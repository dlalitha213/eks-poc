
resource "aws_ecr_repository" "this" {
  name = var.name
  image_scanning_configuration { scan_on_push = true }
  encryption_configuration { encryption_type = "AES256" }
}

output "repository_url" { value = aws_ecr_repository.this.repository_url }
output "repository_id" { value = aws_ecr_repository.this.id }
