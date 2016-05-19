get '/' do
  if logged_in?
    erb :index
  else
    erb :sign_up_log_in, layout: false
  end
end

get '/today' do
  erb :index, layout: false
end

get '/posts' do
  @posts = Post.where(user_id: session[:user_id].to_i).order(created_at: :desc)
  erb :posts, layout: false
end

get '/posts/:id' do
  @post = Post.find_by(id: params[:id])
  erb :post, layout: false
end

get "/time" do
  erb :time, layout: false
end

post '/login' do
  @user = User.authenticate(params["user"])
  login(@user) if @user
  redirect '/'
end

get '/data' do
  if request.xhr?
    user = User.find_by(id: current_user.id)
    posts = user.posts.order(:created_at)
    categories = []
    positive = []
    neutral = []
    negative = []
    posts.each do |post|
      categories << post.created_at.strftime("%B %d, %Y")
      positive << post.pos_avg.to_f
      neutral << post.neutral_avg.to_f
      negative << post.neg_avg.to_f
    end
    data = {categories: categories, positive: positive, neutral: neutral, negative: negative}
    return data.to_json
  end
end

get '/data/:date' do
  date = DateTime.parse(params[:date]).to_date.to_s
  @post = Post.where("date_trunc('day', created_at) = '#{date}'")[0]
  erb :post, layout: false
end

post '/save' do
  clean_post = clean_post(params[:content])
  post = Post.create(user_id: session[:user_id], text: clean_post)
  post_array = analyze_post(clean_post)
  post_array.each do |paragraph|
    paragraph["post_id"] = post.id
    Paragraph.create(paragraph)
  end
  paragraphs = Paragraph.where(post_id: post.id)
  averages = sentiment_extruder(paragraphs)
  post.pos_avg = averages[:pos]
  post.neutral_avg = averages[:neu]
  post.neg_avg = averages[:neg]
  post.save
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
  erb :sign_up_log_in, layout: false
end
