class TasksController < ApplicationController

	before_filter :get_project_id, :except => [:index, :open, :close]
	before_filter :find_task, :only => [:show, :edit, :update, :destroy, :open, :close]

	def index
		@tasks = Task.paginate(:page => params[:page], :order => 'created_at DESC', :limit => 1)
	end

  def show
  	@comments = @task.comments.paginate(:page => params[:page])
  	@comment = @task.comments.build
  end

  def new
    @task = @project.tasks.build
  end

  def edit
  end

  def create
    @task = @project.tasks.build(params[:task])
    respond_to do |format|
      if @task.save
        flash[:notice] = successfull
        format.html { redirect_to(@project, @task) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = successfull(:updated)
        format.html { redirect_to(@project, @task) }

      else
        format.html { render :action => "edit" }
      end
    end
  end

	def close
		@task.close!
		redirect_to project_task_path(@task.project, @task)
	end
	def open
		@task.open!
		redirect_to project_task_path(@task.project, @task)
	end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to(project_tasks_url(@project)) }
    end
  end
  
  protected
  	def get_project_id
  		@project = Project.find(params[:project_id])
  	end
  	def find_task
  		@task = Task.find(params[:id])
  	end
end
