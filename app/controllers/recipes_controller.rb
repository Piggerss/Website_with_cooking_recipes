class RecipesController < ApplicationController
  def home
    @categories = Category.order(:id)
    @recipes = Recipe.includes(:category).order(created_at: :desc).limit(3)
  end

  def index
    @categories = Category.order(:id)
    @category = @categories.find_by(id: params[:category_id])
    @recipes = Recipe.includes(:category).order(created_at: :desc)
    @recipes = @recipes.where(category_id: params[:category_id]) if params[:category_id].present?
  end

  def show
    @recipe = Recipe.includes(:category).find(params[:id])
  end
end
