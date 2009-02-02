class CommentsController < ApplicationController
	before_filter :get_task_id

  def new
    @comment = @task.comments.build
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comment }
    end
  end

  def create
    @comment = @task.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save
      	@task.open!
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(project_task_path(@task.project, @task)) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { redirect_to [@task.project, @task] }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(project_task_path(@task.project, @task)) }
      format.xml  { head :ok }
    end
  end
  
  protected
  	def get_task_id
  		@task = Task.find(params[:task_id])
  	end
end
