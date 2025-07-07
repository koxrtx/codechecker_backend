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

    # 「取得済みだけど失敗してる問題」は除外する
    if @problem.nil? || @problem.question_text&.include?("問題が取得できませんでした。")
      begin
        @problem = ProblemGenerator.generate_daily_ruby_problem

      if @problem.nil?
        Rails.logger.error("ProblemGeneratorがnilを返しました")
        flash[:error] = "問題の生成に失敗しました"
        return render :daily
      end

      @problem.date = today
      @problem.category = ruby_category
      @problem.save!
    rescue OpenAI::Error => e
      Rails.logger.error("OpenAIエラー: #{e.class} - #{e.message}")
      flash[:error] = "AI問題の取得に失敗しました（#{e.message}）"
      return render :daily
    end
  end

    # ログの確認
    Rails.logger.debug "今日のRuby問題: #{@problem.inspect}"
    Rails.logger.debug "AIの模範解答: #{@problem.ai_answer.inspect}"

    @ai_answer = @problem.ai_answer
    render :daily
  end

  def answer
    today = Date.current
    category = Category.find_by(name: "Ruby")

    @problem = Problem.find_by(id: params[:problem_id])
    @answer = Answer.new(answer_params)
    @answer.user = current_user if current_user
    @answer.problem = @problem
    @answer.category = category
    @ai_answer = @problem.ai_answer

    session[:answer_text] = @answer.answer_text
    session[:problem_id] = @problem.id

    if @answer.valid?
      # AIによる判定処理だけ
      result = AiAnswerChecker.check(
        user_code: @answer.answer_text,
        ai_problem: @problem.question_text,
        ai_answer: @ai_answer.answer_text
      )
    session[:verdict] = result["verdict"]

    @answer.correct = (result["verdict"] == "correct")
    @answer.answered_at = Time.current

    # DBに保存する
    @answer.save!

    redirect_to openai_ruby_problem_result_path
    else
      flash[:error] = "回答を入力してください"
      redirect_to openai_ruby_problem_path
    end
  end

  # 再読み込みした時用

  def result
    @problem = Problem.find_by(id: session[:problem_id])
    @ai_answer = @problem&.ai_answer

    @answer = Answer.new(answer_text: session[:answer_text])
    @verdict = session[:verdict]

    if @problem.nil? || @problem.question_text&.include?("問題が取得できませんでした。")
      flash[:error] = "問題情報が正しく取得できませんでした。"
      redirect_to openai_ruby_problem_path
    end
  end


  private

  # answerだけ許可しないとやばい
  def answer_params
    params.permit(:answer_text)
  end

end
