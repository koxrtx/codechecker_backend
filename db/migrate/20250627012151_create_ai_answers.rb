class CreateAiAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :ai_answers do |t|
      t.references :user, foreign_key: true, null: true
      t.references :problem, foreign_key: true, null: false
      t.references :category, foreign_key: true, null: true
      t.text :answer_text, null: false

      t.timestamps
    end
  end
end
