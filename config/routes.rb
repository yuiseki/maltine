ActionController::Routing::Routes.draw do |map|

  # map.connect 'home', :controller => "index", action => "home"

  map.connect 'input', :controller => "index", :action => "input"
  map.connect 'downloader', :controller => "index", :action => "downloader"

  map.connect 'fetch_zip/:filename.zip', :controller => "index", :action => "fetch_zip"

  #map.connect ':login', :controller => "index", :action => "user"
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'


end
