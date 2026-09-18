require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @soups = Category.create!(name: "Супы")
    @breakfasts = Category.create!(name: "Завтраки")
    @baking = Category.create!(name: "Выпечка")

    @vegetable_soup = create_recipe(title: "Овощной суп", category: @soups, created_at: 4.days.ago)
    @chicken_soup = create_recipe(title: "Куриный суп", category: @soups, created_at: 3.days.ago)
    @syrniki = create_recipe(title: "Сырники", category: @breakfasts, created_at: 2.days.ago)
    @apple_pie = create_recipe(title: "Яблочный пирог", category: @baking, created_at: 1.day.ago)
  end

  test "home shows category links and the three latest recipes" do
    get root_url

    assert_response :success
    assert_select ".category-panel a[href='#{recipes_path(category_id: @soups.id)}']", text: "Супы"
    assert_select ".category-panel a[href='#{recipes_path(category_id: @breakfasts.id)}']", text: "Завтраки"
    assert_select ".category-panel a[href='#{recipes_path(category_id: @baking.id)}']", text: "Выпечка"
    assert_select ".recipe-card", count: 3
  end

  test "catalog filters recipes by category and highlights the active category" do
    get recipes_url(category_id: @soups.id)

    assert_response :success
    assert_select ".filter-button--active", text: "Супы"
    assert_select ".recipe-card", text: /Овощной суп/
    assert_select ".recipe-card", text: /Куриный суп/
    assert_select ".recipe-card", text: /Сырники/, count: 0
  end

  test "catalog without a category shows all recipes and no active filter" do
    get recipes_url

    assert_response :success
    assert_select ".filter-button--active", count: 0
    assert_select ".recipe-card", count: 4
  end

  test "recipe page shows a breadcrumb and recipe details" do
    ingredient = Ingredient.create!(name: "Картофель")
    RecipeIngredient.create!(recipe: @vegetable_soup, ingredient: ingredient, quantity: "3 шт.")

    get recipe_url(@vegetable_soup)

    assert_response :success
    assert_select "h1", text: "Овощной суп"
    assert_select ".ingredients-list", text: /Картофель/
  end

  private

  def create_recipe(title:, category:, created_at:)
    Recipe.create!(
      title: title,
      category: category,
      cooking_time: 40,
      difficulty: "Легко",
      image_url: "/images/recipes/vegetable-soup.png",
      description: "Проверенный рецепт на каждый день.",
      instructions: "Подготовьте ингредиенты.\nПриготовьте блюдо.",
      created_at: created_at,
      updated_at: created_at
    )
  end
end
