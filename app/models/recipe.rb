class Recipe < ApplicationRecord
  belongs_to :category

  validates :title, :description, :category, :cooking_time, :difficulty, :instructions, presence: true
  validates :cooking_time, numericality: { only_integer: true, greater_than: 0 }
end
