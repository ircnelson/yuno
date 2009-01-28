class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table :connections do |t|
      t.integer :user_id
      t.datetime :logon
      t.string :address_ip
    end
  end

  def self.down
    drop_table :connections
  end
end
