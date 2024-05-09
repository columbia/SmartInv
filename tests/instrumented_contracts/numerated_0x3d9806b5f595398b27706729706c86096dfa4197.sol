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
123 contract FoMo3Dshort is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcShort for uint256;
127 
128     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xF6b8836492f8332D17B1496828d2bEE71ad511DA);
129 //==============================================================================
130 //     _ _  _  |`. _     _ _ |_ | _  _  .
131 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
132 //=================_|===========================================================
133     address private admin = msg.sender;
134     string constant public name = "MOFO 3D";
135     string constant public symbol = "MOFO";
136     uint256 constant private rndInit_ = 10 minutes;                // round timer starts at this
137     uint256 constant private rndInc_ = 5 seconds;              // every full key purchased adds this much to the timer
138     uint256 constant private rndMax_ = 10 minutes;                // max length a round timer can be
139 //==============================================================================
140 //     _| _ _|_ _    _ _ _|_    _   .
141 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
142 //=============================|================================================
143     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
144     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
145     uint256 public rID_;    // round id number / total rounds that have happened
146 //****************
147 // PLAYER DATA
148 //****************
149     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
150     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
151     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
152     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
153     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
154 //****************
155 // ROUND DATA
156 //****************
157     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
158     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
159 //****************
160 // TEAM FEE DATA
161 //****************
162     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
163     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
164 //==============================================================================
165 //     _ _  _  __|_ _    __|_ _  _  .
166 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
167 //==============================================================================
168     constructor()
169         public
170     {
171 		// Team allocation structures
172         // 0 = whales
173         // 1 = bears
174         // 2 = sneks
175         // 3 = bulls
176 
177 		// Team allocation percentages
178         // (F3D, P3D) + (Pot , Referrals, Community)
179             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
180         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
181         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
182         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
183         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
184 
185         // how to split up the final pot based on which team was picked
186         // (F3D, P3D)
187         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
188         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
189         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
190         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
191 	}
192 //==============================================================================
193 //     _ _  _  _|. |`. _  _ _  .
194 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
195 //==============================================================================
196     /**
197      * @dev used to make sure no one can interact with contract until it has
198      * been activated.
199      */
200     modifier isActivated() {
201         require(activated_ == true, "its not ready yet.  check ?eta in discord");
202         _;
203     }
204 
205     /**
206      * @dev prevents contracts from interacting with fomo3d
207      */
208     modifier isHuman() {
209         address _addr = msg.sender;
210         uint256 _codeLength;
211 
212         assembly {_codeLength := extcodesize(_addr)}
213         require(_codeLength == 0, "sorry humans only");
214         _;
215     }
216 
217     /**
218      * @dev sets boundaries for incoming tx
219      */
220     modifier isWithinLimits(uint256 _eth) {
221         require(_eth >= 1000000000, "pocket lint: not a valid currency");
222         require(_eth <= 100000000000000000000000, "no vitalik, no");
223         _;
224     }
225 
226 //==============================================================================
227 //     _    |_ |. _   |`    _  __|_. _  _  _  .
228 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
229 //====|=========================================================================
230     /**
231      * @dev emergency buy uses last stored affiliate ID and team snek
232      */
233     function()
234         isActivated()
235         isHuman()
236         isWithinLimits(msg.value)
237         public
238         payable
239     {
240         // set up our tx event data and determine if player is new or not
241         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
242 
243         // fetch player id
244         uint256 _pID = pIDxAddr_[msg.sender];
245 
246         // buy core
247         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
248     }
249 
250     /**
251      * @dev converts all incoming ethereum to keys.
252      * -functionhash- 0x8f38f309 (using ID for affiliate)
253      * -functionhash- 0x98a0871d (using address for affiliate)
254      * -functionhash- 0xa65b37a1 (using name for affiliate)
255      * @param _affCode the ID/address/name of the player who gets the affiliate fee
256      * @param _team what team is the player playing for?
257      */
258     function buyXid(uint256 _affCode, uint256 _team)
259         isActivated()
260         isHuman()
261         isWithinLimits(msg.value)
262         public
263         payable
264     {
265         // set up our tx event data and determine if player is new or not
266         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
267 
268         // fetch player id
269         uint256 _pID = pIDxAddr_[msg.sender];
270 
271         // manage affiliate residuals
272         // if no affiliate code was given or player tried to use their own, lolz
273         if (_affCode == 0 || _affCode == _pID)
274         {
275             // use last stored affiliate code
276             _affCode = plyr_[_pID].laff;
277 
278         // if affiliate code was given & its not the same as previously stored
279         } else if (_affCode != plyr_[_pID].laff) {
280             // update last affiliate
281             plyr_[_pID].laff = _affCode;
282         }
283 
284         // verify a valid team was selected
285         _team = verifyTeam(_team);
286 
287         // buy core
288         buyCore(_pID, _affCode, _team, _eventData_);
289     }
290 
291     function buyXaddr(address _affCode, uint256 _team)
292         isActivated()
293         isHuman()
294         isWithinLimits(msg.value)
295         public
296         payable
297     {
298         // set up our tx event data and determine if player is new or not
299         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
300 
301         // fetch player id
302         uint256 _pID = pIDxAddr_[msg.sender];
303 
304         // manage affiliate residuals
305         uint256 _affID;
306         // if no affiliate code was given or player tried to use their own, lolz
307         if (_affCode == address(0) || _affCode == msg.sender)
308         {
309             // use last stored affiliate code
310             _affID = plyr_[_pID].laff;
311 
312         // if affiliate code was given
313         } else {
314             // get affiliate ID from aff Code
315             _affID = pIDxAddr_[_affCode];
316 
317             // if affID is not the same as previously stored
318             if (_affID != plyr_[_pID].laff)
319             {
320                 // update last affiliate
321                 plyr_[_pID].laff = _affID;
322             }
323         }
324 
325         // verify a valid team was selected
326         _team = verifyTeam(_team);
327 
328         // buy core
329         buyCore(_pID, _affID, _team, _eventData_);
330     }
331 
332     function buyXname(bytes32 _affCode, uint256 _team)
333         isActivated()
334         isHuman()
335         isWithinLimits(msg.value)
336         public
337         payable
338     {
339         // set up our tx event data and determine if player is new or not
340         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
341 
342         // fetch player id
343         uint256 _pID = pIDxAddr_[msg.sender];
344 
345         // manage affiliate residuals
346         uint256 _affID;
347         // if no affiliate code was given or player tried to use their own, lolz
348         if (_affCode == '' || _affCode == plyr_[_pID].name)
349         {
350             // use last stored affiliate code
351             _affID = plyr_[_pID].laff;
352 
353         // if affiliate code was given
354         } else {
355             // get affiliate ID from aff Code
356             _affID = pIDxName_[_affCode];
357 
358             // if affID is not the same as previously stored
359             if (_affID != plyr_[_pID].laff)
360             {
361                 // update last affiliate
362                 plyr_[_pID].laff = _affID;
363             }
364         }
365 
366         // verify a valid team was selected
367         _team = verifyTeam(_team);
368 
369         // buy core
370         buyCore(_pID, _affID, _team, _eventData_);
371     }
372 
373     /**
374      * @dev essentially the same as buy, but instead of you sending ether
375      * from your wallet, it uses your unwithdrawn earnings.
376      * -functionhash- 0x349cdcac (using ID for affiliate)
377      * -functionhash- 0x82bfc739 (using address for affiliate)
378      * -functionhash- 0x079ce327 (using name for affiliate)
379      * @param _affCode the ID/address/name of the player who gets the affiliate fee
380      * @param _team what team is the player playing for?
381      * @param _eth amount of earnings to use (remainder returned to gen vault)
382      */
383     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
384         isActivated()
385         isHuman()
386         isWithinLimits(_eth)
387         public
388     {
389         // set up our tx event data
390         F3Ddatasets.EventReturns memory _eventData_;
391 
392         // fetch player ID
393         uint256 _pID = pIDxAddr_[msg.sender];
394 
395         // manage affiliate residuals
396         // if no affiliate code was given or player tried to use their own, lolz
397         if (_affCode == 0 || _affCode == _pID)
398         {
399             // use last stored affiliate code
400             _affCode = plyr_[_pID].laff;
401 
402         // if affiliate code was given & its not the same as previously stored
403         } else if (_affCode != plyr_[_pID].laff) {
404             // update last affiliate
405             plyr_[_pID].laff = _affCode;
406         }
407 
408         // verify a valid team was selected
409         _team = verifyTeam(_team);
410 
411         // reload core
412         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
413     }
414 
415     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
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
428         uint256 _affID;
429         // if no affiliate code was given or player tried to use their own, lolz
430         if (_affCode == address(0) || _affCode == msg.sender)
431         {
432             // use last stored affiliate code
433             _affID = plyr_[_pID].laff;
434 
435         // if affiliate code was given
436         } else {
437             // get affiliate ID from aff Code
438             _affID = pIDxAddr_[_affCode];
439 
440             // if affID is not the same as previously stored
441             if (_affID != plyr_[_pID].laff)
442             {
443                 // update last affiliate
444                 plyr_[_pID].laff = _affID;
445             }
446         }
447 
448         // verify a valid team was selected
449         _team = verifyTeam(_team);
450 
451         // reload core
452         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
453     }
454 
455     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
456         isActivated()
457         isHuman()
458         isWithinLimits(_eth)
459         public
460     {
461         // set up our tx event data
462         F3Ddatasets.EventReturns memory _eventData_;
463 
464         // fetch player ID
465         uint256 _pID = pIDxAddr_[msg.sender];
466 
467         // manage affiliate residuals
468         uint256 _affID;
469         // if no affiliate code was given or player tried to use their own, lolz
470         if (_affCode == '' || _affCode == plyr_[_pID].name)
471         {
472             // use last stored affiliate code
473             _affID = plyr_[_pID].laff;
474 
475         // if affiliate code was given
476         } else {
477             // get affiliate ID from aff Code
478             _affID = pIDxName_[_affCode];
479 
480             // if affID is not the same as previously stored
481             if (_affID != plyr_[_pID].laff)
482             {
483                 // update last affiliate
484                 plyr_[_pID].laff = _affID;
485             }
486         }
487 
488         // verify a valid team was selected
489         _team = verifyTeam(_team);
490 
491         // reload core
492         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
493     }
494 
495     /**
496      * @dev withdraws all of your earnings.
497      * -functionhash- 0x3ccfd60b
498      */
499     function withdraw()
500         isActivated()
501         isHuman()
502         public
503     {
504         // setup local rID
505         uint256 _rID = rID_;
506 
507         // grab time
508         uint256 _now = now;
509 
510         // fetch player ID
511         uint256 _pID = pIDxAddr_[msg.sender];
512 
513         // setup temp var for player eth
514         uint256 _eth;
515 
516         // check to see if round has ended and no one has run round end yet
517         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
518         {
519             // set up our tx event data
520             F3Ddatasets.EventReturns memory _eventData_;
521 
522             // end the round (distributes pot)
523 			round_[_rID].ended = true;
524             _eventData_ = endRound(_eventData_);
525 
526 			// get their earnings
527             _eth = withdrawEarnings(_pID);
528 
529             // gib moni
530             if (_eth > 0)
531                 plyr_[_pID].addr.transfer(_eth);
532 
533             // build event data
534             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
535             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
536 
537             // fire withdraw and distribute event
538             emit F3Devents.onWithdrawAndDistribute
539             (
540                 msg.sender,
541                 plyr_[_pID].name,
542                 _eth,
543                 _eventData_.compressedData,
544                 _eventData_.compressedIDs,
545                 _eventData_.winnerAddr,
546                 _eventData_.winnerName,
547                 _eventData_.amountWon,
548                 _eventData_.newPot,
549                 _eventData_.P3DAmount,
550                 _eventData_.genAmount
551             );
552 
553         // in any other situation
554         } else {
555             // get their earnings
556             _eth = withdrawEarnings(_pID);
557 
558             // gib moni
559             if (_eth > 0)
560                 plyr_[_pID].addr.transfer(_eth);
561 
562             // fire withdraw event
563             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
564         }
565     }
566 
567     /**
568      * @dev use these to register names.  they are just wrappers that will send the
569      * registration requests to the PlayerBook contract.  So registering here is the
570      * same as registering there.  UI will always display the last name you registered.
571      * but you will still own all previously registered names to use as affiliate
572      * links.
573      * - must pay a registration fee.
574      * - name must be unique
575      * - names will be converted to lowercase
576      * - name cannot start or end with a space
577      * - cannot have more than 1 space in a row
578      * - cannot be only numbers
579      * - cannot start with 0x
580      * - name must be at least 1 char
581      * - max length of 32 characters long
582      * - allowed characters: a-z, 0-9, and space
583      * -functionhash- 0x921dec21 (using ID for affiliate)
584      * -functionhash- 0x3ddd4698 (using address for affiliate)
585      * -functionhash- 0x685ffd83 (using name for affiliate)
586      * @param _nameString players desired name
587      * @param _affCode affiliate ID, address, or name of who referred you
588      * @param _all set to true if you want this to push your info to all games
589      * (this might cost a lot of gas)
590      */
591     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
592         isHuman()
593         public
594         payable
595     {
596         bytes32 _name = _nameString.nameFilter();
597         address _addr = msg.sender;
598         uint256 _paid = msg.value;
599         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
600 
601         uint256 _pID = pIDxAddr_[_addr];
602 
603         // fire event
604         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
605     }
606 
607     function registerNameXaddr(string _nameString, address _affCode, bool _all)
608         isHuman()
609         public
610         payable
611     {
612         bytes32 _name = _nameString.nameFilter();
613         address _addr = msg.sender;
614         uint256 _paid = msg.value;
615         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
616 
617         uint256 _pID = pIDxAddr_[_addr];
618 
619         // fire event
620         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
621     }
622 
623     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
624         isHuman()
625         public
626         payable
627     {
628         bytes32 _name = _nameString.nameFilter();
629         address _addr = msg.sender;
630         uint256 _paid = msg.value;
631         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
632 
633         uint256 _pID = pIDxAddr_[_addr];
634 
635         // fire event
636         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
637     }
638 //==============================================================================
639 //     _  _ _|__|_ _  _ _  .
640 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
641 //=====_|=======================================================================
642     /**
643      * @dev return the price buyer will pay for next 1 individual key.
644      * -functionhash- 0x018a25e8
645      * @return price for next key bought (in wei format)
646      */
647     function getBuyPrice()
648         public
649         view
650         returns(uint256)
651     {
652         // setup local rID
653         uint256 _rID = rID_;
654 
655         // grab time
656         uint256 _now = now;
657 
658         // are we in a round?
659         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
660             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
661         else // rounds over.  need price for new round
662             return ( 75000000000000 ); // init
663     }
664 
665     /**
666      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
667      * provider
668      * -functionhash- 0xc7e284b8
669      * @return time left in seconds
670      */
671     function getTimeLeft()
672         public
673         view
674         returns(uint256)
675     {
676         // setup local rID
677         uint256 _rID = rID_;
678 
679         // grab time
680         uint256 _now = now;
681 
682         if (_now < round_[_rID].end)
683             if (_now > round_[_rID].strt)
684                 return( (round_[_rID].end).sub(_now) );
685             else
686                 return( (round_[_rID].strt).sub(_now) );
687         else
688             return(0);
689     }
690 
691     /**
692      * @dev returns player earnings per vaults
693      * -functionhash- 0x63066434
694      * @return winnings vault
695      * @return general vault
696      * @return affiliate vault
697      */
698     function getPlayerVaults(uint256 _pID)
699         public
700         view
701         returns(uint256 ,uint256, uint256)
702     {
703         // setup local rID
704         uint256 _rID = rID_;
705 
706         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
707         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
708         {
709             // if player is winner
710             if (round_[_rID].plyr == _pID)
711             {
712                 return
713                 (
714                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
715                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
716                     plyr_[_pID].aff
717                 );
718             // if player is not the winner
719             } else {
720                 return
721                 (
722                     plyr_[_pID].win,
723                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
724                     plyr_[_pID].aff
725                 );
726             }
727 
728         // if round is still going on, or round has ended and round end has been ran
729         } else {
730             return
731             (
732                 plyr_[_pID].win,
733                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
734                 plyr_[_pID].aff
735             );
736         }
737     }
738 
739     /**
740      * solidity hates stack limits.  this lets us avoid that hate
741      */
742     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
743         private
744         view
745         returns(uint256)
746     {
747         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
748     }
749 
750     /**
751      * @dev returns all current round info needed for front end
752      * -functionhash- 0x747dff42
753      * @return eth invested during ICO phase
754      * @return round id
755      * @return total keys for round
756      * @return time round ends
757      * @return time round started
758      * @return current pot
759      * @return current team ID & player ID in lead
760      * @return current player in leads address
761      * @return current player in leads name
762      * @return whales eth in for round
763      * @return bears eth in for round
764      * @return sneks eth in for round
765      * @return bulls eth in for round
766      * @return airdrop tracker # & airdrop pot
767      */
768     function getCurrentRoundInfo()
769         public
770         view
771         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
772     {
773         // setup local rID
774         uint256 _rID = rID_;
775 
776         return
777         (
778             round_[_rID].ico,               //0
779             _rID,                           //1
780             round_[_rID].keys,              //2
781             round_[_rID].end,               //3
782             round_[_rID].strt,              //4
783             round_[_rID].pot,               //5
784             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
785             plyr_[round_[_rID].plyr].addr,  //7
786             plyr_[round_[_rID].plyr].name,  //8
787             rndTmEth_[_rID][0],             //9
788             rndTmEth_[_rID][1],             //10
789             rndTmEth_[_rID][2],             //11
790             rndTmEth_[_rID][3],             //12
791             airDropTracker_ + (airDropPot_ * 1000)              //13
792         );
793     }
794 
795     /**
796      * @dev returns player info based on address.  if no address is given, it will
797      * use msg.sender
798      * -functionhash- 0xee0b5d8b
799      * @param _addr address of the player you want to lookup
800      * @return player ID
801      * @return player name
802      * @return keys owned (current round)
803      * @return winnings vault
804      * @return general vault
805      * @return affiliate vault
806 	 * @return player round eth
807      */
808     function getPlayerInfoByAddress(address _addr)
809         public
810         view
811         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
812     {
813         // setup local rID
814         uint256 _rID = rID_;
815 
816         if (_addr == address(0))
817         {
818             _addr == msg.sender;
819         }
820         uint256 _pID = pIDxAddr_[_addr];
821 
822         return
823         (
824             _pID,                               //0
825             plyr_[_pID].name,                   //1
826             plyrRnds_[_pID][_rID].keys,         //2
827             plyr_[_pID].win,                    //3
828             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
829             plyr_[_pID].aff,                    //5
830             plyrRnds_[_pID][_rID].eth           //6
831         );
832     }
833 
834 //==============================================================================
835 //     _ _  _ _   | _  _ . _  .
836 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
837 //=====================_|=======================================================
838     /**
839      * @dev logic runs whenever a buy order is executed.  determines how to handle
840      * incoming eth depending on if we are in an active round or not
841      */
842     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
843         private
844     {
845         // setup local rID
846         uint256 _rID = rID_;
847 
848         // grab time
849         uint256 _now = now;
850 
851         // if round is active
852         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
853         {
854             // call core
855             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
856 
857         // if round is not active
858         } else {
859             // check to see if end round needs to be ran
860             if (_now > round_[_rID].end && round_[_rID].ended == false)
861             {
862                 // end the round (distributes pot) & start new round
863 			    round_[_rID].ended = true;
864                 _eventData_ = endRound(_eventData_);
865 
866                 // build event data
867                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
868                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
869 
870                 // fire buy and distribute event
871                 emit F3Devents.onBuyAndDistribute
872                 (
873                     msg.sender,
874                     plyr_[_pID].name,
875                     msg.value,
876                     _eventData_.compressedData,
877                     _eventData_.compressedIDs,
878                     _eventData_.winnerAddr,
879                     _eventData_.winnerName,
880                     _eventData_.amountWon,
881                     _eventData_.newPot,
882                     _eventData_.P3DAmount,
883                     _eventData_.genAmount
884                 );
885             }
886 
887             // put eth in players vault
888             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
889         }
890     }
891 
892     /**
893      * @dev logic runs whenever a reload order is executed.  determines how to handle
894      * incoming eth depending on if we are in an active round or not
895      */
896     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
897         private
898     {
899         // setup local rID
900         uint256 _rID = rID_;
901 
902         // grab time
903         uint256 _now = now;
904 
905         // if round is active
906         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
907         {
908             // get earnings from all vaults and return unused to gen vault
909             // because we use a custom safemath library.  this will throw if player
910             // tried to spend more eth than they have.
911             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
912 
913             // call core
914             core(_rID, _pID, _eth, _affID, _team, _eventData_);
915 
916         // if round is not active and end round needs to be ran
917         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
918             // end the round (distributes pot) & start new round
919             round_[_rID].ended = true;
920             _eventData_ = endRound(_eventData_);
921 
922             // build event data
923             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
924             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
925 
926             // fire buy and distribute event
927             emit F3Devents.onReLoadAndDistribute
928             (
929                 msg.sender,
930                 plyr_[_pID].name,
931                 _eventData_.compressedData,
932                 _eventData_.compressedIDs,
933                 _eventData_.winnerAddr,
934                 _eventData_.winnerName,
935                 _eventData_.amountWon,
936                 _eventData_.newPot,
937                 _eventData_.P3DAmount,
938                 _eventData_.genAmount
939             );
940         }
941     }
942 
943     /**
944      * @dev this is the core logic for any buy/reload that happens while a round
945      * is live.
946      */
947     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
948         private
949     {
950         // if player is new to round
951         if (plyrRnds_[_pID][_rID].keys == 0)
952             _eventData_ = managePlayer(_pID, _eventData_);
953 
954         // early round eth limiter
955         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
956         {
957             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
958             uint256 _refund = _eth.sub(_availableLimit);
959             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
960             _eth = _availableLimit;
961         }
962 
963         // if eth left is greater than min eth allowed (sorry no pocket lint)
964         if (_eth > 1000000000)
965         {
966 
967             // mint the new keys
968             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
969 
970             // if they bought at least 1 whole key
971             if (_keys >= 1000000000000000000)
972             {
973             updateTimer(_keys, _rID);
974 
975             // set new leaders
976             if (round_[_rID].plyr != _pID)
977                 round_[_rID].plyr = _pID;
978             if (round_[_rID].team != _team)
979                 round_[_rID].team = _team;
980 
981             // set the new leader bool to true
982             _eventData_.compressedData = _eventData_.compressedData + 100;
983         }
984 
985             // manage airdrops
986             if (_eth >= 100000000000000000)
987             {
988             airDropTracker_++;
989             if (airdrop() == true)
990             {
991                 // gib muni
992                 uint256 _prize;
993                 if (_eth >= 10000000000000000000)
994                 {
995                     // calculate prize and give it to winner
996                     _prize = ((airDropPot_).mul(75)) / 100;
997                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
998 
999                     // adjust airDropPot
1000                     airDropPot_ = (airDropPot_).sub(_prize);
1001 
1002                     // let event know a tier 3 prize was won
1003                     _eventData_.compressedData += 300000000000000000000000000000000;
1004                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1005                     // calculate prize and give it to winner
1006                     _prize = ((airDropPot_).mul(50)) / 100;
1007                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1008 
1009                     // adjust airDropPot
1010                     airDropPot_ = (airDropPot_).sub(_prize);
1011 
1012                     // let event know a tier 2 prize was won
1013                     _eventData_.compressedData += 200000000000000000000000000000000;
1014                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1015                     // calculate prize and give it to winner
1016                     _prize = ((airDropPot_).mul(25)) / 100;
1017                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1018 
1019                     // adjust airDropPot
1020                     airDropPot_ = (airDropPot_).sub(_prize);
1021 
1022                     // let event know a tier 3 prize was won
1023                     _eventData_.compressedData += 300000000000000000000000000000000;
1024                 }
1025                 // set airdrop happened bool to true
1026                 _eventData_.compressedData += 10000000000000000000000000000000;
1027                 // let event know how much was won
1028                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1029 
1030                 // reset air drop tracker
1031                 airDropTracker_ = 0;
1032             }
1033         }
1034 
1035             // store the air drop tracker number (number of buys since last airdrop)
1036             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1037 
1038             // update player
1039             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1040             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1041 
1042             // update round
1043             round_[_rID].keys = _keys.add(round_[_rID].keys);
1044             round_[_rID].eth = _eth.add(round_[_rID].eth);
1045             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1046 
1047             // distribute eth
1048             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1049             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1050 
1051             // call end tx function to fire end tx event.
1052 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1053         }
1054     }
1055 //==============================================================================
1056 //     _ _ | _   | _ _|_ _  _ _  .
1057 //    (_(_||(_|_||(_| | (_)| _\  .
1058 //==============================================================================
1059     /**
1060      * @dev calculates unmasked earnings (just calculates, does not update mask)
1061      * @return earnings in wei format
1062      */
1063     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1064         private
1065         view
1066         returns(uint256)
1067     {
1068         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1069     }
1070 
1071     /**
1072      * @dev returns the amount of keys you would get given an amount of eth.
1073      * -functionhash- 0xce89c80c
1074      * @param _rID round ID you want price for
1075      * @param _eth amount of eth sent in
1076      * @return keys received
1077      */
1078     function calcKeysReceived(uint256 _rID, uint256 _eth)
1079         public
1080         view
1081         returns(uint256)
1082     {
1083         // grab time
1084         uint256 _now = now;
1085 
1086         // are we in a round?
1087         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1088             return ( (round_[_rID].eth).keysRec(_eth) );
1089         else // rounds over.  need keys for new round
1090             return ( (_eth).keys() );
1091     }
1092 
1093     /**
1094      * @dev returns current eth price for X keys.
1095      * -functionhash- 0xcf808000
1096      * @param _keys number of keys desired (in 18 decimal format)
1097      * @return amount of eth needed to send
1098      */
1099     function iWantXKeys(uint256 _keys)
1100         public
1101         view
1102         returns(uint256)
1103     {
1104         // setup local rID
1105         uint256 _rID = rID_;
1106 
1107         // grab time
1108         uint256 _now = now;
1109 
1110         // are we in a round?
1111         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1112             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1113         else // rounds over.  need price for new round
1114             return ( (_keys).eth() );
1115     }
1116 //==============================================================================
1117 //    _|_ _  _ | _  .
1118 //     | (_)(_)|_\  .
1119 //==============================================================================
1120     /**
1121 	 * @dev receives name/player info from names contract
1122      */
1123     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1124         external
1125     {
1126         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1127         if (pIDxAddr_[_addr] != _pID)
1128             pIDxAddr_[_addr] = _pID;
1129         if (pIDxName_[_name] != _pID)
1130             pIDxName_[_name] = _pID;
1131         if (plyr_[_pID].addr != _addr)
1132             plyr_[_pID].addr = _addr;
1133         if (plyr_[_pID].name != _name)
1134             plyr_[_pID].name = _name;
1135         if (plyr_[_pID].laff != _laff)
1136             plyr_[_pID].laff = _laff;
1137         if (plyrNames_[_pID][_name] == false)
1138             plyrNames_[_pID][_name] = true;
1139     }
1140 
1141     /**
1142      * @dev receives entire player name list
1143      */
1144     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1145         external
1146     {
1147         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1148         if(plyrNames_[_pID][_name] == false)
1149             plyrNames_[_pID][_name] = true;
1150     }
1151 
1152     /**
1153      * @dev gets existing or registers new pID.  use this when a player may be new
1154      * @return pID
1155      */
1156     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1157         private
1158         returns (F3Ddatasets.EventReturns)
1159     {
1160         uint256 _pID = pIDxAddr_[msg.sender];
1161         // if player is new to this version of fomo3d
1162         if (_pID == 0)
1163         {
1164             // grab their player ID, name and last aff ID, from player names contract
1165             _pID = PlayerBook.getPlayerID(msg.sender);
1166             bytes32 _name = PlayerBook.getPlayerName(_pID);
1167             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1168 
1169             // set up player account
1170             pIDxAddr_[msg.sender] = _pID;
1171             plyr_[_pID].addr = msg.sender;
1172 
1173             if (_name != "")
1174             {
1175                 pIDxName_[_name] = _pID;
1176                 plyr_[_pID].name = _name;
1177                 plyrNames_[_pID][_name] = true;
1178             }
1179 
1180             if (_laff != 0 && _laff != _pID)
1181                 plyr_[_pID].laff = _laff;
1182 
1183             // set the new player bool to true
1184             _eventData_.compressedData = _eventData_.compressedData + 1;
1185         }
1186         return (_eventData_);
1187     }
1188 
1189     /**
1190      * @dev checks to make sure user picked a valid team.  if not sets team
1191      * to default (sneks)
1192      */
1193     function verifyTeam(uint256 _team)
1194         private
1195         pure
1196         returns (uint256)
1197     {
1198         if (_team < 0 || _team > 3)
1199             return(2);
1200         else
1201             return(_team);
1202     }
1203 
1204     /**
1205      * @dev decides if round end needs to be run & new round started.  and if
1206      * player unmasked earnings from previously played rounds need to be moved.
1207      */
1208     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1209         private
1210         returns (F3Ddatasets.EventReturns)
1211     {
1212         // if player has played a previous round, move their unmasked earnings
1213         // from that round to gen vault.
1214         if (plyr_[_pID].lrnd != 0)
1215             updateGenVault(_pID, plyr_[_pID].lrnd);
1216 
1217         // update player's last round played
1218         plyr_[_pID].lrnd = rID_;
1219 
1220         // set the joined round bool to true
1221         _eventData_.compressedData = _eventData_.compressedData + 10;
1222 
1223         return(_eventData_);
1224     }
1225 
1226     /**
1227      * @dev ends the round. manages paying out winner/splitting up pot
1228      */
1229     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1230         private
1231         returns (F3Ddatasets.EventReturns)
1232     {
1233         // setup local rID
1234         uint256 _rID = rID_;
1235 
1236         // grab our winning player and team id's
1237         uint256 _winPID = round_[_rID].plyr;
1238         uint256 _winTID = round_[_rID].team;
1239 
1240         // grab our pot amount
1241         uint256 _pot = round_[_rID].pot;
1242 
1243         // calculate our winner share, community rewards, gen share,
1244         // p3d share, and amount reserved for next pot
1245         uint256 _win = (_pot.mul(48)) / 100;
1246         uint256 _com = (_pot / 50);
1247         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1248         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1249         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1250 
1251         // calculate ppt for round mask
1252         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1253         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1254         if (_dust > 0)
1255         {
1256             _gen = _gen.sub(_dust);
1257             _res = _res.add(_dust);
1258         }
1259 
1260         // pay our winner
1261         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1262 
1263         // community rewards
1264 
1265         admin.transfer(_com);
1266 
1267         admin.transfer(_p3d.sub(_p3d / 2));
1268 
1269         round_[_rID].pot = _pot.add(_p3d / 2);
1270 
1271         // distribute gen portion to key holders
1272         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1273 
1274         // prepare event data
1275         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1276         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1277         _eventData_.winnerAddr = plyr_[_winPID].addr;
1278         _eventData_.winnerName = plyr_[_winPID].name;
1279         _eventData_.amountWon = _win;
1280         _eventData_.genAmount = _gen;
1281         _eventData_.P3DAmount = _p3d;
1282         _eventData_.newPot = _res;
1283 
1284         // start next round
1285         rID_++;
1286         _rID++;
1287         round_[_rID].strt = now;
1288         round_[_rID].end = now.add(rndInit_);
1289         round_[_rID].pot = _res;
1290 
1291         return(_eventData_);
1292     }
1293 
1294     /**
1295      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1296      */
1297     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1298         private
1299     {
1300         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1301         if (_earnings > 0)
1302         {
1303             // put in gen vault
1304             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1305             // zero out their earnings by updating mask
1306             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1307         }
1308     }
1309 
1310     /**
1311      * @dev updates round timer based on number of whole keys bought.
1312      */
1313     function updateTimer(uint256 _keys, uint256 _rID)
1314         private
1315     {
1316         // grab time
1317         uint256 _now = now;
1318 
1319         // calculate time based on number of keys bought
1320         uint256 _newTime;
1321         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1322             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1323         else
1324             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1325 
1326         // compare to max and set new end time
1327         if (_newTime < (rndMax_).add(_now))
1328             round_[_rID].end = _newTime;
1329         else
1330             round_[_rID].end = rndMax_.add(_now);
1331     }
1332 
1333     /**
1334      * @dev generates a random number between 0-99 and checks to see if thats
1335      * resulted in an airdrop win
1336      * @return do we have a winner?
1337      */
1338     function airdrop()
1339         private
1340         view
1341         returns(bool)
1342     {
1343         uint256 seed = uint256(keccak256(abi.encodePacked(
1344 
1345             (block.timestamp).add
1346             (block.difficulty).add
1347             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1348             (block.gaslimit).add
1349             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1350             (block.number)
1351 
1352         )));
1353         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1354             return(true);
1355         else
1356             return(false);
1357     }
1358 
1359     /**
1360      * @dev distributes eth based on fees to com, aff, and p3d
1361      */
1362     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1363         private
1364         returns(F3Ddatasets.EventReturns)
1365     {
1366         // pay 5% out to community rewards
1367         uint256 _com = _eth / 20;
1368 
1369 
1370         uint256 _p3d;
1371         if (!address(admin).call.value(_com)())
1372         {
1373             // This ensures Team Just cannot influence the outcome of FoMo3D with
1374             // bank migrations by breaking outgoing transactions.
1375             // Something we would never do. But that's not the point.
1376             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1377             // highest belief that everything we create should be trustless.
1378             // Team JUST, The name you shouldn't have to trust.
1379             _p3d = _com;
1380             _com = 0;
1381         }
1382 
1383 
1384         // distribute share to affiliate
1385         uint256 _aff = (8 * _eth) / 100;
1386 
1387         // decide what to do with affiliate share of fees
1388         // affiliate must not be self, and must have a name registered
1389         if (_affID != _pID && plyr_[_affID].name != '') {
1390             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1391             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1392         } else {
1393             _p3d = _aff;
1394         }
1395 
1396         // pay out p3d
1397         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1398         if (_p3d > 0)
1399         {
1400             // deposit to divies contract
1401             uint256 _potAmount = _p3d / 2;
1402 
1403             admin.transfer(_p3d.sub(_potAmount));
1404 
1405             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1406 
1407             // set up event data
1408             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1409         }
1410 
1411         return(_eventData_);
1412     }
1413 
1414     function potSwap()
1415         external
1416         payable
1417     {
1418         // setup local rID
1419         uint256 _rID = rID_ + 1;
1420 
1421         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1422         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1423     }
1424 
1425     /**
1426      * @dev distributes eth based on fees to gen and pot
1427      */
1428     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1429         private
1430         returns(F3Ddatasets.EventReturns)
1431     {
1432         // calculate gen share
1433         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1434 
1435         // toss 1% into airdrop pot
1436         uint256 _air = (_eth / 100);
1437         airDropPot_ = airDropPot_.add(_air);
1438 
1439         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1440         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1441 
1442         // calculate pot
1443         uint256 _pot = _eth.sub(_gen);
1444 
1445         // distribute gen share (thats what updateMasks() does) and adjust
1446         // balances for dust.
1447         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1448         if (_dust > 0)
1449             _gen = _gen.sub(_dust);
1450 
1451         // add eth to pot
1452         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1453 
1454         // set up event data
1455         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1456         _eventData_.potAmount = _pot;
1457 
1458         return(_eventData_);
1459     }
1460 
1461     /**
1462      * @dev updates masks for round and player when keys are bought
1463      * @return dust left over
1464      */
1465     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1466         private
1467         returns(uint256)
1468     {
1469         /* MASKING NOTES
1470             earnings masks are a tricky thing for people to wrap their minds around.
1471             the basic thing to understand here.  is were going to have a global
1472             tracker based on profit per share for each round, that increases in
1473             relevant proportion to the increase in share supply.
1474 
1475             the player will have an additional mask that basically says "based
1476             on the rounds mask, my shares, and how much i've already withdrawn,
1477             how much is still owed to me?"
1478         */
1479 
1480         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1481         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1482         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1483 
1484         // calculate player earning from their own buy (only based on the keys
1485         // they just bought).  & update player earnings mask
1486         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1487         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1488 
1489         // calculate & return dust
1490         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1491     }
1492 
1493     /**
1494      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1495      * @return earnings in wei format
1496      */
1497     function withdrawEarnings(uint256 _pID)
1498         private
1499         returns(uint256)
1500     {
1501         // update gen vault
1502         updateGenVault(_pID, plyr_[_pID].lrnd);
1503 
1504         // from vaults
1505         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1506         if (_earnings > 0)
1507         {
1508             plyr_[_pID].win = 0;
1509             plyr_[_pID].gen = 0;
1510             plyr_[_pID].aff = 0;
1511         }
1512 
1513         return(_earnings);
1514     }
1515 
1516     /**
1517      * @dev prepares compression data and fires event for buy or reload tx's
1518      */
1519     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1520         private
1521     {
1522         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1523         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1524 
1525         emit F3Devents.onEndTx
1526         (
1527             _eventData_.compressedData,
1528             _eventData_.compressedIDs,
1529             plyr_[_pID].name,
1530             msg.sender,
1531             _eth,
1532             _keys,
1533             _eventData_.winnerAddr,
1534             _eventData_.winnerName,
1535             _eventData_.amountWon,
1536             _eventData_.newPot,
1537             _eventData_.P3DAmount,
1538             _eventData_.genAmount,
1539             _eventData_.potAmount,
1540             airDropPot_
1541         );
1542     }
1543 //==============================================================================
1544 //    (~ _  _    _._|_    .
1545 //    _)(/_(_|_|| | | \/  .
1546 //====================/=========================================================
1547     /** upon contract deploy, it will be deactivated.  this is a one time
1548      * use function that will activate the contract.  we do this so devs
1549      * have time to set things up on the web end                            **/
1550     bool public activated_ = false;
1551     function activate()
1552         public
1553     {
1554         // only team just can activate
1555         require(msg.sender == admin, "only admin can activate");
1556 
1557 
1558         // can only be ran once
1559         require(activated_ == false, "FOMO Short already activated");
1560 
1561         // activate the contract
1562         activated_ = true;
1563 
1564         // lets start first round
1565         rID_ = 1;
1566             round_[1].strt = now;
1567             round_[1].end = round_[1].strt + rndInit_;
1568     }
1569 }
1570 
1571 //==============================================================================
1572 //   __|_ _    __|_ _  .
1573 //  _\ | | |_|(_ | _\  .
1574 //==============================================================================
1575 library F3Ddatasets {
1576     //compressedData key
1577     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1578         // 0 - new player (bool)
1579         // 1 - joined round (bool)
1580         // 2 - new  leader (bool)
1581         // 3-5 - air drop tracker (uint 0-999)
1582         // 6-16 - round end time
1583         // 17 - winnerTeam
1584         // 18 - 28 timestamp
1585         // 29 - team
1586         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1587         // 31 - airdrop happened bool
1588         // 32 - airdrop tier
1589         // 33 - airdrop amount won
1590     //compressedIDs key
1591     // [77-52][51-26][25-0]
1592         // 0-25 - pID
1593         // 26-51 - winPID
1594         // 52-77 - rID
1595     struct EventReturns {
1596         uint256 compressedData;
1597         uint256 compressedIDs;
1598         address winnerAddr;         // winner address
1599         bytes32 winnerName;         // winner name
1600         uint256 amountWon;          // amount won
1601         uint256 newPot;             // amount in new pot
1602         uint256 P3DAmount;          // amount distributed to p3d
1603         uint256 genAmount;          // amount distributed to gen
1604         uint256 potAmount;          // amount added to pot
1605     }
1606     struct Player {
1607         address addr;   // player address
1608         bytes32 name;   // player name
1609         uint256 win;    // winnings vault
1610         uint256 gen;    // general vault
1611         uint256 aff;    // affiliate vault
1612         uint256 lrnd;   // last round played
1613         uint256 laff;   // last affiliate id used
1614     }
1615     struct PlayerRounds {
1616         uint256 eth;    // eth player has added to round (used for eth limiter)
1617         uint256 keys;   // keys
1618         uint256 mask;   // player mask
1619         uint256 ico;    // ICO phase investment
1620     }
1621     struct Round {
1622         uint256 plyr;   // pID of player in lead
1623         uint256 team;   // tID of team in lead
1624         uint256 end;    // time ends/ended
1625         bool ended;     // has round end function been ran
1626         uint256 strt;   // time round started
1627         uint256 keys;   // keys
1628         uint256 eth;    // total eth in
1629         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1630         uint256 mask;   // global mask
1631         uint256 ico;    // total eth sent in during ICO phase
1632         uint256 icoGen; // total eth for gen during ICO phase
1633         uint256 icoAvg; // average key price for ICO phase
1634     }
1635     struct TeamFee {
1636         uint256 gen;    // % of buy in thats paid to key holders of current round
1637         uint256 p3d;    // % of buy in thats paid to p3d holders
1638     }
1639     struct PotSplit {
1640         uint256 gen;    // % of pot thats paid to key holders of current round
1641         uint256 p3d;    // % of pot thats paid to p3d holders
1642     }
1643 }
1644 
1645 //==============================================================================
1646 //  |  _      _ _ | _  .
1647 //  |<(/_\/  (_(_||(_  .
1648 //=======/======================================================================
1649 library F3DKeysCalcShort {
1650     using SafeMath for *;
1651     /**
1652      * @dev calculates number of keys received given X eth
1653      * @param _curEth current amount of eth in contract
1654      * @param _newEth eth being spent
1655      * @return amount of ticket purchased
1656      */
1657     function keysRec(uint256 _curEth, uint256 _newEth)
1658         internal
1659         pure
1660         returns (uint256)
1661     {
1662         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1663     }
1664 
1665     /**
1666      * @dev calculates amount of eth received if you sold X keys
1667      * @param _curKeys current amount of keys that exist
1668      * @param _sellKeys amount of keys you wish to sell
1669      * @return amount of eth received
1670      */
1671     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1672         internal
1673         pure
1674         returns (uint256)
1675     {
1676         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1677     }
1678 
1679     /**
1680      * @dev calculates how many keys would exist with given an amount of eth
1681      * @param _eth eth "in contract"
1682      * @return number of keys that would exist
1683      */
1684     function keys(uint256 _eth)
1685         internal
1686         pure
1687         returns(uint256)
1688     {
1689         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1690     }
1691 
1692     /**
1693      * @dev calculates how much eth would be in contract given a number of keys
1694      * @param _keys number of keys "in contract"
1695      * @return eth that would exists
1696      */
1697     function eth(uint256 _keys)
1698         internal
1699         pure
1700         returns(uint256)
1701     {
1702         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1703     }
1704 }
1705 
1706 //==============================================================================
1707 //  . _ _|_ _  _ |` _  _ _  _  .
1708 //  || | | (/_| ~|~(_|(_(/__\  .
1709 //==============================================================================
1710 
1711 interface F3DexternalSettingsInterface {
1712     function getFastGap() external returns(uint256);
1713     function getLongGap() external returns(uint256);
1714     function getFastExtra() external returns(uint256);
1715     function getLongExtra() external returns(uint256);
1716 }
1717 
1718 interface PlayerBookInterface {
1719     function getPlayerID(address _addr) external returns (uint256);
1720     function getPlayerName(uint256 _pID) external view returns (bytes32);
1721     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1722     function getPlayerAddr(uint256 _pID) external view returns (address);
1723     function getNameFee() external view returns (uint256);
1724     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1725     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1726     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1727 }
1728 
1729 /**
1730 * @title -Name Filter- v0.1.9
1731 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1732 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1733 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1734 *                                  _____                      _____
1735 *                                 (, /     /)       /) /)    (, /      /)          /)
1736 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1737 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1738 *          ┴ ┴                /   /          .-/ _____   (__ /
1739 *                            (__ /          (_/ (, /                                      /)™
1740 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1741 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1742 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1743 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1744 *              _       __    _      ____      ____  _   _    _____  ____  ___
1745 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1746 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1747 *
1748 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1749 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1750 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1751 */
1752 
1753 library NameFilter {
1754     /**
1755      * @dev filters name strings
1756      * -converts uppercase to lower case.
1757      * -makes sure it does not start/end with a space
1758      * -makes sure it does not contain multiple spaces in a row
1759      * -cannot be only numbers
1760      * -cannot start with 0x
1761      * -restricts characters to A-Z, a-z, 0-9, and space.
1762      * @return reprocessed string in bytes32 format
1763      */
1764     function nameFilter(string _input)
1765         internal
1766         pure
1767         returns(bytes32)
1768     {
1769         bytes memory _temp = bytes(_input);
1770         uint256 _length = _temp.length;
1771 
1772         //sorry limited to 32 characters
1773         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1774         // make sure it doesnt start with or end with space
1775         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1776         // make sure first two characters are not 0x
1777         if (_temp[0] == 0x30)
1778         {
1779             require(_temp[1] != 0x78, "string cannot start with 0x");
1780             require(_temp[1] != 0x58, "string cannot start with 0X");
1781         }
1782 
1783         // create a bool to track if we have a non number character
1784         bool _hasNonNumber;
1785 
1786         // convert & check
1787         for (uint256 i = 0; i < _length; i++)
1788         {
1789             // if its uppercase A-Z
1790             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1791             {
1792                 // convert to lower case a-z
1793                 _temp[i] = byte(uint(_temp[i]) + 32);
1794 
1795                 // we have a non number
1796                 if (_hasNonNumber == false)
1797                     _hasNonNumber = true;
1798             } else {
1799                 require
1800                 (
1801                     // require character is a space
1802                     _temp[i] == 0x20 ||
1803                     // OR lowercase a-z
1804                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1805                     // or 0-9
1806                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1807                     "string contains invalid characters"
1808                 );
1809                 // make sure theres not 2x spaces in a row
1810                 if (_temp[i] == 0x20)
1811                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1812 
1813                 // see if we have a character other than a number
1814                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1815                     _hasNonNumber = true;
1816             }
1817         }
1818 
1819         require(_hasNonNumber == true, "string cannot be only numbers");
1820 
1821         bytes32 _ret;
1822         assembly {
1823             _ret := mload(add(_temp, 32))
1824         }
1825         return (_ret);
1826     }
1827 }
1828 
1829 /**
1830  * @title SafeMath v0.1.9
1831  * @dev Math operations with safety checks that throw on error
1832  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1833  * - added sqrt
1834  * - added sq
1835  * - added pwr
1836  * - changed asserts to requires with error log outputs
1837  * - removed div, its useless
1838  */
1839 library SafeMath {
1840 
1841     /**
1842     * @dev Multiplies two numbers, throws on overflow.
1843     */
1844     function mul(uint256 a, uint256 b)
1845         internal
1846         pure
1847         returns (uint256 c)
1848     {
1849         if (a == 0) {
1850             return 0;
1851         }
1852         c = a * b;
1853         require(c / a == b, "SafeMath mul failed");
1854         return c;
1855     }
1856 
1857     /**
1858     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1859     */
1860     function sub(uint256 a, uint256 b)
1861         internal
1862         pure
1863         returns (uint256)
1864     {
1865         require(b <= a, "SafeMath sub failed");
1866         return a - b;
1867     }
1868 
1869     /**
1870     * @dev Adds two numbers, throws on overflow.
1871     */
1872     function add(uint256 a, uint256 b)
1873         internal
1874         pure
1875         returns (uint256 c)
1876     {
1877         c = a + b;
1878         require(c >= a, "SafeMath add failed");
1879         return c;
1880     }
1881 
1882     /**
1883      * @dev gives square root of given x.
1884      */
1885     function sqrt(uint256 x)
1886         internal
1887         pure
1888         returns (uint256 y)
1889     {
1890         uint256 z = ((add(x,1)) / 2);
1891         y = x;
1892         while (z < y)
1893         {
1894             y = z;
1895             z = ((add((x / z),z)) / 2);
1896         }
1897     }
1898 
1899     /**
1900      * @dev gives square. multiplies x by x
1901      */
1902     function sq(uint256 x)
1903         internal
1904         pure
1905         returns (uint256)
1906     {
1907         return (mul(x,x));
1908     }
1909 
1910     /**
1911      * @dev x to the power of y
1912      */
1913     function pwr(uint256 x, uint256 y)
1914         internal
1915         pure
1916         returns (uint256)
1917     {
1918         if (x==0)
1919             return (0);
1920         else if (y==0)
1921             return (1);
1922         else
1923         {
1924             uint256 z = x;
1925             for (uint256 i=1; i < y; i++)
1926                 z = mul(z,x);
1927             return (z);
1928         }
1929     }
1930 }