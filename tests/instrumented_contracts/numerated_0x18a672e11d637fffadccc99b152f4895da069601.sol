1 //                       , ; ,   .-'"""'-.   , ; ,
2 //                       \\|/  .'          '.  \|//
3 //                        \-;-/   ()   ()   \-;-/
4 //                        // ;               ; \\
5 //                       //__; :.         .; ;__\\
6 //                      `-----\'.'-.....-'.'/-----'
7 //                             '.'.-.-,_.'.'
8 //                               '(  (..-'
9 //                                 '-'
10 //  ROULETH 
11 //
12 //  Play the Roulette on ethereum blockchain !
13 //  (or become a member of Rouleth's Decentralized Organisation  and contribute to the bankroll.) 
14 //
15 //
16 //
17 //   check latest contract address version on the current website interface
18 //   V 2
19 //
20 //
21 //
22 
23 contract Rouleth
24 {
25     //Game and Global Variables, Structure of gambles
26     address developer;
27     uint8 blockDelay; //nb of blocks to wait before spin
28     uint8 blockExpiration; //nb of blocks before bet expiration (due to hash storage limits)
29     uint256 maxGamble; //max gamble value manually set by config
30     uint256 minGamble; //min gamble value manually set by config
31     uint maxBetsPerBlock; //limits the number of bets per blocks to prevent miner cheating
32     uint nbBetsCurrentBlock; //counts the nb of bets in the block
33     uint casinoStatisticalLimit; //ratio payroll and max win
34     //Current gamble value possibly lower than limit auto
35     uint256 currentMaxGamble; 
36     //Gambles
37     enum BetTypes{number, color, parity, dozen, column, lowhigh} 
38     struct Gamble
39     {
40 	address player;
41         bool spinned; //Was the rouleth spinned ?
42 	bool win;
43 	//Possible bet types
44         BetTypes betType;
45 	uint8 input; //stores number, color, dozen or oddeven
46 	uint256 wager;
47 	uint256 blockNumber; //block of bet
48 	uint256 blockSpinned; //block of spin
49         uint8 wheelResult;
50     }
51     Gamble[] private gambles;
52     uint totalGambles; 
53     //Tracking progress of players
54     mapping (address=>uint) gambleIndex; //current gamble index of the player
55     //records current status of player
56     enum Status {waitingForBet, waitingForSpin} mapping (address=>Status) playerStatus; 
57 
58 
59     //**********************************************
60     //        Management & Config FUNCTIONS        //
61     //**********************************************
62 
63     function  Rouleth() private //creation settings
64     { 
65         developer = msg.sender;
66         blockDelay=1; //indicates which block after bet will be used for RNG
67 	blockExpiration=200; //delay after which gamble expires
68         minGamble=50 finney; //configurable min bet
69         maxGamble=500 finney; //configurable max bet
70         maxBetsPerBlock=5; // limit of bets per block, to prevent multiple bets per miners
71         casinoStatisticalLimit=100; //we are targeting at least 400
72     }
73     
74     modifier onlyDeveloper() 
75     {
76 	if (msg.sender!=developer) throw;
77 	_
78     }
79     
80     function changeDeveloper_only_Dev(address new_dev)
81     noEthSent
82     onlyDeveloper
83     {
84 	developer=new_dev;
85     }
86 
87     //Prevents accidental sending of Eth when you shouldn't
88     modifier noEthSent()
89     {
90         if (msg.value>0) 
91 	{
92 	    throw;
93 	}
94         _
95     }
96 
97 
98     //Activate, Deactivate Betting
99     enum States{active, inactive} States private contract_state;
100     
101     function disableBetting_only_Dev()
102     noEthSent
103     onlyDeveloper
104     {
105         contract_state=States.inactive;
106     }
107 
108 
109     function enableBetting_only_Dev()
110     noEthSent
111     onlyDeveloper
112     {
113         contract_state=States.active;
114 
115     }
116     
117     modifier onlyActive()
118     {
119         if (contract_state==States.inactive) throw;
120         _
121     }
122 
123 
124 
125     //Change some settings within safety bounds
126     function changeSettings_only_Dev(uint newCasinoStatLimit, uint newMaxBetsBlock, uint256 newMinGamble, uint256 newMaxGamble, uint16 newMaxInvestor, uint256 newMinInvestment,uint256 newMaxInvestment, uint256 newLockPeriod, uint8 newBlockDelay, uint8 newBlockExpiration)
127     noEthSent
128     onlyDeveloper
129     {
130 
131 
132         // changes the statistical multiplier that guarantees the long run casino survival
133         if (newCasinoStatLimit<100) throw;
134         casinoStatisticalLimit=newCasinoStatLimit;
135         //Max number of bets per block to prevent miner cheating
136         maxBetsPerBlock=newMaxBetsBlock;
137         //MAX BET : limited by payroll/(casinoStatisticalLimit*35)
138         if (newMaxGamble<newMinGamble) throw;  
139 	else { maxGamble=newMaxGamble; }
140         //Min Bet
141         if (newMinGamble<0) throw; 
142 	else { minGamble=newMinGamble; }
143         //MAX NB of DAO members (can only increase (within bounds) or stay equal)
144         //this number of members can only increase after 25k spins on Rouleth
145         //refuse change of max number of members if less than 25k spins played
146         if (newMaxInvestor!=setting_maxInvestors && gambles.length<25000) throw;
147         if ( newMaxInvestor<setting_maxInvestors 
148              || newMaxInvestor>investors.length) throw;
149         else { setting_maxInvestors=newMaxInvestor;}
150         //computes the results of the vote of the VIP members, fees to apply to new members
151         computeResultVoteExtraInvestFeesRate();
152         if (newMaxInvestment<newMinInvestment) throw;
153         //MIN INVEST : 
154         setting_minInvestment=newMinInvestment;
155         //MAX INVEST : 
156         setting_maxInvestment=newMaxInvestment;
157         //Invest LOCK PERIOD
158 	//1 year max
159 	//can also serve as a failsafe to shutdown withdraws for a period
160         if (setting_lockPeriod>360 days) throw; 
161         setting_lockPeriod=newLockPeriod;
162         //Delay before spin :
163 	blockDelay=newBlockDelay;
164 	if (newBlockExpiration<blockDelay+20) throw;
165 	blockExpiration=newBlockExpiration;
166         updateMaxBet();
167     }
168 
169 
170     //**********************************************
171     //                 Nicknames FUNCTIONS                    //
172     //**********************************************
173 
174     //User set nickname
175     mapping (address => string) nicknames;
176     function setNickname(string name) 
177     noEthSent
178     {
179         if (bytes(name).length >= 2 && bytes(name).length <= 30)
180             nicknames[msg.sender] = name;
181     }
182     function getNickname(address _address) constant returns(string _name) {
183         _name = nicknames[_address];
184     }
185 
186     
187     //**********************************************
188     //                 BETTING FUNCTIONS                    //
189     //**********************************************
190 
191     //***//basic betting without Mist or contract call
192     //activates when the player only sends eth to the contract
193     //without specifying any type of bet.
194     function () 
195     {
196 	//defaut bet : bet on red
197 	betOnColor(true,false);
198     } 
199 
200     //Admin function that
201     //recalculates max bet
202     //updated after each bet and change of bankroll
203     function updateMaxBet() private
204     {
205 	//check that setting is still within safety bounds
206         if (payroll/(casinoStatisticalLimit*35) > maxGamble) 
207 	{ 
208 	    currentMaxGamble=maxGamble;
209         }
210 	else
211 	{ 
212 	    currentMaxGamble = payroll/(casinoStatisticalLimit*35);
213 	}
214     }
215 
216 
217     //***//Guarantees that gamble is under max bet and above min.
218     // returns bet value
219     function checkBetValue() private returns(uint256 playerBetValue)
220     {
221         if (msg.value < minGamble) throw;
222 	if (msg.value > currentMaxGamble) //if above max, send difference back
223 	{
224             playerBetValue=currentMaxGamble;
225 	}
226         else
227         { playerBetValue=msg.value; }
228         return;
229     }
230 
231 
232     //check number of bets in block (to prevent miner cheating)
233     modifier checkNbBetsCurrentBlock()
234     {
235         if (gambles.length!=0 && block.number==gambles[gambles.length-1].blockNumber) nbBetsCurrentBlock+=1;
236         else nbBetsCurrentBlock=0;
237         if (nbBetsCurrentBlock>=maxBetsPerBlock) throw;
238         _
239     }
240 
241 
242     //Function record bet called by all others betting functions
243     function placeBet(BetTypes betType_, uint8 input_) private
244     {
245 	// Before we record, we may have to spin the past bet if the croupier bot 
246 	// is down for some reason or if the player played again too quickly.
247 	// This would fail though if the player tries too play to quickly (in consecutive block).
248 	// gambles should be spaced by at least a block
249 	// the croupier bot should spin within 2 blocks (~30 secs) after your bet.
250 	// if the bet expires it is added to casino profit, otherwise it would be a way to cheat
251 	if (playerStatus[msg.sender]!=Status.waitingForBet)
252 	{
253             SpinTheWheel(msg.sender);
254 	}
255         //Once this is done, we can record the new bet
256 	playerStatus[msg.sender]=Status.waitingForSpin;
257 	gambleIndex[msg.sender]=gambles.length;
258         totalGambles++;
259         //adapts wager to casino limits
260         uint256 betValue = checkBetValue();
261 	gambles.push(Gamble(msg.sender, false, false, betType_, input_, betValue, block.number, 0, 37)); //37 indicates not spinned yet
262 	//refund excess bet (at last step vs re-entry)
263         if (betValue<msg.value) 
264         {
265  	    if (msg.sender.send(msg.value-betValue)==false) throw;
266         }
267     }
268 
269 
270     //***//bet on Number	
271     function betOnNumber(uint8 numberChosen)
272     onlyActive
273     checkNbBetsCurrentBlock
274     {
275         //check that number chosen is valid and records bet
276         if (numberChosen>36) throw;
277         placeBet(BetTypes.number, numberChosen);
278     }
279 
280     //***// function betOnColor
281     //bet type : color
282     //input : 0 for red
283     //input : 1 for black
284     function betOnColor(bool Red, bool Black)
285     onlyActive
286     checkNbBetsCurrentBlock
287     {
288         uint8 count;
289         uint8 input;
290         if (Red) 
291         { 
292             count+=1; 
293             input=0;
294         }
295         if (Black) 
296         {
297             count+=1; 
298             input=1;
299         }
300         if (count!=1) throw;
301         placeBet(BetTypes.color, input);
302     }
303 
304     //***// function betOnLow_High
305     //bet type : lowhigh
306     //input : 0 for low
307     //input : 1 for low
308     function betOnLowHigh(bool Low, bool High)
309     onlyActive
310     checkNbBetsCurrentBlock
311     {
312         uint8 count;
313         uint8 input;
314         if (Low) 
315         { 
316             count+=1; 
317             input=0;
318         }
319         if (High) 
320         {
321             count+=1; 
322             input=1;
323         }
324         if (count!=1) throw;
325         placeBet(BetTypes.lowhigh, input);
326     }
327 
328     //***// function betOnOddEven
329     //bet type : parity
330     //input : 0 for even
331     //input : 1 for odd
332     function betOnOddEven(bool Odd, bool Even)
333     onlyActive
334     checkNbBetsCurrentBlock
335     {
336         uint8 count;
337         uint8 input;
338         if (Even) 
339         { 
340             count+=1; 
341             input=0;
342         }
343         if (Odd) 
344         {
345             count+=1; 
346             input=1;
347         }
348         if (count!=1) throw;
349         placeBet(BetTypes.parity, input);
350     }
351 
352 
353     //***// function betOnDozen
354     //     //bet type : dozen
355     //     //input : 0 for first dozen
356     //     //input : 1 for second dozen
357     //     //input : 2 for third dozen
358     function betOnDozen(bool First, bool Second, bool Third)
359     {
360         betOnColumnOrDozen(First,Second,Third, BetTypes.dozen);
361     }
362 
363 
364     // //***// function betOnColumn
365     //     //bet type : column
366     //     //input : 0 for first column
367     //     //input : 1 for second column
368     //     //input : 2 for third column
369     function betOnColumn(bool First, bool Second, bool Third)
370     {
371         betOnColumnOrDozen(First, Second, Third, BetTypes.column);
372     }
373 
374     function betOnColumnOrDozen(bool First, bool Second, bool Third, BetTypes bet) private
375     onlyActive
376     checkNbBetsCurrentBlock
377     { 
378         uint8 count;
379         uint8 input;
380         if (First) 
381         { 
382             count+=1; 
383             input=0;
384         }
385         if (Second) 
386         {
387             count+=1; 
388             input=1;
389         }
390         if (Third) 
391         {
392             count+=1; 
393             input=2;
394         }
395         if (count!=1) throw;
396         placeBet(bet, input);
397     }
398 
399 
400     //**********************************************
401     // Spin The Wheel & Check Result FUNCTIONS//
402     //**********************************************
403 
404     event Win(address player, uint8 result, uint value_won, bytes32 bHash, bytes32 sha3Player, uint gambleId);
405     event Loss(address player, uint8 result, uint value_loss, bytes32 bHash, bytes32 sha3Player, uint gambleId);
406 
407     //***//function to spin callable
408     // no eth allowed
409     function spinTheWheel(address spin_for_player)
410     noEthSent
411     {
412         SpinTheWheel(spin_for_player);
413     }
414 
415 
416     function SpinTheWheel(address playerSpinned) private
417     {
418         if (playerSpinned==0)
419 	{
420 	    playerSpinned=msg.sender;         //if no index spins for the sender
421 	}
422 
423 	//check that player has to spin
424         if (playerStatus[playerSpinned]!=Status.waitingForSpin) throw;
425         //redundent double check : check that gamble has not been spinned already
426         if (gambles[gambleIndex[playerSpinned]].spinned==true) throw;
427         //check that the player waited for the delay before spin
428         //and also that the bet is not expired
429 	uint playerblock = gambles[gambleIndex[playerSpinned]].blockNumber;
430         //too early to spin
431 	if (block.number<=playerblock+blockDelay) throw;
432         //too late, bet expired, player lost
433         else if (block.number>playerblock+blockExpiration)  solveBet(playerSpinned, 255, false, 1, 0, 0) ;
434 	//spin !
435         else
436 	{
437 	    uint8 wheelResult;
438             //Spin the wheel, 
439             bytes32 blockHash= block.blockhash(playerblock+blockDelay);
440             //security check that the Hash is not empty
441             if (blockHash==0) throw;
442 	    // generate the hash for RNG from the blockHash and the player's address
443             bytes32 shaPlayer = sha3(playerSpinned, blockHash);
444 	    // get the final wheel result
445 	    wheelResult = uint8(uint256(shaPlayer)%37);
446             //check result against bet and pay if win
447 	    checkBetResult(wheelResult, playerSpinned, blockHash, shaPlayer);
448 	}
449     }
450     
451 
452     //CHECK BETS FUNCTIONS private
453     function checkBetResult(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
454     {
455         BetTypes betType=gambles[gambleIndex[player]].betType;
456         //bet on Number
457         if (betType==BetTypes.number) checkBetNumber(result, player, blockHash, shaPlayer);
458         else if (betType==BetTypes.parity) checkBetParity(result, player, blockHash, shaPlayer);
459         else if (betType==BetTypes.color) checkBetColor(result, player, blockHash, shaPlayer);
460 	else if (betType==BetTypes.lowhigh) checkBetLowhigh(result, player, blockHash, shaPlayer);
461 	else if (betType==BetTypes.dozen) checkBetDozen(result, player, blockHash, shaPlayer);
462         else if (betType==BetTypes.column) checkBetColumn(result, player, blockHash, shaPlayer);
463         updateMaxBet();  //at the end, update the Max possible bet
464     }
465 
466     // function solve Bet once result is determined : sends to winner, adds loss to profit
467     function solveBet(address player, uint8 result, bool win, uint8 multiplier, bytes32 blockHash, bytes32 shaPlayer) private
468     {
469         //Update status and record spinned
470         playerStatus[player]=Status.waitingForBet;
471         gambles[gambleIndex[player]].wheelResult=result;
472         gambles[gambleIndex[player]].spinned=true;
473         gambles[gambleIndex[player]].blockSpinned=block.number;
474 	uint bet_v = gambles[gambleIndex[player]].wager;
475 	
476         if (win)
477         {
478 	    gambles[gambleIndex[player]].win=true;
479 	    uint win_v = (multiplier-1)*bet_v;
480             lossSinceChange+=win_v;
481             Win(player, result, win_v, blockHash, shaPlayer, gambleIndex[player]);
482             //send win!
483 	    //safe send vs potential callstack overflowed spins
484             if (player.send(win_v+bet_v)==false) throw;
485         }
486         else
487         {
488 	    Loss(player, result, bet_v-1, blockHash, shaPlayer, gambleIndex[player]);
489             profitSinceChange+=bet_v-1;
490             //send 1 wei to confirm spin if loss
491             if (player.send(1)==false) throw;
492         }
493 
494     }
495 
496     // checkbeton number(input)
497     // bet type : number
498     // input : chosen number
499     function checkBetNumber(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
500     {
501         bool win;
502         //win
503 	if (result==gambles[gambleIndex[player]].input)
504 	{
505             win=true;  
506         }
507         solveBet(player, result,win,36, blockHash, shaPlayer);
508     }
509 
510 
511     // checkbet on oddeven
512     // bet type : parity
513     // input : 0 for even, 1 for odd
514     function checkBetParity(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
515     {
516         bool win;
517         //win
518 	if (result%2==gambles[gambleIndex[player]].input && result!=0)
519 	{
520             win=true;                
521         }
522         solveBet(player,result,win,2, blockHash, shaPlayer);
523     }
524     
525     // checkbet on lowhigh
526     // bet type : lowhigh
527     // input : 0 low, 1 high
528     function checkBetLowhigh(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
529     {
530         bool win;
531         //win
532 	if (result!=0 && ( (result<19 && gambles[gambleIndex[player]].input==0)
533 			   || (result>18 && gambles[gambleIndex[player]].input==1)
534 			 ) )
535 	{
536             win=true;
537         }
538         solveBet(player,result,win,2, blockHash, shaPlayer);
539     }
540 
541     // checkbet on color
542     // bet type : color
543     // input : 0 red, 1 black
544     uint[18] red_list=[1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36];
545     function checkBetColor(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
546     {
547         bool red;
548         //check if red
549         for (uint8 k; k<18; k++)
550         { 
551             if (red_list[k]==result) 
552             { 
553                 red=true; 
554                 break;
555             }
556         }
557         bool win;
558         //win
559         if ( result!=0
560              && ( (gambles[gambleIndex[player]].input==0 && red)  
561                   || ( gambles[gambleIndex[player]].input==1 && !red)  ) )
562         {
563             win=true;
564         }
565         solveBet(player,result,win,2, blockHash, shaPlayer);
566     }
567 
568     // checkbet on dozen
569     // bet type : dozen
570     // input : 0 first, 1 second, 2 third
571     function checkBetDozen(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
572     { 
573         bool win;
574         //win on first dozen
575      	if ( result!=0 &&
576              ( (result<13 && gambles[gambleIndex[player]].input==0)
577      	       ||
578                (result>12 && result<25 && gambles[gambleIndex[player]].input==1)
579                ||
580                (result>24 && gambles[gambleIndex[player]].input==2) ) )
581      	{
582             win=true;                
583         }
584         solveBet(player,result,win,3, blockHash, shaPlayer);
585     }
586 
587     // checkbet on column
588     // bet type : column
589     // input : 0 first, 1 second, 2 third
590     function checkBetColumn(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
591     {
592         bool win;
593         //win
594         if ( result!=0
595              && ( (gambles[gambleIndex[player]].input==0 && result%3==1)  
596                   || ( gambles[gambleIndex[player]].input==1 && result%3==2)
597                   || ( gambles[gambleIndex[player]].input==2 && result%3==0)  ) )
598         {
599             win=true;
600         }
601         solveBet(player,result,win,3, blockHash, shaPlayer);
602     }
603 
604 
605     //D.A.O. FUNCTIONS
606 
607 
608     //total casino payroll
609     uint256 payroll;
610     //Profit Loss since last investor change
611     uint256 profitSinceChange;
612     uint256 lossSinceChange;
613     //DAO members struct array (hard capped to 777 members (77 VIP + 700 extra members) )
614     struct Investor
615     {
616 	address investor;
617 	uint256 time;
618     }	
619     
620     Investor[777] private investors; //array of 777 elements (max Rouleth's members nb.)
621     uint16 setting_maxInvestors = 77; //Initially restricted to 77 VIP Members
622     //Balances of the DAO members
623     mapping (address=>uint256) balance; 
624     //lockPeriod
625     //minimum membership time
626     uint256 setting_lockPeriod=30 days ;
627     uint256 setting_minInvestment=100 ether; //min amount to send when using "invest()"
628     uint256 setting_maxInvestment=200 ether; //max amount to send when using "invest()"
629     
630     event newInvest(address player, uint invest_v, uint net_invest_v);
631 
632 
633     //Become a DAO member.
634     function invest()
635     {
636         // update balances before altering the shares            
637         updateBalances();
638         uint256 netInvest;
639         uint excess;
640         // reset the open position counter to values out of bounds
641         // =999 if full
642         uint16 openPosition=999;
643         bool alreadyInvestor;
644         // loop over array to find if already member, 
645         // and record a potential openPosition
646         for (uint16 k = 0; k<setting_maxInvestors; k++)
647         { 
648             // captures an index of an open position
649             if (investors[k].investor==0) openPosition=k; 
650             // captures if already a member 
651             else if (investors[k].investor==msg.sender)
652             {
653                 alreadyInvestor=true;
654                 break;
655             }
656         }
657         //new Member
658         if (!alreadyInvestor)
659         {
660             // check that more than min is sent (variable setting)
661             if (msg.value<setting_minInvestment) throw;
662             // check that less than max is sent (variable setting)
663             // otherwise refund
664             if (msg.value>setting_maxInvestment)
665             {
666                 excess=msg.value-setting_maxInvestment;
667   		netInvest=setting_maxInvestment;
668             }
669 	    else
670 	    {
671 		netInvest=msg.value;
672 	    }
673             //members can't become a VIP member after the initial period
674             if (setting_maxInvestors >77 && openPosition<77) throw;
675             //case : array not full, record new member
676             else if (openPosition!=999) investors[openPosition]=Investor(msg.sender, now);
677             //case : array full
678             else
679             {
680                 throw;
681             }
682         }
683         //already a member
684         else
685         {
686             netInvest=msg.value;
687             //is already above the max balance allowed or is sending
688 	    // too much refuse additional invest
689             if (balance[msg.sender]+msg.value>setting_maxInvestment)
690             {
691                 throw;
692             }
693 	    // this additionnal amount should be of at least 1/5 of "setting_minInvestment" (vs spam)
694 	    if (msg.value<setting_minInvestment/5) throw;
695         }
696 
697         // add to balance of member and to bankroll
698         // 10% of initial 77 VIP members investment is allocated to
699         // game developement provider chosen by Rouleth DAO
700 	// 90% to bankroll
701         //share that will be allocated to game dev
702         uint256 developmentAllocation;
703         developmentAllocation=10*netInvest/100; 
704         netInvest-=developmentAllocation;
705         //send game development allocation to Rouleth DAO or tech provider
706         if (developer.send(developmentAllocation)==false) throw;
707 
708 	// Apply extra entry fee once casino has been opened to extra members
709 	// that fee will be shared between the VIP members and represents the increment of
710 	// market value of their shares in Rouleth to outsiders
711 	// warning if a VIP adds to its initial invest after the casino has been opened to 
712 	// extra members he will pay have to pay this fee.
713         if (setting_maxInvestors>77)
714         {
715             // % of extra member's investment that rewards VIP funders
716             // Starts at 100%
717             // is set by a vote and computed when settings are changed
718             // to allow more investors
719             uint256 entryExtraCost=voted_extraInvestFeesRate*netInvest/100;
720             // add to VIP profit (to be shared by later call by dev.)
721             profitVIP += entryExtraCost;
722             netInvest-=entryExtraCost;
723         }
724         newInvest(msg.sender, msg.value, netInvest);//event log
725         balance[msg.sender]+=netInvest; //add to balance
726         payroll+=netInvest; //add to bankroll
727         updateMaxBet();
728         //refund potential excess
729         if (excess>0) 
730         {
731             if (msg.sender.send(excess)==false) throw;
732         }
733     }
734 
735 
736     //Allows to transfer your DAO account to another address
737     //target should not be currently a DAO member of rouleth
738     //enter twice the address to make sure you make no mistake.
739     //this can't be reversed if you don't own the target account
740     function transferInvestorAccount(address newInvestorAccountOwner, address newInvestorAccountOwner_confirm)
741     noEthSent
742     {
743         if (newInvestorAccountOwner!=newInvestorAccountOwner_confirm) throw;
744         if (newInvestorAccountOwner==0) throw;
745         //retrieve investor ID
746         uint16 investorID=999;
747         for (uint16 k = 0; k<setting_maxInvestors; k++)
748         {
749 	    //new address cant be of a current investor
750             if (investors[k].investor==newInvestorAccountOwner) throw;
751 
752 	    //retrieve investor id
753             if (investors[k].investor==msg.sender)
754             {
755                 investorID=k;
756             }
757         }
758         if (investorID==999) throw; //stop if not a member
759 	else
760 	    //accept and execute change of address
761 	    //votes on entryFeesRate are not transfered
762 	    //new address should vote again
763 	{
764 	    balance[newInvestorAccountOwner]=balance[msg.sender];
765 	    balance[msg.sender]=0;
766             investors[investorID].investor=newInvestorAccountOwner;
767 	}
768     }
769     
770     //***// Withdraw function (only after lockPeriod)
771     // input : amount to withdraw in Wei (leave empty for full withdraw)
772     // if your withdraw brings your balance under the min required,
773     // your balance is fully withdrawn
774     event withdraw(address player, uint withdraw_v);
775     
776     function withdrawInvestment(uint256 amountToWithdrawInWei)
777     noEthSent
778     {
779 	//vs spam withdraw min 1/10 of min
780 	if (amountToWithdrawInWei!=0 && amountToWithdrawInWei<setting_minInvestment/10) throw;
781         //before withdraw, update balances with the Profit and Loss sinceChange
782         updateBalances();
783 	//check that amount requested is authorized  
784 	if (amountToWithdrawInWei>balance[msg.sender]) throw;
785         //retrieve member ID
786         uint16 investorID=999;
787         for (uint16 k = 0; k<setting_maxInvestors; k++)
788         {
789             if (investors[k].investor==msg.sender)
790             {
791                 investorID=k;
792                 break;
793             }
794         }
795         if (investorID==999) throw; //stop if not a member
796         //check if investment lock period is over
797         if (investors[investorID].time+setting_lockPeriod>now) throw;
798         //if balance left after withdraw is still above min accept partial withdraw
799         if (balance[msg.sender]-amountToWithdrawInWei>=setting_minInvestment && amountToWithdrawInWei!=0)
800         {
801             balance[msg.sender]-=amountToWithdrawInWei;
802             payroll-=amountToWithdrawInWei;
803             //send amount to investor (with security if transaction fails)
804             if (msg.sender.send(amountToWithdrawInWei)==false) throw;
805 	    withdraw(msg.sender, amountToWithdrawInWei);
806         }
807         else
808             //if amountToWithdraw=0 : user wants full withdraw
809             //if balance after withdraw is < min invest, withdraw all and delete member
810         {
811             //send amount to member (with security if transaction fails)
812             uint256 fullAmount=balance[msg.sender];
813             payroll-=fullAmount;
814             balance[msg.sender]=0;
815 
816 	    //delete member
817             delete investors[investorID];
818             if (msg.sender.send(fullAmount)==false) throw;
819    	    withdraw(msg.sender, fullAmount);
820         }
821         updateMaxBet();
822     }
823 
824     //***// updates balances with Profit Losses when there is a withdraw/deposit
825     // can be called by dev for accounting when there are no more changes
826     function manualUpdateBalances_only_Dev()
827     noEthSent
828     onlyDeveloper
829     {
830 	updateBalances();
831     }
832     function updateBalances() private
833     {
834         //split Profits
835         uint256 profitToSplit;
836         uint256 lossToSplit;
837         if (profitSinceChange==0 && lossSinceChange==0)
838         { return; }
839         
840         else
841         {
842             // Case : Global profit (more win than losses)
843             // 20% fees for game development on global profit (if profit>loss)
844             if (profitSinceChange>lossSinceChange)
845             {
846                 profitToSplit=profitSinceChange-lossSinceChange;
847                 uint256 developerFees=profitToSplit*20/100;
848                 profitToSplit-=developerFees;
849                 if (developer.send(developerFees)==false) throw;
850             }
851             else
852             {
853                 lossToSplit=lossSinceChange-profitSinceChange;
854             }
855             
856             //share the loss and profits between all DAO members 
857             //(proportionnaly. to each one's balance)
858 
859             uint totalShared;
860             for (uint16 k=0; k<setting_maxInvestors; k++)
861             {
862                 address inv=investors[k].investor;
863                 if (inv==0) continue;
864                 else
865                 {
866                     if (profitToSplit!=0) 
867                     {
868                         uint profitShare=(profitToSplit*balance[inv])/payroll;
869                         balance[inv]+=profitShare;
870                         totalShared+=profitShare;
871                     }
872                     else if (lossToSplit!=0) 
873                     {
874                         uint lossShare=(lossToSplit*balance[inv])/payroll;
875                         balance[inv]-=lossShare;
876                         totalShared+=lossShare;
877                         
878                     }
879                 }
880             }
881             // update bankroll
882 	    // and handle potential very small left overs from integer div.
883             if (profitToSplit !=0) 
884             {
885 		payroll+=profitToSplit;
886 		balance[developer]+=profitToSplit-totalShared;
887             }
888             else if (lossToSplit !=0) 
889             {
890 		payroll-=lossToSplit;
891 		balance[developer]-=lossToSplit-totalShared;
892             }
893             profitSinceChange=0; //reset Profit;
894             lossSinceChange=0; //reset Loss ;
895         }
896     }
897     
898 
899     //VIP Voting on Extra Invest Fees Rate
900     //mapping records 100 - vote
901     mapping (address=>uint) hundredminus_extraInvestFeesRate;
902     // max fee is 99%
903     // a fee of 100% indicates that the VIP has never voted.
904     function voteOnNewEntryFees_only_VIP(uint8 extraInvestFeesRate_0_to_99)
905     noEthSent
906     {
907         if (extraInvestFeesRate_0_to_99<1 || extraInvestFeesRate_0_to_99>99) throw;
908         hundredminus_extraInvestFeesRate[msg.sender]=100-extraInvestFeesRate_0_to_99;
909     }
910 
911     uint256 payrollVIP;
912     uint256 voted_extraInvestFeesRate;
913     function computeResultVoteExtraInvestFeesRate() private
914     {
915         payrollVIP=0;
916         voted_extraInvestFeesRate=0;
917         //compute total payroll of the VIPs
918         //compute vote results among VIPs
919         for (uint8 k=0; k<77; k++)
920         {
921             if (investors[k].investor==0) continue;
922             else
923             {
924                 //don't count vote if the VIP never voted
925                 if (hundredminus_extraInvestFeesRate[investors[k].investor]==0) continue;
926                 else
927                 {
928                     payrollVIP+=balance[investors[k].investor];
929                     voted_extraInvestFeesRate+=hundredminus_extraInvestFeesRate[investors[k].investor]*balance[investors[k].investor];
930                 }
931             }
932         }
933 	//compute final result
934 	    if (payrollVIP!=0)
935 	    {
936             voted_extraInvestFeesRate=100-voted_extraInvestFeesRate/payrollVIP;
937      	    }
938     }
939 
940 
941     //Split the profits of the VIP members on extra members' contribution
942     uint profitVIP;
943     function splitProfitVIP_only_Dev()
944     noEthSent
945     onlyDeveloper
946     {
947         payrollVIP=0;
948         //compute total payroll of the VIPs
949         for (uint8 k=0; k<77; k++)
950         {
951             if (investors[k].investor==0) continue;
952             else
953             {
954                 payrollVIP+=balance[investors[k].investor];
955             }
956         }
957         //split the profits of the VIP members on extra member's contribution
958 	uint totalSplit;
959         for (uint8 i=0; i<77; i++)
960         {
961             if (investors[i].investor==0) continue;
962             else
963             {
964 		uint toSplit=balance[investors[i].investor]*profitVIP/payrollVIP;
965                 balance[investors[i].investor]+=toSplit;
966 		totalSplit+=toSplit;
967             }
968         }
969 	//take care of Integer Div remainders, and add to bankroll
970 	balance[developer]+=profitVIP-totalSplit;
971 	payroll+=profitVIP;
972 	//reset var profitVIP
973         profitVIP=0;
974     }
975 
976     
977     //INFORMATION FUNCTIONS
978     function checkProfitLossSinceInvestorChange() constant returns(uint profit_since_update_balances, uint loss_since_update_balances, uint profit_VIP_since_update_balances)
979     {
980         profit_since_update_balances=profitSinceChange;
981         loss_since_update_balances=lossSinceChange;
982         profit_VIP_since_update_balances=profitVIP;	
983         return;
984     }
985 
986     function checkInvestorBalance(address investor) constant returns(uint balanceInWei)
987     {
988         balanceInWei=balance[investor];
989         return;
990     }
991 
992     function getInvestorList(uint index) constant returns(address investor, uint endLockPeriod)
993     {
994         investor=investors[index].investor;
995         endLockPeriod=investors[index].time+setting_lockPeriod;
996         return;
997     }
998     
999     function investmentEntryInfos() constant returns(uint current_max_nb_of_investors, uint investLockPeriod, uint voted_Fees_Rate_on_extra_investments)
1000     {
1001     	investLockPeriod=setting_lockPeriod;
1002     	voted_Fees_Rate_on_extra_investments=voted_extraInvestFeesRate;
1003     	current_max_nb_of_investors=setting_maxInvestors;
1004     	return;
1005     }
1006     
1007     function getSettings() constant returns(uint maxBet, uint8 blockDelayBeforeSpin)
1008     {
1009     	maxBet=currentMaxGamble;
1010     	blockDelayBeforeSpin=blockDelay;
1011     	return ;
1012     }
1013 
1014     function getTotalGambles() constant returns(uint _totalGambles)
1015     {
1016         _totalGambles=totalGambles;
1017     	return ;
1018     }
1019     
1020     function getPayroll() constant returns(uint payroll_at_last_update_balances)
1021     {
1022         payroll_at_last_update_balances=payroll;
1023     	return ;
1024     }
1025 
1026     
1027     function checkMyBet(address player) constant returns(Status player_status, BetTypes bettype, uint8 input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb, uint blockSpin, uint gambleID)
1028     {
1029         player_status=playerStatus[player];
1030         bettype=gambles[gambleIndex[player]].betType;
1031         input=gambles[gambleIndex[player]].input;
1032         value=gambles[gambleIndex[player]].wager;
1033         result=gambles[gambleIndex[player]].wheelResult;
1034         wheelspinned=gambles[gambleIndex[player]].spinned;
1035         win=gambles[gambleIndex[player]].win;
1036         blockNb=gambles[gambleIndex[player]].blockNumber;
1037         blockSpin=gambles[gambleIndex[player]].blockSpinned;
1038     	gambleID=gambleIndex[player];
1039     	return;
1040     }
1041     
1042     function getGamblesList(uint256 index) constant returns(address player, BetTypes bettype, uint8 input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb, uint blockSpin)
1043     {
1044         player=gambles[index].player;
1045         bettype=gambles[index].betType;
1046         input=gambles[index].input;
1047         value=gambles[index].wager;
1048         result=gambles[index].wheelResult;
1049         wheelspinned=gambles[index].spinned;
1050         win=gambles[index].win;
1051     	blockNb=gambles[index].blockNumber;
1052         blockSpin=gambles[index].blockSpinned;
1053     	return;
1054     }
1055 
1056 } //end of contract