class ReceiptsController < ApplicationController
  def create
    file = params[:receipt]
    filename = "#{SecureRandom.uuid}_#{file.original_filename}"

    begin
      result = StorageService.upload_receipt(file, filename)
      # Save the file path or URL to your database if needed
      render json: { success: true, path: result["Key"] }
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def show
    receipt = Receipt.find(params[:id]) # Assuming you have a Receipt model
    signed_url = StorageService.get_receipt_url(receipt.file_path)
    render json: { url: signed_url }
  end
end
