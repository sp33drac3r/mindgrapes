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

  def weighted_average(values, weights)
    raise TypeError unless values.length == weights.length
    weighted_sum = 0
    values.each_with_index { |value, index| weighted_sum += (value * weights[index]) }
    weighted_sum.to_f / weights.inject(:+).to_f
  end

  def sentiment_extruder(paragraphs)
    averages = {}
    pos_scores, neu_scores, neg_scores, weights = Array.new(4) {[]}
    paragraphs.each do |paragraph|
      pos_scores << paragraph.pos.to_f
      neu_scores << paragraph.neutral.to_f
      neg_scores << paragraph.neg.to_f
      weights    << paragraph.char_length
    end
    averages[:pos] = weighted_average(pos_scores, weights)
    averages[:neu] = weighted_average(neu_scores, weights)
    averages[:neg] = weighted_average(neg_scores, weights)
    return averages
  end
end
