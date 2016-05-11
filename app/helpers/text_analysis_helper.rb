helpers do
  def analyze_post(cleaned_post, post_id)
    post_array = cleaned_post.split("\n")
    post_array.reject! { |paragraph| paragraph == "" }
    return post_array
    post_array.each do |paragraph|
      sentiment = gather_sentiment(paragraph)["probability"]
      sentiment["post_id"] = post_id
      sentiment["char_length"] = paragraph.length
      Paragraph.create(sentiment)
    end
  end

  def gather_sentiment(paragraph)
    sentiment = RestClient.post("http://text-processing.com/api/sentiment/", text: paragraph)
    JSON.parse(sentiment)
  end

  def clean_post(post)
    cleaned_post = post.gsub(/"/,"'")
    cleaned_post = cleaned_post.gsub(/\r/, "")
    return cleaned_post
  end
end
