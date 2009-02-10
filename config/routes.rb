ActionController::Routing::Routes.draw do |map|

	include Translate

	map.aliases :resources, :projects => t('routes.resources.projects'),
							:comments => t('routes.resources.comments'),
							:tasks => t('routes.resources.tasks'),
							:clients => t('routes.resources.clients'),
							:users => t('routes.resources.users')

	map.aliases :actions,	:new => t('routes.actions.new'),
  											:edit => t('routes.actions.edit'),
												:suspend => t('routes.actions.suspend'),
												:unsuspend => t('routes.actions.unsuspend'),
												:close => t('routes.actions.close'),
												:open => t('routes.actions.open'),
												:logout => t('routes.actions.logout'),
												:join => t('routes.actions.login'),
												:profile => t('routes.actions.profile'),
												:activate => t('routes.actions.activate')
	
	map.resources :projects, :has_many => :tasks do |project|
		project.resources :tasks,	 	:has_many => :comments,
																:member => { :close => :get, :open => :get }
	end
	
	map.stats "#{t('routes.actions.stats')}", :controller => 'home', :action => 'stats'
  map.logout "#{t('routes.actions.logout')}", :controller => 'users', :action => 'logout'
  map.login "#{t('routes.actions.login')}", :controller => 'users', :action => 'login'
  map.register "#{t('routes.actions.register')}", :controller => 'users', :action => 'new'
  map.profile "#{t('routes.actions.profile')}", :controller => 'users', :action => 'show'
	map.activate "#{t('routes.actions.activate')}/:activation_code", :controller => 'users', :action => 'activate', :activation_code => nil

  map.resources :clients
  map.resources :comments
  map.resources :tasks
	map.resources :users, :member => {		:forceactivate => :get,
																				:suspend   => :get,
																				:unsuspend => :get,
																				:purge     => :delete }

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
