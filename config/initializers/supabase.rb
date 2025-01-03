require "supabase"

SUPABASE_CLIENT = Supabase::Client.new(
  supabase_url: ENV["SUPABASE_URL"],
  supabase_key: ENV["SUPABASE_KEY"]
)

# Make the client available globally
Rails.application.config.supabase = SUPABASE_CLIENT
