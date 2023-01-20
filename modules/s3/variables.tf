variable "bucket_name" {
  type        = string
  description = "The name of the bucket to create."
}

variable "enable_replication" {
  type        = bool
  description = "Whether replication is enabled or not."

  default = false
}

variable "bidirectional_replication" {
  type        = bool
  description = "Whether replication is bi-directional or not."

  default = false
}
