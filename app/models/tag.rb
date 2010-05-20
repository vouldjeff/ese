class Tag < ActiveRecord::Base
  has_many :links, :dependent => :destroy
  has_many :materials, :through => :links

  attr_accessible :name
end
