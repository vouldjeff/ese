class Links < ActiveRecord::Base
  belongs_to :tag
  belongs_to :material
end
