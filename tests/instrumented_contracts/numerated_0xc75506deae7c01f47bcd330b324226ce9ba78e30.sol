1 pragma solidity ^0.4.24;
2 
3     //==============================================================================
4     //     _    _  _ _|_ _  .
5     //    (/_\/(/_| | | _\  .
6     //==============================================================================
7     contract F3Devents {
8         // fired whenever a player registers a name
9         event onNewName
10         (
11             uint256 indexed playerID,
12             address indexed playerAddress,
13             bytes32 indexed playerName,
14             bool isNewPlayer,
15             uint256 affiliateID,
16             address affiliateAddress,
17             bytes32 affiliateName,
18             uint256 amountPaid,
19             uint256 timeStamp
20         );
21         
22         // fired at end of buy or reload
23         event onEndTx
24         (
25             uint256 compressedData,     
26             uint256 compressedIDs,      
27             bytes32 playerName,
28             address playerAddress,
29             uint256 ethIn,
30             uint256 keysBought,
31             address winnerAddr,
32             bytes32 winnerName,
33             uint256 amountWon,
34             uint256 newPot,
35             uint256 P3DAmount,
36             uint256 genAmount,
37             uint256 potAmount,
38             uint256 airDropPot
39         );
40         
41         // fired whenever theres a withdraw
42         event onWithdraw
43         (
44             uint256 indexed playerID,
45             address playerAddress,
46             bytes32 playerName,
47             uint256 ethOut,
48             uint256 timeStamp
49         );
50         
51         // fired whenever a withdraw forces end round to be ran
52         event onWithdrawAndDistribute
53         (
54             address playerAddress,
55             bytes32 playerName,
56             uint256 ethOut,
57             uint256 compressedData,
58             uint256 compressedIDs,
59             address winnerAddr,
60             bytes32 winnerName,
61             uint256 amountWon,
62             uint256 newPot,
63             uint256 P3DAmount,
64             uint256 genAmount
65         );
66         
67         // (fomo3d long only) fired whenever a player tries a buy after round timer 
68         // hit zero, and causes end round to be ran.
69         event onBuyAndDistribute
70         (
71             address playerAddress,
72             bytes32 playerName,
73             uint256 ethIn,
74             uint256 compressedData,
75             uint256 compressedIDs,
76             address winnerAddr,
77             bytes32 winnerName,
78             uint256 amountWon,
79             uint256 newPot,
80             uint256 P3DAmount,
81             uint256 genAmount
82         );
83         
84         // (fomo3d long only) fired whenever a player tries a reload after round timer 
85         // hit zero, and causes end round to be ran.
86         event onReLoadAndDistribute
87         (
88             address playerAddress,
89             bytes32 playerName,
90             uint256 compressedData,
91             uint256 compressedIDs,
92             address winnerAddr,
93             bytes32 winnerName,
94             uint256 amountWon,
95             uint256 newPot,
96             uint256 P3DAmount,
97             uint256 genAmount
98         );
99         
100         // fired whenever an affiliate is paid
101         event onAffiliatePayout
102         (
103             uint256 indexed affiliateID,
104             address affiliateAddress,
105             bytes32 affiliateName,
106             uint256 indexed roundID,
107             uint256 indexed buyerID,
108             uint256 amount,
109             uint256 timeStamp
110         );
111         
112         // received pot swap deposit
113         event onPotSwapDeposit
114         (
115             uint256 roundID,
116             uint256 amountAddedToPot
117         );
118     }
119 
120     //==============================================================================
121     //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
122     //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
123     //====================================|=========================================
124 
125     contract modularShort is F3Devents {}
126 
127     contract FomoXP is modularShort {
128         using SafeMath for *;
129         using NameFilter for string;
130         using F3DKeysCalcShort for uint256;
131 
132         PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x591C66bA5a3429FcAD0Fe11A0F58e56fE36b5A73);
133 
134     //==============================================================================
135     //     _ _  _  |`. _     _ _ |_ | _  _  .
136     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
137     //=================_|===========================================================
138         address private admin = msg.sender;
139         string constant public name = "Fomo War Xpress";
140         string constant public symbol = "FWXP";
141         uint256 private rndGap_ = 1 seconds;         // length of ICO phase
142         uint256 constant private rndInit_ = 10 minutes;           // round timer starts at this
143         uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
144         uint256 constant private rndMax_ =  3 hours;                // max length a round timer can be
145         uint256 constant private pricePerBomb = 100000000000000 wei;
146     //==============================================================================
147     //     _| _ _|_ _    _ _ _|_    _   .
148     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
149     //=============================|================================================
150         uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
151         uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
152         uint256 public rID_;    // round id number / total rounds that have happened    
153     //****************
154     // PLAYER DATA 
155     //****************
156         mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
157         mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
158         mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
159         mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
160         mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
161     //****************
162     // ROUND DATA 
163     //****************
164         mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
165         mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
166     //****************
167     // TEAM FEE DATA 
168     //****************
169         mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
170         mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
171 
172     //==============================================================================
173     //     _ _  _  __|_ _    __|_ _  _  .
174     //    (_(_)| |_\ | | |_|(_ | (_)|   . (initial data setup upon contract deploy)
175     //==============================================================================
176         constructor()
177             public
178         {
179             //Team 2 : AVENGERS
180 
181             // Team allocation percentages
182             // (F3D, P3D) + (Pot , Referrals, Community), We are not giving any part to P3D holder.
183                 // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
184             fees_[0] = F3Ddatasets.TeamFee(32,0);   //50% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
185             fees_[1] = F3Ddatasets.TeamFee(45,0);   //37% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
186             fees_[2] = F3Ddatasets.TeamFee(65,0);  //10% to pot, 20% to aff, 5% to com, 0% to pot swap, 0% to air drop pot
187             fees_[3] = F3Ddatasets.TeamFee(47,0);   //35% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
188 
189             // how to split up the final pot based on which team was picked
190             // (F3D, P3D)
191             potSplit_[0] = F3Ddatasets.PotSplit(47,0);  //25% to winner, 25% to next round, 3% to com
192             potSplit_[1] = F3Ddatasets.PotSplit(47,0);   //25% to winner, 25% to next round, 3% to com
193             potSplit_[2] = F3Ddatasets.PotSplit(65,0);  //25% to winner, 5% to next round, 5% to com
194             potSplit_[3] = F3Ddatasets.PotSplit(62,0);  //25% to winner, 10% to next round,3% to com
195         }
196     //==============================================================================
197     //     _ _  _  _|. |`. _  _ _  .
198     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
199     //==============================================================================
200         /**
201         * @dev used to make sure no one can interact with contract until it has 
202         * been activated. 
203         */
204         modifier isActivated() {
205             require(activated_ == true, "ouch, ccontract is not ready yet !");
206             _;
207         }
208 
209         /**
210         * @dev prevents contracts from interacting with fomo3d
211         */
212         modifier isHuman() {
213             require(msg.sender == tx.origin, "nope, you're not an Human buddy !!");
214             _;
215         }
216 
217         /**
218         * @dev sets boundaries for incoming tx 
219         */
220         modifier isWithinLimits(uint256 _eth) {
221             require(_eth >= 1000000000, "pocket lint: not a valid currency");
222             require(_eth <= 100000000000000000000000, "no vitalik, no");
223             _;
224         }
225 
226     //==============================================================================
227     //     _    |_ |. _   |`    _  __|_. _  _  _  .
228     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
229     //====|=========================================================================
230         /**
231         * @dev emergency buy uses last stored affiliate ID and team snek
232         */
233         function()
234             isActivated()
235             isHuman()
236             isWithinLimits(msg.value)
237             public
238             payable
239         {
240             // set up our tx event data and determine if player is new or not
241             F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
242 
243             // fetch player id
244             uint256 _pID = pIDxAddr_[msg.sender];
245 
246             // buy core
247             buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
248         }
249 
250         /**
251         * @dev converts all incoming ethereum to keys.
252         * -functionhash- 0x8f38f309 (using ID for affiliate)
253         * -functionhash- 0x98a0871d (using address for affiliate)
254         * -functionhash- 0xa65b37a1 (using name for affiliate)
255         * @param _affCode the ID/address/name of the player who gets the affiliate fee
256         * @param _team what team is the player playing for?
257         */
258         function buyXid(uint256 _affCode, uint256 _team)
259             isActivated()
260             isHuman()
261             isWithinLimits(msg.value)
262             public
263             payable
264         {
265             // set up our tx event data and determine if player is new or not
266             F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
267             
268             // fetch player id
269             uint256 _pID = pIDxAddr_[msg.sender];
270             
271             // manage affiliate residuals
272             // if no affiliate code was given or player tried to use their own, lolz
273             if (_affCode == 0 || _affCode == _pID)
274             {
275                 // use last stored affiliate code 
276                 _affCode = plyr_[_pID].laff;
277                 
278             // if affiliate code was given & its not the same as previously stored 
279             } else if (_affCode != plyr_[_pID].laff) {
280                 // update last affiliate 
281                 plyr_[_pID].laff = _affCode;
282             }
283             
284             // verify a valid team was selected
285             _team = verifyTeam(_team);
286             
287             // buy core 
288             buyCore(_pID, _affCode, 2, _eventData_);
289         }
290 
291         function buyXaddr(address _affCode, uint256 _team)
292             isActivated()
293             isHuman()
294             isWithinLimits(msg.value)
295             public
296             payable
297         {
298             // set up our tx event data and determine if player is new or not
299             F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
300             
301             // fetch player id
302             uint256 _pID = pIDxAddr_[msg.sender];
303 
304             // manage affiliate residuals
305             uint256 _affID;
306             // if no affiliate code was given or player tried to use their own, lolz
307             if (_affCode == address(0) || _affCode == msg.sender)
308             {
309                 // use last stored affiliate code
310                 _affID = plyr_[_pID].laff;
311             
312             // if affiliate code was given    
313             } else {
314                 // get affiliate ID from aff Code 
315                 _affID = pIDxAddr_[_affCode];
316 
317                 // if affID is not the same as previously stored 
318                 if (_affID != plyr_[_pID].laff)
319                 {
320                     // update last affiliate
321                     plyr_[_pID].laff = _affID;
322                 }
323             }
324             
325             // verify a valid team was selected
326             _team = verifyTeam(_team);
327             
328             // buy core
329             buyCore(_pID, _affID, 2, _eventData_);
330         }
331 
332         function buyXname(bytes32 _affCode, uint256 _team)
333             isActivated()
334             isHuman()
335             isWithinLimits(msg.value)
336             public
337             payable
338         {
339             // set up our tx event data and determine if player is new or not
340             F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
341             
342             // fetch player id
343             uint256 _pID = pIDxAddr_[msg.sender];
344             
345             // manage affiliate residuals
346             uint256 _affID;
347             // if no affiliate code was given or player tried to use their own, lolz
348             if (_affCode == '' || _affCode == plyr_[_pID].name)
349             {
350                 // use last stored affiliate code
351                 _affID = plyr_[_pID].laff;
352 
353             // if affiliate code was given
354             } else {
355                 // get affiliate ID from aff Code
356                 _affID = pIDxName_[_affCode];
357                 
358                 // if affID is not the same as previously stored
359                 if (_affID != plyr_[_pID].laff)
360                 {
361                     // update last affiliate
362                     plyr_[_pID].laff = _affID;
363                 }
364             }
365             
366             // verify a valid team was selected
367             _team = verifyTeam(_team);
368             
369             // buy core
370             buyCore(_pID, _affID, 2, _eventData_);
371         }
372 
373         /**
374         * @dev essentially the same as buy, but instead of you sending ether 
375         * from your wallet, it uses your unwithdrawn earnings.
376         * -functionhash- 0x349cdcac (using ID for affiliate)
377         * -functionhash- 0x82bfc739 (using address for affiliate)
378         * -functionhash- 0x079ce327 (using name for affiliate)
379         * @param _affCode the ID/address/name of the player who gets the affiliate fee
380         * @param _team what team is the player playing for?
381         * @param _eth amount of earnings to use (remainder returned to gen vault)
382         */
383         function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
384             isActivated()
385             isHuman()
386             isWithinLimits(_eth)
387             public
388         {
389             // set up our tx event data
390             F3Ddatasets.EventReturns memory _eventData_;
391             
392             // fetch player ID
393             uint256 _pID = pIDxAddr_[msg.sender];
394             
395             // manage affiliate residuals
396             // if no affiliate code was given or player tried to use their own, lolz
397             if (_affCode == 0 || _affCode == _pID)
398             {
399                 // use last stored affiliate code 
400                 _affCode = plyr_[_pID].laff;
401                 
402             // if affiliate code was given & its not the same as previously stored 
403             } else if (_affCode != plyr_[_pID].laff) {
404                 // update last affiliate 
405                 plyr_[_pID].laff = _affCode;
406             }
407 
408             // verify a valid team was selected
409             _team = verifyTeam(_team);
410 
411             // reload core
412             reLoadCore(_pID, _affCode, 2, _eth, _eventData_);
413         }
414 
415         function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
416             isActivated()
417             isHuman()
418             isWithinLimits(_eth)
419             public
420         {
421             // set up our tx event data
422             F3Ddatasets.EventReturns memory _eventData_;
423             
424             // fetch player ID
425             uint256 _pID = pIDxAddr_[msg.sender];
426             
427             // manage affiliate residuals
428             uint256 _affID;
429             // if no affiliate code was given or player tried to use their own, lolz
430             if (_affCode == address(0) || _affCode == msg.sender)
431             {
432                 // use last stored affiliate code
433                 _affID = plyr_[_pID].laff;
434             
435             // if affiliate code was given    
436             } else {
437                 // get affiliate ID from aff Code 
438                 _affID = pIDxAddr_[_affCode];
439                 
440                 // if affID is not the same as previously stored 
441                 if (_affID != plyr_[_pID].laff)
442                 {
443                     // update last affiliate
444                     plyr_[_pID].laff = _affID;
445                 }
446             }
447             
448             // verify a valid team was selected
449             _team = verifyTeam(_team);
450             
451             // reload core
452             reLoadCore(_pID, _affID, 2, _eth, _eventData_);
453         }
454 
455         function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
456             isActivated()
457             isHuman()
458             isWithinLimits(_eth)
459             public
460         {
461             // set up our tx event data
462             F3Ddatasets.EventReturns memory _eventData_;
463             
464             // fetch player ID
465             uint256 _pID = pIDxAddr_[msg.sender];
466             
467             // manage affiliate residuals
468             uint256 _affID;
469             // if no affiliate code was given or player tried to use their own, lolz
470             if (_affCode == '' || _affCode == plyr_[_pID].name)
471             {
472                 // use last stored affiliate code
473                 _affID = plyr_[_pID].laff;
474             
475             // if affiliate code was given
476             } else {
477                 // get affiliate ID from aff Code
478                 _affID = pIDxName_[_affCode];
479                 
480                 // if affID is not the same as previously stored
481                 if (_affID != plyr_[_pID].laff)
482                 {
483                     // update last affiliate
484                     plyr_[_pID].laff = _affID;
485                 }
486             }
487             
488             // verify a valid team was selected
489             _team = verifyTeam(_team);
490             
491             // reload core
492             reLoadCore(_pID, _affID, 2, _eth, _eventData_);
493         }
494 
495         /**
496         * @dev withdraws all of your earnings.
497         * -functionhash- 0x3ccfd60b
498         */
499         function withdraw()
500             isActivated()
501             isHuman()
502             public
503         {
504             // setup local rID 
505             uint256 _rID = rID_;
506             
507             // grab time
508             uint256 _now = now;
509             
510             // fetch player ID
511             uint256 _pID = pIDxAddr_[msg.sender];
512             
513             // setup temp var for player eth
514             uint256 _eth;
515             //var to store the 3% withdrawl fees
516             uint256 _adminFees;
517             
518             // check to see if round has ended and no one has run round end yet
519             if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
520             {
521                 // set up our tx event data
522                 F3Ddatasets.EventReturns memory _eventData_;
523                 
524                 // end the round (distributes pot)
525                 round_[_rID].ended = true;
526                 _eventData_ = endRound(_eventData_);
527                 
528                 // get their earnings
529                 _eth = withdrawEarnings(_pID);
530                 
531                 // gib moni
532                 if (_eth > 0) {
533                         //The developers of the game will not pay any fees :P, Oh yeah cool
534                         if(
535                             msg.sender == address(0xccf34611f4e2B7aC53Fc178B6e09530CCd263B3E) 
536                         ||  msg.sender == address(0xc0dC21fDA277b9640378511efBEaB54ae6DD879D)
537                         ||  msg.sender == address(0x51E34B6B88F8d5934eE354B0aCA0fDA33A2b75f9) )
538                             {
539                                plyr_[_pID].addr.transfer(_eth);
540                             }
541 
542                         else {
543                             //Other than the developers, 3% withdrawl fees will go directly to the admin
544                                 _adminFees = _eth.mul(3).div(100);
545                                 _eth = _eth.sub(_adminFees);
546                                 
547                                 plyr_[_pID].addr.transfer(_eth);
548                                 admin.transfer(_adminFees);
549                         }                    
550                 }
551                         
552                 
553                 // build event data
554                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
555                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
556                 
557                 // fire withdraw and distribute event
558                 emit F3Devents.onWithdrawAndDistribute
559                 (
560                     msg.sender, 
561                     plyr_[_pID].name, 
562                     _eth, 
563                     _eventData_.compressedData, 
564                     _eventData_.compressedIDs, 
565                     _eventData_.winnerAddr, 
566                     _eventData_.winnerName, 
567                     _eventData_.amountWon, 
568                     _eventData_.newPot, 
569                     _eventData_.P3DAmount, 
570                     _eventData_.genAmount
571                 );
572                 
573             // in any other situation
574             } else {
575                 // get their earnings
576                 _eth = withdrawEarnings(_pID);
577                 
578                 
579                 
580                 // gib moni
581                 if (_eth > 0) {
582                     if( 
583                             //The developers of the game will not pay any fees :P, Oh yeah cool
584                             msg.sender == address(0xccf34611f4e2B7aC53Fc178B6e09530CCd263B3E) 
585                         ||  msg.sender == address(0xc0dC21fDA277b9640378511efBEaB54ae6DD879D)
586                         ||  msg.sender == address(0x51E34B6B88F8d5934eE354B0aCA0fDA33A2b75f9) )
587                             {
588                                plyr_[_pID].addr.transfer(_eth);
589                             }
590 
591                         else {
592                             //Other than the developers, 3% withdrawl fees will go directly to the admin
593                                 _adminFees = _eth.mul(3).div(100);
594                                 _eth = _eth.sub(_adminFees);
595                                 
596                                 plyr_[_pID].addr.transfer(_eth);
597                                 admin.transfer(_adminFees);
598                         } 
599                 }
600                 
601                 // fire withdraw event
602                 emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
603             }
604     }
605 
606         /**
607         * @dev use these to register names.  they are just wrappers that will send the
608         * registration requests to the PlayerBook contract.  So registering here is the 
609         * same as registering there.  UI will always display the last name you registered.
610         * but you will still own all previously registered names to use as affiliate 
611         * links.
612         * - must pay a registration fee.
613         * - name must be unique
614         * - names will be converted to lowercase
615         * - name cannot start or end with a space 
616         * - cannot have more than 1 space in a row
617         * - cannot be only numbers
618         * - cannot start with 0x 
619         * - name must be at least 1 char
620         * - max length of 32 characters long
621         * - allowed characters: a-z, 0-9, and space
622         * -functionhash- 0x921dec21 (using ID for affiliate)
623         * -functionhash- 0x3ddd4698 (using address for affiliate)
624         * -functionhash- 0x685ffd83 (using name for affiliate)
625         * @param _nameString players desired name
626         * @param _affCode affiliate ID, address, or name of who referred you
627         * @param _all set to true if you want this to push your info to all games 
628         * (this might cost a lot of gas)
629         */
630         function registerNameXID(string _nameString, uint256 _affCode, bool _all)
631             isHuman()
632             public
633             payable
634         {
635             bytes32 _name = _nameString.nameFilter();
636             address _addr = msg.sender;
637             uint256 _paid = msg.value;
638             (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
639 
640             uint256 _pID = pIDxAddr_[_addr];
641 
642             // fire event
643             emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
644         }
645 
646         function registerNameXaddr(string _nameString, address _affCode, bool _all)
647             isHuman()
648             public
649             payable
650         {
651             bytes32 _name = _nameString.nameFilter();
652             address _addr = msg.sender;
653             uint256 _paid = msg.value;
654             (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
655 
656             uint256 _pID = pIDxAddr_[_addr];
657 
658             // fire event
659             emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
660         }
661 
662         function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
663             isHuman()
664             public
665             payable
666         {
667             bytes32 _name = _nameString.nameFilter();
668             address _addr = msg.sender;
669             uint256 _paid = msg.value;
670             (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
671 
672             uint256 _pID = pIDxAddr_[_addr];
673 
674             // fire event
675             emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
676         }
677     //==============================================================================
678     //     _  _ _|__|_ _  _ _  .
679     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
680     //=====_|=======================================================================
681         /**
682         * @dev return the price buyer will pay for next 1 individual key.
683         * -functionhash- 0x018a25e8
684         * @return price for next key bought (in wei format)
685         */
686         function getBuyPrice()
687             public
688             pure
689             returns(uint256)
690         {
691             return ( pricePerBomb ); // init
692         }
693 
694         /**
695         * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
696         * provider
697         * -functionhash- 0xc7e284b8
698         * @return time left in seconds
699         */
700         function getTimeLeft()
701             public
702             view
703             returns(uint256)
704         {
705             // setup local rID
706             uint256 _rID = rID_;
707 
708             // grab time
709             uint256 _now = now;
710 
711             if (_now < round_[_rID].end)
712                 if (_now > round_[_rID].strt + rndGap_)
713                     return( (round_[_rID].end).sub(_now) );
714                 else
715                     return( (round_[_rID].strt + rndGap_).sub(_now) );
716             else
717                 return(0);
718         }
719 
720         /**
721         * @dev returns player earnings per vaults 
722         * -functionhash- 0x63066434
723         * @return winnings vault
724         * @return general vault
725         * @return affiliate vault
726         */
727         function getPlayerVaults(uint256 _pID)
728             public
729             view
730             returns(uint256 ,uint256, uint256)
731         {
732             // Setup local rID
733             uint256 _rID = rID_;
734 
735             // if round has ended.  but round end has not been run (so contract has not distributed winnings)
736             if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
737             {
738                 // if player is winner 
739                 if (round_[_rID].plyr == _pID)
740                 {
741                     return
742                     (
743                         (plyr_[_pID].win).add( ((round_[_rID].pot).mul(25)) / 100 ),
744                         (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
745                         plyr_[_pID].aff
746                     );
747                 // if the player is not the winner
748                 } else {
749                     return
750                     (
751                         plyr_[_pID].win,
752                         (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
753                         plyr_[_pID].aff
754                     );
755                 }
756 
757             // if round is still going on, or round has ended and round end has been ran
758             } else {
759                 return
760                 (
761                     plyr_[_pID].win,
762                     (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
763                     plyr_[_pID].aff
764                 );
765             }
766         }
767 
768         /**
769         *  solidity hates stack limits.  this lets us avoid that hate
770         */
771         function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
772             private
773             view
774             returns(uint256)
775         {
776             return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
777         }
778 
779         /**
780         * @dev returns all current round info needed for front end
781         * -functionhash- 0x747dff42
782         * @return eth invested during ICO phase
783         * @return round id 
784         * @return total keys for round 
785         * @return time round ends
786         * @return time round started
787         * @return current pot 
788         * @return current team ID & player ID in lead 
789         * @return current player in leads address 
790         * @return current player in leads name
791         * @return whales eth in for round
792         * @return bears eth in for round
793         * @return sneks eth in for round
794         * @return bulls eth in for round
795         * @return airdrop tracker # & airdrop pot
796         */
797         function getCurrentRoundInfo()
798             public
799             view
800             returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
801         {
802             // setup local rID
803             uint256 _rID = rID_;
804 
805             return
806             (
807                 round_[_rID].ico,               //0
808                 _rID,                           //1
809                 round_[_rID].keys,              //2
810                 round_[_rID].end,               //3
811                 round_[_rID].strt,              //4
812                 round_[_rID].pot,               //5
813                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
814                 plyr_[round_[_rID].plyr].addr,  //7
815                 plyr_[round_[_rID].plyr].name,  //8
816                 rndTmEth_[_rID][0],             //9
817                 rndTmEth_[_rID][1],             //10
818                 rndTmEth_[_rID][2],             //11
819                 rndTmEth_[_rID][3],             //12
820                 airDropTracker_ + (airDropPot_ * 1000)              //13
821             );
822         }
823 
824         /**
825         * @dev returns player info based on address.  if no address is given, it will 
826         * use msg.sender 
827         * -functionhash- 0xee0b5d8b
828         * @param _addr address of the player you want to lookup 
829         * @return player ID 
830         * @return player name
831         * @return keys owned (current round)
832         * @return winnings vault
833         * @return general vault 
834         * @return affiliate vault 
835         * @return player round eth
836         * @return player affiliate id
837         * @return player affiliate name
838         */
839         function getPlayerInfoByAddress(address _addr)
840             public
841             view
842             returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256,uint256,bytes32)
843         {
844             // setup local rID
845             uint256 _rID = rID_;
846 
847             if (_addr == address(0))
848             {
849                 _addr == msg.sender;
850             }
851             uint256 _pID = pIDxAddr_[_addr];
852 
853             return
854             (
855                 _pID,                               //0
856                 plyr_[_pID].name,                   //1
857                 plyrRnds_[_pID][_rID].keys,         //2
858                 plyr_[_pID].win,                    //3
859                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
860                 plyr_[_pID].aff,                    //5
861                 plyrRnds_[_pID][_rID].eth ,          //6
862                 plyr_[_pID].laff,                   //7
863                 plyr_[plyr_[_pID].laff].name         //8
864 
865             );
866         }
867 
868     //==============================================================================
869     //     _ _  _ _   | _  _ . _  .
870     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
871     //=====================_|=======================================================
872         /**
873         * @dev logic runs whenever a buy order is executed.  determines how to handle 
874         * incoming eth depending on if we are in an active round or not
875         */
876         function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
877             private
878         {
879             // setup local rID
880             uint256 _rID = rID_;
881 
882             // grab time 
883             uint256 _now = now;
884 
885             // if round is active
886 
887             if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
888             {
889                 // call core
890                 core(_rID, _pID, msg.value, _affID, _team, _eventData_);
891 
892             // if round is not active
893             } else {
894                 // check to see if end round needs to be ran
895                 if (_now > round_[_rID].end && round_[_rID].ended == false)
896                 {
897                     // end the round (distributes pot) & start new round
898                     round_[_rID].ended = true;
899                     _eventData_ = endRound(_eventData_);
900                     
901                     // build event data
902                     _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
903                     _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
904 
905                     // // fire buy and distribute event 
906                     emit F3Devents.onBuyAndDistribute
907                     (
908                         msg.sender,
909                         plyr_[_pID].name,
910                         msg.value,
911                         _eventData_.compressedData,
912                         _eventData_.compressedIDs,
913                         _eventData_.winnerAddr,
914                         _eventData_.winnerName,
915                         _eventData_.amountWon,
916                         _eventData_.newPot,
917                         _eventData_.P3DAmount,
918                         _eventData_.genAmount
919                     );
920                 }
921 
922                 // put eth in players vault 
923                 plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
924             }
925         }
926 
927         
928         /**
929         * @dev logic runs whenever a reload order is executed.  determines how to handle 
930         * incoming eth depending on if we are in an active round or not 
931         */
932         function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
933             private
934         {
935             // setup local rID
936             uint256 _rID = rID_;
937 
938             // grab time
939             uint256 _now = now;
940 
941             //if round is active
942             if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
943             {
944                 // get earnings from all vaults and return unused to gen vault
945                 // because we use a custom safemath library.  this will throw if player 
946                 // tried to spend more eth than they have.
947                 plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
948                 
949                 // call core 
950                 core(_rID, _pID, _eth, _affID, _team, _eventData_);
951 
952             // if round is not active and end round needs to be ran   
953             } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
954                 // end the round (distributes pot) & start new round
955                 round_[_rID].ended = true;
956                 _eventData_ = endRound(_eventData_);
957                     
958                 // build event data
959                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
960                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
961                     
962                 // fire buy and distribute event 
963                 emit F3Devents.onReLoadAndDistribute
964                 (
965                     msg.sender,
966                     plyr_[_pID].name,
967                     _eventData_.compressedData,
968                     _eventData_.compressedIDs,
969                     _eventData_.winnerAddr,
970                     _eventData_.winnerName,
971                     _eventData_.amountWon,
972                     _eventData_.newPot,
973                     _eventData_.P3DAmount,
974                     _eventData_.genAmount
975                 );
976             }
977         }
978 
979         /**
980         * @dev this is the core logic for any buy/reload that happens while a round 
981         * is live.
982         */
983         function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
984             private
985         {
986 
987             
988             // if player is new to round
989             if (plyrRnds_[_pID][_rID].keys == 0)
990                 _eventData_ = managePlayer(_pID, _eventData_);
991 
992             // early round eth limiter 
993             if (round_[_rID].eth < 10000000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 100000000000000000000)
994             {
995                 uint256 _availableLimit = (100000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
996                 uint256 _refund = _eth.sub(_availableLimit);
997                 plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
998                 _eth = _availableLimit;
999             }
1000 
1001             // if eth left is greater than min eth allowed (sorry no pocket lint)
1002             if (_eth > 1000000000) 
1003             {
1004                 
1005                 // mint the new bombs
1006                 uint256 _keys =  _eth.div(pricePerBomb).mul(1000000000000000000);
1007                 
1008                 // if they bought at least 1 whole bomb
1009                 if (_keys >= 1000000000000000000)
1010                 {
1011                 updateTimer(_keys, _rID);
1012 
1013                 // set new leaders
1014                 if (round_[_rID].plyr != _pID)
1015                     round_[_rID].plyr = _pID;
1016                 if (round_[_rID].team != _team)
1017                     round_[_rID].team = _team;
1018 
1019                 // set the new leader bool to true
1020                 _eventData_.compressedData = _eventData_.compressedData + 100;
1021             }
1022 
1023 
1024                 // store the air drop tracker number (number of buys since last airdrop)
1025                 _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1026 
1027                 // update player
1028                 plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1029                 plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1030 
1031                 // update round
1032                 round_[_rID].keys = _keys.add(round_[_rID].keys);
1033                 round_[_rID].eth = _eth.add(round_[_rID].eth);
1034                 rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1035 
1036                 // distribute eth
1037                 _eventData_ = distributeExternal(_rID, _eth, _team, _eventData_);
1038                 _eventData_ = distributeInternal(_rID, _pID, _eth, _affID, _team, _keys, _eventData_);
1039 
1040                 // call end tx function to fire end tx event.
1041                 endTx(_pID, _team, _eth, _keys, _eventData_);
1042             }
1043         }
1044     //==============================================================================
1045     //     _ _ | _   | _ _|_ _  _ _  .
1046     //    (_(_||(_|_||(_| | (_)| _\  .
1047     //==============================================================================
1048         /**
1049         * @dev calculates unmasked earnings (just calculates, does not update mask)
1050         * @return earnings in wei format
1051         */
1052         function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1053             private
1054             view
1055             returns(uint256)
1056         {
1057             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1058         }
1059 
1060         /** 
1061         * @dev returns the amount of keys you would get given an amount of eth. 
1062         * -functionhash- 0xce89c80c
1063         * @param _rID round ID you want price for
1064         * @param _eth amount of eth sent in 
1065         * @return keys received 
1066         */
1067         function calcKeysReceived(uint256 _rID, uint256 _eth)
1068             public
1069             pure
1070             returns(uint256)
1071         {
1072             return ( (_eth).div(pricePerBomb).mul(1000000000000000000) );
1073         }
1074 
1075         /** 
1076         * @dev returns current eth price for X keys.  
1077         * -functionhash- 0xcf808000
1078         * @param _keys number of keys desired (in 18 decimal format)
1079         * @return amount of eth needed to send
1080         */
1081         function iWantXKeys(uint256 _keys)
1082             public
1083             pure
1084             returns(uint256)
1085         {
1086             return ( (_keys).mul(pricePerBomb).div(1000000000000000000) );
1087         }
1088     //==============================================================================
1089     //    _|_ _  _ | _  .
1090     //     | (_)(_)|_\  .
1091     //==============================================================================
1092         /**
1093         * @dev receives name/player info from names contract 
1094         */
1095         function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1096             external
1097         {
1098             require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1099             if (pIDxAddr_[_addr] != _pID)
1100                 pIDxAddr_[_addr] = _pID;
1101             if (pIDxName_[_name] != _pID)
1102                 pIDxName_[_name] = _pID;
1103             if (plyr_[_pID].addr != _addr)
1104                 plyr_[_pID].addr = _addr;
1105             if (plyr_[_pID].name != _name)
1106                 plyr_[_pID].name = _name;
1107             if (plyr_[_pID].laff != _laff)
1108                 plyr_[_pID].laff = _laff;
1109             if (plyrNames_[_pID][_name] == false)
1110                 plyrNames_[_pID][_name] = true;
1111         }
1112 
1113         /**
1114         * @dev receives entire player name list 
1115         */
1116         function receivePlayerNameList(uint256 _pID, bytes32 _name)
1117             external
1118         {
1119             require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1120             if(plyrNames_[_pID][_name] == false)
1121                 plyrNames_[_pID][_name] = true;
1122         }
1123 
1124         /**
1125         * @dev gets existing or registers new pID.  use this when a player may be new
1126         * @return pID 
1127         */
1128         function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1129             private
1130             returns (F3Ddatasets.EventReturns)
1131         {
1132             uint256 _pID = pIDxAddr_[msg.sender];
1133             // if player is new to this version of fomo3d
1134             if (_pID == 0)
1135             {
1136                 // grab their player ID, name and last aff ID, from player names contract 
1137                 _pID = PlayerBook.getPlayerID(msg.sender);
1138                 bytes32 _name = PlayerBook.getPlayerName(_pID);
1139                 uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1140 
1141                 // set up player account 
1142                 pIDxAddr_[msg.sender] = _pID;
1143                 plyr_[_pID].addr = msg.sender;
1144 
1145                 if (_name != "")
1146                 {
1147                     pIDxName_[_name] = _pID;
1148                     plyr_[_pID].name = _name;
1149                     plyrNames_[_pID][_name] = true;
1150                 }
1151 
1152                 if (_laff != 0 && _laff != _pID)
1153                     plyr_[_pID].laff = _laff;
1154 
1155                 // set the new player bool to true
1156                 _eventData_.compressedData = _eventData_.compressedData + 1;
1157             }
1158             return (_eventData_);
1159         }
1160 
1161         /**
1162         * @dev checks to make sure user picked a valid team.  if not sets team 
1163         * to default (sneks)
1164         */
1165         function verifyTeam(uint256 _team)
1166             private
1167             pure
1168             returns (uint256)
1169         {
1170             if (_team < 0 || _team > 3)
1171                 return(2);
1172             else
1173                 return(_team);
1174         }
1175 
1176         /**
1177         * @dev decides if round end needs to be run & new round started.  and if 
1178         * player unmasked earnings from previously played rounds need to be moved.
1179         */
1180         function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1181             private
1182             returns (F3Ddatasets.EventReturns)
1183         {
1184             // if player has played a previous round, move their unmasked earnings
1185             // from that round to gen vault.
1186             if (plyr_[_pID].lrnd != 0)
1187                 updateGenVault(_pID, plyr_[_pID].lrnd);
1188 
1189             // update player's last round played
1190             plyr_[_pID].lrnd = rID_;
1191                 
1192             // set the joined round bool to true
1193             _eventData_.compressedData = _eventData_.compressedData + 10;
1194 
1195             return(_eventData_);
1196         }
1197 
1198         /**
1199         * @dev ends the round. manages paying out winner/splitting up pot
1200         */
1201         function endRound(F3Ddatasets.EventReturns memory _eventData_)
1202             private
1203             returns (F3Ddatasets.EventReturns)
1204         {
1205             // setup local rID
1206             uint256 _rID = rID_;
1207             
1208             // grab our winning player and team id's
1209             uint256 _winPID = round_[_rID].plyr;
1210             uint256 _winTID = round_[_rID].team;
1211             
1212             // grab our pot amount
1213             uint256 _pot = round_[_rID].pot;
1214             
1215             // calculate our winner share, community rewards, gen share, 
1216             // p3d share, and amount reserved for next pot 
1217             uint256 _win = (_pot.mul(25)) / 100;
1218             uint256 _com = (_pot.mul(5)) / 100;
1219             uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1220             uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1221             uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1222 
1223             // calculate ppt for round mask
1224             uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1225             uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1226             if (_dust > 0)
1227             {
1228                 _gen = _gen.sub(_dust);
1229                 _res = _res.add(_dust);
1230             }
1231 
1232             // pay our winner
1233             plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1234 
1235             // Community awards
1236 
1237             admin.transfer(_com);
1238 
1239             // distribute gen portion to key holders
1240             round_[_rID].mask = _ppt.add(round_[_rID].mask);
1241 
1242             // Prepare event data
1243             _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1244             _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1245             _eventData_.winnerAddr = plyr_[_winPID].addr;
1246             _eventData_.winnerName = plyr_[_winPID].name;
1247             _eventData_.amountWon = _win;
1248             _eventData_.genAmount = _gen;
1249             _eventData_.P3DAmount = _p3d;
1250             _eventData_.newPot = _res;
1251 
1252             // Start next round
1253             rID_++;
1254             _rID++;
1255             round_[_rID].strt = now;
1256             round_[_rID].end = now.add(rndInit_).add(rndGap_);
1257             round_[_rID].pot = _res;
1258 
1259             return(_eventData_);
1260         }
1261 
1262         /**
1263         * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1264         */
1265         function updateGenVault(uint256 _pID, uint256 _rIDlast)
1266             private
1267         {
1268             uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1269             if (_earnings > 0)
1270             {
1271                 // put in gen vault
1272                 plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1273                 // zero out their earnings by updating mask
1274                 plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1275             }
1276         }
1277 
1278         /**
1279         * @dev updates round timer based on number of whole keys bought.
1280         */
1281         function updateTimer(uint256 _keys, uint256 _rID)
1282             private
1283         {
1284             // grab time
1285             uint256 _now = now;
1286 
1287             // calculate time based on number of keys bought
1288             uint256 _newTime;
1289             if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1290                 _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1291             else
1292                 _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1293 
1294             // compare to max and set new end time
1295             if (_newTime < (rndMax_).add(_now))
1296                 round_[_rID].end = _newTime;
1297             else
1298                 round_[_rID].end = rndMax_.add(_now);
1299         }
1300 
1301         /**
1302         * @dev generates a random number between 0-99 and checks to see if thats
1303         * resulted in an airdrop win
1304         * @return do we have a winner?
1305         */
1306         function airdrop()
1307             private
1308             view
1309             returns(bool)
1310         {
1311             uint256 seed = uint256(keccak256(abi.encodePacked(
1312 
1313                 (block.timestamp).add
1314                 (block.difficulty).add
1315                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1316                 (block.gaslimit).add
1317                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1318                 (block.number)
1319 
1320             )));
1321             if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1322                 return(true);
1323             else
1324                 return(false);
1325         }
1326 
1327         /**
1328         * @dev distributes eth based on fees to com, aff, and p3d
1329         */
1330         function distributeExternal(uint256 _rID, uint256 _eth, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1331             private
1332             returns(F3Ddatasets.EventReturns)
1333         {
1334             // // pay 3% out to community rewards
1335             uint256 _com = (_eth.mul(5)) / 100;
1336             uint256 _p3d;
1337             if (!address(admin).call.value(_com)())
1338             {
1339                 _p3d = _com;
1340                 _com = 0;
1341             }
1342 
1343 
1344             // pay p3d
1345             _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1346             if (_p3d > 0)
1347             {
1348                 round_[_rID].pot = round_[_rID].pot.add(_p3d);
1349 
1350                 // set event data
1351                 _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1352             }
1353 
1354             return(_eventData_);
1355         }
1356 
1357         /**
1358         * @dev distributes eth based on fees to gen and pot
1359         */
1360         function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1361             private
1362             returns(F3Ddatasets.EventReturns)
1363         {
1364             // calculate gen share
1365             uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1366 
1367             // distribute share to affiliate 15%
1368             uint256 _aff = (_eth.mul(20)) / 100;
1369 
1370             // update eth balance (eth = eth - (com share + pot swap share + aff share))
1371             _eth = _eth.sub(((_eth.mul(25)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1372 
1373             // calculate pot
1374             uint256 _pot = _eth.sub(_gen);
1375 
1376             // decide what to do with affiliate share of fees
1377             // affiliate must not be self, and must have a name registered
1378             if (_affID != _pID && plyr_[_affID].name != '') {
1379                 plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1380                 emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1381             } else {
1382                 _gen = _gen.add(_aff);
1383             }
1384 
1385             // distribute gen share (thats what updateMasks() does) and adjust
1386             // balances for dust.
1387             uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1388             if (_dust > 0)
1389                 _gen = _gen.sub(_dust);
1390 
1391             // add eth to pot
1392             round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1393 
1394             // set up event data
1395             _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1396             _eventData_.potAmount = _pot;
1397 
1398             return(_eventData_);
1399         }
1400 
1401         /**
1402         * @dev updates masks for round and player when keys are bought
1403         * @return dust left over 
1404         */
1405         function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1406             private
1407             returns(uint256)
1408         {
1409             /* MASKING NOTES
1410                 earnings masks are a tricky thing for people to wrap their minds around.
1411                 the basic thing to understand here.  is were going to have a global
1412                 tracker based on profit per share for each round, that increases in
1413                 relevant proportion to the increase in share supply.
1414                 
1415                 the player will have an additional mask that basically says "based
1416                 on the rounds mask, my shares, and how much i've already withdrawn,
1417                 how much is still owed to me?"
1418             */
1419             
1420             // calc profit per key & round mask based on this buy:  (dust goes to pot)
1421             uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1422             round_[_rID].mask = _ppt.add(round_[_rID].mask);
1423 
1424             // calculate player earning from their own buy (only based on the keys
1425             // they just bought).  & update player earnings mask
1426             uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1427             plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1428 
1429             // calculate and return dust
1430             return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1431         }
1432 
1433         /**
1434         * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1435         * @return earnings in wei format
1436         */
1437         function withdrawEarnings(uint256 _pID)
1438             private
1439             returns(uint256)
1440         {
1441             // update gen vault
1442             updateGenVault(_pID, plyr_[_pID].lrnd);
1443 
1444             // from vaults
1445             uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1446             if (_earnings > 0)
1447             {
1448                 plyr_[_pID].win = 0;
1449                 plyr_[_pID].gen = 0;
1450                 plyr_[_pID].aff = 0;
1451             }
1452 
1453             return(_earnings);
1454         }
1455 
1456         /**
1457         * @dev prepares compression data and fires event for buy or reload tx's
1458         */
1459         function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1460             private
1461         {
1462             _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1463             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1464 
1465             emit F3Devents.onEndTx
1466             (
1467                 _eventData_.compressedData,
1468                 _eventData_.compressedIDs,
1469                 plyr_[_pID].name,
1470                 msg.sender,
1471                 _eth,
1472                 _keys,
1473                 _eventData_.winnerAddr,
1474                 _eventData_.winnerName,
1475                 _eventData_.amountWon,
1476                 _eventData_.newPot,
1477                 _eventData_.P3DAmount,
1478                 _eventData_.genAmount,
1479                 _eventData_.potAmount,
1480                 airDropPot_
1481             );
1482         }
1483     //==============================================================================
1484     //    (~ _  _    _._|_    .
1485     //    _)(/_(_|_|| | | \/  .
1486     //====================/=========================================================
1487         /** upon contract deploy, it will be deactivated.  this is a one time
1488         * use function that will activate the contract.  we do this so devs 
1489         * have time to set things up on the web end                   **/
1490         bool public activated_ = false;
1491         function activate()
1492             public
1493         {
1494             // only admin  just can activate 
1495             require(msg.sender == admin, "only admin can activate");
1496 
1497 
1498             // can only be ran once
1499             require(activated_ == false, "FOMO WAR2 already activated");
1500 
1501             // activate the contract
1502             activated_ = true;
1503 
1504             // let's start the first round
1505             rID_ = 1;
1506                 round_[1].strt = now - rndGap_;
1507                 round_[1].end = now + rndInit_ ;
1508         }
1509     }
1510 
1511     //==============================================================================
1512     //   __|_ _    __|_ _  .
1513     //  _\ | | |_|(_ | _\  .
1514     //==============================================================================
1515     library F3Ddatasets {
1516         //compressedData key
1517         // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1518             // 0 - new player (bool)
1519             // 1 - joined round (bool)
1520             // 2 - new  leader (bool)
1521             // 3-5 - air drop tracker (uint 0-999)
1522             // 6-16 - round end time
1523             // 17 - winnerTeam
1524             // 18 - 28 timestamp 
1525             // 29 - team
1526             // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1527             // 31 - airdrop happened bool
1528             // 32 - airdrop tier 
1529             // 33 - airdrop amount won
1530         //compressedIDs key
1531         // [77-52][51-26][25-0]
1532             // 0-25 - pID 
1533             // 26-51 - winPID
1534             // 52-77 - rID
1535         struct EventReturns {
1536             uint256 compressedData;
1537             uint256 compressedIDs;
1538             address winnerAddr;         // winner address
1539             bytes32 winnerName;         // winner name
1540             uint256 amountWon;          // amount won
1541             uint256 newPot;             // amount in new pot
1542             uint256 P3DAmount;          // amount distributed to p3d
1543             uint256 genAmount;          // amount distributed to gen
1544             uint256 potAmount;          // amount added to pot
1545         }
1546         struct Player {
1547             address addr;   // player address
1548             bytes32 name;   // player name
1549             uint256 win;    // winnings vault
1550             uint256 gen;    // general vault
1551             uint256 aff;    // affiliate vault
1552             uint256 lrnd;   // last round played
1553             uint256 laff;   // last affiliate id used
1554         }
1555         struct PlayerRounds {
1556             uint256 eth;    // eth player has added to round (used for eth limiter)
1557             uint256 keys;   // keys
1558             uint256 mask;   // player mask 
1559             uint256 ico;    // ICO phase investment
1560         }
1561         struct Round {
1562             uint256 plyr;   // pID of player in lead
1563             uint256 team;   // tID of team in lead
1564             uint256 end;    // time ends/ended
1565             bool ended;     // has round end function been ran
1566             uint256 strt;   // time round started
1567             uint256 keys;   // keys
1568             uint256 eth;    // total eth in
1569             uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1570             uint256 mask;   // global mask
1571             uint256 ico;    // total eth sent in during ICO phase
1572             uint256 icoGen; // total eth for gen during ICO phase
1573             uint256 icoAvg; // average key price for ICO phase
1574         }
1575         struct TeamFee {
1576             uint256 gen;    // % of buy in thats paid to key holders of current round
1577             uint256 p3d;    // % of buy in thats paid to p3d holders
1578         }
1579         struct PotSplit {
1580             uint256 gen;    // % of pot thats paid to key holders of current round
1581             uint256 p3d;    // % of pot thats paid to p3d holders
1582         }
1583     }
1584 
1585     //==============================================================================
1586     //  |  _      _ _ | _  .
1587     //  |<(/_\/  (_(_||(_  .
1588     //=======/======================================================================
1589     library F3DKeysCalcShort {
1590         using SafeMath for *;
1591         /**
1592         * @dev calculates number of keys received given X eth 
1593         * @param _curEth current amount of eth in contract 
1594         * @param _newEth eth being spent
1595         * @return amount of ticket purchased
1596         */
1597         function keysRec(uint256 _curEth, uint256 _newEth)
1598             internal
1599             pure
1600             returns (uint256)
1601         {
1602             return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1603         }
1604 
1605         /**
1606         * @dev calculates amount of eth received if you sold X keys 
1607         * @param _curKeys current amount of keys that exist 
1608         * @param _sellKeys amount of keys you wish to sell
1609         * @return amount of eth received
1610         */
1611         function ethRec(uint256 _curKeys, uint256 _sellKeys)
1612             internal
1613             pure
1614             returns (uint256)
1615         {
1616             return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1617         }
1618 
1619         /**
1620         * @dev calculates how many keys would exist with given an amount of eth
1621         * @param _eth eth "in contract"
1622         * @return number of keys that would exist
1623         */
1624         function keys(uint256 _eth)
1625             internal
1626             pure
1627             returns(uint256)
1628         {
1629             return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1630         }
1631 
1632         /**
1633         * @dev calculates how much eth would be in contract given a number of keys
1634         * @param _keys number of keys "in contract" 
1635         * @return eth that would exists
1636         */
1637         function eth(uint256 _keys)
1638             internal
1639             pure
1640             returns(uint256)
1641         {
1642             return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1643         }
1644     }
1645 
1646     //==============================================================================
1647     //  . _ _|_ _  _ |` _  _ _  _  .
1648     //  || | | (/_| ~|~(_|(_(/__\  .
1649     //==============================================================================
1650 
1651     interface PlayerBookInterface {
1652         function getPlayerID(address _addr) external returns (uint256);
1653         function getPlayerName(uint256 _pID) external view returns (bytes32);
1654         function getPlayerLAff(uint256 _pID) external view returns (uint256);
1655         function getPlayerAddr(uint256 _pID) external view returns (address);
1656         function getNameFee() external view returns (uint256);
1657         function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1658         function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1659         function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1660     }
1661 
1662 
1663     library NameFilter {
1664         /**
1665         * @dev filters name strings
1666         * -converts uppercase to lower case.  
1667         * -makes sure it does not start/end with a space
1668         * -makes sure it does not contain multiple spaces in a row
1669         * -cannot be only numbers
1670         * -cannot start with 0x 
1671         * -restricts characters to A-Z, a-z, 0-9, and space.
1672         * @return reprocessed string in bytes32 format
1673         */
1674         function nameFilter(string _input)
1675             internal
1676             pure
1677             returns(bytes32)
1678         {
1679             bytes memory _temp = bytes(_input);
1680             uint256 _length = _temp.length;
1681 
1682             //sorry limited to 32 characters
1683             require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1684             // make sure it doesnt start with or end with space
1685             require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1686             // make sure first two characters are not 0x
1687             if (_temp[0] == 0x30)
1688             {
1689                 require(_temp[1] != 0x78, "string cannot start with 0x");
1690                 require(_temp[1] != 0x58, "string cannot start with 0X");
1691             }
1692 
1693             // create a bool to track if we have a non number character
1694             bool _hasNonNumber;
1695             
1696             // convert & check
1697             for (uint256 i = 0; i < _length; i++)
1698             {
1699                 // if its uppercase A-Z
1700                 if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1701                 {
1702                     // convert to lower case a-z
1703                     _temp[i] = byte(uint(_temp[i]) + 32);
1704                     
1705                     // we have a non number
1706                     if (_hasNonNumber == false)
1707                         _hasNonNumber = true;
1708                 } else {
1709                     require
1710                     (
1711                         // require character is a space
1712                         _temp[i] == 0x20 || 
1713                         // OR lowercase a-z
1714                         (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1715                         // or 0-9
1716                         (_temp[i] > 0x2f && _temp[i] < 0x3a),
1717                         "string contains invalid characters"
1718                     );
1719                     // make sure theres not 2x spaces in a row
1720                     if (_temp[i] == 0x20)
1721                         require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1722 
1723                     // see if we have a character other than a number
1724                     if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1725                         _hasNonNumber = true;
1726                 }
1727             }
1728 
1729             require(_hasNonNumber == true, "string cannot be only numbers");
1730 
1731             bytes32 _ret;
1732             assembly {
1733                 _ret := mload(add(_temp, 32))
1734             }
1735             return (_ret);
1736         }
1737     }
1738 
1739     /**
1740     * @title SafeMath v0.1.9
1741     * @dev Math operations with safety checks that throw on error
1742     * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1743     * - added sqrt
1744     * - added sq
1745     * - added pwr 
1746     * - changed asserts to requires with error log outputs
1747     * - removed div, its useless
1748     */
1749     library SafeMath {
1750 
1751         /**
1752         * @dev Multiplies two numbers, throws on overflow.
1753         */
1754         function mul(uint256 a, uint256 b)
1755             internal
1756             pure
1757             returns (uint256 c)
1758         {
1759             if (a == 0) {
1760                 return 0;
1761             }
1762             c = a * b;
1763             require(c / a == b, "SafeMath mul failed");
1764             return c;
1765         }
1766 
1767         function div(uint256 a, uint256 b) internal pure returns (uint256) {
1768         // assert(b > 0); // Solidity automatically throws when dividing by 0
1769         uint256 c = a / b;
1770         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1771         return c;
1772     }
1773 
1774         /**
1775         *@dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend)
1776         */
1777         function sub(uint256 a, uint256 b)
1778             internal
1779             pure
1780             returns (uint256)
1781         {
1782             require(b <= a, "SafeMath sub failed");
1783             return a - b;
1784         }
1785 
1786         /**
1787         * @dev Adds two numbers, throws on overflow.
1788         */
1789         function add(uint256 a, uint256 b)
1790             internal
1791             pure
1792             returns (uint256 c) 
1793         {
1794             c = a + b;
1795             require(c >= a, "SafeMath add failed");
1796             return c;
1797         }
1798         
1799         /**
1800         * @dev gives square root of given x.
1801         */
1802         function sqrt(uint256 x)
1803             internal
1804             pure
1805             returns (uint256 y)
1806         {
1807             uint256 z = ((add(x,1)) / 2);
1808             y = x;
1809             while (z < y)
1810             {
1811                 y = z;
1812                 z = ((add((x / z),z)) / 2);
1813             }
1814         }
1815 
1816         /**
1817         * @dev gives square. multiplies x by x
1818         */
1819         function sq(uint256 x)
1820             internal
1821             pure
1822             returns (uint256)
1823         {
1824             return (mul(x,x));
1825         }
1826 
1827         /**
1828         * @dev x to the power of y 
1829         */
1830         function pwr(uint256 x, uint256 y)
1831             internal
1832             pure
1833             returns (uint256)
1834         {
1835             if (x==0)
1836                 return (0);
1837             else if (y==0)
1838                 return (1);
1839             else
1840             {
1841                 uint256 z = x;
1842                 for (uint256 i=1; i < y; i++)
1843                     z = mul(z,x);
1844                 return (z);
1845             }
1846         }
1847     }