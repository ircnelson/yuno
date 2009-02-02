class Task < ActiveRecord::Base
	cattr_reader :per_page
  @@per_page = 10
	
	has_many :comments, :dependent => :destroy, :order => 'id desc'
	belongs_to :project
	belongs_to :user
	validates_uniqueness_of :name
	validates_presence_of :name

	named_scope :recent, lambda { |*args| { :conditions => ["created_at > ?", (args.first || 2.days.ago)] } }

	acts_as_state_machine :initial => :pending
	state :pending
	state :opened, :enter => :set_real_date_start
	state :closed, :enter => :set_real_date_end

	event :pending do
    transitions :from => [:closed, :open], :to => :pending
  end

  event :open do
    transitions :from => [:pending, :closed], :to => :opened, :guard => Proc.new {|task| !(task.comments.blank?) }
  end
  
  event :close do
    transitions :from => [:pending, :opened], :to => :closed
  end

	protected
		def set_real_date_start
		  @task_open = true
		  self.real_date_start = Date.today.to_s(:db)
		end

		def set_real_date_end
		  @task_open = nil
		  self.real_date_end = Date.today.to_s(:db)
		end

	def open?
		@task_open ? true : false
	end
end
