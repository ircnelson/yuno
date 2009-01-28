class AddSessionAtUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :session_at, :datetime
  end

  def self.down
  	remove_column :users, :session_at
  end
end
