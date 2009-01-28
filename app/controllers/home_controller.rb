class HomeController < ApplicationController
  def index
  	@tasks = Task.recent.all :limit => 5
  	@comments = Comment.recent.all :limit => 5
  	@connections = Connection.all :limit => 5
  end
end
