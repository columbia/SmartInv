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
115 contract F3DShopQuick is F3Devents{
116     using SafeMath for uint256;
117     using NameFilter for string;
118     using F3DKeysCalcFast for uint256;
119 
120 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x077c6697C0e6861b0e058bc3D5ba77b9f37434C6);
121 //==============================================================================
122 //     _ _  _  |`. _     _ _ |_ | _  _  .
123 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
124 //=================_|===========================================================
125     address private admin = 0x700D7ccD114D988f0CEDDFCc60dd8c3a2f7b49FB;
126     address private coin_base = 0x4D79AAe78608CF0317F4f785cAF449faDC1ff983;
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
211 
212 
213     }
214 
215     /**
216      * @dev sets boundaries for incoming tx
217      */
218     modifier isWithinLimits(uint256 _eth) {
219         require(_eth >= 1000000000, "pocket lint: not a valid currency");
220         require(_eth <= 100000000000000000000000, "no vitalik, no");    /** NOTE THIS NEEDS TO BE CHECKED **/
221 		_;
222 	}
223 //==============================================================================
224 //     _    |_ |. _   |`    _  __|_. _  _  _  .
225 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
226 //====|=========================================================================
227     /**
228      * @dev emergency buy uses last stored affiliate ID and team snek
229      */
230     function()
231         isActivated()
232         isHuman()
233         isWithinLimits(msg.value)
234         public
235         payable
236     {
237         // set up our tx event data and determine if player is new or not
238         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
239 
240         // fetch player id
241         uint256 _pID = pIDxAddr_[msg.sender];
242 
243         // buy core
244         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
245     }
246 
247     /**
248      * @dev converts all incoming ethereum to keys.
249      * -functionhash- 0x8f38f309 (using ID for affiliate)
250      * -functionhash- 0x98a0871d (using address for affiliate)
251      * -functionhash- 0xa65b37a1 (using name for affiliate)
252      * @param _affCode the ID/address/name of the player who gets the affiliate fee
253      * @param _team what team is the player playing for?
254      */
255     function buyXid(uint256 _affCode, uint256 _team)
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
268         // manage affiliate residuals
269         // if no affiliate code was given or player tried to use their own, lolz
270         if (_affCode == 0 || _affCode == _pID)
271         {
272             // use last stored affiliate code
273             _affCode = plyr_[_pID].laff;
274 
275         // if affiliate code was given & its not the same as previously stored
276         } else if (_affCode != plyr_[_pID].laff) {
277             // update last affiliate
278             plyr_[_pID].laff = _affCode;
279         }
280 
281         // verify a valid team was selected
282         _team = verifyTeam(_team);
283 
284         // buy core
285         buyCore(_pID, _affCode, _team, _eventData_);
286     }
287 
288     function buyXaddr(address _affCode, uint256 _team)
289         isActivated()
290         isHuman()
291         isWithinLimits(msg.value)
292         public
293         payable
294     {
295         // set up our tx event data and determine if player is new or not
296         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
297 
298         // fetch player id
299         uint256 _pID = pIDxAddr_[msg.sender];
300 
301         // manage affiliate residuals
302         uint256 _affID;
303         // if no affiliate code was given or player tried to use their own, lolz
304         if (_affCode == address(0) || _affCode == msg.sender)
305         {
306             // use last stored affiliate code
307             _affID = plyr_[_pID].laff;
308 
309         // if affiliate code was given
310         } else {
311             // get affiliate ID from aff Code
312             _affID = pIDxAddr_[_affCode];
313 
314             // if affID is not the same as previously stored
315             if (_affID != plyr_[_pID].laff)
316             {
317                 // update last affiliate
318                 plyr_[_pID].laff = _affID;
319             }
320         }
321 
322         // verify a valid team was selected
323         _team = verifyTeam(_team);
324 
325         // buy core
326         buyCore(_pID, _affID, _team, _eventData_);
327     }
328 
329     function buyXname(bytes32 _affCode, uint256 _team)
330         isActivated()
331         isHuman()
332         isWithinLimits(msg.value)
333         public
334         payable
335     {
336         // set up our tx event data and determine if player is new or not
337         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
338 
339         // fetch player id
340         uint256 _pID = pIDxAddr_[msg.sender];
341 
342         // manage affiliate residuals
343         uint256 _affID;
344         // if no affiliate code was given or player tried to use their own, lolz
345         if (_affCode == '' || _affCode == plyr_[_pID].name)
346         {
347             // use last stored affiliate code
348             _affID = plyr_[_pID].laff;
349 
350         // if affiliate code was given
351         } else {
352             // get affiliate ID from aff Code
353             _affID = pIDxName_[_affCode];
354 
355             // if affID is not the same as previously stored
356             if (_affID != plyr_[_pID].laff)
357             {
358                 // update last affiliate
359                 plyr_[_pID].laff = _affID;
360             }
361         }
362 
363         // verify a valid team was selected
364         _team = verifyTeam(_team);
365 
366         // buy core
367         buyCore(_pID, _affID, _team, _eventData_);
368     }
369 
370     /**
371      * @dev essentially the same as buy, but instead of you sending ether
372      * from your wallet, it uses your unwithdrawn earnings.
373      * -functionhash- 0x349cdcac (using ID for affiliate)
374      * -functionhash- 0x82bfc739 (using address for affiliate)
375      * -functionhash- 0x079ce327 (using name for affiliate)
376      * @param _affCode the ID/address/name of the player who gets the affiliate fee
377      * @param _team what team is the player playing for?
378      * @param _eth amount of earnings to use (remainder returned to gen vault)
379      */
380     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
381         isActivated()
382         isHuman()
383         isWithinLimits(_eth)
384         public
385     {
386         // set up our tx event data
387         F3Ddatasets.EventReturns memory _eventData_;
388 
389         // fetch player ID
390         uint256 _pID = pIDxAddr_[msg.sender];
391 
392         // manage affiliate residuals
393         // if no affiliate code was given or player tried to use their own, lolz
394         if (_affCode == 0 || _affCode == _pID)
395         {
396             // use last stored affiliate code
397             _affCode = plyr_[_pID].laff;
398 
399         // if affiliate code was given & its not the same as previously stored
400         } else if (_affCode != plyr_[_pID].laff) {
401             // update last affiliate
402             plyr_[_pID].laff = _affCode;
403         }
404 
405         // verify a valid team was selected
406         _team = verifyTeam(_team);
407 
408         // reload core
409         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
410     }
411 
412     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
413         isActivated()
414         isHuman()
415         isWithinLimits(_eth)
416         public
417     {
418         // set up our tx event data
419         F3Ddatasets.EventReturns memory _eventData_;
420 
421         // fetch player ID
422         uint256 _pID = pIDxAddr_[msg.sender];
423 
424         // manage affiliate residuals
425         uint256 _affID;
426         // if no affiliate code was given or player tried to use their own, lolz
427         if (_affCode == address(0) || _affCode == msg.sender)
428         {
429             // use last stored affiliate code
430             _affID = plyr_[_pID].laff;
431 
432         // if affiliate code was given
433         } else {
434             // get affiliate ID from aff Code
435             _affID = pIDxAddr_[_affCode];
436 
437             // if affID is not the same as previously stored
438             if (_affID != plyr_[_pID].laff)
439             {
440                 // update last affiliate
441                 plyr_[_pID].laff = _affID;
442             }
443         }
444 
445         // verify a valid team was selected
446         _team = verifyTeam(_team);
447 
448         // reload core
449         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
450     }
451 
452     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
453         isActivated()
454         isHuman()
455         isWithinLimits(_eth)
456         public
457     {
458         // set up our tx event data
459         F3Ddatasets.EventReturns memory _eventData_;
460 
461         // fetch player ID
462         uint256 _pID = pIDxAddr_[msg.sender];
463 
464         // manage affiliate residuals
465         uint256 _affID;
466         // if no affiliate code was given or player tried to use their own, lolz
467         if (_affCode == '' || _affCode == plyr_[_pID].name)
468         {
469             // use last stored affiliate code
470             _affID = plyr_[_pID].laff;
471 
472         // if affiliate code was given
473         } else {
474             // get affiliate ID from aff Code
475             _affID = pIDxName_[_affCode];
476 
477             // if affID is not the same as previously stored
478             if (_affID != plyr_[_pID].laff)
479             {
480                 // update last affiliate
481                 plyr_[_pID].laff = _affID;
482             }
483         }
484 
485         // verify a valid team was selected
486         _team = verifyTeam(_team);
487 
488         // reload core
489         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
490     }
491 
492     /**
493      * @dev withdraws all of your earnings.
494      * -functionhash- 0x3ccfd60b
495      */
496     function withdraw()
497         isActivated()
498         isHuman()
499         public
500     {
501         // setup local rID
502         uint256 _rID = rID_;
503 
504         // grab time
505         uint256 _now = now;
506 
507         // fetch player ID
508         uint256 _pID = pIDxAddr_[msg.sender];
509 
510         // setup temp var for player eth
511         uint256 _eth;
512 
513         // check to see if round has ended and no one has run round end yet
514         if (_now > round_[_rID].end && round_[_rID].ended == false)
515         {
516             // set up our tx event data
517             F3Ddatasets.EventReturns memory _eventData_;
518 
519             // end the round (distributes pot)
520 			round_[_rID].ended = true;
521             _eventData_ = endRound(_eventData_);
522 
523 			// get their earnings
524             _eth = withdrawEarnings(_pID);
525 
526             // gib moni
527             if (_eth > 0)
528                 plyr_[_pID].addr.transfer(_eth);
529 
530             // build event data
531             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
532             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
533 
534             // fire withdraw and distribute event
535             emit F3Devents.onWithdrawAndDistribute
536             (
537                 msg.sender,
538                 plyr_[_pID].name,
539                 _eth,
540                 _eventData_.compressedData,
541                 _eventData_.compressedIDs,
542                 _eventData_.winnerAddr,
543                 _eventData_.winnerName,
544                 _eventData_.amountWon,
545                 _eventData_.newPot,
546                 _eventData_.P3DAmount,
547                 _eventData_.genAmount
548             );
549 
550         // in any other situation
551         } else {
552             // get their earnings
553             _eth = withdrawEarnings(_pID);
554 
555             // gib moni
556             if (_eth > 0)
557                 plyr_[_pID].addr.transfer(_eth);
558 
559             // fire withdraw event
560             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
561         }
562     }
563 
564     /**
565      * @dev use these to register names.  they are just wrappers that will send the
566      * registration requests to the PlayerBook contract.  So registering here is the
567      * same as registering there.  UI will always display the last name you registered.
568      * but you will still own all previously registered names to use as affiliate
569      * links.
570      * - must pay a registration fee.
571      * - name must be unique
572      * - names will be converted to lowercase
573      * - name cannot start or end with a space
574      * - cannot have more than 1 space in a row
575      * - cannot be only numbers
576      * - cannot start with 0x
577      * - name must be at least 1 char
578      * - max length of 32 characters long
579      * - allowed characters: a-z, 0-9, and space
580      * -functionhash- 0x921dec21 (using ID for affiliate)
581      * -functionhash- 0x3ddd4698 (using address for affiliate)
582      * -functionhash- 0x685ffd83 (using name for affiliate)
583      * @param _nameString players desired name
584      * @param _affCode affiliate ID, address, or name of who referred you
585      * @param _all set to true if you want this to push your info to all games
586      * (this might cost a lot of gas)
587      */
588     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
589         isHuman()
590         public
591         payable
592     {
593         bytes32 _name = _nameString.nameFilter();
594         address _addr = msg.sender;
595         uint256 _paid = msg.value;
596         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
597 
598         uint256 _pID = pIDxAddr_[_addr];
599 
600         // fire event
601         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
602     }
603 
604     function registerNameXaddr(string _nameString, address _affCode, bool _all)
605         isHuman()
606         public
607         payable
608     {
609         bytes32 _name = _nameString.nameFilter();
610         address _addr = msg.sender;
611         uint256 _paid = msg.value;
612         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
613 
614         uint256 _pID = pIDxAddr_[_addr];
615 
616         // fire event
617         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
618     }
619 
620     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
621         isHuman()
622         public
623         payable
624     {
625         bytes32 _name = _nameString.nameFilter();
626         address _addr = msg.sender;
627         uint256 _paid = msg.value;
628         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
629 
630         uint256 _pID = pIDxAddr_[_addr];
631 
632         // fire event
633         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
634     }
635 //==============================================================================
636 //     _  _ _|__|_ _  _ _  .
637 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
638 //=====_|=======================================================================
639     /**
640      * @dev return the price buyer will pay for next 1 individual key.
641      * - during live round.  this is accurate. (well... unless someone buys before
642      * you do and ups the price!  you better HURRY!)
643      * - during ICO phase.  this is the max you would get based on current eth
644      * invested during ICO phase.  if others invest after you, you will receive
645      * less.  (so distract them with meme vids till ICO is over)
646      * -functionhash- 0x018a25e8
647      * @return price for next key bought (in wei format)
648      */
649     function getBuyPrice()
650         public
651         view
652         returns(uint256)
653     {
654         // setup local rID
655         uint256 _rID = rID_;
656 
657         // grab time
658         uint256 _now = now;
659 
660         // is ICO phase over??  & theres eth in the round?
661         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
662             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
663         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
664             return ( ((round_[_rID].ico.keys()).add(1000000000000000000)).ethRec(1000000000000000000) );
665         else // rounds over.  need price for new round
666             return ( 100000000000000 ); // init
667     }
668 
669     /**
670      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
671      * provider
672      * -functionhash- 0xc7e284b8
673      * @return time left in seconds
674      */
675     function getTimeLeft()
676         public
677         view
678         returns(uint256)
679     {
680         // setup local rID
681         uint256 _rID = rID_;
682 
683         // grab time
684         uint256 _now = now;
685 
686         // are we in ICO phase?
687         if (_now <= round_[_rID].strt + rndGap_)
688             return( ((round_[_rID].end).sub(rndInit_)).sub(_now) );
689         else
690             if (_now < round_[_rID].end)
691                 return( (round_[_rID].end).sub(_now) );
692             else
693                 return(0);
694     }
695 
696     /**
697      * @dev returns player earnings per vaults
698      * -functionhash- 0x63066434
699      * @return winnings vault
700      * @return general vault
701      * @return affiliate vault
702      */
703     function getPlayerVaults(uint256 _pID)
704         public
705         view
706         returns(uint256 ,uint256, uint256)
707     {
708         // setup local rID
709         uint256 _rID = rID_;
710 
711         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
712         if (now > round_[_rID].end && round_[_rID].ended == false)
713         {
714             uint256 _roundMask;
715             uint256 _roundEth;
716             uint256 _roundKeys;
717             uint256 _roundPot;
718             if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
719             {
720                 // create a temp round eth based on eth sent in during ICO phase
721                 _roundEth = round_[_rID].ico;
722 
723                 // create a temp round keys based on keys bought during ICO phase
724                 _roundKeys = (round_[_rID].ico).keys();
725 
726                 // create a temp round mask based on eth and keys from ICO phase
727                 _roundMask = ((round_[_rID].icoGen).mul(1000000000000000000)) / _roundKeys;
728 
729                 // create a temp rount pot based on pot, and dust from mask
730                 _roundPot = (round_[_rID].pot).add((round_[_rID].icoGen).sub((_roundMask.mul(_roundKeys)) / (1000000000000000000)));
731             } else {
732                 _roundEth = round_[_rID].eth;
733                 _roundKeys = round_[_rID].keys;
734                 _roundMask = round_[_rID].mask;
735                 _roundPot = round_[_rID].pot;
736             }
737 
738             uint256 _playerKeys;
739             if (plyrRnds_[_pID][plyr_[_pID].lrnd].ico == 0)
740                 _playerKeys = plyrRnds_[_pID][plyr_[_pID].lrnd].keys;
741             else
742                 _playerKeys = calcPlayerICOPhaseKeys(_pID, _rID);
743 
744             // if player is winner
745             if (round_[_rID].plyr == _pID)
746             {
747                 return
748                 (
749                     (plyr_[_pID].win).add( (_roundPot.mul(48)) / 100 ),
750                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
751                     plyr_[_pID].aff
752                 );
753             // if player is not the winner
754             } else {
755                 return
756                 (
757                     plyr_[_pID].win,
758                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
759                     plyr_[_pID].aff
760                 );
761             }
762 
763         // if round is still going on, we are in ico phase, or round has ended and round end has been ran
764         } else {
765             return
766             (
767                 plyr_[_pID].win,
768                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
769                 plyr_[_pID].aff
770             );
771         }
772     }
773 
774     /**
775      * solidity hates stack limits.  this lets us avoid that hate
776      */
777     function getPlayerVaultsHelper(uint256 _pID, uint256 _roundMask, uint256 _roundPot, uint256 _roundKeys, uint256 _playerKeys)
778         private
779         view
780         returns(uint256)
781     {
782         return(  (((_roundMask.add((((_roundPot.mul(potSplit_[round_[rID_].team].gen)) / 100).mul(1000000000000000000)) / _roundKeys)).mul(_playerKeys)) / 1000000000000000000).sub(plyrRnds_[_pID][rID_].mask)  );
783     }
784 
785     /**
786      * @dev returns all current round info needed for front end
787      * -functionhash- 0x747dff42
788      * @return eth invested during ICO phase
789      * @return round id
790      * @return total keys for round
791      * @return time round ends
792      * @return time round started
793      * @return current pot
794      * @return current team ID & player ID in lead
795      * @return current player in leads address
796      * @return current player in leads name
797      * @return whales eth in for round
798      * @return bears eth in for round
799      * @return sneks eth in for round
800      * @return bulls eth in for round
801      * @return airdrop tracker # & airdrop pot
802      */
803     function getCurrentRoundInfo()
804         public
805         view
806         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
807     {
808         // setup local rID
809         uint256 _rID = rID_;
810 
811         if (round_[_rID].eth != 0)
812         {
813             return
814             (
815                 round_[_rID].ico,               //0
816                 _rID,                           //1
817                 round_[_rID].keys,              //2
818                 round_[_rID].end,               //3
819                 round_[_rID].strt,              //4
820                 round_[_rID].pot,               //5
821                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
822                 plyr_[round_[_rID].plyr].addr,  //7
823                 plyr_[round_[_rID].plyr].name,  //8
824                 rndTmEth_[_rID][0],             //9
825                 rndTmEth_[_rID][1],             //10
826                 rndTmEth_[_rID][2],             //11
827                 rndTmEth_[_rID][3],             //12
828                 airDropTracker_ + (airDropPot_ * 1000)              //13
829             );
830         } else {
831             return
832             (
833                 round_[_rID].ico,               //0
834                 _rID,                           //1
835                 (round_[_rID].ico).keys(),      //2
836                 round_[_rID].end,               //3
837                 round_[_rID].strt,              //4
838                 round_[_rID].pot,               //5
839                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
840                 plyr_[round_[_rID].plyr].addr,  //7
841                 plyr_[round_[_rID].plyr].name,  //8
842                 rndTmEth_[_rID][0],             //9
843                 rndTmEth_[_rID][1],             //10
844                 rndTmEth_[_rID][2],             //11
845                 rndTmEth_[_rID][3],             //12
846                 airDropTracker_ + (airDropPot_ * 1000)              //13
847             );
848         }
849     }
850 
851     /**
852      * @dev returns player info based on address.  if no address is given, it will
853      * use msg.sender
854      * -functionhash- 0xee0b5d8b
855      * @param _addr address of the player you want to lookup
856      * @return player ID
857      * @return player name
858      * @return keys owned (current round)
859      * @return winnings vault
860      * @return general vault
861      * @return affiliate vault
862 	 * @return player ico eth
863      */
864     function getPlayerInfoByAddress(address _addr)
865         public
866         view
867         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
868     {
869         // setup local rID
870         uint256 _rID = rID_;
871 
872         if (_addr == address(0))
873         {
874             _addr == msg.sender;
875         }
876         uint256 _pID = pIDxAddr_[_addr];
877 
878         if (plyrRnds_[_pID][_rID].ico == 0)
879         {
880             return
881             (
882                 _pID,                               //0
883                 plyr_[_pID].name,                   //1
884                 plyrRnds_[_pID][_rID].keys,         //2
885                 plyr_[_pID].win,                    //3
886                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
887                 plyr_[_pID].aff,                    //5
888 				0						            //6
889             );
890         } else {
891             return
892             (
893                 _pID,                               //0
894                 plyr_[_pID].name,                   //1
895                 calcPlayerICOPhaseKeys(_pID, _rID), //2
896                 plyr_[_pID].win,                    //3
897                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
898                 plyr_[_pID].aff,                    //5
899 				plyrRnds_[_pID][_rID].ico           //6
900             );
901         }
902 
903     }
904 
905 //==============================================================================
906 //     _ _  _ _   | _  _ . _  .
907 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
908 //=====================_|=======================================================
909     /**
910      * @dev logic runs whenever a buy order is executed.  determines how to handle
911      * incoming eth depending on if we are in ICO phase or not
912      */
913     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
914         private
915     {
916         // check to see if round has ended.  and if player is new to round
917         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
918 
919         // are we in ICO phase?
920         if (now <= round_[rID_].strt + rndGap_)
921         {
922             // let event data know this is a ICO phase buy order
923             _eventData_.compressedData = _eventData_.compressedData + 2000000000000000000000000000000;
924 
925             // ICO phase core
926             icoPhaseCore(_pID, msg.value, _team, _affID, _eventData_);
927 
928 
929         // round is live
930         } else {
931              // let event data know this is a buy order
932             _eventData_.compressedData = _eventData_.compressedData + 1000000000000000000000000000000;
933 
934             // call core
935             core(_pID, msg.value, _affID, _team, _eventData_);
936         }
937     }
938 
939     /**
940      * @dev logic runs whenever a reload order is executed.  determines how to handle
941      * incoming eth depending on if we are in ICO phase or not
942      */
943     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
944         private
945     {
946         // check to see if round has ended.  and if player is new to round
947         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
948 
949         // get earnings from all vaults and return unused to gen vault
950         // because we use a custom safemath library.  this will throw if player
951         // tried to spend more eth than they have.
952         plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
953 
954         // are we in ICO phase?
955         if (now <= round_[rID_].strt + rndGap_)
956         {
957             // let event data know this is an ICO phase reload
958             _eventData_.compressedData = _eventData_.compressedData + 3000000000000000000000000000000;
959 
960             // ICO phase core
961             icoPhaseCore(_pID, _eth, _team, _affID, _eventData_);
962 
963 
964         // round is live
965         } else {
966             // call core
967             core(_pID, _eth, _affID, _team, _eventData_);
968         }
969     }
970 
971     /**
972      * @dev during ICO phase all eth sent in by each player.  will be added to an
973      * "investment pool".  upon end of ICO phase, all eth will be used to buy keys.
974      * each player receives an amount based on how much they put in, and the
975      * the average price attained.
976      */
977     function icoPhaseCore(uint256 _pID, uint256 _eth, uint256 _team, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
978         private
979     {
980         // setup local rID
981         uint256 _rID = rID_;
982 
983         // if they bought at least 1 whole key (at time of purchase)
984         if ((round_[_rID].ico).keysRec(_eth) >= 1000000000000000000 || round_[_rID].plyr == 0)
985         {
986             // set new leaders
987             if (round_[_rID].plyr != _pID)
988                 round_[_rID].plyr = _pID;
989             if (round_[_rID].team != _team)
990                 round_[_rID].team = _team;
991 
992             // set the new leader bool to true
993             _eventData_.compressedData = _eventData_.compressedData + 100;
994         }
995 
996         // add eth to our players & rounds ICO phase investment. this will be used
997         // to determine total keys and each players share
998         plyrRnds_[_pID][_rID].ico = _eth.add(plyrRnds_[_pID][_rID].ico);
999         round_[_rID].ico = _eth.add(round_[_rID].ico);
1000 
1001         // add eth in to team eth tracker
1002         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1003 
1004         // send eth share to com, p3d, affiliate, and fomo3d long
1005         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1006 
1007         // calculate gen share
1008         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1009 
1010         // add gen share to rounds ICO phase gen tracker (will be distributed
1011         // when round starts)
1012         round_[_rID].icoGen = _gen.add(round_[_rID].icoGen);
1013 
1014 		// toss 1% into airdrop pot
1015         uint256 _air = (_eth / 100);
1016         airDropPot_ = airDropPot_.add(_air);
1017 
1018         // calculate pot share pot (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share)) - gen
1019         uint256 _pot = (_eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100))).sub(_gen);
1020 
1021         // add eth to pot
1022         round_[_rID].pot = _pot.add(round_[_rID].pot);
1023 
1024         // set up event data
1025         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1026         _eventData_.potAmount = _pot;
1027 
1028         // fire event
1029         endTx(_rID, _pID, _team, _eth, 0, _eventData_);
1030     }
1031 
1032     /**
1033      * @dev this is the core logic for any buy/reload that happens while a round
1034      * is live.
1035      */
1036     function core(uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1037         private
1038     {
1039         // setup local rID
1040         uint256 _rID = rID_;
1041 
1042         // check to see if its a new round (past ICO phase) && keys were bought in ICO phase
1043         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1044             roundClaimICOKeys(_rID);
1045 
1046         // if player is new to round and is owed keys from ICO phase
1047         if (plyrRnds_[_pID][_rID].keys == 0 && plyrRnds_[_pID][_rID].ico > 0)
1048         {
1049             // assign player their keys from ICO phase
1050             plyrRnds_[_pID][_rID].keys = calcPlayerICOPhaseKeys(_pID, _rID);
1051             // zero out ICO phase investment
1052             plyrRnds_[_pID][_rID].ico = 0;
1053         }
1054 
1055         // mint the new keys
1056         uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1057 
1058         // if they bought at least 1 whole key
1059         if (_keys >= 1000000000000000000)
1060         {
1061             updateTimer(_keys, _rID);
1062 
1063             // set new leaders
1064             if (round_[_rID].plyr != _pID)
1065                 round_[_rID].plyr = _pID;
1066             if (round_[_rID].team != _team)
1067                 round_[_rID].team = _team;
1068 
1069             // set the new leader bool to true
1070             _eventData_.compressedData = _eventData_.compressedData + 100;
1071         }
1072 
1073         // manage airdrops
1074         if (_eth >= 100000000000000000)
1075         {
1076             airDropTracker_++;
1077             if (airdrop() == true)
1078             {
1079                 // gib muni
1080                 uint256 _prize;
1081                 if (_eth >= 10000000000000000000)
1082                 {
1083                     // calculate prize and give it to winner
1084                     _prize = ((airDropPot_).mul(75)) / 100;
1085                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1086 
1087                     // adjust airDropPot
1088                     airDropPot_ = (airDropPot_).sub(_prize);
1089 
1090                     // let event know a tier 3 prize was won
1091                     _eventData_.compressedData += 300000000000000000000000000000000;
1092                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1093                     // calculate prize and give it to winner
1094                     _prize = ((airDropPot_).mul(50)) / 100;
1095                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1096 
1097                     // adjust airDropPot
1098                     airDropPot_ = (airDropPot_).sub(_prize);
1099 
1100                     // let event know a tier 2 prize was won
1101                     _eventData_.compressedData += 200000000000000000000000000000000;
1102                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1103                     // calculate prize and give it to winner
1104                     _prize = ((airDropPot_).mul(25)) / 100;
1105                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1106 
1107                     // adjust airDropPot
1108                     airDropPot_ = (airDropPot_).sub(_prize);
1109 
1110                     // let event know a tier 1 prize was won
1111                     _eventData_.compressedData += 100000000000000000000000000000000;
1112                 }
1113                 // set airdrop happened bool to true
1114                 _eventData_.compressedData += 10000000000000000000000000000000;
1115                 // let event know how much was won
1116                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1117 
1118                 // reset air drop tracker
1119                 airDropTracker_ = 0;
1120             }
1121         }
1122 
1123         // store the air drop tracker number (number of buys since last airdrop)
1124         _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1125 
1126         // update player
1127         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1128 
1129         // update round
1130         round_[_rID].keys = _keys.add(round_[_rID].keys);
1131         round_[_rID].eth = _eth.add(round_[_rID].eth);
1132         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1133 
1134         // distribute eth
1135         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1136         _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1137 
1138         // call end tx function to fire end tx event.
1139         endTx(_rID, _pID, _team, _eth, _keys, _eventData_);
1140     }
1141 //==============================================================================
1142 //     _ _ | _   | _ _|_ _  _ _  .
1143 //    (_(_||(_|_||(_| | (_)| _\  .
1144 //==============================================================================
1145     /**
1146      * @dev calculates unmasked earnings (just calculates, does not update mask)
1147      * @return earnings in wei format
1148      */
1149     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1150         private
1151         view
1152         returns(uint256)
1153     {
1154         // if player does not have unclaimed keys bought in ICO phase
1155         // return their earnings based on keys held only.
1156         if (plyrRnds_[_pID][_rIDlast].ico == 0)
1157             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1158         else
1159             if (now > round_[_rIDlast].strt + rndGap_ && round_[_rIDlast].eth == 0)
1160                 return(  (((((round_[_rIDlast].icoGen).mul(1000000000000000000)) / (round_[_rIDlast].ico).keys()).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1161             else
1162                 return(  (((round_[_rIDlast].mask).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1163         // otherwise return earnings based on keys owed from ICO phase
1164         // (this would be a scenario where they only buy during ICO phase, and never
1165         // buy/reload during round)
1166     }
1167 
1168     /**
1169      * @dev average ico phase key price is total eth put in, during ICO phase,
1170      * divided by the number of keys that were bought with that eth.
1171      * -functionhash- 0xdcb6af48
1172      * @return average key price
1173      */
1174     function calcAverageICOPhaseKeyPrice(uint256 _rID)
1175         public
1176         view
1177         returns(uint256)
1178     {
1179         return(  (round_[_rID].ico).mul(1000000000000000000) / (round_[_rID].ico).keys()  );
1180     }
1181 
1182     /**
1183      * @dev at end of ICO phase, each player is entitled to X keys based on final
1184      * average ICO phase key price, and the amount of eth they put in during ICO.
1185      * if a player participates in the round post ICO, these will be "claimed" and
1186      * added to their rounds total keys.  if not, this will be used to calculate
1187      * their gen earnings throughout round and on round end.
1188      * -functionhash- 0x75661f4c
1189      * @return players keys bought during ICO phase
1190      */
1191     function calcPlayerICOPhaseKeys(uint256 _pID, uint256 _rID)
1192         public
1193         view
1194         returns(uint256)
1195     {
1196         if (round_[_rID].icoAvg != 0 || round_[_rID].ico == 0 )
1197             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / round_[_rID].icoAvg  );
1198         else
1199             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / calcAverageICOPhaseKeyPrice(_rID)  );
1200     }
1201 
1202     /**
1203      * @dev returns the amount of keys you would get given an amount of eth.
1204      * - during live round.  this is accurate. (well... unless someone buys before
1205      * you do and ups the price!  you better HURRY!)
1206      * - during ICO phase.  this is the max you would get based on current eth
1207      * invested during ICO phase.  if others invest after you, you will receive
1208      * less.  (so distract them with meme vids till ICO is over)
1209      * -functionhash- 0xce89c80c
1210      * @param _rID round ID you want price for
1211      * @param _eth amount of eth sent in
1212      * @return keys received
1213      */
1214     function calcKeysReceived(uint256 _rID, uint256 _eth)
1215         public
1216         view
1217         returns(uint256)
1218     {
1219         // grab time
1220         uint256 _now = now;
1221 
1222         // is ICO phase over??  & theres eth in the round?
1223         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1224             return ( (round_[_rID].eth).keysRec(_eth) );
1225         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1226             return ( (round_[_rID].ico).keysRec(_eth) );
1227         else // rounds over.  need keys for new round
1228             return ( (_eth).keys() );
1229     }
1230 
1231     /**
1232      * @dev returns current eth price for X keys.
1233      * - during live round.  this is accurate. (well... unless someone buys before
1234      * you do and ups the price!  you better HURRY!)
1235      * - during ICO phase.  this is the max you would get based on current eth
1236      * invested during ICO phase.  if others invest after you, you will receive
1237      * less.  (so distract them with meme vids till ICO is over)
1238      * -functionhash- 0xcf808000
1239      * @param _keys number of keys desired (in 18 decimal format)
1240      * @return amount of eth needed to send
1241      */
1242     function iWantXKeys(uint256 _keys)
1243         public
1244         view
1245         returns(uint256)
1246     {
1247         // setup local rID
1248         uint256 _rID = rID_;
1249 
1250         // grab time
1251         uint256 _now = now;
1252 
1253         // is ICO phase over??  & theres eth in the round?
1254         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1255             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1256         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1257             return ( (((round_[_rID].ico).keys()).add(_keys)).ethRec(_keys) );
1258         else // rounds over.  need price for new round
1259             return ( (_keys).eth() );
1260     }
1261 //==============================================================================
1262 //    _|_ _  _ | _  .
1263 //     | (_)(_)|_\  .
1264 //==============================================================================
1265     /**
1266 	 * @dev receives name/player info from names contract
1267      */
1268     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1269         external
1270     {
1271         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1272         if (pIDxAddr_[_addr] != _pID)
1273             pIDxAddr_[_addr] = _pID;
1274         if (pIDxName_[_name] != _pID)
1275             pIDxName_[_name] = _pID;
1276         if (plyr_[_pID].addr != _addr)
1277             plyr_[_pID].addr = _addr;
1278         if (plyr_[_pID].name != _name)
1279             plyr_[_pID].name = _name;
1280         if (plyr_[_pID].laff != _laff)
1281             plyr_[_pID].laff = _laff;
1282         if (plyrNames_[_pID][_name] == false)
1283             plyrNames_[_pID][_name] = true;
1284     }
1285 
1286     /**
1287      * @dev receives entire player name list
1288      */
1289     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1290         external
1291     {
1292         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1293         if(plyrNames_[_pID][_name] == false)
1294             plyrNames_[_pID][_name] = true;
1295     }
1296 
1297     /**
1298      * @dev gets existing or registers new pID.  use this when a player may be new
1299      * @return pID
1300      */
1301     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1302         private
1303         returns (F3Ddatasets.EventReturns)
1304     {
1305         uint256 _pID = pIDxAddr_[msg.sender];
1306         // if player is new to this version of fomo3d
1307         if (_pID == 0)
1308         {
1309             // grab their player ID, name and last aff ID, from player names contract
1310             _pID = PlayerBook.getPlayerID(msg.sender);
1311             bytes32 _name = PlayerBook.getPlayerName(_pID);
1312             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1313 
1314             // set up player account
1315             pIDxAddr_[msg.sender] = _pID;
1316             plyr_[_pID].addr = msg.sender;
1317 
1318             if (_name != "")
1319             {
1320                 pIDxName_[_name] = _pID;
1321                 plyr_[_pID].name = _name;
1322                 plyrNames_[_pID][_name] = true;
1323             }
1324 
1325             if (_laff != 0 && _laff != _pID)
1326                 plyr_[_pID].laff = _laff;
1327 
1328             // set the new player bool to true
1329             _eventData_.compressedData = _eventData_.compressedData + 1;
1330         }
1331         return (_eventData_);
1332     }
1333 
1334     /**
1335      * @dev checks to make sure user picked a valid team.  if not sets team
1336      * to default (sneks)
1337      */
1338     function verifyTeam(uint256 _team)
1339         private
1340         pure
1341         returns (uint256)
1342     {
1343         if (_team < 0 || _team > 3)
1344             return(2);
1345         else
1346             return(_team);
1347     }
1348 
1349     /**
1350      * @dev decides if round end needs to be run & new round started.  and if
1351      * player unmasked earnings from previously played rounds need to be moved.
1352      */
1353     function manageRoundAndPlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1354         private
1355         returns (F3Ddatasets.EventReturns)
1356     {
1357         // setup local rID
1358         uint256 _rID = rID_;
1359 
1360         // grab time
1361         uint256 _now = now;
1362 
1363         // check to see if round has ended.  we use > instead of >= so that LAST
1364         // second snipe tx can extend the round.
1365         if (_now > round_[_rID].end)
1366         {
1367             // check to see if round end has been run yet.  (distributes pot)
1368             if (round_[_rID].ended == false)
1369             {
1370                 _eventData_ = endRound(_eventData_);
1371                 round_[_rID].ended = true;
1372             }
1373 
1374             // start next round in ICO phase
1375             rID_++;
1376             _rID++;
1377             round_[_rID].strt = _now;
1378             round_[_rID].end = _now.add(rndInit_).add(rndGap_);
1379         }
1380 
1381         // is player new to round?
1382         if (plyr_[_pID].lrnd != _rID)
1383         {
1384             // if player has played a previous round, move their unmasked earnings
1385             // from that round to gen vault.
1386             if (plyr_[_pID].lrnd != 0)
1387                 updateGenVault(_pID, plyr_[_pID].lrnd);
1388 
1389             // update player's last round played
1390             plyr_[_pID].lrnd = _rID;
1391 
1392             // set the joined round bool to true
1393             _eventData_.compressedData = _eventData_.compressedData + 10;
1394         }
1395 
1396         return(_eventData_);
1397     }
1398 
1399     /**
1400      * @dev ends the round. manages paying out winner/splitting up pot
1401      */
1402     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1403         private
1404         returns (F3Ddatasets.EventReturns)
1405     {
1406         // setup local rID
1407         uint256 _rID = rID_;
1408 
1409         // check to round ended with ONLY ico phase transactions
1410         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1411             roundClaimICOKeys(_rID);
1412 
1413         // grab our winning player and team id's
1414         uint256 _winPID = round_[_rID].plyr;
1415         uint256 _winTID = round_[_rID].team;
1416 
1417         // grab our pot amount
1418         uint256 _pot = round_[_rID].pot;
1419 
1420         // calculate our winner share, community rewards, gen share,
1421         // p3d share, and amount reserved for next pot
1422         uint256 _win = (_pot.mul(48)) / 100;
1423         uint256 _com = (_pot / 50);
1424         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1425         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1426         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1427 
1428         // calculate ppt for round mask
1429         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1430         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1431         if (_dust > 0)
1432         {
1433             _gen = _gen.sub(_dust);
1434             _res = _res.add(_dust);
1435         }
1436 
1437         // pay our winner
1438         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1439 
1440         // community rewards
1441         if (!address(coin_base).call.value(_com)())
1442         {
1443             // This ensures Team Just cannot influence the outcome of FoMo3D with
1444             // bank migrations by breaking outgoing transactions.
1445             // Something we would never do. But that's not the point.
1446             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1447             // highest belief that everything we create should be trustless.
1448             // Team JUST, The name you shouldn't have to trust.
1449             _p3d = _p3d.add(_com);
1450             _com = 0;
1451         }
1452 
1453         // distribute gen portion to key holders
1454         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1455 
1456         // send share for p3d to divies
1457         if (_p3d > 0)
1458             coin_base.transfer(_p3d);
1459 
1460         // fill next round pot with its share
1461         round_[_rID + 1].pot += _res;
1462 
1463         // prepare event data
1464         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1465         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1466         _eventData_.winnerAddr = plyr_[_winPID].addr;
1467         _eventData_.winnerName = plyr_[_winPID].name;
1468         _eventData_.amountWon = _win;
1469         _eventData_.genAmount = _gen;
1470         _eventData_.P3DAmount = _p3d;
1471         _eventData_.newPot = _res;
1472 
1473         return(_eventData_);
1474     }
1475 
1476     /**
1477      * @dev takes keys bought during ICO phase, and adds them to round.  pays
1478      * out gen rewards that accumulated during ICO phase
1479      */
1480     function roundClaimICOKeys(uint256 _rID)
1481         private
1482     {
1483         // update round eth to account for ICO phase eth investment
1484         round_[_rID].eth = round_[_rID].ico;
1485 
1486         // add keys to round that were bought during ICO phase
1487         round_[_rID].keys = (round_[_rID].ico).keys();
1488 
1489         // store average ICO key price
1490         round_[_rID].icoAvg = calcAverageICOPhaseKeyPrice(_rID);
1491 
1492         // set round mask from ICO phase
1493         uint256 _ppt = ((round_[_rID].icoGen).mul(1000000000000000000)) / (round_[_rID].keys);
1494         uint256 _dust = (round_[_rID].icoGen).sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000));
1495         if (_dust > 0)
1496             round_[_rID].pot = (_dust).add(round_[_rID].pot);   // <<< your adding to pot and havent updated event data
1497 
1498         // distribute gen portion to key holders
1499         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1500     }
1501 
1502     /**
1503      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1504      */
1505     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1506         private
1507     {
1508         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1509         if (_earnings > 0)
1510         {
1511             // put in gen vault
1512             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1513             // zero out their earnings by updating mask
1514             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1515         }
1516     }
1517 
1518     /**
1519      * @dev updates round timer based on number of whole keys bought.
1520      */
1521     function updateTimer(uint256 _keys, uint256 _rID)
1522         private
1523     {
1524         // calculate time based on number of keys bought
1525         uint256 _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1526 
1527         // grab time
1528         uint256 _now = now;
1529 
1530         // compare to max and set new end time
1531         if (_newTime < (rndMax_).add(_now))
1532             round_[_rID].end = _newTime;
1533         else
1534             round_[_rID].end = rndMax_.add(_now);
1535     }
1536 
1537     /**
1538      * @dev generates a random number between 0-99 and checks to see if thats
1539      * resulted in an airdrop win
1540      * @return do we have a winner?
1541      */
1542     function airdrop()
1543         private
1544         view
1545         returns(bool)
1546     {
1547         uint256 seed = uint256(keccak256(abi.encodePacked(
1548 
1549             (block.timestamp).add
1550             (block.difficulty).add
1551             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1552             (block.gaslimit).add
1553             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1554             (block.number)
1555 
1556         )));
1557         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1558             return(true);
1559         else
1560             return(false);
1561     }
1562 
1563     /**
1564      * @dev distributes eth based on fees to com, aff, and p3d
1565      */
1566     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1567         private
1568         returns(F3Ddatasets.EventReturns)
1569     {
1570         // pay 2% out to community rewards
1571         uint256 _com = _eth / 50;
1572         uint256 _p3d;
1573         if (!address(coin_base).call.value(_com)())
1574         {
1575             // This ensures Team Just cannot influence the outcome of FoMo3D with
1576             // bank migrations by breaking outgoing transactions.
1577             // Something we would never do. But that's not the point.
1578             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1579             // highest belief that everything we create should be trustless.
1580             // Team JUST, The name you shouldn't have to trust.
1581             _p3d = _com;
1582             _com = 0;
1583         }
1584 
1585         // pay 1% out to FoMo3D long
1586         uint256 _long = _eth / 100;
1587         round_[_rID + 1].pot += _long;
1588 
1589         // distribute share to affiliate
1590         uint256 _aff = _eth / 10;
1591 
1592         // decide what to do with affiliate share of fees
1593         // affiliate must not be self, and must have a name registered
1594         if (_affID != _pID && plyr_[_affID].name != '') {
1595             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1596             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1597         } else {
1598             _p3d = _aff;
1599         }
1600 
1601         // pay out p3d
1602         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1603         if (_p3d > 0)
1604         {
1605             coin_base.transfer(_p3d);
1606 
1607             // set up event data
1608             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1609         }
1610 
1611         return(_eventData_);
1612     }
1613 
1614     function potSwap()
1615         external
1616         payable
1617     {
1618         // setup local rID
1619         uint256 _rID = rID_ + 1;
1620 
1621         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1622         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1623     }
1624 
1625     /**
1626      * @dev distributes eth based on fees to gen and pot
1627      */
1628     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1629         private
1630         returns(F3Ddatasets.EventReturns)
1631     {
1632         // calculate gen share
1633         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1634 
1635         // toss 1% into airdrop pot
1636         uint256 _air = (_eth / 100);
1637         airDropPot_ = airDropPot_.add(_air);
1638 
1639         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1640         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1641 
1642         // calculate pot
1643         uint256 _pot = _eth.sub(_gen);
1644 
1645         // distribute gen share (thats what updateMasks() does) and adjust
1646         // balances for dust.
1647         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1648         if (_dust > 0)
1649             _gen = _gen.sub(_dust);
1650 
1651         // add eth to pot
1652         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1653 
1654         // set up event data
1655         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1656         _eventData_.potAmount = _pot;
1657 
1658         return(_eventData_);
1659     }
1660 
1661     /**
1662      * @dev updates masks for round and player when keys are bought
1663      * @return dust left over
1664      */
1665     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1666         private
1667         returns(uint256)
1668     {
1669         /* MASKING NOTES
1670             earnings masks are a tricky thing for people to wrap their minds around.
1671             the basic thing to understand here.  is were going to have a global
1672             tracker based on profit per share for each round, that increases in
1673             relevant proportion to the increase in share supply.
1674 
1675             the player will have an additional mask that basically says "based
1676             on the rounds mask, my shares, and how much i've already withdrawn,
1677             how much is still owed to me?"
1678         */
1679 
1680         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1681         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1682         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1683 
1684         // calculate player earning from their own buy (only based on the keys
1685         // they just bought).  & update player earnings mask
1686         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1687         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1688 
1689         // calculate & return dust
1690         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1691     }
1692 
1693     /**
1694      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1695      * @return earnings in wei format
1696      */
1697     function withdrawEarnings(uint256 _pID)
1698         private
1699         returns(uint256)
1700     {
1701         // update gen vault
1702         updateGenVault(_pID, plyr_[_pID].lrnd);
1703 
1704         // from vaults
1705         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1706         if (_earnings > 0)
1707         {
1708             plyr_[_pID].win = 0;
1709             plyr_[_pID].gen = 0;
1710             plyr_[_pID].aff = 0;
1711         }
1712 
1713         return(_earnings);
1714     }
1715 
1716     /**
1717      * @dev prepares compression data and fires event for buy or reload tx's
1718      */
1719     function endTx(uint256 _rID, uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1720         private
1721     {
1722         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1723         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (_rID * 10000000000000000000000000000000000000000000000000000);
1724 
1725         emit F3Devents.onEndTx
1726         (
1727             _eventData_.compressedData,
1728             _eventData_.compressedIDs,
1729             plyr_[_pID].name,
1730             msg.sender,
1731             _eth,
1732             _keys,
1733             _eventData_.winnerAddr,
1734             _eventData_.winnerName,
1735             _eventData_.amountWon,
1736             _eventData_.newPot,
1737             _eventData_.P3DAmount,
1738             _eventData_.genAmount,
1739             _eventData_.potAmount,
1740             airDropPot_
1741         );
1742     }
1743 //==============================================================================
1744 //    (~ _  _    _._|_    .
1745 //    _)(/_(_|_|| | | \/  .
1746 //====================/=========================================================
1747     /** upon contract deploy, it will be deactivated.  this is a one time
1748      * use function that will activate the contract.  we do this so devs
1749      * have time to set things up on the web end                            **/
1750     bool public activated_ = false;
1751     function activate()
1752         public
1753     {
1754         // only team just can activate
1755         require(
1756             msg.sender == admin,
1757             "only team just can activate"
1758         );
1759 
1760         // can only be ran once
1761         require(activated_ == false, "fomo3d already activated");
1762 
1763         // activate the contract
1764         activated_ = true;
1765 
1766         // lets start first round in ICO phase
1767 		rID_ = 1;
1768         round_[1].strt = now;
1769         round_[1].end = now + rndInit_ + rndGap_;
1770     }
1771 }
1772 
1773 
1774 //==============================================================================
1775 //   __|_ _    __|_ _  .
1776 //  _\ | | |_|(_ | _\  .
1777 //==============================================================================
1778 library F3Ddatasets {
1779     //compressedData key
1780     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1781         // 0 - new player (bool)
1782         // 1 - joined round (bool)
1783         // 2 - new  leader (bool)
1784         // 3-5 - air drop tracker (uint 0-999)
1785         // 6-16 - round end time
1786         // 17 - winnerTeam
1787         // 18 - 28 timestamp
1788         // 29 - team
1789         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1790         // 31 - airdrop happened bool
1791         // 32 - airdrop tier
1792         // 33 - airdrop amount won
1793     //compressedIDs key
1794     // [77-52][51-26][25-0]
1795         // 0-25 - pID
1796         // 26-51 - winPID
1797         // 52-77 - rID
1798     struct EventReturns {
1799         uint256 compressedData;
1800         uint256 compressedIDs;
1801         address winnerAddr;         // winner address
1802         bytes32 winnerName;         // winner name
1803         uint256 amountWon;          // amount won
1804         uint256 newPot;             // amount in new pot
1805         uint256 P3DAmount;          // amount distributed to p3d
1806         uint256 genAmount;          // amount distributed to gen
1807         uint256 potAmount;          // amount added to pot
1808     }
1809     struct Player {
1810         address addr;   // player address
1811         bytes32 name;   // player name
1812         uint256 win;    // winnings vault
1813         uint256 gen;    // general vault
1814         uint256 aff;    // affiliate vault
1815         uint256 lrnd;   // last round played
1816         uint256 laff;   // last affiliate id used
1817     }
1818     struct PlayerRounds {
1819         uint256 eth;    // eth player has added to round (used for eth limiter)
1820         uint256 keys;   // keys
1821         uint256 mask;   // player mask
1822         uint256 ico;    // ICO phase investment
1823     }
1824     struct Round {
1825         uint256 plyr;   // pID of player in lead
1826         uint256 team;   // tID of team in lead
1827         uint256 end;    // time ends/ended
1828         bool ended;     // has round end function been ran
1829         uint256 strt;   // time round started
1830         uint256 keys;   // keys
1831         uint256 eth;    // total eth in
1832         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1833         uint256 mask;   // global mask
1834         uint256 ico;    // total eth sent in during ICO phase
1835         uint256 icoGen; // total eth for gen during ICO phase
1836         uint256 icoAvg; // average key price for ICO phase
1837     }
1838     struct TeamFee {
1839         uint256 gen;    // % of buy in thats paid to key holders of current round
1840         uint256 p3d;    // % of buy in thats paid to p3d holders
1841     }
1842     struct PotSplit {
1843         uint256 gen;    // % of pot thats paid to key holders of current round
1844         uint256 p3d;    // % of pot thats paid to p3d holders
1845     }
1846 }
1847 
1848 //==============================================================================
1849 //  |  _      _ _ | _  .
1850 //  |<(/_\/  (_(_||(_  .
1851 //=======/======================================================================
1852 library F3DKeysCalcFast {
1853     using SafeMath for *;
1854 
1855     /**
1856      * @dev calculates number of keys received given X eth
1857      * @param _curEth current amount of eth in contract
1858      * @param _newEth eth being spent
1859      * @return amount of ticket purchased
1860      */
1861     function keysRec(uint256 _curEth, uint256 _newEth)
1862         internal
1863         pure
1864         returns (uint256)
1865     {
1866         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1867     }
1868 
1869     /**
1870      * @dev calculates amount of eth received if you sold X keys
1871      * @param _curKeys current amount of keys that exist
1872      * @param _sellKeys amount of keys you wish to sell
1873      * @return amount of eth received
1874      */
1875     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1876         internal
1877         pure
1878         returns (uint256)
1879     {
1880         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1881     }
1882 
1883     /**
1884      * @dev calculates how many keys would exist with given an amount of eth
1885      * @param _eth eth "in contract"
1886      * @return number of keys that would exist
1887      */
1888     function keys(uint256 _eth)
1889         internal
1890         pure
1891         returns(uint256)
1892     {
1893         return ((((((_eth).mul(1000000000000000000)).mul(200000000000000000000000000000000)).add(2500000000000000000000000000000000000000000000000000000000000000)).sqrt()).sub(50000000000000000000000000000000)) / (100000000000000);
1894     }
1895 
1896     /**
1897      * @dev calculates how much eth would be in contract given a number of keys
1898      * @param _keys number of keys "in contract"
1899      * @return eth that would exists
1900      */
1901     function eth(uint256 _keys)
1902         internal
1903         pure
1904         returns(uint256)
1905     {
1906         return ((50000000000000).mul(_keys.sq()).add(((100000000000000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1907     }
1908 }
1909 
1910 //==============================================================================
1911 //  . _ _|_ _  _ |` _  _ _  _  .
1912 //  || | | (/_| ~|~(_|(_(/__\  .
1913 //==============================================================================
1914 interface DiviesInterface {
1915     function deposit() external payable;
1916 }
1917 
1918 interface JIincForwarderInterface {
1919     function deposit() external payable returns(bool);
1920     function status() external view returns(address, address, bool);
1921     function startMigration(address _newCorpBank) external returns(bool);
1922     function cancelMigration() external returns(bool);
1923     function finishMigration() external returns(bool);
1924     function setup(address _firstCorpBank) external;
1925 }
1926 
1927 interface PlayerBookInterface {
1928     function getPlayerID(address _addr) external returns (uint256);
1929     function getPlayerName(uint256 _pID) external view returns (bytes32);
1930     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1931     function getPlayerAddr(uint256 _pID) external view returns (address);
1932     function getNameFee() external view returns (uint256);
1933     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1934     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1935     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1936 }
1937 
1938 /**
1939 * @title -Name Filter- v0.1.9
1940 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1941 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1942 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1943 *                                  _____                      _____
1944 *                                 (, /     /)       /) /)    (, /      /)          /)
1945 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1946 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1947 *          ┴ ┴                /   /          .-/ _____   (__ /
1948 *                            (__ /          (_/ (, /                                      /)™
1949 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1950 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1951 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1952 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1953 *              _       __    _      ____      ____  _   _    _____  ____  ___
1954 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1955 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1956 *
1957 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1958 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1959 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1960 */
1961 
1962 library NameFilter {
1963 
1964     /**
1965      * @dev filters name strings
1966      * -converts uppercase to lower case.
1967      * -makes sure it does not start/end with a space
1968      * -makes sure it does not contain multiple spaces in a row
1969      * -cannot be only numbers
1970      * -cannot start with 0x
1971      * -restricts characters to A-Z, a-z, 0-9, and space.
1972      * @return reprocessed string in bytes32 format
1973      */
1974     function nameFilter(string _input)
1975         internal
1976         pure
1977         returns(bytes32)
1978     {
1979         bytes memory _temp = bytes(_input);
1980         uint256 _length = _temp.length;
1981 
1982         //sorry limited to 32 characters
1983         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1984         // make sure it doesnt start with or end with space
1985         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1986         // make sure first two characters are not 0x
1987         if (_temp[0] == 0x30)
1988         {
1989             require(_temp[1] != 0x78, "string cannot start with 0x");
1990             require(_temp[1] != 0x58, "string cannot start with 0X");
1991         }
1992 
1993         // create a bool to track if we have a non number character
1994         bool _hasNonNumber;
1995 
1996         // convert & check
1997         for (uint256 i = 0; i < _length; i++)
1998         {
1999             // if its uppercase A-Z
2000             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
2001             {
2002                 // convert to lower case a-z
2003                 _temp[i] = byte(uint(_temp[i]) + 32);
2004 
2005                 // we have a non number
2006                 if (_hasNonNumber == false)
2007                     _hasNonNumber = true;
2008             } else {
2009                 require
2010                 (
2011                     // require character is a space
2012                     _temp[i] == 0x20 ||
2013                     // OR lowercase a-z
2014                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2015                     // or 0-9
2016                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
2017                     "string contains invalid characters"
2018                 );
2019                 // make sure theres not 2x spaces in a row
2020                 if (_temp[i] == 0x20)
2021                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2022 
2023                 // see if we have a character other than a number
2024                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2025                     _hasNonNumber = true;
2026             }
2027         }
2028 
2029         require(_hasNonNumber == true, "string cannot be only numbers");
2030 
2031         bytes32 _ret;
2032         assembly {
2033             _ret := mload(add(_temp, 32))
2034         }
2035         return (_ret);
2036     }
2037 }
2038 
2039 /**
2040  * @title SafeMath v0.1.9
2041  * @dev Math operations with safety checks that throw on error
2042  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2043  * - added sqrt
2044  * - added sq
2045  * - added pwr
2046  * - changed asserts to requires with error log outputs
2047  * - removed div, its useless
2048  */
2049 library SafeMath {
2050 
2051     /**
2052     * @dev Multiplies two numbers, throws on overflow.
2053     */
2054     function mul(uint256 a, uint256 b)
2055         internal
2056         pure
2057         returns (uint256 c)
2058     {
2059         if (a == 0) {
2060             return 0;
2061         }
2062         c = a * b;
2063         require(c / a == b, "SafeMath mul failed");
2064         return c;
2065     }
2066 
2067     /**
2068     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2069     */
2070     function sub(uint256 a, uint256 b)
2071         internal
2072         pure
2073         returns (uint256)
2074     {
2075         require(b <= a, "SafeMath sub failed");
2076         return a - b;
2077     }
2078 
2079     /**
2080     * @dev Adds two numbers, throws on overflow.
2081     */
2082     function add(uint256 a, uint256 b)
2083         internal
2084         pure
2085         returns (uint256 c)
2086     {
2087         c = a + b;
2088         require(c >= a, "SafeMath add failed");
2089         return c;
2090     }
2091 
2092     /**
2093      * @dev gives square root of given x.
2094      */
2095     function sqrt(uint256 x)
2096         internal
2097         pure
2098         returns (uint256 y)
2099     {
2100         uint256 z = ((add(x,1)) / 2);
2101         y = x;
2102         while (z < y)
2103         {
2104             y = z;
2105             z = ((add((x / z),z)) / 2);
2106         }
2107     }
2108 
2109     /**
2110      * @dev gives square. multiplies x by x
2111      */
2112     function sq(uint256 x)
2113         internal
2114         pure
2115         returns (uint256)
2116     {
2117         return (mul(x,x));
2118     }
2119 
2120     /**
2121      * @dev x to the power of y
2122      */
2123     function pwr(uint256 x, uint256 y)
2124         internal
2125         pure
2126         returns (uint256)
2127     {
2128         if (x==0)
2129             return (0);
2130         else if (y==0)
2131             return (1);
2132         else
2133         {
2134             uint256 z = x;
2135             for (uint256 i=1; i < y; i++)
2136                 z = mul(z,x);
2137             return (z);
2138         }
2139     }
2140 }