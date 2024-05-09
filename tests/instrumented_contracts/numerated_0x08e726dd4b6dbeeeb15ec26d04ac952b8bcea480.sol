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
59         uint256 P3DAmount,
60         uint256 genAmount
61     );
62 
63     // (fomo3d short only) fired whenever a player tries a buy after round timer
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
80     // (fomo3d short only) fired whenever a player tries a reload after round timer
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
107 
108     // received pot swap deposit
109     event onPotSwapDeposit
110     (
111         uint256 roundID,
112         uint256 amountAddedToPot
113     );
114 }
115 
116 
117 contract modularShort is F3Devents {}
118 
119 contract GrandTheftFOMO is modularShort {
120     using SafeMath for *;
121     using NameFilter for string;
122     using F3DKeysCalcShort for uint256;
123 
124     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x16eFB10FBf0CD487B37BC8f179A8CB76fF3B7Dae);
125 
126     address private admin = msg.sender;
127     string constant public name = "Grand Theft FOMO";
128     string constant public symbol = "GTF";
129     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
130     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
131     uint256 constant private rndInit_ = 2 hours;                // round timer starts at this
132     uint256 constant private rndInc_ = 25 seconds;              // every full key purchased adds this much to the timer
133     uint256 constant private rndMax_ = 2 hours;                // max length a round timer can be
134 //==============================================================================
135 //     _| _ _|_ _    _ _ _|_    _   .
136 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
137 //=============================|================================================
138     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
139     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
140     uint256 public rID_;    // round id number / total rounds that have happened
141 //****************
142 // PLAYER DATA
143 //****************
144     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
145     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
146     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
147     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
148     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
149 //****************
150 // ROUND DATA
151 //****************
152     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
153     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
154 //****************
155 // TEAM FEE DATA
156 //****************
157     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
158     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
159 //==============================================================================
160 //     _ _  _  __|_ _    __|_ _  _  .
161 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
162 //==============================================================================
163     constructor()
164         public
165     {
166 		// Team allocation structures
167         // 0 = whales
168         // 1 = bears
169         // 2 = sneks
170         // 3 = bulls
171 
172 		// Team allocation percentages
173         // (F3D, P3D) + (Pot , Referrals, Community)
174             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
175         fees_[0] = F3Ddatasets.TeamFee(60,0);   // NO P3D SHARES, ALL TEAM SETTINGS 'BEARS' DEFAULT
176         fees_[1] = F3Ddatasets.TeamFee(60,0);  
177         fees_[2] = F3Ddatasets.TeamFee(60,0); 
178         fees_[3] = F3Ddatasets.TeamFee(60,0);   
179 
180         // how to split up the final pot based on which team was picked
181         // (F3D, P3D)
182         potSplit_[0] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
183         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
184         potSplit_[2] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
185         potSplit_[3] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
186 	}
187 //==============================================================================
188 //     _ _  _  _|. |`. _  _ _  .
189 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
190 //==============================================================================
191     /**
192      * @dev used to make sure no one can interact with contract until it has
193      * been activated.
194      */
195     modifier isActivated() {
196         require(activated_ == true, "its not ready yet.  check ?eta in discord");
197         _;
198     }
199 
200     /**
201      * @dev prevents contracts from interacting with fomo3d
202      */
203     modifier isHuman() {
204         address _addr = msg.sender;
205         uint256 _codeLength;
206 
207         assembly {_codeLength := extcodesize(_addr)}
208         require(_codeLength == 0, "sorry humans only");
209         _;
210     }
211 
212     /**
213      * @dev sets boundaries for incoming tx
214      */
215     modifier isWithinLimits(uint256 _eth) {
216         require(_eth >= 1000000000, "pocket lint: not a valid currency");
217         require(_eth <= 100000000000000000000000, "no vitalik, no");
218         _;
219     }
220 
221 //==============================================================================
222 //     _    |_ |. _   |`    _  __|_. _  _  _  .
223 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
224 //====|=========================================================================
225     /**
226      * @dev emergency buy uses last stored affiliate ID and team snek
227      */
228     function()
229         isActivated()
230         isHuman()
231         isWithinLimits(msg.value)
232         public
233         payable
234     {
235         // set up our tx event data and determine if player is new or not
236         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
237 
238         // fetch player id
239         uint256 _pID = pIDxAddr_[msg.sender];
240 
241         // buy core
242         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
243     }
244 
245     /**
246      * @dev converts all incoming ethereum to keys.
247      * -functionhash- 0x8f38f309 (using ID for affiliate)
248      * -functionhash- 0x98a0871d (using address for affiliate)
249      * -functionhash- 0xa65b37a1 (using name for affiliate)
250      * @param _affCode the ID/address/name of the player who gets the affiliate fee
251      * @param _team what team is the player playing for?
252      */
253     function buyXid(uint256 _affCode, uint256 _team)
254         isActivated()
255         isHuman()
256         isWithinLimits(msg.value)
257         public
258         payable
259     {
260         // set up our tx event data and determine if player is new or not
261         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
262 
263         // fetch player id
264         uint256 _pID = pIDxAddr_[msg.sender];
265 
266         // manage affiliate residuals
267         // if no affiliate code was given or player tried to use their own, lolz
268         if (_affCode == 0 || _affCode == _pID)
269         {
270             // use last stored affiliate code
271             _affCode = plyr_[_pID].laff;
272 
273         // if affiliate code was given & its not the same as previously stored
274         } else if (_affCode != plyr_[_pID].laff) {
275             // update last affiliate
276             plyr_[_pID].laff = _affCode;
277         }
278 
279         // verify a valid team was selected
280         _team = verifyTeam(_team);
281 
282         // buy core
283         buyCore(_pID, _affCode, _team, _eventData_);
284     }
285 
286     function buyXaddr(address _affCode, uint256 _team)
287         isActivated()
288         isHuman()
289         isWithinLimits(msg.value)
290         public
291         payable
292     {
293         // set up our tx event data and determine if player is new or not
294         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
295 
296         // fetch player id
297         uint256 _pID = pIDxAddr_[msg.sender];
298 
299         // manage affiliate residuals
300         uint256 _affID;
301         // if no affiliate code was given or player tried to use their own, lolz
302         if (_affCode == address(0) || _affCode == msg.sender)
303         {
304             // use last stored affiliate code
305             _affID = plyr_[_pID].laff;
306 
307         // if affiliate code was given
308         } else {
309             // get affiliate ID from aff Code
310             _affID = pIDxAddr_[_affCode];
311 
312             // if affID is not the same as previously stored
313             if (_affID != plyr_[_pID].laff)
314             {
315                 // update last affiliate
316                 plyr_[_pID].laff = _affID;
317             }
318         }
319 
320         // verify a valid team was selected
321         _team = verifyTeam(_team);
322 
323         // buy core
324         buyCore(_pID, _affID, _team, _eventData_);
325     }
326 
327     function buyXname(bytes32 _affCode, uint256 _team)
328         isActivated()
329         isHuman()
330         isWithinLimits(msg.value)
331         public
332         payable
333     {
334         // set up our tx event data and determine if player is new or not
335         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
336 
337         // fetch player id
338         uint256 _pID = pIDxAddr_[msg.sender];
339 
340         // manage affiliate residuals
341         uint256 _affID;
342         // if no affiliate code was given or player tried to use their own, lolz
343         if (_affCode == '' || _affCode == plyr_[_pID].name)
344         {
345             // use last stored affiliate code
346             _affID = plyr_[_pID].laff;
347 
348         // if affiliate code was given
349         } else {
350             // get affiliate ID from aff Code
351             _affID = pIDxName_[_affCode];
352 
353             // if affID is not the same as previously stored
354             if (_affID != plyr_[_pID].laff)
355             {
356                 // update last affiliate
357                 plyr_[_pID].laff = _affID;
358             }
359         }
360 
361         // verify a valid team was selected
362         _team = verifyTeam(_team);
363 
364         // buy core
365         buyCore(_pID, _affID, _team, _eventData_);
366     }
367 
368     /**
369      * @dev essentially the same as buy, but instead of you sending ether
370      * from your wallet, it uses your unwithdrawn earnings.
371      * -functionhash- 0x349cdcac (using ID for affiliate)
372      * -functionhash- 0x82bfc739 (using address for affiliate)
373      * -functionhash- 0x079ce327 (using name for affiliate)
374      * @param _affCode the ID/address/name of the player who gets the affiliate fee
375      * @param _team what team is the player playing for?
376      * @param _eth amount of earnings to use (remainder returned to gen vault)
377      */
378     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
379         isActivated()
380         isHuman()
381         isWithinLimits(_eth)
382         public
383     {
384         // set up our tx event data
385         F3Ddatasets.EventReturns memory _eventData_;
386 
387         // fetch player ID
388         uint256 _pID = pIDxAddr_[msg.sender];
389 
390         // manage affiliate residuals
391         // if no affiliate code was given or player tried to use their own, lolz
392         if (_affCode == 0 || _affCode == _pID)
393         {
394             // use last stored affiliate code
395             _affCode = plyr_[_pID].laff;
396 
397         // if affiliate code was given & its not the same as previously stored
398         } else if (_affCode != plyr_[_pID].laff) {
399             // update last affiliate
400             plyr_[_pID].laff = _affCode;
401         }
402 
403         // verify a valid team was selected
404         _team = verifyTeam(_team);
405 
406         // reload core
407         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
408     }
409 
410     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
411         isActivated()
412         isHuman()
413         isWithinLimits(_eth)
414         public
415     {
416         // set up our tx event data
417         F3Ddatasets.EventReturns memory _eventData_;
418 
419         // fetch player ID
420         uint256 _pID = pIDxAddr_[msg.sender];
421 
422         // manage affiliate residuals
423         uint256 _affID;
424         // if no affiliate code was given or player tried to use their own, lolz
425         if (_affCode == address(0) || _affCode == msg.sender)
426         {
427             // use last stored affiliate code
428             _affID = plyr_[_pID].laff;
429 
430         // if affiliate code was given
431         } else {
432             // get affiliate ID from aff Code
433             _affID = pIDxAddr_[_affCode];
434 
435             // if affID is not the same as previously stored
436             if (_affID != plyr_[_pID].laff)
437             {
438                 // update last affiliate
439                 plyr_[_pID].laff = _affID;
440             }
441         }
442 
443         // verify a valid team was selected
444         _team = verifyTeam(_team);
445 
446         // reload core
447         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
448     }
449 
450     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
451         isActivated()
452         isHuman()
453         isWithinLimits(_eth)
454         public
455     {
456         // set up our tx event data
457         F3Ddatasets.EventReturns memory _eventData_;
458 
459         // fetch player ID
460         uint256 _pID = pIDxAddr_[msg.sender];
461 
462         // manage affiliate residuals
463         uint256 _affID;
464         // if no affiliate code was given or player tried to use their own, lolz
465         if (_affCode == '' || _affCode == plyr_[_pID].name)
466         {
467             // use last stored affiliate code
468             _affID = plyr_[_pID].laff;
469 
470         // if affiliate code was given
471         } else {
472             // get affiliate ID from aff Code
473             _affID = pIDxName_[_affCode];
474 
475             // if affID is not the same as previously stored
476             if (_affID != plyr_[_pID].laff)
477             {
478                 // update last affiliate
479                 plyr_[_pID].laff = _affID;
480             }
481         }
482 
483         // verify a valid team was selected
484         _team = verifyTeam(_team);
485 
486         // reload core
487         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
488     }
489 
490     /**
491      * @dev withdraws all of your earnings.
492      * -functionhash- 0x3ccfd60b
493      */
494     function withdraw()
495         isActivated()
496         isHuman()
497         public
498     {
499         // setup local rID
500         uint256 _rID = rID_;
501 
502         // grab time
503         uint256 _now = now;
504 
505         // fetch player ID
506         uint256 _pID = pIDxAddr_[msg.sender];
507 
508         // setup temp var for player eth
509         uint256 _eth;
510 
511         // check to see if round has ended and no one has run round end yet
512         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
513         {
514             // set up our tx event data
515             F3Ddatasets.EventReturns memory _eventData_;
516 
517             // end the round (distributes pot)
518 			round_[_rID].ended = true;
519             _eventData_ = endRound(_eventData_);
520 
521 			// get their earnings
522             _eth = withdrawEarnings(_pID);
523 
524             // gib moni
525             if (_eth > 0)
526                 plyr_[_pID].addr.transfer(_eth);
527 
528             // build event data
529             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
530             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
531 
532             // fire withdraw and distribute event
533             emit F3Devents.onWithdrawAndDistribute
534             (
535                 msg.sender,
536                 plyr_[_pID].name,
537                 _eth,
538                 _eventData_.compressedData,
539                 _eventData_.compressedIDs,
540                 _eventData_.winnerAddr,
541                 _eventData_.winnerName,
542                 _eventData_.amountWon,
543                 _eventData_.newPot,
544                 _eventData_.P3DAmount,
545                 _eventData_.genAmount
546             );
547 
548         // in any other situation
549         } else {
550             // get their earnings
551             _eth = withdrawEarnings(_pID);
552 
553             // gib moni
554             if (_eth > 0)
555                 plyr_[_pID].addr.transfer(_eth);
556 
557             // fire withdraw event
558             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
559         }
560     }
561 
562     /**
563      * @dev use these to register names.  they are just wrappers that will send the
564      * registration requests to the PlayerBook contract.  So registering here is the
565      * same as registering there.  UI will always display the last name you registered.
566      * but you will still own all previously registered names to use as affiliate
567      * links.
568      * - must pay a registration fee.
569      * - name must be unique
570      * - names will be converted to lowercase
571      * - name cannot start or end with a space
572      * - cannot have more than 1 space in a row
573      * - cannot be only numbers
574      * - cannot start with 0x
575      * - name must be at least 1 char
576      * - max length of 32 characters long
577      * - allowed characters: a-z, 0-9, and space
578      * -functionhash- 0x921dec21 (using ID for affiliate)
579      * -functionhash- 0x3ddd4698 (using address for affiliate)
580      * -functionhash- 0x685ffd83 (using name for affiliate)
581      * @param _nameString players desired name
582      * @param _affCode affiliate ID, address, or name of who referred you
583      * @param _all set to true if you want this to push your info to all games
584      * (this might cost a lot of gas)
585      */
586     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
587         isHuman()
588         public
589         payable
590     {
591         bytes32 _name = _nameString.nameFilter();
592         address _addr = msg.sender;
593         uint256 _paid = msg.value;
594         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
595 
596         uint256 _pID = pIDxAddr_[_addr];
597 
598         // fire event
599         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
600     }
601 
602     function registerNameXaddr(string _nameString, address _affCode, bool _all)
603         isHuman()
604         public
605         payable
606     {
607         bytes32 _name = _nameString.nameFilter();
608         address _addr = msg.sender;
609         uint256 _paid = msg.value;
610         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
611 
612         uint256 _pID = pIDxAddr_[_addr];
613 
614         // fire event
615         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
616     }
617 
618     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
619         isHuman()
620         public
621         payable
622     {
623         bytes32 _name = _nameString.nameFilter();
624         address _addr = msg.sender;
625         uint256 _paid = msg.value;
626         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
627 
628         uint256 _pID = pIDxAddr_[_addr];
629 
630         // fire event
631         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
632     }
633 //==============================================================================
634 //     _  _ _|__|_ _  _ _  .
635 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
636 //=====_|=======================================================================
637     /**
638      * @dev return the price buyer will pay for next 1 individual key.
639      * -functionhash- 0x018a25e8
640      * @return price for next key bought (in wei format)
641      */
642     function getBuyPrice()
643         public
644         view
645         returns(uint256)
646     {
647         // setup local rID
648         uint256 _rID = rID_;
649 
650         // grab time
651         uint256 _now = now;
652 
653         // are we in a round?
654         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
655             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
656         else // rounds over.  need price for new round
657             return ( 75000000000000 ); // init
658     }
659 
660     /**
661      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
662      * provider
663      * -functionhash- 0xc7e284b8
664      * @return time left in seconds
665      */
666     function getTimeLeft()
667         public
668         view
669         returns(uint256)
670     {
671         // setup local rID
672         uint256 _rID = rID_;
673 
674         // grab time
675         uint256 _now = now;
676 
677         if (_now < round_[_rID].end)
678             if (_now > round_[_rID].strt + rndGap_)
679                 return( (round_[_rID].end).sub(_now) );
680             else
681                 return( (round_[_rID].strt + rndGap_).sub(_now) );
682         else
683             return(0);
684     }
685 
686     /**
687      * @dev returns player earnings per vaults
688      * -functionhash- 0x63066434
689      * @return winnings vault
690      * @return general vault
691      * @return affiliate vault
692      */
693     function getPlayerVaults(uint256 _pID)
694         public
695         view
696         returns(uint256 ,uint256, uint256)
697     {
698         // setup local rID
699         uint256 _rID = rID_;
700 
701         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
702         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
703         {
704             // if player is winner
705             if (round_[_rID].plyr == _pID)
706             {
707                 return
708                 (
709                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
710                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
711                     plyr_[_pID].aff
712                 );
713             // if player is not the winner
714             } else {
715                 return
716                 (
717                     plyr_[_pID].win,
718                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
719                     plyr_[_pID].aff
720                 );
721             }
722 
723         // if round is still going on, or round has ended and round end has been ran
724         } else {
725             return
726             (
727                 plyr_[_pID].win,
728                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
729                 plyr_[_pID].aff
730             );
731         }
732     }
733 
734     /**
735      * solidity hates stack limits.  this lets us avoid that hate
736      */
737     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
738         private
739         view
740         returns(uint256)
741     {
742         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
743     }
744 
745     /**
746      * @dev returns all current round info needed for front end
747      * -functionhash- 0x747dff42
748      * @return eth invested during ICO phase
749      * @return round id
750      * @return total keys for round
751      * @return time round ends
752      * @return time round started
753      * @return current pot
754      * @return current team ID & player ID in lead
755      * @return current player in leads address
756      * @return current player in leads name
757      * @return whales eth in for round
758      * @return bears eth in for round
759      * @return sneks eth in for round
760      * @return bulls eth in for round
761      * @return airdrop tracker # & airdrop pot
762      */
763     function getCurrentRoundInfo()
764         public
765         view
766         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
767     {
768         // setup local rID
769         uint256 _rID = rID_;
770 
771         return
772         (
773             round_[_rID].ico,               //0
774             _rID,                           //1
775             round_[_rID].keys,              //2
776             round_[_rID].end,               //3
777             round_[_rID].strt,              //4
778             round_[_rID].pot,               //5
779             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
780             plyr_[round_[_rID].plyr].addr,  //7
781             plyr_[round_[_rID].plyr].name,  //8
782             rndTmEth_[_rID][0],             //9
783             rndTmEth_[_rID][1],             //10
784             rndTmEth_[_rID][2],             //11
785             rndTmEth_[_rID][3],             //12
786             airDropTracker_ + (airDropPot_ * 1000)              //13
787         );
788     }
789 
790     /**
791      * @dev returns player info based on address.  if no address is given, it will
792      * use msg.sender
793      * -functionhash- 0xee0b5d8b
794      * @param _addr address of the player you want to lookup
795      * @return player ID
796      * @return player name
797      * @return keys owned (current round)
798      * @return winnings vault
799      * @return general vault
800      * @return affiliate vault
801 	 * @return player round eth
802      */
803     function getPlayerInfoByAddress(address _addr)
804         public
805         view
806         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
807     {
808         // setup local rID
809         uint256 _rID = rID_;
810 
811         if (_addr == address(0))
812         {
813             _addr == msg.sender;
814         }
815         uint256 _pID = pIDxAddr_[_addr];
816 
817         return
818         (
819             _pID,                               //0
820             plyr_[_pID].name,                   //1
821             plyrRnds_[_pID][_rID].keys,         //2
822             plyr_[_pID].win,                    //3
823             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
824             plyr_[_pID].aff,                    //5
825             plyrRnds_[_pID][_rID].eth           //6
826         );
827     }
828 
829 //==============================================================================
830 //     _ _  _ _   | _  _ . _  .
831 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
832 //=====================_|=======================================================
833     /**
834      * @dev logic runs whenever a buy order is executed.  determines how to handle
835      * incoming eth depending on if we are in an active round or not
836      */
837     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
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
849             // call core
850             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
851 
852         // if round is not active
853         } else {
854             // check to see if end round needs to be ran
855             if (_now > round_[_rID].end && round_[_rID].ended == false)
856             {
857                 // end the round (distributes pot) & start new round
858 			    round_[_rID].ended = true;
859                 _eventData_ = endRound(_eventData_);
860 
861                 // build event data
862                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
863                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
864 
865                 // fire buy and distribute event
866                 emit F3Devents.onBuyAndDistribute
867                 (
868                     msg.sender,
869                     plyr_[_pID].name,
870                     msg.value,
871                     _eventData_.compressedData,
872                     _eventData_.compressedIDs,
873                     _eventData_.winnerAddr,
874                     _eventData_.winnerName,
875                     _eventData_.amountWon,
876                     _eventData_.newPot,
877                     _eventData_.P3DAmount,
878                     _eventData_.genAmount
879                 );
880             }
881 
882             // put eth in players vault
883             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
884         }
885     }
886 
887     /**
888      * @dev logic runs whenever a reload order is executed.  determines how to handle
889      * incoming eth depending on if we are in an active round or not
890      */
891     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
892         private
893     {
894         // setup local rID
895         uint256 _rID = rID_;
896 
897         // grab time
898         uint256 _now = now;
899 
900         // if round is active
901         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
902         {
903             // get earnings from all vaults and return unused to gen vault
904             // because we use a custom safemath library.  this will throw if player
905             // tried to spend more eth than they have.
906             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
907 
908             // call core
909             core(_rID, _pID, _eth, _affID, _team, _eventData_);
910 
911         // if round is not active and end round needs to be ran
912         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
913             // end the round (distributes pot) & start new round
914             round_[_rID].ended = true;
915             _eventData_ = endRound(_eventData_);
916 
917             // build event data
918             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
919             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
920 
921             // fire buy and distribute event
922             emit F3Devents.onReLoadAndDistribute
923             (
924                 msg.sender,
925                 plyr_[_pID].name,
926                 _eventData_.compressedData,
927                 _eventData_.compressedIDs,
928                 _eventData_.winnerAddr,
929                 _eventData_.winnerName,
930                 _eventData_.amountWon,
931                 _eventData_.newPot,
932                 _eventData_.P3DAmount,
933                 _eventData_.genAmount
934             );
935         }
936     }
937 
938     /**
939      * @dev this is the core logic for any buy/reload that happens while a round
940      * is live.
941      */
942     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
943         private
944     {
945         // if player is new to round
946         if (plyrRnds_[_pID][_rID].keys == 0)
947             _eventData_ = managePlayer(_pID, _eventData_);
948 
949         // early round eth limiter
950         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
951         {
952             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
953             uint256 _refund = _eth.sub(_availableLimit);
954             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
955             _eth = _availableLimit;
956         }
957 
958         // if eth left is greater than min eth allowed (sorry no pocket lint)
959         if (_eth > 1000000000)
960         {
961 
962             // mint the new keys
963             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
964 
965             // if they bought at least 1 whole key
966             if (_keys >= 1000000000000000000)
967             {
968             updateTimer(_keys, _rID);
969 
970             // set new leaders
971             if (round_[_rID].plyr != _pID)
972                 round_[_rID].plyr = _pID;
973             if (round_[_rID].team != _team)
974                 round_[_rID].team = _team;
975 
976             // set the new leader bool to true
977             _eventData_.compressedData = _eventData_.compressedData + 100;
978         }
979 
980             // manage airdrops
981             if (_eth >= 100000000000000000)
982             {
983             airDropTracker_++;
984             if (airdrop() == true)
985             {
986                 // gib muni
987                 uint256 _prize;
988                 if (_eth >= 10000000000000000000)
989                 {
990                     // calculate prize and give it to winner
991                     _prize = ((airDropPot_).mul(75)) / 100;
992                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
993 
994                     // adjust airDropPot
995                     airDropPot_ = (airDropPot_).sub(_prize);
996 
997                     // let event know a tier 3 prize was won
998                     _eventData_.compressedData += 300000000000000000000000000000000;
999                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1000                     // calculate prize and give it to winner
1001                     _prize = ((airDropPot_).mul(50)) / 100;
1002                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1003 
1004                     // adjust airDropPot
1005                     airDropPot_ = (airDropPot_).sub(_prize);
1006 
1007                     // let event know a tier 2 prize was won
1008                     _eventData_.compressedData += 200000000000000000000000000000000;
1009                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1010                     // calculate prize and give it to winner
1011                     _prize = ((airDropPot_).mul(25)) / 100;
1012                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1013 
1014                     // adjust airDropPot
1015                     airDropPot_ = (airDropPot_).sub(_prize);
1016 
1017                     // let event know a tier 3 prize was won
1018                     _eventData_.compressedData += 300000000000000000000000000000000;
1019                 }
1020                 // set airdrop happened bool to true
1021                 _eventData_.compressedData += 10000000000000000000000000000000;
1022                 // let event know how much was won
1023                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1024 
1025                 // reset air drop tracker
1026                 airDropTracker_ = 0;
1027             }
1028         }
1029 
1030             // store the air drop tracker number (number of buys since last airdrop)
1031             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1032 
1033             // update player
1034             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1035             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1036 
1037             // update round
1038             round_[_rID].keys = _keys.add(round_[_rID].keys);
1039             round_[_rID].eth = _eth.add(round_[_rID].eth);
1040             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1041 
1042             // distribute eth
1043             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1044             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1045 
1046             // call end tx function to fire end tx event.
1047 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1048         }
1049     }
1050 //==============================================================================
1051 //     _ _ | _   | _ _|_ _  _ _  .
1052 //    (_(_||(_|_||(_| | (_)| _\  .
1053 //==============================================================================
1054     /**
1055      * @dev calculates unmasked earnings (just calculates, does not update mask)
1056      * @return earnings in wei format
1057      */
1058     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1059         private
1060         view
1061         returns(uint256)
1062     {
1063         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1064     }
1065 
1066     /**
1067      * @dev returns the amount of keys you would get given an amount of eth.
1068      * -functionhash- 0xce89c80c
1069      * @param _rID round ID you want price for
1070      * @param _eth amount of eth sent in
1071      * @return keys received
1072      */
1073     function calcKeysReceived(uint256 _rID, uint256 _eth)
1074         public
1075         view
1076         returns(uint256)
1077     {
1078         // grab time
1079         uint256 _now = now;
1080 
1081         // are we in a round?
1082         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1083             return ( (round_[_rID].eth).keysRec(_eth) );
1084         else // rounds over.  need keys for new round
1085             return ( (_eth).keys() );
1086     }
1087 
1088     /**
1089      * @dev returns current eth price for X keys.
1090      * -functionhash- 0xcf808000
1091      * @param _keys number of keys desired (in 18 decimal format)
1092      * @return amount of eth needed to send
1093      */
1094     function iWantXKeys(uint256 _keys)
1095         public
1096         view
1097         returns(uint256)
1098     {
1099         // setup local rID
1100         uint256 _rID = rID_;
1101 
1102         // grab time
1103         uint256 _now = now;
1104 
1105         // are we in a round?
1106         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1107             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1108         else // rounds over.  need price for new round
1109             return ( (_keys).eth() );
1110     }
1111 //==============================================================================
1112 //    _|_ _  _ | _  .
1113 //     | (_)(_)|_\  .
1114 //==============================================================================
1115     /**
1116 	 * @dev receives name/player info from names contract
1117      */
1118     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1119         external
1120     {
1121         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1122         if (pIDxAddr_[_addr] != _pID)
1123             pIDxAddr_[_addr] = _pID;
1124         if (pIDxName_[_name] != _pID)
1125             pIDxName_[_name] = _pID;
1126         if (plyr_[_pID].addr != _addr)
1127             plyr_[_pID].addr = _addr;
1128         if (plyr_[_pID].name != _name)
1129             plyr_[_pID].name = _name;
1130         if (plyr_[_pID].laff != _laff)
1131             plyr_[_pID].laff = _laff;
1132         if (plyrNames_[_pID][_name] == false)
1133             plyrNames_[_pID][_name] = true;
1134     }
1135 
1136     /**
1137      * @dev receives entire player name list
1138      */
1139     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1140         external
1141     {
1142         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1143         if(plyrNames_[_pID][_name] == false)
1144             plyrNames_[_pID][_name] = true;
1145     }
1146 
1147     /**
1148      * @dev gets existing or registers new pID.  use this when a player may be new
1149      * @return pID
1150      */
1151     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1152         private
1153         returns (F3Ddatasets.EventReturns)
1154     {
1155         uint256 _pID = pIDxAddr_[msg.sender];
1156         // if player is new to this version of fomo3d
1157         if (_pID == 0)
1158         {
1159             // grab their player ID, name and last aff ID, from player names contract
1160             _pID = PlayerBook.getPlayerID(msg.sender);
1161             bytes32 _name = PlayerBook.getPlayerName(_pID);
1162             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1163 
1164             // set up player account
1165             pIDxAddr_[msg.sender] = _pID;
1166             plyr_[_pID].addr = msg.sender;
1167 
1168             if (_name != "")
1169             {
1170                 pIDxName_[_name] = _pID;
1171                 plyr_[_pID].name = _name;
1172                 plyrNames_[_pID][_name] = true;
1173             }
1174 
1175             if (_laff != 0 && _laff != _pID)
1176                 plyr_[_pID].laff = _laff;
1177 
1178             // set the new player bool to true
1179             _eventData_.compressedData = _eventData_.compressedData + 1;
1180         }
1181         return (_eventData_);
1182     }
1183 
1184     /**
1185      * @dev checks to make sure user picked a valid team.  if not sets team
1186      * to default (sneks)
1187      */
1188     function verifyTeam(uint256 _team)
1189         private
1190         pure
1191         returns (uint256)
1192     {
1193         if (_team < 0 || _team > 3)
1194             return(2);
1195         else
1196             return(_team);
1197     }
1198 
1199     /**
1200      * @dev decides if round end needs to be run & new round started.  and if
1201      * player unmasked earnings from previously played rounds need to be moved.
1202      */
1203     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1204         private
1205         returns (F3Ddatasets.EventReturns)
1206     {
1207         // if player has played a previous round, move their unmasked earnings
1208         // from that round to gen vault.
1209         if (plyr_[_pID].lrnd != 0)
1210             updateGenVault(_pID, plyr_[_pID].lrnd);
1211 
1212         // update player's last round played
1213         plyr_[_pID].lrnd = rID_;
1214 
1215         // set the joined round bool to true
1216         _eventData_.compressedData = _eventData_.compressedData + 10;
1217 
1218         return(_eventData_);
1219     }
1220 
1221     /**
1222      * @dev ends the round. manages paying out winner/splitting up pot
1223      */
1224     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1225         private
1226         returns (F3Ddatasets.EventReturns)
1227     {
1228         // setup local rID
1229         uint256 _rID = rID_;
1230 
1231         // grab our winning player and team id's
1232         uint256 _winPID = round_[_rID].plyr;
1233         uint256 _winTID = round_[_rID].team;
1234 
1235         // grab our pot amount
1236         uint256 _pot = round_[_rID].pot;
1237 
1238         // calculate our winner share, community rewards, gen share,
1239         // p3d share, and amount reserved for next pot
1240         uint256 _win = (_pot.mul(48)) / 100;
1241         uint256 _com = (_pot / 50);
1242         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1243         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1244         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1245 
1246         // calculate ppt for round mask
1247         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1248         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1249         if (_dust > 0)
1250         {
1251             _gen = _gen.sub(_dust);
1252             _res = _res.add(_dust);
1253         }
1254 
1255         // pay our winner
1256         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1257 
1258         // community rewards
1259 
1260         admin.transfer(_com);
1261 
1262         admin.transfer(_p3d.sub(_p3d / 2));
1263 
1264         round_[_rID].pot = _pot.add(_p3d / 2);
1265 
1266         // distribute gen portion to key holders
1267         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1268 
1269         // prepare event data
1270         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1271         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1272         _eventData_.winnerAddr = plyr_[_winPID].addr;
1273         _eventData_.winnerName = plyr_[_winPID].name;
1274         _eventData_.amountWon = _win;
1275         _eventData_.genAmount = _gen;
1276         _eventData_.P3DAmount = _p3d;
1277         _eventData_.newPot = _res;
1278 
1279         // start next round
1280         rID_++;
1281         _rID++;
1282         round_[_rID].strt = now;
1283         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1284         round_[_rID].pot = _res;
1285 
1286         return(_eventData_);
1287     }
1288 
1289     /**
1290      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1291      */
1292     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1293         private
1294     {
1295         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1296         if (_earnings > 0)
1297         {
1298             // put in gen vault
1299             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1300             // zero out their earnings by updating mask
1301             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1302         }
1303     }
1304 
1305     /**
1306      * @dev updates round timer based on number of whole keys bought.
1307      */
1308     function updateTimer(uint256 _keys, uint256 _rID)
1309         private
1310     {
1311         // grab time
1312         uint256 _now = now;
1313 
1314         // calculate time based on number of keys bought
1315         uint256 _newTime;
1316         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1317             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1318         else
1319             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1320 
1321         // compare to max and set new end time
1322         if (_newTime < (rndMax_).add(_now))
1323             round_[_rID].end = _newTime;
1324         else
1325             round_[_rID].end = rndMax_.add(_now);
1326     }
1327 
1328     /**
1329      * @dev generates a random number between 0-99 and checks to see if thats
1330      * resulted in an airdrop win
1331      * @return do we have a winner?
1332      */
1333     function airdrop()
1334         private
1335         view
1336         returns(bool)
1337     {
1338         uint256 seed = uint256(keccak256(abi.encodePacked(
1339 
1340             (block.timestamp).add
1341             (block.difficulty).add
1342             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1343             (block.gaslimit).add
1344             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1345             (block.number)
1346 
1347         )));
1348         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1349             return(true);
1350         else
1351             return(false);
1352     }
1353 
1354     /**
1355      * @dev distributes eth based on fees to com, aff, and p3d
1356      */
1357     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1358         private
1359         returns(F3Ddatasets.EventReturns)
1360     {
1361         // pay 3% out to community rewards
1362         uint256 _p1 = _eth / 100;
1363         uint256 _com = _eth / 50;
1364         _com = _com.add(_p1);
1365 
1366         uint256 _p3d;
1367         if (!address(admin).call.value(_com)())
1368         {
1369             // This ensures Team Just cannot influence the outcome of FoMo3D with
1370             // bank migrations by breaking outgoing transactions.
1371             // Something we would never do. But that's not the point.
1372             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1373             // highest belief that everything we create should be trustless.
1374             // Team JUST, The name you shouldn't have to trust.
1375             _p3d = _com;
1376             _com = 0;
1377         }
1378 
1379 
1380         // distribute share to affiliate
1381         uint256 _aff = _eth / 10;
1382 
1383         // decide what to do with affiliate share of fees
1384         // affiliate must not be self, and must have a name registered
1385         if (_affID != _pID && plyr_[_affID].name != '') {
1386             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1387             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1388         } else {
1389             _p3d = _aff;
1390         }
1391 
1392         // pay out p3d
1393         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1394         if (_p3d > 0)
1395         {
1396             // deposit to divies contract
1397             uint256 _potAmount = _p3d / 2;
1398 
1399             admin.transfer(_p3d.sub(_potAmount));
1400 
1401             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1402 
1403             // set up event data
1404             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1405         }
1406 
1407         return(_eventData_);
1408     }
1409 
1410     function potSwap()
1411         external
1412         payable
1413     {
1414         // setup local rID
1415         uint256 _rID = rID_ + 1;
1416 
1417         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1418         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1419     }
1420 
1421     /**
1422      * @dev distributes eth based on fees to gen and pot
1423      */
1424     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1425         private
1426         returns(F3Ddatasets.EventReturns)
1427     {
1428         // calculate gen share
1429         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1430 
1431         // toss 1% into airdrop pot
1432         uint256 _air = (_eth / 100);
1433         airDropPot_ = airDropPot_.add(_air);
1434 
1435         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1436         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1437 
1438         // calculate pot
1439         uint256 _pot = _eth.sub(_gen);
1440 
1441         // distribute gen share (thats what updateMasks() does) and adjust
1442         // balances for dust.
1443         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1444         if (_dust > 0)
1445             _gen = _gen.sub(_dust);
1446 
1447         // add eth to pot
1448         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1449 
1450         // set up event data
1451         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1452         _eventData_.potAmount = _pot;
1453 
1454         return(_eventData_);
1455     }
1456 
1457     /**
1458      * @dev updates masks for round and player when keys are bought
1459      * @return dust left over
1460      */
1461     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1462         private
1463         returns(uint256)
1464     {
1465         /* MASKING NOTES
1466             earnings masks are a tricky thing for people to wrap their minds around.
1467             the basic thing to understand here.  is were going to have a global
1468             tracker based on profit per share for each round, that increases in
1469             relevant proportion to the increase in share supply.
1470 
1471             the player will have an additional mask that basically says "based
1472             on the rounds mask, my shares, and how much i've already withdrawn,
1473             how much is still owed to me?"
1474         */
1475 
1476         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1477         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1478         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1479 
1480         // calculate player earning from their own buy (only based on the keys
1481         // they just bought).  & update player earnings mask
1482         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1483         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1484 
1485         // calculate & return dust
1486         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1487     }
1488 
1489     /**
1490      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1491      * @return earnings in wei format
1492      */
1493     function withdrawEarnings(uint256 _pID)
1494         private
1495         returns(uint256)
1496     {
1497         // update gen vault
1498         updateGenVault(_pID, plyr_[_pID].lrnd);
1499 
1500         // from vaults
1501         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1502         if (_earnings > 0)
1503         {
1504             plyr_[_pID].win = 0;
1505             plyr_[_pID].gen = 0;
1506             plyr_[_pID].aff = 0;
1507         }
1508 
1509         return(_earnings);
1510     }
1511 
1512     /**
1513      * @dev prepares compression data and fires event for buy or reload tx's
1514      */
1515     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1516         private
1517     {
1518         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1519         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1520 
1521         emit F3Devents.onEndTx
1522         (
1523             _eventData_.compressedData,
1524             _eventData_.compressedIDs,
1525             plyr_[_pID].name,
1526             msg.sender,
1527             _eth,
1528             _keys,
1529             _eventData_.winnerAddr,
1530             _eventData_.winnerName,
1531             _eventData_.amountWon,
1532             _eventData_.newPot,
1533             _eventData_.P3DAmount,
1534             _eventData_.genAmount,
1535             _eventData_.potAmount,
1536             airDropPot_
1537         );
1538     }
1539 //==============================================================================
1540 //    (~ _  _    _._|_    .
1541 //    _)(/_(_|_|| | | \/  .
1542 //====================/=========================================================
1543     /** upon contract deploy, it will be deactivated.  this is a one time
1544      * use function that will activate the contract.  we do this so devs
1545      * have time to set things up on the web end                            **/
1546     bool public activated_ = false;
1547     function activate()
1548         public
1549     {
1550         // only team just can activate
1551         require(msg.sender == admin, "only admin can activate");
1552 
1553 
1554         // can only be ran once
1555         require(activated_ == false, "FOMO Short already activated");
1556 
1557         // activate the contract
1558         activated_ = true;
1559 
1560         // lets start first round
1561         rID_ = 1;
1562             round_[1].strt = now + rndExtra_ - rndGap_;
1563             round_[1].end = now + rndInit_ + rndExtra_;
1564     }
1565 }
1566 
1567 //==============================================================================
1568 //   __|_ _    __|_ _  .
1569 //  _\ | | |_|(_ | _\  .
1570 //==============================================================================
1571 library F3Ddatasets {
1572     //compressedData key
1573     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1574         // 0 - new player (bool)
1575         // 1 - joined round (bool)
1576         // 2 - new  leader (bool)
1577         // 3-5 - air drop tracker (uint 0-999)
1578         // 6-16 - round end time
1579         // 17 - winnerTeam
1580         // 18 - 28 timestamp
1581         // 29 - team
1582         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1583         // 31 - airdrop happened bool
1584         // 32 - airdrop tier
1585         // 33 - airdrop amount won
1586     //compressedIDs key
1587     // [77-52][51-26][25-0]
1588         // 0-25 - pID
1589         // 26-51 - winPID
1590         // 52-77 - rID
1591     struct EventReturns {
1592         uint256 compressedData;
1593         uint256 compressedIDs;
1594         address winnerAddr;         // winner address
1595         bytes32 winnerName;         // winner name
1596         uint256 amountWon;          // amount won
1597         uint256 newPot;             // amount in new pot
1598         uint256 P3DAmount;          // amount distributed to p3d
1599         uint256 genAmount;          // amount distributed to gen
1600         uint256 potAmount;          // amount added to pot
1601     }
1602     struct Player {
1603         address addr;   // player address
1604         bytes32 name;   // player name
1605         uint256 win;    // winnings vault
1606         uint256 gen;    // general vault
1607         uint256 aff;    // affiliate vault
1608         uint256 lrnd;   // last round played
1609         uint256 laff;   // last affiliate id used
1610     }
1611     struct PlayerRounds {
1612         uint256 eth;    // eth player has added to round (used for eth limiter)
1613         uint256 keys;   // keys
1614         uint256 mask;   // player mask
1615         uint256 ico;    // ICO phase investment
1616     }
1617     struct Round {
1618         uint256 plyr;   // pID of player in lead
1619         uint256 team;   // tID of team in lead
1620         uint256 end;    // time ends/ended
1621         bool ended;     // has round end function been ran
1622         uint256 strt;   // time round started
1623         uint256 keys;   // keys
1624         uint256 eth;    // total eth in
1625         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1626         uint256 mask;   // global mask
1627         uint256 ico;    // total eth sent in during ICO phase
1628         uint256 icoGen; // total eth for gen during ICO phase
1629         uint256 icoAvg; // average key price for ICO phase
1630     }
1631     struct TeamFee {
1632         uint256 gen;    // % of buy in thats paid to key holders of current round
1633         uint256 p3d;    // % of buy in thats paid to p3d holders
1634     }
1635     struct PotSplit {
1636         uint256 gen;    // % of pot thats paid to key holders of current round
1637         uint256 p3d;    // % of pot thats paid to p3d holders
1638     }
1639 }
1640 
1641 //==============================================================================
1642 //  |  _      _ _ | _  .
1643 //  |<(/_\/  (_(_||(_  .
1644 //=======/======================================================================
1645 library F3DKeysCalcShort {
1646     using SafeMath for *;
1647     /**
1648      * @dev calculates number of keys received given X eth
1649      * @param _curEth current amount of eth in contract
1650      * @param _newEth eth being spent
1651      * @return amount of ticket purchased
1652      */
1653     function keysRec(uint256 _curEth, uint256 _newEth)
1654         internal
1655         pure
1656         returns (uint256)
1657     {
1658         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1659     }
1660 
1661     /**
1662      * @dev calculates amount of eth received if you sold X keys
1663      * @param _curKeys current amount of keys that exist
1664      * @param _sellKeys amount of keys you wish to sell
1665      * @return amount of eth received
1666      */
1667     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1668         internal
1669         pure
1670         returns (uint256)
1671     {
1672         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1673     }
1674 
1675     /**
1676      * @dev calculates how many keys would exist with given an amount of eth
1677      * @param _eth eth "in contract"
1678      * @return number of keys that would exist
1679      */
1680     function keys(uint256 _eth)
1681         internal
1682         pure
1683         returns(uint256)
1684     {
1685         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1686     }
1687 
1688     /**
1689      * @dev calculates how much eth would be in contract given a number of keys
1690      * @param _keys number of keys "in contract"
1691      * @return eth that would exists
1692      */
1693     function eth(uint256 _keys)
1694         internal
1695         pure
1696         returns(uint256)
1697     {
1698         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1699     }
1700 }
1701 
1702 //==============================================================================
1703 //  . _ _|_ _  _ |` _  _ _  _  .
1704 //  || | | (/_| ~|~(_|(_(/__\  .
1705 //==============================================================================
1706 
1707 interface PlayerBookInterface {
1708     function getPlayerID(address _addr) external returns (uint256);
1709     function getPlayerName(uint256 _pID) external view returns (bytes32);
1710     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1711     function getPlayerAddr(uint256 _pID) external view returns (address);
1712     function getNameFee() external view returns (uint256);
1713     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1714     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1715     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1716 }
1717 
1718 /**
1719 * @title -Name Filter- v0.1.9
1720 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1721 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1722 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1723 *                                  _____                      _____
1724 *                                 (, /     /)       /) /)    (, /      /)          /)
1725 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1726 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1727 *          ┴ ┴                /   /          .-/ _____   (__ /
1728 *                            (__ /          (_/ (, /                                      /)™
1729 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1730 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1731 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1732 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1733 *              _       __    _      ____      ____  _   _    _____  ____  ___
1734 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1735 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1736 *
1737 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1738 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1739 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1740 */
1741 
1742 library NameFilter {
1743     /**
1744      * @dev filters name strings
1745      * -converts uppercase to lower case.
1746      * -makes sure it does not start/end with a space
1747      * -makes sure it does not contain multiple spaces in a row
1748      * -cannot be only numbers
1749      * -cannot start with 0x
1750      * -restricts characters to A-Z, a-z, 0-9, and space.
1751      * @return reprocessed string in bytes32 format
1752      */
1753     function nameFilter(string _input)
1754         internal
1755         pure
1756         returns(bytes32)
1757     {
1758         bytes memory _temp = bytes(_input);
1759         uint256 _length = _temp.length;
1760 
1761         //sorry limited to 32 characters
1762         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1763         // make sure it doesnt start with or end with space
1764         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1765         // make sure first two characters are not 0x
1766         if (_temp[0] == 0x30)
1767         {
1768             require(_temp[1] != 0x78, "string cannot start with 0x");
1769             require(_temp[1] != 0x58, "string cannot start with 0X");
1770         }
1771 
1772         // create a bool to track if we have a non number character
1773         bool _hasNonNumber;
1774 
1775         // convert & check
1776         for (uint256 i = 0; i < _length; i++)
1777         {
1778             // if its uppercase A-Z
1779             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1780             {
1781                 // convert to lower case a-z
1782                 _temp[i] = byte(uint(_temp[i]) + 32);
1783 
1784                 // we have a non number
1785                 if (_hasNonNumber == false)
1786                     _hasNonNumber = true;
1787             } else {
1788                 require
1789                 (
1790                     // require character is a space
1791                     _temp[i] == 0x20 ||
1792                     // OR lowercase a-z
1793                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1794                     // or 0-9
1795                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1796                     "string contains invalid characters"
1797                 );
1798                 // make sure theres not 2x spaces in a row
1799                 if (_temp[i] == 0x20)
1800                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1801 
1802                 // see if we have a character other than a number
1803                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1804                     _hasNonNumber = true;
1805             }
1806         }
1807 
1808         require(_hasNonNumber == true, "string cannot be only numbers");
1809 
1810         bytes32 _ret;
1811         assembly {
1812             _ret := mload(add(_temp, 32))
1813         }
1814         return (_ret);
1815     }
1816 }
1817 
1818 /**
1819  * @title SafeMath v0.1.9
1820  * @dev Math operations with safety checks that throw on error
1821  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1822  * - added sqrt
1823  * - added sq
1824  * - added pwr
1825  * - changed asserts to requires with error log outputs
1826  * - removed div, its useless
1827  */
1828 library SafeMath {
1829 
1830     /**
1831     * @dev Multiplies two numbers, throws on overflow.
1832     */
1833     function mul(uint256 a, uint256 b)
1834         internal
1835         pure
1836         returns (uint256 c)
1837     {
1838         if (a == 0) {
1839             return 0;
1840         }
1841         c = a * b;
1842         require(c / a == b, "SafeMath mul failed");
1843         return c;
1844     }
1845 
1846     /**
1847     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1848     */
1849     function sub(uint256 a, uint256 b)
1850         internal
1851         pure
1852         returns (uint256)
1853     {
1854         require(b <= a, "SafeMath sub failed");
1855         return a - b;
1856     }
1857 
1858     /**
1859     * @dev Adds two numbers, throws on overflow.
1860     */
1861     function add(uint256 a, uint256 b)
1862         internal
1863         pure
1864         returns (uint256 c)
1865     {
1866         c = a + b;
1867         require(c >= a, "SafeMath add failed");
1868         return c;
1869     }
1870 
1871     /**
1872      * @dev gives square root of given x.
1873      */
1874     function sqrt(uint256 x)
1875         internal
1876         pure
1877         returns (uint256 y)
1878     {
1879         uint256 z = ((add(x,1)) / 2);
1880         y = x;
1881         while (z < y)
1882         {
1883             y = z;
1884             z = ((add((x / z),z)) / 2);
1885         }
1886     }
1887 
1888     /**
1889      * @dev gives square. multiplies x by x
1890      */
1891     function sq(uint256 x)
1892         internal
1893         pure
1894         returns (uint256)
1895     {
1896         return (mul(x,x));
1897     }
1898 
1899     /**
1900      * @dev x to the power of y
1901      */
1902     function pwr(uint256 x, uint256 y)
1903         internal
1904         pure
1905         returns (uint256)
1906     {
1907         if (x==0)
1908             return (0);
1909         else if (y==0)
1910             return (1);
1911         else
1912         {
1913             uint256 z = x;
1914             for (uint256 i=1; i < y; i++)
1915                 z = mul(z,x);
1916             return (z);
1917         }
1918     }
1919 }