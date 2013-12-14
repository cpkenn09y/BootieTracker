module UserHelper
  def authenticated?
    !session[:oauth_token].nil?
  end

  def current_user
    @current_user ||= User.new(session[:user_attributes])
  end
end