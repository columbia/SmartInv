1 pragma solidity ^0.4.24;
2 contract F3Devents {
3     // fired whenever a player registers a name
4     event onNewName
5     (
6         uint256 indexed playerID,
7         address indexed playerAddress,
8         bytes32 indexed playerName,
9         bool isNewPlayer,
10         uint256 affiliateID,
11         address affiliateAddress,
12         bytes32 affiliateName,
13         uint256 amountPaid,
14         uint256 timeStamp
15     );
16 
17     // fired at end of buy or reload
18     event onEndTx
19     (
20         uint256 compressedData,
21         uint256 compressedIDs,
22         bytes32 playerName,
23         address playerAddress,
24         uint256 ethIn,
25         uint256 keysBought,
26         address winnerAddr,
27         bytes32 winnerName,
28         uint256 amountWon,
29         uint256 newPot,
30         uint256 P3DAmount,
31         uint256 genAmount,
32         uint256 potAmount,
33         uint256 airDropPot
34     );
35 
36 	// fired whenever theres a withdraw
37     event onWithdraw
38     (
39         uint256 indexed playerID,
40         address playerAddress,
41         bytes32 playerName,
42         uint256 ethOut,
43         uint256 timeStamp
44     );
45 
46     // fired whenever a withdraw forces end round to be ran
47     event onWithdrawAndDistribute
48     (
49         address playerAddress,
50         bytes32 playerName,
51         uint256 ethOut,
52         uint256 compressedData,
53         uint256 compressedIDs,
54         address winnerAddr,
55         bytes32 winnerName,
56         uint256 amountWon,
57         uint256 newPot,
58         uint256 P3DAmount,
59         uint256 genAmount
60     );
61 
62     // (fomo3d long only) fired whenever a player tries a buy after round timer
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
75         uint256 P3DAmount,
76         uint256 genAmount
77     );
78 
79     // (fomo3d long only) fired whenever a player tries a reload after round timer
80     // hit zero, and causes end round to be ran.
81     event onReLoadAndDistribute
82     (
83         address playerAddress,
84         bytes32 playerName,
85         uint256 compressedData,
86         uint256 compressedIDs,
87         address winnerAddr,
88         bytes32 winnerName,
89         uint256 amountWon,
90         uint256 newPot,
91         uint256 P3DAmount,
92         uint256 genAmount
93     );
94 
95     // fired whenever an affiliate is paid
96     event onAffiliatePayout
97     (
98         uint256 indexed affiliateID,
99         address affiliateAddress,
100         bytes32 affiliateName,
101         uint256 indexed roundID,
102         uint256 indexed buyerID,
103         uint256 amount,
104         uint256 timeStamp
105     );
106 
107     // received pot swap deposit
108     event onPotSwapDeposit
109     (
110         uint256 roundID,
111         uint256 amountAddedToPot
112     );
113 }
114 
115 contract F3DGoQuick is F3Devents{
116     using SafeMath for uint256;
117     using NameFilter for string;
118     using F3DKeysCalcFast for uint256;
119 
120 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x82e0C3626622d9a8234BFBaf6DD0f8d070C2609D);
121 //==============================================================================
122 //     _ _  _  |`. _     _ _ |_ | _  _  .
123 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
124 //=================_|===========================================================
125     address private admin = 0xacb257873b064b956BD9be84dc347C55F7b2ae8C;
126     address private coin_base = 0x345A756a49DF0eD24002857dd25DAb6a5F4E83FF;
127     string constant public name = "F3DLink Quick";
128     string constant public symbol = "F3D";
129 	uint256 private rndGap_ = 60 seconds;                       // length of ICO phase, set to 1 year for EOS.
130     uint256 constant private rndInit_ = 5 minutes;              // round timer starts at this
131     uint256 constant private rndInc_ = 5 minutes;               // every full key purchased adds this much to the timer
132     uint256 constant private rndMax_ = 5 minutes;               // max length a round timer can be
133 //==============================================================================
134 //     _| _ _|_ _    _ _ _|_    _   .
135 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
136 //=============================|================================================
137 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
138     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
139     uint256 public rID_;    // round id number / total rounds that have happened
140 //****************
141 // PLAYER DATA
142 //****************
143     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
144     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
145     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
146     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
147     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
148 //****************
149 // ROUND DATA
150 //****************
151     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
152     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
153 //****************
154 // TEAM FEE DATA
155 //****************
156     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
157     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
158 //==============================================================================
159 //     _ _  _  __|_ _    __|_ _  _  .
160 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
161 //==============================================================================
162     constructor()
163         public
164     {
165 		// Team allocation structures
166         // 0 = whales
167         // 1 = bears
168         // 2 = sneks
169         // 3 = bulls
170 
171 		// Team allocation percentages
172         // (F3D, P3D) + (Pot , Referrals, Community)
173             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
174         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
175         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
176         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
177         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
178 
179         // how to split up the final pot based on which team was picked
180         // (F3D, P3D)
181         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
182         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
183         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
184         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
185 	}
186 //==============================================================================
187 //     _ _  _  _|. |`. _  _ _  .
188 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
189 //==============================================================================
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
204         require (_addr == tx.origin);
205 
206         uint256 _codeLength;
207 
208         assembly {_codeLength := extcodesize(_addr)}
209         require(_codeLength == 0, "sorry humans only");
210         _;
211     }
212 
213     /**
214      * @dev sets boundaries for incoming tx
215      */
216     modifier isWithinLimits(uint256 _eth) {
217         require(_eth >= 1000000000, "pocket lint: not a valid currency");
218         require(_eth <= 100000000000000000000000, "no vitalik, no");    /** NOTE THIS NEEDS TO BE CHECKED **/
219 		_;
220 	}
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
512         if (_now > round_[_rID].end && round_[_rID].ended == false)
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
639      * - during live round.  this is accurate. (well... unless someone buys before
640      * you do and ups the price!  you better HURRY!)
641      * - during ICO phase.  this is the max you would get based on current eth
642      * invested during ICO phase.  if others invest after you, you will receive
643      * less.  (so distract them with meme vids till ICO is over)
644      * -functionhash- 0x018a25e8
645      * @return price for next key bought (in wei format)
646      */
647     function getBuyPrice()
648         public
649         view
650         returns(uint256)
651     {
652         // setup local rID
653         uint256 _rID = rID_;
654 
655         // grab time
656         uint256 _now = now;
657 
658         // is ICO phase over??  & theres eth in the round?
659         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
660             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
661         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
662             return ( ((round_[_rID].ico.keys()).add(1000000000000000000)).ethRec(1000000000000000000) );
663         else // rounds over.  need price for new round
664             return ( 100000000000000 ); // init
665     }
666 
667     /**
668      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
669      * provider
670      * -functionhash- 0xc7e284b8
671      * @return time left in seconds
672      */
673     function getTimeLeft()
674         public
675         view
676         returns(uint256)
677     {
678         // setup local rID
679         uint256 _rID = rID_;
680 
681         // grab time
682         uint256 _now = now;
683 
684         // are we in ICO phase?
685         if (_now <= round_[_rID].strt + rndGap_)
686             return( ((round_[_rID].end).sub(rndInit_)).sub(_now) );
687         else
688             if (_now < round_[_rID].end)
689                 return( (round_[_rID].end).sub(_now) );
690             else
691                 return(0);
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
710         if (now > round_[_rID].end && round_[_rID].ended == false)
711         {
712             uint256 _roundMask;
713             uint256 _roundEth;
714             uint256 _roundKeys;
715             uint256 _roundPot;
716             if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
717             {
718                 // create a temp round eth based on eth sent in during ICO phase
719                 _roundEth = round_[_rID].ico;
720 
721                 // create a temp round keys based on keys bought during ICO phase
722                 _roundKeys = (round_[_rID].ico).keys();
723 
724                 // create a temp round mask based on eth and keys from ICO phase
725                 _roundMask = ((round_[_rID].icoGen).mul(1000000000000000000)) / _roundKeys;
726 
727                 // create a temp rount pot based on pot, and dust from mask
728                 _roundPot = (round_[_rID].pot).add((round_[_rID].icoGen).sub((_roundMask.mul(_roundKeys)) / (1000000000000000000)));
729             } else {
730                 _roundEth = round_[_rID].eth;
731                 _roundKeys = round_[_rID].keys;
732                 _roundMask = round_[_rID].mask;
733                 _roundPot = round_[_rID].pot;
734             }
735 
736             uint256 _playerKeys;
737             if (plyrRnds_[_pID][plyr_[_pID].lrnd].ico == 0)
738                 _playerKeys = plyrRnds_[_pID][plyr_[_pID].lrnd].keys;
739             else
740                 _playerKeys = calcPlayerICOPhaseKeys(_pID, _rID);
741 
742             // if player is winner
743             if (round_[_rID].plyr == _pID)
744             {
745                 return
746                 (
747                     (plyr_[_pID].win).add( (_roundPot.mul(48)) / 100 ),
748                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
749                     plyr_[_pID].aff
750                 );
751             // if player is not the winner
752             } else {
753                 return
754                 (
755                     plyr_[_pID].win,
756                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
757                     plyr_[_pID].aff
758                 );
759             }
760 
761         // if round is still going on, we are in ico phase, or round has ended and round end has been ran
762         } else {
763             return
764             (
765                 plyr_[_pID].win,
766                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
767                 plyr_[_pID].aff
768             );
769         }
770     }
771 
772     /**
773      * solidity hates stack limits.  this lets us avoid that hate
774      */
775     function getPlayerVaultsHelper(uint256 _pID, uint256 _roundMask, uint256 _roundPot, uint256 _roundKeys, uint256 _playerKeys)
776         private
777         view
778         returns(uint256)
779     {
780         return(  (((_roundMask.add((((_roundPot.mul(potSplit_[round_[rID_].team].gen)) / 100).mul(1000000000000000000)) / _roundKeys)).mul(_playerKeys)) / 1000000000000000000).sub(plyrRnds_[_pID][rID_].mask)  );
781     }
782 
783     /**
784      * @dev returns all current round info needed for front end
785      * -functionhash- 0x747dff42
786      * @return eth invested during ICO phase
787      * @return round id
788      * @return total keys for round
789      * @return time round ends
790      * @return time round started
791      * @return current pot
792      * @return current team ID & player ID in lead
793      * @return current player in leads address
794      * @return current player in leads name
795      * @return whales eth in for round
796      * @return bears eth in for round
797      * @return sneks eth in for round
798      * @return bulls eth in for round
799      * @return airdrop tracker # & airdrop pot
800      */
801     function getCurrentRoundInfo()
802         public
803         view
804         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
805     {
806         // setup local rID
807         uint256 _rID = rID_;
808 
809         if (round_[_rID].eth != 0)
810         {
811             return
812             (
813                 round_[_rID].ico,               //0
814                 _rID,                           //1
815                 round_[_rID].keys,              //2
816                 round_[_rID].end,               //3
817                 round_[_rID].strt,              //4
818                 round_[_rID].pot,               //5
819                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
820                 plyr_[round_[_rID].plyr].addr,  //7
821                 plyr_[round_[_rID].plyr].name,  //8
822                 rndTmEth_[_rID][0],             //9
823                 rndTmEth_[_rID][1],             //10
824                 rndTmEth_[_rID][2],             //11
825                 rndTmEth_[_rID][3],             //12
826                 airDropTracker_ + (airDropPot_ * 1000)              //13
827             );
828         } else {
829             return
830             (
831                 round_[_rID].ico,               //0
832                 _rID,                           //1
833                 (round_[_rID].ico).keys(),      //2
834                 round_[_rID].end,               //3
835                 round_[_rID].strt,              //4
836                 round_[_rID].pot,               //5
837                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
838                 plyr_[round_[_rID].plyr].addr,  //7
839                 plyr_[round_[_rID].plyr].name,  //8
840                 rndTmEth_[_rID][0],             //9
841                 rndTmEth_[_rID][1],             //10
842                 rndTmEth_[_rID][2],             //11
843                 rndTmEth_[_rID][3],             //12
844                 airDropTracker_ + (airDropPot_ * 1000)              //13
845             );
846         }
847     }
848 
849     /**
850      * @dev returns player info based on address.  if no address is given, it will
851      * use msg.sender
852      * -functionhash- 0xee0b5d8b
853      * @param _addr address of the player you want to lookup
854      * @return player ID
855      * @return player name
856      * @return keys owned (current round)
857      * @return winnings vault
858      * @return general vault
859      * @return affiliate vault
860 	 * @return player ico eth
861      */
862     function getPlayerInfoByAddress(address _addr)
863         public
864         view
865         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
866     {
867         // setup local rID
868         uint256 _rID = rID_;
869 
870         if (_addr == address(0))
871         {
872             _addr == msg.sender;
873         }
874         uint256 _pID = pIDxAddr_[_addr];
875 
876         if (plyrRnds_[_pID][_rID].ico == 0)
877         {
878             return
879             (
880                 _pID,                               //0
881                 plyr_[_pID].name,                   //1
882                 plyrRnds_[_pID][_rID].keys,         //2
883                 plyr_[_pID].win,                    //3
884                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
885                 plyr_[_pID].aff,                    //5
886 				0						            //6
887             );
888         } else {
889             return
890             (
891                 _pID,                               //0
892                 plyr_[_pID].name,                   //1
893                 calcPlayerICOPhaseKeys(_pID, _rID), //2
894                 plyr_[_pID].win,                    //3
895                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
896                 plyr_[_pID].aff,                    //5
897 				plyrRnds_[_pID][_rID].ico           //6
898             );
899         }
900 
901     }
902 
903 //==============================================================================
904 //     _ _  _ _   | _  _ . _  .
905 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
906 //=====================_|=======================================================
907     /**
908      * @dev logic runs whenever a buy order is executed.  determines how to handle
909      * incoming eth depending on if we are in ICO phase or not
910      */
911     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
912         private
913     {
914         // check to see if round has ended.  and if player is new to round
915         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
916 
917         // are we in ICO phase?
918         if (now <= round_[rID_].strt + rndGap_)
919         {
920             // let event data know this is a ICO phase buy order
921             _eventData_.compressedData = _eventData_.compressedData + 2000000000000000000000000000000;
922 
923             // ICO phase core
924             icoPhaseCore(_pID, msg.value, _team, _affID, _eventData_);
925 
926 
927         // round is live
928         } else {
929              // let event data know this is a buy order
930             _eventData_.compressedData = _eventData_.compressedData + 1000000000000000000000000000000;
931 
932             // call core
933             core(_pID, msg.value, _affID, _team, _eventData_);
934         }
935     }
936 
937     /**
938      * @dev logic runs whenever a reload order is executed.  determines how to handle
939      * incoming eth depending on if we are in ICO phase or not
940      */
941     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
942         private
943     {
944         // check to see if round has ended.  and if player is new to round
945         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
946 
947         // get earnings from all vaults and return unused to gen vault
948         // because we use a custom safemath library.  this will throw if player
949         // tried to spend more eth than they have.
950         plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
951 
952         // are we in ICO phase?
953         if (now <= round_[rID_].strt + rndGap_)
954         {
955             // let event data know this is an ICO phase reload
956             _eventData_.compressedData = _eventData_.compressedData + 3000000000000000000000000000000;
957 
958             // ICO phase core
959             icoPhaseCore(_pID, _eth, _team, _affID, _eventData_);
960 
961 
962         // round is live
963         } else {
964             // call core
965             core(_pID, _eth, _affID, _team, _eventData_);
966         }
967     }
968 
969     /**
970      * @dev during ICO phase all eth sent in by each player.  will be added to an
971      * "investment pool".  upon end of ICO phase, all eth will be used to buy keys.
972      * each player receives an amount based on how much they put in, and the
973      * the average price attained.
974      */
975     function icoPhaseCore(uint256 _pID, uint256 _eth, uint256 _team, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
976         private
977     {
978         // setup local rID
979         uint256 _rID = rID_;
980 
981         // if they bought at least 1 whole key (at time of purchase)
982         if ((round_[_rID].ico).keysRec(_eth) >= 1000000000000000000 || round_[_rID].plyr == 0)
983         {
984             // set new leaders
985             if (round_[_rID].plyr != _pID)
986                 round_[_rID].plyr = _pID;
987             if (round_[_rID].team != _team)
988                 round_[_rID].team = _team;
989 
990             // set the new leader bool to true
991             _eventData_.compressedData = _eventData_.compressedData + 100;
992         }
993 
994         // add eth to our players & rounds ICO phase investment. this will be used
995         // to determine total keys and each players share
996         plyrRnds_[_pID][_rID].ico = _eth.add(plyrRnds_[_pID][_rID].ico);
997         round_[_rID].ico = _eth.add(round_[_rID].ico);
998 
999         // add eth in to team eth tracker
1000         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1001 
1002         // send eth share to com, p3d, affiliate, and fomo3d long
1003         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1004 
1005         // calculate gen share
1006         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1007 
1008         // add gen share to rounds ICO phase gen tracker (will be distributed
1009         // when round starts)
1010         round_[_rID].icoGen = _gen.add(round_[_rID].icoGen);
1011 
1012 		// toss 1% into airdrop pot
1013         uint256 _air = (_eth / 100);
1014         airDropPot_ = airDropPot_.add(_air);
1015 
1016         // calculate pot share pot (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share)) - gen
1017         uint256 _pot = (_eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100))).sub(_gen);
1018 
1019         // add eth to pot
1020         round_[_rID].pot = _pot.add(round_[_rID].pot);
1021 
1022         // set up event data
1023         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1024         _eventData_.potAmount = _pot;
1025 
1026         // fire event
1027         endTx(_rID, _pID, _team, _eth, 0, _eventData_);
1028     }
1029 
1030     /**
1031      * @dev this is the core logic for any buy/reload that happens while a round
1032      * is live.
1033      */
1034     function core(uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1035         private
1036     {
1037         // setup local rID
1038         uint256 _rID = rID_;
1039 
1040         // check to see if its a new round (past ICO phase) && keys were bought in ICO phase
1041         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1042             roundClaimICOKeys(_rID);
1043 
1044         // if player is new to round and is owed keys from ICO phase
1045         if (plyrRnds_[_pID][_rID].keys == 0 && plyrRnds_[_pID][_rID].ico > 0)
1046         {
1047             // assign player their keys from ICO phase
1048             plyrRnds_[_pID][_rID].keys = calcPlayerICOPhaseKeys(_pID, _rID);
1049             // zero out ICO phase investment
1050             plyrRnds_[_pID][_rID].ico = 0;
1051         }
1052 
1053         // mint the new keys
1054         uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1055 
1056         // if they bought at least 1 whole key
1057         if (_keys >= 1000000000000000000)
1058         {
1059             updateTimer(_keys, _rID);
1060 
1061             // set new leaders
1062             if (round_[_rID].plyr != _pID)
1063                 round_[_rID].plyr = _pID;
1064             if (round_[_rID].team != _team)
1065                 round_[_rID].team = _team;
1066 
1067             // set the new leader bool to true
1068             _eventData_.compressedData = _eventData_.compressedData + 100;
1069         }
1070 
1071         // manage airdrops
1072         if (_eth >= 100000000000000000)
1073         {
1074             airDropTracker_++;
1075             if (airdrop() == true)
1076             {
1077                 // gib muni
1078                 uint256 _prize;
1079                 if (_eth >= 10000000000000000000)
1080                 {
1081                     // calculate prize and give it to winner
1082                     _prize = ((airDropPot_).mul(75)) / 100;
1083                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1084 
1085                     // adjust airDropPot
1086                     airDropPot_ = (airDropPot_).sub(_prize);
1087 
1088                     // let event know a tier 3 prize was won
1089                     _eventData_.compressedData += 300000000000000000000000000000000;
1090                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1091                     // calculate prize and give it to winner
1092                     _prize = ((airDropPot_).mul(50)) / 100;
1093                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1094 
1095                     // adjust airDropPot
1096                     airDropPot_ = (airDropPot_).sub(_prize);
1097 
1098                     // let event know a tier 2 prize was won
1099                     _eventData_.compressedData += 200000000000000000000000000000000;
1100                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1101                     // calculate prize and give it to winner
1102                     _prize = ((airDropPot_).mul(25)) / 100;
1103                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1104 
1105                     // adjust airDropPot
1106                     airDropPot_ = (airDropPot_).sub(_prize);
1107 
1108                     // let event know a tier 1 prize was won
1109                     _eventData_.compressedData += 100000000000000000000000000000000;
1110                 }
1111                 // set airdrop happened bool to true
1112                 _eventData_.compressedData += 10000000000000000000000000000000;
1113                 // let event know how much was won
1114                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1115 
1116                 // reset air drop tracker
1117                 airDropTracker_ = 0;
1118             }
1119         }
1120 
1121         // store the air drop tracker number (number of buys since last airdrop)
1122         _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1123 
1124         // update player
1125         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1126 
1127         // update round
1128         round_[_rID].keys = _keys.add(round_[_rID].keys);
1129         round_[_rID].eth = _eth.add(round_[_rID].eth);
1130         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1131 
1132         // distribute eth
1133         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1134         _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1135 
1136         // call end tx function to fire end tx event.
1137         endTx(_rID, _pID, _team, _eth, _keys, _eventData_);
1138     }
1139 //==============================================================================
1140 //     _ _ | _   | _ _|_ _  _ _  .
1141 //    (_(_||(_|_||(_| | (_)| _\  .
1142 //==============================================================================
1143     /**
1144      * @dev calculates unmasked earnings (just calculates, does not update mask)
1145      * @return earnings in wei format
1146      */
1147     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1148         private
1149         view
1150         returns(uint256)
1151     {
1152         // if player does not have unclaimed keys bought in ICO phase
1153         // return their earnings based on keys held only.
1154         if (plyrRnds_[_pID][_rIDlast].ico == 0)
1155             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1156         else
1157             if (now > round_[_rIDlast].strt + rndGap_ && round_[_rIDlast].eth == 0)
1158                 return(  (((((round_[_rIDlast].icoGen).mul(1000000000000000000)) / (round_[_rIDlast].ico).keys()).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1159             else
1160                 return(  (((round_[_rIDlast].mask).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1161         // otherwise return earnings based on keys owed from ICO phase
1162         // (this would be a scenario where they only buy during ICO phase, and never
1163         // buy/reload during round)
1164     }
1165 
1166     /**
1167      * @dev average ico phase key price is total eth put in, during ICO phase,
1168      * divided by the number of keys that were bought with that eth.
1169      * -functionhash- 0xdcb6af48
1170      * @return average key price
1171      */
1172     function calcAverageICOPhaseKeyPrice(uint256 _rID)
1173         public
1174         view
1175         returns(uint256)
1176     {
1177         return(  (round_[_rID].ico).mul(1000000000000000000) / (round_[_rID].ico).keys()  );
1178     }
1179 
1180     /**
1181      * @dev at end of ICO phase, each player is entitled to X keys based on final
1182      * average ICO phase key price, and the amount of eth they put in during ICO.
1183      * if a player participates in the round post ICO, these will be "claimed" and
1184      * added to their rounds total keys.  if not, this will be used to calculate
1185      * their gen earnings throughout round and on round end.
1186      * -functionhash- 0x75661f4c
1187      * @return players keys bought during ICO phase
1188      */
1189     function calcPlayerICOPhaseKeys(uint256 _pID, uint256 _rID)
1190         public
1191         view
1192         returns(uint256)
1193     {
1194         if (round_[_rID].icoAvg != 0 || round_[_rID].ico == 0 )
1195             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / round_[_rID].icoAvg  );
1196         else
1197             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / calcAverageICOPhaseKeyPrice(_rID)  );
1198     }
1199 
1200     /**
1201      * @dev returns the amount of keys you would get given an amount of eth.
1202      * - during live round.  this is accurate. (well... unless someone buys before
1203      * you do and ups the price!  you better HURRY!)
1204      * - during ICO phase.  this is the max you would get based on current eth
1205      * invested during ICO phase.  if others invest after you, you will receive
1206      * less.  (so distract them with meme vids till ICO is over)
1207      * -functionhash- 0xce89c80c
1208      * @param _rID round ID you want price for
1209      * @param _eth amount of eth sent in
1210      * @return keys received
1211      */
1212     function calcKeysReceived(uint256 _rID, uint256 _eth)
1213         public
1214         view
1215         returns(uint256)
1216     {
1217         // grab time
1218         uint256 _now = now;
1219 
1220         // is ICO phase over??  & theres eth in the round?
1221         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1222             return ( (round_[_rID].eth).keysRec(_eth) );
1223         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1224             return ( (round_[_rID].ico).keysRec(_eth) );
1225         else // rounds over.  need keys for new round
1226             return ( (_eth).keys() );
1227     }
1228 
1229     /**
1230      * @dev returns current eth price for X keys.
1231      * - during live round.  this is accurate. (well... unless someone buys before
1232      * you do and ups the price!  you better HURRY!)
1233      * - during ICO phase.  this is the max you would get based on current eth
1234      * invested during ICO phase.  if others invest after you, you will receive
1235      * less.  (so distract them with meme vids till ICO is over)
1236      * -functionhash- 0xcf808000
1237      * @param _keys number of keys desired (in 18 decimal format)
1238      * @return amount of eth needed to send
1239      */
1240     function iWantXKeys(uint256 _keys)
1241         public
1242         view
1243         returns(uint256)
1244     {
1245         // setup local rID
1246         uint256 _rID = rID_;
1247 
1248         // grab time
1249         uint256 _now = now;
1250 
1251         // is ICO phase over??  & theres eth in the round?
1252         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1253             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1254         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1255             return ( (((round_[_rID].ico).keys()).add(_keys)).ethRec(_keys) );
1256         else // rounds over.  need price for new round
1257             return ( (_keys).eth() );
1258     }
1259 //==============================================================================
1260 //    _|_ _  _ | _  .
1261 //     | (_)(_)|_\  .
1262 //==============================================================================
1263     /**
1264 	 * @dev receives name/player info from names contract
1265      */
1266     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1267         external
1268     {
1269         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1270         if (pIDxAddr_[_addr] != _pID)
1271             pIDxAddr_[_addr] = _pID;
1272         if (pIDxName_[_name] != _pID)
1273             pIDxName_[_name] = _pID;
1274         if (plyr_[_pID].addr != _addr)
1275             plyr_[_pID].addr = _addr;
1276         if (plyr_[_pID].name != _name)
1277             plyr_[_pID].name = _name;
1278         if (plyr_[_pID].laff != _laff)
1279             plyr_[_pID].laff = _laff;
1280         if (plyrNames_[_pID][_name] == false)
1281             plyrNames_[_pID][_name] = true;
1282     }
1283 
1284     /**
1285      * @dev receives entire player name list
1286      */
1287     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1288         external
1289     {
1290         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1291         if(plyrNames_[_pID][_name] == false)
1292             plyrNames_[_pID][_name] = true;
1293     }
1294 
1295     /**
1296      * @dev gets existing or registers new pID.  use this when a player may be new
1297      * @return pID
1298      */
1299     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1300         private
1301         returns (F3Ddatasets.EventReturns)
1302     {
1303         uint256 _pID = pIDxAddr_[msg.sender];
1304         // if player is new to this version of fomo3d
1305         if (_pID == 0)
1306         {
1307             // grab their player ID, name and last aff ID, from player names contract
1308             _pID = PlayerBook.getPlayerID(msg.sender);
1309             bytes32 _name = PlayerBook.getPlayerName(_pID);
1310             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1311 
1312             // set up player account
1313             pIDxAddr_[msg.sender] = _pID;
1314             plyr_[_pID].addr = msg.sender;
1315 
1316             if (_name != "")
1317             {
1318                 pIDxName_[_name] = _pID;
1319                 plyr_[_pID].name = _name;
1320                 plyrNames_[_pID][_name] = true;
1321             }
1322 
1323             if (_laff != 0 && _laff != _pID)
1324                 plyr_[_pID].laff = _laff;
1325 
1326             // set the new player bool to true
1327             _eventData_.compressedData = _eventData_.compressedData + 1;
1328         }
1329         return (_eventData_);
1330     }
1331 
1332     /**
1333      * @dev checks to make sure user picked a valid team.  if not sets team
1334      * to default (sneks)
1335      */
1336     function verifyTeam(uint256 _team)
1337         private
1338         pure
1339         returns (uint256)
1340     {
1341         if (_team < 0 || _team > 3)
1342             return(2);
1343         else
1344             return(_team);
1345     }
1346 
1347     /**
1348      * @dev decides if round end needs to be run & new round started.  and if
1349      * player unmasked earnings from previously played rounds need to be moved.
1350      */
1351     function manageRoundAndPlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1352         private
1353         returns (F3Ddatasets.EventReturns)
1354     {
1355         // setup local rID
1356         uint256 _rID = rID_;
1357 
1358         // grab time
1359         uint256 _now = now;
1360 
1361         // check to see if round has ended.  we use > instead of >= so that LAST
1362         // second snipe tx can extend the round.
1363         if (_now > round_[_rID].end)
1364         {
1365             // check to see if round end has been run yet.  (distributes pot)
1366             if (round_[_rID].ended == false)
1367             {
1368                 _eventData_ = endRound(_eventData_);
1369                 round_[_rID].ended = true;
1370             }
1371 
1372             // start next round in ICO phase
1373             rID_++;
1374             _rID++;
1375             round_[_rID].strt = _now;
1376             round_[_rID].end = _now.add(rndInit_).add(rndGap_);
1377         }
1378 
1379         // is player new to round?
1380         if (plyr_[_pID].lrnd != _rID)
1381         {
1382             // if player has played a previous round, move their unmasked earnings
1383             // from that round to gen vault.
1384             if (plyr_[_pID].lrnd != 0)
1385                 updateGenVault(_pID, plyr_[_pID].lrnd);
1386 
1387             // update player's last round played
1388             plyr_[_pID].lrnd = _rID;
1389 
1390             // set the joined round bool to true
1391             _eventData_.compressedData = _eventData_.compressedData + 10;
1392         }
1393 
1394         return(_eventData_);
1395     }
1396 
1397     /**
1398      * @dev ends the round. manages paying out winner/splitting up pot
1399      */
1400     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1401         private
1402         returns (F3Ddatasets.EventReturns)
1403     {
1404         // setup local rID
1405         uint256 _rID = rID_;
1406 
1407         // check to round ended with ONLY ico phase transactions
1408         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1409             roundClaimICOKeys(_rID);
1410 
1411         // grab our winning player and team id's
1412         uint256 _winPID = round_[_rID].plyr;
1413         uint256 _winTID = round_[_rID].team;
1414 
1415         // grab our pot amount
1416         uint256 _pot = round_[_rID].pot;
1417 
1418         // calculate our winner share, community rewards, gen share,
1419         // p3d share, and amount reserved for next pot
1420         uint256 _win = (_pot.mul(48)) / 100;
1421         uint256 _com = (_pot / 50);
1422         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1423         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1424         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1425 
1426         // calculate ppt for round mask
1427         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1428         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1429         if (_dust > 0)
1430         {
1431             _gen = _gen.sub(_dust);
1432             _res = _res.add(_dust);
1433         }
1434 
1435         // pay our winner
1436         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1437 
1438         // community rewards
1439         if (!address(coin_base).call.value(_com)())
1440         {
1441             // This ensures Team Just cannot influence the outcome of FoMo3D with
1442             // bank migrations by breaking outgoing transactions.
1443             // Something we would never do. But that's not the point.
1444             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1445             // highest belief that everything we create should be trustless.
1446             // Team JUST, The name you shouldn't have to trust.
1447             _p3d = _p3d.add(_com);
1448             _com = 0;
1449         }
1450 
1451         // distribute gen portion to key holders
1452         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1453 
1454         // send share for p3d to divies
1455         if (_p3d > 0)
1456             coin_base.transfer(_p3d);
1457 
1458         // fill next round pot with its share
1459         round_[_rID + 1].pot += _res;
1460 
1461         // prepare event data
1462         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1463         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1464         _eventData_.winnerAddr = plyr_[_winPID].addr;
1465         _eventData_.winnerName = plyr_[_winPID].name;
1466         _eventData_.amountWon = _win;
1467         _eventData_.genAmount = _gen;
1468         _eventData_.P3DAmount = _p3d;
1469         _eventData_.newPot = _res;
1470 
1471         return(_eventData_);
1472     }
1473 
1474     /**
1475      * @dev takes keys bought during ICO phase, and adds them to round.  pays
1476      * out gen rewards that accumulated during ICO phase
1477      */
1478     function roundClaimICOKeys(uint256 _rID)
1479         private
1480     {
1481         // update round eth to account for ICO phase eth investment
1482         round_[_rID].eth = round_[_rID].ico;
1483 
1484         // add keys to round that were bought during ICO phase
1485         round_[_rID].keys = (round_[_rID].ico).keys();
1486 
1487         // store average ICO key price
1488         round_[_rID].icoAvg = calcAverageICOPhaseKeyPrice(_rID);
1489 
1490         // set round mask from ICO phase
1491         uint256 _ppt = ((round_[_rID].icoGen).mul(1000000000000000000)) / (round_[_rID].keys);
1492         uint256 _dust = (round_[_rID].icoGen).sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000));
1493         if (_dust > 0)
1494             round_[_rID].pot = (_dust).add(round_[_rID].pot);   // <<< your adding to pot and havent updated event data
1495 
1496         // distribute gen portion to key holders
1497         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1498     }
1499 
1500     /**
1501      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1502      */
1503     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1504         private
1505     {
1506         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1507         if (_earnings > 0)
1508         {
1509             // put in gen vault
1510             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1511             // zero out their earnings by updating mask
1512             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1513         }
1514     }
1515 
1516     /**
1517      * @dev updates round timer based on number of whole keys bought.
1518      */
1519     function updateTimer(uint256 _keys, uint256 _rID)
1520         private
1521     {
1522         // calculate time based on number of keys bought
1523         uint256 _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1524 
1525         // grab time
1526         uint256 _now = now;
1527 
1528         // compare to max and set new end time
1529         if (_newTime < (rndMax_).add(_now))
1530             round_[_rID].end = _newTime;
1531         else
1532             round_[_rID].end = rndMax_.add(_now);
1533     }
1534 
1535     /**
1536      * @dev generates a random number between 0-99 and checks to see if thats
1537      * resulted in an airdrop win
1538      * @return do we have a winner?
1539      */
1540     function airdrop()
1541         private
1542         view
1543         returns(bool)
1544     {
1545         uint256 seed = uint256(keccak256(abi.encodePacked(
1546 
1547             (block.timestamp).add
1548             (block.difficulty).add
1549             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1550             (block.gaslimit).add
1551             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1552             (block.number)
1553 
1554         )));
1555         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1556             return(true);
1557         else
1558             return(false);
1559     }
1560 
1561     /**
1562      * @dev distributes eth based on fees to com, aff, and p3d
1563      */
1564     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1565         private
1566         returns(F3Ddatasets.EventReturns)
1567     {
1568         // pay 2% out to community rewards
1569         uint256 _com = _eth / 50;
1570         uint256 _p3d;
1571         if (!address(coin_base).call.value(_com)())
1572         {
1573             // This ensures Team Just cannot influence the outcome of FoMo3D with
1574             // bank migrations by breaking outgoing transactions.
1575             // Something we would never do. But that's not the point.
1576             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1577             // highest belief that everything we create should be trustless.
1578             // Team JUST, The name you shouldn't have to trust.
1579             _p3d = _com;
1580             _com = 0;
1581         }
1582 
1583         // pay 1% out to FoMo3D long
1584         uint256 _long = _eth / 100;
1585         round_[_rID + 1].pot += _long;
1586 
1587         // distribute share to affiliate
1588         uint256 _aff = _eth / 10;
1589 
1590         // decide what to do with affiliate share of fees
1591         // affiliate must not be self, and must have a name registered
1592         if (_affID != _pID && plyr_[_affID].name != '') {
1593             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1594             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1595         } else {
1596             _p3d = _aff;
1597         }
1598 
1599         // pay out p3d
1600         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1601         if (_p3d > 0)
1602         {
1603             coin_base.transfer(_p3d);
1604 
1605             // set up event data
1606             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1607         }
1608 
1609         return(_eventData_);
1610     }
1611 
1612     function potSwap()
1613         external
1614         payable
1615     {
1616         // setup local rID
1617         uint256 _rID = rID_ + 1;
1618 
1619         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1620         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1621     }
1622 
1623     /**
1624      * @dev distributes eth based on fees to gen and pot
1625      */
1626     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1627         private
1628         returns(F3Ddatasets.EventReturns)
1629     {
1630         // calculate gen share
1631         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1632 
1633         // toss 1% into airdrop pot
1634         uint256 _air = (_eth / 100);
1635         airDropPot_ = airDropPot_.add(_air);
1636 
1637         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1638         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1639 
1640         // calculate pot
1641         uint256 _pot = _eth.sub(_gen);
1642 
1643         // distribute gen share (thats what updateMasks() does) and adjust
1644         // balances for dust.
1645         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1646         if (_dust > 0)
1647             _gen = _gen.sub(_dust);
1648 
1649         // add eth to pot
1650         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1651 
1652         // set up event data
1653         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1654         _eventData_.potAmount = _pot;
1655 
1656         return(_eventData_);
1657     }
1658 
1659     /**
1660      * @dev updates masks for round and player when keys are bought
1661      * @return dust left over
1662      */
1663     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1664         private
1665         returns(uint256)
1666     {
1667         /* MASKING NOTES
1668             earnings masks are a tricky thing for people to wrap their minds around.
1669             the basic thing to understand here.  is were going to have a global
1670             tracker based on profit per share for each round, that increases in
1671             relevant proportion to the increase in share supply.
1672 
1673             the player will have an additional mask that basically says "based
1674             on the rounds mask, my shares, and how much i've already withdrawn,
1675             how much is still owed to me?"
1676         */
1677 
1678         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1679         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1680         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1681 
1682         // calculate player earning from their own buy (only based on the keys
1683         // they just bought).  & update player earnings mask
1684         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1685         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1686 
1687         // calculate & return dust
1688         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1689     }
1690 
1691     /**
1692      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1693      * @return earnings in wei format
1694      */
1695     function withdrawEarnings(uint256 _pID)
1696         private
1697         returns(uint256)
1698     {
1699         // update gen vault
1700         updateGenVault(_pID, plyr_[_pID].lrnd);
1701 
1702         // from vaults
1703         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1704         if (_earnings > 0)
1705         {
1706             plyr_[_pID].win = 0;
1707             plyr_[_pID].gen = 0;
1708             plyr_[_pID].aff = 0;
1709         }
1710 
1711         return(_earnings);
1712     }
1713 
1714     /**
1715      * @dev prepares compression data and fires event for buy or reload tx's
1716      */
1717     function endTx(uint256 _rID, uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1718         private
1719     {
1720         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1721         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (_rID * 10000000000000000000000000000000000000000000000000000);
1722 
1723         emit F3Devents.onEndTx
1724         (
1725             _eventData_.compressedData,
1726             _eventData_.compressedIDs,
1727             plyr_[_pID].name,
1728             msg.sender,
1729             _eth,
1730             _keys,
1731             _eventData_.winnerAddr,
1732             _eventData_.winnerName,
1733             _eventData_.amountWon,
1734             _eventData_.newPot,
1735             _eventData_.P3DAmount,
1736             _eventData_.genAmount,
1737             _eventData_.potAmount,
1738             airDropPot_
1739         );
1740     }
1741 //==============================================================================
1742 //    (~ _  _    _._|_    .
1743 //    _)(/_(_|_|| | | \/  .
1744 //====================/=========================================================
1745     /** upon contract deploy, it will be deactivated.  this is a one time
1746      * use function that will activate the contract.  we do this so devs
1747      * have time to set things up on the web end                            **/
1748     bool public activated_ = false;
1749     function activate()
1750         public
1751     {
1752         // only team just can activate
1753         require(
1754             msg.sender == admin,
1755             "only team just can activate"
1756         );
1757 
1758         // can only be ran once
1759         require(activated_ == false, "fomo3d already activated");
1760 
1761         // activate the contract
1762         activated_ = true;
1763 
1764         // lets start first round in ICO phase
1765 		rID_ = 1;
1766         round_[1].strt = now;
1767         round_[1].end = now + rndInit_ + rndGap_;
1768     }
1769 }
1770 
1771 
1772 //==============================================================================
1773 //   __|_ _    __|_ _  .
1774 //  _\ | | |_|(_ | _\  .
1775 //==============================================================================
1776 library F3Ddatasets {
1777     //compressedData key
1778     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1779         // 0 - new player (bool)
1780         // 1 - joined round (bool)
1781         // 2 - new  leader (bool)
1782         // 3-5 - air drop tracker (uint 0-999)
1783         // 6-16 - round end time
1784         // 17 - winnerTeam
1785         // 18 - 28 timestamp
1786         // 29 - team
1787         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1788         // 31 - airdrop happened bool
1789         // 32 - airdrop tier
1790         // 33 - airdrop amount won
1791     //compressedIDs key
1792     // [77-52][51-26][25-0]
1793         // 0-25 - pID
1794         // 26-51 - winPID
1795         // 52-77 - rID
1796     struct EventReturns {
1797         uint256 compressedData;
1798         uint256 compressedIDs;
1799         address winnerAddr;         // winner address
1800         bytes32 winnerName;         // winner name
1801         uint256 amountWon;          // amount won
1802         uint256 newPot;             // amount in new pot
1803         uint256 P3DAmount;          // amount distributed to p3d
1804         uint256 genAmount;          // amount distributed to gen
1805         uint256 potAmount;          // amount added to pot
1806     }
1807     struct Player {
1808         address addr;   // player address
1809         bytes32 name;   // player name
1810         uint256 win;    // winnings vault
1811         uint256 gen;    // general vault
1812         uint256 aff;    // affiliate vault
1813         uint256 lrnd;   // last round played
1814         uint256 laff;   // last affiliate id used
1815     }
1816     struct PlayerRounds {
1817         uint256 eth;    // eth player has added to round (used for eth limiter)
1818         uint256 keys;   // keys
1819         uint256 mask;   // player mask
1820         uint256 ico;    // ICO phase investment
1821     }
1822     struct Round {
1823         uint256 plyr;   // pID of player in lead
1824         uint256 team;   // tID of team in lead
1825         uint256 end;    // time ends/ended
1826         bool ended;     // has round end function been ran
1827         uint256 strt;   // time round started
1828         uint256 keys;   // keys
1829         uint256 eth;    // total eth in
1830         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1831         uint256 mask;   // global mask
1832         uint256 ico;    // total eth sent in during ICO phase
1833         uint256 icoGen; // total eth for gen during ICO phase
1834         uint256 icoAvg; // average key price for ICO phase
1835     }
1836     struct TeamFee {
1837         uint256 gen;    // % of buy in thats paid to key holders of current round
1838         uint256 p3d;    // % of buy in thats paid to p3d holders
1839     }
1840     struct PotSplit {
1841         uint256 gen;    // % of pot thats paid to key holders of current round
1842         uint256 p3d;    // % of pot thats paid to p3d holders
1843     }
1844 }
1845 
1846 //==============================================================================
1847 //  |  _      _ _ | _  .
1848 //  |<(/_\/  (_(_||(_  .
1849 //=======/======================================================================
1850 library F3DKeysCalcFast {
1851     using SafeMath for *;
1852 
1853     /**
1854      * @dev calculates number of keys received given X eth
1855      * @param _curEth current amount of eth in contract
1856      * @param _newEth eth being spent
1857      * @return amount of ticket purchased
1858      */
1859     function keysRec(uint256 _curEth, uint256 _newEth)
1860         internal
1861         pure
1862         returns (uint256)
1863     {
1864         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1865     }
1866 
1867     /**
1868      * @dev calculates amount of eth received if you sold X keys
1869      * @param _curKeys current amount of keys that exist
1870      * @param _sellKeys amount of keys you wish to sell
1871      * @return amount of eth received
1872      */
1873     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1874         internal
1875         pure
1876         returns (uint256)
1877     {
1878         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1879     }
1880 
1881     /**
1882      * @dev calculates how many keys would exist with given an amount of eth
1883      * @param _eth eth "in contract"
1884      * @return number of keys that would exist
1885      */
1886     function keys(uint256 _eth)
1887         internal
1888         pure
1889         returns(uint256)
1890     {
1891         return ((((((_eth).mul(1000000000000000000)).mul(200000000000000000000000000000000)).add(2500000000000000000000000000000000000000000000000000000000000000)).sqrt()).sub(50000000000000000000000000000000)) / (100000000000000);
1892     }
1893 
1894     /**
1895      * @dev calculates how much eth would be in contract given a number of keys
1896      * @param _keys number of keys "in contract"
1897      * @return eth that would exists
1898      */
1899     function eth(uint256 _keys)
1900         internal
1901         pure
1902         returns(uint256)
1903     {
1904         return ((50000000000000).mul(_keys.sq()).add(((100000000000000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1905     }
1906 }
1907 
1908 //==============================================================================
1909 //  . _ _|_ _  _ |` _  _ _  _  .
1910 //  || | | (/_| ~|~(_|(_(/__\  .
1911 //==============================================================================
1912 interface DiviesInterface {
1913     function deposit() external payable;
1914 }
1915 
1916 interface JIincForwarderInterface {
1917     function deposit() external payable returns(bool);
1918     function status() external view returns(address, address, bool);
1919     function startMigration(address _newCorpBank) external returns(bool);
1920     function cancelMigration() external returns(bool);
1921     function finishMigration() external returns(bool);
1922     function setup(address _firstCorpBank) external;
1923 }
1924 
1925 interface PlayerBookInterface {
1926     function getPlayerID(address _addr) external returns (uint256);
1927     function getPlayerName(uint256 _pID) external view returns (bytes32);
1928     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1929     function getPlayerAddr(uint256 _pID) external view returns (address);
1930     function getNameFee() external view returns (uint256);
1931     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1932     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1933     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1934 }
1935 
1936 /**
1937 * @title -Name Filter- v0.1.9
1938 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1939 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1940 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1941 *                                  _____                      _____
1942 *                                 (, /     /)       /) /)    (, /      /)          /)
1943 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1944 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1945 *          ┴ ┴                /   /          .-/ _____   (__ /
1946 *                            (__ /          (_/ (, /                                      /)™
1947 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1948 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1949 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1950 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1951 *              _       __    _      ____      ____  _   _    _____  ____  ___
1952 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1953 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1954 *
1955 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1956 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1957 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1958 */
1959 
1960 library NameFilter {
1961 
1962     /**
1963      * @dev filters name strings
1964      * -converts uppercase to lower case.
1965      * -makes sure it does not start/end with a space
1966      * -makes sure it does not contain multiple spaces in a row
1967      * -cannot be only numbers
1968      * -cannot start with 0x
1969      * -restricts characters to A-Z, a-z, 0-9, and space.
1970      * @return reprocessed string in bytes32 format
1971      */
1972     function nameFilter(string _input)
1973         internal
1974         pure
1975         returns(bytes32)
1976     {
1977         bytes memory _temp = bytes(_input);
1978         uint256 _length = _temp.length;
1979 
1980         //sorry limited to 32 characters
1981         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1982         // make sure it doesnt start with or end with space
1983         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1984         // make sure first two characters are not 0x
1985         if (_temp[0] == 0x30)
1986         {
1987             require(_temp[1] != 0x78, "string cannot start with 0x");
1988             require(_temp[1] != 0x58, "string cannot start with 0X");
1989         }
1990 
1991         // create a bool to track if we have a non number character
1992         bool _hasNonNumber;
1993 
1994         // convert & check
1995         for (uint256 i = 0; i < _length; i++)
1996         {
1997             // if its uppercase A-Z
1998             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1999             {
2000                 // convert to lower case a-z
2001                 _temp[i] = byte(uint(_temp[i]) + 32);
2002 
2003                 // we have a non number
2004                 if (_hasNonNumber == false)
2005                     _hasNonNumber = true;
2006             } else {
2007                 require
2008                 (
2009                     // require character is a space
2010                     _temp[i] == 0x20 ||
2011                     // OR lowercase a-z
2012                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2013                     // or 0-9
2014                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
2015                     "string contains invalid characters"
2016                 );
2017                 // make sure theres not 2x spaces in a row
2018                 if (_temp[i] == 0x20)
2019                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2020 
2021                 // see if we have a character other than a number
2022                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2023                     _hasNonNumber = true;
2024             }
2025         }
2026 
2027         require(_hasNonNumber == true, "string cannot be only numbers");
2028 
2029         bytes32 _ret;
2030         assembly {
2031             _ret := mload(add(_temp, 32))
2032         }
2033         return (_ret);
2034     }
2035 }
2036 
2037 /**
2038  * @title SafeMath v0.1.9
2039  * @dev Math operations with safety checks that throw on error
2040  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2041  * - added sqrt
2042  * - added sq
2043  * - added pwr
2044  * - changed asserts to requires with error log outputs
2045  * - removed div, its useless
2046  */
2047 library SafeMath {
2048 
2049     /**
2050     * @dev Multiplies two numbers, throws on overflow.
2051     */
2052     function mul(uint256 a, uint256 b)
2053         internal
2054         pure
2055         returns (uint256 c)
2056     {
2057         if (a == 0) {
2058             return 0;
2059         }
2060         c = a * b;
2061         require(c / a == b, "SafeMath mul failed");
2062         return c;
2063     }
2064 
2065     /**
2066     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2067     */
2068     function sub(uint256 a, uint256 b)
2069         internal
2070         pure
2071         returns (uint256)
2072     {
2073         require(b <= a, "SafeMath sub failed");
2074         return a - b;
2075     }
2076 
2077     /**
2078     * @dev Adds two numbers, throws on overflow.
2079     */
2080     function add(uint256 a, uint256 b)
2081         internal
2082         pure
2083         returns (uint256 c)
2084     {
2085         c = a + b;
2086         require(c >= a, "SafeMath add failed");
2087         return c;
2088     }
2089 
2090     /**
2091      * @dev gives square root of given x.
2092      */
2093     function sqrt(uint256 x)
2094         internal
2095         pure
2096         returns (uint256 y)
2097     {
2098         uint256 z = ((add(x,1)) / 2);
2099         y = x;
2100         while (z < y)
2101         {
2102             y = z;
2103             z = ((add((x / z),z)) / 2);
2104         }
2105     }
2106 
2107     /**
2108      * @dev gives square. multiplies x by x
2109      */
2110     function sq(uint256 x)
2111         internal
2112         pure
2113         returns (uint256)
2114     {
2115         return (mul(x,x));
2116     }
2117 
2118     /**
2119      * @dev x to the power of y
2120      */
2121     function pwr(uint256 x, uint256 y)
2122         internal
2123         pure
2124         returns (uint256)
2125     {
2126         if (x==0)
2127             return (0);
2128         else if (y==0)
2129             return (1);
2130         else
2131         {
2132             uint256 z = x;
2133             for (uint256 i=1; i < y; i++)
2134                 z = mul(z,x);
2135             return (z);
2136         }
2137     }
2138 }