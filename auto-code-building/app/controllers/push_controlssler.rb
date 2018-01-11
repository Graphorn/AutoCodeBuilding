require "net/http"
require "uri"
class PushController < ApplicationController
    skip_before_action :verify_authenticity_token
    protect_from_forgery with: :exception
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
        #     # puts "b."
        #     # stdout.each_line { |line| puts line }
        puts "stderr"
        puts stderr.gets
        #发送post请求
        post_params = {}  
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
        post_params["username"] = params[:repository][:owner][:name]
        post_params["project"] = params[:repository][:name]
        post_params["loginfo"] = logs
        post_params["project_url"] = url
        post_params["author"] = params[:repository][:owner][:name]
        post_params["branch"] = params[:repository][:default_branch]
        post_params["commit_url"] = params[:commits][0][:url]
        post_params["commmit_msg"] = params[:commits][0][:message]
        puts post_params
        uri = URI.parse("https://limiao-limiao.c9users.io/buildinfos/addbuildinfo")  
        res = Net::HTTP.post_form(uri, post_params)  
        #返回的cookie  
        puts res.header['set-cookie']  
        #返回的html body  
        puts res.body  

        
        # Open3.popen3(command1) do |stdin, stdout, stderr|
        #     # puts "a."
        #     stderr.each_line { |line| puts line }
        #     # puts "b."
        #     # stdout.each_line { |line| puts line }
        end
        command2 = "sh clear.sh " + dirname
        Open3.popen3(command2)
        
        
        # stdin, stdout, stderr = Open3.popen3( `sh test.sh`)
        # puts "stdout"
        # puts stdout.gets
        # puts "stderr"
        # puts stderr.gets
       
    end
end




