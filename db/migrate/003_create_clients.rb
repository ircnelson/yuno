class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :client
      t.string :coordinator
      t.string :email
      t.string :phone
      t.string :city
      t.string :address_state
      t.string :address
      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
