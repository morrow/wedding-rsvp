class AddShortNameToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :short_name, :string
  end
end
