1 pragma solidity ^0.4.24;
2 
3 //==============================================================================
4 //     _    _  _ _|_ _  .
5 //    (/_\/(/_| | | _\  .
6 //==============================================================================
7 contract F3Devents {
8     // fired whenever a player registers a name
9     event onNewName
10     (
11         uint256 indexed playerID,
12         address indexed playerAddress,
13         bytes32 indexed playerName,
14         bool isNewPlayer,
15         uint256 affiliateID,
16         address affiliateAddress,
17         bytes32 affiliateName,
18         uint256 amountPaid,
19         uint256 timeStamp
20     );
21     
22     // fired at end of buy or reload
23     event onEndTx
24     (
25         uint256 compressedData,     
26         uint256 compressedIDs,      
27         bytes32 playerName,
28         address playerAddress,
29         uint256 ethIn,
30         uint256 keysBought,
31         address winnerAddr,
32         bytes32 winnerName,
33         uint256 amountWon,
34         uint256 newPot,
35         uint256 P3DAmount,
36         uint256 genAmount,
37         uint256 potAmount,
38         uint256 airDropPot
39     );
40     
41 	// fired whenever theres a withdraw
42     event onWithdraw
43     (
44         uint256 indexed playerID,
45         address playerAddress,
46         bytes32 playerName,
47         uint256 ethOut,
48         uint256 timeStamp
49     );
50     
51     // fired whenever a withdraw forces end round to be ran
52     event onWithdrawAndDistribute
53     (
54         address playerAddress,
55         bytes32 playerName,
56         uint256 ethOut,
57         uint256 compressedData,
58         uint256 compressedIDs,
59         address winnerAddr,
60         bytes32 winnerName,
61         uint256 amountWon,
62         uint256 newPot,
63         uint256 P3DAmount,
64         uint256 genAmount
65     );
66     
67     // (fomo3d long only) fired whenever a player tries a buy after round timer 
68     // hit zero, and causes end round to be ran.
69     event onBuyAndDistribute
70     (
71         address playerAddress,
72         bytes32 playerName,
73         uint256 ethIn,
74         uint256 compressedData,
75         uint256 compressedIDs,
76         address winnerAddr,
77         bytes32 winnerName,
78         uint256 amountWon,
79         uint256 newPot,
80         uint256 P3DAmount,
81         uint256 genAmount
82     );
83     
84     // (fomo3d long only) fired whenever a player tries a reload after round timer 
85     // hit zero, and causes end round to be ran.
86     event onReLoadAndDistribute
87     (
88         address playerAddress,
89         bytes32 playerName,
90         uint256 compressedData,
91         uint256 compressedIDs,
92         address winnerAddr,
93         bytes32 winnerName,
94         uint256 amountWon,
95         uint256 newPot,
96         uint256 P3DAmount,
97         uint256 genAmount
98     );
99     
100     // fired whenever an affiliate is paid
101     event onAffiliatePayout
102     (
103         uint256 indexed affiliateID,
104         address affiliateAddress,
105         bytes32 affiliateName,
106         uint256 indexed roundID,
107         uint256 indexed buyerID,
108         uint256 amount,
109         uint256 timeStamp
110     );
111     
112     // received pot swap deposit
113     event onPotSwapDeposit
114     (
115         uint256 roundID,
116         uint256 amountAddedToPot
117     );
118 }
119 
120 contract FoMoRapid is F3Devents{
121     using SafeMath for uint256;
122     using NameFilter for string;
123     using F3DKeysCalcFast for uint256;
124     
125     address admin;
126     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x56a4d4e31c09558F6A1619DFb857a482B3Bb2Fb6);
127 //==============================================================================
128 //     _ _  _  |`. _     _ _ |_ | _  _  .
129 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
130 //=================_|===========================================================
131     string constant public name = "FoMo3D Soon(tm) Edition";
132     string constant public symbol = "F3D";
133 	uint256 private rndGap_ = 60 seconds;                       // length of ICO phase, set to 1 year for EOS.
134     uint256 constant private rndInit_ = 5 minutes;              // round timer starts at this
135     uint256 constant private rndInc_ = 5 minutes;               // every full key purchased adds this much to the timer
136     uint256 constant private rndMax_ = 5 minutes;               // max length a round timer can be
137 //==============================================================================
138 //     _| _ _|_ _    _ _ _|_    _   .
139 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
140 //=============================|================================================
141 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
142     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
143     uint256 public rID_;    // round id number / total rounds that have happened
144 //****************
145 // PLAYER DATA 
146 //****************
147     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
148     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
149     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
150     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
151     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
152 //****************
153 // ROUND DATA 
154 //****************
155     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
156     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
157 //****************
158 // TEAM FEE DATA 
159 //****************
160     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
161     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
162 //==============================================================================
163 //     _ _  _  __|_ _    __|_ _  _  .
164 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
165 //==============================================================================
166     constructor()
167         public
168     {
169 		// Team allocation structures
170         // 0 = whales
171         // 1 = bears
172         // 2 = sneks
173         // 3 = bulls
174 
175 		// Team allocation percentages
176         // (F3D, P3D) + (Pot , Referrals, Community)
177             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
178         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
179         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
180         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
181         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
182         
183         // how to split up the final pot based on which team was picked
184         // (F3D, P3D)
185         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
186         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
187         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
188         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
189 
190         admin = msg.sender;
191 	}
192 //==============================================================================
193 //     _ _  _  _|. |`. _  _ _  .
194 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
195 //==============================================================================
196     /**
197      * @dev used to make sure no one can interact with contract until it has 
198      * been activated. 
199      */
200     modifier isActivated() {
201         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
202         _;
203     }
204     
205     /**
206      * @dev prevents contracts from interacting with fomo3d 
207      */
208     modifier isHuman() {
209         address _addr = msg.sender;
210         require (_addr == tx.origin);
211         
212         uint256 _codeLength;
213         
214         assembly {_codeLength := extcodesize(_addr)}
215         require(_codeLength == 0, "sorry humans only");
216         _;
217     }
218 
219     /**
220      * @dev sets boundaries for incoming tx 
221      */
222     modifier isWithinLimits(uint256 _eth) {
223         require(_eth >= 1000000000, "pocket lint: not a valid currency");
224 		_;    
225 	}
226 //==============================================================================
227 //     _    |_ |. _   |`    _  __|_. _  _  _  .
228 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
229 //====|=========================================================================
230     /**
231      * @dev emergency buy uses last stored affiliate ID and team snek
232      */
233     function()
234         isActivated()
235         isHuman()
236         isWithinLimits(msg.value)
237         public
238         payable
239     {
240         // set up our tx event data and determine if player is new or not
241         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
242         
243         // fetch player id
244         uint256 _pID = pIDxAddr_[msg.sender];
245         
246         // buy core 
247         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
248     }
249     
250     /**
251      * @dev converts all incoming ethereum to keys.
252      * -functionhash- 0x8f38f309 (using ID for affiliate)
253      * -functionhash- 0x98a0871d (using address for affiliate)
254      * -functionhash- 0xa65b37a1 (using name for affiliate)
255      * @param _affCode the ID/address/name of the player who gets the affiliate fee
256      * @param _team what team is the player playing for?
257      */
258     function buyXid(uint256 _affCode, uint256 _team)
259         isActivated()
260         isHuman()
261         isWithinLimits(msg.value)
262         public
263         payable
264     {
265         // set up our tx event data and determine if player is new or not
266         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
267         
268         // fetch player id
269         uint256 _pID = pIDxAddr_[msg.sender];
270         
271         // manage affiliate residuals
272         // if no affiliate code was given or player tried to use their own, lolz
273         if (_affCode == 0 || _affCode == _pID)
274         {
275             // use last stored affiliate code 
276             _affCode = plyr_[_pID].laff;
277             
278         // if affiliate code was given & its not the same as previously stored 
279         } else if (_affCode != plyr_[_pID].laff) {
280             // update last affiliate 
281             plyr_[_pID].laff = _affCode;
282         }
283         
284         // verify a valid team was selected
285         _team = verifyTeam(_team);
286         
287         // buy core 
288         buyCore(_pID, _affCode, _team, _eventData_);
289     }
290     
291     function buyXaddr(address _affCode, uint256 _team)
292         isActivated()
293         isHuman()
294         isWithinLimits(msg.value)
295         public
296         payable
297     {
298         // set up our tx event data and determine if player is new or not
299         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
300         
301         // fetch player id
302         uint256 _pID = pIDxAddr_[msg.sender];
303         
304         // manage affiliate residuals
305         uint256 _affID;
306         // if no affiliate code was given or player tried to use their own, lolz
307         if (_affCode == address(0) || _affCode == msg.sender)
308         {
309             // use last stored affiliate code
310             _affID = plyr_[_pID].laff;
311         
312         // if affiliate code was given    
313         } else {
314             // get affiliate ID from aff Code 
315             _affID = pIDxAddr_[_affCode];
316             
317             // if affID is not the same as previously stored 
318             if (_affID != plyr_[_pID].laff)
319             {
320                 // update last affiliate
321                 plyr_[_pID].laff = _affID;
322             }
323         }
324         
325         // verify a valid team was selected
326         _team = verifyTeam(_team);
327         
328         // buy core 
329         buyCore(_pID, _affID, _team, _eventData_);
330     }
331     
332     function buyXname(bytes32 _affCode, uint256 _team)
333         isActivated()
334         isHuman()
335         isWithinLimits(msg.value)
336         public
337         payable
338     {
339         // set up our tx event data and determine if player is new or not
340         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
341         
342         // fetch player id
343         uint256 _pID = pIDxAddr_[msg.sender];
344         
345         // manage affiliate residuals
346         uint256 _affID;
347         // if no affiliate code was given or player tried to use their own, lolz
348         if (_affCode == '' || _affCode == plyr_[_pID].name)
349         {
350             // use last stored affiliate code
351             _affID = plyr_[_pID].laff;
352         
353         // if affiliate code was given
354         } else {
355             // get affiliate ID from aff Code
356             _affID = pIDxName_[_affCode];
357             
358             // if affID is not the same as previously stored
359             if (_affID != plyr_[_pID].laff)
360             {
361                 // update last affiliate
362                 plyr_[_pID].laff = _affID;
363             }
364         }
365         
366         // verify a valid team was selected
367         _team = verifyTeam(_team);
368         
369         // buy core 
370         buyCore(_pID, _affID, _team, _eventData_);
371     }
372     
373     /**
374      * @dev essentially the same as buy, but instead of you sending ether 
375      * from your wallet, it uses your unwithdrawn earnings.
376      * -functionhash- 0x349cdcac (using ID for affiliate)
377      * -functionhash- 0x82bfc739 (using address for affiliate)
378      * -functionhash- 0x079ce327 (using name for affiliate)
379      * @param _affCode the ID/address/name of the player who gets the affiliate fee
380      * @param _team what team is the player playing for?
381      * @param _eth amount of earnings to use (remainder returned to gen vault)
382      */
383     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
384         isActivated()
385         isHuman()
386         isWithinLimits(_eth)
387         public
388     {
389         // set up our tx event data
390         F3Ddatasets.EventReturns memory _eventData_;
391         
392         // fetch player ID
393         uint256 _pID = pIDxAddr_[msg.sender];
394         
395         // manage affiliate residuals
396         // if no affiliate code was given or player tried to use their own, lolz
397         if (_affCode == 0 || _affCode == _pID)
398         {
399             // use last stored affiliate code 
400             _affCode = plyr_[_pID].laff;
401             
402         // if affiliate code was given & its not the same as previously stored 
403         } else if (_affCode != plyr_[_pID].laff) {
404             // update last affiliate 
405             plyr_[_pID].laff = _affCode;
406         }
407 
408         // verify a valid team was selected
409         _team = verifyTeam(_team);
410             
411         // reload core
412         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
413     }
414     
415     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
416         isActivated()
417         isHuman()
418         isWithinLimits(_eth)
419         public
420     {
421         // set up our tx event data
422         F3Ddatasets.EventReturns memory _eventData_;
423         
424         // fetch player ID
425         uint256 _pID = pIDxAddr_[msg.sender];
426         
427         // manage affiliate residuals
428         uint256 _affID;
429         // if no affiliate code was given or player tried to use their own, lolz
430         if (_affCode == address(0) || _affCode == msg.sender)
431         {
432             // use last stored affiliate code
433             _affID = plyr_[_pID].laff;
434         
435         // if affiliate code was given    
436         } else {
437             // get affiliate ID from aff Code 
438             _affID = pIDxAddr_[_affCode];
439             
440             // if affID is not the same as previously stored 
441             if (_affID != plyr_[_pID].laff)
442             {
443                 // update last affiliate
444                 plyr_[_pID].laff = _affID;
445             }
446         }
447         
448         // verify a valid team was selected
449         _team = verifyTeam(_team);
450         
451         // reload core
452         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
453     }
454     
455     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
456         isActivated()
457         isHuman()
458         isWithinLimits(_eth)
459         public
460     {
461         // set up our tx event data
462         F3Ddatasets.EventReturns memory _eventData_;
463         
464         // fetch player ID
465         uint256 _pID = pIDxAddr_[msg.sender];
466         
467         // manage affiliate residuals
468         uint256 _affID;
469         // if no affiliate code was given or player tried to use their own, lolz
470         if (_affCode == '' || _affCode == plyr_[_pID].name)
471         {
472             // use last stored affiliate code
473             _affID = plyr_[_pID].laff;
474         
475         // if affiliate code was given
476         } else {
477             // get affiliate ID from aff Code
478             _affID = pIDxName_[_affCode];
479             
480             // if affID is not the same as previously stored
481             if (_affID != plyr_[_pID].laff)
482             {
483                 // update last affiliate
484                 plyr_[_pID].laff = _affID;
485             }
486         }
487         
488         // verify a valid team was selected
489         _team = verifyTeam(_team);
490         
491         // reload core
492         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
493     }
494 
495     /**
496      * @dev withdraws all of your earnings.
497      * -functionhash- 0x3ccfd60b
498      */
499     function withdraw()
500         isActivated()
501         isHuman()
502         public
503     {
504         // setup local rID
505         uint256 _rID = rID_;
506         
507         // grab time
508         uint256 _now = now;
509         
510         // fetch player ID
511         uint256 _pID = pIDxAddr_[msg.sender];
512         
513         // setup temp var for player eth
514         uint256 _eth;
515         
516         // check to see if round has ended and no one has run round end yet
517         if (_now > round_[_rID].end && round_[_rID].ended == false)
518         {
519             // set up our tx event data
520             F3Ddatasets.EventReturns memory _eventData_;
521             
522             // end the round (distributes pot)
523 			round_[_rID].ended = true;
524             _eventData_ = endRound(_eventData_);
525             
526 			// get their earnings
527             _eth = withdrawEarnings(_pID);
528             
529             // gib moni
530             if (_eth > 0)
531                 plyr_[_pID].addr.transfer(_eth);    
532             
533             // build event data
534             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
535             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
536             
537             // fire withdraw and distribute event
538             emit F3Devents.onWithdrawAndDistribute
539             (
540                 msg.sender, 
541                 plyr_[_pID].name, 
542                 _eth, 
543                 _eventData_.compressedData, 
544                 _eventData_.compressedIDs, 
545                 _eventData_.winnerAddr, 
546                 _eventData_.winnerName, 
547                 _eventData_.amountWon, 
548                 _eventData_.newPot, 
549                 _eventData_.P3DAmount, 
550                 _eventData_.genAmount
551             );
552             
553         // in any other situation
554         } else {
555             // get their earnings
556             _eth = withdrawEarnings(_pID);
557             
558             // gib moni
559             if (_eth > 0)
560                 plyr_[_pID].addr.transfer(_eth);
561             
562             // fire withdraw event
563             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
564         }
565     }
566     
567     /**
568      * @dev use these to register names.  they are just wrappers that will send the
569      * registration requests to the PlayerBook contract.  So registering here is the 
570      * same as registering there.  UI will always display the last name you registered.
571      * but you will still own all previously registered names to use as affiliate 
572      * links.
573      * - must pay a registration fee.
574      * - name must be unique
575      * - names will be converted to lowercase
576      * - name cannot start or end with a space 
577      * - cannot have more than 1 space in a row
578      * - cannot be only numbers
579      * - cannot start with 0x 
580      * - name must be at least 1 char
581      * - max length of 32 characters long
582      * - allowed characters: a-z, 0-9, and space
583      * -functionhash- 0x921dec21 (using ID for affiliate)
584      * -functionhash- 0x3ddd4698 (using address for affiliate)
585      * -functionhash- 0x685ffd83 (using name for affiliate)
586      * @param _nameString players desired name
587      * @param _affCode affiliate ID, address, or name of who referred you
588      * @param _all set to true if you want this to push your info to all games 
589      * (this might cost a lot of gas)
590      */
591     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
592         isHuman()
593         public
594         payable
595     {
596         bytes32 _name = _nameString.nameFilter();
597         address _addr = msg.sender;
598         uint256 _paid = msg.value;
599         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
600         
601         uint256 _pID = pIDxAddr_[_addr];
602         
603         // fire event
604         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
605     }
606     
607     function registerNameXaddr(string _nameString, address _affCode, bool _all)
608         isHuman()
609         public
610         payable
611     {
612         bytes32 _name = _nameString.nameFilter();
613         address _addr = msg.sender;
614         uint256 _paid = msg.value;
615         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
616         
617         uint256 _pID = pIDxAddr_[_addr];
618         
619         // fire event
620         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
621     }
622     
623     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
624         isHuman()
625         public
626         payable
627     {
628         bytes32 _name = _nameString.nameFilter();
629         address _addr = msg.sender;
630         uint256 _paid = msg.value;
631         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
632         
633         uint256 _pID = pIDxAddr_[_addr];
634         
635         // fire event
636         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
637     }
638 //==============================================================================
639 //     _  _ _|__|_ _  _ _  .
640 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
641 //=====_|=======================================================================
642     /**
643      * @dev return the price buyer will pay for next 1 individual key.
644      * - during live round.  this is accurate. (well... unless someone buys before 
645      * you do and ups the price!  you better HURRY!)
646      * - during ICO phase.  this is the max you would get based on current eth 
647      * invested during ICO phase.  if others invest after you, you will receive
648      * less.  (so distract them with meme vids till ICO is over)
649      * -functionhash- 0x018a25e8
650      * @return price for next key bought (in wei format)
651      */
652     function getBuyPrice()
653         public 
654         view 
655         returns(uint256)
656     {  
657         // setup local rID
658         uint256 _rID = rID_;
659             
660         // grab time
661         uint256 _now = now;
662         
663         // is ICO phase over??  & theres eth in the round?
664         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
665             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
666         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
667             return ( ((round_[_rID].ico.keys()).add(1000000000000000000)).ethRec(1000000000000000000) );
668         else // rounds over.  need price for new round
669             return ( 100000000000000 ); // init
670     }
671     
672     /**
673      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
674      * provider
675      * -functionhash- 0xc7e284b8
676      * @return time left in seconds
677      */
678     function getTimeLeft()
679         public
680         view
681         returns(uint256)
682     {
683         // setup local rID 
684         uint256 _rID = rID_;
685         
686         // grab time
687         uint256 _now = now;
688         
689         // are we in ICO phase?
690         if (_now <= round_[_rID].strt + rndGap_)
691             return( ((round_[_rID].end).sub(rndInit_)).sub(_now) );
692         else 
693             if (_now < round_[_rID].end)
694                 return( (round_[_rID].end).sub(_now) );
695             else
696                 return(0);
697     }
698     
699     /**
700      * @dev returns player earnings per vaults 
701      * -functionhash- 0x63066434
702      * @return winnings vault
703      * @return general vault
704      * @return affiliate vault
705      */
706     function getPlayerVaults(uint256 _pID)
707         public
708         view
709         returns(uint256 ,uint256, uint256)
710     {
711         // setup local rID
712         uint256 _rID = rID_;
713         
714         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
715         if (now > round_[_rID].end && round_[_rID].ended == false)
716         {
717             uint256 _roundMask;
718             uint256 _roundEth;
719             uint256 _roundKeys;
720             uint256 _roundPot;
721             if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
722             {
723                 // create a temp round eth based on eth sent in during ICO phase
724                 _roundEth = round_[_rID].ico;
725                 
726                 // create a temp round keys based on keys bought during ICO phase
727                 _roundKeys = (round_[_rID].ico).keys();
728                 
729                 // create a temp round mask based on eth and keys from ICO phase
730                 _roundMask = ((round_[_rID].icoGen).mul(1000000000000000000)) / _roundKeys;
731                 
732                 // create a temp rount pot based on pot, and dust from mask
733                 _roundPot = (round_[_rID].pot).add((round_[_rID].icoGen).sub((_roundMask.mul(_roundKeys)) / (1000000000000000000)));
734             } else {
735                 _roundEth = round_[_rID].eth;
736                 _roundKeys = round_[_rID].keys;
737                 _roundMask = round_[_rID].mask;
738                 _roundPot = round_[_rID].pot;
739             }
740             
741             uint256 _playerKeys;
742             if (plyrRnds_[_pID][plyr_[_pID].lrnd].ico == 0)
743                 _playerKeys = plyrRnds_[_pID][plyr_[_pID].lrnd].keys;
744             else
745                 _playerKeys = calcPlayerICOPhaseKeys(_pID, _rID);
746             
747             // if player is winner 
748             if (round_[_rID].plyr == _pID)
749             {
750                 return
751                 (
752                     (plyr_[_pID].win).add( (_roundPot.mul(48)) / 100 ),
753                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
754                     plyr_[_pID].aff
755                 );
756             // if player is not the winner
757             } else {
758                 return
759                 (
760                     plyr_[_pID].win,   
761                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
762                     plyr_[_pID].aff
763                 );
764             }
765             
766         // if round is still going on, we are in ico phase, or round has ended and round end has been ran
767         } else {
768             return
769             (
770                 plyr_[_pID].win,
771                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
772                 plyr_[_pID].aff
773             );
774         }
775     }
776     
777     /**
778      * solidity hates stack limits.  this lets us avoid that hate 
779      */
780     function getPlayerVaultsHelper(uint256 _pID, uint256 _roundMask, uint256 _roundPot, uint256 _roundKeys, uint256 _playerKeys)
781         private
782         view
783         returns(uint256)
784     {
785         return(  (((_roundMask.add((((_roundPot.mul(potSplit_[round_[rID_].team].gen)) / 100).mul(1000000000000000000)) / _roundKeys)).mul(_playerKeys)) / 1000000000000000000).sub(plyrRnds_[_pID][rID_].mask)  );
786     }
787     
788     /**
789      * @dev returns all current round info needed for front end
790      * -functionhash- 0x747dff42
791      * @return eth invested during ICO phase
792      * @return round id 
793      * @return total keys for round 
794      * @return time round ends
795      * @return time round started
796      * @return current pot 
797      * @return current team ID & player ID in lead 
798      * @return current player in leads address 
799      * @return current player in leads name
800      * @return whales eth in for round
801      * @return bears eth in for round
802      * @return sneks eth in for round
803      * @return bulls eth in for round
804      * @return airdrop tracker # & airdrop pot
805      */
806     function getCurrentRoundInfo()
807         public
808         view
809         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
810     {
811         // setup local rID
812         uint256 _rID = rID_;
813         
814         if (round_[_rID].eth != 0)
815         {
816             return
817             (
818                 round_[_rID].ico,               //0
819                 _rID,                           //1
820                 round_[_rID].keys,              //2
821                 round_[_rID].end,               //3
822                 round_[_rID].strt,              //4
823                 round_[_rID].pot,               //5
824                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
825                 plyr_[round_[_rID].plyr].addr,  //7
826                 plyr_[round_[_rID].plyr].name,  //8
827                 rndTmEth_[_rID][0],             //9
828                 rndTmEth_[_rID][1],             //10
829                 rndTmEth_[_rID][2],             //11
830                 rndTmEth_[_rID][3],             //12
831                 airDropTracker_ + (airDropPot_ * 1000)              //13
832             );
833         } else {
834             return
835             (
836                 round_[_rID].ico,               //0
837                 _rID,                           //1
838                 (round_[_rID].ico).keys(),      //2
839                 round_[_rID].end,               //3
840                 round_[_rID].strt,              //4
841                 round_[_rID].pot,               //5
842                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
843                 plyr_[round_[_rID].plyr].addr,  //7
844                 plyr_[round_[_rID].plyr].name,  //8
845                 rndTmEth_[_rID][0],             //9
846                 rndTmEth_[_rID][1],             //10
847                 rndTmEth_[_rID][2],             //11
848                 rndTmEth_[_rID][3],             //12
849                 airDropTracker_ + (airDropPot_ * 1000)              //13
850             );
851         }
852     }
853 
854     /**
855      * @dev returns player info based on address.  if no address is given, it will 
856      * use msg.sender 
857      * -functionhash- 0xee0b5d8b
858      * @param _addr address of the player you want to lookup 
859      * @return player ID 
860      * @return player name
861      * @return keys owned (current round)
862      * @return winnings vault
863      * @return general vault 
864      * @return affiliate vault 
865 	 * @return player ico eth
866      */
867     function getPlayerInfoByAddress(address _addr)
868         public 
869         view 
870         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
871     {
872         // setup local rID
873         uint256 _rID = rID_;
874         
875         if (_addr == address(0))
876         {
877             _addr == msg.sender;
878         }
879         uint256 _pID = pIDxAddr_[_addr];
880         
881         if (plyrRnds_[_pID][_rID].ico == 0)
882         {
883             return
884             (
885                 _pID,                               //0
886                 plyr_[_pID].name,                   //1
887                 plyrRnds_[_pID][_rID].keys,         //2
888                 plyr_[_pID].win,                    //3
889                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
890                 plyr_[_pID].aff,                    //5
891 				0						            //6
892             );
893         } else {
894             return
895             (
896                 _pID,                               //0
897                 plyr_[_pID].name,                   //1
898                 calcPlayerICOPhaseKeys(_pID, _rID), //2
899                 plyr_[_pID].win,                    //3
900                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
901                 plyr_[_pID].aff,                    //5
902 				plyrRnds_[_pID][_rID].ico           //6
903             );
904         }
905         
906     }
907 
908 //==============================================================================
909 //     _ _  _ _   | _  _ . _  .
910 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
911 //=====================_|=======================================================
912     /**
913      * @dev logic runs whenever a buy order is executed.  determines how to handle 
914      * incoming eth depending on if we are in ICO phase or not 
915      */
916     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
917         private
918     {
919         // check to see if round has ended.  and if player is new to round
920         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
921         
922         // are we in ICO phase?
923         if (now <= round_[rID_].strt + rndGap_) 
924         {
925             // let event data know this is a ICO phase buy order
926             _eventData_.compressedData = _eventData_.compressedData + 2000000000000000000000000000000;
927         
928             // ICO phase core
929             icoPhaseCore(_pID, msg.value, _team, _affID, _eventData_);
930         
931         
932         // round is live
933         } else {
934              // let event data know this is a buy order
935             _eventData_.compressedData = _eventData_.compressedData + 1000000000000000000000000000000;
936         
937             // call core
938             core(_pID, msg.value, _affID, _team, _eventData_);
939         }
940     }
941 
942     /**
943      * @dev logic runs whenever a reload order is executed.  determines how to handle 
944      * incoming eth depending on if we are in ICO phase or not 
945      */
946     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
947         private 
948     {
949         // check to see if round has ended.  and if player is new to round
950         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
951         
952         // get earnings from all vaults and return unused to gen vault
953         // because we use a custom safemath library.  this will throw if player 
954         // tried to spend more eth than they have.
955         plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
956                 
957         // are we in ICO phase?
958         if (now <= round_[rID_].strt + rndGap_) 
959         {
960             // let event data know this is an ICO phase reload 
961             _eventData_.compressedData = _eventData_.compressedData + 3000000000000000000000000000000;
962                 
963             // ICO phase core
964             icoPhaseCore(_pID, _eth, _team, _affID, _eventData_);
965 
966 
967         // round is live
968         } else {
969             // call core
970             core(_pID, _eth, _affID, _team, _eventData_);
971         }
972     }    
973     
974     /**
975      * @dev during ICO phase all eth sent in by each player.  will be added to an 
976      * "investment pool".  upon end of ICO phase, all eth will be used to buy keys.
977      * each player receives an amount based on how much they put in, and the 
978      * the average price attained.
979      */
980     function icoPhaseCore(uint256 _pID, uint256 _eth, uint256 _team, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
981         private
982     {
983         // setup local rID
984         uint256 _rID = rID_;
985         
986         // if they bought at least 1 whole key (at time of purchase)
987         if ((round_[_rID].ico).keysRec(_eth) >= 1000000000000000000 || round_[_rID].plyr == 0)
988         {
989             // set new leaders
990             if (round_[_rID].plyr != _pID)
991                 round_[_rID].plyr = _pID;  
992             if (round_[_rID].team != _team)
993                 round_[_rID].team = _team;
994             
995             // set the new leader bool to true
996             _eventData_.compressedData = _eventData_.compressedData + 100;
997         }
998         
999         // add eth to our players & rounds ICO phase investment. this will be used 
1000         // to determine total keys and each players share 
1001         plyrRnds_[_pID][_rID].ico = _eth.add(plyrRnds_[_pID][_rID].ico);
1002         round_[_rID].ico = _eth.add(round_[_rID].ico);
1003         
1004         // add eth in to team eth tracker
1005         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1006         
1007         // send eth share to com, p3d, affiliate, and fomo3d long
1008         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1009         
1010         // calculate gen share 
1011         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1012         
1013         // add gen share to rounds ICO phase gen tracker (will be distributed 
1014         // when round starts)
1015         round_[_rID].icoGen = _gen.add(round_[_rID].icoGen);
1016         
1017 		// toss 1% into airdrop pot 
1018         uint256 _air = (_eth / 100);
1019         airDropPot_ = airDropPot_.add(_air);
1020         
1021         // calculate pot share pot (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share)) - gen
1022         uint256 _pot = (_eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100))).sub(_gen);
1023         
1024         // add eth to pot
1025         round_[_rID].pot = _pot.add(round_[_rID].pot);
1026         
1027         // set up event data
1028         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1029         _eventData_.potAmount = _pot;
1030         
1031         // fire event
1032         endTx(_rID, _pID, _team, _eth, 0, _eventData_);
1033     }
1034     
1035     /**
1036      * @dev this is the core logic for any buy/reload that happens while a round 
1037      * is live.
1038      */
1039     function core(uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1040         private
1041     {
1042         // setup local rID
1043         uint256 _rID = rID_;
1044         
1045         // check to see if its a new round (past ICO phase) && keys were bought in ICO phase
1046         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1047             roundClaimICOKeys(_rID);
1048         
1049         // if player is new to round and is owed keys from ICO phase 
1050         if (plyrRnds_[_pID][_rID].keys == 0 && plyrRnds_[_pID][_rID].ico > 0)
1051         {
1052             // assign player their keys from ICO phase
1053             plyrRnds_[_pID][_rID].keys = calcPlayerICOPhaseKeys(_pID, _rID);
1054             // zero out ICO phase investment
1055             plyrRnds_[_pID][_rID].ico = 0;
1056         }
1057             
1058         // mint the new keys
1059         uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1060         
1061         // if they bought at least 1 whole key
1062         if (_keys >= 1000000000000000000)
1063         {
1064             updateTimer(_keys, _rID);
1065 
1066             // set new leaders
1067             if (round_[_rID].plyr != _pID)
1068                 round_[_rID].plyr = _pID;  
1069             if (round_[_rID].team != _team)
1070                 round_[_rID].team = _team; 
1071             
1072             // set the new leader bool to true
1073             _eventData_.compressedData = _eventData_.compressedData + 100;
1074         }
1075         
1076         // manage airdrops
1077         if (_eth >= 100000000000000000)
1078         {
1079             airDropTracker_++;
1080             if (airdrop() == true)
1081             {
1082                 // gib muni
1083                 uint256 _prize;
1084                 if (_eth >= 10000000000000000000) 
1085                 {
1086                     // calculate prize and give it to winner
1087                     _prize = ((airDropPot_).mul(75)) / 100;
1088                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1089                     
1090                     // adjust airDropPot 
1091                     airDropPot_ = (airDropPot_).sub(_prize);
1092                     
1093                     // let event know a tier 3 prize was won 
1094                     _eventData_.compressedData += 300000000000000000000000000000000;
1095                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1096                     // calculate prize and give it to winner
1097                     _prize = ((airDropPot_).mul(50)) / 100;
1098                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1099                     
1100                     // adjust airDropPot 
1101                     airDropPot_ = (airDropPot_).sub(_prize);
1102                     
1103                     // let event know a tier 2 prize was won 
1104                     _eventData_.compressedData += 200000000000000000000000000000000;
1105                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1106                     // calculate prize and give it to winner
1107                     _prize = ((airDropPot_).mul(25)) / 100;
1108                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1109                     
1110                     // adjust airDropPot 
1111                     airDropPot_ = (airDropPot_).sub(_prize);
1112                     
1113                     // let event know a tier 1 prize was won 
1114                     _eventData_.compressedData += 100000000000000000000000000000000;
1115                 }
1116                 // set airdrop happened bool to true
1117                 _eventData_.compressedData += 10000000000000000000000000000000;
1118                 // let event know how much was won 
1119                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1120                 
1121                 // reset air drop tracker
1122                 airDropTracker_ = 0;
1123             }
1124         }
1125 
1126         // store the air drop tracker number (number of buys since last airdrop)
1127         _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1128         
1129         // update player 
1130         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1131         
1132         // update round
1133         round_[_rID].keys = _keys.add(round_[_rID].keys);
1134         round_[_rID].eth = _eth.add(round_[_rID].eth);
1135         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1136 
1137         // distribute eth
1138         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1139         _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1140         
1141         // call end tx function to fire end tx event.
1142         endTx(_rID, _pID, _team, _eth, _keys, _eventData_);
1143     }
1144 //==============================================================================
1145 //     _ _ | _   | _ _|_ _  _ _  .
1146 //    (_(_||(_|_||(_| | (_)| _\  .
1147 //==============================================================================
1148     /**
1149      * @dev calculates unmasked earnings (just calculates, does not update mask)
1150      * @return earnings in wei format
1151      */
1152     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1153         private
1154         view
1155         returns(uint256)
1156     {
1157         // if player does not have unclaimed keys bought in ICO phase
1158         // return their earnings based on keys held only.
1159         if (plyrRnds_[_pID][_rIDlast].ico == 0)
1160             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1161         else
1162             if (now > round_[_rIDlast].strt + rndGap_ && round_[_rIDlast].eth == 0)
1163                 return(  (((((round_[_rIDlast].icoGen).mul(1000000000000000000)) / (round_[_rIDlast].ico).keys()).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1164             else
1165                 return(  (((round_[_rIDlast].mask).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1166         // otherwise return earnings based on keys owed from ICO phase
1167         // (this would be a scenario where they only buy during ICO phase, and never 
1168         // buy/reload during round)
1169     }
1170     
1171     /**
1172      * @dev average ico phase key price is total eth put in, during ICO phase, 
1173      * divided by the number of keys that were bought with that eth.
1174      * -functionhash- 0xdcb6af48
1175      * @return average key price 
1176      */
1177     function calcAverageICOPhaseKeyPrice(uint256 _rID)
1178         public 
1179         view 
1180         returns(uint256)
1181     {
1182         return(  (round_[_rID].ico).mul(1000000000000000000) / (round_[_rID].ico).keys()  );
1183     }
1184     
1185     /**
1186      * @dev at end of ICO phase, each player is entitled to X keys based on final 
1187      * average ICO phase key price, and the amount of eth they put in during ICO.
1188      * if a player participates in the round post ICO, these will be "claimed" and 
1189      * added to their rounds total keys.  if not, this will be used to calculate 
1190      * their gen earnings throughout round and on round end.
1191      * -functionhash- 0x75661f4c
1192      * @return players keys bought during ICO phase 
1193      */
1194     function calcPlayerICOPhaseKeys(uint256 _pID, uint256 _rID)
1195         public 
1196         view
1197         returns(uint256)
1198     {
1199         if (round_[_rID].icoAvg != 0 || round_[_rID].ico == 0 )
1200             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / round_[_rID].icoAvg  );
1201         else
1202             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / calcAverageICOPhaseKeyPrice(_rID)  );
1203     }
1204     
1205     /** 
1206      * @dev returns the amount of keys you would get given an amount of eth. 
1207      * - during live round.  this is accurate. (well... unless someone buys before 
1208      * you do and ups the price!  you better HURRY!)
1209      * - during ICO phase.  this is the max you would get based on current eth 
1210      * invested during ICO phase.  if others invest after you, you will receive
1211      * less.  (so distract them with meme vids till ICO is over)
1212      * -functionhash- 0xce89c80c
1213      * @param _rID round ID you want price for
1214      * @param _eth amount of eth sent in 
1215      * @return keys received 
1216      */
1217     function calcKeysReceived(uint256 _rID, uint256 _eth)
1218         public
1219         view
1220         returns(uint256)
1221     {
1222         // grab time
1223         uint256 _now = now;
1224         
1225         // is ICO phase over??  & theres eth in the round?
1226         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1227             return ( (round_[_rID].eth).keysRec(_eth) );
1228         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1229             return ( (round_[_rID].ico).keysRec(_eth) );
1230         else // rounds over.  need keys for new round
1231             return ( (_eth).keys() );
1232     }
1233     
1234     /** 
1235      * @dev returns current eth price for X keys.  
1236      * - during live round.  this is accurate. (well... unless someone buys before 
1237      * you do and ups the price!  you better HURRY!)
1238      * - during ICO phase.  this is the max you would get based on current eth 
1239      * invested during ICO phase.  if others invest after you, you will receive
1240      * less.  (so distract them with meme vids till ICO is over)
1241      * -functionhash- 0xcf808000
1242      * @param _keys number of keys desired (in 18 decimal format)
1243      * @return amount of eth needed to send
1244      */
1245     function iWantXKeys(uint256 _keys)
1246         public
1247         view
1248         returns(uint256)
1249     {
1250         // setup local rID
1251         uint256 _rID = rID_;
1252         
1253         // grab time
1254         uint256 _now = now;
1255         
1256         // is ICO phase over??  & theres eth in the round?
1257         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1258             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1259         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1260             return ( (((round_[_rID].ico).keys()).add(_keys)).ethRec(_keys) );
1261         else // rounds over.  need price for new round
1262             return ( (_keys).eth() );
1263     }
1264 //==============================================================================
1265 //    _|_ _  _ | _  .
1266 //     | (_)(_)|_\  .
1267 //==============================================================================
1268     /**
1269 	 * @dev receives name/player info from names contract 
1270      */
1271     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1272         external
1273     {
1274         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1275         if (pIDxAddr_[_addr] != _pID)
1276             pIDxAddr_[_addr] = _pID;
1277         if (pIDxName_[_name] != _pID)
1278             pIDxName_[_name] = _pID;
1279         if (plyr_[_pID].addr != _addr)
1280             plyr_[_pID].addr = _addr;
1281         if (plyr_[_pID].name != _name)
1282             plyr_[_pID].name = _name;
1283         if (plyr_[_pID].laff != _laff)
1284             plyr_[_pID].laff = _laff;
1285         if (plyrNames_[_pID][_name] == false)
1286             plyrNames_[_pID][_name] = true;
1287     }
1288 
1289     /**
1290      * @dev receives entire player name list 
1291      */
1292     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1293         external
1294     {
1295         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1296         if(plyrNames_[_pID][_name] == false)
1297             plyrNames_[_pID][_name] = true;
1298     }  
1299         
1300     /**
1301      * @dev gets existing or registers new pID.  use this when a player may be new
1302      * @return pID 
1303      */
1304     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1305         private
1306         returns (F3Ddatasets.EventReturns)
1307     {
1308         uint256 _pID = pIDxAddr_[msg.sender];
1309         // if player is new to this version of fomo3d
1310         if (_pID == 0)
1311         {
1312             // grab their player ID, name and last aff ID, from player names contract 
1313             _pID = PlayerBook.getPlayerID(msg.sender);
1314             bytes32 _name = PlayerBook.getPlayerName(_pID);
1315             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1316             
1317             // set up player account 
1318             pIDxAddr_[msg.sender] = _pID;
1319             plyr_[_pID].addr = msg.sender;
1320             
1321             if (_name != "")
1322             {
1323                 pIDxName_[_name] = _pID;
1324                 plyr_[_pID].name = _name;
1325                 plyrNames_[_pID][_name] = true;
1326             }
1327             
1328             if (_laff != 0 && _laff != _pID)
1329                 plyr_[_pID].laff = _laff;
1330             
1331             // set the new player bool to true
1332             _eventData_.compressedData = _eventData_.compressedData + 1;
1333         } 
1334         return (_eventData_);
1335     }
1336     
1337     /**
1338      * @dev checks to make sure user picked a valid team.  if not sets team 
1339      * to default (sneks)
1340      */
1341     function verifyTeam(uint256 _team)
1342         private
1343         pure
1344         returns (uint256)
1345     {
1346         if (_team < 0 || _team > 3)
1347             return(2);
1348         else
1349             return(_team);
1350     }
1351     
1352     /**
1353      * @dev decides if round end needs to be run & new round started.  and if 
1354      * player unmasked earnings from previously played rounds need to be moved.
1355      */
1356     function manageRoundAndPlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1357         private
1358         returns (F3Ddatasets.EventReturns)
1359     {
1360         // setup local rID
1361         uint256 _rID = rID_;
1362         
1363         // grab time
1364         uint256 _now = now;
1365         
1366         // check to see if round has ended.  we use > instead of >= so that LAST
1367         // second snipe tx can extend the round.
1368         if (_now > round_[_rID].end)
1369         {
1370             // check to see if round end has been run yet.  (distributes pot)
1371             if (round_[_rID].ended == false)
1372             {
1373                 _eventData_ = endRound(_eventData_);
1374                 round_[_rID].ended = true;
1375             }
1376             
1377             // start next round in ICO phase
1378             rID_++;
1379             _rID++;
1380             round_[_rID].strt = _now;
1381             round_[_rID].end = _now.add(rndInit_).add(rndGap_);
1382         }
1383         
1384         // is player new to round?
1385         if (plyr_[_pID].lrnd != _rID)
1386         {
1387             // if player has played a previous round, move their unmasked earnings
1388             // from that round to gen vault.
1389             if (plyr_[_pID].lrnd != 0)
1390                 updateGenVault(_pID, plyr_[_pID].lrnd);
1391             
1392             // update player's last round played
1393             plyr_[_pID].lrnd = _rID;
1394             
1395             // set the joined round bool to true
1396             _eventData_.compressedData = _eventData_.compressedData + 10;
1397         }
1398         
1399         return(_eventData_);
1400     }
1401     
1402     /**
1403      * @dev ends the round. manages paying out winner/splitting up pot
1404      */
1405     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1406         private
1407         returns (F3Ddatasets.EventReturns)
1408     {
1409         // setup local rID
1410         uint256 _rID = rID_;
1411         
1412         // check to round ended with ONLY ico phase transactions
1413         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1414             roundClaimICOKeys(_rID);
1415         
1416         // grab our winning player and team id's
1417         uint256 _winPID = round_[_rID].plyr;
1418         uint256 _winTID = round_[_rID].team;
1419         
1420         // grab our pot amount
1421         uint256 _pot = round_[_rID].pot;
1422         
1423         // calculate our winner share, community rewards, gen share, 
1424         // p3d share, and amount reserved for next pot 
1425         uint256 _win = (_pot.mul(48)) / 100;
1426         uint256 _com = (_pot / 50);
1427         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1428         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1429         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1430         
1431         // calculate ppt for round mask
1432         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1433         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1434         if (_dust > 0)
1435         {
1436             _gen = _gen.sub(_dust);
1437             _res = _res.add(_dust);
1438         }
1439         
1440         // pay our winner
1441         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1442         
1443         // community rewards
1444         admin.transfer(_p3d.add(_com));
1445             
1446         // distribute gen portion to key holders
1447         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1448                     
1449         // fill next round pot with its share
1450         round_[_rID + 1].pot += _res;
1451         
1452         // prepare event data
1453         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1454         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1455         _eventData_.winnerAddr = plyr_[_winPID].addr;
1456         _eventData_.winnerName = plyr_[_winPID].name;
1457         _eventData_.amountWon = _win;
1458         _eventData_.genAmount = _gen;
1459         _eventData_.P3DAmount = _p3d;
1460         _eventData_.newPot = _res;
1461         
1462         return(_eventData_);
1463     }
1464     
1465     /**
1466      * @dev takes keys bought during ICO phase, and adds them to round.  pays 
1467      * out gen rewards that accumulated during ICO phase 
1468      */
1469     function roundClaimICOKeys(uint256 _rID)
1470         private
1471     {
1472         // update round eth to account for ICO phase eth investment 
1473         round_[_rID].eth = round_[_rID].ico;
1474                 
1475         // add keys to round that were bought during ICO phase
1476         round_[_rID].keys = (round_[_rID].ico).keys();
1477         
1478         // store average ICO key price 
1479         round_[_rID].icoAvg = calcAverageICOPhaseKeyPrice(_rID);
1480                 
1481         // set round mask from ICO phase
1482         uint256 _ppt = ((round_[_rID].icoGen).mul(1000000000000000000)) / (round_[_rID].keys);
1483         uint256 _dust = (round_[_rID].icoGen).sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000));
1484         if (_dust > 0)
1485             round_[_rID].pot = (_dust).add(round_[_rID].pot);   // <<< your adding to pot and havent updated event data
1486                 
1487         // distribute gen portion to key holders
1488         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1489     }
1490     
1491     /**
1492      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1493      */
1494     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1495         private 
1496     {
1497         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1498         if (_earnings > 0)
1499         {
1500             // put in gen vault
1501             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1502             // zero out their earnings by updating mask
1503             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1504         }
1505     }
1506     
1507     /**
1508      * @dev updates round timer based on number of whole keys bought.
1509      */
1510     function updateTimer(uint256 _keys, uint256 _rID)
1511         private
1512     {
1513         // calculate time based on number of keys bought
1514         uint256 _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1515         
1516         // grab time
1517         uint256 _now = now;
1518         
1519         // compare to max and set new end time
1520         if (_newTime < (rndMax_).add(_now))
1521             round_[_rID].end = _newTime;
1522         else
1523             round_[_rID].end = rndMax_.add(_now);
1524     }
1525     
1526     /**
1527      * @dev generates a random number between 0-99 and checks to see if thats
1528      * resulted in an airdrop win
1529      * @return do we have a winner?
1530      */
1531     function airdrop()
1532         private 
1533         view 
1534         returns(bool)
1535     {
1536         uint256 seed = uint256(keccak256(abi.encodePacked(
1537             
1538             (block.timestamp).add
1539             (block.difficulty).add
1540             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1541             (block.gaslimit).add
1542             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1543             (block.number)
1544             
1545         )));
1546         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1547             return(true);
1548         else
1549             return(false);
1550     }
1551 
1552     /**
1553      * @dev distributes eth based on fees to com, aff, and p3d
1554      */
1555     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1556         private
1557         returns(F3Ddatasets.EventReturns)
1558     {
1559         // pay 2% out to community rewards
1560         uint256 _com = _eth / 50;
1561         uint256 _p3d;
1562 
1563         if (!address(admin).call.value(_com)())
1564         {
1565             // This ensures Team Just cannot influence the outcome of FoMo3D with
1566             // bank migrations by breaking outgoing transactions.
1567             // Something we would never do. But that's not the point.
1568             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1569             // highest belief that everything we create should be trustless.
1570             // Team JUST, The name you shouldn't have to trust.
1571             _p3d = _com;
1572             _com = 0;
1573         }
1574         
1575         // pay 1% out to FoMo3D long
1576         uint256 _long = _eth / 100;
1577         admin.transfer(_long);
1578         
1579         // distribute share to affiliate
1580         uint256 _aff = _eth / 10;
1581         
1582         // decide what to do with affiliate share of fees
1583         // affiliate must not be self, and must have a name registered
1584         if (_affID != _pID && plyr_[_affID].name != '') {
1585             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1586             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1587         } else {
1588             _p3d = _aff;
1589         }
1590         
1591         // pay out p3d
1592         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1593         if (_p3d > 0)
1594         {
1595             // deposit to divies contract
1596             admin.transfer(_p3d);
1597             
1598             // set up event data
1599             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1600         }
1601         
1602         return(_eventData_);
1603     }
1604     
1605     function potSwap()
1606         external
1607         payable
1608     {
1609         // setup local rID
1610         uint256 _rID = rID_ + 1;
1611         
1612         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1613         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1614     }
1615     
1616     /**
1617      * @dev distributes eth based on fees to gen and pot
1618      */
1619     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1620         private
1621         returns(F3Ddatasets.EventReturns)
1622     {
1623         // calculate gen share
1624         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1625         
1626         // toss 1% into airdrop pot 
1627         uint256 _air = (_eth / 100);
1628         airDropPot_ = airDropPot_.add(_air);
1629         
1630         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1631         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1632         
1633         // calculate pot 
1634         uint256 _pot = _eth.sub(_gen);
1635         
1636         // distribute gen share (thats what updateMasks() does) and adjust
1637         // balances for dust.
1638         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1639         if (_dust > 0)
1640             _gen = _gen.sub(_dust);
1641         
1642         // add eth to pot
1643         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1644         
1645         // set up event data
1646         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1647         _eventData_.potAmount = _pot;
1648         
1649         return(_eventData_);
1650     }
1651 
1652     /**
1653      * @dev updates masks for round and player when keys are bought
1654      * @return dust left over 
1655      */
1656     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1657         private
1658         returns(uint256)
1659     {
1660         /* MASKING NOTES
1661             earnings masks are a tricky thing for people to wrap their minds around.
1662             the basic thing to understand here.  is were going to have a global
1663             tracker based on profit per share for each round, that increases in
1664             relevant proportion to the increase in share supply.
1665             
1666             the player will have an additional mask that basically says "based
1667             on the rounds mask, my shares, and how much i've already withdrawn,
1668             how much is still owed to me?"
1669         */
1670         
1671         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1672         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1673         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1674             
1675         // calculate player earning from their own buy (only based on the keys
1676         // they just bought).  & update player earnings mask
1677         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1678         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1679         
1680         // calculate & return dust
1681         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1682     }
1683     
1684     /**
1685      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1686      * @return earnings in wei format
1687      */
1688     function withdrawEarnings(uint256 _pID)
1689         private
1690         returns(uint256)
1691     {
1692         // update gen vault
1693         updateGenVault(_pID, plyr_[_pID].lrnd);
1694         
1695         // from vaults 
1696         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1697         if (_earnings > 0)
1698         {
1699             plyr_[_pID].win = 0;
1700             plyr_[_pID].gen = 0;
1701             plyr_[_pID].aff = 0;
1702         }
1703 
1704         return(_earnings);
1705     }
1706     
1707     /**
1708      * @dev prepares compression data and fires event for buy or reload tx's
1709      */
1710     function endTx(uint256 _rID, uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1711         private
1712     {
1713         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1714         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (_rID * 10000000000000000000000000000000000000000000000000000);
1715         
1716         emit F3Devents.onEndTx
1717         (
1718             _eventData_.compressedData,
1719             _eventData_.compressedIDs,
1720             plyr_[_pID].name,
1721             msg.sender,
1722             _eth,
1723             _keys,
1724             _eventData_.winnerAddr,
1725             _eventData_.winnerName,
1726             _eventData_.amountWon,
1727             _eventData_.newPot,
1728             _eventData_.P3DAmount,
1729             _eventData_.genAmount,
1730             _eventData_.potAmount,
1731             airDropPot_
1732         );
1733     }
1734 //==============================================================================
1735 //    (~ _  _    _._|_    .
1736 //    _)(/_(_|_|| | | \/  .
1737 //====================/=========================================================
1738     /** upon contract deploy, it will be deactivated.  this is a one time
1739      * use function that will activate the contract.  we do this so devs 
1740      * have time to set things up on the web end                            **/
1741     bool public activated_ = false;
1742     function activate()
1743         public
1744     {
1745         // only team just can activate 
1746         require(msg.sender == admin);
1747 
1748         // can only be ran once
1749         require(activated_ == false, "fomo3d already activated");
1750         
1751         // activate the contract 
1752         activated_ = true;
1753         
1754         // lets start first round in ICO phase
1755 		rID_ = 1;
1756         round_[1].strt = now;
1757         round_[1].end = now + rndInit_ + rndGap_;
1758     }
1759 }
1760 
1761 
1762 //==============================================================================
1763 //   __|_ _    __|_ _  .
1764 //  _\ | | |_|(_ | _\  .
1765 //==============================================================================
1766 library F3Ddatasets {
1767     //compressedData key
1768     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1769         // 0 - new player (bool)
1770         // 1 - joined round (bool)
1771         // 2 - new  leader (bool)
1772         // 3-5 - air drop tracker (uint 0-999)
1773         // 6-16 - round end time
1774         // 17 - winnerTeam
1775         // 18 - 28 timestamp 
1776         // 29 - team
1777         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1778         // 31 - airdrop happened bool
1779         // 32 - airdrop tier 
1780         // 33 - airdrop amount won
1781     //compressedIDs key
1782     // [77-52][51-26][25-0]
1783         // 0-25 - pID 
1784         // 26-51 - winPID
1785         // 52-77 - rID
1786     struct EventReturns {
1787         uint256 compressedData;
1788         uint256 compressedIDs;
1789         address winnerAddr;         // winner address
1790         bytes32 winnerName;         // winner name
1791         uint256 amountWon;          // amount won
1792         uint256 newPot;             // amount in new pot
1793         uint256 P3DAmount;          // amount distributed to p3d
1794         uint256 genAmount;          // amount distributed to gen
1795         uint256 potAmount;          // amount added to pot
1796     }
1797     struct Player {
1798         address addr;   // player address
1799         bytes32 name;   // player name
1800         uint256 win;    // winnings vault
1801         uint256 gen;    // general vault
1802         uint256 aff;    // affiliate vault
1803         uint256 lrnd;   // last round played
1804         uint256 laff;   // last affiliate id used
1805     }
1806     struct PlayerRounds {
1807         uint256 eth;    // eth player has added to round (used for eth limiter)
1808         uint256 keys;   // keys
1809         uint256 mask;   // player mask 
1810         uint256 ico;    // ICO phase investment
1811     }
1812     struct Round {
1813         uint256 plyr;   // pID of player in lead
1814         uint256 team;   // tID of team in lead
1815         uint256 end;    // time ends/ended
1816         bool ended;     // has round end function been ran
1817         uint256 strt;   // time round started
1818         uint256 keys;   // keys
1819         uint256 eth;    // total eth in
1820         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1821         uint256 mask;   // global mask
1822         uint256 ico;    // total eth sent in during ICO phase
1823         uint256 icoGen; // total eth for gen during ICO phase
1824         uint256 icoAvg; // average key price for ICO phase
1825     }
1826     struct TeamFee {
1827         uint256 gen;    // % of buy in thats paid to key holders of current round
1828         uint256 p3d;    // % of buy in thats paid to p3d holders
1829     }
1830     struct PotSplit {
1831         uint256 gen;    // % of pot thats paid to key holders of current round
1832         uint256 p3d;    // % of pot thats paid to p3d holders
1833     }
1834 }
1835 
1836 //==============================================================================
1837 //  |  _      _ _ | _  .
1838 //  |<(/_\/  (_(_||(_  .
1839 //=======/======================================================================
1840 library F3DKeysCalcFast {
1841     using SafeMath for *;
1842     
1843     /**
1844      * @dev calculates number of keys received given X eth 
1845      * @param _curEth current amount of eth in contract 
1846      * @param _newEth eth being spent
1847      * @return amount of ticket purchased
1848      */
1849     function keysRec(uint256 _curEth, uint256 _newEth)
1850         internal
1851         pure
1852         returns (uint256)
1853     {
1854         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1855     }
1856     
1857     /**
1858      * @dev calculates amount of eth received if you sold X keys 
1859      * @param _curKeys current amount of keys that exist 
1860      * @param _sellKeys amount of keys you wish to sell
1861      * @return amount of eth received
1862      */
1863     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1864         internal
1865         pure
1866         returns (uint256)
1867     {
1868         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1869     }
1870 
1871     /**
1872      * @dev calculates how many keys would exist with given an amount of eth
1873      * @param _eth eth "in contract"
1874      * @return number of keys that would exist
1875      */
1876     function keys(uint256 _eth) 
1877         internal
1878         pure
1879         returns(uint256)
1880     {
1881         return ((((((_eth).mul(1000000000000000000)).mul(200000000000000000000000000000000)).add(2500000000000000000000000000000000000000000000000000000000000000)).sqrt()).sub(50000000000000000000000000000000)) / (100000000000000);
1882     }
1883     
1884     /**
1885      * @dev calculates how much eth would be in contract given a number of keys
1886      * @param _keys number of keys "in contract" 
1887      * @return eth that would exists
1888      */
1889     function eth(uint256 _keys) 
1890         internal
1891         pure
1892         returns(uint256)  
1893     {
1894         return ((50000000000000).mul(_keys.sq()).add(((100000000000000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1895     }
1896 }
1897 
1898 //==============================================================================
1899 //  . _ _|_ _  _ |` _  _ _  _  .
1900 //  || | | (/_| ~|~(_|(_(/__\  .
1901 //==============================================================================
1902 interface DiviesInterface {
1903     function deposit() external payable;
1904 }
1905 
1906 interface JIincForwarderInterface {
1907     function deposit() external payable returns(bool);
1908     function status() external view returns(address, address, bool);
1909     function startMigration(address _newCorpBank) external returns(bool);
1910     function cancelMigration() external returns(bool);
1911     function finishMigration() external returns(bool);
1912     function setup(address _firstCorpBank) external;
1913 }
1914 
1915 interface PlayerBookInterface {
1916     function getPlayerID(address _addr) external returns (uint256);
1917     function getPlayerName(uint256 _pID) external view returns (bytes32);
1918     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1919     function getPlayerAddr(uint256 _pID) external view returns (address);
1920     function getNameFee() external view returns (uint256);
1921     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1922     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1923     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1924 }
1925 
1926 /**
1927 * @title -Name Filter- v0.1.9
1928 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1929 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1930 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1931 *                                  _____                      _____
1932 *                                 (, /     /)       /) /)    (, /      /)          /)
1933 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1934 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1935 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1936 *                            (__ /          (_/ (, /                                      /)™ 
1937 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1938 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1939 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1940 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1941 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1942 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1943 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1944 *
1945 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1946 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1947 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1948 */
1949 
1950 library NameFilter {
1951     
1952     /**
1953      * @dev filters name strings
1954      * -converts uppercase to lower case.  
1955      * -makes sure it does not start/end with a space
1956      * -makes sure it does not contain multiple spaces in a row
1957      * -cannot be only numbers
1958      * -cannot start with 0x 
1959      * -restricts characters to A-Z, a-z, 0-9, and space.
1960      * @return reprocessed string in bytes32 format
1961      */
1962     function nameFilter(string _input)
1963         internal
1964         pure
1965         returns(bytes32)
1966     {
1967         bytes memory _temp = bytes(_input);
1968         uint256 _length = _temp.length;
1969         
1970         //sorry limited to 32 characters
1971         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1972         // make sure it doesnt start with or end with space
1973         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1974         // make sure first two characters are not 0x
1975         if (_temp[0] == 0x30)
1976         {
1977             require(_temp[1] != 0x78, "string cannot start with 0x");
1978             require(_temp[1] != 0x58, "string cannot start with 0X");
1979         }
1980         
1981         // create a bool to track if we have a non number character
1982         bool _hasNonNumber;
1983         
1984         // convert & check
1985         for (uint256 i = 0; i < _length; i++)
1986         {
1987             // if its uppercase A-Z
1988             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1989             {
1990                 // convert to lower case a-z
1991                 _temp[i] = byte(uint(_temp[i]) + 32);
1992                 
1993                 // we have a non number
1994                 if (_hasNonNumber == false)
1995                     _hasNonNumber = true;
1996             } else {
1997                 require
1998                 (
1999                     // require character is a space
2000                     _temp[i] == 0x20 || 
2001                     // OR lowercase a-z
2002                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2003                     // or 0-9
2004                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
2005                     "string contains invalid characters"
2006                 );
2007                 // make sure theres not 2x spaces in a row
2008                 if (_temp[i] == 0x20)
2009                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2010                 
2011                 // see if we have a character other than a number
2012                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2013                     _hasNonNumber = true;    
2014             }
2015         }
2016         
2017         require(_hasNonNumber == true, "string cannot be only numbers");
2018         
2019         bytes32 _ret;
2020         assembly {
2021             _ret := mload(add(_temp, 32))
2022         }
2023         return (_ret);
2024     }
2025 }
2026 
2027 /**
2028  * @title SafeMath v0.1.9
2029  * @dev Math operations with safety checks that throw on error
2030  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2031  * - added sqrt
2032  * - added sq
2033  * - added pwr 
2034  * - changed asserts to requires with error log outputs
2035  * - removed div, its useless
2036  */
2037 library SafeMath {
2038     
2039     /**
2040     * @dev Multiplies two numbers, throws on overflow.
2041     */
2042     function mul(uint256 a, uint256 b) 
2043         internal 
2044         pure 
2045         returns (uint256 c) 
2046     {
2047         if (a == 0) {
2048             return 0;
2049         }
2050         c = a * b;
2051         require(c / a == b, "SafeMath mul failed");
2052         return c;
2053     }
2054 
2055     /**
2056     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2057     */
2058     function sub(uint256 a, uint256 b)
2059         internal
2060         pure
2061         returns (uint256) 
2062     {
2063         require(b <= a, "SafeMath sub failed");
2064         return a - b;
2065     }
2066 
2067     /**
2068     * @dev Adds two numbers, throws on overflow.
2069     */
2070     function add(uint256 a, uint256 b)
2071         internal
2072         pure
2073         returns (uint256 c) 
2074     {
2075         c = a + b;
2076         require(c >= a, "SafeMath add failed");
2077         return c;
2078     }
2079     
2080     /**
2081      * @dev gives square root of given x.
2082      */
2083     function sqrt(uint256 x)
2084         internal
2085         pure
2086         returns (uint256 y) 
2087     {
2088         uint256 z = ((add(x,1)) / 2);
2089         y = x;
2090         while (z < y) 
2091         {
2092             y = z;
2093             z = ((add((x / z),z)) / 2);
2094         }
2095     }
2096     
2097     /**
2098      * @dev gives square. multiplies x by x
2099      */
2100     function sq(uint256 x)
2101         internal
2102         pure
2103         returns (uint256)
2104     {
2105         return (mul(x,x));
2106     }
2107     
2108     /**
2109      * @dev x to the power of y 
2110      */
2111     function pwr(uint256 x, uint256 y)
2112         internal 
2113         pure 
2114         returns (uint256)
2115     {
2116         if (x==0)
2117             return (0);
2118         else if (y==0)
2119             return (1);
2120         else 
2121         {
2122             uint256 z = x;
2123             for (uint256 i=1; i < y; i++)
2124                 z = mul(z,x);
2125             return (z);
2126         }
2127     }
2128 }