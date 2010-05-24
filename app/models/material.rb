class Material < ActiveRecord::Base
  has_many :links, :dependent => :destroy
  has_many :tags, :through => :links
  has_many :assets, :as => :attachable, :dependent => :destroy
  belongs_to :course

  attr_accessible :name, :content

  has_friendly_id :name, :use_slug => true

  validates_length_of :name, :in => 3..200
  validates_length_of :content, :minimum => 10

  validate :validate_attachments

  Max_Attachments = 5
  Max_Attachment_Size = 1.megabyte

  def validate_attachments
    errors.add_to_base(I18n.t('too_many_assets', :count => Max_Attachments)) if assets.length > Max_Attachments
    assets.each {|a| errors.add_to_base(I18n.t('too_big', :name => a.name, :max => Max_Attachment_Size/1.megabyte)) if a.file_size > Max_Attachment_Size}
   end
end
