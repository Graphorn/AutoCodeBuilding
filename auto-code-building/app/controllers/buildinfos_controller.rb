class BuildinfosController < ApplicationController
    skip_before_action :verify_authenticity_token
    # protect_from_forgery with: :exception
    # 获取build信息，log,author(github 作者),user_name,project,branch,commit_url,commmit_msg,build_time,build_status
    def getBuildInfo
        @buildInfos = Buildinfo.where(project: params[:project_name], author: params[:author])
        #@buildInfos = Buildinfo.all
        if @buildInfos
            render json: "{\"status\": 1, \"message\": \"\", \"buildinfoList\": #{@buildInfos.to_json}}"
        else
            render json: "{\"status\": 0, \"user_type\": \"\", \"message\": \"查询失败\", \"buildinfoList\": \"\"}"
        end
    end
    
    # 添加build信息，通过post请求
    def addBuildinfo
        @userName = params[:username]
        @projectName = params[:project_name]
        if User.find_by(user_name:@userName) and Project.find_by(project_name:@projectName)
            @buildInfo = Buildinfo.new
            @buildInfo.user_name = @userName
            @buildInfo.loginfo = params[:log_info]
            @buildInfo.project = @projectName
            @buildInfo.author = params[:author]
            @buildInfo.branch = params[:branch]
            @buildInfo.commit_url = params[:commit_url]
            @buildInfo.commmit_msg = params[:commit_msg]
            @buildInfo.build_time = params[:build_time]
            @buildInfo.build_status = params[:build_status]
            if @buildInfo.save
                @user = User.find_by(user_name:@userName)
                if @user.buildinfos_num == nil
                    @user.buildinfos_num = 0
                end
                @user.buildinfos_num = @user.buildinfos_num + 1
                @user.save
                @project = Project.find_by(project_name:@projectName)
                if @project.buildinfo_num == nil
                    @project.buildinfo_num = 0 
                end
                @project.buildinfo_num = @project.buildinfo_num + 1
                @project.save
                render json: "{\"status\": 1, \"id\": \"#{@buildInfo.id}\", \"message\": \"添加build信息成功\"}"
            else 
                render json: "{\"status\": 0, \"id\": \"\", \"message\": \"\"}"
            end 
        else 
            render json: "{\"status\": 0, \"message\": \"用户或项目不存在\"}"
        end
    end
    
    # 添加build信息
    def addBuild(user_name, project_name, log_info, author,branch,commit_url, commit_msg, build_status)
        @userName = user_name
        @projectName = project_name
        if User.find_by(user_name:@userName) and Project.find_by(project_name:@projectName)
            @buildInfo = Buildinfo.new
            @buildInfo.user_name = @userName
            @buildInfo.loginfo = log_info
            @buildInfo.project = @projectName
            @buildInfo.author = author
            @buildInfo.branch = branch
            @buildInfo.commit_url = commit_url
            @buildInfo.commmit_msg = commit_msg
            @buildInfo.build_status = build_status
            @buildInfo.build_time = Time.new
            if @buildInfo.save
                @user = User.find_by(user_name:@userName)
                if @user.buildinfos_num == nil
                    @user.buildinfos_num = 0
                end
                @user.buildinfos_num = @user.buildinfos_num + 1
                @user.save
                @project = Project.find_by(project_name:@projectName)
                if @project.buildinfo_num == nil
                    @project.buildinfo_num = 0 
                end
                @project.buildinfo_num = @project.buildinfo_num + 1
                @project.save
                return 1
            else 
                return 0
            end 
        else 
            return 0
        end
    end
    
    # 删除build信息
    def delBuildinfo
        @buildId = params[:build_id]
        @buildinfo = Buildinfo.find_by(id:@buildId)
        if @buildinfo.destroy
            @user = User.find_by(user_name: @buildinfo.user_name)
            @user.buidinfos_num = @user.buildinfos_num - 1
            @user.save
            @project = Project.find_by(project_name: @buildinfo.project_name)
            @project.buildinfo_num = @project.buildinfo_num - 1
            @project.save
            render json: "{\"status\": 1, \"message\": \"删除成功\"}"
        else
            render json: "{\"status\": 0, \"message\": \"删除失败\"}"
        end
    end
end
