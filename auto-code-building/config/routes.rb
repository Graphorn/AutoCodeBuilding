Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # 

  post "users/regist" => "users#regist"
  post "users/login" => "users#login"
  post "projects/addproject" => "projects#addProject"
  get "projects/getprojects" => "projects#getProjects"
  get "users/getusers" => "users#getUsers"
  get "buildinfos/getBuildInfo" => "buildinfos#getBuildInfo"
  post "projects/delproject" => "projects#delProject"

  get '/' => "application#index"
  post 'push/info'
  get 'push/info'
  
  get "users/github_oauth" => "users#gitubOAuth"
  
  get "users/test" => "users#test"
end
