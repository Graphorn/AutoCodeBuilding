class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    def index
        render file: 'public/dist/index.html'
    end
end
