1 pragma solidity ^0.4.24;
2 
3 
4 //==============================================================================
5 //     _    _  _ _|_ _  .
6 //    (/_\/(/_| | | _\  .
7 //==============================================================================
8 contract F3Devents {
9     // fired whenever a player registers a name
10     event onNewName
11     (
12         uint256 indexed playerID,
13         address indexed playerAddress,
14         bytes32 indexed playerName,
15         bool isNewPlayer,
16         uint256 affiliateID,
17         address affiliateAddress,
18         bytes32 affiliateName,
19         uint256 amountPaid,
20         uint256 timeStamp
21     );
22     
23     // fired at end of buy or reload
24     event onEndTx
25     (
26         uint256 compressedData,     
27         uint256 compressedIDs,      
28         bytes32 playerName,
29         address playerAddress,
30         uint256 ethIn,
31         uint256 keysBought,
32         address winnerAddr,
33         bytes32 winnerName,
34         uint256 amountWon,
35         uint256 newPot,
36         uint256 P3DAmount,
37         uint256 genAmount,
38         uint256 potAmount,
39         uint256 airDropPot
40     );
41     
42 	// fired whenever theres a withdraw
43     event onWithdraw
44     (
45         uint256 indexed playerID,
46         address playerAddress,
47         bytes32 playerName,
48         uint256 ethOut,
49         uint256 timeStamp
50     );
51     
52     // fired whenever a withdraw forces end round to be ran
53     event onWithdrawAndDistribute
54     (
55         address playerAddress,
56         bytes32 playerName,
57         uint256 ethOut,
58         uint256 compressedData,
59         uint256 compressedIDs,
60         address winnerAddr,
61         bytes32 winnerName,
62         uint256 amountWon,
63         uint256 newPot,
64         uint256 P3DAmount,
65         uint256 genAmount
66     );
67     
68     // (fomo3d long only) fired whenever a player tries a buy after round timer 
69     // hit zero, and causes end round to be ran.
70     event onBuyAndDistribute
71     (
72         address playerAddress,
73         bytes32 playerName,
74         uint256 ethIn,
75         uint256 compressedData,
76         uint256 compressedIDs,
77         address winnerAddr,
78         bytes32 winnerName,
79         uint256 amountWon,
80         uint256 newPot,
81         uint256 P3DAmount,
82         uint256 genAmount
83     );
84     
85     // (fomo3d long only) fired whenever a player tries a reload after round timer 
86     // hit zero, and causes end round to be ran.
87     event onReLoadAndDistribute
88     (
89         address playerAddress,
90         bytes32 playerName,
91         uint256 compressedData,
92         uint256 compressedIDs,
93         address winnerAddr,
94         bytes32 winnerName,
95         uint256 amountWon,
96         uint256 newPot,
97         uint256 P3DAmount,
98         uint256 genAmount
99     );
100     
101     // fired whenever an affiliate is paid
102     event onAffiliatePayout
103     (
104         uint256 indexed affiliateID,
105         address affiliateAddress,
106         bytes32 affiliateName,
107         uint256 indexed roundID,
108         uint256 indexed buyerID,
109         uint256 amount,
110         uint256 timeStamp
111     );
112     
113     // received pot swap deposit
114     event onPotSwapDeposit
115     (
116         uint256 roundID,
117         uint256 amountAddedToPot
118     );
119 }
120 
121 //==============================================================================
122 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
123 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
124 //====================================|=========================================
125 
126 contract modularLong is F3Devents {}
127 
128 contract NOPONZI is modularLong {
129     using SafeMath for *;
130     using NameFilter for string;
131     using F3DKeysCalcLong for uint256;
132 	
133 	otherFoMo3D private otherF3D_;
134     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x80526AA5f9A2905809Aa8E1b861eca7895982c70);
135 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x01308cFf027cC3e130fB1c32114e89179b6c36A7);
136     
137 //==============================================================================
138 //     _ _  _  |`. _     _ _ |_ | _  _  .
139 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
140 //=================_|===========================================================
141     string constant public name = "NOPONZI";
142     string constant public symbol = "NOPONZI";
143     address public owner;
144     uint256 private rndExtra_ = 10 minutes;     // length of the very first ICO 
145     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
146     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
147     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
148     uint256 constant private rndMax_ = 24 hours;                 // max length a round timer can be
149 //==============================================================================
150 //     _| _ _|_ _    _ _ _|_    _   .
151 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
152 //=============================|================================================
153 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
154     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
155     uint256 public rID_;    // round id number / total rounds that have happened
156 //****************
157 // PLAYER DATA 
158 //****************
159     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
160     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
161     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
162     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
163     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
164 //****************
165 // ROUND DATA 
166 //****************
167     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
168     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
169 //****************
170 // TEAM FEE DATA 
171 //****************
172     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
173     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
174 //==============================================================================
175 //     _ _  _  __|_ _    __|_ _  _  .
176 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
177 //==============================================================================
178     constructor()
179         public
180     {
181 		owner=0xAE81cCb079B49f9149E54235802ad22a83A6e0dF;
182 
183 		// Team allocation percentages
184         // (F3D, P3D) + (Pot , Referrals, Community)
185             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
186         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
187         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
188         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
189         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
190         
191         // how to split up the final pot based on which team was picked
192         // (F3D, P3D)
193         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
194         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
195         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
196         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
197 	}
198 //==============================================================================
199 //     _ _  _  _|. |`. _  _ _  .
200 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
201 //==============================================================================
202     /**
203      * @dev used to make sure no one can interact with contract until it has 
204      * been activated. 
205      */
206     modifier isActivated() {
207         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
208         _;
209     }
210     
211     /**
212      * @dev prevents contracts from interacting with fomo3d 
213      */
214     modifier isHuman() {
215         address _addr = msg.sender;
216         uint256 _codeLength;
217         
218         assembly {_codeLength := extcodesize(_addr)}
219         require(_codeLength == 0, "sorry humans only");
220         _;
221     }
222 
223     /**
224      * @dev sets boundaries for incoming tx 
225      */
226     modifier isWithinLimits(uint256 _eth) {
227         require(_eth >= 1000000000, "pocket lint: not a valid currency");
228         require(_eth <= 100000000000000000000000, "no vitalik, no");
229         _;    
230     }
231     
232 //==============================================================================
233 //     _    |_ |. _   |`    _  __|_. _  _  _  .
234 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
235 //====|=========================================================================
236     /**
237      * @dev emergency buy uses last stored affiliate ID and team snek
238      */
239     function()
240         isActivated()
241         isHuman()
242         isWithinLimits(msg.value)
243         public
244         payable
245     {
246         // set up our tx event data and determine if player is new or not
247         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
248             
249         // fetch player id
250         uint256 _pID = pIDxAddr_[msg.sender];
251         
252         // buy core 
253         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
254     }
255     
256     /**
257      * @dev converts all incoming ethereum to keys.
258      * -functionhash- 0x8f38f309 (using ID for affiliate)
259      * -functionhash- 0x98a0871d (using address for affiliate)
260      * -functionhash- 0xa65b37a1 (using name for affiliate)
261      * @param _affCode the ID/address/name of the player who gets the affiliate fee
262      * @param _team what team is the player playing for?
263      */
264     function buyXid(uint256 _affCode, uint256 _team)
265         isActivated()
266         isHuman()
267         isWithinLimits(msg.value)
268         public
269         payable
270     {
271         // set up our tx event data and determine if player is new or not
272         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
273         
274         // fetch player id
275         uint256 _pID = pIDxAddr_[msg.sender];
276         
277         // manage affiliate residuals
278         // if no affiliate code was given or player tried to use their own, lolz
279         if (_affCode == 0 || _affCode == _pID)
280         {
281             // use last stored affiliate code 
282             _affCode = plyr_[_pID].laff;
283             
284         // if affiliate code was given & its not the same as previously stored 
285         } else if (_affCode != plyr_[_pID].laff) {
286             // update last affiliate 
287             plyr_[_pID].laff = _affCode;
288         }
289         
290         // verify a valid team was selected
291         _team = verifyTeam(_team);
292         
293         // buy core 
294         buyCore(_pID, _affCode, _team, _eventData_);
295     }
296     
297     function buyXaddr(address _affCode, uint256 _team)
298         isActivated()
299         isHuman()
300         isWithinLimits(msg.value)
301         public
302         payable
303     {
304         // set up our tx event data and determine if player is new or not
305         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
306         
307         // fetch player id
308         uint256 _pID = pIDxAddr_[msg.sender];
309         
310         // manage affiliate residuals
311         uint256 _affID;
312         // if no affiliate code was given or player tried to use their own, lolz
313         if (_affCode == address(0) || _affCode == msg.sender)
314         {
315             // use last stored affiliate code
316             _affID = plyr_[_pID].laff;
317         
318         // if affiliate code was given    
319         } else {
320             // get affiliate ID from aff Code 
321             _affID = pIDxAddr_[_affCode];
322             
323             // if affID is not the same as previously stored 
324             if (_affID != plyr_[_pID].laff)
325             {
326                 // update last affiliate
327                 plyr_[_pID].laff = _affID;
328             }
329         }
330         
331         // verify a valid team was selected
332         _team = verifyTeam(_team);
333         
334         // buy core 
335         buyCore(_pID, _affID, _team, _eventData_);
336     }
337     
338     function buyXname(bytes32 _affCode, uint256 _team)
339         isActivated()
340         isHuman()
341         isWithinLimits(msg.value)
342         public
343         payable
344     {
345         // set up our tx event data and determine if player is new or not
346         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
347         
348         // fetch player id
349         uint256 _pID = pIDxAddr_[msg.sender];
350         
351         // manage affiliate residuals
352         uint256 _affID;
353         // if no affiliate code was given or player tried to use their own, lolz
354         if (_affCode == '' || _affCode == plyr_[_pID].name)
355         {
356             // use last stored affiliate code
357             _affID = plyr_[_pID].laff;
358         
359         // if affiliate code was given
360         } else {
361             // get affiliate ID from aff Code
362             _affID = pIDxName_[_affCode];
363             
364             // if affID is not the same as previously stored
365             if (_affID != plyr_[_pID].laff)
366             {
367                 // update last affiliate
368                 plyr_[_pID].laff = _affID;
369             }
370         }
371         
372         // verify a valid team was selected
373         _team = verifyTeam(_team);
374         
375         // buy core 
376         buyCore(_pID, _affID, _team, _eventData_);
377     }
378     
379     /**
380      * @dev essentially the same as buy, but instead of you sending ether 
381      * from your wallet, it uses your unwithdrawn earnings.
382      * -functionhash- 0x349cdcac (using ID for affiliate)
383      * -functionhash- 0x82bfc739 (using address for affiliate)
384      * -functionhash- 0x079ce327 (using name for affiliate)
385      * @param _affCode the ID/address/name of the player who gets the affiliate fee
386      * @param _team what team is the player playing for?
387      * @param _eth amount of earnings to use (remainder returned to gen vault)
388      */
389     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
390         isActivated()
391         isHuman()
392         isWithinLimits(_eth)
393         public
394     {
395         // set up our tx event data
396         F3Ddatasets.EventReturns memory _eventData_;
397         
398         // fetch player ID
399         uint256 _pID = pIDxAddr_[msg.sender];
400         
401         // manage affiliate residuals
402         // if no affiliate code was given or player tried to use their own, lolz
403         if (_affCode == 0 || _affCode == _pID)
404         {
405             // use last stored affiliate code 
406             _affCode = plyr_[_pID].laff;
407             
408         // if affiliate code was given & its not the same as previously stored 
409         } else if (_affCode != plyr_[_pID].laff) {
410             // update last affiliate 
411             plyr_[_pID].laff = _affCode;
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
449                 // update last affiliate
450                 plyr_[_pID].laff = _affID;
451             }
452         }
453         
454         // verify a valid team was selected
455         _team = verifyTeam(_team);
456         
457         // reload core
458         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
459     }
460     
461     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
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
494         // verify a valid team was selected
495         _team = verifyTeam(_team);
496         
497         // reload core
498         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
499     }
500 
501     /**
502      * @dev withdraws all of your earnings.
503      * -functionhash- 0x3ccfd60b
504      */
505     function withdraw()
506         isActivated()
507         isHuman()
508         public
509     {
510         // setup local rID 
511         uint256 _rID = rID_;
512         
513         // grab time
514         uint256 _now = now;
515         
516         // fetch player ID
517         uint256 _pID = pIDxAddr_[msg.sender];
518         
519         // setup temp var for player eth
520         uint256 _eth;
521         
522         // check to see if round has ended and no one has run round end yet
523         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
524         {
525             // set up our tx event data
526             F3Ddatasets.EventReturns memory _eventData_;
527             
528             // end the round (distributes pot)
529 			round_[_rID].ended = true;
530             _eventData_ = endRound(_eventData_);
531             
532 			// get their earnings
533             _eth = withdrawEarnings(_pID);
534             
535             // gib moni
536             if (_eth > 0)
537                 plyr_[_pID].addr.transfer(_eth);    
538             
539             // build event data
540             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
541             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
542             
543             // fire withdraw and distribute event
544             emit F3Devents.onWithdrawAndDistribute
545             (
546                 msg.sender, 
547                 plyr_[_pID].name, 
548                 _eth, 
549                 _eventData_.compressedData, 
550                 _eventData_.compressedIDs, 
551                 _eventData_.winnerAddr, 
552                 _eventData_.winnerName, 
553                 _eventData_.amountWon, 
554                 _eventData_.newPot, 
555                 _eventData_.P3DAmount, 
556                 _eventData_.genAmount
557             );
558             
559         // in any other situation
560         } else {
561             // get their earnings
562             _eth = withdrawEarnings(_pID);
563             
564             // gib moni
565             if (_eth > 0)
566                 plyr_[_pID].addr.transfer(_eth);
567             
568             // fire withdraw event
569             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
570         }
571     }
572     
573     /**
574      * @dev use these to register names.  they are just wrappers that will send the
575      * registration requests to the PlayerBook contract.  So registering here is the 
576      * same as registering there.  UI will always display the last name you registered.
577      * but you will still own all previously registered names to use as affiliate 
578      * links.
579      * - must pay a registration fee.
580      * - name must be unique
581      * - names will be converted to lowercase
582      * - name cannot start or end with a space 
583      * - cannot have more than 1 space in a row
584      * - cannot be only numbers
585      * - cannot start with 0x 
586      * - name must be at least 1 char
587      * - max length of 32 characters long
588      * - allowed characters: a-z, 0-9, and space
589      * -functionhash- 0x921dec21 (using ID for affiliate)
590      * -functionhash- 0x3ddd4698 (using address for affiliate)
591      * -functionhash- 0x685ffd83 (using name for affiliate)
592      * @param _nameString players desired name
593      * @param _affCode affiliate ID, address, or name of who referred you
594      * @param _all set to true if you want this to push your info to all games 
595      * (this might cost a lot of gas)
596      */
597     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
598         isHuman()
599         public
600         payable
601     {
602         bytes32 _name = _nameString.nameFilter();
603         address _addr = msg.sender;
604         uint256 _paid = msg.value;
605         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
606         
607         uint256 _pID = pIDxAddr_[_addr];
608         
609         // fire event
610         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
611     }
612     
613     function registerNameXaddr(string _nameString, address _affCode, bool _all)
614         isHuman()
615         public
616         payable
617     {
618         bytes32 _name = _nameString.nameFilter();
619         address _addr = msg.sender;
620         uint256 _paid = msg.value;
621         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
622         
623         uint256 _pID = pIDxAddr_[_addr];
624         
625         // fire event
626         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
627     }
628     
629     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
630         isHuman()
631         public
632         payable
633     {
634         bytes32 _name = _nameString.nameFilter();
635         address _addr = msg.sender;
636         uint256 _paid = msg.value;
637         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
638         
639         uint256 _pID = pIDxAddr_[_addr];
640         
641         // fire event
642         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
643     }
644 //==============================================================================
645 //     _  _ _|__|_ _  _ _  .
646 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
647 //=====_|=======================================================================
648     /**
649      * @dev return the price buyer will pay for next 1 individual key.
650      * -functionhash- 0x018a25e8
651      * @return price for next key bought (in wei format)
652      */
653     function getBuyPrice()
654         public 
655         view 
656         returns(uint256)
657     {  
658         // setup local rID
659         uint256 _rID = rID_;
660         
661         // grab time
662         uint256 _now = now;
663         
664         // are we in a round?
665         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
666             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
667         else // rounds over.  need price for new round
668             return ( 75000000000000 ); // init
669     }
670     
671     /**
672      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
673      * provider
674      * -functionhash- 0xc7e284b8
675      * @return time left in seconds
676      */
677     function getTimeLeft()
678         public
679         view
680         returns(uint256)
681     {
682         // setup local rID
683         uint256 _rID = rID_;
684         
685         // grab time
686         uint256 _now = now;
687         
688         if (_now < round_[_rID].end)
689             if (_now > round_[_rID].strt + rndGap_)
690                 return( (round_[_rID].end).sub(_now) );
691             else
692                 return( (round_[_rID].strt + rndGap_).sub(_now) );
693         else
694             return(0);
695     }
696     
697     /**
698      * @dev returns player earnings per vaults 
699      * -functionhash- 0x63066434
700      * @return winnings vault
701      * @return general vault
702      * @return affiliate vault
703      */
704     function getPlayerVaults(uint256 _pID)
705         public
706         view
707         returns(uint256 ,uint256, uint256)
708     {
709         // setup local rID
710         uint256 _rID = rID_;
711         
712         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
713         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
714         {
715             // if player is winner 
716             if (round_[_rID].plyr == _pID)
717             {
718                 return
719                 (
720                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
721                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
722                     plyr_[_pID].aff
723                 );
724             // if player is not the winner
725             } else {
726                 return
727                 (
728                     plyr_[_pID].win,
729                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
730                     plyr_[_pID].aff
731                 );
732             }
733             
734         // if round is still going on, or round has ended and round end has been ran
735         } else {
736             return
737             (
738                 plyr_[_pID].win,
739                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
740                 plyr_[_pID].aff
741             );
742         }
743     }
744     
745     /**
746      * solidity hates stack limits.  this lets us avoid that hate 
747      */
748     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
749         private
750         view
751         returns(uint256)
752     {
753         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
754     }
755     
756     /**
757      * @dev returns all current round info needed for front end
758      * -functionhash- 0x747dff42
759      * @return eth invested during ICO phase
760      * @return round id 
761      * @return total keys for round 
762      * @return time round ends
763      * @return time round started
764      * @return current pot 
765      * @return current team ID & player ID in lead 
766      * @return current player in leads address 
767      * @return current player in leads name
768      * @return whales eth in for round
769      * @return bears eth in for round
770      * @return sneks eth in for round
771      * @return bulls eth in for round
772      * @return airdrop tracker # & airdrop pot
773      */
774     function getCurrentRoundInfo()
775         public
776         view
777         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
778     {
779         // setup local rID
780         uint256 _rID = rID_;
781         
782         return
783         (
784             round_[_rID].ico,               //0
785             _rID,                           //1
786             round_[_rID].keys,              //2
787             round_[_rID].end,               //3
788             round_[_rID].strt,              //4
789             round_[_rID].pot,               //5
790             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
791             plyr_[round_[_rID].plyr].addr,  //7
792             plyr_[round_[_rID].plyr].name,  //8
793             rndTmEth_[_rID][0],             //9
794             rndTmEth_[_rID][1],             //10
795             rndTmEth_[_rID][2],             //11
796             rndTmEth_[_rID][3],             //12
797             airDropTracker_ + (airDropPot_ * 1000)              //13
798         );
799     }
800 
801     /**
802      * @dev returns player info based on address.  if no address is given, it will 
803      * use msg.sender 
804      * -functionhash- 0xee0b5d8b
805      * @param _addr address of the player you want to lookup 
806      * @return player ID 
807      * @return player name
808      * @return keys owned (current round)
809      * @return winnings vault
810      * @return general vault 
811      * @return affiliate vault 
812 	 * @return player round eth
813      */
814     function getPlayerInfoByAddress(address _addr)
815         public 
816         view 
817         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
818     {
819         // setup local rID
820         uint256 _rID = rID_;
821         
822         if (_addr == address(0))
823         {
824             _addr == msg.sender;
825         }
826         uint256 _pID = pIDxAddr_[_addr];
827         
828         return
829         (
830             _pID,                               //0
831             plyr_[_pID].name,                   //1
832             plyrRnds_[_pID][_rID].keys,         //2
833             plyr_[_pID].win,                    //3
834             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
835             plyr_[_pID].aff,                    //5
836             plyrRnds_[_pID][_rID].eth           //6
837         );
838     }
839 
840 //==============================================================================
841 //     _ _  _ _   | _  _ . _  .
842 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
843 //=====================_|=======================================================
844     /**
845      * @dev logic runs whenever a buy order is executed.  determines how to handle 
846      * incoming eth depending on if we are in an active round or not
847      */
848     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
849         private
850     {
851         // setup local rID
852         uint256 _rID = rID_;
853         
854         // grab time
855         uint256 _now = now;
856         
857         // if round is active
858         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
859         {
860             // call core 
861             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
862         
863         // if round is not active     
864         } else {
865             // check to see if end round needs to be ran
866             if (_now > round_[_rID].end && round_[_rID].ended == false) 
867             {
868                 // end the round (distributes pot) & start new round
869 			    round_[_rID].ended = true;
870                 _eventData_ = endRound(_eventData_);
871                 
872                 // build event data
873                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
874                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
875                 
876                 // fire buy and distribute event 
877                 emit F3Devents.onBuyAndDistribute
878                 (
879                     msg.sender, 
880                     plyr_[_pID].name, 
881                     msg.value, 
882                     _eventData_.compressedData, 
883                     _eventData_.compressedIDs, 
884                     _eventData_.winnerAddr, 
885                     _eventData_.winnerName, 
886                     _eventData_.amountWon, 
887                     _eventData_.newPot, 
888                     _eventData_.P3DAmount, 
889                     _eventData_.genAmount
890                 );
891             }
892             
893             // put eth in players vault 
894             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
895         }
896     }
897     
898     /**
899      * @dev logic runs whenever a reload order is executed.  determines how to handle 
900      * incoming eth depending on if we are in an active round or not 
901      */
902     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
903         private
904     {
905         // setup local rID
906         uint256 _rID = rID_;
907         
908         // grab time
909         uint256 _now = now;
910         
911         // if round is active
912         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
913         {
914             // get earnings from all vaults and return unused to gen vault
915             // because we use a custom safemath library.  this will throw if player 
916             // tried to spend more eth than they have.
917             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
918             
919             // call core 
920             core(_rID, _pID, _eth, _affID, _team, _eventData_);
921         
922         // if round is not active and end round needs to be ran   
923         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
924             // end the round (distributes pot) & start new round
925             round_[_rID].ended = true;
926             _eventData_ = endRound(_eventData_);
927                 
928             // build event data
929             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
930             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
931                 
932             // fire buy and distribute event 
933             emit F3Devents.onReLoadAndDistribute
934             (
935                 msg.sender, 
936                 plyr_[_pID].name, 
937                 _eventData_.compressedData, 
938                 _eventData_.compressedIDs, 
939                 _eventData_.winnerAddr, 
940                 _eventData_.winnerName, 
941                 _eventData_.amountWon, 
942                 _eventData_.newPot, 
943                 _eventData_.P3DAmount, 
944                 _eventData_.genAmount
945             );
946         }
947     }
948     
949     /**
950      * @dev this is the core logic for any buy/reload that happens while a round 
951      * is live.
952      */
953     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
954         private
955     {
956         // if player is new to round
957         if (plyrRnds_[_pID][_rID].keys == 0)
958             _eventData_ = managePlayer(_pID, _eventData_);
959         
960         // early round eth limiter 
961         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
962         {
963             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
964             uint256 _refund = _eth.sub(_availableLimit);
965             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
966             _eth = _availableLimit;
967         }
968         
969         // if eth left is greater than min eth allowed (sorry no pocket lint)
970         if (_eth > 1000000000) 
971         {
972             
973             // mint the new keys
974             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
975             
976             // if they bought at least 1 whole key
977             if (_keys >= 1000000000000000000)
978             {
979             updateTimer(_keys, _rID);
980 
981             // set new leaders
982             if (round_[_rID].plyr != _pID)
983                 round_[_rID].plyr = _pID;  
984             if (round_[_rID].team != _team)
985                 round_[_rID].team = _team; 
986             
987             // set the new leader bool to true
988             _eventData_.compressedData = _eventData_.compressedData + 100;
989         }
990             
991             // manage airdrops
992             if (_eth >= 100000000000000000)
993             {
994             airDropTracker_++;
995             if (airdrop() == true)
996             {
997                 // gib muni
998                 uint256 _prize;
999                 if (_eth >= 10000000000000000000)
1000                 {
1001                     // calculate prize and give it to winner
1002                     _prize = ((airDropPot_).mul(75)) / 100;
1003                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1004                     
1005                     // adjust airDropPot 
1006                     airDropPot_ = (airDropPot_).sub(_prize);
1007                     
1008                     // let event know a tier 3 prize was won 
1009                     _eventData_.compressedData += 300000000000000000000000000000000;
1010                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1011                     // calculate prize and give it to winner
1012                     _prize = ((airDropPot_).mul(50)) / 100;
1013                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1014                     
1015                     // adjust airDropPot 
1016                     airDropPot_ = (airDropPot_).sub(_prize);
1017                     
1018                     // let event know a tier 2 prize was won 
1019                     _eventData_.compressedData += 200000000000000000000000000000000;
1020                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1021                     // calculate prize and give it to winner
1022                     _prize = ((airDropPot_).mul(25)) / 100;
1023                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1024                     
1025                     // adjust airDropPot 
1026                     airDropPot_ = (airDropPot_).sub(_prize);
1027                     
1028                     // let event know a tier 3 prize was won 
1029                     _eventData_.compressedData += 300000000000000000000000000000000;
1030                 }
1031                 // set airdrop happened bool to true
1032                 _eventData_.compressedData += 10000000000000000000000000000000;
1033                 // let event know how much was won 
1034                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1035                 
1036                 // reset air drop tracker
1037                 airDropTracker_ = 0;
1038             }
1039         }
1040     
1041             // store the air drop tracker number (number of buys since last airdrop)
1042             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1043             
1044             // update player 
1045             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1046             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1047             
1048             // update round
1049             round_[_rID].keys = _keys.add(round_[_rID].keys);
1050             round_[_rID].eth = _eth.add(round_[_rID].eth);
1051             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1052     
1053             // distribute eth
1054             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1055             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1056             
1057             // call end tx function to fire end tx event.
1058 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1059         }
1060     }
1061 //==============================================================================
1062 //     _ _ | _   | _ _|_ _  _ _  .
1063 //    (_(_||(_|_||(_| | (_)| _\  .
1064 //==============================================================================
1065     /**
1066      * @dev calculates unmasked earnings (just calculates, does not update mask)
1067      * @return earnings in wei format
1068      */
1069     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1070         private
1071         view
1072         returns(uint256)
1073     {
1074         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1075     }
1076     
1077     /** 
1078      * @dev returns the amount of keys you would get given an amount of eth. 
1079      * -functionhash- 0xce89c80c
1080      * @param _rID round ID you want price for
1081      * @param _eth amount of eth sent in 
1082      * @return keys received 
1083      */
1084     function calcKeysReceived(uint256 _rID, uint256 _eth)
1085         public
1086         view
1087         returns(uint256)
1088     {
1089         // grab time
1090         uint256 _now = now;
1091         
1092         // are we in a round?
1093         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1094             return ( (round_[_rID].eth).keysRec(_eth) );
1095         else // rounds over.  need keys for new round
1096             return ( (_eth).keys() );
1097     }
1098     
1099     /** 
1100      * @dev returns current eth price for X keys.  
1101      * -functionhash- 0xcf808000
1102      * @param _keys number of keys desired (in 18 decimal format)
1103      * @return amount of eth needed to send
1104      */
1105     function iWantXKeys(uint256 _keys)
1106         public
1107         view
1108         returns(uint256)
1109     {
1110         // setup local rID
1111         uint256 _rID = rID_;
1112         
1113         // grab time
1114         uint256 _now = now;
1115         
1116         // are we in a round?
1117         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1118             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1119         else // rounds over.  need price for new round
1120             return ( (_keys).eth() );
1121     }
1122 //==============================================================================
1123 //    _|_ _  _ | _  .
1124 //     | (_)(_)|_\  .
1125 //==============================================================================
1126     /**
1127 	 * @dev receives name/player info from names contract 
1128      */
1129     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1130         external
1131     {
1132         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1133         if (pIDxAddr_[_addr] != _pID)
1134             pIDxAddr_[_addr] = _pID;
1135         if (pIDxName_[_name] != _pID)
1136             pIDxName_[_name] = _pID;
1137         if (plyr_[_pID].addr != _addr)
1138             plyr_[_pID].addr = _addr;
1139         if (plyr_[_pID].name != _name)
1140             plyr_[_pID].name = _name;
1141         if (plyr_[_pID].laff != _laff)
1142             plyr_[_pID].laff = _laff;
1143         if (plyrNames_[_pID][_name] == false)
1144             plyrNames_[_pID][_name] = true;
1145     }
1146     
1147     /**
1148      * @dev receives entire player name list 
1149      */
1150     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1151         external
1152     {
1153         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1154         if(plyrNames_[_pID][_name] == false)
1155             plyrNames_[_pID][_name] = true;
1156     }   
1157         
1158     /**
1159      * @dev gets existing or registers new pID.  use this when a player may be new
1160      * @return pID 
1161      */
1162     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1163         private
1164         returns (F3Ddatasets.EventReturns)
1165     {
1166         uint256 _pID = pIDxAddr_[msg.sender];
1167         // if player is new to this version of fomo3d
1168         if (_pID == 0)
1169         {
1170             // grab their player ID, name and last aff ID, from player names contract 
1171             _pID = PlayerBook.getPlayerID(msg.sender);
1172             bytes32 _name = PlayerBook.getPlayerName(_pID);
1173             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1174             
1175             // set up player account 
1176             pIDxAddr_[msg.sender] = _pID;
1177             plyr_[_pID].addr = msg.sender;
1178             
1179             if (_name != "")
1180             {
1181                 pIDxName_[_name] = _pID;
1182                 plyr_[_pID].name = _name;
1183                 plyrNames_[_pID][_name] = true;
1184             }
1185             
1186             if (_laff != 0 && _laff != _pID)
1187                 plyr_[_pID].laff = _laff;
1188             
1189             // set the new player bool to true
1190             _eventData_.compressedData = _eventData_.compressedData + 1;
1191         } 
1192         return (_eventData_);
1193     }
1194     
1195     /**
1196      * @dev checks to make sure user picked a valid team.  if not sets team 
1197      * to default (sneks)
1198      */
1199     function verifyTeam(uint256 _team)
1200         private
1201         pure
1202         returns (uint256)
1203     {
1204         if (_team < 0 || _team > 3)
1205             return(2);
1206         else
1207             return(_team);
1208     }
1209     
1210     /**
1211      * @dev decides if round end needs to be run & new round started.  and if 
1212      * player unmasked earnings from previously played rounds need to be moved.
1213      */
1214     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1215         private
1216         returns (F3Ddatasets.EventReturns)
1217     {
1218         // if player has played a previous round, move their unmasked earnings
1219         // from that round to gen vault.
1220         if (plyr_[_pID].lrnd != 0)
1221             updateGenVault(_pID, plyr_[_pID].lrnd);
1222             
1223         // update player's last round played
1224         plyr_[_pID].lrnd = rID_;
1225             
1226         // set the joined round bool to true
1227         _eventData_.compressedData = _eventData_.compressedData + 10;
1228         
1229         return(_eventData_);
1230     }
1231     
1232     /**
1233      * @dev ends the round. manages paying out winner/splitting up pot
1234      */
1235     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1236         private
1237         returns (F3Ddatasets.EventReturns)
1238     {
1239         // setup local rID
1240         uint256 _rID = rID_;
1241         
1242         // grab our winning player and team id's
1243         uint256 _winPID = round_[_rID].plyr;
1244         uint256 _winTID = round_[_rID].team;
1245         
1246         // grab our pot amount
1247         uint256 _pot = round_[_rID].pot;
1248         
1249         // calculate our winner share, community rewards, gen share, 
1250         // p3d share, and amount reserved for next pot 
1251         uint256 _win = (_pot.mul(48)) / 100;
1252         uint256 _com = (_pot / 50);
1253         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1254         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1255         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1256         
1257         // calculate ppt for round mask
1258         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1259         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1260         if (_dust > 0)
1261         {
1262             _gen = _gen.sub(_dust);
1263             _res = _res.add(_dust);
1264         }
1265         
1266         // pay our winner
1267         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1268         
1269         // community rewards
1270         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1271         {
1272             // This ensures Team Just cannot influence the outcome of FoMo3D with
1273             // bank migrations by breaking outgoing transactions.
1274             // Something we would never do. But that's not the point.
1275             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1276             // highest belief that everything we create should be trustless.
1277             // Team JUST, The name you shouldn't have to trust.
1278             _p3d = _p3d.add(_com);
1279             _com = 0;
1280         }
1281         
1282         // distribute gen portion to key holders
1283         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1284         
1285         // send share for p3d to divies
1286         //if (_p3d > 0)
1287           //  Divies.deposit.value(_p3d)();
1288           if (_p3d > 0)
1289             owner.transfer(_p3d);
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
1382         // pay 2% out to community rewards
1383         uint256 _com = _eth / 50;
1384         uint256 _p3d;
1385         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1386         {
1387             // This ensures Team Just cannot influence the outcome of FoMo3D with
1388             // bank migrations by breaking outgoing transactions.
1389             // Something we would never do. But that's not the point.
1390             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1391             // highest belief that everything we create should be trustless.
1392             // Team JUST, The name you shouldn't have to trust.
1393             _p3d = _com;
1394             _com = 0;
1395         }
1396         
1397         // pay 1% out to FoMo3D short
1398         uint256 _long = _eth / 100;
1399         otherF3D_.potSwap.value(_long)();
1400         
1401         // distribute share to affiliate
1402         uint256 _aff = _eth / 10;
1403         
1404         // decide what to do with affiliate share of fees
1405         // affiliate must not be self, and must have a name registered
1406         if (_affID != _pID && plyr_[_affID].name != '') {
1407             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1408             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1409         } else {
1410             _p3d = _aff;
1411         }
1412         
1413         // pay out p3d
1414         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1415         if (_p3d > 0)
1416         {
1417             // deposit to divies contract
1418            // Divies.deposit.value(_p3d)();
1419             if (_p3d > 0)
1420             owner.transfer(_p3d);
1421             // set up event data
1422             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1423         }
1424         
1425         return(_eventData_);
1426     }
1427     
1428     function potSwap()
1429         external
1430         payable
1431     {
1432         // setup local rID
1433         uint256 _rID = rID_ + 1;
1434         
1435         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1436         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1437     }
1438     
1439     /**
1440      * @dev distributes eth based on fees to gen and pot
1441      */
1442     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1443         private
1444         returns(F3Ddatasets.EventReturns)
1445     {
1446         // calculate gen share
1447         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1448         
1449         // toss 1% into airdrop pot 
1450         uint256 _air = (_eth / 100);
1451         airDropPot_ = airDropPot_.add(_air);
1452         
1453         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1454         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1455         
1456         // calculate pot 
1457         uint256 _pot = _eth.sub(_gen);
1458         
1459         // distribute gen share (thats what updateMasks() does) and adjust
1460         // balances for dust.
1461         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1462         if (_dust > 0)
1463             _gen = _gen.sub(_dust);
1464         
1465         // add eth to pot
1466         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1467         
1468         // set up event data
1469         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1470         _eventData_.potAmount = _pot;
1471         
1472         return(_eventData_);
1473     }
1474 
1475     /**
1476      * @dev updates masks for round and player when keys are bought
1477      * @return dust left over 
1478      */
1479     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1480         private
1481         returns(uint256)
1482     {
1483         /* MASKING NOTES
1484             earnings masks are a tricky thing for people to wrap their minds around.
1485             the basic thing to understand here.  is were going to have a global
1486             tracker based on profit per share for each round, that increases in
1487             relevant proportion to the increase in share supply.
1488             
1489             the player will have an additional mask that basically says "based
1490             on the rounds mask, my shares, and how much i've already withdrawn,
1491             how much is still owed to me?"
1492         */
1493         
1494         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1495         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1496         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1497             
1498         // calculate player earning from their own buy (only based on the keys
1499         // they just bought).  & update player earnings mask
1500         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1501         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1502         
1503         // calculate & return dust
1504         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1505     }
1506     
1507     /**
1508      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1509      * @return earnings in wei format
1510      */
1511     function withdrawEarnings(uint256 _pID)
1512         private
1513         returns(uint256)
1514     {
1515         // update gen vault
1516         updateGenVault(_pID, plyr_[_pID].lrnd);
1517         
1518         // from vaults 
1519         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1520         if (_earnings > 0)
1521         {
1522             plyr_[_pID].win = 0;
1523             plyr_[_pID].gen = 0;
1524             plyr_[_pID].aff = 0;
1525         }
1526 
1527         return(_earnings);
1528     }
1529     
1530     /**
1531      * @dev prepares compression data and fires event for buy or reload tx's
1532      */
1533     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1534         private
1535     {
1536         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1537         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1538         
1539         emit F3Devents.onEndTx
1540         (
1541             _eventData_.compressedData,
1542             _eventData_.compressedIDs,
1543             plyr_[_pID].name,
1544             msg.sender,
1545             _eth,
1546             _keys,
1547             _eventData_.winnerAddr,
1548             _eventData_.winnerName,
1549             _eventData_.amountWon,
1550             _eventData_.newPot,
1551             _eventData_.P3DAmount,
1552             _eventData_.genAmount,
1553             _eventData_.potAmount,
1554             airDropPot_
1555         );
1556     }
1557 //==============================================================================
1558 //    (~ _  _    _._|_    .
1559 //    _)(/_(_|_|| | | \/  .
1560 //====================/=========================================================
1561     /** upon contract deploy, it will be deactivated.  this is a one time
1562      * use function that will activate the contract.  we do this so devs 
1563      * have time to set things up on the web end                            **/
1564     bool public activated_ = false;
1565     function activate()
1566         public
1567     {
1568         // only team just can activate 
1569         require(
1570             msg.sender == 0xAE81cCb079B49f9149E54235802ad22a83A6e0dF ||
1571             msg.sender == 0x79Afe7a736bf84Bf5E61FE0480A59395F162a317 ,
1572             "only team just can activate"
1573         );
1574 
1575 		// make sure that its been linked.
1576         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1577         
1578         // can only be ran once
1579         require(activated_ == false, "fomo3d already activated");
1580         
1581         // activate the contract 
1582         activated_ = true;
1583         
1584         // lets start first round
1585 		rID_ = 1;
1586         round_[1].strt = now + rndExtra_ - rndGap_;
1587         round_[1].end = now + rndInit_ + rndExtra_;
1588     }
1589     function setOtherFomo(address _otherF3D)
1590         public
1591     {
1592         // only team just can activate 
1593         require(
1594             msg.sender == 0xAE81cCb079B49f9149E54235802ad22a83A6e0dF ||
1595             msg.sender == 0x79Afe7a736bf84Bf5E61FE0480A59395F162a317 ,
1596             "only team just can activate"
1597         );
1598 
1599         // make sure that it HASNT yet been linked.
1600         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1601         
1602         // set up other fomo3d (fast or long) for pot swap
1603         otherF3D_ = otherFoMo3D(_otherF3D);
1604     }
1605 }
1606 
1607 //==============================================================================
1608 //   __|_ _    __|_ _  .
1609 //  _\ | | |_|(_ | _\  .
1610 //==============================================================================
1611 library F3Ddatasets {
1612     //compressedData key
1613     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1614         // 0 - new player (bool)
1615         // 1 - joined round (bool)
1616         // 2 - new  leader (bool)
1617         // 3-5 - air drop tracker (uint 0-999)
1618         // 6-16 - round end time
1619         // 17 - winnerTeam
1620         // 18 - 28 timestamp 
1621         // 29 - team
1622         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1623         // 31 - airdrop happened bool
1624         // 32 - airdrop tier 
1625         // 33 - airdrop amount won
1626     //compressedIDs key
1627     // [77-52][51-26][25-0]
1628         // 0-25 - pID 
1629         // 26-51 - winPID
1630         // 52-77 - rID
1631     struct EventReturns {
1632         uint256 compressedData;
1633         uint256 compressedIDs;
1634         address winnerAddr;         // winner address
1635         bytes32 winnerName;         // winner name
1636         uint256 amountWon;          // amount won
1637         uint256 newPot;             // amount in new pot
1638         uint256 P3DAmount;          // amount distributed to p3d
1639         uint256 genAmount;          // amount distributed to gen
1640         uint256 potAmount;          // amount added to pot
1641     }
1642     struct Player {
1643         address addr;   // player address
1644         bytes32 name;   // player name
1645         uint256 win;    // winnings vault
1646         uint256 gen;    // general vault
1647         uint256 aff;    // affiliate vault
1648         uint256 lrnd;   // last round played
1649         uint256 laff;   // last affiliate id used
1650     }
1651     struct PlayerRounds {
1652         uint256 eth;    // eth player has added to round (used for eth limiter)
1653         uint256 keys;   // keys
1654         uint256 mask;   // player mask 
1655         uint256 ico;    // ICO phase investment
1656     }
1657     struct Round {
1658         uint256 plyr;   // pID of player in lead
1659         uint256 team;   // tID of team in lead
1660         uint256 end;    // time ends/ended
1661         bool ended;     // has round end function been ran
1662         uint256 strt;   // time round started
1663         uint256 keys;   // keys
1664         uint256 eth;    // total eth in
1665         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1666         uint256 mask;   // global mask
1667         uint256 ico;    // total eth sent in during ICO phase
1668         uint256 icoGen; // total eth for gen during ICO phase
1669         uint256 icoAvg; // average key price for ICO phase
1670     }
1671     struct TeamFee {
1672         uint256 gen;    // % of buy in thats paid to key holders of current round
1673         uint256 p3d;    // % of buy in thats paid to p3d holders
1674     }
1675     struct PotSplit {
1676         uint256 gen;    // % of pot thats paid to key holders of current round
1677         uint256 p3d;    // % of pot thats paid to p3d holders
1678     }
1679 }
1680 
1681 //==============================================================================
1682 //  |  _      _ _ | _  .
1683 //  |<(/_\/  (_(_||(_  .
1684 //=======/======================================================================
1685 library F3DKeysCalcLong {
1686     using SafeMath for *;
1687     /**
1688      * @dev calculates number of keys received given X eth 
1689      * @param _curEth current amount of eth in contract 
1690      * @param _newEth eth being spent
1691      * @return amount of ticket purchased
1692      */
1693     function keysRec(uint256 _curEth, uint256 _newEth)
1694         internal
1695         pure
1696         returns (uint256)
1697     {
1698         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1699     }
1700     
1701     /**
1702      * @dev calculates amount of eth received if you sold X keys 
1703      * @param _curKeys current amount of keys that exist 
1704      * @param _sellKeys amount of keys you wish to sell
1705      * @return amount of eth received
1706      */
1707     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1708         internal
1709         pure
1710         returns (uint256)
1711     {
1712         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1713     }
1714 
1715     /**
1716      * @dev calculates how many keys would exist with given an amount of eth
1717      * @param _eth eth "in contract"
1718      * @return number of keys that would exist
1719      */
1720     function keys(uint256 _eth) 
1721         internal
1722         pure
1723         returns(uint256)
1724     {
1725         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1726     }
1727     
1728     /**
1729      * @dev calculates how much eth would be in contract given a number of keys
1730      * @param _keys number of keys "in contract" 
1731      * @return eth that would exists
1732      */
1733     function eth(uint256 _keys) 
1734         internal
1735         pure
1736         returns(uint256)  
1737     {
1738         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1739     }
1740 }
1741 
1742 //==============================================================================
1743 //  . _ _|_ _  _ |` _  _ _  _  .
1744 //  || | | (/_| ~|~(_|(_(/__\  .
1745 //==============================================================================
1746 interface otherFoMo3D {
1747     function potSwap() external payable;
1748 }
1749 
1750 interface F3DexternalSettingsInterface {
1751     function getFastGap() external returns(uint256);
1752     function getLongGap() external returns(uint256);
1753     function getFastExtra() external returns(uint256);
1754     function getLongExtra() external returns(uint256);
1755 }
1756 
1757 
1758 
1759 interface JIincForwarderInterface {
1760     function deposit() external payable returns(bool);
1761     function status() external view returns(address, address, bool);
1762     function startMigration(address _newCorpBank) external returns(bool);
1763     function cancelMigration() external returns(bool);
1764     function finishMigration() external returns(bool);
1765     function setup(address _firstCorpBank) external;
1766 }
1767 
1768 interface PlayerBookInterface {
1769     function getPlayerID(address _addr) external returns (uint256);
1770     function getPlayerName(uint256 _pID) external view returns (bytes32);
1771     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1772     function getPlayerAddr(uint256 _pID) external view returns (address);
1773     function getNameFee() external view returns (uint256);
1774     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1775     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1776     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1777 }
1778 
1779 /**
1780 * @title -Name Filter- v0.1.9
1781 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1782 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1783 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1784 *                                  _____                      _____
1785 *                                 (, /     /)       /) /)    (, /      /)          /)
1786 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1787 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1788 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1789 *                            (__ /          (_/ (, /                                      /)™ 
1790 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1791 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1792 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1793 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1794 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1795 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1796 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1797 *
1798 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1799 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1800 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1801 */
1802 
1803 library NameFilter {
1804     /**
1805      * @dev filters name strings
1806      * -converts uppercase to lower case.  
1807      * -makes sure it does not start/end with a space
1808      * -makes sure it does not contain multiple spaces in a row
1809      * -cannot be only numbers
1810      * -cannot start with 0x 
1811      * -restricts characters to A-Z, a-z, 0-9, and space.
1812      * @return reprocessed string in bytes32 format
1813      */
1814     function nameFilter(string _input)
1815         internal
1816         pure
1817         returns(bytes32)
1818     {
1819         bytes memory _temp = bytes(_input);
1820         uint256 _length = _temp.length;
1821         
1822         //sorry limited to 32 characters
1823         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1824         // make sure it doesnt start with or end with space
1825         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1826         // make sure first two characters are not 0x
1827         if (_temp[0] == 0x30)
1828         {
1829             require(_temp[1] != 0x78, "string cannot start with 0x");
1830             require(_temp[1] != 0x58, "string cannot start with 0X");
1831         }
1832         
1833         // create a bool to track if we have a non number character
1834         bool _hasNonNumber;
1835         
1836         // convert & check
1837         for (uint256 i = 0; i < _length; i++)
1838         {
1839             // if its uppercase A-Z
1840             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1841             {
1842                 // convert to lower case a-z
1843                 _temp[i] = byte(uint(_temp[i]) + 32);
1844                 
1845                 // we have a non number
1846                 if (_hasNonNumber == false)
1847                     _hasNonNumber = true;
1848             } else {
1849                 require
1850                 (
1851                     // require character is a space
1852                     _temp[i] == 0x20 || 
1853                     // OR lowercase a-z
1854                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1855                     // or 0-9
1856                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1857                     "string contains invalid characters"
1858                 );
1859                 // make sure theres not 2x spaces in a row
1860                 if (_temp[i] == 0x20)
1861                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1862                 
1863                 // see if we have a character other than a number
1864                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1865                     _hasNonNumber = true;    
1866             }
1867         }
1868         
1869         require(_hasNonNumber == true, "string cannot be only numbers");
1870         
1871         bytes32 _ret;
1872         assembly {
1873             _ret := mload(add(_temp, 32))
1874         }
1875         return (_ret);
1876     }
1877 }
1878 
1879 /**
1880  * @title SafeMath v0.1.9
1881  * @dev Math operations with safety checks that throw on error
1882  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1883  * - added sqrt
1884  * - added sq
1885  * - added pwr 
1886  * - changed asserts to requires with error log outputs
1887  * - removed div, its useless
1888  */
1889 library SafeMath {
1890     
1891     /**
1892     * @dev Multiplies two numbers, throws on overflow.
1893     */
1894     function mul(uint256 a, uint256 b) 
1895         internal 
1896         pure 
1897         returns (uint256 c) 
1898     {
1899         if (a == 0) {
1900             return 0;
1901         }
1902         c = a * b;
1903         require(c / a == b, "SafeMath mul failed");
1904         return c;
1905     }
1906 
1907     /**
1908     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1909     */
1910     function sub(uint256 a, uint256 b)
1911         internal
1912         pure
1913         returns (uint256) 
1914     {
1915         require(b <= a, "SafeMath sub failed");
1916         return a - b;
1917     }
1918 
1919     /**
1920     * @dev Adds two numbers, throws on overflow.
1921     */
1922     function add(uint256 a, uint256 b)
1923         internal
1924         pure
1925         returns (uint256 c) 
1926     {
1927         c = a + b;
1928         require(c >= a, "SafeMath add failed");
1929         return c;
1930     }
1931     
1932     /**
1933      * @dev gives square root of given x.
1934      */
1935     function sqrt(uint256 x)
1936         internal
1937         pure
1938         returns (uint256 y) 
1939     {
1940         uint256 z = ((add(x,1)) / 2);
1941         y = x;
1942         while (z < y) 
1943         {
1944             y = z;
1945             z = ((add((x / z),z)) / 2);
1946         }
1947     }
1948     
1949     /**
1950      * @dev gives square. multiplies x by x
1951      */
1952     function sq(uint256 x)
1953         internal
1954         pure
1955         returns (uint256)
1956     {
1957         return (mul(x,x));
1958     }
1959     
1960     /**
1961      * @dev x to the power of y 
1962      */
1963     function pwr(uint256 x, uint256 y)
1964         internal 
1965         pure 
1966         returns (uint256)
1967     {
1968         if (x==0)
1969             return (0);
1970         else if (y==0)
1971             return (1);
1972         else 
1973         {
1974             uint256 z = x;
1975             for (uint256 i=1; i < y; i++)
1976                 z = mul(z,x);
1977             return (z);
1978         }
1979     }
1980 }