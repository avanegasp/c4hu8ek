class Api::V1::PinsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    result = token_validation(request.headers["X-Api-Token"],request.headers["X-User-Email"])
      if result
         render json: Pin.all.order('created_at DESC')
       else
         render json: { errors: "Autentication_Fail"}, status: 422
       end
  end

  def create
    result = token_validation(request.headers["X-Api-Token"],request.headers["X-User-Email"])
    if result
      pin = Pin.new(pin_params.merge(user_id: user_id_new))
        if pin.save
          render json: pin, status: 201
        else
          render json: { errors: pin.errors }, status: 422
        end
      else
        render json: { errors: "Autentication_Fail"}, status: 422
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

    def token_validation(token,email)
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      user = User.find_by(email:email)
      if (user && token == user.api_token)
          true
        else
          false
      end
    end

    def user_id_new
      user = User.find_by(email:request.headers["X-User-Email"])
      user.id
    end
end
