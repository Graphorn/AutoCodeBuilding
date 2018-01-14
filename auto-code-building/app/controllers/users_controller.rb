require 'sinatra'
require 'rest-client'
require 'json'

require 'net/https'
require 'uri'
class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token
    # protect_from_forgery with: :exception
    
    # 注册 
    def regist
        @user = User.new
        @user.user_name = params[:username]
        @user.user_type = params[:user_type]
        if @user.user_type == nil
            @user.user_type = "0"
        end
        @user.pwd = params[:password]
        if User.find_by(user_name:@user.user_name) 
            render json: "{\"status\": 0, \"id\": \"\", \"message\": \"用户已存在\"}"
        end
        if @user.save
            render json: "{\"status\": 1, \"id\": \"#{@user.id}\", \"message\": \"注册成功\"}"
        else 
            render json: "{\"status\": 0, \"id\": \"\", \"message\": \"\"}"
        end 
            
    end
    
    # 登录
    def login
        @user = User.find_by(user_name: params[:username])
        if @user == nil
            render json: "{\"status\": 0, \"user_type\": \"\", \"message\": \"用户名不存在\", \"projects\": \"[]\"}"
        else
            if @user.pwd == params[:password]
                # 时区问题
                @user.last_login = Time.now
                @user.save
                if @user.user_type == "0"
                    @projects = Project.find_by(author: @user.user_name)
                else 
                    @projects = Project.all
                end
                @projectsJson = @projects.to_json
                render json: "{\"status\": 1, \"user_type\": #{@user.user_type}, \"message\": \"\", \"projects\": #{@projectsJson}}"
            else
                render json: "{\"status\": 0, \"user_type\": #{@user.user_type}, \"message\": \"密码错误\", \"projectList\": \"[]\"}"
            end
        end 
    end
    
    
    
    # 查看所有用户，不包括管理员，用户名，上次登录时间，用户项目总数，build总数
    def getUsers
        @users = User.where(user_type: "0")
        if @users == nil
            render json: "{\"status\": 0, \"userList\": \"[]\"}"
        else
            render json: "{\"status\": 1, \"userList\": #{@users.to_json}}"
        end
    end
    
    # GitHub第三方服务验证重定向地址
    def gitubOAuth
        @code = params[:code]
        print @code
        @result = RestClient.post('https://github.com/login/oauth/access_token',
                          {:client_id => "b19afefbbe329468fd6d",
                           :client_secret => "a3e0b3b202e333a127825806ac6d493833484282",
                           :code => @code},
                           :accept => :json)
        print @result
                           
        # extract the token and granted scopes
        @access_token = JSON.parse(@result)['access_token']
        @scopes = JSON.parse(@result)['scope'].split(',')
        has_user_email_scope = @scopes.include? 'user:email'
        @auth_result_json = ""
        if has_user_email_scope
            @auth_result_json = RestClient.get('https://api.github.com/user',
                                   {:params => {:access_token => @access_token},
                                    :accept => :json})
        end
        print @auth_result_json
        @auth_result = JSON.parse(@auth_result_json)
        @userIn = User.find_by(user_name: @auth_result['login'])
        print @userIn
        if @userIn == nil
            print "ff"
            @user = User.new
            @user.user_name = @auth_result['login']
            @user.user_type = "0"
            @user.last_login = Time.now
            @user.projects = ""
            @user.projects_num = "0"
            @user.buildinfos_num = "0"
            @user.imgurl = @auth_result['avatar_url']
            @user.save
            @userIn = @user
        else
            @userIn.last_login = Time.now
            @userIn.save
        end
        
        # render file: 'public/dist/index.html'
        
        # set cookie
        print "login=#{@auth_result['login']}"
        response["set-cookie"] = "profile=#{@auth_result['login']}&imgurl=#{@auth_result['avatar_url']}; path=/;"
        redirect_to "/"
    end
    
    def test
        
        # require "open-uri" #如果有GET请求参数直接写在URI地址中 
        # uri = 'https://github.com/seektech/AutoCodeBuilding.git' 
        # html_response = nil 
        # open(uri) do |http| 
        #     html_response = http.status
        # end 
        # print "dd"
        # print html_response[0] + "dfd"
        
        # print Project.find_by(id: 18).id
        # @ps = []
        # @ps.insert(0, Project.find_by(id: 18))
        # print @ps.size
    
        # @users = User.all
        # @users.each do |i|
        #     i.destroy
        # end
        # @projects = Project.all
        # @projects.each do |i|
        #     i.destroy
        # end
        # @buildinfos = Buildinfo.all
        # @buildinfos.each do |i|
        #     i.destroy
        # end
        # print "destroy"
        # @userss = User.all
        # print @userss.size
        
        # @user = User.find_by(user_name: "husterxsp")
        # @user.projects = "18"
        # @user.save
        
        # @user = User.new
        # @user.user_name = "admin"
        # @user.user_type = "1"
        # if @user.user_type == nil
        #     @user.user_type = "0"
        # end
        # @user.pwd = "admin"
        # @user.save
        
        # Project.all.each do |i|
        #     i.destroy
        # end
        # @user = User.find_by(user_name: "husterxsp")
        # print @user.projects
        # @user.projects = ""
        # @user.save
        
        @buildInfos = Buildinfo.where(author: "husterxsp", project: "RubyTest")
        print @buildInfos.size
        render json: ""
        
    end
end

# {"login":"husterxsp","id":6826670,"avatar_url":"https://avatars3.githubusercontent.com/u/6826670?v=4","gravatar_id":"","url":"https://api.github.com/users/husterxsp","html_url":"https://github.com/husterxsp","followers_url":"https://api.github.com/users/husterxsp/followers","following_url":"https://api.github.com/users/husterxsp/following{/other_user}","gists_url":"https://api.github.com/users/husterxsp/gists{/gist_id}","starred_url":"https://api.github.com/users/husterxsp/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/husterxsp/subscriptions","organizations_url":"https://api.github.com/users/husterxsp/orgs","repos_url":"https://api.github.com/users/husterxsp/repos","events_url":"https://api.github.com/users/husterxsp/events{/privacy}","received_events_url":"https://api.github.com/users/husterxsp/received_events","type":"User","site_admin":false,"name":"Shaopeng Xu","company":null,"blog":"http://husterxsp.github.io/","location":null,"email":"husterxsp@gmail.com","hireable":true,"bio":null,"public_repos":29,"public_gists":0,"followers":17,"following":37,"created_at":"2014-03-01T19:16:12Z","updated_at":"2018-01-04T13:06:56Z"}Completed 200 OK in 1647ms (Views: 0.2ms)