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
115     // received end Round
116     event onEndRound
117     (
118         uint256 roundID,
119         address winnerAddr,
120         bytes32 winnerName,
121         uint256 amountWon,
122         uint256 newPot
123     );
124 }
125 
126 //==============================================================================
127 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
128 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
129 //====================================|=========================================
130 
131 contract modularShort is F3Devents {}
132 
133 contract Duang8 is modularShort {
134     using SafeMath for *;
135     using NameFilter for string;
136     using F3DKeysCalcShort for uint256;
137 
138     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xE840E25BaB3F1F02eb1244a3aDC8965F5864f22E);
139 
140 //==============================================================================
141 //     _ _  _  |`. _     _ _ |_ | _  _  .
142 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
143 //=================_|===========================================================
144     address private admin = msg.sender;
145     address private shareCom = 0x2F0839f736197117796967452310F025a330DA45;
146     address private groupCut = 0x2924C3BfA7A20eB7AEcB6c38F4576eDcf7a72Df3;
147 
148     string constant public name = "duang8";
149     string constant public symbol = "duang8";
150 
151     uint256 private rndExtra_ = 0;     // length of the very first ICO
152     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
153 
154     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
155     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
156     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
157 
158     uint256 constant private rndLimit_ = 5000;                // limit rnd eth purchase
159 
160 //==============================================================================
161 //     _| _ _|_ _    _ _ _|_    _   .
162 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
163 //=============================|================================================
164     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
165     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
166     uint256 public rID_;    // round id number / total rounds that have happened
167 //****************
168 // PLAYER DATA
169 //****************
170     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
171     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
172     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
173     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
174     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
175 //****************
176 // ROUND DATA
177 //****************
178     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
179     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
180 //****************
181 // TEAM FEE DATA
182 //****************
183     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
184     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
185 //==============================================================================
186 //     _ _  _  __|_ _    __|_ _  _  .
187 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
188 //==============================================================================
189     constructor()
190         public
191     {
192 		// Team allocation structures
193         // 0 = whales
194         // 1 = bears
195         // 2 = sneks
196         // 3 = bulls
197 
198 		// Team allocation percentages
199         // (F3D) + (Pot , Referrals, Community)
200             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
201         fees_[0] = F3Ddatasets.TeamFee(23,0);   //48% to pot, 18% to aff, 10% to com, 1% to air drop pot
202         fees_[1] = F3Ddatasets.TeamFee(33,0);   //38% to pot, 18% to aff, 10% to com, 1% to air drop pot
203         fees_[2] = F3Ddatasets.TeamFee(53,0);   //18% to pot, 18% to aff, 10% to com, 1% to air drop pot
204         fees_[3] = F3Ddatasets.TeamFee(43,0);   //28% to pot, 18% to aff, 10% to com, 1% to air drop pot
205 
206         // how to split up the final pot based on which team was picked
207         // (F3D)
208         potSplit_[0] = F3Ddatasets.PotSplit(42,0);  //48% to winner, 0% to next round, 10% to com
209         potSplit_[1] = F3Ddatasets.PotSplit(34,0);  //48% to winner, 8% to next round, 10% to com
210         potSplit_[2] = F3Ddatasets.PotSplit(18,0);  //48% to winner, 24% to next round, 10% to com
211         potSplit_[3] = F3Ddatasets.PotSplit(26,0);  //48% to winner, 16% to next round, 10% to com
212 	}
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
226     /**
227      * @dev prevents contracts from interacting with fomo3d
228      */
229     modifier isHuman() {
230         address _addr = msg.sender;
231         uint256 _codeLength;
232 
233         assembly {_codeLength := extcodesize(_addr)}
234         require(_codeLength == 0, "sorry humans only");
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
247 //==============================================================================
248 //     _    |_ |. _   |`    _  __|_. _  _  _  .
249 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
250 //====|=========================================================================
251     /**
252      * @dev emergency buy uses last stored affiliate ID and team snek
253      */
254     function()
255         isActivated()
256         isHuman()
257         isWithinLimits(msg.value)
258         public
259         payable
260     {
261         // set up our tx event data and determine if player is new or not
262         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
263 
264         // fetch player id
265         uint256 _pID = pIDxAddr_[msg.sender];
266 
267         // buy core
268         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
269     }
270 
271     function buyXid(uint256 _affCode, uint256 _team)
272         isActivated()
273         isHuman()
274         isWithinLimits(msg.value)
275         public
276         payable
277     {
278         // set up our tx event data and determine if player is new or not
279         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
280 
281         // fetch player id
282         uint256 _pID = pIDxAddr_[msg.sender];
283 
284         // manage affiliate residuals
285         // if no affiliate code was given or player tried to use their own, lolz
286         if (_affCode == 0 || _affCode == _pID)
287         {
288             // use last stored affiliate code
289             _affCode = plyr_[_pID].laff;
290 
291         // if affiliate code was given & its not the same as previously stored
292         } else if (_affCode != plyr_[_pID].laff) {
293             // update last affiliate
294             plyr_[_pID].laff = _affCode;
295         }
296 
297         // verify a valid team was selected
298         _team = verifyTeam(_team);
299 
300         // buy core
301         buyCore(_pID, _affCode, _team, _eventData_);
302     }
303 
304     function buyXaddr(address _affCode, uint256 _team)
305         isActivated()
306         isHuman()
307         isWithinLimits(msg.value)
308         public
309         payable
310     {
311         // set up our tx event data and determine if player is new or not
312         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
313 
314         // fetch player id
315         uint256 _pID = pIDxAddr_[msg.sender];
316 
317         // manage affiliate residuals
318         uint256 _affID;
319         // if no affiliate code was given or player tried to use their own, lolz
320         if (_affCode == address(0) || _affCode == msg.sender)
321         {
322             // use last stored affiliate code
323             _affID = plyr_[_pID].laff;
324 
325         // if affiliate code was given
326         } else {
327             // get affiliate ID from aff Code
328             _affID = pIDxAddr_[_affCode];
329 
330             // if affID is not the same as previously stored
331             if (_affID != plyr_[_pID].laff)
332             {
333                 // update last affiliate
334                 plyr_[_pID].laff = _affID;
335             }
336         }
337 
338         // verify a valid team was selected
339         _team = verifyTeam(_team);
340 
341         // buy core
342         buyCore(_pID, _affID, _team, _eventData_);
343     }
344 
345     function buyXname(bytes32 _affCode, uint256 _team)
346         isActivated()
347         isHuman()
348         isWithinLimits(msg.value)
349         public
350         payable
351     {
352         // set up our tx event data and determine if player is new or not
353         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
354 
355         // fetch player id
356         uint256 _pID = pIDxAddr_[msg.sender];
357 
358         // manage affiliate residuals
359         uint256 _affID;
360         // if no affiliate code was given or player tried to use their own, lolz
361         if (_affCode == '' || _affCode == plyr_[_pID].name)
362         {
363             // use last stored affiliate code
364             _affID = plyr_[_pID].laff;
365 
366         // if affiliate code was given
367         } else {
368             // get affiliate ID from aff Code
369             _affID = pIDxName_[_affCode];
370 
371             // if affID is not the same as previously stored
372             if (_affID != plyr_[_pID].laff)
373             {
374                 // update last affiliate
375                 plyr_[_pID].laff = _affID;
376             }
377         }
378 
379         // verify a valid team was selected
380         _team = verifyTeam(_team);
381 
382         // buy core
383         buyCore(_pID, _affID, _team, _eventData_);
384     }
385 
386     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
387         isActivated()
388         isHuman()
389         isWithinLimits(_eth)
390         public
391     {
392         // set up our tx event data
393         F3Ddatasets.EventReturns memory _eventData_;
394 
395         // fetch player ID
396         uint256 _pID = pIDxAddr_[msg.sender];
397 
398         // manage affiliate residuals
399         // if no affiliate code was given or player tried to use their own, lolz
400         if (_affCode == 0 || _affCode == _pID)
401         {
402             // use last stored affiliate code
403             _affCode = plyr_[_pID].laff;
404 
405         // if affiliate code was given & its not the same as previously stored
406         } else if (_affCode != plyr_[_pID].laff) {
407             // update last affiliate
408             plyr_[_pID].laff = _affCode;
409         }
410 
411         // verify a valid team was selected
412         _team = verifyTeam(_team);
413 
414         // reload core
415         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
416     }
417 
418     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
419         isActivated()
420         isHuman()
421         isWithinLimits(_eth)
422         public
423     {
424         // set up our tx event data
425         F3Ddatasets.EventReturns memory _eventData_;
426 
427         // fetch player ID
428         uint256 _pID = pIDxAddr_[msg.sender];
429 
430         // manage affiliate residuals
431         uint256 _affID;
432         // if no affiliate code was given or player tried to use their own, lolz
433         if (_affCode == address(0) || _affCode == msg.sender)
434         {
435             // use last stored affiliate code
436             _affID = plyr_[_pID].laff;
437 
438         // if affiliate code was given
439         } else {
440             // get affiliate ID from aff Code
441             _affID = pIDxAddr_[_affCode];
442 
443             // if affID is not the same as previously stored
444             if (_affID != plyr_[_pID].laff)
445             {
446                 // update last affiliate
447                 plyr_[_pID].laff = _affID;
448             }
449         }
450 
451         // verify a valid team was selected
452         _team = verifyTeam(_team);
453 
454         // reload core
455         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
456     }
457 
458     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
459         isActivated()
460         isHuman()
461         isWithinLimits(_eth)
462         public
463     {
464         // set up our tx event data
465         F3Ddatasets.EventReturns memory _eventData_;
466 
467         // fetch player ID
468         uint256 _pID = pIDxAddr_[msg.sender];
469 
470         // manage affiliate residuals
471         uint256 _affID;
472         // if no affiliate code was given or player tried to use their own, lolz
473         if (_affCode == '' || _affCode == plyr_[_pID].name)
474         {
475             // use last stored affiliate code
476             _affID = plyr_[_pID].laff;
477 
478         // if affiliate code was given
479         } else {
480             // get affiliate ID from aff Code
481             _affID = pIDxName_[_affCode];
482 
483             // if affID is not the same as previously stored
484             if (_affID != plyr_[_pID].laff)
485             {
486                 // update last affiliate
487                 plyr_[_pID].laff = _affID;
488             }
489         }
490 
491         // verify a valid team was selected
492         _team = verifyTeam(_team);
493 
494         // reload core
495         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
496     }
497 
498     /**
499      * @dev withdraws all of your earnings.
500      * -functionhash- 0x3ccfd60b
501      */
502     function withdraw()
503         isActivated()
504         isHuman()
505         public
506     {
507         // setup local rID
508         uint256 _rID = rID_;
509 
510         // grab time
511         uint256 _now = now;
512 
513         // fetch player ID
514         uint256 _pID = pIDxAddr_[msg.sender];
515 
516         // setup temp var for player eth
517         uint256 _eth;
518         uint256 _withdrawFee;
519 
520         // check to see if round has ended and no one has run round end yet
521         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
522         {
523             // set up our tx event data
524             F3Ddatasets.EventReturns memory _eventData_;
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
535             {
536                 //10% trade tax
537                 _withdrawFee = _eth / 10;
538                 uint256 _p1 = _withdrawFee / 2;
539                 uint256 _p2 = _withdrawFee / 2;
540                 shareCom.transfer(_p1);
541                 admin.transfer(_p2);
542 
543                 plyr_[_pID].addr.transfer(_eth.sub(_withdrawFee));
544             }
545 
546             // build event data
547             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
548             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
549 
550             // fire withdraw and distribute event
551             emit F3Devents.onWithdrawAndDistribute
552             (
553                 msg.sender,
554                 plyr_[_pID].name,
555                 _eth,
556                 _eventData_.compressedData,
557                 _eventData_.compressedIDs,
558                 _eventData_.winnerAddr,
559                 _eventData_.winnerName,
560                 _eventData_.amountWon,
561                 _eventData_.newPot,
562                 _eventData_.P3DAmount,
563                 _eventData_.genAmount
564             );
565 
566         // in any other situation
567         } else {
568             // get their earnings
569             _eth = withdrawEarnings(_pID);
570 
571             // gib moni
572             if (_eth > 0)
573             {
574                 //10% trade tax
575                 _withdrawFee = _eth / 10;
576                 _p1 = _withdrawFee / 2;
577                 _p2 = _withdrawFee / 2;
578                 shareCom.transfer(_p1);
579                 admin.transfer(_p2);
580 
581                 plyr_[_pID].addr.transfer(_eth.sub(_withdrawFee));
582             }
583 
584             // fire withdraw event
585             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
586         }
587     }
588 
589     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
590         isHuman()
591         public
592         payable
593     {
594         bytes32 _name = _nameString.nameFilter();
595         address _addr = msg.sender;
596         uint256 _paid = msg.value;
597         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
598 
599         uint256 _pID = pIDxAddr_[_addr];
600 
601         // fire event
602         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
603     }
604 
605     function registerNameXaddr(string _nameString, address _affCode, bool _all)
606         isHuman()
607         public
608         payable
609     {
610         bytes32 _name = _nameString.nameFilter();
611         address _addr = msg.sender;
612         uint256 _paid = msg.value;
613         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
614 
615         uint256 _pID = pIDxAddr_[_addr];
616 
617         // fire event
618         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
619     }
620 
621     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
622         isHuman()
623         public
624         payable
625     {
626         bytes32 _name = _nameString.nameFilter();
627         address _addr = msg.sender;
628         uint256 _paid = msg.value;
629         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
630 
631         uint256 _pID = pIDxAddr_[_addr];
632 
633         // fire event
634         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
635     }
636 //==============================================================================
637 //     _  _ _|__|_ _  _ _  .
638 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
639 //=====_|=======================================================================
640     /**
641      * @dev return the price buyer will pay for next 1 individual key.
642      * -functionhash- 0x018a25e8
643      * @return price for next key bought (in wei format)
644      */
645     function getBuyPrice()
646         public
647         view
648         returns(uint256)
649     {
650         // setup local rID
651         uint256 _rID = rID_;
652 
653         // grab time
654         uint256 _now = now;
655 
656         // are we in a round?
657         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
658             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
659         else  // rounds over.  need price for new round
660             return ( 100000000000000 ); // init
661     }
662 
663     /**
664      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
665      * provider
666      * -functionhash- 0xc7e284b8
667      * @return time left in seconds
668      */
669     function getTimeLeft()
670         public
671         view
672         returns(uint256)
673     {
674         // setup local rID
675         uint256 _rID = rID_;
676 
677         // grab time
678         uint256 _now = now;
679 
680         if (_now < round_[_rID].end)
681             if (_now > round_[_rID].strt + rndGap_)
682                 return( (round_[_rID].end).sub(_now) );
683             else
684                 return( (round_[_rID].strt + rndGap_).sub(_now) );
685         else
686             return(0);
687     }
688 
689     function getPlayerVaults(uint256 _pID)
690         public
691         view
692         //win,gen,aff
693         returns(uint256 ,uint256, uint256)
694     {
695         // setup local rID
696         uint256 _rID = rID_;
697 
698         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
699         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
700         {
701             // if player is winner
702             if (round_[_rID].plyr == _pID)
703             {
704                 return
705                 (
706                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
707                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
708                     plyr_[_pID].aff
709                 );
710             // if player is not the winner
711             } else {
712                 return
713                 (
714                     plyr_[_pID].win,
715                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
716                     plyr_[_pID].aff
717                 );
718             }
719 
720         // if round is still going on, or round has ended and round end has been ran
721         } else {
722             return
723             (
724                 plyr_[_pID].win,
725                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
726                 plyr_[_pID].aff
727             );
728         }
729     }
730 
731     /**
732      * solidity hates stack limits.  this lets us avoid that hate
733      */
734     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
735         private
736         view
737         returns(uint256)
738     {
739         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
740     }
741 
742     function getCurrentRoundInfo()
743         public
744         view
745         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
746     {
747         // setup local rID
748         uint256 _rID = rID_;
749 
750         return
751         (
752             round_[_rID].ico,               //0
753             _rID,                           //1
754             round_[_rID].keys,              //2
755             round_[_rID].end,               //3
756             round_[_rID].strt,              //4
757             round_[_rID].pot,               //5
758             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
759             plyr_[round_[_rID].plyr].addr,  //7
760             plyr_[round_[_rID].plyr].name,  //8
761             rndTmEth_[_rID][0],             //9
762             rndTmEth_[_rID][1],             //10
763             rndTmEth_[_rID][2],             //11
764             rndTmEth_[_rID][3],             //12
765             airDropTracker_ + (airDropPot_ * 1000)              //13
766         );
767     }
768 
769     function getPlayerInfoByAddress(address _addr)
770         public
771         view
772         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
773     {
774         // setup local rID
775         uint256 _rID = rID_;
776 
777         if (_addr == address(0))
778         {
779             _addr == msg.sender;
780         }
781         uint256 _pID = pIDxAddr_[_addr];
782 
783         return
784         (
785             _pID,                               //0
786             plyr_[_pID].name,                   //1
787             plyrRnds_[_pID][_rID].keys,         //2
788             plyr_[_pID].win,                    //3
789             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
790             plyr_[_pID].aff,                    //5
791             plyrRnds_[_pID][_rID].eth           //6
792         );
793     }
794 
795 //==============================================================================
796 //     _ _  _ _   | _  _ . _  .
797 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
798 //=====================_|=======================================================
799     /**
800      * @dev logic runs whenever a buy order is executed.  determines how to handle
801      * incoming eth depending on if we are in an active round or not
802      */
803     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
804         private
805     {
806         // setup local rID
807         uint256 _rID = rID_;
808 
809         // grab time
810         uint256 _now = now;
811 
812         // if round is active
813         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
814         {
815             // call core
816             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
817 
818         // if round is not active
819         } else {
820             // check to see if end round needs to be ran
821             if (_now > round_[_rID].end && round_[_rID].ended == false)
822             {
823                 // end the round (distributes pot) & start new round
824 			    round_[_rID].ended = true;
825                 _eventData_ = endRound(_eventData_);
826 
827                 // build event data
828                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
829                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
830 
831                 // fire buy and distribute event
832                 emit F3Devents.onBuyAndDistribute
833                 (
834                     msg.sender,
835                     plyr_[_pID].name,
836                     msg.value,
837                     _eventData_.compressedData,
838                     _eventData_.compressedIDs,
839                     _eventData_.winnerAddr,
840                     _eventData_.winnerName,
841                     _eventData_.amountWon,
842                     _eventData_.newPot,
843                     _eventData_.P3DAmount,
844                     _eventData_.genAmount
845                 );
846             }
847 
848             // put eth in players vault
849             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
850         }
851     }
852 
853     /**
854      * @dev logic runs whenever a reload order is executed.  determines how to handle
855      * incoming eth depending on if we are in an active round or not
856      */
857     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
858         private
859     {
860         // setup local rID
861         uint256 _rID = rID_;
862 
863         // grab time
864         uint256 _now = now;
865 
866         // if round is active
867         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
868         {
869             // get earnings from all vaults and return unused to gen vault
870             // because we use a custom safemath library.  this will throw if player
871             // tried to spend more eth than they have.
872             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
873 
874             // call core
875             core(_rID, _pID, _eth, _affID, _team, _eventData_);
876 
877         // if round is not active and end round needs to be ran
878         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
879             // end the round (distributes pot) & start new round
880             round_[_rID].ended = true;
881             _eventData_ = endRound(_eventData_);
882 
883             // build event data
884             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
885             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
886 
887             // fire buy and distribute event
888             emit F3Devents.onReLoadAndDistribute
889             (
890                 msg.sender,
891                 plyr_[_pID].name,
892                 _eventData_.compressedData,
893                 _eventData_.compressedIDs,
894                 _eventData_.winnerAddr,
895                 _eventData_.winnerName,
896                 _eventData_.amountWon,
897                 _eventData_.newPot,
898                 _eventData_.P3DAmount,
899                 _eventData_.genAmount
900             );
901         }
902     }
903 
904     /**
905      * @dev this is the core logic for any buy/reload that happens while a round
906      * is live.
907      */
908     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
909         private
910     {
911         // if player is new to round
912         if (plyrRnds_[_pID][_rID].keys == 0)
913             _eventData_ = managePlayer(_pID, _eventData_);
914 
915         // if eth left is greater than min eth allowed (sorry no pocket lint)
916         if (_eth > 1000000000)
917         {
918 
919             // mint the new keys
920             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
921 
922             // if they bought at least 1 whole key
923             if (_keys >= 1000000000000000000)
924             {
925                 updateTimer(_keys, _rID);
926 
927                 // set new leaders
928                 if (round_[_rID].plyr != _pID)
929                     round_[_rID].plyr = _pID;
930                 if (round_[_rID].team != _team)
931                     round_[_rID].team = _team;
932 
933                 // set the new leader bool to true
934                 _eventData_.compressedData = _eventData_.compressedData + 100;
935             }
936 
937             // manage airdrops
938             if (_eth >= 100000000000000000)
939             {
940             airDropTracker_++;
941             if (airdrop() == true)
942             {
943                 // gib muni
944                 uint256 _prize;
945                 if (_eth >= 10000000000000000000)
946                 {
947                     // calculate prize and give it to winner
948                     _prize = ((airDropPot_).mul(75)) / 100;
949                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
950 
951                     // adjust airDropPot
952                     airDropPot_ = (airDropPot_).sub(_prize);
953 
954                     // let event know a tier 3 prize was won
955                     _eventData_.compressedData += 300000000000000000000000000000000;
956                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
957                     // calculate prize and give it to winner
958                     _prize = ((airDropPot_).mul(50)) / 100;
959                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
960 
961                     // adjust airDropPot
962                     airDropPot_ = (airDropPot_).sub(_prize);
963 
964                     // let event know a tier 2 prize was won
965                     _eventData_.compressedData += 200000000000000000000000000000000;
966                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
967                     // calculate prize and give it to winner
968                     _prize = ((airDropPot_).mul(25)) / 100;
969                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
970 
971                     // adjust airDropPot
972                     airDropPot_ = (airDropPot_).sub(_prize);
973 
974                     // let event know a tier 3 prize was won
975                     _eventData_.compressedData += 300000000000000000000000000000000;
976                 }
977                 // set airdrop happened bool to true
978                 _eventData_.compressedData += 10000000000000000000000000000000;
979                 // let event know how much was won
980                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
981 
982                 // reset air drop tracker
983                 airDropTracker_ = 0;
984             }
985         }
986 
987             // store the air drop tracker number (number of buys since last airdrop)
988             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
989 
990             // update player
991             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
992             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
993 
994             // update round
995             round_[_rID].keys = _keys.add(round_[_rID].keys);
996             round_[_rID].eth = _eth.add(round_[_rID].eth);
997             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
998 
999             // distribute eth
1000             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1001             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1002 
1003             // call end tx function to fire end tx event.
1004 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1005         }
1006     }
1007 //==============================================================================
1008 //     _ _ | _   | _ _|_ _  _ _  .
1009 //    (_(_||(_|_||(_| | (_)| _\  .
1010 //==============================================================================
1011     /**
1012      * @dev calculates unmasked earnings (just calculates, does not update mask)
1013      * @return earnings in wei format
1014      */
1015     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1016         private
1017         view
1018         returns(uint256)
1019     {
1020         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1021     }
1022 
1023     /**
1024      * @dev returns the amount of keys you would get given an amount of eth.
1025      * -functionhash- 0xce89c80c
1026      * @param _rID round ID you want price for
1027      * @param _eth amount of eth sent in
1028      * @return keys received
1029      */
1030     function calcKeysReceived(uint256 _rID, uint256 _eth)
1031         public
1032         view
1033         returns(uint256)
1034     {
1035         // grab time
1036         uint256 _now = now;
1037 
1038         // are we in a round?
1039         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1040             return ( (round_[_rID].eth).keysRec(_eth) );
1041         else // rounds over.  need keys for new round
1042             return ( (_eth).keys() );
1043     }
1044 
1045     /**
1046      * @dev returns current eth price for X keys.
1047      * -functionhash- 0xcf808000
1048      * @param _keys number of keys desired (in 18 decimal format)
1049      * @return amount of eth needed to send
1050      */
1051     function iWantXKeys(uint256 _keys)
1052         public
1053         view
1054         returns(uint256)
1055     {
1056         // setup local rID
1057         uint256 _rID = rID_;
1058 
1059         // grab time
1060         uint256 _now = now;
1061 
1062         // are we in a round?
1063         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1064             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1065         else // rounds over.  need price for new round
1066             return ( (_keys).eth() );
1067     }
1068 //==============================================================================
1069 //    _|_ _  _ | _  .
1070 //     | (_)(_)|_\  .
1071 //==============================================================================
1072     /**
1073 	 * @dev receives name/player info from names contract
1074      */
1075     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1076         external
1077     {
1078         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1079         if (pIDxAddr_[_addr] != _pID)
1080             pIDxAddr_[_addr] = _pID;
1081         if (pIDxName_[_name] != _pID)
1082             pIDxName_[_name] = _pID;
1083         if (plyr_[_pID].addr != _addr)
1084             plyr_[_pID].addr = _addr;
1085         if (plyr_[_pID].name != _name)
1086             plyr_[_pID].name = _name;
1087         if (plyr_[_pID].laff != _laff)
1088             plyr_[_pID].laff = _laff;
1089         if (plyrNames_[_pID][_name] == false)
1090             plyrNames_[_pID][_name] = true;
1091     }
1092 
1093     /**
1094      * @dev receives entire player name list
1095      */
1096     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1097         external
1098     {
1099         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1100         if(plyrNames_[_pID][_name] == false)
1101             plyrNames_[_pID][_name] = true;
1102     }
1103 
1104     /**
1105      * @dev gets existing or registers new pID.  use this when a player may be new
1106      * @return pID
1107      */
1108     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1109         private
1110         returns (F3Ddatasets.EventReturns)
1111     {
1112         uint256 _pID = pIDxAddr_[msg.sender];
1113         // if player is new to this version of fomo3d
1114         if (_pID == 0)
1115         {
1116             // grab their player ID, name and last aff ID, from player names contract
1117             _pID = PlayerBook.getPlayerID(msg.sender);
1118             bytes32 _name = PlayerBook.getPlayerName(_pID);
1119             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1120 
1121             // set up player account
1122             pIDxAddr_[msg.sender] = _pID;
1123             plyr_[_pID].addr = msg.sender;
1124 
1125             if (_name != "")
1126             {
1127                 pIDxName_[_name] = _pID;
1128                 plyr_[_pID].name = _name;
1129                 plyrNames_[_pID][_name] = true;
1130             }
1131 
1132             if (_laff != 0 && _laff != _pID)
1133                 plyr_[_pID].laff = _laff;
1134 
1135             // set the new player bool to true
1136             _eventData_.compressedData = _eventData_.compressedData + 1;
1137         }
1138         return (_eventData_);
1139     }
1140 
1141     /**
1142      * @dev checks to make sure user picked a valid team.  if not sets team
1143      * to default (sneks)
1144      */
1145     function verifyTeam(uint256 _team)
1146         private
1147         pure
1148         returns (uint256)
1149     {
1150         if (_team < 0 || _team > 3)
1151             return(2);
1152         else
1153             return(_team);
1154     }
1155 
1156     /**
1157      * @dev decides if round end needs to be run & new round started.  and if
1158      * player unmasked earnings from previously played rounds need to be moved.
1159      */
1160     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1161         private
1162         returns (F3Ddatasets.EventReturns)
1163     {
1164         // if player has played a previous round, move their unmasked earnings
1165         // from that round to gen vault.
1166         if (plyr_[_pID].lrnd != 0)
1167             updateGenVault(_pID, plyr_[_pID].lrnd);
1168 
1169         // update player's last round played
1170         plyr_[_pID].lrnd = rID_;
1171 
1172         // set the joined round bool to true
1173         _eventData_.compressedData = _eventData_.compressedData + 10;
1174 
1175         return(_eventData_);
1176     }
1177 
1178     /**
1179      * @dev ends the round. manages paying out winner/splitting up pot
1180      */
1181     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1182         private
1183         returns (F3Ddatasets.EventReturns)
1184     {
1185         // setup local rID
1186         uint256 _rID = rID_;
1187 
1188         // grab our winning player and team id's
1189         uint256 _winPID = round_[_rID].plyr;
1190         uint256 _winTID = round_[_rID].team;
1191 
1192         // grab our pot amount
1193         uint256 _pot = round_[_rID].pot;
1194 
1195         // calculate our winner share, community rewards, gen share,
1196         // p3d share, and amount reserved for next pot
1197         uint256 _win = (_pot.mul(48)) / 100;
1198         uint256 _com = (_pot / 10);
1199         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1200         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1201 
1202         // calculate ppt for round mask
1203         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1204         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1205         if (_dust > 0)
1206         {
1207             _gen = _gen.sub(_dust);
1208             _res = _res.add(_dust);
1209         }
1210 
1211         // pay our winner
1212         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1213 
1214         // community rewards
1215         shareCom.transfer((_com / 2));
1216         admin.transfer((_com / 2));
1217 
1218         // distribute gen portion to key holders
1219         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1220 
1221         // prepare event data
1222         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1223         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1224         _eventData_.winnerAddr = plyr_[_winPID].addr;
1225         _eventData_.winnerName = plyr_[_winPID].name;
1226         _eventData_.amountWon = _win;
1227         _eventData_.genAmount = _gen;
1228         _eventData_.P3DAmount = 0;
1229         _eventData_.newPot = _res;
1230 
1231         // uint256 roundID,
1232         // address winnerAddr,
1233         // bytes32 winnerName,
1234         // uint256 amountWon,
1235         // uint256 newPot
1236 
1237         emit F3Devents.onEndRound
1238         (
1239             _rID,
1240             plyr_[_winPID].addr,
1241             plyr_[_winPID].name,
1242             _win,
1243             _res
1244         );
1245 
1246         // start next round
1247         rID_++;
1248         _rID++;
1249         round_[_rID].strt = now;
1250         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1251         round_[_rID].pot = _res;
1252 
1253         return(_eventData_);
1254     }
1255 
1256     /**
1257      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1258      */
1259     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1260         private
1261     {
1262         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1263         if (_earnings > 0)
1264         {
1265             // put in gen vault
1266             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1267             // zero out their earnings by updating mask
1268             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1269         }
1270     }
1271 
1272     /**
1273      * @dev updates round timer based on number of whole keys bought.
1274      */
1275     function updateTimer(uint256 _keys, uint256 _rID)
1276         private
1277     {
1278         // grab time
1279         uint256 _now = now;
1280 
1281         uint256 _rndInc = rndInc_;
1282 
1283         if(round_[_rID].pot > rndLimit_)
1284         {
1285             _rndInc = _rndInc / 2;
1286         }
1287 
1288         // calculate time based on number of keys bought
1289         uint256 _newTime;
1290         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1291             _newTime = (((_keys) / (1000000000000000000)).mul(_rndInc)).add(_now);
1292         else
1293             _newTime = (((_keys) / (1000000000000000000)).mul(_rndInc)).add(round_[_rID].end);
1294 
1295         // compare to max and set new end time
1296         if (_newTime < (rndMax_).add(_now))
1297             round_[_rID].end = _newTime;
1298         else
1299             round_[_rID].end = rndMax_.add(_now);
1300     }
1301 
1302     /**
1303      * @dev generates a random number between 0-99 and checks to see if thats
1304      * resulted in an airdrop win
1305      * @return do we have a winner?
1306      */
1307     function airdrop()
1308         private
1309         view
1310         returns(bool)
1311     {
1312         uint256 seed = uint256(keccak256(abi.encodePacked(
1313 
1314             (block.timestamp).add
1315             (block.difficulty).add
1316             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1317             (block.gaslimit).add
1318             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1319             (block.number)
1320 
1321         )));
1322         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1323             return(true);
1324         else
1325             return(false);
1326     }
1327 
1328     /**
1329      * @dev distributes eth based on fees to com, aff, and p3d
1330      */
1331     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1332         private
1333         returns(F3Ddatasets.EventReturns)
1334     {
1335          // pay community rewards
1336         uint256 _com = _eth / 10;
1337         uint256 _p3d;
1338 
1339         if (address(admin).call.value((_com / 2))() == false)
1340         {
1341             _p3d = _com / 2;
1342             _com = _com / 2;
1343         }
1344 
1345         if (address(shareCom).call.value((_com / 2))() == false)
1346         {
1347             _p3d += (_com / 2);
1348             _com = _com.sub(_com / 2);
1349         }
1350 
1351         // pay 1% out to FoMo3D short
1352         // uint256 _long = _eth / 100;
1353         // otherF3D_.potSwap.value(_long)();
1354 
1355         _p3d = _p3d.add(distributeAff(_rID,_pID,_eth,_affID));
1356 
1357         // pay out p3d
1358         // _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1359         if (_p3d > 0)
1360         {
1361             // deposit to divies contract
1362             uint256 _potAmount = _p3d / 2;
1363             uint256 _amount = _p3d.sub(_potAmount);
1364 
1365             shareCom.transfer((_amount / 2));
1366             admin.transfer((_amount / 2));
1367 
1368             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1369 
1370             // set up event data
1371             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1372         }
1373 
1374         return(_eventData_);
1375     }
1376 
1377     function distributeAff(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
1378         private
1379         returns(uint256)
1380     {
1381         uint256 _addP3d = 0;
1382 
1383         // distribute share to affiliate
1384         uint256 _aff1 = _eth / 10;
1385         uint256 _aff2 = _eth / 20;
1386         uint256 _aff3 = _eth / 34;
1387 
1388         groupCut.transfer(_aff1);
1389 
1390         // decide what to do with affiliate share of fees
1391         // affiliate must not be self, and must have a name registered
1392         if ((_affID != 0) && (_affID != _pID) && (plyr_[_affID].name != ''))
1393         {
1394             plyr_[_pID].laffID = _affID;
1395             plyr_[_affID].aff = _aff2.add(plyr_[_affID].aff);
1396 
1397             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff2, now);
1398 
1399             //second level aff
1400             uint256 _secLaff = plyr_[_affID].laffID;
1401             if((_secLaff != 0) && (_secLaff != _pID))
1402             {
1403                 plyr_[_secLaff].aff = _aff3.add(plyr_[_secLaff].aff);
1404                 emit F3Devents.onAffiliatePayout(_secLaff, plyr_[_secLaff].addr, plyr_[_secLaff].name, _rID, _pID, _aff3, now);
1405             } else {
1406                 _addP3d = _addP3d.add(_aff3);
1407             }
1408         } else {
1409             _addP3d = _addP3d.add(_aff2);
1410         }
1411         return(_addP3d);
1412     }
1413 
1414     function getPlayerAff(uint256 _pID)
1415         public
1416         view
1417         returns (uint256,uint256,uint256)
1418     {
1419         uint256 _affID = plyr_[_pID].laffID;
1420         if (_affID != 0)
1421         {
1422             //second level aff
1423             uint256 _secondLaff = plyr_[_affID].laffID;
1424 
1425             if(_secondLaff != 0)
1426             {
1427                 //third level aff
1428                 uint256 _thirdAff = plyr_[_secondLaff].laffID;
1429             }
1430         }
1431         return (_affID,_secondLaff,_thirdAff);
1432     }
1433 
1434     function potSwap()
1435         external
1436         payable
1437     {
1438         // setup local rID
1439         uint256 _rID = rID_ + 1;
1440 
1441         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1442         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1443     }
1444 
1445     /**
1446      * @dev distributes eth based on fees to gen and pot
1447      */
1448     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1449         private
1450         returns(F3Ddatasets.EventReturns)
1451     {
1452         // calculate gen share
1453         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1454 
1455         // toss 1% into airdrop pot
1456         uint256 _air = (_eth / 100);
1457         airDropPot_ = airDropPot_.add(_air);
1458 
1459         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1460         //_eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1461         _eth = _eth.sub(_eth.mul(29) / 100);
1462 
1463         // calculate pot
1464         uint256 _pot = _eth.sub(_gen);
1465 
1466         // distribute gen share (thats what updateMasks() does) and adjust
1467         // balances for dust.
1468         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1469         if (_dust > 0)
1470             _gen = _gen.sub(_dust);
1471 
1472         // add eth to pot
1473         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1474 
1475         // set up event data
1476         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1477         _eventData_.potAmount = _pot;
1478 
1479         return(_eventData_);
1480     }
1481 
1482     /**
1483      * @dev updates masks for round and player when keys are bought
1484      * @return dust left over
1485      */
1486     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1487         private
1488         returns(uint256)
1489     {
1490         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1491         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1492         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1493 
1494         // calculate player earning from their own buy (only based on the keys
1495         // they just bought).  & update player earnings mask
1496         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1497         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1498 
1499         // calculate & return dust
1500         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1501     }
1502 
1503     /**
1504      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1505      * @return earnings in wei format
1506      */
1507     function withdrawEarnings(uint256 _pID)
1508         private
1509         returns(uint256)
1510     {
1511         // update gen vault
1512         updateGenVault(_pID, plyr_[_pID].lrnd);
1513 
1514         // from vaults
1515         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1516         if (_earnings > 0)
1517         {
1518             plyr_[_pID].win = 0;
1519             plyr_[_pID].gen = 0;
1520             plyr_[_pID].aff = 0;
1521         }
1522 
1523         return(_earnings);
1524     }
1525 
1526     /**
1527      * @dev prepares compression data and fires event for buy or reload tx's
1528      */
1529     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1530         private
1531     {
1532         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1533         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1534 
1535         emit F3Devents.onEndTx
1536         (
1537             _eventData_.compressedData,
1538             _eventData_.compressedIDs,
1539             plyr_[_pID].name,
1540             msg.sender,
1541             _eth,
1542             _keys,
1543             _eventData_.winnerAddr,
1544             _eventData_.winnerName,
1545             _eventData_.amountWon,
1546             _eventData_.newPot,
1547             _eventData_.P3DAmount,
1548             _eventData_.genAmount,
1549             _eventData_.potAmount,
1550             airDropPot_
1551         );
1552     }
1553 //==============================================================================
1554 //    (~ _  _    _._|_    .
1555 //    _)(/_(_|_|| | | \/  .
1556 //====================/=========================================================
1557     /** upon contract deploy, it will be deactivated.  this is a one time
1558      * use function that will activate the contract.  we do this so devs
1559      * have time to set things up on the web end                            **/
1560     bool public activated_ = false;
1561     function activate()
1562         public
1563     {
1564         // only team just can activate
1565         require(msg.sender == admin, "only admin can activate");
1566 
1567 
1568         // can only be ran once
1569         require(activated_ == false, "FOMO Short already activated");
1570 
1571         // activate the contract
1572         activated_ = true;
1573 
1574         // lets start first round
1575         rID_ = 1;
1576         round_[1].strt = now + rndExtra_ - rndGap_;
1577         round_[1].end = now + rndInit_ + rndExtra_;
1578     }
1579 }
1580 
1581 //==============================================================================
1582 //   __|_ _    __|_ _  .
1583 //  _\ | | |_|(_ | _\  .
1584 //==============================================================================
1585 library F3Ddatasets {
1586     //compressedData key
1587     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1588         // 0 - new player (bool)
1589         // 1 - joined round (bool)
1590         // 2 - new  leader (bool)
1591         // 3-5 - air drop tracker (uint 0-999)
1592         // 6-16 - round end time
1593         // 17 - winnerTeam
1594         // 18 - 28 timestamp
1595         // 29 - team
1596         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1597         // 31 - airdrop happened bool
1598         // 32 - airdrop tier
1599         // 33 - airdrop amount won
1600     //compressedIDs key
1601     // [77-52][51-26][25-0]
1602         // 0-25 - pID
1603         // 26-51 - winPID
1604         // 52-77 - rID
1605     struct EventReturns {
1606         uint256 compressedData;
1607         uint256 compressedIDs;
1608         address winnerAddr;         // winner address
1609         bytes32 winnerName;         // winner name
1610         uint256 amountWon;          // amount won
1611         uint256 newPot;             // amount in new pot
1612         uint256 P3DAmount;          // amount distributed to p3d
1613         uint256 genAmount;          // amount distributed to gen
1614         uint256 potAmount;          // amount added to pot
1615     }
1616     struct Player {
1617         address addr;   // player address
1618         bytes32 name;   // player name
1619         uint256 win;    // winnings vault
1620         uint256 gen;    // general vault
1621         uint256 aff;    // affiliate vault
1622         uint256 lrnd;   // last round played
1623         uint256 laff;   // last affiliate id used
1624         uint256 laffID;   // last affiliate id unaffected
1625     }
1626     struct PlayerRounds {
1627         uint256 eth;    // eth player has added to round (used for eth limiter)
1628         uint256 keys;   // keys
1629         uint256 mask;   // player mask
1630         uint256 ico;    // ICO phase investment
1631     }
1632     struct Round {
1633         uint256 plyr;   // pID of player in lead
1634         uint256 team;   // tID of team in lead
1635         uint256 end;    // time ends/ended
1636         bool ended;     // has round end function been ran
1637         uint256 strt;   // time round started
1638         uint256 keys;   // keys
1639         uint256 eth;    // total eth in
1640         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1641         uint256 mask;   // global mask
1642         uint256 ico;    // total eth sent in during ICO phase
1643         uint256 icoGen; // total eth for gen during ICO phase
1644         uint256 icoAvg; // average key price for ICO phase
1645     }
1646     struct TeamFee {
1647         uint256 gen;    // % of buy in thats paid to key holders of current round
1648         uint256 p3d;    // % of buy in thats paid to p3d holders
1649     }
1650     struct PotSplit {
1651         uint256 gen;    // % of pot thats paid to key holders of current round
1652         uint256 p3d;    // % of pot thats paid to p3d holders
1653     }
1654 }
1655 
1656 //==============================================================================
1657 //  |  _      _ _ | _  .
1658 //  |<(/_\/  (_(_||(_  .
1659 //=======/======================================================================
1660 library F3DKeysCalcShort {
1661     using SafeMath for *;
1662     /**
1663      * @dev calculates number of keys received given X eth
1664      * @param _curEth current amount of eth in contract
1665      * @param _newEth eth being spent
1666      * @return amount of ticket purchased
1667      */
1668     function keysRec(uint256 _curEth, uint256 _newEth)
1669         internal
1670         pure
1671         returns (uint256)
1672     {
1673         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1674     }
1675 
1676     /**
1677      * @dev calculates amount of eth received if you sold X keys
1678      * @param _curKeys current amount of keys that exist
1679      * @param _sellKeys amount of keys you wish to sell
1680      * @return amount of eth received
1681      */
1682     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1683         internal
1684         pure
1685         returns (uint256)
1686     {
1687         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1688     }
1689 
1690      /**
1691      * @dev calculates how many keys would exist with given an amount of eth
1692      * @param _eth eth "in contract"
1693      * @return number of keys that would exist
1694      */
1695     function keys(uint256 _eth)
1696         internal
1697         pure
1698         returns(uint256)
1699     {
1700         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1701     }
1702 
1703     /**
1704      * @dev calculates how much eth would be in contract given a number of keys
1705      * @param _keys number of keys "in contract"
1706      * @return eth that would exists
1707      */
1708     function eth(uint256 _keys)
1709         internal
1710         pure
1711         returns(uint256)
1712     {
1713         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1714     }
1715 }
1716 
1717 //==============================================================================
1718 //  . _ _|_ _  _ |` _  _ _  _  .
1719 //  || | | (/_| ~|~(_|(_(/__\  .
1720 //==============================================================================
1721 
1722 interface PlayerBookInterface {
1723     function getPlayerID(address _addr) external returns (uint256);
1724     function getPlayerName(uint256 _pID) external view returns (bytes32);
1725     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1726     function getPlayerAddr(uint256 _pID) external view returns (address);
1727     function getNameFee() external view returns (uint256);
1728     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1729     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1730     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1731 }
1732 
1733 library NameFilter {
1734 
1735     function nameFilter(string _input)
1736         internal
1737         pure
1738         returns(bytes32)
1739     {
1740         bytes memory _temp = bytes(_input);
1741         uint256 _length = _temp.length;
1742 
1743         //sorry limited to 32 characters
1744         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1745         // make sure it doesnt start with or end with space
1746         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1747         // make sure first two characters are not 0x
1748         if (_temp[0] == 0x30)
1749         {
1750             require(_temp[1] != 0x78, "string cannot start with 0x");
1751             require(_temp[1] != 0x58, "string cannot start with 0X");
1752         }
1753 
1754         // create a bool to track if we have a non number character
1755         bool _hasNonNumber;
1756 
1757         // convert & check
1758         for (uint256 i = 0; i < _length; i++)
1759         {
1760             // if its uppercase A-Z
1761             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1762             {
1763                 // convert to lower case a-z
1764                 _temp[i] = byte(uint(_temp[i]) + 32);
1765 
1766                 // we have a non number
1767                 if (_hasNonNumber == false)
1768                     _hasNonNumber = true;
1769             } else {
1770                 require
1771                 (
1772                     // require character is a space
1773                     _temp[i] == 0x20 ||
1774                     // OR lowercase a-z
1775                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1776                     // or 0-9
1777                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1778                     "string contains invalid characters"
1779                 );
1780                 // make sure theres not 2x spaces in a row
1781                 if (_temp[i] == 0x20)
1782                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1783 
1784                 // see if we have a character other than a number
1785                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1786                     _hasNonNumber = true;
1787             }
1788         }
1789 
1790         require(_hasNonNumber == true, "string cannot be only numbers");
1791 
1792         bytes32 _ret;
1793         assembly {
1794             _ret := mload(add(_temp, 32))
1795         }
1796         return (_ret);
1797     }
1798 }
1799 
1800 
1801 library SafeMath {
1802 
1803     /**
1804     * @dev Multiplies two numbers, throws on overflow.
1805     */
1806     function mul(uint256 a, uint256 b)
1807         internal
1808         pure
1809         returns (uint256 c)
1810     {
1811         if (a == 0) {
1812             return 0;
1813         }
1814         c = a * b;
1815         require(c / a == b, "SafeMath mul failed");
1816         return c;
1817     }
1818 
1819     /**
1820     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1821     */
1822     function sub(uint256 a, uint256 b)
1823         internal
1824         pure
1825         returns (uint256)
1826     {
1827         require(b <= a, "SafeMath sub failed");
1828         return a - b;
1829     }
1830 
1831     /**
1832     * @dev Adds two numbers, throws on overflow.
1833     */
1834     function add(uint256 a, uint256 b)
1835         internal
1836         pure
1837         returns (uint256 c)
1838     {
1839         c = a + b;
1840         require(c >= a, "SafeMath add failed");
1841         return c;
1842     }
1843 
1844     /**
1845      * @dev gives square root of given x.
1846      */
1847     function sqrt(uint256 x)
1848         internal
1849         pure
1850         returns (uint256 y)
1851     {
1852         uint256 z = ((add(x,1)) / 2);
1853         y = x;
1854         while (z < y)
1855         {
1856             y = z;
1857             z = ((add((x / z),z)) / 2);
1858         }
1859     }
1860 
1861     /**
1862      * @dev gives square. multiplies x by x
1863      */
1864     function sq(uint256 x)
1865         internal
1866         pure
1867         returns (uint256)
1868     {
1869         return (mul(x,x));
1870     }
1871 
1872     /**
1873      * @dev x to the power of y
1874      */
1875     function pwr(uint256 x, uint256 y)
1876         internal
1877         pure
1878         returns (uint256)
1879     {
1880         if (x==0)
1881             return (0);
1882         else if (y==0)
1883             return (1);
1884         else
1885         {
1886             uint256 z = x;
1887             for (uint256 i=1; i < y; i++)
1888                 z = mul(z,x);
1889             return (z);
1890         }
1891     }
1892 }