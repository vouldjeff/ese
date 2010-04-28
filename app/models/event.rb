# TODO: add color!!!
class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :course
  
  attr_accessible :name, :description, :start_at, :end_at, :all_day
  
  has_friendly_id :name, :use_slug => true
  
  validates_length_of :name, :in => 3..200
  validates_length_of :description, :in => 10..2000
  validates_presence_of :start_at
  validates_presence_of :end_at
end