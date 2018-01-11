require 'rest-client'
require 'json'
require "open-uri"
class ProjectsController < ApplicationController
    skip_before_action :verify_authenticity_token
    protect_from_forgery with: :exception
    # 添加项目
    def addProject
        @userName = params[:username]
        @projectName = params[:project_name]
        @projectUrl = params[:project_url]
        @author = params[:author]
        print @userName
        print @projectName
        print @projectUrl
        # 验证URL
        @html_response = []
        begin
            open(@projectUrl) do |http| 
                print http.status
                @html_response = http.status
            end 
        rescue
            @html_response[0] = "404"
        end
        
        if @html_response[0] == "200"
            # 判断project是否存在
            @project = Project.find_by(project_name: @projectName, project_url: @projectUrl, author: @author)
            if @project == nil
                @project = Project.new
                @project.project_name = @projectName
                @project.project_url = @projectUrl
                @project.author = @author
                @builds = Buildinfo.where(author: @author, project: @projectName)
                @project.buildinfo_num_all = @builds.size.to_s
                @project.users = ""
                @project.save
            end
            
            @user = User.find_by(user_name: @userName)
            if not @user.projects.include? @project.id.to_s
                @user.projects_num = (@user.projects_num.to_i + 1).to_s
                if @user.projects == ""
                    @user.projects = @project.id.to_s
                else
                    @user.projects = @user.projects + "," + @project.id.to_s
                end
                @user.save
                
                print @project.users
                print @userName
                if @project.users == nil
                    @project.users = ""
                end 
                if @project.users == ""
                    @project.users = @userName
                else
                    @project.users = @project.users + "," + @userName
                end
                @project.save
                render json: "{\"status\": 1, \"id\": \"#{@project.id}\", \"message\": \"添加成功\"}"
            else
                render json: "{\"status\": 0, \"id\": \"#{@project.id}\", \"message\": \"请勿重复添加\"}"
            end
        else
            render json: "{\"status\": 0, \"id\": \"\", \"message\": \"项目地址不存在\"}"
        end
    end
    
    # 获取项目列表
    def getProjects
        @user = User.find_by(user_name: params[:username])
        @projects = []
        print params[:username]+"dd"
        if @user.user_type == "0"
            @projectIds = @user.projects.split(",")
            @projectIds.each do |projectId|
                print projectId
                @projects.insert(0, Project.find_by(id: projectId.to_i))
            end
        else 
            @projects = Project.all
        end
        # @projects = Project.all
        print @projects.size
        @projectsJson = @projects.to_json
        print @projectsJson
        render json: "{\"status\": 1, \"user_type\": \"#{@user.user_type}\", \"message\": \"\", \"projectList\": #{@projectsJson}}"
    end
    
    # 删除项目和用户的关联，如果项目关联的用户为空，则删除项目
    def delProject
        @userName = params[:user_name]
        @projectName = params[:project_name]
        @author = params[:author]
        puts @userName
        puts @projectName
        puts @author
        @project = Project.find_by(author:@author, project_name:@projectName)
        @user = User.find_by(user_name:@userName)
        if @user.projects.include? @project.id.to_s
            # 改变user表中projects的值
            @newProjects = []
            @projects = @user.projects.split(",")
            @projects.each do |i|
                if not i == @project.id.to_s
                    @newProjects.insert(0, i)
                end
            end
            @user.projects = @newProjects.join(",")
            @user.projects_num = (@user.projects_num.to_i - 1).to_s
            @user.save
            # 改变project表中users的值
            @newUsers = []
            @users = @project.users.split(",")
            @users.each do |i|
                if not i == @user.user_name
                    @newUsers.insert(0, i)
                end
            end
            @project.users = @newUsers.join(",")
            @project.save
            
        end
        print @project.users
        # if @project.users == ""
        #     @project.destroy
        # end
        render json: "{\"status\": 1, \"message\": \"删除成功\"}"
    end
    
end
