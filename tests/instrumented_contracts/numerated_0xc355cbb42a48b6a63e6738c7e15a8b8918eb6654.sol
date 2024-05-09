1 pragma solidity ^0.4.24;
2 
3 //modified by CryptoTyrion
4 
5 contract F3Devents {
6     // fired whenever a player registers a name
7     event onNewName
8     (
9         uint256 indexed playerID,
10         address indexed playerAddress,
11         bytes32 indexed playerName,
12         bool isNewPlayer,
13         uint256 affiliateID,
14         address affiliateAddress,
15         bytes32 affiliateName,
16         uint256 amountPaid,
17         uint256 timeStamp
18     );
19 
20     // fired at end of buy or reload
21     event onEndTx
22     (
23         uint256 compressedData,
24         uint256 compressedIDs,
25         bytes32 playerName,
26         address playerAddress,
27         uint256 ethIn,
28         uint256 keysBought,
29         address winnerAddr,
30         bytes32 winnerName,
31         uint256 amountWon,
32         uint256 newPot,
33         uint256 P3DAmount,
34         uint256 genAmount,
35         uint256 potAmount,
36         uint256 airDropPot
37     );
38 
39 	// fired whenever theres a withdraw
40     event onWithdraw
41     (
42         uint256 indexed playerID,
43         address playerAddress,
44         bytes32 playerName,
45         uint256 ethOut,
46         uint256 timeStamp
47     );
48 
49     // fired whenever a withdraw forces end round to be ran
50     event onWithdrawAndDistribute
51     (
52         address playerAddress,
53         bytes32 playerName,
54         uint256 ethOut,
55         uint256 compressedData,
56         uint256 compressedIDs,
57         address winnerAddr,
58         bytes32 winnerName,
59         uint256 amountWon,
60         uint256 newPot,
61         uint256 P3DAmount,
62         uint256 genAmount
63     );
64 
65     // (fomo3d short only) fired whenever a player tries a buy after round timer
66     // hit zero, and causes end round to be ran.
67     event onBuyAndDistribute
68     (
69         address playerAddress,
70         bytes32 playerName,
71         uint256 ethIn,
72         uint256 compressedData,
73         uint256 compressedIDs,
74         address winnerAddr,
75         bytes32 winnerName,
76         uint256 amountWon,
77         uint256 newPot,
78         uint256 P3DAmount,
79         uint256 genAmount
80     );
81 
82     // (fomo3d short only) fired whenever a player tries a reload after round timer
83     // hit zero, and causes end round to be ran.
84     event onReLoadAndDistribute
85     (
86         address playerAddress,
87         bytes32 playerName,
88         uint256 compressedData,
89         uint256 compressedIDs,
90         address winnerAddr,
91         bytes32 winnerName,
92         uint256 amountWon,
93         uint256 newPot,
94         uint256 P3DAmount,
95         uint256 genAmount
96     );
97 
98     // fired whenever an affiliate is paid
99     event onAffiliatePayout
100     (
101         uint256 indexed affiliateID,
102         address affiliateAddress,
103         bytes32 affiliateName,
104         uint256 indexed roundID,
105         uint256 indexed buyerID,
106         uint256 amount,
107         uint256 timeStamp
108     );
109 
110     // received pot swap deposit
111     event onPotSwapDeposit
112     (
113         uint256 roundID,
114         uint256 amountAddedToPot
115     );
116 }
117 
118 //==============================================================================
119 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
120 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
121 //====================================|=========================================
122 
123 contract modularShort is F3Devents {}
124 
125 contract FoMoFAIR is modularShort {
126     using SafeMath for *;
127     using NameFilter for string;
128     using F3DKeysCalcShort for uint256;
129 
130     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xAcd1aE32f6519ED27eC245462d4154584451bb38);
131 
132 //==============================================================================
133 //     _ _  _  |`. _     _ _ |_ | _  _  .
134 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
135 //=================_|===========================================================
136     address private admin = msg.sender;
137     string constant public name = "FOMO FAIR";
138     string constant public symbol = "FAIR";
139     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
140     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
141     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
142     uint256 constant private rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
143     uint256 constant private rndMax_ = 1 hours;                // max length a round timer can be
144 //==============================================================================
145 //     _| _ _|_ _    _ _ _|_    _   .
146 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
147 //=============================|================================================
148     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
149     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
150     uint256 public rID_;    // round id number / total rounds that have happened
151 //****************
152 // PLAYER DATA
153 //****************
154     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
155     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
156     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
157     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
158     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
159 //****************
160 // ROUND DATA
161 //****************
162     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
163     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
164 //****************
165 // TEAM FEE DATA
166 //****************
167     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
168     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
169 //==============================================================================
170 //     _ _  _  __|_ _    __|_ _  _  .
171 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
172 //==============================================================================
173     constructor()
174         public
175     {
176 		// Team allocation structures
177         // 0 = whales
178         // 1 = bears
179         // 2 = sneks
180         // 3 = bulls
181 
182 		// Team allocation percentages
183         // (F3D, P3D) + (Pot , Referrals, Community)
184             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
185         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
186         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
187         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
188         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
189 
190         // how to split up the final pot based on which team was picked
191         // (F3D, P3D)
192         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
193         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
194         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
195         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
196 	}
197 //==============================================================================
198 //     _ _  _  _|. |`. _  _ _  .
199 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
200 //==============================================================================
201     /**
202      * @dev used to make sure no one can interact with contract until it has
203      * been activated.
204      */
205     modifier isActivated() {
206         require(activated_ == true, "its not ready yet.  check ?eta in discord");
207         _;
208     }
209 
210     /**
211      * @dev prevents contracts from interacting with fomo3d
212      */
213     modifier isHuman() {
214         address _addr = msg.sender;
215         uint256 _codeLength;
216 
217         assembly {_codeLength := extcodesize(_addr)}
218         require(_codeLength == 0, "sorry humans only");
219         _;
220     }
221 
222     /**
223      * @dev sets boundaries for incoming tx
224      */
225     modifier isWithinLimits(uint256 _eth) {
226         require(_eth >= 1000000000, "pocket lint: not a valid currency");
227         require(_eth <= 100000000000000000000000, "no vitalik, no");
228         _;
229     }
230 
231 //==============================================================================
232 //     _    |_ |. _   |`    _  __|_. _  _  _  .
233 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
234 //====|=========================================================================
235     /**
236      * @dev emergency buy uses last stored affiliate ID and team snek
237      */
238     function()
239         isActivated()
240         isHuman()
241         isWithinLimits(msg.value)
242         public
243         payable
244     {
245         // set up our tx event data and determine if player is new or not
246         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
247 
248         // fetch player id
249         uint256 _pID = pIDxAddr_[msg.sender];
250 
251         // buy core
252         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
253     }
254 
255     /**
256      * @dev converts all incoming ethereum to keys.
257      * -functionhash- 0x8f38f309 (using ID for affiliate)
258      * -functionhash- 0x98a0871d (using address for affiliate)
259      * -functionhash- 0xa65b37a1 (using name for affiliate)
260      * @param _affCode the ID/address/name of the player who gets the affiliate fee
261      * @param _team what team is the player playing for?
262      */
263     function buyXid(uint256 _affCode, uint256 _team)
264         isActivated()
265         isHuman()
266         isWithinLimits(msg.value)
267         public
268         payable
269     {
270         // set up our tx event data and determine if player is new or not
271         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
272 
273         // fetch player id
274         uint256 _pID = pIDxAddr_[msg.sender];
275 
276         // manage affiliate residuals
277         // if no affiliate code was given or player tried to use their own, lolz
278         if (_affCode == 0 || _affCode == _pID)
279         {
280             // use last stored affiliate code
281             _affCode = plyr_[_pID].laff;
282 
283         // if affiliate code was given & its not the same as previously stored
284         } else if (_affCode != plyr_[_pID].laff) {
285             // update last affiliate
286             plyr_[_pID].laff = _affCode;
287         }
288 
289         // verify a valid team was selected
290         _team = verifyTeam(_team);
291 
292         // buy core
293         buyCore(_pID, _affCode, _team, _eventData_);
294     }
295 
296     function buyXaddr(address _affCode, uint256 _team)
297         isActivated()
298         isHuman()
299         isWithinLimits(msg.value)
300         public
301         payable
302     {
303         // set up our tx event data and determine if player is new or not
304         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
305 
306         // fetch player id
307         uint256 _pID = pIDxAddr_[msg.sender];
308 
309         // manage affiliate residuals
310         uint256 _affID;
311         // if no affiliate code was given or player tried to use their own, lolz
312         if (_affCode == address(0) || _affCode == msg.sender)
313         {
314             // use last stored affiliate code
315             _affID = plyr_[_pID].laff;
316 
317         // if affiliate code was given
318         } else {
319             // get affiliate ID from aff Code
320             _affID = pIDxAddr_[_affCode];
321 
322             // if affID is not the same as previously stored
323             if (_affID != plyr_[_pID].laff)
324             {
325                 // update last affiliate
326                 plyr_[_pID].laff = _affID;
327             }
328         }
329 
330         // verify a valid team was selected
331         _team = verifyTeam(_team);
332 
333         // buy core
334         buyCore(_pID, _affID, _team, _eventData_);
335     }
336 
337     function buyXname(bytes32 _affCode, uint256 _team)
338         isActivated()
339         isHuman()
340         isWithinLimits(msg.value)
341         public
342         payable
343     {
344         // set up our tx event data and determine if player is new or not
345         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
346 
347         // fetch player id
348         uint256 _pID = pIDxAddr_[msg.sender];
349 
350         // manage affiliate residuals
351         uint256 _affID;
352         // if no affiliate code was given or player tried to use their own, lolz
353         if (_affCode == '' || _affCode == plyr_[_pID].name)
354         {
355             // use last stored affiliate code
356             _affID = plyr_[_pID].laff;
357 
358         // if affiliate code was given
359         } else {
360             // get affiliate ID from aff Code
361             _affID = pIDxName_[_affCode];
362 
363             // if affID is not the same as previously stored
364             if (_affID != plyr_[_pID].laff)
365             {
366                 // update last affiliate
367                 plyr_[_pID].laff = _affID;
368             }
369         }
370 
371         // verify a valid team was selected
372         _team = verifyTeam(_team);
373 
374         // buy core
375         buyCore(_pID, _affID, _team, _eventData_);
376     }
377 
378     /**
379      * @dev essentially the same as buy, but instead of you sending ether
380      * from your wallet, it uses your unwithdrawn earnings.
381      * -functionhash- 0x349cdcac (using ID for affiliate)
382      * -functionhash- 0x82bfc739 (using address for affiliate)
383      * -functionhash- 0x079ce327 (using name for affiliate)
384      * @param _affCode the ID/address/name of the player who gets the affiliate fee
385      * @param _team what team is the player playing for?
386      * @param _eth amount of earnings to use (remainder returned to gen vault)
387      */
388     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
389         isActivated()
390         isHuman()
391         isWithinLimits(_eth)
392         public
393     {
394         // set up our tx event data
395         F3Ddatasets.EventReturns memory _eventData_;
396 
397         // fetch player ID
398         uint256 _pID = pIDxAddr_[msg.sender];
399 
400         // manage affiliate residuals
401         // if no affiliate code was given or player tried to use their own, lolz
402         if (_affCode == 0 || _affCode == _pID)
403         {
404             // use last stored affiliate code
405             _affCode = plyr_[_pID].laff;
406 
407         // if affiliate code was given & its not the same as previously stored
408         } else if (_affCode != plyr_[_pID].laff) {
409             // update last affiliate
410             plyr_[_pID].laff = _affCode;
411         }
412 
413         // verify a valid team was selected
414         _team = verifyTeam(_team);
415 
416         // reload core
417         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
418     }
419 
420     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
421         isActivated()
422         isHuman()
423         isWithinLimits(_eth)
424         public
425     {
426         // set up our tx event data
427         F3Ddatasets.EventReturns memory _eventData_;
428 
429         // fetch player ID
430         uint256 _pID = pIDxAddr_[msg.sender];
431 
432         // manage affiliate residuals
433         uint256 _affID;
434         // if no affiliate code was given or player tried to use their own, lolz
435         if (_affCode == address(0) || _affCode == msg.sender)
436         {
437             // use last stored affiliate code
438             _affID = plyr_[_pID].laff;
439 
440         // if affiliate code was given
441         } else {
442             // get affiliate ID from aff Code
443             _affID = pIDxAddr_[_affCode];
444 
445             // if affID is not the same as previously stored
446             if (_affID != plyr_[_pID].laff)
447             {
448                 // update last affiliate
449                 plyr_[_pID].laff = _affID;
450             }
451         }
452 
453         // verify a valid team was selected
454         _team = verifyTeam(_team);
455 
456         // reload core
457         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
458     }
459 
460     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
461         isActivated()
462         isHuman()
463         isWithinLimits(_eth)
464         public
465     {
466         // set up our tx event data
467         F3Ddatasets.EventReturns memory _eventData_;
468 
469         // fetch player ID
470         uint256 _pID = pIDxAddr_[msg.sender];
471 
472         // manage affiliate residuals
473         uint256 _affID;
474         // if no affiliate code was given or player tried to use their own, lolz
475         if (_affCode == '' || _affCode == plyr_[_pID].name)
476         {
477             // use last stored affiliate code
478             _affID = plyr_[_pID].laff;
479 
480         // if affiliate code was given
481         } else {
482             // get affiliate ID from aff Code
483             _affID = pIDxName_[_affCode];
484 
485             // if affID is not the same as previously stored
486             if (_affID != plyr_[_pID].laff)
487             {
488                 // update last affiliate
489                 plyr_[_pID].laff = _affID;
490             }
491         }
492 
493         // verify a valid team was selected
494         _team = verifyTeam(_team);
495 
496         // reload core
497         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
498     }
499 
500     /**
501      * @dev withdraws all of your earnings.
502      * -functionhash- 0x3ccfd60b
503      */
504     function withdraw()
505         isActivated()
506         isHuman()
507         public
508     {
509         // setup local rID
510         uint256 _rID = rID_;
511 
512         // grab time
513         uint256 _now = now;
514 
515         // fetch player ID
516         uint256 _pID = pIDxAddr_[msg.sender];
517 
518         // setup temp var for player eth
519         uint256 _eth;
520 
521         // check to see if round has ended and no one has run round end yet
522         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
523         {
524             // set up our tx event data
525             F3Ddatasets.EventReturns memory _eventData_;
526 
527             // end the round (distributes pot)
528 			round_[_rID].ended = true;
529             _eventData_ = endRound(_eventData_);
530 
531 			// get their earnings
532             _eth = withdrawEarnings(_pID);
533 
534             // gib moni
535             if (_eth > 0)
536                 plyr_[_pID].addr.transfer(_eth);
537 
538             // build event data
539             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
540             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
541 
542             // fire withdraw and distribute event
543             emit F3Devents.onWithdrawAndDistribute
544             (
545                 msg.sender,
546                 plyr_[_pID].name,
547                 _eth,
548                 _eventData_.compressedData,
549                 _eventData_.compressedIDs,
550                 _eventData_.winnerAddr,
551                 _eventData_.winnerName,
552                 _eventData_.amountWon,
553                 _eventData_.newPot,
554                 _eventData_.P3DAmount,
555                 _eventData_.genAmount
556             );
557 
558         // in any other situation
559         } else {
560             // get their earnings
561             _eth = withdrawEarnings(_pID);
562 
563             // gib moni
564             if (_eth > 0)
565                 plyr_[_pID].addr.transfer(_eth);
566 
567             // fire withdraw event
568             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
569         }
570     }
571 
572     /**
573      * @dev use these to register names.  they are just wrappers that will send the
574      * registration requests to the PlayerBook contract.  So registering here is the
575      * same as registering there.  UI will always display the last name you registered.
576      * but you will still own all previously registered names to use as affiliate
577      * links.
578      * - must pay a registration fee.
579      * - name must be unique
580      * - names will be converted to lowercase
581      * - name cannot start or end with a space
582      * - cannot have more than 1 space in a row
583      * - cannot be only numbers
584      * - cannot start with 0x
585      * - name must be at least 1 char
586      * - max length of 32 characters long
587      * - allowed characters: a-z, 0-9, and space
588      * -functionhash- 0x921dec21 (using ID for affiliate)
589      * -functionhash- 0x3ddd4698 (using address for affiliate)
590      * -functionhash- 0x685ffd83 (using name for affiliate)
591      * @param _nameString players desired name
592      * @param _affCode affiliate ID, address, or name of who referred you
593      * @param _all set to true if you want this to push your info to all games
594      * (this might cost a lot of gas)
595      */
596     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
597         isHuman()
598         public
599         payable
600     {
601         bytes32 _name = _nameString.nameFilter();
602         address _addr = msg.sender;
603         uint256 _paid = msg.value;
604         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
605 
606         uint256 _pID = pIDxAddr_[_addr];
607 
608         // fire event
609         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
610     }
611 
612     function registerNameXaddr(string _nameString, address _affCode, bool _all)
613         isHuman()
614         public
615         payable
616     {
617         bytes32 _name = _nameString.nameFilter();
618         address _addr = msg.sender;
619         uint256 _paid = msg.value;
620         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
621 
622         uint256 _pID = pIDxAddr_[_addr];
623 
624         // fire event
625         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
626     }
627 
628     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
629         isHuman()
630         public
631         payable
632     {
633         bytes32 _name = _nameString.nameFilter();
634         address _addr = msg.sender;
635         uint256 _paid = msg.value;
636         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
637 
638         uint256 _pID = pIDxAddr_[_addr];
639 
640         // fire event
641         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
642     }
643 //==============================================================================
644 //     _  _ _|__|_ _  _ _  .
645 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
646 //=====_|=======================================================================
647     /**
648      * @dev return the price buyer will pay for next 1 individual key.
649      * -functionhash- 0x018a25e8
650      * @return price for next key bought (in wei format)
651      */
652     function getBuyPrice()
653         public
654         view
655         returns(uint256)
656     {
657         // setup local rID
658         uint256 _rID = rID_;
659 
660         // grab time
661         uint256 _now = now;
662 
663         // are we in a round?
664         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
665             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
666         else // rounds over.  need price for new round
667             return ( 75000000000000 ); // init
668     }
669 
670     /**
671      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
672      * provider
673      * -functionhash- 0xc7e284b8
674      * @return time left in seconds
675      */
676     function getTimeLeft()
677         public
678         view
679         returns(uint256)
680     {
681         // setup local rID
682         uint256 _rID = rID_;
683 
684         // grab time
685         uint256 _now = now;
686 
687         if (_now < round_[_rID].end)
688             if (_now > round_[_rID].strt + rndGap_)
689                 return( (round_[_rID].end).sub(_now) );
690             else
691                 return( (round_[_rID].strt + rndGap_).sub(_now) );
692         else
693             return(0);
694     }
695 
696     /**
697      * @dev returns player earnings per vaults
698      * -functionhash- 0x63066434
699      * @return winnings vault
700      * @return general vault
701      * @return affiliate vault
702      */
703     function getPlayerVaults(uint256 _pID)
704         public
705         view
706         returns(uint256 ,uint256, uint256)
707     {
708         // setup local rID
709         uint256 _rID = rID_;
710 
711         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
712         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
713         {
714             // if player is winner
715             if (round_[_rID].plyr == _pID)
716             {
717                 return
718                 (
719                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
720                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
721                     plyr_[_pID].aff
722                 );
723             // if player is not the winner
724             } else {
725                 return
726                 (
727                     plyr_[_pID].win,
728                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
729                     plyr_[_pID].aff
730                 );
731             }
732 
733         // if round is still going on, or round has ended and round end has been ran
734         } else {
735             return
736             (
737                 plyr_[_pID].win,
738                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
739                 plyr_[_pID].aff
740             );
741         }
742     }
743 
744     /**
745      * solidity hates stack limits.  this lets us avoid that hate
746      */
747     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
748         private
749         view
750         returns(uint256)
751     {
752         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
753     }
754 
755     /**
756      * @dev returns all current round info needed for front end
757      * -functionhash- 0x747dff42
758      * @return eth invested during ICO phase
759      * @return round id
760      * @return total keys for round
761      * @return time round ends
762      * @return time round started
763      * @return current pot
764      * @return current team ID & player ID in lead
765      * @return current player in leads address
766      * @return current player in leads name
767      * @return whales eth in for round
768      * @return bears eth in for round
769      * @return sneks eth in for round
770      * @return bulls eth in for round
771      * @return airdrop tracker # & airdrop pot
772      */
773     function getCurrentRoundInfo()
774         public
775         view
776         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
777     {
778         // setup local rID
779         uint256 _rID = rID_;
780 
781         return
782         (
783             round_[_rID].ico,               //0
784             _rID,                           //1
785             round_[_rID].keys,              //2
786             round_[_rID].end,               //3
787             round_[_rID].strt,              //4
788             round_[_rID].pot,               //5
789             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
790             plyr_[round_[_rID].plyr].addr,  //7
791             plyr_[round_[_rID].plyr].name,  //8
792             rndTmEth_[_rID][0],             //9
793             rndTmEth_[_rID][1],             //10
794             rndTmEth_[_rID][2],             //11
795             rndTmEth_[_rID][3],             //12
796             airDropTracker_ + (airDropPot_ * 1000)              //13
797         );
798     }
799 
800     /**
801      * @dev returns player info based on address.  if no address is given, it will
802      * use msg.sender
803      * -functionhash- 0xee0b5d8b
804      * @param _addr address of the player you want to lookup
805      * @return player ID
806      * @return player name
807      * @return keys owned (current round)
808      * @return winnings vault
809      * @return general vault
810      * @return affiliate vault
811 	 * @return player round eth
812      */
813     function getPlayerInfoByAddress(address _addr)
814         public
815         view
816         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
817     {
818         // setup local rID
819         uint256 _rID = rID_;
820 
821         if (_addr == address(0))
822         {
823             _addr == msg.sender;
824         }
825         uint256 _pID = pIDxAddr_[_addr];
826 
827         return
828         (
829             _pID,                               //0
830             plyr_[_pID].name,                   //1
831             plyrRnds_[_pID][_rID].keys,         //2
832             plyr_[_pID].win,                    //3
833             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
834             plyr_[_pID].aff,                    //5
835             plyrRnds_[_pID][_rID].eth           //6
836         );
837     }
838 
839 //==============================================================================
840 //     _ _  _ _   | _  _ . _  .
841 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
842 //=====================_|=======================================================
843     /**
844      * @dev logic runs whenever a buy order is executed.  determines how to handle
845      * incoming eth depending on if we are in an active round or not
846      */
847     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
848         private
849     {
850         // setup local rID
851         uint256 _rID = rID_;
852 
853         // grab time
854         uint256 _now = now;
855 
856         // if round is active
857         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
858         {
859             // call core
860             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
861 
862         // if round is not active
863         } else {
864             // check to see if end round needs to be ran
865             if (_now > round_[_rID].end && round_[_rID].ended == false)
866             {
867                 // end the round (distributes pot) & start new round
868 			    round_[_rID].ended = true;
869                 _eventData_ = endRound(_eventData_);
870 
871                 // build event data
872                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
873                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
874 
875                 // fire buy and distribute event
876                 emit F3Devents.onBuyAndDistribute
877                 (
878                     msg.sender,
879                     plyr_[_pID].name,
880                     msg.value,
881                     _eventData_.compressedData,
882                     _eventData_.compressedIDs,
883                     _eventData_.winnerAddr,
884                     _eventData_.winnerName,
885                     _eventData_.amountWon,
886                     _eventData_.newPot,
887                     _eventData_.P3DAmount,
888                     _eventData_.genAmount
889                 );
890             }
891 
892             // put eth in players vault
893             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
894         }
895     }
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
910         // if round is active
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
960         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
961         {
962             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
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
990             // manage airdrops
991             if (_eth >= 100000000000000000)
992             {
993             airDropTracker_++;
994             if (airdrop() == true)
995             {
996                 // gib muni
997                 uint256 _prize;
998                 if (_eth >= 10000000000000000000)
999                 {
1000                     // calculate prize and give it to winner
1001                     _prize = ((airDropPot_).mul(75)) / 100;
1002                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1003 
1004                     // adjust airDropPot
1005                     airDropPot_ = (airDropPot_).sub(_prize);
1006 
1007                     // let event know a tier 3 prize was won
1008                     _eventData_.compressedData += 300000000000000000000000000000000;
1009                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1010                     // calculate prize and give it to winner
1011                     _prize = ((airDropPot_).mul(50)) / 100;
1012                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1013 
1014                     // adjust airDropPot
1015                     airDropPot_ = (airDropPot_).sub(_prize);
1016 
1017                     // let event know a tier 2 prize was won
1018                     _eventData_.compressedData += 200000000000000000000000000000000;
1019                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1020                     // calculate prize and give it to winner
1021                     _prize = ((airDropPot_).mul(25)) / 100;
1022                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1023 
1024                     // adjust airDropPot
1025                     airDropPot_ = (airDropPot_).sub(_prize);
1026 
1027                     // let event know a tier 3 prize was won
1028                     _eventData_.compressedData += 300000000000000000000000000000000;
1029                 }
1030                 // set airdrop happened bool to true
1031                 _eventData_.compressedData += 10000000000000000000000000000000;
1032                 // let event know how much was won
1033                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1034 
1035                 // reset air drop tracker
1036                 airDropTracker_ = 0;
1037             }
1038         }
1039 
1040             // store the air drop tracker number (number of buys since last airdrop)
1041             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1042 
1043             // update player
1044             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1045             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1046 
1047             // update round
1048             round_[_rID].keys = _keys.add(round_[_rID].keys);
1049             round_[_rID].eth = _eth.add(round_[_rID].eth);
1050             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1051 
1052             // distribute eth
1053             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1054             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1055 
1056             // call end tx function to fire end tx event.
1057 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1058         }
1059     }
1060 //==============================================================================
1061 //     _ _ | _   | _ _|_ _  _ _  .
1062 //    (_(_||(_|_||(_| | (_)| _\  .
1063 //==============================================================================
1064     /**
1065      * @dev calculates unmasked earnings (just calculates, does not update mask)
1066      * @return earnings in wei format
1067      */
1068     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1069         private
1070         view
1071         returns(uint256)
1072     {
1073         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1074     }
1075 
1076     /**
1077      * @dev returns the amount of keys you would get given an amount of eth.
1078      * -functionhash- 0xce89c80c
1079      * @param _rID round ID you want price for
1080      * @param _eth amount of eth sent in
1081      * @return keys received
1082      */
1083     function calcKeysReceived(uint256 _rID, uint256 _eth)
1084         public
1085         view
1086         returns(uint256)
1087     {
1088         // grab time
1089         uint256 _now = now;
1090 
1091         // are we in a round?
1092         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1093             return ( (round_[_rID].eth).keysRec(_eth) );
1094         else // rounds over.  need keys for new round
1095             return ( (_eth).keys() );
1096     }
1097 
1098     /**
1099      * @dev returns current eth price for X keys.
1100      * -functionhash- 0xcf808000
1101      * @param _keys number of keys desired (in 18 decimal format)
1102      * @return amount of eth needed to send
1103      */
1104     function iWantXKeys(uint256 _keys)
1105         public
1106         view
1107         returns(uint256)
1108     {
1109         // setup local rID
1110         uint256 _rID = rID_;
1111 
1112         // grab time
1113         uint256 _now = now;
1114 
1115         // are we in a round?
1116         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1117             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1118         else // rounds over.  need price for new round
1119             return ( (_keys).eth() );
1120     }
1121 //==============================================================================
1122 //    _|_ _  _ | _  .
1123 //     | (_)(_)|_\  .
1124 //==============================================================================
1125     /**
1126 	 * @dev receives name/player info from names contract
1127      */
1128     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1129         external
1130     {
1131         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1132         if (pIDxAddr_[_addr] != _pID)
1133             pIDxAddr_[_addr] = _pID;
1134         if (pIDxName_[_name] != _pID)
1135             pIDxName_[_name] = _pID;
1136         if (plyr_[_pID].addr != _addr)
1137             plyr_[_pID].addr = _addr;
1138         if (plyr_[_pID].name != _name)
1139             plyr_[_pID].name = _name;
1140         if (plyr_[_pID].laff != _laff)
1141             plyr_[_pID].laff = _laff;
1142         if (plyrNames_[_pID][_name] == false)
1143             plyrNames_[_pID][_name] = true;
1144     }
1145 
1146     /**
1147      * @dev receives entire player name list
1148      */
1149     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1150         external
1151     {
1152         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1153         if(plyrNames_[_pID][_name] == false)
1154             plyrNames_[_pID][_name] = true;
1155     }
1156 
1157     /**
1158      * @dev gets existing or registers new pID.  use this when a player may be new
1159      * @return pID
1160      */
1161     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1162         private
1163         returns (F3Ddatasets.EventReturns)
1164     {
1165         uint256 _pID = pIDxAddr_[msg.sender];
1166         // if player is new to this version of fomo3d
1167         if (_pID == 0)
1168         {
1169             // grab their player ID, name and last aff ID, from player names contract
1170             _pID = PlayerBook.getPlayerID(msg.sender);
1171             bytes32 _name = PlayerBook.getPlayerName(_pID);
1172             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1173 
1174             // set up player account
1175             pIDxAddr_[msg.sender] = _pID;
1176             plyr_[_pID].addr = msg.sender;
1177 
1178             if (_name != "")
1179             {
1180                 pIDxName_[_name] = _pID;
1181                 plyr_[_pID].name = _name;
1182                 plyrNames_[_pID][_name] = true;
1183             }
1184 
1185             if (_laff != 0 && _laff != _pID)
1186                 plyr_[_pID].laff = _laff;
1187 
1188             // set the new player bool to true
1189             _eventData_.compressedData = _eventData_.compressedData + 1;
1190         }
1191         return (_eventData_);
1192     }
1193 
1194     /**
1195      * @dev checks to make sure user picked a valid team.  if not sets team
1196      * to default (sneks)
1197      */
1198     function verifyTeam(uint256 _team)
1199         private
1200         pure
1201         returns (uint256)
1202     {
1203         if (_team < 0 || _team > 3)
1204             return(2);
1205         else
1206             return(_team);
1207     }
1208 
1209     /**
1210      * @dev decides if round end needs to be run & new round started.  and if
1211      * player unmasked earnings from previously played rounds need to be moved.
1212      */
1213     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1214         private
1215         returns (F3Ddatasets.EventReturns)
1216     {
1217         // if player has played a previous round, move their unmasked earnings
1218         // from that round to gen vault.
1219         if (plyr_[_pID].lrnd != 0)
1220             updateGenVault(_pID, plyr_[_pID].lrnd);
1221 
1222         // update player's last round played
1223         plyr_[_pID].lrnd = rID_;
1224 
1225         // set the joined round bool to true
1226         _eventData_.compressedData = _eventData_.compressedData + 10;
1227 
1228         return(_eventData_);
1229     }
1230 
1231     /**
1232      * @dev ends the round. manages paying out winner/splitting up pot
1233      */
1234     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1235         private
1236         returns (F3Ddatasets.EventReturns)
1237     {
1238         // setup local rID
1239         uint256 _rID = rID_;
1240 
1241         // grab our winning player and team id's
1242         uint256 _winPID = round_[_rID].plyr;
1243         uint256 _winTID = round_[_rID].team;
1244 
1245         // grab our pot amount
1246         uint256 _pot = round_[_rID].pot;
1247 
1248         // calculate our winner share, community rewards, gen share,
1249         // p3d share, and amount reserved for next pot
1250         uint256 _win = (_pot.mul(48)) / 100;
1251         uint256 _com = (_pot / 50);
1252         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1253         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1254         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1255 
1256         // calculate ppt for round mask
1257         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1258         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1259         if (_dust > 0)
1260         {
1261             _gen = _gen.sub(_dust);
1262             _res = _res.add(_dust);
1263         }
1264 
1265         // pay our winner
1266         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1267 
1268 
1269         round_[_rID].pot = _pot.add(_p3d).add(_com);
1270 
1271         // distribute gen portion to key holders
1272         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1273 
1274         // prepare event data
1275         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1276         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1277         _eventData_.winnerAddr = plyr_[_winPID].addr;
1278         _eventData_.winnerName = plyr_[_winPID].name;
1279         _eventData_.amountWon = _win;
1280         _eventData_.genAmount = _gen;
1281         _eventData_.P3DAmount = _p3d;
1282         _eventData_.newPot = _res;
1283 
1284         // start next round
1285         rID_++;
1286         _rID++;
1287         round_[_rID].strt = now;
1288         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1289         round_[_rID].pot = _res;
1290 
1291         return(_eventData_);
1292     }
1293 
1294     /**
1295      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1296      */
1297     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1298         private
1299     {
1300         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1301         if (_earnings > 0)
1302         {
1303             // put in gen vault
1304             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1305             // zero out their earnings by updating mask
1306             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1307         }
1308     }
1309 
1310     /**
1311      * @dev updates round timer based on number of whole keys bought.
1312      */
1313     function updateTimer(uint256 _keys, uint256 _rID)
1314         private
1315     {
1316         // grab time
1317         uint256 _now = now;
1318 
1319         // calculate time based on number of keys bought
1320         uint256 _newTime;
1321         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1322             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1323         else
1324             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1325 
1326         // compare to max and set new end time
1327         if (_newTime < (rndMax_).add(_now))
1328             round_[_rID].end = _newTime;
1329         else
1330             round_[_rID].end = rndMax_.add(_now);
1331     }
1332 
1333     /**
1334      * @dev generates a random number between 0-99 and checks to see if thats
1335      * resulted in an airdrop win
1336      * @return do we have a winner?
1337      */
1338     function airdrop()
1339         private
1340         view
1341         returns(bool)
1342     {
1343         uint256 seed = uint256(keccak256(abi.encodePacked(
1344 
1345             (block.timestamp).add
1346             (block.difficulty).add
1347             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1348             (block.gaslimit).add
1349             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1350             (block.number)
1351 
1352         )));
1353         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1354             return(true);
1355         else
1356             return(false);
1357     }
1358 
1359     /**
1360      * @dev distributes eth based on fees to com, aff, and p3d
1361      */
1362     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1363         private
1364         returns(F3Ddatasets.EventReturns)
1365     {
1366         // pay 3% out to community rewards
1367         uint256 _p1 = _eth / 100;
1368         uint256 _com = _eth / 50;
1369         _com = _com.add(_p1);
1370 
1371         uint256 _p3d;
1372 
1373         admin.transfer(_com);
1374 
1375         // distribute share to affiliate
1376         uint256 _aff = _eth / 10;
1377 
1378         // decide what to do with affiliate share of fees
1379         // affiliate must not be self, and must have a name registered
1380         if (_affID != _pID && plyr_[_affID].name != '') {
1381             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1382             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1383         } else {
1384             _p3d = _aff;
1385         }
1386 
1387         // pay out p3d
1388         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1389         if (_p3d > 0)
1390         {
1391 
1392             round_[_rID].pot = round_[_rID].pot.add(_p3d);
1393 
1394             // set up event data
1395             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1396         }
1397 
1398         return(_eventData_);
1399     }
1400 
1401     function potSwap()
1402         external
1403         payable
1404     {
1405         // setup local rID
1406         uint256 _rID = rID_ + 1;
1407 
1408         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1409         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1410     }
1411 
1412     /**
1413      * @dev distributes eth based on fees to gen and pot
1414      */
1415     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1416         private
1417         returns(F3Ddatasets.EventReturns)
1418     {
1419         // calculate gen share
1420         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1421 
1422         // toss 1% into airdrop pot
1423         uint256 _air = (_eth / 100);
1424         airDropPot_ = airDropPot_.add(_air);
1425 
1426         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1427         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1428 
1429         // calculate pot
1430         uint256 _pot = _eth.sub(_gen);
1431 
1432         // distribute gen share (thats what updateMasks() does) and adjust
1433         // balances for dust.
1434         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1435         if (_dust > 0)
1436             _gen = _gen.sub(_dust);
1437 
1438         // add eth to pot
1439         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1440 
1441         // set up event data
1442         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1443         _eventData_.potAmount = _pot;
1444 
1445         return(_eventData_);
1446     }
1447 
1448     /**
1449      * @dev updates masks for round and player when keys are bought
1450      * @return dust left over
1451      */
1452     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1453         private
1454         returns(uint256)
1455     {
1456         /* MASKING NOTES
1457             earnings masks are a tricky thing for people to wrap their minds around.
1458             the basic thing to understand here.  is were going to have a global
1459             tracker based on profit per share for each round, that increases in
1460             relevant proportion to the increase in share supply.
1461 
1462             the player will have an additional mask that basically says "based
1463             on the rounds mask, my shares, and how much i've already withdrawn,
1464             how much is still owed to me?"
1465         */
1466 
1467         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1468         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1469         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1470 
1471         // calculate player earning from their own buy (only based on the keys
1472         // they just bought).  & update player earnings mask
1473         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1474         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1475 
1476         // calculate & return dust
1477         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1478     }
1479 
1480     /**
1481      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1482      * @return earnings in wei format
1483      */
1484     function withdrawEarnings(uint256 _pID)
1485         private
1486         returns(uint256)
1487     {
1488         // update gen vault
1489         updateGenVault(_pID, plyr_[_pID].lrnd);
1490 
1491         // from vaults
1492         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1493         if (_earnings > 0)
1494         {
1495             plyr_[_pID].win = 0;
1496             plyr_[_pID].gen = 0;
1497             plyr_[_pID].aff = 0;
1498         }
1499 
1500         return(_earnings);
1501     }
1502 
1503     /**
1504      * @dev prepares compression data and fires event for buy or reload tx's
1505      */
1506     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1507         private
1508     {
1509         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1510         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1511 
1512         emit F3Devents.onEndTx
1513         (
1514             _eventData_.compressedData,
1515             _eventData_.compressedIDs,
1516             plyr_[_pID].name,
1517             msg.sender,
1518             _eth,
1519             _keys,
1520             _eventData_.winnerAddr,
1521             _eventData_.winnerName,
1522             _eventData_.amountWon,
1523             _eventData_.newPot,
1524             _eventData_.P3DAmount,
1525             _eventData_.genAmount,
1526             _eventData_.potAmount,
1527             airDropPot_
1528         );
1529     }
1530 //==============================================================================
1531 //    (~ _  _    _._|_    .
1532 //    _)(/_(_|_|| | | \/  .
1533 //====================/=========================================================
1534     /** upon contract deploy, it will be deactivated.  this is a one time
1535      * use function that will activate the contract.  we do this so devs
1536      * have time to set things up on the web end                            **/
1537     bool public activated_ = false;
1538     function activate()
1539         public
1540     {
1541         // only team just can activate
1542         require(msg.sender == admin, "only admin can activate");
1543 
1544 
1545         // can only be ran once
1546         require(activated_ == false, "FOMO Short already activated");
1547 
1548         // activate the contract
1549         activated_ = true;
1550 
1551         // lets start first round
1552         rID_ = 1;
1553             round_[1].strt = now + rndExtra_ - rndGap_;
1554             round_[1].end = now + rndInit_ + rndExtra_;
1555     }
1556 }
1557 
1558 //==============================================================================
1559 //   __|_ _    __|_ _  .
1560 //  _\ | | |_|(_ | _\  .
1561 //==============================================================================
1562 library F3Ddatasets {
1563     //compressedData key
1564     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1565         // 0 - new player (bool)
1566         // 1 - joined round (bool)
1567         // 2 - new  leader (bool)
1568         // 3-5 - air drop tracker (uint 0-999)
1569         // 6-16 - round end time
1570         // 17 - winnerTeam
1571         // 18 - 28 timestamp
1572         // 29 - team
1573         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1574         // 31 - airdrop happened bool
1575         // 32 - airdrop tier
1576         // 33 - airdrop amount won
1577     //compressedIDs key
1578     // [77-52][51-26][25-0]
1579         // 0-25 - pID
1580         // 26-51 - winPID
1581         // 52-77 - rID
1582     struct EventReturns {
1583         uint256 compressedData;
1584         uint256 compressedIDs;
1585         address winnerAddr;         // winner address
1586         bytes32 winnerName;         // winner name
1587         uint256 amountWon;          // amount won
1588         uint256 newPot;             // amount in new pot
1589         uint256 P3DAmount;          // amount distributed to p3d
1590         uint256 genAmount;          // amount distributed to gen
1591         uint256 potAmount;          // amount added to pot
1592     }
1593     struct Player {
1594         address addr;   // player address
1595         bytes32 name;   // player name
1596         uint256 win;    // winnings vault
1597         uint256 gen;    // general vault
1598         uint256 aff;    // affiliate vault
1599         uint256 lrnd;   // last round played
1600         uint256 laff;   // last affiliate id used
1601     }
1602     struct PlayerRounds {
1603         uint256 eth;    // eth player has added to round (used for eth limiter)
1604         uint256 keys;   // keys
1605         uint256 mask;   // player mask
1606         uint256 ico;    // ICO phase investment
1607     }
1608     struct Round {
1609         uint256 plyr;   // pID of player in lead
1610         uint256 team;   // tID of team in lead
1611         uint256 end;    // time ends/ended
1612         bool ended;     // has round end function been ran
1613         uint256 strt;   // time round started
1614         uint256 keys;   // keys
1615         uint256 eth;    // total eth in
1616         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1617         uint256 mask;   // global mask
1618         uint256 ico;    // total eth sent in during ICO phase
1619         uint256 icoGen; // total eth for gen during ICO phase
1620         uint256 icoAvg; // average key price for ICO phase
1621     }
1622     struct TeamFee {
1623         uint256 gen;    // % of buy in thats paid to key holders of current round
1624         uint256 p3d;    // % of buy in thats paid to p3d holders
1625     }
1626     struct PotSplit {
1627         uint256 gen;    // % of pot thats paid to key holders of current round
1628         uint256 p3d;    // % of pot thats paid to p3d holders
1629     }
1630 }
1631 
1632 //==============================================================================
1633 //  |  _      _ _ | _  .
1634 //  |<(/_\/  (_(_||(_  .
1635 //=======/======================================================================
1636 library F3DKeysCalcShort {
1637     using SafeMath for *;
1638     /**
1639      * @dev calculates number of keys received given X eth
1640      * @param _curEth current amount of eth in contract
1641      * @param _newEth eth being spent
1642      * @return amount of ticket purchased
1643      */
1644     function keysRec(uint256 _curEth, uint256 _newEth)
1645         internal
1646         pure
1647         returns (uint256)
1648     {
1649         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1650     }
1651 
1652     /**
1653      * @dev calculates amount of eth received if you sold X keys
1654      * @param _curKeys current amount of keys that exist
1655      * @param _sellKeys amount of keys you wish to sell
1656      * @return amount of eth received
1657      */
1658     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1659         internal
1660         pure
1661         returns (uint256)
1662     {
1663         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1664     }
1665 
1666     /**
1667      * @dev calculates how many keys would exist with given an amount of eth
1668      * @param _eth eth "in contract"
1669      * @return number of keys that would exist
1670      */
1671     function keys(uint256 _eth)
1672         internal
1673         pure
1674         returns(uint256)
1675     {
1676         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1677     }
1678 
1679     /**
1680      * @dev calculates how much eth would be in contract given a number of keys
1681      * @param _keys number of keys "in contract"
1682      * @return eth that would exists
1683      */
1684     function eth(uint256 _keys)
1685         internal
1686         pure
1687         returns(uint256)
1688     {
1689         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1690     }
1691 }
1692 
1693 //==============================================================================
1694 //  . _ _|_ _  _ |` _  _ _  _  .
1695 //  || | | (/_| ~|~(_|(_(/__\  .
1696 //==============================================================================
1697 
1698 interface PlayerBookInterface {
1699     function getPlayerID(address _addr) external returns (uint256);
1700     function getPlayerName(uint256 _pID) external view returns (bytes32);
1701     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1702     function getPlayerAddr(uint256 _pID) external view returns (address);
1703     function getNameFee() external view returns (uint256);
1704     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1705     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1706     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1707 }
1708 
1709 /**
1710 * @title -Name Filter- v0.1.9
1711 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1712 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1713 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1714 *                                  _____                      _____
1715 *                                 (, /     /)       /) /)    (, /      /)          /)
1716 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1717 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1718 *          ┴ ┴                /   /          .-/ _____   (__ /
1719 *                            (__ /          (_/ (, /                                      /)™
1720 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1721 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1722 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1723 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1724 *              _       __    _      ____      ____  _   _    _____  ____  ___
1725 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1726 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1727 *
1728 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1729 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1730 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1731 */
1732 
1733 library NameFilter {
1734     /**
1735      * @dev filters name strings
1736      * -converts uppercase to lower case.
1737      * -makes sure it does not start/end with a space
1738      * -makes sure it does not contain multiple spaces in a row
1739      * -cannot be only numbers
1740      * -cannot start with 0x
1741      * -restricts characters to A-Z, a-z, 0-9, and space.
1742      * @return reprocessed string in bytes32 format
1743      */
1744     function nameFilter(string _input)
1745         internal
1746         pure
1747         returns(bytes32)
1748     {
1749         bytes memory _temp = bytes(_input);
1750         uint256 _length = _temp.length;
1751 
1752         //sorry limited to 32 characters
1753         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1754         // make sure it doesnt start with or end with space
1755         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1756         // make sure first two characters are not 0x
1757         if (_temp[0] == 0x30)
1758         {
1759             require(_temp[1] != 0x78, "string cannot start with 0x");
1760             require(_temp[1] != 0x58, "string cannot start with 0X");
1761         }
1762 
1763         // create a bool to track if we have a non number character
1764         bool _hasNonNumber;
1765 
1766         // convert & check
1767         for (uint256 i = 0; i < _length; i++)
1768         {
1769             // if its uppercase A-Z
1770             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1771             {
1772                 // convert to lower case a-z
1773                 _temp[i] = byte(uint(_temp[i]) + 32);
1774 
1775                 // we have a non number
1776                 if (_hasNonNumber == false)
1777                     _hasNonNumber = true;
1778             } else {
1779                 require
1780                 (
1781                     // require character is a space
1782                     _temp[i] == 0x20 ||
1783                     // OR lowercase a-z
1784                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1785                     // or 0-9
1786                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1787                     "string contains invalid characters"
1788                 );
1789                 // make sure theres not 2x spaces in a row
1790                 if (_temp[i] == 0x20)
1791                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1792 
1793                 // see if we have a character other than a number
1794                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1795                     _hasNonNumber = true;
1796             }
1797         }
1798 
1799         require(_hasNonNumber == true, "string cannot be only numbers");
1800 
1801         bytes32 _ret;
1802         assembly {
1803             _ret := mload(add(_temp, 32))
1804         }
1805         return (_ret);
1806     }
1807 }
1808 
1809 /**
1810  * @title SafeMath v0.1.9
1811  * @dev Math operations with safety checks that throw on error
1812  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1813  * - added sqrt
1814  * - added sq
1815  * - added pwr
1816  * - changed asserts to requires with error log outputs
1817  * - removed div, its useless
1818  */
1819 library SafeMath {
1820 
1821     /**
1822     * @dev Multiplies two numbers, throws on overflow.
1823     */
1824     function mul(uint256 a, uint256 b)
1825         internal
1826         pure
1827         returns (uint256 c)
1828     {
1829         if (a == 0) {
1830             return 0;
1831         }
1832         c = a * b;
1833         require(c / a == b, "SafeMath mul failed");
1834         return c;
1835     }
1836 
1837     /**
1838     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1839     */
1840     function sub(uint256 a, uint256 b)
1841         internal
1842         pure
1843         returns (uint256)
1844     {
1845         require(b <= a, "SafeMath sub failed");
1846         return a - b;
1847     }
1848 
1849     /**
1850     * @dev Adds two numbers, throws on overflow.
1851     */
1852     function add(uint256 a, uint256 b)
1853         internal
1854         pure
1855         returns (uint256 c)
1856     {
1857         c = a + b;
1858         require(c >= a, "SafeMath add failed");
1859         return c;
1860     }
1861 
1862     /**
1863      * @dev gives square root of given x.
1864      */
1865     function sqrt(uint256 x)
1866         internal
1867         pure
1868         returns (uint256 y)
1869     {
1870         uint256 z = ((add(x,1)) / 2);
1871         y = x;
1872         while (z < y)
1873         {
1874             y = z;
1875             z = ((add((x / z),z)) / 2);
1876         }
1877     }
1878 
1879     /**
1880      * @dev gives square. multiplies x by x
1881      */
1882     function sq(uint256 x)
1883         internal
1884         pure
1885         returns (uint256)
1886     {
1887         return (mul(x,x));
1888     }
1889 
1890     /**
1891      * @dev x to the power of y
1892      */
1893     function pwr(uint256 x, uint256 y)
1894         internal
1895         pure
1896         returns (uint256)
1897     {
1898         if (x==0)
1899             return (0);
1900         else if (y==0)
1901             return (1);
1902         else
1903         {
1904             uint256 z = x;
1905             for (uint256 i=1; i < y; i++)
1906                 z = mul(z,x);
1907             return (z);
1908         }
1909     }
1910 }