# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPEN_AI_API_SECRET_KEY")
  config.request_timeout = 240
end
