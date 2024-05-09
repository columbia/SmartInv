1 pragma solidity ^0.4.24;
2 
3 contract HXevents {
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
63     // fired whenever a player tries a buy after round timer 
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
80     // fired whenever a player tries a reload after round timer 
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
116 //==============================================================================
117 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
118 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
119 //====================================|=========================================
120 
121 contract modularShort is HXevents {}
122 
123 contract HX is modularShort {
124     using SafeMath for *;
125     using NameFilter for string;
126     using HXKeysCalcLong for uint256;
127 	
128     address developer_addr = 0xE5Cb34770248B5896dF380704EC19665F9f39634;
129     address community_addr = 0xb007f725F9260CD57D5e894f3ad33A80F0f02BA3;
130     address token_community_addr = 0xBEFB937103A56b866B391b4973F9E8CCb44Bb851;
131 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xF7ca07Ff0389d5690EB9306c490842D837A3fA49);
132 //==============================================================================
133 //     _ _  _  |`. _     _ _ |_ | _  _  .
134 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
135 //=================_|===========================================================
136     string constant public name = "HX";
137     string constant public symbol = "HX";
138     uint256 private rndExtra_ = 0;     // length of the very first ICO
139     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
140     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
141     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
142     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be             // max length a round timer can be
143 //==============================================================================
144 //     _| _ _|_ _    _ _ _|_    _   .
145 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
146 //=============================|================================================
147 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
148     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
149     uint256 public rID_;    // round id number / total rounds that have happened
150 //****************
151 // PLAYER DATA 
152 //****************
153     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
154     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
155     mapping (uint256 => HXdatasets.Player) public plyr_;   // (pID => data) player data
156     mapping (uint256 => mapping (uint256 => HXdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
157     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
158 //****************
159 // ROUND DATA 
160 //****************
161     mapping (uint256 => HXdatasets.Round) public round_;   // (rID => data) round data
162     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
163 //****************
164 // TEAM FEE DATA 
165 //****************
166     mapping (uint256 => HXdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
167     mapping (uint256 => HXdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
168 //==============================================================================
169 //     _ _  _  __|_ _    __|_ _  _  .
170 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
171 //==============================================================================
172     constructor()
173         public
174     {
175 		// Team allocation structures
176         // 0 = whales
177         // 1 = bears
178         // 2 = sneks
179         // 3 = bulls
180 
181 		// Team allocation percentages
182         // (HX, 0) + (Pot , Referrals, Community)
183             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
184         fees_[0] = HXdatasets.TeamFee(30,6);   //46% to pot, 20% to aff, 2% to com, 2% to air drop pot
185         fees_[1] = HXdatasets.TeamFee(43,0);   //33% to pot, 20% to aff, 2% to com, 2% to air drop pot
186         fees_[2] = HXdatasets.TeamFee(56,10);  //20% to pot, 20% to aff, 2% to com, 2% to air drop pot
187         fees_[3] = HXdatasets.TeamFee(43,8);   //33% to pot, 20% to aff, 2% to com, 2% to air drop pot
188         
189         // how to split up the final pot based on which team was picked
190         // (HX, 0)
191         potSplit_[0] = HXdatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 12% to com
192         potSplit_[1] = HXdatasets.PotSplit(25,0);   //48% to winner, 20% to next round, 12% to com
193         potSplit_[2] = HXdatasets.PotSplit(20,20);  //48% to winner, 15% to next round, 12% to com
194         potSplit_[3] = HXdatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 12% to com
195 	}
196 //==============================================================================
197 //     _ _  _  _|. |`. _  _ _  .
198 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
199 //==============================================================================
200     /**
201      * @dev used to make sure no one can interact with contract until it has 
202      * been activated. 
203      */
204     modifier isActivated() {
205         require(activated_ == true, "its not ready yet.  "); 
206         _;
207     }
208     
209     /**
210      * @dev prevents contracts from interacting with fomo3d 
211      */
212     modifier isHuman() {
213         address _addr = msg.sender;
214         uint256 _codeLength;
215         
216         assembly {_codeLength := extcodesize(_addr)}
217         require(_codeLength == 0, "sorry humans only");
218         _;
219     }
220 
221     /**
222      * @dev sets boundaries for incoming tx 
223      */
224     modifier isWithinLimits(uint256 _eth) {
225         require(_eth >= 1000000000, "pocket lint: not a valid currency");
226         require(_eth <= 100000000000000000000000, "no vitalik, no");
227         _;    
228     }
229     
230 //==============================================================================
231 //     _    |_ |. _   |`    _  __|_. _  _  _  .
232 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
233 //====|=========================================================================
234     /**
235      * @dev emergency buy uses last stored affiliate ID and team snek
236      */
237     function()
238         isActivated()
239         isHuman()
240         isWithinLimits(msg.value)
241         public
242         payable
243     {
244         // set up our tx event data and determine if player is new or not
245         HXdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
246             
247         // fetch player id
248         uint256 _pID = pIDxAddr_[msg.sender];
249         
250         // buy core 
251         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
252     }
253     
254     /**
255      * @dev converts all incoming ethereum to keys.
256      * -functionhash- 0x8f38f309 (using ID for affiliate)
257      * -functionhash- 0x98a0871d (using address for affiliate)
258      * -functionhash- 0xa65b37a1 (using name for affiliate)
259      * @param _affCode the ID/address/name of the player who gets the affiliate fee
260      * @param _team what team is the player playing for?
261      */
262     function buyXid(uint256 _affCode, uint256 _team)
263         isActivated()
264         isHuman()
265         isWithinLimits(msg.value)
266         public
267         payable
268     {
269         // set up our tx event data and determine if player is new or not
270         HXdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
271         
272         // fetch player id
273         uint256 _pID = pIDxAddr_[msg.sender];
274         
275         // manage affiliate residuals
276         // if no affiliate code was given or player tried to use their own, lolz
277         if (_affCode == 0 || _affCode == _pID)
278         {
279             // use last stored affiliate code 
280             _affCode = plyr_[_pID].laff;
281             
282         // if affiliate code was given & its not the same as previously stored 
283         } else if (_affCode != plyr_[_pID].laff) {
284             // update last affiliate 
285             plyr_[_pID].laff = _affCode;
286         }
287         
288         // verify a valid team was selected
289         _team = verifyTeam(_team);
290         
291         // buy core 
292         buyCore(_pID, _affCode, _team, _eventData_);
293     }
294     
295     function buyXaddr(address _affCode, uint256 _team)
296         isActivated()
297         isHuman()
298         isWithinLimits(msg.value)
299         public
300         payable
301     {
302         // set up our tx event data and determine if player is new or not
303         HXdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
304         
305         // fetch player id
306         uint256 _pID = pIDxAddr_[msg.sender];
307         
308         // manage affiliate residuals
309         uint256 _affID;
310         // if no affiliate code was given or player tried to use their own, lolz
311         if (_affCode == address(0) || _affCode == msg.sender)
312         {
313             // use last stored affiliate code
314             _affID = plyr_[_pID].laff;
315         
316         // if affiliate code was given    
317         } else {
318             // get affiliate ID from aff Code 
319             _affID = pIDxAddr_[_affCode];
320             
321             // if affID is not the same as previously stored 
322             if (_affID != plyr_[_pID].laff)
323             {
324                 // update last affiliate
325                 plyr_[_pID].laff = _affID;
326             }
327         }
328         
329         // verify a valid team was selected
330         _team = verifyTeam(_team);
331         
332         // buy core 
333         buyCore(_pID, _affID, _team, _eventData_);
334     }
335     
336     function buyXname(bytes32 _affCode, uint256 _team)
337         isActivated()
338         isHuman()
339         isWithinLimits(msg.value)
340         public
341         payable
342     {
343         // set up our tx event data and determine if player is new or not
344         HXdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
345         
346         // fetch player id
347         uint256 _pID = pIDxAddr_[msg.sender];
348         
349         // manage affiliate residuals
350         uint256 _affID;
351         // if no affiliate code was given or player tried to use their own, lolz
352         if (_affCode == '' || _affCode == plyr_[_pID].name)
353         {
354             // use last stored affiliate code
355             _affID = plyr_[_pID].laff;
356         
357         // if affiliate code was given
358         } else {
359             // get affiliate ID from aff Code
360             _affID = pIDxName_[_affCode];
361             
362             // if affID is not the same as previously stored
363             if (_affID != plyr_[_pID].laff)
364             {
365                 // update last affiliate
366                 plyr_[_pID].laff = _affID;
367             }
368         }
369         
370         // verify a valid team was selected
371         _team = verifyTeam(_team);
372         
373         // buy core 
374         buyCore(_pID, _affID, _team, _eventData_);
375     }
376     
377     /**
378      * @dev essentially the same as buy, but instead of you sending ether 
379      * from your wallet, it uses your unwithdrawn earnings.
380      * -functionhash- 0x349cdcac (using ID for affiliate)
381      * -functionhash- 0x82bfc739 (using address for affiliate)
382      * -functionhash- 0x079ce327 (using name for affiliate)
383      * @param _affCode the ID/address/name of the player who gets the affiliate fee
384      * @param _team what team is the player playing for?
385      * @param _eth amount of earnings to use (remainder returned to gen vault)
386      */
387     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
388         isActivated()
389         isHuman()
390         isWithinLimits(_eth)
391         public
392     {
393         // set up our tx event data
394         HXdatasets.EventReturns memory _eventData_;
395         
396         // fetch player ID
397         uint256 _pID = pIDxAddr_[msg.sender];
398         
399         // manage affiliate residuals
400         // if no affiliate code was given or player tried to use their own, lolz
401         if (_affCode == 0 || _affCode == _pID)
402         {
403             // use last stored affiliate code 
404             _affCode = plyr_[_pID].laff;
405             
406         // if affiliate code was given & its not the same as previously stored 
407         } else if (_affCode != plyr_[_pID].laff) {
408             // update last affiliate 
409             plyr_[_pID].laff = _affCode;
410         }
411 
412         // verify a valid team was selected
413         _team = verifyTeam(_team);
414 
415         // reload core
416         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
417     }
418     
419     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
420         isActivated()
421         isHuman()
422         isWithinLimits(_eth)
423         public
424     {
425         // set up our tx event data
426         HXdatasets.EventReturns memory _eventData_;
427         
428         // fetch player ID
429         uint256 _pID = pIDxAddr_[msg.sender];
430         
431         // manage affiliate residuals
432         uint256 _affID;
433         // if no affiliate code was given or player tried to use their own, lolz
434         if (_affCode == address(0) || _affCode == msg.sender)
435         {
436             // use last stored affiliate code
437             _affID = plyr_[_pID].laff;
438         
439         // if affiliate code was given    
440         } else {
441             // get affiliate ID from aff Code 
442             _affID = pIDxAddr_[_affCode];
443             
444             // if affID is not the same as previously stored 
445             if (_affID != plyr_[_pID].laff)
446             {
447                 // update last affiliate
448                 plyr_[_pID].laff = _affID;
449             }
450         }
451         
452         // verify a valid team was selected
453         _team = verifyTeam(_team);
454         
455         // reload core
456         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
457     }
458     
459     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
460         isActivated()
461         isHuman()
462         isWithinLimits(_eth)
463         public
464     {
465         // set up our tx event data
466         HXdatasets.EventReturns memory _eventData_;
467         
468         // fetch player ID
469         uint256 _pID = pIDxAddr_[msg.sender];
470         
471         // manage affiliate residuals
472         uint256 _affID;
473         // if no affiliate code was given or player tried to use their own, lolz
474         if (_affCode == '' || _affCode == plyr_[_pID].name)
475         {
476             // use last stored affiliate code
477             _affID = plyr_[_pID].laff;
478         
479         // if affiliate code was given
480         } else {
481             // get affiliate ID from aff Code
482             _affID = pIDxName_[_affCode];
483             
484             // if affID is not the same as previously stored
485             if (_affID != plyr_[_pID].laff)
486             {
487                 // update last affiliate
488                 plyr_[_pID].laff = _affID;
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
524             HXdatasets.EventReturns memory _eventData_;
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
542             emit HXevents.onWithdrawAndDistribute
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
567             emit HXevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
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
608         emit HXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
624         emit HXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
640         emit HXevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
846     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, HXdatasets.EventReturns memory _eventData_)
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
875                 emit HXevents.onBuyAndDistribute
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
900     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, HXdatasets.EventReturns memory _eventData_)
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
931             emit HXevents.onReLoadAndDistribute
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
951     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, HXdatasets.EventReturns memory _eventData_)
952         private
953     {
954         // if player is new to round
955         if (plyrRnds_[_pID][_rID].keys == 0)
956             _eventData_ = managePlayer(_pID, _eventData_);
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
1151     function determinePID(HXdatasets.EventReturns memory _eventData_)
1152         private
1153         returns (HXdatasets.EventReturns)
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
1203     function managePlayer(uint256 _pID, HXdatasets.EventReturns memory _eventData_)
1204         private
1205         returns (HXdatasets.EventReturns)
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
1224     function endRound(HXdatasets.EventReturns memory _eventData_)
1225         private
1226         returns (HXdatasets.EventReturns)
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
1241         uint256 _com = (_pot.mul(2) / 100);
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
1259         community_addr.transfer(_com);
1260         
1261         // distribute gen portion to key holders
1262         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1263 
1264         if (_p3d > 0)
1265             token_community_addr.transfer(_p3d);
1266         
1267             
1268         // prepare event data
1269         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1270         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1271         _eventData_.winnerAddr = plyr_[_winPID].addr;
1272         _eventData_.winnerName = plyr_[_winPID].name;
1273         _eventData_.amountWon = _win;
1274         _eventData_.genAmount = _gen;
1275         _eventData_.P3DAmount = _p3d;
1276         _eventData_.newPot = _res;
1277         
1278         // start next round
1279         rID_++;
1280         _rID++;
1281         round_[_rID].strt = now;
1282         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1283         round_[_rID].pot = _res;
1284         
1285         return(_eventData_);
1286     }
1287     
1288     /**
1289      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1290      */
1291     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1292         private 
1293     {
1294         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1295         if (_earnings > 0)
1296         {
1297             // put in gen vault
1298             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1299             // zero out their earnings by updating mask
1300             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1301         }
1302     }
1303     
1304     /**
1305      * @dev updates round timer based on number of whole keys bought.
1306      */
1307     function updateTimer(uint256 _keys, uint256 _rID)
1308         private
1309     {
1310         // grab time
1311         uint256 _now = now;
1312         
1313         // calculate time based on number of keys bought
1314         uint256 _newTime;
1315         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1316             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1317         else
1318             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1319         
1320         // compare to max and set new end time
1321         if (_newTime < (rndMax_).add(_now))
1322             round_[_rID].end = _newTime;
1323         else
1324             round_[_rID].end = rndMax_.add(_now);
1325     }
1326     
1327     /**
1328      * @dev generates a random number between 0-99 and checks to see if thats
1329      * resulted in an airdrop win
1330      * @return do we have a winner?
1331      */
1332     function airdrop()
1333         private 
1334         view 
1335         returns(bool)
1336     {
1337         uint256 seed = uint256(keccak256(abi.encodePacked(
1338             
1339             (block.timestamp).add
1340             (block.difficulty).add
1341             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1342             (block.gaslimit).add
1343             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1344             (block.number)
1345             
1346         )));
1347         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1348             return(true);
1349         else
1350             return(false);
1351     }
1352 
1353     /**
1354      * @dev distributes eth based on fees to com, aff, and p3d
1355      */
1356     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, HXdatasets.EventReturns memory _eventData_)
1357         private
1358         returns(HXdatasets.EventReturns)
1359     {
1360         // pay 2% out to community rewards
1361         uint256 _com = _eth / 50;
1362         uint256 _p3d;
1363         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1364         if (_p3d > 0)
1365         {
1366             token_community_addr.transfer(_p3d);
1367             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1368         }
1369         
1370         // distribute share to affiliate
1371         uint256 _aff = _eth / 10;
1372         
1373         // decide what to do with affiliate share of fees
1374         // affiliate must not be self, and must have a name registered
1375         if (_affID != _pID && plyr_[_affID].name != '') {
1376             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1377             emit HXevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1378         } else {
1379             _com = _com.add(_aff);
1380         }
1381         community_addr.transfer(_com);
1382         
1383         return(_eventData_);
1384     }
1385     
1386     /**
1387      * @dev distributes eth based on fees to gen and pot
1388      */
1389     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, HXdatasets.EventReturns memory _eventData_)
1390         private
1391         returns(HXdatasets.EventReturns)
1392     {
1393         // calculate gen share
1394         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1395         
1396         // toss 2% into airdrop pot 
1397         uint256 _air = (_eth / 50);
1398         airDropPot_ = airDropPot_.add(_air);
1399         
1400         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1401         _eth = _eth.sub(((_eth.mul(24)) / 100));
1402         
1403         // calculate pot 
1404         uint256 _pot = _eth.sub(_gen);
1405         
1406         // distribute gen share (thats what updateMasks() does) and adjust
1407         // balances for dust.
1408         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1409         if (_dust > 0)
1410             _gen = _gen.sub(_dust);
1411         
1412         // add eth to pot
1413         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1414         
1415         // set up event data
1416         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1417         _eventData_.potAmount = _pot;
1418         
1419         return(_eventData_);
1420     }
1421 
1422     /**
1423      * @dev updates masks for round and player when keys are bought
1424      * @return dust left over 
1425      */
1426     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1427         private
1428         returns(uint256)
1429     {
1430         /* MASKING NOTES
1431             earnings masks are a tricky thing for people to wrap their minds around.
1432             the basic thing to understand here.  is were going to have a global
1433             tracker based on profit per share for each round, that increases in
1434             relevant proportion to the increase in share supply.
1435             
1436             the player will have an additional mask that basically says "based
1437             on the rounds mask, my shares, and how much i've already withdrawn,
1438             how much is still owed to me?"
1439         */
1440         
1441         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1442         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1443         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1444             
1445         // calculate player earning from their own buy (only based on the keys
1446         // they just bought).  & update player earnings mask
1447         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1448         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1449         
1450         // calculate & return dust
1451         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1452     }
1453     
1454     /**
1455      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1456      * @return earnings in wei format
1457      */
1458     function withdrawEarnings(uint256 _pID)
1459         private
1460         returns(uint256)
1461     {
1462         // update gen vault
1463         updateGenVault(_pID, plyr_[_pID].lrnd);
1464         
1465         // from vaults 
1466         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1467         if (_earnings > 0)
1468         {
1469             plyr_[_pID].win = 0;
1470             plyr_[_pID].gen = 0;
1471             plyr_[_pID].aff = 0;
1472         }
1473 
1474         return(_earnings);
1475     }
1476     
1477     /**
1478      * @dev prepares compression data and fires event for buy or reload tx's
1479      */
1480     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, HXdatasets.EventReturns memory _eventData_)
1481         private
1482     {
1483         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1484         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1485         
1486         emit HXevents.onEndTx
1487         (
1488             _eventData_.compressedData,
1489             _eventData_.compressedIDs,
1490             plyr_[_pID].name,
1491             msg.sender,
1492             _eth,
1493             _keys,
1494             _eventData_.winnerAddr,
1495             _eventData_.winnerName,
1496             _eventData_.amountWon,
1497             _eventData_.newPot,
1498             _eventData_.P3DAmount,
1499             _eventData_.genAmount,
1500             _eventData_.potAmount,
1501             airDropPot_
1502         );
1503     }
1504 //==============================================================================
1505 //    (~ _  _    _._|_    .
1506 //    _)(/_(_|_|| | | \/  .
1507 //====================/=========================================================
1508     /** upon contract deploy, it will be deactivated.  this is a one time
1509      * use function that will activate the contract.  we do this so devs 
1510      * have time to set things up on the web end                            **/
1511     bool public activated_ = false;
1512     function activate()
1513         public
1514     {
1515         // only team just can activate 
1516         require(
1517             msg.sender == developer_addr, "only community can activate"
1518         );
1519 
1520         
1521         // can only be ran once
1522         require(activated_ == false, "shuoha already activated");
1523         
1524         // activate the contract 
1525         activated_ = true;
1526         
1527         // lets start first round
1528 		rID_ = 1;
1529         round_[1].strt = now + rndExtra_ - rndGap_;
1530         round_[1].end = now + rndInit_ + rndExtra_;
1531     }
1532 }
1533 
1534 //==============================================================================
1535 //   __|_ _    __|_ _  .
1536 //  _\ | | |_|(_ | _\  .
1537 //==============================================================================
1538 library HXdatasets {
1539     //compressedData key
1540     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1541         // 0 - new player (bool)
1542         // 1 - joined round (bool)
1543         // 2 - new  leader (bool)
1544         // 3-5 - air drop tracker (uint 0-999)
1545         // 6-16 - round end time
1546         // 17 - winnerTeam
1547         // 18 - 28 timestamp 
1548         // 29 - team
1549         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1550         // 31 - airdrop happened bool
1551         // 32 - airdrop tier 
1552         // 33 - airdrop amount won
1553     //compressedIDs key
1554     // [77-52][51-26][25-0]
1555         // 0-25 - pID 
1556         // 26-51 - winPID
1557         // 52-77 - rID
1558     struct EventReturns {
1559         uint256 compressedData;
1560         uint256 compressedIDs;
1561         address winnerAddr;         // winner address
1562         bytes32 winnerName;         // winner name
1563         uint256 amountWon;          // amount won
1564         uint256 newPot;             // amount in new pot
1565         uint256 P3DAmount;          // amount distributed to p3d
1566         uint256 genAmount;          // amount distributed to gen
1567         uint256 potAmount;          // amount added to pot
1568     }
1569     struct Player {
1570         address addr;   // player address
1571         bytes32 name;   // player name
1572         uint256 win;    // winnings vault
1573         uint256 gen;    // general vault
1574         uint256 aff;    // affiliate vault
1575         uint256 lrnd;   // last round played
1576         uint256 laff;   // last affiliate id used
1577     }
1578     struct PlayerRounds {
1579         uint256 eth;    // eth player has added to round (used for eth limiter)
1580         uint256 keys;   // keys
1581         uint256 mask;   // player mask 
1582         uint256 ico;    // ICO phase investment
1583     }
1584     struct Round {
1585         uint256 plyr;   // pID of player in lead
1586         uint256 team;   // tID of team in lead
1587         uint256 end;    // time ends/ended
1588         bool ended;     // has round end function been ran
1589         uint256 strt;   // time round started
1590         uint256 keys;   // keys
1591         uint256 eth;    // total eth in
1592         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1593         uint256 mask;   // global mask
1594         uint256 ico;    // total eth sent in during ICO phase
1595         uint256 icoGen; // total eth for gen during ICO phase
1596         uint256 icoAvg; // average key price for ICO phase
1597     }
1598     struct TeamFee {
1599         uint256 gen;    // % of buy in thats paid to key holders of current round
1600         uint256 p3d;    // % of buy in thats paid to p3d holders
1601     }
1602     struct PotSplit {
1603         uint256 gen;    // % of pot thats paid to key holders of current round
1604         uint256 p3d;    // % of pot thats paid to p3d holders
1605     }
1606 }
1607 
1608 //==============================================================================
1609 //  |  _      _ _ | _  .
1610 //  |<(/_\/  (_(_||(_  .
1611 //=======/======================================================================
1612 library HXKeysCalcLong {
1613     using SafeMath for *;
1614     /**
1615      * @dev calculates number of keys received given X eth 
1616      * @param _curEth current amount of eth in contract 
1617      * @param _newEth eth being spent
1618      * @return amount of ticket purchased
1619      */
1620     function keysRec(uint256 _curEth, uint256 _newEth)
1621         internal
1622         pure
1623         returns (uint256)
1624     {
1625         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1626     }
1627 
1628     /**
1629      * @dev calculates amount of eth received if you sold X keys 
1630      * @param _curKeys current amount of keys that exist 
1631      * @param _sellKeys amount of keys you wish to sell
1632      * @return amount of eth received
1633      */
1634     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1635         internal
1636         pure
1637         returns (uint256)
1638     {
1639         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1640     }
1641 
1642     /**
1643      * @dev calculates how many keys would exist with given an amount of eth
1644      * @param _eth eth "in contract"
1645      * @return number of keys that would exist
1646      */
1647     function keys(uint256 _eth) 
1648         internal
1649         pure
1650         returns(uint256)
1651     {
1652         return ((((((_eth).mul(1000000000000000000)).mul(156250000000000000000000000)).add(1406247070314025878906250000000000000000000000000000000000000000)).sqrt()).sub(37499960937500000000000000000000)) / (78125000);
1653     }
1654 
1655     /**
1656      * @dev calculates how much eth would be in contract given a number of keys
1657      * @param _keys number of keys "in contract" 
1658      * @return eth that would exists
1659      */
1660     function eth(uint256 _keys) 
1661         internal
1662         pure
1663         returns(uint256)  
1664     {
1665         return ((39062500).mul(_keys.sq()).add(((74999921875000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1666     }
1667 }
1668 
1669 //==============================================================================
1670 //  . _ _|_ _  _ |` _  _ _  _  .
1671 //  || | | (/_| ~|~(_|(_(/__\  .
1672 //==============================================================================
1673 
1674 interface PlayerBookInterface {
1675     function getPlayerID(address _addr) external returns (uint256);
1676     function getPlayerName(uint256 _pID) external view returns (bytes32);
1677     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1678     function getPlayerAddr(uint256 _pID) external view returns (address);
1679     function getNameFee() external view returns (uint256);
1680     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1681     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1682     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1683 }
1684 
1685 
1686 library NameFilter {
1687     /**
1688      * @dev filters name strings
1689      * -converts uppercase to lower case.  
1690      * -makes sure it does not start/end with a space
1691      * -makes sure it does not contain multiple spaces in a row
1692      * -cannot be only numbers
1693      * -cannot start with 0x 
1694      * -restricts characters to A-Z, a-z, 0-9, and space.
1695      * @return reprocessed string in bytes32 format
1696      */
1697     function nameFilter(string _input)
1698         internal
1699         pure
1700         returns(bytes32)
1701     {
1702         bytes memory _temp = bytes(_input);
1703         uint256 _length = _temp.length;
1704         
1705         //sorry limited to 32 characters
1706         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1707         // make sure it doesnt start with or end with space
1708         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1709         // make sure first two characters are not 0x
1710         if (_temp[0] == 0x30)
1711         {
1712             require(_temp[1] != 0x78, "string cannot start with 0x");
1713             require(_temp[1] != 0x58, "string cannot start with 0X");
1714         }
1715         
1716         // create a bool to track if we have a non number character
1717         bool _hasNonNumber;
1718         
1719         // convert & check
1720         for (uint256 i = 0; i < _length; i++)
1721         {
1722             // if its uppercase A-Z
1723             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1724             {
1725                 // convert to lower case a-z
1726                 _temp[i] = byte(uint(_temp[i]) + 32);
1727                 
1728                 // we have a non number
1729                 if (_hasNonNumber == false)
1730                     _hasNonNumber = true;
1731             } else {
1732                 require
1733                 (
1734                     // require character is a space
1735                     _temp[i] == 0x20 || 
1736                     // OR lowercase a-z
1737                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1738                     // or 0-9
1739                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1740                     "string contains invalid characters"
1741                 );
1742                 // make sure theres not 2x spaces in a row
1743                 if (_temp[i] == 0x20)
1744                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1745                 
1746                 // see if we have a character other than a number
1747                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1748                     _hasNonNumber = true;    
1749             }
1750         }
1751         
1752         require(_hasNonNumber == true, "string cannot be only numbers");
1753         
1754         bytes32 _ret;
1755         assembly {
1756             _ret := mload(add(_temp, 32))
1757         }
1758         return (_ret);
1759     }
1760 }
1761 
1762 /**
1763  * @title SafeMath v0.1.9
1764  * @dev Math operations with safety checks that throw on error
1765  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1766  * - added sqrt
1767  * - added sq
1768  * - added pwr 
1769  * - changed asserts to requires with error log outputs
1770  * - removed div, its useless
1771  */
1772 library SafeMath {
1773     
1774     /**
1775     * @dev Multiplies two numbers, throws on overflow.
1776     */
1777     function mul(uint256 a, uint256 b) 
1778         internal 
1779         pure 
1780         returns (uint256 c) 
1781     {
1782         if (a == 0) {
1783             return 0;
1784         }
1785         c = a * b;
1786         require(c / a == b, "SafeMath mul failed");
1787         return c;
1788     }
1789 
1790     /**
1791     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1792     */
1793     function sub(uint256 a, uint256 b)
1794         internal
1795         pure
1796         returns (uint256) 
1797     {
1798         require(b <= a, "SafeMath sub failed");
1799         return a - b;
1800     }
1801 
1802     /**
1803     * @dev Adds two numbers, throws on overflow.
1804     */
1805     function add(uint256 a, uint256 b)
1806         internal
1807         pure
1808         returns (uint256 c) 
1809     {
1810         c = a + b;
1811         require(c >= a, "SafeMath add failed");
1812         return c;
1813     }
1814     
1815     /**
1816      * @dev gives square root of given x.
1817      */
1818     function sqrt(uint256 x)
1819         internal
1820         pure
1821         returns (uint256 y) 
1822     {
1823         uint256 z = ((add(x,1)) / 2);
1824         y = x;
1825         while (z < y) 
1826         {
1827             y = z;
1828             z = ((add((x / z),z)) / 2);
1829         }
1830     }
1831     
1832     /**
1833      * @dev gives square. multiplies x by x
1834      */
1835     function sq(uint256 x)
1836         internal
1837         pure
1838         returns (uint256)
1839     {
1840         return (mul(x,x));
1841     }
1842     
1843     /**
1844      * @dev x to the power of y 
1845      */
1846     function pwr(uint256 x, uint256 y)
1847         internal 
1848         pure 
1849         returns (uint256)
1850     {
1851         if (x==0)
1852             return (0);
1853         else if (y==0)
1854             return (1);
1855         else 
1856         {
1857             uint256 z = x;
1858             for (uint256 i=1; i < y; i++)
1859                 z = mul(z,x);
1860             return (z);
1861         }
1862     }
1863 }