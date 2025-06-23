class Category < ApplicationRecord
  has_many :answer
  has_many :problem
end
