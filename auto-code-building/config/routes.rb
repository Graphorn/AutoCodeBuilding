Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "users/regist" => "users#regist"
  post "users/login" => "users#login"
  post "users/addproject" => "users#addProject"
  get "users/getprojects" => "users#getProjects"
  get "users/getusers" => "users#getUsers"
  get "buildinfos/getBuildInfo" => "buildinfos#getBuildInfo"
end
