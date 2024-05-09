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
116 contract GameOfSwords is modularLong {
117     using SafeMath for *;
118     using NameFilter for string;
119     using F3DKeysCalcLong for uint256;
120 
121     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xfea380f677c9f9c0654afea10f720773efa6b4f1);
122 
123     address private admin = msg.sender;
124     address private com = 0x9f9FCa30aB69d8A5Dfbe5236A170b46fE99d7D6B;
125 
126     string constant public name = "GameOfSwords";
127     string constant public symbol = "GOS";
128     uint256 private rndExtra_ = 0;     // length of the very first ICO
129     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
130     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
131     uint256 constant private rndInc_ = 30 seconds;              // every full sword purchased adds this much to the timer
132     uint256 constant private rndMax_ = 12 hours;                // max length a round timer can be
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
166         // 0 = Tyrion
167         // 1 = Jon
168         // 2 = Daenerys
169         // 3 = Sansa
170 
171         // Team allocation percentages
172         // (F3D, P3D) + (Pot , Referrals, Community)
173         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
174         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
175         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
176         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
177         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
178 
179         // how to split up the final pot based on which team was picked
180         // (F3D, P3D)
181         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
182         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
183         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
184         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
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
203         // *breathes in*
204         // HAHAHAHA
205         //address _addr = msg.sender;
206         //uint256 _codeLength;
207         
208         //assembly {_codeLength := extcodesize(_addr)}
209         //require(_codeLength == 0, "sorry humans only");
210         require(msg.sender == tx.origin, "sorry humans only - FOR REAL THIS TIME");
211         _;
212     }
213 
214     /**
215      * @dev sets boundaries for incoming tx
216      */
217     modifier isWithinLimits(uint256 _eth) {
218         require(_eth >= 1000000000, "pocket lint: not a valid currency");
219         require(_eth <= 100000000000000000000000, "no vitalik, no");
220         _;
221     }
222 
223     //==============================================================================
224     //     _    |_ |. _   |`    _  __|_. _  _  _  .
225     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
226     //====|=========================================================================
227     /**
228      * @dev emergency buy uses last stored affiliate ID and team snek
229      */
230     function()
231     isActivated()
232     isHuman()
233     isWithinLimits(msg.value)
234     public
235     payable
236     {
237         // set up our tx event data and determine if player is new or not
238         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
239 
240         // fetch player id
241         uint256 _pID = pIDxAddr_[msg.sender];
242 
243         // buy core
244         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
245     }
246 
247     /**
248      * @dev converts all incoming ethereum to keys.
249      * -functionhash- 0x8f38f309 (using ID for affiliate)
250      * -functionhash- 0x98a0871d (using address for affiliate)
251      * -functionhash- 0xa65b37a1 (using name for affiliate)
252      * @param _affCode the ID/address/name of the player who gets the affiliate fee
253      * @param _team what team is the player playing for?
254      */
255     function buyXid(uint256 _affCode, uint256 _team)
256     isActivated()
257     isHuman()
258     isWithinLimits(msg.value)
259     public
260     payable
261     {
262         // set up our tx event data and determine if player is new or not
263         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
264 
265         // fetch player id
266         uint256 _pID = pIDxAddr_[msg.sender];
267 
268         // manage affiliate residuals
269         // if no affiliate code was given or player tried to use their own, lolz
270         if (_affCode == 0 || _affCode == _pID)
271         {
272             // use last stored affiliate code
273             _affCode = plyr_[_pID].laff;
274 
275             // if affiliate code was given & its not the same as previously stored
276         } else if (_affCode != plyr_[_pID].laff) {
277             // update last affiliate
278             plyr_[_pID].laff = _affCode;
279         }
280 
281         // verify a valid team was selected
282         _team = verifyTeam(_team);
283 
284         // buy core
285         buyCore(_pID, _affCode, _team, _eventData_);
286     }
287 
288     function buyXaddr(address _affCode, uint256 _team)
289     isActivated()
290     isHuman()
291     isWithinLimits(msg.value)
292     public
293     payable
294     {
295         // set up our tx event data and determine if player is new or not
296         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
297 
298         // fetch player id
299         uint256 _pID = pIDxAddr_[msg.sender];
300 
301         // manage affiliate residuals
302         uint256 _affID;
303         // if no affiliate code was given or player tried to use their own, lolz
304         if (_affCode == address(0) || _affCode == msg.sender)
305         {
306             // use last stored affiliate code
307             _affID = plyr_[_pID].laff;
308 
309             // if affiliate code was given
310         } else {
311             // get affiliate ID from aff Code
312             _affID = pIDxAddr_[_affCode];
313 
314             // if affID is not the same as previously stored
315             if (_affID != plyr_[_pID].laff)
316             {
317                 // update last affiliate
318                 plyr_[_pID].laff = _affID;
319             }
320         }
321 
322         // verify a valid team was selected
323         _team = verifyTeam(_team);
324 
325         // buy core
326         buyCore(_pID, _affID, _team, _eventData_);
327     }
328 
329     function buyXname(bytes32 _affCode, uint256 _team)
330     isActivated()
331     isHuman()
332     isWithinLimits(msg.value)
333     public
334     payable
335     {
336         // set up our tx event data and determine if player is new or not
337         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
338 
339         // fetch player id
340         uint256 _pID = pIDxAddr_[msg.sender];
341 
342         // manage affiliate residuals
343         uint256 _affID;
344         // if no affiliate code was given or player tried to use their own, lolz
345         if (_affCode == '' || _affCode == plyr_[_pID].name)
346         {
347             // use last stored affiliate code
348             _affID = plyr_[_pID].laff;
349 
350             // if affiliate code was given
351         } else {
352             // get affiliate ID from aff Code
353             _affID = pIDxName_[_affCode];
354 
355             // if affID is not the same as previously stored
356             if (_affID != plyr_[_pID].laff)
357             {
358                 // update last affiliate
359                 plyr_[_pID].laff = _affID;
360             }
361         }
362 
363         // verify a valid team was selected
364         _team = verifyTeam(_team);
365 
366         // buy core
367         buyCore(_pID, _affID, _team, _eventData_);
368     }
369 
370     /**
371      * @dev essentially the same as buy, but instead of you sending ether
372      * from your wallet, it uses your unwithdrawn earnings.
373      * -functionhash- 0x349cdcac (using ID for affiliate)
374      * -functionhash- 0x82bfc739 (using address for affiliate)
375      * -functionhash- 0x079ce327 (using name for affiliate)
376      * @param _affCode the ID/address/name of the player who gets the affiliate fee
377      * @param _team what team is the player playing for?
378      * @param _eth amount of earnings to use (remainder returned to gen vault)
379      */
380     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
381     isActivated()
382     isHuman()
383     isWithinLimits(_eth)
384     public
385     {
386         // set up our tx event data
387         F3Ddatasets.EventReturns memory _eventData_;
388 
389         // fetch player ID
390         uint256 _pID = pIDxAddr_[msg.sender];
391 
392         // manage affiliate residuals
393         // if no affiliate code was given or player tried to use their own, lolz
394         if (_affCode == 0 || _affCode == _pID)
395         {
396             // use last stored affiliate code
397             _affCode = plyr_[_pID].laff;
398 
399             // if affiliate code was given & its not the same as previously stored
400         } else if (_affCode != plyr_[_pID].laff) {
401             // update last affiliate
402             plyr_[_pID].laff = _affCode;
403         }
404 
405         // verify a valid team was selected
406         _team = verifyTeam(_team);
407 
408         // reload core
409         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
410     }
411 
412     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
413     isActivated()
414     isHuman()
415     isWithinLimits(_eth)
416     public
417     {
418         // set up our tx event data
419         F3Ddatasets.EventReturns memory _eventData_;
420 
421         // fetch player ID
422         uint256 _pID = pIDxAddr_[msg.sender];
423 
424         // manage affiliate residuals
425         uint256 _affID;
426         // if no affiliate code was given or player tried to use their own, lolz
427         if (_affCode == address(0) || _affCode == msg.sender)
428         {
429             // use last stored affiliate code
430             _affID = plyr_[_pID].laff;
431 
432             // if affiliate code was given
433         } else {
434             // get affiliate ID from aff Code
435             _affID = pIDxAddr_[_affCode];
436 
437             // if affID is not the same as previously stored
438             if (_affID != plyr_[_pID].laff)
439             {
440                 // update last affiliate
441                 plyr_[_pID].laff = _affID;
442             }
443         }
444 
445         // verify a valid team was selected
446         _team = verifyTeam(_team);
447 
448         // reload core
449         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
450     }
451 
452     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
453     isActivated()
454     isHuman()
455     isWithinLimits(_eth)
456     public
457     {
458         // set up our tx event data
459         F3Ddatasets.EventReturns memory _eventData_;
460 
461         // fetch player ID
462         uint256 _pID = pIDxAddr_[msg.sender];
463 
464         // manage affiliate residuals
465         uint256 _affID;
466         // if no affiliate code was given or player tried to use their own, lolz
467         if (_affCode == '' || _affCode == plyr_[_pID].name)
468         {
469             // use last stored affiliate code
470             _affID = plyr_[_pID].laff;
471 
472             // if affiliate code was given
473         } else {
474             // get affiliate ID from aff Code
475             _affID = pIDxName_[_affCode];
476 
477             // if affID is not the same as previously stored
478             if (_affID != plyr_[_pID].laff)
479             {
480                 // update last affiliate
481                 plyr_[_pID].laff = _affID;
482             }
483         }
484 
485         // verify a valid team was selected
486         _team = verifyTeam(_team);
487 
488         // reload core
489         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
490     }
491 
492     /**
493      * @dev withdraws all of your earnings.
494      * -functionhash- 0x3ccfd60b
495      */
496     function withdraw()
497     isActivated()
498     isHuman()
499     public
500     {
501         // setup local rID
502         uint256 _rID = rID_;
503 
504         // grab time
505         uint256 _now = now;
506 
507         // fetch player ID
508         uint256 _pID = pIDxAddr_[msg.sender];
509 
510         // setup temp var for player eth
511         uint256 _eth;
512 
513         // check to see if round has ended and no one has run round end yet
514         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
515         {
516             // set up our tx event data
517             F3Ddatasets.EventReturns memory _eventData_;
518 
519             // end the round (distributes pot)
520             round_[_rID].ended = true;
521             _eventData_ = endRound(_eventData_);
522 
523             // get their earnings
524             _eth = withdrawEarnings(_pID);
525 
526             // gib moni
527             if (_eth > 0)
528                 plyr_[_pID].addr.transfer(_eth);
529 
530             // build event data
531             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
532             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
533 
534             // fire withdraw and distribute event
535             emit F3Devents.onWithdrawAndDistribute
536             (
537                 msg.sender,
538                 plyr_[_pID].name,
539                 _eth,
540                 _eventData_.compressedData,
541                 _eventData_.compressedIDs,
542                 _eventData_.winnerAddr,
543                 _eventData_.winnerName,
544                 _eventData_.amountWon,
545                 _eventData_.newPot,
546                 _eventData_.P3DAmount,
547                 _eventData_.genAmount
548             );
549 
550             // in any other situation
551         } else {
552             // get their earnings
553             _eth = withdrawEarnings(_pID);
554 
555             // gib moni
556             if (_eth > 0)
557                 plyr_[_pID].addr.transfer(_eth);
558 
559             // fire withdraw event
560             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
561         }
562     }
563 
564     /**
565      * @dev use these to register names.  they are just wrappers that will send the
566      * registration requests to the PlayerBook contract.  So registering here is the
567      * same as registering there.  UI will always display the last name you registered.
568      * but you will still own all previously registered names to use as affiliate
569      * links.
570      * - must pay a registration fee.
571      * - name must be unique
572      * - names will be converted to lowercase
573      * - name cannot start or end with a space
574      * - cannot have more than 1 space in a row
575      * - cannot be only numbers
576      * - cannot start with 0x
577      * - name must be at least 1 char
578      * - max length of 32 characters long
579      * - allowed characters: a-z, 0-9, and space
580      * -functionhash- 0x921dec21 (using ID for affiliate)
581      * -functionhash- 0x3ddd4698 (using address for affiliate)
582      * -functionhash- 0x685ffd83 (using name for affiliate)
583      * @param _nameString players desired name
584      * @param _affCode affiliate ID, address, or name of who referred you
585      * @param _all set to true if you want this to push your info to all games
586      * (this might cost a lot of gas)
587      */
588     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
589     isHuman()
590     public
591     payable
592     {
593         bytes32 _name = _nameString.nameFilter();
594         address _addr = msg.sender;
595         uint256 _paid = msg.value;
596         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
597 
598         uint256 _pID = pIDxAddr_[_addr];
599 
600         // fire event
601         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
602     }
603 
604     function registerNameXaddr(string _nameString, address _affCode, bool _all)
605     isHuman()
606     public
607     payable
608     {
609         bytes32 _name = _nameString.nameFilter();
610         address _addr = msg.sender;
611         uint256 _paid = msg.value;
612         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
613 
614         uint256 _pID = pIDxAddr_[_addr];
615 
616         // fire event
617         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
618     }
619 
620     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
621     isHuman()
622     public
623     payable
624     {
625         bytes32 _name = _nameString.nameFilter();
626         address _addr = msg.sender;
627         uint256 _paid = msg.value;
628         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
629 
630         uint256 _pID = pIDxAddr_[_addr];
631 
632         // fire event
633         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
634     }
635     //==============================================================================
636     //     _  _ _|__|_ _  _ _  .
637     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
638     //=====_|=======================================================================
639     /**
640      * @dev return the price buyer will pay for next 1 individual key.
641      * -functionhash- 0x018a25e8
642      * @return price for next key bought (in wei format)
643      */
644     function getBuyPrice()
645     public
646     view
647     returns(uint256)
648     {
649         // setup local rID
650         uint256 _rID = rID_;
651 
652         // grab time
653         uint256 _now = now;
654 
655         // are we in a round?
656         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
657             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
658         else // rounds over.  need price for new round
659             return ( 75000000000000 ); // init
660     }
661 
662     /**
663      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
664      * provider
665      * -functionhash- 0xc7e284b8
666      * @return time left in seconds
667      */
668     function getTimeLeft()
669     public
670     view
671     returns(uint256)
672     {
673         // setup local rID
674         uint256 _rID = rID_;
675 
676         // grab time
677         uint256 _now = now;
678 
679         if (_now < round_[_rID].end)
680             if (_now > round_[_rID].strt + rndGap_)
681                 return( (round_[_rID].end).sub(_now) );
682             else
683                 return( (round_[_rID].strt + rndGap_).sub(_now) );
684         else
685             return(0);
686     }
687 
688     /**
689      * @dev returns player earnings per vaults
690      * -functionhash- 0x63066434
691      * @return winnings vault
692      * @return general vault
693      * @return affiliate vault
694      */
695     function getPlayerVaults(uint256 _pID)
696     public
697     view
698     returns(uint256 ,uint256, uint256)
699     {
700         // setup local rID
701         uint256 _rID = rID_;
702 
703         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
704         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
705         {
706             // if player is winner
707             if (round_[_rID].plyr == _pID)
708             {
709                 return
710                 (
711                 (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
712                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
713                 plyr_[_pID].aff
714                 );
715                 // if player is not the winner
716             } else {
717                 return
718                 (
719                 plyr_[_pID].win,
720                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
721                 plyr_[_pID].aff
722                 );
723             }
724 
725             // if round is still going on, or round has ended and round end has been ran
726         } else {
727             return
728             (
729             plyr_[_pID].win,
730             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
731             plyr_[_pID].aff
732             );
733         }
734     }
735 
736     /**
737      * solidity hates stack limits.  this lets us avoid that hate
738      */
739     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
740     private
741     view
742     returns(uint256)
743     {
744         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
745     }
746 
747     /**
748      * @dev returns all current round info needed for front end
749      * -functionhash- 0x747dff42
750      * @return eth invested during ICO phase
751      * @return round id
752      * @return total keys for round
753      * @return time round ends
754      * @return time round started
755      * @return current pot
756      * @return current team ID & player ID in lead
757      * @return current player in leads address
758      * @return current player in leads name
759      * @return whales eth in for round
760      * @return bears eth in for round
761      * @return sneks eth in for round
762      * @return bulls eth in for round
763      * @return airdrop tracker # & airdrop pot
764      */
765     function getCurrentRoundInfo()
766     public
767     view
768     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
769     {
770         // setup local rID
771         uint256 _rID = rID_;
772 
773         return
774         (
775         round_[_rID].ico,               //0
776         _rID,                           //1
777         round_[_rID].keys,              //2
778         round_[_rID].end,               //3
779         round_[_rID].strt,              //4
780         round_[_rID].pot,               //5
781         (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
782         plyr_[round_[_rID].plyr].addr,  //7
783         plyr_[round_[_rID].plyr].name,  //8
784         rndTmEth_[_rID][0],             //9
785         rndTmEth_[_rID][1],             //10
786         rndTmEth_[_rID][2],             //11
787         rndTmEth_[_rID][3],             //12
788         airDropTracker_ + (airDropPot_ * 1000)              //13
789         );
790     }
791 
792     /**
793      * @dev returns player info based on address.  if no address is given, it will
794      * use msg.sender
795      * -functionhash- 0xee0b5d8b
796      * @param _addr address of the player you want to lookup
797      * @return player ID
798      * @return player name
799      * @return keys owned (current round)
800      * @return winnings vault
801      * @return general vault
802      * @return affiliate vault
803    * @return player round eth
804      */
805     function getPlayerInfoByAddress(address _addr)
806     public
807     view
808     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
809     {
810         // setup local rID
811         uint256 _rID = rID_;
812 
813         if (_addr == address(0))
814         {
815             _addr == msg.sender;
816         }
817         uint256 _pID = pIDxAddr_[_addr];
818 
819         return
820         (
821         _pID,                               //0
822         plyr_[_pID].name,                   //1
823         plyrRnds_[_pID][_rID].keys,         //2
824         plyr_[_pID].win,                    //3
825         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
826         plyr_[_pID].aff,                    //5
827         plyrRnds_[_pID][_rID].eth           //6
828         );
829     }
830 
831     //==============================================================================
832     //     _ _  _ _   | _  _ . _  .
833     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
834     //=====================_|=======================================================
835     /**
836      * @dev logic runs whenever a buy order is executed.  determines how to handle
837      * incoming eth depending on if we are in an active round or not
838      */
839     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
840     private
841     {
842         // setup local rID
843         uint256 _rID = rID_;
844 
845         // grab time
846         uint256 _now = now;
847 
848         // if round is active
849         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
850         {
851             // call core
852             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
853 
854             // if round is not active
855         } else {
856             // check to see if end round needs to be ran
857             if (_now > round_[_rID].end && round_[_rID].ended == false)
858             {
859                 // end the round (distributes pot) & start new round
860                 round_[_rID].ended = true;
861                 _eventData_ = endRound(_eventData_);
862 
863                 // build event data
864                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
865                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
866 
867                 // fire buy and distribute event
868                 emit F3Devents.onBuyAndDistribute
869                 (
870                     msg.sender,
871                     plyr_[_pID].name,
872                     msg.value,
873                     _eventData_.compressedData,
874                     _eventData_.compressedIDs,
875                     _eventData_.winnerAddr,
876                     _eventData_.winnerName,
877                     _eventData_.amountWon,
878                     _eventData_.newPot,
879                     _eventData_.P3DAmount,
880                     _eventData_.genAmount
881                 );
882             }
883 
884             // put eth in players vault
885             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
886         }
887     }
888 
889     /**
890      * @dev logic runs whenever a reload order is executed.  determines how to handle
891      * incoming eth depending on if we are in an active round or not
892      */
893     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
894     private
895     {
896         // setup local rID
897         uint256 _rID = rID_;
898 
899         // grab time
900         uint256 _now = now;
901 
902         // if round is active
903         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
904         {
905             // get earnings from all vaults and return unused to gen vault
906             // because we use a custom safemath library.  this will throw if player
907             // tried to spend more eth than they have.
908             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
909 
910             // call core
911             core(_rID, _pID, _eth, _affID, _team, _eventData_);
912 
913             // if round is not active and end round needs to be ran
914         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
915             // end the round (distributes pot) & start new round
916             round_[_rID].ended = true;
917             _eventData_ = endRound(_eventData_);
918 
919             // build event data
920             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
921             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
922 
923             // fire buy and distribute event
924             emit F3Devents.onReLoadAndDistribute
925             (
926                 msg.sender,
927                 plyr_[_pID].name,
928                 _eventData_.compressedData,
929                 _eventData_.compressedIDs,
930                 _eventData_.winnerAddr,
931                 _eventData_.winnerName,
932                 _eventData_.amountWon,
933                 _eventData_.newPot,
934                 _eventData_.P3DAmount,
935                 _eventData_.genAmount
936             );
937         }
938     }
939 
940     /**
941      * @dev this is the core logic for any buy/reload that happens while a round
942      * is live.
943      */
944     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
945     private
946     {
947         // if player is new to round
948         if (plyrRnds_[_pID][_rID].keys == 0)
949             _eventData_ = managePlayer(_pID, _eventData_);
950 
951         // early round eth limiter
952 //        if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
953 //        {
954 //            uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
955 //            uint256 _refund = _eth.sub(_availableLimit);
956 //            plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
957 //            _eth = _availableLimit;
958 //        }
959 
960         // if eth left is greater than min eth allowed (sorry no pocket lint)
961         if (_eth > 1000000000)
962         {
963 
964             // mint the new keys
965             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
966 
967             // if they bought at least 1 whole key
968             if (_keys >= 1000000000000000000)
969             {
970                 updateTimer(_keys, _rID);
971 
972                 // set new leaders
973                 if (round_[_rID].plyr != _pID)
974                     round_[_rID].plyr = _pID;
975                 if (round_[_rID].team != _team)
976                     round_[_rID].team = _team;
977 
978                 // set the new leader bool to true
979                 _eventData_.compressedData = _eventData_.compressedData + 100;
980             }
981 
982             // manage airdrops
983             if (_eth >= 100000000000000000)
984             {
985                 airDropTracker_++;
986                 if (airdrop() == true)
987                 {
988                     // gib muni
989                     uint256 _prize;
990                     if (_eth >= 10000000000000000000)
991                     {
992                         // calculate prize and give it to winner
993                         _prize = ((airDropPot_).mul(75)) / 100;
994                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
995 
996                         // adjust airDropPot
997                         airDropPot_ = (airDropPot_).sub(_prize);
998 
999                         // let event know a tier 3 prize was won
1000                         _eventData_.compressedData += 300000000000000000000000000000000;
1001                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1002                         // calculate prize and give it to winner
1003                         _prize = ((airDropPot_).mul(50)) / 100;
1004                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1005 
1006                         // adjust airDropPot
1007                         airDropPot_ = (airDropPot_).sub(_prize);
1008 
1009                         // let event know a tier 2 prize was won
1010                         _eventData_.compressedData += 200000000000000000000000000000000;
1011                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1012                         // calculate prize and give it to winner
1013                         _prize = ((airDropPot_).mul(25)) / 100;
1014                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1015 
1016                         // adjust airDropPot
1017                         airDropPot_ = (airDropPot_).sub(_prize);
1018 
1019                         // let event know a tier 3 prize was won
1020                         _eventData_.compressedData += 300000000000000000000000000000000;
1021                     }
1022                     // set airdrop happened bool to true
1023                     _eventData_.compressedData += 10000000000000000000000000000000;
1024                     // let event know how much was won
1025                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1026 
1027                     // reset air drop tracker
1028                     airDropTracker_ = 0;
1029                 }
1030             }
1031 
1032             // store the air drop tracker number (number of buys since last airdrop)
1033             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1034 
1035             // update player
1036             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1037             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1038 
1039             // update round
1040             round_[_rID].keys = _keys.add(round_[_rID].keys);
1041             round_[_rID].eth = _eth.add(round_[_rID].eth);
1042             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1043 
1044             // distribute eth
1045             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1046             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1047 
1048             // call end tx function to fire end tx event.
1049             endTx(_pID, _team, _eth, _keys, _eventData_);
1050         }
1051     }
1052     //==============================================================================
1053     //     _ _ | _   | _ _|_ _  _ _  .
1054     //    (_(_||(_|_||(_| | (_)| _\  .
1055     //==============================================================================
1056     /**
1057      * @dev calculates unmasked earnings (just calculates, does not update mask)
1058      * @return earnings in wei format
1059      */
1060     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1061     private
1062     view
1063     returns(uint256)
1064     {
1065         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1066     }
1067 
1068     /**
1069      * @dev returns the amount of keys you would get given an amount of eth.
1070      * -functionhash- 0xce89c80c
1071      * @param _rID round ID you want price for
1072      * @param _eth amount of eth sent in
1073      * @return keys received
1074      */
1075     function calcKeysReceived(uint256 _rID, uint256 _eth)
1076     public
1077     view
1078     returns(uint256)
1079     {
1080         // grab time
1081         uint256 _now = now;
1082 
1083         // are we in a round?
1084         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1085             return ( (round_[_rID].eth).keysRec(_eth) );
1086         else // rounds over.  need keys for new round
1087             return ( (_eth).keys() );
1088     }
1089 
1090     /**
1091      * @dev returns current eth price for X keys.
1092      * -functionhash- 0xcf808000
1093      * @param _keys number of keys desired (in 18 decimal format)
1094      * @return amount of eth needed to send
1095      */
1096     function iWantXKeys(uint256 _keys)
1097     public
1098     view
1099     returns(uint256)
1100     {
1101         // setup local rID
1102         uint256 _rID = rID_;
1103 
1104         // grab time
1105         uint256 _now = now;
1106 
1107         // are we in a round?
1108         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1109             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1110         else // rounds over.  need price for new round
1111             return ( (_keys).eth() );
1112     }
1113     //==============================================================================
1114     //    _|_ _  _ | _  .
1115     //     | (_)(_)|_\  .
1116     //==============================================================================
1117     /**
1118    * @dev receives name/player info from names contract
1119      */
1120     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1121     external
1122     {
1123         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1124         if (pIDxAddr_[_addr] != _pID)
1125             pIDxAddr_[_addr] = _pID;
1126         if (pIDxName_[_name] != _pID)
1127             pIDxName_[_name] = _pID;
1128         if (plyr_[_pID].addr != _addr)
1129             plyr_[_pID].addr = _addr;
1130         if (plyr_[_pID].name != _name)
1131             plyr_[_pID].name = _name;
1132         if (plyr_[_pID].laff != _laff)
1133             plyr_[_pID].laff = _laff;
1134         if (plyrNames_[_pID][_name] == false)
1135             plyrNames_[_pID][_name] = true;
1136     }
1137 
1138     /**
1139      * @dev receives entire player name list
1140      */
1141     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1142     external
1143     {
1144         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1145         if(plyrNames_[_pID][_name] == false)
1146             plyrNames_[_pID][_name] = true;
1147     }
1148 
1149     /**
1150      * @dev gets existing or registers new pID.  use this when a player may be new
1151      * @return pID
1152      */
1153     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1154     private
1155     returns (F3Ddatasets.EventReturns)
1156     {
1157         uint256 _pID = pIDxAddr_[msg.sender];
1158         // if player is new to this version of fomo3d
1159         if (_pID == 0)
1160         {
1161             // grab their player ID, name and last aff ID, from player names contract
1162             _pID = PlayerBook.getPlayerID(msg.sender);
1163             bytes32 _name = PlayerBook.getPlayerName(_pID);
1164             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1165 
1166             // set up player account
1167             pIDxAddr_[msg.sender] = _pID;
1168             plyr_[_pID].addr = msg.sender;
1169 
1170             if (_name != "")
1171             {
1172                 pIDxName_[_name] = _pID;
1173                 plyr_[_pID].name = _name;
1174                 plyrNames_[_pID][_name] = true;
1175             }
1176 
1177             if (_laff != 0 && _laff != _pID)
1178                 plyr_[_pID].laff = _laff;
1179 
1180             // set the new player bool to true
1181             _eventData_.compressedData = _eventData_.compressedData + 1;
1182         }
1183         return (_eventData_);
1184     }
1185 
1186     /**
1187      * @dev checks to make sure user picked a valid team.  if not sets team
1188      * to default (sneks)
1189      */
1190     function verifyTeam(uint256 _team)
1191     private
1192     pure
1193     returns (uint256)
1194     {
1195         if (_team < 0 || _team > 3)
1196             return(2);
1197         else
1198             return(_team);
1199     }
1200 
1201     /**
1202      * @dev decides if round end needs to be run & new round started.  and if
1203      * player unmasked earnings from previously played rounds need to be moved.
1204      */
1205     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1206     private
1207     returns (F3Ddatasets.EventReturns)
1208     {
1209         // if player has played a previous round, move their unmasked earnings
1210         // from that round to gen vault.
1211         if (plyr_[_pID].lrnd != 0)
1212             updateGenVault(_pID, plyr_[_pID].lrnd);
1213 
1214         // update player's last round played
1215         plyr_[_pID].lrnd = rID_;
1216 
1217         // set the joined round bool to true
1218         _eventData_.compressedData = _eventData_.compressedData + 10;
1219 
1220         return(_eventData_);
1221     }
1222 
1223     /**
1224      * @dev ends the round. manages paying out winner/splitting up pot
1225      */
1226     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1227     private
1228     returns (F3Ddatasets.EventReturns)
1229     {
1230         // setup local rID
1231         uint256 _rID = rID_;
1232 
1233         // grab our winning player and team id's
1234         uint256 _winPID = round_[_rID].plyr;
1235         uint256 _winTID = round_[_rID].team;
1236 
1237         // grab our pot amount
1238         uint256 _pot = round_[_rID].pot;
1239 
1240         // calculate our winner share, community rewards, gen share,
1241         // p3d share, and amount reserved for next pot
1242         uint256 _win = (_pot.mul(48)) / 100;
1243         uint256 _com = (_pot / 50);
1244         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1245         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1246 
1247         // calculate ppt for round mask
1248         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1249         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1250         if (_dust > 0)
1251         {
1252             _gen = _gen.sub(_dust);
1253             _res = _res.add(_dust);
1254         }
1255 
1256         // pay our winner
1257         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1258 
1259         // community rewards
1260         com.transfer(_com);
1261 
1262         // distribute gen portion to key holders
1263         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1264 
1265         // prepare event data
1266         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1267         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1268         _eventData_.winnerAddr = plyr_[_winPID].addr;
1269         _eventData_.winnerName = plyr_[_winPID].name;
1270         _eventData_.amountWon = _win;
1271         _eventData_.genAmount = _gen;
1272         _eventData_.P3DAmount = 0;
1273         _eventData_.newPot = _res;
1274 
1275         // start next round
1276         rID_++;
1277         _rID++;
1278         round_[_rID].strt = now;
1279         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1280         round_[_rID].pot = _res;
1281 
1282         return(_eventData_);
1283     }
1284 
1285     /**
1286      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1287      */
1288     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1289     private
1290     {
1291         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1292         if (_earnings > 0)
1293         {
1294             // put in gen vault
1295             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1296             // zero out their earnings by updating mask
1297             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1298         }
1299     }
1300 
1301     /**
1302      * @dev updates round timer based on number of whole keys bought.
1303      */
1304     function updateTimer(uint256 _keys, uint256 _rID)
1305     private
1306     {
1307         // grab time
1308         uint256 _now = now;
1309 
1310         // calculate time based on number of keys bought
1311         uint256 _newTime;
1312         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1313             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1314         else
1315             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1316 
1317         // compare to max and set new end time
1318         if (_newTime < (rndMax_).add(_now))
1319             round_[_rID].end = _newTime;
1320         else
1321             round_[_rID].end = rndMax_.add(_now);
1322     }
1323 
1324     /**
1325      * @dev generates a random number between 0-99 and checks to see if thats
1326      * resulted in an airdrop win
1327      * @return do we have a winner?
1328      */
1329     function airdrop()
1330     private
1331     view
1332     returns(bool)
1333     {
1334         uint256 seed = uint256(keccak256(abi.encodePacked(
1335 
1336                 (block.timestamp).add
1337                 (block.difficulty).add
1338                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1339                 (block.gaslimit).add
1340                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1341                 (block.number)
1342 
1343             )));
1344         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1345             return(true);
1346         else
1347             return(false);
1348     }
1349 
1350     /**
1351      * @dev distributes eth based on fees to com, aff, and p3d
1352      */
1353     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1354         private
1355         returns(F3Ddatasets.EventReturns)
1356     {
1357         // pay 3% out to community rewards
1358         uint256 _p1 = _eth / 100;
1359         uint256 _com = _eth / 50;
1360         _com = _com.add(_p1);
1361 
1362         uint256 _p3d;
1363         if (!address(admin).call.value(_com)())
1364         {
1365             // This ensures Team Just cannot influence the outcome of FoMo3D with
1366             // bank migrations by breaking outgoing transactions.
1367             // Something we would never do. But that's not the point.
1368             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1369             // highest belief that everything we create should be trustless.
1370             // Team JUST, The name you shouldn't have to trust.
1371             _p3d = _com;
1372             _com = 0;
1373         }
1374 
1375 
1376         // distribute share to affiliate
1377         uint256 _aff = _eth / 10;
1378 
1379         // decide what to do with affiliate share of fees
1380         // affiliate must not be self, and must have a name registered
1381         if (_affID != _pID && plyr_[_affID].name != '') {
1382             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1383             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1384         } else {
1385             _p3d = _aff;
1386         }
1387 
1388         // pay out p3d
1389         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1390         if (_p3d > 0)
1391         {
1392             // deposit to divies contract
1393             uint256 _potAmount = _p3d;
1394             
1395             //p3d rewards straight to the pot enjoy
1396             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1397 
1398             // set up event data
1399             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1400         }
1401 
1402         return(_eventData_);
1403     }
1404 
1405     /**
1406      * @dev distributes eth based on fees to gen and pot
1407      */
1408     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1409     private
1410     returns(F3Ddatasets.EventReturns)
1411     {
1412         // calculate gen share
1413         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1414 
1415         // toss 1% into airdrop pot
1416         uint256 _air = (_eth / 100);
1417         airDropPot_ = airDropPot_.add(_air);
1418 
1419         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1420         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1421 
1422         // calculate pot
1423         uint256 _pot = _eth.sub(_gen);
1424 
1425         // distribute gen share (thats what updateMasks() does) and adjust
1426         // balances for dust.
1427         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1428         if (_dust > 0)
1429             _gen = _gen.sub(_dust);
1430 
1431         // add eth to pot
1432         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1433 
1434         // set up event data
1435         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1436         _eventData_.potAmount = _pot;
1437 
1438         return(_eventData_);
1439     }
1440 
1441     /**
1442      * @dev updates masks for round and player when keys are bought
1443      * @return dust left over
1444      */
1445     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1446     private
1447     returns(uint256)
1448     {
1449         /* MASKING NOTES
1450             earnings masks are a tricky thing for people to wrap their minds around.
1451             the basic thing to understand here.  is were going to have a global
1452             tracker based on profit per share for each round, that increases in
1453             relevant proportion to the increase in share supply.
1454 
1455             the player will have an additional mask that basically says "based
1456             on the rounds mask, my shares, and how much i've already withdrawn,
1457             how much is still owed to me?"
1458         */
1459 
1460         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1461         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1462         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1463 
1464         // calculate player earning from their own buy (only based on the keys
1465         // they just bought).  & update player earnings mask
1466         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1467         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1468 
1469         // calculate & return dust
1470         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1471     }
1472 
1473     /**
1474      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1475      * @return earnings in wei format
1476      */
1477     function withdrawEarnings(uint256 _pID)
1478     private
1479     returns(uint256)
1480     {
1481         // update gen vault
1482         updateGenVault(_pID, plyr_[_pID].lrnd);
1483 
1484         // from vaults
1485         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1486         if (_earnings > 0)
1487         {
1488             plyr_[_pID].win = 0;
1489             plyr_[_pID].gen = 0;
1490             plyr_[_pID].aff = 0;
1491         }
1492 
1493         return(_earnings);
1494     }
1495 
1496     /**
1497      * @dev prepares compression data and fires event for buy or reload tx's
1498      */
1499     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1500     private
1501     {
1502         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1503         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1504 
1505         emit F3Devents.onEndTx
1506         (
1507             _eventData_.compressedData,
1508             _eventData_.compressedIDs,
1509             plyr_[_pID].name,
1510             msg.sender,
1511             _eth,
1512             _keys,
1513             _eventData_.winnerAddr,
1514             _eventData_.winnerName,
1515             _eventData_.amountWon,
1516             _eventData_.newPot,
1517             _eventData_.P3DAmount,
1518             _eventData_.genAmount,
1519             _eventData_.potAmount,
1520             airDropPot_
1521         );
1522     }
1523     //==============================================================================
1524     //    (~ _  _    _._|_    .
1525     //    _)(/_(_|_|| | | \/  .
1526     //====================/=========================================================
1527     /** upon contract deploy, it will be deactivated.  this is a one time
1528      * use function that will activate the contract.  we do this so devs
1529      * have time to set things up on the web end                            **/
1530     bool public activated_ = false;
1531     function activate()
1532     public
1533     {
1534         require(msg.sender == admin, "only admin can activate");
1535 
1536         // can only be ran once
1537         require(activated_ == false, "FOMO Short already activated");
1538 
1539         // activate the contract
1540         activated_ = true;
1541 
1542         // lets start first round
1543         rID_ = 1;
1544         round_[1].strt = now + rndExtra_ - rndGap_;
1545         round_[1].end = now + rndInit_ + rndExtra_;
1546     }
1547 }
1548 
1549 //==============================================================================
1550 //   __|_ _    __|_ _  .
1551 //  _\ | | |_|(_ | _\  .
1552 //==============================================================================
1553 library F3Ddatasets {
1554     //compressedData key
1555     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1556     // 0 - new player (bool)
1557     // 1 - joined round (bool)
1558     // 2 - new  leader (bool)
1559     // 3-5 - air drop tracker (uint 0-999)
1560     // 6-16 - round end time
1561     // 17 - winnerTeam
1562     // 18 - 28 timestamp
1563     // 29 - team
1564     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1565     // 31 - airdrop happened bool
1566     // 32 - airdrop tier
1567     // 33 - airdrop amount won
1568     //compressedIDs key
1569     // [77-52][51-26][25-0]
1570     // 0-25 - pID
1571     // 26-51 - winPID
1572     // 52-77 - rID
1573     struct EventReturns {
1574         uint256 compressedData;
1575         uint256 compressedIDs;
1576         address winnerAddr;         // winner address
1577         bytes32 winnerName;         // winner name
1578         uint256 amountWon;          // amount won
1579         uint256 newPot;             // amount in new pot
1580         uint256 P3DAmount;          // amount distributed to p3d
1581         uint256 genAmount;          // amount distributed to gen
1582         uint256 potAmount;          // amount added to pot
1583     }
1584     struct Player {
1585         address addr;   // player address
1586         bytes32 name;   // player name
1587         uint256 win;    // winnings vault
1588         uint256 gen;    // general vault
1589         uint256 aff;    // affiliate vault
1590         uint256 lrnd;   // last round played
1591         uint256 laff;   // last affiliate id used
1592     }
1593     struct PlayerRounds {
1594         uint256 eth;    // eth player has added to round (used for eth limiter)
1595         uint256 keys;   // keys
1596         uint256 mask;   // player mask
1597         uint256 ico;    // ICO phase investment
1598     }
1599     struct Round {
1600         uint256 plyr;   // pID of player in lead
1601         uint256 team;   // tID of team in lead
1602         uint256 end;    // time ends/ended
1603         bool ended;     // has round end function been ran
1604         uint256 strt;   // time round started
1605         uint256 keys;   // keys
1606         uint256 eth;    // total eth in
1607         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1608         uint256 mask;   // global mask
1609         uint256 ico;    // total eth sent in during ICO phase
1610         uint256 icoGen; // total eth for gen during ICO phase
1611         uint256 icoAvg; // average key price for ICO phase
1612     }
1613     struct TeamFee {
1614         uint256 gen;    // % of buy in thats paid to key holders of current round
1615         uint256 p3d;    // % of buy in thats paid to p3d holders
1616     }
1617     struct PotSplit {
1618         uint256 gen;    // % of pot thats paid to key holders of current round
1619         uint256 p3d;    // % of pot thats paid to p3d holders
1620     }
1621 }
1622 
1623 //==============================================================================
1624 //  |  _      _ _ | _  .
1625 //  |<(/_\/  (_(_||(_  .
1626 //=======/======================================================================
1627 library F3DKeysCalcLong {
1628     using SafeMath for *;
1629     /**
1630      * @dev calculates number of keys received given X eth
1631      * @param _curEth current amount of eth in contract
1632      * @param _newEth eth being spent
1633      * @return amount of ticket purchased
1634      */
1635     function keysRec(uint256 _curEth, uint256 _newEth)
1636     internal
1637     pure
1638     returns (uint256)
1639     {
1640         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1641     }
1642 
1643     /**
1644      * @dev calculates amount of eth received if you sold X keys
1645      * @param _curKeys current amount of keys that exist
1646      * @param _sellKeys amount of keys you wish to sell
1647      * @return amount of eth received
1648      */
1649     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1650     internal
1651     pure
1652     returns (uint256)
1653     {
1654         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1655     }
1656 
1657     /**
1658      * @dev calculates how many keys would exist with given an amount of eth
1659      * @param _eth eth "in contract"
1660      * @return number of keys that would exist
1661      */
1662     function keys(uint256 _eth)
1663     internal
1664     pure
1665     returns(uint256)
1666     {
1667         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1668     }
1669 
1670     /**
1671      * @dev calculates how much eth would be in contract given a number of keys
1672      * @param _keys number of keys "in contract"
1673      * @return eth that would exists
1674      */
1675     function eth(uint256 _keys)
1676     internal
1677     pure
1678     returns(uint256)
1679     {
1680         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1681     }
1682 }
1683 
1684 //==============================================================================
1685 //  . _ _|_ _  _ |` _  _ _  _  .
1686 //  || | | (/_| ~|~(_|(_(/__\  .
1687 //==============================================================================
1688 
1689 interface PlayerBookInterface {
1690     function getPlayerID(address _addr) external returns (uint256);
1691     function getPlayerName(uint256 _pID) external view returns (bytes32);
1692     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1693     function getPlayerAddr(uint256 _pID) external view returns (address);
1694     function getNameFee() external view returns (uint256);
1695     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1696     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1697     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1698 }
1699 
1700 library NameFilter {
1701     /**
1702      * @dev filters name strings
1703      * -converts uppercase to lower case.
1704      * -makes sure it does not start/end with a space
1705      * -makes sure it does not contain multiple spaces in a row
1706      * -cannot be only numbers
1707      * -cannot start with 0x
1708      * -restricts characters to A-Z, a-z, 0-9, and space.
1709      * @return reprocessed string in bytes32 format
1710      */
1711     function nameFilter(string _input)
1712     internal
1713     pure
1714     returns(bytes32)
1715     {
1716         bytes memory _temp = bytes(_input);
1717         uint256 _length = _temp.length;
1718 
1719         //sorry limited to 32 characters
1720         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1721         // make sure it doesnt start with or end with space
1722         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1723         // make sure first two characters are not 0x
1724         if (_temp[0] == 0x30)
1725         {
1726             require(_temp[1] != 0x78, "string cannot start with 0x");
1727             require(_temp[1] != 0x58, "string cannot start with 0X");
1728         }
1729 
1730         // create a bool to track if we have a non number character
1731         bool _hasNonNumber;
1732 
1733         // convert & check
1734         for (uint256 i = 0; i < _length; i++)
1735         {
1736             // if its uppercase A-Z
1737             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1738             {
1739                 // convert to lower case a-z
1740                 _temp[i] = byte(uint(_temp[i]) + 32);
1741 
1742                 // we have a non number
1743                 if (_hasNonNumber == false)
1744                     _hasNonNumber = true;
1745             } else {
1746                 require
1747                 (
1748                 // require character is a space
1749                     _temp[i] == 0x20 ||
1750                 // OR lowercase a-z
1751                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1752                 // or 0-9
1753                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1754                     "string contains invalid characters"
1755                 );
1756                 // make sure theres not 2x spaces in a row
1757                 if (_temp[i] == 0x20)
1758                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1759 
1760                 // see if we have a character other than a number
1761                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1762                     _hasNonNumber = true;
1763             }
1764         }
1765 
1766         require(_hasNonNumber == true, "string cannot be only numbers");
1767 
1768         bytes32 _ret;
1769         assembly {
1770             _ret := mload(add(_temp, 32))
1771         }
1772         return (_ret);
1773     }
1774 }
1775 
1776 /**
1777  * @title SafeMath v0.1.9
1778  * @dev Math operations with safety checks that throw on error
1779  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1780  * - added sqrt
1781  * - added sq
1782  * - added pwr
1783  * - changed asserts to requires with error log outputs
1784  * - removed div, its useless
1785  */
1786 library SafeMath {
1787 
1788     /**
1789     * @dev Multiplies two numbers, throws on overflow.
1790     */
1791     function mul(uint256 a, uint256 b)
1792     internal
1793     pure
1794     returns (uint256 c)
1795     {
1796         if (a == 0) {
1797             return 0;
1798         }
1799         c = a * b;
1800         require(c / a == b, "SafeMath mul failed");
1801         return c;
1802     }
1803 
1804     /**
1805     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1806     */
1807     function sub(uint256 a, uint256 b)
1808     internal
1809     pure
1810     returns (uint256)
1811     {
1812         require(b <= a, "SafeMath sub failed");
1813         return a - b;
1814     }
1815 
1816     /**
1817     * @dev Adds two numbers, throws on overflow.
1818     */
1819     function add(uint256 a, uint256 b)
1820     internal
1821     pure
1822     returns (uint256 c)
1823     {
1824         c = a + b;
1825         require(c >= a, "SafeMath add failed");
1826         return c;
1827     }
1828 
1829     /**
1830      * @dev gives square root of given x.
1831      */
1832     function sqrt(uint256 x)
1833     internal
1834     pure
1835     returns (uint256 y)
1836     {
1837         uint256 z = ((add(x,1)) / 2);
1838         y = x;
1839         while (z < y)
1840         {
1841             y = z;
1842             z = ((add((x / z),z)) / 2);
1843         }
1844     }
1845 
1846     /**
1847      * @dev gives square. multiplies x by x
1848      */
1849     function sq(uint256 x)
1850     internal
1851     pure
1852     returns (uint256)
1853     {
1854         return (mul(x,x));
1855     }
1856 
1857     /**
1858      * @dev x to the power of y
1859      */
1860     function pwr(uint256 x, uint256 y)
1861     internal
1862     pure
1863     returns (uint256)
1864     {
1865         if (x==0)
1866             return (0);
1867         else if (y==0)
1868             return (1);
1869         else
1870         {
1871             uint256 z = x;
1872             for (uint256 i=1; i < y; i++)
1873                 z = mul(z,x);
1874             return (z);
1875         }
1876     }
1877 }