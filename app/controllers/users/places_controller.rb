module Users
  class PlacesController < ApplicationController
    respond_to :json

    def index
      @places = User.find(params[:user_id]).places

      render json: { success: true, places: @places.as_json },
             content_type: 'application/json'
    end

    def create
      @place = current_user.places.new(place_params)
      if @place.save
        render json: { success: true, place: @place.as_json },
               content_type: 'application/json'
      else
        render json: { error: @place.errors, success: false },
               content_type: 'application/json'
      end
    end

    def update
      @place = current_user.places.find(params[:id])
      if @place.update(place_params)
        render json: { success: true, place: @place.as_json },
               content_type: 'application/json'
      else
        render json: { error: @place.errors, success: false },
               content_type: 'application/json'
      end
    end

    def destroy
      current_user.places.find(params[:id]).destroy
    end

    private

      def place_params
        params.require(:place).permit(:user_id, :latitude, :longitude,
                                      :title, :description)
      end
  end
end
