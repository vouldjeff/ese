ActionController::Routing::Routes.draw do |map| 

  map.calendar 'courses/:course_id/calendar/:year/:month', :controller => 'calendar', :action => 'index', :year => Time.now.utc.year, :month => Time.now.utc.month
   
  map.resources :courses
  map.resources :assets

  map.signup 'signup', :controller => 'users', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.resources :user_sessions

  map.resources :users

  map.root :courses

  map.participants 'courses/:course_id/participants', :controller => 'participants', :action => 'new'
  map.participant_create 'courses/:course_id/participants/create', :controller => 'participants', :action => 'create'
  map.participant_destroy 'courses/:course_id/participants/:id/destroy', :controller => 'participants', :action => 'destroy'

  map.courses 'courses', :controller => 'courses', :action => 'index'
  map.course_view 'courses/:id', :controller => 'courses', :action => 'show'
  map.course_new 'courses/actions/new', :controller => 'courses', :action => 'new'
  map.course_create 'courses/actions/create', :controller => 'courses', :action => 'create'
  map.course_other 'courses/:id/:action', :controller => 'courses'

  map.material_view 'courses/:course_id/materials/:id', :controller => 'materials', :action => 'show'
  map.material_new 'courses/:course_id/materials/actions/new', :controller => 'materials', :action => 'new'
  map.material_create 'courses/:course_id/materials/actions/create', :controller => 'materials', :action => 'create'
  map.material_other 'courses/:course_id/materials/:id/:action', :controller => 'materials'
  
  map.event_view 'courses/:course_id/events/:id', :controller => 'events', :action => 'show'
  map.event_new 'courses/:course_id/events/actions/new', :controller => 'events', :action => 'new'
  map.event_create 'courses/:course_id/events/actions/create', :controller => 'events', :action => 'create'
  map.event_other 'courses/:course_id/events/:id/:action', :controller => 'events'

  map.news_create 'courses/:course_id/news/actions/create', :controller => 'news', :action => 'create'
  map.news_destroy 'courses/:course_id/news/:id/destroy', :controller => 'news', :action => 'destroy'

  map.test_view 'courses/:course_id/tests/:id', :controller => 'tests', :action => 'show'
  map.test_new 'courses/:course_id/tests/actions/new', :controller => 'tests', :action => 'new'
  map.test_create 'courses/:course_id/tests/actions/create', :controller => 'tests', :action => 'create'
  map.test_edit 'courses/:course_id/tests/:id/edit', :controller => 'tests', :action => 'edit'
  map.test_other 'courses/:course_id/tests/:id/:action', :controller => 'tests'

  map.roles 'roles', :controller => 'users', :action => 'edit'
  map.roles_update 'roles/update', :controller => 'users', :action => 'update'
  map.users_all 'users/index2', :controller => 'users', :action => 'index2'

  map.connect ':controller/:action/:id'
end
