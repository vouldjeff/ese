class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
    end
    Role.create :name => "admin"
    Role.create :name => "teacher"
    Role.create :name => "student"
  end

  def self.down
    drop_table :roles
  end
end
