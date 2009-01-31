class Comment < ActiveRecord::Base
	cattr_reader :per_page
  @@per_page = 5

	belongs_to :task
	belongs_to :user

	after_save :update_task
	
	named_scope :recent, lambda { |*args| { :conditions => ["created_at > ?", (args.first || 2.days.ago)] } }
	
	def update_task
		task.update_attribute(:commented_at, Time.now.to_s(:db))
	end
end
