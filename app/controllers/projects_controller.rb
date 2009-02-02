class ProjectsController < ApplicationController

	before_filter :admin_required
	before_filter :get_clients, :except => :destroy
	before_filter :find_project, :except => [:index, :new, :create]

  def index
    @projects = Project.find(:all)
    #@users = User.find(:all, :conditions => ["nome like ?","#{params[:coordenador_id]}%"])
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def new
    @project = Project.new
    @project.tasks.build
  end

  def edit
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = successfull
        format.html { redirect_to(@project) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = successfull(:updated)
        format.html { redirect_to(@project) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to(projects_url) }
    end
  end
  
  protected
  	def get_clients
	  	@clients = Client.all
  	end
  	
  	def find_project
	  	@project = Project.find(params[:id])
  	end
end
