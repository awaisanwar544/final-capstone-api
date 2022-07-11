class Api::ReservationsController < ApplicationController
  
  def get_user
    result = UsersHelper::Validator.valid_user_token?(request.headers['Authorization'])
    unless result[0]
      return false
    end
    return result[3]
  end
  # GET api/reservations
  def index
    @user = self.get_user
    if @user
      reservations = @user.reservations.all
      render json: reservations
    else
      render json: '{"error":"Invalid user"}'
    end
  end

  # POST api/reservations
  def create
    @user = self.get_user
    @reservation = @user.reservations.new(reservation_params)
    @reservation.user_id = @user.id
    @reservation.provider_id = params[:provider_id]

    if @reservation.save
      render json: @reservation, status: :created
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # DELETE api/reservations
  def destroy
    @user = self.get_user
    @reservation = Reservation.find(params[:id])
    
    unless @user.id == @reservation.user_id
      render json: { message: 'Invalid User' }
      return
    end

    if @reservation.destroy
      render json: { message: 'Reservation deleted' }
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.permit(:start_date, :end_date, :total_cost)
  end

end
