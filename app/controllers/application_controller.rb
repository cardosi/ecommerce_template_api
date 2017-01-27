class ApplicationController < ActionController::API
  def authenticate
    render json: {status: 401, message: "unauthorized"} unless decode_token(bearer_token)
  end

  def authorize
    render json: {status: 401, message: "unauthorized"} unless current_user.id == params[:id].to_i
  end

  def bearer_token
    pattern = /^Bearer /
    header = request.env["HTTP_AUTHORIZATION"]
    header.gsub(pattern, '') if header && header.match(pattern)
  end

  def current_user
    return if !bearer_token
    decode_jwt = decode_token(bearer_token)

    @current_user ||= User.find(decoded_jwt["user"]["id"])
  end

  def decode_token(token)
    @token ||= JWT.decode(token, nil, false)[0]
  rescue
    render json: {status: 401, message: 'invalid or expired token'}
  end

end
