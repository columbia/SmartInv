1 pragma solidity ^0.4.24;
2 contract F3Devents {
3     // fired whenever a player registers a name
4     event onNewName
5     (
6         uint256 indexed playerID,
7         address indexed playerAddress,
8         bytes32 indexed playerName,
9         bool isNewPlayer,
10         uint256 affiliateID,
11         address affiliateAddress,
12         bytes32 affiliateName,
13         uint256 amountPaid,
14         uint256 timeStamp
15     );
16     
17     // fired at end of buy or reload
18     event onEndTx
19     (
20         uint256 compressedData,     
21         uint256 compressedIDs,      
22         bytes32 playerName,
23         address playerAddress,
24         uint256 ethIn,
25         uint256 keysBought,
26         address winnerAddr,
27         bytes32 winnerName,
28         uint256 amountWon,
29         uint256 newPot,
30         uint256 P3DAmount,
31         uint256 genAmount,
32         uint256 potAmount,
33         uint256 airDropPot
34     );
35     
36     // fired whenever theres a withdraw
37     event onWithdraw
38     (
39         uint256 indexed playerID,
40         address playerAddress,
41         bytes32 playerName,
42         uint256 ethOut,
43         uint256 timeStamp
44     );
45     
46     // fired whenever a withdraw forces end round to be ran
47     event onWithdrawAndDistribute
48     (
49         address playerAddress,
50         bytes32 playerName,
51         uint256 ethOut,
52         uint256 compressedData,
53         uint256 compressedIDs,
54         address winnerAddr,
55         bytes32 winnerName,
56         uint256 amountWon,
57         uint256 newPot,
58         uint256 P3DAmount,
59         uint256 genAmount
60     );
61     
62     // (fomo3d short only) fired whenever a player tries a buy after round timer 
63     // hit zero, and causes end round to be ran.
64     event onBuyAndDistribute
65     (
66         address playerAddress,
67         bytes32 playerName,
68         uint256 ethIn,
69         uint256 compressedData,
70         uint256 compressedIDs,
71         address winnerAddr,
72         bytes32 winnerName,
73         uint256 amountWon,
74         uint256 newPot,
75         uint256 P3DAmount,
76         uint256 genAmount
77     );
78     
79     // (fomo3d short only) fired whenever a player tries a reload after round timer 
80     // hit zero, and causes end round to be ran.
81     event onReLoadAndDistribute
82     (
83         address playerAddress,
84         bytes32 playerName,
85         uint256 compressedData,
86         uint256 compressedIDs,
87         address winnerAddr,
88         bytes32 winnerName,
89         uint256 amountWon,
90         uint256 newPot,
91         uint256 P3DAmount,
92         uint256 genAmount
93     );
94     
95     // fired whenever an affiliate is paid
96     event onAffiliatePayout
97     (
98         uint256 indexed affiliateID,
99         address affiliateAddress,
100         bytes32 affiliateName,
101         uint256 indexed roundID,
102         uint256 indexed buyerID,
103         uint256 amount,
104         uint256 timeStamp
105     );
106     
107     // received pot swap deposit
108     event onPotSwapDeposit
109     (
110         uint256 roundID,
111         uint256 amountAddedToPot
112     );
113 }
114 
115 //==============================================================================
116 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
117 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
118 //====================================|=========================================
119 
120 contract modularShort is F3Devents {}
121 
122 contract FoMo3Dshort is modularShort {
123     using SafeMath for *;
124     using NameFilter for string;
125     using F3DKeysCalcShort for uint256;
126     
127     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x1c02868ca92fda9caec622142ff7dee72cfa2f26);
128 
129 //==============================================================================
130 //     _ _  _  |`. _     _ _ |_ | _  _  .
131 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
132 //=================_|===========================================================
133     address public admin = msg.sender;
134     string constant public name = "FOMO Short";
135     string constant public symbol = "SHORT";
136     uint256 public rndExtra_ = 30 minutes;     // length of the very first ICO
137     uint256 public rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
138     uint256 constant public rndInit_ = 30 minutes;                // round timer starts at this
139     uint256 constant public rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
140     uint256 constant public rndMax_ = 1 hours;                // max length a round timer can be
141 //==============================================================================
142 //     _| _ _|_ _    _ _ _|_    _   .
143 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
144 //=============================|================================================
145     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
146     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
147     uint256 public rID_;    // round id number / total rounds that have happened
148 //****************
149 // PLAYER DATA 
150 //****************
151     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
152     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
153     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
154     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
155     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
156 //****************
157 // ROUND DATA 
158 //****************
159     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
160     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
161 //****************
162 // TEAM FEE DATA 
163 //****************
164     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
165     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
166 //==============================================================================
167 //     _ _  _  __|_ _    __|_ _  _  .
168 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
169 //==============================================================================
170     constructor()
171         public
172     {
173         // Team allocation structures
174         // 0 = whales
175         // 1 = bears
176         // 2 = sneks
177         // 3 = bulls
178 
179         // Team allocation percentages
180         // (F3D, P3D) + (Pot , Referrals, Community)
181             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
182         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
183         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
184         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
185         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
186         
187         // how to split up the final pot based on which team was picked
188         // (F3D, P3D)
189         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
190         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
191         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
192         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
193     }
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
301         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
342         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
392         F3Ddatasets.EventReturns memory _eventData_;
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
424         F3Ddatasets.EventReturns memory _eventData_;
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
464         F3Ddatasets.EventReturns memory _eventData_;
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
522             F3Ddatasets.EventReturns memory _eventData_;
523             
524             // end the round (distributes pot)
525             round_[_rID].ended = true;
526             _eventData_ = endRound(_eventData_);
527             
528             // get their earnings
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
540             emit F3Devents.onWithdrawAndDistribute
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
565             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
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
606         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
622         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
638         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
808      * @return player round eth
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
844     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
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
865                 round_[_rID].ended = true;
866                 _eventData_ = endRound(_eventData_);
867                 
868                 // build event data
869                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
870                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
871                 
872                 // fire buy and distribute event 
873                 emit F3Devents.onBuyAndDistribute
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
898     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
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
929             emit F3Devents.onReLoadAndDistribute
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
949     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
950         private
951     {
952         // if player is new to round
953         if (plyrRnds_[_pID][_rID].keys == 0)
954             _eventData_ = managePlayer(_pID, _eventData_);
955         
956         // early round eth limiter 
957         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
958         {
959             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
960             uint256 _refund = _eth.sub(_availableLimit);
961             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
962             _eth = _availableLimit;
963         }
964         
965         // if eth left is greater than min eth allowed (sorry no pocket lint)
966         if (_eth > 1000000000) 
967         {
968             
969             // mint the new keys
970             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
971             
972             // if they bought at least 1 whole key
973             if (_keys >= 1000000000000000000)
974             {
975             updateTimer(_keys, _rID);
976 
977             // set new leaders
978             if (round_[_rID].plyr != _pID)
979                 round_[_rID].plyr = _pID;  
980             if (round_[_rID].team != _team)
981                 round_[_rID].team = _team; 
982             
983             // set the new leader bool to true
984             _eventData_.compressedData = _eventData_.compressedData + 100;
985         }
986             
987             // manage airdrops
988             if (_eth >= 100000000000000000)
989             {
990             airDropTracker_++;
991             if (airdrop() == true)
992             {
993                 // gib muni
994                 uint256 _prize;
995                 if (_eth >= 10000000000000000000)
996                 {
997                     // calculate prize and give it to winner
998                     _prize = ((airDropPot_).mul(75)) / 100;
999                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1000                     
1001                     // adjust airDropPot 
1002                     airDropPot_ = (airDropPot_).sub(_prize);
1003                     
1004                     // let event know a tier 3 prize was won 
1005                     _eventData_.compressedData += 300000000000000000000000000000000;
1006                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1007                     // calculate prize and give it to winner
1008                     _prize = ((airDropPot_).mul(50)) / 100;
1009                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1010                     
1011                     // adjust airDropPot 
1012                     airDropPot_ = (airDropPot_).sub(_prize);
1013                     
1014                     // let event know a tier 2 prize was won 
1015                     _eventData_.compressedData += 200000000000000000000000000000000;
1016                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1017                     // calculate prize and give it to winner
1018                     _prize = ((airDropPot_).mul(25)) / 100;
1019                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1020                     
1021                     // adjust airDropPot 
1022                     airDropPot_ = (airDropPot_).sub(_prize);
1023                     
1024                     // let event know a tier 3 prize was won 
1025                     _eventData_.compressedData += 300000000000000000000000000000000;
1026                 }
1027                 // set airdrop happened bool to true
1028                 _eventData_.compressedData += 10000000000000000000000000000000;
1029                 // let event know how much was won 
1030                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1031                 
1032                 // reset air drop tracker
1033                 airDropTracker_ = 0;
1034             }
1035         }
1036     
1037             // store the air drop tracker number (number of buys since last airdrop)
1038             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1039             
1040             // update player 
1041             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1042             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1043             
1044             // update round
1045             round_[_rID].keys = _keys.add(round_[_rID].keys);
1046             round_[_rID].eth = _eth.add(round_[_rID].eth);
1047             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1048     
1049             // distribute eth
1050             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1051             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1052             
1053             // call end tx function to fire end tx event.
1054             endTx(_pID, _team, _eth, _keys, _eventData_);
1055         }
1056     }
1057 //==============================================================================
1058 //     _ _ | _   | _ _|_ _  _ _  .
1059 //    (_(_||(_|_||(_| | (_)| _\  .
1060 //==============================================================================
1061     /**
1062      * @dev calculates unmasked earnings (just calculates, does not update mask)
1063      * @return earnings in wei format
1064      */
1065     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1066         private
1067         view
1068         returns(uint256)
1069     {
1070         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1071     }
1072     
1073     /** 
1074      * @dev returns the amount of keys you would get given an amount of eth. 
1075      * -functionhash- 0xce89c80c
1076      * @param _rID round ID you want price for
1077      * @param _eth amount of eth sent in 
1078      * @return keys received 
1079      */
1080     function calcKeysReceived(uint256 _rID, uint256 _eth)
1081         public
1082         view
1083         returns(uint256)
1084     {
1085         // grab time
1086         uint256 _now = now;
1087         
1088         // are we in a round?
1089         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1090             return ( (round_[_rID].eth).keysRec(_eth) );
1091         else // rounds over.  need keys for new round
1092             return ( (_eth).keys() );
1093     }
1094     
1095     /** 
1096      * @dev returns current eth price for X keys.  
1097      * -functionhash- 0xcf808000
1098      * @param _keys number of keys desired (in 18 decimal format)
1099      * @return amount of eth needed to send
1100      */
1101     function iWantXKeys(uint256 _keys)
1102         public
1103         view
1104         returns(uint256)
1105     {
1106         // setup local rID
1107         uint256 _rID = rID_;
1108         
1109         // grab time
1110         uint256 _now = now;
1111         
1112         // are we in a round?
1113         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1114             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1115         else // rounds over.  need price for new round
1116             return ( (_keys).eth() );
1117     }
1118 //==============================================================================
1119 //    _|_ _  _ | _  .
1120 //     | (_)(_)|_\  .
1121 //==============================================================================
1122     /**
1123      * @dev receives name/player info from names contract 
1124      */
1125     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1126         external
1127     {
1128         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1129         if (pIDxAddr_[_addr] != _pID)
1130             pIDxAddr_[_addr] = _pID;
1131         if (pIDxName_[_name] != _pID)
1132             pIDxName_[_name] = _pID;
1133         if (plyr_[_pID].addr != _addr)
1134             plyr_[_pID].addr = _addr;
1135         if (plyr_[_pID].name != _name)
1136             plyr_[_pID].name = _name;
1137         if (plyr_[_pID].laff != _laff)
1138             plyr_[_pID].laff = _laff;
1139         if (plyrNames_[_pID][_name] == false)
1140             plyrNames_[_pID][_name] = true;
1141     }
1142     
1143     /**
1144      * @dev receives entire player name list 
1145      */
1146     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1147         external
1148     {
1149         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1150         if(plyrNames_[_pID][_name] == false)
1151             plyrNames_[_pID][_name] = true;
1152     }   
1153         
1154     /**
1155      * @dev gets existing or registers new pID.  use this when a player may be new
1156      * @return pID 
1157      */
1158     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1159         private
1160         returns (F3Ddatasets.EventReturns)
1161     {
1162         uint256 _pID = pIDxAddr_[msg.sender];
1163         // if player is new to this version of fomo3d
1164         if (_pID == 0)
1165         {
1166             // grab their player ID, name and last aff ID, from player names contract 
1167             _pID = PlayerBook.getPlayerID(msg.sender);
1168             bytes32 _name = PlayerBook.getPlayerName(_pID);
1169             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1170             
1171             // set up player account 
1172             pIDxAddr_[msg.sender] = _pID;
1173             plyr_[_pID].addr = msg.sender;
1174             
1175             if (_name != "")
1176             {
1177                 pIDxName_[_name] = _pID;
1178                 plyr_[_pID].name = _name;
1179                 plyrNames_[_pID][_name] = true;
1180             }
1181             
1182             if (_laff != 0 && _laff != _pID)
1183                 plyr_[_pID].laff = _laff;
1184             
1185             // set the new player bool to true
1186             _eventData_.compressedData = _eventData_.compressedData + 1;
1187         } 
1188         return (_eventData_);
1189     }
1190     
1191     /**
1192      * @dev checks to make sure user picked a valid team.  if not sets team 
1193      * to default (sneks)
1194      */
1195     function verifyTeam(uint256 _team)
1196         private
1197         pure
1198         returns (uint256)
1199     {
1200         if (_team < 0 || _team > 3)
1201             return(2);
1202         else
1203             return(_team);
1204     }
1205     
1206     /**
1207      * @dev decides if round end needs to be run & new round started.  and if 
1208      * player unmasked earnings from previously played rounds need to be moved.
1209      */
1210     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1211         private
1212         returns (F3Ddatasets.EventReturns)
1213     {
1214         // if player has played a previous round, move their unmasked earnings
1215         // from that round to gen vault.
1216         if (plyr_[_pID].lrnd != 0)
1217             updateGenVault(_pID, plyr_[_pID].lrnd);
1218             
1219         // update player's last round played
1220         plyr_[_pID].lrnd = rID_;
1221             
1222         // set the joined round bool to true
1223         _eventData_.compressedData = _eventData_.compressedData + 10;
1224         
1225         return(_eventData_);
1226     }
1227     
1228     /**
1229      * @dev ends the round. manages paying out winner/splitting up pot
1230      */
1231     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1232         private
1233         returns (F3Ddatasets.EventReturns)
1234     {
1235         // setup local rID
1236         uint256 _rID = rID_;
1237         
1238         // grab our winning player and team id's
1239         uint256 _winPID = round_[_rID].plyr;
1240         uint256 _winTID = round_[_rID].team;
1241         
1242         // grab our pot amount
1243         uint256 _pot = round_[_rID].pot;
1244         
1245         // calculate our winner share, community rewards, gen share, 
1246         // p3d share, and amount reserved for next pot 
1247         uint256 _win = (_pot.mul(48)) / 100;
1248         uint256 _com = (_pot / 50);
1249         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1250         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1251         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1252         
1253         // calculate ppt for round mask
1254         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1255         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1256         if (_dust > 0)
1257         {
1258             _gen = _gen.sub(_dust);
1259             _res = _res.add(_dust);
1260         }
1261         
1262         // pay our winner
1263         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1264         
1265         // community rewards
1266 
1267         admin.transfer(_com);
1268 
1269         admin.transfer(_p3d.sub(_p3d / 2));
1270 
1271         round_[_rID].pot = _pot.add(_p3d / 2);
1272 
1273         
1274         // distribute gen portion to key holders
1275         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1276         
1277             
1278         // prepare event data
1279         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1280         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1281         _eventData_.winnerAddr = plyr_[_winPID].addr;
1282         _eventData_.winnerName = plyr_[_winPID].name;
1283         _eventData_.amountWon = _win;
1284         _eventData_.genAmount = _gen;
1285         _eventData_.P3DAmount = _p3d;
1286         _eventData_.newPot = _res;
1287         
1288         // start next round
1289         rID_++;
1290         _rID++;
1291         round_[_rID].strt = now;
1292         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1293         round_[_rID].pot = _res;
1294         
1295         return(_eventData_);
1296     }
1297     
1298     /**
1299      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1300      */
1301     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1302         private 
1303     {
1304         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1305         if (_earnings > 0)
1306         {
1307             // put in gen vault
1308             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1309             // zero out their earnings by updating mask
1310             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1311         }
1312     }
1313     
1314     /**
1315      * @dev updates round timer based on number of whole keys bought.
1316      */
1317     function updateTimer(uint256 _keys, uint256 _rID)
1318         private
1319     {
1320         // grab time
1321         uint256 _now = now;
1322         
1323         // calculate time based on number of keys bought
1324         uint256 _newTime;
1325         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1326             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1327         else
1328             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1329         
1330         // compare to max and set new end time
1331         if (_newTime < (rndMax_).add(_now))
1332             round_[_rID].end = _newTime;
1333         else
1334             round_[_rID].end = rndMax_.add(_now);
1335     }
1336     
1337     /**
1338      * @dev generates a random number between 0-99 and checks to see if thats
1339      * resulted in an airdrop win
1340      * @return do we have a winner?
1341      */
1342     function airdrop()
1343         private 
1344         view 
1345         returns(bool)
1346     {
1347         uint256 seed = uint256(keccak256(abi.encodePacked(
1348             
1349             (block.timestamp).add
1350             (block.difficulty).add
1351             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1352             (block.gaslimit).add
1353             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1354             (block.number)
1355             
1356         )));
1357         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1358             return(true);
1359         else
1360             return(false);
1361     }
1362 
1363     /**
1364      * @dev distributes eth based on fees to com, aff, and p3d
1365      */
1366     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1367         private
1368         returns(F3Ddatasets.EventReturns)
1369     {
1370         // pay 3% out to community rewards
1371         uint256 _p1 = _eth / 100;
1372         uint256 _com = _eth / 50;
1373         _com = _com.add(_p1);
1374         uint256 _p3d;
1375         if (!address(admin).call.value(_com)())
1376         {
1377             // This ensures Team Just cannot influence the outcome of FoMo3D with
1378             // bank migrations by breaking outgoing transactions.
1379             // Something we would never do. But that's not the point.
1380             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1381             // highest belief that everything we create should be trustless.
1382             // Team JUST, The name you shouldn't have to trust.
1383             _p3d = _com;
1384             _com = 0;
1385         }
1386         
1387 
1388         
1389         // distribute share to affiliate
1390         uint256 _aff = _eth / 10;
1391         
1392         // decide what to do with affiliate share of fees
1393         // affiliate must not be self, and must have a name registered
1394         if (_affID != _pID && plyr_[_affID].name != '') {
1395             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1396             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1397         } else {
1398             _p3d = _aff;
1399         }
1400         
1401         // pay out p3d
1402         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1403         if (_p3d > 0)
1404         {
1405             // deposit to divies contract
1406             uint256 _potAmount = _p3d / 2;
1407 
1408             admin.transfer(_p3d.sub(_potAmount));
1409             
1410             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1411             // set up event data
1412             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1413         }
1414         
1415         return(_eventData_);
1416     }
1417     
1418     function potSwap()
1419         external
1420         payable
1421     {
1422         // setup local rID
1423         uint256 _rID = rID_ + 1;
1424         
1425         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1426         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1427     }
1428     
1429     /**
1430      * @dev distributes eth based on fees to gen and pot
1431      */
1432     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1433         private
1434         returns(F3Ddatasets.EventReturns)
1435     {
1436         // calculate gen share
1437         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1438         
1439         // toss 1% into airdrop pot 
1440         uint256 _air = (_eth / 100);
1441         airDropPot_ = airDropPot_.add(_air);
1442         
1443         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1444         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1445         
1446         // calculate pot 
1447         uint256 _pot = _eth.sub(_gen);
1448         
1449         // distribute gen share (thats what updateMasks() does) and adjust
1450         // balances for dust.
1451         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1452         if (_dust > 0)
1453             _gen = _gen.sub(_dust);
1454         
1455         // add eth to pot
1456         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1457         
1458         // set up event data
1459         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1460         _eventData_.potAmount = _pot;
1461         
1462         return(_eventData_);
1463     }
1464 
1465     /**
1466      * @dev updates masks for round and player when keys are bought
1467      * @return dust left over 
1468      */
1469     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1470         private
1471         returns(uint256)
1472     {
1473         /* MASKING NOTES
1474             earnings masks are a tricky thing for people to wrap their minds around.
1475             the basic thing to understand here.  is were going to have a global
1476             tracker based on profit per share for each round, that increases in
1477             relevant proportion to the increase in share supply.
1478             
1479             the player will have an additional mask that basically says "based
1480             on the rounds mask, my shares, and how much i've already withdrawn,
1481             how much is still owed to me?"
1482         */
1483         
1484         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1485         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1486         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1487             
1488         // calculate player earning from their own buy (only based on the keys
1489         // they just bought).  & update player earnings mask
1490         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1491         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1492         
1493         // calculate & return dust
1494         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1495     }
1496     
1497     /**
1498      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1499      * @return earnings in wei format
1500      */
1501     function withdrawEarnings(uint256 _pID)
1502         private
1503         returns(uint256)
1504     {
1505         // update gen vault
1506         updateGenVault(_pID, plyr_[_pID].lrnd);
1507         
1508         // from vaults 
1509         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1510         if (_earnings > 0)
1511         {
1512             plyr_[_pID].win = 0;
1513             plyr_[_pID].gen = 0;
1514             plyr_[_pID].aff = 0;
1515         }
1516 
1517         return(_earnings);
1518     }
1519     
1520     /**
1521      * @dev prepares compression data and fires event for buy or reload tx's
1522      */
1523     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1524         private
1525     {
1526         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1527         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1528         
1529         emit F3Devents.onEndTx
1530         (
1531             _eventData_.compressedData,
1532             _eventData_.compressedIDs,
1533             plyr_[_pID].name,
1534             msg.sender,
1535             _eth,
1536             _keys,
1537             _eventData_.winnerAddr,
1538             _eventData_.winnerName,
1539             _eventData_.amountWon,
1540             _eventData_.newPot,
1541             _eventData_.P3DAmount,
1542             _eventData_.genAmount,
1543             _eventData_.potAmount,
1544             airDropPot_
1545         );
1546     }
1547 //==============================================================================
1548 //    (~ _  _    _._|_    .
1549 //    _)(/_(_|_|| | | \/  .
1550 //====================/=========================================================
1551     /** upon contract deploy, it will be deactivated.  this is a one time
1552      * use function that will activate the contract.  we do this so devs 
1553      * have time to set things up on the web end                            **/
1554     bool public activated_ = false;
1555     function activate()
1556         public
1557     {
1558         // only team just can activate 
1559         require(msg.sender == admin, "only admin can activate");
1560 
1561 
1562         
1563         // can only be ran once
1564         require(activated_ == false, "FOMO Short already activated");
1565         
1566         // activate the contract 
1567         activated_ = true;
1568         
1569         // lets start first round
1570         rID_ = 1;
1571         round_[1].strt = now + rndExtra_ - rndGap_;
1572         round_[1].end = now + rndInit_ + rndExtra_;
1573 
1574     }
1575 }
1576 
1577 //==============================================================================
1578 //   __|_ _    __|_ _  .
1579 //  _\ | | |_|(_ | _\  .
1580 //==============================================================================
1581 library F3Ddatasets {
1582     //compressedData key
1583     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1584         // 0 - new player (bool)
1585         // 1 - joined round (bool)
1586         // 2 - new  leader (bool)
1587         // 3-5 - air drop tracker (uint 0-999)
1588         // 6-16 - round end time
1589         // 17 - winnerTeam
1590         // 18 - 28 timestamp 
1591         // 29 - team
1592         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1593         // 31 - airdrop happened bool
1594         // 32 - airdrop tier 
1595         // 33 - airdrop amount won
1596     //compressedIDs key
1597     // [77-52][51-26][25-0]
1598         // 0-25 - pID 
1599         // 26-51 - winPID
1600         // 52-77 - rID
1601     struct EventReturns {
1602         uint256 compressedData;
1603         uint256 compressedIDs;
1604         address winnerAddr;         // winner address
1605         bytes32 winnerName;         // winner name
1606         uint256 amountWon;          // amount won
1607         uint256 newPot;             // amount in new pot
1608         uint256 P3DAmount;          // amount distributed to p3d
1609         uint256 genAmount;          // amount distributed to gen
1610         uint256 potAmount;          // amount added to pot
1611     }
1612     struct Player {
1613         address addr;   // player address
1614         bytes32 name;   // player name
1615         uint256 win;    // winnings vault
1616         uint256 gen;    // general vault
1617         uint256 aff;    // affiliate vault
1618         uint256 lrnd;   // last round played
1619         uint256 laff;   // last affiliate id used
1620     }
1621     struct PlayerRounds {
1622         uint256 eth;    // eth player has added to round (used for eth limiter)
1623         uint256 keys;   // keys
1624         uint256 mask;   // player mask 
1625         uint256 ico;    // ICO phase investment
1626     }
1627     struct Round {
1628         uint256 plyr;   // pID of player in lead
1629         uint256 team;   // tID of team in lead
1630         uint256 end;    // time ends/ended
1631         bool ended;     // has round end function been ran
1632         uint256 strt;   // time round started
1633         uint256 keys;   // keys
1634         uint256 eth;    // total eth in
1635         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1636         uint256 mask;   // global mask
1637         uint256 ico;    // total eth sent in during ICO phase
1638         uint256 icoGen; // total eth for gen during ICO phase
1639         uint256 icoAvg; // average key price for ICO phase
1640     }
1641     struct TeamFee {
1642         uint256 gen;    // % of buy in thats paid to key holders of current round
1643         uint256 p3d;    // % of buy in thats paid to p3d holders
1644     }
1645     struct PotSplit {
1646         uint256 gen;    // % of pot thats paid to key holders of current round
1647         uint256 p3d;    // % of pot thats paid to p3d holders
1648     }
1649 }
1650 
1651 //==============================================================================
1652 //  |  _      _ _ | _  .
1653 //  |<(/_\/  (_(_||(_  .
1654 //=======/======================================================================
1655 library F3DKeysCalcShort {
1656     using SafeMath for *;
1657     /**
1658      * @dev calculates number of keys received given X eth 
1659      * @param _curEth current amount of eth in contract 
1660      * @param _newEth eth being spent
1661      * @return amount of ticket purchased
1662      */
1663     function keysRec(uint256 _curEth, uint256 _newEth)
1664         internal
1665         pure
1666         returns (uint256)
1667     {
1668         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1669     }
1670     
1671     /**
1672      * @dev calculates amount of eth received if you sold X keys 
1673      * @param _curKeys current amount of keys that exist 
1674      * @param _sellKeys amount of keys you wish to sell
1675      * @return amount of eth received
1676      */
1677     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1678         internal
1679         pure
1680         returns (uint256)
1681     {
1682         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1683     }
1684 
1685     /**
1686      * @dev calculates how many keys would exist with given an amount of eth
1687      * @param _eth eth "in contract"
1688      * @return number of keys that would exist
1689      */
1690     function keys(uint256 _eth) 
1691         internal
1692         pure
1693         returns(uint256)
1694     {
1695         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1696     }
1697     
1698     /**
1699      * @dev calculates how much eth would be in contract given a number of keys
1700      * @param _keys number of keys "in contract" 
1701      * @return eth that would exists
1702      */
1703     function eth(uint256 _keys) 
1704         internal
1705         pure
1706         returns(uint256)  
1707     {
1708         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1709     }
1710 }
1711 
1712 //==============================================================================
1713 //  . _ _|_ _  _ |` _  _ _  _  .
1714 //  || | | (/_| ~|~(_|(_(/__\  .
1715 //==============================================================================
1716 
1717 
1718 
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
1767         internal
1768         pure
1769         returns(bytes32)
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
1803                     // require character is a space
1804                     _temp[i] == 0x20 || 
1805                     // OR lowercase a-z
1806                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1807                     // or 0-9
1808                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
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
1847         internal 
1848         pure 
1849         returns (uint256 c) 
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
1863         internal
1864         pure
1865         returns (uint256) 
1866     {
1867         require(b <= a, "SafeMath sub failed");
1868         return a - b;
1869     }
1870 
1871     /**
1872     * @dev Adds two numbers, throws on overflow.
1873     */
1874     function add(uint256 a, uint256 b)
1875         internal
1876         pure
1877         returns (uint256 c) 
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
1888         internal
1889         pure
1890         returns (uint256 y) 
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
1905         internal
1906         pure
1907         returns (uint256)
1908     {
1909         return (mul(x,x));
1910     }
1911     
1912     /**
1913      * @dev x to the power of y 
1914      */
1915     function pwr(uint256 x, uint256 y)
1916         internal 
1917         pure 
1918         returns (uint256)
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