class Problem < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :incorrect_answers
  has_many :answers
  has_many :ai_answers
end
