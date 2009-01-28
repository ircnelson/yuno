module ProjectsHelper
	def add_task_link(name)
		link_to_function name do |page|
		  page.insert_html :bottom, :tasks, :partial => 'task', :object => Task.new
		end
  end
  
  def fields_for_task(tarefa, &block)
	  prefix = task.new_record? ? 'new' : 'existing'
  	fields_for("project[#{prefix}_task_attrs][]", task, &block)
	end
end
