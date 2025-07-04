class AiAnswerChecker
  def self.check(user_code:, ai_problem:, ai_answer:)
    client = OpenAIClient 

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

            ### 判定方法
            ユーザーコードが問題の要件を満たしているかを判断してください。
            ただし模範解答とコードの違いにこだわらず、コードの動作で判断してください。
            必要なら以下のようなテストケースで実行した結果を参考にしてください。

            ### 出力フォーマット
            以下のJSON形式のみを返してください。説明は不要です。

            {"verdict": "success"} または {"verdict": "fail"}
            MSG
          }
        ],
        temperature: 0.2
      }
    )

    content = response.to_h.dig("choices", 0, "message", "content")
    puts "=== AIからの返答 ==="
    puts content

    begin
      JSON.parse(content)
    rescue JSON::ParserError
      { "verdict" => "fail" }
    end
  end
end