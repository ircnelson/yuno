class UsersController < ApplicationController
  
  # Protect these actions behind an admin login
  before_filter :admin_required, :only => [:index, :suspend, :unsuspend, :destroy, :purge, :forceactivate]
  before_filter :find_user, :only => [:edit, :update, :suspend, :unsuspend, :destroy, :purge]

  def index
		@users = User.paginate(:page => params[:page], :order => 'created_at desc')
  end

  def new
    @user = User.new
  end

	# Criar uma nova conta
  def create
    #logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = t('flash.signup')
    else
      render :action => 'new'
    end
  end

	# Logar conta de usuário
	def login
		if !request.post?
			@user = User.new
		else
		  logout_keeping_session!
		  user = User.authenticate(params[:login], params[:password])
		  if user
		    # reset_session
		    self.current_user = user
		    new_cookie_flag = (params[:remember_me] == "1")
		    handle_remember_cookie! new_cookie_flag
		    respond_to do |format|
		    	format.html do
   			    flash[:notice] = t('flash.login')
		    		redirect_back_or_default('/')
		    	end
				  format.js {	render(:update) { |page| page.reload } }
				end    
		    now = Time.now.to_s(:db)
		    user.update_attribute(:session_at, now)
		    last_connection = user.connections.build(:logon => now, :address_ip => request.remote_ip)
		    last_connection.save rescue nil
		  else
    	  failed_signin
  		  respond_to do |format|
		    	format.html do
				    @login = params[:login]
		  	    @remember_me = params[:remember_me]
		    	  render :action => "login"
   	  		  flash[:error] = @flashmsg
		    	end
				  format.js do
				    render(:update) do |page|
				    	page["#flash-error"].show().text(@flashmsg)
				    	page["#spinner"].hide
				    end
				  end
				end
		  end
		end
  end

	# Logout
	def logout
		user = User.find(current_user.id)
    user.update_attribute(:session_at, nil)
    logout_killing_session!
    flash[:notice] = t('flash.logout')
    redirect_back_or_default('/')
  end
  
  def show
  	if params[:id]
  		@user = User.find(params[:id])
  	else
			@user = current_user
		end
  end
  
  def edit
  end
  
  def update
  	if @user.update_attributes(params[:user])
  		flash[:notice] = successfull(:updated)
  		redirect_back_or_default perfil_path
  	else
  		render :action => "edit"
  	end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
		  when (!params[:activation_code].blank?) && user && !user.active?
		    user.activate!
		    flash[:notice] = t('flash.authentication.completed')
		    redirect_to join_path
		  when params[:activation_code].blank?
		    flash[:error] = t('flash.authentication.code_blank')
		    redirect_back_or_default('/')
    else 
      flash[:error]  = t('flash.authentication.code_missing')
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end
  
  def forceactivate
  	@user.activate!
  	redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

	protected
  	def find_user
		  @user = User.find(params[:id])
		end

		def failed_signin
			if params[:login].blank?
			  @flashmsg = t('flash.authentication.blank_login')
			elsif params[:login] && params[:password].blank?
			  @flashmsg = t('flash.authentication.blank_password')
			else
			  user = User.find_by_login(params[:login])
			  if !user.active?
			    @flashmsg = t('flash.authentication.not_activated')
			  end
			end
		  logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
		end
end
