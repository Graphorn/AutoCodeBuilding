class UsersController < ApplicationController
    # 注册 
    def regist
        @user = User.new
        @user.user_name = params[:user_name]
        @user.user_type = params[:user_type]
        @user.pwd = params[:pwd]
        if @user.save
            render json: "{\"status\": \"1\", \"id\": \"#{@user.id}\", \"message\": \"\"}"
        else 
            render json: "{\"status\": \"0\", \"id\": \"\", \"message\": \"\"}"
        end 
            
    end
    
    # 登录
    def login
        @user = User.find_by(user_name: params[:user_name])
        if @user == nil
            render json: "{\"status\": \"0\", \"user_type\": \"\", \"message\": \"用户名错误\", \"projects\": \"[]\"}"
        end
        
        if @user.pwd == params[:pwd]
            if @user.user_type == "0"
                @projects = Projects.find_by(author: @user.user_name)
            else 
                @projects = Projects.all
            end
            @projectsJson = @projects.as_json
            render json: "{\"status\": \"1\", \"user_type\": \"\", \"message\": \"\", \"projects\": \"#{projectsJson}\"}"
        else
            render json: "{\"status\": \"0\", \"user_type\": \"\", \"message\": \"密码错误\", \"projects\": \"[]\"}"
        end
    end
    
    # 查看所有用户，不包括管理员
    def getUsers
        @users = User.find_by(user_type: "0")
        if @users == nil
            render json: "{\"status\": \"0\", \"userList\": \"[]\"}"
        else
            render json: "{\"status\": \"0\", \"userList\": \"#{@users.as_json}\"}"
        end
    end
    
    # 添加项目
    def addProject
        @userName = params[:user_name]
        @projectName = params[:project_name]
        @projectUrl = params[:project_url]
        @project = Project.new
        @project.author = @userName
        @project.project_name = @projectName
        @project.project_url = @projectUrl
        if @project.save
            render json: "{\"status\": \"1\", \"id\": \"#{@project.id}\", \"message\": \"\"}"
        else 
            render json: "{\"status\": \"0\", \"id\": \"\", \"message\": \"\"}"
        end 
    end
end
