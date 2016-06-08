class AddCountToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :count, :integer
  end
end
