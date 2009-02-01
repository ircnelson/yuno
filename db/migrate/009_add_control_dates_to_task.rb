class AddControlDatesToTask < ActiveRecord::Migration
  @columns = %w(date_start real_date_start date_end real_date_end)
  def self.up
  	@columns.each do |c|
	  	add_column :tasks, c.to_sym, :date
	  end
  end

  def self.down
  	@columns.each do |c|
	  	remove_column :tasks, c.to_sym
	  end
  end
end
