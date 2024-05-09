1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interface/PlayerBookInterface.sol
4 
5 interface PlayerBookInterface {
6     function getPlayerID(address _addr) external returns(uint256);
7     function getPlayerName(uint256 _pID) external view returns(bytes32);
8     function getPlayerLAff(uint256 _pID) external view returns(uint256);
9     function getPlayerAddr(uint256 _pID) external view returns(address);
10     function getNameFee() external view returns(uint256);
11     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
12     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
13     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
14 }
15 
16 // File: contracts/interface/TeamPerfitForwarderInterface.sol
17 
18 interface TeamPerfitForwarderInterface {
19     function deposit() external payable returns(bool);
20     function status() external view returns(address, address);
21 }
22 
23 // File: contracts/interface/DRSCoinInterface.sol
24 
25 interface DRSCoinInterface {
26     function mint(address _to, uint256 _amount) external;
27     function profitEth() external payable;
28 }
29 
30 // File: contracts/library/SafeMath.sol
31 
32 /**
33  * @title SafeMath v0.1.9
34  * @dev Math operations with safety checks that throw on error
35  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
36  * - added sqrt
37  * - added sq
38  * - added pwr 
39  * - changed asserts to requires with error log outputs
40  * - removed div, its useless
41  */
42 library SafeMath {
43     
44     /**
45     * @dev Multiplies two numbers, throws on overflow.
46     */
47     function mul(uint256 a, uint256 b) 
48         internal 
49         pure 
50         returns (uint256 c) 
51     {
52         if (a == 0) {
53             return 0;
54         }
55         c = a * b;
56         require(c / a == b, "SafeMath mul failed");
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two numbers, truncating the quotient.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         assert(b > 0);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67         return c;
68     }
69     
70     /**
71     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b)
74         internal
75         pure
76         returns (uint256) 
77     {
78         require(b <= a, "SafeMath sub failed");
79         return a - b;
80     }
81 
82     /**
83     * @dev Adds two numbers, throws on overflow.
84     */
85     function add(uint256 a, uint256 b)
86         internal
87         pure
88         returns (uint256 c) 
89     {
90         c = a + b;
91         require(c >= a, "SafeMath add failed");
92         return c;
93     }
94     
95     /**
96      * @dev gives square root of given x.
97      */
98     function sqrt(uint256 x)
99         internal
100         pure
101         returns (uint256 y) 
102     {
103         uint256 z = ((add(x,1)) / 2);
104         y = x;
105         while (z < y) 
106         {
107             y = z;
108             z = ((add((x / z),z)) / 2);
109         }
110     }
111     
112     /**
113      * @dev gives square. multiplies x by x
114      */
115     function sq(uint256 x)
116         internal
117         pure
118         returns (uint256)
119     {
120         return (mul(x,x));
121     }
122     
123     /**
124      * @dev x to the power of y 
125      */
126     function pwr(uint256 x, uint256 y)
127         internal 
128         pure 
129         returns (uint256)
130     {
131         if (x==0)
132             return (0);
133         else if (y==0)
134             return (1);
135         else 
136         {
137             uint256 z = x;
138             for (uint256 i=1; i < y; i++)
139                 z = mul(z,x);
140             return (z);
141         }
142     }
143 }
144 
145 // File: contracts/library/NameFilter.sol
146 
147 library NameFilter {
148     /**
149      * @dev filters name strings
150      * -converts uppercase to lower case.  
151      * -makes sure it does not start/end with a space
152      * -makes sure it does not contain multiple spaces in a row
153      * -cannot be only numbers
154      * -cannot start with 0x 
155      * -restricts characters to A-Z, a-z, 0-9, and space.
156      * @return reprocessed string in bytes32 format
157      */
158     function nameFilter(string _input)
159         internal
160         pure
161         returns(bytes32)
162     {
163         bytes memory _temp = bytes(_input);
164         uint256 _length = _temp.length;
165         
166         //sorry limited to 32 characters
167         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
168         // make sure it doesnt start with or end with space
169         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
170         // make sure first two characters are not 0x
171         if (_temp[0] == 0x30)
172         {
173             require(_temp[1] != 0x78, "string cannot start with 0x");
174             require(_temp[1] != 0x58, "string cannot start with 0X");
175         }
176         
177         // create a bool to track if we have a non number character
178         bool _hasNonNumber;
179         
180         // convert & check
181         for (uint256 i = 0; i < _length; i++)
182         {
183             // if its uppercase A-Z
184             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
185             {
186                 // convert to lower case a-z
187                 _temp[i] = byte(uint(_temp[i]) + 32);
188                 
189                 // we have a non number
190                 if (_hasNonNumber == false)
191                     _hasNonNumber = true;
192             } else {
193                 require
194                 (
195                     // require character is a space
196                     _temp[i] == 0x20 || 
197                     // OR lowercase a-z
198                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
199                     // or 0-9
200                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
201                     "string contains invalid characters"
202                 );
203                 // make sure theres not 2x spaces in a row
204                 if (_temp[i] == 0x20)
205                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
206                 
207                 // see if we have a character other than a number
208                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
209                     _hasNonNumber = true;    
210             }
211         }
212         
213         require(_hasNonNumber == true, "string cannot be only numbers");
214         
215         bytes32 _ret;
216         assembly {
217             _ret := mload(add(_temp, 32))
218         }
219         return (_ret);
220     }
221 }
222 
223 // File: contracts/library/DRSDatasets.sol
224 
225 // structs ==============================================================================
226 library DRSDatasets {
227     //compressedData key
228     // [24-14][13-3][2][1][0]
229         // 0 - new player (bool)
230         // 1 - joined round (bool)
231         // 2 - new  leader (bool)
232         // 3-13 - round end time
233         // 14 - 24 timestamp
234 
235     //compressedIDs key
236     // [77-52][51-26][25-0]
237         // 0-25 - pID 
238         // 26-51 - winPID
239         // 52-77 - rID
240     struct EventReturns {
241         uint256 compressedData;
242         uint256 compressedIDs;
243 
244         address winnerAddr;         // winner address
245         bytes32 winnerName;         // winner name
246         uint256 amountWon;          // amount won
247 
248         uint256 newPot;             // amount in new pot
249         uint256 genAmount;          // amount distributed to gen
250         uint256 potAmount;          // amount added to pot
251 
252         address genAddr;
253         uint256 genKeyPrice;
254     }
255 
256     function setNewPlayerFlag(EventReturns _event) internal pure returns(EventReturns) {
257         _event.compressedData = _event.compressedData + 1;
258         return _event;
259     }
260 
261     function setJoinedRoundFlag(EventReturns _event) internal pure returns(EventReturns) {
262         _event.compressedData = _event.compressedData + 10;
263         return _event;
264     }
265 
266     function setNewLeaderFlag(EventReturns _event) internal pure returns(EventReturns) {
267         _event.compressedData = _event.compressedData + 100;
268         return _event;
269     }
270 
271     function setRoundEndTime(EventReturns _event, uint256 roundEndTime) internal pure returns(EventReturns) {
272         _event.compressedData = _event.compressedData + roundEndTime * (10**3);
273         return _event;
274     }
275 
276     function setTimestamp(EventReturns _event, uint256 timestamp) internal pure returns(EventReturns) {
277         _event.compressedData = _event.compressedData + timestamp * (10**14);
278         return _event;
279     }
280 
281     function setPID(EventReturns _event, uint256 _pID) internal pure returns(EventReturns) {
282         _event.compressedIDs = _event.compressedIDs + _pID;
283         return _event;
284     }
285 
286     function setWinPID(EventReturns _event, uint256 _winPID) internal pure returns(EventReturns) {
287         _event.compressedIDs = _event.compressedIDs + (_winPID * (10**26));
288         return _event;
289     }
290 
291     function setRID(EventReturns _event, uint256 _rID) internal pure returns(EventReturns) {
292         _event.compressedIDs = _event.compressedIDs + (_rID * (10**52));
293         return _event;
294     }
295 
296     function setWinner(EventReturns _event, address _winnerAddr, bytes32 _winnerName, uint256 _amountWon)
297         internal pure returns(EventReturns) {
298         _event.winnerAddr = _winnerAddr;
299         _event.winnerName = _winnerName;
300         _event.amountWon = _amountWon;
301         return _event;
302     }
303 
304     function setGenInfo(EventReturns _event, address _genAddr, uint256 _genKeyPrice)
305         internal pure returns(EventReturns) {
306         _event.genAddr = _genAddr;
307         _event.genKeyPrice = _genKeyPrice;
308     }
309 
310     function setNewPot(EventReturns _event, uint256 _newPot) internal pure returns(EventReturns) {
311         _event.newPot = _newPot;
312         return _event;
313     }
314 
315     function setGenAmount(EventReturns _event, uint256 _genAmount) internal pure returns(EventReturns) {
316         _event.genAmount = _genAmount;
317         return _event;
318     }
319 
320     function setPotAmount(EventReturns _event, uint256 _potAmount) internal pure returns(EventReturns) {
321         _event.potAmount = _potAmount;
322         return _event;
323     }
324 
325     struct Player {
326         address addr;   // player address
327         bytes32 name;   // player name
328         uint256 win;    // winnings vault
329         uint256 gen;    // general vault
330         // uint256 aff;    // affiliate vault
331         uint256 lrnd;   // last round played
332         // uint256 laff;   // last affiliate id used
333     }
334 
335     struct PlayerRound {
336         uint256 eth;    // eth player has added to round (used for eth limiter)
337         uint256 keys;   // keys
338     }
339 
340     struct Round {
341         uint256 plyr;   // pID of player in lead
342 
343         uint256 end;    // time ends/ended
344         bool ended;     // has round end function been ran
345         uint256 strt;   // time round started
346         uint256 keys;   // keys
347         uint256 eth;    // total eth in
348         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
349     }
350 
351     struct BuyInfo {
352         address addr;   // player address
353         bytes32 name;   // player name
354         uint256 pid;    // player id
355         uint256 keyPrice;
356         uint256 keyIndex;
357     }
358 }
359 
360 // File: contracts/DRSEvents.sol
361 
362 contract DRSEvents {
363     // fired whenever a player registers a name
364     event onNewName
365     (
366         uint256 indexed playerID,
367         address indexed playerAddress,
368         bytes32 indexed playerName,
369         bool isNewPlayer,
370         // uint256 affiliateID,
371         // address affiliateAddress,
372         // bytes32 affiliateName,
373         uint256 amountPaid,
374         uint256 timeStamp
375     );
376 
377     // fired at end of buy or reload
378     event onEndTx
379     (
380         uint256 compressedData,
381         uint256 compressedIDs,
382 
383         bytes32 playerName,
384         address playerAddress,
385         uint256 ethIn,
386         uint256 keyIndex,
387 
388         address winnerAddr,
389         bytes32 winnerName,
390         uint256 amountWon,
391 
392         uint256 newPot,
393         uint256 genAmount,
394         uint256 potAmount,
395 
396         address genAddr,
397         uint256 genKeyPrice
398     );
399 
400     // fired whenever theres a withdraw
401     event onWithdraw
402     (
403         uint256 indexed playerID,
404         address playerAddress,
405         bytes32 playerName,
406         uint256 ethOut,
407         uint256 timeStamp
408     );
409 
410     // fired whenever a withdraw forces end round to be ran
411     event onWithdrawAndDistribute
412     (
413         address playerAddress,
414         bytes32 playerName,
415         uint256 ethOut,
416         uint256 compressedData,
417 
418         uint256 compressedIDs,
419 
420         address winnerAddr,
421         bytes32 winnerName,
422         uint256 amountWon,
423 
424         uint256 newPot,
425         uint256 genAmount
426     );
427 
428     // fired whenever a player tries a buy after round timer
429     // hit zero, and causes end round to be ran.
430     event onBuyAndDistribute
431     (
432         address playerAddress,
433         bytes32 playerName,
434         uint256 ethIn,
435         uint256 compressedData,
436 
437         uint256 compressedIDs,
438 
439         address winnerAddr,
440         bytes32 winnerName,
441         uint256 amountWon,
442 
443         uint256 newPot,
444         uint256 genAmount
445     );
446 
447     // fired whenever a player tries a reload after round timer
448     // hit zero, and causes end round to be ran.
449     event onReLoadAndDistribute
450     (
451         address playerAddress,
452         bytes32 playerName,
453         uint256 compressedData,
454 
455         uint256 compressedIDs,
456 
457         address winnerAddr,
458         bytes32 winnerName,
459         uint256 amountWon,
460 
461         uint256 newPot,
462         uint256 genAmount
463     );
464 
465     event onBuyKeyFailure
466     (
467         uint256 roundID,
468         uint256 indexed playerID,
469         uint256 amount,
470         uint256 keyPrice,
471         uint256 timeStamp
472     );
473 }
474 
475 // File: contracts/ReserveBag.sol
476 
477 contract ReserveBag is DRSEvents {
478     using SafeMath for uint256;
479     using NameFilter for string;
480     using DRSDatasets for DRSDatasets.EventReturns;
481 
482     TeamPerfitForwarderInterface public teamPerfit;
483     PlayerBookInterface public playerBook;
484     DRSCoinInterface public drsCoin;
485 
486     // game settings
487     string constant public name = "Reserve Bag";
488     string constant public symbol = "RB";
489 
490     uint256 constant private initKeyPrice = (10**18);
491 
492     uint256 private rndExtra_ = 0;       // length of the very first ICO 
493     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
494 
495     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
496     // uint256 constant private rndMax_ = 5 seconds;                // max length a round timer can be
497 
498     uint256 public rID_;    // round id number / total rounds that have happened
499 
500     uint256 public keyPrice = initKeyPrice;
501     uint256 public keyBought = 0;
502 
503     address public owner;
504 
505     uint256 public teamPerfitAmuont = 0;
506 
507     uint256 public rewardInternal = 36;
508     // uint256 public potRatio = 8;
509     uint256 public keyPriceIncreaseRatio = 8;
510     uint256 public genRatio = 90;
511 
512     uint256 public drsCoinDividendRatio = 40;
513     uint256 public teamPerfitRatio = 5;
514 
515     uint256 public ethMintDRSCoinRate = 100;
516 
517     bool public activated_ = false;
518 
519     // PLAYER DATA
520     mapping(address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
521     mapping(bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
522     mapping(uint256 => DRSDatasets.Player) public plyr_;   // (pID => data) player data
523     mapping(uint256 => mapping(uint256 => DRSDatasets.PlayerRound)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
524     mapping(uint256 => mapping(bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
525 
526     DRSDatasets.BuyInfo[] buyinfos;
527     uint256 private startIndex;
528     uint256 private endIndex;
529 
530     // ROUND DATA 
531     mapping(uint256 => DRSDatasets.Round) public round_;   // (rID => data) round data
532 
533     // event Info(uint256 _value);
534 
535     constructor(address _teamPerfit, address _playBook, address _drsCoin) public
536     {
537         owner = msg.sender;
538 
539         teamPerfit = TeamPerfitForwarderInterface(_teamPerfit);
540         playerBook = PlayerBookInterface(_playBook);
541         drsCoin = DRSCoinInterface(_drsCoin);
542 
543         startIndex = 0;
544         endIndex = 0;
545     }
546 
547     modifier onlyOwner {
548         assert(owner == msg.sender);
549         _;
550     }
551 
552     /**
553      * @dev prevents contracts from interacting with ReserveBag 
554      */
555     modifier isHuman() {
556         address _addr = msg.sender;
557         require(_addr == tx.origin);
558 
559         uint256 _codeLength;
560         
561         assembly {_codeLength := extcodesize(_addr)}
562         require(_codeLength == 0, "sorry humans only");
563         _;
564     }
565 
566     /**
567      * @dev sets boundaries for incoming tx 
568      */
569     modifier isWithinLimits(uint256 _eth) {
570         require(_eth >= 1000000000, "pocket lint: not a valid currency");
571         require(_eth <= 100000 * (10**18), "no vitalik, no");
572         _;
573     }
574 
575     function pushBuyInfo(DRSDatasets.BuyInfo info) internal {
576         if(endIndex == buyinfos.length) {
577             buyinfos.push(info);
578         } else if(endIndex < buyinfos.length) {
579             buyinfos[endIndex] = info;
580         } else {
581             // cannot happen
582             revert();
583         }
584 
585         endIndex = (endIndex + 1) % (rewardInternal + 1);
586 
587         if(endIndex == startIndex) {
588             startIndex = (startIndex + 1) % (rewardInternal + 1);
589         }
590     }
591 
592     /**
593      * @dev emergency buy uses last stored affiliate ID and team snek
594      */
595     function()
596         isActivated()
597         isHuman()
598         isWithinLimits(msg.value)
599         public
600         payable
601     {
602         // set up our tx event data and determine if player is new or not
603         DRSDatasets.EventReturns memory _eventData_;
604         _eventData_ = determinePID(_eventData_);
605 
606         // fetch player id
607         uint256 _pID = pIDxAddr_[msg.sender];
608 
609         // buy core 
610         buyCore(_pID, _eventData_);
611     }
612 
613     function buyKey()
614         isActivated()
615         isHuman()
616         isWithinLimits(msg.value)
617         public
618         payable
619     {
620         // set up our tx event data and determine if player is new or not
621         DRSDatasets.EventReturns memory _eventData_;
622         _eventData_ = determinePID(_eventData_);
623 
624         // fetch player id
625         uint256 _pID = pIDxAddr_[msg.sender];
626 
627         // buy core 
628         buyCore(_pID, _eventData_);
629     }
630 
631     function reLoadXaddr(uint256 _eth)
632         isActivated()
633         isHuman()
634         isWithinLimits(_eth)
635         public
636     {
637         // fetch player ID
638         uint256 _pID = pIDxAddr_[msg.sender];
639 
640         require(_pID != 0, "reLoadXaddr can not be called by new players");
641 
642         // set up our tx event data
643         DRSDatasets.EventReturns memory _eventData_;
644 
645         // reload core
646         reLoadCore(_pID, _eth, _eventData_);
647     }
648 
649     function withdrawTeamPerfit()
650         isActivated()
651         onlyOwner()
652         public
653     {
654         if(teamPerfitAmuont > 0) {
655             uint256 _perfit = teamPerfitAmuont;
656 
657             teamPerfitAmuont = 0;
658 
659             owner.transfer(_perfit);
660         }
661     }
662 
663     function getTeamPerfitAmuont() public view returns(uint256) {
664         return teamPerfitAmuont;
665     }
666 
667     /**
668      * @dev withdraws all of your earnings.
669      * -functionhash- 0x3ccfd60b
670      */
671     function withdraw()
672         isActivated()
673         isHuman()
674         public
675     {
676         // fetch player ID
677         uint256 _pID = pIDxAddr_[msg.sender];
678 
679         require(_pID != 0, "withdraw can not be called by new players");
680 
681         // setup local rID
682         uint256 _rID = rID_;
683 
684         // grab time
685         uint256 _now = now;
686 
687         // setup temp var for player eth
688         uint256 _eth;
689 
690         // check to see if round has ended and no one has run round end yet
691         if(_now > round_[_rID].end && !round_[_rID].ended && round_[_rID].plyr != 0)
692         {
693             // set up our tx event data
694             DRSDatasets.EventReturns memory _eventData_;
695 
696             // end the round (distributes pot)
697             round_[_rID].ended = true;
698             _eventData_ = endRound(_eventData_);
699 
700             // get their earnings
701             _eth = withdrawEarnings(_pID);
702 
703             // withdraw eth
704             if(_eth > 0) {
705                 plyr_[_pID].addr.transfer(_eth);    
706             }
707 
708             // build event data
709             _eventData_ = _eventData_.setTimestamp(_now);
710             _eventData_ = _eventData_.setPID(_pID);
711 
712             // fire withdraw and distribute event
713             emit DRSEvents.onWithdrawAndDistribute
714             (
715                 msg.sender,
716                 plyr_[_pID].name,
717                 _eth,
718                 _eventData_.compressedData,
719                 _eventData_.compressedIDs,
720 
721                 _eventData_.winnerAddr,
722                 _eventData_.winnerName,
723                 _eventData_.amountWon,
724 
725                 _eventData_.newPot,
726                 _eventData_.genAmount
727             );
728         } else {
729             // get their earnings
730             _eth = withdrawEarnings(_pID);
731 
732             // withdraw eth
733             if(_eth > 0) {
734                 plyr_[_pID].addr.transfer(_eth);
735             }
736 
737             // fire withdraw event
738             emit DRSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
739         }
740     }
741 
742     function registerName(string _nameString, bool _all)
743         isHuman()
744         public
745         payable
746     {
747         bytes32 _name = _nameString.nameFilter();
748         address _addr = msg.sender;
749         uint256 _paid = msg.value;
750         (bool _isNewPlayer, ) = playerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, address(0), _all);
751 
752         uint256 _pID = pIDxAddr_[_addr];
753 
754         emit DRSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _paid, now);
755     }
756 
757     /**
758      * @dev return the price buyer will pay for next 1 individual key.
759      * -functionhash- 0x018a25e8
760      * @return price for next key bought (in wei format)
761      */
762     function getBuyPrice() public view returns(uint256)
763     {  
764         return keyPrice;
765     }
766 
767     /**
768      * @dev returns time left.  dont spam this, you'll ddos yourself from your node provider
769      * -functionhash- 0xc7e284b8
770      * @return time left in seconds
771      */
772     function getTimeLeft() public view returns(uint256)
773     {
774         uint256 _rID = rID_;
775 
776         uint256 _now = now;
777 
778         if(_now < round_[_rID].end)
779             if(_now > round_[_rID].strt + rndGap_)
780                 return (round_[_rID].end).sub(_now);
781             else
782                 return (round_[_rID].strt + rndGap_).sub(_now);
783         else
784             return 0;
785     }
786 
787     /**
788      * @dev returns player earnings per vaults 
789      * -functionhash- 0x63066434
790      * @return winnings vault
791      * @return general vault
792      */
793     function getPlayerVaults(uint256 _pID) public view returns(uint256, uint256)
794     {
795         uint256 _rID = rID_;
796 
797         uint256 _now = now;
798 
799         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
800         if(_now > round_[_rID].end && !round_[_rID].ended && round_[_rID].plyr != 0) {
801             // if player is winner 
802             if(round_[_rID].plyr == _pID) {
803                 return
804                 (
805                     (plyr_[_pID].win).add(getWin(round_[_rID].pot)),
806                     plyr_[_pID].gen
807                 );
808             }
809         }
810 
811         return (plyr_[_pID].win, plyr_[_pID].gen);
812     }
813 
814     /**
815      * @dev returns all current round info needed for front end
816      * -functionhash- 0x747dff42
817      * @return round id 
818      * @return total keys for round 
819      * @return time round ends
820      * @return time round started
821      * @return current pot
822 
823      * @return key price
824      * @return current key
825 
826      * @return current player ID in lead
827      * @return current player address in leads
828      * @return current player name in leads
829      */
830     function getCurrentRoundInfo() public view
831         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32)
832     {
833         uint256 _rID = rID_;
834 
835         uint256 _winPID = round_[_rID].plyr;
836 
837         return
838         (
839             _rID,                           //0
840             round_[_rID].end,               //1
841             round_[_rID].strt,              //2
842             round_[_rID].pot,               //3
843 
844             keyPrice,                       //4
845             keyBought.add(1),               //5
846 
847             _winPID,                        //6
848             plyr_[_winPID].addr,            //7
849             plyr_[_winPID].name             //8
850         );
851     }
852 
853     /**
854      * @dev returns player info based on address.  if no address is given, it will
855      * use msg.sender
856      * -functionhash- 0xee0b5d8b
857      * @param _addr address of the player you want to lookup
858      * @return player ID
859      * @return player name
860      * @return keys owned (current round)
861      * @return winnings vault
862      * @return general vault
863      * @return player round eth
864      */
865     function getPlayerInfoByAddress(address _addr) public view
866         returns(uint256, bytes32, uint256, uint256, uint256, uint256)
867     {
868         // setup local rID
869         uint256 _rID = rID_;
870         
871         if(_addr == address(0)) {
872             _addr == msg.sender;
873         }
874 
875         uint256 _pID = pIDxAddr_[_addr];
876 
877         if(_pID == 0) {
878             return (0, "", 0, 0, 0, 0);
879         }
880 
881         return
882         (
883             _pID,                               //0
884             plyr_[_pID].name,                   //1
885             plyrRnds_[_pID][_rID].keys,         //2
886             plyr_[_pID].win,                    //3
887             plyr_[_pID].gen,                    //4
888             plyrRnds_[_pID][_rID].eth           //5
889         );
890     }
891 
892     /**
893      * @dev logic runs whenever a buy order is executed.  determines how to handle 
894      * incoming eth depending on if we are in an active round or not
895      */
896     function buyCore(uint256 _pID, DRSDatasets.EventReturns memory _eventData_) private
897     {
898         uint256 _rID = rID_;
899 
900         // grab time
901         uint256 _now = now;
902 
903         // if round is active
904         if(_now >= round_[_rID].strt.add(rndGap_) && (_now <= round_[_rID].end || round_[_rID].plyr == 0)) {
905             // call core
906             core(_rID, _pID, msg.value, _eventData_);
907 
908         // if round is not active
909         } else {
910             // check to see if end round needs to be ran
911             if(_now > round_[_rID].end && !round_[_rID].ended) {
912                 // end the round (distributes pot) & start new round
913                 round_[_rID].ended = true;
914                 _eventData_ = endRound(_eventData_);
915 
916                 // build event data
917                 _eventData_ = _eventData_.setTimestamp(_now);
918                 _eventData_ = _eventData_.setPID(_pID);
919 
920                 // fire buy and distribute event
921                 emit DRSEvents.onBuyAndDistribute
922                 (
923                     msg.sender,
924                     plyr_[_pID].name,
925                     msg.value,
926                     _eventData_.compressedData,
927                     _eventData_.compressedIDs,
928 
929                     _eventData_.winnerAddr,
930                     _eventData_.winnerName,
931                     _eventData_.amountWon,
932 
933                     _eventData_.newPot,
934                     _eventData_.genAmount
935                 );
936             }
937 
938             // put eth in players vault 
939             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
940         }
941     }
942 
943     /**
944      * @dev logic runs whenever a reload order is executed.  determines how to handle
945      * incoming eth depending on if we are in an active round or not
946      */
947     function reLoadCore(uint256 _pID, uint256 _eth, DRSDatasets.EventReturns memory _eventData_) private
948     {
949         uint256 _rID = rID_;
950 
951         uint256 _now = now;
952 
953         // if round is active
954         if(_now > round_[_rID].strt.add(rndGap_) && (_now <= round_[_rID].end || round_[_rID].plyr == 0)) {
955             // get earnings from all vaults and return unused to gen vault
956             // because we use a custom safemath library.  this will throw if player
957             // tried to spend more eth than they have.
958             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
959 
960             // call core
961             core(_rID, _pID, _eth, _eventData_);
962 
963         // if round is not active and end round needs to be ran
964         } else {
965             // check to see if end round needs to be ran
966             if(_now > round_[_rID].end && !round_[_rID].ended) {
967                 // end the round (distributes pot) & start new round
968                 round_[_rID].ended = true;
969                 _eventData_ = endRound(_eventData_);
970 
971                 // build event data
972                 _eventData_ = _eventData_.setTimestamp(_now);
973                 _eventData_ = _eventData_.setPID(_pID);
974 
975                 // fire buy and distribute event
976                 emit DRSEvents.onReLoadAndDistribute
977                 (
978                     msg.sender,
979                     plyr_[_pID].name,
980                     _eventData_.compressedData,
981                     _eventData_.compressedIDs,
982 
983                     _eventData_.winnerAddr,
984                     _eventData_.winnerName,
985                     _eventData_.amountWon,
986 
987                     _eventData_.newPot,
988                     _eventData_.genAmount
989                 );
990             }
991         }
992     }
993 
994     /**
995      * @dev this is the core logic for any buy/reload that happens while a round is live.
996      */
997     function core(uint256 _rID, uint256 _pID, uint256 _eth, DRSDatasets.EventReturns memory _eventData_) private
998     {
999         if(_eth < keyPrice) {
1000             plyr_[_pID].gen = plyr_[_pID].gen.add(_eth);
1001             emit onBuyKeyFailure(_rID, _pID, _eth, keyPrice, now);
1002             return;
1003         }
1004 
1005         // if player is new to round
1006         if(plyrRnds_[_pID][_rID].keys == 0) {
1007             _eventData_ = managePlayer(_pID, _eventData_);
1008         }
1009 
1010         // mint the new key
1011         uint256 _keys = 1;
1012 
1013         uint256 _ethUsed = keyPrice;
1014         uint256 _ethLeft = _eth.sub(keyPrice);
1015 
1016         updateTimer(_rID);
1017 
1018         // set new leaders
1019         if(round_[_rID].plyr != _pID) {
1020             round_[_rID].plyr = _pID;
1021         }
1022 
1023         // set the new leader bool to true
1024         _eventData_ = _eventData_.setNewLeaderFlag();
1025 
1026         // update player 
1027         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1028         plyrRnds_[_pID][_rID].eth = _ethUsed.add(plyrRnds_[_pID][_rID].eth);
1029 
1030         // update round
1031         round_[_rID].keys = _keys.add(round_[_rID].keys);
1032         round_[_rID].eth = _ethUsed.add(round_[_rID].eth);
1033 
1034         // distribute eth
1035         uint256 _ethExt = distributeExternal(_ethUsed);
1036         _eventData_ = distributeInternal(_rID, _ethUsed, _ethExt, _eventData_);
1037 
1038         bytes32 _name = plyr_[_pID].name;
1039 
1040         pushBuyInfo(DRSDatasets.BuyInfo(msg.sender, _name, _pID, keyPrice, keyBought));
1041 
1042         // key index player bought
1043         uint256 _keyIndex = keyBought;
1044 
1045         keyBought = keyBought.add(1);
1046         keyPrice = keyPrice.mul(1000 + keyPriceIncreaseRatio).div(1000);
1047 
1048         if(_ethLeft > 0) {
1049             plyr_[_pID].gen = _ethLeft.add(plyr_[_pID].gen);
1050         }
1051 
1052         // call end tx function to fire end tx event.
1053         endTx(_pID, _ethUsed, _keyIndex, _eventData_);
1054     }
1055 
1056     /**
1057      * @dev receives name/player info from names contract 
1058      */
1059     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name) external
1060     {
1061         require(msg.sender == address(playerBook), "your not playerNames contract.");
1062 
1063         if(pIDxAddr_[_addr] != _pID)
1064             pIDxAddr_[_addr] = _pID;
1065 
1066         if(pIDxName_[_name] != _pID)
1067             pIDxName_[_name] = _pID;
1068 
1069         if(plyr_[_pID].addr != _addr)
1070             plyr_[_pID].addr = _addr;
1071 
1072         if(plyr_[_pID].name != _name)
1073             plyr_[_pID].name = _name;
1074 
1075         if(!plyrNames_[_pID][_name])
1076             plyrNames_[_pID][_name] = true;
1077     }
1078 
1079     /**
1080      * @dev receives entire player name list 
1081      */
1082     function receivePlayerNameList(uint256 _pID, bytes32 _name) external
1083     {
1084         require(msg.sender == address(playerBook), "your not playerNames contract.");
1085 
1086         if(!plyrNames_[_pID][_name])
1087             plyrNames_[_pID][_name] = true;
1088     }
1089 
1090     /**
1091      * @dev gets existing or registers new pID.  use this when a player may be new
1092      * @return pID 
1093      */
1094     function determinePID(DRSDatasets.EventReturns memory _eventData_) private returns(DRSDatasets.EventReturns)
1095     {
1096         uint256 _pID = pIDxAddr_[msg.sender];
1097 
1098         // if player is new to this version of ReserveBag
1099         if(_pID == 0)
1100         {
1101             // grab their player ID, name from player names contract
1102             _pID = playerBook.getPlayerID(msg.sender);
1103             bytes32 _name = playerBook.getPlayerName(_pID);
1104 
1105             // set up player account
1106             pIDxAddr_[msg.sender] = _pID;
1107             plyr_[_pID].addr = msg.sender;
1108 
1109             if(_name != "")
1110             {
1111                 pIDxName_[_name] = _pID;
1112                 plyr_[_pID].name = _name;
1113                 plyrNames_[_pID][_name] = true;
1114             }
1115 
1116             // set the new player bool to true
1117             _eventData_ = _eventData_.setNewPlayerFlag();
1118         }
1119 
1120         return _eventData_;
1121     }
1122 
1123     function managePlayer(uint256 _pID, DRSDatasets.EventReturns memory _eventData_)
1124         private
1125         returns(DRSDatasets.EventReturns)
1126     {
1127         // update player's last round played
1128         plyr_[_pID].lrnd = rID_;
1129 
1130         // set the joined round bool to true
1131         _eventData_ = _eventData_.setJoinedRoundFlag();
1132         
1133         return _eventData_;
1134     }
1135 
1136     function getWin(uint256 _pot) private pure returns(uint256) {
1137         return _pot / 2;
1138     }
1139 
1140     function getDRSCoinDividend(uint256 _pot) private view returns(uint256) {
1141         return _pot.mul(drsCoinDividendRatio).div(100);
1142     }
1143 
1144     function getTeamPerfit(uint256 _pot) private view returns(uint256) {
1145         return _pot.mul(teamPerfitRatio).div(100);
1146     }
1147 
1148     function mintDRSCoin() private {
1149         // empty buyinfos
1150         if(startIndex == endIndex) {
1151             return;
1152         }
1153 
1154         // have one element
1155         if((startIndex + 1) % (rewardInternal + 1) == endIndex) {
1156             return;
1157         }
1158 
1159         // have more than one element
1160         for(uint256 i = startIndex; (i + 1) % (rewardInternal + 1) != endIndex; i = (i + 1) % (rewardInternal + 1)) {
1161             drsCoin.mint(buyinfos[i].addr, buyinfos[i].keyPrice.mul(ethMintDRSCoinRate).div(100));
1162         }
1163     }
1164 
1165     /**
1166      * @dev ends the round. manages paying out winner/splitting up pot
1167      */
1168     function endRound(DRSDatasets.EventReturns memory _eventData_)
1169         private
1170         returns(DRSDatasets.EventReturns)
1171     {
1172         uint256 _rID = rID_;
1173 
1174         uint256 _winPID = round_[_rID].plyr;
1175 
1176         uint256 _pot = round_[_rID].pot;
1177 
1178         // eth for last player's prize
1179         uint256 _win = getWin(_pot);
1180 
1181         // eth for drsCoin dividend
1182         uint256 _drsCoinDividend = getDRSCoinDividend(_pot);
1183 
1184         // eth for team perfit
1185         uint256 _com = getTeamPerfit(_pot);
1186 
1187         // eth put to next round's pot
1188         uint256 _newPot = _pot.sub(_win).sub(_drsCoinDividend).sub(_com);
1189 
1190         // deposit team perfit
1191         depositTeamPerfit(_com);
1192 
1193         // pay our winner
1194         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1195 
1196         // mint DRSCoin
1197         mintDRSCoin();
1198 
1199         // distribute eth to drsCoin holders
1200         drsCoin.profitEth.value(_drsCoinDividend)();
1201 
1202         // prepare event data
1203         _eventData_ = _eventData_.setRoundEndTime(round_[_rID].end);
1204         _eventData_ = _eventData_.setWinPID(_winPID);
1205         _eventData_ = _eventData_.setWinner(plyr_[_winPID].addr, plyr_[_winPID].name, _win);
1206         _eventData_ = _eventData_.setNewPot(_newPot);
1207 
1208         // start next round
1209         rID_++;
1210         _rID++;
1211         round_[_rID].strt = now;
1212         round_[_rID].end = now.add(rndMax_).add(rndGap_);
1213 
1214         keyPrice = initKeyPrice;
1215         keyBought = 0;
1216 
1217         startIndex = 0;
1218         endIndex = 0;
1219 
1220         // add rest eth to next round's pot
1221         round_[_rID].pot = _newPot;
1222 
1223         return _eventData_;
1224     }
1225 
1226     /**
1227      * @dev updates round timer based on number of whole keys bought.
1228      */
1229     function updateTimer(uint256 _rID) private
1230     {
1231         round_[_rID].end = rndMax_.add(now);
1232     }
1233 
1234     function depositTeamPerfit(uint256 _eth) private {
1235         if(teamPerfit == address(0)) {
1236             teamPerfitAmuont = teamPerfitAmuont.add(_eth);
1237             return;
1238         }
1239 
1240         bool res = teamPerfit.deposit.value(_eth)();
1241         if(!res) {
1242             teamPerfitAmuont = teamPerfitAmuont.add(_eth);
1243             return;
1244         }
1245     }
1246 
1247     /**
1248      * @dev distributes eth based on fees to team
1249      */
1250     function distributeExternal(uint256 _eth) private returns(uint256)
1251     {
1252         // pay 2% out to community rewards
1253         uint256 _com = _eth / 50;
1254 
1255         depositTeamPerfit(_com);
1256 
1257         return _com;
1258     }
1259 
1260     /**
1261      * @dev distributes eth based on fees to gen and pot
1262      */
1263     function distributeInternal(uint256 _rID, uint256 _eth, uint256 _ethExt, DRSDatasets.EventReturns memory _eventData_)
1264         private
1265         returns(DRSDatasets.EventReturns)
1266     {
1267         uint256 _gen = 0;
1268         uint256 _pot = 0;
1269 
1270         if(keyBought < rewardInternal) {
1271             _gen = 0;
1272             _pot = _eth.sub(_ethExt);
1273         } else {
1274             _gen = _eth.mul(genRatio).div(100);
1275             _pot = _eth.sub(_ethExt).sub(_gen);
1276 
1277             DRSDatasets.BuyInfo memory info = buyinfos[startIndex];
1278 
1279             uint256 firstPID = info.pid;
1280             plyr_[firstPID].gen = _gen.add(plyr_[firstPID].gen);
1281 
1282             _eventData_.setGenInfo(info.addr, info.keyPrice);
1283         }
1284 
1285         if(_pot > 0) {
1286             round_[_rID].pot = _pot.add(round_[_rID].pot);
1287         }
1288 
1289         _eventData_.setGenAmount(_gen.add(_eventData_.genAmount));
1290         _eventData_.setPotAmount(_pot);
1291 
1292         return _eventData_;
1293     }
1294 
1295     /**
1296      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1297      * @return earnings in wei format
1298      */
1299     function withdrawEarnings(uint256 _pID) private returns(uint256)
1300     {
1301         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen);
1302         if(_earnings > 0)
1303         {
1304             plyr_[_pID].win = 0;
1305             plyr_[_pID].gen = 0;
1306         }
1307 
1308         return _earnings;
1309     }
1310 
1311     /**
1312      * @dev prepares compression data and fires event for buy or reload tx's
1313      */
1314     function endTx(uint256 _pID, uint256 _eth, uint256 _keyIndex, DRSDatasets.EventReturns memory _eventData_) private
1315     {
1316         _eventData_ = _eventData_.setTimestamp(now);
1317         _eventData_ = _eventData_.setPID(_pID);
1318         _eventData_ = _eventData_.setRID(rID_);
1319 
1320         emit DRSEvents.onEndTx
1321         (
1322             _eventData_.compressedData,
1323             _eventData_.compressedIDs,
1324 
1325             plyr_[_pID].name,
1326             msg.sender,
1327             _eth,
1328             _keyIndex,
1329 
1330             _eventData_.winnerAddr,
1331             _eventData_.winnerName,
1332             _eventData_.amountWon,
1333 
1334             _eventData_.newPot,
1335             _eventData_.genAmount,
1336             _eventData_.potAmount,
1337 
1338             _eventData_.genAddr,
1339             _eventData_.genKeyPrice
1340         );
1341     }
1342 
1343     modifier isActivated() {
1344         require(activated_, "its not activated yet.");
1345         _;
1346     }
1347 
1348     function activate() onlyOwner() public
1349     {
1350         // can only be ran once
1351         require(!activated_, "ReserveBag already activated");
1352 
1353         uint256 _now = now;
1354 
1355         // activate the contract 
1356         activated_ = true;
1357 
1358         // lets start first round
1359         rID_ = 1;
1360         round_[1].strt = _now.add(rndExtra_).sub(rndGap_);
1361         round_[1].end = _now.add(rndMax_).add(rndExtra_);
1362     }
1363 
1364     function getActivated() public view returns(bool) {
1365         return activated_;
1366     }
1367 
1368     function setTeamPerfitAddress(address _newTeamPerfitAddress) onlyOwner() public {
1369         teamPerfit = TeamPerfitForwarderInterface(_newTeamPerfitAddress);
1370     }
1371 
1372     function setPlayerBookAddress(address _newPlayerBookAddress) onlyOwner() public {
1373         playerBook = PlayerBookInterface(_newPlayerBookAddress);
1374     }
1375 
1376     function setDRSCoinAddress(address _newDRSCoinAddress) onlyOwner() public {
1377         drsCoin = DRSCoinInterface(_newDRSCoinAddress);
1378     }
1379 }