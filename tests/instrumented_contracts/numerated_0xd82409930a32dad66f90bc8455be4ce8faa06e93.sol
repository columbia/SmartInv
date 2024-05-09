1 pragma solidity ^0.4.24;
2 
3 
4 //==============================================================================
5 //     _    _  _ _|_ _  .
6 //    (/_\/(/_| | | _\  .
7 //==============================================================================
8 contract PCKevents {
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
36         uint256 PCPAmount,
37         uint256 genAmount,
38         uint256 potAmount,
39         uint256 airDropPot
40     );
41     
42     // fired whenever theres a withdraw
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
64         uint256 PCPAmount,
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
81         uint256 PCPAmount,
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
97         uint256 PCPAmount,
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
126 contract modularKey is PCKevents {}
127 
128 contract PlayCoinKey is modularKey {
129     using SafeMath for *;
130     using NameFilter for string;
131     using PCKKeysCalcLong for uint256;
132     
133     otherPCK private otherPCK_;
134     PlayCoinGodInterface constant private PCGod = PlayCoinGodInterface(0x6f93Be8fD47EBb62F54ebd149B58658bf9BaCF4f);
135     ProForwarderInterface constant private Pro_Inc = ProForwarderInterface(0x97354A7281693b7C93f6348Ba4eC38B9DDd76D6e);
136     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x47D1c777f1853cac97E6b81226B1F5108FBD7B81);
137 //==============================================================================
138 //     _ _  _  |`. _     _ _ |_ | _  _  .
139 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
140 //=================_|===========================================================
141     string constant public name = "PlayCoin Key";
142     string constant public symbol = "PCK";
143     uint256 private rndExtra_ = 15 minutes;     // length of the very first ICO 
144     uint256 private rndGap_ = 15 minutes;         // length of ICO phase, set to 1 year for EOS.
145     uint256 constant private rndInit_ = 12 hours;                // round timer starts at this
146     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
147     uint256 constant private rndMax_ = 6 hours;              // max length a round timer can be
148     uint256 constant private rndMin_ = 10 minutes;
149 
150     uint256 public rndReduceThreshold_ = 10e18;           // 10ETH,reduce
151     bool public closed_ = false;
152     // admin is publish contract
153     address private admin = msg.sender;
154 
155 //==============================================================================
156 //     _| _ _|_ _    _ _ _|_    _   .
157 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
158 //=============================|================================================
159     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
160     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
161     uint256 public rID_;    // round id number / total rounds that have happened
162 
163 //****************
164 // PLAYER DATA 
165 //****************
166     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
167     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
168     mapping (uint256 => PCKdatasets.Player) public plyr_;   // (pID => data) player data
169     mapping (uint256 => mapping (uint256 => PCKdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
170     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
171 //****************
172 // ROUND DATA 
173 //****************
174     mapping (uint256 => PCKdatasets.Round) public round_;   // (rID => data) round data
175     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
176 //****************
177 // TEAM FEE DATA 
178 //****************
179     mapping (uint256 => PCKdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
180     mapping (uint256 => PCKdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
181 //==============================================================================
182 //     _ _  _  __|_ _    __|_ _  _  .
183 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
184 //==============================================================================
185     constructor()
186         public
187     {
188         // Team allocation structures
189         // 0 = whales
190         // 1 = bears
191         // 2 = sneks
192         // 3 = bulls
193 
194         // Team allocation percentages
195         // (PCK, PCP) + (Pot , Referrals, Community)
196             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
197         fees_[0] = PCKdatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
198         fees_[1] = PCKdatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
199         fees_[2] = PCKdatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
200         fees_[3] = PCKdatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
201         
202         // how to split up the final pot based on which team was picked
203         // (PCK, PCP)
204         potSplit_[0] = PCKdatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
205         potSplit_[1] = PCKdatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
206         potSplit_[2] = PCKdatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
207         potSplit_[3] = PCKdatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
208     }
209 //==============================================================================
210 //     _ _  _  _|. |`. _  _ _  .
211 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
212 //==============================================================================
213     /**
214      * @dev used to make sure no one can interact with contract until it has 
215      * been activated. 
216      */
217     modifier isActivated() {
218         require(activated_ == true, "its not ready yet.  check ?eta in discord");
219         _;
220     }
221 
222     modifier isRoundActivated() {
223         require(round_[rID_].ended == false, "the round is finished");
224         _;
225     }
226     
227     /**
228      * @dev prevents contracts from interacting with fomo3d 
229      */
230     modifier isHuman() {
231         address _addr = msg.sender;
232         uint256 _codeLength;
233         
234         require(msg.sender == tx.origin, "sorry humans only");
235         _;
236     }
237 
238     /**
239      * @dev sets boundaries for incoming tx 
240      */
241     modifier isWithinLimits(uint256 _eth) {
242         require(_eth >= 1000000000, "pocket lint: not a valid currency");
243         require(_eth <= 100000000000000000000000, "no vitalik, no");
244         _;    
245     }
246 
247     modifier onlyAdmins() {
248         require(msg.sender == admin, "onlyAdmins failed - msg.sender is not an admin");
249         _;
250     }
251 //==============================================================================
252 //     _    |_ |. _   |`    _  __|_. _  _  _  .
253 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
254 //====|=========================================================================
255     function kill () onlyAdmins() public {
256         require(round_[rID_].ended == true && closed_ == true, "the round is active or not close");
257         selfdestruct(admin);
258     }
259 
260     function getRoundStatus() isActivated() public view returns(uint256, bool){
261         return (rID_, round_[rID_].ended);
262     }
263 
264     function setThreshold(uint256 _threshold) onlyAdmins() public returns(uint256) {
265         rndReduceThreshold_ = _threshold;
266         return rndReduceThreshold_;
267     }
268 
269     function setEnforce(bool _closed) onlyAdmins() public returns(bool, uint256, bool) {
270         closed_ = _closed;
271 
272         // open ,next round
273         if( !closed_ && round_[rID_].ended == true && activated_ == true ){
274             nextRound();
275         }
276         // close,finish current round
277         else if( closed_ && round_[rID_].ended == false && activated_ == true ){
278             round_[rID_].end = now - 1;
279         }
280         
281         // close,roundId,finish
282         return (closed_, rID_, now > round_[rID_].end);
283     }
284     /**
285      * @dev emergency buy uses last stored affiliate ID and team snek
286      */
287     function()
288         isActivated()
289         isRoundActivated()
290         isHuman()
291         isWithinLimits(msg.value)
292         public
293         payable
294     {
295         // set up our tx event data and determine if player is new or not
296         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
297             
298         // fetch player id
299         uint256 _pID = pIDxAddr_[msg.sender];
300         
301         // buy core 
302         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
303     }
304     
305     /**
306      * @dev converts all incoming ethereum to keys.
307      * -functionhash- 0x8f38f309 (using ID for affiliate)
308      * -functionhash- 0x98a0871d (using address for affiliate)
309      * -functionhash- 0xa65b37a1 (using name for affiliate)
310      * @param _affCode the ID/address/name of the player who gets the affiliate fee
311      * @param _team what team is the player playing for?
312      */
313     function buyXid(uint256 _affCode, uint256 _team)
314         isActivated()
315         isRoundActivated()
316         isHuman()
317         isWithinLimits(msg.value)
318         public
319         payable
320     {
321         // set up our tx event data and determine if player is new or not
322         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
323         
324         // fetch player id
325         uint256 _pID = pIDxAddr_[msg.sender];
326         
327         // manage affiliate residuals
328         // if no affiliate code was given or player tried to use their own, lolz
329         if (_affCode == 0 || _affCode == _pID)
330         {
331             // use last stored affiliate code 
332             _affCode = plyr_[_pID].laff;
333             
334         // if affiliate code was given & its not the same as previously stored 
335         } else if (_affCode != plyr_[_pID].laff) {
336             // update last affiliate 
337             plyr_[_pID].laff = _affCode;
338         }
339         
340         // verify a valid team was selected
341         _team = verifyTeam(_team);
342         
343         // buy core 
344         buyCore(_pID, _affCode, _team, _eventData_);
345     }
346     
347     function buyXaddr(address _affCode, uint256 _team)
348         isActivated()
349         isRoundActivated()
350         isHuman()
351         isWithinLimits(msg.value)
352         public
353         payable
354     {
355         // set up our tx event data and determine if player is new or not
356         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
357         
358         // fetch player id
359         uint256 _pID = pIDxAddr_[msg.sender];
360         
361         // manage affiliate residuals
362         uint256 _affID;
363         // if no affiliate code was given or player tried to use their own, lolz
364         if (_affCode == address(0) || _affCode == msg.sender)
365         {
366             // use last stored affiliate code
367             _affID = plyr_[_pID].laff;
368         
369         // if affiliate code was given    
370         } else {
371             // get affiliate ID from aff Code 
372             _affID = pIDxAddr_[_affCode];
373             
374             // if affID is not the same as previously stored 
375             if (_affID != plyr_[_pID].laff)
376             {
377                 // update last affiliate
378                 plyr_[_pID].laff = _affID;
379             }
380         }
381         
382         // verify a valid team was selected
383         _team = verifyTeam(_team);
384         
385         // buy core 
386         buyCore(_pID, _affID, _team, _eventData_);
387     }
388     
389     function buyXname(bytes32 _affCode, uint256 _team)
390         isActivated()
391         isRoundActivated()
392         isHuman()
393         isWithinLimits(msg.value)
394         public
395         payable
396     {
397         // set up our tx event data and determine if player is new or not
398         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
399         
400         // fetch player id
401         uint256 _pID = pIDxAddr_[msg.sender];
402         
403         // manage affiliate residuals
404         uint256 _affID;
405         // if no affiliate code was given or player tried to use their own, lolz
406         if (_affCode == '' || _affCode == plyr_[_pID].name)
407         {
408             // use last stored affiliate code
409             _affID = plyr_[_pID].laff;
410         
411         // if affiliate code was given
412         } else {
413             // get affiliate ID from aff Code
414             _affID = pIDxName_[_affCode];
415             
416             // if affID is not the same as previously stored
417             if (_affID != plyr_[_pID].laff)
418             {
419                 // update last affiliate
420                 plyr_[_pID].laff = _affID;
421             }
422         }
423         
424         // verify a valid team was selected
425         _team = verifyTeam(_team);
426         
427         // buy core 
428         buyCore(_pID, _affID, _team, _eventData_);
429     }
430     
431     /**
432      * @dev essentially the same as buy, but instead of you sending ether 
433      * from your wallet, it uses your unwithdrawn earnings.
434      * -functionhash- 0x349cdcac (using ID for affiliate)
435      * -functionhash- 0x82bfc739 (using address for affiliate)
436      * -functionhash- 0x079ce327 (using name for affiliate)
437      * @param _affCode the ID/address/name of the player who gets the affiliate fee
438      * @param _team what team is the player playing for?
439      * @param _eth amount of earnings to use (remainder returned to gen vault)
440      */
441     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
442         isActivated()
443         isRoundActivated()
444         isHuman()
445         isWithinLimits(_eth)
446         public
447     {
448         // set up our tx event data
449         PCKdatasets.EventReturns memory _eventData_;
450         
451         // fetch player ID
452         uint256 _pID = pIDxAddr_[msg.sender];
453         
454         // manage affiliate residuals
455         // if no affiliate code was given or player tried to use their own, lolz
456         if (_affCode == 0 || _affCode == _pID)
457         {
458             // use last stored affiliate code 
459             _affCode = plyr_[_pID].laff;
460             
461         // if affiliate code was given & its not the same as previously stored 
462         } else if (_affCode != plyr_[_pID].laff) {
463             // update last affiliate 
464             plyr_[_pID].laff = _affCode;
465         }
466 
467         // verify a valid team was selected
468         _team = verifyTeam(_team);
469 
470         // reload core
471         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
472     }
473     
474     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
475         isActivated()
476         isRoundActivated()
477         isHuman()
478         isWithinLimits(_eth)
479         public
480     {
481         // set up our tx event data
482         PCKdatasets.EventReturns memory _eventData_;
483         
484         // fetch player ID
485         uint256 _pID = pIDxAddr_[msg.sender];
486         
487         // manage affiliate residuals
488         uint256 _affID;
489         // if no affiliate code was given or player tried to use their own, lolz
490         if (_affCode == address(0) || _affCode == msg.sender)
491         {
492             // use last stored affiliate code
493             _affID = plyr_[_pID].laff;
494         
495         // if affiliate code was given    
496         } else {
497             // get affiliate ID from aff Code 
498             _affID = pIDxAddr_[_affCode];
499             
500             // if affID is not the same as previously stored 
501             if (_affID != plyr_[_pID].laff)
502             {
503                 // update last affiliate
504                 plyr_[_pID].laff = _affID;
505             }
506         }
507         
508         // verify a valid team was selected
509         _team = verifyTeam(_team);
510         
511         // reload core
512         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
513     }
514     
515     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
516         isActivated()
517         isRoundActivated()
518         isHuman()
519         isWithinLimits(_eth)
520         public
521     {
522         // set up our tx event data
523         PCKdatasets.EventReturns memory _eventData_;
524         
525         // fetch player ID
526         uint256 _pID = pIDxAddr_[msg.sender];
527         
528         // manage affiliate residuals
529         uint256 _affID;
530         // if no affiliate code was given or player tried to use their own, lolz
531         if (_affCode == '' || _affCode == plyr_[_pID].name)
532         {
533             // use last stored affiliate code
534             _affID = plyr_[_pID].laff;
535         
536         // if affiliate code was given
537         } else {
538             // get affiliate ID from aff Code
539             _affID = pIDxName_[_affCode];
540             
541             // if affID is not the same as previously stored
542             if (_affID != plyr_[_pID].laff)
543             {
544                 // update last affiliate
545                 plyr_[_pID].laff = _affID;
546             }
547         }
548         
549         // verify a valid team was selected
550         _team = verifyTeam(_team);
551         
552         // reload core
553         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
554     }
555 
556     /**
557      * @dev withdraws all of your earnings.
558      * -functionhash- 0x3ccfd60b
559      */
560     function withdraw()
561         isActivated()
562         isHuman()
563         public
564     {
565         // setup local rID 
566         uint256 _rID = rID_;
567         
568         // grab time
569         uint256 _now = now;
570         
571         // fetch player ID
572         uint256 _pID = pIDxAddr_[msg.sender];
573         
574         // setup temp var for player eth
575         uint256 _eth;
576         
577         // check to see if round has ended and no one has run round end yet
578         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
579         {
580             // set up our tx event data
581             PCKdatasets.EventReturns memory _eventData_;
582             
583             // end the round (distributes pot)
584             round_[_rID].ended = true;
585             _eventData_ = endRound(_eventData_);
586             
587             // get their earnings
588             _eth = withdrawEarnings(_pID);
589             
590             // gib moni
591             if (_eth > 0)
592                 plyr_[_pID].addr.transfer(_eth);    
593             
594             // build event data
595             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
596             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
597             
598             // fire withdraw and distribute event
599             emit PCKevents.onWithdrawAndDistribute
600             (
601                 msg.sender, 
602                 plyr_[_pID].name, 
603                 _eth, 
604                 _eventData_.compressedData, 
605                 _eventData_.compressedIDs, 
606                 _eventData_.winnerAddr, 
607                 _eventData_.winnerName, 
608                 _eventData_.amountWon, 
609                 _eventData_.newPot, 
610                 _eventData_.PCPAmount, 
611                 _eventData_.genAmount
612             );
613             
614         // in any other situation
615         } else {
616             // get their earnings
617             _eth = withdrawEarnings(_pID);
618             
619             // gib moni
620             if (_eth > 0)
621                 plyr_[_pID].addr.transfer(_eth);
622             
623             // fire withdraw event
624             emit PCKevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
625         }
626     }
627     
628     /**
629      * @dev use these to register names.  they are just wrappers that will send the
630      * registration requests to the PlayerBook contract.  So registering here is the 
631      * same as registering there.  UI will always display the last name you registered.
632      * but you will still own all previously registered names to use as affiliate 
633      * links.
634      * - must pay a registration fee.
635      * - name must be unique
636      * - names will be converted to lowercase
637      * - name cannot start or end with a space 
638      * - cannot have more than 1 space in a row
639      * - cannot be only numbers
640      * - cannot start with 0x 
641      * - name must be at least 1 char
642      * - max length of 32 characters long
643      * - allowed characters: a-z, 0-9, and space
644      * -functionhash- 0x921dec21 (using ID for affiliate)
645      * -functionhash- 0x3ddd4698 (using address for affiliate)
646      * -functionhash- 0x685ffd83 (using name for affiliate)
647      * @param _nameString players desired name
648      * @param _affCode affiliate ID, address, or name of who referred you
649      * @param _all set to true if you want this to push your info to all games 
650      * (this might cost a lot of gas)
651      */
652     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
653         isHuman()
654         public
655         payable
656     {
657         bytes32 _name = _nameString.nameFilter();
658         address _addr = msg.sender;
659         uint256 _paid = msg.value;
660         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
661         
662         uint256 _pID = pIDxAddr_[_addr];
663         
664         // fire event
665         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
666     }
667     
668     function registerNameXaddr(string _nameString, address _affCode, bool _all)
669         isHuman()
670         public
671         payable
672     {
673         bytes32 _name = _nameString.nameFilter();
674         address _addr = msg.sender;
675         uint256 _paid = msg.value;
676         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
677         
678         uint256 _pID = pIDxAddr_[_addr];
679         
680         // fire event
681         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
682     }
683     
684     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
685         isHuman()
686         public
687         payable
688     {
689         bytes32 _name = _nameString.nameFilter();
690         address _addr = msg.sender;
691         uint256 _paid = msg.value;
692         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
693         
694         uint256 _pID = pIDxAddr_[_addr];
695         
696         // fire event
697         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
698     }
699 //==============================================================================
700 //     _  _ _|__|_ _  _ _  .
701 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
702 //=====_|=======================================================================
703     /**
704      * @dev return the price buyer will pay for next 1 individual key.
705      * -functionhash- 0x018a25e8
706      * @return price for next key bought (in wei format)
707      */
708     function getBuyPrice()
709         public 
710         view 
711         returns(uint256)
712     {  
713         // setup local rID
714         uint256 _rID = rID_;
715         
716         // grab time
717         uint256 _now = now;
718         
719         // are we in a round?
720         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
721             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
722         else // rounds over.  need price for new round
723             return ( 75000000000000 ); // init
724     }
725     
726     /**
727      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
728      * provider
729      * -functionhash- 0xc7e284b8
730      * @return time left in seconds
731      */
732     function getTimeLeft()
733         public
734         view
735         returns(uint256)
736     {
737         // setup local rID
738         uint256 _rID = rID_;
739         
740         // grab time
741         uint256 _now = now;
742         
743         if (_now < round_[_rID].end)
744             if (_now > round_[_rID].strt + rndGap_)
745                 return( (round_[_rID].end).sub(_now) );
746             else
747                 return( (round_[_rID].strt + rndGap_).sub(_now) );
748         else
749             return(0);
750     }
751     
752     /**
753      * @dev returns player earnings per vaults 
754      * -functionhash- 0x63066434
755      * @return winnings vault
756      * @return general vault
757      * @return affiliate vault
758      */
759     function getPlayerVaults(uint256 _pID)
760         public
761         view
762         returns(uint256 ,uint256, uint256)
763     {
764         // setup local rID
765         uint256 _rID = rID_;
766         
767         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
768         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
769         {
770             // if player is winner 
771             if (round_[_rID].plyr == _pID)
772             {
773                 return
774                 (
775                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
776                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
777                     plyr_[_pID].aff
778                 );
779             // if player is not the winner
780             } else {
781                 return
782                 (
783                     plyr_[_pID].win,
784                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
785                     plyr_[_pID].aff
786                 );
787             }
788             
789         // if round is still going on, or round has ended and round end has been ran
790         } else {
791             return
792             (
793                 plyr_[_pID].win,
794                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
795                 plyr_[_pID].aff
796             );
797         }
798     }
799     
800     /**
801      * solidity hates stack limits.  this lets us avoid that hate 
802      */
803     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
804         private
805         view
806         returns(uint256)
807     {
808         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
809     }
810     
811     /**
812      * @dev returns all current round info needed for front end
813      * -functionhash- 0x747dff42
814      * @return eth invested during ICO phase
815      * @return round id 
816      * @return total keys for round 
817      * @return time round ends
818      * @return time round started
819      * @return current pot 
820      * @return current team ID & player ID in lead 
821      * @return current player in leads address 
822      * @return current player in leads name
823      * @return whales eth in for round
824      * @return bears eth in for round
825      * @return sneks eth in for round
826      * @return bulls eth in for round
827      * @return airdrop tracker # & airdrop pot
828      */
829     function getCurrentRoundInfo()
830         public
831         view
832         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
833     {
834         // setup local rID
835         uint256 _rID = rID_;
836         
837         return
838         (
839             round_[_rID].ico,               //0
840             _rID,                           //1
841             round_[_rID].keys,              //2
842             round_[_rID].end,               //3
843             round_[_rID].strt,              //4
844             round_[_rID].pot,               //5
845             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
846             plyr_[round_[_rID].plyr].addr,  //7
847             plyr_[round_[_rID].plyr].name,  //8
848             rndTmEth_[_rID][0],             //9
849             rndTmEth_[_rID][1],             //10
850             rndTmEth_[_rID][2],             //11
851             rndTmEth_[_rID][3],             //12
852             airDropTracker_ + (airDropPot_ * 1000)              //13
853         );
854     }
855 
856     /**
857      * @dev returns player info based on address.  if no address is given, it will 
858      * use msg.sender 
859      * -functionhash- 0xee0b5d8b
860      * @param _addr address of the player you want to lookup 
861      * @return player ID 
862      * @return player name
863      * @return keys owned (current round)
864      * @return winnings vault
865      * @return general vault 
866      * @return affiliate vault 
867      * @return player round eth
868      */
869     function getPlayerInfoByAddress(address _addr)
870         public 
871         view 
872         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
873     {
874         // setup local rID
875         uint256 _rID = rID_;
876         
877         if (_addr == address(0))
878         {
879             _addr == msg.sender;
880         }
881         uint256 _pID = pIDxAddr_[_addr];
882         
883         return
884         (
885             _pID,                               //0
886             plyr_[_pID].name,                   //1
887             plyrRnds_[_pID][_rID].keys,         //2
888             plyr_[_pID].win,                    //3
889             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
890             plyr_[_pID].aff,                    //5
891             plyrRnds_[_pID][_rID].eth           //6
892         );
893     }
894 
895 //==============================================================================
896 //     _ _  _ _   | _  _ . _  .
897 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
898 //=====================_|=======================================================
899     /**
900      * @dev logic runs whenever a buy order is executed.  determines how to handle 
901      * incoming eth depending on if we are in an active round or not
902      */
903     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_) private {
904 
905         // setup local rID
906         uint256 _rID = rID_;
907         
908         // grab time
909         uint256 _now = now;
910 
911 
912         
913         // if round is active
914         if (_now > (round_[_rID].strt + rndGap_) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
915         {
916             // call core 
917             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
918         
919         // if round is not active     
920         } else {
921 
922             // check to see if end round needs to be ran
923             if ( _now > round_[_rID].end && round_[_rID].ended == false ) {
924                 // end the round (distributes pot) & start new round
925                 round_[_rID].ended = true;
926                 _eventData_ = endRound(_eventData_);
927 
928                 if( !closed_ ){
929                     nextRound();
930                 }
931                 
932                 // build event data
933                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
934                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
935                 
936                 // fire buy and distribute event 
937                 emit PCKevents.onBuyAndDistribute
938                 (
939                     msg.sender, 
940                     plyr_[_pID].name, 
941                     msg.value, 
942                     _eventData_.compressedData, 
943                     _eventData_.compressedIDs, 
944                     _eventData_.winnerAddr, 
945                     _eventData_.winnerName, 
946                     _eventData_.amountWon, 
947                     _eventData_.newPot, 
948                     _eventData_.PCPAmount, 
949                     _eventData_.genAmount
950                 );
951             }
952             
953             // put eth in players vault 
954             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
955         }
956     }
957     
958     /**
959      * @dev logic runs whenever a reload order is executed.  determines how to handle 
960      * incoming eth depending on if we are in an active round or not 
961      */
962     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, PCKdatasets.EventReturns memory _eventData_) private {
963 
964         // setup local rID
965         uint256 _rID = rID_;
966         
967         // grab time
968         uint256 _now = now;
969         
970         // if round is active
971         if (_now > ( round_[_rID].strt + rndGap_ ) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
972         {
973             // get earnings from all vaults and return unused to gen vault
974             // because we use a custom safemath library.  this will throw if player 
975             // tried to spend more eth than they have.
976             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
977             
978             // call core 
979             core(_rID, _pID, _eth, _affID, _team, _eventData_);
980         
981         // if round is not active and end round needs to be ran   
982         } else if ( _now > round_[_rID].end && round_[_rID].ended == false ) {
983             // end the round (distributes pot) & start new round
984             round_[_rID].ended = true;
985             _eventData_ = endRound(_eventData_);
986 
987             if( !closed_ ) {
988                 nextRound();
989             }
990                 
991             // build event data
992             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
993             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
994                 
995             // fire buy and distribute event 
996             emit PCKevents.onReLoadAndDistribute
997             (
998                 msg.sender, 
999                 plyr_[_pID].name, 
1000                 _eventData_.compressedData, 
1001                 _eventData_.compressedIDs, 
1002                 _eventData_.winnerAddr, 
1003                 _eventData_.winnerName, 
1004                 _eventData_.amountWon, 
1005                 _eventData_.newPot, 
1006                 _eventData_.PCPAmount, 
1007                 _eventData_.genAmount
1008             );
1009         }
1010     }
1011     
1012     /**
1013      * @dev this is the core logic for any buy/reload that happens while a round 
1014      * is live.
1015      */
1016     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_)
1017         private
1018     {
1019         // if player is new to round
1020         if (plyrRnds_[_pID][_rID].keys == 0)
1021             _eventData_ = managePlayer(_pID, _eventData_);
1022         
1023         // early round eth limiter 
1024         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1025         {
1026             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1027             uint256 _refund = _eth.sub(_availableLimit);
1028             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1029             _eth = _availableLimit;
1030         }
1031         
1032         // if eth left is greater than min eth allowed (sorry no pocket lint)
1033         if (_eth > 1000000000) 
1034         {
1035             
1036             // mint the new keys
1037             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1038             
1039             // if they bought at least 1 whole key
1040             if (_keys >= 1000000000000000000)
1041             {
1042             updateTimer(_keys, _rID, _eth);
1043 
1044             // set new leaders
1045             if (round_[_rID].plyr != _pID)
1046                 round_[_rID].plyr = _pID;  
1047             if (round_[_rID].team != _team)
1048                 round_[_rID].team = _team; 
1049             
1050             // set the new leader bool to true
1051             _eventData_.compressedData = _eventData_.compressedData + 100;
1052         }
1053             
1054         // manage airdrops
1055         if (_eth >= 100000000000000000) {
1056             airDropTracker_++;
1057             if (airdrop() == true) {
1058                 // gib muni
1059                 uint256 _prize;
1060                 if (_eth >= 10000000000000000000)
1061                 {
1062                     // calculate prize and give it to winner
1063                     _prize = ((airDropPot_).mul(75)) / 100;
1064                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1065                     
1066                     // adjust airDropPot 
1067                     airDropPot_ = (airDropPot_).sub(_prize);
1068                     
1069                     // let event know a tier 3 prize was won 
1070                     _eventData_.compressedData += 300000000000000000000000000000000;
1071                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1072                     // calculate prize and give it to winner
1073                     _prize = ((airDropPot_).mul(50)) / 100;
1074                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1075                     
1076                     // adjust airDropPot 
1077                     airDropPot_ = (airDropPot_).sub(_prize);
1078                     
1079                     // let event know a tier 2 prize was won 
1080                     _eventData_.compressedData += 200000000000000000000000000000000;
1081                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1082                     // calculate prize and give it to winner
1083                     _prize = ((airDropPot_).mul(25)) / 100;
1084                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1085                     
1086                     // adjust airDropPot 
1087                     airDropPot_ = (airDropPot_).sub(_prize);
1088                     
1089                     // let event know a tier 3 prize was won 
1090                     _eventData_.compressedData += 300000000000000000000000000000000;
1091                 }
1092                 // set airdrop happened bool to true
1093                 _eventData_.compressedData += 10000000000000000000000000000000;
1094                 // let event know how much was won 
1095                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1096                 
1097                 // reset air drop tracker
1098                 airDropTracker_ = 0;
1099             }
1100         }
1101     
1102             // store the air drop tracker number (number of buys since last airdrop)
1103             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1104             
1105             // update player 
1106             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1107             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1108             
1109             // update round
1110             round_[_rID].keys = _keys.add(round_[_rID].keys);
1111             round_[_rID].eth = _eth.add(round_[_rID].eth);
1112             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1113     
1114             // distribute eth
1115             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1116             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1117             
1118             // call end tx function to fire end tx event.
1119             endTx(_pID, _team, _eth, _keys, _eventData_);
1120         }
1121     }
1122 //==============================================================================
1123 //     _ _ | _   | _ _|_ _  _ _  .
1124 //    (_(_||(_|_||(_| | (_)| _\  .
1125 //==============================================================================
1126     /**
1127      * @dev calculates unmasked earnings (just calculates, does not update mask)
1128      * @return earnings in wei format
1129      */
1130     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1131         private
1132         view
1133         returns(uint256)
1134     {
1135         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1136     }
1137     
1138     /** 
1139      * @dev returns the amount of keys you would get given an amount of eth. 
1140      * -functionhash- 0xce89c80c
1141      * @param _rID round ID you want price for
1142      * @param _eth amount of eth sent in 
1143      * @return keys received 
1144      */
1145     function calcKeysReceived(uint256 _rID, uint256 _eth)
1146         public
1147         view
1148         returns(uint256)
1149     {
1150         // grab time
1151         uint256 _now = now;
1152         
1153         // are we in a round?
1154         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1155             return ( (round_[_rID].eth).keysRec(_eth) );
1156         else // rounds over.  need keys for new round
1157             return ( (_eth).keys() );
1158     }
1159     
1160     /** 
1161      * @dev returns current eth price for X keys.  
1162      * -functionhash- 0xcf808000
1163      * @param _keys number of keys desired (in 18 decimal format)
1164      * @return amount of eth needed to send
1165      */
1166     function iWantXKeys(uint256 _keys)
1167         public
1168         view
1169         returns(uint256)
1170     {
1171         // setup local rID
1172         uint256 _rID = rID_;
1173         
1174         // grab time
1175         uint256 _now = now;
1176         
1177         // are we in a round?
1178         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1179             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1180         else // rounds over.  need price for new round
1181             return ( (_keys).eth() );
1182     }
1183 //==============================================================================
1184 //    _|_ _  _ | _  .
1185 //     | (_)(_)|_\  .
1186 //==============================================================================
1187     /**
1188      * @dev receives name/player info from names contract 
1189      */
1190     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1191         external
1192     {
1193         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1194         if (pIDxAddr_[_addr] != _pID)
1195             pIDxAddr_[_addr] = _pID;
1196         if (pIDxName_[_name] != _pID)
1197             pIDxName_[_name] = _pID;
1198         if (plyr_[_pID].addr != _addr)
1199             plyr_[_pID].addr = _addr;
1200         if (plyr_[_pID].name != _name)
1201             plyr_[_pID].name = _name;
1202         if (plyr_[_pID].laff != _laff)
1203             plyr_[_pID].laff = _laff;
1204         if (plyrNames_[_pID][_name] == false)
1205             plyrNames_[_pID][_name] = true;
1206     }
1207     
1208     /**
1209      * @dev receives entire player name list 
1210      */
1211     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1212         external
1213     {
1214         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1215         if(plyrNames_[_pID][_name] == false)
1216             plyrNames_[_pID][_name] = true;
1217     }   
1218         
1219     /**
1220      * @dev gets existing or registers new pID.  use this when a player may be new
1221      * @return pID 
1222      */
1223     function determinePID(PCKdatasets.EventReturns memory _eventData_)
1224         private
1225         returns (PCKdatasets.EventReturns)
1226     {
1227         uint256 _pID = pIDxAddr_[msg.sender];
1228         // if player is new to this version of fomo3d
1229         if (_pID == 0)
1230         {
1231             // grab their player ID, name and last aff ID, from player names contract 
1232             _pID = PlayerBook.getPlayerID(msg.sender);
1233             bytes32 _name = PlayerBook.getPlayerName(_pID);
1234             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1235             
1236             // set up player account 
1237             pIDxAddr_[msg.sender] = _pID;
1238             plyr_[_pID].addr = msg.sender;
1239             
1240             if (_name != "")
1241             {
1242                 pIDxName_[_name] = _pID;
1243                 plyr_[_pID].name = _name;
1244                 plyrNames_[_pID][_name] = true;
1245             }
1246             
1247             if (_laff != 0 && _laff != _pID)
1248                 plyr_[_pID].laff = _laff;
1249             
1250             // set the new player bool to true
1251             _eventData_.compressedData = _eventData_.compressedData + 1;
1252         } 
1253         return (_eventData_);
1254     }
1255     
1256     /**
1257      * @dev checks to make sure user picked a valid team.  if not sets team 
1258      * to default (sneks)
1259      */
1260     function verifyTeam(uint256 _team)
1261         private
1262         pure
1263         returns (uint256)
1264     {
1265         if (_team < 0 || _team > 3)
1266             return(2);
1267         else
1268             return(_team);
1269     }
1270     
1271     /**
1272      * @dev decides if round end needs to be run & new round started.  and if 
1273      * player unmasked earnings from previously played rounds need to be moved.
1274      */
1275     function managePlayer(uint256 _pID, PCKdatasets.EventReturns memory _eventData_)
1276         private
1277         returns (PCKdatasets.EventReturns)
1278     {
1279         // if player has played a previous round, move their unmasked earnings
1280         // from that round to gen vault.
1281         if (plyr_[_pID].lrnd != 0)
1282             updateGenVault(_pID, plyr_[_pID].lrnd);
1283             
1284         // update player's last round played
1285         plyr_[_pID].lrnd = rID_;
1286             
1287         // set the joined round bool to true
1288         _eventData_.compressedData = _eventData_.compressedData + 10;
1289         
1290         return(_eventData_);
1291     }
1292 
1293 
1294     function nextRound() private {
1295         rID_++;
1296         round_[rID_].strt = now;
1297         round_[rID_].end = now.add(rndInit_).add(rndGap_);
1298     }
1299     
1300     /**
1301      * @dev ends the round. manages paying out winner/splitting up pot
1302      */
1303     function endRound(PCKdatasets.EventReturns memory _eventData_)
1304         private
1305         returns (PCKdatasets.EventReturns)
1306     {
1307 
1308         // setup local rID
1309         uint256 _rID = rID_;
1310         
1311         // grab our winning player and team id's
1312         uint256 _winPID = round_[_rID].plyr;
1313         uint256 _winTID = round_[_rID].team;
1314         
1315         // grab our pot amount
1316         uint256 _pot = round_[_rID].pot;
1317         
1318         // calculate our winner share, community rewards, gen share, 
1319         // p3d share, and amount reserved for next pot 
1320         uint256 _win = (_pot.mul(48)) / 100;
1321         uint256 _com = (_pot / 50);
1322         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1323         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1324         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1325         
1326         // calculate ppt for round mask
1327         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1328         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1329         if (_dust > 0)
1330         {
1331             _gen = _gen.sub(_dust);
1332             _res = _res.add(_dust);
1333         }
1334         
1335         // pay our winner
1336         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1337         
1338         // community rewards
1339         if (!address(Pro_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1340         {
1341             // This ensures Team Just cannot influence the outcome of FoMo3D with
1342             // bank migrations by breaking outgoing transactions.
1343             // Something we would never do. But that's not the point.
1344             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1345             // highest belief that everything we create should be trustless.
1346             // Team JUST, The name you shouldn't have to trust.
1347             _p3d = _p3d.add(_com);
1348             _com = 0;
1349         }
1350         
1351         // distribute gen portion to key holders
1352         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1353         
1354         // send share for p3d to PCGod
1355         if (_p3d > 0)
1356             PCGod.deposit.value(_p3d)();
1357             
1358         // prepare event data
1359         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1360         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1361         _eventData_.winnerAddr = plyr_[_winPID].addr;
1362         _eventData_.winnerName = plyr_[_winPID].name;
1363         _eventData_.amountWon = _win;
1364         _eventData_.genAmount = _gen;
1365         _eventData_.PCPAmount = _p3d;
1366         _eventData_.newPot = _res;
1367         
1368         // start next round
1369         //rID_++;
1370         _rID++;
1371         round_[_rID].ended = false;
1372         round_[_rID].strt = now;
1373         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1374         round_[_rID].pot = _res;
1375         
1376         return(_eventData_);
1377     }
1378     
1379     /**
1380      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1381      */
1382     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1383         private 
1384     {
1385         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1386         if (_earnings > 0)
1387         {
1388             // put in gen vault
1389             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1390             // zero out their earnings by updating mask
1391             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1392         }
1393     }
1394     
1395     /**
1396      * @dev updates round timer based on number of whole keys bought.
1397      */
1398     function updateTimer(uint256 _keys, uint256 _rID, uint256 _eth)
1399         private
1400     {
1401         // grab time
1402         uint256 _now = now;
1403         
1404         // calculate time based on number of keys bought
1405         uint256 _newTime;
1406         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1407             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1408         else
1409             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1410         
1411         // compare to max and set new end time
1412         uint256 _newEndTime;
1413         if (_newTime < (rndMax_).add(_now))
1414             _newEndTime = _newTime;
1415         else
1416             _newEndTime = rndMax_.add(_now);
1417 
1418         // biger to threshold, reduce
1419         if ( _eth >= rndReduceThreshold_ ) {
1420             _newEndTime = (_newEndTime).sub( (((_keys) / (1000000000000000000))).mul(rndInc_).add( (((_keys) / (2000000000000000000) ).mul(rndInc_)) ) );
1421 
1422             // last add 10 minutes
1423             if( _newEndTime < _now + rndMin_ )
1424                 _newEndTime = _now + rndMin_ ;
1425         }
1426 
1427         round_[_rID].end = _newEndTime;
1428     }
1429     
1430     /**
1431      * @dev generates a random number between 0-99 and checks to see if thats
1432      * resulted in an airdrop win
1433      * @return do we have a winner?
1434      */
1435     function airdrop() private view returns(bool) {
1436         uint256 seed = uint256(keccak256(abi.encodePacked(
1437             
1438             (block.timestamp).add
1439             (block.difficulty).add
1440             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1441             (block.gaslimit).add
1442             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1443             (block.number)
1444             
1445         )));
1446         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1447             return(true);
1448         else
1449             return(false);
1450     }
1451 
1452     /**
1453      * @dev distributes eth based on fees to com, aff, and p3d
1454      */
1455     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_)
1456         private
1457         returns(PCKdatasets.EventReturns)
1458     {
1459         // pay 2% out to community rewards
1460         uint256 _com = _eth / 50;
1461         uint256 _p3d;
1462         if (!address(Pro_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1463         {
1464             // This ensures Team Just cannot influence the outcome of FoMo3D with
1465             // bank migrations by breaking outgoing transactions.
1466             // Something we would never do. But that's not the point.
1467             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1468             // highest belief that everything we create should be trustless.
1469             // Team JUST, The name you shouldn't have to trust.
1470             _p3d = _com;
1471             _com = 0;
1472         }
1473         
1474         // pay 1% out to FoMo3D short
1475         uint256 _long = _eth / 100;
1476         otherPCK_.potSwap.value(_long)();
1477         
1478         // distribute share to affiliate
1479         uint256 _aff = _eth / 10;
1480         
1481         // decide what to do with affiliate share of fees
1482         // affiliate must not be self, and must have a name registered
1483         if (_affID != _pID && plyr_[_affID].name != '') {
1484             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1485             emit PCKevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1486         } else {
1487             _p3d = _aff;
1488         }
1489         
1490         // pay out p3d
1491         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1492         if (_p3d > 0)
1493         {
1494             // deposit to PCGod contract
1495             PCGod.deposit.value(_p3d)();
1496             
1497             // set up event data
1498             _eventData_.PCPAmount = _p3d.add(_eventData_.PCPAmount);
1499         }
1500         
1501         return(_eventData_);
1502     }
1503     
1504     function potSwap()
1505         external
1506         payable
1507     {
1508         // setup local rID
1509         uint256 _rID = rID_ + 1;
1510         
1511         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1512         emit PCKevents.onPotSwapDeposit(_rID, msg.value);
1513     }
1514     
1515     /**
1516      * @dev distributes eth based on fees to gen and pot
1517      */
1518     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, PCKdatasets.EventReturns memory _eventData_)
1519         private
1520         returns(PCKdatasets.EventReturns)
1521     {
1522         // calculate gen share
1523         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1524         
1525         // toss 1% into airdrop pot 
1526         uint256 _air = (_eth / 100);
1527         airDropPot_ = airDropPot_.add(_air);
1528         
1529         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1530         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1531         
1532         // calculate pot 
1533         uint256 _pot = _eth.sub(_gen);
1534         
1535         // distribute gen share (thats what updateMasks() does) and adjust
1536         // balances for dust.
1537         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1538         if (_dust > 0)
1539             _gen = _gen.sub(_dust);
1540         
1541         // add eth to pot
1542         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1543         
1544         // set up event data
1545         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1546         _eventData_.potAmount = _pot;
1547         
1548         return(_eventData_);
1549     }
1550 
1551     /**
1552      * @dev updates masks for round and player when keys are bought
1553      * @return dust left over 
1554      */
1555     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1556         private
1557         returns(uint256)
1558     {
1559         /* MASKING NOTES
1560             earnings masks are a tricky thing for people to wrap their minds around.
1561             the basic thing to understand here.  is were going to have a global
1562             tracker based on profit per share for each round, that increases in
1563             relevant proportion to the increase in share supply.
1564             
1565             the player will have an additional mask that basically says "based
1566             on the rounds mask, my shares, and how much i've already withdrawn,
1567             how much is still owed to me?"
1568         */
1569         
1570         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1571         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1572         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1573             
1574         // calculate player earning from their own buy (only based on the keys
1575         // they just bought).  & update player earnings mask
1576         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1577         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1578         
1579         // calculate & return dust
1580         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1581     }
1582     
1583     /**
1584      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1585      * @return earnings in wei format
1586      */
1587     function withdrawEarnings(uint256 _pID)
1588         private
1589         returns(uint256)
1590     {
1591         // update gen vault
1592         updateGenVault(_pID, plyr_[_pID].lrnd);
1593         
1594         // from vaults 
1595         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1596         if (_earnings > 0)
1597         {
1598             plyr_[_pID].win = 0;
1599             plyr_[_pID].gen = 0;
1600             plyr_[_pID].aff = 0;
1601         }
1602 
1603         return(_earnings);
1604     }
1605     
1606     /**
1607      * @dev prepares compression data and fires event for buy or reload tx's
1608      */
1609     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, PCKdatasets.EventReturns memory _eventData_)
1610         private
1611     {
1612         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1613         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1614         
1615         emit PCKevents.onEndTx
1616         (
1617             _eventData_.compressedData,
1618             _eventData_.compressedIDs,
1619             plyr_[_pID].name,
1620             msg.sender,
1621             _eth,
1622             _keys,
1623             _eventData_.winnerAddr,
1624             _eventData_.winnerName,
1625             _eventData_.amountWon,
1626             _eventData_.newPot,
1627             _eventData_.PCPAmount,
1628             _eventData_.genAmount,
1629             _eventData_.potAmount,
1630             airDropPot_
1631         );
1632     }
1633 //==============================================================================
1634 //    (~ _  _    _._|_    .
1635 //    _)(/_(_|_|| | | \/  .
1636 //====================/=========================================================
1637     /** upon contract deploy, it will be deactivated.  this is a one time
1638      * use function that will activate the contract.  we do this so devs 
1639      * have time to set things up on the web end                            **/
1640     bool public activated_ = false;
1641     function activate() public {
1642         // only team just can activate 
1643         require(
1644             msg.sender == admin,
1645             "only team just can activate"
1646         );
1647 
1648         // make sure that its been linked.
1649         require(address(otherPCK_) != address(0), "must link to other PCK first");
1650         
1651         // can only be ran once
1652         require(activated_ == false, "PCK already activated");
1653         
1654         // activate the contract 
1655         activated_ = true;
1656         
1657         // lets start first round
1658         rID_ = 1;
1659         round_[1].strt = now + rndExtra_ - rndGap_;
1660         round_[1].end = now + rndInit_ + rndExtra_;
1661     }
1662 
1663     function setOtherPCK(address _otherPCK) public {
1664         // only team just can activate 
1665         require(
1666             msg.sender == admin,
1667             "only team just can activate"
1668         );
1669 
1670         // make sure that it HASNT yet been linked.
1671         require(address(otherPCK_) == address(0), "silly dev, you already did that");
1672         
1673         // set up other fomo3d (fast or long) for pot swap
1674         otherPCK_ = otherPCK(_otherPCK);
1675     }
1676 }
1677 
1678 //==============================================================================
1679 //   __|_ _    __|_ _  .
1680 //  _\ | | |_|(_ | _\  .
1681 //==============================================================================
1682 library PCKdatasets {
1683     //compressedData key
1684     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1685         // 0 - new player (bool)
1686         // 1 - joined round (bool)
1687         // 2 - new  leader (bool)
1688         // 3-5 - air drop tracker (uint 0-999)
1689         // 6-16 - round end time
1690         // 17 - winnerTeam
1691         // 18 - 28 timestamp 
1692         // 29 - team
1693         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1694         // 31 - airdrop happened bool
1695         // 32 - airdrop tier 
1696         // 33 - airdrop amount won
1697     //compressedIDs key
1698     // [77-52][51-26][25-0]
1699         // 0-25 - pID 
1700         // 26-51 - winPID
1701         // 52-77 - rID
1702     struct EventReturns {
1703         uint256 compressedData;
1704         uint256 compressedIDs;
1705         address winnerAddr;         // winner address
1706         bytes32 winnerName;         // winner name
1707         uint256 amountWon;          // amount won
1708         uint256 newPot;             // amount in new pot
1709         uint256 PCPAmount;          // amount distributed to p3d
1710         uint256 genAmount;          // amount distributed to gen
1711         uint256 potAmount;          // amount added to pot
1712     }
1713     struct Player {
1714         address addr;   // player address
1715         bytes32 name;   // player name
1716         uint256 win;    // winnings vault
1717         uint256 gen;    // general vault
1718         uint256 aff;    // affiliate vault
1719         uint256 lrnd;   // last round played
1720         uint256 laff;   // last affiliate id used
1721     }
1722     struct PlayerRounds {
1723         uint256 eth;    // eth player has added to round (used for eth limiter)
1724         uint256 keys;   // keys
1725         uint256 mask;   // player mask 
1726         uint256 ico;    // ICO phase investment
1727     }
1728     struct Round {
1729         uint256 plyr;   // pID of player in lead
1730         uint256 team;   // tID of team in lead
1731         uint256 end;    // time ends/ended
1732         bool ended;     // has round end function been ran
1733         uint256 strt;   // time round started
1734         uint256 keys;   // keys
1735         uint256 eth;    // total eth in
1736         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1737         uint256 mask;   // global mask
1738         uint256 ico;    // total eth sent in during ICO phase
1739         uint256 icoGen; // total eth for gen during ICO phase
1740         uint256 icoAvg; // average key price for ICO phase
1741     }
1742     struct TeamFee {
1743         uint256 gen;    // % of buy in thats paid to key holders of current round
1744         uint256 p3d;    // % of buy in thats paid to p3d holders
1745     }
1746     struct PotSplit {
1747         uint256 gen;    // % of pot thats paid to key holders of current round
1748         uint256 p3d;    // % of pot thats paid to p3d holders
1749     }
1750 }
1751 
1752 //==============================================================================
1753 //  |  _      _ _ | _  .
1754 //  |<(/_\/  (_(_||(_  .
1755 //=======/======================================================================
1756 library PCKKeysCalcLong {
1757     using SafeMath for *;
1758     /**
1759      * @dev calculates number of keys received given X eth 
1760      * @param _curEth current amount of eth in contract 
1761      * @param _newEth eth being spent
1762      * @return amount of ticket purchased
1763      */
1764     function keysRec(uint256 _curEth, uint256 _newEth)
1765         internal
1766         pure
1767         returns (uint256)
1768     {
1769         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1770     }
1771     
1772     /**
1773      * @dev calculates amount of eth received if you sold X keys 
1774      * @param _curKeys current amount of keys that exist 
1775      * @param _sellKeys amount of keys you wish to sell
1776      * @return amount of eth received
1777      */
1778     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1779         internal
1780         pure
1781         returns (uint256)
1782     {
1783         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1784     }
1785 
1786     /**
1787      * @dev calculates how many keys would exist with given an amount of eth
1788      * @param _eth eth "in contract"
1789      * @return number of keys that would exist
1790      */
1791     function keys(uint256 _eth) 
1792         internal
1793         pure
1794         returns(uint256)
1795     {
1796         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1797     }
1798     
1799     /**
1800      * @dev calculates how much eth would be in contract given a number of keys
1801      * @param _keys number of keys "in contract" 
1802      * @return eth that would exists
1803      */
1804     function eth(uint256 _keys) 
1805         internal
1806         pure
1807         returns(uint256)  
1808     {
1809         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1810     }
1811 }
1812 
1813 //==============================================================================
1814 //  . _ _|_ _  _ |` _  _ _  _  .
1815 //  || | | (/_| ~|~(_|(_(/__\  .
1816 //==============================================================================
1817 interface otherPCK {
1818     function potSwap() external payable;
1819 }
1820 
1821 interface PCKExtSettingInterface {
1822     function getFastGap() external view returns(uint256);
1823     function getLongGap() external view returns(uint256);
1824     function getFastExtra() external view returns(uint256);
1825     function getLongExtra() external view returns(uint256);
1826 }
1827 
1828 interface PlayCoinGodInterface {
1829     function deposit() external payable;
1830 }
1831 
1832 interface ProForwarderInterface {
1833     function deposit() external payable returns(bool);
1834     function status() external view returns(address, address, bool);
1835     function startMigration(address _newCorpBank) external returns(bool);
1836     function cancelMigration() external returns(bool);
1837     function finishMigration() external returns(bool);
1838     function setup(address _firstCorpBank) external;
1839 }
1840 
1841 interface PlayerBookInterface {
1842     function getPlayerID(address _addr) external returns (uint256);
1843     function getPlayerName(uint256 _pID) external view returns (bytes32);
1844     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1845     function getPlayerAddr(uint256 _pID) external view returns (address);
1846     function getNameFee() external view returns (uint256);
1847     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1848     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1849     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1850 }
1851 
1852 
1853 
1854 library NameFilter {
1855     /**
1856      * @dev filters name strings
1857      * -converts uppercase to lower case.  
1858      * -makes sure it does not start/end with a space
1859      * -makes sure it does not contain multiple spaces in a row
1860      * -cannot be only numbers
1861      * -cannot start with 0x 
1862      * -restricts characters to A-Z, a-z, 0-9, and space.
1863      * @return reprocessed string in bytes32 format
1864      */
1865     function nameFilter(string _input)
1866         internal
1867         pure
1868         returns(bytes32)
1869     {
1870         bytes memory _temp = bytes(_input);
1871         uint256 _length = _temp.length;
1872         
1873         //sorry limited to 32 characters
1874         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1875         // make sure it doesnt start with or end with space
1876         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1877         // make sure first two characters are not 0x
1878         if (_temp[0] == 0x30)
1879         {
1880             require(_temp[1] != 0x78, "string cannot start with 0x");
1881             require(_temp[1] != 0x58, "string cannot start with 0X");
1882         }
1883         
1884         // create a bool to track if we have a non number character
1885         bool _hasNonNumber;
1886         
1887         // convert & check
1888         for (uint256 i = 0; i < _length; i++)
1889         {
1890             // if its uppercase A-Z
1891             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1892             {
1893                 // convert to lower case a-z
1894                 _temp[i] = byte(uint(_temp[i]) + 32);
1895                 
1896                 // we have a non number
1897                 if (_hasNonNumber == false)
1898                     _hasNonNumber = true;
1899             } else {
1900                 require
1901                 (
1902                     // require character is a space
1903                     _temp[i] == 0x20 || 
1904                     // OR lowercase a-z
1905                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1906                     // or 0-9
1907                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1908                     "string contains invalid characters"
1909                 );
1910                 // make sure theres not 2x spaces in a row
1911                 if (_temp[i] == 0x20)
1912                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1913                 
1914                 // see if we have a character other than a number
1915                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1916                     _hasNonNumber = true;    
1917             }
1918         }
1919         
1920         require(_hasNonNumber == true, "string cannot be only numbers");
1921         
1922         bytes32 _ret;
1923         assembly {
1924             _ret := mload(add(_temp, 32))
1925         }
1926         return (_ret);
1927     }
1928 }
1929 
1930 /**
1931  * @title SafeMath v0.1.9
1932  * @dev Math operations with safety checks that throw on error
1933  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1934  * - added sqrt
1935  * - added sq
1936  * - added pwr 
1937  * - changed asserts to requires with error log outputs
1938  * - removed div, its useless
1939  */
1940 library SafeMath {
1941     
1942     /**
1943     * @dev Multiplies two numbers, throws on overflow.
1944     */
1945     function mul(uint256 a, uint256 b) 
1946         internal 
1947         pure 
1948         returns (uint256 c) 
1949     {
1950         if (a == 0) {
1951             return 0;
1952         }
1953         c = a * b;
1954         require(c / a == b, "SafeMath mul failed");
1955         return c;
1956     }
1957 
1958     /**
1959     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1960     */
1961     function sub(uint256 a, uint256 b)
1962         internal
1963         pure
1964         returns (uint256) 
1965     {
1966         require(b <= a, "SafeMath sub failed");
1967         return a - b;
1968     }
1969 
1970     /**
1971     * @dev Adds two numbers, throws on overflow.
1972     */
1973     function add(uint256 a, uint256 b)
1974         internal
1975         pure
1976         returns (uint256 c) 
1977     {
1978         c = a + b;
1979         require(c >= a, "SafeMath add failed");
1980         return c;
1981     }
1982     
1983     /**
1984      * @dev gives square root of given x.
1985      */
1986     function sqrt(uint256 x)
1987         internal
1988         pure
1989         returns (uint256 y) 
1990     {
1991         uint256 z = ((add(x,1)) / 2);
1992         y = x;
1993         while (z < y) 
1994         {
1995             y = z;
1996             z = ((add((x / z),z)) / 2);
1997         }
1998     }
1999     
2000     /**
2001      * @dev gives square. multiplies x by x
2002      */
2003     function sq(uint256 x)
2004         internal
2005         pure
2006         returns (uint256)
2007     {
2008         return (mul(x,x));
2009     }
2010     
2011     /**
2012      * @dev x to the power of y 
2013      */
2014     function pwr(uint256 x, uint256 y)
2015         internal 
2016         pure 
2017         returns (uint256)
2018     {
2019         if (x==0)
2020             return (0);
2021         else if (y==0)
2022             return (1);
2023         else 
2024         {
2025             uint256 z = x;
2026             for (uint256 i=1; i < y; i++)
2027                 z = mul(z,x);
2028             return (z);
2029         }
2030     }
2031 }