1 pragma solidity ^0.4.24;
2  
3 contract Star3Devents {
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
31         uint256 genAmount,
32         uint256 potAmount
33     );
34 
35 	// fired whenever theres a withdraw
36     event onWithdraw
37     (
38         uint256 indexed playerID,
39         address playerAddress,
40         bytes32 playerName,
41         uint256 ethOut,
42         uint256 timeStamp
43     );
44 
45     // fired whenever a withdraw forces end round to be ran
46     event onWithdrawAndDistribute
47     (
48         address playerAddress,
49         bytes32 playerName,
50         uint256 ethOut,
51         uint256 compressedData,
52         uint256 compressedIDs,
53         address winnerAddr,
54         bytes32 winnerName,
55         uint256 amountWon,
56         uint256 newPot,
57         uint256 genAmount
58     );
59 
60     // (fomo3d long only) fired whenever a player tries a buy after round timer
61     // hit zero, and causes end round to be ran.
62     event onBuyAndDistribute
63     (
64         address playerAddress,
65         bytes32 playerName,
66         uint256 ethIn,
67         uint256 compressedData,
68         uint256 compressedIDs,
69         address winnerAddr,
70         bytes32 winnerName,
71         uint256 amountWon,
72         uint256 newPot,
73         uint256 genAmount
74     );
75 
76     // (fomo3d long only) fired whenever a player tries a reload after round timer
77     // hit zero, and causes end round to be ran.
78     event onReLoadAndDistribute
79     (
80         address playerAddress,
81         bytes32 playerName,
82         uint256 compressedData,
83         uint256 compressedIDs,
84         address winnerAddr,
85         bytes32 winnerName,
86         uint256 amountWon,
87         uint256 newPot,
88         uint256 genAmount
89     );
90 
91     // fired whenever an affiliate is paid
92     event onAffiliatePayout
93     (
94         uint256 indexed affiliateID,
95         address affiliateAddress,
96         bytes32 affiliateName,
97         uint256 indexed roundID,
98         uint256 indexed buyerID,
99         uint256 amount,
100         uint256 timeStamp
101     );
102 
103     // received pot swap deposit
104     event onPotSwapDeposit
105     (
106         uint256 roundID,
107         uint256 amountAddedToPot
108     );
109 }
110 
111 interface CompanyShareInterface {
112     function deposit() external payable;
113 }
114 
115 //==============================================================================
116 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
117 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
118 //====================================|=========================================
119 
120 contract modularLong is Star3Devents { uint codeLength=0;}
121 
122 contract Star3Dlong is modularLong {
123     using SafeMath for *;
124     using NameFilter for string;
125     using Star3DKeysCalcLong for uint256;
126 
127     address public admin;
128 //==============================================================================
129 //     _ _  _  |`. _     _ _ |_ | _  _  .
130 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
131 //=================_|===========================================================
132     string constant public name = "Save the planet";
133     string constant public symbol = "Star";
134     CompanyShareInterface constant private CompanyShare = CompanyShareInterface(0x9d9d35ffd945be6e1a75e975fd696ac4736e65c8);
135     
136     uint256 private pID_ = 0;   // total number of players
137 	uint256 private rndExtra_ = 0 hours;     // length of the very first ICO
138     uint256 private rndGap_ = 0 seconds;         // length of ICO phase, set to 1 year for EOS.
139     uint256 constant private rndInit_ = 10 hours;                     // round timer starts at this
140     uint256 constant private rndInc_ = 30 seconds;               // every full key purchased adds this much to the timer
141     uint256 constant private rndMax_ = 24 hours;                     // max length a round timer can be
142     uint256 public registrationFee_ = 10 finney;               // price to register a name
143 
144 //==============================================================================
145 //     _| _ _|_ _    _ _ _|_    _   .
146 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
147 //=============================|================================================
148 //	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
149 //    uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
150     uint256 public rID_;    // round id number / total rounds that have happened
151 //****************
152 // PLAYER DATA 
153 //****************
154     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
155     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
156     mapping (uint256 => Star3Ddatasets.Player) public plyr_;   // (pID => data) player data
157     mapping (uint256 => mapping (uint256 => Star3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
158     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
159 //****************
160 // ROUND DATA
161 //****************
162     mapping (uint256 => Star3Ddatasets.Round) public round_;   // (rID => data) round data
163     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
164 //****************
165 // TEAM FEE DATA
166 //****************
167     mapping (uint256 => Star3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
168     mapping (uint256 => Star3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
169 //==============================================================================
170 //     _ _  _  __|_ _    __|_ _  _  .
171 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
172 //==============================================================================
173     constructor()
174         public
175     {
176         admin = msg.sender;
177 		// Team allocation structures
178         // 0 = whales
179         // 1 = bears
180         // 2 = sneks
181         // 3 = bulls
182 
183 		// Team allocation percentages
184         // (Star, None) + (Pot , Referrals, Community)
185             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
186         fees_[0] = Star3Ddatasets.TeamFee(32, 45, 10, 3);   //32% to pot, 56% to gen, 2% to dev, 48% to winner, 10% aff 3% affLeader
187         fees_[1] = Star3Ddatasets.TeamFee(45, 32, 10, 3);   //45% to pot, 35% to gen, 2% to dev, 48% to winner, 10% aff 3% affLeader
188         fees_[2] = Star3Ddatasets.TeamFee(50, 27, 10, 3);  //50% to pot, 30% to gen, 2% to dev, 48% to winner, 10% aff 3% affLeader
189         fees_[3] = Star3Ddatasets.TeamFee(40, 37, 10, 3);   //48% to pot, 40% to gen, 2% to dev, 48% to winner, 10% aff 3% affLeader
190 
191 //        // how to split up the final pot based on which team was picked
192 //        // (Star, None)
193         potSplit_[0] = Star3Ddatasets.PotSplit(20, 30);  //48% to winner, 20% to next round, 30% to gen, 2% to com
194         potSplit_[1] = Star3Ddatasets.PotSplit(15, 35);   //48% to winner, 15% to next round, 35% to gen, 2% to com
195         potSplit_[2] = Star3Ddatasets.PotSplit(25, 25);  //48% to winner, 25% to next round, 25% to gen, 2% to com
196         potSplit_[3] = Star3Ddatasets.PotSplit(30, 20);  //48% to winner, 30% to next round, 20% to gen, 2% to com
197 	}
198 //==============================================================================
199 //     _ _  _  _|. |`. _  _ _  .
200 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
201 //==============================================================================
202     /**
203      * @dev used to make sure no one can interact with contract until it has
204      * been activated.
205      */
206     modifier isActivated() {
207         require(activated_ == true, "its not ready yet.  check ?eta in discord");
208         _;
209     }
210 
211     modifier isRegisteredName()
212     {
213         uint256 _pID = pIDxAddr_[msg.sender];
214         require(plyr_[_pID].name == "" || _pID == 0, "already has name");
215         _;
216     }
217     /**
218      * @dev prevents contracts from interacting with fomo3d
219      */
220     modifier isHuman() {
221         address _addr = msg.sender;
222         uint256 _codeLength;
223 
224         assembly {_codeLength := extcodesize(_addr)}
225         require(codeLength == 0, "sorry humans only");
226         _;
227     }
228 
229     /**
230      * @dev sets boundaries for incoming tx
231      */
232     modifier isWithinLimits(uint256 _eth) {
233         require(_eth >= 1000000000, "pocket lint: not a valid currency");
234         require(_eth <= 100000000000000000000000, "no vitalik, no");
235         _;
236     }
237 
238 //==============================================================================
239 //     _    |_ |. _   |`    _  __|_. _  _  _  .
240 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
241 //====|=========================================================================
242     /**
243      * @dev emergency buy uses last stored affiliate ID and team snek
244      */
245     function()
246         isActivated()
247         isHuman()
248         isWithinLimits(msg.value)
249         public
250         payable
251     {
252         // set up our tx event data and determine if player is new or not
253         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
254 
255         // fetch player id
256         uint256 _pID = pIDxAddr_[msg.sender];
257 
258         // buy core
259         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
260     }
261 
262     /**
263      * @dev converts all incoming ethereum to keys.
264      * -functionhash- 0x8f38f309 (using ID for affiliate)
265      * -functionhash- 0x98a0871d (using address for affiliate)
266      * -functionhash- 0xa65b37a1 (using name for affiliate)
267      * @param _affCode the ID/address/name of the player who gets the affiliate fee
268      * @param _team what team is the player playing for?
269      */
270     function buyXid(uint256 _affCode, uint256 _team)
271         isActivated()
272         isHuman()
273         isWithinLimits(msg.value)
274         public
275         payable
276     {
277         // set up our tx event data and determine if player is new or not
278         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
279 
280         // fetch player id
281         uint256 _pID = pIDxAddr_[msg.sender];
282 
283         // manage affiliate residuals
284         // if no affiliate code was given or player tried to use their own, lolz
285         if (_affCode == 0 || _affCode == _pID)
286         {
287             // use last stored affiliate code
288             _affCode = plyr_[_pID].laff;
289 
290         // if affiliate code was given & its not the same as previously stored
291         } else if (_affCode != plyr_[_pID].laff) {
292             // update last affiliate
293             plyr_[_pID].laff = _affCode;
294         }
295 
296         // verify a valid team was selected
297         _team = verifyTeam(_team);
298 
299         // buy core
300         buyCore(_pID, _affCode, _team, _eventData_);
301     }
302 
303     function buyXaddr(address _affCode, uint256 _team)
304         isActivated()
305         isHuman()
306         isWithinLimits(msg.value)
307         public
308         payable
309     {
310         // set up our tx event data and determine if player is new or not
311         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
312 
313         // fetch player id
314         uint256 _pID = pIDxAddr_[msg.sender];
315 
316         // verify a valid team was selected
317         _team = verifyTeam(_team);
318         // manage affiliate residuals
319         uint256 _affID;
320         // if no affiliate code was given or player tried to use their own, lolz
321         if (_affCode == address(0) || _affCode == msg.sender)
322         {
323             // use last stored affiliate code
324             _affID = plyr_[_pID].laff;
325 
326         // if affiliate code was given
327         } else {
328             // get affiliate ID from aff Code
329             _affID = pIDxAddr_[_affCode];
330 
331             // if affID is not the same as previously stored
332             if (_affID != plyr_[_pID].laff)
333             {
334                 // update last affiliate
335                 plyr_[_pID].laff = _affID;
336             }
337         }
338         // buy core
339         buyCore(_pID, _affID, _team, _eventData_);
340     }
341 
342     function buyXname(bytes32 _affCode, uint256 _team)
343         isActivated()
344         isHuman()
345         isWithinLimits(msg.value)
346         public
347         payable
348     {
349         // set up our tx event data and determine if player is new or not
350         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
351 
352         // fetch player id
353         uint256 _pID = pIDxAddr_[msg.sender];
354 
355         // manage affiliate residuals
356         uint256 _affID;
357         // if no affiliate code was given or player tried to use their own, lolz
358         if (_affCode == '' || _affCode == plyr_[_pID].name)
359         {
360             // use last stored affiliate code
361             _affID = plyr_[_pID].laff;
362 
363         // if affiliate code was given
364         } else {
365             // get affiliate ID from aff Code
366             _affID = pIDxName_[_affCode];
367 
368             // if affID is not the same as previously stored
369             if (_affID != plyr_[_pID].laff)
370             {
371                 // update last affiliate
372                 plyr_[_pID].laff = _affID;
373             }
374         }
375 
376         // verify a valid team was selected
377         _team = verifyTeam(_team);
378 
379         // buy core
380         buyCore(_pID, _affID, _team, _eventData_);
381     }
382 
383     /**
384      * @dev essentially the same as buy, but instead of you sending ether
385      * from your wallet, it uses your unwithdrawn earnings.
386      * -functionhash- 0x349cdcac (using ID for affiliate)
387      * -functionhash- 0x82bfc739 (using address for affiliate)
388      * -functionhash- 0x079ce327 (using name for affiliate)
389      * @param _affCode the ID/address/name of the player who gets the affiliate fee
390      * @param _team what team is the player playing for?
391      * @param _eth amount of earnings to use (remainder returned to gen vault)
392      */
393     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
394         isActivated()
395         isHuman()
396         isWithinLimits(_eth)
397         public
398     {
399         // set up our tx event data
400         Star3Ddatasets.EventReturns memory _eventData_;
401 
402         // fetch player ID
403         uint256 _pID = pIDxAddr_[msg.sender];
404 
405         // manage affiliate residuals
406         // if no affiliate code was given or player tried to use their own, lolz
407         if (_affCode == 0 || _affCode == _pID)
408         {
409             // use last stored affiliate code
410             _affCode = plyr_[_pID].laff;
411 
412         // if affiliate code was given & its not the same as previously stored
413         } else if (_affCode != plyr_[_pID].laff) {
414             // update last affiliate
415             plyr_[_pID].laff = _affCode;
416         }
417 
418         // verify a valid team was selected
419         _team = verifyTeam(_team);
420 
421         // reload core
422         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
423     }
424 
425     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
426         isActivated()
427         isHuman()
428         isWithinLimits(_eth)
429         public
430     {
431         // set up our tx event data
432         Star3Ddatasets.EventReturns memory _eventData_;
433 
434         // fetch player ID
435         uint256 _pID = pIDxAddr_[msg.sender];
436 
437         // manage affiliate residuals
438         uint256 _affID;
439         // if no affiliate code was given or player tried to use their own, lolz
440         if (_affCode == address(0) || _affCode == msg.sender)
441         {
442             // use last stored affiliate code
443             _affID = plyr_[_pID].laff;
444 
445         // if affiliate code was given
446         } else {
447             // get affiliate ID from aff Code
448             _affID = pIDxAddr_[_affCode];
449 
450             // if affID is not the same as previously stored
451             if (_affID != plyr_[_pID].laff)
452             {
453                 // update last affiliate
454                 plyr_[_pID].laff = _affID;
455             }
456         }
457 
458         // verify a valid team was selected
459         _team = verifyTeam(_team);
460 
461         // reload core
462         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
463     }
464 
465     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
466         isActivated()
467         isHuman()
468         isWithinLimits(_eth)
469         public
470     {
471         // set up our tx event data
472         Star3Ddatasets.EventReturns memory _eventData_;
473 
474         // fetch player ID
475         uint256 _pID = pIDxAddr_[msg.sender];
476 
477         // manage affiliate residuals
478         uint256 _affID;
479         // if no affiliate code was given or player tried to use their own, lolz
480         if (_affCode == '' || _affCode == plyr_[_pID].name)
481         {
482             // use last stored affiliate code
483             _affID = plyr_[_pID].laff;
484 
485         // if affiliate code was given
486         } else {
487             // get affiliate ID from aff Code
488             _affID = pIDxName_[_affCode];
489 
490             // if affID is not the same as previously stored
491             if (_affID != plyr_[_pID].laff)
492             {
493                 // update last affiliate
494                 plyr_[_pID].laff = _affID;
495             }
496         }
497 
498         // verify a valid team was selected
499         _team = verifyTeam(_team);
500 
501         // reload core
502         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
503     }
504 
505     /**
506      * @dev withdraws all of your earnings.
507      * -functionhash- 0x3ccfd60b
508      */
509     function withdraw()
510         isActivated()
511         isHuman()
512         public
513     {
514         // setup local rID
515         uint256 _rID = rID_;
516 
517         // grab time
518         uint256 _now = now;
519 
520         // fetch player ID
521         uint256 _pID = pIDxAddr_[msg.sender];
522 
523         // setup temp var for player eth
524         uint256 _eth;
525 
526         // check to see if round has ended and no one has run round end yet
527         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
528         {
529             // set up our tx event data
530             Star3Ddatasets.EventReturns memory _eventData_;
531 
532             // end the round (distributes pot)
533 			round_[_rID].ended = true;
534             _eventData_ = endRound(_eventData_);
535 
536 			// get their earnings
537             _eth = withdrawEarnings(_pID);
538 
539             // gib moni
540             if (_eth > 0)
541                 plyr_[_pID].addr.transfer(_eth);
542 
543             // build event data
544             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
545             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
546 
547             // fire withdraw and distribute event
548             emit Star3Devents.onWithdrawAndDistribute
549             (
550                 msg.sender,
551                 plyr_[_pID].name,
552                 _eth,
553                 _eventData_.compressedData,
554                 _eventData_.compressedIDs,
555                 _eventData_.winnerAddr,
556                 _eventData_.winnerName,
557                 _eventData_.amountWon,
558                 _eventData_.newPot,
559                 _eventData_.genAmount
560             );
561 
562         // in any other situation
563         } else {
564             // get their earnings
565             _eth = withdrawEarnings(_pID);
566 
567             // gib moni
568             if (_eth > 0)
569                 plyr_[_pID].addr.transfer(_eth);
570 
571             // fire withdraw event
572             emit Star3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
573         }
574     }
575 
576 
577     /**
578      * @dev use these to register names.  they are just wrappers that will send the
579      * registration requests to the PlayerBook contract.  So registering here is the
580      * same as registering there.  UI will always display the last name you registered.
581      * but you will still own all previously registered names to use as affiliate
582      * links.
583      * - must pay a registration fee.
584      * - name must be unique
585      * - names will be converted to lowercase
586      * - name cannot start or end with a space
587      * - cannot have more than 1 space in a row
588      * - cannot be only numbers
589      * - cannot start with 0x
590      * - name must be at least 1 char
591      * - max length of 32 characters long
592      * - allowed characters: a-z, 0-9, and space
593      * -functionhash- 0x921dec21 (using ID for affiliate)
594      * -functionhash- 0x3ddd4698 (using address for affiliate)
595      * -functionhash- 0x685ffd83 (using name for affiliate)
596      * @param _nameString players desired name
597      * @param _affCode affiliate ID, address, or name of who referred you
598      * (this might cost a lot of gas)
599      */
600     function registerNameXID(string _nameString, uint256 _affCode)
601         isHuman()
602         isRegisteredName()
603         public
604         payable
605     {
606         bytes32 _name = _nameString.nameFilter();
607         address _addr = msg.sender;
608         uint256 _paid = msg.value;
609 
610         bool _isNewPlayer = isNewPlayer(_addr);
611         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
612 
613         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
614 
615         uint256 _pID = makePlayerID(msg.sender);
616         uint256 _affID = _affCode;
617         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
618         {
619             // update last affiliate
620             plyr_[_pID].laff = _affID;
621         } else if (_affID == _pID) {
622             _affID = 0;
623         }
624         registerNameCore(_pID, _name);
625         // fire event
626         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
627     }
628 
629     function registerNameXaddr(string _nameString, address _affCode)
630         isHuman()
631         isRegisteredName()
632         public
633         payable
634     {
635         bytes32 _name = _nameString.nameFilter();
636         address _addr = msg.sender;
637         uint256 _paid = msg.value;
638 
639         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
640 
641         bool _isNewPlayer = isNewPlayer(_addr);
642 
643         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
644 
645         uint256 _pID = makePlayerID(msg.sender);
646         uint256 _affID;
647         if (_affCode != address(0) && _affCode != _addr)
648         {
649             // get affiliate ID from aff Code
650             _affID = pIDxAddr_[_affCode];
651 
652             // if affID is not the same as previously stored
653             if (_affID != plyr_[_pID].laff)
654             {
655                 // update last affiliate
656                 plyr_[_pID].laff = _affID;
657             }
658         }
659 
660         registerNameCore(_pID, _name);
661         // fire event
662         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
663     }
664 
665     function registerNameXname(string _nameString, bytes32 _affCode)
666         isHuman()
667         isRegisteredName()
668         public
669         payable
670     {
671         bytes32 _name = _nameString.nameFilter();
672         address _addr = msg.sender;
673         uint256 _paid = msg.value;
674 
675         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
676 
677         bool _isNewPlayer = isNewPlayer(_addr);
678 
679         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
680         uint256 _pID = makePlayerID(msg.sender);
681 
682         uint256 _affID;
683         if (_affCode != "" && _affCode != _name)
684         {
685             // get affiliate ID from aff Code
686             _affID = pIDxName_[_affCode];
687 
688             // if affID is not the same as previously stored
689             if (_affID != plyr_[_pID].laff)
690             {
691                 // update last affiliate
692                 plyr_[_pID].laff = _affID;
693             }
694         }
695 
696         registerNameCore(_pID, _name);
697         // fire event
698         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
699     }
700 
701     function registerNameCore(uint256 _pID, bytes32 _name)
702         private
703     {
704 
705         // if names already has been used, require that current msg sender owns the name
706         if (pIDxName_[_name] != 0)
707             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
708 
709         // add name to player profile, registry, and name book
710         plyr_[_pID].name = _name;
711         pIDxName_[_name] = _pID;
712         if (plyrNames_[_pID][_name] == false)
713         {
714             plyrNames_[_pID][_name] = true;
715         }
716         // registration fee goes directly to community rewards
717         CompanyShare.deposit.value(msg.value)();
718     }
719 
720     function isNewPlayer(address _addr)
721     public
722     view
723     returns (bool)
724     {
725         if (pIDxAddr_[_addr] == 0)
726         {
727             // set the new player bool to true
728             return (true);
729         } else {
730             return (false);
731         }
732     }
733 //==============================================================================
734 //     _  _ _|__|_ _  _ _  .
735 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
736 //=====_|=======================================================================
737     /**
738      * @dev return the price buyer will pay for next 1 individual key.
739      * -functionhash- 0x018a25e8
740      * @return price for next key bought (in wei format)
741      */
742     function getBuyPrice()
743         public
744         view
745         returns(uint256)
746     {
747         // setup local rID
748         uint256 _rID = rID_;
749 
750         // grab time
751         uint256 _now = now;
752 
753         uint256 _timePrice = getBuyPriceTimes();
754         // are we in a round?
755         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
756             return (((round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000)).mul(_timePrice));
757         else // rounds over.  need price for new round
758             return ( 750000000000000 ); // init
759     }
760 
761     function getBuyPriceTimes()
762         public
763         view
764         returns(uint256)
765     {
766         uint256 timeLeft = getTimeLeft();
767         if(timeLeft <= 300)
768         {
769             return 10;
770         }else{
771             return 1;
772         }
773     }
774     /**
775      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
776      * provider
777      * -functionhash- 0xc7e284b8
778      * @return time left in seconds
779      */
780     function getTimeLeft()
781         public
782         view
783         returns(uint256)
784     {
785         // setup local rID
786         uint256 _rID = rID_;
787 
788         // grab time
789         uint256 _now = now;
790 
791         if (_now < round_[_rID].end)
792             if (_now > round_[_rID].strt + rndGap_)
793                 return( (round_[_rID].end).sub(_now) );
794             else
795                 return( (round_[_rID].strt + rndGap_).sub(_now) );
796         else
797             return(0);
798     }
799 
800     /**
801      * @dev returns player earnings per vaults
802      * -functionhash- 0x63066434
803      * @return winnings vault
804      * @return general vault
805      * @return affiliate vault
806      */
807     function getPlayerVaults(uint256 _pID)
808         public
809         view
810         returns(uint256 ,uint256, uint256)
811     {
812         // setup local rID
813         uint256 _rID = rID_;
814 
815         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
816         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
817         {
818             // if player is winner
819             if (round_[_rID].plyr == _pID)
820             {
821                 return
822                 (
823                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
824                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
825                     plyr_[_pID].aff
826                 );
827             // if player is not the winner
828             } else {
829                 return
830                 (
831                     plyr_[_pID].win,
832                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
833                     plyr_[_pID].aff
834                 );
835             }
836 
837         // if round is still going on, or round has ended and round end has been ran
838         } else {
839             return
840             (
841                 plyr_[_pID].win,
842                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
843                 plyr_[_pID].aff
844             );
845         }
846     }
847 
848     /**
849      * solidity hates stack limits.  this lets us avoid that hate
850      */
851     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
852         private
853         view
854         returns(uint256)
855     {
856         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].endGen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
857     }
858 
859     /**
860      * @dev returns all current round info needed for front end
861      * -functionhash- 0x747dff42
862      * @return eth invested during ICO phase
863      * @return round id
864      * @return total keys for round
865      * @return time round ends
866      * @return time round started
867      * @return current pot
868      * @return current team ID & player ID in lead
869      * @return current player in leads address
870      * @return current player in leads name
871      * @return whales eth in for round
872      * @return bears eth in for round
873      * @return sneks eth in for round
874      * @return bulls eth in for round
875      * @return airdrop tracker # & airdrop pot
876      */
877     function getCurrentRoundInfo()
878         public
879         view
880         returns(uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
881     {
882         // setup local rID
883         uint256 _rID = rID_;
884 
885         return
886         (
887             _rID,                           //0
888             round_[_rID].keys,              //1
889             round_[_rID].end,               //2
890             round_[_rID].strt,              //3
891             round_[_rID].pot,               //4
892             (round_[_rID].team + (round_[_rID].plyr * 10)),     //5
893             plyr_[round_[_rID].plyr].addr,  //6
894             plyr_[round_[_rID].plyr].name,  //7
895             rndTmEth_[_rID][0],             //8
896             rndTmEth_[_rID][1],             //9
897             rndTmEth_[_rID][2],             //10
898             rndTmEth_[_rID][3]             //11
899         );
900     }
901 
902     /**
903      * @dev returns player info based on address.  if no address is given, it will
904      * use msg.sender
905      * -functionhash- 0xee0b5d8b
906      * @param _addr address of the player you want to lookup
907      * @return player ID
908      * @return player name
909      * @return keys owned (current round)
910      * @return winnings vault
911      * @return general vault
912      * @return affiliate vault
913 	 * @return player round eth
914      */
915     function getPlayerInfoByAddress(address _addr)
916         public
917         view
918         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
919     {
920         // setup local rID
921         uint256 _rID = rID_;
922 
923         if (_addr == address(0))
924         {
925             _addr == msg.sender;
926         }
927         uint256 _pID = pIDxAddr_[_addr];
928 
929         return
930         (
931             _pID,                               //0
932             plyr_[_pID].name,                   //1
933             plyrRnds_[_pID][_rID].keys,         //2
934             plyr_[_pID].win,                    //3
935             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
936             plyr_[_pID].aff,                    //5
937             plyrRnds_[_pID][_rID].eth           //6
938         );
939     }
940 
941 //==============================================================================
942 //     _ _  _ _   | _  _ . _  .
943 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
944 //=====================_|=======================================================
945     /**
946      * @dev logic runs whenever a buy order is executed.  determines how to handle
947      * incoming eth depending on if we are in an active round or not
948      */
949     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Star3Ddatasets.EventReturns memory _eventData_)
950         private
951     {
952         // setup local rID
953         uint256 _rID = rID_;
954 
955         // grab time
956         uint256 _now = now;
957 
958         // if round is active
959         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
960         {
961             // call core
962             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
963 
964         // if round is not active
965         } else {
966             // check to see if end round needs to be ran
967             if (_now > round_[_rID].end && round_[_rID].ended == false)
968             {
969                 // end the round (distributes pot) & start new round
970 			    round_[_rID].ended = true;
971                 _eventData_ = endRound(_eventData_);
972 
973                 // build event data
974                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
975                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
976 
977                 // fire buy and distribute event
978                 emit Star3Devents.onBuyAndDistribute
979                 (
980                     msg.sender,
981                     plyr_[_pID].name,
982                     msg.value,
983                     _eventData_.compressedData,
984                     _eventData_.compressedIDs,
985                     _eventData_.winnerAddr,
986                     _eventData_.winnerName,
987                     _eventData_.amountWon,
988                     _eventData_.newPot,
989                     _eventData_.genAmount
990                 );
991             }
992 
993             // put eth in players vault
994             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
995         }
996     }
997 
998     /**
999      * @dev logic runs whenever a reload order is executed.  determines how to handle
1000      * incoming eth depending on if we are in an active round or not
1001      */
1002     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Star3Ddatasets.EventReturns memory _eventData_)
1003         private
1004     {
1005         // setup local rID
1006         uint256 _rID = rID_;
1007 
1008         // grab time
1009         uint256 _now = now;
1010 
1011         // if round is active
1012         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1013         {
1014             // get earnings from all vaults and return unused to gen vault
1015             // because we use a custom safemath library.  this will throw if player
1016             // tried to spend more eth than they have.
1017             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1018 
1019             // call core
1020             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1021 
1022         // if round is not active and end round needs to be ran
1023         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1024             // end the round (distributes pot) & start new round
1025             round_[_rID].ended = true;
1026             _eventData_ = endRound(_eventData_);
1027 
1028             // build event data
1029             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1030             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1031 
1032             // fire buy and distribute event
1033             emit Star3Devents.onReLoadAndDistribute
1034             (
1035                 msg.sender,
1036                 plyr_[_pID].name,
1037                 _eventData_.compressedData,
1038                 _eventData_.compressedIDs,
1039                 _eventData_.winnerAddr,
1040                 _eventData_.winnerName,
1041                 _eventData_.amountWon,
1042                 _eventData_.newPot,
1043                 _eventData_.genAmount
1044             );
1045         }
1046     }
1047 
1048     /**
1049      * @dev this is the core logic for any buy/reload that happens while a round
1050      * is live.
1051      */
1052     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Star3Ddatasets.EventReturns memory _eventData_)
1053         private
1054     {
1055         // if player is new to round
1056         if (plyrRnds_[_pID][_rID].keys == 0)
1057             _eventData_ = managePlayer(_pID, _eventData_);
1058 
1059         // early round eth limiter
1060         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1061         {
1062             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1063             uint256 _refund = _eth.sub(_availableLimit);
1064             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1065             _eth = _availableLimit;
1066         }
1067 
1068         // if eth left is greater than min eth allowed (sorry no pocket lint)
1069         if (_eth > 1000000000)
1070         {
1071             uint256 _timeLeft = getTimeLeft();
1072             // mint the new keys
1073             uint256 _keys = (round_[_rID].eth).keysRec(_eth, _timeLeft);
1074 
1075             // if they bought at least 1 whole key
1076             if (_keys >= 1000000000000000000)
1077             {
1078             updateTimer(_keys, _rID);
1079 
1080             // set new leaders
1081             if (round_[_rID].plyr != _pID)
1082                 round_[_rID].plyr = _pID;
1083             if (round_[_rID].team != _team)
1084                 round_[_rID].team = _team;
1085 
1086             // set the new leader bool to true
1087             _eventData_.compressedData = _eventData_.compressedData + 100;
1088             }
1089 
1090             // store the air drop tracker number (number of buys since last airdrop)
1091             _eventData_.compressedData = _eventData_.compressedData;
1092 
1093             // update player
1094             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1095             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1096 
1097             // update round
1098             round_[_rID].keys = _keys.add(round_[_rID].keys);
1099             round_[_rID].eth = _eth.add(round_[_rID].eth);
1100             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1101             if(_timeLeft <= 300)
1102             {
1103                 uint256 devValue = (_eth.mul(90) / 100);
1104                 _eth = _eth.sub(devValue);
1105                 CompanyShare.deposit.value(devValue)();
1106             }
1107 
1108             // distribute eth
1109             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
1110             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1111 
1112             // call end tx function to fire end tx event.
1113 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1114         }
1115     }
1116 //==============================================================================
1117 //     _ _ | _   | _ _|_ _  _ _  .
1118 //    (_(_||(_|_||(_| | (_)| _\  .
1119 //==============================================================================
1120     /**
1121      * @dev calculates unmasked earnings (just calculates, does not update mask)
1122      * @return earnings in wei format
1123      */
1124     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1125         private
1126         view
1127         returns(uint256)
1128     {
1129         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1130     }
1131 
1132     /**
1133      * @dev returns the amount of keys you would get given an amount of eth.
1134      * -functionhash- 0xce89c80c
1135      * @param _rID round ID you want price for
1136      * @param _eth amount of eth sent in
1137      * @return keys received
1138      */
1139     function calcKeysReceived(uint256 _rID, uint256 _eth)
1140         public
1141         view
1142         returns(uint256)
1143     {
1144         // grab time
1145         uint256 _now = now;
1146         uint256 _timeLeft = getTimeLeft();
1147 
1148         // are we in a round?
1149         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1150             return ( (round_[_rID].eth).keysRec(_eth, _timeLeft) );
1151         else // rounds over.  need keys for new round
1152             return ( (_eth).keys(0) );
1153     }
1154 
1155     /**
1156      * @dev returns current eth price for X keys.
1157      * -functionhash- 0xcf808000
1158      * @param _keys number of keys desired (in 18 decimal format)
1159      * @return amount of eth needed to send
1160      */
1161     function iWantXKeys(uint256 _keys)
1162         public
1163         view
1164         returns(uint256)
1165     {
1166         // setup local rID
1167         uint256 _rID = rID_;
1168 
1169         // grab time
1170         uint256 _now = now;
1171         uint256 _timePrice = getBuyPriceTimes();
1172         // are we in a round?
1173         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1174             return (( (round_[_rID].keys.add(_keys)).ethRec(_keys) ).mul(_timePrice));
1175         else // rounds over.  need price for new round
1176             return ( (_keys).eth() );
1177     }
1178     function makePlayerID(address _addr)
1179     private
1180     returns (uint256)
1181     {
1182         if (pIDxAddr_[_addr] == 0)
1183         {
1184             pID_++;
1185             pIDxAddr_[_addr] = pID_;
1186             // set the new player bool to true
1187             return (pID_);
1188         } else {
1189             return (pIDxAddr_[_addr]);
1190         }
1191     }
1192 
1193 
1194     function getPlayerName(uint256 _pID)
1195     external
1196     view
1197     returns (bytes32)
1198     {
1199         return (plyr_[_pID].name);
1200     }
1201     function getPlayerLAff(uint256 _pID)
1202         external
1203         view
1204         returns (uint256)
1205     {
1206         return (plyr_[_pID].laff);
1207     }
1208 
1209     /**
1210      * @dev gets existing or registers new pID.  use this when a player may be new
1211      * @return pID
1212      */
1213     function determinePID(Star3Ddatasets.EventReturns memory _eventData_)
1214         private
1215         returns (Star3Ddatasets.EventReturns)
1216     {
1217         uint256 _pID = pIDxAddr_[msg.sender];
1218         // if player is new to this version of fomo3d
1219         if (_pID == 0)
1220         {
1221             // grab their player ID, name and last aff ID, from player names contract
1222             _pID = makePlayerID(msg.sender);
1223 
1224             bytes32 _name = "";
1225             uint256 _laff = 0;
1226             // set up player account
1227             pIDxAddr_[msg.sender] = _pID;
1228             plyr_[_pID].addr = msg.sender;
1229 
1230             if (_name != "")
1231             {
1232                 pIDxName_[_name] = _pID;
1233                 plyr_[_pID].name = _name;
1234                 plyrNames_[_pID][_name] = true;
1235             }
1236 
1237             if (_laff != 0 && _laff != _pID)
1238                 plyr_[_pID].laff = _laff;
1239             // set the new player bool to true
1240             _eventData_.compressedData = _eventData_.compressedData + 1;
1241         }
1242         return (_eventData_);
1243     }
1244 
1245     /**
1246      * @dev checks to make sure user picked a valid team.  if not sets team
1247      * to default (sneks)
1248      */
1249     function verifyTeam(uint256 _team)
1250         private
1251         pure
1252         returns (uint256)
1253     {
1254         if (_team < 0 || _team > 3)
1255             return(2);
1256         else
1257             return(_team);
1258     }
1259 
1260     /**
1261      * @dev decides if round end needs to be run & new round started.  and if
1262      * player unmasked earnings from previously played rounds need to be moved.
1263      */
1264     function managePlayer(uint256 _pID, Star3Ddatasets.EventReturns memory _eventData_)
1265         private
1266         returns (Star3Ddatasets.EventReturns)
1267     {
1268         // if player has played a previous round, move their unmasked earnings
1269         // from that round to gen vault.
1270         if (plyr_[_pID].lrnd != 0)
1271             updateGenVault(_pID, plyr_[_pID].lrnd);
1272 
1273         // update player's last round played
1274         plyr_[_pID].lrnd = rID_;
1275 
1276         // set the joined round bool to true
1277         _eventData_.compressedData = _eventData_.compressedData + 10;
1278 
1279         return(_eventData_);
1280     }
1281 
1282     /**
1283      * @dev ends the round. manages paying out winner/splitting up pot
1284      */
1285     function endRound(Star3Ddatasets.EventReturns memory _eventData_)
1286         private
1287         returns (Star3Ddatasets.EventReturns)
1288     {
1289         // setup local rID
1290         uint256 _rID = rID_;
1291 
1292         // grab our winning player and team id's
1293         uint256 _winPID = round_[_rID].plyr;
1294         uint256 _winTID = round_[_rID].team;
1295 
1296         // grab our pot amount
1297         uint256 _pot = round_[_rID].pot;
1298 
1299         // calculate our winner share, community rewards, gen share,
1300         // p3d share, and amount reserved for next pot
1301         uint256 _win = (_pot.mul(48)) / 100;
1302         uint256 _com = (_pot / 50);
1303         uint256 _gen = (_pot.mul(potSplit_[_winTID].endGen)) / 100;
1304         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1305 
1306         // calculate ppt for round mask
1307         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1308         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1309         if (_dust > 0)
1310         {
1311             _gen = _gen.sub(_dust);
1312             _res = _res.add(_dust);
1313         }
1314 
1315         // pay our winner
1316         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1317 
1318         // dev rewards
1319         CompanyShare.deposit.value(_com)();
1320 
1321         // distribute gen portion to key holders
1322         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1323 
1324         // send share for p3d to divies
1325 //        if (_p3d > 0)
1326 //            Divies.deposit.value(_p3d)();
1327 
1328         // prepare event data
1329         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1330         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1331         _eventData_.winnerAddr = plyr_[_winPID].addr;
1332         _eventData_.winnerName = plyr_[_winPID].name;
1333         _eventData_.amountWon = _win;
1334         _eventData_.genAmount = _gen;
1335         _eventData_.newPot = _res;
1336 
1337         // start next round
1338         rID_++;
1339         _rID++;
1340         round_[_rID].strt = now;
1341         round_[_rID].end = now.add(rndInit_);
1342         round_[_rID].pot = _res;
1343 
1344         return(_eventData_);
1345     }
1346 
1347     /**
1348      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1349      */
1350     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1351         private
1352     {
1353         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1354         if (_earnings > 0)
1355         {
1356             // put in gen vault
1357             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1358             // zero out their earnings by updating mask
1359             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1360         }
1361     }
1362 
1363     /**
1364      * @dev updates round timer based on number of whole keys bought.
1365      */
1366     function updateTimer(uint256 _keys, uint256 _rID)
1367         private
1368     {
1369         // grab time
1370         uint256 _now = now;
1371 
1372         // calculate time based on number of keys bought
1373         uint256 _newTime;
1374         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1375             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1376         else
1377             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1378 
1379         // compare to max and set new end time
1380         if (_newTime < (rndMax_).add(_now))
1381             round_[_rID].end = _newTime;
1382         else
1383             round_[_rID].end = rndMax_.add(_now);
1384     }
1385 
1386 
1387     /**
1388      * @dev distributes eth based on fees to com, aff, and p3d
1389      */
1390     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, Star3Ddatasets.EventReturns memory _eventData_)
1391         private
1392         returns(Star3Ddatasets.EventReturns)
1393     {
1394         // distribute share to affiliate
1395         uint256 _aff = _eth / 10;
1396         uint256 _affLeader = (_eth.mul(3)) / 100;
1397         uint256 _affLeaderID = plyr_[_affID].laff;
1398         if (_affLeaderID == 0)
1399         {
1400             _aff = _aff.add(_affLeader);
1401         } else{
1402             if (_affLeaderID != _pID && plyr_[_affLeaderID].name != '')
1403             {
1404                 plyr_[_affLeaderID].aff = _affLeader.add(plyr_[_affLeaderID].aff);
1405             }else{
1406                 _aff = _aff.add(_affLeader);
1407             }
1408         }
1409         // affiliate must not be self, and must have a name registered
1410         if (_affID != _pID && plyr_[_affID].name != '') {
1411             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1412         } else {
1413             // dev rewards
1414             CompanyShare.deposit.value(_aff)();
1415         }
1416         return(_eventData_);
1417     }
1418 
1419     /**
1420      * @dev distributes eth based on fees to gen and pot
1421      */
1422     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Star3Ddatasets.EventReturns memory _eventData_)
1423         private
1424         returns(Star3Ddatasets.EventReturns)
1425     {
1426         // calculate gen share
1427         uint256 _gen = (_eth.mul(fees_[_team].firstGive)) / 100;
1428         // calculate dev
1429         uint256 _dev = (_eth.mul(fees_[_team].giveDev)) / 100;
1430         //distribute share to affiliate 13%
1431         _eth = _eth.sub(((_eth.mul(13)) / 100)).sub(_dev);
1432         //calc pot
1433         uint256 _pot =_eth.sub(_gen);
1434 
1435         // distribute gen share (thats what updateMasks() does) and adjust
1436         // balances for dust.
1437         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1438         if (_dust > 0)
1439             _gen = _gen.sub(_dust);
1440 
1441         // dev rewards
1442         CompanyShare.deposit.value(_dev)();
1443 //        address devAddress = 0xD9361fF1cce8EA98d7c58719B20a425FDCE6E50F;
1444 //        devAddress.transfer(_dev);
1445 
1446         // add eth to pot
1447         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1448 
1449         // set up event data
1450         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1451         _eventData_.potAmount = _pot;
1452 
1453         return(_eventData_);
1454     }
1455 
1456     /**
1457      * @dev updates masks for round and player when keys are bought
1458      * @return dust left over
1459      */
1460     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1461         private
1462         returns(uint256)
1463     {
1464         /* MASKING NOTES
1465             earnings masks are a tricky thing for people to wrap their minds around.
1466             the basic thing to understand here.  is were going to have a global
1467             tracker based on profit per share for each round, that increases in
1468             relevant proportion to the increase in share supply.
1469 
1470             the player will have an additional mask that basically says "based
1471             on the rounds mask, my shares, and how much i've already withdrawn,
1472             how much is still owed to me?"
1473         */
1474 
1475         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1476         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1477         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1478 
1479         // calculate player earning from their own buy (only based on the keys
1480         // they just bought).  & update player earnings mask
1481         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1482         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1483 
1484         // calculate & return dust
1485         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1486     }
1487 
1488     /**
1489      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1490      * @return earnings in wei format
1491      */
1492     function withdrawEarnings(uint256 _pID)
1493         private
1494         returns(uint256)
1495     {
1496         // update gen vault
1497         updateGenVault(_pID, plyr_[_pID].lrnd);
1498 
1499         // from vaults
1500         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1501         if (_earnings > 0)
1502         {
1503             plyr_[_pID].win = 0;
1504             plyr_[_pID].gen = 0;
1505             plyr_[_pID].aff = 0;
1506         }
1507 
1508         return(_earnings);
1509     }
1510 
1511     /**
1512      * @dev prepares compression data and fires event for buy or reload tx's
1513      */
1514     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Star3Ddatasets.EventReturns memory _eventData_)
1515         private
1516     {
1517         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1518         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1519 
1520         emit Star3Devents.onEndTx
1521         (
1522             _eventData_.compressedData,
1523             _eventData_.compressedIDs,
1524             plyr_[_pID].name,
1525             msg.sender,
1526             _eth,
1527             _keys,
1528             _eventData_.winnerAddr,
1529             _eventData_.winnerName,
1530             _eventData_.amountWon,
1531             _eventData_.newPot,
1532             _eventData_.genAmount,
1533             _eventData_.potAmount
1534         );
1535     }
1536 //==============================================================================
1537 //    (~ _  _    _._|_    .
1538 //    _)(/_(_|_|| | | \/  .
1539 //====================/=========================================================
1540     /** upon contract deploy, it will be deactivated.  this is a one time
1541      * use function that will activate the contract.  we do this so devs
1542      * have time to set things up on the web end                            **/
1543     bool public activated_ = false;
1544     function activate()
1545         public
1546     {
1547         // only team just can activate
1548         require(
1549 			msg.sender == admin,
1550             "only team just can activate"
1551         );
1552 
1553 		// make sure that its been linked.
1554 //        require(address(otherF3D_) != address(0), "must link to other Star3D first");
1555 
1556         // can only be ran once
1557         require(activated_ == false, "Star3d already activated");
1558 
1559         // activate the contract
1560         activated_ = true;
1561 
1562         // lets start first round
1563 		rID_ = 1;
1564         round_[1].strt = now;
1565         round_[1].end = now + rndInit_ + rndExtra_;
1566     }
1567     
1568     
1569     function recycleAfterEnd() public{ 
1570           require(
1571 			msg.sender == admin,
1572             "only team can call"
1573         );
1574         require(
1575 			round_[rID_].pot < 1 ether,
1576 			"people still playing"
1577 		);
1578         
1579         selfdestruct(address(CompanyShare));
1580     }
1581 }
1582 
1583 
1584 library NameFilter {
1585     /**
1586      * @dev filters name strings
1587      * -converts uppercase to lower case.
1588      * -makes sure it does not start/end with a space
1589      * -makes sure it does not contain multiple spaces in a row
1590      * -cannot be only numbers
1591      * -cannot start with 0x
1592      * -restricts characters to A-Z, a-z, 0-9, and space.
1593      * @return reprocessed string in bytes32 format
1594      */
1595     function nameFilter(string _input)
1596         internal
1597         pure
1598         returns(bytes32)
1599     {
1600         bytes memory _temp = bytes(_input);
1601         uint256 _length = _temp.length;
1602 
1603         //sorry limited to 32 characters
1604         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1605         // make sure it doesnt start with or end with space
1606         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1607         // make sure first two characters are not 0x
1608         if (_temp[0] == 0x30)
1609         {
1610             require(_temp[1] != 0x78, "string cannot start with 0x");
1611             require(_temp[1] != 0x58, "string cannot start with 0X");
1612         }
1613 
1614         // create a bool to track if we have a non number character
1615         bool _hasNonNumber;
1616 
1617         // convert & check
1618         for (uint256 i = 0; i < _length; i++)
1619         {
1620             // if its uppercase A-Z
1621             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1622             {
1623                 // convert to lower case a-z
1624                 _temp[i] = byte(uint(_temp[i]) + 32);
1625 
1626                 // we have a non number
1627                 if (_hasNonNumber == false)
1628                     _hasNonNumber = true;
1629             } else {
1630                 require
1631                 (
1632                     // require character is a space
1633                     _temp[i] == 0x20 ||
1634                     // OR lowercase a-z
1635                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1636                     // or 0-9
1637                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1638                     "string contains invalid characters"
1639                 );
1640                 // make sure theres not 2x spaces in a row
1641                 if (_temp[i] == 0x20)
1642                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1643 
1644                 // see if we have a character other than a number
1645                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1646                     _hasNonNumber = true;
1647             }
1648         }
1649 
1650         require(_hasNonNumber == true, "string cannot be only numbers");
1651 
1652         bytes32 _ret;
1653         assembly {
1654             _ret := mload(add(_temp, 32))
1655         }
1656         return (_ret);
1657     }
1658 }
1659 
1660 
1661 //==============================================================================
1662 //   __|_ _    __|_ _  .
1663 //  _\ | | |_|(_ | _\  .
1664 //==============================================================================
1665 library Star3Ddatasets {
1666     //compressedData key
1667     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1668         // 0 - new player (bool)
1669         // 1 - joined round (bool)
1670         // 2 - new  leader (bool)
1671         // 3-5 - air drop tracker (uint 0-999)
1672         // 6-16 - round end time
1673         // 17 - winnerTeam
1674         // 18 - 28 timestamp
1675         // 29 - team
1676         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1677         // 31 - airdrop happened bool
1678         // 32 - airdrop tier
1679         // 33 - airdrop amount won
1680     //compressedIDs key
1681     // [77-52][51-26][25-0]
1682         // 0-25 - pID
1683         // 26-51 - winPID
1684         // 52-77 - rID
1685     struct EventReturns {
1686         uint256 compressedData;
1687         uint256 compressedIDs;
1688         address winnerAddr;         // winner address
1689         bytes32 winnerName;         // winner name
1690         uint256 amountWon;          // amount won
1691         uint256 newPot;             // amount in new pot
1692         uint256 genAmount;          // amount distributed to gen
1693         uint256 potAmount;          // amount added to pot
1694     }
1695     struct Player {
1696         address addr;   // player address
1697         bytes32 name;   // player name
1698         uint256 win;    // winnings vault
1699         uint256 gen;    // general vault
1700         uint256 aff;    // affiliate vault
1701         uint256 lrnd;   // last round played
1702         uint256 laff;   // last affiliate id used
1703     }
1704     struct PlayerRounds {
1705         uint256 eth;    // eth player has added to round (used for eth limiter)
1706         uint256 keys;   // keys
1707         uint256 mask;   // player mask
1708     }
1709     struct Round {
1710         uint256 plyr;   // pID of player in lead
1711         uint256 team;   // tID of team in lead
1712         uint256 end;    // time ends/ended
1713         bool ended;     // has round end function been ran
1714         uint256 strt;   // time round started
1715         uint256 keys;   // keys
1716         uint256 eth;    // total eth in
1717         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1718         uint256 mask;   // global mask
1719         uint256 icoGen; // total eth for gen during ICO phase
1720         uint256 icoAvg; // average key price for ICO phase
1721     }
1722     struct TeamFee {
1723         uint256 firstPot;   //% of pot
1724         uint256 firstGive; //% of keys gen
1725         uint256 giveDev;//% of give dev
1726         uint256 giveAffLeader;//% of give dev
1727 
1728     }
1729     struct PotSplit {
1730         uint256 endNext; //% of next
1731         uint256 endGen; //% of keys gen
1732     }
1733 }
1734 
1735 //==============================================================================
1736 //  |  _      _ _ | _  .
1737 //  |<(/_\/  (_(_||(_  .
1738 //=======/======================================================================
1739 library Star3DKeysCalcLong {
1740     using SafeMath for *;
1741     /**
1742      * @dev calculates number of keys received given X eth
1743      * @param _curEth current amount of eth in contract
1744      * @param _newEth eth being spent
1745      * @return amount of ticket purchased
1746      */
1747     function keysRec(uint256 _curEth, uint256 _newEth, uint256 _timeLeft)
1748         internal
1749         pure
1750         returns (uint256)
1751     {
1752         if(_timeLeft <= 300)
1753         {
1754             return keys(_newEth, _timeLeft);
1755         }else{
1756             return(keys((_curEth).add(_newEth), _timeLeft).sub(keys(_curEth, _timeLeft)));
1757         }
1758     }
1759 
1760     /**
1761      * @dev calculates amount of eth received if you sold X keys
1762      * @param _curKeys current amount of keys that exist
1763      * @param _sellKeys amount of keys you wish to sell
1764      * @return amount of eth received
1765      */
1766     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1767         internal
1768         pure
1769         returns (uint256)
1770     {
1771         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1772     }
1773 
1774     /**
1775      * @dev calculates how many keys would exist with given an amount of eth
1776      * @param _eth eth "in contract"
1777      * @return number of keys that would exist
1778      */
1779     function keys(uint256 _eth, uint256 _timeLeft)
1780         internal
1781         pure
1782         returns(uint256)
1783     {
1784         uint256 _timePrice = getBuyPriceTimesByTime(_timeLeft);
1785         uint256 _keys = ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000) / (_timePrice.mul(10));
1786         if(_keys >= 990000000000000000 && _keys < 1000000000000000000)
1787         {
1788             return 1000000000000000000;
1789         }
1790         return _keys;
1791     }
1792 
1793     /**
1794      * @dev calculates how much eth would be in contract given a number of keys
1795      * @param _keys number of keys "in contract"
1796      * @return eth that would exists
1797      */
1798     function eth(uint256 _keys)
1799         internal
1800         pure
1801         returns(uint256)
1802     {
1803         return (((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq())).mul(10);
1804     }
1805     function getBuyPriceTimesByTime(uint256 _timeLeft)
1806         public
1807         pure
1808         returns(uint256)
1809     {
1810         if(_timeLeft <= 300)
1811         {
1812             return 10;
1813         }else{
1814             return 1;
1815         }
1816     }
1817 }
1818 
1819 /**
1820  * @title SafeMath v0.1.9
1821  * @dev Math operations with safety checks that throw on error
1822  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1823  * - added sqrt
1824  * - added sq
1825  * - added pwr
1826  * - changed asserts to requires with error log outputs
1827  * - removed div, its useless
1828  */
1829 library SafeMath {
1830 
1831     /**
1832     * @dev Multiplies two numbers, throws on overflow.
1833     */
1834     function mul(uint256 a, uint256 b)
1835         internal
1836         pure
1837         returns (uint256 c)
1838     {
1839         if (a == 0) {
1840             return 0;
1841         }
1842         c = a * b;
1843         require(c / a == b, "SafeMath mul failed");
1844         return c;
1845     }
1846 
1847     /**
1848     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1849     */
1850     function sub(uint256 a, uint256 b)
1851         internal
1852         pure
1853         returns (uint256)
1854     {
1855         require(b <= a, "SafeMath sub failed");
1856         return a - b;
1857     }
1858 
1859     /**
1860     * @dev Adds two numbers, throws on overflow.
1861     */
1862     function add(uint256 a, uint256 b)
1863         internal
1864         pure
1865         returns (uint256 c)
1866     {
1867         c = a + b;
1868         require(c >= a, "SafeMath add failed");
1869         return c;
1870     }
1871 
1872     /**
1873      * @dev gives square root of given x.
1874      */
1875     function sqrt(uint256 x)
1876         internal
1877         pure
1878         returns (uint256 y)
1879     {
1880         uint256 z = ((add(x,1)) / 2);
1881         y = x;
1882         while (z < y)
1883         {
1884             y = z;
1885             z = ((add((x / z),z)) / 2);
1886         }
1887     }
1888 
1889     /**
1890      * @dev gives square. multiplies x by x
1891      */
1892     function sq(uint256 x)
1893         internal
1894         pure
1895         returns (uint256)
1896     {
1897         return (mul(x,x));
1898     }
1899 
1900     /**
1901      * @dev x to the power of y
1902      */
1903     function pwr(uint256 x, uint256 y)
1904         internal
1905         pure
1906         returns (uint256)
1907     {
1908         if (x==0)
1909             return (0);
1910         else if (y==0)
1911             return (1);
1912         else
1913         {
1914             uint256 z = x;
1915             for (uint256 i=1; i < y; i++)
1916                 z = mul(z,x);
1917             return (z);
1918         }
1919     }
1920 }