CrowdCourse::Application.routes.draw do

  get "comments/new"

  resources :s3_uploads

  get "search/index"

  # Root

  root :to => 'dynamic_pages#index'

  # Gems and configured routes

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks", 
                                    :registrations => "registrations"}

  match 'courses/:id/settings' => 'courses#info_settings'
  match 'courses/:id/settings/info' => 'courses#info_settings'
  match 'courses/:id/settings/contributors' => 'courses#contributors_settings'
  match 'courses/:id/settings/maintainers' => 'courses#maintainers_settings'
  match 'courses/:id/settings/syllabus' => 'courses#syllabus_settings'

  # Named routes

  match '/profile' => 'users#show', :as => 'profile'
  match 'my_courses' => 'users#courses'

  match 'privacy_settings' => 'users#privacy_settings'
  match 'update_user_privacy_settings' => 'users#update_privacy'
  match 'donation_settings' => 'users#donation_settings'
  match 'update_user_donation_settings' => 'users#update_donation_settings'

  match '/style-tests' => 'static_pages#styleTests'
  match '/about' => 'static_pages#about'
  match '/contact' => 'static_pages#contact'
  match '/legal' => 'static_pages#legal'
  match '/guidelines' => 'static_pages#community_guidelines'
  match '/video_guidelines' => 'static_pages#video_guidelines'
  match '/news' => 'static_pages#news'

  match '/home' => 'dynamic_pages#home'
  match '/landing' => 'dynamic_pages#landing'
  match '/learn' => 'dynamic_pages#learn'
  match '/teach' => 'dynamic_pages#teach'

  match '/search' => 'search#index'

  # Ajax and forms

  match '/check_answer/:question_id/:value' => 'quizzes#check_answer'
  match '/quizzes/:id/get_questions' => 'quizzes#get_questions'
  match '/quizzes/:id/complete/:score' => 'quizzes#complete_quiz'
  match '/video_view_complete' => 'videos#video_view_complete'
  match '/video_view' => 'videos#video_view'
  match '/rate_video' => 'videos#rate'
  match 'destroy_component' => 'components#destroy'
  match 'change_section' => 'components#change_section'
  match 'destroy_section' => 'sections#destroy'
  match 'destroy_course_with_confirmation' => 'courses#destroy_with_confirmation'
  match 'add_maintainer' => 'courses#add_maintainer'
  match 'destroy_choice' => 'quiz_choices#destroy'

  match 'users/update_description' => 'users#update_description'
  match 'mailing_list_members/create' => 'mailing_list_members#create'
  match 'videos/create_from_url' => 'videos#create_from_url'
  match 'videos/create_from_file' => 'videos#create_from_file'

  # Resources

  resources :categories, only: [:show, :index]
  resources :courses
  resources :sections, except: [:index]
  resources :components, except: [:index] do
    collection { post :sort }
  end

  resources :videos, except: [:update, :edit]
  resources :comments
  resources :quizzes
  resources :field_questions, except: [:index, :show]
  resources :choice_questions, except: [:index, :show]
  resources :quiz_choices, except: [:index, :show]

  resources :users, only: [:show, :update]

  resources :mailing_list_members, only: [:new, :create]


  # Robots

  match '/robots.txt' => 'application#robots'

  
  # for lulz

  match '/teapot' => 'application#teapot'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
