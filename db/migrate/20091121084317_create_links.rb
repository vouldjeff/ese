class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :tag_id
      t.integer :material_id
    end
  end

  def self.down
    drop_table :links
  end
end
