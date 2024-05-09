1 pragma solidity ^0.4.24;
2  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
3  // Website: https://zaynixkey.com
4  // Telegram Annoucements: https://t.me/zaynixcom
5  // Telegram Group: https://t.me/joinchat/ItCwUkuUfhZMTrO4aCP6OQ
6  // Twitter: https://twitter.com/Zaynixcom 
7  // Facebook: https://www.facebook.com/Zaynix-211347836236170/
8  // Zaynix Website: https://zaynix.com
9  // Zaynix Coin: https://zaynix.com/exchange
10  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
11 contract ZaynixKeyevents {
12     // fired whenever a player registers a name
13     event onNewName
14     (
15         uint256 indexed playerID,
16         address indexed playerAddress,
17         bytes32 indexed playerName,
18         bool isNewPlayer,
19         uint256 affiliateID,
20         address affiliateAddress,
21         bytes32 affiliateName,
22         uint256 amountPaid,
23         uint256 timeStamp
24     );
25 
26     // fired at end of buy or reload
27     event onEndTx
28     (
29         uint256 compressedData,
30         uint256 compressedIDs,
31         bytes32 playerName,
32         address playerAddress,
33         uint256 ethIn,
34         uint256 keysBought,
35         address winnerAddr,
36         bytes32 winnerName,
37         uint256 amountWon,
38         uint256 newPot,
39         uint256 ZaynixKeyAmount,
40         uint256 genAmount,
41         uint256 potAmount
42     );
43 
44     // fired whenever theres a withdraw
45     event onWithdraw
46     (
47         uint256 indexed playerID,
48         address playerAddress,
49         bytes32 playerName,
50         uint256 ethOut,
51         uint256 timeStamp
52     );
53 
54     // fired whenever a withdraw forces end round to be ran
55     event onWithdrawAndDistribute
56     (
57         address playerAddress,
58         bytes32 playerName,
59         uint256 ethOut,
60         uint256 compressedData,
61         uint256 compressedIDs,
62         address winnerAddr,
63         bytes32 winnerName,
64         uint256 amountWon,
65         uint256 newPot,
66         uint256 ZaynixKeyAmount,
67         uint256 genAmount
68     );
69 
70     // fired whenever a player tries a buy after round timer
71     // hit zero, and causes end round to be ran.
72     event onBuyAndDistribute
73     (
74         address playerAddress,
75         bytes32 playerName,
76         uint256 ethIn,
77         uint256 compressedData,
78         uint256 compressedIDs,
79         address winnerAddr,
80         bytes32 winnerName,
81         uint256 amountWon,
82         uint256 newPot,
83         uint256 ZaynixKeyAmount,
84         uint256 genAmount
85     );
86 
87     // fired whenever a player tries a reload after round timer
88     // hit zero, and causes end round to be ran.
89     event onReLoadAndDistribute
90     (
91         address playerAddress,
92         bytes32 playerName,
93         uint256 compressedData,
94         uint256 compressedIDs,
95         address winnerAddr,
96         bytes32 winnerName,
97         uint256 amountWon,
98         uint256 newPot,
99         uint256 ZaynixKeyAmount,
100         uint256 genAmount
101     );
102 
103     // fired whenever an affiliate is paid
104     event onAffiliatePayout
105     (
106         uint256 indexed affiliateID,
107         address affiliateAddress,
108         bytes32 affiliateName,
109         uint256 indexed roundID,
110         uint256 indexed buyerID,
111         uint256 amount,
112         uint256 timeStamp
113     );
114 
115     // received pot swap deposit
116     event onPotSwapDeposit
117     (
118         uint256 roundID,
119         uint256 amountAddedToPot
120     );
121 }
122 
123 //==============================================================================
124 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
125 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
126 //====================================|=========================================
127 
128 contract ZaynixKey is ZaynixKeyevents {
129     using SafeMath for *;
130     using NameFilter for string;
131     using KeysCalc for uint256;
132 
133     PlayerBookInterface private PlayerBook;
134 
135 //==============================================================================
136 //     _ _  _  |`. _     _ _ |_ | _  _  .
137 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
138 //=================_|===========================================================
139     address private admin = msg.sender;
140     address private flushDivs;
141     string constant public name = "ZaynixKey";
142     string constant public symbol = "ZaynixKey";
143     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
144     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
145     uint256 private rndInit_ = 25 hours;                // round timer starts at this
146     uint256 constant private rndInc_ = 300 seconds;              // every full key purchased adds this much to the timer
147     uint256 private rndMax_ = 72 hours;                          // max length a round timer can be
148     uint256[6]  private timerLengths = [30 minutes,60 minutes,120 minutes,360 minutes,720 minutes,1440 minutes];             
149 //==============================================================================
150 //     _| _ _|_ _    _ _ _|_    _   .
151 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
152 //=============================|================================================
153     uint256 public rID_;    // round id number / total rounds that have happened
154 //****************
155 // PLAYER DATA
156 //****************
157     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
158     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
159     mapping (uint256 => ZaynixKeyDatasets.Player) public plyr_;   // (pID => data) player data
160     mapping (uint256 => mapping (uint256 => ZaynixKeyDatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
161     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
162 //****************
163 // ROUND DATA
164 //****************
165     mapping (uint256 => ZaynixKeyDatasets.Round) public round_;   // (rID => data) round data
166     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
167 //****************
168 // TEAM FEE DATA
169 //****************
170     mapping (uint256 => ZaynixKeyDatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
171     mapping (uint256 => ZaynixKeyDatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
172 //==============================================================================
173 //     _ _  _  __|_ _    __|_ _  _  .
174 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
175 //==============================================================================
176     constructor(address whaleContract, address playerbook)
177         public
178     {
179         flushDivs = whaleContract;
180         PlayerBook = PlayerBookInterface(playerbook);
181 
182         //no teams... only ZaynixKey-heads
183         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
184         fees_[0] = ZaynixKeyDatasets.TeamFee(49,10);   //30% to pot, 10% to aff, 1% to dev,
185        
186 
187         potSplit_[0] = ZaynixKeyDatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to dev
188     }
189 //==============================================================================
190 //     _ _  _  _|. |`. _  _ _  .
191 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
192 //==============================================================================
193     /**
194      * @dev used to make sure no one can interact with contract until it has
195      * been activated.
196      */
197     modifier isActivated() {
198         require(activated_ == true);
199         _;
200     }
201 
202     /**
203      * @dev prevents contracts from interacting with fomo3d
204      */
205     modifier isHuman() {
206         address _addr = msg.sender;
207         uint256 _codeLength;
208 
209         assembly {_codeLength := extcodesize(_addr)}
210         require(_codeLength == 0);
211         require(_addr == tx.origin);
212         _;
213     }
214 
215     /**
216      * @dev sets boundaries for incoming tx
217      */
218     modifier isWithinLimits(uint256 _eth) {
219         require(_eth >= 1000000000);
220         require(_eth <= 100000000000000000000000);
221         _;
222     }
223 
224 //==============================================================================
225 //     _    |_ |. _   |`    _  __|_. _  _  _  .
226 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
227 //====|=========================================================================
228     /**
229      * @dev emergency buy uses last stored affiliate ID
230      */
231     function()
232         isActivated()
233         isHuman()
234         isWithinLimits(msg.value)
235         public
236         payable
237     {
238         // set up our tx event data and determine if player is new or not
239         ZaynixKeyDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
240 
241         // fetch player id
242         uint256 _pID = pIDxAddr_[msg.sender];
243 
244         // buy core
245         buyCore(_pID, plyr_[_pID].laff, _eventData_);
246     }
247 
248     /**
249      * @dev converts all incoming ethereum to keys.
250      * -functionhash- 0x8f38f309 (using ID for affiliate)
251      * -functionhash- 0x98a0871d (using address for affiliate)
252      * -functionhash- 0xa65b37a1 (using name for affiliate)
253      * @param _affCode the ID/address/name of the player who gets the affiliate fee
254      */
255     function buyXid(uint256 _affCode)
256         isActivated()
257         isHuman()
258         isWithinLimits(msg.value)
259         public
260         payable
261     {
262         // set up our tx event data and determine if player is new or not
263         ZaynixKeyDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
264 
265         // fetch player id
266         uint256 _pID = pIDxAddr_[msg.sender];
267 
268         // manage affiliate residuals
269         // if no affiliate code was given or player tried to use their own, lolz
270         if (_affCode == 0 || _affCode == _pID)
271         {
272             // use last stored affiliate code
273             _affCode = plyr_[_pID].laff;
274 
275         // if affiliate code was given & its not the same as previously stored
276         } else if (_affCode != plyr_[_pID].laff) {
277             // update last affiliate
278             plyr_[_pID].laff = _affCode;
279         }
280 
281         // buy core
282         buyCore(_pID, _affCode, _eventData_);
283     }
284 
285     function buyXaddr(address _affCode)
286         isActivated()
287         isHuman()
288         isWithinLimits(msg.value)
289         public
290         payable
291     {
292         // set up our tx event data and determine if player is new or not
293         ZaynixKeyDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
294 
295         // fetch player id
296         uint256 _pID = pIDxAddr_[msg.sender];
297 
298         // manage affiliate residuals
299         uint256 _affID;
300         // if no affiliate code was given or player tried to use their own, lolz
301         if (_affCode == address(0) || _affCode == msg.sender)
302         {
303             // use last stored affiliate code
304             _affID = plyr_[_pID].laff;
305 
306         // if affiliate code was given
307         } else {
308             // get affiliate ID from aff Code
309             _affID = pIDxAddr_[_affCode];
310 
311             // if affID is not the same as previously stored
312             if (_affID != plyr_[_pID].laff)
313             {
314                 // update last affiliate
315                 plyr_[_pID].laff = _affID;
316             }
317         }
318         // buy core
319         buyCore(_pID, _affID, _eventData_);
320     }
321 
322     function buyXname(bytes32 _affCode)
323         isActivated()
324         isHuman()
325         isWithinLimits(msg.value)
326         public
327         payable
328     {
329         // set up our tx event data and determine if player is new or not
330         ZaynixKeyDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
331 
332         // fetch player id
333         uint256 _pID = pIDxAddr_[msg.sender];
334 
335         // manage affiliate residuals
336         uint256 _affID;
337         // if no affiliate code was given or player tried to use their own, lolz
338         if (_affCode == '' || _affCode == plyr_[_pID].name)
339         {
340             // use last stored affiliate code
341             _affID = plyr_[_pID].laff;
342 
343         // if affiliate code was given
344         } else {
345             // get affiliate ID from aff Code
346             _affID = pIDxName_[_affCode];
347 
348             // if affID is not the same as previously stored
349             if (_affID != plyr_[_pID].laff)
350             {
351                 // update last affiliate
352                 plyr_[_pID].laff = _affID;
353             }
354         }
355 
356         // buy core
357         buyCore(_pID, _affID, _eventData_);
358     }
359 
360     /**
361      * @dev essentially the same as buy, but instead of you sending ether
362      * from your wallet, it uses your unwithdrawn earnings.
363      * -functionhash- 0x349cdcac (using ID for affiliate)
364      * -functionhash- 0x82bfc739 (using address for affiliate)
365      * -functionhash- 0x079ce327 (using name for affiliate)
366      * @param _affCode the ID/address/name of the player who gets the affiliate fee
367      * @param _eth amount of earnings to use (remainder returned to gen vault)
368      */
369     function reLoadXid(uint256 _affCode, uint256 _eth)
370         isActivated()
371         isHuman()
372         isWithinLimits(_eth)
373         public
374     {
375         // set up our tx event data
376         ZaynixKeyDatasets.EventReturns memory _eventData_;
377 
378         // fetch player ID
379         uint256 _pID = pIDxAddr_[msg.sender];
380 
381         // manage affiliate residuals
382         // if no affiliate code was given or player tried to use their own, lolz
383         if (_affCode == 0 || _affCode == _pID)
384         {
385             // use last stored affiliate code
386             _affCode = plyr_[_pID].laff;
387 
388         // if affiliate code was given & its not the same as previously stored
389         } else if (_affCode != plyr_[_pID].laff) {
390             // update last affiliate
391             plyr_[_pID].laff = _affCode;
392         }
393 
394         // reload core
395         reLoadCore(_pID, _affCode, _eth, _eventData_);
396     }
397 
398     function reLoadXaddr(address _affCode, uint256 _eth)
399         isActivated()
400         isHuman()
401         isWithinLimits(_eth)
402         public
403     {
404         // set up our tx event data
405         ZaynixKeyDatasets.EventReturns memory _eventData_;
406 
407         // fetch player ID
408         uint256 _pID = pIDxAddr_[msg.sender];
409 
410         // manage affiliate residuals
411         uint256 _affID;
412         // if no affiliate code was given or player tried to use their own, lolz
413         if (_affCode == address(0) || _affCode == msg.sender)
414         {
415             // use last stored affiliate code
416             _affID = plyr_[_pID].laff;
417 
418         // if affiliate code was given
419         } else {
420             // get affiliate ID from aff Code
421             _affID = pIDxAddr_[_affCode];
422 
423             // if affID is not the same as previously stored
424             if (_affID != plyr_[_pID].laff)
425             {
426                 // update last affiliate
427                 plyr_[_pID].laff = _affID;
428             }
429         }
430 
431         // reload core
432         reLoadCore(_pID, _affID, _eth, _eventData_);
433     }
434 
435     function reLoadXname(bytes32 _affCode, uint256 _eth)
436         isActivated()
437         isHuman()
438         isWithinLimits(_eth)
439         public
440     {
441         // set up our tx event data
442         ZaynixKeyDatasets.EventReturns memory _eventData_;
443 
444         // fetch player ID
445         uint256 _pID = pIDxAddr_[msg.sender];
446 
447         // manage affiliate residuals
448         uint256 _affID;
449         // if no affiliate code was given or player tried to use their own, lolz
450         if (_affCode == '' || _affCode == plyr_[_pID].name)
451         {
452             // use last stored affiliate code
453             _affID = plyr_[_pID].laff;
454 
455         // if affiliate code was given
456         } else {
457             // get affiliate ID from aff Code
458             _affID = pIDxName_[_affCode];
459 
460             // if affID is not the same as previously stored
461             if (_affID != plyr_[_pID].laff)
462             {
463                 // update last affiliate
464                 plyr_[_pID].laff = _affID;
465             }
466         }
467 
468         // reload core
469         reLoadCore(_pID, _affID, _eth, _eventData_);
470     }
471 
472     /**
473      * @dev withdraws all of your earnings.
474      * -functionhash- 0x3ccfd60b
475      */
476     function withdraw()
477         isActivated()
478         isHuman()
479         public
480     {
481         // setup local rID
482         uint256 _rID = rID_;
483 
484         // grab time
485         uint256 _now = now;
486 
487         // fetch player ID
488         uint256 _pID = pIDxAddr_[msg.sender];
489 
490         // setup temp var for player eth
491         uint256 _eth;
492 
493         // check to see if round has ended and no one has run round end yet
494         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
495         {
496             // set up our tx event data
497             ZaynixKeyDatasets.EventReturns memory _eventData_;
498 
499             // end the round (distributes pot)
500             round_[_rID].ended = true;
501             _eventData_ = endRound(_eventData_);
502 
503             // get their earnings
504             _eth = withdrawEarnings(_pID);
505 
506             // gib moni
507             if (_eth > 0)
508                 plyr_[_pID].addr.transfer(_eth);
509 
510             // build event data
511             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
512             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
513 
514             // fire withdraw and distribute event
515             emit ZaynixKeyevents.onWithdrawAndDistribute
516             (
517                 msg.sender,
518                 plyr_[_pID].name,
519                 _eth,
520                 _eventData_.compressedData,
521                 _eventData_.compressedIDs,
522                 _eventData_.winnerAddr,
523                 _eventData_.winnerName,
524                 _eventData_.amountWon,
525                 _eventData_.newPot,
526                 _eventData_.ZaynixKeyAmount,
527                 _eventData_.genAmount
528             );
529 
530         // in any other situation
531         } else {
532             // get their earnings
533             _eth = withdrawEarnings(_pID);
534 
535             // gib moni
536             if (_eth > 0)
537                 plyr_[_pID].addr.transfer(_eth);
538 
539             // fire withdraw event
540             emit ZaynixKeyevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
541         }
542     }
543 
544     /**
545      * @dev use these to register names.  they are just wrappers that will send the
546      * registration requests to the PlayerBook contract.  So registering here is the
547      * same as registering there.  UI will always display the last name you registered.
548      * but you will still own all previously registered names to use as affiliate
549      * links.
550      * - must pay a registration fee.
551      * - name must be unique
552      * - names will be converted to lowercase
553      * - name cannot start or end with a space
554      * - cannot have more than 1 space in a row
555      * - cannot be only numbers
556      * - cannot start with 0x
557      * - name must be at least 1 char
558      * - max length of 32 characters long
559      * - allowed characters: a-z, 0-9, and space
560      * -functionhash- 0x921dec21 (using ID for affiliate)
561      * -functionhash- 0x3ddd4698 (using address for affiliate)
562      * -functionhash- 0x685ffd83 (using name for affiliate)
563      * @param _nameString players desired name
564      * @param _affCode affiliate ID, address, or name of who referred you
565      * @param _all set to true if you want this to push your info to all games
566      * (this might cost a lot of gas)
567      */
568     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
569         isHuman()
570         public
571         payable
572     {
573         bytes32 _name = _nameString.nameFilter();
574         address _addr = msg.sender;
575         uint256 _paid = msg.value;
576         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
577 
578         uint256 _pID = pIDxAddr_[_addr];
579 
580         // fire event
581         emit ZaynixKeyevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
582     }
583 
584     function registerNameXaddr(string _nameString, address _affCode, bool _all)
585         isHuman()
586         public
587         payable
588     {
589         bytes32 _name = _nameString.nameFilter();
590         address _addr = msg.sender;
591         uint256 _paid = msg.value;
592         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
593 
594         uint256 _pID = pIDxAddr_[_addr];
595 
596         // fire event
597         emit ZaynixKeyevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
598     }
599 
600     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
601         isHuman()
602         public
603         payable
604     {
605         bytes32 _name = _nameString.nameFilter();
606         address _addr = msg.sender;
607         uint256 _paid = msg.value;
608         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
609 
610         uint256 _pID = pIDxAddr_[_addr];
611 
612         // fire event
613         emit ZaynixKeyevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
614     }
615 //==============================================================================
616 //     _  _ _|__|_ _  _ _  .
617 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
618 //=====_|=======================================================================
619     /**
620      * @dev return the price buyer will pay for next 1 individual key.
621      * -functionhash- 0x018a25e8
622      * @return price for next key bought (in wei format)
623      */
624     function getBuyPrice()
625         public
626         view
627         returns(uint256)
628     {
629         // setup local rID
630         uint256 _rID = rID_;
631 
632         // grab time
633         uint256 _now = now;
634 
635         // are we in a round?
636         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
637             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
638         else // rounds over.  need price for new round
639             return ( 75000000000000 ); // init
640     }
641 
642     /**
643      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
644      * provider
645      * -functionhash- 0xc7e284b8
646      * @return time left in seconds
647      */
648     function getTimeLeft()
649         public
650         view
651         returns(uint256)
652     {
653         // setup local rID
654         uint256 _rID = rID_;
655 
656         // grab time
657         uint256 _now = now;
658 
659         if (_now < round_[_rID].end)
660             if (_now > round_[_rID].strt + rndGap_)
661                 return( (round_[_rID].end).sub(_now) );
662             else
663                 return( (round_[_rID].strt + rndGap_).sub(_now) );
664         else
665             return(0);
666     }
667 
668     /**
669      * @dev returns player earnings per vaults
670      * -functionhash- 0x63066434
671      * @return winnings vault
672      * @return general vault
673      * @return affiliate vault
674      */
675     function getPlayerVaults(uint256 _pID)
676         public
677         view
678         returns(uint256 ,uint256, uint256)
679     {
680         // setup local rID
681         uint256 _rID = rID_;
682 
683         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
684         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
685         {
686             // if player is winner
687             if (round_[_rID].plyr == _pID)
688             {
689                 return
690                 (
691                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
692                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
693                     plyr_[_pID].aff
694                 );
695             // if player is not the winner
696             } else {
697                 return
698                 (
699                     plyr_[_pID].win,
700                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
701                     plyr_[_pID].aff
702                 );
703             }
704 
705         // if round is still going on, or round has ended and round end has been ran
706         } else {
707             return
708             (
709                 plyr_[_pID].win,
710                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
711                 plyr_[_pID].aff
712             );
713         }
714     }
715 
716     /**
717      * solidity hates stack limits.  this lets us avoid that hate
718      */
719     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
720         private
721         view
722         returns(uint256)
723     {
724         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
725     }
726 
727     /**
728      * @dev returns all current round info needed for front end
729      * -functionhash- 0x747dff42
730      * @return eth invested during ICO phase
731      * @return round id
732      * @return total keys for round
733      * @return time round ends
734      * @return time round started
735      * @return current pot
736      * @return current team ID & player ID in lead
737      * @return current player in leads address
738      * @return current player in leads name
739      * @return whales eth in for round
740      * @return bears eth in for round
741      * @return sneks eth in for round
742      * @return bulls eth in for round
743      */
744     function getCurrentRoundInfo()
745         public
746         view
747         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
748     {
749         // setup local rID
750         uint256 _rID = rID_;
751 
752         return
753         (
754             round_[_rID].ico,               //0
755             _rID,                           //1
756             round_[_rID].keys,              //2
757             round_[_rID].end,               //3
758             round_[_rID].strt,              //4
759             round_[_rID].pot,               //5
760             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
761             plyr_[round_[_rID].plyr].addr,  //7
762             plyr_[round_[_rID].plyr].name,  //8
763             rndTmEth_[_rID][0],             //9
764             rndTmEth_[_rID][1],             //10
765             rndTmEth_[_rID][2],             //11
766             rndTmEth_[_rID][3]              //12
767           
768         );
769     }
770 
771     /**
772      * @dev returns player info based on address.  if no address is given, it will
773      * use msg.sender
774      * -functionhash- 0xee0b5d8b
775      * @param _addr address of the player you want to lookup
776      * @return player ID
777      * @return player name
778      * @return keys owned (current round)
779      * @return winnings vault
780      * @return general vault
781      * @return affiliate vault
782      * @return player round eth
783      */
784     function getPlayerInfoByAddress(address _addr)
785         public
786         view
787         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
788     {
789         // setup local rID
790         uint256 _rID = rID_;
791 
792         if (_addr == address(0))
793         {
794             _addr == msg.sender;
795         }
796         uint256 _pID = pIDxAddr_[_addr];
797 
798         return
799         (
800             _pID,                               //0
801             plyr_[_pID].name,                   //1
802             plyrRnds_[_pID][_rID].keys,         //2
803             plyr_[_pID].win,                    //3
804             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
805             plyr_[_pID].aff,                    //5
806             plyrRnds_[_pID][_rID].eth           //6
807         );
808     }
809 
810 //==============================================================================
811 //     _ _  _ _   | _  _ . _  .
812 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
813 //=====================_|=======================================================
814     /**
815      * @dev logic runs whenever a buy order is executed.  determines how to handle
816      * incoming eth depending on if we are in an active round or not
817      */
818     function buyCore(uint256 _pID, uint256 _affID, ZaynixKeyDatasets.EventReturns memory _eventData_)
819         private
820     {
821         // setup local rID
822         uint256 _rID = rID_;
823 
824         // grab time
825         uint256 _now = now;
826 
827         // if round is active
828         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
829         {
830             // call core
831             core(_rID, _pID, msg.value, _affID, 0, _eventData_);
832 
833         // if round is not active
834         } else {
835             // check to see if end round needs to be ran
836             if (_now > round_[_rID].end && round_[_rID].ended == false)
837             {
838                 // end the round (distributes pot) & start new round
839                 round_[_rID].ended = true;
840                 _eventData_ = endRound(_eventData_);
841 
842                 // build event data
843                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
844                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
845 
846                 // fire buy and distribute event
847                 emit ZaynixKeyevents.onBuyAndDistribute
848                 (
849                     msg.sender,
850                     plyr_[_pID].name,
851                     msg.value,
852                     _eventData_.compressedData,
853                     _eventData_.compressedIDs,
854                     _eventData_.winnerAddr,
855                     _eventData_.winnerName,
856                     _eventData_.amountWon,
857                     _eventData_.newPot,
858                     _eventData_.ZaynixKeyAmount,
859                     _eventData_.genAmount
860                 );
861             }
862 
863             // put eth in players vault
864             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
865         }
866     }
867 
868     /**
869      * @dev logic runs whenever a reload order is executed.  determines how to handle
870      * incoming eth depending on if we are in an active round or not
871      */
872     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, ZaynixKeyDatasets.EventReturns memory _eventData_)
873         private
874     {
875         // setup local rID
876         uint256 _rID = rID_;
877 
878         // grab time
879         uint256 _now = now;
880 
881         // if round is active
882         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
883         {
884             // get earnings from all vaults and return unused to gen vault
885             // because we use a custom safemath library.  this will throw if player
886             // tried to spend more eth than they have.
887             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
888 
889             // call core
890             core(_rID, _pID, _eth, _affID, 0, _eventData_);
891 
892         // if round is not active and end round needs to be ran
893         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
894             // end the round (distributes pot) & start new round
895             round_[_rID].ended = true;
896             _eventData_ = endRound(_eventData_);
897 
898             // build event data
899             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
900             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
901 
902             // fire buy and distribute event
903             emit ZaynixKeyevents.onReLoadAndDistribute
904             (
905                 msg.sender,
906                 plyr_[_pID].name,
907                 _eventData_.compressedData,
908                 _eventData_.compressedIDs,
909                 _eventData_.winnerAddr,
910                 _eventData_.winnerName,
911                 _eventData_.amountWon,
912                 _eventData_.newPot,
913                 _eventData_.ZaynixKeyAmount,
914                 _eventData_.genAmount
915             );
916         }
917     }
918 
919     /**
920      * @dev this is the core logic for any buy/reload that happens while a round
921      * is live.
922      */
923     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, ZaynixKeyDatasets.EventReturns memory _eventData_)
924         private
925     {
926         // if player is new to round
927         if (plyrRnds_[_pID][_rID].keys == 0)
928             _eventData_ = managePlayer(_pID, _eventData_);
929 
930         // early round eth limiter
931         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000)
932         {
933             uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
934             uint256 _refund = _eth.sub(_availableLimit);
935             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
936             _eth = _availableLimit;
937         }
938 
939         // if eth left is greater than min eth allowed (sorry no pocket lint)
940         if (_eth > 1000000000)
941         {
942 
943             // mint the new keys
944             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
945 
946             // if they bought at least 1 whole key
947             if (_keys >= 1000000000000000000)
948             {
949             updateTimer(_keys, _rID);
950 
951             // set new leaders
952             if (round_[_rID].plyr != _pID)
953                 round_[_rID].plyr = _pID;
954             if (round_[_rID].team != _team)
955                 round_[_rID].team = _team;
956 
957             // set the new leader bool to true
958             _eventData_.compressedData = _eventData_.compressedData + 100;
959         }
960 
961             // update player
962             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
963             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
964 
965             // update round
966             round_[_rID].keys = _keys.add(round_[_rID].keys);
967             round_[_rID].eth = _eth.add(round_[_rID].eth);
968             rndTmEth_[_rID][0] = _eth.add(rndTmEth_[_rID][0]);
969 
970             // distribute eth
971             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 0, _eventData_);
972             _eventData_ = distributeInternal(_rID, _pID, _eth, 0, _keys, _eventData_);
973 
974             // call end tx function to fire end tx event.
975             endTx(_pID, 0, _eth, _keys, _eventData_);
976         }
977     }
978 //==============================================================================
979 //     _ _ | _   | _ _|_ _  _ _  .
980 //    (_(_||(_|_||(_| | (_)| _\  .
981 //==============================================================================
982     /**
983      * @dev calculates unmasked earnings (just calculates, does not update mask)
984      * @return earnings in wei format
985      */
986     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
987         private
988         view
989         returns(uint256)
990     {
991         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
992     }
993 
994     /**
995      * @dev returns the amount of keys you would get given an amount of eth.
996      * -functionhash- 0xce89c80c
997      * @param _rID round ID you want price for
998      * @param _eth amount of eth sent in
999      * @return keys received
1000      */
1001     function calcKeysReceived(uint256 _rID, uint256 _eth)
1002         public
1003         view
1004         returns(uint256)
1005     {
1006         // grab time
1007         uint256 _now = now;
1008 
1009         // are we in a round?
1010         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1011             return ( (round_[_rID].eth).keysRec(_eth) );
1012         else // rounds over.  need keys for new round
1013             return ( (_eth).keys() );
1014     }
1015 
1016     /**
1017      * @dev returns current eth price for X keys.
1018      * -functionhash- 0xcf808000
1019      * @param _keys number of keys desired (in 18 decimal format)
1020      * @return amount of eth needed to send
1021      */
1022     function iWantXKeys(uint256 _keys)
1023         public
1024         view
1025         returns(uint256)
1026     {
1027         // setup local rID
1028         uint256 _rID = rID_;
1029 
1030         // grab time
1031         uint256 _now = now;
1032 
1033         // are we in a round?
1034         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1035             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1036         else // rounds over.  need price for new round
1037             return ( (_keys).eth() );
1038     }
1039 //==============================================================================
1040 //    _|_ _  _ | _  .
1041 //     | (_)(_)|_\  .
1042 //==============================================================================
1043     /**
1044      * @dev receives name/player info from names contract
1045      */
1046     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1047         external
1048     {
1049         require (msg.sender == address(PlayerBook));
1050         if (pIDxAddr_[_addr] != _pID)
1051             pIDxAddr_[_addr] = _pID;
1052         if (pIDxName_[_name] != _pID)
1053             pIDxName_[_name] = _pID;
1054         if (plyr_[_pID].addr != _addr)
1055             plyr_[_pID].addr = _addr;
1056         if (plyr_[_pID].name != _name)
1057             plyr_[_pID].name = _name;
1058         if (plyr_[_pID].laff != _laff)
1059             plyr_[_pID].laff = _laff;
1060         if (plyrNames_[_pID][_name] == false)
1061             plyrNames_[_pID][_name] = true;
1062     }
1063 
1064     /**
1065      * @dev receives entire player name list
1066      */
1067     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1068         external
1069     {
1070         require (msg.sender == address(PlayerBook));
1071         if(plyrNames_[_pID][_name] == false)
1072             plyrNames_[_pID][_name] = true;
1073     }
1074 
1075     /**
1076      * @dev gets existing or registers new pID.  use this when a player may be new
1077      * @return pID
1078      */
1079     function determinePID(ZaynixKeyDatasets.EventReturns memory _eventData_)
1080         private
1081         returns (ZaynixKeyDatasets.EventReturns)
1082     {
1083         uint256 _pID = pIDxAddr_[msg.sender];
1084         // if player is new to this version of fomo3d
1085         if (_pID == 0)
1086         {
1087             // grab their player ID, name and last aff ID, from player names contract
1088             _pID = PlayerBook.getPlayerID(msg.sender);
1089             bytes32 _name = PlayerBook.getPlayerName(_pID);
1090             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1091 
1092             // set up player account
1093             pIDxAddr_[msg.sender] = _pID;
1094             plyr_[_pID].addr = msg.sender;
1095 
1096             if (_name != "")
1097             {
1098                 pIDxName_[_name] = _pID;
1099                 plyr_[_pID].name = _name;
1100                 plyrNames_[_pID][_name] = true;
1101             }
1102 
1103             if (_laff != 0 && _laff != _pID)
1104                 plyr_[_pID].laff = _laff;
1105 
1106             // set the new player bool to true
1107             _eventData_.compressedData = _eventData_.compressedData + 1;
1108         }
1109         return (_eventData_);
1110     }
1111 
1112     
1113 
1114     /**
1115      * @dev decides if round end needs to be run & new round started.  and if
1116      * player unmasked earnings from previously played rounds need to be moved.
1117      */
1118     function managePlayer(uint256 _pID, ZaynixKeyDatasets.EventReturns memory _eventData_)
1119         private
1120         returns (ZaynixKeyDatasets.EventReturns)
1121     {
1122         // if player has played a previous round, move their unmasked earnings
1123         // from that round to gen vault.
1124         if (plyr_[_pID].lrnd != 0)
1125             updateGenVault(_pID, plyr_[_pID].lrnd);
1126 
1127         // update player's last round played
1128         plyr_[_pID].lrnd = rID_;
1129 
1130         // set the joined round bool to true
1131         _eventData_.compressedData = _eventData_.compressedData + 10;
1132 
1133         return(_eventData_);
1134     }
1135 
1136     /**
1137      * @dev ends the round. manages paying out winner/splitting up pot
1138      */
1139     function endRound(ZaynixKeyDatasets.EventReturns memory _eventData_)
1140         private
1141         returns (ZaynixKeyDatasets.EventReturns)
1142     {
1143         // setup local rID
1144         uint256 _rID = rID_;
1145 
1146         // grab our winning player and team id's
1147         uint256 _winPID = round_[_rID].plyr;
1148         uint256 _winTID = round_[_rID].team;
1149 
1150         // grab our pot amount
1151         uint256 _pot = round_[_rID].pot;
1152 
1153         // calculate our winner share, community rewards, gen share,
1154         // p3d share, and amount reserved for next pot
1155         uint256 _win = (_pot.mul(48)) / 100;   //48%
1156         uint256 _dev = (_pot / 50);            //2%
1157         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; //15
1158         uint256 _ZaynixKey = (_pot.mul(potSplit_[_winTID].ZaynixKey)) / 100; // 10
1159         uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_ZaynixKey); //25
1160 
1161         // calculate ppt for round mask
1162         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1163         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1164         if (_dust > 0)
1165         {
1166             _gen = _gen.sub(_dust);
1167             _res = _res.add(_dust);
1168         }
1169 
1170         // pay our winner
1171         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1172 
1173         // community rewards
1174 
1175         admin.transfer(_dev);
1176 
1177         flushDivs.call.value(_ZaynixKey)(bytes4(keccak256("donate()")));  
1178 
1179         // distribute gen portion to key holders
1180         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1181 
1182         // prepare event data
1183         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1184         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1185         _eventData_.winnerAddr = plyr_[_winPID].addr;
1186         _eventData_.winnerName = plyr_[_winPID].name;
1187         _eventData_.amountWon = _win;
1188         _eventData_.genAmount = _gen;
1189         _eventData_.ZaynixKeyAmount = _ZaynixKey;
1190         _eventData_.newPot = _res;
1191 
1192         // start next round
1193         rID_++;
1194         _rID++;
1195         round_[_rID].strt = now;
1196         rndMax_ = timerLengths[determineNextRoundLength()];
1197         round_[_rID].end = now.add(rndMax_);
1198         round_[_rID].pot = _res;
1199 
1200         return(_eventData_);
1201     }
1202 
1203     function determineNextRoundLength() internal view returns(uint256 time) 
1204     {
1205         uint256 roundTime = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1)))) % 6;
1206         return roundTime;
1207     }
1208     
1209 
1210     /**
1211      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1212      */
1213     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1214         private
1215     {
1216         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1217         if (_earnings > 0)
1218         {
1219             // put in gen vault
1220             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1221             // zero out their earnings by updating mask
1222             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1223         }
1224     }
1225 
1226     /**
1227      * @dev updates round timer based on number of whole keys bought.
1228      */
1229     function updateTimer(uint256 _keys, uint256 _rID)
1230         private
1231     {
1232         // grab time
1233         uint256 _now = now;
1234 
1235         // calculate time based on number of keys bought
1236         uint256 _newTime;
1237         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1238             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1239         else
1240             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1241 
1242         // compare to max and set new end time
1243         if (_newTime < (rndMax_).add(_now))
1244             round_[_rID].end = _newTime;
1245         else
1246             round_[_rID].end = rndMax_.add(_now);
1247     }
1248 
1249    
1250     /**
1251      * @dev distributes eth based on fees to com, aff, and ZaynixKey
1252      */
1253     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, ZaynixKeyDatasets.EventReturns memory _eventData_)
1254         private
1255         returns(ZaynixKeyDatasets.EventReturns)
1256     {
1257         // pay 1% out to dev
1258         uint256 _dev = _eth / 100;  // 1%
1259 
1260         uint256 _ZaynixKey = 0;
1261         if (!address(admin).call.value(_dev)())
1262         {
1263             _ZaynixKey = _dev;
1264             _dev = 0;
1265         }
1266 
1267 
1268         // distribute share to affiliate
1269         uint256 _aff = _eth / 10;
1270 
1271         // decide what to do with affiliate share of fees
1272         // affiliate must not be self, and must have a name registered
1273         if (_affID != _pID && plyr_[_affID].name != '') {
1274             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1275             emit ZaynixKeyevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1276         } else {
1277             _ZaynixKey = _ZaynixKey.add(_aff);
1278         }
1279 
1280         // pay out ZaynixKey
1281         _ZaynixKey = _ZaynixKey.add((_eth.mul(fees_[_team].ZaynixKey)) / (100));
1282         if (_ZaynixKey > 0)
1283         {
1284             // deposit to divies contract
1285             //uint256 _potAmount = _ZaynixKey / 2;
1286 
1287             flushDivs.call.value(_ZaynixKey)(bytes4(keccak256("donate()")));
1288 
1289             //round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1290 
1291             // set up event data
1292             _eventData_.ZaynixKeyAmount = _ZaynixKey.add(_eventData_.ZaynixKeyAmount);
1293         }
1294 
1295         return(_eventData_);
1296     }
1297 
1298     function potSwap()
1299         external
1300         payable
1301     {
1302        //you shouldn't be using this method
1303        admin.transfer(msg.value);
1304     }
1305 
1306     /**
1307      * @dev distributes eth based on fees to gen and pot
1308      */
1309     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, ZaynixKeyDatasets.EventReturns memory _eventData_)
1310         private
1311         returns(ZaynixKeyDatasets.EventReturns)
1312     {
1313         // calculate gen share
1314         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1315 
1316 
1317         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1318         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].ZaynixKey)) / 100));
1319 
1320         // calculate pot
1321         uint256 _pot = _eth.sub(_gen);
1322 
1323         // distribute gen share (thats what updateMasks() does) and adjust
1324         // balances for dust.
1325         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1326         if (_dust > 0)
1327             _gen = _gen.sub(_dust);
1328 
1329         // add eth to pot
1330         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1331 
1332         // set up event data
1333         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1334         _eventData_.potAmount = _pot;
1335 
1336         return(_eventData_);
1337     }
1338 
1339     /**
1340      * @dev updates masks for round and player when keys are bought
1341      * @return dust left over
1342      */
1343     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1344         private
1345         returns(uint256)
1346     {
1347         /* MASKING NOTES
1348             earnings masks are a tricky thing for people to wrap their minds around.
1349             the basic thing to understand here.  is were going to have a global
1350             tracker based on profit per share for each round, that increases in
1351             relevant proportion to the increase in share supply.
1352 
1353             the player will have an additional mask that basically says "based
1354             on the rounds mask, my shares, and how much i've already withdrawn,
1355             how much is still owed to me?"
1356         */
1357 
1358         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1359         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1360         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1361 
1362         // calculate player earning from their own buy (only based on the keys
1363         // they just bought).  & update player earnings mask
1364         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1365         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1366 
1367         // calculate & return dust
1368         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1369     }
1370 
1371     /**
1372      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1373      * @return earnings in wei format
1374      */
1375     function withdrawEarnings(uint256 _pID)
1376         private
1377         returns(uint256)
1378     {
1379         // update gen vault
1380         updateGenVault(_pID, plyr_[_pID].lrnd);
1381 
1382         // from vaults
1383         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1384         if (_earnings > 0)
1385         {
1386             plyr_[_pID].win = 0;
1387             plyr_[_pID].gen = 0;
1388             plyr_[_pID].aff = 0;
1389         }
1390 
1391         return(_earnings);
1392     }
1393 
1394     /**
1395      * @dev prepares compression data and fires event for buy or reload tx's
1396      */
1397     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, ZaynixKeyDatasets.EventReturns memory _eventData_)
1398         private
1399     {
1400         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1401         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1402 
1403         emit ZaynixKeyevents.onEndTx
1404         (
1405             _eventData_.compressedData,
1406             _eventData_.compressedIDs,
1407             plyr_[_pID].name,
1408             msg.sender,
1409             _eth,
1410             _keys,
1411             _eventData_.winnerAddr,
1412             _eventData_.winnerName,
1413             _eventData_.amountWon,
1414             _eventData_.newPot,
1415             _eventData_.ZaynixKeyAmount,
1416             _eventData_.genAmount,
1417             _eventData_.potAmount
1418         );
1419     }
1420 //==============================================================================
1421 //    (~ _  _    _._|_    .
1422 //    _)(/_(_|_|| | | \/  .
1423 //====================/=========================================================
1424     /** upon contract deploy, it will be deactivated.  this is a one time
1425      * use function that will activate the contract.  we do this so devs
1426      * have time to set things up on the web end                            **/
1427     bool public activated_ = false;
1428     function activate()
1429         public
1430     {
1431         // only team just can activate
1432         require(msg.sender == admin);
1433 
1434 
1435         // can only be ran once
1436         require(activated_ == false);
1437 
1438         // activate the contract
1439         activated_ = true;
1440 
1441         // lets start first round
1442         rID_ = 1;
1443             round_[1].strt = now + rndExtra_ - rndGap_;
1444             round_[1].end = now + rndInit_ + rndExtra_;
1445     }
1446 }
1447 
1448 //==============================================================================
1449 //   __|_ _    __|_ _  .
1450 //  _\ | | |_|(_ | _\  .
1451 //==============================================================================
1452 library ZaynixKeyDatasets {
1453     
1454     struct EventReturns {
1455         uint256 compressedData;
1456         uint256 compressedIDs;
1457         address winnerAddr;         // winner address
1458         bytes32 winnerName;         // winner name
1459         uint256 amountWon;          // amount won
1460         uint256 newPot;             // amount in new pot
1461         uint256 ZaynixKeyAmount;          // amount distributed to p3d
1462         uint256 genAmount;          // amount distributed to gen
1463         uint256 potAmount;          // amount added to pot
1464     }
1465     struct Player {
1466         address addr;   // player address
1467         bytes32 name;   // player name
1468         uint256 win;    // winnings vault
1469         uint256 gen;    // general vault
1470         uint256 aff;    // affiliate vault
1471         uint256 lrnd;   // last round played
1472         uint256 laff;   // last affiliate id used
1473     }
1474     struct PlayerRounds {
1475         uint256 eth;    // eth player has added to round (used for eth limiter)
1476         uint256 keys;   // keys
1477         uint256 mask;   // player mask
1478         uint256 ico;    // ICO phase investment
1479     }
1480     struct Round {
1481         uint256 plyr;   // pID of player in lead
1482         uint256 team;   // tID of team in lead
1483         uint256 end;    // time ends/ended
1484         bool ended;     // has round end function been ran
1485         uint256 strt;   // time round started
1486         uint256 keys;   // keys
1487         uint256 eth;    // total eth in
1488         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1489         uint256 mask;   // global mask
1490         uint256 ico;    // total eth sent in during ICO phase
1491         uint256 icoGen; // total eth for gen during ICO phase
1492         uint256 icoAvg; // average key price for ICO phase
1493     }
1494     struct TeamFee {
1495         uint256 gen;    // % of buy in thats paid to key holders of current round
1496         uint256 ZaynixKey;    // % of buy in thats paid to ZaynixKey holders
1497     }
1498     struct PotSplit {
1499         uint256 gen;    // % of pot thats paid to key holders of current round
1500         uint256 ZaynixKey;    // % of pot thats paid to ZaynixKey holders
1501     }
1502 }
1503 
1504 //==============================================================================
1505 //  |  _      _ _ | _  .
1506 //  |<(/_\/  (_(_||(_  .
1507 //=======/======================================================================
1508 library KeysCalc {
1509     using SafeMath for *;
1510     /**
1511      * @dev calculates number of keys received given X eth
1512      * @param _curEth current amount of eth in contract
1513      * @param _newEth eth being spent
1514      * @return amount of ticket purchased
1515      */
1516     function keysRec(uint256 _curEth, uint256 _newEth)
1517         internal
1518         pure
1519         returns (uint256)
1520     {
1521         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1522     }
1523 
1524     /**
1525      * @dev calculates amount of eth received if you sold X keys
1526      * @param _curKeys current amount of keys that exist
1527      * @param _sellKeys amount of keys you wish to sell
1528      * @return amount of eth received
1529      */
1530     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1531         internal
1532         pure
1533         returns (uint256)
1534     {
1535         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1536     }
1537 
1538     /**
1539      * @dev calculates how many keys would exist with given an amount of eth
1540      * @param _eth eth "in contract"
1541      * @return number of keys that would exist
1542      */
1543     function keys(uint256 _eth)
1544         internal
1545         pure
1546         returns(uint256)
1547     {
1548         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1549     }
1550 
1551     /**
1552      * @dev calculates how much eth would be in contract given a number of keys
1553      * @param _keys number of keys "in contract"
1554      * @return eth that would exists
1555      */
1556     function eth(uint256 _keys)
1557         internal
1558         pure
1559         returns(uint256)
1560     {
1561         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1562     }
1563 }
1564 
1565 //==============================================================================
1566 //  . _ _|_ _  _ |` _  _ _  _  .
1567 //  || | | (/_| ~|~(_|(_(/__\  .
1568 //==============================================================================
1569 
1570 interface PlayerBookInterface {
1571     function getPlayerID(address _addr) external returns (uint256);
1572     function getPlayerName(uint256 _pID) external view returns (bytes32);
1573     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1574     function getPlayerAddr(uint256 _pID) external view returns (address);
1575     function getNameFee() external view returns (uint256);
1576     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1577     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1578     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1579 }
1580 
1581 
1582 library NameFilter {
1583     /**
1584      * @dev filters name strings
1585      * -converts uppercase to lower case.
1586      * -makes sure it does not start/end with a space
1587      * -makes sure it does not contain multiple spaces in a row
1588      * -cannot be only numbers
1589      * -cannot start with 0x
1590      * -restricts characters to A-Z, a-z, 0-9, and space.
1591      * @return reprocessed string in bytes32 format
1592      */
1593     function nameFilter(string _input)
1594         internal
1595         pure
1596         returns(bytes32)
1597     {
1598         bytes memory _temp = bytes(_input);
1599         uint256 _length = _temp.length;
1600 
1601         //sorry limited to 32 characters
1602         require (_length <= 32 && _length > 0);
1603         // make sure it doesnt start with or end with space
1604         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
1605         // make sure first two characters are not 0x
1606         if (_temp[0] == 0x30)
1607         {
1608             require(_temp[1] != 0x78);
1609             require(_temp[1] != 0x58);
1610         }
1611 
1612         // create a bool to track if we have a non number character
1613         bool _hasNonNumber;
1614 
1615         // convert & check
1616         for (uint256 i = 0; i < _length; i++)
1617         {
1618             // if its uppercase A-Z
1619             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1620             {
1621                 // convert to lower case a-z
1622                 _temp[i] = byte(uint(_temp[i]) + 32);
1623 
1624                 // we have a non number
1625                 if (_hasNonNumber == false)
1626                     _hasNonNumber = true;
1627             } else {
1628                 require
1629                 (
1630                     // require character is a space
1631                     _temp[i] == 0x20 ||
1632                     // OR lowercase a-z
1633                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1634                     // or 0-9
1635                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
1636                 // make sure theres not 2x spaces in a row
1637                 if (_temp[i] == 0x20)
1638                     require( _temp[i+1] != 0x20);
1639 
1640                 // see if we have a character other than a number
1641                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1642                     _hasNonNumber = true;
1643             }
1644         }
1645 
1646         require(_hasNonNumber == true);
1647 
1648         bytes32 _ret;
1649         assembly {
1650             _ret := mload(add(_temp, 32))
1651         }
1652         return (_ret);
1653     }
1654 }
1655 
1656 /**
1657  * @title SafeMath v0.1.9
1658  * @dev Math operations with safety checks that throw on error
1659  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1660  * - added sqrt
1661  * - added sq
1662  * - added pwr
1663  * - changed asserts to requires with error log outputs
1664  * - removed div, its useless
1665  */
1666 library SafeMath {
1667 
1668     /**
1669     * @dev Multiplies two numbers, throws on overflow.
1670     */
1671     function mul(uint256 a, uint256 b)
1672         internal
1673         pure
1674         returns (uint256 c)
1675     {
1676         if (a == 0) {
1677             return 0;
1678         }
1679         c = a * b;
1680         require(c / a == b, "SafeMath mul failed");
1681         return c;
1682     }
1683 
1684     /**
1685     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1686     */
1687     function sub(uint256 a, uint256 b)
1688         internal
1689         pure
1690         returns (uint256)
1691     {
1692         require(b <= a, "SafeMath sub failed");
1693         return a - b;
1694     }
1695 
1696     /**
1697     * @dev Adds two numbers, throws on overflow.
1698     */
1699     function add(uint256 a, uint256 b)
1700         internal
1701         pure
1702         returns (uint256 c)
1703     {
1704         c = a + b;
1705         require(c >= a, "SafeMath add failed");
1706         return c;
1707     }
1708 
1709     /**
1710      * @dev gives square root of given x.
1711      */
1712     function sqrt(uint256 x)
1713         internal
1714         pure
1715         returns (uint256 y)
1716     {
1717         uint256 z = ((add(x,1)) / 2);
1718         y = x;
1719         while (z < y)
1720         {
1721             y = z;
1722             z = ((add((x / z),z)) / 2);
1723         }
1724     }
1725 
1726     /**
1727      * @dev gives square. multiplies x by x
1728      */
1729     function sq(uint256 x)
1730         internal
1731         pure
1732         returns (uint256)
1733     {
1734         return (mul(x,x));
1735     }
1736 
1737     /**
1738      * @dev x to the power of y
1739      */
1740     function pwr(uint256 x, uint256 y)
1741         internal
1742         pure
1743         returns (uint256)
1744     {
1745         if (x==0)
1746             return (0);
1747         else if (y==0)
1748             return (1);
1749         else
1750         {
1751             uint256 z = x;
1752             for (uint256 i=1; i < y; i++)
1753                 z = mul(z,x);
1754             return (z);
1755         }
1756     }
1757 }