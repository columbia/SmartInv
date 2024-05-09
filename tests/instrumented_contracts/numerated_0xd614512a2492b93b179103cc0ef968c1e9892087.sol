1 pragma solidity ^0.4.24;
2 
3 
4 contract F3Devents {
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
32         uint256 P3DAmount,
33         uint256 genAmount,
34         uint256 potAmount,
35         uint256 airDropPot
36     );
37 
38     // fired whenever theres a withdraw
39     event onWithdraw
40     (
41         uint256 indexed playerID,
42         address playerAddress,
43         bytes32 playerName,
44         uint256 ethOut,
45         uint256 timeStamp
46     );
47 
48     // fired whenever a withdraw forces end round to be ran
49     event onWithdrawAndDistribute
50     (
51         address playerAddress,
52         bytes32 playerName,
53         uint256 ethOut,
54         uint256 compressedData,
55         uint256 compressedIDs,
56         address winnerAddr,
57         bytes32 winnerName,
58         uint256 amountWon,
59         uint256 newPot,
60         uint256 P3DAmount,
61         uint256 genAmount
62     );
63 
64     // (fomo3d long only) fired whenever a player tries a buy after round timer
65     // hit zero, and causes end round to be ran.
66     event onBuyAndDistribute
67     (
68         address playerAddress,
69         bytes32 playerName,
70         uint256 ethIn,
71         uint256 compressedData,
72         uint256 compressedIDs,
73         address winnerAddr,
74         bytes32 winnerName,
75         uint256 amountWon,
76         uint256 newPot,
77         uint256 P3DAmount,
78         uint256 genAmount
79     );
80 
81     // (fomo3d long only) fired whenever a player tries a reload after round timer
82     // hit zero, and causes end round to be ran.
83     event onReLoadAndDistribute
84     (
85         address playerAddress,
86         bytes32 playerName,
87         uint256 compressedData,
88         uint256 compressedIDs,
89         address winnerAddr,
90         bytes32 winnerName,
91         uint256 amountWon,
92         uint256 newPot,
93         uint256 P3DAmount,
94         uint256 genAmount
95     );
96 
97     // fired whenever an affiliate is paid
98     event onAffiliatePayout
99     (
100         uint256 indexed affiliateID,
101         address affiliateAddress,
102         bytes32 affiliateName,
103         uint256 indexed roundID,
104         uint256 indexed buyerID,
105         uint256 amount,
106         uint256 timeStamp
107     );
108 
109     // received pot swap deposit
110     event onPotSwapDeposit
111     (
112         uint256 roundID,
113         uint256 amountAddedToPot
114     );
115 
116     event Voted(uint256 _pID,uint256 _rID, bool _voted,uint256 _keys);
117 }
118 
119 
120 
121 contract FoMo3Dlong is F3Devents {
122     using SafeMath for *;
123     using NameFilter for string;
124     using F3DKeysCalcLong for uint256;
125 
126     address private com = 0x457E2fEfa7d17cc6738356543e8CC1Ace8be82A2; // community distribution address
127     address private admin = msg.sender;
128 
129     bool RoundVoting = false;
130 
131     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x71Ac32e157a54D990BED4aE611580AA5238193AB);
132 
133 //==============================================================================
134 //     _ _  _  |`. _     _ _ |_ | _  _  .
135 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
136 //=================_|===========================================================
137     string constant public name = "XMG Long Official";
138     string constant public symbol = "XMG";
139     uint256 private rndExtra_ = 0;     // length of the very first ICO
140     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
141     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
142     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
143     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
144 //==============================================================================
145 //     _| _ _|_ _    _ _ _|_    _   .
146 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
147 //=============================|================================================
148     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
149     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
150     uint256 public rID_;    // round id number / total rounds that have happened
151 //****************
152 // PLAYER DATA
153 //****************
154     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
155     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
156     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
157     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
158     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
159 //****************
160 // ROUND DATA
161 //****************
162     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
163     mapping (uint256 => uint256) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
164 //****************
165 // VOTING DATA
166 //****************
167     mapping(uint256 => mapping(uint256 => bool)) VotePidRid_;   // plyId => Rid => voted
168     mapping(uint256 => F3Ddatasets.votingData) roundVotingData;
169 
170 //****************
171 // TEAM FEE DATA
172 //****************
173     F3Ddatasets.TeamFee public fees_;          // (team => fees) fee distribution by team
174     F3Ddatasets.PotSplit public potSplit_;     // (team => fees) pot split distribution by team
175 //==============================================================================
176 //     _ _  _  __|_ _    __|_ _  _  .
177 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
178 //==============================================================================
179     constructor()
180         public
181     {
182         // Team allocation structures
183         // 0 = whales
184         // 1 = bears
185         // 2 = sneks
186         // 3 = bulls
187 
188         // Team allocation percentages
189         // (F3D, P3D) + (Pot , Referrals, Community)
190             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
191         fees_ = F3Ddatasets.TeamFee(54,0,20,15,1);   //15% to pot, 10% to aff, 15% to com
192 
193 
194         // how to split up the final pot based on which team was picked
195         // (F3D, P3D)
196         potSplit_ = F3Ddatasets.PotSplit(50,0);  //48% to winner,  2% to com
197 
198     }
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
233     modifier checkVoting(uint256 _pID,uint256 _rID){
234         require(VotePidRid_[_pID][_rID] != true,"You have already voted");
235         _;
236     }
237 
238     modifier canVoting(){
239         require(RoundVoting == true,"The voting has not started yet");
240         _;
241     }
242 
243     modifier isPlayer(uint256 _pID, uint256 _rID){
244         require(plyrRnds_[_pID][_rID].keys > 0, "Please buy the key and vote again.");
245         _;
246     }
247 
248 //==============================================================================
249 //     _    |_ |. _   |`    _  __|_. _  _  _  .
250 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
251 //====|=========================================================================
252     /**
253      * @dev emergency buy uses last stored affiliate ID and team snek
254      */
255     function()
256         isActivated()
257         isHuman()
258         isWithinLimits(msg.value)
259         public
260         payable
261     {
262         // set up our tx event data and determine if player is new or not
263         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
264 
265         // fetch player id
266         uint256 _pID = pIDxAddr_[msg.sender];
267 
268         // buy core
269         buyCore(_pID, plyr_[_pID].laff, _eventData_);
270     }
271 
272     /**
273      * @dev converts all incoming ethereum to keys.
274      * -functionhash- 0x8f38f309 (using ID for affiliate)
275      * -functionhash- 0x98a0871d (using address for affiliate)
276      * -functionhash- 0xa65b37a1 (using name for affiliate)
277      * @param _affCode the ID/address/name of the player who gets the affiliate fee
278      */
279     function buyXid(uint256 _affCode)
280         isActivated()
281         isHuman()
282         isWithinLimits(msg.value)
283         public
284         payable
285     {
286         // set up our tx event data and determine if player is new or not
287         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
288 
289         // fetch player id
290         uint256 _pID = pIDxAddr_[msg.sender];
291 
292         // manage affiliate residuals
293         // if no affiliate code was given or player tried to use their own, lolz
294         if (_affCode == 0 || _affCode == _pID)
295         {
296             // use last stored affiliate code
297             _affCode = plyr_[_pID].laff;
298 
299         // if affiliate code was given & its not the same as previously stored
300         } else if (_affCode != plyr_[_pID].laff) {
301             // update last affiliate
302             plyr_[_pID].laff = _affCode;
303         }
304 
305         // buy core
306         buyCore(_pID, _affCode, _eventData_);
307     }
308 
309     function buyXaddr(address _affCode)
310         isActivated()
311         isHuman()
312         isWithinLimits(msg.value)
313         public
314         payable
315     {
316         // set up our tx event data and determine if player is new or not
317         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
318 
319         // fetch player id
320         uint256 _pID = pIDxAddr_[msg.sender];
321 
322         // manage affiliate residuals
323         uint256 _affID;
324         // if no affiliate code was given or player tried to use their own, lolz
325         if (_affCode == address(0) || _affCode == msg.sender)
326         {
327             // use last stored affiliate code
328             _affID = plyr_[_pID].laff;
329 
330         // if affiliate code was given
331         } else {
332             // get affiliate ID from aff Code
333             _affID = pIDxAddr_[_affCode];
334 
335             // if affID is not the same as previously stored
336             if (_affID != plyr_[_pID].laff)
337             {
338                 // update last affiliate
339                 plyr_[_pID].laff = _affID;
340             }
341         }
342 
343 
344         // buy core
345         buyCore(_pID, _affID, _eventData_);
346     }
347 
348     function buyXname(bytes32 _affCode)
349         isActivated()
350         isHuman()
351         isWithinLimits(msg.value)
352         public
353         payable
354     {
355         // set up our tx event data and determine if player is new or not
356         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
357 
358         // fetch player id
359         uint256 _pID = pIDxAddr_[msg.sender];
360 
361         // manage affiliate residuals
362         uint256 _affID;
363         // if no affiliate code was given or player tried to use their own, lolz
364         if (_affCode == '' || _affCode == plyr_[_pID].name)
365         {
366             // use last stored affiliate code
367             _affID = plyr_[_pID].laff;
368 
369         // if affiliate code was given
370         } else {
371             // get affiliate ID from aff Code
372             _affID = pIDxName_[_affCode];
373 
374             // if affID is not the same as previously stored
375             if (_affID != plyr_[_pID].laff)
376             {
377                 // update last affiliate
378                 plyr_[_pID].laff = _affID;
379             }
380         }
381 
382         // buy core
383         buyCore(_pID, _affID, _eventData_);
384     }
385 
386     /**
387      * @dev essentially the same as buy, but instead of you sending ether
388      * from your wallet, it uses your unwithdrawn earnings.
389      * -functionhash- 0x349cdcac (using ID for affiliate)
390      * -functionhash- 0x82bfc739 (using address for affiliate)
391      * -functionhash- 0x079ce327 (using name for affiliate)
392      * @param _affCode the ID/address/name of the player who gets the affiliate fee
393      * @param _eth amount of earnings to use (remainder returned to gen vault)
394      */
395     function reLoadXid(uint256 _affCode, uint256 _eth)
396         isActivated()
397         isHuman()
398         isWithinLimits(_eth)
399         public
400     {
401         // set up our tx event data
402         F3Ddatasets.EventReturns memory _eventData_;
403 
404         // fetch player ID
405         uint256 _pID = pIDxAddr_[msg.sender];
406 
407         // manage affiliate residuals
408         // if no affiliate code was given or player tried to use their own, lolz
409         if (_affCode == 0 || _affCode == _pID)
410         {
411             // use last stored affiliate code
412             _affCode = plyr_[_pID].laff;
413 
414         // if affiliate code was given & its not the same as previously stored
415         } else if (_affCode != plyr_[_pID].laff) {
416             // update last affiliate
417             plyr_[_pID].laff = _affCode;
418         }
419 
420         // reload core
421         reLoadCore(_pID, _affCode, _eth, _eventData_);
422     }
423 
424     function reLoadXaddr(address _affCode, uint256 _eth)
425         isActivated()
426         isHuman()
427         isWithinLimits(_eth)
428         public
429     {
430         // set up our tx event data
431         F3Ddatasets.EventReturns memory _eventData_;
432 
433         // fetch player ID
434         uint256 _pID = pIDxAddr_[msg.sender];
435 
436         // manage affiliate residuals
437         uint256 _affID;
438         // if no affiliate code was given or player tried to use their own, lolz
439         if (_affCode == address(0) || _affCode == msg.sender)
440         {
441             // use last stored affiliate code
442             _affID = plyr_[_pID].laff;
443 
444         // if affiliate code was given
445         } else {
446             // get affiliate ID from aff Code
447             _affID = pIDxAddr_[_affCode];
448 
449             // if affID is not the same as previously stored
450             if (_affID != plyr_[_pID].laff)
451             {
452                 // update last affiliate
453                 plyr_[_pID].laff = _affID;
454             }
455         }
456 
457         // reload core
458         reLoadCore(_pID, _affID, _eth, _eventData_);
459     }
460 
461     function reLoadXname(bytes32 _affCode, uint256 _eth)
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
494         // reload core
495         reLoadCore(_pID, _affID, _eth, _eventData_);
496     }
497 
498     /**
499      * @dev withdraws all of your earnings.
500      * -functionhash- 0x3ccfd60b
501      */
502     function withdraw()
503         isActivated()
504         isHuman()
505         public
506     {
507         // setup local rID
508         uint256 _rID = rID_;
509 
510         // grab time
511         uint256 _now = now;
512 
513         // fetch player ID
514         uint256 _pID = pIDxAddr_[msg.sender];
515 
516         // setup temp var for player eth
517         uint256 _eth;
518 
519         // check to see if round has ended and no one has run round end yet
520         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
521         {
522             // set up our tx event data
523             F3Ddatasets.EventReturns memory _eventData_;
524 
525             // end the round (distributes pot)
526             round_[_rID].ended = true;
527             _eventData_ = endRound(_eventData_);
528 
529             // get their earnings
530             _eth = withdrawEarnings(_pID);
531 
532             // gib moni
533             if (_eth > 0)
534                 plyr_[_pID].addr.transfer(_eth);
535 
536             // build event data
537             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
538             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
539 
540             // fire withdraw and distribute event
541             emit F3Devents.onWithdrawAndDistribute
542             (
543                 msg.sender,
544                 plyr_[_pID].name,
545                 _eth,
546                 _eventData_.compressedData,
547                 _eventData_.compressedIDs,
548                 _eventData_.winnerAddr,
549                 _eventData_.winnerName,
550                 _eventData_.amountWon,
551                 _eventData_.newPot,
552                 _eventData_.P3DAmount,
553                 _eventData_.genAmount
554             );
555 
556         // in any other situation
557         } else {
558             // get their earnings
559             _eth = withdrawEarnings(_pID);
560 
561             // gib moni
562             if (_eth > 0)
563                 plyr_[_pID].addr.transfer(_eth);
564 
565             // fire withdraw event
566             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
567         }
568     }
569 
570     /**
571      * @dev use these to register names.  they are just wrappers that will send the
572      * registration requests to the PlayerBook contract.  So registering here is the
573      * same as registering there.  UI will always display the last name you registered.
574      * but you will still own all previously registered names to use as affiliate
575      * links.
576      * - must pay a registration fee.
577      * - name must be unique
578      * - names will be converted to lowercase
579      * - name cannot start or end with a space
580      * - cannot have more than 1 space in a row
581      * - cannot be only numbers
582      * - cannot start with 0x
583      * - name must be at least 1 char
584      * - max length of 32 characters long
585      * - allowed characters: a-z, 0-9, and space
586      * -functionhash- 0x921dec21 (using ID for affiliate)
587      * -functionhash- 0x3ddd4698 (using address for affiliate)
588      * -functionhash- 0x685ffd83 (using name for affiliate)
589      * @param _nameString players desired name
590      * @param _affCode affiliate ID, address, or name of who referred you
591      * @param _all set to true if you want this to push your info to all games
592      * (this might cost a lot of gas)
593      */
594     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
595         isHuman()
596         public
597         payable
598     {
599         bytes32 _name = _nameString.nameFilter();
600         address _addr = msg.sender;
601         uint256 _paid = msg.value;
602         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
603 
604         uint256 _pID = pIDxAddr_[_addr];
605 
606         // fire event
607         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
608     }
609 
610     function registerNameXaddr(string _nameString, address _affCode, bool _all)
611         isHuman()
612         public
613         payable
614     {
615         bytes32 _name = _nameString.nameFilter();
616         address _addr = msg.sender;
617         uint256 _paid = msg.value;
618         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
619 
620         uint256 _pID = pIDxAddr_[_addr];
621 
622         // fire event
623         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
624     }
625 
626     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
627         isHuman()
628         public
629         payable
630     {
631         bytes32 _name = _nameString.nameFilter();
632         address _addr = msg.sender;
633         uint256 _paid = msg.value;
634         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
635 
636         uint256 _pID = pIDxAddr_[_addr];
637 
638         // fire event
639         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
640     }
641 //==============================================================================
642 //     _  _ _|__|_ _  _ _  .
643 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
644 //=====_|=======================================================================
645     /**
646      * @dev return the price buyer will pay for next 1 individual key.
647      * -functionhash- 0x018a25e8
648      * @return price for next key bought (in wei format)
649      */
650     function getBuyPrice()
651         public
652         view
653         returns(uint256)
654     {
655         // setup local rID
656         uint256 _rID = rID_;
657 
658         // grab time
659         uint256 _now = now;
660 
661         // are we in a round?
662         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
663             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
664         else // rounds over.  need price for new round
665             return ( 75000000000000 ); // init
666     }
667 
668     /**
669      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
670      * provider
671      * -functionhash- 0xc7e284b8
672      * @return time left in seconds
673      */
674     function getTimeLeft()
675         public
676         view
677         returns(uint256)
678     {
679         // setup local rID
680         uint256 _rID = rID_;
681 
682         // grab time
683         uint256 _now = now;
684 
685         if (_now < round_[_rID].end)
686             if (_now > round_[_rID].strt + rndGap_)
687                 return( (round_[_rID].end).sub(_now) );
688             else
689                 return( (round_[_rID].strt + rndGap_).sub(_now) );
690         else
691             return(0);
692     }
693 
694     /**
695      * @dev returns player earnings per vaults
696      * -functionhash- 0x63066434
697      * @return winnings vault
698      * @return general vault
699      * @return affiliate vault
700      */
701     function getPlayerVaults(uint256 _pID)
702         public
703         view
704         returns(uint256 ,uint256, uint256)
705     {
706         // setup local rID
707         uint256 _rID = rID_;
708 
709         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
710         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
711         {
712             // if player is winner
713             if (round_[_rID].plyr == _pID)
714             {
715                 return
716                 (
717                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
718                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
719                     plyr_[_pID].aff
720                 );
721             // if player is not the winner
722             } else {
723                 return
724                 (
725                     plyr_[_pID].win,
726                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
727                     plyr_[_pID].aff
728                 );
729             }
730 
731         // if round is still going on, or round has ended and round end has been ran
732         } else {
733             return
734             (
735                 plyr_[_pID].win,
736                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
737                 plyr_[_pID].aff
738             );
739         }
740     }
741 
742     /**
743      * solidity hates stack limits.  this lets us avoid that hate
744      */
745     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
746         private
747         view
748         returns(uint256)
749     {
750         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_.gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
751     }
752 
753     /**
754      * @dev returns all current round info needed for front end
755      * -functionhash- 0x747dff42
756      * @return eth invested during ICO phase
757      * @return round id
758      * @return total keys for round
759      * @return time round ends
760      * @return time round started
761      * @return current pot
762      * @return current team ID & player ID in lead
763      * @return current player in leads address
764      * @return current player in leads name
765      * @return whales eth in for round
766      * @return bears eth in for round
767      * @return sneks eth in for round
768      * @return bulls eth in for round
769      * @return airdrop tracker # & airdrop pot
770      */
771     function getCurrentRoundInfo()
772         public
773         view
774         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
775     {
776         // setup local rID
777         uint256 _rID = rID_;
778 
779         return
780         (
781             round_[_rID].ico,               //0
782             _rID,                           //1
783             round_[_rID].keys,              //2
784             round_[_rID].end,               //3
785             round_[_rID].strt,              //4
786             round_[_rID].pot,               //5
787             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
788             plyr_[round_[_rID].plyr].addr,  //7
789             plyr_[round_[_rID].plyr].name,  //8
790             rndTmEth_[_rID],             //9
791             0,             //10
792             0,             //11
793             0,             //12
794             airDropTracker_ + (airDropPot_ * 1000)              //13
795         );
796     }
797 
798     /**
799      * @dev returns player info based on address.  if no address is given, it will
800      * use msg.sender
801      * -functionhash- 0xee0b5d8b
802      * @param _addr address of the player you want to lookup
803      * @return player ID
804      * @return player name
805      * @return keys owned (current round)
806      * @return winnings vault
807      * @return general vault
808      * @return affiliate vault
809      * @return player round eth
810      */
811     function getPlayerInfoByAddress(address _addr)
812         public
813         view
814         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
815     {
816         // setup local rID
817         uint256 _rID = rID_;
818 
819         if (_addr == address(0))
820         {
821             _addr == msg.sender;
822         }
823         uint256 _pID = pIDxAddr_[_addr];
824 
825         return
826         (
827             _pID,                               //0
828             plyr_[_pID].name,                   //1
829             plyrRnds_[_pID][_rID].keys,         //2
830             plyr_[_pID].win,                    //3
831             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
832             plyr_[_pID].aff,                    //5
833             plyrRnds_[_pID][_rID].eth           //6
834         );
835     }
836 
837 //==============================================================================
838 //     _ _  _ _   | _  _ . _  .
839 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
840 //=====================_|=======================================================
841     /**
842      * @dev logic runs whenever a buy order is executed.  determines how to handle
843      * incoming eth depending on if we are in an active round or not
844      */
845     function buyCore(uint256 _pID, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
846         private
847     {
848         // setup local rID
849         uint256 _rID = rID_;
850 
851         // grab time
852         uint256 _now = now;
853 
854 
855 
856         // if round is active
857         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
858         {
859             // call core
860             core(_rID, _pID, msg.value, _affID, _eventData_);
861 
862             if(round_[_rID].pot > 10000000000000000000000 && RoundVoting == false){
863                 RoundVoting = true;
864                 roundVotingData[_rID].VotingEndTime = _now.add(rndMax_);
865             }
866 
867             if(_now > roundVotingData[_rID].VotingEndTime && RoundVoting == true){
868 
869                 uint256 _agree = roundVotingData[_rID].agress;
870                 uint256 _oppose = roundVotingData[_rID].oppose;
871 
872                 if((_agree.mul(100)).div((_agree+_oppose)) > 67){
873                     round_[_rID].ended = true;
874                     _eventData_ = endRound(_eventData_);
875 
876                     // build event data
877                     _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
878                     _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
879 
880                     // fire buy and distribute event
881                     emit F3Devents.onBuyAndDistribute
882                     (
883                         msg.sender,
884                         plyr_[_pID].name,
885                         msg.value,
886                         _eventData_.compressedData,
887                         _eventData_.compressedIDs,
888                         _eventData_.winnerAddr,
889                         _eventData_.winnerName,
890                         _eventData_.amountWon,
891                         _eventData_.newPot,
892                         _eventData_.P3DAmount,
893                         _eventData_.genAmount
894                     );
895                     // put eth in players vault
896                     plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
897                 }
898             }
899 
900         // if round is not active
901         } else {
902             // check to see if end round needs to be ran
903             if (_now > round_[_rID].end && round_[_rID].ended == false)
904             {
905                 // end the round (distributes pot) & start new round
906                 round_[_rID].ended = true;
907                 _eventData_ = endRound(_eventData_);
908 
909                 // build event data
910                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
911                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
912 
913                 // fire buy and distribute event
914                 emit F3Devents.onBuyAndDistribute
915                 (
916                     msg.sender,
917                     plyr_[_pID].name,
918                     msg.value,
919                     _eventData_.compressedData,
920                     _eventData_.compressedIDs,
921                     _eventData_.winnerAddr,
922                     _eventData_.winnerName,
923                     _eventData_.amountWon,
924                     _eventData_.newPot,
925                     _eventData_.P3DAmount,
926                     _eventData_.genAmount
927                 );
928             }
929 
930             // put eth in players vault
931             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
932         }
933     }
934 
935     /**
936      * @dev logic runs whenever a reload order is executed.  determines how to handle
937      * incoming eth depending on if we are in an active round or not
938      */
939     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
940         private
941     {
942         // setup local rID
943         uint256 _rID = rID_;
944 
945         // grab time
946         uint256 _now = now;
947 
948         // if round is active
949         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
950         {
951             // get earnings from all vaults and return unused to gen vault
952             // because we use a custom safemath library.  this will throw if player
953             // tried to spend more eth than they have.
954             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
955 
956             // call core
957             core(_rID, _pID, _eth, _affID, _eventData_);
958 
959             if(round_[_rID].pot > 10000000000000000000000 && RoundVoting == false){
960                 RoundVoting = true;
961                 roundVotingData[_rID].VotingEndTime = _now.add(rndMax_);
962             }
963 
964             if(_now > roundVotingData[_rID].VotingEndTime && RoundVoting == true){
965 
966 
967                 uint256 _agree = roundVotingData[_rID].agress;
968                 uint256 _oppose = roundVotingData[_rID].oppose;
969 
970                 if((_agree.mul(100)).div((_agree+_oppose)) > 67){
971                     round_[_rID].ended = true;
972                     _eventData_ = endRound(_eventData_);
973 
974                     // build event data
975                     _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
976                     _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
977 
978                     // fire buy and distribute event
979                     emit F3Devents.onBuyAndDistribute
980                     (
981                         msg.sender,
982                         plyr_[_pID].name,
983                         msg.value,
984                         _eventData_.compressedData,
985                         _eventData_.compressedIDs,
986                         _eventData_.winnerAddr,
987                         _eventData_.winnerName,
988                         _eventData_.amountWon,
989                         _eventData_.newPot,
990                         _eventData_.P3DAmount,
991                         _eventData_.genAmount
992                     );
993                 }
994             }
995         // if round is not active and end round needs to be ran
996         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
997             // end the round (distributes pot) & start new round
998             round_[_rID].ended = true;
999             _eventData_ = endRound(_eventData_);
1000 
1001             // build event data
1002             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1003             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1004 
1005             // fire buy and distribute event
1006             emit F3Devents.onReLoadAndDistribute
1007             (
1008                 msg.sender,
1009                 plyr_[_pID].name,
1010                 _eventData_.compressedData,
1011                 _eventData_.compressedIDs,
1012                 _eventData_.winnerAddr,
1013                 _eventData_.winnerName,
1014                 _eventData_.amountWon,
1015                 _eventData_.newPot,
1016                 _eventData_.P3DAmount,
1017                 _eventData_.genAmount
1018             );
1019         }
1020     }
1021 
1022     /**
1023      * @dev this is the core logic for any buy/reload that happens while a round
1024      * is live.
1025      */
1026     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
1027         private
1028     {
1029         // if player is new to round
1030         if (plyrRnds_[_pID][_rID].keys == 0)
1031             _eventData_ = managePlayer(_pID, _eventData_);
1032 
1033         // early round eth limiter
1034         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1035         {
1036             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1037             uint256 _refund = _eth.sub(_availableLimit);
1038             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1039             _eth = _availableLimit;
1040         }
1041 
1042         // if eth left is greater than min eth allowed (sorry no pocket lint)
1043         if (_eth > 1000000000)
1044         {
1045 
1046             // mint the new keys
1047             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1048 
1049             // if they bought at least 1 whole key
1050             if (_keys >= 1000000000000000000)
1051             {
1052             updateTimer(_keys, _rID);
1053 
1054             // set new leaders
1055             if (round_[_rID].plyr != _pID)
1056                 round_[_rID].plyr = _pID;
1057 
1058 
1059             // set the new leader bool to true
1060             _eventData_.compressedData = _eventData_.compressedData + 100;
1061         }
1062 
1063             // manage airdrops
1064             if (_eth >= 100000000000000000)
1065             {
1066             airDropTracker_++;
1067             if (airdrop() == true && airDropPot_ > 250000000000000000)
1068             {
1069                 // gib muni
1070                 uint256 _prize  = 250000000000000000;
1071                 if (_eth >= 10000000000000000000)
1072                 {
1073                     // calculate prize and give it to winner
1074 
1075                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1076 
1077                     // adjust airDropPot
1078                     airDropPot_ = (airDropPot_).sub(_prize);
1079 
1080                     // let event know a tier 3 prize was won
1081                     _eventData_.compressedData += 300000000000000000000000000000000;
1082                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1083                     // calculate prize and give it to winner
1084                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1085 
1086                     // adjust airDropPot
1087                     airDropPot_ = (airDropPot_).sub(_prize);
1088 
1089                     // let event know a tier 2 prize was won
1090                     _eventData_.compressedData += 200000000000000000000000000000000;
1091                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1092                     // calculate prize and give it to winner
1093                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1094 
1095                     // adjust airDropPot
1096                     airDropPot_ = (airDropPot_).sub(_prize);
1097 
1098                     // let event know a tier 3 prize was won
1099                     _eventData_.compressedData += 300000000000000000000000000000000;
1100                 }
1101                 // set airdrop happened bool to true
1102                 _eventData_.compressedData += 10000000000000000000000000000000;
1103                 // let event know how much was won
1104                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1105 
1106                 // reset air drop tracker
1107                 airDropTracker_ = 0;
1108             }
1109         }
1110 
1111             // store the air drop tracker number (number of buys since last airdrop)
1112             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1113 
1114             // update player
1115             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1116             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1117 
1118             // update round
1119             round_[_rID].keys = _keys.add(round_[_rID].keys);
1120             round_[_rID].eth = _eth.add(round_[_rID].eth);
1121             rndTmEth_[_rID] = _eth.add(rndTmEth_[_rID]);
1122 
1123             // distribute eth
1124             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
1125             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
1126 
1127             // call end tx function to fire end tx event.
1128             endTx(_pID, _eth, _keys, _eventData_);
1129         }
1130     }
1131 //==============================================================================
1132 //     _ _ | _   | _ _|_ _  _ _  .
1133 //    (_(_||(_|_||(_| | (_)| _\  .
1134 //==============================================================================
1135     /**
1136      * @dev calculates unmasked earnings (just calculates, does not update mask)
1137      * @return earnings in wei format
1138      */
1139     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1140         private
1141         view
1142         returns(uint256)
1143     {
1144         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1145     }
1146 
1147     /**
1148      * @dev returns the amount of keys you would get given an amount of eth.
1149      * -functionhash- 0xce89c80c
1150      * @param _rID round ID you want price for
1151      * @param _eth amount of eth sent in
1152      * @return keys received
1153      */
1154     function calcKeysReceived(uint256 _rID, uint256 _eth)
1155         public
1156         view
1157         returns(uint256)
1158     {
1159         // grab time
1160         uint256 _now = now;
1161 
1162         // are we in a round?
1163         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1164             return ( (round_[_rID].eth).keysRec(_eth) );
1165         else // rounds over.  need keys for new round
1166             return ( (_eth).keys() );
1167     }
1168 
1169     /**
1170      * @dev returns current eth price for X keys.
1171      * -functionhash- 0xcf808000
1172      * @param _keys number of keys desired (in 18 decimal format)
1173      * @return amount of eth needed to send
1174      */
1175     function iWantXKeys(uint256 _keys)
1176         public
1177         view
1178         returns(uint256)
1179     {
1180         // setup local rID
1181         uint256 _rID = rID_;
1182 
1183         // grab time
1184         uint256 _now = now;
1185 
1186         // are we in a round?
1187         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1188             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1189         else // rounds over.  need price for new round
1190             return ( (_keys).eth() );
1191     }
1192 //==============================================================================
1193 //    _|_ _  _ | _  .
1194 //     | (_)(_)|_\  .
1195 //==============================================================================
1196     /**
1197      * @dev receives name/player info from names contract
1198      */
1199     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1200         external
1201     {
1202         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1203         if (pIDxAddr_[_addr] != _pID)
1204             pIDxAddr_[_addr] = _pID;
1205         if (pIDxName_[_name] != _pID)
1206             pIDxName_[_name] = _pID;
1207         if (plyr_[_pID].addr != _addr)
1208             plyr_[_pID].addr = _addr;
1209         if (plyr_[_pID].name != _name)
1210             plyr_[_pID].name = _name;
1211         if (plyr_[_pID].laff != _laff)
1212             plyr_[_pID].laff = _laff;
1213         if (plyrNames_[_pID][_name] == false)
1214             plyrNames_[_pID][_name] = true;
1215     }
1216 
1217     /**
1218      * @dev receives entire player name list
1219      */
1220     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1221         external
1222     {
1223         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1224         if(plyrNames_[_pID][_name] == false)
1225             plyrNames_[_pID][_name] = true;
1226     }
1227 
1228     /**
1229      * @dev gets existing or registers new pID.  use this when a player may be new
1230      * @return pID
1231      */
1232     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1233         private
1234         returns (F3Ddatasets.EventReturns)
1235     {
1236         uint256 _pID = pIDxAddr_[msg.sender];
1237         // if player is new to this version of fomo3d
1238         if (_pID == 0)
1239         {
1240             // grab their player ID, name and last aff ID, from player names contract
1241             _pID = PlayerBook.getPlayerID(msg.sender);
1242             bytes32 _name = PlayerBook.getPlayerName(_pID);
1243             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1244 
1245             // set up player account
1246             pIDxAddr_[msg.sender] = _pID;
1247             plyr_[_pID].addr = msg.sender;
1248 
1249             if (_name != "")
1250             {
1251                 pIDxName_[_name] = _pID;
1252                 plyr_[_pID].name = _name;
1253                 plyrNames_[_pID][_name] = true;
1254             }
1255 
1256             if (_laff != 0 && _laff != _pID)
1257                 plyr_[_pID].laff = _laff;
1258 
1259             // set the new player bool to true
1260             _eventData_.compressedData = _eventData_.compressedData + 1;
1261         }
1262         return (_eventData_);
1263     }
1264 
1265 
1266 
1267     /**
1268      * @dev decides if round end needs to be run & new round started.  and if
1269      * player unmasked earnings from previously played rounds need to be moved.
1270      */
1271     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1272         private
1273         returns (F3Ddatasets.EventReturns)
1274     {
1275         // if player has played a previous round, move their unmasked earnings
1276         // from that round to gen vault.
1277         if (plyr_[_pID].lrnd != 0)
1278             updateGenVault(_pID, plyr_[_pID].lrnd);
1279 
1280         // update player's last round played
1281         plyr_[_pID].lrnd = rID_;
1282 
1283         // set the joined round bool to true
1284         _eventData_.compressedData = _eventData_.compressedData + 10;
1285 
1286         return(_eventData_);
1287     }
1288 
1289     /**
1290      * @dev ends the round. manages paying out winner/splitting up pot
1291      */
1292     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1293         private
1294         returns (F3Ddatasets.EventReturns)
1295     {
1296         // setup local rID
1297         uint256 _rID = rID_;
1298 
1299         // grab our winning player and team id's
1300         uint256 _winPID = round_[_rID].plyr;
1301         uint256 _winTID = round_[_rID].team;
1302 
1303         // grab our pot amount
1304         uint256 _pot = round_[_rID].pot;
1305 
1306         // calculate our winner share, community rewards, gen share,
1307         // p3d share, and amount reserved for next pot
1308         uint256 _win = (_pot.mul(48)) / 100;
1309         uint256 _com = (_pot / 50);
1310         uint256 _gen = (_pot.mul(potSplit_.gen)) / 100;
1311         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1312 
1313         // calculate ppt for round mask
1314         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1315         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1316         if (_dust > 0)
1317         {
1318             _gen = _gen.sub(_dust);
1319             _res = _res.add(_dust);
1320         }
1321 
1322         // pay our winner
1323         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1324 
1325         // community rewards
1326         com.transfer(_com);
1327 
1328         // distribute gen portion to key holders
1329         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1330 
1331         // prepare event data
1332         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1333         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1334         _eventData_.winnerAddr = plyr_[_winPID].addr;
1335         _eventData_.winnerName = plyr_[_winPID].name;
1336         _eventData_.amountWon = _win;
1337         _eventData_.genAmount = _gen;
1338         _eventData_.P3DAmount = 0;
1339         _eventData_.newPot = _res;
1340 
1341         // start next round
1342         rID_++;
1343         _rID++;
1344         round_[_rID].strt = now;
1345         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1346         round_[_rID].pot = _res;
1347         RoundVoting == false;
1348         return(_eventData_);
1349     }
1350 
1351     /**
1352      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1353      */
1354     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1355         private
1356     {
1357         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1358         if (_earnings > 0)
1359         {
1360             // put in gen vault
1361             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1362             // zero out their earnings by updating mask
1363             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1364         }
1365     }
1366 
1367     /**
1368      * @dev updates round timer based on number of whole keys bought.
1369      */
1370     function updateTimer(uint256 _keys, uint256 _rID)
1371         private
1372     {
1373         // grab time
1374         uint256 _now = now;
1375 
1376         // calculate time based on number of keys bought
1377         uint256 _newTime;
1378         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1379             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1380         else
1381             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1382 
1383         // compare to max and set new end time
1384         if (_newTime < (rndMax_).add(_now))
1385             round_[_rID].end = _newTime;
1386         else
1387             round_[_rID].end = rndMax_.add(_now);
1388     }
1389 
1390     /**
1391      * @dev generates a random number between 0-99 and checks to see if thats
1392      * resulted in an airdrop win
1393      * @return do we have a winner?
1394      */
1395     function airdrop()
1396         private
1397         view
1398         returns(bool)
1399     {
1400         uint256 seed = uint256(keccak256(abi.encodePacked(
1401 
1402             (block.timestamp).add
1403             (block.difficulty).add
1404             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1405             (block.gaslimit).add
1406             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1407             (block.number)
1408 
1409         )));
1410         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1411             return(true);
1412         else
1413             return(false);
1414     }
1415 
1416     /**
1417      * @dev distributes eth based on fees to com, aff, and p3d
1418      */
1419     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
1420         private
1421         returns(F3Ddatasets.EventReturns)
1422     {
1423         // pay 15% out to community rewards
1424         uint256 _com = _eth.mul(fees_.com)/100;
1425 
1426 
1427 
1428          // distribute share to affiliate 10%
1429         uint256 _aff = (_eth / 10);
1430 
1431         // decide what to do with affiliate share of fees
1432         // affiliate must not be self, and must have a name registered
1433         if (_affID != _pID && plyr_[_affID].name != '') {
1434             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1435             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1436         } else {
1437             _com.add(_aff);
1438         }
1439 
1440         com.transfer(_com);
1441         return(_eventData_);
1442     }
1443 
1444     function potSwap()
1445         external
1446         payable
1447     {
1448         // setup local rID
1449         uint256 _rID = rID_ + 1;
1450 
1451         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1452         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1453     }
1454 
1455     /**
1456      * @dev distributes eth based on fees to gen and pot
1457      */
1458     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1459         private
1460         returns(F3Ddatasets.EventReturns)
1461     {
1462         // calculate gen share
1463         uint256 _gen = (_eth.mul(fees_.gen)) / 100;
1464 
1465         // toss 1% into airdrop pot
1466         uint256 _air = (_eth / 100);
1467         airDropPot_ = airDropPot_.add(_air);
1468 
1469         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1470         //_eth = _eth.sub(((_eth.mul(26)) / 100));
1471 
1472         // calculate pot
1473         uint256 _pot = (_eth.mul(fees_.pot)) / 100;
1474 
1475         // distribute gen share (thats what updateMasks() does) and adjust
1476         // balances for dust.
1477         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1478         if (_dust > 0)
1479             _gen = _gen.sub(_dust);
1480 
1481         // add eth to pot
1482         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1483 
1484         // set up event data
1485         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1486         _eventData_.potAmount = _pot;
1487 
1488         return(_eventData_);
1489     }
1490 
1491     /**
1492      * @dev updates masks for round and player when keys are bought
1493      * @return dust left over
1494      */
1495     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1496         private
1497         returns(uint256)
1498     {
1499         /* MASKING NOTES
1500             earnings masks are a tricky thing for people to wrap their minds around.
1501             the basic thing to understand here.  is were going to have a global
1502             tracker based on profit per share for each round, that increases in
1503             relevant proportion to the increase in share supply.
1504 
1505             the player will have an additional mask that basically says "based
1506             on the rounds mask, my shares, and how much i've already withdrawn,
1507             how much is still owed to me?"
1508         */
1509 
1510         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1511         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1512         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1513 
1514         // calculate player earning from their own buy (only based on the keys
1515         // they just bought).  & update player earnings mask
1516         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1517         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1518 
1519         // calculate & return dust
1520         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1521     }
1522 
1523     /**
1524      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1525      * @return earnings in wei format
1526      */
1527     function withdrawEarnings(uint256 _pID)
1528         private
1529         returns(uint256)
1530     {
1531         // update gen vault
1532         updateGenVault(_pID, plyr_[_pID].lrnd);
1533 
1534         // from vaults
1535         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1536         if (_earnings > 0)
1537         {
1538             plyr_[_pID].win = 0;
1539             plyr_[_pID].gen = 0;
1540             plyr_[_pID].aff = 0;
1541         }
1542 
1543         return(_earnings);
1544     }
1545 
1546     /**
1547      * @dev prepares compression data and fires event for buy or reload tx's
1548      */
1549     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1550         private
1551     {
1552         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (100000000000000000000000000000);
1553         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1554 
1555         emit F3Devents.onEndTx
1556         (
1557             _eventData_.compressedData,
1558             _eventData_.compressedIDs,
1559             plyr_[_pID].name,
1560             msg.sender,
1561             _eth,
1562             _keys,
1563             _eventData_.winnerAddr,
1564             _eventData_.winnerName,
1565             _eventData_.amountWon,
1566             _eventData_.newPot,
1567             _eventData_.P3DAmount,
1568             _eventData_.genAmount,
1569             _eventData_.potAmount,
1570             airDropPot_
1571         );
1572     }
1573 //==============================================================================
1574 //    (~ _  _    _._|_    .
1575 //    _)(/_(_|_|| | | \/  .
1576 //====================/=========================================================
1577     /** upon contract deploy, it will be deactivated.  this is a one time
1578      * use function that will activate the contract.  we do this so devs
1579      * have time to set things up on the web end                            **/
1580     bool public activated_ = false;
1581     function activate()
1582         public
1583     {
1584 
1585         require(msg.sender == admin, "only admin can activate");
1586 
1587         // can only be ran once
1588         require(activated_ == false, "fomo3d already activated");
1589 
1590         // activate the contract
1591         activated_ = true;
1592 
1593         // lets start first round
1594         rID_ = 1;
1595         round_[1].strt = now + rndExtra_ - rndGap_;
1596         round_[1].end = now + rndInit_ + rndExtra_;
1597     }
1598 
1599     //==============================================================================
1600 //     _ _ | _   | _ _|_ _  _ _  .
1601 //    (_(_||(_|_||(_| | (_)| _\  .
1602 //==============================================================================
1603     /**
1604      *  ͶƱ
1605      */
1606     function voting(uint256 _pID, uint256 _rID,bool _vote,uint256 _keys)
1607         canVoting
1608         checkVoting(_pID,_rID)
1609         internal
1610     {
1611 
1612         if(_vote){
1613             roundVotingData[_rID].agress.add(_keys);
1614         }else{
1615             roundVotingData[_rID].oppose.add(_keys);
1616         }
1617         emit Voted( _pID, _rID,  _vote, _keys);
1618     }
1619 
1620     function votingByXid(uint256 _pID,bool _Vote)
1621         isPlayer( _pID,  _rID)
1622         external
1623     {
1624         uint256 _rID = rID_;
1625         uint256 _keys = plyrRnds_[_pID][_rID].keys;
1626 
1627         voting( _pID,  _rID, _Vote, _keys);
1628     }
1629 
1630     // function votingBymy(bool _vote)public{
1631     //     RoundVoting = _vote;
1632     // }
1633 }
1634 
1635 library F3Ddatasets {
1636     //compressedData key
1637     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1638         // 0 - new player (bool)
1639         // 1 - joined round (bool)
1640         // 2 - new  leader (bool)
1641         // 3-5 - air drop tracker (uint 0-999)
1642         // 6-16 - round end time
1643         // 17 - winnerTeam
1644         // 18 - 28 timestamp
1645         // 29 - team
1646         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1647         // 31 - airdrop happened bool
1648         // 32 - airdrop tier
1649         // 33 - airdrop amount won
1650     //compressedIDs key
1651     // [77-52][51-26][25-0]
1652         // 0-25 - pID
1653         // 26-51 - winPID
1654         // 52-77 - rID
1655     struct EventReturns {
1656         uint256 compressedData;
1657         uint256 compressedIDs;
1658         address winnerAddr;         // winner address
1659         bytes32 winnerName;         // winner name
1660         uint256 amountWon;          // amount won
1661         uint256 newPot;             // amount in new pot
1662         uint256 P3DAmount;          // amount distributed to p3d
1663         uint256 genAmount;          // amount distributed to gen
1664         uint256 potAmount;          // amount added to pot
1665     }
1666     struct Player {
1667         address addr;   // player address
1668         bytes32 name;   // player name
1669         uint256 win;    // winnings vault
1670         uint256 gen;    // general vault
1671         uint256 aff;    // affiliate vault
1672         uint256 lrnd;   // last round played
1673         uint256 laff;   // last affiliate id used
1674     }
1675     struct PlayerRounds {
1676         uint256 eth;    // eth player has added to round (used for eth limiter)
1677         uint256 keys;   // keys
1678         uint256 mask;   // player mask
1679         uint256 ico;    // ICO phase investment
1680     }
1681     struct Round {
1682         uint256 plyr;   // pID of player in lead
1683         uint256 team;   // tID of team in lead
1684         uint256 end;    // time ends/ended
1685         bool ended;     // has round end function been ran
1686         uint256 strt;   // time round started
1687         uint256 keys;   // keys
1688         uint256 eth;    // total eth in
1689         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1690         uint256 mask;   // global mask
1691         uint256 ico;    // total eth sent in during ICO phase
1692         uint256 icoGen; // total eth for gen during ICO phase
1693         uint256 icoAvg; // average key price for ICO phase
1694     }
1695     struct TeamFee {
1696         uint256 gen;    // % of buy in thats paid to key holders of current round
1697         uint256 p3d;    // % of buy in thats paid to p3d holders
1698         uint256 pot;    // % of buy in thats paid to pot
1699         uint256 com;    // % of buy in thats paid to com
1700         uint256 air;    // % of buy in thats paid to air
1701     }
1702     struct PotSplit {
1703         uint256 gen;    // % of pot thats paid to key holders of current round
1704         uint256 p3d;    // % of pot thats paid to p3d holders
1705     }
1706 
1707     struct votingData{
1708         uint256 VotingEndTime;  // Voting end time
1709         uint256 agress;
1710         uint256 oppose;
1711     }
1712 }
1713 
1714 /**
1715  * @title SafeMath v0.1.9
1716  * @dev Math operations with safety checks that throw on error
1717  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1718  * - added sqrt
1719  * - added sq
1720  * - added pwr
1721  * - changed asserts to requires with error log outputs
1722  * - removed div, its useless
1723  */
1724 library SafeMath {
1725 
1726     /**
1727     * @dev Multiplies two numbers, throws on overflow.
1728     */
1729     function mul(uint256 a, uint256 b)
1730         internal
1731         pure
1732         returns (uint256 c)
1733     {
1734         if (a == 0) {
1735             return 0;
1736         }
1737         c = a * b;
1738         require(c / a == b, "SafeMath mul failed");
1739         return c;
1740     }
1741 
1742     /**
1743     * @dev Integer division of two numbers, truncating the quotient.
1744     */
1745     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1746         // assert(b > 0); // Solidity automatically throws when dividing by 0
1747         uint256 c = a / b;
1748         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1749         return c;
1750     }
1751 
1752     /**
1753     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1754     */
1755     function sub(uint256 a, uint256 b)
1756         internal
1757         pure
1758         returns (uint256)
1759     {
1760         require(b <= a, "SafeMath sub failed");
1761         return a - b;
1762     }
1763 
1764     /**
1765     * @dev Adds two numbers, throws on overflow.
1766     */
1767     function add(uint256 a, uint256 b)
1768         internal
1769         pure
1770         returns (uint256 c)
1771     {
1772         c = a + b;
1773         require(c >= a, "SafeMath add failed");
1774         return c;
1775     }
1776 
1777     /**
1778      * @dev gives square root of given x.
1779      */
1780     function sqrt(uint256 x)
1781         internal
1782         pure
1783         returns (uint256 y)
1784     {
1785         uint256 z = ((add(x,1)) / 2);
1786         y = x;
1787         while (z < y)
1788         {
1789             y = z;
1790             z = ((add((x / z),z)) / 2);
1791         }
1792     }
1793 
1794     /**
1795      * @dev gives square. multiplies x by x
1796      */
1797     function sq(uint256 x)
1798         internal
1799         pure
1800         returns (uint256)
1801     {
1802         return (mul(x,x));
1803     }
1804 
1805     /**
1806      * @dev x to the power of y
1807      */
1808     function pwr(uint256 x, uint256 y)
1809         internal
1810         pure
1811         returns (uint256)
1812     {
1813         if (x==0)
1814             return (0);
1815         else if (y==0)
1816             return (1);
1817         else
1818         {
1819             uint256 z = x;
1820             for (uint256 i=1; i < y; i++)
1821                 z = mul(z,x);
1822             return (z);
1823         }
1824     }
1825 }
1826 
1827 library F3DKeysCalcLong {
1828     using SafeMath for *;
1829     /**
1830      * @dev calculates number of keys received given X eth
1831      * @param _curEth current amount of eth in contract
1832      * @param _newEth eth being spent
1833      * @return amount of ticket purchased
1834      */
1835     function keysRec(uint256 _curEth, uint256 _newEth)
1836         internal
1837         pure
1838         returns (uint256)
1839     {
1840         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1841     }
1842 
1843     /**
1844      * @dev calculates amount of eth received if you sold X keys
1845      * @param _curKeys current amount of keys that exist
1846      * @param _sellKeys amount of keys you wish to sell
1847      * @return amount of eth received
1848      */
1849     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1850         internal
1851         pure
1852         returns (uint256)
1853     {
1854         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1855     }
1856 
1857     /**
1858      * @dev calculates how many keys would exist with given an amount of eth
1859      * @param _eth eth "in contract"
1860      * @return number of keys that would exist
1861      */
1862     function keys(uint256 _eth)
1863         internal
1864         pure
1865         returns(uint256)
1866     {
1867         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1868     }
1869 
1870     /**
1871      * @dev calculates how much eth would be in contract given a number of keys
1872      * @param _keys number of keys "in contract"
1873      * @return eth that would exists
1874      */
1875     function eth(uint256 _keys)
1876         internal
1877         pure
1878         returns(uint256)
1879     {
1880         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1881     }
1882 }
1883 
1884 
1885 library NameFilter {
1886     /**
1887      * @dev filters name strings
1888      * -converts uppercase to lower case.
1889      * -makes sure it does not start/end with a space
1890      * -makes sure it does not contain multiple spaces in a row
1891      * -cannot be only numbers
1892      * -cannot start with 0x
1893      * -restricts characters to A-Z, a-z, 0-9, and space.
1894      * @return reprocessed string in bytes32 format
1895      */
1896     function nameFilter(string _input)
1897         internal
1898         pure
1899         returns(bytes32)
1900     {
1901         bytes memory _temp = bytes(_input);
1902         uint256 _length = _temp.length;
1903 
1904         //sorry limited to 32 characters
1905         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1906         // make sure it doesnt start with or end with space
1907         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1908         // make sure first two characters are not 0x
1909         if (_temp[0] == 0x30)
1910         {
1911             require(_temp[1] != 0x78, "string cannot start with 0x");
1912             require(_temp[1] != 0x58, "string cannot start with 0X");
1913         }
1914 
1915         // create a bool to track if we have a non number character
1916         bool _hasNonNumber;
1917 
1918         // convert & check
1919         for (uint256 i = 0; i < _length; i++)
1920         {
1921             // if its uppercase A-Z
1922             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1923             {
1924                 // convert to lower case a-z
1925                 _temp[i] = byte(uint(_temp[i]) + 32);
1926 
1927                 // we have a non number
1928                 if (_hasNonNumber == false)
1929                     _hasNonNumber = true;
1930             } else {
1931                 require
1932                 (
1933                     // require character is a space
1934                     _temp[i] == 0x20 ||
1935                     // OR lowercase a-z
1936                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1937                     // or 0-9
1938                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1939                     "string contains invalid characters"
1940                 );
1941                 // make sure theres not 2x spaces in a row
1942                 if (_temp[i] == 0x20)
1943                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1944 
1945                 // see if we have a character other than a number
1946                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1947                     _hasNonNumber = true;
1948             }
1949         }
1950 
1951         require(_hasNonNumber == true, "string cannot be only numbers");
1952 
1953         bytes32 _ret;
1954         assembly {
1955             _ret := mload(add(_temp, 32))
1956         }
1957         return (_ret);
1958     }
1959 }
1960 
1961 interface PlayerBookInterface {
1962     function getPlayerID(address _addr) external returns (uint256);
1963     function getPlayerName(uint256 _pID) external view returns (bytes32);
1964     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1965     function getPlayerAddr(uint256 _pID) external view returns (address);
1966     function getNameFee() external view returns (uint256);
1967     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1968     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1969     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1970 }