1 pragma solidity ^0.4.24;
2 
3 contract F3Devents {
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
31         uint256 P3DAmount,
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
59         uint256 P3DAmount,
60         uint256 genAmount
61     );
62 
63     // (fomo3d long only) fired whenever a player tries a buy after round timer
64     // hit zero, and causes end round to be ran.
65     event onBuyAndDistribute
66     (
67         address playerAddress,
68         bytes32 playerName,
69         uint256 ethIn,
70         uint256 compressedData,
71         uint256 compressedIDs,
72         address winnerAddr,
73         bytes32 winnerName,
74         uint256 amountWon,
75         uint256 newPot,
76         uint256 P3DAmount,
77         uint256 genAmount
78     );
79 
80     // (fomo3d long only) fired whenever a player tries a reload after round timer
81     // hit zero, and causes end round to be ran.
82     event onReLoadAndDistribute
83     (
84         address playerAddress,
85         bytes32 playerName,
86         uint256 compressedData,
87         uint256 compressedIDs,
88         address winnerAddr,
89         bytes32 winnerName,
90         uint256 amountWon,
91         uint256 newPot,
92         uint256 P3DAmount,
93         uint256 genAmount
94     );
95 
96     // fired whenever an affiliate is paid
97     event onAffiliatePayout
98     (
99         uint256 indexed affiliateID,
100         address affiliateAddress,
101         bytes32 affiliateName,
102         uint256 indexed roundID,
103         uint256 indexed buyerID,
104         uint256 amount,
105         uint256 timeStamp
106     );
107 }
108 
109 //==============================================================================
110 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
111 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
112 //====================================|=========================================
113 
114 contract modularLong is F3Devents {}
115 
116 contract FoMo3Dlong is modularLong {
117     using SafeMath for *;
118     using NameFilter for string;
119     using F3DKeysCalcLong for uint256;
120 
121     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xE7e851aC612A91667ec4BCf7f90521d48a6a5Db5);
122 
123     address private admin = msg.sender;
124     address private com = 0xaba7a09EDBe80403Ab705B95df24A5cE60Ec3b12; // community distribution address
125 
126     string constant public name = "FoMo4D";
127     string constant public symbol = "F4D";
128     uint256 private rndExtra_ = 0;     // length of the very first ICO
129     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
130     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
131     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
132     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
133     //==============================================================================
134     //     _| _ _|_ _    _ _ _|_    _   .
135     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
136     //=============================|================================================
137     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
138     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
139     uint256 public rID_;    // round id number / total rounds that have happened
140     //****************
141     // PLAYER DATA
142     //****************
143     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
144     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
145     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
146     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
147     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
148     //****************
149     // ROUND DATA
150     //****************
151     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
152     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
153     //****************
154     // TEAM FEE DATA
155     //****************
156     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
157     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
158     //==============================================================================
159     //     _ _  _  __|_ _    __|_ _  _  .
160     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
161     //==============================================================================
162     constructor()
163     public
164     {
165         // Team allocation structures
166         // 0 = whales
167         // 1 = bears
168         // 2 = sneks
169         // 3 = bulls
170 
171         // Team allocation percentages
172         // (F3D, P3D) + (Pot , Referrals, Community)
173         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
174         fees_[0] = F3Ddatasets.TeamFee(31,0);   //50% to pot, 15% to aff, 2% to com, 1% to air drop pot
175         fees_[1] = F3Ddatasets.TeamFee(41,0);   //40% to pot, 15% to aff, 2% to com, 1% to air drop pot
176         fees_[2] = F3Ddatasets.TeamFee(61,0);   //20% to pot, 15% to aff, 2% to com, 1% to air drop pot
177         fees_[3] = F3Ddatasets.TeamFee(46,0);   //35% to pot, 15% to aff, 2% to com, 1% to air drop pot
178 
179         // how to split up the final pot based on which team was picked
180         // (F3D, P3D)
181         potSplit_[0] = F3Ddatasets.PotSplit(20,0);  //48% to winner, 30% to next round, 2% to com
182         potSplit_[1] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
183         potSplit_[2] = F3Ddatasets.PotSplit(30,0);  //48% to winner, 20% to next round, 2% to com
184         potSplit_[3] = F3Ddatasets.PotSplit(35,0);  //48% to winner, 15% to next round, 2% to com
185     }
186     //==============================================================================
187     //     _ _  _  _|. |`. _  _ _  .
188     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
189     //==============================================================================
190     /**
191      * @dev used to make sure no one can interact with contract until it has
192      * been activated.
193      */
194     modifier isActivated() {
195         require(activated_ == true, "its not ready yet.  check ?eta in discord");
196         _;
197     }
198 
199     /**
200      * @dev prevents contracts from interacting with fomo3d
201      */
202     modifier isHuman() {
203         address _addr = msg.sender;
204         uint256 _codeLength;
205 
206         assembly {_codeLength := extcodesize(_addr)}
207         require(_codeLength == 0, "sorry humans only");
208         _;
209     }
210 
211     /**
212      * @dev sets boundaries for incoming tx
213      */
214     modifier isWithinLimits(uint256 _eth) {
215         require(_eth >= 1000000000, "pocket lint: not a valid currency");
216         require(_eth <= 100000000000000000000000, "no vitalik, no");
217         _;
218     }
219 
220     //==============================================================================
221     //     _    |_ |. _   |`    _  __|_. _  _  _  .
222     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
223     //====|=========================================================================
224     /**
225      * @dev emergency buy uses last stored affiliate ID and team snek
226      */
227     function()
228     isActivated()
229     isHuman()
230     isWithinLimits(msg.value)
231     public
232     payable
233     {
234         // set up our tx event data and determine if player is new or not
235         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
236 
237         // fetch player id
238         uint256 _pID = pIDxAddr_[msg.sender];
239 
240         // buy core
241         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
242     }
243 
244     /**
245      * @dev converts all incoming ethereum to keys.
246      * -functionhash- 0x8f38f309 (using ID for affiliate)
247      * -functionhash- 0x98a0871d (using address for affiliate)
248      * -functionhash- 0xa65b37a1 (using name for affiliate)
249      * @param _affCode the ID/address/name of the player who gets the affiliate fee
250      * @param _team what team is the player playing for?
251      */
252     function buyXid(uint256 _affCode, uint256 _team)
253     isActivated()
254     isHuman()
255     isWithinLimits(msg.value)
256     public
257     payable
258     {
259         // set up our tx event data and determine if player is new or not
260         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
261 
262         // fetch player id
263         uint256 _pID = pIDxAddr_[msg.sender];
264 
265         // manage affiliate residuals
266         // if no affiliate code was given or player tried to use their own, lolz
267         if (_affCode == 0 || _affCode == _pID)
268         {
269             // use last stored affiliate code
270             _affCode = plyr_[_pID].laff;
271 
272             // if affiliate code was given & its not the same as previously stored
273         } else if (_affCode != plyr_[_pID].laff) {
274             // update last affiliate
275             plyr_[_pID].laff = _affCode;
276         }
277 
278         // verify a valid team was selected
279         _team = verifyTeam(_team);
280 
281         // buy core
282         buyCore(_pID, _affCode, _team, _eventData_);
283     }
284 
285     function buyXaddr(address _affCode, uint256 _team)
286     isActivated()
287     isHuman()
288     isWithinLimits(msg.value)
289     public
290     payable
291     {
292         // set up our tx event data and determine if player is new or not
293         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
306             // if affiliate code was given
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
318 
319         // verify a valid team was selected
320         _team = verifyTeam(_team);
321 
322         // buy core
323         buyCore(_pID, _affID, _team, _eventData_);
324     }
325 
326     function buyXname(bytes32 _affCode, uint256 _team)
327     isActivated()
328     isHuman()
329     isWithinLimits(msg.value)
330     public
331     payable
332     {
333         // set up our tx event data and determine if player is new or not
334         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
335 
336         // fetch player id
337         uint256 _pID = pIDxAddr_[msg.sender];
338 
339         // manage affiliate residuals
340         uint256 _affID;
341         // if no affiliate code was given or player tried to use their own, lolz
342         if (_affCode == '' || _affCode == plyr_[_pID].name)
343         {
344             // use last stored affiliate code
345             _affID = plyr_[_pID].laff;
346 
347             // if affiliate code was given
348         } else {
349             // get affiliate ID from aff Code
350             _affID = pIDxName_[_affCode];
351 
352             // if affID is not the same as previously stored
353             if (_affID != plyr_[_pID].laff)
354             {
355                 // update last affiliate
356                 plyr_[_pID].laff = _affID;
357             }
358         }
359 
360         // verify a valid team was selected
361         _team = verifyTeam(_team);
362 
363         // buy core
364         buyCore(_pID, _affID, _team, _eventData_);
365     }
366 
367     /**
368      * @dev essentially the same as buy, but instead of you sending ether
369      * from your wallet, it uses your unwithdrawn earnings.
370      * -functionhash- 0x349cdcac (using ID for affiliate)
371      * -functionhash- 0x82bfc739 (using address for affiliate)
372      * -functionhash- 0x079ce327 (using name for affiliate)
373      * @param _affCode the ID/address/name of the player who gets the affiliate fee
374      * @param _team what team is the player playing for?
375      * @param _eth amount of earnings to use (remainder returned to gen vault)
376      */
377     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
378     isActivated()
379     isHuman()
380     isWithinLimits(_eth)
381     public
382     {
383         // set up our tx event data
384         F3Ddatasets.EventReturns memory _eventData_;
385 
386         // fetch player ID
387         uint256 _pID = pIDxAddr_[msg.sender];
388 
389         // manage affiliate residuals
390         // if no affiliate code was given or player tried to use their own, lolz
391         if (_affCode == 0 || _affCode == _pID)
392         {
393             // use last stored affiliate code
394             _affCode = plyr_[_pID].laff;
395 
396             // if affiliate code was given & its not the same as previously stored
397         } else if (_affCode != plyr_[_pID].laff) {
398             // update last affiliate
399             plyr_[_pID].laff = _affCode;
400         }
401 
402         // verify a valid team was selected
403         _team = verifyTeam(_team);
404 
405         // reload core
406         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
407     }
408 
409     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
410     isActivated()
411     isHuman()
412     isWithinLimits(_eth)
413     public
414     {
415         // set up our tx event data
416         F3Ddatasets.EventReturns memory _eventData_;
417 
418         // fetch player ID
419         uint256 _pID = pIDxAddr_[msg.sender];
420 
421         // manage affiliate residuals
422         uint256 _affID;
423         // if no affiliate code was given or player tried to use their own, lolz
424         if (_affCode == address(0) || _affCode == msg.sender)
425         {
426             // use last stored affiliate code
427             _affID = plyr_[_pID].laff;
428 
429             // if affiliate code was given
430         } else {
431             // get affiliate ID from aff Code
432             _affID = pIDxAddr_[_affCode];
433 
434             // if affID is not the same as previously stored
435             if (_affID != plyr_[_pID].laff)
436             {
437                 // update last affiliate
438                 plyr_[_pID].laff = _affID;
439             }
440         }
441 
442         // verify a valid team was selected
443         _team = verifyTeam(_team);
444 
445         // reload core
446         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
447     }
448 
449     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
450     isActivated()
451     isHuman()
452     isWithinLimits(_eth)
453     public
454     {
455         // set up our tx event data
456         F3Ddatasets.EventReturns memory _eventData_;
457 
458         // fetch player ID
459         uint256 _pID = pIDxAddr_[msg.sender];
460 
461         // manage affiliate residuals
462         uint256 _affID;
463         // if no affiliate code was given or player tried to use their own, lolz
464         if (_affCode == '' || _affCode == plyr_[_pID].name)
465         {
466             // use last stored affiliate code
467             _affID = plyr_[_pID].laff;
468 
469             // if affiliate code was given
470         } else {
471             // get affiliate ID from aff Code
472             _affID = pIDxName_[_affCode];
473 
474             // if affID is not the same as previously stored
475             if (_affID != plyr_[_pID].laff)
476             {
477                 // update last affiliate
478                 plyr_[_pID].laff = _affID;
479             }
480         }
481 
482         // verify a valid team was selected
483         _team = verifyTeam(_team);
484 
485         // reload core
486         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
487     }
488 
489     /**
490      * @dev withdraws all of your earnings.
491      * -functionhash- 0x3ccfd60b
492      */
493     function withdraw()
494     isActivated()
495     isHuman()
496     public
497     {
498         // setup local rID
499         uint256 _rID = rID_;
500 
501         // grab time
502         uint256 _now = now;
503 
504         // fetch player ID
505         uint256 _pID = pIDxAddr_[msg.sender];
506 
507         // setup temp var for player eth
508         uint256 _eth;
509 
510         // check to see if round has ended and no one has run round end yet
511         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
512         {
513             // set up our tx event data
514             F3Ddatasets.EventReturns memory _eventData_;
515 
516             // end the round (distributes pot)
517             round_[_rID].ended = true;
518             _eventData_ = endRound(_eventData_);
519 
520             // get their earnings
521             _eth = withdrawEarnings(_pID);
522 
523             // gib moni
524             if (_eth > 0)
525                 plyr_[_pID].addr.transfer(_eth);
526 
527             // build event data
528             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
529             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
530 
531             // fire withdraw and distribute event
532             emit F3Devents.onWithdrawAndDistribute
533             (
534                 msg.sender,
535                 plyr_[_pID].name,
536                 _eth,
537                 _eventData_.compressedData,
538                 _eventData_.compressedIDs,
539                 _eventData_.winnerAddr,
540                 _eventData_.winnerName,
541                 _eventData_.amountWon,
542                 _eventData_.newPot,
543                 _eventData_.P3DAmount,
544                 _eventData_.genAmount
545             );
546 
547             // in any other situation
548         } else {
549             // get their earnings
550             _eth = withdrawEarnings(_pID);
551 
552             // gib moni
553             if (_eth > 0)
554                 plyr_[_pID].addr.transfer(_eth);
555 
556             // fire withdraw event
557             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
558         }
559     }
560 
561     /**
562      * @dev use these to register names.  they are just wrappers that will send the
563      * registration requests to the PlayerBook contract.  So registering here is the
564      * same as registering there.  UI will always display the last name you registered.
565      * but you will still own all previously registered names to use as affiliate
566      * links.
567      * - must pay a registration fee.
568      * - name must be unique
569      * - names will be converted to lowercase
570      * - name cannot start or end with a space
571      * - cannot have more than 1 space in a row
572      * - cannot be only numbers
573      * - cannot start with 0x
574      * - name must be at least 1 char
575      * - max length of 32 characters long
576      * - allowed characters: a-z, 0-9, and space
577      * -functionhash- 0x921dec21 (using ID for affiliate)
578      * -functionhash- 0x3ddd4698 (using address for affiliate)
579      * -functionhash- 0x685ffd83 (using name for affiliate)
580      * @param _nameString players desired name
581      * @param _affCode affiliate ID, address, or name of who referred you
582      * @param _all set to true if you want this to push your info to all games
583      * (this might cost a lot of gas)
584      */
585     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
586     isHuman()
587     public
588     payable
589     {
590         bytes32 _name = _nameString.nameFilter();
591         address _addr = msg.sender;
592         uint256 _paid = msg.value;
593         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
594 
595         uint256 _pID = pIDxAddr_[_addr];
596 
597         // fire event
598         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
599     }
600 
601     function registerNameXaddr(string _nameString, address _affCode, bool _all)
602     isHuman()
603     public
604     payable
605     {
606         bytes32 _name = _nameString.nameFilter();
607         address _addr = msg.sender;
608         uint256 _paid = msg.value;
609         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
610 
611         uint256 _pID = pIDxAddr_[_addr];
612 
613         // fire event
614         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
615     }
616 
617     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
618     isHuman()
619     public
620     payable
621     {
622         bytes32 _name = _nameString.nameFilter();
623         address _addr = msg.sender;
624         uint256 _paid = msg.value;
625         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
626 
627         uint256 _pID = pIDxAddr_[_addr];
628 
629         // fire event
630         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
631     }
632     //==============================================================================
633     //     _  _ _|__|_ _  _ _  .
634     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
635     //=====_|=======================================================================
636     /**
637      * @dev return the price buyer will pay for next 1 individual key.
638      * -functionhash- 0x018a25e8
639      * @return price for next key bought (in wei format)
640      */
641     function getBuyPrice()
642     public
643     view
644     returns(uint256)
645     {
646         // setup local rID
647         uint256 _rID = rID_;
648 
649         // grab time
650         uint256 _now = now;
651 
652         // are we in a round?
653         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
654             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
655         else // rounds over.  need price for new round
656             return ( 75000000000000 ); // init
657     }
658 
659     /**
660      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
661      * provider
662      * -functionhash- 0xc7e284b8
663      * @return time left in seconds
664      */
665     function getTimeLeft()
666     public
667     view
668     returns(uint256)
669     {
670         // setup local rID
671         uint256 _rID = rID_;
672 
673         // grab time
674         uint256 _now = now;
675 
676         if (_now < round_[_rID].end)
677             if (_now > round_[_rID].strt + rndGap_)
678                 return( (round_[_rID].end).sub(_now) );
679             else
680                 return( (round_[_rID].strt + rndGap_).sub(_now) );
681         else
682             return(0);
683     }
684 
685     /**
686      * @dev returns player earnings per vaults
687      * -functionhash- 0x63066434
688      * @return winnings vault
689      * @return general vault
690      * @return affiliate vault
691      */
692     function getPlayerVaults(uint256 _pID)
693     public
694     view
695     returns(uint256 ,uint256, uint256)
696     {
697         // setup local rID
698         uint256 _rID = rID_;
699 
700         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
701         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
702         {
703             // if player is winner
704             if (round_[_rID].plyr == _pID)
705             {
706                 return
707                 (
708                 (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
709                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
710                 plyr_[_pID].aff
711                 );
712                 // if player is not the winner
713             } else {
714                 return
715                 (
716                 plyr_[_pID].win,
717                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
718                 plyr_[_pID].aff
719                 );
720             }
721 
722             // if round is still going on, or round has ended and round end has been ran
723         } else {
724             return
725             (
726             plyr_[_pID].win,
727             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
728             plyr_[_pID].aff
729             );
730         }
731     }
732 
733     /**
734      * solidity hates stack limits.  this lets us avoid that hate
735      */
736     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
737     private
738     view
739     returns(uint256)
740     {
741         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
742     }
743 
744     /**
745      * @dev returns all current round info needed for front end
746      * -functionhash- 0x747dff42
747      * @return eth invested during ICO phase
748      * @return round id
749      * @return total keys for round
750      * @return time round ends
751      * @return time round started
752      * @return current pot
753      * @return current team ID & player ID in lead
754      * @return current player in leads address
755      * @return current player in leads name
756      * @return whales eth in for round
757      * @return bears eth in for round
758      * @return sneks eth in for round
759      * @return bulls eth in for round
760      * @return airdrop tracker # & airdrop pot
761      */
762     function getCurrentRoundInfo()
763     public
764     view
765     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
766     {
767         // setup local rID
768         uint256 _rID = rID_;
769 
770         return
771         (
772         round_[_rID].ico,               //0
773         _rID,                           //1
774         round_[_rID].keys,              //2
775         round_[_rID].end,               //3
776         round_[_rID].strt,              //4
777         round_[_rID].pot,               //5
778         (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
779         plyr_[round_[_rID].plyr].addr,  //7
780         plyr_[round_[_rID].plyr].name,  //8
781         rndTmEth_[_rID][0],             //9
782         rndTmEth_[_rID][1],             //10
783         rndTmEth_[_rID][2],             //11
784         rndTmEth_[_rID][3],             //12
785         airDropTracker_ + (airDropPot_ * 1000)              //13
786         );
787     }
788 
789     /**
790      * @dev returns player info based on address.  if no address is given, it will
791      * use msg.sender
792      * -functionhash- 0xee0b5d8b
793      * @param _addr address of the player you want to lookup
794      * @return player ID
795      * @return player name
796      * @return keys owned (current round)
797      * @return winnings vault
798      * @return general vault
799      * @return affiliate vault
800 	 * @return player round eth
801      */
802     function getPlayerInfoByAddress(address _addr)
803     public
804     view
805     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
806     {
807         // setup local rID
808         uint256 _rID = rID_;
809 
810         if (_addr == address(0))
811         {
812             _addr == msg.sender;
813         }
814         uint256 _pID = pIDxAddr_[_addr];
815 
816         return
817         (
818         _pID,                               //0
819         plyr_[_pID].name,                   //1
820         plyrRnds_[_pID][_rID].keys,         //2
821         plyr_[_pID].win,                    //3
822         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
823         plyr_[_pID].aff,                    //5
824         plyrRnds_[_pID][_rID].eth           //6
825         );
826     }
827 
828     //==============================================================================
829     //     _ _  _ _   | _  _ . _  .
830     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
831     //=====================_|=======================================================
832     /**
833      * @dev logic runs whenever a buy order is executed.  determines how to handle
834      * incoming eth depending on if we are in an active round or not
835      */
836     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
837     private
838     {
839         // setup local rID
840         uint256 _rID = rID_;
841 
842         // grab time
843         uint256 _now = now;
844 
845         // if round is active
846         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
847         {
848             // call core
849             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
850 
851             // if round is not active
852         } else {
853             // check to see if end round needs to be ran
854             if (_now > round_[_rID].end && round_[_rID].ended == false)
855             {
856                 // end the round (distributes pot) & start new round
857                 round_[_rID].ended = true;
858                 _eventData_ = endRound(_eventData_);
859 
860                 // build event data
861                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
862                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
863 
864                 // fire buy and distribute event
865                 emit F3Devents.onBuyAndDistribute
866                 (
867                     msg.sender,
868                     plyr_[_pID].name,
869                     msg.value,
870                     _eventData_.compressedData,
871                     _eventData_.compressedIDs,
872                     _eventData_.winnerAddr,
873                     _eventData_.winnerName,
874                     _eventData_.amountWon,
875                     _eventData_.newPot,
876                     _eventData_.P3DAmount,
877                     _eventData_.genAmount
878                 );
879             }
880 
881             // put eth in players vault
882             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
883         }
884     }
885 
886     /**
887      * @dev logic runs whenever a reload order is executed.  determines how to handle
888      * incoming eth depending on if we are in an active round or not
889      */
890     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
891     private
892     {
893         // setup local rID
894         uint256 _rID = rID_;
895 
896         // grab time
897         uint256 _now = now;
898 
899         // if round is active
900         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
901         {
902             // get earnings from all vaults and return unused to gen vault
903             // because we use a custom safemath library.  this will throw if player
904             // tried to spend more eth than they have.
905             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
906 
907             // call core
908             core(_rID, _pID, _eth, _affID, _team, _eventData_);
909 
910             // if round is not active and end round needs to be ran
911         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
912             // end the round (distributes pot) & start new round
913             round_[_rID].ended = true;
914             _eventData_ = endRound(_eventData_);
915 
916             // build event data
917             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
918             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
919 
920             // fire buy and distribute event
921             emit F3Devents.onReLoadAndDistribute
922             (
923                 msg.sender,
924                 plyr_[_pID].name,
925                 _eventData_.compressedData,
926                 _eventData_.compressedIDs,
927                 _eventData_.winnerAddr,
928                 _eventData_.winnerName,
929                 _eventData_.amountWon,
930                 _eventData_.newPot,
931                 _eventData_.P3DAmount,
932                 _eventData_.genAmount
933             );
934         }
935     }
936 
937     /**
938      * @dev this is the core logic for any buy/reload that happens while a round
939      * is live.
940      */
941     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
942     private
943     {
944         // if player is new to round
945         if (plyrRnds_[_pID][_rID].keys == 0)
946             _eventData_ = managePlayer(_pID, _eventData_);
947 
948         // if eth left is greater than min eth allowed (sorry no pocket lint)
949         if (_eth > 1000000000)
950         {
951 
952             // mint the new keys
953             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
954 
955             // if they bought at least 1 whole key
956             if (_keys >= 1000000000000000000)
957             {
958                 updateTimer(_keys, _rID);
959 
960                 // set new leaders
961                 if (round_[_rID].plyr != _pID)
962                     round_[_rID].plyr = _pID;
963                 if (round_[_rID].team != _team)
964                     round_[_rID].team = _team;
965 
966                 // set the new leader bool to true
967                 _eventData_.compressedData = _eventData_.compressedData + 100;
968             }
969 
970             // manage airdrops
971             if (_eth >= 100000000000000000)
972             {
973                 airDropTracker_++;
974                 if (airdrop() == true)
975                 {
976                     // gib muni
977                     uint256 _prize;
978                     if (_eth >= 10000000000000000000)
979                     {
980                         // calculate prize and give it to winner
981                         _prize = ((airDropPot_).mul(75)) / 100;
982                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
983 
984                         // adjust airDropPot
985                         airDropPot_ = (airDropPot_).sub(_prize);
986 
987                         // let event know a tier 3 prize was won
988                         _eventData_.compressedData += 300000000000000000000000000000000;
989                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
990                         // calculate prize and give it to winner
991                         _prize = ((airDropPot_).mul(50)) / 100;
992                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
993 
994                         // adjust airDropPot
995                         airDropPot_ = (airDropPot_).sub(_prize);
996 
997                         // let event know a tier 2 prize was won
998                         _eventData_.compressedData += 200000000000000000000000000000000;
999                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1000                         // calculate prize and give it to winner
1001                         _prize = ((airDropPot_).mul(25)) / 100;
1002                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1003 
1004                         // adjust airDropPot
1005                         airDropPot_ = (airDropPot_).sub(_prize);
1006 
1007                         // let event know a tier 3 prize was won
1008                         _eventData_.compressedData += 300000000000000000000000000000000;
1009                     }
1010                     // set airdrop happened bool to true
1011                     _eventData_.compressedData += 10000000000000000000000000000000;
1012                     // let event know how much was won
1013                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1014 
1015                     // reset air drop tracker
1016                     airDropTracker_ = 0;
1017                 }
1018             }
1019 
1020             // store the air drop tracker number (number of buys since last airdrop)
1021             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1022 
1023             // update player
1024             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1025             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1026 
1027             // update round
1028             round_[_rID].keys = _keys.add(round_[_rID].keys);
1029             round_[_rID].eth = _eth.add(round_[_rID].eth);
1030             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1031 
1032             // distribute eth
1033             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1034             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1035 
1036             // call end tx function to fire end tx event.
1037             endTx(_pID, _team, _eth, _keys, _eventData_);
1038         }
1039     }
1040     //==============================================================================
1041     //     _ _ | _   | _ _|_ _  _ _  .
1042     //    (_(_||(_|_||(_| | (_)| _\  .
1043     //==============================================================================
1044     /**
1045      * @dev calculates unmasked earnings (just calculates, does not update mask)
1046      * @return earnings in wei format
1047      */
1048     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1049     private
1050     view
1051     returns(uint256)
1052     {
1053         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1054     }
1055 
1056     /**
1057      * @dev returns the amount of keys you would get given an amount of eth.
1058      * -functionhash- 0xce89c80c
1059      * @param _rID round ID you want price for
1060      * @param _eth amount of eth sent in
1061      * @return keys received
1062      */
1063     function calcKeysReceived(uint256 _rID, uint256 _eth)
1064     public
1065     view
1066     returns(uint256)
1067     {
1068         // grab time
1069         uint256 _now = now;
1070 
1071         // are we in a round?
1072         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1073             return ( (round_[_rID].eth).keysRec(_eth) );
1074         else // rounds over.  need keys for new round
1075             return ( (_eth).keys() );
1076     }
1077 
1078     /**
1079      * @dev returns current eth price for X keys.
1080      * -functionhash- 0xcf808000
1081      * @param _keys number of keys desired (in 18 decimal format)
1082      * @return amount of eth needed to send
1083      */
1084     function iWantXKeys(uint256 _keys)
1085     public
1086     view
1087     returns(uint256)
1088     {
1089         // setup local rID
1090         uint256 _rID = rID_;
1091 
1092         // grab time
1093         uint256 _now = now;
1094 
1095         // are we in a round?
1096         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1097             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1098         else // rounds over.  need price for new round
1099             return ( (_keys).eth() );
1100     }
1101     //==============================================================================
1102     //    _|_ _  _ | _  .
1103     //     | (_)(_)|_\  .
1104     //==============================================================================
1105     /**
1106 	 * @dev receives name/player info from names contract
1107      */
1108     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1109     external
1110     {
1111         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1112         if (pIDxAddr_[_addr] != _pID)
1113             pIDxAddr_[_addr] = _pID;
1114         if (pIDxName_[_name] != _pID)
1115             pIDxName_[_name] = _pID;
1116         if (plyr_[_pID].addr != _addr)
1117             plyr_[_pID].addr = _addr;
1118         if (plyr_[_pID].name != _name)
1119             plyr_[_pID].name = _name;
1120         if (plyr_[_pID].laff != _laff)
1121             plyr_[_pID].laff = _laff;
1122         if (plyrNames_[_pID][_name] == false)
1123             plyrNames_[_pID][_name] = true;
1124     }
1125 
1126     /**
1127      * @dev receives entire player name list
1128      */
1129     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1130     external
1131     {
1132         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1133         if(plyrNames_[_pID][_name] == false)
1134             plyrNames_[_pID][_name] = true;
1135     }
1136 
1137     /**
1138      * @dev gets existing or registers new pID.  use this when a player may be new
1139      * @return pID
1140      */
1141     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1142     private
1143     returns (F3Ddatasets.EventReturns)
1144     {
1145         uint256 _pID = pIDxAddr_[msg.sender];
1146         // if player is new to this version of fomo3d
1147         if (_pID == 0)
1148         {
1149             // grab their player ID, name and last aff ID, from player names contract
1150             _pID = PlayerBook.getPlayerID(msg.sender);
1151             bytes32 _name = PlayerBook.getPlayerName(_pID);
1152             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1153 
1154             // set up player account
1155             pIDxAddr_[msg.sender] = _pID;
1156             plyr_[_pID].addr = msg.sender;
1157 
1158             if (_name != "")
1159             {
1160                 pIDxName_[_name] = _pID;
1161                 plyr_[_pID].name = _name;
1162                 plyrNames_[_pID][_name] = true;
1163             }
1164 
1165             if (_laff != 0 && _laff != _pID)
1166                 plyr_[_pID].laff = _laff;
1167 
1168             // set the new player bool to true
1169             _eventData_.compressedData = _eventData_.compressedData + 1;
1170         }
1171         return (_eventData_);
1172     }
1173 
1174     /**
1175      * @dev checks to make sure user picked a valid team.  if not sets team
1176      * to default (sneks)
1177      */
1178     function verifyTeam(uint256 _team)
1179     private
1180     pure
1181     returns (uint256)
1182     {
1183         if (_team < 0 || _team > 3)
1184             return(2);
1185         else
1186             return(_team);
1187     }
1188 
1189     /**
1190      * @dev decides if round end needs to be run & new round started.  and if
1191      * player unmasked earnings from previously played rounds need to be moved.
1192      */
1193     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1194     private
1195     returns (F3Ddatasets.EventReturns)
1196     {
1197         // if player has played a previous round, move their unmasked earnings
1198         // from that round to gen vault.
1199         if (plyr_[_pID].lrnd != 0)
1200             updateGenVault(_pID, plyr_[_pID].lrnd);
1201 
1202         // update player's last round played
1203         plyr_[_pID].lrnd = rID_;
1204 
1205         // set the joined round bool to true
1206         _eventData_.compressedData = _eventData_.compressedData + 10;
1207 
1208         return(_eventData_);
1209     }
1210 
1211     /**
1212      * @dev ends the round. manages paying out winner/splitting up pot
1213      */
1214     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1215     private
1216     returns (F3Ddatasets.EventReturns)
1217     {
1218         // setup local rID
1219         uint256 _rID = rID_;
1220 
1221         // grab our winning player and team id's
1222         uint256 _winPID = round_[_rID].plyr;
1223         uint256 _winTID = round_[_rID].team;
1224 
1225         // grab our pot amount
1226         uint256 _pot = round_[_rID].pot;
1227 
1228         // calculate our winner share, community rewards, gen share,
1229         // p3d share, and amount reserved for next pot
1230         uint256 _win = (_pot.mul(48)) / 100;
1231         uint256 _com = (_pot / 50);
1232         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1233         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1234 
1235         // calculate ppt for round mask
1236         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1237         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1238         if (_dust > 0)
1239         {
1240             _gen = _gen.sub(_dust);
1241             _res = _res.add(_dust);
1242         }
1243 
1244         // pay our winner
1245         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1246 
1247         // community rewards
1248         com.transfer(_com);
1249 
1250         // distribute gen portion to key holders
1251         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1252 
1253         // prepare event data
1254         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1255         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1256         _eventData_.winnerAddr = plyr_[_winPID].addr;
1257         _eventData_.winnerName = plyr_[_winPID].name;
1258         _eventData_.amountWon = _win;
1259         _eventData_.genAmount = _gen;
1260         _eventData_.P3DAmount = 0;
1261         _eventData_.newPot = _res;
1262 
1263         // start next round
1264         rID_++;
1265         _rID++;
1266         round_[_rID].strt = now;
1267         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1268         round_[_rID].pot = _res;
1269 
1270         return(_eventData_);
1271     }
1272 
1273     /**
1274      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1275      */
1276     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1277     private
1278     {
1279         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1280         if (_earnings > 0)
1281         {
1282             // put in gen vault
1283             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1284             // zero out their earnings by updating mask
1285             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1286         }
1287     }
1288 
1289     /**
1290      * @dev updates round timer based on number of whole keys bought.
1291      */
1292     function updateTimer(uint256 _keys, uint256 _rID)
1293     private
1294     {
1295         // grab time
1296         uint256 _now = now;
1297 
1298         // calculate time based on number of keys bought
1299         uint256 _newTime;
1300         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1301             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1302         else
1303             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1304 
1305         // compare to max and set new end time
1306         if (_newTime < (rndMax_).add(_now))
1307             round_[_rID].end = _newTime;
1308         else
1309             round_[_rID].end = rndMax_.add(_now);
1310     }
1311 
1312     /**
1313      * @dev generates a random number between 0-99 and checks to see if thats
1314      * resulted in an airdrop win
1315      * @return do we have a winner?
1316      */
1317     function airdrop()
1318     private
1319     view
1320     returns(bool)
1321     {
1322         uint256 seed = uint256(keccak256(abi.encodePacked(
1323 
1324                 (block.timestamp).add
1325                 (block.difficulty).add
1326                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1327                 (block.gaslimit).add
1328                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1329                 (block.number)
1330 
1331             )));
1332         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1333             return(true);
1334         else
1335             return(false);
1336     }
1337 
1338     /**
1339      * @dev distributes eth based on fees to com, aff, and p3d
1340      */
1341     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1342     private
1343     returns(F3Ddatasets.EventReturns)
1344     {
1345         // pay 2% out to community rewards
1346         uint256 _com = _eth / 50;
1347 
1348         // distribute share to affiliate
1349         uint256 _aff = (_eth / 10).add(_eth / 20);
1350 
1351         // decide what to do with affiliate share of fees
1352         // affiliate must not be self, and must have a name registered
1353         if (_affID != _pID && plyr_[_affID].name != '') {
1354             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1355             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1356         } else {
1357             _com.add(_aff);
1358         }
1359 
1360         com.transfer(_com);
1361         return(_eventData_);
1362     }
1363 
1364     /**
1365      * @dev distributes eth based on fees to gen and pot
1366      */
1367     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1368     private
1369     returns(F3Ddatasets.EventReturns)
1370     {
1371         // calculate gen share
1372         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1373 
1374         // toss 1% into airdrop pot
1375         uint256 _air = (_eth / 100);
1376         airDropPot_ = airDropPot_.add(_air);
1377 
1378         // update eth balance (eth = eth - (com share (2%)+ aff share (15%)+ airdrop pot share (1%)))
1379         _eth = _eth.sub(((_eth.mul(18)) / 100) / 100);
1380 
1381         // calculate pot
1382         uint256 _pot = _eth.sub(_gen);
1383 
1384         // distribute gen share (thats what updateMasks() does) and adjust
1385         // balances for dust.
1386         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1387         if (_dust > 0)
1388             _gen = _gen.sub(_dust);
1389 
1390         // add eth to pot
1391         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1392 
1393         // set up event data
1394         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1395         _eventData_.potAmount = _pot;
1396 
1397         return(_eventData_);
1398     }
1399 
1400     /**
1401      * @dev updates masks for round and player when keys are bought
1402      * @return dust left over
1403      */
1404     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1405     private
1406     returns(uint256)
1407     {
1408         /* MASKING NOTES
1409             earnings masks are a tricky thing for people to wrap their minds around.
1410             the basic thing to understand here.  is were going to have a global
1411             tracker based on profit per share for each round, that increases in
1412             relevant proportion to the increase in share supply.
1413 
1414             the player will have an additional mask that basically says "based
1415             on the rounds mask, my shares, and how much i've already withdrawn,
1416             how much is still owed to me?"
1417         */
1418 
1419         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1420         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1421         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1422 
1423         // calculate player earning from their own buy (only based on the keys
1424         // they just bought).  & update player earnings mask
1425         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1426         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1427 
1428         // calculate & return dust
1429         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1430     }
1431 
1432     /**
1433      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1434      * @return earnings in wei format
1435      */
1436     function withdrawEarnings(uint256 _pID)
1437     private
1438     returns(uint256)
1439     {
1440         // update gen vault
1441         updateGenVault(_pID, plyr_[_pID].lrnd);
1442 
1443         // from vaults
1444         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1445         if (_earnings > 0)
1446         {
1447             plyr_[_pID].win = 0;
1448             plyr_[_pID].gen = 0;
1449             plyr_[_pID].aff = 0;
1450         }
1451 
1452         return(_earnings);
1453     }
1454 
1455     /**
1456      * @dev prepares compression data and fires event for buy or reload tx's
1457      */
1458     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1459     private
1460     {
1461         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1462         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1463 
1464         emit F3Devents.onEndTx
1465         (
1466             _eventData_.compressedData,
1467             _eventData_.compressedIDs,
1468             plyr_[_pID].name,
1469             msg.sender,
1470             _eth,
1471             _keys,
1472             _eventData_.winnerAddr,
1473             _eventData_.winnerName,
1474             _eventData_.amountWon,
1475             _eventData_.newPot,
1476             _eventData_.P3DAmount,
1477             _eventData_.genAmount,
1478             _eventData_.potAmount,
1479             airDropPot_
1480         );
1481     }
1482     //==============================================================================
1483     //    (~ _  _    _._|_    .
1484     //    _)(/_(_|_|| | | \/  .
1485     //====================/=========================================================
1486     /** upon contract deploy, it will be deactivated.  this is a one time
1487      * use function that will activate the contract.  we do this so devs
1488      * have time to set things up on the web end                            **/
1489     bool public activated_ = false;
1490     function activate()
1491     public
1492     {
1493         require(msg.sender == admin, "only admin can activate");
1494 
1495         // can only be ran once
1496         require(activated_ == false, "FOMO4D already activated");
1497 
1498         // activate the contract
1499         activated_ = true;
1500 
1501         // lets start first round
1502         rID_ = 1;
1503         round_[1].strt = now + rndExtra_ - rndGap_;
1504         round_[1].end = now + rndInit_ + rndExtra_;
1505     }
1506 }
1507 
1508 //==============================================================================
1509 //   __|_ _    __|_ _  .
1510 //  _\ | | |_|(_ | _\  .
1511 //==============================================================================
1512 library F3Ddatasets {
1513     //compressedData key
1514     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1515     // 0 - new player (bool)
1516     // 1 - joined round (bool)
1517     // 2 - new  leader (bool)
1518     // 3-5 - air drop tracker (uint 0-999)
1519     // 6-16 - round end time
1520     // 17 - winnerTeam
1521     // 18 - 28 timestamp
1522     // 29 - team
1523     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1524     // 31 - airdrop happened bool
1525     // 32 - airdrop tier
1526     // 33 - airdrop amount won
1527     //compressedIDs key
1528     // [77-52][51-26][25-0]
1529     // 0-25 - pID
1530     // 26-51 - winPID
1531     // 52-77 - rID
1532     struct EventReturns {
1533         uint256 compressedData;
1534         uint256 compressedIDs;
1535         address winnerAddr;         // winner address
1536         bytes32 winnerName;         // winner name
1537         uint256 amountWon;          // amount won
1538         uint256 newPot;             // amount in new pot
1539         uint256 P3DAmount;          // amount distributed to p3d
1540         uint256 genAmount;          // amount distributed to gen
1541         uint256 potAmount;          // amount added to pot
1542     }
1543     struct Player {
1544         address addr;   // player address
1545         bytes32 name;   // player name
1546         uint256 win;    // winnings vault
1547         uint256 gen;    // general vault
1548         uint256 aff;    // affiliate vault
1549         uint256 lrnd;   // last round played
1550         uint256 laff;   // last affiliate id used
1551     }
1552     struct PlayerRounds {
1553         uint256 eth;    // eth player has added to round (used for eth limiter)
1554         uint256 keys;   // keys
1555         uint256 mask;   // player mask
1556         uint256 ico;    // ICO phase investment
1557     }
1558     struct Round {
1559         uint256 plyr;   // pID of player in lead
1560         uint256 team;   // tID of team in lead
1561         uint256 end;    // time ends/ended
1562         bool ended;     // has round end function been ran
1563         uint256 strt;   // time round started
1564         uint256 keys;   // keys
1565         uint256 eth;    // total eth in
1566         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1567         uint256 mask;   // global mask
1568         uint256 ico;    // total eth sent in during ICO phase
1569         uint256 icoGen; // total eth for gen during ICO phase
1570         uint256 icoAvg; // average key price for ICO phase
1571     }
1572     struct TeamFee {
1573         uint256 gen;    // % of buy in thats paid to key holders of current round
1574         uint256 p3d;    // % of buy in thats paid to p3d holders
1575     }
1576     struct PotSplit {
1577         uint256 gen;    // % of pot thats paid to key holders of current round
1578         uint256 p3d;    // % of pot thats paid to p3d holders
1579     }
1580 }
1581 
1582 //==============================================================================
1583 //  |  _      _ _ | _  .
1584 //  |<(/_\/  (_(_||(_  .
1585 //=======/======================================================================
1586 library F3DKeysCalcLong {
1587     using SafeMath for *;
1588     /**
1589      * @dev calculates number of keys received given X eth
1590      * @param _curEth current amount of eth in contract
1591      * @param _newEth eth being spent
1592      * @return amount of ticket purchased
1593      */
1594     function keysRec(uint256 _curEth, uint256 _newEth)
1595     internal
1596     pure
1597     returns (uint256)
1598     {
1599         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1600     }
1601 
1602     /**
1603      * @dev calculates amount of eth received if you sold X keys
1604      * @param _curKeys current amount of keys that exist
1605      * @param _sellKeys amount of keys you wish to sell
1606      * @return amount of eth received
1607      */
1608     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1609     internal
1610     pure
1611     returns (uint256)
1612     {
1613         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1614     }
1615 
1616     /**
1617      * @dev calculates how many keys would exist with given an amount of eth
1618      * @param _eth eth "in contract"
1619      * @return number of keys that would exist
1620      */
1621     function keys(uint256 _eth)
1622     internal
1623     pure
1624     returns(uint256)
1625     {
1626         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1627     }
1628 
1629     /**
1630      * @dev calculates how much eth would be in contract given a number of keys
1631      * @param _keys number of keys "in contract"
1632      * @return eth that would exists
1633      */
1634     function eth(uint256 _keys)
1635     internal
1636     pure
1637     returns(uint256)
1638     {
1639         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1640     }
1641 }
1642 
1643 //==============================================================================
1644 //  . _ _|_ _  _ |` _  _ _  _  .
1645 //  || | | (/_| ~|~(_|(_(/__\  .
1646 //==============================================================================
1647 
1648 interface PlayerBookInterface {
1649     function getPlayerID(address _addr) external returns (uint256);
1650     function getPlayerName(uint256 _pID) external view returns (bytes32);
1651     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1652     function getPlayerAddr(uint256 _pID) external view returns (address);
1653     function getNameFee() external view returns (uint256);
1654     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1655     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1656     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1657 }
1658 
1659 library NameFilter {
1660     /**
1661      * @dev filters name strings
1662      * -converts uppercase to lower case.
1663      * -makes sure it does not start/end with a space
1664      * -makes sure it does not contain multiple spaces in a row
1665      * -cannot be only numbers
1666      * -cannot start with 0x
1667      * -restricts characters to A-Z, a-z, 0-9, and space.
1668      * @return reprocessed string in bytes32 format
1669      */
1670     function nameFilter(string _input)
1671     internal
1672     pure
1673     returns(bytes32)
1674     {
1675         bytes memory _temp = bytes(_input);
1676         uint256 _length = _temp.length;
1677 
1678         //sorry limited to 32 characters
1679         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1680         // make sure it doesnt start with or end with space
1681         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1682         // make sure first two characters are not 0x
1683         if (_temp[0] == 0x30)
1684         {
1685             require(_temp[1] != 0x78, "string cannot start with 0x");
1686             require(_temp[1] != 0x58, "string cannot start with 0X");
1687         }
1688 
1689         // create a bool to track if we have a non number character
1690         bool _hasNonNumber;
1691 
1692         // convert & check
1693         for (uint256 i = 0; i < _length; i++)
1694         {
1695             // if its uppercase A-Z
1696             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1697             {
1698                 // convert to lower case a-z
1699                 _temp[i] = byte(uint(_temp[i]) + 32);
1700 
1701                 // we have a non number
1702                 if (_hasNonNumber == false)
1703                     _hasNonNumber = true;
1704             } else {
1705                 require
1706                 (
1707                 // require character is a space
1708                     _temp[i] == 0x20 ||
1709                 // OR lowercase a-z
1710                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1711                 // or 0-9
1712                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1713                     "string contains invalid characters"
1714                 );
1715                 // make sure theres not 2x spaces in a row
1716                 if (_temp[i] == 0x20)
1717                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1718 
1719                 // see if we have a character other than a number
1720                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1721                     _hasNonNumber = true;
1722             }
1723         }
1724 
1725         require(_hasNonNumber == true, "string cannot be only numbers");
1726 
1727         bytes32 _ret;
1728         assembly {
1729             _ret := mload(add(_temp, 32))
1730         }
1731         return (_ret);
1732     }
1733 }
1734 
1735 /**
1736  * @title SafeMath v0.1.9
1737  * @dev Math operations with safety checks that throw on error
1738  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1739  * - added sqrt
1740  * - added sq
1741  * - added pwr
1742  * - changed asserts to requires with error log outputs
1743  * - removed div, its useless
1744  */
1745 library SafeMath {
1746 
1747     /**
1748     * @dev Multiplies two numbers, throws on overflow.
1749     */
1750     function mul(uint256 a, uint256 b)
1751     internal
1752     pure
1753     returns (uint256 c)
1754     {
1755         if (a == 0) {
1756             return 0;
1757         }
1758         c = a * b;
1759         require(c / a == b, "SafeMath mul failed");
1760         return c;
1761     }
1762 
1763     /**
1764     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1765     */
1766     function sub(uint256 a, uint256 b)
1767     internal
1768     pure
1769     returns (uint256)
1770     {
1771         require(b <= a, "SafeMath sub failed");
1772         return a - b;
1773     }
1774 
1775     /**
1776     * @dev Adds two numbers, throws on overflow.
1777     */
1778     function add(uint256 a, uint256 b)
1779     internal
1780     pure
1781     returns (uint256 c)
1782     {
1783         c = a + b;
1784         require(c >= a, "SafeMath add failed");
1785         return c;
1786     }
1787 
1788     /**
1789      * @dev gives square root of given x.
1790      */
1791     function sqrt(uint256 x)
1792     internal
1793     pure
1794     returns (uint256 y)
1795     {
1796         uint256 z = ((add(x,1)) / 2);
1797         y = x;
1798         while (z < y)
1799         {
1800             y = z;
1801             z = ((add((x / z),z)) / 2);
1802         }
1803     }
1804 
1805     /**
1806      * @dev gives square. multiplies x by x
1807      */
1808     function sq(uint256 x)
1809     internal
1810     pure
1811     returns (uint256)
1812     {
1813         return (mul(x,x));
1814     }
1815 
1816     /**
1817      * @dev x to the power of y
1818      */
1819     function pwr(uint256 x, uint256 y)
1820     internal
1821     pure
1822     returns (uint256)
1823     {
1824         if (x==0)
1825             return (0);
1826         else if (y==0)
1827             return (1);
1828         else
1829         {
1830             uint256 z = x;
1831             for (uint256 i=1; i < y; i++)
1832                 z = mul(z,x);
1833             return (z);
1834         }
1835     }
1836 }