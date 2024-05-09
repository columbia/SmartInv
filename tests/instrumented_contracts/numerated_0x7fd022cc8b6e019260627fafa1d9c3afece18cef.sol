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
11 //   The ROULETH 
12 //
13 //  Play the Roulette on ethereum blockchain !
14 //  (or become an investor in the Casino and share the profits/losses.) 
15 //
16 //
17 //   website : www.WhySoS3rious.com/Rouleth
18 //               with a flashy roulette :) !
19 //
20 // *** coded by WhySoS3rious, 2016.                                       ***//
21 // *** please do not copy without authorization                          ***//
22 // *** contact : reddit    /u/WhySoS3rious                               ***//
23 //
24 //
25 //  Stake : Variable, check on website for the max bet.
26 //  At launch the max stake is 0.05 ETH
27 //
28 //
29 //  How to play ?
30 //  1) Simplest (via transactions from your wallet, not an exchange) : 
31 //  Just send the value you want to bet to the contract and add enough gas 
32 //  (you can enter the max gas amount of ~4,5Million, any excess is refunded anyways)
33 //  This will by default place a bet on number 7
34 //  Wait 2 minutes (6 blocks) and send (with enough gas) 1 wei (or any amount, it will be refunded)
35 //  This will spin the wheel and you will receive * 35 your bet if you win.
36 //  Don't wait more than 200 blocks before you spin the wheel or your bet will expire.
37 //
38 //  2) Advanced (via contract functions, e.g. Mist, cf. tutorial on my website for more details) :
39 //  Import the contract in Mist wallet using the code of the ABI (link on my website)
40 //  Use the functions (betOnNumber, betOnColor ...) to place any type of bet you want
41 //  Provide the appropriate input (ex: check box Red or Black)
42 //  add the amount you want to bet.
43 //  wait 6 blocks, then use the function spinTheWheel, this will solve the bet.
44 //  You can only place one bet at a time before you spin the wheel.
45 //  Don't wait more than 200 blocks before you spin the wheel or your bet will expire.
46 //
47 //
48 //
49 //  Use the website to track your bets and the results of the spins
50 //
51 //
52 //   How to invest ?
53 //   Import the contract in Mist Wallet using the code of the ABI (link on my website)
54 //   Use the Invest function with an amount >10 Ether (can change, check on my website)
55 //   You will become an investor and share the profits and losses of the roulette
56 //   proportionally to your investment. There is a 2% fee on investment to help with the server/website
57 //   cost and also 2% on profit that go to the developper.
58 //   The rest of your investment goes directly to the payroll and 98% of profits are shared between 
59 //   investors relatively to their share of total. Losses are split similarly.
60 //   You can withdraw your funds at any time after the initial lock period (set to 1 week)
61 //   To withdraw use the function withdraw and specify the amoutn you want to withdraw in Wei.
62 //   If your withdraw brings your investment under 10 eth (the min invest, subject to change)
63 //   then you will execute a full withdraw and stop being an investor.
64 //   Check your current investor balance in Mist by using the information functions on the left side
65 //   If you want to update the balances to the last state (otherwise they are automatically
66 //   updated after each invest or withdraw), you can use the function manualUpdateBalances in Mist.
67 //   
68 //   The casino should be profitable in the long run (with 99% confidence). 
69 //   The maximum bet allowed has been computed through statistical analysis to yield high confidence 
70 //   in the long run survival of the casino. The maximum bet is always smaller than the current payroll 
71 //   of the casino * 35 (max pay multiplier) * casinoStatisticalLimit (statistical sample size that allows 
72 //   to have enough confidence in survival, set at 20 at start, should increase to 200 when we have more 
73 //   investors to increase the safety).
74 //   
75 //   At start there is a limit of 50 investors (can be changed via settings up to 150)
76 //   If there is no open position and you want to invest, you can try to buyout a current investor.
77 //   To buyout, you have to invest more than any investor whose funds are unlocked (after 1 week grace lock period)
78 //   If there are no remaining open position and all investors are under grace period, it is not possible to 
79 //   become a new investor in the casino.
80 //
81 //   At any time an investor can add funds to his investment with the withdraw function.
82 //   Doing so will refresh the lock period and secure your position.
83 //
84 //
85 //   A provably fair roulette :  note on Random Number Generation.
86 //   The roulette result is based on the hash of the 6th block after the player commits his bet.
87 //   This guarantees a provably fair roulette with equiprobable results and non predictable
88 //   unless someone has more computing power than all the Ethereum Network.
89 //   Yet Miners could try to exploit their position in 2 ways.
90 //   First they could try to mine 7 blocks in a row (to commit their bet based on result for a sure win),
91 //   but this is highly improbable and not predictible.
92 //   Second they could commit a bet, then wait 6 blocks and hope that they will be the one forming the 
93 //   block on which their commited bet depends. If this is the case and the hash they find is not a
94 //   winning one, they could decide to not share the block with the network but would lose 5 ether.
95 //   To counter this potential miner edge (=base win proba + (miner proba to find block)*base win proba )
96 //   we keep wager amounts far smaller than 5 Eth so that the miner prefers to get his block reward than cheat.
97 //   Note that a miner could place several bets on the same block to increase his potential profit from dropping a block
98 //   For this reason we limit the number of bets per block to 2 at start (configurable later if needed).
99 contract Rouleth
100 {
101 
102     //Variables, Structure
103     address developer;
104     uint8 blockDelay; //nb of blocks to wait before spin
105     uint8 blockExpiration; //nb of blocks before bet expiration (due to hash storage limits)
106     uint256 maxGamble; //max gamble value manually set by config
107     uint maxBetsPerBlock; //limits the number of bets per blocks to prevent miner cheating
108     uint nbBetsCurrentBlock; //counts the nb of bets in the block
109     uint casinoStatisticalLimit;
110     //Current gamble value possibly lower than config (<payroll/(20*35))
111     uint256 currentMaxGamble; 
112     //Gambles
113     struct Gamble
114     {
115 	address player;
116         bool spinned; //Was the rouleth spinned ?
117 	bool win;
118 	BetTypes betType; //number/color/dozen/oddeven
119 	uint8 input; //stores number, color, dozen or oddeven
120 	uint256 wager;
121 	uint256 blockNumber; //block of bet -1
122         uint8 wheelResult;
123     }
124     Gamble[] private gambles;
125     uint firstActiveGamble; //pointer to track the first non spinned and non expired gamble.
126     //Tracking progress of players
127     mapping (address=>uint) gambleIndex; //current gamble index of the player
128     enum Status {waitingForBet, waitingForSpin} Status status; //gamble status
129     mapping (address=>Status) playerStatus; //progress of the player's gamble
130 
131     //**********************************************
132     //        Management & Config FUNCTIONS        //
133     //**********************************************
134 	function  Rouleth() private //creation settings
135     { 
136         developer = msg.sender;
137         blockDelay=6; //delay to wait between bet and spin
138 	blockExpiration=200; //delay after which gamble expires
139         maxGamble=50 finney; //0.05 ether as max bet to start (payroll of 35 eth)
140         maxBetsPerBlock=2; // limit of 2 bets per block, to prevent multiple bets per miners (to keep max reward<5ETH)
141         casinoStatisticalLimit=20;
142     }
143 	
144     modifier onlyDeveloper() {
145 	    if (msg.sender!=developer) throw;
146 	    _
147     }
148 	
149 	function changeDeveloper(address new_dev)
150         noEthSent
151 	    onlyDeveloper
152 	{
153 		developer=new_dev;
154 	}
155 
156 
157     //Activate, Deactivate Betting
158     enum States{active, inactive} States private state;
159 	function disableBetting()
160     noEthSent
161 	onlyDeveloper
162 	{
163             state=States.inactive;
164 	}
165 	function enableBetting()
166 	onlyDeveloper
167         noEthSent
168 	{
169             state=States.active;
170 	}
171     
172 	modifier onlyActive
173     {
174         if (state==States.inactive) throw;
175         _
176     }
177 
178          //Change some settings within safety bounds
179 	function changeSettings(uint newCasinoStatLimit, uint newMaxBetsBlock, uint256 newMaxGamble, uint8 newMaxInvestor, uint256 newMinInvestment, uint256 newLockPeriod, uint8 newBlockDelay, uint8 newBlockExpiration)
180 	noEthSent
181 	onlyDeveloper
182 	{
183 	        // changes the statistical multiplier that guarantees the long run casino survival
184 	        if (newCasinoStatLimit<20) throw;
185 	        casinoStatisticalLimit=newCasinoStatLimit;
186 	        //Max number of bets per block to prevent miner cheating
187 	        maxBetsPerBlock=newMaxBetsBlock;
188                 //MAX BET : limited by payroll/(casinoStatisticalLimit*35) for statiscal confidence in longevity of casino
189 		if (newMaxGamble<=0 || newMaxGamble>=this.balance/(20*35)) throw; 
190 		else { maxGamble=newMaxGamble; }
191                 //MAX NB of INVESTORS (can only increase and max of 149)
192                 if (newMaxInvestor<setting_maxInvestors || newMaxInvestor>149) throw;
193                 else { setting_maxInvestors=newMaxInvestor;}
194                 //MIN INVEST : 
195                 setting_minInvestment=newMinInvestment;
196                 //Invest LOCK PERIOD
197                 if (setting_lockPeriod>5184000) throw; //2 months max
198                 setting_lockPeriod=newLockPeriod;
199 		        //Delay before roll :
200 		if (blockDelay<1) throw;
201 		        blockDelay=newBlockDelay;
202                 updateMaxBet();
203 		if (newBlockExpiration<100) throw;
204 		blockExpiration=newBlockExpiration;
205 	}
206  
207 
208     //**********************************************
209     //                 BETTING FUNCTIONS                    //
210     //**********************************************
211 
212 //***//basic betting without Mist or contract call
213     //activates when the player only sends eth to the contract
214     //without specifying any type of bet.
215     function () 
216    {
217        //if player is not playing : bet on 7
218        if (playerStatus[msg.sender]==Status.waitingForBet)  betOnNumber(7);
219        //if player is already playing, spin the wheel
220        else spinTheWheel();
221     } 
222 
223     function updateMaxBet() private
224     {
225     //check that maxGamble setting is still within safety bounds
226         if (payroll/(casinoStatisticalLimit*35) > maxGamble) 
227 		{ 
228 			currentMaxGamble=maxGamble;
229                 }
230 	else
231 		{ 
232 			currentMaxGamble = payroll/(20*35);
233 		}
234      }
235 
236 //***//Guarantees that gamble is under (statistical) safety limits for casino survival.
237     function checkBetValue() private returns(uint256 playerBetValue)
238     {
239         updateMaxBet();
240 		if (msg.value > currentMaxGamble) //if above max, send difference back
241 		{
242 		    msg.sender.send(msg.value-currentMaxGamble);
243 		    playerBetValue=currentMaxGamble;
244 		}
245                 else
246                 { playerBetValue=msg.value; }
247        }
248 
249 
250     //check number of bets in block (to prevent miner cheating and keep max reward per block <5ETH)
251     modifier checkNbBetsCurrentBlock()
252     {
253         if (gambles.length!=0 && block.number==gambles[gambles.length-1].blockNumber) nbBetsCurrentBlock+=1;
254         else nbBetsCurrentBlock=0;
255         if (nbBetsCurrentBlock>=maxBetsPerBlock) throw;
256         _
257     }
258     //check that the player is not playing already (unless it has expired)
259     modifier checkWaitingForBet{
260         //if player is already in gamble
261         if (playerStatus[msg.sender]!=Status.waitingForBet)
262         {
263              //case not expired
264              if (gambles[gambleIndex[msg.sender]].blockNumber+blockExpiration>block.number) throw;
265              //case expired
266              else
267              {
268                   //add bet to PL and reset status
269                   solveBet(msg.sender, 255, false, 0) ;
270 
271               }
272         }
273 	_
274 	}
275 
276     //Possible bet types
277     enum BetTypes{ number, color, parity, dozen, column, lowhigh} BetTypes private initbetTypes;
278 
279     function updateStatusPlayer() private
280     expireGambles
281     {
282 	playerStatus[msg.sender]=Status.waitingForSpin;
283 	gambleIndex[msg.sender]=gambles.length-1;
284      }
285 
286 //***//bet on Number	
287     function betOnNumber(uint8 numberChosen)
288     checkWaitingForBet
289     onlyActive
290     checkNbBetsCurrentBlock
291     {
292         //check that number chosen is valid and records bet
293         if (numberChosen>36) throw;
294 		//check that wager is under limit
295         uint256 betValue= checkBetValue();
296 	    gambles.push(Gamble(msg.sender, false, false, BetTypes.number, numberChosen, betValue, block.number, 37));
297         updateStatusPlayer();
298     }
299 
300 //***// function betOnColor
301 	//bet type : color
302 	//input : 0 for red
303 	//input : 1 for black
304     function betOnColor(bool Red, bool Black)
305     checkWaitingForBet
306     onlyActive
307     checkNbBetsCurrentBlock
308     {
309         uint8 count;
310         uint8 input;
311         if (Red) 
312         { 
313              count+=1; 
314              input=0;
315          }
316         if (Black) 
317         {
318              count+=1; 
319              input=1;
320          }
321         if (count!=1) throw;
322 	//check that wager is under limit
323         uint256 betValue= checkBetValue();
324 	    gambles.push(Gamble(msg.sender, false, false, BetTypes.color, input, betValue, block.number, 37));
325         updateStatusPlayer();
326     }
327 
328 //***// function betOnLow_High
329 	//bet type : lowhigh
330 	//input : 0 for low
331 	//input : 1 for low
332     function betOnLowHigh(bool Low, bool High)
333     checkWaitingForBet
334     onlyActive
335     checkNbBetsCurrentBlock
336     {
337         uint8 count;
338         uint8 input;
339         if (Low) 
340         { 
341              count+=1; 
342              input=0;
343          }
344         if (High) 
345         {
346              count+=1; 
347              input=1;
348          }
349         if (count!=1) throw;
350 	//check that wager is under limit
351         uint256 betValue= checkBetValue();
352 	gambles.push(Gamble(msg.sender, false, false, BetTypes.lowhigh, input, betValue, block.number, 37));
353         updateStatusPlayer();
354     }
355 
356 //***// function betOnOdd_Even
357 	//bet type : parity
358      //input : 0 for even
359     //input : 1 for odd
360     function betOnOddEven(bool Odd, bool Even)
361     checkWaitingForBet
362     onlyActive
363     checkNbBetsCurrentBlock
364     {
365         uint8 count;
366         uint8 input;
367         if (Even) 
368         { 
369              count+=1; 
370              input=0;
371          }
372         if (Odd) 
373         {
374              count+=1; 
375              input=1;
376          }
377         if (count!=1) throw;
378 	//check that wager is under limit
379         uint256 betValue= checkBetValue();
380 	gambles.push(Gamble(msg.sender, false, false, BetTypes.parity, input, betValue, block.number, 37));
381         updateStatusPlayer();
382     }
383 
384 
385 //***// function betOnDozen
386 //     //bet type : dozen
387 //     //input : 0 for first dozen
388 //     //input : 1 for second dozen
389 //     //input : 2 for third dozen
390     function betOnDozen(bool First, bool Second, bool Third)
391     checkWaitingForBet
392     onlyActive
393     checkNbBetsCurrentBlock
394     {
395          betOnColumnOrDozen(First,Second,Third, BetTypes.dozen);
396     }
397 
398 
399 // //***// function betOnColumn
400 //     //bet type : column
401 //     //input : 0 for first column
402 //     //input : 1 for second column
403 //     //input : 2 for third column
404     function betOnColumn(bool First, bool Second, bool Third)
405     checkWaitingForBet
406     onlyActive
407     checkNbBetsCurrentBlock
408     {
409          betOnColumnOrDozen(First, Second, Third, BetTypes.column);
410      }
411 
412     function betOnColumnOrDozen(bool First, bool Second, bool Third, BetTypes bet) private
413     { 
414         uint8 count;
415         uint8 input;
416         if (First) 
417         { 
418              count+=1; 
419              input=0;
420          }
421         if (Second) 
422         {
423              count+=1; 
424              input=1;
425          }
426         if (Third) 
427         {
428              count+=1; 
429              input=2;
430          }
431         if (count!=1) throw;
432 	//check that wager is under limit
433         uint256 betValue= checkBetValue();
434 	    gambles.push(Gamble(msg.sender, false, false, bet, input, betValue, block.number, 37));
435         updateStatusPlayer();
436     }
437 
438     //**********************************************
439     // Spin The Wheel & Check Result FUNCTIONS//
440     //**********************************************
441 
442 	event Win(address player, uint8 result, uint value_won);
443 	event Loss(address player, uint8 result, uint value_loss);
444 
445     //check that player has to spin the wheel
446     modifier checkWaitingForSpin{
447         if (playerStatus[msg.sender]!=Status.waitingForSpin) throw;
448 	_
449 	}
450     //Prevents accidental sending of Eth when you shouldn't
451     modifier noEthSent()
452     {
453         if (msg.value>0) msg.sender.send(msg.value);
454         _
455     }
456 
457 //***//function to spin
458     function spinTheWheel()
459     checkWaitingForSpin
460     noEthSent
461     {
462         //check that the player waited for the delay before spin
463         //and also that the bet is not expired (200 blocks limit)
464 	uint playerblock = gambles[gambleIndex[msg.sender]].blockNumber;
465 	if (block.number<playerblock+blockDelay || block.number>playerblock+blockExpiration) throw;
466     else
467 	{
468 	    uint8 wheelResult;
469         //Spin the wheel, Reset player status and record result
470 		wheelResult = uint8(uint256(block.blockhash(playerblock+blockDelay))%37);
471 		updateFirstActiveGamble(gambleIndex[msg.sender]);
472 		gambles[gambleIndex[msg.sender]].wheelResult=wheelResult;
473         //check result against bet and pay if win
474 		checkBetResult(wheelResult, gambles[gambleIndex[msg.sender]].betType);
475 	}
476     }
477 
478 function updateFirstActiveGamble(uint bet_id) private
479      {
480          if (bet_id==firstActiveGamble)
481          {   
482               uint index=firstActiveGamble;
483               while (true)
484               {
485                  if (index<gambles.length && gambles[index].spinned){
486                      index=index+1;
487                  }
488                  else {break; }
489                }
490               firstActiveGamble=index;
491               return;
492           }
493  }
494 	
495 //checks if there are expired gambles
496 modifier expireGambles{
497     if (  (gambles.length!=0 && gambles.length-1>=firstActiveGamble ) 
498           && gambles[firstActiveGamble].blockNumber + blockExpiration <= block.number && !gambles[firstActiveGamble].spinned )  
499     { 
500 	solveBet(gambles[firstActiveGamble].player, 255, false, 0);
501         updateFirstActiveGamble(firstActiveGamble);
502     }
503         _
504 }
505 	
506 
507      //CHECK BETS FUNCTIONS private
508      function checkBetResult(uint8 result, BetTypes betType) private
509      {
510           //bet on Number
511           if (betType==BetTypes.number) checkBetNumber(result);
512           else if (betType==BetTypes.parity) checkBetParity(result);
513           else if (betType==BetTypes.color) checkBetColor(result);
514 	 else if (betType==BetTypes.lowhigh) checkBetLowhigh(result);
515 	 else if (betType==BetTypes.dozen) checkBetDozen(result);
516 	else if (betType==BetTypes.column) checkBetColumn(result);
517           updateMaxBet(); 
518      }
519 
520      // function solve Bet once result is determined : sends to winner, adds loss to profit
521      function solveBet(address player, uint8 result, bool win, uint8 multiplier) private
522      {
523         playerStatus[msg.sender]=Status.waitingForBet;
524         gambles[gambleIndex[player]].spinned=true;
525 	uint bet_v = gambles[gambleIndex[player]].wager;
526             if (win)
527             {
528 		  gambles[gambleIndex[player]].win=true;
529 		  uint win_v = multiplier*bet_v;
530                   player.send(win_v);
531                   lossSinceChange+=win_v-bet_v;
532 		  Win(player, result, win_v);
533              }
534             else
535             {
536 		Loss(player, result, bet_v);
537                 profitSinceChange+=bet_v;
538             }
539 
540       }
541 
542 
543      // checkbeton number(input)
544     // bet type : number
545     // input : chosen number
546      function checkBetNumber(uint8 result) private
547      {
548             bool win;
549             //win
550 	    if (result==gambles[gambleIndex[msg.sender]].input)
551 	    {
552                   win=true;  
553              }
554              solveBet(msg.sender, result,win,35);
555      }
556 
557 
558      // checkbet on oddeven
559     // bet type : parity
560     // input : 0 for even, 1 for odd
561      function checkBetParity(uint8 result) private
562      {
563             bool win;
564             //win
565 	    if (result%2==gambles[gambleIndex[msg.sender]].input && result!=0)
566 	    {
567                   win=true;                
568              }
569              solveBet(msg.sender,result,win,2);
570         
571      }
572 	
573      // checkbet on lowhigh
574      // bet type : lowhigh
575      // input : 0 low, 1 high
576      function checkBetLowhigh(uint8 result) private
577      {
578             bool win;
579             //win
580 		 if (result!=0 && ( (result<19 && gambles[gambleIndex[msg.sender]].input==0)
581 			 || (result>18 && gambles[gambleIndex[msg.sender]].input==1)
582 			 ) )
583 	    {
584                   win=true;
585              }
586              solveBet(msg.sender,result,win,2);
587      }
588 
589      // checkbet on color
590      // bet type : color
591      // input : 0 red, 1 black
592       uint[18] red_list=[1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36];
593       function checkBetColor(uint8 result) private
594       {
595              bool red;
596              //check if red
597              for (uint8 k; k<18; k++)
598              { 
599                     if (red_list[k]==result) 
600                     { 
601                           red=true; 
602                           break;
603                     }
604              }
605              bool win;
606              //win
607              if ( result!=0
608                 && ( (gambles[gambleIndex[msg.sender]].input==0 && red)  
609                 || ( gambles[gambleIndex[msg.sender]].input==1 && !red)  ) )
610              {
611                   win=true;
612              }
613              solveBet(msg.sender,result,win,2);
614        }
615 
616      // checkbet on dozen
617      // bet type : dozen
618      // input : 0 first, 1 second, 2 third
619      function checkBetDozen(uint8 result) private
620      { 
621             bool win;
622             //win on first dozen
623      		 if ( result!=0 &&
624                       ( (result<13 && gambles[gambleIndex[msg.sender]].input==0)
625      			||
626                      (result>12 && result<25 && gambles[gambleIndex[msg.sender]].input==1)
627                     ||
628                      (result>24 && gambles[gambleIndex[msg.sender]].input==2) ) )
629      	    {
630                    win=true;                
631              }
632              solveBet(msg.sender,result,win,3);
633      }
634 
635      // checkbet on column
636      // bet type : column
637      // input : 0 first, 1 second, 2 third
638       function checkBetColumn(uint8 result) private
639       {
640              bool win;
641              //win
642              if ( result!=0
643                 && ( (gambles[gambleIndex[msg.sender]].input==0 && result%3==1)  
644                 || ( gambles[gambleIndex[msg.sender]].input==1 && result%3==2)
645                 || ( gambles[gambleIndex[msg.sender]].input==2 && result%3==0)  ) )
646              {
647                   win=true;
648              }
649              solveBet(msg.sender,result,win,3);
650       }
651 
652 
653 //INVESTORS FUNCTIONS
654 
655 
656 //total casino payroll
657     uint256 payroll;
658 //Profit Loss since last investor change
659     uint256 profitSinceChange;
660     uint256 lossSinceChange;
661 //investor struct array (hard capped to 150)
662     uint8 setting_maxInvestors = 50;
663     struct Investor
664     {
665 	    address investor;
666 	    uint256 time;
667     }	
668 	Investor[150] private investors ;
669     //Balances of the investors
670     mapping (address=>uint256) balance; 
671     //Investor lockPeriod
672     //lock time to avoid invest and withdraw for refresh only
673     //also time during which you cannot be outbet by a new investor if it is full
674     uint256 setting_lockPeriod=604800 ; //1 week in sec
675     uint256 setting_minInvestment=10 ether; //min amount to send when using invest()
676     //if full and unlocked position, indicates the cheapest amount to outbid
677     //otherwise cheapestUnlockedPosition=255
678     uint8 cheapestUnlockedPosition; 
679     uint256 minCurrentInvest; 
680     //record open position index
681     // =255 if full
682     uint8 openPosition;
683 	
684     event newInvest(address player, uint invest_v);
685 
686 
687      function invest()
688      {
689           // check that min 10 ETH is sent (variable setting)
690           if (msg.value<setting_minInvestment) throw;
691           // check if already investor
692           bool alreadyInvestor;
693           // reset the position counters to values out of bounds
694           openPosition=255;
695           cheapestUnlockedPosition=255;
696           minCurrentInvest=10000000000000000000000000;//
697           // update balances before altering the investor shares
698           updateBalances();
699           // loop over investor's array to find if already investor, 
700           // or openPosition and cheapest UnlockedPosition
701           for (uint8 k = 0; k<setting_maxInvestors; k++)
702           { 
703                //captures an index of an open position
704                if (investors[k].investor==0) openPosition=k; 
705                //captures if already an investor 
706                else if (investors[k].investor==msg.sender)
707                {
708                     investors[k].time=now; //refresh time invest
709                     alreadyInvestor=true;
710                 }
711                //captures the index of the investor with the min investment (after lock period)
712                else if (investors[k].time+setting_lockPeriod<now && balance[investors[k].investor]<minCurrentInvest && investors[k].investor!=developer)
713                {
714                     cheapestUnlockedPosition=k;
715                     minCurrentInvest=balance[investors[k].investor];
716                 }
717            }
718            //case New investor
719            if (alreadyInvestor==false)
720            {
721                     //case : investor array not full, record new investor
722                     if (openPosition!=255) investors[openPosition]=Investor(msg.sender, now);
723                     //case : investor array full
724                     else
725                     {
726                          //subcase : investor has not outbid or all positions under lock period
727                          if (msg.value<=minCurrentInvest || cheapestUnlockedPosition==255) throw;
728                          //subcase : investor outbid, record investor change and refund previous
729                          else
730                          {
731                               address previous = investors[cheapestUnlockedPosition].investor;
732                               if (previous.send(balance[previous])==false) throw;
733                               balance[previous]=0;
734                               investors[cheapestUnlockedPosition]=Investor(msg.sender, now);
735                           }
736                      }
737             }
738           //add investment to balance of investor and to payroll
739 
740           uint256 maintenanceFees=2*msg.value/100; //2% maintenance fees
741           uint256 netInvest=msg.value - maintenanceFees;
742           newInvest(msg.sender, netInvest);
743           balance[msg.sender]+=netInvest; //add invest to balance
744           payroll+=netInvest;
745           //send maintenance fees to developer 
746           if (developer.send(maintenanceFees)==false) throw;
747           updateMaxBet();
748       }
749 
750 //***// Withdraw function (only after lockPeriod)
751     // input : amount to withdraw in Wei (leave empty for full withdraw)
752     // if your withdraw brings your balance under the min investment required,
753     // your balance is fully withdrawn
754 	event withdraw(address player, uint withdraw_v);
755 	
756     function withdrawInvestment(uint256 amountToWithdrawInWei)
757     noEthSent
758     {
759         //before withdraw, update balances of the investors with the Profit and Loss sinceChange
760         updateBalances();
761 	//check that amount requested is authorized  
762 	if (amountToWithdrawInWei>balance[msg.sender]) throw;
763         //retrieve investor ID
764         uint8 investorID=255;
765         for (uint8 k = 0; k<setting_maxInvestors; k++)
766         {
767                if (investors[k].investor==msg.sender)
768                {
769                     investorID=k;
770                     break;
771                }
772         }
773            if (investorID==255) throw; //stop if not an investor
774            //check if investment lock period is over
775            if (investors[investorID].time+setting_lockPeriod>now) throw;
776            //if balance left after withdraw is still above min investment accept partial withdraw
777            if (balance[msg.sender]-amountToWithdrawInWei>=setting_minInvestment && amountToWithdrawInWei!=0)
778            {
779                balance[msg.sender]-=amountToWithdrawInWei;
780                payroll-=amountToWithdrawInWei;
781                //send amount to investor (with security if transaction fails)
782                if (msg.sender.send(amountToWithdrawInWei)==false) throw;
783 	       withdraw(msg.sender, amountToWithdrawInWei);
784            }
785            else
786            //if amountToWithdraw=0 : user wants full withdraw
787            //if balance after withdraw is < min invest, withdraw all and delete investor
788            {
789                //send amount to investor (with security if transaction fails)
790                uint256 fullAmount=balance[msg.sender];
791                payroll-=fullAmount;
792                balance[msg.sender]=0;
793                if (msg.sender.send(fullAmount)==false) throw;
794                //delete investor
795                delete investors[investorID];
796    	       withdraw(msg.sender, fullAmount);
797             }
798           updateMaxBet();
799      }
800 
801 //***// updates balances with Profit Losses when there is a withdraw/deposit of investors
802 
803 	function manualUpdateBalances()
804 	expireGambles
805 	noEthSent
806 	{
807 	    updateBalances();
808 	}
809     function updateBalances() private
810     {
811          //split Profits
812          uint256 profitToSplit;
813          uint256 lossToSplit;
814          if (profitSinceChange==0 && lossSinceChange==0)
815          { return; }
816          
817          else
818          {
819              // Case : Global profit (more win than losses)
820              // 2% fees for developer on global profit (if profit>loss)
821              if (profitSinceChange>lossSinceChange)
822              {
823                 profitToSplit=profitSinceChange-lossSinceChange;
824                 uint256 developerFees=profitToSplit*2/100;
825                 profitToSplit-=developerFees;
826                 if (developer.send(developerFees)==false) throw;
827              }
828              else
829              {
830                 lossToSplit=lossSinceChange-profitSinceChange;
831              }
832          
833          //share the loss and profits between all invest 
834          //(proportionnaly. to each investor balance)
835          uint totalShared;
836              for (uint8 k=0; k<setting_maxInvestors; k++)
837              {
838                  address inv=investors[k].investor;
839                  if (inv==0) continue;
840                  else
841                  {
842                        if (profitToSplit!=0) 
843                        {
844                            uint profitShare=(profitToSplit*balance[inv])/payroll;
845                            balance[inv]+=profitShare;
846                            totalShared+=profitShare;
847                        }
848                        if (lossToSplit!=0) 
849                        {
850                            uint lossShare=(lossToSplit*balance[inv])/payroll;
851                            balance[inv]-=lossShare;
852                            totalShared+=lossShare;
853                            
854                        }
855                  }
856              }
857           // update payroll
858           if (profitToSplit !=0) 
859           {
860               payroll+=profitToSplit;
861               balance[developer]+=profitToSplit-totalShared;
862           }
863           if (lossToSplit !=0) 
864           {
865               payroll-=lossToSplit;
866               balance[developer]-=lossToSplit-totalShared;
867           }
868           profitSinceChange=0; //reset Profit;
869           lossSinceChange=0; //reset Loss ;
870           
871           }
872      }
873      
874      
875      //INFORMATION FUNCTIONS
876      
877      function checkProfitLossSinceInvestorChange() constant returns(uint profit, uint loss)
878      {
879         profit=profitSinceChange;
880         loss=lossSinceChange;
881         return;
882      }
883 
884     function checkInvestorBalance(address investor) constant returns(uint balanceInWei)
885     {
886           balanceInWei=balance[investor];
887           return;
888      }
889 
890     function getInvestorList(uint index) constant returns(address investor, uint endLockPeriod)
891     {
892           investor=investors[index].investor;
893           endLockPeriod=investors[index].time+setting_lockPeriod;
894           return;
895     }
896 	
897 
898 	function investmentEntryCost() constant returns(bool open_position, bool unlocked_position, uint buyout_amount, uint investLockPeriod)
899 	{
900 		if (openPosition!=255) open_position=true;
901 		if (cheapestUnlockedPosition!=255) 
902 		{
903 			unlocked_position=true;
904 			buyout_amount=minCurrentInvest;
905 		}
906 		investLockPeriod=setting_lockPeriod;
907 		return;
908 	}
909 	
910 	function getSettings() constant returns(uint maxBet, uint8 blockDelayBeforeSpin)
911 	{
912 	    maxBet=currentMaxGamble;
913 	    blockDelayBeforeSpin=blockDelay;
914 	    return ;
915 	}
916 	
917     function checkMyBet(address player) constant returns(Status player_status, BetTypes bettype, uint8 input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb)
918     {
919           player_status=playerStatus[player];
920           bettype=gambles[gambleIndex[player]].betType;
921           input=gambles[gambleIndex[player]].input;
922           value=gambles[gambleIndex[player]].wager;
923           result=gambles[gambleIndex[player]].wheelResult;
924           wheelspinned=gambles[gambleIndex[player]].spinned;
925           win=gambles[gambleIndex[player]].win;
926 		blockNb=gambles[gambleIndex[player]].blockNumber;
927 		  return;
928      }
929 
930 } //end of contract