1 pragma solidity ^0.4.24;
2 /**
3  * Ready Player ONE
4  * @title -ReadyPlayerONE 
5  */
6 
7 //==============================================================================
8 //     _    _  _ _|_ _  .
9 //    (/_\/(/_| | | _\  .
10 //==============================================================================
11 contract RP1events {
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
39         uint256 rp1Amount,
40         uint256 genAmount,
41         uint256 potAmount,
42         uint256 airDropPot
43     );
44     
45 	// fired whenever theres a withdraw
46     event onWithdraw
47     (
48         uint256 indexed playerID,
49         address playerAddress,
50         bytes32 playerName,
51         uint256 ethOut,
52         uint256 timeStamp
53     );
54     
55     // fired whenever a withdraw forces end round to be ran
56     event onWithdrawAndDistribute
57     (
58         address playerAddress,
59         bytes32 playerName,
60         uint256 ethOut,
61         uint256 compressedData,
62         uint256 compressedIDs,
63         address winnerAddr,
64         bytes32 winnerName,
65         uint256 amountWon,
66         uint256 newPot,
67         uint256 rp1Amount,
68         uint256 genAmount
69     );
70     
71     // (fomo3d long only) fired whenever a player tries a buy after round timer 
72     // hit zero, and causes end round to be ran.
73     event onBuyAndDistribute
74     (
75         address playerAddress,
76         bytes32 playerName,
77         uint256 ethIn,
78         uint256 compressedData,
79         uint256 compressedIDs,
80         address winnerAddr,
81         bytes32 winnerName,
82         uint256 amountWon,
83         uint256 newPot,
84         uint256 rp1Amount,
85         uint256 genAmount
86     );
87     
88     // (fomo3d long only) fired whenever a player tries a reload after round timer 
89     // hit zero, and causes end round to be ran.
90     event onReLoadAndDistribute
91     (
92         address playerAddress,
93         bytes32 playerName,
94         uint256 compressedData,
95         uint256 compressedIDs,
96         address winnerAddr,
97         bytes32 winnerName,
98         uint256 amountWon,
99         uint256 newPot,
100         uint256 rp1Amount,
101         uint256 genAmount
102     );
103     
104     // fired whenever an affiliate is paid
105     event onAffiliatePayout
106     (
107         uint256 indexed affiliateID,
108         address affiliateAddress,
109         bytes32 affiliateName,
110         uint256 indexed roundID,
111         uint256 indexed buyerID,
112         uint256 amount,
113         uint256 timeStamp
114     );
115     
116     // received pot swap deposit
117     event onPotSwapDeposit
118     (
119         uint256 roundID,
120         uint256 amountAddedToPot
121     );
122 }
123 
124 //==============================================================================
125 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
126 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
127 //====================================|=========================================
128 
129 contract modularLong is RP1events {}
130 
131 contract ReadyPlayerONE is modularLong {
132     using SafeMath for *;
133     using NameFilter for string;
134     using RP1KeysCalcLong for uint256;
135 
136     address community_addr = 0x4c20d0ab4baadbce39fe6ac94cefd99b7686339c;
137     address marketing_addr = 0x9386b3cc1155764b60ca81fc83761777f6487ac3;
138 
139     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x15247cF99b5870F54EA17e85E1aF8667a58a6644);
140 //==============================================================================
141 //     _ _  _  |`. _     _ _ |_ | _  _  .
142 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
143 //=================_|===========================================================
144     string constant public name = "Ready Player ONE";
145     string constant public symbol = "RP1";
146     uint256 private rndGap_ = 0;                                // length of ICO phase, set to 1 year for EOS.
147     //todo  1hours
148     uint256 constant private rndInit_ = 1 hours;             // round timer starts at this
149     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
150     uint256 constant private rndMax_ = 12 hours;                // max length a round timer can be
151 //==============================================================================
152 //     _| _ _|_ _    _ _ _|_    _   .
153 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
154 //=============================|================================================
155 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
156     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
157     uint256 public rID_;    // round id number / total rounds that have happened
158 //****************
159 // PLAYER DATA 
160 //****************
161     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
162     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
163     mapping (uint256 => RP1datasets.Player) public plyr_;   // (pID => data) player data
164     mapping (uint256 => mapping (uint256 => RP1datasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
165     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
166 //****************
167 // ROUND DATA 
168 //****************
169     mapping (uint256 => RP1datasets.Round) public round_;   // (rID => data) round data
170     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
171 //****************
172 // TEAM FEE DATA 
173 //****************
174     mapping (uint256 => RP1datasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
175     mapping (uint256 => RP1datasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
176 //==============================================================================
177 //     _ _  _  __|_ _    __|_ _  _  .
178 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
179 //==============================================================================
180     constructor()
181         public
182     {
183 
184 	    //玄武 计算的 100-30-18
185         fees_[0] = RP1datasets.TeamFee(30,0);   //52% to pot, 12% to aff, 2% to com, 1% to pot swap, 3% to air drop pot
186         //白虎
187         fees_[1] = RP1datasets.TeamFee(41,0);   //41% to pot, 12% to aff, 2% to com, 1% to pot swap, 3% to air drop pot
188         //青龙
189         fees_[2] = RP1datasets.TeamFee(60,0);   //22% to pot, 12% to aff, 2% to com, 1% to pot swap, 3% to air drop pot
190         //朱雀
191         fees_[3] = RP1datasets.TeamFee(46,0);   //36% to pot, 12% to aff, 2% to com, 1% to pot swap, 3% to air drop pot
192         
193         // (分红, 推广经费)
194         potSplit_[0] = RP1datasets.PotSplit(18,4);  //58% to winner, 18% to next round, 2% to com
195         potSplit_[1] = RP1datasets.PotSplit(25,0);  //58% to winner, 15% to next round, 2% to com
196         potSplit_[2] = RP1datasets.PotSplit(22,8);  //58% to winner, 10% to next round, 2% to com
197         potSplit_[3] = RP1datasets.PotSplit(32,2);  //58% to winner,  6% to next round, 2% to com
198 	}
199 //==============================================================================
200 //     _ _  _  _|. |`. _  _ _  .
201 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
202 //==============================================================================
203     /**
204      * @dev used to make sure no one can interact with contract until it has 
205      * been activated. 
206      */
207     modifier isActivated() {
208         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
209         _;
210     }
211     
212     /**
213      * @dev prevents contracts from interacting with fomo3d 
214      */
215     modifier isHuman() {
216         address _addr = msg.sender;
217         uint256 _codeLength;
218         
219         assembly {_codeLength := extcodesize(_addr)}
220         require(_codeLength == 0, "sorry humans only");
221         _;
222     }
223 
224     /**
225      * @dev sets boundaries for incoming tx 
226      */
227     modifier isWithinLimits(uint256 _eth) {
228         require(_eth >= 1000000000, "pocket lint: not a valid currency");
229         require(_eth <= 100000000000000000000000, "no vitalik, no");
230         _;    
231     }
232     
233 //==============================================================================
234 //     _    |_ |. _   |`    _  __|_. _  _  _  .
235 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
236 //====|=========================================================================
237     /**
238      * @dev emergency buy uses last stored affiliate ID and team snek
239      */
240     function()
241         isActivated()
242         isHuman()
243         isWithinLimits(msg.value)
244         public
245         payable
246     {
247         // set up our tx event data and determine if player is new or not
248         RP1datasets.EventReturns memory _eventData_ = determinePID(_eventData_);
249             
250         // fetch player id
251         uint256 _pID = pIDxAddr_[msg.sender];
252         
253         // buy core 
254         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
255     }
256     
257     /**
258      * @dev converts all incoming ethereum to keys.
259      * -functionhash- 0x8f38f309 (using ID for affiliate)
260      * -functionhash- 0x98a0871d (using address for affiliate)
261      * -functionhash- 0xa65b37a1 (using name for affiliate)
262      * @param _affCode the ID/address/name of the player who gets the affiliate fee
263      * @param _team what team is the player playing for?
264      */
265     function buyXid(uint256 _affCode, uint256 _team)
266         isActivated()
267         isHuman()
268         isWithinLimits(msg.value)
269         public
270         payable
271     {
272         // set up our tx event data and determine if player is new or not
273         RP1datasets.EventReturns memory _eventData_ = determinePID(_eventData_);
274         
275         // fetch player id
276         uint256 _pID = pIDxAddr_[msg.sender];
277         
278         // manage affiliate residuals
279         // if no affiliate code was given or player tried to use their own, lolz
280         if (_affCode == 0 || _affCode == _pID)
281         {
282             // use last stored affiliate code 
283             _affCode = plyr_[_pID].laff;
284             
285         // if affiliate code was given & its not the same as previously stored 
286         } else if (_affCode != plyr_[_pID].laff) {
287             // update last affiliate 
288             plyr_[_pID].laff = _affCode;
289         }
290         
291         // verify a valid team was selected
292         _team = verifyTeam(_team);
293         
294         // buy core 
295         buyCore(_pID, _affCode, _team, _eventData_);
296     }
297     
298     function buyXaddr(address _affCode, uint256 _team)
299         isActivated()
300         isHuman()
301         isWithinLimits(msg.value)
302         public
303         payable
304     {
305         // set up our tx event data and determine if player is new or not
306         RP1datasets.EventReturns memory _eventData_ = determinePID(_eventData_);
307         
308         // fetch player id
309         uint256 _pID = pIDxAddr_[msg.sender];
310         
311         // manage affiliate residuals
312         uint256 _affID;
313         // if no affiliate code was given or player tried to use their own, lolz
314         if (_affCode == address(0) || _affCode == msg.sender)
315         {
316             // use last stored affiliate code
317             _affID = plyr_[_pID].laff;
318         
319         // if affiliate code was given    
320         } else {
321             // get affiliate ID from aff Code 
322             _affID = pIDxAddr_[_affCode];
323             
324             // if affID is not the same as previously stored 
325             if (_affID != plyr_[_pID].laff)
326             {
327                 // update last affiliate
328                 plyr_[_pID].laff = _affID;
329             }
330         }
331         
332         // verify a valid team was selected
333         _team = verifyTeam(_team);
334         
335         // buy core 
336         buyCore(_pID, _affID, _team, _eventData_);
337     }
338     
339     function buyXname(bytes32 _affCode, uint256 _team)
340         isActivated()
341         isHuman()
342         isWithinLimits(msg.value)
343         public
344         payable
345     {
346         // set up our tx event data and determine if player is new or not
347         RP1datasets.EventReturns memory _eventData_ = determinePID(_eventData_);
348         
349         // fetch player id
350         uint256 _pID = pIDxAddr_[msg.sender];
351         
352         // manage affiliate residuals
353         uint256 _affID;
354         // if no affiliate code was given or player tried to use their own, lolz
355         if (_affCode == '' || _affCode == plyr_[_pID].name)
356         {
357             // use last stored affiliate code
358             _affID = plyr_[_pID].laff;
359         
360         // if affiliate code was given
361         } else {
362             // get affiliate ID from aff Code
363             _affID = pIDxName_[_affCode];
364             
365             // if affID is not the same as previously stored
366             if (_affID != plyr_[_pID].laff)
367             {
368                 // update last affiliate
369                 plyr_[_pID].laff = _affID;
370             }
371         }
372         
373         // verify a valid team was selected
374         _team = verifyTeam(_team);
375         
376         // buy core 
377         buyCore(_pID, _affID, _team, _eventData_);
378     }
379     
380     /**
381      * @dev essentially the same as buy, but instead of you sending ether 
382      * from your wallet, it uses your unwithdrawn earnings.
383      * -functionhash- 0x349cdcac (using ID for affiliate)
384      * -functionhash- 0x82bfc739 (using address for affiliate)
385      * -functionhash- 0x079ce327 (using name for affiliate)
386      * @param _affCode the ID/address/name of the player who gets the affiliate fee
387      * @param _team what team is the player playing for?
388      * @param _eth amount of earnings to use (remainder returned to gen vault)
389      */
390     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
391         isActivated()
392         isHuman()
393         isWithinLimits(_eth)
394         public
395     {
396         // set up our tx event data
397         RP1datasets.EventReturns memory _eventData_;
398         
399         // fetch player ID
400         uint256 _pID = pIDxAddr_[msg.sender];
401         
402         // manage affiliate residuals
403         // if no affiliate code was given or player tried to use their own, lolz
404         if (_affCode == 0 || _affCode == _pID)
405         {
406             // use last stored affiliate code 
407             _affCode = plyr_[_pID].laff;
408             
409         // if affiliate code was given & its not the same as previously stored 
410         } else if (_affCode != plyr_[_pID].laff) {
411             // update last affiliate 
412             plyr_[_pID].laff = _affCode;
413         }
414 
415         // verify a valid team was selected
416         _team = verifyTeam(_team);
417 
418         // reload core
419         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
420     }
421     
422     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
423         isActivated()
424         isHuman()
425         isWithinLimits(_eth)
426         public
427     {
428         // set up our tx event data
429         RP1datasets.EventReturns memory _eventData_;
430         
431         // fetch player ID
432         uint256 _pID = pIDxAddr_[msg.sender];
433         
434         // manage affiliate residuals
435         uint256 _affID;
436         // if no affiliate code was given or player tried to use their own, lolz
437         if (_affCode == address(0) || _affCode == msg.sender)
438         {
439             // use last stored affiliate code
440             _affID = plyr_[_pID].laff;
441         
442         // if affiliate code was given    
443         } else {
444             // get affiliate ID from aff Code 
445             _affID = pIDxAddr_[_affCode];
446             
447             // if affID is not the same as previously stored 
448             if (_affID != plyr_[_pID].laff)
449             {
450                 // update last affiliate
451                 plyr_[_pID].laff = _affID;
452             }
453         }
454         
455         // verify a valid team was selected
456         _team = verifyTeam(_team);
457         
458         // reload core
459         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
460     }
461     
462     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
463         isActivated()
464         isHuman()
465         isWithinLimits(_eth)
466         public
467     {
468         // set up our tx event data
469         RP1datasets.EventReturns memory _eventData_;
470         
471         // fetch player ID
472         uint256 _pID = pIDxAddr_[msg.sender];
473         
474         // manage affiliate residuals
475         uint256 _affID;
476         // if no affiliate code was given or player tried to use their own, lolz
477         if (_affCode == '' || _affCode == plyr_[_pID].name)
478         {
479             // use last stored affiliate code
480             _affID = plyr_[_pID].laff;
481         
482         // if affiliate code was given
483         } else {
484             // get affiliate ID from aff Code
485             _affID = pIDxName_[_affCode];
486             
487             // if affID is not the same as previously stored
488             if (_affID != plyr_[_pID].laff)
489             {
490                 // update last affiliate
491                 plyr_[_pID].laff = _affID;
492             }
493         }
494         
495         // verify a valid team was selected
496         _team = verifyTeam(_team);
497         
498         // reload core
499         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
500     }
501 
502     /**
503      * @dev withdraws all of your earnings.
504      * -functionhash- 0x3ccfd60b
505      */
506     function withdraw()
507         isActivated()
508         isHuman()
509         public
510     {
511         // setup local rID 
512         uint256 _rID = rID_;
513         
514         // grab time
515         uint256 _now = now;
516         
517         // fetch player ID
518         uint256 _pID = pIDxAddr_[msg.sender];
519         
520         // setup temp var for player eth
521         uint256 _eth;
522         
523         // check to see if round has ended and no one has run round end yet
524         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
525         {
526             // set up our tx event data
527             RP1datasets.EventReturns memory _eventData_;
528             
529             // end the round (distributes pot)
530 			round_[_rID].ended = true;
531             _eventData_ = endRound(_eventData_);
532             
533 			// get their earnings
534             _eth = withdrawEarnings(_pID);
535             
536             // gib moni
537             if (_eth > 0)
538                 plyr_[_pID].addr.transfer(_eth);    
539             
540             // build event data
541             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
542             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
543             
544             // fire withdraw and distribute event
545             emit RP1events.onWithdrawAndDistribute
546             (
547                 msg.sender, 
548                 plyr_[_pID].name, 
549                 _eth, 
550                 _eventData_.compressedData, 
551                 _eventData_.compressedIDs, 
552                 _eventData_.winnerAddr, 
553                 _eventData_.winnerName, 
554                 _eventData_.amountWon, 
555                 _eventData_.newPot, 
556                 _eventData_.rp1Amount, 
557                 _eventData_.genAmount
558             );
559             
560         // in any other situation
561         } else {
562             // get their earnings
563             _eth = withdrawEarnings(_pID);
564             
565             // gib moni
566             if (_eth > 0)
567                 plyr_[_pID].addr.transfer(_eth);
568             
569             // fire withdraw event
570             emit RP1events.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
571         }
572     }
573     
574     /**
575      * @dev use these to register names.  they are just wrappers that will send the
576      * registration requests to the PlayerBook contract.  So registering here is the 
577      * same as registering there.  UI will always display the last name you registered.
578      * but you will still own all previously registered names to use as affiliate 
579      * links.
580      * - must pay a registration fee.
581      * - name must be unique
582      * - names will be converted to lowercase
583      * - name cannot start or end with a space 
584      * - cannot have more than 1 space in a row
585      * - cannot be only numbers
586      * - cannot start with 0x 
587      * - name must be at least 1 char
588      * - max length of 32 characters long
589      * - allowed characters: a-z, 0-9, and space
590      * -functionhash- 0x921dec21 (using ID for affiliate)
591      * -functionhash- 0x3ddd4698 (using address for affiliate)
592      * -functionhash- 0x685ffd83 (using name for affiliate)
593      * @param _nameString players desired name
594      * @param _affCode affiliate ID, address, or name of who referred you
595      * @param _all set to true if you want this to push your info to all games 
596      * (this might cost a lot of gas)
597      */
598     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
599         isHuman()
600         public
601         payable
602     {
603         bytes32 _name = _nameString.nameFilter();
604         address _addr = msg.sender;
605         uint256 _paid = msg.value;
606         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
607         
608         uint256 _pID = pIDxAddr_[_addr];
609         
610         // fire event
611         emit RP1events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
612     }
613     
614     function registerNameXaddr(string _nameString, address _affCode, bool _all)
615         isHuman()
616         public
617         payable
618     {
619         bytes32 _name = _nameString.nameFilter();
620         address _addr = msg.sender;
621         uint256 _paid = msg.value;
622         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
623         
624         uint256 _pID = pIDxAddr_[_addr];
625         
626         // fire event
627         emit RP1events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
628     }
629     
630     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
631         isHuman()
632         public
633         payable
634     {
635         bytes32 _name = _nameString.nameFilter();
636         address _addr = msg.sender;
637         uint256 _paid = msg.value;
638         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
639         
640         uint256 _pID = pIDxAddr_[_addr];
641         
642         // fire event
643         emit RP1events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
644     }
645 //==============================================================================
646 //     _  _ _|__|_ _  _ _  .
647 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
648 //=====_|=======================================================================
649     /**
650      * @dev return the price buyer will pay for next 1 individual key.
651      * -functionhash- 0x018a25e8
652      * @return price for next key bought (in wei format)
653      */
654     function getBuyPrice()
655         public 
656         view 
657         returns(uint256)
658     {  
659         // setup local rID
660         uint256 _rID = rID_;
661         
662         // grab time
663         uint256 _now = now;
664         
665         // are we in a round?
666         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
667             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
668         else // rounds over.  need price for new round
669             return ( 75000000000000 ); // init
670     }
671     
672     /**
673      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
674      * provider
675      * -functionhash- 0xc7e284b8
676      * @return time left in seconds
677      */
678     function getTimeLeft()
679         public
680         view
681         returns(uint256)
682     {
683         // setup local rID
684         uint256 _rID = rID_;
685         
686         // grab time
687         uint256 _now = now;
688         
689         if (_now < round_[_rID].end)
690             if (_now > round_[_rID].strt + rndGap_)
691                 return( (round_[_rID].end).sub(_now) );
692             else
693                 return( (round_[_rID].strt + rndGap_).sub(_now) );
694         else
695             return(0);
696     }
697     
698     /**
699      * @dev returns player earnings per vaults 
700      * -functionhash- 0x63066434
701      * @return winnings vault
702      * @return general vault
703      * @return affiliate vault
704      */
705     function getPlayerVaults(uint256 _pID)
706         public
707         view
708         returns(uint256 ,uint256, uint256)
709     {
710         // setup local rID
711         uint256 _rID = rID_;
712         
713         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
714         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
715         {
716             // if player is winner 
717             if (round_[_rID].plyr == _pID)
718             {
719                 return
720                 (
721                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(58)) / 100 ),
722                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
723                     plyr_[_pID].aff
724                 );
725             // if player is not the winner
726             } else {
727                 return
728                 (
729                     plyr_[_pID].win,
730                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
731                     plyr_[_pID].aff
732                 );
733             }
734             
735         // if round is still going on, or round has ended and round end has been ran
736         } else {
737             return
738             (
739                 plyr_[_pID].win,
740                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
741                 plyr_[_pID].aff
742             );
743         }
744     }
745     
746     /**
747      * solidity hates stack limits.  this lets us avoid that hate 
748      */
749     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
750         private
751         view
752         returns(uint256)
753     {
754         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
755     }
756     
757     /**
758      * @dev returns all current round info needed for front end
759      * -functionhash- 0x747dff42
760      * @return eth invested during ICO phase
761      * @return round id 
762      * @return total keys for round 
763      * @return time round ends
764      * @return time round started
765      * @return current pot 
766      * @return current team ID & player ID in lead 
767      * @return current player in leads address 
768      * @return current player in leads name
769      * @return whales eth in for round
770      * @return bears eth in for round
771      * @return sneks eth in for round
772      * @return bulls eth in for round
773      * @return airdrop tracker # & airdrop pot
774      */
775     function getCurrentRoundInfo()
776         public
777         view
778         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
779     {
780         // setup local rID
781         uint256 _rID = rID_;
782         
783         return
784         (
785             round_[_rID].ico,               //0
786             _rID,                           //1
787             round_[_rID].keys,              //2
788             round_[_rID].end,               //3
789             round_[_rID].strt,              //4
790             round_[_rID].pot,               //5
791             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
792             plyr_[round_[_rID].plyr].addr,  //7
793             plyr_[round_[_rID].plyr].name,  //8
794             rndTmEth_[_rID][0],             //9
795             rndTmEth_[_rID][1],             //10
796             rndTmEth_[_rID][2],             //11
797             rndTmEth_[_rID][3],             //12
798             airDropTracker_ + (airDropPot_ * 1000)              //13
799         );
800     }
801 
802     /**
803      * @dev returns player info based on address.  if no address is given, it will 
804      * use msg.sender 
805      * -functionhash- 0xee0b5d8b
806      * @param _addr address of the player you want to lookup 
807      * @return player ID 
808      * @return player name
809      * @return keys owned (current round)
810      * @return winnings vault
811      * @return general vault 
812      * @return affiliate vault 
813 	 * @return player round eth
814      */
815     function getPlayerInfoByAddress(address _addr)
816         public 
817         view 
818         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
819     {
820         // setup local rID
821         uint256 _rID = rID_;
822         
823         if (_addr == address(0))
824         {
825             _addr == msg.sender;
826         }
827         uint256 _pID = pIDxAddr_[_addr];
828         
829         return
830         (
831             _pID,                               //0
832             plyr_[_pID].name,                   //1
833             plyrRnds_[_pID][_rID].keys,         //2
834             plyr_[_pID].win,                    //3
835             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
836             plyr_[_pID].aff,                    //5
837             plyrRnds_[_pID][_rID].eth           //6
838         );
839     }
840 
841 //==============================================================================
842 //     _ _  _ _   | _  _ . _  .
843 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
844 //=====================_|=======================================================
845     /**
846      * @dev logic runs whenever a buy order is executed.  determines how to handle 
847      * incoming eth depending on if we are in an active round or not
848      */
849     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, RP1datasets.EventReturns memory _eventData_)
850         private
851     {
852         // setup local rID
853         uint256 _rID = rID_;
854         
855         // grab time
856         uint256 _now = now;
857         
858         // if round is active
859         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
860         {
861             // call core 
862             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
863         
864         // if round is not active     
865         } else {
866             // check to see if end round needs to be ran
867             if (_now > round_[_rID].end && round_[_rID].ended == false) 
868             {
869                 // end the round (distributes pot) & start new round
870 			    round_[_rID].ended = true;
871                 _eventData_ = endRound(_eventData_);
872                 
873                 // build event data
874                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
875                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
876                 
877                 // fire buy and distribute event 
878                 emit RP1events.onBuyAndDistribute
879                 (
880                     msg.sender, 
881                     plyr_[_pID].name, 
882                     msg.value, 
883                     _eventData_.compressedData, 
884                     _eventData_.compressedIDs, 
885                     _eventData_.winnerAddr, 
886                     _eventData_.winnerName, 
887                     _eventData_.amountWon, 
888                     _eventData_.newPot, 
889                     _eventData_.rp1Amount, 
890                     _eventData_.genAmount
891                 );
892             }
893             
894             // put eth in players vault 
895             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
896         }
897     }
898     
899     /**
900      * @dev logic runs whenever a reload order is executed.  determines how to handle 
901      * incoming eth depending on if we are in an active round or not 
902      */
903     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, RP1datasets.EventReturns memory _eventData_)
904         private
905     {
906         // setup local rID
907         uint256 _rID = rID_;
908         
909         // grab time
910         uint256 _now = now;
911         
912         // if round is active
913         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
914         {
915             // get earnings from all vaults and return unused to gen vault
916             // because we use a custom safemath library.  this will throw if player 
917             // tried to spend more eth than they have.
918             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
919             
920             // call core 
921             core(_rID, _pID, _eth, _affID, _team, _eventData_);
922         
923         // if round is not active and end round needs to be ran   
924         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
925             // end the round (distributes pot) & start new round
926             round_[_rID].ended = true;
927             _eventData_ = endRound(_eventData_);
928                 
929             // build event data
930             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
931             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
932                 
933             // fire buy and distribute event 
934             emit RP1events.onReLoadAndDistribute
935             (
936                 msg.sender, 
937                 plyr_[_pID].name, 
938                 _eventData_.compressedData, 
939                 _eventData_.compressedIDs, 
940                 _eventData_.winnerAddr, 
941                 _eventData_.winnerName, 
942                 _eventData_.amountWon, 
943                 _eventData_.newPot, 
944                 _eventData_.rp1Amount, 
945                 _eventData_.genAmount
946             );
947         }
948     }
949     
950     /**
951      * @dev this is the core logic for any buy/reload that happens while a round 
952      * is live.
953      */
954     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, RP1datasets.EventReturns memory _eventData_)
955         private
956     {
957         // if player is new to round
958         if (plyrRnds_[_pID][_rID].keys == 0)
959             _eventData_ = managePlayer(_pID, _eventData_);
960         
961         // early round eth limiter 100eth 1eth
962         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
963         {
964             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
965             uint256 _refund = _eth.sub(_availableLimit);
966             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
967             _eth = _availableLimit;
968         }
969         
970         // if eth left is greater than min eth allowed (sorry no pocket lint)
971         if (_eth > 1000000000) 
972         {
973             
974             // mint the new keys
975             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
976             
977             // if they bought at least 1 whole key
978             if (_keys >= 1000000000000000000)
979             {
980             updateTimer(_keys, _rID);
981 
982             // set new leaders
983             if (round_[_rID].plyr != _pID)
984                 round_[_rID].plyr = _pID;  
985             if (round_[_rID].team != _team)
986                 round_[_rID].team = _team; 
987             
988             // set the new leader bool to true
989             _eventData_.compressedData = _eventData_.compressedData + 100;
990         }
991             
992             // manage airdrops
993             if (_eth >= 100000000000000000)
994             {
995             airDropTracker_++;
996             if (airdrop() == true)
997             {
998                 // gib muni
999                 uint256 _prize;
1000                 if (_eth >= 10000000000000000000)
1001                 {
1002                     // calculate prize and give it to winner
1003                     _prize = ((airDropPot_).mul(75)) / 100;
1004                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1005                     
1006                     // adjust airDropPot 
1007                     airDropPot_ = (airDropPot_).sub(_prize);
1008                     
1009                     // let event know a tier 3 prize was won 
1010                     _eventData_.compressedData += 300000000000000000000000000000000;
1011                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1012                     // calculate prize and give it to winner
1013                     _prize = ((airDropPot_).mul(50)) / 100;
1014                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1015                     
1016                     // adjust airDropPot 
1017                     airDropPot_ = (airDropPot_).sub(_prize);
1018                     
1019                     // let event know a tier 2 prize was won 
1020                     _eventData_.compressedData += 200000000000000000000000000000000;
1021                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1022                     // calculate prize and give it to winner
1023                     _prize = ((airDropPot_).mul(25)) / 100;
1024                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1025                     
1026                     // adjust airDropPot 
1027                     airDropPot_ = (airDropPot_).sub(_prize);
1028                     
1029                     // let event know a tier 3 prize was won 
1030                     _eventData_.compressedData += 300000000000000000000000000000000;
1031                 }
1032                 // set airdrop happened bool to true
1033                 _eventData_.compressedData += 10000000000000000000000000000000;
1034                 // let event know how much was won 
1035                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1036                 
1037                 // reset air drop tracker
1038                 airDropTracker_ = 0;
1039             }
1040         }
1041     
1042             // store the air drop tracker number (number of buys since last airdrop)
1043             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1044             
1045             // update player 
1046             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1047             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1048             
1049             // update round
1050             round_[_rID].keys = _keys.add(round_[_rID].keys);
1051             round_[_rID].eth = _eth.add(round_[_rID].eth);
1052             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1053     
1054             // distribute eth
1055             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1056             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1057             
1058             // call end tx function to fire end tx event.
1059 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1060         }
1061     }
1062 //==============================================================================
1063 //     _ _ | _   | _ _|_ _  _ _  .
1064 //    (_(_||(_|_||(_| | (_)| _\  .
1065 //==============================================================================
1066     /**
1067      * @dev calculates unmasked earnings (just calculates, does not update mask)
1068      * @return earnings in wei format
1069      */
1070     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1071         private
1072         view
1073         returns(uint256)
1074     {
1075         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1076     }
1077     
1078     /** 
1079      * @dev returns the amount of keys you would get given an amount of eth. 
1080      * -functionhash- 0xce89c80c
1081      * @param _rID round ID you want price for
1082      * @param _eth amount of eth sent in 
1083      * @return keys received 
1084      */
1085     function calcKeysReceived(uint256 _rID, uint256 _eth)
1086         public
1087         view
1088         returns(uint256)
1089     {
1090         // grab time
1091         uint256 _now = now;
1092         
1093         // are we in a round?
1094         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1095             return ( (round_[_rID].eth).keysRec(_eth) );
1096         else // rounds over.  need keys for new round
1097             return ( (_eth).keys() );
1098     }
1099     
1100     /** 
1101      * @dev returns current eth price for X keys.  
1102      * -functionhash- 0xcf808000
1103      * @param _keys number of keys desired (in 18 decimal format)
1104      * @return amount of eth needed to send
1105      */
1106     function iWantXKeys(uint256 _keys)
1107         public
1108         view
1109         returns(uint256)
1110     {
1111         // setup local rID
1112         uint256 _rID = rID_;
1113         
1114         // grab time
1115         uint256 _now = now;
1116         
1117         // are we in a round?
1118         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1119             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1120         else // rounds over.  need price for new round
1121             return ( (_keys).eth() );
1122     }
1123 //==============================================================================
1124 //    _|_ _  _ | _  .
1125 //     | (_)(_)|_\  .
1126 //==============================================================================
1127     /**
1128 	 * @dev receives name/player info from names contract 
1129      */
1130     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1131         external
1132     {
1133         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1134         if (pIDxAddr_[_addr] != _pID)
1135             pIDxAddr_[_addr] = _pID;
1136         if (pIDxName_[_name] != _pID)
1137             pIDxName_[_name] = _pID;
1138         if (plyr_[_pID].addr != _addr)
1139             plyr_[_pID].addr = _addr;
1140         if (plyr_[_pID].name != _name)
1141             plyr_[_pID].name = _name;
1142         if (plyr_[_pID].laff != _laff)
1143             plyr_[_pID].laff = _laff;
1144         if (plyrNames_[_pID][_name] == false)
1145             plyrNames_[_pID][_name] = true;
1146     }
1147     
1148     /**
1149      * @dev receives entire player name list 
1150      */
1151     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1152         external
1153     {
1154         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1155         if(plyrNames_[_pID][_name] == false)
1156             plyrNames_[_pID][_name] = true;
1157     }   
1158         
1159     /**
1160      * @dev gets existing or registers new pID.  use this when a player may be new
1161      * @return pID 
1162      */
1163     function determinePID(RP1datasets.EventReturns memory _eventData_)
1164         private
1165         returns (RP1datasets.EventReturns)
1166     {
1167         uint256 _pID = pIDxAddr_[msg.sender];
1168         // if player is new to this version of fomo3d
1169         if (_pID == 0)
1170         {
1171             // grab their player ID, name and last aff ID, from player names contract 
1172             _pID = PlayerBook.getPlayerID(msg.sender);
1173             bytes32 _name = PlayerBook.getPlayerName(_pID);
1174             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1175             
1176             // set up player account 
1177             pIDxAddr_[msg.sender] = _pID;
1178             plyr_[_pID].addr = msg.sender;
1179             
1180             if (_name != "")
1181             {
1182                 pIDxName_[_name] = _pID;
1183                 plyr_[_pID].name = _name;
1184                 plyrNames_[_pID][_name] = true;
1185             }
1186             
1187             if (_laff != 0 && _laff != _pID)
1188                 plyr_[_pID].laff = _laff;
1189             
1190             // set the new player bool to true
1191             _eventData_.compressedData = _eventData_.compressedData + 1;
1192         } 
1193         return (_eventData_);
1194     }
1195     
1196     /**
1197      * @dev checks to make sure user picked a valid team.  if not sets team 
1198      * to default (sneks)
1199      */
1200     function verifyTeam(uint256 _team)
1201         private
1202         pure
1203         returns (uint256)
1204     {
1205         if (_team < 0 || _team > 3)
1206             return(2);
1207         else
1208             return(_team);
1209     }
1210     
1211     /**
1212      * @dev decides if round end needs to be run & new round started.  and if 
1213      * player unmasked earnings from previously played rounds need to be moved.
1214      */
1215     function managePlayer(uint256 _pID, RP1datasets.EventReturns memory _eventData_)
1216         private
1217         returns (RP1datasets.EventReturns)
1218     {
1219         // if player has played a previous round, move their unmasked earnings
1220         // from that round to gen vault.
1221         if (plyr_[_pID].lrnd != 0)
1222             updateGenVault(_pID, plyr_[_pID].lrnd);
1223             
1224         // update player's last round played
1225         plyr_[_pID].lrnd = rID_;
1226             
1227         // set the joined round bool to true
1228         _eventData_.compressedData = _eventData_.compressedData + 10;
1229         
1230         return(_eventData_);
1231     }
1232     
1233     /**
1234      * @dev ends the round. manages paying out winner/splitting up pot
1235      */
1236     function endRound(RP1datasets.EventReturns memory _eventData_)
1237         private
1238         returns (RP1datasets.EventReturns)
1239     {
1240         // setup local rID
1241         uint256 _rID = rID_;
1242         
1243         // grab our winning player and team id's
1244         uint256 _winPID = round_[_rID].plyr;
1245         uint256 _winTID = round_[_rID].team;
1246         
1247         // grab our pot amount
1248         uint256 _pot = round_[_rID].pot;
1249         
1250         // calculate our winner share, community rewards, gen share, 
1251         // rp1 share, and amount reserved for next pot 
1252         uint256 _win = (_pot.mul(58)) / 100;
1253         uint256 _com = (_pot / 50);
1254         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1255         uint256 _rp1 = (_pot.mul(potSplit_[_winTID].rp1)) / 100;
1256         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_rp1);
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
1270         // community rewards
1271         community_addr.transfer(_com);
1272     
1273         
1274         // distribute gen portion to key holders
1275         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1276         
1277         // for next round 修改
1278         if (_rp1 > 0){
1279             _res = _res.add(_rp1);
1280         }
1281             
1282         // prepare event data
1283         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1284         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1285         _eventData_.winnerAddr = plyr_[_winPID].addr;
1286         _eventData_.winnerName = plyr_[_winPID].name;
1287         _eventData_.amountWon = _win;
1288         _eventData_.genAmount = _gen;
1289         _eventData_.rp1Amount = _rp1;
1290         _eventData_.newPot = _res;
1291         
1292         // start next round
1293         rID_++;
1294         _rID++;
1295         round_[_rID].strt = now;
1296         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1297         round_[_rID].pot = _res;
1298         
1299         return(_eventData_);
1300     }
1301     
1302     /**
1303      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1304      */
1305     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1306         private 
1307     {
1308         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1309         if (_earnings > 0)
1310         {
1311             // put in gen vault
1312             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1313             // zero out their earnings by updating mask
1314             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1315         }
1316     }
1317     
1318     /**
1319      * @dev updates round timer based on number of whole keys bought.
1320      */
1321     function updateTimer(uint256 _keys, uint256 _rID)
1322         private
1323     {
1324         // grab time
1325         uint256 _now = now;
1326         
1327         // calculate time based on number of keys bought
1328         uint256 _newTime;
1329         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1330             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1331         else
1332             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1333         
1334         // compare to max and set new end time
1335         if (_newTime < (rndMax_).add(_now))
1336             round_[_rID].end = _newTime;
1337         else
1338             round_[_rID].end = rndMax_.add(_now);
1339     }
1340     
1341     /**
1342      * @dev generates a random number between 0-99 and checks to see if thats
1343      * resulted in an airdrop win
1344      * @return do we have a winner?
1345      */
1346     function airdrop()
1347         private 
1348         view 
1349         returns(bool)
1350     {
1351         uint256 seed = uint256(keccak256(abi.encodePacked(
1352             
1353             (block.timestamp).add
1354             (block.difficulty).add
1355             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1356             (block.gaslimit).add
1357             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1358             (block.number)
1359             
1360         )));
1361         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1362             return(true);
1363         else
1364             return(false);
1365     }
1366 
1367     /**
1368      * @dev distributes eth based on fees to com, aff, and rp1
1369      */
1370     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, RP1datasets.EventReturns memory _eventData_)
1371         private
1372         returns(RP1datasets.EventReturns)
1373     {
1374         // pay 2% out to community rewards
1375         uint256 _com = _eth / 50;
1376         uint256 _rp1;
1377 
1378          //修改
1379         community_addr.transfer(_com);
1380         
1381         // pay 1% out to marketing
1382         uint256 _long = _eth / 100;
1383         //修改
1384         marketing_addr.transfer(_long);
1385 
1386         // distribute share to affiliate
1387         uint256 _aff = _eth / 10;
1388         
1389         // decide what to do with affiliate share of fees
1390         // affiliate must not be self, and must have a name registered
1391         if (_affID != _pID && plyr_[_affID].name != '') {
1392             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1393             emit RP1events.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1394         } else {
1395             _rp1 = _aff;
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
1409         emit RP1events.onPotSwapDeposit(_rID, msg.value);
1410     }
1411     
1412     /**
1413      * @dev distributes eth based on fees to gen and pot
1414      */
1415     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, RP1datasets.EventReturns memory _eventData_)
1416         private
1417         returns(RP1datasets.EventReturns)
1418     {
1419         // calculate gen share
1420         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1421         
1422         // toss 3% into airdrop pot 
1423         uint256 _air = (_eth.mul(3) / 100);
1424         airDropPot_ = airDropPot_.add(_air);
1425         
1426         // update eth balance 
1427         _eth = _eth.sub(((_eth.mul(18)) / 100));
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
1506     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, RP1datasets.EventReturns memory _eventData_)
1507         private
1508     {
1509         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1510         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1511         
1512         emit RP1events.onEndTx
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
1524             _eventData_.rp1Amount,
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
1541         
1542         // can only be ran once
1543         require(activated_ == false, "fomo3d already activated");
1544         
1545         // activate the contract 
1546         activated_ = true;
1547         
1548         // lets start first round
1549 		rID_ = 1;
1550         round_[1].strt = now - rndGap_;
1551         round_[1].end = now + rndInit_ ;
1552     }
1553 }
1554 
1555 //==============================================================================
1556 //   __|_ _    __|_ _  .
1557 //  _\ | | |_|(_ | _\  .
1558 //==============================================================================
1559 library RP1datasets {
1560     //compressedData key
1561     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1562         // 0 - new player (bool)
1563         // 1 - joined round (bool)
1564         // 2 - new  leader (bool)
1565         // 3-5 - air drop tracker (uint 0-999)
1566         // 6-16 - round end time
1567         // 17 - winnerTeam
1568         // 18 - 28 timestamp 
1569         // 29 - team
1570         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1571         // 31 - airdrop happened bool
1572         // 32 - airdrop tier 
1573         // 33 - airdrop amount won
1574     //compressedIDs key
1575     // [77-52][51-26][25-0]
1576         // 0-25 - pID 
1577         // 26-51 - winPID
1578         // 52-77 - rID
1579     struct EventReturns {
1580         uint256 compressedData;
1581         uint256 compressedIDs;
1582         address winnerAddr;         // winner address
1583         bytes32 winnerName;         // winner name
1584         uint256 amountWon;          // amount won
1585         uint256 newPot;             // amount in new pot
1586         uint256 rp1Amount;          // amount distributed to rp1
1587         uint256 genAmount;          // amount distributed to gen
1588         uint256 potAmount;          // amount added to pot
1589     }
1590     struct Player {
1591         address addr;   // player address
1592         bytes32 name;   // player name
1593         uint256 win;    // winnings vault
1594         uint256 gen;    // general vault
1595         uint256 aff;    // affiliate vault
1596         uint256 lrnd;   // last round played
1597         uint256 laff;   // last affiliate id used
1598     }
1599     struct PlayerRounds {
1600         uint256 eth;    // eth player has added to round (used for eth limiter)
1601         uint256 keys;   // keys
1602         uint256 mask;   // player mask 
1603         uint256 ico;    // ICO phase investment
1604     }
1605     struct Round {
1606         uint256 plyr;   // pID of player in lead
1607         uint256 team;   // tID of team in lead
1608         uint256 end;    // time ends/ended
1609         bool ended;     // has round end function been ran
1610         uint256 strt;   // time round started
1611         uint256 keys;   // keys
1612         uint256 eth;    // total eth in
1613         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1614         uint256 mask;   // global mask
1615         uint256 ico;    // total eth sent in during ICO phase
1616         uint256 icoGen; // total eth for gen during ICO phase
1617         uint256 icoAvg; // average key price for ICO phase
1618     }
1619     struct TeamFee {
1620         uint256 gen;    // % of buy in thats paid to key holders of current round
1621         uint256 rp1;    // % of buy in thats paid to rp1 holders
1622     }
1623     struct PotSplit {
1624         uint256 gen;    // % of pot thats paid to key holders of current round
1625         uint256 rp1;    // % of pot thats paid to rp1 holders
1626     }
1627 }
1628 
1629 //==============================================================================
1630 //  |  _      _ _ | _  .
1631 //  |<(/_\/  (_(_||(_  .
1632 //=======/======================================================================
1633 library RP1KeysCalcLong {
1634     using SafeMath for *;
1635     /**
1636      * @dev calculates number of keys received given X eth 
1637      * @param _curEth current amount of eth in contract 
1638      * @param _newEth eth being spent
1639      * @return amount of ticket purchased
1640      */
1641     function keysRec(uint256 _curEth, uint256 _newEth)
1642         internal
1643         pure
1644         returns (uint256)
1645     {
1646         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1647     }
1648     
1649     /**
1650      * @dev calculates amount of eth received if you sold X keys 
1651      * @param _curKeys current amount of keys that exist 
1652      * @param _sellKeys amount of keys you wish to sell
1653      * @return amount of eth received
1654      */
1655     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1656         internal
1657         pure
1658         returns (uint256)
1659     {
1660         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1661     }
1662 
1663     /**
1664      * @dev calculates how many keys would exist with given an amount of eth
1665      * @param _eth eth "in contract"
1666      * @return number of keys that would exist
1667      */
1668     function keys(uint256 _eth) 
1669         internal
1670         pure
1671         returns(uint256)
1672     {
1673         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1674     }
1675     
1676     /**
1677      * @dev calculates how much eth would be in contract given a number of keys
1678      * @param _keys number of keys "in contract" 
1679      * @return eth that would exists
1680      */
1681     function eth(uint256 _keys) 
1682         internal
1683         pure
1684         returns(uint256)  
1685     {
1686         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1687     }
1688 }
1689 
1690 //==============================================================================
1691 //  . _ _|_ _  _ |` _  _ _  _  .
1692 //  || | | (/_| ~|~(_|(_(/__\  .
1693 //==============================================================================
1694 interface otherFoMo3D {
1695     function potSwap() external payable;
1696 }
1697 
1698 interface RP1externalSettingsInterface {
1699     function getFastGap() external returns(uint256);
1700     function getLongGap() external returns(uint256);
1701     function getFastExtra() external returns(uint256);
1702     function getLongExtra() external returns(uint256);
1703 }
1704 
1705 interface DiviesInterface {
1706     function deposit() external payable;
1707 }
1708 
1709 interface JIincForwarderInterface {
1710     function deposit() external payable returns(bool);
1711     function status() external view returns(address, address, bool);
1712     function startMigration(address _newCorpBank) external returns(bool);
1713     function cancelMigration() external returns(bool);
1714     function finishMigration() external returns(bool);
1715     function setup(address _firstCorpBank) external;
1716 }
1717 
1718 interface PlayerBookInterface {
1719     function getPlayerID(address _addr) external returns (uint256);
1720     function getPlayerName(uint256 _pID) external view returns (bytes32);
1721     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1722     function getPlayerAddr(uint256 _pID) external view returns (address);
1723     function getNameFee() external view returns (uint256);
1724     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1725     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1726     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1727 }
1728 
1729 /**
1730 * @title -Name Filter- v0.1.9
1731 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1732 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1733 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1734 *                                  _____                      _____
1735 *                                 (, /     /)       /) /)    (, /      /)          /)
1736 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1737 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1738 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1739 *                            (__ /          (_/ (, /                                      /)™ 
1740 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1741 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1742 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1743 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1744 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1745 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1746 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1747 *
1748 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1749 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1750 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1751 */
1752 
1753 library NameFilter {
1754     /**
1755      * @dev filters name strings
1756      * -converts uppercase to lower case.  
1757      * -makes sure it does not start/end with a space
1758      * -makes sure it does not contain multiple spaces in a row
1759      * -cannot be only numbers
1760      * -cannot start with 0x 
1761      * -restricts characters to A-Z, a-z, 0-9, and space.
1762      * @return reprocessed string in bytes32 format
1763      */
1764     function nameFilter(string _input)
1765         internal
1766         pure
1767         returns(bytes32)
1768     {
1769         bytes memory _temp = bytes(_input);
1770         uint256 _length = _temp.length;
1771         
1772         //sorry limited to 32 characters
1773         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1774         // make sure it doesnt start with or end with space
1775         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1776         // make sure first two characters are not 0x
1777         if (_temp[0] == 0x30)
1778         {
1779             require(_temp[1] != 0x78, "string cannot start with 0x");
1780             require(_temp[1] != 0x58, "string cannot start with 0X");
1781         }
1782         
1783         // create a bool to track if we have a non number character
1784         bool _hasNonNumber;
1785         
1786         // convert & check
1787         for (uint256 i = 0; i < _length; i++)
1788         {
1789             // if its uppercase A-Z
1790             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1791             {
1792                 // convert to lower case a-z
1793                 _temp[i] = byte(uint(_temp[i]) + 32);
1794                 
1795                 // we have a non number
1796                 if (_hasNonNumber == false)
1797                     _hasNonNumber = true;
1798             } else {
1799                 require
1800                 (
1801                     // require character is a space
1802                     _temp[i] == 0x20 || 
1803                     // OR lowercase a-z
1804                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1805                     // or 0-9
1806                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1807                     "string contains invalid characters"
1808                 );
1809                 // make sure theres not 2x spaces in a row
1810                 if (_temp[i] == 0x20)
1811                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1812                 
1813                 // see if we have a character other than a number
1814                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1815                     _hasNonNumber = true;    
1816             }
1817         }
1818         
1819         require(_hasNonNumber == true, "string cannot be only numbers");
1820         
1821         bytes32 _ret;
1822         assembly {
1823             _ret := mload(add(_temp, 32))
1824         }
1825         return (_ret);
1826     }
1827 }
1828 
1829 /**
1830  * @title SafeMath v0.1.9
1831  * @dev Math operations with safety checks that throw on error
1832  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1833  * - added sqrt
1834  * - added sq
1835  * - added pwr 
1836  * - changed asserts to requires with error log outputs
1837  * - removed div, its useless
1838  */
1839 library SafeMath {
1840     
1841     /**
1842     * @dev Multiplies two numbers, throws on overflow.
1843     */
1844     function mul(uint256 a, uint256 b) 
1845         internal 
1846         pure 
1847         returns (uint256 c) 
1848     {
1849         if (a == 0) {
1850             return 0;
1851         }
1852         c = a * b;
1853         require(c / a == b, "SafeMath mul failed");
1854         return c;
1855     }
1856 
1857     /**
1858     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1859     */
1860     function sub(uint256 a, uint256 b)
1861         internal
1862         pure
1863         returns (uint256) 
1864     {
1865         require(b <= a, "SafeMath sub failed");
1866         return a - b;
1867     }
1868 
1869     /**
1870     * @dev Adds two numbers, throws on overflow.
1871     */
1872     function add(uint256 a, uint256 b)
1873         internal
1874         pure
1875         returns (uint256 c) 
1876     {
1877         c = a + b;
1878         require(c >= a, "SafeMath add failed");
1879         return c;
1880     }
1881     
1882     /**
1883      * @dev gives square root of given x.
1884      */
1885     function sqrt(uint256 x)
1886         internal
1887         pure
1888         returns (uint256 y) 
1889     {
1890         uint256 z = ((add(x,1)) / 2);
1891         y = x;
1892         while (z < y) 
1893         {
1894             y = z;
1895             z = ((add((x / z),z)) / 2);
1896         }
1897     }
1898     
1899     /**
1900      * @dev gives square. multiplies x by x
1901      */
1902     function sq(uint256 x)
1903         internal
1904         pure
1905         returns (uint256)
1906     {
1907         return (mul(x,x));
1908     }
1909     
1910     /**
1911      * @dev x to the power of y 
1912      */
1913     function pwr(uint256 x, uint256 y)
1914         internal 
1915         pure 
1916         returns (uint256)
1917     {
1918         if (x==0)
1919             return (0);
1920         else if (y==0)
1921             return (1);
1922         else 
1923         {
1924             uint256 z = x;
1925             for (uint256 i=1; i < y; i++)
1926                 z = mul(z,x);
1927             return (z);
1928         }
1929     }
1930 }