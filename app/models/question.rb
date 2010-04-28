class Question < ActiveRecord::Base
  belongs_to :test
  has_many :answers, :dependent => :destroy

  attr_accessor :should_destroy
  after_update :save_answers
  validates_associated :answers

  def answer_attributes=(answer_attributes)
    answer_attributes.each do |attributes|
      if attributes[:id].blank?
        answers.build(attributes)
      else
        answer = answers.detect { |t| t.id == attributes[:id].to_i }
        answer.attributes = {:correct => 0}
        answer.attributes = attributes
      end
    end
  end

  def num_of_correct
    Answer.count(:all, :conditions => { :question_id => id, :correct => true })
  end

  def correct
    Answer.find(:all, :conditions => { :question_id => id, :correct => true })
  end

  def save_answers
    answers.each do |t|
      if t.should_destroy?
        t.destroy
      else
        t.save(false)
      end
    end
  end

  def should_destroy?
    should_destroy.to_i == 1
  end
end
