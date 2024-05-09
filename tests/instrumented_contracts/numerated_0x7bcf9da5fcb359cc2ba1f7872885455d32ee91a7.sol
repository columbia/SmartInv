1 pragma solidity ^0.4.24;
2 //==============================================================================
3 //     _    _  _ _|_ _  .
4 //    (/_\/(/_| | | _\  .
5 //==============================================================================
6 contract F3Devents {
7     // fired whenever a player registers a name
8     event onNewName
9     (
10         uint256 indexed playerID,
11         address indexed playerAddress,
12         bytes32 indexed playerName,
13         bool isNewPlayer,
14         uint256 affiliateID,
15         address affiliateAddress,
16         bytes32 affiliateName,
17         uint256 amountPaid,
18         uint256 timeStamp
19     );
20 
21     // fired at end of buy or reload
22     event onEndTx
23     (
24         uint256 compressedData,
25         uint256 compressedIDs,
26         bytes32 playerName,
27         address playerAddress,
28         uint256 ethIn,
29         uint256 keysBought,
30         address winnerAddr,
31         bytes32 winnerName,
32         uint256 amountWon,
33         uint256 newPot,
34         uint256 P3DAmount,
35         uint256 genAmount,
36         uint256 potAmount,
37         uint256 airDropPot
38     );
39 
40 	// fired whenever theres a withdraw
41     event onWithdraw
42     (
43         uint256 indexed playerID,
44         address playerAddress,
45         bytes32 playerName,
46         uint256 ethOut,
47         uint256 timeStamp
48     );
49 
50     // fired whenever a withdraw forces end round to be ran
51     event onWithdrawAndDistribute
52     (
53         address playerAddress,
54         bytes32 playerName,
55         uint256 ethOut,
56         uint256 compressedData,
57         uint256 compressedIDs,
58         address winnerAddr,
59         bytes32 winnerName,
60         uint256 amountWon,
61         uint256 newPot,
62         uint256 P3DAmount,
63         uint256 genAmount
64     );
65 
66     // (fomo3d long only) fired whenever a player tries a buy after round timer
67     // hit zero, and causes end round to be ran.
68     event onBuyAndDistribute
69     (
70         address playerAddress,
71         bytes32 playerName,
72         uint256 ethIn,
73         uint256 compressedData,
74         uint256 compressedIDs,
75         address winnerAddr,
76         bytes32 winnerName,
77         uint256 amountWon,
78         uint256 newPot,
79         uint256 P3DAmount,
80         uint256 genAmount
81     );
82 
83     // (fomo3d long only) fired whenever a player tries a reload after round timer
84     // hit zero, and causes end round to be ran.
85     event onReLoadAndDistribute
86     (
87         address playerAddress,
88         bytes32 playerName,
89         uint256 compressedData,
90         uint256 compressedIDs,
91         address winnerAddr,
92         bytes32 winnerName,
93         uint256 amountWon,
94         uint256 newPot,
95         uint256 P3DAmount,
96         uint256 genAmount
97     );
98 
99     // fired whenever an affiliate is paid
100     event onAffiliatePayout
101     (
102         uint256 indexed affiliateID,
103         address affiliateAddress,
104         bytes32 affiliateName,
105         uint256 indexed roundID,
106         uint256 indexed buyerID,
107         uint256 amount,
108         uint256 timeStamp
109     );
110 
111     // received pot swap deposit
112     event onPotSwapDeposit
113     (
114         uint256 roundID,
115         uint256 amountAddedToPot
116     );
117 }
118 
119 //==============================================================================
120 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
121 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
122 //====================================|=========================================
123 
124 contract modularLong is F3Devents {}
125 
126 contract FuMoToken is modularLong {
127     using SafeMath for *;
128     using NameFilter for string;
129     using F3DKeysCalcLong for uint256;
130 
131     otherFoMo3D private otherF3D_;
132 
133     ForwarderInterface constant private Team_Forwarder = ForwarderInterface(0x4D780ebAC0028c41dc311d06aF3db411e314b791);
134     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xd085AcFC0FDaA418E03E8570EF9A4E25a0E14eCf);
135     address private swapDeposit = 0x3705B81d42199138E53FB0Ad57613ce309576077;
136 
137 //==============================================================================
138 //     _ _  _  |`. _     _ _ |_ | _  _  .
139 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
140 //=================_|===========================================================
141     string constant public name = "FuMoToken";
142     string constant public symbol = "FUM";
143     uint256 private rndExtra_ = 0;     // length of the very first ICO
144     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
145     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
146     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
147     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
148 //==============================================================================
149 //     _| _ _|_ _    _ _ _|_    _   .
150 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
151 //=============================|================================================
152     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
153     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
154     uint256 public rID_;    // round id number / total rounds that have happened
155 //****************
156 // PLAYER DATA
157 //****************
158     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
159     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
160     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
161     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
162     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
163 //****************
164 // ROUND DATA
165 //****************
166     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
167     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
168 //****************
169 // TEAM FEE DATA
170 //****************
171     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
172     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
173 //==============================================================================
174 //     _ _  _  __|_ _    __|_ _  _  .
175 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
176 //==============================================================================
177     constructor()
178         public
179     {
180 		// Team allocation structures
181         // 0 = whales
182         // 1 = bears
183         // 2 = sneks
184         // 3 = bulls
185 
186 		// Team allocation percentages
187         // (F3D, P3D) + (Pot , Referrals, Community)
188             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
189         fees_[0] = F3Ddatasets.TeamFee(36,0);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
190         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
191         fees_[2] = F3Ddatasets.TeamFee(66,0);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
192         fees_[3] = F3Ddatasets.TeamFee(50,0);   //36% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
193 
194         // how to split up the final pot based on which team was picked
195         // (F3D, P3D)
196         potSplit_[0] = F3Ddatasets.PotSplit(20,0);  //48% to winner, 30% to next round, 2% to com
197         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
198         potSplit_[2] = F3Ddatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com
199         potSplit_[3] = F3Ddatasets.PotSplit(45,0);  //48% to winner, 5% to next round, 2% to com
200     }
201 //==============================================================================
202 //     _ _  _  _|. |`. _  _ _  .
203 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
204 //==============================================================================
205     /**
206      * @dev used to make sure no one can interact with contract until it has
207      * been activated.
208      */
209     modifier isActivated() {
210         require(activated_ == true, "its not ready yet.  check ?eta in discord");
211         _;
212     }
213 
214     /**
215      * @dev prevents contracts from interacting with fomo3d
216      */
217     modifier isHuman() {
218         address _addr = msg.sender;
219         uint256 _codeLength;
220 
221         assembly {_codeLength := extcodesize(_addr)}
222         require(_codeLength == 0, "sorry humans only");
223         _;
224     }
225 
226     /**
227      * @dev sets boundaries for incoming tx
228      */
229     modifier isWithinLimits(uint256 _eth) {
230         require(_eth >= 1000000000, "pocket lint: not a valid currency");
231         require(_eth <= 100000000000000000000000, "no vitalik, no");
232         _;
233     }
234 
235 
236 //==============================================================================
237 //     _    |_ |. _   |`    _  __|_. _  _  _  .
238 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
239 //====|=========================================================================
240     /**
241      * @dev emergency buy uses last stored affiliate ID and team snek
242      */
243     function()
244         isActivated()
245         isHuman()
246         isWithinLimits(msg.value)
247         public
248         payable
249     {
250         // set up our tx event data and determine if player is new or not
251         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
252 
253         // fetch player id
254         uint256 _pID = pIDxAddr_[msg.sender];
255 
256         // buy core
257         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
258     }
259 
260     /**
261      * @dev converts all incoming ethereum to keys.
262      * -functionhash- 0x8f38f309 (using ID for affiliate)
263      * -functionhash- 0x98a0871d (using address for affiliate)
264      * -functionhash- 0xa65b37a1 (using name for affiliate)
265      * @param _affCode the ID/address/name of the player who gets the affiliate fee
266      * @param _team what team is the player playing for?
267      */
268     function buyXid(uint256 _affCode, uint256 _team)
269         isActivated()
270         isHuman()
271         isWithinLimits(msg.value)
272         public
273         payable
274     {
275         // set up our tx event data and determine if player is new or not
276         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
277 
278         // fetch player id
279         uint256 _pID = pIDxAddr_[msg.sender];
280 
281         // manage affiliate residuals
282         // if no affiliate code was given or player tried to use their own, lolz
283         if (_affCode == 0 || _affCode == _pID)
284         {
285             // use last stored affiliate code
286             _affCode = plyr_[_pID].laff;
287 
288         // if affiliate code was given & its not the same as previously stored
289         } else if (_affCode != plyr_[_pID].laff) {
290             // update last affiliate
291             plyr_[_pID].laff = _affCode;
292         }
293 
294         // verify a valid team was selected
295         _team = verifyTeam(_team);
296 
297         // buy core
298         buyCore(_pID, _affCode, _team, _eventData_);
299     }
300 
301     function buyXaddr(address _affCode, uint256 _team)
302         isActivated()
303         isHuman()
304         isWithinLimits(msg.value)
305         public
306         payable
307     {
308         // set up our tx event data and determine if player is new or not
309         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
310 
311         // fetch player id
312         uint256 _pID = pIDxAddr_[msg.sender];
313 
314         // manage affiliate residuals
315         uint256 _affID;
316         // if no affiliate code was given or player tried to use their own, lolz
317         if (_affCode == address(0) || _affCode == msg.sender)
318         {
319             // use last stored affiliate code
320             _affID = plyr_[_pID].laff;
321 
322         // if affiliate code was given
323         } else {
324             // get affiliate ID from aff Code
325             _affID = pIDxAddr_[_affCode];
326 
327             // if affID is not the same as previously stored
328             if (_affID != plyr_[_pID].laff)
329             {
330                 // update last affiliate
331                 plyr_[_pID].laff = _affID;
332             }
333         }
334 
335         // verify a valid team was selected
336         _team = verifyTeam(_team);
337 
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
350         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
400         F3Ddatasets.EventReturns memory _eventData_;
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
432         F3Ddatasets.EventReturns memory _eventData_;
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
472         F3Ddatasets.EventReturns memory _eventData_;
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
530             F3Ddatasets.EventReturns memory _eventData_;
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
548             emit F3Devents.onWithdrawAndDistribute
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
559                 _eventData_.P3DAmount,
560                 _eventData_.genAmount
561             );
562 
563         // in any other situation
564         } else {
565             // get their earnings
566             _eth = withdrawEarnings(_pID);
567 
568             // gib moni
569             if (_eth > 0)
570                 plyr_[_pID].addr.transfer(_eth);
571 
572             // fire withdraw event
573             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
574         }
575     }
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
598      * @param _all set to true if you want this to push your info to all games
599      * (this might cost a lot of gas)
600      */
601     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
602         isHuman()
603         public
604         payable
605     {
606         bytes32 _name = _nameString.nameFilter();
607         address _addr = msg.sender;
608         uint256 _paid = msg.value;
609         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
610 
611         uint256 _pID = pIDxAddr_[_addr];
612 
613         // fire event
614         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
615     }
616 
617     function registerNameXaddr(string _nameString, address _affCode, bool _all)
618         isHuman()
619         public
620         payable
621     {
622         bytes32 _name = _nameString.nameFilter();
623         address _addr = msg.sender;
624         uint256 _paid = msg.value;
625         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
626 
627         uint256 _pID = pIDxAddr_[_addr];
628 
629         // fire event
630         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
631     }
632 
633     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
634         isHuman()
635         public
636         payable
637     {
638         bytes32 _name = _nameString.nameFilter();
639         address _addr = msg.sender;
640         uint256 _paid = msg.value;
641         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
642 
643         uint256 _pID = pIDxAddr_[_addr];
644 
645         // fire event
646         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
647     }
648 //==============================================================================
649 //     _  _ _|__|_ _  _ _  .
650 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
651 //=====_|=======================================================================
652     /**
653      * @dev return the price buyer will pay for next 1 individual key.
654      * -functionhash- 0x018a25e8
655      * @return price for next key bought (in wei format)
656      */
657     function getBuyPrice()
658         public
659         view
660         returns(uint256)
661     {
662         // setup local rID
663         uint256 _rID = rID_;
664 
665         // grab time
666         uint256 _now = now;
667 
668         // are we in a round?
669         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
670             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
671         else // rounds over.  need price for new round
672             return ( 75000000000001 ); // init
673     }
674 
675     /**
676      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
677      * provider
678      * -functionhash- 0xc7e284b8
679      * @return time left in seconds
680      */
681     function getTimeLeft()
682         public
683         view
684         returns(uint256)
685     {
686         // setup local rID
687         uint256 _rID = rID_;
688 
689         // grab time
690         uint256 _now = now;
691 
692         if (_now < round_[_rID].end)
693             if (_now > round_[_rID].strt + rndGap_)
694                 return( (round_[_rID].end).sub(_now) );
695             else
696                 return( (round_[_rID].strt + rndGap_).sub(_now) );
697         else
698             return(0);
699     }
700 
701     /**
702      * @dev returns player earnings per vaults
703      * -functionhash- 0x63066434
704      * @return winnings vault
705      * @return general vault
706      * @return affiliate vault
707      */
708     function getPlayerVaults(uint256 _pID)
709         public
710         view
711         returns(uint256 ,uint256, uint256)
712     {
713         // setup local rID
714         uint256 _rID = rID_;
715 
716         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
717         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
718         {
719             // if player is winner
720             if (round_[_rID].plyr == _pID)
721             {
722                 return
723                 (
724                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
725                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
726                     plyr_[_pID].aff
727                 );
728             // if player is not the winner
729             } else {
730                 return
731                 (
732                     plyr_[_pID].win,
733                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
734                     plyr_[_pID].aff
735                 );
736             }
737 
738         // if round is still going on, or round has ended and round end has been ran
739         } else {
740             return
741             (
742                 plyr_[_pID].win,
743                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
744                 plyr_[_pID].aff
745             );
746         }
747     }
748 
749     /**
750      * solidity hates stack limits.  this lets us avoid that hate
751      */
752     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
753         private
754         view
755         returns(uint256)
756     {
757         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
758     }
759 
760     /**
761      * @dev returns all current round info needed for front end
762      * -functionhash- 0x747dff42
763      * @return eth invested during ICO phase
764      * @return round id
765      * @return total keys for round
766      * @return time round ends
767      * @return time round started
768      * @return current pot
769      * @return current team ID & player ID in lead
770      * @return current player in leads address
771      * @return current player in leads name
772      * @return whales eth in for round
773      * @return bears eth in for round
774      * @return sneks eth in for round
775      * @return bulls eth in for round
776      * @return airdrop tracker # & airdrop pot
777      */
778     function getCurrentRoundInfo()
779         public
780         view
781         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
782     {
783         // setup local rID
784         uint256 _rID = rID_;
785 
786         return
787         (
788             round_[_rID].ico,               //0
789             _rID,                           //1
790             round_[_rID].keys,              //2
791             round_[_rID].end,               //3
792             round_[_rID].strt,              //4
793             round_[_rID].pot,               //5
794             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
795             plyr_[round_[_rID].plyr].addr,  //7
796             plyr_[round_[_rID].plyr].name,  //8
797             rndTmEth_[_rID][0],             //9
798             rndTmEth_[_rID][1],             //10
799             rndTmEth_[_rID][2],             //11
800             rndTmEth_[_rID][3],             //12
801             airDropTracker_ + (airDropPot_ * 1000)              //13
802         );
803     }
804 
805     /**
806      * @dev returns player info based on address.  if no address is given, it will
807      * use msg.sender
808      * -functionhash- 0xee0b5d8b
809      * @param _addr address of the player you want to lookup
810      * @return player ID
811      * @return player name
812      * @return keys owned (current round)
813      * @return winnings vault
814      * @return general vault
815      * @return affiliate vault
816 	 * @return player round eth
817      */
818     function getPlayerInfoByAddress(address _addr)
819         public
820         view
821         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
822     {
823         // setup local rID
824         uint256 _rID = rID_;
825 
826         if (_addr == address(0))
827         {
828             _addr == msg.sender;
829         }
830         uint256 _pID = pIDxAddr_[_addr];
831 
832         return
833         (
834             _pID,                               //0
835             plyr_[_pID].name,                   //1
836             plyrRnds_[_pID][_rID].keys,         //2
837             plyr_[_pID].win,                    //3
838             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
839             plyr_[_pID].aff,                    //5
840             plyrRnds_[_pID][_rID].eth           //6
841         );
842     }
843 
844 //==============================================================================
845 //     _ _  _ _   | _  _ . _  .
846 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
847 //=====================_|=======================================================
848     /**
849      * @dev logic runs whenever a buy order is executed.  determines how to handle
850      * incoming eth depending on if we are in an active round or not
851      */
852     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
853         private
854     {
855         // setup local rID
856         uint256 _rID = rID_;
857 
858         // grab time
859         uint256 _now = now;
860 
861         // if round is active
862         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
863         {
864             // call core
865             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
866 
867         // if round is not active
868         } else {
869             // check to see if end round needs to be ran
870             if (_now > round_[_rID].end && round_[_rID].ended == false)
871             {
872                 // end the round (distributes pot) & start new round
873 			    round_[_rID].ended = true;
874                 _eventData_ = endRound(_eventData_);
875 
876                 // build event data
877                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
878                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
879 
880                 // fire buy and distribute event
881                 emit F3Devents.onBuyAndDistribute
882                 (
883                     msg.sender,
884                     plyr_[_pID].name,
885                     msg.value,
886                     _eventData_.compressedData,
887                     _eventData_.compressedIDs,
888                     _eventData_.winnerAddr,
889                     _eventData_.winnerName,
890                     _eventData_.amountWon,
891                     _eventData_.newPot,
892                     _eventData_.P3DAmount,
893                     _eventData_.genAmount
894                 );
895             }
896 
897             // put eth in players vault
898             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
899         }
900     }
901 
902     /**
903      * @dev logic runs whenever a reload order is executed.  determines how to handle
904      * incoming eth depending on if we are in an active round or not
905      */
906     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
907         private
908     {
909         // setup local rID
910         uint256 _rID = rID_;
911 
912         // grab time
913         uint256 _now = now;
914 
915         // if round is active
916         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
917         {
918             // get earnings from all vaults and return unused to gen vault
919             // because we use a custom safemath library.  this will throw if player
920             // tried to spend more eth than they have.
921             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
922 
923             // call core
924             core(_rID, _pID, _eth, _affID, _team, _eventData_);
925 
926         // if round is not active and end round needs to be ran
927         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
928             // end the round (distributes pot) & start new round
929             round_[_rID].ended = true;
930             _eventData_ = endRound(_eventData_);
931 
932             // build event data
933             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
934             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
935 
936             // fire buy and distribute event
937             emit F3Devents.onReLoadAndDistribute
938             (
939                 msg.sender,
940                 plyr_[_pID].name,
941                 _eventData_.compressedData,
942                 _eventData_.compressedIDs,
943                 _eventData_.winnerAddr,
944                 _eventData_.winnerName,
945                 _eventData_.amountWon,
946                 _eventData_.newPot,
947                 _eventData_.P3DAmount,
948                 _eventData_.genAmount
949             );
950         }
951     }
952 
953     /**
954      * @dev this is the core logic for any buy/reload that happens while a round
955      * is live.
956      */
957     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
958         private
959     {
960         // if player is new to round
961         if (plyrRnds_[_pID][_rID].keys == 0)
962             _eventData_ = managePlayer(_pID, _eventData_);
963 
964         // early round eth limiter
965         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
966         {
967             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
968             uint256 _refund = _eth.sub(_availableLimit);
969             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
970             _eth = _availableLimit;
971         }
972 
973         // if eth left is greater than min eth allowed (sorry no pocket lint)
974         if (_eth > 1000000000)
975         {
976 
977             // mint the new keys
978             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
979 
980             // if they bought at least 1 whole key
981             if (_keys >= 1000000000000000000)
982             {
983             updateTimer(_keys, _rID);
984 
985             // set new leaders
986             if (round_[_rID].plyr != _pID)
987                 round_[_rID].plyr = _pID;
988             if (round_[_rID].team != _team)
989                 round_[_rID].team = _team;
990 
991             // set the new leader bool to true
992             _eventData_.compressedData = _eventData_.compressedData + 100;
993         }
994 
995             // manage airdrops
996             if (_eth >= 100000000000000000)
997             {
998             airDropTracker_++;
999             if (airdrop() == true)
1000             {
1001                 // gib muni
1002                 uint256 _prize;
1003                 if (_eth >= 10000000000000000000)
1004                 {
1005                     // calculate prize and give it to winner
1006                     _prize = ((airDropPot_).mul(75)) / 100;
1007                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1008 
1009                     // adjust airDropPot
1010                     airDropPot_ = (airDropPot_).sub(_prize);
1011 
1012                     // let event know a tier 3 prize was won
1013                     _eventData_.compressedData += 300000000000000000000000000000000;
1014                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1015                     // calculate prize and give it to winner
1016                     _prize = ((airDropPot_).mul(50)) / 100;
1017                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1018 
1019                     // adjust airDropPot
1020                     airDropPot_ = (airDropPot_).sub(_prize);
1021 
1022                     // let event know a tier 2 prize was won
1023                     _eventData_.compressedData += 200000000000000000000000000000000;
1024                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1025                     // calculate prize and give it to winner
1026                     _prize = ((airDropPot_).mul(25)) / 100;
1027                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1028 
1029                     // adjust airDropPot
1030                     airDropPot_ = (airDropPot_).sub(_prize);
1031 
1032                     // let event know a tier 3 prize was won
1033                     _eventData_.compressedData += 300000000000000000000000000000000;
1034                 }
1035                 // set airdrop happened bool to true
1036                 _eventData_.compressedData += 10000000000000000000000000000000;
1037                 // let event know how much was won
1038                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1039 
1040                 // reset air drop tracker
1041                 airDropTracker_ = 0;
1042             }
1043         }
1044 
1045             // store the air drop tracker number (number of buys since last airdrop)
1046             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1047 
1048             // update player
1049             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1050             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1051 
1052             // update round
1053             round_[_rID].keys = _keys.add(round_[_rID].keys);
1054             round_[_rID].eth = _eth.add(round_[_rID].eth);
1055             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1056 
1057             // distribute eth
1058             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1059             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1060 
1061             // call end tx function to fire end tx event.
1062 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1063         }
1064     }
1065 //==============================================================================
1066 //     _ _ | _   | _ _|_ _  _ _  .
1067 //    (_(_||(_|_||(_| | (_)| _\  .
1068 //==============================================================================
1069     /**
1070      * @dev calculates unmasked earnings (just calculates, does not update mask)
1071      * @return earnings in wei format
1072      */
1073     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1074         private
1075         view
1076         returns(uint256)
1077     {
1078         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1079     }
1080 
1081     /**
1082      * @dev returns the amount of keys you would get given an amount of eth.
1083      * -functionhash- 0xce89c80c
1084      * @param _rID round ID you want price for
1085      * @param _eth amount of eth sent in
1086      * @return keys received
1087      */
1088     function calcKeysReceived(uint256 _rID, uint256 _eth)
1089         public
1090         view
1091         returns(uint256)
1092     {
1093         // grab time
1094         uint256 _now = now;
1095 
1096         // are we in a round?
1097         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1098             return ( (round_[_rID].eth).keysRec(_eth) );
1099         else // rounds over.  need keys for new round
1100             return ( (_eth).keys() );
1101     }
1102 
1103     /**
1104      * @dev returns current eth price for X keys.
1105      * -functionhash- 0xcf808000
1106      * @param _keys number of keys desired (in 18 decimal format)
1107      * @return amount of eth needed to send
1108      */
1109     function iWantXKeys(uint256 _keys)
1110         public
1111         view
1112         returns(uint256)
1113     {
1114         // setup local rID
1115         uint256 _rID = rID_;
1116 
1117         // grab time
1118         uint256 _now = now;
1119 
1120         // are we in a round?
1121         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1122             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1123         else // rounds over.  need price for new round
1124             return ( (_keys).eth() );
1125     }
1126 //==============================================================================
1127 //    _|_ _  _ | _  .
1128 //     | (_)(_)|_\  .
1129 //==============================================================================
1130     /**
1131 	 * @dev receives name/player info from names contract
1132      */
1133     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1134         external
1135     {
1136         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1137         if (pIDxAddr_[_addr] != _pID)
1138             pIDxAddr_[_addr] = _pID;
1139         if (pIDxName_[_name] != _pID)
1140             pIDxName_[_name] = _pID;
1141         if (plyr_[_pID].addr != _addr)
1142             plyr_[_pID].addr = _addr;
1143         if (plyr_[_pID].name != _name)
1144             plyr_[_pID].name = _name;
1145         if (plyr_[_pID].laff != _laff)
1146             plyr_[_pID].laff = _laff;
1147         if (plyrNames_[_pID][_name] == false)
1148             plyrNames_[_pID][_name] = true;
1149     }
1150 
1151     /**
1152      * @dev receives entire player name list
1153      */
1154     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1155         external
1156     {
1157         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1158         if(plyrNames_[_pID][_name] == false)
1159             plyrNames_[_pID][_name] = true;
1160     }
1161 
1162     /**
1163      * @dev gets existing or registers new pID.  use this when a player may be new
1164      * @return pID
1165      */
1166     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1167         private
1168         returns (F3Ddatasets.EventReturns)
1169     {
1170         uint256 _pID = pIDxAddr_[msg.sender];
1171         // if player is new to this version of fomo3d
1172         if (_pID == 0)
1173         {
1174             // grab their player ID, name and last aff ID, from player names contract
1175             _pID = PlayerBook.getPlayerID(msg.sender);
1176             bytes32 _name = PlayerBook.getPlayerName(_pID);
1177             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1178 
1179             // set up player account
1180             pIDxAddr_[msg.sender] = _pID;
1181             plyr_[_pID].addr = msg.sender;
1182 
1183             if (_name != "")
1184             {
1185                 pIDxName_[_name] = _pID;
1186                 plyr_[_pID].name = _name;
1187                 plyrNames_[_pID][_name] = true;
1188             }
1189 
1190             if (_laff != 0 && _laff != _pID)
1191                 plyr_[_pID].laff = _laff;
1192 
1193             // set the new player bool to true
1194             _eventData_.compressedData = _eventData_.compressedData + 1;
1195         }
1196         return (_eventData_);
1197     }
1198 
1199     /**
1200      * @dev checks to make sure user picked a valid team.  if not sets team
1201      * to default (sneks)
1202      */
1203     function verifyTeam(uint256 _team)
1204         private
1205         pure
1206         returns (uint256)
1207     {
1208         if (_team < 0 || _team > 3)
1209             return(2);
1210         else
1211             return(_team);
1212     }
1213 
1214     /**
1215      * @dev decides if round end needs to be run & new round started.  and if
1216      * player unmasked earnings from previously played rounds need to be moved.
1217      */
1218     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1219         private
1220         returns (F3Ddatasets.EventReturns)
1221     {
1222         // if player has played a previous round, move their unmasked earnings
1223         // from that round to gen vault.
1224         if (plyr_[_pID].lrnd != 0)
1225             updateGenVault(_pID, plyr_[_pID].lrnd);
1226 
1227         // update player's last round played
1228         plyr_[_pID].lrnd = rID_;
1229 
1230         // set the joined round bool to true
1231         _eventData_.compressedData = _eventData_.compressedData + 10;
1232 
1233         return(_eventData_);
1234     }
1235 
1236     /**
1237      * @dev ends the round. manages paying out winner/splitting up pot
1238      */
1239     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1240         private
1241         returns (F3Ddatasets.EventReturns)
1242     {
1243         // setup local rID
1244         uint256 _rID = rID_;
1245 
1246         // grab our winning player and team id's
1247         uint256 _winPID = round_[_rID].plyr;
1248         uint256 _winTID = round_[_rID].team;
1249 
1250         // grab our pot amount
1251         uint256 _pot = round_[_rID].pot;
1252 
1253         // calculate our winner share, community rewards, gen share,
1254         // p3d share, and amount reserved for next pot
1255         uint256 _win = (_pot.mul(48)) / 100;
1256         uint256 _com = (_pot / 50);
1257         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1258         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1259         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1260 
1261         // calculate ppt for round mask
1262         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1263         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1264         if (_dust > 0)
1265         {
1266             _gen = _gen.sub(_dust);
1267             _res = _res.add(_dust);
1268         }
1269 
1270         // pay our winner
1271         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1272 
1273         // community rewards
1274         if (!address(Team_Forwarder).call.value(_com)(bytes4(keccak256("deposit()"))))
1275         {
1276             _p3d = _p3d.add(_com);
1277             _com = 0;
1278         }
1279 
1280         // distribute gen portion to key holders
1281         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1282 
1283         // send share for p3d to divies
1284         if (_p3d > 0)
1285         {
1286             if (!address(Team_Forwarder).call.value(_p3d)(bytes4(keccak256("deposit()")))){
1287                 _res = _p3d.add(_res);
1288             }
1289         }
1290 
1291         // prepare event data
1292         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1293         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1294         _eventData_.winnerAddr = plyr_[_winPID].addr;
1295         _eventData_.winnerName = plyr_[_winPID].name;
1296         _eventData_.amountWon = _win;
1297         _eventData_.genAmount = _gen;
1298         _eventData_.P3DAmount = _p3d;
1299         _eventData_.newPot = _res;
1300 
1301         // start next round
1302         rID_++;
1303         _rID++;
1304         round_[_rID].strt = now;
1305         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1306         round_[_rID].pot = _res;
1307 
1308         return(_eventData_);
1309     }
1310 
1311     /**
1312      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1313      */
1314     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1315         private
1316     {
1317         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1318         if (_earnings > 0)
1319         {
1320             // put in gen vault
1321             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1322             // zero out their earnings by updating mask
1323             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1324         }
1325     }
1326 
1327     /**
1328      * @dev updates round timer based on number of whole keys bought.
1329      */
1330     function updateTimer(uint256 _keys, uint256 _rID)
1331         private
1332     {
1333         // grab time
1334         uint256 _now = now;
1335 
1336         // calculate time based on number of keys bought
1337         uint256 _newTime;
1338         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1339             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1340         else
1341             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1342 
1343         // compare to max and set new end time
1344         if (_newTime < (rndMax_).add(_now))
1345             round_[_rID].end = _newTime;
1346         else
1347             round_[_rID].end = rndMax_.add(_now);
1348     }
1349 
1350     /**
1351      * @dev generates a random number between 0-99 and checks to see if thats
1352      * resulted in an airdrop win
1353      * @return do we have a winner?
1354      */
1355     function airdrop()
1356         private
1357         view
1358         returns(bool)
1359     {
1360         uint256 seed = uint256(keccak256(abi.encodePacked(
1361 
1362             (block.timestamp).add
1363             (block.difficulty).add
1364             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1365             (block.gaslimit).add
1366             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1367             (block.number)
1368 
1369         )));
1370         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1371             return(true);
1372         else
1373             return(false);
1374     }
1375 
1376     /**
1377      * @dev distributes eth based on fees to com, aff, and p3d
1378      */
1379     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1380         private
1381         returns(F3Ddatasets.EventReturns)
1382     {
1383         // pay 2% out to community rewards
1384         uint256 _com = _eth / 50;
1385         // pay 1% more
1386         uint256 _long = _eth / 50;
1387         if(_long > 0)
1388             swapDeposit.transfer(_long);
1389         
1390         uint256 _p3d;
1391         if (!address(Team_Forwarder).call.value(_com)(bytes4(keccak256("deposit()"))))
1392         {  
1393             _p3d = _com;
1394             _com = 0;
1395         }
1396 
1397         
1398 
1399         // distribute share to affiliate
1400         uint256 _aff = _eth / 10;
1401 
1402         // decide what to do with affiliate share of fees
1403         // affiliate must not be self, and must have a name registered
1404         if (_affID != _pID && plyr_[_affID].name != "") {
1405             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1406             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1407         } else {
1408             _p3d = _aff;
1409         }
1410 
1411         // pay out p3d
1412         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1413         if (_p3d > 0)
1414         {
1415             // deposit to divies contract
1416             if(!address(Team_Forwarder).call.value(_p3d)(bytes4(keccak256("deposit()"))))
1417             {
1418                 uint256 __rID = rID_ + 1;
1419                 round_[__rID].pot = round_[__rID].pot.add(_p3d);
1420             }
1421             _p3d = 0;
1422 
1423             // set up event data
1424             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1425         }
1426 
1427         return(_eventData_);
1428     }
1429 
1430     function potSwap()
1431         external
1432         payable
1433     {
1434         // setup local rID
1435         uint256 _rID = rID_ + 1;
1436 
1437         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1438         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1439     }
1440 
1441     /**
1442      * @dev distributes eth based on fees to gen and pot
1443      */
1444     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1445         private
1446         returns(F3Ddatasets.EventReturns)
1447     {
1448         // calculate gen share
1449         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1450 
1451         // toss 1% into airdrop pot
1452         uint256 _air = (_eth / 100);
1453         airDropPot_ = airDropPot_.add(_air);
1454 
1455         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1456         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1457 
1458         // calculate pot
1459         uint256 _pot = _eth.sub(_gen);
1460 
1461         // distribute gen share (thats what updateMasks() does) and adjust
1462         // balances for dust.
1463         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1464         if (_dust > 0)
1465             _gen = _gen.sub(_dust);
1466 
1467         // add eth to pot
1468         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1469 
1470         // set up event data
1471         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1472         _eventData_.potAmount = _pot;
1473 
1474         return(_eventData_);
1475     }
1476 
1477     /**
1478      * @dev updates masks for round and player when keys are bought
1479      * @return dust left over
1480      */
1481     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1482         private
1483         returns(uint256)
1484     {
1485         /* MASKING NOTES
1486             earnings masks are a tricky thing for people to wrap their minds around.
1487             the basic thing to understand here.  is were going to have a global
1488             tracker based on profit per share for each round, that increases in
1489             relevant proportion to the increase in share supply.
1490 
1491             the player will have an additional mask that basically says "based
1492             on the rounds mask, my shares, and how much i've already withdrawn,
1493             how much is still owed to me?"
1494         */
1495 
1496         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1497         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1498         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1499 
1500         // calculate player earning from their own buy (only based on the keys
1501         // they just bought).  & update player earnings mask
1502         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1503         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1504 
1505         // calculate & return dust
1506         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1507     }
1508 
1509     /**
1510      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1511      * @return earnings in wei format
1512      */
1513     function withdrawEarnings(uint256 _pID)
1514         private
1515         returns(uint256)
1516     {
1517         // update gen vault
1518         updateGenVault(_pID, plyr_[_pID].lrnd);
1519 
1520         // from vaults
1521         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1522         if (_earnings > 0)
1523         {
1524             plyr_[_pID].win = 0;
1525             plyr_[_pID].gen = 0;
1526             plyr_[_pID].aff = 0;
1527         }
1528 
1529         return(_earnings);
1530     }
1531 
1532     /**
1533      * @dev prepares compression data and fires event for buy or reload tx's
1534      */
1535     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1536         private
1537     {
1538         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1539         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1540 
1541         emit F3Devents.onEndTx
1542         (
1543             _eventData_.compressedData,
1544             _eventData_.compressedIDs,
1545             plyr_[_pID].name,
1546             msg.sender,
1547             _eth,
1548             _keys,
1549             _eventData_.winnerAddr,
1550             _eventData_.winnerName,
1551             _eventData_.amountWon,
1552             _eventData_.newPot,
1553             _eventData_.P3DAmount,
1554             _eventData_.genAmount,
1555             _eventData_.potAmount,
1556             airDropPot_
1557         );
1558     }
1559 //==============================================================================
1560 //    (~ _  _    _._|_    .
1561 //    _)(/_(_|_|| | | \/  .
1562 //====================/=========================================================
1563     /** upon contract deploy, it will be deactivated.  this is a one time
1564      * use function that will activate the contract.  we do this so devs
1565      * have time to set things up on the web end                            **/
1566     bool public activated_ = false;
1567     function activate()
1568         public
1569     {
1570         
1571         require(
1572             msg.sender == 0x3705B81d42199138E53FB0Ad57613ce309576077 ||
1573 			msg.sender == 0x8e24E330d02434D16CA9c4ae145B64e07De19614 ||
1574 			msg.sender == 0xC018492974D65c3B3A9FcE1B9f7577505F31A7D8 ||
1575 			msg.sender == 0x82B0721A8c142C6203F4cF58f80629E15b02a504,
1576             "only team can activate"
1577         );
1578         
1579         // can only be ran once
1580         require(activated_ == false, "fomo3d already activated");
1581 
1582         // activate the contract
1583         activated_ = true;
1584 
1585         // lets start first round
1586 		rID_ = 1;
1587         round_[1].strt = now + rndExtra_ - rndGap_;
1588         round_[1].end = now + rndInit_ + rndExtra_;
1589     }
1590     
1591     function setOtherFomo(address _otherF3D)
1592         public
1593     {
1594         // only team just can activate
1595         require(
1596             msg.sender == 0x3705B81d42199138E53FB0Ad57613ce309576077 ||
1597 			msg.sender == 0x8e24E330d02434D16CA9c4ae145B64e07De19614 ||
1598 			msg.sender == 0xC018492974D65c3B3A9FcE1B9f7577505F31A7D8 ||
1599 			msg.sender == 0x82B0721A8c142C6203F4cF58f80629E15b02a504,
1600             "only team can activate"
1601         );
1602 
1603         // make sure that it HASNT yet been linked.
1604         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1605 
1606         // set up other fomo3d (fast or long) for pot swap
1607         otherF3D_ = otherFoMo3D(_otherF3D);
1608     }
1609 }
1610 
1611 //==============================================================================
1612 //   __|_ _    __|_ _  .
1613 //  _\ | | |_|(_ | _\  .
1614 //==============================================================================
1615 library F3Ddatasets {
1616     //compressedData key
1617     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1618         // 0 - new player (bool)
1619         // 1 - joined round (bool)
1620         // 2 - new  leader (bool)
1621         // 3-5 - air drop tracker (uint 0-999)
1622         // 6-16 - round end time
1623         // 17 - winnerTeam
1624         // 18 - 28 timestamp
1625         // 29 - team
1626         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1627         // 31 - airdrop happened bool
1628         // 32 - airdrop tier
1629         // 33 - airdrop amount won
1630     //compressedIDs key
1631     // [77-52][51-26][25-0]
1632         // 0-25 - pID
1633         // 26-51 - winPID
1634         // 52-77 - rID
1635     struct EventReturns {
1636         uint256 compressedData;
1637         uint256 compressedIDs;
1638         address winnerAddr;         // winner address
1639         bytes32 winnerName;         // winner name
1640         uint256 amountWon;          // amount won
1641         uint256 newPot;             // amount in new pot
1642         uint256 P3DAmount;          // amount distributed to p3d
1643         uint256 genAmount;          // amount distributed to gen
1644         uint256 potAmount;          // amount added to pot
1645     }
1646     struct Player {
1647         address addr;   // player address
1648         bytes32 name;   // player name
1649         uint256 win;    // winnings vault
1650         uint256 gen;    // general vault
1651         uint256 aff;    // affiliate vault
1652         uint256 lrnd;   // last round played
1653         uint256 laff;   // last affiliate id used
1654     }
1655     struct PlayerRounds {
1656         uint256 eth;    // eth player has added to round (used for eth limiter)
1657         uint256 keys;   // keys
1658         uint256 mask;   // player mask
1659         uint256 ico;    // ICO phase investment
1660     }
1661     struct Round {
1662         uint256 plyr;   // pID of player in lead
1663         uint256 team;   // tID of team in lead
1664         uint256 end;    // time ends/ended
1665         bool ended;     // has round end function been ran
1666         uint256 strt;   // time round started
1667         uint256 keys;   // keys
1668         uint256 eth;    // total eth in
1669         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1670         uint256 mask;   // global mask
1671         uint256 ico;    // total eth sent in during ICO phase
1672         uint256 icoGen; // total eth for gen during ICO phase
1673         uint256 icoAvg; // average key price for ICO phase
1674     }
1675     struct TeamFee {
1676         uint256 gen;    // % of buy in thats paid to key holders of current round
1677         uint256 p3d;    // % of buy in thats paid to p3d holders
1678     }
1679     struct PotSplit {
1680         uint256 gen;    // % of pot thats paid to key holders of current round
1681         uint256 p3d;    // % of pot thats paid to p3d holders
1682     }
1683 }
1684 
1685 //==============================================================================
1686 //  |  _      _ _ | _  .
1687 //  |<(/_\/  (_(_||(_  .
1688 //=======/======================================================================
1689 library F3DKeysCalcLong {
1690     using SafeMath for *;
1691     /**
1692      * @dev calculates number of keys received given X eth
1693      * @param _curEth current amount of eth in contract
1694      * @param _newEth eth being spent
1695      * @return amount of ticket purchased
1696      */
1697     function keysRec(uint256 _curEth, uint256 _newEth)
1698         internal
1699         pure
1700         returns (uint256)
1701     {
1702         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1703     }
1704 
1705     /**
1706      * @dev calculates amount of eth received if you sold X keys
1707      * @param _curKeys current amount of keys that exist
1708      * @param _sellKeys amount of keys you wish to sell
1709      * @return amount of eth received
1710      */
1711     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1712         internal
1713         pure
1714         returns (uint256)
1715     {
1716         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1717     }
1718 
1719     /**
1720      * @dev calculates how many keys would exist with given an amount of eth
1721      * @param _eth eth "in contract"
1722      * @return number of keys that would exist
1723      */
1724     function keys(uint256 _eth)
1725         internal
1726         pure
1727         returns(uint256)
1728     {
1729         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1730     }
1731 
1732     /**
1733      * @dev calculates how much eth would be in contract given a number of keys
1734      * @param _keys number of keys "in contract"
1735      * @return eth that would exists
1736      */
1737     function eth(uint256 _keys)
1738         internal
1739         pure
1740         returns(uint256)
1741     {
1742         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1743     }
1744 }
1745 
1746 //==============================================================================
1747 //  . _ _|_ _  _ |` _  _ _  _  .
1748 //  || | | (/_| ~|~(_|(_(/__\  .
1749 //==============================================================================
1750 interface otherFoMo3D {
1751     function potSwap() external payable;
1752 }
1753 
1754 
1755 interface DiviesInterface {
1756     function deposit() external payable;
1757     function balances() public view returns(uint256);
1758 }
1759 
1760 interface ForwarderInterface {
1761     function deposit() external payable returns(bool);
1762     function setup(address _firstCorpBank) external;
1763 }
1764 
1765 interface PlayerBookInterface {
1766     function getPlayerID(address _addr) external returns (uint256);
1767     function getPlayerName(uint256 _pID) external view returns (bytes32);
1768     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1769     function getPlayerAddr(uint256 _pID) external view returns (address);
1770     function getNameFee() external view returns (uint256);
1771     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1772     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1773     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1774 }
1775 
1776 library NameFilter {
1777     /**
1778      * @dev filters name strings
1779      * -converts uppercase to lower case.
1780      * -makes sure it does not start/end with a space
1781      * -makes sure it does not contain multiple spaces in a row
1782      * -cannot be only numbers
1783      * -cannot start with 0x
1784      * -restricts characters to A-Z, a-z, 0-9, and space.
1785      * @return reprocessed string in bytes32 format
1786      */
1787     function nameFilter(string _input)
1788         internal
1789         pure
1790         returns(bytes32)
1791     {
1792         bytes memory _temp = bytes(_input);
1793         uint256 _length = _temp.length;
1794 
1795         //sorry limited to 32 characters
1796         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1797         // make sure it doesnt start with or end with space
1798         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1799         // make sure first two characters are not 0x
1800         if (_temp[0] == 0x30)
1801         {
1802             require(_temp[1] != 0x78, "string cannot start with 0x");
1803             require(_temp[1] != 0x58, "string cannot start with 0X");
1804         }
1805 
1806         // create a bool to track if we have a non number character
1807         bool _hasNonNumber;
1808 
1809         // convert & check
1810         for (uint256 i = 0; i < _length; i++)
1811         {
1812             // if its uppercase A-Z
1813             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1814             {
1815                 // convert to lower case a-z
1816                 _temp[i] = byte(uint(_temp[i]) + 32);
1817 
1818                 // we have a non number
1819                 if (_hasNonNumber == false)
1820                     _hasNonNumber = true;
1821             } else {
1822                 require
1823                 (
1824                     // require character is a space
1825                     _temp[i] == 0x20 ||
1826                     // OR lowercase a-z
1827                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1828                     // or 0-9
1829                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1830                     "string contains invalid characters"
1831                 );
1832                 // make sure theres not 2x spaces in a row
1833                 if (_temp[i] == 0x20)
1834                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1835 
1836                 // see if we have a character other than a number
1837                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1838                     _hasNonNumber = true;
1839             }
1840         }
1841 
1842         require(_hasNonNumber == true, "string cannot be only numbers");
1843 
1844         bytes32 _ret;
1845         assembly {
1846             _ret := mload(add(_temp, 32))
1847         }
1848         return (_ret);
1849     }
1850 }
1851 
1852 /**
1853  * @title SafeMath v0.1.9
1854  * @dev Math operations with safety checks that throw on error
1855  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1856  * - added sqrt
1857  * - added sq
1858  * - added pwr
1859  * - changed asserts to requires with error log outputs
1860  * - removed div, its useless
1861  */
1862 library SafeMath {
1863 
1864     /**
1865     * @dev Multiplies two numbers, throws on overflow.
1866     */
1867     function mul(uint256 a, uint256 b)
1868         internal
1869         pure
1870         returns (uint256 c)
1871     {
1872         if (a == 0) {
1873             return 0;
1874         }
1875         c = a * b;
1876         require(c / a == b, "SafeMath mul failed");
1877         return c;
1878     }
1879 
1880     /**
1881     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1882     */
1883     function sub(uint256 a, uint256 b)
1884         internal
1885         pure
1886         returns (uint256)
1887     {
1888         require(b <= a, "SafeMath sub failed");
1889         return a - b;
1890     }
1891 
1892     /**
1893     * @dev Adds two numbers, throws on overflow.
1894     */
1895     function add(uint256 a, uint256 b)
1896         internal
1897         pure
1898         returns (uint256 c)
1899     {
1900         c = a + b;
1901         require(c >= a, "SafeMath add failed");
1902         return c;
1903     }
1904 
1905     /**
1906      * @dev gives square root of given x.
1907      */
1908     function sqrt(uint256 x)
1909         internal
1910         pure
1911         returns (uint256 y)
1912     {
1913         uint256 z = ((add(x,1)) / 2);
1914         y = x;
1915         while (z < y)
1916         {
1917             y = z;
1918             z = ((add((x / z),z)) / 2);
1919         }
1920     }
1921 
1922     /**
1923      * @dev gives square. multiplies x by x
1924      */
1925     function sq(uint256 x)
1926         internal
1927         pure
1928         returns (uint256)
1929     {
1930         return (mul(x,x));
1931     }
1932 
1933     /**
1934      * @dev x to the power of y
1935      */
1936     function pwr(uint256 x, uint256 y)
1937         internal
1938         pure
1939         returns (uint256)
1940     {
1941         if (x==0)
1942             return (0);
1943         else if (y==0)
1944             return (1);
1945         else
1946         {
1947             uint256 z = x;
1948             for (uint256 i=1; i < y; i++)
1949                 z = mul(z,x);
1950             return (z);
1951         }
1952     }
1953 }