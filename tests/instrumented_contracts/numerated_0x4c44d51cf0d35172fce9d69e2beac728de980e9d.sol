1 /*
2 
3   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9   http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 pragma solidity ^0.4.15;
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal constant returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Math
52  * @dev Assorted math operations
53  */
54 
55 library Math {
56   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
57     return a >= b ? a : b;
58   }
59 
60   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
61     return a < b ? a : b;
62   }
63 
64   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
65     return a >= b ? a : b;
66   }
67 
68   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
69     return a < b ? a : b;
70   }
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   uint256 public totalSupply;
80   function balanceOf(address who) constant returns (uint256);
81   function transfer(address to, uint256 value) returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) returns (bool);
92   function approve(address spender, uint256 value) returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title Ownable
98  * @dev The Ownable contract has an owner address, and provides basic authorization control
99  * functions, this simplifies the implementation of "user permissions".
100  */
101 contract Ownable {
102   address public owner;
103 
104   /**
105    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106    * account.
107    */
108   function Ownable() {
109     owner = msg.sender;
110   }
111 
112 
113   /**
114    * @dev Throws if called by any account other than the owner.
115    */
116   modifier onlyOwner() {
117     require(msg.sender == owner);
118     _;
119   }
120 
121 
122   /**
123    * @dev Allows the current owner to transfer control of the contract to a newOwner.
124    * @param newOwner The address to transfer ownership to.
125    */
126   function transferOwnership(address newOwner) onlyOwner {
127     if (newOwner != address(0)) {
128       owner = newOwner;
129     }
130   }
131 
132 }
133 
134 /// @title UintUtil
135 /// @author Daniel Wang - <daniel@loopring.org>
136 /// @dev uint utility functions
137 library UintLib {
138     using SafeMath  for uint;
139 
140     function tolerantSub(uint x, uint y) internal constant returns (uint z) {
141         if (x >= y)
142             z = x - y;
143         else
144             z = 0;
145     }
146 
147     function next(uint i, uint size) internal constant returns (uint) {
148         return (i + 1) % size;
149     }
150 
151     function prev(uint i, uint size) internal constant returns (uint) {
152         return (i + size - 1) % size;
153     }
154 
155     /// @dev calculate the square of Coefficient of Variation (CV)
156     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
157     function cvsquare(
158         uint[] arr,
159         uint scale)
160         internal
161         constant
162         returns (uint)
163     {
164         uint len = arr.length;
165         require(len > 1);
166         require(scale > 0);
167 
168         uint avg = 0;
169         for (uint i = 0; i < len; i++) {
170             avg += arr[i];
171         }
172 
173         avg = avg.div(len);
174 
175         if (avg == 0) {
176             return 0;
177         }
178 
179         uint cvs = 0;
180         for (i = 0; i < len; i++) {
181             uint sub = 0;
182             if (arr[i] > avg) {
183                 sub = arr[i] - avg;
184             } else {
185                 sub = avg - arr[i];
186             }
187             cvs += sub.mul(sub);
188         }
189 
190         return cvs.mul(scale).div(avg).mul(scale).div(avg).div(len - 1);
191     }
192 }
193 
194 /// @title Token Register Contract
195 /// @author Kongliang Zhong - <kongliang@loopring.org>,
196 /// @author Daniel Wang - <daniel@loopring.org>.
197 library Uint8Lib {
198     function xorReduce(
199         uint8[] arr,
200         uint    len
201         )
202         internal
203         constant
204         returns (uint8 res)
205     {
206         res = arr[0];
207         for (uint i = 1; i < len; i++) {
208             res ^= arr[i];
209         }
210     }
211 }
212 
213 /// @title Token Register Contract
214 /// @author Daniel Wang - <daniel@loopring.org>.
215 library ErrorLib {
216 
217     event Error(string message);
218 
219     /// @dev Check if condition hold, if not, log an exception and revert.
220     function check(bool condition, string message) internal constant {
221         if (!condition) {
222             error(message);
223         }
224     }
225 
226     function error(string message) internal constant {
227         Error(message);
228         revert();
229     }
230 }
231 
232 /// @title Token Register Contract
233 /// @author Kongliang Zhong - <kongliang@loopring.org>,
234 /// @author Daniel Wang - <daniel@loopring.org>.
235 library Bytes32Lib {
236 
237     function xorReduce(
238         bytes32[]   arr,
239         uint        len
240         )
241         internal
242         constant
243         returns (bytes32 res)
244     {
245         res = arr[0];
246         for (uint i = 1; i < len; i++) {
247             res = xorOp(res, arr[i]);
248         }
249     }
250 
251     function xorOp(
252         bytes32 bs1,
253         bytes32 bs2
254         )
255         internal
256         constant
257         returns (bytes32 res)
258     {
259         bytes memory temp = new bytes(32);
260         for (uint i = 0; i < 32; i++) {
261             temp[i] = bs1[i] ^ bs2[i];
262         }
263         string memory str = string(temp);
264         assembly {
265             res := mload(add(str, 32))
266         }
267     }
268 }
269 
270 /// @title Token Register Contract
271 /// @author Kongliang Zhong - <kongliang@loopring.org>,
272 /// @author Daniel Wang - <daniel@loopring.org>.
273 contract TokenRegistry is Ownable {
274 
275     address[] public tokens;
276 
277     mapping (string => address) tokenSymbolMap;
278 
279     function registerToken(address _token, string _symbol)
280         public
281         onlyOwner
282     {
283         require(_token != address(0));
284         require(!isTokenRegisteredBySymbol(_symbol));
285         require(!isTokenRegistered(_token));
286         tokens.push(_token);
287         tokenSymbolMap[_symbol] = _token;
288     }
289 
290     function unregisterToken(address _token, string _symbol)
291         public
292         onlyOwner
293     {
294         require(tokenSymbolMap[_symbol] == _token);
295         delete tokenSymbolMap[_symbol];
296         for (uint i = 0; i < tokens.length; i++) {
297             if (tokens[i] == _token) {
298                 tokens[i] == tokens[tokens.length - 1];
299                 tokens.length --;
300                 break;
301             }
302         }
303     }
304 
305     function isTokenRegisteredBySymbol(string symbol)
306         public
307         constant
308         returns (bool)
309     {
310         return tokenSymbolMap[symbol] != address(0);
311     }
312 
313     function isTokenRegistered(address _token)
314         public
315         constant
316         returns (bool)
317     {
318 
319         for (uint i = 0; i < tokens.length; i++) {
320             if (tokens[i] == _token) {
321                 return true;
322             }
323         }
324         return false;
325     }
326 
327     function getAddressBySymbol(string symbol)
328         public
329         constant
330         returns (address)
331     {
332         return tokenSymbolMap[symbol];
333     }
334 
335 }
336 
337 /// @title TokenTransferDelegate - Acts as a middle man to transfer ERC20 tokens
338 /// on behalf of different versioned of Loopring protocol to avoid ERC20
339 /// re-authorization.
340 /// @author Daniel Wang - <daniel@loopring.org>.
341 contract TokenTransferDelegate is Ownable {
342     using Math for uint;
343 
344     ////////////////////////////////////////////////////////////////////////////
345     /// Variables                                                            ///
346     ////////////////////////////////////////////////////////////////////////////
347 
348     uint lastVersion = 0;
349     address[] public versions;
350     mapping (address => uint) public versioned;
351 
352 
353     ////////////////////////////////////////////////////////////////////////////
354     /// Modifiers                                                            ///
355     ////////////////////////////////////////////////////////////////////////////
356 
357     modifier isVersioned(address addr) {
358         if (versioned[addr] == 0) {
359             revert();
360         }
361         _;
362     }
363 
364     modifier notVersioned(address addr) {
365         if (versioned[addr] > 0) {
366             revert();
367         }
368         _;
369     }
370 
371 
372     ////////////////////////////////////////////////////////////////////////////
373     /// Events                                                               ///
374     ////////////////////////////////////////////////////////////////////////////
375 
376     event VersionAdded(address indexed addr, uint version);
377 
378     event VersionRemoved(address indexed addr, uint version);
379 
380 
381     ////////////////////////////////////////////////////////////////////////////
382     /// Public Functions                                                     ///
383     ////////////////////////////////////////////////////////////////////////////
384 
385     /// @dev Add a Loopring protocol address.
386     /// @param addr A loopring protocol address.
387     function addVersion(address addr)
388         onlyOwner
389         notVersioned(addr)
390     {
391         versioned[addr] = ++lastVersion;
392         versions.push(addr);
393         VersionAdded(addr, lastVersion);
394     }
395 
396     /// @dev Remove a Loopring protocol address.
397     /// @param addr A loopring protocol address.
398     function removeVersion(address addr)
399         onlyOwner
400         isVersioned(addr)
401     {
402         require(versioned[addr] > 0);
403         uint version = versioned[addr];
404         delete versioned[addr];
405 
406         uint length = versions.length;
407         for (uint i = 0; i < length; i++) {
408             if (versions[i] == addr) {
409                 versions[i] = versions[length - 1];
410                 versions.length -= 1;
411                 break;
412             }
413         }
414         VersionRemoved(addr, version);
415     }
416 
417     /// @return Amount of ERC20 token that can be spent by this contract.
418     /// @param tokenAddress Address of token to transfer.
419     /// @param _owner Address of the token owner.
420     function getSpendable(
421         address tokenAddress,
422         address _owner
423         )
424         isVersioned(msg.sender)
425         constant
426         returns (uint)
427     {
428 
429         var token = ERC20(tokenAddress);
430         return token.allowance(
431             _owner,
432             address(this)
433         ).min256(
434             token.balanceOf(_owner)
435         );
436     }
437 
438     /// @dev Invoke ERC20 transferFrom method.
439     /// @param token Address of token to transfer.
440     /// @param from Address to transfer token from.
441     /// @param to Address to transfer token to.
442     /// @param value Amount of token to transfer.
443     /// @return Tansfer result.
444     function transferToken(
445         address token,
446         address from,
447         address to,
448         uint value)
449         isVersioned(msg.sender)
450         returns (bool)
451     {
452         if (from == to) {
453             return false;
454         } else {
455             return ERC20(token).transferFrom(from, to, value);
456         }
457     }
458 
459     /// @dev Gets all versioned addresses.
460     /// @return Array of versioned addresses.
461     function getVersions()
462         constant
463         returns (address[])
464     {
465         return versions;
466     }
467 }
468 
469 /// @title Ring Hash Registry Contract
470 /// @author Kongliang Zhong - <kongliang@loopring.org>,
471 /// @author Daniel Wang - <daniel@loopring.org>.
472 contract RinghashRegistry {
473     using Bytes32Lib    for bytes32[];
474     using ErrorLib      for bool;
475     using Uint8Lib      for uint8[];
476 
477     uint public blocksToLive;
478 
479     struct Submission {
480         address ringminer;
481         uint block;
482     }
483 
484     mapping (bytes32 => Submission) submissions;
485 
486 
487     /// Events
488 
489     event RinghashSubmitted(
490         address indexed _ringminer,
491         bytes32 indexed _ringhash
492     );
493 
494     /// Constructor
495 
496     function RinghashRegistry(uint _blocksToLive)
497         public
498     {
499         require(_blocksToLive > 0);
500         blocksToLive = _blocksToLive;
501     }
502 
503     /// Public Functions
504 
505     function submitRinghash(
506         uint        ringSize,
507         address     ringminer,
508         uint8[]     vList,
509         bytes32[]   rList,
510         bytes32[]   sList)
511         public
512     {
513         bytes32 ringhash = calculateRinghash(
514             ringSize,
515             vList,
516             rList,
517             sList
518         );
519 
520         ErrorLib.check(
521             canSubmit(ringhash, ringminer),
522             "Ringhash submitted"
523         );
524 
525         submissions[ringhash] = Submission(ringminer, block.number);
526         RinghashSubmitted(ringminer, ringhash);
527     }
528 
529     function canSubmit(
530         bytes32 ringhash,
531         address ringminer)
532         public
533         constant
534         returns (bool)
535     {
536         var submission = submissions[ringhash];
537         return (
538             submission.ringminer == address(0) || (
539             submission.block + blocksToLive < block.number) || (
540             submission.ringminer == ringminer)
541         );
542     }
543 
544     /// @return True if a ring's hash has ever been submitted; false otherwise.
545     function ringhashFound(bytes32 ringhash)
546         public
547         constant
548         returns (bool)
549     {
550 
551         return submissions[ringhash].ringminer != address(0);
552     }
553 
554     /// @dev Calculate the hash of a ring.
555     function calculateRinghash(
556         uint        ringSize,
557         uint8[]     vList,
558         bytes32[]   rList,
559         bytes32[]   sList)
560         public
561         constant
562         returns (bytes32)
563     {
564         ErrorLib.check(
565             ringSize == vList.length - 1 && (
566             ringSize == rList.length - 1) && (
567             ringSize == sList.length - 1),
568             "invalid ring data"
569         );
570 
571         return keccak256(
572             vList.xorReduce(ringSize),
573             rList.xorReduce(ringSize),
574             sList.xorReduce(ringSize)
575         );
576     }
577 }
578 
579 /// @title Loopring Token Exchange Protocol Contract Interface
580 /// @author Daniel Wang - <daniel@loopring.org>
581 /// @author Kongliang Zhong - <kongliang@loopring.org>
582 contract LoopringProtocol {
583 
584     ////////////////////////////////////////////////////////////////////////////
585     /// Constants                                                            ///
586     ////////////////////////////////////////////////////////////////////////////
587     uint    public constant FEE_SELECT_LRC               = 0;
588     uint    public constant FEE_SELECT_MARGIN_SPLIT      = 1;
589     uint    public constant FEE_SELECT_MAX_VALUE         = 1;
590 
591     uint    public constant MARGIN_SPLIT_PERCENTAGE_BASE = 100;
592 
593 
594     ////////////////////////////////////////////////////////////////////////////
595     /// Structs                                                              ///
596     ////////////////////////////////////////////////////////////////////////////
597 
598     /// @param tokenS       Token to sell.
599     /// @param tokenB       Token to buy.
600     /// @param amountS      Maximum amount of tokenS to sell.
601     /// @param amountB      Minimum amount of tokenB to buy if all amountS sold.
602     /// @param timestamp    Indicating whtn this order is created/signed.
603     /// @param ttl          Indicating after how many seconds from `timestamp`
604     ///                     this order will expire.
605     /// @param salt         A random number to make this order's hash unique.
606     /// @param lrcFee       Max amount of LRC to pay for miner. The real amount
607     ///                     to pay is proportional to fill amount.
608     /// @param buyNoMoreThanAmountB -
609     ///                     If true, this order does not accept buying more
610     ///                     than `amountB`.
611     /// @param marginSplitPercentage -
612     ///                     The percentage of margin paid to miner.
613     /// @param v            ECDSA signature parameter v.
614     /// @param r            ECDSA signature parameters r.
615     /// @param s            ECDSA signature parameters s.
616     struct Order {
617         address owner;
618         address tokenS;
619         address tokenB;
620         uint    amountS;
621         uint    amountB;
622         uint    timestamp;
623         uint    ttl;
624         uint    salt;
625         uint    lrcFee;
626         bool    buyNoMoreThanAmountB;
627         uint8   marginSplitPercentage;
628         uint8   v;
629         bytes32 r;
630         bytes32 s;
631     }
632 
633 
634     ////////////////////////////////////////////////////////////////////////////
635     /// Public Functions                                                     ///
636     ////////////////////////////////////////////////////////////////////////////
637 
638     /// @dev Submit a order-ring for validation and settlement.
639     /// @param addressList  List of each order's owner and tokenS. Note that next
640     ///                     order's `tokenS` equals this order's `tokenB`.
641     /// @param uintArgsList List of uint-type arguments in this order:
642     ///                     amountS, AmountB, rateAmountS, timestamp, ttl, salt,
643     ///                     and lrcFee.
644     /// @param uint8ArgsList -
645     ///                     List of unit8-type arguments, in this order:
646     ///                     marginSplitPercentageList, feeSelectionList.
647     /// @param vList        List of v for each order. This list is 1-larger than
648     ///                     the previous lists, with the last element being the
649     ///                     v value of the ring signature.
650     /// @param rList        List of r for each order. This list is 1-larger than
651     ///                     the previous lists, with the last element being the
652     ///                     r value of the ring signature.
653     /// @param sList        List of s for each order. This list is 1-larger than
654     ///                     the previous lists, with the last element being the
655     ///                     s value of the ring signature.
656     /// @param ringminer    The address that signed this tx.
657     /// @param feeRecepient The recepient address for fee collection. If this is
658     ///                     '0x0', all fees will be paid to the address who had
659     ///                     signed this transaction, not `msg.sender`. Noted if
660     ///                     LRC need to be paid back to order owner as the result
661     ///                     of fee selection model, LRC will also be sent from
662     ///                     this address.
663     /// @param throwIfLRCIsInsuffcient -
664     ///                     If true, throw exception if any order's spendable
665     ///                     LRC amount is smaller than requried; if false, ring-
666     ///                     minor will give up collection the LRC fee.
667     function submitRing(
668         address[2][]    addressList,
669         uint[7][]       uintArgsList,
670         uint8[2][]      uint8ArgsList,
671         bool[]          buyNoMoreThanAmountBList,
672         uint8[]         vList,
673         bytes32[]       rList,
674         bytes32[]       sList,
675         address         ringminer,
676         address         feeRecepient,
677         bool            throwIfLRCIsInsuffcient
678         ) public;
679 
680     /// @dev Cancel a order. cancel amount(amountS or amountB) can be specified
681     ///      in orderValues.
682     /// @param addresses          owner, tokenS, tokenB
683     /// @param orderValues        amountS, amountB, timestamp, ttl, salt, lrcFee,
684     ///                           cancelAmountS, and cancelAmountB.
685     /// @param marginSplitPercentage -
686     /// @param buyNoMoreThanAmountB -
687     /// @param v                  Order ECDSA signature parameter v.
688     /// @param r                  Order ECDSA signature parameters r.
689     /// @param s                  Order ECDSA signature parameters s.
690     function cancelOrder(
691         address[3] addresses,
692         uint[7]    orderValues,
693         bool       buyNoMoreThanAmountB,
694         uint8      marginSplitPercentage,
695         uint8      v,
696         bytes32    r,
697         bytes32    s
698         ) public;
699 
700     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
701     ///        is smaller than or equal to the new value of the address's cutoff
702     ///        timestamp.
703     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
704     ///        if it is 0.
705     function setCutoff(uint cutoff) public;
706 }
707 
708 /// @title Loopring Token Exchange Protocol Implementation Contract v1
709 /// @author Daniel Wang - <daniel@loopring.org>,
710 /// @author Kongliang Zhong - <kongliang@loopring.org>
711 contract LoopringProtocolImpl is LoopringProtocol {
712     using Math      for uint;
713     using SafeMath  for uint;
714     using UintLib   for uint;
715 
716     ////////////////////////////////////////////////////////////////////////////
717     /// Variables                                                            ///
718     ////////////////////////////////////////////////////////////////////////////
719 
720     address public  lrcTokenAddress             = address(0);
721     address public  tokenRegistryAddress        = address(0);
722     address public  ringhashRegistryAddress     = address(0);
723     address public  delegateAddress             = address(0);
724 
725     uint    public  maxRingSize                 = 0;
726     uint    public  ringIndex                   = 0;
727     bool    private entered                     = false;
728 
729     // Exchange rate (rate) is the amount to sell or sold divided by the amount
730     // to buy or bought.
731     //
732     // Rate ratio is the ratio between executed rate and an order's original
733     // rate.
734     //
735     // To require all orders' rate ratios to have coefficient ofvariation (CV)
736     // smaller than 2.5%, for an example , rateRatioCVSThreshold should be:
737     //     `(0.025 * RATE_RATIO_SCALE)^2` or 62500.
738     uint    public  rateRatioCVSThreshold       = 0;
739 
740     uint    public constant RATE_RATIO_SCALE    = 10000;
741 
742     // The following two maps are used to keep trace of order fill and
743     // cancellation history.
744     mapping (bytes32 => uint) public filled;
745     mapping (bytes32 => uint) public cancelled;
746 
747     // A map from address to its cutoff timestamp.
748     mapping (address => uint) public cutoffs;
749 
750 
751     ////////////////////////////////////////////////////////////////////////////
752     /// Structs                                                              ///
753     ////////////////////////////////////////////////////////////////////////////
754 
755     struct Rate {
756         uint amountS;
757         uint amountB;
758     }
759 
760     /// @param order        The original order
761     /// @param orderHash    The order's hash
762     /// @param feeSelection -
763     ///                     A miner-supplied value indicating if LRC (value = 0)
764     ///                     or margin split is choosen by the miner (value = 1).
765     ///                     We may support more fee model in the future.
766     /// @param rate         Exchange rate provided by miner.
767     /// @param availableAmountS -
768     ///                     The actual spendable amountS.
769     /// @param fillAmountS  Amount of tokenS to sell, calculated by protocol.
770     /// @param lrcReward    The amount of LRC paid by miner to order owner in
771     ///                     exchange for margin split.
772     /// @param lrcFee       The amount of LR paid by order owner to miner.
773     /// @param splitS      TokenS paid to miner.
774     /// @param splitB      TokenB paid to miner.
775     struct OrderState {
776         Order   order;
777         bytes32 orderHash;
778         uint8   feeSelection;
779         Rate    rate;
780         uint    availableAmountS;
781         uint    fillAmountS;
782         uint    lrcReward;
783         uint    lrcFee;
784         uint    splitS;
785         uint    splitB;
786     }
787 
788     struct Ring {
789         bytes32      ringhash;
790         OrderState[] orders;
791         address      miner;
792         address      feeRecepient;
793         bool         throwIfLRCIsInsuffcient;
794     }
795 
796 
797     ////////////////////////////////////////////////////////////////////////////
798     /// Events                                                               ///
799     ////////////////////////////////////////////////////////////////////////////
800 
801     event RingMined(
802         uint                _ringIndex,
803         uint                _time,
804         uint                _blocknumber,
805         bytes32     indexed _ringhash,
806         address     indexed _miner,
807         address     indexed _feeRecepient,
808         bool                _ringhashFound);
809 
810     event OrderFilled(
811         uint                _ringIndex,
812         uint                _time,
813         uint                _blocknumber,
814         bytes32     indexed _ringhash,
815         bytes32             _prevOrderHash,
816         bytes32     indexed _orderHash,
817         bytes32              _nextOrderHash,
818         uint                _amountS,
819         uint                _amountB,
820         uint                _lrcReward,
821         uint                _lrcFee);
822 
823     event OrderCancelled(
824         uint                _time,
825         uint                _blocknumber,
826         bytes32     indexed _orderHash,
827         uint                _amountCancelled);
828 
829     event CutoffTimestampChanged(
830         uint                _time,
831         uint                _blocknumber,
832         address     indexed _address,
833         uint                _cutoff);
834 
835 
836     ////////////////////////////////////////////////////////////////////////////
837     /// Constructor                                                          ///
838     ////////////////////////////////////////////////////////////////////////////
839 
840     function LoopringProtocolImpl(
841         address _lrcTokenAddress,
842         address _tokenRegistryAddress,
843         address _ringhashRegistryAddress,
844         address _delegateAddress,
845         uint    _maxRingSize,
846         uint    _rateRatioCVSThreshold
847         )
848         public
849     {
850         require(address(0) != _lrcTokenAddress);
851         require(address(0) != _tokenRegistryAddress);
852         require(address(0) != _delegateAddress);
853 
854         require(_maxRingSize > 1);
855         require(_rateRatioCVSThreshold > 0);
856 
857         lrcTokenAddress = _lrcTokenAddress;
858         tokenRegistryAddress = _tokenRegistryAddress;
859         ringhashRegistryAddress = _ringhashRegistryAddress;
860         delegateAddress = _delegateAddress;
861         maxRingSize = _maxRingSize;
862         rateRatioCVSThreshold = _rateRatioCVSThreshold;
863     }
864 
865     ////////////////////////////////////////////////////////////////////////////
866     /// Public Functions                                                     ///
867     ////////////////////////////////////////////////////////////////////////////
868 
869     /// @dev Disable default function.
870     function ()
871         payable
872     {
873         revert();
874     }
875 
876     /// @dev Submit a order-ring for validation and settlement.
877     /// @param addressList  List of each order's tokenS. Note that next order's
878     ///                     `tokenS` equals this order's `tokenB`.
879     /// @param uintArgsList List of uint-type arguments in this order:
880     ///                     amountS, amountB, timestamp, ttl, salt, lrcFee,
881     ///                     rateAmountS.
882     /// @param uint8ArgsList -
883     ///                     List of unit8-type arguments, in this order:
884     ///                     marginSplitPercentageList,feeSelectionList.
885     /// @param vList        List of v for each order. This list is 1-larger than
886     ///                     the previous lists, with the last element being the
887     ///                     v value of the ring signature.
888     /// @param rList        List of r for each order. This list is 1-larger than
889     ///                     the previous lists, with the last element being the
890     ///                     r value of the ring signature.
891     /// @param sList        List of s for each order. This list is 1-larger than
892     ///                     the previous lists, with the last element being the
893     ///                     s value of the ring signature.
894     /// @param ringminer    The address that signed this tx.
895     /// @param feeRecepient The recepient address for fee collection. If this is
896     ///                     '0x0', all fees will be paid to the address who had
897     ///                     signed this transaction, not `msg.sender`. Noted if
898     ///                     LRC need to be paid back to order owner as the result
899     ///                     of fee selection model, LRC will also be sent from
900     ///                     this address.
901     /// @param throwIfLRCIsInsuffcient -
902     ///                     If true, throw exception if any order's spendable
903     ///                     LRC amount is smaller than requried; if false, ring-
904     ///                     minor will give up collection the LRC fee.
905     function submitRing(
906         address[2][]    addressList,
907         uint[7][]       uintArgsList,
908         uint8[2][]      uint8ArgsList,
909         bool[]          buyNoMoreThanAmountBList,
910         uint8[]         vList,
911         bytes32[]       rList,
912         bytes32[]       sList,
913         address         ringminer,
914         address         feeRecepient,
915         bool            throwIfLRCIsInsuffcient
916         )
917         public
918     {
919         ErrorLib.check(!entered, "attempted to re-ent submitRing function");
920         entered = true;
921 
922         //Check ring size
923         uint ringSize = addressList.length;
924         ErrorLib.check(
925             ringSize > 1 && ringSize <= maxRingSize,
926             "invalid ring size"
927         );
928 
929         verifyInputDataIntegrity(
930             ringSize,
931             addressList,
932             uintArgsList,
933             uint8ArgsList,
934             buyNoMoreThanAmountBList,
935             vList,
936             rList,
937             sList
938         );
939 
940         verifyTokensRegistered(addressList);
941 
942         var ringhashRegistry = RinghashRegistry(ringhashRegistryAddress);
943 
944         bytes32 ringhash = ringhashRegistry.calculateRinghash(
945             ringSize,
946             vList,
947             rList,
948             sList
949         );
950 
951         ErrorLib.check(
952             ringhashRegistry.canSubmit(ringhash, feeRecepient),
953             "Ring claimed by others"
954         );
955 
956         verifySignature(
957             ringminer,
958             ringhash,
959             vList[ringSize],
960             rList[ringSize],
961             sList[ringSize]
962         );
963 
964         //Assemble input data into a struct so we can pass it to functions.
965         var orders = assembleOrders(
966             ringSize,
967             addressList,
968             uintArgsList,
969             uint8ArgsList,
970             buyNoMoreThanAmountBList,
971             vList,
972             rList,
973             sList
974         );
975 
976         if (feeRecepient == address(0)) {
977             feeRecepient = ringminer;
978         }
979 
980         handleRing(
981             ringhash,
982             orders,
983             ringminer,
984             feeRecepient,
985             throwIfLRCIsInsuffcient
986         );
987 
988         entered = false;
989     }
990 
991     /// @dev Cancel a order. Amount (amountS or amountB) to cancel can be
992     ///                           specified using orderValues.
993     /// @param addresses          owner, tokenS, tokenB
994     /// @param orderValues        amountS, amountB, timestamp, ttl, salt,
995     ///                           lrcFee, and cancelAmount
996     /// @param buyNoMoreThanAmountB -
997     ///                           If true, this order does not accept buying
998     ///                           more than `amountB`.
999     /// @param marginSplitPercentage -
1000     ///                           The percentage of margin paid to miner.
1001     /// @param v                  Order ECDSA signature parameter v.
1002     /// @param r                  Order ECDSA signature parameters r.
1003     /// @param s                  Order ECDSA signature parameters s.
1004 
1005     function cancelOrder(
1006         address[3] addresses,
1007         uint[7]    orderValues,
1008         bool       buyNoMoreThanAmountB,
1009         uint8      marginSplitPercentage,
1010         uint8      v,
1011         bytes32    r,
1012         bytes32    s
1013         )
1014         public
1015     {
1016         uint cancelAmount = orderValues[6];
1017         ErrorLib.check(cancelAmount > 0, "amount to cancel is zero");
1018 
1019         var order = Order(
1020             addresses[0],
1021             addresses[1],
1022             addresses[2],
1023             orderValues[0],
1024             orderValues[1],
1025             orderValues[2],
1026             orderValues[3],
1027             orderValues[4],
1028             orderValues[5],
1029             buyNoMoreThanAmountB,
1030             marginSplitPercentage,
1031             v,
1032             r,
1033             s
1034         );
1035 
1036         ErrorLib.check(msg.sender == order.owner, "cancelOrder not submitted by order owner");
1037 
1038         bytes32 orderHash = calculateOrderHash(order);
1039 
1040         verifySignature(
1041             order.owner,
1042             orderHash,
1043             order.v,
1044             order.r,
1045             order.s
1046         );
1047 
1048         cancelled[orderHash] = cancelled[orderHash].add(cancelAmount);
1049 
1050         OrderCancelled(
1051             block.timestamp,
1052             block.number,
1053             orderHash,
1054             cancelAmount
1055         );
1056     }
1057 
1058     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
1059     ///        is smaller than or equal to the new value of the address's cutoff
1060     ///        timestamp.
1061     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
1062     ///        if it is 0.
1063     function setCutoff(uint cutoff)
1064         public
1065     {
1066         uint t = cutoff;
1067         if (t == 0) {
1068             t = block.timestamp;
1069         }
1070 
1071         ErrorLib.check(
1072             cutoffs[msg.sender] < t,
1073             "attempted to set cutoff to a smaller value"
1074         );
1075 
1076         cutoffs[msg.sender] = t;
1077 
1078         CutoffTimestampChanged(
1079             block.timestamp,
1080             block.number,
1081             msg.sender,
1082             t
1083         );
1084     }
1085 
1086     ////////////////////////////////////////////////////////////////////////////
1087     /// Internal & Private Functions                                         ///
1088     ////////////////////////////////////////////////////////////////////////////
1089 
1090     /// @dev Validate a ring.
1091     function verifyRingHasNoSubRing(Ring ring)
1092         internal
1093         constant
1094     {
1095         uint ringSize = ring.orders.length;
1096         // Check the ring has no sub-ring.
1097         for (uint i = 0; i < ringSize - 1; i++) {
1098             address tokenS = ring.orders[i].order.tokenS;
1099             for (uint j = i + 1; j < ringSize; j++) {
1100                 ErrorLib.check(
1101                     tokenS != ring.orders[j].order.tokenS,
1102                     "found sub-ring"
1103                 );
1104             }
1105         }
1106     }
1107 
1108     function verifyTokensRegistered(address[2][] addressList)
1109         internal
1110         constant
1111     {
1112         var registryContract = TokenRegistry(tokenRegistryAddress);
1113         for (uint i = 0; i < addressList.length; i++) {
1114             ErrorLib.check(
1115                 registryContract.isTokenRegistered(addressList[i][1]),
1116                 "token not registered"
1117             );
1118         }
1119     }
1120 
1121     function handleRing(
1122         bytes32 ringhash,
1123         OrderState[] orders,
1124         address miner,
1125         address feeRecepient,
1126         bool throwIfLRCIsInsuffcient
1127         )
1128         internal
1129     {
1130         var ring = Ring(
1131             ringhash,
1132             orders,
1133             miner,
1134             feeRecepient,
1135             throwIfLRCIsInsuffcient
1136         );
1137 
1138         // Do the hard work.
1139         verifyRingHasNoSubRing(ring);
1140 
1141         // Exchange rates calculation are performed by ring-miners as solidity
1142         // cannot get power-of-1/n operation, therefore we have to verify
1143         // these rates are correct.
1144         verifyMinerSuppliedFillRates(ring);
1145 
1146         // Scale down each order independently by substracting amount-filled and
1147         // amount-cancelled. Order owner's current balance and allowance are
1148         // not taken into consideration in these operations.
1149         scaleRingBasedOnHistoricalRecords(ring);
1150 
1151         // Based on the already verified exchange rate provided by ring-miners,
1152         // we can furthur scale down orders based on token balance and allowance,
1153         // then find the smallest order of the ring, then calculate each order's
1154         // `fillAmountS`.
1155         calculateRingFillAmount(ring);
1156 
1157         // Calculate each order's `lrcFee` and `lrcRewrard` and splict how much
1158         // of `fillAmountS` shall be paid to matching order or miner as margin
1159         // split.
1160         calculateRingFees(ring);
1161 
1162         /// Make payments.
1163         settleRing(ring);
1164 
1165         RingMined(
1166             ringIndex++,
1167             block.timestamp,
1168             block.number,
1169             ring.ringhash,
1170             ring.miner,
1171             ring.feeRecepient,
1172             RinghashRegistry(ringhashRegistryAddress).ringhashFound(ring.ringhash)
1173         );
1174     }
1175 
1176     function settleRing(Ring ring)
1177         internal
1178     {
1179         uint ringSize = ring.orders.length;
1180         var delegate = TokenTransferDelegate(delegateAddress);
1181 
1182         for (uint i = 0; i < ringSize; i++) {
1183             var state = ring.orders[i];
1184             var prev = ring.orders[i.prev(ringSize)];
1185             var next = ring.orders[i.next(ringSize)];
1186 
1187             // Pay tokenS to previous order, or to miner as previous order's
1188             // margin split or/and this order's margin split.
1189 
1190             delegate.transferToken(
1191                 state.order.tokenS,
1192                 state.order.owner,
1193                 prev.order.owner,
1194                 state.fillAmountS - prev.splitB
1195             );
1196 
1197             if (prev.splitB + state.splitS > 0) {
1198                 delegate.transferToken(
1199                     state.order.tokenS,
1200                     state.order.owner,
1201                     ring.feeRecepient,
1202                     prev.splitB + state.splitS
1203                 );
1204             }
1205 
1206             // Pay LRC
1207             if (state.lrcReward > 0) {
1208                 delegate.transferToken(
1209                     lrcTokenAddress,
1210                     ring.feeRecepient,
1211                     state.order.owner,
1212                     state.lrcReward
1213                 );
1214             }
1215 
1216             if (state.lrcFee > 0) {
1217                 delegate.transferToken(
1218                     lrcTokenAddress,
1219                     state.order.owner,
1220                     ring.feeRecepient,
1221                     state.lrcFee
1222                 );
1223             }
1224 
1225             // Update fill records
1226             if (state.order.buyNoMoreThanAmountB) {
1227                 filled[state.orderHash] += next.fillAmountS;
1228             } else {
1229                 filled[state.orderHash] += state.fillAmountS;
1230             }
1231 
1232             OrderFilled(
1233                 ringIndex,
1234                 block.timestamp,
1235                 block.number,
1236                 ring.ringhash,
1237                 prev.orderHash,
1238                 state.orderHash,
1239                 next.orderHash,
1240                 state.fillAmountS + state.splitS,
1241                 next.fillAmountS - state.splitB,
1242                 state.lrcReward,
1243                 state.lrcFee
1244             );
1245         }
1246 
1247     }
1248 
1249     function verifyMinerSuppliedFillRates(Ring ring)
1250         internal
1251         constant
1252     {
1253         var orders = ring.orders;
1254         uint ringSize = orders.length;
1255         uint[] memory rateRatios = new uint[](ringSize);
1256 
1257         for (uint i = 0; i < ringSize; i++) {
1258             uint s1b0 = orders[i].rate.amountS.mul(orders[i].order.amountB);
1259             uint s0b1 = orders[i].order.amountS.mul(orders[i].rate.amountB);
1260 
1261             ErrorLib.check(
1262                 s1b0 <= s0b1,
1263                 "miner supplied exchange rate provides invalid discount"
1264             );
1265 
1266             rateRatios[i] = RATE_RATIO_SCALE.mul(s1b0).div(s0b1);
1267         }
1268 
1269         uint cvs = UintLib.cvsquare(rateRatios, RATE_RATIO_SCALE);
1270 
1271         ErrorLib.check(
1272             cvs <= rateRatioCVSThreshold,
1273             "miner supplied exchange rate is not evenly discounted"
1274         );
1275     }
1276 
1277     function calculateRingFees(Ring ring)
1278         internal
1279         constant
1280     {
1281         uint minerLrcSpendable = getLRCSpendable(ring.feeRecepient);
1282         uint ringSize = ring.orders.length;
1283 
1284         for (uint i = 0; i < ringSize; i++) {
1285             var state = ring.orders[i];
1286             var next = ring.orders[i.next(ringSize)];
1287 
1288             if (state.feeSelection == FEE_SELECT_LRC) {
1289 
1290                 uint lrcSpendable = getLRCSpendable(state.order.owner);
1291 
1292                 if (lrcSpendable < state.lrcFee) {
1293                     ErrorLib.check(
1294                         !ring.throwIfLRCIsInsuffcient,
1295                         "order LRC balance insuffcient"
1296                     );
1297 
1298                     state.lrcFee = lrcSpendable;
1299                     minerLrcSpendable += lrcSpendable;
1300                 }
1301 
1302             } else if (state.feeSelection == FEE_SELECT_MARGIN_SPLIT) {
1303                 if (minerLrcSpendable >= state.lrcFee) {
1304                     if (state.order.buyNoMoreThanAmountB) {
1305                         uint splitS = next.fillAmountS.mul(
1306                             state.order.amountS
1307                         ).div(
1308                             state.order.amountB
1309                         ).sub(
1310                             state.fillAmountS
1311                         );
1312 
1313                         state.splitS = splitS.mul(
1314                             state.order.marginSplitPercentage
1315                         ).div(
1316                             MARGIN_SPLIT_PERCENTAGE_BASE
1317                         );
1318                     } else {
1319                         uint splitB = next.fillAmountS.sub(state.fillAmountS
1320                             .mul(state.order.amountB)
1321                             .div(state.order.amountS)
1322                         );
1323 
1324                         state.splitB = splitB.mul(
1325                             state.order.marginSplitPercentage
1326                         ).div(
1327                             MARGIN_SPLIT_PERCENTAGE_BASE
1328                         );
1329                     }
1330 
1331                     // This implicits order with smaller index in the ring will
1332                     // be paid LRC reward first, so the orders in the ring does
1333                     // mater.
1334                     if (state.splitS > 0 || state.splitB > 0) {
1335                         minerLrcSpendable = minerLrcSpendable.sub(state.lrcFee);
1336                         state.lrcReward = state.lrcFee;
1337                     }
1338                     state.lrcFee = 0;
1339                 }
1340             } else {
1341                 ErrorLib.error("unsupported fee selection value");
1342             }
1343         }
1344 
1345     }
1346 
1347     function calculateRingFillAmount(Ring ring)
1348         internal
1349         constant
1350     {
1351         uint ringSize = ring.orders.length;
1352         uint smallestIdx = 0;
1353         uint i;
1354         uint j;
1355 
1356         for (i = 0; i < ringSize; i++) {
1357             j = i.next(ringSize);
1358 
1359             uint res = calculateOrderFillAmount(
1360                 ring.orders[i],
1361                 ring.orders[j]
1362             );
1363 
1364             if (res == 1) {
1365                 smallestIdx = i;
1366             } else if (res == 2) {
1367                 smallestIdx = j;
1368             }
1369         }
1370 
1371         for (i = 0; i < smallestIdx; i++) {
1372             j = i.next(ringSize);
1373             calculateOrderFillAmount(
1374                 ring.orders[i],
1375                 ring.orders[j]
1376             );
1377         }
1378     }
1379 
1380     /// @return 0 if neither order is the smallest one;
1381     ///         1 if 'state' is the smallest order;
1382     ///         2 if 'next' is the smallest order.
1383     function calculateOrderFillAmount(
1384         OrderState state,
1385         OrderState next
1386         )
1387         internal
1388         constant
1389         returns (uint whichIsSmaller)
1390     {
1391         uint fillAmountB = state.fillAmountS.mul(
1392             state.rate.amountB
1393         ).div(
1394             state.rate.amountS
1395         );
1396 
1397         if (state.order.buyNoMoreThanAmountB) {
1398             if (fillAmountB > state.order.amountB) {
1399                 fillAmountB = state.order.amountB;
1400 
1401                 state.fillAmountS = fillAmountB.mul(
1402                     state.rate.amountS
1403                 ).div(
1404                     state.rate.amountB
1405                 );
1406 
1407                 whichIsSmaller = 1;
1408             }
1409         }
1410 
1411         state.lrcFee = state.order.lrcFee.mul(
1412             state.fillAmountS
1413         ).div(
1414             state.order.amountS
1415         );
1416 
1417         if (fillAmountB <= next.fillAmountS) {
1418             next.fillAmountS = fillAmountB;
1419         } else {
1420             whichIsSmaller = 2;
1421         }
1422     }
1423 
1424     /// @dev Scale down all orders based on historical fill or cancellation
1425     ///      stats but key the order's original exchange rate.
1426     function scaleRingBasedOnHistoricalRecords(Ring ring)
1427         internal
1428         constant
1429     {
1430         uint ringSize = ring.orders.length;
1431 
1432         for (uint i = 0; i < ringSize; i++) {
1433             var state = ring.orders[i];
1434             var order = state.order;
1435 
1436             if (order.buyNoMoreThanAmountB) {
1437                 uint amountB = order.amountB.sub(
1438                     filled[state.orderHash]
1439                 ).tolerantSub(
1440                     cancelled[state.orderHash]
1441                 );
1442 
1443                 order.amountS = amountB.mul(order.amountS).div(order.amountB);
1444                 order.lrcFee = amountB.mul(order.lrcFee).div(order.amountB);
1445 
1446                 order.amountB = amountB;
1447             } else {
1448                 uint amountS = order.amountS.sub(
1449                     filled[state.orderHash]
1450                 ).tolerantSub(
1451                     cancelled[state.orderHash]
1452                 );
1453 
1454                 order.amountB = amountS.mul(order.amountB).div(order.amountS);
1455                 order.lrcFee = amountS.mul(order.lrcFee).div(order.amountS);
1456 
1457                 order.amountS = amountS;
1458             }
1459 
1460             ErrorLib.check(order.amountS > 0, "amountS is zero");
1461             ErrorLib.check(order.amountB > 0, "amountB is zero");
1462 
1463             state.fillAmountS = order.amountS.min256(state.availableAmountS);
1464         }
1465     }
1466 
1467     /// @return Amount of ERC20 token that can be spent by this contract.
1468     function getSpendable(
1469         address tokenAddress,
1470         address tokenOwner
1471         )
1472         internal
1473         constant
1474         returns (uint)
1475     {
1476         return TokenTransferDelegate(
1477             delegateAddress
1478         ).getSpendable(
1479             tokenAddress,
1480             tokenOwner
1481         );
1482     }
1483 
1484     /// @return Amount of LRC token that can be spent by this contract.
1485     function getLRCSpendable(address tokenOwner)
1486         internal
1487         constant
1488         returns (uint)
1489     {
1490         return getSpendable(lrcTokenAddress, tokenOwner);
1491     }
1492 
1493     /// @dev verify input data's basic integrity.
1494     function verifyInputDataIntegrity(
1495         uint ringSize,
1496         address[2][]    addressList,
1497         uint[7][]       uintArgsList,
1498         uint8[2][]      uint8ArgsList,
1499         bool[]          buyNoMoreThanAmountBList,
1500         uint8[]         vList,
1501         bytes32[]       rList,
1502         bytes32[]       sList
1503         )
1504         internal
1505         constant
1506     {
1507         ErrorLib.check(
1508             ringSize == addressList.length,
1509             "ring data is inconsistent - addressList"
1510         );
1511 
1512         ErrorLib.check(
1513             ringSize == uintArgsList.length,
1514             "ring data is inconsistent - uintArgsList"
1515         );
1516 
1517         ErrorLib.check(
1518             ringSize == uint8ArgsList.length,
1519             "ring data is inconsistent - uint8ArgsList"
1520         );
1521 
1522         ErrorLib.check(
1523             ringSize == buyNoMoreThanAmountBList.length,
1524             "ring data is inconsistent - buyNoMoreThanAmountBList"
1525         );
1526 
1527         ErrorLib.check(
1528             ringSize + 1 == vList.length,
1529             "ring data is inconsistent - vList"
1530         );
1531 
1532         ErrorLib.check(
1533             ringSize + 1 == rList.length,
1534             "ring data is inconsistent - rList"
1535         );
1536 
1537         ErrorLib.check(
1538             ringSize + 1 == sList.length,
1539             "ring data is inconsistent - sList"
1540         );
1541 
1542         // Validate ring-mining related arguments.
1543         for (uint i = 0; i < ringSize; i++) {
1544             ErrorLib.check(
1545                 uintArgsList[i][6] > 0,
1546                 "order rateAmountS is zero"
1547             );
1548 
1549             ErrorLib.check(
1550                 uint8ArgsList[i][1] <= FEE_SELECT_MAX_VALUE,
1551                 "invalid order fee selection"
1552             );
1553         }
1554     }
1555 
1556     /// @dev        assmble order parameters into Order struct.
1557     /// @return     A list of orders.
1558     function assembleOrders(
1559         uint            ringSize,
1560         address[2][]    addressList,
1561         uint[7][]       uintArgsList,
1562         uint8[2][]      uint8ArgsList,
1563         bool[]          buyNoMoreThanAmountBList,
1564         uint8[]         vList,
1565         bytes32[]       rList,
1566         bytes32[]       sList
1567         )
1568         internal
1569         constant
1570         returns (OrderState[])
1571     {
1572         var orders = new OrderState[](ringSize);
1573 
1574         for (uint i = 0; i < ringSize; i++) {
1575             uint j = i.next(ringSize);
1576 
1577             var order = Order(
1578                 addressList[i][0],
1579                 addressList[i][1],
1580                 addressList[j][1],
1581                 uintArgsList[i][0],
1582                 uintArgsList[i][1],
1583                 uintArgsList[i][2],
1584                 uintArgsList[i][3],
1585                 uintArgsList[i][4],
1586                 uintArgsList[i][5],
1587                 buyNoMoreThanAmountBList[i],
1588                 uint8ArgsList[i][0],
1589                 vList[i],
1590                 rList[i],
1591                 sList[i]
1592             );
1593 
1594             bytes32 orderHash = calculateOrderHash(order);
1595 
1596             verifySignature(
1597                 order.owner,
1598                 orderHash,
1599                 order.v,
1600                 order.r,
1601                 order.s
1602             );
1603 
1604             validateOrder(order);
1605 
1606             orders[i] = OrderState(
1607                 order,
1608                 orderHash,
1609                 uint8ArgsList[i][1],  // feeSelection
1610                 Rate(uintArgsList[i][6], order.amountB),
1611                 getSpendable(order.tokenS, order.owner),
1612                 0,   // fillAmountS
1613                 0,   // lrcReward
1614                 0,   // lrcFee
1615                 0,   // splitS
1616                 0    // splitB
1617             );
1618 
1619             ErrorLib.check(
1620                 orders[i].availableAmountS > 0,
1621                 "order spendable amountS is zero"
1622             );
1623         }
1624 
1625         return orders;
1626     }
1627 
1628     /// @dev validate order's parameters are OK.
1629     function validateOrder(Order order)
1630         internal
1631         constant
1632     {
1633         ErrorLib.check(
1634             order.owner != address(0),
1635             "invalid order owner"
1636         );
1637 
1638         ErrorLib.check(
1639             order.tokenS != address(0),
1640             "invalid order tokenS"
1641         );
1642 
1643         ErrorLib.check(
1644             order.tokenB != address(0),
1645             "invalid order tokenB"
1646         );
1647 
1648         ErrorLib.check(
1649             order.amountS > 0,
1650             "invalid order amountS"
1651         );
1652 
1653         ErrorLib.check(
1654             order.amountB > 0,
1655             "invalid order amountB"
1656         );
1657 
1658         ErrorLib.check(
1659             order.timestamp <= block.timestamp,
1660             "order is too early to match"
1661         );
1662 
1663         ErrorLib.check(
1664             order.timestamp > cutoffs[order.owner],
1665             "order is cut off"
1666         );
1667 
1668         ErrorLib.check(
1669             order.ttl > 0,
1670             "order ttl is 0"
1671         );
1672 
1673         ErrorLib.check(
1674             order.timestamp + order.ttl > block.timestamp,
1675             "order is expired"
1676         );
1677 
1678         ErrorLib.check(
1679             order.salt > 0,
1680             "invalid order salt"
1681         );
1682 
1683         ErrorLib.check(
1684             order.marginSplitPercentage <= MARGIN_SPLIT_PERCENTAGE_BASE,
1685             "invalid order marginSplitPercentage"
1686         );
1687     }
1688 
1689     /// @dev Get the Keccak-256 hash of order with specified parameters.
1690     function calculateOrderHash(Order order)
1691         internal
1692         constant
1693         returns (bytes32)
1694     {
1695         return keccak256(
1696             address(this),
1697             order.owner,
1698             order.tokenS,
1699             order.tokenB,
1700             order.amountS,
1701             order.amountB,
1702             order.timestamp,
1703             order.ttl,
1704             order.salt,
1705             order.lrcFee,
1706             order.buyNoMoreThanAmountB,
1707             order.marginSplitPercentage
1708         );
1709     }
1710 
1711     /// @dev Verify signer's signature.
1712     function verifySignature(
1713         address signer,
1714         bytes32 hash,
1715         uint8   v,
1716         bytes32 r,
1717         bytes32 s)
1718         internal
1719         constant
1720     {
1721         address addr = ecrecover(
1722             keccak256("\x19Ethereum Signed Message:\n32", hash),
1723             v,
1724             r,
1725             s
1726         );
1727 
1728         ErrorLib.check(signer == addr, "invalid signature");
1729     }
1730 
1731 }