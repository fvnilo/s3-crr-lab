variable "bucket_name" {
  type        = string
  description = "The name of the bucket to create."
}

variable "tags" {
  type        = map(string)
  description = "Tags to add to the bucket."

  default = {}
}
