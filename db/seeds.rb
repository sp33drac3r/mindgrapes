10.times do
  name = Faker::Name.name.split(" ")[0]
  User.create(name: name,
              email: Faker::Internet.safe_email,
              password: Faker::Internet.password,
              ok_to_email: true
  )
end

d = Date.today
i = 100
while i > 0 do
  date = (d-i).to_s
  post = Post.create(user_id: rand(1..10),
              text: Faker::Hipster.paragraphs.join,
              pos_avg: (rand(1..100)/100.to_f),
              neutral_avg: (rand(1..100)/100.to_f),
              neg_avg: (rand(1..100)/100.to_f)
          )

  post.created_at = date
  5.time do
    paragraph = Paragraph.create(
                  post_id: post.id,
                  pos: (rand(1..100)/100.to_f),
                  neutral: (rand(1..100)/100.to_f),
                  neg: (rand(1..100)/100.to_f),
                  char_length: post.text.length
                )
  end
  i -= 1
end
