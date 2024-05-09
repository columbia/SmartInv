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
123 contract F3DGame is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcShort for uint256;
127 
128     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xC0E7e9b6a8Ccc06270069f1370c1F01163B094b9);
129 
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     address private admin = 0x700D7ccD114D988f0CEDDFCc60dd8c3a2f7b49FB;
135     address private coin_base = 0x3FB8bDB25b6ad6ccb78a4c1D54B3c010493D2F03;
136     string constant public name = "F3DGame";
137     string constant public symbol = "F3DGame";
138     uint256 private rndExtra_ = 0;     // length of the very first ICO
139     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
140     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
141     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
142     uint256 constant private rndMax_ = 7 hours;                // max length a round timer can be
143 //==============================================================================
144 //     _| _ _|_ _    _ _ _|_    _   .
145 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
146 //=============================|================================================
147     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
148     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
149     uint256 public rID_;    // round id number / total rounds that have happened
150 //****************
151 // PLAYER DATA
152 //****************
153     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
154     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
155     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
156     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
157     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
158 //****************
159 // ROUND DATA
160 //****************
161     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
162     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
163 //****************
164 // TEAM FEE DATA
165 //****************
166     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
167     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
168 //==============================================================================
169 //     _ _  _  __|_ _    __|_ _  _  .
170 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
171 //==============================================================================
172     constructor()
173         public
174     {
175 		// Team allocation structures
176         // 0 = whales
177         // 1 = bears
178         // 2 = sneks
179         // 3 = bulls
180 
181 		// Team allocation percentages
182         // (F3D, P3D) + (Pot , Referrals, Community)
183             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
184         fees_[0] = F3Ddatasets.TeamFee(22,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
185         fees_[1] = F3Ddatasets.TeamFee(38,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
186         fees_[2] = F3Ddatasets.TeamFee(52,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
187         fees_[3] = F3Ddatasets.TeamFee(68,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
188 
189         // how to split up the final pot based on which team was picked
190         // (F3D, P3D)
191         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
192         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
193         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
194         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
195 	}
196 //==============================================================================
197 //     _ _  _  _|. |`. _  _ _  .
198 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
199 //==============================================================================
200     /**
201      * @dev used to make sure no one can interact with contract until it has
202      * been activated.
203      */
204     modifier isActivated() {
205         require(activated_ == true, "its not ready yet.  check ?eta in discord");
206         _;
207     }
208 
209     /**
210      * @dev prevents contracts from interacting with fomo3d
211      */
212     modifier isHuman() {
213         address _addr = msg.sender;
214         uint256 _codeLength;
215 
216         assembly {_codeLength := extcodesize(_addr)}
217         require(_codeLength == 0, "sorry humans only");
218         _;
219     }
220 
221     /**
222      * @dev sets boundaries for incoming tx
223      */
224     modifier isWithinLimits(uint256 _eth) {
225         require(_eth >= 1000000000, "pocket lint: not a valid currency");
226         require(_eth <= 100000000000000000000000, "no vitalik, no");
227         _;
228     }
229 
230 //==============================================================================
231 //     _    |_ |. _   |`    _  __|_. _  _  _  .
232 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
233 //====|=========================================================================
234     /**
235      * @dev emergency buy uses last stored affiliate ID and team snek
236      */
237     function()
238         isActivated()
239         isHuman()
240         isWithinLimits(msg.value)
241         public
242         payable
243     {
244         // set up our tx event data and determine if player is new or not
245         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
246 
247         // fetch player id
248         uint256 _pID = pIDxAddr_[msg.sender];
249 
250         // buy core
251         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
252     }
253 
254     /**
255      * @dev converts all incoming ethereum to keys.
256      * -functionhash- 0x8f38f309 (using ID for affiliate)
257      * -functionhash- 0x98a0871d (using address for affiliate)
258      * -functionhash- 0xa65b37a1 (using name for affiliate)
259      * @param _affCode the ID/address/name of the player who gets the affiliate fee
260      * @param _team what team is the player playing for?
261      */
262     function buyXid(uint256 _affCode, uint256 _team)
263         isActivated()
264         isHuman()
265         isWithinLimits(msg.value)
266         public
267         payable
268     {
269         // set up our tx event data and determine if player is new or not
270         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
271 
272         // fetch player id
273         uint256 _pID = pIDxAddr_[msg.sender];
274 
275         // manage affiliate residuals
276         // if no affiliate code was given or player tried to use their own, lolz
277         if (_affCode == 0 || _affCode == _pID)
278         {
279             // use last stored affiliate code
280             _affCode = plyr_[_pID].laff;
281 
282         // if affiliate code was given & its not the same as previously stored
283         } else if (_affCode != plyr_[_pID].laff) {
284             // update last affiliate
285             plyr_[_pID].laff = _affCode;
286         }
287 
288         // verify a valid team was selected
289         _team = verifyTeam(_team);
290 
291         // buy core
292         buyCore(_pID, _affCode, _team, _eventData_);
293     }
294 
295     function buyXaddr(address _affCode, uint256 _team)
296         isActivated()
297         isHuman()
298         isWithinLimits(msg.value)
299         public
300         payable
301     {
302         // set up our tx event data and determine if player is new or not
303         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
304 
305         // fetch player id
306         uint256 _pID = pIDxAddr_[msg.sender];
307 
308         // manage affiliate residuals
309         uint256 _affID;
310         // if no affiliate code was given or player tried to use their own, lolz
311         if (_affCode == address(0) || _affCode == msg.sender)
312         {
313             // use last stored affiliate code
314             _affID = plyr_[_pID].laff;
315 
316         // if affiliate code was given
317         } else {
318             // get affiliate ID from aff Code
319             _affID = pIDxAddr_[_affCode];
320 
321             // if affID is not the same as previously stored
322             if (_affID != plyr_[_pID].laff)
323             {
324                 // update last affiliate
325                 plyr_[_pID].laff = _affID;
326             }
327         }
328 
329         // verify a valid team was selected
330         _team = verifyTeam(_team);
331 
332         // buy core
333         buyCore(_pID, _affID, _team, _eventData_);
334     }
335 
336     function buyXname(bytes32 _affCode, uint256 _team)
337         isActivated()
338         isHuman()
339         isWithinLimits(msg.value)
340         public
341         payable
342     {
343         // set up our tx event data and determine if player is new or not
344         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
345 
346         // fetch player id
347         uint256 _pID = pIDxAddr_[msg.sender];
348 
349         // manage affiliate residuals
350         uint256 _affID;
351         // if no affiliate code was given or player tried to use their own, lolz
352         if (_affCode == '' || _affCode == plyr_[_pID].name)
353         {
354             // use last stored affiliate code
355             _affID = plyr_[_pID].laff;
356 
357         // if affiliate code was given
358         } else {
359             // get affiliate ID from aff Code
360             _affID = pIDxName_[_affCode];
361 
362             // if affID is not the same as previously stored
363             if (_affID != plyr_[_pID].laff)
364             {
365                 // update last affiliate
366                 plyr_[_pID].laff = _affID;
367             }
368         }
369 
370         // verify a valid team was selected
371         _team = verifyTeam(_team);
372 
373         // buy core
374         buyCore(_pID, _affID, _team, _eventData_);
375     }
376 
377     /**
378      * @dev essentially the same as buy, but instead of you sending ether
379      * from your wallet, it uses your unwithdrawn earnings.
380      * -functionhash- 0x349cdcac (using ID for affiliate)
381      * -functionhash- 0x82bfc739 (using address for affiliate)
382      * -functionhash- 0x079ce327 (using name for affiliate)
383      * @param _affCode the ID/address/name of the player who gets the affiliate fee
384      * @param _team what team is the player playing for?
385      * @param _eth amount of earnings to use (remainder returned to gen vault)
386      */
387     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
388         isActivated()
389         isHuman()
390         isWithinLimits(_eth)
391         public
392     {
393         // set up our tx event data
394         F3Ddatasets.EventReturns memory _eventData_;
395 
396         // fetch player ID
397         uint256 _pID = pIDxAddr_[msg.sender];
398 
399         // manage affiliate residuals
400         // if no affiliate code was given or player tried to use their own, lolz
401         if (_affCode == 0 || _affCode == _pID)
402         {
403             // use last stored affiliate code
404             _affCode = plyr_[_pID].laff;
405 
406         // if affiliate code was given & its not the same as previously stored
407         } else if (_affCode != plyr_[_pID].laff) {
408             // update last affiliate
409             plyr_[_pID].laff = _affCode;
410         }
411 
412         // verify a valid team was selected
413         _team = verifyTeam(_team);
414 
415         // reload core
416         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
417     }
418 
419     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
420         isActivated()
421         isHuman()
422         isWithinLimits(_eth)
423         public
424     {
425         // set up our tx event data
426         F3Ddatasets.EventReturns memory _eventData_;
427 
428         // fetch player ID
429         uint256 _pID = pIDxAddr_[msg.sender];
430 
431         // manage affiliate residuals
432         uint256 _affID;
433         // if no affiliate code was given or player tried to use their own, lolz
434         if (_affCode == address(0) || _affCode == msg.sender)
435         {
436             // use last stored affiliate code
437             _affID = plyr_[_pID].laff;
438 
439         // if affiliate code was given
440         } else {
441             // get affiliate ID from aff Code
442             _affID = pIDxAddr_[_affCode];
443 
444             // if affID is not the same as previously stored
445             if (_affID != plyr_[_pID].laff)
446             {
447                 // update last affiliate
448                 plyr_[_pID].laff = _affID;
449             }
450         }
451 
452         // verify a valid team was selected
453         _team = verifyTeam(_team);
454 
455         // reload core
456         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
457     }
458 
459     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
460         isActivated()
461         isHuman()
462         isWithinLimits(_eth)
463         public
464     {
465         // set up our tx event data
466         F3Ddatasets.EventReturns memory _eventData_;
467 
468         // fetch player ID
469         uint256 _pID = pIDxAddr_[msg.sender];
470 
471         // manage affiliate residuals
472         uint256 _affID;
473         // if no affiliate code was given or player tried to use their own, lolz
474         if (_affCode == '' || _affCode == plyr_[_pID].name)
475         {
476             // use last stored affiliate code
477             _affID = plyr_[_pID].laff;
478 
479         // if affiliate code was given
480         } else {
481             // get affiliate ID from aff Code
482             _affID = pIDxName_[_affCode];
483 
484             // if affID is not the same as previously stored
485             if (_affID != plyr_[_pID].laff)
486             {
487                 // update last affiliate
488                 plyr_[_pID].laff = _affID;
489             }
490         }
491 
492         // verify a valid team was selected
493         _team = verifyTeam(_team);
494 
495         // reload core
496         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
497     }
498 
499     /**
500      * @dev withdraws all of your earnings.
501      * -functionhash- 0x3ccfd60b
502      */
503     function withdraw()
504         isActivated()
505         isHuman()
506         public
507     {
508         // setup local rID
509         uint256 _rID = rID_;
510 
511         // grab time
512         uint256 _now = now;
513 
514         // fetch player ID
515         uint256 _pID = pIDxAddr_[msg.sender];
516 
517         // setup temp var for player eth
518         uint256 _eth;
519 
520         // check to see if round has ended and no one has run round end yet
521         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
522         {
523             // set up our tx event data
524             F3Ddatasets.EventReturns memory _eventData_;
525 
526             // end the round (distributes pot)
527 			round_[_rID].ended = true;
528             _eventData_ = endRound(_eventData_);
529 
530 			// get their earnings
531             _eth = withdrawEarnings(_pID);
532 
533             // gib moni
534             if (_eth > 0)
535                 plyr_[_pID].addr.transfer(_eth);
536 
537             // build event data
538             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
539             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
540 
541             // fire withdraw and distribute event
542             emit F3Devents.onWithdrawAndDistribute
543             (
544                 msg.sender,
545                 plyr_[_pID].name,
546                 _eth,
547                 _eventData_.compressedData,
548                 _eventData_.compressedIDs,
549                 _eventData_.winnerAddr,
550                 _eventData_.winnerName,
551                 _eventData_.amountWon,
552                 _eventData_.newPot,
553                 _eventData_.P3DAmount,
554                 _eventData_.genAmount
555             );
556 
557         // in any other situation
558         } else {
559             // get their earnings
560             _eth = withdrawEarnings(_pID);
561 
562             // gib moni
563             if (_eth > 0)
564                 plyr_[_pID].addr.transfer(_eth);
565 
566             // fire withdraw event
567             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
568         }
569     }
570 
571     /**
572      * @dev use these to register names.  they are just wrappers that will send the
573      * registration requests to the PlayerBook contract.  So registering here is the
574      * same as registering there.  UI will always display the last name you registered.
575      * but you will still own all previously registered names to use as affiliate
576      * links.
577      * - must pay a registration fee.
578      * - name must be unique
579      * - names will be converted to lowercase
580      * - name cannot start or end with a space
581      * - cannot have more than 1 space in a row
582      * - cannot be only numbers
583      * - cannot start with 0x
584      * - name must be at least 1 char
585      * - max length of 32 characters long
586      * - allowed characters: a-z, 0-9, and space
587      * -functionhash- 0x921dec21 (using ID for affiliate)
588      * -functionhash- 0x3ddd4698 (using address for affiliate)
589      * -functionhash- 0x685ffd83 (using name for affiliate)
590      * @param _nameString players desired name
591      * @param _affCode affiliate ID, address, or name of who referred you
592      * @param _all set to true if you want this to push your info to all games
593      * (this might cost a lot of gas)
594      */
595     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
596         isHuman()
597         public
598         payable
599     {
600         bytes32 _name = _nameString.nameFilter();
601         address _addr = msg.sender;
602         uint256 _paid = msg.value;
603         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
604 
605         uint256 _pID = pIDxAddr_[_addr];
606 
607         // fire event
608         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
609     }
610 
611     function registerNameXaddr(string _nameString, address _affCode, bool _all)
612         isHuman()
613         public
614         payable
615     {
616         bytes32 _name = _nameString.nameFilter();
617         address _addr = msg.sender;
618         uint256 _paid = msg.value;
619         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
620 
621         uint256 _pID = pIDxAddr_[_addr];
622 
623         // fire event
624         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
625     }
626 
627     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
628         isHuman()
629         public
630         payable
631     {
632         bytes32 _name = _nameString.nameFilter();
633         address _addr = msg.sender;
634         uint256 _paid = msg.value;
635         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
636 
637         uint256 _pID = pIDxAddr_[_addr];
638 
639         // fire event
640         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
641     }
642 //==============================================================================
643 //     _  _ _|__|_ _  _ _  .
644 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
645 //=====_|=======================================================================
646     /**
647      * @dev return the price buyer will pay for next 1 individual key.
648      * -functionhash- 0x018a25e8
649      * @return price for next key bought (in wei format)
650      */
651     function getBuyPrice()
652         public
653         view
654         returns(uint256)
655     {
656         // setup local rID
657         uint256 _rID = rID_;
658 
659         // grab time
660         uint256 _now = now;
661 
662         // are we in a round?
663         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
664             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
665         else // rounds over.  need price for new round
666             return ( 75000000000000 ); // init
667     }
668 
669     /**
670      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
671      * provider
672      * -functionhash- 0xc7e284b8
673      * @return time left in seconds
674      */
675     function getTimeLeft()
676         public
677         view
678         returns(uint256)
679     {
680         // setup local rID
681         uint256 _rID = rID_;
682 
683         // grab time
684         uint256 _now = now;
685 
686         if (_now < round_[_rID].end)
687             if (_now > round_[_rID].strt + rndGap_)
688                 return( (round_[_rID].end).sub(_now) );
689             else
690                 return( (round_[_rID].strt + rndGap_).sub(_now) );
691         else
692             return(0);
693     }
694 
695     /**
696      * @dev returns player earnings per vaults
697      * -functionhash- 0x63066434
698      * @return winnings vault
699      * @return general vault
700      * @return affiliate vault
701      */
702     function getPlayerVaults(uint256 _pID)
703         public
704         view
705         returns(uint256 ,uint256, uint256)
706     {
707         // setup local rID
708         uint256 _rID = rID_;
709 
710         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
711         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
712         {
713             // if player is winner
714             if (round_[_rID].plyr == _pID)
715             {
716                 return
717                 (
718                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
719                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
720                     plyr_[_pID].aff
721                 );
722             // if player is not the winner
723             } else {
724                 return
725                 (
726                     plyr_[_pID].win,
727                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
728                     plyr_[_pID].aff
729                 );
730             }
731 
732         // if round is still going on, or round has ended and round end has been ran
733         } else {
734             return
735             (
736                 plyr_[_pID].win,
737                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
738                 plyr_[_pID].aff
739             );
740         }
741     }
742 
743     /**
744      * solidity hates stack limits.  this lets us avoid that hate
745      */
746     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
747         private
748         view
749         returns(uint256)
750     {
751         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
752     }
753 
754     /**
755      * @dev returns all current round info needed for front end
756      * -functionhash- 0x747dff42
757      * @return eth invested during ICO phase
758      * @return round id
759      * @return total keys for round
760      * @return time round ends
761      * @return time round started
762      * @return current pot
763      * @return current team ID & player ID in lead
764      * @return current player in leads address
765      * @return current player in leads name
766      * @return whales eth in for round
767      * @return bears eth in for round
768      * @return sneks eth in for round
769      * @return bulls eth in for round
770      * @return airdrop tracker # & airdrop pot
771      */
772     function getCurrentRoundInfo()
773         public
774         view
775         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
776     {
777         // setup local rID
778         uint256 _rID = rID_;
779 
780         return
781         (
782             round_[_rID].ico,               //0
783             _rID,                           //1
784             round_[_rID].keys,              //2
785             round_[_rID].end,               //3
786             round_[_rID].strt,              //4
787             round_[_rID].pot,               //5
788             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
789             plyr_[round_[_rID].plyr].addr,  //7
790             plyr_[round_[_rID].plyr].name,  //8
791             rndTmEth_[_rID][0],             //9
792             rndTmEth_[_rID][1],             //10
793             rndTmEth_[_rID][2],             //11
794             rndTmEth_[_rID][3],             //12
795             airDropTracker_ + (airDropPot_ * 1000)              //13
796         );
797     }
798 
799     /**
800      * @dev returns player info based on address.  if no address is given, it will
801      * use msg.sender
802      * -functionhash- 0xee0b5d8b
803      * @param _addr address of the player you want to lookup
804      * @return player ID
805      * @return player name
806      * @return keys owned (current round)
807      * @return winnings vault
808      * @return general vault
809      * @return affiliate vault
810 	 * @return player round eth
811      */
812     function getPlayerInfoByAddress(address _addr)
813         public
814         view
815         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
816     {
817         // setup local rID
818         uint256 _rID = rID_;
819 
820         if (_addr == address(0))
821         {
822             _addr == msg.sender;
823         }
824         uint256 _pID = pIDxAddr_[_addr];
825 
826         return
827         (
828             _pID,                               //0
829             plyr_[_pID].name,                   //1
830             plyrRnds_[_pID][_rID].keys,         //2
831             plyr_[_pID].win,                    //3
832             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
833             plyr_[_pID].aff,                    //5
834             plyrRnds_[_pID][_rID].eth           //6
835         );
836     }
837 
838 //==============================================================================
839 //     _ _  _ _   | _  _ . _  .
840 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
841 //=====================_|=======================================================
842     /**
843      * @dev logic runs whenever a buy order is executed.  determines how to handle
844      * incoming eth depending on if we are in an active round or not
845      */
846     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
847         private
848     {
849         // setup local rID
850         uint256 _rID = rID_;
851 
852         // grab time
853         uint256 _now = now;
854 
855         // if round is active
856         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
857         {
858             // call core
859             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
860 
861         // if round is not active
862         } else {
863             // check to see if end round needs to be ran
864             if (_now > round_[_rID].end && round_[_rID].ended == false)
865             {
866                 // end the round (distributes pot) & start new round
867 			    round_[_rID].ended = true;
868                 _eventData_ = endRound(_eventData_);
869 
870                 // build event data
871                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
872                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
873 
874                 // fire buy and distribute event
875                 emit F3Devents.onBuyAndDistribute
876                 (
877                     msg.sender,
878                     plyr_[_pID].name,
879                     msg.value,
880                     _eventData_.compressedData,
881                     _eventData_.compressedIDs,
882                     _eventData_.winnerAddr,
883                     _eventData_.winnerName,
884                     _eventData_.amountWon,
885                     _eventData_.newPot,
886                     _eventData_.P3DAmount,
887                     _eventData_.genAmount
888                 );
889             }
890 
891             // put eth in players vault
892             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
893         }
894     }
895 
896     /**
897      * @dev logic runs whenever a reload order is executed.  determines how to handle
898      * incoming eth depending on if we are in an active round or not
899      */
900     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
901         private
902     {
903         // setup local rID
904         uint256 _rID = rID_;
905 
906         // grab time
907         uint256 _now = now;
908 
909         // if round is active
910         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
911         {
912             // get earnings from all vaults and return unused to gen vault
913             // because we use a custom safemath library.  this will throw if player
914             // tried to spend more eth than they have.
915             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
916 
917             // call core
918             core(_rID, _pID, _eth, _affID, _team, _eventData_);
919 
920         // if round is not active and end round needs to be ran
921         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
922             // end the round (distributes pot) & start new round
923             round_[_rID].ended = true;
924             _eventData_ = endRound(_eventData_);
925 
926             // build event data
927             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
928             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
929 
930             // fire buy and distribute event
931             emit F3Devents.onReLoadAndDistribute
932             (
933                 msg.sender,
934                 plyr_[_pID].name,
935                 _eventData_.compressedData,
936                 _eventData_.compressedIDs,
937                 _eventData_.winnerAddr,
938                 _eventData_.winnerName,
939                 _eventData_.amountWon,
940                 _eventData_.newPot,
941                 _eventData_.P3DAmount,
942                 _eventData_.genAmount
943             );
944         }
945     }
946 
947     /**
948      * @dev this is the core logic for any buy/reload that happens while a round
949      * is live.
950      */
951     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
952         private
953     {
954         //take off 30%
955         uint256 _coin_fee = ((_eth).mul(30)) / 100;
956         coin_base.transfer(_coin_fee);
957         _eth = _eth-_coin_fee;
958 
959         // if player is new to round
960         if (plyrRnds_[_pID][_rID].keys == 0)
961             _eventData_ = managePlayer(_pID, _eventData_);
962 
963         // early round eth limiter
964         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
965         {
966             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
967             uint256 _refund = _eth.sub(_availableLimit);
968             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
969             _eth = _availableLimit;
970         }
971 
972         // if eth left is greater than min eth allowed (sorry no pocket lint)
973         if (_eth > 1000000000)
974         {
975 
976             // mint the new keys
977             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
978 
979             // if they bought at least 1 whole key
980             if (_keys >= 1000000000000000000)
981             {
982             updateTimer(_keys, _rID);
983 
984             // set new leaders
985             if (round_[_rID].plyr != _pID)
986                 round_[_rID].plyr = _pID;
987             if (round_[_rID].team != _team)
988                 round_[_rID].team = _team;
989 
990             // set the new leader bool to true
991             _eventData_.compressedData = _eventData_.compressedData + 100;
992         }
993 
994             // manage airdrops
995             if (_eth >= 100000000000000000)
996             {
997             airDropTracker_++;
998             if (airdrop() == true)
999             {
1000                 // gib muni
1001                 uint256 _prize;
1002                 if (_eth >= 10000000000000000000)
1003                 {
1004                     // calculate prize and give it to winner
1005                     _prize = ((airDropPot_).mul(75)) / 100;
1006                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1007 
1008                     // adjust airDropPot
1009                     airDropPot_ = (airDropPot_).sub(_prize);
1010 
1011                     // let event know a tier 3 prize was won
1012                     _eventData_.compressedData += 300000000000000000000000000000000;
1013                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1014                     // calculate prize and give it to winner
1015                     _prize = ((airDropPot_).mul(50)) / 100;
1016                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1017 
1018                     // adjust airDropPot
1019                     airDropPot_ = (airDropPot_).sub(_prize);
1020 
1021                     // let event know a tier 2 prize was won
1022                     _eventData_.compressedData += 200000000000000000000000000000000;
1023                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1024                     // calculate prize and give it to winner
1025                     _prize = ((airDropPot_).mul(25)) / 100;
1026                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1027 
1028                     // adjust airDropPot
1029                     airDropPot_ = (airDropPot_).sub(_prize);
1030 
1031                     // let event know a tier 3 prize was won
1032                     _eventData_.compressedData += 300000000000000000000000000000000;
1033                 }
1034                 // set airdrop happened bool to true
1035                 _eventData_.compressedData += 10000000000000000000000000000000;
1036                 // let event know how much was won
1037                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1038 
1039                 // reset air drop tracker
1040                 airDropTracker_ = 0;
1041             }
1042         }
1043 
1044             // store the air drop tracker number (number of buys since last airdrop)
1045             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1046 
1047             // update player
1048             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1049             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1050 
1051             // update round
1052             round_[_rID].keys = _keys.add(round_[_rID].keys);
1053             round_[_rID].eth = _eth.add(round_[_rID].eth);
1054             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1055 
1056             // distribute eth
1057             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1058             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1059 
1060             // call end tx function to fire end tx event.
1061 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1062         }
1063     }
1064 //==============================================================================
1065 //     _ _ | _   | _ _|_ _  _ _  .
1066 //    (_(_||(_|_||(_| | (_)| _\  .
1067 //==============================================================================
1068     /**
1069      * @dev calculates unmasked earnings (just calculates, does not update mask)
1070      * @return earnings in wei format
1071      */
1072     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1073         private
1074         view
1075         returns(uint256)
1076     {
1077         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1078     }
1079 
1080     /**
1081      * @dev returns the amount of keys you would get given an amount of eth.
1082      * -functionhash- 0xce89c80c
1083      * @param _rID round ID you want price for
1084      * @param _eth amount of eth sent in
1085      * @return keys received
1086      */
1087     function calcKeysReceived(uint256 _rID, uint256 _eth)
1088         public
1089         view
1090         returns(uint256)
1091     {
1092         // grab time
1093         uint256 _now = now;
1094 
1095         // are we in a round?
1096         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1097             return ( (round_[_rID].eth).keysRec(_eth) );
1098         else // rounds over.  need keys for new round
1099             return ( (_eth).keys() );
1100     }
1101 
1102     /**
1103      * @dev returns current eth price for X keys.
1104      * -functionhash- 0xcf808000
1105      * @param _keys number of keys desired (in 18 decimal format)
1106      * @return amount of eth needed to send
1107      */
1108     function iWantXKeys(uint256 _keys)
1109         public
1110         view
1111         returns(uint256)
1112     {
1113         // setup local rID
1114         uint256 _rID = rID_;
1115 
1116         // grab time
1117         uint256 _now = now;
1118 
1119         // are we in a round?
1120         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1121             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1122         else // rounds over.  need price for new round
1123             return ( (_keys).eth() );
1124     }
1125 //==============================================================================
1126 //    _|_ _  _ | _  .
1127 //     | (_)(_)|_\  .
1128 //==============================================================================
1129     /**
1130 	 * @dev receives name/player info from names contract
1131      */
1132     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1133         external
1134     {
1135         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1136         if (pIDxAddr_[_addr] != _pID)
1137             pIDxAddr_[_addr] = _pID;
1138         if (pIDxName_[_name] != _pID)
1139             pIDxName_[_name] = _pID;
1140         if (plyr_[_pID].addr != _addr)
1141             plyr_[_pID].addr = _addr;
1142         if (plyr_[_pID].name != _name)
1143             plyr_[_pID].name = _name;
1144         if (plyr_[_pID].laff != _laff)
1145             plyr_[_pID].laff = _laff;
1146         if (plyrNames_[_pID][_name] == false)
1147             plyrNames_[_pID][_name] = true;
1148     }
1149 
1150     /**
1151      * @dev receives entire player name list
1152      */
1153     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1154         external
1155     {
1156         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1157         if(plyrNames_[_pID][_name] == false)
1158             plyrNames_[_pID][_name] = true;
1159     }
1160 
1161     /**
1162      * @dev gets existing or registers new pID.  use this when a player may be new
1163      * @return pID
1164      */
1165     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1166         private
1167         returns (F3Ddatasets.EventReturns)
1168     {
1169         uint256 _pID = pIDxAddr_[msg.sender];
1170         // if player is new to this version of fomo3d
1171         if (_pID == 0)
1172         {
1173             // grab their player ID, name and last aff ID, from player names contract
1174             _pID = PlayerBook.getPlayerID(msg.sender);
1175             bytes32 _name = PlayerBook.getPlayerName(_pID);
1176             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1177 
1178             // set up player account
1179             pIDxAddr_[msg.sender] = _pID;
1180             plyr_[_pID].addr = msg.sender;
1181 
1182             if (_name != "")
1183             {
1184                 pIDxName_[_name] = _pID;
1185                 plyr_[_pID].name = _name;
1186                 plyrNames_[_pID][_name] = true;
1187             }
1188 
1189             if (_laff != 0 && _laff != _pID)
1190                 plyr_[_pID].laff = _laff;
1191 
1192             // set the new player bool to true
1193             _eventData_.compressedData = _eventData_.compressedData + 1;
1194         }
1195         return (_eventData_);
1196     }
1197 
1198     /**
1199      * @dev checks to make sure user picked a valid team.  if not sets team
1200      * to default (sneks)
1201      */
1202     function verifyTeam(uint256 _team)
1203         private
1204         pure
1205         returns (uint256)
1206     {
1207         if (_team < 0 || _team > 3)
1208             return(2);
1209         else
1210             return(_team);
1211     }
1212 
1213     /**
1214      * @dev decides if round end needs to be run & new round started.  and if
1215      * player unmasked earnings from previously played rounds need to be moved.
1216      */
1217     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1218         private
1219         returns (F3Ddatasets.EventReturns)
1220     {
1221         // if player has played a previous round, move their unmasked earnings
1222         // from that round to gen vault.
1223         if (plyr_[_pID].lrnd != 0)
1224             updateGenVault(_pID, plyr_[_pID].lrnd);
1225 
1226         // update player's last round played
1227         plyr_[_pID].lrnd = rID_;
1228 
1229         // set the joined round bool to true
1230         _eventData_.compressedData = _eventData_.compressedData + 10;
1231 
1232         return(_eventData_);
1233     }
1234 
1235     /**
1236      * @dev ends the round. manages paying out winner/splitting up pot
1237      */
1238     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1239         private
1240         returns (F3Ddatasets.EventReturns)
1241     {
1242         // setup local rID
1243         uint256 _rID = rID_;
1244 
1245         // grab our winning player and team id's
1246         uint256 _winPID = round_[_rID].plyr;
1247         uint256 _winTID = round_[_rID].team;
1248 
1249         // grab our pot amount
1250         uint256 _pot = round_[_rID].pot;
1251 
1252         // calculate our winner share, community rewards, gen share,
1253         // p3d share, and amount reserved for next pot
1254         uint256 _win = (_pot.mul(48)) / 100;
1255         uint256 _com = (_pot / 50);
1256         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1257         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1258         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1259 
1260         // calculate ppt for round mask
1261         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1262         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1263         if (_dust > 0)
1264         {
1265             _gen = _gen.sub(_dust);
1266             _res = _res.add(_dust);
1267         }
1268 
1269         // pay our winner
1270         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1271 
1272         // community rewards
1273         _com = _com.add(_p3d.sub(_p3d / 2));
1274         coin_base.transfer(_com);
1275 
1276         _res = _res.add(_p3d / 2);
1277 
1278         // distribute gen portion to key holders
1279         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1280 
1281         // prepare event data
1282         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1283         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1284         _eventData_.winnerAddr = plyr_[_winPID].addr;
1285         _eventData_.winnerName = plyr_[_winPID].name;
1286         _eventData_.amountWon = _win;
1287         _eventData_.genAmount = _gen;
1288         _eventData_.P3DAmount = _p3d;
1289         _eventData_.newPot = _res;
1290 
1291         // start next round
1292         rID_++;
1293         _rID++;
1294         round_[_rID].strt = now;
1295         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1296         round_[_rID].pot = _res;
1297 
1298         return(_eventData_);
1299     }
1300 
1301     /**
1302      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1303      */
1304     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1305         private
1306     {
1307         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1308         if (_earnings > 0)
1309         {
1310             // put in gen vault
1311             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1312             // zero out their earnings by updating mask
1313             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1314         }
1315     }
1316 
1317     /**
1318      * @dev updates round timer based on number of whole keys bought.
1319      */
1320     function updateTimer(uint256 _keys, uint256 _rID)
1321         private
1322     {
1323         // grab time
1324         uint256 _now = now;
1325 
1326         // calculate time based on number of keys bought
1327         uint256 _newTime;
1328         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1329             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1330         else
1331             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1332 
1333         // compare to max and set new end time
1334         if (_newTime < (rndMax_).add(_now))
1335             round_[_rID].end = _newTime;
1336         else
1337             round_[_rID].end = rndMax_.add(_now);
1338     }
1339 
1340     /**
1341      * @dev generates a random number between 0-99 and checks to see if thats
1342      * resulted in an airdrop win
1343      * @return do we have a winner?
1344      */
1345     function airdrop()
1346         private
1347         view
1348         returns(bool)
1349     {
1350         uint256 seed = uint256(keccak256(abi.encodePacked(
1351 
1352             (block.timestamp).add
1353             (block.difficulty).add
1354             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1355             (block.gaslimit).add
1356             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1357             (block.number)
1358 
1359         )));
1360         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1361             return(true);
1362         else
1363             return(false);
1364     }
1365 
1366     /**
1367      * @dev distributes eth based on fees to com, aff, and p3d
1368      */
1369     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1370         private
1371         returns(F3Ddatasets.EventReturns)
1372     {
1373         // pay 3% out to community rewards
1374         uint256 _p1 = _eth / 100;
1375         uint256 _com = _eth / 50;
1376         _com = _com.add(_p1);
1377 
1378         uint256 _p3d;
1379         if (!address(coin_base).call.value(_com)())
1380         {
1381             // This ensures Team Just cannot influence the outcome of FoMo3D with
1382             // bank migrations by breaking outgoing transactions.
1383             // Something we would never do. But that's not the point.
1384             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1385             // highest belief that everything we create should be trustless.
1386             // Team JUST, The name you shouldn't have to trust.
1387             _p3d = _com;
1388             _com = 0;
1389         }
1390 
1391 
1392         // distribute share to affiliate
1393         uint256 _aff = _eth / 10;
1394 
1395         // decide what to do with affiliate share of fees
1396         // affiliate must not be self, and must have a name registered
1397         if (_affID != _pID && plyr_[_affID].name != '') {
1398             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1399             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1400         } else {
1401             _p3d = _p3d.add(_aff);
1402         }
1403 
1404         // pay out p3d
1405         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1406         if (_p3d > 0)
1407         {
1408             // deposit to divies contract
1409             uint256 _potAmount = _p3d / 2;
1410 
1411             coin_base.transfer(_p3d.sub(_potAmount));
1412 
1413             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1414 
1415             // set up event data
1416             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1417         }
1418 
1419         return(_eventData_);
1420     }
1421 
1422     function potSwap()
1423         external
1424         payable
1425     {
1426         // setup local rID
1427         uint256 _rID = rID_ + 1;
1428 
1429         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1430         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1431     }
1432 
1433     /**
1434      * @dev distributes eth based on fees to gen and pot
1435      */
1436     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1437         private
1438         returns(F3Ddatasets.EventReturns)
1439     {
1440         // calculate gen share
1441         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1442 
1443         // toss 1% into airdrop pot
1444         uint256 _air = (_eth / 100);
1445         airDropPot_ = airDropPot_.add(_air);
1446 
1447         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1448         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1449 
1450         // calculate pot
1451         uint256 _pot = _eth.sub(_gen);
1452 
1453         // distribute gen share (thats what updateMasks() does) and adjust
1454         // balances for dust.
1455         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1456         if (_dust > 0)
1457             _gen = _gen.sub(_dust);
1458 
1459         // add eth to pot
1460         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1461 
1462         // set up event data
1463         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1464         _eventData_.potAmount = _pot;
1465 
1466         return(_eventData_);
1467     }
1468 
1469     /**
1470      * @dev updates masks for round and player when keys are bought
1471      * @return dust left over
1472      */
1473     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1474         private
1475         returns(uint256)
1476     {
1477         /* MASKING NOTES
1478             earnings masks are a tricky thing for people to wrap their minds around.
1479             the basic thing to understand here.  is were going to have a global
1480             tracker based on profit per share for each round, that increases in
1481             relevant proportion to the increase in share supply.
1482 
1483             the player will have an additional mask that basically says "based
1484             on the rounds mask, my shares, and how much i've already withdrawn,
1485             how much is still owed to me?"
1486         */
1487 
1488         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1489         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1490         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1491 
1492         // calculate player earning from their own buy (only based on the keys
1493         // they just bought).  & update player earnings mask
1494         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1495         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1496 
1497         // calculate & return dust
1498         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1499     }
1500 
1501     /**
1502      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1503      * @return earnings in wei format
1504      */
1505     function withdrawEarnings(uint256 _pID)
1506         private
1507         returns(uint256)
1508     {
1509         // update gen vault
1510         updateGenVault(_pID, plyr_[_pID].lrnd);
1511 
1512         // from vaults
1513         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1514         if (_earnings > 0)
1515         {
1516             plyr_[_pID].win = 0;
1517             plyr_[_pID].gen = 0;
1518             plyr_[_pID].aff = 0;
1519         }
1520 
1521         return(_earnings);
1522     }
1523 
1524     /**
1525      * @dev prepares compression data and fires event for buy or reload tx's
1526      */
1527     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1528         private
1529     {
1530         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1531         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1532 
1533         emit F3Devents.onEndTx
1534         (
1535             _eventData_.compressedData,
1536             _eventData_.compressedIDs,
1537             plyr_[_pID].name,
1538             msg.sender,
1539             _eth,
1540             _keys,
1541             _eventData_.winnerAddr,
1542             _eventData_.winnerName,
1543             _eventData_.amountWon,
1544             _eventData_.newPot,
1545             _eventData_.P3DAmount,
1546             _eventData_.genAmount,
1547             _eventData_.potAmount,
1548             airDropPot_
1549         );
1550     }
1551 //==============================================================================
1552 //    (~ _  _    _._|_    .
1553 //    _)(/_(_|_|| | | \/  .
1554 //====================/=========================================================
1555     /** upon contract deploy, it will be deactivated.  this is a one time
1556      * use function that will activate the contract.  we do this so devs
1557      * have time to set things up on the web end                            **/
1558     bool public activated_ = false;
1559     function activate()
1560         public
1561     {
1562         // only team just can activate
1563         require(msg.sender == admin, "only admin can activate");
1564 
1565 
1566         // can only be ran once
1567         require(activated_ == false, "FOMO Short already activated");
1568 
1569         // activate the contract
1570         activated_ = true;
1571 
1572         // lets start first round
1573         rID_ = 1;
1574             round_[1].strt = now + rndExtra_ - rndGap_;
1575             round_[1].end = now + rndInit_ + rndExtra_;
1576     }
1577 }
1578 
1579 //==============================================================================
1580 //   __|_ _    __|_ _  .
1581 //  _\ | | |_|(_ | _\  .
1582 //==============================================================================
1583 library F3Ddatasets {
1584     //compressedData key
1585     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1586         // 0 - new player (bool)
1587         // 1 - joined round (bool)
1588         // 2 - new  leader (bool)
1589         // 3-5 - air drop tracker (uint 0-999)
1590         // 6-16 - round end time
1591         // 17 - winnerTeam
1592         // 18 - 28 timestamp
1593         // 29 - team
1594         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1595         // 31 - airdrop happened bool
1596         // 32 - airdrop tier
1597         // 33 - airdrop amount won
1598     //compressedIDs key
1599     // [77-52][51-26][25-0]
1600         // 0-25 - pID
1601         // 26-51 - winPID
1602         // 52-77 - rID
1603     struct EventReturns {
1604         uint256 compressedData;
1605         uint256 compressedIDs;
1606         address winnerAddr;         // winner address
1607         bytes32 winnerName;         // winner name
1608         uint256 amountWon;          // amount won
1609         uint256 newPot;             // amount in new pot
1610         uint256 P3DAmount;          // amount distributed to p3d
1611         uint256 genAmount;          // amount distributed to gen
1612         uint256 potAmount;          // amount added to pot
1613     }
1614     struct Player {
1615         address addr;   // player address
1616         bytes32 name;   // player name
1617         uint256 win;    // winnings vault
1618         uint256 gen;    // general vault
1619         uint256 aff;    // affiliate vault
1620         uint256 lrnd;   // last round played
1621         uint256 laff;   // last affiliate id used
1622     }
1623     struct PlayerRounds {
1624         uint256 eth;    // eth player has added to round (used for eth limiter)
1625         uint256 keys;   // keys
1626         uint256 mask;   // player mask
1627         uint256 ico;    // ICO phase investment
1628     }
1629     struct Round {
1630         uint256 plyr;   // pID of player in lead
1631         uint256 team;   // tID of team in lead
1632         uint256 end;    // time ends/ended
1633         bool ended;     // has round end function been ran
1634         uint256 strt;   // time round started
1635         uint256 keys;   // keys
1636         uint256 eth;    // total eth in
1637         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1638         uint256 mask;   // global mask
1639         uint256 ico;    // total eth sent in during ICO phase
1640         uint256 icoGen; // total eth for gen during ICO phase
1641         uint256 icoAvg; // average key price for ICO phase
1642     }
1643     struct TeamFee {
1644         uint256 gen;    // % of buy in thats paid to key holders of current round
1645         uint256 p3d;    // % of buy in thats paid to p3d holders
1646     }
1647     struct PotSplit {
1648         uint256 gen;    // % of pot thats paid to key holders of current round
1649         uint256 p3d;    // % of pot thats paid to p3d holders
1650     }
1651 }
1652 
1653 //==============================================================================
1654 //  |  _      _ _ | _  .
1655 //  |<(/_\/  (_(_||(_  .
1656 //=======/======================================================================
1657 library F3DKeysCalcShort {
1658     using SafeMath for *;
1659     /**
1660      * @dev calculates number of keys received given X eth
1661      * @param _curEth current amount of eth in contract
1662      * @param _newEth eth being spent
1663      * @return amount of ticket purchased
1664      */
1665     function keysRec(uint256 _curEth, uint256 _newEth)
1666         internal
1667         pure
1668         returns (uint256)
1669     {
1670         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1671     }
1672 
1673     /**
1674      * @dev calculates amount of eth received if you sold X keys
1675      * @param _curKeys current amount of keys that exist
1676      * @param _sellKeys amount of keys you wish to sell
1677      * @return amount of eth received
1678      */
1679     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1680         internal
1681         pure
1682         returns (uint256)
1683     {
1684         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1685     }
1686 
1687     /**
1688      * @dev calculates how many keys would exist with given an amount of eth
1689      * @param _eth eth "in contract"
1690      * @return number of keys that would exist
1691      */
1692     function keys(uint256 _eth)
1693         internal
1694         pure
1695         returns(uint256)
1696     {
1697         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1698     }
1699 
1700     /**
1701      * @dev calculates how much eth would be in contract given a number of keys
1702      * @param _keys number of keys "in contract"
1703      * @return eth that would exists
1704      */
1705     function eth(uint256 _keys)
1706         internal
1707         pure
1708         returns(uint256)
1709     {
1710         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1711     }
1712 }
1713 
1714 //==============================================================================
1715 //  . _ _|_ _  _ |` _  _ _  _  .
1716 //  || | | (/_| ~|~(_|(_(/__\  .
1717 //==============================================================================
1718 
1719 interface PlayerBookInterface {
1720     function getPlayerID(address _addr) external returns (uint256);
1721     function getPlayerName(uint256 _pID) external view returns (bytes32);
1722     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1723     function getPlayerAddr(uint256 _pID) external view returns (address);
1724     function getNameFee() external view returns (uint256);
1725     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1726     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1727     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1728 }
1729 
1730 /**
1731 * @title -Name Filter- v0.1.9
1732 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1733 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1734 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1735 *                                  _____                      _____
1736 *                                 (, /     /)       /) /)    (, /      /)          /)
1737 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1738 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1739 *          ┴ ┴                /   /          .-/ _____   (__ /
1740 *                            (__ /          (_/ (, /                                      /)™
1741 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1742 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1743 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1744 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1745 *              _       __    _      ____      ____  _   _    _____  ____  ___
1746 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1747 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1748 *
1749 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1750 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1751 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1752 */
1753 
1754 library NameFilter {
1755     /**
1756      * @dev filters name strings
1757      * -converts uppercase to lower case.
1758      * -makes sure it does not start/end with a space
1759      * -makes sure it does not contain multiple spaces in a row
1760      * -cannot be only numbers
1761      * -cannot start with 0x
1762      * -restricts characters to A-Z, a-z, 0-9, and space.
1763      * @return reprocessed string in bytes32 format
1764      */
1765     function nameFilter(string _input)
1766         internal
1767         pure
1768         returns(bytes32)
1769     {
1770         bytes memory _temp = bytes(_input);
1771         uint256 _length = _temp.length;
1772 
1773         //sorry limited to 32 characters
1774         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1775         // make sure it doesnt start with or end with space
1776         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1777         // make sure first two characters are not 0x
1778         if (_temp[0] == 0x30)
1779         {
1780             require(_temp[1] != 0x78, "string cannot start with 0x");
1781             require(_temp[1] != 0x58, "string cannot start with 0X");
1782         }
1783 
1784         // create a bool to track if we have a non number character
1785         bool _hasNonNumber;
1786 
1787         // convert & check
1788         for (uint256 i = 0; i < _length; i++)
1789         {
1790             // if its uppercase A-Z
1791             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1792             {
1793                 // convert to lower case a-z
1794                 _temp[i] = byte(uint(_temp[i]) + 32);
1795 
1796                 // we have a non number
1797                 if (_hasNonNumber == false)
1798                     _hasNonNumber = true;
1799             } else {
1800                 require
1801                 (
1802                     // require character is a space
1803                     _temp[i] == 0x20 ||
1804                     // OR lowercase a-z
1805                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1806                     // or 0-9
1807                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1808                     "string contains invalid characters"
1809                 );
1810                 // make sure theres not 2x spaces in a row
1811                 if (_temp[i] == 0x20)
1812                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1813 
1814                 // see if we have a character other than a number
1815                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1816                     _hasNonNumber = true;
1817             }
1818         }
1819 
1820         require(_hasNonNumber == true, "string cannot be only numbers");
1821 
1822         bytes32 _ret;
1823         assembly {
1824             _ret := mload(add(_temp, 32))
1825         }
1826         return (_ret);
1827     }
1828 }
1829 
1830 /**
1831  * @title SafeMath v0.1.9
1832  * @dev Math operations with safety checks that throw on error
1833  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1834  * - added sqrt
1835  * - added sq
1836  * - added pwr
1837  * - changed asserts to requires with error log outputs
1838  * - removed div, its useless
1839  */
1840 library SafeMath {
1841 
1842     /**
1843     * @dev Multiplies two numbers, throws on overflow.
1844     */
1845     function mul(uint256 a, uint256 b)
1846         internal
1847         pure
1848         returns (uint256 c)
1849     {
1850         if (a == 0) {
1851             return 0;
1852         }
1853         c = a * b;
1854         require(c / a == b, "SafeMath mul failed");
1855         return c;
1856     }
1857 
1858     /**
1859     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1860     */
1861     function sub(uint256 a, uint256 b)
1862         internal
1863         pure
1864         returns (uint256)
1865     {
1866         require(b <= a, "SafeMath sub failed");
1867         return a - b;
1868     }
1869 
1870     /**
1871     * @dev Adds two numbers, throws on overflow.
1872     */
1873     function add(uint256 a, uint256 b)
1874         internal
1875         pure
1876         returns (uint256 c)
1877     {
1878         c = a + b;
1879         require(c >= a, "SafeMath add failed");
1880         return c;
1881     }
1882 
1883     /**
1884      * @dev gives square root of given x.
1885      */
1886     function sqrt(uint256 x)
1887         internal
1888         pure
1889         returns (uint256 y)
1890     {
1891         uint256 z = ((add(x,1)) / 2);
1892         y = x;
1893         while (z < y)
1894         {
1895             y = z;
1896             z = ((add((x / z),z)) / 2);
1897         }
1898     }
1899 
1900     /**
1901      * @dev gives square. multiplies x by x
1902      */
1903     function sq(uint256 x)
1904         internal
1905         pure
1906         returns (uint256)
1907     {
1908         return (mul(x,x));
1909     }
1910 
1911     /**
1912      * @dev x to the power of y
1913      */
1914     function pwr(uint256 x, uint256 y)
1915         internal
1916         pure
1917         returns (uint256)
1918     {
1919         if (x==0)
1920             return (0);
1921         else if (y==0)
1922             return (1);
1923         else
1924         {
1925             uint256 z = x;
1926             for (uint256 i=1; i < y; i++)
1927                 z = mul(z,x);
1928             return (z);
1929         }
1930     }
1931 }