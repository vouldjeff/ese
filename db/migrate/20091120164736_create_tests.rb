class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.string :name
      t.text :description
      t.boolean :enabled
      t.boolean :can_correct
      t.integer :course_id
    end
  end

  def self.down
    drop_table :tests
  end
end
