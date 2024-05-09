1 pragma solidity ^0.4.24;
2 
3 /*--------------------------------------------------
4  ____                           ____              _ 
5 / ___| _   _ _ __   ___ _ __   / ___|__ _ _ __ __| |
6 \___ \| | | | '_ \ / _ \ '__| | |   / _` | '__/ _` |
7  ___) | |_| | |_) |  __/ |    | |__| (_| | | | (_| |
8 |____/ \__,_| .__/ \___|_|     \____\__,_|_|  \__,_|
9             |_|                                   
10 
11                                     2018-08-08 V0.8
12 ---------------------------------------------------*/
13 
14 contract SPCevents {
15     // fired whenever a player registers a name
16     event onNewName
17     (
18         uint256 indexed playerID,
19         address indexed playerAddress,
20         bytes32 indexed playerName,
21         bool isNewPlayer,
22         uint256 affiliateID,
23         address affiliateAddress,
24         bytes32 affiliateName,
25         uint256 amountPaid,
26         uint256 timeStamp
27     );
28 
29     // fired at end of buy or reload
30     event onEndTx
31     (
32         uint256 compressedData,
33         uint256 compressedIDs,
34         bytes32 playerName,
35         address playerAddress,
36         uint256 ethIn,
37         uint256 keysBought,
38         address winnerAddr,
39         bytes32 winnerName,
40         uint256 amountWon,
41         uint256 newPot,
42         uint256 P3DAmount,
43         uint256 genAmount,
44         uint256 potAmount,
45         uint256 airDropPot
46     );
47 
48   // fired whenever theres a withdraw
49     event onWithdraw
50     (
51         uint256 indexed playerID,
52         address playerAddress,
53         bytes32 playerName,
54         uint256 ethOut,
55         uint256 timeStamp
56     );
57 
58     // fired whenever a withdraw forces end round to be ran
59     event onWithdrawAndDistribute
60     (
61         address playerAddress,
62         bytes32 playerName,
63         uint256 ethOut,
64         uint256 compressedData,
65         uint256 compressedIDs,
66         address winnerAddr,
67         bytes32 winnerName,
68         uint256 amountWon,
69         uint256 newPot,
70         uint256 P3DAmount,
71         uint256 genAmount
72     );
73 
74     // fired whenever a player tries a buy after round timer
75     // hit zero, and causes end round to be ran.
76     event onBuyAndDistribute
77     (
78         address playerAddress,
79         bytes32 playerName,
80         uint256 ethIn,
81         uint256 compressedData,
82         uint256 compressedIDs,
83         address winnerAddr,
84         bytes32 winnerName,
85         uint256 amountWon,
86         uint256 newPot,
87         uint256 P3DAmount,
88         uint256 genAmount
89     );
90 
91     // fired whenever a player tries a reload after round timer
92     // hit zero, and causes end round to be ran.
93     event onReLoadAndDistribute
94     (
95         address playerAddress,
96         bytes32 playerName,
97         uint256 compressedData,
98         uint256 compressedIDs,
99         address winnerAddr,
100         bytes32 winnerName,
101         uint256 amountWon,
102         uint256 newPot,
103         uint256 P3DAmount,
104         uint256 genAmount
105     );
106 
107     // fired whenever an affiliate is paid
108     event onAffiliatePayout
109     (
110         uint256 indexed affiliateID,
111         address affiliateAddress,
112         bytes32 affiliateName,
113         uint256 indexed roundID,
114         uint256 indexed buyerID,
115         uint256 amount,
116         uint256 timeStamp
117     );
118 
119     // received pot swap deposit, add pot directly by admin to next round
120     event onPotSwapDeposit
121     (
122         uint256 roundID,
123         uint256 amountAddedToPot
124     );
125 }
126 
127 //==============================================================================
128 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
129 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
130 //====================================|=========================================
131 
132 contract SuperCard is SPCevents {
133     using SafeMath for *;
134     using NameFilter for string;
135 
136     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xbac825cdb506dcf917a7715a4bf3fa1b06abe3e4);
137 
138 //==============================================================================
139 //     _ _  _  |`. _     _ _ |_ | _  _  .
140 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
141 //=================_|===========================================================
142     address private admin = msg.sender;
143     string constant public name   = "SuperCard";
144     string constant public symbol = "SPC";
145     uint256 private rndExtra_     = 0;     // length of the very first ICO
146     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
147     uint256 constant private rndInit_ = 6 hours;           // round timer starts at this
148     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
149     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
150 //==============================================================================
151 //     _| _ _|_ _    _ _ _|_    _   .
152 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
153 //=============================|================================================
154     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
155     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
156     uint256 public rID_;    // last rID
157     uint256 public pID_;    // last pID 
158 //****************
159 // PLAYER DATA
160 //****************
161     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
162     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
163     mapping (uint256 => SPCdatasets.Player) public plyr_;   // (pID => data) player data
164     mapping (uint256 => mapping (uint256 => SPCdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
165     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
166 //****************
167 // ROUND DATA
168 //****************
169     mapping (uint256 => SPCdatasets.Round) public round_;   // (rID => data) round data
170     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
171 
172     mapping (uint256 => uint256) public attend;   // (index => pID) player ID attend current round
173 //****************
174 // TEAM FEE DATA
175 //****************
176     mapping (uint256 => SPCdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
177     mapping (uint256 => SPCdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
178 //==============================================================================
179 //     _ _  _  __|_ _    __|_ _  _  .
180 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
181 //==============================================================================
182     constructor()
183         public
184     {
185         fees_[0] = SPCdatasets.TeamFee(80,2);
186         fees_[1] = SPCdatasets.TeamFee(80,2);
187         fees_[2] = SPCdatasets.TeamFee(80,2);
188         fees_[3] = SPCdatasets.TeamFee(80,2);
189 
190         // how to split up the final pot based on which team was picked
191         potSplit_[0] = SPCdatasets.PotSplit(20,10);
192         potSplit_[1] = SPCdatasets.PotSplit(20,10);
193         potSplit_[2] = SPCdatasets.PotSplit(20,10);
194         potSplit_[3] = SPCdatasets.PotSplit(20,10);
195 
196     /*
197         activated_ = true;
198 
199         // lets start first round
200         rID_ = 1;
201         round_[1].strt = now + rndExtra_ - rndGap_;
202         round_[1].end = now + rndInit_ + rndExtra_;
203     */
204   }
205 //==============================================================================
206 //     _ _  _  _|. |`. _  _ _  .
207 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
208 //==============================================================================
209     /**
210      * @dev used to make sure no one can interact with contract until it has
211      * been activated.
212      */
213   modifier isActivated() {
214         if ( activated_ == false ){
215           if ( (now >= pre_active_time) &&  (pre_active_time > 0) ){
216             activated_ = true;
217 
218             // lets start first round
219             rID_ = 1;
220             round_[1].strt = now + rndExtra_ - rndGap_;
221             round_[1].end = now + rndInit_ + rndExtra_;
222           }
223         }
224         require(activated_ == true, "its not ready yet.");
225         _;
226     }
227 
228     /**
229      * @dev prevents contracts from interacting with SuperCard
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
249 //==============================================================================
250 //     _    |_ |. _   |`    _  __|_. _  _  _  .
251 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
252 //====|=========================================================================
253     /**
254      * @dev emergency buy uses last stored affiliate ID and team snek
255      */
256     function()
257         isActivated()
258         isHuman()
259         isWithinLimits(msg.value)
260         public
261         payable
262     {
263         // set up our tx event data and determine if player is new or not
264         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
282         isActivated()
283         isHuman()
284         isWithinLimits(msg.value)
285         public
286         payable
287     {
288         // set up our tx event data and determine if player is new or not
289         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
290 
291         // fetch player id
292         uint256 _pID = pIDxAddr_[msg.sender];
293 
294         // manage affiliate residuals
295         // if no affiliate code was given or player tried to use their own, lolz
296         if (_affCode == 0 || _affCode == _pID)
297         {
298             // use last stored affiliate code
299             _affCode = plyr_[_pID].laff;
300 
301         // if affiliate code was given & its not the same as previously stored
302         } else if (_affCode != plyr_[_pID].laff) {
303             // update last affiliate
304             plyr_[_pID].laff = _affCode;
305         }
306 
307         // buy core, team set to 2, snake
308         buyCore(_pID, _affCode, 2, _eventData_);
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
319         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
320 
321         // fetch player id
322         uint256 _pID = pIDxAddr_[msg.sender];
323 
324         // manage affiliate residuals
325         uint256 _affID;
326         // if no affiliate code was given or player tried to use their own, lolz
327         if (_affCode == address(0) || _affCode == msg.sender)
328         {
329             // use last stored affiliate code
330             _affID = plyr_[_pID].laff;
331 
332         // if affiliate code was given
333         } else {
334             // get affiliate ID from aff Code
335             _affID = pIDxAddr_[_affCode];
336 
337             // if affID is not the same as previously stored
338             if (_affID != plyr_[_pID].laff)
339             {
340                 // update last affiliate
341                 plyr_[_pID].laff = _affID;
342             }
343         }
344 
345         // buy core, team set to 2, snake
346         buyCore(_pID, _affID, 2, _eventData_);
347     }
348 
349     function buyXname(bytes32 _affCode, uint256 _team)
350         isActivated()
351         isHuman()
352         isWithinLimits(msg.value)
353         public
354         payable
355     {
356         // set up our tx event data and determine if player is new or not
357         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
358 
359         // fetch player id
360         uint256 _pID = pIDxAddr_[msg.sender];
361 
362         // manage affiliate residuals
363         uint256 _affID;
364         // if no affiliate code was given or player tried to use their own, lolz
365         if (_affCode == '' || _affCode == plyr_[_pID].name)
366         {
367             // use last stored affiliate code
368             _affID = plyr_[_pID].laff;
369 
370         // if affiliate code was given
371         } else {
372             // get affiliate ID from aff Code
373             _affID = pIDxName_[_affCode];
374 
375             // if affID is not the same as previously stored
376             if (_affID != plyr_[_pID].laff)
377             {
378                 // update last affiliate
379                 plyr_[_pID].laff = _affID;
380             }
381         }
382 
383         // buy core, team set to 2, snake
384         buyCore(_pID, _affID, 2, _eventData_);
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
400         isWithinLimits(_eth)
401         public
402     {
403         // set up our tx event data
404         SPCdatasets.EventReturns memory _eventData_;
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
422         // reload core, team set to 2, snake
423         reLoadCore(_pID, _affCode, _eth, _eventData_);
424     }
425 
426     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
427         isActivated()
428         isHuman()
429         isWithinLimits(_eth)
430         public
431     {
432         // set up our tx event data
433         SPCdatasets.EventReturns memory _eventData_;
434 
435         // fetch player ID
436         uint256 _pID = pIDxAddr_[msg.sender];
437 
438         // manage affiliate residuals
439         uint256 _affID;
440         // if no affiliate code was given or player tried to use their own, lolz
441         if (_affCode == address(0) || _affCode == msg.sender)
442         {
443             // use last stored affiliate code
444             _affID = plyr_[_pID].laff;
445 
446         // if affiliate code was given
447         } else {
448             // get affiliate ID from aff Code
449             _affID = pIDxAddr_[_affCode];
450 
451             // if affID is not the same as previously stored
452             if (_affID != plyr_[_pID].laff)
453             {
454                 // update last affiliate
455                 plyr_[_pID].laff = _affID;
456             }
457         }
458 
459         // reload core, team set to 2, snake
460         reLoadCore(_pID, _affID, _eth, _eventData_);
461     }
462 
463     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
464         isActivated()
465         isHuman()
466         isWithinLimits(_eth)
467         public
468     {
469         // set up our tx event data
470         SPCdatasets.EventReturns memory _eventData_;
471 
472         // fetch player ID
473         uint256 _pID = pIDxAddr_[msg.sender];
474 
475         // manage affiliate residuals
476         uint256 _affID;
477         // if no affiliate code was given or player tried to use their own, lolz
478         if (_affCode == '' || _affCode == plyr_[_pID].name)
479         {
480             // use last stored affiliate code
481             _affID = plyr_[_pID].laff;
482 
483         // if affiliate code was given
484         } else {
485             // get affiliate ID from aff Code
486             _affID = pIDxName_[_affCode];
487 
488             // if affID is not the same as previously stored
489             if (_affID != plyr_[_pID].laff)
490             {
491                 // update last affiliate
492                 plyr_[_pID].laff = _affID;
493             }
494         }
495 
496         // reload core, team set to 2, snake
497         reLoadCore(_pID, _affID, _eth, _eventData_);
498     }
499 
500     /**
501      * @dev withdraws all of your earnings.
502      * -functionhash- 0x3ccfd60b
503      */
504     function withdraw()
505         isActivated()
506         isHuman()
507         public
508     {
509         // setup local rID
510 
511         // grab time
512         uint256 _now = now;
513 
514         // fetch player ID
515         uint256 _pID = pIDxAddr_[msg.sender];
516 
517         // setup temp var for player eth
518         uint256 upperLimit = 0;
519         uint256 usedGen = 0;
520 
521         // eth send to player
522         uint256 ethout = 0;   
523         
524         uint256 over_gen = 0;
525 
526         updateGenVault(_pID, plyr_[_pID].lrnd);
527 
528         if (plyr_[_pID].gen > 0)
529         {
530           upperLimit = (calceth(plyrRnds_[_pID][rID_].keys).mul(105))/100;
531           if(plyr_[_pID].gen >= upperLimit)
532           {
533             over_gen = (plyr_[_pID].gen).sub(upperLimit);
534 
535             round_[rID_].keys = (round_[rID_].keys).sub(plyrRnds_[_pID][rID_].keys);
536             plyrRnds_[_pID][rID_].keys = 0;
537 
538             round_[rID_].pot = (round_[rID_].pot).add(over_gen);
539               
540             usedGen = upperLimit;       
541           }
542           else
543           {
544             plyrRnds_[_pID][rID_].keys = (plyrRnds_[_pID][rID_].keys).sub(calckeys(((plyr_[_pID].gen).mul(100))/105));
545             round_[rID_].keys = (round_[rID_].keys).sub(calckeys(((plyr_[_pID].gen).mul(100))/105));
546             usedGen = plyr_[_pID].gen;
547           }
548 
549           ethout = ((plyr_[_pID].win).add(plyr_[_pID].aff)).add(usedGen);
550         }
551         else
552         {
553           ethout = ((plyr_[_pID].win).add(plyr_[_pID].aff));
554         }
555 
556         plyr_[_pID].win = 0;
557         plyr_[_pID].gen = 0;
558         plyr_[_pID].aff = 0;
559 
560         plyr_[_pID].addr.transfer(ethout);
561 
562         // check to see if round has ended and no one has run round end yet
563         if (_now > round_[rID_].end && round_[rID_].ended == false && round_[rID_].plyr != 0)
564         {
565             // set up our tx event data
566             SPCdatasets.EventReturns memory _eventData_;
567 
568             // end the round (distributes pot)
569             round_[rID_].ended = true;
570             _eventData_ = endRound(_eventData_);
571 
572             // build event data
573             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
574             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
575 
576             // fire withdraw and distribute event
577             emit SPCevents.onWithdrawAndDistribute
578             (
579                 msg.sender,
580                 plyr_[_pID].name,
581                 ethout,
582                 _eventData_.compressedData,
583                 _eventData_.compressedIDs,
584                 _eventData_.winnerAddr,
585                 _eventData_.winnerName,
586                 _eventData_.amountWon,
587                 _eventData_.newPot,
588                 _eventData_.P3DAmount,
589                 _eventData_.genAmount
590             );
591 
592         // in any other situation
593         } else {
594             // fire withdraw event
595             emit SPCevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, ethout, _now);
596         }
597     }
598 
599     /**
600      * @dev use these to register names.  they are just wrappers that will send the
601      * registration requests to the PlayerBook contract.  So registering here is the
602      * same as registering there.  UI will always display the last name you registered.
603      * but you will still own all previously registered names to use as affiliate
604      * links.
605      * - must pay a registration fee.
606      * - name must be unique
607      * - names will be converted to lowercase
608      * - name cannot start or end with a space
609      * - cannot have more than 1 space in a row
610      * - cannot be only numbers
611      * - cannot start with 0x
612      * - name must be at least 1 char
613      * - max length of 32 characters long
614      * - allowed characters: a-z, 0-9, and space
615      * -functionhash- 0x921dec21 (using ID for affiliate)
616      * -functionhash- 0x3ddd4698 (using address for affiliate)
617      * -functionhash- 0x685ffd83 (using name for affiliate)
618      * @param _nameString players desired name
619      * @param _affCode affiliate ID, address, or name of who referred you
620      * @param _all set to true if you want this to push your info to all games
621      * (this might cost a lot of gas)
622      */
623     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
624         isHuman()
625         public
626         payable
627     {
628         bytes32 _name = _nameString.nameFilter();
629         address _addr = msg.sender;
630         uint256 _paid = msg.value;
631         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
632 
633         uint256 _pID = pIDxAddr_[_addr];
634 
635         // fire event
636         emit SPCevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
637     }
638 
639     function registerNameXaddr(string _nameString, address _affCode, bool _all)
640         isHuman()
641         public
642         payable
643     {
644         bytes32 _name = _nameString.nameFilter();
645         address _addr = msg.sender;
646         uint256 _paid = msg.value;
647         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
648 
649         uint256 _pID = pIDxAddr_[_addr];
650 
651         // fire event
652         emit SPCevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
653     }
654 
655     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
656         isHuman()
657         public
658         payable
659     {
660         bytes32 _name = _nameString.nameFilter();
661         address _addr = msg.sender;
662         uint256 _paid = msg.value;
663         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
664 
665         uint256 _pID = pIDxAddr_[_addr];
666 
667         // fire event
668         emit SPCevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
669     }
670 //==============================================================================
671 //     _  _ _|__|_ _  _ _  .
672 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
673 //=====_|=======================================================================
674     /**
675      * @dev return the price buyer will pay for next 1 individual key.
676      * -functionhash- 0x018a25e8
677      * @return price for next key bought (in wei format)
678      */
679     function getBuyPrice()
680         public
681         view
682         returns(uint256)
683     {
684         // price 0.01 ETH
685         return(10000000000000000);
686     }
687 
688     /**
689      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
690      * provider
691      * -functionhash- 0xc7e284b8
692      * @return time left in seconds
693      */
694     function getTimeLeft()
695         public
696         view
697         returns(uint256)
698     {
699         // setup local rID
700         uint256 _rID = rID_;
701 
702         // grab time
703         uint256 _now = now;
704 
705         if (_now < round_[_rID].end)
706             if (_now > round_[_rID].strt + rndGap_)
707                 return( (round_[_rID].end).sub(_now) );
708             else
709                 return( (round_[_rID].strt + rndGap_).sub(_now) );
710         else
711             return(0);
712     }
713 
714     /**
715      * @dev returns player earnings per vaults
716      * -functionhash- 0x63066434
717      * @return winnings vault
718      * @return general vault
719      * @return affiliate vault
720      */
721     function getPlayerVaults(uint256 _pID)
722         public
723         view
724         returns(uint256 ,uint256, uint256)
725     {
726         // setup local rID
727         uint256 _rID = rID_;
728 
729         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
730         return
731         (
732             plyr_[_pID].win,
733             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
734             plyr_[_pID].aff
735         );
736     }
737 
738      /**
739      * @dev returns all current round info needed for front end
740      * -functionhash- 0x747dff42
741      * @return eth invested during ICO phase
742      * @return round id
743      * @return total keys for round
744      * @return time round ends
745      * @return time round started
746      * @return current pot
747      * @return current team ID & player ID in lead
748      * @return current player in leads address
749      * @return current player in leads name
750      * @return whales eth in for round
751      * @return bears eth in for round
752      * @return sneks eth in for round
753      * @return bulls eth in for round
754      * @return airdrop tracker # & airdrop pot
755      */
756     function getCurrentRoundInfo()
757         public
758         view
759         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
760     {
761         // setup local rID
762         uint256 _rID = rID_;
763 
764         return
765         (
766             round_[_rID].ico,               //0
767             _rID,                           //1
768             round_[_rID].keys,              //2
769             round_[_rID].end,               //3
770             round_[_rID].strt,              //4
771             round_[_rID].pot,               //5
772             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
773             plyr_[round_[_rID].plyr].addr,  //7
774             plyr_[round_[_rID].plyr].name,  //8
775             rndTmEth_[_rID][0],             //9
776             rndTmEth_[_rID][1],             //10
777             rndTmEth_[_rID][2],             //11
778             rndTmEth_[_rID][3],             //12
779             airDropTracker_ + (airDropPot_ * 1000)              //13
780         );
781     }
782 
783     /**
784      * @dev returns player info based on address.  if no address is given, it will
785      * use msg.sender
786      * -functionhash- 0xee0b5d8b
787      * @param _addr address of the player you want to lookup
788      * @return player ID
789      * @return player name
790      * @return keys owned (current round)
791      * @return winnings vault
792      * @return general vault
793      * @return affiliate vault
794    * @return player round eth
795      */
796     function getPlayerInfoByAddress(address _addr)
797         public
798         view
799         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
800     {
801         // setup local rID
802         uint256 _rID = rID_;
803 
804         if (_addr == address(0))
805         {
806             _addr == msg.sender;
807         }
808         uint256 _pID = pIDxAddr_[_addr];
809 
810         return
811         (
812             _pID,                               //0
813             plyr_[_pID].name,                   //1
814             plyrRnds_[_pID][_rID].keys,         //2
815             plyr_[_pID].win,                    //3
816             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
817             plyr_[_pID].aff,                    //5
818             plyrRnds_[_pID][_rID].eth           //6
819         );
820     }
821 
822 //==============================================================================
823 //     _ _  _ _   | _  _ . _  .
824 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
825 //=====================_|=======================================================
826     /**
827      * @dev logic runs whenever a buy order is executed.  determines how to handle
828      * incoming eth depending on if we are in an active round or not
829      */
830     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
831         private
832     {
833         // setup local rID
834         uint256 _rID = rID_;
835 
836         // grab time
837         uint256 _now = now;
838 
839         // if round is active
840         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
841         {
842             // call core
843             core(_rID, _pID, msg.value, _affID, 2, _eventData_);
844 
845         // if round is not active
846         } else {
847             // check to see if end round needs to be ran
848             if (_now > round_[_rID].end && round_[_rID].ended == false)
849             {
850                 // end the round (distributes pot) & start new round
851                 round_[_rID].ended = true;
852                 _eventData_ = endRound(_eventData_);
853 
854                 // build event data
855                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
856                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
857 
858                 // fire buy and distribute event
859                 emit SPCevents.onBuyAndDistribute
860                 (
861                     msg.sender,
862                     plyr_[_pID].name,
863                     msg.value,
864                     _eventData_.compressedData,
865                     _eventData_.compressedIDs,
866                     _eventData_.winnerAddr,
867                     _eventData_.winnerName,
868                     _eventData_.amountWon,
869                     _eventData_.newPot,
870                     _eventData_.P3DAmount,
871                     _eventData_.genAmount
872                 );
873             }
874 
875             // put eth in players vault, to win vault
876             plyr_[_pID].win = plyr_[_pID].win.add(msg.value);
877         }
878     }
879 
880     /**
881      * @dev gen limit handle
882      */
883     function genLimit(uint256 _pID) 
884     private 
885     returns(uint256)
886     {
887       uint256 upperLimit = 0;
888       uint256 usedGen = 0;
889       
890       uint256 over_gen = 0;
891       uint256 eth_can_use = 0;
892 
893       uint256 tempnum = 0;
894 
895       updateGenVault(_pID, plyr_[_pID].lrnd);
896 
897       if (plyr_[_pID].gen > 0)
898       {
899         upperLimit = ((plyrRnds_[_pID][rID_].keys).mul(105))/10000;
900         if(plyr_[_pID].gen >= upperLimit)
901         {
902           over_gen = (plyr_[_pID].gen).sub(upperLimit);
903 
904           round_[rID_].keys = (round_[rID_].keys).sub(plyrRnds_[_pID][rID_].keys);
905           plyrRnds_[_pID][rID_].keys = 0;
906 
907           round_[rID_].pot = (round_[rID_].pot).add(over_gen);
908             
909           usedGen = upperLimit;
910         }
911         else
912         {
913           tempnum = ((plyr_[_pID].gen).mul(10000))/105;
914 
915           plyrRnds_[_pID][rID_].keys = (plyrRnds_[_pID][rID_].keys).sub(tempnum);
916           round_[rID_].keys = (round_[rID_].keys).sub(tempnum);
917 
918           usedGen = plyr_[_pID].gen;
919         }
920 
921         eth_can_use = ((plyr_[_pID].win).add(plyr_[_pID].aff)).add(usedGen);
922 
923         plyr_[_pID].win = 0;
924         plyr_[_pID].gen = 0;
925         plyr_[_pID].aff = 0;
926       }
927       else
928       {
929         eth_can_use = (plyr_[_pID].win).add(plyr_[_pID].aff);
930         plyr_[_pID].win = 0;
931         plyr_[_pID].aff = 0;
932       }
933 
934       return(eth_can_use);
935   }
936 
937   /**
938      * @dev logic runs whenever a reload order is executed.  determines how to handle
939      * incoming eth depending on if we are in an active round or not
940      */
941     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, SPCdatasets.EventReturns memory _eventData_)
942         private
943     {
944         // setup local rID
945 
946         // grab time
947         uint256 _now = now;
948 
949         uint256 eth_can_use = 0;
950 
951         // if round is active
952         if (_now > round_[rID_].strt + rndGap_ && (_now <= round_[rID_].end || (_now > round_[rID_].end && round_[rID_].plyr == 0)))
953         {
954             // get earnings from all vaults and return unused to gen vault
955             // because we use a custom safemath library.  this will throw if player
956             // tried to spend more eth than they have.
957 
958             eth_can_use = genLimit(_pID);
959             if(eth_can_use > 0)
960             {
961               // call core
962               core(rID_, _pID, eth_can_use, _affID, 2, _eventData_);
963             }
964 
965         // if round is not active and end round needs to be ran
966         } else if (_now > round_[rID_].end && round_[rID_].ended == false) {
967             // end the round (distributes pot) & start new round
968             round_[rID_].ended = true;
969             _eventData_ = endRound(_eventData_);
970 
971             // build event data
972             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
973             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
974 
975             // fire buy and distribute event
976             emit SPCevents.onReLoadAndDistribute
977             (
978                 msg.sender,
979                 plyr_[_pID].name,
980                 _eventData_.compressedData,
981                 _eventData_.compressedIDs,
982                 _eventData_.winnerAddr,
983                 _eventData_.winnerName,
984                 _eventData_.amountWon,
985                 _eventData_.newPot,
986                 _eventData_.P3DAmount,
987                 _eventData_.genAmount
988             );
989         }
990     }
991 
992     /**
993      * @dev this is the core logic for any buy/reload that happens while a round
994      * is live.
995      */
996     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
997         private
998     {
999         // if player is new to round。
1000         if (plyrRnds_[_pID][_rID].jionflag != 1)
1001         {
1002           _eventData_ = managePlayer(_pID, _eventData_);
1003           plyrRnds_[_pID][_rID].jionflag = 1;
1004 
1005           attend[round_[_rID].attendNum] = _pID;
1006           round_[_rID].attendNum  = (round_[_rID].attendNum).add(1);
1007         }
1008 
1009         if (_eth > 10000000000000000)
1010         {
1011 
1012             // mint the new keys
1013             uint256 _keys = calckeys(_eth);
1014 
1015             // if they bought at least 1 whole key
1016             if (_keys >= 1000000000000000000)
1017             {
1018               updateTimer(_keys, _rID);
1019 
1020               // set new leaders
1021               if (round_[_rID].plyr != _pID)
1022                 round_[_rID].plyr = _pID;
1023 
1024               round_[_rID].team = 2;
1025 
1026               // set the new leader bool to true
1027               _eventData_.compressedData = _eventData_.compressedData + 100;
1028             }
1029 
1030             // update player
1031             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1032             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1033 
1034             // update round
1035             round_[_rID].keys = _keys.add(round_[_rID].keys);
1036             round_[_rID].eth = _eth.add(round_[_rID].eth);
1037             rndTmEth_[_rID][2] = _eth.add(rndTmEth_[_rID][2]);
1038 
1039             // distribute eth
1040             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 2, _eventData_);
1041             _eventData_ = distributeInternal(_rID, _pID, _eth, 2, _keys, _eventData_);
1042 
1043             // call end tx function to fire end tx event.
1044             endTx(_pID, 2, _eth, _keys, _eventData_);
1045         }
1046     }
1047 //==============================================================================
1048 //     _ _ | _   | _ _|_ _  _ _  .
1049 //    (_(_||(_|_||(_| | (_)| _\  .
1050 //==============================================================================
1051     /**
1052      * @dev calculates unmasked earnings (just calculates, does not update mask)
1053      * @return earnings in wei format
1054      */
1055     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1056         private
1057         view
1058         returns(uint256)
1059     {
1060         uint256 temp;
1061         temp = (round_[_rIDlast].mask).mul((plyrRnds_[_pID][_rIDlast].keys)/1000000000000000000);
1062         if(temp > plyrRnds_[_pID][_rIDlast].mask)
1063         {
1064           return( temp.sub(plyrRnds_[_pID][_rIDlast].mask) );
1065         }
1066         else
1067         {
1068           return( 0 );
1069         }
1070     }
1071 
1072     /**
1073      * @dev returns the amount of keys you would get given an amount of eth.
1074      * -functionhash- 0xce89c80c
1075      * @param _rID round ID you want price for
1076      * @param _eth amount of eth sent in
1077      * @return keys received
1078      */
1079     function calcKeysReceived(uint256 _rID, uint256 _eth)
1080         public
1081         view
1082         returns(uint256)
1083     {
1084         return ( calckeys(_eth) );
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
1098         return ( _keys/100 );
1099     }
1100 //==============================================================================
1101 //    _|_ _  _ | _  .
1102 //     | (_)(_)|_\  .
1103 //==============================================================================
1104     /**
1105    * @dev receives name/player info from names contract
1106      */
1107     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1108         external
1109     {
1110         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1111         if (pIDxAddr_[_addr] != _pID)
1112             pIDxAddr_[_addr] = _pID;
1113         if (pIDxName_[_name] != _pID)
1114             pIDxName_[_name] = _pID;
1115         if (plyr_[_pID].addr != _addr)
1116             plyr_[_pID].addr = _addr;
1117         if (plyr_[_pID].name != _name)
1118             plyr_[_pID].name = _name;
1119         if (plyr_[_pID].laff != _laff)
1120             plyr_[_pID].laff = _laff;
1121         if (plyrNames_[_pID][_name] == false)
1122             plyrNames_[_pID][_name] = true;
1123     }
1124 
1125     /**
1126      * @dev receives entire player name list
1127      */
1128     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1129         external
1130     {
1131         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1132         if(plyrNames_[_pID][_name] == false)
1133             plyrNames_[_pID][_name] = true;
1134     }
1135 
1136     /**
1137      * @dev gets existing or registers new pID.  use this when a player may be new
1138      * @return pID
1139      */
1140     function determinePID(SPCdatasets.EventReturns memory _eventData_)
1141         private
1142         returns (SPCdatasets.EventReturns)
1143     {
1144         uint256 _pID = pIDxAddr_[msg.sender];
1145         // if player is new to this version of SuperCard
1146         if (_pID == 0)
1147         {
1148             // grab their player ID, name and last aff ID, from player names contract
1149             _pID = PlayerBook.getPlayerID(msg.sender);
1150             pID_ = _pID; // save Last pID
1151             
1152             bytes32 _name = PlayerBook.getPlayerName(_pID);
1153             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1154 
1155             // set up player account
1156             pIDxAddr_[msg.sender] = _pID;
1157             plyr_[_pID].addr = msg.sender;
1158 
1159             if (_name != "")
1160             {
1161                 pIDxName_[_name] = _pID;
1162                 plyr_[_pID].name = _name;
1163                 plyrNames_[_pID][_name] = true;
1164             }
1165 
1166             if (_laff != 0 && _laff != _pID)
1167                 plyr_[_pID].laff = _laff;
1168 
1169             // set the new player bool to true
1170             _eventData_.compressedData = _eventData_.compressedData + 1;
1171         }
1172         return (_eventData_);
1173     }
1174 
1175     /**
1176      * @dev decides if round end needs to be run & new round started.  and if
1177      * player unmasked earnings from previously played rounds need to be moved.
1178      */
1179     function managePlayer(uint256 _pID, SPCdatasets.EventReturns memory _eventData_)
1180         private
1181         returns (SPCdatasets.EventReturns)
1182     {
1183         uint256 temp_eth = 0;
1184         // if player has played a previous round, move their unmasked earnings
1185         // from that round to win vault. 
1186         if (plyr_[_pID].lrnd != 0)
1187         {
1188           updateGenVault(_pID, plyr_[_pID].lrnd);
1189           temp_eth = ((plyr_[_pID].win).add((plyr_[_pID].gen))).add(plyr_[_pID].aff);
1190 
1191           plyr_[_pID].gen = 0;
1192           plyr_[_pID].aff = 0;
1193           plyr_[_pID].win = temp_eth;
1194         }
1195 
1196         // update player's last round played
1197         plyr_[_pID].lrnd = rID_;
1198 
1199         // set the joined round bool to true
1200         _eventData_.compressedData = _eventData_.compressedData + 10;
1201 
1202         return(_eventData_);
1203     }
1204 
1205     /**
1206      * @dev ends the round. manages paying out winner/splitting up pot
1207      */
1208     function endRound(SPCdatasets.EventReturns memory _eventData_)
1209         private
1210         returns (SPCdatasets.EventReturns)
1211     {
1212         // setup local rID
1213         uint256 _rID = rID_;
1214 
1215         // grab our winning player and team id's
1216         uint256 _winPID = round_[_rID].plyr;
1217         uint256 _winTID = round_[_rID].team;
1218 
1219         // grab our pot amount
1220         uint256 _pot = round_[_rID].pot;
1221 
1222         // calculate our winner share, community rewards, gen share,
1223         // p3d share, and amount reserved for next pot
1224         uint256 _win = (_pot.mul(30)) / 100;
1225         uint256 _com = (_pot / 10);
1226         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1227         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1228         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1229 
1230         // calculate ppt for round mask
1231         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1232         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1233         if (_dust > 0)
1234         {
1235             _gen = _gen.sub(_dust);
1236         }
1237 
1238         // pay our winner
1239         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1240 
1241         // community rewards
1242         _com = _com.add(_p3d.sub(_p3d / 2));
1243         admin.transfer(_com);
1244 
1245         _res = _res.add(_p3d / 2);
1246 
1247         // distribute gen portion to key holders
1248         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1249 
1250         // prepare event data
1251         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1252         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1253         _eventData_.winnerAddr = plyr_[_winPID].addr;
1254         _eventData_.winnerName = plyr_[_winPID].name;
1255         _eventData_.amountWon = _win;
1256         _eventData_.genAmount = _gen;
1257         _eventData_.P3DAmount = _p3d;
1258         _eventData_.newPot = _res;
1259 
1260         // start next round
1261         rID_++;
1262         _rID++;
1263         round_[_rID].strt = now;
1264         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1265         round_[_rID].pot = _res;
1266 
1267         return(_eventData_);
1268     }
1269 
1270   /**
1271      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1272      */
1273     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1274         private
1275     {
1276         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1277         if (_earnings > 0)
1278         {
1279             // put in gen vault
1280             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1281             // zero out their earnings by updating mask
1282             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1283         }
1284     }
1285 
1286     /**
1287      * @dev updates round timer based on number of whole keys bought.
1288      */
1289     function updateTimer(uint256 _keys, uint256 _rID)
1290         private
1291     {
1292         // grab time
1293         uint256 _now = now;
1294 
1295         // calculate time based on number of keys bought
1296         uint256 _newTime;
1297         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1298             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1299         else
1300             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1301 
1302         // compare to max and set new end time
1303         if (_newTime < (rndMax_).add(_now))
1304             round_[_rID].end = _newTime;
1305         else
1306             round_[_rID].end = rndMax_.add(_now);
1307     }
1308 
1309     /**
1310      * @dev distributes eth based on fees to com, aff, and p3d
1311      */
1312     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
1313         private
1314         returns(SPCdatasets.EventReturns)
1315     {
1316         // pay 3% out to community rewards
1317         uint256 _p3d = (_eth/100).mul(3);
1318               
1319         // distribute share to affiliate
1320         // 5%:3%:2%
1321         uint256 _aff_cent = (_eth) / 100;
1322         
1323         uint256 tempID  = _affID;
1324 
1325         // decide what to do with affiliate share of fees
1326         // affiliate must not be self, and must have a name registered
1327         
1328         // 5%
1329         if (tempID != _pID && plyr_[tempID].name != '') 
1330         { 
1331             plyr_[tempID].aff = (_aff_cent.mul(5)).add(plyr_[tempID].aff);
1332             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(5), now);
1333         } 
1334         else 
1335         {
1336             _p3d = _p3d.add(_aff_cent.mul(5));
1337         }
1338 
1339         tempID = PlayerBook.getPlayerID(plyr_[tempID].addr);
1340         tempID = PlayerBook.getPlayerLAff(tempID);
1341 
1342         if (tempID != _pID && plyr_[tempID].name != '') 
1343         { 
1344             plyr_[tempID].aff = (_aff_cent.mul(3)).add(plyr_[tempID].aff);
1345             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(3), now);
1346         } 
1347         else 
1348         {
1349             _p3d = _p3d.add(_aff_cent.mul(3));
1350         }
1351         
1352         tempID = PlayerBook.getPlayerID(plyr_[tempID].addr);
1353         tempID = PlayerBook.getPlayerLAff(tempID);
1354 
1355         if (tempID != _pID && plyr_[tempID].name != '') 
1356         { 
1357             plyr_[tempID].aff = (_aff_cent.mul(2)).add(plyr_[tempID].aff);
1358             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(2), now);
1359         } 
1360         else 
1361         {
1362             _p3d = _p3d.add(_aff_cent.mul(2));
1363         }
1364 
1365 
1366         // pay out p3d
1367         _p3d = _p3d.add((_eth.mul(fees_[2].p3d)) / (100));
1368         if (_p3d > 0)
1369         {
1370             admin.transfer(_p3d);
1371             // set up event data
1372             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1373         }
1374 
1375         return(_eventData_);
1376     }
1377 
1378   /**
1379      * @dev 
1380      */
1381     function potSwap()
1382         external
1383         payable
1384     {
1385         // setup local rID
1386         uint256 _rID = rID_ + 1;
1387 
1388         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1389         emit SPCevents.onPotSwapDeposit(_rID, msg.value);
1390     }
1391 
1392     /**
1393      * @dev distributes eth based on fees to gen and pot
1394      */
1395     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, SPCdatasets.EventReturns memory _eventData_)
1396         private
1397         returns(SPCdatasets.EventReturns)
1398     {
1399         // calculate gen share，80%
1400         uint256 _gen = (_eth.mul(fees_[2].gen)) / 100;
1401 
1402         // pot 5%
1403         uint256 _pot = (_eth.mul(5)) / 100;
1404 
1405         // distribute gen share (thats what updateMasks() does) and adjust
1406         // balances for dust.
1407         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1408         if (_dust > 0)
1409             _gen = _gen.sub(_dust);
1410 
1411         // add eth to pot
1412         round_[_rID].pot = _pot.add(round_[_rID].pot);
1413 
1414         // set up event data
1415         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1416         _eventData_.potAmount = _pot;
1417 
1418         return(_eventData_);
1419     }
1420 
1421     /**
1422      * @dev updates masks for round and player when keys are bought
1423      * @return dust left over
1424      */
1425     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1426         private
1427         returns(uint256)
1428     {
1429         /* MASKING NOTES
1430             earnings masks are a tricky thing for people to wrap their minds around.
1431             the basic thing to understand here.  is were going to have a global
1432             tracker based on profit per share for each round, that increases in
1433             relevant proportion to the increase in share supply.
1434 
1435             the player will have an additional mask that basically says "based
1436             on the rounds mask, my shares, and how much i've already withdrawn,
1437             how much is still owed to me?"
1438         */
1439 
1440         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1441         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1442         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1443 
1444         // calculate player earning from their own buy (only based on the keys
1445         // they just bought).  & update player earnings mask
1446         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1447         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1448 
1449         // calculate & return dust
1450         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1451     }
1452 
1453     /**
1454      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1455      * @return earnings in wei format
1456      */
1457     function withdrawEarnings(uint256 _pID)
1458         private
1459         returns(uint256)
1460     {
1461         // update gen vault
1462         updateGenVault(_pID, plyr_[_pID].lrnd);
1463 
1464         // from vaults
1465         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1466         if (_earnings > 0)
1467         {
1468             plyr_[_pID].win = 0;
1469             plyr_[_pID].gen = 0;
1470             plyr_[_pID].aff = 0;
1471         }
1472 
1473         return(_earnings);
1474     }
1475   
1476   /**
1477      * @dev prepares compression data and fires event for buy or reload tx's
1478      */
1479     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, SPCdatasets.EventReturns memory _eventData_)
1480         private
1481     {
1482     _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (2 * 100000000000000000000000000000);
1483         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1484 
1485         emit SPCevents.onEndTx
1486         (
1487             _eventData_.compressedData,
1488             _eventData_.compressedIDs,
1489             plyr_[_pID].name,
1490             msg.sender,
1491             _eth,
1492             _keys,
1493             _eventData_.winnerAddr,
1494             _eventData_.winnerName,
1495             _eventData_.amountWon,
1496             _eventData_.newPot,
1497             _eventData_.P3DAmount,
1498             _eventData_.genAmount,
1499             _eventData_.potAmount,
1500             airDropPot_
1501         );
1502     }
1503 //==============================================================================
1504 //    (~ _  _    _._|_    .
1505 //    _)(/_(_|_|| | | \/  .
1506 //====================/=========================================================
1507     /** upon contract deploy, it will be deactivated.  this is a one time
1508      * use function that will activate the contract.  we do this so devs
1509      * have time to set things up on the web end                            **/
1510     bool public activated_ = false;
1511 
1512     //uint256 public pre_active_time = 0;
1513     uint256 public pre_active_time = 1534412700;
1514     
1515     /**
1516      * @dev return active flag 、time
1517      * @return active flag
1518      * @return active time
1519      * @return system time
1520      */
1521     function getRunInfo() public view returns(bool, uint256, uint256)
1522     {
1523         return
1524         (
1525             activated_,      //0
1526             pre_active_time, //1
1527             now          //2      
1528         );
1529     }
1530 
1531     function setPreActiveTime(uint256 _pre_time) public
1532     {
1533         // only team just can activate
1534         require(msg.sender == admin, "only admin can activate"); 
1535         pre_active_time = _pre_time;
1536     }
1537 
1538     function activate()
1539         public
1540     {
1541         // only team just can activate
1542         require(msg.sender == admin, "only admin can activate"); 
1543 
1544         // can only be ran once
1545         require(activated_ == false, "SuperCard already activated");
1546 
1547         // activate the contract
1548         activated_ = true;
1549         //activated_ = false;
1550 
1551         // lets start first round
1552         rID_ = 1;
1553         round_[1].strt = now + rndExtra_ - rndGap_;
1554         round_[1].end = now + rndInit_ + rndExtra_;
1555     }
1556 
1557 //==============================================================================
1558 //  |  _      _ _ | _  .
1559 //  |<(/_\/  (_(_||(_  .
1560 //=======/======================================================================
1561   function calckeys(uint256 _eth)
1562         pure
1563     public
1564         returns(uint256)
1565     {
1566         return ( (_eth).mul(100) );
1567     }
1568 
1569     /**
1570      * @dev calculates how much eth would be in contract given a number of keys
1571      * @param _keys number of keys "in contract"
1572      * @return eth that would exists
1573      */
1574     function calceth(uint256 _keys)
1575         pure
1576     public
1577         returns(uint256)
1578     {
1579         return( (_keys)/100 );
1580     } 
1581 }
1582 
1583 //==============================================================================
1584 //   __|_ _    __|_ _  .
1585 //  _\ | | |_|(_ | _\  .
1586 //==============================================================================
1587 library SPCdatasets {
1588     //compressedData key
1589     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1590         // 0 - new player (bool)
1591         // 1 - joined round (bool)
1592         // 2 - new  leader (bool)
1593         // 3-5 - air drop tracker (uint 0-999)
1594         // 6-16 - round end time
1595         // 17 - winnerTeam
1596         // 18 - 28 timestamp
1597         // 29 - team
1598         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1599         // 31 - airdrop happened bool
1600         // 32 - airdrop tier
1601         // 33 - airdrop amount won
1602     //compressedIDs key
1603     // [77-52][51-26][25-0]
1604         // 0-25 - pID
1605         // 26-51 - winPID
1606         // 52-77 - rID
1607     struct EventReturns {
1608         uint256 compressedData;
1609         uint256 compressedIDs;
1610         address winnerAddr;         // winner address
1611         bytes32 winnerName;         // winner name
1612         uint256 amountWon;          // amount won
1613         uint256 newPot;             // amount in new pot
1614         uint256 P3DAmount;          // amount distributed to p3d
1615         uint256 genAmount;          // amount distributed to gen
1616         uint256 potAmount;          // amount added to pot
1617     }
1618     struct Player {
1619         address addr;   // player address
1620         bytes32 name;   // player name
1621         uint256 win;    // winnings vault
1622         uint256 gen;    // general vault
1623 		uint256 aff;    // affiliate vault
1624         uint256 lrnd;   // last round played
1625         uint256 laff;   // last affiliate id used
1626 		uint256 gen2;   // general for clear keys
1627     }
1628     struct PlayerRounds {
1629         uint256 eth;    // eth player has added to round (used for eth limiter)
1630         uint256 keys;   // keys
1631         uint256 mask;   // player mask
1632     uint256 jionflag;   // player not jion round
1633         uint256 ico;    // ICO phase investment
1634     }
1635     struct Round {
1636         uint256 plyr;   // pID of player in lead
1637         uint256 team;   // tID of team in lead
1638         uint256 end;    // time ends/ended
1639         bool ended;     // has round end function been ran
1640         uint256 strt;   // time round started
1641         uint256 keys;   // keys
1642         uint256 eth;    // total eth in
1643         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1644         uint256 mask;   // global mask
1645         uint256 ico;    // total eth sent in during ICO phase
1646         uint256 icoGen; // total eth for gen during ICO phase
1647         uint256 icoAvg; // average key price for ICO phase
1648     uint256 attendNum; // number of players attend
1649     }
1650     struct TeamFee {
1651         uint256 gen;    // % of buy in thats paid to key holders of current round
1652         uint256 p3d;    // % of buy in thats paid to p3d holders
1653     }
1654     struct PotSplit {
1655         uint256 gen;    // % of pot thats paid to key holders of current round
1656         uint256 p3d;    // % of pot thats paid to p3d holders
1657     }
1658 }
1659 
1660 //==============================================================================
1661 //  . _ _|_ _  _ |` _  _ _  _  .
1662 //  || | | (/_| ~|~(_|(_(/__\  .
1663 //==============================================================================
1664 
1665 interface PlayerBookInterface {
1666     function getPlayerID(address _addr) external returns (uint256);
1667     function getPlayerName(uint256 _pID) external view returns (bytes32);
1668     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1669     function getPlayerAddr(uint256 _pID) external view returns (address);
1670     function getNameFee() external view returns (uint256);
1671     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1672     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1673     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1674 }
1675 
1676 /**
1677 * @title -Name Filter- v0.1.9
1678 */
1679 
1680 library NameFilter {
1681     /**
1682      * @dev filters name strings
1683      * -converts uppercase to lower case.
1684      * -makes sure it does not start/end with a space
1685      * -makes sure it does not contain multiple spaces in a row
1686      * -cannot be only numbers
1687      * -cannot start with 0x
1688      * -restricts characters to A-Z, a-z, 0-9, and space.
1689      * @return reprocessed string in bytes32 format
1690      */
1691     function nameFilter(string _input)
1692         internal
1693         pure
1694         returns(bytes32)
1695     {
1696         bytes memory _temp = bytes(_input);
1697         uint256 _length = _temp.length;
1698 
1699         //sorry limited to 32 characters
1700         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1701         // make sure it doesnt start with or end with space
1702         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1703         // make sure first two characters are not 0x
1704         if (_temp[0] == 0x30)
1705         {
1706             require(_temp[1] != 0x78, "string cannot start with 0x");
1707             require(_temp[1] != 0x58, "string cannot start with 0X");
1708         }
1709 
1710         // create a bool to track if we have a non number character
1711         bool _hasNonNumber;
1712 
1713         // convert & check
1714         for (uint256 i = 0; i < _length; i++)
1715         {
1716             // if its uppercase A-Z
1717             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1718             {
1719                 // convert to lower case a-z
1720                 _temp[i] = byte(uint(_temp[i]) + 32);
1721 
1722                 // we have a non number
1723                 if (_hasNonNumber == false)
1724                     _hasNonNumber = true;
1725             } else {
1726                 require
1727                 (
1728                     // require character is a space
1729                     _temp[i] == 0x20 ||
1730                     // OR lowercase a-z
1731                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1732                     // or 0-9
1733                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1734                     "string contains invalid characters"
1735                 );
1736                 // make sure theres not 2x spaces in a row
1737                 if (_temp[i] == 0x20)
1738                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1739 
1740                 // see if we have a character other than a number
1741                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1742                     _hasNonNumber = true;
1743             }
1744         }
1745 
1746         require(_hasNonNumber == true, "string cannot be only numbers");
1747 
1748         bytes32 _ret;
1749         assembly {
1750             _ret := mload(add(_temp, 32))
1751         }
1752         return (_ret);
1753     }
1754 }
1755 
1756 /**
1757  * @title SafeMath v0.1.9
1758  * @dev Math operations with safety checks that throw on error
1759  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1760  * - added sqrt
1761  * - added sq
1762  * - added pwr
1763  * - changed asserts to requires with error log outputs
1764  * - removed div, its useless
1765  */
1766 library SafeMath {
1767 
1768     /**
1769     * @dev Multiplies two numbers, throws on overflow.
1770     */
1771     function mul(uint256 a, uint256 b)
1772         internal
1773         pure
1774         returns (uint256 c)
1775     {
1776         if (a == 0) {
1777             return 0;
1778         }
1779         c = a * b;
1780         require(c / a == b, "SafeMath mul failed");
1781         return c;
1782     }
1783 
1784     /**
1785     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1786     */
1787     function sub(uint256 a, uint256 b)
1788         internal
1789         pure
1790         returns (uint256)
1791     {
1792         require(b <= a, "SafeMath sub failed");
1793         return a - b;
1794     }
1795 
1796     /**
1797     * @dev Adds two numbers, throws on overflow.
1798     */
1799     function add(uint256 a, uint256 b)
1800         internal
1801         pure
1802         returns (uint256 c)
1803     {
1804         c = a + b;
1805         require(c >= a, "SafeMath add failed");
1806         return c;
1807     }
1808 }