class MoviesController < ApplicationController

  def index
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
    def movie_params
      params.require(:movie).permit(:title, :description, :director)
    end
end
