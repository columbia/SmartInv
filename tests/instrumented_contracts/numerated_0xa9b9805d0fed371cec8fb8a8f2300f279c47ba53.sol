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
123 contract F4Kings is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcShort for uint256;
127 
128     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xf626967fA13d841fd74D49dEe9bDd0D0dD6C4394);
129 
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     address private admin = msg.sender;
135     address private shareCom = 0x431C4354dB7f2b9aC1d9B2019e925C85C725DA5c;
136 
137     string constant public name = "f4kings";
138     string constant public symbol = "f4kings";
139 
140     uint256 private rndExtra_ = 0;     // length of the very first ICO
141     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
142 
143     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
144     uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
145     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
146 
147     uint256 constant private rndLimit_ = 3;                // limit rnd eth purchase
148 
149 //==============================================================================
150 //     _| _ _|_ _    _ _ _|_    _   .
151 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
152 //=============================|================================================
153     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
154     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
155     uint256 public rID_;    // round id number / total rounds that have happened
156 //****************
157 // PLAYER DATA
158 //****************
159     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
160     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
161     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
162     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
163     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
164 //****************
165 // ROUND DATA
166 //****************
167     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
168     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
169 //****************
170 // TEAM FEE DATA
171 //****************
172     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
173     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
174 //==============================================================================
175 //     _ _  _  __|_ _    __|_ _  _  .
176 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
177 //==============================================================================
178     constructor()
179         public
180     {
181 		// Team allocation structures
182         // 0 = whales
183         // 1 = bears
184         // 2 = sneks
185         // 3 = bulls
186 
187 		// Team allocation percentages
188         // (F3D) + (Pot , Referrals, Community)
189             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
190         fees_[0] = F3Ddatasets.TeamFee(22,0);   //48% to pot, 18% to aff, 10% to com, 1% to pot swap, 1% to air drop pot
191         fees_[1] = F3Ddatasets.TeamFee(32,0);   //38% to pot, 18% to aff, 10% to com, 1% to pot swap, 1% to air drop pot
192         fees_[2] = F3Ddatasets.TeamFee(52,0);   //18% to pot, 18% to aff, 10% to com, 1% to pot swap, 1% to air drop pot
193         fees_[3] = F3Ddatasets.TeamFee(42,0);   //28% to pot, 18% to aff, 10% to com, 1% to pot swap, 1% to air drop pot
194 
195         // how to split up the final pot based on which team was picked
196         // (F3D)
197         potSplit_[0] = F3Ddatasets.PotSplit(42,0);  //48% to winner, 0% to next round, 10% to com
198         potSplit_[1] = F3Ddatasets.PotSplit(34,0);  //48% to winner, 8% to next round, 10% to com
199         potSplit_[2] = F3Ddatasets.PotSplit(18,0);  //48% to winner, 24% to next round, 10% to com
200         potSplit_[3] = F3Ddatasets.PotSplit(26,0);  //48% to winner, 16% to next round, 10% to com
201 	}
202 //==============================================================================
203 //     _ _  _  _|. |`. _  _ _  .
204 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
205 //==============================================================================
206     /**
207      * @dev used to make sure no one can interact with contract until it has
208      * been activated.
209      */
210     modifier isActivated() {
211         require(activated_ == true, "its not ready yet.  check ?eta in discord");
212         _;
213     }
214 
215     /**
216      * @dev prevents contracts from interacting with fomo3d
217      */
218     modifier isHuman() {
219         address _addr = msg.sender;
220         uint256 _codeLength;
221 
222         assembly {_codeLength := extcodesize(_addr)}
223         require(_codeLength == 0, "sorry humans only");
224         _;
225     }
226 
227     /**
228      * @dev sets boundaries for incoming tx
229      */
230     modifier isWithinLimits(uint256 _eth) {
231         require(_eth >= 1000000000, "pocket lint: not a valid currency");
232         require(_eth <= 100000000000000000000000, "no vitalik, no");
233         _;
234     }
235 
236 //==============================================================================
237 //     _    |_ |. _   |`    _  __|_. _  _  _  .
238 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
239 //====|=========================================================================
240     /**
241      * @dev emergency buy uses last stored affiliate ID and team snek
242      */
243     function()
244         isActivated()
245         isHuman()
246         isWithinLimits(msg.value)
247         public
248         payable
249     {
250         // set up our tx event data and determine if player is new or not
251         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
252 
253         // fetch player id
254         uint256 _pID = pIDxAddr_[msg.sender];
255 
256         // buy core
257         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
258     }
259 
260     function buyXid(uint256 _affCode, uint256 _team)
261         isActivated()
262         isHuman()
263         isWithinLimits(msg.value)
264         public
265         payable
266     {
267         // set up our tx event data and determine if player is new or not
268         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
269 
270         // fetch player id
271         uint256 _pID = pIDxAddr_[msg.sender];
272 
273         // manage affiliate residuals
274         // if no affiliate code was given or player tried to use their own, lolz
275         if (_affCode == 0 || _affCode == _pID)
276         {
277             // use last stored affiliate code
278             _affCode = plyr_[_pID].laff;
279 
280         // if affiliate code was given & its not the same as previously stored
281         } else if (_affCode != plyr_[_pID].laff) {
282             // update last affiliate
283             plyr_[_pID].laff = _affCode;
284         }
285 
286         // verify a valid team was selected
287         _team = verifyTeam(_team);
288 
289         // buy core
290         buyCore(_pID, _affCode, _team, _eventData_);
291     }
292 
293     function buyXaddr(address _affCode, uint256 _team)
294         isActivated()
295         isHuman()
296         isWithinLimits(msg.value)
297         public
298         payable
299     {
300         // set up our tx event data and determine if player is new or not
301         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
302 
303         // fetch player id
304         uint256 _pID = pIDxAddr_[msg.sender];
305 
306         // manage affiliate residuals
307         uint256 _affID;
308         // if no affiliate code was given or player tried to use their own, lolz
309         if (_affCode == address(0) || _affCode == msg.sender)
310         {
311             // use last stored affiliate code
312             _affID = plyr_[_pID].laff;
313 
314         // if affiliate code was given
315         } else {
316             // get affiliate ID from aff Code
317             _affID = pIDxAddr_[_affCode];
318 
319             // if affID is not the same as previously stored
320             if (_affID != plyr_[_pID].laff)
321             {
322                 // update last affiliate
323                 plyr_[_pID].laff = _affID;
324             }
325         }
326 
327         // verify a valid team was selected
328         _team = verifyTeam(_team);
329 
330         // buy core
331         buyCore(_pID, _affID, _team, _eventData_);
332     }
333 
334     function buyXname(bytes32 _affCode, uint256 _team)
335         isActivated()
336         isHuman()
337         isWithinLimits(msg.value)
338         public
339         payable
340     {
341         // set up our tx event data and determine if player is new or not
342         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
343 
344         // fetch player id
345         uint256 _pID = pIDxAddr_[msg.sender];
346 
347         // manage affiliate residuals
348         uint256 _affID;
349         // if no affiliate code was given or player tried to use their own, lolz
350         if (_affCode == '' || _affCode == plyr_[_pID].name)
351         {
352             // use last stored affiliate code
353             _affID = plyr_[_pID].laff;
354 
355         // if affiliate code was given
356         } else {
357             // get affiliate ID from aff Code
358             _affID = pIDxName_[_affCode];
359 
360             // if affID is not the same as previously stored
361             if (_affID != plyr_[_pID].laff)
362             {
363                 // update last affiliate
364                 plyr_[_pID].laff = _affID;
365             }
366         }
367 
368         // verify a valid team was selected
369         _team = verifyTeam(_team);
370 
371         // buy core
372         buyCore(_pID, _affID, _team, _eventData_);
373     }
374 
375     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
376         isActivated()
377         isHuman()
378         isWithinLimits(_eth)
379         public
380     {
381         // set up our tx event data
382         F3Ddatasets.EventReturns memory _eventData_;
383 
384         // fetch player ID
385         uint256 _pID = pIDxAddr_[msg.sender];
386 
387         // manage affiliate residuals
388         // if no affiliate code was given or player tried to use their own, lolz
389         if (_affCode == 0 || _affCode == _pID)
390         {
391             // use last stored affiliate code
392             _affCode = plyr_[_pID].laff;
393 
394         // if affiliate code was given & its not the same as previously stored
395         } else if (_affCode != plyr_[_pID].laff) {
396             // update last affiliate
397             plyr_[_pID].laff = _affCode;
398         }
399 
400         // verify a valid team was selected
401         _team = verifyTeam(_team);
402 
403         // reload core
404         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
405     }
406 
407     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
408         isActivated()
409         isHuman()
410         isWithinLimits(_eth)
411         public
412     {
413         // set up our tx event data
414         F3Ddatasets.EventReturns memory _eventData_;
415 
416         // fetch player ID
417         uint256 _pID = pIDxAddr_[msg.sender];
418 
419         // manage affiliate residuals
420         uint256 _affID;
421         // if no affiliate code was given or player tried to use their own, lolz
422         if (_affCode == address(0) || _affCode == msg.sender)
423         {
424             // use last stored affiliate code
425             _affID = plyr_[_pID].laff;
426 
427         // if affiliate code was given
428         } else {
429             // get affiliate ID from aff Code
430             _affID = pIDxAddr_[_affCode];
431 
432             // if affID is not the same as previously stored
433             if (_affID != plyr_[_pID].laff)
434             {
435                 // update last affiliate
436                 plyr_[_pID].laff = _affID;
437             }
438         }
439 
440         // verify a valid team was selected
441         _team = verifyTeam(_team);
442 
443         // reload core
444         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
445     }
446 
447     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
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
462         if (_affCode == '' || _affCode == plyr_[_pID].name)
463         {
464             // use last stored affiliate code
465             _affID = plyr_[_pID].laff;
466 
467         // if affiliate code was given
468         } else {
469             // get affiliate ID from aff Code
470             _affID = pIDxName_[_affCode];
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
487     /**
488      * @dev withdraws all of your earnings.
489      * -functionhash- 0x3ccfd60b
490      */
491     function withdraw()
492         isActivated()
493         isHuman()
494         public
495     {
496         // setup local rID
497         uint256 _rID = rID_;
498 
499         // grab time
500         uint256 _now = now;
501 
502         // fetch player ID
503         uint256 _pID = pIDxAddr_[msg.sender];
504 
505         // setup temp var for player eth
506         uint256 _eth;
507         uint256 _withdrawFee;
508 
509         // check to see if round has ended and no one has run round end yet
510         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
511         {
512             // set up our tx event data
513             F3Ddatasets.EventReturns memory _eventData_;
514 
515             // end the round (distributes pot)
516 			round_[_rID].ended = true;
517             _eventData_ = endRound(_eventData_);
518 
519 			// get their earnings
520             _eth = withdrawEarnings(_pID);
521 
522             // gib moni
523             if (_eth > 0)
524             {
525                 //10% trade tax
526                 _withdrawFee = _eth / 10;
527                 uint256 _p1 = _withdrawFee.mul(65) / 100;
528                 uint256 _p2 = _withdrawFee.mul(35) / 100;
529                 shareCom.transfer(_p1);
530                 admin.transfer(_p2);
531                 
532                 plyr_[_pID].addr.transfer(_eth.sub(_withdrawFee));
533             }
534                 
535             // build event data
536             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
537             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
538 
539             // fire withdraw and distribute event
540             emit F3Devents.onWithdrawAndDistribute
541             (
542                 msg.sender,
543                 plyr_[_pID].name,
544                 _eth,
545                 _eventData_.compressedData,
546                 _eventData_.compressedIDs,
547                 _eventData_.winnerAddr,
548                 _eventData_.winnerName,
549                 _eventData_.amountWon,
550                 _eventData_.newPot,
551                 _eventData_.P3DAmount,
552                 _eventData_.genAmount
553             );
554 
555         // in any other situation
556         } else {
557             // get their earnings
558             _eth = withdrawEarnings(_pID);
559 
560             // gib moni
561             if (_eth > 0) 
562             {
563                 //10% trade tax
564                 _withdrawFee = _eth / 10;
565                 _p1 = _withdrawFee.mul(65) / 100;
566                 _p2 = _withdrawFee.mul(35) / 100;
567                 shareCom.transfer(_p1);
568                 admin.transfer(_p2);
569 
570                 plyr_[_pID].addr.transfer(_eth.sub(_withdrawFee));
571             }
572 
573             // fire withdraw event
574             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
575         }
576     }
577 
578     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
579         isHuman()
580         public
581         payable
582     {
583         bytes32 _name = _nameString.nameFilter();
584         address _addr = msg.sender;
585         uint256 _paid = msg.value;
586         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
587 
588         uint256 _pID = pIDxAddr_[_addr];
589 
590         // fire event
591         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
592     }
593 
594     function registerNameXaddr(string _nameString, address _affCode, bool _all)
595         isHuman()
596         public
597         payable
598     {
599         bytes32 _name = _nameString.nameFilter();
600         address _addr = msg.sender;
601         uint256 _paid = msg.value;
602         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
603 
604         uint256 _pID = pIDxAddr_[_addr];
605 
606         // fire event
607         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
608     }
609 
610     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
611         isHuman()
612         public
613         payable
614     {
615         bytes32 _name = _nameString.nameFilter();
616         address _addr = msg.sender;
617         uint256 _paid = msg.value;
618         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
619 
620         uint256 _pID = pIDxAddr_[_addr];
621 
622         // fire event
623         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
624     }
625 //==============================================================================
626 //     _  _ _|__|_ _  _ _  .
627 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
628 //=====_|=======================================================================
629     /**
630      * @dev return the price buyer will pay for next 1 individual key.
631      * -functionhash- 0x018a25e8
632      * @return price for next key bought (in wei format)
633      */
634     function getBuyPrice()
635         public
636         view
637         returns(uint256)
638     {
639         // setup local rID
640         uint256 _rID = rID_;
641 
642         // grab time
643         uint256 _now = now;
644 
645         // are we in a round?
646         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
647             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
648         else  // rounds over.  need price for new round
649             return ( 100000000000000 ); // init
650     }
651 
652     /**
653      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
654      * provider
655      * -functionhash- 0xc7e284b8
656      * @return time left in seconds
657      */
658     function getTimeLeft()
659         public
660         view
661         returns(uint256)
662     {
663         // setup local rID
664         uint256 _rID = rID_;
665 
666         // grab time
667         uint256 _now = now;
668 
669         if (_now < round_[_rID].end)
670             if (_now > round_[_rID].strt + rndGap_)
671                 return( (round_[_rID].end).sub(_now) );
672             else
673                 return( (round_[_rID].strt + rndGap_).sub(_now) );
674         else
675             return(0);
676     }
677 
678     function getPlayerVaults(uint256 _pID)
679         public
680         view
681         returns(uint256 ,uint256, uint256)
682     {
683         // setup local rID
684         uint256 _rID = rID_;
685 
686         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
687         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
688         {
689             // if player is winner
690             if (round_[_rID].plyr == _pID)
691             {
692                 return
693                 (
694                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
695                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
696                     plyr_[_pID].aff
697                 );
698             // if player is not the winner
699             } else {
700                 return
701                 (
702                     plyr_[_pID].win,
703                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
704                     plyr_[_pID].aff
705                 );
706             }
707 
708         // if round is still going on, or round has ended and round end has been ran
709         } else {
710             return
711             (
712                 plyr_[_pID].win,
713                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
714                 plyr_[_pID].aff
715             );
716         }
717     }
718 
719     /**
720      * solidity hates stack limits.  this lets us avoid that hate
721      */
722     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
723         private
724         view
725         returns(uint256)
726     {
727         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
728     }
729 
730     function getCurrentRoundInfo()
731         public
732         view
733         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
734     {
735         // setup local rID
736         uint256 _rID = rID_;
737 
738         return
739         (
740             round_[_rID].ico,               //0
741             _rID,                           //1
742             round_[_rID].keys,              //2
743             round_[_rID].end,               //3
744             round_[_rID].strt,              //4
745             round_[_rID].pot,               //5
746             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
747             plyr_[round_[_rID].plyr].addr,  //7
748             plyr_[round_[_rID].plyr].name,  //8
749             rndTmEth_[_rID][0],             //9
750             rndTmEth_[_rID][1],             //10
751             rndTmEth_[_rID][2],             //11
752             rndTmEth_[_rID][3],             //12
753             airDropTracker_ + (airDropPot_ * 1000)              //13
754         );
755     }
756 
757     function getPlayerInfoByAddress(address _addr)
758         public
759         view
760         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
761     {
762         // setup local rID
763         uint256 _rID = rID_;
764 
765         if (_addr == address(0))
766         {
767             _addr == msg.sender;
768         }
769         uint256 _pID = pIDxAddr_[_addr];
770 
771         return
772         (
773             _pID,                               //0
774             plyr_[_pID].name,                   //1
775             plyrRnds_[_pID][_rID].keys,         //2
776             plyr_[_pID].win,                    //3
777             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
778             plyr_[_pID].aff,                    //5
779             plyrRnds_[_pID][_rID].eth           //6
780         );
781     }
782 
783 //==============================================================================
784 //     _ _  _ _   | _  _ . _  .
785 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
786 //=====================_|=======================================================
787     /**
788      * @dev logic runs whenever a buy order is executed.  determines how to handle
789      * incoming eth depending on if we are in an active round or not
790      */
791     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
792         private
793     {
794         // setup local rID
795         uint256 _rID = rID_;
796 
797         // grab time
798         uint256 _now = now;
799 
800         // if round is active
801         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
802         {
803             // call core
804             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
805 
806         // if round is not active
807         } else {
808             // check to see if end round needs to be ran
809             if (_now > round_[_rID].end && round_[_rID].ended == false)
810             {
811                 // end the round (distributes pot) & start new round
812 			    round_[_rID].ended = true;
813                 _eventData_ = endRound(_eventData_);
814 
815                 // build event data
816                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
817                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
818 
819                 // fire buy and distribute event
820                 emit F3Devents.onBuyAndDistribute
821                 (
822                     msg.sender,
823                     plyr_[_pID].name,
824                     msg.value,
825                     _eventData_.compressedData,
826                     _eventData_.compressedIDs,
827                     _eventData_.winnerAddr,
828                     _eventData_.winnerName,
829                     _eventData_.amountWon,
830                     _eventData_.newPot,
831                     _eventData_.P3DAmount,
832                     _eventData_.genAmount
833                 );
834             }
835 
836             // put eth in players vault
837             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
838         }
839     }
840 
841     /**
842      * @dev logic runs whenever a reload order is executed.  determines how to handle
843      * incoming eth depending on if we are in an active round or not
844      */
845     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
846         private
847     {
848         // setup local rID
849         uint256 _rID = rID_;
850 
851         // grab time
852         uint256 _now = now;
853 
854         // if round is active
855         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
856         {
857             // get earnings from all vaults and return unused to gen vault
858             // because we use a custom safemath library.  this will throw if player
859             // tried to spend more eth than they have.
860             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
861 
862             // call core
863             core(_rID, _pID, _eth, _affID, _team, _eventData_);
864 
865         // if round is not active and end round needs to be ran
866         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
867             // end the round (distributes pot) & start new round
868             round_[_rID].ended = true;
869             _eventData_ = endRound(_eventData_);
870 
871             // build event data
872             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
873             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
874 
875             // fire buy and distribute event
876             emit F3Devents.onReLoadAndDistribute
877             (
878                 msg.sender,
879                 plyr_[_pID].name,
880                 _eventData_.compressedData,
881                 _eventData_.compressedIDs,
882                 _eventData_.winnerAddr,
883                 _eventData_.winnerName,
884                 _eventData_.amountWon,
885                 _eventData_.newPot,
886                 _eventData_.P3DAmount,
887                 _eventData_.genAmount
888             );
889         }
890     }
891 
892     /**
893      * @dev this is the core logic for any buy/reload that happens while a round
894      * is live.
895      */
896     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
897         private
898     {
899         // if player is new to round
900         if (plyrRnds_[_pID][_rID].keys == 0)
901             _eventData_ = managePlayer(_pID, _eventData_);
902 
903         // if eth left is greater than min eth allowed (sorry no pocket lint)
904         if (_eth > 1000000000)
905         {
906 
907             // mint the new keys
908             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
909 
910             // if they bought at least 1 whole key
911             if (_keys >= 1000000000000000000)
912             {
913                 updateTimer(_keys, _rID);
914 
915                 // set new leaders
916                 if (round_[_rID].plyr != _pID)
917                     round_[_rID].plyr = _pID;
918                 if (round_[_rID].team != _team)
919                     round_[_rID].team = _team;
920 
921                 // set the new leader bool to true
922                 _eventData_.compressedData = _eventData_.compressedData + 100;
923             }
924 
925             // manage airdrops
926             if (_eth >= 100000000000000000)
927             {
928             airDropTracker_++;
929             if (airdrop() == true)
930             {
931                 // gib muni
932                 uint256 _prize;
933                 if (_eth >= 10000000000000000000)
934                 {
935                     // calculate prize and give it to winner
936                     _prize = ((airDropPot_).mul(75)) / 100;
937                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
938 
939                     // adjust airDropPot
940                     airDropPot_ = (airDropPot_).sub(_prize);
941 
942                     // let event know a tier 3 prize was won
943                     _eventData_.compressedData += 300000000000000000000000000000000;
944                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
945                     // calculate prize and give it to winner
946                     _prize = ((airDropPot_).mul(50)) / 100;
947                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
948 
949                     // adjust airDropPot
950                     airDropPot_ = (airDropPot_).sub(_prize);
951 
952                     // let event know a tier 2 prize was won
953                     _eventData_.compressedData += 200000000000000000000000000000000;
954                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
955                     // calculate prize and give it to winner
956                     _prize = ((airDropPot_).mul(25)) / 100;
957                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
958 
959                     // adjust airDropPot
960                     airDropPot_ = (airDropPot_).sub(_prize);
961 
962                     // let event know a tier 3 prize was won
963                     _eventData_.compressedData += 300000000000000000000000000000000;
964                 }
965                 // set airdrop happened bool to true
966                 _eventData_.compressedData += 10000000000000000000000000000000;
967                 // let event know how much was won
968                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
969 
970                 // reset air drop tracker
971                 airDropTracker_ = 0;
972             }
973         }
974 
975             // store the air drop tracker number (number of buys since last airdrop)
976             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
977 
978             // update player
979             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
980             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
981 
982             // update round
983             round_[_rID].keys = _keys.add(round_[_rID].keys);
984             round_[_rID].eth = _eth.add(round_[_rID].eth);
985             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
986 
987             // distribute eth
988             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
989             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
990 
991             // call end tx function to fire end tx event.
992 		    endTx(_pID, _team, _eth, _keys, _eventData_);
993         }
994     }
995 //==============================================================================
996 //     _ _ | _   | _ _|_ _  _ _  .
997 //    (_(_||(_|_||(_| | (_)| _\  .
998 //==============================================================================
999     /**
1000      * @dev calculates unmasked earnings (just calculates, does not update mask)
1001      * @return earnings in wei format
1002      */
1003     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1004         private
1005         view
1006         returns(uint256)
1007     {
1008         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1009     }
1010 
1011     /**
1012      * @dev returns the amount of keys you would get given an amount of eth.
1013      * -functionhash- 0xce89c80c
1014      * @param _rID round ID you want price for
1015      * @param _eth amount of eth sent in
1016      * @return keys received
1017      */
1018     function calcKeysReceived(uint256 _rID, uint256 _eth)
1019         public
1020         view
1021         returns(uint256)
1022     {
1023         // grab time
1024         uint256 _now = now;
1025 
1026         // are we in a round?
1027         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1028             return ( (round_[_rID].eth).keysRec(_eth) );
1029         else // rounds over.  need keys for new round
1030             return ( (_eth).keys() );
1031     }
1032 
1033     /**
1034      * @dev returns current eth price for X keys.
1035      * -functionhash- 0xcf808000
1036      * @param _keys number of keys desired (in 18 decimal format)
1037      * @return amount of eth needed to send
1038      */
1039     function iWantXKeys(uint256 _keys)
1040         public
1041         view
1042         returns(uint256)
1043     {
1044         // setup local rID
1045         uint256 _rID = rID_;
1046 
1047         // grab time
1048         uint256 _now = now;
1049 
1050         // are we in a round?
1051         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1052             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1053         else // rounds over.  need price for new round
1054             return ( (_keys).eth() );
1055     }
1056 //==============================================================================
1057 //    _|_ _  _ | _  .
1058 //     | (_)(_)|_\  .
1059 //==============================================================================
1060     /**
1061 	 * @dev receives name/player info from names contract
1062      */
1063     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1064         external
1065     {
1066         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1067         if (pIDxAddr_[_addr] != _pID)
1068             pIDxAddr_[_addr] = _pID;
1069         if (pIDxName_[_name] != _pID)
1070             pIDxName_[_name] = _pID;
1071         if (plyr_[_pID].addr != _addr)
1072             plyr_[_pID].addr = _addr;
1073         if (plyr_[_pID].name != _name)
1074             plyr_[_pID].name = _name;
1075         if (plyr_[_pID].laff != _laff)
1076             plyr_[_pID].laff = _laff;
1077         if (plyrNames_[_pID][_name] == false)
1078             plyrNames_[_pID][_name] = true;
1079     }
1080 
1081     /**
1082      * @dev receives entire player name list
1083      */
1084     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1085         external
1086     {
1087         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1088         if(plyrNames_[_pID][_name] == false)
1089             plyrNames_[_pID][_name] = true;
1090     }
1091 
1092     /**
1093      * @dev gets existing or registers new pID.  use this when a player may be new
1094      * @return pID
1095      */
1096     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1097         private
1098         returns (F3Ddatasets.EventReturns)
1099     {
1100         uint256 _pID = pIDxAddr_[msg.sender];
1101         // if player is new to this version of fomo3d
1102         if (_pID == 0)
1103         {
1104             // grab their player ID, name and last aff ID, from player names contract
1105             _pID = PlayerBook.getPlayerID(msg.sender);
1106             bytes32 _name = PlayerBook.getPlayerName(_pID);
1107             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1108 
1109             // set up player account
1110             pIDxAddr_[msg.sender] = _pID;
1111             plyr_[_pID].addr = msg.sender;
1112 
1113             if (_name != "")
1114             {
1115                 pIDxName_[_name] = _pID;
1116                 plyr_[_pID].name = _name;
1117                 plyrNames_[_pID][_name] = true;
1118             }
1119 
1120             if (_laff != 0 && _laff != _pID)
1121                 plyr_[_pID].laff = _laff;
1122 
1123             // set the new player bool to true
1124             _eventData_.compressedData = _eventData_.compressedData + 1;
1125         }
1126         return (_eventData_);
1127     }
1128 
1129     /**
1130      * @dev checks to make sure user picked a valid team.  if not sets team
1131      * to default (sneks)
1132      */
1133     function verifyTeam(uint256 _team)
1134         private
1135         pure
1136         returns (uint256)
1137     {
1138         if (_team < 0 || _team > 3)
1139             return(2);
1140         else
1141             return(_team);
1142     }
1143 
1144     /**
1145      * @dev decides if round end needs to be run & new round started.  and if
1146      * player unmasked earnings from previously played rounds need to be moved.
1147      */
1148     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1149         private
1150         returns (F3Ddatasets.EventReturns)
1151     {
1152         // if player has played a previous round, move their unmasked earnings
1153         // from that round to gen vault.
1154         if (plyr_[_pID].lrnd != 0)
1155             updateGenVault(_pID, plyr_[_pID].lrnd);
1156 
1157         // update player's last round played
1158         plyr_[_pID].lrnd = rID_;
1159 
1160         // set the joined round bool to true
1161         _eventData_.compressedData = _eventData_.compressedData + 10;
1162 
1163         return(_eventData_);
1164     }
1165 
1166     /**
1167      * @dev ends the round. manages paying out winner/splitting up pot
1168      */
1169     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1170         private
1171         returns (F3Ddatasets.EventReturns)
1172     {
1173         // setup local rID
1174         uint256 _rID = rID_;
1175 
1176         // grab our winning player and team id's
1177         uint256 _winPID = round_[_rID].plyr;
1178         uint256 _winTID = round_[_rID].team;
1179 
1180         // grab our pot amount
1181         uint256 _pot = round_[_rID].pot;
1182 
1183         // calculate our winner share, community rewards, gen share,
1184         // p3d share, and amount reserved for next pot
1185         uint256 _win = (_pot.mul(48)) / 100;
1186         uint256 _com = (_pot / 10);
1187         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1188         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1189 
1190         // calculate ppt for round mask
1191         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1192         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1193         if (_dust > 0)
1194         {
1195             _gen = _gen.sub(_dust);
1196             _res = _res.add(_dust);
1197         }
1198 
1199         // pay our winner
1200         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1201 
1202         // community rewards
1203         shareCom.transfer((_com.mul(65) / 100));
1204         admin.transfer((_com.mul(35) / 100));
1205     
1206         // distribute gen portion to key holders
1207         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1208 
1209         // prepare event data
1210         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1211         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1212         _eventData_.winnerAddr = plyr_[_winPID].addr;
1213         _eventData_.winnerName = plyr_[_winPID].name;
1214         _eventData_.amountWon = _win;
1215         _eventData_.genAmount = _gen;
1216         _eventData_.P3DAmount = 0;
1217         _eventData_.newPot = _res;
1218 
1219         // start next round
1220         rID_++;
1221         _rID++;
1222         round_[_rID].strt = now;
1223         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1224         round_[_rID].pot = _res;
1225 
1226         return(_eventData_);
1227     }
1228 
1229     /**
1230      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1231      */
1232     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1233         private
1234     {
1235         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1236         if (_earnings > 0)
1237         {
1238             // put in gen vault
1239             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1240             // zero out their earnings by updating mask
1241             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1242         }
1243     }
1244 
1245     /**
1246      * @dev updates round timer based on number of whole keys bought.
1247      */
1248     function updateTimer(uint256 _keys, uint256 _rID)
1249         private
1250     {
1251         // grab time
1252         uint256 _now = now;
1253 
1254         uint256 _rndInc = rndInc_;
1255 
1256         if(round_[_rID].pot > rndLimit_) 
1257         {
1258             _rndInc = _rndInc / 2;
1259         }
1260             
1261         // calculate time based on number of keys bought
1262         uint256 _newTime;
1263         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1264             _newTime = (((_keys) / (1000000000000000000)).mul(_rndInc)).add(_now);
1265         else
1266             _newTime = (((_keys) / (1000000000000000000)).mul(_rndInc)).add(round_[_rID].end);
1267 
1268         // compare to max and set new end time
1269         if (_newTime < (rndMax_).add(_now))
1270             round_[_rID].end = _newTime;
1271         else
1272             round_[_rID].end = rndMax_.add(_now);
1273     }
1274 
1275     /**
1276      * @dev generates a random number between 0-99 and checks to see if thats
1277      * resulted in an airdrop win
1278      * @return do we have a winner?
1279      */
1280     function airdrop()
1281         private
1282         view
1283         returns(bool)
1284     {
1285         uint256 seed = uint256(keccak256(abi.encodePacked(
1286 
1287             (block.timestamp).add
1288             (block.difficulty).add
1289             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1290             (block.gaslimit).add
1291             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1292             (block.number)
1293 
1294         )));
1295         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1296             return(true);
1297         else
1298             return(false);
1299     }
1300 
1301     /**
1302      * @dev distributes eth based on fees to com, aff, and p3d
1303      */
1304     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1305         private
1306         returns(F3Ddatasets.EventReturns)
1307     {
1308          // pay community rewards
1309         uint256 _com = _eth / 10;
1310         uint256 _p3d;
1311         if (!address(admin).call.value(_com)())
1312         {
1313             _p3d = _com;
1314             _com = 0;
1315         }
1316 
1317         // pay 1% out to FoMo3D short
1318         // uint256 _long = _eth / 100;
1319         // otherF3D_.potSwap.value(_long)();
1320 
1321         _p3d = _p3d.add(distributeAff(_rID,_pID,_eth,_affID));
1322 
1323         // pay out p3d
1324         // _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1325         if (_p3d > 0)
1326         {
1327             // deposit to divies contract
1328             uint256 _potAmount = _p3d / 2;
1329             uint256 _amount = _p3d.sub(_potAmount);
1330 
1331             shareCom.transfer((_amount.mul(65)/100));
1332             admin.transfer((_amount.mul(35)/100));
1333             
1334             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1335 
1336             // set up event data
1337             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1338         }
1339 
1340         return(_eventData_);
1341     }
1342 
1343     function distributeAff(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
1344         private
1345         returns(uint256)
1346     {
1347         uint256 _addP3d = 0;
1348 
1349         // distribute share to affiliate
1350         uint256 _aff1 = _eth / 10;
1351         uint256 _aff2 = _eth / 20;
1352         uint256 _aff3 = _eth / 34;
1353 
1354         // decide what to do with affiliate share of fees
1355         // affiliate must not be self, and must have a name registered
1356         if ((_affID != 0) && (_affID != _pID) && (plyr_[_affID].name != '')) 
1357         {
1358             plyr_[_pID].laffID = _affID;
1359             plyr_[_affID].aff = _aff1.add(plyr_[_affID].aff);
1360             
1361             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff1, now);
1362 
1363             //second level aff
1364             uint256 _secLaff = plyr_[_affID].laffID; 
1365             if((_secLaff != 0) && (_secLaff != _pID))
1366             {
1367                 plyr_[_secLaff].aff = _aff2.add(plyr_[_secLaff].aff); 
1368                 emit F3Devents.onAffiliatePayout(_secLaff, plyr_[_secLaff].addr, plyr_[_secLaff].name, _rID, _pID, _aff2, now);
1369 
1370                 //third level aff
1371                 uint256 _thirdAff = plyr_[_secLaff].laffID; 
1372                 if((_thirdAff != 0 ) && (_thirdAff != _pID))
1373                 {
1374                     plyr_[_thirdAff].aff = _aff3.add(plyr_[_thirdAff].aff); 
1375                     emit F3Devents.onAffiliatePayout(_thirdAff, plyr_[_thirdAff].addr, plyr_[_thirdAff].name, _rID, _pID, _aff3, now);
1376                 } else {
1377                     _addP3d = _addP3d.add(_aff3); 
1378                 }
1379             } else {
1380                 _addP3d = _addP3d.add(_aff2); 
1381             } 
1382         } else {
1383             _addP3d = _addP3d.add(_aff1);
1384         }
1385         return(_addP3d);
1386     }
1387 
1388     function getPlayerAff(uint256 _pID)
1389         public
1390         view
1391         returns (uint256,uint256,uint256)
1392     {
1393         uint256 _affID = plyr_[_pID].laffID;
1394         if (_affID != 0) 
1395         {
1396             //second level aff
1397             uint256 _secondLaff = plyr_[_affID].laffID;
1398 
1399             if(_secondLaff != 0)
1400             {
1401                 //third level aff
1402                 uint256 _thirdAff = plyr_[_secondLaff].laffID;
1403             }
1404         }
1405         return (_affID,_secondLaff,_thirdAff);
1406     }
1407 
1408     function potSwap()
1409         external
1410         payable
1411     {
1412         // setup local rID
1413         uint256 _rID = rID_ + 1;
1414 
1415         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1416         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1417     }
1418 
1419     /**
1420      * @dev distributes eth based on fees to gen and pot
1421      */
1422     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1423         private
1424         returns(F3Ddatasets.EventReturns)
1425     {
1426         // calculate gen share
1427         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1428 
1429         // toss 1% into airdrop pot
1430         uint256 _air = (_eth / 100);
1431         airDropPot_ = airDropPot_.add(_air);
1432 
1433         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1434         //_eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1435         _eth = _eth.sub(_eth.mul(30) / 100);
1436 
1437         // calculate pot
1438         uint256 _pot = _eth.sub(_gen);
1439 
1440         // distribute gen share (thats what updateMasks() does) and adjust
1441         // balances for dust.
1442         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1443         if (_dust > 0)
1444             _gen = _gen.sub(_dust);
1445 
1446         // add eth to pot
1447         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1448 
1449         // set up event data
1450         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1451         _eventData_.potAmount = _pot;
1452 
1453         return(_eventData_);
1454     }
1455 
1456     /**
1457      * @dev updates masks for round and player when keys are bought
1458      * @return dust left over
1459      */
1460     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1461         private
1462         returns(uint256)
1463     {
1464         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1465         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1466         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1467 
1468         // calculate player earning from their own buy (only based on the keys
1469         // they just bought).  & update player earnings mask
1470         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1471         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1472 
1473         // calculate & return dust
1474         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1475     }
1476 
1477     /**
1478      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1479      * @return earnings in wei format
1480      */
1481     function withdrawEarnings(uint256 _pID)
1482         private
1483         returns(uint256)
1484     {
1485         // update gen vault
1486         updateGenVault(_pID, plyr_[_pID].lrnd);
1487 
1488         // from vaults
1489         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1490         if (_earnings > 0)
1491         {
1492             plyr_[_pID].win = 0;
1493             plyr_[_pID].gen = 0;
1494             plyr_[_pID].aff = 0;
1495         }
1496 
1497         return(_earnings);
1498     }
1499 
1500     /**
1501      * @dev prepares compression data and fires event for buy or reload tx's
1502      */
1503     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1504         private
1505     {
1506         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1507         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1508 
1509         emit F3Devents.onEndTx
1510         (
1511             _eventData_.compressedData,
1512             _eventData_.compressedIDs,
1513             plyr_[_pID].name,
1514             msg.sender,
1515             _eth,
1516             _keys,
1517             _eventData_.winnerAddr,
1518             _eventData_.winnerName,
1519             _eventData_.amountWon,
1520             _eventData_.newPot,
1521             _eventData_.P3DAmount,
1522             _eventData_.genAmount,
1523             _eventData_.potAmount,
1524             airDropPot_
1525         );
1526     }
1527 //==============================================================================
1528 //    (~ _  _    _._|_    .
1529 //    _)(/_(_|_|| | | \/  .
1530 //====================/=========================================================
1531     /** upon contract deploy, it will be deactivated.  this is a one time
1532      * use function that will activate the contract.  we do this so devs
1533      * have time to set things up on the web end                            **/
1534     bool public activated_ = false;
1535     function activate()
1536         public
1537     {
1538         // only team just can activate
1539         require(msg.sender == admin, "only admin can activate");
1540 
1541 
1542         // can only be ran once
1543         require(activated_ == false, "FOMO Short already activated");
1544 
1545         // activate the contract
1546         activated_ = true;
1547 
1548         // lets start first round
1549         rID_ = 1;
1550             round_[1].strt = now + rndExtra_ - rndGap_;
1551             round_[1].end = now + rndInit_ + rndExtra_;
1552     }
1553 }
1554 
1555 //==============================================================================
1556 //   __|_ _    __|_ _  .
1557 //  _\ | | |_|(_ | _\  .
1558 //==============================================================================
1559 library F3Ddatasets {
1560     //compressedData key
1561     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1562         // 0 - new player (bool)
1563         // 1 - joined round (bool)
1564         // 2 - new  leader (bool)
1565         // 3-5 - air drop tracker (uint 0-999)
1566         // 6-16 - round end time
1567         // 17 - winnerTeam
1568         // 18 - 28 timestamp
1569         // 29 - team
1570         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1571         // 31 - airdrop happened bool
1572         // 32 - airdrop tier
1573         // 33 - airdrop amount won
1574     //compressedIDs key
1575     // [77-52][51-26][25-0]
1576         // 0-25 - pID
1577         // 26-51 - winPID
1578         // 52-77 - rID
1579     struct EventReturns {
1580         uint256 compressedData;
1581         uint256 compressedIDs;
1582         address winnerAddr;         // winner address
1583         bytes32 winnerName;         // winner name
1584         uint256 amountWon;          // amount won
1585         uint256 newPot;             // amount in new pot
1586         uint256 P3DAmount;          // amount distributed to p3d
1587         uint256 genAmount;          // amount distributed to gen
1588         uint256 potAmount;          // amount added to pot
1589     }
1590     struct Player {
1591         address addr;   // player address
1592         bytes32 name;   // player name
1593         uint256 win;    // winnings vault
1594         uint256 gen;    // general vault
1595         uint256 aff;    // affiliate vault
1596         uint256 lrnd;   // last round played
1597         uint256 laff;   // last affiliate id used
1598         uint256 laffID;   // last affiliate id unaffected
1599     }
1600     struct PlayerRounds {
1601         uint256 eth;    // eth player has added to round (used for eth limiter)
1602         uint256 keys;   // keys
1603         uint256 mask;   // player mask
1604         uint256 ico;    // ICO phase investment
1605     }
1606     struct Round {
1607         uint256 plyr;   // pID of player in lead
1608         uint256 team;   // tID of team in lead
1609         uint256 end;    // time ends/ended
1610         bool ended;     // has round end function been ran
1611         uint256 strt;   // time round started
1612         uint256 keys;   // keys
1613         uint256 eth;    // total eth in
1614         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1615         uint256 mask;   // global mask
1616         uint256 ico;    // total eth sent in during ICO phase
1617         uint256 icoGen; // total eth for gen during ICO phase
1618         uint256 icoAvg; // average key price for ICO phase
1619     }
1620     struct TeamFee {
1621         uint256 gen;    // % of buy in thats paid to key holders of current round
1622         uint256 p3d;    // % of buy in thats paid to p3d holders
1623     }
1624     struct PotSplit {
1625         uint256 gen;    // % of pot thats paid to key holders of current round
1626         uint256 p3d;    // % of pot thats paid to p3d holders
1627     }
1628 }
1629 
1630 //==============================================================================
1631 //  |  _      _ _ | _  .
1632 //  |<(/_\/  (_(_||(_  .
1633 //=======/======================================================================
1634 library F3DKeysCalcShort {
1635     using SafeMath for *;
1636     /**
1637      * @dev calculates number of keys received given X eth
1638      * @param _curEth current amount of eth in contract
1639      * @param _newEth eth being spent
1640      * @return amount of ticket purchased
1641      */
1642     function keysRec(uint256 _curEth, uint256 _newEth)
1643         internal
1644         pure
1645         returns (uint256)
1646     {
1647         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1648     }
1649 
1650     /**
1651      * @dev calculates amount of eth received if you sold X keys
1652      * @param _curKeys current amount of keys that exist
1653      * @param _sellKeys amount of keys you wish to sell
1654      * @return amount of eth received
1655      */
1656     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1657         internal
1658         pure
1659         returns (uint256)
1660     {
1661         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1662     }
1663 
1664      /**
1665      * @dev calculates how many keys would exist with given an amount of eth
1666      * @param _eth eth "in contract"
1667      * @return number of keys that would exist
1668      */
1669     function keys(uint256 _eth) 
1670         internal
1671         pure
1672         returns(uint256)
1673     {
1674         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1675     }
1676     
1677     /**
1678      * @dev calculates how much eth would be in contract given a number of keys
1679      * @param _keys number of keys "in contract" 
1680      * @return eth that would exists
1681      */
1682     function eth(uint256 _keys) 
1683         internal
1684         pure
1685         returns(uint256)  
1686     {
1687         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1688     }
1689 }
1690 
1691 //==============================================================================
1692 //  . _ _|_ _  _ |` _  _ _  _  .
1693 //  || | | (/_| ~|~(_|(_(/__\  .
1694 //==============================================================================
1695 
1696 interface PlayerBookInterface {
1697     function getPlayerID(address _addr) external returns (uint256);
1698     function getPlayerName(uint256 _pID) external view returns (bytes32);
1699     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1700     function getPlayerAddr(uint256 _pID) external view returns (address);
1701     function getNameFee() external view returns (uint256);
1702     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1703     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1704     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1705 }
1706 
1707 library NameFilter {
1708 
1709     function nameFilter(string _input)
1710         internal
1711         pure
1712         returns(bytes32)
1713     {
1714         bytes memory _temp = bytes(_input);
1715         uint256 _length = _temp.length;
1716 
1717         //sorry limited to 32 characters
1718         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1719         // make sure it doesnt start with or end with space
1720         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1721         // make sure first two characters are not 0x
1722         if (_temp[0] == 0x30)
1723         {
1724             require(_temp[1] != 0x78, "string cannot start with 0x");
1725             require(_temp[1] != 0x58, "string cannot start with 0X");
1726         }
1727 
1728         // create a bool to track if we have a non number character
1729         bool _hasNonNumber;
1730 
1731         // convert & check
1732         for (uint256 i = 0; i < _length; i++)
1733         {
1734             // if its uppercase A-Z
1735             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1736             {
1737                 // convert to lower case a-z
1738                 _temp[i] = byte(uint(_temp[i]) + 32);
1739 
1740                 // we have a non number
1741                 if (_hasNonNumber == false)
1742                     _hasNonNumber = true;
1743             } else {
1744                 require
1745                 (
1746                     // require character is a space
1747                     _temp[i] == 0x20 ||
1748                     // OR lowercase a-z
1749                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1750                     // or 0-9
1751                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1752                     "string contains invalid characters"
1753                 );
1754                 // make sure theres not 2x spaces in a row
1755                 if (_temp[i] == 0x20)
1756                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1757 
1758                 // see if we have a character other than a number
1759                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1760                     _hasNonNumber = true;
1761             }
1762         }
1763 
1764         require(_hasNonNumber == true, "string cannot be only numbers");
1765 
1766         bytes32 _ret;
1767         assembly {
1768             _ret := mload(add(_temp, 32))
1769         }
1770         return (_ret);
1771     }
1772 }
1773 
1774 
1775 library SafeMath {
1776 
1777     /**
1778     * @dev Multiplies two numbers, throws on overflow.
1779     */
1780     function mul(uint256 a, uint256 b)
1781         internal
1782         pure
1783         returns (uint256 c)
1784     {
1785         if (a == 0) {
1786             return 0;
1787         }
1788         c = a * b;
1789         require(c / a == b, "SafeMath mul failed");
1790         return c;
1791     }
1792 
1793     /**
1794     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1795     */
1796     function sub(uint256 a, uint256 b)
1797         internal
1798         pure
1799         returns (uint256)
1800     {
1801         require(b <= a, "SafeMath sub failed");
1802         return a - b;
1803     }
1804 
1805     /**
1806     * @dev Adds two numbers, throws on overflow.
1807     */
1808     function add(uint256 a, uint256 b)
1809         internal
1810         pure
1811         returns (uint256 c)
1812     {
1813         c = a + b;
1814         require(c >= a, "SafeMath add failed");
1815         return c;
1816     }
1817 
1818     /**
1819      * @dev gives square root of given x.
1820      */
1821     function sqrt(uint256 x)
1822         internal
1823         pure
1824         returns (uint256 y)
1825     {
1826         uint256 z = ((add(x,1)) / 2);
1827         y = x;
1828         while (z < y)
1829         {
1830             y = z;
1831             z = ((add((x / z),z)) / 2);
1832         }
1833     }
1834 
1835     /**
1836      * @dev gives square. multiplies x by x
1837      */
1838     function sq(uint256 x)
1839         internal
1840         pure
1841         returns (uint256)
1842     {
1843         return (mul(x,x));
1844     }
1845 
1846     /**
1847      * @dev x to the power of y
1848      */
1849     function pwr(uint256 x, uint256 y)
1850         internal
1851         pure
1852         returns (uint256)
1853     {
1854         if (x==0)
1855             return (0);
1856         else if (y==0)
1857             return (1);
1858         else
1859         {
1860             uint256 z = x;
1861             for (uint256 i=1; i < y; i++)
1862                 z = mul(z,x);
1863             return (z);
1864         }
1865     }
1866 }