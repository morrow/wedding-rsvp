class AddSlugToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :slug, :string
  end
end
