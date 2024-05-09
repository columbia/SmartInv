1 pragma solidity ^0.4.24;
2 
3 contract GEvents {
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
99         uint256 indexed buyerID,
100         uint256 amount,
101         uint256 timeStamp
102     );
103 }
104 
105 contract modularGScam is GEvents {}
106 
107 contract GScam is modularGScam {
108     using SafeMath for *;
109     using NameFilter for string;
110     using RSKeysCalc for uint256;
111 	
112     // TODO: check address
113 	PlayerBookInterface private PlayerBook;
114 
115     address private admin = msg.sender;
116     address private yyyy;
117     address private gggg;
118     
119     string constant public name = "GScam Round #1";
120     string constant public symbol = "GS1";
121     uint256 private rndGap_ = 0;
122 
123     // TODO: check time
124     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
125     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
126     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
127 
128     uint256 constant private preIcoMax_ = 100000000000000000000; // max ico num
129     uint256 constant private preIcoPerEth_ = 1000000000000000000; // in ico, per addr eth
130 
131 //==============================================================================
132 //     _| _ _|_ _    _ _ _|_    _   .
133 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
134 //=============================|================================================
135 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
136     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
137 //****************
138 // PLAYER DATA 
139 //****************
140     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
141     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
142     mapping (uint256 => RSdatasets.Player) public plyr_;   // (pID => data) player data
143     mapping (uint256 => RSdatasets.PlayerRounds) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
144     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
145 //****************
146 // ROUND DATA 
147 //****************
148     RSdatasets.Round public round_;   // round data
149 //****************
150 // TEAM FEE DATA 
151 //****************
152     uint256 public fees_ = 50;          // fee distribution
153     uint256 public potSplit_ = 30;     // pot split distribution
154 
155     uint256 constant private affLv1_ = 50;
156     uint256 constant private affLv2_ = 30;
157     uint256 constant private affLv3_ = 20;
158     uint256 constant private affTol = 20;
159     
160 //==============================================================================
161 //     _ _  _  __|_ _    __|_ _  _  .
162 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
163 //==============================================================================
164     constructor(PlayerBookInterface _PlayerBook, address _yyyy, address _gggg)
165         public
166     {
167         PlayerBook = _PlayerBook;
168         yyyy = _yyyy;
169         gggg = _gggg;
170 	}
171 //==============================================================================
172 //     _ _  _  _|. |`. _  _ _  .
173 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
174 //==============================================================================
175     /**
176      * @dev used to make sure no one can interact with contract until it has 
177      * been activated. 
178      */
179     modifier isActivated() {
180         require(activated_ == true, "its not ready yet"); 
181         _;
182     }
183     
184     /**
185      * @dev prevents contracts from interacting with gscam 
186      */
187     modifier isHuman() {
188         address _addr = msg.sender;
189         uint256 _codeLength;
190         
191         assembly {_codeLength := extcodesize(_addr)}
192         require(_codeLength == 0, "non smart contract address only");
193         _;
194     }
195 
196     /**
197      * @dev sets boundaries for incoming tx 
198      */
199     modifier isWithinLimits(uint256 _eth) {
200         require(_eth >= 1000000000, "too little money");
201         require(_eth <= 100000000000000000000000, "too much money");
202         _;    
203     }
204     
205 //==============================================================================
206 //     _    |_ |. _   |`    _  __|_. _  _  _  .
207 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
208 //====|=========================================================================
209     /**
210      * @dev emergency buy uses last stored affiliate ID and team snek
211      */
212     function()
213         isActivated()
214         isHuman()
215         isWithinLimits(msg.value)
216         public
217         payable
218     {
219         // set up our tx event data and determine if player is new or not
220         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
221             
222         // fetch player id
223         uint256 _pID = pIDxAddr_[msg.sender];
224         
225         // buy core 
226         buyCore(_pID, plyr_[_pID].laff, _eventData_);
227     }
228     
229     /**
230      * @dev converts all incoming ethereum to keys.
231      * -functionhash- 0x8f38f309 (using ID for affiliate)
232      * -functionhash- 0x98a0871d (using address for affiliate)
233      * -functionhash- 0xa65b37a1 (using name for affiliate)
234      * @param _affCode the ID/address/name of the player who gets the affiliate fee
235      */
236     function buyXid(uint256 _affCode)
237         isActivated()
238         isHuman()
239         isWithinLimits(msg.value)
240         public
241         payable
242     {
243         // set up our tx event data and determine if player is new or not
244         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
245         
246         // fetch player id
247         uint256 _pID = pIDxAddr_[msg.sender];
248         
249         // manage affiliate residuals
250         // if no affiliate code was given or player tried to use their own, lolz
251          if (_affCode != plyr_[_pID].laff && _affCode != _pID && plyr_[_pID].laff == 0) {
252             // update last affiliate 
253             plyr_[_pID].laff = _affCode;
254         }
255         _affCode = plyr_[_pID].laff;
256 
257         // buy core 
258         buyCore(_pID, _affCode, _eventData_);
259     }
260     
261     function buyXaddr(address _affCode)
262         isActivated()
263         isHuman()
264         isWithinLimits(msg.value)
265         public
266         payable
267     {
268         // set up our tx event data and determine if player is new or not
269         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
270         
271         // fetch player id
272         uint256 _pID = pIDxAddr_[msg.sender];
273         
274         // manage affiliate residuals
275         uint256 _affID;
276         // get affiliate ID from aff Code 
277         _affID = pIDxAddr_[_affCode];
278             
279         // if affID is not the same as previously stored 
280         if (_affID != plyr_[_pID].laff && _affID != _pID && plyr_[_pID].laff == 0)
281         {
282             // update last affiliate
283             plyr_[_pID].laff = _affID;
284         }
285 
286         _affID = plyr_[_pID].laff;
287         
288         // buy core 
289         buyCore(_pID, _affID, _eventData_);
290     }
291     
292     function buyXname(bytes32 _affCode)
293         isActivated()
294         isHuman()
295         isWithinLimits(msg.value)
296         public
297         payable
298     {
299         // set up our tx event data and determine if player is new or not
300         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
301         
302         // fetch player id
303         uint256 _pID = pIDxAddr_[msg.sender];
304         
305         // manage affiliate residuals
306         uint256 _affID;
307         // get affiliate ID from aff Code
308         _affID = pIDxName_[_affCode];
309             
310         // if affID is not the same as previously stored 
311         if (_affID != plyr_[_pID].laff && _affID != _pID && plyr_[_pID].laff == 0)
312         {
313             // update last affiliate
314             plyr_[_pID].laff = _affID;
315         }
316 
317         _affID = plyr_[_pID].laff;
318         
319         // buy core 
320         buyCore(_pID, _affID, _eventData_);
321     }
322     
323     /**
324      * @dev essentially the same as buy, but instead of you sending ether 
325      * from your wallet, it uses your unwithdrawn earnings.
326      * -functionhash- 0x349cdcac (using ID for affiliate)
327      * -functionhash- 0x82bfc739 (using address for affiliate)
328      * -functionhash- 0x079ce327 (using name for affiliate)
329      * @param _affCode the ID/address/name of the player who gets the affiliate fee
330      * @param _eth amount of earnings to use (remainder returned to gen vault)
331      */
332     function reLoadXid(uint256 _affCode, uint256 _eth)
333         isActivated()
334         isHuman()
335         isWithinLimits(_eth)
336         public
337     {
338         // set up our tx event data
339         RSdatasets.EventReturns memory _eventData_;
340         
341         // fetch player ID
342         uint256 _pID = pIDxAddr_[msg.sender];
343 
344         if (_affCode != plyr_[_pID].laff && _affCode != _pID && plyr_[_pID].laff == 0) {
345             // update last affiliate 
346             plyr_[_pID].laff = _affCode;
347         }
348         _affCode = plyr_[_pID].laff;
349 
350         // reload core
351         reLoadCore(_pID, _affCode, _eth, _eventData_);
352     }
353     
354     function reLoadXaddr(address _affCode, uint256 _eth)
355         isActivated()
356         isHuman()
357         isWithinLimits(_eth)
358         public
359     {
360         // set up our tx event data
361         RSdatasets.EventReturns memory _eventData_;
362         
363         // fetch player ID
364         uint256 _pID = pIDxAddr_[msg.sender];
365         
366         // manage affiliate residuals
367         uint256 _affID;
368         // get affiliate ID from aff Code 
369         _affID = pIDxAddr_[_affCode];
370             
371         // if affID is not the same as previously stored 
372         if (_affID != plyr_[_pID].laff && _affID != _pID && plyr_[_pID].laff == 0)
373         {
374             // update last affiliate
375             plyr_[_pID].laff = _affID;
376         }
377 
378         _affID = plyr_[_pID].laff;
379                 
380         // reload core
381         reLoadCore(_pID, _affID, _eth, _eventData_);
382     }
383     
384     function reLoadXname(bytes32 _affCode, uint256 _eth)
385         isActivated()
386         isHuman()
387         isWithinLimits(_eth)
388         public
389     {
390         // set up our tx event data
391         RSdatasets.EventReturns memory _eventData_;
392         
393         // fetch player ID
394         uint256 _pID = pIDxAddr_[msg.sender];
395         
396         // manage affiliate residuals
397         uint256 _affID;
398         // get affiliate ID from aff Code 
399         _affID = pIDxName_[_affCode];
400             
401         // if affID is not the same as previously stored 
402         if (_affID != plyr_[_pID].laff && _affID != _pID && plyr_[_pID].laff == 0)
403         {
404             // update last affiliate
405             plyr_[_pID].laff = _affID;
406         }
407 
408         _affID = plyr_[_pID].laff;
409 
410         // reload core
411         reLoadCore(_pID, _affID, _eth, _eventData_);
412     }
413 
414     /**
415      * @dev withdraws all of your earnings.
416      * -functionhash- 0x3ccfd60b
417      */
418     function withdraw()
419         isActivated()
420         isHuman()
421         public
422     {        
423         // grab time
424         uint256 _now = now;
425         
426         // fetch player ID
427         uint256 _pID = pIDxAddr_[msg.sender];
428         
429         // setup temp var for player eth
430         uint256 _eth;
431         
432         // check to see if round has ended and no one has run round end yet
433         if (_now > round_.end && round_.ended == false && round_.plyr != 0)
434         {
435             // set up our tx event data
436             RSdatasets.EventReturns memory _eventData_;
437             
438             // end the round (distributes pot)
439 			round_.ended = true;
440             _eventData_ = endRound(_eventData_);
441             
442 			// get their earnings
443             _eth = withdrawEarnings(_pID);
444             
445             // gib moni
446             if (_eth > 0)
447                 plyr_[_pID].addr.transfer(_eth);    
448             
449             // build event data
450             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
451             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
452             
453             // fire withdraw and distribute event
454             emit GEvents.onWithdrawAndDistribute
455             (
456                 msg.sender, 
457                 plyr_[_pID].name, 
458                 _eth, 
459                 _eventData_.compressedData, 
460                 _eventData_.compressedIDs, 
461                 _eventData_.winnerAddr, 
462                 _eventData_.winnerName, 
463                 _eventData_.amountWon, 
464                 _eventData_.newPot, 
465                 _eventData_.genAmount
466             );
467             
468         // in any other situation
469         } else {
470             // get their earnings
471             _eth = withdrawEarnings(_pID);
472             
473             // gib moni
474             if (_eth > 0)
475                 plyr_[_pID].addr.transfer(_eth);
476             
477             // fire withdraw event
478             emit GEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
479         }
480     }
481     
482     /**
483      * @dev use these to register names.  they are just wrappers that will send the
484      * registration requests to the PlayerBook contract.  So registering here is the 
485      * same as registering there.  UI will always display the last name you registered.
486      * but you will still own all previously registered names to use as affiliate 
487      * links.
488      * - must pay a registration fee.
489      * - name must be unique
490      * - names will be converted to lowercase
491      * - name cannot start or end with a space 
492      * - cannot have more than 1 space in a row
493      * - cannot be only numbers
494      * - cannot start with 0x 
495      * - name must be at least 1 char
496      * - max length of 32 characters long
497      * - allowed characters: a-z, 0-9, and space
498      * -functionhash- 0x921dec21 (using ID for affiliate)
499      * -functionhash- 0x3ddd4698 (using address for affiliate)
500      * -functionhash- 0x685ffd83 (using name for affiliate)
501      * @param _nameString players desired name
502      * @param _affCode affiliate ID, address, or name of who referred you
503      * @param _all set to true if you want this to push your info to all games 
504      * (this might cost a lot of gas)
505      */
506     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
507         isHuman()
508         public
509         payable
510     {
511         bytes32 _name = _nameString.nameFilter();
512         address _addr = msg.sender;
513         uint256 _paid = msg.value;
514         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
515 
516         uint256 _pID = pIDxAddr_[_addr];
517         
518         // fire event
519         emit GEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
520     }
521     
522     function registerNameXaddr(string _nameString, address _affCode, bool _all)
523         isHuman()
524         public
525         payable
526     {
527         bytes32 _name = _nameString.nameFilter();
528         address _addr = msg.sender;
529         uint256 _paid = msg.value;
530         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
531         
532         uint256 _pID = pIDxAddr_[_addr];
533         
534         // fire event
535         emit GEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
536     }
537     
538     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
539         isHuman()
540         public
541         payable
542     {
543         bytes32 _name = _nameString.nameFilter();
544         address _addr = msg.sender;
545         uint256 _paid = msg.value;
546         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
547         
548         uint256 _pID = pIDxAddr_[_addr];
549         
550         // fire event
551         emit GEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
552     }
553 //==============================================================================
554 //     _  _ _|__|_ _  _ _  .
555 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
556 //=====_|=======================================================================
557     /**
558      * @dev return the price buyer will pay for next 1 individual key.
559      * -functionhash- 0x018a25e8
560      * @return price for next key bought (in wei format)
561      */
562     function getBuyPrice()
563         public 
564         view 
565         returns(uint256)
566     {          
567         // grab time
568         uint256 _now = now;
569         
570         // are we in a round?
571         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
572             return ( (round_.keys.add(1000000000000000000)).ethRec(1000000000000000000) );
573         else // rounds over.  need price for new round
574             return ( 75000000000000 ); // init
575     }
576     
577     /**
578      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
579      * provider
580      * -functionhash- 0xc7e284b8
581      * @return time left in seconds
582      */
583     function getTimeLeft()
584         public
585         view
586         returns(uint256)
587     {
588         // grab time
589         uint256 _now = now;
590         
591         if (_now < round_.end)
592             if (_now > round_.strt + rndGap_)
593                 return( (round_.end).sub(_now) );
594             else
595                 return( (round_.strt + rndGap_).sub(_now));
596         else
597             return(0);
598     }
599     
600     /**
601      * @dev returns player earnings per vaults 
602      * -functionhash- 0x63066434
603      * @return winnings vault
604      * @return general vault
605      * @return affiliate vault
606      */
607     function getPlayerVaults(uint256 _pID)
608         public
609         view
610         returns(uint256 ,uint256, uint256)
611     {
612         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
613         if (now > round_.end && round_.ended == false && round_.plyr != 0)
614         {
615             // if player is winner 
616             if (round_.plyr == _pID)
617             {
618                 return
619                 (
620                     (plyr_[_pID].win).add( ((round_.pot).mul(48)) / 100 ),
621                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)   ),
622                     plyr_[_pID].aff
623                 );
624             // if player is not the winner
625             } else {
626                 return
627                 (
628                     plyr_[_pID].win,
629                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)  ),
630                     plyr_[_pID].aff
631                 );
632             }
633             
634         // if round is still going on, or round has ended and round end has been ran
635         } else {
636             return
637             (
638                 plyr_[_pID].win,
639                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),
640                 plyr_[_pID].aff
641             );
642         }
643     }
644     
645     /**
646      * solidity hates stack limits.  this lets us avoid that hate 
647      */
648     function getPlayerVaultsHelper(uint256 _pID)
649         private
650         view
651         returns(uint256)
652     {
653         return(  ((((round_.mask).add(((((round_.pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_.keys))).mul(plyrRnds_[_pID].keys)) / 1000000000000000000)  );
654     }
655     
656     /**
657      * @dev returns all current round info needed for front end
658      * -functionhash- 0x747dff42
659      * @return total keys
660      * @return time ends
661      * @return time started
662      * @return current pot 
663      * @return current player ID in lead 
664      * @return current player in leads address 
665      * @return current player in leads name
666      * @return airdrop tracker # & airdrop pot
667      */
668     function getCurrentRoundInfo()
669         public
670         view
671         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
672     {
673         return
674         (
675             round_.keys,              //0
676             round_.end,               //1
677             round_.strt,              //2
678             round_.pot,               //3
679             round_.plyr,              //4
680             plyr_[round_.plyr].addr,  //5
681             plyr_[round_.plyr].name,  //6
682             airDropTracker_ + (airDropPot_ * 1000)              //7
683         );
684     }
685 
686     /**
687      * @dev returns player info based on address.  if no address is given, it will 
688      * use msg.sender 
689      * -functionhash- 0xee0b5d8b
690      * @param _addr address of the player you want to lookup 
691      * @return player ID 
692      * @return player name
693      * @return keys owned (current round)
694      * @return winnings vault
695      * @return general vault 
696      * @return affiliate vault 
697 	 * @return player round eth
698      */
699     function getPlayerInfoByAddress(address _addr)
700         public 
701         view 
702         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
703     {
704         if (_addr == address(0))
705         {
706             _addr == msg.sender;
707         }
708         uint256 _pID = pIDxAddr_[_addr];
709         
710         return
711         (
712             _pID,                               //0
713             plyr_[_pID].name,                   //1
714             plyrRnds_[_pID].keys,         //2
715             plyr_[_pID].win,                    //3
716             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),       //4
717             plyr_[_pID].aff,                    //5
718             plyrRnds_[_pID].eth           //6
719         );
720     }
721 
722 //==============================================================================
723 //     _ _  _ _   | _  _ . _  .
724 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
725 //=====================_|=======================================================
726     /**
727      * @dev logic runs whenever a buy order is executed.  determines how to handle 
728      * incoming eth depending on if we are in an active round or not
729      */
730     function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
731         private
732     {
733         // grab time
734         uint256 _now = now;
735         
736         // if round is active
737         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
738         {
739             // call core 
740             core(_pID, msg.value, _affID, _eventData_);
741         
742         // if round is not active     
743         } else {
744             // check to see if end round needs to be ran
745             if (_now > round_.end && round_.ended == false) 
746             {
747                 // end the round (distributes pot) & start new round
748 			    round_.ended = true;
749                 _eventData_ = endRound(_eventData_);
750                 
751                 // build event data
752                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
753                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
754                 
755                 // fire buy and distribute event 
756                 emit GEvents.onBuyAndDistribute
757                 (
758                     msg.sender, 
759                     plyr_[_pID].name, 
760                     msg.value, 
761                     _eventData_.compressedData, 
762                     _eventData_.compressedIDs, 
763                     _eventData_.winnerAddr, 
764                     _eventData_.winnerName, 
765                     _eventData_.amountWon, 
766                     _eventData_.newPot, 
767                     _eventData_.genAmount
768                 );
769             }
770             
771             // put eth in players vault 
772             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
773         }
774     }
775     
776     /**
777      * @dev logic runs whenever a reload order is executed.  determines how to handle 
778      * incoming eth depending on if we are in an active round or not 
779      */
780     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, RSdatasets.EventReturns memory _eventData_)
781         private
782     {
783         // grab time
784         uint256 _now = now;
785         
786         // if round is active
787         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
788         {
789             // get earnings from all vaults and return unused to gen vault
790             // because we use a custom safemath library.  this will throw if player 
791             // tried to spend more eth than they have.
792             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
793             
794             // call core 
795             core(_pID, _eth, _affID, _eventData_);
796         
797         // if round is not active and end round needs to be ran   
798         } else if (_now > round_.end && round_.ended == false) {
799             // end the round (distributes pot) & start new round
800             round_.ended = true;
801             _eventData_ = endRound(_eventData_);
802                 
803             // build event data
804             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
805             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
806                 
807             // fire buy and distribute event 
808             emit GEvents.onReLoadAndDistribute
809             (
810                 msg.sender, 
811                 plyr_[_pID].name, 
812                 _eventData_.compressedData, 
813                 _eventData_.compressedIDs, 
814                 _eventData_.winnerAddr, 
815                 _eventData_.winnerName, 
816                 _eventData_.amountWon, 
817                 _eventData_.newPot, 
818                 _eventData_.genAmount
819             );
820         }
821     }
822     
823     /**
824      * @dev this is the core logic for any buy/reload that happens while a round 
825      * is live.
826      */
827     function core(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
828         private
829     {
830         require(_affID != 0, "must have affID");
831 
832         // if player is new to round
833         if (plyrRnds_[_pID].keys == 0)
834             _eventData_ = managePlayer(_pID, _eventData_);
835         
836         // early round eth limiter 
837         if (round_.eth < preIcoMax_ && plyrRnds_[_pID].eth.add(_eth) > preIcoPerEth_)
838         {
839             uint256 _availableLimit = (preIcoPerEth_).sub(plyrRnds_[_pID].eth);
840             uint256 _refund = _eth.sub(_availableLimit);
841             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
842             _eth = _availableLimit;
843         }
844         
845         // if eth left is greater than min eth allowed (sorry no pocket lint)
846         if (_eth > 1000000000) 
847         {
848             
849             // mint the new keys
850             uint256 _keys = (round_.eth).keysRec(_eth);
851             
852             // if they bought at least 1 whole key
853             if (_keys >= 1000000000000000000)
854             {
855             updateTimer(_keys);
856 
857             // set new leaders
858             if (round_.plyr != _pID)
859                 round_.plyr = _pID;  
860             
861             // set the new leader bool to true
862             _eventData_.compressedData = _eventData_.compressedData + 100;
863         }
864             
865             // manage airdrops
866             if (_eth >= 100000000000000000)
867             {
868             airDropTracker_++;
869             if (airdrop() == true)
870             {
871                 // gib muni
872                 uint256 _prize;
873                 if (_eth >= 10000000000000000000)
874                 {
875                     // calculate prize and give it to winner
876                     _prize = ((airDropPot_).mul(75)) / 100;
877                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
878                     
879                     // adjust airDropPot 
880                     airDropPot_ = (airDropPot_).sub(_prize);
881                     
882                     // let event know a tier 3 prize was won 
883                     _eventData_.compressedData += 300000000000000000000000000000000;
884                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
885                     // calculate prize and give it to winner
886                     _prize = ((airDropPot_).mul(50)) / 100;
887                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
888                     
889                    // ust airDropPot 
890                     airDropPot_ = (airDropPot_).sub(_prize);
891                     
892                     // let event know a tier 2 prize was won 
893                     _eventData_.compressedData += 200000000000000000000000000000000;
894                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
895                     // calculate prize and give it to winner
896                     _prize = ((airDropPot_).mul(25)) / 100;
897                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
898                     
899                     // adjust airDropPot 
900                     airDropPot_ = (airDropPot_).sub(_prize);
901                     
902                     // let event know a tier 1 prize was won 
903                     _eventData_.compressedData += 100000000000000000000000000000000;
904                 }
905                 // set airdrop happened bool to true
906                 _eventData_.compressedData += 10000000000000000000000000000000;
907                 // let event know how much was won 
908                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
909                 
910                 // reset air drop tracker
911                 airDropTracker_ = 0;
912             }
913         }
914     
915             // store the air drop tracker number (number of buys since last airdrop)
916             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
917             
918             // update player 
919             plyrRnds_[_pID].keys = _keys.add(plyrRnds_[_pID].keys);
920             plyrRnds_[_pID].eth = _eth.add(plyrRnds_[_pID].eth);
921             
922             // update round
923             round_.keys = _keys.add(round_.keys);
924             round_.eth = _eth.add(round_.eth);
925     
926             // distribute eth
927             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
928             _eventData_ = distributeInternal(_pID, _eth, _keys, _eventData_);
929             
930             // call end tx function to fire end tx event.
931 		    endTx(_pID, _eth, _keys, _eventData_);
932         }
933     }
934 //==============================================================================
935 //     _ _ | _   | _ _|_ _  _ _  .
936 //    (_(_||(_|_||(_| | (_)| _\  .
937 //==============================================================================
938     /**
939      * @dev calculates unmasked earnings (just calculates, does not update mask)
940      * @return earnings in wei format
941      */
942     function calcUnMaskedEarnings(uint256 _pID)
943         private
944         view
945         returns(uint256)
946     {
947         return((((round_.mask).mul(plyrRnds_[_pID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID].mask));
948     }
949     
950     /** 
951      * @dev returns the amount of keys you would get given an amount of eth. 
952      * -functionhash- 0xce89c80c
953      * @param _eth amount of eth sent in 
954      * @return keys received 
955      */
956     function calcKeysReceived(uint256 _eth)
957         public
958         view
959         returns(uint256)
960     {
961         // grab time
962         uint256 _now = now;
963         
964         // are we in a round?
965         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
966             return ( (round_.eth).keysRec(_eth) );
967         else // rounds over.  need keys for new round
968             return ( (_eth).keys() );
969     }
970     
971     /** 
972      * @dev returns current eth price for X keys.  
973      * -functionhash- 0xcf808000
974      * @param _keys number of keys desired (in 18 decimal format)
975      * @return amount of eth needed to send
976      */
977     function iWantXKeys(uint256 _keys)
978         public
979         view
980         returns(uint256)
981     {
982         // grab time
983         uint256 _now = now;
984         
985         // are we in a round?
986         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
987             return ( (round_.keys.add(_keys)).ethRec(_keys) );
988         else // rounds over.  need price for new round
989             return ( (_keys).eth() );
990     }
991 //==============================================================================
992 //    _|_ _  _ | _  .
993 //     | (_)(_)|_\  .
994 //==============================================================================
995     /**
996 	 * @dev receives name/player info from names contract 
997      */
998     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
999         external
1000     {
1001         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1002         if (pIDxAddr_[_addr] != _pID)
1003             pIDxAddr_[_addr] = _pID;
1004         if (pIDxName_[_name] != _pID)
1005             pIDxName_[_name] = _pID;
1006         if (plyr_[_pID].addr != _addr)
1007             plyr_[_pID].addr = _addr;
1008         if (plyr_[_pID].name != _name)
1009             plyr_[_pID].name = _name;
1010         if (plyr_[_pID].laff != _laff && plyr_[_pID].laff != 0 && _laff != _pID)
1011             plyr_[_pID].laff = _laff;
1012         if (plyrNames_[_pID][_name] == false)
1013             plyrNames_[_pID][_name] = true;
1014     }
1015     
1016     /**
1017      * @dev receives entire player name list 
1018      */
1019     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1020         external
1021     {
1022         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1023         if(plyrNames_[_pID][_name] == false)
1024             plyrNames_[_pID][_name] = true;
1025     }   
1026         
1027     /**
1028      * @dev gets existing or registers new pID.  use this when a player may be new
1029      * @return pID 
1030      */
1031     function determinePID(RSdatasets.EventReturns memory _eventData_)
1032         private
1033         returns (RSdatasets.EventReturns)
1034     {
1035         uint256 _pID = pIDxAddr_[msg.sender];
1036         // if player is new to this version of gscam
1037         if (_pID == 0)
1038         {
1039             // grab their player ID, name and last aff ID, from player names contract 
1040             _pID = PlayerBook.getPlayerID(msg.sender);
1041             bytes32 _name = PlayerBook.getPlayerName(_pID);
1042             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1043             
1044             // set up player account 
1045             pIDxAddr_[msg.sender] = _pID;
1046             plyr_[_pID].addr = msg.sender;
1047             
1048             if (_name != "")
1049             {
1050                 pIDxName_[_name] = _pID;
1051                 plyr_[_pID].name = _name;
1052                 plyrNames_[_pID][_name] = true;
1053             }
1054             
1055             if (_laff != 0 && _laff != _pID)
1056                 plyr_[_pID].laff = _laff;
1057             
1058             // set the new player bool to true
1059             _eventData_.compressedData = _eventData_.compressedData + 1;
1060         } 
1061         return (_eventData_);
1062     }
1063 
1064     /**
1065      * @dev decides if round end needs to be run & new round started.  and if 
1066      * player unmasked earnings from previously played rounds need to be moved.
1067      */
1068     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1069         private
1070         returns (RSdatasets.EventReturns)
1071     {            
1072         // set the joined round bool to true
1073         _eventData_.compressedData = _eventData_.compressedData + 10;
1074         
1075         return(_eventData_);
1076     }
1077     
1078     /**
1079      * @dev ends the round. manages paying out winner/splitting up pot
1080      */
1081     function endRound(RSdatasets.EventReturns memory _eventData_)
1082         private
1083         returns (RSdatasets.EventReturns)
1084     {        
1085         // grab our winning player and team id's
1086         uint256 _winPID = round_.plyr;
1087         
1088         // grab our pot amount
1089         // add airdrop pot into the final pot
1090         uint256 _pot = round_.pot.add(airDropPot_);
1091         
1092         // calculate our winner share, community rewards, gen share, 
1093         // p3d share, and amount reserved for next pot 
1094         uint256 _win = (_pot.mul(60)) / 100;
1095         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1096         uint256 _com = ((_pot.sub(_win)).sub(_gen));
1097         
1098         // calculate ppt for round mask
1099         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1100         uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);
1101         if (_dust > 0)
1102         {
1103             _gen = _gen.sub(_dust);
1104             _com = _com.add(_dust);
1105         }
1106         
1107         // pay our winner
1108         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1109 
1110         yyyy.transfer((_com.mul(80)/100));
1111         gggg.transfer((_com.sub((_com.mul(80)/100))));
1112         
1113         // distribute gen portion to key holders
1114         round_.mask = _ppt.add(round_.mask);
1115             
1116         // prepare event data
1117         _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);
1118         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1119         _eventData_.winnerAddr = plyr_[_winPID].addr;
1120         _eventData_.winnerName = plyr_[_winPID].name;
1121         _eventData_.amountWon = _win;
1122         _eventData_.genAmount = _gen;
1123         _eventData_.newPot = 0;
1124         
1125         return(_eventData_);
1126     }
1127     
1128     /**
1129      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1130      */
1131     function updateGenVault(uint256 _pID)
1132         private 
1133     {
1134         uint256 _earnings = calcUnMaskedEarnings(_pID);
1135         if (_earnings > 0)
1136         {
1137             // put in gen vault
1138             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1139             // zero out their earnings by updating mask
1140             plyrRnds_[_pID].mask = _earnings.add(plyrRnds_[_pID].mask);
1141         }
1142     }
1143     
1144     /**
1145      * @dev updates round timer based on number of whole keys bought.
1146      */
1147     function updateTimer(uint256 _keys)
1148         private
1149     {
1150         // grab time
1151         uint256 _now = now;
1152         
1153         // calculate time based on number of keys bought
1154         uint256 _newTime;
1155         if (_now > round_.end && round_.plyr == 0)
1156             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1157         else
1158             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_.end);
1159         
1160         // compare to max and set new end time
1161         if (_newTime < (rndMax_).add(_now))
1162             round_.end = _newTime;
1163         else
1164             round_.end = rndMax_.add(_now);
1165     }
1166     
1167     /**
1168      * @dev generates a random number between 0-99 and checks to see if thats
1169      * resulted in an airdrop win
1170      * @return do we have a winner?
1171      */
1172     function airdrop()
1173         private 
1174         view 
1175         returns(bool)
1176     {
1177         uint256 seed = uint256(keccak256(abi.encodePacked(
1178             
1179             (block.timestamp).add
1180             (block.difficulty).add
1181             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1182             (block.gaslimit).add
1183             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1184             (block.number)
1185             
1186         )));
1187         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1188             return(true);
1189         else
1190             return(false);
1191     }
1192 
1193     /**
1194      * @dev distributes eth based on fees to com, aff, and p3d
1195      */
1196     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1197         private
1198         returns(RSdatasets.EventReturns)
1199     {
1200         // pay 5% out to community rewards
1201         uint256 _com = (_eth.mul(5)) / 100;
1202                 
1203         // distribute share to affiliate
1204         uint256 _affs = (_eth.mul(affTol)) / 100;
1205         uint256 _comTmp;
1206         uint256 _affIDNext;        
1207 
1208         // lv1
1209         (_affIDNext, _comTmp) = updateAff(_pID, _affs, _affID, affLv1_);
1210         if (_comTmp > 0){
1211            _com = (_com.add(_comTmp));
1212         }
1213 
1214         // lv2
1215         (_affIDNext, _comTmp) = updateAff(_pID, _affs, _affIDNext, affLv2_);
1216         if (_comTmp > 0){
1217            _com = (_com.add(_comTmp));
1218         }
1219 
1220         // lv3
1221         (_affIDNext, _comTmp) = updateAff(_pID, _affs, _affIDNext, affLv3_);
1222         if (_comTmp > 0){
1223            _com = (_com.add(_comTmp));
1224         }
1225 
1226         yyyy.transfer((_com.mul(80)/100));
1227         gggg.transfer((_com.sub((_com.mul(80)/100))));
1228         
1229         return(_eventData_);
1230     }
1231     
1232     /**
1233      * @dev distributes eth based on fees to gen and pot
1234      */
1235     function distributeInternal(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1236         private
1237         returns(RSdatasets.EventReturns)
1238     {
1239         // calculate gen share
1240         uint256 _gen = (_eth.mul(fees_)) / 100;
1241         
1242         // toss 5% into airdrop pot 
1243         uint256 _air = (_eth / 20);
1244         airDropPot_ = airDropPot_.add(_air);
1245                 
1246         // calculate pot (20%)
1247         uint256 _otherP = affTol.add(fees_).add(10);
1248         uint256 _pot = _eth.sub((_eth.mul(_otherP)) / 100);
1249         
1250         // distribute gen share (thats what updateMasks() does) and adjust
1251         // balances for dust.
1252         uint256 _dust = updateMasks(_pID, _gen, _keys);
1253         if (_dust > 0)
1254             _gen = _gen.sub(_dust);
1255         
1256         // add eth to pot
1257         round_.pot = _pot.add(_dust).add(round_.pot);
1258         
1259         // set up event data
1260         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1261         _eventData_.potAmount = _pot;
1262         
1263         return(_eventData_);
1264     }
1265 
1266     function updateAff(uint256 _pID, uint256 _affEths, uint256 _affID, uint256 _affP)
1267         private
1268         returns(uint256, uint256)
1269     {
1270         uint256 _aff = (_affEths.mul(_affP)) / 100;
1271         uint256 _key = (round_.eth).keysRec(_aff);
1272 
1273         if (_affID != _pID && plyr_[_affID].name != '') {
1274             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1275             emit GEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1276 
1277             plyrRnds_[_affID].keys = _key.add(plyrRnds_[_affID].keys);
1278             plyrRnds_[_affID].mask = ((round_.mask.mul(_key)) / (1000000000000000000)).add(plyrRnds_[_affID].mask);
1279             
1280             round_.keys = _key.add(round_.keys);
1281 
1282             return (plyr_[_affID].laff, 0);
1283         }
1284         
1285         return (0, _aff);
1286     }         
1287 
1288 
1289     /**
1290      * @dev updates masks for round and player when keys are bought
1291      * @return dust left over 
1292      */
1293     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1294         private
1295         returns(uint256)
1296     {
1297         /* MASKING NOTES
1298             earnings masks are a tricky thing for people to wrap their minds around.
1299             the basic thing to understand here.  is were going to have a global
1300             tracker based on profit per share for each round, that increases in
1301             relevant proportion to the increase in share supply.
1302             
1303             the player will have an additional mask that basically says "based
1304             on the rounds mask, my shares, and how much i've already withdrawn,
1305             how much is still owed to me?"
1306         */
1307         
1308         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1309         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1310         round_.mask = _ppt.add(round_.mask);
1311             
1312         // calculate player earning from their own buy (only based on the keys
1313         // they just bought).  & update player earnings mask
1314         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1315         plyrRnds_[_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID].mask);
1316         
1317         // calculate & return dust
1318         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1319     }
1320     
1321     /**
1322      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1323      * @return earnings in wei format
1324      */
1325     function withdrawEarnings(uint256 _pID)
1326         private
1327         returns(uint256)
1328     {
1329         // update gen vault
1330         updateGenVault(_pID);
1331         
1332         // from vaults 
1333         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1334         if (_earnings > 0)
1335         {
1336             plyr_[_pID].win = 0;
1337             plyr_[_pID].gen = 0;
1338             plyr_[_pID].aff = 0;
1339         }
1340 
1341         return(_earnings);
1342     }
1343     
1344     /**
1345      * @dev prepares compression data and fires event for buy or reload tx's
1346      */
1347     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1348         private
1349     {
1350         _eventData_.compressedData = _eventData_.compressedData + (now * 100000000000000000);
1351         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1352         
1353         emit GEvents.onEndTx
1354         (
1355             _eventData_.compressedData,
1356             _eventData_.compressedIDs,
1357             plyr_[_pID].name,
1358             msg.sender,
1359             _eth,
1360             _keys,
1361             _eventData_.winnerAddr,
1362             _eventData_.winnerName,
1363             _eventData_.amountWon,
1364             _eventData_.newPot,
1365             _eventData_.genAmount,
1366             _eventData_.potAmount,
1367             airDropPot_
1368         );
1369     }
1370 
1371     /** upon contract deploy, it will be deactivated.  this is a one time
1372      * use function that will activate the contract.  we do this so devs 
1373      * have time to set things up on the web end                            **/
1374     bool public activated_ = false;
1375     function activate()
1376         public
1377     {
1378         // only team just can activate
1379         require(msg.sender == admin, "only admin can activate");
1380 
1381         
1382         // can only be ran once
1383         require(activated_ == false, "gscam already activated");
1384         
1385         // activate the contract 
1386         activated_ = true;
1387         
1388         round_.strt = now - rndGap_;
1389         round_.end = now + rndInit_;
1390     }
1391 }
1392 
1393 //==============================================================================
1394 //   __|_ _    __|_ _  .
1395 //  _\ | | |_|(_ | _\  .
1396 //==============================================================================
1397 library RSdatasets {
1398     //compressedData key
1399     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1400         // 0 - new player (bool)
1401         // 1 - joined round (bool)
1402         // 2 - new  leader (bool)
1403         // 3-5 - air drop tracker (uint 0-999)
1404         // 6-16 - round end time
1405         // 17 - winnerTeam
1406         // 18 - 28 timestamp 
1407         // 29 - team
1408         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1409         // 31 - airdrop happened bool
1410         // 32 - airdrop tier 
1411         // 33 - airdrop amount won
1412     //compressedIDs key
1413     // [77-52][51-26][25-0]
1414         // 0-25 - pID 
1415         // 26-51 - winPID
1416         // 52-77 - rID
1417     struct EventReturns {
1418         uint256 compressedData;
1419         uint256 compressedIDs;
1420         address winnerAddr;         // winner address
1421         bytes32 winnerName;         // winner name
1422         uint256 amountWon;          // amount won
1423         uint256 newPot;             // amount in new pot
1424         uint256 genAmount;          // amount distributed to gen
1425         uint256 potAmount;          // amount added to pot
1426     }
1427     struct Player {
1428         address addr;   // player address
1429         bytes32 name;   // player name
1430         uint256 win;    // winnings vault
1431         uint256 gen;    // general vault
1432         uint256 aff;    // affiliate vault
1433         uint256 laff;   // last affiliate id used
1434     }
1435     struct PlayerRounds {
1436         uint256 eth;    // eth player has added to round (used for eth limiter)
1437         uint256 keys;   // keys
1438         uint256 mask;   // player mask 
1439     }
1440     struct Round {
1441         uint256 plyr;   // pID of player in lead
1442         uint256 end;    // time ends/ended
1443         bool ended;     // has round end function been ran
1444         uint256 strt;   // time round started
1445         uint256 keys;   // keys
1446         uint256 eth;    // total eth in
1447         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1448         uint256 mask;   // global mask
1449     }
1450 }
1451 
1452 //==============================================================================
1453 //  |  _      _ _ | _  .
1454 //  |<(/_\/  (_(_||(_  .
1455 //=======/======================================================================
1456 library RSKeysCalc {
1457     using SafeMath for *;
1458     /**
1459      * @dev calculates number of keys received given X eth 
1460      * @param _curEth current amount of eth in contract 
1461      * @param _newEth eth being spent
1462      * @return amount of ticket purchased
1463      */
1464     function keysRec(uint256 _curEth, uint256 _newEth)
1465         internal
1466         pure
1467         returns (uint256)
1468     {
1469         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1470     }
1471     
1472     /**
1473      * @dev calculates amount of eth received if you sold X keys 
1474      * @param _curKeys current amount of keys that exist 
1475      * @param _sellKeys amount of keys you wish to sell
1476      * @return amount of eth received
1477      */
1478     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1479         internal
1480         pure
1481         returns (uint256)
1482     {
1483         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1484     }
1485 
1486     /**
1487      * @dev calculates how many keys would exist with given an amount of eth
1488      * @param _eth eth "in contract"
1489      * @return number of keys that would exist
1490      */
1491     function keys(uint256 _eth) 
1492         internal
1493         pure
1494         returns(uint256)
1495     {
1496         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1497     }
1498     
1499     /**
1500      * @dev calculates how much eth would be in contract given a number of keys
1501      * @param _keys number of keys "in contract" 
1502      * @return eth that would exists
1503      */
1504     function eth(uint256 _keys) 
1505         internal
1506         pure
1507         returns(uint256)  
1508     {
1509         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1510     }
1511 }
1512 
1513 interface PlayerBookInterface {
1514     function getPlayerID(address _addr) external returns (uint256);
1515     function getPlayerName(uint256 _pID) external view returns (bytes32);
1516     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1517     function getPlayerAddr(uint256 _pID) external view returns (address);
1518     function getNameFee() external view returns (uint256);
1519     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1520     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1521     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1522 }
1523 
1524 library NameFilter {
1525     /**
1526      * @dev filters name strings
1527      * -converts uppercase to lower case.  
1528      * -makes sure it does not start/end with a space
1529      * -makes sure it does not contain multiple spaces in a row
1530      * -cannot be only numbers
1531      * -cannot start with 0x 
1532      * -restricts characters to A-Z, a-z, 0-9, and space.
1533      * @return reprocessed string in bytes32 format
1534      */
1535     function nameFilter(string _input)
1536         internal
1537         pure
1538         returns(bytes32)
1539     {
1540         bytes memory _temp = bytes(_input);
1541         uint256 _length = _temp.length;
1542         
1543         //sorry limited to 32 characters
1544         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1545         // make sure it doesnt start with or end with space
1546         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1547         // make sure first two characters are not 0x
1548         if (_temp[0] == 0x30)
1549         {
1550             require(_temp[1] != 0x78, "string cannot start with 0x");
1551             require(_temp[1] != 0x58, "string cannot start with 0X");
1552         }
1553         
1554         // create a bool to track if we have a non number character
1555         bool _hasNonNumber;
1556         
1557         // convert & check
1558         for (uint256 i = 0; i < _length; i++)
1559         {
1560             // if its uppercase A-Z
1561             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1562             {
1563                 // convert to lower case a-z
1564                 _temp[i] = byte(uint(_temp[i]) + 32);
1565                 
1566                 // we have a non number
1567                 if (_hasNonNumber == false)
1568                     _hasNonNumber = true;
1569             } else {
1570                 require
1571                 (
1572                     // require character is a space
1573                     _temp[i] == 0x20 || 
1574                     // OR lowercase a-z
1575                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1576                     // or 0-9
1577                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1578                     "string contains invalid characters"
1579                 );
1580                 // make sure theres not 2x spaces in a row
1581                 if (_temp[i] == 0x20)
1582                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1583                 
1584                 // see if we have a character other than a number
1585                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1586                     _hasNonNumber = true;    
1587             }
1588         }
1589         
1590         require(_hasNonNumber == true, "string cannot be only numbers");
1591         
1592         bytes32 _ret;
1593         assembly {
1594             _ret := mload(add(_temp, 32))
1595         }
1596         return (_ret);
1597     }
1598 }
1599 
1600 /**
1601  * @title SafeMath v0.1.9
1602  * @dev Math operations with safety checks that throw on error
1603  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1604  * - added sqrt
1605  * - added sq
1606  * - changed asserts to requires with error log outputs
1607  * - removed div, its useless
1608  */
1609 library SafeMath {
1610     
1611     /**
1612     * @dev Multiplies two numbers, throws on overflow.
1613     */
1614     function mul(uint256 a, uint256 b) 
1615         internal 
1616         pure 
1617         returns (uint256 c) 
1618     {
1619         if (a == 0) {
1620             return 0;
1621         }
1622         c = a * b;
1623         require(c / a == b, "SafeMath mul failed");
1624         return c;
1625     }
1626 
1627     /**
1628     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1629     */
1630     function sub(uint256 a, uint256 b)
1631         internal
1632         pure
1633         returns (uint256) 
1634     {
1635         require(b <= a, "SafeMath sub failed");
1636         return a - b;
1637     }
1638 
1639     /**
1640     * @dev Adds two numbers, throws on overflow.
1641     */
1642     function add(uint256 a, uint256 b)
1643         internal
1644         pure
1645         returns (uint256 c) 
1646     {
1647         c = a + b;
1648         require(c >= a, "SafeMath add failed");
1649         return c;
1650     }
1651 
1652     /**
1653      * @dev gives square root of given x.
1654      */
1655     function sqrt(uint256 x)
1656         internal
1657         pure
1658         returns (uint256 y) 
1659     {
1660         uint256 z = ((add(x,1)) / 2);
1661         y = x;
1662         while (z < y) 
1663         {
1664             y = z;
1665             z = ((add((x / z),z)) / 2);
1666         }
1667     }
1668 
1669     /**
1670      * @dev gives square. multiplies x by x
1671      */
1672     function sq(uint256 x)
1673         internal
1674         pure
1675         returns (uint256)
1676     {
1677         return (mul(x,x));
1678     }
1679 }