class SongsController < ApplicationController
  before_action :find_artist, only: [:index, :show, :new, :edit, :create]

  def index
    if params[:artist_id] && !@artist
      redirect_to artists_path, alert: 'Artist not found'
    elsif @artist
      @songs = @artist.songs
    else
      @songs = Song.all
    end
  end

  def show
    if @artist
      @song = @artist.songs.find_by_id(params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: 'Song not found'
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if params[:artist_id]
      unless @artist
        redirect_to artists_path
      else
        @song = @artist.songs.build
      end
    else
      @song = Song.new
    end
  end

  def create
    if @artist
      @song = @artist.songs.create(song_params)
    else
      @song = Song.new(song_params)
    end

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find_by_id(params[:id])
  end

  def update
    @song = Song.find(params[:id])
    @song.update(song_params)
    if @song.save
      redirect_to @song
    else
      flash[:errors] = @song.errors.full_messages
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end

  def find_artist
    @artist = Artist.find_by_id(params[:artist_id])
  end

end

