class Article < ApplicationRecord
  validates :title, :body, presence: true
  belongs_to :author, class_name: 'User'
  scope :city, -> (city_id) { where city_id: city_id }
end
