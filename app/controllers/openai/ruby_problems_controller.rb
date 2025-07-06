class Openai::RubyProblemsController < ApplicationController
  def daily
    today = Date.current
    ruby_category = Category.find_or_create_by!(name: "Ruby")

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

    # ログの確認
    Rails.logger.debug "🎯 今日のRuby問題: #{@problem.inspect}"
    Rails.logger.debug "🧠 AIの模範解答: #{@problem.ai_answer.inspect}"

    @ai_answer = @problem.ai_answer
    render :daily
  end

  def answer
    today = Date.current
    category = Category.find_by(name: "Ruby")

    @problem = Problem.find_by(date: today, category: category)
    @answer = Answer.new(answer_params)
    @ai_answer = @problem.ai_answer

    session[:answer_text] = @answer.answer_text

    if @answer.valid?
      # AIによる判定処理だけ
      result = AiAnswerChecker.check(
        user_code: @answer.answer_text,
        ai_problem: @problem.question_text,
        ai_answer: @ai_answer.answer_text
      )
    session[:verdict] = result["verdict"]

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
    @verdict = session[:verdict]
  end
end

  private

  # answerだけ許可しないとやばい
  def answer_params
    params.permit(:answer_text)
  end
