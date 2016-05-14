get '/' do
  if logged_in?
    erb :index
  else
    #erb :index
    erb :sign_up_log_in
  end
end

post '/login' do
  @user = User.authenticate(params["user"])
  p @user
  if @user
    login(@user)
    redirect '/'
  else
    redirect '/'
  end
end

post '/save' do
  clean_post = clean_post(params[:content])
  post = Post.create(user_id: rand(1..100), text: clean_post)
  post_array = analyze_post(clean_post)
  post_array.each do |paragraph|
    p paragraph
    paragraph["post_id"] = post.id
    Paragraph.create(paragraph)
  end
  redirect '/'
end

post "/users" do
  params["user"]["ok_to_email"] = true if params["user"]["ok_to_email"] == "on"
  @user = User.new(params["user"])
  if @user.save
    login(@user)
    redirect '/'
  else
    redirect '/'
  end
end
