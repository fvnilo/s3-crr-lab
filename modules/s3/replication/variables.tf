variable "source_bucket" {
  type        = string
  description = "The id of the source bucket."
}

variable "replicate_bucket" {
  type        = string
  description = "The id of the replicate bucket."
}

variable "bidirectional" {
  type        = bool
  description = "Whether replication is bi-directional or not."
}
