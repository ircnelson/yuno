class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,												:string, :limit => 40
      t.column :name,													:string, :limit => 100, :default => '', :null => true
      t.column :email,												:string, :limit => 100
      t.column :crypted_password,						:string, :limit => 40
      t.column :salt,													:string, :limit => 40
      t.column :created_at,									:datetime
      t.column :updated_at,									:datetime
      t.column :remember_token,							:string, :limit => 40
      t.column :remember_token_expires_at,	:datetime
      t.column :activation_code,						:string, :limit => 40
      t.column :activated_at,								:datetime
      t.column :state,												:string, :null => :no, :default => 'passive'
      t.column :deleted_at,									:datetime
      t.column :level,												:string, :default => 'normal', :null => true
    end
    add_index :users, :login, :unique => true
    admin = User.create(:name => "Administrador", :login => "Admin", :password => "rR1121", :password_confirmation => "rR1121", :email => "admin@yuno.com.br", :level => "admin")
    admin.activate!
    
    nelson = User.create(:name => "Nelson Corrêa V. Júnior", :login => "nelson", :password => "487569", :password_confirmation => "487569", :email => "nelson@yuno.com.br", :level => "admin")
    nelson.activate!
    
    raphael = User.create(:name => "Raphael Cavassan Dourado", :login => "raphael", :password => "rph_dourado", :password_confirmation => "rph_dourado", :email => "raphael@yuno.com.br", :level => "admin")
    raphael.activate!
  end

  def self.down
    drop_table "users"
  end
end
