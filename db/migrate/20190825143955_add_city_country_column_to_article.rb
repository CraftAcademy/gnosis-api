class AddCityCountryColumnToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :country, :string
    add_column :articles, :city, :string
  end
end
