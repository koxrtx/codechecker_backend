class ProblemGenerator
  # 毎日問題についての一括設定
  def self.generate_daily_problem
    response = OpenAIClient.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          { role: "system", content: "あなたは問題作成の先生です。" },
          { role: "user", content: "今日のRubyのアルゴリズムの問題を1問出してください。対象レベルはRuby初学者〜中級者向けとし、難しすぎる問題は避けてください。if文、配列、繰り返し処理（each, for）、配列の操作（map, select, sum）などを使って解けるレベルの問題にしてください。
          問題文だけをまず作ってください。そのあと模範解答を別でください。文章は句点（。）ごとに改行してください。JSON形式で、{\"problem\":\"問題文\", \"answer\":\"模範解答\"}の形で返してください。" }
        ]
      }
    )
    # AIからの返答を取り出す
    content = response.to_h.dig("choices", 0, "message", "content")

    # 受け取ったJSONをハッシュに変換する
    parsed = nil
    begin
      parsed = JSON.parse(content)
    rescue
      JSON::ParserError
    end

    # ハッシュにした問題・回答があるか確認する
    problem = nil
    if parsed && parsed["problem"] && parsed["answer"]
      problem = Problem.create!(question_text:parsed["problem"])

      ai_answer = AiAnswer.create!(
        problem_id: problem.id,
        answer_text: parsed["answer"]
      )
    else
      # 問題が作られなかった場合の代わりになる
      problem = Problem.create!(
        question_text: "問題が取得できませんでした。"
      )
    end
    return problem

  # ダミー問題
  # problem = Problem.new(
  #  question_text: "これはダミー問題です。RubyでFizzBuzzを出力してください",
  #  answer: "1から100までの数字をループし、3で割り切れる時はFizz、5で割り切れる時はBuzz、両方ならFizzBuzzと表示。"
  # )

  # return problem
  end
end