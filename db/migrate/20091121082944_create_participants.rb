class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.integer :user_id
      t.integer :course_id
    end
  end

  def self.down
    drop_table :participants
  end
end
