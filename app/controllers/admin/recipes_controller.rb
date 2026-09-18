class Admin::RecipesController < ApplicationController
  before_action :require_admin
  before_action :set_categories, only: %i[new create]

  def index
    @recipes = Recipe.includes(:category).order(created_at: :desc)
  end

  def new
    @recipe = Recipe.new
    @ingredients_text = ""
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @ingredients_text = params[:ingredients_text].to_s

    ActiveRecord::Base.transaction do
      @recipe.save!
      create_ingredients
    end

    redirect_to admin_recipes_path
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_content
  end

  def destroy
    Recipe.find(params[:id]).destroy
    redirect_to admin_recipes_path
  end

  private

  def set_categories
    @categories = Category.order(:id)
  end

  def recipe_params
    params.require(:recipe).permit(:title, :category_id, :cooking_time, :difficulty, :image_url, :description, :instructions)
  end

  def create_ingredients
    @ingredients_text.each_line do |line|
      next if line.strip.blank?

      name, quantity = line.split(/\s+[—–-]\s+/, 2).map { |value| value&.strip }
      unless name.present? && quantity.present?
        @recipe.errors.add(:base, "Укажите ингредиент в формате «Название — количество».")
        raise ActiveRecord::RecordInvalid, @recipe
      end

      ingredient = Ingredient.find_or_create_by!(name: name)
      @recipe.recipe_ingredients.create!(ingredient: ingredient, quantity: quantity)
    end
  end
end
