class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    
    @user_session.save do |result|
      if result
        flash[:notice] = t('logged_in')
        redirect_to_target_or_default(root_url)
      else
        render :action => 'new'
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    flash[:notice] = t('logged_out')
    redirect_to root_url
  end
end
