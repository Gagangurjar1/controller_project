class ChaptersController < ApplicationController
  before_action :find_chapter, only: [:show, :update, :destroy]
  before_action :find_user_course, only: [:index]  
  def index
		if @user.present? && @user.user_type == 'teacher'
       render json: @course.chapters
    elsif @user.present? && @user.user_type == 'student'
      if @subscription.present?
        if @course.present?
          render json: @course.chapters
        else
          render json: { error:"course not found" }
        end
      else  
        render json: { error: "this user not subscribe given course" }
      end 
    else 
      render json: { error:"user not found" }   
    end     
  end 

  def create
    chapter = Chapter.new(chapter_params)
    if chapter 
      chapter.save
      render json: chapter
    else
      render json: { error:"there is a some problem for create chapter" }
    end
  end
        
  def update
    if @chapter.present?
      @chapter.update(chapter_params)
      render json: @chapter
    else
      render json: { error:"chapter not found" }
    end 
  end

  def destroy
		if @chapter.present?
			@chapter.destroy
			head :no_content
		else
			render json: { error: "Chapter not found." }
	  end
  end

  def show
    if @chapter.present?
      render json: @chapter
    else
      render json: { error: "Chapter not found."}
    end 
  end

  private      
  def chapter_params
    params.require(:chapter).permit(:name, :course_id)
  end
  def find_chapter
    @chapter= Chapter.find_by(id: params[:id])
  end  
  def find_user_course
    @user = User.find_by(id: params[:user_id].to_i, user_type: params[:user_type])
    @subscription = Subscription.find_by(course_id: params[:course_id], user_id: params[:user_id]) 
    @course = Course.find_by(id: params[:course_id])
  end 
end       


	  
 


