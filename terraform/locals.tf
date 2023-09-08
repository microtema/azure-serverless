locals {
  tags = {
    Project     = var.project
    CostCentre  = "60510"
    Department  = "it"
    Environment = var.env
    Geography   = var.location
    Owner       = "microtema"
  }

  namespace       = "${var.project}-${var.env}-${var.location}-${var.counter}"
  namespace_slug  = "${var.project}_${var.env}_${var.location}_${var.counter}"
  namespace_short = "${var.project}${var.env}${var.location}${var.counter}"
}