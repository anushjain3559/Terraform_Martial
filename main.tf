terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}
# resource "aws_s3_bucket" "example_source" {
#   bucket = var.bucket_name
# }

resource "aws_s3_bucket_policy" "example_source" {
  bucket = var.bucket_name
  policy = <<EOF
{
    "Statement": [
        {
            "Effect": "Allow",
            "Sid": "AllowAppFlowSourceActions",
            "Principal": {
                "Service": "appflow.amazonaws.com"
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts",
                "s3:ListBucketMultipartUploads",
                "s3:GetBucketAcl",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::martialbkttest1",
                "arn:aws:s3:::martialbkttest1/*"
            ]
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_s3_object" "example" {
  bucket = var.bucket_name
  key    = "${var.object_key}${aws_appflow_flow.example.name}//"
  #source = "example_source.csv"
  #kms_key_id = aws_kms_key.examplekms.arn
  #server_side_encryption = "aws:kms"
}

# resource "aws_s3_bucket" "example_destination" {
#   bucket = "demoexampledestination"
# }

# resource "aws_s3_bucket_policy" "example_destination" {
#   bucket = aws_s3_bucket.example_destination.id
#   policy = <<EOF

# {
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Sid": "AllowAppFlowDestinationActions",
#             "Principal": {
#                 "Service": "appflow.amazonaws.com"
#             },
#             "Action": [
# "s3:PutObject",
# "s3:AbortMultipartUpload",
# "s3:ListMultipartUploadParts",
# "s3:ListBucketMultipartUploads",
# "s3:GetBucketAcl",
# "s3:PutObjectAcl"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::example_destination",
#                 "arn:aws:s3:::example_destination/*"
#             ]
#         }
#     ],
#     "Version": "2012-10-17"
# }
# EOF
# }

resource "aws_appflow_flow" "example" {
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
        #        bucket_name = aws_s3_bucket_policy.example_destination.bucket
        bucket_name = var.bucket_name
        s3_output_format_config {
          prefix_config {
            prefix_type = "PATH"
          }
        }
      }
    }
  }

  task {
    #source_fields     = ["Id","IsDeleted","MasterRecordId","Name","Type","ParentId","BillingStreet","BillingCity","BillingState","BillingPostalCode"]
    source_fields = [""]
    #destination_field = ["Id","IsDeleted","MasterRecordId","Name","Type","ParentId","BillingStreet","BillingCity","BillingState","BillingPostalCode"]
    task_type = var.tasktype

    connector_operator {
      salesforce = "NO_OP"
    }
  }

  trigger_config {
    trigger_type = var.trigger_type
  }
}