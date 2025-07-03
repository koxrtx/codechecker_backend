class AddTestCodeToAiAnswers < ActiveRecord::Migration[7.2]
  def change
    add_column :ai_answers, :test_code, :text
  end
end
