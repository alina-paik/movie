class CategoriesController < ApplicationController
  before_action :authentication, except: %i[index search_movies]
  before_action :find_category, only: %i[search_movies update destroy]
  # GET /categories
  def index
    @categories = Category.all.order('name ASC')
  end


  # GET /categories/:id/movies?page=:page
  def search_movies
    @movies = @category.movies.page(params[:page])

  end

  # POST /categories
  def create
    authorize!
    category = Category.new(category_params)
    if category.save
      render json: category, status: :created
    else
      render json: category.errors, status: :unprocessable_entity
    end
  end

  # PATCH /categories/:id
  def update
    authorize! @category
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  #DEL /categories/:id
  def destroy
    authorize! @category
    @category.destroy
  end

  private
  def find_category
    @category = Category.find_by(id: params[:id])
  end
  def category_params
    params.require(:category).permit(:name)
  end
end
