class Course < ActiveRecord::Base
  has_many :tests, :dependent => :destroy
  has_many :materials, :dependent => :destroy
  has_many :news, :dependent => :destroy
  has_many :participants, :dependent => :destroy
  has_many :users, :through => :participants
  has_many :events, :dependent => :destroy

  attr_accessible :name, :description, :lang

  has_friendly_id :name, :use_slug => true

  validates_length_of :name, :in => 3..200
  validates_length_of :description, :in => 10..2000
  validates_inclusion_of :lang, :in => %w{ bg en fr de ru es it }
end
