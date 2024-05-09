1 pragma solidity ^0.4.24;
2 /**
3  * cx mode of fomo3d
4  */
5 
6 //==============================================================================
7 //     _    _  _ _|_ _  .
8 //    (/_\/(/_| | | _\  .
9 //==============================================================================
10 contract F3Devents {
11     // fired whenever a player registers a name
12     event onNewName
13     (
14         uint256 indexed playerID,
15         address indexed playerAddress,
16         bytes32 indexed playerName,
17         bool isNewPlayer,
18         uint256 affiliateID,
19         address affiliateAddress,
20         bytes32 affiliateName,
21         uint256 amountPaid,
22         uint256 timeStamp
23     );
24     
25     // fired at end of buy or reload
26     event onEndTx
27     (
28         uint256 compressedData,     
29         uint256 compressedIDs,      
30         bytes32 playerName,
31         address playerAddress,
32         uint256 ethIn,
33         uint256 keysBought,
34         address winnerAddr,
35         bytes32 winnerName,
36         uint256 amountWon,
37         uint256 newPot,
38         uint256 P3DAmount,
39         uint256 genAmount,
40         uint256 potAmount,
41         uint256 airDropPot
42     );
43     
44 	// fired whenever theres a withdraw
45     event onWithdraw
46     (
47         uint256 indexed playerID,
48         address playerAddress,
49         bytes32 playerName,
50         uint256 ethOut,
51         uint256 timeStamp
52     );
53     
54     // fired whenever a withdraw forces end round to be ran
55     event onWithdrawAndDistribute
56     (
57         address playerAddress,
58         bytes32 playerName,
59         uint256 ethOut,
60         uint256 compressedData,
61         uint256 compressedIDs,
62         address winnerAddr,
63         bytes32 winnerName,
64         uint256 amountWon,
65         uint256 newPot,
66         uint256 P3DAmount,
67         uint256 genAmount
68     );
69     
70     // (fomo3d long only) fired whenever a player tries a buy after round timer 
71     // hit zero, and causes end round to be ran.
72     event onBuyAndDistribute
73     (
74         address playerAddress,
75         bytes32 playerName,
76         uint256 ethIn,
77         uint256 compressedData,
78         uint256 compressedIDs,
79         address winnerAddr,
80         bytes32 winnerName,
81         uint256 amountWon,
82         uint256 newPot,
83         uint256 P3DAmount,
84         uint256 genAmount
85     );
86     
87     // (fomo3d long only) fired whenever a player tries a reload after round timer 
88     // hit zero, and causes end round to be ran.
89     event onReLoadAndDistribute
90     (
91         address playerAddress,
92         bytes32 playerName,
93         uint256 compressedData,
94         uint256 compressedIDs,
95         address winnerAddr,
96         bytes32 winnerName,
97         uint256 amountWon,
98         uint256 newPot,
99         uint256 P3DAmount,
100         uint256 genAmount
101     );
102     
103     // fired whenever an affiliate is paid
104     event onAffiliatePayout
105     (
106         uint256 indexed affiliateID,
107         address affiliateAddress,
108         bytes32 affiliateName,
109         uint256 indexed roundID,
110         uint256 indexed buyerID,
111         uint256 amount,
112         uint256 timeStamp
113     );
114     
115     // // received pot swap deposit
116     // event onPotSwapDeposit
117     // (
118     //     uint256 roundID,
119     //     uint256 amountAddedToPot
120     // );
121 
122     event onRoundEnded1
123     (
124         uint256 winrSeq,
125         uint256 winPID,
126         uint256 winVault
127     );
128 
129     event onRoundEnded2
130     (
131         uint256 maxEthPID,
132         uint256 maxEthVault,
133         uint256 maxAffPID,
134         uint256 maxAffVault
135     );
136 }
137 
138 //==============================================================================
139 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
140 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
141 //====================================|=========================================
142 
143 contract modularLong is F3Devents {}
144 
145 contract FoMo3Dlong is modularLong {
146     using SafeMath for *;
147     using NameFilter for string;
148     using F3DKeysCalcLong for uint256;
149 	
150     //god of game
151     address constant private god = 0xe1B35fEBaB9Ff6da5b29C3A7A44eef06cD86B0f9;
152     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xf79341b38865310e1a00d7630bd1decc92a8f8b1);
153 //==============================================================================
154 //     _ _  _  |`. _     _ _ |_ | _  _  .
155 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
156 //=================_|===========================================================
157     string constant public name = "FM3D Pyramid Selling Heihei~";
158     string constant public symbol = "F3D";
159     uint256 private rndExtra_ = 0 minutes;                     // length of the very first ICO 
160     uint256 private rndGap_ = 0 minutes;                       // length of ICO phase, set to 1 year for EOS.
161     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
162     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
163     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
164     uint256[3] private potToWinners_ = [30,15,10];              // pot of 55% to 3 winner, 30%->15%->10%    5% to next round
165     uint256 constant private potToMaxEth_ = 20;                 // 20% to max eth,
166     uint256 constant private potToMaxAff_ = 20;                 // 20% to max invite,
167 //==============================================================================
168 //     _| _ _|_ _    _ _ _|_    _   .
169 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
170 //=============================|================================================
171     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
172     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
173     uint256 public rID_;    // round id number / total rounds that have happened
174 //****************
175 // PLAYER DATA 
176 //****************
177     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
178     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
179     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
180     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
181     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
182 //****************
183 // ROUND DATA 
184 //****************
185     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
186     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
187     uint256[3] private affPerLv_ = [20,10,5];  //affiliate's scale per level, parent 20%, pa's pa 10%, papapa 5%
188 //==============================================================================
189 //     _ _  _  __|_ _    __|_ _  _  .
190 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
191 //==============================================================================
192     constructor()
193         public
194     {
195         // 666
196     }
197 //==============================================================================
198 //     _ _  _  _|. |`. _  _ _  .
199 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
200 //==============================================================================
201     /**
202      * @dev used to make sure no one can interact with contract until it has 
203      * been activated. 
204      */
205     modifier isActivated() {
206         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
207         _;
208     }
209     
210     /**
211      * @dev prevents contracts from interacting with fomo3d 
212      */
213     modifier isHuman() {
214         address _addr = msg.sender;
215         uint256 _codeLength;
216         
217         assembly {_codeLength := extcodesize(_addr)}
218         require(_codeLength == 0, "sorry humans only");
219         _;
220     }
221 
222     /**
223      * @dev sets boundaries for incoming tx 
224      */
225     modifier isWithinLimits(uint256 _eth) {
226         require(_eth >= 1000000000, "pocket lint: not a valid currency");
227         require(_eth <= 100000000000000000000000, "no vitalik, no");
228         _;    
229     }
230     
231 //==============================================================================
232 //     _    |_ |. _   |`    _  __|_. _  _  _  .
233 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
234 //====|=========================================================================
235     /**
236      * @dev emergency buy uses last stored affiliate ID and team snek
237      */
238     function()
239         isActivated()
240         isHuman()
241         isWithinLimits(msg.value)
242         public
243         payable
244     {
245         // set up our tx event data and determine if player is new or not
246         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
247             
248         // fetch player id
249         uint256 _pID = pIDxAddr_[msg.sender];
250         
251         // buy core 
252         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
253     }
254     
255     /**
256      * @dev determine player's affid
257      * @param _pID player's id
258      * @param _inAffID inviter's pid
259      * @return _affID player's real affid
260      */
261     function determineAffID(uint256 _pID, uint256 _inAffID) private returns(uint256){
262         // affiliate must not be self, and must have a name registered
263         if(plyr_[_pID].laff == 0 && 0 != _inAffID && _pID != _inAffID && plyr_[_inAffID].name != ''){
264             // update last affiliate 
265             plyr_[_pID].laff = _inAffID;
266 
267             // _inAffID invite a new player, count it.
268             // update invite num of inviter for this round. if in round 0, add to round 1
269             uint256 _rID = (0 == rID_)?1:rID_;
270             plyrRnds_[_rID][_inAffID].affNum =  plyrRnds_[_rID][_inAffID].affNum.add(1);
271 
272             //update max invite num pid of this round
273             if( plyrRnds_[_rID][round_[_rID].maxAffPID].affNum < plyrRnds_[_rID][_inAffID].affNum){
274                 round_[_rID].maxAffPID = _inAffID;
275             }
276         }
277         return plyr_[_pID].laff;
278     }
279 
280     /**
281      * @dev converts all incoming ethereum to keys.
282      * -functionhash- 0x8f38f309 (using ID for affiliate)
283      * -functionhash- 0x98a0871d (using address for affiliate)
284      * -functionhash- 0xa65b37a1 (using name for affiliate)
285      * @param _affCode the ID/address/name of the player who gets the affiliate fee
286      * @param _team what team is the player playing for?
287      */
288     function buyXid(uint256 _affCode, uint256 _team)
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
301         // get real affid
302         _affCode = determineAffID(_pID,_affCode);
303         
304         // verify a valid team was selected
305         _team = verifyTeam(_team);
306         
307         // buy core 
308         buyCore(_pID, _affCode, _team, _eventData_);
309     }
310     
311     function buyXaddr(address _affCode, uint256 _team)
312         isActivated()
313         isHuman()
314         isWithinLimits(msg.value)
315         public
316         payable
317     {
318         // set up our tx event data and determine if player is new or not
319         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
320         
321         // fetch player id
322         uint256 _pID = pIDxAddr_[msg.sender];
323 
324         // get real affid
325         uint256 _affID = determineAffID(_pID,pIDxAddr_[_affCode]);
326         
327         // verify a valid team was selected
328         _team = verifyTeam(_team);
329         
330         // buy core 
331         buyCore(_pID, _affID, _team, _eventData_);
332     }
333     
334     function buyXname(bytes32 _affCode, uint256 _team)
335         isActivated()
336         isHuman()
337         isWithinLimits(msg.value)
338         public
339         payable
340     {
341         // set up our tx event data and determine if player is new or not
342         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
343         
344         // fetch player id
345         uint256 _pID = pIDxAddr_[msg.sender];
346         
347         // get real affid
348         uint256 _affID = determineAffID(_pID,pIDxName_[_affCode]);
349         
350         // verify a valid team was selected
351         _team = verifyTeam(_team);
352         
353         // buy core 
354         buyCore(_pID, _affID, _team, _eventData_);
355     }
356     
357     /**
358      * @dev essentially the same as buy, but instead of you sending ether 
359      * from your wallet, it uses your unwithdrawn earnings.
360      * -functionhash- 0x349cdcac (using ID for affiliate)
361      * -functionhash- 0x82bfc739 (using address for affiliate)
362      * -functionhash- 0x079ce327 (using name for affiliate)
363      * @param _affCode the ID/address/name of the player who gets the affiliate fee
364      * @param _team what team is the player playing for?
365      * @param _eth amount of earnings to use (remainder returned to gen vault)
366      */
367     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
368         isActivated()
369         isHuman()
370         isWithinLimits(_eth)
371         public
372     {
373         // set up our tx event data
374         F3Ddatasets.EventReturns memory _eventData_;
375         
376         // fetch player ID
377         uint256 _pID = pIDxAddr_[msg.sender];
378 
379         // get real affid
380         _affCode = determineAffID(_pID,_affCode);
381 
382         // verify a valid team was selected
383         _team = verifyTeam(_team);
384 
385         // reload core
386         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
387     }
388     
389     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
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
401         // get real affid
402         uint256 _affID = determineAffID(_pID,pIDxAddr_[_affCode]);
403         
404         // verify a valid team was selected
405         _team = verifyTeam(_team);
406         
407         // reload core
408         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
409     }
410     
411     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
412         isActivated()
413         isHuman()
414         isWithinLimits(_eth)
415         public
416     {
417         // set up our tx event data
418         F3Ddatasets.EventReturns memory _eventData_;
419         
420         // fetch player ID
421         uint256 _pID = pIDxAddr_[msg.sender];
422         
423         // get real affid
424         uint256 _affID = determineAffID(_pID,pIDxName_[_affCode]);
425         
426         // verify a valid team was selected
427         _team = verifyTeam(_team);
428         
429         // reload core
430         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
431     }
432 
433     /**
434      * @dev withdraws all of your earnings.
435      * -functionhash- 0x3ccfd60b
436      */
437     function withdraw()
438         isActivated()
439         isHuman()
440         public
441     {
442         // setup local rID 
443         uint256 _rID = rID_;
444         
445         // grab time
446         uint256 _now = now;
447         
448         // fetch player ID
449         uint256 _pID = pIDxAddr_[msg.sender];
450         
451         // setup temp var for player eth
452         uint256 _eth;
453         
454         // check to see if round has ended and no one has run round end yet
455         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
456         {
457             // set up our tx event data
458             F3Ddatasets.EventReturns memory _eventData_;
459             
460             // end the round (distributes pot)
461 			round_[_rID].ended = true;
462             _eventData_ = endRound(_eventData_);
463             
464 			// get their earnings
465             _eth = withdrawEarnings(_pID);
466             
467             // gib moni
468             if (_eth > 0)
469                 plyr_[_pID].addr.transfer(_eth);    
470             
471             // build event data
472             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
473             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
474             
475             // fire withdraw and distribute event
476             emit F3Devents.onWithdrawAndDistribute
477             (
478                 msg.sender, 
479                 plyr_[_pID].name, 
480                 _eth, 
481                 _eventData_.compressedData, 
482                 _eventData_.compressedIDs, 
483                 _eventData_.winnerAddr, 
484                 _eventData_.winnerName, 
485                 _eventData_.amountWon, 
486                 _eventData_.newPot, 
487                 _eventData_.P3DAmount, 
488                 _eventData_.genAmount
489             );
490             
491         // in any other situation
492         } else {
493             // get their earnings
494             _eth = withdrawEarnings(_pID);
495             
496             // gib moni
497             if (_eth > 0)
498                 plyr_[_pID].addr.transfer(_eth);
499             
500             // fire withdraw event
501             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
502         }
503     }
504     
505     /**
506      * @dev use these to register names.  they are just wrappers that will send the
507      * registration requests to the PlayerBook contract.  So registering here is the 
508      * same as registering there.  UI will always display the last name you registered.
509      * but you will still own all previously registered names to use as affiliate 
510      * links.
511      * - must pay a registration fee.
512      * - name must be unique
513      * - names will be converted to lowercase
514      * - name cannot start or end with a space 
515      * - cannot have more than 1 space in a row
516      * - cannot be only numbers
517      * - cannot start with 0x 
518      * - name must be at least 1 char
519      * - max length of 32 characters long
520      * - allowed characters: a-z, 0-9, and space
521      * -functionhash- 0x921dec21 (using ID for affiliate)
522      * -functionhash- 0x3ddd4698 (using address for affiliate)
523      * -functionhash- 0x685ffd83 (using name for affiliate)
524      * @param _nameString players desired name
525      * @param _affCode affiliate ID, address, or name of who referred you
526      * @param _all set to true if you want this to push your info to all games 
527      * (this might cost a lot of gas)
528      */
529     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
530         isHuman()
531         public
532         payable
533     {
534         bytes32 _name = _nameString.nameFilter();
535         address _addr = msg.sender;
536         uint256 _paid = msg.value;
537         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
538         
539         uint256 _pID = pIDxAddr_[_addr];
540         
541         // fire event
542         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
543     }
544     
545     function registerNameXaddr(string _nameString, address _affCode, bool _all)
546         isHuman()
547         public
548         payable
549     {
550         bytes32 _name = _nameString.nameFilter();
551         address _addr = msg.sender;
552         uint256 _paid = msg.value;
553         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
554         
555         uint256 _pID = pIDxAddr_[_addr];
556         
557         // fire event
558         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
559     }
560     
561     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
562         isHuman()
563         public
564         payable
565     {
566         bytes32 _name = _nameString.nameFilter();
567         address _addr = msg.sender;
568         uint256 _paid = msg.value;
569         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
570         
571         uint256 _pID = pIDxAddr_[_addr];
572         
573         // fire event
574         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
575     }
576 //==============================================================================
577 //     _  _ _|__|_ _  _ _  .
578 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
579 //=====_|=======================================================================
580     /**
581      * @dev return the price buyer will pay for next 1 individual key.
582      * -functionhash- 0x018a25e8
583      * @return price for next key bought (in wei format)
584      */
585     function getBuyPrice()
586         public 
587         view 
588         returns(uint256)
589     {  
590         // setup local rID
591         uint256 _rID = rID_;
592         
593         // grab time
594         uint256 _now = now;
595         
596         // are we in a round?
597         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
598             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
599         else // rounds over.  need price for new round
600             return ( 75000000000000 ); // init
601     }
602     
603     /**
604      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
605      * provider
606      * -functionhash- 0xc7e284b8
607      * @return time left in seconds
608      */
609     function getTimeLeft()
610         public
611         view
612         returns(uint256)
613     {
614         // setup local rID
615         uint256 _rID = rID_;
616         
617         // grab time
618         uint256 _now = now;
619         
620         if (_now < round_[_rID].end)
621             if (_now > round_[_rID].strt + rndGap_)
622                 return( (round_[_rID].end).sub(_now) );
623             else
624                 return( (round_[_rID].strt + rndGap_).sub(_now) );
625         else
626             return(0);
627     }
628     
629     /**
630      * @dev returns player earnings per vaults 
631      * -functionhash- 0x63066434
632      * @return winnings vault
633      * @return general vault
634      * @return affiliate vault
635      */
636     function getPlayerVaults(uint256 _pID)
637         public
638         view
639         returns(uint256 ,uint256, uint256)
640     {
641         // setup local rID
642         uint256 _rID = rID_;
643         
644         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
645         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
646         {
647             // if player is winner 
648             if (round_[_rID].plyr == _pID)
649             {
650                 return
651                 (
652                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
653                     (plyr_[_pID].gen),//.add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
654                     plyr_[_pID].aff
655                 );
656             // if player is not the winner
657             } else {
658                 return
659                 (
660                     plyr_[_pID].win,
661                     (plyr_[_pID].gen),//.add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
662                     plyr_[_pID].aff
663                 );
664             }
665             
666         // if round is still going on, or round has ended and round end has been ran
667         } else {
668             return
669             (
670                 plyr_[_pID].win,
671                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
672                 plyr_[_pID].aff
673             );
674         }
675     }
676     
677     /**
678      * solidity hates stack limits.  this lets us avoid that hate 
679      */
680     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
681         private
682         view
683         returns(uint256)
684     {
685         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(0)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
686     }
687     
688     /**
689      * @dev returns all current round info needed for front end
690      * -functionhash- 0x747dff42
691      * @return eth invested during ICO phase
692      * @return round id 
693      * @return total keys for round 
694      * @return time round ends
695      * @return time round started
696      * @return current pot 
697      * @return current team ID & player ID in lead 
698      * @return current player in leads address 
699      * @return current player in leads name
700      * @return whales eth in for round
701      * @return bears eth in for round
702      * @return sneks eth in for round
703      * @return bulls eth in for round
704      * @return airdrop tracker # & airdrop pot
705      */
706     function getCurrentRoundInfo()
707         public
708         view
709         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
710     {
711         // setup local rID
712         uint256 _rID = rID_;
713         
714         return
715         (
716             round_[_rID].ico,               //0
717             _rID,                           //1
718             round_[_rID].keys,              //2
719             round_[_rID].end,               //3
720             round_[_rID].strt,              //4
721             round_[_rID].pot,               //5
722             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
723             plyr_[round_[_rID].plyr].addr,  //7
724             plyr_[round_[_rID].plyr].name,  //8
725             rndTmEth_[_rID][0],             //9
726             rndTmEth_[_rID][1],             //10
727             rndTmEth_[_rID][2],             //11
728             rndTmEth_[_rID][3],             //12
729             airDropTracker_ + (airDropPot_ * 1000)              //13
730         );
731     }
732 
733     /**
734      * @dev other round info. if player not set name, return null string
735      * @return max eth of round player name
736      * @return max eth of round
737      * @return max invite of round player name
738      * @return max invite of round
739      * @return last 1 name of buyer
740      * @return last 2 name of buyer
741      * @return last 3 name of buyer
742      */
743     function getCurrentRoundInfo2()
744         public
745         view
746         returns(bytes32, uint256, bytes32, uint256, bytes32, bytes32, bytes32)
747     {
748         // setup local rID
749         uint256 _rID = rID_;
750         return 
751         (
752             plyr_[round_[_rID].maxEthPID].name, //1
753             plyrRnds_[round_[_rID].maxEthPID][_rID].eth,  //2
754             plyr_[round_[_rID].maxAffPID].name, //3
755             plyrRnds_[round_[_rID].maxAffPID][_rID].affNum, //4
756             plyr_[round_[_rID].plyrs[0]].name,  //5
757             plyr_[round_[_rID].plyrs[1]].name,  //6
758             plyr_[round_[_rID].plyrs[2]].name   //7
759         );
760     }
761 
762     /**
763      * @dev returns player info based on address.  if no address is given, it will 
764      * use msg.sender 
765      * -functionhash- 0xee0b5d8b
766      * @param _addr address of the player you want to lookup 
767      * @return player ID 
768      * @return player name
769      * @return keys owned (current round)
770      * @return winnings vault
771      * @return general vault 
772      * @return affiliate vault 
773 	 * @return player round eth
774      * @return player's papa's name
775      */
776     function getPlayerInfoByAddress(address _addr)
777         public 
778         view 
779         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, bytes32)
780     {
781         // setup local rID
782         uint256 _rID = rID_;
783         
784         if (_addr == address(0))
785         {
786             _addr == msg.sender;
787         }
788         uint256 _pID = pIDxAddr_[_addr];
789         
790         return
791         (
792             _pID,                               //0
793             plyr_[_pID].name,                   //1
794             plyrRnds_[_pID][_rID].keys,         //2
795             plyr_[_pID].win,                    //3
796             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
797             plyr_[_pID].aff,                    //5
798             plyrRnds_[_pID][_rID].eth,          //6
799             plyr_[plyr_[_pID].laff].name        //7
800         );
801     }
802 
803 //==============================================================================
804 //     _ _  _ _   | _  _ . _  .
805 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
806 //=====================_|=======================================================
807     /**
808      * @dev logic runs whenever a buy order is executed.  determines how to handle 
809      * incoming eth depending on if we are in an active round or not
810      */
811     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
812         private
813     {
814         // setup local rID
815         uint256 _rID = rID_;
816         
817         // grab time
818         uint256 _now = now;
819         
820         // if round is active
821         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
822         {
823             // call core 
824             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
825         
826         // if round is not active     
827         } else {
828             // check to see if end round needs to be ran
829             if (_now > round_[_rID].end && round_[_rID].ended == false) 
830             {
831                 // end the round (distributes pot) & start new round
832 			    round_[_rID].ended = true;
833                 _eventData_ = endRound(_eventData_);
834                 
835                 // build event data
836                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
837                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
838                 
839                 // fire buy and distribute event 
840                 emit F3Devents.onBuyAndDistribute
841                 (
842                     msg.sender, 
843                     plyr_[_pID].name, 
844                     msg.value, 
845                     _eventData_.compressedData, 
846                     _eventData_.compressedIDs, 
847                     _eventData_.winnerAddr, 
848                     _eventData_.winnerName, 
849                     _eventData_.amountWon, 
850                     _eventData_.newPot, 
851                     _eventData_.P3DAmount, 
852                     _eventData_.genAmount
853                 );
854             }
855             
856             // put eth in players vault 
857             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
858         }
859     }
860     
861     /**
862      * @dev logic runs whenever a reload order is executed.  determines how to handle 
863      * incoming eth depending on if we are in an active round or not 
864      */
865     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
866         private
867     {
868         // setup local rID
869         uint256 _rID = rID_;
870         
871         // grab time
872         uint256 _now = now;
873         
874         // if round is active
875         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
876         {
877             // get earnings from all vaults and return unused to gen vault
878             // because we use a custom safemath library.  this will throw if player 
879             // tried to spend more eth than they have.
880             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
881             
882             // call core 
883             core(_rID, _pID, _eth, _affID, _team, _eventData_);
884         
885         // if round is not active and end round needs to be ran   
886         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
887             // end the round (distributes pot) & start new round
888             round_[_rID].ended = true;
889             _eventData_ = endRound(_eventData_);
890                 
891             // build event data
892             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
893             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
894                 
895             // fire buy and distribute event 
896             emit F3Devents.onReLoadAndDistribute
897             (
898                 msg.sender, 
899                 plyr_[_pID].name, 
900                 _eventData_.compressedData, 
901                 _eventData_.compressedIDs, 
902                 _eventData_.winnerAddr, 
903                 _eventData_.winnerName, 
904                 _eventData_.amountWon, 
905                 _eventData_.newPot, 
906                 _eventData_.P3DAmount, 
907                 _eventData_.genAmount
908             );
909         }
910     }
911 
912     /**
913      * @dev update last multi pids who boungt key. pids able repeat
914      */
915     function updateLastBuyKeysPIDs(uint256 _rID, uint256 _lastPID)
916         private 
917     {
918         //move last pids
919         for(uint256 _i=potToWinners_.length-1; _i>=1; _i--){
920             round_[_rID].plyrs[_i] = round_[_rID].plyrs[_i - 1];
921         }
922         
923         //set lastPID to first of set
924         round_[_rID].plyrs[0] = _lastPID;
925     }
926     
927     /**
928      * @dev this is the core logic for any buy/reload that happens while a round 
929      * is live.
930      */
931     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
932         private
933     {
934         // if player is new to round
935         if (plyrRnds_[_pID][_rID].keys == 0)
936             _eventData_ = managePlayer(_pID, _eventData_);
937         
938         // // early round eth limiter 
939         // if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
940         // {
941         //     uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
942         //     uint256 _refund = _eth.sub(_availableLimit);
943         //     plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
944         //     _eth = _availableLimit;
945         // }
946         
947         // if eth left is greater than min eth allowed (sorry no pocket lint)
948         if (_eth > 1000000000) 
949         {
950             
951             // mint the new keys
952             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
953             
954             // if they bought at least 1 whole key
955             if (_keys >= 1000000000000000000)
956             {
957                 updateTimer(_keys, _rID);
958 
959                 // set new leaders is they cost eth >= 0.01
960                 if(_eth > 10000000000000000){
961                     if (round_[_rID].plyr != _pID){
962                         round_[_rID].plyr = _pID;
963                     }
964                     //update last 3 player
965                     updateLastBuyKeysPIDs(_rID, _pID);
966                 }
967                     
968                 if (round_[_rID].team != _team){ round_[_rID].team = _team; } 
969                 
970                 // set the new leader bool to true
971                 _eventData_.compressedData = _eventData_.compressedData + 100;
972             }
973             
974             // manage airdrops
975             if (_eth >= 100000000000000000)
976             {
977                 airDropTracker_++;
978                 if (airdrop() == true)
979                 {
980                     // gib muni
981                     uint256 _prize;
982                     if (_eth >= 10000000000000000000)
983                     {
984                         // calculate prize and give it to winner
985                         _prize = ((airDropPot_).mul(75)) / 100;
986                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
987                         
988                         // adjust airDropPot 
989                         airDropPot_ = (airDropPot_).sub(_prize);
990                         
991                         // let event know a tier 3 prize was won 
992                         _eventData_.compressedData += 300000000000000000000000000000000;
993                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
994                         // calculate prize and give it to winner
995                         _prize = ((airDropPot_).mul(50)) / 100;
996                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
997                         
998                         // adjust airDropPot 
999                         airDropPot_ = (airDropPot_).sub(_prize);
1000                         
1001                         // let event know a tier 2 prize was won 
1002                         _eventData_.compressedData += 200000000000000000000000000000000;
1003                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1004                         // calculate prize and give it to winner
1005                         _prize = ((airDropPot_).mul(25)) / 100;
1006                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1007                         
1008                         // adjust airDropPot 
1009                         airDropPot_ = (airDropPot_).sub(_prize);
1010                         
1011                         // let event know a tier 3 prize was won 
1012                         _eventData_.compressedData += 300000000000000000000000000000000;
1013                     }
1014                     // set airdrop happened bool to true
1015                     _eventData_.compressedData += 10000000000000000000000000000000;
1016                     // let event know how much was won 
1017                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1018                     
1019                     // reset air drop tracker
1020                     airDropTracker_ = 0;
1021                 }
1022             }
1023     
1024             // store the air drop tracker number (number of buys since last airdrop)
1025             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1026             
1027             // update player 
1028             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1029             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1030             
1031             // update round
1032             round_[_rID].keys = _keys.add(round_[_rID].keys);
1033             round_[_rID].eth = _eth.add(round_[_rID].eth);
1034             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1035 
1036             //update round of max eth player
1037             if(0 == round_[_rID].maxEthPID || plyrRnds_[round_[_rID].maxEthPID][_rID].eth < plyrRnds_[_pID][_rID].eth){
1038                 round_[_rID].maxEthPID = _pID;
1039             }
1040     
1041             // distribute eth
1042             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1043             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1044             
1045             // call end tx function to fire end tx event.
1046 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1047         }
1048     }
1049 //==============================================================================
1050 //     _ _ | _   | _ _|_ _  _ _  .
1051 //    (_(_||(_|_||(_| | (_)| _\  .
1052 //==============================================================================
1053     /**
1054      * @dev calculates unmasked earnings (just calculates, does not update mask)
1055      * @return earnings in wei format
1056      */
1057     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1058         private
1059         view
1060         returns(uint256)
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
1073         public
1074         view
1075         returns(uint256)
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
1094         public
1095         view
1096         returns(uint256)
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
1110 //==============================================================================
1111 //    _|_ _  _ | _  .
1112 //     | (_)(_)|_\  .
1113 //==============================================================================
1114     /**
1115 	 * @dev receives name/player info from names contract 
1116      */
1117     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1118         external
1119     {
1120         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1121         if (pIDxAddr_[_addr] != _pID){ pIDxAddr_[_addr] = _pID; }
1122         if (pIDxName_[_name] != _pID){ pIDxName_[_name] = _pID; }
1123         if (plyr_[_pID].addr != _addr){ plyr_[_pID].addr = _addr; }
1124         if (plyr_[_pID].name != _name){ plyr_[_pID].name = _name; }
1125         if (plyr_[_pID].laff != _laff){ determineAffID(_pID, _laff); }
1126         if (plyrNames_[_pID][_name] == false){ plyrNames_[_pID][_name] = true; }
1127     }
1128     
1129     /**
1130      * @dev receives entire player name list 
1131      */
1132     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1133         external
1134     {
1135         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1136         if(plyrNames_[_pID][_name] == false)
1137             plyrNames_[_pID][_name] = true;
1138     }   
1139         
1140     /**
1141      * @dev gets existing or registers new pID.  use this when a player may be new
1142      * @return pID 
1143      */
1144     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1145         private
1146         returns (F3Ddatasets.EventReturns)
1147     {
1148         uint256 _pID = pIDxAddr_[msg.sender];
1149         // if player is new to this version of fomo3d
1150         if (_pID == 0)
1151         {
1152             // grab their player ID, name and last aff ID, from player names contract 
1153             _pID = PlayerBook.getPlayerID(msg.sender);
1154             bytes32 _name = PlayerBook.getPlayerName(_pID);
1155             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1156             
1157             // set up player account 
1158             pIDxAddr_[msg.sender] = _pID;
1159             plyr_[_pID].addr = msg.sender;
1160             
1161             if (_name != "")
1162             {
1163                 pIDxName_[_name] = _pID;
1164                 plyr_[_pID].name = _name;
1165                 plyrNames_[_pID][_name] = true;
1166             }
1167             
1168             if (_laff != 0 && _laff != _pID)
1169                 plyr_[_pID].laff = _laff;
1170             
1171             // set the new player bool to true
1172             _eventData_.compressedData = _eventData_.compressedData + 1;
1173         } 
1174         return (_eventData_);
1175     }
1176     
1177     /**
1178      * @dev checks to make sure user picked a valid team.  if not sets team 
1179      * to default (sneks)
1180      */
1181     function verifyTeam(uint256 _team)
1182         private
1183         pure
1184         returns (uint256)
1185     {
1186         if (_team < 0 || _team > 3)
1187             return(2);
1188         else
1189             return(_team);
1190     }
1191     
1192     /**
1193      * @dev decides if round end needs to be run & new round started.  and if 
1194      * player unmasked earnings from previously played rounds need to be moved.
1195      */
1196     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1197         private
1198         returns (F3Ddatasets.EventReturns)
1199     {
1200         // if player has played a previous round, move their unmasked earnings
1201         // from that round to gen vault.
1202         if (plyr_[_pID].lrnd != 0)
1203             
1204             updateGenVault(_pID, plyr_[_pID].lrnd);
1205         // update player's last round played
1206         plyr_[_pID].lrnd = rID_;
1207             
1208         // set the joined round bool to true
1209         _eventData_.compressedData = _eventData_.compressedData + 10;
1210         
1211         return(_eventData_);
1212     }
1213     
1214     /**
1215      * @dev ends the round. manages paying out winner/splitting up pot
1216      */
1217     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1218         private
1219         returns (F3Ddatasets.EventReturns)
1220     {
1221         // setup local rID
1222         uint256 _rID = rID_;
1223         
1224         // grab our winning player and team id's
1225         //uint256 _winPID = round_[_rID].plyr;
1226         uint256 _winTID = round_[_rID].team;
1227         uint256 _maxEthPID = round_[_rID].maxEthPID;
1228         uint256 _maxAffPID = round_[_rID].maxAffPID;
1229         if(0 == _maxAffPID){ _maxAffPID = 1; }
1230         
1231         // grab our pot amount
1232         uint256 _pot = round_[_rID].pot;
1233         
1234         // calculate our winner, max buyer, max inviter share
1235         // uint256 _win = (_pot.mul(potToWinner_)) / 100;
1236         uint256 _maxEth = (_pot.mul(potToMaxEth_)) / 100;
1237         uint256 _maxAff = (_pot.mul(potToMaxAff_)) / 100;
1238         uint256 _res = _pot.sub(_win).sub(_maxEth);
1239         
1240         // // pay our winner
1241         // plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1242         // pay for maxEth player
1243         plyr_[_maxEthPID].win = _maxEth.add(plyr_[_maxEthPID].win);
1244         // pay for maxAff player
1245         plyr_[_maxAffPID].win = _maxAff.add(plyr_[_maxAffPID].win);
1246 
1247         //deal multi winner, no.1 last, no.2 last, no.3 last...
1248         for(uint256 _seq=0; _seq<potToWinners_.length; _seq++){
1249             uint256 _win = _pot.mul(potToWinners_[_seq]) / 100;
1250             uint256 _winPID = round_[_rID].plyrs[_seq];
1251             if(0 == _winPID){
1252                // invalid pid, set default pid:1
1253                _winPID = 1;
1254             }
1255             
1256             // pay our winner
1257             plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1258             
1259             // count res eth
1260             _res = _res.sub(_win);
1261              
1262             // log it
1263             emit F3Devents.onRoundEnded1(
1264                 _seq,
1265                 _winPID,
1266                 _win
1267             );
1268         }
1269 
1270         //log once
1271         emit F3Devents.onRoundEnded2(
1272             _maxEthPID,
1273             _maxEth,
1274             _maxAffPID,
1275             _maxAff
1276         );
1277         
1278         // prepare event data
1279         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1280         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1281         _eventData_.winnerAddr = plyr_[_winPID].addr;
1282         _eventData_.winnerName = plyr_[_winPID].name;
1283         _eventData_.amountWon = _win;
1284         _eventData_.genAmount = 0;
1285         _eventData_.P3DAmount = 0;
1286         _eventData_.newPot = _res;
1287         
1288         // start next round
1289         rID_++;
1290         _rID++;
1291         round_[_rID].strt = now;
1292         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1293         round_[_rID].pot = _res;
1294         
1295         return(_eventData_);
1296     }
1297     
1298     /**
1299      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1300      */
1301     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1302         private 
1303     {
1304         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1305         if (_earnings > 0)
1306         {
1307             // put in gen vault
1308             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1309             // zero out their earnings by updating mask
1310             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1311         }
1312     }
1313 
1314     /**
1315      * @dev calc real max time for spent time. maxtime make half per day
1316      */
1317     function getRealRndMaxTime(uint256 _rID)
1318         public
1319         returns(uint256)
1320     {
1321         uint256 _realRndMax = rndMax_;
1322         uint256 _days = (now - round_[_rID].strt) / (1 days);
1323         while(0 < _days --){
1324             _realRndMax = _realRndMax / 2;
1325         }
1326         return (_realRndMax > 10 minutes) ? _realRndMax : 10 minutes;
1327     }
1328     
1329     /**
1330      * @dev updates round timer based on number of whole keys bought.
1331      */
1332     function updateTimer(uint256 _keys, uint256 _rID)
1333         private
1334     {
1335         // grab time
1336         uint256 _now = now;
1337         
1338         // calculate time based on number of keys bought
1339         uint256 _newTime;
1340         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1341             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1342         else
1343             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1344         
1345         //get real max time
1346         uint256 _realRndMax = getRealRndMaxTime(_rID);
1347 
1348         // compare to max and set new end time
1349         if (_newTime < (_realRndMax).add(_now))
1350             round_[_rID].end = _newTime;
1351         else
1352             round_[_rID].end = _realRndMax.add(_now);
1353     }
1354     
1355     /**
1356      * @dev generates a random number between 0-99 and checks to see if thats
1357      * resulted in an airdrop win
1358      * @return do we have a winner?
1359      */
1360     function airdrop()
1361         private 
1362         view 
1363         returns(bool)
1364     {
1365         uint256 seed = uint256(keccak256(abi.encodePacked(
1366             
1367             (block.timestamp).add
1368             (block.difficulty).add
1369             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1370             (block.gaslimit).add
1371             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1372             (block.number)
1373             
1374         )));
1375         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1376             return(true);
1377         else
1378             return(false);
1379     }
1380 
1381     /**
1382      * @dev distributes eth based on fees to com, aff, and p3d
1383      */
1384     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1385         private
1386         returns(F3Ddatasets.EventReturns)
1387     {
1388         // pay 5% out to community rewards
1389         uint256 _com = _eth / 20;
1390 
1391         //community rewards and FoMo3D short all send to god
1392         address(god).transfer(_com);
1393         
1394         // decide what to do with affiliate share of fees
1395         // uint256 _curAffID = _affID;
1396         // use player's affid, not use param
1397         uint256 _curAffID = plyr_[_pID].laff;
1398         for(uint256 _i=0; _i< affPerLv_.length; _i++){
1399             uint256 _aff =  _eth.mul(affPerLv_[_i]) / (100);
1400 
1401             // affiliate must not be self, and must have a name registered
1402             if (_curAffID == _pID || plyr_[_curAffID].name == '') {
1403                 //affID is not invalid. set default id: 1
1404                 _curAffID = 1;
1405             }
1406             plyr_[_curAffID].aff = _aff.add(plyr_[_curAffID].aff);
1407             //log
1408             emit F3Devents.onAffiliatePayout(_curAffID, plyr_[_curAffID].addr, plyr_[_curAffID].name, _rID, _pID, _aff, now);
1409             //get affiliate's affiliate
1410             _curAffID = plyr_[_curAffID].laff;
1411         }
1412         
1413         return(_eventData_);
1414     }
1415     
1416 
1417     // this function had a bug~
1418     // function potSwap()
1419     //     external
1420     //     payable
1421     // {
1422     //     // setup local rID
1423     //     uint256 _rID = rID_ + 1;
1424         
1425     //     round_[_rID].pot = round_[_rID].pot.add(msg.value);
1426     //     emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1427     // }
1428     
1429     /**
1430      * @dev distributes eth based on fees to gen and pot
1431      */
1432     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1433         private
1434         returns(F3Ddatasets.EventReturns)
1435     {
1436         // calculate gen share, 40% of total
1437         uint256 _gen = _eth.mul(40) / 100;
1438         
1439         // toss 0% into airdrop pot 
1440         uint256 _air = 0; // (_eth / 100);
1441         airDropPot_ = airDropPot_.add(_air);
1442         
1443         // // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1444         // _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1445 
1446         // calculate pot 
1447         uint256 _pot = (_eth.mul(20)) / 100; //_eth.sub(_gen);
1448         
1449         // distribute gen share (thats what updateMasks() does) and adjust
1450         // balances for dust.
1451         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1452         if (_dust > 0)
1453             _gen = _gen.sub(_dust);
1454         
1455         // add eth to pot
1456         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1457         
1458         // set up event data
1459         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1460         _eventData_.potAmount = _pot;
1461         
1462         return(_eventData_);
1463     }
1464 
1465     /**
1466      * @dev updates masks for round and player when keys are bought
1467      * @return dust left over 
1468      */
1469     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1470         private
1471         returns(uint256)
1472     {
1473         /* MASKING NOTES
1474             earnings masks are a tricky thing for people to wrap their minds around.
1475             the basic thing to understand here.  is were going to have a global
1476             tracker based on profit per share for each round, that increases in
1477             relevant proportion to the increase in share supply.
1478             
1479             the player will have an additional mask that basically says "based
1480             on the rounds mask, my shares, and how much i've already withdrawn,
1481             how much is still owed to me?"
1482         */
1483         
1484         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1485         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1486         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1487             
1488         // calculate player earning from their own buy (only based on the keys
1489         // they just bought).  & update player earnings mask
1490         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1491         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1492         
1493         // calculate & return dust
1494         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1495     }
1496     
1497     /**
1498      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1499      * @return earnings in wei format
1500      */
1501     function withdrawEarnings(uint256 _pID)
1502         private
1503         returns(uint256)
1504     {
1505         // update gen vault
1506         updateGenVault(_pID, plyr_[_pID].lrnd);
1507         
1508         // from vaults 
1509         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1510         if (_earnings > 0)
1511         {
1512             plyr_[_pID].win = 0;
1513             plyr_[_pID].gen = 0;
1514             plyr_[_pID].aff = 0;
1515         }
1516 
1517         return(_earnings);
1518     }
1519     
1520     /**
1521      * @dev prepares compression data and fires event for buy or reload tx's
1522      */
1523     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1524         private
1525     {
1526         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1527         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1528         
1529         emit F3Devents.onEndTx
1530         (
1531             _eventData_.compressedData,
1532             _eventData_.compressedIDs,
1533             plyr_[_pID].name,
1534             msg.sender,
1535             _eth,
1536             _keys,
1537             _eventData_.winnerAddr,
1538             _eventData_.winnerName,
1539             _eventData_.amountWon,
1540             _eventData_.newPot,
1541             _eventData_.P3DAmount,
1542             _eventData_.genAmount,
1543             _eventData_.potAmount,
1544             airDropPot_
1545         );
1546     }
1547 //==============================================================================
1548 //    (~ _  _    _._|_    .
1549 //    _)(/_(_|_|| | | \/  .
1550 //====================/=========================================================
1551     /** upon contract deploy, it will be deactivated.  this is a one time
1552      * use function that will activate the contract.  we do this so devs 
1553      * have time to set things up on the web end                            **/
1554     bool public activated_ = false;
1555     function activate()
1556         public
1557     {
1558         // only team just can activate 
1559         // require(
1560         //     msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1561         //     msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1562         //     msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1563         //     msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1564 		// 	msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1565         //     "only team just can activate"
1566         // );
1567         require(msg.sender == god, "only team just can activate");
1568 
1569 		// // make sure that its been linked.
1570         // require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1571         
1572         // can only be ran once
1573         require(activated_ == false, "fomo3d already activated");
1574         
1575         // activate the contract 
1576         activated_ = true;
1577         
1578         // lets start first round
1579 		rID_ = 1;
1580         round_[1].strt = now + rndExtra_ - rndGap_;
1581         round_[1].end = now + rndInit_ + rndExtra_;
1582     }
1583     // function setOtherFomo(address _otherF3D)
1584     //     public
1585     // {
1586     //     // only team just can activate 
1587     //     require(
1588     //         msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1589     //         msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1590     //         msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1591     //         msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1592 	// 		msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1593     //         "only team just can activate"
1594     //     );
1595 
1596     //     // make sure that it HASNT yet been linked.
1597     //     require(address(otherF3D_) == address(0), "silly dev, you already did that");
1598         
1599     //     // set up other fomo3d (fast or long) for pot swap
1600     //     otherF3D_ = otherFoMo3D(_otherF3D);
1601     // }
1602 }
1603 
1604 //==============================================================================
1605 //   __|_ _    __|_ _  .
1606 //  _\ | | |_|(_ | _\  .
1607 //==============================================================================
1608 library F3Ddatasets {
1609     //compressedData key
1610     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1611         // 0 - new player (bool)
1612         // 1 - joined round (bool)
1613         // 2 - new  leader (bool)
1614         // 3-5 - air drop tracker (uint 0-999)
1615         // 6-16 - round end time
1616         // 17 - winnerTeam
1617         // 18 - 28 timestamp 
1618         // 29 - team
1619         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1620         // 31 - airdrop happened bool
1621         // 32 - airdrop tier 
1622         // 33 - airdrop amount won
1623     //compressedIDs key
1624     // [77-52][51-26][25-0]
1625         // 0-25 - pID 
1626         // 26-51 - winPID
1627         // 52-77 - rID
1628     struct EventReturns {
1629         uint256 compressedData;
1630         uint256 compressedIDs;
1631         address winnerAddr;         // winner address
1632         bytes32 winnerName;         // winner name
1633         uint256 amountWon;          // amount won
1634         uint256 newPot;             // amount in new pot
1635         uint256 P3DAmount;          // amount distributed to p3d
1636         uint256 genAmount;          // amount distributed to gen
1637         uint256 potAmount;          // amount added to pot
1638     }
1639     struct Player {
1640         address addr;   // player address
1641         bytes32 name;   // player name
1642         uint256 win;    // winnings vault
1643         uint256 gen;    // general vault
1644         uint256 aff;    // affiliate vault
1645         uint256 lrnd;   // last round played
1646         uint256 laff;   // last affiliate id used
1647     }
1648     struct PlayerRounds {
1649         uint256 eth;    // eth player has added to round (used for eth limiter)
1650         uint256 keys;   // keys
1651         uint256 mask;   // player mask 
1652         uint256 ico;    // ICO phase investment
1653         uint256 affNum; // num of invite players in this round
1654     }
1655     struct Round {
1656         uint256 plyr;  // pIDs of player in lead,
1657         uint256 team;   // tID of team in lead
1658         uint256 end;    // time ends/ended
1659         bool ended;     // has round end function been ran
1660         uint256 strt;   // time round started
1661         uint256 keys;   // keys
1662         uint256 eth;    // total eth in
1663         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1664         uint256 mask;   // global mask
1665         uint256 ico;    // total eth sent in during ICO phase
1666         uint256 icoGen; // total eth for gen during ICO phase
1667         uint256 icoAvg; // average key price for ICO phase
1668         uint256 maxEthPID;   // pid who buy max eth
1669         uint256 maxAffPID;   // pid who invite max 
1670         uint256[3] plyrs;   // pIDs of player in lead, the first is newest
1671     }
1672     struct TeamFee {
1673         uint256 gen;    // % of buy in thats paid to key holders of current round
1674         // uint256 p3d;    // % of buy in thats paid to p3d holders
1675     }
1676     struct PotSplit {
1677         uint256 gen;    // % of pot thats paid to key holders of current round
1678         // uint256 p3d;    // % of pot thats paid to p3d holders
1679     }
1680 }
1681 
1682 //==============================================================================
1683 //  |  _      _ _ | _  .
1684 //  |<(/_\/  (_(_||(_  .
1685 //=======/======================================================================
1686 library F3DKeysCalcLong {
1687     using SafeMath for *;
1688     /**
1689      * @dev calculates number of keys received given X eth 
1690      * @param _curEth current amount of eth in contract 
1691      * @param _newEth eth being spent
1692      * @return amount of ticket purchased
1693      */
1694     function keysRec(uint256 _curEth, uint256 _newEth)
1695         internal
1696         pure
1697         returns (uint256)
1698     {
1699         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1700     }
1701     
1702     /**
1703      * @dev calculates amount of eth received if you sold X keys 
1704      * @param _curKeys current amount of keys that exist 
1705      * @param _sellKeys amount of keys you wish to sell
1706      * @return amount of eth received
1707      */
1708     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1709         internal
1710         pure
1711         returns (uint256)
1712     {
1713         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1714     }
1715 
1716     /**
1717      * @dev calculates how many keys would exist with given an amount of eth
1718      * @param _eth eth "in contract"
1719      * @return number of keys that would exist
1720      */
1721     function keys(uint256 _eth) 
1722         internal
1723         pure
1724         returns(uint256)
1725     {
1726         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1727     }
1728     
1729     /**
1730      * @dev calculates how much eth would be in contract given a number of keys
1731      * @param _keys number of keys "in contract" 
1732      * @return eth that would exists
1733      */
1734     function eth(uint256 _keys) 
1735         internal
1736         pure
1737         returns(uint256)  
1738     {
1739         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1740     }
1741 }
1742 
1743 //==============================================================================
1744 //  . _ _|_ _  _ |` _  _ _  _  .
1745 //  || | | (/_| ~|~(_|(_(/__\  .
1746 //==============================================================================
1747 // interface otherFoMo3D {
1748 //     function potSwap() external payable;
1749 // }
1750 
1751 interface F3DexternalSettingsInterface {
1752     function getFastGap() external returns(uint256);
1753     function getLongGap() external returns(uint256);
1754     function getFastExtra() external returns(uint256);
1755     function getLongExtra() external returns(uint256);
1756 }
1757 
1758 // interface DiviesInterface {
1759 //     function deposit() external payable;
1760 // }
1761 
1762 // interface JIincForwarderInterface {
1763 //     function deposit() external payable returns(bool);
1764 //     function status() external view returns(address, address, bool);
1765 //     function startMigration(address _newCorpBank) external returns(bool);
1766 //     function cancelMigration() external returns(bool);
1767 //     function finishMigration() external returns(bool);
1768 //     function setup(address _firstCorpBank) external;
1769 // }
1770 
1771 interface PlayerBookInterface {
1772     function getPlayerID(address _addr) external returns (uint256);
1773     function getPlayerName(uint256 _pID) external view returns (bytes32);
1774     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1775     function getPlayerAddr(uint256 _pID) external view returns (address);
1776     function getNameFee() external view returns (uint256);
1777     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1778     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1779     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1780 }
1781 
1782 
1783 library NameFilter {
1784     /**
1785      * @dev filters name strings
1786      * -converts uppercase to lower case.  
1787      * -makes sure it does not start/end with a space
1788      * -makes sure it does not contain multiple spaces in a row
1789      * -cannot be only numbers
1790      * -cannot start with 0x 
1791      * -restricts characters to A-Z, a-z, 0-9, and space.
1792      * @return reprocessed string in bytes32 format
1793      */
1794     function nameFilter(string _input)
1795         internal
1796         pure
1797         returns(bytes32)
1798     {
1799         bytes memory _temp = bytes(_input);
1800         uint256 _length = _temp.length;
1801         
1802         //sorry limited to 32 characters
1803         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1804         // make sure it doesnt start with or end with space
1805         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1806         // make sure first two characters are not 0x
1807         if (_temp[0] == 0x30)
1808         {
1809             require(_temp[1] != 0x78, "string cannot start with 0x");
1810             require(_temp[1] != 0x58, "string cannot start with 0X");
1811         }
1812         
1813         // create a bool to track if we have a non number character
1814         bool _hasNonNumber;
1815         
1816         // convert & check
1817         for (uint256 i = 0; i < _length; i++)
1818         {
1819             // if its uppercase A-Z
1820             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1821             {
1822                 // convert to lower case a-z
1823                 _temp[i] = byte(uint(_temp[i]) + 32);
1824                 
1825                 // we have a non number
1826                 if (_hasNonNumber == false)
1827                     _hasNonNumber = true;
1828             } else {
1829                 require
1830                 (
1831                     // require character is a space
1832                     _temp[i] == 0x20 || 
1833                     // OR lowercase a-z
1834                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1835                     // or 0-9
1836                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1837                     "string contains invalid characters"
1838                 );
1839                 // make sure theres not 2x spaces in a row
1840                 if (_temp[i] == 0x20)
1841                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1842                 
1843                 // see if we have a character other than a number
1844                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1845                     _hasNonNumber = true;    
1846             }
1847         }
1848         
1849         require(_hasNonNumber == true, "string cannot be only numbers");
1850         
1851         bytes32 _ret;
1852         assembly {
1853             _ret := mload(add(_temp, 32))
1854         }
1855         return (_ret);
1856     }
1857 }
1858 
1859 /**
1860  * @title SafeMath v0.1.9
1861  * @dev Math operations with safety checks that throw on error
1862  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1863  * - added sqrt
1864  * - added sq
1865  * - added pwr 
1866  * - changed asserts to requires with error log outputs
1867  * - removed div, its useless
1868  */
1869 library SafeMath {
1870     
1871     /**
1872     * @dev Multiplies two numbers, throws on overflow.
1873     */
1874     function mul(uint256 a, uint256 b) 
1875         internal 
1876         pure 
1877         returns (uint256 c) 
1878     {
1879         if (a == 0) {
1880             return 0;
1881         }
1882         c = a * b;
1883         require(c / a == b, "SafeMath mul failed");
1884         return c;
1885     }
1886 
1887     /**
1888     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1889     */
1890     function sub(uint256 a, uint256 b)
1891         internal
1892         pure
1893         returns (uint256) 
1894     {
1895         require(b <= a, "SafeMath sub failed");
1896         return a - b;
1897     }
1898 
1899     /**
1900     * @dev Adds two numbers, throws on overflow.
1901     */
1902     function add(uint256 a, uint256 b)
1903         internal
1904         pure
1905         returns (uint256 c) 
1906     {
1907         c = a + b;
1908         require(c >= a, "SafeMath add failed");
1909         return c;
1910     }
1911     
1912     /**
1913      * @dev gives square root of given x.
1914      */
1915     function sqrt(uint256 x)
1916         internal
1917         pure
1918         returns (uint256 y) 
1919     {
1920         uint256 z = ((add(x,1)) / 2);
1921         y = x;
1922         while (z < y) 
1923         {
1924             y = z;
1925             z = ((add((x / z),z)) / 2);
1926         }
1927     }
1928     
1929     /**
1930      * @dev gives square. multiplies x by x
1931      */
1932     function sq(uint256 x)
1933         internal
1934         pure
1935         returns (uint256)
1936     {
1937         return (mul(x,x));
1938     }
1939     
1940     /**
1941      * @dev x to the power of y 
1942      */
1943     function pwr(uint256 x, uint256 y)
1944         internal 
1945         pure 
1946         returns (uint256)
1947     {
1948         if (x==0)
1949             return (0);
1950         else if (y==0)
1951             return (1);
1952         else 
1953         {
1954             uint256 z = x;
1955             for (uint256 i=1; i < y; i++)
1956                 z = mul(z,x);
1957             return (z);
1958         }
1959     }
1960 }