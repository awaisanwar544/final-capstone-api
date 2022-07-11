class Api::ReservationsController < ApplicationController
  # GET api/reservation
  def index
    result = UsersHelper::Validator.valid_user_token?(request.headers['Authorization'])
    # result = UsersHelper::Validator.valid_user_token?('Bearer eyJhbGciOiJIUzI1NiJ9.bnVsbA.vdmTmedbjb6wZjzwL-u9n3uU447A_T1wQNzbYO6Doa8')
    unless result[0]
      render json: '{"error":"Invalid user"}'
      return
    end
    user = result[3]
    reservations = user.reservations.all
    render json: reservations
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
