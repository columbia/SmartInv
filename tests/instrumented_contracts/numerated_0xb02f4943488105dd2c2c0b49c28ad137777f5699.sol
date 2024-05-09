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
440 interface PlayerBookInterface {
441     function getPlayerID(address _addr) external returns (uint256);
442     function getPlayerName(uint256 _pID) external view returns (bytes32);
443     function getPlayerLAff(uint256 _pID) external view returns (uint256);
444     function getPlayerAddr(uint256 _pID) external view returns (address);
445     function getNameFee() external view returns (uint256);
446     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
447     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
448     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
449 }
450 
451 
452 
453 contract modularFast is F3Devents {}
454 
455 
456 contract FoMo3DFast is modularFast {
457     using SafeMath for *;
458     using NameFilter for string;
459     using F3DKeysCalcShort for uint256;
460 
461     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xe04c48654AE73771AB6b73767c86D623bDc0bD98);
462 
463     address private admin = msg.sender;
464     string constant public name = "OTION";
465     string constant public symbol = "OTION";
466     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
467     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
468     uint256 constant private rndInit_ = 88 minutes;                // round timer starts at this
469     uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
470     uint256 constant private rndMax_ = 888 minutes;                // max length a round timer can be
471     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
472     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
473     uint256 public rID_;    // round id number / total rounds that have happened
474     //****************
475     // PLAYER DATA
476     //****************
477     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
478     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
479     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
480     // (pID => rID => data) player round data by player id & round id
481     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
482     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
483     //****************
484     // ROUND DATA
485     //****************
486     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
487     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
488     //****************
489     // TEAM FEE DATA
490     //****************
491     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
492     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
493 
494     constructor()
495         public
496     {
497     // Team allocation structures
498         // 0 = the only team
499         
500 
501     // Team allocation percentages
502         // (F3D, P3D) + (Pot , Referrals, Community)  解读:TeamFee, PotSplit 第一个参数都是分给现在key holder的比例, 第二个是给Pow3D的比例
503             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
504         fees_[0] = F3Ddatasets.TeamFee(80,0);   //10% to pot, 8% to aff, 2% to com
505 
506         // how to split up the final pot based on which team was picked
507         // (F3D, P3D)
508         potSplit_[0] = F3Ddatasets.PotSplit(0,0);  //100% to winner
509     }
510     //==============================================================================
511     //     _ _  _  _|. |`. _  _ _  .
512     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
513     //==============================================================================
514     /**
515     * @dev used to make sure no one can interact with contract until it has
516     * been activated.
517     */
518     modifier isActivated() {
519         require(activated_ == true, "its not ready yet.  check ?eta in discord");
520         _;
521     }
522 
523     /**
524     * @dev prevents contracts from interacting with fomo3d
525     */
526     modifier isHuman() {
527         address _addr = msg.sender;
528         uint256 _codeLength;
529 
530         assembly {_codeLength := extcodesize(_addr)}
531         require(_codeLength == 0, "sorry humans only");
532         _;
533     }
534 
535     /**
536     * @dev sets boundaries for incoming tx
537     */
538     modifier isWithinLimits(uint256 _eth) {
539         require(_eth >= 1000000000, "pocket lint: not a valid currency");
540         _;
541     }
542 
543     //==============================================================================
544     //     _    |_ |. _   |`    _  __|_. _  _  _  .
545     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
546     //====|=========================================================================
547     /**
548     * @dev emergency buy uses last stored affiliate ID and team snek
549     */
550     function()
551         isActivated()
552         isHuman()
553         isWithinLimits(msg.value)
554         public
555         payable
556     {
557         // set up our tx event data and determine if player is new or not
558         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
559 
560         // fetch player id
561         uint256 _pID = pIDxAddr_[msg.sender];
562 
563         // buy core
564         buyCore(_pID, _eventData_);
565     }
566 
567 
568 
569     function buyXnameQR(address _realSender)
570         isActivated()
571         isWithinLimits(msg.value)
572         public
573         payable
574     {
575         // set up our tx event data and determine if player is new or not
576         F3Ddatasets.EventReturns memory _eventData_ = determinePIDQR(_realSender,_eventData_);
577 
578         // fetch player id
579         uint256 _pID = pIDxAddr_[_realSender];
580 
581         // buy core
582         buyCoreQR(_realSender, _pID, _eventData_);
583     }
584 
585     /**
586     * @dev withdraws all of your earnings.
587     * -functionhash- 0x3ccfd60b
588     */
589     function withdraw()
590         isActivated()
591         isHuman()
592         public
593     {
594         // setup local rID
595         uint256 _rID = rID_;
596 
597         // grab time
598         uint256 _now = now;
599 
600         // fetch player ID
601         uint256 _pID = pIDxAddr_[msg.sender];
602 
603         // setup temp var for player eth
604         uint256 _eth;
605 
606         // check to see if round has ended and no one has run round end yet
607         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
608         {
609             // set up our tx event data
610             F3Ddatasets.EventReturns memory _eventData_;
611 
612             // end the round (distributes pot)
613             round_[_rID].ended = true;
614             _eventData_ = endRound(_eventData_);
615 
616             // get their earnings
617             _eth = withdrawEarnings(_pID);
618 
619             // gib moni
620             if (_eth > 0)
621                 plyr_[_pID].addr.transfer(_eth);
622 
623             // build event data
624             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
625             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
626 
627             // fire withdraw and distribute event
628             emit F3Devents.onWithdrawAndDistribute
629             (
630                 msg.sender,
631                 plyr_[_pID].name,
632                 _eth,
633                 _eventData_.compressedData,
634                 _eventData_.compressedIDs,
635                 _eventData_.winnerAddr,
636                 _eventData_.winnerName,
637                 _eventData_.amountWon,
638                 _eventData_.newPot,
639                 _eventData_.P3DAmount,
640                 _eventData_.genAmount
641             );
642 
643         // in any other situation
644         } else {
645             // get their earnings
646             _eth = withdrawEarnings(_pID);
647 
648             // gib moni
649             if (_eth > 0)
650                 plyr_[_pID].addr.transfer(_eth);
651 
652             // fire withdraw event
653             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
654         }
655     }
656 
657     /**
658     * @dev withdraws all of your earnings.
659     * -functionhash- 0x3ccfd60b
660     */
661     function withdrawQR(address _realSender)
662         isActivated()
663         payable
664         public
665     {
666         // setup local rID
667         uint256 _rID = rID_;
668 
669         // grab time
670         uint256 _now = now;
671 
672         // fetch player ID
673         uint256 _pID = pIDxAddr_[_realSender];
674 
675         // setup temp var for player eth
676         uint256 _eth;
677 
678         // check to see if round has ended and no one has run round end yet
679         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
680         {
681             // set up our tx event data
682             F3Ddatasets.EventReturns memory _eventData_;
683 
684             // end the round (distributes pot)
685             round_[_rID].ended = true;
686             _eventData_ = endRound(_eventData_);
687 
688             // get their earnings
689             _eth = withdrawEarnings(_pID);
690 
691             // gib moni
692             if (_eth > 0)
693                 plyr_[_pID].addr.transfer(_eth);
694 
695             // build event data
696             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
697             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
698 
699             // fire withdraw and distribute event
700             emit F3Devents.onWithdrawAndDistribute
701             (
702                 _realSender,
703                 plyr_[_pID].name,
704                 _eth,
705                 _eventData_.compressedData,
706                 _eventData_.compressedIDs,
707                 _eventData_.winnerAddr,
708                 _eventData_.winnerName,
709                 _eventData_.amountWon,
710                 _eventData_.newPot,
711                 _eventData_.P3DAmount,
712                 _eventData_.genAmount
713             );
714 
715         // in any other situation
716         } else {
717             // get their earnings
718             _eth = withdrawEarnings(_pID);
719 
720             // gib moni
721             if (_eth > 0)
722                 plyr_[_pID].addr.transfer(_eth);
723 
724             // fire withdraw event
725             emit F3Devents.onWithdraw(_pID, _realSender, plyr_[_pID].name, _eth, _now);
726         }
727     }
728 
729 
730     //==============================================================================
731     //     _  _ _|__|_ _  _ _  .
732     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
733     //=====_|=======================================================================
734     /**
735     * @dev return the price buyer will pay for next 1 individual key.
736     * -functionhash- 0x018a25e8
737     * @return price for next key bought (in wei format)
738     */
739     function getBuyPrice()
740         public
741         view
742         returns(uint256)
743     {
744         // setup local rID
745         uint256 _rID = rID_;
746 
747         // grab time
748         uint256 _now = now;
749 
750         // are we in a round?
751         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
752             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
753         else // rounds over.  need price for new round
754             return ( 75000000000000 ); // init
755     }
756 
757     /**
758     * @dev returns time left.  dont spam this, you'll ddos yourself from your node
759     * provider
760     * -functionhash- 0xc7e284b8
761     * @return time left in seconds
762     */
763     function getTimeLeft()
764         public
765         view
766         returns(uint256)
767     {
768         // setup local rID
769         uint256 _rID = rID_;
770 
771         // grab time
772         uint256 _now = now;
773 
774         if (_now < round_[_rID].end)
775             if (_now > round_[_rID].strt + rndGap_)
776                 return( (round_[_rID].end).sub(_now) );
777             else
778                 return( (round_[_rID].strt + rndGap_).sub(_now) );
779         else
780             return(0);
781     }
782 
783     /**
784     * @dev returns player earnings per vaults
785     * -functionhash- 0x63066434
786     * @return winnings vault
787     * @return general vault
788     * @return affiliate vault
789     */
790     function getPlayerVaults(uint256 _pID)
791         public
792         view
793         returns(uint256 ,uint256, uint256)
794     {
795         // setup local rID
796         uint256 _rID = rID_;
797 
798         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
799         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
800         {
801             // if player is winner
802             if (round_[_rID].plyr == _pID)
803             {
804                 return
805                 (
806                     (plyr_[_pID].win).add(((round_[_rID].pot))),
807                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
808                     plyr_[_pID].aff
809                 );
810             // if player is not the winner
811             } else {
812                 return
813                 (
814                     plyr_[_pID].win,
815                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
816                     plyr_[_pID].aff
817                 );
818             }
819 
820         // if round is still going on, or round has ended and round end has been ran
821         } else {
822             return
823             (
824                 plyr_[_pID].win,
825                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
826                 plyr_[_pID].aff
827             );
828         }
829     }
830 
831     /**
832     * solidity hates stack limits.  this lets us avoid that hate
833     */
834     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
835         private
836         view
837         returns(uint256)
838     {
839         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
840     }
841 
842     /**
843     * @dev returns all current round info needed for front end
844     * -functionhash- 0x747dff42
845     * @return eth invested during ICO phase
846     * @return round id
847     * @return total keys for round
848     * @return time round ends
849     * @return time round started
850     * @return current pot
851     * @return current team ID & player ID in lead
852     * @return current player in leads address
853     * @return current player in leads name
854     * @return eth in total
855     * @return 0
856     * @return 0
857     * @return 0
858     * @return airdrop tracker # & airdrop pot
859     */
860     function getCurrentRoundInfo()
861         public
862         view
863         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
864     {
865         // setup local rID
866         uint256 _rID = rID_;
867 
868         return
869         (
870             round_[_rID].ico,               //0
871             _rID,                           //1
872             round_[_rID].keys,              //2
873             round_[_rID].end,               //3
874             round_[_rID].strt,              //4
875             round_[_rID].pot,               //5
876             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
877             plyr_[round_[_rID].plyr].addr,  //7
878             plyr_[round_[_rID].plyr].name,  //8
879             rndTmEth_[_rID][0],             //9
880             rndTmEth_[_rID][1],             //10
881             rndTmEth_[_rID][2],             //11
882             rndTmEth_[_rID][3],             //12
883             airDropTracker_ + (airDropPot_ * 1000)              //13
884         );
885     }
886 
887     /**
888     * @dev returns player info based on address.  if no address is given, it will
889     * use msg.sender
890     * -functionhash- 0xee0b5d8b
891     * @param _addr address of the player you want to lookup
892     * @return player ID
893     * @return player name
894     * @return keys owned (current round)
895     * @return winnings vault
896     * @return general vault
897     * @return affiliate vault
898     * @return player round eth
899     */
900     function getPlayerInfoByAddress(address _addr)
901         public
902         view
903         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
904     {
905         // setup local rID
906         uint256 _rID = rID_;
907 
908         if (_addr == address(0))
909         {
910             _addr == msg.sender;
911         }
912         uint256 _pID = pIDxAddr_[_addr];
913 
914         return
915         (
916             _pID,                               //0
917             plyr_[_pID].name,                   //1
918             plyrRnds_[_pID][_rID].keys,         //2
919             plyr_[_pID].win,                    //3
920             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
921             plyr_[_pID].aff,                    //5
922             plyrRnds_[_pID][_rID].eth           //6
923         );
924     }
925 
926     //==============================================================================
927     //     _ _  _ _   | _  _ . _  .
928     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
929     //=====================_|=======================================================
930     /**
931     * @dev logic runs whenever a buy order is executed.  determines how to handle
932     * incoming eth depending on if we are in an active round or not
933     */
934     function buyCore(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
935         private
936     {
937         // setup local rID
938         uint256 _rID = rID_;
939 
940         // grab time
941         uint256 _now = now;
942         uint256 _affID = 1;
943         uint256 _team = 0;
944 
945         // if round is active
946         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
947         {
948             // call core
949             core(address(0), _rID, _pID, msg.value, _affID, _team, _eventData_);
950 
951         // if round is not active
952         } else {
953             // check to see if end round needs to be ran
954             if (_now > round_[_rID].end && round_[_rID].ended == false)
955             {
956                 // end the round (distributes pot) & start new round
957                 round_[_rID].ended = true;
958                 _eventData_ = endRound(_eventData_);
959 
960                 // build event data
961                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
962                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
963 
964                 // fire buy and distribute event
965                 emit F3Devents.onBuyAndDistribute
966                 (
967                     msg.sender,
968                     plyr_[_pID].name,
969                     msg.value,
970                     _eventData_.compressedData,
971                     _eventData_.compressedIDs,
972                     _eventData_.winnerAddr,
973                     _eventData_.winnerName,
974                     _eventData_.amountWon,
975                     _eventData_.newPot,
976                     _eventData_.P3DAmount,
977                     _eventData_.genAmount
978                 );
979             }
980 
981             // put eth in players vault
982             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
983         }
984     }
985 
986     /**
987     * @dev logic runs whenever a buy order is executed.  determines how to handle
988     * incoming eth depending on if we are in an active round or not
989     */
990     function buyCoreQR(address _realSender, uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
991         private
992     {
993         // setup local rID
994         uint256 _rID = rID_;
995 
996         // grab time
997         uint256 _now = now;
998         uint256 _affID = 1;
999         uint256 _team = 0;
1000 
1001         // if round is active
1002         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1003         {
1004             // call core
1005             core(_realSender,_rID, _pID, msg.value, _affID, _team, _eventData_);
1006 
1007         // if round is not active
1008         } else {
1009             // check to see if end round needs to be ran
1010             if (_now > round_[_rID].end && round_[_rID].ended == false)
1011             {
1012                 // end the round (distributes pot) & start new round
1013                 round_[_rID].ended = true;
1014                 _eventData_ = endRound(_eventData_);
1015 
1016                 // build event data
1017                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1018                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1019 
1020                 // fire buy and distribute event
1021                 emit F3Devents.onBuyAndDistribute
1022                 (
1023                     _realSender,
1024                     plyr_[_pID].name,
1025                     msg.value,
1026                     _eventData_.compressedData,
1027                     _eventData_.compressedIDs,
1028                     _eventData_.winnerAddr,
1029                     _eventData_.winnerName,
1030                     _eventData_.amountWon,
1031                     _eventData_.newPot,
1032                     _eventData_.P3DAmount,
1033                     _eventData_.genAmount
1034                 );
1035             }
1036 
1037             // put eth in players vault
1038             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1039         }
1040     }
1041 
1042     /**
1043     * @dev this is the core logic for any buy/reload that happens while a round
1044     * is live.
1045     */
1046     function core(address _realSender, uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1047         private
1048     {
1049         // if player is new to round
1050         if (plyrRnds_[_pID][_rID].keys == 0)
1051             _eventData_ = managePlayer(_pID, _eventData_);
1052 
1053         // early round eth limiter
1054         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1055         {
1056             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1057             uint256 _refund = _eth.sub(_availableLimit);
1058             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1059             _eth = _availableLimit;
1060         }
1061 
1062         // if eth left is greater than min eth allowed (sorry no pocket lint)
1063         if (_eth > 1000000000)
1064         {
1065 
1066             // mint the new keys
1067             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1068 
1069             // if they bought at least 1 whole key
1070             if (_keys >= 1000000000000000000)
1071             {
1072                 updateTimer(_keys, _rID);
1073 
1074                 // set new leaders
1075                 if (round_[_rID].plyr != _pID)
1076                     round_[_rID].plyr = _pID;
1077                 if (round_[_rID].team != _team)
1078                     round_[_rID].team = _team;
1079 
1080                 // set the new leader bool to true
1081                 _eventData_.compressedData = _eventData_.compressedData + 100;
1082             }
1083 
1084             // update player
1085             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1086             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1087 
1088             // update round
1089             round_[_rID].keys = _keys.add(round_[_rID].keys);
1090             round_[_rID].eth = _eth.add(round_[_rID].eth);
1091             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1092 
1093             // distribute eth
1094             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1095             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1096 
1097             // call end tx function to fire end tx event.
1098             endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1099         }
1100     }
1101 
1102 
1103   //==============================================================================
1104   //     _ _ | _   | _ _|_ _  _ _  .
1105   //    (_(_||(_|_||(_| | (_)| _\  .
1106   //==============================================================================
1107       /**
1108        * @dev calculates unmasked earnings (just calculates, does not update mask)
1109        * @return earnings in wei format
1110        */
1111       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1112           private
1113           view
1114           returns(uint256)
1115       {
1116           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1117       }
1118 
1119       /**
1120        * @dev returns the amount of keys you would get given an amount of eth.
1121        * -functionhash- 0xce89c80c
1122        * @param _rID round ID you want price for
1123        * @param _eth amount of eth sent in
1124        * @return keys received
1125        */
1126       function calcKeysReceived(uint256 _rID, uint256 _eth)
1127           public
1128           view
1129           returns(uint256)
1130       {
1131           // grab time
1132           uint256 _now = now;
1133 
1134           // are we in a round?
1135           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1136               return ( (round_[_rID].eth).keysRec(_eth) );
1137           else // rounds over.  need keys for new round
1138               return ( (_eth).keys() );
1139       }
1140 
1141       /**
1142        * @dev returns current eth price for X keys.
1143        * -functionhash- 0xcf808000
1144        * @param _keys number of keys desired (in 18 decimal format)
1145        * @return amount of eth needed to send
1146        */
1147       function iWantXKeys(uint256 _keys)
1148           public
1149           view
1150           returns(uint256)
1151       {
1152           // setup local rID
1153           uint256 _rID = rID_;
1154 
1155           // grab time
1156           uint256 _now = now;
1157 
1158           // are we in a round?
1159           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1160               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1161           else // rounds over.  need price for new round
1162               return ( (_keys).eth() );
1163       }
1164   //==============================================================================
1165   //    _|_ _  _ | _  .
1166   //     | (_)(_)|_\  .
1167   //==============================================================================
1168       /**
1169   	 * @dev receives name/player info from names contract
1170        */
1171       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1172           external
1173       {
1174           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1175           if (pIDxAddr_[_addr] != _pID)
1176               pIDxAddr_[_addr] = _pID;
1177           if (pIDxName_[_name] != _pID)
1178               pIDxName_[_name] = _pID;
1179           if (plyr_[_pID].addr != _addr)
1180               plyr_[_pID].addr = _addr;
1181           if (plyr_[_pID].name != _name)
1182               plyr_[_pID].name = _name;
1183           if (plyr_[_pID].laff != _laff)
1184               plyr_[_pID].laff = _laff;
1185           if (plyrNames_[_pID][_name] == false)
1186               plyrNames_[_pID][_name] = true;
1187       }
1188 
1189       /**
1190        * @dev receives entire player name list
1191        */
1192       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1193           external
1194       {
1195           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1196           if(plyrNames_[_pID][_name] == false)
1197               plyrNames_[_pID][_name] = true;
1198       }
1199 
1200       /**
1201        * @dev gets existing or registers new pID.  use this when a player may be new
1202        * @return pID
1203        */
1204       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1205           private
1206           returns (F3Ddatasets.EventReturns)
1207       {
1208           uint256 _pID = pIDxAddr_[msg.sender];
1209           // if player is new to this version of fomo3d
1210           if (_pID == 0)
1211           {
1212               // grab their player ID, name and last aff ID, from player names contract
1213               _pID = PlayerBook.getPlayerID(msg.sender);
1214               bytes32 _name = PlayerBook.getPlayerName(_pID);
1215               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1216 
1217               // set up player account
1218               pIDxAddr_[msg.sender] = _pID;
1219               plyr_[_pID].addr = msg.sender;
1220 
1221               if (_name != "")
1222               {
1223                   pIDxName_[_name] = _pID;
1224                   plyr_[_pID].name = _name;
1225                   plyrNames_[_pID][_name] = true;
1226               }
1227 
1228               if (_laff != 0 && _laff != _pID)
1229                   plyr_[_pID].laff = _laff;
1230 
1231               // set the new player bool to true
1232               _eventData_.compressedData = _eventData_.compressedData + 1;
1233           }
1234           return (_eventData_);
1235       }
1236 
1237 
1238     /**
1239     * @dev gets existing or registers new pID.  use this when a player may be new
1240     * @return pID
1241     */
1242     function determinePIDQR(address _realSender, F3Ddatasets.EventReturns memory _eventData_)
1243         private
1244         returns (F3Ddatasets.EventReturns)
1245     {
1246         uint256 _pID = pIDxAddr_[_realSender];
1247         // if player is new to this version of fomo3d
1248         if (_pID == 0)
1249         {
1250             // grab their player ID, name and last aff ID, from player names contract
1251             _pID = PlayerBook.getPlayerID(_realSender);
1252             bytes32 _name = PlayerBook.getPlayerName(_pID);
1253             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1254 
1255             // set up player account
1256             pIDxAddr_[_realSender] = _pID;
1257             plyr_[_pID].addr = _realSender;
1258 
1259             if (_name != "")
1260             {
1261                 pIDxName_[_name] = _pID;
1262                 plyr_[_pID].name = _name;
1263                 plyrNames_[_pID][_name] = true;
1264             }
1265 
1266             if (_laff != 0 && _laff != _pID)
1267                 plyr_[_pID].laff = _laff;
1268 
1269             // set the new player bool to true
1270             _eventData_.compressedData = _eventData_.compressedData + 1;
1271         }
1272         return (_eventData_);
1273     }
1274 
1275       /**
1276        * @dev checks to make sure user picked a valid team.  if not sets team
1277        * to default (sneks)
1278        */
1279       function verifyTeam(uint256 _team)
1280           private
1281           pure
1282           returns (uint256)
1283       {
1284           if (_team < 0 || _team > 3)
1285               return(2);
1286           else
1287               return(_team);
1288       }
1289 
1290       /**
1291        * @dev decides if round end needs to be run & new round started.  and if
1292        * player unmasked earnings from previously played rounds need to be moved.
1293        */
1294       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1295           private
1296           returns (F3Ddatasets.EventReturns)
1297       {
1298           // if player has played a previous round, move their unmasked earnings
1299           // from that round to gen vault.
1300           if (plyr_[_pID].lrnd != 0)
1301               updateGenVault(_pID, plyr_[_pID].lrnd);
1302 
1303           // update player's last round played
1304           plyr_[_pID].lrnd = rID_;
1305 
1306           // set the joined round bool to true
1307           _eventData_.compressedData = _eventData_.compressedData + 10;
1308 
1309           return(_eventData_);
1310       }
1311 
1312     /**
1313     * @dev ends the round. manages paying out winner/splitting up pot
1314     */
1315     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1316         private
1317         returns (F3Ddatasets.EventReturns)
1318     {
1319         // setup local rID
1320         uint256 _rID = rID_;
1321 
1322         // grab our winning player and team id's
1323         uint256 _winPID = round_[_rID].plyr;
1324         uint256 _winTID = round_[_rID].team;
1325 
1326         // grab our pot amount
1327         uint256 _pot = round_[_rID].pot;
1328 
1329         // calculate our winner share, community rewards, gen share,
1330         // p3d share, and amount reserved for next pot
1331         uint256 _win = _pot;
1332         uint256 _gen = 0;
1333         uint256 _p3d = 0;
1334         uint256 _res = 0; // actually 0 eth to the next round
1335 
1336         // calculate ppt for round mask
1337         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1338 
1339         // pay our winner
1340         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1341 
1342         // distribute gen portion to key holders
1343         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1344 
1345         // prepare event data
1346         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1347         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1348         _eventData_.winnerAddr = plyr_[_winPID].addr;
1349         _eventData_.winnerName = plyr_[_winPID].name;
1350         _eventData_.amountWon = _win;
1351         _eventData_.genAmount = _gen;
1352         _eventData_.P3DAmount = _p3d;
1353         _eventData_.newPot = _res;
1354 
1355         // start next round
1356         rID_++;
1357         _rID++;
1358         round_[_rID].strt = now;
1359         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1360         round_[_rID].pot = _res;
1361 
1362         return(_eventData_);
1363     }
1364 
1365     /**
1366     * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1367     */
1368     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1369         private
1370     {
1371         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1372         if (_earnings > 0)
1373         {
1374             // put in gen vault
1375             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1376             // zero out their earnings by updating mask
1377             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1378         }
1379     }
1380 
1381     /**
1382     * @dev updates round timer based on number of whole keys bought.
1383     */
1384     function updateTimer(uint256 _keys, uint256 _rID)
1385         private
1386     {
1387         // grab time
1388         uint256 _now = now;
1389 
1390         // calculate time based on number of keys bought
1391         uint256 _newTime;
1392         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1393             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1394         else
1395             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1396 
1397         // compare to max and set new end time
1398         if (_newTime < (rndMax_).add(_now))
1399             round_[_rID].end = _newTime;
1400         else
1401             round_[_rID].end = rndMax_.add(_now);
1402     }
1403 
1404 
1405     /**
1406     * @dev distributes eth based on fees to com, aff, and p3d
1407     */
1408     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1409         private
1410         returns(F3Ddatasets.EventReturns)
1411     {
1412         // pay 2% out to developers rewards
1413         uint256 _p3d = _eth / 50;
1414 
1415         // distribute share to running team
1416         uint256 _aff = _eth.mul(8) / 100;
1417 
1418         // decide what to do with affiliate share of fees
1419         // affiliate must not be self, and must have a name registered
1420         plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1421         emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1422 
1423         // pay out p3d
1424         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1425         if (_p3d > 0)
1426         {
1427             // deposit to divies contract
1428             admin.transfer(_p3d);
1429             // set up event data
1430             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1431         }
1432         return(_eventData_);
1433     }
1434 
1435     function potSwap()
1436         external
1437         payable
1438     {
1439         // setup local rID
1440         uint256 _rID = rID_ + 1;
1441 
1442         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1443         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1444     }
1445 
1446     /**
1447     * @dev distributes eth based on fees to gen and pot
1448     */
1449     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1450         private
1451         returns(F3Ddatasets.EventReturns)
1452     {
1453         // calculate gen share
1454         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1455 
1456         // distribute 10% to pot
1457         uint256 _potAmount = _eth / 10;
1458 
1459         // distribute gen share (thats what updateMasks() does) and adjust
1460         // balances for dust.
1461         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1462         if (_dust > 0)
1463             _gen = _gen.sub(_dust);
1464 
1465         // add eth to pot
1466         round_[_rID].pot = _potAmount.add(_dust).add(round_[_rID].pot);
1467 
1468         // set up event data
1469         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1470         _eventData_.potAmount = _potAmount;
1471 
1472         return(_eventData_);
1473     }
1474 
1475 
1476       /**
1477        * @dev updates masks for round and player when keys are bought
1478        * @return dust left over
1479        */
1480       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1481           private
1482           returns(uint256)
1483       {
1484           /* MASKING NOTES
1485               earnings masks are a tricky thing for people to wrap their minds around.
1486               the basic thing to understand here.  is were going to have a global
1487               tracker based on profit per share for each round, that increases in
1488               relevant proportion to the increase in share supply.
1489 
1490               the player will have an additional mask that basically says "based
1491               on the rounds mask, my shares, and how much i've already withdrawn,
1492               how much is still owed to me?"
1493           */
1494 
1495           // calc profit per key & round mask based on this buy:  (dust goes to pot)
1496           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1497           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1498 
1499           // calculate player earning from their own buy (only based on the keys
1500           // they just bought).  & update player earnings mask
1501           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1502           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1503 
1504           // calculate & return dust
1505           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1506       }
1507 
1508     /**
1509     * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1510     * @return earnings in wei format
1511     */
1512     function withdrawEarnings(uint256 _pID)
1513         private
1514         returns(uint256)
1515     {
1516         // update gen vault
1517         updateGenVault(_pID, plyr_[_pID].lrnd);
1518 
1519         // from vaults
1520         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1521         if (_earnings > 0)
1522         {
1523             plyr_[_pID].win = 0;
1524             plyr_[_pID].gen = 0;
1525             plyr_[_pID].aff = 0;
1526         }
1527 
1528         return(_earnings);
1529     }
1530 
1531     /**
1532     * @dev prepares compression data and fires event for buy or reload tx's
1533     */
1534     function endTxQR(address _realSender,uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1535         private
1536     {
1537         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1538         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1539 
1540         emit F3Devents.onEndTx
1541         (
1542             _eventData_.compressedData,
1543             _eventData_.compressedIDs,
1544             plyr_[_pID].name,
1545             _realSender,
1546             _eth,
1547             _keys,
1548             _eventData_.winnerAddr,
1549             _eventData_.winnerName,
1550             _eventData_.amountWon,
1551             _eventData_.newPot,
1552             _eventData_.P3DAmount,
1553             _eventData_.genAmount,
1554             _eventData_.potAmount,
1555             airDropPot_
1556         );
1557     }
1558 
1559   //==============================================================================
1560   //    (~ _  _    _._|_    .
1561   //    _)(/_(_|_|| | | \/  .
1562   //====================/=========================================================
1563       /** upon contract deploy, it will be deactivated.  this is a one time
1564        * use function that will activate the contract.  we do this so devs
1565        * have time to set things up on the web end                            **/
1566       bool public activated_ = false;
1567       function activate()
1568           public
1569       {
1570           // only team just can activate
1571           require(msg.sender == admin, "only admin can activate");
1572 
1573 
1574           // can only be ran once
1575           require(activated_ == false, "FOMO Short already activated");
1576 
1577           // activate the contract
1578           activated_ = true;
1579 
1580           // lets start first round
1581           rID_ = 1;
1582               round_[1].strt = now + rndExtra_ - rndGap_;
1583               round_[1].end = now + rndInit_ + rndExtra_;
1584       }
1585   }