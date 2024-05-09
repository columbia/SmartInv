1 pragma solidity ^0.4.24;
2 
3 contract HXevents {
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
63     // fired whenever a player tries a buy after round timer 
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
80     // fired whenever a player tries a reload after round timer 
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
121 contract modularShort is HXevents {}
122 
123 contract HX is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using HXKeysCalcLong for uint256;
127 	
128     address community_addr = 0x31D19054aa337207573E3aFf7644a9Fe0EB094C2;
129 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xc6645d6c197f2d634822f08da5809065bad03785);
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     string constant public name = "HX";
135     string constant public symbol = "HX";
136     uint256 private rndExtra_ = 0;     // length of the very first ICO
137     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
138     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
139     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
140     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be             // max length a round timer can be
141 //==============================================================================
142 //     _| _ _|_ _    _ _ _|_    _   .
143 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
144 //=============================|================================================
145 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
146     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
147     uint256 public rID_;    // round id number / total rounds that have happened
148 //****************
149 // PLAYER DATA 
150 //****************
151     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
152     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
153     mapping (uint256 => HXdatasets.Player) public plyr_;   // (pID => data) player data
154     mapping (uint256 => mapping (uint256 => HXdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
155     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
156 //****************
157 // ROUND DATA 
158 //****************
159     mapping (uint256 => HXdatasets.Round) public round_;   // (rID => data) round data
160     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
161 //****************
162 // TEAM FEE DATA 
163 //****************
164     mapping (uint256 => HXdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
165     mapping (uint256 => HXdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
166 //==============================================================================
167 //     _ _  _  __|_ _    __|_ _  _  .
168 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
169 //==============================================================================
170     constructor()
171         public
172     {
173 		// Team allocation structures
174         // 0 = whales
175         // 1 = bears
176         // 2 = sneks
177         // 3 = bulls
178 
179 		// Team allocation percentages
180         // (HX, 0) + (Pot , Referrals, Community)
181             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
182         fees_[0] = HXdatasets.TeamFee(30,0);   //46% to pot, 20% to aff, 2% to com, 2% to air drop pot
183         fees_[1] = HXdatasets.TeamFee(43,0);   //33% to pot, 20% to aff, 2% to com, 2% to air drop pot
184         fees_[2] = HXdatasets.TeamFee(56,0);  //20% to pot, 20% to aff, 2% to com, 2% to air drop pot
185         fees_[3] = HXdatasets.TeamFee(43,8);   //33% to pot, 20% to aff, 2% to com, 2% to air drop pot
186         
187         // how to split up the final pot based on which team was picked
188         // (HX, 0)
189         potSplit_[0] = HXdatasets.PotSplit(15,0);  //48% to winner, 25% to next round, 12% to com
190         potSplit_[1] = HXdatasets.PotSplit(20,0);   //48% to winner, 20% to next round, 12% to com
191         potSplit_[2] = HXdatasets.PotSplit(25,0);  //48% to winner, 15% to next round, 12% to com
192         potSplit_[3] = HXdatasets.PotSplit(30,0);  //48% to winner, 10% to next round, 12% to com
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
203         require(activated_ == true, "its not ready yet.  "); 
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
243         HXdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
268         HXdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
301         HXdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
342         HXdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
375     /**
376      * @dev essentially the same as buy, but instead of you sending ether 
377      * from your wallet, it uses your unwithdrawn earnings.
378      * -functionhash- 0x349cdcac (using ID for affiliate)
379      * -functionhash- 0x82bfc739 (using address for affiliate)
380      * -functionhash- 0x079ce327 (using name for affiliate)
381      * @param _affCode the ID/address/name of the player who gets the affiliate fee
382      * @param _team what team is the player playing for?
383      * @param _eth amount of earnings to use (remainder returned to gen vault)
384      */
385     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
386         isActivated()
387         isHuman()
388         isWithinLimits(_eth)
389         public
390     {
391         // set up our tx event data
392         HXdatasets.EventReturns memory _eventData_;
393         
394         // fetch player ID
395         uint256 _pID = pIDxAddr_[msg.sender];
396         
397         // manage affiliate residuals
398         // if no affiliate code was given or player tried to use their own, lolz
399         if (_affCode == 0 || _affCode == _pID)
400         {
401             // use last stored affiliate code 
402             _affCode = plyr_[_pID].laff;
403             
404         // if affiliate code was given & its not the same as previously stored 
405         } else if (_affCode != plyr_[_pID].laff) {
406             // update last affiliate 
407             plyr_[_pID].laff = _affCode;
408         }
409 
410         // verify a valid team was selected
411         _team = verifyTeam(_team);
412 
413         // reload core
414         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
415     }
416     
417     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
418         isActivated()
419         isHuman()
420         isWithinLimits(_eth)
421         public
422     {
423         // set up our tx event data
424         HXdatasets.EventReturns memory _eventData_;
425         
426         // fetch player ID
427         uint256 _pID = pIDxAddr_[msg.sender];
428         
429         // manage affiliate residuals
430         uint256 _affID;
431         // if no affiliate code was given or player tried to use their own, lolz
432         if (_affCode == address(0) || _affCode == msg.sender)
433         {
434             // use last stored affiliate code
435             _affID = plyr_[_pID].laff;
436         
437         // if affiliate code was given    
438         } else {
439             // get affiliate ID from aff Code 
440             _affID = pIDxAddr_[_affCode];
441             
442             // if affID is not the same as previously stored 
443             if (_affID != plyr_[_pID].laff)
444             {
445                 // update last affiliate
446                 plyr_[_pID].laff = _affID;
447             }
448         }
449         
450         // verify a valid team was selected
451         _team = verifyTeam(_team);
452         
453         // reload core
454         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
455     }
456     
457     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
458         isActivated()
459         isHuman()
460         isWithinLimits(_eth)
461         public
462     {
463         // set up our tx event data
464         HXdatasets.EventReturns memory _eventData_;
465         
466         // fetch player ID
467         uint256 _pID = pIDxAddr_[msg.sender];
468         
469         // manage affiliate residuals
470         uint256 _affID;
471         // if no affiliate code was given or player tried to use their own, lolz
472         if (_affCode == '' || _affCode == plyr_[_pID].name)
473         {
474             // use last stored affiliate code
475             _affID = plyr_[_pID].laff;
476         
477         // if affiliate code was given
478         } else {
479             // get affiliate ID from aff Code
480             _affID = pIDxName_[_affCode];
481             
482             // if affID is not the same as previously stored
483             if (_affID != plyr_[_pID].laff)
484             {
485                 // update last affiliate
486                 plyr_[_pID].laff = _affID;
487             }
488         }
489         
490         // verify a valid team was selected
491         _team = verifyTeam(_team);
492         
493         // reload core
494         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
495     }
496 
497     /**
498      * @dev withdraws all of your earnings.
499      * -functionhash- 0x3ccfd60b
500      */
501     function withdraw()
502         isActivated()
503         isHuman()
504         public
505     {
506         // setup local rID 
507         uint256 _rID = rID_;
508         
509         // grab time
510         uint256 _now = now;
511         
512         // fetch player ID
513         uint256 _pID = pIDxAddr_[msg.sender];
514         
515         // setup temp var for player eth
516         uint256 _eth;
517         
518         // check to see if round has ended and no one has run round end yet
519         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
520         {
521             // set up our tx event data
522             HXdatasets.EventReturns memory _eventData_;
523             
524             // end the round (distributes pot)
525 			round_[_rID].ended = true;
526             _eventData_ = endRound(_eventData_);
527             
528 			// get their earnings
529             _eth = withdrawEarnings(_pID);
530             
531             // gib moni
532             if (_eth > 0)
533                 plyr_[_pID].addr.transfer(_eth);    
534             
535             // build event data
536             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
537             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
538             
539             // fire withdraw and distribute event
540             emit HXevents.onWithdrawAndDistribute
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
562                 plyr_[_pID].addr.transfer(_eth);
563             
564             // fire withdraw event
565             emit HXevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
566         }
567     }
568     
569     /**
570      * @dev use these to register names.  they are just wrappers that will send the
571      * registration requests to the PlayerBook contract.  So registering here is the 
572      * same as registering there.  UI will always display the last name you registered.
573      * but you will still own all previously registered names to use as affiliate 
574      * links.
575      * - must pay a registration fee.
576      * - name must be unique
577      * - names will be converted to lowercase
578      * - name cannot start or end with a space 
579      * - cannot have more than 1 space in a row
580      * - cannot be only numbers
581      * - cannot start with 0x 
582      * - name must be at least 1 char
583      * - max length of 32 characters long
584      * - allowed characters: a-z, 0-9, and space
585      * -functionhash- 0x921dec21 (using ID for affiliate)
586      * -functionhash- 0x3ddd4698 (using address for affiliate)
587      * -functionhash- 0x685ffd83 (using name for affiliate)
588      * @param _nameString players desired name
589      * @param _affCode affiliate ID, address, or name of who referred you
590      * @param _all set to true if you want this to push your info to all games 
591      * (this might cost a lot of gas)
592      */
593     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
594         isHuman()
595         public
596         payable
597     {
598         bytes32 _name = _nameString.nameFilter();
599         address _addr = msg.sender;
600         uint256 _paid = msg.value;
601         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
602         
603         uint256 _pID = pIDxAddr_[_addr];
604         
605         // fire event
606         emit HXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
607     }
608     
609     function registerNameXaddr(string _nameString, address _affCode, bool _all)
610         isHuman()
611         public
612         payable
613     {
614         bytes32 _name = _nameString.nameFilter();
615         address _addr = msg.sender;
616         uint256 _paid = msg.value;
617         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
618         
619         uint256 _pID = pIDxAddr_[_addr];
620         
621         // fire event
622         emit HXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
623     }
624     
625     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
626         isHuman()
627         public
628         payable
629     {
630         bytes32 _name = _nameString.nameFilter();
631         address _addr = msg.sender;
632         uint256 _paid = msg.value;
633         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
634         
635         uint256 _pID = pIDxAddr_[_addr];
636         
637         // fire event
638         emit HXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
639     }
640 //==============================================================================
641 //     _  _ _|__|_ _  _ _  .
642 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
643 //=====_|=======================================================================
644     /**
645      * @dev return the price buyer will pay for next 1 individual key.
646      * -functionhash- 0x018a25e8
647      * @return price for next key bought (in wei format)
648      */
649     function getBuyPrice()
650         public 
651         view 
652         returns(uint256)
653     {  
654         // setup local rID
655         uint256 _rID = rID_;
656         
657         // grab time
658         uint256 _now = now;
659         
660         // are we in a round?
661         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
662             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
663         else // rounds over.  need price for new round
664             return ( 75000000000000 ); // init
665     }
666     
667     /**
668      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
669      * provider
670      * -functionhash- 0xc7e284b8
671      * @return time left in seconds
672      */
673     function getTimeLeft()
674         public
675         view
676         returns(uint256)
677     {
678         // setup local rID
679         uint256 _rID = rID_;
680         
681         // grab time
682         uint256 _now = now;
683         
684         if (_now < round_[_rID].end)
685             if (_now > round_[_rID].strt + rndGap_)
686                 return( (round_[_rID].end).sub(_now) );
687             else
688                 return( (round_[_rID].strt + rndGap_).sub(_now) );
689         else
690             return(0);
691     }
692     
693     /**
694      * @dev returns player earnings per vaults 
695      * -functionhash- 0x63066434
696      * @return winnings vault
697      * @return general vault
698      * @return affiliate vault
699      */
700     function getPlayerVaults(uint256 _pID)
701         public
702         view
703         returns(uint256 ,uint256, uint256)
704     {
705         // setup local rID
706         uint256 _rID = rID_;
707         
708         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
709         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
710         {
711             // if player is winner 
712             if (round_[_rID].plyr == _pID)
713             {
714                 return
715                 (
716                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
717                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
718                     plyr_[_pID].aff
719                 );
720             // if player is not the winner
721             } else {
722                 return
723                 (
724                     plyr_[_pID].win,
725                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
726                     plyr_[_pID].aff
727                 );
728             }
729             
730         // if round is still going on, or round has ended and round end has been ran
731         } else {
732             return
733             (
734                 plyr_[_pID].win,
735                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
736                 plyr_[_pID].aff
737             );
738         }
739     }
740     
741     /**
742      * solidity hates stack limits.  this lets us avoid that hate 
743      */
744     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
745         private
746         view
747         returns(uint256)
748     {
749         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
750     }
751     
752     /**
753      * @dev returns all current round info needed for front end
754      * -functionhash- 0x747dff42
755      * @return eth invested during ICO phase
756      * @return round id 
757      * @return total keys for round 
758      * @return time round ends
759      * @return time round started
760      * @return current pot 
761      * @return current team ID & player ID in lead 
762      * @return current player in leads address 
763      * @return current player in leads name
764      * @return whales eth in for round
765      * @return bears eth in for round
766      * @return sneks eth in for round
767      * @return bulls eth in for round
768      * @return airdrop tracker # & airdrop pot
769      */
770     function getCurrentRoundInfo()
771         public
772         view
773         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
774     {
775         // setup local rID
776         uint256 _rID = rID_;
777         
778         return
779         (
780             round_[_rID].ico,               //0
781             _rID,                           //1
782             round_[_rID].keys,              //2
783             round_[_rID].end,               //3
784             round_[_rID].strt,              //4
785             round_[_rID].pot,               //5
786             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
787             plyr_[round_[_rID].plyr].addr,  //7
788             plyr_[round_[_rID].plyr].name,  //8
789             rndTmEth_[_rID][0],             //9
790             rndTmEth_[_rID][1],             //10
791             rndTmEth_[_rID][2],             //11
792             rndTmEth_[_rID][3],             //12
793             airDropTracker_ + (airDropPot_ * 1000)              //13
794         );
795     }
796 
797     /**
798      * @dev returns player info based on address.  if no address is given, it will 
799      * use msg.sender 
800      * -functionhash- 0xee0b5d8b
801      * @param _addr address of the player you want to lookup 
802      * @return player ID 
803      * @return player name
804      * @return keys owned (current round)
805      * @return winnings vault
806      * @return general vault 
807      * @return affiliate vault 
808 	 * @return player round eth
809      */
810     function getPlayerInfoByAddress(address _addr)
811         public 
812         view 
813         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
814     {
815         // setup local rID
816         uint256 _rID = rID_;
817         
818         if (_addr == address(0))
819         {
820             _addr == msg.sender;
821         }
822         uint256 _pID = pIDxAddr_[_addr];
823         
824         return
825         (
826             _pID,                               //0
827             plyr_[_pID].name,                   //1
828             plyrRnds_[_pID][_rID].keys,         //2
829             plyr_[_pID].win,                    //3
830             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
831             plyr_[_pID].aff,                    //5
832             plyrRnds_[_pID][_rID].eth           //6
833         );
834     }
835 
836 //==============================================================================
837 //     _ _  _ _   | _  _ . _  .
838 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
839 //=====================_|=======================================================
840     /**
841      * @dev logic runs whenever a buy order is executed.  determines how to handle 
842      * incoming eth depending on if we are in an active round or not
843      */
844     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, HXdatasets.EventReturns memory _eventData_)
845         private
846     {
847         // setup local rID
848         uint256 _rID = rID_;
849         
850         // grab time
851         uint256 _now = now;
852         
853         // if round is active
854         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
855         {
856             // call core 
857             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
858         
859         // if round is not active     
860         } else {
861             // check to see if end round needs to be ran
862             if (_now > round_[_rID].end && round_[_rID].ended == false) 
863             {
864                 // end the round (distributes pot) & start new round
865 			    round_[_rID].ended = true;
866                 _eventData_ = endRound(_eventData_);
867                 
868                 // build event data
869                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
870                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
871                 
872                 // fire buy and distribute event 
873                 emit HXevents.onBuyAndDistribute
874                 (
875                     msg.sender, 
876                     plyr_[_pID].name, 
877                     msg.value, 
878                     _eventData_.compressedData, 
879                     _eventData_.compressedIDs, 
880                     _eventData_.winnerAddr, 
881                     _eventData_.winnerName, 
882                     _eventData_.amountWon, 
883                     _eventData_.newPot, 
884                     _eventData_.P3DAmount, 
885                     _eventData_.genAmount
886                 );
887             }
888             
889             // put eth in players vault 
890             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
891         }
892     }
893     
894     /**
895      * @dev logic runs whenever a reload order is executed.  determines how to handle 
896      * incoming eth depending on if we are in an active round or not 
897      */
898     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, HXdatasets.EventReturns memory _eventData_)
899         private
900     {
901         // setup local rID
902         uint256 _rID = rID_;
903         
904         // grab time
905         uint256 _now = now;
906         
907         // if round is active
908         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
909         {
910             // get earnings from all vaults and return unused to gen vault
911             // because we use a custom safemath library.  this will throw if player 
912             // tried to spend more eth than they have.
913             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
914             
915             // call core 
916             core(_rID, _pID, _eth, _affID, _team, _eventData_);
917         
918         // if round is not active and end round needs to be ran   
919         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
920             // end the round (distributes pot) & start new round
921             round_[_rID].ended = true;
922             _eventData_ = endRound(_eventData_);
923                 
924             // build event data
925             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
926             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
927                 
928             // fire buy and distribute event 
929             emit HXevents.onReLoadAndDistribute
930             (
931                 msg.sender, 
932                 plyr_[_pID].name, 
933                 _eventData_.compressedData, 
934                 _eventData_.compressedIDs, 
935                 _eventData_.winnerAddr, 
936                 _eventData_.winnerName, 
937                 _eventData_.amountWon, 
938                 _eventData_.newPot, 
939                 _eventData_.P3DAmount, 
940                 _eventData_.genAmount
941             );
942         }
943     }
944     
945     /**
946      * @dev this is the core logic for any buy/reload that happens while a round 
947      * is live.
948      */
949     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, HXdatasets.EventReturns memory _eventData_)
950         private
951     {
952         // if player is new to round
953         if (plyrRnds_[_pID][_rID].keys == 0)
954             _eventData_ = managePlayer(_pID, _eventData_);
955         
956         // if eth left is greater than min eth allowed (sorry no pocket lint)
957         if (_eth > 1000000000) 
958         {
959             
960             // mint the new keys
961             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
962             
963             // if they bought at least 1 whole key
964             if (_keys >= 1000000000000000000)
965             {
966             updateTimer(_keys, _rID);
967 
968             // set new leaders
969             if (round_[_rID].plyr != _pID)
970                 round_[_rID].plyr = _pID;  
971             if (round_[_rID].team != _team)
972                 round_[_rID].team = _team; 
973             
974             // set the new leader bool to true
975             _eventData_.compressedData = _eventData_.compressedData + 100;
976         }
977             
978             // manage airdrops
979             if (_eth >= 100000000000000000)
980             {
981             airDropTracker_++;
982             if (airdrop() == true)
983             {
984                 // gib muni
985                 uint256 _prize;
986                 if (_eth >= 10000000000000000000)
987                 {
988                     // calculate prize and give it to winner
989                     _prize = ((airDropPot_).mul(75)) / 100;
990                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
991                     
992                     // adjust airDropPot 
993                     airDropPot_ = (airDropPot_).sub(_prize);
994                     
995                     // let event know a tier 3 prize was won 
996                     _eventData_.compressedData += 300000000000000000000000000000000;
997                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
998                     // calculate prize and give it to winner
999                     _prize = ((airDropPot_).mul(50)) / 100;
1000                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1001                     
1002                     // adjust airDropPot 
1003                     airDropPot_ = (airDropPot_).sub(_prize);
1004                     
1005                     // let event know a tier 2 prize was won 
1006                     _eventData_.compressedData += 200000000000000000000000000000000;
1007                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1008                     // calculate prize and give it to winner
1009                     _prize = ((airDropPot_).mul(25)) / 100;
1010                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1011                     
1012                     // adjust airDropPot 
1013                     airDropPot_ = (airDropPot_).sub(_prize);
1014                     
1015                     // let event know a tier 3 prize was won 
1016                     _eventData_.compressedData += 300000000000000000000000000000000;
1017                 }
1018                 // set airdrop happened bool to true
1019                 _eventData_.compressedData += 10000000000000000000000000000000;
1020                 // let event know how much was won 
1021                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1022                 
1023                 // reset air drop tracker
1024                 airDropTracker_ = 0;
1025             }
1026         }
1027     
1028             // store the air drop tracker number (number of buys since last airdrop)
1029             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1030             
1031             // update player 
1032             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1033             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1034             
1035             // update round
1036             round_[_rID].keys = _keys.add(round_[_rID].keys);
1037             round_[_rID].eth = _eth.add(round_[_rID].eth);
1038             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1039     
1040             // distribute eth
1041             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1042             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1043             
1044             // call end tx function to fire end tx event.
1045 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1046         }
1047     }
1048 //==============================================================================
1049 //     _ _ | _   | _ _|_ _  _ _  .
1050 //    (_(_||(_|_||(_| | (_)| _\  .
1051 //==============================================================================
1052     /**
1053      * @dev calculates unmasked earnings (just calculates, does not update mask)
1054      * @return earnings in wei format
1055      */
1056     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1057         private
1058         view
1059         returns(uint256)
1060     {
1061         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1062     }
1063     
1064     /** 
1065      * @dev returns the amount of keys you would get given an amount of eth. 
1066      * -functionhash- 0xce89c80c
1067      * @param _rID round ID you want price for
1068      * @param _eth amount of eth sent in 
1069      * @return keys received 
1070      */
1071     function calcKeysReceived(uint256 _rID, uint256 _eth)
1072         public
1073         view
1074         returns(uint256)
1075     {
1076         // grab time
1077         uint256 _now = now;
1078         
1079         // are we in a round?
1080         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1081             return ( (round_[_rID].eth).keysRec(_eth) );
1082         else // rounds over.  need keys for new round
1083             return ( (_eth).keys() );
1084     }
1085     
1086     /** 
1087      * @dev returns current eth price for X keys.  
1088      * -functionhash- 0xcf808000
1089      * @param _keys number of keys desired (in 18 decimal format)
1090      * @return amount of eth needed to send
1091      */
1092     function iWantXKeys(uint256 _keys)
1093         public
1094         view
1095         returns(uint256)
1096     {
1097         // setup local rID
1098         uint256 _rID = rID_;
1099         
1100         // grab time
1101         uint256 _now = now;
1102         
1103         // are we in a round?
1104         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1105             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1106         else // rounds over.  need price for new round
1107             return ( (_keys).eth() );
1108     }
1109 //==============================================================================
1110 //    _|_ _  _ | _  .
1111 //     | (_)(_)|_\  .
1112 //==============================================================================
1113     /**
1114 	 * @dev receives name/player info from names contract 
1115      */
1116     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1117         external
1118     {
1119         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1120         if (pIDxAddr_[_addr] != _pID)
1121             pIDxAddr_[_addr] = _pID;
1122         if (pIDxName_[_name] != _pID)
1123             pIDxName_[_name] = _pID;
1124         if (plyr_[_pID].addr != _addr)
1125             plyr_[_pID].addr = _addr;
1126         if (plyr_[_pID].name != _name)
1127             plyr_[_pID].name = _name;
1128         if (plyr_[_pID].laff != _laff)
1129             plyr_[_pID].laff = _laff;
1130         if (plyrNames_[_pID][_name] == false)
1131             plyrNames_[_pID][_name] = true;
1132     }
1133     
1134     /**
1135      * @dev receives entire player name list 
1136      */
1137     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1138         external
1139     {
1140         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1141         if(plyrNames_[_pID][_name] == false)
1142             plyrNames_[_pID][_name] = true;
1143     }   
1144         
1145     /**
1146      * @dev gets existing or registers new pID.  use this when a player may be new
1147      * @return pID 
1148      */
1149     function determinePID(HXdatasets.EventReturns memory _eventData_)
1150         private
1151         returns (HXdatasets.EventReturns)
1152     {
1153         uint256 _pID = pIDxAddr_[msg.sender];
1154         // if player is new to this version of fomo3d
1155         if (_pID == 0)
1156         {
1157             // grab their player ID, name and last aff ID, from player names contract 
1158             _pID = PlayerBook.getPlayerID(msg.sender);
1159             bytes32 _name = PlayerBook.getPlayerName(_pID);
1160             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1161             
1162             // set up player account 
1163             pIDxAddr_[msg.sender] = _pID;
1164             plyr_[_pID].addr = msg.sender;
1165             
1166             if (_name != "")
1167             {
1168                 pIDxName_[_name] = _pID;
1169                 plyr_[_pID].name = _name;
1170                 plyrNames_[_pID][_name] = true;
1171             }
1172             
1173             if (_laff != 0 && _laff != _pID)
1174                 plyr_[_pID].laff = _laff;
1175             
1176             // set the new player bool to true
1177             _eventData_.compressedData = _eventData_.compressedData + 1;
1178         } 
1179         return (_eventData_);
1180     }
1181     
1182     /**
1183      * @dev checks to make sure user picked a valid team.  if not sets team 
1184      * to default (sneks)
1185      */
1186     function verifyTeam(uint256 _team)
1187         private
1188         pure
1189         returns (uint256)
1190     {
1191         if (_team < 0 || _team > 3)
1192             return(2);
1193         else
1194             return(_team);
1195     }
1196     
1197     /**
1198      * @dev decides if round end needs to be run & new round started.  and if 
1199      * player unmasked earnings from previously played rounds need to be moved.
1200      */
1201     function managePlayer(uint256 _pID, HXdatasets.EventReturns memory _eventData_)
1202         private
1203         returns (HXdatasets.EventReturns)
1204     {
1205         // if player has played a previous round, move their unmasked earnings
1206         // from that round to gen vault.
1207         if (plyr_[_pID].lrnd != 0)
1208             updateGenVault(_pID, plyr_[_pID].lrnd);
1209             
1210         // update player's last round played
1211         plyr_[_pID].lrnd = rID_;
1212             
1213         // set the joined round bool to true
1214         _eventData_.compressedData = _eventData_.compressedData + 10;
1215         
1216         return(_eventData_);
1217     }
1218     
1219     /**
1220      * @dev ends the round. manages paying out winner/splitting up pot
1221      */
1222     function endRound(HXdatasets.EventReturns memory _eventData_)
1223         private
1224         returns (HXdatasets.EventReturns)
1225     {
1226         // setup local rID
1227         uint256 _rID = rID_;
1228         
1229         // grab our winning player and team id's
1230         uint256 _winPID = round_[_rID].plyr;
1231         uint256 _winTID = round_[_rID].team;
1232         
1233         // grab our pot amount
1234         uint256 _pot = round_[_rID].pot;
1235         
1236         // calculate our winner share, community rewards, gen share, 
1237         // p3d share, and amount reserved for next pot 
1238         uint256 _win = (_pot.mul(48)) / 100;
1239         uint256 _com = (_pot.mul(6) / 50);
1240         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1241         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1242         
1243         // calculate ppt for round mask
1244         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1245         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1246         if (_dust > 0)
1247         {
1248             _gen = _gen.sub(_dust);
1249             _res = _res.add(_dust);
1250         }
1251         
1252         // pay our winner
1253         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1254         
1255         // community rewards
1256         community_addr.transfer(_com);
1257         
1258         // distribute gen portion to key holders
1259         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1260         
1261             
1262         // prepare event data
1263         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1264         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1265         _eventData_.winnerAddr = plyr_[_winPID].addr;
1266         _eventData_.winnerName = plyr_[_winPID].name;
1267         _eventData_.amountWon = _win;
1268         _eventData_.genAmount = _gen;
1269         _eventData_.P3DAmount = 0;
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
1350     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, HXdatasets.EventReturns memory _eventData_)
1351         private
1352         returns(HXdatasets.EventReturns)
1353     {
1354         // pay 2% out to community rewards
1355         uint256 _com = _eth / 50;
1356         
1357     
1358         
1359         // distribute share to affiliate
1360         uint256 _aff = _eth / 5;
1361         
1362         // decide what to do with affiliate share of fees
1363         // affiliate must not be self, and must have a name registered
1364         if (_affID != _pID && plyr_[_affID].name != '') {
1365             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1366             emit HXevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1367         } else {
1368             _com = _com.add(_aff);
1369         }
1370         community_addr.transfer(_com);
1371         
1372         return(_eventData_);
1373     }
1374     
1375     /**
1376      * @dev distributes eth based on fees to gen and pot
1377      */
1378     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, HXdatasets.EventReturns memory _eventData_)
1379         private
1380         returns(HXdatasets.EventReturns)
1381     {
1382         // calculate gen share
1383         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1384         
1385         // toss 2% into airdrop pot 
1386         uint256 _air = (_eth / 50);
1387         airDropPot_ = airDropPot_.add(_air);
1388         
1389         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1390         _eth = _eth.sub(((_eth.mul(24)) / 100));
1391         
1392         // calculate pot 
1393         uint256 _pot = _eth.sub(_gen);
1394         
1395         // distribute gen share (thats what updateMasks() does) and adjust
1396         // balances for dust.
1397         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1398         if (_dust > 0)
1399             _gen = _gen.sub(_dust);
1400         
1401         // add eth to pot
1402         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1403         
1404         // set up event data
1405         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1406         _eventData_.potAmount = _pot;
1407         
1408         return(_eventData_);
1409     }
1410 
1411     /**
1412      * @dev updates masks for round and player when keys are bought
1413      * @return dust left over 
1414      */
1415     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1416         private
1417         returns(uint256)
1418     {
1419         /* MASKING NOTES
1420             earnings masks are a tricky thing for people to wrap their minds around.
1421             the basic thing to understand here.  is were going to have a global
1422             tracker based on profit per share for each round, that increases in
1423             relevant proportion to the increase in share supply.
1424             
1425             the player will have an additional mask that basically says "based
1426             on the rounds mask, my shares, and how much i've already withdrawn,
1427             how much is still owed to me?"
1428         */
1429         
1430         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1431         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1432         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1433             
1434         // calculate player earning from their own buy (only based on the keys
1435         // they just bought).  & update player earnings mask
1436         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1437         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1438         
1439         // calculate & return dust
1440         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1441     }
1442     
1443     /**
1444      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1445      * @return earnings in wei format
1446      */
1447     function withdrawEarnings(uint256 _pID)
1448         private
1449         returns(uint256)
1450     {
1451         // update gen vault
1452         updateGenVault(_pID, plyr_[_pID].lrnd);
1453         
1454         // from vaults 
1455         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1456         if (_earnings > 0)
1457         {
1458             plyr_[_pID].win = 0;
1459             plyr_[_pID].gen = 0;
1460             plyr_[_pID].aff = 0;
1461         }
1462 
1463         return(_earnings);
1464     }
1465     
1466     /**
1467      * @dev prepares compression data and fires event for buy or reload tx's
1468      */
1469     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, HXdatasets.EventReturns memory _eventData_)
1470         private
1471     {
1472         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1473         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1474         
1475         emit HXevents.onEndTx
1476         (
1477             _eventData_.compressedData,
1478             _eventData_.compressedIDs,
1479             plyr_[_pID].name,
1480             msg.sender,
1481             _eth,
1482             _keys,
1483             _eventData_.winnerAddr,
1484             _eventData_.winnerName,
1485             _eventData_.amountWon,
1486             _eventData_.newPot,
1487             _eventData_.P3DAmount,
1488             _eventData_.genAmount,
1489             _eventData_.potAmount,
1490             airDropPot_
1491         );
1492     }
1493 //==============================================================================
1494 //    (~ _  _    _._|_    .
1495 //    _)(/_(_|_|| | | \/  .
1496 //====================/=========================================================
1497     /** upon contract deploy, it will be deactivated.  this is a one time
1498      * use function that will activate the contract.  we do this so devs 
1499      * have time to set things up on the web end                            **/
1500     bool public activated_ = false;
1501     function activate()
1502         public
1503     {
1504         // only team just can activate 
1505         require(
1506             msg.sender == community_addr, "only community can activate"
1507         );
1508 
1509         
1510         // can only be ran once
1511         require(activated_ == false, "shuoha already activated");
1512         
1513         // activate the contract 
1514         activated_ = true;
1515         
1516         // lets start first round
1517 		rID_ = 1;
1518         round_[1].strt = now + rndExtra_ - rndGap_;
1519         round_[1].end = now + rndInit_ + rndExtra_;
1520     }
1521 }
1522 
1523 //==============================================================================
1524 //   __|_ _    __|_ _  .
1525 //  _\ | | |_|(_ | _\  .
1526 //==============================================================================
1527 library HXdatasets {
1528     //compressedData key
1529     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1530         // 0 - new player (bool)
1531         // 1 - joined round (bool)
1532         // 2 - new  leader (bool)
1533         // 3-5 - air drop tracker (uint 0-999)
1534         // 6-16 - round end time
1535         // 17 - winnerTeam
1536         // 18 - 28 timestamp 
1537         // 29 - team
1538         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1539         // 31 - airdrop happened bool
1540         // 32 - airdrop tier 
1541         // 33 - airdrop amount won
1542     //compressedIDs key
1543     // [77-52][51-26][25-0]
1544         // 0-25 - pID 
1545         // 26-51 - winPID
1546         // 52-77 - rID
1547     struct EventReturns {
1548         uint256 compressedData;
1549         uint256 compressedIDs;
1550         address winnerAddr;         // winner address
1551         bytes32 winnerName;         // winner name
1552         uint256 amountWon;          // amount won
1553         uint256 newPot;             // amount in new pot
1554         uint256 P3DAmount;          // amount distributed to p3d
1555         uint256 genAmount;          // amount distributed to gen
1556         uint256 potAmount;          // amount added to pot
1557     }
1558     struct Player {
1559         address addr;   // player address
1560         bytes32 name;   // player name
1561         uint256 win;    // winnings vault
1562         uint256 gen;    // general vault
1563         uint256 aff;    // affiliate vault
1564         uint256 lrnd;   // last round played
1565         uint256 laff;   // last affiliate id used
1566     }
1567     struct PlayerRounds {
1568         uint256 eth;    // eth player has added to round (used for eth limiter)
1569         uint256 keys;   // keys
1570         uint256 mask;   // player mask 
1571         uint256 ico;    // ICO phase investment
1572     }
1573     struct Round {
1574         uint256 plyr;   // pID of player in lead
1575         uint256 team;   // tID of team in lead
1576         uint256 end;    // time ends/ended
1577         bool ended;     // has round end function been ran
1578         uint256 strt;   // time round started
1579         uint256 keys;   // keys
1580         uint256 eth;    // total eth in
1581         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1582         uint256 mask;   // global mask
1583         uint256 ico;    // total eth sent in during ICO phase
1584         uint256 icoGen; // total eth for gen during ICO phase
1585         uint256 icoAvg; // average key price for ICO phase
1586     }
1587     struct TeamFee {
1588         uint256 gen;    // % of buy in thats paid to key holders of current round
1589         uint256 p3d;    // % of buy in thats paid to p3d holders
1590     }
1591     struct PotSplit {
1592         uint256 gen;    // % of pot thats paid to key holders of current round
1593         uint256 p3d;    // % of pot thats paid to p3d holders
1594     }
1595 }
1596 
1597 //==============================================================================
1598 //  |  _      _ _ | _  .
1599 //  |<(/_\/  (_(_||(_  .
1600 //=======/======================================================================
1601 library HXKeysCalcLong {
1602     using SafeMath for *;
1603     /**
1604      * @dev calculates number of keys received given X eth 
1605      * @param _curEth current amount of eth in contract 
1606      * @param _newEth eth being spent
1607      * @return amount of ticket purchased
1608      */
1609     function keysRec(uint256 _curEth, uint256 _newEth)
1610         internal
1611         pure
1612         returns (uint256)
1613     {
1614         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1615     }
1616 
1617     /**
1618      * @dev calculates amount of eth received if you sold X keys 
1619      * @param _curKeys current amount of keys that exist 
1620      * @param _sellKeys amount of keys you wish to sell
1621      * @return amount of eth received
1622      */
1623     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1624         internal
1625         pure
1626         returns (uint256)
1627     {
1628         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1629     }
1630 
1631     /**
1632      * @dev calculates how many keys would exist with given an amount of eth
1633      * @param _eth eth "in contract"
1634      * @return number of keys that would exist
1635      */
1636     function keys(uint256 _eth) 
1637         internal
1638         pure
1639         returns(uint256)
1640     {
1641         return ((((((_eth).mul(1000000000000000000)).mul(156250000000000000000000000)).add(1406247070314025878906250000000000000000000000000000000000000000)).sqrt()).sub(37499960937500000000000000000000)) / (78125000);
1642     }
1643 
1644     /**
1645      * @dev calculates how much eth would be in contract given a number of keys
1646      * @param _keys number of keys "in contract" 
1647      * @return eth that would exists
1648      */
1649     function eth(uint256 _keys) 
1650         internal
1651         pure
1652         returns(uint256)  
1653     {
1654         return ((39062500).mul(_keys.sq()).add(((74999921875000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1655     }
1656 }
1657 
1658 //==============================================================================
1659 //  . _ _|_ _  _ |` _  _ _  _  .
1660 //  || | | (/_| ~|~(_|(_(/__\  .
1661 //==============================================================================
1662 
1663 interface PlayerBookInterface {
1664     function getPlayerID(address _addr) external returns (uint256);
1665     function getPlayerName(uint256 _pID) external view returns (bytes32);
1666     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1667     function getPlayerAddr(uint256 _pID) external view returns (address);
1668     function getNameFee() external view returns (uint256);
1669     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1670     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1671     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1672 }
1673 
1674 
1675 library NameFilter {
1676     /**
1677      * @dev filters name strings
1678      * -converts uppercase to lower case.  
1679      * -makes sure it does not start/end with a space
1680      * -makes sure it does not contain multiple spaces in a row
1681      * -cannot be only numbers
1682      * -cannot start with 0x 
1683      * -restricts characters to A-Z, a-z, 0-9, and space.
1684      * @return reprocessed string in bytes32 format
1685      */
1686     function nameFilter(string _input)
1687         internal
1688         pure
1689         returns(bytes32)
1690     {
1691         bytes memory _temp = bytes(_input);
1692         uint256 _length = _temp.length;
1693         
1694         //sorry limited to 32 characters
1695         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1696         // make sure it doesnt start with or end with space
1697         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1698         // make sure first two characters are not 0x
1699         if (_temp[0] == 0x30)
1700         {
1701             require(_temp[1] != 0x78, "string cannot start with 0x");
1702             require(_temp[1] != 0x58, "string cannot start with 0X");
1703         }
1704         
1705         // create a bool to track if we have a non number character
1706         bool _hasNonNumber;
1707         
1708         // convert & check
1709         for (uint256 i = 0; i < _length; i++)
1710         {
1711             // if its uppercase A-Z
1712             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1713             {
1714                 // convert to lower case a-z
1715                 _temp[i] = byte(uint(_temp[i]) + 32);
1716                 
1717                 // we have a non number
1718                 if (_hasNonNumber == false)
1719                     _hasNonNumber = true;
1720             } else {
1721                 require
1722                 (
1723                     // require character is a space
1724                     _temp[i] == 0x20 || 
1725                     // OR lowercase a-z
1726                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1727                     // or 0-9
1728                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1729                     "string contains invalid characters"
1730                 );
1731                 // make sure theres not 2x spaces in a row
1732                 if (_temp[i] == 0x20)
1733                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1734                 
1735                 // see if we have a character other than a number
1736                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1737                     _hasNonNumber = true;    
1738             }
1739         }
1740         
1741         require(_hasNonNumber == true, "string cannot be only numbers");
1742         
1743         bytes32 _ret;
1744         assembly {
1745             _ret := mload(add(_temp, 32))
1746         }
1747         return (_ret);
1748     }
1749 }
1750 
1751 /**
1752  * @title SafeMath v0.1.9
1753  * @dev Math operations with safety checks that throw on error
1754  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1755  * - added sqrt
1756  * - added sq
1757  * - added pwr 
1758  * - changed asserts to requires with error log outputs
1759  * - removed div, its useless
1760  */
1761 library SafeMath {
1762     
1763     /**
1764     * @dev Multiplies two numbers, throws on overflow.
1765     */
1766     function mul(uint256 a, uint256 b) 
1767         internal 
1768         pure 
1769         returns (uint256 c) 
1770     {
1771         if (a == 0) {
1772             return 0;
1773         }
1774         c = a * b;
1775         require(c / a == b, "SafeMath mul failed");
1776         return c;
1777     }
1778 
1779     /**
1780     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1781     */
1782     function sub(uint256 a, uint256 b)
1783         internal
1784         pure
1785         returns (uint256) 
1786     {
1787         require(b <= a, "SafeMath sub failed");
1788         return a - b;
1789     }
1790 
1791     /**
1792     * @dev Adds two numbers, throws on overflow.
1793     */
1794     function add(uint256 a, uint256 b)
1795         internal
1796         pure
1797         returns (uint256 c) 
1798     {
1799         c = a + b;
1800         require(c >= a, "SafeMath add failed");
1801         return c;
1802     }
1803     
1804     /**
1805      * @dev gives square root of given x.
1806      */
1807     function sqrt(uint256 x)
1808         internal
1809         pure
1810         returns (uint256 y) 
1811     {
1812         uint256 z = ((add(x,1)) / 2);
1813         y = x;
1814         while (z < y) 
1815         {
1816             y = z;
1817             z = ((add((x / z),z)) / 2);
1818         }
1819     }
1820     
1821     /**
1822      * @dev gives square. multiplies x by x
1823      */
1824     function sq(uint256 x)
1825         internal
1826         pure
1827         returns (uint256)
1828     {
1829         return (mul(x,x));
1830     }
1831     
1832     /**
1833      * @dev x to the power of y 
1834      */
1835     function pwr(uint256 x, uint256 y)
1836         internal 
1837         pure 
1838         returns (uint256)
1839     {
1840         if (x==0)
1841             return (0);
1842         else if (y==0)
1843             return (1);
1844         else 
1845         {
1846             uint256 z = x;
1847             for (uint256 i=1; i < y; i++)
1848                 z = mul(z,x);
1849             return (z);
1850         }
1851     }
1852 }