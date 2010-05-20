class Result < ActiveRecord::Base
  belongs_to :test
  belongs_to :user

  serialize :answers

  attr_accessible :answers, :result

  def calculate
    points = 0
    max = 0
    correctPerAnswer = 0

    if answers == nil
      return 0
    end

    if answers.length != right.length
      return 0
    end

    right.each do |question|
      max += question.weight
      if answers["#{question.id}"] != nil and answers["#{question.id}"][answers["#{question.id}"].length - 1][:service] == "1"
        total_correct_per_answer = question.num_of_correct
        if total_correct_per_answer >= answers["#{question.id}"].length - 1 and answers["#{question.id}"].length - 1 > 0
          correct = (question.correct.collect! { |e| e.id } & answers["#{question.id}"][0..(answers["#{question.id}"].length - 2)].collect { |e| e.to_i }).length
          points += (correct / total_correct_per_answer) * question.weight
        end
      else
        return 0
      end
    end
    (points.to_f * 100 / max.to_f).round(2)
  end
end
