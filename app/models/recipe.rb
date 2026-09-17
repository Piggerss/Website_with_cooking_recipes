class Recipe < ApplicationRecord
  belongs_to :category

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, :description, :category, :cooking_time, :difficulty, :instructions, presence: true
  validates :cooking_time, numericality: { only_integer: true, greater_than: 0 }
end
