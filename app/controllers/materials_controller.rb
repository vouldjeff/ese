class MaterialsController < ApplicationController
  before_filter :login_required
  before_filter :change_language
  filter_resource_access

  def show
    @l = @material.course.lang
  end

  def new
    @allowed = Material::Max_Attachments
  end

  def edit
    @allowed = Material::Max_Attachments - @material.assets.count
  end

  def create
    process_file_uploads(@material)

    @material.course = Course.find(params[:course_id])
    if @material.save
      flash[:notice] = t('success_insert') + " " + t('material') + "."
      redirect_to material_view_path(:id => @material, :course_id => @material.course)
    else
      render :action => "new"
    end
  end

  def update
    process_file_uploads(@material)

    if @material.update_attributes(params[:material])
      flash[:notice] = t('success_update') + " " + t('material') + "."
      redirect_to material_view_path(:id => @material, :course_id => @material.course)
    else
      render :action => "edit"
    end
  end

  def destroy
    @material.destroy
    flash[:notice] = t('success_destroy') + " " + t('material') + "."

    redirect_to course_view_path(@material.course)
  end

  def change_language
    lang = Course.find(params[:course_id]).lang
    I18n.locale = lang
  end

  protected

  def process_file_uploads(material)
    i = 0
    return if params[:attachment].nil?
    while params[:attachment]['file_'+i.to_s] != "" && !params[:attachment]['file_'+i.to_s].nil?
      material.assets.build(:data => params[:attachment]['file_'+i.to_s])
      i += 1
    end
  end
end
