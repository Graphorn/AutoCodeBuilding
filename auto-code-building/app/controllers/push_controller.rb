require "net/http"
require "uri"
class PushController < ApplicationController
    skip_before_action :verify_authenticity_token
    def info
        # @word = "Hello World"
        # puts word
        url = "https://github.com/" + params[:repository][:full_name] +"/"
        dirname = "test"+Random.rand(1000).to_s
        # puts url,dirname
        require 'open3'
        command1 = "sh compile.sh " + url + " " + dirname
        # puts command1
        logs = ""
        Open3.popen3(command1) do |stdin, stdout, stderr|
        #     # puts "a."
            stderr.each_line {|line| logs << line.chomp }
        end
        #     # puts "b."
        #     # stdout.each_line { |line| puts line }
        # puts "stderr"
        # puts stderr.gets
        #发送post请求
        # post_params = {}  
        # @userName = params[:user_name]
        # @projectName = params[:project_name]
        # if User.find_by(user_name:@userName) and Project.find_by(project_name:@projectName)
        #     @buildInfo = Buildinfo.new
        #     @buildInfo.user_name = @userName
        #     @buildInfo.loginfo = params[:log_info]
        #     @buildInfo.project = @projectName
        #     @buildInfo.project_url = params[:project_url]
        #     @buildInfo.author = params[:author]
        #     @buildInfo.branch = params[:branch]
        #     @buildInfo.commit_url = params[:commit_url]
        #     @buildInfo.commmit_msg = params[:commit_msg]
        #     @buildInfo.build_time = params[:build_time]
        #     @buildInfo.build_status = params[:build_status]
        # post_params["username"] = params[:repository][:owner][:name]
        # post_params["project"] = params[:repository][:name]
        # post_params["loginfo"] = logs
        # post_params["project_url"] = url
        # post_params["author"] = params[:repository][:owner][:name]
        # post_params["branch"] = params[:repository][:default_branch]
        # post_params["commit_url"] = params[:commits][0][:url]
        # post_params["commmit_msg"] = params[:commits][0][:message]
        # puts post_params
        # uri = URI.parse("https://limiao-limiao.c9users.io/buildinfos/addbuildinfo")  
        # res = Net::HTTP.post_form(uri, post_params)  
        # #返回的cookie  
        # puts res.header['set-cookie']  
        # #返回的html body  
        # puts res.body  
        addBuild(params[:repository][:owner][:name], params[:repository][:name], logs, 
                    params[:repository][:owner][:name],params[:repository][:default_branch],
                    params[:commits][0][:url], params[:commits][0][:message], "true")
        
        # Open3.popen3(command1) do |stdin, stdout, stderr|
        #     # puts "a."
        #     stderr.each_line { |line| puts line }
        #     # puts "b."
        #     # stdout.each_line { |line| puts line }
        # end
        command2 = "sh clear.sh " + dirname
        Open3.popen3(command2)
        
        
        # stdin, stdout, stderr = Open3.popen3( `sh test.sh`)
        # puts "stdout"
        # puts stdout.gets
        # puts "stderr"
        # puts stderr.gets
        render json: "{}"
    end
    
     # 添加build信息
    def addBuild(user_name, project_name, log_info, author,branch,commit_url, commit_msg, build_status)
        @userName = user_name
        @projectName = project_name
        if User.find_by(user_name:@userName) and Project.find_by(project_name:@projectName, author: author)
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
                @user.buildinfos_num = (@user.buildinfos_num.to_i + 1).to_s
                @user.save
                @project = Project.find_by(project_name:@projectName)
                if @project.buildinfo_num_all == nil
                    @project.buildinfo_num_all = "0"
                end
                @project.buildinfo_num_all = (@project.buildinfo_num_all.to_i + 1).to_s
                @project.save
                return 1
            else 
                return 0
            end 
        else 
            return 0
        end
    end
    
end





