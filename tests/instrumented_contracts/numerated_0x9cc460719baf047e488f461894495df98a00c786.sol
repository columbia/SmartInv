1 pragma solidity ^0.4.24;
2 
3 contract F3Devents {
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
37     // fired whenever theres a withdraw
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
63     // (fomo3d short only) fired whenever a player tries a buy after round timer
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
80     // (fomo3d short only) fired whenever a player tries a reload after round timer
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
114 
115     event onLTestStr
116     (
117         string log
118     );
119 
120     event onLTestAddr
121     (
122         address log
123     );
124 
125     event onLTestInt
126     (
127         uint256 log
128     );
129 }
130 
131 //==============================================================================
132 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
133 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
134 //====================================|=========================================
135 
136 contract modularShort is F3Devents {}
137 
138 contract FoMo100 is modularShort {
139     using SafeMath for *;
140     using NameFilter for string;
141     using F3DKeysCalcShort for uint256;
142 
143     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xa392c209ba2ee375cfed30d5f65663f71005f457);
144 
145     //==============================================================================
146     //     _ _  _  |`. _     _ _ |_ | _  _  .
147     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
148     //=================_|===========================================================
149     // used to start the game
150     address private admin = 0x09cd6157b0585283d9ac1b6d7a6fbbc931b22ebe;
151     // partner account
152     address private p3d_coinbase = 0x09cd6157b0585283d9ac1b6d7a6fbbc931b22ebe;
153     string constant public name = "FoMo100";
154     string constant public symbol = "FoMo100";
155     uint256 private rndExtra_ = 30;     // length of the very first ICO
156     uint256 private rndGap_ = 30;         // length of ICO phase, set to 1 year for EOS.
157     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
158     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
159     uint256 constant private rndMax_ = 24 hours;//6 hours;                // max length a round timer can be
160     //==============================================================================
161     //     _| _ _|_ _    _ _ _|_    _   .
162     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
163     //=============================|================================================
164     bool private openAirDrop = false;
165     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
166     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
167     uint256 public rID_;    // round id number / total rounds that have happened
168     //****************
169     // PLAYER DATA
170     //****************
171     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
172     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
173     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
174     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
175     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
176     //****************
177     // ROUND DATA
178     //****************
179     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
180     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
181     //****************
182     // TEAM FEE DATA
183     //****************
184     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
185     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
186     //==============================================================================
187     //     _ _  _  __|_ _    __|_ _  _  .
188     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
189     //==============================================================================
190     constructor()
191     public
192     {
193         // Team allocation structures
194         // 0 = whales
195         // 1 = bears
196         // 2 = sneks
197         // 3 = bulls
198 
199         // Team allocation percentages
200         // (F3D, P3D) + (Pot , Referrals, Community)
201         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
202         fees_[0] = F3Ddatasets.TeamFee(22,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
203         fees_[1] = F3Ddatasets.TeamFee(38,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
204         fees_[2] = F3Ddatasets.TeamFee(52,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
205         fees_[3] = F3Ddatasets.TeamFee(68,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
206 
207         // how to split up the final pot based on which team was picked
208         // (F3D, P3D)
209         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
210         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
211         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
212         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
213     }
214 
215     //==============================================================================
216     //     _ _  _  _|. |`. _  _ _  .
217     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
218     //==============================================================================
219     /**
220      * @dev used to make sure no one can interact with contract until it has
221      * been activated.
222      */
223     modifier isActivated() {
224         require(activated_ == true, "its not ready yet.  check ?eta in discord");
225         _;
226     }
227 
228     /**
229      * @dev prevents contracts from interacting with fomo3d
230      */
231     modifier isHuman() {
232         address _addr = msg.sender;
233         uint256 _codeLength;
234 
235         assembly {_codeLength := extcodesize(_addr)}
236         require(_codeLength == 0, "sorry humans only");
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
249     //==============================================================================
250     //     _    |_ |. _   |`    _  __|_. _  _  _  .
251     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
252     //====|=========================================================================
253     /**
254      * @dev emergency buy uses last stored affiliate ID and team snek
255      */
256     function()
257     isActivated()
258     isHuman()
259     isWithinLimits(msg.value)
260     public
261     payable
262     {
263         // set up our tx event data and determine if player is new or not
264         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
265 
266         // fetch player id
267         uint256 _pID = pIDxAddr_[msg.sender];
268 
269         // buy core
270         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
271     }
272 
273     /**
274      * @dev converts all incoming ethereum to keys.
275      * -functionhash- 0x8f38f309 (using ID for affiliate)
276      * -functionhash- 0x98a0871d (using address for affiliate)
277      * -functionhash- 0xa65b37a1 (using name for affiliate)
278      * @param _affCode the ID/address/name of the player who gets the affiliate fee
279      * @param _team what team is the player playing for?
280      */
281     function buyXid(uint256 _affCode, uint256 _team)
282     isActivated()
283     isHuman()
284     isWithinLimits(msg.value)
285     public
286     payable
287     {
288         // set up our tx event data and determine if player is new or not
289         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
290         // fetch player id
291         uint256 _pID = pIDxAddr_[msg.sender];
292 
293         // manage affiliate residuals
294         // if no affiliate code was given or player tried to use their own, lolz
295         if (_affCode == 0 || _affCode == _pID)
296         {
297             // use last stored affiliate code
298             _affCode = plyr_[_pID].laff;
299 
300             // if affiliate code was given & its not the same as previously stored
301         } else if (_affCode != plyr_[_pID].laff) {
302             // update last affiliate
303             plyr_[_pID].laff = _affCode;
304         }
305 
306         // verify a valid team was selected
307         _team = verifyTeam(_team);
308 
309         // buy core
310         buyCore(_pID, _affCode, _team, _eventData_);
311     }
312 
313     function buyXaddr(address _affCode, uint256 _team)
314     isActivated()
315     isHuman()
316     isWithinLimits(msg.value)
317     public
318     payable
319     {
320         // set up our tx event data and determine if player is new or not
321         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
322 
323         // fetch player id
324         uint256 _pID = pIDxAddr_[msg.sender];
325 
326         // manage affiliate residuals
327         uint256 _affID;
328         // if no affiliate code was given or player tried to use their own, lolz
329         if (_affCode == address(0) || _affCode == msg.sender)
330         {
331             // use last stored affiliate code
332             _affID = plyr_[_pID].laff;
333 
334             // if affiliate code was given
335         } else {
336             // get affiliate ID from aff Code
337             _affID = pIDxAddr_[_affCode];
338 
339             // if affID is not the same as previously stored
340             if (_affID != plyr_[_pID].laff)
341             {
342                 // update last affiliate
343                 plyr_[_pID].laff = _affID;
344             }
345         }
346 
347         // verify a valid team was selected
348         _team = verifyTeam(_team);
349 
350         // buy core
351         buyCore(_pID, _affID, _team, _eventData_);
352     }
353 
354     function buyXname(bytes32 _affCode, uint256 _team)
355     isActivated()
356     isHuman()
357     isWithinLimits(msg.value)
358     public
359     payable
360     {
361         // set up our tx event data and determine if player is new or not
362         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
363 
364         // fetch player id
365         uint256 _pID = pIDxAddr_[msg.sender];
366 
367         // manage affiliate residuals
368         uint256 _affID;
369         // if no affiliate code was given or player tried to use their own, lolz
370         if (_affCode == '' || _affCode == plyr_[_pID].name)
371         {
372             // use last stored affiliate code
373             _affID = plyr_[_pID].laff;
374 
375             // if affiliate code was given
376         } else {
377             // get affiliate ID from aff Code
378             _affID = pIDxName_[_affCode];
379 
380             // if affID is not the same as previously stored
381             if (_affID != plyr_[_pID].laff)
382             {
383                 // update last affiliate
384                 plyr_[_pID].laff = _affID;
385             }
386         }
387 
388         // verify a valid team was selected
389         _team = verifyTeam(_team);
390 
391         // buy core
392         buyCore(_pID, _affID, _team, _eventData_);
393     }
394 
395     /**
396      * @dev essentially the same as buy, but instead of you sending ether
397      * from your wallet, it uses your unwithdrawn earnings.
398      * -functionhash- 0x349cdcac (using ID for affiliate)
399      * -functionhash- 0x82bfc739 (using address for affiliate)
400      * -functionhash- 0x079ce327 (using name for affiliate)
401      * @param _affCode the ID/address/name of the player who gets the affiliate fee
402      * @param _team what team is the player playing for?
403      * @param _eth amount of earnings to use (remainder returned to gen vault)
404      */
405     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
406     isActivated()
407     isHuman()
408     isWithinLimits(_eth)
409     public
410     {
411         // set up our tx event data
412         F3Ddatasets.EventReturns memory _eventData_;
413 
414         // fetch player ID
415         uint256 _pID = pIDxAddr_[msg.sender];
416 
417         // manage affiliate residuals
418         // if no affiliate code was given or player tried to use their own, lolz
419         if (_affCode == 0 || _affCode == _pID)
420         {
421             // use last stored affiliate code
422             _affCode = plyr_[_pID].laff;
423 
424             // if affiliate code was given & its not the same as previously stored
425         } else if (_affCode != plyr_[_pID].laff) {
426             // update last affiliate
427             plyr_[_pID].laff = _affCode;
428         }
429 
430         // verify a valid team was selected
431         _team = verifyTeam(_team);
432 
433         // reload core
434         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
435     }
436 
437     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
438     isActivated()
439     isHuman()
440     isWithinLimits(_eth)
441     public
442     {
443         // set up our tx event data
444         F3Ddatasets.EventReturns memory _eventData_;
445 
446         // fetch player ID
447         uint256 _pID = pIDxAddr_[msg.sender];
448 
449         // manage affiliate residuals
450         uint256 _affID;
451         // if no affiliate code was given or player tried to use their own, lolz
452         if (_affCode == address(0) || _affCode == msg.sender)
453         {
454             // use last stored affiliate code
455             _affID = plyr_[_pID].laff;
456 
457             // if affiliate code was given
458         } else {
459             // get affiliate ID from aff Code
460             _affID = pIDxAddr_[_affCode];
461 
462             // if affID is not the same as previously stored
463             if (_affID != plyr_[_pID].laff)
464             {
465                 // update last affiliate
466                 plyr_[_pID].laff = _affID;
467             }
468         }
469 
470         // verify a valid team was selected
471         _team = verifyTeam(_team);
472 
473         // reload core
474         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
475     }
476 
477     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
478     isActivated()
479     isHuman()
480     isWithinLimits(_eth)
481     public
482     {
483         // set up our tx event data
484         F3Ddatasets.EventReturns memory _eventData_;
485 
486         // fetch player ID
487         uint256 _pID = pIDxAddr_[msg.sender];
488 
489         // manage affiliate residuals
490         uint256 _affID;
491         // if no affiliate code was given or player tried to use their own, lolz
492         if (_affCode == '' || _affCode == plyr_[_pID].name)
493         {
494             // use last stored affiliate code
495             _affID = plyr_[_pID].laff;
496 
497             // if affiliate code was given
498         } else {
499             // get affiliate ID from aff Code
500             _affID = pIDxName_[_affCode];
501 
502             // if affID is not the same as previously stored
503             if (_affID != plyr_[_pID].laff)
504             {
505                 // update last affiliate
506                 plyr_[_pID].laff = _affID;
507             }
508         }
509 
510         // verify a valid team was selected
511         _team = verifyTeam(_team);
512 
513         // reload core
514         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
515     }
516 
517     /**
518      * @dev withdraws all of your earnings.
519      * -functionhash- 0x3ccfd60b
520      */
521     function withdraw()
522     isActivated()
523     isHuman()
524     public
525     {
526         // setup local rID
527         uint256 _rID = rID_;
528 
529         // grab time
530         uint256 _now = now;
531 
532         // fetch player ID
533         uint256 _pID = pIDxAddr_[msg.sender];
534 
535         // setup temp var for player eth
536         uint256 _eth;
537 
538         // check to see if round has ended and no one has run round end yet
539         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
540         {
541             // set up our tx event data
542             F3Ddatasets.EventReturns memory _eventData_;
543 
544             // end the round (distributes pot)
545             round_[_rID].ended = true;
546             _eventData_ = endRound(_eventData_);
547 
548             // get their earnings
549             _eth = withdrawEarnings(_pID);
550 
551             // gib moni
552             if (_eth > 0)
553                 plyr_[_pID].addr.transfer(_eth);
554 
555             // build event data
556             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
557             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
558 
559             // fire withdraw and distribute event
560             emit F3Devents.onWithdrawAndDistribute
561             (
562                 msg.sender,
563                 plyr_[_pID].name,
564                 _eth,
565                 _eventData_.compressedData,
566                 _eventData_.compressedIDs,
567                 _eventData_.winnerAddr,
568                 _eventData_.winnerName,
569                 _eventData_.amountWon,
570                 _eventData_.newPot,
571                 _eventData_.P3DAmount,
572                 _eventData_.genAmount
573             );
574 
575             // in any other situation
576         } else {
577             // get their earnings
578             _eth = withdrawEarnings(_pID);
579 
580             // gib moni
581             if (_eth > 0)
582                 plyr_[_pID].addr.transfer(_eth);
583 
584             // fire withdraw event
585             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
586         }
587     }
588 
589     /**
590      * @dev use these to register names.  they are just wrappers that will send the
591      * registration requests to the PlayerBook contract.  So registering here is the
592      * same as registering there.  UI will always display the last name you registered.
593      * but you will still own all previously registered names to use as affiliate
594      * links.
595      * - must pay a registration fee.
596      * - name must be unique
597      * - names will be converted to lowercase
598      * - name cannot start or end with a space
599      * - cannot have more than 1 space in a row
600      * - cannot be only numbers
601      * - cannot start with 0x
602      * - name must be at least 1 char
603      * - max length of 32 characters long
604      * - allowed characters: a-z, 0-9, and space
605      * -functionhash- 0x921dec21 (using ID for affiliate)
606      * -functionhash- 0x3ddd4698 (using address for affiliate)
607      * -functionhash- 0x685ffd83 (using name for affiliate)
608      * @param _nameString players desired name
609      * @param _affCode affiliate ID, address, or name of who referred you
610      * @param _all set to true if you want this to push your info to all games
611      * (this might cost a lot of gas)
612      */
613     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
614     isHuman()
615     public
616     payable
617     {
618         bytes32 _name = _nameString.nameFilter();
619         address _addr = msg.sender;
620         uint256 _paid = msg.value;
621         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
622 
623         uint256 _pID = pIDxAddr_[_addr];
624 
625         // fire event
626         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
627     }
628 
629     function registerNameXaddr(string _nameString, address _affCode, bool _all)
630     isHuman()
631     public
632     payable
633     {
634         bytes32 _name = _nameString.nameFilter();
635         address _addr = msg.sender;
636         uint256 _paid = msg.value;
637         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
638 
639         uint256 _pID = pIDxAddr_[_addr];
640 
641         // fire event
642         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
643     }
644 
645     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
646     isHuman()
647     public
648     payable
649     {
650         bytes32 _name = _nameString.nameFilter();
651         address _addr = msg.sender;
652         uint256 _paid = msg.value;
653         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
654 
655         uint256 _pID = pIDxAddr_[_addr];
656 
657         // fire event
658         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
659     }
660     //==============================================================================
661     //     _  _ _|__|_ _  _ _  .
662     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
663     //=====_|=======================================================================
664     /**
665      * @dev return the price buyer will pay for next 1 individual key.
666      * -functionhash- 0x018a25e8
667      * @return price for next key bought (in wei format)
668      */
669     function getBuyPrice()
670     public
671     view
672     returns(uint256)
673     {
674         // setup local rID
675         uint256 _rID = rID_;
676 
677         // grab time
678         uint256 _now = now;
679 
680         // are we in a round?
681         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
682             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
683         else // rounds over.  need price for new round
684             return ( 75000000000000 ); // init
685     }
686 
687     /**
688      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
689      * provider
690      * -functionhash- 0xc7e284b8
691      * @return time left in seconds
692      */
693     function getTimeLeft()
694     public
695     view
696     returns(uint256)
697     {
698         // setup local rID
699         uint256 _rID = rID_;
700 
701         // grab time
702         uint256 _now = now;
703 
704         if (_now < round_[_rID].end)
705             if (_now > round_[_rID].strt + rndGap_)
706                 return( (round_[_rID].end).sub(_now) );
707             else
708                 return( (round_[_rID].strt + rndGap_).sub(_now) );
709         else
710             return(0);
711     }
712 
713     /**
714      * @dev returns player earnings per vaults
715      * -functionhash- 0x63066434
716      * @return winnings vault
717      * @return general vault
718      * @return affiliate vault
719      */
720     function getPlayerVaults(uint256 _pID)
721     public
722     view
723     returns(uint256 ,uint256, uint256)
724     {
725         // setup local rID
726         uint256 _rID = rID_;
727 
728         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
729         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
730         {
731             // if player is winner
732             if (round_[_rID].plyr == _pID)
733             {
734                 return
735                 (
736                 (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
737                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
738                 plyr_[_pID].aff
739                 );
740                 // if player is not the winner
741             } else {
742                 return
743                 (
744                 plyr_[_pID].win,
745                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
746                 plyr_[_pID].aff
747                 );
748             }
749 
750             // if round is still going on, or round has ended and round end has been ran
751         } else {
752             return
753             (
754             plyr_[_pID].win,
755             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
756             plyr_[_pID].aff
757             );
758         }
759     }
760 
761     /**
762      * solidity hates stack limits.  this lets us avoid that hate
763      */
764     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
765     private
766     view
767     returns(uint256)
768     {
769         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
770     }
771 
772     /**
773      * @dev returns all current round info needed for front end
774      * -functionhash- 0x747dff42
775      * @return eth invested during ICO phase
776      * @return round id
777      * @return total keys for round
778      * @return time round ends
779      * @return time round started
780      * @return current pot
781      * @return current team ID & player ID in lead
782      * @return current player in leads address
783      * @return current player in leads name
784      * @return whales eth in for round
785      * @return bears eth in for round
786      * @return sneks eth in for round
787      * @return bulls eth in for round
788      * @return airdrop tracker # & airdrop pot
789      */
790     function getCurrentRoundInfo()
791     public
792     view
793     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
794     {
795         // setup local rID
796         uint256 _rID = rID_;
797 
798         return
799         (
800         round_[_rID].ico,               //0
801         _rID,                           //1
802         round_[_rID].keys,              //2
803         round_[_rID].end,               //3
804         round_[_rID].strt,              //4
805         round_[_rID].pot,               //5
806         (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
807         plyr_[round_[_rID].plyr].addr,  //7
808         plyr_[round_[_rID].plyr].name,  //8
809         rndTmEth_[_rID][0],             //9
810         rndTmEth_[_rID][1],             //10
811         rndTmEth_[_rID][2],             //11
812         rndTmEth_[_rID][3],             //12
813         airDropTracker_ + (airDropPot_ * 1000)              //13
814         );
815     }
816 
817     /**
818      * @dev returns player info based on address.  if no address is given, it will
819      * use msg.sender
820      * -functionhash- 0xee0b5d8b
821      * @param _addr address of the player you want to lookup
822      * @return player ID
823      * @return player name
824      * @return keys owned (current round)
825      * @return winnings vault
826      * @return general vault
827      * @return affiliate vault
828 	 * @return player round eth
829      */
830     function getPlayerInfoByAddress(address _addr)
831     public
832     view
833     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
834     {
835         // setup local rID
836         uint256 _rID = rID_;
837 
838         if (_addr == address(0))
839         {
840             _addr == msg.sender;
841         }
842         uint256 _pID = pIDxAddr_[_addr];
843 
844         return
845         (
846         _pID,                               //0
847         plyr_[_pID].name,                   //1
848         plyrRnds_[_pID][_rID].keys,         //2
849         plyr_[_pID].win,                    //3
850         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
851         plyr_[_pID].aff,                    //5
852         plyrRnds_[_pID][_rID].eth           //6
853         );
854     }
855 
856     //==============================================================================
857     //     _ _  _ _   | _  _ . _  .
858     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
859     //=====================_|=======================================================
860     /**
861      * @dev logic runs whenever a buy order is executed.  determines how to handle
862      * incoming eth depending on if we are in an active round or not
863      */
864     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
865     private
866     {
867         // setup local rID
868         uint256 _rID = rID_;
869 
870         // grab time
871         uint256 _now = now;
872 
873         // if round is active
874         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
875         {
876             emit onLTestStr("not end");
877             emit onLTestInt(_pID);
878             emit onLTestInt(_team);
879             // call core
880             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
881 
882             // if round is not active
883         } else {
884             emit onLTestStr("has end");
885             emit onLTestInt(_pID);
886             emit onLTestInt(_team);
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
925     private
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
944             // if round is not active and end round needs to be ran
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
976     private
977     {
978         // if player is new to round
979         if (plyrRnds_[_pID][_rID].keys == 0)
980             _eventData_ = managePlayer(_pID, _eventData_);
981 
982         // early round eth limiter
983         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
984         {
985             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
986             uint256 _refund = _eth.sub(_availableLimit);
987             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
988             _eth = _availableLimit;
989         }
990 
991         // if eth left is greater than min eth allowed (sorry no pocket lint)
992         if (_eth > 1000000000)
993         {
994 
995             // mint the new keys
996             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
997 
998             // if they bought at least 1 whole key
999             if (_keys >= 1000000000000000000)
1000             {
1001                 updateTimer(_keys, _rID);
1002 
1003                 // set new leaders
1004                 if (round_[_rID].plyr != _pID)
1005                     round_[_rID].plyr = _pID;
1006                 if (round_[_rID].team != _team)
1007                     round_[_rID].team = _team;
1008 
1009                 // set the new leader bool to true
1010                 _eventData_.compressedData = _eventData_.compressedData + 100;
1011             }
1012 
1013             // manage airdrops
1014             if (openAirDrop == true && _eth >= 100000000000000000)
1015             {
1016                 airDropTracker_++;
1017                 if (airdrop() == true)
1018                 {
1019                     // gib muni
1020                     uint256 _prize;
1021                     if (_eth >= 10000000000000000000)
1022                     {
1023                         // calculate prize and give it to winner
1024                         _prize = ((airDropPot_).mul(75)) / 100;
1025                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1026 
1027                         // adjust airDropPot
1028                         airDropPot_ = (airDropPot_).sub(_prize);
1029 
1030                         // let event know a tier 3 prize was won
1031                         _eventData_.compressedData += 300000000000000000000000000000000;
1032                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1033                         // calculate prize and give it to winner
1034                         _prize = ((airDropPot_).mul(50)) / 100;
1035                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1036 
1037                         // adjust airDropPot
1038                         airDropPot_ = (airDropPot_).sub(_prize);
1039 
1040                         // let event know a tier 2 prize was won
1041                         _eventData_.compressedData += 200000000000000000000000000000000;
1042                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1043                         // calculate prize and give it to winner
1044                         _prize = ((airDropPot_).mul(25)) / 100;
1045                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1046 
1047                         // adjust airDropPot
1048                         airDropPot_ = (airDropPot_).sub(_prize);
1049 
1050                         // let event know a tier 3 prize was won
1051                         _eventData_.compressedData += 300000000000000000000000000000000;
1052                     }
1053                     // set airdrop happened bool to true
1054                     _eventData_.compressedData += 10000000000000000000000000000000;
1055                     // let event know how much was won
1056                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1057 
1058                     // reset air drop tracker
1059                     airDropTracker_ = 0;
1060                 }
1061             }
1062 
1063             // store the air drop tracker number (number of buys since last airdrop)
1064             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1065 
1066             // update player
1067             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1068             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1069 
1070             // update round
1071             round_[_rID].keys = _keys.add(round_[_rID].keys);
1072             round_[_rID].eth = _eth.add(round_[_rID].eth);
1073             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1074 
1075             // distribute eth
1076             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1077             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1078 
1079             // call end tx function to fire end tx event.
1080             endTx(_pID, _team, _eth, _keys, _eventData_);
1081         }
1082     }
1083     //==============================================================================
1084     //     _ _ | _   | _ _|_ _  _ _  .
1085     //    (_(_||(_|_||(_| | (_)| _\  .
1086     //==============================================================================
1087     /**
1088      * @dev calculates unmasked earnings (just calculates, does not update mask)
1089      * @return earnings in wei format
1090      */
1091     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1092     private
1093     view
1094     returns(uint256)
1095     {
1096         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1097     }
1098 
1099     /**
1100      * @dev returns the amount of keys you would get given an amount of eth.
1101      * -functionhash- 0xce89c80c
1102      * @param _rID round ID you want price for
1103      * @param _eth amount of eth sent in
1104      * @return keys received
1105      */
1106     function calcKeysReceived(uint256 _rID, uint256 _eth)
1107     public
1108     view
1109     returns(uint256)
1110     {
1111         // grab time
1112         uint256 _now = now;
1113 
1114         // are we in a round?
1115         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1116             return ( (round_[_rID].eth).keysRec(_eth) );
1117         else // rounds over.  need keys for new round
1118             return ( (_eth).keys() );
1119     }
1120 
1121     /**
1122      * @dev returns current eth price for X keys.
1123      * -functionhash- 0xcf808000
1124      * @param _keys number of keys desired (in 18 decimal format)
1125      * @return amount of eth needed to send
1126      */
1127     function iWantXKeys(uint256 _keys)
1128     public
1129     view
1130     returns(uint256)
1131     {
1132         // setup local rID
1133         uint256 _rID = rID_;
1134 
1135         // grab time
1136         uint256 _now = now;
1137 
1138         // are we in a round?
1139         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1140             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1141         else // rounds over.  need price for new round
1142             return ( (_keys).eth() );
1143     }
1144     //==============================================================================
1145     //    _|_ _  _ | _  .
1146     //     | (_)(_)|_\  .
1147     //==============================================================================
1148     /**
1149 	 * @dev receives name/player info from names contract
1150      */
1151     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1152     external
1153     {
1154         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1155         if (pIDxAddr_[_addr] != _pID)
1156             pIDxAddr_[_addr] = _pID;
1157         if (pIDxName_[_name] != _pID)
1158             pIDxName_[_name] = _pID;
1159         if (plyr_[_pID].addr != _addr)
1160             plyr_[_pID].addr = _addr;
1161         if (plyr_[_pID].name != _name)
1162             plyr_[_pID].name = _name;
1163         if (plyr_[_pID].laff != _laff)
1164             plyr_[_pID].laff = _laff;
1165         if (plyrNames_[_pID][_name] == false)
1166             plyrNames_[_pID][_name] = true;
1167     }
1168 
1169     /**
1170      * @dev receives entire player name list
1171      */
1172     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1173     external
1174     {
1175         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1176         if(plyrNames_[_pID][_name] == false)
1177             plyrNames_[_pID][_name] = true;
1178     }
1179 
1180     /**
1181      * @dev gets existing or registers new pID.  use this when a player may be new
1182      * @return pID
1183      */
1184     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1185     private
1186     returns (F3Ddatasets.EventReturns)
1187     {
1188         uint256 _pID = pIDxAddr_[msg.sender];
1189         // if player is new to this version of fomo3d
1190         if (_pID == 0)
1191         {
1192             // grab their player ID, name and last aff ID, from player names contract
1193 //            emit onLTestAddr(msg.sender);
1194             _pID = PlayerBook.getPlayerID(msg.sender);
1195 //            emit onLTestInt(_pID);
1196             bytes32 _name = PlayerBook.getPlayerName(_pID);
1197             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1198 
1199             // set up player account
1200             pIDxAddr_[msg.sender] = _pID;
1201             plyr_[_pID].addr = msg.sender;
1202 
1203             if (_name != "")
1204             {
1205                 pIDxName_[_name] = _pID;
1206                 plyr_[_pID].name = _name;
1207                 plyrNames_[_pID][_name] = true;
1208             }
1209 
1210             if (_laff != 0 && _laff != _pID)
1211                 plyr_[_pID].laff = _laff;
1212 
1213             // set the new player bool to true
1214             _eventData_.compressedData = _eventData_.compressedData + 1;
1215         }
1216         return (_eventData_);
1217     }
1218 
1219     /**
1220      * @dev checks to make sure user picked a valid team.  if not sets team
1221      * to default (sneks)
1222      */
1223     function verifyTeam(uint256 _team)
1224     private
1225     pure
1226     returns (uint256)
1227     {
1228         if (_team < 0 || _team > 3)
1229             return(2);
1230         else
1231             return(_team);
1232     }
1233 
1234     /**
1235      * @dev decides if round end needs to be run & new round started.  and if
1236      * player unmasked earnings from previously played rounds need to be moved.
1237      */
1238     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1239     private
1240     returns (F3Ddatasets.EventReturns)
1241     {
1242         // if player has played a previous round, move their unmasked earnings
1243         // from that round to gen vault.
1244         if (plyr_[_pID].lrnd != 0)
1245             updateGenVault(_pID, plyr_[_pID].lrnd);
1246 
1247         // update player's last round played
1248         plyr_[_pID].lrnd = rID_;
1249 
1250         // set the joined round bool to true
1251         _eventData_.compressedData = _eventData_.compressedData + 10;
1252 
1253         return(_eventData_);
1254     }
1255 
1256     /**
1257      * @dev ends the round. manages paying out winner/splitting up pot
1258      */
1259     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1260     private
1261     returns (F3Ddatasets.EventReturns)
1262     {
1263         // setup local rID
1264         uint256 _rID = rID_;
1265 
1266         // grab our winning player and team id's
1267         uint256 _winPID = round_[_rID].plyr;
1268         uint256 _winTID = round_[_rID].team;
1269 
1270         // grab our pot amount
1271         uint256 _pot = round_[_rID].pot;
1272 
1273         // calculate our winner share, community rewards, gen share,
1274         // p3d share, and amount reserved for next pot
1275         uint256 _win = (_pot.mul(48)) / 100;
1276         uint256 _com = (_pot / 50);
1277         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1278         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1279         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1280 
1281         // calculate ppt for round mask
1282         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1283         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1284         if (_dust > 0)
1285         {
1286             _gen = _gen.sub(_dust);
1287             _res = _res.add(_dust);
1288         }
1289 
1290         // pay our winner
1291         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1292 
1293         // community rewards
1294         _com = _com.add(_p3d.sub(_p3d / 2));
1295         p3d_coinbase.transfer(_com);
1296 
1297         _res = _res.add(_p3d / 2);
1298 
1299         // distribute gen portion to key holders
1300         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1301 
1302         // prepare event data
1303         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1304         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1305         _eventData_.winnerAddr = plyr_[_winPID].addr;
1306         _eventData_.winnerName = plyr_[_winPID].name;
1307         _eventData_.amountWon = _win;
1308         _eventData_.genAmount = _gen;
1309         _eventData_.P3DAmount = _p3d;
1310         _eventData_.newPot = _res;
1311 
1312         // start next round
1313         rID_++;
1314         _rID++;
1315         round_[_rID].strt = now;
1316         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1317         round_[_rID].pot = _res;
1318 
1319         return(_eventData_);
1320     }
1321 
1322     /**
1323      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1324      */
1325     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1326     private
1327     {
1328         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1329         if (_earnings > 0)
1330         {
1331             // put in gen vault
1332             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1333             // zero out their earnings by updating mask
1334             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1335         }
1336     }
1337 
1338     /**
1339      * @dev updates round timer based on number of whole keys bought.
1340      */
1341     function updateTimer(uint256 _keys, uint256 _rID)
1342     private
1343     {
1344         // grab time
1345         uint256 _now = now;
1346 
1347         // calculate time based on number of keys bought
1348         uint256 _newTime;
1349         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1350             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1351         else
1352             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1353 
1354         // compare to max and set new end time
1355         if (_newTime < (rndMax_).add(_now))
1356             round_[_rID].end = _newTime;
1357         else
1358             round_[_rID].end = rndMax_.add(_now);
1359     }
1360 
1361     /**
1362      * @dev generates a random number between 0-99 and checks to see if thats
1363      * resulted in an airdrop win
1364      * @return do we have a winner?
1365      */
1366     function airdrop()
1367     private
1368     view
1369     returns(bool)
1370     {
1371         uint256 seed = uint256(keccak256(abi.encodePacked(
1372 
1373                 (block.timestamp).add
1374                 (block.difficulty).add
1375                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1376                 (block.gaslimit).add
1377                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1378                 (block.number)
1379 
1380             )));
1381         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1382             return(true);
1383         else
1384             return(false);
1385     }
1386 
1387     /**
1388      * @dev distributes eth based on fees to com, aff, and p3d
1389      */
1390     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1391     private
1392     returns(F3Ddatasets.EventReturns)
1393     {
1394         // pay 3% out to community rewards
1395         uint256 _p1 = _eth / 100;
1396         uint256 _com = _eth / 50;
1397         _com = _com.add(_p1);
1398 
1399         uint256 _p3d;
1400         if (!address(p3d_coinbase).call.value(_com)())
1401         {
1402             // This ensures Team Just cannot influence the outcome of FoMo3D with
1403             // bank migrations by breaking outgoing transactions.
1404             // Something we would never do. But that's not the point.
1405             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1406             // highest belief that everything we create should be trustless.
1407             // Team JUST, The name you shouldn't have to trust.
1408             _p3d = _com;
1409             _com = 0;
1410         }
1411 
1412 
1413         // distribute share to affiliate
1414         uint256 _aff = _eth / 10;
1415 
1416         // decide what to do with affiliate share of fees
1417         // affiliate must not be self, and must have a name registered
1418         if (_affID != _pID && plyr_[_affID].name != '') {
1419             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1420             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1421         } else {
1422             _p3d = _p3d.add(_aff);
1423         }
1424 
1425         // pay out p3d
1426         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1427         if (_p3d > 0)
1428         {
1429             // deposit to divies contract
1430             uint256 _potAmount = _p3d / 2;
1431 
1432             p3d_coinbase.transfer(_p3d.sub(_potAmount));
1433 
1434             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1435 
1436             // set up event data
1437             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1438         }
1439 
1440         return(_eventData_);
1441     }
1442 
1443     function potSwap()
1444     external
1445     payable
1446     {
1447         // setup local rID
1448         uint256 _rID = rID_ + 1;
1449 
1450         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1451         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1452     }
1453 
1454     /**
1455      * @dev distributes eth based on fees to gen and pot
1456      */
1457     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1458     private
1459     returns(F3Ddatasets.EventReturns)
1460     {
1461         // calculate gen share
1462         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1463 
1464         if (openAirDrop == true) {
1465             // toss 1% into airdrop pot
1466             uint256 _air = (_eth / 100);
1467             airDropPot_ = airDropPot_.add(_air);
1468         }
1469 
1470         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1471         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1472 
1473         // calculate pot
1474         uint256 _pot = _eth.sub(_gen);
1475 
1476         // distribute gen share (thats what updateMasks() does) and adjust
1477         // balances for dust.
1478         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1479         if (_dust > 0)
1480             _gen = _gen.sub(_dust);
1481 
1482         // add eth to pot
1483         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1484 
1485         // set up event data
1486         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1487         _eventData_.potAmount = _pot;
1488 
1489         return(_eventData_);
1490     }
1491 
1492     /**
1493      * @dev updates masks for round and player when keys are bought
1494      * @return dust left over
1495      */
1496     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1497     private
1498     returns(uint256)
1499     {
1500         /* MASKING NOTES
1501             earnings masks are a tricky thing for people to wrap their minds around.
1502             the basic thing to understand here.  is were going to have a global
1503             tracker based on profit per share for each round, that increases in
1504             relevant proportion to the increase in share supply.
1505 
1506             the player will have an additional mask that basically says "based
1507             on the rounds mask, my shares, and how much i've already withdrawn,
1508             how much is still owed to me?"
1509         */
1510 
1511         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1512         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1513         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1514 
1515         // calculate player earning from their own buy (only based on the keys
1516         // they just bought).  & update player earnings mask
1517         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1518         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1519 
1520         // calculate & return dust
1521         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1522     }
1523 
1524     /**
1525      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1526      * @return earnings in wei format
1527      */
1528     function withdrawEarnings(uint256 _pID)
1529     private
1530     returns(uint256)
1531     {
1532         // update gen vault
1533         updateGenVault(_pID, plyr_[_pID].lrnd);
1534 
1535         // from vaults
1536         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1537         if (_earnings > 0)
1538         {
1539             plyr_[_pID].win = 0;
1540             plyr_[_pID].gen = 0;
1541             plyr_[_pID].aff = 0;
1542         }
1543 
1544         return(_earnings);
1545     }
1546 
1547     /**
1548      * @dev prepares compression data and fires event for buy or reload tx's
1549      */
1550     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1551     private
1552     {
1553         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1554         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1555 
1556         emit F3Devents.onEndTx
1557         (
1558             _eventData_.compressedData,
1559             _eventData_.compressedIDs,
1560             plyr_[_pID].name,
1561             msg.sender,
1562             _eth,
1563             _keys,
1564             _eventData_.winnerAddr,
1565             _eventData_.winnerName,
1566             _eventData_.amountWon,
1567             _eventData_.newPot,
1568             _eventData_.P3DAmount,
1569             _eventData_.genAmount,
1570             _eventData_.potAmount,
1571             airDropPot_
1572         );
1573     }
1574     //==============================================================================
1575     //    (~ _  _    _._|_    .
1576     //    _)(/_(_|_|| | | \/  .
1577     //====================/=========================================================
1578     /** upon contract deploy, it will be deactivated.  this is a one time
1579      * use function that will activate the contract.  we do this so devs
1580      * have time to set things up on the web end                            **/
1581     bool public activated_ = false;
1582     function activate()
1583     public
1584     returns(bool)
1585     {
1586         // only team just can activate
1587         require(msg.sender == admin, "only admin can activate");
1588 
1589 
1590         // can only be ran once
1591         require(activated_ == false, "FOMO Short already activated");
1592 
1593         // activate the contract
1594         activated_ = true;
1595 
1596         // lets start first round
1597         rID_ = 1;
1598         round_[1].strt = now + rndExtra_ - rndGap_;
1599         round_[1].end = now + rndInit_ + rndExtra_;
1600         return activated_;
1601     }
1602 }
1603 
1604 //==============================================================================
1605 //   __|_ _    __|_ _  .
1606 //  _\ | | |_|(_ | _\  .
1607 //==============================================================================
1608 library F3Ddatasets {
1609     //compressedData key
1610     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1611     // 0 - new player (bool)
1612     // 1 - joined round (bool)
1613     // 2 - new  leader (bool)
1614     // 3-5 - air drop tracker (uint 0-999)
1615     // 6-16 - round end time
1616     // 17 - winnerTeam
1617     // 18 - 28 timestamp
1618     // 29 - team
1619     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1620     // 31 - airdrop happened bool
1621     // 32 - airdrop tier
1622     // 33 - airdrop amount won
1623     //compressedIDs key
1624     // [77-52][51-26][25-0]
1625     // 0-25 - pID
1626     // 26-51 - winPID
1627     // 52-77 - rID
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
1653     }
1654     struct Round {
1655         uint256 plyr;   // pID of player in lead
1656         uint256 team;   // tID of team in lead
1657         uint256 end;    // time ends/ended
1658         bool ended;     // has round end function been ran
1659         uint256 strt;   // time round started
1660         uint256 keys;   // keys
1661         uint256 eth;    // total eth in
1662         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1663         uint256 mask;   // global mask
1664         uint256 ico;    // total eth sent in during ICO phase
1665         uint256 icoGen; // total eth for gen during ICO phase
1666         uint256 icoAvg; // average key price for ICO phase
1667     }
1668     struct TeamFee {
1669         uint256 gen;    // % of buy in thats paid to key holders of current round
1670         uint256 p3d;    // % of buy in thats paid to p3d holders
1671     }
1672     struct PotSplit {
1673         uint256 gen;    // % of pot thats paid to key holders of current round
1674         uint256 p3d;    // % of pot thats paid to p3d holders
1675     }
1676 }
1677 
1678 //==============================================================================
1679 //  |  _      _ _ | _  .
1680 //  |<(/_\/  (_(_||(_  .
1681 //=======/======================================================================
1682 library F3DKeysCalcShort {
1683     using SafeMath for *;
1684     /**
1685      * @dev calculates number of keys received given X eth
1686      * @param _curEth current amount of eth in contract
1687      * @param _newEth eth being spent
1688      * @return amount of ticket purchased
1689      */
1690     function keysRec(uint256 _curEth, uint256 _newEth)
1691     internal
1692     pure
1693     returns (uint256)
1694     {
1695         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1696     }
1697 
1698     /**
1699      * @dev calculates amount of eth received if you sold X keys
1700      * @param _curKeys current amount of keys that exist
1701      * @param _sellKeys amount of keys you wish to sell
1702      * @return amount of eth received
1703      */
1704     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1705     internal
1706     pure
1707     returns (uint256)
1708     {
1709         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1710     }
1711 
1712     /**
1713      * @dev calculates how many keys would exist with given an amount of eth
1714      * @param _eth eth "in contract"
1715      * @return number of keys that would exist
1716      */
1717     function keys(uint256 _eth)
1718     internal
1719     pure
1720     returns(uint256)
1721     {
1722         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1723     }
1724 
1725     /**
1726      * @dev calculates how much eth would be in contract given a number of keys
1727      * @param _keys number of keys "in contract"
1728      * @return eth that would exists
1729      */
1730     function eth(uint256 _keys)
1731     internal
1732     pure
1733     returns(uint256)
1734     {
1735         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1736     }
1737 }
1738 
1739 //==============================================================================
1740 //  . _ _|_ _  _ |` _  _ _  _  .
1741 //  || | | (/_| ~|~(_|(_(/__\  .
1742 //==============================================================================
1743 
1744 interface PlayerBookInterface {
1745     function getPlayerID(address _addr) external returns (uint256);
1746     function getPlayerName(uint256 _pID) external view returns (bytes32);
1747     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1748     function getPlayerAddr(uint256 _pID) external view returns (address);
1749     function getNameFee() external view returns (uint256);
1750     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1751     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1752     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1753 }
1754 
1755 /**
1756 * @title -Name Filter- v0.1.9
1757 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1758 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1759 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1760 *                                  _____                      _____
1761 *                                 (, /     /)       /) /)    (, /      /)          /)
1762 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1763 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1764 *          ┴ ┴                /   /          .-/ _____   (__ /
1765 *                            (__ /          (_/ (, /                                      /)™
1766 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1767 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1768 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1769 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1770 *              _       __    _      ____      ____  _   _    _____  ____  ___
1771 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1772 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1773 *
1774 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1775 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1776 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1777 */
1778 
1779 library NameFilter {
1780     /**
1781      * @dev filters name strings
1782      * -converts uppercase to lower case.
1783      * -makes sure it does not start/end with a space
1784      * -makes sure it does not contain multiple spaces in a row
1785      * -cannot be only numbers
1786      * -cannot start with 0x
1787      * -restricts characters to A-Z, a-z, 0-9, and space.
1788      * @return reprocessed string in bytes32 format
1789      */
1790     function nameFilter(string _input)
1791     internal
1792     pure
1793     returns(bytes32)
1794     {
1795         bytes memory _temp = bytes(_input);
1796         uint256 _length = _temp.length;
1797 
1798         //sorry limited to 32 characters
1799         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1800         // make sure it doesnt start with or end with space
1801         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1802         // make sure first two characters are not 0x
1803         if (_temp[0] == 0x30)
1804         {
1805             require(_temp[1] != 0x78, "string cannot start with 0x");
1806             require(_temp[1] != 0x58, "string cannot start with 0X");
1807         }
1808 
1809         // create a bool to track if we have a non number character
1810         bool _hasNonNumber;
1811 
1812         // convert & check
1813         for (uint256 i = 0; i < _length; i++)
1814         {
1815             // if its uppercase A-Z
1816             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1817             {
1818                 // convert to lower case a-z
1819                 _temp[i] = byte(uint(_temp[i]) + 32);
1820 
1821                 // we have a non number
1822                 if (_hasNonNumber == false)
1823                     _hasNonNumber = true;
1824             } else {
1825                 require
1826                 (
1827                 // require character is a space
1828                     _temp[i] == 0x20 ||
1829                 // OR lowercase a-z
1830                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1831                 // or 0-9
1832                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1833                     "string contains invalid characters"
1834                 );
1835                 // make sure theres not 2x spaces in a row
1836                 if (_temp[i] == 0x20)
1837                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1838 
1839                 // see if we have a character other than a number
1840                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1841                     _hasNonNumber = true;
1842             }
1843         }
1844 
1845         require(_hasNonNumber == true, "string cannot be only numbers");
1846 
1847         bytes32 _ret;
1848         assembly {
1849             _ret := mload(add(_temp, 32))
1850         }
1851         return (_ret);
1852     }
1853 }
1854 
1855 /**
1856  * @title SafeMath v0.1.9
1857  * @dev Math operations with safety checks that throw on error
1858  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1859  * - added sqrt
1860  * - added sq
1861  * - added pwr
1862  * - changed asserts to requires with error log outputs
1863  * - removed div, its useless
1864  */
1865 library SafeMath {
1866 
1867     /**
1868     * @dev Multiplies two numbers, throws on overflow.
1869     */
1870     function mul(uint256 a, uint256 b)
1871     internal
1872     pure
1873     returns (uint256 c)
1874     {
1875         if (a == 0) {
1876             return 0;
1877         }
1878         c = a * b;
1879         require(c / a == b, "SafeMath mul failed");
1880         return c;
1881     }
1882 
1883     /**
1884     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1885     */
1886     function sub(uint256 a, uint256 b)
1887     internal
1888     pure
1889     returns (uint256)
1890     {
1891         require(b <= a, "SafeMath sub failed");
1892         return a - b;
1893     }
1894 
1895     /**
1896     * @dev Adds two numbers, throws on overflow.
1897     */
1898     function add(uint256 a, uint256 b)
1899     internal
1900     pure
1901     returns (uint256 c)
1902     {
1903         c = a + b;
1904         require(c >= a, "SafeMath add failed");
1905         return c;
1906     }
1907 
1908     /**
1909      * @dev gives square root of given x.
1910      */
1911     function sqrt(uint256 x)
1912     internal
1913     pure
1914     returns (uint256 y)
1915     {
1916         uint256 z = ((add(x,1)) / 2);
1917         y = x;
1918         while (z < y)
1919         {
1920             y = z;
1921             z = ((add((x / z),z)) / 2);
1922         }
1923     }
1924 
1925     /**
1926      * @dev gives square. multiplies x by x
1927      */
1928     function sq(uint256 x)
1929     internal
1930     pure
1931     returns (uint256)
1932     {
1933         return (mul(x,x));
1934     }
1935 
1936     /**
1937      * @dev x to the power of y
1938      */
1939     function pwr(uint256 x, uint256 y)
1940     internal
1941     pure
1942     returns (uint256)
1943     {
1944         if (x==0)
1945             return (0);
1946         else if (y==0)
1947             return (1);
1948         else
1949         {
1950             uint256 z = x;
1951             for (uint256 i=1; i < y; i++)
1952                 z = mul(z,x);
1953             return (z);
1954         }
1955     }
1956 }