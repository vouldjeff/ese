class Participant < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  attr_accessible nil

  validates_uniqueness_of :user_id, :scope => :course_id
  validates_presence_of :user_id
  validates_presence_of :course_id

  def username
    user.username if user
  end

  def username=(username)
    self.user = User.find_by_username(username) unless username.blank?
  end
end
