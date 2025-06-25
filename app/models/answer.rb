class Answer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :problem, optional: true
  belongs_to :category, optional: true

  validates :answer_text, presence: true
end
