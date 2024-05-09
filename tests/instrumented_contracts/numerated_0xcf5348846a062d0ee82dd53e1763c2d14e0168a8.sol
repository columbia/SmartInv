1 pragma solidity ^0.4.24;
2 
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
176         fees_[0] = POOHMODatasets.TeamFee(47,10);   //30% to pot, 10% to aff, 2% to com, 1% potSwap
177        
178 
179         potSplit_[0] = POOHMODatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
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
735      * @return airdrop tracker # & airdrop pot
736      */
737     function getCurrentRoundInfo()
738         public
739         view
740         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
741     {
742         // setup local rID
743         uint256 _rID = rID_;
744 
745         return
746         (
747             round_[_rID].ico,               //0
748             _rID,                           //1
749             round_[_rID].keys,              //2
750             round_[_rID].end,               //3
751             round_[_rID].strt,              //4
752             round_[_rID].pot,               //5
753             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
754             plyr_[round_[_rID].plyr].addr,  //7
755             plyr_[round_[_rID].plyr].name,  //8
756             rndTmEth_[_rID][0],             //9
757             rndTmEth_[_rID][1],             //10
758             rndTmEth_[_rID][2],             //11
759             rndTmEth_[_rID][3]              //12
760           
761         );
762     }
763 
764     /**
765      * @dev returns player info based on address.  if no address is given, it will
766      * use msg.sender
767      * -functionhash- 0xee0b5d8b
768      * @param _addr address of the player you want to lookup
769      * @return player ID
770      * @return player name
771      * @return keys owned (current round)
772      * @return winnings vault
773      * @return general vault
774      * @return affiliate vault
775      * @return player round eth
776      */
777     function getPlayerInfoByAddress(address _addr)
778         public
779         view
780         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
781     {
782         // setup local rID
783         uint256 _rID = rID_;
784 
785         if (_addr == address(0))
786         {
787             _addr == msg.sender;
788         }
789         uint256 _pID = pIDxAddr_[_addr];
790 
791         return
792         (
793             _pID,                               //0
794             plyr_[_pID].name,                   //1
795             plyrRnds_[_pID][_rID].keys,         //2
796             plyr_[_pID].win,                    //3
797             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
798             plyr_[_pID].aff,                    //5
799             plyrRnds_[_pID][_rID].eth           //6
800         );
801     }
802 
803 //==============================================================================
804 //     _ _  _ _   | _  _ . _  .
805 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
806 //=====================_|=======================================================
807     /**
808      * @dev logic runs whenever a buy order is executed.  determines how to handle
809      * incoming eth depending on if we are in an active round or not
810      */
811     function buyCore(uint256 _pID, uint256 _affID, POOHMODatasets.EventReturns memory _eventData_)
812         private
813     {
814         // setup local rID
815         uint256 _rID = rID_;
816 
817         // grab time
818         uint256 _now = now;
819 
820         // if round is active
821         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
822         {
823             // call core
824             core(_rID, _pID, msg.value, _affID, 0, _eventData_);
825 
826         // if round is not active
827         } else {
828             // check to see if end round needs to be ran
829             if (_now > round_[_rID].end && round_[_rID].ended == false)
830             {
831                 // end the round (distributes pot) & start new round
832                 round_[_rID].ended = true;
833                 _eventData_ = endRound(_eventData_);
834 
835                 // build event data
836                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
837                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
838 
839                 // fire buy and distribute event
840                 emit POOHMOevents.onBuyAndDistribute
841                 (
842                     msg.sender,
843                     plyr_[_pID].name,
844                     msg.value,
845                     _eventData_.compressedData,
846                     _eventData_.compressedIDs,
847                     _eventData_.winnerAddr,
848                     _eventData_.winnerName,
849                     _eventData_.amountWon,
850                     _eventData_.newPot,
851                     _eventData_.POOHAmount,
852                     _eventData_.genAmount
853                 );
854             }
855 
856             // put eth in players vault
857             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
858         }
859     }
860 
861     /**
862      * @dev logic runs whenever a reload order is executed.  determines how to handle
863      * incoming eth depending on if we are in an active round or not
864      */
865     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, POOHMODatasets.EventReturns memory _eventData_)
866         private
867     {
868         // setup local rID
869         uint256 _rID = rID_;
870 
871         // grab time
872         uint256 _now = now;
873 
874         // if round is active
875         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
876         {
877             // get earnings from all vaults and return unused to gen vault
878             // because we use a custom safemath library.  this will throw if player
879             // tried to spend more eth than they have.
880             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
881 
882             // call core
883             core(_rID, _pID, _eth, _affID, 0, _eventData_);
884 
885         // if round is not active and end round needs to be ran
886         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
887             // end the round (distributes pot) & start new round
888             round_[_rID].ended = true;
889             _eventData_ = endRound(_eventData_);
890 
891             // build event data
892             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
893             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
894 
895             // fire buy and distribute event
896             emit POOHMOevents.onReLoadAndDistribute
897             (
898                 msg.sender,
899                 plyr_[_pID].name,
900                 _eventData_.compressedData,
901                 _eventData_.compressedIDs,
902                 _eventData_.winnerAddr,
903                 _eventData_.winnerName,
904                 _eventData_.amountWon,
905                 _eventData_.newPot,
906                 _eventData_.POOHAmount,
907                 _eventData_.genAmount
908             );
909         }
910     }
911 
912     /**
913      * @dev this is the core logic for any buy/reload that happens while a round
914      * is live.
915      */
916     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMODatasets.EventReturns memory _eventData_)
917         private
918     {
919         // if player is new to round
920         if (plyrRnds_[_pID][_rID].keys == 0)
921             _eventData_ = managePlayer(_pID, _eventData_);
922 
923         // early round eth limiter
924         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000)
925         {
926             uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
927             uint256 _refund = _eth.sub(_availableLimit);
928             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
929             _eth = _availableLimit;
930         }
931 
932         // if eth left is greater than min eth allowed (sorry no pocket lint)
933         if (_eth > 1000000000)
934         {
935 
936             // mint the new keys
937             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
938 
939             // if they bought at least 1 whole key
940             if (_keys >= 1000000000000000000)
941             {
942             updateTimer(_keys, _rID);
943 
944             // set new leaders
945             if (round_[_rID].plyr != _pID)
946                 round_[_rID].plyr = _pID;
947             if (round_[_rID].team != _team)
948                 round_[_rID].team = _team;
949 
950             // set the new leader bool to true
951             _eventData_.compressedData = _eventData_.compressedData + 100;
952         }
953 
954             // update player
955             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
956             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
957 
958             // update round
959             round_[_rID].keys = _keys.add(round_[_rID].keys);
960             round_[_rID].eth = _eth.add(round_[_rID].eth);
961             rndTmEth_[_rID][0] = _eth.add(rndTmEth_[_rID][0]);
962 
963             // distribute eth
964             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 0, _eventData_);
965             _eventData_ = distributeInternal(_rID, _pID, _eth, 0, _keys, _eventData_);
966 
967             // call end tx function to fire end tx event.
968             endTx(_pID, 0, _eth, _keys, _eventData_);
969         }
970     }
971 //==============================================================================
972 //     _ _ | _   | _ _|_ _  _ _  .
973 //    (_(_||(_|_||(_| | (_)| _\  .
974 //==============================================================================
975     /**
976      * @dev calculates unmasked earnings (just calculates, does not update mask)
977      * @return earnings in wei format
978      */
979     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
980         private
981         view
982         returns(uint256)
983     {
984         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
985     }
986 
987     /**
988      * @dev returns the amount of keys you would get given an amount of eth.
989      * -functionhash- 0xce89c80c
990      * @param _rID round ID you want price for
991      * @param _eth amount of eth sent in
992      * @return keys received
993      */
994     function calcKeysReceived(uint256 _rID, uint256 _eth)
995         public
996         view
997         returns(uint256)
998     {
999         // grab time
1000         uint256 _now = now;
1001 
1002         // are we in a round?
1003         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1004             return ( (round_[_rID].eth).keysRec(_eth) );
1005         else // rounds over.  need keys for new round
1006             return ( (_eth).keys() );
1007     }
1008 
1009     /**
1010      * @dev returns current eth price for X keys.
1011      * -functionhash- 0xcf808000
1012      * @param _keys number of keys desired (in 18 decimal format)
1013      * @return amount of eth needed to send
1014      */
1015     function iWantXKeys(uint256 _keys)
1016         public
1017         view
1018         returns(uint256)
1019     {
1020         // setup local rID
1021         uint256 _rID = rID_;
1022 
1023         // grab time
1024         uint256 _now = now;
1025 
1026         // are we in a round?
1027         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1028             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1029         else // rounds over.  need price for new round
1030             return ( (_keys).eth() );
1031     }
1032 //==============================================================================
1033 //    _|_ _  _ | _  .
1034 //     | (_)(_)|_\  .
1035 //==============================================================================
1036     /**
1037      * @dev receives name/player info from names contract
1038      */
1039     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1040         external
1041     {
1042         require (msg.sender == address(PlayerBook));
1043         if (pIDxAddr_[_addr] != _pID)
1044             pIDxAddr_[_addr] = _pID;
1045         if (pIDxName_[_name] != _pID)
1046             pIDxName_[_name] = _pID;
1047         if (plyr_[_pID].addr != _addr)
1048             plyr_[_pID].addr = _addr;
1049         if (plyr_[_pID].name != _name)
1050             plyr_[_pID].name = _name;
1051         if (plyr_[_pID].laff != _laff)
1052             plyr_[_pID].laff = _laff;
1053         if (plyrNames_[_pID][_name] == false)
1054             plyrNames_[_pID][_name] = true;
1055     }
1056 
1057     /**
1058      * @dev receives entire player name list
1059      */
1060     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1061         external
1062     {
1063         require (msg.sender == address(PlayerBook));
1064         if(plyrNames_[_pID][_name] == false)
1065             plyrNames_[_pID][_name] = true;
1066     }
1067 
1068     /**
1069      * @dev gets existing or registers new pID.  use this when a player may be new
1070      * @return pID
1071      */
1072     function determinePID(POOHMODatasets.EventReturns memory _eventData_)
1073         private
1074         returns (POOHMODatasets.EventReturns)
1075     {
1076         uint256 _pID = pIDxAddr_[msg.sender];
1077         // if player is new to this version of fomo3d
1078         if (_pID == 0)
1079         {
1080             // grab their player ID, name and last aff ID, from player names contract
1081             _pID = PlayerBook.getPlayerID(msg.sender);
1082             bytes32 _name = PlayerBook.getPlayerName(_pID);
1083             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1084 
1085             // set up player account
1086             pIDxAddr_[msg.sender] = _pID;
1087             plyr_[_pID].addr = msg.sender;
1088 
1089             if (_name != "")
1090             {
1091                 pIDxName_[_name] = _pID;
1092                 plyr_[_pID].name = _name;
1093                 plyrNames_[_pID][_name] = true;
1094             }
1095 
1096             if (_laff != 0 && _laff != _pID)
1097                 plyr_[_pID].laff = _laff;
1098 
1099             // set the new player bool to true
1100             _eventData_.compressedData = _eventData_.compressedData + 1;
1101         }
1102         return (_eventData_);
1103     }
1104 
1105     
1106 
1107     /**
1108      * @dev decides if round end needs to be run & new round started.  and if
1109      * player unmasked earnings from previously played rounds need to be moved.
1110      */
1111     function managePlayer(uint256 _pID, POOHMODatasets.EventReturns memory _eventData_)
1112         private
1113         returns (POOHMODatasets.EventReturns)
1114     {
1115         // if player has played a previous round, move their unmasked earnings
1116         // from that round to gen vault.
1117         if (plyr_[_pID].lrnd != 0)
1118             updateGenVault(_pID, plyr_[_pID].lrnd);
1119 
1120         // update player's last round played
1121         plyr_[_pID].lrnd = rID_;
1122 
1123         // set the joined round bool to true
1124         _eventData_.compressedData = _eventData_.compressedData + 10;
1125 
1126         return(_eventData_);
1127     }
1128 
1129     /**
1130      * @dev ends the round. manages paying out winner/splitting up pot
1131      */
1132     function endRound(POOHMODatasets.EventReturns memory _eventData_)
1133         private
1134         returns (POOHMODatasets.EventReturns)
1135     {
1136         // setup local rID
1137         uint256 _rID = rID_;
1138 
1139         // grab our winning player and team id's
1140         uint256 _winPID = round_[_rID].plyr;
1141         uint256 _winTID = round_[_rID].team;
1142 
1143         // grab our pot amount
1144         uint256 _pot = round_[_rID].pot;
1145 
1146         // calculate our winner share, community rewards, gen share,
1147         // p3d share, and amount reserved for next pot
1148         uint256 _win = (_pot.mul(48)) / 100;   //48%
1149         uint256 _dev = (_pot / 50);            //2%
1150         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1151         uint256 _POOH = (_pot.mul(potSplit_[_winTID].pooh)) / 100;
1152         uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_POOH);
1153 
1154         // calculate ppt for round mask
1155         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1156         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1157         if (_dust > 0)
1158         {
1159             _gen = _gen.sub(_dust);
1160             _res = _res.add(_dust);
1161         }
1162 
1163         // pay our winner
1164         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1165 
1166         // community rewards
1167 
1168         admin.transfer(_dev);
1169 
1170         flushDivs.transfer((_POOH.sub(_POOH / 3)).mul(2));  // 2/3
1171 
1172         round_[_rID].pot = _pot.add(_POOH / 3);  // 1/3
1173 
1174         // distribute gen portion to key holders
1175         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1176 
1177         // prepare event data
1178         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1179         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1180         _eventData_.winnerAddr = plyr_[_winPID].addr;
1181         _eventData_.winnerName = plyr_[_winPID].name;
1182         _eventData_.amountWon = _win;
1183         _eventData_.genAmount = _gen;
1184         _eventData_.POOHAmount = _POOH;
1185         _eventData_.newPot = _res;
1186 
1187         // start next round
1188         rID_++;
1189         _rID++;
1190         round_[_rID].strt = now;
1191         rndMax_ = timerLengths[determineNextRoundLength()];
1192         round_[_rID].end = now.add(rndMax_);
1193         round_[_rID].pot = _res;
1194 
1195         return(_eventData_);
1196     }
1197 
1198     function determineNextRoundLength() internal view returns(uint256 time) 
1199     {
1200         uint256 roundTime = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1)))) % 6;
1201         return roundTime;
1202     }
1203     
1204 
1205     /**
1206      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1207      */
1208     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1209         private
1210     {
1211         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1212         if (_earnings > 0)
1213         {
1214             // put in gen vault
1215             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1216             // zero out their earnings by updating mask
1217             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1218         }
1219     }
1220 
1221     /**
1222      * @dev updates round timer based on number of whole keys bought.
1223      */
1224     function updateTimer(uint256 _keys, uint256 _rID)
1225         private
1226     {
1227         // grab time
1228         uint256 _now = now;
1229 
1230         // calculate time based on number of keys bought
1231         uint256 _newTime;
1232         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1233             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1234         else
1235             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1236 
1237         // compare to max and set new end time
1238         if (_newTime < (rndMax_).add(_now))
1239             round_[_rID].end = _newTime;
1240         else
1241             round_[_rID].end = rndMax_.add(_now);
1242     }
1243 
1244    
1245     /**
1246      * @dev distributes eth based on fees to com, aff, and pooh
1247      */
1248     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMODatasets.EventReturns memory _eventData_)
1249         private
1250         returns(POOHMODatasets.EventReturns)
1251     {
1252         // pay 1% out to dev
1253         uint256 _dev = _eth / 100;  // 1%
1254 
1255         uint256 _POOH;
1256         if (!address(admin).call.value(_dev)())
1257         {
1258             _POOH = _dev;
1259             _dev = 0;
1260         }
1261 
1262 
1263         // distribute share to affiliate
1264         uint256 _aff = _eth / 10;
1265 
1266         // decide what to do with affiliate share of fees
1267         // affiliate must not be self, and must have a name registered
1268         if (_affID != _pID && plyr_[_affID].name != '') {
1269             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1270             emit POOHMOevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1271         } else {
1272             _POOH = _aff;
1273         }
1274 
1275         // pay out POOH
1276         _POOH = _POOH.add((_eth.mul(fees_[_team].pooh)) / (100));
1277         if (_POOH > 0)
1278         {
1279             // deposit to divies contract
1280             uint256 _potAmount = _POOH / 2;
1281 
1282             flushDivs.transfer(_POOH.sub(_potAmount));
1283 
1284             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1285 
1286             // set up event data
1287             _eventData_.POOHAmount = _POOH.add(_eventData_.POOHAmount);
1288         }
1289 
1290         return(_eventData_);
1291     }
1292 
1293     function potSwap()
1294         external
1295         payable
1296     {
1297         // setup local rID
1298         uint256 _rID = rID_ + 1;
1299 
1300         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1301         emit POOHMOevents.onPotSwapDeposit(_rID, msg.value);
1302     }
1303 
1304     /**
1305      * @dev distributes eth based on fees to gen and pot
1306      */
1307     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, POOHMODatasets.EventReturns memory _eventData_)
1308         private
1309         returns(POOHMODatasets.EventReturns)
1310     {
1311         // calculate gen share
1312         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1313 
1314 
1315         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1316         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].pooh)) / 100));
1317 
1318         // calculate pot
1319         uint256 _pot = _eth.sub(_gen);
1320 
1321         // distribute gen share (thats what updateMasks() does) and adjust
1322         // balances for dust.
1323         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1324         if (_dust > 0)
1325             _gen = _gen.sub(_dust);
1326 
1327         // add eth to pot
1328         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1329 
1330         // set up event data
1331         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1332         _eventData_.potAmount = _pot;
1333 
1334         return(_eventData_);
1335     }
1336 
1337     /**
1338      * @dev updates masks for round and player when keys are bought
1339      * @return dust left over
1340      */
1341     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1342         private
1343         returns(uint256)
1344     {
1345         /* MASKING NOTES
1346             earnings masks are a tricky thing for people to wrap their minds around.
1347             the basic thing to understand here.  is were going to have a global
1348             tracker based on profit per share for each round, that increases in
1349             relevant proportion to the increase in share supply.
1350 
1351             the player will have an additional mask that basically says "based
1352             on the rounds mask, my shares, and how much i've already withdrawn,
1353             how much is still owed to me?"
1354         */
1355 
1356         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1357         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1358         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1359 
1360         // calculate player earning from their own buy (only based on the keys
1361         // they just bought).  & update player earnings mask
1362         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1363         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1364 
1365         // calculate & return dust
1366         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1367     }
1368 
1369     /**
1370      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1371      * @return earnings in wei format
1372      */
1373     function withdrawEarnings(uint256 _pID)
1374         private
1375         returns(uint256)
1376     {
1377         // update gen vault
1378         updateGenVault(_pID, plyr_[_pID].lrnd);
1379 
1380         // from vaults
1381         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1382         if (_earnings > 0)
1383         {
1384             plyr_[_pID].win = 0;
1385             plyr_[_pID].gen = 0;
1386             plyr_[_pID].aff = 0;
1387         }
1388 
1389         return(_earnings);
1390     }
1391 
1392     /**
1393      * @dev prepares compression data and fires event for buy or reload tx's
1394      */
1395     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, POOHMODatasets.EventReturns memory _eventData_)
1396         private
1397     {
1398         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1399         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1400 
1401         emit POOHMOevents.onEndTx
1402         (
1403             _eventData_.compressedData,
1404             _eventData_.compressedIDs,
1405             plyr_[_pID].name,
1406             msg.sender,
1407             _eth,
1408             _keys,
1409             _eventData_.winnerAddr,
1410             _eventData_.winnerName,
1411             _eventData_.amountWon,
1412             _eventData_.newPot,
1413             _eventData_.POOHAmount,
1414             _eventData_.genAmount,
1415             _eventData_.potAmount
1416         );
1417     }
1418 //==============================================================================
1419 //    (~ _  _    _._|_    .
1420 //    _)(/_(_|_|| | | \/  .
1421 //====================/=========================================================
1422     /** upon contract deploy, it will be deactivated.  this is a one time
1423      * use function that will activate the contract.  we do this so devs
1424      * have time to set things up on the web end                            **/
1425     bool public activated_ = false;
1426     function activate()
1427         public
1428     {
1429         // only team just can activate
1430         require(msg.sender == admin);
1431 
1432 
1433         // can only be ran once
1434         require(activated_ == false);
1435 
1436         // activate the contract
1437         activated_ = true;
1438 
1439         // lets start first round
1440         rID_ = 1;
1441             round_[1].strt = now + rndExtra_ - rndGap_;
1442             round_[1].end = now + rndInit_ + rndExtra_;
1443     }
1444 }
1445 
1446 //==============================================================================
1447 //   __|_ _    __|_ _  .
1448 //  _\ | | |_|(_ | _\  .
1449 //==============================================================================
1450 library POOHMODatasets {
1451     
1452     struct EventReturns {
1453         uint256 compressedData;
1454         uint256 compressedIDs;
1455         address winnerAddr;         // winner address
1456         bytes32 winnerName;         // winner name
1457         uint256 amountWon;          // amount won
1458         uint256 newPot;             // amount in new pot
1459         uint256 POOHAmount;          // amount distributed to p3d
1460         uint256 genAmount;          // amount distributed to gen
1461         uint256 potAmount;          // amount added to pot
1462     }
1463     struct Player {
1464         address addr;   // player address
1465         bytes32 name;   // player name
1466         uint256 win;    // winnings vault
1467         uint256 gen;    // general vault
1468         uint256 aff;    // affiliate vault
1469         uint256 lrnd;   // last round played
1470         uint256 laff;   // last affiliate id used
1471     }
1472     struct PlayerRounds {
1473         uint256 eth;    // eth player has added to round (used for eth limiter)
1474         uint256 keys;   // keys
1475         uint256 mask;   // player mask
1476         uint256 ico;    // ICO phase investment
1477     }
1478     struct Round {
1479         uint256 plyr;   // pID of player in lead
1480         uint256 team;   // tID of team in lead
1481         uint256 end;    // time ends/ended
1482         bool ended;     // has round end function been ran
1483         uint256 strt;   // time round started
1484         uint256 keys;   // keys
1485         uint256 eth;    // total eth in
1486         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1487         uint256 mask;   // global mask
1488         uint256 ico;    // total eth sent in during ICO phase
1489         uint256 icoGen; // total eth for gen during ICO phase
1490         uint256 icoAvg; // average key price for ICO phase
1491     }
1492     struct TeamFee {
1493         uint256 gen;    // % of buy in thats paid to key holders of current round
1494         uint256 pooh;    // % of buy in thats paid to POOH holders
1495     }
1496     struct PotSplit {
1497         uint256 gen;    // % of pot thats paid to key holders of current round
1498         uint256 pooh;    // % of pot thats paid to POOH holders
1499     }
1500 }
1501 
1502 //==============================================================================
1503 //  |  _      _ _ | _  .
1504 //  |<(/_\/  (_(_||(_  .
1505 //=======/======================================================================
1506 library KeysCalc {
1507     using SafeMath for *;
1508     /**
1509      * @dev calculates number of keys received given X eth
1510      * @param _curEth current amount of eth in contract
1511      * @param _newEth eth being spent
1512      * @return amount of ticket purchased
1513      */
1514     function keysRec(uint256 _curEth, uint256 _newEth)
1515         internal
1516         pure
1517         returns (uint256)
1518     {
1519         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1520     }
1521 
1522     /**
1523      * @dev calculates amount of eth received if you sold X keys
1524      * @param _curKeys current amount of keys that exist
1525      * @param _sellKeys amount of keys you wish to sell
1526      * @return amount of eth received
1527      */
1528     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1529         internal
1530         pure
1531         returns (uint256)
1532     {
1533         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1534     }
1535 
1536     /**
1537      * @dev calculates how many keys would exist with given an amount of eth
1538      * @param _eth eth "in contract"
1539      * @return number of keys that would exist
1540      */
1541     function keys(uint256 _eth)
1542         internal
1543         pure
1544         returns(uint256)
1545     {
1546         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1547     }
1548 
1549     /**
1550      * @dev calculates how much eth would be in contract given a number of keys
1551      * @param _keys number of keys "in contract"
1552      * @return eth that would exists
1553      */
1554     function eth(uint256 _keys)
1555         internal
1556         pure
1557         returns(uint256)
1558     {
1559         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1560     }
1561 }
1562 
1563 //==============================================================================
1564 //  . _ _|_ _  _ |` _  _ _  _  .
1565 //  || | | (/_| ~|~(_|(_(/__\  .
1566 //==============================================================================
1567 
1568 interface PlayerBookInterface {
1569     function getPlayerID(address _addr) external returns (uint256);
1570     function getPlayerName(uint256 _pID) external view returns (bytes32);
1571     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1572     function getPlayerAddr(uint256 _pID) external view returns (address);
1573     function getNameFee() external view returns (uint256);
1574     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1575     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1576     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1577 }
1578 
1579 
1580 library NameFilter {
1581     /**
1582      * @dev filters name strings
1583      * -converts uppercase to lower case.
1584      * -makes sure it does not start/end with a space
1585      * -makes sure it does not contain multiple spaces in a row
1586      * -cannot be only numbers
1587      * -cannot start with 0x
1588      * -restricts characters to A-Z, a-z, 0-9, and space.
1589      * @return reprocessed string in bytes32 format
1590      */
1591     function nameFilter(string _input)
1592         internal
1593         pure
1594         returns(bytes32)
1595     {
1596         bytes memory _temp = bytes(_input);
1597         uint256 _length = _temp.length;
1598 
1599         //sorry limited to 32 characters
1600         require (_length <= 32 && _length > 0);
1601         // make sure it doesnt start with or end with space
1602         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
1603         // make sure first two characters are not 0x
1604         if (_temp[0] == 0x30)
1605         {
1606             require(_temp[1] != 0x78);
1607             require(_temp[1] != 0x58);
1608         }
1609 
1610         // create a bool to track if we have a non number character
1611         bool _hasNonNumber;
1612 
1613         // convert & check
1614         for (uint256 i = 0; i < _length; i++)
1615         {
1616             // if its uppercase A-Z
1617             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1618             {
1619                 // convert to lower case a-z
1620                 _temp[i] = byte(uint(_temp[i]) + 32);
1621 
1622                 // we have a non number
1623                 if (_hasNonNumber == false)
1624                     _hasNonNumber = true;
1625             } else {
1626                 require
1627                 (
1628                     // require character is a space
1629                     _temp[i] == 0x20 ||
1630                     // OR lowercase a-z
1631                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1632                     // or 0-9
1633                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
1634                 // make sure theres not 2x spaces in a row
1635                 if (_temp[i] == 0x20)
1636                     require( _temp[i+1] != 0x20);
1637 
1638                 // see if we have a character other than a number
1639                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1640                     _hasNonNumber = true;
1641             }
1642         }
1643 
1644         require(_hasNonNumber == true);
1645 
1646         bytes32 _ret;
1647         assembly {
1648             _ret := mload(add(_temp, 32))
1649         }
1650         return (_ret);
1651     }
1652 }
1653 
1654 /**
1655  * @title SafeMath v0.1.9
1656  * @dev Math operations with safety checks that throw on error
1657  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1658  * - added sqrt
1659  * - added sq
1660  * - added pwr
1661  * - changed asserts to requires with error log outputs
1662  * - removed div, its useless
1663  */
1664 library SafeMath {
1665 
1666     /**
1667     * @dev Multiplies two numbers, throws on overflow.
1668     */
1669     function mul(uint256 a, uint256 b)
1670         internal
1671         pure
1672         returns (uint256 c)
1673     {
1674         if (a == 0) {
1675             return 0;
1676         }
1677         c = a * b;
1678         require(c / a == b, "SafeMath mul failed");
1679         return c;
1680     }
1681 
1682     /**
1683     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1684     */
1685     function sub(uint256 a, uint256 b)
1686         internal
1687         pure
1688         returns (uint256)
1689     {
1690         require(b <= a, "SafeMath sub failed");
1691         return a - b;
1692     }
1693 
1694     /**
1695     * @dev Adds two numbers, throws on overflow.
1696     */
1697     function add(uint256 a, uint256 b)
1698         internal
1699         pure
1700         returns (uint256 c)
1701     {
1702         c = a + b;
1703         require(c >= a, "SafeMath add failed");
1704         return c;
1705     }
1706 
1707     /**
1708      * @dev gives square root of given x.
1709      */
1710     function sqrt(uint256 x)
1711         internal
1712         pure
1713         returns (uint256 y)
1714     {
1715         uint256 z = ((add(x,1)) / 2);
1716         y = x;
1717         while (z < y)
1718         {
1719             y = z;
1720             z = ((add((x / z),z)) / 2);
1721         }
1722     }
1723 
1724     /**
1725      * @dev gives square. multiplies x by x
1726      */
1727     function sq(uint256 x)
1728         internal
1729         pure
1730         returns (uint256)
1731     {
1732         return (mul(x,x));
1733     }
1734 
1735     /**
1736      * @dev x to the power of y
1737      */
1738     function pwr(uint256 x, uint256 y)
1739         internal
1740         pure
1741         returns (uint256)
1742     {
1743         if (x==0)
1744             return (0);
1745         else if (y==0)
1746             return (1);
1747         else
1748         {
1749             uint256 z = x;
1750             for (uint256 i=1; i < y; i++)
1751                 z = mul(z,x);
1752             return (z);
1753         }
1754     }
1755 }