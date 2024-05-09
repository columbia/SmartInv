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
123 contract ReFoMoMe is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcShort for uint256;
127 
128     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x90EddCe88d54dAfd22eC724727bA1181BcfD23F0);
129 
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     address private admin = msg.sender;
135     string constant public name = "Fomo3D (Rebirth)";
136     string constant public symbol = "F3D";
137     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
138     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
139     uint256 constant private rndInit_ = 7 hours;              // round timer starts at this
140     uint256 constant private rndInc_ = 37 seconds;              // every full key purchased adds this much to the timer
141     uint256 constant private rndMax_ = 24 hours;              // max length a round timer can be
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
181         // (F3D) + (Pot , Referrals, Community)
182         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
183         fees_[0] = F3Ddatasets.TeamFee(20,0);   //20% to key holders, 66% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
184         fees_[1] = F3Ddatasets.TeamFee(33,0);   //33% to key holders, 53% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
185         fees_[2] = F3Ddatasets.TeamFee(64,0);   //64% to key holders, 22% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
186         fees_[3] = F3Ddatasets.TeamFee(37,0);   //37% to key holders, 49% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
187         
188         // how to split up the final pot based on which team was picked
189         potSplit_[0] = F3Ddatasets.PotSplit(30,0);  //48% to winner, 20% to next round, 2% to com
190         potSplit_[1] = F3Ddatasets.PotSplit(20,0);  //48% to winner, 30% to next round, 2% to com
191         potSplit_[2] = F3Ddatasets.PotSplit(10,0);  //48% to winner, 40% to next round, 2% to com
192         potSplit_[3] = F3Ddatasets.PotSplit(20,0);  //48% to winner, 30% to next round, 2% to com
193 	}
194 //==============================================================================
195 //     _ _  _  _|. |`. _  _ _  .
196 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
197 //==============================================================================
198     /**
199      * @dev used to make sure no one can interact with contract until it has
200      * been activated.
201      */
202     modifier isActivated() {
203         require(activated_ == true, "its not ready yet.  check ?eta in discord");
204         _;
205     }
206 
207     /**
208      * @dev prevents contracts from interacting with fomo3d
209      */
210     modifier isHuman() {
211         address _addr = msg.sender;
212         uint256 _codeLength;
213 
214         assembly {_codeLength := extcodesize(_addr)}
215         require(_codeLength == 0, "sorry humans only");
216         _;
217     }
218 
219     /**
220      * @dev sets boundaries for incoming tx
221      */
222     modifier isWithinLimits(uint256 _eth) {
223         require(_eth >= 1000000000, "pocket lint: not a valid currency");
224         require(_eth <= 100000000000000000000000, "no vitalik, no");
225         _;
226     }
227 
228 //==============================================================================
229 //     _    |_ |. _   |`    _  __|_. _  _  _  .
230 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
231 //====|=========================================================================
232     /**
233      * @dev emergency buy uses last stored affiliate ID and team snek
234      */
235     function()
236         isActivated()
237         isHuman()
238         isWithinLimits(msg.value)
239         public
240         payable
241     {
242         // set up our tx event data and determine if player is new or not
243         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
244 
245         // fetch player id
246         uint256 _pID = pIDxAddr_[msg.sender];
247 
248         // buy core
249         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
250     }
251 
252     /**
253      * @dev converts all incoming ethereum to keys.
254      * -functionhash- 0x8f38f309 (using ID for affiliate)
255      * -functionhash- 0x98a0871d (using address for affiliate)
256      * -functionhash- 0xa65b37a1 (using name for affiliate)
257      * @param _affCode the ID/address/name of the player who gets the affiliate fee
258      * @param _team what team is the player playing for?
259      */
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
277             _affCode = plyr_[_pID].laff;
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
309             _affID = plyr_[_pID].laff;
310         // if affiliate code was given
311         } else {
312             // get affiliate ID from aff Code
313             _affID = pIDxAddr_[_affCode];
314 
315             // if affID is not the same as previously stored
316             if (_affID != plyr_[_pID].laff)
317             {
318                 // update last affiliate
319                 plyr_[_pID].laff = _affID;
320             }
321         }
322 
323         // verify a valid team was selected
324         _team = verifyTeam(_team);
325 
326         // buy core
327         buyCore(_pID, _affID, _team, _eventData_);
328     }
329 
330     function buyXname(bytes32 _affCode, uint256 _team)
331         isActivated()
332         isHuman()
333         isWithinLimits(msg.value)
334         public
335         payable
336     {
337         // set up our tx event data and determine if player is new or not
338         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
339 
340         // fetch player id
341         uint256 _pID = pIDxAddr_[msg.sender];
342 
343         // manage affiliate residuals
344         uint256 _affID;
345         // if no affiliate code was given or player tried to use their own, lolz
346         if (_affCode == '' || _affCode == plyr_[_pID].name)
347         {
348             _affCode = 0x6e6f6e6500000000000000000000000000000000000000000000000000000000;
349         // if affiliate code was given
350         } else {
351             // get affiliate ID from aff Code
352             _affID = pIDxName_[_affCode];
353 
354             // if affID is not the same as previously stored
355             if (_affID != plyr_[_pID].laff)
356             {
357                 // update last affiliate
358                 plyr_[_pID].laff = _affID;
359             }
360         }
361 
362         // verify a valid team was selected
363         _team = verifyTeam(_team);
364 
365         // buy core
366         buyCore(_pID, _affID, _team, _eventData_);
367     }
368 
369     /**
370      * @dev essentially the same as buy, but instead of you sending ether
371      * from your wallet, it uses your unwithdrawn earnings.
372      * -functionhash- 0x349cdcac (using ID for affiliate)
373      * -functionhash- 0x82bfc739 (using address for affiliate)
374      * -functionhash- 0x079ce327 (using name for affiliate)
375      * @param _affCode the ID/address/name of the player who gets the affiliate fee
376      * @param _team what team is the player playing for?
377      * @param _eth amount of earnings to use (remainder returned to gen vault)
378      */
379     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
380         isActivated()
381         isHuman()
382         isWithinLimits(_eth)
383         public
384     {
385         // set up our tx event data
386         F3Ddatasets.EventReturns memory _eventData_;
387 
388         // fetch player ID
389         uint256 _pID = pIDxAddr_[msg.sender];
390 
391         // manage affiliate residuals
392         // if no affiliate code was given or player tried to use their own, lolz
393         if (_affCode == 0 || _affCode == _pID)
394         {
395             _affCode = plyr_[_pID].laff;
396         // if affiliate code was given & its not the same as previously stored
397         } else if (_affCode != plyr_[_pID].laff) {
398             // update last affiliate
399             plyr_[_pID].laff = _affCode;
400         }
401 
402         // verify a valid team was selected
403         _team = verifyTeam(_team);
404 
405         // reload core
406         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
407     }
408 
409     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
410         isActivated()
411         isHuman()
412         isWithinLimits(_eth)
413         public
414     {
415         // set up our tx event data
416         F3Ddatasets.EventReturns memory _eventData_;
417 
418         // fetch player ID
419         uint256 _pID = pIDxAddr_[msg.sender];
420 
421         // manage affiliate residuals
422         uint256 _affID;
423         // if no affiliate code was given or player tried to use their own, lolz
424         if (_affCode == address(0) || _affCode == msg.sender)
425         {
426             _affID = plyr_[_pID].laff;
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
464             _affCode = 0x6e6f6e6500000000000000000000000000000000000000000000000000000000;
465         // if affiliate code was given
466         } else {
467             // get affiliate ID from aff Code
468             _affID = pIDxName_[_affCode];
469 
470             // if affID is not the same as previously stored
471             if (_affID != plyr_[_pID].laff)
472             {
473                 // update last affiliate
474                 plyr_[_pID].laff = _affID;
475             }
476         }
477 
478         // verify a valid team was selected
479         _team = verifyTeam(_team);
480 
481         // reload core
482         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
483     }
484 
485     /**
486      * @dev withdraws all of your earnings.
487      * -functionhash- 0x3ccfd60b
488      */
489     function withdraw()
490         isActivated()
491         isHuman()
492         public
493     {
494         // setup local rID
495         uint256 _rID = rID_;
496 
497         // grab time
498         uint256 _now = now;
499 
500         // fetch player ID
501         uint256 _pID = pIDxAddr_[msg.sender];
502 
503         // setup temp var for player eth
504         uint256 _eth;
505 
506         // check to see if round has ended and no one has run round end yet
507         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
508         {
509             // set up our tx event data
510             F3Ddatasets.EventReturns memory _eventData_;
511 
512             // end the round (distributes pot)
513 			round_[_rID].ended = true;
514             _eventData_ = endRound(_eventData_);
515 
516 			// get their earnings
517             _eth = withdrawEarnings(_pID);
518 
519             // gib moni
520             if (_eth > 0)
521                 plyr_[_pID].addr.transfer(_eth);
522 
523             // build event data
524             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
525             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
526 
527             // fire withdraw and distribute event
528             emit F3Devents.onWithdrawAndDistribute
529             (
530                 msg.sender,
531                 plyr_[_pID].name,
532                 _eth,
533                 _eventData_.compressedData,
534                 _eventData_.compressedIDs,
535                 _eventData_.winnerAddr,
536                 _eventData_.winnerName,
537                 _eventData_.amountWon,
538                 _eventData_.newPot,
539                 _eventData_.P3DAmount,
540                 _eventData_.genAmount
541             );
542 
543         // in any other situation
544         } else {
545             // get their earnings
546             _eth = withdrawEarnings(_pID);
547 
548             // gib moni
549             if (_eth > 0)
550                 plyr_[_pID].addr.transfer(_eth);
551 
552             // fire withdraw event
553             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
554         }
555     }
556 
557     /**
558      * @dev use these to register names.  they are just wrappers that will send the
559      * registration requests to the PlayerBook contract.  So registering here is the
560      * same as registering there.  UI will always display the last name you registered.
561      * but you will still own all previously registered names to use as affiliate
562      * links.
563      * - must pay a registration fee.
564      * - name must be unique
565      * - names will be converted to lowercase
566      * - name cannot start or end with a space
567      * - cannot have more than 1 space in a row
568      * - cannot be only numbers
569      * - cannot start with 0x
570      * - name must be at least 1 char
571      * - max length of 32 characters long
572      * - allowed characters: a-z, 0-9, and space
573      * -functionhash- 0x921dec21 (using ID for affiliate)
574      * -functionhash- 0x3ddd4698 (using address for affiliate)
575      * -functionhash- 0x685ffd83 (using name for affiliate)
576      * @param _nameString players desired name
577      * @param _affCode affiliate ID, address, or name of who referred you
578      * @param _all set to true if you want this to push your info to all games
579      * (this might cost a lot of gas)
580      */
581     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
582         isHuman()
583         public
584         payable
585     {
586         bytes32 _name = _nameString.nameFilter();
587         address _addr = msg.sender;
588         uint256 _paid = msg.value;
589         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
590 
591         uint256 _pID = pIDxAddr_[_addr];
592 
593         // fire event
594         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
595     }
596 
597     function registerNameXaddr(string _nameString, address _affCode, bool _all)
598         isHuman()
599         public
600         payable
601     {
602         bytes32 _name = _nameString.nameFilter();
603         address _addr = msg.sender;
604         uint256 _paid = msg.value;
605         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
606 
607         uint256 _pID = pIDxAddr_[_addr];
608 
609         // fire event
610         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
611     }
612 
613     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
614         isHuman()
615         public
616         payable
617     {
618         bytes32 _name = _nameString.nameFilter();
619         address _addr = msg.sender;
620         uint256 _paid = msg.value;
621         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
622 
623         uint256 _pID = pIDxAddr_[_addr];
624 
625         // fire event
626         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
627     }
628 //==============================================================================
629 //     _  _ _|__|_ _  _ _  .
630 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
631 //=====_|=======================================================================
632     /**
633      * @dev return the price buyer will pay for next 1 individual key.
634      * -functionhash- 0x018a25e8
635      * @return price for next key bought (in wei format)
636      */
637     function getBuyPrice()
638         public
639         view
640         returns(uint256)
641     {
642         // setup local rID
643         uint256 _rID = rID_;
644 
645         // grab time
646         uint256 _now = now;
647 
648         // are we in a round?
649         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
650             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
651         else // rounds over.  need price for new round
652             return ( 75000000000000 ); // init
653     }
654 
655     /**
656      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
657      * provider
658      * -functionhash- 0xc7e284b8
659      * @return time left in seconds
660      */
661     function getTimeLeft()
662         public
663         view
664         returns(uint256)
665     {
666         // setup local rID
667         uint256 _rID = rID_;
668 
669         // grab time
670         uint256 _now = now;
671 
672         if (_now < round_[_rID].end)
673             if (_now < round_[_rID].strt + rndGap_)
674                 return( (round_[_rID].strt + rndGap_).sub(_now));
675             else 
676                 return( (round_[_rID].end).sub(_now) );
677         else
678             return(0);
679     }
680 
681     /**
682      * @dev returns player earnings per vaults
683      * -functionhash- 0x63066434
684      * @return winnings vault
685      * @return general vault
686      * @return affiliate vault
687      */
688     function getPlayerVaults(uint256 _pID)
689         public
690         view
691         returns(uint256 ,uint256, uint256)
692     {
693         // setup local rID
694         uint256 _rID = rID_;
695 
696         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
697         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
698         {
699             // if player is winner
700             if (round_[_rID].plyr == _pID)
701             {
702                 return
703                 (
704                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
705                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
706                     plyr_[_pID].aff
707                 );
708             // if player is not the winner
709             } else {
710                 return
711                 (
712                     plyr_[_pID].win,
713                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
714                     plyr_[_pID].aff
715                 );
716             }
717 
718         // if round is still going on, or round has ended and round end has been ran
719         } else {
720             return
721             (
722                 plyr_[_pID].win,
723                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
724                 plyr_[_pID].aff
725             );
726         }
727     }
728 
729     /**
730      * solidity hates stack limits.  this lets us avoid that hate
731      */
732     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
733         private
734         view
735         returns(uint256)
736     {
737         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
738     }
739 
740     /**
741      * @dev returns all current round info needed for front end
742      * -functionhash- 0x747dff42
743      * @return eth invested during ICO phase
744      * @return round id
745      * @return total keys for round
746      * @return time round ends
747      * @return time round started
748      * @return current pot
749      * @return current team ID & player ID in lead
750      * @return current player in leads address
751      * @return current player in leads name
752      * @return whales eth in for round
753      * @return bears eth in for round
754      * @return sneks eth in for round
755      * @return bulls eth in for round
756      * @return airdrop tracker # & airdrop pot
757      */
758     function getCurrentRoundInfo()
759         public
760         view
761         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
762     {
763         // setup local rID
764         uint256 _rID = rID_;
765 
766         return
767         (
768             round_[_rID].ico,               //0
769             _rID,                           //1
770             round_[_rID].keys,              //2
771             round_[_rID].end,               //3
772             round_[_rID].strt,              //4
773             round_[_rID].pot,               //5
774             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
775             plyr_[round_[_rID].plyr].addr,  //7
776             plyr_[round_[_rID].plyr].name,  //8
777             rndTmEth_[_rID][0],             //9
778             rndTmEth_[_rID][1],             //10
779             rndTmEth_[_rID][2],             //11
780             rndTmEth_[_rID][3],             //12
781             airDropTracker_ + (airDropPot_ * 1000)              //13
782         );
783     }
784 
785     /**
786      * @dev returns player info based on address.  if no address is given, it will
787      * use msg.sender
788      * -functionhash- 0xee0b5d8b
789      * @param _addr address of the player you want to lookup
790      * @return player ID
791      * @return player name
792      * @return keys owned (current round)
793      * @return winnings vault
794      * @return general vault
795      * @return affiliate vault
796 	 * @return player round eth
797      */
798     function getPlayerInfoByAddress(address _addr)
799         public
800         view
801         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
802     {
803         // setup local rID
804         uint256 _rID = rID_;
805 
806         if (_addr == address(0))
807         {
808             _addr == msg.sender;
809         }
810         uint256 _pID = pIDxAddr_[_addr];
811 
812         return
813         (
814             _pID,                               //0
815             plyr_[_pID].name,                   //1
816             plyrRnds_[_pID][_rID].keys,         //2
817             plyr_[_pID].win,                    //3
818             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
819             plyr_[_pID].aff,                    //5
820             plyrRnds_[_pID][_rID].eth           //6
821         );
822     }
823 
824 //==============================================================================
825 //     _ _  _ _   | _  _ . _  .
826 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
827 //=====================_|=======================================================
828     /**
829      * @dev logic runs whenever a buy order is executed.  determines how to handle
830      * incoming eth depending on if we are in an active round or not
831      */
832     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
833         private
834     {
835         // setup local rID
836         uint256 _rID = rID_;
837 
838         // grab time
839         uint256 _now = now;
840 
841         // if round is active
842         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
843         {
844             // call core
845             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
846 
847         // if round is not active
848         } else {
849             // check to see if end round needs to be ran
850             if (_now > round_[_rID].end && round_[_rID].ended == false)
851             {
852                 // end the round (distributes pot) & start new round
853 			    round_[_rID].ended = true;
854                 _eventData_ = endRound(_eventData_);
855 
856                 // build event data
857                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
858                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
859 
860                 // fire buy and distribute event
861                 emit F3Devents.onBuyAndDistribute
862                 (
863                     msg.sender,
864                     plyr_[_pID].name,
865                     msg.value,
866                     _eventData_.compressedData,
867                     _eventData_.compressedIDs,
868                     _eventData_.winnerAddr,
869                     _eventData_.winnerName,
870                     _eventData_.amountWon,
871                     _eventData_.newPot,
872                     _eventData_.P3DAmount,
873                     _eventData_.genAmount
874                 );
875             }
876 
877             // put eth in players vault
878             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
879         }
880     }
881 
882     /**
883      * @dev logic runs whenever a reload order is executed.  determines how to handle
884      * incoming eth depending on if we are in an active round or not
885      */
886     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
887         private
888     {
889         // setup local rID
890         uint256 _rID = rID_;
891 
892         // grab time
893         uint256 _now = now;
894 
895         // if round is active
896         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
897         {
898             // get earnings from all vaults and return unused to gen vault
899             // because we use a custom safemath library.  this will throw if player
900             // tried to spend more eth than they have.
901             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
902 
903             // call core
904             core(_rID, _pID, _eth, _affID, _team, _eventData_);
905 
906         // if round is not active and end round needs to be ran
907         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
908             // end the round (distributes pot) & start new round
909             round_[_rID].ended = true;
910             _eventData_ = endRound(_eventData_);
911 
912             // build event data
913             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
914             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
915 
916             // fire buy and distribute event
917             emit F3Devents.onReLoadAndDistribute
918             (
919                 msg.sender,
920                 plyr_[_pID].name,
921                 _eventData_.compressedData,
922                 _eventData_.compressedIDs,
923                 _eventData_.winnerAddr,
924                 _eventData_.winnerName,
925                 _eventData_.amountWon,
926                 _eventData_.newPot,
927                 _eventData_.P3DAmount,
928                 _eventData_.genAmount
929             );
930         }
931     }
932 
933     /**
934      * @dev this is the core logic for any buy/reload that happens while a round
935      * is live.
936      */
937     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
938         private
939     {
940         // if player is new to round
941         if (plyrRnds_[_pID][_rID].keys == 0)
942             _eventData_ = managePlayer(_pID, _eventData_);
943 
944         // early round eth limiter
945         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 2100000000000000000000)
946         {
947             uint256 _availableLimit = (2100000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
948             uint256 _refund = _eth.sub(_availableLimit);
949             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
950             _eth = _availableLimit;
951         }
952 
953         // if eth left is greater than min eth allowed (sorry no pocket lint)
954         if (_eth > 1000000000)
955         {
956 
957             // mint the new keys
958             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
959 
960             // if they bought at least 1 whole key
961             if (_keys >= 1000000000000000000)
962             {
963             updateTimer(_keys, _rID);
964 
965             // set new leaders
966             if (round_[_rID].plyr != _pID)
967                 round_[_rID].plyr = _pID;
968             if (round_[_rID].team != _team)
969                 round_[_rID].team = _team;
970 
971             // set the new leader bool to true
972             _eventData_.compressedData = _eventData_.compressedData + 100;
973         }
974 
975             // manage airdrops
976             if (_eth >= 100000000000000000)
977             {
978             airDropTracker_++;
979             if (airdrop() == true)
980             {
981                 // gib muni
982                 uint256 _prize;
983                 if (_eth >= 10000000000000000000)
984                 {
985                     // calculate prize and give it to winner
986                     _prize = ((airDropPot_).mul(75)) / 100;
987                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
988 
989                     // adjust airDropPot
990                     airDropPot_ = (airDropPot_).sub(_prize);
991 
992                     // let event know a tier 3 prize was won
993                     _eventData_.compressedData += 300000000000000000000000000000000;
994                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
995                     // calculate prize and give it to winner
996                     _prize = ((airDropPot_).mul(50)) / 100;
997                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
998 
999                     // adjust airDropPot
1000                     airDropPot_ = (airDropPot_).sub(_prize);
1001 
1002                     // let event know a tier 2 prize was won
1003                     _eventData_.compressedData += 200000000000000000000000000000000;
1004                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1005                     // calculate prize and give it to winner
1006                     _prize = ((airDropPot_).mul(25)) / 100;
1007                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1008 
1009                     // adjust airDropPot
1010                     airDropPot_ = (airDropPot_).sub(_prize);
1011 
1012                     // let event know a tier 3 prize was won
1013                     _eventData_.compressedData += 300000000000000000000000000000000;
1014                 }
1015                 // set airdrop happened bool to true
1016                 _eventData_.compressedData += 10000000000000000000000000000000;
1017                 // let event know how much was won
1018                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1019 
1020                 // reset air drop tracker
1021                 airDropTracker_ = 0;
1022             }
1023         }
1024 
1025             // store the air drop tracker number (number of buys since last airdrop)
1026             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1027 
1028             // update player
1029             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1030             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1031 
1032             // update round
1033             round_[_rID].keys = _keys.add(round_[_rID].keys);
1034             round_[_rID].eth = _eth.add(round_[_rID].eth);
1035             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1036 
1037             // distribute eth
1038             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1039             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1040 
1041             // call end tx function to fire end tx event.
1042 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1043         }
1044     }
1045 //==============================================================================
1046 //     _ _ | _   | _ _|_ _  _ _  .
1047 //    (_(_||(_|_||(_| | (_)| _\  .
1048 //==============================================================================
1049     /**
1050      * @dev calculates unmasked earnings (just calculates, does not update mask)
1051      * @return earnings in wei format
1052      */
1053     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1054         private
1055         view
1056         returns(uint256)
1057     {
1058         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1059     }
1060 
1061     /**
1062      * @dev returns the amount of keys you would get given an amount of eth.
1063      * -functionhash- 0xce89c80c
1064      * @param _rID round ID you want price for
1065      * @param _eth amount of eth sent in
1066      * @return keys received
1067      */
1068     function calcKeysReceived(uint256 _rID, uint256 _eth)
1069         public
1070         view
1071         returns(uint256)
1072     {
1073         // grab time
1074         uint256 _now = now;
1075 
1076         // are we in a round?
1077         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1078             return ( (round_[_rID].eth).keysRec(_eth) );
1079         else // rounds over.  need keys for new round
1080             return ( (_eth).keys() );
1081     }
1082 
1083     /**
1084      * @dev returns current eth price for X keys.
1085      * -functionhash- 0xcf808000
1086      * @param _keys number of keys desired (in 18 decimal format)
1087      * @return amount of eth needed to send
1088      */
1089     function iWantXKeys(uint256 _keys)
1090         public
1091         view
1092         returns(uint256)
1093     {
1094         // setup local rID
1095         uint256 _rID = rID_;
1096 
1097         // grab time
1098         uint256 _now = now;
1099 
1100         // are we in a round?
1101         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1102             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1103         else // rounds over.  need price for new round
1104             return ( (_keys).eth() );
1105     }
1106 //==============================================================================
1107 //    _|_ _  _ | _  .
1108 //     | (_)(_)|_\  .
1109 //==============================================================================
1110     /**
1111 	 * @dev receives name/player info from names contract
1112      */
1113     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1114         external
1115     {
1116         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1117         if (pIDxAddr_[_addr] != _pID)
1118             pIDxAddr_[_addr] = _pID;
1119         if (pIDxName_[_name] != _pID)
1120             pIDxName_[_name] = _pID;
1121         if (plyr_[_pID].addr != _addr)
1122             plyr_[_pID].addr = _addr;
1123         if (plyr_[_pID].name != _name)
1124             plyr_[_pID].name = _name;
1125         if (plyr_[_pID].laff != _laff)
1126             plyr_[_pID].laff = _laff;
1127         if (plyrNames_[_pID][_name] == false)
1128             plyrNames_[_pID][_name] = true;
1129     }
1130 
1131     /**
1132      * @dev receives entire player name list
1133      */
1134     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1135         external
1136     {
1137         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1138         if(plyrNames_[_pID][_name] == false)
1139             plyrNames_[_pID][_name] = true;
1140     }
1141 
1142     /**
1143      * @dev gets existing or registers new pID.  use this when a player may be new
1144      * @return pID
1145      */
1146     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1147         private
1148         returns (F3Ddatasets.EventReturns)
1149     {
1150         uint256 _pID = pIDxAddr_[msg.sender];
1151         // if player is new to this version of fomo3d
1152         if (_pID == 0)
1153         {
1154             // grab their player ID, name and last aff ID, from player names contract
1155             _pID = PlayerBook.getPlayerID(msg.sender);
1156             bytes32 _name = PlayerBook.getPlayerName(_pID);
1157             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1158 
1159             // set up player account
1160             pIDxAddr_[msg.sender] = _pID;
1161             plyr_[_pID].addr = msg.sender;
1162 
1163             if (_name != "")
1164             {
1165                 pIDxName_[_name] = _pID;
1166                 plyr_[_pID].name = _name;
1167                 plyrNames_[_pID][_name] = true;
1168             }
1169 
1170             if (_laff != 0 && _laff != _pID)
1171                 plyr_[_pID].laff = _laff;
1172 
1173             // set the new player bool to true
1174             _eventData_.compressedData = _eventData_.compressedData + 1;
1175         }
1176         return (_eventData_);
1177     }
1178 
1179     /**
1180      * @dev checks to make sure user picked a valid team.  if not sets team
1181      * to default (sneks)
1182      */
1183     function verifyTeam(uint256 _team)
1184         private
1185         pure
1186         returns (uint256)
1187     {
1188         if (_team < 0 || _team > 3)
1189             return(2);
1190         else
1191             return(_team);
1192     }
1193 
1194     /**
1195      * @dev decides if round end needs to be run & new round started.  and if
1196      * player unmasked earnings from previously played rounds need to be moved.
1197      */
1198     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1199         private
1200         returns (F3Ddatasets.EventReturns)
1201     {
1202         // if player has played a previous round, move their unmasked earnings
1203         // from that round to gen vault.
1204         if (plyr_[_pID].lrnd != 0)
1205             updateGenVault(_pID, plyr_[_pID].lrnd);
1206 
1207         // update player's last round played
1208         plyr_[_pID].lrnd = rID_;
1209 
1210         // set the joined round bool to true
1211         _eventData_.compressedData = _eventData_.compressedData + 10;
1212 
1213         return(_eventData_);
1214     }
1215 
1216     /**
1217      * @dev ends the round. manages paying out winner/splitting up pot
1218      */
1219     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1220         private
1221         returns (F3Ddatasets.EventReturns)
1222     {
1223         // setup local rID
1224         uint256 _rID = rID_;
1225 
1226         // grab our winning player and team id's
1227         uint256 _winPID = round_[_rID].plyr;
1228         uint256 _winTID = round_[_rID].team;
1229 
1230         // grab our pot amount
1231         uint256 _pot = round_[_rID].pot;
1232 
1233         // calculate our winner share, community rewards, gen share,
1234         // p3d share, and amount reserved for next pot
1235         uint256 _win = (_pot.mul(48)) / 100; //48%
1236         uint256 _com = (_pot / 50); //2% 
1237         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1238         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1239         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1240 
1241         // calculate ppt for round mask
1242         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1243         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1244         if (_dust > 0)
1245         {
1246             _gen = _gen.sub(_dust);
1247             _res = _res.add(_dust);
1248         }
1249 
1250         // pay our winner
1251         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1252 
1253         // community rewards
1254 
1255         admin.transfer(_com);
1256         // p3d to pot
1257         _res = _res.add(_p3d);
1258 
1259         // distribute gen portion to key holders
1260         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1261 
1262         // prepare event data
1263         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1264         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1265         _eventData_.winnerAddr = plyr_[_winPID].addr;
1266         _eventData_.winnerName = plyr_[_winPID].name;
1267         _eventData_.amountWon = _win;
1268         _eventData_.genAmount = _gen;
1269         _eventData_.P3DAmount = _p3d;
1270         _eventData_.newPot = _res;
1271 
1272         // start next round
1273         rID_++;
1274         _rID++;
1275         round_[_rID].strt = now;
1276         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1277         round_[_rID].pot = _res;
1278 
1279         return(_eventData_);
1280     }
1281 
1282     /**
1283      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1284      */
1285     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1286         private
1287     {
1288         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1289         if (_earnings > 0)
1290         {
1291             // put in gen vault
1292             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1293             // zero out their earnings by updating mask
1294             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1295         }
1296     }
1297 
1298     /**
1299      * @dev updates round timer based on number of whole keys bought.
1300      */
1301     function updateTimer(uint256 _keys, uint256 _rID)
1302         private
1303     {
1304         // grab time
1305         uint256 _now = now;
1306 
1307         // calculate time based on number of keys bought
1308         uint256 _newTime;
1309         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1310             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1311         else
1312             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1313 
1314         // compare to max and set new end time
1315         if (_newTime < (rndMax_).add(_now))
1316             round_[_rID].end = _newTime;
1317         else
1318             round_[_rID].end = rndMax_.add(_now);
1319     }
1320 
1321     /**
1322      * @dev generates a random number between 0-99 and checks to see if thats
1323      * resulted in an airdrop win
1324      * @return do we have a winner?
1325      */
1326     function airdrop()
1327         private
1328         view
1329         returns(bool)
1330     {
1331         uint256 seed = uint256(keccak256(abi.encodePacked(
1332 
1333             (block.timestamp).add
1334             (block.difficulty).add
1335             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1336             (block.gaslimit).add
1337             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1338             (block.number)
1339 
1340         )));
1341         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1342             return(true);
1343         else
1344             return(false);
1345     }
1346 
1347     /**
1348      * @dev distributes eth based on fees to com, aff, and p3d
1349      */
1350     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1351         private
1352         returns(F3Ddatasets.EventReturns)
1353     {
1354         // pay 2% out to community rewards
1355         uint256 _com = _eth / 50;  //2%
1356 
1357         uint256 _p3d;
1358         if (!address(admin).call.value(_com)())
1359         {
1360             // This ensures Team Just cannot influence the outcome of FoMo3D with
1361             // bank migrations by breaking outgoing transactions.
1362             // Something we would never do. But that's not the point.
1363             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1364             // highest belief that everything we create should be trustless.
1365             // Team JUST, The name you shouldn't have to trust.
1366             _p3d = _com;
1367             _com = 0;
1368         }
1369 
1370 
1371         // distribute share to affiliate
1372         uint256 _aff = _eth / 10;
1373 
1374         // decide what to do with affiliate share of fees
1375         // affiliate must not be self, and must have a name registered
1376         if (_affID != _pID && plyr_[_affID].name != '') {
1377             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1378             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1379         } else {
1380             _p3d = _aff;
1381         }
1382 
1383         // pay out p3d
1384         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1385         if (_p3d > 0)
1386         {
1387             // deposit to divies contract
1388             uint256 _potAmount = _p3d;
1389 
1390             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1391 
1392             // set up event data
1393             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1394         }
1395 
1396         return(_eventData_);
1397     }
1398 
1399     function potSwap()
1400         external
1401         payable
1402     {
1403         // setup local rID
1404         uint256 _rID = rID_ + 1;
1405 
1406         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1407         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1408     }
1409 
1410     /**
1411      * @dev distributes eth based on fees to gen and pot
1412      */
1413     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1414         private
1415         returns(F3Ddatasets.EventReturns)
1416     {
1417         // calculate gen share
1418         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1419 
1420         // toss 1% into airdrop pot
1421         uint256 _air = (_eth / 100);
1422         airDropPot_ = airDropPot_.add(_air);
1423 
1424         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1425         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1426 
1427         // calculate pot
1428         uint256 _pot = _eth.sub(_gen);
1429 
1430         // distribute gen share (thats what updateMasks() does) and adjust
1431         // balances for dust.
1432         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1433         if (_dust > 0)
1434             _gen = _gen.sub(_dust);
1435 
1436         // add eth to pot
1437         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1438 
1439         // set up event data
1440         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1441         _eventData_.potAmount = _pot;
1442 
1443         return(_eventData_);
1444     }
1445 
1446     /**
1447      * @dev updates masks for round and player when keys are bought
1448      * @return dust left over
1449      */
1450     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1451         private
1452         returns(uint256)
1453     {
1454         /* MASKING NOTES
1455             earnings masks are a tricky thing for people to wrap their minds around.
1456             the basic thing to understand here.  is were going to have a global
1457             tracker based on profit per share for each round, that increases in
1458             relevant proportion to the increase in share supply.
1459             the player will have an additional mask that basically says "based
1460             on the rounds mask, my shares, and how much i've already withdrawn,
1461             how much is still owed to me?"
1462         */
1463 
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
1539         require(msg.sender == admin);
1540 
1541 
1542         // can only be ran once
1543         require(activated_ == false);
1544 
1545         // activate the contract
1546         activated_ = true;
1547 
1548         // lets start first round
1549         rID_ = 1;
1550         round_[1].strt = now + rndExtra_ - rndGap_;
1551         round_[1].end = now + rndInit_ + rndExtra_;
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
1598     }
1599     struct PlayerRounds {
1600         uint256 eth;    // eth player has added to round (used for eth limiter)
1601         uint256 keys;   // keys
1602         uint256 mask;   // player mask
1603         uint256 ico;    // ICO phase investment
1604     }
1605     struct Round {
1606         uint256 plyr;   // pID of player in lead
1607         uint256 team;   // tID of team in lead
1608         uint256 end;    // time ends/ended
1609         bool ended;     // has round end function been ran
1610         uint256 strt;   // time round started
1611         uint256 keys;   // keys
1612         uint256 eth;    // total eth in
1613         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1614         uint256 mask;   // global mask
1615         uint256 ico;    // total eth sent in during ICO phase
1616         uint256 icoGen; // total eth for gen during ICO phase
1617         uint256 icoAvg; // average key price for ICO phase
1618     }
1619     struct TeamFee {
1620         uint256 gen;    // % of buy in thats paid to key holders of current round
1621         uint256 p3d;    // % of buy in thats paid to p3d holders
1622     }
1623     struct PotSplit {
1624         uint256 gen;    // % of pot thats paid to key holders of current round
1625         uint256 p3d;    // % of pot thats paid to p3d holders
1626     }
1627 }
1628 
1629 //==============================================================================
1630 //  |  _      _ _ | _  .
1631 //  |<(/_\/  (_(_||(_  .
1632 //=======/======================================================================
1633 library F3DKeysCalcShort {
1634     using SafeMath for *;
1635     /**
1636      * @dev calculates number of keys received given X eth
1637      * @param _curEth current amount of eth in contract
1638      * @param _newEth eth being spent
1639      * @return amount of ticket purchased
1640      */
1641     function keysRec(uint256 _curEth, uint256 _newEth)
1642         internal
1643         pure
1644         returns (uint256)
1645     {
1646         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1647     }
1648 
1649     /**
1650      * @dev calculates amount of eth received if you sold X keys
1651      * @param _curKeys current amount of keys that exist
1652      * @param _sellKeys amount of keys you wish to sell
1653      * @return amount of eth received
1654      */
1655     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1656         internal
1657         pure
1658         returns (uint256)
1659     {
1660         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1661     }
1662 
1663     /**
1664      * @dev calculates how many keys would exist with given an amount of eth
1665      * @param _eth eth "in contract"
1666      * @return number of keys that would exist
1667      */
1668     function keys(uint256 _eth)
1669         internal
1670         pure
1671         returns(uint256)
1672     {
1673         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1674     }
1675 
1676     /**
1677      * @dev calculates how much eth would be in contract given a number of keys
1678      * @param _keys number of keys "in contract"
1679      * @return eth that would exists
1680      */
1681     function eth(uint256 _keys)
1682         internal
1683         pure
1684         returns(uint256)
1685     {
1686         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1687     }
1688 }
1689 
1690 //==============================================================================
1691 //  . _ _|_ _  _ |` _  _ _  _  .
1692 //  || | | (/_| ~|~(_|(_(/__\  .
1693 //==============================================================================
1694 
1695 interface PlayerBookInterface {
1696     function getPlayerID(address _addr) external returns (uint256);
1697     function getPlayerName(uint256 _pID) external view returns (bytes32);
1698     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1699     function getPlayerAddr(uint256 _pID) external view returns (address);
1700     function getNameFee() external view returns (uint256);
1701     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1702     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1703     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1704 }
1705 
1706 
1707 library NameFilter {
1708     /**
1709      * @dev filters name strings
1710      * -converts uppercase to lower case.
1711      * -makes sure it does not start/end with a space
1712      * -makes sure it does not contain multiple spaces in a row
1713      * -cannot be only numbers
1714      * -cannot start with 0x
1715      * -restricts characters to A-Z, a-z, 0-9, and space.
1716      * @return reprocessed string in bytes32 format
1717      */
1718     function nameFilter(string _input)
1719         internal
1720         pure
1721         returns(bytes32)
1722     {
1723         bytes memory _temp = bytes(_input);
1724         uint256 _length = _temp.length;
1725 
1726         //sorry limited to 32 characters
1727         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1728         // make sure it doesnt start with or end with space
1729         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1730         // make sure first two characters are not 0x
1731         if (_temp[0] == 0x30)
1732         {
1733             require(_temp[1] != 0x78, "string cannot start with 0x");
1734             require(_temp[1] != 0x58, "string cannot start with 0X");
1735         }
1736 
1737         // create a bool to track if we have a non number character
1738         bool _hasNonNumber;
1739 
1740         // convert & check
1741         for (uint256 i = 0; i < _length; i++)
1742         {
1743             // if its uppercase A-Z
1744             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1745             {
1746                 // convert to lower case a-z
1747                 _temp[i] = byte(uint(_temp[i]) + 32);
1748 
1749                 // we have a non number
1750                 if (_hasNonNumber == false)
1751                     _hasNonNumber = true;
1752             } else {
1753                 require
1754                 (
1755                     // require character is a space
1756                     _temp[i] == 0x20 ||
1757                     // OR lowercase a-z
1758                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1759                     // or 0-9
1760                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1761                     "string contains invalid characters"
1762                 );
1763                 // make sure theres not 2x spaces in a row
1764                 if (_temp[i] == 0x20)
1765                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1766 
1767                 // see if we have a character other than a number
1768                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1769                     _hasNonNumber = true;
1770             }
1771         }
1772 
1773         require(_hasNonNumber == true, "string cannot be only numbers");
1774 
1775         bytes32 _ret;
1776         assembly {
1777             _ret := mload(add(_temp, 32))
1778         }
1779         return (_ret);
1780     }
1781 }
1782 
1783 /**
1784  * @title SafeMath v0.1.9
1785  * @dev Math operations with safety checks that throw on error
1786  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1787  * - added sqrt
1788  * - added sq
1789  * - added pwr
1790  * - changed asserts to requires with error log outputs
1791  * - removed div, its useless
1792  */
1793 library SafeMath {
1794 
1795     /**
1796     * @dev Multiplies two numbers, throws on overflow.
1797     */
1798     function mul(uint256 a, uint256 b)
1799         internal
1800         pure
1801         returns (uint256 c)
1802     {
1803         if (a == 0) {
1804             return 0;
1805         }
1806         c = a * b;
1807         require(c / a == b, "SafeMath mul failed");
1808         return c;
1809     }
1810 
1811     /**
1812     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1813     */
1814     function sub(uint256 a, uint256 b)
1815         internal
1816         pure
1817         returns (uint256)
1818     {
1819         require(b <= a, "SafeMath sub failed");
1820         return a - b;
1821     }
1822 
1823     /**
1824     * @dev Adds two numbers, throws on overflow.
1825     */
1826     function add(uint256 a, uint256 b)
1827         internal
1828         pure
1829         returns (uint256 c)
1830     {
1831         c = a + b;
1832         require(c >= a, "SafeMath add failed");
1833         return c;
1834     }
1835 
1836     /**
1837      * @dev gives square root of given x.
1838      */
1839     function sqrt(uint256 x)
1840         internal
1841         pure
1842         returns (uint256 y)
1843     {
1844         uint256 z = ((add(x,1)) / 2);
1845         y = x;
1846         while (z < y)
1847         {
1848             y = z;
1849             z = ((add((x / z),z)) / 2);
1850         }
1851     }
1852 
1853     /**
1854      * @dev gives square. multiplies x by x
1855      */
1856     function sq(uint256 x)
1857         internal
1858         pure
1859         returns (uint256)
1860     {
1861         return (mul(x,x));
1862     }
1863 
1864     /**
1865      * @dev x to the power of y
1866      */
1867     function pwr(uint256 x, uint256 y)
1868         internal
1869         pure
1870         returns (uint256)
1871     {
1872         if (x==0)
1873             return (0);
1874         else if (y==0)
1875             return (1);
1876         else
1877         {
1878             uint256 z = x;
1879             for (uint256 i=1; i < y; i++)
1880                 z = mul(z,x);
1881             return (z);
1882         }
1883     }
1884 }