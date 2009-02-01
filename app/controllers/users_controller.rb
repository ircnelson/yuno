class UsersController < ApplicationController
  
  # Protect these actions behind an admin login
  before_filter :admin_required, :only => [:index, :suspend, :unsuspend, :destroy, :purge, :forceactivate]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  def index
		@users = User.paginate(:page => params[:page], :order => 'created_at desc')
		respond_to do |format|
	    format.html
		end
  end

  def new
    @user = User.new
  end

	# Criar uma nova conta
  def create
    logout_keeping_session!
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

	# join.html.erb
	def join
		@user = User.new
	end

	# Logar conta de usuário
	def auth
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      flash[:notice] = t('flash.login')
      
      now = Time.now.to_s(:db)
      user.update_attribute(:session_at, now)
      last_connection = user.connections.build(:logon => now, :address_ip => request.remote_ip)
      last_connection.save rescue nil
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      redirect_to join_path
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
  	@user = User.find(current_user.id)
  end
  
  def update
  	@user = User.find(current_user.id)
  	if @user.update_attributes(params[:user])
  		flash[:notice] = "Sua conta foi atualizada com sucesso"
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
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
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
		# Track failed login attempts
		def note_failed_signin
		  flash[:error] = "Couldn't log you in as '#{params[:login]}'"
		  logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
		end
end
