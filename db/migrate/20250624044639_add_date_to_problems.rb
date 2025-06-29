class AddDateToProblems < ActiveRecord::Migration[7.2]
  def change
    add_column :problems, :date, :date
  end
end
