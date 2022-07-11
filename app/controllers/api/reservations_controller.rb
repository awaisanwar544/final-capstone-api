class Api::ReservationsController < ApplicationController
  # GET api/reservation
  def index
    resolve = UsersHelper::Validator.valid_user_token?(request.headers['Authorization'])
    user = resolve[3] if resolve[0]
    @reservations = user.reservations.all
    render json: @reservations
  end

  # POST api/reservation
  def create
    @reservation = @current_user.reservations.new(reservation_params)
    @reservation.user_id = current_user
    @reservation.provider_id = params[:provider_id]

    if @reservation.save
      render json: @reservation, status: :created
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.permit(:start_date, :end_date, :total_cost)
  end

end
