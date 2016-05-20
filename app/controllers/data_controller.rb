get "/time" do
  erb :time, layout: !request.xhr?
end

get '/data' do
  if request.xhr?
    user = User.find_by(id: current_user.id)
    posts = user.posts.order(:created_at)
    categories, positive, neutral, negative = Array.new(4) {[]}
    posts.each do |post|
      categories << post.created_at.strftime("%B %d, %Y")
      positive   << post.pos_avg.to_f
      neutral    << post.neutral_avg.to_f
      negative   << post.neg_avg.to_f
    end

    data = { categories: categories,
             positive:   positive,
             neutral:    neutral,
             negative:   negative
          }

    return data.to_json
  end
end

get '/data/:date' do
  date = DateTime.parse(params[:date]).to_date.to_s
  @post = Post.where("date_trunc('day', created_at) = '#{date}'")[0]
  erb :post, layout: !request.xhr?
end
