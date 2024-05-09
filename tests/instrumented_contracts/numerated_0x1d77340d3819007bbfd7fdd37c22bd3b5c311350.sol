1 contract RockPaperScissors {
2   /*
3     Brief introduction:
4     the game is about to submit your pick (R/P/S) with fee to the blockchain,
5     join players into pairs and withdraw 2x the fee, or just 1x the fee in case of draw.
6     if there will be no other player in "LimitOfMinutes" minutes you can refund your fee.
7 
8     The whole thing is made by picking a random value called SECRET_RAND, where (SECRET_RAND % 3) gives 0,1 or 2 for Rock,Paper or Scissors,
9     then taking a hash of SECRET_RAND and submitting it as your ticket.
10     At this moment player waits for opponent. If there is no opponent in "LimitOfMinutes", player can refund or wait more.
11     When both players sended their hashes then they have "LimitOfMinutes" minutes to announce their SECRET_RAND.
12     As soon as both players provided their SECRET_RAND the withdraw is possible.
13     If opponent will not announce his SECRET_RAND in LimitOfMinutes then the players bet is treated as a winning one.
14     In any case (win, draw, refund) you should use Withdraw() function to pay out.
15 
16     There is fee of 1% for contract owner, charged while player withdraws.
17     There is no fee for contract owner in case of refund.
18    */
19 
20   /*
21   JSON Interface:
22 
23 [{"constant":true,"inputs":[],"name":"Announcement","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":false,"inputs":[{"name":"HASH","type":"bytes32"}],"name":"play","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"MySecretRand","type":"bytes32"}],"name":"announce","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"MyHash","type":"bytes32"}],"name":"IsPayoutReady__InfoFunction","outputs":[{"name":"Info","type":"string"}],"type":"function"},{"constant":true,"inputs":[{"name":"RockPaperOrScissors","type":"uint8"},{"name":"WriteHereSomeUniqeRandomStuff","type":"string"}],"name":"CreateHash","outputs":[{"name":"SendThisHashToStart","type":"bytes32"},{"name":"YourSecretRandKey","type":"bytes32"},{"name":"Info","type":"string"}],"type":"function"},{"constant":true,"inputs":[{"name":"SecretRand","type":"bytes32"}],"name":"WhatWasMyHash","outputs":[{"name":"HASH","type":"bytes32"}],"type":"function"},{"constant":false,"inputs":[{"name":"HASH","type":"bytes32"}],"name":"withdraw","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"LimitOfMinutes","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"constant":true,"inputs":[],"name":"Cost","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"inputs":[],"type":"constructor"}]
24  */
25   modifier OnlyOwner()
26   { // Modifier
27     if (msg.sender != owner) throw;
28     _
29   }
30   
31   uint8 public LimitOfMinutes;//number of minutes you have to announce (1)your choice or (2)wait to withdraw funds back if no one else will play
32   uint public Cost;
33   string public Announcement;
34 
35   address owner;
36   uint TimeOfLastPriceChange;
37   mapping(bytes32=>bet_t) bets;
38   uint playerssofar;
39   struct bet_t {
40     bytes32 OpponentHash;
41     address sender;
42     uint timestamp;
43     int8 Pick;
44     bool can_withdraw;//default==false
45   }
46   bytes32 LastHash;
47   
48   function RockPaperScissors()
49   {
50     playerssofar=0;
51     owner=msg.sender;
52     //SetInternalValues(limitofminutes, cost);
53     LimitOfMinutes=255;
54     Cost=100000000000000000;//0.1ETH
55     TimeOfLastPriceChange = now - 255*60;
56   }
57   function SetInternalValues(uint8 limitofminutes, uint cost)
58     OnlyOwner
59   {
60     LimitOfMinutes=limitofminutes;
61     if(Cost!=cost)
62       {
63 	Cost=cost;
64 	TimeOfLastPriceChange=now;
65       }
66   }
67   function OwnerAnnounce(string announcement)
68     OnlyOwner
69   {
70     Announcement=announcement;
71   }
72  
73   function play(bytes32 HASH)
74   {
75     if(now < TimeOfLastPriceChange + LimitOfMinutes*60 || //the game is temprorary off 
76        msg.value != Cost || // pay to play 
77        //bets[HASH].can_withdraw == true ||//to play twice, give another random seed in CreateHash() f-n
78        bets[HASH].sender != 0 || //throw because someone have already made this bet 
79        HASH == 0 //this would be problematic situation
80        )
81       throw;
82 
83     bets[HASH].sender=msg.sender;
84     bets[HASH].can_withdraw=true;
85     if(playerssofar%2 == 1)
86       {
87 	bets[HASH].OpponentHash=LastHash;
88 	bets[LastHash].OpponentHash=HASH;
89       }
90     else
91       LastHash=HASH;
92     bets[HASH].timestamp=now;
93     playerssofar++;
94   }
95 
96   function announce(bytes32 MySecretRand)
97   {
98     if(msg.value != 0 ||
99        bets[sha3(MySecretRand)].can_withdraw==false)
100       throw; //if you try to announce non existing bet (do not waste your gas)
101     bets[sha3(MySecretRand)].Pick= int8( uint(MySecretRand)%3 + 1 );
102     //there is no check of msg.sender. If your secret rand was guessed by someone else it is no longer secret
103     //remember to give good 'random' seed as input of CreateHash f-n.
104     bets[sha3(MySecretRand)].timestamp=now;
105   }
106 
107   function withdraw(bytes32 HASH)
108   { //3 ways to payout:
109     //1: both sides announced their picks and you have won OR draw happend
110     //2: no one else played - you can payout after LimitOfMinutes (100% refund)
111     //3: you have announced your pick but opponent not (you have won)
112     //note that both of you has "LimitOfMinutes" minutes to announce the SecretRand numbers after 2nd player played
113     if(msg.value != 0 || 
114        bets[HASH].can_withdraw == false)
115       throw;
116 
117     if(bets[HASH].OpponentHash!=0 && //case 1
118        bets[bets[HASH].OpponentHash].Pick != 0 && //check if opponent announced
119        bets[HASH].Pick != 0 //check if player announced
120        //it is impossible for val .Pick to be !=0 without broadcasting SecretRand
121        )
122       {
123 	int8 tmp = bets[HASH].Pick - bets[bets[HASH].OpponentHash].Pick;
124 	if(tmp==0)//draw?
125 	  {
126 	    bets[HASH].can_withdraw=false;
127 	    if(!bets[HASH].sender.send(Cost*99/100)) //return ETH
128 	      throw;
129 	    else
130 	      if(!owner.send(Cost/100))
131 		throw;
132 	  }
133 	else if(tmp == 1 || tmp == -2)//you have won
134 	  {
135 	    bets[HASH].can_withdraw=false;
136 	    bets[bets[HASH].OpponentHash].can_withdraw=false;
137 	    if(!bets[HASH].sender.send(2*Cost*99/100)) //refund
138 	      throw;	    
139 	    else
140 	      if(!owner.send(2*Cost/100))
141 		throw;
142 	  }
143 	else
144 	  throw;
145       }
146     else if(bets[HASH].OpponentHash==0 && //case 2
147 	    now > bets[HASH].timestamp + LimitOfMinutes*60)
148       {
149 	bets[HASH].can_withdraw=false;
150 	if(!bets[HASH].sender.send(Cost)) //refund
151 	  throw;
152 
153 	//if we are here that means we should repair playerssofar
154 	--playerssofar;
155       }
156     else if(bets[HASH].OpponentHash!=0 && 
157 	    bets[bets[HASH].OpponentHash].Pick == 0 && //opponent did not announced
158 	    bets[HASH].Pick != 0 //check if player announced
159 	    )//case 3
160       {
161 	//now lets make sure that opponent had enough time to announce
162 	if(//now > (time of last interaction from player or opponent)
163 	   now > bets[HASH].timestamp + LimitOfMinutes*60 &&
164 	   now > bets[bets[HASH].OpponentHash].timestamp + LimitOfMinutes*60
165 	   )//then refund is possible
166 	  {
167 	    bets[HASH].can_withdraw=false;
168 	    bets[bets[HASH].OpponentHash].can_withdraw=false;
169 	    if(!bets[HASH].sender.send(2*Cost*99/100)) 
170 	      throw;
171 	    else
172 	      if(!owner.send(2*Cost/100))
173 		throw;
174 	  }
175 	else
176 	  throw;//you still need to wait some more time
177       }
178     else
179       throw; //throw in any other case
180     //here program flow jumps
181     //and program ends
182   }
183 
184   function IsPayoutReady__InfoFunction(bytes32 MyHash)
185     constant
186     returns (string Info) 
187   {
188     // "write your hash"
189     // "you can send this hash and double your ETH!"
190     // "wait for opponent [Xmin left]"
191     // "you can announce your SecretRand"
192     // "wait for opponent SecretRand"
193     // "ready to withdraw - you have won!"
194     // "you have lost, try again"
195     if(MyHash == 0)
196       return "write your hash";
197     if(bets[MyHash].sender == 0) 
198       return "you can send this hash and double your ETH!";
199     if(bets[MyHash].sender != 0 &&
200        bets[MyHash].can_withdraw==false) 
201       return "this bet is burned";
202     if(bets[MyHash].OpponentHash==0 &&
203        now < bets[MyHash].timestamp + LimitOfMinutes*60)
204       return "wait for other player";
205     if(bets[MyHash].OpponentHash==0)
206       return "no one played, use withdraw() for refund";
207     
208     //from now there is opponent
209     bool timeforaction =
210       (now < bets[MyHash].timestamp + LimitOfMinutes*60) ||
211       (now < bets[bets[MyHash].OpponentHash].timestamp + LimitOfMinutes*60 );
212     
213     if(bets[MyHash].Pick == 0 &&
214        timeforaction
215        )
216       return "you can announce your SecretRand";
217     if(bets[MyHash].Pick == 0)
218       return "you have failed to announce your SecretRand but still you can try before opponent withdraws";
219     if(bets[bets[MyHash].OpponentHash].Pick == 0 &&
220        timeforaction
221        )
222       return "wait for opponent SecretRand";
223 
224 
225     bool win=false;
226     bool draw=false;
227     int8 tmp = bets[MyHash].Pick - bets[bets[MyHash].OpponentHash].Pick;
228     if(tmp==0)//draw?
229       draw=true;
230     else if(tmp == 1 || tmp == -2)//you have won
231       win=true;
232     
233     if(bets[bets[MyHash].OpponentHash].Pick == 0 ||
234        win
235        )
236       return "you have won! now you can withdraw your ETH";
237     if(draw)
238       return "Draw happend! withdraw back your funds";
239 
240 
241     return "you have lost, try again";
242   }
243 
244   function WhatWasMyHash(bytes32 SecretRand)
245     constant
246     returns (bytes32 HASH) 
247   {
248     return sha3(SecretRand);
249   }
250 
251   function CreateHash(uint8 RockPaperOrScissors, string WriteHereSomeUniqeRandomStuff)
252     constant
253     returns (bytes32 SendThisHashToStart,
254 	     bytes32 YourSecretRandKey,
255 	     string Info)
256   {
257     uint SecretRand;
258 
259     SecretRand=3*( uint(sha3(WriteHereSomeUniqeRandomStuff))/3 ) + (RockPaperOrScissors-1)%3;
260     //SecretRand%3 ==
261     //0 - Rock
262     //1 - Paper
263     //2 - Scissors
264 
265     if(RockPaperOrScissors==0)
266       return(0,0, "enter 1 for Rock, 2 for Paper, 3 for Scissors");
267 
268     return (sha3(bytes32(SecretRand)),bytes32(SecretRand),  bets[sha3(bytes32(SecretRand))].sender != 0 ? "someone have already used this random string - try another one" :
269                                                             SecretRand%3==0 ? "Rock" :
270 	                                                        SecretRand%3==1 ? "Paper" :
271 	                                                        "Scissors");
272   }
273 
274 }