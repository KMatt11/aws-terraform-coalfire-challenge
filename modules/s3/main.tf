# s3 main.tf

data "aws_iam_policy_document" "coalfire_ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# s3 bucket without acl argument
resource "aws_s3_bucket" "coalfire_project_bucket" {
  bucket = "${var.project_name}-bucket"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = var.environment
  }
}

# public access block for s3
resource "aws_s3_bucket_public_access_block" "coalfire_project" {
  bucket = aws_s3_bucket.coalfire_project_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# images, archive and logs folders
resource "aws_s3_object" "coalfire_images_folder" {
  bucket = aws_s3_bucket.coalfire_project_bucket.bucket
  key    = "images/"
  source = "/dev/null"

  depends_on = [aws_s3_bucket.coalfire_project_bucket]
}

resource "aws_s3_object" "coalfire_archive_folder" {
  bucket = aws_s3_bucket.coalfire_project_bucket.bucket
  key    = "images/archive/"
  source = "/dev/null"

  depends_on = [aws_s3_bucket.coalfire_project_bucket]
}

resource "aws_s3_object" "coalfire_logs_folder" {
  bucket = aws_s3_bucket.coalfire_project_bucket.bucket
  key    = "logs/"
  source = "/dev/null"

  depends_on = [aws_s3_bucket.coalfire_project_bucket]
}

# lifecycle configuration for s3 bucket
resource "aws_s3_bucket_lifecycle_configuration" "coalfire_project_lifecycle" {
  bucket = aws_s3_bucket.coalfire_project_bucket.id

  # move objects in the memes folder after 90 days
  rule {
    id     = "Move-Memes-to-Glacier"
    status = "Enabled"

    filter {
      prefix = "images/memes/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  # move objects in the active folder after 90 days
  rule {
    id     = "Move-Active-to-Glacier"
    status = "Enabled"

    filter {
      prefix = "logs/active/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  # delete objects in the inactive folder after 90 days
  rule {
    id     = "Delete-Inactive"
    status = "Enabled"

    filter {
      prefix = "logs/inactive/"
    }

    expiration {
      days = 90
    }
  }
}

# IAM policy for write access to logs bucket
resource "aws_iam_policy" "coalfire_write_logs_policy" {
  name        = "${var.project_name}-write-logs-policy"
  description = "Policy to allow EC2 instances to write to logs bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:PutObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.coalfire_project_bucket.arn}/logs/*"
      }
    ]
  })
}

# IAM role for logs write access
resource "aws_iam_role" "coalfire_ec2_write_logs_role" {
  name               = "${var.project_name}-ec2-write-logs-role"
assume_role_policy = data.aws_iam_policy_document.coalfire_ec2_assume_role.json
}

# IAM policy for logs write role
resource "aws_iam_policy_attachment" "coalfire_ec2_write_logs_attach" {
  name       = "${var.project_name}-ec2-write-logs-attach"
  roles      = [aws_iam_role.coalfire_ec2_write_logs_role.name]
  policy_arn = aws_iam_policy.coalfire_write_logs_policy.arn
}

# profile for ec2
resource "aws_iam_instance_profile" "coalfire_ec2_instance_profile" {
  name = "${var.project_name}-ec2-instance-profile"
  role = aws_iam_role.coalfire_ec2_write_logs_role.name
}
