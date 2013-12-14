module ApplicationHelper
    def current_user
    @current_user = User.find(session[:user_id]) || nil
  end
end
