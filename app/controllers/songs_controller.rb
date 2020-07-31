class SongsController < ApplicationController
  def index
    artist = Artist.find_by(id: params[:artist_id])
    if params[:artist_id]
      if artist != nil
        @songs = artist.songs
      else
        flash[:alert] = "Artist not found."
        redirect_to artists_path
      end
    else
      @songs = Song.all
    end
  end

  def show
    my_song = Song.find_by(id: params[:id])
    if my_song
      @song = my_song
    else
      if params[:artist_id]
        flash[:alert] = "Song not found."
        redirect_to artist_songs_path(params[:artist_id])
      else
        redirect_to :index
      end
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
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
end

