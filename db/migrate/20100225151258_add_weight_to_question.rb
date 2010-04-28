class AddWeightToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :weight, :integer
  end

  def self.down
    remove_column :questions, :weight
  end
end
