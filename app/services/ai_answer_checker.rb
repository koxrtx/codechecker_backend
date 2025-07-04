class AiAnswerChecker
  def self.check(user_code:, ai_problem:, ai_answer:)
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          {
            role: "system",
            content: "あなたはRuby学習アプリの判定AIです。"
          },
          {
            role: "user",
            content: <<~MSG
              ### 問題
              #{ai_problem}

              ### 模範解答
              #{ai_answer}

              ### ユーザーのコード
              #{user_code}

              ### 出力フォーマット
              - verdict: 'success' または 'fail' のどちらかのみ
            MSG
          }
        ],
        temperature: 0.2
      }
    )

    content = response.to_h.dig("choices", 0, "message", "content")

    begin
      JSON.parse(content)
    rescue JSON::ParserError
      { "verdict" => "fail" }
    end
  end
end