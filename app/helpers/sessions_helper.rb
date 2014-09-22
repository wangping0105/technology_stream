module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token,User.encrypt(remember_token))
    self.current_user = User.encrypt(remember_token)
  end
  def current_user=(user)
    @current_user=user
  end
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to (session[:return_to] || default)
    session.delete(:return_to)
  end
  def store_location
    unless request.fullpath == "/messages/show_messages"
      session[:return_to] = request.fullpath if request.get?
    end
  end
  def signed_in?
    !current_user.nil?
  end
  def sign_out
    current_user.update_attribute(:remember_token,
      User.encrypt(User.new_remember_token))
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def check_authority
    if !current_user.nil? && !current_user.status
      return true
    end
    false
  end
end
