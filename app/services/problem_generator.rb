class ProblemGenerator
  # rubyの毎日問題についての一括設定
  def self.generate_daily_ruby_problem
    response = OpenAIClient.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          { role: "system", content: "あなたは問題作成の先生です。" },
          { role: "user", content: "今日のRubyのアルゴリズムの問題を1問出してください。対象レベルはRuby初学者〜中級者向けとし、難しすぎる問題は避けてください。if文、配列、繰り返し処理（each, for）、配列の操作（map, select, sum）などを使って解けるレベルの問題にしてください。
          問題文だけをまず作ってください。そのあと模範解答を別でください。文章は句点（。）ごとに改行してください。
          また、模範解答に使われているメソッドの簡単な説明（どんな働きをするか）と、なぜそのような解き方をしているのかを初心者に向けてわかりやすく解説してください。
          次に、テストコード（RSpecまたはミニマムなassertベースのもの）も出してください。
          さらに、テストコードでで使用したメソッド名をひとつだけ文字列で出してください。
          最後にすべてをJSON形式で、{\"problem\":\"問題文\", \"answer\":\"模範解答\", \"explanation\": \"解説（使っているメソッドや考え方の説明）\, \"test\": \"テストコード\",\"method_name\": \"メソッド名\"}の形で返してください。" }
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
    if parsed && parsed["problem"] && parsed["answer"] && parsed["explanation"] && parsed["test"] && parsed["method_name"]
      problem = Problem.create!(question_text: parsed["problem"])

      ai_answer = AiAnswer.create!(
        problem_id: problem.id,
        answer_text: parsed["answer"],
        explanation: parsed["explanation"],
        test_code: parsed["test"],
        method_name: parsed["method_name"]
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

  # sql用
  def self.generate_daily_sql_problem
    response = OpenAIClient.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          { role: "system", content: "あなたは問題作成の先生です。" },
          { role: "user", content: "今日のsqlの問題を1問出してください。対象レベルはsql初学者〜中級者向けとし、難しすぎる問題は避けてください。
          問題文だけをまず作ってください。そのあと模範解答を別でください。文章は句点（。）ごとに改行してください。
          また、模範解答に使われているメソッドの簡単な説明（どんな働きをするか）と、なぜそのような解き方をしているのかを初心者に向けてわかりやすく解説してください。
          最後にすべてをJSON形式で、{\"problem\":\"問題文\", \"answer\":\"模範解答\", \"explanation\": \"解説（使っているメソッドや考え方の説明）\"}の形で返してください。" }
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
    if parsed && parsed["problem"] && parsed["answer"] && parsed["explanation"]
      problem = Problem.create!(question_text: parsed["problem"])

      ai_answer = AiAnswer.create!(
        problem_id: problem.id,
        answer_text: parsed["answer"],
        explanation: parsed["explanation"]
      )
    else
      # 問題が作られなかった場合の代わりになる
      problem = Problem.create!(
        question_text: "問題が取得できませんでした。"
      )
    end
    return problem
  end
end
