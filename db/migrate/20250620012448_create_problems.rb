class CreateProblems < ActiveRecord::Migration[7.2]
  def change
    create_table :problems do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.text :question_text

      t.timestamps
    end
  end
end
