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
112     // TODO: check address
113     address constant private adminAddress = 0xFAdb9139a33a4F2FE67D340B6AAef0d04E9D5681;
114     RatBookInterface constant private RatBook = RatBookInterface(0x3257d637b8977781b4f8178365858a474b2a6195);
115 
116     string constant public name = "RatScam In One Hour";
117     string constant public symbol = "RS";
118     uint256 private rndGap_ = 0;
119 
120     // TODO: check time
121     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
122     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
123     uint256 constant private rndMax_ = 1 hours;                // max length a round timer can be
124     //==============================================================================
125     //     _| _ _|_ _    _ _ _|_    _   .
126     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
127     //=============================|================================================
128     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
129     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
130     uint256 public rID_;    // round id number / total rounds that have happened
131     //****************
132     // PLAYER DATA
133     //****************
134     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
135     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
136     mapping (uint256 => RSdatasets.Player) public plyr_;   // (pID => data) player data
137     mapping (uint256 => mapping (uint256 => RSdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
138     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
139     //****************
140     // ROUND DATA
141     //****************
142     //RSdatasets.Round public round_;   // round data
143     mapping (uint256 => RSdatasets.Round) public round_;   // (rID => data) round data
144     //****************
145     // TEAM FEE DATA
146     //****************
147     uint256 public fees_ = 60;          // fee distribution
148     uint256 public potSplit_ = 45;     // pot split distribution
149     //==============================================================================
150     //     _ _  _  __|_ _    __|_ _  _  .
151     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
152     //==============================================================================
153     constructor()
154     public
155     {
156     }
157     //==============================================================================
158     //     _ _  _  _|. |`. _  _ _  .
159     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
160     //==============================================================================
161     /**
162      * @dev used to make sure no one can interact with contract until it has
163      * been activated.
164      */
165     modifier isActivated() {
166         require(activated_ == true, "its not ready yet");
167         _;
168     }
169 
170     /**
171      * @dev prevents contracts from interacting with ratscam
172      */
173     modifier isHuman() {
174         address _addr = msg.sender;
175         uint256 _codeLength;
176 
177         assembly {_codeLength := extcodesize(_addr)}
178         require(_codeLength == 0, "non smart contract address only");
179         _;
180     }
181 
182     /**
183      * @dev sets boundaries for incoming tx
184      */
185     modifier isWithinLimits(uint256 _eth) {
186         require(_eth >= 1000000000, "too little money");
187         require(_eth <= 100000000000000000000000, "too much money");
188         _;
189     }
190 
191     //==============================================================================
192     //     _    |_ |. _   |`    _  __|_. _  _  _  .
193     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
194     //====|=========================================================================
195     /**
196      * @dev emergency buy uses last stored affiliate ID and team snek
197      */
198     function()
199     isActivated()
200     isHuman()
201     isWithinLimits(msg.value)
202     public
203     payable
204     {
205         // set up our tx event data and determine if player is new or not
206         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
207 
208         // fetch player id
209         uint256 _pID = pIDxAddr_[msg.sender];
210 
211         // buy core
212         buyCore(_pID, plyr_[_pID].laff, _eventData_);
213     }
214 
215     /**
216      * @dev converts all incoming ethereum to keys.
217      * -functionhash- 0x8f38f309 (using ID for affiliate)
218      * -functionhash- 0x98a0871d (using address for affiliate)
219      * -functionhash- 0xa65b37a1 (using name for affiliate)
220      * @param _affCode the ID/address/name of the player who gets the affiliate fee
221      */
222     function buyXid(uint256 _affCode)
223     isActivated()
224     isHuman()
225     isWithinLimits(msg.value)
226     public
227     payable
228     {
229         // set up our tx event data and determine if player is new or not
230         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
231 
232         // fetch player id
233         uint256 _pID = pIDxAddr_[msg.sender];
234 
235         // manage affiliate residuals
236         // if no affiliate code was given or player tried to use their own, lolz
237         if (_affCode == 0 || _affCode == _pID)
238         {
239             // use last stored affiliate code
240             _affCode = plyr_[_pID].laff;
241 
242             // if affiliate code was given & its not the same as previously stored
243         } else if (_affCode != plyr_[_pID].laff) {
244             // update last affiliate
245             plyr_[_pID].laff = _affCode;
246         }
247 
248         // buy core
249         buyCore(_pID, _affCode, _eventData_);
250     }
251 
252     function buyXaddr(address _affCode)
253     isActivated()
254     isHuman()
255     isWithinLimits(msg.value)
256     public
257     payable
258     {
259         // set up our tx event data and determine if player is new or not
260         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
261 
262         // fetch player id
263         uint256 _pID = pIDxAddr_[msg.sender];
264 
265         // manage affiliate residuals
266         uint256 _affID;
267         // if no affiliate code was given or player tried to use their own, lolz
268         if (_affCode == address(0) || _affCode == msg.sender)
269         {
270             // use last stored affiliate code
271             _affID = plyr_[_pID].laff;
272 
273             // if affiliate code was given
274         } else {
275             // get affiliate ID from aff Code
276             _affID = pIDxAddr_[_affCode];
277 
278             // if affID is not the same as previously stored
279             if (_affID != plyr_[_pID].laff)
280             {
281                 // update last affiliate
282                 plyr_[_pID].laff = _affID;
283             }
284         }
285 
286         // buy core
287         buyCore(_pID, _affID, _eventData_);
288     }
289 
290     function buyXname(bytes32 _affCode)
291     isActivated()
292     isHuman()
293     isWithinLimits(msg.value)
294     public
295     payable
296     {
297         // set up our tx event data and determine if player is new or not
298         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
299 
300         // fetch player id
301         uint256 _pID = pIDxAddr_[msg.sender];
302 
303         // manage affiliate residuals
304         uint256 _affID;
305         // if no affiliate code was given or player tried to use their own, lolz
306         if (_affCode == '' || _affCode == plyr_[_pID].name)
307         {
308             // use last stored affiliate code
309             _affID = plyr_[_pID].laff;
310 
311             // if affiliate code was given
312         } else {
313             // get affiliate ID from aff Code
314             _affID = pIDxName_[_affCode];
315 
316             // if affID is not the same as previously stored
317             if (_affID != plyr_[_pID].laff)
318             {
319                 // update last affiliate
320                 plyr_[_pID].laff = _affID;
321             }
322         }
323 
324         // buy core
325         buyCore(_pID, _affID, _eventData_);
326     }
327 
328     /**
329      * @dev essentially the same as buy, but instead of you sending ether
330      * from your wallet, it uses your unwithdrawn earnings.
331      * -functionhash- 0x349cdcac (using ID for affiliate)
332      * -functionhash- 0x82bfc739 (using address for affiliate)
333      * -functionhash- 0x079ce327 (using name for affiliate)
334      * @param _affCode the ID/address/name of the player who gets the affiliate fee
335      * @param _eth amount of earnings to use (remainder returned to gen vault)
336      */
337     function reLoadXid(uint256 _affCode, uint256 _eth)
338     isActivated()
339     isHuman()
340     isWithinLimits(_eth)
341     public
342     {
343         // set up our tx event data
344         RSdatasets.EventReturns memory _eventData_;
345 
346         // fetch player ID
347         uint256 _pID = pIDxAddr_[msg.sender];
348 
349         // manage affiliate residuals
350         // if no affiliate code was given or player tried to use their own, lolz
351         if (_affCode == 0 || _affCode == _pID)
352         {
353             // use last stored affiliate code
354             _affCode = plyr_[_pID].laff;
355 
356             // if affiliate code was given & its not the same as previously stored
357         } else if (_affCode != plyr_[_pID].laff) {
358             // update last affiliate
359             plyr_[_pID].laff = _affCode;
360         }
361 
362         // reload core
363         reLoadCore(_pID, _affCode, _eth, _eventData_);
364     }
365 
366     function reLoadXaddr(address _affCode, uint256 _eth)
367     isActivated()
368     isHuman()
369     isWithinLimits(_eth)
370     public
371     {
372         // set up our tx event data
373         RSdatasets.EventReturns memory _eventData_;
374 
375         // fetch player ID
376         uint256 _pID = pIDxAddr_[msg.sender];
377 
378         // manage affiliate residuals
379         uint256 _affID;
380         // if no affiliate code was given or player tried to use their own, lolz
381         if (_affCode == address(0) || _affCode == msg.sender)
382         {
383             // use last stored affiliate code
384             _affID = plyr_[_pID].laff;
385 
386             // if affiliate code was given
387         } else {
388             // get affiliate ID from aff Code
389             _affID = pIDxAddr_[_affCode];
390 
391             // if affID is not the same as previously stored
392             if (_affID != plyr_[_pID].laff)
393             {
394                 // update last affiliate
395                 plyr_[_pID].laff = _affID;
396             }
397         }
398 
399         // reload core
400         reLoadCore(_pID, _affID, _eth, _eventData_);
401     }
402 
403     function reLoadXname(bytes32 _affCode, uint256 _eth)
404     isActivated()
405     isHuman()
406     isWithinLimits(_eth)
407     public
408     {
409         // set up our tx event data
410         RSdatasets.EventReturns memory _eventData_;
411 
412         // fetch player ID
413         uint256 _pID = pIDxAddr_[msg.sender];
414 
415         // manage affiliate residuals
416         uint256 _affID;
417         // if no affiliate code was given or player tried to use their own, lolz
418         if (_affCode == '' || _affCode == plyr_[_pID].name)
419         {
420             // use last stored affiliate code
421             _affID = plyr_[_pID].laff;
422 
423             // if affiliate code was given
424         } else {
425             // get affiliate ID from aff Code
426             _affID = pIDxName_[_affCode];
427 
428             // if affID is not the same as previously stored
429             if (_affID != plyr_[_pID].laff)
430             {
431                 // update last affiliate
432                 plyr_[_pID].laff = _affID;
433             }
434         }
435 
436         // reload core
437         reLoadCore(_pID, _affID, _eth, _eventData_);
438     }
439 
440     /**
441      * @dev withdraws all of your earnings.
442      * -functionhash- 0x3ccfd60b
443      */
444     function withdraw()
445     isActivated()
446     isHuman()
447     public
448     {
449         // setup local rID
450         uint256 _rID = rID_;
451 
452         // grab time
453         uint256 _now = now;
454 
455         // fetch player ID
456         uint256 _pID = pIDxAddr_[msg.sender];
457 
458         // setup temp var for player eth
459         uint256 _eth;
460 
461         // check to see if round has ended and no one has run round end yet
462         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
463         {
464             // set up our tx event data
465             RSdatasets.EventReturns memory _eventData_;
466 
467             // end the round (distributes pot)
468             round_[_rID].ended = true;
469             _eventData_ = endRound(_eventData_);
470 
471             // get their earnings
472             _eth = withdrawEarnings(_pID);
473 
474             // gib moni
475             if (_eth > 0)
476                 plyr_[_pID].addr.transfer(_eth);
477 
478             // build event data
479             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
480             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
481 
482             // fire withdraw and distribute event
483             emit RSEvents.onWithdrawAndDistribute
484             (
485                 msg.sender,
486                 plyr_[_pID].name,
487                 _eth,
488                 _eventData_.compressedData,
489                 _eventData_.compressedIDs,
490                 _eventData_.winnerAddr,
491                 _eventData_.winnerName,
492                 _eventData_.amountWon,
493                 _eventData_.newPot,
494                 _eventData_.genAmount
495             );
496 
497             // in any other situation
498         } else {
499             // get their earnings
500             _eth = withdrawEarnings(_pID);
501 
502             // gib moni
503             if (_eth > 0)
504                 plyr_[_pID].addr.transfer(_eth);
505 
506             // fire withdraw event
507             emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
508         }
509     }
510 
511     /**
512      * @dev use these to register names.  they are just wrappers that will send the
513      * registration requests to the PlayerBook contract.  So registering here is the
514      * same as registering there.  UI will always display the last name you registered.
515      * but you will still own all previously registered names to use as affiliate
516      * links.
517      * - must pay a registration fee.
518      * - name must be unique
519      * - names will be converted to lowercase
520      * - name cannot start or end with a space
521      * - cannot have more than 1 space in a row
522      * - cannot be only numbers
523      * - cannot start with 0x
524      * - name must be at least 1 char
525      * - max length of 32 characters long
526      * - allowed characters: a-z, 0-9, and space
527      * -functionhash- 0x921dec21 (using ID for affiliate)
528      * -functionhash- 0x3ddd4698 (using address for affiliate)
529      * -functionhash- 0x685ffd83 (using name for affiliate)
530      * @param _nameString players desired name
531      * @param _affCode affiliate ID, address, or name of who referred you
532      * @param _all set to true if you want this to push your info to all games
533      * (this might cost a lot of gas)
534      */
535     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
536     isHuman()
537     public
538     payable
539     {
540         bytes32 _name = _nameString.nameFilter();
541         address _addr = msg.sender;
542         uint256 _paid = msg.value;
543         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
544 
545         uint256 _pID = pIDxAddr_[_addr];
546 
547         // fire event
548         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
549     }
550 
551     function registerNameXaddr(string _nameString, address _affCode, bool _all)
552     isHuman()
553     public
554     payable
555     {
556         bytes32 _name = _nameString.nameFilter();
557         address _addr = msg.sender;
558         uint256 _paid = msg.value;
559         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
560 
561         uint256 _pID = pIDxAddr_[_addr];
562 
563         // fire event
564         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
565     }
566 
567     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
568     isHuman()
569     public
570     payable
571     {
572         bytes32 _name = _nameString.nameFilter();
573         address _addr = msg.sender;
574         uint256 _paid = msg.value;
575         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
576 
577         uint256 _pID = pIDxAddr_[_addr];
578 
579         // fire event
580         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
581     }
582     //==============================================================================
583     //     _  _ _|__|_ _  _ _  .
584     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
585     //=====_|=======================================================================
586     /**
587      * @dev return the price buyer will pay for next 1 individual key.
588      * -functionhash- 0x018a25e8
589      * @return price for next key bought (in wei format)
590      */
591     function getBuyPrice()
592     public
593     view
594     returns(uint256)
595     {
596         // setup local rID
597         uint256 _rID = rID_;
598 
599         // grab time
600         uint256 _now = now;
601 
602         // are we in a round?
603         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
604             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
605         else // rounds over.  need price for new round
606             return ( 75000000000000 ); // init
607     }
608 
609     /**
610      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
611      * provider
612      * -functionhash- 0xc7e284b8
613      * @return time left in seconds
614      */
615     function getTimeLeft()
616     public
617     view
618     returns(uint256)
619     {
620         // setup local rID
621         uint256 _rID = rID_;
622 
623         // grab time
624         uint256 _now = now;
625 
626         if (_now < round_[_rID].end)
627             if (_now > round_[_rID].strt + rndGap_)
628                 return( (round_[_rID].end).sub(_now) );
629             else
630                 return( (round_[_rID].strt + rndGap_).sub(_now));
631         else
632             return(0);
633     }
634 
635     /**
636      * @dev returns player earnings per vaults
637      * -functionhash- 0x63066434
638      * @return winnings vault
639      * @return general vault
640      * @return affiliate vault
641      */
642     function getPlayerVaults(uint256 _pID)
643     public
644     view
645     returns(uint256 ,uint256, uint256)
646     {
647         // setup local rID
648         uint256 _rID = rID_;
649 
650         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
651         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
652         {
653             // if player is winner
654             if (round_[_rID].plyr == _pID)
655             {
656                 return
657                 (
658                 (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
659                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
660                 plyr_[_pID].aff
661                 );
662                 // if player is not the winner
663             } else {
664                 return
665                 (
666                 plyr_[_pID].win,
667                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
668                 plyr_[_pID].aff
669                 );
670             }
671 
672             // if round is still going on, or round has ended and round end has been ran
673         } else {
674             return
675             (
676             plyr_[_pID].win,
677             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
678             plyr_[_pID].aff
679             );
680         }
681     }
682 
683     /**
684      * solidity hates stack limits.  this lets us avoid that hate
685      */
686     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
687     private
688     view
689     returns(uint256)
690     {
691         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
692     }
693 
694     /**
695      * @dev returns all current round info needed for front end
696      * -functionhash- 0x747dff42
697      * @return total keys
698      * @return time ends
699      * @return time started
700      * @return current pot
701      * @return current player ID in lead
702      * @return current player in leads address
703      * @return current player in leads name
704      * @return airdrop tracker # & airdrop pot
705      */
706     function getCurrentRoundInfo()
707     public
708     view
709     returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
710     {
711         // setup local rID
712         uint256 _rID = rID_;
713 
714         return
715         (
716         round_[rID_].keys,              //0
717         round_[rID_].end,               //1
718         round_[rID_].strt,              //2
719         round_[rID_].pot,               //3
720         round_[rID_].plyr,              //4
721         plyr_[round_[rID_].plyr].addr,  //5
722         plyr_[round_[rID_].plyr].name,  //6
723         airDropTracker_ + (airDropPot_ * 1000)              //7
724         );
725     }
726 
727     /**
728      * @dev returns player info based on address.  if no address is given, it will
729      * use msg.sender
730      * -functionhash- 0xee0b5d8b
731      * @param _addr address of the player you want to lookup
732      * @return player ID
733      * @return player name
734      * @return keys owned (current round)
735      * @return winnings vault
736      * @return general vault
737      * @return affiliate vault
738 	 * @return player round eth
739      */
740     function getPlayerInfoByAddress(address _addr)
741     public
742     view
743     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
744     {
745         // setup local rID
746         uint256 _rID = rID_;
747 
748         if (_addr == address(0))
749         {
750             _addr == msg.sender;
751         }
752         uint256 _pID = pIDxAddr_[_addr];
753 
754         return
755         (
756         _pID,                               //0
757         plyr_[_pID].name,                   //1
758         plyrRnds_[_pID][_rID].keys,         //2
759         plyr_[_pID].win,                    //3
760         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
761         plyr_[_pID].aff,                    //5
762         plyrRnds_[_pID][_rID].eth           //6
763         );
764     }
765 
766     //==============================================================================
767     //     _ _  _ _   | _  _ . _  .
768     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
769     //=====================_|=======================================================
770     /**
771      * @dev logic runs whenever a buy order is executed.  determines how to handle
772      * incoming eth depending on if we are in an active round or not
773      */
774     function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
775     private
776     {
777         // setup local rID
778         uint256 _rID = rID_;
779 
780         // grab time
781         uint256 _now = now;
782 
783         // if round is active
784         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
785         {
786             // call core
787             core(_rID, _pID, msg.value, _affID, _eventData_);
788 
789             // if round is not active
790         } else {
791             // check to see if end round needs to be ran
792             if (_now > round_[_rID].end && round_[_rID].ended == false)
793             {
794                 // end the round (distributes pot) & start new round
795                 round_[_rID].ended = true;
796                 _eventData_ = endRound(_eventData_);
797 
798                 // build event data
799                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
800                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
801 
802                 // fire buy and distribute event
803                 emit RSEvents.onBuyAndDistribute
804                 (
805                     msg.sender,
806                     plyr_[_pID].name,
807                     msg.value,
808                     _eventData_.compressedData,
809                     _eventData_.compressedIDs,
810                     _eventData_.winnerAddr,
811                     _eventData_.winnerName,
812                     _eventData_.amountWon,
813                     _eventData_.newPot,
814                     _eventData_.genAmount
815                 );
816             }
817 
818             // put eth in players vault
819             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
820         }
821     }
822 
823     /**
824      * @dev logic runs whenever a reload order is executed.  determines how to handle
825      * incoming eth depending on if we are in an active round or not
826      */
827     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, RSdatasets.EventReturns memory _eventData_)
828     private
829     {
830         // setup local rID
831         uint256 _rID = rID_;
832 
833         // grab time
834         uint256 _now = now;
835 
836         // if round is active
837         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
838         {
839             // get earnings from all vaults and return unused to gen vault
840             // because we use a custom safemath library.  this will throw if player
841             // tried to spend more eth than they have.
842             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
843 
844             // call core
845             core( _rID, _pID, _eth, _affID, _eventData_);
846 
847             // if round is not active and end round needs to be ran
848         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
849             // end the round (distributes pot) & start new round
850             round_[_rID].ended = true;
851             _eventData_ = endRound(_eventData_);
852 
853             // build event data
854             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
855             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
856 
857             // fire buy and distribute event
858             emit RSEvents.onReLoadAndDistribute
859             (
860                 msg.sender,
861                 plyr_[_pID].name,
862                 _eventData_.compressedData,
863                 _eventData_.compressedIDs,
864                 _eventData_.winnerAddr,
865                 _eventData_.winnerName,
866                 _eventData_.amountWon,
867                 _eventData_.newPot,
868                 _eventData_.genAmount
869             );
870         }
871     }
872 
873     /**
874      * @dev this is the core logic for any buy/reload that happens while a round
875      * is live.
876      */
877     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
878     private
879     {
880         // if player is new to round
881         if (plyrRnds_[_pID][_rID].keys == 0)
882             _eventData_ = managePlayer(_pID, _eventData_);
883 
884         // early round eth limiter
885         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 10000000000000000000)
886         {
887             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
888             uint256 _refund = _eth.sub(_availableLimit);
889             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
890             _eth = _availableLimit;
891         }
892 
893         // if eth left is greater than min eth allowed (sorry no pocket lint)
894         if (_eth > 1000000000)
895         {
896 
897             // mint the new keys
898             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
899 
900             // if they bought at least 1 whole key
901             if (_keys >= 1000000000000000000)
902             {
903                 updateTimer(_keys, _rID);
904 
905                 // set new leaders
906                 if (round_[_rID].plyr != _pID)
907                     round_[_rID].plyr = _pID;
908 
909                 // set the new leader bool to true
910                 _eventData_.compressedData = _eventData_.compressedData + 100;
911             }
912 
913             // manage airdrops
914             if (_eth >= 100000000000000000)
915             {
916                 airDropTracker_++;
917                 if (airdrop() == true)
918                 {
919                     // gib muni
920                     uint256 _prize;
921                     if (_eth >= 10000000000000000000)
922                     {
923                         // calculate prize and give it to winner
924                         _prize = ((airDropPot_).mul(75)) / 100;
925                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
926 
927                         // adjust airDropPot
928                         airDropPot_ = (airDropPot_).sub(_prize);
929 
930                         // let event know a tier 3 prize was won
931                         _eventData_.compressedData += 300000000000000000000000000000000;
932                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
933                         // calculate prize and give it to winner
934                         _prize = ((airDropPot_).mul(50)) / 100;
935                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
936 
937                         // adjust airDropPot
938                         airDropPot_ = (airDropPot_).sub(_prize);
939 
940                         // let event know a tier 2 prize was won
941                         _eventData_.compressedData += 200000000000000000000000000000000;
942                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
943                         // calculate prize and give it to winner
944                         _prize = ((airDropPot_).mul(25)) / 100;
945                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
946 
947                         // adjust airDropPot
948                         airDropPot_ = (airDropPot_).sub(_prize);
949 
950                         // let event know a tier 1 prize was won
951                         _eventData_.compressedData += 100000000000000000000000000000000;
952                     }
953                     // set airdrop happened bool to true
954                     _eventData_.compressedData += 10000000000000000000000000000000;
955                     // let event know how much was won
956                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
957 
958                     // reset air drop tracker
959                     airDropTracker_ = 0;
960                 }
961             }
962 
963             // store the air drop tracker number (number of buys since last airdrop)
964             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
965 
966             // update player
967             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
968             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
969 
970             // update round
971             round_[_rID].keys = _keys.add(round_[_rID].keys);
972             round_[_rID].eth = _eth.add(round_[_rID].eth);
973 
974             // distribute eth
975             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
976             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
977 
978             // call end tx function to fire end tx event.
979             endTx(_pID, _eth, _keys, _eventData_);
980         }
981     }
982     //==============================================================================
983     //     _ _ | _   | _ _|_ _  _ _  .
984     //    (_(_||(_|_||(_| | (_)| _\  .
985     //==============================================================================
986     /**
987      * @dev calculates unmasked earnings (just calculates, does not update mask)
988      * @return earnings in wei format
989      */
990     function calcUnMaskedEarnings(uint256 _pID, uint256 _rID)
991     private
992     view
993     returns(uint256)
994     {
995         return((((round_[_rID].mask).mul(plyrRnds_[_pID][_rID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rID].mask));
996     }
997 
998     /**
999      * @dev returns the amount of keys you would get given an amount of eth.
1000      * -functionhash- 0xce89c80c
1001      * @param _eth amount of eth sent in
1002      * @return keys received
1003      */
1004     function calcKeysReceived(uint256 _eth)
1005     public
1006     view
1007     returns(uint256)
1008     {
1009         uint256 _rID = rID_;
1010 
1011         // grab time
1012         uint256 _now = now;
1013 
1014         // are we in a round?
1015         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1016             return ( (round_[_rID].eth).keysRec(_eth) );
1017         else // rounds over.  need keys for new round
1018             return ( (_eth).keys() );
1019     }
1020 
1021     /**
1022      * @dev returns current eth price for X keys.
1023      * -functionhash- 0xcf808000
1024      * @param _keys number of keys desired (in 18 decimal format)
1025      * @return amount of eth needed to send
1026      */
1027     function iWantXKeys(uint256 _keys)
1028     public
1029     view
1030     returns(uint256)
1031     {
1032         // setup local rID
1033         uint256 _rID = rID_;
1034 
1035         // grab time
1036         uint256 _now = now;
1037 
1038         // are we in a round?
1039         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1040             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1041         else // rounds over.  need price for new round
1042             return ( (_keys).eth() );
1043     }
1044     //==============================================================================
1045     //    _|_ _  _ | _  .
1046     //     | (_)(_)|_\  .
1047     //==============================================================================
1048     /**
1049 	 * @dev receives name/player info from names contract
1050      */
1051     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1052     external
1053     {
1054         require (msg.sender == address(RatBook), "only RatBook can call this function");
1055         if (pIDxAddr_[_addr] != _pID)
1056             pIDxAddr_[_addr] = _pID;
1057         if (pIDxName_[_name] != _pID)
1058             pIDxName_[_name] = _pID;
1059         if (plyr_[_pID].addr != _addr)
1060             plyr_[_pID].addr = _addr;
1061         if (plyr_[_pID].name != _name)
1062             plyr_[_pID].name = _name;
1063         if (plyr_[_pID].laff != _laff)
1064             plyr_[_pID].laff = _laff;
1065         if (plyrNames_[_pID][_name] == false)
1066             plyrNames_[_pID][_name] = true;
1067     }
1068 
1069     /**
1070      * @dev receives entire player name list
1071      */
1072     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1073     external
1074     {
1075         require (msg.sender == address(RatBook), "only RatBook can call this function");
1076         if(plyrNames_[_pID][_name] == false)
1077             plyrNames_[_pID][_name] = true;
1078     }
1079 
1080     /**
1081      * @dev gets existing or registers new pID.  use this when a player may be new
1082      * @return pID
1083      */
1084     function determinePID(RSdatasets.EventReturns memory _eventData_)
1085     private
1086     returns (RSdatasets.EventReturns)
1087     {
1088         uint256 _pID = pIDxAddr_[msg.sender];
1089         // if player is new to this version of ratscam
1090         if (_pID == 0)
1091         {
1092             // grab their player ID, name and last aff ID, from player names contract
1093             _pID = RatBook.getPlayerID(msg.sender);
1094             bytes32 _name = RatBook.getPlayerName(_pID);
1095             uint256 _laff = RatBook.getPlayerLAff(_pID);
1096 
1097             // set up player account
1098             pIDxAddr_[msg.sender] = _pID;
1099             plyr_[_pID].addr = msg.sender;
1100 
1101             if (_name != "")
1102             {
1103                 pIDxName_[_name] = _pID;
1104                 plyr_[_pID].name = _name;
1105                 plyrNames_[_pID][_name] = true;
1106             }
1107 
1108             if (_laff != 0 && _laff != _pID)
1109                 plyr_[_pID].laff = _laff;
1110 
1111             // set the new player bool to true
1112             _eventData_.compressedData = _eventData_.compressedData + 1;
1113         }
1114         return (_eventData_);
1115     }
1116 
1117     /**
1118      * @dev decides if round end needs to be run & new round started.  and if
1119      * player unmasked earnings from previously played rounds need to be moved.
1120      */
1121     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1122     private
1123     returns (RSdatasets.EventReturns)
1124     {
1125         // if player has played a previous round, move their unmasked earnings
1126         // from that round to gen vault.
1127         if (plyr_[_pID].lrnd != 0)
1128             updateGenVault(_pID, plyr_[_pID].lrnd);
1129 
1130         // update player's last round played
1131         plyr_[_pID].lrnd = rID_;
1132 
1133         // set the joined round bool to true
1134         _eventData_.compressedData = _eventData_.compressedData + 10;
1135 
1136         return(_eventData_);
1137     }
1138 
1139     /**
1140      * @dev ends the round. manages paying out winner/splitting up pot
1141      */
1142     function endRound(RSdatasets.EventReturns memory _eventData_)
1143     private
1144     returns (RSdatasets.EventReturns)
1145     {
1146         // setup local rID
1147         uint256 _rID = rID_;
1148 
1149         // grab our winning player and team id's
1150         uint256 _winPID = round_[_rID].plyr;
1151 
1152         // grab our pot amount
1153         // add airdrop pot into the final pot
1154         uint256 _pot = round_[_rID].pot + airDropPot_;
1155 
1156         // calculate our winner share, community rewards, gen share,
1157         // p3d share, and amount reserved for next pot
1158         uint256 _win = (_pot.mul(45)) / 100;
1159         uint256 _com = (_pot / 10);
1160         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1161 
1162         // calculate ppt for round mask
1163         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1164         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1165         if (_dust > 0)
1166         {
1167             _gen = _gen.sub(_dust);
1168             _com = _com.add(_dust);
1169         }
1170 
1171         // pay our winner
1172         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1173 
1174         // community rewards
1175         adminAddress.transfer(_com);
1176 
1177         // distribute gen portion to key holders
1178         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1179 
1180         // prepare event data
1181         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1182         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1183         _eventData_.winnerAddr = plyr_[_winPID].addr;
1184         _eventData_.winnerName = plyr_[_winPID].name;
1185         _eventData_.amountWon = _win;
1186         _eventData_.genAmount = _gen;
1187         _eventData_.newPot = 0;
1188 
1189         // start next round
1190         rID_++;
1191         _rID++;
1192         round_[_rID].strt = now;
1193         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1194         round_[_rID].pot = 0;
1195 
1196         return(_eventData_);
1197     }
1198 
1199     /**
1200      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1201      */
1202     function updateGenVault(uint256 _pID, uint256 _rID)
1203     private
1204     {
1205         uint256 _earnings = calcUnMaskedEarnings(_pID, _rID);
1206         if (_earnings > 0)
1207         {
1208             // put in gen vault
1209             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1210             // zero out their earnings by updating mask
1211             plyrRnds_[_pID][_rID].mask = _earnings.add(plyrRnds_[_pID][_rID].mask);
1212         }
1213     }
1214 
1215     /**
1216      * @dev updates round timer based on number of whole keys bought.
1217      */
1218     function updateTimer(uint256 _keys, uint256 _rID)
1219     private
1220     {
1221         // grab time
1222         uint256 _now = now;
1223 
1224         // calculate time based on number of keys bought
1225         uint256 _newTime;
1226         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1227             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1228         else
1229             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1230 
1231         // compare to max and set new end time
1232         if (_newTime < (rndMax_).add(_now))
1233             round_[_rID].end = _newTime;
1234         else
1235             round_[_rID].end = rndMax_.add(_now);
1236     }
1237 
1238     /**
1239      * @dev generates a random number between 0-99 and checks to see if thats
1240      * resulted in an airdrop win
1241      * @return do we have a winner?
1242      */
1243     function airdrop()
1244     private
1245     view
1246     returns(bool)
1247     {
1248         uint256 seed = uint256(keccak256(abi.encodePacked(
1249 
1250                 (block.timestamp).add
1251                 (block.difficulty).add
1252                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1253                 (block.gaslimit).add
1254                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1255                 (block.number)
1256 
1257             )));
1258         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1259             return(true);
1260         else
1261             return(false);
1262     }
1263 
1264     /**
1265      * @dev distributes eth based on fees to com, aff, and p3d
1266      */
1267     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1268     private
1269     returns(RSdatasets.EventReturns)
1270     {
1271         // pay 5% out to community rewards
1272         uint256 _com = _eth * 5 / 100;
1273 
1274         // distribute share to affiliate
1275         uint256 _aff = _eth / 10;
1276 
1277         // decide what to do with affiliate share of fees
1278         // affiliate must not be self, and must have a name registered
1279         if (_affID != _pID && plyr_[_affID].name != '') {
1280             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1281             emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1282         } else {
1283             // no affiliates, add to community
1284             _com += _aff;
1285         }
1286 
1287         // pay out team
1288         adminAddress.transfer(_com);
1289 
1290         return(_eventData_);
1291     }
1292 
1293     /**
1294      * @dev distributes eth based on fees to gen and pot
1295      */
1296     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1297     private
1298     returns(RSdatasets.EventReturns)
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
1317         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1318 
1319         // set up event data
1320         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1321         _eventData_.potAmount = _pot;
1322 
1323         return(_eventData_);
1324     }
1325 
1326     /**
1327      * @dev updates masks for round and player when keys are bought
1328      * @return dust left over
1329      */
1330     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1331     private
1332     returns(uint256)
1333     {
1334         /* MASKING NOTES
1335             earnings masks are a tricky thing for people to wrap their minds around.
1336             the basic thing to understand here.  is were going to have a global
1337             tracker based on profit per share for each round, that increases in
1338             relevant proportion to the increase in share supply.
1339 
1340             the player will have an additional mask that basically says "based
1341             on the rounds mask, my shares, and how much i've already withdrawn,
1342             how much is still owed to me?"
1343         */
1344         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1345         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1346         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1347 
1348         // calculate player earning from their own buy (only based on the keys
1349         // they just bought).  & update player earnings mask
1350         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1351         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1352 
1353         // calculate & return dust
1354         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1355     }
1356 
1357     /**
1358      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1359      * @return earnings in wei format
1360      */
1361     function withdrawEarnings(uint256 _pID)
1362     private
1363     returns(uint256)
1364     {
1365         // update gen vault
1366         updateGenVault(_pID, plyr_[_pID].lrnd);
1367 
1368         // from vaults
1369         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1370         if (_earnings > 0)
1371         {
1372             plyr_[_pID].win = 0;
1373             plyr_[_pID].gen = 0;
1374             plyr_[_pID].aff = 0;
1375         }
1376 
1377         return(_earnings);
1378     }
1379 
1380     /**
1381      * @dev prepares compression data and fires event for buy or reload tx's
1382      */
1383     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1384     private
1385     {
1386         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1387         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1388 
1389         emit RSEvents.onEndTx
1390         (
1391             _eventData_.compressedData,
1392             _eventData_.compressedIDs,
1393             plyr_[_pID].name,
1394             msg.sender,
1395             _eth,
1396             _keys,
1397             _eventData_.winnerAddr,
1398             _eventData_.winnerName,
1399             _eventData_.amountWon,
1400             _eventData_.newPot,
1401             _eventData_.genAmount,
1402             _eventData_.potAmount,
1403             airDropPot_
1404         );
1405     }
1406 
1407     /** upon contract deploy, it will be deactivated.  this is a one time
1408      * use function that will activate the contract.  we do this so devs
1409      * have time to set things up on the web end                            **/
1410     bool public activated_ = false;
1411     function activate()
1412     public
1413     {
1414         // only owner can activate
1415         // TODO: set owner
1416         require(
1417             msg.sender == adminAddress,
1418             "only owner can activate"
1419         );
1420 
1421         // can only be ran once
1422         require(activated_ == false, "ratscam already activated");
1423 
1424         // activate the contract
1425         activated_ = true;
1426 
1427         // lets start first round
1428         rID_ = 1;
1429         round_[1].strt = now - rndGap_;
1430         round_[1].end = now + rndInit_;
1431     }
1432 }
1433 
1434 //==============================================================================
1435 //   __|_ _    __|_ _  .
1436 //  _\ | | |_|(_ | _\  .
1437 //==============================================================================
1438 library RSdatasets {
1439     //compressedData key
1440     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1441     // 0 - new player (bool)
1442     // 1 - joined round (bool)
1443     // 2 - new  leader (bool)
1444     // 3-5 - air drop tracker (uint 0-999)
1445     // 6-16 - round end time
1446     // 17 - winnerTeam
1447     // 18 - 28 timestamp
1448     // 29 - team
1449     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1450     // 31 - airdrop happened bool
1451     // 32 - airdrop tier
1452     // 33 - airdrop amount won
1453     //compressedIDs key
1454     // [77-52][51-26][25-0]
1455     // 0-25 - pID
1456     // 26-51 - winPID
1457     // 52-77 - rID
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
1474         uint256 laff;   // last affiliate id used
1475         uint256 lrnd;   // last round played
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
1498 library RSKeysCalc {
1499     using SafeMath for *;
1500     /**
1501      * @dev calculates number of keys received given X eth
1502      * @param _curEth current amount of eth in contract
1503      * @param _newEth eth being spent
1504      * @return amount of ticket purchased
1505      */
1506     function keysRec(uint256 _curEth, uint256 _newEth)
1507     internal
1508     pure
1509     returns (uint256)
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
1521     internal
1522     pure
1523     returns (uint256)
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
1534     internal
1535     pure
1536     returns(uint256)
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
1547     internal
1548     pure
1549     returns(uint256)
1550     {
1551         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1552     }
1553 }
1554 
1555 //interface RatInterfaceForForwarder {
1556 //    function deposit() external payable returns(bool);
1557 //}
1558 
1559 interface RatBookInterface {
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
1582     internal
1583     pure
1584     returns(bytes32)
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
1618                 // require character is a space
1619                     _temp[i] == 0x20 ||
1620                 // OR lowercase a-z
1621                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1622                 // or 0-9
1623                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
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
1661     internal
1662     pure
1663     returns (uint256 c)
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
1677     internal
1678     pure
1679     returns (uint256)
1680     {
1681         require(b <= a, "SafeMath sub failed");
1682         return a - b;
1683     }
1684 
1685     /**
1686     * @dev Adds two numbers, throws on overflow.
1687     */
1688     function add(uint256 a, uint256 b)
1689     internal
1690     pure
1691     returns (uint256 c)
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
1702     internal
1703     pure
1704     returns (uint256 y)
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
1719     internal
1720     pure
1721     returns (uint256)
1722     {
1723         return (mul(x,x));
1724     }
1725 }