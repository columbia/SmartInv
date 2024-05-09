1 pragma solidity ^0.4.24;
2 
3 //==============================================================================
4 //     _    _  _ _|_ _  .
5 //    (/_\/(/_| | | _\  .
6 //==============================================================================
7 contract F3Devents {
8     // fired whenever a player registers a name
9     event onNewName
10     (
11         uint256 indexed playerID,
12         address indexed playerAddress,
13         bytes32 indexed playerName,
14         bool isNewPlayer,
15         uint256 affiliateID,
16         address affiliateAddress,
17         bytes32 affiliateName,
18         uint256 amountPaid,
19         uint256 timeStamp
20     );
21     
22     // fired at end of buy or reload
23     event onEndTx
24     (
25         uint256 compressedData,     
26         uint256 compressedIDs,      
27         bytes32 playerName,
28         address playerAddress,
29         uint256 ethIn,
30         uint256 keysBought,
31         address winnerAddr,
32         bytes32 winnerName,
33         uint256 amountWon,
34         uint256 newPot,
35         uint256 P3DAmount,
36         uint256 genAmount,
37         uint256 potAmount,
38         uint256 airDropPot
39     );
40     
41 	// fired whenever theres a withdraw
42     event onWithdraw
43     (
44         uint256 indexed playerID,
45         address playerAddress,
46         bytes32 playerName,
47         uint256 ethOut,
48         uint256 timeStamp
49     );
50     
51     // fired whenever a withdraw forces end round to be ran
52     event onWithdrawAndDistribute
53     (
54         address playerAddress,
55         bytes32 playerName,
56         uint256 ethOut,
57         uint256 compressedData,
58         uint256 compressedIDs,
59         address winnerAddr,
60         bytes32 winnerName,
61         uint256 amountWon,
62         uint256 newPot,
63         uint256 P3DAmount,
64         uint256 genAmount
65     );
66     
67     // (fomo3d long only) fired whenever a player tries a buy after round timer 
68     // hit zero, and causes end round to be ran.
69     event onBuyAndDistribute
70     (
71         address playerAddress,
72         bytes32 playerName,
73         uint256 ethIn,
74         uint256 compressedData,
75         uint256 compressedIDs,
76         address winnerAddr,
77         bytes32 winnerName,
78         uint256 amountWon,
79         uint256 newPot,
80         uint256 P3DAmount,
81         uint256 genAmount
82     );
83     
84     // (fomo3d long only) fired whenever a player tries a reload after round timer 
85     // hit zero, and causes end round to be ran.
86     event onReLoadAndDistribute
87     (
88         address playerAddress,
89         bytes32 playerName,
90         uint256 compressedData,
91         uint256 compressedIDs,
92         address winnerAddr,
93         bytes32 winnerName,
94         uint256 amountWon,
95         uint256 newPot,
96         uint256 P3DAmount,
97         uint256 genAmount
98     );
99     
100     // fired whenever an affiliate is paid
101     event onAffiliatePayout
102     (
103         uint256 indexed affiliateID,
104         address affiliateAddress,
105         bytes32 affiliateName,
106         uint256 indexed roundID,
107         uint256 indexed buyerID,
108         uint256 amount,
109         uint256 timeStamp
110     );
111     
112     // received pot swap deposit
113     event onPotSwapDeposit
114     (
115         uint256 roundID,
116         uint256 amountAddedToPot
117     );
118 }
119 
120 //==============================================================================
121 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
122 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
123 //====================================|=========================================
124 
125 contract modularShort is F3Devents {}
126 
127 contract Fomo is modularShort {
128     using SafeMath for *;
129     using NameFilter for string;
130     using F3DKeysCalcShort for uint256;
131 
132     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x591C66bA5a3429FcAD0Fe11A0F58e56fE36b5A73);
133 
134 //==============================================================================
135 //     _ _  _  |`. _     _ _ |_ | _  _  .
136 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
137 //=================_|===========================================================
138     address private admin = msg.sender;
139     string constant public name = "Fomo War";
140     string constant public symbol = "FW";
141     uint256 private rndGap_ = 1 seconds;         // length of ICO phase
142     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
143     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
144     uint256 constant private rndMax_ =  24 hours;                // max length a round timer can be
145 //==============================================================================
146 //     _| _ _|_ _    _ _ _|_    _   .
147 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
148 //=============================|================================================
149 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
150     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
151     uint256 public rID_;    // round id number / total rounds that have happened    
152 //****************
153 // PLAYER DATA 
154 //****************
155     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
156     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
157     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
158     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
159     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
160 //****************
161 // ROUND DATA 
162 //****************
163     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
164     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
165 //****************
166 // TEAM FEE DATA 
167 //****************
168     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
169     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
170 
171 //==============================================================================
172 //     _ _  _  __|_ _    __|_ _  _  .
173 //    (_(_)| |_\ | | |_|(_ | (_)|   . (initial data setup upon contract deploy)
174 //==============================================================================
175     constructor()
176         public
177     {
178         // Team allocation structures
179         // 0 = Thor
180         // 1 = Captain
181         // 2 = IronMan
182         // 3 = Hulk
183 
184         // Team allocation percentages
185         // (F3D, P3D) + (Pot , Referrals, Community), We are not giving any part to P3D holder.
186             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
187         fees_[0] = F3Ddatasets.TeamFee(32,0);   //50% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
188         fees_[1] = F3Ddatasets.TeamFee(45,0);   //37% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
189         fees_[2] = F3Ddatasets.TeamFee(62,0);  //20% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
190         fees_[3] = F3Ddatasets.TeamFee(47,0);   //35% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
191 
192         // how to split up the final pot based on which team was picked
193         // (F3D, P3D)
194         potSplit_[0] = F3Ddatasets.PotSplit(47,0);  //25% to winner, 25% to next round, 3% to com
195         potSplit_[1] = F3Ddatasets.PotSplit(47,0);   //25% to winner, 25% to next round, 3% to com
196         potSplit_[2] = F3Ddatasets.PotSplit(62,0);  //25% to winner, 10% to next round, 3% to com
197         potSplit_[3] = F3Ddatasets.PotSplit(62,0);  //25% to winner, 10% to next round,3% to com
198     }
199 //==============================================================================
200 //     _ _  _  _|. |`. _  _ _  .
201 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
202 //==============================================================================
203     /**
204      * @dev used to make sure no one can interact with contract until it has 
205      * been activated. 
206      */
207     modifier isActivated() {
208         require(activated_ == true, "ouch, ccontract is not ready yet !");
209         _;
210     }
211 
212     /**
213      * @dev prevents contracts from interacting with fomo3d
214      */
215     modifier isHuman() {
216         require(msg.sender == tx.origin, "nope, you're not an Human buddy !!");
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
244         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
269         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
302         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
343         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
393         F3Ddatasets.EventReturns memory _eventData_;
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
425         F3Ddatasets.EventReturns memory _eventData_;
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
465         F3Ddatasets.EventReturns memory _eventData_;
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
523             F3Ddatasets.EventReturns memory _eventData_;
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
541             emit F3Devents.onWithdrawAndDistribute
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
566             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
567         }
568    }
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
607         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
623         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
639         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
706         // Setup local rID
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
717                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(25)) / 100 ),
718                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
719                     plyr_[_pID].aff
720                 );
721             // if the player is not the winner
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
743      *  solidity hates stack limits.  this lets us avoid that hate
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
845     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
846         private
847     {
848         // setup local rID
849         uint256 _rID = rID_;
850 
851         // grab time 
852         uint256 _now = now;
853 
854         // if round is active
855 
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
874                 // // fire buy and distribute event 
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
896     
897     /**
898      * @dev logic runs whenever a reload order is executed.  determines how to handle 
899      * incoming eth depending on if we are in an active round or not 
900      */
901     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
902         private
903     {
904         // setup local rID
905         uint256 _rID = rID_;
906 
907         // grab time
908         uint256 _now = now;
909 
910         //if round is active
911         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
912         {
913             // get earnings from all vaults and return unused to gen vault
914             // because we use a custom safemath library.  this will throw if player 
915             // tried to spend more eth than they have.
916             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
917             
918             // call core 
919             core(_rID, _pID, _eth, _affID, _team, _eventData_);
920 
921         // if round is not active and end round needs to be ran   
922         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
923             // end the round (distributes pot) & start new round
924             round_[_rID].ended = true;
925             _eventData_ = endRound(_eventData_);
926                 
927             // build event data
928             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
929             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
930                 
931             // fire buy and distribute event 
932             emit F3Devents.onReLoadAndDistribute
933             (
934                 msg.sender,
935                 plyr_[_pID].name,
936                 _eventData_.compressedData,
937                 _eventData_.compressedIDs,
938                 _eventData_.winnerAddr,
939                 _eventData_.winnerName,
940                 _eventData_.amountWon,
941                 _eventData_.newPot,
942                 _eventData_.P3DAmount,
943                 _eventData_.genAmount
944             );
945         }
946     }
947 
948     /**
949      * @dev this is the core logic for any buy/reload that happens while a round 
950      * is live.
951      */
952     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
953         private
954     {
955         // if player is new to round
956         if (plyrRnds_[_pID][_rID].keys == 0)
957             _eventData_ = managePlayer(_pID, _eventData_);
958 
959         // early round eth limiter 
960         if (round_[_rID].eth < 10000000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 100000000000000000000)
961         {
962             uint256 _availableLimit = (100000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
963             uint256 _refund = _eth.sub(_availableLimit);
964             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
965             _eth = _availableLimit;
966         }
967 
968         // if eth left is greater than min eth allowed (sorry no pocket lint)
969         if (_eth > 1000000000) 
970         {
971             
972             // mint the new keys
973             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
974             
975             // if they bought at least 1 whole key
976             if (_keys >= 1000000000000000000)
977             {
978             updateTimer(_keys, _rID);
979 
980             // set new leaders
981             if (round_[_rID].plyr != _pID)
982                 round_[_rID].plyr = _pID;
983             if (round_[_rID].team != _team)
984                 round_[_rID].team = _team;
985 
986             // set the new leader bool to true
987             _eventData_.compressedData = _eventData_.compressedData + 100;
988         }
989 
990 
991             // store the air drop tracker number (number of buys since last airdrop)
992             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
993 
994             // update player
995             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
996             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
997 
998             // update round
999             round_[_rID].keys = _keys.add(round_[_rID].keys);
1000             round_[_rID].eth = _eth.add(round_[_rID].eth);
1001             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1002 
1003             // distribute eth
1004             _eventData_ = distributeExternal(_rID, _eth, _team, _eventData_);
1005             _eventData_ = distributeInternal(_rID, _pID, _eth, _affID, _team, _keys, _eventData_);
1006 
1007             // call end tx function to fire end tx event.
1008             endTx(_pID, _team, _eth, _keys, _eventData_);
1009         }
1010     }
1011 //==============================================================================
1012 //     _ _ | _   | _ _|_ _  _ _  .
1013 //    (_(_||(_|_||(_| | (_)| _\  .
1014 //==============================================================================
1015     /**
1016      * @dev calculates unmasked earnings (just calculates, does not update mask)
1017      * @return earnings in wei format
1018      */
1019     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1020         private
1021         view
1022         returns(uint256)
1023     {
1024         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1025     }
1026 
1027     /** 
1028      * @dev returns the amount of keys you would get given an amount of eth. 
1029      * -functionhash- 0xce89c80c
1030      * @param _rID round ID you want price for
1031      * @param _eth amount of eth sent in 
1032      * @return keys received 
1033      */
1034     function calcKeysReceived(uint256 _rID, uint256 _eth)
1035         public
1036         view
1037         returns(uint256)
1038     {
1039         // grab time
1040         uint256 _now = now;
1041         
1042         // are we in a round?
1043         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1044             return ( (round_[_rID].eth).keysRec(_eth) );
1045         else // rounds over.  need keys for new round
1046             return ( (_eth).keys() );
1047     }
1048 
1049     /** 
1050      * @dev returns current eth price for X keys.  
1051      * -functionhash- 0xcf808000
1052      * @param _keys number of keys desired (in 18 decimal format)
1053      * @return amount of eth needed to send
1054      */
1055     function iWantXKeys(uint256 _keys)
1056         public
1057         view
1058         returns(uint256)
1059     {
1060         // setup local rID
1061         uint256 _rID = rID_;
1062         
1063         // grab time
1064         uint256 _now = now;
1065         
1066         // are we in a round?
1067         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1068             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1069         else // rounds over.  need price for new round
1070             return ( (_keys).eth() );
1071     }
1072 //==============================================================================
1073 //    _|_ _  _ | _  .
1074 //     | (_)(_)|_\  .
1075 //==============================================================================
1076     /**
1077 	 * @dev receives name/player info from names contract 
1078      */
1079     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1080         external
1081     {
1082         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1083         if (pIDxAddr_[_addr] != _pID)
1084             pIDxAddr_[_addr] = _pID;
1085         if (pIDxName_[_name] != _pID)
1086             pIDxName_[_name] = _pID;
1087         if (plyr_[_pID].addr != _addr)
1088             plyr_[_pID].addr = _addr;
1089         if (plyr_[_pID].name != _name)
1090             plyr_[_pID].name = _name;
1091         if (plyr_[_pID].laff != _laff)
1092             plyr_[_pID].laff = _laff;
1093         if (plyrNames_[_pID][_name] == false)
1094             plyrNames_[_pID][_name] = true;
1095     }
1096 
1097     /**
1098      * @dev receives entire player name list 
1099      */
1100     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1101         external
1102     {
1103         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1104         if(plyrNames_[_pID][_name] == false)
1105             plyrNames_[_pID][_name] = true;
1106     }
1107 
1108     /**
1109      * @dev gets existing or registers new pID.  use this when a player may be new
1110      * @return pID 
1111      */
1112     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1113         private
1114         returns (F3Ddatasets.EventReturns)
1115     {
1116         uint256 _pID = pIDxAddr_[msg.sender];
1117         // if player is new to this version of fomo3d
1118         if (_pID == 0)
1119         {
1120             // grab their player ID, name and last aff ID, from player names contract 
1121             _pID = PlayerBook.getPlayerID(msg.sender);
1122             bytes32 _name = PlayerBook.getPlayerName(_pID);
1123             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1124 
1125             // set up player account 
1126             pIDxAddr_[msg.sender] = _pID;
1127             plyr_[_pID].addr = msg.sender;
1128 
1129             if (_name != "")
1130             {
1131                 pIDxName_[_name] = _pID;
1132                 plyr_[_pID].name = _name;
1133                 plyrNames_[_pID][_name] = true;
1134             }
1135 
1136             if (_laff != 0 && _laff != _pID)
1137                 plyr_[_pID].laff = _laff;
1138 
1139             // set the new player bool to true
1140             _eventData_.compressedData = _eventData_.compressedData + 1;
1141         }
1142         return (_eventData_);
1143     }
1144 
1145     /**
1146      * @dev checks to make sure user picked a valid team.  if not sets team 
1147      * to default (sneks)
1148      */
1149     function verifyTeam(uint256 _team)
1150         private
1151         pure
1152         returns (uint256)
1153     {
1154         if (_team < 0 || _team > 3)
1155             return(2);
1156         else
1157             return(_team);
1158     }
1159 
1160     /**
1161      * @dev decides if round end needs to be run & new round started.  and if 
1162      * player unmasked earnings from previously played rounds need to be moved.
1163      */
1164     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1165         private
1166         returns (F3Ddatasets.EventReturns)
1167     {
1168         // if player has played a previous round, move their unmasked earnings
1169         // from that round to gen vault.
1170         if (plyr_[_pID].lrnd != 0)
1171             updateGenVault(_pID, plyr_[_pID].lrnd);
1172 
1173         // update player's last round played
1174         plyr_[_pID].lrnd = rID_;
1175             
1176         // set the joined round bool to true
1177         _eventData_.compressedData = _eventData_.compressedData + 10;
1178 
1179         return(_eventData_);
1180     }
1181 
1182     /**
1183      * @dev ends the round. manages paying out winner/splitting up pot
1184      */
1185     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1186         private
1187         returns (F3Ddatasets.EventReturns)
1188     {
1189         // setup local rID
1190         uint256 _rID = rID_;
1191         
1192         // grab our winning player and team id's
1193         uint256 _winPID = round_[_rID].plyr;
1194         uint256 _winTID = round_[_rID].team;
1195         
1196         // grab our pot amount
1197         uint256 _pot = round_[_rID].pot;
1198         
1199         // calculate our winner share, community rewards, gen share, 
1200         // p3d share, and amount reserved for next pot 
1201         uint256 _win = (_pot.mul(25)) / 100;
1202         uint256 _com = (_pot.mul(3)) / 100;
1203         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1204         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1205         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1206 
1207         // calculate ppt for round mask
1208         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1209         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1210         if (_dust > 0)
1211         {
1212             _gen = _gen.sub(_dust);
1213             _res = _res.add(_dust);
1214         }
1215 
1216         // pay our winner
1217         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1218 
1219         // Community awards
1220 
1221         admin.transfer(_com);
1222 
1223         // distribute gen portion to key holders
1224         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1225 
1226         // Prepare event data
1227         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1228         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1229         _eventData_.winnerAddr = plyr_[_winPID].addr;
1230         _eventData_.winnerName = plyr_[_winPID].name;
1231         _eventData_.amountWon = _win;
1232         _eventData_.genAmount = _gen;
1233         _eventData_.P3DAmount = _p3d;
1234         _eventData_.newPot = _res;
1235 
1236         // Start next round
1237         rID_++;
1238         _rID++;
1239         round_[_rID].strt = now;
1240         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1241         round_[_rID].pot = _res;
1242 
1243         return(_eventData_);
1244     }
1245 
1246     /**
1247      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1248      */
1249     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1250         private
1251     {
1252         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1253         if (_earnings > 0)
1254         {
1255             // put in gen vault
1256             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1257             // zero out their earnings by updating mask
1258             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1259         }
1260     }
1261 
1262     /**
1263      * @dev updates round timer based on number of whole keys bought.
1264      */
1265     function updateTimer(uint256 _keys, uint256 _rID)
1266         private
1267     {
1268         // grab time
1269         uint256 _now = now;
1270 
1271         // calculate time based on number of keys bought
1272         uint256 _newTime;
1273         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1274             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1275         else
1276             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1277 
1278         // compare to max and set new end time
1279         if (_newTime < (rndMax_).add(_now))
1280             round_[_rID].end = _newTime;
1281         else
1282             round_[_rID].end = rndMax_.add(_now);
1283     }
1284 
1285     /**
1286      * @dev generates a random number between 0-99 and checks to see if thats
1287      * resulted in an airdrop win
1288      * @return do we have a winner?
1289      */
1290     function airdrop()
1291         private
1292         view
1293         returns(bool)
1294     {
1295         uint256 seed = uint256(keccak256(abi.encodePacked(
1296 
1297             (block.timestamp).add
1298             (block.difficulty).add
1299             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1300             (block.gaslimit).add
1301             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1302             (block.number)
1303 
1304         )));
1305         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1306             return(true);
1307         else
1308             return(false);
1309     }
1310 
1311     /**
1312      * @dev distributes eth based on fees to com, aff, and p3d
1313      */
1314     function distributeExternal(uint256 _rID, uint256 _eth, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1315         private
1316         returns(F3Ddatasets.EventReturns)
1317     {
1318         // // pay 3% out to community rewards
1319         uint256 _com = (_eth.mul(3)) / 100;
1320         uint256 _p3d;
1321         if (!address(admin).call.value(_com)())
1322         {
1323             _p3d = _com;
1324             _com = 0;
1325         }
1326 
1327 
1328         // pay p3d
1329         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1330         if (_p3d > 0)
1331         {
1332             round_[_rID].pot = round_[_rID].pot.add(_p3d);
1333 
1334             // set event data
1335             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1336         }
1337 
1338         return(_eventData_);
1339     }
1340 
1341     // function potSwap()
1342     //     external
1343     //     payable
1344     // {
1345     //     // setup local rID
1346     //     uint256 _rID = rID_ + 1;
1347 
1348     //     round_[_rID].pot = round_[_rID].pot.add(msg.value);
1349     //     emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1350     // }
1351 
1352     /**
1353      * @dev distributes eth based on fees to gen and pot
1354      */
1355     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1356         private
1357         returns(F3Ddatasets.EventReturns)
1358     {
1359         // calculate gen share
1360         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1361 
1362         // distribute share to affiliate 15%
1363         uint256 _aff = (_eth.mul(15)) / 100;
1364 
1365         // update eth balance (eth = eth - (com share + pot swap share + aff share))
1366         _eth = _eth.sub(((_eth.mul(18)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1367 
1368         // calculate pot
1369         uint256 _pot = _eth.sub(_gen);
1370 
1371         // decide what to do with affiliate share of fees
1372         // affiliate must not be self, and must have a name registered
1373         if (_affID != _pID && plyr_[_affID].name != '') {
1374             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1375             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1376         } else {
1377             _gen = _gen.add(_aff);
1378         }
1379 
1380         // distribute gen share (thats what updateMasks() does) and adjust
1381         // balances for dust.
1382         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1383         if (_dust > 0)
1384             _gen = _gen.sub(_dust);
1385 
1386         // add eth to pot
1387         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1388 
1389         // set up event data
1390         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1391         _eventData_.potAmount = _pot;
1392 
1393         return(_eventData_);
1394     }
1395 
1396     /**
1397      * @dev updates masks for round and player when keys are bought
1398      * @return dust left over 
1399      */
1400     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1401         private
1402         returns(uint256)
1403     {
1404         /* MASKING NOTES
1405             earnings masks are a tricky thing for people to wrap their minds around.
1406             the basic thing to understand here.  is were going to have a global
1407             tracker based on profit per share for each round, that increases in
1408             relevant proportion to the increase in share supply.
1409             
1410             the player will have an additional mask that basically says "based
1411             on the rounds mask, my shares, and how much i've already withdrawn,
1412             how much is still owed to me?"
1413         */
1414         
1415         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1416         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1417         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1418 
1419         // calculate player earning from their own buy (only based on the keys
1420         // they just bought).  & update player earnings mask
1421         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1422         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1423 
1424         // calculate and return dust
1425         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1426     }
1427 
1428     /**
1429      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1430      * @return earnings in wei format
1431      */
1432     function withdrawEarnings(uint256 _pID)
1433         private
1434         returns(uint256)
1435     {
1436         // update gen vault
1437         updateGenVault(_pID, plyr_[_pID].lrnd);
1438 
1439         // from vaults
1440         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1441         if (_earnings > 0)
1442         {
1443             plyr_[_pID].win = 0;
1444             plyr_[_pID].gen = 0;
1445             plyr_[_pID].aff = 0;
1446         }
1447 
1448         return(_earnings);
1449     }
1450 
1451      /**
1452      * @dev prepares compression data and fires event for buy or reload tx's
1453      */
1454     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1455         private
1456     {
1457         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1458         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1459 
1460         emit F3Devents.onEndTx
1461         (
1462             _eventData_.compressedData,
1463             _eventData_.compressedIDs,
1464             plyr_[_pID].name,
1465             msg.sender,
1466             _eth,
1467             _keys,
1468             _eventData_.winnerAddr,
1469             _eventData_.winnerName,
1470             _eventData_.amountWon,
1471             _eventData_.newPot,
1472             _eventData_.P3DAmount,
1473             _eventData_.genAmount,
1474             _eventData_.potAmount,
1475             airDropPot_
1476         );
1477     }
1478 //==============================================================================
1479 //    (~ _  _    _._|_    .
1480 //    _)(/_(_|_|| | | \/  .
1481 //====================/=========================================================
1482     /** upon contract deploy, it will be deactivated.  this is a one time
1483      * use function that will activate the contract.  we do this so devs 
1484      * have time to set things up on the web end                   **/
1485     bool public activated_ = false;
1486     function activate()
1487         public
1488     {
1489         // only admin  just can activate 
1490         require(msg.sender == admin, "only admin can activate");
1491 
1492 
1493         // can only be ran once
1494         require(activated_ == false, "FOMO Free already activated");
1495 
1496         // activate the contract
1497         activated_ = true;
1498 
1499         // let's start the first round
1500         rID_ = 1;
1501             round_[1].strt = now - rndGap_;
1502             round_[1].end = now + rndInit_ ;
1503     }
1504 }
1505 
1506 //==============================================================================
1507 //   __|_ _    __|_ _  .
1508 //  _\ | | |_|(_ | _\  .
1509 //==============================================================================
1510 library F3Ddatasets {
1511     //compressedData key
1512     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1513         // 0 - new player (bool)
1514         // 1 - joined round (bool)
1515         // 2 - new  leader (bool)
1516         // 3-5 - air drop tracker (uint 0-999)
1517         // 6-16 - round end time
1518         // 17 - winnerTeam
1519         // 18 - 28 timestamp 
1520         // 29 - team
1521         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1522         // 31 - airdrop happened bool
1523         // 32 - airdrop tier 
1524         // 33 - airdrop amount won
1525     //compressedIDs key
1526     // [77-52][51-26][25-0]
1527         // 0-25 - pID 
1528         // 26-51 - winPID
1529         // 52-77 - rID
1530     struct EventReturns {
1531         uint256 compressedData;
1532         uint256 compressedIDs;
1533         address winnerAddr;         // winner address
1534         bytes32 winnerName;         // winner name
1535         uint256 amountWon;          // amount won
1536         uint256 newPot;             // amount in new pot
1537         uint256 P3DAmount;          // amount distributed to p3d
1538         uint256 genAmount;          // amount distributed to gen
1539         uint256 potAmount;          // amount added to pot
1540      }
1541     struct Player {
1542         address addr;   // player address
1543         bytes32 name;   // player name
1544         uint256 win;    // winnings vault
1545         uint256 gen;    // general vault
1546         uint256 aff;    // affiliate vault
1547         uint256 lrnd;   // last round played
1548         uint256 laff;   // last affiliate id used
1549     }
1550     struct PlayerRounds {
1551         uint256 eth;    // eth player has added to round (used for eth limiter)
1552         uint256 keys;   // keys
1553         uint256 mask;   // player mask 
1554         uint256 ico;    // ICO phase investment
1555     }
1556     struct Round {
1557         uint256 plyr;   // pID of player in lead
1558         uint256 team;   // tID of team in lead
1559         uint256 end;    // time ends/ended
1560         bool ended;     // has round end function been ran
1561         uint256 strt;   // time round started
1562         uint256 keys;   // keys
1563         uint256 eth;    // total eth in
1564         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1565         uint256 mask;   // global mask
1566         uint256 ico;    // total eth sent in during ICO phase
1567         uint256 icoGen; // total eth for gen during ICO phase
1568         uint256 icoAvg; // average key price for ICO phase
1569     }
1570     struct TeamFee {
1571         uint256 gen;    // % of buy in thats paid to key holders of current round
1572         uint256 p3d;    // % of buy in thats paid to p3d holders
1573     }
1574     struct PotSplit {
1575         uint256 gen;    // % of pot thats paid to key holders of current round
1576         uint256 p3d;    // % of pot thats paid to p3d holders
1577     }
1578 }
1579 
1580 //==============================================================================
1581 //  |  _      _ _ | _  .
1582 //  |<(/_\/  (_(_||(_  .
1583 //=======/======================================================================
1584 library F3DKeysCalcShort {
1585     using SafeMath for *;
1586     /**
1587      * @dev calculates number of keys received given X eth 
1588      * @param _curEth current amount of eth in contract 
1589      * @param _newEth eth being spent
1590      * @return amount of ticket purchased
1591      */
1592     function keysRec(uint256 _curEth, uint256 _newEth)
1593         internal
1594         pure
1595         returns (uint256)
1596     {
1597         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1598     }
1599 
1600     /**
1601      * @dev calculates amount of eth received if you sold X keys 
1602      * @param _curKeys current amount of keys that exist 
1603      * @param _sellKeys amount of keys you wish to sell
1604      * @return amount of eth received
1605      */
1606     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1607         internal
1608         pure
1609         returns (uint256)
1610     {
1611         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1612     }
1613 
1614     /**
1615      * @dev calculates how many keys would exist with given an amount of eth
1616      * @param _eth eth "in contract"
1617      * @return number of keys that would exist
1618      */
1619     function keys(uint256 _eth)
1620         internal
1621         pure
1622         returns(uint256)
1623     {
1624         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1625     }
1626 
1627     /**
1628      * @dev calculates how much eth would be in contract given a number of keys
1629      * @param _keys number of keys "in contract" 
1630      * @return eth that would exists
1631      */
1632     function eth(uint256 _keys)
1633         internal
1634         pure
1635         returns(uint256)
1636     {
1637         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1638     }
1639 }
1640 
1641 //==============================================================================
1642 //  . _ _|_ _  _ |` _  _ _  _  .
1643 //  || | | (/_| ~|~(_|(_(/__\  .
1644 //==============================================================================
1645 
1646 interface PlayerBookInterface {
1647     function getPlayerID(address _addr) external returns (uint256);
1648     function getPlayerName(uint256 _pID) external view returns (bytes32);
1649     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1650     function getPlayerAddr(uint256 _pID) external view returns (address);
1651     function getNameFee() external view returns (uint256);
1652     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1653     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1654     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1655 }
1656 
1657 
1658 library NameFilter {
1659     /**
1660      * @dev filters name strings
1661      * -converts uppercase to lower case.  
1662      * -makes sure it does not start/end with a space
1663      * -makes sure it does not contain multiple spaces in a row
1664      * -cannot be only numbers
1665      * -cannot start with 0x 
1666      * -restricts characters to A-Z, a-z, 0-9, and space.
1667      * @return reprocessed string in bytes32 format
1668      */
1669     function nameFilter(string _input)
1670         internal
1671         pure
1672         returns(bytes32)
1673     {
1674         bytes memory _temp = bytes(_input);
1675         uint256 _length = _temp.length;
1676 
1677         //sorry limited to 32 characters
1678         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1679         // make sure it doesnt start with or end with space
1680         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1681         // make sure first two characters are not 0x
1682         if (_temp[0] == 0x30)
1683         {
1684             require(_temp[1] != 0x78, "string cannot start with 0x");
1685             require(_temp[1] != 0x58, "string cannot start with 0X");
1686         }
1687 
1688         // create a bool to track if we have a non number character
1689         bool _hasNonNumber;
1690         
1691         // convert & check
1692         for (uint256 i = 0; i < _length; i++)
1693         {
1694             // if its uppercase A-Z
1695             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1696             {
1697                 // convert to lower case a-z
1698                 _temp[i] = byte(uint(_temp[i]) + 32);
1699                 
1700                 // we have a non number
1701                 if (_hasNonNumber == false)
1702                     _hasNonNumber = true;
1703             } else {
1704                 require
1705                 (
1706                     // require character is a space
1707                     _temp[i] == 0x20 || 
1708                     // OR lowercase a-z
1709                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1710                     // or 0-9
1711                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1712                     "string contains invalid characters"
1713                 );
1714                 // make sure theres not 2x spaces in a row
1715                 if (_temp[i] == 0x20)
1716                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1717 
1718                  // see if we have a character other than a number
1719                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1720                     _hasNonNumber = true;
1721             }
1722         }
1723 
1724         require(_hasNonNumber == true, "string cannot be only numbers");
1725 
1726         bytes32 _ret;
1727         assembly {
1728             _ret := mload(add(_temp, 32))
1729         }
1730         return (_ret);
1731     }
1732 }
1733 
1734 /**
1735  * @title SafeMath v0.1.9
1736  * @dev Math operations with safety checks that throw on error
1737  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1738  * - added sqrt
1739  * - added sq
1740  * - added pwr 
1741  * - changed asserts to requires with error log outputs
1742  * - removed div, its useless
1743  */
1744 library SafeMath {
1745 
1746     /**
1747     * @dev Multiplies two numbers, throws on overflow.
1748     */
1749     function mul(uint256 a, uint256 b)
1750         internal
1751         pure
1752         returns (uint256 c)
1753     {
1754         if (a == 0) {
1755             return 0;
1756         }
1757         c = a * b;
1758         require(c / a == b, "SafeMath mul failed");
1759         return c;
1760     }
1761 
1762     /**
1763     *@dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend)
1764     */
1765     function sub(uint256 a, uint256 b)
1766         internal
1767         pure
1768         returns (uint256)
1769     {
1770         require(b <= a, "SafeMath sub failed");
1771         return a - b;
1772     }
1773 
1774     /**
1775     * @dev Adds two numbers, throws on overflow.
1776     */
1777     function add(uint256 a, uint256 b)
1778         internal
1779         pure
1780         returns (uint256 c) 
1781     {
1782         c = a + b;
1783         require(c >= a, "SafeMath add failed");
1784         return c;
1785     }
1786     
1787     /**
1788      * @dev gives square root of given x.
1789      */
1790     function sqrt(uint256 x)
1791         internal
1792         pure
1793         returns (uint256 y)
1794     {
1795         uint256 z = ((add(x,1)) / 2);
1796         y = x;
1797         while (z < y)
1798         {
1799             y = z;
1800             z = ((add((x / z),z)) / 2);
1801         }
1802     }
1803 
1804     /**
1805      * @dev gives square. multiplies x by x
1806      */
1807     function sq(uint256 x)
1808         internal
1809         pure
1810         returns (uint256)
1811     {
1812         return (mul(x,x));
1813     }
1814 
1815     /**
1816      * @dev x to the power of y 
1817      */
1818     function pwr(uint256 x, uint256 y)
1819         internal
1820         pure
1821         returns (uint256)
1822     {
1823         if (x==0)
1824             return (0);
1825         else if (y==0)
1826             return (1);
1827         else
1828         {
1829             uint256 z = x;
1830             for (uint256 i=1; i < y; i++)
1831                 z = mul(z,x);
1832             return (z);
1833         }
1834     }
1835 }