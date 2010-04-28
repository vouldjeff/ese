class ParticipantsController < ApplicationController
  before_filter :login_required
  before_filter :change_language
  filter_resource_access

  def new
    @participants = Participant.all(:all, :conditions => { :course_id => Course.find(params[:course_id]).id })
  end

  def create
    @participant.course = Course.find(params[:course_id])
    if User.find_by_username(params[:participant][:username]) != nil
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

  def change_language
    lang = Course.find(params[:course_id]).lang
    I18n.locale = lang
  end
end
