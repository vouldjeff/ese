class User < ActiveRecord::Base

  has_many :results, :dependent => :destroy
  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
  has_many :participants, :dependent => :destroy
  has_many :courses, :through => :participants

  has_friendly_id :username, :use_slug => true

  acts_as_authentic

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

end
