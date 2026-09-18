require "test_helper"

class Admin::RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    post login_url, params: { login: "admin", password: "admin" }
  end

  test "new recipe form renders all required fields" do
    Category.create!(name: "Супы")

    get new_admin_recipe_url

    assert_response :success
    assert_select "h1", text: "Добавить рецепт"
    assert_select "label[for='recipe_title']", text: "Название"
    assert_select "select[name='recipe[category_id]'][required]"
    assert_select "textarea[name='ingredients_text']"
    assert_select "input[type='submit'][value='Сохранить рецепт']"
  end

  test "create saves a recipe and its ingredients" do
    category = Category.create!(name: "Супы")

    assert_difference("Recipe.count", 1) do
      post admin_recipes_url, params: {
        recipe: {
          title: "Тестовый суп",
          category_id: category.id,
          cooking_time: 30,
          difficulty: "Легко",
          image_url: "/images/recipes/vegetable-soup.png",
          description: "Описание тестового рецепта.",
          instructions: "Первый шаг."
        },
        ingredients_text: "Картофель - 2 шт."
      }
    end

    assert_redirected_to admin_recipes_url
    recipe = Recipe.find_by!(title: "Тестовый суп")
    assert_equal [ "Картофель" ], recipe.ingredients.pluck(:name)
    assert_equal [ "2 шт." ], recipe.recipe_ingredients.pluck(:quantity)
  end

  test "admin list shows the supported recipe actions" do
    category = Category.create!(name: "Супы")
    Recipe.create!(
      title: "Овощной суп",
      category: category,
      cooking_time: 40,
      difficulty: "Легко",
      description: "Проверенный рецепт на каждый день.",
      instructions: "Подготовьте ингредиенты."
    )

    get admin_recipes_url

    assert_response :success
    assert_select "h1", text: "Админка — рецепты"
    assert_select "a[href='#{new_admin_recipe_path}']", text: "Добавить рецепт"
    assert_select "button", text: "Удалить"
  end

  test "destroy removes a recipe and redirects to the admin list" do
    category = Category.create!(name: "Супы")
    recipe = Recipe.create!(
      title: "Рецепт для удаления",
      category: category,
      cooking_time: 20,
      difficulty: "Легко",
      description: "Тестовый рецепт.",
      instructions: "Тестовый шаг."
    )

    assert_difference("Recipe.count", -1) do
      delete admin_recipe_url(recipe)
    end

    assert_redirected_to admin_recipes_url
  end
end
