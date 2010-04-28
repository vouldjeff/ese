class CoursesController < ApplicationController
  before_filter :login_required
  before_filter :change_language, :only => [:show]
  filter_resource_access

  def index
    @courses = current_user.courses

    current_user.roles.map do |role|
      @courses = Course.all if role[:id] == 1
    end
  end

  def show
    @materials = @course.materials

    @tests = @course.tests
    @news = @course.news.reverse
  end

  def new
  end

  def progress
    @tests = @course.tests.sort! { |x, y| x.created_at <=> y.created_at }
    @participants = @course.participants.sort! { |x, y| x.user.created_at <=> y.user.created_at }
    
    # all results or only current users`s
    if @template.is_teacher?
      conditions = ["courses.id = ?", @course.id]
      height = @participants.count
    else
      conditions = ["courses.id = ? AND results.user_id = ?", @course.id, current_user.id]
      height = 1
    end
    
    #fetch all results needed
    raw_results = Result.find(:all, :joins => "LEFT JOIN tests ON tests.id = results.test_id 
    LEFT JOIN courses ON courses.id = tests.course_id", :conditions => conditions, :order => "results.created_at DESC")

    # loop through all results and sort them for easy use
    @results = Hash.new
    raw_results.each do |result|
      unless @results[result.user_id].nil?
        next unless @results[result.user_id][result.test_id].nil?
      end
      
      if @results[result.user_id].nil?
        @results[result.user_id] = Hash.new
      end
      @results[result.user_id][result.test_id] = result.result
    end
  end

  def edit
  end

  def create

    if @course.save
      flash[:notice] = t('success_insert') + " " + t('course') + "."
      redirect_to course_view_path(@course)
    else
      render :action => "new"
    end
  end

  def update

    if @course.update_attributes(params[:course])
      flash[:notice] = t('success_update') + " " + t('course') + "."
      redirect_to course_view_path(@course)
    else
      render :action => "edit"
    end
  end

  def destroy
    @course.destroy
    flash[:notice] = t('success_destroy') + " " + t('course') + "."

    redirect_to(courses_url)
  end

  def change_language
    lang = Course.find(params[:id]).lang
    I18n.locale = lang
  end
end
