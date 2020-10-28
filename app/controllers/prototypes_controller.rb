class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :move_to_index, only: [:edit]

  def index
    @prototypes = Prototype.all.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    @prototype.save
    if @prototype.save
      redirect_to root_path
    else 
      @prototypes = Prototype.all.includes(:user)
      render :new
    end  
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end
  
  def edit
    @prototype = Prototype.find(params[:id])
  end 

  def update
    @prototype = Prototype.find(params[:id])
    @prototype.update(prototype_params)
    if @prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit  
    end 
  end    

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end  

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end  

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end  
  end
end

