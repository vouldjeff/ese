class Result < ActiveRecord::Base
  belongs_to :test
  belongs_to :user

  serialize :answers

  attr_accessible :answers, :result

  validates_associated :user
  validates_associated :test

  validates_presence_of :result
  validates_presence_of :answers

  def calculate
    points = 0
    max = 0
    total_correct_per_answer = 0
    answers_per_question = Array.new

    if answers.nil?
      return 0
    end

    if answers.length != test.questions.length
      return 0
    end

    test.questions.each do |question|
      max += question.weight
      answers_per_question = answers["#{question.id}"]
      if !answers_per_question.nil? and answers_per_question.last[:service] == "1"
        total_correct_per_answer = question.number_of_correct_answers
        if (1..total_correct_per_answer).include?(answers_per_question.length - 1)
          correct = (question.correct_answers.collect! { |e| e.id } & answers_per_question[0..(answers_per_question.length - 2)].collect { |e| e.to_i }).length
          points += (correct / total_correct_per_answer) * question.weight
        end
      else
        return 0
      end
    end
    (points.to_f * 100 / max.to_f).round(2)
  end
end
