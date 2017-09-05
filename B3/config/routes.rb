Rails.application.routes.draw do


  # 首页
  root 'posts#index'

  # 用户相关路由
  get '/signup', to: 'users#signup'
  post '/signup', to: 'users#signup'
  get '/login', to: 'users#login'
  post '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  get '/profile', to: 'users#show'
  patch '/profile', to: 'users#update'

  # 管理员增删改博文路由
  scope '/admin' do
    resources :posts, except: [:index, :show]
  end

  get '/admin/posts', to: 'posts#admin_index'


  get '/posts/:id', to: 'posts#show', as: :show_post


  get '/admin/comments/:id', to: 'comments#destroy'

  #get '/admin/posts/:id/comments', to: 'post#show_comments', as: :admin_comments

  get '/admin/delete/posts/:id',  to: 'posts#destroy',as: :delete_post

  get '/admin/posts/:id', to: 'posts#edit'
  
  post '/posts/:id/comments', to: 'comments#create', as: :create_post_comment

  #feedback
  get '/feedback', to: 'feedbacks#create', as: :create_feedback

  post '/feedback', to: 'feedbacks#create'
  
  get '/admin/check/feedback', to: 'feedbacks#check', as: :check_feedback

  scope '/admin' do
    resources :comments, only: [:destroy]
  end

  scope '/admin' do
    resources :feedbacks, only: [:check]
  end
  
end
