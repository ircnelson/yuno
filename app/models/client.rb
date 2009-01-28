class Client < ActiveRecord::Base
	has_many :projetos
	validates_presence_of			:client
	validates_presence_of			:coordinator
	validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
end
