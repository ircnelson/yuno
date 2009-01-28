class Comment < ActiveRecord::Base
	belongs_to :task
	belongs_to :user

	after_save :update_task
	
	named_scope :recent, lambda { |*args| { :conditions => ["created_at > ?", (args.first || 2.days.ago)] } }
	
	def update_task
		task.update_attribute(:commented_at, Time.now.to_s(:db))
	end
end
