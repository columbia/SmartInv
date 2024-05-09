1 pragma solidity ^0.4.24;
2 
3 contract Suohaevents {
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
121 contract modularShort is Suohaevents {}
122 
123 contract West is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using SuohaKeysCalcLong for uint256;
127 	
128     address community_addr = 0xfd76dB2AF819978d43e07737771c8D9E8bd8cbbF;
129     address activate_addr = 0x6C7DFE3c255a098Ea031f334436DD50345cFC737;
130 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x19e6d24885d69ecd0beac5f5de5825ad61a73673);
131 //==============================================================================
132 //     _ _  _  |`. _     _ _ |_ | _  _  .
133 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
134 //=================_|===========================================================
135     string constant public name = "West";
136     string constant public symbol = "West";
137     uint256 private rndExtra_ = 0;     // length of the very first ICO
138     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
139     uint256 constant private rndInit_ = 1440 minutes;                // round timer starts at this
140     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
141     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be             // max length a round timer can be
142 //==============================================================================
143 //     _| _ _|_ _    _ _ _|_    _   .
144 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
145 //=============================|================================================
146 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
147     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
148     uint256 public rID_;    // round id number / total rounds that have happened
149 //****************
150 // PLAYER DATA 
151 //****************
152     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
153     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
154     mapping (uint256 => Suohadatasets.Player) public plyr_;   // (pID => data) player data
155     mapping (uint256 => mapping (uint256 => Suohadatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
156     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
157 //****************
158 // ROUND DATA 
159 //****************
160     mapping (uint256 => Suohadatasets.Round) public round_;   // (rID => data) round data
161     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
162 //****************
163 // TEAM FEE DATA 
164 //****************
165     mapping (uint256 => Suohadatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
166     mapping (uint256 => Suohadatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
167 //==============================================================================
168 //     _ _  _  __|_ _    __|_ _  _  .
169 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
170 //==============================================================================
171     constructor()
172         public
173     {
174 		// Team allocation structures
175         // 0 = whales  tangseng
176         // 1 = bears   shaseng
177         // 2 = sneks   wukong
178         // 3 = bulls   bajie
179 
180 		// Team allocation percentages
181         // (Suoha, 0) + (Pot , Referrals, Community)
182             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
183         fees_[0] = Suohadatasets.TeamFee(47,0);   //46% to pot, 20% to aff, 2% to com, 2% to air drop pot
184         fees_[1] = Suohadatasets.TeamFee(5,0);   //33% to pot, 20% to aff, 2% to com, 2% to air drop pot
185         fees_[2] = Suohadatasets.TeamFee(62,0);  //20% to pot, 20% to aff, 2% to com, 2% to air drop pot
186         fees_[3] = Suohadatasets.TeamFee(22,0);   //33% to pot, 20% to aff, 2% to com, 2% to air drop pot
187         
188         // how to split up the final pot based on which team was picked
189         // (Suoha, 0)
190         potSplit_[0] = Suohadatasets.PotSplit(30,0);  //48% to winner, 25% to next round, 12% to com
191         potSplit_[1] = Suohadatasets.PotSplit(40,0);   //48% to winner, 20% to next round, 12% to com
192         potSplit_[2] = Suohadatasets.PotSplit(25,0);  //48% to winner, 15% to next round, 12% to com
193         potSplit_[3] = Suohadatasets.PotSplit(35,0);  //48% to winner, 10% to next round, 12% to com
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
204         require(activated_ == true, "its not ready yet.  "); 
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
244         Suohadatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
269         Suohadatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
302         Suohadatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
343         Suohadatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
393         Suohadatasets.EventReturns memory _eventData_;
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
425         Suohadatasets.EventReturns memory _eventData_;
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
465         Suohadatasets.EventReturns memory _eventData_;
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
523             Suohadatasets.EventReturns memory _eventData_;
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
541             emit Suohaevents.onWithdrawAndDistribute
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
566             emit Suohaevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
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
607         emit Suohaevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
623         emit Suohaevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
639         emit Suohaevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
665             return ( 75000000000000 ); // init
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
845     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Suohadatasets.EventReturns memory _eventData_)
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
874                 emit Suohaevents.onBuyAndDistribute
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
899     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Suohadatasets.EventReturns memory _eventData_)
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
930             emit Suohaevents.onReLoadAndDistribute
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
950     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Suohadatasets.EventReturns memory _eventData_)
951         private
952     {
953         // if player is new to round
954         if (plyrRnds_[_pID][_rID].keys == 0)
955             _eventData_ = managePlayer(_pID, _eventData_);
956         
957         // if eth left is greater than min eth allowed (sorry no pocket lint)
958         if (_eth > 1000000000) 
959         {
960             
961             // mint the new keys
962             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
963             
964             // if they bought at least 1 whole key
965             if (_keys >= 1000000000000000000)
966             {
967             updateTimer(_keys, _rID);
968 
969             // set new leaders
970             if (round_[_rID].plyr != _pID)
971                 round_[_rID].plyr = _pID;  
972             if (round_[_rID].team != _team)
973                 round_[_rID].team = _team; 
974             
975             // set the new leader bool to true
976             _eventData_.compressedData = _eventData_.compressedData + 100;
977         }
978             
979             // manage airdrops
980             if (_eth >= 100000000000000000)
981             {
982             airDropTracker_++;
983             if (airdrop() == true)
984             {
985                 // gib muni
986                 uint256 _prize;
987                 if (_eth >= 10000000000000000000)
988                 {
989                     // calculate prize and give it to winner
990                     _prize = ((airDropPot_).mul(75)) / 100;
991                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
992                     
993                     // adjust airDropPot 
994                     airDropPot_ = (airDropPot_).sub(_prize);
995                     
996                     // let event know a tier 3 prize was won 
997                     _eventData_.compressedData += 300000000000000000000000000000000;
998                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
999                     // calculate prize and give it to winner
1000                     _prize = ((airDropPot_).mul(50)) / 100;
1001                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1002                     
1003                     // adjust airDropPot 
1004                     airDropPot_ = (airDropPot_).sub(_prize);
1005                     
1006                     // let event know a tier 2 prize was won 
1007                     _eventData_.compressedData += 200000000000000000000000000000000;
1008                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1009                     // calculate prize and give it to winner
1010                     _prize = ((airDropPot_).mul(25)) / 100;
1011                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1012                     
1013                     // adjust airDropPot 
1014                     airDropPot_ = (airDropPot_).sub(_prize);
1015                     
1016                     // let event know a tier 3 prize was won 
1017                     _eventData_.compressedData += 300000000000000000000000000000000;
1018                 }
1019                 // set airdrop happened bool to true
1020                 _eventData_.compressedData += 10000000000000000000000000000000;
1021                 // let event know how much was won 
1022                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1023                 
1024                 // reset air drop tracker
1025                 airDropTracker_ = 0;
1026             }
1027         }
1028     
1029             // store the air drop tracker number (number of buys since last airdrop)
1030             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1031             
1032             // update player 
1033             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1034             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1035             
1036             // update round
1037             round_[_rID].keys = _keys.add(round_[_rID].keys);
1038             round_[_rID].eth = _eth.add(round_[_rID].eth);
1039             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1040     
1041             // distribute eth
1042             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1043             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1044             
1045             // call end tx function to fire end tx event.
1046 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1047         }
1048     }
1049 //==============================================================================
1050 //     _ _ | _   | _ _|_ _  _ _  .
1051 //    (_(_||(_|_||(_| | (_)| _\  .
1052 //==============================================================================
1053     /**
1054      * @dev calculates unmasked earnings (just calculates, does not update mask)
1055      * @return earnings in wei format
1056      */
1057     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1058         private
1059         view
1060         returns(uint256)
1061     {
1062         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1063     }
1064     
1065     /** 
1066      * @dev returns the amount of keys you would get given an amount of eth. 
1067      * -functionhash- 0xce89c80c
1068      * @param _rID round ID you want price for
1069      * @param _eth amount of eth sent in 
1070      * @return keys received 
1071      */
1072     function calcKeysReceived(uint256 _rID, uint256 _eth)
1073         public
1074         view
1075         returns(uint256)
1076     {
1077         // grab time
1078         uint256 _now = now;
1079         
1080         // are we in a round?
1081         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1082             return ( (round_[_rID].eth).keysRec(_eth) );
1083         else // rounds over.  need keys for new round
1084             return ( (_eth).keys() );
1085     }
1086     
1087     /** 
1088      * @dev returns current eth price for X keys.  
1089      * -functionhash- 0xcf808000
1090      * @param _keys number of keys desired (in 18 decimal format)
1091      * @return amount of eth needed to send
1092      */
1093     function iWantXKeys(uint256 _keys)
1094         public
1095         view
1096         returns(uint256)
1097     {
1098         // setup local rID
1099         uint256 _rID = rID_;
1100         
1101         // grab time
1102         uint256 _now = now;
1103         
1104         // are we in a round?
1105         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1106             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1107         else // rounds over.  need price for new round
1108             return ( (_keys).eth() );
1109     }
1110 //==============================================================================
1111 //    _|_ _  _ | _  .
1112 //     | (_)(_)|_\  .
1113 //==============================================================================
1114     /**
1115 	 * @dev receives name/player info from names contract 
1116      */
1117     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1118         external
1119     {
1120         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1121         if (pIDxAddr_[_addr] != _pID)
1122             pIDxAddr_[_addr] = _pID;
1123         if (pIDxName_[_name] != _pID)
1124             pIDxName_[_name] = _pID;
1125         if (plyr_[_pID].addr != _addr)
1126             plyr_[_pID].addr = _addr;
1127         if (plyr_[_pID].name != _name)
1128             plyr_[_pID].name = _name;
1129         if (plyr_[_pID].laff != _laff)
1130             plyr_[_pID].laff = _laff;
1131         if (plyrNames_[_pID][_name] == false)
1132             plyrNames_[_pID][_name] = true;
1133     }
1134     
1135     /**
1136      * @dev receives entire player name list 
1137      */
1138     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1139         external
1140     {
1141         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1142         if(plyrNames_[_pID][_name] == false)
1143             plyrNames_[_pID][_name] = true;
1144     }   
1145         
1146     /**
1147      * @dev gets existing or registers new pID.  use this when a player may be new
1148      * @return pID 
1149      */
1150     function determinePID(Suohadatasets.EventReturns memory _eventData_)
1151         private
1152         returns (Suohadatasets.EventReturns)
1153     {
1154         uint256 _pID = pIDxAddr_[msg.sender];
1155         // if player is new to this version of fomo3d
1156         if (_pID == 0)
1157         {
1158             // grab their player ID, name and last aff ID, from player names contract 
1159             _pID = PlayerBook.getPlayerID(msg.sender);
1160             bytes32 _name = PlayerBook.getPlayerName(_pID);
1161             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1162             
1163             // set up player account 
1164             pIDxAddr_[msg.sender] = _pID;
1165             plyr_[_pID].addr = msg.sender;
1166             
1167             if (_name != "")
1168             {
1169                 pIDxName_[_name] = _pID;
1170                 plyr_[_pID].name = _name;
1171                 plyrNames_[_pID][_name] = true;
1172             }
1173             
1174             if (_laff != 0 && _laff != _pID)
1175                 plyr_[_pID].laff = _laff;
1176             
1177             // set the new player bool to true
1178             _eventData_.compressedData = _eventData_.compressedData + 1;
1179         } 
1180         return (_eventData_);
1181     }
1182     
1183     /**
1184      * @dev checks to make sure user picked a valid team.  if not sets team 
1185      * to default (sneks)
1186      */
1187     function verifyTeam(uint256 _team)
1188         private
1189         pure
1190         returns (uint256)
1191     {
1192         if (_team < 0 || _team > 3)
1193             return(2);
1194         else
1195             return(_team);
1196     }
1197     
1198     /**
1199      * @dev decides if round end needs to be run & new round started.  and if 
1200      * player unmasked earnings from previously played rounds need to be moved.
1201      */
1202     function managePlayer(uint256 _pID, Suohadatasets.EventReturns memory _eventData_)
1203         private
1204         returns (Suohadatasets.EventReturns)
1205     {
1206         // if player has played a previous round, move their unmasked earnings
1207         // from that round to gen vault.
1208         if (plyr_[_pID].lrnd != 0)
1209             updateGenVault(_pID, plyr_[_pID].lrnd);
1210             
1211         // update player's last round played
1212         plyr_[_pID].lrnd = rID_;
1213             
1214         // set the joined round bool to true
1215         _eventData_.compressedData = _eventData_.compressedData + 10;
1216         
1217         return(_eventData_);
1218     }
1219     
1220     /**
1221      * @dev ends the round. manages paying out winner/splitting up pot
1222      */
1223     function endRound(Suohadatasets.EventReturns memory _eventData_)
1224         private
1225         returns (Suohadatasets.EventReturns)
1226     {
1227         // setup local rID
1228         uint256 _rID = rID_;
1229         
1230         // grab our winning player and team id's
1231         uint256 _winPID = round_[_rID].plyr;
1232         uint256 _winTID = round_[_rID].team;
1233         
1234         // grab our pot amount
1235         uint256 _pot = round_[_rID].pot;
1236         
1237         // calculate our winner share, community rewards, gen share, 
1238         // p3d share, and amount reserved for next pot 
1239         uint256 _win = (_pot.mul(48)) / 100;
1240         uint256 _com = (_pot / 50);
1241         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1242         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1243         
1244         // calculate ppt for round mask
1245         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1246         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1247         if (_dust > 0)
1248         {
1249             _gen = _gen.sub(_dust);
1250             _res = _res.add(_dust);
1251         }
1252         
1253         // pay our winner
1254         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1255         
1256         // community rewards
1257         community_addr.transfer(_com);
1258         
1259         // distribute gen portion to key holders
1260         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1261         
1262             
1263         // prepare event data
1264         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1265         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1266         _eventData_.winnerAddr = plyr_[_winPID].addr;
1267         _eventData_.winnerName = plyr_[_winPID].name;
1268         _eventData_.amountWon = _win;
1269         _eventData_.genAmount = _gen;
1270         _eventData_.P3DAmount = 0;
1271         _eventData_.newPot = _res;
1272         
1273         // start next round
1274         rID_++;
1275         _rID++;
1276         round_[_rID].strt = now;
1277         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1278         round_[_rID].pot = _res;
1279         
1280         return(_eventData_);
1281     }
1282     
1283     /**
1284      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1285      */
1286     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1287         private 
1288     {
1289         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1290         if (_earnings > 0)
1291         {
1292             // put in gen vault
1293             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1294             // zero out their earnings by updating mask
1295             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1296         }
1297     }
1298     
1299     /**
1300      * @dev updates round timer based on number of whole keys bought.
1301      */
1302     function updateTimer(uint256 _keys, uint256 _rID)
1303         private
1304     {
1305         // grab time
1306         uint256 _now = now;
1307         
1308         // calculate time based on number of keys bought
1309         uint256 _newTime;
1310         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1311             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1312         else
1313             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1314         
1315         // compare to max and set new end time
1316         if (_newTime < (rndMax_).add(_now))
1317             round_[_rID].end = _newTime;
1318         else
1319             round_[_rID].end = rndMax_.add(_now);
1320     }
1321     
1322     /**
1323      * @dev generates a random number between 0-99 and checks to see if thats
1324      * resulted in an airdrop win
1325      * @return do we have a winner?
1326      */
1327     function airdrop()
1328         private 
1329         view 
1330         returns(bool)
1331     {
1332         uint256 seed = uint256(keccak256(abi.encodePacked(
1333             
1334             (block.timestamp).add
1335             (block.difficulty).add
1336             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1337             (block.gaslimit).add
1338             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1339             (block.number)
1340             
1341         )));
1342         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1343             return(true);
1344         else
1345             return(false);
1346     }
1347 
1348     /**
1349      * @dev distributes eth based on fees to com, aff, and p3d
1350      */
1351     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Suohadatasets.EventReturns memory _eventData_)
1352         private
1353         returns(Suohadatasets.EventReturns)
1354     {
1355         // pay 3% out to community rewards
1356         uint256 _com = (_eth.mul(3)) / 100;
1357         
1358     
1359         
1360         // distribute share to affiliate  10%
1361         uint256 _aff = _eth / 10;
1362         
1363         // decide what to do with affiliate share of fees
1364         // affiliate must not be self, and must have a name registered
1365         if (_affID != _pID && plyr_[_affID].name != '') {
1366             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1367             emit Suohaevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1368         } else {
1369             _com = _com.add(_aff);
1370         }
1371         community_addr.transfer(_com);
1372         
1373         return(_eventData_);
1374     }
1375     
1376     /**
1377      * @dev distributes eth based on fees to gen and pot
1378      */
1379     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Suohadatasets.EventReturns memory _eventData_)
1380         private
1381         returns(Suohadatasets.EventReturns)
1382     {
1383         // calculate gen share
1384         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1385         
1386         // toss 2% into airdrop pot 
1387         //uint256 _air = (_eth / 50);
1388         uint256 _air = 0;
1389         airDropPot_ = airDropPot_.add(_air);
1390         
1391         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1392         _eth = _eth.sub(((_eth.mul(13)) / 100));
1393         
1394         // calculate pot 
1395         uint256 _pot = _eth.sub(_gen);
1396         
1397         // distribute gen share (thats what updateMasks() does) and adjust
1398         // balances for dust.
1399         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1400         if (_dust > 0)
1401             _gen = _gen.sub(_dust);
1402         
1403         // add eth to pot
1404         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1405         
1406         // set up event data
1407         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1408         _eventData_.potAmount = _pot;
1409         
1410         return(_eventData_);
1411     }
1412 
1413     /**
1414      * @dev updates masks for round and player when keys are bought
1415      * @return dust left over 
1416      */
1417     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1418         private
1419         returns(uint256)
1420     {
1421         /* MASKING NOTES
1422             earnings masks are a tricky thing for people to wrap their minds around.
1423             the basic thing to understand here.  is were going to have a global
1424             tracker based on profit per share for each round, that increases in
1425             relevant proportion to the increase in share supply.
1426             
1427             the player will have an additional mask that basically says "based
1428             on the rounds mask, my shares, and how much i've already withdrawn,
1429             how much is still owed to me?"
1430         */
1431         
1432         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1433         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1434         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1435             
1436         // calculate player earning from their own buy (only based on the keys
1437         // they just bought).  & update player earnings mask
1438         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1439         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1440         
1441         // calculate & return dust
1442         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1443     }
1444     
1445     /**
1446      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1447      * @return earnings in wei format
1448      */
1449     function withdrawEarnings(uint256 _pID)
1450         private
1451         returns(uint256)
1452     {
1453         // update gen vault
1454         updateGenVault(_pID, plyr_[_pID].lrnd);
1455         
1456         // from vaults 
1457         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1458         if (_earnings > 0)
1459         {
1460             plyr_[_pID].win = 0;
1461             plyr_[_pID].gen = 0;
1462             plyr_[_pID].aff = 0;
1463         }
1464 
1465         return(_earnings);
1466     }
1467     
1468     /**
1469      * @dev prepares compression data and fires event for buy or reload tx's
1470      */
1471     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Suohadatasets.EventReturns memory _eventData_)
1472         private
1473     {
1474         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1475         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1476         
1477         emit Suohaevents.onEndTx
1478         (
1479             _eventData_.compressedData,
1480             _eventData_.compressedIDs,
1481             plyr_[_pID].name,
1482             msg.sender,
1483             _eth,
1484             _keys,
1485             _eventData_.winnerAddr,
1486             _eventData_.winnerName,
1487             _eventData_.amountWon,
1488             _eventData_.newPot,
1489             _eventData_.P3DAmount,
1490             _eventData_.genAmount,
1491             _eventData_.potAmount,
1492             airDropPot_
1493         );
1494     }
1495 //==============================================================================
1496 //    (~ _  _    _._|_    .
1497 //    _)(/_(_|_|| | | \/  .
1498 //====================/=========================================================
1499     /** upon contract deploy, it will be deactivated.  this is a one time
1500      * use function that will activate the contract.  we do this so devs 
1501      * have time to set things up on the web end                            **/
1502     bool public activated_ = false;
1503     function activate()
1504         public
1505     {
1506         // only team just can activate 
1507         require(
1508             msg.sender == activate_addr, "only activate can activate"
1509         );
1510 
1511         
1512         // can only be ran once
1513         require(activated_ == false, "shuoha already activated");
1514         
1515         // activate the contract 
1516         activated_ = true;
1517         
1518         // lets start first round
1519 		rID_ = 1;
1520         round_[1].strt = now + rndExtra_ - rndGap_;
1521         round_[1].end = now + rndInit_ + rndExtra_;
1522     }
1523 }
1524 
1525 //==============================================================================
1526 //   __|_ _    __|_ _  .
1527 //  _\ | | |_|(_ | _\  .
1528 //==============================================================================
1529 library Suohadatasets {
1530     //compressedData key
1531     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1532         // 0 - new player (bool)
1533         // 1 - joined round (bool)
1534         // 2 - new  leader (bool)
1535         // 3-5 - air drop tracker (uint 0-999)
1536         // 6-16 - round end time
1537         // 17 - winnerTeam
1538         // 18 - 28 timestamp 
1539         // 29 - team
1540         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1541         // 31 - airdrop happened bool
1542         // 32 - airdrop tier 
1543         // 33 - airdrop amount won
1544     //compressedIDs key
1545     // [77-52][51-26][25-0]
1546         // 0-25 - pID 
1547         // 26-51 - winPID
1548         // 52-77 - rID
1549     struct EventReturns {
1550         uint256 compressedData;
1551         uint256 compressedIDs;
1552         address winnerAddr;         // winner address
1553         bytes32 winnerName;         // winner name
1554         uint256 amountWon;          // amount won
1555         uint256 newPot;             // amount in new pot
1556         uint256 P3DAmount;          // amount distributed to p3d
1557         uint256 genAmount;          // amount distributed to gen
1558         uint256 potAmount;          // amount added to pot
1559     }
1560     struct Player {
1561         address addr;   // player address
1562         bytes32 name;   // player name
1563         uint256 win;    // winnings vault
1564         uint256 gen;    // general vault
1565         uint256 aff;    // affiliate vault
1566         uint256 lrnd;   // last round played
1567         uint256 laff;   // last affiliate id used
1568     }
1569     struct PlayerRounds {
1570         uint256 eth;    // eth player has added to round (used for eth limiter)
1571         uint256 keys;   // keys
1572         uint256 mask;   // player mask 
1573         uint256 ico;    // ICO phase investment
1574     }
1575     struct Round {
1576         uint256 plyr;   // pID of player in lead
1577         uint256 team;   // tID of team in lead
1578         uint256 end;    // time ends/ended
1579         bool ended;     // has round end function been ran
1580         uint256 strt;   // time round started
1581         uint256 keys;   // keys
1582         uint256 eth;    // total eth in
1583         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1584         uint256 mask;   // global mask
1585         uint256 ico;    // total eth sent in during ICO phase
1586         uint256 icoGen; // total eth for gen during ICO phase
1587         uint256 icoAvg; // average key price for ICO phase
1588     }
1589     struct TeamFee {
1590         uint256 gen;    // % of buy in thats paid to key holders of current round
1591         uint256 p3d;    // % of buy in thats paid to p3d holders
1592     }
1593     struct PotSplit {
1594         uint256 gen;    // % of pot thats paid to key holders of current round
1595         uint256 p3d;    // % of pot thats paid to p3d holders
1596     }
1597 }
1598 
1599 //==============================================================================
1600 //  |  _      _ _ | _  .
1601 //  |<(/_\/  (_(_||(_  .
1602 //=======/======================================================================
1603 library SuohaKeysCalcLong {
1604     using SafeMath for *;
1605     /**
1606      * @dev calculates number of keys received given X eth 
1607      * @param _curEth current amount of eth in contract 
1608      * @param _newEth eth being spent
1609      * @return amount of ticket purchased
1610      */
1611     function keysRec(uint256 _curEth, uint256 _newEth)
1612         internal
1613         pure
1614         returns (uint256)
1615     {
1616         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1617     }
1618 
1619     /**
1620      * @dev calculates amount of eth received if you sold X keys 
1621      * @param _curKeys current amount of keys that exist 
1622      * @param _sellKeys amount of keys you wish to sell
1623      * @return amount of eth received
1624      */
1625     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1626         internal
1627         pure
1628         returns (uint256)
1629     {
1630         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1631     }
1632 
1633     /**
1634      * @dev calculates how many keys would exist with given an amount of eth
1635      * @param _eth eth "in contract"
1636      * @return number of keys that would exist
1637      */
1638     function keys(uint256 _eth) 
1639         internal
1640         pure
1641         returns(uint256)
1642     {
1643         return ((((((_eth).mul(1000000000000000000)).mul(156250000000000000000000000)).add(1406247070314025878906250000000000000000000000000000000000000000)).sqrt()).sub(37499960937500000000000000000000)) / (78125000);
1644     }
1645 
1646     /**
1647      * @dev calculates how much eth would be in contract given a number of keys
1648      * @param _keys number of keys "in contract" 
1649      * @return eth that would exists
1650      */
1651     function eth(uint256 _keys) 
1652         internal
1653         pure
1654         returns(uint256)  
1655     {
1656         return ((39062500).mul(_keys.sq()).add(((74999921875000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1657     }
1658 }
1659 
1660 //==============================================================================
1661 //  . _ _|_ _  _ |` _  _ _  _  .
1662 //  || | | (/_| ~|~(_|(_(/__\  .
1663 //==============================================================================
1664 
1665 interface PlayerBookInterface {
1666     function getPlayerID(address _addr) external returns (uint256);
1667     function getPlayerName(uint256 _pID) external view returns (bytes32);
1668     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1669     function getPlayerAddr(uint256 _pID) external view returns (address);
1670     function getNameFee() external view returns (uint256);
1671     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1672     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1673     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1674 }
1675 
1676 
1677 library NameFilter {
1678     /**
1679      * @dev filters name strings
1680      * -converts uppercase to lower case.  
1681      * -makes sure it does not start/end with a space
1682      * -makes sure it does not contain multiple spaces in a row
1683      * -cannot be only numbers
1684      * -cannot start with 0x 
1685      * -restricts characters to A-Z, a-z, 0-9, and space.
1686      * @return reprocessed string in bytes32 format
1687      */
1688     function nameFilter(string _input)
1689         internal
1690         pure
1691         returns(bytes32)
1692     {
1693         bytes memory _temp = bytes(_input);
1694         uint256 _length = _temp.length;
1695         
1696         //sorry limited to 32 characters
1697         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1698         // make sure it doesnt start with or end with space
1699         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1700         // make sure first two characters are not 0x
1701         if (_temp[0] == 0x30)
1702         {
1703             require(_temp[1] != 0x78, "string cannot start with 0x");
1704             require(_temp[1] != 0x58, "string cannot start with 0X");
1705         }
1706         
1707         // create a bool to track if we have a non number character
1708         bool _hasNonNumber;
1709         
1710         // convert & check
1711         for (uint256 i = 0; i < _length; i++)
1712         {
1713             // if its uppercase A-Z
1714             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1715             {
1716                 // convert to lower case a-z
1717                 _temp[i] = byte(uint(_temp[i]) + 32);
1718                 
1719                 // we have a non number
1720                 if (_hasNonNumber == false)
1721                     _hasNonNumber = true;
1722             } else {
1723                 require
1724                 (
1725                     // require character is a space
1726                     _temp[i] == 0x20 || 
1727                     // OR lowercase a-z
1728                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1729                     // or 0-9
1730                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1731                     "string contains invalid characters"
1732                 );
1733                 // make sure theres not 2x spaces in a row
1734                 if (_temp[i] == 0x20)
1735                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1736                 
1737                 // see if we have a character other than a number
1738                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1739                     _hasNonNumber = true;    
1740             }
1741         }
1742         
1743         require(_hasNonNumber == true, "string cannot be only numbers");
1744         
1745         bytes32 _ret;
1746         assembly {
1747             _ret := mload(add(_temp, 32))
1748         }
1749         return (_ret);
1750     }
1751 }
1752 
1753 /**
1754  * @title SafeMath v0.1.9
1755  * @dev Math operations with safety checks that throw on error
1756  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1757  * - added sqrt
1758  * - added sq
1759  * - added pwr 
1760  * - changed asserts to requires with error log outputs
1761  * - removed div, its useless
1762  */
1763 library SafeMath {
1764     
1765     /**
1766     * @dev Multiplies two numbers, throws on overflow.
1767     */
1768     function mul(uint256 a, uint256 b) 
1769         internal 
1770         pure 
1771         returns (uint256 c) 
1772     {
1773         if (a == 0) {
1774             return 0;
1775         }
1776         c = a * b;
1777         require(c / a == b, "SafeMath mul failed");
1778         return c;
1779     }
1780 
1781     /**
1782     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1783     */
1784     function sub(uint256 a, uint256 b)
1785         internal
1786         pure
1787         returns (uint256) 
1788     {
1789         require(b <= a, "SafeMath sub failed");
1790         return a - b;
1791     }
1792 
1793     /**
1794     * @dev Adds two numbers, throws on overflow.
1795     */
1796     function add(uint256 a, uint256 b)
1797         internal
1798         pure
1799         returns (uint256 c) 
1800     {
1801         c = a + b;
1802         require(c >= a, "SafeMath add failed");
1803         return c;
1804     }
1805     
1806     /**
1807      * @dev gives square root of given x.
1808      */
1809     function sqrt(uint256 x)
1810         internal
1811         pure
1812         returns (uint256 y) 
1813     {
1814         uint256 z = ((add(x,1)) / 2);
1815         y = x;
1816         while (z < y) 
1817         {
1818             y = z;
1819             z = ((add((x / z),z)) / 2);
1820         }
1821     }
1822     
1823     /**
1824      * @dev gives square. multiplies x by x
1825      */
1826     function sq(uint256 x)
1827         internal
1828         pure
1829         returns (uint256)
1830     {
1831         return (mul(x,x));
1832     }
1833     
1834     /**
1835      * @dev x to the power of y 
1836      */
1837     function pwr(uint256 x, uint256 y)
1838         internal 
1839         pure 
1840         returns (uint256)
1841     {
1842         if (x==0)
1843             return (0);
1844         else if (y==0)
1845             return (1);
1846         else 
1847         {
1848             uint256 z = x;
1849             for (uint256 i=1; i < y; i++)
1850                 z = mul(z,x);
1851             return (z);
1852         }
1853     }
1854 }