class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.text :content
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
