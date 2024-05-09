1 pragma solidity ^0.4.24;
2 /**
3  * @title -OK3D v0.0.1
4  *
5  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
6  */
7 
8 //==============================================================================
9 //     _    _  _ _|_ _  .
10 //    (/_\/(/_| | | _\  .
11 //==============================================================================
12 contract F3Devents {
13     // fired whenever a player registers a name
14     event onNewName
15     (
16         uint256 indexed playerID,
17         address indexed playerAddress,
18         bytes32 indexed playerName,
19         bool isNewPlayer,
20         uint256 affiliateID,
21         address affiliateAddress,
22         bytes32 affiliateName,
23         uint256 amountPaid,
24         uint256 timeStamp
25     );
26 
27     // fired at end of buy or reload
28     event onEndTx
29     (
30         uint256 compressedData,
31         uint256 compressedIDs,
32         bytes32 playerName,
33         address playerAddress,
34         uint256 ethIn,
35         uint256 keysBought,
36         address winnerAddr,
37         bytes32 winnerName,
38         uint256 amountWon,
39         uint256 newPot,
40         uint256 P3DAmount,
41         uint256 genAmount,
42         uint256 potAmount,
43         uint256 airDropPot
44     );
45 
46 	// fired whenever theres a withdraw
47     event onWithdraw
48     (
49         uint256 indexed playerID,
50         address playerAddress,
51         bytes32 playerName,
52         uint256 ethOut,
53         uint256 timeStamp
54     );
55 
56     // fired whenever a withdraw forces end round to be ran
57     event onWithdrawAndDistribute
58     (
59         address playerAddress,
60         bytes32 playerName,
61         uint256 ethOut,
62         uint256 compressedData,
63         uint256 compressedIDs,
64         address winnerAddr,
65         bytes32 winnerName,
66         uint256 amountWon,
67         uint256 newPot,
68         uint256 P3DAmount,
69         uint256 genAmount
70     );
71 
72     // (OK3D short only) fired whenever a player tries a buy after round timer
73     // hit zero, and causes end round to be ran.
74     event onBuyAndDistribute
75     (
76         address playerAddress,
77         bytes32 playerName,
78         uint256 ethIn,
79         uint256 compressedData,
80         uint256 compressedIDs,
81         address winnerAddr,
82         bytes32 winnerName,
83         uint256 amountWon,
84         uint256 newPot,
85         uint256 P3DAmount,
86         uint256 genAmount
87     );
88 
89     // (OK3D short only) fired whenever a player tries a reload after round timer
90     // hit zero, and causes end round to be ran.
91     event onReLoadAndDistribute
92     (
93         address playerAddress,
94         bytes32 playerName,
95         uint256 compressedData,
96         uint256 compressedIDs,
97         address winnerAddr,
98         bytes32 winnerName,
99         uint256 amountWon,
100         uint256 newPot,
101         uint256 P3DAmount,
102         uint256 genAmount
103     );
104 
105     // fired whenever an affiliate is paid
106     event onAffiliatePayout
107     (
108         uint256 indexed affiliateID,
109         address affiliateAddress,
110         bytes32 affiliateName,
111         uint256 indexed roundID,
112         uint256 indexed buyerID,
113         uint256 amount,
114         uint256 timeStamp
115     );
116 
117     // received pot swap deposit
118     event onPotSwapDeposit
119     (
120         uint256 roundID,
121         uint256 amountAddedToPot
122     );
123 }
124 
125 //==============================================================================
126 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
127 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
128 //====================================|=========================================
129 
130 contract modularShort is F3Devents {}
131 
132 contract OK3D is modularShort {
133     using SafeMath for *;
134     using NameFilter for string;
135     using F3DKeysCalcShort for uint256;
136 
137     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x5015A6E288FF4AC0c62bf1DA237c24c3Fb849188);
138 
139 //==============================================================================
140 //     _ _  _  |`. _     _ _ |_ | _  _  .
141 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
142 //=================_|===========================================================
143     address private admin = msg.sender;
144     string constant public name = "OK3D";
145     string constant public symbol = "OK3D";
146     uint256 private rndExtra_ = 0;     // length of the very first ICO
147     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
148     uint256 constant private rndInit_ = 12 hours;                // round timer starts at this
149     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
150     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
151 //==============================================================================
152 //     _| _ _|_ _    _ _ _|_    _   .
153 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
154 //=============================|================================================
155     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
156     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
157     uint256 public rID_;    // round id number / total rounds that have happened
158 //****************
159 // PLAYER DATA
160 //****************
161     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
162     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
163     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
164     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
165     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
166 //****************
167 // ROUND DATA
168 //****************
169     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
170     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
171 //****************
172 // TEAM FEE DATA
173 //****************
174     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
175     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
176 //==============================================================================
177 //     _ _  _  __|_ _    __|_ _  _  .
178 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
179 //==============================================================================
180     constructor()
181         public
182     {
183 		// Team allocation structures
184         // 0 = whales
185         // 1 = bears
186         // 2 = sneks
187         // 3 = bulls
188 
189 		// Team allocation percentages
190         // (F3D, P3D) + (Pot , Referrals, Community)
191             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
192         fees_[0] = F3Ddatasets.TeamFee(28,10);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
193         fees_[1] = F3Ddatasets.TeamFee(36,10);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
194         fees_[2] = F3Ddatasets.TeamFee(51,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
195         fees_[3] = F3Ddatasets.TeamFee(40,10);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
196 
197         // how to split up the final pot based on which team was picked
198         // (F3D, P3D)
199         potSplit_[0] = F3Ddatasets.PotSplit(25,10);  //48% to winner, 25% to next round, 2% to com
200         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
201         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
202         potSplit_[3] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
203 
204         activated_ = true;
205 
206         // lets start first round
207         rID_ = 1;
208         round_[1].strt = now + rndExtra_ - rndGap_;
209         round_[1].end = now + rndInit_ + rndExtra_;
210 	}
211 //==============================================================================
212 //     _ _  _  _|. |`. _  _ _  .
213 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
214 //==============================================================================
215     /**
216      * @dev used to make sure no one can interact with contract until it has
217      * been activated.
218      */
219     modifier isActivated() {
220         require(activated_ == true, "its not ready yet.  check ?eta in discord");
221         _;
222     }
223 
224     /**
225      * @dev prevents contracts from interacting with fomo3d
226      */
227     modifier isHuman() {
228         address _addr = msg.sender;
229         uint256 _codeLength;
230 
231         assembly {_codeLength := extcodesize(_addr)}
232         require(_codeLength == 0, "sorry humans only");
233         _;
234     }
235 
236     /**
237      * @dev sets boundaries for incoming tx
238      */
239     modifier isWithinLimits(uint256 _eth) {
240         require(_eth >= 1000000000, "pocket lint: not a valid currency");
241         require(_eth <= 100000000000000000000000, "no vitalik, no");
242         _;
243     }
244 
245 //==============================================================================
246 //     _    |_ |. _   |`    _  __|_. _  _  _  .
247 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
248 //====|=========================================================================
249     /**
250      * @dev emergency buy uses last stored affiliate ID and team snek
251      */
252     function()
253         isActivated()
254         isHuman()
255         isWithinLimits(msg.value)
256         public
257         payable
258     {
259         // set up our tx event data and determine if player is new or not
260         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
261 
262         // fetch player id
263         uint256 _pID = pIDxAddr_[msg.sender];
264 
265         // buy core
266         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
267     }
268 
269     /**
270      * @dev converts all incoming ethereum to keys.
271      * -functionhash- 0x8f38f309 (using ID for affiliate)
272      * -functionhash- 0x98a0871d (using address for affiliate)
273      * -functionhash- 0xa65b37a1 (using name for affiliate)
274      * @param _affCode the ID/address/name of the player who gets the affiliate fee
275      * @param _team what team is the player playing for?
276      */
277     function buyXid(uint256 _affCode, uint256 _team)
278         isActivated()
279         isHuman()
280         isWithinLimits(msg.value)
281         public
282         payable
283     {
284         // set up our tx event data and determine if player is new or not
285         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
286 
287         // fetch player id
288         uint256 _pID = pIDxAddr_[msg.sender];
289 
290         // manage affiliate residuals
291         // if no affiliate code was given or player tried to use their own, lolz
292         if (_affCode == 0 || _affCode == _pID)
293         {
294             // use last stored affiliate code
295             _affCode = plyr_[_pID].laff;
296 
297         // if affiliate code was given & its not the same as previously stored
298         } else if (_affCode != plyr_[_pID].laff) {
299             // update last affiliate
300             plyr_[_pID].laff = _affCode;
301         }
302 
303         // verify a valid team was selected
304         _team = verifyTeam(_team);
305 
306         // buy core
307         buyCore(_pID, _affCode, _team, _eventData_);
308     }
309 
310     function buyXaddr(address _affCode, uint256 _team)
311         isActivated()
312         isHuman()
313         isWithinLimits(msg.value)
314         public
315         payable
316     {
317         // set up our tx event data and determine if player is new or not
318         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
319 
320         // fetch player id
321         uint256 _pID = pIDxAddr_[msg.sender];
322 
323         // manage affiliate residuals
324         uint256 _affID;
325         // if no affiliate code was given or player tried to use their own, lolz
326         if (_affCode == address(0) || _affCode == msg.sender)
327         {
328             // use last stored affiliate code
329             _affID = plyr_[_pID].laff;
330 
331         // if affiliate code was given
332         } else {
333             // get affiliate ID from aff Code
334             _affID = pIDxAddr_[_affCode];
335 
336             // if affID is not the same as previously stored
337             if (_affID != plyr_[_pID].laff)
338             {
339                 // update last affiliate
340                 plyr_[_pID].laff = _affID;
341             }
342         }
343 
344         // verify a valid team was selected
345         _team = verifyTeam(_team);
346 
347         // buy core
348         buyCore(_pID, _affID, _team, _eventData_);
349     }
350 
351     function buyXname(bytes32 _affCode, uint256 _team)
352         isActivated()
353         isHuman()
354         isWithinLimits(msg.value)
355         public
356         payable
357     {
358         // set up our tx event data and determine if player is new or not
359         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
360 
361         // fetch player id
362         uint256 _pID = pIDxAddr_[msg.sender];
363 
364         // manage affiliate residuals
365         uint256 _affID;
366         // if no affiliate code was given or player tried to use their own, lolz
367         if (_affCode == '' || _affCode == plyr_[_pID].name)
368         {
369             // use last stored affiliate code
370             _affID = plyr_[_pID].laff;
371 
372         // if affiliate code was given
373         } else {
374             // get affiliate ID from aff Code
375             _affID = pIDxName_[_affCode];
376 
377             // if affID is not the same as previously stored
378             if (_affID != plyr_[_pID].laff)
379             {
380                 // update last affiliate
381                 plyr_[_pID].laff = _affID;
382             }
383         }
384 
385         // verify a valid team was selected
386         _team = verifyTeam(_team);
387 
388         // buy core
389         buyCore(_pID, _affID, _team, _eventData_);
390     }
391 
392     /**
393      * @dev essentially the same as buy, but instead of you sending ether
394      * from your wallet, it uses your unwithdrawn earnings.
395      * -functionhash- 0x349cdcac (using ID for affiliate)
396      * -functionhash- 0x82bfc739 (using address for affiliate)
397      * -functionhash- 0x079ce327 (using name for affiliate)
398      * @param _affCode the ID/address/name of the player who gets the affiliate fee
399      * @param _team what team is the player playing for?
400      * @param _eth amount of earnings to use (remainder returned to gen vault)
401      */
402     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
403         isActivated()
404         isHuman()
405         isWithinLimits(_eth)
406         public
407     {
408         // set up our tx event data
409         F3Ddatasets.EventReturns memory _eventData_;
410 
411         // fetch player ID
412         uint256 _pID = pIDxAddr_[msg.sender];
413 
414         // manage affiliate residuals
415         // if no affiliate code was given or player tried to use their own, lolz
416         if (_affCode == 0 || _affCode == _pID)
417         {
418             // use last stored affiliate code
419             _affCode = plyr_[_pID].laff;
420 
421         // if affiliate code was given & its not the same as previously stored
422         } else if (_affCode != plyr_[_pID].laff) {
423             // update last affiliate
424             plyr_[_pID].laff = _affCode;
425         }
426 
427         // verify a valid team was selected
428         _team = verifyTeam(_team);
429 
430         // reload core
431         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
432     }
433 
434     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
435         isActivated()
436         isHuman()
437         isWithinLimits(_eth)
438         public
439     {
440         // set up our tx event data
441         F3Ddatasets.EventReturns memory _eventData_;
442 
443         // fetch player ID
444         uint256 _pID = pIDxAddr_[msg.sender];
445 
446         // manage affiliate residuals
447         uint256 _affID;
448         // if no affiliate code was given or player tried to use their own, lolz
449         if (_affCode == address(0) || _affCode == msg.sender)
450         {
451             // use last stored affiliate code
452             _affID = plyr_[_pID].laff;
453 
454         // if affiliate code was given
455         } else {
456             // get affiliate ID from aff Code
457             _affID = pIDxAddr_[_affCode];
458 
459             // if affID is not the same as previously stored
460             if (_affID != plyr_[_pID].laff)
461             {
462                 // update last affiliate
463                 plyr_[_pID].laff = _affID;
464             }
465         }
466 
467         // verify a valid team was selected
468         _team = verifyTeam(_team);
469 
470         // reload core
471         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
472     }
473 
474     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
475         isActivated()
476         isHuman()
477         isWithinLimits(_eth)
478         public
479     {
480         // set up our tx event data
481         F3Ddatasets.EventReturns memory _eventData_;
482 
483         // fetch player ID
484         uint256 _pID = pIDxAddr_[msg.sender];
485 
486         // manage affiliate residuals
487         uint256 _affID;
488         // if no affiliate code was given or player tried to use their own, lolz
489         if (_affCode == '' || _affCode == plyr_[_pID].name)
490         {
491             // use last stored affiliate code
492             _affID = plyr_[_pID].laff;
493 
494         // if affiliate code was given
495         } else {
496             // get affiliate ID from aff Code
497             _affID = pIDxName_[_affCode];
498 
499             // if affID is not the same as previously stored
500             if (_affID != plyr_[_pID].laff)
501             {
502                 // update last affiliate
503                 plyr_[_pID].laff = _affID;
504             }
505         }
506 
507         // verify a valid team was selected
508         _team = verifyTeam(_team);
509 
510         // reload core
511         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
512     }
513 
514     /**
515      * @dev withdraws all of your earnings.
516      * -functionhash- 0x3ccfd60b
517      */
518     function withdraw()
519         isActivated()
520         isHuman()
521         public
522     {
523         // setup local rID
524         uint256 _rID = rID_;
525 
526         // grab time
527         uint256 _now = now;
528 
529         // fetch player ID
530         uint256 _pID = pIDxAddr_[msg.sender];
531 
532         // setup temp var for player eth
533         uint256 _eth;
534 
535         // check to see if round has ended and no one has run round end yet
536         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
537         {
538             // set up our tx event data
539             F3Ddatasets.EventReturns memory _eventData_;
540 
541             // end the round (distributes pot)
542 			round_[_rID].ended = true;
543             _eventData_ = endRound(_eventData_);
544 
545 			// get their earnings
546             _eth = withdrawEarnings(_pID);
547 
548             // gib moni
549             if (_eth > 0)
550                 plyr_[_pID].addr.transfer(_eth);
551 
552             // build event data
553             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
554             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
555 
556             // fire withdraw and distribute event
557             emit F3Devents.onWithdrawAndDistribute
558             (
559                 msg.sender,
560                 plyr_[_pID].name,
561                 _eth,
562                 _eventData_.compressedData,
563                 _eventData_.compressedIDs,
564                 _eventData_.winnerAddr,
565                 _eventData_.winnerName,
566                 _eventData_.amountWon,
567                 _eventData_.newPot,
568                 _eventData_.P3DAmount,
569                 _eventData_.genAmount
570             );
571 
572         // in any other situation
573         } else {
574             // get their earnings
575             _eth = withdrawEarnings(_pID);
576 
577             // gib moni
578             if (_eth > 0)
579                 plyr_[_pID].addr.transfer(_eth);
580 
581             // fire withdraw event
582             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
583         }
584     }
585 
586     /**
587      * @dev use these to register names.  they are just wrappers that will send the
588      * registration requests to the PlayerBook contract.  So registering here is the
589      * same as registering there.  UI will always display the last name you registered.
590      * but you will still own all previously registered names to use as affiliate
591      * links.
592      * - must pay a registration fee.
593      * - name must be unique
594      * - names will be converted to lowercase
595      * - name cannot start or end with a space
596      * - cannot have more than 1 space in a row
597      * - cannot be only numbers
598      * - cannot start with 0x
599      * - name must be at least 1 char
600      * - max length of 32 characters long
601      * - allowed characters: a-z, 0-9, and space
602      * -functionhash- 0x921dec21 (using ID for affiliate)
603      * -functionhash- 0x3ddd4698 (using address for affiliate)
604      * -functionhash- 0x685ffd83 (using name for affiliate)
605      * @param _nameString players desired name
606      * @param _affCode affiliate ID, address, or name of who referred you
607      * @param _all set to true if you want this to push your info to all games
608      * (this might cost a lot of gas)
609      */
610     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
611         isHuman()
612         public
613         payable
614     {
615         bytes32 _name = _nameString.nameFilter();
616         address _addr = msg.sender;
617         uint256 _paid = msg.value;
618         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
619 
620         uint256 _pID = pIDxAddr_[_addr];
621 
622         // fire event
623         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
624     }
625 
626     function registerNameXaddr(string _nameString, address _affCode, bool _all)
627         isHuman()
628         public
629         payable
630     {
631         bytes32 _name = _nameString.nameFilter();
632         address _addr = msg.sender;
633         uint256 _paid = msg.value;
634         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
635 
636         uint256 _pID = pIDxAddr_[_addr];
637 
638         // fire event
639         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
640     }
641 
642     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
643         isHuman()
644         public
645         payable
646     {
647         bytes32 _name = _nameString.nameFilter();
648         address _addr = msg.sender;
649         uint256 _paid = msg.value;
650         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
651 
652         uint256 _pID = pIDxAddr_[_addr];
653 
654         // fire event
655         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
656     }
657 //==============================================================================
658 //     _  _ _|__|_ _  _ _  .
659 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
660 //=====_|=======================================================================
661     /**
662      * @dev return the price buyer will pay for next 1 individual key.
663      * -functionhash- 0x018a25e8
664      * @return price for next key bought (in wei format)
665      */
666     function getBuyPrice()
667         public
668         view
669         returns(uint256)
670     {
671         // setup local rID
672         uint256 _rID = rID_;
673 
674         // grab time
675         uint256 _now = now;
676 
677         // are we in a round?
678         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
679             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
680         else // rounds over.  need price for new round
681             return ( 75000000000000 ); // init
682     }
683 
684     /**
685      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
686      * provider
687      * -functionhash- 0xc7e284b8
688      * @return time left in seconds
689      */
690     function getTimeLeft()
691         public
692         view
693         returns(uint256)
694     {
695         // setup local rID
696         uint256 _rID = rID_;
697 
698         // grab time
699         uint256 _now = now;
700 
701         if (_now < round_[_rID].end)
702             if (_now > round_[_rID].strt + rndGap_)
703                 return( (round_[_rID].end).sub(_now) );
704             else
705                 return( (round_[_rID].strt + rndGap_).sub(_now) );
706         else
707             return(0);
708     }
709 
710     /**
711      * @dev returns player earnings per vaults
712      * -functionhash- 0x63066434
713      * @return winnings vault
714      * @return general vault
715      * @return affiliate vault
716      */
717     function getPlayerVaults(uint256 _pID)
718         public
719         view
720         returns(uint256 ,uint256, uint256)
721     {
722         // setup local rID
723         uint256 _rID = rID_;
724 
725         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
726         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
727         {
728             // if player is winner
729             if (round_[_rID].plyr == _pID)
730             {
731                 return
732                 (
733                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
734                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
735                     plyr_[_pID].aff
736                 );
737             // if player is not the winner
738             } else {
739                 return
740                 (
741                     plyr_[_pID].win,
742                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
743                     plyr_[_pID].aff
744                 );
745             }
746 
747         // if round is still going on, or round has ended and round end has been ran
748         } else {
749             return
750             (
751                 plyr_[_pID].win,
752                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
753                 plyr_[_pID].aff
754             );
755         }
756     }
757 
758     /**
759      * solidity hates stack limits.  this lets us avoid that hate
760      */
761     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
762         private
763         view
764         returns(uint256)
765     {
766         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
767     }
768 
769     /**
770      * @dev returns all current round info needed for front end
771      * -functionhash- 0x747dff42
772      * @return eth invested during ICO phase
773      * @return round id
774      * @return total keys for round
775      * @return time round ends
776      * @return time round started
777      * @return current pot
778      * @return current team ID & player ID in lead
779      * @return current player in leads address
780      * @return current player in leads name
781      * @return whales eth in for round
782      * @return bears eth in for round
783      * @return sneks eth in for round
784      * @return bulls eth in for round
785      * @return airdrop tracker # & airdrop pot
786      */
787     function getCurrentRoundInfo()
788         public
789         view
790         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
791     {
792         // setup local rID
793         uint256 _rID = rID_;
794 
795         return
796         (
797             round_[_rID].ico,               //0
798             _rID,                           //1
799             round_[_rID].keys,              //2
800             round_[_rID].end,               //3
801             round_[_rID].strt,              //4
802             round_[_rID].pot,               //5
803             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
804             plyr_[round_[_rID].plyr].addr,  //7
805             plyr_[round_[_rID].plyr].name,  //8
806             rndTmEth_[_rID][0],             //9
807             rndTmEth_[_rID][1],             //10
808             rndTmEth_[_rID][2],             //11
809             rndTmEth_[_rID][3],             //12
810             airDropTracker_ + (airDropPot_ * 1000)              //13
811         );
812     }
813 
814     /**
815      * @dev returns player info based on address.  if no address is given, it will
816      * use msg.sender
817      * -functionhash- 0xee0b5d8b
818      * @param _addr address of the player you want to lookup
819      * @return player ID
820      * @return player name
821      * @return keys owned (current round)
822      * @return winnings vault
823      * @return general vault
824      * @return affiliate vault
825 	 * @return player round eth
826      */
827     function getPlayerInfoByAddress(address _addr)
828         public
829         view
830         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
831     {
832         // setup local rID
833         uint256 _rID = rID_;
834 
835         if (_addr == address(0))
836         {
837             _addr == msg.sender;
838         }
839         uint256 _pID = pIDxAddr_[_addr];
840 
841         return
842         (
843             _pID,                               //0
844             plyr_[_pID].name,                   //1
845             plyrRnds_[_pID][_rID].keys,         //2
846             plyr_[_pID].win,                    //3
847             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
848             plyr_[_pID].aff,                    //5
849             plyrRnds_[_pID][_rID].eth           //6
850         );
851     }
852 
853 //==============================================================================
854 //     _ _  _ _   | _  _ . _  .
855 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
856 //=====================_|=======================================================
857     /**
858      * @dev logic runs whenever a buy order is executed.  determines how to handle
859      * incoming eth depending on if we are in an active round or not
860      */
861     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
862         private
863     {
864         // setup local rID
865         uint256 _rID = rID_;
866 
867         // grab time
868         uint256 _now = now;
869 
870         // if round is active
871         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
872         {
873             // call core
874             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
875 
876         // if round is not active
877         } else {
878             // check to see if end round needs to be ran
879             if (_now > round_[_rID].end && round_[_rID].ended == false)
880             {
881                 // end the round (distributes pot) & start new round
882 			    round_[_rID].ended = true;
883                 _eventData_ = endRound(_eventData_);
884 
885                 // build event data
886                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
887                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
888 
889                 // fire buy and distribute event
890                 emit F3Devents.onBuyAndDistribute
891                 (
892                     msg.sender,
893                     plyr_[_pID].name,
894                     msg.value,
895                     _eventData_.compressedData,
896                     _eventData_.compressedIDs,
897                     _eventData_.winnerAddr,
898                     _eventData_.winnerName,
899                     _eventData_.amountWon,
900                     _eventData_.newPot,
901                     _eventData_.P3DAmount,
902                     _eventData_.genAmount
903                 );
904             }
905 
906             // put eth in players vault
907             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
908         }
909     }
910 
911     /**
912      * @dev logic runs whenever a reload order is executed.  determines how to handle
913      * incoming eth depending on if we are in an active round or not
914      */
915     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
916         private
917     {
918         // setup local rID
919         uint256 _rID = rID_;
920 
921         // grab time
922         uint256 _now = now;
923 
924         // if round is active
925         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
926         {
927             // get earnings from all vaults and return unused to gen vault
928             // because we use a custom safemath library.  this will throw if player
929             // tried to spend more eth than they have.
930             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
931 
932             // call core
933             core(_rID, _pID, _eth, _affID, _team, _eventData_);
934 
935         // if round is not active and end round needs to be ran
936         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
937             // end the round (distributes pot) & start new round
938             round_[_rID].ended = true;
939             _eventData_ = endRound(_eventData_);
940 
941             // build event data
942             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
943             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
944 
945             // fire buy and distribute event
946             emit F3Devents.onReLoadAndDistribute
947             (
948                 msg.sender,
949                 plyr_[_pID].name,
950                 _eventData_.compressedData,
951                 _eventData_.compressedIDs,
952                 _eventData_.winnerAddr,
953                 _eventData_.winnerName,
954                 _eventData_.amountWon,
955                 _eventData_.newPot,
956                 _eventData_.P3DAmount,
957                 _eventData_.genAmount
958             );
959         }
960     }
961 
962     /**
963      * @dev this is the core logic for any buy/reload that happens while a round
964      * is live.
965      */
966     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
967         private
968     {
969         // if player is new to round
970         if (plyrRnds_[_pID][_rID].keys == 0)
971             _eventData_ = managePlayer(_pID, _eventData_);
972 
973         // early round eth limiter
974         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
975         {
976             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
977             uint256 _refund = _eth.sub(_availableLimit);
978             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
979             _eth = _availableLimit;
980         }
981 
982         // if eth left is greater than min eth allowed (sorry no pocket lint)
983         if (_eth > 1000000000)
984         {
985 
986             // mint the new keys
987             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
988 
989             // if they bought at least 1 whole key
990             if (_keys >= 1000000000000000000)
991             {
992             updateTimer(_keys, _rID);
993 
994             // set new leaders
995             if (round_[_rID].plyr != _pID)
996                 round_[_rID].plyr = _pID;
997             if (round_[_rID].team != _team)
998                 round_[_rID].team = _team;
999 
1000             // set the new leader bool to true
1001             _eventData_.compressedData = _eventData_.compressedData + 100;
1002         }
1003 
1004             // manage airdrops
1005             if (_eth >= 100000000000000000)
1006             {
1007             airDropTracker_++;
1008             if (airdrop() == true)
1009             {
1010                 // gib muni
1011                 uint256 _prize;
1012                 if (_eth >= 10000000000000000000)
1013                 {
1014                     // calculate prize and give it to winner
1015                     _prize = ((airDropPot_).mul(75)) / 100;
1016                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1017 
1018                     // adjust airDropPot
1019                     airDropPot_ = (airDropPot_).sub(_prize);
1020 
1021                     // let event know a tier 3 prize was won
1022                     _eventData_.compressedData += 300000000000000000000000000000000;
1023                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1024                     // calculate prize and give it to winner
1025                     _prize = ((airDropPot_).mul(50)) / 100;
1026                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1027 
1028                     // adjust airDropPot
1029                     airDropPot_ = (airDropPot_).sub(_prize);
1030 
1031                     // let event know a tier 2 prize was won
1032                     _eventData_.compressedData += 200000000000000000000000000000000;
1033                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1034                     // calculate prize and give it to winner
1035                     _prize = ((airDropPot_).mul(25)) / 100;
1036                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1037 
1038                     // adjust airDropPot
1039                     airDropPot_ = (airDropPot_).sub(_prize);
1040 
1041                     // let event know a tier 3 prize was won
1042                     _eventData_.compressedData += 300000000000000000000000000000000;
1043                 }
1044                 // set airdrop happened bool to true
1045                 _eventData_.compressedData += 10000000000000000000000000000000;
1046                 // let event know how much was won
1047                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1048 
1049                 // reset air drop tracker
1050                 airDropTracker_ = 0;
1051             }
1052         }
1053 
1054             // store the air drop tracker number (number of buys since last airdrop)
1055             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1056 
1057             // update player
1058             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1059             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1060 
1061             // update round
1062             round_[_rID].keys = _keys.add(round_[_rID].keys);
1063             round_[_rID].eth = _eth.add(round_[_rID].eth);
1064             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1065 
1066             // distribute eth
1067             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1068             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1069 
1070             // call end tx function to fire end tx event.
1071 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1072         }
1073     }
1074 //==============================================================================
1075 //     _ _ | _   | _ _|_ _  _ _  .
1076 //    (_(_||(_|_||(_| | (_)| _\  .
1077 //==============================================================================
1078     /**
1079      * @dev calculates unmasked earnings (just calculates, does not update mask)
1080      * @return earnings in wei format
1081      */
1082     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1083         private
1084         view
1085         returns(uint256)
1086     {
1087         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1088     }
1089 
1090     /**
1091      * @dev returns the amount of keys you would get given an amount of eth.
1092      * -functionhash- 0xce89c80c
1093      * @param _rID round ID you want price for
1094      * @param _eth amount of eth sent in
1095      * @return keys received
1096      */
1097     function calcKeysReceived(uint256 _rID, uint256 _eth)
1098         public
1099         view
1100         returns(uint256)
1101     {
1102         // grab time
1103         uint256 _now = now;
1104 
1105         // are we in a round?
1106         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1107             return ( (round_[_rID].eth).keysRec(_eth) );
1108         else // rounds over.  need keys for new round
1109             return ( (_eth).keys() );
1110     }
1111 
1112     /**
1113      * @dev returns current eth price for X keys.
1114      * -functionhash- 0xcf808000
1115      * @param _keys number of keys desired (in 18 decimal format)
1116      * @return amount of eth needed to send
1117      */
1118     function iWantXKeys(uint256 _keys)
1119         public
1120         view
1121         returns(uint256)
1122     {
1123         // setup local rID
1124         uint256 _rID = rID_;
1125 
1126         // grab time
1127         uint256 _now = now;
1128 
1129         // are we in a round?
1130         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1131             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1132         else // rounds over.  need price for new round
1133             return ( (_keys).eth() );
1134     }
1135 //==============================================================================
1136 //    _|_ _  _ | _  .
1137 //     | (_)(_)|_\  .
1138 //==============================================================================
1139     /**
1140 	 * @dev receives name/player info from names contract
1141      */
1142     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1143         external
1144     {
1145         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1146         if (pIDxAddr_[_addr] != _pID)
1147             pIDxAddr_[_addr] = _pID;
1148         if (pIDxName_[_name] != _pID)
1149             pIDxName_[_name] = _pID;
1150         if (plyr_[_pID].addr != _addr)
1151             plyr_[_pID].addr = _addr;
1152         if (plyr_[_pID].name != _name)
1153             plyr_[_pID].name = _name;
1154         if (plyr_[_pID].laff != _laff)
1155             plyr_[_pID].laff = _laff;
1156         if (plyrNames_[_pID][_name] == false)
1157             plyrNames_[_pID][_name] = true;
1158     }
1159 
1160     /**
1161      * @dev receives entire player name list
1162      */
1163     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1164         external
1165     {
1166         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1167         if(plyrNames_[_pID][_name] == false)
1168             plyrNames_[_pID][_name] = true;
1169     }
1170 
1171     /**
1172      * @dev gets existing or registers new pID.  use this when a player may be new
1173      * @return pID
1174      */
1175     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1176         private
1177         returns (F3Ddatasets.EventReturns)
1178     {
1179         uint256 _pID = pIDxAddr_[msg.sender];
1180         // if player is new to this version of fomo3d
1181         if (_pID == 0)
1182         {
1183             // grab their player ID, name and last aff ID, from player names contract
1184             _pID = PlayerBook.getPlayerID(msg.sender);
1185             bytes32 _name = PlayerBook.getPlayerName(_pID);
1186             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1187 
1188             // set up player account
1189             pIDxAddr_[msg.sender] = _pID;
1190             plyr_[_pID].addr = msg.sender;
1191 
1192             if (_name != "")
1193             {
1194                 pIDxName_[_name] = _pID;
1195                 plyr_[_pID].name = _name;
1196                 plyrNames_[_pID][_name] = true;
1197             }
1198 
1199             if (_laff != 0 && _laff != _pID)
1200                 plyr_[_pID].laff = _laff;
1201 
1202             // set the new player bool to true
1203             _eventData_.compressedData = _eventData_.compressedData + 1;
1204         }
1205         return (_eventData_);
1206     }
1207 
1208     /**
1209      * @dev checks to make sure user picked a valid team.  if not sets team
1210      * to default (sneks)
1211      */
1212     function verifyTeam(uint256 _team)
1213         private
1214         pure
1215         returns (uint256)
1216     {
1217         if (_team < 0 || _team > 3)
1218             return(2);
1219         else
1220             return(_team);
1221     }
1222 
1223     /**
1224      * @dev decides if round end needs to be run & new round started.  and if
1225      * player unmasked earnings from previously played rounds need to be moved.
1226      */
1227     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1228         private
1229         returns (F3Ddatasets.EventReturns)
1230     {
1231         // if player has played a previous round, move their unmasked earnings
1232         // from that round to gen vault.
1233         if (plyr_[_pID].lrnd != 0)
1234             updateGenVault(_pID, plyr_[_pID].lrnd);
1235 
1236         // update player's last round played
1237         plyr_[_pID].lrnd = rID_;
1238 
1239         // set the joined round bool to true
1240         _eventData_.compressedData = _eventData_.compressedData + 10;
1241 
1242         return(_eventData_);
1243     }
1244 
1245     /**
1246      * @dev ends the round. manages paying out winner/splitting up pot
1247      */
1248     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1249         private
1250         returns (F3Ddatasets.EventReturns)
1251     {
1252         // setup local rID
1253         uint256 _rID = rID_;
1254 
1255         // grab our winning player and team id's
1256         uint256 _winPID = round_[_rID].plyr;
1257         uint256 _winTID = round_[_rID].team;
1258 
1259         // grab our pot amount
1260         uint256 _pot = round_[_rID].pot;
1261 
1262         // calculate our winner share, community rewards, gen share,
1263         // p3d share, and amount reserved for next pot
1264         uint256 _win = (_pot.mul(48)) / 100;
1265         uint256 _com = (_pot / 50);
1266         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1267         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1268         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1269 
1270         // calculate ppt for round mask
1271         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1272         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1273         if (_dust > 0)
1274         {
1275             _gen = _gen.sub(_dust);
1276             _res = _res.add(_dust);
1277         }
1278 
1279         // pay our winner
1280         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1281 
1282         // community rewards
1283         _com = _com.add(_p3d.sub(_p3d / 2));
1284         admin.transfer(_com);
1285 
1286         _res = _res.add(_p3d / 2);
1287 
1288         // distribute gen portion to key holders
1289         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1290 
1291         // prepare event data
1292         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1293         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1294         _eventData_.winnerAddr = plyr_[_winPID].addr;
1295         _eventData_.winnerName = plyr_[_winPID].name;
1296         _eventData_.amountWon = _win;
1297         _eventData_.genAmount = _gen;
1298         _eventData_.P3DAmount = _p3d;
1299         _eventData_.newPot = _res;
1300 
1301         // start next round
1302         rID_++;
1303         _rID++;
1304         round_[_rID].strt = now;
1305         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1306         round_[_rID].pot = _res;
1307 
1308         return(_eventData_);
1309     }
1310 
1311     /**
1312      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1313      */
1314     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1315         private
1316     {
1317         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1318         if (_earnings > 0)
1319         {
1320             // put in gen vault
1321             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1322             // zero out their earnings by updating mask
1323             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1324         }
1325     }
1326 
1327     /**
1328      * @dev updates round timer based on number of whole keys bought.
1329      */
1330     function updateTimer(uint256 _keys, uint256 _rID)
1331         private
1332     {
1333         // grab time
1334         uint256 _now = now;
1335 
1336         // calculate time based on number of keys bought
1337         uint256 _newTime;
1338         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1339             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1340         else
1341             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1342 
1343         // compare to max and set new end time
1344         if (_newTime < (rndMax_).add(_now))
1345             round_[_rID].end = _newTime;
1346         else
1347             round_[_rID].end = rndMax_.add(_now);
1348     }
1349 
1350     /**
1351      * @dev generates a random number between 0-99 and checks to see if thats
1352      * resulted in an airdrop win
1353      * @return do we have a winner?
1354      */
1355     function airdrop()
1356         private
1357         view
1358         returns(bool)
1359     {
1360         uint256 seed = uint256(keccak256(abi.encodePacked(
1361 
1362             (block.timestamp).add
1363             (block.difficulty).add
1364             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1365             (block.gaslimit).add
1366             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1367             (block.number)
1368 
1369         )));
1370         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1371             return(true);
1372         else
1373             return(false);
1374     }
1375 
1376     /**
1377      * @dev distributes eth based on fees to com, aff, and p3d
1378      */
1379     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1380         private
1381         returns(F3Ddatasets.EventReturns)
1382     {
1383         // pay 3% out to community rewards
1384         uint256 _p1 = _eth / 100;
1385         uint256 _com = _eth / 50;
1386         _com = _com.add(_p1);
1387 
1388         uint256 _p3d;
1389         if (!address(admin).call.value(_com)())
1390         {
1391             // This ensures Team Just cannot influence the outcome of FoMo3D with
1392             // bank migrations by breaking outgoing transactions.
1393             // Something we would never do. But that's not the point.
1394             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1395             // highest belief that everything we create should be trustless.
1396             // Team JUST, The name you shouldn't have to trust.
1397             _p3d = _com;
1398             _com = 0;
1399         }
1400 
1401 
1402         // distribute share to affiliate
1403         //uint256 _aff = _eth / 10;
1404 
1405         // decide what to do with affiliate share of fees
1406         // affiliate must not be self, and must have a name registered
1407         /*if (_affID != _pID && plyr_[_affID].name != '') {
1408             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1409             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1410         } else {
1411             _p3d = _p3d.add(_aff);
1412         }*/
1413         uint256 _invest_return = 0;
1414         _invest_return = distributeInvest(_pID, _eth, _affID);
1415 
1416         _p3d = _p3d.add(_invest_return);
1417 
1418         // pay out p3d
1419         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1420         if (_p3d > 0)
1421         {
1422             // deposit to divies contract
1423             uint256 _potAmount = _p3d / 2;
1424 
1425             admin.transfer(_p3d.sub(_potAmount));
1426 
1427             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1428 
1429             // set up event data
1430             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1431         }
1432 
1433         return(_eventData_);
1434     }
1435 
1436     /**
1437      * @dev distributes eth based on fees to com, aff, and p3d
1438      */
1439     function distributeInvest(uint256 _pID, uint256 _aff_eth, uint256 _affID)
1440         private
1441         returns(uint256)
1442     {
1443 
1444         uint256 _p3d;
1445         uint256 _aff;
1446         uint256 _aff_2;
1447         uint256 _aff_3;
1448         uint256 _affID_1;
1449         uint256 _affID_2;
1450         uint256 _affID_3;
1451 
1452         _p3d = 0;
1453 
1454         // distribute share to affiliate
1455         _aff = _aff_eth / 10;
1456         _aff_2 = _aff_eth / 20;
1457         _aff_3 = _aff_eth / 10;
1458 
1459         _affID_1 = _affID;// up one member
1460         _affID_2 = plyr_[_affID_1].laff;// up two member
1461         _affID_3 = plyr_[_affID_2].laff;// up three member
1462 
1463         // decide what to do with affiliate share of fees
1464         // affiliate must not be self, and must have a name registered
1465         if (_affID != _pID && plyr_[_affID].name != '') {
1466             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1467             //emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1468         } else {
1469             _p3d = _p3d.add(_aff);
1470         }
1471 
1472         if (_affID_2 != _pID && _affID_2 != _affID && plyr_[_affID_2].name != '') {
1473             plyr_[_affID_2].aff = _aff_2.add(plyr_[_affID_2].aff);
1474         } else {
1475             _p3d = _p3d.add(_aff_2);
1476         }
1477 
1478         if (_affID_3 != _pID &&  _affID_3 != _affID && plyr_[_affID_3].name != '') {
1479             plyr_[_affID_3].aff = _aff_3.add(plyr_[_affID_3].aff);
1480         } else {
1481             _p3d = _p3d.add(_aff_3);
1482         }
1483 
1484 
1485 
1486         return _p3d;
1487     }
1488 
1489     function potSwap()
1490         external
1491         payable
1492     {
1493         // setup local rID
1494         uint256 _rID = rID_ + 1;
1495 
1496         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1497         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1498     }
1499 
1500     /**
1501      * @dev distributes eth based on fees to gen and pot
1502      */
1503     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1504         private
1505         returns(F3Ddatasets.EventReturns)
1506     {
1507         // calculate gen share
1508         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1509 
1510         // toss 1% into airdrop pot
1511         uint256 _air = (_eth / 100);
1512         airDropPot_ = airDropPot_.add(_air);
1513 
1514         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1515         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1516 
1517         // calculate pot
1518         uint256 _pot = _eth.sub(_gen);
1519 
1520         // distribute gen share (thats what updateMasks() does) and adjust
1521         // balances for dust.
1522         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1523         if (_dust > 0)
1524             _gen = _gen.sub(_dust);
1525 
1526         // add eth to pot
1527         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1528 
1529         // set up event data
1530         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1531         _eventData_.potAmount = _pot;
1532 
1533         return(_eventData_);
1534     }
1535 
1536     /**
1537      * @dev updates masks for round and player when keys are bought
1538      * @return dust left over
1539      */
1540     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1541         private
1542         returns(uint256)
1543     {
1544         /* MASKING NOTES
1545             earnings masks are a tricky thing for people to wrap their minds around.
1546             the basic thing to understand here.  is were going to have a global
1547             tracker based on profit per share for each round, that increases in
1548             relevant proportion to the increase in share supply.
1549 
1550             the player will have an additional mask that basically says "based
1551             on the rounds mask, my shares, and how much i've already withdrawn,
1552             how much is still owed to me?"
1553         */
1554 
1555         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1556         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1557         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1558 
1559         // calculate player earning from their own buy (only based on the keys
1560         // they just bought).  & update player earnings mask
1561         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1562         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1563 
1564         // calculate & return dust
1565         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1566     }
1567 
1568     /**
1569      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1570      * @return earnings in wei format
1571      */
1572     function withdrawEarnings(uint256 _pID)
1573         private
1574         returns(uint256)
1575     {
1576         // update gen vault
1577         updateGenVault(_pID, plyr_[_pID].lrnd);
1578 
1579         // from vaults
1580         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1581         if (_earnings > 0)
1582         {
1583             plyr_[_pID].win = 0;
1584             plyr_[_pID].gen = 0;
1585             plyr_[_pID].aff = 0;
1586         }
1587 
1588         return(_earnings);
1589     }
1590 
1591     /**
1592      * @dev prepares compression data and fires event for buy or reload tx's
1593      */
1594     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1595         private
1596     {
1597         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1598         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1599 
1600         emit F3Devents.onEndTx
1601         (
1602             _eventData_.compressedData,
1603             _eventData_.compressedIDs,
1604             plyr_[_pID].name,
1605             msg.sender,
1606             _eth,
1607             _keys,
1608             _eventData_.winnerAddr,
1609             _eventData_.winnerName,
1610             _eventData_.amountWon,
1611             _eventData_.newPot,
1612             _eventData_.P3DAmount,
1613             _eventData_.genAmount,
1614             _eventData_.potAmount,
1615             airDropPot_
1616         );
1617     }
1618 //==============================================================================
1619 //    (~ _  _    _._|_    .
1620 //    _)(/_(_|_|| | | \/  .
1621 //====================/=========================================================
1622     /** upon contract deploy, it will be deactivated.  this is a one time
1623      * use function that will activate the contract.  we do this so devs
1624      * have time to set things up on the web end                            **/
1625     bool public activated_ = false;
1626     function activate()
1627         public
1628     {
1629         // only team just can activate
1630         // require(msg.sender == admin, "only admin can activate"); // erik
1631 
1632 
1633         // can only be ran once
1634         require(activated_ == false, "OK3D already activated");
1635 
1636         // activate the contract
1637         activated_ = true;
1638 
1639         // lets start first round
1640         rID_ = 1;
1641             round_[1].strt = now + rndExtra_ - rndGap_;
1642             round_[1].end = now + rndInit_ + rndExtra_;
1643     }
1644 }
1645 
1646 //==============================================================================
1647 //   __|_ _    __|_ _  .
1648 //  _\ | | |_|(_ | _\  .
1649 //==============================================================================
1650 library F3Ddatasets {
1651     //compressedData key
1652     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1653         // 0 - new player (bool)
1654         // 1 - joined round (bool)
1655         // 2 - new  leader (bool)
1656         // 3-5 - air drop tracker (uint 0-999)
1657         // 6-16 - round end time
1658         // 17 - winnerTeam
1659         // 18 - 28 timestamp
1660         // 29 - team
1661         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1662         // 31 - airdrop happened bool
1663         // 32 - airdrop tier
1664         // 33 - airdrop amount won
1665     //compressedIDs key
1666     // [77-52][51-26][25-0]
1667         // 0-25 - pID
1668         // 26-51 - winPID
1669         // 52-77 - rID
1670     struct EventReturns {
1671         uint256 compressedData;
1672         uint256 compressedIDs;
1673         address winnerAddr;         // winner address
1674         bytes32 winnerName;         // winner name
1675         uint256 amountWon;          // amount won
1676         uint256 newPot;             // amount in new pot
1677         uint256 P3DAmount;          // amount distributed to p3d
1678         uint256 genAmount;          // amount distributed to gen
1679         uint256 potAmount;          // amount added to pot
1680     }
1681     struct Player {
1682         address addr;   // player address
1683         bytes32 name;   // player name
1684         uint256 win;    // winnings vault
1685         uint256 gen;    // general vault
1686         uint256 aff;    // affiliate vault
1687         uint256 lrnd;   // last round played
1688         uint256 laff;   // last affiliate id used
1689     }
1690     struct PlayerRounds {
1691         uint256 eth;    // eth player has added to round (used for eth limiter)
1692         uint256 keys;   // keys
1693         uint256 mask;   // player mask
1694         uint256 ico;    // ICO phase investment
1695     }
1696     struct Round {
1697         uint256 plyr;   // pID of player in lead
1698         uint256 team;   // tID of team in lead
1699         uint256 end;    // time ends/ended
1700         bool ended;     // has round end function been ran
1701         uint256 strt;   // time round started
1702         uint256 keys;   // keys
1703         uint256 eth;    // total eth in
1704         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1705         uint256 mask;   // global mask
1706         uint256 ico;    // total eth sent in during ICO phase
1707         uint256 icoGen; // total eth for gen during ICO phase
1708         uint256 icoAvg; // average key price for ICO phase
1709     }
1710     struct TeamFee {
1711         uint256 gen;    // % of buy in thats paid to key holders of current round
1712         uint256 p3d;    // % of buy in thats paid to p3d holders
1713     }
1714     struct PotSplit {
1715         uint256 gen;    // % of pot thats paid to key holders of current round
1716         uint256 p3d;    // % of pot thats paid to p3d holders
1717     }
1718 }
1719 
1720 //==============================================================================
1721 //  |  _      _ _ | _  .
1722 //  |<(/_\/  (_(_||(_  .
1723 //=======/======================================================================
1724 library F3DKeysCalcShort {
1725     using SafeMath for *;
1726     /**
1727      * @dev calculates number of keys received given X eth
1728      * @param _curEth current amount of eth in contract
1729      * @param _newEth eth being spent
1730      * @return amount of ticket purchased
1731      */
1732     function keysRec(uint256 _curEth, uint256 _newEth)
1733         internal
1734         pure
1735         returns (uint256)
1736     {
1737         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1738     }
1739 
1740     /**
1741      * @dev calculates amount of eth received if you sold X keys
1742      * @param _curKeys current amount of keys that exist
1743      * @param _sellKeys amount of keys you wish to sell
1744      * @return amount of eth received
1745      */
1746     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1747         internal
1748         pure
1749         returns (uint256)
1750     {
1751         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1752     }
1753 
1754     /**
1755      * @dev calculates how many keys would exist with given an amount of eth
1756      * @param _eth eth "in contract"
1757      * @return number of keys that would exist
1758      */
1759     function keys(uint256 _eth)
1760         internal
1761         pure
1762         returns(uint256)
1763     {
1764         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1765     }
1766 
1767     /**
1768      * @dev calculates how much eth would be in contract given a number of keys
1769      * @param _keys number of keys "in contract"
1770      * @return eth that would exists
1771      */
1772     function eth(uint256 _keys)
1773         internal
1774         pure
1775         returns(uint256)
1776     {
1777         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1778     }
1779 }
1780 
1781 //==============================================================================
1782 //  . _ _|_ _  _ |` _  _ _  _  .
1783 //  || | | (/_| ~|~(_|(_(/__\  .
1784 //==============================================================================
1785 
1786 interface PlayerBookInterface {
1787     function getPlayerID(address _addr) external returns (uint256);
1788     function getPlayerName(uint256 _pID) external view returns (bytes32);
1789     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1790     function getPlayerAddr(uint256 _pID) external view returns (address);
1791     function getNameFee() external view returns (uint256);
1792     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1793     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1794     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1795 }
1796 
1797 /**
1798 * @title -Name Filter- v0.1.9
1799 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1800 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1801 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1802 *                                  _____                      _____
1803 *                                 (, /     /)       /) /)    (, /      /)          /)
1804 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1805 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1806 *          ┴ ┴                /   /          .-/ _____   (__ /
1807 *                            (__ /          (_/ (, /                                      /)™
1808 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1809 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1810 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1811 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1812 *              _       __    _      ____      ____  _   _    _____  ____  ___
1813 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1814 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1815 *
1816 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1817 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1818 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1819 */
1820 
1821 library NameFilter {
1822     /**
1823      * @dev filters name strings
1824      * -converts uppercase to lower case.
1825      * -makes sure it does not start/end with a space
1826      * -makes sure it does not contain multiple spaces in a row
1827      * -cannot be only numbers
1828      * -cannot start with 0x
1829      * -restricts characters to A-Z, a-z, 0-9, and space.
1830      * @return reprocessed string in bytes32 format
1831      */
1832     function nameFilter(string _input)
1833         internal
1834         pure
1835         returns(bytes32)
1836     {
1837         bytes memory _temp = bytes(_input);
1838         uint256 _length = _temp.length;
1839 
1840         //sorry limited to 32 characters
1841         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1842         // make sure it doesnt start with or end with space
1843         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1844         // make sure first two characters are not 0x
1845         if (_temp[0] == 0x30)
1846         {
1847             require(_temp[1] != 0x78, "string cannot start with 0x");
1848             require(_temp[1] != 0x58, "string cannot start with 0X");
1849         }
1850 
1851         // create a bool to track if we have a non number character
1852         bool _hasNonNumber;
1853 
1854         // convert & check
1855         for (uint256 i = 0; i < _length; i++)
1856         {
1857             // if its uppercase A-Z
1858             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1859             {
1860                 // convert to lower case a-z
1861                 _temp[i] = byte(uint(_temp[i]) + 32);
1862 
1863                 // we have a non number
1864                 if (_hasNonNumber == false)
1865                     _hasNonNumber = true;
1866             } else {
1867                 require
1868                 (
1869                     // require character is a space
1870                     _temp[i] == 0x20 ||
1871                     // OR lowercase a-z
1872                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1873                     // or 0-9
1874                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1875                     "string contains invalid characters"
1876                 );
1877                 // make sure theres not 2x spaces in a row
1878                 if (_temp[i] == 0x20)
1879                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1880 
1881                 // see if we have a character other than a number
1882                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1883                     _hasNonNumber = true;
1884             }
1885         }
1886 
1887         require(_hasNonNumber == true, "string cannot be only numbers");
1888 
1889         bytes32 _ret;
1890         assembly {
1891             _ret := mload(add(_temp, 32))
1892         }
1893         return (_ret);
1894     }
1895 }
1896 
1897 /**
1898  * @title SafeMath v0.1.9
1899  * @dev Math operations with safety checks that throw on error
1900  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1901  * - added sqrt
1902  * - added sq
1903  * - added pwr
1904  * - changed asserts to requires with error log outputs
1905  * - removed div, its useless
1906  */
1907 library SafeMath {
1908 
1909     /**
1910     * @dev Multiplies two numbers, throws on overflow.
1911     */
1912     function mul(uint256 a, uint256 b)
1913         internal
1914         pure
1915         returns (uint256 c)
1916     {
1917         if (a == 0) {
1918             return 0;
1919         }
1920         c = a * b;
1921         require(c / a == b, "SafeMath mul failed");
1922         return c;
1923     }
1924 
1925     /**
1926     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1927     */
1928     function sub(uint256 a, uint256 b)
1929         internal
1930         pure
1931         returns (uint256)
1932     {
1933         require(b <= a, "SafeMath sub failed");
1934         return a - b;
1935     }
1936 
1937     /**
1938     * @dev Adds two numbers, throws on overflow.
1939     */
1940     function add(uint256 a, uint256 b)
1941         internal
1942         pure
1943         returns (uint256 c)
1944     {
1945         c = a + b;
1946         require(c >= a, "SafeMath add failed");
1947         return c;
1948     }
1949 
1950     /**
1951      * @dev gives square root of given x.
1952      */
1953     function sqrt(uint256 x)
1954         internal
1955         pure
1956         returns (uint256 y)
1957     {
1958         uint256 z = ((add(x,1)) / 2);
1959         y = x;
1960         while (z < y)
1961         {
1962             y = z;
1963             z = ((add((x / z),z)) / 2);
1964         }
1965     }
1966 
1967     /**
1968      * @dev gives square. multiplies x by x
1969      */
1970     function sq(uint256 x)
1971         internal
1972         pure
1973         returns (uint256)
1974     {
1975         return (mul(x,x));
1976     }
1977 
1978     /**
1979      * @dev x to the power of y
1980      */
1981     function pwr(uint256 x, uint256 y)
1982         internal
1983         pure
1984         returns (uint256)
1985     {
1986         if (x==0)
1987             return (0);
1988         else if (y==0)
1989             return (1);
1990         else
1991         {
1992             uint256 z = x;
1993             for (uint256 i=1; i < y; i++)
1994                 z = mul(z,x);
1995             return (z);
1996         }
1997     }
1998 }