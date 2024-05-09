1 pragma solidity ^0.4.24;
2 
3 library NameFilter {
4     /**
5      * @dev filters name strings
6      * -converts uppercase to lower case.
7      * -makes sure it does not start/end with a space
8      * -makes sure it does not contain multiple spaces in a row
9      * -cannot be only numbers
10      * -cannot start with 0x
11      * -restricts characters to A-Z, a-z, 0-9, and space.
12      * @return reprocessed string in bytes32 format
13      */
14     function nameFilter(string _input)
15         internal
16         pure
17         returns(bytes32)
18     {
19         bytes memory _temp = bytes(_input);
20         uint256 _length = _temp.length;
21 
22         //sorry limited to 32 characters
23         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
24         // make sure it doesnt start with or end with space
25         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
26         // make sure first two characters are not 0x
27         if (_temp[0] == 0x30)
28         {
29             require(_temp[1] != 0x78, "string cannot start with 0x");
30             require(_temp[1] != 0x58, "string cannot start with 0X");
31         }
32 
33         // create a bool to track if we have a non number character
34         bool _hasNonNumber;
35 
36         // convert & check
37         for (uint256 i = 0; i < _length; i++)
38         {
39             // if its uppercase A-Z
40             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
41             {
42                 // convert to lower case a-z
43                 _temp[i] = byte(uint(_temp[i]) + 32);
44 
45                 // we have a non number
46                 if (_hasNonNumber == false)
47                     _hasNonNumber = true;
48             } else {
49                 require
50                 (
51                     // require character is a space
52                     _temp[i] == 0x20 ||
53                     // OR lowercase a-z
54                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
55                     // or 0-9
56                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
57                     "string contains invalid characters"
58                 );
59                 // make sure theres not 2x spaces in a row
60                 if (_temp[i] == 0x20)
61                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
62 
63                 // see if we have a character other than a number
64                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
65                     _hasNonNumber = true;
66             }
67         }
68 
69         require(_hasNonNumber == true, "string cannot be only numbers");
70 
71         bytes32 _ret;
72         assembly {
73             _ret := mload(add(_temp, 32))
74         }
75         return (_ret);
76     }
77 }
78 
79 /**
80  * @title SafeMath v0.1.9
81  * @dev Math operations with safety checks that throw on error
82  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
83  * - added sqrt
84  * - added sq
85  * - added pwr
86  * - changed asserts to requires with error log outputs
87  * - removed div, its useless
88  */
89 library SafeMath {
90 
91     /**
92     * @dev Multiplies two numbers, throws on overflow.
93     */
94     function mul(uint256 a, uint256 b)
95         internal
96         pure
97         returns (uint256 c)
98     {
99         if (a == 0) {
100             return 0;
101         }
102         c = a * b;
103         require(c / a == b, "SafeMath mul failed");
104         return c;
105     }
106 
107     /**
108     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
109     */
110     function sub(uint256 a, uint256 b)
111         internal
112         pure
113         returns (uint256)
114     {
115         require(b <= a, "SafeMath sub failed");
116         return a - b;
117     }
118 
119     /**
120     * @dev Adds two numbers, throws on overflow.
121     */
122     function add(uint256 a, uint256 b)
123         internal
124         pure
125         returns (uint256 c)
126     {
127         c = a + b;
128         require(c >= a, "SafeMath add failed");
129         return c;
130     }
131 
132     /**
133      * @dev gives square root of given x.
134      */
135     function sqrt(uint256 x)
136         internal
137         pure
138         returns (uint256 y)
139     {
140         uint256 z = ((add(x,1)) / 2);
141         y = x;
142         while (z < y)
143         {
144             y = z;
145             z = ((add((x / z),z)) / 2);
146         }
147     }
148 
149     /**
150      * @dev gives square. multiplies x by x
151      */
152     function sq(uint256 x)
153         internal
154         pure
155         returns (uint256)
156     {
157         return (mul(x,x));
158     }
159 
160     /**
161      * @dev x to the power of y
162      */
163     function pwr(uint256 x, uint256 y)
164         internal
165         pure
166         returns (uint256)
167     {
168         if (x==0)
169             return (0);
170         else if (y==0)
171             return (1);
172         else
173         {
174             uint256 z = x;
175             for (uint256 i=1; i < y; i++)
176                 z = mul(z,x);
177             return (z);
178         }
179     }
180 }
181 
182 
183 
184 //==============================================================================
185 //   __|_ _    __|_ _  .
186 //  _\ | | |_|(_ | _\  .
187 //==============================================================================
188 library F3Ddatasets {
189     //compressedData key
190     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
191         // 0 - new player (bool)
192         // 1 - joined round (bool)
193         // 2 - new  leader (bool)
194         // 3-5 - air drop tracker (uint 0-999)
195         // 6-16 - round end time
196         // 17 - winnerTeam
197         // 18 - 28 timestamp
198         // 29 - team
199         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
200         // 31 - airdrop happened bool
201         // 32 - airdrop tier
202         // 33 - airdrop amount won
203         
204     //compressedIDs key
205     // [77-52][51-26][25-0]
206         // 0-25 - pID
207         // 26-51 - winPID
208         // 52-77 - rID
209     struct EventReturns {
210         uint256 compressedData;
211         uint256 compressedIDs;
212         address winnerAddr;         // winner address
213         bytes32 winnerName;         // winner name
214         uint256 amountWon;          // amount won
215         uint256 newPot;             // amount in new pot
216         uint256 P3DAmount;          // amount distributed to p3d
217         uint256 genAmount;          // amount distributed to gen
218         uint256 potAmount;          // amount added to pot
219     }
220     struct Player {
221         address addr;   // player address
222         bytes32 name;   // player name
223         uint256 win;    // winnings vault
224         uint256 gen;    // general vault
225         uint256 aff;    // affiliate vault
226         uint256 lrnd;   // last round played
227         uint256 laff;   // last affiliate id used
228     }
229     struct PlayerRounds {
230         uint256 eth;    // eth player has added to round (used for eth limiter)
231         uint256 keys;   // keys
232         uint256 mask;   // player mask
233         uint256 ico;    // ICO phase investment
234     }
235     struct Round {
236         uint256 plyr;   // pID of player in lead
237         uint256 team;   // tID of team in lead
238         uint256 end;    // time ends/ended
239         bool ended;     // has round end function been ran
240         uint256 strt;   // time round started
241         uint256 keys;   // keys
242         uint256 eth;    // total eth in
243         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
244         uint256 mask;   // global mask
245         uint256 ico;    // total eth sent in during ICO phase
246         uint256 icoGen; // total eth for gen during ICO phase
247         uint256 icoAvg; // average key price for ICO phase
248     }
249     struct TeamFee {
250         uint256 gen;    // % of buy in thats paid to key holders of current round
251         uint256 p3d;    // % of buy in thats paid to p3d holders
252     }
253     struct PotSplit {
254         uint256 gen;    // % of pot thats paid to key holders of current round
255         uint256 p3d;    // % of pot thats paid to p3d holders
256     }
257 }
258 
259 //==============================================================================
260 //  |  _      _ _ | _  .
261 //  |<(/_\/  (_(_||(_  .
262 //=======/======================================================================
263 library F3DKeysCalcShort {
264     using SafeMath for *;
265     /**
266      * @dev calculates number of keys received given X eth
267      * @param _curEth current amount of eth in contract
268      * @param _newEth eth being spent
269      * @return amount of ticket purchased
270      */
271     function keysRec(uint256 _curEth, uint256 _newEth)
272         internal
273         pure
274         returns (uint256)
275     {
276         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
277     }
278 
279     /**
280      * @dev calculates amount of eth received if you sold X keys
281      * @param _curKeys current amount of keys that exist
282      * @param _sellKeys amount of keys you wish to sell
283      * @return amount of eth received
284      */
285     function ethRec(uint256 _curKeys, uint256 _sellKeys)
286         internal
287         pure
288         returns (uint256)
289     {
290         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
291     }
292 
293     /**
294      * @dev calculates how many keys would exist with given an amount of eth
295      * @param _eth eth "in contract"
296      * @return number of keys that would exist
297      */
298     function keys(uint256 _eth)
299         internal
300         pure
301         returns(uint256)
302     {
303         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
304     }
305 
306     /**
307      * @dev calculates how much eth would be in contract given a number of keys
308      * @param _keys number of keys "in contract"
309      * @return eth that would exists
310      */
311     function eth(uint256 _keys)
312         internal
313         pure
314         returns(uint256)
315     {
316         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
317     }
318 }
319 
320 //==============================================================================
321 //  . _ _|_ _  _ |` _  _ _  _  .
322 //  || | | (/_| ~|~(_|(_(/__\  .
323 //==============================================================================
324 
325 
326 contract F3Devents {
327     // fired whenever a player registers a name
328     event onNewName
329     (
330         uint256 indexed playerID,
331         address indexed playerAddress,
332         bytes32 indexed playerName,
333         bool isNewPlayer,
334         uint256 affiliateID,
335         address affiliateAddress,
336         bytes32 affiliateName,
337         uint256 amountPaid,
338         uint256 timeStamp
339     );
340 
341     // fired at end of buy or reload
342     event onEndTx
343     (
344         uint256 compressedData,
345         uint256 compressedIDs,
346         bytes32 playerName,
347         address playerAddress,
348         uint256 ethIn,
349         uint256 keysBought,
350         address winnerAddr,
351         bytes32 winnerName,
352         uint256 amountWon,
353         uint256 newPot,
354         uint256 P3DAmount,
355         uint256 genAmount,
356         uint256 potAmount,
357         uint256 airDropPot
358     );
359 
360 	// fired whenever theres a withdraw
361     event onWithdraw
362     (
363         uint256 indexed playerID,
364         address playerAddress,
365         bytes32 playerName,
366         uint256 ethOut,
367         uint256 timeStamp
368     );
369 
370     // fired whenever a withdraw forces end round to be ran
371     event onWithdrawAndDistribute
372     (
373         address playerAddress,
374         bytes32 playerName,
375         uint256 ethOut,
376         uint256 compressedData,
377         uint256 compressedIDs,
378         address winnerAddr,
379         bytes32 winnerName,
380         uint256 amountWon,
381         uint256 newPot,
382         uint256 P3DAmount,
383         uint256 genAmount
384     );
385 
386     // (fomo3d short only) fired whenever a player tries a buy after round timer
387     // hit zero, and causes end round to be ran.
388     event onBuyAndDistribute
389     (
390         address playerAddress,
391         bytes32 playerName,
392         uint256 ethIn,
393         uint256 compressedData,
394         uint256 compressedIDs,
395         address winnerAddr,
396         bytes32 winnerName,
397         uint256 amountWon,
398         uint256 newPot,
399         uint256 P3DAmount,
400         uint256 genAmount
401     );
402 
403     // (fomo3d short only) fired whenever a player tries a reload after round timer
404     // hit zero, and causes end round to be ran.
405     event onReLoadAndDistribute
406     (
407         address playerAddress,
408         bytes32 playerName,
409         uint256 compressedData,
410         uint256 compressedIDs,
411         address winnerAddr,
412         bytes32 winnerName,
413         uint256 amountWon,
414         uint256 newPot,
415         uint256 P3DAmount,
416         uint256 genAmount
417     );
418 
419     // fired whenever an affiliate is paid
420     event onAffiliatePayout
421     (
422         uint256 indexed affiliateID,
423         address affiliateAddress,
424         bytes32 affiliateName,
425         uint256 indexed roundID,
426         uint256 indexed buyerID,
427         uint256 amount,
428         uint256 timeStamp
429     );
430 
431     // received pot swap deposit
432     event onPotSwapDeposit
433     (
434         uint256 roundID,
435         uint256 amountAddedToPot
436     );
437 }
438 
439 
440 
441 
442 interface PlayerBookInterface {
443     function getPlayerID(address _addr) external returns (uint256);
444     function getPlayerName(uint256 _pID) external view returns (bytes32);
445     function getPlayerLAff(uint256 _pID) external view returns (uint256);
446     function getPlayerAddr(uint256 _pID) external view returns (address);
447     function getNameFee() external view returns (uint256);
448     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
449     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
450     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
451 }
452 
453 
454 
455 contract modularFast is F3Devents {}
456 
457 
458 contract FoMo3DFast is modularFast {
459     using SafeMath for *;
460     using NameFilter for string;
461     using F3DKeysCalcShort for uint256;
462 
463     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x990116637aa0e6fBf1549908C079385a38A1B4bC);
464 
465     address private admin = msg.sender;
466     string constant public name = "OTION";
467     string constant public symbol = "OTION";
468     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
469     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
470     uint256 constant private rndInit_ = 888 minutes;                // round timer starts at this
471     uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
472     uint256 constant private rndMax_ = 888 minutes;                // max length a round timer can be
473     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
474     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
475     uint256 public rID_;    // round id number / total rounds that have happened
476     //****************
477     // PLAYER DATA
478     //****************
479     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
480     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
481     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
482     // (pID => rID => data) player round data by player id & round id
483     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
484     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
485     //****************
486     // ROUND DATA
487     //****************
488     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
489     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
490     //****************
491     // TEAM FEE DATA
492     //****************
493     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
494     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
495 
496     constructor()
497         public
498     {
499     // Team allocation structures
500         // 0 = the only team
501         
502 
503     // Team allocation percentages
504         // (F3D, P3D) + (Pot , Referrals, Community)  解读:TeamFee, PotSplit 第一个参数都是分给现在key holder的比例, 第二个是给Pow3D的比例
505             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
506         fees_[0] = F3Ddatasets.TeamFee(80,0);   //10% to pot, 8% to aff, 2% to com
507 
508         // how to split up the final pot based on which team was picked
509         // (F3D, P3D)
510         potSplit_[0] = F3Ddatasets.PotSplit(0,0);  //100% to winner
511     }
512     //==============================================================================
513     //     _ _  _  _|. |`. _  _ _  .
514     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
515     //==============================================================================
516     /**
517     * @dev used to make sure no one can interact with contract until it has
518     * been activated.
519     */
520     modifier isActivated() {
521         require(activated_ == true, "its not ready yet.  check ?eta in discord");
522         _;
523     }
524 
525     /**
526     * @dev prevents contracts from interacting with fomo3d
527     */
528     modifier isHuman() {
529         address _addr = msg.sender;
530         uint256 _codeLength;
531 
532         assembly {_codeLength := extcodesize(_addr)}
533         require(_codeLength == 0, "sorry humans only");
534         _;
535     }
536 
537     /**
538     * @dev sets boundaries for incoming tx
539     */
540     modifier isWithinLimits(uint256 _eth) {
541         require(_eth >= 1000000000, "pocket lint: not a valid currency");
542         _;
543     }
544 
545     //==============================================================================
546     //     _    |_ |. _   |`    _  __|_. _  _  _  .
547     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
548     //====|=========================================================================
549     /**
550     * @dev emergency buy uses last stored affiliate ID and team snek
551     */
552     function()
553         isActivated()
554         isHuman()
555         isWithinLimits(msg.value)
556         public
557         payable
558     {
559         // set up our tx event data and determine if player is new or not
560         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
561 
562         // fetch player id
563         uint256 _pID = pIDxAddr_[msg.sender];
564 
565         // buy core
566         buyCore(_pID, _eventData_);
567     }
568 
569 
570 
571     function buyXnameQR(address _realSender)
572         isActivated()
573         isWithinLimits(msg.value)
574         public
575         payable
576     {
577         // set up our tx event data and determine if player is new or not
578         F3Ddatasets.EventReturns memory _eventData_ = determinePIDQR(_realSender,_eventData_);
579 
580         // fetch player id
581         uint256 _pID = pIDxAddr_[_realSender];
582 
583         // // manage affiliate residuals
584         // uint256 _affID = 1;
585         
586         // // verify a valid team was selected
587         // uint256 _team = 0;
588 
589         // buy core
590         buyCoreQR(_realSender, _pID, _eventData_);
591     }
592 
593     /**
594     * @dev withdraws all of your earnings.
595     * -functionhash- 0x3ccfd60b
596     */
597     function withdraw()
598         isActivated()
599         isHuman()
600         public
601     {
602         // setup local rID
603         uint256 _rID = rID_;
604 
605         // grab time
606         uint256 _now = now;
607 
608         // fetch player ID
609         uint256 _pID = pIDxAddr_[msg.sender];
610 
611         // setup temp var for player eth
612         uint256 _eth;
613 
614         // check to see if round has ended and no one has run round end yet
615         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
616         {
617             // set up our tx event data
618             F3Ddatasets.EventReturns memory _eventData_;
619 
620             // end the round (distributes pot)
621             round_[_rID].ended = true;
622             _eventData_ = endRound(_eventData_);
623 
624             // get their earnings
625             _eth = withdrawEarnings(_pID);
626 
627             // gib moni
628             if (_eth > 0)
629                 plyr_[_pID].addr.transfer(_eth);
630 
631             // build event data
632             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
633             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
634 
635             // fire withdraw and distribute event
636             emit F3Devents.onWithdrawAndDistribute
637             (
638                 msg.sender,
639                 plyr_[_pID].name,
640                 _eth,
641                 _eventData_.compressedData,
642                 _eventData_.compressedIDs,
643                 _eventData_.winnerAddr,
644                 _eventData_.winnerName,
645                 _eventData_.amountWon,
646                 _eventData_.newPot,
647                 _eventData_.P3DAmount,
648                 _eventData_.genAmount
649             );
650 
651         // in any other situation
652         } else {
653             // get their earnings
654             _eth = withdrawEarnings(_pID);
655 
656             // gib moni
657             if (_eth > 0)
658                 plyr_[_pID].addr.transfer(_eth);
659 
660             // fire withdraw event
661             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
662         }
663     }
664 
665     /**
666     * @dev withdraws all of your earnings.
667     * -functionhash- 0x3ccfd60b
668     */
669     function withdrawQR(address _realSender)
670         isActivated()
671         payable
672         public
673     {
674         // setup local rID
675         uint256 _rID = rID_;
676 
677         // grab time
678         uint256 _now = now;
679 
680         // fetch player ID
681         uint256 _pID = pIDxAddr_[_realSender];
682 
683         // setup temp var for player eth
684         uint256 _eth;
685 
686         // check to see if round has ended and no one has run round end yet
687         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
688         {
689             // set up our tx event data
690             F3Ddatasets.EventReturns memory _eventData_;
691 
692             // end the round (distributes pot)
693             round_[_rID].ended = true;
694             _eventData_ = endRound(_eventData_);
695 
696             // get their earnings
697             _eth = withdrawEarnings(_pID);
698 
699             // gib moni
700             if (_eth > 0)
701                 plyr_[_pID].addr.transfer(_eth);
702 
703             // build event data
704             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
705             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
706 
707             // fire withdraw and distribute event
708             emit F3Devents.onWithdrawAndDistribute
709             (
710                 _realSender,
711                 plyr_[_pID].name,
712                 _eth,
713                 _eventData_.compressedData,
714                 _eventData_.compressedIDs,
715                 _eventData_.winnerAddr,
716                 _eventData_.winnerName,
717                 _eventData_.amountWon,
718                 _eventData_.newPot,
719                 _eventData_.P3DAmount,
720                 _eventData_.genAmount
721             );
722 
723         // in any other situation
724         } else {
725             // get their earnings
726             _eth = withdrawEarnings(_pID);
727 
728             // gib moni
729             if (_eth > 0)
730                 plyr_[_pID].addr.transfer(_eth);
731 
732             // fire withdraw event
733             emit F3Devents.onWithdraw(_pID, _realSender, plyr_[_pID].name, _eth, _now);
734         }
735     }
736 
737 
738     //==============================================================================
739     //     _  _ _|__|_ _  _ _  .
740     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
741     //=====_|=======================================================================
742     /**
743     * @dev return the price buyer will pay for next 1 individual key.
744     * -functionhash- 0x018a25e8
745     * @return price for next key bought (in wei format)
746     */
747     function getBuyPrice()
748         public
749         view
750         returns(uint256)
751     {
752         // setup local rID
753         uint256 _rID = rID_;
754 
755         // grab time
756         uint256 _now = now;
757 
758         // are we in a round?
759         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
760             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
761         else // rounds over.  need price for new round
762             return ( 75000000000000 ); // init
763     }
764 
765     /**
766     * @dev returns time left.  dont spam this, you'll ddos yourself from your node
767     * provider
768     * -functionhash- 0xc7e284b8
769     * @return time left in seconds
770     */
771     function getTimeLeft()
772         public
773         view
774         returns(uint256)
775     {
776         // setup local rID
777         uint256 _rID = rID_;
778 
779         // grab time
780         uint256 _now = now;
781 
782         if (_now < round_[_rID].end)
783             if (_now > round_[_rID].strt + rndGap_)
784                 return( (round_[_rID].end).sub(_now) );
785             else
786                 return( (round_[_rID].strt + rndGap_).sub(_now) );
787         else
788             return(0);
789     }
790 
791     /**
792     * @dev returns player earnings per vaults
793     * -functionhash- 0x63066434
794     * @return winnings vault
795     * @return general vault
796     * @return affiliate vault
797     */
798     function getPlayerVaults(uint256 _pID)
799         public
800         view
801         returns(uint256 ,uint256, uint256)
802     {
803         // setup local rID
804         uint256 _rID = rID_;
805 
806         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
807         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
808         {
809             // if player is winner
810             if (round_[_rID].plyr == _pID)
811             {
812                 return
813                 (
814                     (plyr_[_pID].win).add(((round_[_rID].pot))),
815                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
816                     plyr_[_pID].aff
817                 );
818             // if player is not the winner
819             } else {
820                 return
821                 (
822                     plyr_[_pID].win,
823                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
824                     plyr_[_pID].aff
825                 );
826             }
827 
828         // if round is still going on, or round has ended and round end has been ran
829         } else {
830             return
831             (
832                 plyr_[_pID].win,
833                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
834                 plyr_[_pID].aff
835             );
836         }
837     }
838 
839     /**
840     * solidity hates stack limits.  this lets us avoid that hate
841     */
842     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
843         private
844         view
845         returns(uint256)
846     {
847         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
848     }
849 
850     /**
851     * @dev returns all current round info needed for front end
852     * -functionhash- 0x747dff42
853     * @return eth invested during ICO phase
854     * @return round id
855     * @return total keys for round
856     * @return time round ends
857     * @return time round started
858     * @return current pot
859     * @return current team ID & player ID in lead
860     * @return current player in leads address
861     * @return current player in leads name
862     * @return eth in total
863     * @return 0
864     * @return 0
865     * @return 0
866     * @return airdrop tracker # & airdrop pot
867     */
868     function getCurrentRoundInfo()
869         public
870         view
871         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
872     {
873         // setup local rID
874         uint256 _rID = rID_;
875 
876         return
877         (
878             round_[_rID].ico,               //0
879             _rID,                           //1
880             round_[_rID].keys,              //2
881             round_[_rID].end,               //3
882             round_[_rID].strt,              //4
883             round_[_rID].pot,               //5
884             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
885             plyr_[round_[_rID].plyr].addr,  //7
886             plyr_[round_[_rID].plyr].name,  //8
887             rndTmEth_[_rID][0],             //9
888             rndTmEth_[_rID][1],             //10
889             rndTmEth_[_rID][2],             //11
890             rndTmEth_[_rID][3],             //12
891             airDropTracker_ + (airDropPot_ * 1000)              //13
892         );
893     }
894 
895     /**
896     * @dev returns player info based on address.  if no address is given, it will
897     * use msg.sender
898     * -functionhash- 0xee0b5d8b
899     * @param _addr address of the player you want to lookup
900     * @return player ID
901     * @return player name
902     * @return keys owned (current round)
903     * @return winnings vault
904     * @return general vault
905     * @return affiliate vault
906     * @return player round eth
907     */
908     function getPlayerInfoByAddress(address _addr)
909         public
910         view
911         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
912     {
913         // setup local rID
914         uint256 _rID = rID_;
915 
916         if (_addr == address(0))
917         {
918             _addr == msg.sender;
919         }
920         uint256 _pID = pIDxAddr_[_addr];
921 
922         return
923         (
924             _pID,                               //0
925             plyr_[_pID].name,                   //1
926             plyrRnds_[_pID][_rID].keys,         //2
927             plyr_[_pID].win,                    //3
928             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
929             plyr_[_pID].aff,                    //5
930             plyrRnds_[_pID][_rID].eth           //6
931         );
932     }
933 
934     //==============================================================================
935     //     _ _  _ _   | _  _ . _  .
936     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
937     //=====================_|=======================================================
938     /**
939     * @dev logic runs whenever a buy order is executed.  determines how to handle
940     * incoming eth depending on if we are in an active round or not
941     */
942     function buyCore(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
943         private
944     {
945         // setup local rID
946         uint256 _rID = rID_;
947 
948         // grab time
949         uint256 _now = now;
950         uint256 _affID = 1;
951         uint256 _team = 0;
952 
953         // if round is active
954         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
955         {
956             // call core
957             core(address(0), _rID, _pID, msg.value, _affID, _team, _eventData_);
958 
959         // if round is not active
960         } else {
961             // check to see if end round needs to be ran
962             if (_now > round_[_rID].end && round_[_rID].ended == false)
963             {
964                 // end the round (distributes pot) & start new round
965                 round_[_rID].ended = true;
966                 _eventData_ = endRound(_eventData_);
967 
968                 // build event data
969                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
970                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
971 
972                 // fire buy and distribute event
973                 emit F3Devents.onBuyAndDistribute
974                 (
975                     msg.sender,
976                     plyr_[_pID].name,
977                     msg.value,
978                     _eventData_.compressedData,
979                     _eventData_.compressedIDs,
980                     _eventData_.winnerAddr,
981                     _eventData_.winnerName,
982                     _eventData_.amountWon,
983                     _eventData_.newPot,
984                     _eventData_.P3DAmount,
985                     _eventData_.genAmount
986                 );
987             }
988 
989             // put eth in players vault
990             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
991         }
992     }
993 
994     /**
995     * @dev logic runs whenever a buy order is executed.  determines how to handle
996     * incoming eth depending on if we are in an active round or not
997     */
998     function buyCoreQR(address _realSender, uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
999         private
1000     {
1001         // setup local rID
1002         uint256 _rID = rID_;
1003 
1004         // grab time
1005         uint256 _now = now;
1006         uint256 _affID = 1;
1007         uint256 _team = 0;
1008 
1009         // if round is active
1010         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1011         {
1012             // call core
1013             core(_realSender,_rID, _pID, msg.value, _affID, _team, _eventData_);
1014 
1015         // if round is not active
1016         } else {
1017             // check to see if end round needs to be ran
1018             if (_now > round_[_rID].end && round_[_rID].ended == false)
1019             {
1020                 // end the round (distributes pot) & start new round
1021                 round_[_rID].ended = true;
1022                 _eventData_ = endRound(_eventData_);
1023 
1024                 // build event data
1025                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1026                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1027 
1028                 // fire buy and distribute event
1029                 emit F3Devents.onBuyAndDistribute
1030                 (
1031                     _realSender,
1032                     plyr_[_pID].name,
1033                     msg.value,
1034                     _eventData_.compressedData,
1035                     _eventData_.compressedIDs,
1036                     _eventData_.winnerAddr,
1037                     _eventData_.winnerName,
1038                     _eventData_.amountWon,
1039                     _eventData_.newPot,
1040                     _eventData_.P3DAmount,
1041                     _eventData_.genAmount
1042                 );
1043             }
1044 
1045             // put eth in players vault
1046             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1047         }
1048     }
1049 
1050     /**
1051     * @dev this is the core logic for any buy/reload that happens while a round
1052     * is live.
1053     */
1054     function core(address _realSender, uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1055         private
1056     {
1057         // if player is new to round
1058         if (plyrRnds_[_pID][_rID].keys == 0)
1059             _eventData_ = managePlayer(_pID, _eventData_);
1060 
1061         // early round eth limiter
1062         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1063         {
1064             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1065             uint256 _refund = _eth.sub(_availableLimit);
1066             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1067             _eth = _availableLimit;
1068         }
1069 
1070         // if eth left is greater than min eth allowed (sorry no pocket lint)
1071         if (_eth > 1000000000)
1072         {
1073 
1074             // mint the new keys
1075             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1076 
1077             // if they bought at least 1 whole key
1078             if (_keys >= 1000000000000000000)
1079             {
1080                 updateTimer(_keys, _rID);
1081 
1082                 // set new leaders
1083                 if (round_[_rID].plyr != _pID)
1084                     round_[_rID].plyr = _pID;
1085                 if (round_[_rID].team != _team)
1086                     round_[_rID].team = _team;
1087 
1088                 // set the new leader bool to true
1089                 _eventData_.compressedData = _eventData_.compressedData + 100;
1090             }
1091 
1092             // update player
1093             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1094             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1095 
1096             // update round
1097             round_[_rID].keys = _keys.add(round_[_rID].keys);
1098             round_[_rID].eth = _eth.add(round_[_rID].eth);
1099             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1100 
1101             // distribute eth
1102             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1103             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1104 
1105             // call end tx function to fire end tx event.
1106             endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1107         }
1108     }
1109 
1110 
1111   //==============================================================================
1112   //     _ _ | _   | _ _|_ _  _ _  .
1113   //    (_(_||(_|_||(_| | (_)| _\  .
1114   //==============================================================================
1115       /**
1116        * @dev calculates unmasked earnings (just calculates, does not update mask)
1117        * @return earnings in wei format
1118        */
1119       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1120           private
1121           view
1122           returns(uint256)
1123       {
1124           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1125       }
1126 
1127       /**
1128        * @dev returns the amount of keys you would get given an amount of eth.
1129        * -functionhash- 0xce89c80c
1130        * @param _rID round ID you want price for
1131        * @param _eth amount of eth sent in
1132        * @return keys received
1133        */
1134       function calcKeysReceived(uint256 _rID, uint256 _eth)
1135           public
1136           view
1137           returns(uint256)
1138       {
1139           // grab time
1140           uint256 _now = now;
1141 
1142           // are we in a round?
1143           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1144               return ( (round_[_rID].eth).keysRec(_eth) );
1145           else // rounds over.  need keys for new round
1146               return ( (_eth).keys() );
1147       }
1148 
1149       /**
1150        * @dev returns current eth price for X keys.
1151        * -functionhash- 0xcf808000
1152        * @param _keys number of keys desired (in 18 decimal format)
1153        * @return amount of eth needed to send
1154        */
1155       function iWantXKeys(uint256 _keys)
1156           public
1157           view
1158           returns(uint256)
1159       {
1160           // setup local rID
1161           uint256 _rID = rID_;
1162 
1163           // grab time
1164           uint256 _now = now;
1165 
1166           // are we in a round?
1167           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1168               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1169           else // rounds over.  need price for new round
1170               return ( (_keys).eth() );
1171       }
1172   //==============================================================================
1173   //    _|_ _  _ | _  .
1174   //     | (_)(_)|_\  .
1175   //==============================================================================
1176       /**
1177   	 * @dev receives name/player info from names contract
1178        */
1179       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1180           external
1181       {
1182           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1183           if (pIDxAddr_[_addr] != _pID)
1184               pIDxAddr_[_addr] = _pID;
1185           if (pIDxName_[_name] != _pID)
1186               pIDxName_[_name] = _pID;
1187           if (plyr_[_pID].addr != _addr)
1188               plyr_[_pID].addr = _addr;
1189           if (plyr_[_pID].name != _name)
1190               plyr_[_pID].name = _name;
1191           if (plyr_[_pID].laff != _laff)
1192               plyr_[_pID].laff = _laff;
1193           if (plyrNames_[_pID][_name] == false)
1194               plyrNames_[_pID][_name] = true;
1195       }
1196 
1197       /**
1198        * @dev receives entire player name list
1199        */
1200       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1201           external
1202       {
1203           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1204           if(plyrNames_[_pID][_name] == false)
1205               plyrNames_[_pID][_name] = true;
1206       }
1207 
1208       /**
1209        * @dev gets existing or registers new pID.  use this when a player may be new
1210        * @return pID
1211        */
1212       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1213           private
1214           returns (F3Ddatasets.EventReturns)
1215       {
1216           uint256 _pID = pIDxAddr_[msg.sender];
1217           // if player is new to this version of fomo3d
1218           if (_pID == 0)
1219           {
1220               // grab their player ID, name and last aff ID, from player names contract
1221               _pID = PlayerBook.getPlayerID(msg.sender);
1222               bytes32 _name = PlayerBook.getPlayerName(_pID);
1223               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1224 
1225               // set up player account
1226               pIDxAddr_[msg.sender] = _pID;
1227               plyr_[_pID].addr = msg.sender;
1228 
1229               if (_name != "")
1230               {
1231                   pIDxName_[_name] = _pID;
1232                   plyr_[_pID].name = _name;
1233                   plyrNames_[_pID][_name] = true;
1234               }
1235 
1236               if (_laff != 0 && _laff != _pID)
1237                   plyr_[_pID].laff = _laff;
1238 
1239               // set the new player bool to true
1240               _eventData_.compressedData = _eventData_.compressedData + 1;
1241           }
1242           return (_eventData_);
1243       }
1244 
1245 
1246     /**
1247     * @dev gets existing or registers new pID.  use this when a player may be new
1248     * @return pID
1249     */
1250     function determinePIDQR(address _realSender, F3Ddatasets.EventReturns memory _eventData_)
1251         private
1252         returns (F3Ddatasets.EventReturns)
1253     {
1254         uint256 _pID = pIDxAddr_[_realSender];
1255         // if player is new to this version of fomo3d
1256         if (_pID == 0)
1257         {
1258             // grab their player ID, name and last aff ID, from player names contract
1259             _pID = PlayerBook.getPlayerID(_realSender);
1260             bytes32 _name = PlayerBook.getPlayerName(_pID);
1261             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1262 
1263             // set up player account
1264             pIDxAddr_[_realSender] = _pID;
1265             plyr_[_pID].addr = _realSender;
1266 
1267             if (_name != "")
1268             {
1269                 pIDxName_[_name] = _pID;
1270                 plyr_[_pID].name = _name;
1271                 plyrNames_[_pID][_name] = true;
1272             }
1273 
1274             if (_laff != 0 && _laff != _pID)
1275                 plyr_[_pID].laff = _laff;
1276 
1277             // set the new player bool to true
1278             _eventData_.compressedData = _eventData_.compressedData + 1;
1279         }
1280         return (_eventData_);
1281     }
1282 
1283       /**
1284        * @dev checks to make sure user picked a valid team.  if not sets team
1285        * to default (sneks)
1286        */
1287       function verifyTeam(uint256 _team)
1288           private
1289           pure
1290           returns (uint256)
1291       {
1292           if (_team < 0 || _team > 3)
1293               return(2);
1294           else
1295               return(_team);
1296       }
1297 
1298       /**
1299        * @dev decides if round end needs to be run & new round started.  and if
1300        * player unmasked earnings from previously played rounds need to be moved.
1301        */
1302       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1303           private
1304           returns (F3Ddatasets.EventReturns)
1305       {
1306           // if player has played a previous round, move their unmasked earnings
1307           // from that round to gen vault.
1308           if (plyr_[_pID].lrnd != 0)
1309               updateGenVault(_pID, plyr_[_pID].lrnd);
1310 
1311           // update player's last round played
1312           plyr_[_pID].lrnd = rID_;
1313 
1314           // set the joined round bool to true
1315           _eventData_.compressedData = _eventData_.compressedData + 10;
1316 
1317           return(_eventData_);
1318       }
1319 
1320     /**
1321     * @dev ends the round. manages paying out winner/splitting up pot
1322     */
1323     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1324         private
1325         returns (F3Ddatasets.EventReturns)
1326     {
1327         // setup local rID
1328         uint256 _rID = rID_;
1329 
1330         // grab our winning player and team id's
1331         uint256 _winPID = round_[_rID].plyr;
1332         uint256 _winTID = round_[_rID].team;
1333 
1334         // grab our pot amount
1335         uint256 _pot = round_[_rID].pot;
1336 
1337         // calculate our winner share, community rewards, gen share,
1338         // p3d share, and amount reserved for next pot
1339         uint256 _win = _pot;
1340         uint256 _gen = 0;
1341         uint256 _p3d = 0;
1342         uint256 _res = 0; // actually 0 eth to the next round
1343 
1344         // calculate ppt for round mask
1345         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1346 
1347         // pay our winner
1348         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1349 
1350         // distribute gen portion to key holders
1351         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1352 
1353         // prepare event data
1354         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1355         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1356         _eventData_.winnerAddr = plyr_[_winPID].addr;
1357         _eventData_.winnerName = plyr_[_winPID].name;
1358         _eventData_.amountWon = _win;
1359         _eventData_.genAmount = _gen;
1360         _eventData_.P3DAmount = _p3d;
1361         _eventData_.newPot = _res;
1362 
1363         // start next round
1364         rID_++;
1365         _rID++;
1366         round_[_rID].strt = now;
1367         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1368         round_[_rID].pot = _res;
1369 
1370         return(_eventData_);
1371     }
1372 
1373     /**
1374     * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1375     */
1376     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1377         private
1378     {
1379         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1380         if (_earnings > 0)
1381         {
1382             // put in gen vault
1383             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1384             // zero out their earnings by updating mask
1385             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1386         }
1387     }
1388 
1389     /**
1390     * @dev updates round timer based on number of whole keys bought.
1391     */
1392     function updateTimer(uint256 _keys, uint256 _rID)
1393         private
1394     {
1395         // grab time
1396         uint256 _now = now;
1397 
1398         // calculate time based on number of keys bought
1399         uint256 _newTime;
1400         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1401             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1402         else
1403             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1404 
1405         // compare to max and set new end time
1406         if (_newTime < (rndMax_).add(_now))
1407             round_[_rID].end = _newTime;
1408         else
1409             round_[_rID].end = rndMax_.add(_now);
1410     }
1411 
1412 
1413     /**
1414     * @dev distributes eth based on fees to com, aff, and p3d
1415     */
1416     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1417         private
1418         returns(F3Ddatasets.EventReturns)
1419     {
1420         // pay 2% out to developers rewards
1421         uint256 _p3d = _eth / 50;
1422 
1423         // distribute share to running team
1424         uint256 _aff = _eth.mul(8) / 100;
1425 
1426         // decide what to do with affiliate share of fees
1427         // affiliate must not be self, and must have a name registered
1428         plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1429         emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1430 
1431         // pay out p3d
1432         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1433         if (_p3d > 0)
1434         {
1435             // deposit to divies contract
1436             admin.transfer(_p3d);
1437             // set up event data
1438             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1439         }
1440         return(_eventData_);
1441     }
1442 
1443     function potSwap()
1444         external
1445         payable
1446     {
1447         // setup local rID
1448         uint256 _rID = rID_ + 1;
1449 
1450         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1451         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1452     }
1453 
1454     /**
1455     * @dev distributes eth based on fees to gen and pot
1456     */
1457     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1458         private
1459         returns(F3Ddatasets.EventReturns)
1460     {
1461         // calculate gen share
1462         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1463 
1464         // distribute 10% to pot
1465         uint256 _potAmount = _eth / 10;
1466 
1467         // distribute gen share (thats what updateMasks() does) and adjust
1468         // balances for dust.
1469         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1470         if (_dust > 0)
1471             _gen = _gen.sub(_dust);
1472 
1473         // add eth to pot
1474         round_[_rID].pot = _potAmount.add(_dust).add(round_[_rID].pot);
1475 
1476         // set up event data
1477         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1478         _eventData_.potAmount = _potAmount;
1479 
1480         return(_eventData_);
1481     }
1482 
1483 
1484       /**
1485        * @dev updates masks for round and player when keys are bought
1486        * @return dust left over
1487        */
1488       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1489           private
1490           returns(uint256)
1491       {
1492           /* MASKING NOTES
1493               earnings masks are a tricky thing for people to wrap their minds around.
1494               the basic thing to understand here.  is were going to have a global
1495               tracker based on profit per share for each round, that increases in
1496               relevant proportion to the increase in share supply.
1497 
1498               the player will have an additional mask that basically says "based
1499               on the rounds mask, my shares, and how much i've already withdrawn,
1500               how much is still owed to me?"
1501           */
1502 
1503           // calc profit per key & round mask based on this buy:  (dust goes to pot)
1504           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1505           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1506 
1507           // calculate player earning from their own buy (only based on the keys
1508           // they just bought).  & update player earnings mask
1509           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1510           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1511 
1512           // calculate & return dust
1513           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1514       }
1515 
1516     /**
1517     * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1518     * @return earnings in wei format
1519     */
1520     function withdrawEarnings(uint256 _pID)
1521         private
1522         returns(uint256)
1523     {
1524         // update gen vault
1525         updateGenVault(_pID, plyr_[_pID].lrnd);
1526 
1527         // from vaults
1528         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1529         if (_earnings > 0)
1530         {
1531             plyr_[_pID].win = 0;
1532             plyr_[_pID].gen = 0;
1533             plyr_[_pID].aff = 0;
1534         }
1535 
1536         return(_earnings);
1537     }
1538 
1539     /**
1540     * @dev prepares compression data and fires event for buy or reload tx's
1541     */
1542     function endTxQR(address _realSender,uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1543         private
1544     {
1545         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1546         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1547 
1548         emit F3Devents.onEndTx
1549         (
1550             _eventData_.compressedData,
1551             _eventData_.compressedIDs,
1552             plyr_[_pID].name,
1553             _realSender,
1554             _eth,
1555             _keys,
1556             _eventData_.winnerAddr,
1557             _eventData_.winnerName,
1558             _eventData_.amountWon,
1559             _eventData_.newPot,
1560             _eventData_.P3DAmount,
1561             _eventData_.genAmount,
1562             _eventData_.potAmount,
1563             airDropPot_
1564         );
1565     }
1566 
1567   //==============================================================================
1568   //    (~ _  _    _._|_    .
1569   //    _)(/_(_|_|| | | \/  .
1570   //====================/=========================================================
1571       /** upon contract deploy, it will be deactivated.  this is a one time
1572        * use function that will activate the contract.  we do this so devs
1573        * have time to set things up on the web end                            **/
1574       bool public activated_ = false;
1575       function activate()
1576           public
1577       {
1578           // only team just can activate
1579           require(msg.sender == admin, "only admin can activate");
1580 
1581 
1582           // can only be ran once
1583           require(activated_ == false, "FOMO Short already activated");
1584 
1585           // activate the contract
1586           activated_ = true;
1587 
1588           // lets start first round
1589           rID_ = 1;
1590               round_[1].strt = now + rndExtra_ - rndGap_;
1591               round_[1].end = now + rndInit_ + rndExtra_;
1592       }
1593   }