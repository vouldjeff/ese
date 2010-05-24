class ApplicationController < ActionController::Base
  include Authentication
  helper :all
  rescue_from ActiveRecord::RecordNotFound, :with => :rescue_404_action
  rescue_from ActionController::RoutingError, :with => :rescue_404_action

  protect_from_forgery
  before_filter { |c| Authorization.current_user = c.current_user }
  before_filter {
    I18n.locale = "bg"
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

  def load_course_object
    @course = Course.find(params[:course_id])
  end

  def change_language
    I18n.locale = @course.lang
  end
end