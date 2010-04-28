authorization do
  role :admin do
    has_permission_on [:courses, :materials, :tests, :events], :to => [:show, :new, :create, :edit, :update, :destroy]
    has_permission_on :courses, :to => [:index, :progress]
    has_permission_on :tests, :to => [:step2, :step2_update, :step3, :step3_update]
    has_permission_on :participants, :to => [:new, :create, :destroy]
    has_permission_on :tests, :to => [:doit]
    has_permission_on :users, :to => [:index, :index2, :new, :create, :edit, :update]
    has_permission_on :news, :to => [:create, :destroy]
    has_permission_on :assets, :to => [:show, :destroy]
    has_permission_on :calendar, :to => [:index]
  end

  role :student do
    has_permission_on [:courses], :to => [:index]
    has_permission_on [:courses], :to => [:show] do
      if_attribute :users => contains { user }
    end
    
    has_permission_on [:materials], :to => [:show] do
      if_permitted_to :show, :course
    end
    
    has_permission_on [:events], :to => [:show] do
      if_permitted_to :show, :course
    end

    has_permission_on :tests, :to => [:show, :doit] do
      if_permitted_to :show, :course
    end
    
    has_permission_on :calendar, :to => [:index] do
      if_permitted_to :show, :course
    end
    
    has_permission_on :assets, :to => [:show] do
      if_attribute :attachable => { :course => { :users => contains { user } } }
    end
  end

  role :teacher do
    includes :student
    
    has_permission_on [:courses], :to => [:edit, :update] do
      if_attribute :users => contains { user }
    end

    has_permission_on :news, :to => [:create, :destroy] do
      if_permitted_to :edit, :course
    end

    has_permission_on [:materials, :tests, :events], :to => [:new, :create, :edit, :update, :destroy] do
      if_permitted_to :edit, :course
    end
    
    has_permission_on :tests, :to => [:step2, :step2_update, :step3, :step3_update] do
      if_permitted_to :edit, :course
    end

    has_permission_on :participants, :to => [:new, :create, :destroy] do
      if_permitted_to :edit, :course
    end

    has_permission_on :news, :to => [:create, :destroy] do
      if_permitted_to :edit, :course
    end
    
    has_permission_on :assets, :to => [:show, :destroy] do
      if_attribute :attachable => { :course => { :users => contains { user } } }
    end
  end

  role :guest do
    has_permission_on :users, :to => [:new, :create]
  end
end
