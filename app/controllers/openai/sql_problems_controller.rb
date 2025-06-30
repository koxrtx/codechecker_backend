class Openai::SqlProblemsController < ApplicationController
  def daily
    today = Date.current
    sql_category = Category.find_by(name: "SQL")

    @problem = Problem.find_by(date: today, category: sql_category)
    if @problem.nil?
      begin
        @problem = ProblemGenerator.generate_daily_sql_problem
        @problem.date = today
        @problem.category = sql_category
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
    category = Category.find_by(name: "SQL")

    @problem = Problem.find_by(date: today, category: category)
    @answer = Answer.new(answer_params)
    @ai_answer = @problem.ai_answer

    session[:answer_text] = @answer.answer_text

    if @answer.valid?
      redirect_to openai_sql_problem_result_path
    else
      flash[:error] = "回答を入力してください"
      redirect_to openai_sql_problem_path
    end
  end

  # 再読み込みした時用
  def result
    today = Date.current
    category = Category.find_by(name: "SQL")

    @problem = Problem.find_by(date: today, category: category)
    @ai_answer = @problem.ai_answer

    # ユーザー回答はセッションから取得
    @answer = Answer.new(answer_text: session[:answer_text])
  end
end

  private

  # answerだけ許可しないとやばい
  def answer_params
    params.permit(:answer_text)
  end
