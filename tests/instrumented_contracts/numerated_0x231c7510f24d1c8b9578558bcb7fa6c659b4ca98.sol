1 //                       , ; ,   .-'"""'-.   , ; ,
2 //                       \\|/  .'          '.  \|//
3 //                        \-;-/   ()   ()   \-;-/
4 //                        // ;               ; \\
5 //                       //__; :.         .; ;__\\
6 //                      `-----\'.'-.....-'.'/-----'
7 //                             '.'.-.-,_.'.'
8 //                               '(  (..-'
9 //                                 '-'
10 //   WHYSOS3RIOUS   PRESENTS :                          
11 //                                                                
12 //   ROCK PAPER SCISSORS
13 //   Challenge an opponent with an encrypted hand
14 //   www.matching-ethers.com/rps                 
15 //
16 //
17 // *** coded by WhySoS3rious, 2016.                                       ***//
18 // *** please do not copy without authorization                          ***//
19 // *** contact : reddit    /u/WhySoS3rious                               ***//
20 
21 //          STAKE : 0.1 ETH
22 //          DRAW : Full refund
23 //          WIN : 0.198 ETH (house : 0.002)
24 //          EXPIRATION TIME : 1hour after duel starts (refreshed when one player reveals)
25 //          If only one player reveals, he wins after 1 hour if the other doesn't reveal
26 //          he will be paid automatically when other ppl play the game.
27 //          If both player don't reveal and forget the bet, it is refunded (-house)
28 
29 //         HOW TO PLAY ?
30 //         1- Send a encrypted Hand (generated on the game's website or by yourself)
31 //         2- Wait for opponent (can cancel if you wish)
32 //         3- Once matched, reveal your hand with the appropriate function and your secret
33 //         4- Wait for your duel to resolve and the automatic payout
34 
35 //         ENCRYPT YOUR HAND
36 //         Encrypt your hands on the website or
37 //         directly with web3.js :  web3.sha3(secret+hand)
38 
39 // exemple results with secret = "testing"
40 //hand = "rock" :  web3.sha3("testing"+"rock")
41 // 0x8935dc293ca2ee08e33bad4f4061699a8f59ec637081944145ca19cbc8b39473
42 //hand = "paper" : 
43 // 0x859743aa01286a6a1eba5dbbcc4cf8eeaf1cc953a3118799ba290afff7125501
44 //hand = "scissors" : 
45 //0x35ccbb689808295e5c51510ed28a96a729e963a12d09c4a7a4ba000c9777e897
46 
47 contract Crypted_RPS
48 {
49     address owner;
50     uint256 gambleValue;
51     uint256 expirationTime;
52     uint256 house;
53     uint256 houseTotal;
54     modifier noEthSent(){
55         if (msg.value>0) msg.sender.send(msg.value);
56         _
57     }
58     modifier onlyOwner() {
59 	    if (msg.sender!=owner) throw;
60 	    _
61     }
62     modifier equalGambleValue() {
63 	if (msg.value < gambleValue) throw;
64         if (msg.value > gambleValue) msg.sender.send(msg.value-gambleValue);
65 	_
66     }
67 
68     struct PlayerWaiting
69     {
70         bool full;
71         address player;
72         bytes32 cryptedHand;
73     }
74     PlayerWaiting playerWaiting;
75 
76     struct Duel2Decrypt
77     {
78 	address player_1;
79         bytes32 cryptedHand_1;
80         address player_2;
81  	bytes32 cryptedHand_2;
82         bool decrypted;
83         uint256 timeStamp;
84     }
85     Duel2Decrypt[] duels2Decrypt;
86     uint firstActiveDuel2; //index of first Duel 2 not decrypted
87 
88     struct Duel1Decrypt
89    {
90 	address player_1;
91         string hand_1;
92         address player_2;
93 	bytes32 cryptedHand_2;
94         bool decrypted;
95         uint256 timeStamp;
96     }
97     Duel1Decrypt[] duels1Decrypt;
98     uint firstActiveDuel1;
99 
100     struct Result  
101     {
102        address player_1;
103        string hand_1;
104        address player_2;
105        string hand_2;
106        uint result; //0 draw, 1 wins, 2 wins
107     }
108     Result[] results;
109 
110 
111     mapping (address => uint) player_progress;
112     // 0 not here, 1 waiting, 2 2crypted, 3 1crypted
113     mapping (address => uint) player_bet_id;
114     mapping (address => uint) player_bet_position;
115 
116     function getPlayerStatus(address player, uint option) constant returns (uint result)
117     {
118          if (option==0) {result = player_progress[player];}
119          else if (option==1) {result= player_bet_id[player];}
120          else if (option==2) {result = player_bet_position[player];}
121          return result;
122     }
123 
124 
125     mapping (string => mapping(string => int)) payoffMatrix;
126     //constructor
127     function Crypted_RPS()
128     {
129 	owner= msg.sender;
130 	gambleValue = 100000 szabo;
131         house = 1000 szabo;
132         expirationTime = 7200;   //2 hour
133         payoffMatrix["rock"]["rock"] = 0;
134         payoffMatrix["rock"]["paper"] = 2;
135         payoffMatrix["rock"]["scissors"] = 1;
136         payoffMatrix["paper"]["rock"] = 1;
137         payoffMatrix["paper"]["paper"] = 0;
138         payoffMatrix["paper"]["scissors"] = 2;
139         payoffMatrix["scissors"]["rock"] = 2;
140         payoffMatrix["scissors"]["paper"] = 1;
141         payoffMatrix["scissors"]["scissors"] = 0;
142     }
143 
144     function () {throw;} //no callback, use the functions to play
145 
146     modifier payexpired2Duel{
147         if (duels2Decrypt.length>firstActiveDuel2 && duels2Decrypt[firstActiveDuel2].timeStamp + expirationTime <= now) {
148             duels2Decrypt[firstActiveDuel2].player_1.send(gambleValue-house);
149             duels2Decrypt[firstActiveDuel2].player_2.send(gambleValue-house);
150             houseTotal+=2*house;
151             player_progress[duels2Decrypt[firstActiveDuel2].player_1]=0;
152             player_progress[duels2Decrypt[firstActiveDuel2].player_2]=0;
153             duels2Decrypt[firstActiveDuel2].decrypted = true;
154             updateFirstDuel2(firstActiveDuel2);
155         }
156         _
157     }
158 
159     modifier payexpired1Duel{
160         if (duels1Decrypt.length>firstActiveDuel1 && (duels1Decrypt[firstActiveDuel1].timeStamp + expirationTime) < now) {
161             duels1Decrypt[firstActiveDuel1].player_1.send(2*(gambleValue-house));
162             houseTotal+=2*house;
163             duels1Decrypt[firstActiveDuel1].decrypted = true;
164             player_progress[duels1Decrypt[firstActiveDuel1].player_1]=0;
165             player_progress[duels1Decrypt[firstActiveDuel1].player_2]=0;
166             results.push(Result(duels1Decrypt[firstActiveDuel1].player_1, duels1Decrypt[firstActiveDuel1].hand_1, duels1Decrypt[firstActiveDuel1].player_2,"expired", 1));
167             updateFirstDuel1(firstActiveDuel1);
168            
169         }
170         _
171     }
172         
173 
174     function cancelWaitingForOpponent()
175     noEthSent {
176         if (msg.sender==playerWaiting.player && playerWaiting.full)
177         {
178              msg.sender.send(gambleValue);
179              playerWaiting.full=false;
180              player_progress[msg.sender]=0;
181         }
182         else { throw;}
183     }	
184 
185 
186     function sendCryptedHand(bytes32 cryptedH)
187     equalGambleValue
188     payexpired2Duel
189     payexpired1Duel
190     {
191           uint progress = player_progress[msg.sender];
192           uint position = player_bet_position[msg.sender];
193           //one not resolved duel per player only
194           if ( progress==3 && position==1 )throw;
195           if (progress == 2 ) throw; 
196           if (progress ==  1 ) throw; //no selfdueling
197           if (!playerWaiting.full) 
198           {
199               playerWaiting.player=msg.sender;
200               playerWaiting.cryptedHand= cryptedH;
201               playerWaiting.full=true;
202               player_progress[msg.sender]=1;
203           }
204           else
205           {
206                duels2Decrypt.push( Duel2Decrypt(playerWaiting.player, playerWaiting.cryptedHand, msg.sender, cryptedH, false, now) );
207                 player_progress[playerWaiting.player]=2;
208                 player_bet_id[playerWaiting.player]=duels2Decrypt.length-1;
209                 player_bet_position[playerWaiting.player]=0;
210                 player_progress[msg.sender]=2;
211                 player_bet_id[msg.sender]=duels2Decrypt.length-1;
212                 player_bet_position[msg.sender]=1;         
213                 playerWaiting.full=false;
214           }
215 
216     }
217 
218 
219     function revealRock(string secret)
220     {
221         bytes32 hashRevealed = sha3(secret, "rock");
222         reveal(hashRevealed, "rock");
223     }
224     function revealPaper(string secret)
225     {
226         bytes32 hashRevealed = sha3(secret, "paper");
227         reveal(hashRevealed, "paper");
228     }
229     function revealScissors(string secret)
230     {
231         bytes32 hashRevealed = sha3(secret, "scissors");
232         reveal(hashRevealed, "scissors");
233     }
234 
235     function reveal(bytes32 hashRevealed, string hand) private
236     noEthSent
237    {
238 
239         uint progress =  getPlayerStatus(msg.sender,0);
240         uint bet_id     =  getPlayerStatus(msg.sender,1);
241         uint position  =  getPlayerStatus(msg.sender,2);
242         
243 
244         bytes32 hashStored;        
245         if (progress==2)  //duel not revealed
246         { 
247             if (position == 0)
248             {
249                  hashStored = duels2Decrypt[bet_id].cryptedHand_1;
250             }
251             else
252             {
253                  hashStored = duels2Decrypt[bet_id].cryptedHand_2;
254             }
255         }
256         else if (progress==3 && position==1) //duel half revealed already
257         { 
258                 hashStored = duels1Decrypt[bet_id].cryptedHand_2;
259         }
260         else { throw;} //player has nothing to reveal
261 
262 	if (hashStored==hashRevealed)
263         {
264               decryptHand(hand, progress, bet_id, position);
265         }
266         else
267         {
268              throw; //wrong secret or hand
269          }
270     }
271     
272     function  decryptHand(string hand, uint progress, uint bet_id, uint position) private
273     {
274              address op_add;
275              bytes32 op_cH;
276 
277          if (progress==2)
278          {  
279              if (position==0) 
280              {
281                  op_add = duels2Decrypt[bet_id].player_2;
282                  op_cH = duels2Decrypt[bet_id].cryptedHand_2;
283 
284              }
285              else
286              {
287                  op_add = duels2Decrypt[bet_id].player_1;
288                  op_cH = duels2Decrypt[bet_id].cryptedHand_1;
289              }
290 
291               duels1Decrypt.push(Duel1Decrypt(msg.sender,hand,op_add, op_cH, false, now));
292               duels2Decrypt[bet_id].decrypted=true;
293               updateFirstDuel2(bet_id);
294               player_progress[msg.sender]=3;
295               player_bet_id[msg.sender]=duels1Decrypt.length-1;
296               player_bet_position[msg.sender]=0;
297               player_progress[op_add]=3;
298               player_bet_id[op_add]=duels1Decrypt.length-1;
299               player_bet_position[op_add]=1;
300 
301          }
302          else if (progress==3 && position==1)
303          {
304               op_add = duels1Decrypt[bet_id].player_1;
305               string op_h = duels1Decrypt[bet_id].hand_1;
306               duels1Decrypt[bet_id].decrypted=true;
307               uint result = payDuel(op_add, op_h, msg.sender, hand);
308               results.push(Result(op_add, op_h, msg.sender,hand, result));
309               updateFirstDuel1(bet_id);
310               player_progress[msg.sender]=0;
311               player_progress[op_add]=0;
312           }
313      }
314 
315      function updateFirstDuel2(uint bet_id) private
316      {
317          if (bet_id==firstActiveDuel2)
318          {   
319               uint index;
320               while (true) {
321                  if (index<duels2Decrypt.length && duels2Decrypt[index].decrypted){
322                      index=index+1;
323                  }
324                  else {break; }
325               }
326               firstActiveDuel2=index;
327               return;
328           }
329       }
330 
331      function updateFirstDuel1(uint bet_id) private
332      {
333          if (bet_id==firstActiveDuel1)
334          {   
335               uint index;
336               while (true) {
337                  if (index<duels1Decrypt.length && duels1Decrypt[index].decrypted){
338                      index=index+1;
339                  }
340                  else {break; }
341               }
342               firstActiveDuel1=index;
343               return;
344           }
345       }
346 
347      // in case there is too much expired duels in queue for automatic payout, 
348      //I can help to catch up
349      function manualPayExpiredDuel() 
350      onlyOwner
351      payexpired2Duel
352      payexpired1Duel
353      noEthSent
354      {
355          return;
356      }
357 
358      //payout
359      function payDuel(address player_1, string hand_1, address player_2, string hand_2) private returns(uint result) 
360      {
361               if (payoffMatrix[hand_1][hand_2]==0) //draw
362               {player_1.send(gambleValue); player_2.send(gambleValue); result=0;}
363               else if (payoffMatrix[hand_1][hand_2]==1) //1 win
364               {player_1.send(2*(gambleValue-house)); result=1; houseTotal+=2*house;}
365               if (payoffMatrix[hand_1][hand_2]==2) //2 wins
366               {player_2.send(2*(gambleValue-house)); result=2; houseTotal+=2*house;}
367               return result;
368       }
369 
370      function payHouse() 
371      onlyOwner
372      noEthSent {
373          owner.send(houseTotal);
374          houseTotal=0;
375      }
376 
377      function getFirstActiveDuel1() constant returns(uint fAD1) {
378          return firstActiveDuel1;}
379      function getLastDuel1() constant returns(uint lD1) {
380          return duels1Decrypt.length;}
381      function getDuel1(uint index) constant returns(address p1, string h1, address p2, bool dC, uint256 tS) {
382          p1 = duels1Decrypt[index].player_1;
383          h1 = duels1Decrypt[index].hand_1;
384          p2 = duels1Decrypt[index].player_2;
385          dC = duels1Decrypt[index].decrypted;
386          tS  = duels1Decrypt[index].timeStamp;
387      }
388 
389      function getFirstActiveDuel2() constant returns(uint fAD2) {
390          return firstActiveDuel2;}
391      function getLastDuel2() constant returns(uint lD2) {
392          return duels2Decrypt.length;}
393      function getDuel2(uint index) constant returns(address p1, address p2, bool dC, uint256 tS) {
394          p1 = duels2Decrypt[index].player_1;
395          p2 = duels2Decrypt[index].player_2;
396          dC = duels2Decrypt[index].decrypted;
397          tS  = duels2Decrypt[index].timeStamp;
398      }
399 
400      function getPlayerWaiting() constant returns(address p, bool full) {
401          p = playerWaiting.player;
402          full = playerWaiting.full;
403      }
404 
405      function getLastResult() constant returns(uint lD2) {
406          return results.length;}
407      function getResults(uint index) constant returns(address p1, string h1, address p2, string h2, uint r) {
408          p1 = results[index].player_1;
409          h1 = results[index].hand_1;
410          p2 = results[index].player_2;
411          h2 = results[index].hand_2;
412          r = results[index].result;
413      }
414 
415 
416 }