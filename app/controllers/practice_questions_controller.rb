class PracticeQuestionsController < ApplicationController
  before_action :find_practice_questions, only: [:show, :update, :destroy]
  before_action :find_user_course, only: [:index]  
  def index
		if @user.present? && @user.user_type == 'teacher'
      render json: @course.practice_questions
    elsif @user.present? && @user.user_type == 'student'
      if @subscription.present?
        if @course.present?
          render json: @course.practice_questions
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
      practice_question= PracticeQuestion.new(practice_question_params)
      if practice_question.present?
        practice_question.save
        render json: practice_question
      else
          render json: { error:"there is a some problem for create chapter " }
      end
  end
         
  def update
      if @practice_question.present?
        @practice_question.update(practice_question_params)
          render json: @practice_question
      else
          render json: { error:"Quetion not found" }
      end 
  end
  
  def destroy
    if @practice_question.present?
      @practice_question.destroy
      head :no_content
    else
      render json: { error: "Quetion not found." }
    end
  end
  
  def show
      if @practice_question.present?
        render json: @practice_question
      else
        render json: { error: "Quetion not found."}
      end
    end

  private      
  def practice_question_params
      params.require(:practice_question).permit(:question,:answer,:course_id)
  end 
  def find_user_course
    @user = User.find_by(id: params[:user_id].to_i, user_type: params[:user_type])
    @subscription = Subscription.find_by(course_id: params[:course_id], user_id: params[:user_id]) 
    @course = Course.find_by(id: params[:course_id])
  end   
     
  def find_practice_questions
    @practice_question= PracticeQuestion.find(params[:id])
  end
end 