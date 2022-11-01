terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"  #Terraform version
}

#Terraform provider Declaration
provider "aws" {                
  region = var.region
}

#Definiing aws_s3 object
resource "aws_s3_object" "s3object" {
  bucket = var.bucket_name
  key    = "${var.object_key}${aws_appflow_flow.s3appflow.name}//"
}
resource "aws_s3_bucket_policy" "example_destination" {
   bucket = var.bucket_name
   policy = <<EOF
 {
     "Statement": [
         {
             "Effect": "Allow",
             "Sid": "AllowAppFlowDestinationActions",
             "Principal": {
                 "Service": "appflow.amazonaws.com"
             },
             "Action": [
                 "s3:PutObject",
                 "s3:AbortMultipartUpload",
                 "s3:ListMultipartUploadParts",
                 "s3:ListBucketMultipartUploads",
                 "s3:GetBucketAcl",
                 "s3:PutObjectAcl"
             ],
             "Resource": [
                 "arn:aws:s3:::gilead-kdh-tst-us-west-2-raw",
                 "arn:aws:s3:::gilead-kdh-tst-us-west-2-raw/*"
             ]
         }
     ],
     "Version": "2012-10-17"
 }
 EOF
}
#Creating AppFlow
resource "aws_appflow_flow" "s3appflow" {
  name = "${var.appflowname}-${var.nametype}_${var.objectsname}"
  source_flow_config {
    connector_type         = var.source_connector_type
    connector_profile_name = var.source_connector_profile_name
    source_connector_properties {
      salesforce {
        object = var.source_connector_object
      }
    }
  }

  destination_flow_config {
    connector_type = var.destination_connector_type
    destination_connector_properties {
      s3 {
        bucket_name = var.bucket_name
        s3_output_format_config {
          file_type = "CSV"
          aggregation_config {
            aggregation_type = "SingleFile"
          }
          prefix_config {
            prefix_type = "PATH"
          }
        }
      }
    }
  }

  task {
    source_fields = [""]
    task_type = var.tasktype
    connector_operator {
      salesforce = "NO_OP"
    }
  }

  trigger_config {
    trigger_type = var.trigger_type
  }
}
