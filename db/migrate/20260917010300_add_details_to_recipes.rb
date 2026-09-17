class AddDetailsToRecipes < ActiveRecord::Migration[8.1]
  def change
    add_column :recipes, :cooking_time, :integer, null: false
    add_column :recipes, :difficulty, :string, null: false
    add_column :recipes, :image_url, :string
    add_column :recipes, :instructions, :text, null: false
  end
end
