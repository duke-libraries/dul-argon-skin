class MapLocationController < ApplicationController

  def show
    render layout:false
    params.permit(:loc_n, :loc_b, :title, :call_no)
  end

end
