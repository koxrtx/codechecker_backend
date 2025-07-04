class Admin::ProblemsController < ApplicationController
  before_action :require_admin

  def index
    @problems = Problem.includes(:category).order(date: :desc)
  end

  def show
    @problem = Problem.find(params[:id])
  end

  def destroy
    @problem = Problem.find(params[:id])
    @problem.destroy
    redirect_to admin_problems_path, notice: "削除しました"
  end

  private

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end