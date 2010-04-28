class NewsController < ApplicationController
  before_filter :login_required
  filter_resource_access

  def create
    @news = News.new(params[:news])

    @news.course = Course.find(params[:course_id])
    @news.user = current_user

    respond_to do |format|
      if @news.save
        flash[:notice] = t('success_insert') + " " + t('single_news') + "."
        format.html { redirect_to(@news.course) }
        format.js
      else
        format.html { course_view_path(@news.course) }
      end
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy
    flash[:notice] = t('success_destroy') + " " + t('single_news') + "."

    respond_to do |format|
      format.html { course_view_path(@news.course) }
      format.js
    end
  end
end