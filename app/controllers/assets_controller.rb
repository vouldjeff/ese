class AssetsController < ApplicationController
  before_filter :load_asset_object
  before_filter :login_required
  filter_access_to :all, :attribute_check => true

  def show
    @asset = Asset.find(params[:id])
    # do security check here
    send_file @asset.data.path, :type => @asset.data_content_type, :disposition => 'inline'
  end

  def destroy
    @asset_id = @asset.id.to_s
    @allowed = Material::Max_Attachments - @asset.attachable.assets.count + 1
    @asset.destroy
    flash[:notice] = t('success_destroy') + " " + t('asset') + "."
  end

  private
  def load_asset_object
    @asset = Asset.find(params[:id])
  end
end