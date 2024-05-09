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
133     PlayCoinGodInterface constant private PCGod = PlayCoinGodInterface(0x6f93Be8fD47EBb62F54ebd149B58658bf9BaCF4f);
134     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x47D1c777f1853cac97E6b81226B1F5108FBD7B81);
135 //==============================================================================
136 //     _ _  _  |`. _     _ _ |_ | _  _  .
137 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
138 //=================_|===========================================================
139     string constant public name = "PlayCoin Key";
140     string constant public symbol = "PCK";
141     uint256 private rndExtra_ = 15 minutes;     // length of the very first ICO 
142     uint256 private rndGap_ = 15 minutes;         // length of ICO phase, set to 1 year for EOS.
143     uint256 constant private rndInit_ = 12 hours;                // round timer starts at this
144     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
145     uint256 constant private rndMax_ = 6 hours;              // max length a round timer can be
146     uint256 constant private rndMin_ = 10 minutes;
147 
148     uint256 public rndReduceThreshold_ = 10e18;           // 10ETH,reduce
149     bool public closed_ = false;
150     // admin is publish contract
151     address private admin = msg.sender;
152 
153 //==============================================================================
154 //     _| _ _|_ _    _ _ _|_    _   .
155 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
156 //=============================|================================================
157     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
158     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
159     uint256 public rID_;    // round id number / total rounds that have happened
160 
161 //****************
162 // PLAYER DATA 
163 //****************
164     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
165     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
166     mapping (uint256 => PCKdatasets.Player) public plyr_;   // (pID => data) player data
167     mapping (uint256 => mapping (uint256 => PCKdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
168     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
169 //****************
170 // ROUND DATA 
171 //****************
172     mapping (uint256 => PCKdatasets.Round) public round_;   // (rID => data) round data
173     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
174 //****************
175 // TEAM FEE DATA 
176 //****************
177     mapping (uint256 => PCKdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
178     mapping (uint256 => PCKdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
179 //==============================================================================
180 //     _ _  _  __|_ _    __|_ _  _  .
181 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
182 //==============================================================================
183     constructor()
184         public
185     {
186         // Team allocation structures
187         // 0 = whales
188         // 1 = bears
189         // 2 = sneks
190         // 3 = bulls
191 
192         // Team allocation percentages
193         // (PCK, PCP) + (Pot , Referrals, Community)
194             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
195         fees_[0] = PCKdatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
196         fees_[1] = PCKdatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
197         fees_[2] = PCKdatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
198         fees_[3] = PCKdatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
199         
200         // how to split up the final pot based on which team was picked
201         // (PCK, PCP)
202         potSplit_[0] = PCKdatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
203         potSplit_[1] = PCKdatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
204         potSplit_[2] = PCKdatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
205         potSplit_[3] = PCKdatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
206     }
207 //==============================================================================
208 //     _ _  _  _|. |`. _  _ _  .
209 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
210 //==============================================================================
211     /**
212      * @dev used to make sure no one can interact with contract until it has 
213      * been activated. 
214      */
215     modifier isActivated() {
216         require(activated_ == true, "its not ready yet.  check ?eta in discord");
217         _;
218     }
219 
220     modifier isRoundActivated() {
221         require(round_[rID_].ended == false, "the round is finished");
222         _;
223     }
224     
225     /**
226      * @dev prevents contracts from interacting with fomo3d 
227      */
228     modifier isHuman() {
229         address _addr = msg.sender;
230         uint256 _codeLength;
231         
232         require(msg.sender == tx.origin, "sorry humans only");
233         _;
234     }
235 
236     /**
237      * @dev sets boundaries for incoming tx 
238      */
239     modifier isWithinLimits(uint256 _eth) {
240         require(_eth >= 1000000000, "pocket lint: not a valid currency");
241         require(_eth <= 100000000000000000000000, "no vitalik, no");
242         _;    
243     }
244 
245     modifier onlyAdmins() {
246         require(msg.sender == admin, "onlyAdmins failed - msg.sender is not an admin");
247         _;
248     }
249 //==============================================================================
250 //     _    |_ |. _   |`    _  __|_. _  _  _  .
251 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
252 //====|=========================================================================
253     function kill () onlyAdmins() public {
254         require(round_[rID_].ended == true && closed_ == true, "the round is active or not close");
255         selfdestruct(admin);
256     }
257 
258     function getRoundStatus() isActivated() public view returns(uint256, bool){
259         return (rID_, round_[rID_].ended);
260     }
261 
262     function setThreshold(uint256 _threshold) onlyAdmins() public returns(uint256) {
263         rndReduceThreshold_ = _threshold;
264         return rndReduceThreshold_;
265     }
266 
267     function setEnforce(bool _closed) onlyAdmins() public returns(bool, uint256, bool) {
268         closed_ = _closed;
269 
270         // open ,next round
271         if( !closed_ && round_[rID_].ended == true && activated_ == true ){
272             nextRound();
273         }
274         // close,finish current round
275         else if( closed_ && round_[rID_].ended == false && activated_ == true ){
276             round_[rID_].end = now - 1;
277         }
278         
279         // close,roundId,finish
280         return (closed_, rID_, now > round_[rID_].end);
281     }
282     /**
283      * @dev emergency buy uses last stored affiliate ID and team snek
284      */
285     function()
286         isActivated()
287         isRoundActivated()
288         isHuman()
289         isWithinLimits(msg.value)
290         public
291         payable
292     {
293         // set up our tx event data and determine if player is new or not
294         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
295             
296         // fetch player id
297         uint256 _pID = pIDxAddr_[msg.sender];
298         
299         // buy core 
300         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
301     }
302     
303     /**
304      * @dev converts all incoming ethereum to keys.
305      * -functionhash- 0x8f38f309 (using ID for affiliate)
306      * -functionhash- 0x98a0871d (using address for affiliate)
307      * -functionhash- 0xa65b37a1 (using name for affiliate)
308      * @param _affCode the ID/address/name of the player who gets the affiliate fee
309      * @param _team what team is the player playing for?
310      */
311     function buyXid(uint256 _affCode, uint256 _team)
312         isActivated()
313         isRoundActivated()
314         isHuman()
315         isWithinLimits(msg.value)
316         public
317         payable
318     {
319         // set up our tx event data and determine if player is new or not
320         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
321         
322         // fetch player id
323         uint256 _pID = pIDxAddr_[msg.sender];
324         
325         // manage affiliate residuals
326         // if no affiliate code was given or player tried to use their own, lolz
327         if (_affCode == 0 || _affCode == _pID)
328         {
329             // use last stored affiliate code 
330             _affCode = plyr_[_pID].laff;
331             
332         // if affiliate code was given & its not the same as previously stored 
333         } else if (_affCode != plyr_[_pID].laff) {
334             // update last affiliate 
335             plyr_[_pID].laff = _affCode;
336         }
337         
338         // verify a valid team was selected
339         _team = verifyTeam(_team);
340         
341         // buy core 
342         buyCore(_pID, _affCode, _team, _eventData_);
343     }
344     
345     function buyXaddr(address _affCode, uint256 _team)
346         isActivated()
347         isRoundActivated()
348         isHuman()
349         isWithinLimits(msg.value)
350         public
351         payable
352     {
353         // set up our tx event data and determine if player is new or not
354         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
355         
356         // fetch player id
357         uint256 _pID = pIDxAddr_[msg.sender];
358         
359         // manage affiliate residuals
360         uint256 _affID;
361         // if no affiliate code was given or player tried to use their own, lolz
362         if (_affCode == address(0) || _affCode == msg.sender)
363         {
364             // use last stored affiliate code
365             _affID = plyr_[_pID].laff;
366         
367         // if affiliate code was given    
368         } else {
369             // get affiliate ID from aff Code 
370             _affID = pIDxAddr_[_affCode];
371             
372             // if affID is not the same as previously stored 
373             if (_affID != plyr_[_pID].laff)
374             {
375                 // update last affiliate
376                 plyr_[_pID].laff = _affID;
377             }
378         }
379         
380         // verify a valid team was selected
381         _team = verifyTeam(_team);
382         
383         // buy core 
384         buyCore(_pID, _affID, _team, _eventData_);
385     }
386     
387     function buyXname(bytes32 _affCode, uint256 _team)
388         isActivated()
389         isRoundActivated()
390         isHuman()
391         isWithinLimits(msg.value)
392         public
393         payable
394     {
395         // set up our tx event data and determine if player is new or not
396         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
397         
398         // fetch player id
399         uint256 _pID = pIDxAddr_[msg.sender];
400         
401         // manage affiliate residuals
402         uint256 _affID;
403         // if no affiliate code was given or player tried to use their own, lolz
404         if (_affCode == '' || _affCode == plyr_[_pID].name)
405         {
406             // use last stored affiliate code
407             _affID = plyr_[_pID].laff;
408         
409         // if affiliate code was given
410         } else {
411             // get affiliate ID from aff Code
412             _affID = pIDxName_[_affCode];
413             
414             // if affID is not the same as previously stored
415             if (_affID != plyr_[_pID].laff)
416             {
417                 // update last affiliate
418                 plyr_[_pID].laff = _affID;
419             }
420         }
421         
422         // verify a valid team was selected
423         _team = verifyTeam(_team);
424         
425         // buy core 
426         buyCore(_pID, _affID, _team, _eventData_);
427     }
428     
429     /**
430      * @dev essentially the same as buy, but instead of you sending ether 
431      * from your wallet, it uses your unwithdrawn earnings.
432      * -functionhash- 0x349cdcac (using ID for affiliate)
433      * -functionhash- 0x82bfc739 (using address for affiliate)
434      * -functionhash- 0x079ce327 (using name for affiliate)
435      * @param _affCode the ID/address/name of the player who gets the affiliate fee
436      * @param _team what team is the player playing for?
437      * @param _eth amount of earnings to use (remainder returned to gen vault)
438      */
439     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
440         isActivated()
441         isRoundActivated()
442         isHuman()
443         isWithinLimits(_eth)
444         public
445     {
446         // set up our tx event data
447         PCKdatasets.EventReturns memory _eventData_;
448         
449         // fetch player ID
450         uint256 _pID = pIDxAddr_[msg.sender];
451         
452         // manage affiliate residuals
453         // if no affiliate code was given or player tried to use their own, lolz
454         if (_affCode == 0 || _affCode == _pID)
455         {
456             // use last stored affiliate code 
457             _affCode = plyr_[_pID].laff;
458             
459         // if affiliate code was given & its not the same as previously stored 
460         } else if (_affCode != plyr_[_pID].laff) {
461             // update last affiliate 
462             plyr_[_pID].laff = _affCode;
463         }
464 
465         // verify a valid team was selected
466         _team = verifyTeam(_team);
467 
468         // reload core
469         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
470     }
471     
472     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
473         isActivated()
474         isRoundActivated()
475         isHuman()
476         isWithinLimits(_eth)
477         public
478     {
479         // set up our tx event data
480         PCKdatasets.EventReturns memory _eventData_;
481         
482         // fetch player ID
483         uint256 _pID = pIDxAddr_[msg.sender];
484         
485         // manage affiliate residuals
486         uint256 _affID;
487         // if no affiliate code was given or player tried to use their own, lolz
488         if (_affCode == address(0) || _affCode == msg.sender)
489         {
490             // use last stored affiliate code
491             _affID = plyr_[_pID].laff;
492         
493         // if affiliate code was given    
494         } else {
495             // get affiliate ID from aff Code 
496             _affID = pIDxAddr_[_affCode];
497             
498             // if affID is not the same as previously stored 
499             if (_affID != plyr_[_pID].laff)
500             {
501                 // update last affiliate
502                 plyr_[_pID].laff = _affID;
503             }
504         }
505         
506         // verify a valid team was selected
507         _team = verifyTeam(_team);
508         
509         // reload core
510         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
511     }
512     
513     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
514         isActivated()
515         isRoundActivated()
516         isHuman()
517         isWithinLimits(_eth)
518         public
519     {
520         // set up our tx event data
521         PCKdatasets.EventReturns memory _eventData_;
522         
523         // fetch player ID
524         uint256 _pID = pIDxAddr_[msg.sender];
525         
526         // manage affiliate residuals
527         uint256 _affID;
528         // if no affiliate code was given or player tried to use their own, lolz
529         if (_affCode == '' || _affCode == plyr_[_pID].name)
530         {
531             // use last stored affiliate code
532             _affID = plyr_[_pID].laff;
533         
534         // if affiliate code was given
535         } else {
536             // get affiliate ID from aff Code
537             _affID = pIDxName_[_affCode];
538             
539             // if affID is not the same as previously stored
540             if (_affID != plyr_[_pID].laff)
541             {
542                 // update last affiliate
543                 plyr_[_pID].laff = _affID;
544             }
545         }
546         
547         // verify a valid team was selected
548         _team = verifyTeam(_team);
549         
550         // reload core
551         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
552     }
553 
554     /**
555      * @dev withdraws all of your earnings.
556      * -functionhash- 0x3ccfd60b
557      */
558     function withdraw()
559         isActivated()
560         isHuman()
561         public
562     {
563         // setup local rID 
564         uint256 _rID = rID_;
565         
566         // grab time
567         uint256 _now = now;
568         
569         // fetch player ID
570         uint256 _pID = pIDxAddr_[msg.sender];
571         
572         // setup temp var for player eth
573         uint256 _eth;
574         
575         // check to see if round has ended and no one has run round end yet
576         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
577         {
578             // set up our tx event data
579             PCKdatasets.EventReturns memory _eventData_;
580             
581             // end the round (distributes pot)
582             round_[_rID].ended = true;
583             _eventData_ = endRound(_eventData_);
584             
585             // get their earnings
586             _eth = withdrawEarnings(_pID);
587             
588             // gib moni
589             if (_eth > 0)
590                 plyr_[_pID].addr.transfer(_eth);    
591             
592             // build event data
593             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
594             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
595             
596             // fire withdraw and distribute event
597             emit PCKevents.onWithdrawAndDistribute
598             (
599                 msg.sender, 
600                 plyr_[_pID].name, 
601                 _eth, 
602                 _eventData_.compressedData, 
603                 _eventData_.compressedIDs, 
604                 _eventData_.winnerAddr, 
605                 _eventData_.winnerName, 
606                 _eventData_.amountWon, 
607                 _eventData_.newPot, 
608                 _eventData_.PCPAmount, 
609                 _eventData_.genAmount
610             );
611             
612         // in any other situation
613         } else {
614             // get their earnings
615             _eth = withdrawEarnings(_pID);
616             
617             // gib moni
618             if (_eth > 0)
619                 plyr_[_pID].addr.transfer(_eth);
620             
621             // fire withdraw event
622             emit PCKevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
623         }
624     }
625     
626     /**
627      * @dev use these to register names.  they are just wrappers that will send the
628      * registration requests to the PlayerBook contract.  So registering here is the 
629      * same as registering there.  UI will always display the last name you registered.
630      * but you will still own all previously registered names to use as affiliate 
631      * links.
632      * - must pay a registration fee.
633      * - name must be unique
634      * - names will be converted to lowercase
635      * - name cannot start or end with a space 
636      * - cannot have more than 1 space in a row
637      * - cannot be only numbers
638      * - cannot start with 0x 
639      * - name must be at least 1 char
640      * - max length of 32 characters long
641      * - allowed characters: a-z, 0-9, and space
642      * -functionhash- 0x921dec21 (using ID for affiliate)
643      * -functionhash- 0x3ddd4698 (using address for affiliate)
644      * -functionhash- 0x685ffd83 (using name for affiliate)
645      * @param _nameString players desired name
646      * @param _affCode affiliate ID, address, or name of who referred you
647      * @param _all set to true if you want this to push your info to all games 
648      * (this might cost a lot of gas)
649      */
650     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
651         isHuman()
652         public
653         payable
654     {
655         bytes32 _name = _nameString.nameFilter();
656         address _addr = msg.sender;
657         uint256 _paid = msg.value;
658         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
659         
660         uint256 _pID = pIDxAddr_[_addr];
661         
662         // fire event
663         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
664     }
665     
666     function registerNameXaddr(string _nameString, address _affCode, bool _all)
667         isHuman()
668         public
669         payable
670     {
671         bytes32 _name = _nameString.nameFilter();
672         address _addr = msg.sender;
673         uint256 _paid = msg.value;
674         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
675         
676         uint256 _pID = pIDxAddr_[_addr];
677         
678         // fire event
679         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
680     }
681     
682     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
683         isHuman()
684         public
685         payable
686     {
687         bytes32 _name = _nameString.nameFilter();
688         address _addr = msg.sender;
689         uint256 _paid = msg.value;
690         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
691         
692         uint256 _pID = pIDxAddr_[_addr];
693         
694         // fire event
695         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
696     }
697 //==============================================================================
698 //     _  _ _|__|_ _  _ _  .
699 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
700 //=====_|=======================================================================
701     /**
702      * @dev return the price buyer will pay for next 1 individual key.
703      * -functionhash- 0x018a25e8
704      * @return price for next key bought (in wei format)
705      */
706     function getBuyPrice()
707         public 
708         view 
709         returns(uint256)
710     {  
711         // setup local rID
712         uint256 _rID = rID_;
713         
714         // grab time
715         uint256 _now = now;
716         
717         // are we in a round?
718         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
719             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
720         else // rounds over.  need price for new round
721             return ( 75000000000000 ); // init
722     }
723     
724     /**
725      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
726      * provider
727      * -functionhash- 0xc7e284b8
728      * @return time left in seconds
729      */
730     function getTimeLeft()
731         public
732         view
733         returns(uint256)
734     {
735         // setup local rID
736         uint256 _rID = rID_;
737         
738         // grab time
739         uint256 _now = now;
740         
741         if (_now < round_[_rID].end)
742             if (_now > round_[_rID].strt + rndGap_)
743                 return( (round_[_rID].end).sub(_now) );
744             else
745                 return( (round_[_rID].strt + rndGap_).sub(_now) );
746         else
747             return(0);
748     }
749     
750     /**
751      * @dev returns player earnings per vaults 
752      * -functionhash- 0x63066434
753      * @return winnings vault
754      * @return general vault
755      * @return affiliate vault
756      */
757     function getPlayerVaults(uint256 _pID)
758         public
759         view
760         returns(uint256 ,uint256, uint256)
761     {
762         // setup local rID
763         uint256 _rID = rID_;
764         
765         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
766         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
767         {
768             // if player is winner 
769             if (round_[_rID].plyr == _pID)
770             {
771                 return
772                 (
773                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
774                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
775                     plyr_[_pID].aff
776                 );
777             // if player is not the winner
778             } else {
779                 return
780                 (
781                     plyr_[_pID].win,
782                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
783                     plyr_[_pID].aff
784                 );
785             }
786             
787         // if round is still going on, or round has ended and round end has been ran
788         } else {
789             return
790             (
791                 plyr_[_pID].win,
792                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
793                 plyr_[_pID].aff
794             );
795         }
796     }
797     
798     /**
799      * solidity hates stack limits.  this lets us avoid that hate 
800      */
801     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
802         private
803         view
804         returns(uint256)
805     {
806         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
807     }
808     
809     /**
810      * @dev returns all current round info needed for front end
811      * -functionhash- 0x747dff42
812      * @return eth invested during ICO phase
813      * @return round id 
814      * @return total keys for round 
815      * @return time round ends
816      * @return time round started
817      * @return current pot 
818      * @return current team ID & player ID in lead 
819      * @return current player in leads address 
820      * @return current player in leads name
821      * @return whales eth in for round
822      * @return bears eth in for round
823      * @return sneks eth in for round
824      * @return bulls eth in for round
825      * @return airdrop tracker # & airdrop pot
826      */
827     function getCurrentRoundInfo()
828         public
829         view
830         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
831     {
832         // setup local rID
833         uint256 _rID = rID_;
834         
835         return
836         (
837             round_[_rID].ico,               //0
838             _rID,                           //1
839             round_[_rID].keys,              //2
840             round_[_rID].end,               //3
841             round_[_rID].strt,              //4
842             round_[_rID].pot,               //5
843             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
844             plyr_[round_[_rID].plyr].addr,  //7
845             plyr_[round_[_rID].plyr].name,  //8
846             rndTmEth_[_rID][0],             //9
847             rndTmEth_[_rID][1],             //10
848             rndTmEth_[_rID][2],             //11
849             rndTmEth_[_rID][3],             //12
850             airDropTracker_ + (airDropPot_ * 1000)              //13
851         );
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
865      * @return player round eth
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
881         return
882         (
883             _pID,                               //0
884             plyr_[_pID].name,                   //1
885             plyrRnds_[_pID][_rID].keys,         //2
886             plyr_[_pID].win,                    //3
887             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
888             plyr_[_pID].aff,                    //5
889             plyrRnds_[_pID][_rID].eth           //6
890         );
891     }
892 
893 //==============================================================================
894 //     _ _  _ _   | _  _ . _  .
895 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
896 //=====================_|=======================================================
897     /**
898      * @dev logic runs whenever a buy order is executed.  determines how to handle 
899      * incoming eth depending on if we are in an active round or not
900      */
901     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_) private {
902 
903         // setup local rID
904         uint256 _rID = rID_;
905         
906         // grab time
907         uint256 _now = now;
908 
909 
910         
911         // if round is active
912         if (_now > (round_[_rID].strt + rndGap_) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
913         {
914             // call core 
915             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
916         
917         // if round is not active     
918         } else {
919 
920             // check to see if end round needs to be ran
921             if ( _now > round_[_rID].end && round_[_rID].ended == false ) {
922                 // end the round (distributes pot) & start new round
923                 round_[_rID].ended = true;
924                 _eventData_ = endRound(_eventData_);
925 
926                 if( !closed_ ){
927                     nextRound();
928                 }
929                 
930                 // build event data
931                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
932                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
933                 
934                 // fire buy and distribute event 
935                 emit PCKevents.onBuyAndDistribute
936                 (
937                     msg.sender, 
938                     plyr_[_pID].name, 
939                     msg.value, 
940                     _eventData_.compressedData, 
941                     _eventData_.compressedIDs, 
942                     _eventData_.winnerAddr, 
943                     _eventData_.winnerName, 
944                     _eventData_.amountWon, 
945                     _eventData_.newPot, 
946                     _eventData_.PCPAmount, 
947                     _eventData_.genAmount
948                 );
949             }
950             
951             // put eth in players vault 
952             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
953         }
954     }
955     
956     /**
957      * @dev logic runs whenever a reload order is executed.  determines how to handle 
958      * incoming eth depending on if we are in an active round or not 
959      */
960     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, PCKdatasets.EventReturns memory _eventData_) private {
961 
962         // setup local rID
963         uint256 _rID = rID_;
964         
965         // grab time
966         uint256 _now = now;
967         
968         // if round is active
969         if (_now > ( round_[_rID].strt + rndGap_ ) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
970         {
971             // get earnings from all vaults and return unused to gen vault
972             // because we use a custom safemath library.  this will throw if player 
973             // tried to spend more eth than they have.
974             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
975             
976             // call core 
977             core(_rID, _pID, _eth, _affID, _team, _eventData_);
978         
979         // if round is not active and end round needs to be ran   
980         } else if ( _now > round_[_rID].end && round_[_rID].ended == false ) {
981             // end the round (distributes pot) & start new round
982             round_[_rID].ended = true;
983             _eventData_ = endRound(_eventData_);
984 
985             if( !closed_ ) {
986                 nextRound();
987             }
988                 
989             // build event data
990             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
991             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
992                 
993             // fire buy and distribute event 
994             emit PCKevents.onReLoadAndDistribute
995             (
996                 msg.sender, 
997                 plyr_[_pID].name, 
998                 _eventData_.compressedData, 
999                 _eventData_.compressedIDs, 
1000                 _eventData_.winnerAddr, 
1001                 _eventData_.winnerName, 
1002                 _eventData_.amountWon, 
1003                 _eventData_.newPot, 
1004                 _eventData_.PCPAmount, 
1005                 _eventData_.genAmount
1006             );
1007         }
1008     }
1009     
1010     /**
1011      * @dev this is the core logic for any buy/reload that happens while a round 
1012      * is live.
1013      */
1014     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_)
1015         private
1016     {
1017         // if player is new to round
1018         if (plyrRnds_[_pID][_rID].keys == 0)
1019             _eventData_ = managePlayer(_pID, _eventData_);
1020         
1021         // early round eth limiter 
1022         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1023         {
1024             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1025             uint256 _refund = _eth.sub(_availableLimit);
1026             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1027             _eth = _availableLimit;
1028         }
1029         
1030         // if eth left is greater than min eth allowed (sorry no pocket lint)
1031         if (_eth > 1000000000) 
1032         {
1033             
1034             // mint the new keys
1035             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1036             
1037             // if they bought at least 1 whole key
1038             if (_keys >= 1000000000000000000)
1039             {
1040             updateTimer(_keys, _rID, _eth);
1041 
1042             // set new leaders
1043             if (round_[_rID].plyr != _pID)
1044                 round_[_rID].plyr = _pID;  
1045             if (round_[_rID].team != _team)
1046                 round_[_rID].team = _team; 
1047             
1048             // set the new leader bool to true
1049             _eventData_.compressedData = _eventData_.compressedData + 100;
1050         }
1051             
1052         // manage airdrops
1053         if (_eth >= 100000000000000000) {
1054             airDropTracker_++;
1055             if (airdrop() == true) {
1056                 // gib muni
1057                 uint256 _prize;
1058                 if (_eth >= 10000000000000000000)
1059                 {
1060                     // calculate prize and give it to winner
1061                     _prize = ((airDropPot_).mul(75)) / 100;
1062                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1063                     
1064                     // adjust airDropPot 
1065                     airDropPot_ = (airDropPot_).sub(_prize);
1066                     
1067                     // let event know a tier 3 prize was won 
1068                     _eventData_.compressedData += 300000000000000000000000000000000;
1069                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1070                     // calculate prize and give it to winner
1071                     _prize = ((airDropPot_).mul(50)) / 100;
1072                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1073                     
1074                     // adjust airDropPot 
1075                     airDropPot_ = (airDropPot_).sub(_prize);
1076                     
1077                     // let event know a tier 2 prize was won 
1078                     _eventData_.compressedData += 200000000000000000000000000000000;
1079                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1080                     // calculate prize and give it to winner
1081                     _prize = ((airDropPot_).mul(25)) / 100;
1082                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1083                     
1084                     // adjust airDropPot 
1085                     airDropPot_ = (airDropPot_).sub(_prize);
1086                     
1087                     // let event know a tier 3 prize was won 
1088                     _eventData_.compressedData += 300000000000000000000000000000000;
1089                 }
1090                 // set airdrop happened bool to true
1091                 _eventData_.compressedData += 10000000000000000000000000000000;
1092                 // let event know how much was won 
1093                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1094                 
1095                 // reset air drop tracker
1096                 airDropTracker_ = 0;
1097             }
1098         }
1099     
1100             // store the air drop tracker number (number of buys since last airdrop)
1101             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1102             
1103             // update player 
1104             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1105             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1106             
1107             // update round
1108             round_[_rID].keys = _keys.add(round_[_rID].keys);
1109             round_[_rID].eth = _eth.add(round_[_rID].eth);
1110             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1111     
1112             // distribute eth
1113             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1114             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1115             
1116             // call end tx function to fire end tx event.
1117             endTx(_pID, _team, _eth, _keys, _eventData_);
1118         }
1119     }
1120 //==============================================================================
1121 //     _ _ | _   | _ _|_ _  _ _  .
1122 //    (_(_||(_|_||(_| | (_)| _\  .
1123 //==============================================================================
1124     /**
1125      * @dev calculates unmasked earnings (just calculates, does not update mask)
1126      * @return earnings in wei format
1127      */
1128     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1129         private
1130         view
1131         returns(uint256)
1132     {
1133         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1134     }
1135     
1136     /** 
1137      * @dev returns the amount of keys you would get given an amount of eth. 
1138      * -functionhash- 0xce89c80c
1139      * @param _rID round ID you want price for
1140      * @param _eth amount of eth sent in 
1141      * @return keys received 
1142      */
1143     function calcKeysReceived(uint256 _rID, uint256 _eth)
1144         public
1145         view
1146         returns(uint256)
1147     {
1148         // grab time
1149         uint256 _now = now;
1150         
1151         // are we in a round?
1152         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1153             return ( (round_[_rID].eth).keysRec(_eth) );
1154         else // rounds over.  need keys for new round
1155             return ( (_eth).keys() );
1156     }
1157     
1158     /** 
1159      * @dev returns current eth price for X keys.  
1160      * -functionhash- 0xcf808000
1161      * @param _keys number of keys desired (in 18 decimal format)
1162      * @return amount of eth needed to send
1163      */
1164     function iWantXKeys(uint256 _keys)
1165         public
1166         view
1167         returns(uint256)
1168     {
1169         // setup local rID
1170         uint256 _rID = rID_;
1171         
1172         // grab time
1173         uint256 _now = now;
1174         
1175         // are we in a round?
1176         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1177             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1178         else // rounds over.  need price for new round
1179             return ( (_keys).eth() );
1180     }
1181 //==============================================================================
1182 //    _|_ _  _ | _  .
1183 //     | (_)(_)|_\  .
1184 //==============================================================================
1185     /**
1186      * @dev receives name/player info from names contract 
1187      */
1188     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1189         external
1190     {
1191         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1192         if (pIDxAddr_[_addr] != _pID)
1193             pIDxAddr_[_addr] = _pID;
1194         if (pIDxName_[_name] != _pID)
1195             pIDxName_[_name] = _pID;
1196         if (plyr_[_pID].addr != _addr)
1197             plyr_[_pID].addr = _addr;
1198         if (plyr_[_pID].name != _name)
1199             plyr_[_pID].name = _name;
1200         if (plyr_[_pID].laff != _laff)
1201             plyr_[_pID].laff = _laff;
1202         if (plyrNames_[_pID][_name] == false)
1203             plyrNames_[_pID][_name] = true;
1204     }
1205     
1206     /**
1207      * @dev receives entire player name list 
1208      */
1209     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1210         external
1211     {
1212         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1213         if(plyrNames_[_pID][_name] == false)
1214             plyrNames_[_pID][_name] = true;
1215     }   
1216         
1217     /**
1218      * @dev gets existing or registers new pID.  use this when a player may be new
1219      * @return pID 
1220      */
1221     function determinePID(PCKdatasets.EventReturns memory _eventData_)
1222         private
1223         returns (PCKdatasets.EventReturns)
1224     {
1225         uint256 _pID = pIDxAddr_[msg.sender];
1226         // if player is new to this version of fomo3d
1227         if (_pID == 0)
1228         {
1229             // grab their player ID, name and last aff ID, from player names contract 
1230             _pID = PlayerBook.getPlayerID(msg.sender);
1231             bytes32 _name = PlayerBook.getPlayerName(_pID);
1232             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1233             
1234             // set up player account 
1235             pIDxAddr_[msg.sender] = _pID;
1236             plyr_[_pID].addr = msg.sender;
1237             
1238             if (_name != "")
1239             {
1240                 pIDxName_[_name] = _pID;
1241                 plyr_[_pID].name = _name;
1242                 plyrNames_[_pID][_name] = true;
1243             }
1244             
1245             if (_laff != 0 && _laff != _pID)
1246                 plyr_[_pID].laff = _laff;
1247             
1248             // set the new player bool to true
1249             _eventData_.compressedData = _eventData_.compressedData + 1;
1250         } 
1251         return (_eventData_);
1252     }
1253     
1254     /**
1255      * @dev checks to make sure user picked a valid team.  if not sets team 
1256      * to default (sneks)
1257      */
1258     function verifyTeam(uint256 _team)
1259         private
1260         pure
1261         returns (uint256)
1262     {
1263         if (_team < 0 || _team > 3)
1264             return(2);
1265         else
1266             return(_team);
1267     }
1268     
1269     /**
1270      * @dev decides if round end needs to be run & new round started.  and if 
1271      * player unmasked earnings from previously played rounds need to be moved.
1272      */
1273     function managePlayer(uint256 _pID, PCKdatasets.EventReturns memory _eventData_)
1274         private
1275         returns (PCKdatasets.EventReturns)
1276     {
1277         // if player has played a previous round, move their unmasked earnings
1278         // from that round to gen vault.
1279         if (plyr_[_pID].lrnd != 0)
1280             updateGenVault(_pID, plyr_[_pID].lrnd);
1281             
1282         // update player's last round played
1283         plyr_[_pID].lrnd = rID_;
1284             
1285         // set the joined round bool to true
1286         _eventData_.compressedData = _eventData_.compressedData + 10;
1287         
1288         return(_eventData_);
1289     }
1290 
1291 
1292     function nextRound() private {
1293         rID_++;
1294         round_[rID_].strt = now;
1295         round_[rID_].end = now.add(rndInit_).add(rndGap_);
1296     }
1297     
1298     /**
1299      * @dev ends the round. manages paying out winner/splitting up pot
1300      */
1301     function endRound(PCKdatasets.EventReturns memory _eventData_)
1302         private
1303         returns (PCKdatasets.EventReturns)
1304     {
1305 
1306         // setup local rID
1307         uint256 _rID = rID_;
1308         
1309         // grab our winning player and team id's
1310         uint256 _winPID = round_[_rID].plyr;
1311         uint256 _winTID = round_[_rID].team;
1312         
1313         // grab our pot amount
1314         uint256 _pot = round_[_rID].pot;
1315         
1316         // calculate our winner share, community rewards, gen share, 
1317         // p3d share, and amount reserved for next pot 
1318         uint256 _win = (_pot.mul(48)) / 100;
1319         uint256 _com = (_pot / 50);
1320         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1321         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1322         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1323         
1324         // calculate ppt for round mask
1325         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1326         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1327         if (_dust > 0)
1328         {
1329             _gen = _gen.sub(_dust);
1330             _res = _res.add(_dust);
1331         }
1332         
1333         // pay our winner
1334         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1335         
1336         // community rewards
1337         if (!address(admin).call.value(_com)())
1338         {
1339             // This ensures Team Just cannot influence the outcome of FoMo3D with
1340             // bank migrations by breaking outgoing transactions.
1341             // Something we would never do. But that's not the point.
1342             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1343             // highest belief that everything we create should be trustless.
1344             // Team JUST, The name you shouldn't have to trust.
1345             _p3d = _p3d.add(_com);
1346             _com = 0;
1347         }
1348         
1349         // distribute gen portion to key holders
1350         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1351         
1352         // send share for p3d to PCGod
1353         if (_p3d > 0)
1354             PCGod.deposit.value(_p3d)();
1355             
1356         // prepare event data
1357         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1358         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1359         _eventData_.winnerAddr = plyr_[_winPID].addr;
1360         _eventData_.winnerName = plyr_[_winPID].name;
1361         _eventData_.amountWon = _win;
1362         _eventData_.genAmount = _gen;
1363         _eventData_.PCPAmount = _p3d;
1364         _eventData_.newPot = _res;
1365         
1366         // start next round
1367         //rID_++;
1368         _rID++;
1369         round_[_rID].ended = false;
1370         round_[_rID].strt = now;
1371         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1372         round_[_rID].pot = _res;
1373         
1374         return(_eventData_);
1375     }
1376     
1377     /**
1378      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1379      */
1380     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1381         private 
1382     {
1383         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1384         if (_earnings > 0)
1385         {
1386             // put in gen vault
1387             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1388             // zero out their earnings by updating mask
1389             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1390         }
1391     }
1392     
1393     /**
1394      * @dev updates round timer based on number of whole keys bought.
1395      */
1396     function updateTimer(uint256 _keys, uint256 _rID, uint256 _eth)
1397         private
1398     {
1399         // grab time
1400         uint256 _now = now;
1401         
1402         // calculate time based on number of keys bought
1403         uint256 _newTime;
1404         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1405             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1406         else
1407             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1408         
1409         // compare to max and set new end time
1410         uint256 _newEndTime;
1411         if (_newTime < (rndMax_).add(_now))
1412             _newEndTime = _newTime;
1413         else
1414             _newEndTime = rndMax_.add(_now);
1415 
1416         // biger to threshold, reduce
1417         if ( _eth >= rndReduceThreshold_ ) {
1418             _newEndTime = (_newEndTime).sub( (((_keys) / (1000000000000000000))).mul(rndInc_).add( (((_keys) / (2000000000000000000) ).mul(rndInc_)) ) );
1419 
1420             // last add 10 minutes
1421             if( _newEndTime < _now + rndMin_ )
1422                 _newEndTime = _now + rndMin_ ;
1423         }
1424 
1425         round_[_rID].end = _newEndTime;
1426     }
1427     
1428     /**
1429      * @dev generates a random number between 0-99 and checks to see if thats
1430      * resulted in an airdrop win
1431      * @return do we have a winner?
1432      */
1433     function airdrop() private view returns(bool) {
1434         uint256 seed = uint256(keccak256(abi.encodePacked(
1435             
1436             (block.timestamp).add
1437             (block.difficulty).add
1438             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1439             (block.gaslimit).add
1440             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1441             (block.number)
1442             
1443         )));
1444         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1445             return(true);
1446         else
1447             return(false);
1448     }
1449 
1450     /**
1451      * @dev distributes eth based on fees to com, aff, and p3d
1452      */
1453     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_)
1454         private
1455         returns(PCKdatasets.EventReturns)
1456     {
1457         // pay 2% out to community rewards
1458         uint256 _com = _eth / 50;
1459         uint256 _p3d;
1460         if (!address(admin).call.value(_com)())
1461         {
1462             // This ensures Team Just cannot influence the outcome of FoMo3D with
1463             // bank migrations by breaking outgoing transactions.
1464             // Something we would never do. But that's not the point.
1465             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1466             // highest belief that everything we create should be trustless.
1467             // Team JUST, The name you shouldn't have to trust.
1468             _p3d = _com;
1469             _com = 0;
1470         }
1471         
1472         // pay 1% out to FoMo3D short
1473         uint256 _long = _eth / 100;
1474         potSwap(_long);
1475         
1476         // distribute share to affiliate
1477         uint256 _aff = _eth / 10;
1478         
1479         // decide what to do with affiliate share of fees
1480         // affiliate must not be self, and must have a name registered
1481         if (_affID != _pID && plyr_[_affID].name != '') {
1482             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1483             emit PCKevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1484         } else {
1485             _p3d = _aff;
1486         }
1487         
1488         // pay out p3d
1489         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1490         if (_p3d > 0)
1491         {
1492             // deposit to PCGod contract
1493             PCGod.deposit.value(_p3d)();
1494             
1495             // set up event data
1496             _eventData_.PCPAmount = _p3d.add(_eventData_.PCPAmount);
1497         }
1498         
1499         return(_eventData_);
1500     }
1501     
1502     function potSwap(uint256 _pot) private {
1503         // setup local rID
1504         uint256 _rID = rID_ + 1;
1505         
1506         round_[_rID].pot = round_[_rID].pot.add(_pot);
1507         emit PCKevents.onPotSwapDeposit(_rID, _pot);
1508     }
1509     
1510     /**
1511      * @dev distributes eth based on fees to gen and pot
1512      */
1513     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, PCKdatasets.EventReturns memory _eventData_)
1514         private
1515         returns(PCKdatasets.EventReturns)
1516     {
1517         // calculate gen share
1518         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1519         
1520         // toss 1% into airdrop pot 
1521         uint256 _air = (_eth / 100);
1522         airDropPot_ = airDropPot_.add(_air);
1523         
1524         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1525         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1526         
1527         // calculate pot 
1528         uint256 _pot = _eth.sub(_gen);
1529         
1530         // distribute gen share (thats what updateMasks() does) and adjust
1531         // balances for dust.
1532         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1533         if (_dust > 0)
1534             _gen = _gen.sub(_dust);
1535         
1536         // add eth to pot
1537         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1538         
1539         // set up event data
1540         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1541         _eventData_.potAmount = _pot;
1542         
1543         return(_eventData_);
1544     }
1545 
1546     /**
1547      * @dev updates masks for round and player when keys are bought
1548      * @return dust left over 
1549      */
1550     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1551         private
1552         returns(uint256)
1553     {
1554         /* MASKING NOTES
1555             earnings masks are a tricky thing for people to wrap their minds around.
1556             the basic thing to understand here.  is were going to have a global
1557             tracker based on profit per share for each round, that increases in
1558             relevant proportion to the increase in share supply.
1559             
1560             the player will have an additional mask that basically says "based
1561             on the rounds mask, my shares, and how much i've already withdrawn,
1562             how much is still owed to me?"
1563         */
1564         
1565         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1566         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1567         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1568             
1569         // calculate player earning from their own buy (only based on the keys
1570         // they just bought).  & update player earnings mask
1571         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1572         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1573         
1574         // calculate & return dust
1575         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1576     }
1577     
1578     /**
1579      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1580      * @return earnings in wei format
1581      */
1582     function withdrawEarnings(uint256 _pID)
1583         private
1584         returns(uint256)
1585     {
1586         // update gen vault
1587         updateGenVault(_pID, plyr_[_pID].lrnd);
1588         
1589         // from vaults 
1590         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1591         if (_earnings > 0)
1592         {
1593             plyr_[_pID].win = 0;
1594             plyr_[_pID].gen = 0;
1595             plyr_[_pID].aff = 0;
1596         }
1597 
1598         return(_earnings);
1599     }
1600     
1601     /**
1602      * @dev prepares compression data and fires event for buy or reload tx's
1603      */
1604     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, PCKdatasets.EventReturns memory _eventData_)
1605         private
1606     {
1607         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1608         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1609         
1610         emit PCKevents.onEndTx
1611         (
1612             _eventData_.compressedData,
1613             _eventData_.compressedIDs,
1614             plyr_[_pID].name,
1615             msg.sender,
1616             _eth,
1617             _keys,
1618             _eventData_.winnerAddr,
1619             _eventData_.winnerName,
1620             _eventData_.amountWon,
1621             _eventData_.newPot,
1622             _eventData_.PCPAmount,
1623             _eventData_.genAmount,
1624             _eventData_.potAmount,
1625             airDropPot_
1626         );
1627     }
1628 //==============================================================================
1629 //    (~ _  _    _._|_    .
1630 //    _)(/_(_|_|| | | \/  .
1631 //====================/=========================================================
1632     /** upon contract deploy, it will be deactivated.  this is a one time
1633      * use function that will activate the contract.  we do this so devs 
1634      * have time to set things up on the web end                            **/
1635     bool public activated_ = false;
1636     function activate() public {
1637         // only team just can activate 
1638         require(
1639             msg.sender == admin,
1640             "only team just can activate"
1641         );
1642         
1643         // can only be ran once
1644         require(activated_ == false, "PCK already activated");
1645         
1646         // activate the contract 
1647         activated_ = true;
1648         
1649         // lets start first round
1650         rID_ = 1;
1651         round_[1].strt = now + rndExtra_ - rndGap_;
1652         round_[1].end = now + rndInit_ + rndExtra_;
1653     }
1654 
1655 }
1656 
1657 //==============================================================================
1658 //   __|_ _    __|_ _  .
1659 //  _\ | | |_|(_ | _\  .
1660 //==============================================================================
1661 library PCKdatasets {
1662     //compressedData key
1663     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1664         // 0 - new player (bool)
1665         // 1 - joined round (bool)
1666         // 2 - new  leader (bool)
1667         // 3-5 - air drop tracker (uint 0-999)
1668         // 6-16 - round end time
1669         // 17 - winnerTeam
1670         // 18 - 28 timestamp 
1671         // 29 - team
1672         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1673         // 31 - airdrop happened bool
1674         // 32 - airdrop tier 
1675         // 33 - airdrop amount won
1676     //compressedIDs key
1677     // [77-52][51-26][25-0]
1678         // 0-25 - pID 
1679         // 26-51 - winPID
1680         // 52-77 - rID
1681     struct EventReturns {
1682         uint256 compressedData;
1683         uint256 compressedIDs;
1684         address winnerAddr;         // winner address
1685         bytes32 winnerName;         // winner name
1686         uint256 amountWon;          // amount won
1687         uint256 newPot;             // amount in new pot
1688         uint256 PCPAmount;          // amount distributed to p3d
1689         uint256 genAmount;          // amount distributed to gen
1690         uint256 potAmount;          // amount added to pot
1691     }
1692     struct Player {
1693         address addr;   // player address
1694         bytes32 name;   // player name
1695         uint256 win;    // winnings vault
1696         uint256 gen;    // general vault
1697         uint256 aff;    // affiliate vault
1698         uint256 lrnd;   // last round played
1699         uint256 laff;   // last affiliate id used
1700     }
1701     struct PlayerRounds {
1702         uint256 eth;    // eth player has added to round (used for eth limiter)
1703         uint256 keys;   // keys
1704         uint256 mask;   // player mask 
1705         uint256 ico;    // ICO phase investment
1706     }
1707     struct Round {
1708         uint256 plyr;   // pID of player in lead
1709         uint256 team;   // tID of team in lead
1710         uint256 end;    // time ends/ended
1711         bool ended;     // has round end function been ran
1712         uint256 strt;   // time round started
1713         uint256 keys;   // keys
1714         uint256 eth;    // total eth in
1715         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1716         uint256 mask;   // global mask
1717         uint256 ico;    // total eth sent in during ICO phase
1718         uint256 icoGen; // total eth for gen during ICO phase
1719         uint256 icoAvg; // average key price for ICO phase
1720     }
1721     struct TeamFee {
1722         uint256 gen;    // % of buy in thats paid to key holders of current round
1723         uint256 p3d;    // % of buy in thats paid to p3d holders
1724     }
1725     struct PotSplit {
1726         uint256 gen;    // % of pot thats paid to key holders of current round
1727         uint256 p3d;    // % of pot thats paid to p3d holders
1728     }
1729 }
1730 
1731 //==============================================================================
1732 //  |  _      _ _ | _  .
1733 //  |<(/_\/  (_(_||(_  .
1734 //=======/======================================================================
1735 library PCKKeysCalcLong {
1736     using SafeMath for *;
1737     /**
1738      * @dev calculates number of keys received given X eth 
1739      * @param _curEth current amount of eth in contract 
1740      * @param _newEth eth being spent
1741      * @return amount of ticket purchased
1742      */
1743     function keysRec(uint256 _curEth, uint256 _newEth)
1744         internal
1745         pure
1746         returns (uint256)
1747     {
1748         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1749     }
1750     
1751     /**
1752      * @dev calculates amount of eth received if you sold X keys 
1753      * @param _curKeys current amount of keys that exist 
1754      * @param _sellKeys amount of keys you wish to sell
1755      * @return amount of eth received
1756      */
1757     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1758         internal
1759         pure
1760         returns (uint256)
1761     {
1762         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1763     }
1764 
1765     /**
1766      * @dev calculates how many keys would exist with given an amount of eth
1767      * @param _eth eth "in contract"
1768      * @return number of keys that would exist
1769      */
1770     function keys(uint256 _eth) 
1771         internal
1772         pure
1773         returns(uint256)
1774     {
1775         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1776     }
1777     
1778     /**
1779      * @dev calculates how much eth would be in contract given a number of keys
1780      * @param _keys number of keys "in contract" 
1781      * @return eth that would exists
1782      */
1783     function eth(uint256 _keys) 
1784         internal
1785         pure
1786         returns(uint256)  
1787     {
1788         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1789     }
1790 }
1791 
1792 //==============================================================================
1793 //  . _ _|_ _  _ |` _  _ _  _  .
1794 //  || | | (/_| ~|~(_|(_(/__\  .
1795 //==============================================================================
1796 
1797 interface PCKExtSettingInterface {
1798     function getFastGap() external view returns(uint256);
1799     function getLongGap() external view returns(uint256);
1800     function getFastExtra() external view returns(uint256);
1801     function getLongExtra() external view returns(uint256);
1802 }
1803 
1804 interface PlayCoinGodInterface {
1805     function deposit() external payable;
1806 }
1807 
1808 interface ProForwarderInterface {
1809     function deposit() external payable returns(bool);
1810     function status() external view returns(address, address, bool);
1811     function startMigration(address _newCorpBank) external returns(bool);
1812     function cancelMigration() external returns(bool);
1813     function finishMigration() external returns(bool);
1814     function setup(address _firstCorpBank) external;
1815 }
1816 
1817 interface PlayerBookInterface {
1818     function getPlayerID(address _addr) external returns (uint256);
1819     function getPlayerName(uint256 _pID) external view returns (bytes32);
1820     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1821     function getPlayerAddr(uint256 _pID) external view returns (address);
1822     function getNameFee() external view returns (uint256);
1823     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1824     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1825     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1826 }
1827 
1828 
1829 
1830 library NameFilter {
1831     /**
1832      * @dev filters name strings
1833      * -converts uppercase to lower case.  
1834      * -makes sure it does not start/end with a space
1835      * -makes sure it does not contain multiple spaces in a row
1836      * -cannot be only numbers
1837      * -cannot start with 0x 
1838      * -restricts characters to A-Z, a-z, 0-9, and space.
1839      * @return reprocessed string in bytes32 format
1840      */
1841     function nameFilter(string _input)
1842         internal
1843         pure
1844         returns(bytes32)
1845     {
1846         bytes memory _temp = bytes(_input);
1847         uint256 _length = _temp.length;
1848         
1849         //sorry limited to 32 characters
1850         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1851         // make sure it doesnt start with or end with space
1852         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1853         // make sure first two characters are not 0x
1854         if (_temp[0] == 0x30)
1855         {
1856             require(_temp[1] != 0x78, "string cannot start with 0x");
1857             require(_temp[1] != 0x58, "string cannot start with 0X");
1858         }
1859         
1860         // create a bool to track if we have a non number character
1861         bool _hasNonNumber;
1862         
1863         // convert & check
1864         for (uint256 i = 0; i < _length; i++)
1865         {
1866             // if its uppercase A-Z
1867             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1868             {
1869                 // convert to lower case a-z
1870                 _temp[i] = byte(uint(_temp[i]) + 32);
1871                 
1872                 // we have a non number
1873                 if (_hasNonNumber == false)
1874                     _hasNonNumber = true;
1875             } else {
1876                 require
1877                 (
1878                     // require character is a space
1879                     _temp[i] == 0x20 || 
1880                     // OR lowercase a-z
1881                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1882                     // or 0-9
1883                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1884                     "string contains invalid characters"
1885                 );
1886                 // make sure theres not 2x spaces in a row
1887                 if (_temp[i] == 0x20)
1888                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1889                 
1890                 // see if we have a character other than a number
1891                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1892                     _hasNonNumber = true;    
1893             }
1894         }
1895         
1896         require(_hasNonNumber == true, "string cannot be only numbers");
1897         
1898         bytes32 _ret;
1899         assembly {
1900             _ret := mload(add(_temp, 32))
1901         }
1902         return (_ret);
1903     }
1904 }
1905 
1906 /**
1907  * @title SafeMath v0.1.9
1908  * @dev Math operations with safety checks that throw on error
1909  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1910  * - added sqrt
1911  * - added sq
1912  * - added pwr 
1913  * - changed asserts to requires with error log outputs
1914  * - removed div, its useless
1915  */
1916 library SafeMath {
1917     
1918     /**
1919     * @dev Multiplies two numbers, throws on overflow.
1920     */
1921     function mul(uint256 a, uint256 b) 
1922         internal 
1923         pure 
1924         returns (uint256 c) 
1925     {
1926         if (a == 0) {
1927             return 0;
1928         }
1929         c = a * b;
1930         require(c / a == b, "SafeMath mul failed");
1931         return c;
1932     }
1933 
1934     /**
1935     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1936     */
1937     function sub(uint256 a, uint256 b)
1938         internal
1939         pure
1940         returns (uint256) 
1941     {
1942         require(b <= a, "SafeMath sub failed");
1943         return a - b;
1944     }
1945 
1946     /**
1947     * @dev Adds two numbers, throws on overflow.
1948     */
1949     function add(uint256 a, uint256 b)
1950         internal
1951         pure
1952         returns (uint256 c) 
1953     {
1954         c = a + b;
1955         require(c >= a, "SafeMath add failed");
1956         return c;
1957     }
1958     
1959     /**
1960      * @dev gives square root of given x.
1961      */
1962     function sqrt(uint256 x)
1963         internal
1964         pure
1965         returns (uint256 y) 
1966     {
1967         uint256 z = ((add(x,1)) / 2);
1968         y = x;
1969         while (z < y) 
1970         {
1971             y = z;
1972             z = ((add((x / z),z)) / 2);
1973         }
1974     }
1975     
1976     /**
1977      * @dev gives square. multiplies x by x
1978      */
1979     function sq(uint256 x)
1980         internal
1981         pure
1982         returns (uint256)
1983     {
1984         return (mul(x,x));
1985     }
1986     
1987     /**
1988      * @dev x to the power of y 
1989      */
1990     function pwr(uint256 x, uint256 y)
1991         internal 
1992         pure 
1993         returns (uint256)
1994     {
1995         if (x==0)
1996             return (0);
1997         else if (y==0)
1998             return (1);
1999         else 
2000         {
2001             uint256 z = x;
2002             for (uint256 i=1; i < y; i++)
2003                 z = mul(z,x);
2004             return (z);
2005         }
2006     }
2007 }