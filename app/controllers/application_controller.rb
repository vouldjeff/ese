# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication
  helper :all
  rescue_from ActiveRecord::RecordNotFound, :with => :rescue_404_action
  rescue_from ActionController::RoutingError, :with => :rescue_404_action

  protect_from_forgery
  before_filter { |c| Authorization.current_user = c.current_user }
  before_filter {
    I18n.locale = "bg"
    @l = "bg"
  }

  helper :breadcrumbs

  #def default_url_options(options = nil)
  #  { :format => 'html' }
  #end

  protected
  
  def rescue_404_action
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  def permission_denied
    flash[:error] = t('access_denied')
    redirect_to root_url
  end

  def is_techer?
    current_user.roles.map do |role|
      return true if role[:id] == 2
    end
    return false
  end

  def calculate_result(answers, right)
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