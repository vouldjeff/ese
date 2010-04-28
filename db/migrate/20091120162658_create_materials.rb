class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.string :name
      t.text :content
      t.integer :course_id
    end
  end

  def self.down
    drop_table :materials
  end
end
