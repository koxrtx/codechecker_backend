class AiAnswer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :problem
  belongs_to :category, optional: true

  validates :answer_text, presence: true
end