1 pragma solidity ^0.4.19;
2 /*	The Hitchhiker's Guide to the Galaxy (H2G2), Version 1.0.42.000.000.The.Primary.Phase
3 /*	==============================================================================================	*/
4 /*	  http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.19+commit.c4cbbb05.js			*/
5 /*	This contract MUST be compiled with OPTIMIZATION=NO via Solidity v0.4.19+commit.c4cbbb05		*/
6 /*	Attempting to compile this contract with any earlier or later  build  of  Solidity  will		*/
7 /*	result in Warnings and/or Compilation Errors. Turning  on  optimization  during  compile		*/
8 /*	will prevent the contract code from being able to Publish and Verify properly. Thus,  it		*/
9 /*	is imperative that this contract be compiled with optimization off using v0.4.19 of  the		*/
10 /*	Solidity compiler, more specifically: v0.4.19+commit.c4cbbb05.					        		*/
11 /*	==============================================================================================	*/
12 /*	THIS TOKEN IS PROUDLY BROUGHT TO YOU BY THE CAMPAIGN FOR REAL TIME  WITH  SLARTIBARTFAST		*/
13 /*	IN COOPERATION WITH THE CAMPAIGN TO SAVE THE HUMANS WITH  THE  DOLPHINS.  THIS  MAY  ALL		*/
14 /*	CEASE TO EXIST WITH THE DEATH OF AGRAJAG AT STAVROMULA BETA,  OR  SO  IT  WOULD  SEEM...		*/
15 /*	SHOUTOUT TO "THE DIGITAL VILLAGE"! 	http://www.tdv.com/											*/
16 /*										https://en.wikipedia.org/wiki/The_Digital_Village			*/
17 /*	==============================================================================================	*/
18 /*							:	The following are the details of this token as it appears			*/
19 /*							:	on the Ethereum MainNet.											*/
20 /*	Token Name				:	The Hitchhiker's Guide to the Galaxy								*/
21 /*	Version Number			:	V1.0.42.000.000.The.Primary.Phase									*/
22 /*	Total Supply			:	42,000,000 Tokens													*/
23 /*	Contract Address		:	0xb957D92D7fEaE5be6877AA94997De6dcd36B65F4							*/
24 /*	Ticker Symbol			:	H2G2																*/
25 /*	Decimals				:	18																	*/
26 /*	Creator Address			:	0x1f313f38d37705fb87feecf4e0dca4a95f74bd52							*/
27 /*	Via the Genesis Address	:	0x0000000000000000000000000000000000000000							*/
28 /*	Transaction				:	0xeed85dd48475bad57a7b06aba4780ae47e8d3473b1ce4218c9c24994188d4d40	*/
29 /*	==============================================================================================	*/
30 /*							:	The following are the details of this token as it appears			*/
31 /*							:	on the Ropsten Ethereum TestNet.									*/
32 /*	Token Name				:	The Hitchhiker's Guide to the Galaxy								*/
33 /*	Version Number			:	V1.0.42.000.000.The.Primary.Phase									*/
34 /*	Total Supply			:	42,000,000 Tokens													*/
35 /*	Contract Address		:	0xb957d92d7feae5be6877aa94997de6dcd36b65f4							*/
36 /*	Ticker Symbol			:	H2G2																*/
37 /*	Decimals				:	18																	*/
38 /*	Creator Address			:	0x1f313f38d37705fb87feecf4e0dca4a95f74bd52							*/
39 /*	Via the Genesis Address	:	0x0000000000000000000000000000000000000000							*/
40 /*	Transaction				:	0xf14d0a2d8a6616064a27f661696a7d991b174f2c6601250878d3d55dcaff4523	*/
41 /*	==============================================================================================	*/
42 /*							:	The following are the details of this token as it appears			*/
43 /*							:	on the Rinkeby Ethereum TestNet.									*/
44 /*	Token Name				:	The Hitchhiker's Guide to the Galaxy								*/
45 /*	Version Number			:	V1.0.42.000.000.The.Primary.Phase									*/
46 /*	Total Supply			:	42,000,000 Tokens													*/
47 /*	Contract Address		:	0xb957d92d7feae5be6877aa94997de6dcd36b65f4							*/
48 /*	Ticker Symbol			:	H2G2																*/
49 /*	Decimals				:	18																	*/
50 /*	Creator Address			:	0x1f313f38d37705fb87feecf4e0dca4a95f74bd52							*/
51 /*	Via the Genesis Address	:	0x0000000000000000000000000000000000000000							*/
52 /*	Transaction				:	0xd5a46e0cf8e3e05b84f3cd334dc45a3b905fcb2b76da7816a4985c6b3ac52a79	*/
53 /*	==============================================================================================	*/
54 /*							:	The following are the details of this token as it appears			*/
55 /*							:	on the Kovan Ethereum TestNet.										*/
56 /*	Token Name				:	The Hitchhiker's Guide to the Galaxy								*/
57 /*	Version Number			:	V1.0.42.000.000.The.Primary.Phase									*/
58 /*	Total Supply			:	42,000,000 Tokens													*/
59 /*	Contract Address		:	0xb957d92d7feae5be6877aa94997de6dcd36b65f4							*/
60 /*	Ticker Symbol			:	H2G2																*/
61 /*	Decimals				:	18																	*/
62 /*	Creator Address			:	0x1f313f38d37705fb87feecf4e0dca4a95f74bd52							*/
63 /*	Via the Genesis Address	:	0x0000000000000000000000000000000000000000							*/
64 /*	Transaction				:	0x83a32aa85037e350a52f6679fa52bed2efc7f873890a77dfaf47f03e0f4c7a59	*/
65 /*	==============================================================================================	*/
66 
67 /*
68 	This ERC20 Token: The Hitchhiker's Guide to the Galaxy (H2G2) is NOT meant to have any  intrinsic  (fundamental)  value  nor  any  monetary  value
69 	whatsoever. It is designed to honour the memory of Douglas Noel Adams. However, it is possible  that  this  token  may  accrue  value  over  time,
70 	although this is HIGHLY UNLIKELY. Any such valuation would likely be based entirely upon speculation, current market conditions,  the  actions  of
71 	other fanatical Douglas Adams fans (such as myself) and a myriad of other such  conditions  and/or  factors.  These  factors  and  conditions  may
72 	include, but are not limited to, the magnitude (quantity) and frequency (volume) of funds being traded for this token, if  any.  In  the  unlikely
73 	event that this token should gain monetary value at some future date, then a novel use of this token might  be  to  trade  value  and/or  pay  for
74 	memorabilia between fans and collectors of Douglas Adams memorabilia, publications and so forth. Again, do NOT count on this token to acquire  any
75 	value of any kind as it has been created solely for the purpose of honouring the memory of Douglas Adams. Should you decide to purchase this token
76 	which, again, is NOT recommended, then please be aware that they are non-refundable. See also the supplemental token: HHGTTG (h2g2),  as  detailed
77 	below. The supplemental token HHGTTG (h2g2) will be distributed via an airdop to the TOP 42 HOLDERS of this (The Hitchhiker's Guide to the  Galaxy
78 	[H2G2]) token. Whereas this (The Hitchhiker's Guide to the Galaxy [H2G2])token has a total supply of 42,000,000; the supplemental token will  have
79 	a total supply of ONLY 42 tokens @ 18 decimals and will be airdropped when greater than 55% of this  (The Hitchhiker's Guide to the Galaxy [H2G2])
80 	token has been distributed, however long that may take. Although these tokens,  The Hitchhiker's Guide to the Galaxy (H2G2) and HHGTTG (h2g2)  are
81 	not intended to have value, they may be acquired by sending eth to the contract  address  at a rate of 1000 H2G2 tokens per 1 eth and 1 h2g2 token
82 	per 1 eth. The price of h2g2 is intentionally set high to discourage purchase leaving a larger quantity for the airdrop (keep in mind  that  there
83 	exists a sum total of ONLY 42 h2g2 tokens and 42,000,000 H2G2 tokens). Note that the "ticker" symbols for these two tokens differ  only  in  case,
84 	with H2G2 being The Hitchhiker's Guide to the Galaxy token (42,000,000) and h2g2 being the HHGTTG token (42). No disrespect  is  intended  to  the
85 	memory of Douglas Noel Adams, nor his estate and heirs and neither to the BBC - all to whom  I  remain  thankful  for  these  wonderful  works  of
86 	artistic fiction. Now then, let's get on with the tribute:
87 
88 	The day of 11 May 2001 would become one of the worst days of my life for that is the date on which Douglas Adams died of  heart  failure.  My  one
89 	true hero ceased to exist as did my hope of a further H2G2 (HG2G) novel, although Eoin Colfer would eventually pen  "And Another Thing",  it  just
90 	wasn't the same. If your interest in this token is piqued, then you will no doubt know WHY the Total Supply  is  42,000,000 Tokens.  The  original
91 	intent was to have the total supply limited to only 42 Tokens  with  18  decimal  places  resulting  in  the  ability  to  acquire  as  little  as
92 	.000000000000000001 Hitchhiker's Guide to the Galaxy (H2G2) Tokens. Setting the maximum  supply  to  only  42  would  have  severely  limited  the
93 	utility of this Token, as there are far more than 42 fans of Douglas Adams in this Universe. A supplemental token WILL be created which will  have
94 	a total supply of ONLY 42 tokens and will be distributed to the 42 highest holders of this token  (in an amount to be determined).  The  following
95 	text has been lifted from WikiPedia on 8 June 2018. To see the most recent version of this text, visit:
96 	https://en.wikipedia.org/wiki/Douglas_Adams
97 
98 	Douglas Noel Adams (11 March 1952 – 11 May 2001) was an English author, scriptwriter, essayist, humorist, satirist and dramatist. Adams was author
99 	of The Hitchhiker's Guide to the Galaxy, which originated in 1978 as a BBC radio comedy before developing into a "trilogy" of five books that sold
100 	more than 15 million copies in his lifetime and generated a television series, several stage plays, comics, a computer game, and in 2005 a feature
101 	film. Adams's contribution to UK radio is commemorated in The Radio Academy's Hall of Fame. Adams also  wrote  Dirk  Gently's  Holistic  Detective
102 	Agency (1987) and The Long Dark Tea-Time of the Soul (1988), and co-wrote The Meaning of Liff (1983), The Deeper  Meaning  of  Liff  (1990),  Last
103 	Chance to See (1990), and three stories for the television series Doctor Who; he also served as script editor for the show's seventeenth season in
104 	1979. A posthumous collection of his works, including an unfinished novel, was published as The Salmon of Doubt in 2002. Adams was an advocate for
105 	environmentalism  and  conservation,  a  lover  of  fast  cars,  technological  innovation  and  the  Apple  Macintosh,  and  a  radical  atheist.
106 
107 	Early life: Adams was born on 11 March 1952 to Janet (née Donovan; 1927–2016) and Christopher Douglas Adams (1927–1985) in Cambridge, England. The
108 	Family moved to the East End of London a few months after his birth, where his sister, Susan, was born three years later. His parents divorced  in
109 	1957;   Douglas,  Susan,  and  their  mother  moved  to  an  RSPCA  animal  shelter  in  Brentwood,  Essex,  run  by  his  maternal  grandparents.
110 
111 	Education: Adams attended Primrose Hill Primary School in Brentwood. At nine, he passed the entrance exam for  Brentwood  School,  an  independent
112 	school whose alumni include Robin Day, Jack Straw, Noel Edmonds, and David Irving. Griff Rhys Jones was a year below him, and he was in  the  same
113 	class as Stuckist artist Charles Thomson. He attended the prep school from 1959 to 1964, then the main school until  December 1970.  Adams  was  6
114 	feet (1.8 m) by age 12 and stopped growing at 6 feet 5 inches (1.96 m). His form master, Frank Halford, said his height had made him stand out and
115 	that he had been self-conscious about it. His ability to write stories made him well known in the school. He became the only student  ever  to  be
116 	awarded a ten out of ten by Halford for creative writing, something he remembered for the rest of his  life,  particularly  when  facing  writer's
117 	block. Some of his earliest writing was published at the school, such as a report on its photography club in The Brentwoodian in  1962,  or  spoof
118 	reviews in the school magazine Broadsheet, edited by Paul Neil Milne Johnstone, who later became a character in  The Hitchhiker's Guide.  He  also
119 	designed the cover of one issue of the Broadsheet, and had a letter and short story published in  The Eagle, the boys'  comic,  in  1965.  A  poem
120 	entitled "A Dissertation on the task of writing a poem on a candle and an account of some of the difficulties thereto pertaining" written by Adams
121 	in January 1970, at the age of 17, was discovered in a cupboard at the school in early 2014. On the strength  of  a  bravura  essay  on  religious
122 	poetry that discussed the Beatles and William Blake, he was awarded an Exhibition in English at St John's College, Cambridge, going up in 1971. He
123 	wanted to join the Footlights, an invitation-only student comedy club that has  acted  as  a  hothouse  for  comic  talent.  He  was  not  elected
124 	immediately as he had hoped, and started to write and perform in revues with Will Adams (no relation) and Martin Smith,  forming  a  group  called
125 	"Adams-Smith-Adams", but became a member of the Footlights by 1973. Despite doing very little work—he recalled having completed  three  essays  in
126 	three years—he graduated in 1974 with a B.A. in English literature.
127 
128 	Career: Writing: After leaving university Adams moved back to London, determined to break into TV and radio as a writer. An edited version of  the
129 	Footlights Revue appeared on BBC2 television in 1974. A version of the Revue performed live in London's West End led to Adams being discovered  by
130 	Monty Python's Graham Chapman. The two formed a brief writing partnership, earning Adams a writing credit in  episode 45  of  Monty Python  for  a
131 	sketch called "Patient Abuse". The pair also co-wrote the "Marilyn Monroe" sketch which appeared on the soundtrack album of Monty Python  and  the
132 	Holy Grail. Adams is one of only two people other than the original Python members to get a writing credit (the other being Neil Innes). Adams had
133 	two brief appearances in the fourth series of Monty Python's Flying Circus. At the beginning of episode 42,  "The Light Entertainment War",  Adams
134 	is in a surgeon's mask (as Dr. Emile Koning, according to on-screen captions), pulling on gloves, while  Michael  Palin  narrates  a  sketch  that
135 	introduces one person after another but never gets started. At the beginning of episode 44, "Mr. Neutron", Adams is dressed in a pepper-pot outfit
136 	and loads a missile onto a cart driven by Terry Jones, who is calling for scrap metal ("Any old iron..."). The  two  episodes  were  broadcast  in
137 	November 1974. Adams and Chapman also attempted non-Python projects, including Out of the Trees. At this point Adams's career stalled; his writing
138 	style was unsuited to the then-current style of radio and TV comedy. To make ends meet he took a series of  odd  jobs,  including  as  a  hospital
139 	porter, barn builder, and chicken shed cleaner. He was employed as a bodyguard by a Qatari family, who had made their fortune in oil. During  this
140 	time Adams continued to write and submit sketches, though few were accepted. In 1976 his  career  had  a  brief  improvement  when  he  wrote  and
141 	performed Unpleasantness at Brodie's Close at the Edinburgh Fringe festival. By Christmas, work had dried up again, and a depressed Adams moved to
142 	live with his mother. The lack of writing work hit him hard and low confidence became a feature of Adams's life; "I have terrible periods of  lack
143 	of confidence. I briefly did therapy, but after a while I realised it was like a farmer complaining about the weather. You can't fix the weather –
144 	you just have to get on with it". Some of Adams's early radio work included sketches for The Burkiss Way in 1977 and The News Huddlines.  He  also
145 	wrote, again with Chapman, the 20 February 1977 episode of Doctor on the Go, a sequel to the Doctor in the House television comedy  series.  After
146 	the first radio series of The Hitchhiker's Guide became successful, Adams was made a BBC radio producer, working on Week Ending  and  a  pantomime
147 	called Black Cinderella Two Goes East. He left after six months to become the script editor for Doctor Who. In 1979  Adams  and  John Lloyd  wrote
148 	scripts for two half-hour episodes of Doctor Snuggles: "The Remarkable Fidgety River" and  "The Great Disappearing Mystery"  (episodes  eight  and
149 	twelve). John Lloyd was also co-author of two episodes from the original Hitchhiker radio series ("Fit the Fifth" and "Fit the Sixth", also  known
150 	as "Episode Five" and "Episode Six"), as well as The Meaning of Liff and The Deeper Meaning of Liff.
151 
152 	The Hitchhiker's Guide to the Galaxy: The Hitchhiker's Guide to the Galaxy was a concept for a science-fiction  comedy  radio  series  pitched  by
153 	Adams and radio producer Simon Brett to BBC Radio 4 in 1977. Adams came up with an outline for a pilot episode, as well as  a  few  other  stories
154 	(reprinted in Neil Gaiman's book Don't Panic: The Official Hitchhiker's Guide to the Galaxy Companion) that could be used in the series. According
155 	to Adams, the idea for the title occurred to him while he lay drunk in a field in Innsbruck, Austria, gazing at the stars. He was carrying a  copy
156 	of the Hitch-hiker's Guide to Europe, and it occurred to him that "somebody ought to write a Hitchhiker's Guide to the Galaxy". He later said that
157 	the constant repetition of this anecdote had obliterated his memory of the actual event. Despite the original outline, Adams was said to  make  up
158 	the stories as he wrote. He turned to John Lloyd for help with the final two episodes  of  the  first  series.  Lloyd  contributed  bits  from  an
159 	unpublished science fiction book of his own, called GiGax. Very little of Lloyd's material survived in later adaptations of Hitchhiker's, such  as
160 	the novels and the TV series. The TV series was based on the first six radio episodes, and sections contributed by Lloyd were largely  re-written.
161 	BBC Radio 4 broadcast the first radio series weekly in the UK in March and April 1978. The series was distributed in the United States by National
162 	Public Radio. Following the success of the first series, another episode was recorded and broadcast, which was commonly  known  as  the  Christmas
163 	Episode. A second series of five episodes was broadcast one per night, during the week of 21–25 January 1980. While working on  the  radio  series
164 	(and with simultaneous projects such as The Pirate Planet) Adams developed problems keeping to writing deadlines that got worse  as  he  published
165 	novels. Adams was never a prolific writer and usually had to be forced by others to do any writing. This included being locked in  a  hotel  suite
166 	with his editor for three weeks to ensure that So Long, and Thanks for All the Fish was completed. He was quoted as saying,  "I love deadlines.  I
167 	love the whooshing noise they make as they go by." Despite the difficulty with deadlines, Adams wrote five novels  in  the  series,  published  in
168 	1979, 1980, 1982, 1984, and 1992. The books formed the basis for other adaptations, such as three-part comic book  adaptations  for  each  of  the
169 	first three books, an interactive text-adventure computer game, and a photo-illustrated edition, published in 1994. This latter edition featured a
170 	42 Puzzle designed by Adams, which was later incorporated into paperback covers of the first four Hitchhiker's novels (the paperback for the fifth
171 	re-used the artwork from the hardback edition). In 1980 Adams began attempts to turn the first Hitchhiker's novel  into  a  film,  making  several
172 	trips to Los Angeles, and working with Hollywood studios and potential producers. The next year, the radio series  became  the  basis  for  a  BBC
173 	television mini-series broadcast in six parts. When he died in 2001 in California, he had been trying again to get the movie project started  with
174 	Disney, which had bought the rights in 1998. The screenplay got a posthumous re-write by Karey Kirkpatrick, and the resulting film was released in
175 	2005. Radio producer Dirk Maggs had consulted with Adams, first in 1993, and later in 1997 and 2000 about creating a third radio series, based  on
176 	the third novel in the Hitchhiker's series. They also discussed the possibilities of radio adaptations of the final two novels  in  the  five-book
177 	"trilogy". As with the movie, this project was realised only after Adams's death. The third series, The Tertiary Phase, was broadcast on BBC Radio
178 	4 in September 2004 and was subsequently released on audio CD. With the aid of a recording of his reading of Life, the Universe and Everything and
179 	editing, Adams can be heard playing the part of Agrajag posthumously. So Long, and Thanks for All the Fish and Mostly Harmless made up the  fourth
180 	and fifth radio series, respectively (on radio they were titled The Quandary Phase and The Quintessential Phase) and these were broadcast  in  May
181 	and June 2005, and also subsequently released on Audio CD. The last episode in the last series (with a new, "more upbeat" ending) concluded  with,
182 	"The very final episode of The Hitchhiker's Guide to the Galaxy by Douglas Adams is affectionately dedicated to its author."
183 
184 	Dirk Gently series: Between Adams's first trip to Madagascar with Mark Carwardine in 1985, and their series of travels that formed the  basis  for
185 	the radio series and non-fiction book Last Chance to See, Adams wrote two other novels  with  a  new  cast  of  characters. Dirk Gently's Holistic
186 	Detective Agency was published in 1987, and was described by  its  author  as  "a kind of ghost-horror-detective-time-travel-romantic-comedy-epic,
187 	mainly concerned with mud, music and quantum mechanics". It was derived from two Doctor Who serials Adams had  written.  A  sequel,  The Long Dark
188 	Tea-Time of the Soul, was published a year later. This was an entirely original work, Adams's  first  since  So Long, and Thanks for All the Fish.
189 	After  the  book  tour,  Adams  set  off  on  his  round-the-world  excursion  which  supplied  him  with  the  material  for  Last Chance to See.
190 
191 	Doctor Who: Adams sent the script for the HHGG pilot radio programme to the Doctor Who production office in 1978, and was  commissioned  to  write
192 	The Pirate Planet (see below). He had also previously attempted to submit a potential movie script, called "Doctor Who and the Krikkitmen",  which
193 	later became his novel Life, the Universe and Everything (which in turn became the third Hitchhiker's Guide radio series). Adams then went  on  to
194 	serve as script editor on the show for its seventeenth season in 1979. Altogether, he wrote three Doctor Who serials  starring  Tom Baker  as  the
195 	Doctor: "The Pirate Planet" (the second serial in the "Key to Time" arc, in season 16) "City of Death" (with  producer  Graham Williams,  from  an
196 	original storyline by writer David Fisher. It was transmitted under the pseudonym "David Agnew") "Shada" (only partially filmed; not televised due
197 	to industry disputes) The episodes authored by Adams are some of the few that were not novelised as Adams would not allow  anyone  else  to  write
198 	them, and asked for a higher price than the publishers were willing to pay. "Shada" was later adapted as a novel by  Gareth Roberts  in  2012  and
199 	"City of Death" and "The Pirate Planet" by James Goss in 2015 and 2017 respectively. Elements of Shada and City of Death were  reused  in  Adams's
200 	later novel Dirk Gently's Holistic Detective Agency, in particular the character of Professor Chronotis. Big Finish Productions eventually  remade
201 	Shada as an audio play starring Paul McGann as the Doctor. Accompanied by partially animated illustrations, it was webcast on the BBC  website  in
202 	2003, and subsequently released as a two-CD set later that year. An omnibus edition of this version was broadcast on  the  digital  radio  station
203 	BBC7 on 10 December 2005. In the Doctor Who 2012 Christmas episode The Snowmen, writer Steven Moffat  was  inspired  by  a  storyline  that  Adams
204 	pitched called The Doctor Retires.
205 
206 	Music: Adams played the guitar left-handed and had a collection of twenty-four left-handed guitars when he died (having received his first  guitar
207 	in 1964). He also studied piano in the 1960s with the same teacher as Paul Wickens, the pianist who plays in Paul McCartney's band  (and  composed
208 	the music for the 2004–2005 editions of the Hitchhiker's Guide radio series). Pink Floyd and Procol Harum had important influence on Adams'  work.
209 
210 	Pink Floyd: Adams's official biography shares its name with the song  "Wish You Were Here"  by  Pink Floyd.  Adams  was  friends  with  Pink Floyd
211 	guitarist David Gilmour and, on Adams's 42nd birthday, he was invited to make a guest appearance at Pink Floyd's concert of  28  October  1994  at
212 	Earls Court in London, playing guitar on the songs "Brain Damage" and "Eclipse". Adams chose the name  for  Pink Floyd's 1994 album,  The Division
213 	Bell, by picking the words from the lyrics to one of its tracks, "High Hopes". Gilmour also performed at Adams's memorial  service  in  2001,  and
214 	what would have been Adams's 60th birthday party in 2012.
215 	
216 	Computer games and projects: Douglas Adams created an interactive fiction version of HHGG with Steve Meretzky from Infocom in  1984.  In  1986  he
217 	participated in a week-long brainstorming session with the Lucasfilm Games team for the game Labyrinth. Later he was  also  involved  in  creating
218 	Bureaucracy as a parody of events in his own life. Adams was a founder-director and Chief Fantasist of The Digital Village, a  digital  media  and
219 	Internet company with which he created Starship Titanic, a Codie Award-winning and BAFTA-nominated adventure game, which was published in 1998  by
220 	Simon & Schuster. Terry Jones wrote the accompanying book, entitled Douglas Adams' Starship Titanic, since Adams was too busy  with  the  computer
221 	game to do both. In April 1999, Adams initiated the H2G2 collaborative writing project, an experimental attempt at  making  The Hitchhiker's Guide
222 	to the Galaxy a reality, and at harnessing the collective brainpower of the internet community. It was hosted by BBC Online from 2001 to 2011.  In
223 	1990, Adams wrote and presented a television documentary programme Hyperland which featured  Tom Baker  as  a  "software agent"  (similar  to  the
224 	assistant pictured in Apple's Knowledge Navigator video of future concepts  from  1987),  and  interviews  with  Ted Nelson,  the  co-inventor  of
225 	hypertext and the person who coined the term. Adams was an early adopter and advocate of hypertext.
226 
227 	Personal beliefs and activism: Atheism and views on religion: Adams described himself as a "radical atheist", adding "radical" for emphasis so  he
228 	would not be asked if he meant agnostic. He told American Atheists that this conveyed the fact that he really meant it.  He  imagined  a  sentient
229 	puddle who wakes up one morning and thinks, "This is an interesting world I find myself in – an interesting hole I find myself in – fits me rather
230 	neatly, doesn't it? In fact it fits me staggeringly well, must have been made to have me in it!" to  demonstrate  his  view  that  the  fine-tuned
231 	Universe argument for God was a fallacy. He remained fascinated by religion because of its effect  on  human  affairs.  "I love to keep poking and
232 	prodding at it. I've thought about it so much over the years that that fascination is bound to spill  over  into  my  writing."  The  evolutionary
233 	biologist and atheist Richard Dawkins uses Adams's influence to exemplify arguments for non-belief in  his  2006  book  The God Delusion.  Dawkins
234 	dedicated the book to Adams, whom he jokingly called "possibly [my] only convert" to atheism and  wrote  on  his  death  that  "Science has lost a
235 	friend, literature has lost a luminary, the mountain gorilla and the black rhino have lost a gallant defender."
236 
237 	Environmental activism: Adams was also an environmental activist who campaigned on behalf  of  endangered  species.  This  activism  included  the
238 	production of the non-fiction radio series Last Chance to See, in which he and naturalist Mark Carwardine visited rare species such as the  kakapo
239 	and baiji, and the publication of a tie-in book of the same name. In 1992 this was made into a CD-ROM combination of audiobook, e-book and picture
240 	slide show. Adams and Mark Carwardine contributed the 'Meeting a Gorilla' passage from Last Chance to See to the book The Great Ape Project.  This
241 	book, edited by Paola Cavalieri and Peter Singer, launched a wider-scale project in 1993, which calls for  the  extension  of  moral  equality  to
242 	include all great apes, human and non-human. In 1994, he participated in a climb of Mount Kilimanjaro while wearing a rhino suit for  the  British
243 	charity organisation Save the Rhino International. Puppeteer William Todd-Jones, who had originally worn the suit in the London Marathon to  raise
244 	money and bring awareness to the group, also participated in the climb wearing a rhino suit; Adams wore the suit while travelling to the  mountain
245 	before the climb began. About £100,000 was raised through that event, benefiting schools in Kenya and a black rhinoceros preservation programme in
246 	Tanzania. Adams was also an active supporter of the Dian Fossey Gorilla Fund. Since 2003, Save the Rhino has held an annual Douglas Adams Memorial
247 	Lecture around the time of his birthday to raise money for environmental campaigns.
248 
249 	Technology and innovation: Adams bought his first word processor in 1982, having considered one as early as 1979. His first purchase was  a  Nexu.
250 	In 1983, when he and Jane Belson went to Los Angeles, he bought a DEC Rainbow. Upon their return to England, Adams bought an Apricot, then  a  BBC
251 	Micro and a Tandy 1000. In Last Chance to See Adams mentions his Cambridge Z88, which he had taken to Zaire on a quest to find the northern  white
252 	rhinoceros. Adams's posthumously published work, The Salmon of Doubt, features several articles by him on the  subject  of  technology,  including
253 	reprints of articles that originally ran in MacUser magazine, and in The Independent on Sunday newspaper. In these Adams claims that  one  of  the
254 	first computers he ever saw was a Commodore PET, and that he had "adored" his Apple Macintosh ("or rather my family of however many Macintoshes it
255 	is that I've recklessly accumulated over the years") since he first saw one at Infocom's offices in Boston in 1984. Adams  was  a  Macintosh  user
256 	from the time they first came out in 1984 until his death in 2001. He was the first person to buy a Mac in Europe (the  second  being  Stephen Fry
257 	– though some accounts differ on this, saying Fry bought his Mac first. Fry claims he was second to Adams).  Adams  was  also  an  "Apple Master",
258 	celebrities whom Apple made into spokespeople for its products (others included John Cleese and Gregory Hines). Adams's contributions  included  a
259 	rock video that he created using the first version of iMovie with footage featuring his daughter Polly. The video was available  on  Adams's  .Mac
260 	homepage. Adams installed and started using the first release of Mac OS X in the weeks leading up to his death. His very  last  post  to  his  own
261 	forum was in praise of Mac OS X and the possibilities of its Cocoa programming framework. He said it was "awesome...", which  was  also  the  last
262 	word he wrote on his site. Adams used email to correspond with Steve Meretzky in the early 1980s, during their collaboration on Infocom's  version
263 	of The Hitchhiker's Guide to the Galaxy. While living in New Mexico in 1993 he set up another e-mail address and began posting to his  own  USENET
264 	newsgroup, alt.fan.douglas-adams, and occasionally, when his computer was acting up, to the comp.sys.mac hierarchy. Challenges to the authenticity
265 	of his messages later led Adams to set up a message forum on his own website to avoid the issue. In 1996, Adams  was  a  keynote  speaker  at  the
266 	Microsoft Professional Developers Conference (PDC) where he described the personal computer as being a modelling device. The video of his  keynote
267 	speech is archived on Channel 9. Adams was also a keynote speaker for the April 2001 Embedded Systems Conference  in  San Francisco,  one  of  the
268 	major technical conferences on embedded system engineering.
269 
270 	Personal life: Adams moved to Upper Street, Islington, in 1981 and to Duncan Terrace, a few minutes' walk away, in the late 1980s.  In  the  early
271 	1980s Adams had an affair with novelist Sally Emerson, who was separated from her husband at that time. Adams later dedicated his  book  Life, the
272 	Universe and Everything to Emerson. In 1981 Emerson returned to her husband, Peter Stothard, a contemporary of Adams's  at  Brentwood School,  and
273 	later editor of The Times. Adams was soon introduced by friends to Jane Belson, with whom he later became romantically involved.  Belson  was  the
274 	"lady barrister" mentioned in the jacket-flap biography printed in his books during the mid-1980s ("He [Adams] lives  in  Islington  with  a  lady
275 	barrister and an Apple Macintosh"). The two lived in Los Angeles together during 1983 while Adams worked on  an  early  screenplay  adaptation  of
276 	Hitchhiker's. When the deal fell through, they moved back to London, and after several separations ("He is currently not certain where  he  lives,
277 	or with whom") and a broken engagement, they married on 25 November 1991. Adams and Belson had  one  daughter  together,  Polly Jane Rocket Adams,
278 	born on 22 June 1994, shortly after Adams turned 42. In 1999 the family moved from London to Santa Barbara, California, where they lived until his
279 	death. Following the  funeral,  Jane Belson  and  Polly Adams  returned  to  London.  Belson  died  on  7  September  2011  of  cancer,  aged  59.
280 
281 	Death and legacy: Adams died of a heart attack on 11 May 2001, aged 49, after resting from his regular workout at  a  private  gym  in  Montecito,
282 	California. Adams had been due to deliver the commencement address at Harvey Mudd College on 13 May. His funeral was  held  on  16  May  in  Santa
283 	Barbara. His ashes were placed in Highgate Cemetery in  north  London  in  June  2002.  A  memorial  service  was  held  on  17 September 2001  at
284 	St Martin-in-the-Fields church, Trafalgar Square, London. This became the first church service broadcast live on the web by the  BBC.  Video clips
285 	of the service are still available on the BBC's website for download. One of his last public appearances was a talk given  at  the  University  of
286 	California, Santa Barbara, Parrots, the universe and everything, recorded days before his death. A full transcript of the talk is  available,  and
287 	the university has made the full video available on YouTube. Two days before Adams died, the Minor Planet Center announced the naming of  asteroid
288 	18610 Arthurdent. In 2005, the asteroid 25924 Douglasadams was named in his memory. In May 2002,  The Salmon of Doubt  was  published,  containing
289 	many short stories, essays, and letters, as well as eulogies from Richard Dawkins, Stephen Fry (in the UK edition), Christopher Cerf  (in  the  US
290 	edition), and Terry Jones (in the US paperback edition). It also includes eleven chapters of his unfinished novel, The Salmon of Doubt, which  was
291 	originally intended to become a new Dirk Gently novel, but might have later become the sixth Hitchhiker novel. Other events  after  Adams's  death
292 	included a webcast production of Shada, allowing the complete story to be told, radio dramatisations of the final three books in the  Hitchhiker's
293 	series, and the completion of the film adaptation of The Hitchhiker's Guide to the Galaxy. The film, released in 2005, posthumously credits  Adams
294 	as a producer, and several design elements – including a head-shaped planet seen near the end of the  film  –  incorporated  Adams's  features.  A
295 	12-part radio series based on the Dirk Gently novels was announced in 2007. BBC Radio 4 also commissioned a third Dirk Gently radio  series  based
296 	on the incomplete chapters of The Salmon of Doubt, and written by Kim Fuller; but this was dropped in favour of a BBC TV series based on  the  two
297 	completed novels. A sixth Hitchhiker novel, And Another Thing..., by Artemis Fowl author Eoin Colfer, was released on 12 October  2009  (the  30th
298 	anniversary of the first book), published with the support of Adams's estate. A BBC Radio 4 Book at Bedtime adaptation  and  an  audio  book  soon
299 	followed. On 25 May 2001, two weeks after Adams's death, his fans organised a tribute known as Towel Day, which has been observed every year since
300 	then. In 2011, over 3,000 people took part in a public vote to choose the subjects of People's Plaques in Islington; Adams received 489 votes.  On
301 	11 March 2013, Adams's 61st birthday was celebrated with an interactive Google Doodle. In 2018, John Lloyd presented an hour-long episode  of  the
302 	BBC Radio Four documentary Archive on 4, discussing Adams' private papers,  which  are  held  at  St John's College,  Cambridge.  The  episode  is
303 	available online. A street in São José, Santa Catarina, Brazil is named in Adams' honour.
304 
305 	The following text has been lifted from WikiPedia on 14 June 2018. To see the most recent version of this text, visit:
306 	https://en.wikipedia.org/wiki/The_Hitchhiker%27s_Guide_to_the_Galaxy
307 	The Hitchhiker's Guide to the Galaxy (sometimes referred to as HG2G, HHGTTG or H2G2 is a comedy science fiction series created  by  Douglas Adams.
308 	Originally a radio comedy broadcast on BBC Radio 4 in 1978, it was later adapted to other formats, including stage shows, novels,  comic books,  a
309 	1981 TV series, a 1984 video game, and 2005 feature film. A prominent series in British popular culture, The Hitchhiker's Guide to the Galaxy  has
310 	become an international multi-media phenomenon; the novels are the most widely distributed, having been translated into more than 30 languages  by
311 	2005. In 2017, BBC Radio 4 announced a 40th-anniversary celebration with Dirk Maggs, one of the original producers, in charge. This  sixth  series
312 	of the sci-fi spoof has been based on Eoin Colfer's book And Another Thing, with additional unpublished material by Douglas Adams.  The  first  of
313 	six new episodes was broadcast on 8 March 2018. The broad narrative of Hitchhiker follows the misadventures of  the  last  surviving  man,  Arthur
314 	Dent, following the demolition of the planet Earth by a Vogon constructor fleet to make way for a hyperspace bypass. Dent is rescued from  Earth's
315 	destruction by Ford Prefect, a human-like  alien  writer  for  the  eccentric,  electronic travel guide  The Hitchhiker's Guide to the Galaxy,  by
316 	hitchhiking onto a passing Vogon spacecraft. Following his rescue, Dent explores the galaxy with Prefect and encounters  Trillian,  another  human
317 	that had been taken from Earth prior to its destruction by the  President of the Galaxy,  the  two-headed  Zaphod Beeblebrox,  and  the  depressed
318 	Marvin, the Paranoid Android. Certain narrative details were changed between the various adaptations.
319 
320 	Plot: The various versions follow the same basic plot but they are in many places mutually contradictory, as Adams rewrote the story substantially
321 	for each new adaptation. Throughout all versions, the  series  follows  the  adventures  of  Arthur Dent,  a  hapless  Englishman,  following  the
322 	destruction of the Earth by the Vogons, a race of unpleasant and bureaucratic aliens, to make way for an intergalactic bypass.  Dent's  adventures
323 	intersect with several other characters: Ford Prefect (who named himself after the Ford Prefect car to blend in with what was assumed  to  be  the
324 	dominant life form, automobiles), an alien from a small planet somewhere in the  vicinity  of  Betelgeuse  and  a  researcher  for  the  eponymous
325 	guidebook, who rescues Dent from Earth's destruction; Zaphod Beeblebrox, Ford's eccentric semi-cousin and the  Galactic President;  the  depressed
326 	robot Marvin the Paranoid Android; and Trillian, formerly known as Tricia McMillan, a woman Arthur once met at a party in Islington and  the  only
327 	other human survivor of Earth's destruction thanks to Beeblebrox' intervention.
328 
329 	Background: The first radio series comes from a proposal called "The Ends of the Earth": six self-contained  episodes,  all  ending  with  Earth's
330 	being destroyed in a different way. While writing the first episode, Adams realized that he needed someone on the  planet  who  was  an  alien  to
331 	provide some context, and that this alien needed a reason to be there. Adams finally settled on  making  the  alien  a  roving  researcher  for  a
332 	"wholly remarkable book" named The Hitchhiker's Guide to the Galaxy. As the first radio episode's writing progressed, the Guide became the  centre
333 	of his story, and he decided to focus the series on it, with the destruction of Earth being the only hold-over. Adams claimed that the title  came
334 	from a 1971 incident while he was hitchhiking around Europe as a young man with a copy of  the  Hitch-hiker's Guide to Europe  book:  while  lying
335 	drunk in a field near Innsbruck with a copy of the book and looking up at the stars, he thought it would be a good idea for  someone  to  write  a
336 	hitchhiker's guide to the galaxy as well. However, he later claimed that he had told this story so many times that he had forgotten  the  incident
337 	itself, and only remembered himself telling the story. His friends are quoted as saying that Adams mentioned the idea of "hitch-hiking around  the
338 	galaxy" to them while on holiday in Greece in 1973. Adams's fictional Guide  is  an  electronic  guidebook  to  the  entire  universe,  originally
339 	published by Megadodo Publications, one of the great publishing houses of Ursa Minor Beta. The narrative of the various versions of the story  are
340 	frequently punctuated with excerpts from the Guide. The voice of the Guide (Peter Jones in the first two  radio  series  and  TV  versions,  later
341 	William Franklyn in the third, fourth and  fifth  radio  series,  and  Stephen Fry  in  the  movie  version),  also  provides  general  narration.
342 
343 	Original radio series: The first radio series of six episodes (called "Fits" after the names of the sections of Lewis Carroll's nonsense poem "The
344 	Hunting of the Snark") was broadcast in 1978 on BBC Radio 4. Despite a low-key launch of the series (the first episode was broadcast  at  10:30 pm
345 	on Wednesday, 8 March 1978), it received generally good reviews and a tremendous audience reaction for radio.  A  one-off  episode  (a  "Christmas
346 	special") was broadcast later in the year. The BBC had a practice at the time of commissioning  "Christmas Special"  episodes  for  popular  radio
347 	series, and while an early draft of this episode of The Hitchhiker's Guide had a Christmas-related plotline, it was  decided  to  be  "in slightly
348 	poor taste" and the episode as transmitted served as a bridge between the two series. This episode was released as part of the second radio series
349 	and, later, The Secondary Phase on cassettes and CDs. The Primary and Secondary Phases were aired, in a slightly edited  version,  in  the  United
350 	States on NPR Playhouse. The first series was repeated twice in 1978 alone and many more  times  in  the  next  few  years.  This  led  to  an  LP
351 	re-recording, produced independently of the BBC for sale, and a further adaptation of the series as a book. A second radio series, which consisted
352 	of a further six episodes, and bringing the total number of episodes to 12, was broadcast in 1980. The radio  series  (and the LP and TV versions)
353 	greatly benefited from the narration of noted comedy actor Peter Jones as The Book. He was cast after it was decided that a "Peter Jonesy" sort of
354 	voice was required. This led to a three-month search for an actor who sounded exactly like Peter Jones, which was unsuccessful. The producers then
355 	hired Peter Jones as exactly the "Peter Jonesy" voice they were looking for. The series was also notable for its use of  sound,  being  the  first
356 	comedy series to be produced in stereo. Adams said that he wanted the programme's production to be comparable to that of a modern rock album. Much
357 	of the programme's budget was spent on sound effects, which were largely the work of Paddy Kingsland (for  the  pilot  episode  and  the  complete
358 	second series) at the BBC Radiophonic Workshop and Dick Mills and Harry Parker (for the remaining  episodes (2–6) of the first series).  The  fact
359 	that they were at the forefront of modern radio production in 1978 and 1980 was reflected when the three new series of Hitchhiker's became some of
360 	the first radio shows to be mixed into four-channel Dolby Surround. This mix was also featured on DVD releases of  the  third  radio  series.  The
361 	theme tune used for the radio, television, LP and film versions is "Journey of the Sorcerer", an instrumental piece composed by Bernie Leadon  and
362 	recorded by The Eagles on their album One of These Nights. Only the transmitted radio series used the original recording; a sound-alike  cover  by
363 	Tim Souster was used for the LP and TV series, another arrangement by Joby Talbot was used for the 2005 film, and still another arrangement,  this
364 	time by Philip Pope, was recorded to be released with the CDs of the  last  three  radio  series.  Apparently,  Adams  chose  this  song  for  its
365 	futuristic-sounding nature, but also for the fact that it had a banjo in it, which, as Geoffrey Perkins recalls, Adams said would give an  "on the
366 	road, hitch-hiking feel" to it. The twelve episodes were released (in a slightly edited form, removing the Pink Floyd music and  two  other  tunes
367 	"hummed" by Marvin when the team land on Magrathea) on CD and cassette in 1988, becoming the first CD release in  the  BBC Radio Collection.  They
368 	were re-released in 1992, and at this time Adams suggested that they could retitle Fits the First to Sixth  as  "The Primary Phase"  and  Fits the
369 	Seventh to Twelfth as "The Secondary Phase" instead of just "the first series" and "the second series". It was at about this time that a "Tertiary
370 	Phase" was first discussed with Dirk Maggs, adapting Life, the Universe and Everything, but this series would not  be  recorded  for  another  ten
371 	years. Main cast:
372 						Simon Jones as Arthur Dent
373 						Geoffrey McGivern as Ford Prefect
374 						Susan Sheridan as Trillian
375 						Mark Wing-Davey as Zaphod Beeblebrox
376 						Stephen Moore as Marvin, the Paranoid Android
377 						Richard Vernon as Slartibartfast
378 						Peter Jones as The Book
379 
380 	Novels: The novels are described as "a trilogy in five parts", having been described as a trilogy on the release of the  third book,  and  then  a
381 	"trilogy in four parts" on the release of the fourth book. The US edition of the fifth book was originally released  with  the  legend  "The fifth
382 	book in the increasingly inaccurately named Hitchhiker's Trilogy" on the cover. Subsequent re-releases of the other novels bore  the  legend  "The
383 	[first, second, third, fourth] book in the increasingly inaccurately named Hitchhiker's Trilogy".  In  addition,  the  blurb  on  the  fifth  book
384 	describes it as "the book that gives a whole new meaning to the word 'trilogy'". The plots of the television and radio series are more or less the
385 	same as that of the first two novels, though some of the events occur in a different order and many of the details are changed. Much of parts five
386 	and six of the radio series were written by John Lloyd, but his material did not make it into the other versions of the story and is not  included
387 	here. Many consider the books' version of events to be definitive because they are the most readily accessible and widely distributed  version  of
388 	the story. However, they are not the final version that Adams produced. Before his death from a heart attack on 11 May 2001, Adams was considering
389 	writing a sixth novel in the Hitchhiker's series. He was working on a third Dirk Gently novel, under the  working  title  The Salmon of Doubt, but
390 	felt that the book was not working and abandoned it. In an interview, he said some of the ideas in the book might fit better  in  the Hitchhiker's
391 	series, and suggested he might rework those ideas into a sixth book in that series. He described Mostly Harmless as "a very bleak book"  and  said
392 	he "would love to finish Hitchhiker on a slightly more upbeat note". Adams also remarked that if he were to write a sixth instalment, he would  at
393 	least start with all the characters in the same place. Eoin Colfer, who wrote the sixth book in the Hitchhiker's  series  in  2008–09,  used  this
394 	latter concept but none of the plot ideas from The Salmon of Doubt.
395 	
396 	The Hitchhiker's Guide to the Galaxy: In The Hitchhiker's Guide to the Galaxy (published in 1979),  the  characters  visit  the  legendary  planet
397 	Magrathea, home to the now-collapsed planet-building industry, and meet Slartibartfast, a planetary coastline designer who was responsible for the
398 	fjords of Norway. Through archival recordings, he relates the story of a race of hyper-intelligent pan-dimensional beings  who  built  a  computer
399 	named Deep Thought to calculate the Answer to the Ultimate Question of Life, the Universe, and Everything. When the answer was revealed to be  42,
400 	Deep Thought explained that the answer was incomprehensible because the beings didn't know what they were asking.  It  went  on  to  predict  that
401 	another computer, more powerful than itself would be made and designed by it to calculate the question for  the  answer.  (Later  on,  referencing
402 	this, Adams would  create  the 42 Puzzle, a puzzle which could be approached in multiple ways, all yielding the answer 42.)  The  computer,  often
403 	mistaken for a planet (because of its size and use of biological components), was the Earth, and was  destroyed  by  Vogons  to  make  way  for  a
404 	hyperspatial express route five minutes before the conclusion of its 10-million-year  program.  Two  members  of  the  race  of  hyper-intelligent
405 	pan-dimensional beings who commissioned the Earth in the first place disguise themselves as Trillian's mice, and want to dissect Arthur's brain to
406 	help reconstruct the question, since he was part of the Earth's matrix moments before it was destroyed, and so he is likely to have  part  of  the
407 	question buried in his brain. Trillian is also human but had left Earth six months previously with Zaphod Beeblebrox, President of the Galaxy. The
408 	protagonists escape, setting the course for "The Restaurant at the End of the Universe". The mice, in Arthur's absence, create  a  phony  question
409 	since it is too troublesome for them to wait 10 million years again just to cash in on a lucrative deal. The book was adapted from the first  four
410 	radio episodes. It was first published in 1979, initially in paperback, by Pan Books, after BBC Publishing had turned down the offer of publishing
411 	a novelization, an action they would later regret. The book reached number one on the book charts in only its second week, and sold  over  250,000
412 	copies within three months of its release. A hardback edition was published by Harmony Books, a division of Random House in the  United States  in
413 	October 1980, and the 1981 US paperback edition was promoted by the give-away of 3,000 free copies in the magazine Rolling Stone to build word  of
414 	mouth. In 2005, Del Rey Books rereleased the Hitchhiker series with new covers for the release of the 2005 movie. To date, it  has  sold  over  14
415 	million copies. A photo-illustrated edition of the first novel appeared in 1994.
416 	
417 	The Restaurant at the End of the Universe: In The Restaurant at the End of the Universe (published in 1980), Zaphod is separated from  the  others
418 	and finds he is part of a conspiracy to uncover who really runs the Universe. Zaphod meets Zarniwoop, a conspirator and editor for The Guide,  who
419 	knows where to find the secret ruler. Zaphod becomes briefly reunited with the others for a trip to Milliways, the restaurant of the title. Zaphod
420 	and Ford decide to steal a ship from there, which turns out to be a stunt ship pre-programmed to plunge into a star as a special effect in a stage
421 	show. Unable to change course, the main characters get Marvin to run the teleporter they find in the ship, which is working other than  having  no
422 	automatic control (someone must remain behind to operate it), and Marvin seemingly sacrifices himself.  Zaphod  and  Trillian  discover  that  the
423 	Universe is in the safe hands of a simple man living on a remote planet in a wooden shack with his cat. Ford and Arthur, meanwhile, end  up  on  a
424 	spacecraft full of the outcasts of the Golgafrinchan civilization. The ship crashes on prehistoric Earth; Ford and Arthur  are  stranded,  and  it
425 	becomes clear that the inept Golgafrinchans are the ancestors of modern humans,  having  displaced  the  Earth's  indigenous  hominids.  This  has
426 	disrupted the Earth's programming so that when Ford and Arthur manage to extract the final readout from  Arthur's  subconscious  mind  by  pulling
427 	lettered tiles from a Scrabble set, it is "What do you get if you multiply six by nine?"  Arthur  then  comments,  "I've  always  said  there  was
428 	something fundamentally wrong with the universe." The book was adapted from the remaining material in the radio  series—covering  from  the  fifth
429 	episode to the twelfth episode, although the ordering was greatly changed (in particular, the events of Fit the Sixth, with Ford and Arthur  being
430 	stranded on pre-historic Earth, end the book, and their rescue in Fit the Seventh is deleted), and most of the Brontitall  incident  was  omitted,
431 	instead of the Haggunenon sequence, co-written by John Loyd, the Disaster Area stunt ship was substituted—this having first been introduced in the
432 	LP version. Adams himself considered Restaurant to be his best novel of the five.
433 	
434 	Life, the Universe and Everything: In Life, the Universe and Everything  (published in 1982),  Ford  and  Arthur  travel  through  the  space-time
435 	continuum from prehistoric Earth to Lord's Cricket Ground. There they run into Slartibartfast, who enlists their aid in preventing  galactic  war.
436 	Long ago, the people of Krikkit attempted to wipe out all life in the Universe, but they were stopped and imprisoned on  their  home  planet;  now
437 	they are poised to escape. With the help of Marvin, Zaphod, and Trillian, our heroes prevent the destruction of life in the Universe and go  their
438 	separate ways. This was the first Hitchhiker's book originally written as a book and not adapted from radio. Its story was based  on  a  treatment
439 	Adams had written for a Doctor Who theatrical release, with the Doctor role being split between Slartibartfast (to begin with), and later Trillian
440 	and Arthur. In 2004 it was adapted for radio as the Tertiary Phase of the radio series.
441 	
442 	So Long, and Thanks for All  the  Fish: In So Long, and Thanks for All the Fish  (published  in  1984),  Arthur  returns  home  to  Earth,  rather
443 	surprisingly since it was destroyed when he left. He meets and falls in love  with  a  girl  named  Fenchurch,  and  discovers  this  Earth  is  a
444 	replacement provided by the dolphins in their Save the Humans campaign. Eventually, he rejoins Ford, who claims to have saved the Universe in  the
445 	meantime, to hitch-hike one last time and see God's Final Message to His Creation. Along the way, they are joined by Marvin, the Paranoid Android,
446 	who, although 37 times older than the universe itself (what with time travel and all), has just enough power left in his failing body to read  the
447 	message and feel better about it all before expiring. This was the first Hitchhiker's novel which was not an adaptation of any previously  written
448 	story or script. In 2005 it was adapted for radio as the Quandary Phase of the radio series.
449 
450 	Mostly Harmless: Finally, in Mostly Harmless  (published  in  1992),  Vogons  take  over  The Hitchhiker's Guide  (under  the  name  of  InfiniDim
451 	Enterprises), to finish, once and for all, the task of obliterating the Earth. After abruptly losing Fenchurch and  traveling  around  the  galaxy
452 	despondently, Arthur's spaceship crashes on the planet Lamuella, where he settles in happily as the official sandwich-maker for a small village of
453 	simple, peaceful people. Meanwhile, Ford Prefect breaks into The Guide's offices, gets himself an  infinite  expense  account  from  the  computer
454 	system, and then meets The Hitchhiker's Guide to the Galaxy, Mark II, an artificially intelligent, multi-dimensional guide with vast  power  and a
455 	hidden purpose. After he declines this dangerously powerful machine's aid (which he receives anyway), he sends it to Arthur Dent for  safety  ("Oh
456 	yes, whose?"—Arthur). Trillian uses DNA that Arthur donated for traveling money to have a daughter, and when she goes to cover a war,  she  leaves
457 	her daughter Random Frequent Flyer Dent with Arthur. Random, a more than typically troubled teenager, steals The Guide Mark II and uses it to  get
458 	to Earth. Arthur, Ford, Trillian, and Tricia McMillan (Trillian in this alternate universe) follow her to  a  crowded  club,  where  an  anguished
459 	Random becomes startled by a noise and inadvertently fires her gun at Arthur. The shot  misses  Arthur  and  kills  a  man  (the  ever-unfortunate
460 	Agrajag). Immediately afterwards, The Guide Mark II causes the removal of all possible Earths from probability. All of the main  characters,  save
461 	Zaphod, were on Earth at the time and are apparently killed, bringing a good deal of satisfaction to the Vogons. In 2005 it was adapted for  radio
462 	as the Quintessential Phase of the radio series, with the final episode first transmitted on 21 June 2005.
463 	
464 	And Another Thing...: It was announced in September 2008 that Eoin Colfer, author of Artemis Fowl,  had  been  commissioned  to  write  the  sixth
465 	instalment entitled And Another Thing... with the support of Jane Belson, Adams's widow. The book was published by Penguin Books  in  the  UK  and
466 	Hyperion in the US in October 2009. The story begins as death rays bear down on Earth, and the characters awaken from a  virtual  reality.  Zaphod
467 	picks them up shortly before they are killed, but completely fails to escape the death beams. They  are  then  saved  by  Bowerick Wowbagger,  the
468 	Infinitely Prolonged, whom they agree to help kill. Zaphod travels to Asgard to get Thor's help. In  the  meantime,  the  Vogons  are  heading  to
469 	destroy a colony of people who also escaped Earth's destruction, on the planet Nano. Arthur, Wowbagger, Trillian and Random head to Nano to try to
470 	stop the Vogons, and on the journey, Wowbagger and Trillian fall in love, making Wowbagger  question  whether  or  not  he  wants  to  be  killed.
471 	Zaphod arrives with Thor, who then signs up to be the planet's God. With Random's help, Thor almost kills Wowbagger. Wowbagger, who  merely  loses
472 	his immortality, then marries Trillian. Thor then stops the first Vogon attack and apparently dies. Meanwhile, Constant Mown,  son  of  Prostetnic
473 	Jeltz, convinces his father that the people on the planet are not citizens of Earth, but are, in fact, citizens of Nano, which means that it would
474 	be illegal to kill them. As the book draws to a close, Arthur is on his way to check  out  a  possible  university  for  Random,  when,  during  a
475 	hyperspace jump, he is flung across alternate universes, has a brief encounter with Fenchurch, and ends up exactly where  he  would  want  to  be.
476 	And then the Vogons turn up again. In 2017 it was adapted for radio as the Hexagonal Phase of the radio series, with its  premiere  episode  first
477 	transmitted on 8 March 2018, (exactly forty years, to the day, from the first episode of the first series, the Primary Phase).
478 
479 	Omnibus editions: Two omnibus editions were created by Douglas Adams to combine the Hitchhiker series novels and to "set the record straight". The
480 	stories came in so many different formats that Adams stated that every time he told it he would contradict himself. Therefore, he  stated  in  the
481 	introduction of The More Than Complete Hitchhiker's Guide that  "anything I put down wrong here is, as far as I'm concerned, wrong for good."  The
482 	two omnibus editions were  The More Than Complete Hitchhiker's Guide, Complete and Unabridged  (published in 1987)  and  The Ultimate Hitchhiker's
483 	Guide, Complete and Unabridged (published in 1997).
484 	The More Than Complete Hitchhiker's Guide: Published in 1987, this 624-page leatherbound omnibus edition contains "wrong for good" versions of the
485 	four Hitchhiker series novels at the time, and also includes one short story:
486 		The Hitchhiker's Guide to the Galaxy
487 		The Restaurant at the End of the Universe
488 		Life, the Universe and Everything
489 		So Long, and Thanks for All the Fish
490 		"Young Zaphod Plays it Safe"
491 	The Ultimate Hitchhiker's Guide: Published in 1997, this 832-page leatherbound final omnibus edition contains five Hitchhiker  series  novels  and
492 	one short story:
493 		The Hitchhiker's Guide to the Galaxy
494 		The Restaurant at the End of the Universe
495 		Life, the Universe and Everything
496 		So Long, and Thanks for All the Fish
497 		Mostly Harmless
498 		"Young Zaphod Plays it Safe"
499 	Also appearing in The Ultimate Hitchhiker's Guide, at the end of Adams's introduction, is a list  of  instructions  on  "How to Leave the Planet",
500 	providing a humorous explanation of how one might replicate Arthur and Ford's feat at the beginning of Hitchhiker's.
501 
502 	Other Hitchhiker's-related books and stories:
503 		Related stories:
504 			A short story by Adams, "Young Zaphod Plays It Safe", first appeared in The Utterly Utterly Merry Comic Relief Christmas Book,  a  special
505 			large-print compilation of different stories and pictures that raised money for the then-new Comic Relief charity in  the  UK.  The  story
506 			also appears in some of the omnibus editions of the trilogy, and in The Salmon of Doubt. There are two 	versions of  this  story,  one  of
507 			which is slightly more explicit in its political commentary.
508 
509 			A novel, Douglas Adams' Starship Titanic: A Novel, written by Terry Jones, is based on Adams's computer game of  the  same  name,  Douglas
510 			Adams's Starship Titanic, which in turn is based on an idea from Life, the Universe and Everything. The idea concerns a  luxury  passenger
511 			starship that suffers "sudden and gratuitous total existence failure" on its maiden voyage.
512 			
513 			Wowbagger the Infinitely Prolonged, a character from Life, the Universe and Everything, also appears in a short story by Adams titled "The
514 			Private Life of Genghis Khan" which appears in some early editions of The Salmon of Doubt.
515 
516 	Published radio scripts: Douglas Adams and Geoffrey Perkins collaborated on The Hitchhiker's Guide to the  Galaxy:  The  Original  Radio  Scripts,
517 	first published in the United Kingdom and United States in 1985. A tenth-anniversary (of the script book publication) edition was printed in 1995,
518 	and a twenty-fifth-anniversary (of the first radio series broadcast) edition was printed in 2003.  The 2004 series was produced by Above The Title
519 	Productions and the scripts were published in July 2005, with production notes for each episode. This second radio script  book  is  entitled  The
520 	Hitchhiker's Guide to the Galaxy Radio Scripts: The Tertiary, Quandary and Quintessential Phases. Douglas Adams gets the primary  writer's  credit
521 	(as he wrote the original novels), and there is a foreword by Simon Jones, introductions by the producer and the director, and other  introductory
522 	notes from other members of the cast.
523 
524 	Television series: The popularity of the radio series gave rise to a six-episode television series,  directed  and  produced  by  Alan J. W. Bell,
525 	which first aired on BBC 2 in January and February 1981. It employed many of the actors from the radio series and was based mainly  on  the  radio
526 	versions of Fits the First to Sixth. A second series was at one point planned, with a storyline, according to Alan Bell and  Mark Wing-Davey  that
527 	would have come from Adams's abandoned Doctor Who and the Krikkitmen project (instead of simply making a TV version of the second  radio  series).
528 	However, Adams got into disputes with the BBC (accounts differ: problems with budget, scripts, and having Alan Bell involved are  all  offered  as
529 	causes), and the second series was never made. Elements of Doctor Who and the Krikkitmen were instead used in the  third novel, Life, the Universe
530 	and Everything. The main cast was the same as the original radio series, except for David Dixon as  Ford Prefect  instead  of McGivern, and Sandra
531 	Dickinson as Trillian instead of Sheridan.
532 	
533 	Other television appearances: Segments of several of the books were adapted as part of the BBC's The Big Read survey and programme,  broadcast  in
534 	late 2003. The film, directed by Deep Sehgal, starred Sanjeev Bhaskar as Arthur Dent, alongside Spencer Brown as Ford Prefect, Nigel Planer as the
535 	voice of Marvin, Stephen Hawking as the voice of Deep Thought, Patrick Moore as the voice of the Guide, Roger Lloyd-Pack  as  Slartibartfast,  and
536 	Adam Buxton and Joe Cornish as Loonquawl and Phouchg.
537 
538 	Radio series three to five: On 21 June 2004, the BBC announced in a press release that a new series of Hitchhiker's based on the third novel would
539 	be broadcast as part of its autumn schedule, produced by Above the Title Productions Ltd. The episodes were recorded  in  late  2003,  but  actual
540 	transmission was delayed while an agreement was  reached  with  The  Walt  Disney  Company  over  Internet  re-broadcasts,  as  Disney  had  begun
541 	pre-production on the film. This was followed by news that further series would be produced based on the  fourth  and  fifth  novels.  These  were
542 	broadcast in September and October 2004 and May and June 2005. CD releases accompanied the transmission of the final episode in each  series.  The
543 	adaptation of the third novel followed the book very closely, which caused major structural issues in meshing with the preceding radio  series  in
544 	comparison to the second novel. Because many events from the radio series were omitted from the second novel, and those that did occur happened in
545 	a different order, the two series split in completely different directions. The last two adaptations vary somewhat—some events in Mostly  Harmless
546 	are now foreshadowed in the adaptation of So Long and Thanks For All The Fish,  while  both  include  some  additional  material  that  builds  on
547 	incidents in the third series to tie all five (and their divergent plotlines) together,  most  especially  including  the  character  Zaphod  more
548 	prominently in the final chapters and addressing his altered reality  to  include  the  events  of  the  Secondary Phase.  While  Mostly  Harmless
549 	originally contained a rather bleak ending, Dirk Maggs created a different ending for the transmitted radio version, ending  it  on  a  much  more
550 	upbeat note, reuniting the cast one last time. The core cast for the third to fifth radio series remained the same, except for the replacement  of
551 	Peter Jones by William Franklyn as the Book, and Richard Vernon by Richard Griffiths as Slartibartfast, since both had  died.  (Homage  to  Jones'
552 	iconic portrayal of the Book was paid twice: the gradual shift of voices to a "new" version in episode 13, launching the new  productions,  and  a
553 	blend of Jones and Franklyn's voices at the end of the final episode, the first part of Maggs' alternative ending.) Sandra Dickinson,  who  played
554 	Trillian in the TV series, here played Tricia McMillan, an English-born, American-accented alternate-universe version  of  Trillian,  while  David
555 	Dixon, the television series' Ford Prefect, made a cameo appearance as the "Ecological Man". Jane Horrocks appeared in the new  semi-regular  role
556 	of Fenchurch, Arthur's girlfriend, and Samantha Béart joined in the final series as Arthur and Trillian's daughter,  Random Dent.  Also  reprising
557 	their roles from the original radio series were Jonathan Pryce as Zarniwoop (here blended  with  a  character  from  the  final  novel  to  become
558 	Zarniwoop Vann Harl), Rula Lenska as Lintilla and her clones (and also as the  Voice  of  the  Bird),  and  Roy  Hudd  as  Milliways  compere  Max
559 	Quordlepleen, as well as the original radio series' announcer, John Marsh. The series also featured guest appearances by such noted  personalities
560 	as Joanna Lumley as the Sydney Opera House Woman, Jackie Mason as the East River Creature, Miriam Margolyes as the  Smelly Photocopier Woman,  BBC
561 	Radio cricket legends Henry Blofeld and Fred Trueman as themselves, June Whitfield as the Raffle Woman,  Leslie Phillips as Hactar,  Saeed Jaffrey
562 	as the Man on the Pole, Sir Patrick Moore as himself, and Christian Slater as Wonko the Sane. Finally, Adams himself played the role of Agrajag, a
563 	performance adapted from his book-on-tape reading of the third novel, and edited into the series created  some  time  after  the  author's  death.
564 
565 	Tertiary, Quandary and Quintessential Phase Main cast:
566 		Simon Jones as Arthur Dent
567 		Geoffrey McGivern as Ford Prefect
568 		Susan Sheridan as Trillian
569 		Mark Wing-Davey as Zaphod Beeblebrox
570 		Stephen Moore as Marvin, the Paranoid Android
571 		Richard Griffiths as Slartibartfast
572 		Sandra Dickinson as Tricia McMillan
573 		Jane Horrocks as Fenchurch
574 		Rula Lenska as the Voice of the Bird
575 		Samantha Béart as Random
576 		William Franklyn as The Book
577 	
578 	Radio series six: The first of six episodes in a sixth series, the Hexagonal  Phase, was broadcast on  BBC Radio 4  on  8 March 2018 and  featured
579 	Professor Stephen Hawking  introducing  himself as the voice of The Hitchhiker’s Guide to the Galaxy Mk II  by  saying: "I have been quite popular
580 	in my time. Some even read my books."
581 
582 	Film: After several years of setbacks and renewed efforts to start production and a quarter of a century after the first book  was  published, the
583 	big-screen adaptation of The Hitchhiker's Guide to the Galaxy was finally shot. Pre-production began in 2003, filming began on  19 April 2004  and
584 	post-production began in early September 2004. After a London premiere on 20 April 2005, it was released on 28 April in  the  UK and Australia, 29
585 	April in the United States and Canada, and 29 July in South Africa. (A full list of release dates is available  at  the  IMDb.)  The  movie  stars
586 	Martin Freeman as Arthur, Mos Def as Ford, Sam Rockwell as President of the  Galaxy Zaphod Beeblebrox and Zooey Deschanel as Trillian,  with  Alan
587 	Rickman providing the voice of Marvin the Paranoid Android (and Warwick Davis acting in Marvin's costume), and Stephen Fry as  the  voice  of  the
588 	Guide/Narrator. The plot of the film adaptation of Hitchhiker's Guide differs widely from that of the radio show, book and television  series. The
589 	romantic triangle between Arthur, Zaphod, and Trillian is more prominent in the film; and visits to Vogsphere, the homeworld of the Vogons (which,
590 	in the books, was already abandoned), and Viltvodle VI are inserted. The film covers roughly events in  the  first four radio episodes,  and  ends
591 	with the characters en route to the Restaurant at the End of the Universe, leaving the opportunity for a sequel open. A unique appearance is  made
592 	by the Point-of-View Gun, a device specifically created by Adams himself for the movie. Commercially the film was a  modest  success,  taking  $21
593 	million in its opening weekend in the United States, and nearly £3.3 million in its opening weekend in the United Kingdom. The film  was  released
594 	on DVD (Region 2, PAL) in the UK on 5 September 2005. Both a standard double-disc edition and a UK-exclusive numbered  limited edition  "Giftpack"
595 	were released on this date. The "Giftpack" edition includes a copy of the novel with a "movie tie-in" cover, and collectible prints from the film,
596 	packaged in a replica of the film's version of the Hitchhiker's Guide prop. A single-disc widescreen or full-screen edition (Region 1, NTSC)  were
597 	made available in the United States and Canada on 13 September 2005. Single-disc releases in the Blu-ray format and UMD format for the PlayStation
598 	Portable were also released on the respective dates in these three countries.
599 	
600 	Stage shows: There have been multiple professional and amateur stage adaptations of The Hitchhiker's Guide to the Galaxy. There were  three  early
601 	professional productions, which were staged in 1979 and 1980. The first of these was performed  at  the  Institute of Contemporary Arts in London,
602 	between 1 and 19 May 1979, starring Chris Langham as Arthur Dent (Langham later returned to Hitchhiker's as Prak in the final  episode  of  2004's
603 	Tertiary Phase) and Richard Hope as Ford Prefect. This show was adapted from the first series' scripts and was directed by Ken Campbell, who  went
604 	on to perform a character in the final episode of the second radio series. The show ran 90 minutes, but had an audience limited to  eighty  people
605 	per night. Actors performed on a variety of ledges and platforms, and the audience was pushed around in a hovercar, 1/2000th of an inch above  the
606 	floor. This was the first time that Zaphod was represented by having two actors in one large  costume.  The  narration  of  "The Book"  was  split
607 	between two usherettes, an adaptation that has appeared in no other version of H2G2. One of  these  usherettes,  Cindy Oswin,  went  on  to  voice
608 	Trillian for the LP adaptation. The second stage show was  performed  throughout  Wales  between  15 January  and  23 February 1980.  This  was  a
609 	production of Clwyd Theatr Cymru, and was directed by Jonathan Petherbridge. The company performed adaptations  of  complete  radio  episodes,  at
610 	times doing two episodes in a night, and at other times doing all six episodes of the first series in single three-hour sessions. This  adaptation
611 	was performed again at the Oxford Playhouse in December 1981, the Bristol Hippodrome, Plymouth's Theatre Royal in May–June 1982, and also  at  the
612 	Belgrade Theatre, Coventry, in July 1983. The third and least successful stage show was held at the Rainbow Theatre in London, in July 1980.  This
613 	was the second production directed by Ken Campbell. The Rainbow Theatre had been adapted for stagings of  rock  operas  in  the  1970s,  and  both
614 	reference books mentioned in footnotes indicate that this, coupled with incidental music throughout the  performance,  caused  some  reviewers  to
615 	label it as a "musical". This was the first adaptation for which Adams wrote the "Dish of the Day" sequence. The production  ran  for  over  three
616 	hours, and was widely panned for this, as well as for the music, laser effects, and the acting. Despite attempts to shorten the script,  and  make
617 	other changes, it closed three or four weeks early (accounts differ), and lost a lot of money. Despite the bad reviews, there were  at  least  two
618 	stand-out performances: Michael Cule and David Learner both went on from this production to appearances in the  TV adaptation. In  December 2011 a
619 	new stage production was announced to begin touring in June 2012. This included members of the original radio and TV casts  such  as  Simon Jones,
620 	Geoff McGivern, Susan Sheridan, Mark Wing-Davey and Stephen Moore with VIP guests playing the role of the Book. It was produced in the form  of  a
621 	radio show which could be downloaded when the tour was completed. This production was based on the first four Fits in  the  first  act,  with  the
622 	second act covering material from the rest of the series. The show also featured a band, who performed the songs  "Share and Enjoy",  the  Krikkit
623 	song "Under the Ink Black Sky", Marvin's song "How I Hate The Night", and "Marvin", which was a minor hit  in  1981.  The  production  featured  a
624 	series of "VIP guests" as the voice of  The Book  including  Billy Boyd,  Phill Jupitus,  Rory McGrath,  Roger McGough,  Jon Culshaw,  Christopher
625 	Timothy, Andrew Sachs, John Challis, Hugh Dennis, John Lloyd, Terry Jones and Neil Gaiman. The tour started on 8 June 2012 at  the  Theatre Royal,
626 	Glasgow and continued through the summer until 21 July when the final performance was at  Playhouse Theatre,  Edinburgh.  The  production  started
627 	touring again in September 2013, but the remaining dates of the tour were cancelled due to poor ticket sales.
628 	
629 	Live radio adaptation: On Saturday 29 March 2014, Radio 4 broadcast an adaptation in front of a live  audience,  featuring  many  members  of  the
630 	original cast including Stephen Moore, Susan Sheridan,  Mark Wing-Davey,  Simon Jones  and  Geoff McGivern,  with  John Lloyd  as  the  book.  The
631 	adaptation was adapted by Dirk Maggs primarily from Fit the First, including material from the books and later radio Fits  as  well  as  some  new
632 	jokes. It formed part of Radio 4's Character Invasion series. 
633 	
634 	LP album adaptations: The first four radio episodes were adapted for a new double LP, also entitled The Hitchhiker's Guide to the Galaxy (appended
635 	with "Part One" for the subsequent Canadian release), first by mail-order only, and  later  into  stores.  The  double  LP  and  its  sequel  were
636 	originally released by Original Records in the United Kingdom in 1979 and 1980, with the catalogue numbers ORA042  and  ORA054  respectively. They
637 	were first released by Hannibal Records in 1982 (as HNBL 2301 and HNBL 1307, respectively) in the United States and Canada, and later  re-released
638 	in a slightly abridged edition by Simon & Schuster's Audioworks in the mid-1980s. Both  were  produced  by  Geoffrey Perkins  and  featured  cover
639 	artwork by Hipgnosis. The script in the first double LP very closely follows the first four radio episodes, although further cuts had to  be  made
640 	for reasons of timing. Despite this, other lines of dialogue that were indicated as having been cut when  the  original  scripts  from  the  radio
641 	series were eventually published can be  heard  in  the  LP  version.  The  Simon & Schuster  cassettes  omit  the  Veet Voojagig  narration,  the
642 	cheerleader's speech as Deep Thought concludes its seven-and-one-half-million-year programme, and a few other lines from both sides of the  second
643 	LP of the set. Most of the original cast returned, except for Susan Sheridan, who was recording a voice for the character of  Princess Eilonwy  in
644 	The Black Cauldron for Walt Disney Pictures. Cindy Oswin voiced Trillian on all three LPs in her place. Other casting changes in the  first double
645 	LP included Stephen Moore taking on the additional role of the barman, and Valentine Dyall as the voice of  Deep Thought.  Adams's  voice  can  be
646 	heard making the public address announcements on Magrathea. Because of copyright issues, the music used during the first radio series  was  either
647 	replaced, or in the case of the title it was re-recorded in a  new  arrangement.  Composer  Tim Souster  did  both  duties  (with  Paddy Kingsland
648 	contributing music as well), and Souster's version of the theme was the version also used for the eventual television series.  The  sequel LP  was
649 	released, singly, as The Hitchhiker's Guide to the Galaxy Part Two: The Restaurant at the End of the  Universe  in  the  UK,  and  simply  as  The
650 	Restaurant at the End of the Universe in the USA. The script here mostly follows Fit the Fifth and Fit the Sixth,  but  includes  a  song  by  the
651 	backup band in the restaurant ("Reg Nullify and his Cataclysmic Combo"), and changes the Haggunenon sequence to "Disaster Area". As the result  of
652 	a misunderstanding, the second record was released before being cut down in a final edit that Douglas Adams and Geoffrey Perkins had both intended
653 	to make. Perkins has said, "[I]t is far too long on each side. It's  just  a  rough cut. [...] I felt it was flabby, and I wanted to speed it up."
654 	The Simon & Schuster Audioworks re-release of this LP was also abridged slightly from its  original  release.  The  scene  with  Ford Prefect  and
655 	Hotblack Desiato's bodyguard is omitted. Sales for the first double-LP release were primarily through mail order. Total sales reached over  60,000
656 	units, with half of those being mail order, and the other half through retail outlets. This  is  in  spite  of  the  facts  that Original Records'
657 	warehouse ordered and stocked more copies than they were actually selling for quite some time, and that Paul Neil Milne Johnstone complained about
658 	his name and then-current address being included in the recording. This was corrected for a later pressing of the double-LP by "cut[ting] up  that
659 	part of the master tape and reassembl[ing] it in the wrong order". The second LP release ("Part Two") also only sold a total of  60,000  units  in
660 	the UK. The distribution deals for the United States and Canada with Hannibal Records and Simon and Schuster  were  later  negotiated  by  Douglas
661 	Adams and his agent, Ed Victor, after gaining full rights to the recordings from Original Records, which went bankrupt.
662 
663 	Audiobook adaptations: There have been three audiobook recordings of the novel. The first was an abridged edition  (ISBN 0-671-62964-6),  recorded
664 	in the mid-1980s for the EMI label Music For Pleasure by Stephen Moore, best known for playing the voice  of  Marvin the Paranoid Android  in  the
665 	radio series and in the TV series. In 1990,  Adams  himself  recorded  an  unabridged  edition  for  Dove Audiobooks  (ISBN 1-55800-273-1),  later
666 	re-released by New Millennium Audio (ISBN 1-59007-257-X)  in  the  United States  and available from BBC Audiobooks in the United Kingdom. Also by
667 	arrangement with Dove, ISIS Publishing Ltd produced a numbered exclusive edition signed by Douglas Adams (ISBN 1-85695-028-X) in 1994.  To  tie-in
668 	with the 2005 film, actor Stephen Fry, the film's voice of the Guide, recorded a second  unabridged  edition  (ISBN 0-7393-2220-6).  In  addition,
669 	unabridged versions of books 2-5 of the  series were recorded by Martin Freeman for Random House Audio. Freeman plays  Arthur  in  the  2005  film
670 	adaptation. Audiobooks 2-5 follow in order  and  include: The Restaurant at the End of the Universe (ISBN 9780739332085);  Life, the Universe, and
671 	Everything (ISBN 9780739332108); So Long, and Thanks for All the Fish (ISBN 9780739332122); and Mostly Harmless (ISBN 9780739332146).
672 
673 	Interactive fiction and video games: Sometime between 1982 and 1984  (accounts differ), the  British  company  Supersoft  published  a  text-based
674 	adventure game based on the book, which was released in versions for the Commodore PET and Commodore 64. One  account  states  that  there  was  a
675 	dispute as to whether valid permission for publication had been granted, and following legal action the  game  was  withdrawn  and  all  remaining
676 	copies were destroyed. Another account states that the programmer, Bob Chappell, rewrote the game  to  remove  all  Hitchhiker's  references,  and
677 	republished it as "Cosmic Capers". Officially, the TV series was followed in 1984 by a best-selling "interactive fiction", or text-based adventure
678 	game, distributed by Infocom. It was designed by Adams and Infocom regular Steve Meretzky and was one of Infocom's most successful games. As  with
679 	many Infocom games, the box contained a number of "feelies" including a  "Don't panic" badge,  some  "pocket fluff",  a  pair  of  peril-sensitive
680 	sunglasses (made of cardboard), an order for the destruction of the Earth, a small, clear plastic bag containing "a microscopic battle fleet"  and
681 	an order for the destruction of Arthur Dent's house  (signed by Adams and Meretzky).  In  September 2004,  it  was  revived  by  the  BBC  on  the
682 	Hitchhiker's section of the Radio 4 website for the initial broadcast of the Tertiary Phase, and is still  available  to  play  online.  This  new
683 	version uses an original Infocom datafile with a custom-written interpreter, by Sean Sollé, and Flash programming by Shimon Young,  both  of  whom
684 	used to work at The Digital Village (TDV). The new version includes illustrations by Rod Lord, who was head of Pearce Animation Studios  in  1980,
685 	which produced the guide graphics for the TV series. On 2 March 2005 it won the Interactive BAFTA in the "best online entertainment"  category.  A
686 	sequel to the original Infocom game was never made. An all-new, fully graphical game was designed and developed by a  joint  venture  between  The
687 	Digital Village and PAN Interactive (no connection to Pan Books / Pan Mcmillan). This new game was planned and  developed  between  1998 and 2002,
688 	but like the sequel to the Infocom game, it also never materialised. In April 2005, Starwave Mobile released two mobile  games  to  accompany  the
689 	release of the film adaptation. The first, developed by Atatio, was called "The Hitchhiker's Guide to the Galaxy: Vogon Planet Destructor". It was
690 	a typical top-down shooter and except for the title had little to do with the actual story. The second game,  developed  by  TKO Software,  was  a
691 	graphical adventure game named "The Hitchhiker's Guide to the Galaxy: Adventure Game". Despite  its  name,  the  newly  designed  puzzles  by  TKO
692 	Software's Ireland studio were different from the Infocom ones, and the game followed the movie's script closely and included the  new  characters
693 	and places. The "Adventure Game" won the IGN's "Editors' Choice Award" in May 2005. On 25 May 2011, Hothead Games announced they were working on a
694 	new edition of The Guide. Along with the announcement, Hothead Games launched a teaser web site made to look like an  announcement  from  Megadodo
695 	Publications that The Guide will soon be available on Earth. It has since been revealed that they are developing an iOS app in the  style  of  the
696 	fictional Guide.
697 	
698 	Comic books: In 1993, DC Comics, in conjunction with Byron Preiss Visual Publications,  published  a  three-part  comic  book  adaptation  of  the
699 	novelisation of The Hitchhiker's Guide to the Galaxy. This was followed up with three-part adaptations  of  The  Restaurant  at  the  End  of  the
700 	Universe in 1994, and Life, the Universe and Everything in 1996. There was also a series of collectors' cards with art from and  inspired  by  the
701 	comic adaptations of the first book, and a graphic novelisation (or "collected edition") combining the three individual  comic  books  from  1993,
702 	itself released in May 1997. Douglas Adams was deeply opposed to the use of American English spellings and idioms in  what  he  felt  was  a  very
703 	British story, and had to be talked into it by the American publishers, although he remained very unhappy with  the  compromise.  The  adaptations
704 	were scripted by John Carnell. Steve Leialoha provided the art for Hitchhiker's and the layouts for Restaurant. Shepherd Hendrix did the  finished
705 	art for Restaurant. Neil Vokes and John Nyberg did the finished artwork for Life, based on breakdowns by Paris Cullins  (Book 1)  and  Christopher
706 	Schenck (Books 2–3). The miniseries were edited by Howard Zimmerman and Ken Grobe.
707 	
708 	"Hitch-Hikeriana": Many merchandising and spin-off items (or "Hitch-Hikeriana") were produced in the early 1980s, including  towels  in  different
709 	colours, all bearing the Guide entry for towels. Later runs of towels include those made for promotions by Pan Books, Touchstone Pictures / Disney
710 	for the 2005 movie, and different towels made for ZZ9 Plural Z Alpha,  the official Hitchhiker's Appreciation  society.  Other  items  that  first
711 	appeared in the mid-1980s were T-shirts, including those made for Infocom (such as one bearing the legend "I got the Babel Fish" for  successfully
712 	completing one of that game's most difficult puzzles), and a Disaster Area tour T-shirt. Other official items have included  "Beeblebears"  (teddy
713 	bears with an extra head and arm, named after Hitchhiker's character Zaphod Beeblebrox, sold by the official Appreciation Society), an  assortment
714 	of pin-on buttons and a number of novelty singles. Many of the above items  are  displayed  throughout  the  2004  "25th  Anniversary  Illustrated
715 	Edition" of the novel, which used items from the personal collections of fans of the  series.  Stephen  Moore  recorded  two  novelty  singles  in
716 	character as Marvin, the Paranoid Android: "Marvin"/"Metal Man" and "Reasons To Be Miserable"/"Marvin I Love You". The last song has appeared on a
717 	Dr. Demento compilation. Another single featured the re-recorded "Journey of the Sorcerer" (arranged by Tim Souster) backed  with  "Reg Nullify In
718 	Concert" by Reg Nullify, and "Only the End of the World Again" by Disaster Area (including Douglas Adams on bass guitar). These  discs  have since
719 	become collector's items.  The 2005 movie also added quite a few collectibles, mostly through the National Entertainment Collectibles Association.
720 	These included three prop  replicas  of objects seen on the Vogon ship and homeworld (a mug, a pen and a stapler), sets of "action figures" with a
721 	height of either 3 or 6 inches (76 or 150 mm), a gun—based on a prop used by Marvin, the Paranoid Android, that shoots foam darts, a crystal cube,
722 	shot glasses, a ten-inch (254 mm) high version of  Marvin  with  eyes  that light up green, and "yarn doll" versions of Arthur Dent, Ford Prefect,
723 	Trillian, Marvin and Zaphod Beeblebrox. Also, various audio tracks were released to coincide with the movie, notably re-recordings of "Marvin" and
724 	"Reasons To Be Miserable", sung by Stephen Fry, along with some of the "Guide Entries",  newly  written  material read in-character by Fry. SpaceX
725 	CEO Elon Musk launched his Tesla Roadster into an elliptical heliocentric orbit as part of the initial test launch of  the  Falcon Heavy.  On  the
726 	car's dashboard, the phrase "Don't Panic!" appears, as a nod to the Hitchhiker's Guide.
727 	
728 	International phenomenon: Many science fiction fans and radio listeners outside the United Kingdom were first exposed to The Hitchhiker's Guide to
729 	the Galaxy in one of two ways: shortwave radio broadcasts of the original radio series, or by Douglas Adams being "Guest of Honour"  at  the  1979
730 	World Science Fiction Convention, Seacon, held in Brighton, England. It was there that the radio series was nominated for a Hugo Award (the  first
731 	radio series to receive a nomination) but lost to Superman. A convention exclusively for H2G2, Hitchercon I, was held  in  Glasgow,  Scotland,  in
732 	September 1980, the year that the official fan club, ZZ9 Plural Z Alpha, was organised. In the early 1980s, versions  of  H2G2 became available in
733 	the United States, Canada, Germany (Per Anhalter durch die Galaxis), Denmark (Håndbog for vakse galakseblaffere), the Netherlands (Transgalactisch
734 	Liftershandboek), Sweden (Liftarens guide till galaxen), Finland (Linnunradan Käsikirja Liftareille) and also Israel (מדריך הטרמפיסט לגלקסיה).  In
735 	the meantime the book has been translated into more than thirty  languages,  such  as  Bulgarian  (Пътеводител на галактическия стопаджия),  Czech
736 	(Stopařův průvodce Galaxií), Farsi/Persian (راهنمای مسافران مجانی کهکشان), French (Le routard galactique), Greek (Γυρίστε το Γαλαξία με Ωτο-στόπ),
737 	Hungarian (Galaxis Útikalauz stopposoknak), Italian (Guida galattica per gli autostoppisti),
738 	Japanese (銀河ヒッチハイク・ガイド), Korean (은하수를 여행하는히치하이커를 위한 안내서),
739 	Latvian  (Galaktikas   ceļvedis   stopētājiem),   Norwegian   (Haikerens   guide   til   Galaksen,   first   published   as  På  tommeltotten  til
740 	melkeveien), Brazilian Portuguese (Guia do Mochileiro das Galáxias), Portuguese (À Boleia Pela  Galáxia),  Polish  (Autostopem  przez  galaktykę),
741 	Romanian (Ghidul autostopistului galactic), Russian (Автостопом по Галактике), Serbian (Autostoperski vodič kroz galaksiju), Slovenian  (Štoparski
742 	vodnik po Galaksiji), Spanish (Guía del autoestopista galáctico), Slovak (Stopárov sprievodca galaxiou), Czech  (Stopařův  průvodce  galaxií)  and
743 	Turkish (Otostopçunun Galaksi Rehberi).
744 	
745 	Spelling: The different versions of the series spell the title  differently−thus  Hitch-Hiker's Guide,  Hitch Hiker's Guide and Hitchhiker's Guide
746 	are used in different editions (US or UK), formats (audio or print) and compilations of the book, with some omitting the apostrophe. Some editions
747 	used different spellings on the spine and title page.  The h2g2's English Usage in Approved Entries claims that Hitchhiker's Guide is the spelling
748 	Adams preferred. At least two reference works make note of the inconsistency in the titles. Both, however, repeat the statement that Adams decided
749 	in 2000 that "everyone should spell it the same way [one word, no hyphen] from then on."
750 	
751 	Bibliography:
752 		Adams, Douglas (2002).
753 		Guzzardi, Peter, ed. The Salmon of Doubt: Hitchhiking the Galaxy One Last Time (first UK ed.). Macmillan. ISBN 0-333-76657-1 (2003).
754 		Perkins, Geoffrey, ed. The Hitchhiker's Guide to the Galaxy: The Original Radio Scripts. MJ Simpson, add. mater (25th Anniversary ed.).
755 			Pan Books. ISBN 0-330-41957-9.
756 		Gaiman, Neil (2003). Don't Panic: Douglas Adams and the "Hitchhiker's Guide to the Galaxy". Titan Books. ISBN 1-84023-742-2.
757 		Simpson, M. J. (2003). Hitchhiker: A Biography of Douglas Adams (first US ed.). Justin Charles & Co. ISBN 1-932112-17-0.
758 		The Pocket Essential Hitchhiker's Guide (second ed.) (2005). Pocket Essentials. ISBN 1-904048-46-3.
759 		Stamp, Robbie, editor (2005). The Making of The Hitchhiker's Guide to the Galaxy: The Filming of the Douglas Adams Classic. Boxtree.
760 			ISBN 0-7522-2585-5.
761 		Webb, Nick (2005). Wish You Were Here: The Official Biography of Douglas Adams (first US hardcover ed.). Ballantine Books. ISBN 0-345-47650-6.
762 
763 	The following text has been lifted from WikiPedia on 19 June 2018. To see the most recent version of this text, visit:
764 	https://en.wikipedia.org/wiki/The_Hitchhiker%27s_Guide_to_the_Galaxy_(novel)
765 	The Hitchhiker's Guide to the Galaxy is the first of five books in  the  Hitchhiker's Guide to the Galaxy  comedy  science  fiction  "trilogy"  by
766 	Douglas Adams. The novel is an adaptation of the first four parts of Adams' radio series of the same  name.  The  novel  was  first  published  in
767 	London on 12 October 1979. It sold 250,000 copies in the first three months.  The  namesake  of  the  novel  is  The  Hitchhiker's  Guide  to  the
768 	Galaxy, a fictional guide book for hitchhikers (inspired  by the  Hitch-hiker's  Guide  to  Europe)  written  in  the  form  of  an  encyclopedia.
769 	Plot summary: The book begins with city council workmen arriving at  Arthur Dent's  house. They  wish  to  demolish  his house in order to build a
770 	bypass. Arthur's best friend, Ford Prefect, arrives, warning him of the end of the world. Ford is  revealed  to  be  an  alien  who  had  come  to
771 	Earth to research it for the titular Hitchhiker's Guide to the Galaxy, an enormous work providing  information  about  every  planet  and place in
772 	the universe. The two head to a pub, where the locals question Ford's knowledge of the Apocalypse. An alien race, known  as  Vogons,  show  up  to
773 	demolish Earth in order to build a bypass for an intergalactic highway. Arthur and Ford manage to get onto the Vogon ship  just  before  Earth  is
774 	demolished, where they are forced to listen to horrible Vogon poetry as a form of torture. Arthur and Ford  are  ordered  to  say  how  much  they
775 	like the poetry in order to avoid being thrown out of the airlock, and while Ford finds  listening  to  be  painful,  Arthur  believes  it  to  be
776 	genuinely good, since human poetry is apparently even worse. Arthur and Ford are then placed into the airlock  and  jettisoned  into  space,  only
777 	to  be  rescued  by  Zaphod Beeblebrox's  ship,  the Heart of Gold.  Zaphod, a  semi-cousin  of  Ford,  is  the  President of the Galaxy,  and  is
778 	accompanied by a depressed robot named Marvin and a human woman by the name of Trillian. The five embark  on  a  journey  to  find  the  legendary
779 	planet known as  Magrathea,  known  for  selling  luxury  planets.  Once  there,  they  are  taken  into  the  planet's  centre  by  a  man  named
780 	Slartibartfast. There,  they  learn  that  a  supercomputer  named  Deep Thought,  who  determined  the ultimate answer to life, the universe, and
781 	everything to be the number 42, created Earth as an even greater computer to calculate  the  question  to  which  42  is  the  answer.  Trillian's
782 	mice, actually part of the group of sentient and hyper-intelligent superbeings that  had  Earth  created  in  the  first place, reject the idea of
783 	building a second Earth to redo the process, and offer to  buy  Arthur's brain in the hope that it contains  the  question,  leading  to  a  fight
784 	when  he  declines.  Zaphod  saves  Arthur  when the brain is about to be removed, and the group decides to go to The Restaurant at the End of the
785 	Universe.
786 		
787 	Illustrated edition: The Illustrated Hitchhiker's Guide to the Galaxy is a specially designed book made in 1994.  It  was  first  printed  in  the
788 	United Kingdom by Weidenfeld & Nicolson and in  the  United States by Harmony Books  (who sold it for $42.00).  It  is an oversized book, and came
789 	in silver-foil "holographic" covers in both the  UK and US  markets.  It  features  the  first  appearance  of  the  42  Puzzle, designed by Adams
790 	himself, a photograph of Adams and his literary agent Ed Victor as  the  two  space  cops,  and  many  other  designs  by  Kevin Davies,  who  has
791 	participated in many Hitchhiker's related projects since the stage  productions  in  the  late  1970s.  Davies  himself  appears  as Prosser. This
792 	edition is out of print – Adams bought up many remainder copies and sold them, autographed, on his website.
793 		
794 	In other media:  Audiobook  adaptations:  There  have  been  three  audiobook  recordings  of  the  novel.  The  first  was  an  abridged  edition
795 	(ISBN 0-671-62964-6), recorded in the mid-1980s by Stephen Moore, best known for playing the voice  of  Marvin  the  Paranoid Android in the radio
796 	series, LP adaptations and in the TV series. In 1990, Adams himself recorded  an  unabridged  edition  for  Dove Audiobooks  (ISBN 1-55800-273-1),
797 	later re-released by New Millennium Audio (ISBN 1-59007-257-X)  in  the  United  States  and  available from BBC Audiobooks in the United Kingdom.
798 	Also by arrangement with Dove, ISIS Publishing Ltd produced a numbered exclusive edition signed by  Douglas Adams  (ISBN 1-85695-028-X)  in  1994.
799 	To tie-in with the 2005 film, actor Stephen Fry, the film's voice of  the  Guide,  recorded  a  second  unabridged  edition  (ISBN 0-7393-2220-6).
800 
801 	Television series: The popularity of the radio series gave rise to a six-episode television series,  directed  and  produced  by  Alan J. W. Bell,
802 	which first aired on BBC 2 in January and February 1981. It employed many  of the  actors  from the radio series and was based mainly on the radio
803 	versions of Fits the First through Sixth. A second series was at one point  planned, with  a storyline, according to Alan Bell and Mark Wing-Davey
804 	that would have come from Adams's abandoned Doctor Who and the Krikkitmen project (instead of simply making  a  TV version  of  the  second  radio
805 	series). However, Adams got into disputes with the BBC (accounts differ: problems with budget, scripts, and  having  Alan Bell  involved  are  all
806 	offered as causes), and the second series was never made. Elements of Doctor Who and the Krikkitmen were instead used in  the  third  novel, Life,
807 	the Universe and Everything. The main cast was the same as the original radio series, except for David Dixon as Ford Prefect instead of  McGivern,
808 	and Sandra Dickinson as Trillian instead of Sheridan.
809 	
810 	Film adaptation: The Hitchhiker's Guide to the Galaxy was adapted into a science fiction comedy film directed by Garth Jennings  and  released  on
811 	28 April 2005 in the UK, Australia and New Zealand, and on the following day in the United States  and  Canada.  It  was  rolled  out  to  cinemas
812 	worldwide during May, June, July, August and September.
813 	
814 	Series: The deliberately misnamed Hitchhiker's Guide to the Galaxy "Trilogy" consists of six books, five written by  Adams: The Hitchhiker's Guide
815 	to the Galaxy (1979), The Restaurant at the End of the Universe (1980), Life, the Universe and Everything (1982),  So Long, and Thanks for All the
816 	Fish (1984) and Mostly Harmless (1992). On 16 September 2008 it was announced that Irish author Eoin Colfer was to pen a  sixth  book.  The  book,
817 	entitled And Another Thing...,  was  published  in   October  2009,   on  the   30th  anniversary  of  the  publication  of  the  original  novel.
818 	
819 	Legacy: When Elon Musk's Tesla Roadster was launched into space on the maiden flight of the Falcon Heavy rocket in February 2018, it had the words
820 	DON'T PANIC on the dashboard display and carried amongst other items a copy of the novel and a towel.
821 	
822 	Awards:
823 		Number one on the Sunday Times best seller list (1979)
824 		Author received the "Golden Pan" (From his publishers for reaching the 1,000,000th book sold) (1984)
825 		Waterstone's Books/Channel Four's list of the 'One Hundred Greatest Books of the Century', at number 24. (1996)
826 		BBC's "Big Read", an attempt to find the "Nation's Best-loved book", ranked it number four. (2003)
827 		
828 */
829 
830 /*	========================================================================================	*/
831 contract ERC20Basic {uint256 public totalSupply; function balanceOf(address who) public constant returns (uint256); function transfer(address to, uint256 value) public returns (bool); event Transfer(address indexed from, address indexed to, uint256 value);}
832 /*	========================================================================================	*/ 
833 /* ERC20 interface see https://github.com/ethereum/EIPs/issues/20 */
834 contract ERC20 is ERC20Basic {function allowance(address owner, address spender) public constant returns (uint256); function transferFrom(address from, address to, uint256 value) public returns (bool); function approve(address spender, uint256 value) public returns (bool); event Approval(address indexed owner, address indexed spender, uint256 value);}
835 /*	========================================================================================	*/ 
836 /*  SafeMath - the lowest gas library - Math operations with safety checks that throw on error */
837 library SafeMath {function mul(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a * b; assert(a == 0 || c / a == b); return c;}
838 // assert(b > 0); // Solidity automatically throws when dividing by 0
839 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
840 function div(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a / b; return c;}
841 function sub(uint256 a, uint256 b) internal pure returns (uint256) {assert(b <= a); return a - b;}
842 function add(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a + b; assert(c >= a); return c;}}
843 /*	========================================================================================	*/ 
844 /*	Basic token Basic version of StandardToken, with no allowances. */
845 contract BasicToken is ERC20Basic {using SafeMath for uint256; mapping(address => uint256) balances;
846 function transfer(address _to, uint256 _value) public returns (bool) {balances[msg.sender] = balances[msg.sender].sub(_value); balances[_to] = balances[_to].add(_value); Transfer(msg.sender, _to, _value); return true;}
847 /*	========================================================================================	*/ 
848 /* Gets the balance of the specified address.
849    param _owner The address to query the the balance of. 
850    return An uint256 representing the amount owned by the passed address.
851 */
852 function balanceOf(address _owner) public constant returns (uint256 balance) {return balances[_owner];}}
853 /*	========================================================================================	*/ 
854 /*  Implementation of the basic standard token. https://github.com/ethereum/EIPs/issues/20 */
855 contract StandardToken is ERC20, BasicToken {mapping (address => mapping (address => uint256)) allowed;
856 /*  Transfer tokens from one address to another
857     param _from address The address which you want to send tokens from
858     param _to address The address which you want to transfer to
859     param _value uint256 the amout of tokens to be transfered
860 */
861 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {var _allowance = allowed[_from][msg.sender];
862 // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
863 // require (_value <= _allowance);
864 balances[_to] = balances[_to].add(_value); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); return true;}
865 /*  Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
866     param _spender The address which will spend the funds.
867     param _value The amount of Douglas Adams' tokens to be spent.
868 */
869 function approve(address _spender, uint256 _value) public returns (bool) {
870 //  To change the approve amount you must first reduce the allowance
871 //  of the adddress to zero by calling `approve(_spender, 0)` if it
872 //  is not already 0 to mitigate the race condition described here:
873 //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
874 require((_value == 0) || (allowed[msg.sender][_spender] == 0)); allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true;}
875 /*  Function to check the amount of tokens that an owner allowed to a spender.
876     param _owner address The of the funds owner.
877     param _spender address The address of the funds spender.
878     return A uint256 Specify the amount of tokens still available to the spender.   */
879 function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {return allowed[_owner][_spender];}}
880 /*	========================================================================================	*/ 
881 /*  The Ownable contract has an owner address, and provides basic authorization control
882     functions, this simplifies the implementation of "user permissions".    */
883 contract Ownable {address public owner;
884 /*  Throws if called by any account other than the owner.                   */
885 function Ownable() public {owner = msg.sender;} modifier onlyOwner() {require(msg.sender == owner);_;}
886 /*  Allows the current owner to transfer control of the contract to a newOwner.
887     param newOwner The address to transfer ownership to.    */
888 function transferOwnership(address newOwner) public onlyOwner {require(newOwner != address(0)); owner = newOwner;}}
889 /*	========================================================================================	*/
890 contract H2G2 is StandardToken, Ownable {
891     string public constant name = "The Hitchhiker's Guide to the Galaxy";
892         string public constant symbol = "H2G2";
893             string public version = 'V1.0.42.000.000.The.Primary.Phase';
894             uint public constant decimals = 18;
895         uint256 public initialSupply;
896     uint256 public unitsOneEthCanBuy;           /*  How many units of H2G2 can be bought by 1 ETH?  */
897 uint256 public totalEthInWei;                   /*  WEI is the smallest unit of ETH (the equivalent */
898                                                 /*  of cent in USD or satoshi in BTC). We'll store  */
899                                                 /*  the total ETH raised via the contract here.     */
900 address public fundsWallet;                     /*  Where should ETH sent to the contract go?       */
901     function H2G2 () public {
902         totalSupply = 42000000 * 10 ** decimals;
903             balances[msg.sender] = totalSupply;
904                 initialSupply = totalSupply;
905             Transfer(0, this, totalSupply);
906         Transfer(this, msg.sender, totalSupply);
907     unitsOneEthCanBuy = 1000;                   /*  Set the contract price of the H2G2 token        */
908 fundsWallet = msg.sender;                       /*  The owner of the contract gets the ETH sent     */
909                                                 /*  to the H2G2 contract                            */
910 }function() public payable{totalEthInWei = totalEthInWei + msg.value; uint256 amount = msg.value * unitsOneEthCanBuy; require(balances[fundsWallet] >= amount); balances[fundsWallet] = balances[fundsWallet] - amount; balances[msg.sender] = balances[msg.sender] + amount;
911 Transfer(fundsWallet, msg.sender, amount);      /*  Broadcast a message to the blockchain           */
912 /*  Transfer ether to fundsWallet   */
913 fundsWallet.transfer(msg.value);}
914 /*  Approves and then calls the receiving contract */
915 function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value);
916 /*  call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
917     receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
918     it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.  */
919 if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { return; } return true;}}
920 /*	========================================================================================	*/
921 /*	At the risk of being quite redundant, we shall reiterate some of the previously provided information from the header section of this token  code.
922 	As mentioned above, this token has a total supply of 42,000,000 tokens which is not only twice the total supply of  BitCoin (BTC),  but  is  also
923 	shades of "The Ultimate Question of Life, the Universe and Everything" to which the answer is forty two. The supplementary token, however, has  a
924 	total supply of only 42 tokens, the reason for which should be quite obvious. The "ticker" symbol for these two tokens differ only by case:  This
925 	token is H2G2 whilst the supplementary token is h2g2. The token names however are completely different. This token  is  The Hitchhiker's Guide to
926 	the Galaxy whilst the supplemental token is HHGTTG. We  would  wish to ask that you refrain from using non-existent words: "hodl", abbreviations:
927 	"lambo", and ridiculous phrases: "to the moon" when referring to these tokens. We  would  much  prefer  the use of such terms as: "hold until the
928 	ends of the earth", "star buggy", and "to magrathea". Marvin the Paranoid Android thanks you in advance, for he has  waited  576 thousand million
929 	years for these tokens to rematerialize out of the space time continuum. Now, THAT my friends is HOLDING. Although we do not plan to offer  these
930 	tokens for sale, they may be acquired by simply sending eth to the contract address. The contract will then respond by sending tokens back to the
931 	address from which the eth was sent. The smallest amount of eth that may be sent to the  contract  is:  .000000000000000001.  The  contract  will
932 	exhibit this behaviour until such time as the total supply of tokens has been depleted.		*/
933 /*	========================================================================================	*/