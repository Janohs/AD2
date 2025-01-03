require "aws-sdk-s3"

Aws.config.update({
  region: "ap-southeast-1", # Adjust region if needed
  credentials: Aws::Credentials.new(
    ENV["SUPABASE_KEY"],    # Your Supabase Key
    ENV["SUPABASE_SECRET"]  # Supabase Secret, if available
  ),
  endpoint: "https://jcixfyhrvesbyjtuinxe.supabase.co/storage/v1/s3",  # Supabase S3 endpoint
  force_path_style: true   # This is important for S3-compatible services
})

# Create the S3 client
S3_CLIENT = Aws::S3::Client.new
