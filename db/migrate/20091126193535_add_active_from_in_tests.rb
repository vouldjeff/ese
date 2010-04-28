class AddActiveFromInTests < ActiveRecord::Migration
  def self.up
    add_column :tests, :active_from, :datetime
    add_column :tests, :active_to, :datetime
  end

  def self.down
    remove_column :tests, :active_from
    remove_column :tests, :active_to
  end
end
