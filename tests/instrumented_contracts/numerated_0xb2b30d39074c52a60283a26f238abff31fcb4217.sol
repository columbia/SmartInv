1 pragma solidity ^0.4.24;
2 
3 // Is needed to call functions in the Snow contract.
4 contract Snow {
5     function buy(address) public payable returns(uint256);
6     function withdraw() public;
7     function redistribution() external payable;
8     function myTokens() public view returns(uint256);
9     function myDividends(bool) public view returns(uint256);
10 }
11 
12 
13 contract F3Devents {
14     // fired whenever a player registers a name
15     event onNewName
16     (
17         uint256 indexed playerID,
18         address indexed playerAddress,
19         bytes32 indexed playerName,
20         bool isNewPlayer,
21         uint256 affiliateID,
22         address affiliateAddress,
23         bytes32 affiliateName,
24         uint256 amountPaid,
25         uint256 timeStamp
26     );
27 
28     // fired at end of buy or reload
29     event onEndTx
30     (
31         uint256 compressedData,
32         uint256 compressedIDs,
33         bytes32 playerName,
34         address playerAddress,
35         uint256 ethIn,
36         uint256 keysBought,
37         address winnerAddr,
38         bytes32 winnerName,
39         uint256 amountWon,
40         uint256 newPot,
41         uint256 P3DAmount,
42         uint256 genAmount,
43         uint256 potAmount,
44         uint256 airDropPot
45     );
46 
47 	// fired whenever theres a withdraw
48     event onWithdraw
49     (
50         uint256 indexed playerID,
51         address playerAddress,
52         bytes32 playerName,
53         uint256 ethOut,
54         uint256 timeStamp
55     );
56 
57     // fired whenever a withdraw forces end round to be ran
58     event onWithdrawAndDistribute
59     (
60         address playerAddress,
61         bytes32 playerName,
62         uint256 ethOut,
63         uint256 compressedData,
64         uint256 compressedIDs,
65         address winnerAddr,
66         bytes32 winnerName,
67         uint256 amountWon,
68         uint256 newPot,
69         uint256 P3DAmount,
70         uint256 genAmount
71     );
72 
73     // (fomo3d short only) fired whenever a player tries a buy after round timer
74     // hit zero, and causes end round to be ran.
75     event onBuyAndDistribute
76     (
77         address playerAddress,
78         bytes32 playerName,
79         uint256 ethIn,
80         uint256 compressedData,
81         uint256 compressedIDs,
82         address winnerAddr,
83         bytes32 winnerName,
84         uint256 amountWon,
85         uint256 newPot,
86         uint256 P3DAmount,
87         uint256 genAmount
88     );
89 
90     // (fomo3d short only) fired whenever a player tries a reload after round timer
91     // hit zero, and causes end round to be ran.
92     event onReLoadAndDistribute
93     (
94         address playerAddress,
95         bytes32 playerName,
96         uint256 compressedData,
97         uint256 compressedIDs,
98         address winnerAddr,
99         bytes32 winnerName,
100         uint256 amountWon,
101         uint256 newPot,
102         uint256 P3DAmount,
103         uint256 genAmount
104     );
105 
106     // fired whenever an affiliate is paid
107     event onAffiliatePayout
108     (
109         uint256 indexed affiliateID,
110         address affiliateAddress,
111         bytes32 affiliateName,
112         uint256 indexed roundID,
113         uint256 indexed buyerID,
114         uint256 amount,
115         uint256 timeStamp
116     );
117 
118     // received pot swap deposit
119     event onPotSwapDeposit
120     (
121         uint256 roundID,
122         uint256 amountAddedToPot
123     );
124 }
125 
126 contract modularShort is F3Devents {}
127 
128 contract SnowStorm is modularShort {
129     using SafeMath for *;
130     using NameFilter for string;
131     using F3DKeysCalcShort for uint256;
132 
133     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xf4FBEF849bcf02Ac4b305c2bc092FC270a14124C);
134 
135     address private admin = msg.sender;
136     string constant public name = "SnowStorm";
137     string constant public symbol = "SS";
138     uint256 private rndExtra_ = 1 seconds;
139     uint256 private rndGap_ = 1 seconds;
140     uint256 constant private rndInit_ = 8 hours;
141     uint256 constant private rndInc_ = 30 seconds;
142     uint256 constant private rndMax_ = 8 hours;
143     address treat;
144     Snow action;
145 
146     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
147     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
148     uint256 public rID_;    // round id number / total rounds that have happened
149 //****************
150 // PLAYER DATA
151 //****************
152     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
153     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
154     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
155     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
156     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
157 //****************
158 // ROUND DATA
159 //****************
160     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
161     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
162 //****************
163 // TEAM FEE DATA
164 //****************
165     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
166     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
167 //==============================================================================
168 //     _ _  _  __|_ _    __|_ _  _  .
169 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
170 //==============================================================================
171     constructor()
172         public
173     {   
174         treat = 0x371308b6A7B6f80DF798589c48Dea369839951dd; // contract address
175         action = Snow(treat);
176 
177 		// Team allocation structures
178         // 0 = whales
179         // 1 = bears
180         // 2 = sneks
181         // 3 = bulls
182 
183 		// Team allocation percentages
184         // (F3D, P3D) + (Pot , Referrals, Community)
185         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
186         fees_[0] = F3Ddatasets.TeamFee(46,10);   //33% to pot, 10% to aff, 1% to air drop pot
187         fees_[1] = F3Ddatasets.TeamFee(46,10);   //33% to pot, 10% to aff, 1% to air drop pot
188         fees_[2] = F3Ddatasets.TeamFee(46,10);   //33% to pot, 10% to aff, 1% to air drop pot
189         fees_[3] = F3Ddatasets.TeamFee(46,10);   //33% to pot, 10% to aff, 1% to air drop pot
190 
191         // how to split up the final pot based on which team was picked
192         // (F3D, P3D)
193         potSplit_[0] = F3Ddatasets.PotSplit(35,5);  //50% to winner, 10% to next round
194         potSplit_[1] = F3Ddatasets.PotSplit(35,5);  //50% to winner, 10% to next round
195         potSplit_[2] = F3Ddatasets.PotSplit(35,5);  //50% to winner, 10% to next round
196         potSplit_[3] = F3Ddatasets.PotSplit(35,5);  //50% to winner, 10% to next round
197     }
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
211     /**
212      * @dev prevents contracts from interacting with fomo3d
213      */
214     modifier isHuman() {
215         address _addr = msg.sender;
216         uint256 _codeLength;
217 
218         assembly {_codeLength := extcodesize(_addr)}
219         require(_codeLength == 0, "sorry humans only");
220         _;
221     }
222 
223     /**
224      * @dev sets boundaries for incoming tx
225      */
226     modifier isWithinLimits(uint256 _eth) {
227         require(_eth >= 1000000000, "pocket lint: not a valid currency");
228         require(_eth <= 100000000000000000000000, "no vitalik, no");
229         _;
230     }
231 
232 //==============================================================================
233 //     _    |_ |. _   |`    _  __|_. _  _  _  .
234 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
235 //====|=========================================================================
236     /**
237      * @dev emergency buy uses last stored affiliate ID and team snek
238      */
239     function()
240         isActivated()
241         isHuman()
242         isWithinLimits(msg.value)
243         public
244         payable
245     {
246         // set up our tx event data and determine if player is new or not
247         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
248 
249         // fetch player id
250         uint256 _pID = pIDxAddr_[msg.sender];
251 
252         // buy core
253         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
254     }
255 
256     /**
257      * @dev converts all incoming ethereum to keys.
258      * -functionhash- 0x8f38f309 (using ID for affiliate)
259      * -functionhash- 0x98a0871d (using address for affiliate)
260      * -functionhash- 0xa65b37a1 (using name for affiliate)
261      * @param _affCode the ID/address/name of the player who gets the affiliate fee
262      * @param _team what team is the player playing for?
263      */
264     function buyXid(uint256 _affCode, uint256 _team)
265         isActivated()
266         isHuman()
267         isWithinLimits(msg.value)
268         public
269         payable
270     {
271         // set up our tx event data and determine if player is new or not
272         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
273 
274         // fetch player id
275         uint256 _pID = pIDxAddr_[msg.sender];
276 
277         // manage affiliate residuals
278         // if no affiliate code was given or player tried to use their own, lolz
279         if (_affCode == 0 || _affCode == _pID)
280         {
281             // use last stored affiliate code
282             _affCode = plyr_[_pID].laff;
283 
284         // if affiliate code was given & its not the same as previously stored
285         } else if (_affCode != plyr_[_pID].laff) {
286             // update last affiliate
287             plyr_[_pID].laff = _affCode;
288         }
289 
290         // verify a valid team was selected
291         _team = verifyTeam(_team);
292 
293         // buy core
294         buyCore(_pID, _affCode, _team, _eventData_);
295     }
296 
297     function buyXaddr(address _affCode, uint256 _team)
298         isActivated()
299         isHuman()
300         isWithinLimits(msg.value)
301         public
302         payable
303     {
304         // set up our tx event data and determine if player is new or not
305         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
306 
307         // fetch player id
308         uint256 _pID = pIDxAddr_[msg.sender];
309 
310         // manage affiliate residuals
311         uint256 _affID;
312         // if no affiliate code was given or player tried to use their own, lolz
313         if (_affCode == address(0) || _affCode == msg.sender)
314         {
315             // use last stored affiliate code
316             _affID = plyr_[_pID].laff;
317 
318         // if affiliate code was given
319         } else {
320             // get affiliate ID from aff Code
321             _affID = pIDxAddr_[_affCode];
322 
323             // if affID is not the same as previously stored
324             if (_affID != plyr_[_pID].laff)
325             {
326                 // update last affiliate
327                 plyr_[_pID].laff = _affID;
328             }
329         }
330 
331         // verify a valid team was selected
332         _team = verifyTeam(_team);
333 
334         // buy core
335         buyCore(_pID, _affID, _team, _eventData_);
336     }
337 
338     function buyXname(bytes32 _affCode, uint256 _team)
339         isActivated()
340         isHuman()
341         isWithinLimits(msg.value)
342         public
343         payable
344     {
345         // set up our tx event data and determine if player is new or not
346         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
347 
348         // fetch player id
349         uint256 _pID = pIDxAddr_[msg.sender];
350 
351         // manage affiliate residuals
352         uint256 _affID;
353         // if no affiliate code was given or player tried to use their own, lolz
354         if (_affCode == '' || _affCode == plyr_[_pID].name)
355         {
356             // use last stored affiliate code
357             _affID = plyr_[_pID].laff;
358 
359         // if affiliate code was given
360         } else {
361             // get affiliate ID from aff Code
362             _affID = pIDxName_[_affCode];
363 
364             // if affID is not the same as previously stored
365             if (_affID != plyr_[_pID].laff)
366             {
367                 // update last affiliate
368                 plyr_[_pID].laff = _affID;
369             }
370         }
371 
372         // verify a valid team was selected
373         _team = verifyTeam(_team);
374 
375         // buy core
376         buyCore(_pID, _affID, _team, _eventData_);
377     }
378 
379     /**
380      * @dev essentially the same as buy, but instead of you sending ether
381      * from your wallet, it uses your unwithdrawn earnings.
382      * -functionhash- 0x349cdcac (using ID for affiliate)
383      * -functionhash- 0x82bfc739 (using address for affiliate)
384      * -functionhash- 0x079ce327 (using name for affiliate)
385      * @param _affCode the ID/address/name of the player who gets the affiliate fee
386      * @param _team what team is the player playing for?
387      * @param _eth amount of earnings to use (remainder returned to gen vault)
388      */
389     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
390         isActivated()
391         isHuman()
392         isWithinLimits(_eth)
393         public
394     {
395         // set up our tx event data
396         F3Ddatasets.EventReturns memory _eventData_;
397 
398         // fetch player ID
399         uint256 _pID = pIDxAddr_[msg.sender];
400 
401         // manage affiliate residuals
402         // if no affiliate code was given or player tried to use their own, lolz
403         if (_affCode == 0 || _affCode == _pID)
404         {
405             // use last stored affiliate code
406             _affCode = plyr_[_pID].laff;
407 
408         // if affiliate code was given & its not the same as previously stored
409         } else if (_affCode != plyr_[_pID].laff) {
410             // update last affiliate
411             plyr_[_pID].laff = _affCode;
412         }
413 
414         // verify a valid team was selected
415         _team = verifyTeam(_team);
416 
417         // reload core
418         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
419     }
420 
421     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
422         isActivated()
423         isHuman()
424         isWithinLimits(_eth)
425         public
426     {
427         // set up our tx event data
428         F3Ddatasets.EventReturns memory _eventData_;
429 
430         // fetch player ID
431         uint256 _pID = pIDxAddr_[msg.sender];
432 
433         // manage affiliate residuals
434         uint256 _affID;
435         // if no affiliate code was given or player tried to use their own, lolz
436         if (_affCode == address(0) || _affCode == msg.sender)
437         {
438             // use last stored affiliate code
439             _affID = plyr_[_pID].laff;
440 
441         // if affiliate code was given
442         } else {
443             // get affiliate ID from aff Code
444             _affID = pIDxAddr_[_affCode];
445 
446             // if affID is not the same as previously stored
447             if (_affID != plyr_[_pID].laff)
448             {
449                 // update last affiliate
450                 plyr_[_pID].laff = _affID;
451             }
452         }
453 
454         // verify a valid team was selected
455         _team = verifyTeam(_team);
456 
457         // reload core
458         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
459     }
460 
461     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
462         isActivated()
463         isHuman()
464         isWithinLimits(_eth)
465         public
466     {
467         // set up our tx event data
468         F3Ddatasets.EventReturns memory _eventData_;
469 
470         // fetch player ID
471         uint256 _pID = pIDxAddr_[msg.sender];
472 
473         // manage affiliate residuals
474         uint256 _affID;
475         // if no affiliate code was given or player tried to use their own, lolz
476         if (_affCode == '' || _affCode == plyr_[_pID].name)
477         {
478             // use last stored affiliate code
479             _affID = plyr_[_pID].laff;
480 
481         // if affiliate code was given
482         } else {
483             // get affiliate ID from aff Code
484             _affID = pIDxName_[_affCode];
485 
486             // if affID is not the same as previously stored
487             if (_affID != plyr_[_pID].laff)
488             {
489                 // update last affiliate
490                 plyr_[_pID].laff = _affID;
491             }
492         }
493 
494         // verify a valid team was selected
495         _team = verifyTeam(_team);
496 
497         // reload core
498         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
499     }
500 
501     /**
502      * @dev withdraws all of your earnings.
503      * -functionhash- 0x3ccfd60b
504      */
505     function withdraw()
506         isActivated()
507         isHuman()
508         public
509     {
510         // setup local rID
511         uint256 _rID = rID_;
512 
513         // grab time
514         uint256 _now = now;
515 
516         // fetch player ID
517         uint256 _pID = pIDxAddr_[msg.sender];
518 
519         // setup temp var for player eth
520         uint256 _eth;
521 
522         // check to see if round has ended and no one has run round end yet
523         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
524         {
525             // set up our tx event data
526             F3Ddatasets.EventReturns memory _eventData_;
527 
528             // end the round (distributes pot)
529 			round_[_rID].ended = true;
530             _eventData_ = endRound(_eventData_);
531 
532 			// get their earnings
533             _eth = withdrawEarnings(_pID);
534 
535             // gib moni
536             if (_eth > 0)
537                 plyr_[_pID].addr.transfer(_eth);
538 
539             // build event data
540             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
541             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
542 
543             // fire withdraw and distribute event
544             emit F3Devents.onWithdrawAndDistribute
545             (
546                 msg.sender,
547                 plyr_[_pID].name,
548                 _eth,
549                 _eventData_.compressedData,
550                 _eventData_.compressedIDs,
551                 _eventData_.winnerAddr,
552                 _eventData_.winnerName,
553                 _eventData_.amountWon,
554                 _eventData_.newPot,
555                 _eventData_.P3DAmount,
556                 _eventData_.genAmount
557             );
558 
559         // in any other situation
560         } else {
561             // get their earnings
562             _eth = withdrawEarnings(_pID);
563 
564             // gib moni
565             if (_eth > 0)
566                 plyr_[_pID].addr.transfer(_eth);
567 
568             // fire withdraw event
569             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
570         }
571     }
572 
573     /**
574      * @dev use these to register names.  they are just wrappers that will send the
575      * registration requests to the PlayerBook contract.  So registering here is the
576      * same as registering there.  UI will always display the last name you registered.
577      * but you will still own all previously registered names to use as affiliate
578      * links.
579      * - must pay a registration fee.
580      * - name must be unique
581      * - names will be converted to lowercase
582      * - name cannot start or end with a space
583      * - cannot have more than 1 space in a row
584      * - cannot be only numbers
585      * - cannot start with 0x
586      * - name must be at least 1 char
587      * - max length of 32 characters long
588      * - allowed characters: a-z, 0-9, and space
589      * -functionhash- 0x921dec21 (using ID for affiliate)
590      * -functionhash- 0x3ddd4698 (using address for affiliate)
591      * -functionhash- 0x685ffd83 (using name for affiliate)
592      * @param _nameString players desired name
593      * @param _affCode affiliate ID, address, or name of who referred you
594      * @param _all set to true if you want this to push your info to all games
595      * (this might cost a lot of gas)
596      */
597     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
598         isHuman()
599         public
600         payable
601     {
602         bytes32 _name = _nameString.nameFilter();
603         address _addr = msg.sender;
604         uint256 _paid = msg.value;
605         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
606 
607         uint256 _pID = pIDxAddr_[_addr];
608 
609         // fire event
610         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
611     }
612 
613     function registerNameXaddr(string _nameString, address _affCode, bool _all)
614         isHuman()
615         public
616         payable
617     {
618         bytes32 _name = _nameString.nameFilter();
619         address _addr = msg.sender;
620         uint256 _paid = msg.value;
621         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
622 
623         uint256 _pID = pIDxAddr_[_addr];
624 
625         // fire event
626         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
627     }
628 
629     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
630         isHuman()
631         public
632         payable
633     {
634         bytes32 _name = _nameString.nameFilter();
635         address _addr = msg.sender;
636         uint256 _paid = msg.value;
637         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
638 
639         uint256 _pID = pIDxAddr_[_addr];
640 
641         // fire event
642         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
643     }
644 //==============================================================================
645 //     _  _ _|__|_ _  _ _  .
646 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
647 //=====_|=======================================================================
648     /**
649      * @dev return the price buyer will pay for next 1 individual key.
650      * -functionhash- 0x018a25e8
651      * @return price for next key bought (in wei format)
652      */
653     function getBuyPrice()
654         public
655         view
656         returns(uint256)
657     {
658         // setup local rID
659         uint256 _rID = rID_;
660 
661         // grab time
662         uint256 _now = now;
663 
664         // are we in a round?
665         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
666             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
667         else // rounds over.  need price for new round
668             return ( 75000000000000 ); // init
669     }
670 
671     /**
672      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
673      * provider
674      * -functionhash- 0xc7e284b8
675      * @return time left in seconds
676      */
677     function getTimeLeft()
678         public
679         view
680         returns(uint256)
681     {
682         // setup local rID
683         uint256 _rID = rID_;
684 
685         // grab time
686         uint256 _now = now;
687 
688         if (_now < round_[_rID].end)
689             if (_now > round_[_rID].strt + rndGap_)
690                 return( (round_[_rID].end).sub(_now) );
691             else
692                 return( (round_[_rID].strt + rndGap_).sub(_now) );
693         else
694             return(0);
695     }
696 
697     /**
698      * @dev returns player earnings per vaults
699      * -functionhash- 0x63066434
700      * @return winnings vault
701      * @return general vault
702      * @return affiliate vault
703      */
704     function getPlayerVaults(uint256 _pID)
705         public
706         view
707         returns(uint256 ,uint256, uint256)
708     {
709         // setup local rID
710         uint256 _rID = rID_;
711 
712         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
713         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
714         {
715             // if player is winner
716             if (round_[_rID].plyr == _pID)
717             {
718                 return
719                 (
720                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(50)) / 100 ),
721                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
722                     plyr_[_pID].aff
723                 );
724             // if player is not the winner
725             } else {
726                 return
727                 (
728                     plyr_[_pID].win,
729                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
730                     plyr_[_pID].aff
731                 );
732             }
733 
734         // if round is still going on, or round has ended and round end has been ran
735         } else {
736             return
737             (
738                 plyr_[_pID].win,
739                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
740                 plyr_[_pID].aff
741             );
742         }
743     }
744 
745     /**
746      * solidity hates stack limits.  this lets us avoid that hate
747      */
748     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
749         private
750         view
751         returns(uint256)
752     {
753         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
754     }
755 
756     /**
757      * @dev returns all current round info needed for front end
758      * -functionhash- 0x747dff42
759      * @return eth invested during ICO phase
760      * @return round id
761      * @return total keys for round
762      * @return time round ends
763      * @return time round started
764      * @return current pot
765      * @return current team ID & player ID in lead
766      * @return current player in leads address
767      * @return current player in leads name
768      * @return whales eth in for round
769      * @return bears eth in for round
770      * @return sneks eth in for round
771      * @return bulls eth in for round
772      * @return airdrop tracker # & airdrop pot
773      */
774     function getCurrentRoundInfo()
775         public
776         view
777         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
778     {
779         // setup local rID
780         uint256 _rID = rID_;
781 
782         return
783         (
784             round_[_rID].ico,               //0
785             _rID,                           //1
786             round_[_rID].keys,              //2
787             round_[_rID].end,               //3
788             round_[_rID].strt,              //4
789             round_[_rID].pot,               //5
790             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
791             plyr_[round_[_rID].plyr].addr,  //7
792             plyr_[round_[_rID].plyr].name,  //8
793             rndTmEth_[_rID][0],             //9
794             rndTmEth_[_rID][1],             //10
795             rndTmEth_[_rID][2],             //11
796             rndTmEth_[_rID][3],             //12
797             airDropTracker_ + (airDropPot_ * 1000)              //13
798         );
799     }
800 
801     /**
802      * @dev returns player info based on address.  if no address is given, it will
803      * use msg.sender
804      * -functionhash- 0xee0b5d8b
805      * @param _addr address of the player you want to lookup
806      * @return player ID
807      * @return player name
808      * @return keys owned (current round)
809      * @return winnings vault
810      * @return general vault
811      * @return affiliate vault
812 	 * @return player round eth
813      */
814     function getPlayerInfoByAddress(address _addr)
815         public
816         view
817         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
818     {
819         // setup local rID
820         uint256 _rID = rID_;
821 
822         if (_addr == address(0))
823         {
824             _addr == msg.sender;
825         }
826         uint256 _pID = pIDxAddr_[_addr];
827 
828         return
829         (
830             _pID,                               //0
831             plyr_[_pID].name,                   //1
832             plyrRnds_[_pID][_rID].keys,         //2
833             plyr_[_pID].win,                    //3
834             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
835             plyr_[_pID].aff,                    //5
836             plyrRnds_[_pID][_rID].eth           //6
837         );
838     }
839 
840 //==============================================================================
841 //     _ _  _ _   | _  _ . _  .
842 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
843 //=====================_|=======================================================
844     /**
845      * @dev logic runs whenever a buy order is executed.  determines how to handle
846      * incoming eth depending on if we are in an active round or not
847      */
848     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
849         private
850     {
851         // setup local rID
852         uint256 _rID = rID_;
853 
854         // grab time
855         uint256 _now = now;
856 
857         // if round is active
858         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
859         {
860             // call core
861             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
862 
863         // if round is not active
864         } else {
865             // check to see if end round needs to be ran
866             if (_now > round_[_rID].end && round_[_rID].ended == false)
867             {
868                 // end the round (distributes pot) & start new round
869 			    round_[_rID].ended = true;
870                 _eventData_ = endRound(_eventData_);
871 
872                 // build event data
873                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
874                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
875 
876                 // fire buy and distribute event
877                 emit F3Devents.onBuyAndDistribute
878                 (
879                     msg.sender,
880                     plyr_[_pID].name,
881                     msg.value,
882                     _eventData_.compressedData,
883                     _eventData_.compressedIDs,
884                     _eventData_.winnerAddr,
885                     _eventData_.winnerName,
886                     _eventData_.amountWon,
887                     _eventData_.newPot,
888                     _eventData_.P3DAmount,
889                     _eventData_.genAmount
890                 );
891             }
892 
893             // put eth in players vault
894             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
895         }
896     }
897 
898     /**
899      * @dev logic runs whenever a reload order is executed.  determines how to handle
900      * incoming eth depending on if we are in an active round or not
901      */
902     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
903         private
904     {
905         // setup local rID
906         uint256 _rID = rID_;
907 
908         // grab time
909         uint256 _now = now;
910 
911         // if round is active
912         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
913         {
914             // get earnings from all vaults and return unused to gen vault
915             // because we use a custom safemath library.  this will throw if player
916             // tried to spend more eth than they have.
917             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
918 
919             // call core
920             core(_rID, _pID, _eth, _affID, _team, _eventData_);
921 
922         // if round is not active and end round needs to be ran
923         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
924             // end the round (distributes pot) & start new round
925             round_[_rID].ended = true;
926             _eventData_ = endRound(_eventData_);
927 
928             // build event data
929             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
930             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
931 
932             // fire buy and distribute event
933             emit F3Devents.onReLoadAndDistribute
934             (
935                 msg.sender,
936                 plyr_[_pID].name,
937                 _eventData_.compressedData,
938                 _eventData_.compressedIDs,
939                 _eventData_.winnerAddr,
940                 _eventData_.winnerName,
941                 _eventData_.amountWon,
942                 _eventData_.newPot,
943                 _eventData_.P3DAmount,
944                 _eventData_.genAmount
945             );
946         }
947     }
948 
949     /**
950      * @dev this is the core logic for any buy/reload that happens while a round
951      * is live.
952      */
953     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
954         private
955     {
956         // if player is new to round
957         if (plyrRnds_[_pID][_rID].keys == 0)
958             _eventData_ = managePlayer(_pID, _eventData_);
959 
960         // early round eth limiter
961         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000)
962         {
963             uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
964             uint256 _refund = _eth.sub(_availableLimit);
965             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
966             _eth = _availableLimit;
967         }
968 
969         // if eth left is greater than min eth allowed (sorry no pocket lint)
970         if (_eth > 1000000000)
971         {
972 
973             // mint the new keys
974             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
975 
976             // if they bought at least 1 whole key
977             if (_keys >= 1000000000000000000)
978             {
979             updateTimer(_keys, _rID);
980 
981             // set new leaders
982             if (round_[_rID].plyr != _pID)
983                 round_[_rID].plyr = _pID;
984             if (round_[_rID].team != _team)
985                 round_[_rID].team = _team;
986 
987             // set the new leader bool to true
988             _eventData_.compressedData = _eventData_.compressedData + 100;
989         }
990 
991             // manage airdrops
992             if (_eth >= 100000000000000000)
993             {
994             airDropTracker_++;
995             if (airdrop() == true)
996             {
997                 // gib muni
998                 uint256 _prize;
999                 if (_eth >= 10000000000000000000)
1000                 {
1001                     // calculate prize and give it to winner
1002                     _prize = ((airDropPot_).mul(75)) / 100;
1003                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1004 
1005                     // adjust airDropPot
1006                     airDropPot_ = (airDropPot_).sub(_prize);
1007 
1008                     // let event know a tier 3 prize was won
1009                     _eventData_.compressedData += 300000000000000000000000000000000;
1010                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1011                     // calculate prize and give it to winner
1012                     _prize = ((airDropPot_).mul(50)) / 100;
1013                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1014 
1015                     // adjust airDropPot
1016                     airDropPot_ = (airDropPot_).sub(_prize);
1017 
1018                     // let event know a tier 2 prize was won
1019                     _eventData_.compressedData += 200000000000000000000000000000000;
1020                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1021                     // calculate prize and give it to winner
1022                     _prize = ((airDropPot_).mul(25)) / 100;
1023                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1024 
1025                     // adjust airDropPot
1026                     airDropPot_ = (airDropPot_).sub(_prize);
1027 
1028                     // let event know a tier 3 prize was won
1029                     _eventData_.compressedData += 300000000000000000000000000000000;
1030                 }
1031                 // set airdrop happened bool to true
1032                 _eventData_.compressedData += 10000000000000000000000000000000;
1033                 // let event know how much was won
1034                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1035 
1036                 // reset air drop tracker
1037                 airDropTracker_ = 0;
1038             }
1039         }
1040 
1041             // store the air drop tracker number (number of buys since last airdrop)
1042             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1043 
1044             // update player
1045             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1046             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1047 
1048             // update round
1049             round_[_rID].keys = _keys.add(round_[_rID].keys);
1050             round_[_rID].eth = _eth.add(round_[_rID].eth);
1051             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1052 
1053             // distribute eth
1054             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1055             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1056 
1057             // call end tx function to fire end tx event.
1058 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1059         }
1060     }
1061 //==============================================================================
1062 //     _ _ | _   | _ _|_ _  _ _  .
1063 //    (_(_||(_|_||(_| | (_)| _\  .
1064 //==============================================================================
1065     /**
1066      * @dev calculates unmasked earnings (just calculates, does not update mask)
1067      * @return earnings in wei format
1068      */
1069     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1070         private
1071         view
1072         returns(uint256)
1073     {
1074         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1075     }
1076 
1077     /**
1078      * @dev returns the amount of keys you would get given an amount of eth.
1079      * -functionhash- 0xce89c80c
1080      * @param _rID round ID you want price for
1081      * @param _eth amount of eth sent in
1082      * @return keys received
1083      */
1084     function calcKeysReceived(uint256 _rID, uint256 _eth)
1085         public
1086         view
1087         returns(uint256)
1088     {
1089         // grab time
1090         uint256 _now = now;
1091 
1092         // are we in a round?
1093         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1094             return ( (round_[_rID].eth).keysRec(_eth) );
1095         else // rounds over.  need keys for new round
1096             return ( (_eth).keys() );
1097     }
1098 
1099     /**
1100      * @dev returns current eth price for X keys.
1101      * -functionhash- 0xcf808000
1102      * @param _keys number of keys desired (in 18 decimal format)
1103      * @return amount of eth needed to send
1104      */
1105     function iWantXKeys(uint256 _keys)
1106         public
1107         view
1108         returns(uint256)
1109     {
1110         // setup local rID
1111         uint256 _rID = rID_;
1112 
1113         // grab time
1114         uint256 _now = now;
1115 
1116         // are we in a round?
1117         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1118             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1119         else // rounds over.  need price for new round
1120             return ( (_keys).eth() );
1121     }
1122 //==============================================================================
1123 //    _|_ _  _ | _  .
1124 //     | (_)(_)|_\  .
1125 //==============================================================================
1126     /**
1127 	 * @dev receives name/player info from names contract
1128      */
1129     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1130         external
1131     {
1132         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1133         if (pIDxAddr_[_addr] != _pID)
1134             pIDxAddr_[_addr] = _pID;
1135         if (pIDxName_[_name] != _pID)
1136             pIDxName_[_name] = _pID;
1137         if (plyr_[_pID].addr != _addr)
1138             plyr_[_pID].addr = _addr;
1139         if (plyr_[_pID].name != _name)
1140             plyr_[_pID].name = _name;
1141         if (plyr_[_pID].laff != _laff)
1142             plyr_[_pID].laff = _laff;
1143         if (plyrNames_[_pID][_name] == false)
1144             plyrNames_[_pID][_name] = true;
1145     }
1146 
1147     /**
1148      * @dev receives entire player name list
1149      */
1150     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1151         external
1152     {
1153         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1154         if(plyrNames_[_pID][_name] == false)
1155             plyrNames_[_pID][_name] = true;
1156     }
1157 
1158     /**
1159      * @dev gets existing or registers new pID.  use this when a player may be new
1160      * @return pID
1161      */
1162     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1163         private
1164         returns (F3Ddatasets.EventReturns)
1165     {
1166         uint256 _pID = pIDxAddr_[msg.sender];
1167         // if player is new to this version of fomo3d
1168         if (_pID == 0)
1169         {
1170             // grab their player ID, name and last aff ID, from player names contract
1171             _pID = PlayerBook.getPlayerID(msg.sender);
1172             bytes32 _name = PlayerBook.getPlayerName(_pID);
1173             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1174 
1175             // set up player account
1176             pIDxAddr_[msg.sender] = _pID;
1177             plyr_[_pID].addr = msg.sender;
1178 
1179             if (_name != "")
1180             {
1181                 pIDxName_[_name] = _pID;
1182                 plyr_[_pID].name = _name;
1183                 plyrNames_[_pID][_name] = true;
1184             }
1185 
1186             if (_laff != 0 && _laff != _pID)
1187                 plyr_[_pID].laff = _laff;
1188 
1189             // set the new player bool to true
1190             _eventData_.compressedData = _eventData_.compressedData + 1;
1191         }
1192         return (_eventData_);
1193     }
1194 
1195     /**
1196      * @dev checks to make sure user picked a valid team.  if not sets team
1197      * to default (sneks)
1198      */
1199     function verifyTeam(uint256 _team)
1200         private
1201         pure
1202         returns (uint256)
1203     {
1204         if (_team < 0 || _team > 3)
1205             return(2);
1206         else
1207             return(_team);
1208     }
1209 
1210     /**
1211      * @dev decides if round end needs to be run & new round started.  and if
1212      * player unmasked earnings from previously played rounds need to be moved.
1213      */
1214     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1215         private
1216         returns (F3Ddatasets.EventReturns)
1217     {
1218         // if player has played a previous round, move their unmasked earnings
1219         // from that round to gen vault.
1220         if (plyr_[_pID].lrnd != 0)
1221             updateGenVault(_pID, plyr_[_pID].lrnd);
1222 
1223         // update player's last round played
1224         plyr_[_pID].lrnd = rID_;
1225 
1226         // set the joined round bool to true
1227         _eventData_.compressedData = _eventData_.compressedData + 10;
1228 
1229         return(_eventData_);
1230     }
1231 
1232     /**
1233      * @dev ends the round. manages paying out winner/splitting up pot
1234      */
1235     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1236         private
1237         returns (F3Ddatasets.EventReturns)
1238     {
1239         // setup local rID
1240         uint256 _rID = rID_;
1241 
1242         // grab our winning player and team id's
1243         uint256 _winPID = round_[_rID].plyr;
1244         uint256 _winTID = round_[_rID].team;
1245 
1246         // grab our pot amount
1247         uint256 _pot = round_[_rID].pot;
1248 
1249         // calculate our winner share, community rewards, gen share,
1250         // p3d share, and amount reserved for next pot
1251         uint256 _win = (_pot.mul(48)) / 100; //48%
1252         uint256 _com = (_pot / 50); //2% 
1253         _win = _win+_com; // 50%
1254         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1255         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1256         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1257 
1258         // calculate ppt for round mask
1259         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1260         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1261         if (_dust > 0)
1262         {
1263             _gen = _gen.sub(_dust);
1264             _res = _res.add(_dust);
1265         }
1266 
1267         // pay our winner
1268         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1269 
1270         action.redistribution.value(_p3d).gas(1000000)(); // send dividends to snow holders
1271 
1272         // distribute gen portion to key holders
1273         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1274 
1275         // prepare event data
1276         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1277         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1278         _eventData_.winnerAddr = plyr_[_winPID].addr;
1279         _eventData_.winnerName = plyr_[_winPID].name;
1280         _eventData_.amountWon = _win;
1281         _eventData_.genAmount = _gen;
1282         _eventData_.P3DAmount = _p3d;
1283         _eventData_.newPot = _res;
1284 
1285         // start next round
1286         rID_++;
1287         _rID++;
1288         round_[_rID].strt = now;
1289         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1290         round_[_rID].pot = _res;
1291 
1292         return(_eventData_);
1293     }
1294 
1295     /**
1296      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1297      */
1298     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1299         private
1300     {
1301         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1302         if (_earnings > 0)
1303         {
1304             // put in gen vault
1305             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1306             // zero out their earnings by updating mask
1307             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1308         }
1309     }
1310 
1311     /**
1312      * @dev updates round timer based on number of whole keys bought.
1313      */
1314     function updateTimer(uint256 _keys, uint256 _rID)
1315         private
1316     {
1317         // grab time
1318         uint256 _now = now;
1319 
1320         // calculate time based on number of keys bought
1321         uint256 _newTime;
1322         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1323             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1324         else
1325             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1326 
1327         // compare to max and set new end time
1328         if (_newTime < (rndMax_).add(_now))
1329             round_[_rID].end = _newTime;
1330         else
1331             round_[_rID].end = rndMax_.add(_now);
1332     }
1333 
1334     /**
1335      * @dev generates a random number between 0-99 and checks to see if thats
1336      * resulted in an airdrop win
1337      * @return do we have a winner?
1338      */
1339     function airdrop()
1340         private
1341         view
1342         returns(bool)
1343     {
1344         uint256 seed = uint256(keccak256(abi.encodePacked(
1345 
1346             (block.timestamp).add
1347             (block.difficulty).add
1348             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1349             (block.gaslimit).add
1350             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1351             (block.number)
1352 
1353         )));
1354         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1355             return(true);
1356         else
1357             return(false);
1358     }
1359 
1360     /**
1361      * @dev distributes eth based on fees to com, aff, and p3d
1362      */
1363     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1364         private
1365         returns(F3Ddatasets.EventReturns)
1366     {
1367         //pay 3% also into the pot
1368         uint256 _p1 = _eth / 100; //1%
1369         uint256 _com = _eth / 50;  //2%
1370         _com = _com.add(_p1); //1 + 2 = 3
1371 
1372 
1373         uint256 _p3d;
1374         if (!address(admin).call.value(_com)())
1375         {
1376             // This ensures Team Just cannot influence the outcome of FoMo3D with
1377             // bank migrations by breaking outgoing transactions.
1378             // Something we would never do. But that's not the point.
1379             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1380             // highest belief that everything we create should be trustless.
1381             // Team JUST, The name you shouldn't have to trust.
1382             _p3d = _com;
1383             _com = 0;
1384         }
1385 
1386 
1387         // distribute share to affiliate
1388         uint256 _aff = _eth / 10;
1389 
1390         // decide what to do with affiliate share of fees
1391         // affiliate must not be self, and must have a name registered
1392         if (_affID != _pID && plyr_[_affID].name != '') {
1393             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1394             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1395         } else {
1396             _p3d = _aff;
1397         }
1398 
1399         // pay out p3d
1400         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1401         if (_p3d > 0)
1402         {
1403             action.redistribution.value(_p3d).gas(1000000)();
1404 
1405 
1406             // set up event data
1407             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1408         }
1409 
1410         return(_eventData_);
1411     }
1412 
1413     function potSwap()
1414         external
1415         payable
1416     {
1417         // setup local rID
1418         uint256 _rID = rID_ + 1;
1419 
1420         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1421         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1422     }
1423 
1424     /**
1425      * @dev distributes eth based on fees to gen and pot
1426      */
1427     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1428         private
1429         returns(F3Ddatasets.EventReturns)
1430     {
1431         // calculate gen share
1432         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1433 
1434         // toss 1% into airdrop pot
1435         uint256 _air = (_eth / 100);
1436         airDropPot_ = airDropPot_.add(_air);
1437 
1438         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1439         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1440 
1441         // calculate pot
1442         uint256 _pot = _eth.sub(_gen);
1443 
1444         // distribute gen share (thats what updateMasks() does) and adjust
1445         // balances for dust.
1446         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1447         if (_dust > 0)
1448             _gen = _gen.sub(_dust);
1449 
1450         // add eth to pot
1451         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1452 
1453         // set up event data
1454         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1455         _eventData_.potAmount = _pot;
1456 
1457         return(_eventData_);
1458     }
1459 
1460     /**
1461      * @dev updates masks for round and player when keys are bought
1462      * @return dust left over
1463      */
1464     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1465         private
1466         returns(uint256)
1467     {
1468         /* MASKING NOTES
1469             earnings masks are a tricky thing for people to wrap their minds around.
1470             the basic thing to understand here.  is were going to have a global
1471             tracker based on profit per share for each round, that increases in
1472             relevant proportion to the increase in share supply.
1473 
1474             the player will have an additional mask that basically says "based
1475             on the rounds mask, my shares, and how much i've already withdrawn,
1476             how much is still owed to me?"
1477         */
1478 
1479         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1480         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1481         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1482 
1483         // calculate player earning from their own buy (only based on the keys
1484         // they just bought).  & update player earnings mask
1485         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1486         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1487 
1488         // calculate & return dust
1489         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1490     }
1491 
1492     /**
1493      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1494      * @return earnings in wei format
1495      */
1496     function withdrawEarnings(uint256 _pID)
1497         private
1498         returns(uint256)
1499     {
1500         // update gen vault
1501         updateGenVault(_pID, plyr_[_pID].lrnd);
1502 
1503         // from vaults
1504         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1505         if (_earnings > 0)
1506         {
1507             plyr_[_pID].win = 0;
1508             plyr_[_pID].gen = 0;
1509             plyr_[_pID].aff = 0;
1510         }
1511 
1512         return(_earnings);
1513     }
1514 
1515     /**
1516      * @dev prepares compression data and fires event for buy or reload tx's
1517      */
1518     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1519         private
1520     {
1521         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1522         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1523 
1524         emit F3Devents.onEndTx
1525         (
1526             _eventData_.compressedData,
1527             _eventData_.compressedIDs,
1528             plyr_[_pID].name,
1529             msg.sender,
1530             _eth,
1531             _keys,
1532             _eventData_.winnerAddr,
1533             _eventData_.winnerName,
1534             _eventData_.amountWon,
1535             _eventData_.newPot,
1536             _eventData_.P3DAmount,
1537             _eventData_.genAmount,
1538             _eventData_.potAmount,
1539             airDropPot_
1540         );
1541     }
1542 //==============================================================================
1543 //    (~ _  _    _._|_    .
1544 //    _)(/_(_|_|| | | \/  .
1545 //====================/=========================================================
1546     /** upon contract deploy, it will be deactivated.  this is a one time
1547      * use function that will activate the contract.  we do this so devs
1548      * have time to set things up on the web end                            **/
1549     bool public activated_ = false;
1550     function activate()
1551         public
1552     {
1553         // only team just can activate
1554         require(msg.sender == admin);
1555 
1556 
1557         // can only be ran once
1558         require(activated_ == false);
1559 
1560         // activate the contract
1561         activated_ = true;
1562 
1563         // lets start first round
1564         rID_ = 1;
1565             round_[1].strt = now + rndExtra_ - rndGap_;
1566             round_[1].end = now + rndInit_ + rndExtra_;
1567     }
1568 }
1569 
1570 //==============================================================================
1571 //   __|_ _    __|_ _  .
1572 //  _\ | | |_|(_ | _\  .
1573 //==============================================================================
1574 library F3Ddatasets {
1575     //compressedData key
1576     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1577         // 0 - new player (bool)
1578         // 1 - joined round (bool)
1579         // 2 - new  leader (bool)
1580         // 3-5 - air drop tracker (uint 0-999)
1581         // 6-16 - round end time
1582         // 17 - winnerTeam
1583         // 18 - 28 timestamp
1584         // 29 - team
1585         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1586         // 31 - airdrop happened bool
1587         // 32 - airdrop tier
1588         // 33 - airdrop amount won
1589     //compressedIDs key
1590     // [77-52][51-26][25-0]
1591         // 0-25 - pID
1592         // 26-51 - winPID
1593         // 52-77 - rID
1594     struct EventReturns {
1595         uint256 compressedData;
1596         uint256 compressedIDs;
1597         address winnerAddr;         // winner address
1598         bytes32 winnerName;         // winner name
1599         uint256 amountWon;          // amount won
1600         uint256 newPot;             // amount in new pot
1601         uint256 P3DAmount;          // amount distributed to p3d
1602         uint256 genAmount;          // amount distributed to gen
1603         uint256 potAmount;          // amount added to pot
1604     }
1605     struct Player {
1606         address addr;   // player address
1607         bytes32 name;   // player name
1608         uint256 win;    // winnings vault
1609         uint256 gen;    // general vault
1610         uint256 aff;    // affiliate vault
1611         uint256 lrnd;   // last round played
1612         uint256 laff;   // last affiliate id used
1613     }
1614     struct PlayerRounds {
1615         uint256 eth;    // eth player has added to round (used for eth limiter)
1616         uint256 keys;   // keys
1617         uint256 mask;   // player mask
1618         uint256 ico;    // ICO phase investment
1619     }
1620     struct Round {
1621         uint256 plyr;   // pID of player in lead
1622         uint256 team;   // tID of team in lead
1623         uint256 end;    // time ends/ended
1624         bool ended;     // has round end function been ran
1625         uint256 strt;   // time round started
1626         uint256 keys;   // keys
1627         uint256 eth;    // total eth in
1628         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1629         uint256 mask;   // global mask
1630         uint256 ico;    // total eth sent in during ICO phase
1631         uint256 icoGen; // total eth for gen during ICO phase
1632         uint256 icoAvg; // average key price for ICO phase
1633     }
1634     struct TeamFee {
1635         uint256 gen;    // % of buy in thats paid to key holders of current round
1636         uint256 p3d;    // % of buy in thats paid to p3d holders
1637     }
1638     struct PotSplit {
1639         uint256 gen;    // % of pot thats paid to key holders of current round
1640         uint256 p3d;    // % of pot thats paid to p3d holders
1641     }
1642 }
1643 
1644 //==============================================================================
1645 //  |  _      _ _ | _  .
1646 //  |<(/_\/  (_(_||(_  .
1647 //=======/======================================================================
1648 library F3DKeysCalcShort {
1649     using SafeMath for *;
1650     /**
1651      * @dev calculates number of keys received given X eth
1652      * @param _curEth current amount of eth in contract
1653      * @param _newEth eth being spent
1654      * @return amount of ticket purchased
1655      */
1656     function keysRec(uint256 _curEth, uint256 _newEth)
1657         internal
1658         pure
1659         returns (uint256)
1660     {
1661         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1662     }
1663 
1664     /**
1665      * @dev calculates amount of eth received if you sold X keys
1666      * @param _curKeys current amount of keys that exist
1667      * @param _sellKeys amount of keys you wish to sell
1668      * @return amount of eth received
1669      */
1670     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1671         internal
1672         pure
1673         returns (uint256)
1674     {
1675         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1676     }
1677 
1678     /**
1679      * @dev calculates how many keys would exist with given an amount of eth
1680      * @param _eth eth "in contract"
1681      * @return number of keys that would exist
1682      */
1683     function keys(uint256 _eth)
1684         internal
1685         pure
1686         returns(uint256)
1687     {
1688         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1689     }
1690 
1691     /**
1692      * @dev calculates how much eth would be in contract given a number of keys
1693      * @param _keys number of keys "in contract"
1694      * @return eth that would exists
1695      */
1696     function eth(uint256 _keys)
1697         internal
1698         pure
1699         returns(uint256)
1700     {
1701         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1702     }
1703 }
1704 
1705 //==============================================================================
1706 //  . _ _|_ _  _ |` _  _ _  _  .
1707 //  || | | (/_| ~|~(_|(_(/__\  .
1708 //==============================================================================
1709 
1710 interface PlayerBookInterface {
1711     function getPlayerID(address _addr) external returns (uint256);
1712     function getPlayerName(uint256 _pID) external view returns (bytes32);
1713     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1714     function getPlayerAddr(uint256 _pID) external view returns (address);
1715     function getNameFee() external view returns (uint256);
1716     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1717     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1718     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1719 }
1720 
1721 
1722 library NameFilter {
1723     /**
1724      * @dev filters name strings
1725      * -converts uppercase to lower case.
1726      * -makes sure it does not start/end with a space
1727      * -makes sure it does not contain multiple spaces in a row
1728      * -cannot be only numbers
1729      * -cannot start with 0x
1730      * -restricts characters to A-Z, a-z, 0-9, and space.
1731      * @return reprocessed string in bytes32 format
1732      */
1733     function nameFilter(string _input)
1734         internal
1735         pure
1736         returns(bytes32)
1737     {
1738         bytes memory _temp = bytes(_input);
1739         uint256 _length = _temp.length;
1740 
1741         //sorry limited to 32 characters
1742         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1743         // make sure it doesnt start with or end with space
1744         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1745         // make sure first two characters are not 0x
1746         if (_temp[0] == 0x30)
1747         {
1748             require(_temp[1] != 0x78, "string cannot start with 0x");
1749             require(_temp[1] != 0x58, "string cannot start with 0X");
1750         }
1751 
1752         // create a bool to track if we have a non number character
1753         bool _hasNonNumber;
1754 
1755         // convert & check
1756         for (uint256 i = 0; i < _length; i++)
1757         {
1758             // if its uppercase A-Z
1759             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1760             {
1761                 // convert to lower case a-z
1762                 _temp[i] = byte(uint(_temp[i]) + 32);
1763 
1764                 // we have a non number
1765                 if (_hasNonNumber == false)
1766                     _hasNonNumber = true;
1767             } else {
1768                 require
1769                 (
1770                     // require character is a space
1771                     _temp[i] == 0x20 ||
1772                     // OR lowercase a-z
1773                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1774                     // or 0-9
1775                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1776                     "string contains invalid characters"
1777                 );
1778                 // make sure theres not 2x spaces in a row
1779                 if (_temp[i] == 0x20)
1780                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1781 
1782                 // see if we have a character other than a number
1783                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1784                     _hasNonNumber = true;
1785             }
1786         }
1787 
1788         require(_hasNonNumber == true, "string cannot be only numbers");
1789 
1790         bytes32 _ret;
1791         assembly {
1792             _ret := mload(add(_temp, 32))
1793         }
1794         return (_ret);
1795     }
1796 }
1797 
1798 /**
1799  * @title SafeMath v0.1.9
1800  * @dev Math operations with safety checks that throw on error
1801  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1802  * - added sqrt
1803  * - added sq
1804  * - added pwr
1805  * - changed asserts to requires with error log outputs
1806  * - removed div, its useless
1807  */
1808 library SafeMath {
1809 
1810     /**
1811     * @dev Multiplies two numbers, throws on overflow.
1812     */
1813     function mul(uint256 a, uint256 b)
1814         internal
1815         pure
1816         returns (uint256 c)
1817     {
1818         if (a == 0) {
1819             return 0;
1820         }
1821         c = a * b;
1822         require(c / a == b, "SafeMath mul failed");
1823         return c;
1824     }
1825 
1826     /**
1827     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1828     */
1829     function sub(uint256 a, uint256 b)
1830         internal
1831         pure
1832         returns (uint256)
1833     {
1834         require(b <= a, "SafeMath sub failed");
1835         return a - b;
1836     }
1837 
1838     /**
1839     * @dev Adds two numbers, throws on overflow.
1840     */
1841     function add(uint256 a, uint256 b)
1842         internal
1843         pure
1844         returns (uint256 c)
1845     {
1846         c = a + b;
1847         require(c >= a, "SafeMath add failed");
1848         return c;
1849     }
1850 
1851     /**
1852      * @dev gives square root of given x.
1853      */
1854     function sqrt(uint256 x)
1855         internal
1856         pure
1857         returns (uint256 y)
1858     {
1859         uint256 z = ((add(x,1)) / 2);
1860         y = x;
1861         while (z < y)
1862         {
1863             y = z;
1864             z = ((add((x / z),z)) / 2);
1865         }
1866     }
1867 
1868     /**
1869      * @dev gives square. multiplies x by x
1870      */
1871     function sq(uint256 x)
1872         internal
1873         pure
1874         returns (uint256)
1875     {
1876         return (mul(x,x));
1877     }
1878 
1879     /**
1880      * @dev x to the power of y
1881      */
1882     function pwr(uint256 x, uint256 y)
1883         internal
1884         pure
1885         returns (uint256)
1886     {
1887         if (x==0)
1888             return (0);
1889         else if (y==0)
1890             return (1);
1891         else
1892         {
1893             uint256 z = x;
1894             for (uint256 i=1; i < y; i++)
1895                 z = mul(z,x);
1896             return (z);
1897         }
1898     }
1899 }