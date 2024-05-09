1 pragma solidity ^0.4.24;
2 
3 contract PoHEVENTS {
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
31         uint256 PoCAmount,
32         uint256 genAmount,
33         uint256 potAmount
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
58         uint256 PoCAmount,
59         uint256 genAmount
60     );
61 
62     // fired whenever a player tries a buy after round timer
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
75         uint256 PoCAmount,
76         uint256 genAmount
77     );
78 
79     // fired whenever a player tries a reload after round timer
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
91         uint256 PoCAmount,
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
120 contract POHMO is PoHEVENTS {
121     using SafeMath for *;
122     using NameFilter for string;
123     using KeysCalc for uint256;
124 
125     PlayerBookInterface private PlayerBook;
126 
127 //==============================================================================
128 //     _ _  _  |`. _     _ _ |_ | _  _  .
129 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
130 //=================_|===========================================================
131     address private admin = msg.sender;
132     address private _POHWHALE;
133     string constant public name = "POHMO";
134     string constant public symbol = "POHMO";
135     uint256 private rndExtra_ = 1 seconds;     // length of the very first ICO
136     uint256 private rndGap_ = 1 seconds;         // length of ICO phase, set to 1 year for EOS.
137     uint256 private rndInit_ = 6 hours;                // round timer starts at this
138     uint256 constant private rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
139     uint256 private rndMax_ = 6 hours;                          // max length a round timer can be             
140 //==============================================================================
141 //     _| _ _|_ _    _ _ _|_    _   .
142 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
143 //=============================|================================================
144     uint256 public rID_;    // round id number / total rounds that have happened
145 //****************
146 // PLAYER DATA
147 //****************
148     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
149     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
150     mapping (uint256 => POHMODATASETS.Player) public plyr_;   // (pID => data) player data
151     mapping (uint256 => mapping (uint256 => POHMODATASETS.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
152     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
153 //****************
154 // ROUND DATA
155 //****************
156     mapping (uint256 => POHMODATASETS.Round) public round_;   // (rID => data) round data
157     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
158 //****************
159 // TEAM FEE DATA
160 //****************
161     mapping (uint256 => POHMODATASETS.TeamFee) public fees_;          // (team => fees) fee distribution by team
162     mapping (uint256 => POHMODATASETS.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
163 //==============================================================================
164 //     _ _  _  __|_ _    __|_ _  _  .
165 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
166 //==============================================================================
167     constructor(address whaleContract, address playerbook)
168         public
169     {
170         _POHWHALE = whaleContract;
171         PlayerBook = PlayerBookInterface(playerbook);
172 
173         //no teams... only POOH-heads
174         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
175         fees_[0] = POHMODATASETS.TeamFee(47,12);   //30% to pot, 10% to aff, 1% to dev,
176        
177 
178         potSplit_[0] = POHMODATASETS.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to dev
179     }
180 //==============================================================================
181 //     _ _  _  _|. |`. _  _ _  .
182 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
183 //==============================================================================
184     /**
185      * @dev used to make sure no one can interact with contract until it has
186      * been activated.
187      */
188     modifier isActivated() {
189         require(activated_ == true);
190         _;
191     }
192 
193     /**
194      * @dev prevents contracts from interacting with fomo3d
195      */
196     modifier isHuman() {
197         address _addr = msg.sender;
198         uint256 _codeLength;
199 
200         assembly {_codeLength := extcodesize(_addr)}
201         require(_codeLength == 0);
202         require(_addr == tx.origin);
203         _;
204     }
205 
206     /**
207      * @dev sets boundaries for incoming tx
208      */
209     modifier isWithinLimits(uint256 _eth) {
210         require(_eth >= 1000000000);
211         require(_eth <= 100000000000000000000000);
212         _;
213     }
214 
215 //==============================================================================
216 //     _    |_ |. _   |`    _  __|_. _  _  _  .
217 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
218 //====|=========================================================================
219     /**
220      * @dev emergency buy uses last stored affiliate ID
221      */
222     function()
223         isActivated()
224         isHuman()
225         isWithinLimits(msg.value)
226         public
227         payable
228     {
229         // set up our tx event data and determine if player is new or not
230         POHMODATASETS.EventReturns memory _eventData_ = determinePID(_eventData_);
231 
232         // fetch player id
233         uint256 _pID = pIDxAddr_[msg.sender];
234 
235         // buy core
236         buyCore(_pID, plyr_[_pID].laff, _eventData_);
237     }
238 
239     /**
240      * @dev converts all incoming ethereum to keys.
241      * -functionhash- 0x8f38f309 (using ID for affiliate)
242      * -functionhash- 0x98a0871d (using address for affiliate)
243      * -functionhash- 0xa65b37a1 (using name for affiliate)
244      * @param _affCode the ID/address/name of the player who gets the affiliate fee
245      */
246     function buyXid(uint256 _affCode)
247         isActivated()
248         isHuman()
249         isWithinLimits(msg.value)
250         public
251         payable
252     {
253         // set up our tx event data and determine if player is new or not
254         POHMODATASETS.EventReturns memory _eventData_ = determinePID(_eventData_);
255 
256         // fetch player id
257         uint256 _pID = pIDxAddr_[msg.sender];
258 
259         // manage affiliate residuals
260         // if no affiliate code was given or player tried to use their own, lolz
261         if (_affCode == 0 || _affCode == _pID)
262         {
263             // use last stored affiliate code
264             _affCode = plyr_[_pID].laff;
265 
266         // if affiliate code was given & its not the same as previously stored
267         } else if (_affCode != plyr_[_pID].laff) {
268             // update last affiliate
269             plyr_[_pID].laff = _affCode;
270         }
271 
272         // buy core
273         buyCore(_pID, _affCode, _eventData_);
274     }
275 
276     function buyXaddr(address _affCode)
277         isActivated()
278         isHuman()
279         isWithinLimits(msg.value)
280         public
281         payable
282     {
283         // set up our tx event data and determine if player is new or not
284         POHMODATASETS.EventReturns memory _eventData_ = determinePID(_eventData_);
285 
286         // fetch player id
287         uint256 _pID = pIDxAddr_[msg.sender];
288 
289         // manage affiliate residuals
290         uint256 _affID;
291         // if no affiliate code was given or player tried to use their own, lolz
292         if (_affCode == address(0) || _affCode == msg.sender)
293         {
294             // use last stored affiliate code
295             _affID = plyr_[_pID].laff;
296 
297         // if affiliate code was given
298         } else {
299             // get affiliate ID from aff Code
300             _affID = pIDxAddr_[_affCode];
301 
302             // if affID is not the same as previously stored
303             if (_affID != plyr_[_pID].laff)
304             {
305                 // update last affiliate
306                 plyr_[_pID].laff = _affID;
307             }
308         }
309         // buy core
310         buyCore(_pID, _affID, _eventData_);
311     }
312 
313     function buyXname(bytes32 _affCode)
314         isActivated()
315         isHuman()
316         isWithinLimits(msg.value)
317         public
318         payable
319     {
320         // set up our tx event data and determine if player is new or not
321         POHMODATASETS.EventReturns memory _eventData_ = determinePID(_eventData_);
322 
323         // fetch player id
324         uint256 _pID = pIDxAddr_[msg.sender];
325 
326         // manage affiliate residuals
327         uint256 _affID;
328         // if no affiliate code was given or player tried to use their own, lolz
329         if (_affCode == '' || _affCode == plyr_[_pID].name)
330         {
331             // use last stored affiliate code
332             _affID = plyr_[_pID].laff;
333 
334         // if affiliate code was given
335         } else {
336             // get affiliate ID from aff Code
337             _affID = pIDxName_[_affCode];
338 
339             // if affID is not the same as previously stored
340             if (_affID != plyr_[_pID].laff)
341             {
342                 // update last affiliate
343                 plyr_[_pID].laff = _affID;
344             }
345         }
346 
347         // buy core
348         buyCore(_pID, _affID, _eventData_);
349     }
350 
351     /**
352      * @dev essentially the same as buy, but instead of you sending ether
353      * from your wallet, it uses your unwithdrawn earnings.
354      * -functionhash- 0x349cdcac (using ID for affiliate)
355      * -functionhash- 0x82bfc739 (using address for affiliate)
356      * -functionhash- 0x079ce327 (using name for affiliate)
357      * @param _affCode the ID/address/name of the player who gets the affiliate fee
358      * @param _eth amount of earnings to use (remainder returned to gen vault)
359      */
360     function reLoadXid(uint256 _affCode, uint256 _eth)
361         isActivated()
362         isHuman()
363         isWithinLimits(_eth)
364         public
365     {
366         // set up our tx event data
367         POHMODATASETS.EventReturns memory _eventData_;
368 
369         // fetch player ID
370         uint256 _pID = pIDxAddr_[msg.sender];
371 
372         // manage affiliate residuals
373         // if no affiliate code was given or player tried to use their own, lolz
374         if (_affCode == 0 || _affCode == _pID)
375         {
376             // use last stored affiliate code
377             _affCode = plyr_[_pID].laff;
378 
379         // if affiliate code was given & its not the same as previously stored
380         } else if (_affCode != plyr_[_pID].laff) {
381             // update last affiliate
382             plyr_[_pID].laff = _affCode;
383         }
384 
385         // reload core
386         reLoadCore(_pID, _affCode, _eth, _eventData_);
387     }
388 
389     function reLoadXaddr(address _affCode, uint256 _eth)
390         isActivated()
391         isHuman()
392         isWithinLimits(_eth)
393         public
394     {
395         // set up our tx event data
396         POHMODATASETS.EventReturns memory _eventData_;
397 
398         // fetch player ID
399         uint256 _pID = pIDxAddr_[msg.sender];
400 
401         // manage affiliate residuals
402         uint256 _affID;
403         // if no affiliate code was given or player tried to use their own, lolz
404         if (_affCode == address(0) || _affCode == msg.sender)
405         {
406             // use last stored affiliate code
407             _affID = plyr_[_pID].laff;
408 
409         // if affiliate code was given
410         } else {
411             // get affiliate ID from aff Code
412             _affID = pIDxAddr_[_affCode];
413 
414             // if affID is not the same as previously stored
415             if (_affID != plyr_[_pID].laff)
416             {
417                 // update last affiliate
418                 plyr_[_pID].laff = _affID;
419             }
420         }
421 
422         // reload core
423         reLoadCore(_pID, _affID, _eth, _eventData_);
424     }
425 
426     function reLoadXname(bytes32 _affCode, uint256 _eth)
427         isActivated()
428         isHuman()
429         isWithinLimits(_eth)
430         public
431     {
432         // set up our tx event data
433         POHMODATASETS.EventReturns memory _eventData_;
434 
435         // fetch player ID
436         uint256 _pID = pIDxAddr_[msg.sender];
437 
438         // manage affiliate residuals
439         uint256 _affID;
440         // if no affiliate code was given or player tried to use their own, lolz
441         if (_affCode == '' || _affCode == plyr_[_pID].name)
442         {
443             // use last stored affiliate code
444             _affID = plyr_[_pID].laff;
445 
446         // if affiliate code was given
447         } else {
448             // get affiliate ID from aff Code
449             _affID = pIDxName_[_affCode];
450 
451             // if affID is not the same as previously stored
452             if (_affID != plyr_[_pID].laff)
453             {
454                 // update last affiliate
455                 plyr_[_pID].laff = _affID;
456             }
457         }
458 
459         // reload core
460         reLoadCore(_pID, _affID, _eth, _eventData_);
461     }
462 
463     /**
464      * @dev withdraws all of your earnings.
465      * -functionhash- 0x3ccfd60b
466      */
467     function withdraw()
468         isActivated()
469         isHuman()
470         public
471     {
472         // setup local rID
473         uint256 _rID = rID_;
474 
475         // grab time
476         uint256 _now = now;
477 
478         // fetch player ID
479         uint256 _pID = pIDxAddr_[msg.sender];
480 
481         // setup temp var for player eth
482         uint256 _eth;
483 
484         // check to see if round has ended and no one has run round end yet
485         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
486         {
487             // set up our tx event data
488             POHMODATASETS.EventReturns memory _eventData_;
489 
490             // end the round (distributes pot)
491             round_[_rID].ended = true;
492             _eventData_ = endRound(_eventData_);
493 
494             // get their earnings
495             _eth = withdrawEarnings(_pID);
496 
497             // gib moni
498             if (_eth > 0)
499                 plyr_[_pID].addr.transfer(_eth);
500 
501             // build event data
502             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
503             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
504 
505             // fire withdraw and distribute event
506             emit PoHEVENTS.onWithdrawAndDistribute
507             (
508                 msg.sender,
509                 plyr_[_pID].name,
510                 _eth,
511                 _eventData_.compressedData,
512                 _eventData_.compressedIDs,
513                 _eventData_.winnerAddr,
514                 _eventData_.winnerName,
515                 _eventData_.amountWon,
516                 _eventData_.newPot,
517                 _eventData_.PoCAmount,
518                 _eventData_.genAmount
519             );
520 
521         // in any other situation
522         } else {
523             // get their earnings
524             _eth = withdrawEarnings(_pID);
525 
526             // gib moni
527             if (_eth > 0)
528                 plyr_[_pID].addr.transfer(_eth);
529 
530             // fire withdraw event
531             emit PoHEVENTS.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
532         }
533     }
534 
535     /**
536      * @dev use these to register names.  they are just wrappers that will send the
537      * registration requests to the PlayerBook contract.  So registering here is the
538      * same as registering there.  UI will always display the last name you registered.
539      * but you will still own all previously registered names to use as affiliate
540      * links.
541      * - must pay a registration fee.
542      * - name must be unique
543      * - names will be converted to lowercase
544      * - name cannot start or end with a space
545      * - cannot have more than 1 space in a row
546      * - cannot be only numbers
547      * - cannot start with 0x
548      * - name must be at least 1 char
549      * - max length of 32 characters long
550      * - allowed characters: a-z, 0-9, and space
551      * -functionhash- 0x921dec21 (using ID for affiliate)
552      * -functionhash- 0x3ddd4698 (using address for affiliate)
553      * -functionhash- 0x685ffd83 (using name for affiliate)
554      * @param _nameString players desired name
555      * @param _affCode affiliate ID, address, or name of who referred you
556      * @param _all set to true if you want this to push your info to all games
557      * (this might cost a lot of gas)
558      */
559     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
560         isHuman()
561         public
562         payable
563     {
564         bytes32 _name = _nameString.nameFilter();
565         address _addr = msg.sender;
566         uint256 _paid = msg.value;
567         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
568 
569         uint256 _pID = pIDxAddr_[_addr];
570 
571         // fire event
572         emit PoHEVENTS.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
573     }
574 
575     function registerNameXaddr(string _nameString, address _affCode, bool _all)
576         isHuman()
577         public
578         payable
579     {
580         bytes32 _name = _nameString.nameFilter();
581         address _addr = msg.sender;
582         uint256 _paid = msg.value;
583         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
584 
585         uint256 _pID = pIDxAddr_[_addr];
586 
587         // fire event
588         emit PoHEVENTS.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
589     }
590 
591     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
592         isHuman()
593         public
594         payable
595     {
596         bytes32 _name = _nameString.nameFilter();
597         address _addr = msg.sender;
598         uint256 _paid = msg.value;
599         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
600 
601         uint256 _pID = pIDxAddr_[_addr];
602 
603         // fire event
604         emit PoHEVENTS.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
605     }
606 //==============================================================================
607 //     _  _ _|__|_ _  _ _  .
608 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
609 //=====_|=======================================================================
610     /**
611      * @dev return the price buyer will pay for next 1 individual key.
612      * -functionhash- 0x018a25e8
613      * @return price for next key bought (in wei format)
614      */
615     function getBuyPrice()
616         public
617         view
618         returns(uint256)
619     {
620         // setup local rID
621         uint256 _rID = rID_;
622 
623         // grab time
624         uint256 _now = now;
625 
626         // are we in a round?
627         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
628             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
629         else // rounds over.  need price for new round
630             return ( 75000000000000 ); // init
631     }
632 
633     /**
634      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
635      * provider
636      * -functionhash- 0xc7e284b8
637      * @return time left in seconds
638      */
639     function getTimeLeft()
640         public
641         view
642         returns(uint256)
643     {
644         // setup local rID
645         uint256 _rID = rID_;
646 
647         // grab time
648         uint256 _now = now;
649 
650         if (_now < round_[_rID].end)
651             if (_now > round_[_rID].strt + rndGap_)
652                 return( (round_[_rID].end).sub(_now) );
653             else
654                 return( (round_[_rID].strt + rndGap_).sub(_now) );
655         else
656             return(0);
657     }
658 
659     /**
660      * @dev returns player earnings per vaults
661      * -functionhash- 0x63066434
662      * @return winnings vault
663      * @return general vault
664      * @return affiliate vault
665      */
666     function getPlayerVaults(uint256 _pID)
667         public
668         view
669         returns(uint256 ,uint256, uint256)
670     {
671         // setup local rID
672         uint256 _rID = rID_;
673 
674         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
675         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
676         {
677             // if player is winner
678             if (round_[_rID].plyr == _pID)
679             {
680                 return
681                 (
682                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
683                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
684                     plyr_[_pID].aff
685                 );
686             // if player is not the winner
687             } else {
688                 return
689                 (
690                     plyr_[_pID].win,
691                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
692                     plyr_[_pID].aff
693                 );
694             }
695 
696         // if round is still going on, or round has ended and round end has been ran
697         } else {
698             return
699             (
700                 plyr_[_pID].win,
701                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
702                 plyr_[_pID].aff
703             );
704         }
705     }
706 
707     /**
708      * solidity hates stack limits.  this lets us avoid that hate
709      */
710     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
711         private
712         view
713         returns(uint256)
714     {
715         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
716     }
717 
718     /**
719      * @dev returns all current round info needed for front end
720      * -functionhash- 0x747dff42
721      * @return eth invested during ICO phase
722      * @return round id
723      * @return total keys for round
724      * @return time round ends
725      * @return time round started
726      * @return current pot
727      * @return current team ID & player ID in lead
728      * @return current player in leads address
729      * @return current player in leads name
730      * @return whales eth in for round
731      * @return bears eth in for round
732      * @return sneks eth in for round
733      * @return bulls eth in for round
734      */
735     function getCurrentRoundInfo()
736         public
737         view
738         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
739     {
740         // setup local rID
741         uint256 _rID = rID_;
742 
743         return
744         (
745             round_[_rID].ico,               //0
746             _rID,                           //1
747             round_[_rID].keys,              //2
748             round_[_rID].end,               //3
749             round_[_rID].strt,              //4
750             round_[_rID].pot,               //5
751             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
752             plyr_[round_[_rID].plyr].addr,  //7
753             plyr_[round_[_rID].plyr].name,  //8
754             rndTmEth_[_rID][0],             //9
755             rndTmEth_[_rID][1],             //10
756             rndTmEth_[_rID][2],             //11
757             rndTmEth_[_rID][3]              //12
758           
759         );
760     }
761 
762     /**
763      * @dev returns player info based on address.  if no address is given, it will
764      * use msg.sender
765      * -functionhash- 0xee0b5d8b
766      * @param _addr address of the player you want to lookup
767      * @return player ID
768      * @return player name
769      * @return keys owned (current round)
770      * @return winnings vault
771      * @return general vault
772      * @return affiliate vault
773      * @return player round eth
774      */
775     function getPlayerInfoByAddress(address _addr)
776         public
777         view
778         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
779     {
780         // setup local rID
781         uint256 _rID = rID_;
782 
783         if (_addr == address(0))
784         {
785             _addr == msg.sender;
786         }
787         uint256 _pID = pIDxAddr_[_addr];
788 
789         return
790         (
791             _pID,                               //0
792             plyr_[_pID].name,                   //1
793             plyrRnds_[_pID][_rID].keys,         //2
794             plyr_[_pID].win,                    //3
795             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
796             plyr_[_pID].aff,                    //5
797             plyrRnds_[_pID][_rID].eth           //6
798         );
799     }
800 
801 //==============================================================================
802 //     _ _  _ _   | _  _ . _  .
803 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
804 //=====================_|=======================================================
805     /**
806      * @dev logic runs whenever a buy order is executed.  determines how to handle
807      * incoming eth depending on if we are in an active round or not
808      */
809     function buyCore(uint256 _pID, uint256 _affID, POHMODATASETS.EventReturns memory _eventData_)
810         private
811     {
812         // setup local rID
813         uint256 _rID = rID_;
814 
815         // grab time
816         uint256 _now = now;
817 
818         // if round is active
819         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
820         {
821             // call core
822             core(_rID, _pID, msg.value, _affID, 0, _eventData_);
823 
824         // if round is not active
825         } else {
826             // check to see if end round needs to be ran
827             if (_now > round_[_rID].end && round_[_rID].ended == false)
828             {
829                 // end the round (distributes pot) & start new round
830                 round_[_rID].ended = true;
831                 _eventData_ = endRound(_eventData_);
832 
833                 // build event data
834                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
835                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
836 
837                 // fire buy and distribute event
838                 emit PoHEVENTS.onBuyAndDistribute
839                 (
840                     msg.sender,
841                     plyr_[_pID].name,
842                     msg.value,
843                     _eventData_.compressedData,
844                     _eventData_.compressedIDs,
845                     _eventData_.winnerAddr,
846                     _eventData_.winnerName,
847                     _eventData_.amountWon,
848                     _eventData_.newPot,
849                     _eventData_.PoCAmount,
850                     _eventData_.genAmount
851                 );
852             }
853 
854             // put eth in players vault
855             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
856         }
857     }
858 
859     /**
860      * @dev logic runs whenever a reload order is executed.  determines how to handle
861      * incoming eth depending on if we are in an active round or not
862      */
863     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, POHMODATASETS.EventReturns memory _eventData_)
864         private
865     {
866         // setup local rID
867         uint256 _rID = rID_;
868 
869         // grab time
870         uint256 _now = now;
871 
872         // if round is active
873         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
874         {
875             // get earnings from all vaults and return unused to gen vault
876             // because we use a custom safemath library.  this will throw if player
877             // tried to spend more eth than they have.
878             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
879 
880             // call core
881             core(_rID, _pID, _eth, _affID, 0, _eventData_);
882 
883         // if round is not active and end round needs to be ran
884         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
885             // end the round (distributes pot) & start new round
886             round_[_rID].ended = true;
887             _eventData_ = endRound(_eventData_);
888 
889             // build event data
890             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
891             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
892 
893             // fire buy and distribute event
894             emit PoHEVENTS.onReLoadAndDistribute
895             (
896                 msg.sender,
897                 plyr_[_pID].name,
898                 _eventData_.compressedData,
899                 _eventData_.compressedIDs,
900                 _eventData_.winnerAddr,
901                 _eventData_.winnerName,
902                 _eventData_.amountWon,
903                 _eventData_.newPot,
904                 _eventData_.PoCAmount,
905                 _eventData_.genAmount
906             );
907         }
908     }
909 
910     /**
911      * @dev this is the core logic for any buy/reload that happens while a round
912      * is live.
913      */
914     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POHMODATASETS.EventReturns memory _eventData_)
915         private
916     {
917         // if player is new to round
918         if (plyrRnds_[_pID][_rID].keys == 0)
919             _eventData_ = managePlayer(_pID, _eventData_);
920 
921         // early round eth limiter
922         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000)
923         {
924             uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
925             uint256 _refund = _eth.sub(_availableLimit);
926             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
927             _eth = _availableLimit;
928         }
929 
930         // if eth left is greater than min eth allowed (sorry no pocket lint)
931         if (_eth > 1000000000)
932         {
933 
934             // mint the new keys
935             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
936 
937             // if they bought at least 1 whole key
938             if (_keys >= 1000000000000000000)
939             {
940             updateTimer(_keys, _rID);
941 
942             // set new leaders
943             if (round_[_rID].plyr != _pID)
944                 round_[_rID].plyr = _pID;
945             if (round_[_rID].team != _team)
946                 round_[_rID].team = _team;
947 
948             // set the new leader bool to true
949             _eventData_.compressedData = _eventData_.compressedData + 100;
950         }
951 
952             // update player
953             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
954             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
955 
956             // update round
957             round_[_rID].keys = _keys.add(round_[_rID].keys);
958             round_[_rID].eth = _eth.add(round_[_rID].eth);
959             rndTmEth_[_rID][0] = _eth.add(rndTmEth_[_rID][0]);
960 
961             // distribute eth
962             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 0, _eventData_);
963             _eventData_ = distributeInternal(_rID, _pID, _eth, 0, _keys, _eventData_);
964 
965             // call end tx function to fire end tx event.
966             endTx(_pID, 0, _eth, _keys, _eventData_);
967         }
968     }
969 //==============================================================================
970 //     _ _ | _   | _ _|_ _  _ _  .
971 //    (_(_||(_|_||(_| | (_)| _\  .
972 //==============================================================================
973     /**
974      * @dev calculates unmasked earnings (just calculates, does not update mask)
975      * @return earnings in wei format
976      */
977     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
978         private
979         view
980         returns(uint256)
981     {
982         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
983     }
984 
985     /**
986      * @dev returns the amount of keys you would get given an amount of eth.
987      * -functionhash- 0xce89c80c
988      * @param _rID round ID you want price for
989      * @param _eth amount of eth sent in
990      * @return keys received
991      */
992     function calcKeysReceived(uint256 _rID, uint256 _eth)
993         public
994         view
995         returns(uint256)
996     {
997         // grab time
998         uint256 _now = now;
999 
1000         // are we in a round?
1001         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1002             return ( (round_[_rID].eth).keysRec(_eth) );
1003         else // rounds over.  need keys for new round
1004             return ( (_eth).keys() );
1005     }
1006 
1007     /**
1008      * @dev returns current eth price for X keys.
1009      * -functionhash- 0xcf808000
1010      * @param _keys number of keys desired (in 18 decimal format)
1011      * @return amount of eth needed to send
1012      */
1013     function iWantXKeys(uint256 _keys)
1014         public
1015         view
1016         returns(uint256)
1017     {
1018         // setup local rID
1019         uint256 _rID = rID_;
1020 
1021         // grab time
1022         uint256 _now = now;
1023 
1024         // are we in a round?
1025         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1026             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1027         else // rounds over.  need price for new round
1028             return ( (_keys).eth() );
1029     }
1030 //==============================================================================
1031 //    _|_ _  _ | _  .
1032 //     | (_)(_)|_\  .
1033 //==============================================================================
1034     /**
1035      * @dev receives name/player info from names contract
1036      */
1037     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1038         external
1039     {
1040         require (msg.sender == address(PlayerBook));
1041         if (pIDxAddr_[_addr] != _pID)
1042             pIDxAddr_[_addr] = _pID;
1043         if (pIDxName_[_name] != _pID)
1044             pIDxName_[_name] = _pID;
1045         if (plyr_[_pID].addr != _addr)
1046             plyr_[_pID].addr = _addr;
1047         if (plyr_[_pID].name != _name)
1048             plyr_[_pID].name = _name;
1049         if (plyr_[_pID].laff != _laff)
1050             plyr_[_pID].laff = _laff;
1051         if (plyrNames_[_pID][_name] == false)
1052             plyrNames_[_pID][_name] = true;
1053     }
1054 
1055     /**
1056      * @dev receives entire player name list
1057      */
1058     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1059         external
1060     {
1061         require (msg.sender == address(PlayerBook));
1062         if(plyrNames_[_pID][_name] == false)
1063             plyrNames_[_pID][_name] = true;
1064     }
1065 
1066     /**
1067      * @dev gets existing or registers new pID.  use this when a player may be new
1068      * @return pID
1069      */
1070     function determinePID(POHMODATASETS.EventReturns memory _eventData_)
1071         private
1072         returns (POHMODATASETS.EventReturns)
1073     {
1074         uint256 _pID = pIDxAddr_[msg.sender];
1075         // if player is new to this version of fomo3d
1076         if (_pID == 0)
1077         {
1078             // grab their player ID, name and last aff ID, from player names contract
1079             _pID = PlayerBook.getPlayerID(msg.sender);
1080             bytes32 _name = PlayerBook.getPlayerName(_pID);
1081             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1082 
1083             // set up player account
1084             pIDxAddr_[msg.sender] = _pID;
1085             plyr_[_pID].addr = msg.sender;
1086 
1087             if (_name != "")
1088             {
1089                 pIDxName_[_name] = _pID;
1090                 plyr_[_pID].name = _name;
1091                 plyrNames_[_pID][_name] = true;
1092             }
1093 
1094             if (_laff != 0 && _laff != _pID)
1095                 plyr_[_pID].laff = _laff;
1096 
1097             // set the new player bool to true
1098             _eventData_.compressedData = _eventData_.compressedData + 1;
1099         }
1100         return (_eventData_);
1101     }
1102 
1103     
1104 
1105     /**
1106      * @dev decides if round end needs to be run & new round started.  and if
1107      * player unmasked earnings from previously played rounds need to be moved.
1108      */
1109     function managePlayer(uint256 _pID, POHMODATASETS.EventReturns memory _eventData_)
1110         private
1111         returns (POHMODATASETS.EventReturns)
1112     {
1113         // if player has played a previous round, move their unmasked earnings
1114         // from that round to gen vault.
1115         if (plyr_[_pID].lrnd != 0)
1116             updateGenVault(_pID, plyr_[_pID].lrnd);
1117 
1118         // update player's last round played
1119         plyr_[_pID].lrnd = rID_;
1120 
1121         // set the joined round bool to true
1122         _eventData_.compressedData = _eventData_.compressedData + 10;
1123 
1124         return(_eventData_);
1125     }
1126 
1127     /**
1128      * @dev ends the round. manages paying out winner/splitting up pot
1129      */
1130     function endRound(POHMODATASETS.EventReturns memory _eventData_)
1131         private
1132         returns (POHMODATASETS.EventReturns)
1133     {
1134         // setup local rID
1135         uint256 _rID = rID_;
1136 
1137         // grab our winning player and team id's
1138         uint256 _winPID = round_[_rID].plyr;
1139         uint256 _winTID = round_[_rID].team;
1140 
1141         // grab our pot amount
1142         uint256 _pot = round_[_rID].pot;
1143 
1144         // calculate our winner share, community rewards, gen share,
1145         // p3d share, and amount reserved for next pot
1146         uint256 _win = (_pot.mul(48)) / 100;   //48%
1147         uint256 _dev = (_pot / 50);            //2%
1148         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; //15
1149         uint256 _PoC = (_pot.mul(potSplit_[_winTID].pooh)) / 100; // 10
1150         uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_PoC); //25
1151 
1152         // calculate ppt for round mask
1153         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1154         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1155         if (_dust > 0)
1156         {
1157             _gen = _gen.sub(_dust);
1158             _res = _res.add(_dust);
1159         }
1160 
1161         // pay our winner
1162         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1163 
1164         // community rewards
1165 
1166         admin.transfer(_dev);
1167 
1168         _POHWHALE.call.value(_PoC)(bytes4(keccak256("donate()")));  
1169 
1170         // distribute gen portion to key holders
1171         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1172 
1173         // prepare event data
1174         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1175         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1176         _eventData_.winnerAddr = plyr_[_winPID].addr;
1177         _eventData_.winnerName = plyr_[_winPID].name;
1178         _eventData_.amountWon = _win;
1179         _eventData_.genAmount = _gen;
1180         _eventData_.PoCAmount = _PoC;
1181         _eventData_.newPot = _res;
1182 
1183         // start next round
1184         rID_++;
1185         _rID++;
1186         round_[_rID].strt = now;
1187         round_[_rID].end = now.add(rndMax_);
1188         round_[_rID].pot = _res;
1189 
1190         return(_eventData_);
1191     }
1192 
1193     function determineNextRoundLength() internal view returns(uint256 time) 
1194     {
1195         uint256 roundTime = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1)))) % 6;
1196         return roundTime;
1197     }
1198     
1199 
1200     /**
1201      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1202      */
1203     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1204         private
1205     {
1206         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1207         if (_earnings > 0)
1208         {
1209             // put in gen vault
1210             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1211             // zero out their earnings by updating mask
1212             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1213         }
1214     }
1215 
1216     /**
1217      * @dev updates round timer based on number of whole keys bought.
1218      */
1219     function updateTimer(uint256 _keys, uint256 _rID)
1220         private
1221     {
1222         // grab time
1223         uint256 _now = now;
1224 
1225         // calculate time based on number of keys bought
1226         uint256 _newTime;
1227         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1228             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1229         else
1230             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1231 
1232         // compare to max and set new end time
1233         if (_newTime < (rndMax_).add(_now))
1234             round_[_rID].end = _newTime;
1235         else
1236             round_[_rID].end = rndMax_.add(_now);
1237     }
1238 
1239    
1240     /**
1241      * @dev distributes eth based on fees to com, aff, and pooh
1242      */
1243     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POHMODATASETS.EventReturns memory _eventData_)
1244         private
1245         returns(POHMODATASETS.EventReturns)
1246     {
1247         // pay 1% out to dev
1248         uint256 _dev = _eth / 100;  // 1%
1249 
1250         uint256 _PoC = 0;
1251         if (!address(admin).call.value(_dev)())
1252         {
1253             _PoC = _dev;
1254             _dev = 0;
1255         }
1256 
1257 
1258         // distribute share to affiliate
1259         uint256 _aff = _eth / 10;
1260 
1261         // decide what to do with affiliate share of fees
1262         // affiliate must not be self, and must have a name registered
1263         if (_affID != _pID && plyr_[_affID].name != '') {
1264             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1265             emit PoHEVENTS.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1266         } else {
1267             _PoC = _PoC.add(_aff);
1268         }
1269 
1270         // pay out POOH
1271         _PoC = _PoC.add((_eth.mul(fees_[_team].pooh)) / (100));
1272         if (_PoC > 0)
1273         {
1274             // deposit to divies contract
1275             _POHWHALE.call.value(_PoC)(bytes4(keccak256("donate()")));
1276 
1277             // set up event data
1278             _eventData_.PoCAmount = _PoC.add(_eventData_.PoCAmount);
1279         }
1280 
1281         return(_eventData_);
1282     }
1283 
1284     function potSwap()
1285         external
1286         payable
1287     {
1288        //you shouldn't be using this method
1289        admin.transfer(msg.value);
1290     }
1291 
1292     /**
1293      * @dev distributes eth based on fees to gen and pot
1294      */
1295     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, POHMODATASETS.EventReturns memory _eventData_)
1296         private
1297         returns(POHMODATASETS.EventReturns)
1298     {
1299         // calculate gen share
1300         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1301 
1302 
1303         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1304         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].pooh)) / 100));
1305 
1306         // calculate pot
1307         uint256 _pot = _eth.sub(_gen);
1308 
1309         // distribute gen share (thats what updateMasks() does) and adjust
1310         // balances for dust.
1311         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1312         if (_dust > 0)
1313             _gen = _gen.sub(_dust);
1314 
1315         // add eth to pot
1316         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1317 
1318         // set up event data
1319         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1320         _eventData_.potAmount = _pot;
1321 
1322         return(_eventData_);
1323     }
1324 
1325     /**
1326      * @dev updates masks for round and player when keys are bought
1327      * @return dust left over
1328      */
1329     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1330         private
1331         returns(uint256)
1332     {
1333         /* MASKING NOTES
1334             earnings masks are a tricky thing for people to wrap their minds around.
1335             the basic thing to understand here.  is were going to have a global
1336             tracker based on profit per share for each round, that increases in
1337             relevant proportion to the increase in share supply.
1338 
1339             the player will have an additional mask that basically says "based
1340             on the rounds mask, my shares, and how much i've already withdrawn,
1341             how much is still owed to me?"
1342         */
1343 
1344         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1345         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1346         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1347 
1348         // calculate player earning from their own buy (only based on the keys
1349         // they just bought).  & update player earnings mask
1350         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1351         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1352 
1353         // calculate & return dust
1354         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1355     }
1356 
1357     /**
1358      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1359      * @return earnings in wei format
1360      */
1361     function withdrawEarnings(uint256 _pID)
1362         private
1363         returns(uint256)
1364     {
1365         // update gen vault
1366         updateGenVault(_pID, plyr_[_pID].lrnd);
1367 
1368         // from vaults
1369         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1370         if (_earnings > 0)
1371         {
1372             plyr_[_pID].win = 0;
1373             plyr_[_pID].gen = 0;
1374             plyr_[_pID].aff = 0;
1375         }
1376 
1377         return(_earnings);
1378     }
1379 
1380     /**
1381      * @dev prepares compression data and fires event for buy or reload tx's
1382      */
1383     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, POHMODATASETS.EventReturns memory _eventData_)
1384         private
1385     {
1386         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1387         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1388 
1389         emit PoHEVENTS.onEndTx
1390         (
1391             _eventData_.compressedData,
1392             _eventData_.compressedIDs,
1393             plyr_[_pID].name,
1394             msg.sender,
1395             _eth,
1396             _keys,
1397             _eventData_.winnerAddr,
1398             _eventData_.winnerName,
1399             _eventData_.amountWon,
1400             _eventData_.newPot,
1401             _eventData_.PoCAmount,
1402             _eventData_.genAmount,
1403             _eventData_.potAmount
1404         );
1405     }
1406 //==============================================================================
1407 //    (~ _  _    _._|_    .
1408 //    _)(/_(_|_|| | | \/  .
1409 //====================/=========================================================
1410     /** upon contract deploy, it will be deactivated.  this is a one time
1411      * use function that will activate the contract.  we do this so devs
1412      * have time to set things up on the web end                            **/
1413     bool public activated_ = false;
1414     function activate()
1415         public
1416     {
1417         // only team just can activate
1418         require(msg.sender == admin);
1419 
1420 
1421         // can only be ran once
1422         require(activated_ == false);
1423 
1424         // activate the contract
1425         activated_ = true;
1426 
1427         // lets start first round
1428         rID_ = 1;
1429             round_[1].strt = now + rndExtra_ - rndGap_;
1430             round_[1].end = now + rndInit_ + rndExtra_;
1431     }
1432 }
1433 
1434 //==============================================================================
1435 //   __|_ _    __|_ _  .
1436 //  _\ | | |_|(_ | _\  .
1437 //==============================================================================
1438 library POHMODATASETS {
1439     
1440     struct EventReturns {
1441         uint256 compressedData;
1442         uint256 compressedIDs;
1443         address winnerAddr;         // winner address
1444         bytes32 winnerName;         // winner name
1445         uint256 amountWon;          // amount won
1446         uint256 newPot;             // amount in new pot
1447         uint256 PoCAmount;          // amount distributed to p3d
1448         uint256 genAmount;          // amount distributed to gen
1449         uint256 potAmount;          // amount added to pot
1450     }
1451     struct Player {
1452         address addr;   // player address
1453         bytes32 name;   // player name
1454         uint256 win;    // winnings vault
1455         uint256 gen;    // general vault
1456         uint256 aff;    // affiliate vault
1457         uint256 lrnd;   // last round played
1458         uint256 laff;   // last affiliate id used
1459     }
1460     struct PlayerRounds {
1461         uint256 eth;    // eth player has added to round (used for eth limiter)
1462         uint256 keys;   // keys
1463         uint256 mask;   // player mask
1464         uint256 ico;    // ICO phase investment
1465     }
1466     struct Round {
1467         uint256 plyr;   // pID of player in lead
1468         uint256 team;   // tID of team in lead
1469         uint256 end;    // time ends/ended
1470         bool ended;     // has round end function been ran
1471         uint256 strt;   // time round started
1472         uint256 keys;   // keys
1473         uint256 eth;    // total eth in
1474         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1475         uint256 mask;   // global mask
1476         uint256 ico;    // total eth sent in during ICO phase
1477         uint256 icoGen; // total eth for gen during ICO phase
1478         uint256 icoAvg; // average key price for ICO phase
1479     }
1480     struct TeamFee {
1481         uint256 gen;    // % of buy in thats paid to key holders of current round
1482         uint256 pooh;    // % of buy in thats paid to POOH holders
1483     }
1484     struct PotSplit {
1485         uint256 gen;    // % of pot thats paid to key holders of current round
1486         uint256 pooh;    // % of pot thats paid to POOH holders
1487     }
1488 }
1489 
1490 //==============================================================================
1491 //  |  _      _ _ | _  .
1492 //  |<(/_\/  (_(_||(_  .
1493 //=======/======================================================================
1494 library KeysCalc {
1495     using SafeMath for *;
1496     /**
1497      * @dev calculates number of keys received given X eth
1498      * @param _curEth current amount of eth in contract
1499      * @param _newEth eth being spent
1500      * @return amount of ticket purchased
1501      */
1502     function keysRec(uint256 _curEth, uint256 _newEth)
1503         internal
1504         pure
1505         returns (uint256)
1506     {
1507         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1508     }
1509 
1510     /**
1511      * @dev calculates amount of eth received if you sold X keys
1512      * @param _curKeys current amount of keys that exist
1513      * @param _sellKeys amount of keys you wish to sell
1514      * @return amount of eth received
1515      */
1516     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1517         internal
1518         pure
1519         returns (uint256)
1520     {
1521         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1522     }
1523 
1524     /**
1525      * @dev calculates how many keys would exist with given an amount of eth
1526      * @param _eth eth "in contract"
1527      * @return number of keys that would exist
1528      */
1529     function keys(uint256 _eth)
1530         internal
1531         pure
1532         returns(uint256)
1533     {
1534         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1535     }
1536 
1537     /**
1538      * @dev calculates how much eth would be in contract given a number of keys
1539      * @param _keys number of keys "in contract"
1540      * @return eth that would exists
1541      */
1542     function eth(uint256 _keys)
1543         internal
1544         pure
1545         returns(uint256)
1546     {
1547         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1548     }
1549 }
1550 
1551 //==============================================================================
1552 //  . _ _|_ _  _ |` _  _ _  _  .
1553 //  || | | (/_| ~|~(_|(_(/__\  .
1554 //==============================================================================
1555 
1556 interface PlayerBookInterface {
1557     function getPlayerID(address _addr) external returns (uint256);
1558     function getPlayerName(uint256 _pID) external view returns (bytes32);
1559     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1560     function getPlayerAddr(uint256 _pID) external view returns (address);
1561     function getNameFee() external view returns (uint256);
1562     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1563     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1564     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1565 }
1566 
1567 
1568 library NameFilter {
1569     /**
1570      * @dev filters name strings
1571      * -converts uppercase to lower case.
1572      * -makes sure it does not start/end with a space
1573      * -makes sure it does not contain multiple spaces in a row
1574      * -cannot be only numbers
1575      * -cannot start with 0x
1576      * -restricts characters to A-Z, a-z, 0-9, and space.
1577      * @return reprocessed string in bytes32 format
1578      */
1579     function nameFilter(string _input)
1580         internal
1581         pure
1582         returns(bytes32)
1583     {
1584         bytes memory _temp = bytes(_input);
1585         uint256 _length = _temp.length;
1586 
1587         //sorry limited to 32 characters
1588         require (_length <= 32 && _length > 0);
1589         // make sure it doesnt start with or end with space
1590         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
1591         // make sure first two characters are not 0x
1592         if (_temp[0] == 0x30)
1593         {
1594             require(_temp[1] != 0x78);
1595             require(_temp[1] != 0x58);
1596         }
1597 
1598         // create a bool to track if we have a non number character
1599         bool _hasNonNumber;
1600 
1601         // convert & check
1602         for (uint256 i = 0; i < _length; i++)
1603         {
1604             // if its uppercase A-Z
1605             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1606             {
1607                 // convert to lower case a-z
1608                 _temp[i] = byte(uint(_temp[i]) + 32);
1609 
1610                 // we have a non number
1611                 if (_hasNonNumber == false)
1612                     _hasNonNumber = true;
1613             } else {
1614                 require
1615                 (
1616                     // require character is a space
1617                     _temp[i] == 0x20 ||
1618                     // OR lowercase a-z
1619                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1620                     // or 0-9
1621                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
1622                 // make sure theres not 2x spaces in a row
1623                 if (_temp[i] == 0x20)
1624                     require( _temp[i+1] != 0x20);
1625 
1626                 // see if we have a character other than a number
1627                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1628                     _hasNonNumber = true;
1629             }
1630         }
1631 
1632         require(_hasNonNumber == true);
1633 
1634         bytes32 _ret;
1635         assembly {
1636             _ret := mload(add(_temp, 32))
1637         }
1638         return (_ret);
1639     }
1640 }
1641 
1642 /**
1643  * @title SafeMath v0.1.9
1644  * @dev Math operations with safety checks that throw on error
1645  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1646  * - added sqrt
1647  * - added sq
1648  * - added pwr
1649  * - changed asserts to requires with error log outputs
1650  * - removed div, its useless
1651  */
1652 library SafeMath {
1653 
1654     /**
1655     * @dev Multiplies two numbers, throws on overflow.
1656     */
1657     function mul(uint256 a, uint256 b)
1658         internal
1659         pure
1660         returns (uint256 c)
1661     {
1662         if (a == 0) {
1663             return 0;
1664         }
1665         c = a * b;
1666         require(c / a == b, "SafeMath mul failed");
1667         return c;
1668     }
1669 
1670     /**
1671     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1672     */
1673     function sub(uint256 a, uint256 b)
1674         internal
1675         pure
1676         returns (uint256)
1677     {
1678         require(b <= a, "SafeMath sub failed");
1679         return a - b;
1680     }
1681 
1682     /**
1683     * @dev Adds two numbers, throws on overflow.
1684     */
1685     function add(uint256 a, uint256 b)
1686         internal
1687         pure
1688         returns (uint256 c)
1689     {
1690         c = a + b;
1691         require(c >= a, "SafeMath add failed");
1692         return c;
1693     }
1694 
1695     /**
1696      * @dev gives square root of given x.
1697      */
1698     function sqrt(uint256 x)
1699         internal
1700         pure
1701         returns (uint256 y)
1702     {
1703         uint256 z = ((add(x,1)) / 2);
1704         y = x;
1705         while (z < y)
1706         {
1707             y = z;
1708             z = ((add((x / z),z)) / 2);
1709         }
1710     }
1711 
1712     /**
1713      * @dev gives square. multiplies x by x
1714      */
1715     function sq(uint256 x)
1716         internal
1717         pure
1718         returns (uint256)
1719     {
1720         return (mul(x,x));
1721     }
1722 
1723     /**
1724      * @dev x to the power of y
1725      */
1726     function pwr(uint256 x, uint256 y)
1727         internal
1728         pure
1729         returns (uint256)
1730     {
1731         if (x==0)
1732             return (0);
1733         else if (y==0)
1734             return (1);
1735         else
1736         {
1737             uint256 z = x;
1738             for (uint256 i=1; i < y; i++)
1739                 z = mul(z,x);
1740             return (z);
1741         }
1742     }
1743 }