class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  attr_accessible nil

  validates_presence_of :user_id
  validates_presence_of :role_id
end
