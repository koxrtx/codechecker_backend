require "openai"
require "bundler/setup"

OpenAIClient = OpenAI::Client.new(
  api_key: ENV.fetch("OPENAI_API_KEY")
)
