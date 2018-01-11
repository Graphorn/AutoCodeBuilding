class ApplicationController < ActionController::Base
    layout false
    protect_from_forgery with: :exception
    def index

        # render 'layouts/mailer.html.erb'
        render 'layouts/index.html.erb'
        
        # render file: 'public/index.html'
        # render :file => 'index.html'
    end
end
