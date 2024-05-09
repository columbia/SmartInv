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
441 interface PlayerBookInterface {
442     function getPlayerID(address _addr) external returns (uint256);
443     function getPlayerName(uint256 _pID) external view returns (bytes32);
444     function getPlayerLAff(uint256 _pID) external view returns (uint256);
445     function getPlayerAddr(uint256 _pID) external view returns (address);
446     function getNameFee() external view returns (uint256);
447     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
448     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
449     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
450 }
451 
452 
453 
454 contract modularFast is F3Devents {}
455 
456 
457 contract FoMo3DFast is modularFast {
458     using SafeMath for *;
459     using NameFilter for string;
460     using F3DKeysCalcShort for uint256;
461 
462     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x62F9Cd807779A0e8534d564A00230a9b7D241391);
463 
464     address private admin = msg.sender;
465     string constant public name = "OTION";
466     string constant public symbol = "OTION";
467     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
468     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
469     uint256 constant private rndInit_ = 888 minutes;                // round timer starts at this
470     uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
471     uint256 constant private rndMax_ = 888 minutes;                // max length a round timer can be
472     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
473     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
474     uint256 public rID_;    // round id number / total rounds that have happened
475     //****************
476     // PLAYER DATA
477     //****************
478     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
479     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
480     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
481     // (pID => rID => data) player round data by player id & round id
482     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
483     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
484     //****************
485     // ROUND DATA
486     //****************
487     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
488     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
489     //****************
490     // TEAM FEE DATA
491     //****************
492     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
493     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
494 
495     constructor()
496         public
497     {
498     // Team allocation structures
499         // 0 = the only team
500         
501 
502     // Team allocation percentages
503         // (F3D, P3D) + (Pot , Referrals, Community)  解读:TeamFee, PotSplit 第一个参数都是分给现在key holder的比例, 第二个是给Pow3D的比例
504             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
505         fees_[0] = F3Ddatasets.TeamFee(80,0);   //10% to pot, 8% to aff, 2% to com
506 
507         // how to split up the final pot based on which team was picked
508         // (F3D, P3D)
509         potSplit_[0] = F3Ddatasets.PotSplit(0,0);  //100% to winner
510     }
511     //==============================================================================
512     //     _ _  _  _|. |`. _  _ _  .
513     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
514     //==============================================================================
515     /**
516     * @dev used to make sure no one can interact with contract until it has
517     * been activated.
518     */
519     modifier isActivated() {
520         require(activated_ == true, "its not ready yet.  check ?eta in discord");
521         _;
522     }
523 
524     /**
525     * @dev prevents contracts from interacting with fomo3d
526     */
527     modifier isHuman() {
528         address _addr = msg.sender;
529         uint256 _codeLength;
530 
531         assembly {_codeLength := extcodesize(_addr)}
532         require(_codeLength == 0, "sorry humans only");
533         _;
534     }
535 
536     /**
537     * @dev sets boundaries for incoming tx
538     */
539     modifier isWithinLimits(uint256 _eth) {
540         require(_eth >= 1000000000, "pocket lint: not a valid currency");
541         _;
542     }
543 
544     //==============================================================================
545     //     _    |_ |. _   |`    _  __|_. _  _  _  .
546     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
547     //====|=========================================================================
548     /**
549     * @dev emergency buy uses last stored affiliate ID and team snek
550     */
551     function()
552         isActivated()
553         isHuman()
554         isWithinLimits(msg.value)
555         public
556         payable
557     {
558         // set up our tx event data and determine if player is new or not
559         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
560 
561         // fetch player id
562         uint256 _pID = pIDxAddr_[msg.sender];
563 
564         // buy core
565         buyCore(_pID, _eventData_);
566     }
567 
568 
569 
570     function buyXnameQR(address _realSender)
571         isActivated()
572         isWithinLimits(msg.value)
573         public
574         payable
575     {
576         // set up our tx event data and determine if player is new or not
577         F3Ddatasets.EventReturns memory _eventData_ = determinePIDQR(_realSender,_eventData_);
578 
579         // fetch player id
580         uint256 _pID = pIDxAddr_[_realSender];
581 
582         // // manage affiliate residuals
583         // uint256 _affID = 1;
584         
585         // // verify a valid team was selected
586         // uint256 _team = 0;
587 
588         // buy core
589         buyCoreQR(_realSender, _pID, _eventData_);
590     }
591 
592     /**
593     * @dev withdraws all of your earnings.
594     * -functionhash- 0x3ccfd60b
595     */
596     function withdraw()
597         isActivated()
598         isHuman()
599         public
600     {
601         // setup local rID
602         uint256 _rID = rID_;
603 
604         // grab time
605         uint256 _now = now;
606 
607         // fetch player ID
608         uint256 _pID = pIDxAddr_[msg.sender];
609 
610         // setup temp var for player eth
611         uint256 _eth;
612 
613         // check to see if round has ended and no one has run round end yet
614         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
615         {
616             // set up our tx event data
617             F3Ddatasets.EventReturns memory _eventData_;
618 
619             // end the round (distributes pot)
620             round_[_rID].ended = true;
621             _eventData_ = endRound(_eventData_);
622 
623             // get their earnings
624             _eth = withdrawEarnings(_pID);
625 
626             // gib moni
627             if (_eth > 0)
628                 plyr_[_pID].addr.transfer(_eth);
629 
630             // build event data
631             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
632             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
633 
634             // fire withdraw and distribute event
635             emit F3Devents.onWithdrawAndDistribute
636             (
637                 msg.sender,
638                 plyr_[_pID].name,
639                 _eth,
640                 _eventData_.compressedData,
641                 _eventData_.compressedIDs,
642                 _eventData_.winnerAddr,
643                 _eventData_.winnerName,
644                 _eventData_.amountWon,
645                 _eventData_.newPot,
646                 _eventData_.P3DAmount,
647                 _eventData_.genAmount
648             );
649 
650         // in any other situation
651         } else {
652             // get their earnings
653             _eth = withdrawEarnings(_pID);
654 
655             // gib moni
656             if (_eth > 0)
657                 plyr_[_pID].addr.transfer(_eth);
658 
659             // fire withdraw event
660             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
661         }
662     }
663 
664     /**
665     * @dev withdraws all of your earnings.
666     * -functionhash- 0x3ccfd60b
667     */
668     function withdrawQR(address _realSender)
669         isActivated()
670         payable
671         public
672     {
673         // setup local rID
674         uint256 _rID = rID_;
675 
676         // grab time
677         uint256 _now = now;
678 
679         // fetch player ID
680         uint256 _pID = pIDxAddr_[_realSender];
681 
682         // setup temp var for player eth
683         uint256 _eth;
684 
685         // check to see if round has ended and no one has run round end yet
686         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
687         {
688             // set up our tx event data
689             F3Ddatasets.EventReturns memory _eventData_;
690 
691             // end the round (distributes pot)
692             round_[_rID].ended = true;
693             _eventData_ = endRound(_eventData_);
694 
695             // get their earnings
696             _eth = withdrawEarnings(_pID);
697 
698             // gib moni
699             if (_eth > 0)
700                 plyr_[_pID].addr.transfer(_eth);
701 
702             // build event data
703             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
704             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
705 
706             // fire withdraw and distribute event
707             emit F3Devents.onWithdrawAndDistribute
708             (
709                 _realSender,
710                 plyr_[_pID].name,
711                 _eth,
712                 _eventData_.compressedData,
713                 _eventData_.compressedIDs,
714                 _eventData_.winnerAddr,
715                 _eventData_.winnerName,
716                 _eventData_.amountWon,
717                 _eventData_.newPot,
718                 _eventData_.P3DAmount,
719                 _eventData_.genAmount
720             );
721 
722         // in any other situation
723         } else {
724             // get their earnings
725             _eth = withdrawEarnings(_pID);
726 
727             // gib moni
728             if (_eth > 0)
729                 plyr_[_pID].addr.transfer(_eth);
730 
731             // fire withdraw event
732             emit F3Devents.onWithdraw(_pID, _realSender, plyr_[_pID].name, _eth, _now);
733         }
734     }
735 
736 
737     //==============================================================================
738     //     _  _ _|__|_ _  _ _  .
739     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
740     //=====_|=======================================================================
741     /**
742     * @dev return the price buyer will pay for next 1 individual key.
743     * -functionhash- 0x018a25e8
744     * @return price for next key bought (in wei format)
745     */
746     function getBuyPrice()
747         public
748         view
749         returns(uint256)
750     {
751         // setup local rID
752         uint256 _rID = rID_;
753 
754         // grab time
755         uint256 _now = now;
756 
757         // are we in a round?
758         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
759             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
760         else // rounds over.  need price for new round
761             return ( 75000000000000 ); // init
762     }
763 
764     /**
765     * @dev returns time left.  dont spam this, you'll ddos yourself from your node
766     * provider
767     * -functionhash- 0xc7e284b8
768     * @return time left in seconds
769     */
770     function getTimeLeft()
771         public
772         view
773         returns(uint256)
774     {
775         // setup local rID
776         uint256 _rID = rID_;
777 
778         // grab time
779         uint256 _now = now;
780 
781         if (_now < round_[_rID].end)
782             if (_now > round_[_rID].strt + rndGap_)
783                 return( (round_[_rID].end).sub(_now) );
784             else
785                 return( (round_[_rID].strt + rndGap_).sub(_now) );
786         else
787             return(0);
788     }
789 
790     /**
791     * @dev returns player earnings per vaults
792     * -functionhash- 0x63066434
793     * @return winnings vault
794     * @return general vault
795     * @return affiliate vault
796     */
797     function getPlayerVaults(uint256 _pID)
798         public
799         view
800         returns(uint256 ,uint256, uint256)
801     {
802         // setup local rID
803         uint256 _rID = rID_;
804 
805         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
806         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
807         {
808             // if player is winner
809             if (round_[_rID].plyr == _pID)
810             {
811                 return
812                 (
813                     (plyr_[_pID].win).add(((round_[_rID].pot))),
814                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
815                     plyr_[_pID].aff
816                 );
817             // if player is not the winner
818             } else {
819                 return
820                 (
821                     plyr_[_pID].win,
822                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
823                     plyr_[_pID].aff
824                 );
825             }
826 
827         // if round is still going on, or round has ended and round end has been ran
828         } else {
829             return
830             (
831                 plyr_[_pID].win,
832                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
833                 plyr_[_pID].aff
834             );
835         }
836     }
837 
838     /**
839     * solidity hates stack limits.  this lets us avoid that hate
840     */
841     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
842         private
843         view
844         returns(uint256)
845     {
846         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
847     }
848 
849     /**
850     * @dev returns all current round info needed for front end
851     * -functionhash- 0x747dff42
852     * @return eth invested during ICO phase
853     * @return round id
854     * @return total keys for round
855     * @return time round ends
856     * @return time round started
857     * @return current pot
858     * @return current team ID & player ID in lead
859     * @return current player in leads address
860     * @return current player in leads name
861     * @return eth in total
862     * @return 0
863     * @return 0
864     * @return 0
865     * @return airdrop tracker # & airdrop pot
866     */
867     function getCurrentRoundInfo()
868         public
869         view
870         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
871     {
872         // setup local rID
873         uint256 _rID = rID_;
874 
875         return
876         (
877             round_[_rID].ico,               //0
878             _rID,                           //1
879             round_[_rID].keys,              //2
880             round_[_rID].end,               //3
881             round_[_rID].strt,              //4
882             round_[_rID].pot,               //5
883             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
884             plyr_[round_[_rID].plyr].addr,  //7
885             plyr_[round_[_rID].plyr].name,  //8
886             rndTmEth_[_rID][0],             //9
887             rndTmEth_[_rID][1],             //10
888             rndTmEth_[_rID][2],             //11
889             rndTmEth_[_rID][3],             //12
890             airDropTracker_ + (airDropPot_ * 1000)              //13
891         );
892     }
893 
894     /**
895     * @dev returns player info based on address.  if no address is given, it will
896     * use msg.sender
897     * -functionhash- 0xee0b5d8b
898     * @param _addr address of the player you want to lookup
899     * @return player ID
900     * @return player name
901     * @return keys owned (current round)
902     * @return winnings vault
903     * @return general vault
904     * @return affiliate vault
905     * @return player round eth
906     */
907     function getPlayerInfoByAddress(address _addr)
908         public
909         view
910         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
911     {
912         // setup local rID
913         uint256 _rID = rID_;
914 
915         if (_addr == address(0))
916         {
917             _addr == msg.sender;
918         }
919         uint256 _pID = pIDxAddr_[_addr];
920 
921         return
922         (
923             _pID,                               //0
924             plyr_[_pID].name,                   //1
925             plyrRnds_[_pID][_rID].keys,         //2
926             plyr_[_pID].win,                    //3
927             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
928             plyr_[_pID].aff,                    //5
929             plyrRnds_[_pID][_rID].eth           //6
930         );
931     }
932 
933     //==============================================================================
934     //     _ _  _ _   | _  _ . _  .
935     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
936     //=====================_|=======================================================
937     /**
938     * @dev logic runs whenever a buy order is executed.  determines how to handle
939     * incoming eth depending on if we are in an active round or not
940     */
941     function buyCore(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
942         private
943     {
944         // setup local rID
945         uint256 _rID = rID_;
946 
947         // grab time
948         uint256 _now = now;
949         uint256 _affID = 1;
950         uint256 _team = 0;
951 
952         // if round is active
953         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
954         {
955             // call core
956             core(address(0), _rID, _pID, msg.value, _affID, _team, _eventData_);
957 
958         // if round is not active
959         } else {
960             // check to see if end round needs to be ran
961             if (_now > round_[_rID].end && round_[_rID].ended == false)
962             {
963                 // end the round (distributes pot) & start new round
964                 round_[_rID].ended = true;
965                 _eventData_ = endRound(_eventData_);
966 
967                 // build event data
968                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
969                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
970 
971                 // fire buy and distribute event
972                 emit F3Devents.onBuyAndDistribute
973                 (
974                     msg.sender,
975                     plyr_[_pID].name,
976                     msg.value,
977                     _eventData_.compressedData,
978                     _eventData_.compressedIDs,
979                     _eventData_.winnerAddr,
980                     _eventData_.winnerName,
981                     _eventData_.amountWon,
982                     _eventData_.newPot,
983                     _eventData_.P3DAmount,
984                     _eventData_.genAmount
985                 );
986             }
987 
988             // put eth in players vault
989             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
990         }
991     }
992 
993     /**
994     * @dev logic runs whenever a buy order is executed.  determines how to handle
995     * incoming eth depending on if we are in an active round or not
996     */
997     function buyCoreQR(address _realSender, uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
998         private
999     {
1000         // setup local rID
1001         uint256 _rID = rID_;
1002 
1003         // grab time
1004         uint256 _now = now;
1005         uint256 _affID = 1;
1006         uint256 _team = 0;
1007 
1008         // if round is active
1009         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1010         {
1011             // call core
1012             core(_realSender,_rID, _pID, msg.value, _affID, _team, _eventData_);
1013 
1014         // if round is not active
1015         } else {
1016             // check to see if end round needs to be ran
1017             if (_now > round_[_rID].end && round_[_rID].ended == false)
1018             {
1019                 // end the round (distributes pot) & start new round
1020                 round_[_rID].ended = true;
1021                 _eventData_ = endRound(_eventData_);
1022 
1023                 // build event data
1024                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1025                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1026 
1027                 // fire buy and distribute event
1028                 emit F3Devents.onBuyAndDistribute
1029                 (
1030                     _realSender,
1031                     plyr_[_pID].name,
1032                     msg.value,
1033                     _eventData_.compressedData,
1034                     _eventData_.compressedIDs,
1035                     _eventData_.winnerAddr,
1036                     _eventData_.winnerName,
1037                     _eventData_.amountWon,
1038                     _eventData_.newPot,
1039                     _eventData_.P3DAmount,
1040                     _eventData_.genAmount
1041                 );
1042             }
1043 
1044             // put eth in players vault
1045             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1046         }
1047     }
1048 
1049     /**
1050     * @dev this is the core logic for any buy/reload that happens while a round
1051     * is live.
1052     */
1053     function core(address _realSender, uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1054         private
1055     {
1056         // if player is new to round
1057         if (plyrRnds_[_pID][_rID].keys == 0)
1058             _eventData_ = managePlayer(_pID, _eventData_);
1059 
1060         // early round eth limiter
1061         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1062         {
1063             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1064             uint256 _refund = _eth.sub(_availableLimit);
1065             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1066             _eth = _availableLimit;
1067         }
1068 
1069         // if eth left is greater than min eth allowed (sorry no pocket lint)
1070         if (_eth > 1000000000)
1071         {
1072 
1073             // mint the new keys
1074             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1075 
1076             // if they bought at least 1 whole key
1077             if (_keys >= 1000000000000000000)
1078             {
1079                 updateTimer(_keys, _rID);
1080 
1081                 // set new leaders
1082                 if (round_[_rID].plyr != _pID)
1083                     round_[_rID].plyr = _pID;
1084                 if (round_[_rID].team != _team)
1085                     round_[_rID].team = _team;
1086 
1087                 // set the new leader bool to true
1088                 _eventData_.compressedData = _eventData_.compressedData + 100;
1089             }
1090 
1091             // update player
1092             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1093             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1094 
1095             // update round
1096             round_[_rID].keys = _keys.add(round_[_rID].keys);
1097             round_[_rID].eth = _eth.add(round_[_rID].eth);
1098             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1099 
1100             // distribute eth
1101             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1102             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1103 
1104             // call end tx function to fire end tx event.
1105             endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1106         }
1107     }
1108 
1109 
1110   //==============================================================================
1111   //     _ _ | _   | _ _|_ _  _ _  .
1112   //    (_(_||(_|_||(_| | (_)| _\  .
1113   //==============================================================================
1114       /**
1115        * @dev calculates unmasked earnings (just calculates, does not update mask)
1116        * @return earnings in wei format
1117        */
1118       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1119           private
1120           view
1121           returns(uint256)
1122       {
1123           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1124       }
1125 
1126       /**
1127        * @dev returns the amount of keys you would get given an amount of eth.
1128        * -functionhash- 0xce89c80c
1129        * @param _rID round ID you want price for
1130        * @param _eth amount of eth sent in
1131        * @return keys received
1132        */
1133       function calcKeysReceived(uint256 _rID, uint256 _eth)
1134           public
1135           view
1136           returns(uint256)
1137       {
1138           // grab time
1139           uint256 _now = now;
1140 
1141           // are we in a round?
1142           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1143               return ( (round_[_rID].eth).keysRec(_eth) );
1144           else // rounds over.  need keys for new round
1145               return ( (_eth).keys() );
1146       }
1147 
1148       /**
1149        * @dev returns current eth price for X keys.
1150        * -functionhash- 0xcf808000
1151        * @param _keys number of keys desired (in 18 decimal format)
1152        * @return amount of eth needed to send
1153        */
1154       function iWantXKeys(uint256 _keys)
1155           public
1156           view
1157           returns(uint256)
1158       {
1159           // setup local rID
1160           uint256 _rID = rID_;
1161 
1162           // grab time
1163           uint256 _now = now;
1164 
1165           // are we in a round?
1166           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1167               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1168           else // rounds over.  need price for new round
1169               return ( (_keys).eth() );
1170       }
1171   //==============================================================================
1172   //    _|_ _  _ | _  .
1173   //     | (_)(_)|_\  .
1174   //==============================================================================
1175       /**
1176   	 * @dev receives name/player info from names contract
1177        */
1178       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1179           external
1180       {
1181           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1182           if (pIDxAddr_[_addr] != _pID)
1183               pIDxAddr_[_addr] = _pID;
1184           if (pIDxName_[_name] != _pID)
1185               pIDxName_[_name] = _pID;
1186           if (plyr_[_pID].addr != _addr)
1187               plyr_[_pID].addr = _addr;
1188           if (plyr_[_pID].name != _name)
1189               plyr_[_pID].name = _name;
1190           if (plyr_[_pID].laff != _laff)
1191               plyr_[_pID].laff = _laff;
1192           if (plyrNames_[_pID][_name] == false)
1193               plyrNames_[_pID][_name] = true;
1194       }
1195 
1196       /**
1197        * @dev receives entire player name list
1198        */
1199       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1200           external
1201       {
1202           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1203           if(plyrNames_[_pID][_name] == false)
1204               plyrNames_[_pID][_name] = true;
1205       }
1206 
1207       /**
1208        * @dev gets existing or registers new pID.  use this when a player may be new
1209        * @return pID
1210        */
1211       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1212           private
1213           returns (F3Ddatasets.EventReturns)
1214       {
1215           uint256 _pID = pIDxAddr_[msg.sender];
1216           // if player is new to this version of fomo3d
1217           if (_pID == 0)
1218           {
1219               // grab their player ID, name and last aff ID, from player names contract
1220               _pID = PlayerBook.getPlayerID(msg.sender);
1221               bytes32 _name = PlayerBook.getPlayerName(_pID);
1222               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1223 
1224               // set up player account
1225               pIDxAddr_[msg.sender] = _pID;
1226               plyr_[_pID].addr = msg.sender;
1227 
1228               if (_name != "")
1229               {
1230                   pIDxName_[_name] = _pID;
1231                   plyr_[_pID].name = _name;
1232                   plyrNames_[_pID][_name] = true;
1233               }
1234 
1235               if (_laff != 0 && _laff != _pID)
1236                   plyr_[_pID].laff = _laff;
1237 
1238               // set the new player bool to true
1239               _eventData_.compressedData = _eventData_.compressedData + 1;
1240           }
1241           return (_eventData_);
1242       }
1243 
1244 
1245     /**
1246     * @dev gets existing or registers new pID.  use this when a player may be new
1247     * @return pID
1248     */
1249     function determinePIDQR(address _realSender, F3Ddatasets.EventReturns memory _eventData_)
1250         private
1251         returns (F3Ddatasets.EventReturns)
1252     {
1253         uint256 _pID = pIDxAddr_[_realSender];
1254         // if player is new to this version of fomo3d
1255         if (_pID == 0)
1256         {
1257             // grab their player ID, name and last aff ID, from player names contract
1258             _pID = PlayerBook.getPlayerID(_realSender);
1259             bytes32 _name = PlayerBook.getPlayerName(_pID);
1260             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1261 
1262             // set up player account
1263             pIDxAddr_[_realSender] = _pID;
1264             plyr_[_pID].addr = _realSender;
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
1282       /**
1283        * @dev checks to make sure user picked a valid team.  if not sets team
1284        * to default (sneks)
1285        */
1286       function verifyTeam(uint256 _team)
1287           private
1288           pure
1289           returns (uint256)
1290       {
1291           if (_team < 0 || _team > 3)
1292               return(2);
1293           else
1294               return(_team);
1295       }
1296 
1297       /**
1298        * @dev decides if round end needs to be run & new round started.  and if
1299        * player unmasked earnings from previously played rounds need to be moved.
1300        */
1301       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1302           private
1303           returns (F3Ddatasets.EventReturns)
1304       {
1305           // if player has played a previous round, move their unmasked earnings
1306           // from that round to gen vault.
1307           if (plyr_[_pID].lrnd != 0)
1308               updateGenVault(_pID, plyr_[_pID].lrnd);
1309 
1310           // update player's last round played
1311           plyr_[_pID].lrnd = rID_;
1312 
1313           // set the joined round bool to true
1314           _eventData_.compressedData = _eventData_.compressedData + 10;
1315 
1316           return(_eventData_);
1317       }
1318 
1319     /**
1320     * @dev ends the round. manages paying out winner/splitting up pot
1321     */
1322     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1323         private
1324         returns (F3Ddatasets.EventReturns)
1325     {
1326         // setup local rID
1327         uint256 _rID = rID_;
1328 
1329         // grab our winning player and team id's
1330         uint256 _winPID = round_[_rID].plyr;
1331         uint256 _winTID = round_[_rID].team;
1332 
1333         // grab our pot amount
1334         uint256 _pot = round_[_rID].pot;
1335 
1336         // calculate our winner share, community rewards, gen share,
1337         // p3d share, and amount reserved for next pot
1338         uint256 _win = _pot;
1339         uint256 _gen = 0;
1340         uint256 _p3d = 0;
1341         uint256 _res = 0; // actually 0 eth to the next round
1342 
1343         // calculate ppt for round mask
1344         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1345 
1346         // pay our winner
1347         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1348 
1349         // distribute gen portion to key holders
1350         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1351 
1352         // prepare event data
1353         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1354         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1355         _eventData_.winnerAddr = plyr_[_winPID].addr;
1356         _eventData_.winnerName = plyr_[_winPID].name;
1357         _eventData_.amountWon = _win;
1358         _eventData_.genAmount = _gen;
1359         _eventData_.P3DAmount = _p3d;
1360         _eventData_.newPot = _res;
1361 
1362         // start next round
1363         rID_++;
1364         _rID++;
1365         round_[_rID].strt = now;
1366         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1367         round_[_rID].pot = _res;
1368 
1369         return(_eventData_);
1370     }
1371 
1372     /**
1373     * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1374     */
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
1389     * @dev updates round timer based on number of whole keys bought.
1390     */
1391     function updateTimer(uint256 _keys, uint256 _rID)
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
1405         if (_newTime < (rndMax_).add(_now))
1406             round_[_rID].end = _newTime;
1407         else
1408             round_[_rID].end = rndMax_.add(_now);
1409     }
1410 
1411 
1412     /**
1413     * @dev distributes eth based on fees to com, aff, and p3d
1414     */
1415     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1416         private
1417         returns(F3Ddatasets.EventReturns)
1418     {
1419         // pay 2% out to developers rewards
1420         uint256 _p3d = _eth / 50;
1421 
1422         // distribute share to running team
1423         uint256 _aff = _eth.mul(8) / 100;
1424 
1425         // decide what to do with affiliate share of fees
1426         // affiliate must not be self, and must have a name registered
1427         plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1428         emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1429 
1430         // pay out p3d
1431         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1432         if (_p3d > 0)
1433         {
1434             // deposit to divies contract
1435             admin.transfer(_p3d);
1436             // set up event data
1437             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1438         }
1439         return(_eventData_);
1440     }
1441 
1442     function potSwap()
1443         external
1444         payable
1445     {
1446         // setup local rID
1447         uint256 _rID = rID_ + 1;
1448 
1449         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1450         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1451     }
1452 
1453     /**
1454     * @dev distributes eth based on fees to gen and pot
1455     */
1456     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1457         private
1458         returns(F3Ddatasets.EventReturns)
1459     {
1460         // calculate gen share
1461         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1462 
1463         // distribute 10% to pot
1464         uint256 _potAmount = _eth / 10;
1465 
1466         // distribute gen share (thats what updateMasks() does) and adjust
1467         // balances for dust.
1468         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1469         if (_dust > 0)
1470             _gen = _gen.sub(_dust);
1471 
1472         // add eth to pot
1473         round_[_rID].pot = _potAmount.add(_dust).add(round_[_rID].pot);
1474 
1475         // set up event data
1476         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1477         _eventData_.potAmount = _potAmount;
1478 
1479         return(_eventData_);
1480     }
1481 
1482 
1483       /**
1484        * @dev updates masks for round and player when keys are bought
1485        * @return dust left over
1486        */
1487       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1488           private
1489           returns(uint256)
1490       {
1491           /* MASKING NOTES
1492               earnings masks are a tricky thing for people to wrap their minds around.
1493               the basic thing to understand here.  is were going to have a global
1494               tracker based on profit per share for each round, that increases in
1495               relevant proportion to the increase in share supply.
1496 
1497               the player will have an additional mask that basically says "based
1498               on the rounds mask, my shares, and how much i've already withdrawn,
1499               how much is still owed to me?"
1500           */
1501 
1502           // calc profit per key & round mask based on this buy:  (dust goes to pot)
1503           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1504           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1505 
1506           // calculate player earning from their own buy (only based on the keys
1507           // they just bought).  & update player earnings mask
1508           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1509           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1510 
1511           // calculate & return dust
1512           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1513       }
1514 
1515     /**
1516     * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1517     * @return earnings in wei format
1518     */
1519     function withdrawEarnings(uint256 _pID)
1520         private
1521         returns(uint256)
1522     {
1523         // update gen vault
1524         updateGenVault(_pID, plyr_[_pID].lrnd);
1525 
1526         // from vaults
1527         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1528         if (_earnings > 0)
1529         {
1530             plyr_[_pID].win = 0;
1531             plyr_[_pID].gen = 0;
1532             plyr_[_pID].aff = 0;
1533         }
1534 
1535         return(_earnings);
1536     }
1537 
1538     /**
1539     * @dev prepares compression data and fires event for buy or reload tx's
1540     */
1541     function endTxQR(address _realSender,uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1542         private
1543     {
1544         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1545         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1546 
1547         emit F3Devents.onEndTx
1548         (
1549             _eventData_.compressedData,
1550             _eventData_.compressedIDs,
1551             plyr_[_pID].name,
1552             _realSender,
1553             _eth,
1554             _keys,
1555             _eventData_.winnerAddr,
1556             _eventData_.winnerName,
1557             _eventData_.amountWon,
1558             _eventData_.newPot,
1559             _eventData_.P3DAmount,
1560             _eventData_.genAmount,
1561             _eventData_.potAmount,
1562             airDropPot_
1563         );
1564     }
1565 
1566   //==============================================================================
1567   //    (~ _  _    _._|_    .
1568   //    _)(/_(_|_|| | | \/  .
1569   //====================/=========================================================
1570       /** upon contract deploy, it will be deactivated.  this is a one time
1571        * use function that will activate the contract.  we do this so devs
1572        * have time to set things up on the web end                            **/
1573       bool public activated_ = false;
1574       function activate()
1575           public
1576       {
1577           // only team just can activate
1578           require(msg.sender == admin, "only admin can activate");
1579 
1580 
1581           // can only be ran once
1582           require(activated_ == false, "FOMO Short already activated");
1583 
1584           // activate the contract
1585           activated_ = true;
1586 
1587           // lets start first round
1588           rID_ = 1;
1589               round_[1].strt = now + rndExtra_ - rndGap_;
1590               round_[1].end = now + rndInit_ + rndExtra_;
1591       }
1592   }