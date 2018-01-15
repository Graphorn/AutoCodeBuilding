require "net/http"
require "uri"
class PushController < ApplicationController
    skip_before_action :verify_authenticity_token
    # protect_from_forgery with: :exception
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
            # stderr.each_line {|line| logs << line.chomp }
            stderr.each_line {|line| logs << line }
            # stderr.close
        end
        puts "logs:"
        puts logs
        # 编译是否成功
        status = "false"
        if logs==''
            status = "true"
        end
            
        addBuild(params[:repository][:owner][:name], params[:repository][:name], logs, 
                    params[:repository][:owner][:name],params[:repository][:default_branch],
                    params[:commits][0][:url], params[:commits][0][:message], status)
        
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





