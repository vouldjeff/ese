class AddWeightInTests < ActiveRecord::Migration
  def self.up
    add_column :tests, :weight, :integer
  end

  def self.down
    remove_column :tests, :weight
  end
end
