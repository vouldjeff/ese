class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :results, :user_id
    add_index :results, :test_id
    add_index :participants, :course_id
    add_index :participants, :user_id
    add_index :questions, :test_id
    add_index :tests, :course_id
    add_index :events, :course_id
    add_index :materials, :course_id
    add_index :links, :tag_id
    add_index :links, :material_id
    add_index :assignments, :role_id
    add_index :assignments, :user_id
    add_index :news, :course_id
    add_index :news, :user_id
    add_index :answers, :question_id
  end

  def self.down
    remove_index :results, :user_id
    remove_index :results, :test_id
    remove_index :participants, :course_id
    remove_index :participants, :user_id
    remove_index :questions, :test_id
    remove_index :tests, :course_id
    remove_index :events, :course_id
    remove_index :materials, :course_id
    remove_index :links, :tag_id
    remove_index :links, :material_id
    remove_index :assignments, :role_id
    remove_index :assignments, :user_id
    remove_index :news, :course_id
    remove_index :news, :user_id
    remove_index :answers, :question_id
  end
end
