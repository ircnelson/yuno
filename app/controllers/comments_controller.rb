class CommentsController < ApplicationController
	before_filter :find_task

  def new
    @comment = @task.comments.build
  end

  def create
    @comment = @task.comments.build(params[:comment])
    if @comment.save
	   	@task.open!
      flash[:notice] = successfull(:comment)
      redirect_to(project_task_path(@task.project, @task))
    else
      redirect_to [@task.project, @task]
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to(project_task_path(@task.project, @task))
  end
  
  protected
  	def find_task
  		@task = Task.find(params[:task_id])
  	end
end
