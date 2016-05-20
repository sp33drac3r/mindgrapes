get '/' do
  if logged_in?
    erb :index
  else
    erb :sign_up_log_in, layout: !request.xhr?
  end
end
