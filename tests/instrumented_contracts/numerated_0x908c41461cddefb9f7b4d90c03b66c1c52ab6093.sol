1 pragma solidity ^0.4.8;
2 
3 contract Rouleth
4 {
5   //Game and Global Variables, Structure of gambles
6   address public developer;
7   uint8 public blockDelay; //nb of blocks to wait before spin
8   uint8 public blockExpiration; //nb of blocks before bet expiration (due to hash storage limits)
9   uint256 public maxGamble; //max gamble value manually set by config
10   uint256 public minGamble; //min gamble value manually set by config
11   uint public maxBetsPerBlock; //limits the number of bets per blocks to prevent miner cheating
12   uint nbBetsCurrentBlock; //counts the nb of bets in the block
13 
14     
15   //Gambles
16   enum BetTypes{number, color, parity, dozen, column, lowhigh} 
17   struct Gamble
18   {
19     address player;
20     bool spinned; //Was the rouleth spinned ?
21     bool win;
22     //Possible bet types
23     BetTypes betType;
24     uint8 input; //stores number, color, dozen or oddeven
25     uint256 wager;
26     uint256 blockNumber; //block of bet
27     uint256 blockSpinned; //block of spin
28     uint8 wheelResult;
29   }
30   Gamble[] private gambles;
31   uint public totalGambles; 
32   //Tracking progress of players
33   mapping (address=>uint) gambleIndex; //current gamble index of the player
34   //records current status of player
35   enum Status {waitingForBet, waitingForSpin} mapping (address=>Status) playerStatus; 
36 
37 
38   //**********************************************
39   //        Management & Config FUNCTIONS        //
40   //**********************************************
41 
42   function  Rouleth() //creation settings
43   { 
44     developer = msg.sender;
45     blockDelay=0; //indicates which block after bet will be used for RNG
46     blockExpiration=200; //delay after which gamble expires
47     minGamble=50 finney; //configurable min bet
48     maxGamble=750 finney; //configurable max bet
49     maxBetsPerBlock=5; // limit of bets per block, to prevent multiple bets per miners
50   }
51     
52   modifier onlyDeveloper() 
53   {
54     if (msg.sender!=developer) throw;
55     _;
56   }
57 
58   function addBankroll()
59     onlyDeveloper
60     payable {
61   }
62 
63   function removeBankroll(uint256 _amount_wei)
64     onlyDeveloper
65   {
66     if (!developer.send(_amount_wei)) throw;
67   }
68     
69   function changeDeveloper_only_Dev(address new_dev)
70     onlyDeveloper
71   {
72     developer=new_dev;
73   }
74 
75 
76   //Activate, Deactivate Betting
77   enum States{active, inactive} States private contract_state;
78     
79   function disableBetting_only_Dev()
80     onlyDeveloper
81   {
82     contract_state=States.inactive;
83   }
84 
85 
86   function enableBetting_only_Dev()
87     onlyDeveloper
88   {
89     contract_state=States.active;
90 
91   }
92     
93   modifier onlyActive()
94   {
95     if (contract_state==States.inactive) throw;
96     _;
97   }
98 
99 
100 
101   //Change some settings within safety bounds
102   function changeSettings_only_Dev(uint newMaxBetsBlock, uint256 newMinGamble, uint256 newMaxGamble, uint8 newBlockDelay, uint8 newBlockExpiration)
103     onlyDeveloper
104   {
105     //Max number of bets per block to prevent miner cheating
106     maxBetsPerBlock=newMaxBetsBlock;
107     //MAX BET : limited by payroll/(casinoStatisticalLimit*35)
108     if (newMaxGamble<newMinGamble) throw;  
109     maxGamble=newMaxGamble; 
110     minGamble=newMinGamble;
111     //Delay before spin :
112     blockDelay=newBlockDelay;
113     if (newBlockExpiration < blockDelay + 250) throw;
114     blockExpiration=newBlockExpiration;
115   }
116 
117 
118   //**********************************************
119   //                 BETTING FUNCTIONS                    //
120   //**********************************************
121 
122   //***//basic betting without Mist or contract call
123   //activates when the player only sends eth to the contract
124   //without specifying any type of bet.
125   function ()
126     payable
127     {
128       //defaut bet : bet on red
129       betOnColor(false);
130     } 
131 
132   //***//Guarantees that gamble is under max bet and above min.
133   // returns bet value
134   function checkBetValue() private returns(uint256)
135   {
136     uint256 playerBetValue;
137     if (msg.value < minGamble) throw;
138     if (msg.value > maxGamble){
139       playerBetValue = maxGamble;
140     }
141     else{
142       playerBetValue=msg.value;
143     }
144     return playerBetValue;
145   }
146 
147 
148   //check number of bets in block (to prevent miner cheating)
149   modifier checkNbBetsCurrentBlock()
150   {
151     if (gambles.length!=0 && block.number==gambles[gambles.length-1].blockNumber) nbBetsCurrentBlock+=1;
152     else nbBetsCurrentBlock=0;
153     if (nbBetsCurrentBlock>=maxBetsPerBlock) throw;
154     _;
155   }
156 
157 
158   //Function record bet called by all others betting functions
159   function placeBet(BetTypes betType_, uint8 input_) private
160   {
161     if (playerStatus[msg.sender]!=Status.waitingForBet)
162       {
163 	SpinTheWheel(msg.sender);
164       }
165     //Once this is done, we can record the new bet
166     playerStatus[msg.sender]=Status.waitingForSpin;
167     gambleIndex[msg.sender]=gambles.length;
168     totalGambles++;
169     //adapts wager to casino limits
170     uint256 betValue = checkBetValue();
171     gambles.push(Gamble(msg.sender, false, false, betType_, input_, betValue, block.number, 0, 37)); //37 indicates not spinned yet
172     //refund excess bet (at last step vs re-entry)
173     if (betValue < msg.value) 
174       {
175 	if (msg.sender.send(msg.value-betValue)==false) throw;
176       }
177   }
178 
179 
180   //***//bet on Number	
181   function betOnNumber(uint8 numberChosen)
182     payable
183     onlyActive
184     checkNbBetsCurrentBlock
185   {
186     //check that number chosen is valid and records bet
187     if (numberChosen>36) throw;
188     placeBet(BetTypes.number, numberChosen);
189   }
190 
191   //***// function betOnColor
192   //bet type : color
193   //input : 0 for red
194   //input : 1 for black
195   function betOnColor(bool Black)
196     payable
197     onlyActive
198     checkNbBetsCurrentBlock
199   {
200     uint8 input;
201     if (!Black) 
202       { 
203 	input=0;
204       }
205     else{
206       input=1;
207     }
208     placeBet(BetTypes.color, input);
209   }
210 
211   //***// function betOnLow_High
212   //bet type : lowhigh
213   //input : 0 for low
214   //input : 1 for low
215   function betOnLowHigh(bool High)
216     payable
217     onlyActive
218     checkNbBetsCurrentBlock
219   {
220     uint8 input;
221     if (!High) 
222       { 
223 	input=0;
224       }
225     else 
226       {
227 	input=1;
228       }
229     placeBet(BetTypes.lowhigh, input);
230   }
231 
232   //***// function betOnOddEven
233   //bet type : parity
234   //input : 0 for even
235   //input : 1 for odd
236   function betOnOddEven(bool Odd)
237     payable
238     onlyActive
239     checkNbBetsCurrentBlock
240   {
241     uint8 input;
242     if (!Odd) 
243       { 
244 	input=0;
245       }
246     else{
247       input=1;
248     }
249     placeBet(BetTypes.parity, input);
250   }
251 
252   //***// function betOnDozen
253   //     //bet type : dozen
254   //     //input : 0 for first dozen
255   //     //input : 1 for second dozen
256   //     //input : 2 for third dozen
257   function betOnDozen(uint8 dozen_selected_0_1_2)
258     payable
259     onlyActive
260     checkNbBetsCurrentBlock
261   {
262     if (dozen_selected_0_1_2 > 2) throw;
263     placeBet(BetTypes.dozen, dozen_selected_0_1_2);
264   }
265 
266 
267   // //***// function betOnColumn
268   //     //bet type : column
269   //     //input : 0 for first column
270   //     //input : 1 for second column
271   //     //input : 2 for third column
272   function betOnColumn(uint8 column_selected_0_1_2)
273     payable
274     onlyActive
275     checkNbBetsCurrentBlock
276   {
277     if (column_selected_0_1_2 > 2) throw;
278     placeBet(BetTypes.column, column_selected_0_1_2);
279   }
280 
281   //**********************************************
282   // Spin The Wheel & Check Result FUNCTIONS//
283   //**********************************************
284 
285   event Win(address player, uint8 result, uint value_won, bytes32 bHash, bytes32 sha3Player, uint gambleId, uint bet);
286   event Loss(address player, uint8 result, uint value_loss, bytes32 bHash, bytes32 sha3Player, uint gambleId, uint bet);
287 
288   //***//function to spin callable
289   // no eth allowed
290   function spinTheWheel(address spin_for_player)
291   {
292     SpinTheWheel(spin_for_player);
293   }
294 
295 
296   function SpinTheWheel(address playerSpinned) private
297   {
298     if (playerSpinned==0)
299       {
300 	playerSpinned=msg.sender;         //if no index spins for the sender
301       }
302 
303     //check that player has to spin
304     if (playerStatus[playerSpinned]!=Status.waitingForSpin) throw;
305     //redundent double check : check that gamble has not been spinned already
306     if (gambles[gambleIndex[playerSpinned]].spinned==true) throw;
307     //check that the player waited for the delay before spin
308     //and also that the bet is not expired
309     uint playerblock = gambles[gambleIndex[playerSpinned]].blockNumber;
310     //too early to spin
311     if (block.number<=playerblock+blockDelay) throw;
312     //too late, bet expired, player lost
313     else if (block.number>playerblock+blockExpiration)  solveBet(playerSpinned, 255, false, 1, 0, 0) ;
314     //spin !
315     else
316       {
317 	uint8 wheelResult;
318 	//Spin the wheel, 
319 	bytes32 blockHash= block.blockhash(playerblock+blockDelay);
320 	//security check that the Hash is not empty
321 	if (blockHash==0) throw;
322 	// generate the hash for RNG from the blockHash and the player's address
323 	bytes32 shaPlayer = sha3(playerSpinned, blockHash, this);
324 	// get the final wheel result
325 	wheelResult = uint8(uint256(shaPlayer)%37);
326 	//check result against bet and pay if win
327 	checkBetResult(wheelResult, playerSpinned, blockHash, shaPlayer);
328       }
329   }
330     
331 
332   //CHECK BETS FUNCTIONS private
333   function checkBetResult(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
334   {
335     BetTypes betType=gambles[gambleIndex[player]].betType;
336     //bet on Number
337     if (betType==BetTypes.number) checkBetNumber(result, player, blockHash, shaPlayer);
338     else if (betType==BetTypes.parity) checkBetParity(result, player, blockHash, shaPlayer);
339     else if (betType==BetTypes.color) checkBetColor(result, player, blockHash, shaPlayer);
340     else if (betType==BetTypes.lowhigh) checkBetLowhigh(result, player, blockHash, shaPlayer);
341     else if (betType==BetTypes.dozen) checkBetDozen(result, player, blockHash, shaPlayer);
342     else if (betType==BetTypes.column) checkBetColumn(result, player, blockHash, shaPlayer);
343   }
344 
345   // function solve Bet once result is determined : sends to winner, adds loss to profit
346   function solveBet(address player, uint8 result, bool win, uint8 multiplier, bytes32 blockHash, bytes32 shaPlayer) private
347   {
348     //Update status and record spinned
349     playerStatus[player]=Status.waitingForBet;
350     gambles[gambleIndex[player]].wheelResult=result;
351     gambles[gambleIndex[player]].spinned=true;
352     gambles[gambleIndex[player]].blockSpinned=block.number;
353     uint bet_v = gambles[gambleIndex[player]].wager;
354 	
355     if (win)
356       {
357 	gambles[gambleIndex[player]].win=true;
358 	uint win_v = (multiplier-1)*bet_v;
359 	Win(player, result, win_v, blockHash, shaPlayer, gambleIndex[player], bet_v);
360 	//send win!
361 	//safe send vs potential callstack overflowed spins
362 	if (player.send(win_v+bet_v)==false) throw;
363       }
364     else
365       {
366 	Loss(player, result, bet_v-1, blockHash, shaPlayer, gambleIndex[player], bet_v);
367 	//send 1 wei to confirm spin if loss
368 	if (player.send(1)==false) throw;
369       }
370 
371   }
372 
373   // checkbeton number(input)
374   // bet type : number
375   // input : chosen number
376   function checkBetNumber(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
377   {
378     bool win;
379     //win
380     if (result==gambles[gambleIndex[player]].input)
381       {
382 	win=true;  
383       }
384     solveBet(player, result,win,36, blockHash, shaPlayer);
385   }
386 
387 
388   // checkbet on oddeven
389   // bet type : parity
390   // input : 0 for even, 1 for odd
391   function checkBetParity(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
392   {
393     bool win;
394     //win
395     if (result%2==gambles[gambleIndex[player]].input && result!=0)
396       {
397 	win=true;                
398       }
399     solveBet(player,result,win,2, blockHash, shaPlayer);
400   }
401     
402   // checkbet on lowhigh
403   // bet type : lowhigh
404   // input : 0 low, 1 high
405   function checkBetLowhigh(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
406   {
407     bool win;
408     //win
409     if (result!=0 && ( (result<19 && gambles[gambleIndex[player]].input==0)
410 		       || (result>18 && gambles[gambleIndex[player]].input==1)
411 		       ) )
412       {
413 	win=true;
414       }
415     solveBet(player,result,win,2, blockHash, shaPlayer);
416   }
417 
418   // checkbet on color
419   // bet type : color
420   // input : 0 red, 1 black
421   uint[18] red_list=[1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36];
422   function checkBetColor(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
423   {
424     bool red;
425     //check if red
426     for (uint8 k; k<18; k++)
427       { 
428 	if (red_list[k]==result) 
429 	  { 
430 	    red=true; 
431 	    break;
432 	  }
433       }
434     bool win;
435     //win
436     if ( result!=0
437 	 && ( (gambles[gambleIndex[player]].input==0 && red)  
438 	      || ( gambles[gambleIndex[player]].input==1 && !red)  ) )
439       {
440 	win=true;
441       }
442     solveBet(player,result,win,2, blockHash, shaPlayer);
443   }
444 
445   // checkbet on dozen
446   // bet type : dozen
447   // input : 0 first, 1 second, 2 third
448   function checkBetDozen(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
449   { 
450     bool win;
451     //win on first dozen
452     if ( result!=0 &&
453 	 ( (result<13 && gambles[gambleIndex[player]].input==0)
454 	   ||
455 	   (result>12 && result<25 && gambles[gambleIndex[player]].input==1)
456 	   ||
457 	   (result>24 && gambles[gambleIndex[player]].input==2) ) )
458       {
459 	win=true;                
460       }
461     solveBet(player,result,win,3, blockHash, shaPlayer);
462   }
463 
464   // checkbet on column
465   // bet type : column
466   // input : 0 first, 1 second, 2 third
467   function checkBetColumn(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
468   {
469     bool win;
470     //win
471     if ( result!=0
472 	 && ( (gambles[gambleIndex[player]].input==0 && result%3==1)  
473 	      || ( gambles[gambleIndex[player]].input==1 && result%3==2)
474 	      || ( gambles[gambleIndex[player]].input==2 && result%3==0)  ) )
475       {
476 	win=true;
477       }
478     solveBet(player,result,win,3, blockHash, shaPlayer);
479   }
480 
481 
482   function checkMyBet(address player) constant returns(Status player_status, BetTypes bettype, uint8 input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb, uint blockSpin, uint gambleID)
483   {
484     player_status=playerStatus[player];
485     bettype=gambles[gambleIndex[player]].betType;
486     input=gambles[gambleIndex[player]].input;
487     value=gambles[gambleIndex[player]].wager;
488     result=gambles[gambleIndex[player]].wheelResult;
489     wheelspinned=gambles[gambleIndex[player]].spinned;
490     win=gambles[gambleIndex[player]].win;
491     blockNb=gambles[gambleIndex[player]].blockNumber;
492     blockSpin=gambles[gambleIndex[player]].blockSpinned;
493     gambleID=gambleIndex[player];
494     return;
495   }
496     
497   function getGamblesList(uint256 index) constant returns(address player, BetTypes bettype, uint8 input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb, uint blockSpin)
498   {
499     player=gambles[index].player;
500     bettype=gambles[index].betType;
501     input=gambles[index].input;
502     value=gambles[index].wager;
503     result=gambles[index].wheelResult;
504     wheelspinned=gambles[index].spinned;
505     win=gambles[index].win;
506     blockNb=gambles[index].blockNumber;
507     blockSpin=gambles[index].blockSpinned;
508     return;
509   }
510 
511 } //end of contract