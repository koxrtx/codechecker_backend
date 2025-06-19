class Problem < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :answers
  has_many :ai_answers
  has_many :incorrect_answers
end
