class AddCityIdToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :city_id, :string
  end
end
