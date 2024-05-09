1 pragma solidity ^0.4.4;
2 
3 	///
4     /// This ERC20 Token HHGTTG (h2g2) is NOT meant to have any intrinsic (fundamental) value nor any
5     /// monetary value whatsoever. It is designed to honour the memory of Douglas Noel Adams.
6 	/// 11 May 2001 would become one of the worst days of my life. My one true hero ceased to
7 	/// exist as did my hope of a further h2g2 (HG2G) novel, although Eoin Colfer would eventually
8 	/// pen "And Another Thing", it just wasn't the same. If your interest in this token is piqued,
9 	/// the you will no doubt know WHY the Total Supply is ONLY 42 Tokens. This Token Contract has been
10 	/// designed to return the SAME amount of HHGTTG (h2g2) Tokens as the amount of ETH sent to the
11 	/// contract with the smallest amount being: .000000000000000001 of ETH which will return the same
12 	/// amount of h2g2 until the total supply of 42 h2g2 Tokens is depleted. The following text has been
13 	/// lifted from WikiPedia on 8 June 2018, the date of creation of this token.
14 	/// https://en.wikipedia.org/wiki/Douglas_Adams
15 	/// Douglas Noel Adams (11 March 1952 – 11 May 2001) was an English author, scriptwriter,
16 	/// essayist, humorist, satirist and dramatist. Adams was author of The Hitchhiker's Guide
17 	/// to the Galaxy, which originated in 1978 as a BBC radio comedy before developing into a
18 	/// "trilogy" of five books that sold more than 15 million copies in his lifetime and generated
19 	/// a television series, several stage plays, comics, a computer game, and in 2005 a feature film.
20 	/// Adams's contribution to UK radio is commemorated in The Radio Academy's Hall of Fame. Adams
21 	/// also wrote Dirk Gently's Holistic Detective Agency (1987) and The Long Dark Tea-Time of the
22 	/// Soul (1988), and co-wrote The Meaning of Liff (1983), The Deeper Meaning of Liff (1990), Last
23 	/// Chance to See (1990), and three stories for the television series Doctor Who; he also served
24 	/// as script editor for the show's seventeenth season in 1979. A posthumous collection of his
25 	/// works, including an unfinished novel, was published as The Salmon of Doubt in 2002.
26 	///
27 	/// Adams was an advocate for environmentalism and conservation, a lover of fast cars,
28 	/// technological innovation and the Apple Macintosh, and a radical atheist.
29 	///
30     /// Early life: Adams was born on 11 March 1952 to Janet (née Donovan; 1927–2016) and
31 	/// Christopher Douglas Adams (1927–1985) in Cambridge, England.[3] The family moved to the East
32 	/// End of London a few months after his birth, where his sister, Susan, was born three years later.
33 	/// His parents divorced in 1957; Douglas, Susan, and their mother moved to an RSPCA animal shelter
34 	/// in Brentwood, Essex, run by his maternal grandparents.
35 	///
36     /// Education: Adams attended Primrose Hill Primary School in Brentwood. At nine, he passed the
37 	/// entrance exam for Brentwood School, an independent school whose alumni include Robin Day,
38 	/// Jack Straw, Noel Edmonds, and David Irving. Griff Rhys Jones was a year below him, and he was in
39 	/// the same class as Stuckist artist Charles Thomson. He attended the prep school from 1959 to 1964,
40 	/// then the main school until December 1970. Adams was 6 feet (1.8 m) by age 12 and stopped growing
41 	/// at 6 feet 5 inches (1.96 m). His form master, Frank Halford, said his height had made him stand out
42 	/// and that he had been self-conscious about it. His ability to write stories made him well known in
43 	/// the school. He became the only student ever to be awarded a ten out of ten by Halford for creative
44 	/// writing, something he remembered for the rest of his life, particularly when facing writer's block.
45 	/// Some of his earliest writing was published at the school, such as a report on its photography club
46 	/// in The Brentwoodian in 1962, or spoof reviews in the school magazine Broadsheet, edited by Paul Neil
47 	/// Milne Johnstone, who later became a character in The Hitchhiker's Guide. He also designed the cover
48 	/// of one issue of the Broadsheet, and had a letter and short story published in The Eagle, the boys'
49 	/// comic, in 1965. A poem entitled "A Dissertation on the task of writing a poem on a candle and an
50 	/// account of some of the difficulties thereto pertaining" written by Adams in January 1970, at the age
51 	/// of 17, was discovered in a cupboard at the school in early 2014. On the strength of a bravura essay
52 	/// on religious poetry that discussed the Beatles and William Blake, he was awarded an Exhibition in
53 	/// English at St John's College, Cambridge, going up in 1971. He wanted to join the Footlights, an
54 	/// invitation-only student comedy club that has acted as a hothouse for comic talent. He was not
55 	/// elected immediately as he had hoped, and started to write and perform in revues with Will Adams
56 	/// (no relation) and Martin Smith, forming a group called "Adams-Smith-Adams", but became a member of
57 	/// the Footlights by 1973. Despite doing very little work—he recalled having completed three essays in
58 	/// three years—he graduated in 1974 with a B.A. in English literature.
59     /// 
60     /// Career: Writing: After leaving university Adams moved back to London, determined to break into TV
61 	/// and radio as a writer. An edited version of the Footlights Revue appeared on BBC2 television in 1974.
62 	/// A version of the Revue performed live in London's West End led to Adams being discovered by Monty
63 	/// Python's Graham Chapman. The two formed a brief writing partnership, earning Adams a writing credit
64 	/// in episode 45 of Monty Python for a sketch called "Patient Abuse". The pair also co-wrote the
65 	/// "Marilyn Monroe" sketch which appeared on the soundtrack album of Monty Python and the Holy Grail.
66 	/// Adams is one of only two people other than the original Python members to get a writing credit (the
67 	/// other being Neil Innes). Adams had two brief appearances in the fourth series of Monty Python's Flying
68 	/// Circus. At the beginning of episode 42, "The Light Entertainment War", Adams is in a surgeon's mask (as
69 	/// Dr. Emile Koning, according to on-screen captions), pulling on gloves, while Michael Palin narrates a
70 	/// sketch that introduces one person after another but never gets started. At the beginning of episode 44,
71 	/// "Mr. Neutron", Adams is dressed in a pepper-pot outfit and loads a missile onto a cart driven by
72 	/// Terry Jones, who is calling for scrap metal ("Any old iron..."). The two episodes were broadcast in
73 	/// November 1974. Adams and Chapman also attempted non-Python projects, including Out of the Trees. At
74 	/// this point Adams's career stalled; his writing style was unsuited to the then-current style of radio
75 	/// and TV comedy. To make ends meet he took a series of odd jobs, including as a hospital porter, barn
76 	/// builder, and chicken shed cleaner. He was employed as a bodyguard by a Qatari family, who had made
77 	/// their fortune in oil. During this time Adams continued to write and submit sketches, though few were
78 	/// accepted. In 1976 his career had a brief improvement when he wrote and performed Unpleasantness at
79 	/// Brodie's Close at the Edinburgh Fringe festival. By Christmas, work had dried up again, and a
80 	/// depressed Adams moved to live with his mother. The lack of writing work hit him hard and low confidence
81 	/// became a feature of Adams's life; "I have terrible periods of lack of confidence [..] I briefly did
82 	/// therapy, but after a while I realised it was like a farmer complaining about the weather. You can't fix
83 	/// the weather – you just have to get on with it". Some of Adams's early radio work included sketches for
84 	/// The Burkiss Way in 1977 and The News Huddlines. He also wrote, again with Chapman, 20 February 1977
85 	/// episode of Doctor on the Go, a sequel to the Doctor in the House television comedy series. After the
86 	/// first radio series of The Hitchhiker's Guide became successful, Adams was made a BBC radio producer,
87 	/// working on Week Ending and a pantomime called Black Cinderella Two Goes East. He left after six months
88 	/// to become the script editor for Doctor Who. In 1979 Adams and John Lloyd wrote scripts for two half-hour
89 	/// episodes of Doctor Snuggles: "The Remarkable Fidgety River" and "The Great Disappearing Mystery"
90 	/// (episodes eight and twelve). John Lloyd was also co-author of two episodes from the original Hitchhiker
91 	/// radio series ("Fit the Fifth" and "Fit the Sixth", also known as "Episode Five" and "Episode Six"), as
92 	/// well as The Meaning of Liff and The Deeper Meaning of Liff.
93 	///
94     /// The Hitchhiker's Guide to the Galaxy: The Hitchhiker's Guide to the Galaxy was a concept for a
95 	/// science-fiction comedy radio series pitched by Adams and radio producer Simon Brett to BBC Radio 4 in
96 	/// 1977. Adams came up with an outline for a pilot episode, as well as a few other stories (reprinted in
97 	/// Neil Gaiman's book Don't Panic: The Official Hitchhiker's Guide to the Galaxy Companion) that could be
98 	/// used in the series. According to Adams, the idea for the title occurred to him while he lay drunk in a
99 	/// field in Innsbruck, Austria, gazing at the stars. He was carrying a copy of the Hitch-hiker's Guide to
100 	/// Europe, and it occurred to him that "somebody ought to write a Hitchhiker's Guide to the Galaxy". He
101 	/// later said that the constant repetition of this anecdote had obliterated his memory of the actual event.
102 	/// Despite the original outline, Adams was said to make up the stories as he wrote. He turned to John Lloyd
103 	/// for help with the final two episodes of the first series. Lloyd contributed bits from an unpublished
104 	/// science fiction book of his own, called GiGax. Very little of Lloyd's material survived in later
105 	/// adaptations of Hitchhiker's, such as the novels and the TV series. The TV series was based on the first
106 	/// six radio episodes, and sections contributed by Lloyd were largely re-written. BBC Radio 4 broadcast the
107 	/// first radio series weekly in the UK in March and April 1978. The series was distributed in the United
108 	/// States by National Public Radio. Following the success of the first series, another episode was recorded
109 	/// and broadcast, which was commonly known as the Christmas Episode. A second series of five episodes was
110 	/// broadcast one per night, during the week of 21–25 January 1980. While working on the radio series (and
111 	/// with simultaneous projects such as The Pirate Planet) Adams developed problems keeping to writing
112 	/// deadlines that got worse as he published novels. Adams was never a prolific writer and usually had to be
113 	/// forced by others to do any writing. This included being locked in a hotel suite with his editor for three
114 	/// weeks to ensure that So Long, and Thanks for All the Fish was completed. He was quoted as saying, "I love
115 	/// deadlines. I love the whooshing noise they make as they go by." Despite the difficulty with deadlines,
116 	/// Adams wrote five novels in the series, published in 1979, 1980, 1982, 1984, and 1992. The books formed the
117 	/// basis for other adaptations, such as three-part comic book adaptations for each of the first three books,
118 	/// an interactive text-adventure computer game, and a photo-illustrated edition, published in 1994. This
119 	/// latter edition featured a 42 Puzzle designed by Adams, which was later incorporated into paperback covers
120 	/// of the first four Hitchhiker's novels (the paperback for the fifth re-used the artwork from the hardback
121 	/// edition). In 1980 Adams began attempts to turn the first Hitchhiker's novel into a film, making several
122 	/// trips to Los Angeles, and working with Hollywood studios and potential producers. The next year, the radio
123 	/// series became the basis for a BBC television mini-series broadcast in six parts. When he died in 2001 in
124 	/// California, he had been trying again to get the movie project started with Disney, which had bought the
125 	/// rights in 1998. The screenplay got a posthumous re-write by Karey Kirkpatrick, and the resulting film was
126 	/// released in 2005. Radio producer Dirk Maggs had consulted with Adams, first in 1993, and later in 1997 and
127 	/// 2000 about creating a third radio series, based on the third novel in the Hitchhiker's series. They also
128 	/// discussed the possibilities of radio adaptations of the final two novels in the five-book "trilogy". As
129 	/// with the movie, this project was realised only after Adams's death. The third series, The Tertiary Phase,
130 	/// was broadcast on BBC Radio 4 in September 2004 and was subsequently released on audio CD. With the aid of
131 	/// a recording of his reading of Life, the Universe and Everything and editing, Adams can be heard playing
132 	/// the part of Agrajag posthumously. So Long, and Thanks for All the Fish and Mostly Harmless made up the
133 	/// fourth and fifth radio series, respectively (on radio they were titled The Quandary Phase and The
134 	/// Quintessential Phase) and these were broadcast in May and June 2005, and also subsequently released on
135 	/// Audio CD. The last episode in the last series (with a new, "more upbeat" ending) concluded with, "The very
136 	/// final episode of The Hitchhiker's Guide to the Galaxy by Douglas Adams is affectionately dedicated to its
137 	/// author."
138     /// 
139     /// Dirk Gently series: Between Adams's first trip to Madagascar with Mark Carwardine in 1985, and their series
140 	/// of travels that formed the basis for the radio series and non-fiction book Last Chance to See, Adams wrote
141 	/// two other novels with a new cast of characters. Dirk Gently's Holistic Detective Agency was published in 1987,
142 	/// and was described by its author as "a kind of ghost-horror-detective-time-travel-romantic-comedy-epic, mainly
143 	/// concerned with mud, music and quantum mechanics". It was derived from two Doctor Who serials Adams had written.
144 	/// A sequel, The Long Dark Tea-Time of the Soul, was published a year later. This was an entirely original work,
145 	/// Adams's first since So Long, and Thanks for All the Fish. After the book tour, Adams set off on his
146 	/// round-the-world excursion which supplied him with the material for Last Chance to See.
147 	/// 
148 	/// Doctor Who: Adams sent the script for the HHGG pilot radio programme to the Doctor Who production office in
149 	/// 1978, and was commissioned to write The Pirate Planet (see below). He had also previously attempted to submit
150 	/// a potential movie script, called "Doctor Who and the Krikkitmen", which later became his novel Life, the
151 	/// Universe and Everything (which in turn became the third Hitchhiker's Guide radio series). Adams then went on
152 	/// to serve as script editor on the show for its seventeenth season in 1979. Altogether, he wrote three Doctor Who
153 	/// serials starring Tom Baker as the Doctor: "The Pirate Planet" (the second serial in the "Key to Time" arc, in
154 	/// season 16) "City of Death" (with producer Graham Williams, from an original storyline by writer David Fisher.
155 	/// It was transmitted under the pseudonym "David Agnew") "Shada" (only partially filmed; not televised due to
156 	/// industry disputes) The episodes authored by Adams are some of the few that were not novelised as Adams would
157 	/// not allow anyone else to write them, and asked for a higher price than the publishers were willing to pay.
158 	/// "Shada" was later adapted as a novel by Gareth Roberts in 2012 and "City of Death" and "The Pirate Planet" by
159 	/// James Goss in 2015 and 2017 respectively. Elements of Shada and City of Death were reused in Adams's later
160 	/// novel Dirk Gently's Holistic Detective Agency, in particular the character of Professor Chronotis. Big Finish
161 	/// Productions eventually remade Shada as an audio play starring Paul McGann as the Doctor. Accompanied by
162 	/// partially animated illustrations, it was webcast on the BBC website in 2003, and subsequently released as a
163 	/// two-CD set later that year. An omnibus edition of this version was broadcast on the digital radio station BBC7
164 	/// on 10 December 2005. In the Doctor Who 2012 Christmas episode The Snowmen, writer Steven Moffat was inspired by
165 	/// a storyline that Adams pitched called The Doctor Retires.
166 	/// 
167 	/// Music: Adams played the guitar left-handed and had a collection of twenty-four left-handed guitars when he died
168 	/// (having received his first guitar in 1964). He also studied piano in the 1960s with the same teacher as Paul
169 	/// Wickens, the pianist who plays in Paul McCartney's band (and composed the music for the 2004–2005 editions of
170 	/// the Hitchhiker's Guide radio series). Pink Floyd and Procol Harum had important influence on Adams' work.
171 	/// 
172 	/// Pink Floyd: Adams's official biography shares its name with the song "Wish You Were Here" by Pink Floyd. Adams
173 	/// was friends with Pink Floyd guitarist David Gilmour and, on Adams's 42nd birthday, he was invited to make a
174 	/// guest appearance at Pink Floyd's concert of 28 October 1994 at Earls Court in London, playing guitar on the
175 	/// songs "Brain Damage" and "Eclipse". Adams chose the name for Pink Floyd's 1994 album, The Division Bell, by
176 	/// picking the words from the lyrics to one of its tracks, "High Hopes". Gilmour also performed at Adams's
177 	/// memorial service in 2001, and what would have been Adams's 60th birthday party in 2012.
178 	/// 
179 	/// Computer games and projects: Douglas Adams created an interactive fiction version of HHGG with Steve Meretzky
180 	/// from Infocom in 1984. In 1986 he participated in a week-long brainstorming session with the Lucasfilm Games
181 	/// team for the game Labyrinth. Later he was also involved in creating Bureaucracy as a parody of events in his
182 	/// own life. Adams was a founder-director and Chief Fantasist of The Digital Village, a digital media and Internet
183 	/// company with which he created Starship Titanic, a Codie Award-winning and BAFTA-nominated adventure game, which
184 	/// was published in 1998 by Simon & Schuster. Terry Jones wrote the accompanying book, entitled Douglas Adams'
185 	/// Starship Titanic, since Adams was too busy with the computer game to do both. In April 1999, Adams initiated the
186 	/// h2g2 collaborative writing project, an experimental attempt at making The Hitchhiker's Guide to the Galaxy a
187 	/// reality, and at harnessing the collective brainpower of the internet community. It was hosted by BBC Online from
188 	/// 2001 to 2011. In 1990, Adams wrote and presented a television documentary programme Hyperland which featured Tom
189 	/// Baker as a "software agent" (similar to the assistant pictured in Apple's Knowledge Navigator video of future
190 	/// concepts from 1987), and interviews with Ted Nelson, the co-inventor of hypertext and the person who coined the
191 	/// term. Adams was an early adopter and advocate of hypertext.
192 	/// 
193 	/// Personal beliefs and activism: Atheism and views on religion: Adams described himself as a "radical atheist",
194 	/// adding "radical" for emphasis so he would not be asked if he meant agnostic. He told American Atheists that
195 	/// this conveyed the fact that he really meant it. He imagined a sentient puddle who wakes up one morning and
196 	/// thinks, "This is an interesting world I find myself in – an interesting hole I find myself in – fits me rather
197 	/// neatly, doesn't it? In fact it fits me staggeringly well, must have been made to have me in it!" to demonstrate
198 	/// his view that the fine-tuned Universe argument for God was a fallacy. He remained fascinated by religion because
199 	/// of its effect on human affairs. "I love to keep poking and prodding at it. I've thought about it so much over the
200 	/// years that that fascination is bound to spill over into my writing." The evolutionary biologist and atheist
201 	/// Richard Dawkins uses Adams's influence to exemplify arguments for non-belief in his 2006 book The God Delusion.
202 	/// Dawkins dedicated the book to Adams, whom he jokingly called "possibly [my] only convert" to atheism and wrote on
203 	/// his death that "Science has lost a friend, literature has lost a luminary, the mountain gorilla and the black
204 	/// rhino have lost a gallant defender."
205 	/// 
206 	/// Environmental activism: Adams was also an environmental activist who campaigned on behalf of endangered species.
207 	/// This activism included the production of the non-fiction radio series Last Chance to See, in which he and
208 	/// naturalist Mark Carwardine visited rare species such as the kakapo and baiji, and the publication of a tie-in
209 	/// book of the same name. In 1992 this was made into a CD-ROM combination of audiobook, e-book and picture slide show.
210 	/// Adams and Mark Carwardine contributed the 'Meeting a Gorilla' passage from Last Chance to See to the book
211 	/// The Great Ape Project. This book, edited by Paola Cavalieri and Peter Singer, launched a wider-scale project in
212 	/// 1993, which calls for the extension of moral equality to include all great apes, human and non-human. In 1994, he
213 	/// participated in a climb of Mount Kilimanjaro while wearing a rhino suit for the British charity organisation Save
214 	/// the Rhino International. Puppeteer William Todd-Jones, who had originally worn the suit in the London Marathon to
215 	/// raise money and bring awareness to the group, also participated in the climb wearing a rhino suit; Adams wore the
216 	/// suit while travelling to the mountain before the climb began. About £100,000 was raised through that event,
217 	/// benefiting schools in Kenya and a black rhinoceros preservation programme in Tanzania. Adams was also an active
218 	/// supporter of the Dian Fossey Gorilla Fund. Since 2003, Save the Rhino has held an annual Douglas Adams Memorial
219 	/// Lecture around the time of his birthday to raise money for environmental campaigns.
220 	/// 
221 	/// Technology and innovation: Adams bought his first word processor in 1982, having considered one as early as 1979.
222 	/// His first purchase was a Nexu. In 1983, when he and Jane Belson went to Los Angeles, he bought a DEC Rainbow. Upon
223 	/// their return to England, Adams bought an Apricot, then a BBC Micro and a Tandy 1000. In Last Chance to See Adams
224 	/// mentions his Cambridge Z88, which he had taken to Zaire on a quest to find the northern white rhinoceros. Adams's
225 	/// posthumously published work, The Salmon of Doubt, features several articles by him on the subject of technology,
226 	/// including reprints of articles that originally ran in MacUser magazine, and in The Independent on Sunday newspaper.
227 	/// In these Adams claims that one of the first computers he ever saw was a Commodore PET, and that he had "adored" his
228 	/// Apple Macintosh ("or rather my family of however many Macintoshes it is that I've recklessly accumulated over the
229 	/// years") since he first saw one at Infocom's offices in Boston in 1984. Adams was a Macintosh user from the time they
230 	/// first came out in 1984 until his death in 2001. He was the first person to buy a Mac in Europe (the second being
231 	/// Stephen Fry – though some accounts differ on this, saying Fry bought his Mac first. Fry claims he was second to
232 	/// Adams). Adams was also an "Apple Master", celebrities whom Apple made into spokespeople for its products (others
233 	/// included John Cleese and Gregory Hines). Adams's contributions included a rock video that he created using the
234 	/// first version of iMovie with footage featuring his daughter Polly. The video was available on Adams's .Mac
235 	/// homepage. Adams installed and started using the first release of Mac OS X in the weeks leading up to his death. His
236 	/// very last post to his own forum was in praise of Mac OS X and the possibilities of its Cocoa programming framework.
237 	/// He said it was "awesome...", which was also the last word he wrote on his site. Adams used email to correspond with
238 	/// Steve Meretzky in the early 1980s, during their collaboration on Infocom's version of The Hitchhiker's Guide to the
239 	/// Galaxy. While living in New Mexico in 1993 he set up another e-mail address and began posting to his own USENET
240 	/// newsgroup, alt.fan.douglas-adams, and occasionally, when his computer was acting up, to the comp.sys.mac hierarchy.
241 	/// Challenges to the authenticity of his messages later led Adams to set up a message forum on his own website to
242 	/// avoid the issue. In 1996, Adams was a keynote speaker at the Microsoft Professional Developers Conference (PDC)
243 	/// where he described the personal computer as being a modelling device. The video of his keynote speech is archived
244 	/// on Channel 9. Adams was also a keynote speaker for the April 2001 Embedded Systems Conference in San Francisco, one
245 	/// of the major technical conferences on embedded system engineering.
246 	/// 
247 	/// Personal life: Adams moved to Upper Street, Islington, in 1981 and to Duncan Terrace, a few minutes' walk away,
248 	/// in the late 1980s. In the early 1980s Adams had an affair with novelist Sally Emerson, who was separated from her
249 	/// husband at that time. Adams later dedicated his book Life, the Universe and Everything to Emerson. In 1981 Emerson
250 	/// returned to her husband, Peter Stothard, a contemporary of Adams's at Brentwood School, and later editor of The
251 	/// Times. Adams was soon introduced by friends to Jane Belson, with whom he later became romantically involved. Belson
252 	/// was the "lady barrister" mentioned in the jacket-flap biography printed in his books during the mid-1980s
253 	/// ("He [Adams] lives in Islington with a lady barrister and an Apple Macintosh"). The two lived in Los Angeles
254 	/// together during 1983 while Adams worked on an early screenplay adaptation of Hitchhiker's. When the deal fell
255 	/// through, they moved back to London, and after several separations ("He is currently not certain where he lives,
256 	/// or with whom") and a broken engagement, they married on 25 November 1991. Adams and Belson had one daughter together,
257 	/// Polly Jane Rocket Adams, born on 22 June 1994, shortly after Adams turned 42. In 1999 the family moved from London to
258 	/// Santa Barbara, California, where they lived until his death. Following the funeral, Jane Belson and Polly Adams
259 	/// returned to London. Belson died on 7 September 2011 of cancer, aged 59.
260 	/// 
261 	/// Death and legacy: Adams died of a heart attack on 11 May 2001, aged 49, after resting from his regular workout at a
262 	/// private gym in Montecito, California. Adams had been due to deliver the commencement address at Harvey Mudd College
263 	/// on 13 May. His funeral was held on 16 May in Santa Barbara. His ashes were placed in Highgate Cemetery in north
264 	/// London in June 2002. A memorial service was held on 17 September 2001 at St Martin-in-the-Fields church, Trafalgar
265 	/// Square, London. This became the first church service broadcast live on the web by the BBC. Video clips of the
266 	/// service are still available on the BBC's website for download. One of his last public appearances was a talk given
267 	/// at the University of California, Santa Barbara, Parrots, the universe and everything, recorded days before his death.
268 	/// A full transcript of the talk is available, and the university has made the full video available on YouTube. Two
269 	/// days before Adams died, the Minor Planet Center announced the naming of asteroid 18610 Arthurdent. In 2005, the
270 	/// asteroid 25924 Douglasadams was named in his memory. In May 2002, The Salmon of Doubt was published, containing many
271 	/// short stories, essays, and letters, as well as eulogies from Richard Dawkins, Stephen Fry (in the UK edition),
272 	/// Christopher Cerf (in the US edition), and Terry Jones (in the US paperback edition). It also includes eleven
273 	/// chapters of his unfinished novel, The Salmon of Doubt, which was originally intended to become a new Dirk Gently
274 	/// novel, but might have later become the sixth Hitchhiker novel. Other events after Adams's death included a webcast
275 	/// production of Shada, allowing the complete story to be told, radio dramatisations of the final three books in the
276 	/// Hitchhiker's series, and the completion of the film adaptation of The Hitchhiker's Guide to the Galaxy. The film,
277 	/// released in 2005, posthumously credits Adams as a producer, and several design elements – including a head-shaped
278 	/// planet seen near the end of the film – incorporated Adams's features. A 12-part radio series based on the Dirk Gently
279 	/// novels was announced in 2007. BBC Radio 4 also commissioned a third Dirk Gently radio series based on the incomplete
280 	/// chapters of The Salmon of Doubt, and written by Kim Fuller;[66] but this was dropped in favour of a BBC TV series
281 	/// based on the two completed novels.[67] A sixth Hitchhiker novel, And Another Thing..., by Artemis Fowl author Eoin
282 	/// Colfer, was released on 12 October 2009 (the 30th anniversary of the first book), published with the support of
283 	/// Adams's estate. A BBC Radio 4 Book at Bedtime adaptation and an audio book soon followed. On 25 May 2001, two weeks
284 	/// after Adams's death, his fans organised a tribute known as Towel Day, which has been observed every year since then.
285 	/// In 2011, over 3,000 people took part in a public vote to choose the subjects of People's Plaques in Islington;
286 	/// Adams received 489 votes. On 11 March 2013, Adams's 61st birthday was celebrated with an interactive Google Doodle.
287 	/// In 2018, John Lloyd presented an hour-long episode of the BBC Radio Four documentary Archive on 4, discussing Adams'
288 	/// private papers, which are held at St John's College, Cambridge. The episode is available online. A street in
289 	/// São José, Santa Catarina, Brazil is named in Adams' honour.
290 	/// 
291 	
292 contract Token {
293 
294     /// @return total amount of tokens
295     function totalSupply() constant returns (uint256 supply) {}
296 
297     /// @param _owner The address from which the balance will be retrieved
298     /// @return The balance
299     function balanceOf(address _owner) constant returns (uint256 balance) {}
300 
301     /// @notice send `_value` token to `_to` from `msg.sender`
302     /// @param _to The address of the recipient
303     /// @param _value The amount of token to be transferred
304     /// @return Whether the transfer was successful or not
305     function transfer(address _to, uint256 _value) returns (bool success) {}
306 
307     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
308     /// @param _from The address of the sender
309     /// @param _to The address of the recipient
310     /// @param _value The amount of token to be transferred
311     /// @return Whether the transfer was successful or not
312     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
313 
314     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
315     /// @param _spender The address of the account able to transfer the tokens
316     /// @param _value The amount of wei to be approved for transfer
317     /// @return Whether the approval was successful or not
318     function approve(address _spender, uint256 _value) returns (bool success) {}
319 
320     /// @param _owner The address of the account owning tokens
321     /// @param _spender The address of the account able to transfer the tokens
322     /// @return Amount of remaining tokens allowed to spent
323     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
324 
325     event Transfer(address indexed _from, address indexed _to, uint256 _value);
326     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
327 
328 }
329 
330 contract StandardToken is Token {
331 
332     function transfer(address _to, uint256 _value) returns (bool success) {
333         //Default assumes totalSupply can't be over max (2^256 - 1).
334         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
335         //Replace the if with this one instead.
336         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
337         if (balances[msg.sender] >= _value && _value > 0) {
338             balances[msg.sender] -= _value;
339             balances[_to] += _value;
340             Transfer(msg.sender, _to, _value);
341             return true;
342         } else { return false; }
343     }
344 
345     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
346         //same as above. Replace this line with the following if you want to protect against wrapping uints.
347         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
348         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
349             balances[_to] += _value;
350             balances[_from] -= _value;
351             allowed[_from][msg.sender] -= _value;
352             Transfer(_from, _to, _value);
353             return true;
354         } else { return false; }
355     }
356 
357     function balanceOf(address _owner) constant returns (uint256 balance) {
358         return balances[_owner];
359     }
360 
361     function approve(address _spender, uint256 _value) returns (bool success) {
362         allowed[msg.sender][_spender] = _value;
363         Approval(msg.sender, _spender, _value);
364         return true;
365     }
366 
367     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
368       return allowed[_owner][_spender];
369     }
370 
371     mapping (address => uint256) balances;
372     mapping (address => mapping (address => uint256)) allowed;
373     uint256 public totalSupply;
374 }
375 
376 contract HHGTTG is StandardToken { // Contract Name.
377 
378     /* Public variables of the token */
379 
380     /*
381     NOTE:
382     The following variables are OPTIONAL vanities. One does not have to include them.
383     They allow one to customise the token contract & in no way influences the core functionality.
384     Some wallets/interfaces might not even bother to look at this information.
385     */
386     string public name;                   // Token Name
387     uint8 public decimals;                // How many decimals to show. To be standard compliant keep it at 18
388     string public symbol;                 // An identifier: e.g. h2g2, HHGTTG, HG2G, etc.
389     string public version = 'H1.0'; 
390     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
391     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
392     address public fundsWallet;           // Where should the raised ETH go?
393 
394     // This is a constructor function 
395     // which means the following function name has to match the contract name declared above
396     function HHGTTG() {
397         balances[msg.sender] = 42000000000000000000;	// Give the creator all initial tokens. This is set to 42.
398         totalSupply = 42000000000000000000;				// Update total supply (42)
399         name = "HHGTTG";								// Set the name for display purposes.
400         decimals = 18;									// Amount of decimals for display purposes.
401         symbol = "h2g2";								// Set the symbol for display purposes
402         unitsOneEthCanBuy = 1;							// Set the price of token for the ICO
403         fundsWallet = msg.sender;						// The owner of the contract gets ETH
404     }													// REMEMBER THIS TOKEN HAS ZERO MONETARY VALUE!
405 														// IT IS NOT WORTH THE COST TO PURCHASE IT!
406 														// PLEASE REFRAIN FROM BUYING THIS TOKEN AS IT
407 														// IS NON-REFUNDABLE!
408     function() payable{
409         totalEthInWei = totalEthInWei + msg.value;
410         uint256 amount = msg.value * unitsOneEthCanBuy;
411         require(balances[fundsWallet] >= amount);
412 
413         balances[fundsWallet] = balances[fundsWallet] - amount;
414         balances[msg.sender] = balances[msg.sender] + amount;
415 
416         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
417 
418         //Transfer ether to fundsWallet
419         fundsWallet.transfer(msg.value);                               
420     }
421 
422     /* Approves and then calls the receiving contract */
423     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
424         allowed[msg.sender][_spender] = _value;
425         Approval(msg.sender, _spender, _value);
426 
427         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
428         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
429         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
430         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
431         return true;
432     }
433 }