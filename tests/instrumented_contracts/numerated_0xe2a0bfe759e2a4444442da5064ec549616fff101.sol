1 /*
2 
3     Copyright 2019 The Hydro Protocol Foundation
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9         http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity ^0.4.24;
20 pragma experimental ABIEncoderV2;
21 
22 /// @dev Math operations with safety checks that revert on error
23 library SafeMath {
24 
25     /// @dev Multiplies two numbers, reverts on overflow.
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b, "MUL_ERROR");
33 
34         return c;
35     }
36 
37     /// @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b > 0, "DIVIDING_ERROR");
40         uint256 c = a / b;
41         return c;
42     }
43 
44     /// @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b <= a, "SUB_ERROR");
47         uint256 c = a - b;
48         return c;
49     }
50 
51     /// @dev Adds two numbers, reverts on overflow.
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "ADD_ERROR");
55         return c;
56     }
57 
58     /// @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0, "MOD_ERROR");
61         return a % b;
62     }
63 }
64 
65 /**
66  * EIP712 Ethereum typed structured data hashing and signing
67  */
68 contract EIP712 {
69     string internal constant DOMAIN_NAME = "Hydro Protocol";
70 
71     /**
72      * Hash of the EIP712 Domain Separator Schema
73      */
74     bytes32 public constant EIP712_DOMAIN_TYPEHASH = keccak256(
75         abi.encodePacked("EIP712Domain(string name)")
76     );
77 
78     bytes32 public DOMAIN_SEPARATOR;
79 
80     constructor () public {
81         DOMAIN_SEPARATOR = keccak256(
82             abi.encodePacked(
83                 EIP712_DOMAIN_TYPEHASH,
84                 keccak256(bytes(DOMAIN_NAME))
85             )
86         );
87     }
88 
89     /**
90      * Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
91      *
92      * @param eip712hash The EIP712 hash struct.
93      * @return EIP712 hash applied to this EIP712 Domain.
94      */
95     function hashEIP712Message(bytes32 eip712hash) internal view returns (bytes32) {
96         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, eip712hash));
97     }
98 }
99 
100 contract LibSignature {
101 
102     enum SignatureMethod {
103         EthSign,
104         EIP712
105     }
106 
107     /**
108      * OrderSignature struct contains typical signature data as v, r, and s with the signature
109      * method encoded in as well.
110      */
111     struct OrderSignature {
112         /**
113          * Config contains the following values packed into 32 bytes
114          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
115          * ║                    │ length(bytes)   desc                                      ║
116          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
117          * ║ v                  │ 1               the v parameter of a signature            ║
118          * ║ signatureMethod    │ 1               SignatureMethod enum value                ║
119          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
120          */
121         bytes32 config;
122         bytes32 r;
123         bytes32 s;
124     }
125 
126     /**
127      * Validate a signature given a hash calculated from the order data, the signer, and the
128      * signature data passed in with the order.
129      *
130      * This function will revert the transaction if the signature method is invalid.
131      *
132      * @param hash Hash bytes calculated by taking the EIP712 hash of the passed order data
133      * @param signerAddress The address of the signer
134      * @param signature The signature data passed along with the order to validate against
135      * @return True if the calculated signature matches the order signature data, false otherwise.
136      */
137     function isValidSignature(bytes32 hash, address signerAddress, OrderSignature memory signature)
138         internal
139         pure
140         returns (bool)
141     {
142         uint8 method = uint8(signature.config[1]);
143         address recovered;
144         uint8 v = uint8(signature.config[0]);
145 
146         if (method == uint8(SignatureMethod.EthSign)) {
147             recovered = ecrecover(
148                 keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
149                 v,
150                 signature.r,
151                 signature.s
152             );
153         } else if (method == uint8(SignatureMethod.EIP712)) {
154             recovered = ecrecover(hash, v, signature.r, signature.s);
155         } else {
156             revert("INVALID_SIGN_METHOD");
157         }
158 
159         return signerAddress == recovered;
160     }
161 }
162 
163 contract LibMath {
164     using SafeMath for uint256;
165 
166     /**
167      * Check the amount of precision lost by calculating multiple * (numerator / denominator). To
168      * do this, we check the remainder and make sure it's proportionally less than 0.1%. So we have:
169      *
170      *     ((numerator * multiple) % denominator)     1
171      *     -------------------------------------- < ----
172      *              numerator * multiple            1000
173      *
174      * To avoid further division, we can move the denominators to the other sides and we get:
175      *
176      *     ((numerator * multiple) % denominator) * 1000 < numerator * multiple
177      *
178      * Since we want to return true if there IS a rounding error, we simply flip the sign and our
179      * final equation becomes:
180      *
181      *     ((numerator * multiple) % denominator) * 1000 >= numerator * multiple
182      *
183      * @param numerator The numerator of the proportion
184      * @param denominator The denominator of the proportion
185      * @param multiple The amount we want a proportion of
186      * @return Boolean indicating if there is a rounding error when calculating the proportion
187      */
188     function isRoundingError(uint256 numerator, uint256 denominator, uint256 multiple)
189         internal
190         pure
191         returns (bool)
192     {
193         return numerator.mul(multiple).mod(denominator).mul(1000) >= numerator.mul(multiple);
194     }
195 
196     /// @dev calculate "multiple * (numerator / denominator)", rounded down.
197     /// revert when there is a rounding error.
198     /**
199      * Takes an amount (multiple) and calculates a proportion of it given a numerator/denominator
200      * pair of values. The final value will be rounded down to the nearest integer value.
201      *
202      * This function will revert the transaction if rounding the final value down would lose more
203      * than 0.1% precision.
204      *
205      * @param numerator The numerator of the proportion
206      * @param denominator The denominator of the proportion
207      * @param multiple The amount we want a proportion of
208      * @return The final proportion of multiple rounded down
209      */
210     function getPartialAmountFloor(uint256 numerator, uint256 denominator, uint256 multiple)
211         internal
212         pure
213         returns (uint256)
214     {
215         require(!isRoundingError(numerator, denominator, multiple), "ROUNDING_ERROR");
216         return numerator.mul(multiple).div(denominator);
217     }
218 
219     /**
220      * Returns the smaller integer of the two passed in.
221      *
222      * @param a Unsigned integer
223      * @param b Unsigned integer
224      * @return The smaller of the two integers
225      */
226     function min(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a < b ? a : b;
228     }
229 }
230 
231 contract LibOrder is EIP712, LibSignature, LibMath {
232 
233     uint256 public constant REBATE_RATE_BASE = 100;
234 
235     struct Order {
236         address trader;
237         address relayer;
238         address baseToken;
239         address quoteToken;
240         uint256 baseTokenAmount;
241         uint256 quoteTokenAmount;
242         uint256 gasTokenAmount;
243 
244         /**
245          * Data contains the following values packed into 32 bytes
246          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
247          * ║                    │ length(bytes)   desc                                      ║
248          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
249          * ║ version            │ 1               order version                             ║
250          * ║ side               │ 1               0: buy, 1: sell                           ║
251          * ║ isMarketOrder      │ 1               0: limitOrder, 1: marketOrder             ║
252          * ║ expiredAt          │ 5               order expiration time in seconds          ║
253          * ║ asMakerFeeRate     │ 2               maker fee rate (base 100,000)             ║
254          * ║ asTakerFeeRate     │ 2               taker fee rate (base 100,000)             ║
255          * ║ makerRebateRate    │ 2               rebate rate for maker (base 100)          ║
256          * ║ salt               │ 8               salt                                      ║
257          * ║ isMakerOnly        │ 1               is maker only                             ║
258          * ║                    │ 9               reserved                                  ║
259          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
260          */
261         bytes32 data;
262     }
263 
264     enum OrderStatus {
265         EXPIRED,
266         CANCELLED,
267         FILLABLE,
268         FULLY_FILLED
269     }
270 
271     bytes32 public constant EIP712_ORDER_TYPE = keccak256(
272         abi.encodePacked(
273             "Order(address trader,address relayer,address baseToken,address quoteToken,uint256 baseTokenAmount,uint256 quoteTokenAmount,uint256 gasTokenAmount,bytes32 data)"
274         )
275     );
276 
277     /**
278      * Calculates the Keccak-256 EIP712 hash of the order using the Hydro Protocol domain.
279      *
280      * @param order The order data struct.
281      * @return Fully qualified EIP712 hash of the order in the Hydro Protocol domain.
282      */
283     function getOrderHash(Order memory order) internal view returns (bytes32 orderHash) {
284         orderHash = hashEIP712Message(hashOrder(order));
285         return orderHash;
286     }
287 
288     /**
289      * Calculates the EIP712 hash of the order.
290      *
291      * @param order The order data struct.
292      * @return Hash of the order.
293      */
294     function hashOrder(Order memory order) internal pure returns (bytes32 result) {
295         /**
296          * Calculate the following hash in solidity assembly to save gas.
297          *
298          * keccak256(
299          *     abi.encodePacked(
300          *         EIP712_ORDER_TYPE,
301          *         bytes32(order.trader),
302          *         bytes32(order.relayer),
303          *         bytes32(order.baseToken),
304          *         bytes32(order.quoteToken),
305          *         order.baseTokenAmount,
306          *         order.quoteTokenAmount,
307          *         order.gasTokenAmount,
308          *         order.data
309          *     )
310          * );
311          */
312 
313         bytes32 orderType = EIP712_ORDER_TYPE;
314 
315         assembly {
316             let start := sub(order, 32)
317             let tmp := mload(start)
318 
319             // 288 = (1 + 8) * 32
320             //
321             // [0...32)   bytes: EIP712_ORDER_TYPE
322             // [32...288) bytes: order
323             mstore(start, orderType)
324             result := keccak256(start, 288)
325 
326             mstore(start, tmp)
327         }
328 
329         return result;
330     }
331 
332     /* Functions to extract info from data bytes in Order struct */
333 
334     function getOrderVersion(bytes32 data) internal pure returns (uint256) {
335         return uint256(byte(data));
336     }
337 
338     function getExpiredAtFromOrderData(bytes32 data) internal pure returns (uint256) {
339         return uint256(bytes5(data << (8*3)));
340     }
341 
342     function isSell(bytes32 data) internal pure returns (bool) {
343         return data[1] == 1;
344     }
345 
346     function isMarketOrder(bytes32 data) internal pure returns (bool) {
347         return data[2] == 1;
348     }
349 
350     function isMakerOnly(bytes32 data) internal pure returns (bool) {
351         return data[22] == 1;
352     }
353 
354     function isMarketBuy(bytes32 data) internal pure returns (bool) {
355         return !isSell(data) && isMarketOrder(data);
356     }
357 
358     function getAsMakerFeeRateFromOrderData(bytes32 data) internal pure returns (uint256) {
359         return uint256(bytes2(data << (8*8)));
360     }
361 
362     function getAsTakerFeeRateFromOrderData(bytes32 data) internal pure returns (uint256) {
363         return uint256(bytes2(data << (8*10)));
364     }
365 
366     function getMakerRebateRateFromOrderData(bytes32 data) internal pure returns (uint256) {
367         uint256 makerRebate = uint256(bytes2(data << (8*12)));
368 
369         // make sure makerRebate will never be larger than REBATE_RATE_BASE, which is 100
370         return min(makerRebate, REBATE_RATE_BASE);
371     }
372 }
373 
374 /**
375  * @title LibRelayer provides two distinct features for relayers.
376  *
377  * First, Relayers can opt into or out of the Hydro liquidity incentive system.
378  *
379  * Second, a relayer can register a delegate address.
380  * Delegates can send matching requests on behalf of relayers.
381  * The delegate scheme allows additional possibilities for smart contract interaction.
382  * on behalf of the relayer.
383  */
384 contract LibRelayer {
385 
386     /**
387      * Mapping of relayerAddress => delegateAddress
388      */
389     mapping (address => mapping (address => bool)) public relayerDelegates;
390 
391     /**
392      * Mapping of relayerAddress => whether relayer is opted out of the liquidity incentive system
393      */
394     mapping (address => bool) hasExited;
395 
396     event RelayerApproveDelegate(address indexed relayer, address indexed delegate);
397     event RelayerRevokeDelegate(address indexed relayer, address indexed delegate);
398 
399     event RelayerExit(address indexed relayer);
400     event RelayerJoin(address indexed relayer);
401 
402     /**
403      * Approve an address to match orders on behalf of msg.sender
404      */
405     function approveDelegate(address delegate) external {
406         relayerDelegates[msg.sender][delegate] = true;
407         emit RelayerApproveDelegate(msg.sender, delegate);
408     }
409 
410     /**
411      * Revoke an existing delegate
412      */
413     function revokeDelegate(address delegate) external {
414         relayerDelegates[msg.sender][delegate] = false;
415         emit RelayerRevokeDelegate(msg.sender, delegate);
416     }
417 
418     /**
419      * @return true if msg.sender is allowed to match orders which belong to relayer
420      */
421     function canMatchOrdersFrom(address relayer) public view returns(bool) {
422         return msg.sender == relayer || relayerDelegates[relayer][msg.sender] == true;
423     }
424 
425     /**
426      * Join the Hydro incentive system.
427      */
428     function joinIncentiveSystem() external {
429         delete hasExited[msg.sender];
430         emit RelayerJoin(msg.sender);
431     }
432 
433     /**
434      * Exit the Hydro incentive system.
435      * For relayers that choose to opt-out, the Hydro Protocol
436      * effective becomes a tokenless protocol.
437      */
438     function exitIncentiveSystem() external {
439         hasExited[msg.sender] = true;
440         emit RelayerExit(msg.sender);
441     }
442 
443     /**
444      * @return true if relayer is participating in the Hydro incentive system.
445      */
446     function isParticipant(address relayer) public view returns(bool) {
447         return !hasExited[relayer];
448     }
449 }
450 
451 /// @title Ownable
452 /// @dev The Ownable contract has an owner address, and provides basic authorization control
453 /// functions, this simplifies the implementation of "user permissions".
454 contract LibOwnable {
455     address private _owner;
456 
457     event OwnershipTransferred(
458         address indexed previousOwner,
459         address indexed newOwner
460     );
461 
462     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
463     constructor() internal {
464         _owner = msg.sender;
465         emit OwnershipTransferred(address(0), _owner);
466     }
467 
468     /// @return the address of the owner.
469     function owner() public view returns(address) {
470         return _owner;
471     }
472 
473     /// @dev Throws if called by any account other than the owner.
474     modifier onlyOwner() {
475         require(isOwner(), "NOT_OWNER");
476         _;
477     }
478 
479     /// @return true if `msg.sender` is the owner of the contract.
480     function isOwner() public view returns(bool) {
481         return msg.sender == _owner;
482     }
483 
484     /// @dev Allows the current owner to relinquish control of the contract.
485     /// @notice Renouncing to ownership will leave the contract without an owner.
486     /// It will not be possible to call the functions with the `onlyOwner`
487     /// modifier anymore.
488     function renounceOwnership() public onlyOwner {
489         emit OwnershipTransferred(_owner, address(0));
490         _owner = address(0);
491     }
492 
493     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
494     /// @param newOwner The address to transfer ownership to.
495     function transferOwnership(address newOwner) public onlyOwner {
496         require(newOwner != address(0), "INVALID_OWNER");
497         emit OwnershipTransferred(_owner, newOwner);
498         _owner = newOwner;
499     }
500 }
501 
502 /**
503  * Library to handle fee discount calculation
504  */
505 contract LibDiscount is LibOwnable {
506     using SafeMath for uint256;
507 
508     // The base discounted rate is 100% of the current rate, or no discount.
509     uint256 public constant DISCOUNT_RATE_BASE = 100;
510 
511     address public hotTokenAddress;
512 
513     constructor(address _hotTokenAddress) internal {
514         hotTokenAddress = _hotTokenAddress;
515     }
516 
517     /**
518      * Get the HOT token balance of an address.
519      *
520      * @param owner The address to check.
521      * @return The HOT balance for the owner address.
522      */
523     function getHotBalance(address owner) internal view returns (uint256 result) {
524         address hotToken = hotTokenAddress;
525 
526         // IERC20(hotTokenAddress).balanceOf(owner)
527 
528         /**
529          * We construct calldata for the `balanceOf` ABI.
530          * The layout of this calldata is in the table below.
531          *
532          * ╔════════╤════════╤════════╤═══════════════════╗
533          * ║ Area   │ Offset │ Length │ Contents          ║
534          * ╟────────┼────────┼────────┼───────────────────╢
535          * ║ Header │ 0      │ 4      │ function selector ║
536          * ║ Params │ 4      │ 32     │ owner address     ║
537          * ╚════════╧════════╧════════╧═══════════════════╝
538          */
539         assembly {
540             // Keep these so we can restore stack memory upon completion
541             let tmp1 := mload(0)
542             let tmp2 := mload(4)
543 
544             // keccak256('balanceOf(address)') bitmasked to 4 bytes
545             mstore(0, 0x70a0823100000000000000000000000000000000000000000000000000000000)
546             mstore(4, owner)
547 
548             // No need to check the return value because hotToken is a trustworthy contract
549             result := call(
550                 gas,      // Forward all gas
551                 hotToken, // HOT token deployment address
552                 0,        // Don't send any ETH
553                 0,        // Pointer to start of calldata
554                 36,       // Length of calldata
555                 0,        // Overwrite calldata with output
556                 32        // Expecting uint256 output, the token balance
557             )
558             result := mload(0)
559 
560             // Restore stack memory
561             mstore(0, tmp1)
562             mstore(4, tmp2)
563         }
564     }
565 
566     bytes32 public discountConfig = 0x043c000027106400004e205a000075305000009c404600000000000000000000;
567 
568     /**
569      * Calculate and return the rate at which fees will be charged for an address. The discounted
570      * rate depends on how much HOT token is owned by the user. Values returned will be a percentage
571      * used to calculate how much of the fee is paid, so a return value of 100 means there is 0
572      * discount, and a return value of 70 means a 30% rate reduction.
573      *
574      * The discountConfig is defined as such:
575      * ╔═══════════════════╤════════════════════════════════════════════╗
576      * ║                   │ length(bytes)   desc                       ║
577      * ╟───────────────────┼────────────────────────────────────────────╢
578      * ║ count             │ 1               the count of configs       ║
579      * ║ maxDiscountedRate │ 1               the max discounted rate    ║
580      * ║ config            │ 5 each                                     ║
581      * ╚═══════════════════╧════════════════════════════════════════════╝
582      *
583      * The default discount structure as defined in code would give the following result:
584      *
585      * Fee discount table
586      * ╔════════════════════╤══════════╗
587      * ║     HOT BALANCE    │ DISCOUNT ║
588      * ╠════════════════════╪══════════╣
589      * ║     0 <= x < 10000 │     0%   ║
590      * ╟────────────────────┼──────────╢
591      * ║ 10000 <= x < 20000 │    10%   ║
592      * ╟────────────────────┼──────────╢
593      * ║ 20000 <= x < 30000 │    20%   ║
594      * ╟────────────────────┼──────────╢
595      * ║ 30000 <= x < 40000 │    30%   ║
596      * ╟────────────────────┼──────────╢
597      * ║ 40000 <= x         │    40%   ║
598      * ╚════════════════════╧══════════╝
599      *
600      * Breaking down the bytes of 0x043c000027106400004e205a000075305000009c404600000000000000000000
601      *
602      * 0x  04           3c          0000271064  00004e205a  0000753050  00009c4046  0000000000  0000000000;
603      *     ~~           ~~          ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~
604      *      |            |               |           |           |           |           |           |
605      *    count  maxDiscountedRate       1           2           3           4           5           6
606      *
607      * The first config breaks down as follows:  00002710   64
608      *                                           ~~~~~~~~   ~~
609      *                                               |      |
610      *                                              bar    rate
611      *
612      * Meaning if a user has less than 10000 (0x00002710) HOT, they will pay 100%(0x64) of the
613      * standard fee.
614      *
615      * @param user The user address to calculate a fee discount for.
616      * @return The percentage of the regular fee this user will pay.
617      */
618     function getDiscountedRate(address user) public view returns (uint256 result) {
619         uint256 hotBalance = getHotBalance(user);
620 
621         if (hotBalance == 0) {
622             return DISCOUNT_RATE_BASE;
623         }
624 
625         bytes32 config = discountConfig;
626         uint256 count = uint256(byte(config));
627         uint256 bar;
628 
629         // HOT Token has 18 decimals
630         hotBalance = hotBalance.div(10**18);
631 
632         for (uint256 i = 0; i < count; i++) {
633             bar = uint256(bytes4(config << (2 + i * 5) * 8));
634 
635             if (hotBalance < bar) {
636                 result = uint256(byte(config << (2 + i * 5 + 4) * 8));
637                 break;
638             }
639         }
640 
641         // If we haven't found a rate in the config yet, use the maximum rate.
642         if (result == 0) {
643             result = uint256(config[1]);
644         }
645 
646         // Make sure our discount algorithm never returns a higher rate than the base.
647         require(result <= DISCOUNT_RATE_BASE, "DISCOUNT_ERROR");
648     }
649 
650     /**
651      * Owner can modify discount configuration.
652      *
653      * @param newConfig A data blob representing the new discount config. Details on format above.
654      */
655     function changeDiscountConfig(bytes32 newConfig) external onlyOwner {
656         discountConfig = newConfig;
657     }
658 }
659 
660 contract LibExchangeErrors {
661     string constant INVALID_TRADER = "INVALID_TRADER";
662     string constant INVALID_SENDER = "INVALID_SENDER";
663     // Taker order and maker order can't be matched
664     string constant INVALID_MATCH = "INVALID_MATCH";
665     string constant INVALID_SIDE = "INVALID_SIDE";
666     // Signature validation failed
667     string constant INVALID_ORDER_SIGNATURE = "INVALID_ORDER_SIGNATURE";
668     // Taker order is not valid
669     string constant ORDER_IS_NOT_FILLABLE = "ORDER_IS_NOT_FILLABLE";
670     string constant MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER = "MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER";
671     string constant TRANSFER_FROM_FAILED = "TRANSFER_FROM_FAILED";
672     string constant MAKER_ORDER_OVER_MATCH = "MAKER_ORDER_OVER_MATCH";
673     string constant TAKER_ORDER_OVER_MATCH = "TAKER_ORDER_OVER_MATCH";
674     string constant ORDER_VERSION_NOT_SUPPORTED = "ORDER_VERSION_NOT_SUPPORTED";
675 
676     string constant MAKER_ONLY_ORDER_CANNOT_BE_TAKER = "MAKER_ONLY_ORDER_CANNOT_BE_TAKER";
677 }
678 
679 contract HybridExchange is LibMath, LibOrder, LibRelayer, LibDiscount, LibExchangeErrors {
680     using SafeMath for uint256;
681 
682     uint256 public constant FEE_RATE_BASE = 100000;
683 
684     /* Order v2 data is uncompatible with v1. This contract can only handle v2 order. */
685     uint256 public constant SUPPORTED_ORDER_VERSION = 2;
686 
687     /**
688      * Address of the proxy responsible for asset transfer.
689      */
690     address public proxyAddress;
691 
692     /**
693      * Mapping of orderHash => amount
694      * Generally the amount will be specified in base token units, however in the case of a market
695      * buy order the amount is specified in quote token units.
696      */
697     mapping (bytes32 => uint256) public filled;
698     /**
699      * Mapping of orderHash => whether order has been cancelled.
700      */
701     mapping (bytes32 => bool) public cancelled;
702 
703     event Cancel(bytes32 indexed orderHash);
704 
705     /**
706      * When orders are being matched, they will always contain the exact same base token,
707      * quote token, and relayer. Since excessive call data is very expensive, we choose
708      * to create a stripped down OrderParam struct containing only data that may vary between
709      * Order objects, and separate out the common elements into a set of addresses that will
710      * be shared among all of the OrderParam items. This is meant to eliminate redundancy in
711      * the call data, reducing it's size, and hence saving gas.
712      */
713     struct OrderParam {
714         address trader;
715         uint256 baseTokenAmount;
716         uint256 quoteTokenAmount;
717         uint256 gasTokenAmount;
718         bytes32 data;
719         OrderSignature signature;
720     }
721 
722     /**
723      * Calculated data about an order object.
724      * Generally the filledAmount is specified in base token units, however in the case of a market
725      * buy order the filledAmount is specified in quote token units.
726      */
727     struct OrderInfo {
728         bytes32 orderHash;
729         uint256 filledAmount;
730     }
731 
732     struct OrderAddressSet {
733         address baseToken;
734         address quoteToken;
735         address relayer;
736     }
737 
738     struct MatchResult {
739         address maker;
740         address taker;
741         address buyer;
742         uint256 makerFee;
743         uint256 makerRebate;
744         uint256 takerFee;
745         uint256 makerGasFee;
746         uint256 takerGasFee;
747         uint256 baseTokenFilledAmount;
748         uint256 quoteTokenFilledAmount;
749     }
750 
751 
752     event Match(
753         OrderAddressSet addressSet,
754         MatchResult result
755     );
756 
757     constructor(address _proxyAddress, address hotTokenAddress)
758         LibDiscount(hotTokenAddress)
759         public
760     {
761         proxyAddress = _proxyAddress;
762     }
763 
764     /**
765      * Match taker order to a list of maker orders. Common addresses are passed in
766      * separately as an OrderAddressSet to reduce call size data and save gas.
767      *
768      * @param takerOrderParam A OrderParam object representing the order from the taker.
769      * @param makerOrderParams An array of OrderParam objects representing orders from a list of makers.
770      * @param orderAddressSet An object containing addresses common across each order.
771      */
772     function matchOrders(
773         OrderParam memory takerOrderParam,
774         OrderParam[] memory makerOrderParams,
775         uint256[] memory baseTokenFilledAmounts,
776         OrderAddressSet memory orderAddressSet
777     ) public {
778         require(canMatchOrdersFrom(orderAddressSet.relayer), INVALID_SENDER);
779         require(!isMakerOnly(takerOrderParam.data), MAKER_ONLY_ORDER_CANNOT_BE_TAKER);
780 
781         bool isParticipantRelayer = isParticipant(orderAddressSet.relayer);
782         uint256 takerFeeRate = getTakerFeeRate(takerOrderParam, isParticipantRelayer);
783         OrderInfo memory takerOrderInfo = getOrderInfo(takerOrderParam, orderAddressSet);
784 
785         // Calculate which orders match for settlement.
786         MatchResult[] memory results = new MatchResult[](makerOrderParams.length);
787 
788         for (uint256 i = 0; i < makerOrderParams.length; i++) {
789             require(!isMarketOrder(makerOrderParams[i].data), MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER);
790             require(isSell(takerOrderParam.data) != isSell(makerOrderParams[i].data), INVALID_SIDE);
791             validatePrice(takerOrderParam, makerOrderParams[i]);
792 
793             OrderInfo memory makerOrderInfo = getOrderInfo(makerOrderParams[i], orderAddressSet);
794 
795             results[i] = getMatchResult(
796                 takerOrderParam,
797                 takerOrderInfo,
798                 makerOrderParams[i],
799                 makerOrderInfo,
800                 baseTokenFilledAmounts[i],
801                 takerFeeRate,
802                 isParticipantRelayer
803             );
804 
805             // Update amount filled for this maker order.
806             filled[makerOrderInfo.orderHash] = makerOrderInfo.filledAmount;
807         }
808 
809         // Update amount filled for this taker order.
810         filled[takerOrderInfo.orderHash] = takerOrderInfo.filledAmount;
811 
812         settleResults(results, takerOrderParam, orderAddressSet);
813     }
814 
815     /**
816      * Cancels an order, preventing it from being matched. In practice, matching mode relayers will
817      * generally handle cancellation off chain by removing the order from their system, however if
818      * the trader wants to ensure the order never goes through, or they no longer trust the relayer,
819      * this function may be called to block it from ever matching at the contract level.
820      *
821      * Emits a Cancel event on success.
822      *
823      * @param order The order to be cancelled.
824      */
825     function cancelOrder(Order memory order) public {
826         require(order.trader == msg.sender, INVALID_TRADER);
827 
828         bytes32 orderHash = getOrderHash(order);
829         cancelled[orderHash] = true;
830 
831         emit Cancel(orderHash);
832     }
833 
834     /**
835      * Calculates current state of the order. Will revert transaction if this order is not
836      * fillable for any reason, or if the order signature is invalid.
837      *
838      * @param orderParam The OrderParam object containing Order data.
839      * @param orderAddressSet An object containing addresses common across each order.
840      * @return An OrderInfo object containing the hash and current amount filled
841      */
842     function getOrderInfo(OrderParam memory orderParam, OrderAddressSet memory orderAddressSet)
843         internal
844         view
845         returns (OrderInfo memory orderInfo)
846     {
847         require(getOrderVersion(orderParam.data) == SUPPORTED_ORDER_VERSION, ORDER_VERSION_NOT_SUPPORTED);
848 
849         Order memory order = getOrderFromOrderParam(orderParam, orderAddressSet);
850         orderInfo.orderHash = getOrderHash(order);
851         orderInfo.filledAmount = filled[orderInfo.orderHash];
852         uint8 status = uint8(OrderStatus.FILLABLE);
853 
854         if (!isMarketBuy(order.data) && orderInfo.filledAmount >= order.baseTokenAmount) {
855             status = uint8(OrderStatus.FULLY_FILLED);
856         } else if (isMarketBuy(order.data) && orderInfo.filledAmount >= order.quoteTokenAmount) {
857             status = uint8(OrderStatus.FULLY_FILLED);
858         } else if (block.timestamp >= getExpiredAtFromOrderData(order.data)) {
859             status = uint8(OrderStatus.EXPIRED);
860         } else if (cancelled[orderInfo.orderHash]) {
861             status = uint8(OrderStatus.CANCELLED);
862         }
863 
864         require(status == uint8(OrderStatus.FILLABLE), ORDER_IS_NOT_FILLABLE);
865         require(
866             isValidSignature(orderInfo.orderHash, orderParam.trader, orderParam.signature),
867             INVALID_ORDER_SIGNATURE
868         );
869 
870         return orderInfo;
871     }
872 
873     /**
874      * Reconstruct an Order object from the given OrderParam and OrderAddressSet objects.
875      *
876      * @param orderParam The OrderParam object containing the Order data.
877      * @param orderAddressSet An object containing addresses common across each order.
878      * @return The reconstructed Order object.
879      */
880     function getOrderFromOrderParam(OrderParam memory orderParam, OrderAddressSet memory orderAddressSet)
881         internal
882         pure
883         returns (Order memory order)
884     {
885         order.trader = orderParam.trader;
886         order.baseTokenAmount = orderParam.baseTokenAmount;
887         order.quoteTokenAmount = orderParam.quoteTokenAmount;
888         order.gasTokenAmount = orderParam.gasTokenAmount;
889         order.data = orderParam.data;
890         order.baseToken = orderAddressSet.baseToken;
891         order.quoteToken = orderAddressSet.quoteToken;
892         order.relayer = orderAddressSet.relayer;
893     }
894 
895     /**
896      * Validates that the maker and taker orders can be matched based on the listed prices.
897      *
898      * If the taker submitted a sell order, the matching maker order must have a price greater than
899      * or equal to the price the taker is willing to sell for.
900      *
901      * Since the price of an order is computed by order.quoteTokenAmount / order.baseTokenAmount
902      * we can establish the following formula:
903      *
904      *    takerOrder.quoteTokenAmount        makerOrder.quoteTokenAmount
905      *   -----------------------------  <=  -----------------------------
906      *     takerOrder.baseTokenAmount        makerOrder.baseTokenAmount
907      *
908      * To avoid precision loss from division, we modify the formula to avoid division entirely.
909      * In shorthand, this becomes:
910      *
911      *   takerOrder.quote * makerOrder.base <= takerOrder.base * makerOrder.quote
912      *
913      * We can apply this same process to buy orders - if the taker submitted a buy order then
914      * the matching maker order must have a price less than or equal to the price the taker is
915      * willing to pay. This means we can use the same result as above, but simply flip the
916      * sign of the comparison operator.
917      *
918      * The function will revert the transaction if the orders cannot be matched.
919      *
920      * @param takerOrderParam The OrderParam object representing the taker's order data
921      * @param makerOrderParam The OrderParam object representing the maker's order data
922      */
923     function validatePrice(OrderParam memory takerOrderParam, OrderParam memory makerOrderParam)
924         internal
925         pure
926     {
927         uint256 left = takerOrderParam.quoteTokenAmount.mul(makerOrderParam.baseTokenAmount);
928         uint256 right = takerOrderParam.baseTokenAmount.mul(makerOrderParam.quoteTokenAmount);
929         require(isSell(takerOrderParam.data) ? left <= right : left >= right, INVALID_MATCH);
930     }
931 
932     /**
933      * Construct a MatchResult from matching taker and maker order data, which will be used when
934      * settling the orders and transferring token.
935      *
936      * @param takerOrderParam The OrderParam object representing the taker's order data
937      * @param takerOrderInfo The OrderInfo object representing the current taker order state
938      * @param makerOrderParam The OrderParam object representing the maker's order data
939      * @param makerOrderInfo The OrderInfo object representing the current maker order state
940      * @param takerFeeRate The rate used to calculate the fee charged to the taker
941      * @param isParticipantRelayer Whether this relayer is participating in hot discount
942      * @return MatchResult object containing data that will be used during order settlement.
943      */
944     function getMatchResult(
945         OrderParam memory takerOrderParam,
946         OrderInfo memory takerOrderInfo,
947         OrderParam memory makerOrderParam,
948         OrderInfo memory makerOrderInfo,
949         uint256 baseTokenFilledAmount,
950         uint256 takerFeeRate,
951         bool isParticipantRelayer
952     )
953         internal
954         view
955         returns (MatchResult memory result)
956     {
957         result.baseTokenFilledAmount = baseTokenFilledAmount;
958         result.quoteTokenFilledAmount = convertBaseToQuote(makerOrderParam, baseTokenFilledAmount);
959 
960         // Each order only pays gas once, so only pay gas when nothing has been filled yet.
961         if (takerOrderInfo.filledAmount == 0) {
962             result.takerGasFee = takerOrderParam.gasTokenAmount;
963         }
964 
965         if (makerOrderInfo.filledAmount == 0) {
966             result.makerGasFee = makerOrderParam.gasTokenAmount;
967         }
968 
969         if(!isMarketBuy(takerOrderParam.data)) {
970             takerOrderInfo.filledAmount = takerOrderInfo.filledAmount.add(result.baseTokenFilledAmount);
971             require(takerOrderInfo.filledAmount <= takerOrderParam.baseTokenAmount, TAKER_ORDER_OVER_MATCH);
972         } else {
973             takerOrderInfo.filledAmount = takerOrderInfo.filledAmount.add(result.quoteTokenFilledAmount);
974             require(takerOrderInfo.filledAmount <= takerOrderParam.quoteTokenAmount, TAKER_ORDER_OVER_MATCH);
975         }
976 
977         makerOrderInfo.filledAmount = makerOrderInfo.filledAmount.add(result.baseTokenFilledAmount);
978         require(makerOrderInfo.filledAmount <= makerOrderParam.baseTokenAmount, MAKER_ORDER_OVER_MATCH);
979 
980         result.maker = makerOrderParam.trader;
981         result.taker = takerOrderParam.trader;
982 
983         if(isSell(takerOrderParam.data)) {
984             result.buyer = result.maker;
985         } else {
986             result.buyer = result.taker;
987         }
988 
989         uint256 rebateRate = getMakerRebateRateFromOrderData(makerOrderParam.data);
990 
991         if (rebateRate > 0) {
992             // If the rebate rate is not zero, maker pays no fees.
993             result.makerFee = 0;
994 
995             // RebateRate will never exceed REBATE_RATE_BASE, so rebateFee will never exceed the fees paid by the taker.
996             result.makerRebate = result.quoteTokenFilledAmount.mul(takerFeeRate).mul(rebateRate).div(
997                 FEE_RATE_BASE.mul(DISCOUNT_RATE_BASE).mul(REBATE_RATE_BASE)
998             );
999         } else {
1000             uint256 makerRawFeeRate = getAsMakerFeeRateFromOrderData(makerOrderParam.data);
1001             result.makerRebate = 0;
1002 
1003             // maker fee will be reduced, but still >= 0
1004             uint256 makerFeeRate = getFinalFeeRate(
1005                 makerOrderParam.trader,
1006                 makerRawFeeRate,
1007                 isParticipantRelayer
1008             );
1009 
1010             result.makerFee = result.quoteTokenFilledAmount.mul(makerFeeRate).div(
1011                 FEE_RATE_BASE.mul(DISCOUNT_RATE_BASE)
1012             );
1013         }
1014 
1015         result.takerFee = result.quoteTokenFilledAmount.mul(takerFeeRate).div(
1016             FEE_RATE_BASE.mul(DISCOUNT_RATE_BASE)
1017         );
1018     }
1019 
1020     /**
1021      * Get the rate used to calculate the taker fee.
1022      *
1023      * @param orderParam The OrderParam object representing the taker order data.
1024      * @param isParticipantRelayer Whether this relayer is participating in hot discount.
1025      * @return The final potentially discounted rate to use for the taker fee.
1026      */
1027     function getTakerFeeRate(OrderParam memory orderParam, bool isParticipantRelayer)
1028         internal
1029         view
1030         returns(uint256)
1031     {
1032         uint256 rawRate = getAsTakerFeeRateFromOrderData(orderParam.data);
1033         return getFinalFeeRate(orderParam.trader, rawRate, isParticipantRelayer);
1034     }
1035 
1036     /**
1037      * Take a fee rate and calculate the potentially discounted rate for this trader based on
1038      * HOT token ownership.
1039      *
1040      * @param trader The address of the trader who made the order.
1041      * @param rate The raw rate which we will discount if needed.
1042      * @param isParticipantRelayer Whether this relayer is participating in hot discount.
1043      * @return The final potentially discounted rate.
1044      */
1045     function getFinalFeeRate(address trader, uint256 rate, bool isParticipantRelayer)
1046         internal
1047         view
1048         returns(uint256)
1049     {
1050         if (isParticipantRelayer) {
1051             return rate.mul(getDiscountedRate(trader));
1052         } else {
1053             return rate.mul(DISCOUNT_RATE_BASE);
1054         }
1055     }
1056 
1057     /**
1058      * Take an amount and convert it from base token units to quote token units based on the price
1059      * in the order param.
1060      *
1061      * @param orderParam The OrderParam object containing the Order data.
1062      * @param amount An amount of base token.
1063      * @return The converted amount in quote token units.
1064      */
1065     function convertBaseToQuote(OrderParam memory orderParam, uint256 amount)
1066         internal
1067         pure
1068         returns (uint256)
1069     {
1070         return getPartialAmountFloor(
1071             orderParam.quoteTokenAmount,
1072             orderParam.baseTokenAmount,
1073             amount
1074         );
1075     }
1076 
1077     /**
1078      * Take an amount and convert it from quote token units to base token units based on the price
1079      * in the order param.
1080      *
1081      * @param orderParam The OrderParam object containing the Order data.
1082      * @param amount An amount of quote token.
1083      * @return The converted amount in base token units.
1084      */
1085     function convertQuoteToBase(OrderParam memory orderParam, uint256 amount)
1086         internal
1087         pure
1088         returns (uint256)
1089     {
1090         return getPartialAmountFloor(
1091             orderParam.baseTokenAmount,
1092             orderParam.quoteTokenAmount,
1093             amount
1094         );
1095     }
1096 
1097     /**
1098      * Take a list of matches and settle them with the taker order, transferring tokens all tokens
1099      * and paying all fees necessary to complete the transaction.
1100      *
1101      * @param results List of MatchResult objects representing each individual trade to settle.
1102      * @param takerOrderParam The OrderParam object representing the taker order data.
1103      * @param orderAddressSet An object containing addresses common across each order.
1104      */
1105     function settleResults(
1106         MatchResult[] memory results,
1107         OrderParam memory takerOrderParam,
1108         OrderAddressSet memory orderAddressSet
1109     )
1110         internal
1111     {
1112         if (isSell(takerOrderParam.data)) {
1113             settleTakerSell(results, orderAddressSet);
1114         } else {
1115             settleTakerBuy(results, orderAddressSet);
1116         }
1117     }
1118 
1119     /**
1120      * Settles a sell order given a list of MatchResult objects. A naive approach would be to take
1121      * each result, have the taker and maker transfer the appropriate tokens, and then have them
1122      * each send the appropriate fees to the relayer, meaning that for n makers there would be 4n
1123      * transactions. Additionally the taker would have to have an allowance set for the quote token
1124      * in order to pay the fees to the relayer.
1125      *
1126      * Instead we do the following:
1127      *  - Taker transfers the required base token to each maker
1128      *  - Each maker sends an amount of quote token to the relayer equal to:
1129      *    [Amount owed to taker] + [Maker fee] + [Maker gas cost] - [Maker rebate amount]
1130      *  - The relayer will then take all of this quote token and in a single batch transaction
1131      *    send the appropriate amount to the taker, equal to:
1132      *    [Total amount owed to taker] - [All taker fees] - [All taker gas costs]
1133      *
1134      * Thus in the end the taker will have the full amount of quote token, sans the fee and cost of
1135      * their share of gas. Each maker will have their share of base token, sans the fee and cost of
1136      * their share of gas, and will keep their rebate in quote token. The relayer will end up with
1137      * the fees from the taker and each maker (sans rebate), and the gas costs will pay for the
1138      * transactions. In this scenario, with n makers there will be 2n + 1 transactions, which will
1139      * be a significant gas savings over the original method.
1140      *
1141      * @param results A list of MatchResult objects representing each individual trade to settle.
1142      * @param orderAddressSet An object containing addresses common across each order.
1143      */
1144     function settleTakerSell(MatchResult[] memory results, OrderAddressSet memory orderAddressSet) internal {
1145         uint256 totalTakerQuoteTokenFilledAmount = 0;
1146 
1147         for (uint256 i = 0; i < results.length; i++) {
1148             transferFrom(
1149                 orderAddressSet.baseToken,
1150                 results[i].taker,
1151                 results[i].maker,
1152                 results[i].baseTokenFilledAmount
1153             );
1154 
1155             transferFrom(
1156                 orderAddressSet.quoteToken,
1157                 results[i].maker,
1158                 orderAddressSet.relayer,
1159                 results[i].quoteTokenFilledAmount.
1160                     add(results[i].makerFee).
1161                     add(results[i].makerGasFee).
1162                     sub(results[i].makerRebate)
1163             );
1164 
1165             totalTakerQuoteTokenFilledAmount = totalTakerQuoteTokenFilledAmount.add(
1166                 results[i].quoteTokenFilledAmount.sub(results[i].takerFee)
1167             );
1168 
1169             emitMatchEvent(results[i], orderAddressSet);
1170         }
1171 
1172         transferFrom(
1173             orderAddressSet.quoteToken,
1174             orderAddressSet.relayer,
1175             results[0].taker,
1176             totalTakerQuoteTokenFilledAmount.sub(results[0].takerGasFee)
1177         );
1178     }
1179 
1180     /**
1181      * Settles a buy order given a list of MatchResult objects. A naive approach would be to take
1182      * each result, have the taker and maker transfer the appropriate tokens, and then have them
1183      * each send the appropriate fees to the relayer, meaning that for n makers there would be 4n
1184      * transactions. Additionally each maker would have to have an allowance set for the quote token
1185      * in order to pay the fees to the relayer.
1186      *
1187      * Instead we do the following:
1188      *  - Each maker transfers base tokens to the taker
1189      *  - The taker sends an amount of quote tokens to each maker equal to:
1190      *    [Amount owed to maker] + [Maker rebate amount] - [Maker fee] - [Maker gas cost]
1191      *  - Since the taker saved all the maker fees and gas costs, it can then send them as a single
1192      *    batch transaction to the relayer, equal to:
1193      *    [All maker and taker fees] + [All maker and taker gas costs] - [All maker rebates]
1194      *
1195      * Thus in the end the taker will have the full amount of base token, sans the fee and cost of
1196      * their share of gas. Each maker will have their share of quote token, including their rebate,
1197      * but sans the fee and cost of their share of gas. The relayer will end up with the fees from
1198      * the taker and each maker (sans rebates), and the gas costs will pay for the transactions. In
1199      * this scenario, with n makers there will be 2n + 1 transactions, which will be a significant
1200      * gas savings over the original method.
1201      *
1202      * @param results A list of MatchResult objects representing each individual trade to settle.
1203      * @param orderAddressSet An object containing addresses common across each order.
1204      */
1205     function settleTakerBuy(MatchResult[] memory results, OrderAddressSet memory orderAddressSet) internal {
1206         uint256 totalFee = 0;
1207 
1208         for (uint256 i = 0; i < results.length; i++) {
1209             transferFrom(
1210                 orderAddressSet.baseToken,
1211                 results[i].maker,
1212                 results[i].taker,
1213                 results[i].baseTokenFilledAmount
1214             );
1215 
1216             transferFrom(
1217                 orderAddressSet.quoteToken,
1218                 results[i].taker,
1219                 results[i].maker,
1220                 results[i].quoteTokenFilledAmount.
1221                     sub(results[i].makerFee).
1222                     sub(results[i].makerGasFee).
1223                     add(results[i].makerRebate)
1224             );
1225 
1226             totalFee = totalFee.
1227                 add(results[i].takerFee).
1228                 add(results[i].makerFee).
1229                 add(results[i].makerGasFee).
1230                 add(results[i].takerGasFee).
1231                 sub(results[i].makerRebate);
1232 
1233             emitMatchEvent(results[i], orderAddressSet);
1234         }
1235 
1236         transferFrom(
1237             orderAddressSet.quoteToken,
1238             results[0].taker,
1239             orderAddressSet.relayer,
1240             totalFee
1241         );
1242     }
1243 
1244     /**
1245      * A helper function to call the transferFrom function in Proxy.sol with solidity assembly.
1246      * Copying the data in order to make an external call can be expensive, but performing the
1247      * operations in assembly seems to reduce gas cost.
1248      *
1249      * The function will revert the transaction if the transfer fails.
1250      *
1251      * @param token The address of the ERC20 token we will be transferring, 0 for ETH.
1252      * @param from The address we will be transferring from.
1253      * @param to The address we will be transferring to.
1254      * @param value The amount of token we will be transferring.
1255      */
1256     function transferFrom(address token, address from, address to, uint256 value) internal {
1257         if (value == 0) {
1258             return;
1259         }
1260 
1261         address proxy = proxyAddress;
1262         uint256 result;
1263 
1264         /**
1265          * We construct calldata for the `Proxy.transferFrom` ABI.
1266          * The layout of this calldata is in the table below.
1267          *
1268          * ╔════════╤════════╤════════╤═══════════════════╗
1269          * ║ Area   │ Offset │ Length │ Contents          ║
1270          * ╟────────┼────────┼────────┼───────────────────╢
1271          * ║ Header │ 0      │ 4      │ function selector ║
1272          * ║ Params │ 4      │ 32     │ token address     ║
1273          * ║        │ 36     │ 32     │ from address      ║
1274          * ║        │ 68     │ 32     │ to address        ║
1275          * ║        │ 100    │ 32     │ amount of token   ║
1276          * ╚════════╧════════╧════════╧═══════════════════╝
1277          */
1278         assembly {
1279             // Keep these so we can restore stack memory upon completion
1280             let tmp1 := mload(0)
1281             let tmp2 := mload(4)
1282             let tmp3 := mload(36)
1283             let tmp4 := mload(68)
1284             let tmp5 := mload(100)
1285 
1286             // keccak256('transferFrom(address,address,address,uint256)') bitmasked to 4 bytes
1287             mstore(0, 0x15dacbea00000000000000000000000000000000000000000000000000000000)
1288             mstore(4, token)
1289             mstore(36, from)
1290             mstore(68, to)
1291             mstore(100, value)
1292 
1293             // Call Proxy contract transferFrom function using constructed calldata
1294             result := call(
1295                 gas,   // Forward all gas
1296                 proxy, // Proxy.sol deployment address
1297                 0,     // Don't send any ETH
1298                 0,     // Pointer to start of calldata
1299                 132,   // Length of calldata
1300                 0,     // Output location
1301                 0      // We don't expect any output
1302             )
1303 
1304             // Restore stack memory
1305             mstore(0, tmp1)
1306             mstore(4, tmp2)
1307             mstore(36, tmp3)
1308             mstore(68, tmp4)
1309             mstore(100, tmp5)
1310         }
1311 
1312         if (result == 0) {
1313             revert(TRANSFER_FROM_FAILED);
1314         }
1315     }
1316 
1317     function emitMatchEvent(MatchResult memory result, OrderAddressSet memory orderAddressSet) internal {
1318         emit Match(
1319             orderAddressSet, result
1320         );
1321     }
1322 }