class User < ActiveRecord::Base
  extend Devise::Models
  after_initialize :set_default_role, if: :new_record?

  enum role: { university: 0, research_group: 1, reader: 2 }

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :registration_keys
  has_many :articles

  has_many :research_groups, class_name: "User", foreign_key: "university_id"

  belongs_to :university, class_name: "User", optional: true

  private

  def set_default_role
    self.role ||= :reader
  end
end
