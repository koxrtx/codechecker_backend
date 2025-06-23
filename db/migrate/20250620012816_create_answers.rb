class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :problem, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.text :answer_text
      t.boolean :correct
      t.timestamp :answered_at

      t.timestamps
    end
  end
end
