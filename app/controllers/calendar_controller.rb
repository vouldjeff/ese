# Remember, that I`ve eddited event_calendar.rb to add course_id, and the helper, to add 24hours format
class CalendarController < ApplicationController
  before_filter :login_required
  before_filter :change_language
  filter_resource_access
  
  def index
    @month = params[:month].to_i
    @year = params[:year].to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month, @course.id, 0)
  end
  
  private
  
  def change_language
    @course = Course.find(params[:course_id])
    lang = @course.lang
    I18n.locale = lang
  end
end