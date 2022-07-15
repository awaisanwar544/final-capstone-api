class Api::ReservationsController < ApplicationController
  def user_validation
    user, error, status = UsersHelper::Validator.valid_user_token?(request.headers['Authorization'])
    unless user
      render json: { 'error:': error }, status: status
      return
    end
    user
  end

  # GET api/reservations
  def index
    @user = user_validation
    return unless @user

    @reservations = reservations_all
    render json: @reservations, status: :ok
  end

  # POST api/reservations
  def create
    @user = user_validation
    return unless @user

    @reservation = @user.reservations.new(reservation_params)
    @reservation.user_id = @user.id

    if @reservation.save
      render json: @reservation, status: :created
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # DELETE api/reservations
  def destroy
    @user = user_validation
    return unless @user

    begin
      @reservation = Reservation.find(params[:id])
    rescue StandardError
      render json: { message: "Couldn't find Reservation with 'id'=#{params[:id]}" }, status: :bad_request
      return
    end

    unless @user.id == @reservation.user_id
      render json: { message: 'Invalid User' }, status: :unauthorized
      return
    end

    if @reservation.destroy
      render json: { message: 'Reservation deleted' }
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  private

  def reservations_all
    reser = []
    reservations = @user.reservations.includes(:provider)
    reservations.each do |reservation|
      reser.push(
        id: reservation.id,
        provider_id: reservation.provider_id,
        start_date: reservation.start_date,
        end_date: reservation.end_date,
        total_cost: reservation.total_cost,
        created_at: reservation.created_at,
        provider_name: reservation.provider.name,
        provider_image: url_for(reservation.provider.image)
      )
    end
    reser
  end

  def reservation_params
    params.permit(:provider_id, :start_date, :end_date, :total_cost)
  end
end
