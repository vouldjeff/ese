class Link < ActiveRecord::Base
  belongs_to :tag
  belongs_to :material

  attr_accessible nil

  validates_presence_of :tag_id
  validates_presence_of :material_id
end
