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
37         // fired whenever theres a withdraw
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
63     // (fomo3d fast only) fired whenever a player tries a buy after round timer
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
80     // (fomo3d fast only) fired whenever a player tries a reload after round timer
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
121 contract modularFast is F3Devents {}
122 
123 contract FoMo3Dfast is modularFast {
124     using SafeMath for *;
125     using NameFilter for string;
126     using F3DKeysCalcFast for uint256;
127 
128 
129 
130     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x91e047c728BD71047ea30372456444239c76e341);
131 
132 //==============================================================================
133 //     _ _  _  |`. _     _ _ |_ | _  _  .
134 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
135 //=================_|===========================================================
136     address private admin = msg.sender;
137     string constant public name = "FOMO Fast";
138     string constant public symbol = "FAST";
139     uint256 private rndExtra_ = 10 minutes;     // length of the very first ICO
140     uint256 private rndGap_ = 10 minutes;         // length of ICO phase, set to 1 year for EOS.
141     uint256 constant private rndInit_ = 10 minutes;                // round timer starts at this
142     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
143     uint256 constant private rndMax_ = 10 minutes;                // max length a round timer can be
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
176                 // Team allocation structures
177         // 0 = whales
178         // 1 = bears
179         // 2 = sneks
180         // 3 = bulls
181 
182                 // Team allocation percentages
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
196         }
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
528                         round_[_rID].ended = true;
529             _eventData_ = endRound(_eventData_);
530 
531                         // get their earnings
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
811          * @return player round eth
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
868                             round_[_rID].ended = true;
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
1057                     endTx(_pID, _team, _eth, _keys, _eventData_);
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
1126          * @dev receives name/player info from names contract
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
1268         // community rewards
1269 
1270         admin.transfer(_com);
1271 
1272         admin.transfer(_p3d.sub(_p3d / 2));
1273 
1274         round_[_rID].pot = _pot.add(_p3d / 2);
1275 
1276         // distribute gen portion to key holders
1277         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1278 
1279         // prepare event data
1280         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1281         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1282         _eventData_.winnerAddr = plyr_[_winPID].addr;
1283         _eventData_.winnerName = plyr_[_winPID].name;
1284         _eventData_.amountWon = _win;
1285         _eventData_.genAmount = _gen;
1286         _eventData_.P3DAmount = _p3d;
1287         _eventData_.newPot = _res;
1288 
1289         // start next round
1290         rID_++;
1291         _rID++;
1292         round_[_rID].strt = now;
1293         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1294         round_[_rID].pot = _res;
1295 
1296         return(_eventData_);
1297     }
1298 
1299     /**
1300      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1301      */
1302     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1303         private
1304     {
1305         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1306         if (_earnings > 0)
1307         {
1308             // put in gen vault
1309             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1310             // zero out their earnings by updating mask
1311             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1312         }
1313     }
1314 
1315     /**
1316      * @dev updates round timer based on number of whole keys bought.
1317      */
1318     function updateTimer(uint256 _keys, uint256 _rID)
1319         private
1320     {
1321         // grab time
1322         uint256 _now = now;
1323 
1324         // calculate time based on number of keys bought
1325         uint256 _newTime;
1326         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1327             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1328         else
1329             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1330 
1331         // compare to max and set new end time
1332         if (_newTime < (rndMax_).add(_now))
1333             round_[_rID].end = _newTime;
1334         else
1335             round_[_rID].end = rndMax_.add(_now);
1336     }
1337 
1338     /**
1339      * @dev generates a random number between 0-99 and checks to see if thats
1340      * resulted in an airdrop win
1341      * @return do we have a winner?
1342      */
1343     function airdrop()
1344         private
1345         view
1346         returns(bool)
1347     {
1348         uint256 seed = uint256(keccak256(abi.encodePacked(
1349 
1350             (block.timestamp).add
1351             (block.difficulty).add
1352             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1353             (block.gaslimit).add
1354             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1355             (block.number)
1356 
1357         )));
1358         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1359             return(true);
1360         else
1361             return(false);
1362     }
1363 
1364     /**
1365      * @dev distributes eth based on fees to com, aff, and p3d
1366      */
1367     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1368         private
1369         returns(F3Ddatasets.EventReturns)
1370     {
1371         // pay 3% out to community rewards
1372         uint256 _p1 = _eth / 100;
1373         uint256 _com = _eth / 50;
1374         _com = _com.add(_p1);
1375 
1376         uint256 _p3d;
1377         if (!address(admin).call.value(_com)())
1378         {
1379             // This ensures Team Just cannot influence the outcome of FoMo3D with
1380             // bank migrations by breaking outgoing transactions.
1381             // Something we would never do. But that's not the point.
1382             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1383             // highest belief that everything we create should be trustless.
1384             // Team JUST, The name you shouldn't have to trust.
1385             _p3d = _com;
1386             _com = 0;
1387         }
1388 
1389 
1390         // distribute share to affiliate
1391         uint256 _aff = _eth / 10;
1392 
1393         // decide what to do with affiliate share of fees
1394         // affiliate must not be self, and must have a name registered
1395         if (_affID != _pID && plyr_[_affID].name != '') {
1396             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1397             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1398         } else {
1399             _p3d = _aff;
1400         }
1401 
1402         // pay out p3d
1403         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1404         if (_p3d > 0)
1405         {
1406             // deposit to divies contract
1407             uint256 _potAmount = _p3d / 2;
1408 
1409             admin.transfer(_p3d.sub(_potAmount));
1410 
1411             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1412 
1413             // set up event data
1414             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1415         }
1416 
1417         return(_eventData_);
1418     }
1419 
1420     function potSwap()
1421         external
1422         payable
1423     {
1424         // setup local rID
1425         uint256 _rID = rID_ + 1;
1426 
1427         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1428         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1429     }
1430 
1431     /**
1432      * @dev distributes eth based on fees to gen and pot
1433      */
1434     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1435         private
1436         returns(F3Ddatasets.EventReturns)
1437     {
1438         // calculate gen share
1439         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1440 
1441         // toss 1% into airdrop pot
1442         uint256 _air = (_eth / 100);
1443         airDropPot_ = airDropPot_.add(_air);
1444 
1445         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1446         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1447 
1448         // calculate pot
1449         uint256 _pot = _eth.sub(_gen);
1450 
1451         // distribute gen share (thats what updateMasks() does) and adjust
1452         // balances for dust.
1453         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1454         if (_dust > 0)
1455             _gen = _gen.sub(_dust);
1456 
1457         // add eth to pot
1458         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1459 
1460         // set up event data
1461         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1462         _eventData_.potAmount = _pot;
1463 
1464         return(_eventData_);
1465     }
1466 
1467     /**
1468      * @dev updates masks for round and player when keys are bought
1469      * @return dust left over
1470      */
1471     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1472         private
1473         returns(uint256)
1474     {
1475         /* MASKING NOTES
1476             earnings masks are a tricky thing for people to wrap their minds around.
1477             the basic thing to understand here.  is were going to have a global
1478             tracker based on profit per share for each round, that increases in
1479             relevant proportion to the increase in share supply.
1480 
1481             the player will have an additional mask that basically says "based
1482             on the rounds mask, my shares, and how much i've already withdrawn,
1483             how much is still owed to me?"
1484         */
1485 
1486         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1487         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1488         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1489 
1490         // calculate player earning from their own buy (only based on the keys
1491         // they just bought).  & update player earnings mask
1492         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1493         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1494 
1495         // calculate & return dust
1496         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1497     }
1498 
1499     /**
1500      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1501      * @return earnings in wei format
1502      */
1503     function withdrawEarnings(uint256 _pID)
1504         private
1505         returns(uint256)
1506     {
1507         // update gen vault
1508         updateGenVault(_pID, plyr_[_pID].lrnd);
1509 
1510         // from vaults
1511         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1512         if (_earnings > 0)
1513         {
1514             plyr_[_pID].win = 0;
1515             plyr_[_pID].gen = 0;
1516             plyr_[_pID].aff = 0;
1517         }
1518 
1519         return(_earnings);
1520     }
1521 
1522     /**
1523      * @dev prepares compression data and fires event for buy or reload tx's
1524      */
1525     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1526         private
1527     {
1528         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1529         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1530 
1531         emit F3Devents.onEndTx
1532         (
1533             _eventData_.compressedData,
1534             _eventData_.compressedIDs,
1535             plyr_[_pID].name,
1536             msg.sender,
1537             _eth,
1538             _keys,
1539             _eventData_.winnerAddr,
1540             _eventData_.winnerName,
1541             _eventData_.amountWon,
1542             _eventData_.newPot,
1543             _eventData_.P3DAmount,
1544             _eventData_.genAmount,
1545             _eventData_.potAmount,
1546             airDropPot_
1547         );
1548     }
1549 //==============================================================================
1550 //    (~ _  _    _._|_    .
1551 //    _)(/_(_|_|| | | \/  .
1552 //====================/=========================================================
1553     /** upon contract deploy, it will be deactivated.  this is a one time
1554      * use function that will activate the contract.  we do this so devs
1555      * have time to set things up on the web end                            **/
1556     bool public activated_ = false;
1557     function activate()
1558         public
1559     {
1560         // only team just can activate
1561         require(msg.sender == admin, "only admin can activate");
1562 
1563 
1564         // can only be ran once
1565         require(activated_ == false, "FOMO Fast already activated");
1566 
1567         // activate the contract
1568         activated_ = true;
1569 
1570         // lets start first round
1571         rID_ = 1;
1572             round_[1].strt = now + rndExtra_ - rndGap_;
1573             round_[1].end = now + rndInit_ + rndExtra_;
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
1655 library F3DKeysCalcFast {
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
1717 interface PlayerBookInterface {
1718     function getPlayerID(address _addr) external returns (uint256);
1719     function getPlayerName(uint256 _pID) external view returns (bytes32);
1720     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1721     function getPlayerAddr(uint256 _pID) external view returns (address);
1722     function getNameFee() external view returns (uint256);
1723     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1724     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1725     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1726 }
1727 
1728 /**
1729 * @title -Name Filter- v0.1.9
1730 *     
1731 
1732 *          
1733 *     
1734 
1735 *                                  _____                      _____
1736 *                                 (, /     /)       /) /)    (, /      /)          /)
1737 *                              /   _ (/_      // //       /  _   // _   __  _(/
1738 *                          ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1739 *                       /   /          .-/ _____   (__ /
1740 *                            (__ /          (_/ (, /                                      /)?
1741 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1742 * ЩЩ                       /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1743 *                         (__ /              .-/  ? Jekyll Island Inc. 2018
1744 *                                      (_/
1745 *              _       __    _      ____      ____  _   _    _____  ____  ___
1746 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1747 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1748 *
1749 *    
1750 
1751 *  nventor 
1752 * ة    
1753 
1754 */
1755 
1756 library NameFilter {
1757     /**
1758      * @dev filters name strings
1759      * -converts uppercase to lower case.
1760      * -makes sure it does not start/end with a space
1761      * -makes sure it does not contain multiple spaces in a row
1762      * -cannot be only numbers
1763      * -cannot start with 0x
1764      * -restricts characters to A-Z, a-z, 0-9, and space.
1765      * @return reprocessed string in bytes32 format
1766      */
1767     function nameFilter(string _input)
1768         internal
1769         pure
1770         returns(bytes32)
1771     {
1772         bytes memory _temp = bytes(_input);
1773         uint256 _length = _temp.length;
1774 
1775         //sorry limited to 32 characters
1776         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1777         // make sure it doesnt start with or end with space
1778         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1779         // make sure first two characters are not 0x
1780         if (_temp[0] == 0x30)
1781         {
1782             require(_temp[1] != 0x78, "string cannot start with 0x");
1783             require(_temp[1] != 0x58, "string cannot start with 0X");
1784         }
1785 
1786         // create a bool to track if we have a non number character
1787         bool _hasNonNumber;
1788 
1789         // convert & check
1790         for (uint256 i = 0; i < _length; i++)
1791         {
1792             // if its uppercase A-Z
1793             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1794             {
1795                 // convert to lower case a-z
1796                 _temp[i] = byte(uint(_temp[i]) + 32);
1797 
1798                 // we have a non number
1799                 if (_hasNonNumber == false)
1800                     _hasNonNumber = true;
1801             } else {
1802                 require
1803                 (
1804                     // require character is a space
1805                     _temp[i] == 0x20 ||
1806                     // OR lowercase a-z
1807                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1808                     // or 0-9
1809                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1810                     "string contains invalid characters"
1811                 );
1812                 // make sure theres not 2x spaces in a row
1813                 if (_temp[i] == 0x20)
1814                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1815 
1816                 // see if we have a character other than a number
1817                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1818                     _hasNonNumber = true;
1819             }
1820         }
1821 
1822         require(_hasNonNumber == true, "string cannot be only numbers");
1823 
1824         bytes32 _ret;
1825         assembly {
1826             _ret := mload(add(_temp, 32))
1827         }
1828         return (_ret);
1829     }
1830 }
1831 
1832 /**
1833  * @title SafeMath v0.1.9
1834  * @dev Math operations with safety checks that throw on error
1835  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1836  * - added sqrt
1837  * - added sq
1838  * - added pwr
1839  * - changed asserts to requires with error log outputs
1840  * - removed div, its useless
1841  */
1842 library SafeMath {
1843 
1844     /**
1845     * @dev Multiplies two numbers, throws on overflow.
1846     */
1847     function mul(uint256 a, uint256 b)
1848         internal
1849         pure
1850         returns (uint256 c)
1851     {
1852         if (a == 0) {
1853             return 0;
1854         }
1855         c = a * b;
1856         require(c / a == b, "SafeMath mul failed");
1857         return c;
1858     }
1859 
1860     /**
1861     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1862     */
1863     function sub(uint256 a, uint256 b)
1864         internal
1865         pure
1866         returns (uint256)
1867     {
1868         require(b <= a, "SafeMath sub failed");
1869         return a - b;
1870     }
1871 
1872     /**
1873     * @dev Adds two numbers, throws on overflow.
1874     */
1875     function add(uint256 a, uint256 b)
1876         internal
1877         pure
1878         returns (uint256 c)
1879     {
1880         c = a + b;
1881         require(c >= a, "SafeMath add failed");
1882         return c;
1883     }
1884 
1885     /**
1886      * @dev gives square root of given x.
1887      */
1888     function sqrt(uint256 x)
1889         internal
1890         pure
1891         returns (uint256 y)
1892     {
1893         uint256 z = ((add(x,1)) / 2);
1894         y = x;
1895         while (z < y)
1896         {
1897             y = z;
1898             z = ((add((x / z),z)) / 2);
1899         }
1900     }
1901 
1902     /**
1903      * @dev gives square. multiplies x by x
1904      */
1905     function sq(uint256 x)
1906         internal
1907         pure
1908         returns (uint256)
1909     {
1910         return (mul(x,x));
1911     }
1912 
1913     /**
1914      * @dev x to the power of y
1915      */
1916     function pwr(uint256 x, uint256 y)
1917         internal
1918         pure
1919         returns (uint256)
1920     {
1921         if (x==0)
1922             return (0);
1923         else if (y==0)
1924             return (1);
1925         else
1926         {
1927             uint256 z = x;
1928             for (uint256 i=1; i < y; i++)
1929                 z = mul(z,x);
1930             return (z);
1931         }
1932     }
1933 }