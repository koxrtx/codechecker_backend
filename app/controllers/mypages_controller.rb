class MypagesController < ApplicationController
  def incorrect_answers
    @incorrect_problems = current_user.incorrect_problems.distinct
  end
end