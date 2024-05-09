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
37     // fired whenever theres a withdraw
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
121 contract modularPlus is F3Devents {}
122 
123 contract FoMo3DPlus is modularPlus {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcShort for uint256;
127 
128     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x00F6b8836492f8332D17B1496828d2bEE71ad511DA);
129 
130     //==============================================================================
131     //     _ _  _  |`. _     _ _ |_ | _  _  .
132     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133     //=================_|===========================================================
134     address private admin = msg.sender;
135     string constant public name = "FOMO Plus";
136     string constant public symbol = "fomoplus";
137     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
138     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
139     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
140     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
141     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
142     //==============================================================================
143     //     _| _ _|_ _    _ _ _|_    _   .
144     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
145     //=============================|================================================
146     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
147     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
148     uint256 public rID_;    // round id number / total rounds that have happened
149     uint256 public pID_;
150     //****************
151     // PLAYER DATA
152     //****************
153     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
154     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
155     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
156     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID =>QrID => data) player round data by player id & round id
157     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
158     //****************
159     // ROUND DATA
160     //****************
161     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
162     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
163     //****************
164     // TEAM FEE DATA
165     //****************
166     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
167     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
168     //==============================================================================
169     //     _ _  _  __|_ _    __|_ _  _  .
170     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
171     //==============================================================================
172     constructor()
173     public
174     {
175         // Team allocation structures
176         // 0 = whales
177         // 1 = bears
178         // 2 = sneks
179         // 3 = bulls
180 
181         // Team allocation percentages
182         // (F3D, P3D) + (Pot , Referrals, Community)
183         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
184         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
185         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
186         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
187         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
188 
189         // how to split up the final pot based on which team was picked
190         // (F3D, P3D)
191         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
192         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
193         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
194         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
195     }
196     //==============================================================================
197     //     _ _  _  _|. |`. _  _ _  .
198     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
199     //==============================================================================
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
230     //==============================================================================
231     //     _    |_ |. _   |`    _  __|_. _  _  _  .
232     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
233     //====|=========================================================================
234     /**
235      * @dev emergency buy uses last stored affiliate ID and team snek
236      */
237     function()
238     isActivated()
239     isHuman()
240     isWithinLimits(msg.value)
241     public
242     payable
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
263     isActivated()
264     isHuman()
265     isWithinLimits(msg.value)
266     public
267     payable
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
282             // if affiliate code was given & its not the same as previously stored
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
296     isActivated()
297     isHuman()
298     isWithinLimits(msg.value)
299     public
300     payable
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
316             // if affiliate code was given
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
337     isActivated()
338     isHuman()
339     isWithinLimits(msg.value)
340     public
341     payable
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
357             // if affiliate code was given
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
388     isActivated()
389     isHuman()
390     isWithinLimits(_eth)
391     public
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
406             // if affiliate code was given & its not the same as previously stored
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
420     isActivated()
421     isHuman()
422     isWithinLimits(_eth)
423     public
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
439             // if affiliate code was given
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
460     isActivated()
461     isHuman()
462     isWithinLimits(_eth)
463     public
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
479             // if affiliate code was given
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
504     isActivated()
505     isHuman()
506     public
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
527             round_[_rID].ended = true;
528             _eventData_ = endRound(_eventData_);
529 
530             // get their earnings
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
557             // in any other situation
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
596     isHuman()
597     public
598     payable
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
612     isHuman()
613     public
614     payable
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
628     isHuman()
629     public
630     payable
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
642     //==============================================================================
643     //     _  _ _|__|_ _  _ _  .
644     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
645     //=====_|=======================================================================
646     /**
647      * @dev return the price buyer will pay for next 1 individual key.
648      * -functionhash- 0x018a25e8
649      * @return price for next key bought (in wei format)
650      */
651     function getBuyPrice()
652     public
653     view
654     returns(uint256)
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
676     public
677     view
678     returns(uint256)
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
703     public
704     view
705     returns(uint256 ,uint256, uint256)
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
718                 (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
719                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
720                 plyr_[_pID].aff
721                 );
722                 // if player is not the winner
723             } else {
724                 return
725                 (
726                 plyr_[_pID].win,
727                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
728                 plyr_[_pID].aff
729                 );
730             }
731 
732             // if round is still going on, or round has ended and round end has been ran
733         } else {
734             return
735             (
736             plyr_[_pID].win,
737             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
738             plyr_[_pID].aff
739             );
740         }
741     }
742 
743     /**
744      * solidity hates stack limits.  this lets us avoid that hate
745      */
746     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
747     private
748     view
749     returns(uint256)
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
773     public
774     view
775     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
776     {
777         // setup local rID
778         uint256 _rID = rID_;
779 
780         return
781         (
782         round_[_rID].ico,               //0
783         _rID,                           //1
784         round_[_rID].keys,              //2
785         round_[_rID].end,               //3
786         round_[_rID].strt,              //4
787         round_[_rID].pot,               //5
788         (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
789         plyr_[round_[_rID].plyr].addr,  //7
790         plyr_[round_[_rID].plyr].name,  //8
791         rndTmEth_[_rID][0],             //9
792         rndTmEth_[_rID][1],             //10
793         rndTmEth_[_rID][2],             //11
794         rndTmEth_[_rID][3],             //12
795         airDropTracker_ + (airDropPot_ * 1000)              //13
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
813     public
814     view
815     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
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
828         _pID,                               //0
829         plyr_[_pID].name,                   //1
830         plyrRnds_[_pID][_rID].keys,         //2
831         plyr_[_pID].win,                    //3
832         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
833         plyr_[_pID].aff,                    //5
834         plyrRnds_[_pID][_rID].eth           //6
835         );
836     }
837 
838     //==============================================================================
839     //     _ _  _ _   | _  _ . _  .
840     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
841     //=====================_|=======================================================
842     /**
843      * @dev logic runs whenever a buy order is executed.  determines how to handle
844      * incoming eth depending on if we are in an active round or not
845      */
846     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
847     private
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
861             // if round is not active
862         } else {
863             // check to see if end round needs to be ran
864             if (_now > round_[_rID].end && round_[_rID].ended == false)
865             {
866                 // end the round (distributes pot) & start new round
867                 round_[_rID].ended = true;
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
901     private
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
920             // if round is not active and end round needs to be ran
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
952     private
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
977                 updateTimer(_keys, _rID);
978 
979                 // set new leaders
980                 if (round_[_rID].plyr != _pID)
981                     round_[_rID].plyr = _pID;
982                 if (round_[_rID].team != _team)
983                     round_[_rID].team = _team;
984 
985                 // set the new leader bool to true
986                 _eventData_.compressedData = _eventData_.compressedData + 100;
987             }
988 
989             // manage airdrops
990             if (_eth >= 100000000000000000)
991             {
992                 airDropTracker_++;
993                 if (airdrop() == true)
994                 {
995                     // gib muni
996                     uint256 _prize;
997                     if (_eth >= 10000000000000000000)
998                     {
999                         // calculate prize and give it to winner
1000                         _prize = ((airDropPot_).mul(75)) / 100;
1001                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1002 
1003                         // adjust airDropPot
1004                         airDropPot_ = (airDropPot_).sub(_prize);
1005 
1006                         // let event know a tier 3 prize was won
1007                         _eventData_.compressedData += 300000000000000000000000000000000;
1008                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1009                         // calculate prize and give it to winner
1010                         _prize = ((airDropPot_).mul(50)) / 100;
1011                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1012 
1013                         // adjust airDropPot
1014                         airDropPot_ = (airDropPot_).sub(_prize);
1015 
1016                         // let event know a tier 2 prize was won
1017                         _eventData_.compressedData += 200000000000000000000000000000000;
1018                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1019                         // calculate prize and give it to winner
1020                         _prize = ((airDropPot_).mul(25)) / 100;
1021                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1022 
1023                         // adjust airDropPot
1024                         airDropPot_ = (airDropPot_).sub(_prize);
1025 
1026                         // let event know a tier 3 prize was won
1027                         _eventData_.compressedData += 300000000000000000000000000000000;
1028                     }
1029                     // set airdrop happened bool to true
1030                     _eventData_.compressedData += 10000000000000000000000000000000;
1031                     // let event know how much was won
1032                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1033 
1034                     // reset air drop tracker
1035                     airDropTracker_ = 0;
1036                 }
1037             }
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
1056             endTx(_pID, _team, _eth, _keys, _eventData_);
1057         }
1058     }
1059     //==============================================================================
1060     //     _ _ | _   | _ _|_ _  _ _  .
1061     //    (_(_||(_|_||(_| | (_)| _\  .
1062     //==============================================================================
1063     /**
1064      * @dev calculates unmasked earnings (just calculates, does not update mask)
1065      * @return earnings in wei format
1066      */
1067     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1068     private
1069     view
1070     returns(uint256)
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
1083     public
1084     view
1085     returns(uint256)
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
1104     public
1105     view
1106     returns(uint256)
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
1120     //==============================================================================
1121     //    _|_ _  _ | _  .
1122     //     | (_)(_)|_\  .
1123     //==============================================================================
1124     /**
1125 	 * @dev receives name/player info from names contract
1126      */
1127     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1128     external
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
1149     external
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
1161     private
1162     returns (F3Ddatasets.EventReturns)
1163     {
1164         uint256 _pID = pIDxAddr_[msg.sender];
1165         // if player is new to this version of fomo3d
1166         if (_pID == 0)
1167         {
1168             // grab their player ID, name and last aff ID, from player names contract
1169             //_pID = PlayerBook.getPlayerID(msg.sender);
1170             //bytes32 _name = PlayerBook.getPlayerName(_pID);
1171             //uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1172 
1173             pID_++;
1174             _pID = pID_;
1175             // set up player account
1176             pIDxAddr_[msg.sender] = _pID;
1177             plyr_[_pID].addr = msg.sender;
1178 
1179             /*if (_name != "")
1180             {
1181                 pIDxName_[_name] = _pID;
1182                 plyr_[_pID].name = _name;
1183                 plyrNames_[_pID][_name] = true;
1184             }
1185 
1186             if (_laff != 0 && _laff != _pID)
1187                 plyr_[_pID].laff = _laff;*/
1188 
1189             // set the new player bool to true
1190             _eventData_.compressedData = _eventData_.compressedData + 1;
1191         }
1192         return (_eventData_);
1193     }
1194 
1195     /**
1196      * @dev checks to make sure user picked a valid team.  if not sets team
1197      * to default (sneks)
1198      */
1199     function verifyTeam(uint256 _team)
1200     private
1201     pure
1202     returns (uint256)
1203     {
1204         if (_team < 0 || _team > 3)
1205             return(2);
1206         else
1207             return(_team);
1208     }
1209 
1210     /**
1211      * @dev decides if round end needs to be run & new round started.  and if
1212      * player unmasked earnings from previously played rounds need to be moved.
1213      */
1214     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1215     private
1216     returns (F3Ddatasets.EventReturns)
1217     {
1218         // if player has played a previous round, move their unmasked earnings
1219         // from that round to gen vault.
1220         if (plyr_[_pID].lrnd != 0)
1221             updateGenVault(_pID, plyr_[_pID].lrnd);
1222 
1223         // update player's last round played
1224         plyr_[_pID].lrnd = rID_;
1225 
1226         // set the joined round bool to true
1227         _eventData_.compressedData = _eventData_.compressedData + 10;
1228 
1229         return(_eventData_);
1230     }
1231 
1232     /**
1233      * @dev ends the round. manages paying out winner/splitting up pot
1234      */
1235     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1236     private
1237     returns (F3Ddatasets.EventReturns)
1238     {
1239         // setup local rID
1240         uint256 _rID = rID_;
1241 
1242         // grab our winning player and team id's
1243         uint256 _winPID = round_[_rID].plyr;
1244         uint256 _winTID = round_[_rID].team;
1245 
1246         // grab our pot amount
1247         uint256 _pot = round_[_rID].pot;
1248 
1249         // calculate our winner share, community rewards, gen share,
1250         // p3d share, and amount reserved for next pot
1251         uint256 _win = (_pot.mul(48)) / 100;
1252         uint256 _com = (_pot / 50);
1253         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1254         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1255         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1256 
1257         // calculate ppt for round mask
1258         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1259         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1260         if (_dust > 0)
1261         {
1262             _gen = _gen.sub(_dust);
1263             _res = _res.add(_dust);
1264         }
1265 
1266         // pay our winner
1267         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1268 
1269         // community rewards
1270 
1271         admin.transfer(_com);
1272 
1273         admin.transfer(_p3d.sub(_p3d / 2));
1274 
1275         round_[_rID].pot = _pot.add(_p3d / 2);
1276 
1277         // distribute gen portion to key holders
1278         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1279 
1280         // prepare event data
1281         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1282         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1283         _eventData_.winnerAddr = plyr_[_winPID].addr;
1284         _eventData_.winnerName = plyr_[_winPID].name;
1285         _eventData_.amountWon = _win;
1286         _eventData_.genAmount = _gen;
1287         _eventData_.P3DAmount = _p3d;
1288         _eventData_.newPot = _res;
1289 
1290         // start next round
1291         rID_++;
1292         _rID++;
1293         round_[_rID].strt = now;
1294         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1295         round_[_rID].pot = _res;
1296 
1297         return(_eventData_);
1298     }
1299 
1300     /**
1301      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1302      */
1303     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1304     private
1305     {
1306         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1307         if (_earnings > 0)
1308         {
1309             // put in gen vault
1310             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1311             // zero out their earnings by updating mask
1312             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1313         }
1314     }
1315 
1316     /**
1317      * @dev updates round timer based on number of whole keys bought.
1318      */
1319     function updateTimer(uint256 _keys, uint256 _rID)
1320     private
1321     {
1322         // grab time
1323         uint256 _now = now;
1324 
1325         // calculate time based on number of keys bought
1326         uint256 _newTime;
1327         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1328             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1329         else
1330             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1331 
1332         // compare to max and set new end time
1333         if (_newTime < (rndMax_).add(_now))
1334             round_[_rID].end = _newTime;
1335         else
1336             round_[_rID].end = rndMax_.add(_now);
1337     }
1338 
1339     /**
1340      * @dev generates a random number between 0-99 and checks to see if thats
1341      * resulted in an airdrop win
1342      * @return do we have a winner?
1343      */
1344     function airdrop()
1345     private
1346     view
1347     returns(bool)
1348     {
1349         uint256 seed = uint256(keccak256(abi.encodePacked(
1350 
1351                 (block.timestamp).add
1352                 (block.difficulty).add
1353                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1354                 (block.gaslimit).add
1355                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1356                 (block.number)
1357 
1358             )));
1359         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1360             return(true);
1361         else
1362             return(false);
1363     }
1364 
1365     /**
1366      * @dev distributes eth based on fees to com, aff, and p3d
1367      */
1368     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1369     private
1370     returns(F3Ddatasets.EventReturns)
1371     {
1372         // pay 3% out to community rewards
1373         uint256 _p1 = _eth / 100;
1374         uint256 _com = _eth / 50;
1375         _com = _com.add(_p1);
1376 
1377         uint256 _p3d;
1378         if (!address(admin).call.value(_com)())
1379         {
1380             // This ensures Team Just cannot influence the outcome of FoMo3D with
1381             // bank migrations by breaking outgoing transactions.
1382             // Something we would never do. But that's not the point.
1383             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1384             // highest belief that everything we create should be trustless.
1385             // Team JUST, The name you shouldn't have to trust.
1386             _p3d = _com;
1387             _com = 0;
1388         }
1389 
1390 
1391         // distribute share to affiliate
1392         uint256 _aff = _eth / 10;
1393 
1394         // decide what to do with affiliate share of fees
1395         // affiliate must not be self, and must have a name registered
1396         if (_affID != _pID && plyr_[_affID].name != '') {
1397             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1398             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1399         } else {
1400             _p3d = _aff;
1401         }
1402 
1403         // pay out p3d
1404         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1405         if (_p3d > 0)
1406         {
1407             // deposit to divies contract
1408             uint256 _potAmount = _p3d / 2;
1409 
1410             admin.transfer(_p3d.sub(_potAmount));
1411 
1412             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1413 
1414             // set up event data
1415             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1416         }
1417 
1418         return(_eventData_);
1419     }
1420 
1421     function potSwap()
1422     external
1423     payable
1424     {
1425         // setup local rID
1426         uint256 _rID = rID_ + 1;
1427 
1428         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1429         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1430     }
1431 
1432     /**
1433      * @dev distributes eth based on fees to gen and pot
1434      */
1435     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1436     private
1437     returns(F3Ddatasets.EventReturns)
1438     {
1439         // calculate gen share
1440         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1441 
1442         // toss 1% into airdrop pot
1443         uint256 _air = (_eth / 100);
1444         airDropPot_ = airDropPot_.add(_air);
1445 
1446         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1447         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1448 
1449         // calculate pot
1450         uint256 _pot = _eth.sub(_gen);
1451 
1452         // distribute gen share (thats what updateMasks() does) and adjust
1453         // balances for dust.
1454         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1455         if (_dust > 0)
1456             _gen = _gen.sub(_dust);
1457 
1458         // add eth to pot
1459         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1460 
1461         // set up event data
1462         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1463         _eventData_.potAmount = _pot;
1464 
1465         return(_eventData_);
1466     }
1467 
1468     /**
1469      * @dev updates masks for round and player when keys are bought
1470      * @return dust left over
1471      */
1472     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1473     private
1474     returns(uint256)
1475     {
1476         /* MASKING NOTES
1477             earnings masks are a tricky thing for people to wrap their minds around.
1478             the basic thing to understand here.  is were going to have a global
1479             tracker based on profit per share for each round, that increases in
1480             relevant proportion to the increase in share supply.
1481 
1482             the player will have an additional mask that basically says "based
1483             on the rounds mask, my shares, and how much i've already withdrawn,
1484             how much is still owed to me?"
1485         */
1486 
1487         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1488         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1489         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1490 
1491         // calculate player earning from their own buy (only based on the keys
1492         // they just bought).  & update player earnings mask
1493         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1494         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1495 
1496         // calculate & return dust
1497         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1498     }
1499 
1500     /**
1501      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1502      * @return earnings in wei format
1503      */
1504     function withdrawEarnings(uint256 _pID)
1505     private
1506     returns(uint256)
1507     {
1508         // update gen vault
1509         updateGenVault(_pID, plyr_[_pID].lrnd);
1510 
1511         // from vaults
1512         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1513         if (_earnings > 0)
1514         {
1515             plyr_[_pID].win = 0;
1516             plyr_[_pID].gen = 0;
1517             plyr_[_pID].aff = 0;
1518         }
1519 
1520         return(_earnings);
1521     }
1522 
1523     /**
1524      * @dev prepares compression data and fires event for buy or reload tx's
1525      */
1526     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1527     private
1528     {
1529         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1530         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1531 
1532         emit F3Devents.onEndTx
1533         (
1534             _eventData_.compressedData,
1535             _eventData_.compressedIDs,
1536             plyr_[_pID].name,
1537             msg.sender,
1538             _eth,
1539             _keys,
1540             _eventData_.winnerAddr,
1541             _eventData_.winnerName,
1542             _eventData_.amountWon,
1543             _eventData_.newPot,
1544             _eventData_.P3DAmount,
1545             _eventData_.genAmount,
1546             _eventData_.potAmount,
1547             airDropPot_
1548         );
1549     }
1550     //==============================================================================
1551     //    (~ _  _    _._|_    .
1552     //    _)(/_(_|_|| | | \/  .
1553     //====================/=========================================================
1554     /** upon contract deploy, it will be deactivated.  this is a one time
1555      * use function that will activate the contract.  we do this so devs
1556      * have time to set things up on the web end                            **/
1557     bool public activated_ = false;
1558     function activate()
1559     public
1560     {
1561         // only team just can activate
1562         require(msg.sender == admin, "only admin can activate");
1563 
1564 
1565         // can only be ran once
1566         require(activated_ == false, "FOMO Short already activated");
1567 
1568         // activate the contract
1569         activated_ = true;
1570 
1571         // lets start first round
1572 
1573 
1574         rID_ = 1;
1575         round_[1].strt = now + rndExtra_ - rndGap_;
1576         round_[1].end = now + rndInit_ + rndExtra_;
1577     }
1578 }
1579 
1580 //==============================================================================
1581 //   __|_ _    __|_ _  .
1582 //  _\ | | |_|(_ | _\  .
1583 //==============================================================================
1584 library F3Ddatasets {
1585     //compressedData key
1586     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1587     // 0 - new player (bool)
1588     // 1 - joined round (bool)
1589     // 2 - new  leader (bool)
1590     // 3-5 - air drop tracker (uint 0-999)
1591     // 6-16 - round end time
1592     // 17 - winnerTeam
1593     // 18 - 28 timestamp
1594     // 29 - team
1595     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1596     // 31 - airdrop happened bool
1597     // 32 - airdrop tier
1598     // 33 - airdrop amount won
1599     //compressedIDs key
1600     // [77-52][51-26][25-0]
1601     // 0-25 - pID
1602     // 26-51 - winPID
1603     // 52-77 - rID
1604     struct EventReturns {
1605         uint256 compressedData;
1606         uint256 compressedIDs;
1607         address winnerAddr;         // winner address
1608         bytes32 winnerName;         // winner name
1609         uint256 amountWon;          // amount won
1610         uint256 newPot;             // amount in new pot
1611         uint256 P3DAmount;          // amount distributed to p3d
1612         uint256 genAmount;          // amount distributed to gen
1613         uint256 potAmount;          // amount added to pot
1614     }
1615     struct Player {
1616         address addr;   // player address
1617         bytes32 name;   // player name
1618         uint256 win;    // winnings vault
1619         uint256 gen;    // general vault
1620         uint256 aff;    // affiliate vault
1621         uint256 lrnd;   // last round played
1622         uint256 laff;   // last affiliate id used
1623     }
1624     struct PlayerRounds {
1625         uint256 eth;    // eth player has added to round (used for eth limiter)
1626         uint256 keys;   // keys
1627         uint256 mask;   // player mask
1628         uint256 ico;    // ICO phase investment
1629     }
1630     struct Round {
1631         uint256 plyr;   // pID of player in lead
1632         uint256 team;   // tID of team in lead
1633         uint256 end;    // time ends/ended
1634         bool ended;     // has round end function been ran
1635         uint256 strt;   // time round started
1636         uint256 keys;   // keys
1637         uint256 eth;    // total eth in
1638         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1639         uint256 mask;   // global mask
1640         uint256 ico;    // total eth sent in during ICO phase
1641         uint256 icoGen; // total eth for gen during ICO phase
1642         uint256 icoAvg; // average key price for ICO phase
1643     }
1644     struct TeamFee {
1645         uint256 gen;    // % of buy in thats paid to key holders of current round
1646         uint256 p3d;    // % of buy in thats paid to p3d holders
1647     }
1648     struct PotSplit {
1649         uint256 gen;    // % of pot thats paid to key holders of current round
1650         uint256 p3d;    // % of pot thats paid to p3d holders
1651     }
1652 }
1653 
1654 //==============================================================================
1655 //  |  _      _ _ | _  .
1656 //  |<(/_\/  (_(_||(_  .
1657 //=======/======================================================================
1658 library F3DKeysCalcShort {
1659     using SafeMath for *;
1660     /**
1661      * @dev calculates number of keys received given X eth
1662      * @param _curEth current amount of eth in contract
1663      * @param _newEth eth being spent
1664      * @return amount of ticket purchased
1665      */
1666     function keysRec(uint256 _curEth, uint256 _newEth)
1667     internal
1668     pure
1669     returns (uint256)
1670     {
1671         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1672     }
1673 
1674     /**
1675      * @dev calculates amount of eth received if you sold X keys
1676      * @param _curKeys current amount of keys that exist
1677      * @param _sellKeys amount of keys you wish to sell
1678      * @return amount of eth received
1679      */
1680     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1681     internal
1682     pure
1683     returns (uint256)
1684     {
1685         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1686     }
1687 
1688     /**
1689      * @dev calculates how many keys would exist with given an amount of eth
1690      * @param _eth eth "in contract"
1691      * @return number of keys that would exist
1692      */
1693     function keys(uint256 _eth)
1694     internal
1695     pure
1696     returns(uint256)
1697     {
1698         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1699     }
1700 
1701     /**
1702      * @dev calculates how much eth would be in contract given a number of keys
1703      * @param _keys number of keys "in contract"
1704      * @return eth that would exists
1705      */
1706     function eth(uint256 _keys)
1707     internal
1708     pure
1709     returns(uint256)
1710     {
1711         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1712     }
1713 }
1714 
1715 //==============================================================================
1716 //  . _ _|_ _  _ |` _  _ _  _  .
1717 //  || | | (/_| ~|~(_|(_(/__\  .
1718 //==============================================================================
1719 
1720 interface PlayerBookInterface {
1721     function getPlayerID(address _addr) external returns (uint256);
1722     function getPlayerName(uint256 _pID) external view returns (bytes32);
1723     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1724     function getPlayerAddr(uint256 _pID) external view returns (address);
1725     function getNameFee() external view returns (uint256);
1726     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1727     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1728     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1729 }
1730 
1731 /**
1732 * @title -Name Filter- v0.1.9
1733 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1734 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1735 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1736 *                                  _____                      _____
1737 *                                 (, /     /)       /) /)    (, /      /)          /)
1738 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1739 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1740 *          ┴ ┴                /   /          .-/ _____   (__ /
1741 *                            (__ /          (_/ (, /                                      /)™
1742 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1743 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1744 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1745 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1746 *              _       __    _      ____      ____  _   _    _____  ____  ___
1747 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1748 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1749 *
1750 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1751 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1752 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1753 */
1754 
1755 library NameFilter {
1756     /**
1757      * @dev filters name strings
1758      * -converts uppercase to lower case.
1759      * -makes sure it does not start/end with a space
1760      * -makes sure it does not contain multiple spaces in a row
1761      * -cannot be only numbers
1762      * -cannot start with 0x
1763      * -restricts characters to A-Z, a-z, 0-9, and space.
1764      * @return reprocessed string in bytes32 format
1765      */
1766     function nameFilter(string _input)
1767     internal
1768     pure
1769     returns(bytes32)
1770     {
1771         bytes memory _temp = bytes(_input);
1772         uint256 _length = _temp.length;
1773 
1774         //sorry limited to 32 characters
1775         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1776         // make sure it doesnt start with or end with space
1777         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1778         // make sure first two characters are not 0x
1779         if (_temp[0] == 0x30)
1780         {
1781             require(_temp[1] != 0x78, "string cannot start with 0x");
1782             require(_temp[1] != 0x58, "string cannot start with 0X");
1783         }
1784 
1785         // create a bool to track if we have a non number character
1786         bool _hasNonNumber;
1787 
1788         // convert & check
1789         for (uint256 i = 0; i < _length; i++)
1790         {
1791             // if its uppercase A-Z
1792             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1793             {
1794                 // convert to lower case a-z
1795                 _temp[i] = byte(uint(_temp[i]) + 32);
1796 
1797                 // we have a non number
1798                 if (_hasNonNumber == false)
1799                     _hasNonNumber = true;
1800             } else {
1801                 require
1802                 (
1803                 // require character is a space
1804                     _temp[i] == 0x20 ||
1805                 // OR lowercase a-z
1806                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1807                 // or 0-9
1808                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1809                     "string contains invalid characters"
1810                 );
1811                 // make sure theres not 2x spaces in a row
1812                 if (_temp[i] == 0x20)
1813                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1814 
1815                 // see if we have a character other than a number
1816                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1817                     _hasNonNumber = true;
1818             }
1819         }
1820 
1821         require(_hasNonNumber == true, "string cannot be only numbers");
1822 
1823         bytes32 _ret;
1824         assembly {
1825             _ret := mload(add(_temp, 32))
1826         }
1827         return (_ret);
1828     }
1829 }
1830 
1831 /**
1832  * @title SafeMath v0.1.9
1833  * @dev Math operations with safety checks that throw on error
1834  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1835  * - added sqrt
1836  * - added sq
1837  * - added pwr
1838  * - changed asserts to requires with error log outputs
1839  * - removed div, its useless
1840  */
1841 library SafeMath {
1842 
1843     /**
1844     * @dev Multiplies two numbers, throws on overflow.
1845     */
1846     function mul(uint256 a, uint256 b)
1847     internal
1848     pure
1849     returns (uint256 c)
1850     {
1851         if (a == 0) {
1852             return 0;
1853         }
1854         c = a * b;
1855         require(c / a == b, "SafeMath mul failed");
1856         return c;
1857     }
1858 
1859     /**
1860     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1861     */
1862     function sub(uint256 a, uint256 b)
1863     internal
1864     pure
1865     returns (uint256)
1866     {
1867         require(b <= a, "SafeMath sub failed");
1868         return a - b;
1869     }
1870 
1871     /**
1872     * @dev Adds two numbers, throws on overflow.
1873     */
1874     function add(uint256 a, uint256 b)
1875     internal
1876     pure
1877     returns (uint256 c)
1878     {
1879         c = a + b;
1880         require(c >= a, "SafeMath add failed");
1881         return c;
1882     }
1883 
1884     /**
1885      * @dev gives square root of given x.
1886      */
1887     function sqrt(uint256 x)
1888     internal
1889     pure
1890     returns (uint256 y)
1891     {
1892         uint256 z = ((add(x,1)) / 2);
1893         y = x;
1894         while (z < y)
1895         {
1896             y = z;
1897             z = ((add((x / z),z)) / 2);
1898         }
1899     }
1900 
1901     /**
1902      * @dev gives square. multiplies x by x
1903      */
1904     function sq(uint256 x)
1905     internal
1906     pure
1907     returns (uint256)
1908     {
1909         return (mul(x,x));
1910     }
1911 
1912     /**
1913      * @dev x to the power of y
1914      */
1915     function pwr(uint256 x, uint256 y)
1916     internal
1917     pure
1918     returns (uint256)
1919     {
1920         if (x==0)
1921             return (0);
1922         else if (y==0)
1923             return (1);
1924         else
1925         {
1926             uint256 z = x;
1927             for (uint256 i=1; i < y; i++)
1928                 z = mul(z,x);
1929             return (z);
1930         }
1931     }
1932 }