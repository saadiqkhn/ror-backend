class Api::V1::SocialLoginController < Api::V1::ApiController

  def social_login
    response = SocialLoginService.new(params['provider'], params['token'], params['type'], params['fcm_token']).social_login
    render json: { customer: response[0], token: response[1], profile_image: response[2] }
  end

end