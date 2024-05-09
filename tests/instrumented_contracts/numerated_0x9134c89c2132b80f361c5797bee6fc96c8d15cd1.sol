1 pragma solidity ^0.4.24;
2 
3 contract F3Devents {
4     // fired whenever a player registers a name
5     event onNewName
6     (
7         uint256 indexed playerID,
8         address indexed playerAddress,
9         bytes32 indexed playerName,
10         bool isNewPlayer,
11         uint256 affiliateID,
12         address affiliateAddress,
13         bytes32 affiliateName,
14         uint256 amountPaid,
15         uint256 timeStamp
16     );
17 
18     // fired at end of buy or reload
19     event onEndTx
20     (
21         uint256 compressedData,
22         uint256 compressedIDs,
23         bytes32 playerName,
24         address playerAddress,
25         uint256 ethIn,
26         uint256 keysBought,
27         address winnerAddr,
28         bytes32 winnerName,
29         uint256 amountWon,
30         uint256 newPot,
31         uint256 P3DAmount,
32         uint256 genAmount,
33         uint256 potAmount,
34         uint256 airDropPot
35     );
36 
37 	// fired whenever theres a withdraw
38     event onWithdraw
39     (
40         uint256 indexed playerID,
41         address playerAddress,
42         bytes32 playerName,
43         uint256 ethOut,
44         uint256 timeStamp
45     );
46 
47     // fired whenever a withdraw forces end round to be ran
48     event onWithdrawAndDistribute
49     (
50         address playerAddress,
51         bytes32 playerName,
52         uint256 ethOut,
53         uint256 compressedData,
54         uint256 compressedIDs,
55         address winnerAddr,
56         bytes32 winnerName,
57         uint256 amountWon,
58         uint256 newPot,
59         uint256 P3DAmount,
60         uint256 genAmount
61     );
62 
63     // (fomo3d short only) fired whenever a player tries a buy after round timer
64     // hit zero, and causes end round to be ran.
65     event onBuyAndDistribute
66     (
67         address playerAddress,
68         bytes32 playerName,
69         uint256 ethIn,
70         uint256 compressedData,
71         uint256 compressedIDs,
72         address winnerAddr,
73         bytes32 winnerName,
74         uint256 amountWon,
75         uint256 newPot,
76         uint256 P3DAmount,
77         uint256 genAmount
78     );
79 
80     // (fomo3d short only) fired whenever a player tries a reload after round timer
81     // hit zero, and causes end round to be ran.
82     event onReLoadAndDistribute
83     (
84         address playerAddress,
85         bytes32 playerName,
86         uint256 compressedData,
87         uint256 compressedIDs,
88         address winnerAddr,
89         bytes32 winnerName,
90         uint256 amountWon,
91         uint256 newPot,
92         uint256 P3DAmount,
93         uint256 genAmount
94     );
95 
96     // fired whenever an affiliate is paid
97     event onAffiliatePayout
98     (
99         uint256 indexed affiliateID,
100         address affiliateAddress,
101         bytes32 affiliateName,
102         uint256 indexed roundID,
103         uint256 indexed buyerID,
104         uint256 amount,
105         uint256 timeStamp
106     );
107 
108     // received pot swap deposit
109     event onPotSwapDeposit
110     (
111         uint256 roundID,
112         uint256 amountAddedToPot
113     );
114 }
115 
116 //==============================================================================
117 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
118 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
119 //====================================|=========================================
120 
121 contract modularShort is F3Devents {}
122 
123 contract FoMo3DLightning is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcShort for uint256;
127 
128     uint256 public pID_ = 4;
129 
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     address private admin = msg.sender;
135     string constant public name = "FOMO Lightning";
136     string constant public symbol = "F4D";
137     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
138     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
139     uint256 constant private rndInit_ = 2 minutes;                // round timer starts at this
140     uint256 constant private rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
141     uint256 constant private rndMax_ = 5 minutes;                // max length a round timer can be
142 //==============================================================================
143 //     _| _ _|_ _    _ _ _|_    _   .
144 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
145 //=============================|================================================
146     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
147     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
148     uint256 public rID_;    // round id number / total rounds that have happened
149 //****************
150 // PLAYER DATA
151 //****************
152     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
153     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
154     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
155     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
156     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
157 //****************
158 // ROUND DATA
159 //****************
160     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
161     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
162 //****************
163 // TEAM FEE DATA
164 //****************
165     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
166     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
167 //==============================================================================
168 //     _ _  _  __|_ _    __|_ _  _  .
169 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
170 //==============================================================================
171     constructor()
172         public
173     {
174 		// Team allocation structures
175         // 0 = whales
176         // 1 = bears
177         // 2 = sneks
178         // 3 = bulls
179 
180 		// Team allocation percentages
181         // (F3D, P3D) + (Pot , Referrals, Community)
182             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
183         fees_[0] = F3Ddatasets.TeamFee(49,2);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
184         fees_[1] = F3Ddatasets.TeamFee(49,2);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
185         fees_[2] = F3Ddatasets.TeamFee(49,2);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
186         fees_[3] = F3Ddatasets.TeamFee(49,2);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
187 
188         // how to split up the final pot based on which team was picked
189         // (F3D, P3D)
190         potSplit_[0] = F3Ddatasets.PotSplit(38,2);  //48% to winner, 10% to next round, 2% to com
191         potSplit_[1] = F3Ddatasets.PotSplit(38,2);  //48% to winner, 10% to next round, 2% to com
192         potSplit_[2] = F3Ddatasets.PotSplit(38,2);  //48% to winner, 10% to next round, 2% to com
193         potSplit_[3] = F3Ddatasets.PotSplit(38,2);  //48% to winner, 10% to next round, 2% to com
194 	}
195 //==============================================================================
196 //     _ _  _  _|. |`. _  _ _  .
197 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
198 //==============================================================================
199     /**
200      * @dev used to make sure no one can interact with contract until it has
201      * been activated.
202      */
203     modifier isActivated() {
204         require(activated_ == true, "its not ready yet.  check ?eta in discord");
205         _;
206     }
207 
208     /**
209      * @dev prevents contracts from interacting with fomo3d
210      */
211     modifier isHuman() {
212         address _addr = msg.sender;
213         uint256 _codeLength;
214 
215         assembly {_codeLength := extcodesize(_addr)}
216         require(_codeLength == 0, "sorry humans only");
217         _;
218     }
219 
220     /**
221      * @dev sets boundaries for incoming tx
222      */
223     modifier isWithinLimits(uint256 _eth) {
224         require(_eth >= 1000000000, "pocket lint: not a valid currency");
225         require(_eth <= 100000000000000000000000, "no vitalik, no");
226         _;
227     }
228 
229 //==============================================================================
230 //     _    |_ |. _   |`    _  __|_. _  _  _  .
231 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
232 //====|=========================================================================
233     /**
234      * @dev emergency buy uses last stored affiliate ID and team snek
235      */
236     function()
237         isActivated()
238         isHuman()
239         isWithinLimits(msg.value)
240         public
241         payable
242     {
243         // set up our tx event data and determine if player is new or not
244         F3Ddatasets.EventReturns memory _eventData_;
245 
246         if (determinePID(msg.sender)) {
247             _eventData_.compressedData = _eventData_.compressedData + 1;
248         }
249         // fetch player id
250         uint256 _pID = pIDxAddr_[msg.sender];
251 
252         // buy core
253         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
254     }
255 
256     function determinePID(address _addr)
257         private
258         returns (bool)
259     {
260         if (pIDxAddr_[_addr] == 0)
261         {
262             pID_++;
263             pIDxAddr_[_addr] = pID_;
264             plyr_[pID_].addr = _addr;
265 
266             // set the new player bool to true
267             return (true);
268         } else {
269             return (false);
270         }
271     }
272 
273     /**
274      * @dev converts all incoming ethereum to keys.
275      * -functionhash- 0x8f38f309 (using ID for affiliate)
276      * -functionhash- 0x98a0871d (using address for affiliate)
277      * -functionhash- 0xa65b37a1 (using name for affiliate)
278      * @param _affCode the ID/address/name of the player who gets the affiliate fee
279      * @param _team what team is the player playing for?
280      */
281     function buyXid(uint256 _affCode, uint256 _team)
282         isActivated()
283         isHuman()
284         isWithinLimits(msg.value)
285         public
286         payable
287     {
288         // set up our tx event data and determine if player is new or not
289         F3Ddatasets.EventReturns memory _eventData_;
290         if (determinePID(msg.sender)) {
291             _eventData_.compressedData = _eventData_.compressedData + 1;
292         }
293 
294         // fetch player id
295         uint256 _pID = pIDxAddr_[msg.sender];
296 
297         // manage affiliate residuals
298         // if no affiliate code was given or player tried to use their own, lolz
299         if (_affCode == 0 || _affCode == _pID)
300         {
301             // use last stored affiliate code
302             _affCode = plyr_[_pID].laff;
303 
304         // if affiliate code was given & its not the same as previously stored
305         } else if (_affCode != plyr_[_pID].laff) {
306             // update last affiliate
307             plyr_[_pID].laff = _affCode;
308         }
309 
310         // verify a valid team was selected
311         _team = verifyTeam(_team);
312 
313         // buy core
314         buyCore(_pID, _affCode, _team, _eventData_);
315     }
316 
317     function buyXaddr(address _affCode, uint256 _team)
318         isActivated()
319         isHuman()
320         isWithinLimits(msg.value)
321         public
322         payable
323     {
324         // set up our tx event data and determine if player is new or not
325         F3Ddatasets.EventReturns memory _eventData_;
326         if (determinePID(msg.sender)) {
327             _eventData_.compressedData = _eventData_.compressedData + 1;
328         }
329 
330         // fetch player id
331         uint256 _pID = pIDxAddr_[msg.sender];
332 
333         // manage affiliate residuals
334         uint256 _affID;
335         // if no affiliate code was given or player tried to use their own, lolz
336         if (_affCode == address(0) || _affCode == msg.sender)
337         {
338             // use last stored affiliate code
339             _affID = plyr_[_pID].laff;
340 
341         // if affiliate code was given
342         } else {
343             // get affiliate ID from aff Code
344             _affID = pIDxAddr_[_affCode];
345 
346             // if affID is not the same as previously stored
347             if (_affID != plyr_[_pID].laff)
348             {
349                 // update last affiliate
350                 plyr_[_pID].laff = _affID;
351             }
352         }
353 
354         // verify a valid team was selected
355         _team = verifyTeam(_team);
356 
357         // buy core
358         buyCore(_pID, _affID, _team, _eventData_);
359     }
360 
361     function buyXname(bytes32 _affCode, uint256 _team)
362         isActivated()
363         isHuman()
364         isWithinLimits(msg.value)
365         public
366         payable
367     {
368         // set up our tx event data and determine if player is new or not
369         F3Ddatasets.EventReturns memory _eventData_;
370         if (determinePID(msg.sender)) {
371             _eventData_.compressedData = _eventData_.compressedData + 1;
372         }
373 
374         // fetch player id
375         uint256 _pID = pIDxAddr_[msg.sender];
376 
377         // manage affiliate residuals
378         uint256 _affID;
379         // if no affiliate code was given or player tried to use their own, lolz
380         if (_affCode == '' || _affCode == plyr_[_pID].name)
381         {
382             // use last stored affiliate code
383             _affID = plyr_[_pID].laff;
384 
385         // if affiliate code was given
386         } else {
387             // get affiliate ID from aff Code
388             _affID = pIDxName_[_affCode];
389 
390             // if affID is not the same as previously stored
391             if (_affID != plyr_[_pID].laff)
392             {
393                 // update last affiliate
394                 plyr_[_pID].laff = _affID;
395             }
396         }
397 
398         // verify a valid team was selected
399         _team = verifyTeam(_team);
400 
401         // buy core
402         buyCore(_pID, _affID, _team, _eventData_);
403     }
404 
405     /**
406      * @dev essentially the same as buy, but instead of you sending ether
407      * from your wallet, it uses your unwithdrawn earnings.
408      * -functionhash- 0x349cdcac (using ID for affiliate)
409      * -functionhash- 0x82bfc739 (using address for affiliate)
410      * -functionhash- 0x079ce327 (using name for affiliate)
411      * @param _affCode the ID/address/name of the player who gets the affiliate fee
412      * @param _team what team is the player playing for?
413      * @param _eth amount of earnings to use (remainder returned to gen vault)
414      */
415     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
416         isActivated()
417         isHuman()
418         isWithinLimits(_eth)
419         public
420     {
421         // set up our tx event data
422         F3Ddatasets.EventReturns memory _eventData_;
423 
424         // fetch player ID
425         uint256 _pID = pIDxAddr_[msg.sender];
426 
427         // manage affiliate residuals
428         // if no affiliate code was given or player tried to use their own, lolz
429         if (_affCode == 0 || _affCode == _pID)
430         {
431             // use last stored affiliate code
432             _affCode = plyr_[_pID].laff;
433 
434         // if affiliate code was given & its not the same as previously stored
435         } else if (_affCode != plyr_[_pID].laff) {
436             // update last affiliate
437             plyr_[_pID].laff = _affCode;
438         }
439 
440         // verify a valid team was selected
441         _team = verifyTeam(_team);
442 
443         // reload core
444         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
445     }
446 
447     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
448         isActivated()
449         isHuman()
450         isWithinLimits(_eth)
451         public
452     {
453         // set up our tx event data
454         F3Ddatasets.EventReturns memory _eventData_;
455 
456         // fetch player ID
457         uint256 _pID = pIDxAddr_[msg.sender];
458 
459         // manage affiliate residuals
460         uint256 _affID;
461         // if no affiliate code was given or player tried to use their own, lolz
462         if (_affCode == address(0) || _affCode == msg.sender)
463         {
464             // use last stored affiliate code
465             _affID = plyr_[_pID].laff;
466 
467         // if affiliate code was given
468         } else {
469             // get affiliate ID from aff Code
470             _affID = pIDxAddr_[_affCode];
471 
472             // if affID is not the same as previously stored
473             if (_affID != plyr_[_pID].laff)
474             {
475                 // update last affiliate
476                 plyr_[_pID].laff = _affID;
477             }
478         }
479 
480         // verify a valid team was selected
481         _team = verifyTeam(_team);
482 
483         // reload core
484         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
485     }
486 
487     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
488         isActivated()
489         isHuman()
490         isWithinLimits(_eth)
491         public
492     {
493         // set up our tx event data
494         F3Ddatasets.EventReturns memory _eventData_;
495 
496         // fetch player ID
497         uint256 _pID = pIDxAddr_[msg.sender];
498 
499         // manage affiliate residuals
500         uint256 _affID;
501         // if no affiliate code was given or player tried to use their own, lolz
502         if (_affCode == '' || _affCode == plyr_[_pID].name)
503         {
504             // use last stored affiliate code
505             _affID = plyr_[_pID].laff;
506 
507         // if affiliate code was given
508         } else {
509             // get affiliate ID from aff Code
510             _affID = pIDxName_[_affCode];
511 
512             // if affID is not the same as previously stored
513             if (_affID != plyr_[_pID].laff)
514             {
515                 // update last affiliate
516                 plyr_[_pID].laff = _affID;
517             }
518         }
519 
520         // verify a valid team was selected
521         _team = verifyTeam(_team);
522 
523         // reload core
524         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
525     }
526 
527     /**
528      * @dev withdraws all of your earnings.
529      * -functionhash- 0x3ccfd60b
530      */
531     function withdraw()
532         isActivated()
533         isHuman()
534         public
535     {
536         // setup local rID
537         uint256 _rID = rID_;
538 
539         // grab time
540         uint256 _now = now;
541 
542         // fetch player ID
543         uint256 _pID = pIDxAddr_[msg.sender];
544 
545         // setup temp var for player eth
546         uint256 _eth;
547 
548         // check to see if round has ended and no one has run round end yet
549         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
550         {
551             // set up our tx event data
552             F3Ddatasets.EventReturns memory _eventData_;
553 
554             // end the round (distributes pot)
555 			round_[_rID].ended = true;
556             _eventData_ = endRound(_eventData_);
557 
558 			// get their earnings
559             _eth = withdrawEarnings(_pID);
560 
561             // gib moni
562             if (_eth > 0)
563                 plyr_[_pID].addr.transfer(_eth);
564 
565             // build event data
566             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
567             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
568 
569             // fire withdraw and distribute event
570             emit F3Devents.onWithdrawAndDistribute
571             (
572                 msg.sender,
573                 plyr_[_pID].name,
574                 _eth,
575                 _eventData_.compressedData,
576                 _eventData_.compressedIDs,
577                 _eventData_.winnerAddr,
578                 _eventData_.winnerName,
579                 _eventData_.amountWon,
580                 _eventData_.newPot,
581                 _eventData_.P3DAmount,
582                 _eventData_.genAmount
583             );
584 
585         // in any other situation
586         } else {
587             // get their earnings
588             _eth = withdrawEarnings(_pID);
589 
590             // gib moni
591             if (_eth > 0)
592                 plyr_[_pID].addr.transfer(_eth);
593 
594             // fire withdraw event
595             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
596         }
597     }
598 //==============================================================================
599 //     _  _ _|__|_ _  _ _  .
600 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
601 //=====_|=======================================================================
602     /**
603      * @dev return the price buyer will pay for next 1 individual key.
604      * -functionhash- 0x018a25e8
605      * @return price for next key bought (in wei format)
606      */
607     function getBuyPrice()
608         public
609         view
610         returns(uint256)
611     {
612         // setup local rID
613         uint256 _rID = rID_;
614 
615         // grab time
616         uint256 _now = now;
617 
618         // are we in a round?
619         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
620             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
621         else // rounds over.  need price for new round
622             return ( 75000000000000 ); // init
623     }
624 
625     /**
626      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
627      * provider
628      * -functionhash- 0xc7e284b8
629      * @return time left in seconds
630      */
631     function getTimeLeft()
632         public
633         view
634         returns(uint256)
635     {
636         // setup local rID
637         uint256 _rID = rID_;
638 
639         // grab time
640         uint256 _now = now;
641 
642         if (_now < round_[_rID].end)
643             if (_now > round_[_rID].strt + rndGap_)
644                 return( (round_[_rID].end).sub(_now) );
645             else
646                 return( (round_[_rID].strt + rndGap_).sub(_now) );
647         else
648             return(0);
649     }
650 
651     /**
652      * @dev returns player earnings per vaults
653      * -functionhash- 0x63066434
654      * @return winnings vault
655      * @return general vault
656      * @return affiliate vault
657      */
658     function getPlayerVaults(uint256 _pID)
659         public
660         view
661         returns(uint256 ,uint256, uint256)
662     {
663         // setup local rID
664         uint256 _rID = rID_;
665 
666         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
667         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
668         {
669             // if player is winner
670             if (round_[_rID].plyr == _pID)
671             {
672                 return
673                 (
674                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
675                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
676                     plyr_[_pID].aff
677                 );
678             // if player is not the winner
679             } else {
680                 return
681                 (
682                     plyr_[_pID].win,
683                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
684                     plyr_[_pID].aff
685                 );
686             }
687 
688         // if round is still going on, or round has ended and round end has been ran
689         } else {
690             return
691             (
692                 plyr_[_pID].win,
693                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
694                 plyr_[_pID].aff
695             );
696         }
697     }
698 
699     /**
700      * solidity hates stack limits.  this lets us avoid that hate
701      */
702     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
703         private
704         view
705         returns(uint256)
706     {
707         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
708     }
709 
710     /**
711      * @dev returns all current round info needed for front end
712      * -functionhash- 0x747dff42
713      * @return eth invested during ICO phase
714      * @return round id
715      * @return total keys for round
716      * @return time round ends
717      * @return time round started
718      * @return current pot
719      * @return current team ID & player ID in lead
720      * @return current player in leads address
721      * @return current player in leads name
722      * @return whales eth in for round
723      * @return bears eth in for round
724      * @return sneks eth in for round
725      * @return bulls eth in for round
726      * @return airdrop tracker # & airdrop pot
727      */
728     function getCurrentRoundInfo()
729         public
730         view
731         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
732     {
733         // setup local rID
734         uint256 _rID = rID_;
735 
736         return
737         (
738             round_[_rID].ico,               //0
739             _rID,                           //1
740             round_[_rID].keys,              //2
741             round_[_rID].end,               //3
742             round_[_rID].strt,              //4
743             round_[_rID].pot,               //5
744             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
745             plyr_[round_[_rID].plyr].addr,  //7
746             plyr_[round_[_rID].plyr].name,  //8
747             rndTmEth_[_rID][0],             //9
748             rndTmEth_[_rID][1],             //10
749             rndTmEth_[_rID][2],             //11
750             rndTmEth_[_rID][3],             //12
751             airDropTracker_ + (airDropPot_ * 1000)              //13
752         );
753     }
754 
755     /**
756      * @dev returns player info based on address.  if no address is given, it will
757      * use msg.sender
758      * -functionhash- 0xee0b5d8b
759      * @param _addr address of the player you want to lookup
760      * @return player ID
761      * @return player name
762      * @return keys owned (current round)
763      * @return winnings vault
764      * @return general vault
765      * @return affiliate vault
766 	 * @return player round eth
767      */
768     function getPlayerInfoByAddress(address _addr)
769         public
770         view
771         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
772     {
773         // setup local rID
774         uint256 _rID = rID_;
775 
776         if (_addr == address(0))
777         {
778             _addr == msg.sender;
779         }
780         uint256 _pID = pIDxAddr_[_addr];
781 
782         return
783         (
784             _pID,                               //0
785             plyr_[_pID].name,                   //1
786             plyrRnds_[_pID][_rID].keys,         //2
787             plyr_[_pID].win,                    //3
788             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
789             plyr_[_pID].aff,                    //5
790             plyrRnds_[_pID][_rID].eth           //6
791         );
792     }
793 
794 //==============================================================================
795 //     _ _  _ _   | _  _ . _  .
796 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
797 //=====================_|=======================================================
798     /**
799      * @dev logic runs whenever a buy order is executed.  determines how to handle
800      * incoming eth depending on if we are in an active round or not
801      */
802     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
803         private
804     {
805         // setup local rID
806         uint256 _rID = rID_;
807 
808         // grab time
809         uint256 _now = now;
810 
811         // if round is active
812         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
813         {
814             // call core
815             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
816 
817         // if round is not active
818         } else {
819             // check to see if end round needs to be ran
820             if (_now > round_[_rID].end && round_[_rID].ended == false)
821             {
822                 // end the round (distributes pot) & start new round
823 			    round_[_rID].ended = true;
824                 _eventData_ = endRound(_eventData_);
825 
826                 // build event data
827                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
828                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
829 
830                 // fire buy and distribute event
831                 emit F3Devents.onBuyAndDistribute
832                 (
833                     msg.sender,
834                     plyr_[_pID].name,
835                     msg.value,
836                     _eventData_.compressedData,
837                     _eventData_.compressedIDs,
838                     _eventData_.winnerAddr,
839                     _eventData_.winnerName,
840                     _eventData_.amountWon,
841                     _eventData_.newPot,
842                     _eventData_.P3DAmount,
843                     _eventData_.genAmount
844                 );
845             }
846 
847             // put eth in players vault
848             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
849         }
850     }
851 
852     /**
853      * @dev logic runs whenever a reload order is executed.  determines how to handle
854      * incoming eth depending on if we are in an active round or not
855      */
856     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
857         private
858     {
859         // setup local rID
860         uint256 _rID = rID_;
861 
862         // grab time
863         uint256 _now = now;
864 
865         // if round is active
866         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
867         {
868             // get earnings from all vaults and return unused to gen vault
869             // because we use a custom safemath library.  this will throw if player
870             // tried to spend more eth than they have.
871             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
872 
873             // call core
874             core(_rID, _pID, _eth, _affID, _team, _eventData_);
875 
876         // if round is not active and end round needs to be ran
877         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
878             // end the round (distributes pot) & start new round
879             round_[_rID].ended = true;
880             _eventData_ = endRound(_eventData_);
881 
882             // build event data
883             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
884             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
885 
886             // fire buy and distribute event
887             emit F3Devents.onReLoadAndDistribute
888             (
889                 msg.sender,
890                 plyr_[_pID].name,
891                 _eventData_.compressedData,
892                 _eventData_.compressedIDs,
893                 _eventData_.winnerAddr,
894                 _eventData_.winnerName,
895                 _eventData_.amountWon,
896                 _eventData_.newPot,
897                 _eventData_.P3DAmount,
898                 _eventData_.genAmount
899             );
900         }
901     }
902 
903     /**
904      * @dev this is the core logic for any buy/reload that happens while a round
905      * is live.
906      */
907     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
908         private
909     {
910         // if player is new to round
911         if (plyrRnds_[_pID][_rID].keys == 0)
912             _eventData_ = managePlayer(_pID, _eventData_);
913 
914         // early round eth limiter
915         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 2100000000000000000)
916         {
917             uint256 _availableLimit = (2100000000000000000).sub(plyrRnds_[_pID][_rID].eth);
918             uint256 _refund = _eth.sub(_availableLimit);
919             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
920             _eth = _availableLimit;
921         }
922 
923         // if eth left is greater than min eth allowed (sorry no pocket lint)
924         if (_eth > 1000000000)
925         {
926 
927             // mint the new keys
928             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
929 
930             // if they bought at least 1 whole key
931             if (_keys >= 1000000000000000000)
932             {
933             updateTimer(_keys, _rID);
934 
935             // set new leaders
936             if (round_[_rID].plyr != _pID)
937                 round_[_rID].plyr = _pID;
938             if (round_[_rID].team != _team)
939                 round_[_rID].team = _team;
940 
941             // set the new leader bool to true
942             _eventData_.compressedData = _eventData_.compressedData + 100;
943         }
944 
945             // manage airdrops
946             if (_eth >= 100000000000000000)
947             {
948             airDropTracker_++;
949             if (airdrop() == true)
950             {
951                 // gib muni
952                 uint256 _prize;
953                 if (_eth >= 10000000000000000000)
954                 {
955                     // calculate prize and give it to winner
956                     _prize = ((airDropPot_).mul(75)) / 100;
957                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
958 
959                     // adjust airDropPot
960                     airDropPot_ = (airDropPot_).sub(_prize);
961 
962                     // let event know a tier 3 prize was won
963                     _eventData_.compressedData += 300000000000000000000000000000000;
964                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
965                     // calculate prize and give it to winner
966                     _prize = ((airDropPot_).mul(50)) / 100;
967                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
968 
969                     // adjust airDropPot
970                     airDropPot_ = (airDropPot_).sub(_prize);
971 
972                     // let event know a tier 2 prize was won
973                     _eventData_.compressedData += 200000000000000000000000000000000;
974                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
975                     // calculate prize and give it to winner
976                     _prize = ((airDropPot_).mul(25)) / 100;
977                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
978 
979                     // adjust airDropPot
980                     airDropPot_ = (airDropPot_).sub(_prize);
981 
982                     // let event know a tier 3 prize was won
983                     _eventData_.compressedData += 300000000000000000000000000000000;
984                 }
985                 // set airdrop happened bool to true
986                 _eventData_.compressedData += 10000000000000000000000000000000;
987                 // let event know how much was won
988                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
989 
990                 // reset air drop tracker
991                 airDropTracker_ = 0;
992             }
993         }
994 
995             // store the air drop tracker number (number of buys since last airdrop)
996             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
997 
998             // update player
999             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1000             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1001 
1002             // update round
1003             round_[_rID].keys = _keys.add(round_[_rID].keys);
1004             round_[_rID].eth = _eth.add(round_[_rID].eth);
1005             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1006 
1007             // distribute eth
1008             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1009             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1010 
1011             // call end tx function to fire end tx event.
1012 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1013         }
1014     }
1015 //==============================================================================
1016 //     _ _ | _   | _ _|_ _  _ _  .
1017 //    (_(_||(_|_||(_| | (_)| _\  .
1018 //==============================================================================
1019     /**
1020      * @dev calculates unmasked earnings (just calculates, does not update mask)
1021      * @return earnings in wei format
1022      */
1023     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1024         private
1025         view
1026         returns(uint256)
1027     {
1028         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1029     }
1030 
1031     /**
1032      * @dev returns the amount of keys you would get given an amount of eth.
1033      * -functionhash- 0xce89c80c
1034      * @param _rID round ID you want price for
1035      * @param _eth amount of eth sent in
1036      * @return keys received
1037      */
1038     function calcKeysReceived(uint256 _rID, uint256 _eth)
1039         public
1040         view
1041         returns(uint256)
1042     {
1043         // grab time
1044         uint256 _now = now;
1045 
1046         // are we in a round?
1047         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1048             return ( (round_[_rID].eth).keysRec(_eth) );
1049         else // rounds over.  need keys for new round
1050             return ( (_eth).keys() );
1051     }
1052 
1053     /**
1054      * @dev returns current eth price for X keys.
1055      * -functionhash- 0xcf808000
1056      * @param _keys number of keys desired (in 18 decimal format)
1057      * @return amount of eth needed to send
1058      */
1059     function iWantXKeys(uint256 _keys)
1060         public
1061         view
1062         returns(uint256)
1063     {
1064         // setup local rID
1065         uint256 _rID = rID_;
1066 
1067         // grab time
1068         uint256 _now = now;
1069 
1070         // are we in a round?
1071         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1072             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1073         else // rounds over.  need price for new round
1074             return ( (_keys).eth() );
1075     }
1076 
1077     /**
1078      * @dev checks to make sure user picked a valid team.  if not sets team
1079      * to default (sneks)
1080      */
1081     function verifyTeam(uint256 _team)
1082         private
1083         pure
1084         returns (uint256)
1085     {
1086         if (_team < 0 || _team > 3)
1087             return(2);
1088         else
1089             return(_team);
1090     }
1091 
1092     /**
1093      * @dev decides if round end needs to be run & new round started.  and if
1094      * player unmasked earnings from previously played rounds need to be moved.
1095      */
1096     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1097         private
1098         returns (F3Ddatasets.EventReturns)
1099     {
1100         // if player has played a previous round, move their unmasked earnings
1101         // from that round to gen vault.
1102         if (plyr_[_pID].lrnd != 0)
1103             updateGenVault(_pID, plyr_[_pID].lrnd);
1104 
1105         // update player's last round played
1106         plyr_[_pID].lrnd = rID_;
1107 
1108         // set the joined round bool to true
1109         _eventData_.compressedData = _eventData_.compressedData + 10;
1110 
1111         return(_eventData_);
1112     }
1113 
1114     /**
1115      * @dev ends the round. manages paying out winner/splitting up pot
1116      */
1117     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1118         private
1119         returns (F3Ddatasets.EventReturns)
1120     {
1121         // setup local rID
1122         uint256 _rID = rID_;
1123 
1124         // grab our winning player and team id's
1125         uint256 _winPID = round_[_rID].plyr;
1126         uint256 _winTID = round_[_rID].team;
1127 
1128         // grab our pot amount
1129         uint256 _pot = round_[_rID].pot;
1130 
1131         // calculate our winner share, community rewards, gen share,
1132         // p3d share, and amount reserved for next pot
1133         uint256 _win = (_pot.mul(48)) / 100; //48%
1134         uint256 _com = (_pot / 50); //2%
1135         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1136         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1137         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1138 
1139         // calculate ppt for round mask
1140         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1141         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1142         if (_dust > 0)
1143         {
1144             _gen = _gen.sub(_dust);
1145             _res = _res.add(_dust);
1146         }
1147 
1148         // pay our winner
1149         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1150 
1151         // community rewards
1152 
1153         admin.transfer(_com);
1154 
1155         admin.transfer(_p3d.sub(_p3d / 2));
1156 
1157         round_[_rID].pot = _pot.add(_p3d / 2);
1158 
1159         // distribute gen portion to key holders
1160         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1161 
1162         // prepare event data
1163         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1164         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1165         _eventData_.winnerAddr = plyr_[_winPID].addr;
1166         _eventData_.winnerName = plyr_[_winPID].name;
1167         _eventData_.amountWon = _win;
1168         _eventData_.genAmount = _gen;
1169         _eventData_.P3DAmount = _p3d;
1170         _eventData_.newPot = _res;
1171 
1172         // start next round
1173         rID_++;
1174         _rID++;
1175         round_[_rID].strt = now;
1176         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1177         round_[_rID].pot = _res;
1178 
1179         return(_eventData_);
1180     }
1181 
1182     /**
1183      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1184      */
1185     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1186         private
1187     {
1188         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1189         if (_earnings > 0)
1190         {
1191             // put in gen vault
1192             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1193             // zero out their earnings by updating mask
1194             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1195         }
1196     }
1197 
1198     /**
1199      * @dev updates round timer based on number of whole keys bought.
1200      */
1201     function updateTimer(uint256 _keys, uint256 _rID)
1202         private
1203     {
1204         // grab time
1205         uint256 _now = now;
1206 
1207         // calculate time based on number of keys bought
1208         uint256 _newTime;
1209         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1210             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1211         else
1212             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1213 
1214         // compare to max and set new end time
1215         if (_newTime < (rndMax_).add(_now))
1216             round_[_rID].end = _newTime;
1217         else
1218             round_[_rID].end = rndMax_.add(_now);
1219     }
1220 
1221     /**
1222      * @dev generates a random number between 0-99 and checks to see if thats
1223      * resulted in an airdrop win
1224      * @return do we have a winner?
1225      */
1226     function airdrop()
1227         private
1228         view
1229         returns(bool)
1230     {
1231         uint256 seed = uint256(keccak256(abi.encodePacked(
1232 
1233             (block.timestamp).add
1234             (block.difficulty).add
1235             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1236             (block.gaslimit).add
1237             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1238             (block.number)
1239 
1240         )));
1241         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1242             return(true);
1243         else
1244             return(false);
1245     }
1246 
1247     /**
1248      * @dev distributes eth based on fees to com, aff, and p3d
1249      */
1250     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1251         private
1252         returns(F3Ddatasets.EventReturns)
1253     {
1254         // pay 3% out to community rewards
1255         uint256 _p1 = _eth / 100; //1%
1256         uint256 _com = _eth / 50;  //2%
1257         _com = _com.add(_p1); //1 + 2 = 3
1258 
1259         uint256 _p3d;
1260         if (!address(admin).call.value(_com)())
1261         {
1262             // This ensures Team Just cannot influence the outcome of FoMo3D with
1263             // bank migrations by breaking outgoing transactions.
1264             // Something we would never do. But that's not the point.
1265             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1266             // highest belief that everything we create should be trustless.
1267             // Team JUST, The name you shouldn't have to trust.
1268             _p3d = _com;
1269             _com = 0;
1270         }
1271 
1272 
1273         // distribute share to affiliate
1274         uint256 _aff = _eth / 10;
1275 
1276         // decide what to do with affiliate share of fees
1277         // affiliate must not be self, and must have a name registered
1278         if (_affID != _pID && plyr_[_affID].name != '') {
1279             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1280             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1281         } else {
1282             _p3d = _aff;
1283         }
1284 
1285         // pay out p3d
1286         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1287         if (_p3d > 0)
1288         {
1289             // deposit to divies contract
1290             uint256 _potAmount = _p3d / 2;
1291 
1292             admin.transfer(_p3d.sub(_potAmount));
1293 
1294             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1295 
1296             // set up event data
1297             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1298         }
1299 
1300         return(_eventData_);
1301     }
1302 
1303     function potSwap()
1304         external
1305         payable
1306     {
1307         // setup local rID
1308         uint256 _rID = rID_ + 1;
1309 
1310         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1311         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1312     }
1313 
1314     /**
1315      * @dev distributes eth based on fees to gen and pot
1316      */
1317     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1318         private
1319         returns(F3Ddatasets.EventReturns)
1320     {
1321         // calculate gen share
1322         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1323 
1324         // toss 1% into airdrop pot
1325         uint256 _air = (_eth / 100);
1326         airDropPot_ = airDropPot_.add(_air);
1327 
1328         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1329         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1330 
1331         // calculate pot
1332         uint256 _pot = _eth.sub(_gen);
1333 
1334         // distribute gen share (thats what updateMasks() does) and adjust
1335         // balances for dust.
1336         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1337         if (_dust > 0)
1338             _gen = _gen.sub(_dust);
1339 
1340         // add eth to pot
1341         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1342 
1343         // set up event data
1344         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1345         _eventData_.potAmount = _pot;
1346 
1347         return(_eventData_);
1348     }
1349 
1350     /**
1351      * @dev updates masks for round and player when keys are bought
1352      * @return dust left over
1353      */
1354     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1355         private
1356         returns(uint256)
1357     {
1358         /* MASKING NOTES
1359             earnings masks are a tricky thing for people to wrap their minds around.
1360             the basic thing to understand here.  is were going to have a global
1361             tracker based on profit per share for each round, that increases in
1362             relevant proportion to the increase in share supply.
1363 
1364             the player will have an additional mask that basically says "based
1365             on the rounds mask, my shares, and how much i've already withdrawn,
1366             how much is still owed to me?"
1367         */
1368 
1369         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1370         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1371         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1372 
1373         // calculate player earning from their own buy (only based on the keys
1374         // they just bought).  & update player earnings mask
1375         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1376         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1377 
1378         // calculate & return dust
1379         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1380     }
1381 
1382     /**
1383      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1384      * @return earnings in wei format
1385      */
1386     function withdrawEarnings(uint256 _pID)
1387         private
1388         returns(uint256)
1389     {
1390         // update gen vault
1391         updateGenVault(_pID, plyr_[_pID].lrnd);
1392 
1393         // from vaults
1394         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1395         if (_earnings > 0)
1396         {
1397             plyr_[_pID].win = 0;
1398             plyr_[_pID].gen = 0;
1399             plyr_[_pID].aff = 0;
1400         }
1401 
1402         return(_earnings);
1403     }
1404 
1405     /**
1406      * @dev prepares compression data and fires event for buy or reload tx's
1407      */
1408     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1409         private
1410     {
1411         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1412         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1413 
1414         emit F3Devents.onEndTx
1415         (
1416             _eventData_.compressedData,
1417             _eventData_.compressedIDs,
1418             plyr_[_pID].name,
1419             msg.sender,
1420             _eth,
1421             _keys,
1422             _eventData_.winnerAddr,
1423             _eventData_.winnerName,
1424             _eventData_.amountWon,
1425             _eventData_.newPot,
1426             _eventData_.P3DAmount,
1427             _eventData_.genAmount,
1428             _eventData_.potAmount,
1429             airDropPot_
1430         );
1431     }
1432 //==============================================================================
1433 //    (~ _  _    _._|_    .
1434 //    _)(/_(_|_|| | | \/  .
1435 //====================/=========================================================
1436     /** upon contract deploy, it will be deactivated.  this is a one time
1437      * use function that will activate the contract.  we do this so devs
1438      * have time to set things up on the web end                            **/
1439     bool public activated_ = false;
1440     function activate()
1441         public
1442     {
1443         // only team just can activate
1444         require(msg.sender == admin);
1445 
1446 
1447         // can only be ran once
1448         require(activated_ == false);
1449 
1450         // activate the contract
1451         activated_ = true;
1452 
1453         // lets start first round
1454         rID_ = 1;
1455             round_[1].strt = now + rndExtra_ - rndGap_;
1456             round_[1].end = now + rndInit_ + rndExtra_;
1457     }
1458 }
1459 
1460 //==============================================================================
1461 //   __|_ _    __|_ _  .
1462 //  _\ | | |_|(_ | _\  .
1463 //==============================================================================
1464 library F3Ddatasets {
1465     //compressedData key
1466     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1467         // 0 - new player (bool)
1468         // 1 - joined round (bool)
1469         // 2 - new  leader (bool)
1470         // 3-5 - air drop tracker (uint 0-999)
1471         // 6-16 - round end time
1472         // 17 - winnerTeam
1473         // 18 - 28 timestamp
1474         // 29 - team
1475         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1476         // 31 - airdrop happened bool
1477         // 32 - airdrop tier
1478         // 33 - airdrop amount won
1479     //compressedIDs key
1480     // [77-52][51-26][25-0]
1481         // 0-25 - pID
1482         // 26-51 - winPID
1483         // 52-77 - rID
1484     struct EventReturns {
1485         uint256 compressedData;
1486         uint256 compressedIDs;
1487         address winnerAddr;         // winner address
1488         bytes32 winnerName;         // winner name
1489         uint256 amountWon;          // amount won
1490         uint256 newPot;             // amount in new pot
1491         uint256 P3DAmount;          // amount distributed to p3d
1492         uint256 genAmount;          // amount distributed to gen
1493         uint256 potAmount;          // amount added to pot
1494     }
1495     struct Player {
1496         address addr;   // player address
1497         bytes32 name;   // player name
1498         uint256 win;    // winnings vault
1499         uint256 gen;    // general vault
1500         uint256 aff;    // affiliate vault
1501         uint256 lrnd;   // last round played
1502         uint256 laff;   // last affiliate id used
1503     }
1504     struct PlayerRounds {
1505         uint256 eth;    // eth player has added to round (used for eth limiter)
1506         uint256 keys;   // keys
1507         uint256 mask;   // player mask
1508         uint256 ico;    // ICO phase investment
1509     }
1510     struct Round {
1511         uint256 plyr;   // pID of player in lead
1512         uint256 team;   // tID of team in lead
1513         uint256 end;    // time ends/ended
1514         bool ended;     // has round end function been ran
1515         uint256 strt;   // time round started
1516         uint256 keys;   // keys
1517         uint256 eth;    // total eth in
1518         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1519         uint256 mask;   // global mask
1520         uint256 ico;    // total eth sent in during ICO phase
1521         uint256 icoGen; // total eth for gen during ICO phase
1522         uint256 icoAvg; // average key price for ICO phase
1523     }
1524     struct TeamFee {
1525         uint256 gen;    // % of buy in thats paid to key holders of current round
1526         uint256 p3d;    // % of buy in thats paid to p3d holders
1527     }
1528     struct PotSplit {
1529         uint256 gen;    // % of pot thats paid to key holders of current round
1530         uint256 p3d;    // % of pot thats paid to p3d holders
1531     }
1532 }
1533 
1534 //==============================================================================
1535 //  |  _      _ _ | _  .
1536 //  |<(/_\/  (_(_||(_  .
1537 //=======/======================================================================
1538 library F3DKeysCalcShort {
1539     using SafeMath for *;
1540     /**
1541      * @dev calculates number of keys received given X eth
1542      * @param _curEth current amount of eth in contract
1543      * @param _newEth eth being spent
1544      * @return amount of ticket purchased
1545      */
1546     function keysRec(uint256 _curEth, uint256 _newEth)
1547         internal
1548         pure
1549         returns (uint256)
1550     {
1551         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1552     }
1553 
1554     /**
1555      * @dev calculates amount of eth received if you sold X keys
1556      * @param _curKeys current amount of keys that exist
1557      * @param _sellKeys amount of keys you wish to sell
1558      * @return amount of eth received
1559      */
1560     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1561         internal
1562         pure
1563         returns (uint256)
1564     {
1565         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1566     }
1567 
1568     /**
1569      * @dev calculates how many keys would exist with given an amount of eth
1570      * @param _eth eth "in contract"
1571      * @return number of keys that would exist
1572      */
1573     function keys(uint256 _eth)
1574         internal
1575         pure
1576         returns(uint256)
1577     {
1578         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1579     }
1580 
1581     /**
1582      * @dev calculates how much eth would be in contract given a number of keys
1583      * @param _keys number of keys "in contract"
1584      * @return eth that would exists
1585      */
1586     function eth(uint256 _keys)
1587         internal
1588         pure
1589         returns(uint256)
1590     {
1591         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1592     }
1593 }
1594 
1595 //==============================================================================
1596 //  . _ _|_ _  _ |` _  _ _  _  .
1597 //  || | | (/_| ~|~(_|(_(/__\  .
1598 //==============================================================================
1599 
1600 interface PlayerBookInterface {
1601     function getPlayerID(address _addr) external returns (uint256);
1602     function getPlayerName(uint256 _pID) external view returns (bytes32);
1603     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1604     function getPlayerAddr(uint256 _pID) external view returns (address);
1605     function getNameFee() external view returns (uint256);
1606     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1607     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1608     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1609 }
1610 
1611 
1612 library NameFilter {
1613     /**
1614      * @dev filters name strings
1615      * -converts uppercase to lower case.
1616      * -makes sure it does not start/end with a space
1617      * -makes sure it does not contain multiple spaces in a row
1618      * -cannot be only numbers
1619      * -cannot start with 0x
1620      * -restricts characters to A-Z, a-z, 0-9, and space.
1621      * @return reprocessed string in bytes32 format
1622      */
1623     function nameFilter(string _input)
1624         internal
1625         pure
1626         returns(bytes32)
1627     {
1628         bytes memory _temp = bytes(_input);
1629         uint256 _length = _temp.length;
1630 
1631         //sorry limited to 32 characters
1632         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1633         // make sure it doesnt start with or end with space
1634         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1635         // make sure first two characters are not 0x
1636         if (_temp[0] == 0x30)
1637         {
1638             require(_temp[1] != 0x78, "string cannot start with 0x");
1639             require(_temp[1] != 0x58, "string cannot start with 0X");
1640         }
1641 
1642         // create a bool to track if we have a non number character
1643         bool _hasNonNumber;
1644 
1645         // convert & check
1646         for (uint256 i = 0; i < _length; i++)
1647         {
1648             // if its uppercase A-Z
1649             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1650             {
1651                 // convert to lower case a-z
1652                 _temp[i] = byte(uint(_temp[i]) + 32);
1653 
1654                 // we have a non number
1655                 if (_hasNonNumber == false)
1656                     _hasNonNumber = true;
1657             } else {
1658                 require
1659                 (
1660                     // require character is a space
1661                     _temp[i] == 0x20 ||
1662                     // OR lowercase a-z
1663                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1664                     // or 0-9
1665                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1666                     "string contains invalid characters"
1667                 );
1668                 // make sure theres not 2x spaces in a row
1669                 if (_temp[i] == 0x20)
1670                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1671 
1672                 // see if we have a character other than a number
1673                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1674                     _hasNonNumber = true;
1675             }
1676         }
1677 
1678         require(_hasNonNumber == true, "string cannot be only numbers");
1679 
1680         bytes32 _ret;
1681         assembly {
1682             _ret := mload(add(_temp, 32))
1683         }
1684         return (_ret);
1685     }
1686 }
1687 
1688 /**
1689  * @title SafeMath v0.1.9
1690  * @dev Math operations with safety checks that throw on error
1691  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1692  * - added sqrt
1693  * - added sq
1694  * - added pwr
1695  * - changed asserts to requires with error log outputs
1696  * - removed div, its useless
1697  */
1698 library SafeMath {
1699 
1700     /**
1701     * @dev Multiplies two numbers, throws on overflow.
1702     */
1703     function mul(uint256 a, uint256 b)
1704         internal
1705         pure
1706         returns (uint256 c)
1707     {
1708         if (a == 0) {
1709             return 0;
1710         }
1711         c = a * b;
1712         require(c / a == b, "SafeMath mul failed");
1713         return c;
1714     }
1715 
1716     /**
1717     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1718     */
1719     function sub(uint256 a, uint256 b)
1720         internal
1721         pure
1722         returns (uint256)
1723     {
1724         require(b <= a, "SafeMath sub failed");
1725         return a - b;
1726     }
1727 
1728     /**
1729     * @dev Adds two numbers, throws on overflow.
1730     */
1731     function add(uint256 a, uint256 b)
1732         internal
1733         pure
1734         returns (uint256 c)
1735     {
1736         c = a + b;
1737         require(c >= a, "SafeMath add failed");
1738         return c;
1739     }
1740 
1741     /**
1742      * @dev gives square root of given x.
1743      */
1744     function sqrt(uint256 x)
1745         internal
1746         pure
1747         returns (uint256 y)
1748     {
1749         uint256 z = ((add(x,1)) / 2);
1750         y = x;
1751         while (z < y)
1752         {
1753             y = z;
1754             z = ((add((x / z),z)) / 2);
1755         }
1756     }
1757 
1758     /**
1759      * @dev gives square. multiplies x by x
1760      */
1761     function sq(uint256 x)
1762         internal
1763         pure
1764         returns (uint256)
1765     {
1766         return (mul(x,x));
1767     }
1768 
1769     /**
1770      * @dev x to the power of y
1771      */
1772     function pwr(uint256 x, uint256 y)
1773         internal
1774         pure
1775         returns (uint256)
1776     {
1777         if (x==0)
1778             return (0);
1779         else if (y==0)
1780             return (1);
1781         else
1782         {
1783             uint256 z = x;
1784             for (uint256 i=1; i < y; i++)
1785                 z = mul(z,x);
1786             return (z);
1787         }
1788     }
1789 }