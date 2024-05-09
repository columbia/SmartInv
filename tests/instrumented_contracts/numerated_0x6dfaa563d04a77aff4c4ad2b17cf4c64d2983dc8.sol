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
20 //   check latest contract version on website
21 //   V 1.0.2
22 //
23 // *** coded by WhySoS3rious, 2016.                                       ***//
24 // *** please do not copy without authorization                          ***//
25 // *** contact : reddit    /u/WhySoS3rious                               ***//
26 //
27 //
28 //  Stake : Variable, check on website for the max bet.
29 //  At launch the max stake is 0.05 ETH
30 //
31 //
32 //  How to play ?
33 //  1) Simplest (via transactions from your wallet, not an exchange) : 
34 //  Just send the value you want to bet to the contract and add enough gas 
35 //  (you can enter the max gas amount of ~4,5Million, any excess is refunded anyways)
36 //  This will by default place a bet on number 7
37 //  Wait 2 minutes (6 blocks) and send (with enough gas) 1 wei (or any amount, it will be refunded)
38 //  This will spin the wheel and you will receive * 35 your bet if you win.
39 //  Don't wait more than 200 blocks before you spin the wheel or your bet will expire.
40 //
41 //  2) Advanced (via contract functions, e.g. Mist, cf. tutorial on my website for more details) :
42 //  Import the contract in Mist wallet using the code of the ABI (link on my website)
43 //  Use the functions (betOnNumber, betOnColor ...) to place any type of bet you want
44 //  Provide the appropriate input (ex: check box Red or Black)
45 //  add the amount you want to bet.
46 //  wait 6 blocks, then use the function spinTheWheel, this will solve the bet.
47 //  You can only place one bet at a time before you spin the wheel.
48 //  Don't wait more than 200 blocks before you spin the wheel or your bet will expire.
49 //
50 //
51 //
52 //  Use the website to track your bets and the results of the spins
53 //
54 //
55 //   How to invest ?
56 //   Import the contract in Mist Wallet using the code of the ABI (link on my website)
57 //   Use the Invest function with an amount >10 Ether (can change, check on my website)
58 //   You will become an investor and share the profits and losses of the roulette
59 //   proportionally to your investment. There is a 2% fee on investment to help with the server/website
60 //   cost and also 2% on profit that go to the developper.
61 //   The rest of your investment goes directly to the payroll and 98% of profits are shared between 
62 //   investors relatively to their share of total. Losses are split similarly.
63 //   You can withdraw your funds at any time after the initial lock period (set to 1 week)
64 //   To withdraw use the function withdraw and specify the amoutn you want to withdraw in Wei.
65 //   If your withdraw brings your investment under 10 eth (the min invest, subject to change)
66 //   then you will execute a full withdraw and stop being an investor.
67 //   Check your current investor balance in Mist by using the information functions on the left side
68 //   If you want to update the balances to the last state (otherwise they are automatically
69 //   updated after each invest or withdraw), you can use the function manualUpdateBalances in Mist.
70 //   
71 //   The casino should be profitable in the long run (with 99% confidence). 
72 //   The maximum bet allowed has been computed through statistical analysis to yield high confidence 
73 //   in the long run survival of the casino. The maximum bet is always smaller than the current payroll 
74 //   of the casino * 35 (max pay multiplier) * casinoStatisticalLimit (statistical sample size that allows 
75 //   to have enough confidence in survival, set at 20 at start, should increase to 200 when we have more 
76 //   investors to increase the safety).
77 //   
78 //   At start there is a limit of 50 investors (can be changed via settings up to 150)
79 //   If there is no open position and you want to invest, you can try to buyout a current investor.
80 //   To buyout, you have to invest more than any investor whose funds are unlocked (after 1 week grace lock period)
81 //   If there are no remaining open position and all investors are under grace period, it is not possible to 
82 //   become a new investor in the casino.
83 //
84 //   At any time an investor can add funds to his investment with the withdraw function.
85 //   Doing so will refresh the lock period and secure your position.
86 //
87 //
88 //   A provably fair roulette :  note on Random Number Generation.
89 //   The roulette result is based on the hash of the 6th block after the player commits his bet.
90 //   This guarantees a provably fair roulette with equiprobable results and non predictable
91 //   unless someone has more computing power than all the Ethereum Network.
92 //   Yet Miners could try to exploit their position in 2 ways.
93 //   First they could try to mine 7 blocks in a row (to commit their bet based on result for a sure win),
94 //   but this is highly improbable and not predictible.
95 //   Second they could commit a bet, then wait 6 blocks and hope that they will be the one forming the 
96 //   block on which their commited bet depends. If this is the case and the hash they find is not a
97 //   winning one, they could decide to not share the block with the network but would lose 5 ether.
98 //   To counter this potential miner edge (=base win proba + (miner proba to find block)*base win proba )
99 //   we keep wager amounts far smaller than 5 Eth so that the miner prefers to get his block reward than cheat.
100 //   Note that a miner could place several bets on the same block to increase his potential profit from dropping a block
101 //   For this reason we limit the number of bets per block to 2 at start (configurable later if needed).
102 contract Rouleth
103 {
104 
105     //Variables, Structure
106     address developer;
107     uint8 blockDelay; //nb of blocks to wait before spin
108     uint8 blockExpiration; //nb of blocks before bet expiration (due to hash storage limits)
109     uint256 maxGamble; //max gamble value manually set by config
110     uint maxBetsPerBlock; //limits the number of bets per blocks to prevent miner cheating
111     uint nbBetsCurrentBlock; //counts the nb of bets in the block
112     uint casinoStatisticalLimit;
113     //Current gamble value possibly lower than config (<payroll/(20*35))
114     uint256 currentMaxGamble; 
115     //Gambles
116     struct Gamble
117     {
118 	address player;
119         bool spinned; //Was the rouleth spinned ?
120 	bool win;
121 	BetTypes betType; //number/color/dozen/oddeven
122 	uint8 input; //stores number, color, dozen or oddeven
123 	uint256 wager;
124 	uint256 blockNumber; //block of bet -1
125         uint8 wheelResult;
126     }
127     Gamble[] private gambles;
128     uint firstActiveGamble; //pointer to track the first non spinned and non expired gamble.
129     //Tracking progress of players
130     mapping (address=>uint) gambleIndex; //current gamble index of the player
131     enum Status {waitingForBet, waitingForSpin} Status status; //gamble status
132     mapping (address=>Status) playerStatus; //progress of the player's gamble
133 
134     //**********************************************
135     //        Management & Config FUNCTIONS        //
136     //**********************************************
137 	function  Rouleth() private //creation settings
138     { 
139         developer = msg.sender;
140         blockDelay=6; //delay to wait between bet and spin
141 	blockExpiration=200; //delay after which gamble expires
142         maxGamble=50 finney; //0.05 ether as max bet to start (payroll of 35 eth)
143         maxBetsPerBlock=2; // limit of 2 bets per block, to prevent multiple bets per miners (to keep max reward<5ETH)
144         casinoStatisticalLimit=20;
145     }
146 	
147     modifier onlyDeveloper() {
148 	    if (msg.sender!=developer) throw;
149 	    _
150     }
151 	
152 	function changeDeveloper(address new_dev)
153         noEthSent
154 	    onlyDeveloper
155 	{
156 		developer=new_dev;
157 	}
158 
159 
160     //Activate, Deactivate Betting
161     enum States{active, inactive} States private state;
162 	function disableBetting()
163     noEthSent
164 	onlyDeveloper
165 	{
166             state=States.inactive;
167 	}
168 	function enableBetting()
169 	onlyDeveloper
170         noEthSent
171 	{
172             state=States.active;
173 	}
174     
175 	modifier onlyActive
176     {
177         if (state==States.inactive) throw;
178         _
179     }
180 
181          //Change some settings within safety bounds
182 	function changeSettings(uint newCasinoStatLimit, uint newMaxBetsBlock, uint256 newMaxGamble, uint8 newMaxInvestor, uint256 newMinInvestment, uint256 newLockPeriod, uint8 newBlockDelay, uint8 newBlockExpiration)
183 	noEthSent
184 	onlyDeveloper
185 	{
186 	        // changes the statistical multiplier that guarantees the long run casino survival
187 	        if (newCasinoStatLimit<20) throw;
188 	        casinoStatisticalLimit=newCasinoStatLimit;
189 	        //Max number of bets per block to prevent miner cheating
190 	        maxBetsPerBlock=newMaxBetsBlock;
191                 //MAX BET : limited by payroll/(casinoStatisticalLimit*35) for statiscal confidence in longevity of casino
192 		if (newMaxGamble<=0 || newMaxGamble>=this.balance/(20*35)) throw; 
193 		else { maxGamble=newMaxGamble; }
194                 //MAX NB of INVESTORS (can only increase and max of 149)
195                 if (newMaxInvestor<setting_maxInvestors || newMaxInvestor>149) throw;
196                 else { setting_maxInvestors=newMaxInvestor;}
197                 //MIN INVEST : 
198                 setting_minInvestment=newMinInvestment;
199                 //Invest LOCK PERIOD
200                 if (setting_lockPeriod>5184000) throw; //2 months max
201                 setting_lockPeriod=newLockPeriod;
202 		        //Delay before roll :
203 		if (blockDelay<1) throw;
204 		        blockDelay=newBlockDelay;
205                 updateMaxBet();
206 		if (newBlockExpiration<100) throw;
207 		blockExpiration=newBlockExpiration;
208 	}
209  
210 
211     //**********************************************
212     //                 BETTING FUNCTIONS                    //
213     //**********************************************
214 
215 //***//basic betting without Mist or contract call
216     //activates when the player only sends eth to the contract
217     //without specifying any type of bet.
218     function () 
219    {
220        //if player is not playing : bet on 7
221        if (playerStatus[msg.sender]==Status.waitingForBet)  betOnNumber(7);
222        //if player is already playing, spin the wheel
223        else spinTheWheel();
224     } 
225 
226     function updateMaxBet() private
227     {
228     //check that maxGamble setting is still within safety bounds
229         if (payroll/(casinoStatisticalLimit*35) > maxGamble) 
230 		{ 
231 			currentMaxGamble=maxGamble;
232                 }
233 	else
234 		{ 
235 			currentMaxGamble = payroll/(20*35);
236 		}
237      }
238 
239 //***//Guarantees that gamble is under (statistical) safety limits for casino survival.
240     function checkBetValue() private returns(uint256 playerBetValue)
241     {
242         updateMaxBet();
243 		if (msg.value > currentMaxGamble) //if above max, send difference back
244 		{
245 		    msg.sender.send(msg.value-currentMaxGamble);
246 		    playerBetValue=currentMaxGamble;
247 		}
248                 else
249                 { playerBetValue=msg.value; }
250        }
251 
252 
253     //check number of bets in block (to prevent miner cheating and keep max reward per block <5ETH)
254     modifier checkNbBetsCurrentBlock()
255     {
256         if (gambles.length!=0 && block.number==gambles[gambles.length-1].blockNumber) nbBetsCurrentBlock+=1;
257         else nbBetsCurrentBlock=0;
258         if (nbBetsCurrentBlock>=maxBetsPerBlock) throw;
259         _
260     }
261     //check that the player is not playing already (unless it has expired)
262     modifier checkWaitingForBet{
263         //if player is already in gamble
264         if (playerStatus[msg.sender]!=Status.waitingForBet)
265         {
266              //case not expired
267              if (gambles[gambleIndex[msg.sender]].blockNumber+blockExpiration>block.number) throw;
268              //case expired
269              else
270              {
271                   //add bet to PL and reset status
272                   solveBet(msg.sender, 255, false, 0) ;
273 
274               }
275         }
276 	_
277 	}
278 
279     //Possible bet types
280     enum BetTypes{ number, color, parity, dozen, column, lowhigh} BetTypes private initbetTypes;
281 
282     function updateStatusPlayer() private
283     expireGambles
284     {
285 	playerStatus[msg.sender]=Status.waitingForSpin;
286 	gambleIndex[msg.sender]=gambles.length-1;
287      }
288 
289 //***//bet on Number	
290     function betOnNumber(uint8 numberChosen)
291     checkWaitingForBet
292     onlyActive
293     checkNbBetsCurrentBlock
294     {
295         //check that number chosen is valid and records bet
296         if (numberChosen>36) throw;
297 		//check that wager is under limit
298         uint256 betValue= checkBetValue();
299 	    gambles.push(Gamble(msg.sender, false, false, BetTypes.number, numberChosen, betValue, block.number, 37));
300         updateStatusPlayer();
301     }
302 
303 //***// function betOnColor
304 	//bet type : color
305 	//input : 0 for red
306 	//input : 1 for black
307     function betOnColor(bool Red, bool Black)
308     checkWaitingForBet
309     onlyActive
310     checkNbBetsCurrentBlock
311     {
312         uint8 count;
313         uint8 input;
314         if (Red) 
315         { 
316              count+=1; 
317              input=0;
318          }
319         if (Black) 
320         {
321              count+=1; 
322              input=1;
323          }
324         if (count!=1) throw;
325 	//check that wager is under limit
326         uint256 betValue= checkBetValue();
327 	    gambles.push(Gamble(msg.sender, false, false, BetTypes.color, input, betValue, block.number, 37));
328         updateStatusPlayer();
329     }
330 
331 //***// function betOnLow_High
332 	//bet type : lowhigh
333 	//input : 0 for low
334 	//input : 1 for low
335     function betOnLowHigh(bool Low, bool High)
336     checkWaitingForBet
337     onlyActive
338     checkNbBetsCurrentBlock
339     {
340         uint8 count;
341         uint8 input;
342         if (Low) 
343         { 
344              count+=1; 
345              input=0;
346          }
347         if (High) 
348         {
349              count+=1; 
350              input=1;
351          }
352         if (count!=1) throw;
353 	//check that wager is under limit
354         uint256 betValue= checkBetValue();
355 	gambles.push(Gamble(msg.sender, false, false, BetTypes.lowhigh, input, betValue, block.number, 37));
356         updateStatusPlayer();
357     }
358 
359 //***// function betOnOdd_Even
360 	//bet type : parity
361      //input : 0 for even
362     //input : 1 for odd
363     function betOnOddEven(bool Odd, bool Even)
364     checkWaitingForBet
365     onlyActive
366     checkNbBetsCurrentBlock
367     {
368         uint8 count;
369         uint8 input;
370         if (Even) 
371         { 
372              count+=1; 
373              input=0;
374          }
375         if (Odd) 
376         {
377              count+=1; 
378              input=1;
379          }
380         if (count!=1) throw;
381 	//check that wager is under limit
382         uint256 betValue= checkBetValue();
383 	gambles.push(Gamble(msg.sender, false, false, BetTypes.parity, input, betValue, block.number, 37));
384         updateStatusPlayer();
385     }
386 
387 
388 //***// function betOnDozen
389 //     //bet type : dozen
390 //     //input : 0 for first dozen
391 //     //input : 1 for second dozen
392 //     //input : 2 for third dozen
393     function betOnDozen(bool First, bool Second, bool Third)
394     checkWaitingForBet
395     onlyActive
396     checkNbBetsCurrentBlock
397     {
398          betOnColumnOrDozen(First,Second,Third, BetTypes.dozen);
399     }
400 
401 
402 // //***// function betOnColumn
403 //     //bet type : column
404 //     //input : 0 for first column
405 //     //input : 1 for second column
406 //     //input : 2 for third column
407     function betOnColumn(bool First, bool Second, bool Third)
408     checkWaitingForBet
409     onlyActive
410     checkNbBetsCurrentBlock
411     {
412          betOnColumnOrDozen(First, Second, Third, BetTypes.column);
413      }
414 
415     function betOnColumnOrDozen(bool First, bool Second, bool Third, BetTypes bet) private
416     { 
417         uint8 count;
418         uint8 input;
419         if (First) 
420         { 
421              count+=1; 
422              input=0;
423          }
424         if (Second) 
425         {
426              count+=1; 
427              input=1;
428          }
429         if (Third) 
430         {
431              count+=1; 
432              input=2;
433          }
434         if (count!=1) throw;
435 	//check that wager is under limit
436         uint256 betValue= checkBetValue();
437 	    gambles.push(Gamble(msg.sender, false, false, bet, input, betValue, block.number, 37));
438         updateStatusPlayer();
439     }
440 
441     //**********************************************
442     // Spin The Wheel & Check Result FUNCTIONS//
443     //**********************************************
444 
445 	event Win(address player, uint8 result, uint value_won);
446 	event Loss(address player, uint8 result, uint value_loss);
447 
448     //check that player has to spin the wheel
449     modifier checkWaitingForSpin{
450         if (playerStatus[msg.sender]!=Status.waitingForSpin) throw;
451 	_
452 	}
453     //Prevents accidental sending of Eth when you shouldn't
454     modifier noEthSent()
455     {
456         if (msg.value>0) msg.sender.send(msg.value);
457         _
458     }
459 
460 //***//function to spin
461     function spinTheWheel()
462     checkWaitingForSpin
463     noEthSent
464     {
465         //check that the player waited for the delay before spin
466         //and also that the bet is not expired (200 blocks limit)
467 	uint playerblock = gambles[gambleIndex[msg.sender]].blockNumber;
468 	if (block.number<playerblock+blockDelay || block.number>playerblock+blockExpiration) throw;
469     else
470 	{
471 	    uint8 wheelResult;
472         //Spin the wheel, Reset player status and record result
473 		wheelResult = uint8(uint256(block.blockhash(playerblock+blockDelay))%37);
474 		gambles[gambleIndex[msg.sender]].wheelResult=wheelResult;
475         //check result against bet and pay if win
476 		checkBetResult(wheelResult, gambles[gambleIndex[msg.sender]].betType);
477 		updateFirstActiveGamble(gambleIndex[msg.sender]);
478 	}
479     }
480 
481 function updateFirstActiveGamble(uint bet_id) private
482      {
483          if (bet_id==firstActiveGamble)
484          {   
485               uint index;
486               if (firstActiveGamble!=0) index=firstActiveGamble-1;
487               while (true)
488               {
489                  if (index<gambles.length && gambles[index].spinned)
490                  {
491                      index=index+1;
492                  }
493                  else {break; }
494                }
495               firstActiveGamble=index;
496               return;
497           }
498  }
499 	
500 //checks if there are expired gambles
501 modifier expireGambles{
502     if (  (gambles.length!=0 && gambles.length-1>=firstActiveGamble ) 
503           && gambles[firstActiveGamble].blockNumber + blockExpiration <= block.number && !gambles[firstActiveGamble].spinned )  
504     { 
505 	solveBet(gambles[firstActiveGamble].player, 255, false, 0);
506         updateFirstActiveGamble(firstActiveGamble);
507     }
508         _
509 }
510 	
511 
512      //CHECK BETS FUNCTIONS private
513      function checkBetResult(uint8 result, BetTypes betType) private
514      {
515           //bet on Number
516           if (betType==BetTypes.number) checkBetNumber(result);
517           else if (betType==BetTypes.parity) checkBetParity(result);
518           else if (betType==BetTypes.color) checkBetColor(result);
519 	 else if (betType==BetTypes.lowhigh) checkBetLowhigh(result);
520 	 else if (betType==BetTypes.dozen) checkBetDozen(result);
521 	else if (betType==BetTypes.column) checkBetColumn(result);
522           updateMaxBet(); 
523      }
524 
525      // function solve Bet once result is determined : sends to winner, adds loss to profit
526      function solveBet(address player, uint8 result, bool win, uint8 multiplier) private
527      {
528         playerStatus[msg.sender]=Status.waitingForBet;
529         gambles[gambleIndex[player]].spinned=true;
530 	uint bet_v = gambles[gambleIndex[player]].wager;
531             if (win)
532             {
533 		  gambles[gambleIndex[player]].win=true;
534 		  uint win_v = multiplier*bet_v;
535                   player.send(win_v);
536                   lossSinceChange+=win_v-bet_v;
537 		  Win(player, result, win_v);
538              }
539             else
540             {
541 		Loss(player, result, bet_v);
542                 profitSinceChange+=bet_v;
543             }
544 
545       }
546 
547 
548      // checkbeton number(input)
549     // bet type : number
550     // input : chosen number
551      function checkBetNumber(uint8 result) private
552      {
553             bool win;
554             //win
555 	    if (result==gambles[gambleIndex[msg.sender]].input)
556 	    {
557                   win=true;  
558              }
559              solveBet(msg.sender, result,win,35);
560      }
561 
562 
563      // checkbet on oddeven
564     // bet type : parity
565     // input : 0 for even, 1 for odd
566      function checkBetParity(uint8 result) private
567      {
568             bool win;
569             //win
570 	    if (result%2==gambles[gambleIndex[msg.sender]].input && result!=0)
571 	    {
572                   win=true;                
573              }
574              solveBet(msg.sender,result,win,2);
575         
576      }
577 	
578      // checkbet on lowhigh
579      // bet type : lowhigh
580      // input : 0 low, 1 high
581      function checkBetLowhigh(uint8 result) private
582      {
583             bool win;
584             //win
585 		 if (result!=0 && ( (result<19 && gambles[gambleIndex[msg.sender]].input==0)
586 			 || (result>18 && gambles[gambleIndex[msg.sender]].input==1)
587 			 ) )
588 	    {
589                   win=true;
590              }
591              solveBet(msg.sender,result,win,2);
592      }
593 
594      // checkbet on color
595      // bet type : color
596      // input : 0 red, 1 black
597       uint[18] red_list=[1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36];
598       function checkBetColor(uint8 result) private
599       {
600              bool red;
601              //check if red
602              for (uint8 k; k<18; k++)
603              { 
604                     if (red_list[k]==result) 
605                     { 
606                           red=true; 
607                           break;
608                     }
609              }
610              bool win;
611              //win
612              if ( result!=0
613                 && ( (gambles[gambleIndex[msg.sender]].input==0 && red)  
614                 || ( gambles[gambleIndex[msg.sender]].input==1 && !red)  ) )
615              {
616                   win=true;
617              }
618              solveBet(msg.sender,result,win,2);
619        }
620 
621      // checkbet on dozen
622      // bet type : dozen
623      // input : 0 first, 1 second, 2 third
624      function checkBetDozen(uint8 result) private
625      { 
626             bool win;
627             //win on first dozen
628      		 if ( result!=0 &&
629                       ( (result<13 && gambles[gambleIndex[msg.sender]].input==0)
630      			||
631                      (result>12 && result<25 && gambles[gambleIndex[msg.sender]].input==1)
632                     ||
633                      (result>24 && gambles[gambleIndex[msg.sender]].input==2) ) )
634      	    {
635                    win=true;                
636              }
637              solveBet(msg.sender,result,win,3);
638      }
639 
640      // checkbet on column
641      // bet type : column
642      // input : 0 first, 1 second, 2 third
643       function checkBetColumn(uint8 result) private
644       {
645              bool win;
646              //win
647              if ( result!=0
648                 && ( (gambles[gambleIndex[msg.sender]].input==0 && result%3==1)  
649                 || ( gambles[gambleIndex[msg.sender]].input==1 && result%3==2)
650                 || ( gambles[gambleIndex[msg.sender]].input==2 && result%3==0)  ) )
651              {
652                   win=true;
653              }
654              solveBet(msg.sender,result,win,3);
655       }
656 
657 
658 //INVESTORS FUNCTIONS
659 
660 
661 //total casino payroll
662     uint256 payroll;
663 //Profit Loss since last investor change
664     uint256 profitSinceChange;
665     uint256 lossSinceChange;
666 //investor struct array (hard capped to 150)
667     uint8 setting_maxInvestors = 50;
668     struct Investor
669     {
670 	    address investor;
671 	    uint256 time;
672     }	
673 	Investor[150] private investors ;
674     //Balances of the investors
675     mapping (address=>uint256) balance; 
676     //Investor lockPeriod
677     //lock time to avoid invest and withdraw for refresh only
678     //also time during which you cannot be outbet by a new investor if it is full
679     uint256 setting_lockPeriod=604800 ; //1 week in sec
680     uint256 setting_minInvestment=10 ether; //min amount to send when using invest()
681     //if full and unlocked position, indicates the cheapest amount to outbid
682     //otherwise cheapestUnlockedPosition=255
683     uint8 cheapestUnlockedPosition; 
684     uint256 minCurrentInvest; 
685     //record open position index
686     // =255 if full
687     uint8 openPosition;
688 	
689     event newInvest(address player, uint invest_v);
690 
691 
692      function invest()
693      {
694           // check that min 10 ETH is sent (variable setting)
695           if (msg.value<setting_minInvestment) throw;
696           // check if already investor
697           bool alreadyInvestor;
698           // reset the position counters to values out of bounds
699           openPosition=255;
700           cheapestUnlockedPosition=255;
701           minCurrentInvest=10000000000000000000000000;//
702           // update balances before altering the investor shares
703           updateBalances();
704           // loop over investor's array to find if already investor, 
705           // or openPosition and cheapest UnlockedPosition
706           for (uint8 k = 0; k<setting_maxInvestors; k++)
707           { 
708                //captures an index of an open position
709                if (investors[k].investor==0) openPosition=k; 
710                //captures if already an investor 
711                else if (investors[k].investor==msg.sender)
712                {
713                     investors[k].time=now; //refresh time invest
714                     alreadyInvestor=true;
715                 }
716                //captures the index of the investor with the min investment (after lock period)
717                else if (investors[k].time+setting_lockPeriod<now && balance[investors[k].investor]<minCurrentInvest && investors[k].investor!=developer)
718                {
719                     cheapestUnlockedPosition=k;
720                     minCurrentInvest=balance[investors[k].investor];
721                 }
722            }
723            //case New investor
724            if (alreadyInvestor==false)
725            {
726                     //case : investor array not full, record new investor
727                     if (openPosition!=255) investors[openPosition]=Investor(msg.sender, now);
728                     //case : investor array full
729                     else
730                     {
731                          //subcase : investor has not outbid or all positions under lock period
732                          if (msg.value<=minCurrentInvest || cheapestUnlockedPosition==255) throw;
733                          //subcase : investor outbid, record investor change and refund previous
734                          else
735                          {
736                               address previous = investors[cheapestUnlockedPosition].investor;
737                               if (previous.send(balance[previous])==false) throw;
738                               balance[previous]=0;
739                               investors[cheapestUnlockedPosition]=Investor(msg.sender, now);
740                           }
741                      }
742             }
743           //add investment to balance of investor and to payroll
744 
745           uint256 maintenanceFees=2*msg.value/100; //2% maintenance fees
746           uint256 netInvest=msg.value - maintenanceFees;
747           newInvest(msg.sender, netInvest);
748           balance[msg.sender]+=netInvest; //add invest to balance
749           payroll+=netInvest;
750           //send maintenance fees to developer 
751           if (developer.send(maintenanceFees)==false) throw;
752           updateMaxBet();
753       }
754 
755 //***// Withdraw function (only after lockPeriod)
756     // input : amount to withdraw in Wei (leave empty for full withdraw)
757     // if your withdraw brings your balance under the min investment required,
758     // your balance is fully withdrawn
759 	event withdraw(address player, uint withdraw_v);
760 	
761     function withdrawInvestment(uint256 amountToWithdrawInWei)
762     noEthSent
763     {
764         //before withdraw, update balances of the investors with the Profit and Loss sinceChange
765         updateBalances();
766 	//check that amount requested is authorized  
767 	if (amountToWithdrawInWei>balance[msg.sender]) throw;
768         //retrieve investor ID
769         uint8 investorID=255;
770         for (uint8 k = 0; k<setting_maxInvestors; k++)
771         {
772                if (investors[k].investor==msg.sender)
773                {
774                     investorID=k;
775                     break;
776                }
777         }
778            if (investorID==255) throw; //stop if not an investor
779            //check if investment lock period is over
780            if (investors[investorID].time+setting_lockPeriod>now) throw;
781            //if balance left after withdraw is still above min investment accept partial withdraw
782            if (balance[msg.sender]-amountToWithdrawInWei>=setting_minInvestment && amountToWithdrawInWei!=0)
783            {
784                balance[msg.sender]-=amountToWithdrawInWei;
785                payroll-=amountToWithdrawInWei;
786                //send amount to investor (with security if transaction fails)
787                if (msg.sender.send(amountToWithdrawInWei)==false) throw;
788 	       withdraw(msg.sender, amountToWithdrawInWei);
789            }
790            else
791            //if amountToWithdraw=0 : user wants full withdraw
792            //if balance after withdraw is < min invest, withdraw all and delete investor
793            {
794                //send amount to investor (with security if transaction fails)
795                uint256 fullAmount=balance[msg.sender];
796                payroll-=fullAmount;
797                balance[msg.sender]=0;
798                if (msg.sender.send(fullAmount)==false) throw;
799                //delete investor
800                delete investors[investorID];
801    	       withdraw(msg.sender, fullAmount);
802             }
803           updateMaxBet();
804      }
805 
806 //***// updates balances with Profit Losses when there is a withdraw/deposit of investors
807 
808 	function manualUpdateBalances()
809 	expireGambles
810 	noEthSent
811 	{
812 	    updateBalances();
813 	}
814     function updateBalances() private
815     {
816          //split Profits
817          uint256 profitToSplit;
818          uint256 lossToSplit;
819          if (profitSinceChange==0 && lossSinceChange==0)
820          { return; }
821          
822          else
823          {
824              // Case : Global profit (more win than losses)
825              // 2% fees for developer on global profit (if profit>loss)
826              if (profitSinceChange>lossSinceChange)
827              {
828                 profitToSplit=profitSinceChange-lossSinceChange;
829                 uint256 developerFees=profitToSplit*2/100;
830                 profitToSplit-=developerFees;
831                 if (developer.send(developerFees)==false) throw;
832              }
833              else
834              {
835                 lossToSplit=lossSinceChange-profitSinceChange;
836              }
837          
838          //share the loss and profits between all invest 
839          //(proportionnaly. to each investor balance)
840          uint totalShared;
841              for (uint8 k=0; k<setting_maxInvestors; k++)
842              {
843                  address inv=investors[k].investor;
844                  if (inv==0) continue;
845                  else
846                  {
847                        if (profitToSplit!=0) 
848                        {
849                            uint profitShare=(profitToSplit*balance[inv])/payroll;
850                            balance[inv]+=profitShare;
851                            totalShared+=profitShare;
852                        }
853                        if (lossToSplit!=0) 
854                        {
855                            uint lossShare=(lossToSplit*balance[inv])/payroll;
856                            balance[inv]-=lossShare;
857                            totalShared+=lossShare;
858                            
859                        }
860                  }
861              }
862           // update payroll
863           if (profitToSplit !=0) 
864           {
865               payroll+=profitToSplit;
866               balance[developer]+=profitToSplit-totalShared;
867           }
868           if (lossToSplit !=0) 
869           {
870               payroll-=lossToSplit;
871               balance[developer]-=lossToSplit-totalShared;
872           }
873           profitSinceChange=0; //reset Profit;
874           lossSinceChange=0; //reset Loss ;
875           
876           }
877      }
878      
879      
880      //INFORMATION FUNCTIONS
881      
882      function checkProfitLossSinceInvestorChange() constant returns(uint profit, uint loss)
883      {
884         profit=profitSinceChange;
885         loss=lossSinceChange;
886         return;
887      }
888 
889     function checkInvestorBalance(address investor) constant returns(uint balanceInWei)
890     {
891           balanceInWei=balance[investor];
892           return;
893      }
894 
895     function getInvestorList(uint index) constant returns(address investor, uint endLockPeriod)
896     {
897           investor=investors[index].investor;
898           endLockPeriod=investors[index].time+setting_lockPeriod;
899           return;
900     }
901 	
902 
903 	function investmentEntryCost() constant returns(bool open_position, bool unlocked_position, uint buyout_amount, uint investLockPeriod)
904 	{
905 		if (openPosition!=255) open_position=true;
906 		if (cheapestUnlockedPosition!=255) 
907 		{
908 			unlocked_position=true;
909 			buyout_amount=minCurrentInvest;
910 		}
911 		investLockPeriod=setting_lockPeriod;
912 		return;
913 	}
914 	
915 	function getSettings() constant returns(uint maxBet, uint8 blockDelayBeforeSpin)
916 	{
917 	    maxBet=currentMaxGamble;
918 	    blockDelayBeforeSpin=blockDelay;
919 	    return ;
920 	}
921 
922 	function getFirstActiveDuel() constant returns(uint _firstActiveGamble)
923 	{
924             _firstActiveGamble=firstActiveGamble;
925 	    return ;
926 	}
927 
928 	
929     function checkMyBet(address player) constant returns(Status player_status, BetTypes bettype, uint8 input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb)
930     {
931           player_status=playerStatus[player];
932           bettype=gambles[gambleIndex[player]].betType;
933           input=gambles[gambleIndex[player]].input;
934           value=gambles[gambleIndex[player]].wager;
935           result=gambles[gambleIndex[player]].wheelResult;
936           wheelspinned=gambles[gambleIndex[player]].spinned;
937           win=gambles[gambleIndex[player]].win;
938 	blockNb=gambles[gambleIndex[player]].blockNumber;
939 	  return;
940      }
941 
942 } //end of contract