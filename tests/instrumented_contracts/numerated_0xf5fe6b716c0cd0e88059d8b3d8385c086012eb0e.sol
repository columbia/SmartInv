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
41     // fired whenever theres a withdraw
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
120 //==============================================================================
121 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
122 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
123 //====================================|=========================================
124 
125 contract modularLong is F3Devents { }
126 
127 contract FoMo3Dlong is modularLong {
128     using SafeMath for *;
129     using NameFilter for string;
130     using F3DKeysCalcLong for uint256;
131 
132     // otherFoMo3D private otherF3D_;
133     address private otherF3D_;
134     uint8 private rSees_;
135     
136     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xED8c249B7EB8d5b3cF7e0d6CcFA270249f7C0CeF);
137 
138 //==============================================================================
139 //     _ _  _  |`. _     _ _ |_ | _  _  .
140 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
141 //=================_|===========================================================
142     string constant public name = "Gold medal winner Official";
143     string constant public symbol = "Gold";
144     uint256 private rndExtra_ = 60;     // length of the very first ICO
145     uint256 private rndGap_ = 60;         // length of ICO phase, set to 1 year for EOS.
146     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
147     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
148     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
149     address constant private ceo = 0x918b8dc988e3702DA4625d69E3D043E8aA9358e6;
150     address constant private cfo = 0xCC221D6154A5091919240b36d476C2BdeAf246BD;
151     address constant private coo = 0x139aAc9edD31015327394160516C26E8f3Ee06AB;
152     address constant private cto = 0xDe0015b72D1dC1F32768Dc1983788F4c32F70f05;
153 //==============================================================================
154 //     _| _ _|_ _    _ _ _|_    _   .
155 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
156 //=============================|================================================
157     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
158     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
159     uint256 public rID_;    // round id number / total rounds that have happened
160 //****************
161 // PLAYER DATA
162 //****************
163     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
164     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
165     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
166     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
167     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
168 //****************
169 // ROUND DATA
170 //****************
171     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
172     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
173 //****************
174 // TEAM FEE DATA
175 //****************
176     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
177     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
178 //==============================================================================
179 //     _ _  _  __|_ _    __|_ _  _  .
180 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
181 //==============================================================================
182     constructor()
183         public
184     {
185         // Team allocation structures
186         // 0 = electric
187         // 1 = cloud  
188         // 2 = thunder 
189         // 3 = wind 
190 
191         // Team allocation percentages
192         // (F3D, P3D) + (Pot , Referrals, Community)
193             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
194         fees_[0] = F3Ddatasets.TeamFee(48,0);   
195         fees_[1] = F3Ddatasets.TeamFee(28,0);   
196         fees_[2] = F3Ddatasets.TeamFee(18,0);   
197         fees_[3] = F3Ddatasets.TeamFee(38,0);   
198 
199         // how to split up the final pot based on which team was picked
200         // (F3D, P3D)
201         potSplit_[0] = F3Ddatasets.PotSplit(38,0);  
202         potSplit_[1] = F3Ddatasets.PotSplit(28,0);  
203         potSplit_[2] = F3Ddatasets.PotSplit(23,0);  
204         potSplit_[3] = F3Ddatasets.PotSplit(33,0);  
205     }
206 //==============================================================================
207 //     _ _  _  _|. |`. _  _ _  .
208 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
209 //==============================================================================
210     /**
211      * @dev used to make sure no one can interact with contract until it has
212      * been activated.
213      */
214     modifier isActivated() {
215         require(activated_ == true, "its not ready yet.  check ?eta in discord");
216         _;
217     }
218 
219     /**
220      * @dev prevents contracts from interacting with fomo3d
221      */
222     modifier isHuman() {
223         address _addr = msg.sender;
224         uint256 _codeLength;
225 
226         assembly {_codeLength := extcodesize(_addr)}
227         require(_codeLength == 0, "sorry humans only");
228         _;
229     }
230 
231     /**
232      * @dev sets boundaries for incoming tx
233      */
234     modifier isWithinLimits(uint256 _eth) {
235         require(_eth >= 100000000000000000, "pocket lint: not a valid currency");
236         require(_eth <= 100000000000000000000000, "no vitalik, no");
237         _;
238     }
239 
240 //==============================================================================
241 //     _    |_ |. _   |`    _  __|_. _  _  _  .
242 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
243 //====|=========================================================================
244     /**
245      * @dev emergency buy uses last stored affiliate ID and team snek
246      */
247     function()
248         isActivated()
249         isHuman()
250         isWithinLimits(msg.value)
251         public
252         payable
253     {
254         // set up our tx event data and determine if player is new or not
255         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
256 
257         // fetch player id
258         uint256 _pID = pIDxAddr_[msg.sender];
259 
260         // buy core
261         buyCore(_pID, plyr_[_pID].laff, 0, _eventData_);
262     }
263 
264     /**
265      * @dev converts all incoming ethereum to keys.
266      * -functionhash- 0x8f38f309 (using ID for affiliate)
267      * -functionhash- 0x98a0871d (using address for affiliate)
268      * -functionhash- 0xa65b37a1 (using name for affiliate)
269      * @param _affCode the ID/address/name of the player who gets the affiliate fee
270      * @param _team what team is the player playing for?
271      */
272     function buyXid(uint256 _affCode, uint256 _team)
273         isActivated()
274         isHuman()
275         isWithinLimits(msg.value)
276         public
277         payable
278     {
279         // set up our tx event data and determine if player is new or not
280         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
281 
282         // fetch player id
283         uint256 _pID = pIDxAddr_[msg.sender];
284 
285         // manage affiliate residuals
286         // if no affiliate code was given or player tried to use their own, lolz
287         if (_affCode == 0 || _affCode == _pID)
288         {
289             // use last stored affiliate code
290             _affCode = plyr_[_pID].laff;
291 
292         // if affiliate code was given & its not the same as previously stored
293         } else if (_affCode != plyr_[_pID].laff) {
294             // update last affiliate
295             plyr_[_pID].laff = _affCode;
296         }
297 
298         // verify a valid team was selected
299         _team = verifyTeam(_team);
300 
301         // buy core
302         buyCore(_pID, _affCode, _team, _eventData_);
303     }
304 
305     function buyXaddr(address _affCode, uint256 _team)
306         isActivated()
307         isHuman()
308         isWithinLimits(msg.value)
309         public
310         payable
311     {
312         // set up our tx event data and determine if player is new or not
313         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
314 
315         // fetch player id
316         uint256 _pID = pIDxAddr_[msg.sender];
317 
318         // manage affiliate residuals
319         uint256 _affID;
320         // if no affiliate code was given or player tried to use their own, lolz
321         if (_affCode == address(0) || _affCode == msg.sender)
322         {
323             // use last stored affiliate code
324             _affID = plyr_[_pID].laff;
325 
326         // if affiliate code was given
327         } else {
328             // get affiliate ID from aff Code
329             _affID = pIDxAddr_[_affCode];
330 
331             // if affID is not the same as previously stored
332             if (_affID != plyr_[_pID].laff)
333             {
334                 // update last affiliate
335                 plyr_[_pID].laff = _affID;
336             }
337         }
338 
339         // verify a valid team was selected
340         _team = verifyTeam(_team);
341 
342         // buy core
343         buyCore(_pID, _affID, _team, _eventData_);
344     }
345 
346     function buyXname(bytes32 _affCode, uint256 _team)
347         isActivated()
348         isHuman()
349         isWithinLimits(msg.value)
350         public
351         payable
352     {
353         // set up our tx event data and determine if player is new or not
354         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
355 
356         // fetch player id
357         uint256 _pID = pIDxAddr_[msg.sender];
358 
359         // manage affiliate residuals
360         uint256 _affID;
361         // if no affiliate code was given or player tried to use their own, lolz
362         if (_affCode == '' || _affCode == plyr_[_pID].name)
363         {
364             // use last stored affiliate code
365             _affID = plyr_[_pID].laff;
366 
367         // if affiliate code was given
368         } else {
369             // get affiliate ID from aff Code
370             _affID = pIDxName_[_affCode];
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
387     /**
388      * @dev essentially the same as buy, but instead of you sending ether
389      * from your wallet, it uses your unwithdrawn earnings.
390      * -functionhash- 0x349cdcac (using ID for affiliate)
391      * -functionhash- 0x82bfc739 (using address for affiliate)
392      * -functionhash- 0x079ce327 (using name for affiliate)
393      * @param _affCode the ID/address/name of the player who gets the affiliate fee
394      * @param _team what team is the player playing for?
395      * @param _eth amount of earnings to use (remainder returned to gen vault)
396      */
397     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
398         isActivated()
399         isHuman()
400        
401         public
402     {
403         // set up our tx event data
404         F3Ddatasets.EventReturns memory _eventData_;
405 
406         // fetch player ID
407         uint256 _pID = pIDxAddr_[msg.sender];
408 
409         // manage affiliate residuals
410         // if no affiliate code was given or player tried to use their own, lolz
411         if (_affCode == 0 || _affCode == _pID)
412         {
413             // use last stored affiliate code
414             _affCode = plyr_[_pID].laff;
415 
416         // if affiliate code was given & its not the same as previously stored
417         } else if (_affCode != plyr_[_pID].laff) {
418             // update last affiliate
419             plyr_[_pID].laff = _affCode;
420         }
421 
422         // verify a valid team was selected
423         _team = verifyTeam(_team);
424 
425         // reload core
426         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
427     }
428 
429     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
430         isActivated()
431         isHuman()
432        
433         public
434     {
435         // set up our tx event data
436         F3Ddatasets.EventReturns memory _eventData_;
437 
438         // fetch player ID
439         uint256 _pID = pIDxAddr_[msg.sender];
440 
441         // manage affiliate residuals
442         uint256 _affID;
443         // if no affiliate code was given or player tried to use their own, lolz
444         if (_affCode == address(0) || _affCode == msg.sender)
445         {
446             // use last stored affiliate code
447             _affID = plyr_[_pID].laff;
448 
449         // if affiliate code was given
450         } else {
451             // get affiliate ID from aff Code
452             _affID = pIDxAddr_[_affCode];
453 
454             // if affID is not the same as previously stored
455             if (_affID != plyr_[_pID].laff)
456             {
457                 // update last affiliate
458                 plyr_[_pID].laff = _affID;
459             }
460         }
461 
462         // verify a valid team was selected
463         _team = verifyTeam(_team);
464 
465         // reload core
466         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
467     }
468 
469     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
470         isActivated()
471         isHuman()
472        
473         public
474     {
475         // set up our tx event data
476         F3Ddatasets.EventReturns memory _eventData_;
477 
478         // fetch player ID
479         uint256 _pID = pIDxAddr_[msg.sender];
480 
481         // manage affiliate residuals
482         uint256 _affID;
483         // if no affiliate code was given or player tried to use their own, lolz
484         if (_affCode == '' || _affCode == plyr_[_pID].name)
485         {
486             // use last stored affiliate code
487             _affID = plyr_[_pID].laff;
488 
489         // if affiliate code was given
490         } else {
491             // get affiliate ID from aff Code
492             _affID = pIDxName_[_affCode];
493 
494             // if affID is not the same as previously stored
495             if (_affID != plyr_[_pID].laff)
496             {
497                 // update last affiliate
498                 plyr_[_pID].laff = _affID;
499             }
500         }
501 
502         // verify a valid team was selected
503         _team = verifyTeam(_team);
504 
505         // reload core
506         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
507     }
508 
509     /**
510      * @dev withdraws all of your earnings.
511      * -functionhash- 0x3ccfd60b
512      */
513     function withdraw()
514         isActivated()
515         isHuman()
516         public
517     {
518         // setup local rID
519         uint256 _rID = rID_;
520 
521         // grab time
522         uint256 _now = now;
523 
524         // fetch player ID
525         uint256 _pID = pIDxAddr_[msg.sender];
526 
527         // setup temp var for player eth
528         uint256 _eth;
529 
530         // check to see if round has ended and no one has run round end yet
531         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
532         {
533             // set up our tx event data
534             F3Ddatasets.EventReturns memory _eventData_;
535 
536             // end the round (distributes pot)
537             round_[_rID].ended = true;
538             _eventData_ = endRound(_eventData_);
539 
540             // get their earnings
541             _eth = withdrawEarnings(_pID);
542 
543             // gib moni
544             if (_eth > 0)
545                 plyr_[_pID].addr.transfer(_eth);
546 
547             // build event data
548             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
549             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
550 
551             // fire withdraw and distribute event
552             emit F3Devents.onWithdrawAndDistribute
553             (
554                 msg.sender,
555                 plyr_[_pID].name,
556                 _eth,
557                 _eventData_.compressedData,
558                 _eventData_.compressedIDs,
559                 _eventData_.winnerAddr,
560                 _eventData_.winnerName,
561                 _eventData_.amountWon,
562                 _eventData_.newPot,
563                 _eventData_.P3DAmount,
564                 _eventData_.genAmount
565             );
566 
567         // in any other situation
568         } else {
569             // get their earnings
570             _eth = withdrawEarnings(_pID);
571 
572             // gib moni
573             if (_eth > 0)
574                 plyr_[_pID].addr.transfer(_eth);
575 
576             // fire withdraw event
577             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
578         }
579     }
580 
581     /**
582      * @dev use these to register names.  they are just wrappers that will send the
583      * registration requests to the PlayerBook contract.  So registering here is the
584      * same as registering there.  UI will always display the last name you registered.
585      * but you will still own all previously registered names to use as affiliate
586      * links.
587      * - must pay a registration fee.
588      * - name must be unique
589      * - names will be converted to lowercase
590      * - name cannot start or end with a space
591      * - cannot have more than 1 space in a row
592      * - cannot be only numbers
593      * - cannot start with 0x
594      * - name must be at least 1 char
595      * - max length of 32 characters long
596      * - allowed characters: a-z, 0-9, and space
597      * -functionhash- 0x921dec21 (using ID for affiliate)
598      * -functionhash- 0x3ddd4698 (using address for affiliate)
599      * -functionhash- 0x685ffd83 (using name for affiliate)
600      * @param _nameString players desired name
601      * @param _affCode affiliate ID, address, or name of who referred you
602      * @param _all set to true if you want this to push your info to all games
603      * (this might cost a lot of gas)
604      */
605     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
606         isHuman()
607         public
608         payable
609     {
610         bytes32 _name = _nameString.nameFilter();
611         address _addr = msg.sender;
612         uint256 _paid = msg.value;
613         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
614 
615         uint256 _pID = pIDxAddr_[_addr];
616 
617         // fire event
618         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
619     }
620 
621     function registerNameXaddr(string _nameString, address _affCode, bool _all)
622         isHuman()
623         public
624         payable
625     {
626         bytes32 _name = _nameString.nameFilter();
627         address _addr = msg.sender;
628         uint256 _paid = msg.value;
629         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
630 
631         uint256 _pID = pIDxAddr_[_addr];
632 
633         // fire event
634         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
635     }
636 
637     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
638         isHuman()
639         public
640         payable
641     {
642         bytes32 _name = _nameString.nameFilter();
643         address _addr = msg.sender;
644         uint256 _paid = msg.value;
645         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
646 
647         uint256 _pID = pIDxAddr_[_addr];
648 
649         // fire event
650         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
651     }
652 //==============================================================================
653 //     _  _ _|__|_ _  _ _  .
654 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
655 //=====_|=======================================================================
656     /**
657      * @dev return the price buyer will pay for next 1 individual key.
658      * -functionhash- 0x018a25e8
659      * @return price for next key bought (in wei format)
660      */
661     function getBuyPrice()
662         public
663         view
664         returns(uint256)
665     {
666         // setup local rID
667         uint256 _rID = rID_;
668 
669         // grab time
670         uint256 _now = now;
671 
672         // are we in a round?
673         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
674             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
675         else // rounds over.  need price for new round
676             return ( 1000000000000000 ); // init
677     }
678 
679     /**
680      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
681      * provider
682      * -functionhash- 0xc7e284b8
683      * @return time left in seconds
684      */
685     function getTimeLeft()
686         public
687         view
688         returns(uint256)
689     {
690         // setup local rID
691         uint256 _rID = rID_;
692 
693         // grab time
694         uint256 _now = now;
695 
696         if (_now < round_[_rID].end)
697             if (_now > round_[_rID].strt + rndGap_)
698                 return( (round_[_rID].end).sub(_now) );
699             else
700                 return( (round_[_rID].strt + rndGap_).sub(_now) );
701         else
702             return(0);
703     }
704 
705     /**
706      * @dev returns player earnings per vaults
707      * -functionhash- 0x63066434
708      * @return winnings vault
709      * @return general vault
710      * @return affiliate vault
711      */
712     function getPlayerVaults(uint256 _pID)
713         public
714         view
715         returns(uint256 ,uint256, uint256)
716     {
717         // setup local rID
718         uint256 _rID = rID_;
719 
720         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
721         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
722         {
723             // if player is winner
724             if (round_[_rID].plyr == _pID)
725             {
726                 uint256 bonus = 0;
727                 uint256 count = 0;
728                 uint256 l = round_[_rID].lastNum;
729             for(uint i = 0; i<l; i++)
730             { 
731             uint _pid = round_[_rID].lastPlys[i]; 
732             count += plyr_[_pid].lbks;
733             }
734             bonus = (((round_[_rID].pot).mul(48)) / 100).mul(plyr_[_pID].lbks) / count;
735                 return
736                 (
737                     (plyr_[_pID].win).add(bonus),
738                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
739                     plyr_[_pID].aff
740                 );
741             // if player is not the winner
742             } else {
743                 return
744                 (
745                     plyr_[_pID].win,
746                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
747                     plyr_[_pID].aff
748                 );
749             }
750 
751         // if round is still going on, or round has ended and round end has been ran
752         } else {
753             return
754             (
755                 plyr_[_pID].win,
756                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
757                 plyr_[_pID].aff
758             );
759         }
760     }
761 
762     /**
763      * solidity hates stack limits.  this lets us avoid that hate
764      */
765     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
766         private
767         view
768         returns(uint256)
769     {
770         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
771     }
772 
773     /**
774      * @dev returns all current round info needed for front end
775      * -functionhash- 0x747dff42
776      * @return eth invested during ICO phase
777      * @return round id
778      * @return total keys for round
779      * @return time round ends
780      * @return time round started
781      * @return current pot
782      * @return current team ID & player ID in lead
783      * @return current player in leads address
784      * @return current player in leads name
785      * @return whales eth in for round
786      * @return bears eth in for round
787      * @return sneks eth in for round
788      * @return bulls eth in for round
789      * @return airdrop tracker # & airdrop pot
790      */
791     function getCurrentRoundInfo()
792         public
793         view
794         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
795     {
796         // setup local rID
797         uint256 _rID = rID_;
798 
799         return
800         (
801             round_[_rID].ico,               //0
802             _rID,                           //1
803             round_[_rID].keys,              //2
804             round_[_rID].end,               //3
805             round_[_rID].strt,              //4
806             round_[_rID].pot,               //5
807             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
808             plyr_[round_[_rID].plyr].addr,  //7
809             plyr_[round_[_rID].plyr].name,  //8
810             rndTmEth_[_rID][0],             //9
811             rndTmEth_[_rID][1],             //10
812             rndTmEth_[_rID][2],             //11
813             rndTmEth_[_rID][3],             //12
814             airDropTracker_ + (airDropPot_ * 1000)              //13
815         );
816     }
817 
818     /**
819      * @dev returns player info based on address.  if no address is given, it will
820      * use msg.sender
821      * -functionhash- 0xee0b5d8b
822      * @param _addr address of the player you want to lookup
823      * @return player ID
824      * @return player name
825      * @return keys owned (current round)
826      * @return winnings vault
827      * @return general vault
828      * @return affiliate vault
829      * @return player round eth
830      */
831     function getPlayerInfoByAddress(address _addr)
832         public
833         view
834         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256,uint256)
835     {
836         // setup local rID
837         uint256 _rID = rID_;
838 
839         if (_addr == address(0))
840         {
841             _addr == msg.sender;
842         }
843         uint256 _pID = pIDxAddr_[_addr];
844 
845         return
846         (
847             _pID,                               //0
848             plyr_[_pID].name,                   //1
849             plyrRnds_[_pID][_rID].keys,         //2
850             plyr_[_pID].win,                    //3
851             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
852             plyr_[_pID].aff,                    //5
853             plyrRnds_[_pID][_rID].eth,           //6
854             plyr_[_pID].laff
855         );
856     }
857 
858 //==============================================================================
859 //     _ _  _ _   | _  _ . _  .
860 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
861 //=====================_|=======================================================
862     /**
863      * @dev logic runs whenever a buy order is executed.  determines how to handle
864      * incoming eth depending on if we are in an active round or not
865      */
866     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
867         private
868     {
869         // setup local rID
870         uint256 _rID = rID_;
871 
872         // grab time
873         uint256 _now = now;
874 
875       
876         // if round is active
877         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
878         {   
879 
880     
881             insertLastPlys(_pID);
882             // call core
883             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
884 
885         // if round is not active
886         } else {
887             // check to see if end round needs to be ran
888             if (_now > round_[_rID].end && round_[_rID].ended == false)
889             {
890                 // end the round (distributes pot) & start new round
891                 round_[_rID].ended = true;
892                 _eventData_ = endRound(_eventData_);
893 
894                 // build event data
895                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
896                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
897 
898                 // fire buy and distribute event
899                 emit F3Devents.onBuyAndDistribute
900                 (
901                     msg.sender,
902                     plyr_[_pID].name,
903                     msg.value,
904                     _eventData_.compressedData,
905                     _eventData_.compressedIDs,
906                     _eventData_.winnerAddr,
907                     _eventData_.winnerName,
908                     _eventData_.amountWon,
909                     _eventData_.newPot,
910                     _eventData_.P3DAmount,
911                     _eventData_.genAmount
912                 );
913             }
914 
915             // put eth in players vault
916             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
917         }
918     }
919 
920     /**
921      * @dev logic runs whenever a reload order is executed.  determines how to handle
922      * incoming eth depending on if we are in an active round or not
923      */
924     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
925         private
926     {
927         // setup local rID
928         uint256 _rID = rID_;
929 
930         // grab time
931         uint256 _now = now;
932 
933         // if round is active
934         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
935         {
936             // get earnings from all vaults and return unused to gen vault
937             // because we use a custom safemath library.  this will throw if player
938             // tried to spend more eth than they have.
939             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
940 
941             // call core
942             core(_rID, _pID, _eth, _affID, _team, _eventData_);
943 
944         // if round is not active and end round needs to be ran
945         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
946             // end the round (distributes pot) & start new round
947             round_[_rID].ended = true;
948             _eventData_ = endRound(_eventData_);
949 
950             // build event data
951             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
952             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
953 
954             // fire buy and distribute event
955             emit F3Devents.onReLoadAndDistribute
956             (
957                 msg.sender,
958                 plyr_[_pID].name,
959                 _eventData_.compressedData,
960                 _eventData_.compressedIDs,
961                 _eventData_.winnerAddr,
962                 _eventData_.winnerName,
963                 _eventData_.amountWon,
964                 _eventData_.newPot,
965                 _eventData_.P3DAmount,
966                 _eventData_.genAmount
967             );
968         }
969     }
970 
971     /**
972      * @dev this is the core logic for any buy/reload that happens while a round
973      * is live.
974      */
975     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
976         private
977     {
978         // if player is new to round
979         if (plyrRnds_[_pID][_rID].keys == 0)
980             _eventData_ = managePlayer(_pID, _eventData_);
981 
982 
983         // if eth left is greater than min eth allowed (sorry no pocket lint)
984         if (_eth > 1000000000)
985         {
986 
987             // mint the new keys
988             uint256 _keys = (round_[_rID].eth).keysRec(_eth,round_[_rID].keys);
989 
990             // if they bought at least 1 whole key
991             if (_keys >= 1000000000000000000)
992             {
993                 updateTimer(_keys, _rID);
994 
995                 // set new leaders
996                 if (round_[_rID].plyr != _pID)
997                     round_[_rID].plyr = _pID;
998                 if (round_[_rID].team != _team)
999                     round_[_rID].team = _team;
1000 
1001             // set the new leader bool to true
1002             _eventData_.compressedData = _eventData_.compressedData + 100;
1003             }
1004 
1005          
1006             if (airdrop(_team) == true)
1007             {
1008                 // gib muni
1009                 uint256 _prize;
1010                
1011                  _prize = ((airDropPot_).mul(50)) / 100;
1012                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1013 
1014                     // adjust airDropPot
1015                     airDropPot_ = (airDropPot_).sub(_prize);
1016 
1017                     // let event know a tier 3 prize was won
1018                     _eventData_.compressedData += 300000000000000000000000000000000;
1019            
1020             }
1021      
1022 
1023             // store the air drop tracker number (number of buys since last airdrop)
1024             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1025 
1026             // update player
1027             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1028             plyr_[_pID].lbks = _keys;
1029             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1030 
1031             // update round
1032             round_[_rID].keys = _keys.add(round_[_rID].keys);
1033             round_[_rID].eth = _eth.add(round_[_rID].eth);
1034             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1035 
1036             // distribute eth
1037             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
1038             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1039 
1040             // call end tx function to fire end tx event.
1041             endTx(_pID, _team, _eth, _keys, _eventData_);
1042         }
1043     }
1044 //==============================================================================
1045 //     _ _ | _   | _ _|_ _  _ _  .
1046 //    (_(_||(_|_||(_| | (_)| _\  .
1047 //==============================================================================
1048     /**
1049      * @dev calculates unmasked earnings (just calculates, does not update mask)
1050      * @return earnings in wei format
1051      */
1052     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1053         private
1054         view
1055         returns(uint256)
1056     {
1057         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1058     }
1059 
1060     /**
1061      * @dev returns the amount of keys you would get given an amount of eth.
1062      * -functionhash- 0xce89c80c
1063      * @param _rID round ID you want price for
1064      * @param _eth amount of eth sent in
1065      * @return keys received
1066      */
1067     function calcKeysReceived(uint256 _rID, uint256 _eth)
1068         public
1069         view
1070         returns(uint256)
1071     {
1072         // grab time
1073         uint256 _now = now;
1074 
1075         // are we in a round?
1076         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1077             return ( (round_[_rID].eth).keysRec(_eth,round_[_rID].keys) );
1078         else // rounds over.  need keys for new round
1079             return ( (_eth).keys(round_[_rID].keys) );
1080     }
1081 
1082     /**
1083      * @dev returns current eth price for X keys.
1084      * -functionhash- 0xcf808000
1085      * @param _keys number of keys desired (in 18 decimal format)
1086      * @return amount of eth needed to send
1087      */
1088     function iWantXKeys(uint256 _keys)
1089         public
1090         view
1091         returns(uint256)
1092     {
1093         // setup local rID
1094         uint256 _rID = rID_;
1095 
1096         // grab time
1097         uint256 _now = now;
1098 
1099         // are we in a round?
1100         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1101             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1102         else // rounds over.  need price for new round
1103             return ( (_keys).eth() );
1104     }
1105 //==============================================================================
1106 //    _|_ _  _ | _  .
1107 //     | (_)(_)|_\  .
1108 //==============================================================================
1109     /**
1110      * @dev receives name/player info from names contract
1111      */
1112     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1113         external
1114     {
1115         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1116         if (pIDxAddr_[_addr] != _pID)
1117             pIDxAddr_[_addr] = _pID;
1118         if (pIDxName_[_name] != _pID)
1119             pIDxName_[_name] = _pID;
1120         if (plyr_[_pID].addr != _addr)
1121             plyr_[_pID].addr = _addr;
1122         if (plyr_[_pID].name != _name)
1123             plyr_[_pID].name = _name;
1124         if (plyr_[_pID].laff != _laff)
1125             plyr_[_pID].laff = _laff;
1126         if (plyrNames_[_pID][_name] == false)
1127             plyrNames_[_pID][_name] = true;
1128     }
1129 
1130     /**
1131      * @dev receives entire player name list
1132      */
1133     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1134         external
1135     {
1136         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1137         if(plyrNames_[_pID][_name] == false)
1138             plyrNames_[_pID][_name] = true;
1139     }
1140 
1141     /**
1142      * @dev gets existing or registers new pID.  use this when a player may be new
1143      * @return pID
1144      */
1145     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1146         private
1147         returns (F3Ddatasets.EventReturns)
1148     {
1149         uint256 _pID = pIDxAddr_[msg.sender];
1150         // if player is new to this version of fomo3d
1151         if (_pID == 0)
1152         {
1153             // grab their player ID, name and last aff ID, from player names contract
1154             _pID = PlayerBook.getPlayerID(msg.sender);
1155             bytes32 _name = PlayerBook.getPlayerName(_pID);
1156             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1157 
1158             // set up player account
1159             pIDxAddr_[msg.sender] = _pID;
1160             plyr_[_pID].addr = msg.sender;
1161 
1162             if (_name != "")
1163             {
1164                 pIDxName_[_name] = _pID;
1165                 plyr_[_pID].name = _name;
1166                 plyrNames_[_pID][_name] = true;
1167             }
1168 
1169             if (_laff != 0 && _laff != _pID)
1170                 plyr_[_pID].laff = _laff;
1171 
1172             // set the new player bool to true
1173             _eventData_.compressedData = _eventData_.compressedData + 1;
1174         }
1175         return (_eventData_);
1176     }
1177 
1178     /**
1179      * @dev checks to make sure user picked a valid team.  if not sets team
1180      * to default (sneks)
1181      */
1182     function verifyTeam(uint256 _team)
1183         private
1184         pure
1185         returns (uint256)
1186     {
1187         if (_team < 0 || _team > 3)
1188             return(2);
1189         else
1190             return(_team);
1191     }
1192 
1193     /**
1194      * @dev decides if round end needs to be run & new round started.  and if
1195      * player unmasked earnings from previously played rounds need to be moved.
1196      */
1197     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1198         private
1199         returns (F3Ddatasets.EventReturns)
1200     {
1201         // if player has played a previous round, move their unmasked earnings
1202         // from that round to gen vault.
1203         if (plyr_[_pID].lrnd != 0)
1204             updateGenVault(_pID, plyr_[_pID].lrnd);
1205 
1206         // update player's last round played
1207         plyr_[_pID].lrnd = rID_;
1208 
1209         // set the joined round bool to true
1210         _eventData_.compressedData = _eventData_.compressedData + 10;
1211 
1212         return(_eventData_);
1213     }
1214 
1215     /**
1216      * @dev ends the round. manages paying out winner/splitting up pot
1217      */
1218     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1219         private
1220         returns (F3Ddatasets.EventReturns)
1221     {
1222         // setup local rID
1223         uint256 _rID = rID_;
1224 
1225         // grab our winning player and team id's
1226         uint256 _winPID = round_[_rID].plyr;
1227         uint256 _winTID = round_[_rID].team;
1228 
1229 
1230         // grab our pot amount
1231         uint256 _pot = round_[_rID].pot;
1232 
1233         // calculate our winner share, community rewards, gen share,
1234         // p3d share, and amount reserved for next pot
1235         uint256 _win = (_pot.mul(48)) / 100;
1236         uint256 _com = (_pot / 25);
1237         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1238         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1239         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1240 
1241         // calculate ppt for round mask
1242         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1243         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1244         if (_dust > 0)
1245         {
1246             _gen = _gen.sub(_dust);
1247             _res = _res.add(_dust);
1248         }
1249 
1250         payLast(_win);
1251 
1252      
1253         // distribute gen portion to key holders
1254         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1255       
1256         if (_com > 0)
1257          {
1258             ceo.transfer( _com.mul(20) / 100);
1259             cfo.transfer( _com.mul(20) / 100);
1260             coo.transfer( _com.mul(50) / 100);
1261             cto.transfer(_com.mul(10) / 100);
1262          }
1263         // prepare event data
1264         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1265         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1266         _eventData_.winnerAddr = plyr_[_winPID].addr;
1267         _eventData_.winnerName = plyr_[_winPID].name;
1268         _eventData_.amountWon = _win;
1269         _eventData_.genAmount = _gen;
1270         _eventData_.P3DAmount = _p3d;
1271         _eventData_.newPot = _res;
1272 
1273         // start next round
1274         rID_++;
1275         _rID++;
1276         round_[_rID].strt = now;
1277         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1278         round_[_rID].pot = _res;
1279 
1280         return(_eventData_);
1281     }
1282 
1283     /**
1284      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1285      */
1286     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1287         private
1288     {
1289         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1290         if (_earnings > 0)
1291         {
1292             // put in gen vault
1293             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1294             // zero out their earnings by updating mask
1295             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1296         }
1297     }
1298 
1299     /**
1300      * @dev updates round timer based on number of whole keys bought.
1301      */
1302     function updateTimer(uint256 _keys, uint256 _rID)
1303         private
1304     {
1305         // grab time
1306         uint256 _now = now;
1307 
1308         // calculate time based on number of keys bought
1309         uint256 _newTime;
1310         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1311             _newTime = (((_keys) / (1000000000000000000)).mul(rndInit_)).add(_now);
1312         else
1313             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1314 
1315         // compare to max and set new end time
1316         if (_newTime < (rndMax_).add(_now))
1317             round_[_rID].end = _newTime;
1318         else
1319             round_[_rID].end = rndMax_.add(_now);
1320     }
1321 
1322     /**
1323      * @dev generates a random number between 0-99 and checks to see if thats
1324      * resulted in an airdrop win
1325      * @return do we have a winner?
1326      */
1327     function airdrop(uint256 _temp)
1328         private
1329         view
1330         returns(bool)
1331     {
1332         uint8 cc= 0;
1333         uint8[5] memory randomNum;
1334          if(_temp == 0){
1335             randomNum[0]=6;
1336             randomNum[1]=22;
1337             randomNum[2]=38;
1338             randomNum[3]=59;
1339             randomNum[4]=96;
1340             cc = 5;
1341             
1342             }else if(_temp == 1){
1343             randomNum[0]=9;
1344             randomNum[1]=25;
1345             randomNum[2]=65;
1346             randomNum[3]=79;
1347             cc = 4;
1348             }else if(_temp == 2){
1349             randomNum[0]=2;
1350             randomNum[1]=57;
1351             randomNum[2]=32;
1352             cc = 3;
1353          
1354             }else if(_temp == 3){
1355             randomNum[0]=44;
1356             randomNum[1]=90;
1357             cc = 2;
1358          
1359             }
1360         
1361         
1362         uint256 seed = uint256(keccak256(abi.encodePacked(
1363 
1364             (block.timestamp).add
1365             (block.difficulty).add
1366             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1367             (block.gaslimit).add
1368             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1369             (block.number)
1370 
1371         )));
1372         seed = seed - ((seed / 100) * 100);
1373         for(uint j=0;j<cc;j++)
1374         {
1375            if(randomNum[j] == seed)
1376            {
1377              return(true);
1378            } 
1379         }
1380        
1381             return(false);
1382     }
1383     
1384     /**
1385      * @dev distributes eth based on fees to com, aff, and p3d
1386      */
1387     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
1388         private
1389         returns(F3Ddatasets.EventReturns)
1390     {
1391         // pay 20% out to community rewards
1392         uint256 _com = _eth / 5;
1393      
1394         // distribute share to affiliate
1395         uint256 _aff;
1396         _aff = _eth.mul(10) / 100;
1397       
1398         // decide what to do with affiliate share of fees
1399         // affiliate must not be self, and must have a name registered
1400         if (_affID != _pID && plyr_[_affID].name != "") {
1401             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1402              emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1403         } else {
1404             //_com = _com.add(_aff);
1405          
1406             ceo.transfer(_aff.mul(40) / 100);
1407             cfo.transfer(_aff.mul(40) / 100);
1408             cto.transfer(_aff.mul(20) / 100);
1409         }
1410 
1411  
1412         if (_com > 0)
1413         {
1414            
1415             
1416             ceo.transfer(_com.mul(20) / 100);
1417             cfo.transfer(_com.mul(20) / 100);
1418             coo.transfer( _com.mul(50) / 100);
1419             cto.transfer(_com.mul(10) / 100);
1420             // set up event data
1421             _eventData_.P3DAmount = _com.add(_eventData_.P3DAmount);
1422         }
1423 
1424         return(_eventData_);
1425     }
1426 
1427     function potSwap()
1428         external
1429         payable
1430     {
1431         // setup local rID
1432         uint256 _rID = rID_ + 1;
1433 
1434         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1435         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1436     }
1437 
1438     /**
1439      * @dev distributes eth based on fees to gen and pot
1440      */
1441     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1442         private
1443         returns(F3Ddatasets.EventReturns)
1444     {
1445         // calculate gen share
1446         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1447 
1448         // toss 20% into airdrop pot
1449         uint256 _air = (_eth.mul(2)/ 100);
1450         airDropPot_ = airDropPot_.add(_air);
1451 
1452         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1453         _eth = _eth.sub(((_eth.mul(20)) / 100).add((_eth.mul(12)) / 100));
1454 
1455         // calculate pot
1456         uint256 _pot = _eth.sub(_gen);
1457 
1458         // distribute gen share (thats what updateMasks() does) and adjust
1459         // balances for dust.
1460         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1461         if (_dust > 0)
1462             _gen = _gen.sub(_dust);
1463 
1464         // add eth to pot
1465         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1466 
1467         // set up event data
1468         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1469         _eventData_.potAmount = _pot;
1470 
1471         return(_eventData_);
1472     }
1473 
1474     /**
1475      * @dev updates masks for round and player when keys are bought
1476      * @return dust left over
1477      */
1478     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1479         private
1480         returns(uint256)
1481     {
1482         /* MASKING NOTES
1483             earnings masks are a tricky thing for people to wrap their minds around.
1484             the basic thing to understand here.  is were going to have a global
1485             tracker based on profit per share for each round, that increases in
1486             relevant proportion to the increase in share supply.
1487 
1488             the player will have an additional mask that basically says "based
1489             on the rounds mask, my shares, and how much i've already withdrawn,
1490             how much is still owed to me?"
1491         */
1492 
1493         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1494         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1495         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1496 
1497         // calculate player earning from their own buy (only based on the keys
1498         // they just bought).  & update player earnings mask
1499         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1500         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1501 
1502         // calculate & return dust
1503         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1504     }
1505 
1506     /**
1507      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1508      * @return earnings in wei format
1509      */
1510     function withdrawEarnings(uint256 _pID)
1511         private
1512         returns(uint256)
1513     {
1514         // update gen vault
1515         updateGenVault(_pID, plyr_[_pID].lrnd);
1516 
1517         // from vaults
1518         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1519         if (_earnings > 0)
1520         {
1521             plyr_[_pID].win = 0;
1522             plyr_[_pID].gen = 0;
1523             plyr_[_pID].aff = 0;
1524         }
1525 
1526         return(_earnings);
1527     }
1528 
1529     /**
1530      * @dev prepares compression data and fires event for buy or reload tx's
1531      */
1532     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1533         private
1534     {
1535         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1536         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1537 
1538         emit F3Devents.onEndTx
1539         (
1540             _eventData_.compressedData,
1541             _eventData_.compressedIDs,
1542             plyr_[_pID].name,
1543             msg.sender,
1544             _eth,
1545             _keys,
1546             _eventData_.winnerAddr,
1547             _eventData_.winnerName,
1548             _eventData_.amountWon,
1549             _eventData_.newPot,
1550             _eventData_.P3DAmount,
1551             _eventData_.genAmount,
1552             _eventData_.potAmount,
1553             airDropPot_
1554         );
1555     }
1556 //==============================================================================
1557 //    (~ _  _    _._|_    .
1558 //    _)(/_(_|_|| | | \/  .
1559 //====================/=========================================================
1560     /** upon contract deploy, it will be deactivated.  this is a one time
1561      * use function that will activate the contract.  we do this so devs
1562      * have time to set things up on the web end                            **/
1563     bool public activated_ = false;
1564     function activate()
1565         public
1566     {
1567         // only team just can activate
1568         require(
1569             msg.sender == 0x100d5695a0b35bbb8c044AEFef7C7b278E5843e1,
1570             "only team just can activate"
1571         );
1572 
1573         // make sure that its been linked.
1574         //require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1575 
1576         // can only be ran once
1577         require(activated_ == false, "fomo3d already activated");
1578 
1579         // activate the contract
1580         activated_ = true;
1581 
1582         // lets start first round
1583         rID_ = 1;
1584         round_[1].strt = now + rndExtra_ - rndGap_;
1585         round_[1].end = now + rndInit_ + rndExtra_;
1586     }
1587     function setOtherFomo(address _otherF3D)
1588         public
1589     {
1590         // only team just can activate
1591         require(
1592             msg.sender == 0x100d5695a0b35bbb8c044AEFef7C7b278E5843e1,
1593             "only team just can activate"
1594         );
1595 
1596         // make sure that it HASNT yet been linked.
1597         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1598 
1599         // set up other fomo3d (fast or long) for pot swap
1600         // otherF3D_ = otherFoMo3D(_otherF3D);
1601         otherF3D_ = _otherF3D;
1602     }
1603 
1604 
1605     function insertLastPlys(uint256 _pID)
1606     private
1607     {   
1608         uint256 _rID = rID_;    
1609         if(round_[_rID].lastNum == 0)
1610         {   round_[_rID].lastPlys[0] = _pID;
1611             round_[_rID].lastNum++;
1612             //round_[_rID].lastPlys.push(_pID);
1613             }else if(round_[_rID].lastNum <10)
1614             {
1615                 if(round_[rID_].lastPlys[round_[_rID].lastNum-1] != _pID)
1616                 {
1617                     bool repeat = false;
1618                     for(uint j=0; j<round_[_rID].lastNum; j++)
1619                     {
1620                         if(_pID == round_[rID_].lastPlys[j])
1621                         {
1622                             repeat = true;
1623                             break;
1624                         }
1625                     }
1626                     if(!repeat){
1627                         round_[rID_].lastPlys[round_[_rID].lastNum] = _pID;
1628                         round_[_rID].lastNum++;
1629                     //round_[rID_].lastPlys.push(_pID);
1630                     }else{
1631                         for(j; j<round_[_rID].lastNum-1; j++){
1632                             round_[rID_].lastPlys[j] = round_[rID_].lastPlys[j+1];
1633                         }
1634                         round_[rID_].lastPlys[round_[_rID].lastNum-1] = _pID;
1635                     }
1636                 }    
1637             }else{
1638              if(round_[rID_].lastPlys[round_[_rID].lastNum-1] != _pID)
1639              {
1640                 round_[_rID].lastNum = 10;
1641                 for(j=0; j<round_[_rID].lastNum-1; j++){
1642                     round_[rID_].lastPlys[j] = round_[rID_].lastPlys[j+1];
1643                     }
1644                 round_[rID_].lastPlys[round_[_rID].lastNum-1] = _pID;
1645             }    
1646         }  
1647     }
1648 
1649    
1650     function payLast(uint _win)
1651     private{
1652         uint256 _rID = rID_;
1653         uint l = round_[_rID].lastNum;
1654         uint _pid;
1655         uint i;
1656         uint256  count = 0;
1657        
1658         for( i = 0; i<l; i++)
1659         {   
1660             _pid = round_[_rID].lastPlys[i];       
1661             count += plyr_[_pid].lbks;
1662         }
1663         for( i = 0; i<l; i++)
1664         {  
1665             _pid = round_[_rID].lastPlys[i];
1666             plyr_[_pid].win = (_win.mul(plyr_[_pid].lbks / count) ).add(plyr_[_pid].win);  
1667 
1668         }
1669     
1670     }
1671 
1672 }
1673 
1674 //==============================================================================
1675 //   __|_ _    __|_ _  .
1676 //  _\ | | |_|(_ | _\  .
1677 //==============================================================================
1678 library F3Ddatasets {
1679     //compressedData key
1680     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1681         // 0 - new player (bool)
1682         // 1 - joined round (bool)
1683         // 2 - new  leader (bool)
1684         // 3-5 - air drop tracker (uint 0-999)
1685         // 6-16 - round end time
1686         // 17 - winnerTeam
1687         // 18 - 28 timestamp
1688         // 29 - team
1689         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1690         // 31 - airdrop happened bool
1691         // 32 - airdrop tier
1692         // 33 - airdrop amount won
1693     //compressedIDs key
1694     // [77-52][51-26][25-0]
1695         // 0-25 - pID
1696         // 26-51 - winPID
1697         // 52-77 - rID
1698     struct EventReturns {
1699         uint256 compressedData;
1700         uint256 compressedIDs;
1701         address winnerAddr;         // winner address
1702         bytes32 winnerName;         // winner name
1703         uint256 amountWon;          // amount won
1704         uint256 newPot;             // amount in new pot
1705         uint256 P3DAmount;          // amount distributed to p3d
1706         uint256 genAmount;          // amount distributed to gen
1707         uint256 potAmount;          // amount added to pot
1708     }
1709     struct Player {
1710         address addr;   // player address
1711         bytes32 name;   // player name
1712         uint256 win;    // winnings vault
1713         uint256 gen;    // general vault
1714         uint256 aff;    // affiliate vault
1715         uint256 lrnd;   // last round played
1716         uint256 laff;   // last affiliate id used
1717         uint256 lbks;   // last buy keys
1718     }
1719     struct PlayerRounds {
1720         uint256 eth;    // eth player has added to round (used for eth limiter)
1721         uint256 keys;   // keys
1722         uint256 mask;   // player mask
1723         uint256 ico;    // ICO phase investment
1724     }
1725     struct Round {
1726         uint256 plyr;   // pID of player in lead
1727         uint256 team;   // tID of team in lead
1728         uint256 end;    // time ends/ended
1729         bool ended;     // has round end function been ran
1730         uint256 strt;   // time round started
1731         uint256 keys;   // keys
1732         uint256 eth;    // total eth in
1733         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1734         uint256 mask;   // global mask
1735         uint256 ico;    // total eth sent in during ICO phase
1736         uint256 icoGen; // total eth for gen during ICO phase
1737         uint256 icoAvg; // average key price for ICO phase
1738         uint256[10] lastPlys; // last player 
1739         uint256 lastNum;        //count lastPlys length 
1740     }
1741     struct TeamFee {
1742         uint256 gen;    // % of buy in thats paid to key holders of current round
1743         uint256 p3d;    // % of buy in thats paid to p3d holders
1744     }
1745     struct PotSplit {
1746         uint256 gen;    // % of pot thats paid to key holders of current round
1747         uint256 p3d;    // % of pot thats paid to p3d holders
1748     }
1749 }
1750 
1751 //==============================================================================
1752 //  |  _      _ _ | _  .
1753 //  |<(/_\/  (_(_||(_  .
1754 //=======/======================================================================
1755 library F3DKeysCalcLong {
1756     using SafeMath for *;
1757     /**
1758      * @dev calculates number of keys received given X eth
1759      * @param _curEth current amount of eth in contract
1760      * @param _newEth eth being spent
1761      * @return amount of ticket purchased
1762      */
1763      /*
1764     function keysRec(uint256 _curEth, uint256 _newEth)
1765         internal
1766         pure
1767         returns (uint256)
1768     {
1769         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1770     }
1771     */
1772     function keysRec(uint256 _curEth, uint256 _newEth,uint256 _curKeys)
1773         internal
1774         pure
1775         returns (uint256)
1776     {
1777          if(_curKeys<=0){
1778             _curKeys=1000000000000000000;
1779         }   
1780         return (keys(_newEth,_curKeys));
1781  
1782     }
1783     /**
1784      * @dev calculates amount of eth received if you sold X keys
1785      * @param _curKeys current amount of keys that exist
1786      * @param _sellKeys amount of keys you wish to sell
1787      * @return amount of eth received
1788      */
1789      /*
1790     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1791         internal
1792         pure
1793         returns (uint256)
1794     {
1795         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1796     }
1797     */
1798      function ethRec(uint256 _curKeys, uint256 _sellKeys)
1799         internal
1800         pure
1801         returns (uint256)
1802     {
1803        if(_curKeys<=0){
1804             _curKeys=1000000000000000000;
1805         }
1806         return eth(_curKeys).mul(_sellKeys)/1000000000000000000;
1807      
1808     }
1809 
1810     /**
1811      * @dev calculates how many keys would exist with given an amount of eth
1812      * @param _eth eth "in contract"
1813      * @return number of keys that would exist
1814      */
1815      /*
1816     function keys(uint256 _eth)
1817         internal
1818         pure
1819         returns(uint256)
1820     {
1821         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1822     }
1823     */
1824      function keys(uint256 _eth,uint256 _curKeys)
1825         internal
1826         pure
1827         returns(uint256)
1828     {
1829        
1830         uint a =1000000000000000;
1831         uint b =2000000000;
1832         if(_curKeys<=0){
1833             _curKeys=1000000000000000000;
1834         }
1835         uint c = a .add((b.mul((_curKeys.sub(1000000000000000000))))/1000000000000000000);
1836         return (_eth.mul(1000000000000000000)/(c));
1837     }
1838     /**
1839      * @dev calculates how much eth would be in contract given a number of keys
1840      * @param _keys number of keys "in contract"
1841      * @return eth that would exists
1842      */
1843      /*
1844     function eth(uint256 _keys)
1845         internal
1846         pure
1847         returns(uint256)
1848     {
1849         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1850     }
1851     */
1852     function eth(uint256 _keys)
1853         internal
1854         pure
1855         returns(uint256)
1856     {   
1857         uint a =1000000000000000;
1858         uint b =2000000000;
1859         uint c = a .add((b.mul((_keys.sub(1000000000000000000))))/1000000000000000000);
1860         
1861         return c;
1862     }
1863 }
1864 
1865 //==============================================================================
1866 //  . _ _|_ _  _ |` _  _ _  _  .
1867 //  || | | (/_| ~|~(_|(_(/__\  .
1868 //==============================================================================
1869 interface otherFoMo3D {
1870     function potSwap() external payable;
1871 }
1872 
1873 interface F3DexternalSettingsInterface {
1874     function getFastGap() external returns(uint256);
1875     function getLongGap() external returns(uint256);
1876     function getFastExtra() external returns(uint256);
1877     function getLongExtra() external returns(uint256);
1878 }
1879 
1880 interface DiviesInterface {
1881     function deposit() external payable;
1882 }
1883 
1884 interface JIincForwarderInterface {
1885     function deposit() external payable returns(bool);
1886     function status() external view returns(address, address, bool);
1887     function startMigration(address _newCorpBank) external returns(bool);
1888     function cancelMigration() external returns(bool);
1889     function finishMigration() external returns(bool);
1890     function setup(address _firstCorpBank) external;
1891 }
1892 
1893 interface PlayerBookInterface {
1894     function getPlayerID(address _addr) external returns (uint256);
1895     function getPlayerName(uint256 _pID) external view returns (bytes32);
1896     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1897     function getPlayerAddr(uint256 _pID) external view returns (address);
1898     function getNameFee() external view returns (uint256);
1899     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1900     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1901     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1902 }
1903 
1904 /**
1905 * @title -Name Filter- v0.1.9
1906 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1907 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1908 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1909 *                                  _____                      _____
1910 *                                 (, /     /)       /) /)    (, /      /)          /)
1911 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1912 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1913 *          ┴ ┴                /   /          .-/ _____   (__ /
1914 *                            (__ /          (_/ (, /                                      /)™
1915 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1916 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1917 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1918 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1919 *              _       __    _      ____      ____  _   _    _____  ____  ___
1920 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1921 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1922 *
1923 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1924 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1925 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1926 */
1927 
1928 library NameFilter {
1929     /**
1930      * @dev filters name strings
1931      * -converts uppercase to lower case.
1932      * -makes sure it does not start/end with a space
1933      * -makes sure it does not contain multiple spaces in a row
1934      * -cannot be only numbers
1935      * -cannot start with 0x
1936      * -restricts characters to A-Z, a-z, 0-9, and space.
1937      * @return reprocessed string in bytes32 format
1938      */
1939     function nameFilter(string _input)
1940         internal
1941         pure
1942         returns(bytes32)
1943     {
1944         bytes memory _temp = bytes(_input);
1945         uint256 _length = _temp.length;
1946 
1947         //sorry limited to 32 characters
1948         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1949         // make sure it doesnt start with or end with space
1950         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1951         // make sure first two characters are not 0x
1952         if (_temp[0] == 0x30)
1953         {
1954             require(_temp[1] != 0x78, "string cannot start with 0x");
1955             require(_temp[1] != 0x58, "string cannot start with 0X");
1956         }
1957 
1958         // create a bool to track if we have a non number character
1959         bool _hasNonNumber;
1960 
1961         // convert & check
1962         for (uint256 i = 0; i < _length; i++)
1963         {
1964             // if its uppercase A-Z
1965             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1966             {
1967                 // convert to lower case a-z
1968                 _temp[i] = byte(uint(_temp[i]) + 32);
1969 
1970                 // we have a non number
1971                 if (_hasNonNumber == false)
1972                     _hasNonNumber = true;
1973             } else {
1974                 require
1975                 (
1976                     // require character is a space
1977                     _temp[i] == 0x20 ||
1978                     // OR lowercase a-z
1979                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1980                     // or 0-9
1981                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1982                     "string contains invalid characters"
1983                 );
1984                 // make sure theres not 2x spaces in a row
1985                 if (_temp[i] == 0x20)
1986                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1987 
1988                 // see if we have a character other than a number
1989                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1990                     _hasNonNumber = true;
1991             }
1992         }
1993 
1994         require(_hasNonNumber == true, "string cannot be only numbers");
1995 
1996         bytes32 _ret;
1997         assembly {
1998             _ret := mload(add(_temp, 32))
1999         }
2000         return (_ret);
2001     }
2002 }
2003 
2004 /**
2005  * @title SafeMath v0.1.9
2006  * @dev Math operations with safety checks that throw on error
2007  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2008  * - added sqrt
2009  * - added sq
2010  * - added pwr
2011  * - changed asserts to requires with error log outputs
2012  * - removed div, its useless
2013  */
2014 library SafeMath {
2015 
2016     /**
2017     * @dev Multiplies two numbers, throws on overflow.
2018     */
2019     function mul(uint256 a, uint256 b)
2020         internal
2021         pure
2022         returns (uint256 c)
2023     {
2024         if (a == 0) {
2025             return 0;
2026         }
2027         c = a * b;
2028         require(c / a == b, "SafeMath mul failed");
2029         return c;
2030     }
2031 
2032     /**
2033     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2034     */
2035     function sub(uint256 a, uint256 b)
2036         internal
2037         pure
2038         returns (uint256)
2039     {
2040         require(b <= a, "SafeMath sub failed");
2041         return a - b;
2042     }
2043 
2044     /**
2045     * @dev Adds two numbers, throws on overflow.
2046     */
2047     function add(uint256 a, uint256 b)
2048         internal
2049         pure
2050         returns (uint256 c)
2051     {
2052         c = a + b;
2053         require(c >= a, "SafeMath add failed");
2054         return c;
2055     }
2056 
2057     /**
2058      * @dev gives square root of given x.
2059      */
2060     function sqrt(uint256 x)
2061         internal
2062         pure
2063         returns (uint256 y)
2064     {
2065         uint256 z = ((add(x,1)) / 2);
2066         y = x;
2067         while (z < y)
2068         {
2069             y = z;
2070             z = ((add((x / z),z)) / 2);
2071         }
2072     }
2073 
2074     /**
2075      * @dev gives square. multiplies x by x
2076      */
2077     function sq(uint256 x)
2078         internal
2079         pure
2080         returns (uint256)
2081     {
2082         return (mul(x,x));
2083     }
2084 
2085     /**
2086      * @dev x to the power of y
2087      */
2088     function pwr(uint256 x, uint256 y)
2089         internal
2090         pure
2091         returns (uint256)
2092     {
2093         if (x==0)
2094             return (0);
2095         else if (y==0)
2096             return (1);
2097         else
2098         {
2099             uint256 z = x;
2100             for (uint256 i=1; i < y; i++)
2101                 z = mul(z,x);
2102             return (z);
2103         }
2104     }
2105 }