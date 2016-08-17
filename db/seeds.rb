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

def add_post(user, text, date)
  post = Post.new(user_id: user.id, text: text)
  clean_post = clean_post(text)
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
  post.created_at  = date

  post.save
end

user = User.create(name: 'Harry Truman',
            email: 'demo@demo.com',
            password: 123,
            ok_to_email: true
  )

text = "Spent the day at work. Was aboard the Williamsburg with secretaries and miltary [sic] and naval aides, and Adm[iral] Leahy.
Had a most pleasant evening-and so did everyone, apparently. Went to bed at 1:30 A.M. tomorrow after Chief Ph[ysician's] M[a]t[e]. Taylor gave me a good and thorough rub down."

date = '1974-01-01'

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Arose at 7:30, shaved, dressed and had breakfast at 8:15 with Adm[iral] Foskett the naval aide and Capt[ain] Freeman, Commander of the Williamsburg. Arrived at the White House about 9 A.M. Had a beautiful snow the night before. Trees in the White House yard were beautiful. R[ea]r Adm[iral] Foskett came to the House with me and then went home.
Spent the day working on messages. Called all the members of the Cabinet[,] wished them a happy New Year. Called Henry Stimson, Miss Perkins, Gen[eral] Eisenhower and Gen[eral] Flemming too.
"

date = "1974-01-02"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Byrnes & I discussed General Marshall's last letter and decided to ask him to come home. Byrnes is going to quit on the tenth and I shall make Marshall Sec[retary] of State. Some of the crackpots will in all probability yell their heads off-but let 'em yell! Marshall is the ablest man in the whole gallery.
Mrs. Roosevelt came in at 3 P.M. to assure me that Jimmy & Elliott had nothing against me and intended no disparagement of me in their recent non-edited remarks. Said she was for me. Said she didn't like Byrnes and was sure he was not reporting Elliott correctly. Said Byrnes was always for Byrnes and no one else. I wonder! He's been loyal to me[.] In the Senate he gave me my first small appropriation, which started the Special Committee to investigate the National Defense Program on its way. He'd probably have done me a favor if he'd refused to give it.
Maybe there was something on both sides in this situation. It is a pity a great man has to have progeny! Look at Churchill's. Remember Lincoln's and Grant's. Even in collateral branches Washington's wasn't so good-and Teddy Roosevelt's are terrible.
"

date = "1974-01-03"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Spent the day working on State of the Union, Economic and Budget messages. Having a terrible time with the Economic one. The Commission have no White House experience. I've turned them over to Steelman[,] Harriman, Snyder and Schwellenbach, and I hope for the best.
The awful 79th Congress put me on the spot. Now I've a job putting the 80th on the same spot to make us even."

date = "1974-01-04"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Spent all morning with the State of the Union Message. Went to sleep at 12:15 last night or this morning reading it.
Slept until 7:30-most unusual. Get up nearly every morning at 5:30 or five minutes to six. Took an 'electric' shave (practically none) and then went walking at
8 A.M. with Jim Rowley[,] Chief of the White House S[ecret] S[ervice] detail and a couple of more men following. And some in a car following along behind. I'm not supposed to know about the car.
Went down F St[.] and back G. Like to look in merchants['] windows. Had breakfast at 9 A.M.
At 12:45 had the G. D. message in shape. Read & reread. Spent the afternoon in study on the same message and the Economic one too."

date = "1974-01-05"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Arose at 5:45 A.M.[,] read the papers and at 7:10 walked to the station to meet the family. Took 35 minutes. It was a good walk. Sure is fine to have them back. This great white jail is a hell of a place in which to be alone. While I work from early morning until late at night, it is a ghostly place. The floors pop and crack all night long. Anyone with imagination can see old Jim Buchanan walking up and down worrying about conditions not of his making. Then there's Van Buren who inherited a terrible mess from his predecessor as did poor old James Madison. Of course Andrew Johnson was the worst mistreated of any of them. But they all walk up and down the halls of this place and moan about what they should have done and didn't. So-you see. I've only named a few. The ones who had Boswells and New England historians are too busy trying to control heaven and hell to come back here. So the tortured souls who were and are misrepresented in history are the ones who come back. It's a hell of a place.
Read my annual message. It was good if I do say it myself. Outlines by me to begin with, the cabinet, the little cabinet, Sam Rosenman, the Chief Justice all added criticisms. Clark Clifford did most of the work. He's a nice boy and will go places."

date = "1974-01-06"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "A terrific day. After the usual go around, discussion of the budget and other things, a swim seemed to be in order.
Mr. Byrnes called at 5 P.M. and said he'd like to see me. He came to the executive office and told me that there had been a leak on his resignation, effective Jan. 10th. I had expected to hold a press conference at 4:00 P.M. Jan. 10th and announce the resignation of Mr[.] Byrnes as Sec[retary] of State. About 5 P.M. Mr. B[yrnes] called me and asked if he could see me. I was getting ready for a swim but of course I see any Cabinet Officer at any time. He came to the exec[utive] office all out of breath and told me that the N. Y. Times had obtained the information of his resignation and that he was morally certain that the information had leaked at the White House. Well only my Secretarial Staff knew of it-and they had known since April 19, 1946! Mr. Byrnes finally got round to suggesting that the release should be made at once. Well I called in Charlie Ross and Bill Hassett and we cooked up the release and it was made.
I had indicated to Gen[eral] Marshall that the release would not be made until Jan[.] 10th. But Gen[eral] Marshall is a real man and I'm sure he'll understand just as I do. Byrnes was very happy at the Diplomatic Reception at 9 P.M. although he was late."

date = "1974-01-07"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "The papers this morning are full of Marshall's appointment and Mr. B[yrne]'s resignation. I am very sorry Mr. Byrnes decided to quit. I'm sure he'll regret it-and I know I do. He is a good negotiator-a very good one. But of course I don't want to be the cause of his death and his Dr. told him in March 1946 that he must slow down. So much for that.
The Senate took Marshall lock, stock and barrell [sic]. Confirmed him by unanimous consent and did not even refer his nomination to a committee. A grand start for him.
I am very happy over that proceedure [sic]. Marshall is, I think[,] the greatest man of the World War II. He managed to get along with Roosevelt, the Congress, Churchill, the Navy and the Joint Chief of Staff and he made a grand record in China.
When I asked him to take the extrovert Pat Hurley[']s place as my special envoy to China, he merely said 'Yes, Mr. President I'll go.' No argument only patriotic action. And if any man was entitled to balk and ask for a rest, he was. We'll have a real State Dep[artmen]t now."

date = "1974-01-08"

sleep(2)

add_post(user, text, date)



####################### NEW POST #######################

text = "Went to Nat[ional] Press Club dinner at the Statler. The show was good. I was introduced at the end for remarks. They seemed to be well pleased with what was said. After complimenting the show and entertainment and thanking the Club for a pleasant evening, I explained that organizations and individuals were constantly importuning me to make proclamations for various days & weeks, such as Cat Week, Horse Week, Foot Happiness Week, Laugh Week, Liars Week[,] etc. Each one was discussed and elaborated to some extent and the audience seemed pleased. I hope that was so."

date = "1974-01-11"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Had quite a day. (Look at schedule for this day, the day before and the day before that.) The Crown Prince of Arabia with his retinue and the Minister from his country to ours came in with the Secretary of State (Mr. Byrnes) and discussed Mid East Affairs at some length. Arabians are jealous of Syrians, Iraqis, Egyptians and Turks. They seem to like us but are suspicious of the British. They hate the Bolshiviks [sic]. It was an interesting talk.
They afterwards came to lunch. It was a gala affair. See guest list.
Was sitting at my desk just before dinner tonight when [name of person and staff position restricted] came up and asked if he might speak to me. He was scared stiff and almost crying. Said he'd got his checks mixed up, had lied to the Secret Service and he wanted to tell me before his boss did. As usual I felt sorry for him and promised to help him out. I wonder why nearly everyone makes a father confessor out of me. I must look benevolent or else I'm a known easy mark. Well any way I like people and like to help 'em and keep 'em out of trouble when I can and help 'em out when they get into it.
The rule around here is that no one may speak to the President. I break it every day and make 'em speak to me. So-you see what I get. But I still want 'em to tell me."

date = "1974-01-16"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "We go to K[ansas] C[ity.] See mamma[.]"

date = "1974-03-02"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Spend a pleasant day.
Go to bed and get called a[t] 2:30 A.M. Tuesday.
It is a nice morning. But we run into clouds over Texas and Okla[homa]."

date = "1974-03-03"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Come into sight of Monterey [sic] after the sun had been up an hour or two. Country looks like a map. About nine or nine thirty see Popocatepetl and try to see Orizaba-haze too thick[,] can't see it. Approach rim around Tenochtitlan Valley-up 11000 feet. No discomfort. Beautiful valley. Must have been lovely when a lake. Too bad the Spaniards drained it. Made a lot of dust.
Perfect day. Land at 10:00 on the dot. My pilot never misses a schedule.
Step down from plane. Mexican President comes down steps of observation tower at same time. We meet. I like him at once. He introduces his Cabinet, I introduce my secretaries and aides.
We walk to platform beautiful [sic] decorated with flowers-both flags worked out in flowers. The Mexican President welcomes me. I am made a citizen of the Federal district by its Governor-another Aleman[,] no kin of the President. He pins a beautiful gold medal on me. I make suitable reply and mispronounce Tenochtitlan to the delight of everybody.
We get into my big open Lincoln car and start for American Embassy.
Never saw such crowds-such enthusiasm. Arrive at Embassy[,] bid President goodbye. Have dinner at Palace where I make a speech in reply to the [Truman writes 'Tuesday night' above this part of the entry] Mexican Presidents. Shake hands with some two or three thousand. The President & I go out upon a balcony with a rug over the railing and wave to a sea of people-thousands so they say. Have seen pictures of Franz Joseph, Marcus Aurelius & Napoleon doing it. But it[']s my first time.
Tuesday morning lay a wreath on soldiers monument with lots and lots of ceremony. Then the Foreign Minister and I drive to the Chepultepec where I place a wreath on the Monument to the Ninos [sic] Heros [sic]-cadets who stood up to Old Fuss & Feathers until all but one was killed. He wraped [sic] the Mexican Flag around himself and jumped 200 feet to his death. The monument is where he fell. Had all the cadets lined up and the Foreign Minister and the Commandant of the Cadets wept-so did news men and photographers. I almost did myself. It seems that tribute to these young heros [sic] really set off the visit. They had it coming.
Lunch at Embassy and reception. More hand shakes-3000 of 'em. Dinner at Embassy for President of Mexico."

date = "1974-03-04"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Fiesta! oh my what a show. Never saw anything like it and never expect to again[.] 60000 in the Stadium and twice as many outside.
Dinner with the President at his house. Three Ex-Presidents present. A grand time. Music and everything.
To bed at 1 A.M. What a time!"

date = "1974-03-06"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Left Mexico City at 6 A.M. Everyone[,] President, Cabinet, half the City to see me off.
Land at Waco in the rain at 11 A.M.
Doc tell's [sic] me I have Cardiac Asthma! Ain[']t that hell.
Well it makes no diff[erence,] will go on as before. I've sworn him to secrecy! So What!"

date = "1974-03-07"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Meeting with 'big six' in study at White House. Present[:] Barclay [sic], Rayburn, Vandenberg, Martin, White, Halleck. Extention of II [Second] War Powers Act discussed. Sugar, rent, food, transportation controls at stake. Hope for renewal."

date = "1974-03-24"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Meeting with Argentine Ambassador. He is going to Argentine [sic]. Invited Dean Atcheson [sic], Tom Connolly [sic] and Vandenberg. Told the Ambassador that we wanted friendly relations with his country, but that we also wanted compliance with agreements made at San Francisco and Mexico City. Informed him that there were still Nazi war criminals loose in his country. They should be rounded up and deported for trial.
He talked of Communism in Chili [sic], Brazil and Bolivia. It was intimated that Argentines [sic] compliance was the subject of conversation. He said that Communism is rife in Brazil.
I doubt if we accomplished anything. The Ambassador speaks terrible English. Said Argentine [sic] wanted to get along with us, etc."

date = "1974-03-31"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Called in Sec[retary] of State, Gen[eral] Marshall, Sec[retary] of War, Sec[retary of the] Navy, Gen[eral] Eisenhower, Adm[iral] Leahy, and Adm[iral] Nimitz along with Dr. Lillienthal to discuss new atomic bombs, and the advisability of testing them. Gen[eral] Marshall agreed that they should be tested but at a date beyond the Foreign Minister's meeting in Nov.-say from Feb[.] to April.
I appointed Patterson, Forestal [sic] and Dr. Lillienthal to work out details with Gen[eral] Eisenhower and Adm[iral] Nimitz as advisors. Gen[eral] Marshall & Adm[iral] Leahy to be consulted as developments proceed.
We must make the tests without insulting the Bolshies or our own Red helpers-headed by Wallace.
Lunched with Marshall & Att[orne]y. Gen[eral] Clark in John Pye's dining room. Ross, Clifford, Latta[,] Haskett & John Steelman present.
Marshall told the best story of World War II[,] at least Winston Churchill thinks it is. I endorse Churchill's judgement-about an American Army Chaplain being driven into Tunis after the German surrender. All Americans had gone forward so Germans took over traffic direction. Traffic terribly snarled up. The Chaplain with his corporal driver was stopped by a tough Nazi at a street crossing and completely 'balled out' just as an American cop would do it-only in addition to the balling out the Nazi traffic cop told the chaplain what he thought of the inefficiency and general no account make up of Americans. The Chaplain was kind and polite and tried his level best to be decent. In fact he went so far that the poor corporal driver could hardly hold his tongue. Finally the Chaplain pointed to his insignia and informed the tough Nazi cop that he belonged to the religious section of the army and finally remarked-'I am only up here to plant some of you Nazi bastards.' The corporal was made very happy by that remark and I suppose the good Chaplain regreted [sic] it. Any way it's a good story and I agree with Winston."

date = "1974-06-27"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Was driven to Charlottesville, V[irgini]a at 2 P.M. Stayed at Stanley Woodward's farm beyond Monticello and a mile this side of Ashlawn. Had a most delightful week end.
Of course on the 4th had to take the plaudits of the populous [sic] but outside that no in convenience.
Mr. Woodward and his charming wife really know what protocol means-without the 'stripped [sic] pants'
Visited Monroe's Ashland after the festivities and enjoyed it very much. This on July 4th.
Went back to the N[orth] of V[irgini]a at 5 P.M. July 4th to a party given by Adm[iral] Halsey to the press. Had a very pleasant time."

date = "1974-07-03"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Had most cordial reception at Jefferson's home-some 4000 or 5000 people there to hear me speak. Speech seemed to go over.
Held a reception before speaking time and then signed some programs for those who had helped with the arrangements.
The Governor of V[irgini]a made a very, very nice welcoming speech as did Mr. Houston, Pres[ident] of the Jefferson foundation, just before I spoke.
Road to the U[niversity] of V[irgini]a in the car with Mayor Adams of Charlottesville, Gov[ernor] Tuck of V[irgini]a and Hon[orable] Colgate Darden, Pres[ident] of the U[niversity] of V[irgini]a and a former Governor of V[irgini]a.
Mrs. Astor-Lady Astor came to the car just before we started from Monticello to say to me that she liked my policies as President but that she thought I had become rather too much 'Yankee.'
I couldn't help telling her that my purported 'Yankee' tendencies were not half so bad as her ultra conservative British leanings. She almost had a stroke."

date = "1974-07-04"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Spent a quiet pleasant day at Stanley Woodward's place.
It is ideal.
Haven't had a more pleasant week end since moving into the great white jail, known as the White House!"

date = "1974-07-05"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Drove an open car from Charlottesville to Washington-starting at 9:15 Washington time.
Had a V[irgini]a Highway Policeman in a car ahead making the pace at exactly the speed allowed by V[irgini]a law. He forced all the trucks to one side as I always wanted to do. Made the drive in 3 hours. Had Sec[retary] of Treas[ury] Snyder, Adm[iral] Leahy, and Doctor Brig[adier] Gen[eral] Graham as passengers. All said they enjoyed the ride and felt they needed no extra accident coverage!"

date = "1974-07-06"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = ""

date = "1974-06-24"

sleep(2)

add_post(user, text, date)

# July 21:

# [The entry for this day is written on three loose pages, interleaved in the diary book.]

# 6:00 P. M. Monday July 21, 1947

# Had ten minutes conversation with Henry Morgenthau about Jewish ship in Palistine [sic]. Told him I would talk to Gen[eral] Marshall about it.
# He'd no business, whatever to call me. The Jews have no sense of proportion nor do they have any judgement on world affairs.
# Henry brought a thousand Jews to New York on a supposedly temporary basis and they stayed. When the country went backward-and Republican in the election of 1946, this incident loomed large on the D[isplaced] P[ersons] program.
# The Jews, I find are very, very selfish. They care not how many Estonians, Latvians, Finns, Poles, Yugoslavs or Greeks get murdered or mistreated as D[isplaced] P[ersons] as long as the Jews get special treatment. Yet when they have power, physical, financial or political neither Hitler nor Stalin has anything on them for cruelty or mistreatment to the under dog. Put an underdog on top and it makes no difference whether his name is Russian, Jewish, Negro, Management, Labor, Mormon, Baptist he goes haywire. I've found very, very few who remember their past condition when prosperity comes.
# Look at the Congress[ional] attitude on D[isplaced] P[ersons]-and they all come from D[isplaced] P[erson]s.

####################### NEW POST #######################

text = "Had the usual hectic day, though not so bad as some I've had.
Lectured eleven junior Democratic Congressmen on foreign policy. Had four Republicans not long ago-nice young men, to whom I gave the same treatment. If I could only get all the young ones together, the military & foreign policy would become the law of the land.
Talked to young Franklin for almost thirty minutes on Jews, New York, California, his daddy's papers and political matters generally. Said he & his mamma were not with Henry Wallace!
Went to Jim Forestal's [sic] house to a party for Bob Patterson. It was a nice one. A couple of Senators-Vandenburg [sic] & Gurney, the Cabinet, Gen[eral] Eisenhower & three Navy Captains. Don't know [why] Leahy, Nimitz & House members were not there. Sam Rayburn was present-only House member there.
How we'll miss Mrs. Patterson! as well as the Sec[retary] of War. Looks as if we've lost a grand, honest man & wife of the same caliber and have gained a good man and a baby talking, henna haired lady. She went to school with Claire Booth Luce-too bad I'd say. Cabinet women are a problem. I'll write a book on it some day."

date = "1974-07-23"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "At 3:30 today had a very interesting conversation with Gen[eral] Eisenhower. Sent for him to discuss the new Sec[retary] for National Defense. Asked him if he could work with Forestal [sic]. He said he could. Told him that I would have given the job to Bob Patterson had he stayed on as Sec[retary] of War. I couldn't bring myself to force him to stay. He has three daughters comming [sic] on for education and I know what that means, having had only one. But she is in a class by herself and I shouldn't judge Patterson's three by her. No one ever had a daughter equal to mine!
After the discussion on Forestal [sic] was over Ike & I visited and talked politics. He is going to Columbia U[niversity] in NY as President. What a job he can do there. He'll do it too. We discussed MacArthur and his superiority complex.
When Ike went to the far east on an inspection tour in 1946 I asked him to tell Gen[eral] Marshall, then special envoy to China, if he'd accept appointment to Sec[retary] of State. Byrnes was tired, sick and wanted to quit. Ike, when he returned came in and said 'Gen[eral] Marshall said yes.' So when Byrnes quit I appointed Marshall and did not even ask him about it!
Ike & I think MacArthur expects to make a Roman Triumphal return to the U. S. a short time before the Republican Convention meets in Philadelphia. I told Ike that if he did that that he (Ike) should announce for the nomination for President on the Democratic ticket and that I'd be glad to be in second place, or Vice President. I like the Senate anyway. Ike & I could be elected and my family & myself would be happy outside this great white jail, known as the White House.
Ike won't quot [sic] me & I won't quote him."

date = "1974-07-25"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "My sister, Mary Jane, called & said that mamma is sinking swiftly. Dr. Greene was at home in Grandview and said she'd not last long. Call was at 9 A.M. Washington time. I ordered plane set up at 12:30. Began getting things in order.
Congress quitting tonight.
Unification bill passed. Asked that it be sent up so I could appoint Defence [sic] Secretary. Printing office closed. Finally recieved [sic] bill at air port. Signed it and appointed Forestal [sic]. All favor him. Took off at 12:30 Washington time. At 1:30 Washington time recieved [sic] message my mother has passed on. Terrible shock. No one knew it.
Arrived in Grandview about 3:30 CST[,] went to the house and met sister & brother. Went to Belton with them and picked a casket. A terrible ordeal. Back to Grandview and then to Independence with Bess & Margie. They were at airport to meet me but stayed in Grandview while I went to Belton with Vivian & Mary.
Spent Sunday morning and afternoon at Grandview. Mamma had been placed in casket we had decided upon and returned to her cottage. I couldn't look at her dead. I wanted to remember [her] alive when she was at her best."

date = "1974-07-26"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "This was a terrible day. Arose at 6:15[,] had breakfast, fixed up by Bess at seven. Didn't sleep much Saturday night or Sunday night. So took a nap after breakfast. Had a time doing it. The Mayor of Ind[e]p[endence,] Roger Sermon, a [World] War I buddy of mine[,] came in at 9:30 with Renick Jones[,] a lifetime friend of mine[,] to pay respects. When they left the house I started to take a nap and Charlie Ross my Press Secretary called and said that the Mexican Ambassador wanted to come and see me on orders from Pres[ident] Aleman to pay his respects personally. He came at 10:30.
I took a short nap, had lunch at 12:00 and went to Grandview, arriving at 1:00. All the cousins on both sides came. About fifty of them. The Baptist preacher Wellborn Bowman conducted the service. It was as mamma wanted it. We went to Forest Hill and the preacher did it excellently at the grave.
Along the road all cars, trucks and pedestrians stood with hats off. It made me want to weep-but I couldn't in public.
I've read thousands of messages from all over the world in the White House study and I can shed tears as I please-no one's looking."

date = "1974-07-28"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Returned to Washington. Had the new crew on the Sacred Cow sign the two maps-going & coming.
The new plane 'Independence['] is in Brazil with the Sec[retary] of the Treas[ury].
Landed in Washington at 4:16. Called Bess from White House. She was worried because our new pilots couldn't make the old cow run as fast as L[ieutenan]t Col[onel] Myers can.
The new pilots were rattled on account of the passenger and were careful & conservative. They are nice boys."

date = "1974-07-29"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "At 9 A.M. we leave Washington for Brazil. I am in doubt about what the result may be. We have a pleasant flight to Trinadad [sic], and a cordial reception by the British Governor and the U.S. Commandant. Stay at the house of the American C[ommanding] O[fficer]. It was very pleasant."

date = "1974-08-31"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Arose at 2 A.M., shaved, took a bath and then called Bess & Margaret. Both were up when I called them. We had a very nice breakfast and signed autographs for the commandant and the troop commander. I wrote a personal note to our host and autographed dollar bills for all the help.
When we arrived at the plane we found everybody present but the press secretary, Charlie Ross. He'd told Hassett to put on his stripped [sic] pants and formal coat and Mr. Hassett had done so. Then he had to go out in the rain and call a number of the party. Gen[eral] Vaughan said he'd put grapefruits in the knees of his pants! We sent a special messenger for Ross and he arrived in time for us to take off at 3:15.
Arrived at Belem at 8:45. Saw the Guiana jungle and was greatly impressed at the Amazon. It is beyond discription [sic]. We landed on its south bank. I took a walk around the air station. We were in the air at 9:15 A.M. Saw all of Brazil from Belem to Rio de Janeiro. Our approach to Rio was as perfect as we could have wanted.
Circled the city, landed on an island in the harbour [sic]. Took a power boat to the city. The President & Mrs. Dutra recieved [sic] us and we had a drive and reception through the city that seldom happens."

date = "1974-09-01"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "We have had a grand cruise aboard the Battleship Missouri. It ended today at Norfolk. I gave the Captain leave to put on all the 'dog' the navy likes.
Recieved [sic] all the commanders, Army, Navy, Marine Corps, Coast Guard and then went overside with all the honors. If it pleased the Navy and all the rest I'm happy because I had a pleasant trip from Rio. Took about 21 hours to go down and twelve days cruising to come back.
We had all sorts of maneuvers etc[.] to amuse me, including Neptune and Davy Jones when the crossed the 0º line. Everybody enjoyed it-I hope."

date = "1974-09-19"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Landed in Washington aboard the Williamsburg at 8:00 A.M.
Everyone glad to get home. So am I."

date = "1974-09-20"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Have all sorts of things facing me."

date = "1974-09-21"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Had General Fleming in at 3 P.M. to discuss the hurricane disaster on Gulf Coast. Very bad in places.
Had Sec[retary] of State, Agriculture, Commerce & John Steelman, Under Sec[retary] of Treas[ury] & Clifford & Bob Lovett in to discuss meeting with Congressional leaders tomorrow. It was a very good meeting.
Went to 1st Baptist Church at 9:45[.] Spoke to the Sunday School Graduating Classes. Walked both ways. It was a lovely day."

date = "1974-09-28"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Had my new chairman of the Citizens Food Committee in to see me at ten. Told him action is what is needed. Then went in to the Cabinet Food Committee meeting. Told them that they should act as Board of Directors and Luckman as executive and that all would be responsible to me. The Citizens Committee of which Luckman is Chairman to work out plans and a program for my approval."

date = "1974-09-30"

sleep(2)

add_post(user, text, date)


####################### NEW POST #######################

text = "Had an acrimonious meeting of my secretaries this morning in the Cabinet Room. Matt Connelly & Clark Clifford on one side and Charlie Ross & John Steelman on the other.
Matt & Clark were afraid Luckman is trying to steal the lime light in the food emergency. I'm not. We worked out a statement for the 10 A.M. meeting in the movie room for the Citizens Committee.
It was a good meeting. I went back to the office and had the usual go around until 1 P.M. Then had to decide the argument between Charlie & John and Clark & Matt. I let Luckman announce his committee plan at a press conference, supporting Charlie & John.
Listened to some commentators and then called Dr. Steelman & told him to tell Luckman he'd done well. He'd had a hell of a press conference and some of the smart alecks had tried to trap him.
He came out very well.
We Are Going to Win This One."

date = "1974-10-01"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "The Congressional Record should be read very carefully during the following days and until Congress adjourns.
The message, in my opinion[,] also should be carefully read."

date = "1974-11-17"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Gridiron Club had its night.
Mr. Martin made such a very pleasant speech I just had to go shake his hand.
That made it most difficult for me to reply. But all seemed satisfied with what was said by the President."

date = "1974-12-13"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "The Congressional leaders were called to the Executive Office for conference. It was agreed that the long term plan for European recovery would not be sent to the Congress until the Bill for Interim Aid and the Appropriation had been passed. It was also agreed that Congress would not adjourn until the long time plan was recieved [sic] by them. A very pleasant meeting."

date = "1974-12-15"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Sent to Congress the European Recovery Plan (Marshall Plan).
No Presidential Message in my tenure has had the same careful consideration.
Had the Dep[artmen]t of Interior survey our assets, the Dep[artmen]t of Commerce survey the impact on our economy after a survey had been made by the Council of Economic Advisors [sic].
Had the Treasury look into the financing.
And finally had State, Defence [sic] and the White House Secretariat, headed by John Steelman, Cabinet Secretary and Clark Clifford, Special Council[,] prepare a draft of a message. After seven or eight trials one came up, on which all could finally agree.
It is a good message and a historical State Document.
Congress adjourned. We obtained the Interim Aid Plan & the money-part of it. But Congress tore its pants on the economic situation. They gave us a perfectly assinine [sic] bill-thanks to Taft."

date = "1974-12-19"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "My sister Mary Jane came in today.
The whole in law family are comming [sic]. I'm glad I like 'em."

date = "1974-12-20"

sleep(2)

add_post(user, text, date)

####################### NEW POST #######################

text = "Went to Bethesda to see Bill Hassett. Took him a poinsetta [sic] from the base of our Christmas tree and charged him with recieving [sic] flowers from Mrs. T[ruman] by me. He's a grand person.
Saw Cordell Hull and Adm[iral] King. Both in fine spirits.
Went through 3 or 4 wards and shook hands with patients who couldn't get out of bed. One negro [sic] patient told me that he had some sort of complicated ailment but after shaking my hand he had high blood pressure!
Went over to Walter Reed from Bethesda and went through the bed fast wards with Dr. Graham, my doctor & the C[ommanding] O[fficer] of the hospital. Met forty or fifty patients most of whom were war wounded. They were happy and optimistic. Makes a person ashamed to be gloomy even if world affairs are mixed up.
Went down to the W[hite] H[ouse] garage to see the tree and then ate a tall dinner[,] gained a pound and a half and the doctor says I should take it off!"

date = "1974-12-25"

sleep(2)

add_post(user, text, date)
