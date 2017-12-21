class ProjectsController < ApplicationController
    skip_before_action :verify_authenticity_token
    # 添加项目
    def addProject
        @userName = params[:username]
        @projectName = params[:project_name]
        @projectUrl = params[:project_url]
        @project = Project.new
        @project.user_name = @userName
        @project.project_name = @projectName
        @project.project_url = @projectUrl
        @project.author = params[:author]
        @project.buildinfo_num = 0
        if @project.save
            @user = User.find_by(user_name:@userName)
            @user.projects_num = @user.projects_num + 1
            @user.save
            render json: "{\"status\": 1, \"id\": \"#{@project.id}\", \"message\": \"\"}"
        else 
            render json: "{\"status\": 0, \"id\": \"\", \"message\": \"\"}"
        end 
    end
    
    # 获取项目列表
    def getProjects
        @user = User.find_by(user_name: params[:username])
        # @projects = Project.where(user_name: @user.user_name)
        if @user.user_type == "0"
            @projects = Project.where(user_name: @user.user_name)
        else 
            @projects = Project.all
        end
        # @projects = Project.all
        @projectsJson = @projects.to_json
        render json: "{\"status\": 1, \"user_type\": \"\", \"message\": \"\", \"projectList\": #{@projectsJson}}"
    end
    
    # 删除项目
    def delProject
        @userName = params[:user_name]
        @projectName = params[:project_name]
        @project = Project.find_by(user_name:@userName, project_name:@projectName)
        if @project.destroy
            @user = User.find_by(user_name:@userName)
            @user.projects_num = @user.projects_num - 1
            @user.save
            render json: "{\"status\": 1, \"message\": \"删除成功\"}"
        else
            render json: "{\"status\": 0, \"message\": \"删除失败\"}"
        end
    end
end
