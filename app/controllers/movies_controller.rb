class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #If we have new sorting/filtering settings, assign them into session[] first, then use session[] in following code.
    if !params[:sort_by] and !params[:ratings] and !session[:current_sort_by] and !session[:current_ratings]
      @movies = Movie.all
    end
    if params[:sort_by]
      session[:current_sort_by] = params[:sort_by]
    end
    if params[:ratings]
      session[:current_ratings] = params[:ratings]
    end
    if !params[:sort_by] and !params[:ratings]
      redirect_to movies_path(sort_by: session[:current_sort_by], ratings: session[:current_ratings])
    end
    
    @movies = Movie.order(params[:sort_by]).all
    if session[:current_ratings]
      @movies = Movie.where(rating: session[:current_ratings].keys).order(session[:current_sort_by])
    end
    if session[:current_sort_by] == 'title'
      @title_header = 'hilite'
    elsif session[:current_sort_by] == 'release_date'
      @release_date_header ='hilite'
    end
    @all_ratings = Movie.all_ratings
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
end
