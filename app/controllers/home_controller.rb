class HomeController < ApplicationController
  def index
  	@tasks = Task.recent.all :limit => 5, :order => 'id desc'
  	@comments = Comment.recent.all :limit => 5, :order => 'id desc'
  	@connections = Connection.all :limit => 5, :order => 'id desc'
  end
end
