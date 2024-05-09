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
123 contract F3DPLUS is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcShort for uint256;
127 
128     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x0433c529Bb7FA84f18dfe49F0234c6815bD441FA);
129 
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     address private admin = msg.sender;
135     string constant public name = "f3dplus";
136     string constant public symbol = "f3dplus";
137     uint256 private rndExtra_ = 0;     // length of the very first ICO
138     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
139     uint256 constant private rndInit_ = 3 hours;                // round timer starts at this
140     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
141     uint256 constant private rndMax_ = 3 hours;                // max length a round timer can be
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
183         fees_[0] = F3Ddatasets.TeamFee(30,0);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
184         fees_[1] = F3Ddatasets.TeamFee(31,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
185         fees_[2] = F3Ddatasets.TeamFee(50,0);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
186         fees_[3] = F3Ddatasets.TeamFee(36,0);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
187 
188         // how to split up the final pot based on which team was picked
189         // (F3D, P3D)
190         potSplit_[0] = F3Ddatasets.PotSplit(52,0);  //48% to winner, 25% to next round, 2% to com
191         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
192         potSplit_[2] = F3Ddatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com
193         potSplit_[3] = F3Ddatasets.PotSplit(34,0);  //48% to winner, 10% to next round, 2% to com
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
244         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
245 
246         // fetch player id
247         uint256 _pID = pIDxAddr_[msg.sender];
248 
249         // buy core
250         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
251     }
252 
253     /**
254      * @dev converts all incoming ethereum to keys.
255      * -functionhash- 0x8f38f309 (using ID for affiliate)
256      * -functionhash- 0x98a0871d (using address for affiliate)
257      * -functionhash- 0xa65b37a1 (using name for affiliate)
258      * @param _affCode the ID/address/name of the player who gets the affiliate fee
259      * @param _team what team is the player playing for?
260      */
261     function buyXid(uint256 _affCode, uint256 _team)
262         isActivated()
263         isHuman()
264         isWithinLimits(msg.value)
265         public
266         payable
267     {
268         // set up our tx event data and determine if player is new or not
269         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
270 
271         // fetch player id
272         uint256 _pID = pIDxAddr_[msg.sender];
273 
274         // manage affiliate residuals
275         // if no affiliate code was given or player tried to use their own, lolz
276         if (_affCode == 0 || _affCode == _pID)
277         {
278             // use last stored affiliate code
279             _affCode = plyr_[_pID].laff;
280 
281         // if affiliate code was given & its not the same as previously stored
282         } else if (_affCode != plyr_[_pID].laff) {
283             // update last affiliate
284             plyr_[_pID].laff = _affCode;
285         }
286 
287         // verify a valid team was selected
288         _team = verifyTeam(_team);
289 
290         // buy core
291         buyCore(_pID, _affCode, _team, _eventData_);
292     }
293 
294     function buyXaddr(address _affCode, uint256 _team)
295         isActivated()
296         isHuman()
297         isWithinLimits(msg.value)
298         public
299         payable
300     {
301         // set up our tx event data and determine if player is new or not
302         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
303 
304         // fetch player id
305         uint256 _pID = pIDxAddr_[msg.sender];
306 
307         // manage affiliate residuals
308         uint256 _affID;
309         // if no affiliate code was given or player tried to use their own, lolz
310         if (_affCode == address(0) || _affCode == msg.sender)
311         {
312             // use last stored affiliate code
313             _affID = plyr_[_pID].laff;
314 
315         // if affiliate code was given
316         } else {
317             // get affiliate ID from aff Code
318             _affID = pIDxAddr_[_affCode];
319 
320             // if affID is not the same as previously stored
321             if (_affID != plyr_[_pID].laff)
322             {
323                 // update last affiliate
324                 plyr_[_pID].laff = _affID;
325             }
326         }
327 
328         // verify a valid team was selected
329         _team = verifyTeam(_team);
330 
331         // buy core
332         buyCore(_pID, _affID, _team, _eventData_);
333     }
334 
335     function buyXname(bytes32 _affCode, uint256 _team)
336         isActivated()
337         isHuman()
338         isWithinLimits(msg.value)
339         public
340         payable
341     {
342         // set up our tx event data and determine if player is new or not
343         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
344 
345         // fetch player id
346         uint256 _pID = pIDxAddr_[msg.sender];
347 
348         // manage affiliate residuals
349         uint256 _affID;
350         // if no affiliate code was given or player tried to use their own, lolz
351         if (_affCode == '' || _affCode == plyr_[_pID].name)
352         {
353             // use last stored affiliate code
354             _affID = plyr_[_pID].laff;
355 
356         // if affiliate code was given
357         } else {
358             // get affiliate ID from aff Code
359             _affID = pIDxName_[_affCode];
360 
361             // if affID is not the same as previously stored
362             if (_affID != plyr_[_pID].laff)
363             {
364                 // update last affiliate
365                 plyr_[_pID].laff = _affID;
366             }
367         }
368 
369         // verify a valid team was selected
370         _team = verifyTeam(_team);
371 
372         // buy core
373         buyCore(_pID, _affID, _team, _eventData_);
374     }
375 
376     /**
377      * @dev essentially the same as buy, but instead of you sending ether
378      * from your wallet, it uses your unwithdrawn earnings.
379      * -functionhash- 0x349cdcac (using ID for affiliate)
380      * -functionhash- 0x82bfc739 (using address for affiliate)
381      * -functionhash- 0x079ce327 (using name for affiliate)
382      * @param _affCode the ID/address/name of the player who gets the affiliate fee
383      * @param _team what team is the player playing for?
384      * @param _eth amount of earnings to use (remainder returned to gen vault)
385      */
386     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
387         isActivated()
388         isHuman()
389         isWithinLimits(_eth)
390         public
391     {
392         // set up our tx event data
393         F3Ddatasets.EventReturns memory _eventData_;
394 
395         // fetch player ID
396         uint256 _pID = pIDxAddr_[msg.sender];
397 
398         // manage affiliate residuals
399         // if no affiliate code was given or player tried to use their own, lolz
400         if (_affCode == 0 || _affCode == _pID)
401         {
402             // use last stored affiliate code
403             _affCode = plyr_[_pID].laff;
404 
405         // if affiliate code was given & its not the same as previously stored
406         } else if (_affCode != plyr_[_pID].laff) {
407             // update last affiliate
408             plyr_[_pID].laff = _affCode;
409         }
410 
411         // verify a valid team was selected
412         _team = verifyTeam(_team);
413 
414         // reload core
415         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
416     }
417 
418     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
419         isActivated()
420         isHuman()
421         isWithinLimits(_eth)
422         public
423     {
424         // set up our tx event data
425         F3Ddatasets.EventReturns memory _eventData_;
426 
427         // fetch player ID
428         uint256 _pID = pIDxAddr_[msg.sender];
429 
430         // manage affiliate residuals
431         uint256 _affID;
432         // if no affiliate code was given or player tried to use their own, lolz
433         if (_affCode == address(0) || _affCode == msg.sender)
434         {
435             // use last stored affiliate code
436             _affID = plyr_[_pID].laff;
437 
438         // if affiliate code was given
439         } else {
440             // get affiliate ID from aff Code
441             _affID = pIDxAddr_[_affCode];
442 
443             // if affID is not the same as previously stored
444             if (_affID != plyr_[_pID].laff)
445             {
446                 // update last affiliate
447                 plyr_[_pID].laff = _affID;
448             }
449         }
450 
451         // verify a valid team was selected
452         _team = verifyTeam(_team);
453 
454         // reload core
455         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
456     }
457 
458     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
459         isActivated()
460         isHuman()
461         isWithinLimits(_eth)
462         public
463     {
464         // set up our tx event data
465         F3Ddatasets.EventReturns memory _eventData_;
466 
467         // fetch player ID
468         uint256 _pID = pIDxAddr_[msg.sender];
469 
470         // manage affiliate residuals
471         uint256 _affID;
472         // if no affiliate code was given or player tried to use their own, lolz
473         if (_affCode == '' || _affCode == plyr_[_pID].name)
474         {
475             // use last stored affiliate code
476             _affID = plyr_[_pID].laff;
477 
478         // if affiliate code was given
479         } else {
480             // get affiliate ID from aff Code
481             _affID = pIDxName_[_affCode];
482 
483             // if affID is not the same as previously stored
484             if (_affID != plyr_[_pID].laff)
485             {
486                 // update last affiliate
487                 plyr_[_pID].laff = _affID;
488             }
489         }
490 
491         // verify a valid team was selected
492         _team = verifyTeam(_team);
493 
494         // reload core
495         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
496     }
497 
498     /**
499      * @dev withdraws all of your earnings.
500      * -functionhash- 0x3ccfd60b
501      */
502     function withdraw()
503         isActivated()
504         isHuman()
505         public
506     {
507         // setup local rID
508         uint256 _rID = rID_;
509 
510         // grab time
511         uint256 _now = now;
512 
513         // fetch player ID
514         uint256 _pID = pIDxAddr_[msg.sender];
515 
516         // setup temp var for player eth
517         uint256 _eth;
518 
519         // check to see if round has ended and no one has run round end yet
520         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
521         {
522             // set up our tx event data
523             F3Ddatasets.EventReturns memory _eventData_;
524 
525             // end the round (distributes pot)
526 			round_[_rID].ended = true;
527             _eventData_ = endRound(_eventData_);
528 
529 			// get their earnings
530             _eth = withdrawEarnings(_pID);
531 
532             // gib moni
533             if (_eth > 0)
534                 plyr_[_pID].addr.transfer(_eth);
535 
536             // build event data
537             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
538             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
539 
540             // fire withdraw and distribute event
541             emit F3Devents.onWithdrawAndDistribute
542             (
543                 msg.sender,
544                 plyr_[_pID].name,
545                 _eth,
546                 _eventData_.compressedData,
547                 _eventData_.compressedIDs,
548                 _eventData_.winnerAddr,
549                 _eventData_.winnerName,
550                 _eventData_.amountWon,
551                 _eventData_.newPot,
552                 _eventData_.P3DAmount,
553                 _eventData_.genAmount
554             );
555 
556         // in any other situation
557         } else {
558             // get their earnings
559             _eth = withdrawEarnings(_pID);
560 
561             // gib moni
562             if (_eth > 0)
563                 plyr_[_pID].addr.transfer(_eth);
564 
565             // fire withdraw event
566             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
567         }
568     }
569 
570     /**
571      * @dev use these to register names.  they are just wrappers that will send the
572      * registration requests to the PlayerBook contract.  So registering here is the
573      * same as registering there.  UI will always display the last name you registered.
574      * but you will still own all previously registered names to use as affiliate
575      * links.
576      * - must pay a registration fee.
577      * - name must be unique
578      * - names will be converted to lowercase
579      * - name cannot start or end with a space
580      * - cannot have more than 1 space in a row
581      * - cannot be only numbers
582      * - cannot start with 0x
583      * - name must be at least 1 char
584      * - max length of 32 characters long
585      * - allowed characters: a-z, 0-9, and space
586      * -functionhash- 0x921dec21 (using ID for affiliate)
587      * -functionhash- 0x3ddd4698 (using address for affiliate)
588      * -functionhash- 0x685ffd83 (using name for affiliate)
589      * @param _nameString players desired name
590      * @param _affCode affiliate ID, address, or name of who referred you
591      * @param _all set to true if you want this to push your info to all games
592      * (this might cost a lot of gas)
593      */
594     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
595         isHuman()
596         public
597         payable
598     {
599         bytes32 _name = _nameString.nameFilter();
600         address _addr = msg.sender;
601         uint256 _paid = msg.value;
602         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
603 
604         uint256 _pID = pIDxAddr_[_addr];
605 
606         // fire event
607         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
608     }
609 
610     function registerNameXaddr(string _nameString, address _affCode, bool _all)
611         isHuman()
612         public
613         payable
614     {
615         bytes32 _name = _nameString.nameFilter();
616         address _addr = msg.sender;
617         uint256 _paid = msg.value;
618         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
619 
620         uint256 _pID = pIDxAddr_[_addr];
621 
622         // fire event
623         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
624     }
625 
626     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
627         isHuman()
628         public
629         payable
630     {
631         bytes32 _name = _nameString.nameFilter();
632         address _addr = msg.sender;
633         uint256 _paid = msg.value;
634         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
635 
636         uint256 _pID = pIDxAddr_[_addr];
637 
638         // fire event
639         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
640     }
641 //==============================================================================
642 //     _  _ _|__|_ _  _ _  .
643 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
644 //=====_|=======================================================================
645     /**
646      * @dev return the price buyer will pay for next 1 individual key.
647      * -functionhash- 0x018a25e8
648      * @return price for next key bought (in wei format)
649      */
650     function getBuyPrice()
651         public
652         view
653         returns(uint256)
654     {
655         // setup local rID
656         uint256 _rID = rID_;
657 
658         // grab time
659         uint256 _now = now;
660 
661         // are we in a round?
662         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
663             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
664         else // rounds over.  need price for new round
665             return ( 67000000000000 ); // init
666     }
667 
668     /**
669      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
670      * provider
671      * -functionhash- 0xc7e284b8
672      * @return time left in seconds
673      */
674     function getTimeLeft()
675         public
676         view
677         returns(uint256)
678     {
679         // setup local rID
680         uint256 _rID = rID_;
681 
682         // grab time
683         uint256 _now = now;
684 
685         if (_now < round_[_rID].end)
686             if (_now > round_[_rID].strt + rndGap_)
687                 return( (round_[_rID].end).sub(_now) );
688             else
689                 return( (round_[_rID].strt + rndGap_).sub(_now) );
690         else
691             return(0);
692     }
693 
694     /**
695      * @dev returns player earnings per vaults
696      * -functionhash- 0x63066434
697      * @return winnings vault
698      * @return general vault
699      * @return affiliate vault
700      */
701     function getPlayerVaults(uint256 _pID)
702         public
703         view
704         returns(uint256 ,uint256, uint256)
705     {
706         // setup local rID
707         uint256 _rID = rID_;
708 
709         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
710         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
711         {
712             // if player is winner
713             if (round_[_rID].plyr == _pID)
714             {
715                 return
716                 (
717                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
718                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
719                     plyr_[_pID].aff
720                 );
721             // if player is not the winner
722             } else {
723                 return
724                 (
725                     plyr_[_pID].win,
726                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
727                     plyr_[_pID].aff
728                 );
729             }
730 
731         // if round is still going on, or round has ended and round end has been ran
732         } else {
733             return
734             (
735                 plyr_[_pID].win,
736                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
737                 plyr_[_pID].aff
738             );
739         }
740     }
741 
742     /**
743      * solidity hates stack limits.  this lets us avoid that hate
744      */
745     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
746         private
747         view
748         returns(uint256)
749     {
750         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
751     }
752 
753     /**
754      * @dev returns all current round info needed for front end
755      * -functionhash- 0x747dff42
756      * @return eth invested during ICO phase
757      * @return round id
758      * @return total keys for round
759      * @return time round ends
760      * @return time round started
761      * @return current pot
762      * @return current team ID & player ID in lead
763      * @return current player in leads address
764      * @return current player in leads name
765      * @return whales eth in for round
766      * @return bears eth in for round
767      * @return sneks eth in for round
768      * @return bulls eth in for round
769      * @return airdrop tracker # & airdrop pot
770      */
771     function getCurrentRoundInfo()
772         public
773         view
774         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
775     {
776         // setup local rID
777         uint256 _rID = rID_;
778 
779         return
780         (
781             round_[_rID].ico,               //0
782             _rID,                           //1
783             round_[_rID].keys,              //2
784             round_[_rID].end,               //3
785             round_[_rID].strt,              //4
786             round_[_rID].pot,               //5
787             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
788             plyr_[round_[_rID].plyr].addr,  //7
789             plyr_[round_[_rID].plyr].name,  //8
790             rndTmEth_[_rID][0],             //9
791             rndTmEth_[_rID][1],             //10
792             rndTmEth_[_rID][2],             //11
793             rndTmEth_[_rID][3],             //12
794             airDropTracker_ + (airDropPot_ * 1000)              //13
795         );
796     }
797 
798     /**
799      * @dev returns player info based on address.  if no address is given, it will
800      * use msg.sender
801      * -functionhash- 0xee0b5d8b
802      * @param _addr address of the player you want to lookup
803      * @return player ID
804      * @return player name
805      * @return keys owned (current round)
806      * @return winnings vault
807      * @return general vault
808      * @return affiliate vault
809 	 * @return player round eth
810      */
811     function getPlayerInfoByAddress(address _addr)
812         public
813         view
814         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
815     {
816         // setup local rID
817         uint256 _rID = rID_;
818 
819         if (_addr == address(0))
820         {
821             _addr == msg.sender;
822         }
823         uint256 _pID = pIDxAddr_[_addr];
824 
825         return
826         (
827             _pID,                               //0
828             plyr_[_pID].name,                   //1
829             plyrRnds_[_pID][_rID].keys,         //2
830             plyr_[_pID].win,                    //3
831             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
832             plyr_[_pID].aff,                    //5
833             plyrRnds_[_pID][_rID].eth           //6
834         );
835     }
836 
837 //==============================================================================
838 //     _ _  _ _   | _  _ . _  .
839 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
840 //=====================_|=======================================================
841     /**
842      * @dev logic runs whenever a buy order is executed.  determines how to handle
843      * incoming eth depending on if we are in an active round or not
844      */
845     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
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
857             // call core
858             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
859 
860         // if round is not active
861         } else {
862             // check to see if end round needs to be ran
863             if (_now > round_[_rID].end && round_[_rID].ended == false)
864             {
865                 // end the round (distributes pot) & start new round
866 			    round_[_rID].ended = true;
867                 _eventData_ = endRound(_eventData_);
868 
869                 // build event data
870                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
871                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
872 
873                 // fire buy and distribute event
874                 emit F3Devents.onBuyAndDistribute
875                 (
876                     msg.sender,
877                     plyr_[_pID].name,
878                     msg.value,
879                     _eventData_.compressedData,
880                     _eventData_.compressedIDs,
881                     _eventData_.winnerAddr,
882                     _eventData_.winnerName,
883                     _eventData_.amountWon,
884                     _eventData_.newPot,
885                     _eventData_.P3DAmount,
886                     _eventData_.genAmount
887                 );
888             }
889 
890             // put eth in players vault
891             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
892         }
893     }
894 
895     /**
896      * @dev logic runs whenever a reload order is executed.  determines how to handle
897      * incoming eth depending on if we are in an active round or not
898      */
899     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
900         private
901     {
902         // setup local rID
903         uint256 _rID = rID_;
904 
905         // grab time
906         uint256 _now = now;
907 
908         // if round is active
909         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
910         {
911             // get earnings from all vaults and return unused to gen vault
912             // because we use a custom safemath library.  this will throw if player
913             // tried to spend more eth than they have.
914             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
915 
916             // call core
917             core(_rID, _pID, _eth, _affID, _team, _eventData_);
918 
919         // if round is not active and end round needs to be ran
920         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
921             // end the round (distributes pot) & start new round
922             round_[_rID].ended = true;
923             _eventData_ = endRound(_eventData_);
924 
925             // build event data
926             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
927             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
928 
929             // fire buy and distribute event
930             emit F3Devents.onReLoadAndDistribute
931             (
932                 msg.sender,
933                 plyr_[_pID].name,
934                 _eventData_.compressedData,
935                 _eventData_.compressedIDs,
936                 _eventData_.winnerAddr,
937                 _eventData_.winnerName,
938                 _eventData_.amountWon,
939                 _eventData_.newPot,
940                 _eventData_.P3DAmount,
941                 _eventData_.genAmount
942             );
943         }
944     }
945 
946     /**
947      * @dev this is the core logic for any buy/reload that happens while a round
948      * is live.
949      */
950     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
951         private
952     {
953         // if player is new to round
954         if (plyrRnds_[_pID][_rID].keys == 0)
955             _eventData_ = managePlayer(_pID, _eventData_);
956 
957         // early round eth limiter
958         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
959         {
960             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
961             uint256 _refund = _eth.sub(_availableLimit);
962             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
963             _eth = _availableLimit;
964         }
965 
966         // if eth left is greater than min eth allowed (sorry no pocket lint)
967         if (_eth > 1000000000)
968         {
969 
970             // mint the new keys
971             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
972 
973             // if they bought at least 1 whole key
974             if (_keys >= 1000000000000000000)
975             {
976             updateTimer(_keys, _rID);
977 
978             // set new leaders
979             if (round_[_rID].plyr != _pID)
980                 round_[_rID].plyr = _pID;
981             if (round_[_rID].team != _team)
982                 round_[_rID].team = _team;
983 
984             // set the new leader bool to true
985             _eventData_.compressedData = _eventData_.compressedData + 100;
986         }
987 
988             // manage airdrops
989             if (_eth >= 100000000000000000)
990             {
991             airDropTracker_++;
992             if (airdrop() == true)
993             {
994                 // gib muni
995                 uint256 _prize;
996                 if (_eth >= 10000000000000000000)
997                 {
998                     // calculate prize and give it to winner
999                     _prize = ((airDropPot_).mul(75)) / 100;
1000                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1001 
1002                     // adjust airDropPot
1003                     airDropPot_ = (airDropPot_).sub(_prize);
1004 
1005                     // let event know a tier 3 prize was won
1006                     _eventData_.compressedData += 300000000000000000000000000000000;
1007                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1008                     // calculate prize and give it to winner
1009                     _prize = ((airDropPot_).mul(50)) / 100;
1010                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1011 
1012                     // adjust airDropPot
1013                     airDropPot_ = (airDropPot_).sub(_prize);
1014 
1015                     // let event know a tier 2 prize was won
1016                     _eventData_.compressedData += 200000000000000000000000000000000;
1017                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1018                     // calculate prize and give it to winner
1019                     _prize = ((airDropPot_).mul(25)) / 100;
1020                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1021 
1022                     // adjust airDropPot
1023                     airDropPot_ = (airDropPot_).sub(_prize);
1024 
1025                     // let event know a tier 3 prize was won
1026                     _eventData_.compressedData += 300000000000000000000000000000000;
1027                 }
1028                 // set airdrop happened bool to true
1029                 _eventData_.compressedData += 10000000000000000000000000000000;
1030                 // let event know how much was won
1031                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1032 
1033                 // reset air drop tracker
1034                 airDropTracker_ = 0;
1035             }
1036         }
1037 
1038             // store the air drop tracker number (number of buys since last airdrop)
1039             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1040 
1041             // update player
1042             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1043             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1044 
1045             // update round
1046             round_[_rID].keys = _keys.add(round_[_rID].keys);
1047             round_[_rID].eth = _eth.add(round_[_rID].eth);
1048             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1049 
1050             // distribute eth
1051             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1052             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1053 
1054             // call end tx function to fire end tx event.
1055 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1056         }
1057     }
1058 //==============================================================================
1059 //     _ _ | _   | _ _|_ _  _ _  .
1060 //    (_(_||(_|_||(_| | (_)| _\  .
1061 //==============================================================================
1062     /**
1063      * @dev calculates unmasked earnings (just calculates, does not update mask)
1064      * @return earnings in wei format
1065      */
1066     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1067         private
1068         view
1069         returns(uint256)
1070     {
1071         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1072     }
1073 
1074     /**
1075      * @dev returns the amount of keys you would get given an amount of eth.
1076      * -functionhash- 0xce89c80c
1077      * @param _rID round ID you want price for
1078      * @param _eth amount of eth sent in
1079      * @return keys received
1080      */
1081     function calcKeysReceived(uint256 _rID, uint256 _eth)
1082         public
1083         view
1084         returns(uint256)
1085     {
1086         // grab time
1087         uint256 _now = now;
1088 
1089         // are we in a round?
1090         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1091             return ( (round_[_rID].eth).keysRec(_eth) );
1092         else // rounds over.  need keys for new round
1093             return ( (_eth).keys() );
1094     }
1095 
1096     /**
1097      * @dev returns current eth price for X keys.
1098      * -functionhash- 0xcf808000
1099      * @param _keys number of keys desired (in 18 decimal format)
1100      * @return amount of eth needed to send
1101      */
1102     function iWantXKeys(uint256 _keys)
1103         public
1104         view
1105         returns(uint256)
1106     {
1107         // setup local rID
1108         uint256 _rID = rID_;
1109 
1110         // grab time
1111         uint256 _now = now;
1112 
1113         // are we in a round?
1114         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1115             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1116         else // rounds over.  need price for new round
1117             return ( (_keys).eth() );
1118     }
1119 //==============================================================================
1120 //    _|_ _  _ | _  .
1121 //     | (_)(_)|_\  .
1122 //==============================================================================
1123     /**
1124 	 * @dev receives name/player info from names contract
1125      */
1126     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1127         external
1128     {
1129         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1130         if (pIDxAddr_[_addr] != _pID)
1131             pIDxAddr_[_addr] = _pID;
1132         if (pIDxName_[_name] != _pID)
1133             pIDxName_[_name] = _pID;
1134         if (plyr_[_pID].addr != _addr)
1135             plyr_[_pID].addr = _addr;
1136         if (plyr_[_pID].name != _name)
1137             plyr_[_pID].name = _name;
1138         if (plyr_[_pID].laff != _laff)
1139             plyr_[_pID].laff = _laff;
1140         if (plyrNames_[_pID][_name] == false)
1141             plyrNames_[_pID][_name] = true;
1142     }
1143 
1144     /**
1145      * @dev receives entire player name list
1146      */
1147     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1148         external
1149     {
1150         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1151         if(plyrNames_[_pID][_name] == false)
1152             plyrNames_[_pID][_name] = true;
1153     }
1154 
1155     /**
1156      * @dev gets existing or registers new pID.  use this when a player may be new
1157      * @return pID
1158      */
1159     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1160         private
1161         returns (F3Ddatasets.EventReturns)
1162     {
1163         uint256 _pID = pIDxAddr_[msg.sender];
1164         // if player is new to this version of fomo3d
1165         if (_pID == 0)
1166         {
1167             // grab their player ID, name and last aff ID, from player names contract
1168             _pID = PlayerBook.getPlayerID(msg.sender);
1169             bytes32 _name = PlayerBook.getPlayerName(_pID);
1170             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1171 
1172             // set up player account
1173             pIDxAddr_[msg.sender] = _pID;
1174             plyr_[_pID].addr = msg.sender;
1175 
1176             if (_name != "")
1177             {
1178                 pIDxName_[_name] = _pID;
1179                 plyr_[_pID].name = _name;
1180                 plyrNames_[_pID][_name] = true;
1181             }
1182 
1183             if (_laff != 0 && _laff != _pID)
1184                 plyr_[_pID].laff = _laff;
1185 
1186             // set the new player bool to true
1187             _eventData_.compressedData = _eventData_.compressedData + 1;
1188         }
1189         return (_eventData_);
1190     }
1191 
1192     /**
1193      * @dev checks to make sure user picked a valid team.  if not sets team
1194      * to default (sneks)
1195      */
1196     function verifyTeam(uint256 _team)
1197         private
1198         pure
1199         returns (uint256)
1200     {
1201         if (_team < 0 || _team > 3)
1202             return(2);
1203         else
1204             return(_team);
1205     }
1206 
1207     /**
1208      * @dev decides if round end needs to be run & new round started.  and if
1209      * player unmasked earnings from previously played rounds need to be moved.
1210      */
1211     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1212         private
1213         returns (F3Ddatasets.EventReturns)
1214     {
1215         // if player has played a previous round, move their unmasked earnings
1216         // from that round to gen vault.
1217         if (plyr_[_pID].lrnd != 0)
1218             updateGenVault(_pID, plyr_[_pID].lrnd);
1219 
1220         // update player's last round played
1221         plyr_[_pID].lrnd = rID_;
1222 
1223         // set the joined round bool to true
1224         _eventData_.compressedData = _eventData_.compressedData + 10;
1225 
1226         return(_eventData_);
1227     }
1228 
1229     /**
1230      * @dev ends the round. manages paying out winner/splitting up pot
1231      */
1232     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1233         private
1234         returns (F3Ddatasets.EventReturns)
1235     {
1236         // setup local rID
1237         uint256 _rID = rID_;
1238 
1239         // grab our winning player and team id's
1240         uint256 _winPID = round_[_rID].plyr;
1241         uint256 _winTID = round_[_rID].team;
1242 
1243         // grab our pot amount
1244         uint256 _pot = round_[_rID].pot;
1245 
1246         // calculate our winner share, community rewards, gen share,
1247         // p3d share, and amount reserved for next pot
1248         uint256 _win = (_pot.mul(48)) / 100;
1249         uint256 _com = (_pot / 50);
1250         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1251         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1252         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1253 
1254         // calculate ppt for round mask
1255         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1256         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1257         if (_dust > 0)
1258         {
1259             _gen = _gen.sub(_dust);
1260             _res = _res.add(_dust);
1261         }
1262 
1263         // pay our winner
1264         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1265 
1266         // community rewards
1267         _com = _com.add(_p3d.sub(_p3d / 2));
1268         admin.transfer(_com);
1269 
1270         _res = _res.add(_p3d / 2);
1271 
1272         // distribute gen portion to key holders
1273         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1274 
1275         // prepare event data
1276         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1277         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1278         _eventData_.winnerAddr = plyr_[_winPID].addr;
1279         _eventData_.winnerName = plyr_[_winPID].name;
1280         _eventData_.amountWon = _win;
1281         _eventData_.genAmount = _gen;
1282         _eventData_.P3DAmount = _p3d;
1283         _eventData_.newPot = _res;
1284 
1285         // start next round
1286         rID_++;
1287         _rID++;
1288         round_[_rID].strt = now;
1289         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1290         round_[_rID].pot = _res;
1291 
1292         return(_eventData_);
1293     }
1294 
1295     /**
1296      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1297      */
1298     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1299         private
1300     {
1301         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1302         if (_earnings > 0)
1303         {
1304             // put in gen vault
1305             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1306             // zero out their earnings by updating mask
1307             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1308         }
1309     }
1310 
1311     /**
1312      * @dev updates round timer based on number of whole keys bought.
1313      */
1314     function updateTimer(uint256 _keys, uint256 _rID)
1315         private
1316     {
1317         // grab time
1318         uint256 _now = now;
1319 
1320         // calculate time based on number of keys bought
1321         uint256 _newTime;
1322         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1323             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1324         else
1325             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1326 
1327         // compare to max and set new end time
1328         if (_newTime < (rndMax_).add(_now))
1329             round_[_rID].end = _newTime;
1330         else
1331             round_[_rID].end = rndMax_.add(_now);
1332     }
1333 
1334     /**
1335      * @dev generates a random number between 0-99 and checks to see if thats
1336      * resulted in an airdrop win
1337      * @return do we have a winner?
1338      */
1339     function airdrop()
1340         private
1341         view
1342         returns(bool)
1343     {
1344         uint256 seed = uint256(keccak256(abi.encodePacked(
1345 
1346             (block.timestamp).add
1347             (block.difficulty).add
1348             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1349             (block.gaslimit).add
1350             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1351             (block.number)
1352 
1353         )));
1354         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1355             return(true);
1356         else
1357             return(false);
1358     }
1359 
1360     /**
1361      * @dev distributes eth based on fees to com, aff, and p3d
1362      */
1363     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1364         private
1365         returns(F3Ddatasets.EventReturns)
1366     {
1367         // pay 3% out to community rewards
1368         uint256 _p1 = _eth / 100;
1369         uint256 _com = _eth / 5;
1370         _com = _com.add(_p1);
1371 
1372         uint256 _p3d;
1373         if (!address(admin).call.value(_com)())
1374         {
1375             // This ensures Team Just cannot influence the outcome of FoMo3D with
1376             // bank migrations by breaking outgoing transactions.
1377             // Something we would never do. But that's not the point.
1378             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1379             // highest belief that everything we create should be trustless.
1380             // Team JUST, The name you shouldn't have to trust.
1381             _p3d = _com;
1382             _com = 0;
1383         }
1384 
1385 
1386         // distribute share to affiliate
1387         uint256 _aff = _eth / 8;
1388 
1389         // decide what to do with affiliate share of fees
1390         // affiliate must not be self, and must have a name registered
1391         if (_affID != _pID && plyr_[_affID].name != '') {
1392             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1393             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1394         } else {
1395             _p3d = _p3d.add(_aff);
1396         }
1397 
1398         // pay out p3d
1399         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1400         if (_p3d > 0)
1401         {
1402             // deposit to divies contract
1403             uint256 _potAmount = _p3d / 2;
1404 
1405             admin.transfer(_p3d.sub(_potAmount));
1406 
1407             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1408 
1409             // set up event data
1410             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1411         }
1412 
1413         return(_eventData_);
1414     }
1415 
1416     function potSwap()
1417         external
1418         payable
1419     {
1420         // setup local rID
1421         uint256 _rID = rID_ + 1;
1422 
1423         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1424         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1425     }
1426 
1427     /**
1428      * @dev distributes eth based on fees to gen and pot
1429      */
1430     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1431         private
1432         returns(F3Ddatasets.EventReturns)
1433     {
1434         // calculate gen share
1435         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1436 
1437         // toss 1% into airdrop pot
1438         uint256 _air = (_eth / 100);
1439         airDropPot_ = airDropPot_.add(_air);
1440 
1441         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1442         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1443 
1444         // calculate pot
1445         uint256 _pot = _eth.sub(_gen);
1446 
1447         // distribute gen share (thats what updateMasks() does) and adjust
1448         // balances for dust.
1449         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1450         if (_dust > 0)
1451             _gen = _gen.sub(_dust);
1452 
1453         // add eth to pot
1454         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1455 
1456         // set up event data
1457         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1458         _eventData_.potAmount = _pot;
1459 
1460         return(_eventData_);
1461     }
1462 
1463     /**
1464      * @dev updates masks for round and player when keys are bought
1465      * @return dust left over
1466      */
1467     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1468         private
1469         returns(uint256)
1470     {
1471         /* MASKING NOTES
1472             earnings masks are a tricky thing for people to wrap their minds around.
1473             the basic thing to understand here.  is were going to have a global
1474             tracker based on profit per share for each round, that increases in
1475             relevant proportion to the increase in share supply.
1476 
1477             the player will have an additional mask that basically says "based
1478             on the rounds mask, my shares, and how much i've already withdrawn,
1479             how much is still owed to me?"
1480         */
1481 
1482         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1483         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1484         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1485 
1486         // calculate player earning from their own buy (only based on the keys
1487         // they just bought).  & update player earnings mask
1488         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1489         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1490 
1491         // calculate & return dust
1492         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1493     }
1494 
1495     /**
1496      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1497      * @return earnings in wei format
1498      */
1499     function withdrawEarnings(uint256 _pID)
1500         private
1501         returns(uint256)
1502     {
1503         // update gen vault
1504         updateGenVault(_pID, plyr_[_pID].lrnd);
1505 
1506         // from vaults
1507         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1508         if (_earnings > 0)
1509         {
1510             plyr_[_pID].win = 0;
1511             plyr_[_pID].gen = 0;
1512             plyr_[_pID].aff = 0;
1513         }
1514 
1515         return(_earnings);
1516     }
1517 
1518     /**
1519      * @dev prepares compression data and fires event for buy or reload tx's
1520      */
1521     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1522         private
1523     {
1524         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1525         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1526 
1527         emit F3Devents.onEndTx
1528         (
1529             _eventData_.compressedData,
1530             _eventData_.compressedIDs,
1531             plyr_[_pID].name,
1532             msg.sender,
1533             _eth,
1534             _keys,
1535             _eventData_.winnerAddr,
1536             _eventData_.winnerName,
1537             _eventData_.amountWon,
1538             _eventData_.newPot,
1539             _eventData_.P3DAmount,
1540             _eventData_.genAmount,
1541             _eventData_.potAmount,
1542             airDropPot_
1543         );
1544     }
1545 //==============================================================================
1546 //    (~ _  _    _._|_    .
1547 //    _)(/_(_|_|| | | \/  .
1548 //====================/=========================================================
1549     /** upon contract deploy, it will be deactivated.  this is a one time
1550      * use function that will activate the contract.  we do this so devs
1551      * have time to set things up on the web end                            **/
1552     bool public activated_ = false;
1553     function activate()
1554         public
1555     {
1556         // only team just can activate
1557         require(msg.sender == admin, "only admin can activate");
1558 
1559 
1560         // can only be ran once
1561         require(activated_ == false, "FOMO Short already activated");
1562 
1563         // activate the contract
1564         activated_ = true;
1565 
1566         // lets start first round
1567         rID_ = 1;
1568             round_[1].strt = now + rndExtra_ - rndGap_;
1569             round_[1].end = now + rndInit_ + rndExtra_;
1570     }
1571 }
1572 
1573 //==============================================================================
1574 //   __|_ _    __|_ _  .
1575 //  _\ | | |_|(_ | _\  .
1576 //==============================================================================
1577 library F3Ddatasets {
1578     //compressedData key
1579     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1580         // 0 - new player (bool)
1581         // 1 - joined round (bool)
1582         // 2 - new  leader (bool)
1583         // 3-5 - air drop tracker (uint 0-999)
1584         // 6-16 - round end time
1585         // 17 - winnerTeam
1586         // 18 - 28 timestamp
1587         // 29 - team
1588         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1589         // 31 - airdrop happened bool
1590         // 32 - airdrop tier
1591         // 33 - airdrop amount won
1592     //compressedIDs key
1593     // [77-52][51-26][25-0]
1594         // 0-25 - pID
1595         // 26-51 - winPID
1596         // 52-77 - rID
1597     struct EventReturns {
1598         uint256 compressedData;
1599         uint256 compressedIDs;
1600         address winnerAddr;         // winner address
1601         bytes32 winnerName;         // winner name
1602         uint256 amountWon;          // amount won
1603         uint256 newPot;             // amount in new pot
1604         uint256 P3DAmount;          // amount distributed to p3d
1605         uint256 genAmount;          // amount distributed to gen
1606         uint256 potAmount;          // amount added to pot
1607     }
1608     struct Player {
1609         address addr;   // player address
1610         bytes32 name;   // player name
1611         uint256 win;    // winnings vault
1612         uint256 gen;    // general vault
1613         uint256 aff;    // affiliate vault
1614         uint256 lrnd;   // last round played
1615         uint256 laff;   // last affiliate id used
1616     }
1617     struct PlayerRounds {
1618         uint256 eth;    // eth player has added to round (used for eth limiter)
1619         uint256 keys;   // keys
1620         uint256 mask;   // player mask
1621         uint256 ico;    // ICO phase investment
1622     }
1623     struct Round {
1624         uint256 plyr;   // pID of player in lead
1625         uint256 team;   // tID of team in lead
1626         uint256 end;    // time ends/ended
1627         bool ended;     // has round end function been ran
1628         uint256 strt;   // time round started
1629         uint256 keys;   // keys
1630         uint256 eth;    // total eth in
1631         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1632         uint256 mask;   // global mask
1633         uint256 ico;    // total eth sent in during ICO phase
1634         uint256 icoGen; // total eth for gen during ICO phase
1635         uint256 icoAvg; // average key price for ICO phase
1636     }
1637     struct TeamFee {
1638         uint256 gen;    // % of buy in thats paid to key holders of current round
1639         uint256 p3d;    // % of buy in thats paid to p3d holders
1640     }
1641     struct PotSplit {
1642         uint256 gen;    // % of pot thats paid to key holders of current round
1643         uint256 p3d;    // % of pot thats paid to p3d holders
1644     }
1645 }
1646 
1647 //==============================================================================
1648 //  |  _      _ _ | _  .
1649 //  |<(/_\/  (_(_||(_  .
1650 //=======/======================================================================
1651 library F3DKeysCalcShort {
1652     using SafeMath for *;
1653     /**
1654      * @dev calculates number of keys received given X eth
1655      * @param _curEth current amount of eth in contract
1656      * @param _newEth eth being spent
1657      * @return amount of ticket purchased
1658      */
1659     function keysRec(uint256 _curEth, uint256 _newEth)
1660         internal
1661         pure
1662         returns (uint256)
1663     {
1664         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1665     }
1666 
1667     /**
1668      * @dev calculates amount of eth received if you sold X keys
1669      * @param _curKeys current amount of keys that exist
1670      * @param _sellKeys amount of keys you wish to sell
1671      * @return amount of eth received
1672      */
1673     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1674         internal
1675         pure
1676         returns (uint256)
1677     {
1678         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1679     }
1680 
1681     /**
1682      * @dev calculates how many keys would exist with given an amount of eth
1683      * @param _eth eth "in contract"
1684      * @return number of keys that would exist
1685      */
1686     function keys(uint256 _eth)
1687         internal
1688         pure
1689         returns(uint256)
1690     {
1691         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1692     }
1693 
1694     /**
1695      * @dev calculates how much eth would be in contract given a number of keys
1696      * @param _keys number of keys "in contract"
1697      * @return eth that would exists
1698      */
1699     function eth(uint256 _keys)
1700         internal
1701         pure
1702         returns(uint256)
1703     {
1704         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1705     }
1706 }
1707 
1708 //==============================================================================
1709 //  . _ _|_ _  _ |` _  _ _  _  .
1710 //  || | | (/_| ~|~(_|(_(/__\  .
1711 //==============================================================================
1712 
1713 interface PlayerBookInterface {
1714     function getPlayerID(address _addr) external returns (uint256);
1715     function getPlayerName(uint256 _pID) external view returns (bytes32);
1716     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1717     function getPlayerAddr(uint256 _pID) external view returns (address);
1718     function getNameFee() external view returns (uint256);
1719     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1720     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1721     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1722 }
1723 
1724 /**
1725 * @title -Name Filter- v0.1.9
1726 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1727 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1728 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1729 *                                  _____                      _____
1730 *                                 (, /     /)       /) /)    (, /      /)          /)
1731 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1732 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1733 *          ┴ ┴                /   /          .-/ _____   (__ /
1734 *                            (__ /          (_/ (, /                                      /)™
1735 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1736 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1737 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1738 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1739 *              _       __    _      ____      ____  _   _    _____  ____  ___
1740 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1741 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1742 *
1743 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1744 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1745 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1746 */
1747 
1748 library NameFilter {
1749     /**
1750      * @dev filters name strings
1751      * -converts uppercase to lower case.
1752      * -makes sure it does not start/end with a space
1753      * -makes sure it does not contain multiple spaces in a row
1754      * -cannot be only numbers
1755      * -cannot start with 0x
1756      * -restricts characters to A-Z, a-z, 0-9, and space.
1757      * @return reprocessed string in bytes32 format
1758      */
1759     function nameFilter(string _input)
1760         internal
1761         pure
1762         returns(bytes32)
1763     {
1764         bytes memory _temp = bytes(_input);
1765         uint256 _length = _temp.length;
1766 
1767         //sorry limited to 32 characters
1768         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1769         // make sure it doesnt start with or end with space
1770         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1771         // make sure first two characters are not 0x
1772         if (_temp[0] == 0x30)
1773         {
1774             require(_temp[1] != 0x78, "string cannot start with 0x");
1775             require(_temp[1] != 0x58, "string cannot start with 0X");
1776         }
1777 
1778         // create a bool to track if we have a non number character
1779         bool _hasNonNumber;
1780 
1781         // convert & check
1782         for (uint256 i = 0; i < _length; i++)
1783         {
1784             // if its uppercase A-Z
1785             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1786             {
1787                 // convert to lower case a-z
1788                 _temp[i] = byte(uint(_temp[i]) + 32);
1789 
1790                 // we have a non number
1791                 if (_hasNonNumber == false)
1792                     _hasNonNumber = true;
1793             } else {
1794                 require
1795                 (
1796                     // require character is a space
1797                     _temp[i] == 0x20 ||
1798                     // OR lowercase a-z
1799                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1800                     // or 0-9
1801                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1802                     "string contains invalid characters"
1803                 );
1804                 // make sure theres not 2x spaces in a row
1805                 if (_temp[i] == 0x20)
1806                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1807 
1808                 // see if we have a character other than a number
1809                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1810                     _hasNonNumber = true;
1811             }
1812         }
1813 
1814         require(_hasNonNumber == true, "string cannot be only numbers");
1815 
1816         bytes32 _ret;
1817         assembly {
1818             _ret := mload(add(_temp, 32))
1819         }
1820         return (_ret);
1821     }
1822 }
1823 
1824 /**
1825  * @title SafeMath v0.1.9
1826  * @dev Math operations with safety checks that throw on error
1827  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1828  * - added sqrt
1829  * - added sq
1830  * - added pwr
1831  * - changed asserts to requires with error log outputs
1832  * - removed div, its useless
1833  */
1834 library SafeMath {
1835 
1836     /**
1837     * @dev Multiplies two numbers, throws on overflow.
1838     */
1839     function mul(uint256 a, uint256 b)
1840         internal
1841         pure
1842         returns (uint256 c)
1843     {
1844         if (a == 0) {
1845             return 0;
1846         }
1847         c = a * b;
1848         require(c / a == b, "SafeMath mul failed");
1849         return c;
1850     }
1851 
1852     /**
1853     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1854     */
1855     function sub(uint256 a, uint256 b)
1856         internal
1857         pure
1858         returns (uint256)
1859     {
1860         require(b <= a, "SafeMath sub failed");
1861         return a - b;
1862     }
1863 
1864     /**
1865     * @dev Adds two numbers, throws on overflow.
1866     */
1867     function add(uint256 a, uint256 b)
1868         internal
1869         pure
1870         returns (uint256 c)
1871     {
1872         c = a + b;
1873         require(c >= a, "SafeMath add failed");
1874         return c;
1875     }
1876 
1877     /**
1878      * @dev gives square root of given x.
1879      */
1880     function sqrt(uint256 x)
1881         internal
1882         pure
1883         returns (uint256 y)
1884     {
1885         uint256 z = ((add(x,1)) / 2);
1886         y = x;
1887         while (z < y)
1888         {
1889             y = z;
1890             z = ((add((x / z),z)) / 2);
1891         }
1892     }
1893 
1894     /**
1895      * @dev gives square. multiplies x by x
1896      */
1897     function sq(uint256 x)
1898         internal
1899         pure
1900         returns (uint256)
1901     {
1902         return (mul(x,x));
1903     }
1904 
1905     /**
1906      * @dev x to the power of y
1907      */
1908     function pwr(uint256 x, uint256 y)
1909         internal
1910         pure
1911         returns (uint256)
1912     {
1913         if (x==0)
1914             return (0);
1915         else if (y==0)
1916             return (1);
1917         else
1918         {
1919             uint256 z = x;
1920             for (uint256 i=1; i < y; i++)
1921                 z = mul(z,x);
1922             return (z);
1923         }
1924     }
1925 }