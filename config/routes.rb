
Rails.application.routes.draw do
  resources :users, except: [:new, :edit] 
    resources :courses, only: [:index, :create, :show, :update, :destroy]
        resources :chapters, except: [:new, :edit]
        resources :practice_questions, except: [:new, :edit]
        resources :subscriptions, only: [:index, :create, :show] 
  end


























#          root "users#index"

#          resources :users, :courses, :chapters , :practice_questions , :subscriptions
# end 
# Rails.application.routes.draw do
#   resources :users, except: [:new, :edit] do
#     collection do
#       get 'students', to: 'users#students'
#       get 'teachers', to: 'users#teachers'
#     end 
  
#     resources :courses, only: [:index,:create, :show, :update, :destroy] do
#       resources :chapters, only: [:index,:create, :show, :update, :destroy] 
#       resources :practice_questions, only: [:index,:create, :show, :update, :destroy]
#       resources :subscriptions, only: [:index,:create,:show]
#     end 
#   end
#   