helpers do
  def current_user
    user ||= User.find(session(:user_id).to_i)
  end
end
