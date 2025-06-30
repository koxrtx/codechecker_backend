class AddExplanationToAiAnswers < ActiveRecord::Migration[7.2]
  def change
    add_column :ai_answers, :explanation, :text
  end
end
