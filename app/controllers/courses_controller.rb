class CoursesController < ApplicationController
	before_action :set_course, only: [:show, :update, :destroy]
  def index
		user = User.find_by(id: params[:user_id].to_i)
		if user
		  if user.user_type == 'teacher'
			  courses = user.courses
			  render json: courses
		  elsif user.user_type == 'student'
			  courses = Course.all
			  render json: courses
		  else
			  render json: { error: "course not found" }
		  end
		else
		  render json: { error: "User not found." }
		end
	end

	def create
		if teacher? 
		  @course = Course.new(course_params)
		  if @course 
        @course.save
			  render json: @course
		  else
			  render json: { errors: @course.errors.full_messages }
		  end
	  else
		  render_teacher_error
		end
	end
	
  def update
		if teacher? 
		  if @course
        @course.update(course_params)
			  render json: @course
		  else
		    render json: { errors: @course.errors.full_messages }
		  end
	  else
		  render_teacher_error
	  end
  end
	
  def destroy
		if teacher?
		  @course = Course.find(params[:id])
		  if @course
			  @course.destroy
			  head :no_content
		  else
			  render json: { error: @course.errors.full_messages}
		  end
	  else
		  render_teacher_error
    end
  end

  def show
    course = Course.find(params[:id])
	  render json:course 
    unless course
      render json: "course not found.."
    end
  end
  private
	def teacher?
		user = User.find_by(id: course_params[:user_id].to_i, user_type: course_params[:user_type])
		user.present? && user.user_type == 'teacher'
  end
  
	def render_teacher_error
		render json: { error: "Only teachers Type Userperform this action." }
	end  

	def course_params
	  params.require(:course).permit(:title, :description, :user_id, :user_type)
	end
  
	def set_course
		@course = Course.find(params[:id])
	end
end
  
