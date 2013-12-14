module UserHelper
  def authenticated?
    !session[:oauth_token].nil?
  end

  def current_user
    @current_user = User.find(session[:user_id]) || nil
  end
end