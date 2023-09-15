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

variable "failover_location" {
  default = "northeurope"
}

variable "counter" {
  type        = string
  description = "Counter for resources"
  default     = "01"
}

variable "commit_id" {
  type        = string
  description = "Git commit id in short form"
  default     = "01"
}

variable "branch" {
  type        = string
  description = "current branch"
  default     = "1.0.0-SNAPSHOT"
}