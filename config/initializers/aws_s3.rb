require "aws-sdk-s3"

Aws.config.update(
  region: ENV["AWS_REGION"],
  credentials: Aws::Credentials.new(
    ENV["AWS_ACCESS_KEY_ID"],
    ENV["AWS_SECRET_ACCESS_KEY"]
  )
)

# Initialize the S3 client
S3_CLIENT = Aws::S3::Client.new
