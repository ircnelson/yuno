class Task < ActiveRecord::Base
	has_many :comments, :dependent => :destroy
	belongs_to :project
	belongs_to :user
	validates_presence_of :name

	named_scope :recent, lambda { |*args| { :conditions => ["created_at > ?", (args.first || 2.days.ago)] } }
	
	def open!
		 write_attribute :state, "open"
		 save()
	end
	
	def close!
		write_attribute :state, "closed"
		save()
	end
	
	def open?
		self.state.downcase === "open" ? true : false
	end
end
