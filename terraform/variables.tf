variable "project" {
  type        = string
  description = "Project name"
  default     = "microtema"
}

variable "env" {
  type        = string
  description = "Environment (dev / stage / prod)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region to deploy module to"
  default     = "westeurope"
}

variable "counter" {
  type        = string
  description = "Counter for resources"
  default     = "01"
}