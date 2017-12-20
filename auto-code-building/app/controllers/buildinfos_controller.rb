class BuildinfosController < ApplicationController
    # 获取build信息，log,author(github 作者),user_name,project,branch,commit_url,commmit_msg,build_time,build_status
    def getBuildInfo
        @buildInfos = Buildinfo.find_by(project: params[:project_name], user_name: params[:user_name])
        if @buildInfos
            render json: "{\"status\": \"1\", \"message\": \"\", \"buildinfoList\": #{@buildInfos.to_json}}"
        else
            render json: "{\"status\": \"0\", \"user_type\": \"\", \"message\": \"查询失败\", \"buildinfoList\": \"\"}"
        end
    end
end
