class AddMethodNameToAiAnswers < ActiveRecord::Migration[7.2]
  def change
    add_column :ai_answers, :method_name, :string
  end
end
