# // s3 bucket

# resource "aws_s3_bucket" "artifact_store" {
#   bucket = "${var.bucket_name}-${var.git_branch}" // substr is use in all intances bc of the _
#   acl    = "private"
# }

# // codepipeline rol

# resource "aws_iam_role" "codepipeline_role" {
#   name = "${var.pipeline_name}-rol-${var.git_branch}"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "codepipeline.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# // in the future is best to follow least privilege principle, but this is just for testing so its fine

# resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = aws_iam_role.codepipeline_role.name
# }

# // codepipeline

# /*after terraform code is run, the pipeline will fail since the CodeStar Connection you made isn’t available
# to finish the creation of the pipeline you need to go to your pipeline, then settings, connections, 
# then select the connection with status pending, Then select “Update pending connection”
# Another screen will pop up. Select “Install a new app”, Next, click on your GitHub account and then select
# the repository, or repositories you want the AWS Connector to have access to.(im selecting the app and
# infra repo at this time), Click “save”, Next you will come back to the “Connect to GitHub” screen. Hit “Connect”
# if everything went well it should display status available in the connection, this needs to be done one
# time per pipeline*/

# resource "aws_codestarconnections_connection" "github_codepipeline" {
#   name          = "${var.git_branch}-${var.pipeline_name}-con"
#   provider_type = "GitHub"
# }

# resource "aws_codepipeline" "this" {
#   name     = "${var.pipeline_name}-${var.git_branch}"
#   role_arn = aws_iam_role.codepipeline_role.arn

#   artifact_store {
#     location = aws_s3_bucket.artifact_store.bucket
#     type     = "S3"
#   }

#   stage {
#     name = "Source"

#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "AWS"
#       provider         = "CodeStarSourceConnection"
#       version          = "1"
#       output_artifacts = ["source_output"]

#       configuration = {
#         ConnectionArn = aws_codestarconnections_connection.github_codepipeline.arn
#         FullRepositoryId = "${var.git_user}/${var.git_repo}"
#         BranchName = var.git_branch // carefull not short it here
#       }
#     }
#   }

#   stage {
#     name = "Build"

#     action {
#       name             = "Build"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       version          = "1"
#       input_artifacts  = ["source_output"]
#       output_artifacts = ["build_output"]

#       configuration = {
#         ProjectName = aws_codebuild_project.this.name
#       }
#     }
#   }

#   stage {
#     name = "Manual_Approval"
#     action {
#       name     = "Manual-Approval"
#       category = "Approval"
#       owner    = "AWS"
#       provider = "Manual"
#       version  = "1"
#     }
#   }

# }


# // codebuild rol

# resource "aws_iam_role" "codebuild_role" {
#   name = "${var.codebuild_project_name}-rol-${var.git_branch}"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "codebuild.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# // in the future is best to follow least privilege principle, but this is just for testing so its fine
# resource "aws_iam_role_policy_attachment" "codebuild_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = aws_iam_role.codebuild_role.name
# }

# // codebuild

# // create a secret name git-personal-credentials

# data "aws_secretsmanager_secret" "git-credentials" {
#   name = "git-personal-credentials"
# }

# data "aws_secretsmanager_secret_version" "git-credentials" {
#   secret_id = data.aws_secretsmanager_secret.git-credentials.id
# }

# resource "aws_codebuild_project" "this" {
#   name          = "${var.codebuild_project_name}-${var.git_branch}"
#   description   = "My CodeBuild project for building and pushing Docker images"
#   build_timeout = "5"
#   service_role  = aws_iam_role.codebuild_role.arn

#   artifacts {
#     type = "CODEPIPELINE"
#   }

#   environment {
#     compute_type                = "BUILD_GENERAL1_SMALL"
#     image                       = "aws/codebuild/standard:3.0"
#     type                        = "LINUX_CONTAINER"
#     privileged_mode             = true
#     image_pull_credentials_type = "CODEBUILD"

#     environment_variable {
#       name  = "FRONTEND"
#       value = var.frontend_repo # 438555236323.dkr.ecr.us-east-1.amazonaws.com/ecs_frontend
#     }

#     environment_variable {
#       name  = "GIT_USER_EMAIL"
#       value = jsondecode(data.aws_secretsmanager_secret_version.git-credentials.secret_string)["git_email"]
#     }

#     environment_variable {
#       name  = "GIT_USER_NAME"
#       value = jsondecode(data.aws_secretsmanager_secret_version.git-credentials.secret_string)["git_user"]
#     }

#     environment_variable {
#       name  = "GITHUB_TOKEN"
#       value = jsondecode(data.aws_secretsmanager_secret_version.git-credentials.secret_string)["github_token"]
#     }

#     environment_variable {
#       name  = "REPO_NAME"
#       value = var.git_repo # "testmernapp"
#     }
#     # Add other environment variables if necessary
#   }

#   source {
#     type            = "CODEPIPELINE"
#     buildspec       = var.buildspec_file
#     git_clone_depth = 1
#   }

  
# }