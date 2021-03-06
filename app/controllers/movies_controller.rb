class MoviesController < ApplicationController
  before_action :find_movie, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit]

  def index
    if params[:category].blank?
      @movies = Movie.all.order('created_at DESC')
    else
      @category_id = Category.find_by(name: params[:category]).id
      @movies = Movie.where(:category_id => @category_id).order('created_at DESC')
    end
  end

  def new
    # @movie = Movie.new
    @movie = current_user.movies.build
    @categories = Category.all.map{|c| [c.name, c.id]}
  end

  def create
    # @movie = Movie.new(movie_params)
    @movie = current_user.movies.build(movie_params)
    @movie.category_id = params[:category_id]

    if @movie.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    # adding average rating
    if @movie.reviews.blank?
      @average_review = 0
    else
      @average_review = @movie.reviews.average(:rating).round(2)
    end
  end

  def edit
    @categories = Category.all.map{|c| [c.name, c.id]}
  end

  def update
    @movie.category_id = params[:category_id]
    if @movie.update(movie_params)
      redirect_to movie_path(@movie)
    else
      render 'edit'
    end
  end

  def destroy
    @movie.destroy
    redirect_to root_path
  end

  private
    def movie_params
      params.require(:movie).permit(:title, :description, :director, :category_id, :movie_img)
    end

    def find_movie
      @movie = Movie.find(params[:id])
    end
end
