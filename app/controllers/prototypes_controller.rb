class PrototypesController < ApplicationController
  
  before_action :authenticate_user!, except: [:show, :index]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end
  
  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
      return
    end
    render :new, status: :unprocessable_entity
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
      return
    end
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    if  @prototype.destroy
      redirect_to root_path
    return
    end
  end


  private

    def prototype_params
      params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
    end
    
    def contributor_confirmation
      if user_signed_in?
      else
        redirect_to root_path
      end
    end
end

