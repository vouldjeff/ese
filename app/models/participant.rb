class Participant < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => :course_id

  def username
    user.username if user
  end

  def username=(username)
    self.user = User.find_by_username(username) unless username.blank?
  end
end
