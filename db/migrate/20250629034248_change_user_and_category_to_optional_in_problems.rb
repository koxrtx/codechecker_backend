class ChangeUserAndCategoryToOptionalInProblems < ActiveRecord::Migration[7.2]
  def change
    change_column_null :problems, :user_id, true
    change_column_null :problems, :category_id, true
  end
end
