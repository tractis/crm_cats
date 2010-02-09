ActionController::Routing::Routes.draw do |map| 
  map.namespace :admin do |admin|
    admin.resources :cats, :collection => { :search => :get, :auto_complete => :post }, :member => { :confirm => :get, :changetype => :get, :add_child => :get }
  end  
end