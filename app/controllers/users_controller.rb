post '/login' do
  @user = User.authenticate(params["user"])
  login(@user) if @user
  redirect '/'
end

post "/users" do
  params["user"]["ok_to_email"] = true if params["user"]["ok_to_email"] == "on"
  @user = User.new(params["user"])
  login(@user) if @user.save
  redirect '/'
end

get '/logout' do
  logout!
  erb :sign_up_log_in, layout: !request.xhr?
end
