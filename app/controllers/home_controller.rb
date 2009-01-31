require 'rubygems'
require 'gruff'

class HomeController < ApplicationController
	
	before_filter :admin_required, :only => [:stats]

  def index
  	@tasks = Task.recent.all :limit => 5, :order => 'id desc'
  	@comments = Comment.recent.all :limit => 5, :order => 'id desc'
  	@connections = Connection.all :limit => 5, :order => 'id desc'
  	stats
  end

  def stats

    g = Gruff::Line.new('600x200')
    g.theme = {
       #:colors => ['#ff6600', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
       :colors => ['#FFA5FF', '#7FFF00', '#1e90ff', '#efba00', '#0aaafd'],
       :marker_color => '#aaa',
       :background_colors => ['#eaeaea', '#fff']
     }
 
    g.hide_title = true
    #g.font = File.expand_path('path/to/font.ttf', RAILS_ROOT)
 
    range = "created_at #{(6.months.ago.to_date..Date.today + 6.months).to_s(:db)}"
    @stats_users = User.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
    @stats_projects = Project.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
    @stats_tasks = Task.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
 
    # Take the union of all keys & convert into a hash {1 => "month", 2 => "month2"...}
    # - This will be the x-axis.. representing the date range
    #months = (@users.keys | @votes.keys | @bookmarks.keys).sort
    months = (@stats_users.keys | @stats_projects.keys | @stats_tasks.keys).sort
    keys = Hash[*months.collect {|v| [months.index(v),v.to_s] }.flatten]
 
    # Plot the data - insert 0's for missing keys
    g.data("Users", keys.collect {|k,v| @stats_users[v].nil? ? 0 : @stats_users[v]})
    g.data("Projects", keys.collect {|k,v| @stats_projects[v].nil? ? 0 : @stats_projects[v]})
    g.data("Tasks", keys.collect {|k,v| @stats_tasks[v].nil? ? 0 : @stats_tasks[v]})
 
    g.labels = keys
		g.write("#{RAILS_ROOT}/public/images/stats.png")
    #send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "site-stats.png")
  end
end
