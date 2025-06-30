class Problem < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  has_many :incorrect_answers
  has_many :answers
  has_one :ai_answer
end
