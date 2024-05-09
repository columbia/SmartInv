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
123 contract F5D is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcShort for uint256;
127 
128     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x4e369A53c989CE99475814aa0ad81Ad8eBE346E8);
129 
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     address private admin = 0xAbcd3976464519C648758233f6Fd19fecdf70Eb6;
135     address private coin_base = 0xe2300D461B62c8482C21e6E77E6DDf3F5B902478;
136     string constant public name = "F5D";
137     string constant public symbol = "F5D";
138     uint256 private rndExtra_ = 0;     // length of the very first ICO
139     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
140     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
141     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
142     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
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
954         // if player is new to round
955         if (plyrRnds_[_pID][_rID].keys == 0)
956             _eventData_ = managePlayer(_pID, _eventData_);
957 
958         // early round eth limiter
959         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
960         {
961             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
962             uint256 _refund = _eth.sub(_availableLimit);
963             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
964             _eth = _availableLimit;
965         }
966 
967         // if eth left is greater than min eth allowed (sorry no pocket lint)
968         if (_eth > 1000000000)
969         {
970 
971             // mint the new keys
972             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
973 
974             // if they bought at least 1 whole key
975             if (_keys >= 1000000000000000000)
976             {
977             updateTimer(_keys, _rID);
978 
979             // set new leaders
980             if (round_[_rID].plyr != _pID)
981                 round_[_rID].plyr = _pID;
982             if (round_[_rID].team != _team)
983                 round_[_rID].team = _team;
984 
985             // set the new leader bool to true
986             _eventData_.compressedData = _eventData_.compressedData + 100;
987         }
988 
989             // manage airdrops
990             if (_eth >= 100000000000000000)
991             {
992             airDropTracker_++;
993             if (airdrop() == true)
994             {
995                 // gib muni
996                 uint256 _prize;
997                 if (_eth >= 10000000000000000000)
998                 {
999                     // calculate prize and give it to winner
1000                     _prize = ((airDropPot_).mul(75)) / 100;
1001                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1002 
1003                     // adjust airDropPot
1004                     airDropPot_ = (airDropPot_).sub(_prize);
1005 
1006                     // let event know a tier 3 prize was won
1007                     _eventData_.compressedData += 300000000000000000000000000000000;
1008                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1009                     // calculate prize and give it to winner
1010                     _prize = ((airDropPot_).mul(50)) / 100;
1011                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1012 
1013                     // adjust airDropPot
1014                     airDropPot_ = (airDropPot_).sub(_prize);
1015 
1016                     // let event know a tier 2 prize was won
1017                     _eventData_.compressedData += 200000000000000000000000000000000;
1018                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1019                     // calculate prize and give it to winner
1020                     _prize = ((airDropPot_).mul(25)) / 100;
1021                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1022 
1023                     // adjust airDropPot
1024                     airDropPot_ = (airDropPot_).sub(_prize);
1025 
1026                     // let event know a tier 3 prize was won
1027                     _eventData_.compressedData += 300000000000000000000000000000000;
1028                 }
1029                 // set airdrop happened bool to true
1030                 _eventData_.compressedData += 10000000000000000000000000000000;
1031                 // let event know how much was won
1032                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1033 
1034                 // reset air drop tracker
1035                 airDropTracker_ = 0;
1036             }
1037         }
1038 
1039             // store the air drop tracker number (number of buys since last airdrop)
1040             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1041 
1042             // update player
1043             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1044             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1045 
1046             // update round
1047             round_[_rID].keys = _keys.add(round_[_rID].keys);
1048             round_[_rID].eth = _eth.add(round_[_rID].eth);
1049             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1050 
1051             // distribute eth
1052             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1053             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1054 
1055             // call end tx function to fire end tx event.
1056 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1057         }
1058     }
1059 //==============================================================================
1060 //     _ _ | _   | _ _|_ _  _ _  .
1061 //    (_(_||(_|_||(_| | (_)| _\  .
1062 //==============================================================================
1063     /**
1064      * @dev calculates unmasked earnings (just calculates, does not update mask)
1065      * @return earnings in wei format
1066      */
1067     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1068         private
1069         view
1070         returns(uint256)
1071     {
1072         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1073     }
1074 
1075     /**
1076      * @dev returns the amount of keys you would get given an amount of eth.
1077      * -functionhash- 0xce89c80c
1078      * @param _rID round ID you want price for
1079      * @param _eth amount of eth sent in
1080      * @return keys received
1081      */
1082     function calcKeysReceived(uint256 _rID, uint256 _eth)
1083         public
1084         view
1085         returns(uint256)
1086     {
1087         // grab time
1088         uint256 _now = now;
1089 
1090         // are we in a round?
1091         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1092             return ( (round_[_rID].eth).keysRec(_eth) );
1093         else // rounds over.  need keys for new round
1094             return ( (_eth).keys() );
1095     }
1096 
1097     /**
1098      * @dev returns current eth price for X keys.
1099      * -functionhash- 0xcf808000
1100      * @param _keys number of keys desired (in 18 decimal format)
1101      * @return amount of eth needed to send
1102      */
1103     function iWantXKeys(uint256 _keys)
1104         public
1105         view
1106         returns(uint256)
1107     {
1108         // setup local rID
1109         uint256 _rID = rID_;
1110 
1111         // grab time
1112         uint256 _now = now;
1113 
1114         // are we in a round?
1115         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1116             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1117         else // rounds over.  need price for new round
1118             return ( (_keys).eth() );
1119     }
1120 //==============================================================================
1121 //    _|_ _  _ | _  .
1122 //     | (_)(_)|_\  .
1123 //==============================================================================
1124     /**
1125 	 * @dev receives name/player info from names contract
1126      */
1127     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1128         external
1129     {
1130         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1131         if (pIDxAddr_[_addr] != _pID)
1132             pIDxAddr_[_addr] = _pID;
1133         if (pIDxName_[_name] != _pID)
1134             pIDxName_[_name] = _pID;
1135         if (plyr_[_pID].addr != _addr)
1136             plyr_[_pID].addr = _addr;
1137         if (plyr_[_pID].name != _name)
1138             plyr_[_pID].name = _name;
1139         if (plyr_[_pID].laff != _laff)
1140             plyr_[_pID].laff = _laff;
1141         if (plyrNames_[_pID][_name] == false)
1142             plyrNames_[_pID][_name] = true;
1143     }
1144 
1145     /**
1146      * @dev receives entire player name list
1147      */
1148     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1149         external
1150     {
1151         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1152         if(plyrNames_[_pID][_name] == false)
1153             plyrNames_[_pID][_name] = true;
1154     }
1155 
1156     /**
1157      * @dev gets existing or registers new pID.  use this when a player may be new
1158      * @return pID
1159      */
1160     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1161         private
1162         returns (F3Ddatasets.EventReturns)
1163     {
1164         uint256 _pID = pIDxAddr_[msg.sender];
1165         // if player is new to this version of fomo3d
1166         if (_pID == 0)
1167         {
1168             // grab their player ID, name and last aff ID, from player names contract
1169             _pID = PlayerBook.getPlayerID(msg.sender);
1170             bytes32 _name = PlayerBook.getPlayerName(_pID);
1171             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1172 
1173             // set up player account
1174             pIDxAddr_[msg.sender] = _pID;
1175             plyr_[_pID].addr = msg.sender;
1176 
1177             if (_name != "")
1178             {
1179                 pIDxName_[_name] = _pID;
1180                 plyr_[_pID].name = _name;
1181                 plyrNames_[_pID][_name] = true;
1182             }
1183 
1184             if (_laff != 0 && _laff != _pID)
1185                 plyr_[_pID].laff = _laff;
1186 
1187             // set the new player bool to true
1188             _eventData_.compressedData = _eventData_.compressedData + 1;
1189         }
1190         return (_eventData_);
1191     }
1192 
1193     /**
1194      * @dev checks to make sure user picked a valid team.  if not sets team
1195      * to default (sneks)
1196      */
1197     function verifyTeam(uint256 _team)
1198         private
1199         pure
1200         returns (uint256)
1201     {
1202         if (_team < 0 || _team > 3)
1203             return(2);
1204         else
1205             return(_team);
1206     }
1207 
1208     /**
1209      * @dev decides if round end needs to be run & new round started.  and if
1210      * player unmasked earnings from previously played rounds need to be moved.
1211      */
1212     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1213         private
1214         returns (F3Ddatasets.EventReturns)
1215     {
1216         // if player has played a previous round, move their unmasked earnings
1217         // from that round to gen vault.
1218         if (plyr_[_pID].lrnd != 0)
1219             updateGenVault(_pID, plyr_[_pID].lrnd);
1220 
1221         // update player's last round played
1222         plyr_[_pID].lrnd = rID_;
1223 
1224         // set the joined round bool to true
1225         _eventData_.compressedData = _eventData_.compressedData + 10;
1226 
1227         return(_eventData_);
1228     }
1229 
1230     /**
1231      * @dev ends the round. manages paying out winner/splitting up pot
1232      */
1233     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1234         private
1235         returns (F3Ddatasets.EventReturns)
1236     {
1237         // setup local rID
1238         uint256 _rID = rID_;
1239 
1240         // grab our winning player and team id's
1241         uint256 _winPID = round_[_rID].plyr;
1242         uint256 _winTID = round_[_rID].team;
1243 
1244         // grab our pot amount
1245         uint256 _pot = round_[_rID].pot;
1246 
1247         // calculate our winner share, community rewards, gen share,
1248         // p3d share, and amount reserved for next pot
1249         uint256 _win = (_pot.mul(48)) / 100;
1250         uint256 _com = (_pot / 50);
1251         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1252         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1253         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1254 
1255         // calculate ppt for round mask
1256         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1257         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1258         if (_dust > 0)
1259         {
1260             _gen = _gen.sub(_dust);
1261             _res = _res.add(_dust);
1262         }
1263 
1264         // pay our winner
1265         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1266 
1267         // community rewards
1268         _com = _com.add(_p3d.sub(_p3d / 100 ));
1269         coin_base.transfer(_com);
1270 
1271         _res = _res.add(_p3d / 100);
1272 
1273         // distribute gen portion to key holders
1274         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1275 
1276         // prepare event data
1277         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1278         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1279         _eventData_.winnerAddr = plyr_[_winPID].addr;
1280         _eventData_.winnerName = plyr_[_winPID].name;
1281         _eventData_.amountWon = _win;
1282         _eventData_.genAmount = _gen;
1283         _eventData_.P3DAmount = _p3d;
1284         _eventData_.newPot = _res;
1285 
1286         // start next round
1287         rID_++;
1288         _rID++;
1289         round_[_rID].strt = now;
1290         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1291         round_[_rID].pot = _res;
1292 
1293         return(_eventData_);
1294     }
1295 
1296     /**
1297      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1298      */
1299     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1300         private
1301     {
1302         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1303         if (_earnings > 0)
1304         {
1305             // put in gen vault
1306             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1307             // zero out their earnings by updating mask
1308             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1309         }
1310     }
1311 
1312     /**
1313      * @dev updates round timer based on number of whole keys bought.
1314      */
1315     function updateTimer(uint256 _keys, uint256 _rID)
1316         private
1317     {
1318         // grab time
1319         uint256 _now = now;
1320 
1321         // calculate time based on number of keys bought
1322         uint256 _newTime;
1323         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1324             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1325         else
1326             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1327 
1328         // compare to max and set new end time
1329         if (_newTime < (rndMax_).add(_now))
1330             round_[_rID].end = _newTime;
1331         else
1332             round_[_rID].end = rndMax_.add(_now);
1333     }
1334 
1335     /**
1336      * @dev generates a random number between 0-99 and checks to see if thats
1337      * resulted in an airdrop win
1338      * @return do we have a winner?
1339      */
1340     function airdrop()
1341         private
1342         view
1343         returns(bool)
1344     {
1345         uint256 seed = uint256(keccak256(abi.encodePacked(
1346 
1347             (block.timestamp).add
1348             (block.difficulty).add
1349             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1350             (block.gaslimit).add
1351             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1352             (block.number)
1353 
1354         )));
1355         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1356             return(true);
1357         else
1358             return(false);
1359     }
1360 
1361     /**
1362      * @dev distributes eth based on fees to com, aff, and p3d
1363      */
1364     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1365         private
1366         returns(F3Ddatasets.EventReturns)
1367     {
1368         // pay 3% out to community rewards
1369         uint256 _p1 = _eth / 100;
1370         uint256 _com = _eth / 50;
1371         _com = _com.add(_p1);
1372 
1373         uint256 _p3d;
1374         if (!address(coin_base).call.value(_com)())
1375         {
1376             // This ensures Team Just cannot influence the outcome of FoMo3D with
1377             // bank migrations by breaking outgoing transactions.
1378             // Something we would never do. But that's not the point.
1379             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1380             // highest belief that everything we create should be trustless.
1381             // Team JUST, The name you shouldn't have to trust.
1382             _p3d = _com;
1383             _com = 0;
1384         }
1385 
1386 
1387         // distribute share to affiliate
1388         uint256 _aff = _eth / 100 * 17;
1389 
1390         // decide what to do with affiliate share of fees
1391         // affiliate must not be self, and must have a name registered
1392         if (_affID != _pID && plyr_[_affID].name != '') {
1393             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1394             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1395         } else {
1396             _p3d = _p3d.add(_aff);
1397         }
1398 
1399         // pay out p3d
1400         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1401         if (_p3d > 0)
1402         {
1403             // deposit to divies contract
1404             uint256 _potAmount = _p3d / 2;
1405 
1406             coin_base.transfer(_p3d.sub(_potAmount));
1407 
1408             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1409 
1410             // set up event data
1411             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1412         }
1413 
1414         return(_eventData_);
1415     }
1416 
1417     function potSwap()
1418         external
1419         payable
1420     {
1421         // setup local rID
1422         uint256 _rID = rID_ + 1;
1423 
1424         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1425         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1426     }
1427 
1428     /**
1429      * @dev distributes eth based on fees to gen and pot
1430      */
1431     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1432         private
1433         returns(F3Ddatasets.EventReturns)
1434     {
1435         // calculate gen share
1436         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1437 
1438         // toss 1% into airdrop pot
1439         uint256 _air = (_eth / 100);
1440         airDropPot_ = airDropPot_.add(_air);
1441 
1442         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1443         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1444 
1445         // calculate pot
1446         uint256 _pot = _eth.sub(_gen);
1447 
1448         // distribute gen share (thats what updateMasks() does) and adjust
1449         // balances for dust.
1450         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1451         if (_dust > 0)
1452             _gen = _gen.sub(_dust);
1453 
1454         // add eth to pot
1455         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1456 
1457         // set up event data
1458         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1459         _eventData_.potAmount = _pot;
1460 
1461         return(_eventData_);
1462     }
1463 
1464     /**
1465      * @dev updates masks for round and player when keys are bought
1466      * @return dust left over
1467      */
1468     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1469         private
1470         returns(uint256)
1471     {
1472         /* MASKING NOTES
1473             earnings masks are a tricky thing for people to wrap their minds around.
1474             the basic thing to understand here.  is were going to have a global
1475             tracker based on profit per share for each round, that increases in
1476             relevant proportion to the increase in share supply.
1477 
1478             the player will have an additional mask that basically says "based
1479             on the rounds mask, my shares, and how much i've already withdrawn,
1480             how much is still owed to me?"
1481         */
1482 
1483         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1484         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1485         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1486 
1487         // calculate player earning from their own buy (only based on the keys
1488         // they just bought).  & update player earnings mask
1489         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1490         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1491 
1492         // calculate & return dust
1493         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1494     }
1495 
1496     /**
1497      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1498      * @return earnings in wei format
1499      */
1500     function withdrawEarnings(uint256 _pID)
1501         private
1502         returns(uint256)
1503     {
1504         // update gen vault
1505         updateGenVault(_pID, plyr_[_pID].lrnd);
1506 
1507         // from vaults
1508         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1509         if (_earnings > 0)
1510         {
1511             plyr_[_pID].win = 0;
1512             plyr_[_pID].gen = 0;
1513             plyr_[_pID].aff = 0;
1514         }
1515 
1516         return(_earnings);
1517     }
1518 
1519     /**
1520      * @dev prepares compression data and fires event for buy or reload tx's
1521      */
1522     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1523         private
1524     {
1525         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1526         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1527 
1528         emit F3Devents.onEndTx
1529         (
1530             _eventData_.compressedData,
1531             _eventData_.compressedIDs,
1532             plyr_[_pID].name,
1533             msg.sender,
1534             _eth,
1535             _keys,
1536             _eventData_.winnerAddr,
1537             _eventData_.winnerName,
1538             _eventData_.amountWon,
1539             _eventData_.newPot,
1540             _eventData_.P3DAmount,
1541             _eventData_.genAmount,
1542             _eventData_.potAmount,
1543             airDropPot_
1544         );
1545     }
1546 //==============================================================================
1547 //    (~ _  _    _._|_    .
1548 //    _)(/_(_|_|| | | \/  .
1549 //====================/=========================================================
1550     /** upon contract deploy, it will be deactivated.  this is a one time
1551      * use function that will activate the contract.  we do this so devs
1552      * have time to set things up on the web end                            **/
1553     bool public activated_ = false;
1554     function activate()
1555         public
1556     {
1557         // only team just can activate
1558         require(msg.sender == admin, "only admin can activate");
1559 
1560 
1561         // can only be ran once
1562         require(activated_ == false, "FOMO Short already activated");
1563 
1564         // activate the contract
1565         activated_ = true;
1566 
1567         // lets start first round
1568         rID_ = 1;
1569             round_[1].strt = now + rndExtra_ - rndGap_;
1570             round_[1].end = now + rndInit_ + rndExtra_;
1571     }
1572 }
1573 
1574 //==============================================================================
1575 //   __|_ _    __|_ _  .
1576 //  _\ | | |_|(_ | _\  .
1577 //==============================================================================
1578 library F3Ddatasets {
1579     //compressedData key
1580     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1581         // 0 - new player (bool)
1582         // 1 - joined round (bool)
1583         // 2 - new  leader (bool)
1584         // 3-5 - air drop tracker (uint 0-999)
1585         // 6-16 - round end time
1586         // 17 - winnerTeam
1587         // 18 - 28 timestamp
1588         // 29 - team
1589         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1590         // 31 - airdrop happened bool
1591         // 32 - airdrop tier
1592         // 33 - airdrop amount won
1593     //compressedIDs key
1594     // [77-52][51-26][25-0]
1595         // 0-25 - pID
1596         // 26-51 - winPID
1597         // 52-77 - rID
1598     struct EventReturns {
1599         uint256 compressedData;
1600         uint256 compressedIDs;
1601         address winnerAddr;         // winner address
1602         bytes32 winnerName;         // winner name
1603         uint256 amountWon;          // amount won
1604         uint256 newPot;             // amount in new pot
1605         uint256 P3DAmount;          // amount distributed to p3d
1606         uint256 genAmount;          // amount distributed to gen
1607         uint256 potAmount;          // amount added to pot
1608     }
1609     struct Player {
1610         address addr;   // player address
1611         bytes32 name;   // player name
1612         uint256 win;    // winnings vault
1613         uint256 gen;    // general vault
1614         uint256 aff;    // affiliate vault
1615         uint256 lrnd;   // last round played
1616         uint256 laff;   // last affiliate id used
1617     }
1618     struct PlayerRounds {
1619         uint256 eth;    // eth player has added to round (used for eth limiter)
1620         uint256 keys;   // keys
1621         uint256 mask;   // player mask
1622         uint256 ico;    // ICO phase investment
1623     }
1624     struct Round {
1625         uint256 plyr;   // pID of player in lead
1626         uint256 team;   // tID of team in lead
1627         uint256 end;    // time ends/ended
1628         bool ended;     // has round end function been ran
1629         uint256 strt;   // time round started
1630         uint256 keys;   // keys
1631         uint256 eth;    // total eth in
1632         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1633         uint256 mask;   // global mask
1634         uint256 ico;    // total eth sent in during ICO phase
1635         uint256 icoGen; // total eth for gen during ICO phase
1636         uint256 icoAvg; // average key price for ICO phase
1637     }
1638     struct TeamFee {
1639         uint256 gen;    // % of buy in thats paid to key holders of current round
1640         uint256 p3d;    // % of buy in thats paid to p3d holders
1641     }
1642     struct PotSplit {
1643         uint256 gen;    // % of pot thats paid to key holders of current round
1644         uint256 p3d;    // % of pot thats paid to p3d holders
1645     }
1646 }
1647 
1648 //==============================================================================
1649 //  |  _      _ _ | _  .
1650 //  |<(/_\/  (_(_||(_  .
1651 //=======/======================================================================
1652 library F3DKeysCalcShort {
1653     using SafeMath for *;
1654     /**
1655      * @dev calculates number of keys received given X eth
1656      * @param _curEth current amount of eth in contract
1657      * @param _newEth eth being spent
1658      * @return amount of ticket purchased
1659      */
1660     function keysRec(uint256 _curEth, uint256 _newEth)
1661         internal
1662         pure
1663         returns (uint256)
1664     {
1665         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1666     }
1667 
1668     /**
1669      * @dev calculates amount of eth received if you sold X keys
1670      * @param _curKeys current amount of keys that exist
1671      * @param _sellKeys amount of keys you wish to sell
1672      * @return amount of eth received
1673      */
1674     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1675         internal
1676         pure
1677         returns (uint256)
1678     {
1679         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1680     }
1681 
1682     /**
1683      * @dev calculates how many keys would exist with given an amount of eth
1684      * @param _eth eth "in contract"
1685      * @return number of keys that would exist
1686      */
1687     function keys(uint256 _eth)
1688         internal
1689         pure
1690         returns(uint256)
1691     {
1692         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1693     }
1694 
1695     /**
1696      * @dev calculates how much eth would be in contract given a number of keys
1697      * @param _keys number of keys "in contract"
1698      * @return eth that would exists
1699      */
1700     function eth(uint256 _keys)
1701         internal
1702         pure
1703         returns(uint256)
1704     {
1705         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1706     }
1707 }
1708 
1709 //==============================================================================
1710 //  . _ _|_ _  _ |` _  _ _  _  .
1711 //  || | | (/_| ~|~(_|(_(/__\  .
1712 //==============================================================================
1713 
1714 interface PlayerBookInterface {
1715     function getPlayerID(address _addr) external returns (uint256);
1716     function getPlayerName(uint256 _pID) external view returns (bytes32);
1717     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1718     function getPlayerAddr(uint256 _pID) external view returns (address);
1719     function getNameFee() external view returns (uint256);
1720     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1721     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1722     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1723 }
1724 
1725 /**
1726 * @title -Name Filter- v0.1.9
1727 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1728 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1729 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1730 *                                  _____                      _____
1731 *                                 (, /     /)       /) /)    (, /      /)          /)
1732 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1733 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1734 *          ┴ ┴                /   /          .-/ _____   (__ /
1735 *                            (__ /          (_/ (, /                                      /)™
1736 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1737 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1738 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1739 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1740 *              _       __    _      ____      ____  _   _    _____  ____  ___
1741 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1742 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1743 *
1744 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1745 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1746 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1747 */
1748 
1749 library NameFilter {
1750     /**
1751      * @dev filters name strings
1752      * -converts uppercase to lower case.
1753      * -makes sure it does not start/end with a space
1754      * -makes sure it does not contain multiple spaces in a row
1755      * -cannot be only numbers
1756      * -cannot start with 0x
1757      * -restricts characters to A-Z, a-z, 0-9, and space.
1758      * @return reprocessed string in bytes32 format
1759      */
1760     function nameFilter(string _input)
1761         internal
1762         pure
1763         returns(bytes32)
1764     {
1765         bytes memory _temp = bytes(_input);
1766         uint256 _length = _temp.length;
1767 
1768         //sorry limited to 32 characters
1769         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1770         // make sure it doesnt start with or end with space
1771         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1772         // make sure first two characters are not 0x
1773         if (_temp[0] == 0x30)
1774         {
1775             require(_temp[1] != 0x78, "string cannot start with 0x");
1776             require(_temp[1] != 0x58, "string cannot start with 0X");
1777         }
1778 
1779         // create a bool to track if we have a non number character
1780         bool _hasNonNumber;
1781 
1782         // convert & check
1783         for (uint256 i = 0; i < _length; i++)
1784         {
1785             // if its uppercase A-Z
1786             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1787             {
1788                 // convert to lower case a-z
1789                 _temp[i] = byte(uint(_temp[i]) + 32);
1790 
1791                 // we have a non number
1792                 if (_hasNonNumber == false)
1793                     _hasNonNumber = true;
1794             } else {
1795                 require
1796                 (
1797                     // require character is a space
1798                     _temp[i] == 0x20 ||
1799                     // OR lowercase a-z
1800                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1801                     // or 0-9
1802                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1803                     "string contains invalid characters"
1804                 );
1805                 // make sure theres not 2x spaces in a row
1806                 if (_temp[i] == 0x20)
1807                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1808 
1809                 // see if we have a character other than a number
1810                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1811                     _hasNonNumber = true;
1812             }
1813         }
1814 
1815         require(_hasNonNumber == true, "string cannot be only numbers");
1816 
1817         bytes32 _ret;
1818         assembly {
1819             _ret := mload(add(_temp, 32))
1820         }
1821         return (_ret);
1822     }
1823 }
1824 
1825 /**
1826  * @title SafeMath v0.1.9
1827  * @dev Math operations with safety checks that throw on error
1828  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1829  * - added sqrt
1830  * - added sq
1831  * - added pwr
1832  * - changed asserts to requires with error log outputs
1833  * - removed div, its useless
1834  */
1835 library SafeMath {
1836 
1837     /**
1838     * @dev Multiplies two numbers, throws on overflow.
1839     */
1840     function mul(uint256 a, uint256 b)
1841         internal
1842         pure
1843         returns (uint256 c)
1844     {
1845         if (a == 0) {
1846             return 0;
1847         }
1848         c = a * b;
1849         require(c / a == b, "SafeMath mul failed");
1850         return c;
1851     }
1852 
1853     /**
1854     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1855     */
1856     function sub(uint256 a, uint256 b)
1857         internal
1858         pure
1859         returns (uint256)
1860     {
1861         require(b <= a, "SafeMath sub failed");
1862         return a - b;
1863     }
1864 
1865     /**
1866     * @dev Adds two numbers, throws on overflow.
1867     */
1868     function add(uint256 a, uint256 b)
1869         internal
1870         pure
1871         returns (uint256 c)
1872     {
1873         c = a + b;
1874         require(c >= a, "SafeMath add failed");
1875         return c;
1876     }
1877 
1878     /**
1879      * @dev gives square root of given x.
1880      */
1881     function sqrt(uint256 x)
1882         internal
1883         pure
1884         returns (uint256 y)
1885     {
1886         uint256 z = ((add(x,1)) / 2);
1887         y = x;
1888         while (z < y)
1889         {
1890             y = z;
1891             z = ((add((x / z),z)) / 2);
1892         }
1893     }
1894 
1895     /**
1896      * @dev gives square. multiplies x by x
1897      */
1898     function sq(uint256 x)
1899         internal
1900         pure
1901         returns (uint256)
1902     {
1903         return (mul(x,x));
1904     }
1905 
1906     /**
1907      * @dev x to the power of y
1908      */
1909     function pwr(uint256 x, uint256 y)
1910         internal
1911         pure
1912         returns (uint256)
1913     {
1914         if (x==0)
1915             return (0);
1916         else if (y==0)
1917             return (1);
1918         else
1919         {
1920             uint256 z = x;
1921             for (uint256 i=1; i < y; i++)
1922                 z = mul(z,x);
1923             return (z);
1924         }
1925     }
1926 }