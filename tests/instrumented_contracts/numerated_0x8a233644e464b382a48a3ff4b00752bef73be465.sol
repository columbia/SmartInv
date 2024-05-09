1 pragma solidity ^0.4.24;
2 
3 contract FFFevents {
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
63     // (fomo3d short only) fired whenever a player tries a buy after round timer
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
80     // (fomo3d short only) fired whenever a player tries a reload after round timer
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
121 contract modularShort is FFFevents {}
122 
123 contract FFFultra is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using FFFKeysCalcShort for uint256;
127 
128     PlayerBookInterface private PlayerBook;
129 
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     address private admin = msg.sender;
135     address private yyyy;
136     address private gggg;
137     
138     string constant public name = "ethfomo3d";
139     string constant public symbol = "ethfomo3d";
140     uint256 private rndExtra_ = 0;     // length of the very first ICO
141     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
142     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
143     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
144     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
145 
146     uint256 constant private preIcoMax_ = 50000000000000000000; // max ico num
147     uint256 constant private preIcoPerEth_ = 1500000000000000000; // in ico, per addr eth
148     
149 //==============================================================================
150 //     _| _ _|_ _    _ _ _|_    _   .
151 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
152 //=============================|================================================
153     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
154     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
155     uint256 public rID_;    // round id number / total rounds that have happened
156 //****************
157 // PLAYER DATA
158 //****************
159     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
160     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
161     mapping (uint256 => FFFdatasets.Player) public plyr_;   // (pID => data) player data
162     mapping (uint256 => mapping (uint256 => FFFdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
163     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
164 //****************
165 // ROUND DATA
166 //****************
167     mapping (uint256 => FFFdatasets.Round) public round_;   // (rID => data) round data
168     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
169 //****************
170 // TEAM FEE DATA
171 //****************
172     mapping (uint256 => FFFdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
173     mapping (uint256 => FFFdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
174 //==============================================================================
175 //     _ _  _  __|_ _    __|_ _  _  .
176 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
177 //==============================================================================
178     constructor(PlayerBookInterface _PlayerBook, address _yyyy, address _gggg)
179         public
180     {
181 		// Team allocation structures
182         // 0 = whales
183         // 1 = bears
184         // 2 = sneks
185         // 3 = bulls
186 
187 		// Team allocation percentages
188         // (F3D, P3D) + (Pot , Referrals, Community)
189             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
190         fees_[0] = FFFdatasets.TeamFee(60,8);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
191         fees_[1] = FFFdatasets.TeamFee(60,8);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
192         fees_[2] = FFFdatasets.TeamFee(60,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
193         fees_[3] = FFFdatasets.TeamFee(60,8);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
194 
195         // how to split up the final pot based on which team was picked
196         // (F3D, P3D)
197         potSplit_[0] = FFFdatasets.PotSplit(30,10);  //48% to winner, 25% to next round, 2% to com
198         potSplit_[1] = FFFdatasets.PotSplit(30,10);   //48% to winner, 25% to next round, 2% to com
199         potSplit_[2] = FFFdatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
200         potSplit_[3] = FFFdatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
201 
202         PlayerBook = _PlayerBook;
203         yyyy = _yyyy;
204         gggg = _gggg;
205 	}
206 //==============================================================================
207 //     _ _  _  _|. |`. _  _ _  .
208 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
209 //==============================================================================
210     /**
211      * @dev used to make sure no one can interact with contract until it has
212      * been activated.
213      */
214     modifier isActivated() {
215         require(activated_ == true, "its not ready yet.  check ?eta in discord");
216         _;
217     }
218 
219     /**
220      * @dev prevents contracts from interacting with fomo3d
221      */
222     modifier isHuman() {
223         address _addr = msg.sender;
224         uint256 _codeLength;
225 
226         assembly {_codeLength := extcodesize(_addr)}
227         require(_codeLength == 0, "sorry humans only");
228         _;
229     }
230 
231     /**
232      * @dev sets boundaries for incoming tx
233      */
234     modifier isWithinLimits(uint256 _eth) {
235         require(_eth >= 1000000000, "pocket lint: not a valid currency");
236         require(_eth <= 100000000000000000000000, "no vitalik, no");
237         _;
238     }
239 
240 //==============================================================================
241 //     _    |_ |. _   |`    _  __|_. _  _  _  .
242 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
243 //====|=========================================================================
244     /**
245      * @dev emergency buy uses last stored affiliate ID and team snek
246      */
247     function()
248         isActivated()
249         isHuman()
250         isWithinLimits(msg.value)
251         public
252         payable
253     {
254         // set up our tx event data and determine if player is new or not
255         FFFdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
256 
257         // fetch player id
258         uint256 _pID = pIDxAddr_[msg.sender];
259 
260         // buy core
261         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
262     }
263 
264     /**
265      * @dev converts all incoming ethereum to keys.
266      * -functionhash- 0x8f38f309 (using ID for affiliate)
267      * -functionhash- 0x98a0871d (using address for affiliate)
268      * -functionhash- 0xa65b37a1 (using name for affiliate)
269      * @param _affCode the ID/address/name of the player who gets the affiliate fee
270      * @param _team what team is the player playing for?
271      */
272     function buyXid(uint256 _affCode, uint256 _team)
273         isActivated()
274         isHuman()
275         isWithinLimits(msg.value)
276         public
277         payable
278     {
279         // set up our tx event data and determine if player is new or not
280         FFFdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
281 
282         // fetch player id
283         uint256 _pID = pIDxAddr_[msg.sender];
284 
285         // manage affiliate residuals
286         // if no affiliate code was given or player tried to use their own, lolz
287         if (_affCode == 0 || _affCode == _pID)
288         {
289             // use last stored affiliate code
290             _affCode = plyr_[_pID].laff;
291 
292         // if affiliate code was given & its not the same as previously stored
293         } else if (_affCode != plyr_[_pID].laff) {
294             // update last affiliate
295             plyr_[_pID].laff = _affCode;
296         }
297 
298         // verify a valid team was selected
299         _team = verifyTeam(_team);
300 
301         // buy core
302         buyCore(_pID, _affCode, _team, _eventData_);
303     }
304 
305     function buyXaddr(address _affCode, uint256 _team)
306         isActivated()
307         isHuman()
308         isWithinLimits(msg.value)
309         public
310         payable
311     {
312         // set up our tx event data and determine if player is new or not
313         FFFdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
314 
315         // fetch player id
316         uint256 _pID = pIDxAddr_[msg.sender];
317 
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
338 
339         // verify a valid team was selected
340         _team = verifyTeam(_team);
341 
342         // buy core
343         buyCore(_pID, _affID, _team, _eventData_);
344     }
345 
346     function buyXname(bytes32 _affCode, uint256 _team)
347         isActivated()
348         isHuman()
349         isWithinLimits(msg.value)
350         public
351         payable
352     {
353         // set up our tx event data and determine if player is new or not
354         FFFdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
355 
356         // fetch player id
357         uint256 _pID = pIDxAddr_[msg.sender];
358 
359         // manage affiliate residuals
360         uint256 _affID;
361         // if no affiliate code was given or player tried to use their own, lolz
362         if (_affCode == '' || _affCode == plyr_[_pID].name)
363         {
364             // use last stored affiliate code
365             _affID = plyr_[_pID].laff;
366 
367         // if affiliate code was given
368         } else {
369             // get affiliate ID from aff Code
370             _affID = pIDxName_[_affCode];
371 
372             // if affID is not the same as previously stored
373             if (_affID != plyr_[_pID].laff)
374             {
375                 // update last affiliate
376                 plyr_[_pID].laff = _affID;
377             }
378         }
379 
380         // verify a valid team was selected
381         _team = verifyTeam(_team);
382 
383         // buy core
384         buyCore(_pID, _affID, _team, _eventData_);
385     }
386 
387     /**
388      * @dev essentially the same as buy, but instead of you sending ether
389      * from your wallet, it uses your unwithdrawn earnings.
390      * -functionhash- 0x349cdcac (using ID for affiliate)
391      * -functionhash- 0x82bfc739 (using address for affiliate)
392      * -functionhash- 0x079ce327 (using name for affiliate)
393      * @param _affCode the ID/address/name of the player who gets the affiliate fee
394      * @param _team what team is the player playing for?
395      * @param _eth amount of earnings to use (remainder returned to gen vault)
396      */
397     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
398         isActivated()
399         isHuman()
400         isWithinLimits(_eth)
401         public
402     {
403         // set up our tx event data
404         FFFdatasets.EventReturns memory _eventData_;
405 
406         // fetch player ID
407         uint256 _pID = pIDxAddr_[msg.sender];
408 
409         // manage affiliate residuals
410         // if no affiliate code was given or player tried to use their own, lolz
411         if (_affCode == 0 || _affCode == _pID)
412         {
413             // use last stored affiliate code
414             _affCode = plyr_[_pID].laff;
415 
416         // if affiliate code was given & its not the same as previously stored
417         } else if (_affCode != plyr_[_pID].laff) {
418             // update last affiliate
419             plyr_[_pID].laff = _affCode;
420         }
421 
422         // verify a valid team was selected
423         _team = verifyTeam(_team);
424 
425         // reload core
426         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
427     }
428 
429     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
430         isActivated()
431         isHuman()
432         isWithinLimits(_eth)
433         public
434     {
435         // set up our tx event data
436         FFFdatasets.EventReturns memory _eventData_;
437 
438         // fetch player ID
439         uint256 _pID = pIDxAddr_[msg.sender];
440 
441         // manage affiliate residuals
442         uint256 _affID;
443         // if no affiliate code was given or player tried to use their own, lolz
444         if (_affCode == address(0) || _affCode == msg.sender)
445         {
446             // use last stored affiliate code
447             _affID = plyr_[_pID].laff;
448 
449         // if affiliate code was given
450         } else {
451             // get affiliate ID from aff Code
452             _affID = pIDxAddr_[_affCode];
453 
454             // if affID is not the same as previously stored
455             if (_affID != plyr_[_pID].laff)
456             {
457                 // update last affiliate
458                 plyr_[_pID].laff = _affID;
459             }
460         }
461 
462         // verify a valid team was selected
463         _team = verifyTeam(_team);
464 
465         // reload core
466         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
467     }
468 
469     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
470         isActivated()
471         isHuman()
472         isWithinLimits(_eth)
473         public
474     {
475         // set up our tx event data
476         FFFdatasets.EventReturns memory _eventData_;
477 
478         // fetch player ID
479         uint256 _pID = pIDxAddr_[msg.sender];
480 
481         // manage affiliate residuals
482         uint256 _affID;
483         // if no affiliate code was given or player tried to use their own, lolz
484         if (_affCode == '' || _affCode == plyr_[_pID].name)
485         {
486             // use last stored affiliate code
487             _affID = plyr_[_pID].laff;
488 
489         // if affiliate code was given
490         } else {
491             // get affiliate ID from aff Code
492             _affID = pIDxName_[_affCode];
493 
494             // if affID is not the same as previously stored
495             if (_affID != plyr_[_pID].laff)
496             {
497                 // update last affiliate
498                 plyr_[_pID].laff = _affID;
499             }
500         }
501 
502         // verify a valid team was selected
503         _team = verifyTeam(_team);
504 
505         // reload core
506         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
507     }
508 
509     /**
510      * @dev withdraws all of your earnings.
511      * -functionhash- 0x3ccfd60b
512      */
513     function withdraw()
514         isActivated()
515         isHuman()
516         public
517     {
518         // setup local rID
519         uint256 _rID = rID_;
520 
521         // grab time
522         uint256 _now = now;
523 
524         // fetch player ID
525         uint256 _pID = pIDxAddr_[msg.sender];
526 
527         // setup temp var for player eth
528         uint256 _eth;
529 
530         // check to see if round has ended and no one has run round end yet
531         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
532         {
533             // set up our tx event data
534             FFFdatasets.EventReturns memory _eventData_;
535 
536             // end the round (distributes pot)
537 			round_[_rID].ended = true;
538             _eventData_ = endRound(_eventData_);
539 
540 			// get their earnings
541             _eth = withdrawEarnings(_pID);
542 
543             // gib moni
544             if (_eth > 0)
545                 plyr_[_pID].addr.transfer(_eth);
546 
547             // build event data
548             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
549             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
550 
551             // fire withdraw and distribute event
552             emit FFFevents.onWithdrawAndDistribute
553             (
554                 msg.sender,
555                 plyr_[_pID].name,
556                 _eth,
557                 _eventData_.compressedData,
558                 _eventData_.compressedIDs,
559                 _eventData_.winnerAddr,
560                 _eventData_.winnerName,
561                 _eventData_.amountWon,
562                 _eventData_.newPot,
563                 _eventData_.P3DAmount,
564                 _eventData_.genAmount
565             );
566 
567         // in any other situation
568         } else {
569             // get their earnings
570             _eth = withdrawEarnings(_pID);
571 
572             // gib moni
573             if (_eth > 0)
574                 plyr_[_pID].addr.transfer(_eth);
575 
576             // fire withdraw event
577             emit FFFevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
578         }
579     }
580 
581     /**
582      * @dev use these to register names.  they are just wrappers that will send the
583      * registration requests to the PlayerBook contract.  So registering here is the
584      * same as registering there.  UI will always display the last name you registered.
585      * but you will still own all previously registered names to use as affiliate
586      * links.
587      * - must pay a registration fee.
588      * - name must be unique
589      * - names will be converted to lowercase
590      * - name cannot start or end with a space
591      * - cannot have more than 1 space in a row
592      * - cannot be only numbers
593      * - cannot start with 0x
594      * - name must be at least 1 char
595      * - max length of 32 characters long
596      * - allowed characters: a-z, 0-9, and space
597      * -functionhash- 0x921dec21 (using ID for affiliate)
598      * -functionhash- 0x3ddd4698 (using address for affiliate)
599      * -functionhash- 0x685ffd83 (using name for affiliate)
600      * @param _nameString players desired name
601      * @param _affCode affiliate ID, address, or name of who referred you
602      * @param _all set to true if you want this to push your info to all games
603      * (this might cost a lot of gas)
604      */
605     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
606         isHuman()
607         public
608         payable
609     {
610         bytes32 _name = _nameString.nameFilter();
611         address _addr = msg.sender;
612         uint256 _paid = msg.value;
613         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
614 
615         uint256 _pID = pIDxAddr_[_addr];
616 
617         // fire event
618         emit FFFevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
619     }
620 
621     function registerNameXaddr(string _nameString, address _affCode, bool _all)
622         isHuman()
623         public
624         payable
625     {
626         bytes32 _name = _nameString.nameFilter();
627         address _addr = msg.sender;
628         uint256 _paid = msg.value;
629         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
630 
631         uint256 _pID = pIDxAddr_[_addr];
632 
633         // fire event
634         emit FFFevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
635     }
636 
637     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
638         isHuman()
639         public
640         payable
641     {
642         bytes32 _name = _nameString.nameFilter();
643         address _addr = msg.sender;
644         uint256 _paid = msg.value;
645         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
646 
647         uint256 _pID = pIDxAddr_[_addr];
648 
649         // fire event
650         emit FFFevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
651     }
652 //==============================================================================
653 //     _  _ _|__|_ _  _ _  .
654 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
655 //=====_|=======================================================================
656     /**
657      * @dev return the price buyer will pay for next 1 individual key.
658      * -functionhash- 0x018a25e8
659      * @return price for next key bought (in wei format)
660      */
661     function getBuyPrice()
662         public
663         view
664         returns(uint256)
665     {
666         // setup local rID
667         uint256 _rID = rID_;
668 
669         // grab time
670         uint256 _now = now;
671 
672         // are we in a round?
673         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
674             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
675         else // rounds over.  need price for new round
676             return ( 75000000000000 ); // init
677     }
678 
679     /**
680      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
681      * provider
682      * -functionhash- 0xc7e284b8
683      * @return time left in seconds
684      */
685     function getTimeLeft()
686         public
687         view
688         returns(uint256)
689     {
690         // setup local rID
691         uint256 _rID = rID_;
692 
693         // grab time
694         uint256 _now = now;
695 
696         if (_now < round_[_rID].end)
697             if (_now > round_[_rID].strt + rndGap_)
698                 return( (round_[_rID].end).sub(_now) );
699             else
700                 return( (round_[_rID].strt + rndGap_).sub(_now) );
701         else
702             return(0);
703     }
704 
705     /**
706      * @dev returns player earnings per vaults
707      * -functionhash- 0x63066434
708      * @return winnings vault
709      * @return general vault
710      * @return affiliate vault
711      */
712     function getPlayerVaults(uint256 _pID)
713         public
714         view
715         returns(uint256 ,uint256, uint256)
716     {
717         // setup local rID
718         uint256 _rID = rID_;
719 
720         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
721         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
722         {
723             // if player is winner
724             if (round_[_rID].plyr == _pID)
725             {
726                 return
727                 (
728                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
729                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
730                     plyr_[_pID].aff
731                 );
732             // if player is not the winner
733             } else {
734                 return
735                 (
736                     plyr_[_pID].win,
737                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
738                     plyr_[_pID].aff
739                 );
740             }
741 
742         // if round is still going on, or round has ended and round end has been ran
743         } else {
744             return
745             (
746                 plyr_[_pID].win,
747                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
748                 plyr_[_pID].aff
749             );
750         }
751     }
752 
753     /**
754      * solidity hates stack limits.  this lets us avoid that hate
755      */
756     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
757         private
758         view
759         returns(uint256)
760     {
761         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
762     }
763 
764     /**
765      * @dev returns all current round info needed for front end
766      * -functionhash- 0x747dff42
767      * @return eth invested during ICO phase
768      * @return round id
769      * @return total keys for round
770      * @return time round ends
771      * @return time round started
772      * @return current pot
773      * @return current team ID & player ID in lead
774      * @return current player in leads address
775      * @return current player in leads name
776      * @return whales eth in for round
777      * @return bears eth in for round
778      * @return sneks eth in for round
779      * @return bulls eth in for round
780      * @return airdrop tracker # & airdrop pot
781      */
782     function getCurrentRoundInfo()
783         public
784         view
785         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
786     {
787         // setup local rID
788         uint256 _rID = rID_;
789 
790         return
791         (
792             round_[_rID].ico,               //0
793             _rID,                           //1
794             round_[_rID].keys,              //2
795             round_[_rID].end,               //3
796             round_[_rID].strt,              //4
797             round_[_rID].pot,               //5
798             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
799             plyr_[round_[_rID].plyr].addr,  //7
800             plyr_[round_[_rID].plyr].name,  //8
801             rndTmEth_[_rID][0],             //9
802             rndTmEth_[_rID][1],             //10
803             rndTmEth_[_rID][2],             //11
804             rndTmEth_[_rID][3],             //12
805             airDropTracker_ + (airDropPot_ * 1000)              //13
806         );
807     }
808 
809     /**
810      * @dev returns player info based on address.  if no address is given, it will
811      * use msg.sender
812      * -functionhash- 0xee0b5d8b
813      * @param _addr address of the player you want to lookup
814      * @return player ID
815      * @return player name
816      * @return keys owned (current round)
817      * @return winnings vault
818      * @return general vault
819      * @return affiliate vault
820 	 * @return player round eth
821      */
822     function getPlayerInfoByAddress(address _addr)
823         public
824         view
825         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
826     {
827         // setup local rID
828         uint256 _rID = rID_;
829 
830         if (_addr == address(0))
831         {
832             _addr == msg.sender;
833         }
834         uint256 _pID = pIDxAddr_[_addr];
835 
836         return
837         (
838             _pID,                               //0
839             plyr_[_pID].name,                   //1
840             plyrRnds_[_pID][_rID].keys,         //2
841             plyr_[_pID].win,                    //3
842             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
843             plyr_[_pID].aff,                    //5
844             plyrRnds_[_pID][_rID].eth           //6
845         );
846     }
847 
848 //==============================================================================
849 //     _ _  _ _   | _  _ . _  .
850 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
851 //=====================_|=======================================================
852     /**
853      * @dev logic runs whenever a buy order is executed.  determines how to handle
854      * incoming eth depending on if we are in an active round or not
855      */
856     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, FFFdatasets.EventReturns memory _eventData_)
857         private
858     {
859         // setup local rID
860         uint256 _rID = rID_;
861 
862         // grab time
863         uint256 _now = now;
864 
865         // if round is active
866         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
867         {
868             // call core
869             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
870 
871         // if round is not active
872         } else {
873             // check to see if end round needs to be ran
874             if (_now > round_[_rID].end && round_[_rID].ended == false)
875             {
876                 // end the round (distributes pot) & start new round
877 			    round_[_rID].ended = true;
878                 _eventData_ = endRound(_eventData_);
879 
880                 // build event data
881                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
882                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
883 
884                 // fire buy and distribute event
885                 emit FFFevents.onBuyAndDistribute
886                 (
887                     msg.sender,
888                     plyr_[_pID].name,
889                     msg.value,
890                     _eventData_.compressedData,
891                     _eventData_.compressedIDs,
892                     _eventData_.winnerAddr,
893                     _eventData_.winnerName,
894                     _eventData_.amountWon,
895                     _eventData_.newPot,
896                     _eventData_.P3DAmount,
897                     _eventData_.genAmount
898                 );
899             }
900 
901             // put eth in players vault
902             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
903         }
904     }
905 
906     /**
907      * @dev logic runs whenever a reload order is executed.  determines how to handle
908      * incoming eth depending on if we are in an active round or not
909      */
910     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, FFFdatasets.EventReturns memory _eventData_)
911         private
912     {
913         // setup local rID
914         uint256 _rID = rID_;
915 
916         // grab time
917         uint256 _now = now;
918 
919         // if round is active
920         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
921         {
922             // get earnings from all vaults and return unused to gen vault
923             // because we use a custom safemath library.  this will throw if player
924             // tried to spend more eth than they have.
925             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
926 
927             // call core
928             core(_rID, _pID, _eth, _affID, _team, _eventData_);
929 
930         // if round is not active and end round needs to be ran
931         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
932             // end the round (distributes pot) & start new round
933             round_[_rID].ended = true;
934             _eventData_ = endRound(_eventData_);
935 
936             // build event data
937             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
938             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
939 
940             // fire buy and distribute event
941             emit FFFevents.onReLoadAndDistribute
942             (
943                 msg.sender,
944                 plyr_[_pID].name,
945                 _eventData_.compressedData,
946                 _eventData_.compressedIDs,
947                 _eventData_.winnerAddr,
948                 _eventData_.winnerName,
949                 _eventData_.amountWon,
950                 _eventData_.newPot,
951                 _eventData_.P3DAmount,
952                 _eventData_.genAmount
953             );
954         }
955     }
956 
957     /**
958      * @dev this is the core logic for any buy/reload that happens while a round
959      * is live.
960      */
961     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, FFFdatasets.EventReturns memory _eventData_)
962         private
963     {
964         // if player is new to round
965         if (plyrRnds_[_pID][_rID].keys == 0)
966             _eventData_ = managePlayer(_pID, _eventData_);
967 
968         // early round eth limiter
969         if (round_[_rID].eth < preIcoMax_ && plyrRnds_[_pID][_rID].eth.add(_eth) > preIcoPerEth_)
970         {
971             uint256 _availableLimit = (preIcoPerEth_).sub(plyrRnds_[_pID][_rID].eth);
972             uint256 _refund = _eth.sub(_availableLimit);
973             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
974             _eth = _availableLimit;
975         }
976 
977         // if eth left is greater than min eth allowed (sorry no pocket lint)
978         if (_eth > 1000000000)
979         {
980 
981             // mint the new keys
982             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
983 
984             // if they bought at least 1 whole key
985             if (_keys >= 1000000000000000000)
986             {
987             updateTimer(_keys, _rID);
988 
989             // set new leaders
990             if (round_[_rID].plyr != _pID)
991                 round_[_rID].plyr = _pID;
992             if (round_[_rID].team != _team)
993                 round_[_rID].team = _team;
994 
995             // set the new leader bool to true
996             _eventData_.compressedData = _eventData_.compressedData + 100;
997         }
998 
999             // manage airdrops
1000             if (_eth >= 100000000000000000)
1001             {
1002             airDropTracker_++;
1003             if (airdrop() == true)
1004             {
1005                 // gib muni
1006                 uint256 _prize;
1007                 if (_eth >= 10000000000000000000)
1008                 {
1009                     // calculate prize and give it to winner
1010                     _prize = ((airDropPot_).mul(75)) / 100;
1011                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1012 
1013                     // adjust airDropPot
1014                     airDropPot_ = (airDropPot_).sub(_prize);
1015 
1016                     // let event know a tier 3 prize was won
1017                     _eventData_.compressedData += 300000000000000000000000000000000;
1018                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1019                     // calculate prize and give it to winner
1020                     _prize = ((airDropPot_).mul(50)) / 100;
1021                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1022 
1023                     // adjust airDropPot
1024                     airDropPot_ = (airDropPot_).sub(_prize);
1025 
1026                     // let event know a tier 2 prize was won
1027                     _eventData_.compressedData += 200000000000000000000000000000000;
1028                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1029                     // calculate prize and give it to winner
1030                     _prize = ((airDropPot_).mul(25)) / 100;
1031                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1032 
1033                     // adjust airDropPot
1034                     airDropPot_ = (airDropPot_).sub(_prize);
1035 
1036                     // let event know a tier 3 prize was won
1037                     _eventData_.compressedData += 300000000000000000000000000000000;
1038                 }
1039                 // set airdrop happened bool to true
1040                 _eventData_.compressedData += 10000000000000000000000000000000;
1041                 // let event know how much was won
1042                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1043 
1044                 // reset air drop tracker
1045                 airDropTracker_ = 0;
1046             }
1047         }
1048 
1049             // store the air drop tracker number (number of buys since last airdrop)
1050             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1051 
1052             // update player
1053             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1054             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1055 
1056             // update round
1057             round_[_rID].keys = _keys.add(round_[_rID].keys);
1058             round_[_rID].eth = _eth.add(round_[_rID].eth);
1059             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1060 
1061             // distribute eth
1062             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1063             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1064 
1065             // call end tx function to fire end tx event.
1066 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1067         }
1068     }
1069 //==============================================================================
1070 //     _ _ | _   | _ _|_ _  _ _  .
1071 //    (_(_||(_|_||(_| | (_)| _\  .
1072 //==============================================================================
1073     /**
1074      * @dev calculates unmasked earnings (just calculates, does not update mask)
1075      * @return earnings in wei format
1076      */
1077     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1078         private
1079         view
1080         returns(uint256)
1081     {
1082         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1083     }
1084 
1085     /**
1086      * @dev returns the amount of keys you would get given an amount of eth.
1087      * -functionhash- 0xce89c80c
1088      * @param _rID round ID you want price for
1089      * @param _eth amount of eth sent in
1090      * @return keys received
1091      */
1092     function calcKeysReceived(uint256 _rID, uint256 _eth)
1093         public
1094         view
1095         returns(uint256)
1096     {
1097         // grab time
1098         uint256 _now = now;
1099 
1100         // are we in a round?
1101         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1102             return ( (round_[_rID].eth).keysRec(_eth) );
1103         else // rounds over.  need keys for new round
1104             return ( (_eth).keys() );
1105     }
1106 
1107     /**
1108      * @dev returns current eth price for X keys.
1109      * -functionhash- 0xcf808000
1110      * @param _keys number of keys desired (in 18 decimal format)
1111      * @return amount of eth needed to send
1112      */
1113     function iWantXKeys(uint256 _keys)
1114         public
1115         view
1116         returns(uint256)
1117     {
1118         // setup local rID
1119         uint256 _rID = rID_;
1120 
1121         // grab time
1122         uint256 _now = now;
1123 
1124         // are we in a round?
1125         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1126             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1127         else // rounds over.  need price for new round
1128             return ( (_keys).eth() );
1129     }
1130 //==============================================================================
1131 //    _|_ _  _ | _  .
1132 //     | (_)(_)|_\  .
1133 //==============================================================================
1134     /**
1135 	 * @dev receives name/player info from names contract
1136      */
1137     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1138         external
1139     {
1140         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1141         if (pIDxAddr_[_addr] != _pID)
1142             pIDxAddr_[_addr] = _pID;
1143         if (pIDxName_[_name] != _pID)
1144             pIDxName_[_name] = _pID;
1145         if (plyr_[_pID].addr != _addr)
1146             plyr_[_pID].addr = _addr;
1147         if (plyr_[_pID].name != _name)
1148             plyr_[_pID].name = _name;
1149         if (plyr_[_pID].laff != _laff)
1150             plyr_[_pID].laff = _laff;
1151         if (plyrNames_[_pID][_name] == false)
1152             plyrNames_[_pID][_name] = true;
1153     }
1154 
1155     /**
1156      * @dev receives entire player name list
1157      */
1158     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1159         external
1160     {
1161         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1162         if(plyrNames_[_pID][_name] == false)
1163             plyrNames_[_pID][_name] = true;
1164     }
1165 
1166     /**
1167      * @dev gets existing or registers new pID.  use this when a player may be new
1168      * @return pID
1169      */
1170     function determinePID(FFFdatasets.EventReturns memory _eventData_)
1171         private
1172         returns (FFFdatasets.EventReturns)
1173     {
1174         uint256 _pID = pIDxAddr_[msg.sender];
1175         // if player is new to this version of fomo3d
1176         if (_pID == 0)
1177         {
1178             // grab their player ID, name and last aff ID, from player names contract
1179             _pID = PlayerBook.getPlayerID(msg.sender);
1180             bytes32 _name = PlayerBook.getPlayerName(_pID);
1181             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1182 
1183             // set up player account
1184             pIDxAddr_[msg.sender] = _pID;
1185             plyr_[_pID].addr = msg.sender;
1186 
1187             if (_name != "")
1188             {
1189                 pIDxName_[_name] = _pID;
1190                 plyr_[_pID].name = _name;
1191                 plyrNames_[_pID][_name] = true;
1192             }
1193 
1194             if (_laff != 0 && _laff != _pID)
1195                 plyr_[_pID].laff = _laff;
1196 
1197             // set the new player bool to true
1198             _eventData_.compressedData = _eventData_.compressedData + 1;
1199         }
1200         return (_eventData_);
1201     }
1202 
1203     /**
1204      * @dev checks to make sure user picked a valid team.  if not sets team
1205      * to default (sneks)
1206      */
1207     function verifyTeam(uint256 _team)
1208         private
1209         pure
1210         returns (uint256)
1211     {
1212         if (_team < 0 || _team > 3)
1213             return(2);
1214         else
1215             return(_team);
1216     }
1217 
1218     /**
1219      * @dev decides if round end needs to be run & new round started.  and if
1220      * player unmasked earnings from previously played rounds need to be moved.
1221      */
1222     function managePlayer(uint256 _pID, FFFdatasets.EventReturns memory _eventData_)
1223         private
1224         returns (FFFdatasets.EventReturns)
1225     {
1226         // if player has played a previous round, move their unmasked earnings
1227         // from that round to gen vault.
1228         if (plyr_[_pID].lrnd != 0)
1229             updateGenVault(_pID, plyr_[_pID].lrnd);
1230 
1231         // update player's last round played
1232         plyr_[_pID].lrnd = rID_;
1233 
1234         // set the joined round bool to true
1235         _eventData_.compressedData = _eventData_.compressedData + 10;
1236 
1237         return(_eventData_);
1238     }
1239 
1240     /**
1241      * @dev ends the round. manages paying out winner/splitting up pot
1242      */
1243     function endRound(FFFdatasets.EventReturns memory _eventData_)
1244         private
1245         returns (FFFdatasets.EventReturns)
1246     {
1247         // setup local rID
1248         uint256 _rID = rID_;
1249 
1250         // grab our winning player and team id's
1251         uint256 _winPID = round_[_rID].plyr;
1252         uint256 _winTID = round_[_rID].team;
1253 
1254         // grab our pot amount
1255         uint256 _pot = round_[_rID].pot;
1256 
1257         // calculate our winner share, community rewards, gen share,
1258         // p3d share, and amount reserved for next pot
1259         uint256 _win = (_pot.mul(48)) / 100;
1260         uint256 _com = (_pot / 50);
1261         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1262         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1263         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1264 
1265         // calculate ppt for round mask
1266         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1267         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1268         if (_dust > 0)
1269         {
1270             _gen = _gen.sub(_dust);
1271             _res = _res.add(_dust);
1272         }
1273 
1274         // pay our winner
1275         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1276 
1277         // community rewards
1278         _com = _com.add(_p3d.sub(_p3d / 2));
1279         yyyy.transfer((_com.mul(80)/100));
1280         gggg.transfer((_com.sub((_com.mul(80)/100))));
1281 
1282         _res = _res.add(_p3d / 2);
1283 
1284         // distribute gen portion to key holders
1285         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1286 
1287         // prepare event data
1288         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1289         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1290         _eventData_.winnerAddr = plyr_[_winPID].addr;
1291         _eventData_.winnerName = plyr_[_winPID].name;
1292         _eventData_.amountWon = _win;
1293         _eventData_.genAmount = _gen;
1294         _eventData_.P3DAmount = _p3d;
1295         _eventData_.newPot = _res;
1296 
1297         // start next round
1298         rID_++;
1299         _rID++;
1300         round_[_rID].strt = now;
1301         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1302         round_[_rID].pot = _res;
1303 
1304         return(_eventData_);
1305     }
1306 
1307     /**
1308      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1309      */
1310     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1311         private
1312     {
1313         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1314         if (_earnings > 0)
1315         {
1316             // put in gen vault
1317             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1318             // zero out their earnings by updating mask
1319             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1320         }
1321     }
1322 
1323     /**
1324      * @dev updates round timer based on number of whole keys bought.
1325      */
1326     function updateTimer(uint256 _keys, uint256 _rID)
1327         private
1328     {
1329         // grab time
1330         uint256 _now = now;
1331 
1332         // calculate time based on number of keys bought
1333         uint256 _newTime;
1334         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1335             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1336         else
1337             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1338 
1339         // compare to max and set new end time
1340         if (_newTime < (rndMax_).add(_now))
1341             round_[_rID].end = _newTime;
1342         else
1343             round_[_rID].end = rndMax_.add(_now);
1344     }
1345 
1346     /**
1347      * @dev generates a random number between 0-99 and checks to see if thats
1348      * resulted in an airdrop win
1349      * @return do we have a winner?
1350      */
1351     function airdrop()
1352         private
1353         view
1354         returns(bool)
1355     {
1356         uint256 seed = uint256(keccak256(abi.encodePacked(
1357 
1358             (block.timestamp).add
1359             (block.difficulty).add
1360             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1361             (block.gaslimit).add
1362             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1363             (block.number)
1364 
1365         )));
1366         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1367             return(true);
1368         else
1369             return(false);
1370     }
1371 
1372     /**
1373      * @dev distributes eth based on fees to com, aff, and p3d
1374      */
1375     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, FFFdatasets.EventReturns memory _eventData_)
1376         private
1377         returns(FFFdatasets.EventReturns)
1378     {
1379         // pay 3% out to community rewards
1380         uint256 _p1 = _eth / 100;
1381         uint256 _com = _eth / 50;
1382         _com = _com.add(_p1);
1383 
1384         // distribute share to affiliate
1385         uint256 _aff = _eth / 10;
1386 
1387         // decide what to do with affiliate share of fees
1388         // affiliate must not be self, and must have a name registered
1389         if (_affID != _pID && plyr_[_affID].name != '') {
1390             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1391             emit FFFevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1392         } else {
1393             _com = (_com.add(_aff));
1394         }
1395 
1396         // pay out p3d
1397         uint256 _p3d;
1398         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1399         if (_p3d > 0)
1400         {
1401             // deposit to divies contract
1402             uint256 _potAmount = _p3d / 2;
1403 
1404             _com = (_com.add((_p3d.sub(_potAmount))));
1405 
1406             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1407 
1408             // set up event data
1409             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1410         }
1411 
1412         yyyy.transfer((_com.mul(80)/100));
1413         gggg.transfer((_com.sub((_com.mul(80)/100))));
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
1426         emit FFFevents.onPotSwapDeposit(_rID, msg.value);
1427     }
1428 
1429     /**
1430      * @dev distributes eth based on fees to gen and pot
1431      */
1432     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, FFFdatasets.EventReturns memory _eventData_)
1433         private
1434         returns(FFFdatasets.EventReturns)
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
1523     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, FFFdatasets.EventReturns memory _eventData_)
1524         private
1525     {
1526         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1527         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1528 
1529         emit FFFevents.onEndTx
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
1562         // can only be ran once
1563         require(activated_ == false, "FOMO Short already activated");
1564 
1565         // activate the contract
1566         activated_ = true;
1567 
1568         // lets start first round
1569         rID_ = 1;
1570             round_[1].strt = now + rndExtra_ - rndGap_;
1571             round_[1].end = now + rndInit_ + rndExtra_;
1572     }
1573 }
1574 
1575 //==============================================================================
1576 //   __|_ _    __|_ _  .
1577 //  _\ | | |_|(_ | _\  .
1578 //==============================================================================
1579 library FFFdatasets {
1580     //compressedData key
1581     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1582         // 0 - new player (bool)
1583         // 1 - joined round (bool)
1584         // 2 - new  leader (bool)
1585         // 3-5 - air drop tracker (uint 0-999)
1586         // 6-16 - round end time
1587         // 17 - winnerTeam
1588         // 18 - 28 timestamp
1589         // 29 - team
1590         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1591         // 31 - airdrop happened bool
1592         // 32 - airdrop tier
1593         // 33 - airdrop amount won
1594     //compressedIDs key
1595     // [77-52][51-26][25-0]
1596         // 0-25 - pID
1597         // 26-51 - winPID
1598         // 52-77 - rID
1599     struct EventReturns {
1600         uint256 compressedData;
1601         uint256 compressedIDs;
1602         address winnerAddr;         // winner address
1603         bytes32 winnerName;         // winner name
1604         uint256 amountWon;          // amount won
1605         uint256 newPot;             // amount in new pot
1606         uint256 P3DAmount;          // amount distributed to p3d
1607         uint256 genAmount;          // amount distributed to gen
1608         uint256 potAmount;          // amount added to pot
1609     }
1610     struct Player {
1611         address addr;   // player address
1612         bytes32 name;   // player name
1613         uint256 win;    // winnings vault
1614         uint256 gen;    // general vault
1615         uint256 aff;    // affiliate vault
1616         uint256 lrnd;   // last round played
1617         uint256 laff;   // last affiliate id used
1618     }
1619     struct PlayerRounds {
1620         uint256 eth;    // eth player has added to round (used for eth limiter)
1621         uint256 keys;   // keys
1622         uint256 mask;   // player mask
1623         uint256 ico;    // ICO phase investment
1624     }
1625     struct Round {
1626         uint256 plyr;   // pID of player in lead
1627         uint256 team;   // tID of team in lead
1628         uint256 end;    // time ends/ended
1629         bool ended;     // has round end function been ran
1630         uint256 strt;   // time round started
1631         uint256 keys;   // keys
1632         uint256 eth;    // total eth in
1633         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1634         uint256 mask;   // global mask
1635         uint256 ico;    // total eth sent in during ICO phase
1636         uint256 icoGen; // total eth for gen during ICO phase
1637         uint256 icoAvg; // average key price for ICO phase
1638     }
1639     struct TeamFee {
1640         uint256 gen;    // % of buy in thats paid to key holders of current round
1641         uint256 p3d;    // % of buy in thats paid to p3d holders
1642     }
1643     struct PotSplit {
1644         uint256 gen;    // % of pot thats paid to key holders of current round
1645         uint256 p3d;    // % of pot thats paid to p3d holders
1646     }
1647 }
1648 
1649 //==============================================================================
1650 //  |  _      _ _ | _  .
1651 //  |<(/_\/  (_(_||(_  .
1652 //=======/======================================================================
1653 library FFFKeysCalcShort {
1654     using SafeMath for *;
1655     /**
1656      * @dev calculates number of keys received given X eth
1657      * @param _curEth current amount of eth in contract
1658      * @param _newEth eth being spent
1659      * @return amount of ticket purchased
1660      */
1661     function keysRec(uint256 _curEth, uint256 _newEth)
1662         internal
1663         pure
1664         returns (uint256)
1665     {
1666         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1667     }
1668 
1669     /**
1670      * @dev calculates amount of eth received if you sold X keys
1671      * @param _curKeys current amount of keys that exist
1672      * @param _sellKeys amount of keys you wish to sell
1673      * @return amount of eth received
1674      */
1675     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1676         internal
1677         pure
1678         returns (uint256)
1679     {
1680         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1681     }
1682 
1683     /**
1684      * @dev calculates how many keys would exist with given an amount of eth
1685      * @param _eth eth "in contract"
1686      * @return number of keys that would exist
1687      */
1688     function keys(uint256 _eth)
1689         internal
1690         pure
1691         returns(uint256)
1692     {
1693         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1694     }
1695 
1696     /**
1697      * @dev calculates how much eth would be in contract given a number of keys
1698      * @param _keys number of keys "in contract"
1699      * @return eth that would exists
1700      */
1701     function eth(uint256 _keys)
1702         internal
1703         pure
1704         returns(uint256)
1705     {
1706         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1707     }
1708 }
1709 
1710 //==============================================================================
1711 //  . _ _|_ _  _ |` _  _ _  _  .
1712 //  || | | (/_| ~|~(_|(_(/__\  .
1713 //==============================================================================
1714 
1715 interface PlayerBookInterface {
1716     function getPlayerID(address _addr) external returns (uint256);
1717     function getPlayerName(uint256 _pID) external view returns (bytes32);
1718     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1719     function getPlayerAddr(uint256 _pID) external view returns (address);
1720     function getNameFee() external view returns (uint256);
1721     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1722     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1723     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1724 }
1725 
1726 /**
1727 * @title -Name Filter- v0.1.9
1728 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1729 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1730 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1731 *                                  _____                      _____
1732 *                                 (, /     /)       /) /)    (, /      /)          /)
1733 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1734 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1735 *          ┴ ┴                /   /          .-/ _____   (__ /
1736 *                            (__ /          (_/ (, /                                      /)™
1737 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1738 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1739 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1740 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1741 *              _       __    _      ____      ____  _   _    _____  ____  ___
1742 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1743 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1744 *
1745 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1746 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1747 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1748 */
1749 
1750 library NameFilter {
1751     /**
1752      * @dev filters name strings
1753      * -converts uppercase to lower case.
1754      * -makes sure it does not start/end with a space
1755      * -makes sure it does not contain multiple spaces in a row
1756      * -cannot be only numbers
1757      * -cannot start with 0x
1758      * -restricts characters to A-Z, a-z, 0-9, and space.
1759      * @return reprocessed string in bytes32 format
1760      */
1761     function nameFilter(string _input)
1762         internal
1763         pure
1764         returns(bytes32)
1765     {
1766         bytes memory _temp = bytes(_input);
1767         uint256 _length = _temp.length;
1768 
1769         //sorry limited to 32 characters
1770         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1771         // make sure it doesnt start with or end with space
1772         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1773         // make sure first two characters are not 0x
1774         if (_temp[0] == 0x30)
1775         {
1776             require(_temp[1] != 0x78, "string cannot start with 0x");
1777             require(_temp[1] != 0x58, "string cannot start with 0X");
1778         }
1779 
1780         // create a bool to track if we have a non number character
1781         bool _hasNonNumber;
1782 
1783         // convert & check
1784         for (uint256 i = 0; i < _length; i++)
1785         {
1786             // if its uppercase A-Z
1787             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1788             {
1789                 // convert to lower case a-z
1790                 _temp[i] = byte(uint(_temp[i]) + 32);
1791 
1792                 // we have a non number
1793                 if (_hasNonNumber == false)
1794                     _hasNonNumber = true;
1795             } else {
1796                 require
1797                 (
1798                     // require character is a space
1799                     _temp[i] == 0x20 ||
1800                     // OR lowercase a-z
1801                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1802                     // or 0-9
1803                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1804                     "string contains invalid characters"
1805                 );
1806                 // make sure theres not 2x spaces in a row
1807                 if (_temp[i] == 0x20)
1808                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1809 
1810                 // see if we have a character other than a number
1811                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1812                     _hasNonNumber = true;
1813             }
1814         }
1815 
1816         require(_hasNonNumber == true, "string cannot be only numbers");
1817 
1818         bytes32 _ret;
1819         assembly {
1820             _ret := mload(add(_temp, 32))
1821         }
1822         return (_ret);
1823     }
1824 }
1825 
1826 /**
1827  * @title SafeMath v0.1.9
1828  * @dev Math operations with safety checks that throw on error
1829  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1830  * - added sqrt
1831  * - added sq
1832  * - added pwr
1833  * - changed asserts to requires with error log outputs
1834  * - removed div, its useless
1835  */
1836 library SafeMath {
1837 
1838     /**
1839     * @dev Multiplies two numbers, throws on overflow.
1840     */
1841     function mul(uint256 a, uint256 b)
1842         internal
1843         pure
1844         returns (uint256 c)
1845     {
1846         if (a == 0) {
1847             return 0;
1848         }
1849         c = a * b;
1850         require(c / a == b, "SafeMath mul failed");
1851         return c;
1852     }
1853 
1854     /**
1855     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1856     */
1857     function sub(uint256 a, uint256 b)
1858         internal
1859         pure
1860         returns (uint256)
1861     {
1862         require(b <= a, "SafeMath sub failed");
1863         return a - b;
1864     }
1865 
1866     /**
1867     * @dev Adds two numbers, throws on overflow.
1868     */
1869     function add(uint256 a, uint256 b)
1870         internal
1871         pure
1872         returns (uint256 c)
1873     {
1874         c = a + b;
1875         require(c >= a, "SafeMath add failed");
1876         return c;
1877     }
1878 
1879     /**
1880      * @dev gives square root of given x.
1881      */
1882     function sqrt(uint256 x)
1883         internal
1884         pure
1885         returns (uint256 y)
1886     {
1887         uint256 z = ((add(x,1)) / 2);
1888         y = x;
1889         while (z < y)
1890         {
1891             y = z;
1892             z = ((add((x / z),z)) / 2);
1893         }
1894     }
1895 
1896     /**
1897      * @dev gives square. multiplies x by x
1898      */
1899     function sq(uint256 x)
1900         internal
1901         pure
1902         returns (uint256)
1903     {
1904         return (mul(x,x));
1905     }
1906 
1907     /**
1908      * @dev x to the power of y
1909      */
1910     function pwr(uint256 x, uint256 y)
1911         internal
1912         pure
1913         returns (uint256)
1914     {
1915         if (x==0)
1916             return (0);
1917         else if (y==0)
1918             return (1);
1919         else
1920         {
1921             uint256 z = x;
1922             for (uint256 i=1; i < y; i++)
1923                 z = mul(z,x);
1924             return (z);
1925         }
1926     }
1927 }