class UsersController < ApplicationController
    include UsersHelper

    before_action :require_login, except:[:login]
    def login
  	    if logged_in?
  		    redirect_to admin_posts_path
  		    return
        end
        if request.post?
    	    name = params[:admin][:name]
    	    password = params[:admin][:password]
    	    email = params[:admin][:email]
    	    user = Admin.find_by(name: name)

    	    if !user
    		    user = Admin.find_by(email: email)
    	    end

    	    if user && user.authenticate(password)
    		    log_in(user)
    		    redirect_to admin_posts_path
    	        return
    	    else
    		    flash.now[:danger] = "Invalid name or passowrd"
    	    end
    	end

    end

    def logout
    	log_out if logged_in?
        redirect_to root_path
    end

    def show
  	  @admin = Admin.first
    end

    def update
    	@admin = Admin.find(params[:admin][:id])
    	user_params = params.require(:admin).permit(:name,:email,:password)
    	if @admin.update(user_params)
    		flash[:success] = "your password is"+params[:admin][:password]
    		redirect_to profile_path
    	else
    		render'show'
    	end
    end

end
