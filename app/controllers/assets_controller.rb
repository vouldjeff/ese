class AssetsController < ApplicationController
  before_filter :login_required
  filter_resource_access

  def show
    @asset = Asset.find(params[:id])
    # do security check here
    send_file @asset.data.path, :type => @asset.data_content_type, :disposition => 'inline'
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset_id = @asset.id.to_s
    @allowed = Material::Max_Attachments - @asset.attachable.assets.count + 1
    @asset.destroy
    flash[:notice] = t('success_destroy') + " " + t('asset') + "."
  end
end