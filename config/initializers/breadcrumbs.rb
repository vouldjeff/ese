Breadcrumb.configure do
  
  crumb :root, I18n.t('courses'), :courses_path
  crumb :login, I18n.t('courses'), :login_path

  crumb :courses, '#{@course.name}', :course_view_path
  crumb :courses_, '#{@material.course.name}', :course_view_path, '@material.course'
  crumb :courses__, '#{@test.course.name}', :course_view_path, '@test.course'
  crumb :courses___, '#{@course.name}', :course_view_path, '@course'
  crumb :coursess, '#{@event.course.name}', :course_view_path, '@event.course'
  crumb :course_new, I18n.t('new_course'), :course_new_path
  crumb :course_edit, I18n.t('edit_course') + ' - #{@course.name}', :course_other_path, :params => { :action => 'edit' }

  crumb :materials, I18n.t('materials') + ' - #{@material.name}', :material_view_path
  crumb :material_new, I18n.t('new_material'), :material_new_path
  crumb :material_edit, I18n.t('edit_material') + ' - #{@material.name}', :material_other_path, :params => { :action => 'edit'}
  
  crumb :events, I18n.t('events') + ' - #{@event.name}', :event_view_path
  crumb :event_new, I18n.t('new_event'), :event_new_path
  crumb :event_edit, I18n.t('edit_event') + ' - #{@event.name}', :event_other_path, :params => { :action => 'edit'}

  crumb :tests, I18n.t('tests') + ' - #{@test.name}', :test_view_path
  crumb :test_new, I18n.t('new_test'), :test_new_path
  crumb :test_edit, I18n.t('edit_test') + ' - #{@test.name}', :test_edit_path
  crumb :test_step1, I18n.t('step1'), :test_edit_path
  crumb :test_step2, I18n.t('step2'), :test_other_path, :params => { :action => 'step2' }
  crumb :test_step3, I18n.t('step3'), :test_other_path, :params => { :action => 'step3' }
  crumb :test_doit, I18n.t('doit'), :test_other_path, :params => { :action => 'doit' }

  crumb :participants, I18n.t('participants'), :participants_path

  crumb :roles, I18n.t('roles'), :roles_path
  crumb :calendar, I18n.t('calendar'), :calendar_path

  # Specify controller, action, and an array of the crumbs you specified above
  trail :courses, :index, [:root]

  trail :user_sessions, :new, [:login]

  trail :courses, :show, [:root, :courses]
  trail :courses, :new, [:root, :course_new]
  trail :courses, :create, [:root, :course_new]
  trail :courses, :edit, [:root, :course_edit]
  trail :courses, :update, [:root, :course_edit]

  trail :events, :show, [:root, :coursess, :events]
  trail :events, :new, [:root, :courses___, :event_new]
  trail :events, :create, [:root, :courses___, :event_new]
  trail :events, :edit, [:root, :coursess, :event_edit]
  trail :events, :update, [:root, :coursess, :event_edit]
  
  trail :materials, :show, [:root, :courses_, :materials]
  trail :materials, :new, [:root, :courses___, :material_new]
  trail :materials, :create, [:root, :courses___, :material_new]
  trail :materials, :edit, [:root, :courses_, :material_edit]
  trail :materials, :update, [:root, :courses_, :material_edit]

  trail :tests, :show, [:root, :courses__, :tests]
  trail :tests, :new, [:root, :courses___, :test_new]
  trail :tests, :create, [:root, :courses___, :test_new]
  trail :tests, :edit, [:root, :courses__, :test_edit]
  trail :tests, :update, [:root, :courses__, :test_edit]
  trail :tests, :new, [:root, :courses__, :test_new, :test_step1]
  trail :tests, :edit, [:root, :courses__, :test_edit, :test_step1]
  trail :tests, :step2, [:root, :courses__, :test_edit, :test_step1, :test_step2]
  trail :tests, :step3, [:root, :courses__, :test_edit, :test_step1, :test_step2, :test_step3]
  trail :tests, :doit, [:root, :courses__, :test_doit]

  trail :participants, :new, [:root, :courses___, :participants]
  
  trail :calendar, :index, [:root, :courses___, :calendar]

  trail :users, :edit, [:root, :roles]


  delimit_with " <span>/</span> "
  dont_link_last_crumb
end