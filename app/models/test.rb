class Test < ActiveRecord::Base
  belongs_to :course
  has_many :questions, :dependent => :destroy
  has_many :results, :dependent => :destroy
  has_friendly_id :name, :use_slug => true

  attr_accessible :name, :description, :enabled, :can_correct, :active_from, :active_to, :duration, :weight, :question_attributes
  after_update :save_questions
  validates_associated :questions

  validates_length_of :name, :in => 3..200
  validates_length_of :description, :in => 10..2000

  def question_attributes=(question_attributes)
    question_attributes.each do |attributes|
      if attributes[:id].blank?
        questions.build(attributes)
      else
        question = questions.detect { |t| t.id == attributes[:id].to_i }
        question.attributes = attributes
      end
    end
  end

  def save_questions
    questions.each do |t|
      if t.should_destroy?
        t.destroy
      else
        t.save(false)
      end
    end
  end
end
