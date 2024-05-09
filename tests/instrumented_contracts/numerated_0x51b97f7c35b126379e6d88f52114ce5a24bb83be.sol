1 pragma solidity ^0.4.24;
2 
3 contract ExitScamsevents {
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
121 contract modularLong is ExitScamsevents {}
122 
123 contract ExitScams is modularLong {
124     using SafeMath for *;
125     using NameFilter for string;
126     using ExitScamsKeysCalcLong for uint256;
127 	
128     address private manager = msg.sender;
129     address private community1 = 0x28a52B6FB427cf299b67f68835c7A37Bf80db915;
130     address private community2 = 0x366b8C3Dd186A29dCaA9C148F39cdf741997A168;
131 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x1DD1EF4696B14C82eB199f7BB13F2f0059cb6382);
132 //==============================================================================
133 //     _ _  _  |`. _     _ _ |_ | _  _  .
134 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
135 //=================_|===========================================================
136     string constant public name = "Exit Scams";
137     string constant public symbol = "ES";
138     uint256 private rndExtra_ = 0;     // length of the very first ICO
139     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
140     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
141     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
142     uint256 constant private rndMax_ = 24 hours;                 // max length a round timer can be             // max length a round timer can be
143 //==============================================================================
144 //     _| _ _|_ _    _ _ _|_    _   .
145 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
146 //=============================|================================================
147 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
148     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
149     uint256 public rID_;    // round id number / total rounds that have happened
150 //****************
151 // PLAYER DATA 
152 //****************
153     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
154     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
155     mapping (uint256 => ExitScamsdatasets.Player) public plyr_;   // (pID => data) player data
156     mapping (uint256 => mapping (uint256 => ExitScamsdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
157     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
158 //****************
159 // ROUND DATA 
160 //****************
161     mapping (uint256 => ExitScamsdatasets.Round) public round_;   // (rID => data) round data
162     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
163 //****************
164 // TEAM FEE DATA 
165 //****************
166     mapping (uint256 => ExitScamsdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
167     mapping (uint256 => ExitScamsdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
168 //==============================================================================
169 //     _ _  _  __|_ _    __|_ _  _  .
170 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
171 //==============================================================================
172     constructor()
173         public
174     {
175 		// Team allocation structures
176         // 0 = whales
177         // 1 = bears
178         // 2 = sneks
179         // 3 = bulls
180 
181 		// Team allocation percentages
182         // (ExitScams, 0) + (Pot , Referrals, Community)
183             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
184         fees_[0] = ExitScamsdatasets.TeamFee(30,0);   //46% to pot, 20% to aff, 3.9% to com, 0.1% to air drop pot
185         fees_[1] = ExitScamsdatasets.TeamFee(43,0);   //33% to pot, 20% to aff, 3.9% to com, 0.1% to air drop pot
186         fees_[2] = ExitScamsdatasets.TeamFee(56,0);  //20% to pot, 20% to aff, 3.9% to com, 0.1% to air drop pot
187         fees_[3] = ExitScamsdatasets.TeamFee(43,0);   //33% to pot, 20% to aff, 3.9% to com, 0.1% to air drop pot
188         
189         // how to split up the final pot based on which team was picked
190         // (ExitScams, 0)
191         potSplit_[0] = ExitScamsdatasets.PotSplit(25,0);  //18% to winner, 35% to next round, 22% to com
192         potSplit_[1] = ExitScamsdatasets.PotSplit(30,0);   //18% to winner, 30% to next round, 22% to com
193         potSplit_[2] = ExitScamsdatasets.PotSplit(35,0);  //18% to winner, 25% to next round, 22% to com
194         potSplit_[3] = ExitScamsdatasets.PotSplit(40,0);  //18% to winner, 20% to next round, 22% to com
195 	}
196 //==============================================================================
197 //     _ _  _  _|. |`. _  _ _  .
198 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
199 //==============================================================================
200     /**
201      * @dev used to make sure no one can interact with contract until it has 
202      * been activated. 
203      */
204     modifier isActivated() {
205         require(activated_ == true, "its not ready yet.  "); 
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
230 //==============================================================================
231 //     _    |_ |. _   |`    _  __|_. _  _  _  .
232 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
233 //====|=========================================================================
234     /**
235      * @dev emergency buy uses last stored affiliate ID and team snek
236      */
237     function()
238         isActivated()
239         isHuman()
240         isWithinLimits(msg.value)
241         public
242         payable
243     {
244         // set up our tx event data and determine if player is new or not
245         ExitScamsdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
263         isActivated()
264         isHuman()
265         isWithinLimits(msg.value)
266         public
267         payable
268     {
269         // set up our tx event data and determine if player is new or not
270         ExitScamsdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
282         // if affiliate code was given & its not the same as previously stored 
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
296         isActivated()
297         isHuman()
298         isWithinLimits(msg.value)
299         public
300         payable
301     {
302         // set up our tx event data and determine if player is new or not
303         ExitScamsdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
316         // if affiliate code was given    
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
337         isActivated()
338         isHuman()
339         isWithinLimits(msg.value)
340         public
341         payable
342     {
343         // set up our tx event data and determine if player is new or not
344         ExitScamsdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
357         // if affiliate code was given
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
388         isActivated()
389         isHuman()
390         isWithinLimits(_eth)
391         public
392     {
393         // set up our tx event data
394         ExitScamsdatasets.EventReturns memory _eventData_;
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
406         // if affiliate code was given & its not the same as previously stored 
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
420         isActivated()
421         isHuman()
422         isWithinLimits(_eth)
423         public
424     {
425         // set up our tx event data
426         ExitScamsdatasets.EventReturns memory _eventData_;
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
439         // if affiliate code was given    
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
460         isActivated()
461         isHuman()
462         isWithinLimits(_eth)
463         public
464     {
465         // set up our tx event data
466         ExitScamsdatasets.EventReturns memory _eventData_;
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
479         // if affiliate code was given
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
504         isActivated()
505         isHuman()
506         public
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
524             ExitScamsdatasets.EventReturns memory _eventData_;
525             
526             // end the round (distributes pot)
527 			round_[_rID].ended = true;
528             _eventData_ = endRound(_eventData_);
529             
530 			// get their earnings
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
542             emit ExitScamsevents.onWithdrawAndDistribute
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
557         // in any other situation
558         } else {
559             // get their earnings
560             _eth = withdrawEarnings(_pID);
561             
562             // gib moni
563             if (_eth > 0)
564                 plyr_[_pID].addr.transfer(_eth);
565             
566             // fire withdraw event
567             emit ExitScamsevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
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
596         isHuman()
597         public
598         payable
599     {
600         bytes32 _name = _nameString.nameFilter();
601         address _addr = msg.sender;
602         uint256 _paid = msg.value;
603         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
604         
605         uint256 _pID = pIDxAddr_[_addr];
606         
607         // fire event
608         emit ExitScamsevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
609     }
610     
611     function registerNameXaddr(string _nameString, address _affCode, bool _all)
612         isHuman()
613         public
614         payable
615     {
616         bytes32 _name = _nameString.nameFilter();
617         address _addr = msg.sender;
618         uint256 _paid = msg.value;
619         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
620         
621         uint256 _pID = pIDxAddr_[_addr];
622         
623         // fire event
624         emit ExitScamsevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
625     }
626     
627     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
628         isHuman()
629         public
630         payable
631     {
632         bytes32 _name = _nameString.nameFilter();
633         address _addr = msg.sender;
634         uint256 _paid = msg.value;
635         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
636         
637         uint256 _pID = pIDxAddr_[_addr];
638         
639         // fire event
640         emit ExitScamsevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
641     }
642 //==============================================================================
643 //     _  _ _|__|_ _  _ _  .
644 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
645 //=====_|=======================================================================
646     /**
647      * @dev return the price buyer will pay for next 1 individual key.
648      * -functionhash- 0x018a25e8
649      * @return price for next key bought (in wei format)
650      */
651     function getBuyPrice()
652         public 
653         view 
654         returns(uint256)
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
676         public
677         view
678         returns(uint256)
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
703         public
704         view
705         returns(uint256 ,uint256, uint256)
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
718                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
719                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
720                     plyr_[_pID].aff
721                 );
722             // if player is not the winner
723             } else {
724                 return
725                 (
726                     plyr_[_pID].win,
727                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
728                     plyr_[_pID].aff
729                 );
730             }
731             
732         // if round is still going on, or round has ended and round end has been ran
733         } else {
734             return
735             (
736                 plyr_[_pID].win,
737                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
738                 plyr_[_pID].aff
739             );
740         }
741     }
742     
743     /**
744      * solidity hates stack limits.  this lets us avoid that hate 
745      */
746     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
747         private
748         view
749         returns(uint256)
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
773         public
774         view
775         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
776     {
777         // setup local rID
778         uint256 _rID = rID_;
779         
780         return
781         (
782             round_[_rID].ico,               //0
783             _rID,                           //1
784             round_[_rID].keys,              //2
785             round_[_rID].end,               //3
786             round_[_rID].strt,              //4
787             round_[_rID].pot,               //5
788             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
789             plyr_[round_[_rID].plyr].addr,  //7
790             plyr_[round_[_rID].plyr].name,  //8
791             rndTmEth_[_rID][0],             //9
792             rndTmEth_[_rID][1],             //10
793             rndTmEth_[_rID][2],             //11
794             rndTmEth_[_rID][3],             //12
795             airDropTracker_ + (airDropPot_ * 1000)              //13
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
813         public 
814         view 
815         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
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
828             _pID,                               //0
829             plyr_[_pID].name,                   //1
830             plyrRnds_[_pID][_rID].keys,         //2
831             plyr_[_pID].win,                    //3
832             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
833             plyr_[_pID].aff,                    //5
834             plyrRnds_[_pID][_rID].eth           //6
835         );
836     }
837 
838 //==============================================================================
839 //     _ _  _ _   | _  _ . _  .
840 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
841 //=====================_|=======================================================
842     /**
843      * @dev logic runs whenever a buy order is executed.  determines how to handle 
844      * incoming eth depending on if we are in an active round or not
845      */
846     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, ExitScamsdatasets.EventReturns memory _eventData_)
847         private
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
874                 // fire buy and distribute event 
875                 emit ExitScamsevents.onBuyAndDistribute
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
900     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, ExitScamsdatasets.EventReturns memory _eventData_)
901         private
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
920         // if round is not active and end round needs to be ran   
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
931             emit ExitScamsevents.onReLoadAndDistribute
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
951     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, ExitScamsdatasets.EventReturns memory _eventData_)
952         private
953     {
954         // if player is new to round
955         if (plyrRnds_[_pID][_rID].keys == 0)
956             _eventData_ = managePlayer(_pID, _eventData_);
957         
958         // if eth left is greater than min eth allowed (sorry no pocket lint)
959         if (_eth > 1000000000) 
960         {
961             
962             // mint the new keys
963             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
964             
965             // if they bought at least 1 whole key
966             if (_keys >= 1000000000000000000)
967             {
968             updateTimer(_keys, _rID);
969 
970             // set new leaders
971             if (round_[_rID].plyr != _pID)
972                 round_[_rID].plyr = _pID;  
973             if (round_[_rID].team != _team)
974                 round_[_rID].team = _team; 
975             
976             // set the new leader bool to true
977             _eventData_.compressedData = _eventData_.compressedData + 100;
978         }
979             
980             // manage airdrops
981             if (_eth >= 100000000000000000)
982             {
983             airDropTracker_++;
984             if (airdrop() == true)
985             {
986                 // gib muni
987                 uint256 _prize;
988                 if (_eth >= 10000000000000000000)
989                 {
990                     // calculate prize and give it to winner
991                     _prize = ((airDropPot_).mul(75)) / 100;
992                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
993                     
994                     // adjust airDropPot 
995                     airDropPot_ = (airDropPot_).sub(_prize);
996                     
997                     // let event know a tier 3 prize was won 
998                     _eventData_.compressedData += 300000000000000000000000000000000;
999                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1000                     // calculate prize and give it to winner
1001                     _prize = ((airDropPot_).mul(50)) / 100;
1002                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1003                     
1004                     // adjust airDropPot 
1005                     airDropPot_ = (airDropPot_).sub(_prize);
1006                     
1007                     // let event know a tier 2 prize was won 
1008                     _eventData_.compressedData += 200000000000000000000000000000000;
1009                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1010                     // calculate prize and give it to winner
1011                     _prize = ((airDropPot_).mul(25)) / 100;
1012                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1013                     
1014                     // adjust airDropPot 
1015                     airDropPot_ = (airDropPot_).sub(_prize);
1016                     
1017                     // let event know a tier 3 prize was won 
1018                     _eventData_.compressedData += 300000000000000000000000000000000;
1019                 }
1020                 // set airdrop happened bool to true
1021                 _eventData_.compressedData += 10000000000000000000000000000000;
1022                 // let event know how much was won 
1023                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1024                 
1025                 // reset air drop tracker
1026                 airDropTracker_ = 0;
1027             }
1028         }
1029     
1030             // store the air drop tracker number (number of buys since last airdrop)
1031             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1032             
1033             // update player 
1034             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1035             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1036             
1037             // update round
1038             round_[_rID].keys = _keys.add(round_[_rID].keys);
1039             round_[_rID].eth = _eth.add(round_[_rID].eth);
1040             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1041     
1042             // distribute eth
1043             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1044             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1045             
1046             // call end tx function to fire end tx event.
1047 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1048         }
1049     }
1050 //==============================================================================
1051 //     _ _ | _   | _ _|_ _  _ _  .
1052 //    (_(_||(_|_||(_| | (_)| _\  .
1053 //==============================================================================
1054     /**
1055      * @dev calculates unmasked earnings (just calculates, does not update mask)
1056      * @return earnings in wei format
1057      */
1058     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1059         private
1060         view
1061         returns(uint256)
1062     {
1063         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1064     }
1065     
1066     /** 
1067      * @dev returns the amount of keys you would get given an amount of eth. 
1068      * -functionhash- 0xce89c80c
1069      * @param _rID round ID you want price for
1070      * @param _eth amount of eth sent in 
1071      * @return keys received 
1072      */
1073     function calcKeysReceived(uint256 _rID, uint256 _eth)
1074         public
1075         view
1076         returns(uint256)
1077     {
1078         // grab time
1079         uint256 _now = now;
1080         
1081         // are we in a round?
1082         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1083             return ( (round_[_rID].eth).keysRec(_eth) );
1084         else // rounds over.  need keys for new round
1085             return ( (_eth).keys() );
1086     }
1087     
1088     /** 
1089      * @dev returns current eth price for X keys.  
1090      * -functionhash- 0xcf808000
1091      * @param _keys number of keys desired (in 18 decimal format)
1092      * @return amount of eth needed to send
1093      */
1094     function iWantXKeys(uint256 _keys)
1095         public
1096         view
1097         returns(uint256)
1098     {
1099         // setup local rID
1100         uint256 _rID = rID_;
1101         
1102         // grab time
1103         uint256 _now = now;
1104         
1105         // are we in a round?
1106         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1107             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1108         else // rounds over.  need price for new round
1109             return ( (_keys).eth() );
1110     }
1111 //==============================================================================
1112 //    _|_ _  _ | _  .
1113 //     | (_)(_)|_\  .
1114 //==============================================================================
1115     /**
1116 	 * @dev receives name/player info from names contract 
1117      */
1118     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1119         external
1120     {
1121         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1122         if (pIDxAddr_[_addr] != _pID)
1123             pIDxAddr_[_addr] = _pID;
1124         if (pIDxName_[_name] != _pID)
1125             pIDxName_[_name] = _pID;
1126         if (plyr_[_pID].addr != _addr)
1127             plyr_[_pID].addr = _addr;
1128         if (plyr_[_pID].name != _name)
1129             plyr_[_pID].name = _name;
1130         if (plyr_[_pID].laff != _laff)
1131             plyr_[_pID].laff = _laff;
1132         if (plyrNames_[_pID][_name] == false)
1133             plyrNames_[_pID][_name] = true;
1134     }
1135     
1136     /**
1137      * @dev receives entire player name list 
1138      */
1139     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1140         external
1141     {
1142         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1143         if(plyrNames_[_pID][_name] == false)
1144             plyrNames_[_pID][_name] = true;
1145     }   
1146         
1147     /**
1148      * @dev gets existing or registers new pID.  use this when a player may be new
1149      * @return pID 
1150      */
1151     function determinePID(ExitScamsdatasets.EventReturns memory _eventData_)
1152         private
1153         returns (ExitScamsdatasets.EventReturns)
1154     {
1155         uint256 _pID = pIDxAddr_[msg.sender];
1156         // if player is new to this version of fomo3d
1157         if (_pID == 0)
1158         {
1159             // grab their player ID, name and last aff ID, from player names contract 
1160             _pID = PlayerBook.getPlayerID(msg.sender);
1161             bytes32 _name = PlayerBook.getPlayerName(_pID);
1162             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1163             
1164             // set up player account 
1165             pIDxAddr_[msg.sender] = _pID;
1166             plyr_[_pID].addr = msg.sender;
1167             
1168             if (_name != "")
1169             {
1170                 pIDxName_[_name] = _pID;
1171                 plyr_[_pID].name = _name;
1172                 plyrNames_[_pID][_name] = true;
1173             }
1174             
1175             if (_laff != 0 && _laff != _pID)
1176                 plyr_[_pID].laff = _laff;
1177             
1178             // set the new player bool to true
1179             _eventData_.compressedData = _eventData_.compressedData + 1;
1180         } 
1181         return (_eventData_);
1182     }
1183     
1184     /**
1185      * @dev checks to make sure user picked a valid team.  if not sets team 
1186      * to default (sneks)
1187      */
1188     function verifyTeam(uint256 _team)
1189         private
1190         pure
1191         returns (uint256)
1192     {
1193         if (_team < 0 || _team > 3)
1194             return(2);
1195         else
1196             return(_team);
1197     }
1198     
1199     /**
1200      * @dev decides if round end needs to be run & new round started.  and if 
1201      * player unmasked earnings from previously played rounds need to be moved.
1202      */
1203     function managePlayer(uint256 _pID, ExitScamsdatasets.EventReturns memory _eventData_)
1204         private
1205         returns (ExitScamsdatasets.EventReturns)
1206     {
1207         // if player has played a previous round, move their unmasked earnings
1208         // from that round to gen vault.
1209         if (plyr_[_pID].lrnd != 0)
1210             updateGenVault(_pID, plyr_[_pID].lrnd);
1211             
1212         // update player's last round played
1213         plyr_[_pID].lrnd = rID_;
1214             
1215         // set the joined round bool to true
1216         _eventData_.compressedData = _eventData_.compressedData + 10;
1217         
1218         return(_eventData_);
1219     }
1220     
1221     /**
1222      * @dev ends the round. manages paying out winner/splitting up pot
1223      */
1224     function endRound(ExitScamsdatasets.EventReturns memory _eventData_)
1225         private
1226         returns (ExitScamsdatasets.EventReturns)
1227     {
1228         // setup local rID
1229         uint256 _rID = rID_;
1230         
1231         // grab our winning player and team id's
1232         uint256 _winPID = round_[_rID].plyr;
1233         uint256 _winTID = round_[_rID].team;
1234         
1235         // grab our pot amount
1236         uint256 _pot = round_[_rID].pot;
1237         
1238         // calculate our winner share, community rewards, gen share, 
1239         // p3d share, and amount reserved for next pot 
1240         uint256 _win = (_pot.mul(18)) / 100;
1241         uint256 _com = (_pot.mul(11) / 50);
1242         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1243         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1244         
1245         // calculate ppt for round mask
1246         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1247         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1248         if (_dust > 0)
1249         {
1250             _gen = _gen.sub(_dust);
1251             _res = _res.add(_dust);
1252         }
1253         
1254         // pay our winner
1255         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1256         
1257         // community rewards
1258         community1.transfer(_com/2);
1259         community2.transfer(_com/2);
1260         
1261         // distribute gen portion to key holders
1262         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1263         
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
1289         private 
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
1305         private
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
1330         private 
1331         view 
1332         returns(bool)
1333     {
1334         uint256 seed = uint256(keccak256(abi.encodePacked(
1335             
1336             (block.timestamp).add
1337             (block.difficulty).add
1338             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1339             (block.gaslimit).add
1340             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1341             (block.number)
1342             
1343         )));
1344         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1345             return(true);
1346         else
1347             return(false);
1348     }
1349 
1350     /**
1351      * @dev distributes eth based on fees to com, aff, and p3d
1352      */
1353     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, ExitScamsdatasets.EventReturns memory _eventData_)
1354         private
1355         returns(ExitScamsdatasets.EventReturns)
1356     {
1357         // pay 3.9% out to community rewards
1358         uint256 _com = _eth * 39 / 1000;
1359         
1360     
1361         
1362         // distribute share to affiliate
1363         uint256 _aff = _eth / 5;
1364         
1365         // decide what to do with affiliate share of fees
1366         // affiliate must not be self, and must have a name registered
1367         if (_affID != _pID && plyr_[_affID].name != '') {
1368             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1369             emit ExitScamsevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1370         } else {
1371             _com = _com.add(_aff);
1372         }
1373         community1.transfer(_com/2);
1374         community2.transfer(_com/2);
1375         
1376         return(_eventData_);
1377     }
1378     
1379     /**
1380      * @dev distributes eth based on fees to gen and pot
1381      */
1382     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, ExitScamsdatasets.EventReturns memory _eventData_)
1383         private
1384         returns(ExitScamsdatasets.EventReturns)
1385     {
1386         // calculate gen share
1387         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1388         
1389         // toss 0.1% into airdrop pot 
1390         uint256 _air = (_eth / 1000);
1391         airDropPot_ = airDropPot_.add(_air);
1392         
1393         // update eth balance (eth = eth - (com share + pot swap share + aff share + airdrop pot share))
1394         _eth = _eth.sub(((_eth.mul(24)) / 100));
1395         
1396         // calculate pot 
1397         uint256 _pot = _eth.sub(_gen);
1398         
1399         // distribute gen share (thats what updateMasks() does) and adjust
1400         // balances for dust.
1401         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1402         if (_dust > 0)
1403             _gen = _gen.sub(_dust);
1404         
1405         // add eth to pot
1406         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1407         
1408         // set up event data
1409         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1410         _eventData_.potAmount = _pot;
1411         
1412         return(_eventData_);
1413     }
1414 
1415     /**
1416      * @dev updates masks for round and player when keys are bought
1417      * @return dust left over 
1418      */
1419     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1420         private
1421         returns(uint256)
1422     {
1423         /* MASKING NOTES
1424             earnings masks are a tricky thing for people to wrap their minds around.
1425             the basic thing to understand here.  is were going to have a global
1426             tracker based on profit per share for each round, that increases in
1427             relevant proportion to the increase in share supply.
1428             
1429             the player will have an additional mask that basically says "based
1430             on the rounds mask, my shares, and how much i've already withdrawn,
1431             how much is still owed to me?"
1432         */
1433         
1434         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1435         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1436         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1437             
1438         // calculate player earning from their own buy (only based on the keys
1439         // they just bought).  & update player earnings mask
1440         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1441         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1442         
1443         // calculate & return dust
1444         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1445     }
1446     
1447     /**
1448      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1449      * @return earnings in wei format
1450      */
1451     function withdrawEarnings(uint256 _pID)
1452         private
1453         returns(uint256)
1454     {
1455         // update gen vault
1456         updateGenVault(_pID, plyr_[_pID].lrnd);
1457         
1458         // from vaults 
1459         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1460         if (_earnings > 0)
1461         {
1462             plyr_[_pID].win = 0;
1463             plyr_[_pID].gen = 0;
1464             plyr_[_pID].aff = 0;
1465         }
1466 
1467         return(_earnings);
1468     }
1469     
1470     /**
1471      * @dev prepares compression data and fires event for buy or reload tx's
1472      */
1473     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, ExitScamsdatasets.EventReturns memory _eventData_)
1474         private
1475     {
1476         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1477         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1478         
1479         emit ExitScamsevents.onEndTx
1480         (
1481             _eventData_.compressedData,
1482             _eventData_.compressedIDs,
1483             plyr_[_pID].name,
1484             msg.sender,
1485             _eth,
1486             _keys,
1487             _eventData_.winnerAddr,
1488             _eventData_.winnerName,
1489             _eventData_.amountWon,
1490             _eventData_.newPot,
1491             _eventData_.P3DAmount,
1492             _eventData_.genAmount,
1493             _eventData_.potAmount,
1494             airDropPot_
1495         );
1496     }
1497 //==============================================================================
1498 //    (~ _  _    _._|_    .
1499 //    _)(/_(_|_|| | | \/  .
1500 //====================/=========================================================
1501     /** upon contract deploy, it will be deactivated.  this is a one time
1502      * use function that will activate the contract.  we do this so devs 
1503      * have time to set things up on the web end                            **/
1504     bool public activated_ = false;
1505     function activate()
1506         public
1507     {
1508         // only team manager can activate 
1509         require(
1510             msg.sender == manager, "only manager can activate"
1511         );
1512 
1513         
1514         // can only be ran once
1515         require(activated_ == false, "Game already activated");
1516         
1517         // activate the contract 
1518         activated_ = true;
1519         
1520         // lets start first round
1521 		rID_ = 1;
1522         round_[1].strt = now + rndExtra_ - rndGap_;
1523         round_[1].end = now + rndInit_ + rndExtra_;
1524     }
1525 }
1526 
1527 //==============================================================================
1528 //   __|_ _    __|_ _  .
1529 //  _\ | | |_|(_ | _\  .
1530 //==============================================================================
1531 library ExitScamsdatasets {
1532     //compressedData key
1533     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1534         // 0 - new player (bool)
1535         // 1 - joined round (bool)
1536         // 2 - new  leader (bool)
1537         // 3-5 - air drop tracker (uint 0-999)
1538         // 6-16 - round end time
1539         // 17 - winnerTeam
1540         // 18 - 28 timestamp 
1541         // 29 - team
1542         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1543         // 31 - airdrop happened bool
1544         // 32 - airdrop tier 
1545         // 33 - airdrop amount won
1546     //compressedIDs key
1547     // [77-52][51-26][25-0]
1548         // 0-25 - pID 
1549         // 26-51 - winPID
1550         // 52-77 - rID
1551     struct EventReturns {
1552         uint256 compressedData;
1553         uint256 compressedIDs;
1554         address winnerAddr;         // winner address
1555         bytes32 winnerName;         // winner name
1556         uint256 amountWon;          // amount won
1557         uint256 newPot;             // amount in new pot
1558         uint256 P3DAmount;          // amount distributed to p3d
1559         uint256 genAmount;          // amount distributed to gen
1560         uint256 potAmount;          // amount added to pot
1561     }
1562     struct Player {
1563         address addr;   // player address
1564         bytes32 name;   // player name
1565         uint256 win;    // winnings vault
1566         uint256 gen;    // general vault
1567         uint256 aff;    // affiliate vault
1568         uint256 lrnd;   // last round played
1569         uint256 laff;   // last affiliate id used
1570     }
1571     struct PlayerRounds {
1572         uint256 eth;    // eth player has added to round (used for eth limiter)
1573         uint256 keys;   // keys
1574         uint256 mask;   // player mask 
1575         uint256 ico;    // ICO phase investment
1576     }
1577     struct Round {
1578         uint256 plyr;   // pID of player in lead
1579         uint256 team;   // tID of team in lead
1580         uint256 end;    // time ends/ended
1581         bool ended;     // has round end function been ran
1582         uint256 strt;   // time round started
1583         uint256 keys;   // keys
1584         uint256 eth;    // total eth in
1585         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1586         uint256 mask;   // global mask
1587         uint256 ico;    // total eth sent in during ICO phase
1588         uint256 icoGen; // total eth for gen during ICO phase
1589         uint256 icoAvg; // average key price for ICO phase
1590     }
1591     struct TeamFee {
1592         uint256 gen;    // % of buy in thats paid to key holders of current round
1593         uint256 p3d;    // % of buy in thats paid to p3d holders
1594     }
1595     struct PotSplit {
1596         uint256 gen;    // % of pot thats paid to key holders of current round
1597         uint256 p3d;    // % of pot thats paid to p3d holders
1598     }
1599 }
1600 
1601 //==============================================================================
1602 //  |  _      _ _ | _  .
1603 //  |<(/_\/  (_(_||(_  .
1604 //=======/======================================================================
1605 library ExitScamsKeysCalcLong {
1606     using SafeMath for *;
1607     /**
1608      * @dev calculates number of keys received given X eth 
1609      * @param _curEth current amount of eth in contract 
1610      * @param _newEth eth being spent
1611      * @return amount of ticket purchased
1612      */
1613     function keysRec(uint256 _curEth, uint256 _newEth)
1614         internal
1615         pure
1616         returns (uint256)
1617     {
1618         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1619     }
1620     
1621     /**
1622      * @dev calculates amount of eth received if you sold X keys 
1623      * @param _curKeys current amount of keys that exist 
1624      * @param _sellKeys amount of keys you wish to sell
1625      * @return amount of eth received
1626      */
1627     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1628         internal
1629         pure
1630         returns (uint256)
1631     {
1632         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1633     }
1634 
1635     /**
1636      * @dev calculates how many keys would exist with given an amount of eth
1637      * @param _eth eth "in contract"
1638      * @return number of keys that would exist
1639      */
1640     function keys(uint256 _eth) 
1641         internal
1642         pure
1643         returns(uint256)
1644     {
1645         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1646     }
1647     
1648     /**
1649      * @dev calculates how much eth would be in contract given a number of keys
1650      * @param _keys number of keys "in contract" 
1651      * @return eth that would exists
1652      */
1653     function eth(uint256 _keys) 
1654         internal
1655         pure
1656         returns(uint256)  
1657     {
1658         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1659     }
1660 }
1661 
1662 //==============================================================================
1663 //  . _ _|_ _  _ |` _  _ _  _  .
1664 //  || | | (/_| ~|~(_|(_(/__\  .
1665 //==============================================================================
1666 
1667 interface PlayerBookInterface {
1668     function getPlayerID(address _addr) external returns (uint256);
1669     function getPlayerName(uint256 _pID) external view returns (bytes32);
1670     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1671     function getPlayerAddr(uint256 _pID) external view returns (address);
1672     function getNameFee() external view returns (uint256);
1673     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1674     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1675     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1676 }
1677 
1678 
1679 library NameFilter {
1680     /**
1681      * @dev filters name strings
1682      * -converts uppercase to lower case.  
1683      * -makes sure it does not start/end with a space
1684      * -makes sure it does not contain multiple spaces in a row
1685      * -cannot be only numbers
1686      * -cannot start with 0x 
1687      * -restricts characters to A-Z, a-z, 0-9, and space.
1688      * @return reprocessed string in bytes32 format
1689      */
1690     function nameFilter(string _input)
1691         internal
1692         pure
1693         returns(bytes32)
1694     {
1695         bytes memory _temp = bytes(_input);
1696         uint256 _length = _temp.length;
1697         
1698         //sorry limited to 32 characters
1699         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1700         // make sure it doesnt start with or end with space
1701         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1702         // make sure first two characters are not 0x
1703         if (_temp[0] == 0x30)
1704         {
1705             require(_temp[1] != 0x78, "string cannot start with 0x");
1706             require(_temp[1] != 0x58, "string cannot start with 0X");
1707         }
1708         
1709         // create a bool to track if we have a non number character
1710         bool _hasNonNumber;
1711         
1712         // convert & check
1713         for (uint256 i = 0; i < _length; i++)
1714         {
1715             // if its uppercase A-Z
1716             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1717             {
1718                 // convert to lower case a-z
1719                 _temp[i] = byte(uint(_temp[i]) + 32);
1720                 
1721                 // we have a non number
1722                 if (_hasNonNumber == false)
1723                     _hasNonNumber = true;
1724             } else {
1725                 require
1726                 (
1727                     // require character is a space
1728                     _temp[i] == 0x20 || 
1729                     // OR lowercase a-z
1730                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1731                     // or 0-9
1732                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1733                     "string contains invalid characters"
1734                 );
1735                 // make sure theres not 2x spaces in a row
1736                 if (_temp[i] == 0x20)
1737                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1738                 
1739                 // see if we have a character other than a number
1740                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1741                     _hasNonNumber = true;    
1742             }
1743         }
1744         
1745         require(_hasNonNumber == true, "string cannot be only numbers");
1746         
1747         bytes32 _ret;
1748         assembly {
1749             _ret := mload(add(_temp, 32))
1750         }
1751         return (_ret);
1752     }
1753 }
1754 
1755 /**
1756  * @title SafeMath v0.1.9
1757  * @dev Math operations with safety checks that throw on error
1758  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1759  * - added sqrt
1760  * - added sq
1761  * - added pwr 
1762  * - changed asserts to requires with error log outputs
1763  * - removed div, its useless
1764  */
1765 library SafeMath {
1766     
1767     /**
1768     * @dev Multiplies two numbers, throws on overflow.
1769     */
1770     function mul(uint256 a, uint256 b) 
1771         internal 
1772         pure 
1773         returns (uint256 c) 
1774     {
1775         if (a == 0) {
1776             return 0;
1777         }
1778         c = a * b;
1779         require(c / a == b, "SafeMath mul failed");
1780         return c;
1781     }
1782 
1783     /**
1784     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1785     */
1786     function sub(uint256 a, uint256 b)
1787         internal
1788         pure
1789         returns (uint256) 
1790     {
1791         require(b <= a, "SafeMath sub failed");
1792         return a - b;
1793     }
1794 
1795     /**
1796     * @dev Adds two numbers, throws on overflow.
1797     */
1798     function add(uint256 a, uint256 b)
1799         internal
1800         pure
1801         returns (uint256 c) 
1802     {
1803         c = a + b;
1804         require(c >= a, "SafeMath add failed");
1805         return c;
1806     }
1807     
1808     /**
1809      * @dev gives square root of given x.
1810      */
1811     function sqrt(uint256 x)
1812         internal
1813         pure
1814         returns (uint256 y) 
1815     {
1816         uint256 z = ((add(x,1)) / 2);
1817         y = x;
1818         while (z < y) 
1819         {
1820             y = z;
1821             z = ((add((x / z),z)) / 2);
1822         }
1823     }
1824     
1825     /**
1826      * @dev gives square. multiplies x by x
1827      */
1828     function sq(uint256 x)
1829         internal
1830         pure
1831         returns (uint256)
1832     {
1833         return (mul(x,x));
1834     }
1835     
1836     /**
1837      * @dev x to the power of y 
1838      */
1839     function pwr(uint256 x, uint256 y)
1840         internal 
1841         pure 
1842         returns (uint256)
1843     {
1844         if (x==0)
1845             return (0);
1846         else if (y==0)
1847             return (1);
1848         else 
1849         {
1850             uint256 z = x;
1851             for (uint256 i=1; i < y; i++)
1852                 z = mul(z,x);
1853             return (z);
1854         }
1855     }
1856 }