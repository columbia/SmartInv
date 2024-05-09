1 pragma solidity ^0.4.24;
2 /////////////////////////////////////THATS ONLY FOR TEST////////////////////////////////////////
3 contract POOHMOevents {
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
120 contract POOHMO is POOHMOevents {
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
133     string constant public name = "POOHMO";
134     string constant public symbol = "POOHMO";
135     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
136     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
137     uint256 private rndInit_ = 30 minutes;                // round timer starts at this
138     uint256 constant private rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
139     uint256 private rndMax_ = 6 hours;                          // max length a round timer can be
140     uint256[6]  private timerLengths = [30 minutes,60 minutes,120 minutes,360 minutes,720 minutes,1440 minutes];             
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
151     mapping (uint256 => POOHMODatasets.Player) public plyr_;   // (pID => data) player data
152     mapping (uint256 => mapping (uint256 => POOHMODatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
153     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
154 //****************
155 // ROUND DATA
156 //****************
157     mapping (uint256 => POOHMODatasets.Round) public round_;   // (rID => data) round data
158     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
159 //****************
160 // TEAM FEE DATA
161 //****************
162     mapping (uint256 => POOHMODatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
163     mapping (uint256 => POOHMODatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
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
176         fees_[0] = POOHMODatasets.TeamFee(49,10);   //30% to pot, 10% to aff, 1% to dev,
177        
178 
179         potSplit_[0] = POOHMODatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to dev
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
231         POOHMODatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
255         POOHMODatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
285         POOHMODatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
322         POOHMODatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
368         POOHMODatasets.EventReturns memory _eventData_;
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
397         POOHMODatasets.EventReturns memory _eventData_;
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
434         POOHMODatasets.EventReturns memory _eventData_;
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
489             POOHMODatasets.EventReturns memory _eventData_;
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
507             emit POOHMOevents.onWithdrawAndDistribute
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
532             emit POOHMOevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
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
573         emit POOHMOevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
589         emit POOHMOevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
605         emit POOHMOevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
621         // setup local rID
622         uint256 _rID = rID_;
623 
624         // grab time
625         uint256 _now = now;
626 
627         // are we in a round?
628         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
629             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
630         else // rounds over.  need price for new round
631             return ( 75000000000000 ); // init
632     }
633 
634     /**
635      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
636      * provider
637      * -functionhash- 0xc7e284b8
638      * @return time left in seconds
639      */
640     function getTimeLeft()
641         public
642         view
643         returns(uint256)
644     {
645         // setup local rID
646         uint256 _rID = rID_;
647 
648         // grab time
649         uint256 _now = now;
650 
651         if (_now < round_[_rID].end)
652             if (_now > round_[_rID].strt + rndGap_)
653                 return( (round_[_rID].end).sub(_now) );
654             else
655                 return( (round_[_rID].strt + rndGap_).sub(_now) );
656         else
657             return(0);
658     }
659 
660     /**
661      * @dev returns player earnings per vaults
662      * -functionhash- 0x63066434
663      * @return winnings vault
664      * @return general vault
665      * @return affiliate vault
666      */
667     function getPlayerVaults(uint256 _pID)
668         public
669         view
670         returns(uint256 ,uint256, uint256)
671     {
672         // setup local rID
673         uint256 _rID = rID_;
674 
675         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
676         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
677         {
678             // if player is winner
679             if (round_[_rID].plyr == _pID)
680             {
681                 return
682                 (
683                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
684                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
685                     plyr_[_pID].aff
686                 );
687             // if player is not the winner
688             } else {
689                 return
690                 (
691                     plyr_[_pID].win,
692                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
693                     plyr_[_pID].aff
694                 );
695             }
696 
697         // if round is still going on, or round has ended and round end has been ran
698         } else {
699             return
700             (
701                 plyr_[_pID].win,
702                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
703                 plyr_[_pID].aff
704             );
705         }
706     }
707 
708     /**
709      * solidity hates stack limits.  this lets us avoid that hate
710      */
711     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
712         private
713         view
714         returns(uint256)
715     {
716         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
717     }
718 
719     /**
720      * @dev returns all current round info needed for front end
721      * -functionhash- 0x747dff42
722      * @return eth invested during ICO phase
723      * @return round id
724      * @return total keys for round
725      * @return time round ends
726      * @return time round started
727      * @return current pot
728      * @return current team ID & player ID in lead
729      * @return current player in leads address
730      * @return current player in leads name
731      * @return whales eth in for round
732      * @return bears eth in for round
733      * @return sneks eth in for round
734      * @return bulls eth in for round
735      */
736     function getCurrentRoundInfo()
737         public
738         view
739         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
740     {
741         // setup local rID
742         uint256 _rID = rID_;
743 
744         return
745         (
746             round_[_rID].ico,               //0
747             _rID,                           //1
748             round_[_rID].keys,              //2
749             round_[_rID].end,               //3
750             round_[_rID].strt,              //4
751             round_[_rID].pot,               //5
752             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
753             plyr_[round_[_rID].plyr].addr,  //7
754             plyr_[round_[_rID].plyr].name,  //8
755             rndTmEth_[_rID][0],             //9
756             rndTmEth_[_rID][1],             //10
757             rndTmEth_[_rID][2],             //11
758             rndTmEth_[_rID][3]              //12
759           
760         );
761     }
762 
763     /**
764      * @dev returns player info based on address.  if no address is given, it will
765      * use msg.sender
766      * -functionhash- 0xee0b5d8b
767      * @param _addr address of the player you want to lookup
768      * @return player ID
769      * @return player name
770      * @return keys owned (current round)
771      * @return winnings vault
772      * @return general vault
773      * @return affiliate vault
774      * @return player round eth
775      */
776     function getPlayerInfoByAddress(address _addr)
777         public
778         view
779         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
780     {
781         // setup local rID
782         uint256 _rID = rID_;
783 
784         if (_addr == address(0))
785         {
786             _addr == msg.sender;
787         }
788         uint256 _pID = pIDxAddr_[_addr];
789 
790         return
791         (
792             _pID,                               //0
793             plyr_[_pID].name,                   //1
794             plyrRnds_[_pID][_rID].keys,         //2
795             plyr_[_pID].win,                    //3
796             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
797             plyr_[_pID].aff,                    //5
798             plyrRnds_[_pID][_rID].eth           //6
799         );
800     }
801 
802 //==============================================================================
803 //     _ _  _ _   | _  _ . _  .
804 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
805 //=====================_|=======================================================
806     /**
807      * @dev logic runs whenever a buy order is executed.  determines how to handle
808      * incoming eth depending on if we are in an active round or not
809      */
810     function buyCore(uint256 _pID, uint256 _affID, POOHMODatasets.EventReturns memory _eventData_)
811         private
812     {
813         // setup local rID
814         uint256 _rID = rID_;
815 
816         // grab time
817         uint256 _now = now;
818 
819         // if round is active
820         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
821         {
822             // call core
823             core(_rID, _pID, msg.value, _affID, 0, _eventData_);
824 
825         // if round is not active
826         } else {
827             // check to see if end round needs to be ran
828             if (_now > round_[_rID].end && round_[_rID].ended == false)
829             {
830                 // end the round (distributes pot) & start new round
831                 round_[_rID].ended = true;
832                 _eventData_ = endRound(_eventData_);
833 
834                 // build event data
835                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
836                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
837 
838                 // fire buy and distribute event
839                 emit POOHMOevents.onBuyAndDistribute
840                 (
841                     msg.sender,
842                     plyr_[_pID].name,
843                     msg.value,
844                     _eventData_.compressedData,
845                     _eventData_.compressedIDs,
846                     _eventData_.winnerAddr,
847                     _eventData_.winnerName,
848                     _eventData_.amountWon,
849                     _eventData_.newPot,
850                     _eventData_.POOHAmount,
851                     _eventData_.genAmount
852                 );
853             }
854 
855             // put eth in players vault
856             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
857         }
858     }
859 
860     /**
861      * @dev logic runs whenever a reload order is executed.  determines how to handle
862      * incoming eth depending on if we are in an active round or not
863      */
864     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, POOHMODatasets.EventReturns memory _eventData_)
865         private
866     {
867         // setup local rID
868         uint256 _rID = rID_;
869 
870         // grab time
871         uint256 _now = now;
872 
873         // if round is active
874         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
875         {
876             // get earnings from all vaults and return unused to gen vault
877             // because we use a custom safemath library.  this will throw if player
878             // tried to spend more eth than they have.
879             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
880 
881             // call core
882             core(_rID, _pID, _eth, _affID, 0, _eventData_);
883 
884         // if round is not active and end round needs to be ran
885         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
886             // end the round (distributes pot) & start new round
887             round_[_rID].ended = true;
888             _eventData_ = endRound(_eventData_);
889 
890             // build event data
891             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
892             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
893 
894             // fire buy and distribute event
895             emit POOHMOevents.onReLoadAndDistribute
896             (
897                 msg.sender,
898                 plyr_[_pID].name,
899                 _eventData_.compressedData,
900                 _eventData_.compressedIDs,
901                 _eventData_.winnerAddr,
902                 _eventData_.winnerName,
903                 _eventData_.amountWon,
904                 _eventData_.newPot,
905                 _eventData_.POOHAmount,
906                 _eventData_.genAmount
907             );
908         }
909     }
910 
911     /**
912      * @dev this is the core logic for any buy/reload that happens while a round
913      * is live.
914      */
915     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMODatasets.EventReturns memory _eventData_)
916         private
917     {
918         // if player is new to round
919         if (plyrRnds_[_pID][_rID].keys == 0)
920             _eventData_ = managePlayer(_pID, _eventData_);
921 
922         // early round eth limiter
923         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000)
924         {
925             uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
926             uint256 _refund = _eth.sub(_availableLimit);
927             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
928             _eth = _availableLimit;
929         }
930 
931         // if eth left is greater than min eth allowed (sorry no pocket lint)
932         if (_eth > 1000000000)
933         {
934 
935             // mint the new keys
936             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
937 
938             // if they bought at least 1 whole key
939             if (_keys >= 1000000000000000000)
940             {
941             updateTimer(_keys, _rID);
942 
943             // set new leaders
944             if (round_[_rID].plyr != _pID)
945                 round_[_rID].plyr = _pID;
946             if (round_[_rID].team != _team)
947                 round_[_rID].team = _team;
948 
949             // set the new leader bool to true
950             _eventData_.compressedData = _eventData_.compressedData + 100;
951         }
952 
953             // update player
954             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
955             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
956 
957             // update round
958             round_[_rID].keys = _keys.add(round_[_rID].keys);
959             round_[_rID].eth = _eth.add(round_[_rID].eth);
960             rndTmEth_[_rID][0] = _eth.add(rndTmEth_[_rID][0]);
961 
962             // distribute eth
963             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 0, _eventData_);
964             _eventData_ = distributeInternal(_rID, _pID, _eth, 0, _keys, _eventData_);
965 
966             // call end tx function to fire end tx event.
967             endTx(_pID, 0, _eth, _keys, _eventData_);
968         }
969     }
970 //==============================================================================
971 //     _ _ | _   | _ _|_ _  _ _  .
972 //    (_(_||(_|_||(_| | (_)| _\  .
973 //==============================================================================
974     /**
975      * @dev calculates unmasked earnings (just calculates, does not update mask)
976      * @return earnings in wei format
977      */
978     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
979         private
980         view
981         returns(uint256)
982     {
983         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
984     }
985 
986     /**
987      * @dev returns the amount of keys you would get given an amount of eth.
988      * -functionhash- 0xce89c80c
989      * @param _rID round ID you want price for
990      * @param _eth amount of eth sent in
991      * @return keys received
992      */
993     function calcKeysReceived(uint256 _rID, uint256 _eth)
994         public
995         view
996         returns(uint256)
997     {
998         // grab time
999         uint256 _now = now;
1000 
1001         // are we in a round?
1002         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1003             return ( (round_[_rID].eth).keysRec(_eth) );
1004         else // rounds over.  need keys for new round
1005             return ( (_eth).keys() );
1006     }
1007 
1008     /**
1009      * @dev returns current eth price for X keys.
1010      * -functionhash- 0xcf808000
1011      * @param _keys number of keys desired (in 18 decimal format)
1012      * @return amount of eth needed to send
1013      */
1014     function iWantXKeys(uint256 _keys)
1015         public
1016         view
1017         returns(uint256)
1018     {
1019         // setup local rID
1020         uint256 _rID = rID_;
1021 
1022         // grab time
1023         uint256 _now = now;
1024 
1025         // are we in a round?
1026         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1027             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1028         else // rounds over.  need price for new round
1029             return ( (_keys).eth() );
1030     }
1031 //==============================================================================
1032 //    _|_ _  _ | _  .
1033 //     | (_)(_)|_\  .
1034 //==============================================================================
1035     /**
1036      * @dev receives name/player info from names contract
1037      */
1038     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1039         external
1040     {
1041         require (msg.sender == address(PlayerBook));
1042         if (pIDxAddr_[_addr] != _pID)
1043             pIDxAddr_[_addr] = _pID;
1044         if (pIDxName_[_name] != _pID)
1045             pIDxName_[_name] = _pID;
1046         if (plyr_[_pID].addr != _addr)
1047             plyr_[_pID].addr = _addr;
1048         if (plyr_[_pID].name != _name)
1049             plyr_[_pID].name = _name;
1050         if (plyr_[_pID].laff != _laff)
1051             plyr_[_pID].laff = _laff;
1052         if (plyrNames_[_pID][_name] == false)
1053             plyrNames_[_pID][_name] = true;
1054     }
1055 
1056     /**
1057      * @dev receives entire player name list
1058      */
1059     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1060         external
1061     {
1062         require (msg.sender == address(PlayerBook));
1063         if(plyrNames_[_pID][_name] == false)
1064             plyrNames_[_pID][_name] = true;
1065     }
1066 
1067     /**
1068      * @dev gets existing or registers new pID.  use this when a player may be new
1069      * @return pID
1070      */
1071     function determinePID(POOHMODatasets.EventReturns memory _eventData_)
1072         private
1073         returns (POOHMODatasets.EventReturns)
1074     {
1075         uint256 _pID = pIDxAddr_[msg.sender];
1076         // if player is new to this version of fomo3d
1077         if (_pID == 0)
1078         {
1079             // grab their player ID, name and last aff ID, from player names contract
1080             _pID = PlayerBook.getPlayerID(msg.sender);
1081             bytes32 _name = PlayerBook.getPlayerName(_pID);
1082             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1083 
1084             // set up player account
1085             pIDxAddr_[msg.sender] = _pID;
1086             plyr_[_pID].addr = msg.sender;
1087 
1088             if (_name != "")
1089             {
1090                 pIDxName_[_name] = _pID;
1091                 plyr_[_pID].name = _name;
1092                 plyrNames_[_pID][_name] = true;
1093             }
1094 
1095             if (_laff != 0 && _laff != _pID)
1096                 plyr_[_pID].laff = _laff;
1097 
1098             // set the new player bool to true
1099             _eventData_.compressedData = _eventData_.compressedData + 1;
1100         }
1101         return (_eventData_);
1102     }
1103 
1104     
1105 
1106     /**
1107      * @dev decides if round end needs to be run & new round started.  and if
1108      * player unmasked earnings from previously played rounds need to be moved.
1109      */
1110     function managePlayer(uint256 _pID, POOHMODatasets.EventReturns memory _eventData_)
1111         private
1112         returns (POOHMODatasets.EventReturns)
1113     {
1114         // if player has played a previous round, move their unmasked earnings
1115         // from that round to gen vault.
1116         if (plyr_[_pID].lrnd != 0)
1117             updateGenVault(_pID, plyr_[_pID].lrnd);
1118 
1119         // update player's last round played
1120         plyr_[_pID].lrnd = rID_;
1121 
1122         // set the joined round bool to true
1123         _eventData_.compressedData = _eventData_.compressedData + 10;
1124 
1125         return(_eventData_);
1126     }
1127 
1128     /**
1129      * @dev ends the round. manages paying out winner/splitting up pot
1130      */
1131     function endRound(POOHMODatasets.EventReturns memory _eventData_)
1132         private
1133         returns (POOHMODatasets.EventReturns)
1134     {
1135         // setup local rID
1136         uint256 _rID = rID_;
1137 
1138         // grab our winning player and team id's
1139         uint256 _winPID = round_[_rID].plyr;
1140         uint256 _winTID = round_[_rID].team;
1141 
1142         // grab our pot amount
1143         uint256 _pot = round_[_rID].pot;
1144 
1145         // calculate our winner share, community rewards, gen share,
1146         // p3d share, and amount reserved for next pot
1147         uint256 _win = (_pot.mul(48)) / 100;   //48%
1148         uint256 _dev = (_pot / 50);            //2%
1149         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; //15
1150         uint256 _POOH = (_pot.mul(potSplit_[_winTID].pooh)) / 100; // 10
1151         uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_POOH); //25
1152 
1153         // calculate ppt for round mask
1154         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1155         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1156         if (_dust > 0)
1157         {
1158             _gen = _gen.sub(_dust);
1159             _res = _res.add(_dust);
1160         }
1161 
1162         // pay our winner
1163         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1164 
1165         // community rewards
1166 
1167         admin.transfer(_dev);
1168 
1169         flushDivs.call.value(_POOH)(bytes4(keccak256("donate()")));  
1170 
1171         // distribute gen portion to key holders
1172         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1173 
1174         // prepare event data
1175         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1176         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1177         _eventData_.winnerAddr = plyr_[_winPID].addr;
1178         _eventData_.winnerName = plyr_[_winPID].name;
1179         _eventData_.amountWon = _win;
1180         _eventData_.genAmount = _gen;
1181         _eventData_.POOHAmount = _POOH;
1182         _eventData_.newPot = _res;
1183 
1184         // start next round
1185         rID_++;
1186         _rID++;
1187         round_[_rID].strt = now;
1188         rndMax_ = timerLengths[determineNextRoundLength()];
1189         round_[_rID].end = now.add(rndMax_);
1190         round_[_rID].pot = _res;
1191 
1192         return(_eventData_);
1193     }
1194 
1195     function determineNextRoundLength() internal view returns(uint256 time) 
1196     {
1197         uint256 roundTime = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1)))) % 6;
1198         return roundTime;
1199     }
1200     
1201 
1202     /**
1203      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1204      */
1205     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1206         private
1207     {
1208         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1209         if (_earnings > 0)
1210         {
1211             // put in gen vault
1212             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1213             // zero out their earnings by updating mask
1214             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1215         }
1216     }
1217 
1218     /**
1219      * @dev updates round timer based on number of whole keys bought.
1220      */
1221     function updateTimer(uint256 _keys, uint256 _rID)
1222         private
1223     {
1224         // grab time
1225         uint256 _now = now;
1226 
1227         // calculate time based on number of keys bought
1228         uint256 _newTime;
1229         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1230             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1231         else
1232             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1233 
1234         // compare to max and set new end time
1235         if (_newTime < (rndMax_).add(_now))
1236             round_[_rID].end = _newTime;
1237         else
1238             round_[_rID].end = rndMax_.add(_now);
1239     }
1240 
1241    
1242     /**
1243      * @dev distributes eth based on fees to com, aff, and pooh
1244      */
1245     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMODatasets.EventReturns memory _eventData_)
1246         private
1247         returns(POOHMODatasets.EventReturns)
1248     {
1249         // pay 1% out to dev
1250         uint256 _dev = _eth / 100;  // 1%
1251 
1252         uint256 _POOH = 0;
1253         if (!address(admin).call.value(_dev)())
1254         {
1255             _POOH = _dev;
1256             _dev = 0;
1257         }
1258 
1259 
1260         // distribute share to affiliate
1261         uint256 _aff = _eth / 10;
1262 
1263         // decide what to do with affiliate share of fees
1264         // affiliate must not be self, and must have a name registered
1265         if (_affID != _pID && plyr_[_affID].name != '') {
1266             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1267             emit POOHMOevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1268         } else {
1269             _POOH = _POOH.add(_aff);
1270         }
1271 
1272         // pay out POOH
1273         _POOH = _POOH.add((_eth.mul(fees_[_team].pooh)) / (100));
1274         if (_POOH > 0)
1275         {
1276             // deposit to divies contract
1277             //uint256 _potAmount = _POOH / 2;
1278 
1279             flushDivs.call.value(_POOH)(bytes4(keccak256("donate()")));
1280 
1281             //round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1282 
1283             // set up event data
1284             _eventData_.POOHAmount = _POOH.add(_eventData_.POOHAmount);
1285         }
1286 
1287         return(_eventData_);
1288     }
1289 
1290     function potSwap()
1291         external
1292         payable
1293     {
1294        //you shouldn't be using this method
1295        admin.transfer(msg.value);
1296     }
1297 
1298     /**
1299      * @dev distributes eth based on fees to gen and pot
1300      */
1301     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, POOHMODatasets.EventReturns memory _eventData_)
1302         private
1303         returns(POOHMODatasets.EventReturns)
1304     {
1305         // calculate gen share
1306         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1307 
1308 
1309         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1310         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].pooh)) / 100));
1311 
1312         // calculate pot
1313         uint256 _pot = _eth.sub(_gen);
1314 
1315         // distribute gen share (thats what updateMasks() does) and adjust
1316         // balances for dust.
1317         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1318         if (_dust > 0)
1319             _gen = _gen.sub(_dust);
1320 
1321         // add eth to pot
1322         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1323 
1324         // set up event data
1325         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1326         _eventData_.potAmount = _pot;
1327 
1328         return(_eventData_);
1329     }
1330 
1331     /**
1332      * @dev updates masks for round and player when keys are bought
1333      * @return dust left over
1334      */
1335     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1336         private
1337         returns(uint256)
1338     {
1339         /* MASKING NOTES
1340             earnings masks are a tricky thing for people to wrap their minds around.
1341             the basic thing to understand here.  is were going to have a global
1342             tracker based on profit per share for each round, that increases in
1343             relevant proportion to the increase in share supply.
1344 
1345             the player will have an additional mask that basically says "based
1346             on the rounds mask, my shares, and how much i've already withdrawn,
1347             how much is still owed to me?"
1348         */
1349 
1350         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1351         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1352         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1353 
1354         // calculate player earning from their own buy (only based on the keys
1355         // they just bought).  & update player earnings mask
1356         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1357         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1358 
1359         // calculate & return dust
1360         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1361     }
1362 
1363     /**
1364      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1365      * @return earnings in wei format
1366      */
1367     function withdrawEarnings(uint256 _pID)
1368         private
1369         returns(uint256)
1370     {
1371         // update gen vault
1372         updateGenVault(_pID, plyr_[_pID].lrnd);
1373 
1374         // from vaults
1375         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1376         if (_earnings > 0)
1377         {
1378             plyr_[_pID].win = 0;
1379             plyr_[_pID].gen = 0;
1380             plyr_[_pID].aff = 0;
1381         }
1382 
1383         return(_earnings);
1384     }
1385 
1386     /**
1387      * @dev prepares compression data and fires event for buy or reload tx's
1388      */
1389     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, POOHMODatasets.EventReturns memory _eventData_)
1390         private
1391     {
1392         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1393         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1394 
1395         emit POOHMOevents.onEndTx
1396         (
1397             _eventData_.compressedData,
1398             _eventData_.compressedIDs,
1399             plyr_[_pID].name,
1400             msg.sender,
1401             _eth,
1402             _keys,
1403             _eventData_.winnerAddr,
1404             _eventData_.winnerName,
1405             _eventData_.amountWon,
1406             _eventData_.newPot,
1407             _eventData_.POOHAmount,
1408             _eventData_.genAmount,
1409             _eventData_.potAmount
1410         );
1411     }
1412 //==============================================================================
1413 //    (~ _  _    _._|_    .
1414 //    _)(/_(_|_|| | | \/  .
1415 //====================/=========================================================
1416     /** upon contract deploy, it will be deactivated.  this is a one time
1417      * use function that will activate the contract.  we do this so devs
1418      * have time to set things up on the web end                            **/
1419     bool public activated_ = false;
1420     function activate()
1421         public
1422     {
1423         // only team just can activate
1424         require(msg.sender == admin);
1425 
1426 
1427         // can only be ran once
1428         require(activated_ == false);
1429 
1430         // activate the contract
1431         activated_ = true;
1432 
1433         // lets start first round
1434         rID_ = 1;
1435             round_[1].strt = now + rndExtra_ - rndGap_;
1436             round_[1].end = now + rndInit_ + rndExtra_;
1437     }
1438 }
1439 
1440 //==============================================================================
1441 //   __|_ _    __|_ _  .
1442 //  _\ | | |_|(_ | _\  .
1443 //==============================================================================
1444 library POOHMODatasets {
1445     
1446     struct EventReturns {
1447         uint256 compressedData;
1448         uint256 compressedIDs;
1449         address winnerAddr;         // winner address
1450         bytes32 winnerName;         // winner name
1451         uint256 amountWon;          // amount won
1452         uint256 newPot;             // amount in new pot
1453         uint256 POOHAmount;          // amount distributed to p3d
1454         uint256 genAmount;          // amount distributed to gen
1455         uint256 potAmount;          // amount added to pot
1456     }
1457     struct Player {
1458         address addr;   // player address
1459         bytes32 name;   // player name
1460         uint256 win;    // winnings vault
1461         uint256 gen;    // general vault
1462         uint256 aff;    // affiliate vault
1463         uint256 lrnd;   // last round played
1464         uint256 laff;   // last affiliate id used
1465     }
1466     struct PlayerRounds {
1467         uint256 eth;    // eth player has added to round (used for eth limiter)
1468         uint256 keys;   // keys
1469         uint256 mask;   // player mask
1470         uint256 ico;    // ICO phase investment
1471     }
1472     struct Round {
1473         uint256 plyr;   // pID of player in lead
1474         uint256 team;   // tID of team in lead
1475         uint256 end;    // time ends/ended
1476         bool ended;     // has round end function been ran
1477         uint256 strt;   // time round started
1478         uint256 keys;   // keys
1479         uint256 eth;    // total eth in
1480         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1481         uint256 mask;   // global mask
1482         uint256 ico;    // total eth sent in during ICO phase
1483         uint256 icoGen; // total eth for gen during ICO phase
1484         uint256 icoAvg; // average key price for ICO phase
1485     }
1486     struct TeamFee {
1487         uint256 gen;    // % of buy in thats paid to key holders of current round
1488         uint256 pooh;    // % of buy in thats paid to POOH holders
1489     }
1490     struct PotSplit {
1491         uint256 gen;    // % of pot thats paid to key holders of current round
1492         uint256 pooh;    // % of pot thats paid to POOH holders
1493     }
1494 }
1495 
1496 //==============================================================================
1497 //  |  _      _ _ | _  .
1498 //  |<(/_\/  (_(_||(_  .
1499 //=======/======================================================================
1500 library KeysCalc {
1501     using SafeMath for *;
1502     /**
1503      * @dev calculates number of keys received given X eth
1504      * @param _curEth current amount of eth in contract
1505      * @param _newEth eth being spent
1506      * @return amount of ticket purchased
1507      */
1508     function keysRec(uint256 _curEth, uint256 _newEth)
1509         internal
1510         pure
1511         returns (uint256)
1512     {
1513         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1514     }
1515 
1516     /**
1517      * @dev calculates amount of eth received if you sold X keys
1518      * @param _curKeys current amount of keys that exist
1519      * @param _sellKeys amount of keys you wish to sell
1520      * @return amount of eth received
1521      */
1522     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1523         internal
1524         pure
1525         returns (uint256)
1526     {
1527         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1528     }
1529 
1530     /**
1531      * @dev calculates how many keys would exist with given an amount of eth
1532      * @param _eth eth "in contract"
1533      * @return number of keys that would exist
1534      */
1535     function keys(uint256 _eth)
1536         internal
1537         pure
1538         returns(uint256)
1539     {
1540         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1541     }
1542 
1543     /**
1544      * @dev calculates how much eth would be in contract given a number of keys
1545      * @param _keys number of keys "in contract"
1546      * @return eth that would exists
1547      */
1548     function eth(uint256 _keys)
1549         internal
1550         pure
1551         returns(uint256)
1552     {
1553         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1554     }
1555 }
1556 
1557 //==============================================================================
1558 //  . _ _|_ _  _ |` _  _ _  _  .
1559 //  || | | (/_| ~|~(_|(_(/__\  .
1560 //==============================================================================
1561 
1562 interface PlayerBookInterface {
1563     function getPlayerID(address _addr) external returns (uint256);
1564     function getPlayerName(uint256 _pID) external view returns (bytes32);
1565     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1566     function getPlayerAddr(uint256 _pID) external view returns (address);
1567     function getNameFee() external view returns (uint256);
1568     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1569     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1570     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1571 }
1572 
1573 
1574 library NameFilter {
1575     /**
1576      * @dev filters name strings
1577      * -converts uppercase to lower case.
1578      * -makes sure it does not start/end with a space
1579      * -makes sure it does not contain multiple spaces in a row
1580      * -cannot be only numbers
1581      * -cannot start with 0x
1582      * -restricts characters to A-Z, a-z, 0-9, and space.
1583      * @return reprocessed string in bytes32 format
1584      */
1585     function nameFilter(string _input)
1586         internal
1587         pure
1588         returns(bytes32)
1589     {
1590         bytes memory _temp = bytes(_input);
1591         uint256 _length = _temp.length;
1592 
1593         //sorry limited to 32 characters
1594         require (_length <= 32 && _length > 0);
1595         // make sure it doesnt start with or end with space
1596         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
1597         // make sure first two characters are not 0x
1598         if (_temp[0] == 0x30)
1599         {
1600             require(_temp[1] != 0x78);
1601             require(_temp[1] != 0x58);
1602         }
1603 
1604         // create a bool to track if we have a non number character
1605         bool _hasNonNumber;
1606 
1607         // convert & check
1608         for (uint256 i = 0; i < _length; i++)
1609         {
1610             // if its uppercase A-Z
1611             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1612             {
1613                 // convert to lower case a-z
1614                 _temp[i] = byte(uint(_temp[i]) + 32);
1615 
1616                 // we have a non number
1617                 if (_hasNonNumber == false)
1618                     _hasNonNumber = true;
1619             } else {
1620                 require
1621                 (
1622                     // require character is a space
1623                     _temp[i] == 0x20 ||
1624                     // OR lowercase a-z
1625                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1626                     // or 0-9
1627                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
1628                 // make sure theres not 2x spaces in a row
1629                 if (_temp[i] == 0x20)
1630                     require( _temp[i+1] != 0x20);
1631 
1632                 // see if we have a character other than a number
1633                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1634                     _hasNonNumber = true;
1635             }
1636         }
1637 
1638         require(_hasNonNumber == true);
1639 
1640         bytes32 _ret;
1641         assembly {
1642             _ret := mload(add(_temp, 32))
1643         }
1644         return (_ret);
1645     }
1646 }
1647 
1648 /**
1649  * @title SafeMath v0.1.9
1650  * @dev Math operations with safety checks that throw on error
1651  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1652  * - added sqrt
1653  * - added sq
1654  * - added pwr
1655  * - changed asserts to requires with error log outputs
1656  * - removed div, its useless
1657  */
1658 library SafeMath {
1659 
1660     /**
1661     * @dev Multiplies two numbers, throws on overflow.
1662     */
1663     function mul(uint256 a, uint256 b)
1664         internal
1665         pure
1666         returns (uint256 c)
1667     {
1668         if (a == 0) {
1669             return 0;
1670         }
1671         c = a * b;
1672         require(c / a == b, "SafeMath mul failed");
1673         return c;
1674     }
1675 
1676     /**
1677     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1678     */
1679     function sub(uint256 a, uint256 b)
1680         internal
1681         pure
1682         returns (uint256)
1683     {
1684         require(b <= a, "SafeMath sub failed");
1685         return a - b;
1686     }
1687 
1688     /**
1689     * @dev Adds two numbers, throws on overflow.
1690     */
1691     function add(uint256 a, uint256 b)
1692         internal
1693         pure
1694         returns (uint256 c)
1695     {
1696         c = a + b;
1697         require(c >= a, "SafeMath add failed");
1698         return c;
1699     }
1700 
1701     /**
1702      * @dev gives square root of given x.
1703      */
1704     function sqrt(uint256 x)
1705         internal
1706         pure
1707         returns (uint256 y)
1708     {
1709         uint256 z = ((add(x,1)) / 2);
1710         y = x;
1711         while (z < y)
1712         {
1713             y = z;
1714             z = ((add((x / z),z)) / 2);
1715         }
1716     }
1717 
1718     /**
1719      * @dev gives square. multiplies x by x
1720      */
1721     function sq(uint256 x)
1722         internal
1723         pure
1724         returns (uint256)
1725     {
1726         return (mul(x,x));
1727     }
1728 
1729     /**
1730      * @dev x to the power of y
1731      */
1732     function pwr(uint256 x, uint256 y)
1733         internal
1734         pure
1735         returns (uint256)
1736     {
1737         if (x==0)
1738             return (0);
1739         else if (y==0)
1740             return (1);
1741         else
1742         {
1743             uint256 z = x;
1744             for (uint256 i=1; i < y; i++)
1745                 z = mul(z,x);
1746             return (z);
1747         }
1748     }
1749 }