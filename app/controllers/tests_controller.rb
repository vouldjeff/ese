class TestsController < ApplicationController
  before_filter :login_required
  before_filter :load_course_object
  before_filter :load_test_object, :only => [:edit, :step2, :step3, :doit]
  before_filter :load_test_object_with_results, :only => [:show]
  before_filter :change_language
  filter_access_to :all, :attribute_check => true

  def show
    if current_user.is_teacher?
      @results = @test.results
    elsif
      @results = Result.all(:conditions => {:test_id => current_user.id, :test_id => @test.id}, :include => [:user, {:test => {:questions => :answers}}])
    end
  end

  def new
  end

  def edit
  end

  def create
    @test.course = Course.find(params[:course_id])
    if @test.save
      flash[:notice] = t('first_step_acc')
      redirect_to test_other_path(:id => @test, :action => 'step2')
    else
      render :action => "new"
    end
  end

  def update
    if @test.update_attributes(params[:test])
      flash[:notice] = t('first_step_acc')
      redirect_to test_other_path(:id => @test, :action => 'step2')
    else
      render :action => "edit"
    end
  end

  def destroy
    @test.destroy
    flash[:notice] =  t('success_destroy') + " " + t('test') + "."

    redirect_to course_view_path(@test.course)
  end

  def step2
  end

  def step2_update
    if @test.update_attributes(params[:test])
      flash[:notice] = t('second_step_acc')
      redirect_to test_other_path(:id => @test, :action => 'step3')
    else
      render :action => "step2"
    end
  end

  def step3
  end

  def step3_update
    if @test.update_attributes(params[:test])
      flash[:notice] = t('third_step_acc')
      redirect_to test_view_path(:id => @test)
    else
      render :action => "step3"
    end
  end

  def doit
    #time checking
    unless ((@test.active_from.utc)..(@test.active_to.utc - 60)).include?(Time.now.utc) or !@test.enabled
      unless params[:questions].nil?
        @result = Result.create(:answers => {})
        flash[:error] = t('late')
      else
        lash[:error] = t('test_not_active')
      end

      session["start_#{@test.id}"] = nil
      
      redirect_to test_view_path()
      return
    end

    #already made check
    count = Result.count(:all, :conditions => { :test_id => @test.id, :user_id => current_user.id })
    if count > 0
      if !@test.can_correct?
        flash[:error] = t('made_this_test')
        redirect_to test_view_path()
      elsif count > 2
        flash[:error] = t('made_this_test_over')
        redirect_to test_view_path()
      end
    end

    #calculate end time for session or calculate result
    if params[:questions].nil?
      session["start_#{@test.id}"] = Time.now.utc
      return
    else
      real_end = session["start_#{@test.id}"] + (@test.duration * 60)
      if real_end >= @test.active_to
        endtime = @test.active_to + 60
      else
        endtime = real_end + 60
      end

      if endtime < Time.now.utc
        flash[:error] = t('late')
        @result = Result.create(:answers => {})
      else
        @result = Result.create(:answers => params[:questions])
      end

      session["start_#{@test.id}"] = nil

      @result.user = current_user
      @result.test = @test
      @result.result = @result.calculate
      @result.save!
    end

    redirect_to test_view_path()
  end

  private
  def load_test_object
    @test = Test.find(params[:id], :include => [{:questions => :answers}])
  end

  def load_test_object_with_results
    @test = Test.find(params[:id], :include => [{:results => [:user, {:test => {:questions => :answers}}]}, {:questions => :answers}])
  end
end
