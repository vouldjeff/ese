class Question < ActiveRecord::Base
  belongs_to :test
  has_many :answers, :dependent => :destroy

  attr_accessor :should_destroy
  after_update :save_answers
  validates_associated :answers

  attr_accessible :content, :kind, :answer_attributes

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

  def number_of_correct_answers
    correct_answers.length
  end

  def correct_answers
    @correct unless @correct.nil?
    @correct = []
    answers.each{ |e| @correct << e if e.correct? }
    
    @correct
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
