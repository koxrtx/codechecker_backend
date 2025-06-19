class CreateProblems < ActiveRecord::Migration[7.2]
  def change
    create_table :problems do |t|
      t.integer :user_id
      t.integer :category_id
      t.text :question_text

      t.timestamps
    end
  end
end
