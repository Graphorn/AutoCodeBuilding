class BuildinfosController < ApplicationController
    # 根据项目id取出项目所有buildinfo 
    def getBuildInfo
        @projectId = params[:project_id]
        @buildInfo = Buildinfo.find_by(id: @projectId)
        render "{\"status\": \"1\", \"projectId\": \"#{@projectId}\", \"buildList\": \"#{@buildInfo.as_json}\"}"
    end
end
