get '/' do
  erb :index
end

post '/save' do
  post = Post.new(user_id: session[:user_id], text: params[:content])
  analyze_post(post)
  redirect '/'
end
