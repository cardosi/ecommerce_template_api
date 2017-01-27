class UsersController < ApplicationController
  before_action :authenticate, except: [:login, :create]
  before_action :authorize, except: [:login, :create]

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: {status: 200, message: "ok"}
    else
      render json: {status: 422, user: user.errors}
    end
  end

  # GET /users/1
  def show
    user = current_user
    render json: {status: 200, user: user}
  end

  def login
    user = User.find_by(username: params[:user][:user_name])
    if user && user.authenticate(params[:user][:password])
      token = token(user.id, user.user_name)
      render json: {status: 201, token: token, user: user}
    else
      render json: {status: 401, message: "unauthorized"}
    end
  end

  private

  def token(id, user_name)
    JWT.encode(payload(id, user_name), ENV['JWT_SECRET'], 'HS256')
  end

  def payload(id, user_name)
    {
      exp: (Time.now + 60.minutes).to_i,
      iat: Time.now.to_i,
      iss: ENV['JWT_ISSUER'],
      user: {
        id: id,
        user_name: user_name
      }
    }
  end

  def user_params
    params.require(:user).permit(:user_name, :password, :email, :name, :address, :city, :state, :zip)
  end


  # PATCH/PUT /users/1
  # def update
  #   if @user.update(user_params)
  #     render json: @user
  #   else
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /users/1
  # def destroy
  #   @user.destroy
  # end

    # Use callbacks to share common setup or constraints between actions.
    # def set_user
    #   @user = User.find(params[:id])
    # end

    # Only allow a trusted parameter "white list" through.

end
