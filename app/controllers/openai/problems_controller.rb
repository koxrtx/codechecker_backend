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

    render :daily
  end

  def answer
    @problem = Problem.new(question_text: params[:question_text])
    @answer = Answer.new(answer_params)
    @ai_answer = "Rubyは柔軟でシンプルな文法を持つオブジェクト指向言語です。" # ← ダミー模範解答

    if @answer.valid?
      render :answer
    else
      render :daily
    end
  end
end

private

# answerだけ許可しないとやばい
def answer_params
  params.require(:answer).permit(:answer_text)
end

