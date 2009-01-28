# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include AuthenticatedSystem
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0581095ecbc4c0d9708805bf92026990'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

	before_filter :set_language
	#before_filter :update_connections
	
	private
		def set_language
			I18n.locale = "br"
		end
		
		#def update_connections
		#	now = DateTime.now.to_s(:db)
		#	if logged_in?
		#		@user = User.find(current_user.id)
		#		@user.update_attribute(:session_at, now)
		#	end
		#	User.update_all(["session_at = ?", nil], ["session_at < ?", Time.now - 30.minutes])
		#end
end
