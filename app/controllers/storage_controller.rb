require "net/http"
require "json"
require "uri"

class StorageController < ApplicationController
  def test
    uri = URI.parse("https://jcixfyhrvesbyjtuinxe.supabase.co/storage/v1/object/sign/receipts")
    request = Net::HTTP::Get.new(uri)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    files = JSON.parse(response.body)

    if files.any?
      render json: {
        success: true,
        message: "Files fetched successfully",
        files: files
      }
    else
      render json: {
        success: false,
        message: "No files found in the receipts bucket"
      }
    end
  rescue => e
    render json: {
      success: false,
      error: e.message,
      details: e.backtrace.first
    }, status: :internal_server_error
  end
end
