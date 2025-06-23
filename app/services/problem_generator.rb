class ProblemGenerator
  # 毎日問題についての一括設定
  def self.generate_daily_problem
    response = OpenAIClient.chat.completions.create(
      model: :"gpt-4o-mini",
      messages: [
        { role: "system", content: "あなたは問題作成の先生です。"},
        { role: "user", content: "今日のRubyの問題を1問、問題文だけをまず作ってください。そのあと模範解答を別でください。JSON形式で、{\"problem\":\"問題文\", \"answer\":\"模範解答\"}の形で返してください。"}
      ]
    )
  # AIからの返答を取り出す
  response.to_h.dig("choices", 0, "message", "content")
  end
end