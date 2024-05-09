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
37     // fired whenever theres a withdraw
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
105 contract modularRatScam is RSEvents {}
106 
107 contract RatScam is modularRatScam {
108     using SafeMath for *;
109     using NameFilter for string;
110     using RSKeysCalc for uint256;
111 
112     RatBookInterface constant private RatBook = RatBookInterface(0x3257d637b8977781b4f8178365858a474b2a6195);
113 
114     string constant public name = "RatScam In One Hour";
115     string constant public symbol = "RS";
116     uint256 private rndGap_ = 0;
117 
118     uint256 private rndInit_ = 1 hours;                // round timer starts at this
119     uint256 private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
120     uint256 private rndMax_ = 1 hours;                // max length a round timer can be
121     //==============================================================================
122     //     _| _ _|_ _    _ _ _|_    _   .
123     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
124     //=============================|================================================
125     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
126     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
127     uint256 public rID_;    // round id number / total rounds that have happened
128     //****************
129     // PLAYER DATA
130     //****************
131     address private adminAddress;
132     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
133     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
134     mapping (uint256 => RSdatasets.Player) public plyr_;   // (pID => data) player data
135     mapping (uint256 => mapping (uint256 => RSdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
136     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
137     //****************
138     // ROUND DATA
139     //****************
140     //RSdatasets.Round public round_;   // round data
141     mapping (uint256 => RSdatasets.Round) public round_;   // (rID => data) round data
142     //****************
143     // TEAM FEE DATA
144     //****************
145     uint256 public fees_ = 60;          // fee distribution
146     uint256 public potSplit_ = 45;     // pot split distribution
147     //==============================================================================
148     //     _ _  _  __|_ _    __|_ _  _  .
149     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
150     //==============================================================================
151     constructor()
152     public
153     {
154         adminAddress = msg.sender;
155     }
156     //==============================================================================
157     //     _ _  _  _|. |`. _  _ _  .
158     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
159     //==============================================================================
160     /**
161      * @dev used to make sure no one can interact with contract until it has
162      * been activated.
163      */
164     modifier isActivated() {
165         require(activated_ == true, "its not ready yet");
166         _;
167     }
168 
169     /**
170      * @dev prevents contracts from interacting with ratscam
171      */
172     modifier isHuman() {
173         address _addr = msg.sender;
174         uint256 _codeLength;
175 
176         assembly {_codeLength := extcodesize(_addr)}
177         require(_codeLength == 0, "non smart contract address only");
178         _;
179     }
180 
181     /**
182      * @dev sets boundaries for incoming tx
183      */
184     modifier isWithinLimits(uint256 _eth) {
185         require(_eth >= 1000000000, "too little money");
186         require(_eth <= 100000000000000000000000, "too much money");
187         _;
188     }
189 
190     //==============================================================================
191     //     _    |_ |. _   |`    _  __|_. _  _  _  .
192     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
193     //====|=========================================================================
194     /**
195      * @dev emergency buy uses last stored affiliate ID and team snek
196      */
197     function()
198     isActivated()
199     isHuman()
200     isWithinLimits(msg.value)
201     public
202     payable
203     {
204         // set up our tx event data and determine if player is new or not
205         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
206 
207         // fetch player id
208         uint256 _pID = pIDxAddr_[msg.sender];
209 
210         // buy core
211         buyCore(_pID, plyr_[_pID].laff, _eventData_);
212     }
213 
214     /**
215      * @dev converts all incoming ethereum to keys.
216      * -functionhash- 0x8f38f309 (using ID for affiliate)
217      * -functionhash- 0x98a0871d (using address for affiliate)
218      * -functionhash- 0xa65b37a1 (using name for affiliate)
219      * @param _affCode the ID/address/name of the player who gets the affiliate fee
220      */
221     function buyXid(uint256 _affCode)
222     isActivated()
223     isHuman()
224     isWithinLimits(msg.value)
225     public
226     payable
227     {
228         // set up our tx event data and determine if player is new or not
229         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
230 
231         // fetch player id
232         uint256 _pID = pIDxAddr_[msg.sender];
233 
234         // manage affiliate residuals
235         // if no affiliate code was given or player tried to use their own, lolz
236         if (_affCode == 0 || _affCode == _pID)
237         {
238             // use last stored affiliate code
239             _affCode = plyr_[_pID].laff;
240 
241             // if affiliate code was given & its not the same as previously stored
242         } else if (_affCode != plyr_[_pID].laff) {
243             // update last affiliate
244             plyr_[_pID].laff = _affCode;
245         }
246 
247         // buy core
248         buyCore(_pID, _affCode, _eventData_);
249     }
250 
251     function buyXaddr(address _affCode)
252     isActivated()
253     isHuman()
254     isWithinLimits(msg.value)
255     public
256     payable
257     {
258         // set up our tx event data and determine if player is new or not
259         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
260 
261         // fetch player id
262         uint256 _pID = pIDxAddr_[msg.sender];
263 
264         // manage affiliate residuals
265         uint256 _affID;
266         // if no affiliate code was given or player tried to use their own, lolz
267         if (_affCode == address(0) || _affCode == msg.sender)
268         {
269             // use last stored affiliate code
270             _affID = plyr_[_pID].laff;
271 
272             // if affiliate code was given
273         } else {
274             // get affiliate ID from aff Code
275             _affID = pIDxAddr_[_affCode];
276 
277             // if affID is not the same as previously stored
278             if (_affID != plyr_[_pID].laff)
279             {
280                 // update last affiliate
281                 plyr_[_pID].laff = _affID;
282             }
283         }
284 
285         // buy core
286         buyCore(_pID, _affID, _eventData_);
287     }
288 
289     function buyXname(bytes32 _affCode)
290     isActivated()
291     isHuman()
292     isWithinLimits(msg.value)
293     public
294     payable
295     {
296         // set up our tx event data and determine if player is new or not
297         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
298 
299         // fetch player id
300         uint256 _pID = pIDxAddr_[msg.sender];
301 
302         // manage affiliate residuals
303         uint256 _affID;
304         // if no affiliate code was given or player tried to use their own, lolz
305         if (_affCode == '' || _affCode == plyr_[_pID].name)
306         {
307             // use last stored affiliate code
308             _affID = plyr_[_pID].laff;
309 
310             // if affiliate code was given
311         } else {
312             // get affiliate ID from aff Code
313             _affID = pIDxName_[_affCode];
314 
315             // if affID is not the same as previously stored
316             if (_affID != plyr_[_pID].laff)
317             {
318                 // update last affiliate
319                 plyr_[_pID].laff = _affID;
320             }
321         }
322 
323         // buy core
324         buyCore(_pID, _affID, _eventData_);
325     }
326 
327     /**
328      * @dev essentially the same as buy, but instead of you sending ether
329      * from your wallet, it uses your unwithdrawn earnings.
330      * -functionhash- 0x349cdcac (using ID for affiliate)
331      * -functionhash- 0x82bfc739 (using address for affiliate)
332      * -functionhash- 0x079ce327 (using name for affiliate)
333      * @param _affCode the ID/address/name of the player who gets the affiliate fee
334      * @param _eth amount of earnings to use (remainder returned to gen vault)
335      */
336     function reLoadXid(uint256 _affCode, uint256 _eth)
337     isActivated()
338     isHuman()
339     isWithinLimits(_eth)
340     public
341     {
342         // set up our tx event data
343         RSdatasets.EventReturns memory _eventData_;
344 
345         // fetch player ID
346         uint256 _pID = pIDxAddr_[msg.sender];
347 
348         // manage affiliate residuals
349         // if no affiliate code was given or player tried to use their own, lolz
350         if (_affCode == 0 || _affCode == _pID)
351         {
352             // use last stored affiliate code
353             _affCode = plyr_[_pID].laff;
354 
355             // if affiliate code was given & its not the same as previously stored
356         } else if (_affCode != plyr_[_pID].laff) {
357             // update last affiliate
358             plyr_[_pID].laff = _affCode;
359         }
360 
361         // reload core
362         reLoadCore(_pID, _affCode, _eth, _eventData_);
363     }
364 
365     function reLoadXaddr(address _affCode, uint256 _eth)
366     isActivated()
367     isHuman()
368     isWithinLimits(_eth)
369     public
370     {
371         // set up our tx event data
372         RSdatasets.EventReturns memory _eventData_;
373 
374         // fetch player ID
375         uint256 _pID = pIDxAddr_[msg.sender];
376 
377         // manage affiliate residuals
378         uint256 _affID;
379         // if no affiliate code was given or player tried to use their own, lolz
380         if (_affCode == address(0) || _affCode == msg.sender)
381         {
382             // use last stored affiliate code
383             _affID = plyr_[_pID].laff;
384 
385             // if affiliate code was given
386         } else {
387             // get affiliate ID from aff Code
388             _affID = pIDxAddr_[_affCode];
389 
390             // if affID is not the same as previously stored
391             if (_affID != plyr_[_pID].laff)
392             {
393                 // update last affiliate
394                 plyr_[_pID].laff = _affID;
395             }
396         }
397 
398         // reload core
399         reLoadCore(_pID, _affID, _eth, _eventData_);
400     }
401 
402     function reLoadXname(bytes32 _affCode, uint256 _eth)
403     isActivated()
404     isHuman()
405     isWithinLimits(_eth)
406     public
407     {
408         // set up our tx event data
409         RSdatasets.EventReturns memory _eventData_;
410 
411         // fetch player ID
412         uint256 _pID = pIDxAddr_[msg.sender];
413 
414         // manage affiliate residuals
415         uint256 _affID;
416         // if no affiliate code was given or player tried to use their own, lolz
417         if (_affCode == '' || _affCode == plyr_[_pID].name)
418         {
419             // use last stored affiliate code
420             _affID = plyr_[_pID].laff;
421 
422             // if affiliate code was given
423         } else {
424             // get affiliate ID from aff Code
425             _affID = pIDxName_[_affCode];
426 
427             // if affID is not the same as previously stored
428             if (_affID != plyr_[_pID].laff)
429             {
430                 // update last affiliate
431                 plyr_[_pID].laff = _affID;
432             }
433         }
434 
435         // reload core
436         reLoadCore(_pID, _affID, _eth, _eventData_);
437     }
438 
439     /**
440      * @dev withdraws all of your earnings.
441      * -functionhash- 0x3ccfd60b
442      */
443     function withdraw()
444     isActivated()
445     isHuman()
446     public
447     {
448         // setup local rID
449         uint256 _rID = rID_;
450 
451         // grab time
452         uint256 _now = now;
453 
454         // fetch player ID
455         uint256 _pID = pIDxAddr_[msg.sender];
456 
457         // setup temp var for player eth
458         uint256 _eth;
459 
460         // check to see if round has ended and no one has run round end yet
461         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
462         {
463             // set up our tx event data
464             RSdatasets.EventReturns memory _eventData_;
465 
466             // end the round (distributes pot)
467             round_[_rID].ended = true;
468             _eventData_ = endRound(_eventData_);
469 
470             // get their earnings
471             _eth = withdrawEarnings(_pID);
472 
473             // gib moni
474             if (_eth > 0)
475                 plyr_[_pID].addr.transfer(_eth);
476 
477             // build event data
478             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
479             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
480 
481             // fire withdraw and distribute event
482             emit RSEvents.onWithdrawAndDistribute
483             (
484                 msg.sender,
485                 plyr_[_pID].name,
486                 _eth,
487                 _eventData_.compressedData,
488                 _eventData_.compressedIDs,
489                 _eventData_.winnerAddr,
490                 _eventData_.winnerName,
491                 _eventData_.amountWon,
492                 _eventData_.newPot,
493                 _eventData_.genAmount
494             );
495 
496             // in any other situation
497         } else {
498             // get their earnings
499             _eth = withdrawEarnings(_pID);
500 
501             // gib moni
502             if (_eth > 0)
503                 plyr_[_pID].addr.transfer(_eth);
504 
505             // fire withdraw event
506             emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
507         }
508     }
509 
510     /**
511      * @dev use these to register names.  they are just wrappers that will send the
512      * registration requests to the PlayerBook contract.  So registering here is the
513      * same as registering there.  UI will always display the last name you registered.
514      * but you will still own all previously registered names to use as affiliate
515      * links.
516      * - must pay a registration fee.
517      * - name must be unique
518      * - names will be converted to lowercase
519      * - name cannot start or end with a space
520      * - cannot have more than 1 space in a row
521      * - cannot be only numbers
522      * - cannot start with 0x
523      * - name must be at least 1 char
524      * - max length of 32 characters long
525      * - allowed characters: a-z, 0-9, and space
526      * -functionhash- 0x921dec21 (using ID for affiliate)
527      * -functionhash- 0x3ddd4698 (using address for affiliate)
528      * -functionhash- 0x685ffd83 (using name for affiliate)
529      * @param _nameString players desired name
530      * @param _affCode affiliate ID, address, or name of who referred you
531      * @param _all set to true if you want this to push your info to all games
532      * (this might cost a lot of gas)
533      */
534     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
535     isHuman()
536     public
537     payable
538     {
539         bytes32 _name = _nameString.nameFilter();
540         address _addr = msg.sender;
541         uint256 _paid = msg.value;
542         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
543 
544         uint256 _pID = pIDxAddr_[_addr];
545 
546         // fire event
547         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
548     }
549 
550     function registerNameXaddr(string _nameString, address _affCode, bool _all)
551     isHuman()
552     public
553     payable
554     {
555         bytes32 _name = _nameString.nameFilter();
556         address _addr = msg.sender;
557         uint256 _paid = msg.value;
558         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
559 
560         uint256 _pID = pIDxAddr_[_addr];
561 
562         // fire event
563         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
564     }
565 
566     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
567     isHuman()
568     public
569     payable
570     {
571         bytes32 _name = _nameString.nameFilter();
572         address _addr = msg.sender;
573         uint256 _paid = msg.value;
574         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
575 
576         uint256 _pID = pIDxAddr_[_addr];
577 
578         // fire event
579         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
580     }
581     //==============================================================================
582     //     _  _ _|__|_ _  _ _  .
583     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
584     //=====_|=======================================================================
585     /**
586      * @dev return the price buyer will pay for next 1 individual key.
587      * -functionhash- 0x018a25e8
588      * @return price for next key bought (in wei format)
589      */
590     function getBuyPrice()
591     public
592     view
593     returns(uint256)
594     {
595         // setup local rID
596         uint256 _rID = rID_;
597 
598         // grab time
599         uint256 _now = now;
600 
601         // are we in a round?
602         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
603             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
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
615     public
616     view
617     returns(uint256)
618     {
619         // setup local rID
620         uint256 _rID = rID_;
621 
622         // grab time
623         uint256 _now = now;
624 
625         if (_now < round_[_rID].end)
626             if (_now > round_[_rID].strt + rndGap_)
627                 return( (round_[_rID].end).sub(_now) );
628             else
629                 return( (round_[_rID].strt + rndGap_).sub(_now));
630         else
631             return(0);
632     }
633 
634     /**
635      * @dev returns player earnings per vaults
636      * -functionhash- 0x63066434
637      * @return winnings vault
638      * @return general vault
639      * @return affiliate vault
640      */
641     function getPlayerVaults(uint256 _pID)
642     public
643     view
644     returns(uint256 ,uint256, uint256)
645     {
646         // setup local rID
647         uint256 _rID = rID_;
648 
649         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
650         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
651         {
652             // if player is winner
653             if (round_[_rID].plyr == _pID)
654             {
655                 return
656                 (
657                 (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
658                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
659                 plyr_[_pID].aff
660                 );
661                 // if player is not the winner
662             } else {
663                 return
664                 (
665                 plyr_[_pID].win,
666                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
667                 plyr_[_pID].aff
668                 );
669             }
670 
671             // if round is still going on, or round has ended and round end has been ran
672         } else {
673             return
674             (
675             plyr_[_pID].win,
676             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
677             plyr_[_pID].aff
678             );
679         }
680     }
681 
682     /**
683      * solidity hates stack limits.  this lets us avoid that hate
684      */
685     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
686     private
687     view
688     returns(uint256)
689     {
690         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
691     }
692 
693     /**
694      * @dev returns all current round info needed for front end
695      * -functionhash- 0x747dff42
696      * @return total keys
697      * @return time ends
698      * @return time started
699      * @return current pot
700      * @return current player ID in lead
701      * @return current player in leads address
702      * @return current player in leads name
703      * @return airdrop tracker # & airdrop pot
704      */
705     function getCurrentRoundInfo()
706     public
707     view
708     returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
709     {
710         // setup local rID
711         uint256 _rID = rID_;
712 
713         return
714         (
715         round_[rID_].keys,              //0
716         round_[rID_].end,               //1
717         round_[rID_].strt,              //2
718         round_[rID_].pot,               //3
719         round_[rID_].plyr,              //4
720         plyr_[round_[rID_].plyr].addr,  //5
721         plyr_[round_[rID_].plyr].name,  //6
722         airDropTracker_ + (airDropPot_ * 1000)              //7
723         );
724     }
725 
726     /**
727      * @dev returns player info based on address.  if no address is given, it will
728      * use msg.sender
729      * -functionhash- 0xee0b5d8b
730      * @param _addr address of the player you want to lookup
731      * @return player ID
732      * @return player name
733      * @return keys owned (current round)
734      * @return winnings vault
735      * @return general vault
736      * @return affiliate vault
737 	 * @return player round eth
738      */
739     function getPlayerInfoByAddress(address _addr)
740     public
741     view
742     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
743     {
744         // setup local rID
745         uint256 _rID = rID_;
746 
747         if (_addr == address(0))
748         {
749             _addr == msg.sender;
750         }
751         uint256 _pID = pIDxAddr_[_addr];
752 
753         return
754         (
755         _pID,                               //0
756         plyr_[_pID].name,                   //1
757         plyrRnds_[_pID][_rID].keys,         //2
758         plyr_[_pID].win,                    //3
759         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
760         plyr_[_pID].aff,                    //5
761         plyrRnds_[_pID][_rID].eth           //6
762         );
763     }
764 
765     //==============================================================================
766     //     _ _  _ _   | _  _ . _  .
767     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
768     //=====================_|=======================================================
769     /**
770      * @dev logic runs whenever a buy order is executed.  determines how to handle
771      * incoming eth depending on if we are in an active round or not
772      */
773     function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
774     private
775     {
776         // setup local rID
777         uint256 _rID = rID_;
778 
779         // grab time
780         uint256 _now = now;
781 
782         // if round is end, fire endRound
783         if (_now > round_[_rID].end && round_[_rID].ended == false)
784         {
785             // end the round (distributes pot) & start new round
786             round_[_rID].ended = true;
787             _eventData_ = endRound(_eventData_);
788 
789             // build event data
790             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
791             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
792 
793             // fire buy and distribute event
794             emit RSEvents.onBuyAndDistribute
795             (
796                 msg.sender,
797                 plyr_[_pID].name,
798                 msg.value,
799                 _eventData_.compressedData,
800                 _eventData_.compressedIDs,
801                 _eventData_.winnerAddr,
802                 _eventData_.winnerName,
803                 _eventData_.amountWon,
804                 _eventData_.newPot,
805                 _eventData_.genAmount
806             );
807         }
808         
809         _rID = rID_;
810         core(_rID, _pID, msg.value, _affID, _eventData_);
811     }
812 
813     /**
814      * @dev logic runs whenever a reload order is executed.  determines how to handle
815      * incoming eth depending on if we are in an active round or not
816      */
817     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, RSdatasets.EventReturns memory _eventData_)
818     private
819     {
820         // setup local rID
821         uint256 _rID = rID_;
822 
823         // grab time
824         uint256 _now = now;
825 
826         // if round is end, fire endRound
827         if (_now > round_[_rID].end && round_[_rID].ended == false)
828         {
829             // end the round (distributes pot) & start new round
830             round_[_rID].ended = true;
831             _eventData_ = endRound(_eventData_);
832 
833             // build event data
834             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
835             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
836 
837             // fire buy and distribute event
838             emit RSEvents.onBuyAndDistribute
839             (
840                 msg.sender,
841                 plyr_[_pID].name,
842                 msg.value,
843                 _eventData_.compressedData,
844                 _eventData_.compressedIDs,
845                 _eventData_.winnerAddr,
846                 _eventData_.winnerName,
847                 _eventData_.amountWon,
848                 _eventData_.newPot,
849                 _eventData_.genAmount
850             );
851         }
852         
853         // get earnings from all vaults and return unused to gen vault
854         // because we use a custom safemath library.  this will throw if player
855         // tried to spend more eth than they have.
856         plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
857 
858         // call core
859         core( _rID, _pID, _eth, _affID, _eventData_);
860     }
861 
862     /**
863      * @dev this is the core logic for any buy/reload that happens while a round
864      * is live.
865      */
866     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
867     private
868     {
869         // if player is new to round
870         if (plyrRnds_[_pID][_rID].keys == 0)
871             _eventData_ = managePlayer(_pID, _eventData_);
872 
873         // early round eth limiter
874         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 10000000000000000000)
875         {
876             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
877             uint256 _refund = _eth.sub(_availableLimit);
878             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
879             _eth = _availableLimit;
880         }
881 
882         // if eth left is greater than min eth allowed (sorry no pocket lint)
883         if (_eth > 1000000000)
884         {
885 
886             // mint the new keys
887             // uint256 _keys = (round_[_rID].eth).keysRec(_eth);
888             uint256 _keys = 1000000000000000000;
889 
890             // if they bought at least 1 whole key
891             if (_keys >= 1000000000000000000)
892             {
893                 updateTimer(_keys, _rID);
894 
895                 // set new leaders
896                 if (round_[_rID].plyr != _pID)
897                     round_[_rID].plyr = _pID;
898 
899                 // set the new leader bool to true
900                 _eventData_.compressedData = _eventData_.compressedData + 100;
901             }
902 
903             // manage airdrops
904             if (_eth >= 100000000000000000)
905             {
906                 airDropTracker_++;
907                 if (airdrop() == true)
908                 {
909                     // gib muni
910                     uint256 _prize;
911                     if (_eth >= 10000000000000000000)
912                     {
913                         // calculate prize and give it to winner
914                         _prize = ((airDropPot_).mul(75)) / 100;
915                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
916 
917                         // adjust airDropPot
918                         airDropPot_ = (airDropPot_).sub(_prize);
919 
920                         // let event know a tier 3 prize was won
921                         _eventData_.compressedData += 300000000000000000000000000000000;
922                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
923                         // calculate prize and give it to winner
924                         _prize = ((airDropPot_).mul(50)) / 100;
925                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
926 
927                         // adjust airDropPot
928                         airDropPot_ = (airDropPot_).sub(_prize);
929 
930                         // let event know a tier 2 prize was won
931                         _eventData_.compressedData += 200000000000000000000000000000000;
932                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
933                         // calculate prize and give it to winner
934                         _prize = ((airDropPot_).mul(25)) / 100;
935                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
936 
937                         // adjust airDropPot
938                         airDropPot_ = (airDropPot_).sub(_prize);
939 
940                         // let event know a tier 1 prize was won
941                         _eventData_.compressedData += 100000000000000000000000000000000;
942                     }
943                     // set airdrop happened bool to true
944                     _eventData_.compressedData += 10000000000000000000000000000000;
945                     // let event know how much was won
946                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
947 
948                     // reset air drop tracker
949                     airDropTracker_ = 0;
950                 }
951             }
952 
953             // store the air drop tracker number (number of buys since last airdrop)
954             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
955 
956             // update player
957             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
958             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
959 
960             // update round
961             round_[_rID].keys = _keys.add(round_[_rID].keys);
962             round_[_rID].eth = _eth.add(round_[_rID].eth);
963 
964             // distribute eth
965             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
966             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
967 
968             // call end tx function to fire end tx event.
969             endTx(_pID, _eth, _keys, _eventData_);
970         }
971     }
972     //==============================================================================
973     //     _ _ | _   | _ _|_ _  _ _  .
974     //    (_(_||(_|_||(_| | (_)| _\  .
975     //==============================================================================
976     /**
977      * @dev calculates unmasked earnings (just calculates, does not update mask)
978      * @return earnings in wei format
979      */
980     function calcUnMaskedEarnings(uint256 _pID, uint256 _rID)
981     private
982     view
983     returns(uint256)
984     {
985         return((((round_[_rID].mask).mul(plyrRnds_[_pID][_rID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rID].mask));
986     }
987 
988     /**
989      * @dev returns the amount of keys you would get given an amount of eth.
990      * -functionhash- 0xce89c80c
991      * @param _eth amount of eth sent in
992      * @return keys received
993      */
994     function calcKeysReceived(uint256 _eth)
995     public
996     view
997     returns(uint256)
998     {
999         uint256 _rID = rID_;
1000 
1001         // grab time
1002         uint256 _now = now;
1003 
1004         // are we in a round?
1005         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1006             return ( (round_[_rID].eth).keysRec(_eth) );
1007         else // rounds over.  need keys for new round
1008             return ( (_eth).keys() );
1009     }
1010 
1011     /**
1012      * @dev returns current eth price for X keys.
1013      * -functionhash- 0xcf808000
1014      * @param _keys number of keys desired (in 18 decimal format)
1015      * @return amount of eth needed to send
1016      */
1017     function iWantXKeys(uint256 _keys)
1018     public
1019     view
1020     returns(uint256)
1021     {
1022         // setup local rID
1023         uint256 _rID = rID_;
1024 
1025         // grab time
1026         uint256 _now = now;
1027 
1028         // are we in a round?
1029         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1030             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1031         else // rounds over.  need price for new round
1032             return ( (_keys).eth() );
1033     }
1034     //==============================================================================
1035     //    _|_ _  _ | _  .
1036     //     | (_)(_)|_\  .
1037     //==============================================================================
1038     /**
1039 	 * @dev receives name/player info from names contract
1040      */
1041     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1042     external
1043     {
1044         require (msg.sender == address(RatBook), "only RatBook can call this function");
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
1063     external
1064     {
1065         require (msg.sender == address(RatBook), "only RatBook can call this function");
1066         if(plyrNames_[_pID][_name] == false)
1067             plyrNames_[_pID][_name] = true;
1068     }
1069 
1070     /**
1071      * @dev gets existing or registers new pID.  use this when a player may be new
1072      * @return pID
1073      */
1074     function determinePID(RSdatasets.EventReturns memory _eventData_)
1075     private
1076     returns (RSdatasets.EventReturns)
1077     {
1078         uint256 _pID = pIDxAddr_[msg.sender];
1079         // if player is new to this version of ratscam
1080         if (_pID == 0)
1081         {
1082             // grab their player ID, name and last aff ID, from player names contract
1083             _pID = RatBook.getPlayerID(msg.sender);
1084             bytes32 _name = RatBook.getPlayerName(_pID);
1085             uint256 _laff = RatBook.getPlayerLAff(_pID);
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
1111     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1112     private
1113     returns (RSdatasets.EventReturns)
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
1132     function endRound(RSdatasets.EventReturns memory _eventData_)
1133     private
1134     returns (RSdatasets.EventReturns)
1135     {
1136         // setup local rID
1137         uint256 _rID = rID_;
1138 
1139         // grab our winning player and team id's
1140         uint256 _winPID = round_[_rID].plyr;
1141 
1142         // grab our pot amount
1143         // add airdrop pot into the final pot
1144         uint256 _pot = round_[_rID].pot;
1145 
1146         // calculate our winner share, community rewards, gen share,
1147         // p3d share, and amount reserved for next pot
1148         uint256 _win = (_pot.mul(45)) / 100;
1149         uint256 _com = (_pot / 10);
1150         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1151 
1152         // calculate ppt for round mask
1153         uint256 _ppt = 0;
1154         if(round_[_rID].keys > 0)
1155         {
1156             _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1157         }
1158         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1159         
1160         if (_dust > 0)
1161         {
1162             _gen = _gen.sub(_dust);
1163             _com = _com.add(_dust);
1164         }
1165 
1166         // pay our winner
1167         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1168 
1169         // community rewards
1170         adminAddress.transfer(_com);
1171 
1172         // distribute gen portion to key holders
1173         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1174 
1175         // prepare event data
1176         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1177         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1178         _eventData_.winnerAddr = plyr_[_winPID].addr;
1179         _eventData_.winnerName = plyr_[_winPID].name;
1180         _eventData_.amountWon = _win;
1181         _eventData_.genAmount = _gen;
1182         _eventData_.newPot = 0;
1183 
1184         // start next round
1185         rID_++;
1186         _rID++;
1187         round_[_rID].strt = now;
1188         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1189         round_[_rID].pot = 0;
1190 
1191         return(_eventData_);
1192     }
1193 
1194     /**
1195      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1196      */
1197     function updateGenVault(uint256 _pID, uint256 _rID)
1198     private
1199     {
1200         uint256 _earnings = calcUnMaskedEarnings(_pID, _rID);
1201         if (_earnings > 0)
1202         {
1203             // put in gen vault
1204             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1205             // zero out their earnings by updating mask
1206             plyrRnds_[_pID][_rID].mask = _earnings.add(plyrRnds_[_pID][_rID].mask);
1207         }
1208     }
1209 
1210     /**
1211      * @dev updates round timer based on number of whole keys bought.
1212      */
1213     function updateTimer(uint256 _keys, uint256 _rID)
1214     private
1215     {
1216         // grab time
1217         uint256 _now = now;
1218 
1219         // calculate time based on number of keys bought
1220         uint256 _newTime;
1221         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1222             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1223         else
1224             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1225 
1226         // compare to max and set new end time
1227         if (_newTime < (rndMax_).add(_now))
1228             round_[_rID].end = _newTime;
1229         else
1230             round_[_rID].end = rndMax_.add(_now);
1231     }
1232 
1233     /**
1234      * @dev generates a random number between 0-99 and checks to see if thats
1235      * resulted in an airdrop win
1236      * @return do we have a winner?
1237      */
1238     function airdrop()
1239     private
1240     view
1241     returns(bool)
1242     {
1243         uint256 seed = uint256(keccak256(abi.encodePacked(
1244 
1245                 (block.timestamp).add
1246                 (block.difficulty).add
1247                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1248                 (block.gaslimit).add
1249                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1250                 (block.number)
1251 
1252             )));
1253         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1254             return(true);
1255         else
1256             return(false);
1257     }
1258 
1259     /**
1260      * @dev distributes eth based on fees to com, aff, and p3d
1261      */
1262     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1263     private
1264     returns(RSdatasets.EventReturns)
1265     {
1266         // pay 5% out to community rewards
1267         uint256 _com = _eth * 5 / 100;
1268 
1269         // distribute share to affiliate
1270         uint256 _aff = _eth / 10;
1271 
1272         // decide what to do with affiliate share of fees
1273         // affiliate must not be self, and must have a name registered
1274         if (_affID != _pID && plyr_[_affID].name != '') {
1275             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1276             emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1277         } else {
1278             // no affiliates, add to community
1279             _com += _aff;
1280         }
1281 
1282         // pay out team
1283         adminAddress.transfer(_com);
1284 
1285         return(_eventData_);
1286     }
1287 
1288     /**
1289      * @dev distributes eth based on fees to gen and pot
1290      */
1291     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1292     private
1293     returns(RSdatasets.EventReturns)
1294     {
1295         // calculate gen share
1296         uint256 _gen = (_eth.mul(fees_)) / 100;
1297 
1298         // toss 5% into airdrop pot
1299         uint256 _air = (_eth / 20);
1300         airDropPot_ = airDropPot_.add(_air);
1301 
1302         // calculate pot (20%)
1303         uint256 _pot = (_eth.mul(20) / 100);
1304 
1305         // distribute gen share (thats what updateMasks() does) and adjust
1306         // balances for dust.
1307         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1308         if (_dust > 0)
1309             _gen = _gen.sub(_dust);
1310 
1311         // add eth to pot
1312         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1313 
1314         // set up event data
1315         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1316         _eventData_.potAmount = _pot;
1317 
1318         return(_eventData_);
1319     }
1320 
1321     /**
1322      * @dev updates masks for round and player when keys are bought
1323      * @return dust left over
1324      */
1325     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1326     private
1327     returns(uint256)
1328     {
1329         /* MASKING NOTES
1330             earnings masks are a tricky thing for people to wrap their minds around.
1331             the basic thing to understand here.  is were going to have a global
1332             tracker based on profit per share for each round, that increases in
1333             relevant proportion to the increase in share supply.
1334 
1335             the player will have an additional mask that basically says "based
1336             on the rounds mask, my shares, and how much i've already withdrawn,
1337             how much is still owed to me?"
1338         */
1339 
1340         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1341         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1342         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1343 
1344         // calculate player earning from their own buy (only based on the keys
1345         // they just bought).  & update player earnings mask
1346         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1347         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1348 
1349         // calculate & return dust
1350         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1351     }
1352 
1353     /**
1354      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1355      * @return earnings in wei format
1356      */
1357     function withdrawEarnings(uint256 _pID)
1358     private
1359     returns(uint256)
1360     {
1361         // update gen vault
1362         updateGenVault(_pID, plyr_[_pID].lrnd);
1363 
1364         // from vaults
1365         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1366         if (_earnings > 0)
1367         {
1368             plyr_[_pID].win = 0;
1369             plyr_[_pID].gen = 0;
1370             plyr_[_pID].aff = 0;
1371         }
1372 
1373         return(_earnings);
1374     }
1375 
1376     /**
1377      * @dev prepares compression data and fires event for buy or reload tx's
1378      */
1379     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1380     private
1381     {
1382         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1383         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1384 
1385         emit RSEvents.onEndTx
1386         (
1387             _eventData_.compressedData,
1388             _eventData_.compressedIDs,
1389             plyr_[_pID].name,
1390             msg.sender,
1391             _eth,
1392             _keys,
1393             _eventData_.winnerAddr,
1394             _eventData_.winnerName,
1395             _eventData_.amountWon,
1396             _eventData_.newPot,
1397             _eventData_.genAmount,
1398             _eventData_.potAmount,
1399             airDropPot_
1400         );
1401     }
1402 
1403     /** upon contract deploy, it will be deactivated.  this is a one time
1404      * use function that will activate the contract.  we do this so devs
1405      * have time to set things up on the web end                            **/
1406     bool public activated_ = false;
1407     function activate()
1408     public
1409     {
1410         // only owner can activate
1411         require(
1412             msg.sender == adminAddress,
1413             "only owner can activate"
1414         );
1415 
1416         // can only be ran once
1417         require(activated_ == false, "ratscam already activated");
1418 
1419         // activate the contract
1420         activated_ = true;
1421 
1422         // lets start first round
1423         rID_ = 1;
1424         round_[1].strt = now - rndGap_;
1425         round_[1].end = now + rndInit_;
1426     }
1427 
1428     function setNextRndTime(uint32 rndInit, uint32 rndInc, uint32 rndMax)
1429     public
1430     {
1431         // only owner
1432         require(msg.sender == adminAddress, "only owner can setNextRndTime");
1433 
1434         rndInit_ = rndInit * 1 hours;
1435         rndInc_ = rndInc * 1 seconds;
1436         rndMax_ = rndMax * 1 hours;
1437     }
1438 }
1439 
1440 //==============================================================================
1441 //   __|_ _    __|_ _  .
1442 //  _\ | | |_|(_ | _\  .
1443 //==============================================================================
1444 library RSdatasets {
1445     //compressedData key
1446     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1447     // 0 - new player (bool)
1448     // 1 - joined round (bool)
1449     // 2 - new  leader (bool)
1450     // 3-5 - air drop tracker (uint 0-999)
1451     // 6-16 - round end time
1452     // 17 - winnerTeam
1453     // 18 - 28 timestamp
1454     // 29 - team
1455     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1456     // 31 - airdrop happened bool
1457     // 32 - airdrop tier
1458     // 33 - airdrop amount won
1459     //compressedIDs key
1460     // [77-52][51-26][25-0]
1461     // 0-25 - pID
1462     // 26-51 - winPID
1463     // 52-77 - rID
1464     struct EventReturns {
1465         uint256 compressedData;
1466         uint256 compressedIDs;
1467         address winnerAddr;         // winner address
1468         bytes32 winnerName;         // winner name
1469         uint256 amountWon;          // amount won
1470         uint256 newPot;             // amount in new pot
1471         uint256 genAmount;          // amount distributed to gen
1472         uint256 potAmount;          // amount added to pot
1473     }
1474     struct Player {
1475         address addr;   // player address
1476         bytes32 name;   // player name
1477         uint256 win;    // winnings vault
1478         uint256 gen;    // general vault
1479         uint256 aff;    // affiliate vault
1480         uint256 laff;   // last affiliate id used
1481         uint256 lrnd;   // last round played
1482     }
1483     struct PlayerRounds {
1484         uint256 eth;    // eth player has added to round (used for eth limiter)
1485         uint256 keys;   // keys
1486         uint256 mask;   // player mask
1487     }
1488     struct Round {
1489         uint256 plyr;   // pID of player in lead
1490         uint256 end;    // time ends/ended
1491         bool ended;     // has round end function been ran
1492         uint256 strt;   // time round started
1493         uint256 keys;   // keys
1494         uint256 eth;    // total eth in
1495         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1496         uint256 mask;   // global mask
1497     }
1498 }
1499 
1500 //==============================================================================
1501 //  |  _      _ _ | _  .
1502 //  |<(/_\/  (_(_||(_  .
1503 //=======/======================================================================
1504 library RSKeysCalc {
1505     using SafeMath for *;
1506     /**
1507      * @dev calculates number of keys received given X eth
1508      * @param _curEth current amount of eth in contract
1509      * @param _newEth eth being spent
1510      * @return amount of ticket purchased
1511      */
1512     function keysRec(uint256 _curEth, uint256 _newEth)
1513     internal
1514     pure
1515     returns (uint256)
1516     {
1517         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1518     }
1519 
1520     /**
1521      * @dev calculates amount of eth received if you sold X keys
1522      * @param _curKeys current amount of keys that exist
1523      * @param _sellKeys amount of keys you wish to sell
1524      * @return amount of eth received
1525      */
1526     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1527     internal
1528     pure
1529     returns (uint256)
1530     {
1531         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1532     }
1533 
1534     /**
1535      * @dev calculates how many keys would exist with given an amount of eth
1536      * @param _eth eth "in contract"
1537      * @return number of keys that would exist
1538      */
1539     function keys(uint256 _eth)
1540     internal
1541     pure
1542     returns(uint256)
1543     {
1544         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1545     }
1546 
1547     /**
1548      * @dev calculates how much eth would be in contract given a number of keys
1549      * @param _keys number of keys "in contract"
1550      * @return eth that would exists
1551      */
1552     function eth(uint256 _keys)
1553     internal
1554     pure
1555     returns(uint256)
1556     {
1557         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1558     }
1559 }
1560 
1561 //interface RatInterfaceForForwarder {
1562 //    function deposit() external payable returns(bool);
1563 //}
1564 
1565 interface RatBookInterface {
1566     function getPlayerID(address _addr) external returns (uint256);
1567     function getPlayerName(uint256 _pID) external view returns (bytes32);
1568     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1569     function getPlayerAddr(uint256 _pID) external view returns (address);
1570     function getNameFee() external view returns (uint256);
1571     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1572     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1573     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1574 }
1575 
1576 library NameFilter {
1577     /**
1578      * @dev filters name strings
1579      * -converts uppercase to lower case.
1580      * -makes sure it does not start/end with a space
1581      * -makes sure it does not contain multiple spaces in a row
1582      * -cannot be only numbers
1583      * -cannot start with 0x
1584      * -restricts characters to A-Z, a-z, 0-9, and space.
1585      * @return reprocessed string in bytes32 format
1586      */
1587     function nameFilter(string _input)
1588     internal
1589     pure
1590     returns(bytes32)
1591     {
1592         bytes memory _temp = bytes(_input);
1593         uint256 _length = _temp.length;
1594 
1595         //sorry limited to 32 characters
1596         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1597         // make sure it doesnt start with or end with space
1598         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1599         // make sure first two characters are not 0x
1600         if (_temp[0] == 0x30)
1601         {
1602             require(_temp[1] != 0x78, "string cannot start with 0x");
1603             require(_temp[1] != 0x58, "string cannot start with 0X");
1604         }
1605 
1606         // create a bool to track if we have a non number character
1607         bool _hasNonNumber;
1608 
1609         // convert & check
1610         for (uint256 i = 0; i < _length; i++)
1611         {
1612             // if its uppercase A-Z
1613             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1614             {
1615                 // convert to lower case a-z
1616                 _temp[i] = byte(uint(_temp[i]) + 32);
1617 
1618                 // we have a non number
1619                 if (_hasNonNumber == false)
1620                     _hasNonNumber = true;
1621             } else {
1622                 require
1623                 (
1624                 // require character is a space
1625                     _temp[i] == 0x20 ||
1626                 // OR lowercase a-z
1627                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1628                 // or 0-9
1629                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1630                     "string contains invalid characters"
1631                 );
1632                 // make sure theres not 2x spaces in a row
1633                 if (_temp[i] == 0x20)
1634                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1635 
1636                 // see if we have a character other than a number
1637                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1638                     _hasNonNumber = true;
1639             }
1640         }
1641 
1642         require(_hasNonNumber == true, "string cannot be only numbers");
1643 
1644         bytes32 _ret;
1645         assembly {
1646             _ret := mload(add(_temp, 32))
1647         }
1648         return (_ret);
1649     }
1650 }
1651 
1652 /**
1653  * @title SafeMath v0.1.9
1654  * @dev Math operations with safety checks that throw on error
1655  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1656  * - added sqrt
1657  * - added sq
1658  * - changed asserts to requires with error log outputs
1659  * - removed div, its useless
1660  */
1661 library SafeMath {
1662 
1663     /**
1664     * @dev Multiplies two numbers, throws on overflow.
1665     */
1666     function mul(uint256 a, uint256 b)
1667     internal
1668     pure
1669     returns (uint256 c)
1670     {
1671         if (a == 0) {
1672             return 0;
1673         }
1674         c = a * b;
1675         require(c / a == b, "SafeMath mul failed");
1676         return c;
1677     }
1678 
1679     /**
1680     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1681     */
1682     function sub(uint256 a, uint256 b)
1683     internal
1684     pure
1685     returns (uint256)
1686     {
1687         require(b <= a, "SafeMath sub failed");
1688         return a - b;
1689     }
1690 
1691     /**
1692     * @dev Adds two numbers, throws on overflow.
1693     */
1694     function add(uint256 a, uint256 b)
1695     internal
1696     pure
1697     returns (uint256 c)
1698     {
1699         c = a + b;
1700         require(c >= a, "SafeMath add failed");
1701         return c;
1702     }
1703 
1704     /**
1705      * @dev gives square root of given x.
1706      */
1707     function sqrt(uint256 x)
1708     internal
1709     pure
1710     returns (uint256 y)
1711     {
1712         uint256 z = ((add(x,1)) / 2);
1713         y = x;
1714         while (z < y)
1715         {
1716             y = z;
1717             z = ((add((x / z),z)) / 2);
1718         }
1719     }
1720 
1721     /**
1722      * @dev gives square. multiplies x by x
1723      */
1724     function sq(uint256 x)
1725     internal
1726     pure
1727     returns (uint256)
1728     {
1729         return (mul(x,x));
1730     }
1731 }