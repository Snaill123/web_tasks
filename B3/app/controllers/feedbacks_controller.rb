class FeedbacksController < ApplicationController
  include UsersHelper

  before_action :require_login, except: [:create]

  def create
  	if request.post?
  	  name = params[:feedback][:name]
  	  email = params[:feedback[:email]
      content = params[:feedback][:content]
  	  feedback = Feedback.new(name: name, email: email, content: content)
  	  if feedback.save
  	    flash[:success] = "feedback succeed"
	    else
	  	flash[:success] = "feedback failed"
	    end
    end
  end
  def check
  	@feedbacks = Feedback.all
  end
end
