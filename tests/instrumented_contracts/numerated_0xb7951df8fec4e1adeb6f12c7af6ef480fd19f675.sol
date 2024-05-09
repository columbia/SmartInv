1 pragma solidity ^0.4.24;
2 
3 contract FDDEvents {
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
105 contract modularFomoDD is FDDEvents {}
106 
107 contract FomoDD is modularFomoDD {
108     using SafeMath for *;
109     using NameFilter for string;
110     using FDDKeysCalc for uint256;
111 	
112     // TODO: check address
113     BankInterfaceForForwarder constant private Bank = BankInterfaceForForwarder(0xfa1678C00299fB685794865eA5e20dB155a8C913);
114 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xA5d855212A9475558ACf92338F6a1df44dFCE908);
115 
116     address private admin = msg.sender;
117     string constant public name = "FomoDD";
118     string constant public symbol = "Chives";
119 
120     // TODO: check time
121     uint256 private rndGap_ = 0;
122     uint256 private rndExtra_ = 0 minutes;
123     uint256 constant private rndInit_ = 12 hours;                // round timer starts at this
124     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
125     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
126 //==============================================================================
127 //     _| _ _|_ _    _ _ _|_    _   .
128 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
129 //=============================|================================================
130 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
131     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
132 //****************
133 // PLAYER DATA 
134 //****************
135     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
136     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
137     mapping (uint256 => FDDdatasets.Player) public plyr_;   // (pID => data) player data
138     mapping (uint256 => FDDdatasets.PlayerRounds) public plyrRnds_; // current round
139     mapping (uint256 => mapping (uint256 => FDDdatasets.PlayerRounds)) public plyrRnds; // (pID => rID => data) player round data by player id & round id
140     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
141 //****************
142 // ROUND DATA 
143 //****************
144     uint256 public rID_;    // round id number / total rounds that have happened
145     FDDdatasets.Round public round_;   // round data
146     mapping (uint256 => FDDdatasets.Round) public round; // current round
147 //****************
148 // TEAM FEE DATA 
149 //****************
150     uint256 public fees_ = 60;          // fee distribution
151     uint256 public potSplit_ = 45;     // pot split distribution
152 //==============================================================================
153 //     _ _  _  __|_ _    __|_ _  _  .
154 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
155 //==============================================================================
156     constructor()
157         public
158     {
159 	}
160 //==============================================================================
161 //     _ _  _  _|. |`. _  _ _  .
162 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
163 //==============================================================================
164     /**
165      * @dev used to make sure no one can interact with contract until it has 
166      * been activated. 
167      */
168     modifier isActivated() {
169         require(activated_ == true, "its not ready yet"); 
170         _;
171     }
172     
173     /**
174      * @dev prevents contracts from interacting with FomoDD 
175      */
176     modifier isHuman() {
177         address _addr = msg.sender;
178         uint256 _codeLength;
179         
180         assembly {_codeLength := extcodesize(_addr)}
181         require(_codeLength == 0, "non smart contract address only");
182         _;
183     }
184 
185     /**
186      * @dev sets boundaries for incoming tx 
187      */
188     modifier isWithinLimits(uint256 _eth) {
189         require(_eth >= 1000000000, "too little money");
190         require(_eth <= 100000000000000000000000, "too much money");
191         _;    
192     }
193     
194 //==============================================================================
195 //     _    |_ |. _   |`    _  __|_. _  _  _  .
196 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
197 //====|=========================================================================
198     /**
199      * @dev emergency buy uses last stored affiliate ID and team snek
200      */
201     function()
202         isActivated()
203         isHuman()
204         isWithinLimits(msg.value)
205         public
206         payable
207     {
208         // set up our tx event data and determine if player is new or not
209         FDDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
210             
211         // fetch player id
212         uint256 _pID = pIDxAddr_[msg.sender];
213         
214         // buy core 
215         buyCore(_pID, plyr_[_pID].laff, _eventData_);
216     }
217     
218     /**
219      * @dev converts all incoming ethereum to keys.
220      * -functionhash- 0x8f38f309 (using ID for affiliate)
221      * -functionhash- 0x98a0871d (using address for affiliate)
222      * -functionhash- 0xa65b37a1 (using name for affiliate)
223      * @param _affCode the ID/address/name of the player who gets the affiliate fee
224      */
225     function buyXid(uint256 _affCode)
226         isActivated()
227         isHuman()
228         isWithinLimits(msg.value)
229         public
230         payable
231     {
232         // set up our tx event data and determine if player is new or not
233         FDDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
234         
235         // fetch player id
236         uint256 _pID = pIDxAddr_[msg.sender];
237         
238         // manage affiliate residuals
239         // if no affiliate code was given or player tried to use their own, lolz
240         if (_affCode == 0 || _affCode == _pID)
241         {
242             // use last stored affiliate code 
243             _affCode = plyr_[_pID].laff;
244             
245         // if affiliate code was given & its not the same as previously stored 
246         } else if (_affCode != plyr_[_pID].laff) {
247             // update last affiliate 
248             plyr_[_pID].laff = _affCode;
249         }
250                 
251         // buy core 
252         buyCore(_pID, _affCode, _eventData_);
253     }
254     
255     function buyXaddr(address _affCode)
256         isActivated()
257         isHuman()
258         isWithinLimits(msg.value)
259         public
260         payable
261     {
262         // set up our tx event data and determine if player is new or not
263         FDDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
264         
265         // fetch player id
266         uint256 _pID = pIDxAddr_[msg.sender];
267         
268         // manage affiliate residuals
269         uint256 _affID;
270         // if no affiliate code was given or player tried to use their own, lolz
271         if (_affCode == address(0) || _affCode == msg.sender)
272         {
273             // use last stored affiliate code
274             _affID = plyr_[_pID].laff;
275         
276         // if affiliate code was given    
277         } else {
278             // get affiliate ID from aff Code 
279             _affID = pIDxAddr_[_affCode];
280             
281             // if affID is not the same as previously stored 
282             if (_affID != plyr_[_pID].laff)
283             {
284                 // update last affiliate
285                 plyr_[_pID].laff = _affID;
286             }
287         }
288         
289         // buy core 
290         buyCore(_pID, _affID, _eventData_);
291     }
292     
293     function buyXname(bytes32 _affCode)
294         isActivated()
295         isHuman()
296         isWithinLimits(msg.value)
297         public
298         payable
299     {
300         // set up our tx event data and determine if player is new or not
301         FDDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
302         
303         // fetch player id
304         uint256 _pID = pIDxAddr_[msg.sender];
305         
306         // manage affiliate residuals
307         uint256 _affID;
308         // if no affiliate code was given or player tried to use their own, lolz
309         if (_affCode == '' || _affCode == plyr_[_pID].name)
310         {
311             // use last stored affiliate code
312             _affID = plyr_[_pID].laff;
313         
314         // if affiliate code was given
315         } else {
316             // get affiliate ID from aff Code
317             _affID = pIDxName_[_affCode];
318             
319             // if affID is not the same as previously stored
320             if (_affID != plyr_[_pID].laff)
321             {
322                 // update last affiliate
323                 plyr_[_pID].laff = _affID;
324             }
325         }
326         
327         // buy core 
328         buyCore(_pID, _affID, _eventData_);
329     }
330     
331     /**
332      * @dev essentially the same as buy, but instead of you sending ether 
333      * from your wallet, it uses your unwithdrawn earnings.
334      * -functionhash- 0x349cdcac (using ID for affiliate)
335      * -functionhash- 0x82bfc739 (using address for affiliate)
336      * -functionhash- 0x079ce327 (using name for affiliate)
337      * @param _affCode the ID/address/name of the player who gets the affiliate fee
338      * @param _eth amount of earnings to use (remainder returned to gen vault)
339      */
340     function reLoadXid(uint256 _affCode, uint256 _eth)
341         isActivated()
342         isHuman()
343         isWithinLimits(_eth)
344         public
345     {
346         // set up our tx event data
347         FDDdatasets.EventReturns memory _eventData_;
348         
349         // fetch player ID
350         uint256 _pID = pIDxAddr_[msg.sender];
351         
352         // manage affiliate residuals
353         // if no affiliate code was given or player tried to use their own, lolz
354         if (_affCode == 0 || _affCode == _pID)
355         {
356             // use last stored affiliate code 
357             _affCode = plyr_[_pID].laff;
358             
359         // if affiliate code was given & its not the same as previously stored 
360         } else if (_affCode != plyr_[_pID].laff) {
361             // update last affiliate 
362             plyr_[_pID].laff = _affCode;
363         }
364 
365         // reload core
366         reLoadCore(_pID, _affCode, _eth, _eventData_);
367     }
368     
369     function reLoadXaddr(address _affCode, uint256 _eth)
370         isActivated()
371         isHuman()
372         isWithinLimits(_eth)
373         public
374     {
375         // set up our tx event data
376         FDDdatasets.EventReturns memory _eventData_;
377         
378         // fetch player ID
379         uint256 _pID = pIDxAddr_[msg.sender];
380         
381         // manage affiliate residuals
382         uint256 _affID;
383         // if no affiliate code was given or player tried to use their own, lolz
384         if (_affCode == address(0) || _affCode == msg.sender)
385         {
386             // use last stored affiliate code
387             _affID = plyr_[_pID].laff;
388         
389         // if affiliate code was given    
390         } else {
391             // get affiliate ID from aff Code 
392             _affID = pIDxAddr_[_affCode];
393             
394             // if affID is not the same as previously stored 
395             if (_affID != plyr_[_pID].laff)
396             {
397                 // update last affiliate
398                 plyr_[_pID].laff = _affID;
399             }
400         }
401                 
402         // reload core
403         reLoadCore(_pID, _affID, _eth, _eventData_);
404     }
405     
406     function reLoadXname(bytes32 _affCode, uint256 _eth)
407         isActivated()
408         isHuman()
409         isWithinLimits(_eth)
410         public
411     {
412         // set up our tx event data
413         FDDdatasets.EventReturns memory _eventData_;
414         
415         // fetch player ID
416         uint256 _pID = pIDxAddr_[msg.sender];
417         
418         // manage affiliate residuals
419         uint256 _affID;
420         // if no affiliate code was given or player tried to use their own, lolz
421         if (_affCode == '' || _affCode == plyr_[_pID].name)
422         {
423             // use last stored affiliate code
424             _affID = plyr_[_pID].laff;
425         
426         // if affiliate code was given
427         } else {
428             // get affiliate ID from aff Code
429             _affID = pIDxName_[_affCode];
430             
431             // if affID is not the same as previously stored
432             if (_affID != plyr_[_pID].laff)
433             {
434                 // update last affiliate
435                 plyr_[_pID].laff = _affID;
436             }
437         }
438                 
439         // reload core
440         reLoadCore(_pID, _affID, _eth, _eventData_);
441     }
442 
443     /**
444      * @dev withdraws all of your earnings.
445      * -functionhash- 0x3ccfd60b
446      */
447     function withdraw()
448         isActivated()
449         isHuman()
450         public
451     {
452         uint256 _rID = rID_;
453 
454         // grab time
455         uint256 _now = now;
456         
457         // fetch player ID
458         uint256 _pID = pIDxAddr_[msg.sender];
459         
460         // setup temp var for player eth
461         uint256 _eth;
462         
463         // check to see if round has ended and no one has run round end yet
464         if (_now > round[_rID].end && round[_rID].ended == false && round[_rID].plyr != 0)
465         {
466             // set up our tx event data
467             FDDdatasets.EventReturns memory _eventData_;
468             
469             // end the round (distributes pot)
470 			round[_rID].ended = true;
471             _eventData_ = endRound(_eventData_);
472             
473 			// get their earnings
474             _eth = withdrawEarnings(_pID);
475             
476             // gib moni
477             if (_eth > 0)
478                 plyr_[_pID].addr.transfer(_eth);    
479             
480             // build event data
481             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
482             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
483             
484             // fire withdraw and distribute event
485             emit FDDEvents.onWithdrawAndDistribute
486             (
487                 msg.sender, 
488                 plyr_[_pID].name, 
489                 _eth, 
490                 _eventData_.compressedData, 
491                 _eventData_.compressedIDs, 
492                 _eventData_.winnerAddr, 
493                 _eventData_.winnerName, 
494                 _eventData_.amountWon, 
495                 _eventData_.newPot, 
496                 _eventData_.genAmount
497             );
498         // in any other situation
499         } else {
500             // get their earnings
501             _eth = withdrawEarnings(_pID);
502             
503             // gib moni
504             if (_eth > 0)
505                 plyr_[_pID].addr.transfer(_eth);
506             
507             // fire withdraw event
508             emit FDDEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
509         }
510     }
511     
512     /**
513      * @dev use these to register names.  they are just wrappers that will send the
514      * registration requests to the PlayerBook contract.  So registering here is the 
515      * same as registering there.  UI will always display the last name you registered.
516      * but you will still own all previously registered names to use as affiliate 
517      * links.
518      * - must pay a registration fee.
519      * - name must be unique
520      * - names will be converted to lowercase
521      * - name cannot start or end with a space 
522      * - cannot have more than 1 space in a row
523      * - cannot be only numbers
524      * - cannot start with 0x 
525      * - name must be at least 1 char
526      * - max length of 32 characters long
527      * - allowed characters: a-z, 0-9, and space
528      * -functionhash- 0x921dec21 (using ID for affiliate)
529      * -functionhash- 0x3ddd4698 (using address for affiliate)
530      * -functionhash- 0x685ffd83 (using name for affiliate)
531      * @param _nameString players desired name
532      * @param _affCode affiliate ID, address, or name of who referred you
533      * @param _all set to true if you want this to push your info to all games 
534      * (this might cost a lot of gas)
535      */
536     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
537         isHuman()
538         public
539         payable
540     {
541         bytes32 _name = _nameString.nameFilter();
542         address _addr = msg.sender;
543         uint256 _paid = msg.value;
544         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
545 
546         uint256 _pID = pIDxAddr_[_addr];
547         
548         // fire event
549         emit FDDEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
550     }
551     
552     function registerNameXaddr(string _nameString, address _affCode, bool _all)
553         isHuman()
554         public
555         payable
556     {
557         bytes32 _name = _nameString.nameFilter();
558         address _addr = msg.sender;
559         uint256 _paid = msg.value;
560         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
561         
562         uint256 _pID = pIDxAddr_[_addr];
563         
564         // fire event
565         emit FDDEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
566     }
567     
568     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
569         isHuman()
570         public
571         payable
572     {
573         bytes32 _name = _nameString.nameFilter();
574         address _addr = msg.sender;
575         uint256 _paid = msg.value;
576         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
577         
578         uint256 _pID = pIDxAddr_[_addr];
579         
580         // fire event
581         emit FDDEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
582     }
583 //==============================================================================
584 //     _  _ _|__|_ _  _ _  .
585 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
586 //=====_|=======================================================================
587     /**
588      * @dev return the price buyer will pay for next 1 individual key.
589      * -functionhash- 0x018a25e8
590      * @return price for next key bought (in wei format)
591      */
592     function getBuyPrice()
593         public 
594         view 
595         returns(uint256)
596     {
597         uint256 _rID = rID_;          
598         // grab time
599         uint256 _now = now;
600         
601         // are we in a round?
602         if (_now > round[_rID].strt + rndGap_ && (_now <= round[_rID].end || (_now > round[_rID].end && round[_rID].plyr == 0)))
603             return ( (round[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
604         else // rounds over.  need price for new round
605             return ( 75000000000000 ); // init
606     }
607     
608     /**
609      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
610      * provider
611      * -functionhash- 0xc7e284b8
612      * @return time left in seconds
613      */
614     function getTimeLeft()
615         public
616         view
617         returns(uint256)
618     {
619         uint256 _rID = rID_;
620         // grab time
621         uint256 _now = now;
622         
623         if (_now < round[_rID].end)
624             if (_now > round[_rID].strt + rndGap_)
625                 return( (round[_rID].end).sub(_now) );
626             else
627                 return( (round[_rID].strt + rndGap_).sub(_now));
628         else
629             return(0);
630     }
631     
632     /**
633      * @dev returns player earnings per vaults 
634      * -functionhash- 0x63066434
635      * @return winnings vault
636      * @return general vault
637      * @return affiliate vault
638      */
639     function getPlayerVaults(uint256 _pID)
640         public
641         view
642         returns(uint256 ,uint256, uint256)
643     {
644         uint256 _rID = rID_;
645 
646         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
647         if (now > round[_rID].end && round[_rID].ended == false && round[_rID].plyr != 0)
648         {
649             // if player is winner 
650             if (round[_rID].plyr == _pID)
651             {
652                 return
653                 (
654                     (plyr_[_pID].win).add( ((round[_rID].pot).mul(48)) / 100 ),
655                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds[_pID][_rID].mask)   ),
656                     plyr_[_pID].aff
657                 );
658             // if player is not the winner
659             } else {
660                 return
661                 (
662                     plyr_[_pID].win,
663                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds[_pID][_rID].mask)  ),
664                     plyr_[_pID].aff
665                 );
666             }
667             plyrRnds_[_pID] = plyrRnds[_pID][_rID];
668         // if round is still going on, or round has ended and round end has been ran
669         } else {
670             return
671             (
672                 plyr_[_pID].win,
673                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
674                 plyr_[_pID].aff
675             );
676         }
677     }
678     
679     /**
680      * solidity hates stack limits.  this lets us avoid that hate 
681      */
682     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
683         private
684         view
685         returns(uint256)
686     {
687         return(  ((((round[_rID].mask).add(((((round[_rID].pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round[_rID].keys))).mul(plyrRnds[_pID][_rID].keys)) / 1000000000000000000)  );
688     }
689     
690     /**
691      * @dev returns all current round info needed for front end
692      * -functionhash- 0x747dff42
693      * @return total keys
694      * @return time ends
695      * @return time started
696      * @return current pot 
697      * @return current player ID in lead 
698      * @return current player in leads address 
699      * @return current player in leads name
700      * @return airdrop tracker # & airdrop pot
701      */
702     function getCurrentRoundInfo()
703         public
704         view
705         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
706     {
707         uint256 _rID = rID_;
708         return
709         (
710             round[_rID].keys,              //0
711             round[_rID].end,               //1
712             round[_rID].strt,              //2
713             round[_rID].pot,               //3
714             round[_rID].plyr,              //4
715             plyr_[round[_rID].plyr].addr,  //5
716             plyr_[round[_rID].plyr].name,  //6
717             airDropTracker_ + (airDropPot_ * 1000)              //7
718         );
719     }
720 
721     /**
722      * @dev returns player info based on address.  if no address is given, it will 
723      * use msg.sender 
724      * -functionhash- 0xee0b5d8b
725      * @param _addr address of the player you want to lookup 
726      * @return player ID 
727      * @return player name
728      * @return keys owned (current round)
729      * @return winnings vault
730      * @return general vault 
731      * @return affiliate vault 
732 	 * @return player round eth
733      */
734     function getPlayerInfoByAddress(address _addr)
735         public 
736         view 
737         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
738     {
739         uint256 _rID = rID_;
740 
741         if (_addr == address(0))
742         {
743             _addr == msg.sender;
744         }
745         uint256 _pID = pIDxAddr_[_addr];
746         
747         return
748         (
749             _pID,                               //0
750             plyr_[_pID].name,                   //1
751             plyrRnds[_pID][_rID].keys,         //2
752             plyr_[_pID].win,                    //3
753             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
754             plyr_[_pID].aff,                    //5
755             plyrRnds[_pID][_rID].eth           //6
756         );
757     }
758 
759 //==============================================================================
760 //     _ _  _ _   | _  _ . _  .
761 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
762 //=====================_|=======================================================
763     /**
764      * @dev logic runs whenever a buy order is executed.  determines how to handle 
765      * incoming eth depending on if we are in an active round or not
766      */
767     function buyCore(uint256 _pID, uint256 _affID, FDDdatasets.EventReturns memory _eventData_)
768         private
769     {
770         uint256 _rID = rID_;
771 
772         // grab time
773         uint256 _now = now;
774         
775         // if round is active
776         if (_now > round[_rID].strt + rndGap_ && (_now <= round[_rID].end || (_now > round[_rID].end && round[_rID].plyr == 0))) 
777         {
778             // call core 
779             core(_rID, _pID, msg.value, _affID, _eventData_);
780         
781         // if round is not active     
782         } else {
783             // check to see if end round needs to be ran
784             if (_now > round[_rID].end && round[_rID].ended == false) 
785             {
786                 // end the round (distributes pot) & start new round
787 			    round[_rID].ended = true;
788                 _eventData_ = endRound(_eventData_);
789                 
790                 // build event data
791                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
792                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
793                 
794                 // fire buy and distribute event 
795                 emit FDDEvents.onBuyAndDistribute
796                 (
797                     msg.sender, 
798                     plyr_[_pID].name, 
799                     msg.value, 
800                     _eventData_.compressedData, 
801                     _eventData_.compressedIDs, 
802                     _eventData_.winnerAddr, 
803                     _eventData_.winnerName, 
804                     _eventData_.amountWon, 
805                     _eventData_.newPot, 
806                     _eventData_.genAmount
807                 );
808             }
809             
810             // put eth in players vault 
811             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
812         }
813     }
814     
815     /**
816      * @dev logic runs whenever a reload order is executed.  determines how to handle 
817      * incoming eth depending on if we are in an active round or not 
818      */
819     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, FDDdatasets.EventReturns memory _eventData_)
820         private
821     {
822         uint256 _rID = rID_;
823 
824         // grab time
825         uint256 _now = now;
826         
827         // if round is active
828         if (_now > round[_rID].strt + rndGap_ && (_now <= round[_rID].end || (_now > round[_rID].end && round[_rID].plyr == 0))) 
829         {
830             // get earnings from all vaults and return unused to gen vault
831             // because we use a custom safemath library.  this will throw if player 
832             // tried to spend more eth than they have.
833             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
834             
835             // call core 
836             core(_rID, _pID, _eth, _affID, _eventData_);
837         
838         // if round is not active and end round needs to be ran   
839         } else if (_now > round[_rID].end && round[_rID].ended == false) {
840             // end the round (distributes pot) & start new round
841             round[_rID].ended = true;
842             _eventData_ = endRound(_eventData_);
843                 
844             // build event data
845             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
846             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
847                 
848             // fire buy and distribute event 
849             emit FDDEvents.onReLoadAndDistribute
850             (
851                 msg.sender, 
852                 plyr_[_pID].name, 
853                 _eventData_.compressedData, 
854                 _eventData_.compressedIDs, 
855                 _eventData_.winnerAddr, 
856                 _eventData_.winnerName, 
857                 _eventData_.amountWon, 
858                 _eventData_.newPot, 
859                 _eventData_.genAmount
860             );
861         }
862     }
863     
864     /**
865      * @dev this is the core logic for any buy/reload that happens while a round 
866      * is live.
867      */
868     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, FDDdatasets.EventReturns memory _eventData_)
869         private
870     {
871         // if player is new to round
872         if (plyrRnds[_pID][_rID].keys == 0)
873             _eventData_ = managePlayer(_pID, _eventData_);
874         
875         // early round eth limiter 
876         if (round[_rID].eth < 100000000000000000000 && plyrRnds[_pID][_rID].eth.add(_eth) > 10000000000000000000)
877         {
878             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds[_pID][_rID].eth);
879             uint256 _refund = _eth.sub(_availableLimit);
880             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
881             _eth = _availableLimit;
882         }
883         
884         // if eth left is greater than min eth allowed (sorry no pocket lint)
885         if (_eth > 1000000000) 
886         {
887             
888             // mint the new keys
889             uint256 _keys = (round[_rID].eth).keysRec(_eth);
890             
891             // if they bought at least 1 whole key
892             if (_keys >= 1000000000000000000)
893             {
894                 updateTimer(_keys, _rID);
895 
896                 // set new leaders
897                 if (round[_rID].plyr != _pID)
898                     round[_rID].plyr = _pID;  
899             
900                 // set the new leader bool to true
901                 _eventData_.compressedData = _eventData_.compressedData + 100;
902             }
903             
904             // manage airdrops
905             if (_eth >= 100000000000000000)
906             {
907                 airDropTracker_++;
908                 if (airdrop() == true)
909                 {
910                     // gib muni
911                     uint256 _prize;
912                     if (_eth >= 10000000000000000000)
913                     {
914                         // calculate prize and give it to winner
915                         _prize = ((airDropPot_).mul(75)) / 100;
916                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
917                         
918                         // adjust airDropPot 
919                         airDropPot_ = (airDropPot_).sub(_prize);
920                         
921                         // let event know a tier 3 prize was won 
922                         _eventData_.compressedData += 300000000000000000000000000000000;
923                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
924                         // calculate prize and give it to winner
925                         _prize = ((airDropPot_).mul(50)) / 100;
926                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
927                         
928                         // adjust airDropPot 
929                         airDropPot_ = (airDropPot_).sub(_prize);
930                         
931                         // let event know a tier 2 prize was won 
932                         _eventData_.compressedData += 200000000000000000000000000000000;
933                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
934                         // calculate prize and give it to winner
935                         _prize = ((airDropPot_).mul(25)) / 100;
936                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
937                         
938                         // adjust airDropPot 
939                         airDropPot_ = (airDropPot_).sub(_prize);
940                         
941                         // let event know a tier 1 prize was won 
942                         _eventData_.compressedData += 100000000000000000000000000000000;
943                     }
944                     // set airdrop happened bool to true
945                     _eventData_.compressedData += 10000000000000000000000000000000;
946                     // let event know how much was won 
947                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
948                     
949                     // reset air drop tracker
950                     airDropTracker_ = 0;
951                 }
952             }
953     
954             // store the air drop tracker number (number of buys since last airdrop)
955             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
956             
957             // update player 
958             plyrRnds[_pID][_rID].keys = _keys.add(plyrRnds[_pID][_rID].keys);
959             plyrRnds[_pID][_rID].eth = _eth.add(plyrRnds[_pID][_rID].eth);
960             
961             // update round
962             round[_rID].keys = _keys.add(round[_rID].keys);
963             round[_rID].eth = _eth.add(round[_rID].eth);
964     
965             // distribute eth
966             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
967             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
968             
969             // call end tx function to fire end tx event.
970 		    endTx(_pID, _eth, _keys, _eventData_);
971         }
972         plyrRnds_[_pID] = plyrRnds[_pID][_rID];
973         round_ = round[_rID];
974     }
975 //==============================================================================
976 //     _ _ | _   | _ _|_ _  _ _  .
977 //    (_(_||(_|_||(_| | (_)| _\  .
978 //==============================================================================
979     /**
980      * @dev calculates unmasked earnings (just calculates, does not update mask)
981      * @return earnings in wei format
982      */
983     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
984         private
985         view
986         returns(uint256)
987     {
988         return((((round[_rIDlast].mask).mul(plyrRnds[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds[_pID][_rIDlast].mask));
989     }
990     
991     /** 
992      * @dev returns the amount of keys you would get given an amount of eth. 
993      * -functionhash- 0xce89c80c
994      * @param _eth amount of eth sent in 
995      * @return keys received 
996      */
997     function calcKeysReceived(uint256 _eth)
998         public
999         view
1000         returns(uint256)
1001     {
1002         uint256 _rID = rID_;
1003         // grab time
1004         uint256 _now = now;
1005         
1006         // are we in a round?
1007         if (_now > round[_rID].strt + rndGap_ && (_now <= round[_rID].end || (_now > round[_rID].end && round[_rID].plyr == 0)))
1008             return ( (round[_rID].eth).keysRec(_eth) );
1009         else // rounds over.  need keys for new round
1010             return ( (_eth).keys() );
1011     }
1012     
1013     /** 
1014      * @dev returns current eth price for X keys.  
1015      * -functionhash- 0xcf808000
1016      * @param _keys number of keys desired (in 18 decimal format)
1017      * @return amount of eth needed to send
1018      */
1019     function iWantXKeys(uint256 _keys)
1020         public
1021         view
1022         returns(uint256)
1023     {
1024         uint256 _rID = rID_;
1025         // grab time
1026         uint256 _now = now;
1027         
1028         // are we in a round?
1029         if (_now > round[_rID].strt + rndGap_ && (_now <= round[_rID].end || (_now > round[_rID].end && round[_rID].plyr == 0)))
1030             return ( (round[_rID].keys.add(_keys)).ethRec(_keys) );
1031         else // rounds over.  need price for new round
1032             return ( (_keys).eth() );
1033     }
1034 //==============================================================================
1035 //    _|_ _  _ | _  .
1036 //     | (_)(_)|_\  .
1037 //==============================================================================
1038     /**
1039 	 * @dev receives name/player info from names contract 
1040      */
1041     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1042         external
1043     {
1044         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1045         if (pIDxAddr_[_addr] != _pID)
1046             pIDxAddr_[_addr] = _pID;
1047         if (pIDxName_[_name] != _pID)
1048             pIDxName_[_name] = _pID;
1049         if (plyr_[_pID].addr != _addr)
1050             plyr_[_pID].addr = _addr;
1051         if (plyr_[_pID].name != _name)
1052             plyr_[_pID].name = _name;
1053         if (plyr_[_pID].laff != _laff)
1054             plyr_[_pID].laff = _laff;
1055         if (plyrNames_[_pID][_name] == false)
1056             plyrNames_[_pID][_name] = true;
1057     }
1058     
1059     /**
1060      * @dev receives entire player name list 
1061      */
1062     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1063         external
1064     {
1065         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1066         if(plyrNames_[_pID][_name] == false)
1067             plyrNames_[_pID][_name] = true;
1068     }   
1069         
1070     /**
1071      * @dev gets existing or registers new pID.  use this when a player may be new
1072      * @return pID 
1073      */
1074     function determinePID(FDDdatasets.EventReturns memory _eventData_)
1075         private
1076         returns (FDDdatasets.EventReturns)
1077     {
1078         uint256 _pID = pIDxAddr_[msg.sender];
1079         // if player is new to this version of FomoDD
1080         if (_pID == 0)
1081         {
1082             // grab their player ID, name and last aff ID, from player names contract 
1083             _pID = PlayerBook.getPlayerID(msg.sender);
1084             bytes32 _name = PlayerBook.getPlayerName(_pID);
1085             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1086             
1087             // set up player account 
1088             pIDxAddr_[msg.sender] = _pID;
1089             plyr_[_pID].addr = msg.sender;
1090             
1091             if (_name != "")
1092             {
1093                 pIDxName_[_name] = _pID;
1094                 plyr_[_pID].name = _name;
1095                 plyrNames_[_pID][_name] = true;
1096             }
1097             
1098             if (_laff != 0 && _laff != _pID)
1099                 plyr_[_pID].laff = _laff;
1100             
1101             // set the new player bool to true
1102             _eventData_.compressedData = _eventData_.compressedData + 1;
1103         } 
1104         return (_eventData_);
1105     }
1106 
1107     /**
1108      * @dev decides if round end needs to be run & new round started.  and if 
1109      * player unmasked earnings from previously played rounds need to be moved.
1110      */
1111     function managePlayer(uint256 _pID, FDDdatasets.EventReturns memory _eventData_)
1112         private
1113         returns (FDDdatasets.EventReturns)
1114     {
1115         if (plyr_[_pID].lrnd != 0)
1116             updateGenVault(_pID, plyr_[_pID].lrnd);
1117 
1118         plyr_[_pID].lrnd = rID_;            
1119         // set the joined round bool to true
1120         _eventData_.compressedData = _eventData_.compressedData + 10;
1121         
1122         return(_eventData_);
1123     }
1124     
1125     /**
1126      * @dev ends the round. manages paying out winner/splitting up pot
1127      */
1128     function endRound(FDDdatasets.EventReturns memory _eventData_)
1129         private
1130         returns (FDDdatasets.EventReturns)
1131     {        
1132         uint256 _rID = rID_;
1133         // grab our winning player and team id's
1134         uint256 _winPID = round[_rID].plyr;
1135         
1136         // grab our pot amount
1137         // add airdrop pot into the final pot
1138         // uint256 _pot = round[_rID].pot + airDropPot_;
1139         uint256 _pot = round[_rID].pot;
1140         
1141         // calculate our winner share, community rewards, gen share, 
1142         // p3d share, and amount reserved for next pot 
1143         uint256 _win = (_pot.mul(45)) / 100;
1144         uint256 _com = (_pot / 10);
1145         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1146         
1147         // calculate ppt for round mask
1148         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round[_rID].keys);
1149         uint256 _dust = _gen.sub((_ppt.mul(round[_rID].keys)) / 1000000000000000000);
1150         if (_dust > 0)
1151         {
1152             _gen = _gen.sub(_dust);
1153             _com = _com.add(_dust);
1154         }
1155         
1156         // pay our winner
1157         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1158         
1159         // community rewards
1160         // if (!address(Bank).call.value(_com)(bytes4(keccak256("deposit()"))))
1161         // {
1162         //     _gen = _gen.add(_com);
1163         //     _com = 0;
1164         // }
1165         
1166         // distribute gen portion to key holders
1167         round[_rID].mask = _ppt.add(round[_rID].mask);
1168             
1169         // prepare event data
1170         _eventData_.compressedData = _eventData_.compressedData + (round[_rID].end * 1000000);
1171         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1172         _eventData_.winnerAddr = plyr_[_winPID].addr;
1173         _eventData_.winnerName = plyr_[_winPID].name;
1174         _eventData_.amountWon = _win;
1175         _eventData_.genAmount = _gen;
1176         _eventData_.newPot = _com;
1177         
1178         // start next round
1179         rID_++;
1180         _rID++;
1181         round[_rID].strt = now + rndExtra_;
1182         round[_rID].end = now + rndInit_ + rndExtra_;
1183         round[_rID].pot = _com;
1184         round_ = round[_rID];
1185 
1186         return(_eventData_);
1187     }
1188     
1189     /**
1190      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1191      */
1192     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1193         private 
1194     {
1195         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1196         if (_earnings > 0)
1197         {
1198             // put in gen vault
1199             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1200             // zero out their earnings by updating mask
1201             plyrRnds[_pID][_rIDlast].mask = _earnings.add(plyrRnds[_pID][_rIDlast].mask);
1202             plyrRnds_[_pID] = plyrRnds[_pID][_rIDlast];
1203         }
1204     }
1205     
1206     /**
1207      * @dev updates round timer based on number of whole keys bought.
1208      */
1209     function updateTimer(uint256 _keys, uint256 _rID)
1210         private
1211     {
1212         // grab time
1213         uint256 _now = now;
1214         
1215         // calculate time based on number of keys bought
1216         uint256 _newTime;
1217         if (_now > round[_rID].end && round[_rID].plyr == 0)
1218             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1219         else
1220             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round[_rID].end);
1221         
1222         // compare to max and set new end time
1223         if (_newTime < (rndMax_).add(_now))
1224             round[_rID].end = _newTime;
1225         else
1226             round[_rID].end = rndMax_.add(_now);
1227 
1228         round_ = round[_rID];
1229     }
1230     
1231     /**
1232      * @dev generates a random number between 0-99 and checks to see if thats
1233      * resulted in an airdrop win
1234      * @return do we have a winner?
1235      */
1236     function airdrop()
1237         private 
1238         view 
1239         returns(bool)
1240     {
1241         uint256 seed = uint256(keccak256(abi.encodePacked(
1242             
1243             (block.timestamp).add
1244             (block.difficulty).add
1245             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1246             (block.gaslimit).add
1247             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1248             (block.number)
1249             
1250         )));
1251         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1252             return(true);
1253         else
1254             return(false);
1255     }
1256 
1257     /**
1258      * @dev distributes eth based on fees to com, aff, and p3d
1259      */
1260     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, FDDdatasets.EventReturns memory _eventData_)
1261         private
1262         returns(FDDdatasets.EventReturns)
1263     {
1264         // pay 5% out to community rewards
1265         uint256 _com = _eth * 5 / 100;
1266                 
1267         // distribute share to affiliate
1268         uint256 _aff = _eth * 10 / 100;
1269         
1270         // decide what to do with affiliate share of fees
1271         // affiliate must not be self, and must have a name registered
1272         if (_affID != _pID && plyr_[_affID].name != '') {
1273             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1274             emit FDDEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1275         } else {
1276             // no affiliates, add to community
1277             _com += _aff;
1278         }
1279 
1280         if (!address(Bank).call.value(_com)(bytes4(keccak256("deposit()"))))
1281         {
1282             // This ensures Team Just cannot influence the outcome of FoMo3D with
1283             // bank migrations by breaking outgoing transactions.
1284             // Something we would never do. But that's not the point.
1285             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1286             // highest belief that everything we create should be trustless.
1287             // Team JUST, The name you shouldn't have to trust.
1288         }
1289 
1290         return(_eventData_);
1291     }
1292     
1293     /**
1294      * @dev distributes eth based on fees to gen and pot
1295      */
1296     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, FDDdatasets.EventReturns memory _eventData_)
1297         private
1298         returns(FDDdatasets.EventReturns)
1299     {
1300         // calculate gen share
1301         uint256 _gen = (_eth.mul(fees_)) / 100;
1302         
1303         // toss 5% into airdrop pot 
1304         uint256 _air = (_eth / 20);
1305         airDropPot_ = airDropPot_.add(_air);
1306                 
1307         // calculate pot (20%) 
1308         uint256 _pot = (_eth.mul(20) / 100);
1309         
1310         // distribute gen share (thats what updateMasks() does) and adjust
1311         // balances for dust.
1312         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1313         if (_dust > 0)
1314             _gen = _gen.sub(_dust);
1315         
1316         // add eth to pot
1317         round[_rID].pot = _pot.add(_dust).add(round[_rID].pot);
1318         
1319         // set up event data
1320         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1321         _eventData_.potAmount = _pot;
1322         round_ = round[_rID];
1323 
1324         return(_eventData_);
1325     }
1326 
1327     /**
1328      * @dev updates masks for round and player when keys are bought
1329      * @return dust left over 
1330      */
1331     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1332         private
1333         returns(uint256)
1334     {
1335         /* MASKING NOTES
1336             earnings masks are a tricky thing for people to wrap their minds around.
1337             the basic thing to understand here.  is were going to have a global
1338             tracker based on profit per share for each round, that increases in
1339             relevant proportion to the increase in share supply.
1340             
1341             the player will have an additional mask that basically says "based
1342             on the rounds mask, my shares, and how much i've already withdrawn,
1343             how much is still owed to me?"
1344         */
1345         
1346         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1347         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round[_rID].keys);
1348         round[_rID].mask = _ppt.add(round[_rID].mask);
1349             
1350         // calculate player earning from their own buy (only based on the keys
1351         // they just bought).  & update player earnings mask
1352         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1353         plyrRnds[_pID][_rID].mask = (((round[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds[_pID][_rID].mask);
1354         plyrRnds_[_pID] = plyrRnds[_pID][_rID];
1355         round_ = round[_rID];
1356         // calculate & return dust
1357         return(_gen.sub((_ppt.mul(round[_rID].keys)) / (1000000000000000000)));
1358     }
1359     
1360     /**
1361      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1362      * @return earnings in wei format
1363      */
1364     function withdrawEarnings(uint256 _pID)
1365         private
1366         returns(uint256)
1367     {
1368         // update gen vault
1369         updateGenVault(_pID, plyr_[_pID].lrnd);
1370         
1371         // from vaults 
1372         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1373         if (_earnings > 0)
1374         {
1375             plyr_[_pID].win = 0;
1376             plyr_[_pID].gen = 0;
1377             plyr_[_pID].aff = 0;
1378         }
1379 
1380         return(_earnings);
1381     }
1382     
1383     /**
1384      * @dev prepares compression data and fires event for buy or reload tx's
1385      */
1386     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, FDDdatasets.EventReturns memory _eventData_)
1387         private
1388     {
1389         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1390         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1391         
1392         emit FDDEvents.onEndTx
1393         (
1394             _eventData_.compressedData,
1395             _eventData_.compressedIDs,
1396             plyr_[_pID].name,
1397             msg.sender,
1398             _eth,
1399             _keys,
1400             _eventData_.winnerAddr,
1401             _eventData_.winnerName,
1402             _eventData_.amountWon,
1403             _eventData_.newPot,
1404             _eventData_.genAmount,
1405             _eventData_.potAmount,
1406             airDropPot_
1407         );
1408     }
1409 
1410     /** upon contract deploy, it will be deactivated.  this is a one time
1411      * use function that will activate the contract.  we do this so devs 
1412      * have time to set things up on the web end                            **/
1413     bool public activated_ = false;
1414     function activate()
1415         public
1416     {
1417         // only owner can activate 
1418         // TODO: set owner
1419         require(msg.sender == admin);
1420         
1421         // can only be ran once
1422         require(activated_ == false, "FomoDD already activated");
1423         
1424         // activate the contract 
1425         activated_ = true;
1426         
1427         rID_ = 1;
1428         round[1].strt = now + rndExtra_;
1429         round[1].end = now + rndInit_ + rndExtra_;
1430         round_ = round[1];
1431     }
1432 }
1433 
1434 //==============================================================================
1435 //   __|_ _    __|_ _  .
1436 //  _\ | | |_|(_ | _\  .
1437 //==============================================================================
1438 library FDDdatasets {
1439     //compressedData key
1440     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1441         // 0 - new player (bool)
1442         // 1 - joined round (bool)
1443         // 2 - new  leader (bool)
1444         // 3-5 - air drop tracker (uint 0-999)
1445         // 6-16 - round end time
1446         // 17 - winnerTeam
1447         // 18 - 28 timestamp 
1448         // 29 - team
1449         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1450         // 31 - airdrop happened bool
1451         // 32 - airdrop tier 
1452         // 33 - airdrop amount won
1453     //compressedIDs key
1454     // [77-52][51-26][25-0]
1455         // 0-25 - pID 
1456         // 26-51 - winPID
1457         // 52-77 - rID
1458     struct EventReturns {
1459         uint256 compressedData;
1460         uint256 compressedIDs;
1461         address winnerAddr;         // winner address
1462         bytes32 winnerName;         // winner name
1463         uint256 amountWon;          // amount won
1464         uint256 newPot;             // amount in new pot
1465         uint256 genAmount;          // amount distributed to gen
1466         uint256 potAmount;          // amount added to pot
1467     }
1468     struct Player {
1469         address addr;   // player address
1470         bytes32 name;   // player name
1471         uint256 win;    // winnings vault
1472         uint256 gen;    // general vault
1473         uint256 aff;    // affiliate vault
1474         uint256 lrnd;   // last round played
1475         uint256 laff;   // last affiliate id used
1476     }
1477     struct PlayerRounds {
1478         uint256 eth;    // eth player has added to round (used for eth limiter)
1479         uint256 keys;   // keys
1480         uint256 mask;   // player mask 
1481     }
1482     struct Round {
1483         uint256 plyr;   // pID of player in lead
1484         uint256 end;    // time ends/ended
1485         bool ended;     // has round end function been ran
1486         uint256 strt;   // time round started
1487         uint256 keys;   // keys
1488         uint256 eth;    // total eth in
1489         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1490         uint256 mask;   // global mask
1491     }
1492 }
1493 
1494 //==============================================================================
1495 //  |  _      _ _ | _  .
1496 //  |<(/_\/  (_(_||(_  .
1497 //=======/======================================================================
1498 library FDDKeysCalc {
1499     using SafeMath for *;
1500     /**
1501      * @dev calculates number of keys received given X eth 
1502      * @param _curEth current amount of eth in contract 
1503      * @param _newEth eth being spent
1504      * @return amount of ticket purchased
1505      */
1506     function keysRec(uint256 _curEth, uint256 _newEth)
1507         internal
1508         pure
1509         returns (uint256)
1510     {
1511         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1512     }
1513     
1514     /**
1515      * @dev calculates amount of eth received if you sold X keys 
1516      * @param _curKeys current amount of keys that exist 
1517      * @param _sellKeys amount of keys you wish to sell
1518      * @return amount of eth received
1519      */
1520     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1521         internal
1522         pure
1523         returns (uint256)
1524     {
1525         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1526     }
1527 
1528     /**
1529      * @dev calculates how many keys would exist with given an amount of eth
1530      * @param _eth eth "in contract"
1531      * @return number of keys that would exist
1532      */
1533     function keys(uint256 _eth) 
1534         internal
1535         pure
1536         returns(uint256)
1537     {
1538         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1539     }
1540     
1541     /**
1542      * @dev calculates how much eth would be in contract given a number of keys
1543      * @param _keys number of keys "in contract" 
1544      * @return eth that would exists
1545      */
1546     function eth(uint256 _keys) 
1547         internal
1548         pure
1549         returns(uint256)  
1550     {
1551         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1552     }
1553 }
1554 
1555 interface BankInterfaceForForwarder {
1556     function deposit() external payable returns(bool);
1557 }
1558 
1559 interface PlayerBookInterface {
1560     function getPlayerID(address _addr) external returns (uint256);
1561     function getPlayerName(uint256 _pID) external view returns (bytes32);
1562     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1563     function getPlayerAddr(uint256 _pID) external view returns (address);
1564     function getNameFee() external view returns (uint256);
1565     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1566     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1567     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1568 }
1569 
1570 library NameFilter {
1571     /**
1572      * @dev filters name strings
1573      * -converts uppercase to lower case.  
1574      * -makes sure it does not start/end with a space
1575      * -makes sure it does not contain multiple spaces in a row
1576      * -cannot be only numbers
1577      * -cannot start with 0x 
1578      * -restricts characters to A-Z, a-z, 0-9, and space.
1579      * @return reprocessed string in bytes32 format
1580      */
1581     function nameFilter(string _input)
1582         internal
1583         pure
1584         returns(bytes32)
1585     {
1586         bytes memory _temp = bytes(_input);
1587         uint256 _length = _temp.length;
1588         
1589         //sorry limited to 32 characters
1590         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1591         // make sure it doesnt start with or end with space
1592         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1593         // make sure first two characters are not 0x
1594         if (_temp[0] == 0x30)
1595         {
1596             require(_temp[1] != 0x78, "string cannot start with 0x");
1597             require(_temp[1] != 0x58, "string cannot start with 0X");
1598         }
1599         
1600         // create a bool to track if we have a non number character
1601         bool _hasNonNumber;
1602         
1603         // convert & check
1604         for (uint256 i = 0; i < _length; i++)
1605         {
1606             // if its uppercase A-Z
1607             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1608             {
1609                 // convert to lower case a-z
1610                 _temp[i] = byte(uint(_temp[i]) + 32);
1611                 
1612                 // we have a non number
1613                 if (_hasNonNumber == false)
1614                     _hasNonNumber = true;
1615             } else {
1616                 require
1617                 (
1618                     // require character is a space
1619                     _temp[i] == 0x20 || 
1620                     // OR lowercase a-z
1621                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1622                     // or 0-9
1623                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1624                     "string contains invalid characters"
1625                 );
1626                 // make sure theres not 2x spaces in a row
1627                 if (_temp[i] == 0x20)
1628                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1629                 
1630                 // see if we have a character other than a number
1631                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1632                     _hasNonNumber = true;    
1633             }
1634         }
1635         
1636         require(_hasNonNumber == true, "string cannot be only numbers");
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
1652  * - changed asserts to requires with error log outputs
1653  * - removed div, its useless
1654  */
1655 library SafeMath {
1656     
1657     /**
1658     * @dev Multiplies two numbers, throws on overflow.
1659     */
1660     function mul(uint256 a, uint256 b) 
1661         internal 
1662         pure 
1663         returns (uint256 c) 
1664     {
1665         if (a == 0) {
1666             return 0;
1667         }
1668         c = a * b;
1669         require(c / a == b, "SafeMath mul failed");
1670         return c;
1671     }
1672 
1673     /**
1674     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1675     */
1676     function sub(uint256 a, uint256 b)
1677         internal
1678         pure
1679         returns (uint256) 
1680     {
1681         require(b <= a, "SafeMath sub failed");
1682         return a - b;
1683     }
1684 
1685     /**
1686     * @dev Adds two numbers, throws on overflow.
1687     */
1688     function add(uint256 a, uint256 b)
1689         internal
1690         pure
1691         returns (uint256 c) 
1692     {
1693         c = a + b;
1694         require(c >= a, "SafeMath add failed");
1695         return c;
1696     }
1697 
1698     /**
1699      * @dev gives square root of given x.
1700      */
1701     function sqrt(uint256 x)
1702         internal
1703         pure
1704         returns (uint256 y) 
1705     {
1706         uint256 z = ((add(x,1)) / 2);
1707         y = x;
1708         while (z < y) 
1709         {
1710             y = z;
1711             z = ((add((x / z),z)) / 2);
1712         }
1713     }
1714 
1715     /**
1716      * @dev gives square. multiplies x by x
1717      */
1718     function sq(uint256 x)
1719         internal
1720         pure
1721         returns (uint256)
1722     {
1723         return (mul(x,x));
1724     }
1725 }