class SubscriptionsController < ApplicationController
  before_action :find_course, only: [:index]
  before_action :find_subscription, only: [:show]
  def index
    render json: @course.subscriptions
  end

  def create
    if student?
      subscription =Subscription.new(subscription_params)
      if subscription.save
        render json: subscription
      else
        render json: { errors: "Unable to create a subscription for this course" }
      end
    else
      render_student_error
    end
  end

  def show
    render json: @subscription
  end

  private
  def subscription_params
         params.require(:subscription).permit(:user_id, :course_id)  
   end
  def render_student_error
    render json: { error: "Only student_type users can perform this action." }
  end
  def student?
		user = User.find_by(id: subscription_params[:user_id])
		user.present? && user.user_type == 'student'
  end
  def find_course
    @course = Course.find_by(id: params[:course_id])
    unless @course
      render json: { error: " course_id not found." }
    end
  end

  def find_subscription
    @subscription = Subscription.find_by(id: params[:id])
    unless @subscription
      render json: { error: "Subscription not found." }
    end
  end
end 