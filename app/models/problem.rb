class Problem < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :incorrect_answers
  has_many :answer
  has_many :ai_answers
end
