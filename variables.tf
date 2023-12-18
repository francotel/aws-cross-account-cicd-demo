variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
  default     = "demo-bucket-hash" # Cambia por el nombre deseado
}

variable "bucket_region" {
  description = "Región del bucket S3"
  type        = string
  default     = "us-east-1" # Cambia por la región deseada
}