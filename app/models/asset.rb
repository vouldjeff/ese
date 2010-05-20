class Asset < ActiveRecord::Base
  attr_accessible nil

  has_attached_file :data,
                    :url  => "/assets/:id",
                    :path => ":rails_root/assets/docs/:id/:style/:basename.:extension"

  belongs_to :attachable, :polymorphic => true

  validates_presence_of :name
  validates_presence_of :file_size
  validates_presence_of :content_type

  def url(*args)
    data.url(*args)
  end

  def name
    data_file_name
  end

  def content_type
    data_content_type
  end

  def file_size
    data_file_size
  end
end