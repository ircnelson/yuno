class Project < ActiveRecord::Base
	has_many :tasks, :dependent => :destroy
	belongs_to :user
	belongs_to :client
	validates_uniqueness_of :name
	validates_presence_of :name
	validates_associated :tasks

	named_scope :recent, lambda { |*args| { :conditions => ["created_at > ?", (args.first || 1.week.ago)]} }
end
