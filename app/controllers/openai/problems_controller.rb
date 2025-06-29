class Openai::ProblemsController < ApplicationController
  def daily
    today = Date.current

    # ダミー問題
  #  @problem = Problem.new(
  #  question_text: "これはダミー問題です。RubyでFizzBuzzを出力してください"
  #  )
  #  @answer = Answer.new

    @problem = Problem.find_by(date: today)
    if @problem.nil?
      begin
        @problem = ProblemGenerator.generate_daily_problem
        @problem.date = today
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

    @problem = Problem.find_by(date: today)
    @answer = Answer.new(answer_params)
    @ai_answer = @problem.ai_answer
#  @ai_answer = "Rubyは柔軟でシンプルな文法を持つオブジェクト指向言語です。" # ← ダミー模範解答
    
    session[:answer_text] = @answer.answer_text

    if @answer.valid?
      redirect_to problem_result_path
    else
      flash[:error] = '回答を入力してください'
      redirect_to problem_daily_path
    end
  end

  # 再読み込みした時用
  def result
  today = Date.current
  @problem = Problem.find_by(date: today)
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

