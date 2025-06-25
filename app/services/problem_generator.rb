class ProblemGenerator
  # 毎日問題についての一括設定
  def self.generate_daily_problem
  #  response = OpenAIClient.chat(
  #    parameters: {
  #      model: "gpt-4o",
  #      messages: [
  #        { role: "system", content: "あなたは問題作成の先生です。" },
  #        { role: "user", content: "今日のRubyのアルゴリズムの問題を1問、問題文だけをまず作ってください。そのあと模範解答を別でください。JSON形式で、{\"problem\":\"問題文\", \"answer\":\"模範解答\"}の形で返してください。" }
  #      ]
  #    }
  #  )
  # AIからの返答を取り出す
  #response.to_h.dig("choices", 0, "message", "content")
  # ダミー問題
  problem = Problem.new(
    question_text: "これはダミー問題です。RubyでFizzBuzzを出力してください",
    answer: "1から100までの数字をループし、3で割り切れる時はFizz、5で割り切れる時はBuzz、両方ならFizzBuzzと表示。"
  )

  return problem
  end
end