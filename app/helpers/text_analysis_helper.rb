def analyze_post(post)
  cleaned_post = post.gsub(/"/,"'")
  cleaned_post = cleaned_post.gsub(/\r/, "")
  post_array = cleaned_post.split("\n")
  post_array.reject! { |paragraph| paragraph == "" }
  post_array.each do |paragraph|
    p paragraph
    gather_sentiment(paragraph)
  end
end

def gather_sentiment(paragraph)
  sentiment = RestClient.post("http://text-processing.com/api/sentiment/", text: paragraph)
  p JSON.parse(sentiment)
end
