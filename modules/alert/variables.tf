variable "combiner" {
  description = "(required) - How to combine the results of multiple conditions to\ndetermine if an incident should be opened. Possible values: [\"AND\", \"OR\", \"AND_WITH_MATCHING_RESOURCE\"]"
  type        = string
  default     = "OR"
}

variable "enabled" {
  description = "(optional) - Whether or not the policy is enabled. The default is true."
  type        = bool
  default     = true
}

variable "static_envs" {
  description = "lets the user specify a list of environments to create the alert for"
  type        = list(string)
  default     = [""]
}

variable "debug" {
  description = "label used to debug alerts flowing to on-prem pubsub subscribers"
  type        = string
  default     = ""
}
variable "static_envs_alert_route" {
  description = "Used for non-domain cwow program repos if more than one env needs to be specified - like Spanner or GKE"
  type        = list(string)
  default     = [""]
}
variable "unique_webhook" {
  description = "unique google chat webhook"
  default     = ""
  type        = string
}

variable "content" {
  type        = string
  default     = ""
  description = "(optional) - Used for documentation/instructions in the alert policy, metadata can be substantiented in this field as well at alert trigger. Google chat webhook can be placed here as well for alert routing to unique channels."
}


variable "display_name" {
  type        = string
  description = "name of the alert policy"
}
variable "mime_type" {
  type    = string
  default = "text/markdown"
}
variable "notification_email_addresses" {
  type    = list(string)
  default = []
}
variable "monitoring_project_id" {
  type = string
}

variable "channel_type" {
  type    = string
  default = ""
}
variable "domain" {
  description = "(optional) - if applicable, refers to the application domain"
  default     = "default"
}

variable "application" {
  description = "(optional) - refers to the application - cwow|path|p360|etc"
  default     = "cwow"
  type        = string
}

variable "assignment_group" {
  description = "Assignment group in ServiceNow"
  default     = ""
  type        = string
}
variable "alert_route" {
  description = "refers to the alert route, or destination of the alert message. will correspond to a google chat webhook or email address"
  type        = string
  default     = ""
}

variable "pub_sub_notification_channel" {
  description = "the pub sub notification channel that routes alert payloads from google cloud incidents to the alert routing cloud function"
  type        = string
  default     = ""
}

variable "alert_conditions" {
  type    = any
  default = null
}
