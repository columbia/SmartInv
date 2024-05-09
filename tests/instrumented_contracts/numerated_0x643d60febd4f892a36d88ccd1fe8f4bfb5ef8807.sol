1 pragma solidity ^0.4.24;
2 
3 contract POOHMOXevents {
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
31         uint256 POOHAmount,
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
58         uint256 POOHAmount,
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
75         uint256 POOHAmount,
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
91         uint256 POOHAmount,
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
120 contract POOHMOX is POOHMOXevents {
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
132     address private flushDivs;
133     string constant public name = "POOHMOX";
134     string constant public symbol = "POOHMOX";
135     uint256 private rndExtra_ = 1 seconds;     // length of the very first ICO phase
136     uint256 private rndGap_ = 1 seconds;       // length of ICO phases
137     uint256 private rndInit_ = 5 minutes;      // round timer starts at this
138     uint256 private rndMax_ = 5 minutes;       // max length a round timer can be  (for first round) 
139     uint256 constant private rndInc_ = 5 minutes;// every full key purchased adds this much to the timer
140                                  
141 //==============================================================================
142 //     _| _ _|_ _    _ _ _|_    _   .
143 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
144 //=============================|================================================
145     uint256 public rID_;    // round id number / total rounds that have happened
146 //****************
147 // PLAYER DATA
148 //****************
149     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
150     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
151     mapping (uint256 => POOHMOXDatasets.Player) public plyr_;   // (pID => data) player data
152     mapping (uint256 => mapping (uint256 => POOHMOXDatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
153     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
154 //****************
155 // ROUND DATA
156 //****************
157     mapping (uint256 => POOHMOXDatasets.Round) public round_;   // (rID => data) round data
158     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
159 //****************
160 // TEAM FEE DATA
161 //****************
162     mapping (uint256 => POOHMOXDatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
163     mapping (uint256 => POOHMOXDatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
164 //==============================================================================
165 //     _ _  _  __|_ _    __|_ _  _  .
166 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
167 //==============================================================================
168     constructor(address whaleContract, address playerbook)
169         public
170     {
171         flushDivs = whaleContract;
172         PlayerBook = PlayerBookInterface(playerbook);
173 
174         //no teams... only POOH-heads
175         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
176         fees_[0] = POOHMOXDatasets.TeamFee(39,20);   //30% to pot, 10% to aff, 1% to dev,
177        
178 
179         potSplit_[0] = POOHMOXDatasets.PotSplit(15,10);  //36% to winner, 36% to next round, 3% to dev
180     }
181 //==============================================================================
182 //     _ _  _  _|. |`. _  _ _  .
183 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
184 //==============================================================================
185     /**
186      * @dev used to make sure no one can interact with contract until it has
187      * been activated.
188      */
189     modifier isActivated() {
190         require(activated_ == true);
191         _;
192     }
193 
194     /**
195      * @dev prevents contracts from interacting with fomo3d
196      */
197     modifier isHuman() {
198         address _addr = msg.sender;
199         uint256 _codeLength;
200 
201         assembly {_codeLength := extcodesize(_addr)}
202         require(_codeLength == 0);
203         require(_addr == tx.origin);
204         _;
205     }
206 
207     /**
208      * @dev sets boundaries for incoming tx
209      */
210     modifier isWithinLimits(uint256 _eth) {
211         require(_eth >= 1000000000);
212         require(_eth <= 100000000000000000000000);
213         _;
214     }
215 
216 //==============================================================================
217 //     _    |_ |. _   |`    _  __|_. _  _  _  .
218 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
219 //====|=========================================================================
220     /**
221      * @dev emergency buy uses last stored affiliate ID
222      */
223     function()
224         isActivated()
225         isHuman()
226         isWithinLimits(msg.value)
227         public
228         payable
229     {
230         // set up our tx event data and determine if player is new or not
231         POOHMOXDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
232 
233         // fetch player id
234         uint256 _pID = pIDxAddr_[msg.sender];
235 
236         // buy core
237         buyCore(_pID, plyr_[_pID].laff, _eventData_);
238     }
239 
240     /**
241      * @dev converts all incoming ethereum to keys.
242      * -functionhash- 0x8f38f309 (using ID for affiliate)
243      * -functionhash- 0x98a0871d (using address for affiliate)
244      * -functionhash- 0xa65b37a1 (using name for affiliate)
245      * @param _affCode the ID/address/name of the player who gets the affiliate fee
246      */
247     function buyXid(uint256 _affCode)
248         isActivated()
249         isHuman()
250         isWithinLimits(msg.value)
251         public
252         payable
253     {
254         // set up our tx event data and determine if player is new or not
255         POOHMOXDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
256 
257         // fetch player id
258         uint256 _pID = pIDxAddr_[msg.sender];
259 
260         // manage affiliate residuals
261         // if no affiliate code was given or player tried to use their own, lolz
262         if (_affCode == 0 || _affCode == _pID)
263         {
264             // use last stored affiliate code
265             _affCode = plyr_[_pID].laff;
266 
267         // if affiliate code was given & its not the same as previously stored
268         } else if (_affCode != plyr_[_pID].laff) {
269             // update last affiliate
270             plyr_[_pID].laff = _affCode;
271         }
272 
273         // buy core
274         buyCore(_pID, _affCode, _eventData_);
275     }
276 
277     function buyXaddr(address _affCode)
278         isActivated()
279         isHuman()
280         isWithinLimits(msg.value)
281         public
282         payable
283     {
284         // set up our tx event data and determine if player is new or not
285         POOHMOXDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
286 
287         // fetch player id
288         uint256 _pID = pIDxAddr_[msg.sender];
289 
290         // manage affiliate residuals
291         uint256 _affID;
292         // if no affiliate code was given or player tried to use their own, lolz
293         if (_affCode == address(0) || _affCode == msg.sender)
294         {
295             // use last stored affiliate code
296             _affID = plyr_[_pID].laff;
297 
298         // if affiliate code was given
299         } else {
300             // get affiliate ID from aff Code
301             _affID = pIDxAddr_[_affCode];
302 
303             // if affID is not the same as previously stored
304             if (_affID != plyr_[_pID].laff)
305             {
306                 // update last affiliate
307                 plyr_[_pID].laff = _affID;
308             }
309         }
310         // buy core
311         buyCore(_pID, _affID, _eventData_);
312     }
313 
314     function buyXname(bytes32 _affCode)
315         isActivated()
316         isHuman()
317         isWithinLimits(msg.value)
318         public
319         payable
320     {
321         // set up our tx event data and determine if player is new or not
322         POOHMOXDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
323 
324         // fetch player id
325         uint256 _pID = pIDxAddr_[msg.sender];
326 
327         // manage affiliate residuals
328         uint256 _affID;
329         // if no affiliate code was given or player tried to use their own, lolz
330         if (_affCode == '' || _affCode == plyr_[_pID].name)
331         {
332             // use last stored affiliate code
333             _affID = plyr_[_pID].laff;
334 
335         // if affiliate code was given
336         } else {
337             // get affiliate ID from aff Code
338             _affID = pIDxName_[_affCode];
339 
340             // if affID is not the same as previously stored
341             if (_affID != plyr_[_pID].laff)
342             {
343                 // update last affiliate
344                 plyr_[_pID].laff = _affID;
345             }
346         }
347 
348         // buy core
349         buyCore(_pID, _affID, _eventData_);
350     }
351 
352     /**
353      * @dev essentially the same as buy, but instead of you sending ether
354      * from your wallet, it uses your unwithdrawn earnings.
355      * -functionhash- 0x349cdcac (using ID for affiliate)
356      * -functionhash- 0x82bfc739 (using address for affiliate)
357      * -functionhash- 0x079ce327 (using name for affiliate)
358      * @param _affCode the ID/address/name of the player who gets the affiliate fee
359      * @param _eth amount of earnings to use (remainder returned to gen vault)
360      */
361     function reLoadXid(uint256 _affCode, uint256 _eth)
362         isActivated()
363         isHuman()
364         isWithinLimits(_eth)
365         public
366     {
367         // set up our tx event data
368         POOHMOXDatasets.EventReturns memory _eventData_;
369 
370         // fetch player ID
371         uint256 _pID = pIDxAddr_[msg.sender];
372 
373         // manage affiliate residuals
374         // if no affiliate code was given or player tried to use their own, lolz
375         if (_affCode == 0 || _affCode == _pID)
376         {
377             // use last stored affiliate code
378             _affCode = plyr_[_pID].laff;
379 
380         // if affiliate code was given & its not the same as previously stored
381         } else if (_affCode != plyr_[_pID].laff) {
382             // update last affiliate
383             plyr_[_pID].laff = _affCode;
384         }
385 
386         // reload core
387         reLoadCore(_pID, _affCode, _eth, _eventData_);
388     }
389 
390     function reLoadXaddr(address _affCode, uint256 _eth)
391         isActivated()
392         isHuman()
393         isWithinLimits(_eth)
394         public
395     {
396         // set up our tx event data
397         POOHMOXDatasets.EventReturns memory _eventData_;
398 
399         // fetch player ID
400         uint256 _pID = pIDxAddr_[msg.sender];
401 
402         // manage affiliate residuals
403         uint256 _affID;
404         // if no affiliate code was given or player tried to use their own, lolz
405         if (_affCode == address(0) || _affCode == msg.sender)
406         {
407             // use last stored affiliate code
408             _affID = plyr_[_pID].laff;
409 
410         // if affiliate code was given
411         } else {
412             // get affiliate ID from aff Code
413             _affID = pIDxAddr_[_affCode];
414 
415             // if affID is not the same as previously stored
416             if (_affID != plyr_[_pID].laff)
417             {
418                 // update last affiliate
419                 plyr_[_pID].laff = _affID;
420             }
421         }
422 
423         // reload core
424         reLoadCore(_pID, _affID, _eth, _eventData_);
425     }
426 
427     function reLoadXname(bytes32 _affCode, uint256 _eth)
428         isActivated()
429         isHuman()
430         isWithinLimits(_eth)
431         public
432     {
433         // set up our tx event data
434         POOHMOXDatasets.EventReturns memory _eventData_;
435 
436         // fetch player ID
437         uint256 _pID = pIDxAddr_[msg.sender];
438 
439         // manage affiliate residuals
440         uint256 _affID;
441         // if no affiliate code was given or player tried to use their own, lolz
442         if (_affCode == '' || _affCode == plyr_[_pID].name)
443         {
444             // use last stored affiliate code
445             _affID = plyr_[_pID].laff;
446 
447         // if affiliate code was given
448         } else {
449             // get affiliate ID from aff Code
450             _affID = pIDxName_[_affCode];
451 
452             // if affID is not the same as previously stored
453             if (_affID != plyr_[_pID].laff)
454             {
455                 // update last affiliate
456                 plyr_[_pID].laff = _affID;
457             }
458         }
459 
460         // reload core
461         reLoadCore(_pID, _affID, _eth, _eventData_);
462     }
463 
464     /**
465      * @dev withdraws all of your earnings.
466      * -functionhash- 0x3ccfd60b
467      */
468     function withdraw()
469         isActivated()
470         isHuman()
471         public
472     {
473         // setup local rID
474         uint256 _rID = rID_;
475 
476         // grab time
477         uint256 _now = now;
478 
479         // fetch player ID
480         uint256 _pID = pIDxAddr_[msg.sender];
481 
482         // setup temp var for player eth
483         uint256 _eth;
484 
485         // check to see if round has ended and no one has run round end yet
486         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
487         {
488             // set up our tx event data
489             POOHMOXDatasets.EventReturns memory _eventData_;
490 
491             // end the round (distributes pot)
492             round_[_rID].ended = true;
493             _eventData_ = endRound(_eventData_);
494 
495             // get their earnings
496             _eth = withdrawEarnings(_pID);
497 
498             // gib moni
499             if (_eth > 0)
500                 plyr_[_pID].addr.transfer(_eth);
501 
502             // build event data
503             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
504             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
505 
506             // fire withdraw and distribute event
507             emit POOHMOXevents.onWithdrawAndDistribute
508             (
509                 msg.sender,
510                 plyr_[_pID].name,
511                 _eth,
512                 _eventData_.compressedData,
513                 _eventData_.compressedIDs,
514                 _eventData_.winnerAddr,
515                 _eventData_.winnerName,
516                 _eventData_.amountWon,
517                 _eventData_.newPot,
518                 _eventData_.POOHAmount,
519                 _eventData_.genAmount
520             );
521 
522         // in any other situation
523         } else {
524             // get their earnings
525             _eth = withdrawEarnings(_pID);
526 
527             // gib moni
528             if (_eth > 0)
529                 plyr_[_pID].addr.transfer(_eth);
530 
531             // fire withdraw event
532             emit POOHMOXevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
533         }
534     }
535 
536     /**
537      * @dev use these to register names.  they are just wrappers that will send the
538      * registration requests to the PlayerBook contract.  So registering here is the
539      * same as registering there.  UI will always display the last name you registered.
540      * but you will still own all previously registered names to use as affiliate
541      * links.
542      * - must pay a registration fee.
543      * - name must be unique
544      * - names will be converted to lowercase
545      * - name cannot start or end with a space
546      * - cannot have more than 1 space in a row
547      * - cannot be only numbers
548      * - cannot start with 0x
549      * - name must be at least 1 char
550      * - max length of 32 characters long
551      * - allowed characters: a-z, 0-9, and space
552      * -functionhash- 0x921dec21 (using ID for affiliate)
553      * -functionhash- 0x3ddd4698 (using address for affiliate)
554      * -functionhash- 0x685ffd83 (using name for affiliate)
555      * @param _nameString players desired name
556      * @param _affCode affiliate ID, address, or name of who referred you
557      * @param _all set to true if you want this to push your info to all games
558      * (this might cost a lot of gas)
559      */
560     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
561         isHuman()
562         public
563         payable
564     {
565         bytes32 _name = _nameString.nameFilter();
566         address _addr = msg.sender;
567         uint256 _paid = msg.value;
568         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
569 
570         uint256 _pID = pIDxAddr_[_addr];
571 
572         // fire event
573         emit POOHMOXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
574     }
575 
576     function registerNameXaddr(string _nameString, address _affCode, bool _all)
577         isHuman()
578         public
579         payable
580     {
581         bytes32 _name = _nameString.nameFilter();
582         address _addr = msg.sender;
583         uint256 _paid = msg.value;
584         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
585 
586         uint256 _pID = pIDxAddr_[_addr];
587 
588         // fire event
589         emit POOHMOXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
590     }
591 
592     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
593         isHuman()
594         public
595         payable
596     {
597         bytes32 _name = _nameString.nameFilter();
598         address _addr = msg.sender;
599         uint256 _paid = msg.value;
600         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
601 
602         uint256 _pID = pIDxAddr_[_addr];
603 
604         // fire event
605         emit POOHMOXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
606     }
607 //==============================================================================
608 //     _  _ _|__|_ _  _ _  .
609 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
610 //=====_|=======================================================================
611     /**
612      * @dev return the price buyer will pay for next 1 individual key.
613      * -functionhash- 0x018a25e8
614      * @return price for next key bought (in wei format)
615      */
616     function getBuyPrice()
617         public
618         view
619         returns(uint256)
620     {
621        return 0.01 ether;
622     }
623 
624     /**
625      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
626      * provider
627      * -functionhash- 0xc7e284b8
628      * @return time left in seconds
629      */
630     function getTimeLeft()
631         public
632         view
633         returns(uint256)
634     {
635         // setup local rID
636         uint256 _rID = rID_;
637 
638         // grab time
639         uint256 _now = now;
640 
641         if (_now < round_[_rID].end)
642             if (_now > round_[_rID].strt + rndGap_)
643                 return( (round_[_rID].end).sub(_now) );
644             else
645                 return( (round_[_rID].strt + rndGap_).sub(_now) );
646         else
647             return(0);
648     }
649 
650     /**
651      * @dev returns player earnings per vaults
652      * -functionhash- 0x63066434
653      * @return winnings vault
654      * @return general vault
655      * @return affiliate vault
656      */
657     function getPlayerVaults(uint256 _pID)
658         public
659         view
660         returns(uint256 ,uint256, uint256)
661     {
662         // setup local rID
663         uint256 _rID = rID_;
664 
665         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
666         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
667         {
668             // if player is winner
669             if (round_[_rID].plyr == _pID)
670             {
671                 return
672                 (
673                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
674                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
675                     plyr_[_pID].aff
676                 );
677             // if player is not the winner
678             } else {
679                 return
680                 (
681                     plyr_[_pID].win,
682                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
683                     plyr_[_pID].aff
684                 );
685             }
686 
687         // if round is still going on, or round has ended and round end has been ran
688         } else {
689             return
690             (
691                 plyr_[_pID].win,
692                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
693                 plyr_[_pID].aff
694             );
695         }
696     }
697 
698     /**
699      * solidity hates stack limits.  this lets us avoid that hate
700      */
701     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
702         private
703         view
704         returns(uint256)
705     {
706         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
707     }
708 
709     /**
710      * @dev returns all current round info needed for front end
711      * -functionhash- 0x747dff42
712      * @return eth invested during ICO phase
713      * @return round id
714      * @return total keys for round
715      * @return time round ends
716      * @return time round started
717      * @return current pot
718      * @return current team ID & player ID in lead
719      * @return current player in leads address
720      * @return current player in leads name
721      * @return whales eth in for round
722      * @return bears eth in for round
723      * @return sneks eth in for round
724      * @return bulls eth in for round
725      */
726     function getCurrentRoundInfo()
727         public
728         view
729         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
730     {
731         // setup local rID
732         uint256 _rID = rID_;
733 
734         return
735         (
736             round_[_rID].ico,               //0
737             _rID,                           //1
738             round_[_rID].keys,              //2
739             round_[_rID].end,               //3
740             round_[_rID].strt,              //4
741             round_[_rID].pot,               //5
742             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
743             plyr_[round_[_rID].plyr].addr,  //7
744             plyr_[round_[_rID].plyr].name,  //8
745             rndTmEth_[_rID][0],             //9
746             rndTmEth_[_rID][1],             //10
747             rndTmEth_[_rID][2],             //11
748             rndTmEth_[_rID][3]              //12
749           
750         );
751     }
752 
753     /**
754      * @dev returns player info based on address.  if no address is given, it will
755      * use msg.sender
756      * -functionhash- 0xee0b5d8b
757      * @param _addr address of the player you want to lookup
758      * @return player ID
759      * @return player name
760      * @return keys owned (current round)
761      * @return winnings vault
762      * @return general vault
763      * @return affiliate vault
764      * @return player round eth
765      */
766     function getPlayerInfoByAddress(address _addr)
767         public
768         view
769         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
770     {
771         // setup local rID
772         uint256 _rID = rID_;
773 
774         if (_addr == address(0))
775         {
776             _addr == msg.sender;
777         }
778         uint256 _pID = pIDxAddr_[_addr];
779 
780         return
781         (
782             _pID,                               //0
783             plyr_[_pID].name,                   //1
784             plyrRnds_[_pID][_rID].keys,         //2
785             plyr_[_pID].win,                    //3
786             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
787             plyr_[_pID].aff,                    //5
788             plyrRnds_[_pID][_rID].eth           //6
789         );
790     }
791 
792 //==============================================================================
793 //     _ _  _ _   | _  _ . _  .
794 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
795 //=====================_|=======================================================
796     /**
797      * @dev logic runs whenever a buy order is executed.  determines how to handle
798      * incoming eth depending on if we are in an active round or not
799      */
800     function buyCore(uint256 _pID, uint256 _affID, POOHMOXDatasets.EventReturns memory _eventData_)
801         private
802     {
803         // setup local rID
804         uint256 _rID = rID_;
805 
806         // grab time
807         uint256 _now = now;
808 
809         // if round is active
810         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
811         {
812             // call core
813             core(_rID, _pID, msg.value, _affID, 0, _eventData_);
814 
815         // if round is not active
816         } else {
817             // check to see if end round needs to be ran
818             if (_now > round_[_rID].end && round_[_rID].ended == false)
819             {
820                 // end the round (distributes pot) & start new round
821                 round_[_rID].ended = true;
822                 _eventData_ = endRound(_eventData_);
823 
824                 // build event data
825                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
826                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
827 
828                 // fire buy and distribute event
829                 emit POOHMOXevents.onBuyAndDistribute
830                 (
831                     msg.sender,
832                     plyr_[_pID].name,
833                     msg.value,
834                     _eventData_.compressedData,
835                     _eventData_.compressedIDs,
836                     _eventData_.winnerAddr,
837                     _eventData_.winnerName,
838                     _eventData_.amountWon,
839                     _eventData_.newPot,
840                     _eventData_.POOHAmount,
841                     _eventData_.genAmount
842                 );
843             }
844 
845             // put eth in players vault
846             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
847         }
848     }
849 
850     /**
851      * @dev logic runs whenever a reload order is executed.  determines how to handle
852      * incoming eth depending on if we are in an active round or not
853      */
854     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, POOHMOXDatasets.EventReturns memory _eventData_)
855         private
856     {
857         // setup local rID
858         uint256 _rID = rID_;
859 
860         // grab time
861         uint256 _now = now;
862 
863         // if round is active
864         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
865         {
866             // get earnings from all vaults and return unused to gen vault
867             // because we use a custom safemath library.  this will throw if player
868             // tried to spend more eth than they have.
869             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
870 
871             // call core
872             core(_rID, _pID, _eth, _affID, 0, _eventData_);
873 
874         // if round is not active and end round needs to be ran
875         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
876             // end the round (distributes pot) & start new round
877             round_[_rID].ended = true;
878             _eventData_ = endRound(_eventData_);
879 
880             // build event data
881             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
882             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
883 
884             // fire buy and distribute event
885             emit POOHMOXevents.onReLoadAndDistribute
886             (
887                 msg.sender,
888                 plyr_[_pID].name,
889                 _eventData_.compressedData,
890                 _eventData_.compressedIDs,
891                 _eventData_.winnerAddr,
892                 _eventData_.winnerName,
893                 _eventData_.amountWon,
894                 _eventData_.newPot,
895                 _eventData_.POOHAmount,
896                 _eventData_.genAmount
897             );
898         }
899     }
900 
901     /**
902      * @dev this is the core logic for any buy/reload that happens while a round
903      * is live.
904      */
905     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMOXDatasets.EventReturns memory _eventData_)
906         private
907     {
908         require(_eth >= 0.01 ether);
909 
910         // if player is new to round
911         if (plyrRnds_[_pID][_rID].keys == 0)
912             _eventData_ = managePlayer(_pID, _eventData_);
913 
914         // // early round eth limiter
915         // if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000)
916         // {
917         //     uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
918         //     uint256 _refund = _eth.sub(_availableLimit);
919         //     plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
920         //     _eth = _availableLimit;
921         // }
922 
923         // if eth left is greater than min eth allowed (sorry no pocket lint)
924        
925 
926             // mint the new keys
927             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
928 
929             // if they bought at least 1 whole key
930             if (_keys >= 1000000000000000000)
931             {
932                 updateTimer(_keys, _rID);
933 
934                 // set new leaders
935                 if (round_[_rID].plyr != _pID)
936                     round_[_rID].plyr = _pID;
937                 if (round_[_rID].team != _team)
938                     round_[_rID].team = _team;
939 
940                 // set the new leader bool to true
941                 _eventData_.compressedData = _eventData_.compressedData + 100;
942             }
943 
944             // update player
945             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
946             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
947 
948             // update round
949             round_[_rID].keys = _keys.add(round_[_rID].keys);
950             round_[_rID].eth = _eth.add(round_[_rID].eth);
951             rndTmEth_[_rID][0] = _eth.add(rndTmEth_[_rID][0]);
952 
953             // distribute eth
954             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 0, _eventData_);
955             _eventData_ = distributeInternal(_rID, _pID, _eth, 0, _keys, _eventData_);
956 
957             // call end tx function to fire end tx event.
958             endTx(_pID, 0, _eth, _keys, _eventData_);
959     }
960 //==============================================================================
961 //     _ _ | _   | _ _|_ _  _ _  .
962 //    (_(_||(_|_||(_| | (_)| _\  .
963 //==============================================================================
964     /**
965      * @dev calculates unmasked earnings (just calculates, does not update mask)
966      * @return earnings in wei format
967      */
968     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
969         private
970         view
971         returns(uint256)
972     {
973         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
974     }
975 
976     /**
977      * @dev returns the amount of keys you would get given an amount of eth.
978      * -functionhash- 0xce89c80c
979      * @param _rID round ID you want price for
980      * @param _eth amount of eth sent in
981      * @return keys received
982      */
983     function calcKeysReceived(uint256 _rID, uint256 _eth)
984         public
985         view
986         returns(uint256)
987     {
988         // grab time
989         uint256 _now = now;
990 
991         // are we in a round?
992         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
993             return ( (round_[_rID].eth).keysRec(_eth) );
994         else // rounds over.  need keys for new round
995             return ( (_eth).keys() );
996     }
997 
998     /**
999      * @dev returns current eth price for X keys.
1000      * -functionhash- 0xcf808000
1001      * @param _keys number of keys desired (in 18 decimal format)
1002      * @return amount of eth needed to send
1003      */
1004     function iWantXKeys(uint256 _keys)
1005         public
1006         view
1007         returns(uint256)
1008     {
1009         // setup local rID
1010         uint256 _rID = rID_;
1011 
1012         // grab time
1013         uint256 _now = now;
1014 
1015         // are we in a round?
1016         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1017             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1018         else // rounds over.  need price for new round
1019             return ( (_keys).eth() );
1020     }
1021 //==============================================================================
1022 //    _|_ _  _ | _  .
1023 //     | (_)(_)|_\  .
1024 //==============================================================================
1025     /**
1026      * @dev receives name/player info from names contract
1027      */
1028     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1029         external
1030     {
1031         require (msg.sender == address(PlayerBook));
1032         if (pIDxAddr_[_addr] != _pID)
1033             pIDxAddr_[_addr] = _pID;
1034         if (pIDxName_[_name] != _pID)
1035             pIDxName_[_name] = _pID;
1036         if (plyr_[_pID].addr != _addr)
1037             plyr_[_pID].addr = _addr;
1038         if (plyr_[_pID].name != _name)
1039             plyr_[_pID].name = _name;
1040         if (plyr_[_pID].laff != _laff)
1041             plyr_[_pID].laff = _laff;
1042         if (plyrNames_[_pID][_name] == false)
1043             plyrNames_[_pID][_name] = true;
1044     }
1045 
1046     /**
1047      * @dev receives entire player name list
1048      */
1049     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1050         external
1051     {
1052         require (msg.sender == address(PlayerBook));
1053         if(plyrNames_[_pID][_name] == false)
1054             plyrNames_[_pID][_name] = true;
1055     }
1056 
1057     /**
1058      * @dev gets existing or registers new pID.  use this when a player may be new
1059      * @return pID
1060      */
1061     function determinePID(POOHMOXDatasets.EventReturns memory _eventData_)
1062         private
1063         returns (POOHMOXDatasets.EventReturns)
1064     {
1065         uint256 _pID = pIDxAddr_[msg.sender];
1066         // if player is new to this version of fomo3d
1067         if (_pID == 0)
1068         {
1069             // grab their player ID, name and last aff ID, from player names contract
1070             _pID = PlayerBook.getPlayerID(msg.sender);
1071             bytes32 _name = PlayerBook.getPlayerName(_pID);
1072             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1073 
1074             // set up player account
1075             pIDxAddr_[msg.sender] = _pID;
1076             plyr_[_pID].addr = msg.sender;
1077 
1078             if (_name != "")
1079             {
1080                 pIDxName_[_name] = _pID;
1081                 plyr_[_pID].name = _name;
1082                 plyrNames_[_pID][_name] = true;
1083             }
1084 
1085             if (_laff != 0 && _laff != _pID)
1086                 plyr_[_pID].laff = _laff;
1087 
1088             // set the new player bool to true
1089             _eventData_.compressedData = _eventData_.compressedData + 1;
1090         }
1091         return (_eventData_);
1092     }
1093 
1094     
1095 
1096     /**
1097      * @dev decides if round end needs to be run & new round started.  and if
1098      * player unmasked earnings from previously played rounds need to be moved.
1099      */
1100     function managePlayer(uint256 _pID, POOHMOXDatasets.EventReturns memory _eventData_)
1101         private
1102         returns (POOHMOXDatasets.EventReturns)
1103     {
1104         // if player has played a previous round, move their unmasked earnings
1105         // from that round to gen vault.
1106         if (plyr_[_pID].lrnd != 0)
1107             updateGenVault(_pID, plyr_[_pID].lrnd);
1108 
1109         // update player's last round played
1110         plyr_[_pID].lrnd = rID_;
1111 
1112         // set the joined round bool to true
1113         _eventData_.compressedData = _eventData_.compressedData + 10;
1114 
1115         return(_eventData_);
1116     }
1117 
1118     /**
1119      * @dev ends the round. manages paying out winner/splitting up pot
1120      */
1121     function endRound(POOHMOXDatasets.EventReturns memory _eventData_)
1122         private
1123         returns (POOHMOXDatasets.EventReturns)
1124     {
1125         // setup local rID
1126         uint256 _rID = rID_;
1127 
1128         // grab our winning player and team id's
1129         uint256 _winPID = round_[_rID].plyr;
1130         uint256 _winTID = round_[_rID].team;
1131 
1132         // grab our pot amount
1133         uint256 _pot = round_[_rID].pot;
1134 
1135         // calculate our winner share, community rewards, gen share,
1136         // p3d share, and amount reserved for next pot
1137         uint256 _win = (_pot.mul(48)) / 100;   //48%
1138         uint256 _dev = (_pot / 50);            //2%
1139         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; //15
1140         uint256 _POOH = (_pot.mul(potSplit_[_winTID].pooh)) / 100; // 10
1141         uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_POOH); //25
1142 
1143         // calculate ppt for round mask
1144         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1145         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1146         if (_dust > 0)
1147         {
1148             _gen = _gen.sub(_dust);
1149             _res = _res.add(_dust);
1150         }
1151 
1152         // pay our winner
1153         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1154 
1155         // community rewards
1156 
1157         admin.transfer(_dev);
1158 
1159         flushDivs.call.value(_POOH)(bytes4(keccak256("donate()")));  
1160 
1161         // distribute gen portion to key holders
1162         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1163 
1164         // prepare event data
1165         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1166         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1167         _eventData_.winnerAddr = plyr_[_winPID].addr;
1168         _eventData_.winnerName = plyr_[_winPID].name;
1169         _eventData_.amountWon = _win;
1170         _eventData_.genAmount = _gen;
1171         _eventData_.POOHAmount = _POOH;
1172         _eventData_.newPot = _res;
1173 
1174         // start next round
1175         rID_++;
1176         _rID++;
1177         round_[_rID].strt = now;
1178         round_[_rID].end = now.add(rndMax_);
1179         round_[_rID].pot = _res;
1180 
1181         return(_eventData_);
1182     }
1183     
1184 
1185     /**
1186      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1187      */
1188     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1189         private
1190     {
1191         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1192         if (_earnings > 0)
1193         {
1194             // put in gen vault
1195             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1196             // zero out their earnings by updating mask
1197             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1198         }
1199     }
1200 
1201     /**
1202      * @dev updates round timer based on number of whole keys bought.
1203      */
1204     function updateTimer(uint256 _keys, uint256 _rID)
1205         private
1206     {
1207         // grab time
1208         uint256 _now = now;
1209 
1210         // calculate time based on number of keys bought
1211         uint256 _newTime;
1212         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1213             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1214         else
1215             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1216 
1217         // compare to max and set new end time
1218         if (_newTime < (rndMax_).add(_now))
1219             round_[_rID].end = _newTime;
1220         else
1221             round_[_rID].end = rndMax_.add(_now);
1222     }
1223 
1224    
1225     /**
1226      * @dev distributes eth based on fees to com, aff, and pooh
1227      */
1228     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMOXDatasets.EventReturns memory _eventData_)
1229         private
1230         returns(POOHMOXDatasets.EventReturns)
1231     {
1232         // pay 1% out to dev
1233         uint256 _dev = _eth / 100;  // 1%
1234 
1235         uint256 _POOH = 0;
1236         if (!address(admin).call.value(_dev)())
1237         {
1238             _POOH = _dev;
1239             _dev = 0;
1240         }
1241 
1242 
1243         // distribute share to affiliate
1244         uint256 _aff = _eth / 10;
1245 
1246         // decide what to do with affiliate share of fees
1247         // affiliate must not be self, and must have a name registered
1248         if (_affID != _pID && plyr_[_affID].name != '') {
1249             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1250             emit POOHMOXevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1251         } else {
1252             _POOH = _POOH.add(_aff);
1253         }
1254 
1255         // pay out POOH
1256         _POOH = _POOH.add((_eth.mul(fees_[_team].pooh)) / (100));
1257         if (_POOH > 0)
1258         {
1259 
1260             flushDivs.call.value(_POOH)(bytes4(keccak256("donate()")));
1261 
1262             // set up event data
1263             _eventData_.POOHAmount = _POOH.add(_eventData_.POOHAmount);
1264         }
1265 
1266         return(_eventData_);
1267     }
1268 
1269     function potSwap()
1270         external
1271         payable
1272     {
1273        //you shouldn't be using this method
1274        admin.transfer(msg.value);
1275     }
1276 
1277     /**
1278      * @dev distributes eth based on fees to gen and pot
1279      */
1280     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, POOHMOXDatasets.EventReturns memory _eventData_)
1281         private
1282         returns(POOHMOXDatasets.EventReturns)
1283     {
1284         // calculate gen share
1285         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1286 
1287 
1288         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1289         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].pooh)) / 100));
1290 
1291         // calculate pot
1292         uint256 _pot = _eth.sub(_gen);
1293 
1294         // distribute gen share (thats what updateMasks() does) and adjust
1295         // balances for dust.
1296         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1297         if (_dust > 0)
1298             _gen = _gen.sub(_dust);
1299 
1300         // add eth to pot
1301         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1302 
1303         // set up event data
1304         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1305         _eventData_.potAmount = _pot;
1306 
1307         return(_eventData_);
1308     }
1309 
1310     /**
1311      * @dev updates masks for round and player when keys are bought
1312      * @return dust left over
1313      */
1314     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1315         private
1316         returns(uint256)
1317     {
1318         /* MASKING NOTES
1319             earnings masks are a tricky thing for people to wrap their minds around.
1320             the basic thing to understand here.  is were going to have a global
1321             tracker based on profit per share for each round, that increases in
1322             relevant proportion to the increase in share supply.
1323 
1324             the player will have an additional mask that basically says "based
1325             on the rounds mask, my shares, and how much i've already withdrawn,
1326             how much is still owed to me?"
1327         */
1328 
1329         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1330         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1331         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1332 
1333         // calculate player earning from their own buy (only based on the keys
1334         // they just bought).  & update player earnings mask
1335         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1336         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1337 
1338         // calculate & return dust
1339         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1340     }
1341 
1342     /**
1343      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1344      * @return earnings in wei format
1345      */
1346     function withdrawEarnings(uint256 _pID)
1347         private
1348         returns(uint256)
1349     {
1350         // update gen vault
1351         updateGenVault(_pID, plyr_[_pID].lrnd);
1352 
1353         // from vaults
1354         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1355         if (_earnings > 0)
1356         {
1357             plyr_[_pID].win = 0;
1358             plyr_[_pID].gen = 0;
1359             plyr_[_pID].aff = 0;
1360         }
1361 
1362         return(_earnings);
1363     }
1364 
1365     /**
1366      * @dev prepares compression data and fires event for buy or reload tx's
1367      */
1368     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, POOHMOXDatasets.EventReturns memory _eventData_)
1369         private
1370     {
1371         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1372         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1373 
1374         emit POOHMOXevents.onEndTx
1375         (
1376             _eventData_.compressedData,
1377             _eventData_.compressedIDs,
1378             plyr_[_pID].name,
1379             msg.sender,
1380             _eth,
1381             _keys,
1382             _eventData_.winnerAddr,
1383             _eventData_.winnerName,
1384             _eventData_.amountWon,
1385             _eventData_.newPot,
1386             _eventData_.POOHAmount,
1387             _eventData_.genAmount,
1388             _eventData_.potAmount
1389         );
1390     }
1391 //==============================================================================
1392 //    (~ _  _    _._|_    .
1393 //    _)(/_(_|_|| | | \/  .
1394 //====================/=========================================================
1395     /** upon contract deploy, it will be deactivated.  this is a one time
1396      * use function that will activate the contract.  we do this so devs
1397      * have time to set things up on the web end                            **/
1398     bool public activated_ = false;
1399     function activate()
1400         public
1401     {
1402         // only team just can activate
1403         require(msg.sender == admin);
1404 
1405 
1406         // can only be ran once
1407         require(activated_ == false);
1408 
1409         // activate the contract
1410         activated_ = true;
1411 
1412         // lets start first round
1413         rID_ = 1;
1414             round_[1].strt = now + rndExtra_ - rndGap_;
1415             round_[1].end = now + rndInit_ + rndExtra_;
1416     }
1417 
1418     /** Upon game death, there might be some ETH still locked in contract.  
1419      * This is a one time use function that will empty the contract and 
1420      * send the eth to POOH tokenholders.
1421     **/
1422     function whenGameDies()
1423         public
1424     {
1425         // only team just can activate
1426         require(msg.sender == admin);
1427 
1428         //take any black-holed eth left in contract and send to pooh whale
1429          flushDivs.call.value(address(this).balance)(bytes4(keccak256("donate()")));
1430      }
1431 
1432         
1433 
1434 }
1435 
1436 //==============================================================================
1437 //   __|_ _    __|_ _  .
1438 //  _\ | | |_|(_ | _\  .
1439 //==============================================================================
1440 library POOHMOXDatasets {
1441     
1442     struct EventReturns {
1443         uint256 compressedData;
1444         uint256 compressedIDs;
1445         address winnerAddr;         // winner address
1446         bytes32 winnerName;         // winner name
1447         uint256 amountWon;          // amount won
1448         uint256 newPot;             // amount in new pot
1449         uint256 POOHAmount;          // amount distributed to p3d
1450         uint256 genAmount;          // amount distributed to gen
1451         uint256 potAmount;          // amount added to pot
1452     }
1453     struct Player {
1454         address addr;   // player address
1455         bytes32 name;   // player name
1456         uint256 win;    // winnings vault
1457         uint256 gen;    // general vault
1458         uint256 aff;    // affiliate vault
1459         uint256 lrnd;   // last round played
1460         uint256 laff;   // last affiliate id used
1461     }
1462     struct PlayerRounds {
1463         uint256 eth;    // eth player has added to round (used for eth limiter)
1464         uint256 keys;   // keys
1465         uint256 mask;   // player mask
1466         uint256 ico;    // ICO phase investment
1467     }
1468     struct Round {
1469         uint256 plyr;   // pID of player in lead
1470         uint256 team;   // tID of team in lead
1471         uint256 end;    // time ends/ended
1472         bool ended;     // has round end function been ran
1473         uint256 strt;   // time round started
1474         uint256 keys;   // keys
1475         uint256 eth;    // total eth in
1476         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1477         uint256 mask;   // global mask
1478         uint256 ico;    // total eth sent in during ICO phase
1479         uint256 icoGen; // total eth for gen during ICO phase
1480         uint256 icoAvg; // average key price for ICO phase
1481     }
1482     struct TeamFee {
1483         uint256 gen;    // % of buy in thats paid to key holders of current round
1484         uint256 pooh;    // % of buy in thats paid to POOH holders
1485     }
1486     struct PotSplit {
1487         uint256 gen;    // % of pot thats paid to key holders of current round
1488         uint256 pooh;    // % of pot thats paid to POOH holders
1489     }
1490 }
1491 
1492 //==============================================================================
1493 //  |  _      _ _ | _  .
1494 //  |<(/_\/  (_(_||(_  .
1495 //=======/======================================================================
1496 library KeysCalc {
1497     using SafeMath for *;
1498     /**
1499      * @dev calculates number of keys received given X eth
1500      * @param _curEth current amount of eth in contract
1501      * @param _newEth eth being spent
1502      * @return amount of ticket purchased
1503      */
1504     function keysRec(uint256 _curEth, uint256 _newEth)
1505         internal
1506         pure
1507         returns (uint256)
1508     {
1509         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1510     }
1511 
1512     /**
1513      * @dev calculates amount of eth received if you sold X keys
1514      * @param _curKeys current amount of keys that exist
1515      * @param _sellKeys amount of keys you wish to sell
1516      * @return amount of eth received
1517      */
1518     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1519         internal
1520         pure
1521         returns (uint256)
1522     {
1523         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1524     }
1525 
1526     /**
1527      * @dev calculates how many keys would exist with given an amount of eth
1528      * @param _eth eth "in contract"
1529      * @return number of keys that would exist
1530      */
1531     function keys(uint256 _eth)
1532         internal
1533         pure
1534         returns(uint256)
1535     {
1536          // return ((((((_eth).mul(1000000000000000000)).mul(200000000000000000000000000000000)).add(2500000000000000000000000000000000000000000000000000000000000000)).sqrt()).sub(50000000000000000000000000000000)) / (100000000000000);
1537         return (_eth / 0.01 ether) * 1e18;
1538     }
1539 
1540     /**
1541      * @dev calculates how much eth would be in contract given a number of keys
1542      * @param _keys number of keys "in contract"
1543      * @return eth that would exists
1544      */
1545     function eth(uint256 _keys)
1546         internal
1547         pure
1548         returns(uint256)
1549     {
1550        return _keys.mul(0.01 ether)  / 1e18;
1551        //return ((50000000000000).mul(_keys.sq()).add(((100000000000000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1552     }
1553 }
1554 
1555 //==============================================================================
1556 //  . _ _|_ _  _ |` _  _ _  _  .
1557 //  || | | (/_| ~|~(_|(_(/__\  .
1558 //==============================================================================
1559 
1560 interface PlayerBookInterface {
1561     function getPlayerID(address _addr) external returns (uint256);
1562     function getPlayerName(uint256 _pID) external view returns (bytes32);
1563     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1564     function getPlayerAddr(uint256 _pID) external view returns (address);
1565     function getNameFee() external view returns (uint256);
1566     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1567     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1568     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1569 }
1570 
1571 
1572 library NameFilter {
1573     /**
1574      * @dev filters name strings
1575      * -converts uppercase to lower case.
1576      * -makes sure it does not start/end with a space
1577      * -makes sure it does not contain multiple spaces in a row
1578      * -cannot be only numbers
1579      * -cannot start with 0x
1580      * -restricts characters to A-Z, a-z, 0-9, and space.
1581      * @return reprocessed string in bytes32 format
1582      */
1583     function nameFilter(string _input)
1584         internal
1585         pure
1586         returns(bytes32)
1587     {
1588         bytes memory _temp = bytes(_input);
1589         uint256 _length = _temp.length;
1590 
1591         //sorry limited to 32 characters
1592         require (_length <= 32 && _length > 0);
1593         // make sure it doesnt start with or end with space
1594         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
1595         // make sure first two characters are not 0x
1596         if (_temp[0] == 0x30)
1597         {
1598             require(_temp[1] != 0x78);
1599             require(_temp[1] != 0x58);
1600         }
1601 
1602         // create a bool to track if we have a non number character
1603         bool _hasNonNumber;
1604 
1605         // convert & check
1606         for (uint256 i = 0; i < _length; i++)
1607         {
1608             // if its uppercase A-Z
1609             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1610             {
1611                 // convert to lower case a-z
1612                 _temp[i] = byte(uint(_temp[i]) + 32);
1613 
1614                 // we have a non number
1615                 if (_hasNonNumber == false)
1616                     _hasNonNumber = true;
1617             } else {
1618                 require
1619                 (
1620                     // require character is a space
1621                     _temp[i] == 0x20 ||
1622                     // OR lowercase a-z
1623                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1624                     // or 0-9
1625                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
1626                 // make sure theres not 2x spaces in a row
1627                 if (_temp[i] == 0x20)
1628                     require( _temp[i+1] != 0x20);
1629 
1630                 // see if we have a character other than a number
1631                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1632                     _hasNonNumber = true;
1633             }
1634         }
1635 
1636         require(_hasNonNumber == true);
1637 
1638         bytes32 _ret;
1639         assembly {
1640             _ret := mload(add(_temp, 32))
1641         }
1642         return (_ret);
1643     }
1644 }
1645 
1646 /**
1647  * @title SafeMath v0.1.9
1648  * @dev Math operations with safety checks that throw on error
1649  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1650  * - added sqrt
1651  * - added sq
1652  * - added pwr
1653  * - changed asserts to requires with error log outputs
1654  * - removed div, its useless
1655  */
1656 library SafeMath {
1657 
1658     /**
1659     * @dev Multiplies two numbers, throws on overflow.
1660     */
1661     function mul(uint256 a, uint256 b)
1662         internal
1663         pure
1664         returns (uint256 c)
1665     {
1666         if (a == 0) {
1667             return 0;
1668         }
1669         c = a * b;
1670         require(c / a == b, "SafeMath mul failed");
1671         return c;
1672     }
1673 
1674     /**
1675     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1676     */
1677     function sub(uint256 a, uint256 b)
1678         internal
1679         pure
1680         returns (uint256)
1681     {
1682         require(b <= a, "SafeMath sub failed");
1683         return a - b;
1684     }
1685 
1686     /**
1687     * @dev Adds two numbers, throws on overflow.
1688     */
1689     function add(uint256 a, uint256 b)
1690         internal
1691         pure
1692         returns (uint256 c)
1693     {
1694         c = a + b;
1695         require(c >= a, "SafeMath add failed");
1696         return c;
1697     }
1698 
1699     /**
1700      * @dev gives square root of given x.
1701      */
1702     function sqrt(uint256 x)
1703         internal
1704         pure
1705         returns (uint256 y)
1706     {
1707         uint256 z = ((add(x,1)) / 2);
1708         y = x;
1709         while (z < y)
1710         {
1711             y = z;
1712             z = ((add((x / z),z)) / 2);
1713         }
1714     }
1715 
1716     /**
1717      * @dev gives square. multiplies x by x
1718      */
1719     function sq(uint256 x)
1720         internal
1721         pure
1722         returns (uint256)
1723     {
1724         return (mul(x,x));
1725     }
1726 
1727     /**
1728      * @dev x to the power of y
1729      */
1730     function pwr(uint256 x, uint256 y)
1731         internal
1732         pure
1733         returns (uint256)
1734     {
1735         if (x==0)
1736             return (0);
1737         else if (y==0)
1738             return (1);
1739         else
1740         {
1741             uint256 z = x;
1742             for (uint256 i=1; i < y; i++)
1743                 z = mul(z,x);
1744             return (z);
1745         }
1746     }
1747 }