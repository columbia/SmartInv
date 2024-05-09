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
112     RatBookInterface constant private RatBook = RatBookInterface(0xA50A1d26f7F9FBf24EF1a41B2870E317f9c4BC93);
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
887             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
888 
889             // if they bought at least 1 whole key
890             if (_keys >= 1000000000000000000)
891             {
892                 updateTimer(_keys, _rID);
893 
894                 // set new leaders
895                 if (round_[_rID].plyr != _pID)
896                     round_[_rID].plyr = _pID;
897 
898                 // set the new leader bool to true
899                 _eventData_.compressedData = _eventData_.compressedData + 100;
900             }
901 
902             // manage airdrops
903             if (_eth >= 100000000000000000)
904             {
905                 airDropTracker_++;
906                 if (airdrop() == true)
907                 {
908                     // gib muni
909                     uint256 _prize;
910                     if (_eth >= 10000000000000000000)
911                     {
912                         // calculate prize and give it to winner
913                         _prize = ((airDropPot_).mul(75)) / 100;
914                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
915 
916                         // adjust airDropPot
917                         airDropPot_ = (airDropPot_).sub(_prize);
918 
919                         // let event know a tier 3 prize was won
920                         _eventData_.compressedData += 300000000000000000000000000000000;
921                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
922                         // calculate prize and give it to winner
923                         _prize = ((airDropPot_).mul(50)) / 100;
924                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
925 
926                         // adjust airDropPot
927                         airDropPot_ = (airDropPot_).sub(_prize);
928 
929                         // let event know a tier 2 prize was won
930                         _eventData_.compressedData += 200000000000000000000000000000000;
931                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
932                         // calculate prize and give it to winner
933                         _prize = ((airDropPot_).mul(25)) / 100;
934                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
935 
936                         // adjust airDropPot
937                         airDropPot_ = (airDropPot_).sub(_prize);
938 
939                         // let event know a tier 1 prize was won
940                         _eventData_.compressedData += 100000000000000000000000000000000;
941                     }
942                     // set airdrop happened bool to true
943                     _eventData_.compressedData += 10000000000000000000000000000000;
944                     // let event know how much was won
945                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
946 
947                     // reset air drop tracker
948                     airDropTracker_ = 0;
949                 }
950             }
951 
952             // store the air drop tracker number (number of buys since last airdrop)
953             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
954 
955             // update player
956             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
957             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
958 
959             // update round
960             round_[_rID].keys = _keys.add(round_[_rID].keys);
961             round_[_rID].eth = _eth.add(round_[_rID].eth);
962 
963             // distribute eth
964             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
965             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
966 
967             // call end tx function to fire end tx event.
968             endTx(_pID, _eth, _keys, _eventData_);
969         }
970     }
971     //==============================================================================
972     //     _ _ | _   | _ _|_ _  _ _  .
973     //    (_(_||(_|_||(_| | (_)| _\  .
974     //==============================================================================
975     /**
976      * @dev calculates unmasked earnings (just calculates, does not update mask)
977      * @return earnings in wei format
978      */
979     function calcUnMaskedEarnings(uint256 _pID, uint256 _rID)
980     private
981     view
982     returns(uint256)
983     {
984         return((((round_[_rID].mask).mul(plyrRnds_[_pID][_rID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rID].mask));
985     }
986 
987     /**
988      * @dev returns the amount of keys you would get given an amount of eth.
989      * -functionhash- 0xce89c80c
990      * @param _eth amount of eth sent in
991      * @return keys received
992      */
993     function calcKeysReceived(uint256 _eth)
994     public
995     view
996     returns(uint256)
997     {
998         uint256 _rID = rID_;
999 
1000         // grab time
1001         uint256 _now = now;
1002 
1003         // are we in a round?
1004         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1005             return ( (round_[_rID].eth).keysRec(_eth) );
1006         else // rounds over.  need keys for new round
1007             return ( (_eth).keys() );
1008     }
1009 
1010     /**
1011      * @dev returns current eth price for X keys.
1012      * -functionhash- 0xcf808000
1013      * @param _keys number of keys desired (in 18 decimal format)
1014      * @return amount of eth needed to send
1015      */
1016     function iWantXKeys(uint256 _keys)
1017     public
1018     view
1019     returns(uint256)
1020     {
1021         // setup local rID
1022         uint256 _rID = rID_;
1023 
1024         // grab time
1025         uint256 _now = now;
1026 
1027         // are we in a round?
1028         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1029             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1030         else // rounds over.  need price for new round
1031             return ( (_keys).eth() );
1032     }
1033     //==============================================================================
1034     //    _|_ _  _ | _  .
1035     //     | (_)(_)|_\  .
1036     //==============================================================================
1037     /**
1038 	 * @dev receives name/player info from names contract
1039      */
1040     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1041     external
1042     {
1043         require (msg.sender == address(RatBook), "only RatBook can call this function");
1044         if (pIDxAddr_[_addr] != _pID)
1045             pIDxAddr_[_addr] = _pID;
1046         if (pIDxName_[_name] != _pID)
1047             pIDxName_[_name] = _pID;
1048         if (plyr_[_pID].addr != _addr)
1049             plyr_[_pID].addr = _addr;
1050         if (plyr_[_pID].name != _name)
1051             plyr_[_pID].name = _name;
1052         if (plyr_[_pID].laff != _laff)
1053             plyr_[_pID].laff = _laff;
1054         if (plyrNames_[_pID][_name] == false)
1055             plyrNames_[_pID][_name] = true;
1056     }
1057 
1058     /**
1059      * @dev receives entire player name list
1060      */
1061     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1062     external
1063     {
1064         require (msg.sender == address(RatBook), "only RatBook can call this function");
1065         if(plyrNames_[_pID][_name] == false)
1066             plyrNames_[_pID][_name] = true;
1067     }
1068 
1069     /**
1070      * @dev gets existing or registers new pID.  use this when a player may be new
1071      * @return pID
1072      */
1073     function determinePID(RSdatasets.EventReturns memory _eventData_)
1074     private
1075     returns (RSdatasets.EventReturns)
1076     {
1077         uint256 _pID = pIDxAddr_[msg.sender];
1078         // if player is new to this version of ratscam
1079         if (_pID == 0)
1080         {
1081             // grab their player ID, name and last aff ID, from player names contract
1082             _pID = RatBook.getPlayerID(msg.sender);
1083             bytes32 _name = RatBook.getPlayerName(_pID);
1084             uint256 _laff = RatBook.getPlayerLAff(_pID);
1085 
1086             // set up player account
1087             pIDxAddr_[msg.sender] = _pID;
1088             plyr_[_pID].addr = msg.sender;
1089 
1090             if (_name != "")
1091             {
1092                 pIDxName_[_name] = _pID;
1093                 plyr_[_pID].name = _name;
1094                 plyrNames_[_pID][_name] = true;
1095             }
1096 
1097             if (_laff != 0 && _laff != _pID)
1098                 plyr_[_pID].laff = _laff;
1099 
1100             // set the new player bool to true
1101             _eventData_.compressedData = _eventData_.compressedData + 1;
1102         }
1103         return (_eventData_);
1104     }
1105 
1106     /**
1107      * @dev decides if round end needs to be run & new round started.  and if
1108      * player unmasked earnings from previously played rounds need to be moved.
1109      */
1110     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1111     private
1112     returns (RSdatasets.EventReturns)
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
1131     function endRound(RSdatasets.EventReturns memory _eventData_)
1132     private
1133     returns (RSdatasets.EventReturns)
1134     {
1135         // setup local rID
1136         uint256 _rID = rID_;
1137 
1138         // grab our winning player and team id's
1139         uint256 _winPID = round_[_rID].plyr;
1140 
1141         // grab our pot amount
1142         // add airdrop pot into the final pot
1143         uint256 _pot = round_[_rID].pot;
1144 
1145         // calculate our winner share, community rewards, gen share,
1146         // p3d share, and amount reserved for next pot
1147         uint256 _win = (_pot.mul(45)) / 100;
1148         uint256 _com = (_pot / 10);
1149         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1150 
1151         // calculate ppt for round mask
1152         uint256 _ppt = 0;
1153         if(round_[_rID].keys > 0)
1154         {
1155             _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1156         }
1157         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1158         
1159         if (_dust > 0)
1160         {
1161             _gen = _gen.sub(_dust);
1162             _com = _com.add(_dust);
1163         }
1164 
1165         // pay our winner
1166         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1167 
1168         // community rewards
1169         adminAddress.transfer(_com);
1170 
1171         // distribute gen portion to key holders
1172         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1173 
1174         // prepare event data
1175         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1176         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1177         _eventData_.winnerAddr = plyr_[_winPID].addr;
1178         _eventData_.winnerName = plyr_[_winPID].name;
1179         _eventData_.amountWon = _win;
1180         _eventData_.genAmount = _gen;
1181         _eventData_.newPot = 0;
1182 
1183         // start next round
1184         rID_++;
1185         _rID++;
1186         round_[_rID].strt = now;
1187         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1188         round_[_rID].pot = 0;
1189 
1190         return(_eventData_);
1191     }
1192 
1193     /**
1194      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1195      */
1196     function updateGenVault(uint256 _pID, uint256 _rID)
1197     private
1198     {
1199         uint256 _earnings = calcUnMaskedEarnings(_pID, _rID);
1200         if (_earnings > 0)
1201         {
1202             // put in gen vault
1203             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1204             // zero out their earnings by updating mask
1205             plyrRnds_[_pID][_rID].mask = _earnings.add(plyrRnds_[_pID][_rID].mask);
1206         }
1207     }
1208 
1209     /**
1210      * @dev updates round timer based on number of whole keys bought.
1211      */
1212     function updateTimer(uint256 _keys, uint256 _rID)
1213     private
1214     {
1215         // grab time
1216         uint256 _now = now;
1217 
1218         // calculate time based on number of keys bought
1219         uint256 _newTime;
1220         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1221             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1222         else
1223             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1224 
1225         // compare to max and set new end time
1226         if (_newTime < (rndMax_).add(_now))
1227             round_[_rID].end = _newTime;
1228         else
1229             round_[_rID].end = rndMax_.add(_now);
1230     }
1231 
1232     /**
1233      * @dev generates a random number between 0-99 and checks to see if thats
1234      * resulted in an airdrop win
1235      * @return do we have a winner?
1236      */
1237     function airdrop()
1238     private
1239     view
1240     returns(bool)
1241     {
1242         uint256 seed = uint256(keccak256(abi.encodePacked(
1243 
1244                 (block.timestamp).add
1245                 (block.difficulty).add
1246                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1247                 (block.gaslimit).add
1248                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1249                 (block.number)
1250 
1251             )));
1252         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1253             return(true);
1254         else
1255             return(false);
1256     }
1257 
1258     /**
1259      * @dev distributes eth based on fees to com, aff, and p3d
1260      */
1261     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1262     private
1263     returns(RSdatasets.EventReturns)
1264     {
1265         // pay 5% out to community rewards
1266         uint256 _com = _eth * 5 / 100;
1267 
1268         // distribute share to affiliate
1269         uint256 _aff = _eth / 10;
1270 
1271         // decide what to do with affiliate share of fees
1272         // affiliate must not be self, and must have a name registered
1273         if (_affID != _pID && plyr_[_affID].name != '') {
1274             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1275             emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1276         } else {
1277             // no affiliates, add to community
1278             _com += _aff;
1279         }
1280 
1281         // pay out team
1282         adminAddress.transfer(_com);
1283 
1284         return(_eventData_);
1285     }
1286 
1287     /**
1288      * @dev distributes eth based on fees to gen and pot
1289      */
1290     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1291     private
1292     returns(RSdatasets.EventReturns)
1293     {
1294         // calculate gen share
1295         uint256 _gen = (_eth.mul(fees_)) / 100;
1296 
1297         // toss 5% into airdrop pot
1298         uint256 _air = (_eth / 20);
1299         airDropPot_ = airDropPot_.add(_air);
1300 
1301         // calculate pot (20%)
1302         uint256 _pot = (_eth.mul(20) / 100);
1303 
1304         // distribute gen share (thats what updateMasks() does) and adjust
1305         // balances for dust.
1306         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1307         if (_dust > 0)
1308             _gen = _gen.sub(_dust);
1309 
1310         // add eth to pot
1311         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1312 
1313         // set up event data
1314         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1315         _eventData_.potAmount = _pot;
1316 
1317         return(_eventData_);
1318     }
1319 
1320     /**
1321      * @dev updates masks for round and player when keys are bought
1322      * @return dust left over
1323      */
1324     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1325     private
1326     returns(uint256)
1327     {
1328         /* MASKING NOTES
1329             earnings masks are a tricky thing for people to wrap their minds around.
1330             the basic thing to understand here.  is were going to have a global
1331             tracker based on profit per share for each round, that increases in
1332             relevant proportion to the increase in share supply.
1333 
1334             the player will have an additional mask that basically says "based
1335             on the rounds mask, my shares, and how much i've already withdrawn,
1336             how much is still owed to me?"
1337         */
1338 
1339         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1340         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1341         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1342 
1343         // calculate player earning from their own buy (only based on the keys
1344         // they just bought).  & update player earnings mask
1345         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1346         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1347 
1348         // calculate & return dust
1349         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1350     }
1351 
1352     /**
1353      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1354      * @return earnings in wei format
1355      */
1356     function withdrawEarnings(uint256 _pID)
1357     private
1358     returns(uint256)
1359     {
1360         // update gen vault
1361         updateGenVault(_pID, plyr_[_pID].lrnd);
1362 
1363         // from vaults
1364         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1365         if (_earnings > 0)
1366         {
1367             plyr_[_pID].win = 0;
1368             plyr_[_pID].gen = 0;
1369             plyr_[_pID].aff = 0;
1370         }
1371 
1372         return(_earnings);
1373     }
1374 
1375     /**
1376      * @dev prepares compression data and fires event for buy or reload tx's
1377      */
1378     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1379     private
1380     {
1381         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1382         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1383 
1384         emit RSEvents.onEndTx
1385         (
1386             _eventData_.compressedData,
1387             _eventData_.compressedIDs,
1388             plyr_[_pID].name,
1389             msg.sender,
1390             _eth,
1391             _keys,
1392             _eventData_.winnerAddr,
1393             _eventData_.winnerName,
1394             _eventData_.amountWon,
1395             _eventData_.newPot,
1396             _eventData_.genAmount,
1397             _eventData_.potAmount,
1398             airDropPot_
1399         );
1400     }
1401 
1402     /** upon contract deploy, it will be deactivated.  this is a one time
1403      * use function that will activate the contract.  we do this so devs
1404      * have time to set things up on the web end                            **/
1405     bool public activated_ = false;
1406     function activate()
1407     public
1408     {
1409         // only owner can activate
1410         require(
1411             msg.sender == adminAddress,
1412             "only owner can activate"
1413         );
1414 
1415         // can only be ran once
1416         require(activated_ == false, "ratscam already activated");
1417 
1418         // activate the contract
1419         activated_ = true;
1420 
1421         // lets start first round
1422         rID_ = 1;
1423         round_[1].strt = now - rndGap_;
1424         round_[1].end = now + rndInit_;
1425     }
1426 
1427     function setNextRndTime(uint32 rndInit, uint32 rndInc, uint32 rndMax)
1428     public
1429     {
1430         // only owner
1431         require(msg.sender == adminAddress, "only owner can setNextRndTime");
1432 
1433         rndInit_ = rndInit * 1 hours;
1434         rndInc_ = rndInc * 1 seconds;
1435         rndMax_ = rndMax * 1 hours;
1436     }
1437 }
1438 
1439 //==============================================================================
1440 //   __|_ _    __|_ _  .
1441 //  _\ | | |_|(_ | _\  .
1442 //==============================================================================
1443 library RSdatasets {
1444     //compressedData key
1445     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1446     // 0 - new player (bool)
1447     // 1 - joined round (bool)
1448     // 2 - new  leader (bool)
1449     // 3-5 - air drop tracker (uint 0-999)
1450     // 6-16 - round end time
1451     // 17 - winnerTeam
1452     // 18 - 28 timestamp
1453     // 29 - team
1454     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1455     // 31 - airdrop happened bool
1456     // 32 - airdrop tier
1457     // 33 - airdrop amount won
1458     //compressedIDs key
1459     // [77-52][51-26][25-0]
1460     // 0-25 - pID
1461     // 26-51 - winPID
1462     // 52-77 - rID
1463     struct EventReturns {
1464         uint256 compressedData;
1465         uint256 compressedIDs;
1466         address winnerAddr;         // winner address
1467         bytes32 winnerName;         // winner name
1468         uint256 amountWon;          // amount won
1469         uint256 newPot;             // amount in new pot
1470         uint256 genAmount;          // amount distributed to gen
1471         uint256 potAmount;          // amount added to pot
1472     }
1473     struct Player {
1474         address addr;   // player address
1475         bytes32 name;   // player name
1476         uint256 win;    // winnings vault
1477         uint256 gen;    // general vault
1478         uint256 aff;    // affiliate vault
1479         uint256 laff;   // last affiliate id used
1480         uint256 lrnd;   // last round played
1481     }
1482     struct PlayerRounds {
1483         uint256 eth;    // eth player has added to round (used for eth limiter)
1484         uint256 keys;   // keys
1485         uint256 mask;   // player mask
1486     }
1487     struct Round {
1488         uint256 plyr;   // pID of player in lead
1489         uint256 end;    // time ends/ended
1490         bool ended;     // has round end function been ran
1491         uint256 strt;   // time round started
1492         uint256 keys;   // keys
1493         uint256 eth;    // total eth in
1494         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1495         uint256 mask;   // global mask
1496     }
1497 }
1498 
1499 //==============================================================================
1500 //  |  _      _ _ | _  .
1501 //  |<(/_\/  (_(_||(_  .
1502 //=======/======================================================================
1503 library RSKeysCalc {
1504     using SafeMath for *;
1505     /**
1506      * @dev calculates number of keys received given X eth
1507      * @param _curEth current amount of eth in contract
1508      * @param _newEth eth being spent
1509      * @return amount of ticket purchased
1510      */
1511     function keysRec(uint256 _curEth, uint256 _newEth)
1512     internal
1513     pure
1514     returns (uint256)
1515     {
1516         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1517     }
1518 
1519     /**
1520      * @dev calculates amount of eth received if you sold X keys
1521      * @param _curKeys current amount of keys that exist
1522      * @param _sellKeys amount of keys you wish to sell
1523      * @return amount of eth received
1524      */
1525     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1526     internal
1527     pure
1528     returns (uint256)
1529     {
1530         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1531     }
1532 
1533     /**
1534      * @dev calculates how many keys would exist with given an amount of eth
1535      * @param _eth eth "in contract"
1536      * @return number of keys that would exist
1537      */
1538     function keys(uint256 _eth)
1539     internal
1540     pure
1541     returns(uint256)
1542     {
1543         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1544     }
1545 
1546     /**
1547      * @dev calculates how much eth would be in contract given a number of keys
1548      * @param _keys number of keys "in contract"
1549      * @return eth that would exists
1550      */
1551     function eth(uint256 _keys)
1552     internal
1553     pure
1554     returns(uint256)
1555     {
1556         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1557     }
1558 }
1559 
1560 //interface RatInterfaceForForwarder {
1561 //    function deposit() external payable returns(bool);
1562 //}
1563 
1564 interface RatBookInterface {
1565     function getPlayerID(address _addr) external returns (uint256);
1566     function getPlayerName(uint256 _pID) external view returns (bytes32);
1567     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1568     function getPlayerAddr(uint256 _pID) external view returns (address);
1569     function getNameFee() external view returns (uint256);
1570     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1571     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1572     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1573 }
1574 
1575 library NameFilter {
1576     /**
1577      * @dev filters name strings
1578      * -converts uppercase to lower case.
1579      * -makes sure it does not start/end with a space
1580      * -makes sure it does not contain multiple spaces in a row
1581      * -cannot be only numbers
1582      * -cannot start with 0x
1583      * -restricts characters to A-Z, a-z, 0-9, and space.
1584      * @return reprocessed string in bytes32 format
1585      */
1586     function nameFilter(string _input)
1587     internal
1588     pure
1589     returns(bytes32)
1590     {
1591         bytes memory _temp = bytes(_input);
1592         uint256 _length = _temp.length;
1593 
1594         //sorry limited to 32 characters
1595         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1596         // make sure it doesnt start with or end with space
1597         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1598         // make sure first two characters are not 0x
1599         if (_temp[0] == 0x30)
1600         {
1601             require(_temp[1] != 0x78, "string cannot start with 0x");
1602             require(_temp[1] != 0x58, "string cannot start with 0X");
1603         }
1604 
1605         // create a bool to track if we have a non number character
1606         bool _hasNonNumber;
1607 
1608         // convert & check
1609         for (uint256 i = 0; i < _length; i++)
1610         {
1611             // if its uppercase A-Z
1612             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1613             {
1614                 // convert to lower case a-z
1615                 _temp[i] = byte(uint(_temp[i]) + 32);
1616 
1617                 // we have a non number
1618                 if (_hasNonNumber == false)
1619                     _hasNonNumber = true;
1620             } else {
1621                 require
1622                 (
1623                 // require character is a space
1624                     _temp[i] == 0x20 ||
1625                 // OR lowercase a-z
1626                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1627                 // or 0-9
1628                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1629                     "string contains invalid characters"
1630                 );
1631                 // make sure theres not 2x spaces in a row
1632                 if (_temp[i] == 0x20)
1633                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1634 
1635                 // see if we have a character other than a number
1636                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1637                     _hasNonNumber = true;
1638             }
1639         }
1640 
1641         require(_hasNonNumber == true, "string cannot be only numbers");
1642 
1643         bytes32 _ret;
1644         assembly {
1645             _ret := mload(add(_temp, 32))
1646         }
1647         return (_ret);
1648     }
1649 }
1650 
1651 /**
1652  * @title SafeMath v0.1.9
1653  * @dev Math operations with safety checks that throw on error
1654  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1655  * - added sqrt
1656  * - added sq
1657  * - changed asserts to requires with error log outputs
1658  * - removed div, its useless
1659  */
1660 library SafeMath {
1661 
1662     /**
1663     * @dev Multiplies two numbers, throws on overflow.
1664     */
1665     function mul(uint256 a, uint256 b)
1666     internal
1667     pure
1668     returns (uint256 c)
1669     {
1670         if (a == 0) {
1671             return 0;
1672         }
1673         c = a * b;
1674         require(c / a == b, "SafeMath mul failed");
1675         return c;
1676     }
1677 
1678     /**
1679     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1680     */
1681     function sub(uint256 a, uint256 b)
1682     internal
1683     pure
1684     returns (uint256)
1685     {
1686         require(b <= a, "SafeMath sub failed");
1687         return a - b;
1688     }
1689 
1690     /**
1691     * @dev Adds two numbers, throws on overflow.
1692     */
1693     function add(uint256 a, uint256 b)
1694     internal
1695     pure
1696     returns (uint256 c)
1697     {
1698         c = a + b;
1699         require(c >= a, "SafeMath add failed");
1700         return c;
1701     }
1702 
1703     /**
1704      * @dev gives square root of given x.
1705      */
1706     function sqrt(uint256 x)
1707     internal
1708     pure
1709     returns (uint256 y)
1710     {
1711         uint256 z = ((add(x,1)) / 2);
1712         y = x;
1713         while (z < y)
1714         {
1715             y = z;
1716             z = ((add((x / z),z)) / 2);
1717         }
1718     }
1719 
1720     /**
1721      * @dev gives square. multiplies x by x
1722      */
1723     function sq(uint256 x)
1724     internal
1725     pure
1726     returns (uint256)
1727     {
1728         return (mul(x,x));
1729     }
1730 }