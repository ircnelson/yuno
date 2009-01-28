class ProjectsController < ApplicationController

	before_filter :admin_required
	before_filter :get_clients, :except => :destroy

  def index
    @projects = Project.find(:all)
    #@users = User.find(:all, :conditions => ["nome like ?","#{params[:coordenador_id]}%"])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
      format.js
    end
  end

  def show
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def new
    @project = Project.new
    @project.tasks.build

    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  	def get_clients
	  	@clients = Client.all
  	end
end
