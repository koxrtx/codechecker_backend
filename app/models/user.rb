class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }

  # 管理者画面
  enum role: { general: 0, admin: 1 }

  has_many :answers
  has_many :incorrect_answers, -> { where(correct: false) }, class_name: "Answer"
  has_many :incorrect_problems, through: :incorrect_answers, source: :problem
end
