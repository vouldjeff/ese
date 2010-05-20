class ParticipantsController < ApplicationController
  before_filter :login_required
  before_filter :load_course_object
  before_filter :change_language
  filter_resource_access

  def new
    @participants = Participant.find(:all, :include => [:user], :conditions => { :course_id => @course.id })
  end

  def create
    @participant.course = @course
    if User.count(:conditions => { :username => params[:participant][:username] }) == 1
      if @participant.save
        flash[:notice] = t('successfully_added') + " #{@participant.username}!"
        respond_to do |format|
          format.html { redirect_to participants_path() }
          format.js
        end
      else
        render :action => "new"
      end
    end
  end

  def destroy
    @participant.destroy
    flash[:notice] = t('successfully_removed') + " #{@participant.username}!"

    respond_to do |format|
      format.html { redirect_to participants_path() }
      format.js
    end
  end
end
