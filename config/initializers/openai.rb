require "openai"

OpenAIClient = OpenAI::Client.new(
  access_token: ENV.fetch("OPENAI_API_KEY", "dummy")
)
