class EventsController < ApplicationController
  before_filter :login_required
  before_filter :change_language
  filter_resource_access

  def show
  end

  def new
  end

  def edit
  end

  def create
    @event.course = Course.find(params[:course_id])
    if @event.save
      flash[:notice] = t('success_insert') + " " + t('event') + "."
      redirect_to event_view_path(:id => @event, :course_id => @event.course)
    else
      render :action => "new"
    end
  end

  def update
    if @event.update_attributes(params[:event])
      flash[:notice] = t('success_update') + " " + t('event') + "."
      redirect_to event_view_path(:id => @event, :course_id => @event.course)
    else
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = t('success_destroy') + " " + t('event') + "."

    redirect_to course_view_path(@event.course)
  end

  def change_language
    lang = Course.find(params[:course_id]).lang
    I18n.locale = lang
  end
end