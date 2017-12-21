class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token
    
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
    
    
end
