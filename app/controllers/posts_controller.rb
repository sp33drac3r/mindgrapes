get '/today' do
  erb :index, layout: !request.xhr?
end

get '/posts' do
  @posts = Post.where(user_id: session[:user_id].to_i).order(created_at: :desc)
  erb :posts, layout: !request.xhr?
end

get '/posts/:id' do
  @post = Post.find_by(id: params[:id])
  erb :post, layout: !request.xhr?
end

post '/save' do
  post = Post.create(user_id: session[:user_id], text: params[:content])
  clean_post = clean_post(params[:content])
  post_array = analyze_post(clean_post)
  post_array.each do |paragraph|
    paragraph["post_id"] = post.id
    Paragraph.create(paragraph)
  end

  paragraphs = Paragraph.where(post_id: post.id)
  averages = sentiment_extruder(paragraphs)
  post.pos_avg     = averages[:pos]
  post.neutral_avg = averages[:neu]
  post.neg_avg     = averages[:neg]

  post.save
  redirect '/'
end
