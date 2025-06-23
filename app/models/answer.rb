class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  belongs_to :category
end
