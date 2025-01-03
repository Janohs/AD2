class StorageService
  def self.client
    @client ||= Supabase::Client.new(
      project_id: ENV["SUPABASE_PROJECT_ID"],
      api_key: ENV["SUPABASE_KEY"]
    )
  end

  def self.upload_receipt(file, filename)
    client.storage
          .from("receipts")  # your bucket name
          .upload(filename, file)
  end

  def self.get_receipt_url(path)
    client.storage
          .from("receipts")  # your bucket name
          .create_signed_url(path, 3600) # URL valid for 1 hour
  end
end
