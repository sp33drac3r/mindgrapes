get '/' do
  erb :index
end

post '/save' do
  clean_post = clean_post(params[:content])
  post = Post.create(user_id: session[:user_id], text: clean_post)
  analyze_post(clean_post, post.id)
  Paragraph.where(post_id: post.id)
  redirect '/'
end
