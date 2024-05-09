1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookInterface {
4     function getPlayerID(address _addr) external returns (uint256);
5     function getPlayerName(uint256 _pID) external view returns (bytes32);
6     function getPlayerLAff(uint256 _pID) external view returns (uint256);
7     function getPlayerAddr(uint256 _pID) external view returns (address);
8     function getNameFee() external view returns (uint256);
9     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
10     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
11     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
12 }
13 pragma solidity ^0.4.24;
14 
15 /**
16  * @title SafeMath v0.1.9
17  * @dev Math operations with safety checks that throw on error
18  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
19  * - added sqrt
20  * - added sq
21  * - added pwr
22  * - changed asserts to requires with error log outputs
23  * - removed div, its useless
24  */
25 library SafeMath {
26 
27     /**
28     * @dev Multiplies two numbers, throws on overflow.
29     */
30     function mul(uint256 a, uint256 b)
31     internal
32     pure
33     returns (uint256 c)
34     {
35         if (a == 0) {
36             return 0;
37         }
38         c = a * b;
39         require(c / a == b, "SafeMath mul failed");
40         return c;
41     }
42 
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b)
47     internal
48     pure
49     returns (uint256)
50     {
51         require(b <= a, "SafeMath sub failed");
52         return a - b;
53     }
54 
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b)
59     internal
60     pure
61     returns (uint256 c)
62     {
63         c = a + b;
64         require(c >= a, "SafeMath add failed");
65         return c;
66     }
67 
68     /**
69      * @dev gives square root of given x.
70      */
71     function sqrt(uint256 x)
72     internal
73     pure
74     returns (uint256 y)
75     {
76         uint256 z = ((add(x,1)) / 2);
77         y = x;
78         while (z < y)
79         {
80             y = z;
81             z = ((add((x / z),z)) / 2);
82         }
83     }
84 
85     /**
86      * @dev gives square. multiplies x by x
87      */
88     function sq(uint256 x)
89     internal
90     pure
91     returns (uint256)
92     {
93         return (mul(x,x));
94     }
95 
96     /**
97      * @dev x to the power of y
98      */
99     function pwr(uint256 x, uint256 y)
100     internal
101     pure
102     returns (uint256)
103     {
104         if (x==0)
105             return (0);
106         else if (y==0)
107             return (1);
108         else
109         {
110             uint256 z = x;
111             for (uint256 i=1; i < y; i++)
112                 z = mul(z,x);
113             return (z);
114         }
115     }
116 }
117 pragma solidity ^0.4.24;
118 
119 library NameFilter {
120 
121     /**
122      * @dev filters name strings
123      * -converts uppercase to lower case.
124      * -makes sure it does not start/end with a space
125      * -makes sure it does not contain multiple spaces in a row
126      * -cannot be only numbers
127      * -cannot start with 0x
128      * -restricts characters to A-Z, a-z, 0-9, and space.
129      * @return reprocessed string in bytes32 format
130      */
131     function nameFilter(string _input)
132     internal
133     pure
134     returns(bytes32)
135     {
136         bytes memory _temp = bytes(_input);
137         uint256 _length = _temp.length;
138 
139         //sorry limited to 32 characters
140         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
141         // make sure it doesnt start with or end with space
142         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
143         // make sure first two characters are not 0x
144         if (_temp[0] == 0x30)
145         {
146             require(_temp[1] != 0x78, "string cannot start with 0x");
147             require(_temp[1] != 0x58, "string cannot start with 0X");
148         }
149 
150         // create a bool to track if we have a non number character
151         bool _hasNonNumber;
152 
153         // convert & check
154         for (uint256 i = 0; i < _length; i++)
155         {
156             // if its uppercase A-Z
157             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
158             {
159                 // convert to lower case a-z
160                 _temp[i] = byte(uint(_temp[i]) + 32);
161 
162                 // we have a non number
163                 if (_hasNonNumber == false)
164                     _hasNonNumber = true;
165             } else {
166                 require
167                 (
168                 // require character is a space
169                     _temp[i] == 0x20 ||
170                 // OR lowercase a-z
171                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
172                 // or 0-9
173                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
174                     "string contains invalid characters"
175                 );
176                 // make sure theres not 2x spaces in a row
177                 if (_temp[i] == 0x20)
178                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
179 
180                 // see if we have a character other than a number
181                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
182                     _hasNonNumber = true;
183             }
184         }
185 
186         require(_hasNonNumber == true, "string cannot be only numbers");
187 
188         bytes32 _ret;
189         assembly {
190             _ret := mload(add(_temp, 32))
191         }
192         return (_ret);
193     }
194 }
195 pragma solidity ^0.4.24;
196 
197 
198 /**
199  * @title Ownable
200  * @dev The Ownable contract has an owner address, and provides basic authorization control
201  * functions, this simplifies the implementation of "user permissions".
202  */
203 contract Ownable {
204   address public owner;
205 
206 
207   event OwnershipRenounced(address indexed previousOwner);
208   event OwnershipTransferred(
209     address indexed previousOwner,
210     address indexed newOwner
211   );
212 
213 
214   /**
215    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
216    * account.
217    */
218   constructor() public {
219     owner = msg.sender;
220   }
221 
222   /**
223    * @dev Throws if called by any account other than the owner.
224    */
225   modifier onlyOwner() {
226     require(msg.sender == owner);
227     _;
228   }
229 
230   /**
231    * @dev Allows the current owner to relinquish control of the contract.
232    * @notice Renouncing to ownership will leave the contract without an owner.
233    * It will not be possible to call the functions with the `onlyOwner`
234    * modifier anymore.
235    */
236   function renounceOwnership() public onlyOwner {
237     emit OwnershipRenounced(owner);
238     owner = address(0);
239   }
240 
241   /**
242    * @dev Allows the current owner to transfer control of the contract to a newOwner.
243    * @param _newOwner The address to transfer ownership to.
244    */
245   function transferOwnership(address _newOwner) public onlyOwner {
246     _transferOwnership(_newOwner);
247   }
248 
249   /**
250    * @dev Transfers control of the contract to a newOwner.
251    * @param _newOwner The address to transfer ownership to.
252    */
253   function _transferOwnership(address _newOwner) internal {
254     require(_newOwner != address(0));
255     emit OwnershipTransferred(owner, _newOwner);
256     owner = _newOwner;
257   }
258 }
259 pragma solidity ^0.4.24;
260 
261 // "./PlayerBookInterface.sol";
262 // "./SafeMath.sol";
263 // "./NameFilter.sol";
264 // 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
265 
266 //==============================================================================
267 //     _    _  _ _|_ _  .
268 //    (/_\/(/_| | | _\  .
269 //==============================================================================
270 contract F3Devents {
271     /*
272     event debug (
273         uint16 code,
274         uint256 value,
275         bytes32 msg
276     );
277     */
278 
279     // fired whenever a player registers a name
280     event onNewName
281     (
282         uint256 indexed playerID,
283         address indexed playerAddress,
284         bytes32 indexed playerName,
285         bool isNewPlayer,
286         uint256 affiliateID,
287         address affiliateAddress,
288         bytes32 affiliateName,
289         uint256 amountPaid,
290         uint256 timeStamp
291     );
292 
293     // fired at end of buy or reload
294     event onEndTx
295     (
296         uint256 compressedData,
297         uint256 compressedIDs,
298         bytes32 playerName,
299         address playerAddress,
300         uint256 ethIn,
301         uint256 keysBought,
302         address winnerAddr,
303         bytes32 winnerName,
304         uint256 amountWon,
305         uint256 newPot,
306         uint256 mktAmount,
307 //        uint256 comAmount,
308         uint256 genAmount,
309         uint256 potAmount,
310         uint256 airDropPot
311     );
312 
313     // fired whenever theres a withdraw
314     event onWithdraw
315     (
316         uint256 indexed playerID,
317         address playerAddress,
318         bytes32 playerName,
319         uint256 ethOut,
320         uint256 timeStamp
321     );
322 
323     // fired whenever a withdraw forces end round to be ran
324     event onWithdrawAndDistribute
325     (
326         address playerAddress,
327         bytes32 playerName,
328         uint256 ethOut,
329         uint256 compressedData,
330         uint256 compressedIDs,
331         address winnerAddr,
332         bytes32 winnerName,
333         uint256 amountWon,
334         uint256 newPot,
335         uint256 mktAmount,
336         uint256 genAmount
337     );
338 
339     // (fomo3d long only) fired whenever a player tries a buy after round timer
340     // hit zero, and causes end round to be ran.
341     event onBuyAndDistribute
342     (
343         address playerAddress,
344         bytes32 playerName,
345         uint256 ethIn,
346         uint256 compressedData,
347         uint256 compressedIDs,
348         address winnerAddr,
349         bytes32 winnerName,
350         uint256 amountWon,
351         uint256 newPot,
352         uint256 mktAmount,
353         uint256 genAmount
354     );
355 
356     // (fomo3d long only) fired whenever a player tries a reload after round timer
357     // hit zero, and causes end round to be ran.
358     event onReLoadAndDistribute
359     (
360         address playerAddress,
361         bytes32 playerName,
362         uint256 compressedData,
363         uint256 compressedIDs,
364         address winnerAddr,
365         bytes32 winnerName,
366         uint256 amountWon,
367         uint256 newPot,
368         uint256 mktAmount,
369         uint256 genAmount
370     );
371 
372     // fired whenever an affiliate is paid
373     event onAffiliatePayout
374     (
375         uint256 indexed affiliateID,
376         address affiliateAddress,
377         bytes32 affiliateName,
378         uint256 indexed roundID,
379         uint256 indexed buyerID,
380         uint256 amount,
381         uint256 timeStamp
382     );
383 
384     // received pot swap deposit
385     event onPotSwapDeposit
386     (
387         uint256 roundID,
388         uint256 amountAddedToPot
389     );
390 }
391 
392 
393 contract modularLong is F3Devents {}
394 
395 contract FoMoJP is modularLong, Ownable {
396     using SafeMath for *;
397     using NameFilter for string;
398     using F3DKeysCalcLong for uint256;
399 
400 //    otherFoMo3D private otherF3D_;
401     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x24a0e6BD446CF4c76C5f456f7754055d75c45ecF);
402 
403     //==============================================================================
404     //     _ _  _  |`. _     _ _ |_ | _  _  .
405     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
406     //=================_|===========================================================
407     string constant public name = "BonBon Sama Great";
408     string constant public symbol = "BON";
409 //    uint256 private rndExtra_ = extSettings.getLongExtra();     // length of the very first ICO
410     uint256 constant private rndGap_ = 0; // 120 seconds;         // length of ICO phase.
411     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
412     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
413     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
414 
415     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
416     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
417     uint256 public rID_;    // round id number / total rounds that have happened
418     //****************
419     // PLAYER DATA
420     //****************
421     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
422     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
423     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
424     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
425     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
426     //****************
427     // ROUND DATA
428     //****************
429     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
430     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
431     //****************
432     // TEAM FEE DATA
433     //****************
434     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
435     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
436 
437     constructor()
438     public
439     {
440         // Team allocation structures
441         // 0 = whales
442         // 1 = bears
443         // 2 = sneks
444         // 3 = bulls
445 
446         // Team allocation percentages
447         // (F3D, P3D) + (Pot , Referrals, Community)
448         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
449         fees_[0] = F3Ddatasets.TeamFee(30, 6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
450         fees_[1] = F3Ddatasets.TeamFee(43, 0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
451         fees_[2] = F3Ddatasets.TeamFee(56, 10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
452         fees_[3] = F3Ddatasets.TeamFee(43, 8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
453 
454         // how to split up the final pot based on which team was picked
455         // (F3D, P3D)
456         potSplit_[0] = F3Ddatasets.PotSplit(15, 10);  //48% to winner, 25% to next round, 2% to com
457         potSplit_[1] = F3Ddatasets.PotSplit(25, 0);   //48% to winner, 25% to next round, 2% to com
458         potSplit_[2] = F3Ddatasets.PotSplit(20, 20);  //48% to winner, 10% to next round, 2% to com
459         potSplit_[3] = F3Ddatasets.PotSplit(30, 10);  //48% to winner, 10% to next round, 2% to com
460     }
461 
462     /**
463      * @dev used to make sure no one can interact with contract until it has
464      * been activated.
465      */
466     modifier isActivated() {
467         require(activated_ == true, "its not ready yet.  check ?eta in discord");
468         _;
469     }
470 
471     /**
472      * @dev prevents contracts from interacting with fomo3d
473      */
474     modifier isHuman() {
475         address _addr = msg.sender;
476         uint256 _codeLength;
477 
478         assembly {_codeLength := extcodesize(_addr)}
479         require(_codeLength == 0, "sorry humans only");
480         _;
481     }
482 
483     /**
484      * @dev sets boundaries for incoming tx
485      */
486     modifier isWithinLimits(uint256 _eth) {
487         require(_eth >= 1000000000, "pocket lint: not a valid currency");
488         require(_eth <= 100000000000000000000000, "no vitalik, no");
489         _;
490     }
491 
492     /**
493      * @dev emergency buy uses last stored affiliate ID and team snek
494      */
495     function()
496     isActivated()
497     isHuman()
498     isWithinLimits(msg.value)
499     public
500     payable
501     {
502         // set up our tx event data and determine if player is new or not
503         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
504 
505         // fetch player id
506         uint256 _pID = pIDxAddr_[msg.sender];
507 
508         // buy core
509         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
510     }
511 
512     /**
513      * @dev converts all incoming ethereum to keys.
514      * -functionhash- 0x8f38f309 (using ID for affiliate)
515      * -functionhash- 0x98a0871d (using address for affiliate)
516      * -functionhash- 0xa65b37a1 (using name for affiliate)
517      * @param _affCode the ID/address/name of the player who gets the affiliate fee
518      * @param _team what team is the player playing for?
519      */
520     function buyXid(uint256 _affCode, uint256 _team)
521     isActivated()
522     isHuman()
523     isWithinLimits(msg.value)
524     public
525     payable
526     {
527         // set up our tx event data and determine if player is new or not
528         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
529 
530         // fetch player id
531         uint256 _pID = pIDxAddr_[msg.sender];
532 
533         // manage affiliate residuals
534         // if no affiliate code was given or player tried to use their own, lolz
535         if (_affCode == 0 || _affCode == _pID)
536         {
537             // use last stored affiliate code
538             _affCode = plyr_[_pID].laff;
539 
540             // if affiliate code was given & its not the same as previously stored
541         } else if (_affCode != plyr_[_pID].laff) {
542             // update last affiliate
543             plyr_[_pID].laff = _affCode;
544         }
545 
546         // verify a valid team was selected
547         _team = verifyTeam(_team);
548 
549         // buy core
550         buyCore(_pID, _affCode, _team, _eventData_);
551     }
552 
553     function buyXaddr(address _affCode, uint256 _team)
554     isActivated()
555     isHuman()
556     isWithinLimits(msg.value)
557     public
558     payable
559     {
560         // set up our tx event data and determine if player is new or not
561         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
562 
563         // fetch player id
564         uint256 _pID = pIDxAddr_[msg.sender];
565 
566         // manage affiliate residuals
567         uint256 _affID;
568         // if no affiliate code was given or player tried to use their own, lolz
569         if (_affCode == address(0) || _affCode == msg.sender)
570         {
571             // use last stored affiliate code
572             _affID = plyr_[_pID].laff;
573 
574             // if affiliate code was given
575         } else {
576             // get affiliate ID from aff Code
577             _affID = pIDxAddr_[_affCode];
578 
579             // if affID is not the same as previously stored
580             if (_affID != plyr_[_pID].laff)
581             {
582                 // update last affiliate
583                 plyr_[_pID].laff = _affID;
584             }
585         }
586 
587         // verify a valid team was selected
588         _team = verifyTeam(_team);
589 
590         // buy core
591         buyCore(_pID, _affID, _team, _eventData_);
592     }
593 
594     function buyXname(bytes32 _affCode, uint256 _team)
595     isActivated()
596     isHuman()
597     isWithinLimits(msg.value)
598     public
599     payable
600     {
601         // set up our tx event data and determine if player is new or not
602         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
603 
604         // fetch player id
605         uint256 _pID = pIDxAddr_[msg.sender];
606 
607         // manage affiliate residuals
608         uint256 _affID;
609         // if no affiliate code was given or player tried to use their own, lolz
610         if (_affCode == '' || _affCode == plyr_[_pID].name)
611         {
612             // use last stored affiliate code
613             _affID = plyr_[_pID].laff;
614 
615             // if affiliate code was given
616         } else {
617             // get affiliate ID from aff Code
618             _affID = pIDxName_[_affCode];
619 
620             // if affID is not the same as previously stored
621             if (_affID != plyr_[_pID].laff)
622             {
623                 // update last affiliate
624                 plyr_[_pID].laff = _affID;
625             }
626         }
627 
628         // verify a valid team was selected
629         _team = verifyTeam(_team);
630 
631         // buy core
632         buyCore(_pID, _affID, _team, _eventData_);
633     }
634 
635     /**
636      * @dev essentially the same as buy, but instead of you sending ether
637      * from your wallet, it uses your unwithdrawn earnings.
638      * -functionhash- 0x349cdcac (using ID for affiliate)
639      * -functionhash- 0x82bfc739 (using address for affiliate)
640      * -functionhash- 0x079ce327 (using name for affiliate)
641      * @param _affCode the ID/address/name of the player who gets the affiliate fee
642      * @param _team what team is the player playing for?
643      * @param _eth amount of earnings to use (remainder returned to gen vault)
644      */
645     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
646     isActivated()
647     isHuman()
648     isWithinLimits(_eth)
649     public
650     {
651         // set up our tx event data
652         F3Ddatasets.EventReturns memory _eventData_;
653 
654         // fetch player ID
655         uint256 _pID = pIDxAddr_[msg.sender];
656 
657         // manage affiliate residuals
658         // if no affiliate code was given or player tried to use their own, lolz
659         if (_affCode == 0 || _affCode == _pID)
660         {
661             // use last stored affiliate code
662             _affCode = plyr_[_pID].laff;
663 
664             // if affiliate code was given & its not the same as previously stored
665         } else if (_affCode != plyr_[_pID].laff) {
666             // update last affiliate
667             plyr_[_pID].laff = _affCode;
668         }
669 
670         // verify a valid team was selected
671         _team = verifyTeam(_team);
672 
673         // reload core
674         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
675     }
676 
677     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
678     isActivated()
679     isHuman()
680     isWithinLimits(_eth)
681     public
682     {
683         // set up our tx event data
684         F3Ddatasets.EventReturns memory _eventData_;
685 
686         // fetch player ID
687         uint256 _pID = pIDxAddr_[msg.sender];
688 
689         // manage affiliate residuals
690         uint256 _affID;
691         // if no affiliate code was given or player tried to use their own, lolz
692         if (_affCode == address(0) || _affCode == msg.sender)
693         {
694             // use last stored affiliate code
695             _affID = plyr_[_pID].laff;
696 
697             // if affiliate code was given
698         } else {
699             // get affiliate ID from aff Code
700             _affID = pIDxAddr_[_affCode];
701 
702             // if affID is not the same as previously stored
703             if (_affID != plyr_[_pID].laff)
704             {
705                 // update last affiliate
706                 plyr_[_pID].laff = _affID;
707             }
708         }
709 
710         // verify a valid team was selected
711         _team = verifyTeam(_team);
712 
713         // reload core
714         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
715     }
716 
717     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
718     isActivated()
719     isHuman()
720     isWithinLimits(_eth)
721     public
722     {
723         // set up our tx event data
724         F3Ddatasets.EventReturns memory _eventData_;
725 
726         // fetch player ID
727         uint256 _pID = pIDxAddr_[msg.sender];
728 
729         // manage affiliate residuals
730         uint256 _affID;
731         // if no affiliate code was given or player tried to use their own, lolz
732         if (_affCode == '' || _affCode == plyr_[_pID].name)
733         {
734             // use last stored affiliate code
735             _affID = plyr_[_pID].laff;
736 
737             // if affiliate code was given
738         } else {
739             // get affiliate ID from aff Code
740             _affID = pIDxName_[_affCode];
741 
742             // if affID is not the same as previously stored
743             if (_affID != plyr_[_pID].laff)
744             {
745                 // update last affiliate
746                 plyr_[_pID].laff = _affID;
747             }
748         }
749 
750         // verify a valid team was selected
751         _team = verifyTeam(_team);
752 
753         // reload core
754         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
755     }
756 
757     /**
758      * @dev withdraws all of your earnings.
759      * -functionhash- 0x3ccfd60b
760      */
761     function withdraw()
762     isActivated()
763     isHuman()
764     public
765     {
766         // setup local rID
767         uint256 _rID = rID_;
768 
769         // grab time
770         uint256 _now = now;
771 
772         // fetch player ID
773         uint256 _pID = pIDxAddr_[msg.sender];
774 
775         // setup temp var for player eth
776         uint256 _eth;
777 
778         // check to see if round has ended and no one has run round end yet
779         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
780         {
781             // set up our tx event data
782             F3Ddatasets.EventReturns memory _eventData_;
783 
784             // end the round (distributes pot)
785             round_[_rID].ended = true;
786             _eventData_ = endRound(_eventData_);
787 
788             // get their earnings
789             _eth = withdrawEarnings(_pID);
790 
791             // gib moni
792             if (_eth > 0)
793                 plyr_[_pID].addr.transfer(_eth);
794 
795             // build event data
796             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
797             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
798 
799             // fire withdraw and distribute event
800             emit F3Devents.onWithdrawAndDistribute
801             (
802                 msg.sender,
803                 plyr_[_pID].name,
804                 _eth,
805                 _eventData_.compressedData,
806                 _eventData_.compressedIDs,
807                 _eventData_.winnerAddr,
808                 _eventData_.winnerName,
809                 _eventData_.amountWon,
810                 _eventData_.newPot,
811                 _eventData_.mktAmount,
812                 _eventData_.genAmount
813             );
814 
815             // in any other situation
816         } else {
817             // get their earnings
818             _eth = withdrawEarnings(_pID);
819 
820             // gib moni
821             if (_eth > 0)
822                 plyr_[_pID].addr.transfer(_eth);
823 
824             // fire withdraw event
825             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
826         }
827     }
828 
829     /**
830      * @dev use these to register names.  they are just wrappers that will send the
831      * registration requests to the PlayerBook contract.  So registering here is the
832      * same as registering there.  UI will always display the last name you registered.
833      * but you will still own all previously registered names to use as affiliate
834      * links.
835      * - must pay a registration fee.
836      * - name must be unique
837      * - names will be converted to lowercase
838      * - name cannot start or end with a space
839      * - cannot have more than 1 space in a row
840      * - cannot be only numbers
841      * - cannot start with 0x
842      * - name must be at least 1 char
843      * - max length of 32 characters long
844      * - allowed characters: a-z, 0-9, and space
845      * -functionhash- 0x921dec21 (using ID for affiliate)
846      * -functionhash- 0x3ddd4698 (using address for affiliate)
847      * -functionhash- 0x685ffd83 (using name for affiliate)
848      * @param _nameString players desired name
849      * @param _affCode affiliate ID, address, or name of who referred you
850      * @param _all set to true if you want this to push your info to all games
851      * (this might cost a lot of gas)
852      */
853     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
854     isHuman()
855     public
856     payable
857     {
858         bytes32 _name = _nameString.nameFilter();
859         address _addr = msg.sender;
860         uint256 _paid = msg.value;
861         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
862 
863         uint256 _pID = pIDxAddr_[_addr];
864 
865         // fire event
866         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
867     }
868 
869     function registerNameXaddr(string _nameString, address _affCode, bool _all)
870     isHuman()
871     public
872     payable
873     {
874         bytes32 _name = _nameString.nameFilter();
875         address _addr = msg.sender;
876         uint256 _paid = msg.value;
877         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
878 
879         uint256 _pID = pIDxAddr_[_addr];
880 
881         // fire event
882         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
883     }
884 
885     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
886     isHuman()
887     public
888     payable
889     {
890         bytes32 _name = _nameString.nameFilter();
891         address _addr = msg.sender;
892         uint256 _paid = msg.value;
893         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
894 
895         uint256 _pID = pIDxAddr_[_addr];
896 
897         // fire event
898         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
899     }
900     /**
901      * @dev return the price buyer will pay for next 1 individual key.
902      * -functionhash- 0x018a25e8
903      * @return price for next key bought (in wei format)
904      */
905     function getBuyPrice()
906     public
907     view
908     returns(uint256)
909     {
910         // setup local rID
911         uint256 _rID = rID_;
912 
913         // grab time
914         uint256 _now = now;
915 
916         // are we in a round?
917         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
918             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
919         else // rounds over.  need price for new round
920             return ( 75000000000000 ); // init
921     }
922 
923     /**
924      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
925      * provider
926      * -functionhash- 0xc7e284b8
927      * @return time left in seconds
928      */
929     function getTimeLeft()
930     public
931     view
932     returns(uint256)
933     {
934         // setup local rID
935         uint256 _rID = rID_;
936 
937         // grab time
938         uint256 _now = now;
939 
940         if (_now < round_[_rID].end)
941             if (_now > round_[_rID].strt + rndGap_)
942                 return( (round_[_rID].end).sub(_now) );
943             else
944                 return( (round_[_rID].strt + rndGap_).sub(_now) );
945         else
946             return(0);
947     }
948 
949     /**
950      * @dev returns player earnings per vaults
951      * -functionhash- 0x63066434
952      * @return winnings vault
953      * @return general vault
954      * @return affiliate vault
955      */
956     function getPlayerVaults(uint256 _pID)
957     public
958     view
959     returns(uint256 ,uint256, uint256)
960     {
961         // setup local rID
962         uint256 _rID = rID_;
963 
964         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
965         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
966         {
967             // if player is winner
968             if (round_[_rID].plyr == _pID)
969             {
970                 return
971                 (
972                 (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
973                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
974                 plyr_[_pID].aff
975                 );
976                 // if player is not the winner
977             } else {
978                 return
979                 (
980                 plyr_[_pID].win,
981                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
982                 plyr_[_pID].aff
983                 );
984             }
985 
986             // if round is still going on, or round has ended and round end has been ran
987         } else {
988             return
989             (
990             plyr_[_pID].win,
991             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
992             plyr_[_pID].aff
993             );
994         }
995     }
996 
997     /**
998      * solidity hates stack limits.  this lets us avoid that hate
999      */
1000     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1001     private
1002     view
1003     returns(uint256)
1004     {
1005         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1006     }
1007 
1008     /**
1009      * @dev returns all current round info needed for front end
1010      * -functionhash- 0x747dff42
1011      * @return eth invested during ICO phase
1012      * @return round id
1013      * @return total keys for round
1014      * @return time round ends
1015      * @return time round started
1016      * @return current pot
1017      * @return current team ID & player ID in lead
1018      * @return current player in leads address
1019      * @return current player in leads name
1020      * @return whales eth in for round
1021      * @return bears eth in for round
1022      * @return sneks eth in for round
1023      * @return bulls eth in for round
1024      * @return airdrop tracker # & airdrop pot
1025      */
1026     function getCurrentRoundInfo()
1027     public
1028     view
1029     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1030     {
1031         // setup local rID
1032         uint256 _rID = rID_;
1033 
1034         return
1035         (
1036         round_[_rID].ico,               //0
1037         _rID,                           //1
1038         round_[_rID].keys,              //2
1039         round_[_rID].end,               //3
1040         round_[_rID].strt,              //4
1041         round_[_rID].pot,               //5
1042         (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1043         plyr_[round_[_rID].plyr].addr,  //7
1044         plyr_[round_[_rID].plyr].name,  //8
1045         rndTmEth_[_rID][0],             //9
1046         rndTmEth_[_rID][1],             //10
1047         rndTmEth_[_rID][2],             //11
1048         rndTmEth_[_rID][3],             //12
1049         airDropTracker_ + (airDropPot_ * 1000)              //13
1050         );
1051     }
1052 
1053     /**
1054      * @dev returns player info based on address.  if no address is given, it will
1055      * use msg.sender
1056      * -functionhash- 0xee0b5d8b
1057      * @param _addr address of the player you want to lookup
1058      * @return player ID
1059      * @return player name
1060      * @return keys owned (current round)
1061      * @return winnings vault
1062      * @return general vault
1063      * @return affiliate vault
1064 	 * @return player round eth
1065      */
1066     function getPlayerInfoByAddress(address _addr)
1067     public
1068     view
1069     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1070     {
1071         // setup local rID
1072         uint256 _rID = rID_;
1073 
1074         if (_addr == address(0))
1075         {
1076             _addr == msg.sender;
1077         }
1078         uint256 _pID = pIDxAddr_[_addr];
1079 
1080         return
1081         (
1082         _pID,                               //0
1083         plyr_[_pID].name,                   //1
1084         plyrRnds_[_pID][_rID].keys,         //2
1085         plyr_[_pID].win,                    //3
1086         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1087         plyr_[_pID].aff,                    //5
1088         plyrRnds_[_pID][_rID].eth           //6
1089         );
1090     }
1091 
1092     /**
1093      * @dev logic runs whenever a buy order is executed.  determines how to handle
1094      * incoming eth depending on if we are in an active round or not
1095      */
1096     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1097     private
1098     {
1099         // setup local rID
1100         uint256 _rID = rID_;
1101 
1102         // grab time
1103         uint256 _now = now;
1104 
1105         // if round is active
1106         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1107         {
1108             // call core
1109             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1110 
1111             // if round is not active
1112         } else {
1113             // check to see if end round needs to be ran
1114             if (_now > round_[_rID].end && round_[_rID].ended == false)
1115             {
1116                 // end the round (distributes pot) & start new round
1117                 round_[_rID].ended = true;
1118                 _eventData_ = endRound(_eventData_);
1119 
1120                 // build event data
1121                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1122                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1123 
1124                 // fire buy and distribute event
1125                 emit F3Devents.onBuyAndDistribute
1126                 (
1127                     msg.sender,
1128                     plyr_[_pID].name,
1129                     msg.value,
1130                     _eventData_.compressedData,
1131                     _eventData_.compressedIDs,
1132                     _eventData_.winnerAddr,
1133                     _eventData_.winnerName,
1134                     _eventData_.amountWon,
1135                     _eventData_.newPot,
1136                     _eventData_.mktAmount,
1137                     _eventData_.genAmount
1138                 );
1139             }
1140 
1141             // put eth in players vault
1142             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1143         }
1144     }
1145 
1146     /**
1147      * @dev logic runs whenever a reload order is executed.  determines how to handle
1148      * incoming eth depending on if we are in an active round or not
1149      */
1150     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1151     private
1152     {
1153         // setup local rID
1154         uint256 _rID = rID_;
1155 
1156         // grab time
1157         uint256 _now = now;
1158 
1159         // if round is active
1160         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1161         {
1162             // get earnings from all vaults and return unused to gen vault
1163             // because we use a custom safemath library.  this will throw if player
1164             // tried to spend more eth than they have.
1165             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1166 
1167             // call core
1168             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1169 
1170             // if round is not active and end round needs to be ran
1171         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1172             // end the round (distributes pot) & start new round
1173             round_[_rID].ended = true;
1174             _eventData_ = endRound(_eventData_);
1175 
1176             // build event data
1177             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1178             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1179 
1180             // fire buy and distribute event
1181             emit F3Devents.onReLoadAndDistribute
1182             (
1183                 msg.sender,
1184                 plyr_[_pID].name,
1185                 _eventData_.compressedData,
1186                 _eventData_.compressedIDs,
1187                 _eventData_.winnerAddr,
1188                 _eventData_.winnerName,
1189                 _eventData_.amountWon,
1190                 _eventData_.newPot,
1191                 _eventData_.mktAmount,
1192                 _eventData_.genAmount
1193             );
1194         }
1195     }
1196 
1197     /**
1198      * @dev this is the core logic for any buy/reload that happens while a round
1199      * is live.
1200      */
1201     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1202     private
1203     {
1204         // if player is new to round
1205         if (plyrRnds_[_pID][_rID].keys == 0)
1206             _eventData_ = managePlayer(_pID, _eventData_);
1207 
1208         // early round eth limiter
1209         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1210         {
1211             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1212             uint256 _refund = _eth.sub(_availableLimit);
1213             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1214             _eth = _availableLimit;
1215         }
1216 
1217         // if eth left is greater than min eth allowed (sorry no pocket lint)
1218         if (_eth > 1000000000)
1219         {
1220             // mint the new keys
1221             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1222 
1223             // if they bought at least 1 whole key
1224             if (_keys >= 1000000000000000000)
1225             {
1226                 updateTimer(_keys, _rID);
1227 
1228                 // set new leaders
1229                 if (round_[_rID].plyr != _pID)
1230                     round_[_rID].plyr = _pID;
1231                 if (round_[_rID].team != _team)
1232                     round_[_rID].team = _team;
1233 
1234                 // set the new leader bool to true
1235                 _eventData_.compressedData = _eventData_.compressedData + 100;
1236             }
1237 
1238             // manage airdrops
1239             if (_eth >= 100000000000000000)
1240             {
1241                 airDropTracker_++;
1242                 if (airdrop() == true)
1243                 {
1244                     // gib muni
1245                     uint256 _prize;
1246                     if (_eth >= 10000000000000000000)
1247                     {
1248                         // calculate prize and give it to winner
1249                         _prize = ((airDropPot_).mul(75)) / 100;
1250                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1251 
1252                         // adjust airDropPot
1253                         airDropPot_ = (airDropPot_).sub(_prize);
1254 
1255                         // let event know a tier 3 prize was won
1256                         _eventData_.compressedData += 300000000000000000000000000000000;
1257                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1258                         // calculate prize and give it to winner
1259                         _prize = ((airDropPot_).mul(50)) / 100;
1260                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1261 
1262                         // adjust airDropPot
1263                         airDropPot_ = (airDropPot_).sub(_prize);
1264 
1265                         // let event know a tier 2 prize was won
1266                         _eventData_.compressedData += 200000000000000000000000000000000;
1267                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1268                         // calculate prize and give it to winner
1269                         _prize = ((airDropPot_).mul(25)) / 100;
1270                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1271 
1272                         // adjust airDropPot
1273                         airDropPot_ = (airDropPot_).sub(_prize);
1274 
1275                         // let event know a tier 3 prize was won
1276                         _eventData_.compressedData += 300000000000000000000000000000000;
1277                     }
1278                     // set airdrop happened bool to true
1279                     _eventData_.compressedData += 10000000000000000000000000000000;
1280                     // let event know how much was won
1281                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1282 
1283                     // reset air drop tracker
1284                     airDropTracker_ = 0;
1285                 }
1286             }
1287 
1288             // store the air drop tracker number (number of buys since last airdrop)
1289             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1290 
1291             // update player
1292             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1293             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1294 
1295             // update round
1296             round_[_rID].keys = _keys.add(round_[_rID].keys);
1297             round_[_rID].eth = _eth.add(round_[_rID].eth);
1298             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1299 
1300             // distribute eth
1301             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1302             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1303 
1304             // call end tx function to fire end tx event.
1305             endTx(_pID, _team, _eth, _keys, _eventData_);
1306         }
1307     }
1308     /**
1309      * @dev calculates unmasked earnings (just calculates, does not update mask)
1310      * @return earnings in wei format
1311      */
1312     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1313     private
1314     view
1315     returns(uint256)
1316     {
1317         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1318     }
1319 
1320     /**
1321      * @dev returns the amount of keys you would get given an amount of eth.
1322      * -functionhash- 0xce89c80c
1323      * @param _rID round ID you want price for
1324      * @param _eth amount of eth sent in
1325      * @return keys received
1326      */
1327     function calcKeysReceived(uint256 _rID, uint256 _eth)
1328     public
1329     view
1330     returns(uint256)
1331     {
1332         // grab time
1333         uint256 _now = now;
1334 
1335         // are we in a round?
1336         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1337             return ( (round_[_rID].eth).keysRec(_eth) );
1338         else // rounds over.  need keys for new round
1339             return ( (_eth).keys() );
1340     }
1341 
1342     /**
1343      * @dev returns current eth price for X keys.
1344      * -functionhash- 0xcf808000
1345      * @param _keys number of keys desired (in 18 decimal format)
1346      * @return amount of eth needed to send
1347      */
1348     function iWantXKeys(uint256 _keys)
1349     public
1350     view
1351     returns(uint256)
1352     {
1353         // setup local rID
1354         uint256 _rID = rID_;
1355 
1356         // grab time
1357         uint256 _now = now;
1358 
1359         // are we in a round?
1360         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1361             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1362         else // rounds over.  need price for new round
1363             return ( (_keys).eth() );
1364     }
1365     //==============================================================================
1366     //    _|_ _  _ | _  .
1367     //     | (_)(_)|_\  .
1368     //==============================================================================
1369     /**
1370 	 * @dev receives name/player info from names contract
1371      */
1372     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1373     external
1374     {
1375         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1376         if (pIDxAddr_[_addr] != _pID)
1377             pIDxAddr_[_addr] = _pID;
1378         if (pIDxName_[_name] != _pID)
1379             pIDxName_[_name] = _pID;
1380         if (plyr_[_pID].addr != _addr)
1381             plyr_[_pID].addr = _addr;
1382         if (plyr_[_pID].name != _name)
1383             plyr_[_pID].name = _name;
1384         if (plyr_[_pID].laff != _laff)
1385             plyr_[_pID].laff = _laff;
1386         if (plyrNames_[_pID][_name] == false)
1387             plyrNames_[_pID][_name] = true;
1388     }
1389 
1390     /**
1391      * @dev receives entire player name list
1392      */
1393     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1394     external
1395     {
1396         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1397         if(plyrNames_[_pID][_name] == false)
1398             plyrNames_[_pID][_name] = true;
1399     }
1400 
1401     /**
1402      * @dev gets existing or registers new pID.  use this when a player may be new
1403      * @return pID
1404      */
1405     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1406     private
1407     returns (F3Ddatasets.EventReturns)
1408     {
1409         uint256 _pID = pIDxAddr_[msg.sender];
1410         // if player is new to this version of fomo3d
1411         if (_pID == 0)
1412         {
1413             // grab their player ID, name and last aff ID, from player names contract
1414             _pID = PlayerBook.getPlayerID(msg.sender);
1415             bytes32 _name = PlayerBook.getPlayerName(_pID);
1416             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1417 
1418             // set up player account
1419             pIDxAddr_[msg.sender] = _pID;
1420             plyr_[_pID].addr = msg.sender;
1421 
1422             if (_name != "")
1423             {
1424                 pIDxName_[_name] = _pID;
1425                 plyr_[_pID].name = _name;
1426                 plyrNames_[_pID][_name] = true;
1427             }
1428 
1429             if (_laff != 0 && _laff != _pID)
1430                 plyr_[_pID].laff = _laff;
1431 
1432             // set the new player bool to true
1433             _eventData_.compressedData = _eventData_.compressedData + 1;
1434         }
1435         return (_eventData_);
1436     }
1437 
1438     /**
1439      * @dev checks to make sure user picked a valid team.  if not sets team
1440      * to default (sneks)
1441      */
1442     function verifyTeam(uint256 _team)
1443     private
1444     pure
1445     returns (uint256)
1446     {
1447         if (_team < 0 || _team > 3)
1448             return(2);
1449         else
1450             return(_team);
1451     }
1452 
1453     /**
1454      * @dev decides if round end needs to be run & new round started.  and if
1455      * player unmasked earnings from previously played rounds need to be moved.
1456      */
1457     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1458     private
1459     returns (F3Ddatasets.EventReturns)
1460     {
1461         // if player has played a previous round, move their unmasked earnings
1462         // from that round to gen vault.
1463         if (plyr_[_pID].lrnd != 0)
1464             updateGenVault(_pID, plyr_[_pID].lrnd);
1465 
1466         // update player's last round played
1467         plyr_[_pID].lrnd = rID_;
1468 
1469         // set the joined round bool to true
1470         _eventData_.compressedData = _eventData_.compressedData + 10;
1471 
1472         return(_eventData_);
1473     }
1474 
1475     /**
1476      * @dev ends the round. manages paying out winner/splitting up pot
1477      */
1478     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1479     private
1480     returns (F3Ddatasets.EventReturns)
1481     {
1482         // setup local rID
1483         uint256 _rID = rID_;
1484 
1485         // grab our winning player and team id's
1486         uint256 _winPID = round_[_rID].plyr;
1487         uint256 _winTID = round_[_rID].team;
1488 
1489         // grab our pot amount
1490         uint256 _pot = round_[_rID].pot;
1491 
1492         // calculate our winner share, community rewards, gen share,
1493         // p3d share, and amount reserved for next pot
1494         uint256 _win = (_pot.mul(48)) / 100;
1495         uint256 _com = (_pot / 50);
1496         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1497         uint256 _mkt = (_pot.mul(potSplit_[_winTID].marketing)) / 100;
1498         uint256 _res = ((_pot.sub(_win)).sub(_com)).sub(_gen).sub(_mkt);
1499 
1500         // calculate ppt for round mask
1501         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1502         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1503         if (_dust > 0)
1504         {
1505             _gen = _gen.sub(_dust);
1506             _res = _res.add(_dust);
1507         }
1508 
1509         // pay our winner
1510         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1511 
1512         // community rewards
1513         _com = _com.add(_mkt);
1514         if (!owner.send(_com)) {
1515             _com = 0;
1516             _res = _res.add(_com);
1517         }
1518 
1519         // distribute gen portion to key holders
1520         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1521 
1522         // prepare event data
1523         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1524         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1525         _eventData_.winnerAddr = plyr_[_winPID].addr;
1526         _eventData_.winnerName = plyr_[_winPID].name;
1527         _eventData_.amountWon = _win;
1528         _eventData_.genAmount = _gen;
1529         _eventData_.mktAmount = _mkt;
1530 //        _eventData_.comAmount = _com;
1531         _eventData_.newPot = _res;
1532 
1533         // start next round
1534         rID_++;
1535         _rID++;
1536         round_[_rID].strt = now;
1537         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1538         round_[_rID].pot = _res;
1539 
1540         return(_eventData_);
1541     }
1542 
1543     /**
1544      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1545      */
1546     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1547     private
1548     {
1549         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1550         if (_earnings > 0)
1551         {
1552             // put in gen vault
1553             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1554             // zero out their earnings by updating mask
1555             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1556         }
1557     }
1558 
1559     /**
1560      * @dev updates round timer based on number of whole keys bought.
1561      */
1562     function updateTimer(uint256 _keys, uint256 _rID)
1563     private
1564     {
1565         // grab time
1566         uint256 _now = now;
1567 
1568         // calculate time based on number of keys bought
1569         uint256 _newTime;
1570         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1571             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1572         else
1573             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1574 
1575         // compare to max and set new end time
1576         if (_newTime < (rndMax_).add(_now))
1577             round_[_rID].end = _newTime;
1578         else
1579             round_[_rID].end = rndMax_.add(_now);
1580     }
1581 
1582     /**
1583      * @dev generates a random number between 0-99 and checks to see if thats
1584      * resulted in an airdrop win
1585      * @return do we have a winner?
1586      */
1587     function airdrop()
1588     private
1589     view
1590     returns(bool)
1591     {
1592         uint256 seed = uint256(keccak256(abi.encodePacked((block.timestamp).add(block.difficulty).add((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add(block.gaslimit).add((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add(block.number))));
1593         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1594             return(true);
1595         else
1596             return(false);
1597     }
1598 
1599     /**
1600      * @dev distributes eth based on fees to com, aff, and p3d
1601      */
1602     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1603     private
1604     returns(F3Ddatasets.EventReturns)
1605     {
1606         // pay 2% out to community rewards
1607         uint256 _com = _eth / 50;
1608 
1609         // distribute share to affiliate
1610         uint256 _aff = _eth / 10;
1611 
1612         // decide what to do with affiliate share of fees
1613         // affiliate must not be self, and must have a name registered
1614         if (_affID != _pID && plyr_[_affID].name != '') {
1615             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1616             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1617         } else {
1618             _com = _com.add(_aff);
1619         }
1620 
1621         uint256 _mkt = _eth.mul(fees_[_team].marketing) / 100;
1622         _com = _com.add(_mkt);
1623         owner.transfer(_com);
1624 
1625         _eventData_.mktAmount = _mkt;
1626 //        _eventData_.comAmount = _com;
1627         return(_eventData_);
1628     }
1629 
1630     function potSwap()
1631     external
1632     payable
1633     {
1634         // setup local rID
1635         uint256 _rID = rID_ + 1;
1636 
1637         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1638         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1639     }
1640 
1641     /**
1642      * @dev distributes eth based on fees to gen and pot
1643      */
1644     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1645     private
1646     returns(F3Ddatasets.EventReturns)
1647     {
1648         // calculate gen share
1649         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1650 
1651         // toss 1% into airdrop pot
1652         uint256 _air = (_eth / 100);
1653         airDropPot_ = airDropPot_.add(_air);
1654 
1655         uint256 cut = (fees_[_team].marketing).add(13);
1656         _eth = _eth.sub(_eth.mul(cut) / 100);
1657 
1658         // calculate pot
1659         uint256 _pot = _eth.sub(_gen);
1660 
1661         // distribute gen share (thats what updateMasks() does) and adjust
1662         // balances for dust.
1663         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1664         if (_dust > 0) {
1665             _gen = _gen.sub(_dust);
1666         }
1667 
1668         // add eth to pot
1669         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1670 
1671         // set up event data
1672         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1673         _eventData_.potAmount = _pot;
1674 
1675         return(_eventData_);
1676     }
1677 
1678     /**
1679      * @dev updates masks for round and player when keys are bought
1680      * @return dust left over
1681      */
1682     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1683     private
1684     returns(uint256)
1685     {
1686         /* MASKING NOTES
1687             earnings masks are a tricky thing for people to wrap their minds around.
1688             the basic thing to understand here.  is were going to have a global
1689             tracker based on profit per share for each round, that increases in
1690             relevant proportion to the increase in share supply.
1691 
1692             the player will have an additional mask that basically says "based
1693             on the rounds mask, my shares, and how much i've already withdrawn,
1694             how much is still owed to me?"
1695         */
1696 
1697         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1698         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1699         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1700 
1701         // calculate player earning from their own buy (only based on the keys
1702         // they just bought).  & update player earnings mask
1703         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1704         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1705 
1706         // calculate & return dust
1707         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1708     }
1709 
1710     /**
1711      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1712      * @return earnings in wei format
1713      */
1714     function withdrawEarnings(uint256 _pID)
1715     private
1716     returns(uint256)
1717     {
1718         // update gen vault
1719         updateGenVault(_pID, plyr_[_pID].lrnd);
1720 
1721         // from vaults
1722         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1723         if (_earnings > 0)
1724         {
1725             plyr_[_pID].win = 0;
1726             plyr_[_pID].gen = 0;
1727             plyr_[_pID].aff = 0;
1728         }
1729 
1730         return(_earnings);
1731     }
1732 
1733     /**
1734      * @dev prepares compression data and fires event for buy or reload tx's
1735      */
1736     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1737     private
1738     {
1739         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1740         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1741 
1742         emit F3Devents.onEndTx
1743         (
1744             _eventData_.compressedData,
1745             _eventData_.compressedIDs,
1746             plyr_[_pID].name,
1747             msg.sender,
1748             _eth,
1749             _keys,
1750             _eventData_.winnerAddr,
1751             _eventData_.winnerName,
1752             _eventData_.amountWon,
1753             _eventData_.newPot,
1754             _eventData_.mktAmount,
1755 //            _eventData_.comAmount,
1756             _eventData_.genAmount,
1757             _eventData_.potAmount,
1758             airDropPot_
1759         );
1760     }
1761     //==============================================================================
1762     //    (~ _  _    _._|_    .
1763     //    _)(/_(_|_|| | | \/  .
1764     //====================/=========================================================
1765     /** upon contract deploy, it will be deactivated.  this is a one time
1766      * use function that will activate the contract.  we do this so devs
1767      * have time to set things up on the web end                            **/
1768     bool public activated_ = false;
1769     function activate()
1770     public onlyOwner {
1771         // make sure that its been linked.
1772 //        require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1773 
1774         // can only be ran once
1775         require(activated_ == false, "fomo3d already activated");
1776 
1777         // activate the contract
1778         activated_ = true;
1779 
1780         // lets start first round
1781         rID_ = 1;
1782         round_[1].strt = now;
1783         round_[1].end = now + rndInit_;
1784     }
1785 }
1786 
1787 library F3Ddatasets {
1788     //compressedData key
1789     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1790     // 0 - new player (bool)
1791     // 1 - joined round (bool)
1792     // 2 - new  leader (bool)
1793     // 3-5 - air drop tracker (uint 0-999)
1794     // 6-16 - round end time
1795     // 17 - winnerTeam
1796     // 18 - 28 timestamp
1797     // 29 - team
1798     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1799     // 31 - airdrop happened bool
1800     // 32 - airdrop tier
1801     // 33 - airdrop amount won
1802     //compressedIDs key
1803     // [77-52][51-26][25-0]
1804     // 0-25 - pID
1805     // 26-51 - winPID
1806     // 52-77 - rID
1807     struct EventReturns {
1808         uint256 compressedData;
1809         uint256 compressedIDs;
1810         address winnerAddr;         // winner address
1811         bytes32 winnerName;         // winner name
1812         uint256 amountWon;          // amount won
1813         uint256 newPot;             // amount in new pot
1814         uint256 mktAmount;          // amount distributed for marketing
1815 //        uint256 comAmount;
1816         uint256 genAmount;          // amount distributed to gen
1817         uint256 potAmount;          // amount added to pot
1818     }
1819     struct Player {
1820         address addr;   // player address
1821         bytes32 name;   // player name
1822         uint256 win;    // winnings vault
1823         uint256 gen;    // general vault
1824         uint256 aff;    // affiliate vault
1825         uint256 lrnd;   // last round played
1826         uint256 laff;   // last affiliate id used
1827     }
1828     struct PlayerRounds {
1829         uint256 eth;    // eth player has added to round (used for eth limiter)
1830         uint256 keys;   // keys
1831         uint256 mask;   // player mask
1832         uint256 ico;    // ICO phase investment
1833     }
1834     struct Round {
1835         uint256 plyr;   // pID of player in lead
1836         uint256 team;   // tID of team in lead
1837         uint256 end;    // time ends/ended
1838         bool ended;     // has round end function been ran
1839         uint256 strt;   // time round started
1840         uint256 keys;   // keys
1841         uint256 eth;    // total eth in
1842         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1843         uint256 mask;   // global mask
1844         uint256 ico;    // total eth sent in during ICO phase
1845         uint256 icoGen; // total eth for gen during ICO phase
1846         uint256 icoAvg; // average key price for ICO phase
1847     }
1848     struct TeamFee {
1849         uint256 gen;          // % of buy in thats paid to key holders of current round
1850         uint256 marketing;    // % of buy in thats paid for marketing
1851     }
1852     struct PotSplit {
1853         uint256 gen;          // % of pot thats paid to key holders of current round
1854         uint256 marketing;    // % of pot thats paid to for marketing
1855     }
1856 }
1857 
1858 library F3DKeysCalcLong {
1859     using SafeMath for *;
1860     /**
1861      * @dev calculates number of keys received given X eth
1862      * @param _curEth current amount of eth in contract
1863      * @param _newEth eth being spent
1864      * @return amount of ticket purchased
1865      */
1866     function keysRec(uint256 _curEth, uint256 _newEth)
1867     internal
1868     pure
1869     returns (uint256)
1870     {
1871         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1872     }
1873 
1874     /**
1875      * @dev calculates amount of eth received if you sold X keys
1876      * @param _curKeys current amount of keys that exist
1877      * @param _sellKeys amount of keys you wish to sell
1878      * @return amount of eth received
1879      */
1880     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1881     internal
1882     pure
1883     returns (uint256)
1884     {
1885         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1886     }
1887 
1888     /**
1889      * @dev calculates how many keys would exist with given an amount of eth
1890      * @param _eth eth "in contract"
1891      * @return number of keys that would exist
1892      */
1893     function keys(uint256 _eth)
1894     internal
1895     pure
1896     returns(uint256)
1897     {
1898         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1899     }
1900 
1901     /**
1902      * @dev calculates how much eth would be in contract given a number of keys
1903      * @param _keys number of keys "in contract"
1904      * @return eth that would exists
1905      */
1906     function eth(uint256 _keys)
1907     internal
1908     pure
1909     returns(uint256)
1910     {
1911         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1912     }
1913 }