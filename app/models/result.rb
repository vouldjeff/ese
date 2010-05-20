class Result < ActiveRecord::Base
  belongs_to :test
  belongs_to :user

  serialize :answers

  attr_accessible :answers, :result
end
