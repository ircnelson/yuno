class AddCommentedAtTask < ActiveRecord::Migration
  def self.up
  	add_column :tasks, :commented_at, :datetime
  end

  def self.down
  	remove_column :tasks, :commented_at
  end
end
