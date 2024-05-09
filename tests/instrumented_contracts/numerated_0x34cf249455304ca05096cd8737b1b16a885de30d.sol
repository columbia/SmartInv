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
138     string constant public name = "PlayCoin Key";
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
165     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
166     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
167     mapping (uint256 => PCKdatasets.Player) public plyr_;   // (pID => data) player data
168     mapping (uint256 => mapping (uint256 => PCKdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
169     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
170 //****************
171 // ROUND DATA 
172 //****************
173     mapping (uint256 => PCKdatasets.Round) public round_;   // (rID => data) round data
174     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
175 //****************
176 // TEAM FEE DATA 
177 //****************
178     mapping (uint256 => PCKdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
179     mapping (uint256 => PCKdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
180 //==============================================================================
181 //     _ _  _  __|_ _    __|_ _  _  .
182 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
183 //==============================================================================
184     constructor()
185         public
186     {
187         // Team allocation structures
188         // 0 = whales
189         // 1 = bears
190         // 2 = sneks
191         // 3 = bulls
192 
193         // Team allocation percentages
194         // (PCK, PCP) + (Pot , Referrals, Community)
195             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
196         fees_[0] = PCKdatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
197         fees_[1] = PCKdatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
198         fees_[2] = PCKdatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
199         fees_[3] = PCKdatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
200         
201         // how to split up the final pot based on which team was picked
202         // (PCK, PCP)
203         potSplit_[0] = PCKdatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
204         potSplit_[1] = PCKdatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
205         potSplit_[2] = PCKdatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
206         potSplit_[3] = PCKdatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
207     }
208 //==============================================================================
209 //     _ _  _  _|. |`. _  _ _  .
210 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
211 //==============================================================================
212     /**
213      * @dev used to make sure no one can interact with contract until it has 
214      * been activated. 
215      */
216     modifier isActivated() {
217         require(activated_ == true, "its not ready yet.  check ?eta in discord");
218         _;
219     }
220 
221     modifier isRoundActivated() {
222         require(round_[rID_].ended == false, "the round is finished");
223         _;
224     }
225     
226     /**
227      * @dev prevents contracts from interacting with fomo3d 
228      */
229     modifier isHuman() {
230         
231         require(msg.sender == tx.origin, "sorry humans only");
232         _;
233     }
234 
235     /**
236      * @dev sets boundaries for incoming tx 
237      */
238     modifier isWithinLimits(uint256 _eth) {
239         require(_eth >= 1000000000, "pocket lint: not a valid currency");
240         require(_eth <= 100000000000000000000000, "no vitalik, no");
241         _;    
242     }
243 
244     modifier onlyAdmins() {
245         require(msg.sender == admin, "onlyAdmins failed - msg.sender is not an admin");
246         _;
247     }
248 //==============================================================================
249 //     _    |_ |. _   |`    _  __|_. _  _  _  .
250 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
251 //====|=========================================================================
252     function kill () onlyAdmins() public {
253         require(round_[rID_].ended == true && closed_ == true, "the round is active or not close");
254         selfdestruct(admin);
255     }
256 
257     function getRoundStatus() isActivated() public view returns(uint256, bool){
258         return (rID_, round_[rID_].ended);
259     }
260 
261     function setThreshold(uint256 _threshold, uint256 _mul, uint256 _div) onlyAdmins() public {
262 
263         require(_threshold > 0, "threshold must greater 0");
264         require(_mul > 0, "mul must greater 0");
265         require(_div > 0, "div must greater 0");
266 
267 
268         rndReduceThreshold_ = _threshold;
269         reduceMul_ = _mul;
270         reduceDiv_ = _div;
271     }
272 
273     function setEnforce(bool _closed) onlyAdmins() public returns(bool, uint256, bool) {
274         closed_ = _closed;
275 
276         // open ,next round
277         if( !closed_ && round_[rID_].ended == true && activated_ == true ){
278             nextRound();
279         }
280         // close,finish current round
281         else if( closed_ && round_[rID_].ended == false && activated_ == true ){
282             round_[rID_].end = now - 1;
283         }
284         
285         // close,roundId,finish
286         return (closed_, rID_, now > round_[rID_].end);
287     }
288     /**
289      * @dev emergency buy uses last stored affiliate ID and team snek
290      */
291     function()
292         isActivated()
293         isRoundActivated()
294         isHuman()
295         isWithinLimits(msg.value)
296         public
297         payable
298     {
299         // set up our tx event data and determine if player is new or not
300         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
301             
302         // fetch player id
303         uint256 _pID = pIDxAddr_[msg.sender];
304         
305         // buy core 
306         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
307     }
308     
309     /**
310      * @dev converts all incoming ethereum to keys.
311      * -functionhash- 0x8f38f309 (using ID for affiliate)
312      * -functionhash- 0x98a0871d (using address for affiliate)
313      * -functionhash- 0xa65b37a1 (using name for affiliate)
314      * @param _affCode the ID/address/name of the player who gets the affiliate fee
315      * @param _team what team is the player playing for?
316      */
317     function buyXid(uint256 _affCode, uint256 _team)
318         isActivated()
319         isRoundActivated()
320         isHuman()
321         isWithinLimits(msg.value)
322         public
323         payable
324     {
325         // set up our tx event data and determine if player is new or not
326         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
327         
328         // fetch player id
329         uint256 _pID = pIDxAddr_[msg.sender];
330         
331         // manage affiliate residuals
332         // if no affiliate code was given or player tried to use their own, lolz
333         if (_affCode == 0 || _affCode == _pID)
334         {
335             // use last stored affiliate code 
336             _affCode = plyr_[_pID].laff;
337             
338         // if affiliate code was given & its not the same as previously stored 
339         } else if (_affCode != plyr_[_pID].laff) {
340             // update last affiliate 
341             plyr_[_pID].laff = _affCode;
342         }
343         
344         // verify a valid team was selected
345         _team = verifyTeam(_team);
346         
347         // buy core 
348         buyCore(_pID, _affCode, _team, _eventData_);
349     }
350     
351     function buyXaddr(address _affCode, uint256 _team)
352         isActivated()
353         isRoundActivated()
354         isHuman()
355         isWithinLimits(msg.value)
356         public
357         payable
358     {
359         // set up our tx event data and determine if player is new or not
360         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
361         
362         // fetch player id
363         uint256 _pID = pIDxAddr_[msg.sender];
364         
365         // manage affiliate residuals
366         uint256 _affID;
367         // if no affiliate code was given or player tried to use their own, lolz
368         if (_affCode == address(0) || _affCode == msg.sender)
369         {
370             // use last stored affiliate code
371             _affID = plyr_[_pID].laff;
372         
373         // if affiliate code was given    
374         } else {
375             // get affiliate ID from aff Code 
376             _affID = pIDxAddr_[_affCode];
377             
378             // if affID is not the same as previously stored 
379             if (_affID != plyr_[_pID].laff)
380             {
381                 // update last affiliate
382                 plyr_[_pID].laff = _affID;
383             }
384         }
385         
386         // verify a valid team was selected
387         _team = verifyTeam(_team);
388         
389         // buy core 
390         buyCore(_pID, _affID, _team, _eventData_);
391     }
392     
393     function buyXname(bytes32 _affCode, uint256 _team)
394         isActivated()
395         isRoundActivated()
396         isHuman()
397         isWithinLimits(msg.value)
398         public
399         payable
400     {
401         // set up our tx event data and determine if player is new or not
402         PCKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
403         
404         // fetch player id
405         uint256 _pID = pIDxAddr_[msg.sender];
406         
407         // manage affiliate residuals
408         uint256 _affID;
409         // if no affiliate code was given or player tried to use their own, lolz
410         if (_affCode == '' || _affCode == plyr_[_pID].name)
411         {
412             // use last stored affiliate code
413             _affID = plyr_[_pID].laff;
414         
415         // if affiliate code was given
416         } else {
417             // get affiliate ID from aff Code
418             _affID = pIDxName_[_affCode];
419             
420             // if affID is not the same as previously stored
421             if (_affID != plyr_[_pID].laff)
422             {
423                 // update last affiliate
424                 plyr_[_pID].laff = _affID;
425             }
426         }
427         
428         // verify a valid team was selected
429         _team = verifyTeam(_team);
430         
431         // buy core 
432         buyCore(_pID, _affID, _team, _eventData_);
433     }
434     
435     /**
436      * @dev essentially the same as buy, but instead of you sending ether 
437      * from your wallet, it uses your unwithdrawn earnings.
438      * -functionhash- 0x349cdcac (using ID for affiliate)
439      * -functionhash- 0x82bfc739 (using address for affiliate)
440      * -functionhash- 0x079ce327 (using name for affiliate)
441      * @param _affCode the ID/address/name of the player who gets the affiliate fee
442      * @param _team what team is the player playing for?
443      * @param _eth amount of earnings to use (remainder returned to gen vault)
444      */
445     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
446         isActivated()
447         isRoundActivated()
448         isHuman()
449         isWithinLimits(_eth)
450         public
451     {
452         // set up our tx event data
453         PCKdatasets.EventReturns memory _eventData_;
454         
455         // fetch player ID
456         uint256 _pID = pIDxAddr_[msg.sender];
457         
458         // manage affiliate residuals
459         // if no affiliate code was given or player tried to use their own, lolz
460         if (_affCode == 0 || _affCode == _pID)
461         {
462             // use last stored affiliate code 
463             _affCode = plyr_[_pID].laff;
464             
465         // if affiliate code was given & its not the same as previously stored 
466         } else if (_affCode != plyr_[_pID].laff) {
467             // update last affiliate 
468             plyr_[_pID].laff = _affCode;
469         }
470 
471         // verify a valid team was selected
472         _team = verifyTeam(_team);
473 
474         // reload core
475         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
476     }
477     
478     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
479         isActivated()
480         isRoundActivated()
481         isHuman()
482         isWithinLimits(_eth)
483         public
484     {
485         // set up our tx event data
486         PCKdatasets.EventReturns memory _eventData_;
487         
488         // fetch player ID
489         uint256 _pID = pIDxAddr_[msg.sender];
490         
491         // manage affiliate residuals
492         uint256 _affID;
493         // if no affiliate code was given or player tried to use their own, lolz
494         if (_affCode == address(0) || _affCode == msg.sender)
495         {
496             // use last stored affiliate code
497             _affID = plyr_[_pID].laff;
498         
499         // if affiliate code was given    
500         } else {
501             // get affiliate ID from aff Code 
502             _affID = pIDxAddr_[_affCode];
503             
504             // if affID is not the same as previously stored 
505             if (_affID != plyr_[_pID].laff)
506             {
507                 // update last affiliate
508                 plyr_[_pID].laff = _affID;
509             }
510         }
511         
512         // verify a valid team was selected
513         _team = verifyTeam(_team);
514         
515         // reload core
516         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
517     }
518     
519     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
520         isActivated()
521         isRoundActivated()
522         isHuman()
523         isWithinLimits(_eth)
524         public
525     {
526         // set up our tx event data
527         PCKdatasets.EventReturns memory _eventData_;
528         
529         // fetch player ID
530         uint256 _pID = pIDxAddr_[msg.sender];
531         
532         // manage affiliate residuals
533         uint256 _affID;
534         // if no affiliate code was given or player tried to use their own, lolz
535         if (_affCode == '' || _affCode == plyr_[_pID].name)
536         {
537             // use last stored affiliate code
538             _affID = plyr_[_pID].laff;
539         
540         // if affiliate code was given
541         } else {
542             // get affiliate ID from aff Code
543             _affID = pIDxName_[_affCode];
544             
545             // if affID is not the same as previously stored
546             if (_affID != plyr_[_pID].laff)
547             {
548                 // update last affiliate
549                 plyr_[_pID].laff = _affID;
550             }
551         }
552         
553         // verify a valid team was selected
554         _team = verifyTeam(_team);
555         
556         // reload core
557         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
558     }
559 
560     /**
561      * @dev withdraws all of your earnings.
562      * -functionhash- 0x3ccfd60b
563      */
564     function withdraw()
565         isActivated()
566         isHuman()
567         public
568     {
569         // setup local rID 
570         uint256 _rID = rID_;
571         
572         // grab time
573         uint256 _now = now;
574         
575         // fetch player ID
576         uint256 _pID = pIDxAddr_[msg.sender];
577         
578         // setup temp var for player eth
579         uint256 _eth;
580         
581         // check to see if round has ended and no one has run round end yet
582         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
583         {
584             // set up our tx event data
585             PCKdatasets.EventReturns memory _eventData_;
586             
587             // end the round (distributes pot)
588             round_[_rID].ended = true;
589             _eventData_ = endRound(_eventData_);
590             
591             // get their earnings
592             _eth = withdrawEarnings(_pID);
593             
594             // gib moni
595             if (_eth > 0)
596                 plyr_[_pID].addr.transfer(_eth);    
597             
598             // build event data
599             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
600             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
601             
602             // fire withdraw and distribute event
603             emit PCKevents.onWithdrawAndDistribute
604             (
605                 msg.sender, 
606                 plyr_[_pID].name, 
607                 _eth, 
608                 _eventData_.compressedData, 
609                 _eventData_.compressedIDs, 
610                 _eventData_.winnerAddr, 
611                 _eventData_.winnerName, 
612                 _eventData_.amountWon, 
613                 _eventData_.newPot, 
614                 _eventData_.PCPAmount, 
615                 _eventData_.genAmount
616             );
617             
618         // in any other situation
619         } else {
620             // get their earnings
621             _eth = withdrawEarnings(_pID);
622             
623             // gib moni
624             if (_eth > 0)
625                 plyr_[_pID].addr.transfer(_eth);
626             
627             // fire withdraw event
628             emit PCKevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
629         }
630     }
631     
632     /**
633      * @dev use these to register names.  they are just wrappers that will send the
634      * registration requests to the PlayerBook contract.  So registering here is the 
635      * same as registering there.  UI will always display the last name you registered.
636      * but you will still own all previously registered names to use as affiliate 
637      * links.
638      * - must pay a registration fee.
639      * - name must be unique
640      * - names will be converted to lowercase
641      * - name cannot start or end with a space 
642      * - cannot have more than 1 space in a row
643      * - cannot be only numbers
644      * - cannot start with 0x 
645      * - name must be at least 1 char
646      * - max length of 32 characters long
647      * - allowed characters: a-z, 0-9, and space
648      * -functionhash- 0x921dec21 (using ID for affiliate)
649      * -functionhash- 0x3ddd4698 (using address for affiliate)
650      * -functionhash- 0x685ffd83 (using name for affiliate)
651      * @param _nameString players desired name
652      * @param _affCode affiliate ID, address, or name of who referred you
653      * @param _all set to true if you want this to push your info to all games 
654      * (this might cost a lot of gas)
655      */
656     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
657         isHuman()
658         public
659         payable
660     {
661         bytes32 _name = _nameString.nameFilter();
662         address _addr = msg.sender;
663         uint256 _paid = msg.value;
664         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
665         
666         uint256 _pID = pIDxAddr_[_addr];
667         
668         // fire event
669         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
670     }
671     
672     function registerNameXaddr(string _nameString, address _affCode, bool _all)
673         isHuman()
674         public
675         payable
676     {
677         bytes32 _name = _nameString.nameFilter();
678         address _addr = msg.sender;
679         uint256 _paid = msg.value;
680         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
681         
682         uint256 _pID = pIDxAddr_[_addr];
683         
684         // fire event
685         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
686     }
687     
688     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
689         isHuman()
690         public
691         payable
692     {
693         bytes32 _name = _nameString.nameFilter();
694         address _addr = msg.sender;
695         uint256 _paid = msg.value;
696         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
697         
698         uint256 _pID = pIDxAddr_[_addr];
699         
700         // fire event
701         emit PCKevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
702     }
703 //==============================================================================
704 //     _  _ _|__|_ _  _ _  .
705 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
706 //=====_|=======================================================================
707     /**
708      * @dev return the price buyer will pay for next 1 individual key.
709      * -functionhash- 0x018a25e8
710      * @return price for next key bought (in wei format)
711      */
712     function getBuyPrice()
713         public 
714         view 
715         returns(uint256)
716     {  
717         // setup local rID
718         uint256 _rID = rID_;
719         
720         // grab time
721         uint256 _now = now;
722         
723         // are we in a round?
724         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
725             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
726         else // rounds over.  need price for new round
727             return ( 75000000000000 ); // init
728     }
729     
730     /**
731      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
732      * provider
733      * -functionhash- 0xc7e284b8
734      * @return time left in seconds
735      */
736     function getTimeLeft()
737         public
738         view
739         returns(uint256)
740     {
741         // setup local rID
742         uint256 _rID = rID_;
743         
744         // grab time
745         uint256 _now = now;
746         
747         if (_now < round_[_rID].end)
748             if (_now > round_[_rID].strt + rndGap_)
749                 return( (round_[_rID].end).sub(_now) );
750             else
751                 return( (round_[_rID].strt + rndGap_).sub(_now) );
752         else
753             return(0);
754     }
755     
756     /**
757      * @dev returns player earnings per vaults 
758      * -functionhash- 0x63066434
759      * @return winnings vault
760      * @return general vault
761      * @return affiliate vault
762      */
763     function getPlayerVaults(uint256 _pID)
764         public
765         view
766         returns(uint256 ,uint256, uint256)
767     {
768         // setup local rID
769         uint256 _rID = rID_;
770         
771         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
772         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
773         {
774             // if player is winner 
775             if (round_[_rID].plyr == _pID)
776             {
777                 return
778                 (
779                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
780                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
781                     plyr_[_pID].aff
782                 );
783             // if player is not the winner
784             } else {
785                 return
786                 (
787                     plyr_[_pID].win,
788                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
789                     plyr_[_pID].aff
790                 );
791             }
792             
793         // if round is still going on, or round has ended and round end has been ran
794         } else {
795             return
796             (
797                 plyr_[_pID].win,
798                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
799                 plyr_[_pID].aff
800             );
801         }
802     }
803     
804     /**
805      * solidity hates stack limits.  this lets us avoid that hate 
806      */
807     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
808         private
809         view
810         returns(uint256)
811     {
812         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
813     }
814     
815     /**
816      * @dev returns all current round info needed for front end
817      * -functionhash- 0x747dff42
818      * @return eth invested during ICO phase
819      * @return round id 
820      * @return total keys for round 
821      * @return time round ends
822      * @return time round started
823      * @return current pot 
824      * @return current team ID & player ID in lead 
825      * @return current player in leads address 
826      * @return current player in leads name
827      * @return whales eth in for round
828      * @return bears eth in for round
829      * @return sneks eth in for round
830      * @return bulls eth in for round
831      * @return airdrop tracker # & airdrop pot
832      */
833     function getCurrentRoundInfo()
834         public
835         view
836         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
837     {
838         // setup local rID
839         uint256 _rID = rID_;
840         
841         return
842         (
843             round_[_rID].ico,               //0
844             _rID,                           //1
845             round_[_rID].keys,              //2
846             round_[_rID].end,               //3
847             round_[_rID].strt,              //4
848             round_[_rID].pot,               //5
849             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
850             plyr_[round_[_rID].plyr].addr,  //7
851             plyr_[round_[_rID].plyr].name,  //8
852             rndTmEth_[_rID][0],             //9
853             rndTmEth_[_rID][1],             //10
854             rndTmEth_[_rID][2],             //11
855             rndTmEth_[_rID][3],             //12
856             airDropTracker_ + (airDropPot_ * 1000)              //13
857         );
858     }
859 
860     /**
861      * @dev returns player info based on address.  if no address is given, it will 
862      * use msg.sender 
863      * -functionhash- 0xee0b5d8b
864      * @param _addr address of the player you want to lookup 
865      * @return player ID 
866      * @return player name
867      * @return keys owned (current round)
868      * @return winnings vault
869      * @return general vault 
870      * @return affiliate vault 
871      * @return player round eth
872      */
873     function getPlayerInfoByAddress(address _addr)
874         public 
875         view 
876         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
877     {
878         // setup local rID
879         uint256 _rID = rID_;
880         
881         if (_addr == address(0))
882         {
883             _addr == msg.sender;
884         }
885         uint256 _pID = pIDxAddr_[_addr];
886         
887         return
888         (
889             _pID,                               //0
890             plyr_[_pID].name,                   //1
891             plyrRnds_[_pID][_rID].keys,         //2
892             plyr_[_pID].win,                    //3
893             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
894             plyr_[_pID].aff,                    //5
895             plyrRnds_[_pID][_rID].eth           //6
896         );
897     }
898 
899 //==============================================================================
900 //     _ _  _ _   | _  _ . _  .
901 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
902 //=====================_|=======================================================
903     /**
904      * @dev logic runs whenever a buy order is executed.  determines how to handle 
905      * incoming eth depending on if we are in an active round or not
906      */
907     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_) private {
908 
909         // setup local rID
910         uint256 _rID = rID_;
911         
912         // grab time
913         uint256 _now = now;
914 
915 
916         
917         // if round is active
918         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
919         {
920             // call core 
921             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
922         
923         // if round is not active     
924         } else {
925 
926             // check to see if end round needs to be ran
927             if ( _now > round_[_rID].end && round_[_rID].ended == false ) {
928                 // end the round (distributes pot) & start new round
929                 round_[_rID].ended = true;
930                 _eventData_ = endRound(_eventData_);
931 
932                 if( !closed_ ){
933                     nextRound();
934                 }
935                 
936                 // build event data
937                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
938                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
939                 
940                 // fire buy and distribute event 
941                 emit PCKevents.onBuyAndDistribute
942                 (
943                     msg.sender, 
944                     plyr_[_pID].name, 
945                     msg.value, 
946                     _eventData_.compressedData, 
947                     _eventData_.compressedIDs, 
948                     _eventData_.winnerAddr, 
949                     _eventData_.winnerName, 
950                     _eventData_.amountWon, 
951                     _eventData_.newPot, 
952                     _eventData_.PCPAmount, 
953                     _eventData_.genAmount
954                 );
955             }
956             
957             // put eth in players vault 
958             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
959         }
960     }
961     
962     /**
963      * @dev logic runs whenever a reload order is executed.  determines how to handle 
964      * incoming eth depending on if we are in an active round or not 
965      */
966     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, PCKdatasets.EventReturns memory _eventData_) private {
967 
968         // setup local rID
969         uint256 _rID = rID_;
970         
971         // grab time
972         uint256 _now = now;
973         
974         // if round is active
975         if (_now > ( round_[_rID].strt + rndGap_ ) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
976         {
977             // get earnings from all vaults and return unused to gen vault
978             // because we use a custom safemath library.  this will throw if player 
979             // tried to spend more eth than they have.
980             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
981             
982             // call core 
983             core(_rID, _pID, _eth, _affID, _team, _eventData_);
984         
985         // if round is not active and end round needs to be ran   
986         } else if ( _now > round_[_rID].end && round_[_rID].ended == false ) {
987             // end the round (distributes pot) & start new round
988             round_[_rID].ended = true;
989             _eventData_ = endRound(_eventData_);
990 
991             if( !closed_ ) {
992                 nextRound();
993             }
994                 
995             // build event data
996             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
997             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
998                 
999             // fire buy and distribute event 
1000             emit PCKevents.onReLoadAndDistribute
1001             (
1002                 msg.sender, 
1003                 plyr_[_pID].name, 
1004                 _eventData_.compressedData, 
1005                 _eventData_.compressedIDs, 
1006                 _eventData_.winnerAddr, 
1007                 _eventData_.winnerName, 
1008                 _eventData_.amountWon, 
1009                 _eventData_.newPot, 
1010                 _eventData_.PCPAmount, 
1011                 _eventData_.genAmount
1012             );
1013         }
1014     }
1015     
1016     /**
1017      * @dev this is the core logic for any buy/reload that happens while a round 
1018      * is live.
1019      */
1020     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_)
1021         private
1022     {
1023         // if player is new to round
1024         if (plyrRnds_[_pID][_rID].keys == 0)
1025             _eventData_ = managePlayer(_pID, _eventData_);
1026         
1027         // early round eth limiter 
1028         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1029         {
1030             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1031             uint256 _refund = _eth.sub(_availableLimit);
1032             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1033             _eth = _availableLimit;
1034         }
1035         
1036         // if eth left is greater than min eth allowed (sorry no pocket lint)
1037         if (_eth > 1000000000) 
1038         {
1039             
1040             // mint the new keys
1041             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1042             
1043             // if they bought at least 1 whole key
1044             if (_keys >= 1000000000000000000)
1045             {
1046             updateTimer(_keys, _rID, _eth);
1047 
1048             // set new leaders
1049             if (round_[_rID].plyr != _pID)
1050                 round_[_rID].plyr = _pID;  
1051             if (round_[_rID].team != _team)
1052                 round_[_rID].team = _team; 
1053             
1054             // set the new leader bool to true
1055             _eventData_.compressedData = _eventData_.compressedData + 100;
1056         }
1057             
1058         // manage airdrops
1059         if (_eth >= 100000000000000000) {
1060             airDropTracker_++;
1061             if (airdrop() == true) {
1062                 // gib muni
1063                 uint256 _prize;
1064                 if (_eth >= 10000000000000000000)
1065                 {
1066                     // calculate prize and give it to winner
1067                     _prize = ((airDropPot_).mul(75)) / 100;
1068                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1069                     
1070                     // adjust airDropPot 
1071                     airDropPot_ = (airDropPot_).sub(_prize);
1072                     
1073                     // let event know a tier 3 prize was won 
1074                     _eventData_.compressedData += 300000000000000000000000000000000;
1075                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1076                     // calculate prize and give it to winner
1077                     _prize = ((airDropPot_).mul(50)) / 100;
1078                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1079                     
1080                     // adjust airDropPot 
1081                     airDropPot_ = (airDropPot_).sub(_prize);
1082                     
1083                     // let event know a tier 2 prize was won 
1084                     _eventData_.compressedData += 200000000000000000000000000000000;
1085                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1086                     // calculate prize and give it to winner
1087                     _prize = ((airDropPot_).mul(25)) / 100;
1088                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1089                     
1090                     // adjust airDropPot 
1091                     airDropPot_ = (airDropPot_).sub(_prize);
1092                     
1093                     // let event know a tier 3 prize was won 
1094                     _eventData_.compressedData += 300000000000000000000000000000000;
1095                 }
1096                 // set airdrop happened bool to true
1097                 _eventData_.compressedData += 10000000000000000000000000000000;
1098                 // let event know how much was won 
1099                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1100                 
1101                 // reset air drop tracker
1102                 airDropTracker_ = 0;
1103             }
1104         }
1105     
1106             // store the air drop tracker number (number of buys since last airdrop)
1107             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1108             
1109             // update player 
1110             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1111             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1112             
1113             // update round
1114             round_[_rID].keys = _keys.add(round_[_rID].keys);
1115             round_[_rID].eth = _eth.add(round_[_rID].eth);
1116             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1117     
1118             // distribute eth
1119             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1120             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1121             
1122             // call end tx function to fire end tx event.
1123             endTx(_pID, _team, _eth, _keys, _eventData_);
1124         }
1125     }
1126 //==============================================================================
1127 //     _ _ | _   | _ _|_ _  _ _  .
1128 //    (_(_||(_|_||(_| | (_)| _\  .
1129 //==============================================================================
1130     /**
1131      * @dev calculates unmasked earnings (just calculates, does not update mask)
1132      * @return earnings in wei format
1133      */
1134     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1135         private
1136         view
1137         returns(uint256)
1138     {
1139         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1140     }
1141     
1142     /** 
1143      * @dev returns the amount of keys you would get given an amount of eth. 
1144      * -functionhash- 0xce89c80c
1145      * @param _rID round ID you want price for
1146      * @param _eth amount of eth sent in 
1147      * @return keys received 
1148      */
1149     function calcKeysReceived(uint256 _rID, uint256 _eth)
1150         public
1151         view
1152         returns(uint256)
1153     {
1154         // grab time
1155         uint256 _now = now;
1156         
1157         // are we in a round?
1158         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1159             return ( (round_[_rID].eth).keysRec(_eth) );
1160         else // rounds over.  need keys for new round
1161             return ( (_eth).keys() );
1162     }
1163     
1164     /** 
1165      * @dev returns current eth price for X keys.  
1166      * -functionhash- 0xcf808000
1167      * @param _keys number of keys desired (in 18 decimal format)
1168      * @return amount of eth needed to send
1169      */
1170     function iWantXKeys(uint256 _keys)
1171         public
1172         view
1173         returns(uint256)
1174     {
1175         // setup local rID
1176         uint256 _rID = rID_;
1177         
1178         // grab time
1179         uint256 _now = now;
1180         
1181         // are we in a round?
1182         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1183             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1184         else // rounds over.  need price for new round
1185             return ( (_keys).eth() );
1186     }
1187 //==============================================================================
1188 //    _|_ _  _ | _  .
1189 //     | (_)(_)|_\  .
1190 //==============================================================================
1191     /**
1192      * @dev receives name/player info from names contract 
1193      */
1194     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1195         external
1196     {
1197         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1198         if (pIDxAddr_[_addr] != _pID)
1199             pIDxAddr_[_addr] = _pID;
1200         if (pIDxName_[_name] != _pID)
1201             pIDxName_[_name] = _pID;
1202         if (plyr_[_pID].addr != _addr)
1203             plyr_[_pID].addr = _addr;
1204         if (plyr_[_pID].name != _name)
1205             plyr_[_pID].name = _name;
1206         if (plyr_[_pID].laff != _laff)
1207             plyr_[_pID].laff = _laff;
1208         if (plyrNames_[_pID][_name] == false)
1209             plyrNames_[_pID][_name] = true;
1210     }
1211     
1212     /**
1213      * @dev receives entire player name list 
1214      */
1215     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1216         external
1217     {
1218         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1219         if(plyrNames_[_pID][_name] == false)
1220             plyrNames_[_pID][_name] = true;
1221     }   
1222         
1223     /**
1224      * @dev gets existing or registers new pID.  use this when a player may be new
1225      * @return pID 
1226      */
1227     function determinePID(PCKdatasets.EventReturns memory _eventData_)
1228         private
1229         returns (PCKdatasets.EventReturns)
1230     {
1231         uint256 _pID = pIDxAddr_[msg.sender];
1232         // if player is new to this version of fomo3d
1233         if (_pID == 0)
1234         {
1235             // grab their player ID, name and last aff ID, from player names contract 
1236             _pID = PlayerBook.getPlayerID(msg.sender);
1237             bytes32 _name = PlayerBook.getPlayerName(_pID);
1238             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1239             
1240             // set up player account 
1241             pIDxAddr_[msg.sender] = _pID;
1242             plyr_[_pID].addr = msg.sender;
1243             
1244             if (_name != "")
1245             {
1246                 pIDxName_[_name] = _pID;
1247                 plyr_[_pID].name = _name;
1248                 plyrNames_[_pID][_name] = true;
1249             }
1250             
1251             if (_laff != 0 && _laff != _pID)
1252                 plyr_[_pID].laff = _laff;
1253             
1254             // set the new player bool to true
1255             _eventData_.compressedData = _eventData_.compressedData + 1;
1256         } 
1257         return (_eventData_);
1258     }
1259     
1260     /**
1261      * @dev checks to make sure user picked a valid team.  if not sets team 
1262      * to default (sneks)
1263      */
1264     function verifyTeam(uint256 _team)
1265         private
1266         pure
1267         returns (uint256)
1268     {
1269         if (_team < 0 || _team > 3)
1270             return(2);
1271         else
1272             return(_team);
1273     }
1274     
1275     /**
1276      * @dev decides if round end needs to be run & new round started.  and if 
1277      * player unmasked earnings from previously played rounds need to be moved.
1278      */
1279     function managePlayer(uint256 _pID, PCKdatasets.EventReturns memory _eventData_)
1280         private
1281         returns (PCKdatasets.EventReturns)
1282     {
1283         // if player has played a previous round, move their unmasked earnings
1284         // from that round to gen vault.
1285         if (plyr_[_pID].lrnd != 0)
1286             updateGenVault(_pID, plyr_[_pID].lrnd);
1287             
1288         // update player's last round played
1289         plyr_[_pID].lrnd = rID_;
1290             
1291         // set the joined round bool to true
1292         _eventData_.compressedData = _eventData_.compressedData + 10;
1293         
1294         return(_eventData_);
1295     }
1296 
1297 
1298     function nextRound() private {
1299         rID_++;
1300         round_[rID_].strt = now;
1301         round_[rID_].end = now.add(rndInit_).add(rndGap_);
1302     }
1303     
1304     /**
1305      * @dev ends the round. manages paying out winner/splitting up pot
1306      */
1307     function endRound(PCKdatasets.EventReturns memory _eventData_)
1308         private
1309         returns (PCKdatasets.EventReturns)
1310     {
1311 
1312         // setup local rID
1313         uint256 _rID = rID_;
1314         
1315         // grab our winning player and team id's
1316         uint256 _winPID = round_[_rID].plyr;
1317         uint256 _winTID = round_[_rID].team;
1318         
1319         // grab our pot amount
1320         uint256 _pot = round_[_rID].pot;
1321         
1322         // calculate our winner share, community rewards, gen share, 
1323         // p3d share, and amount reserved for next pot 
1324         uint256 _win = (_pot.mul(48)) / 100;
1325         uint256 _com = (_pot / 50);
1326         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1327         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1328         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1329         
1330         // calculate ppt for round mask
1331         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1332         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1333         if (_dust > 0)
1334         {
1335             _gen = _gen.sub(_dust);
1336             _res = _res.add(_dust);
1337         }
1338         
1339         // pay our winner
1340         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1341         
1342         // community rewards
1343         admin.transfer(_com.add(_p3d.sub(_p3d / 2)));
1344         
1345         // distribute gen portion to key holders
1346         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1347         
1348         // p3d half to next
1349         _res = _res.add(_p3d / 2);
1350             
1351         // prepare event data
1352         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1353         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1354         _eventData_.winnerAddr = plyr_[_winPID].addr;
1355         _eventData_.winnerName = plyr_[_winPID].name;
1356         _eventData_.amountWon = _win;
1357         _eventData_.genAmount = _gen;
1358         _eventData_.PCPAmount = _p3d;
1359         _eventData_.newPot = _res;
1360         
1361         // start next round
1362         //rID_++;
1363         _rID++;
1364         round_[_rID].ended = false;
1365         round_[_rID].strt = now;
1366         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1367         round_[_rID].pot = _res;
1368         
1369         return(_eventData_);
1370     }
1371     
1372     /**
1373      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1374      */
1375     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1376         private 
1377     {
1378         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1379         if (_earnings > 0)
1380         {
1381             // put in gen vault
1382             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1383             // zero out their earnings by updating mask
1384             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1385         }
1386     }
1387     
1388     /**
1389      * @dev updates round timer based on number of whole keys bought.
1390      */
1391     function updateTimer(uint256 _keys, uint256 _rID, uint256 _eth)
1392         private
1393     {
1394         // grab time
1395         uint256 _now = now;
1396         
1397         // calculate time based on number of keys bought
1398         uint256 _newTime;
1399         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1400             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1401         else
1402             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1403         
1404         // compare to max and set new end time
1405         uint256 _newEndTime;
1406         if (_newTime < (rndMax_).add(_now))
1407             _newEndTime = _newTime;
1408         else
1409             _newEndTime = rndMax_.add(_now);
1410 
1411         // biger to threshold, reduce
1412         if ( _eth >= rndReduceThreshold_ ) {
1413 
1414             uint256 reduce = ((((_keys) / (1000000000000000000))).mul(rndInc_ * reduceMul_) / reduceDiv_);
1415 
1416             if( _newEndTime > reduce && _now + rndMin_ + reduce < _newEndTime){
1417                 _newEndTime = (_newEndTime).sub(reduce);
1418             }
1419             // last add 10 minutes
1420             else if ( _newEndTime > reduce ){
1421                 _newEndTime = _now + rndMin_;
1422             }
1423         }
1424 
1425         round_[_rID].end = _newEndTime;
1426     }
1427 
1428 
1429     function getReduce(uint256 _rID, uint256 _eth) public view returns(uint256,uint256){
1430 
1431         uint256 _keys = calcKeysReceived(_rID, _eth);
1432 
1433         if ( _eth >= rndReduceThreshold_ ) {
1434             return ( ((((_keys) / (1000000000000000000))).mul(rndInc_ * reduceMul_) / reduceDiv_), (((_keys) / (1000000000000000000)).mul(rndInc_)) );
1435         } else {
1436             return (0, (((_keys) / (1000000000000000000)).mul(rndInc_)) );
1437         }
1438 
1439     }
1440     
1441     /**
1442      * @dev generates a random number between 0-99 and checks to see if thats
1443      * resulted in an airdrop win
1444      * @return do we have a winner?
1445      */
1446     function airdrop() private view returns(bool) {
1447         uint256 seed = uint256(keccak256(abi.encodePacked(
1448             
1449             (block.timestamp).add
1450             (block.difficulty).add
1451             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1452             (block.gaslimit).add
1453             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1454             (block.number)
1455             
1456         )));
1457         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1458             return(true);
1459         else
1460             return(false);
1461     }
1462 
1463     /**
1464      * @dev distributes eth based on fees to com, aff, and p3d
1465      */
1466     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, PCKdatasets.EventReturns memory _eventData_)
1467         private
1468         returns(PCKdatasets.EventReturns)
1469     {
1470         // pay 2% out to community rewards
1471         uint256 _com = _eth / 50;
1472         uint256 _p3d;
1473         if (!address(admin).call.value(_com)()) {
1474             // This ensures Team Just cannot influence the outcome of FoMo3D with
1475             // bank migrations by breaking outgoing transactions.
1476             // Something we would never do. But that's not the point.
1477             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1478             // highest belief that everything we create should be trustless.
1479             // Team JUST, The name you shouldn't have to trust.
1480             _p3d = _com;
1481             _com = 0;
1482         }
1483         
1484         // pay 1% out to next
1485         uint256 _long = _eth / 100;
1486         potSwap(_long);
1487         
1488         // distribute share to affiliate
1489         uint256 _aff = _eth / 10;
1490         
1491         // decide what to do with affiliate share of fees
1492         // affiliate must not be self, and must have a name registered
1493         if (_affID != _pID && plyr_[_affID].name != '') {
1494             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1495             emit PCKevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1496         } else {
1497             _p3d = _aff;
1498         }
1499         
1500         // pay out p3d
1501         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1502         if (_p3d > 0)
1503         {
1504             admin.transfer(_p3d.sub(_p3d / 2));
1505 
1506             round_[_rID].pot = round_[_rID].pot.add(_p3d / 2);
1507             
1508             // set up event data
1509             _eventData_.PCPAmount = _p3d.add(_eventData_.PCPAmount);
1510         }
1511         
1512         return(_eventData_);
1513     }
1514     
1515     function potSwap(uint256 _pot) private {
1516         // setup local rID
1517         uint256 _rID = rID_ + 1;
1518         
1519         round_[_rID].pot = round_[_rID].pot.add(_pot);
1520         emit PCKevents.onPotSwapDeposit(_rID, _pot);
1521     }
1522     
1523     /**
1524      * @dev distributes eth based on fees to gen and pot
1525      */
1526     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, PCKdatasets.EventReturns memory _eventData_)
1527         private
1528         returns(PCKdatasets.EventReturns)
1529     {
1530         // calculate gen share
1531         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1532         
1533         // toss 1% into airdrop pot 
1534         uint256 _air = (_eth / 100);
1535         airDropPot_ = airDropPot_.add(_air);
1536         
1537         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1538         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1539         
1540         // calculate pot 
1541         uint256 _pot = _eth.sub(_gen);
1542         
1543         // distribute gen share (thats what updateMasks() does) and adjust
1544         // balances for dust.
1545         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1546         if (_dust > 0)
1547             _gen = _gen.sub(_dust);
1548         
1549         // add eth to pot
1550         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1551         
1552         // set up event data
1553         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1554         _eventData_.potAmount = _pot;
1555         
1556         return(_eventData_);
1557     }
1558 
1559     /**
1560      * @dev updates masks for round and player when keys are bought
1561      * @return dust left over 
1562      */
1563     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1564         private
1565         returns(uint256)
1566     {
1567         /* MASKING NOTES
1568             earnings masks are a tricky thing for people to wrap their minds around.
1569             the basic thing to understand here.  is were going to have a global
1570             tracker based on profit per share for each round, that increases in
1571             relevant proportion to the increase in share supply.
1572             
1573             the player will have an additional mask that basically says "based
1574             on the rounds mask, my shares, and how much i've already withdrawn,
1575             how much is still owed to me?"
1576         */
1577         
1578         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1579         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1580         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1581             
1582         // calculate player earning from their own buy (only based on the keys
1583         // they just bought).  & update player earnings mask
1584         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1585         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1586         
1587         // calculate & return dust
1588         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1589     }
1590     
1591     /**
1592      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1593      * @return earnings in wei format
1594      */
1595     function withdrawEarnings(uint256 _pID)
1596         private
1597         returns(uint256)
1598     {
1599         // update gen vault
1600         updateGenVault(_pID, plyr_[_pID].lrnd);
1601         
1602         // from vaults 
1603         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1604         if (_earnings > 0)
1605         {
1606             plyr_[_pID].win = 0;
1607             plyr_[_pID].gen = 0;
1608             plyr_[_pID].aff = 0;
1609         }
1610 
1611         return(_earnings);
1612     }
1613     
1614     /**
1615      * @dev prepares compression data and fires event for buy or reload tx's
1616      */
1617     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, PCKdatasets.EventReturns memory _eventData_)
1618         private
1619     {
1620         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1621         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1622         
1623         emit PCKevents.onEndTx
1624         (
1625             _eventData_.compressedData,
1626             _eventData_.compressedIDs,
1627             plyr_[_pID].name,
1628             msg.sender,
1629             _eth,
1630             _keys,
1631             _eventData_.winnerAddr,
1632             _eventData_.winnerName,
1633             _eventData_.amountWon,
1634             _eventData_.newPot,
1635             _eventData_.PCPAmount,
1636             _eventData_.genAmount,
1637             _eventData_.potAmount,
1638             airDropPot_
1639         );
1640     }
1641 //==============================================================================
1642 //    (~ _  _    _._|_    .
1643 //    _)(/_(_|_|| | | \/  .
1644 //====================/=========================================================
1645     /** upon contract deploy, it will be deactivated.  this is a one time
1646      * use function that will activate the contract.  we do this so devs 
1647      * have time to set things up on the web end                            **/
1648     bool public activated_ = false;
1649     function activate() public {
1650         // only team just can activate 
1651         require(
1652             msg.sender == admin,
1653             "only team just can activate"
1654         );
1655         
1656         // can only be ran once
1657         require(activated_ == false, "PCK already activated");
1658         
1659         // activate the contract 
1660         activated_ = true;
1661         
1662         // lets start first round
1663         rID_ = 1;
1664         round_[1].strt = now + rndExtra_ - rndGap_;
1665         round_[1].end = now + rndInit_ + rndExtra_;
1666     }
1667 
1668 }
1669 
1670 //==============================================================================
1671 //   __|_ _    __|_ _  .
1672 //  _\ | | |_|(_ | _\  .
1673 //==============================================================================
1674 library PCKdatasets {
1675     //compressedData key
1676     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1677         // 0 - new player (bool)
1678         // 1 - joined round (bool)
1679         // 2 - new  leader (bool)
1680         // 3-5 - air drop tracker (uint 0-999)
1681         // 6-16 - round end time
1682         // 17 - winnerTeam
1683         // 18 - 28 timestamp 
1684         // 29 - team
1685         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1686         // 31 - airdrop happened bool
1687         // 32 - airdrop tier 
1688         // 33 - airdrop amount won
1689     //compressedIDs key
1690     // [77-52][51-26][25-0]
1691         // 0-25 - pID 
1692         // 26-51 - winPID
1693         // 52-77 - rID
1694     struct EventReturns {
1695         uint256 compressedData;
1696         uint256 compressedIDs;
1697         address winnerAddr;         // winner address
1698         bytes32 winnerName;         // winner name
1699         uint256 amountWon;          // amount won
1700         uint256 newPot;             // amount in new pot
1701         uint256 PCPAmount;          // amount distributed to p3d
1702         uint256 genAmount;          // amount distributed to gen
1703         uint256 potAmount;          // amount added to pot
1704     }
1705     struct Player {
1706         address addr;   // player address
1707         bytes32 name;   // player name
1708         uint256 win;    // winnings vault
1709         uint256 gen;    // general vault
1710         uint256 aff;    // affiliate vault
1711         uint256 lrnd;   // last round played
1712         uint256 laff;   // last affiliate id used
1713     }
1714     struct PlayerRounds {
1715         uint256 eth;    // eth player has added to round (used for eth limiter)
1716         uint256 keys;   // keys
1717         uint256 mask;   // player mask 
1718         uint256 ico;    // ICO phase investment
1719     }
1720     struct Round {
1721         uint256 plyr;   // pID of player in lead
1722         uint256 team;   // tID of team in lead
1723         uint256 end;    // time ends/ended
1724         bool ended;     // has round end function been ran
1725         uint256 strt;   // time round started
1726         uint256 keys;   // keys
1727         uint256 eth;    // total eth in
1728         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1729         uint256 mask;   // global mask
1730         uint256 ico;    // total eth sent in during ICO phase
1731         uint256 icoGen; // total eth for gen during ICO phase
1732         uint256 icoAvg; // average key price for ICO phase
1733     }
1734     struct TeamFee {
1735         uint256 gen;    // % of buy in thats paid to key holders of current round
1736         uint256 p3d;    // % of buy in thats paid to p3d holders
1737     }
1738     struct PotSplit {
1739         uint256 gen;    // % of pot thats paid to key holders of current round
1740         uint256 p3d;    // % of pot thats paid to p3d holders
1741     }
1742 }
1743 
1744 //==============================================================================
1745 //  |  _      _ _ | _  .
1746 //  |<(/_\/  (_(_||(_  .
1747 //=======/======================================================================
1748 library PCKKeysCalcLong {
1749     using SafeMath for *;
1750     /**
1751      * @dev calculates number of keys received given X eth 
1752      * @param _curEth current amount of eth in contract 
1753      * @param _newEth eth being spent
1754      * @return amount of ticket purchased
1755      */
1756     function keysRec(uint256 _curEth, uint256 _newEth)
1757         internal
1758         pure
1759         returns (uint256)
1760     {
1761         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1762     }
1763     
1764     /**
1765      * @dev calculates amount of eth received if you sold X keys 
1766      * @param _curKeys current amount of keys that exist 
1767      * @param _sellKeys amount of keys you wish to sell
1768      * @return amount of eth received
1769      */
1770     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1771         internal
1772         pure
1773         returns (uint256)
1774     {
1775         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1776     }
1777 
1778     /**
1779      * @dev calculates how many keys would exist with given an amount of eth
1780      * @param _eth eth "in contract"
1781      * @return number of keys that would exist
1782      */
1783     function keys(uint256 _eth) 
1784         internal
1785         pure
1786         returns(uint256)
1787     {
1788         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1789     }
1790     
1791     /**
1792      * @dev calculates how much eth would be in contract given a number of keys
1793      * @param _keys number of keys "in contract" 
1794      * @return eth that would exists
1795      */
1796     function eth(uint256 _keys) 
1797         internal
1798         pure
1799         returns(uint256)  
1800     {
1801         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1802     }
1803 }
1804 
1805 //==============================================================================
1806 //  . _ _|_ _  _ |` _  _ _  _  .
1807 //  || | | (/_| ~|~(_|(_(/__\  .
1808 //==============================================================================
1809 
1810 interface PCKExtSettingInterface {
1811     function getFastGap() external view returns(uint256);
1812     function getLongGap() external view returns(uint256);
1813     function getFastExtra() external view returns(uint256);
1814     function getLongExtra() external view returns(uint256);
1815 }
1816 
1817 interface PlayCoinGodInterface {
1818     function deposit() external payable;
1819 }
1820 
1821 interface ProForwarderInterface {
1822     function deposit() external payable returns(bool);
1823     function status() external view returns(address, address, bool);
1824     function startMigration(address _newCorpBank) external returns(bool);
1825     function cancelMigration() external returns(bool);
1826     function finishMigration() external returns(bool);
1827     function setup(address _firstCorpBank) external;
1828 }
1829 
1830 interface PlayerBookInterface {
1831     function getPlayerID(address _addr) external returns (uint256);
1832     function getPlayerName(uint256 _pID) external view returns (bytes32);
1833     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1834     function getPlayerAddr(uint256 _pID) external view returns (address);
1835     function getNameFee() external view returns (uint256);
1836     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1837     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1838     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1839 }
1840 
1841 
1842 
1843 library NameFilter {
1844     /**
1845      * @dev filters name strings
1846      * -converts uppercase to lower case.  
1847      * -makes sure it does not start/end with a space
1848      * -makes sure it does not contain multiple spaces in a row
1849      * -cannot be only numbers
1850      * -cannot start with 0x 
1851      * -restricts characters to A-Z, a-z, 0-9, and space.
1852      * @return reprocessed string in bytes32 format
1853      */
1854     function nameFilter(string _input)
1855         internal
1856         pure
1857         returns(bytes32)
1858     {
1859         bytes memory _temp = bytes(_input);
1860         uint256 _length = _temp.length;
1861         
1862         //sorry limited to 32 characters
1863         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1864         // make sure it doesnt start with or end with space
1865         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1866         // make sure first two characters are not 0x
1867         if (_temp[0] == 0x30)
1868         {
1869             require(_temp[1] != 0x78, "string cannot start with 0x");
1870             require(_temp[1] != 0x58, "string cannot start with 0X");
1871         }
1872         
1873         // create a bool to track if we have a non number character
1874         bool _hasNonNumber;
1875         
1876         // convert & check
1877         for (uint256 i = 0; i < _length; i++)
1878         {
1879             // if its uppercase A-Z
1880             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1881             {
1882                 // convert to lower case a-z
1883                 _temp[i] = byte(uint(_temp[i]) + 32);
1884                 
1885                 // we have a non number
1886                 if (_hasNonNumber == false)
1887                     _hasNonNumber = true;
1888             } else {
1889                 require
1890                 (
1891                     // require character is a space
1892                     _temp[i] == 0x20 || 
1893                     // OR lowercase a-z
1894                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1895                     // or 0-9
1896                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1897                     "string contains invalid characters"
1898                 );
1899                 // make sure theres not 2x spaces in a row
1900                 if (_temp[i] == 0x20)
1901                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1902                 
1903                 // see if we have a character other than a number
1904                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1905                     _hasNonNumber = true;    
1906             }
1907         }
1908         
1909         require(_hasNonNumber == true, "string cannot be only numbers");
1910         
1911         bytes32 _ret;
1912         assembly {
1913             _ret := mload(add(_temp, 32))
1914         }
1915         return (_ret);
1916     }
1917 }
1918 
1919 /**
1920  * @title SafeMath v0.1.9
1921  * @dev Math operations with safety checks that throw on error
1922  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1923  * - added sqrt
1924  * - added sq
1925  * - added pwr 
1926  * - changed asserts to requires with error log outputs
1927  * - removed div, its useless
1928  */
1929 library SafeMath {
1930     
1931     /**
1932     * @dev Multiplies two numbers, throws on overflow.
1933     */
1934     function mul(uint256 a, uint256 b) 
1935         internal 
1936         pure 
1937         returns (uint256 c) 
1938     {
1939         if (a == 0) {
1940             return 0;
1941         }
1942         c = a * b;
1943         require(c / a == b, "SafeMath mul failed");
1944         return c;
1945     }
1946 
1947     /**
1948     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1949     */
1950     function sub(uint256 a, uint256 b)
1951         internal
1952         pure
1953         returns (uint256) 
1954     {
1955         require(b <= a, "SafeMath sub failed");
1956         return a - b;
1957     }
1958 
1959     /**
1960     * @dev Adds two numbers, throws on overflow.
1961     */
1962     function add(uint256 a, uint256 b)
1963         internal
1964         pure
1965         returns (uint256 c) 
1966     {
1967         c = a + b;
1968         require(c >= a, "SafeMath add failed");
1969         return c;
1970     }
1971     
1972     /**
1973      * @dev gives square root of given x.
1974      */
1975     function sqrt(uint256 x)
1976         internal
1977         pure
1978         returns (uint256 y) 
1979     {
1980         uint256 z = ((add(x,1)) / 2);
1981         y = x;
1982         while (z < y) 
1983         {
1984             y = z;
1985             z = ((add((x / z),z)) / 2);
1986         }
1987     }
1988     
1989     /**
1990      * @dev gives square. multiplies x by x
1991      */
1992     function sq(uint256 x)
1993         internal
1994         pure
1995         returns (uint256)
1996     {
1997         return (mul(x,x));
1998     }
1999     
2000     /**
2001      * @dev x to the power of y 
2002      */
2003     function pwr(uint256 x, uint256 y)
2004         internal 
2005         pure 
2006         returns (uint256)
2007     {
2008         if (x==0)
2009             return (0);
2010         else if (y==0)
2011             return (1);
2012         else 
2013         {
2014             uint256 z = x;
2015             for (uint256 i=1; i < y; i++)
2016                 z = mul(z,x);
2017             return (z);
2018         }
2019     }
2020 }