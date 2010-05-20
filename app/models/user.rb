class User < ActiveRecord::Base
  has_many :results, :dependent => :destroy
  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
  has_many :participants, :dependent => :destroy
  has_many :courses, :through => :participants

  has_friendly_id :username, :use_slug => true

  acts_as_authentic

  def role_symbols
    @role_symbols ||= roles.map{ |r| r.name.underscore.to_sym }
  end

  def is_techer?
   @is_teacher ||= !role_symbols().index(:teacher).nil?
  end
end
