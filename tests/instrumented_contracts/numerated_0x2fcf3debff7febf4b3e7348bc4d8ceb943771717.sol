1 pragma solidity ^0.4.24;
2 
3 /**
4               _.-+.
5          _.-""     '.
6       :""       o    '.
7       |\       m       '.
8       | \     o       _.+
9       |  '.  F    _.-"  |
10       |    \  _.-"      |
11       |     +"       e  |
12        \    |      b    |
13         \   |    u     .+
14          \  |  C    .-'
15           \ |    .-'
16            \| .-'
17             +'
18             
19 This contract is an evolution of Fomo3D Long:
20 https://etherscan.io/address/0xa62142888aba8370742be823c1782d17a0389da1#code
21 https://fomo3d.hostedwiki.co/pages/FAQ
22 
23 Modifications:
24 - Replaced "PlayerBook" with FomoCube username contract
25 - Removed staking requirement
26 - Removed teams
27 - Removed airdrops
28 |
29 --- New ETH distribution:
30 // 50% for POLY holders, 20% for the jackpot
31 // 15% for CUBE holders, 10% for referrer or CUBE holders
32 // 5% for the developers <3
33 |
34 --- Replaced "Pot" system with a jackpot and "increment":
35 |
36 - The increment is the minimum purchase to become the leader (in POLY)
37 |
38 - The increment starts at 0 and increases by 100 for every ETH in the jackpot
39 |
40 - The jackpot is awarded to the leader when the timer runs out
41 |
42 - Each new leader increases the round timer by 30 minutes, and the maximum is 72 hours
43 |
44 - POLY follows the same price formula as "Fomo3D Long",
45 - thus the cost of becoming the leader is affected by price and increment
46 |
47 - For example:
48 ~~ Jackpot of 10 ETH --> Becoming the leader costs 0.14 ETH
49 ~~ Jackpot of 50 ETH --> Becoming the leader costs 1.44 ETH
50 ~~ Jackpot of 100 ETH -> Becoming the leader costs 4.02 ETH
51 |
52 ~~~
53   This system is designed to end the round before players lose interest.
54   The increasing cost of becoming the leader forces whales to fight for the jackpot -
55   - benefitting all previous buyers.
56 ~~~
57 |
58 >>> https://fomocube.io/
59 
60  */
61  
62 //==============================================================================
63 //     _    _  _ _|_ _  .
64 //    (/_\/(/_| | | _\  .
65 //==============================================================================
66 contract PolyFomoEvents {
67     // fired at end of buy or reload
68     event onEndTx
69     (
70         uint256 compressedData,     
71         uint256 compressedIDs,      
72         bytes32 playerName,
73         address playerAddress,
74         uint256 ethIn,
75         uint256 polyBought,
76         address winnerAddr,
77         bytes32 winnerName,
78         uint256 amountWon,
79         uint256 newPot,
80         uint256 cubeAmount,
81         uint256 genAmount,
82         uint256 potAmount
83     );
84     
85     // fired whenever theres a withdraw
86     event onWithdraw
87     (
88         uint256 indexed playerID,
89         address playerAddress,
90         bytes32 playerName,
91         uint256 ethOut,
92         uint256 timeStamp
93     );
94     
95     // fired whenever a withdraw forces end round to be ran
96     event onWithdrawAndDistribute
97     (
98         address playerAddress,
99         bytes32 playerName,
100         uint256 ethOut,
101         uint256 compressedData,
102         uint256 compressedIDs,
103         address winnerAddr,
104         bytes32 winnerName,
105         uint256 amountWon,
106         uint256 newPot
107     );
108     
109     // fired whenever a player tries a buy after round timer 
110     // hit zero, and causes end round to be ran.
111     event onBuyAndDistribute
112     (
113         address playerAddress,
114         bytes32 playerName,
115         uint256 ethIn,
116         uint256 compressedData,
117         uint256 compressedIDs,
118         address winnerAddr,
119         bytes32 winnerName,
120         uint256 amountWon,
121         uint256 newPot
122     );
123     
124     // fired whenever a player tries a reload after round timer 
125     // hit zero, and causes end round to be ran.
126     event onReLoadAndDistribute
127     (
128         address playerAddress,
129         bytes32 playerName,
130         uint256 compressedData,
131         uint256 compressedIDs,
132         address winnerAddr,
133         bytes32 winnerName,
134         uint256 amountWon,
135         uint256 newPot
136     );
137     
138     // fired whenever an affiliate is paid
139     event onAffiliatePayout
140     (
141         uint256 indexed affiliateID,
142         address affiliateAddress,
143         bytes32 affiliateName,
144         uint256 indexed roundID,
145         uint256 indexed buyerID,
146         uint256 amount,
147         uint256 timeStamp
148     );
149 }
150 
151 //==============================================================================
152 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
153 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
154 //====================================|=========================================
155 
156 contract modularLong is PolyFomoEvents {}
157 
158 contract PolyFomo is modularLong {
159     using SafeMath for *;
160     using PolygonCalcLong for uint256;
161     
162     address private comAddress_;
163     CubeInterface private cube;
164     UsernameInterface private username;
165     
166 //==============================================================================
167 //     _ _  _  |`. _     _ _ |_ | _  _  .
168 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
169 //=================_|===========================================================
170     string constant public name = "PolyFomo";
171     string constant public symbol = "POLY";
172     uint256 constant private rndExtra_ = 24 hours;              // Countdown before open
173     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
174     uint256 constant private rndInc_ = 30 minutes;              // every new leader adds 30 minutes to the timer
175     uint256 constant private rndMax_ = 72 hours;                // max length a round timer can be
176     
177 //==============================================================================
178 //     _| _ _|_ _    _ _ _|_    _   .
179 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
180 //=============================|================================================
181     uint256 public rID_;    // round id number / total rounds that have happened
182     uint256 public pID_;  // total number of players
183 //****************
184 // PLAYER DATA 
185 //****************
186     mapping (address => uint256) public pIDxAddr_;                                               // (addr => pID) returns player id by address
187     mapping (uint256 => PolyFomoDatasets.Player) public plyr_;                                   // (pID => data) player data
188     mapping (uint256 => mapping (uint256 => PolyFomoDatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
189 
190 //****************
191 // ROUND DATA 
192 //****************
193     mapping (uint256 => PolyFomoDatasets.Round) public round_;              // (rID => data) round data
194     uint256 public rndEth_;
195 //****************
196 // TEAM FEE DATA 
197 //****************
198 //==============================================================================
199 //     _ _  _  __|_ _    __|_ _  _  .
200 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
201 //==============================================================================
202     constructor(address usernameAddress, address cubeAddress, address comAddress)
203         public
204     {
205         username = UsernameInterface(usernameAddress);
206         cube = CubeInterface(cubeAddress);
207         comAddress_ = comAddress;
208         
209         // PURCHASES
210         // 50% for POLY holders, 20% for jackpot, 15% for CUBE holders, 10% for referral or CUBE holders, 5% dev fee
211         
212         // Open the gates
213         rID_ = 1;
214         round_[1].strt = cube.startTime() + rndExtra_;
215         round_[1].end = cube.startTime() + rndInit_ + rndExtra_;
216 	}
217 //==============================================================================
218 //     _ _  _  _|. |`. _  _ _  .
219 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
220 //==============================================================================
221 
222     /**
223      * @dev prevents contracts from interacting with fomo3d 
224      */
225     modifier isHuman() {
226         require(tx.origin == msg.sender);
227         _;
228     }
229 
230     /**
231      * @dev sets boundaries for incoming tx 
232      */
233     modifier isWithinLimits(uint256 _eth) {
234         require(_eth >= 1000000000, "pocket lint: not a valid currency");
235         require(_eth <= 100000000000000000000000, "no vitalik, no");
236         _;    
237     }
238     
239 //==============================================================================
240 //     _    |_ |. _   |`    _  __|_. _  _  _  .
241 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
242 //====|=========================================================================
243     /**
244      * @dev emergency buy uses last stored affiliate ID
245      */
246     function()
247         isHuman()
248         isWithinLimits(msg.value)
249         public
250         payable
251     {
252         // set up our tx event data and determine if player is new or not
253         PolyFomoDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
254             
255         // fetch player id
256         uint256 _pID = pIDxAddr_[msg.sender];
257         
258         // buy core 
259         buyCore(_pID, plyr_[_pID].laff, _eventData_);
260     }
261     
262     /**
263      * @dev converts all incoming ethereum to poly.
264      * @param _affCode the ID/address/name of the player who gets the affiliate fee
265      */
266     
267     function buyXaddr(address _affCode)
268         isHuman()
269         isWithinLimits(msg.value)
270         public
271         payable
272     {
273         // set up our tx event data and determine if player is new or not
274         PolyFomoDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
275         
276         // fetch player id
277         uint256 _pID = pIDxAddr_[msg.sender];
278         
279         // manage affiliate residuals
280         uint256 _affID;
281         // if no affiliate code was given or player tried to use their own, lolz
282         if (_affCode == address(0) || _affCode == msg.sender)
283         {
284             // use last stored affiliate code
285             _affID = plyr_[_pID].laff;
286         
287         // if affiliate code was given    
288         } else {
289             // get affiliate ID from aff Code 
290             _affID = pIDxAddr_[_affCode];
291             
292             if (_affID == 0) {
293                 _affID = registerReferrer(_affCode);
294             }
295             
296             // if affID is not the same as previously stored 
297             if (_affID != plyr_[_pID].laff)
298             {
299                 // update last affiliate
300                 plyr_[_pID].laff = _affID;
301             }
302         }
303         
304         // buy core 
305         buyCore(_pID, _affID, _eventData_);
306     }
307     
308     /**
309      * @dev essentially the same as buy, but instead of you sending ether 
310      * from your wallet, it uses your unwithdrawn earnings.
311      * @param _affCode the ID/address/name of the player who gets the affiliate fee
312      * @param _eth amount of earnings to use (remainder returned to gen vault)
313      */
314     
315     function reLoadXaddr(address _affCode, uint256 _eth)
316         isHuman()
317         isWithinLimits(_eth)
318         public
319     {
320         // set up our tx event data
321         PolyFomoDatasets.EventReturns memory _eventData_;
322         
323         // fetch player ID
324         uint256 _pID = pIDxAddr_[msg.sender];
325         
326         // manage affiliate residuals
327         uint256 _affID;
328         // if no affiliate code was given or player tried to use their own, lolz
329         if (_affCode == address(0) || _affCode == msg.sender)
330         {
331             // use last stored affiliate code
332             _affID = plyr_[_pID].laff;
333         
334         // if affiliate code was given    
335         } else {
336             // get affiliate ID from aff Code 
337             _affID = pIDxAddr_[_affCode];
338             
339             // set up new referrer if necessary
340             if (_affID == 0) {
341                 _affID = registerReferrer(_affCode);
342             }
343             // if affID is not the same as previously stored 
344             if (_affID != plyr_[_pID].laff)
345             {
346                 // update last affiliate
347                 plyr_[_pID].laff = _affID;
348             }
349         }
350         
351         // reload core
352         reLoadCore(_pID, _affID, _eth, _eventData_);
353     }
354 
355     /**
356      * @dev withdraws all of your earnings.
357      */
358     function withdraw()
359         isHuman()
360         public
361     {
362         // setup local rID 
363         uint256 _rID = rID_;
364         
365         // grab time
366         uint256 _now = now;
367         
368         // fetch player ID
369         uint256 _pID = pIDxAddr_[msg.sender];
370         
371         // setup temp var for player eth
372         uint256 _eth;
373         
374         // check to see if round has ended and no one has run round end yet
375         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
376         {
377             // set up our tx event data
378             PolyFomoDatasets.EventReturns memory _eventData_;
379             
380             // end the round (distributes pot)
381             round_[_rID].ended = true;
382             _eventData_ = endRound(_eventData_);
383             
384             // get their earnings
385             _eth = withdrawEarnings(_pID);
386             
387             // gib moni
388             if (_eth > 0)
389                 plyr_[_pID].addr.transfer(_eth);    
390             
391             // build event data
392             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
393             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
394             
395             // fire withdraw and distribute event
396             emit PolyFomoEvents.onWithdrawAndDistribute
397             (
398                 msg.sender, 
399                 username.getNameByAddress(plyr_[_pID].addr), 
400                 _eth, 
401                 _eventData_.compressedData, 
402                 _eventData_.compressedIDs, 
403                 _eventData_.winnerAddr, 
404                 _eventData_.winnerName, 
405                 _eventData_.amountWon, 
406                 _eventData_.newPot
407             );
408             
409         // in any other situation
410         } else {
411             // get their earnings
412             _eth = withdrawEarnings(_pID);
413             
414             // gib moni
415             if (_eth > 0)
416                 plyr_[_pID].addr.transfer(_eth);
417             
418             // fire withdraw event
419             emit PolyFomoEvents.onWithdraw(_pID, msg.sender, username.getNameByAddress(plyr_[_pID].addr), _eth, _now);
420         }
421     }
422     
423 //==============================================================================
424 //     _  _ _|__|_ _  _ _  .
425 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
426 //=====_|=======================================================================
427 
428     /**
429      * @dev return minimum purchase in POLY for 1 timer increment
430      * @return minimum purchase in POLY for 1 timer increment (in wei format)
431      */
432 
433     function getIncrementPrice()
434         public 
435         view
436         returns(uint256)
437     {  
438         // setup local rID
439         uint256 _rID = rID_;
440         
441         // grab pot
442         uint256 _pot = round_[_rID].pot;
443         
444         return (_pot / 1000000000000000000).mul(100000000000000000000);
445     }
446 
447     /**
448      * @dev return the price buyer will pay for next 1 individual poly.
449      * @return price for next poly bought (in wei format)
450      */
451     function getBuyPrice()
452         public 
453         view 
454         returns(uint256)
455     {  
456         // setup local rID
457         uint256 _rID = rID_;
458         
459         // grab time
460         uint256 _now = now;
461         
462         // are we in a round?
463         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
464             return ( (round_[_rID].poly.add(1000000000000000000)).ethRec(1000000000000000000) );
465         else // rounds over.  need price for new round
466             return ( 75000000000000 ); // init
467     }
468     
469     /**
470      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
471      * provider
472      * @return time left in seconds
473      */
474     function getTimeLeft()
475         public
476         view
477         returns(uint256)
478     {
479         // setup local rID
480         uint256 _rID = rID_;
481         
482         // grab time
483         uint256 _now = now;
484         
485         if (_now < round_[_rID].end)
486             if (_now > round_[_rID].strt)
487                 return( (round_[_rID].end).sub(_now) );
488             else
489                 return( (round_[_rID].strt).sub(_now) );
490         else
491             return(0);
492     }
493     
494     /**
495      * @dev returns player earnings per vaults 
496      * @return winnings vault
497      * @return general vault
498      * @return affiliate vault
499      */
500     function getPlayerVaults(uint256 _pID)
501         public
502         view
503         returns(uint256 ,uint256, uint256)
504     {
505         // setup local rID
506         uint256 _rID = rID_;
507         
508         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
509         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
510         {
511             // if player is winner 
512             if (round_[_rID].plyr == _pID)
513             {
514                 return
515                 (
516                     (plyr_[_pID].win).add(round_[_rID].pot),
517                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
518                     plyr_[_pID].aff
519                 );
520             // if player is not the winner
521             } else {
522                 return
523                 (
524                     plyr_[_pID].win,
525                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
526                     plyr_[_pID].aff
527                 );
528             }
529             
530         // if round is still going on, or round has ended and round end has been ran
531         } else {
532             return
533             (
534                 plyr_[_pID].win,
535                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
536                 plyr_[_pID].aff
537             );
538         }
539     }
540     
541     /**
542      * solidity hates stack limits.  this lets us avoid that hate 
543      */
544     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
545         private
546         view
547         returns(uint256)
548     {
549         return round_[_rID].mask.mul(plyrRnds_[_pID][_rID].poly) / 1000000000000000000;
550     }
551     
552     /**
553      * @dev returns all current round info needed for front end
554      * @return round id 
555      * @return total poly for round 
556      * @return time round ends
557      * @return time round started
558      * @return current pot 
559      * @return current player in leads address 
560      * @return current player in leads name
561      * @return eth spent in current round
562      */
563     function getCurrentRoundInfo()
564         public
565         view
566         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
567     {
568         // setup local rID
569         uint256 _rID = rID_;
570         
571         return
572         (
573             _rID,                                                     //0
574             round_[_rID].poly,                                        //1
575             round_[_rID].end,                                         //2
576             round_[_rID].strt,                                        //3
577             round_[_rID].pot,                                         //4
578             plyr_[round_[_rID].plyr].addr,                            //5
579             username.getNameByAddress(plyr_[round_[_rID].plyr].addr), //6
580             rndEth_                                                   //7
581         );
582     }
583 
584     /**
585      * @dev returns player info based on address.  if no address is given, it will 
586      * use msg.sender 
587      * @param _addr address of the player you want to lookup 
588      * @return player ID 
589      * @return player name
590      * @return poly owned (current round)
591      * @return winnings vault
592      * @return general vault 
593      * @return affiliate vault 
594      * @return player round eth
595      */
596     function getPlayerInfoByAddress(address _addr)
597         public 
598         view 
599         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
600     {
601         // setup local rID
602         uint256 _rID = rID_;
603         
604         if (_addr == address(0))
605         {
606             _addr == msg.sender;
607         }
608         uint256 _pID = pIDxAddr_[_addr];
609         
610         return
611         (
612             _pID,                               //0
613             username.getNameByAddress(_addr),   //1
614             plyrRnds_[_pID][_rID].poly,         //2
615             plyr_[_pID].win,                    //3
616             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
617             plyr_[_pID].aff,                    //5
618             plyrRnds_[_pID][_rID].eth           //6
619         );
620     }
621 
622 //==============================================================================
623 //     _ _  _ _   | _  _ . _  .
624 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
625 //=====================_|=======================================================
626     /**
627      * @dev logic runs whenever a buy order is executed.  determines how to handle 
628      * incoming eth depending on if we are in an active round or not
629      */
630     function buyCore(uint256 _pID, uint256 _affID, PolyFomoDatasets.EventReturns memory _eventData_)
631         private
632     {
633         // setup local rID
634         uint256 _rID = rID_;
635         
636         // grab time
637         uint256 _now = now;
638         // if round is active
639         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
640         {
641             // call core 
642             core(_rID, _pID, msg.value, _affID, _eventData_);
643         
644         // if round is not active     
645         } else {
646             // check to see if end round needs to be ran
647             if (_now > round_[_rID].end && round_[_rID].ended == false) 
648             {
649                 // end the round (distributes pot) & start new round
650                 round_[_rID].ended = true;
651                 _eventData_ = endRound(_eventData_);
652                 
653                 // build event data
654                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
655                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
656                 
657                 // fire buy and distribute event 
658                 emit PolyFomoEvents.onBuyAndDistribute
659                 (
660                     msg.sender, 
661                     username.getNameByAddress(plyr_[_pID].addr), 
662                     msg.value, 
663                     _eventData_.compressedData, 
664                     _eventData_.compressedIDs, 
665                     _eventData_.winnerAddr, 
666                     _eventData_.winnerName, 
667                     _eventData_.amountWon, 
668                     _eventData_.newPot
669                 );
670             }
671             
672             // put eth in players vault 
673             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
674         }
675     }
676     
677     /**
678      * @dev logic runs whenever a reload order is executed.  determines how to handle 
679      * incoming eth depending on if we are in an active round or not 
680      */
681     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, PolyFomoDatasets.EventReturns memory _eventData_)
682         private
683     {
684         // setup local rID
685         uint256 _rID = rID_;
686         
687         // grab time
688         uint256 _now = now;
689         
690         // if round is active
691         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
692         {
693             // get earnings from all vaults and return unused to gen vault
694             // because we use a custom safemath library.  this will throw if player 
695             // tried to spend more eth than they have.
696             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
697             
698             // call core 
699             core(_rID, _pID, _eth, _affID, _eventData_);
700         
701         // if round is not active and end round needs to be ran   
702         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
703             // end the round (distributes pot) & start new round
704             round_[_rID].ended = true;
705             _eventData_ = endRound(_eventData_);
706                 
707             // build event data
708             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
709             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
710                 
711             // fire buy and distribute event 
712             emit PolyFomoEvents.onReLoadAndDistribute
713             (
714                 msg.sender, 
715                 username.getNameByAddress(plyr_[_pID].addr), 
716                 _eventData_.compressedData, 
717                 _eventData_.compressedIDs, 
718                 _eventData_.winnerAddr, 
719                 _eventData_.winnerName, 
720                 _eventData_.amountWon, 
721                 _eventData_.newPot
722             );
723         }
724     }
725     
726     /**
727      * @dev this is the core logic for any buy/reload that happens while a round 
728      * is live.
729      */
730     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, PolyFomoDatasets.EventReturns memory _eventData_)
731         private
732     {
733         // if player is new to round
734         if (plyrRnds_[_pID][_rID].poly == 0)
735             _eventData_ = managePlayer(_pID, _eventData_);
736         
737         // early round eth limiter 
738         if (round_[_rID].eth < 30000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
739         {
740             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
741             uint256 _refund = _eth.sub(_availableLimit);
742             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
743             _eth = _availableLimit;
744         }
745         
746         // if eth left is greater than min eth allowed (sorry no pocket lint)
747         if (_eth > 1000000000) 
748         {
749             
750             // mint the new poly
751             uint256 _poly = (round_[_rID].eth).polyRec(_eth);
752             
753             if (_poly >= getIncrementPrice())
754             {
755                 updateTimer(_rID);
756 
757                 // set new leaders
758                 if (round_[_rID].plyr != _pID)
759                     round_[_rID].plyr = _pID;  
760                 
761                 // set the new leader bool to true
762                 _eventData_.compressedData = _eventData_.compressedData + 100;
763             }
764             
765             // update player 
766             plyrRnds_[_pID][_rID].poly = _poly.add(plyrRnds_[_pID][_rID].poly);
767             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
768             
769             // update round
770             round_[_rID].poly = _poly.add(round_[_rID].poly);
771             round_[_rID].eth = _eth.add(round_[_rID].eth);
772             rndEth_ = _eth.add(rndEth_);
773     
774             // distribute eth
775             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
776             _eventData_ = distributeInternal(_rID, _pID, _eth, _poly, _eventData_);
777             
778             // call end tx function to fire end tx event.
779             endTx(_pID, _eth, _poly, _eventData_);
780         }
781     }
782 //==============================================================================
783 //     _ _ | _   | _ _|_ _  _ _  .
784 //    (_(_||(_|_||(_| | (_)| _\  .
785 //==============================================================================
786     /**
787      * @dev calculates unmasked earnings (just calculates, does not update mask)
788      * @return earnings in wei format
789      */
790     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
791         private
792         view
793         returns(uint256)
794     {
795         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].poly)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
796     }
797     
798     /** 
799      * @dev returns the amount of poly you would get given an amount of eth. 
800      * @param _rID round ID you want price for
801      * @param _eth amount of eth sent in 
802      * @return poly received 
803      */
804     function calcPolyReceived(uint256 _rID, uint256 _eth)
805         public
806         view
807         returns(uint256)
808     {
809         // grab time
810         uint256 _now = now;
811         
812         // are we in a round?
813         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
814             return ( (round_[_rID].eth).polyRec(_eth) );
815         else // rounds over.  need poly for new round
816             return ( (_eth).poly() );
817     }
818     
819     /** 
820      * @dev returns current eth price for X poly.  
821      * @param _poly number of poly desired (in 18 decimal format)
822      * @return amount of eth needed to send
823      */
824     function iWantXPoly(uint256 _poly)
825         public
826         view
827         returns(uint256)
828     {
829         // setup local rID
830         uint256 _rID = rID_;
831         
832         // grab time
833         uint256 _now = now;
834         
835         // are we in a round?
836         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
837             return ( (round_[_rID].poly.add(_poly)).ethRec(_poly) );
838         else // rounds over.  need price for new round
839             return ( (_poly).eth() );
840     }
841 //==============================================================================
842 //    _|_ _  _ | _  .
843 //     | (_)(_)|_\  .
844 //==============================================================================
845         
846     /**
847      * @dev gets existing or registers new pID.  use this when a player may be new
848      * @return pID 
849      */
850     function determinePID(PolyFomoDatasets.EventReturns memory _eventData_)
851         private
852         returns (PolyFomoDatasets.EventReturns memory)
853     {
854         uint256 _pID = pIDxAddr_[msg.sender];
855 
856         if (_pID == 0)
857         {
858             pID_++;
859             pIDxAddr_[msg.sender] = pID_;
860             plyr_[pID_].addr = msg.sender;
861             
862             // set the new player bool to true
863             _eventData_.compressedData = _eventData_.compressedData + 1;
864         }
865         
866         return (_eventData_);
867     }
868     
869     /**
870      * @dev registers a non-player referrer
871      * @return pID 
872      */
873     function registerReferrer(address _affCode)
874         private
875         returns (uint256 affID)
876     {
877         pID_++;
878         pIDxAddr_[_affCode] = pID_;
879         plyr_[pID_].addr = _affCode;
880         
881         return pID_;
882     }
883     
884     /**
885      * @dev decides if round end needs to be run & new round started.  and if 
886      * player unmasked earnings from previously played rounds need to be moved.
887      */
888     function managePlayer(uint256 _pID, PolyFomoDatasets.EventReturns memory _eventData_)
889         private
890         returns (PolyFomoDatasets.EventReturns memory)
891     {
892         // if player has played a previous round, move their unmasked earnings
893         // from that round to gen vault.
894         if (plyr_[_pID].lrnd != 0)
895             updateGenVault(_pID, plyr_[_pID].lrnd);
896             
897         // update player's last round played
898         plyr_[_pID].lrnd = rID_;
899             
900         // set the joined round bool to true
901         _eventData_.compressedData = _eventData_.compressedData + 10;
902         
903         return(_eventData_);
904     }
905     
906     /**
907      * @dev ends the round. manages paying out winner/splitting up pot
908      */
909     function endRound(PolyFomoDatasets.EventReturns memory _eventData_)
910         private
911         returns (PolyFomoDatasets.EventReturns memory)
912     {
913         // setup local rID
914         uint256 _rID = rID_;
915         
916         // grab our winning player
917         uint256 _winPID = round_[_rID].plyr;
918         
919         // Entire 20% of buys / pot value
920         uint256 _win = round_[_rID].pot;
921 
922         // pay our winner
923         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
924         
925         // prepare event data
926         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
927         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
928         _eventData_.winnerAddr = plyr_[_winPID].addr;
929         _eventData_.winnerName = username.getNameByAddress(plyr_[_winPID].addr);
930         _eventData_.amountWon = _win;
931         _eventData_.newPot = 0;
932         
933         // start next round
934         rID_++;
935         _rID++;
936         round_[_rID].strt = now;
937         round_[_rID].end = now.add(rndInit_);
938         round_[_rID].pot = 0;
939         
940         return(_eventData_);
941     }
942     
943     /**
944      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
945      */
946     function updateGenVault(uint256 _pID, uint256 _rIDlast)
947         private 
948     {
949         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
950         if (_earnings > 0)
951         {
952             // put in gen vault
953             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
954             // zero out their earnings by updating mask
955             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
956         }
957     }
958     
959     /**
960      * @dev increment timer if poly requirement is met
961      */
962     function updateTimer(uint256 _rID)
963         private
964     {
965         // grab time
966         uint256 _now = now;
967         
968         // calculate time based on number of poly bought
969         uint256 _newTime;
970         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
971             _newTime = rndInc_.add(_now);
972         else
973             _newTime = rndInc_.add(round_[_rID].end);
974         
975         // compare to max and set new end time
976         if (_newTime < (rndMax_).add(_now))
977             round_[_rID].end = _newTime;
978         else
979             round_[_rID].end = rndMax_.add(_now);
980     }
981 
982     /**
983      * @dev distributes eth based on fees to com, aff, and cube
984      */
985     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, PolyFomoDatasets.EventReturns memory _eventData_)
986         private
987         returns(PolyFomoDatasets.EventReturns memory)
988     {       
989         uint256 _cube;
990     
991         // 5% for the developers :)
992         uint256 _com = _eth / 20;
993         comAddress_.transfer(_com);
994         
995         // 10% for aff or CUBE holders
996         uint256 _aff = _eth / 10;
997         
998         if (_affID != _pID && _affID != 0) {
999             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1000             emit PolyFomoEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, username.getNameByAddress(plyr_[_affID].addr), _rID, _pID, _aff, now);
1001         } else {
1002             _cube = _aff;
1003         }
1004         
1005         // 15% for CUBE holders
1006         _cube = _cube.add((_eth.mul(15)) / (100));
1007         if (_cube > 0)
1008         {
1009             // distribute to CUBE
1010             cube.distribute.value(_cube)();
1011             
1012             // set up event data
1013             _eventData_.cubeAmount = _cube.add(_eventData_.cubeAmount);
1014         }
1015         
1016         return(_eventData_);
1017     }
1018 
1019     /**
1020      * @dev distributes eth based on fees to gen and pot
1021      */
1022     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _poly, PolyFomoDatasets.EventReturns memory _eventData_)
1023         private
1024         returns(PolyFomoDatasets.EventReturns memory)
1025     {
1026         // 50% for POLY holders
1027         uint256 _gen = (_eth.mul(50)) / 100;
1028         
1029         // update eth balance (eth = eth - (developers (5%) + aff share (10%)) + cube share (15%))
1030         _eth = _eth.sub((_eth.mul(30)) / 100);
1031         
1032         // 20% for winner
1033         uint256 _pot = _eth.sub(_gen);
1034         
1035         // distribute gen share (thats what updateMasks() does) and adjust
1036         // balances for dust.
1037         uint256 _dust = updateMasks(_rID, _pID, _gen, _poly);
1038         if (_dust > 0)
1039             _gen = _gen.sub(_dust);
1040         
1041         // add the 20% + dust
1042         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1043         
1044         // set up event data
1045         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1046         _eventData_.potAmount = _pot;
1047         
1048         return(_eventData_);
1049     }
1050     
1051     /**
1052      * @dev updates masks for round and player when poly are bought
1053      * @return dust left over 
1054      */
1055     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _poly)
1056         private
1057         returns(uint256)
1058     {
1059         /* MASKING NOTES
1060             earnings masks are a tricky thing for people to wrap their minds around.
1061             the basic thing to understand here.  is were going to have a global
1062             tracker based on profit per share for each round, that increases in
1063             relevant proportion to the increase in share supply.
1064             
1065             the player will have an additional mask that basically says "based
1066             on the rounds mask, my shares, and how much i've already withdrawn,
1067             how much is still owed to me?"
1068         */
1069         
1070         // calc profit per poly & round mask based on this buy:  (dust goes to pot)
1071         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].poly);
1072         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1073             
1074         // calculate player earning from their own buy (only based on the poly
1075         // they just bought).  & update player earnings mask
1076         uint256 _pearn = (_ppt.mul(_poly)) / (1000000000000000000);
1077         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_poly)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1078         
1079         // calculate & return dust
1080         return(_gen.sub((_ppt.mul(round_[_rID].poly)) / (1000000000000000000)));
1081     }
1082     
1083     /**
1084      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1085      * @return earnings in wei format
1086      */
1087     function withdrawEarnings(uint256 _pID)
1088         private
1089         returns(uint256)
1090     {
1091         // update gen vault
1092         updateGenVault(_pID, plyr_[_pID].lrnd);
1093         
1094         // from vaults 
1095         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1096         if (_earnings > 0)
1097         {
1098             plyr_[_pID].win = 0;
1099             plyr_[_pID].gen = 0;
1100             plyr_[_pID].aff = 0;
1101         }
1102 
1103         return(_earnings);
1104     }
1105     
1106     /**
1107      * @dev prepares compression data and fires event for buy or reload tx's
1108      */
1109     function endTx(uint256 _pID, uint256 _eth, uint256 _poly, PolyFomoDatasets.EventReturns memory _eventData_)
1110         private
1111     {
1112         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1113         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1114         
1115         emit PolyFomoEvents.onEndTx
1116         (
1117             _eventData_.compressedData,
1118             _eventData_.compressedIDs,
1119             username.getNameByAddress(plyr_[_pID].addr),
1120             msg.sender,
1121             _eth,
1122             _poly,
1123             _eventData_.winnerAddr,
1124             _eventData_.winnerName,
1125             _eventData_.amountWon,
1126             _eventData_.newPot,
1127             _eventData_.cubeAmount,
1128             _eventData_.genAmount,
1129             _eventData_.potAmount
1130         );
1131     }
1132 }
1133 
1134 //==============================================================================
1135 //   __|_ _    __|_ _  .
1136 //  _\ | | |_|(_ | _\  .
1137 //==============================================================================
1138 library PolyFomoDatasets {
1139     struct EventReturns {
1140         uint256 compressedData;
1141         uint256 compressedIDs;
1142         address winnerAddr;         // winner address
1143         bytes32 winnerName;         // winner name
1144         uint256 amountWon;          // amount won
1145         uint256 newPot;             // amount in new pot
1146         uint256 cubeAmount;         // amount distributed to cube
1147         uint256 genAmount;          // amount distributed to gen
1148         uint256 potAmount;          // amount added to pot
1149     }
1150     struct Player {
1151         address addr;   // player address
1152         bytes32 name;   // player name
1153         uint256 win;    // winnings vault
1154         uint256 gen;    // general vault
1155         uint256 aff;    // affiliate vault
1156         uint256 lrnd;   // last round played
1157         uint256 laff;   // last affiliate id used
1158     }
1159     struct PlayerRounds {
1160         uint256 eth;    // eth player has added to round (used for eth limiter)
1161         uint256 poly;   // poly
1162         uint256 mask;   // player mask 
1163     }
1164     struct Round {
1165         uint256 plyr;   // pID of player in lead
1166         uint256 end;    // time ends/ended
1167         bool ended;     // has round end function been ran
1168         uint256 strt;   // time round started
1169         uint256 poly;   // poly
1170         uint256 eth;    // total eth in
1171         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1172         uint256 mask;   // global mask
1173     }
1174 }
1175 
1176 //==============================================================================
1177 //  |  _      _ _ | _  .
1178 //  |<(/_\/  (_(_||(_  .
1179 //=======/======================================================================
1180 library PolygonCalcLong {
1181     using SafeMath for *;
1182     /**
1183      * @dev calculates number of poly received given X eth 
1184      * @param _curEth current amount of eth in contract 
1185      * @param _newEth eth being spent
1186      * @return amount of ticket purchased
1187      */
1188     function polyRec(uint256 _curEth, uint256 _newEth)
1189         internal
1190         pure
1191         returns (uint256)
1192     {
1193         return(poly((_curEth).add(_newEth)).sub(poly(_curEth)));
1194     }
1195     
1196     /**
1197      * @dev calculates amount of eth received if you sold X poly 
1198      * @param _curPoly current amount of poly that exist 
1199      * @param _sellPoly amount of poly you wish to sell
1200      * @return amount of eth received
1201      */
1202     function ethRec(uint256 _curPoly, uint256 _sellPoly)
1203         internal
1204         pure
1205         returns (uint256)
1206     {
1207         return((eth(_curPoly)).sub(eth(_curPoly.sub(_sellPoly))));
1208     }
1209 
1210     /**
1211      * @dev calculates how many poly would exist with given an amount of eth
1212      * @param _eth eth "in contract"
1213      * @return number of poly that would exist
1214      */
1215     function poly(uint256 _eth) 
1216         internal
1217         pure
1218         returns(uint256)
1219     {
1220         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1221     }
1222     
1223     /**
1224      * @dev calculates how much eth would be in contract given a number of poly
1225      * @param _poly number of poly "in contract" 
1226      * @return eth that would exists
1227      */
1228     function eth(uint256 _poly) 
1229         internal
1230         pure
1231         returns(uint256)  
1232     {
1233         return ((78125000).mul(_poly.sq()).add(((149999843750000).mul(_poly.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1234     }
1235 }
1236 
1237 //==============================================================================
1238 //  . _ _|_ _  _ |` _  _ _  _  .
1239 //  || | | (/_| ~|~(_|(_(/__\  .
1240 //==============================================================================
1241 
1242 interface UsernameInterface {
1243     function getNameByAddress(address _addr) external view returns (bytes32);
1244 }
1245 
1246 interface CubeInterface {
1247     function distribute() external payable;
1248     function startTime() external view returns (uint256);
1249 }
1250 
1251 /**
1252  * @title SafeMath v0.1.9
1253  * @dev Math operations with safety checks that throw on error
1254  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1255  * - added sqrt
1256  * - added sq
1257  * - added pwr 
1258  * - changed asserts to requires with error log outputs
1259  * - removed div, its useless
1260  */
1261 library SafeMath {
1262     
1263     /**
1264     * @dev Multiplies two numbers, throws on overflow.
1265     */
1266     function mul(uint256 a, uint256 b) 
1267         internal 
1268         pure 
1269         returns (uint256 c) 
1270     {
1271         if (a == 0) {
1272             return 0;
1273         }
1274         c = a * b;
1275         require(c / a == b, "SafeMath mul failed");
1276         return c;
1277     }
1278 
1279     /**
1280     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1281     */
1282     function sub(uint256 a, uint256 b)
1283         internal
1284         pure
1285         returns (uint256) 
1286     {
1287         require(b <= a, "SafeMath sub failed");
1288         return a - b;
1289     }
1290 
1291     /**
1292     * @dev Adds two numbers, throws on overflow.
1293     */
1294     function add(uint256 a, uint256 b)
1295         internal
1296         pure
1297         returns (uint256 c) 
1298     {
1299         c = a + b;
1300         require(c >= a, "SafeMath add failed");
1301         return c;
1302     }
1303     
1304     /**
1305      * @dev gives square root of given x.
1306      */
1307     function sqrt(uint256 x)
1308         internal
1309         pure
1310         returns (uint256 y) 
1311     {
1312         uint256 z = ((add(x,1)) / 2);
1313         y = x;
1314         while (z < y) 
1315         {
1316             y = z;
1317             z = ((add((x / z),z)) / 2);
1318         }
1319     }
1320     
1321     /**
1322      * @dev gives square. multiplies x by x
1323      */
1324     function sq(uint256 x)
1325         internal
1326         pure
1327         returns (uint256)
1328     {
1329         return (mul(x,x));
1330     }
1331     
1332     /**
1333      * @dev x to the power of y 
1334      */
1335     function pwr(uint256 x, uint256 y)
1336         internal 
1337         pure 
1338         returns (uint256)
1339     {
1340         if (x==0)
1341             return (0);
1342         else if (y==0)
1343             return (1);
1344         else 
1345         {
1346             uint256 z = x;
1347             for (uint256 i=1; i < y; i++)
1348                 z = mul(z,x);
1349             return (z);
1350         }
1351     }
1352 }