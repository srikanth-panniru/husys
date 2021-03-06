Husys::Application.routes.draw do
  devise_for :users , :controllers => { :sessions => 'sessions' }

  #authenticated :user do
  # devise_scope :user do
  #   root to: "sessions#new"
  # end
  #end
  resources :users

  get "courses/hierarchy" => "courses#hierarchy"

  resources :courses do
    collection do
      get 'search'
    end
    resources :descriptive_questions do
      collection do
        get 'xls_template_descriptive'
      end
    end
    resources :questions do
      collection do
        get 'upload_new'
        post 'upload'
        get 'xls_template'
      end
    end
  end

  resources :exam_centers do
    member do
      get "machine_availability"
      get "today_exams"
    end
    resources :machines
  end

  resources :registrations do
    member do
      get "exam"
      post "exam"
      get "review_exam"
      get "submit_exam"
      get "init_registration_show"
      post "validate_exam_entrance"
    end
    collection do
      get "avalable_slots"
    end
  end

  get 'auto_search/autocomplete_course_category'
  get 'auto_search/autocomplete_course_sub_category'
  get 'auto_search/autocomplete_course_course_name'
  get 'auto_search/autocomplete_course_exam_name'
  get 'auto_search/autocomplete_exam_center_center_name'
  get 'auto_search/autocomplete_user_user_id'
  get 'auto_search/autocomplete_user_user_info'
  get 'auto_search/autocomplete_registration_registration_id'

  get "home/exam_centers_geo" => "home#exam_centers_geo"


  root :to => 'home#landing'
end
