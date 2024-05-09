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
112     // // received pot swap deposit
113     // event onPotSwapDeposit
114     // (
115     //     uint256 roundID,
116     //     uint256 amountAddedToPot
117     // );
118 }
119 
120 //==============================================================================
121 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
122 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
123 //====================================|=========================================
124 
125 contract modularLong is F3Devents {}
126 
127 contract FoMo3Dlong is modularLong {
128     using SafeMath for *;
129     using NameFilter for string;
130     using F3DKeysCalcLong for uint256;
131 	
132     //god of game
133     address constant private god = 0xe1B35fEBaB9Ff6da5b29C3A7A44eef06cD86B0f9;
134     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x99a1cac09c1c07037c3c7b821ce4ddc4a9fe564d);
135 //==============================================================================
136 //     _ _  _  |`. _     _ _ |_ | _  _  .
137 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
138 //=================_|===========================================================
139     string constant public name = "FM3D More Award~";
140     string constant public symbol = "F3D";
141     uint256 private rndExtra_ = 10 minutes;                     // length of the very first ICO 
142     uint256 private rndGap_ = 30 minutes;                       // length of ICO phase, set to 1 year for EOS.
143     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
144     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
145     uint256 constant private rndMax_ = 8 hours;                // max length a round timer can be
146 //==============================================================================
147 //     _| _ _|_ _    _ _ _|_    _   .
148 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
149 //=============================|================================================
150     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
151     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
152     uint256 public rID_;    // round id number / total rounds that have happened
153 //****************
154 // PLAYER DATA 
155 //****************
156     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
157     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
158     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
159     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
160     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
161 //****************
162 // ROUND DATA 
163 //****************
164     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
165     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
166 //****************
167 // TEAM FEE DATA 
168 //****************
169     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
170     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
171 //==============================================================================
172 //     _ _  _  __|_ _    __|_ _  _  .
173 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
174 //==============================================================================
175     constructor()
176         public
177     {
178         // Team allocation percentages
179         fees_[0] = F3Ddatasets.TeamFee(40,0);   //40% to gen, 20% to pot, 35% to aff, 5% to com, 0% to air drop pot
180         fees_[1] = F3Ddatasets.TeamFee(40,0);   //40% to gen, 20% to pot, 35% to aff, 5% to com, 0% to air drop pot
181         fees_[2] = F3Ddatasets.TeamFee(40,0);   //40% to gen, 20% to pot, 35% to aff, 5% to com, 0% to air drop pot
182         fees_[3] = F3Ddatasets.TeamFee(40,0);   //40% to gen, 20% to pot, 35% to aff, 5% to com, 0% to air drop pot
183         potSplit_[0] = F3Ddatasets.PotSplit(95,0);  //95% to winner, 5% to next round, 0% to com
184         potSplit_[1] = F3Ddatasets.PotSplit(95,0);  //95% to winner, 5% to next round, 0% to com
185         potSplit_[2] = F3Ddatasets.PotSplit(95,0);  //95% to winner, 5% to next round, 0% to com
186         potSplit_[3] = F3Ddatasets.PotSplit(95,0);  //95% to winner, 5% to next round, 0% to com
187     }
188 //==============================================================================
189 //     _ _  _  _|. |`. _  _ _  .
190 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
191 //==============================================================================
192     /**
193      * @dev used to make sure no one can interact with contract until it has 
194      * been activated. 
195      */
196     modifier isActivated() {
197         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
198         _;
199     }
200     
201     /**
202      * @dev prevents contracts from interacting with fomo3d 
203      */
204     modifier isHuman() {
205         address _addr = msg.sender;
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
218         require(_eth <= 100000000000000000000000, "no vitalik, no");
219         _;    
220     }
221     
222 //==============================================================================
223 //     _    |_ |. _   |`    _  __|_. _  _  _  .
224 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
225 //====|=========================================================================
226     /**
227      * @dev emergency buy uses last stored affiliate ID and team snek
228      */
229     function()
230         isActivated()
231         isHuman()
232         isWithinLimits(msg.value)
233         public
234         payable
235     {
236         // set up our tx event data and determine if player is new or not
237         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
238             
239         // fetch player id
240         uint256 _pID = pIDxAddr_[msg.sender];
241         
242         // buy core 
243         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
244     }
245     
246     /**
247      * @dev determine player's affid
248      * @param _pID the ID/address/name of the player who gets the affiliate fee
249      * @param _inAffID what team is the player playing for?
250      * @return _affID player's real affid
251      */
252     function determineAffID(uint256 _pID, uint256 _inAffID) private returns(uint256){
253         if(plyr_[_pID].laff == 0){
254             // update last affiliate 
255             plyr_[_pID].laff = _inAffID;
256         }
257         return plyr_[_pID].laff;
258     }
259 
260     /**
261      * @dev converts all incoming ethereum to keys.
262      * -functionhash- 0x8f38f309 (using ID for affiliate)
263      * -functionhash- 0x98a0871d (using address for affiliate)
264      * -functionhash- 0xa65b37a1 (using name for affiliate)
265      * @param _affCode the ID/address/name of the player who gets the affiliate fee
266      * @param _team what team is the player playing for?
267      */
268     function buyXid(uint256 _affCode, uint256 _team)
269         isActivated()
270         isHuman()
271         isWithinLimits(msg.value)
272         public
273         payable
274     {
275         // set up our tx event data and determine if player is new or not
276         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
277         
278         // fetch player id
279         uint256 _pID = pIDxAddr_[msg.sender];
280         
281         // manage affiliate residuals
282         // if no affiliate code was given or player tried to use their own, lolz
283         if (_affCode == 0 || _affCode == _pID)
284         {
285             // use last stored affiliate code 
286             _affCode = plyr_[_pID].laff;
287             
288         // if affiliate code was given & its not the same as previously stored 
289         } else if (_affCode != plyr_[_pID].laff) {
290             _affCode = determineAffID(_pID,_affCode);
291         }
292         
293         // verify a valid team was selected
294         _team = verifyTeam(_team);
295         
296         // buy core 
297         buyCore(_pID, _affCode, _team, _eventData_);
298     }
299     
300     function buyXaddr(address _affCode, uint256 _team)
301         isActivated()
302         isHuman()
303         isWithinLimits(msg.value)
304         public
305         payable
306     {
307         // set up our tx event data and determine if player is new or not
308         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
309         
310         // fetch player id
311         uint256 _pID = pIDxAddr_[msg.sender];
312         
313         // manage affiliate residuals
314         uint256 _affID;
315         // if no affiliate code was given or player tried to use their own, lolz
316         if (_affCode == address(0) || _affCode == msg.sender)
317         {
318             // use last stored affiliate code
319             _affID = plyr_[_pID].laff;
320         
321         // if affiliate code was given    
322         } else {
323             // get affiliate ID from aff Code 
324             _affID = pIDxAddr_[_affCode];
325             
326             // if affID is not the same as previously stored 
327             if (_affID != plyr_[_pID].laff)
328             {
329                 _affID = determineAffID(_pID,_affID);
330             }
331         }
332         
333         // verify a valid team was selected
334         _team = verifyTeam(_team);
335         
336         // buy core 
337         buyCore(_pID, _affID, _team, _eventData_);
338     }
339     
340     function buyXname(bytes32 _affCode, uint256 _team)
341         isActivated()
342         isHuman()
343         isWithinLimits(msg.value)
344         public
345         payable
346     {
347         // set up our tx event data and determine if player is new or not
348         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
349         
350         // fetch player id
351         uint256 _pID = pIDxAddr_[msg.sender];
352         
353         // manage affiliate residuals
354         uint256 _affID;
355         // if no affiliate code was given or player tried to use their own, lolz
356         if (_affCode == '' || _affCode == plyr_[_pID].name)
357         {
358             // use last stored affiliate code
359             _affID = plyr_[_pID].laff;
360         
361         // if affiliate code was given
362         } else {
363             // get affiliate ID from aff Code
364             _affID = pIDxName_[_affCode];
365             
366             // if affID is not the same as previously stored
367             if (_affID != plyr_[_pID].laff)
368             {
369                 _affID = determineAffID(_pID,_affID);
370             }
371         }
372         
373         // verify a valid team was selected
374         _team = verifyTeam(_team);
375         
376         // buy core 
377         buyCore(_pID, _affID, _team, _eventData_);
378     }
379     
380     /**
381      * @dev essentially the same as buy, but instead of you sending ether 
382      * from your wallet, it uses your unwithdrawn earnings.
383      * -functionhash- 0x349cdcac (using ID for affiliate)
384      * -functionhash- 0x82bfc739 (using address for affiliate)
385      * -functionhash- 0x079ce327 (using name for affiliate)
386      * @param _affCode the ID/address/name of the player who gets the affiliate fee
387      * @param _team what team is the player playing for?
388      * @param _eth amount of earnings to use (remainder returned to gen vault)
389      */
390     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
391         isActivated()
392         isHuman()
393         isWithinLimits(_eth)
394         public
395     {
396         // set up our tx event data
397         F3Ddatasets.EventReturns memory _eventData_;
398         
399         // fetch player ID
400         uint256 _pID = pIDxAddr_[msg.sender];
401         
402         // manage affiliate residuals
403         // if no affiliate code was given or player tried to use their own, lolz
404         if (_affCode == 0 || _affCode == _pID)
405         {
406             // use last stored affiliate code 
407             _affCode = plyr_[_pID].laff;
408             
409         // if affiliate code was given & its not the same as previously stored 
410         } else if (_affCode != plyr_[_pID].laff) {
411             _affCode = determineAffID(_pID,_affCode);
412         }
413 
414         // verify a valid team was selected
415         _team = verifyTeam(_team);
416 
417         // reload core
418         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
419     }
420     
421     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
422         isActivated()
423         isHuman()
424         isWithinLimits(_eth)
425         public
426     {
427         // set up our tx event data
428         F3Ddatasets.EventReturns memory _eventData_;
429         
430         // fetch player ID
431         uint256 _pID = pIDxAddr_[msg.sender];
432         
433         // manage affiliate residuals
434         uint256 _affID;
435         // if no affiliate code was given or player tried to use their own, lolz
436         if (_affCode == address(0) || _affCode == msg.sender)
437         {
438             // use last stored affiliate code
439             _affID = plyr_[_pID].laff;
440         
441         // if affiliate code was given    
442         } else {
443             // get affiliate ID from aff Code 
444             _affID = pIDxAddr_[_affCode];
445             
446             // if affID is not the same as previously stored 
447             if (_affID != plyr_[_pID].laff)
448             {
449                 _affID = determineAffID(_pID,_affID);
450             }
451         }
452         
453         // verify a valid team was selected
454         _team = verifyTeam(_team);
455         
456         // reload core
457         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
458     }
459     
460     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
461         isActivated()
462         isHuman()
463         isWithinLimits(_eth)
464         public
465     {
466         // set up our tx event data
467         F3Ddatasets.EventReturns memory _eventData_;
468         
469         // fetch player ID
470         uint256 _pID = pIDxAddr_[msg.sender];
471         
472         // manage affiliate residuals
473         uint256 _affID;
474         // if no affiliate code was given or player tried to use their own, lolz
475         if (_affCode == '' || _affCode == plyr_[_pID].name)
476         {
477             // use last stored affiliate code
478             _affID = plyr_[_pID].laff;
479         
480         // if affiliate code was given
481         } else {
482             // get affiliate ID from aff Code
483             _affID = pIDxName_[_affCode];
484             
485             // if affID is not the same as previously stored
486             if (_affID != plyr_[_pID].laff)
487             {
488                 _affID = determineAffID(_pID,_affID);
489             }
490         }
491         
492         // verify a valid team was selected
493         _team = verifyTeam(_team);
494         
495         // reload core
496         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
497     }
498 
499     /**
500      * @dev withdraws all of your earnings.
501      * -functionhash- 0x3ccfd60b
502      */
503     function withdraw()
504         isActivated()
505         isHuman()
506         public
507     {
508         // setup local rID 
509         uint256 _rID = rID_;
510         
511         // grab time
512         uint256 _now = now;
513         
514         // fetch player ID
515         uint256 _pID = pIDxAddr_[msg.sender];
516         
517         // setup temp var for player eth
518         uint256 _eth;
519         
520         // check to see if round has ended and no one has run round end yet
521         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
522         {
523             // set up our tx event data
524             F3Ddatasets.EventReturns memory _eventData_;
525             
526             // end the round (distributes pot)
527 			round_[_rID].ended = true;
528             _eventData_ = endRound(_eventData_);
529             
530 			// get their earnings
531             _eth = withdrawEarnings(_pID);
532             
533             // gib moni
534             if (_eth > 0)
535                 plyr_[_pID].addr.transfer(_eth);    
536             
537             // build event data
538             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
539             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
540             
541             // fire withdraw and distribute event
542             emit F3Devents.onWithdrawAndDistribute
543             (
544                 msg.sender, 
545                 plyr_[_pID].name, 
546                 _eth, 
547                 _eventData_.compressedData, 
548                 _eventData_.compressedIDs, 
549                 _eventData_.winnerAddr, 
550                 _eventData_.winnerName, 
551                 _eventData_.amountWon, 
552                 _eventData_.newPot, 
553                 _eventData_.P3DAmount, 
554                 _eventData_.genAmount
555             );
556             
557         // in any other situation
558         } else {
559             // get their earnings
560             _eth = withdrawEarnings(_pID);
561             
562             // gib moni
563             if (_eth > 0)
564                 plyr_[_pID].addr.transfer(_eth);
565             
566             // fire withdraw event
567             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
568         }
569     }
570     
571     /**
572      * @dev use these to register names.  they are just wrappers that will send the
573      * registration requests to the PlayerBook contract.  So registering here is the 
574      * same as registering there.  UI will always display the last name you registered.
575      * but you will still own all previously registered names to use as affiliate 
576      * links.
577      * - must pay a registration fee.
578      * - name must be unique
579      * - names will be converted to lowercase
580      * - name cannot start or end with a space 
581      * - cannot have more than 1 space in a row
582      * - cannot be only numbers
583      * - cannot start with 0x 
584      * - name must be at least 1 char
585      * - max length of 32 characters long
586      * - allowed characters: a-z, 0-9, and space
587      * -functionhash- 0x921dec21 (using ID for affiliate)
588      * -functionhash- 0x3ddd4698 (using address for affiliate)
589      * -functionhash- 0x685ffd83 (using name for affiliate)
590      * @param _nameString players desired name
591      * @param _affCode affiliate ID, address, or name of who referred you
592      * @param _all set to true if you want this to push your info to all games 
593      * (this might cost a lot of gas)
594      */
595     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
596         isHuman()
597         public
598         payable
599     {
600         bytes32 _name = _nameString.nameFilter();
601         address _addr = msg.sender;
602         uint256 _paid = msg.value;
603         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
604         
605         uint256 _pID = pIDxAddr_[_addr];
606         
607         // fire event
608         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
609     }
610     
611     function registerNameXaddr(string _nameString, address _affCode, bool _all)
612         isHuman()
613         public
614         payable
615     {
616         bytes32 _name = _nameString.nameFilter();
617         address _addr = msg.sender;
618         uint256 _paid = msg.value;
619         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
620         
621         uint256 _pID = pIDxAddr_[_addr];
622         
623         // fire event
624         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
625     }
626     
627     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
628         isHuman()
629         public
630         payable
631     {
632         bytes32 _name = _nameString.nameFilter();
633         address _addr = msg.sender;
634         uint256 _paid = msg.value;
635         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
636         
637         uint256 _pID = pIDxAddr_[_addr];
638         
639         // fire event
640         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
641     }
642 //==============================================================================
643 //     _  _ _|__|_ _  _ _  .
644 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
645 //=====_|=======================================================================
646     /**
647      * @dev return the price buyer will pay for next 1 individual key.
648      * -functionhash- 0x018a25e8
649      * @return price for next key bought (in wei format)
650      */
651     function getBuyPrice()
652         public 
653         view 
654         returns(uint256)
655     {  
656         // setup local rID
657         uint256 _rID = rID_;
658         
659         // grab time
660         uint256 _now = now;
661         
662         // are we in a round?
663         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
664             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
665         else // rounds over.  need price for new round
666             return ( 75000000000000 ); // init
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
686         if (_now < round_[_rID].end)
687             if (_now > round_[_rID].strt + rndGap_)
688                 return( (round_[_rID].end).sub(_now) );
689             else
690                 return( (round_[_rID].strt + rndGap_).sub(_now) );
691         else
692             return(0);
693     }
694     
695     /**
696      * @dev returns player earnings per vaults 
697      * -functionhash- 0x63066434
698      * @return winnings vault
699      * @return general vault
700      * @return affiliate vault
701      */
702     function getPlayerVaults(uint256 _pID)
703         public
704         view
705         returns(uint256 ,uint256, uint256)
706     {
707         // setup local rID
708         uint256 _rID = rID_;
709         
710         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
711         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
712         {
713             // if player is winner 
714             if (round_[_rID].plyr == _pID)
715             {
716                 return
717                 (
718                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
719                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
720                     plyr_[_pID].aff
721                 );
722             // if player is not the winner
723             } else {
724                 return
725                 (
726                     plyr_[_pID].win,
727                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
728                     plyr_[_pID].aff
729                 );
730             }
731             
732         // if round is still going on, or round has ended and round end has been ran
733         } else {
734             return
735             (
736                 plyr_[_pID].win,
737                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
738                 plyr_[_pID].aff
739             );
740         }
741     }
742     
743     /**
744      * solidity hates stack limits.  this lets us avoid that hate 
745      */
746     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
747         private
748         view
749         returns(uint256)
750     {
751         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
752     }
753     
754     /**
755      * @dev returns all current round info needed for front end
756      * -functionhash- 0x747dff42
757      * @return eth invested during ICO phase
758      * @return round id 
759      * @return total keys for round 
760      * @return time round ends
761      * @return time round started
762      * @return current pot 
763      * @return current team ID & player ID in lead 
764      * @return current player in leads address 
765      * @return current player in leads name
766      * @return whales eth in for round
767      * @return bears eth in for round
768      * @return sneks eth in for round
769      * @return bulls eth in for round
770      * @return airdrop tracker # & airdrop pot
771      */
772     function getCurrentRoundInfo()
773         public
774         view
775         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
776     {
777         // setup local rID
778         uint256 _rID = rID_;
779         
780         return
781         (
782             round_[_rID].ico,               //0
783             _rID,                           //1
784             round_[_rID].keys,              //2
785             round_[_rID].end,               //3
786             round_[_rID].strt,              //4
787             round_[_rID].pot,               //5
788             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
789             plyr_[round_[_rID].plyr].addr,  //7
790             plyr_[round_[_rID].plyr].name,  //8
791             rndTmEth_[_rID][0],             //9
792             rndTmEth_[_rID][1],             //10
793             rndTmEth_[_rID][2],             //11
794             rndTmEth_[_rID][3],             //12
795             airDropTracker_ + (airDropPot_ * 1000)              //13
796         );
797     }
798 
799     /**
800      * @dev returns player info based on address.  if no address is given, it will 
801      * use msg.sender 
802      * -functionhash- 0xee0b5d8b
803      * @param _addr address of the player you want to lookup 
804      * @return player ID 
805      * @return player name
806      * @return keys owned (current round)
807      * @return winnings vault
808      * @return general vault 
809      * @return affiliate vault 
810 	 * @return player round eth
811      */
812     function getPlayerInfoByAddress(address _addr)
813         public 
814         view 
815         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
816     {
817         // setup local rID
818         uint256 _rID = rID_;
819         
820         if (_addr == address(0))
821         {
822             _addr == msg.sender;
823         }
824         uint256 _pID = pIDxAddr_[_addr];
825         
826         return
827         (
828             _pID,                               //0
829             plyr_[_pID].name,                   //1
830             plyrRnds_[_pID][_rID].keys,         //2
831             plyr_[_pID].win,                    //3
832             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
833             plyr_[_pID].aff,                    //5
834             plyrRnds_[_pID][_rID].eth           //6
835         );
836     }
837 
838 //==============================================================================
839 //     _ _  _ _   | _  _ . _  .
840 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
841 //=====================_|=======================================================
842     /**
843      * @dev logic runs whenever a buy order is executed.  determines how to handle 
844      * incoming eth depending on if we are in an active round or not
845      */
846     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
847         private
848     {
849         // setup local rID
850         uint256 _rID = rID_;
851         
852         // grab time
853         uint256 _now = now;
854         
855         // if round is active
856         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
857         {
858             // call core 
859             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
860         
861         // if round is not active     
862         } else {
863             // check to see if end round needs to be ran
864             if (_now > round_[_rID].end && round_[_rID].ended == false) 
865             {
866                 // end the round (distributes pot) & start new round
867 			    round_[_rID].ended = true;
868                 _eventData_ = endRound(_eventData_);
869                 
870                 // build event data
871                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
872                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
873                 
874                 // fire buy and distribute event 
875                 emit F3Devents.onBuyAndDistribute
876                 (
877                     msg.sender, 
878                     plyr_[_pID].name, 
879                     msg.value, 
880                     _eventData_.compressedData, 
881                     _eventData_.compressedIDs, 
882                     _eventData_.winnerAddr, 
883                     _eventData_.winnerName, 
884                     _eventData_.amountWon, 
885                     _eventData_.newPot, 
886                     _eventData_.P3DAmount, 
887                     _eventData_.genAmount
888                 );
889             }
890             
891             // put eth in players vault 
892             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
893         }
894     }
895     
896     /**
897      * @dev logic runs whenever a reload order is executed.  determines how to handle 
898      * incoming eth depending on if we are in an active round or not 
899      */
900     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
901         private
902     {
903         // setup local rID
904         uint256 _rID = rID_;
905         
906         // grab time
907         uint256 _now = now;
908         
909         // if round is active
910         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
911         {
912             // get earnings from all vaults and return unused to gen vault
913             // because we use a custom safemath library.  this will throw if player 
914             // tried to spend more eth than they have.
915             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
916             
917             // call core 
918             core(_rID, _pID, _eth, _affID, _team, _eventData_);
919         
920         // if round is not active and end round needs to be ran   
921         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
922             // end the round (distributes pot) & start new round
923             round_[_rID].ended = true;
924             _eventData_ = endRound(_eventData_);
925                 
926             // build event data
927             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
928             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
929                 
930             // fire buy and distribute event 
931             emit F3Devents.onReLoadAndDistribute
932             (
933                 msg.sender, 
934                 plyr_[_pID].name, 
935                 _eventData_.compressedData, 
936                 _eventData_.compressedIDs, 
937                 _eventData_.winnerAddr, 
938                 _eventData_.winnerName, 
939                 _eventData_.amountWon, 
940                 _eventData_.newPot, 
941                 _eventData_.P3DAmount, 
942                 _eventData_.genAmount
943             );
944         }
945     }
946     
947     /**
948      * @dev this is the core logic for any buy/reload that happens while a round 
949      * is live.
950      */
951     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
952         private
953     {
954         // if player is new to round
955         if (plyrRnds_[_pID][_rID].keys == 0)
956             _eventData_ = managePlayer(_pID, _eventData_);
957         
958         // // early round eth limiter 
959         // if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
960         // {
961         //     uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
962         //     uint256 _refund = _eth.sub(_availableLimit);
963         //     plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
964         //     _eth = _availableLimit;
965         // }
966         
967         // if eth left is greater than min eth allowed (sorry no pocket lint)
968         if (_eth > 1000000000) 
969         {
970             
971             // mint the new keys
972             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
973             
974             // if they bought at least 1 whole key
975             if (_keys >= 1000000000000000000)
976             {
977                 updateTimer(_keys, _rID);
978 
979                 // set new leaders
980                 if (round_[_rID].plyr != _pID)
981                     round_[_rID].plyr = _pID;  
982                 if (round_[_rID].team != _team)
983                     round_[_rID].team = _team; 
984                 
985                 // set the new leader bool to true
986                 _eventData_.compressedData = _eventData_.compressedData + 100;
987             }
988             
989             // manage airdrops
990             if (_eth >= 100000000000000000)
991             {
992                 airDropTracker_++;
993                 if (airdrop() == true)
994                 {
995                     // gib muni
996                     uint256 _prize;
997                     if (_eth >= 10000000000000000000)
998                     {
999                         // calculate prize and give it to winner
1000                         _prize = ((airDropPot_).mul(75)) / 100;
1001                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1002                         
1003                         // adjust airDropPot 
1004                         airDropPot_ = (airDropPot_).sub(_prize);
1005                         
1006                         // let event know a tier 3 prize was won 
1007                         _eventData_.compressedData += 300000000000000000000000000000000;
1008                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1009                         // calculate prize and give it to winner
1010                         _prize = ((airDropPot_).mul(50)) / 100;
1011                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1012                         
1013                         // adjust airDropPot 
1014                         airDropPot_ = (airDropPot_).sub(_prize);
1015                         
1016                         // let event know a tier 2 prize was won 
1017                         _eventData_.compressedData += 200000000000000000000000000000000;
1018                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1019                         // calculate prize and give it to winner
1020                         _prize = ((airDropPot_).mul(25)) / 100;
1021                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1022                         
1023                         // adjust airDropPot 
1024                         airDropPot_ = (airDropPot_).sub(_prize);
1025                         
1026                         // let event know a tier 3 prize was won 
1027                         _eventData_.compressedData += 300000000000000000000000000000000;
1028                     }
1029                     // set airdrop happened bool to true
1030                     _eventData_.compressedData += 10000000000000000000000000000000;
1031                     // let event know how much was won 
1032                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1033                     
1034                     // reset air drop tracker
1035                     airDropTracker_ = 0;
1036                 }
1037             }
1038     
1039             // store the air drop tracker number (number of buys since last airdrop)
1040             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1041             
1042             // update player 
1043             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1044             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1045             
1046             // update round
1047             round_[_rID].keys = _keys.add(round_[_rID].keys);
1048             round_[_rID].eth = _eth.add(round_[_rID].eth);
1049             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1050     
1051             // distribute eth
1052             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1053             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1054             
1055             // call end tx function to fire end tx event.
1056 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1057         }
1058     }
1059 //==============================================================================
1060 //     _ _ | _   | _ _|_ _  _ _  .
1061 //    (_(_||(_|_||(_| | (_)| _\  .
1062 //==============================================================================
1063     /**
1064      * @dev calculates unmasked earnings (just calculates, does not update mask)
1065      * @return earnings in wei format
1066      */
1067     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1068         private
1069         view
1070         returns(uint256)
1071     {
1072         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1073     }
1074     
1075     /** 
1076      * @dev returns the amount of keys you would get given an amount of eth. 
1077      * -functionhash- 0xce89c80c
1078      * @param _rID round ID you want price for
1079      * @param _eth amount of eth sent in 
1080      * @return keys received 
1081      */
1082     function calcKeysReceived(uint256 _rID, uint256 _eth)
1083         public
1084         view
1085         returns(uint256)
1086     {
1087         // grab time
1088         uint256 _now = now;
1089         
1090         // are we in a round?
1091         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1092             return ( (round_[_rID].eth).keysRec(_eth) );
1093         else // rounds over.  need keys for new round
1094             return ( (_eth).keys() );
1095     }
1096     
1097     /** 
1098      * @dev returns current eth price for X keys.  
1099      * -functionhash- 0xcf808000
1100      * @param _keys number of keys desired (in 18 decimal format)
1101      * @return amount of eth needed to send
1102      */
1103     function iWantXKeys(uint256 _keys)
1104         public
1105         view
1106         returns(uint256)
1107     {
1108         // setup local rID
1109         uint256 _rID = rID_;
1110         
1111         // grab time
1112         uint256 _now = now;
1113         
1114         // are we in a round?
1115         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1116             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1117         else // rounds over.  need price for new round
1118             return ( (_keys).eth() );
1119     }
1120 //==============================================================================
1121 //    _|_ _  _ | _  .
1122 //     | (_)(_)|_\  .
1123 //==============================================================================
1124     /**
1125 	 * @dev receives name/player info from names contract 
1126      */
1127     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1128         external
1129     {
1130         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1131         if (pIDxAddr_[_addr] != _pID)
1132             pIDxAddr_[_addr] = _pID;
1133         if (pIDxName_[_name] != _pID)
1134             pIDxName_[_name] = _pID;
1135         if (plyr_[_pID].addr != _addr)
1136             plyr_[_pID].addr = _addr;
1137         if (plyr_[_pID].name != _name)
1138             plyr_[_pID].name = _name;
1139         if (plyr_[_pID].laff != _laff)
1140             plyr_[_pID].laff = _laff;
1141         if (plyrNames_[_pID][_name] == false)
1142             plyrNames_[_pID][_name] = true;
1143     }
1144     
1145     /**
1146      * @dev receives entire player name list 
1147      */
1148     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1149         external
1150     {
1151         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1152         if(plyrNames_[_pID][_name] == false)
1153             plyrNames_[_pID][_name] = true;
1154     }   
1155         
1156     /**
1157      * @dev gets existing or registers new pID.  use this when a player may be new
1158      * @return pID 
1159      */
1160     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1161         private
1162         returns (F3Ddatasets.EventReturns)
1163     {
1164         uint256 _pID = pIDxAddr_[msg.sender];
1165         // if player is new to this version of fomo3d
1166         if (_pID == 0)
1167         {
1168             // grab their player ID, name and last aff ID, from player names contract 
1169             _pID = PlayerBook.getPlayerID(msg.sender);
1170             bytes32 _name = PlayerBook.getPlayerName(_pID);
1171             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1172             
1173             // set up player account 
1174             pIDxAddr_[msg.sender] = _pID;
1175             plyr_[_pID].addr = msg.sender;
1176             
1177             if (_name != "")
1178             {
1179                 pIDxName_[_name] = _pID;
1180                 plyr_[_pID].name = _name;
1181                 plyrNames_[_pID][_name] = true;
1182             }
1183             
1184             if (_laff != 0 && _laff != _pID)
1185                 plyr_[_pID].laff = _laff;
1186             
1187             // set the new player bool to true
1188             _eventData_.compressedData = _eventData_.compressedData + 1;
1189         } 
1190         return (_eventData_);
1191     }
1192     
1193     /**
1194      * @dev checks to make sure user picked a valid team.  if not sets team 
1195      * to default (sneks)
1196      */
1197     function verifyTeam(uint256 _team)
1198         private
1199         pure
1200         returns (uint256)
1201     {
1202         if (_team < 0 || _team > 3)
1203             return(2);
1204         else
1205             return(_team);
1206     }
1207     
1208     /**
1209      * @dev decides if round end needs to be run & new round started.  and if 
1210      * player unmasked earnings from previously played rounds need to be moved.
1211      */
1212     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1213         private
1214         returns (F3Ddatasets.EventReturns)
1215     {
1216         // if player has played a previous round, move their unmasked earnings
1217         // from that round to gen vault.
1218         if (plyr_[_pID].lrnd != 0)
1219             
1220             updateGenVault(_pID, plyr_[_pID].lrnd);
1221         // update player's last round played
1222         plyr_[_pID].lrnd = rID_;
1223             
1224         // set the joined round bool to true
1225         _eventData_.compressedData = _eventData_.compressedData + 10;
1226         
1227         return(_eventData_);
1228     }
1229     
1230     /**
1231      * @dev ends the round. manages paying out winner/splitting up pot
1232      */
1233     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1234         private
1235         returns (F3Ddatasets.EventReturns)
1236     {
1237         // setup local rID
1238         uint256 _rID = rID_;
1239         
1240         // grab our winning player and team id's
1241         uint256 _winPID = round_[_rID].plyr;
1242         uint256 _winTID = round_[_rID].team;
1243         
1244         // grab our pot amount
1245         uint256 _pot = round_[_rID].pot;
1246         
1247         // calculate our winner share, community rewards, gen share, 
1248         // p3d share, and amount reserved for next pot 
1249         uint256 _win = (_pot.mul(95)) / 100;
1250         uint256 _com = 0; //(_pot / 10);
1251         uint256 _gen = 0; //(_pot.mul(potSplit_[_winTID].gen)) / 100;
1252         uint256 _p3d = 0; //(_pot.mul(potSplit_[_winTID].p3d)) / 100;
1253         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1254         
1255         // calculate ppt for round mask
1256         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1257         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1258         if (_dust > 0)
1259         {
1260             _gen = _gen.sub(_dust);
1261             _res = _res.add(_dust);
1262         }
1263         
1264         // pay our winner
1265         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1266         
1267         // // community rewards
1268         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1269         // {
1270         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1271         //     // bank migrations by breaking outgoing transactions.
1272         //     // Something we would never do. But that's not the point.
1273         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1274         //     // highest belief that everything we create should be trustless.
1275         //     // Team JUST, The name you shouldn't have to trust.
1276         //     _p3d = _p3d.add(_com);
1277         //     _com = 0;
1278         // }
1279 
1280         // // community rewards send to god
1281         // address(god).transfer(_com);
1282         
1283         // distribute gen portion to key holders
1284         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1285         
1286         // // send share for p3d to divies
1287         // if (_p3d > 0)
1288         //     address(god).transfer(_p3d); //Divies.deposit.value(_p3d)();
1289             
1290         // prepare event data
1291         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1292         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1293         _eventData_.winnerAddr = plyr_[_winPID].addr;
1294         _eventData_.winnerName = plyr_[_winPID].name;
1295         _eventData_.amountWon = _win;
1296         _eventData_.genAmount = _gen;
1297         _eventData_.P3DAmount = _p3d;
1298         _eventData_.newPot = _res;
1299         
1300         // start next round
1301         rID_++;
1302         _rID++;
1303         round_[_rID].strt = now;
1304         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1305         round_[_rID].pot = _res;
1306         
1307         return(_eventData_);
1308     }
1309     
1310     /**
1311      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1312      */
1313     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1314         private 
1315     {
1316         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1317         if (_earnings > 0)
1318         {
1319             // put in gen vault
1320             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1321             // zero out their earnings by updating mask
1322             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1323         }
1324     }
1325     
1326     /**
1327      * @dev updates round timer based on number of whole keys bought.
1328      */
1329     function updateTimer(uint256 _keys, uint256 _rID)
1330         private
1331     {
1332         // grab time
1333         uint256 _now = now;
1334         
1335         // calculate time based on number of keys bought
1336         uint256 _newTime;
1337         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1338             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1339         else
1340             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1341         
1342         // compare to max and set new end time
1343         if (_newTime < (rndMax_).add(_now))
1344             round_[_rID].end = _newTime;
1345         else
1346             round_[_rID].end = rndMax_.add(_now);
1347     }
1348     
1349     /**
1350      * @dev generates a random number between 0-99 and checks to see if thats
1351      * resulted in an airdrop win
1352      * @return do we have a winner?
1353      */
1354     function airdrop()
1355         private 
1356         view 
1357         returns(bool)
1358     {
1359         uint256 seed = uint256(keccak256(abi.encodePacked(
1360             
1361             (block.timestamp).add
1362             (block.difficulty).add
1363             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1364             (block.gaslimit).add
1365             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1366             (block.number)
1367             
1368         )));
1369         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1370             return(true);
1371         else
1372             return(false);
1373     }
1374 
1375     /**
1376      * @dev distributes eth based on fees to com, aff, and p3d
1377      */
1378     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1379         private
1380         returns(F3Ddatasets.EventReturns)
1381     {
1382         // pay 5% out to community rewards
1383         uint256 _com = _eth / 20;
1384         uint256 _p3d;
1385         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1386         // {
1387         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1388         //     // bank migrations by breaking outgoing transactions.
1389         //     // Something we would never do. But that's not the point.
1390         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1391         //     // highest belief that everything we create should be trustless.
1392         //     // Team JUST, The name you shouldn't have to trust.
1393         //     _p3d = _com;
1394         //     _com = 0;
1395         // }
1396         
1397         // // pay 1% out to FoMo3D short
1398         // uint256 _long = _eth / 100;
1399         // otherF3D_.potSwap.value(_long)();
1400 
1401         //community rewards and FoMo3D short all send to god
1402         address(god).transfer(_com);
1403         
1404         // distribute share to affiliate 35%
1405         uint256 _aff = _eth.mul(35) / (100);
1406         
1407         // decide what to do with affiliate share of fees
1408         // affiliate must not be self, and must have a name registered
1409         if (_affID != _pID && plyr_[_affID].name != '') {
1410             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1411             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1412         } else {
1413             _p3d = _aff;
1414         }
1415         
1416         // pay out p3d
1417         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1418         if (_p3d > 0)
1419         {
1420             // // deposit to divies contract
1421             // Divies.deposit.value(_p3d)();
1422             
1423             // // set up event data
1424             // _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1425 
1426             // p3d send to god
1427             address(god).transfer(_p3d);
1428         }
1429         
1430         return(_eventData_);
1431     }
1432     
1433 
1434     // this function had a bug~
1435     // function potSwap()
1436     //     external
1437     //     payable
1438     // {
1439     //     // setup local rID
1440     //     uint256 _rID = rID_ + 1;
1441         
1442     //     round_[_rID].pot = round_[_rID].pot.add(msg.value);
1443     //     emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1444     // }
1445     
1446     /**
1447      * @dev distributes eth based on fees to gen and pot
1448      */
1449     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1450         private
1451         returns(F3Ddatasets.EventReturns)
1452     {
1453         // calculate gen share
1454         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1455         
1456         // toss 0% into airdrop pot 
1457         uint256 _air = 0; // (_eth / 100);
1458         airDropPot_ = airDropPot_.add(_air);
1459         
1460         // // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1461         // _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1462 
1463         // calculate pot 
1464         uint256 _pot = (_eth.mul(20)) / 100; //_eth.sub(_gen);
1465         
1466         // distribute gen share (thats what updateMasks() does) and adjust
1467         // balances for dust.
1468         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1469         if (_dust > 0)
1470             _gen = _gen.sub(_dust);
1471         
1472         // add eth to pot
1473         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1474         
1475         // set up event data
1476         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1477         _eventData_.potAmount = _pot;
1478         
1479         return(_eventData_);
1480     }
1481 
1482     /**
1483      * @dev updates masks for round and player when keys are bought
1484      * @return dust left over 
1485      */
1486     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1487         private
1488         returns(uint256)
1489     {
1490         /* MASKING NOTES
1491             earnings masks are a tricky thing for people to wrap their minds around.
1492             the basic thing to understand here.  is were going to have a global
1493             tracker based on profit per share for each round, that increases in
1494             relevant proportion to the increase in share supply.
1495             
1496             the player will have an additional mask that basically says "based
1497             on the rounds mask, my shares, and how much i've already withdrawn,
1498             how much is still owed to me?"
1499         */
1500         
1501         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1502         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1503         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1504             
1505         // calculate player earning from their own buy (only based on the keys
1506         // they just bought).  & update player earnings mask
1507         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1508         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1509         
1510         // calculate & return dust
1511         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1512     }
1513     
1514     /**
1515      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1516      * @return earnings in wei format
1517      */
1518     function withdrawEarnings(uint256 _pID)
1519         private
1520         returns(uint256)
1521     {
1522         // update gen vault
1523         updateGenVault(_pID, plyr_[_pID].lrnd);
1524         
1525         // from vaults 
1526         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1527         if (_earnings > 0)
1528         {
1529             plyr_[_pID].win = 0;
1530             plyr_[_pID].gen = 0;
1531             plyr_[_pID].aff = 0;
1532         }
1533 
1534         return(_earnings);
1535     }
1536     
1537     /**
1538      * @dev prepares compression data and fires event for buy or reload tx's
1539      */
1540     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1541         private
1542     {
1543         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1544         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1545         
1546         emit F3Devents.onEndTx
1547         (
1548             _eventData_.compressedData,
1549             _eventData_.compressedIDs,
1550             plyr_[_pID].name,
1551             msg.sender,
1552             _eth,
1553             _keys,
1554             _eventData_.winnerAddr,
1555             _eventData_.winnerName,
1556             _eventData_.amountWon,
1557             _eventData_.newPot,
1558             _eventData_.P3DAmount,
1559             _eventData_.genAmount,
1560             _eventData_.potAmount,
1561             airDropPot_
1562         );
1563     }
1564 //==============================================================================
1565 //    (~ _  _    _._|_    .
1566 //    _)(/_(_|_|| | | \/  .
1567 //====================/=========================================================
1568     /** upon contract deploy, it will be deactivated.  this is a one time
1569      * use function that will activate the contract.  we do this so devs 
1570      * have time to set things up on the web end                            **/
1571     bool public activated_ = false;
1572     function activate()
1573         public
1574     {
1575         // only team just can activate 
1576         // require(
1577         //     msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1578         //     msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1579         //     msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1580         //     msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1581 		// 	msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1582         //     "only team just can activate"
1583         // );
1584         require(msg.sender == god, "only team just can activate");
1585 
1586 		// // make sure that its been linked.
1587         // require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1588         
1589         // can only be ran once
1590         require(activated_ == false, "fomo3d already activated");
1591         
1592         // activate the contract 
1593         activated_ = true;
1594         
1595         // lets start first round
1596 		rID_ = 1;
1597         round_[1].strt = now + rndExtra_ - rndGap_;
1598         round_[1].end = now + rndInit_ + rndExtra_;
1599     }
1600     // function setOtherFomo(address _otherF3D)
1601     //     public
1602     // {
1603     //     // only team just can activate 
1604     //     require(
1605     //         msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1606     //         msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1607     //         msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1608     //         msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1609 	// 		msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1610     //         "only team just can activate"
1611     //     );
1612 
1613     //     // make sure that it HASNT yet been linked.
1614     //     require(address(otherF3D_) == address(0), "silly dev, you already did that");
1615         
1616     //     // set up other fomo3d (fast or long) for pot swap
1617     //     otherF3D_ = otherFoMo3D(_otherF3D);
1618     // }
1619 }
1620 
1621 //==============================================================================
1622 //   __|_ _    __|_ _  .
1623 //  _\ | | |_|(_ | _\  .
1624 //==============================================================================
1625 library F3Ddatasets {
1626     //compressedData key
1627     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1628         // 0 - new player (bool)
1629         // 1 - joined round (bool)
1630         // 2 - new  leader (bool)
1631         // 3-5 - air drop tracker (uint 0-999)
1632         // 6-16 - round end time
1633         // 17 - winnerTeam
1634         // 18 - 28 timestamp 
1635         // 29 - team
1636         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1637         // 31 - airdrop happened bool
1638         // 32 - airdrop tier 
1639         // 33 - airdrop amount won
1640     //compressedIDs key
1641     // [77-52][51-26][25-0]
1642         // 0-25 - pID 
1643         // 26-51 - winPID
1644         // 52-77 - rID
1645     struct EventReturns {
1646         uint256 compressedData;
1647         uint256 compressedIDs;
1648         address winnerAddr;         // winner address
1649         bytes32 winnerName;         // winner name
1650         uint256 amountWon;          // amount won
1651         uint256 newPot;             // amount in new pot
1652         uint256 P3DAmount;          // amount distributed to p3d
1653         uint256 genAmount;          // amount distributed to gen
1654         uint256 potAmount;          // amount added to pot
1655     }
1656     struct Player {
1657         address addr;   // player address
1658         bytes32 name;   // player name
1659         uint256 win;    // winnings vault
1660         uint256 gen;    // general vault
1661         uint256 aff;    // affiliate vault
1662         uint256 lrnd;   // last round played
1663         uint256 laff;   // last affiliate id used
1664     }
1665     struct PlayerRounds {
1666         uint256 eth;    // eth player has added to round (used for eth limiter)
1667         uint256 keys;   // keys
1668         uint256 mask;   // player mask 
1669         uint256 ico;    // ICO phase investment
1670     }
1671     struct Round {
1672         uint256 plyr;   // pID of player in lead
1673         uint256 team;   // tID of team in lead
1674         uint256 end;    // time ends/ended
1675         bool ended;     // has round end function been ran
1676         uint256 strt;   // time round started
1677         uint256 keys;   // keys
1678         uint256 eth;    // total eth in
1679         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1680         uint256 mask;   // global mask
1681         uint256 ico;    // total eth sent in during ICO phase
1682         uint256 icoGen; // total eth for gen during ICO phase
1683         uint256 icoAvg; // average key price for ICO phase
1684     }
1685     struct TeamFee {
1686         uint256 gen;    // % of buy in thats paid to key holders of current round
1687         uint256 p3d;    // % of buy in thats paid to p3d holders
1688     }
1689     struct PotSplit {
1690         uint256 gen;    // % of pot thats paid to key holders of current round
1691         uint256 p3d;    // % of pot thats paid to p3d holders
1692     }
1693 }
1694 
1695 //==============================================================================
1696 //  |  _      _ _ | _  .
1697 //  |<(/_\/  (_(_||(_  .
1698 //=======/======================================================================
1699 library F3DKeysCalcLong {
1700     using SafeMath for *;
1701     /**
1702      * @dev calculates number of keys received given X eth 
1703      * @param _curEth current amount of eth in contract 
1704      * @param _newEth eth being spent
1705      * @return amount of ticket purchased
1706      */
1707     function keysRec(uint256 _curEth, uint256 _newEth)
1708         internal
1709         pure
1710         returns (uint256)
1711     {
1712         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1713     }
1714     
1715     /**
1716      * @dev calculates amount of eth received if you sold X keys 
1717      * @param _curKeys current amount of keys that exist 
1718      * @param _sellKeys amount of keys you wish to sell
1719      * @return amount of eth received
1720      */
1721     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1722         internal
1723         pure
1724         returns (uint256)
1725     {
1726         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1727     }
1728 
1729     /**
1730      * @dev calculates how many keys would exist with given an amount of eth
1731      * @param _eth eth "in contract"
1732      * @return number of keys that would exist
1733      */
1734     function keys(uint256 _eth) 
1735         internal
1736         pure
1737         returns(uint256)
1738     {
1739         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1740     }
1741     
1742     /**
1743      * @dev calculates how much eth would be in contract given a number of keys
1744      * @param _keys number of keys "in contract" 
1745      * @return eth that would exists
1746      */
1747     function eth(uint256 _keys) 
1748         internal
1749         pure
1750         returns(uint256)  
1751     {
1752         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1753     }
1754 }
1755 
1756 //==============================================================================
1757 //  . _ _|_ _  _ |` _  _ _  _  .
1758 //  || | | (/_| ~|~(_|(_(/__\  .
1759 //==============================================================================
1760 // interface otherFoMo3D {
1761 //     function potSwap() external payable;
1762 // }
1763 
1764 interface F3DexternalSettingsInterface {
1765     function getFastGap() external returns(uint256);
1766     function getLongGap() external returns(uint256);
1767     function getFastExtra() external returns(uint256);
1768     function getLongExtra() external returns(uint256);
1769 }
1770 
1771 // interface DiviesInterface {
1772 //     function deposit() external payable;
1773 // }
1774 
1775 // interface JIincForwarderInterface {
1776 //     function deposit() external payable returns(bool);
1777 //     function status() external view returns(address, address, bool);
1778 //     function startMigration(address _newCorpBank) external returns(bool);
1779 //     function cancelMigration() external returns(bool);
1780 //     function finishMigration() external returns(bool);
1781 //     function setup(address _firstCorpBank) external;
1782 // }
1783 
1784 interface PlayerBookInterface {
1785     function getPlayerID(address _addr) external returns (uint256);
1786     function getPlayerName(uint256 _pID) external view returns (bytes32);
1787     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1788     function getPlayerAddr(uint256 _pID) external view returns (address);
1789     function getNameFee() external view returns (uint256);
1790     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1791     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1792     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1793 }
1794 
1795 
1796 library NameFilter {
1797     /**
1798      * @dev filters name strings
1799      * -converts uppercase to lower case.  
1800      * -makes sure it does not start/end with a space
1801      * -makes sure it does not contain multiple spaces in a row
1802      * -cannot be only numbers
1803      * -cannot start with 0x 
1804      * -restricts characters to A-Z, a-z, 0-9, and space.
1805      * @return reprocessed string in bytes32 format
1806      */
1807     function nameFilter(string _input)
1808         internal
1809         pure
1810         returns(bytes32)
1811     {
1812         bytes memory _temp = bytes(_input);
1813         uint256 _length = _temp.length;
1814         
1815         //sorry limited to 32 characters
1816         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1817         // make sure it doesnt start with or end with space
1818         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1819         // make sure first two characters are not 0x
1820         if (_temp[0] == 0x30)
1821         {
1822             require(_temp[1] != 0x78, "string cannot start with 0x");
1823             require(_temp[1] != 0x58, "string cannot start with 0X");
1824         }
1825         
1826         // create a bool to track if we have a non number character
1827         bool _hasNonNumber;
1828         
1829         // convert & check
1830         for (uint256 i = 0; i < _length; i++)
1831         {
1832             // if its uppercase A-Z
1833             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1834             {
1835                 // convert to lower case a-z
1836                 _temp[i] = byte(uint(_temp[i]) + 32);
1837                 
1838                 // we have a non number
1839                 if (_hasNonNumber == false)
1840                     _hasNonNumber = true;
1841             } else {
1842                 require
1843                 (
1844                     // require character is a space
1845                     _temp[i] == 0x20 || 
1846                     // OR lowercase a-z
1847                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1848                     // or 0-9
1849                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1850                     "string contains invalid characters"
1851                 );
1852                 // make sure theres not 2x spaces in a row
1853                 if (_temp[i] == 0x20)
1854                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1855                 
1856                 // see if we have a character other than a number
1857                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1858                     _hasNonNumber = true;    
1859             }
1860         }
1861         
1862         require(_hasNonNumber == true, "string cannot be only numbers");
1863         
1864         bytes32 _ret;
1865         assembly {
1866             _ret := mload(add(_temp, 32))
1867         }
1868         return (_ret);
1869     }
1870 }
1871 
1872 /**
1873  * @title SafeMath v0.1.9
1874  * @dev Math operations with safety checks that throw on error
1875  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1876  * - added sqrt
1877  * - added sq
1878  * - added pwr 
1879  * - changed asserts to requires with error log outputs
1880  * - removed div, its useless
1881  */
1882 library SafeMath {
1883     
1884     /**
1885     * @dev Multiplies two numbers, throws on overflow.
1886     */
1887     function mul(uint256 a, uint256 b) 
1888         internal 
1889         pure 
1890         returns (uint256 c) 
1891     {
1892         if (a == 0) {
1893             return 0;
1894         }
1895         c = a * b;
1896         require(c / a == b, "SafeMath mul failed");
1897         return c;
1898     }
1899 
1900     /**
1901     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1902     */
1903     function sub(uint256 a, uint256 b)
1904         internal
1905         pure
1906         returns (uint256) 
1907     {
1908         require(b <= a, "SafeMath sub failed");
1909         return a - b;
1910     }
1911 
1912     /**
1913     * @dev Adds two numbers, throws on overflow.
1914     */
1915     function add(uint256 a, uint256 b)
1916         internal
1917         pure
1918         returns (uint256 c) 
1919     {
1920         c = a + b;
1921         require(c >= a, "SafeMath add failed");
1922         return c;
1923     }
1924     
1925     /**
1926      * @dev gives square root of given x.
1927      */
1928     function sqrt(uint256 x)
1929         internal
1930         pure
1931         returns (uint256 y) 
1932     {
1933         uint256 z = ((add(x,1)) / 2);
1934         y = x;
1935         while (z < y) 
1936         {
1937             y = z;
1938             z = ((add((x / z),z)) / 2);
1939         }
1940     }
1941     
1942     /**
1943      * @dev gives square. multiplies x by x
1944      */
1945     function sq(uint256 x)
1946         internal
1947         pure
1948         returns (uint256)
1949     {
1950         return (mul(x,x));
1951     }
1952     
1953     /**
1954      * @dev x to the power of y 
1955      */
1956     function pwr(uint256 x, uint256 y)
1957         internal 
1958         pure 
1959         returns (uint256)
1960     {
1961         if (x==0)
1962             return (0);
1963         else if (y==0)
1964             return (1);
1965         else 
1966         {
1967             uint256 z = x;
1968             for (uint256 i=1; i < y; i++)
1969                 z = mul(z,x);
1970             return (z);
1971         }
1972     }
1973 }