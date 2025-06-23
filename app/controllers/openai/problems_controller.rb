class Openai::ProblemsController < ApplicationController
  def daily
    begin
      @problem = ProblemGenerator.generate_daily_problem
    rescue OpenAI::Errors::APIConnectionError => e
      puts ("サーバーに接続できませんでした")
      puts (e.cause)
    rescue OpenAI::Errors::RateLimitError => e
      puts ("439 status しばらく待ってください")
    rescue OpenAI::Errors::APIStatusError => e
      puts ("200番台以外のステータスコードが返されました")
      puts (e.status)
    end

    render :daily
  end

  def answer
    @answer = params[:answer]
    render :answer
  end
end
