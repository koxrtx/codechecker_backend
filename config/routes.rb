Rails.application.routes.draw do
  get "mypages/sho"
  get "posts/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "posts#index"
  resources :users
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy", as: "logout"
  get "/signup", to: "users#new"
  get "problem/select", to: "openai/problems#select", as: "problem_select"

  # Openai::Controller を使うためのグループ化
  namespace :openai do
    # Ruby用
    get  "ruby/daily",   to: "ruby_problems#daily",   as: "ruby_problem"
    post "ruby/answer",  to: "ruby_problems#answer",  as: "ruby_problem_answer"
    get  "ruby/result",  to: "ruby_problems#result",  as: "ruby_problem_result"

    # SQL用
    get  "sql/daily",    to: "sql_problems#daily",    as: "sql_problem"
    post "sql/answer",   to: "sql_problems#answer",   as: "sql_problem_answer"
    get  "sql/result",   to: "sql_problems#result",   as: "sql_problem_result"
  end

  # 管理者画面
  namespace :admin do
    resources :problems, only: [:index, :show, :destroy]
  end
end
