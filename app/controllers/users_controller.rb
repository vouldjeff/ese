class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]
  protect_from_forgery :only => [:create, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.role_ids = [3]
    if @user.save
      flash[:notice] = t('registered_s')
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    if params[:role] != nil
      @user = User.find_by_username(params[:role][:username])
      if @user == nil
        redirect_to page404_path()
      end
    end
  end

  def update
    @user = User.find(params[:id])
    @user.role_ids = params[:user][:role_ids]
    if @user.save
      flash[:notice] = t('successfully_updated_user')
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def index
    # TODO: not show old participants
    @users = User.find(:all, :select => "username, id", :include => [:participants], :conditions => ['username LIKE ?', "%#{params[:search]}%"])
  end

  def index2
    @users = User.find(:all, :select => "username, id", :conditions => ['username LIKE ?', "%#{params[:role][:username]}%"])
  end
end
