use Rack::Session::Pool, :expire_after => 2592000

helpers do
  def current_user
    @user ||= User.find_by(id: session[:user_id].to_i)
  end

  def logged_in?
    !!current_user
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logout!
    session[:user_id] = nil
  end
end
