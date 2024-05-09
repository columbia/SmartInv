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
121     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x46162369F33ac6Cf7A21f093F676619C9264629f);
122 
123     address private admin = msg.sender;
124     address private com = 0xF2bE09314d0F044a537eb4c3d15E2a76feBDD662;
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
174         fees_[0] = F3Ddatasets.TeamFee(33,0);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
175         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air dr op pot
176         fees_[2] = F3Ddatasets.TeamFee(61,0);   //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
177         fees_[3] = F3Ddatasets.TeamFee(47,0);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
178 
179         // how to split up the final pot based on which team was picked
180         // (F3D, P3D)
181         potSplit_[0] = F3Ddatasets.PotSplit(20,0);  //48% to winner, 25% to next round, 2% to com
182         potSplit_[1] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
183         potSplit_[2] = F3Ddatasets.PotSplit(30,0);  //48% to winner, 10% to next round, 2% to com
184         potSplit_[3] = F3Ddatasets.PotSplit(35,0);  //48% to winner, 10% to next round, 2% to com
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
948         // early round eth limiter
949 //        if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
950 //        {
951 //            uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
952 //            uint256 _refund = _eth.sub(_availableLimit);
953 //            plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
954 //            _eth = _availableLimit;
955 //        }
956 
957         // if eth left is greater than min eth allowed (sorry no pocket lint)
958         if (_eth > 1000000000)
959         {
960 
961             // mint the new keys
962             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
963 
964             // if they bought at least 1 whole key
965             if (_keys >= 1000000000000000000)
966             {
967                 updateTimer(_keys, _rID);
968 
969                 // set new leaders
970                 if (round_[_rID].plyr != _pID)
971                     round_[_rID].plyr = _pID;
972                 if (round_[_rID].team != _team)
973                     round_[_rID].team = _team;
974 
975                 // set the new leader bool to true
976                 _eventData_.compressedData = _eventData_.compressedData + 100;
977             }
978 
979             // manage airdrops
980             if (_eth >= 100000000000000000)
981             {
982                 airDropTracker_++;
983                 if (airdrop() == true)
984                 {
985                     // gib muni
986                     uint256 _prize;
987                     if (_eth >= 10000000000000000000)
988                     {
989                         // calculate prize and give it to winner
990                         _prize = ((airDropPot_).mul(75)) / 100;
991                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
992 
993                         // adjust airDropPot
994                         airDropPot_ = (airDropPot_).sub(_prize);
995 
996                         // let event know a tier 3 prize was won
997                         _eventData_.compressedData += 300000000000000000000000000000000;
998                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
999                         // calculate prize and give it to winner
1000                         _prize = ((airDropPot_).mul(50)) / 100;
1001                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1002 
1003                         // adjust airDropPot
1004                         airDropPot_ = (airDropPot_).sub(_prize);
1005 
1006                         // let event know a tier 2 prize was won
1007                         _eventData_.compressedData += 200000000000000000000000000000000;
1008                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1009                         // calculate prize and give it to winner
1010                         _prize = ((airDropPot_).mul(25)) / 100;
1011                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1012 
1013                         // adjust airDropPot
1014                         airDropPot_ = (airDropPot_).sub(_prize);
1015 
1016                         // let event know a tier 3 prize was won
1017                         _eventData_.compressedData += 300000000000000000000000000000000;
1018                     }
1019                     // set airdrop happened bool to true
1020                     _eventData_.compressedData += 10000000000000000000000000000000;
1021                     // let event know how much was won
1022                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1023 
1024                     // reset air drop tracker
1025                     airDropTracker_ = 0;
1026                 }
1027             }
1028 
1029             // store the air drop tracker number (number of buys since last airdrop)
1030             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1031 
1032             // update player
1033             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1034             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1035 
1036             // update round
1037             round_[_rID].keys = _keys.add(round_[_rID].keys);
1038             round_[_rID].eth = _eth.add(round_[_rID].eth);
1039             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1040 
1041             // distribute eth
1042             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1043             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1044 
1045             // call end tx function to fire end tx event.
1046             endTx(_pID, _team, _eth, _keys, _eventData_);
1047         }
1048     }
1049     //==============================================================================
1050     //     _ _ | _   | _ _|_ _  _ _  .
1051     //    (_(_||(_|_||(_| | (_)| _\  .
1052     //==============================================================================
1053     /**
1054      * @dev calculates unmasked earnings (just calculates, does not update mask)
1055      * @return earnings in wei format
1056      */
1057     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1058     private
1059     view
1060     returns(uint256)
1061     {
1062         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1063     }
1064 
1065     /**
1066      * @dev returns the amount of keys you would get given an amount of eth.
1067      * -functionhash- 0xce89c80c
1068      * @param _rID round ID you want price for
1069      * @param _eth amount of eth sent in
1070      * @return keys received
1071      */
1072     function calcKeysReceived(uint256 _rID, uint256 _eth)
1073     public
1074     view
1075     returns(uint256)
1076     {
1077         // grab time
1078         uint256 _now = now;
1079 
1080         // are we in a round?
1081         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1082             return ( (round_[_rID].eth).keysRec(_eth) );
1083         else // rounds over.  need keys for new round
1084             return ( (_eth).keys() );
1085     }
1086 
1087     /**
1088      * @dev returns current eth price for X keys.
1089      * -functionhash- 0xcf808000
1090      * @param _keys number of keys desired (in 18 decimal format)
1091      * @return amount of eth needed to send
1092      */
1093     function iWantXKeys(uint256 _keys)
1094     public
1095     view
1096     returns(uint256)
1097     {
1098         // setup local rID
1099         uint256 _rID = rID_;
1100 
1101         // grab time
1102         uint256 _now = now;
1103 
1104         // are we in a round?
1105         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1106             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1107         else // rounds over.  need price for new round
1108             return ( (_keys).eth() );
1109     }
1110     //==============================================================================
1111     //    _|_ _  _ | _  .
1112     //     | (_)(_)|_\  .
1113     //==============================================================================
1114     /**
1115 	 * @dev receives name/player info from names contract
1116      */
1117     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1118     external
1119     {
1120         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1121         if (pIDxAddr_[_addr] != _pID)
1122             pIDxAddr_[_addr] = _pID;
1123         if (pIDxName_[_name] != _pID)
1124             pIDxName_[_name] = _pID;
1125         if (plyr_[_pID].addr != _addr)
1126             plyr_[_pID].addr = _addr;
1127         if (plyr_[_pID].name != _name)
1128             plyr_[_pID].name = _name;
1129         if (plyr_[_pID].laff != _laff)
1130             plyr_[_pID].laff = _laff;
1131         if (plyrNames_[_pID][_name] == false)
1132             plyrNames_[_pID][_name] = true;
1133     }
1134 
1135     /**
1136      * @dev receives entire player name list
1137      */
1138     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1139     external
1140     {
1141         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1142         if(plyrNames_[_pID][_name] == false)
1143             plyrNames_[_pID][_name] = true;
1144     }
1145 
1146     /**
1147      * @dev gets existing or registers new pID.  use this when a player may be new
1148      * @return pID
1149      */
1150     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1151     private
1152     returns (F3Ddatasets.EventReturns)
1153     {
1154         uint256 _pID = pIDxAddr_[msg.sender];
1155         // if player is new to this version of fomo3d
1156         if (_pID == 0)
1157         {
1158             // grab their player ID, name and last aff ID, from player names contract
1159             _pID = PlayerBook.getPlayerID(msg.sender);
1160             bytes32 _name = PlayerBook.getPlayerName(_pID);
1161             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1162 
1163             // set up player account
1164             pIDxAddr_[msg.sender] = _pID;
1165             plyr_[_pID].addr = msg.sender;
1166 
1167             if (_name != "")
1168             {
1169                 pIDxName_[_name] = _pID;
1170                 plyr_[_pID].name = _name;
1171                 plyrNames_[_pID][_name] = true;
1172             }
1173 
1174             if (_laff != 0 && _laff != _pID)
1175                 plyr_[_pID].laff = _laff;
1176 
1177             // set the new player bool to true
1178             _eventData_.compressedData = _eventData_.compressedData + 1;
1179         }
1180         return (_eventData_);
1181     }
1182 
1183     /**
1184      * @dev checks to make sure user picked a valid team.  if not sets team
1185      * to default (sneks)
1186      */
1187     function verifyTeam(uint256 _team)
1188     private
1189     pure
1190     returns (uint256)
1191     {
1192         if (_team < 0 || _team > 3)
1193             return(2);
1194         else
1195             return(_team);
1196     }
1197 
1198     /**
1199      * @dev decides if round end needs to be run & new round started.  and if
1200      * player unmasked earnings from previously played rounds need to be moved.
1201      */
1202     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1203     private
1204     returns (F3Ddatasets.EventReturns)
1205     {
1206         // if player has played a previous round, move their unmasked earnings
1207         // from that round to gen vault.
1208         if (plyr_[_pID].lrnd != 0)
1209             updateGenVault(_pID, plyr_[_pID].lrnd);
1210 
1211         // update player's last round played
1212         plyr_[_pID].lrnd = rID_;
1213 
1214         // set the joined round bool to true
1215         _eventData_.compressedData = _eventData_.compressedData + 10;
1216 
1217         return(_eventData_);
1218     }
1219 
1220     /**
1221      * @dev ends the round. manages paying out winner/splitting up pot
1222      */
1223     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1224     private
1225     returns (F3Ddatasets.EventReturns)
1226     {
1227         // setup local rID
1228         uint256 _rID = rID_;
1229 
1230         // grab our winning player and team id's
1231         uint256 _winPID = round_[_rID].plyr;
1232         uint256 _winTID = round_[_rID].team;
1233 
1234         // grab our pot amount
1235         uint256 _pot = round_[_rID].pot;
1236 
1237         // calculate our winner share, community rewards, gen share,
1238         // p3d share, and amount reserved for next pot
1239         uint256 _win = (_pot.mul(40)) / 100;
1240         uint256 _com = (_pot / 10);
1241         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1242         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1243 
1244         // calculate ppt for round mask
1245         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1246         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1247         if (_dust > 0)
1248         {
1249             _gen = _gen.sub(_dust);
1250             _res = _res.add(_dust);
1251         }
1252 
1253         // pay our winner
1254         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1255 
1256         // community rewards
1257         com.transfer(_com);
1258 
1259         // distribute gen portion to key holders
1260         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1261 
1262         // prepare event data
1263         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1264         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1265         _eventData_.winnerAddr = plyr_[_winPID].addr;
1266         _eventData_.winnerName = plyr_[_winPID].name;
1267         _eventData_.amountWon = _win;
1268         _eventData_.genAmount = _gen;
1269         _eventData_.P3DAmount = 0;
1270         _eventData_.newPot = _res;
1271 
1272         // start next round
1273         rID_++;
1274         _rID++;
1275         round_[_rID].strt = now;
1276         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1277         round_[_rID].pot = _res;
1278 
1279         return(_eventData_);
1280     }
1281 
1282     /**
1283      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1284      */
1285     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1286     private
1287     {
1288         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1289         if (_earnings > 0)
1290         {
1291             // put in gen vault
1292             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1293             // zero out their earnings by updating mask
1294             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1295         }
1296     }
1297 
1298     /**
1299      * @dev updates round timer based on number of whole keys bought.
1300      */
1301     function updateTimer(uint256 _keys, uint256 _rID)
1302     private
1303     {
1304         // grab time
1305         uint256 _now = now;
1306 
1307         // calculate time based on number of keys bought
1308         uint256 _newTime;
1309         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1310             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1311         else
1312             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1313 
1314         // compare to max and set new end time
1315         if (_newTime < (rndMax_).add(_now))
1316             round_[_rID].end = _newTime;
1317         else
1318             round_[_rID].end = rndMax_.add(_now);
1319     }
1320 
1321     /**
1322      * @dev generates a random number between 0-99 and checks to see if thats
1323      * resulted in an airdrop win
1324      * @return do we have a winner?
1325      */
1326     function airdrop()
1327     private
1328     view
1329     returns(bool)
1330     {
1331         uint256 seed = uint256(keccak256(abi.encodePacked(
1332 
1333                 (block.timestamp).add
1334                 (block.difficulty).add
1335                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1336                 (block.gaslimit).add
1337                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1338                 (block.number)
1339 
1340             )));
1341         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1342             return(true);
1343         else
1344             return(false);
1345     }
1346 
1347     /**
1348      * @dev distributes eth based on fees to com, aff, and p3d
1349      */
1350     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1351     private
1352     returns(F3Ddatasets.EventReturns)
1353     {
1354         // pay 2% out to community rewards
1355         uint256 _com = _eth / 10;
1356 
1357         // distribute share to affiliate
1358         uint256 _aff = _eth / 10;
1359 
1360         // decide what to do with affiliate share of fees
1361         // affiliate must not be self, and must have a name registered
1362         if (_affID != _pID && plyr_[_affID].name != '') {
1363             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1364             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1365         } else {
1366             _com.add(_aff);
1367         }
1368 
1369         com.transfer(_com);
1370         return(_eventData_);
1371     }
1372 
1373     /**
1374      * @dev distributes eth based on fees to gen and pot
1375      */
1376     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1377     private
1378     returns(F3Ddatasets.EventReturns)
1379     {
1380         // calculate gen share
1381         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1382 
1383         // toss 1% into airdrop pot
1384         uint256 _air = (_eth / 100);
1385         airDropPot_ = airDropPot_.add(_air);
1386 
1387         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1388         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1389 
1390         // calculate pot
1391         uint256 _pot = _eth.sub(_gen);
1392 
1393         // distribute gen share (thats what updateMasks() does) and adjust
1394         // balances for dust.
1395         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1396         if (_dust > 0)
1397             _gen = _gen.sub(_dust);
1398 
1399         // add eth to pot
1400         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1401 
1402         // set up event data
1403         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1404         _eventData_.potAmount = _pot;
1405 
1406         return(_eventData_);
1407     }
1408 
1409     /**
1410      * @dev updates masks for round and player when keys are bought
1411      * @return dust left over
1412      */
1413     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1414     private
1415     returns(uint256)
1416     {
1417         /* MASKING NOTES
1418             earnings masks are a tricky thing for people to wrap their minds around.
1419             the basic thing to understand here.  is were going to have a global
1420             tracker based on profit per share for each round, that increases in
1421             relevant proportion to the increase in share supply.
1422 
1423             the player will have an additional mask that basically says "based
1424             on the rounds mask, my shares, and how much i've already withdrawn,
1425             how much is still owed to me?"
1426         */
1427 
1428         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1429         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1430         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1431 
1432         // calculate player earning from their own buy (only based on the keys
1433         // they just bought).  & update player earnings mask
1434         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1435         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1436 
1437         // calculate & return dust
1438         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1439     }
1440 
1441     /**
1442      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1443      * @return earnings in wei format
1444      */
1445     function withdrawEarnings(uint256 _pID)
1446     private
1447     returns(uint256)
1448     {
1449         // update gen vault
1450         updateGenVault(_pID, plyr_[_pID].lrnd);
1451 
1452         // from vaults
1453         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1454         if (_earnings > 0)
1455         {
1456             plyr_[_pID].win = 0;
1457             plyr_[_pID].gen = 0;
1458             plyr_[_pID].aff = 0;
1459         }
1460 
1461         return(_earnings);
1462     }
1463 
1464     /**
1465      * @dev prepares compression data and fires event for buy or reload tx's
1466      */
1467     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1468     private
1469     {
1470         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1471         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1472 
1473         emit F3Devents.onEndTx
1474         (
1475             _eventData_.compressedData,
1476             _eventData_.compressedIDs,
1477             plyr_[_pID].name,
1478             msg.sender,
1479             _eth,
1480             _keys,
1481             _eventData_.winnerAddr,
1482             _eventData_.winnerName,
1483             _eventData_.amountWon,
1484             _eventData_.newPot,
1485             _eventData_.P3DAmount,
1486             _eventData_.genAmount,
1487             _eventData_.potAmount,
1488             airDropPot_
1489         );
1490     }
1491     //==============================================================================
1492     //    (~ _  _    _._|_    .
1493     //    _)(/_(_|_|| | | \/  .
1494     //====================/=========================================================
1495     /** upon contract deploy, it will be deactivated.  this is a one time
1496      * use function that will activate the contract.  we do this so devs
1497      * have time to set things up on the web end                            **/
1498     bool public activated_ = false;
1499     function activate()
1500     public
1501     {
1502         require(msg.sender == admin, "only admin can activate");
1503 
1504         // can only be ran once
1505         require(activated_ == false, "FOMO Short already activated");
1506 
1507         // activate the contract
1508         activated_ = true;
1509 
1510         // lets start first round
1511         rID_ = 1;
1512         round_[1].strt = now + rndExtra_ - rndGap_;
1513         round_[1].end = now + rndInit_ + rndExtra_;
1514     }
1515 }
1516 
1517 //==============================================================================
1518 //   __|_ _    __|_ _  .
1519 //  _\ | | |_|(_ | _\  .
1520 //==============================================================================
1521 library F3Ddatasets {
1522     //compressedData key
1523     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1524     // 0 - new player (bool)
1525     // 1 - joined round (bool)
1526     // 2 - new  leader (bool)
1527     // 3-5 - air drop tracker (uint 0-999)
1528     // 6-16 - round end time
1529     // 17 - winnerTeam
1530     // 18 - 28 timestamp
1531     // 29 - team
1532     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1533     // 31 - airdrop happened bool
1534     // 32 - airdrop tier
1535     // 33 - airdrop amount won
1536     //compressedIDs key
1537     // [77-52][51-26][25-0]
1538     // 0-25 - pID
1539     // 26-51 - winPID
1540     // 52-77 - rID
1541     struct EventReturns {
1542         uint256 compressedData;
1543         uint256 compressedIDs;
1544         address winnerAddr;         // winner address
1545         bytes32 winnerName;         // winner name
1546         uint256 amountWon;          // amount won
1547         uint256 newPot;             // amount in new pot
1548         uint256 P3DAmount;          // amount distributed to p3d
1549         uint256 genAmount;          // amount distributed to gen
1550         uint256 potAmount;          // amount added to pot
1551     }
1552     struct Player {
1553         address addr;   // player address
1554         bytes32 name;   // player name
1555         uint256 win;    // winnings vault
1556         uint256 gen;    // general vault
1557         uint256 aff;    // affiliate vault
1558         uint256 lrnd;   // last round played
1559         uint256 laff;   // last affiliate id used
1560     }
1561     struct PlayerRounds {
1562         uint256 eth;    // eth player has added to round (used for eth limiter)
1563         uint256 keys;   // keys
1564         uint256 mask;   // player mask
1565         uint256 ico;    // ICO phase investment
1566     }
1567     struct Round {
1568         uint256 plyr;   // pID of player in lead
1569         uint256 team;   // tID of team in lead
1570         uint256 end;    // time ends/ended
1571         bool ended;     // has round end function been ran
1572         uint256 strt;   // time round started
1573         uint256 keys;   // keys
1574         uint256 eth;    // total eth in
1575         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1576         uint256 mask;   // global mask
1577         uint256 ico;    // total eth sent in during ICO phase
1578         uint256 icoGen; // total eth for gen during ICO phase
1579         uint256 icoAvg; // average key price for ICO phase
1580     }
1581     struct TeamFee {
1582         uint256 gen;    // % of buy in thats paid to key holders of current round
1583         uint256 p3d;    // % of buy in thats paid to p3d holders
1584     }
1585     struct PotSplit {
1586         uint256 gen;    // % of pot thats paid to key holders of current round
1587         uint256 p3d;    // % of pot thats paid to p3d holders
1588     }
1589 }
1590 
1591 //==============================================================================
1592 //  |  _      _ _ | _  .
1593 //  |<(/_\/  (_(_||(_  .
1594 //=======/======================================================================
1595 library F3DKeysCalcLong {
1596     using SafeMath for *;
1597     /**
1598      * @dev calculates number of keys received given X eth
1599      * @param _curEth current amount of eth in contract
1600      * @param _newEth eth being spent
1601      * @return amount of ticket purchased
1602      */
1603     function keysRec(uint256 _curEth, uint256 _newEth)
1604     internal
1605     pure
1606     returns (uint256)
1607     {
1608         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1609     }
1610 
1611     /**
1612      * @dev calculates amount of eth received if you sold X keys
1613      * @param _curKeys current amount of keys that exist
1614      * @param _sellKeys amount of keys you wish to sell
1615      * @return amount of eth received
1616      */
1617     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1618     internal
1619     pure
1620     returns (uint256)
1621     {
1622         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1623     }
1624 
1625     /**
1626      * @dev calculates how many keys would exist with given an amount of eth
1627      * @param _eth eth "in contract"
1628      * @return number of keys that would exist
1629      */
1630     function keys(uint256 _eth)
1631     internal
1632     pure
1633     returns(uint256)
1634     {
1635         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1636     }
1637 
1638     /**
1639      * @dev calculates how much eth would be in contract given a number of keys
1640      * @param _keys number of keys "in contract"
1641      * @return eth that would exists
1642      */
1643     function eth(uint256 _keys)
1644     internal
1645     pure
1646     returns(uint256)
1647     {
1648         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1649     }
1650 }
1651 
1652 //==============================================================================
1653 //  . _ _|_ _  _ |` _  _ _  _  .
1654 //  || | | (/_| ~|~(_|(_(/__\  .
1655 //==============================================================================
1656 
1657 interface PlayerBookInterface {
1658     function getPlayerID(address _addr) external returns (uint256);
1659     function getPlayerName(uint256 _pID) external view returns (bytes32);
1660     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1661     function getPlayerAddr(uint256 _pID) external view returns (address);
1662     function getNameFee() external view returns (uint256);
1663     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1664     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1665     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1666 }
1667 
1668 library NameFilter {
1669     /**
1670      * @dev filters name strings
1671      * -converts uppercase to lower case.
1672      * -makes sure it does not start/end with a space
1673      * -makes sure it does not contain multiple spaces in a row
1674      * -cannot be only numbers
1675      * -cannot start with 0x
1676      * -restricts characters to A-Z, a-z, 0-9, and space.
1677      * @return reprocessed string in bytes32 format
1678      */
1679     function nameFilter(string _input)
1680     internal
1681     pure
1682     returns(bytes32)
1683     {
1684         bytes memory _temp = bytes(_input);
1685         uint256 _length = _temp.length;
1686 
1687         //sorry limited to 32 characters
1688         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1689         // make sure it doesnt start with or end with space
1690         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1691         // make sure first two characters are not 0x
1692         if (_temp[0] == 0x30)
1693         {
1694             require(_temp[1] != 0x78, "string cannot start with 0x");
1695             require(_temp[1] != 0x58, "string cannot start with 0X");
1696         }
1697 
1698         // create a bool to track if we have a non number character
1699         bool _hasNonNumber;
1700 
1701         // convert & check
1702         for (uint256 i = 0; i < _length; i++)
1703         {
1704             // if its uppercase A-Z
1705             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1706             {
1707                 // convert to lower case a-z
1708                 _temp[i] = byte(uint(_temp[i]) + 32);
1709 
1710                 // we have a non number
1711                 if (_hasNonNumber == false)
1712                     _hasNonNumber = true;
1713             } else {
1714                 require
1715                 (
1716                 // require character is a space
1717                     _temp[i] == 0x20 ||
1718                 // OR lowercase a-z
1719                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1720                 // or 0-9
1721                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1722                     "string contains invalid characters"
1723                 );
1724                 // make sure theres not 2x spaces in a row
1725                 if (_temp[i] == 0x20)
1726                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1727 
1728                 // see if we have a character other than a number
1729                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1730                     _hasNonNumber = true;
1731             }
1732         }
1733 
1734         require(_hasNonNumber == true, "string cannot be only numbers");
1735 
1736         bytes32 _ret;
1737         assembly {
1738             _ret := mload(add(_temp, 32))
1739         }
1740         return (_ret);
1741     }
1742 }
1743 
1744 /**
1745  * @title SafeMath v0.1.9
1746  * @dev Math operations with safety checks that throw on error
1747  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1748  * - added sqrt
1749  * - added sq
1750  * - added pwr
1751  * - changed asserts to requires with error log outputs
1752  * - removed div, its useless
1753  */
1754 library SafeMath {
1755 
1756     /**
1757     * @dev Multiplies two numbers, throws on overflow.
1758     */
1759     function mul(uint256 a, uint256 b)
1760     internal
1761     pure
1762     returns (uint256 c)
1763     {
1764         if (a == 0) {
1765             return 0;
1766         }
1767         c = a * b;
1768         require(c / a == b, "SafeMath mul failed");
1769         return c;
1770     }
1771 
1772     /**
1773     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1774     */
1775     function sub(uint256 a, uint256 b)
1776     internal
1777     pure
1778     returns (uint256)
1779     {
1780         require(b <= a, "SafeMath sub failed");
1781         return a - b;
1782     }
1783 
1784     /**
1785     * @dev Adds two numbers, throws on overflow.
1786     */
1787     function add(uint256 a, uint256 b)
1788     internal
1789     pure
1790     returns (uint256 c)
1791     {
1792         c = a + b;
1793         require(c >= a, "SafeMath add failed");
1794         return c;
1795     }
1796 
1797     /**
1798      * @dev gives square root of given x.
1799      */
1800     function sqrt(uint256 x)
1801     internal
1802     pure
1803     returns (uint256 y)
1804     {
1805         uint256 z = ((add(x,1)) / 2);
1806         y = x;
1807         while (z < y)
1808         {
1809             y = z;
1810             z = ((add((x / z),z)) / 2);
1811         }
1812     }
1813 
1814     /**
1815      * @dev gives square. multiplies x by x
1816      */
1817     function sq(uint256 x)
1818     internal
1819     pure
1820     returns (uint256)
1821     {
1822         return (mul(x,x));
1823     }
1824 
1825     /**
1826      * @dev x to the power of y
1827      */
1828     function pwr(uint256 x, uint256 y)
1829     internal
1830     pure
1831     returns (uint256)
1832     {
1833         if (x==0)
1834             return (0);
1835         else if (y==0)
1836             return (1);
1837         else
1838         {
1839             uint256 z = x;
1840             for (uint256 i=1; i < y; i++)
1841                 z = mul(z,x);
1842             return (z);
1843         }
1844     }
1845 }