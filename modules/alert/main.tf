# modules for alert policy
resource "google_monitoring_alert_policy" "alert_policy" {
  enabled      = var.enabled
  count        = var.static_envs != [""] ? length(var.static_envs) : 1
  project      = var.monitoring_project_id
  display_name = var.static_envs == [] ? var.display_name : tostring("${var.display_name} ${var.static_envs[count.index]}")
  combiner     = var.combiner

  documentation {
    content   = var.alert_route == "unique_webhook" ? "${var.content}\n${var.unique_webhook}" : var.content
    mime_type = var.mime_type
  }

  dynamic "conditions" {
    for_each = local.alert_conditions
    content {
      condition_threshold {
        aggregations {
          alignment_period     = conditions.value.alignment_period
          cross_series_reducer = conditions.value.cross_series_reducer
          per_series_aligner   = conditions.value.per_series_aligner
          group_by_fields      = conditions.value.group_by_fields
        }
        comparison      = conditions.value.comparison
        duration        = conditions.value.duration
        filter          = conditions.value.filter
        threshold_value = conditions.value.threshold_value
        trigger {
          count   = conditions.value.count
          percent = conditions.value.percent
        }
      }
      display_name = conditions.value.display_name
    }
  }
  user_labels = {
    "domain"           = var.domain
    "application"      = var.application
    "channel_type"     = var.channel_type
    "alert_route"      = var.static_envs == [] ? var.static_envs_alert_route[count.index] : var.alert_route
    "debug"            = var.debug
    "assignment_group" = var.assignment_group
  }
  notification_channels = var.notification_email_addresses != "" && var.pub_sub_notification_channel == "" ? flatten([local.notification_object_email]) : (
    var.pub_sub_notification_channel != "" && var.notification_email_addresses == "" ? [var.pub_sub_notification_channel] : flatten([local.notification_object_email, var.pub_sub_notification_channel])
  )
}

resource "google_monitoring_notification_channel" "email_channel" {
  count        = length(local.email_list)
  display_name = "${local.email_list[count.index]}-${random_string.random.result}"
  type         = "email"
  project      = var.monitoring_project_id
  labels = {
    email_address = local.email_list[count.index]
  }
}

locals {
  notification_object_email = var.channel_type == "email" ? [for i in google_monitoring_notification_channel.email_channel : i.name] : []
  email_list                = var.channel_type == "email" ? var.notification_email_addresses : []
  alert_conditions = flatten([
    for condition in var.alert_conditions : {
      alignment_period     = tostring(try(condition.alignment_period, "900s"))
      cross_series_reducer = tostring(try(condition.cross_series_reducer, "REDUCE_MAX"))
      per_series_aligner   = tostring(try(condition.per_series_aligner, "ALIGN_MEAN"))
      group_by_fields      = tolist(try(condition.group_by_fields, ["resource.project_id"]))
      duration             = tostring(try(condition.duration, "300s"))
      count                = tostring(try(condition.threshold_count, 0))
      percent              = tostring(try(condition.threshold_percent, 0))
      threshold_value      = tostring(try(condition.threshold_value, 0))
      comparison           = tostring(try(condition.comparison, "COMPARISON_GT"))
      filter               = condition.filter
      display_name         = condition.condition_display_name
  }])
}

resource "random_string" "random" {
  length  = 4
  upper   = false
  special = false
}
