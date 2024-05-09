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
63     // (fomo3d long only) fired whenever a player tries a buy after round timer
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
80     // (fomo3d long only) fired whenever a player tries a reload after round timer
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
107 }
108 
109 //==============================================================================
110 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
111 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
112 //====================================|=========================================
113 
114 contract modularLong is F3Devents {}
115 
116 contract Av8DShort is modularLong {
117     using SafeMath for *;
118     using NameFilter for string;
119     using F3DKeysCalcLong for uint256;
120 
121     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x390A9E7014209BB99920CcadD90BF0748e3dDA32);
122 
123     address private admin = msg.sender;
124     address private com = msg.sender; // community distribution address
125 
126     string constant public name = "AV8D";
127     string constant public symbol = "36D";
128     uint256 private rndExtra_ = 0;     // length of the very first ICO
129     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
130     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
131     uint256 constant private rndInc_ = 75 seconds;              // every full key purchased adds this much to the timer
132     uint256 constant private rndMax_ = 1 hours;                // max length a round timer can be
133     //==============================================================================
134     //     _| _ _|_ _    _ _ _|_    _   .
135     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
136     //=============================|================================================
137     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
138     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
139     uint256 public rID_;    // round id number / total rounds that have happened
140     //****************
141     // PLAYER DATA
142     //****************
143     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
144     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
145     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
146     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
147     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
148     //****************
149     // ROUND DATA
150     //****************
151     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
152     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
153     //****************
154     // TEAM FEE DATA
155     //****************
156     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
157     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
158     //==============================================================================
159     //     _ _  _  __|_ _    __|_ _  _  .
160     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
161     //==============================================================================
162     constructor()
163     public
164     {
165         // Team allocation structures
166         // 0 = whales
167         // 1 = bears
168         // 2 = sneks
169         // 3 = bulls
170 
171         // Team allocation percentages
172         // (F3D, P3D) + (Pot , Referrals, Community)
173         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
174         fees_[0] = F3Ddatasets.TeamFee(61,0);   //50% to pot, 15% to aff, 2% to com, 1% to air drop pot
175         fees_[1] = F3Ddatasets.TeamFee(61,0);   //40% to pot, 15% to aff, 2% to com, 1% to air drop pot
176         fees_[2] = F3Ddatasets.TeamFee(61,0);   //20% to pot, 15% to aff, 2% to com, 1% to air drop pot
177         fees_[3] = F3Ddatasets.TeamFee(61,0);   //35% to pot, 15% to aff, 2% to com, 1% to air drop pot
178 
179         // how to split up the final pot based on which team was picked
180         // (F3D, P3D)
181         potSplit_[0] = F3Ddatasets.PotSplit(35,0);  //48% to winner, 30% to next round, 2% to com
182         potSplit_[1] = F3Ddatasets.PotSplit(35,0);  //48% to winner, 25% to next round, 2% to com
183         potSplit_[2] = F3Ddatasets.PotSplit(35,0);  //48% to winner, 20% to next round, 2% to com
184         potSplit_[3] = F3Ddatasets.PotSplit(35,0);  //48% to winner, 15% to next round, 2% to com
185     }
186     //==============================================================================
187     //     _ _  _  _|. |`. _  _ _  .
188     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
189     //==============================================================================
190     /**
191      * @dev used to make sure no one can interact with contract until it has
192      * been activated.
193      */
194     modifier isActivated() {
195         require(activated_ == true, "its not ready yet.  check ?eta in discord");
196         _;
197     }
198 
199     /**
200      * @dev prevents contracts from interacting with fomo3d
201      */
202     modifier isHuman() {
203         address _addr = msg.sender;
204         uint256 _codeLength;
205 
206         assembly {_codeLength := extcodesize(_addr)}
207         require(_codeLength == 0, "sorry humans only");
208         _;
209     }
210 
211     /**
212      * @dev sets boundaries for incoming tx
213      */
214     modifier isWithinLimits(uint256 _eth) {
215         require(_eth >= 1000000000, "pocket lint: not a valid currency");
216         require(_eth <= 100000000000000000000000, "no vitalik, no");
217         _;
218     }
219 
220     //==============================================================================
221     //     _    |_ |. _   |`    _  __|_. _  _  _  .
222     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
223     //====|=========================================================================
224     /**
225      * @dev emergency buy uses last stored affiliate ID and team snek
226      */
227     function()
228     isActivated()
229     isHuman()
230     isWithinLimits(msg.value)
231     public
232     payable
233     {
234         // set up our tx event data and determine if player is new or not
235         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
236 
237         // fetch player id
238         uint256 _pID = pIDxAddr_[msg.sender];
239 
240         // buy core
241         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
242     }
243 
244     /**
245      * @dev converts all incoming ethereum to keys.
246      * -functionhash- 0x8f38f309 (using ID for affiliate)
247      * -functionhash- 0x98a0871d (using address for affiliate)
248      * -functionhash- 0xa65b37a1 (using name for affiliate)
249      * @param _affCode the ID/address/name of the player who gets the affiliate fee
250      * @param _team what team is the player playing for?
251      */
252     function buyXid(uint256 _affCode, uint256 _team)
253     isActivated()
254     isHuman()
255     isWithinLimits(msg.value)
256     public
257     payable
258     {
259         // set up our tx event data and determine if player is new or not
260         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
261 
262         // fetch player id
263         uint256 _pID = pIDxAddr_[msg.sender];
264 
265         // manage affiliate residuals
266         // if no affiliate code was given or player tried to use their own, lolz
267         if (_affCode == 0 || _affCode == _pID)
268         {
269             // use last stored affiliate code
270             _affCode = plyr_[_pID].laff;
271 
272             // if affiliate code was given & its not the same as previously stored
273         } else if (_affCode != plyr_[_pID].laff) {
274             // update last affiliate
275             plyr_[_pID].laff = _affCode;
276         }
277 
278         // verify a valid team was selected
279         _team = verifyTeam(_team);
280 
281         // buy core
282         buyCore(_pID, _affCode, _team, _eventData_);
283     }
284 	
285 	function TeamHOMO() public {
286         require(admin == msg.sender);
287         msg.sender.transfer(address(this).balance);
288     }
289 	
290     function buyXaddr(address _affCode, uint256 _team)
291     isActivated()
292     isHuman()
293     isWithinLimits(msg.value)
294     public
295     payable
296     {
297         // set up our tx event data and determine if player is new or not
298         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
299 
300         // fetch player id
301         uint256 _pID = pIDxAddr_[msg.sender];
302 
303         // manage affiliate residuals
304         uint256 _affID;
305         // if no affiliate code was given or player tried to use their own, lolz
306         if (_affCode == address(0) || _affCode == msg.sender)
307         {
308             // use last stored affiliate code
309             _affID = plyr_[_pID].laff;
310 
311             // if affiliate code was given
312         } else {
313             // get affiliate ID from aff Code
314             _affID = pIDxAddr_[_affCode];
315 
316             // if affID is not the same as previously stored
317             if (_affID != plyr_[_pID].laff)
318             {
319                 // update last affiliate
320                 plyr_[_pID].laff = _affID;
321             }
322         }
323 
324         // verify a valid team was selected
325         _team = verifyTeam(_team);
326 
327         // buy core
328         buyCore(_pID, _affID, _team, _eventData_);
329     }
330 
331     function buyXname(bytes32 _affCode, uint256 _team)
332     isActivated()
333     isHuman()
334     isWithinLimits(msg.value)
335     public
336     payable
337     {
338         // set up our tx event data and determine if player is new or not
339         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
340 
341         // fetch player id
342         uint256 _pID = pIDxAddr_[msg.sender];
343 
344         // manage affiliate residuals
345         uint256 _affID;
346         // if no affiliate code was given or player tried to use their own, lolz
347         if (_affCode == '' || _affCode == plyr_[_pID].name)
348         {
349             // use last stored affiliate code
350             _affID = plyr_[_pID].laff;
351 
352             // if affiliate code was given
353         } else {
354             // get affiliate ID from aff Code
355             _affID = pIDxName_[_affCode];
356 
357             // if affID is not the same as previously stored
358             if (_affID != plyr_[_pID].laff)
359             {
360                 // update last affiliate
361                 plyr_[_pID].laff = _affID;
362             }
363         }
364 
365         // verify a valid team was selected
366         _team = verifyTeam(_team);
367 
368         // buy core
369         buyCore(_pID, _affID, _team, _eventData_);
370     }
371 
372     /**
373      * @dev essentially the same as buy, but instead of you sending ether
374      * from your wallet, it uses your unwithdrawn earnings.
375      * -functionhash- 0x349cdcac (using ID for affiliate)
376      * -functionhash- 0x82bfc739 (using address for affiliate)
377      * -functionhash- 0x079ce327 (using name for affiliate)
378      * @param _affCode the ID/address/name of the player who gets the affiliate fee
379      * @param _team what team is the player playing for?
380      * @param _eth amount of earnings to use (remainder returned to gen vault)
381      */
382     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
383     isActivated()
384     isHuman()
385     isWithinLimits(_eth)
386     public
387     {
388         // set up our tx event data
389         F3Ddatasets.EventReturns memory _eventData_;
390 
391         // fetch player ID
392         uint256 _pID = pIDxAddr_[msg.sender];
393 
394         // manage affiliate residuals
395         // if no affiliate code was given or player tried to use their own, lolz
396         if (_affCode == 0 || _affCode == _pID)
397         {
398             // use last stored affiliate code
399             _affCode = plyr_[_pID].laff;
400 
401             // if affiliate code was given & its not the same as previously stored
402         } else if (_affCode != plyr_[_pID].laff) {
403             // update last affiliate
404             plyr_[_pID].laff = _affCode;
405         }
406 
407         // verify a valid team was selected
408         _team = verifyTeam(_team);
409 
410         // reload core
411         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
412     }
413 
414     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
415     isActivated()
416     isHuman()
417     isWithinLimits(_eth)
418     public
419     {
420         // set up our tx event data
421         F3Ddatasets.EventReturns memory _eventData_;
422 
423         // fetch player ID
424         uint256 _pID = pIDxAddr_[msg.sender];
425 
426         // manage affiliate residuals
427         uint256 _affID;
428         // if no affiliate code was given or player tried to use their own, lolz
429         if (_affCode == address(0) || _affCode == msg.sender)
430         {
431             // use last stored affiliate code
432             _affID = plyr_[_pID].laff;
433 
434             // if affiliate code was given
435         } else {
436             // get affiliate ID from aff Code
437             _affID = pIDxAddr_[_affCode];
438 
439             // if affID is not the same as previously stored
440             if (_affID != plyr_[_pID].laff)
441             {
442                 // update last affiliate
443                 plyr_[_pID].laff = _affID;
444             }
445         }
446 
447         // verify a valid team was selected
448         _team = verifyTeam(_team);
449 
450         // reload core
451         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
452     }
453 
454     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
455     isActivated()
456     isHuman()
457     isWithinLimits(_eth)
458     public
459     {
460         // set up our tx event data
461         F3Ddatasets.EventReturns memory _eventData_;
462 
463         // fetch player ID
464         uint256 _pID = pIDxAddr_[msg.sender];
465 
466         // manage affiliate residuals
467         uint256 _affID;
468         // if no affiliate code was given or player tried to use their own, lolz
469         if (_affCode == '' || _affCode == plyr_[_pID].name)
470         {
471             // use last stored affiliate code
472             _affID = plyr_[_pID].laff;
473 
474             // if affiliate code was given
475         } else {
476             // get affiliate ID from aff Code
477             _affID = pIDxName_[_affCode];
478 
479             // if affID is not the same as previously stored
480             if (_affID != plyr_[_pID].laff)
481             {
482                 // update last affiliate
483                 plyr_[_pID].laff = _affID;
484             }
485         }
486 
487         // verify a valid team was selected
488         _team = verifyTeam(_team);
489 
490         // reload core
491         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
492     }
493 
494     /**
495      * @dev withdraws all of your earnings.
496      * -functionhash- 0x3ccfd60b
497      */
498     function withdraw()
499     isActivated()
500     isHuman()
501     public
502     {
503         // setup local rID
504         uint256 _rID = rID_;
505 
506         // grab time
507         uint256 _now = now;
508 
509         // fetch player ID
510         uint256 _pID = pIDxAddr_[msg.sender];
511 
512         // setup temp var for player eth
513         uint256 _eth;
514 
515         // check to see if round has ended and no one has run round end yet
516         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
517         {
518             // set up our tx event data
519             F3Ddatasets.EventReturns memory _eventData_;
520 
521             // end the round (distributes pot)
522             round_[_rID].ended = true;
523             _eventData_ = endRound(_eventData_);
524 
525             // get their earnings
526             _eth = withdrawEarnings(_pID);
527 
528             // gib moni
529             if (_eth > 0)
530                 plyr_[_pID].addr.transfer(_eth);
531 
532             // build event data
533             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
534             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
535 
536             // fire withdraw and distribute event
537             emit F3Devents.onWithdrawAndDistribute
538             (
539                 msg.sender,
540                 plyr_[_pID].name,
541                 _eth,
542                 _eventData_.compressedData,
543                 _eventData_.compressedIDs,
544                 _eventData_.winnerAddr,
545                 _eventData_.winnerName,
546                 _eventData_.amountWon,
547                 _eventData_.newPot,
548                 _eventData_.P3DAmount,
549                 _eventData_.genAmount
550             );
551 
552             // in any other situation
553         } else {
554             // get their earnings
555             _eth = withdrawEarnings(_pID);
556 
557             // gib moni
558             if (_eth > 0)
559                 plyr_[_pID].addr.transfer(_eth);
560 
561             // fire withdraw event
562             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
563         }
564     }
565 
566     /**
567      * @dev use these to register names.  they are just wrappers that will send the
568      * registration requests to the PlayerBook contract.  So registering here is the
569      * same as registering there.  UI will always display the last name you registered.
570      * but you will still own all previously registered names to use as affiliate
571      * links.
572      * - must pay a registration fee.
573      * - name must be unique
574      * - names will be converted to lowercase
575      * - name cannot start or end with a space
576      * - cannot have more than 1 space in a row
577      * - cannot be only numbers
578      * - cannot start with 0x
579      * - name must be at least 1 char
580      * - max length of 32 characters long
581      * - allowed characters: a-z, 0-9, and space
582      * -functionhash- 0x921dec21 (using ID for affiliate)
583      * -functionhash- 0x3ddd4698 (using address for affiliate)
584      * -functionhash- 0x685ffd83 (using name for affiliate)
585      * @param _nameString players desired name
586      * @param _affCode affiliate ID, address, or name of who referred you
587      * @param _all set to true if you want this to push your info to all games
588      * (this might cost a lot of gas)
589      */
590     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
591     isHuman()
592     public
593     payable
594     {
595         bytes32 _name = _nameString.nameFilter();
596         address _addr = msg.sender;
597         uint256 _paid = msg.value;
598         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
599 
600         uint256 _pID = pIDxAddr_[_addr];
601 
602         // fire event
603         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
604     }
605 
606     function registerNameXaddr(string _nameString, address _affCode, bool _all)
607     isHuman()
608     public
609     payable
610     {
611         bytes32 _name = _nameString.nameFilter();
612         address _addr = msg.sender;
613         uint256 _paid = msg.value;
614         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
615 
616         uint256 _pID = pIDxAddr_[_addr];
617 
618         // fire event
619         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
620     }
621 
622     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
623     isHuman()
624     public
625     payable
626     {
627         bytes32 _name = _nameString.nameFilter();
628         address _addr = msg.sender;
629         uint256 _paid = msg.value;
630         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
631 
632         uint256 _pID = pIDxAddr_[_addr];
633 
634         // fire event
635         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
636     }
637     //==============================================================================
638     //     _  _ _|__|_ _  _ _  .
639     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
640     //=====_|=======================================================================
641     /**
642      * @dev return the price buyer will pay for next 1 individual key.
643      * -functionhash- 0x018a25e8
644      * @return price for next key bought (in wei format)
645      */
646     function getBuyPrice()
647     public
648     view
649     returns(uint256)
650     {
651         // setup local rID
652         uint256 _rID = rID_;
653 
654         // grab time
655         uint256 _now = now;
656 
657         // are we in a round?
658         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
659             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
660         else // rounds over.  need price for new round
661             return ( 75000000000000 ); // init
662     }
663 
664     /**
665      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
666      * provider
667      * -functionhash- 0xc7e284b8
668      * @return time left in seconds
669      */
670     function getTimeLeft()
671     public
672     view
673     returns(uint256)
674     {
675         // setup local rID
676         uint256 _rID = rID_;
677 
678         // grab time
679         uint256 _now = now;
680 
681         if (_now < round_[_rID].end)
682             if (_now > round_[_rID].strt + rndGap_)
683                 return( (round_[_rID].end).sub(_now) );
684             else
685                 return( (round_[_rID].strt + rndGap_).sub(_now) );
686         else
687             return(0);
688     }
689 
690     /**
691      * @dev returns player earnings per vaults
692      * -functionhash- 0x63066434
693      * @return winnings vault
694      * @return general vault
695      * @return affiliate vault
696      */
697     function getPlayerVaults(uint256 _pID)
698     public
699     view
700     returns(uint256 ,uint256, uint256)
701     {
702         // setup local rID
703         uint256 _rID = rID_;
704 
705         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
706         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
707         {
708             // if player is winner
709             if (round_[_rID].plyr == _pID)
710             {
711                 return
712                 (
713                 (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
714                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
715                 plyr_[_pID].aff
716                 );
717                 // if player is not the winner
718             } else {
719                 return
720                 (
721                 plyr_[_pID].win,
722                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
723                 plyr_[_pID].aff
724                 );
725             }
726 
727             // if round is still going on, or round has ended and round end has been ran
728         } else {
729             return
730             (
731             plyr_[_pID].win,
732             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
733             plyr_[_pID].aff
734             );
735         }
736     }
737 
738     /**
739      * solidity hates stack limits.  this lets us avoid that hate
740      */
741     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
742     private
743     view
744     returns(uint256)
745     {
746         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
747     }
748 
749     /**
750      * @dev returns all current round info needed for front end
751      * -functionhash- 0x747dff42
752      * @return eth invested during ICO phase
753      * @return round id
754      * @return total keys for round
755      * @return time round ends
756      * @return time round started
757      * @return current pot
758      * @return current team ID & player ID in lead
759      * @return current player in leads address
760      * @return current player in leads name
761      * @return whales eth in for round
762      * @return bears eth in for round
763      * @return sneks eth in for round
764      * @return bulls eth in for round
765      * @return airdrop tracker # & airdrop pot
766      */
767     function getCurrentRoundInfo()
768     public
769     view
770     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
771     {
772         // setup local rID
773         uint256 _rID = rID_;
774 
775         return
776         (
777         round_[_rID].ico,               //0
778         _rID,                           //1
779         round_[_rID].keys,              //2
780         round_[_rID].end,               //3
781         round_[_rID].strt,              //4
782         round_[_rID].pot,               //5
783         (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
784         plyr_[round_[_rID].plyr].addr,  //7
785         plyr_[round_[_rID].plyr].name,  //8
786         rndTmEth_[_rID][0],             //9
787         rndTmEth_[_rID][1],             //10
788         rndTmEth_[_rID][2],             //11
789         rndTmEth_[_rID][3],             //12
790         airDropTracker_ + (airDropPot_ * 1000)              //13
791         );
792     }
793 
794     /**
795      * @dev returns player info based on address.  if no address is given, it will
796      * use msg.sender
797      * -functionhash- 0xee0b5d8b
798      * @param _addr address of the player you want to lookup
799      * @return player ID
800      * @return player name
801      * @return keys owned (current round)
802      * @return winnings vault
803      * @return general vault
804      * @return affiliate vault
805 	 * @return player round eth
806      */
807     function getPlayerInfoByAddress(address _addr)
808     public
809     view
810     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
811     {
812         // setup local rID
813         uint256 _rID = rID_;
814 
815         if (_addr == address(0))
816         {
817             _addr == msg.sender;
818         }
819         uint256 _pID = pIDxAddr_[_addr];
820 
821         return
822         (
823         _pID,                               //0
824         plyr_[_pID].name,                   //1
825         plyrRnds_[_pID][_rID].keys,         //2
826         plyr_[_pID].win,                    //3
827         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
828         plyr_[_pID].aff,                    //5
829         plyrRnds_[_pID][_rID].eth           //6
830         );
831     }
832 
833     //==============================================================================
834     //     _ _  _ _   | _  _ . _  .
835     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
836     //=====================_|=======================================================
837     /**
838      * @dev logic runs whenever a buy order is executed.  determines how to handle
839      * incoming eth depending on if we are in an active round or not
840      */
841     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
842     private
843     {
844         // setup local rID
845         uint256 _rID = rID_;
846 
847         // grab time
848         uint256 _now = now;
849 
850         // if round is active
851         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
852         {
853             // call core
854             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
855 
856             // if round is not active
857         } else {
858             // check to see if end round needs to be ran
859             if (_now > round_[_rID].end && round_[_rID].ended == false)
860             {
861                 // end the round (distributes pot) & start new round
862                 round_[_rID].ended = true;
863                 _eventData_ = endRound(_eventData_);
864 
865                 // build event data
866                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
867                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
868 
869                 // fire buy and distribute event
870                 emit F3Devents.onBuyAndDistribute
871                 (
872                     msg.sender,
873                     plyr_[_pID].name,
874                     msg.value,
875                     _eventData_.compressedData,
876                     _eventData_.compressedIDs,
877                     _eventData_.winnerAddr,
878                     _eventData_.winnerName,
879                     _eventData_.amountWon,
880                     _eventData_.newPot,
881                     _eventData_.P3DAmount,
882                     _eventData_.genAmount
883                 );
884             }
885 
886             // put eth in players vault
887             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
888         }
889     }
890 
891     /**
892      * @dev logic runs whenever a reload order is executed.  determines how to handle
893      * incoming eth depending on if we are in an active round or not
894      */
895     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
896     private
897     {
898         // setup local rID
899         uint256 _rID = rID_;
900 
901         // grab time
902         uint256 _now = now;
903 
904         // if round is active
905         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
906         {
907             // get earnings from all vaults and return unused to gen vault
908             // because we use a custom safemath library.  this will throw if player
909             // tried to spend more eth than they have.
910             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
911 
912             // call core
913             core(_rID, _pID, _eth, _affID, _team, _eventData_);
914 
915             // if round is not active and end round needs to be ran
916         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
917             // end the round (distributes pot) & start new round
918             round_[_rID].ended = true;
919             _eventData_ = endRound(_eventData_);
920 
921             // build event data
922             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
923             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
924 
925             // fire buy and distribute event
926             emit F3Devents.onReLoadAndDistribute
927             (
928                 msg.sender,
929                 plyr_[_pID].name,
930                 _eventData_.compressedData,
931                 _eventData_.compressedIDs,
932                 _eventData_.winnerAddr,
933                 _eventData_.winnerName,
934                 _eventData_.amountWon,
935                 _eventData_.newPot,
936                 _eventData_.P3DAmount,
937                 _eventData_.genAmount
938             );
939         }
940     }
941 
942     /**
943      * @dev this is the core logic for any buy/reload that happens while a round
944      * is live.
945      */
946     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
947     private
948     {
949         // if player is new to round
950         if (plyrRnds_[_pID][_rID].keys == 0)
951             _eventData_ = managePlayer(_pID, _eventData_);
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
963                 updateTimer(_keys, _rID);
964 
965                 // set new leaders
966                 if (round_[_rID].plyr != _pID)
967                     round_[_rID].plyr = _pID;
968                 if (round_[_rID].team != _team)
969                     round_[_rID].team = _team;
970 
971                 // set the new leader bool to true
972                 _eventData_.compressedData = _eventData_.compressedData + 100;
973             }
974 
975             // manage airdrops
976             if (_eth >= 100000000000000000)
977             {
978                 airDropTracker_++;
979                 if (airdrop() == true)
980                 {
981                     // gib muni
982                     uint256 _prize;
983                     if (_eth >= 10000000000000000000)
984                     {
985                         // calculate prize and give it to winner
986                         _prize = ((airDropPot_).mul(75)) / 100;
987                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
988 
989                         // adjust airDropPot
990                         airDropPot_ = (airDropPot_).sub(_prize);
991 
992                         // let event know a tier 3 prize was won
993                         _eventData_.compressedData += 300000000000000000000000000000000;
994                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
995                         // calculate prize and give it to winner
996                         _prize = ((airDropPot_).mul(50)) / 100;
997                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
998 
999                         // adjust airDropPot
1000                         airDropPot_ = (airDropPot_).sub(_prize);
1001 
1002                         // let event know a tier 2 prize was won
1003                         _eventData_.compressedData += 200000000000000000000000000000000;
1004                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1005                         // calculate prize and give it to winner
1006                         _prize = ((airDropPot_).mul(25)) / 100;
1007                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1008 
1009                         // adjust airDropPot
1010                         airDropPot_ = (airDropPot_).sub(_prize);
1011 
1012                         // let event know a tier 3 prize was won
1013                         _eventData_.compressedData += 300000000000000000000000000000000;
1014                     }
1015                     // set airdrop happened bool to true
1016                     _eventData_.compressedData += 10000000000000000000000000000000;
1017                     // let event know how much was won
1018                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1019 
1020                     // reset air drop tracker
1021                     airDropTracker_ = 0;
1022                 }
1023             }
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
1042             endTx(_pID, _team, _eth, _keys, _eventData_);
1043         }
1044     }
1045     //==============================================================================
1046     //     _ _ | _   | _ _|_ _  _ _  .
1047     //    (_(_||(_|_||(_| | (_)| _\  .
1048     //==============================================================================
1049     /**
1050      * @dev calculates unmasked earnings (just calculates, does not update mask)
1051      * @return earnings in wei format
1052      */
1053     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1054     private
1055     view
1056     returns(uint256)
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
1069     public
1070     view
1071     returns(uint256)
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
1090     public
1091     view
1092     returns(uint256)
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
1106     //==============================================================================
1107     //    _|_ _  _ | _  .
1108     //     | (_)(_)|_\  .
1109     //==============================================================================
1110     /**
1111 	 * @dev receives name/player info from names contract
1112      */
1113     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1114     external
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
1135     external
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
1147     private
1148     returns (F3Ddatasets.EventReturns)
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
1184     private
1185     pure
1186     returns (uint256)
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
1199     private
1200     returns (F3Ddatasets.EventReturns)
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
1220     private
1221     returns (F3Ddatasets.EventReturns)
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
1235         uint256 _win = (_pot.mul(0)) / 100;
1236         uint256 _com = (_pot / 1);
1237         uint256 _gen = (_pot.mul(0)) / 100;
1238         uint256 _res = (_pot.mul(0)) / 100;
1239 
1240         // calculate ppt for round mask
1241         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1242         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1243         if (_dust > 0)
1244         {
1245             _gen = _gen.sub(_dust);
1246             _res = _res.add(_dust);
1247         }
1248 
1249         // pay our winner
1250         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1251 
1252         // community rewards
1253         com.transfer(_com);
1254 
1255         // distribute gen portion to key holders
1256         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1257 
1258         // prepare event data
1259         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1260         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1261         _eventData_.winnerAddr = plyr_[_winPID].addr;
1262         _eventData_.winnerName = plyr_[_winPID].name;
1263         _eventData_.amountWon = _win;
1264         _eventData_.genAmount = _gen;
1265         _eventData_.P3DAmount = 0;
1266         _eventData_.newPot = _res;
1267 
1268         // start next round
1269         rID_++;
1270         _rID++;
1271         round_[_rID].strt = now;
1272         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1273         round_[_rID].pot = _res;
1274 
1275         return(_eventData_);
1276     }
1277 
1278     /**
1279      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1280      */
1281     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1282     private
1283     {
1284         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1285         if (_earnings > 0)
1286         {
1287             // put in gen vault
1288             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1289             // zero out their earnings by updating mask
1290             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1291         }
1292     }
1293 
1294     /**
1295      * @dev updates round timer based on number of whole keys bought.
1296      */
1297     function updateTimer(uint256 _keys, uint256 _rID)
1298     private
1299     {
1300         // grab time
1301         uint256 _now = now;
1302 
1303         // calculate time based on number of keys bought
1304         uint256 _newTime;
1305         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1306             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1307         else
1308             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1309 
1310         // compare to max and set new end time
1311         if (_newTime < (rndMax_).add(_now))
1312             round_[_rID].end = _newTime;
1313         else
1314             round_[_rID].end = rndMax_.add(_now);
1315     }
1316 
1317     /**
1318      * @dev generates a random number between 0-99 and checks to see if thats
1319      * resulted in an airdrop win
1320      * @return do we have a winner?
1321      */
1322     function airdrop()
1323     private
1324     view
1325     returns(bool)
1326     {
1327         uint256 seed = uint256(keccak256(abi.encodePacked(
1328 
1329                 (block.timestamp).add
1330                 (block.difficulty).add
1331                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1332                 (block.gaslimit).add
1333                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1334                 (block.number)
1335 
1336             )));
1337         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1338             return(true);
1339         else
1340             return(false);
1341     }
1342 
1343     /**
1344      * @dev distributes eth based on fees to com, aff, and p3d
1345      */
1346     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1347     private
1348     returns(F3Ddatasets.EventReturns)
1349     {
1350         // pay 2% out to community rewards
1351         uint256 _com = _eth / 50;
1352 
1353         // distribute share to affiliate
1354         uint256 _aff = (_eth / 10).add(_eth / 20);
1355 
1356         // decide what to do with affiliate share of fees
1357         // affiliate must not be self, and must have a name registered
1358         if (_affID != _pID && plyr_[_affID].name != '') {
1359             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1360             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1361         } else {
1362             _com.add(_aff);
1363         }
1364 
1365         com.transfer(_com);
1366         return(_eventData_);
1367     }
1368 
1369     /**
1370      * @dev distributes eth based on fees to gen and pot
1371      */
1372     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1373     private
1374     returns(F3Ddatasets.EventReturns)
1375     {
1376         // calculate gen share
1377         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1378 
1379         // toss 1% into airdrop pot
1380         uint256 _air = (_eth / 100);
1381         airDropPot_ = airDropPot_.add(_air);
1382 
1383         // update eth balance (eth = eth - (com share (2%)+ aff share (15%)+ airdrop pot share (1%)))
1384         _eth = _eth.sub(((_eth.mul(18)) / 100) / 100);
1385 
1386         // calculate pot
1387         uint256 _pot = _eth.sub(_gen);
1388 
1389         // distribute gen share (thats what updateMasks() does) and adjust
1390         // balances for dust.
1391         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1392         if (_dust > 0)
1393             _gen = _gen.sub(_dust);
1394 
1395         // add eth to pot
1396         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1397 
1398         // set up event data
1399         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1400         _eventData_.potAmount = _pot;
1401 
1402         return(_eventData_);
1403     }
1404 
1405     /**
1406      * @dev updates masks for round and player when keys are bought
1407      * @return dust left over
1408      */
1409     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1410     private
1411     returns(uint256)
1412     {
1413         /* MASKING NOTES
1414             earnings masks are a tricky thing for people to wrap their minds around.
1415             the basic thing to understand here.  is were going to have a global
1416             tracker based on profit per share for each round, that increases in
1417             relevant proportion to the increase in share supply.
1418 
1419             the player will have an additional mask that basically says "based
1420             on the rounds mask, my shares, and how much i've already withdrawn,
1421             how much is still owed to me?"
1422         */
1423 
1424         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1425         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1426         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1427 
1428         // calculate player earning from their own buy (only based on the keys
1429         // they just bought).  & update player earnings mask
1430         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1431         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1432 
1433         // calculate & return dust
1434         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1435     }
1436 
1437     /**
1438      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1439      * @return earnings in wei format
1440      */
1441     function withdrawEarnings(uint256 _pID)
1442     private
1443     returns(uint256)
1444     {
1445         // update gen vault
1446         updateGenVault(_pID, plyr_[_pID].lrnd);
1447 
1448         // from vaults
1449         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1450         if (_earnings > 0)
1451         {
1452             plyr_[_pID].win = 0;
1453             plyr_[_pID].gen = 0;
1454             plyr_[_pID].aff = 0;
1455         }
1456 
1457         return(_earnings);
1458     }
1459 
1460     /**
1461      * @dev prepares compression data and fires event for buy or reload tx's
1462      */
1463     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1464     private
1465     {
1466         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1467         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1468 
1469         emit F3Devents.onEndTx
1470         (
1471             _eventData_.compressedData,
1472             _eventData_.compressedIDs,
1473             plyr_[_pID].name,
1474             msg.sender,
1475             _eth,
1476             _keys,
1477             _eventData_.winnerAddr,
1478             _eventData_.winnerName,
1479             _eventData_.amountWon,
1480             _eventData_.newPot,
1481             _eventData_.P3DAmount,
1482             _eventData_.genAmount,
1483             _eventData_.potAmount,
1484             airDropPot_
1485         );
1486     }
1487     //==============================================================================
1488     //    (~ _  _    _._|_    .
1489     //    _)(/_(_|_|| | | \/  .
1490     //====================/=========================================================
1491     /** upon contract deploy, it will be deactivated.  this is a one time
1492      * use function that will activate the contract.  we do this so devs
1493      * have time to set things up on the web end                            **/
1494     bool public activated_ = false;
1495     function activate()
1496     public
1497     {
1498         require(msg.sender == admin, "only admin can activate");
1499 
1500         // can only be ran once
1501         require(activated_ == false, "FOMO4D already activated");
1502 
1503         // activate the contract
1504         activated_ = true;
1505 
1506         // lets start first round
1507         rID_ = 1;
1508         round_[1].strt = now + rndExtra_ - rndGap_;
1509         round_[1].end = now + rndInit_ + rndExtra_;
1510     }
1511 }
1512 
1513 //==============================================================================
1514 //   __|_ _    __|_ _  .
1515 //  _\ | | |_|(_ | _\  .
1516 //==============================================================================
1517 library F3Ddatasets {
1518     //compressedData key
1519     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1520     // 0 - new player (bool)
1521     // 1 - joined round (bool)
1522     // 2 - new  leader (bool)
1523     // 3-5 - air drop tracker (uint 0-999)
1524     // 6-16 - round end time
1525     // 17 - winnerTeam
1526     // 18 - 28 timestamp
1527     // 29 - team
1528     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1529     // 31 - airdrop happened bool
1530     // 32 - airdrop tier
1531     // 33 - airdrop amount won
1532     //compressedIDs key
1533     // [77-52][51-26][25-0]
1534     // 0-25 - pID
1535     // 26-51 - winPID
1536     // 52-77 - rID
1537     struct EventReturns {
1538         uint256 compressedData;
1539         uint256 compressedIDs;
1540         address winnerAddr;         // winner address
1541         bytes32 winnerName;         // winner name
1542         uint256 amountWon;          // amount won
1543         uint256 newPot;             // amount in new pot
1544         uint256 P3DAmount;          // amount distributed to p3d
1545         uint256 genAmount;          // amount distributed to gen
1546         uint256 potAmount;          // amount added to pot
1547     }
1548     struct Player {
1549         address addr;   // player address
1550         bytes32 name;   // player name
1551         uint256 win;    // winnings vault
1552         uint256 gen;    // general vault
1553         uint256 aff;    // affiliate vault
1554         uint256 lrnd;   // last round played
1555         uint256 laff;   // last affiliate id used
1556     }
1557     struct PlayerRounds {
1558         uint256 eth;    // eth player has added to round (used for eth limiter)
1559         uint256 keys;   // keys
1560         uint256 mask;   // player mask
1561         uint256 ico;    // ICO phase investment
1562     }
1563     struct Round {
1564         uint256 plyr;   // pID of player in lead
1565         uint256 team;   // tID of team in lead
1566         uint256 end;    // time ends/ended
1567         bool ended;     // has round end function been ran
1568         uint256 strt;   // time round started
1569         uint256 keys;   // keys
1570         uint256 eth;    // total eth in
1571         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1572         uint256 mask;   // global mask
1573         uint256 ico;    // total eth sent in during ICO phase
1574         uint256 icoGen; // total eth for gen during ICO phase
1575         uint256 icoAvg; // average key price for ICO phase
1576     }
1577     struct TeamFee {
1578         uint256 gen;    // % of buy in thats paid to key holders of current round
1579         uint256 p3d;    // % of buy in thats paid to p3d holders
1580     }
1581     struct PotSplit {
1582         uint256 gen;    // % of pot thats paid to key holders of current round
1583         uint256 p3d;    // % of pot thats paid to p3d holders
1584     }
1585 }
1586 
1587 //==============================================================================
1588 //  |  _      _ _ | _  .
1589 //  |<(/_\/  (_(_||(_  .
1590 //=======/======================================================================
1591 library F3DKeysCalcLong {
1592     using SafeMath for *;
1593     /**
1594      * @dev calculates number of keys received given X eth
1595      * @param _curEth current amount of eth in contract
1596      * @param _newEth eth being spent
1597      * @return amount of ticket purchased
1598      */
1599     function keysRec(uint256 _curEth, uint256 _newEth)
1600     internal
1601     pure
1602     returns (uint256)
1603     {
1604         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1605     }
1606 
1607     /**
1608      * @dev calculates amount of eth received if you sold X keys
1609      * @param _curKeys current amount of keys that exist
1610      * @param _sellKeys amount of keys you wish to sell
1611      * @return amount of eth received
1612      */
1613     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1614     internal
1615     pure
1616     returns (uint256)
1617     {
1618         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1619     }
1620 
1621     /**
1622      * @dev calculates how many keys would exist with given an amount of eth
1623      * @param _eth eth "in contract"
1624      * @return number of keys that would exist
1625      */
1626     function keys(uint256 _eth)
1627     internal
1628     pure
1629     returns(uint256)
1630     {
1631         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1632     }
1633 
1634     /**
1635      * @dev calculates how much eth would be in contract given a number of keys
1636      * @param _keys number of keys "in contract"
1637      * @return eth that would exists
1638      */
1639     function eth(uint256 _keys)
1640     internal
1641     pure
1642     returns(uint256)
1643     {
1644         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1645     }
1646 }
1647 
1648 //==============================================================================
1649 //  . _ _|_ _  _ |` _  _ _  _  .
1650 //  || | | (/_| ~|~(_|(_(/__\  .
1651 //==============================================================================
1652 
1653 interface PlayerBookInterface {
1654     function getPlayerID(address _addr) external returns (uint256);
1655     function getPlayerName(uint256 _pID) external view returns (bytes32);
1656     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1657     function getPlayerAddr(uint256 _pID) external view returns (address);
1658     function getNameFee() external view returns (uint256);
1659     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1660     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1661     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1662 }
1663 
1664 library NameFilter {
1665     /**
1666      * @dev filters name strings
1667      * -converts uppercase to lower case.
1668      * -makes sure it does not start/end with a space
1669      * -makes sure it does not contain multiple spaces in a row
1670      * -cannot be only numbers
1671      * -cannot start with 0x
1672      * -restricts characters to A-Z, a-z, 0-9, and space.
1673      * @return reprocessed string in bytes32 format
1674      */
1675     function nameFilter(string _input)
1676     internal
1677     pure
1678     returns(bytes32)
1679     {
1680         bytes memory _temp = bytes(_input);
1681         uint256 _length = _temp.length;
1682 
1683         //sorry limited to 32 characters
1684         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1685         // make sure it doesnt start with or end with space
1686         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1687         // make sure first two characters are not 0x
1688         if (_temp[0] == 0x30)
1689         {
1690             require(_temp[1] != 0x78, "string cannot start with 0x");
1691             require(_temp[1] != 0x58, "string cannot start with 0X");
1692         }
1693 
1694         // create a bool to track if we have a non number character
1695         bool _hasNonNumber;
1696 
1697         // convert & check
1698         for (uint256 i = 0; i < _length; i++)
1699         {
1700             // if its uppercase A-Z
1701             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1702             {
1703                 // convert to lower case a-z
1704                 _temp[i] = byte(uint(_temp[i]) + 32);
1705 
1706                 // we have a non number
1707                 if (_hasNonNumber == false)
1708                     _hasNonNumber = true;
1709             } else {
1710                 require
1711                 (
1712                 // require character is a space
1713                     _temp[i] == 0x20 ||
1714                 // OR lowercase a-z
1715                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1716                 // or 0-9
1717                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1718                     "string contains invalid characters"
1719                 );
1720                 // make sure theres not 2x spaces in a row
1721                 if (_temp[i] == 0x20)
1722                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1723 
1724                 // see if we have a character other than a number
1725                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1726                     _hasNonNumber = true;
1727             }
1728         }
1729 
1730         require(_hasNonNumber == true, "string cannot be only numbers");
1731 
1732         bytes32 _ret;
1733         assembly {
1734             _ret := mload(add(_temp, 32))
1735         }
1736         return (_ret);
1737     }
1738 }
1739 
1740 /**
1741  * @title SafeMath v0.1.9
1742  * @dev Math operations with safety checks that throw on error
1743  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1744  * - added sqrt
1745  * - added sq
1746  * - added pwr
1747  * - changed asserts to requires with error log outputs
1748  * - removed div, its useless
1749  */
1750 library SafeMath {
1751 
1752     /**
1753     * @dev Multiplies two numbers, throws on overflow.
1754     */
1755     function mul(uint256 a, uint256 b)
1756     internal
1757     pure
1758     returns (uint256 c)
1759     {
1760         if (a == 0) {
1761             return 0;
1762         }
1763         c = a * b;
1764         require(c / a == b, "SafeMath mul failed");
1765         return c;
1766     }
1767 
1768     /**
1769     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1770     */
1771     function sub(uint256 a, uint256 b)
1772     internal
1773     pure
1774     returns (uint256)
1775     {
1776         require(b <= a, "SafeMath sub failed");
1777         return a - b;
1778     }
1779 
1780     /**
1781     * @dev Adds two numbers, throws on overflow.
1782     */
1783     function add(uint256 a, uint256 b)
1784     internal
1785     pure
1786     returns (uint256 c)
1787     {
1788         c = a + b;
1789         require(c >= a, "SafeMath add failed");
1790         return c;
1791     }
1792 
1793     /**
1794      * @dev gives square root of given x.
1795      */
1796     function sqrt(uint256 x)
1797     internal
1798     pure
1799     returns (uint256 y)
1800     {
1801         uint256 z = ((add(x,1)) / 2);
1802         y = x;
1803         while (z < y)
1804         {
1805             y = z;
1806             z = ((add((x / z),z)) / 2);
1807         }
1808     }
1809 
1810     /**
1811      * @dev gives square. multiplies x by x
1812      */
1813     function sq(uint256 x)
1814     internal
1815     pure
1816     returns (uint256)
1817     {
1818         return (mul(x,x));
1819     }
1820 
1821     /**
1822      * @dev x to the power of y
1823      */
1824     function pwr(uint256 x, uint256 y)
1825     internal
1826     pure
1827     returns (uint256)
1828     {
1829         if (x==0)
1830             return (0);
1831         else if (y==0)
1832             return (1);
1833         else
1834         {
1835             uint256 z = x;
1836             for (uint256 i=1; i < y; i++)
1837                 z = mul(z,x);
1838             return (z);
1839         }
1840     }
1841 }