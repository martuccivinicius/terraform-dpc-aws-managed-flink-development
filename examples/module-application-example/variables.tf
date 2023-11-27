variable "tags" {
  description = "A map of tags to apply to all the resources deployed"
  type        = map(any)
  default     = { "caylent:Owner" : "vinicius.martucci@caylent.com" }
}