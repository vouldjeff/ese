class TestsController < ApplicationController
  before_filter :login_required
  before_filter :change_language
  filter_resource_access

  def show
    @your_results = Result.find(:all, :conditions => { :test_id => @test.id, :user_id => current_user.id })
    
    @vls = Array.new
    if @template.is_teacher? and @test.results.count > 0
      @vls = @test.results
    elsif @your_results.count > 0
      @vls = @your_results
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
    unless (@test.active_from.utc <= Time.now.utc and Time.now.utc <= @test.active_to.utc - 60) or @test.enabled != true
      flash[:error] = t('test_not_active')
      if params[:questions] != nil
        Result.create(:test => @test, :user => current_user, :result => -1, :answers => {})
        session["start_#{@test.id}"] = nil
        flash[:error] = t('late')
      end

      redirect_to test_view_path()
      return
    end
	
    #already made check
    if Result.find(:all, :conditions => { :test_id => @test.id, :user_id => current_user.id }).length > 0
      if @test.can_correct != true
        flash[:error] = t('made_this_test')
        redirect_to test_view_path()
      elsif Result.find(:all, :conditions => { :test_id => @test.id, :user_id => current_user.id }).length > 2
        flash[:error] = t('made_this_test_over')
        redirect_to test_view_path()
      end
    end

	#calculate end time for session or calculate result
    if params[:questions] == nil
      session["start_#{@test.id}"] = Time.now.utc
      return
    else
      if session["start_#{@test.id}"] + (@test.duration * 60) >= @test.active_to
        endtime = @test.active_to + 60
      else
        endtime = session["start_#{@test.id}"] + (@test.duration * 60) + 60
      end

      if endtime < Time.now.utc
        flash[:error] = t('late')
        Result.create(:test => @test, :user => current_user, :result => -1, :answers => {})
        session["start_#{@test.id}"] = nil
      else
        Result.create(:test => @test, :user => current_user, :result => calculate_result(params[:questions], @test.questions), :answers => params[:questions])
        session["start_#{@test.id}"] = nil
      end
    end

    redirect_to test_view_path()
  end

  def change_language
    lang = Course.find(params[:course_id]).lang
    I18n.locale = lang
  end
end
