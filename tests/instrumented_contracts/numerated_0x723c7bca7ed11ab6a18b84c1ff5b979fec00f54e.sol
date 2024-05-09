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
133     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x14229878e85e57FF4109dc27bb2EfB5EA8067E6E);
134 //==============================================================================
135 //     _ _  _  |`. _     _ _ |_ | _  _  .
136 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
137 //=================_|===========================================================
138     string constant public name = "PlayCoin Game";
139     string constant public symbol = "PCK";
140     uint256 private rndExtra_ = 2 minutes;     // length of the very first ICO 
141     uint256 private rndGap_ = 15 minutes;         // length of ICO phase, set to 1 year for EOS.
142     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
143     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
144     uint256 constant private rndMax_ = 24 hours;              // max length a round timer can be
145     uint256 constant private rndMin_ = 10 minutes;
146 
147     uint256 public reduceMul_ = 3;
148     uint256 public reduceDiv_ = 2;
149     uint256 public rndReduceThreshold_ = 10e18;           // 10ETH,reduce
150     bool public closed_ = false;
151     // admin is publish contract
152     address private admin = msg.sender;
153 
154 //==============================================================================
155 //     _| _ _|_ _    _ _ _|_    _   .
156 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
157 //=============================|================================================
158     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
159     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
160     uint256 public rID_;    // round id number / total rounds that have happened
161 
162 //****************
163 // PLAYER DATA 
164 //****************
165     mapping (address => uint256) private blacklist_;
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
188 
189         // blacklist
190         blacklist_[0xB04B473418b6f09e5A1f809Ae2d01f14211e03fF] = 1;
191 
192         // Team allocation structures
193         // 0 = whales
194         // 1 = bears
195         // 2 = sneks
196         // 3 = bulls
197 
198         // Team allocation percentages
199         // (PCK, PCP) + (Pot , Referrals, Community)
200             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
201         fees_[0] = PCKdatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
202         fees_[1] = PCKdatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
203         fees_[2] = PCKdatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
204         fees_[3] = PCKdatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
205         
206         // how to split up the final pot based on which team was picked
207         // (PCK, PCP)
208         potSplit_[0] = PCKdatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
209         potSplit_[1] = PCKdatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
210         potSplit_[2] = PCKdatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
211         potSplit_[3] = PCKdatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
212     }
213 //==============================================================================
214 //     _ _  _  _|. |`. _  _ _  .
215 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
216 //==============================================================================
217     /**
218      * @dev used to make sure no one can interact with contract until it has 
219      * been activated. 
220      */
221     modifier isActivated() {
222         require(activated_ == true, "its not ready yet.  check ?eta in discord");
223         _;
224     }
225 
226     modifier isRoundActivated() {
227         require(round_[rID_].ended == false, "the round is finished");
228         _;
229     }
230     
231     /**
232      * @dev prevents contracts from interacting with fomo3d 
233      */
234     modifier isHuman() {
235         
236         require(msg.sender == tx.origin, "sorry humans only");
237         _;
238     }
239 
240     /**
241      * @dev sets boundaries for incoming tx 
242      */
243     modifier isWithinLimits(uint256 _eth) {
244         require(_eth >= 1000000000, "pocket lint: not a valid currency");
245         require(_eth <= 100000000000000000000000, "no vitalik, no");
246         _;    
247     }
248 
249     modifier onlyAdmins() {
250         require(msg.sender == admin, "onlyAdmins failed - msg.sender is not an admin");
251         _;
252     }
253 
254     modifier notBlacklist() {
255         require(blacklist_[msg.sender] == 0, "bad man,shut!");
256         _;
257     }
258 //==============================================================================
259 //     _    |_ |. _   |`    _  __|_. _  _  _  .
260 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
261 //====|=========================================================================
262     function addBlacklist(address _black,bool _in) onlyAdmins() public {
263         if( _in ){
264             blacklist_[_black] = 1 ;
265         } else {
266             delete blacklist_[_black];
267         }
268     }
269 
270     function getBlacklist(address _black) onlyAdmins() public view returns(bool) {
271         return blacklist_[_black] > 0;
272     }
273 
274     function kill () onlyAdmins() public {
275         require(round_[rID_].ended == true && closed_ == true, "the round is active or not close");
276         selfdestruct(admin);
277     }
278 
279     function getRoundStatus() isActivated() public view returns(uint256, bool){
280         return (rID_, round_[rID_].ended);
281     }
282 
283     function setThreshold(uint256 _threshold, uint256 _mul, uint256 _div) onlyAdmins() public {
284 
285         require(_threshold > 0, "threshold must greater 0");
286         require(_mul > 0, "mul must greater 0");
287         require(_div > 0, "div must greater 0");
288 
289 
290         rndReduceThreshold_ = _threshold;
291         reduceMul_ = _mul;
292         reduceDiv_ = _div;
293     }
294 
295     function setEnforce(bool _closed) onlyAdmins() public returns(bool, uint256, bool) {
296         closed_ = _closed;
297 
298         // open ,next round
299         if( !closed_ && round_[rID_].ended == true && activated_ == true ){
300             nextRound();
301         }
302         // close,finish current round
303         else if( closed_ && round_[rID_].ended == false && activated_ == true ){
304             round_[rID_].end = now - 1;
305         }
306         
307         // close,roundId,finish
308         return (closed_, rID_, now > round_[rID_].end);
309     }
310     /**
311      * @dev emergency buy uses last stored affiliate ID and team snek
312      */
313     function()
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
327         // buy core 
328         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
329     }
330     
331     /**
332      * @dev converts all incoming ethereum to keys.
333      * -functionhash- 0x8f38f309 (using ID for affiliate)
334      * -functionhash- 0x98a0871d (using address for affiliate)
335      * -functionhash- 0xa65b37a1 (using name for affiliate)
336      * @param _affCode the ID/address/name of the player who gets the affiliate fee
337      * @param _team what team is the player playing for?
338      */
339     function buyXid(uint256 _affCode, uint256 _team)
340         isActivated()
341         isRoundActivated()
342         isHuman()
343         isWithinLimits(msg.value)
344         public
345         payable
346     {
347         // set up our tx event data and determine if player is new or not
348         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
349         
350         // fetch player id
351         uint256 _pID = pIDxAddr_[msg.sender];
352         
353         // manage affiliate residuals
354         // if no affiliate code was given or player tried to use their own, lolz
355         if (_affCode == 0 || _affCode == _pID)
356         {
357             // use last stored affiliate code 
358             _affCode = plyr_[_pID].laff;
359             
360         // if affiliate code was given & its not the same as previously stored 
361         } else if (_affCode != plyr_[_pID].laff) {
362             // update last affiliate 
363             plyr_[_pID].laff = _affCode;
364         }
365         
366         // verify a valid team was selected
367         _team = verifyTeam(_team);
368         
369         // buy core 
370         buyCore(_pID, _affCode, _team, _eventData_);
371     }
372     
373     function buyXaddr(address _affCode, uint256 _team)
374         isActivated()
375         isRoundActivated()
376         isHuman()
377         isWithinLimits(msg.value)
378         public
379         payable
380     {
381         // set up our tx event data and determine if player is new or not
382         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
383         
384         // fetch player id
385         uint256 _pID = pIDxAddr_[msg.sender];
386         
387         // manage affiliate residuals
388         uint256 _affID;
389         // if no affiliate code was given or player tried to use their own, lolz
390         if (_affCode == address(0) || _affCode == msg.sender)
391         {
392             // use last stored affiliate code
393             _affID = plyr_[_pID].laff;
394         
395         // if affiliate code was given    
396         } else {
397             // get affiliate ID from aff Code 
398             _affID = pIDxAddr_[_affCode];
399             
400             // if affID is not the same as previously stored 
401             if (_affID != plyr_[_pID].laff)
402             {
403                 // update last affiliate
404                 plyr_[_pID].laff = _affID;
405             }
406         }
407         
408         // verify a valid team was selected
409         _team = verifyTeam(_team);
410         
411         // buy core 
412         buyCore(_pID, _affID, _team, _eventData_);
413     }
414     
415     function buyXname(bytes32 _affCode, uint256 _team)
416         isActivated()
417         isRoundActivated()
418         isHuman()
419         isWithinLimits(msg.value)
420         public
421         payable
422     {
423         // set up our tx event data and determine if player is new or not
424         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
425         
426         // fetch player id
427         uint256 _pID = pIDxAddr_[msg.sender];
428         
429         // manage affiliate residuals
430         uint256 _affID;
431         // if no affiliate code was given or player tried to use their own, lolz
432         if (_affCode == '' || _affCode == plyr_[_pID].name)
433         {
434             // use last stored affiliate code
435             _affID = plyr_[_pID].laff;
436         
437         // if affiliate code was given
438         } else {
439             // get affiliate ID from aff Code
440             _affID = pIDxName_[_affCode];
441             
442             // if affID is not the same as previously stored
443             if (_affID != plyr_[_pID].laff)
444             {
445                 // update last affiliate
446                 plyr_[_pID].laff = _affID;
447             }
448         }
449         
450         // verify a valid team was selected
451         _team = verifyTeam(_team);
452         
453         // buy core 
454         buyCore(_pID, _affID, _team, _eventData_);
455     }
456     
457     /**
458      * @dev essentially the same as buy, but instead of you sending ether 
459      * from your wallet, it uses your unwithdrawn earnings.
460      * -functionhash- 0x349cdcac (using ID for affiliate)
461      * -functionhash- 0x82bfc739 (using address for affiliate)
462      * -functionhash- 0x079ce327 (using name for affiliate)
463      * @param _affCode the ID/address/name of the player who gets the affiliate fee
464      * @param _team what team is the player playing for?
465      * @param _eth amount of earnings to use (remainder returned to gen vault)
466      */
467     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
468         isActivated()
469         isRoundActivated()
470         isHuman()
471         isWithinLimits(_eth)
472         public
473     {
474         // set up our tx event data
475         PCKdatasets.EventReturns memory _eventData_;
476         
477         // fetch player ID
478         uint256 _pID = pIDxAddr_[msg.sender];
479         
480         // manage affiliate residuals
481         // if no affiliate code was given or player tried to use their own, lolz
482         if (_affCode == 0 || _affCode == _pID)
483         {
484             // use last stored affiliate code 
485             _affCode = plyr_[_pID].laff;
486             
487         // if affiliate code was given & its not the same as previously stored 
488         } else if (_affCode != plyr_[_pID].laff) {
489             // update last affiliate 
490             plyr_[_pID].laff = _affCode;
491         }
492 
493         // verify a valid team was selected
494         _team = verifyTeam(_team);
495 
496         // reload core
497         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
498     }
499     
500     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
501         isActivated()
502         isRoundActivated()
503         isHuman()
504         isWithinLimits(_eth)
505         public
506     {
507         // set up our tx event data
508         PCKdatasets.EventReturns memory _eventData_;
509         
510         // fetch player ID
511         uint256 _pID = pIDxAddr_[msg.sender];
512         
513         // manage affiliate residuals
514         uint256 _affID;
515         // if no affiliate code was given or player tried to use their own, lolz
516         if (_affCode == address(0) || _affCode == msg.sender)
517         {
518             // use last stored affiliate code
519             _affID = plyr_[_pID].laff;
520         
521         // if affiliate code was given    
522         } else {
523             // get affiliate ID from aff Code 
524             _affID = pIDxAddr_[_affCode];
525             
526             // if affID is not the same as previously stored 
527             if (_affID != plyr_[_pID].laff)
528             {
529                 // update last affiliate
530                 plyr_[_pID].laff = _affID;
531             }
532         }
533         
534         // verify a valid team was selected
535         _team = verifyTeam(_team);
536         
537         // reload core
538         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
539     }
540     
541     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
542         isActivated()
543         isRoundActivated()
544         isHuman()
545         isWithinLimits(_eth)
546         public
547     {
548         // set up our tx event data
549         PCKdatasets.EventReturns memory _eventData_;
550         
551         // fetch player ID
552         uint256 _pID = pIDxAddr_[msg.sender];
553         
554         // manage affiliate residuals
555         uint256 _affID;
556         // if no affiliate code was given or player tried to use their own, lolz
557         if (_affCode == '' || _affCode == plyr_[_pID].name)
558         {
559             // use last stored affiliate code
560             _affID = plyr_[_pID].laff;
561         
562         // if affiliate code was given
563         } else {
564             // get affiliate ID from aff Code
565             _affID = pIDxName_[_affCode];
566             
567             // if affID is not the same as previously stored
568             if (_affID != plyr_[_pID].laff)
569             {
570                 // update last affiliate
571                 plyr_[_pID].laff = _affID;
572             }
573         }
574         
575         // verify a valid team was selected
576         _team = verifyTeam(_team);
577         
578         // reload core
579         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
580     }
581 
582     /**
583      * @dev withdraws all of your earnings.
584      * -functionhash- 0x3ccfd60b
585      */
586     function withdraw()
587         isActivated()
588         isHuman()
589         public
590     {
591         // setup local rID 
592         uint256 _rID = rID_;
593         
594         // grab time
595         uint256 _now = now;
596         
597         // fetch player ID
598         uint256 _pID = pIDxAddr_[msg.sender];
599         
600         // setup temp var for player eth
601         uint256 _eth;
602         
603         // check to see if round has ended and no one has run round end yet
604         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
605         {
606             // set up our tx event data
607             PCKdatasets.EventReturns memory _eventData_;
608             
609             // end the round (distributes pot)
610             round_[_rID].ended = true;
611             _eventData_ = endRound(_eventData_);
612             
613             // get their earnings
614             _eth = withdrawEarnings(_pID);
615             
616             // gib moni
617             if (_eth > 0)
618                 plyr_[_pID].addr.transfer(_eth);    
619             
620             // build event data
621             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
622             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
623             
624             // fire withdraw and distribute event
625             emit PCKevents.onWithdrawAndDistribute
626             (
627                 msg.sender, 
628                 plyr_[_pID].name, 
629                 _eth, 
630                 _eventData_.compressedData, 
631                 _eventData_.compressedIDs, 
632                 _eventData_.winnerAddr, 
633                 _eventData_.winnerName, 
634                 _eventData_.amountWon, 
635                 _eventData_.newPot, 
636                 _eventData_.PCPAmount, 
637                 _eventData_.genAmount
638             );
639             
640         // in any other situation
641         } else {
642             // get their earnings
643             _eth = withdrawEarnings(_pID);
644             
645             // gib moni
646             if (_eth > 0)
647                 plyr_[_pID].addr.transfer(_eth);
648             
649             // fire withdraw event
650             emit PCKevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
651         }
652     }
653     
654     /**
655      * @dev use these to register names.  they are just wrappers that will send the
656      * registration requests to the PlayerBook contract.  So registering here is the 
657      * same as registering there.  UI will always display the last name you registered.
658      * but you will still own all previously registered names to use as affiliate 
659      * links.
660      * - must pay a registration fee.
661      * - name must be unique
662      * - names will be converted to lowercase
663      * - name cannot start or end with a space 
664      * - cannot have more than 1 space in a row
665      * - cannot be only numbers
666      * - cannot start with 0x 
667      * - name must be at least 1 char
668      * - max length of 32 characters long
669      * - allowed characters: a-z, 0-9, and space
670      * -functionhash- 0x921dec21 (using ID for affiliate)
671      * -functionhash- 0x3ddd4698 (using address for affiliate)
672      * -functionhash- 0x685ffd83 (using name for affiliate)
673      * @param _nameString players desired name
674      * @param _affCode affiliate ID, address, or name of who referred you
675      * @param _all set to true if you want this to push your info to all games 
676      * (this might cost a lot of gas)
677      */
678     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
679         isHuman()
680         public
681         payable
682     {
683         bytes32 _name = _nameString.nameFilter();
684         address _addr = msg.sender;
685         uint256 _paid = msg.value;
686         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
687         
688         uint256 _pID = pIDxAddr_[_addr];
689         
690         // fire event
691         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
692     }
693     
694     function registerNameXaddr(string _nameString, address _affCode, bool _all)
695         isHuman()
696         public
697         payable
698     {
699         bytes32 _name = _nameString.nameFilter();
700         address _addr = msg.sender;
701         uint256 _paid = msg.value;
702         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
703         
704         uint256 _pID = pIDxAddr_[_addr];
705         
706         // fire event
707         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
708     }
709     
710     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
711         isHuman()
712         public
713         payable
714     {
715         bytes32 _name = _nameString.nameFilter();
716         address _addr = msg.sender;
717         uint256 _paid = msg.value;
718         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
719         
720         uint256 _pID = pIDxAddr_[_addr];
721         
722         // fire event
723         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
724     }
725 //==============================================================================
726 //     _  _ _|__|_ _  _ _  .
727 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
728 //=====_|=======================================================================
729     /**
730      * @dev return the price buyer will pay for next 1 individual key.
731      * -functionhash- 0x018a25e8
732      * @return price for next key bought (in wei format)
733      */
734     function getBuyPrice()
735         public 
736         view 
737         returns(uint256)
738     {  
739         // setup local rID
740         uint256 _rID = rID_;
741         
742         // grab time
743         uint256 _now = now;
744         
745         // are we in a round?
746         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
747             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
748         else // rounds over.  need price for new round
749             return ( 75000000000000 ); // init
750     }
751     
752     /**
753      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
754      * provider
755      * -functionhash- 0xc7e284b8
756      * @return time left in seconds
757      */
758     function getTimeLeft()
759         public
760         view
761         returns(uint256)
762     {
763         // setup local rID
764         uint256 _rID = rID_;
765         
766         // grab time
767         uint256 _now = now;
768         
769         if (_now < round_[_rID].end)
770             if (_now > round_[_rID].strt + rndGap_)
771                 return( (round_[_rID].end).sub(_now) );
772             else
773                 return( (round_[_rID].strt + rndGap_).sub(_now) );
774         else
775             return(0);
776     }
777     
778     /**
779      * @dev returns player earnings per vaults 
780      * -functionhash- 0x63066434
781      * @return winnings vault
782      * @return general vault
783      * @return affiliate vault
784      */
785     function getPlayerVaults(uint256 _pID)
786         public
787         view
788         returns(uint256 ,uint256, uint256)
789     {
790         // setup local rID
791         uint256 _rID = rID_;
792         
793         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
794         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
795         {
796             // if player is winner 
797             if (round_[_rID].plyr == _pID)
798             {
799                 return
800                 (
801                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
802                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
803                     plyr_[_pID].aff
804                 );
805             // if player is not the winner
806             } else {
807                 return
808                 (
809                     plyr_[_pID].win,
810                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
811                     plyr_[_pID].aff
812                 );
813             }
814             
815         // if round is still going on, or round has ended and round end has been ran
816         } else {
817             return
818             (
819                 plyr_[_pID].win,
820                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
821                 plyr_[_pID].aff
822             );
823         }
824     }
825     
826     /**
827      * solidity hates stack limits.  this lets us avoid that hate 
828      */
829     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
830         private
831         view
832         returns(uint256)
833     {
834         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
835     }
836     
837     /**
838      * @dev returns all current round info needed for front end
839      * -functionhash- 0x747dff42
840      * @return eth invested during ICO phase
841      * @return round id 
842      * @return total keys for round 
843      * @return time round ends
844      * @return time round started
845      * @return current pot 
846      * @return current team ID & player ID in lead 
847      * @return current player in leads address 
848      * @return current player in leads name
849      * @return whales eth in for round
850      * @return bears eth in for round
851      * @return sneks eth in for round
852      * @return bulls eth in for round
853      * @return airdrop tracker # & airdrop pot
854      */
855     function getCurrentRoundInfo()
856         public
857         view
858         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
859     {
860         // setup local rID
861         uint256 _rID = rID_;
862         
863         return
864         (
865             round_[_rID].ico,               //0
866             _rID,                           //1
867             round_[_rID].keys,              //2
868             round_[_rID].end,               //3
869             round_[_rID].strt,              //4
870             round_[_rID].pot,               //5
871             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
872             plyr_[round_[_rID].plyr].addr,  //7
873             plyr_[round_[_rID].plyr].name,  //8
874             rndTmEth_[_rID][0],             //9
875             rndTmEth_[_rID][1],             //10
876             rndTmEth_[_rID][2],             //11
877             rndTmEth_[_rID][3],             //12
878             airDropTracker_ + (airDropPot_ * 1000)              //13
879         );
880     }
881 
882     /**
883      * @dev returns player info based on address.  if no address is given, it will 
884      * use msg.sender 
885      * -functionhash- 0xee0b5d8b
886      * @param _addr address of the player you want to lookup 
887      * @return player ID 
888      * @return player name
889      * @return keys owned (current round)
890      * @return winnings vault
891      * @return general vault 
892      * @return affiliate vault 
893      * @return player round eth
894      */
895     function getPlayerInfoByAddress(address _addr)
896         public 
897         view 
898         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
899     {
900         // setup local rID
901         uint256 _rID = rID_;
902         
903         if (_addr == address(0))
904         {
905             _addr == msg.sender;
906         }
907         uint256 _pID = pIDxAddr_[_addr];
908         
909         return
910         (
911             _pID,                               //0
912             plyr_[_pID].name,                   //1
913             plyrRnds_[_pID][_rID].keys,         //2
914             plyr_[_pID].win,                    //3
915             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
916             plyr_[_pID].aff,                    //5
917             plyrRnds_[_pID][_rID].eth           //6
918         );
919     }
920 
921 //==============================================================================
922 //     _ _  _ _   | _  _ . _  .
923 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
924 //=====================_|=======================================================
925     /**
926      * @dev logic runs whenever a buy order is executed.  determines how to handle 
927      * incoming eth depending on if we are in an active round or not
928      */
929     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_) notBlacklist() private {
930 
931         // setup local rID
932         uint256 _rID = rID_;
933         
934         // grab time
935         uint256 _now = now;
936 
937 
938         
939         // if round is active
940         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
941         {
942             // call core 
943             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
944         
945         // if round is not active     
946         } else {
947 
948             // check to see if end round needs to be ran
949             if ( _now > round_[_rID].end && round_[_rID].ended == false ) {
950                 // end the round (distributes pot) & start new round
951                 round_[_rID].ended = true;
952                 _eventData_ = endRound(_eventData_);
953 
954                 if( !closed_ ){
955                     nextRound();
956                 }
957                 
958                 // build event data
959                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
960                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
961                 
962                 // fire buy and distribute event 
963                 emit PCKevents.onBuyAndDistribute
964                 (
965                     msg.sender, 
966                     plyr_[_pID].name, 
967                     msg.value, 
968                     _eventData_.compressedData, 
969                     _eventData_.compressedIDs, 
970                     _eventData_.winnerAddr, 
971                     _eventData_.winnerName, 
972                     _eventData_.amountWon, 
973                     _eventData_.newPot, 
974                     _eventData_.PCPAmount, 
975                     _eventData_.genAmount
976                 );
977             }
978             
979             // put eth in players vault 
980             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
981         }
982     }
983     
984     /**
985      * @dev logic runs whenever a reload order is executed.  determines how to handle 
986      * incoming eth depending on if we are in an active round or not 
987      */
988     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, PCKdatasets.EventReturns memory _eventData_) private {
989 
990         // setup local rID
991         uint256 _rID = rID_;
992         
993         // grab time
994         uint256 _now = now;
995         
996         // if round is active
997         if (_now > ( round_[_rID].strt + rndGap_ ) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
998         {
999             // get earnings from all vaults and return unused to gen vault
1000             // because we use a custom safemath library.  this will throw if player 
1001             // tried to spend more eth than they have.
1002             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1003             
1004             // call core 
1005             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1006         
1007         // if round is not active and end round needs to be ran   
1008         } else if ( _now > round_[_rID].end && round_[_rID].ended == false ) {
1009             // end the round (distributes pot) & start new round
1010             round_[_rID].ended = true;
1011             _eventData_ = endRound(_eventData_);
1012 
1013             if( !closed_ ) {
1014                 nextRound();
1015             }
1016                 
1017             // build event data
1018             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1019             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1020                 
1021             // fire buy and distribute event 
1022             emit PCKevents.onReLoadAndDistribute
1023             (
1024                 msg.sender, 
1025                 plyr_[_pID].name, 
1026                 _eventData_.compressedData, 
1027                 _eventData_.compressedIDs, 
1028                 _eventData_.winnerAddr, 
1029                 _eventData_.winnerName, 
1030                 _eventData_.amountWon, 
1031                 _eventData_.newPot, 
1032                 _eventData_.PCPAmount, 
1033                 _eventData_.genAmount
1034             );
1035         }
1036     }
1037     
1038     /**
1039      * @dev this is the core logic for any buy/reload that happens while a round 
1040      * is live.
1041      */
1042     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_)
1043         private
1044     {
1045         // if player is new to round
1046         if (plyrRnds_[_pID][_rID].keys == 0)
1047             _eventData_ = managePlayer(_pID, _eventData_);
1048         
1049         // early round eth limiter 
1050         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1051         {
1052             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1053             uint256 _refund = _eth.sub(_availableLimit);
1054             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1055             _eth = _availableLimit;
1056         }
1057         
1058         // if eth left is greater than min eth allowed (sorry no pocket lint)
1059         if (_eth > 1000000000) 
1060         {
1061             
1062             // mint the new keys
1063             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1064             
1065             // if they bought at least 1 whole key
1066             if (_keys >= 1000000000000000000)
1067             {
1068             updateTimer(_keys, _rID, _eth);
1069 
1070             // set new leaders
1071             if (round_[_rID].plyr != _pID)
1072                 round_[_rID].plyr = _pID;  
1073             if (round_[_rID].team != _team)
1074                 round_[_rID].team = _team; 
1075             
1076             // set the new leader bool to true
1077             _eventData_.compressedData = _eventData_.compressedData + 100;
1078         }
1079             
1080         // manage airdrops
1081         if (_eth >= 100000000000000000) {
1082             airDropTracker_++;
1083             if (airdrop() == true) {
1084                 // gib muni
1085                 uint256 _prize;
1086                 if (_eth >= 10000000000000000000)
1087                 {
1088                     // calculate prize and give it to winner
1089                     _prize = ((airDropPot_).mul(75)) / 100;
1090                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1091                     
1092                     // adjust airDropPot 
1093                     airDropPot_ = (airDropPot_).sub(_prize);
1094                     
1095                     // let event know a tier 3 prize was won 
1096                     _eventData_.compressedData += 300000000000000000000000000000000;
1097                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1098                     // calculate prize and give it to winner
1099                     _prize = ((airDropPot_).mul(50)) / 100;
1100                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1101                     
1102                     // adjust airDropPot 
1103                     airDropPot_ = (airDropPot_).sub(_prize);
1104                     
1105                     // let event know a tier 2 prize was won 
1106                     _eventData_.compressedData += 200000000000000000000000000000000;
1107                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1108                     // calculate prize and give it to winner
1109                     _prize = ((airDropPot_).mul(25)) / 100;
1110                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1111                     
1112                     // adjust airDropPot 
1113                     airDropPot_ = (airDropPot_).sub(_prize);
1114                     
1115                     // let event know a tier 3 prize was won 
1116                     _eventData_.compressedData += 300000000000000000000000000000000;
1117                 }
1118                 // set airdrop happened bool to true
1119                 _eventData_.compressedData += 10000000000000000000000000000000;
1120                 // let event know how much was won 
1121                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1122                 
1123                 // reset air drop tracker
1124                 airDropTracker_ = 0;
1125             }
1126         }
1127     
1128             // store the air drop tracker number (number of buys since last airdrop)
1129             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1130             
1131             // update player 
1132             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1133             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1134             
1135             // update round
1136             round_[_rID].keys = _keys.add(round_[_rID].keys);
1137             round_[_rID].eth = _eth.add(round_[_rID].eth);
1138             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1139     
1140             // distribute eth
1141             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1142             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1143             
1144             // call end tx function to fire end tx event.
1145             endTx(_pID, _team, _eth, _keys, _eventData_);
1146         }
1147     }
1148 //==============================================================================
1149 //     _ _ | _   | _ _|_ _  _ _  .
1150 //    (_(_||(_|_||(_| | (_)| _\  .
1151 //==============================================================================
1152     /**
1153      * @dev calculates unmasked earnings (just calculates, does not update mask)
1154      * @return earnings in wei format
1155      */
1156     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1157         private
1158         view
1159         returns(uint256)
1160     {
1161         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1162     }
1163     
1164     /** 
1165      * @dev returns the amount of keys you would get given an amount of eth. 
1166      * -functionhash- 0xce89c80c
1167      * @param _rID round ID you want price for
1168      * @param _eth amount of eth sent in 
1169      * @return keys received 
1170      */
1171     function calcKeysReceived(uint256 _rID, uint256 _eth)
1172         public
1173         view
1174         returns(uint256)
1175     {
1176         // grab time
1177         uint256 _now = now;
1178         
1179         // are we in a round?
1180         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1181             return ( (round_[_rID].eth).keysRec(_eth) );
1182         else // rounds over.  need keys for new round
1183             return ( (_eth).keys() );
1184     }
1185     
1186     /** 
1187      * @dev returns current eth price for X keys.  
1188      * -functionhash- 0xcf808000
1189      * @param _keys number of keys desired (in 18 decimal format)
1190      * @return amount of eth needed to send
1191      */
1192     function iWantXKeys(uint256 _keys)
1193         public
1194         view
1195         returns(uint256)
1196     {
1197         // setup local rID
1198         uint256 _rID = rID_;
1199         
1200         // grab time
1201         uint256 _now = now;
1202         
1203         // are we in a round?
1204         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1205             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1206         else // rounds over.  need price for new round
1207             return ( (_keys).eth() );
1208     }
1209 //==============================================================================
1210 //    _|_ _  _ | _  .
1211 //     | (_)(_)|_\  .
1212 //==============================================================================
1213     /**
1214      * @dev receives name/player info from names contract 
1215      */
1216     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1217         external
1218     {
1219         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1220         if (pIDxAddr_[_addr] != _pID)
1221             pIDxAddr_[_addr] = _pID;
1222         if (pIDxName_[_name] != _pID)
1223             pIDxName_[_name] = _pID;
1224         if (plyr_[_pID].addr != _addr)
1225             plyr_[_pID].addr = _addr;
1226         if (plyr_[_pID].name != _name)
1227             plyr_[_pID].name = _name;
1228         if (plyr_[_pID].laff != _laff)
1229             plyr_[_pID].laff = _laff;
1230         if (plyrNames_[_pID][_name] == false)
1231             plyrNames_[_pID][_name] = true;
1232     }
1233     
1234     /**
1235      * @dev receives entire player name list 
1236      */
1237     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1238         external
1239     {
1240         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1241         if(plyrNames_[_pID][_name] == false)
1242             plyrNames_[_pID][_name] = true;
1243     }   
1244         
1245     /**
1246      * @dev gets existing or registers new pID.  use this when a player may be new
1247      * @return pID 
1248      */
1249     function determinePID(PCKdatasets.EventReturns memory _eventData_)
1250         private
1251         returns (PCKdatasets.EventReturns)
1252     {
1253         uint256 _pID = pIDxAddr_[msg.sender];
1254         // if player is new to this version of fomo3d
1255         if (_pID == 0)
1256         {
1257             // grab their player ID, name and last aff ID, from player names contract 
1258             _pID = PlayerBook.getPlayerID(msg.sender);
1259             bytes32 _name = PlayerBook.getPlayerName(_pID);
1260             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1261             
1262             // set up player account 
1263             pIDxAddr_[msg.sender] = _pID;
1264             plyr_[_pID].addr = msg.sender;
1265             
1266             if (_name != "")
1267             {
1268                 pIDxName_[_name] = _pID;
1269                 plyr_[_pID].name = _name;
1270                 plyrNames_[_pID][_name] = true;
1271             }
1272             
1273             if (_laff != 0 && _laff != _pID)
1274                 plyr_[_pID].laff = _laff;
1275             
1276             // set the new player bool to true
1277             _eventData_.compressedData = _eventData_.compressedData + 1;
1278         } 
1279         return (_eventData_);
1280     }
1281     
1282     /**
1283      * @dev checks to make sure user picked a valid team.  if not sets team 
1284      * to default (sneks)
1285      */
1286     function verifyTeam(uint256 _team)
1287         private
1288         pure
1289         returns (uint256)
1290     {
1291         if (_team < 0 || _team > 3)
1292             return(2);
1293         else
1294             return(_team);
1295     }
1296     
1297     /**
1298      * @dev decides if round end needs to be run & new round started.  and if 
1299      * player unmasked earnings from previously played rounds need to be moved.
1300      */
1301     function managePlayer(uint256 _pID, PCKdatasets.EventReturns memory _eventData_)
1302         private
1303         returns (PCKdatasets.EventReturns)
1304     {
1305         // if player has played a previous round, move their unmasked earnings
1306         // from that round to gen vault.
1307         if (plyr_[_pID].lrnd != 0)
1308             updateGenVault(_pID, plyr_[_pID].lrnd);
1309             
1310         // update player's last round played
1311         plyr_[_pID].lrnd = rID_;
1312             
1313         // set the joined round bool to true
1314         _eventData_.compressedData = _eventData_.compressedData + 10;
1315         
1316         return(_eventData_);
1317     }
1318 
1319 
1320     function nextRound() private {
1321         rID_++;
1322         round_[rID_].strt = now;
1323         round_[rID_].end = now.add(rndInit_).add(rndGap_);
1324     }
1325     
1326     /**
1327      * @dev ends the round. manages paying out winner/splitting up pot
1328      */
1329     function endRound(PCKdatasets.EventReturns memory _eventData_)
1330         private
1331         returns (PCKdatasets.EventReturns)
1332     {
1333 
1334         // setup local rID
1335         uint256 _rID = rID_;
1336         
1337         // grab our winning player and team id's
1338         uint256 _winPID = round_[_rID].plyr;
1339         uint256 _winTID = round_[_rID].team;
1340         
1341         // grab our pot amount
1342         uint256 _pot = round_[_rID].pot;
1343         
1344         // calculate our winner share, community rewards, gen share, 
1345         // p3d share, and amount reserved for next pot 
1346         uint256 _win = (_pot.mul(48)) / 100;
1347         uint256 _com = (_pot / 50);
1348         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1349         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1350         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1351         
1352         // calculate ppt for round mask
1353         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1354         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1355         if (_dust > 0)
1356         {
1357             _gen = _gen.sub(_dust);
1358             _res = _res.add(_dust);
1359         }
1360         
1361         // pay our winner
1362         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1363         
1364         // community rewards
1365         admin.transfer(_com.add(_p3d.sub(_p3d / 2)));
1366         
1367         // distribute gen portion to key holders
1368         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1369         
1370         // p3d half to next
1371         _res = _res.add(_p3d / 2);
1372             
1373         // prepare event data
1374         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1375         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1376         _eventData_.winnerAddr = plyr_[_winPID].addr;
1377         _eventData_.winnerName = plyr_[_winPID].name;
1378         _eventData_.amountWon = _win;
1379         _eventData_.genAmount = _gen;
1380         _eventData_.PCPAmount = _p3d;
1381         _eventData_.newPot = _res;
1382         
1383         // clear pot
1384         round_[_rID].pot = 0;
1385         // start next round
1386         //rID_++;
1387         _rID++;
1388         round_[_rID].ended = false;
1389         round_[_rID].strt = now;
1390         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1391         round_[_rID].pot = (round_[_rID].pot).add(_res);
1392         
1393         return(_eventData_);
1394     }
1395     
1396     /**
1397      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1398      */
1399     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1400         private 
1401     {
1402         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1403         if (_earnings > 0)
1404         {
1405             // put in gen vault
1406             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1407             // zero out their earnings by updating mask
1408             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1409         }
1410     }
1411     
1412     /**
1413      * @dev updates round timer based on number of whole keys bought.
1414      */
1415     function updateTimer(uint256 _keys, uint256 _rID, uint256 _eth)
1416         private
1417     {
1418         // grab time
1419         uint256 _now = now;
1420         
1421         // calculate time based on number of keys bought
1422         uint256 _newTime;
1423         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1424             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1425         else
1426             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1427         
1428         // compare to max and set new end time
1429         uint256 _newEndTime;
1430         if (_newTime < (rndMax_).add(_now))
1431             _newEndTime = _newTime;
1432         else
1433             _newEndTime = rndMax_.add(_now);
1434 
1435         // biger to threshold, reduce
1436         if ( _eth >= rndReduceThreshold_ ) {
1437 
1438             uint256 reduce = ((((_keys) / (1000000000000000000))).mul(rndInc_ * reduceMul_) / reduceDiv_);
1439 
1440             if( _newEndTime > reduce && _now + rndMin_ + reduce < _newEndTime){
1441                 _newEndTime = (_newEndTime).sub(reduce);
1442             }
1443             // last add 10 minutes
1444             else if ( _newEndTime > reduce ){
1445                 _newEndTime = _now + rndMin_;
1446             }
1447         }
1448 
1449         round_[_rID].end = _newEndTime;
1450     }
1451 
1452 
1453     function getReduce(uint256 _rID, uint256 _eth) public view returns(uint256,uint256){
1454 
1455         uint256 _keys = calcKeysReceived(_rID, _eth);
1456 
1457         if ( _eth >= rndReduceThreshold_ ) {
1458             return ( ((((_keys) / (1000000000000000000))).mul(rndInc_ * reduceMul_) / reduceDiv_), (((_keys) / (1000000000000000000)).mul(rndInc_)) );
1459         } else {
1460             return (0, (((_keys) / (1000000000000000000)).mul(rndInc_)) );
1461         }
1462 
1463     }
1464     
1465     /**
1466      * @dev generates a random number between 0-99 and checks to see if thats
1467      * resulted in an airdrop win
1468      * @return do we have a winner?
1469      */
1470     function airdrop() private view returns(bool) {
1471         uint256 seed = uint256(keccak256(abi.encodePacked(
1472             
1473             (block.timestamp).add
1474             (block.difficulty).add
1475             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1476             (block.gaslimit).add
1477             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1478             (block.number)
1479             
1480         )));
1481         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1482             return(true);
1483         else
1484             return(false);
1485     }
1486 
1487     /**
1488      * @dev distributes eth based on fees to com, aff, and p3d
1489      */
1490     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_)
1491         private
1492         returns(PCKdatasets.EventReturns)
1493     {
1494         // pay 2% out to community rewards
1495         uint256 _com = _eth / 50;
1496         uint256 _p3d;
1497         if (!address(admin).call.value(_com)()) {
1498             // This ensures Team Just cannot influence the outcome of FoMo3D with
1499             // bank migrations by breaking outgoing transactions.
1500             // Something we would never do. But that's not the point.
1501             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1502             // highest belief that everything we create should be trustless.
1503             // Team JUST, The name you shouldn't have to trust.
1504             _p3d = _com;
1505             _com = 0;
1506         }
1507         
1508         // pay 1% out to next
1509         uint256 _long = _eth / 100;
1510         potSwap(_long);
1511         
1512         // distribute share to affiliate
1513         uint256 _aff = _eth / 10;
1514         
1515         // decide what to do with affiliate share of fees
1516         // affiliate must not be self, and must have a name registered
1517         if (_affID != _pID && plyr_[_affID].name != '') {
1518             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1519             emit PCKevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1520         } else {
1521             _p3d = _aff;
1522         }
1523         
1524         // pay out p3d
1525         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1526         if (_p3d > 0)
1527         {
1528             admin.transfer(_p3d.sub(_p3d / 2));
1529 
1530             round_[_rID].pot = round_[_rID].pot.add(_p3d / 2);
1531             
1532             // set up event data
1533             _eventData_.PCPAmount = _p3d.add(_eventData_.PCPAmount);
1534         }
1535         
1536         return(_eventData_);
1537     }
1538     
1539     function potSwap(uint256 _pot) private {
1540         // setup local rID
1541         uint256 _rID = rID_ + 1;
1542         
1543         round_[_rID].pot = round_[_rID].pot.add(_pot);
1544         emit PCKevents.onPotSwapDeposit(_rID, _pot);
1545     }
1546     
1547     /**
1548      * @dev distributes eth based on fees to gen and pot
1549      */
1550     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, PCKdatasets.EventReturns memory _eventData_)
1551         private
1552         returns(PCKdatasets.EventReturns)
1553     {
1554         // calculate gen share
1555         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1556         
1557         // toss 1% into airdrop pot 
1558         uint256 _air = (_eth / 100);
1559         airDropPot_ = airDropPot_.add(_air);
1560         
1561         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1562         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1563         
1564         // calculate pot 
1565         uint256 _pot = _eth.sub(_gen);
1566         
1567         // distribute gen share (thats what updateMasks() does) and adjust
1568         // balances for dust.
1569         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1570         if (_dust > 0)
1571             _gen = _gen.sub(_dust);
1572         
1573         // add eth to pot
1574         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1575         
1576         // set up event data
1577         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1578         _eventData_.potAmount = _pot;
1579         
1580         return(_eventData_);
1581     }
1582 
1583     /**
1584      * @dev updates masks for round and player when keys are bought
1585      * @return dust left over 
1586      */
1587     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1588         private
1589         returns(uint256)
1590     {
1591         /* MASKING NOTES
1592             earnings masks are a tricky thing for people to wrap their minds around.
1593             the basic thing to understand here.  is were going to have a global
1594             tracker based on profit per share for each round, that increases in
1595             relevant proportion to the increase in share supply.
1596             
1597             the player will have an additional mask that basically says "based
1598             on the rounds mask, my shares, and how much i've already withdrawn,
1599             how much is still owed to me?"
1600         */
1601         
1602         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1603         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1604         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1605             
1606         // calculate player earning from their own buy (only based on the keys
1607         // they just bought).  & update player earnings mask
1608         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1609         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1610         
1611         // calculate & return dust
1612         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1613     }
1614     
1615     /**
1616      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1617      * @return earnings in wei format
1618      */
1619     function withdrawEarnings(uint256 _pID)
1620         private
1621         returns(uint256)
1622     {
1623         // update gen vault
1624         updateGenVault(_pID, plyr_[_pID].lrnd);
1625         
1626         // from vaults 
1627         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1628         if (_earnings > 0)
1629         {
1630             plyr_[_pID].win = 0;
1631             plyr_[_pID].gen = 0;
1632             plyr_[_pID].aff = 0;
1633         }
1634 
1635         return(_earnings);
1636     }
1637     
1638     /**
1639      * @dev prepares compression data and fires event for buy or reload tx's
1640      */
1641     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, PCKdatasets.EventReturns memory _eventData_)
1642         private
1643     {
1644         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1645         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1646         
1647         emit PCKevents.onEndTx
1648         (
1649             _eventData_.compressedData,
1650             _eventData_.compressedIDs,
1651             plyr_[_pID].name,
1652             msg.sender,
1653             _eth,
1654             _keys,
1655             _eventData_.winnerAddr,
1656             _eventData_.winnerName,
1657             _eventData_.amountWon,
1658             _eventData_.newPot,
1659             _eventData_.PCPAmount,
1660             _eventData_.genAmount,
1661             _eventData_.potAmount,
1662             airDropPot_
1663         );
1664     }
1665 //==============================================================================
1666 //    (~ _  _    _._|_    .
1667 //    _)(/_(_|_|| | | \/  .
1668 //====================/=========================================================
1669     /** upon contract deploy, it will be deactivated.  this is a one time
1670      * use function that will activate the contract.  we do this so devs 
1671      * have time to set things up on the web end                            **/
1672     bool public activated_ = false;
1673     function activate() public {
1674         // only team just can activate 
1675         require(
1676             msg.sender == admin,
1677             "only team just can activate"
1678         );
1679         
1680         // can only be ran once
1681         require(activated_ == false, "PCK already activated");
1682         
1683         // activate the contract 
1684         activated_ = true;
1685         
1686         // lets start first round
1687         rID_ = 1;
1688         round_[1].strt = now + rndExtra_ - rndGap_;
1689         round_[1].end = now + rndInit_ + rndExtra_;
1690     }
1691 
1692 }
1693 
1694 //==============================================================================
1695 //   __|_ _    __|_ _  .
1696 //  _\ | | |_|(_ | _\  .
1697 //==============================================================================
1698 library PCKdatasets {
1699     //compressedData key
1700     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1701         // 0 - new player (bool)
1702         // 1 - joined round (bool)
1703         // 2 - new  leader (bool)
1704         // 3-5 - air drop tracker (uint 0-999)
1705         // 6-16 - round end time
1706         // 17 - winnerTeam
1707         // 18 - 28 timestamp 
1708         // 29 - team
1709         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1710         // 31 - airdrop happened bool
1711         // 32 - airdrop tier 
1712         // 33 - airdrop amount won
1713     //compressedIDs key
1714     // [77-52][51-26][25-0]
1715         // 0-25 - pID 
1716         // 26-51 - winPID
1717         // 52-77 - rID
1718     struct EventReturns {
1719         uint256 compressedData;
1720         uint256 compressedIDs;
1721         address winnerAddr;         // winner address
1722         bytes32 winnerName;         // winner name
1723         uint256 amountWon;          // amount won
1724         uint256 newPot;             // amount in new pot
1725         uint256 PCPAmount;          // amount distributed to p3d
1726         uint256 genAmount;          // amount distributed to gen
1727         uint256 potAmount;          // amount added to pot
1728     }
1729     struct Player {
1730         address addr;   // player address
1731         bytes32 name;   // player name
1732         uint256 win;    // winnings vault
1733         uint256 gen;    // general vault
1734         uint256 aff;    // affiliate vault
1735         uint256 lrnd;   // last round played
1736         uint256 laff;   // last affiliate id used
1737     }
1738     struct PlayerRounds {
1739         uint256 eth;    // eth player has added to round (used for eth limiter)
1740         uint256 keys;   // keys
1741         uint256 mask;   // player mask 
1742         uint256 ico;    // ICO phase investment
1743     }
1744     struct Round {
1745         uint256 plyr;   // pID of player in lead
1746         uint256 team;   // tID of team in lead
1747         uint256 end;    // time ends/ended
1748         bool ended;     // has round end function been ran
1749         uint256 strt;   // time round started
1750         uint256 keys;   // keys
1751         uint256 eth;    // total eth in
1752         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1753         uint256 mask;   // global mask
1754         uint256 ico;    // total eth sent in during ICO phase
1755         uint256 icoGen; // total eth for gen during ICO phase
1756         uint256 icoAvg; // average key price for ICO phase
1757     }
1758     struct TeamFee {
1759         uint256 gen;    // % of buy in thats paid to key holders of current round
1760         uint256 p3d;    // % of buy in thats paid to p3d holders
1761     }
1762     struct PotSplit {
1763         uint256 gen;    // % of pot thats paid to key holders of current round
1764         uint256 p3d;    // % of pot thats paid to p3d holders
1765     }
1766 }
1767 
1768 //==============================================================================
1769 //  |  _      _ _ | _  .
1770 //  |<(/_\/  (_(_||(_  .
1771 //=======/======================================================================
1772 library PCKKeysCalcLong {
1773     using SafeMath for *;
1774     /**
1775      * @dev calculates number of keys received given X eth 
1776      * @param _curEth current amount of eth in contract 
1777      * @param _newEth eth being spent
1778      * @return amount of ticket purchased
1779      */
1780     function keysRec(uint256 _curEth, uint256 _newEth)
1781         internal
1782         pure
1783         returns (uint256)
1784     {
1785         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1786     }
1787     
1788     /**
1789      * @dev calculates amount of eth received if you sold X keys 
1790      * @param _curKeys current amount of keys that exist 
1791      * @param _sellKeys amount of keys you wish to sell
1792      * @return amount of eth received
1793      */
1794     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1795         internal
1796         pure
1797         returns (uint256)
1798     {
1799         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1800     }
1801 
1802     /**
1803      * @dev calculates how many keys would exist with given an amount of eth
1804      * @param _eth eth "in contract"
1805      * @return number of keys that would exist
1806      */
1807     function keys(uint256 _eth) 
1808         internal
1809         pure
1810         returns(uint256)
1811     {
1812         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1813     }
1814     
1815     /**
1816      * @dev calculates how much eth would be in contract given a number of keys
1817      * @param _keys number of keys "in contract" 
1818      * @return eth that would exists
1819      */
1820     function eth(uint256 _keys) 
1821         internal
1822         pure
1823         returns(uint256)  
1824     {
1825         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1826     }
1827 }
1828 
1829 //==============================================================================
1830 //  . _ _|_ _  _ |` _  _ _  _  .
1831 //  || | | (/_| ~|~(_|(_(/__\  .
1832 //==============================================================================
1833 
1834 interface PCKExtSettingInterface {
1835     function getFastGap() external view returns(uint256);
1836     function getLongGap() external view returns(uint256);
1837     function getFastExtra() external view returns(uint256);
1838     function getLongExtra() external view returns(uint256);
1839 }
1840 
1841 interface PlayCoinGodInterface {
1842     function deposit() external payable;
1843 }
1844 
1845 interface ProForwarderInterface {
1846     function deposit() external payable returns(bool);
1847     function status() external view returns(address, address, bool);
1848     function startMigration(address _newCorpBank) external returns(bool);
1849     function cancelMigration() external returns(bool);
1850     function finishMigration() external returns(bool);
1851     function setup(address _firstCorpBank) external;
1852 }
1853 
1854 interface PlayerBookInterface {
1855     function getPlayerID(address _addr) external returns (uint256);
1856     function getPlayerName(uint256 _pID) external view returns (bytes32);
1857     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1858     function getPlayerAddr(uint256 _pID) external view returns (address);
1859     function getNameFee() external view returns (uint256);
1860     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1861     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1862     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1863 }
1864 
1865 
1866 
1867 library NameFilter {
1868     /**
1869      * @dev filters name strings
1870      * -converts uppercase to lower case.  
1871      * -makes sure it does not start/end with a space
1872      * -makes sure it does not contain multiple spaces in a row
1873      * -cannot be only numbers
1874      * -cannot start with 0x 
1875      * -restricts characters to A-Z, a-z, 0-9, and space.
1876      * @return reprocessed string in bytes32 format
1877      */
1878     function nameFilter(string _input)
1879         internal
1880         pure
1881         returns(bytes32)
1882     {
1883         bytes memory _temp = bytes(_input);
1884         uint256 _length = _temp.length;
1885         
1886         //sorry limited to 32 characters
1887         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1888         // make sure it doesnt start with or end with space
1889         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1890         // make sure first two characters are not 0x
1891         if (_temp[0] == 0x30)
1892         {
1893             require(_temp[1] != 0x78, "string cannot start with 0x");
1894             require(_temp[1] != 0x58, "string cannot start with 0X");
1895         }
1896         
1897         // create a bool to track if we have a non number character
1898         bool _hasNonNumber;
1899         
1900         // convert & check
1901         for (uint256 i = 0; i < _length; i++)
1902         {
1903             // if its uppercase A-Z
1904             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1905             {
1906                 // convert to lower case a-z
1907                 _temp[i] = byte(uint(_temp[i]) + 32);
1908                 
1909                 // we have a non number
1910                 if (_hasNonNumber == false)
1911                     _hasNonNumber = true;
1912             } else {
1913                 require
1914                 (
1915                     // require character is a space
1916                     _temp[i] == 0x20 || 
1917                     // OR lowercase a-z
1918                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1919                     // or 0-9
1920                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1921                     "string contains invalid characters"
1922                 );
1923                 // make sure theres not 2x spaces in a row
1924                 if (_temp[i] == 0x20)
1925                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1926                 
1927                 // see if we have a character other than a number
1928                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1929                     _hasNonNumber = true;    
1930             }
1931         }
1932         
1933         require(_hasNonNumber == true, "string cannot be only numbers");
1934         
1935         bytes32 _ret;
1936         assembly {
1937             _ret := mload(add(_temp, 32))
1938         }
1939         return (_ret);
1940     }
1941 }
1942 
1943 /**
1944  * @title SafeMath v0.1.9
1945  * @dev Math operations with safety checks that throw on error
1946  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1947  * - added sqrt
1948  * - added sq
1949  * - added pwr 
1950  * - changed asserts to requires with error log outputs
1951  * - removed div, its useless
1952  */
1953 library SafeMath {
1954     
1955     /**
1956     * @dev Multiplies two numbers, throws on overflow.
1957     */
1958     function mul(uint256 a, uint256 b) 
1959         internal 
1960         pure 
1961         returns (uint256 c) 
1962     {
1963         if (a == 0) {
1964             return 0;
1965         }
1966         c = a * b;
1967         require(c / a == b, "SafeMath mul failed");
1968         return c;
1969     }
1970 
1971     /**
1972     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1973     */
1974     function sub(uint256 a, uint256 b)
1975         internal
1976         pure
1977         returns (uint256) 
1978     {
1979         require(b <= a, "SafeMath sub failed");
1980         return a - b;
1981     }
1982 
1983     /**
1984     * @dev Adds two numbers, throws on overflow.
1985     */
1986     function add(uint256 a, uint256 b)
1987         internal
1988         pure
1989         returns (uint256 c) 
1990     {
1991         c = a + b;
1992         require(c >= a, "SafeMath add failed");
1993         return c;
1994     }
1995     
1996     /**
1997      * @dev gives square root of given x.
1998      */
1999     function sqrt(uint256 x)
2000         internal
2001         pure
2002         returns (uint256 y) 
2003     {
2004         uint256 z = ((add(x,1)) / 2);
2005         y = x;
2006         while (z < y) 
2007         {
2008             y = z;
2009             z = ((add((x / z),z)) / 2);
2010         }
2011     }
2012     
2013     /**
2014      * @dev gives square. multiplies x by x
2015      */
2016     function sq(uint256 x)
2017         internal
2018         pure
2019         returns (uint256)
2020     {
2021         return (mul(x,x));
2022     }
2023     
2024     /**
2025      * @dev x to the power of y 
2026      */
2027     function pwr(uint256 x, uint256 y)
2028         internal 
2029         pure 
2030         returns (uint256)
2031     {
2032         if (x==0)
2033             return (0);
2034         else if (y==0)
2035             return (1);
2036         else 
2037         {
2038             uint256 z = x;
2039             for (uint256 i=1; i < y; i++)
2040                 z = mul(z,x);
2041             return (z);
2042         }
2043     }
2044 }