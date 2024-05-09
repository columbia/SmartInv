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
17 //   Full GUI on website with all info to play : 
18 //                   
19 //                  www.Rouleth.com
20 //
21 //
22 //   All documentation on playing and investing are on the website.
23 //
24 //   News : www.reddit.com/r/Rouleth
25 //   twitter : https://twitter.com/TheRouleth
26 //
27 //   Github : https://github.com/Bunjin/Rouleth
28 //
29 //   check latest contract version on website
30 //   V 1.2
31 //
32 // *** coded by WhySoS3rious, 2016.                                       ***//
33 // *** please do not copy without authorization                          ***//
34 // *** contact : reddit    /u/WhySoS3rious                               ***//
35 //
36 //
37 //  Stake : Variable, check on website for the max bet.
38 
39 contract Rouleth
40 {
41 
42     //Variables, Structure
43     address developer;
44     uint8 blockDelay; //nb of blocks to wait before spin
45     uint8 blockExpiration; //nb of blocks before bet expiration (due to hash storage limits)
46     uint256 maxGamble; //max gamble value manually set by config
47     uint maxBetsPerBlock; //limits the number of bets per blocks to prevent miner cheating
48     uint nbBetsCurrentBlock; //counts the nb of bets in the block
49     uint casinoStatisticalLimit;
50     //Current gamble value possibly lower than config (<payroll/(casinoStatisticalLimit*35))
51     uint256 currentMaxGamble; 
52     //Gambles
53     enum BetTypes{number, color, parity, dozen, column, lowhigh} 
54     struct Gamble
55     {
56 	address player;
57         bool spinned; //Was the rouleth spinned ?
58 	bool win;
59 	//Possible bet types
60         BetTypes betType;
61 	uint8 input; //stores number, color, dozen or oddeven
62 	uint256 wager;
63 	uint256 blockNumber; //block of bet -1
64         uint8 wheelResult;
65     }
66     Gamble[] private gambles;
67     uint firstActiveGamble; //pointer to track the first non spinned and non expired gamble.
68     //Tracking progress of players
69     mapping (address=>uint) gambleIndex; //current gamble index of the player
70     enum Status {waitingForBet, waitingForSpin} mapping (address=>Status) playerStatus; //records current status of player
71 
72     //**********************************************
73     //        Management & Config FUNCTIONS        //
74     //**********************************************
75     function  Rouleth() private //creation settings
76     { 
77         developer = msg.sender;
78         blockDelay=2; //delay to wait between bet and spin
79 	blockExpiration=200; //delay after which gamble expires
80         maxGamble=500 finney; //configurable max bet
81         maxBetsPerBlock=5; // limit of bets per block, to prevent multiple bets per miners
82         casinoStatisticalLimit=20;
83     }
84 	
85     modifier onlyDeveloper() 
86     {
87 	if (msg.sender!=developer) throw;
88 	_
89     }
90 	
91     function changeDeveloper(address new_dev)
92     noEthSent
93     onlyDeveloper
94     {
95 	developer=new_dev;
96     }
97 
98 
99     //Activate, Deactivate Betting
100     enum States{active, inactive} States private state;
101 	
102     function disableBetting()
103     noEthSent
104     onlyDeveloper
105     {
106         state=States.inactive;
107     }
108     function enableBetting()
109     onlyDeveloper
110     noEthSent
111     {
112         state=States.active;
113     }
114     
115     modifier onlyActive
116     {
117         if (state==States.inactive) throw;
118         _
119     }
120 
121     //Change some settings within safety bounds
122     function changeSettings(uint newCasinoStatLimit, uint newMaxBetsBlock, uint256 newMaxGamble, uint8 newMaxInvestor, uint256 newMinInvestment, uint256 newLockPeriod, uint8 newBlockDelay, uint8 newBlockExpiration)
123     noEthSent
124     onlyDeveloper
125 	{
126 	        // changes the statistical multiplier that guarantees the long run casino survival
127 	        if (newCasinoStatLimit<10) throw;
128 	        casinoStatisticalLimit=newCasinoStatLimit;
129 	        //Max number of bets per block to prevent miner cheating
130 	        maxBetsPerBlock=newMaxBetsBlock;
131                 //MAX BET : limited by payroll/(casinoStatisticalLimit*35) for statiscal confidence in longevity of casino
132 		if (newMaxGamble<=0) throw; 
133 		else { maxGamble=newMaxGamble; }
134                 //MAX NB of INVESTORS (can only increase and max of 149)
135                 if (newMaxInvestor<setting_maxInvestors || newMaxInvestor>149) throw;
136                 else { setting_maxInvestors=newMaxInvestor;}
137                 //MIN INVEST : 
138                 setting_minInvestment=newMinInvestment;
139                 //Invest LOCK PERIOD
140                 if (setting_lockPeriod>90 days) throw; //3 months max
141                 setting_lockPeriod=newLockPeriod;
142 		//Delay before roll :
143 		if (blockDelay<1) throw;
144 		blockDelay=newBlockDelay;
145                 updateMaxBet();
146 		if (newBlockExpiration<50) throw;
147 		blockExpiration=newBlockExpiration;
148 	}
149  
150 
151     //**********************************************
152     //                 BETTING FUNCTIONS                    //
153     //**********************************************
154 
155 //***//basic betting without Mist or contract call
156     //activates when the player only sends eth to the contract
157     //without specifying any type of bet.
158     function () 
159    {
160        //if player is not playing : bet on Red
161        if (playerStatus[msg.sender]==Status.waitingForBet)  betOnColor(true,false);
162        //if player is already playing, spin the wheel
163        else spinTheWheel();
164     } 
165 
166     function updateMaxBet() private
167     {
168     //check that maxGamble setting is still within safety bounds
169         if (payroll/(casinoStatisticalLimit*35) > maxGamble) 
170 		{ 
171 			currentMaxGamble=maxGamble;
172                 }
173 	else
174 		{ 
175 			currentMaxGamble = payroll/(casinoStatisticalLimit*35);
176 		}
177      }
178 
179 //***//Guarantees that gamble is under (statistical) safety limits for casino survival.
180     function checkBetValue() private returns(uint256 playerBetValue)
181     {
182         updateMaxBet();
183 		if (msg.value > currentMaxGamble) //if above max, send difference back
184 		{
185 			if (msg.sender.send(msg.value-currentMaxGamble)==false) throw;
186 		    playerBetValue=currentMaxGamble;
187 		}
188                 else
189                 { playerBetValue=msg.value; }
190          return;
191        }
192 
193 
194     //check number of bets in block (to prevent miner cheating)
195     modifier checkNbBetsCurrentBlock()
196     {
197         if (gambles.length!=0 && block.number==gambles[gambles.length-1].blockNumber) nbBetsCurrentBlock+=1;
198         else nbBetsCurrentBlock=0;
199         if (nbBetsCurrentBlock>=maxBetsPerBlock) throw;
200         _
201     }
202     //check that the player is not playing already (unless it has expired)
203     modifier checkWaitingForBet{
204         //if player is already in gamble
205         if (playerStatus[msg.sender]!=Status.waitingForBet)
206         {
207              //case not expired
208              if (gambles[gambleIndex[msg.sender]].blockNumber+blockExpiration>block.number) throw;
209              //case expired
210              else
211              {
212                   //add bet to PL and reset status
213                   solveBet(msg.sender, 255, false, 0) ;
214 
215               }
216         }
217 	_
218 	}
219 
220     function updateStatusPlayer() private
221     expireGambles
222     {
223 	playerStatus[msg.sender]=Status.waitingForSpin;
224 	gambleIndex[msg.sender]=gambles.length;
225      }
226 
227 //***//bet on Number	
228     function betOnNumber(uint8 numberChosen)
229     checkWaitingForBet
230     onlyActive
231     checkNbBetsCurrentBlock
232     {
233         updateStatusPlayer();
234         //check that number chosen is valid and records bet
235         if (numberChosen>36) throw;
236         //adapts wager to casino limits
237         uint256 betValue= checkBetValue();
238 	gambles.push(Gamble(msg.sender, false, false, BetTypes.number, numberChosen, betValue, block.number, 37));
239     }
240 
241 //***// function betOnColor
242 	//bet type : color
243 	//input : 0 for red
244 	//input : 1 for black
245     function betOnColor(bool Red, bool Black)
246     checkWaitingForBet
247     onlyActive
248     checkNbBetsCurrentBlock
249     {
250         updateStatusPlayer();
251         uint8 count;
252         uint8 input;
253         if (Red) 
254         { 
255              count+=1; 
256              input=0;
257          }
258         if (Black) 
259         {
260              count+=1; 
261              input=1;
262          }
263         if (count!=1) throw;
264 	//check that wager is under limit
265         uint256 betValue= checkBetValue();
266 	gambles.push(Gamble(msg.sender, false, false, BetTypes.color, input, betValue, block.number, 37));
267     }
268 
269 //***// function betOnLow_High
270 	//bet type : lowhigh
271 	//input : 0 for low
272 	//input : 1 for low
273     function betOnLowHigh(bool Low, bool High)
274     checkWaitingForBet
275     onlyActive
276     checkNbBetsCurrentBlock
277     {
278         updateStatusPlayer();
279         uint8 count;
280         uint8 input;
281         if (Low) 
282         { 
283              count+=1; 
284              input=0;
285          }
286         if (High) 
287         {
288              count+=1; 
289              input=1;
290          }
291         if (count!=1) throw;
292 	//check that wager is under limit
293         uint256 betValue= checkBetValue();
294 	gambles.push(Gamble(msg.sender, false, false, BetTypes.lowhigh, input, betValue, block.number, 37));
295     }
296 
297 //***// function betOnOdd_Even
298 	//bet type : parity
299      //input : 0 for even
300     //input : 1 for odd
301     function betOnOddEven(bool Odd, bool Even)
302     checkWaitingForBet
303     onlyActive
304     checkNbBetsCurrentBlock
305     {
306         updateStatusPlayer();
307         uint8 count;
308         uint8 input;
309         if (Even) 
310         { 
311              count+=1; 
312              input=0;
313          }
314         if (Odd) 
315         {
316              count+=1; 
317              input=1;
318          }
319         if (count!=1) throw;
320 	//check that wager is under limit
321         uint256 betValue= checkBetValue();
322 	gambles.push(Gamble(msg.sender, false, false, BetTypes.parity, input, betValue, block.number, 37));
323     }
324 
325 
326 //***// function betOnDozen
327 //     //bet type : dozen
328 //     //input : 0 for first dozen
329 //     //input : 1 for second dozen
330 //     //input : 2 for third dozen
331     function betOnDozen(bool First, bool Second, bool Third)
332     {
333          betOnColumnOrDozen(First,Second,Third, BetTypes.dozen);
334     }
335 
336 
337 // //***// function betOnColumn
338 //     //bet type : column
339 //     //input : 0 for first column
340 //     //input : 1 for second column
341 //     //input : 2 for third column
342     function betOnColumn(bool First, bool Second, bool Third)
343     {
344          betOnColumnOrDozen(First, Second, Third, BetTypes.column);
345      }
346 
347     function betOnColumnOrDozen(bool First, bool Second, bool Third, BetTypes bet) private
348     checkWaitingForBet
349     onlyActive
350     checkNbBetsCurrentBlock
351     { 
352         updateStatusPlayer();
353         uint8 count;
354         uint8 input;
355         if (First) 
356         { 
357              count+=1; 
358              input=0;
359          }
360         if (Second) 
361         {
362              count+=1; 
363              input=1;
364          }
365         if (Third) 
366         {
367              count+=1; 
368              input=2;
369          }
370         if (count!=1) throw;
371 	//check that wager is under limit
372         uint256 betValue= checkBetValue();
373 	gambles.push(Gamble(msg.sender, false, false, bet, input, betValue, block.number, 37));
374     }
375 
376     //**********************************************
377     // Spin The Wheel & Check Result FUNCTIONS//
378     //**********************************************
379 
380 	event Win(address player, uint8 result, uint value_won);
381 	event Loss(address player, uint8 result, uint value_loss);
382 
383     //check that player has to spin the wheel
384     modifier checkWaitingForSpin{
385         if (playerStatus[msg.sender]!=Status.waitingForSpin) throw;
386 	_
387 	}
388     //Prevents accidental sending of Eth when you shouldn't
389     modifier noEthSent()
390     {
391         if (msg.value>0) 
392 		{
393 				if (msg.sender.send(msg.value)==false) throw;
394 		}
395         _
396     }
397 
398 //***//function to spin
399     function spinTheWheel()
400     noEthSent
401     checkWaitingForSpin
402     {
403         //check that the player waited for the delay before spin
404         //and also that the bet is not expired
405 	uint playerblock = gambles[gambleIndex[msg.sender]].blockNumber;
406 	if (block.number<playerblock+blockDelay || block.number>playerblock+blockExpiration) throw;
407         else
408 	{
409 	    uint8 wheelResult;
410             //Spin the wheel, Reset player status and record result
411 	    wheelResult = uint8(uint256(block.blockhash(playerblock+blockDelay))%37);
412 	    gambles[gambleIndex[msg.sender]].wheelResult=wheelResult;
413             //check result against bet and pay if win
414 	    checkBetResult(wheelResult, gambles[gambleIndex[msg.sender]].betType);
415 	    updateFirstActiveGamble();
416 	}
417     }
418 
419 //update pointer of first gamble not spinned
420 function updateFirstActiveGamble() private
421      {
422               for (uint k=firstActiveGamble; k<=firstActiveGamble+50; k++) 
423               //limit the update to 50 to cap the gas cost and share the work among users
424               {
425                  if (k>=gambles.length || !gambles[k].spinned)
426                  {
427                     firstActiveGamble=k;
428                     break; 
429                  }
430               }
431  }
432 	
433 //checks if there are expired gambles
434 modifier expireGambles{
435     if (  gambles.length!=0 && gambles.length-1>=firstActiveGamble 
436           && gambles[firstActiveGamble].blockNumber + blockExpiration <= block.number 
437           && !gambles[firstActiveGamble].spinned )  
438     { 
439 	solveBet(gambles[firstActiveGamble].player, 255, false, 0); //expires
440     }
441         updateFirstActiveGamble(); //update pointer
442         _
443 }
444 	
445 
446      //CHECK BETS FUNCTIONS private
447      function checkBetResult(uint8 result, BetTypes betType) private
448      {
449           //bet on Number
450           if (betType==BetTypes.number) checkBetNumber(result);
451           else if (betType==BetTypes.parity) checkBetParity(result);
452           else if (betType==BetTypes.color) checkBetColor(result);
453 	 else if (betType==BetTypes.lowhigh) checkBetLowhigh(result);
454 	 else if (betType==BetTypes.dozen) checkBetDozen(result);
455 	else if (betType==BetTypes.column) checkBetColumn(result);
456           updateMaxBet(); 
457      }
458 
459      // function solve Bet once result is determined : sends to winner, adds loss to profit
460      function solveBet(address player, uint8 result, bool win, uint8 multiplier) private
461      {
462         playerStatus[player]=Status.waitingForBet;
463         gambles[gambleIndex[player]].spinned=true;
464 	uint bet_v = gambles[gambleIndex[player]].wager;
465             if (win)
466             {
467                   if (player!=gambles[gambleIndex[player]].player) throw; //security failcheck
468 		  gambles[gambleIndex[player]].win=true;
469 		  uint win_v = multiplier*bet_v;
470                   lossSinceChange+=win_v-bet_v;
471 		  Win(player, result, win_v);
472 				if (player.send(win_v)==false) throw;
473              }
474             else
475             {
476 		Loss(player, result, bet_v);
477                 profitSinceChange+=bet_v;
478             }
479 
480       }
481 
482 
483      // checkbeton number(input)
484     // bet type : number
485     // input : chosen number
486      function checkBetNumber(uint8 result) private
487      {
488             bool win;
489             //win
490 	    if (result==gambles[gambleIndex[msg.sender]].input)
491 	    {
492                   win=true;  
493              }
494              solveBet(msg.sender, result,win,36);
495      }
496 
497 
498      // checkbet on oddeven
499     // bet type : parity
500     // input : 0 for even, 1 for odd
501      function checkBetParity(uint8 result) private
502      {
503             bool win;
504             //win
505 	    if (result%2==gambles[gambleIndex[msg.sender]].input && result!=0)
506 	    {
507                   win=true;                
508              }
509              solveBet(msg.sender,result,win,2);
510         
511      }
512 	
513      // checkbet on lowhigh
514      // bet type : lowhigh
515      // input : 0 low, 1 high
516      function checkBetLowhigh(uint8 result) private
517      {
518             bool win;
519             //win
520 		 if (result!=0 && ( (result<19 && gambles[gambleIndex[msg.sender]].input==0)
521 			 || (result>18 && gambles[gambleIndex[msg.sender]].input==1)
522 			 ) )
523 	    {
524                   win=true;
525              }
526              solveBet(msg.sender,result,win,2);
527      }
528 
529      // checkbet on color
530      // bet type : color
531      // input : 0 red, 1 black
532       uint[18] red_list=[1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36];
533       function checkBetColor(uint8 result) private
534       {
535              bool red;
536              //check if red
537              for (uint8 k; k<18; k++)
538              { 
539                     if (red_list[k]==result) 
540                     { 
541                           red=true; 
542                           break;
543                     }
544              }
545              bool win;
546              //win
547              if ( result!=0
548                 && ( (gambles[gambleIndex[msg.sender]].input==0 && red)  
549                 || ( gambles[gambleIndex[msg.sender]].input==1 && !red)  ) )
550              {
551                   win=true;
552              }
553              solveBet(msg.sender,result,win,2);
554        }
555 
556      // checkbet on dozen
557      // bet type : dozen
558      // input : 0 first, 1 second, 2 third
559      function checkBetDozen(uint8 result) private
560      { 
561             bool win;
562             //win on first dozen
563      		 if ( result!=0 &&
564                       ( (result<13 && gambles[gambleIndex[msg.sender]].input==0)
565      			||
566                      (result>12 && result<25 && gambles[gambleIndex[msg.sender]].input==1)
567                     ||
568                      (result>24 && gambles[gambleIndex[msg.sender]].input==2) ) )
569      	    {
570                    win=true;                
571              }
572              solveBet(msg.sender,result,win,3);
573      }
574 
575      // checkbet on column
576      // bet type : column
577      // input : 0 first, 1 second, 2 third
578       function checkBetColumn(uint8 result) private
579       {
580              bool win;
581              //win
582              if ( result!=0
583                 && ( (gambles[gambleIndex[msg.sender]].input==0 && result%3==1)  
584                 || ( gambles[gambleIndex[msg.sender]].input==1 && result%3==2)
585                 || ( gambles[gambleIndex[msg.sender]].input==2 && result%3==0)  ) )
586              {
587                   win=true;
588              }
589              solveBet(msg.sender,result,win,3);
590       }
591 
592 
593 //INVESTORS FUNCTIONS
594 
595 
596 //total casino payroll
597     uint256 payroll;
598 //Profit Loss since last investor change
599     uint256 profitSinceChange;
600     uint256 lossSinceChange;
601 //investor struct array (hard capped to 150)
602     uint8 setting_maxInvestors = 50;
603     struct Investor
604     {
605 	    address investor;
606 	    uint256 time;
607     }	
608 	
609     Investor[250] private investors ;
610     //Balances of the investors
611     mapping (address=>uint256) balance; 
612     //Investor lockPeriod
613     //lock time to avoid invest and withdraw for refresh only
614     //also time during which you cannot be outbet by a new investor if it is full
615     uint256 setting_lockPeriod=30 days ;
616     uint256 setting_minInvestment=10 ether; //min amount to send when using invest()
617     //if full and unlocked position, indicates the cheapest amount to outbid
618     //otherwise cheapestUnlockedPosition=255
619     uint8 cheapestUnlockedPosition; 
620     uint256 minCurrentInvest; 
621     //record open position index
622     // =255 if full
623     uint8 openPosition;
624 	
625     event newInvest(address player, uint invest_v);
626 
627 
628      function invest()
629      {
630           // check that min 10 ETH is sent (variable setting)
631           if (msg.value<setting_minInvestment) throw;
632           // check if already investor
633           bool alreadyInvestor;
634           // reset the position counters to values out of bounds
635           openPosition=255;
636           cheapestUnlockedPosition=255;
637           minCurrentInvest=1000000000 ether;
638           // update balances before altering the investor shares
639           updateBalances();
640           // loop over investor's array to find if already investor, 
641           // or openPosition and cheapest UnlockedPosition
642           for (uint8 k = 0; k<setting_maxInvestors; k++)
643           { 
644                //captures an index of an open position
645                if (investors[k].investor==0) openPosition=k; 
646                //captures if already an investor 
647                else if (investors[k].investor==msg.sender)
648                {
649                     investors[k].time=now; //refresh time invest
650                     alreadyInvestor=true;
651                 }
652                //captures the index of the investor with the min investment (after lock period)
653                else if (investors[k].time+setting_lockPeriod<now && balance[investors[k].investor]<minCurrentInvest && investors[k].investor!=developer)
654                {
655                     cheapestUnlockedPosition=k;
656                     minCurrentInvest=balance[investors[k].investor];
657                 }
658            }
659            //case New investor
660            if (alreadyInvestor==false)
661            {
662                     //case : investor array not full, record new investor
663                     if (openPosition!=255) investors[openPosition]=Investor(msg.sender, now);
664                     //case : investor array full
665                     else
666                     {
667                          //subcase : investor has not outbid or all positions under lock period
668                          if (msg.value<=minCurrentInvest || cheapestUnlockedPosition==255) throw;
669                          //subcase : investor outbid, record investor change and refund previous
670                          else
671                          {
672                               address previous = investors[cheapestUnlockedPosition].investor;
673                               balance[previous]=0;
674                               investors[cheapestUnlockedPosition]=Investor(msg.sender, now);
675                               if (previous.send(balance[previous])==false) throw;
676                           }
677                      }
678             }
679           //add investment to balance of investor and to payroll
680 
681           uint256 maintenanceFees=2*msg.value/100; //2% maintenance fees
682           uint256 netInvest=msg.value - maintenanceFees;
683           newInvest(msg.sender, netInvest);
684           balance[msg.sender]+=netInvest; //add invest to balance
685           payroll+=netInvest;
686           //send maintenance fees to developer 
687           if (developer.send(maintenanceFees)==false) throw;
688           updateMaxBet();
689       }
690 
691 //***// Withdraw function (only after lockPeriod)
692     // input : amount to withdraw in Wei (leave empty for full withdraw)
693     // if your withdraw brings your balance under the min investment required,
694     // your balance is fully withdrawn
695 	event withdraw(address player, uint withdraw_v);
696 	
697     function withdrawInvestment(uint256 amountToWithdrawInWei)
698     noEthSent
699     {
700         //before withdraw, update balances of the investors with the Profit and Loss sinceChange
701         updateBalances();
702 	//check that amount requested is authorized  
703 	if (amountToWithdrawInWei>balance[msg.sender]) throw;
704         //retrieve investor ID
705         uint8 investorID=255;
706         for (uint8 k = 0; k<setting_maxInvestors; k++)
707         {
708                if (investors[k].investor==msg.sender)
709                {
710                     investorID=k;
711                     break;
712                }
713         }
714            if (investorID==255) throw; //stop if not an investor
715            //check if investment lock period is over
716            if (investors[investorID].time+setting_lockPeriod>now) throw;
717            //if balance left after withdraw is still above min investment accept partial withdraw
718            if (balance[msg.sender]-amountToWithdrawInWei>=setting_minInvestment && amountToWithdrawInWei!=0)
719            {
720                balance[msg.sender]-=amountToWithdrawInWei;
721                payroll-=amountToWithdrawInWei;
722                //send amount to investor (with security if transaction fails)
723                if (msg.sender.send(amountToWithdrawInWei)==false) throw;
724 	       withdraw(msg.sender, amountToWithdrawInWei);
725            }
726            else
727            //if amountToWithdraw=0 : user wants full withdraw
728            //if balance after withdraw is < min invest, withdraw all and delete investor
729            {
730                //send amount to investor (with security if transaction fails)
731                uint256 fullAmount=balance[msg.sender];
732                payroll-=fullAmount;
733                balance[msg.sender]=0;
734                //delete investor
735                delete investors[investorID];
736                if (msg.sender.send(fullAmount)==false) throw;
737    	       withdraw(msg.sender, fullAmount);
738             }
739           updateMaxBet();
740      }
741 
742 //***// updates balances with Profit Losses when there is a withdraw/deposit of investors
743 
744 	function manualUpdateBalances()
745 	expireGambles
746 	noEthSent
747 	onlyDeveloper
748 	{
749 	    updateBalances();
750 	}
751     function updateBalances() private
752     {
753          //split Profits
754          uint256 profitToSplit;
755          uint256 lossToSplit;
756          if (profitSinceChange==0 && lossSinceChange==0)
757          { return; }
758          
759          else
760          {
761              // Case : Global profit (more win than losses)
762              // 2% fees for developer on global profit (if profit>loss)
763              if (profitSinceChange>lossSinceChange)
764              {
765                 profitToSplit=profitSinceChange-lossSinceChange;
766                 uint256 developerFees=profitToSplit*2/100;
767                 profitToSplit-=developerFees;
768                 if (developer.send(developerFees)==false) throw;
769              }
770              else
771              {
772                 lossToSplit=lossSinceChange-profitSinceChange;
773              }
774          
775          //share the loss and profits between all invest 
776          //(proportionnaly. to each investor balance)
777          uint totalShared;
778              for (uint8 k=0; k<setting_maxInvestors; k++)
779              {
780                  address inv=investors[k].investor;
781                  if (inv==0) continue;
782                  else
783                  {
784                        if (profitToSplit!=0) 
785                        {
786                            uint profitShare=(profitToSplit*balance[inv])/payroll;
787                            balance[inv]+=profitShare;
788                            totalShared+=profitShare;
789                        }
790                        if (lossToSplit!=0) 
791                        {
792                            uint lossShare=(lossToSplit*balance[inv])/payroll;
793                            balance[inv]-=lossShare;
794                            totalShared+=lossShare;
795                            
796                        }
797                  }
798              }
799           // update payroll
800           if (profitToSplit !=0) 
801           {
802               payroll+=profitToSplit;
803               balance[developer]+=profitToSplit-totalShared;
804           }
805           if (lossToSplit !=0) 
806           {
807               payroll-=lossToSplit;
808               balance[developer]-=lossToSplit-totalShared;
809           }
810           profitSinceChange=0; //reset Profit;
811           lossSinceChange=0; //reset Loss ;
812           
813           }
814      }
815      
816      
817      //INFORMATION FUNCTIONS
818      
819      function checkProfitLossSinceInvestorChange() constant returns(uint profit_since_update_balances, uint loss_since_update_balances)
820      {
821         profit_since_update_balances=profitSinceChange;
822         loss_since_update_balances=lossSinceChange;
823         return;
824      }
825 
826     function checkInvestorBalance(address investor) constant returns(uint balanceInWei)
827     {
828           balanceInWei=balance[investor];
829           return;
830      }
831 
832     function getInvestorList(uint index) constant returns(address investor, uint endLockPeriod)
833     {
834           investor=investors[index].investor;
835           endLockPeriod=investors[index].time+setting_lockPeriod;
836           return;
837     }
838 	
839 
840 	function investmentEntryCost() constant returns(bool open_position, bool unlocked_position, uint buyout_amount, uint investLockPeriod)
841 	{
842 		if (openPosition!=255) open_position=true;
843 		if (cheapestUnlockedPosition!=255) 
844 		{
845 			unlocked_position=true;
846 			buyout_amount=minCurrentInvest;
847 		}
848 		investLockPeriod=setting_lockPeriod;
849 		return;
850 	}
851 	
852 	function getSettings() constant returns(uint maxBet, uint8 blockDelayBeforeSpin)
853 	{
854 	    maxBet=currentMaxGamble;
855 	    blockDelayBeforeSpin=blockDelay;
856 	    return ;
857 	}
858 
859 	function getFirstActiveGamble() constant returns(uint _firstActiveGamble)
860 	{
861             _firstActiveGamble=firstActiveGamble;
862 	    return ;
863 	}
864 	
865 	function getPayroll() constant returns(uint payroll_at_last_update_balances)
866 	{
867             payroll_at_last_update_balances=payroll;
868 	    return ;
869 	}
870 
871 	
872     function checkMyBet(address player) constant returns(Status player_status, BetTypes bettype, uint8 input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb)
873     {
874           player_status=playerStatus[player];
875           bettype=gambles[gambleIndex[player]].betType;
876           input=gambles[gambleIndex[player]].input;
877           value=gambles[gambleIndex[player]].wager;
878           result=gambles[gambleIndex[player]].wheelResult;
879           wheelspinned=gambles[gambleIndex[player]].spinned;
880           win=gambles[gambleIndex[player]].win;
881           blockNb=gambles[gambleIndex[player]].blockNumber;
882 	  return;
883      }
884      
885          function getGamblesList(uint256 index) constant returns(address player, BetTypes bettype, uint8 input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb)
886     {
887           player=gambles[index].player;
888           bettype=gambles[index].betType;
889           input=gambles[index].input;
890           value=gambles[index].wager;
891           result=gambles[index].wheelResult;
892           wheelspinned=gambles[index].spinned;
893           win=gambles[index].win;
894 	  blockNb=gambles[index].blockNumber;
895 	  return;
896      }
897 
898 } //end of contract