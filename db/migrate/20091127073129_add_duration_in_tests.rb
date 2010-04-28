class AddDurationInTests < ActiveRecord::Migration
  def self.up
    add_column :tests, :duration, :integer
  end

  def self.down
    remove_column :tests, :duration
  end
end
