helpers do
  def clean_post(post)
    post.gsub(/\r|"/, "")
  end

  def analyze_post(cleaned_post)
    paragraph_array = cleaned_post.split("\n")
    paragraph_array.reject! { |paragraph| paragraph == "" }
    analyzed_paragraph_array = []
    paragraph_array.each do |paragraph|
      sentiment = gather_sentiment(paragraph)["probability"]
      sentiment["char_length"] = paragraph.length
      analyzed_paragraph_array << sentiment
    end
    return analyzed_paragraph_array
  end

  def gather_sentiment(paragraph)
    sentiment = RestClient.post("http://text-processing.com/api/sentiment/", text: paragraph)
    JSON.parse(sentiment)
  end
end
