class Openai::RubyProblemsController < ApplicationController
  def daily
    today = Date.current
    ruby_category = Category.find_by(name: "Ruby")

    # ダミー問題
    #  @problem = Problem.new(
    #  question_text: "これはダミー問題です。RubyでFizzBuzzを出力してください"
    #  )
    #  @answer = Answer.new

    @problem = Problem.find_by(date: today, category: ruby_category)
    if @problem.nil?
      begin
        @problem = ProblemGenerator.generate_daily_ruby_problem
        @problem.date = today
        @problem.category = ruby_category
        @problem.save!
      rescue OpenAI::Error => e
        case e.status
        when 429
          Rails.logger.warn("429 しばらく待ってください")
        when 500..599
          Rails.logger.error("サーバーエラー")
        else
          Rails.logger.error("その他のエラー")
        end
      end
    end

    @ai_answer = @problem.ai_answer
    render :daily
  end

  def answer
    today = Date.current
    category = Category.find_by(name: "Ruby")

    @problem = Problem.find_by(date: today, category: category)
    @answer = Answer.new(answer_params)
    @ai_answer = @problem.ai_answer
    # @ai_answer = "Rubyは柔軟でシンプルな文法を持つオブジェクト指向言語です。" # ← ダミー模範解答

    session[:answer_text] = @answer.answer_text

    if @answer.valid?
      begin
        puts "=== DEBUG: ユーザーコード ==="
        puts @answer.answer_text
        puts "=== DEBUG: テストコード ==="
        puts @ai_answer.test_code.inspect
        # ユーザーのコードとAIのテストコードを評価
        test_result = CodeExecutor.run(@answer.answer_text, @ai_problem.test_code)
        session[:test_result] = test_result
      rescue => e
        # 実行時エラーをセッションに格納しておく
        session[:test_result] = "実行エラー: #{e.message}"
      end

      redirect_to openai_ruby_problem_result_path
    else
      flash[:error] = "回答を入力してください"
      redirect_to openai_ruby_problem_path
    end
  end

  # 再読み込みした時用
  def result
    today = Date.current
    category = Category.find_by(name: "Ruby")

    @problem = Problem.find_by(date: today, category: category)
    @ai_answer = @problem.ai_answer

    # ユーザー回答はセッションから取得
    @answer = Answer.new(answer_text: session[:answer_text])
    @test_result = session[:test_result]
  end
end

  private

  # answerだけ許可しないとやばい
  def answer_params
    params.permit(:answer_text)
  end
