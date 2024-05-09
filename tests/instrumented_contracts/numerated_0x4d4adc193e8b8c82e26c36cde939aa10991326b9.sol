1 pragma solidity ^0.4.24;
2 
3 contract RSEvents {
4 
5     // fired whenever a player registers a name
6     event onNewName
7     (
8         uint256 indexed playerID,
9         address indexed playerAddress,
10         bytes32 indexed playerName,
11         bool isNewPlayer,
12         uint256 affiliateID,
13         address affiliateAddress,
14         bytes32 affiliateName,
15         uint256 amountPaid,
16         uint256 timeStamp
17     );
18     
19     // fired at end of buy or reload
20     event onEndTx
21     (
22         uint256 compressedData,     
23         uint256 compressedIDs,      
24         bytes32 playerName,
25         address playerAddress,
26         uint256 ethIn,
27         uint256 keysBought,
28         address winnerAddr,
29         bytes32 winnerName,
30         uint256 amountWon,
31         uint256 newPot,
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
75         uint256 genAmount
76     );
77     
78     // fired whenever a player tries a reload after round timer 
79     // hit zero, and causes end round to be ran.
80     event onReLoadAndDistribute
81     (
82         address playerAddress,
83         bytes32 playerName,
84         uint256 compressedData,
85         uint256 compressedIDs,
86         address winnerAddr,
87         bytes32 winnerName,
88         uint256 amountWon,
89         uint256 newPot,
90         uint256 genAmount
91     );
92     
93     // fired whenever an affiliate is paid
94     event onAffiliatePayout
95     (
96         uint256 indexed affiliateID,
97         address affiliateAddress,
98         bytes32 affiliateName,
99         uint256 indexed roundID,
100         uint256 indexed buyerID,
101         uint256 amount,
102         uint256 timeStamp
103     );
104 }
105 
106 //==============================================================================
107 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
108 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
109 //====================================|=========================================
110 
111 contract modularGoalbonanzaPlus is RSEvents {}
112 
113 contract GoalbonanzaPlusLong is modularGoalbonanzaPlus {
114     using SafeMath for *;
115     using NameFilter for string;
116     using RSKeysCalc for uint256;
117 	
118     GoalbonanzaInterfaceForForwarder constant private TeamGoalbonanza = GoalbonanzaInterfaceForForwarder(0xffcbd472aa93a45f2f9e61945b2b190d0795317b);
119 	GoalbonanzaBookInterface constant private GoalbonanzaBook = GoalbonanzaBookInterface(0x0376a6E256DD4B2419973964fCd5d3CB49B53Aef);
120 
121 //==============================================================================
122 //     _ _  _  |`. _     _ _ |_ | _  _  .
123 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
124 //=================_|===========================================================
125     string constant public name = "GoalbonanzaPlus Multiple Rounds";
126     string constant public symbol = "GB+";
127     uint256 private rndGap_ = 0;
128 
129     // TODO: check time
130     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
131     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
132     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
133 //==============================================================================
134 //     _| _ _|_ _    _ _ _|_    _   .
135 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
136 //=============================|================================================
137 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
138     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
139 	uint256 public rID_;    // round id number / total rounds that have happened
140 //****************
141 // PLAYER DATA 
142 //****************
143     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
144     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
145     mapping (uint256 => RSdatasets.Player) public plyr_;   // (pID => data) player data
146     mapping (uint256 => mapping (uint256 => RSdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
147     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
148 //****************
149 // ROUND DATA 
150 //****************
151 	mapping (uint256 => RSdatasets.Round) public round_;   // (rID => data) round data
152 //****************
153 // TEAM FEE DATA 
154 //****************
155     uint256 public fees_ = 50;          // fee distribution
156     uint256 public potSplit_ = 45;     // pot split distribution
157 //==============================================================================
158 //     _ _  _  __|_ _    __|_ _  _  .
159 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
160 //==============================================================================
161     constructor()
162         public
163     {
164 	}
165 //==============================================================================
166 //     _ _  _  _|. |`. _  _ _  .
167 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
168 //==============================================================================
169     /**
170      * @dev used to make sure no one can interact with contract until it has 
171      * been activated. 
172      */
173     modifier isActivated() {
174         require(activated_ == true, "its not ready yet"); 
175         _;
176     }
177     
178     /**
179      * @dev prevents contracts from interacting with GoalbonanzaPlus 
180      */
181     modifier isHuman() {
182         address _addr = msg.sender;
183         require (_addr == tx.origin);
184         
185         uint256 _codeLength;
186         
187         assembly {_codeLength := extcodesize(_addr)}
188         require(_codeLength == 0, "sorry humans only");
189         _;
190     }
191 
192     /**
193      * @dev sets boundaries for incoming tx 
194      */
195     modifier isWithinLimits(uint256 _eth) {
196         require(_eth >= 1000000000, "too little money");
197         require(_eth <= 100000000000000000000000, "too much money");
198         _;    
199     }
200     
201 //==============================================================================
202 //     _    |_ |. _   |`    _  __|_. _  _  _  .
203 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
204 //====|=========================================================================
205     /**
206      * @dev emergency buy uses last stored affiliate ID and team snek
207      */
208     function()
209         isActivated()
210         isHuman()
211         isWithinLimits(msg.value)
212         public
213         payable
214     {
215         // set up our tx event data and determine if player is new or not
216         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
217             
218         // fetch player id
219         uint256 _pID = pIDxAddr_[msg.sender];
220         
221         // buy core 
222         buyCore(_pID, plyr_[_pID].laff, _eventData_);
223     }
224     
225     /**
226      * @dev converts all incoming ethereum to keys.
227      * -functionhash- 0x8f38f309 (using ID for affiliate)
228      * -functionhash- 0x98a0871d (using address for affiliate)
229      * -functionhash- 0xa65b37a1 (using name for affiliate)
230      * @param _affCode the ID/address/name of the player who gets the affiliate fee
231      */
232     function buyXid(uint256 _affCode)
233         isActivated()
234         isHuman()
235         isWithinLimits(msg.value)
236         public
237         payable
238     {
239         // set up our tx event data and determine if player is new or not
240         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
241         
242         // fetch player id
243         uint256 _pID = pIDxAddr_[msg.sender];
244         
245         // manage affiliate residuals
246         // if no affiliate code was given or player tried to use their own, lolz
247         if (_affCode == 0 || _affCode == _pID)
248         {
249             // use last stored affiliate code 
250             _affCode = plyr_[_pID].laff;
251             
252         // if affiliate code was given & its not the same as previously stored 
253         } else if (_affCode != plyr_[_pID].laff) {
254             // update last affiliate 
255             plyr_[_pID].laff = _affCode;
256         }
257                 
258         // buy core 
259         buyCore(_pID, _affCode, _eventData_);
260     }
261     
262     function buyXaddr(address _affCode)
263         isActivated()
264         isHuman()
265         isWithinLimits(msg.value)
266         public
267         payable
268     {
269         // set up our tx event data and determine if player is new or not
270         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
271         
272         // fetch player id
273         uint256 _pID = pIDxAddr_[msg.sender];
274         
275         // manage affiliate residuals
276         uint256 _affID;
277         // if no affiliate code was given or player tried to use their own, lolz
278         if (_affCode == address(0) || _affCode == msg.sender)
279         {
280             // use last stored affiliate code
281             _affID = plyr_[_pID].laff;
282         
283         // if affiliate code was given    
284         } else {
285             // get affiliate ID from aff Code 
286             _affID = pIDxAddr_[_affCode];
287             
288             // if affID is not the same as previously stored 
289             if (_affID != plyr_[_pID].laff)
290             {
291                 // update last affiliate
292                 plyr_[_pID].laff = _affID;
293             }
294         }
295         
296         // buy core 
297         buyCore(_pID, _affID, _eventData_);
298     }
299     
300     function buyXname(bytes32 _affCode)
301         isActivated()
302         isHuman()
303         isWithinLimits(msg.value)
304         public
305         payable
306     {
307         // set up our tx event data and determine if player is new or not
308         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
309         
310         // fetch player id
311         uint256 _pID = pIDxAddr_[msg.sender];
312         
313         // manage affiliate residuals
314         uint256 _affID;
315         // if no affiliate code was given or player tried to use their own, lolz
316         if (_affCode == '' || _affCode == plyr_[_pID].name)
317         {
318             // use last stored affiliate code
319             _affID = plyr_[_pID].laff;
320         
321         // if affiliate code was given
322         } else {
323             // get affiliate ID from aff Code
324             _affID = pIDxName_[_affCode];
325             
326             // if affID is not the same as previously stored
327             if (_affID != plyr_[_pID].laff)
328             {
329                 // update last affiliate
330                 plyr_[_pID].laff = _affID;
331             }
332         }
333         
334         // buy core 
335         buyCore(_pID, _affID, _eventData_);
336     }
337     
338     /**
339      * @dev essentially the same as buy, but instead of you sending ether 
340      * from your wallet, it uses your unwithdrawn earnings.
341      * -functionhash- 0x349cdcac (using ID for affiliate)
342      * -functionhash- 0x82bfc739 (using address for affiliate)
343      * -functionhash- 0x079ce327 (using name for affiliate)
344      * @param _affCode the ID/address/name of the player who gets the affiliate fee
345      * @param _eth amount of earnings to use (remainder returned to gen vault)
346      */
347     function reLoadXid(uint256 _affCode, uint256 _eth)
348         isActivated()
349         isHuman()
350         isWithinLimits(_eth)
351         public
352     {
353         // set up our tx event data
354         RSdatasets.EventReturns memory _eventData_;
355         
356         // fetch player ID
357         uint256 _pID = pIDxAddr_[msg.sender];
358         
359         // manage affiliate residuals
360         // if no affiliate code was given or player tried to use their own, lolz
361         if (_affCode == 0 || _affCode == _pID)
362         {
363             // use last stored affiliate code 
364             _affCode = plyr_[_pID].laff;
365             
366         // if affiliate code was given & its not the same as previously stored 
367         } else if (_affCode != plyr_[_pID].laff) {
368             // update last affiliate 
369             plyr_[_pID].laff = _affCode;
370         }
371 
372         // reload core
373         reLoadCore(_pID, _affCode, _eth, _eventData_);
374     }
375     
376     function reLoadXaddr(address _affCode, uint256 _eth)
377         isActivated()
378         isHuman()
379         isWithinLimits(_eth)
380         public
381     {
382         // set up our tx event data
383         RSdatasets.EventReturns memory _eventData_;
384         
385         // fetch player ID
386         uint256 _pID = pIDxAddr_[msg.sender];
387         
388         // manage affiliate residuals
389         uint256 _affID;
390         // if no affiliate code was given or player tried to use their own, lolz
391         if (_affCode == address(0) || _affCode == msg.sender)
392         {
393             // use last stored affiliate code
394             _affID = plyr_[_pID].laff;
395         
396         // if affiliate code was given    
397         } else {
398             // get affiliate ID from aff Code 
399             _affID = pIDxAddr_[_affCode];
400             
401             // if affID is not the same as previously stored 
402             if (_affID != plyr_[_pID].laff)
403             {
404                 // update last affiliate
405                 plyr_[_pID].laff = _affID;
406             }
407         }
408                 
409         // reload core
410         reLoadCore(_pID, _affID, _eth, _eventData_);
411     }
412     
413     function reLoadXname(bytes32 _affCode, uint256 _eth)
414         isActivated()
415         isHuman()
416         isWithinLimits(_eth)
417         public
418     {
419         // set up our tx event data
420         RSdatasets.EventReturns memory _eventData_;
421         
422         // fetch player ID
423         uint256 _pID = pIDxAddr_[msg.sender];
424         
425         // manage affiliate residuals
426         uint256 _affID;
427         // if no affiliate code was given or player tried to use their own, lolz
428         if (_affCode == '' || _affCode == plyr_[_pID].name)
429         {
430             // use last stored affiliate code
431             _affID = plyr_[_pID].laff;
432         
433         // if affiliate code was given
434         } else {
435             // get affiliate ID from aff Code
436             _affID = pIDxName_[_affCode];
437             
438             // if affID is not the same as previously stored
439             if (_affID != plyr_[_pID].laff)
440             {
441                 // update last affiliate
442                 plyr_[_pID].laff = _affID;
443             }
444         }
445                 
446         // reload core
447         reLoadCore(_pID, _affID, _eth, _eventData_);
448     }
449 
450     /**
451      * @dev withdraws all of your earnings.
452      * -functionhash- 0x3ccfd60b
453      */
454     function withdraw()
455         isActivated()
456         isHuman()
457         public
458     {        
459         // setup local rID 
460         uint256 _rID = rID_;
461         
462         // grab time
463         uint256 _now = now;
464         
465         // fetch player ID
466         uint256 _pID = pIDxAddr_[msg.sender];
467         
468         // setup temp var for player eth
469         uint256 _eth;
470         
471         // check to see if round has ended and no one has run round end yet
472         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
473         {
474             // set up our tx event data
475             RSdatasets.EventReturns memory _eventData_;
476             
477             // end the round (distributes pot)
478 			round_[_rID].ended = true;
479             _eventData_ = endRound(_eventData_);
480             
481 			// get their earnings
482             _eth = withdrawEarnings(_pID);
483             
484             // gib moni
485             if (_eth > 0)
486                 plyr_[_pID].addr.transfer(_eth);    
487             
488             // build event data
489             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
490             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
491             
492             // fire withdraw and distribute event
493             emit RSEvents.onWithdrawAndDistribute
494             (
495                 msg.sender, 
496                 plyr_[_pID].name, 
497                 _eth, 
498                 _eventData_.compressedData, 
499                 _eventData_.compressedIDs, 
500                 _eventData_.winnerAddr, 
501                 _eventData_.winnerName, 
502                 _eventData_.amountWon, 
503                 _eventData_.newPot, 
504                 _eventData_.genAmount
505             );
506             
507         // in any other situation
508         } else {
509             // get their earnings
510             _eth = withdrawEarnings(_pID);
511             
512             // gib moni
513             if (_eth > 0)
514                 plyr_[_pID].addr.transfer(_eth);
515             
516             // fire withdraw event
517             emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
518         }
519     }
520     
521     /**
522      * @dev use these to register names.  they are just wrappers that will send the
523      * registration requests to the PlayerBook contract.  So registering here is the 
524      * same as registering there.  UI will always display the last name you registered.
525      * but you will still own all previously registered names to use as affiliate 
526      * links.
527      * - must pay a registration fee.
528      * - name must be unique
529      * - names will be converted to lowercase
530      * - name cannot start or end with a space 
531      * - cannot have more than 1 space in a row
532      * - cannot be only numbers
533      * - cannot start with 0x 
534      * - name must be at least 1 char
535      * - max length of 32 characters long
536      * - allowed characters: a-z, 0-9, and space
537      * -functionhash- 0x921dec21 (using ID for affiliate)
538      * -functionhash- 0x3ddd4698 (using address for affiliate)
539      * -functionhash- 0x685ffd83 (using name for affiliate)
540      * @param _nameString players desired name
541      * @param _affCode affiliate ID, address, or name of who referred you
542      * @param _all set to true if you want this to push your info to all games 
543      * (this might cost a lot of gas)
544      */
545     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
546         isHuman()
547         public
548         payable
549     {
550         bytes32 _name = _nameString.nameFilter();
551         address _addr = msg.sender;
552         uint256 _paid = msg.value;
553         (bool _isNewPlayer, uint256 _affID) = GoalbonanzaBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
554 
555         uint256 _pID = pIDxAddr_[_addr];
556         
557         // fire event
558         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
559     }
560     
561     function registerNameXaddr(string _nameString, address _affCode, bool _all)
562         isHuman()
563         public
564         payable
565     {
566         bytes32 _name = _nameString.nameFilter();
567         address _addr = msg.sender;
568         uint256 _paid = msg.value;
569         (bool _isNewPlayer, uint256 _affID) = GoalbonanzaBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
570         
571         uint256 _pID = pIDxAddr_[_addr];
572         
573         // fire event
574         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
575     }
576     
577     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
578         isHuman()
579         public
580         payable
581     {
582         bytes32 _name = _nameString.nameFilter();
583         address _addr = msg.sender;
584         uint256 _paid = msg.value;
585         (bool _isNewPlayer, uint256 _affID) = GoalbonanzaBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
586         
587         uint256 _pID = pIDxAddr_[_addr];
588         
589         // fire event
590         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
591     }
592 //==============================================================================
593 //     _  _ _|__|_ _  _ _  .
594 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
595 //=====_|=======================================================================
596     /**
597      * @dev return the price buyer will pay for next 1 individual key.
598      * -functionhash- 0x018a25e8
599      * @return price for next key bought (in wei format)
600      */
601     function getBuyPrice()
602         public 
603         view 
604         returns(uint256)
605     {
606         // setup local rID
607         uint256 _rID = rID_;
608         
609         // grab time
610         uint256 _now = now;
611         
612         // are we in a round?
613         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
614             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
615         else // rounds over.  need price for new round
616             return ( 75000000000000 ); // init
617     }
618     
619     /**
620      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
621      * provider
622      * -functionhash- 0xc7e284b8
623      * @return time left in seconds
624      */
625     function getTimeLeft()
626         public
627         view
628         returns(uint256)
629     {
630         // setup local rID
631         uint256 _rID = rID_;
632         
633         // grab time
634         uint256 _now = now;
635         
636         if (_now < round_[_rID].end)
637             if (_now > round_[_rID].strt + rndGap_)
638                 return( (round_[_rID].end).sub(_now) );
639             else
640                 return( (round_[_rID].strt + rndGap_).sub(_now));
641         else
642             return(0);
643     }
644     
645     /**
646      * @dev returns player earnings per vaults 
647      * -functionhash- 0x63066434
648      * @return winnings vault
649      * @return general vault
650      * @return affiliate vault
651      */
652     function getPlayerVaults(uint256 _pID)
653         public
654         view
655         returns(uint256 ,uint256, uint256)
656     {
657         // setup local rID
658         uint256 _rID = rID_;
659         
660         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
661         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
662         {
663             // if player is winner 
664             if (round_[_rID].plyr == _pID)
665             {
666                 return
667                 (
668                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
669                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
670                     plyr_[_pID].aff
671                 );
672             // if player is not the winner
673             } else {
674                 return
675                 (
676                     plyr_[_pID].win,
677                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
678                     plyr_[_pID].aff
679                 );
680             }
681             
682         // if round is still going on, or round has ended and round end has been ran
683         } else {
684             return
685             (
686                 plyr_[_pID].win,
687                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
688                 plyr_[_pID].aff
689             );
690         }
691     }
692     
693     /**
694      * solidity hates stack limits.  this lets us avoid that hate 
695      */
696     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
697         private
698         view
699         returns(uint256)
700     {
701         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
702     }
703     
704     /**
705      * @dev returns all current round info needed for front end
706      * -functionhash- 0x747dff42
707      * @return total keys
708      * @return time ends
709      * @return time started
710      * @return current pot 
711      * @return current player ID in lead 
712      * @return current player in leads address 
713      * @return current player in leads name
714      * @return airdrop tracker # & airdrop pot
715      */
716     function getCurrentRoundInfo()
717         public
718         view
719         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
720     {
721         // setup local rID
722         uint256 _rID = rID_;
723         
724         return
725         (
726             round_[_rID].keys,              //0
727             round_[_rID].end,               //1
728             round_[_rID].strt,              //2
729             round_[_rID].pot,               //3
730             (round_[_rID].plyr * 10),     //6 check here
731             plyr_[round_[_rID].plyr].addr,  //5
732             plyr_[round_[_rID].plyr].name,  //6
733             airDropTracker_ + (airDropPot_ * 1000)              //7
734         );
735     }
736 
737     /**
738      * @dev returns player info based on address.  if no address is given, it will 
739      * use msg.sender 
740      * -functionhash-
741      * @param _addr address of the player you want to lookup 
742      * @return player ID 
743      * @return player name
744      * @return keys owned (current round)
745      * @return winnings vault
746      * @return general vault 
747      * @return affiliate vault 
748 	 * @return player round eth
749      */
750     function getPlayerInfoByAddress(address _addr)
751         public 
752         view 
753         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
754     {
755         // setup local rID
756         uint256 _rID = rID_;
757         
758         if (_addr == address(0))
759         {
760             _addr == msg.sender;
761         }
762         uint256 _pID = pIDxAddr_[_addr];
763         
764         return
765         (
766             _pID,                               //0
767             plyr_[_pID].name,                   //1
768             plyrRnds_[_pID][_rID].keys,         //2
769             plyr_[_pID].win,                    //3
770             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
771             plyr_[_pID].aff,                    //5
772             plyrRnds_[_pID][_rID].eth           //6
773         );
774     }
775 
776 //==============================================================================
777 //     _ _  _ _   | _  _ . _  .
778 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
779 //=====================_|=======================================================
780     /**
781      * @dev logic runs whenever a buy order is executed.  determines how to handle 
782      * incoming eth depending on if we are in an active round or not
783      */
784     function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
785         private
786     {
787         // setup local rID
788         uint256 _rID = rID_;
789         
790         // grab time
791         uint256 _now = now;
792         
793         // if round is active
794         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
795         {
796             // call core 
797             core(_rID, _pID, msg.value, _affID, _eventData_);
798         
799         // if round is not active     
800         } else {
801             // check to see if end round needs to be ran
802             if (_now > round_[_rID].end && round_[_rID].ended == false) 
803             {
804                 // end the round (distributes pot) & start new round
805 			    round_[_rID].ended = true;
806                 _eventData_ = endRound(_eventData_);
807                 
808                 // build event data
809                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
810                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
811                 
812                 // fire buy and distribute event 
813                 emit RSEvents.onBuyAndDistribute
814                 (
815                     msg.sender, 
816                     plyr_[_pID].name, 
817                     msg.value, 
818                     _eventData_.compressedData, 
819                     _eventData_.compressedIDs, 
820                     _eventData_.winnerAddr, 
821                     _eventData_.winnerName, 
822                     _eventData_.amountWon, 
823                     _eventData_.newPot, 
824                     _eventData_.genAmount
825                 );
826             }
827             
828             // put eth in players vault 
829             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
830         }
831     }
832     
833     /**
834      * @dev logic runs whenever a reload order is executed.  determines how to handle 
835      * incoming eth depending on if we are in an active round or not 
836      */
837     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, RSdatasets.EventReturns memory _eventData_)
838         private
839     {
840         // setup local rID
841         uint256 _rID = rID_;
842         
843         // grab time
844         uint256 _now = now;
845         
846         // if round is active
847         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
848         {
849             // get earnings from all vaults and return unused to gen vault
850             // because we use a custom safemath library.  this will throw if player 
851             // tried to spend more eth than they have.
852             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
853             
854             // call core 
855             core(_rID, _pID, _eth, _affID, _eventData_);
856         
857         // if round is not active and end round needs to be ran   
858         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
859             // end the round (distributes pot) & start new round
860             round_[_rID].ended = true;
861             _eventData_ = endRound(_eventData_);
862                 
863             // build event data
864             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
865             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
866                 
867             // fire buy and distribute event 
868             emit RSEvents.onReLoadAndDistribute
869             (
870                 msg.sender, 
871                 plyr_[_pID].name, 
872                 _eventData_.compressedData, 
873                 _eventData_.compressedIDs, 
874                 _eventData_.winnerAddr, 
875                 _eventData_.winnerName, 
876                 _eventData_.amountWon, 
877                 _eventData_.newPot, 
878                 _eventData_.genAmount
879             );
880         }
881     }
882     
883     /**
884      * @dev this is the core logic for any buy/reload that happens while a round 
885      * is live.
886      */
887     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
888         private
889     {
890         // if player is new to round
891         if (plyrRnds_[_pID][_rID].keys == 0)
892             _eventData_ = managePlayer(_pID, _eventData_);
893         
894         // early round eth limiter 
895         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 10000000000000000000)
896         {
897             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
898             uint256 _refund = _eth.sub(_availableLimit);
899             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
900             _eth = _availableLimit;
901         }
902         
903         // if eth left is greater than min eth allowed (sorry no pocket lint)
904         if (_eth > 1000000000) 
905         {
906             
907             // mint the new keys
908             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
909             
910             // if they bought at least 1 whole key
911             if (_keys >= 1000000000000000000)
912             {
913                 updateTimer(_keys, _rID);
914 
915             // set new leaders
916             if (round_[_rID].plyr != _pID)
917                 round_[_rID].plyr = _pID;  
918             
919             // set the new leader bool to true
920             _eventData_.compressedData = _eventData_.compressedData + 100;
921         }
922             
923             // manage airdrops
924             if (_eth >= 100000000000000000)
925             {
926             airDropTracker_++;
927             if (airdrop() == true)
928             {
929                 // gib muni
930                 uint256 _prize;
931                 if (_eth >= 10000000000000000000)
932                 {
933                     // calculate prize and give it to winner
934                     _prize = ((airDropPot_).mul(75)) / 100;
935                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
936                     
937                     // adjust airDropPot 
938                     airDropPot_ = (airDropPot_).sub(_prize);
939                     
940                     // let event know a tier 3 prize was won 
941                     _eventData_.compressedData += 300000000000000000000000000000000;
942                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
943                     // calculate prize and give it to winner
944                     _prize = ((airDropPot_).mul(50)) / 100;
945                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
946                     
947                     // adjust airDropPot 
948                     airDropPot_ = (airDropPot_).sub(_prize);
949                     
950                     // let event know a tier 2 prize was won 
951                     _eventData_.compressedData += 200000000000000000000000000000000;
952                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
953                     // calculate prize and give it to winner
954                     _prize = ((airDropPot_).mul(25)) / 100;
955                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
956                     
957                     // adjust airDropPot 
958                     airDropPot_ = (airDropPot_).sub(_prize);
959                     
960                     // let event know a tier 1 prize was won 
961                     _eventData_.compressedData += 100000000000000000000000000000000;
962                 }
963                 // set airdrop happened bool to true
964                 _eventData_.compressedData += 10000000000000000000000000000000;
965                 // let event know how much was won 
966                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
967                 
968                 // reset air drop tracker
969                 airDropTracker_ = 0;
970             }
971         }
972     
973             // store the air drop tracker number (number of buys since last airdrop)
974             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
975             
976             // update player 
977             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
978             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
979             
980             // update round
981             round_[_rID].keys = _keys.add(round_[_rID].keys);
982             round_[_rID].eth = _eth.add(round_[_rID].eth);
983     
984             // distribute eth
985             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
986             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
987             
988             // call end tx function to fire end tx event.
989 		    endTx(_pID, _eth, _keys, _eventData_);
990         }
991     }
992 //==============================================================================
993 //     _ _ | _   | _ _|_ _  _ _  .
994 //    (_(_||(_|_||(_| | (_)| _\  .
995 //==============================================================================
996     /**
997      * @dev calculates unmasked earnings (just calculates, does not update mask)
998      * @return earnings in wei format
999      */
1000     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1001         private
1002         view
1003         returns(uint256)
1004     {
1005         return((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
1006     }
1007     
1008     /** 
1009      * @dev returns the amount of keys you would get given an amount of eth. 
1010      * -functionhash- 0xce89c80c
1011      * @param _eth amount of eth sent in 
1012      * @return keys received 
1013      */
1014     function calcKeysReceived(uint256 _rID, uint256 _eth)
1015         public
1016         view
1017         returns(uint256)
1018     {
1019         // grab time
1020         uint256 _now = now;
1021         
1022         // are we in a round?
1023         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1024             return ( (round_[_rID].eth).keysRec(_eth) );
1025         else // rounds over.  need keys for new round
1026             return ( (_eth).keys() );
1027     }
1028     
1029     /** 
1030      * @dev returns current eth price for X keys.  
1031      * -functionhash- 0xcf808000
1032      * @param _keys number of keys desired (in 18 decimal format)
1033      * @return amount of eth needed to send
1034      */
1035     function iWantXKeys(uint256 _keys)
1036         public
1037         view
1038         returns(uint256)
1039     {
1040         // setup local rID
1041         uint256 _rID = rID_;
1042         
1043         // grab time
1044         uint256 _now = now;
1045         
1046         // are we in a round?
1047         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1048             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1049         else // rounds over.  need price for new round
1050             return ( (_keys).eth() );
1051     }
1052 //==============================================================================
1053 //    _|_ _  _ | _  .
1054 //     | (_)(_)|_\  .
1055 //==============================================================================
1056     /**
1057 	 * @dev receives name/player info from names contract 
1058      */
1059     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1060         external
1061     {
1062         require (msg.sender == address(GoalbonanzaBook), "only GoalbonanzaBook can call this function");
1063         if (pIDxAddr_[_addr] != _pID)
1064             pIDxAddr_[_addr] = _pID;
1065         if (pIDxName_[_name] != _pID)
1066             pIDxName_[_name] = _pID;
1067         if (plyr_[_pID].addr != _addr)
1068             plyr_[_pID].addr = _addr;
1069         if (plyr_[_pID].name != _name)
1070             plyr_[_pID].name = _name;
1071         if (plyr_[_pID].laff != _laff)
1072             plyr_[_pID].laff = _laff;
1073         if (plyrNames_[_pID][_name] == false)
1074             plyrNames_[_pID][_name] = true;
1075     }
1076     
1077     /**
1078      * @dev receives entire player name list 
1079      */
1080     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1081         external
1082     {
1083         require (msg.sender == address(GoalbonanzaBook), "only GoalbonanzaBook can call this function");
1084         if(plyrNames_[_pID][_name] == false)
1085             plyrNames_[_pID][_name] = true;
1086     }   
1087         
1088     /**
1089      * @dev gets existing or registers new pID.  use this when a player may be new
1090      * @return pID 
1091      */
1092     function determinePID(RSdatasets.EventReturns memory _eventData_)
1093         private
1094         returns (RSdatasets.EventReturns)
1095     {
1096         uint256 _pID = pIDxAddr_[msg.sender];
1097         // if player is new to this version of GoalbonanzaPlus
1098         if (_pID == 0)
1099         {
1100             // grab their player ID, name and last aff ID, from player names contract 
1101             _pID = GoalbonanzaBook.getPlayerID(msg.sender);
1102             bytes32 _name = GoalbonanzaBook.getPlayerName(_pID);
1103             uint256 _laff = GoalbonanzaBook.getPlayerLAff(_pID);
1104             
1105             // set up player account 
1106             pIDxAddr_[msg.sender] = _pID;
1107             plyr_[_pID].addr = msg.sender;
1108             
1109             if (_name != "")
1110             {
1111                 pIDxName_[_name] = _pID;
1112                 plyr_[_pID].name = _name;
1113                 plyrNames_[_pID][_name] = true;
1114             }
1115             
1116             if (_laff != 0 && _laff != _pID)
1117                 plyr_[_pID].laff = _laff;
1118             
1119             // set the new player bool to true
1120             _eventData_.compressedData = _eventData_.compressedData + 1;
1121         } 
1122         return (_eventData_);
1123     }
1124 
1125     /**
1126      * @dev decides if round end needs to be run & new round started.  and if 
1127      * player unmasked earnings from previously played rounds need to be moved.
1128      */
1129     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1130         private
1131         returns (RSdatasets.EventReturns)
1132     {        
1133         // if player has played a previous round, move their unmasked earnings
1134         // from that round to gen vault.
1135         if (plyr_[_pID].lrnd != 0)
1136             updateGenVault(_pID, plyr_[_pID].lrnd);
1137             
1138         // update player's last round played
1139         plyr_[_pID].lrnd = rID_;
1140         
1141         // set the joined round bool to true
1142         _eventData_.compressedData = _eventData_.compressedData + 10;
1143         
1144         return(_eventData_);
1145     }
1146     
1147     /**
1148      * @dev ends the round. manages paying out winner/splitting up pot
1149      */
1150     function endRound(RSdatasets.EventReturns memory _eventData_)
1151         private
1152         returns (RSdatasets.EventReturns)
1153     {  
1154         // setup local rID
1155         uint256 _rID = rID_;
1156         
1157         // grab our winning player and team id's
1158         uint256 _winPID = round_[_rID].plyr;
1159         
1160         // grab our pot amount
1161         // add airdrop pot into the final pot
1162         uint256 _pot = round_[_rID].pot;
1163         
1164         // calculate our winner share, community rewards, gen share, 
1165         // p3d share, and amount reserved for next pot 
1166         uint256 _win = (_pot.mul(45)) / 100;
1167         uint256 _com = (_pot / 10);
1168         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1169         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1170         
1171         // calculate ppt for round mask
1172         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1173         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1174         if (_dust > 0)
1175         {
1176             _gen = _gen.sub(_dust);
1177             _res = _com.add(_dust);
1178         }
1179         
1180         // pay our winner
1181         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1182         
1183         // community rewards
1184         if (!address(TeamGoalbonanza).call.value(_com)(bytes4(keccak256("deposit()"))))
1185         {
1186             _gen = _gen.add(_com);
1187             _com = 0;
1188         }
1189         
1190         // distribute gen portion to key holders
1191         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1192             
1193         // prepare event data
1194         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1195         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1196         _eventData_.winnerAddr = plyr_[_winPID].addr;
1197         _eventData_.winnerName = plyr_[_winPID].name;
1198         _eventData_.amountWon = _win;
1199         _eventData_.genAmount = _gen;
1200         _eventData_.newPot = _res;
1201 		
1202 		// start next round
1203         rID_++;
1204         _rID++;
1205         round_[_rID].strt = now;
1206         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1207         round_[_rID].pot = _res;
1208         
1209         return(_eventData_);
1210     }
1211     
1212     /**
1213      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1214      */
1215     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1216         private 
1217     {
1218         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1219         if (_earnings > 0)
1220         {
1221             // put in gen vault
1222             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1223             // zero out their earnings by updating mask
1224             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1225         }
1226     }
1227     
1228     /**
1229      * @dev updates round timer based on number of whole keys bought.
1230      */
1231     function updateTimer(uint256 _keys, uint256 _rID)
1232         private
1233     {
1234         // grab time
1235         uint256 _now = now;
1236         
1237         // calculate time based on number of keys bought
1238         uint256 _newTime;
1239         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1240             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1241         else
1242             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1243         
1244         // compare to max and set new end time
1245         if (_newTime < (rndMax_).add(_now))
1246             round_[_rID].end = _newTime;
1247         else
1248             round_[_rID].end = rndMax_.add(_now);
1249     }
1250     
1251     /**
1252      * @dev generates a random number between 0-99 and checks to see if thats
1253      * resulted in an airdrop win
1254      * @return do we have a winner?
1255      */
1256     function airdrop()
1257         private 
1258         view 
1259         returns(bool)
1260     {
1261         uint256 seed = uint256(keccak256(abi.encodePacked(
1262             
1263             (block.timestamp).add
1264             (block.difficulty).add
1265             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1266             (block.gaslimit).add
1267             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1268             (block.number)
1269             
1270         )));
1271         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1272             return(true);
1273         else
1274             return(false);
1275     }
1276 
1277     /**
1278      * @dev distributes eth based on fees to com, aff, and p3d
1279      */
1280     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1281         private
1282         returns(RSdatasets.EventReturns)
1283     {
1284         // pay 15% out to community rewards
1285         uint256 _com = _eth * 15 / 100;
1286                 
1287         // distribute share to affiliate
1288         uint256 _aff = _eth / 10;
1289         
1290         // decide what to do with affiliate share of fees
1291         // affiliate must not be self, and must have a name registered
1292         if (_affID != _pID && plyr_[_affID].name != '') {
1293             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1294             emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1295         } else {
1296             // no affiliates, add to community
1297             _com += _aff;
1298         }
1299 
1300         if (!address(TeamGoalbonanza).call.value(_com)(bytes4(keccak256("deposit()"))))
1301         {
1302             // This ensures TeamGoalbonanza cannot influence the outcome
1303             // bank migrations by breaking outgoing transactions.
1304         }
1305 
1306         return(_eventData_);
1307     }
1308     
1309     /**
1310      * @dev distributes eth based on fees to gen and pot
1311      */
1312     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1313         private
1314         returns(RSdatasets.EventReturns)
1315     {
1316         // calculate gen share
1317         uint256 _gen = (_eth.mul(fees_)) / 100;
1318         
1319         // toss 1% into airdrop pot 
1320 		uint256 _air = (_eth / 1000);
1321         airDropPot_ = airDropPot_.add(_air);
1322                 
1323         // calculate pot (24.9%) 
1324         uint256 _pot = (_eth.mul(249) / 1000);
1325         
1326         // distribute gen share (thats what updateMasks() does) and adjust
1327         // balances for dust.
1328         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1329         if (_dust > 0)
1330             _gen = _gen.sub(_dust);
1331         
1332         // add eth to pot
1333         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1334         
1335         // set up event data
1336         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1337         _eventData_.potAmount = _pot;
1338         
1339         return(_eventData_);
1340     }
1341 
1342     /**
1343      * @dev updates masks for round and player when keys are bought
1344      * @return dust left over 
1345      */
1346     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1347         private
1348         returns(uint256)
1349     {
1350         /* MASKING NOTES
1351             earnings masks are a tricky thing for people to wrap their minds around.
1352             the basic thing to understand here.  is were going to have a global
1353             tracker based on profit per share for each round, that increases in
1354             relevant proportion to the increase in share supply.
1355             
1356             the player will have an additional mask that basically says "based
1357             on the rounds mask, my shares, and how much i've already withdrawn,
1358             how much is still owed to me?"
1359         */
1360         
1361         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1362         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1363         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1364             
1365         // calculate player earning from their own buy (only based on the keys
1366         // they just bought).  & update player earnings mask
1367         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1368         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1369         
1370         // calculate & return dust
1371         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1372     }
1373     
1374     /**
1375      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1376      * @return earnings in wei format
1377      */
1378     function withdrawEarnings(uint256 _pID)
1379         private
1380         returns(uint256)
1381     {
1382         // update gen vault
1383         updateGenVault(_pID, plyr_[_pID].lrnd);
1384         
1385         // from vaults 
1386         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1387         if (_earnings > 0)
1388         {
1389             plyr_[_pID].win = 0;
1390             plyr_[_pID].gen = 0;
1391             plyr_[_pID].aff = 0;
1392         }
1393 
1394         return(_earnings);
1395     }
1396     
1397     /**
1398      * @dev prepares compression data and fires event for buy or reload tx's
1399      */
1400     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1401         private
1402     {
1403         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1404         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1405         
1406         emit RSEvents.onEndTx
1407         (
1408             _eventData_.compressedData,
1409             _eventData_.compressedIDs,
1410             plyr_[_pID].name,
1411             msg.sender,
1412             _eth,
1413             _keys,
1414             _eventData_.winnerAddr,
1415             _eventData_.winnerName,
1416             _eventData_.amountWon,
1417             _eventData_.newPot,
1418             _eventData_.genAmount,
1419             _eventData_.potAmount,
1420             airDropPot_
1421         );
1422     }
1423 
1424 //==============================================================================
1425 //    (~ _  _    _._|_    .
1426 //    _)(/_(_|_|| | | \/  .
1427 //====================/=========================================================
1428     /** upon contract deploy, it will be deactivated.  this is a one time
1429      * use function that will activate the contract.  we do this so devs 
1430      * have time to set things up on the web end                            **/
1431     bool public activated_ = false;
1432     function activate()
1433         public
1434     {
1435         // only owner can activate 
1436         // TODO: set owner
1437         require(
1438             (msg.sender == 0xcd0fce8d255349092496f131f2900df25f0569f8),
1439             "only owner can activate"
1440         );
1441         
1442         // can only be ran once
1443         require(activated_ == false, "GoalbonanzaPlus already activated");
1444         
1445         // activate the contract 
1446         activated_ = true;
1447         
1448         // lets start first round
1449 		rID_ = 1;
1450         round_[1].strt = now - rndGap_;
1451         round_[1].end = now + rndInit_;
1452     }
1453 }
1454 
1455 //==============================================================================
1456 //   __|_ _    __|_ _  .
1457 //  _\ | | |_|(_ | _\  .
1458 //==============================================================================
1459 library RSdatasets {
1460     //compressedData key
1461     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1462         // 0 - new player (bool)
1463         // 1 - joined round (bool)
1464         // 2 - new  leader (bool)
1465         // 3-5 - air drop tracker (uint 0-999)
1466         // 6-16 - round end time
1467         // 17 - winnerTeam
1468         // 18 - 28 timestamp 
1469         // 29 - team
1470         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1471         // 31 - airdrop happened bool
1472         // 32 - airdrop tier 
1473         // 33 - airdrop amount won
1474     //compressedIDs key
1475     // [77-52][51-26][25-0]
1476         // 0-25 - pID 
1477         // 26-51 - winPID
1478         // 52-77 - rID
1479     struct EventReturns {
1480         uint256 compressedData;
1481         uint256 compressedIDs;
1482         address winnerAddr;         // winner address
1483         bytes32 winnerName;         // winner name
1484         uint256 amountWon;          // amount won
1485         uint256 newPot;             // amount in new pot
1486         uint256 genAmount;          // amount distributed to gen
1487         uint256 potAmount;          // amount added to pot
1488     }
1489     struct Player {
1490         address addr;   // player address
1491         bytes32 name;   // player name
1492         uint256 win;    // winnings vault
1493         uint256 gen;    // general vault
1494         uint256 aff;    // affiliate vault
1495         uint256 lrnd;   // last round played
1496         uint256 laff;   // last affiliate id used
1497     }
1498     struct PlayerRounds {
1499         uint256 eth;    // eth player has added to round (used for eth limiter)
1500         uint256 keys;   // keys
1501         uint256 mask;   // player mask 
1502     }
1503     struct Round {
1504         uint256 plyr;   // pID of player in lead
1505         uint256 end;    // time ends/ended
1506         bool ended;     // has round end function been ran
1507         uint256 strt;   // time round started
1508         uint256 keys;   // keys
1509         uint256 eth;    // total eth in
1510         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1511         uint256 mask;   // global mask
1512     }
1513 }
1514 
1515 //==============================================================================
1516 //  |  _      _ _ | _  .
1517 //  |<(/_\/  (_(_||(_  .
1518 //=======/======================================================================
1519 library RSKeysCalc {
1520     using SafeMath for *;
1521     /**
1522      * @dev calculates number of keys received given X eth 
1523      * @param _curEth current amount of eth in contract 
1524      * @param _newEth eth being spent
1525      * @return amount of ticket purchased
1526      */
1527     function keysRec(uint256 _curEth, uint256 _newEth)
1528         internal
1529         pure
1530         returns (uint256)
1531     {
1532         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1533     }
1534     
1535     /**
1536      * @dev calculates amount of eth received if you sold X keys 
1537      * @param _curKeys current amount of keys that exist 
1538      * @param _sellKeys amount of keys you wish to sell
1539      * @return amount of eth received
1540      */
1541     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1542         internal
1543         pure
1544         returns (uint256)
1545     {
1546         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1547     }
1548 
1549     /**
1550      * @dev calculates how many keys would exist with given an amount of eth
1551      * @param _eth eth "in contract"
1552      * @return number of keys that would exist
1553      */
1554     function keys(uint256 _eth) 
1555         internal
1556         pure
1557         returns(uint256)
1558     {
1559         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1560     }
1561     
1562     /**
1563      * @dev calculates how much eth would be in contract given a number of keys
1564      * @param _keys number of keys "in contract" 
1565      * @return eth that would exists
1566      */
1567     function eth(uint256 _keys) 
1568         internal
1569         pure
1570         returns(uint256)  
1571     {
1572         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1573     }
1574 }
1575 
1576 interface GoalbonanzaInterfaceForForwarder {
1577     function deposit() external payable returns(bool);
1578 }
1579 
1580 interface GoalbonanzaBookInterface {
1581     function getPlayerID(address _addr) external returns (uint256);
1582     function getPlayerName(uint256 _pID) external view returns (bytes32);
1583     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1584     function getPlayerAddr(uint256 _pID) external view returns (address);
1585     function getNameFee() external view returns (uint256);
1586     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1587     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1588     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1589 }
1590 
1591 library NameFilter {
1592     /**
1593      * @dev filters name strings
1594      * -converts uppercase to lower case.  
1595      * -makes sure it does not start/end with a space
1596      * -makes sure it does not contain multiple spaces in a row
1597      * -cannot be only numbers
1598      * -cannot start with 0x 
1599      * -restricts characters to A-Z, a-z, 0-9, and space.
1600      * @return reprocessed string in bytes32 format
1601      */
1602     function nameFilter(string _input)
1603         internal
1604         pure
1605         returns(bytes32)
1606     {
1607         bytes memory _temp = bytes(_input);
1608         uint256 _length = _temp.length;
1609         
1610         //sorry limited to 32 characters
1611         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1612         // make sure it doesnt start with or end with space
1613         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1614         // make sure first two characters are not 0x
1615         if (_temp[0] == 0x30)
1616         {
1617             require(_temp[1] != 0x78, "string cannot start with 0x");
1618             require(_temp[1] != 0x58, "string cannot start with 0X");
1619         }
1620         
1621         // create a bool to track if we have a non number character
1622         bool _hasNonNumber;
1623         
1624         // convert & check
1625         for (uint256 i = 0; i < _length; i++)
1626         {
1627             // if its uppercase A-Z
1628             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1629             {
1630                 // convert to lower case a-z
1631                 _temp[i] = byte(uint(_temp[i]) + 32);
1632                 
1633                 // we have a non number
1634                 if (_hasNonNumber == false)
1635                     _hasNonNumber = true;
1636             } else {
1637                 require
1638                 (
1639                     // require character is a space
1640                     _temp[i] == 0x20 || 
1641                     // OR lowercase a-z
1642                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1643                     // or 0-9
1644                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1645                     "string contains invalid characters"
1646                 );
1647                 // make sure theres not 2x spaces in a row
1648                 if (_temp[i] == 0x20)
1649                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1650                 
1651                 // see if we have a character other than a number
1652                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1653                     _hasNonNumber = true;    
1654             }
1655         }
1656         
1657         require(_hasNonNumber == true, "string cannot be only numbers");
1658         
1659         bytes32 _ret;
1660         assembly {
1661             _ret := mload(add(_temp, 32))
1662         }
1663         return (_ret);
1664     }
1665 }
1666 
1667 /**
1668  * @title SafeMath v0.1.9
1669  * @dev Math operations with safety checks that throw on error
1670  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1671  * - added sqrt
1672  * - added sq
1673  * - changed asserts to requires with error log outputs
1674  * - removed div, its useless
1675  */
1676 library SafeMath {
1677     
1678     /**
1679     * @dev Multiplies two numbers, throws on overflow.
1680     */
1681     function mul(uint256 a, uint256 b) 
1682         internal 
1683         pure 
1684         returns (uint256 c) 
1685     {
1686         if (a == 0) {
1687             return 0;
1688         }
1689         c = a * b;
1690         require(c / a == b, "SafeMath mul failed");
1691         return c;
1692     }
1693 
1694     /**
1695     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1696     */
1697     function sub(uint256 a, uint256 b)
1698         internal
1699         pure
1700         returns (uint256) 
1701     {
1702         require(b <= a, "SafeMath sub failed");
1703         return a - b;
1704     }
1705 
1706     /**
1707     * @dev Adds two numbers, throws on overflow.
1708     */
1709     function add(uint256 a, uint256 b)
1710         internal
1711         pure
1712         returns (uint256 c) 
1713     {
1714         c = a + b;
1715         require(c >= a, "SafeMath add failed");
1716         return c;
1717     }
1718     
1719     /**
1720      * @dev gives square root of given x.
1721      */
1722     function sqrt(uint256 x)
1723         internal
1724         pure
1725         returns (uint256 y) 
1726     {
1727         uint256 z = ((add(x,1)) / 2);
1728         y = x;
1729         while (z < y) 
1730         {
1731             y = z;
1732             z = ((add((x / z),z)) / 2);
1733         }
1734     }
1735 
1736     /**
1737      * @dev gives square. multiplies x by x
1738      */
1739     function sq(uint256 x)
1740         internal
1741         pure
1742         returns (uint256)
1743     {
1744         return (mul(x,x));
1745     }
1746 
1747 }