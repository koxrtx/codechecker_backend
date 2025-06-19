class Openai::ProblemsController < ApplicationController
  def daily
    @problem = ProblemGenerator.generate_daily_problem

    render :daily
  end
end
