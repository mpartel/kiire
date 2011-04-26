class PositionsController < ApplicationController
  def update
    begin
      user = current_user
      place = user.places.find(params[:place_id])
      if params[:below] == 'top'
        below = nil
      else
        below = user.places.find(params[:below])
      end
      user.move_place_after(place, below)

      render :text => 'OK', :content_type => 'text/plain'
    rescue StandardError => e
      logger.error "Failed to move place: #{e}"
      response.content_type = 'text/plain'
      render :text => 'FAIL', :status => 500, :content_type => 'text/plain'
    end
  end
end
