1 /*
2 
3     Copyright 2018 The Hydro Protocol Foundation
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
22 /// @title Ownable
23 /// @dev The Ownable contract has an owner address, and provides basic authorization control
24 /// functions, this simplifies the implementation of "user permissions".
25 contract LibOwnable {
26     address private _owner;
27 
28     event OwnershipTransferred(
29         address indexed previousOwner,
30         address indexed newOwner
31     );
32 
33     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
34     constructor() internal {
35         _owner = msg.sender;
36         emit OwnershipTransferred(address(0), _owner);
37     }
38 
39     /// @return the address of the owner.
40     function owner() public view returns(address) {
41         return _owner;
42     }
43 
44     /// @dev Throws if called by any account other than the owner.
45     modifier onlyOwner() {
46         require(isOwner(), "NOT_OWNER");
47         _;
48     }
49 
50     /// @return true if `msg.sender` is the owner of the contract.
51     function isOwner() public view returns(bool) {
52         return msg.sender == _owner;
53     }
54 
55     /// @dev Allows the current owner to relinquish control of the contract.
56     /// @notice Renouncing to ownership will leave the contract without an owner.
57     /// It will not be possible to call the functions with the `onlyOwner`
58     /// modifier anymore.
59     function renounceOwnership() public onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63 
64     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
65     /// @param newOwner The address to transfer ownership to.
66     function transferOwnership(address newOwner) public onlyOwner {
67         require(newOwner != address(0), "INVALID_OWNER");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 /// @dev Math operations with safety checks that revert on error
74 library SafeMath {
75 
76     /// @dev Multiplies two numbers, reverts on overflow.
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "MUL_ERROR");
84 
85         return c;
86     }
87 
88     /// @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b > 0, "DIVIDING_ERROR");
91         uint256 c = a / b;
92         return c;
93     }
94 
95     /// @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b <= a, "SUB_ERROR");
98         uint256 c = a - b;
99         return c;
100     }
101 
102     /// @dev Adds two numbers, reverts on overflow.
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "ADD_ERROR");
106         return c;
107     }
108 
109     /// @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b != 0, "MOD_ERROR");
112         return a % b;
113     }
114 }
115 
116 /**
117  * EIP712 Ethereum typed structured data hashing and signing
118  */
119 contract EIP712 {
120     string internal constant DOMAIN_NAME = "Hydro Protocol";
121     string internal constant DOMAIN_VERSION = "1";
122 
123     /**
124      * Hash of the EIP712 Domain Separator Schema
125      */
126     bytes32 public constant EIP712_DOMAIN_TYPEHASH = keccak256(
127         abi.encodePacked("EIP712Domain(string name,string version,address verifyingContract)")
128     );
129 
130     bytes32 public DOMAIN_SEPARATOR;
131 
132     constructor () public {
133         DOMAIN_SEPARATOR = keccak256(
134             abi.encodePacked(
135                 EIP712_DOMAIN_TYPEHASH,
136                 keccak256(bytes(DOMAIN_NAME)),
137                 keccak256(bytes(DOMAIN_VERSION)),
138                 bytes32(address(this))
139             )
140         );
141     }
142 
143     /**
144      * Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
145      *
146      * @param eip712hash The EIP712 hash struct.
147      * @return EIP712 hash applied to this EIP712 Domain.
148      */
149     function hashEIP712Message(bytes32 eip712hash) internal view returns (bytes32) {
150         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, eip712hash));
151     }
152 }
153 
154 contract LibSignature {
155 
156     enum SignatureMethod {
157         EthSign,
158         EIP712
159     }
160 
161     /**
162      * OrderSignature struct contains typical signature data as v, r, and s with the signature
163      * method encoded in as well.
164      */
165     struct OrderSignature {
166         /**
167          * Config contains the following values packed into 32 bytes
168          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
169          * ║                    │ length(bytes)   desc                                      ║
170          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
171          * ║ v                  │ 1               the v parameter of a signature            ║
172          * ║ signatureMethod    │ 1               SignatureMethod enum value                ║
173          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
174          */
175         bytes32 config;
176         bytes32 r;
177         bytes32 s;
178     }
179     
180     /**
181      * Validate a signature given a hash calculated from the order data, the signer, and the
182      * signature data passed in with the order.
183      *
184      * This function will revert the transaction if the signature method is invalid.
185      *
186      * @param hash Hash bytes calculated by taking the EIP712 hash of the passed order data
187      * @param signerAddress The address of the signer
188      * @param signature The signature data passed along with the order to validate against
189      * @return True if the calculated signature matches the order signature data, false otherwise.
190      */
191     function isValidSignature(bytes32 hash, address signerAddress, OrderSignature memory signature)
192         internal
193         pure
194         returns (bool)
195     {
196         uint8 method = uint8(signature.config[1]);
197         address recovered;
198         uint8 v = uint8(signature.config[0]);
199 
200         if (method == uint8(SignatureMethod.EthSign)) {
201             recovered = ecrecover(
202                 keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
203                 v,
204                 signature.r,
205                 signature.s
206             );
207         } else if (method == uint8(SignatureMethod.EIP712)) {
208             recovered = ecrecover(hash, v, signature.r, signature.s);
209         } else {
210             revert("INVALID_SIGN_METHOD");
211         }
212 
213         return signerAddress == recovered;
214     }
215 }
216 
217 contract LibOrder is EIP712, LibSignature {
218     struct Order {
219         address trader;
220         address relayer;
221         address baseToken;
222         address quoteToken;
223         uint256 baseTokenAmount;
224         uint256 quoteTokenAmount;
225         uint256 gasTokenAmount;
226 
227         /**
228          * Data contains the following values packed into 32 bytes
229          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
230          * ║                    │ length(bytes)   desc                                      ║
231          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
232          * ║ version            │ 1               order version                             ║
233          * ║ side               │ 1               0: buy, 1: sell                           ║
234          * ║ isMarketOrder      │ 1               0: limitOrder, 1: marketOrder             ║
235          * ║ expiredAt          │ 5               order expiration time in seconds          ║
236          * ║ asMakerFeeRate     │ 2               maker fee rate (base 100,000)             ║
237          * ║ asTakerFeeRate     │ 2               taker fee rate (base 100,000)             ║
238          * ║ makerRebateRate    │ 2               rebate rate for maker (base 100,000)      ║
239          * ║ salt               │ 8               salt                                      ║
240          * ║                    │ 10              reserved                                  ║
241          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
242          */
243         bytes32 data;
244     }
245 
246     enum OrderStatus {
247         EXPIRED,
248         CANCELLED,
249         FILLABLE,
250         FULLY_FILLED
251     }
252 
253     bytes32 public constant EIP712_ORDER_TYPE = keccak256(
254         abi.encodePacked(
255             "Order(address trader,address relayer,address baseToken,address quoteToken,uint256 baseTokenAmount,uint256 quoteTokenAmount,uint256 gasTokenAmount,bytes32 data)"
256         )
257     );
258 
259     /**
260      * Calculates the Keccak-256 EIP712 hash of the order using the Hydro Protocol domain.
261      *
262      * @param order The order data struct.
263      * @return Fully qualified EIP712 hash of the order in the Hydro Protocol domain.
264      */
265     function getOrderHash(Order memory order) internal view returns (bytes32 orderHash) {
266         orderHash = hashEIP712Message(hashOrder(order));
267         return orderHash;
268     }
269 
270     /**
271      * Calculates the EIP712 hash of the order.
272      *
273      * @param order The order data struct.
274      * @return Hash of the order.
275      */
276     function hashOrder(Order memory order) internal pure returns (bytes32 result) {
277         /**
278          * Calculate the following hash in solidity assembly to save gas.
279          *
280          * keccak256(
281          *     abi.encodePacked(
282          *         EIP712_ORDER_TYPE,
283          *         bytes32(order.trader),
284          *         bytes32(order.relayer),
285          *         bytes32(order.baseToken),
286          *         bytes32(order.quoteToken),
287          *         order.baseTokenAmount,
288          *         order.quoteTokenAmount,
289          *         order.gasTokenAmount,
290          *         order.data
291          *     )
292          * );
293          */
294 
295         bytes32 orderType = EIP712_ORDER_TYPE;
296 
297         assembly {
298             let start := sub(order, 32)
299             let tmp := mload(start)
300 
301             // 288 = (1 + 8) * 32
302             //
303             // [0...32)   bytes: EIP712_ORDER_TYPE
304             // [32...288) bytes: order
305             mstore(start, orderType)
306             result := keccak256(start, 288)
307 
308             mstore(start, tmp)
309         }
310 
311         return result;
312     }
313 
314     /* Functions to extract info from data bytes in Order struct */
315 
316     function getExpiredAtFromOrderData(bytes32 data) internal pure returns (uint256) {
317         return uint256(bytes5(data << (8*3)));
318     }
319 
320     function isSell(bytes32 data) internal pure returns (bool) {
321         return data[1] == 1;
322     }
323 
324     function isMarketOrder(bytes32 data) internal pure returns (bool) {
325         return data[2] == 1;
326     }
327 
328     function isMarketBuy(bytes32 data) internal pure returns (bool) {
329         return !isSell(data) && isMarketOrder(data);
330     }
331 
332     function getAsMakerFeeRateFromOrderData(bytes32 data) internal pure returns (uint256) {
333         return uint256(bytes2(data << (8*8)));
334     }
335 
336     function getAsTakerFeeRateFromOrderData(bytes32 data) internal pure returns (uint256) {
337         return uint256(bytes2(data << (8*10)));
338     }
339 
340     function getMakerRebateRateFromOrderData(bytes32 data) internal pure returns (uint256) {
341         return uint256(bytes2(data << (8*12)));
342     }
343 }
344 
345 contract LibMath {
346     using SafeMath for uint256;
347 
348     /**
349      * Check the amount of precision lost by calculating multiple * (numerator / denominator). To
350      * do this, we check the remainder and make sure it's proportionally less than 0.1%. So we have:
351      *
352      *     ((numerator * multiple) % denominator)     1
353      *     -------------------------------------- < ----
354      *              numerator * multiple            1000
355      *
356      * To avoid further division, we can move the denominators to the other sides and we get:
357      *
358      *     ((numerator * multiple) % denominator) * 1000 < numerator * multiple
359      *
360      * Since we want to return true if there IS a rounding error, we simply flip the sign and our
361      * final equation becomes:
362      *
363      *     ((numerator * multiple) % denominator) * 1000 >= numerator * multiple
364      *
365      * @param numerator The numerator of the proportion
366      * @param denominator The denominator of the proportion
367      * @param multiple The amount we want a proportion of
368      * @return Boolean indicating if there is a rounding error when calculating the proportion
369      */
370     function isRoundingError(uint256 numerator, uint256 denominator, uint256 multiple)
371         internal
372         pure
373         returns (bool)
374     {
375         return numerator.mul(multiple).mod(denominator).mul(1000) >= numerator.mul(multiple);
376     }
377 
378     /// @dev calculate "multiple * (numerator / denominator)", rounded down.
379     /// revert when there is a rounding error.
380     /**
381      * Takes an amount (multiple) and calculates a proportion of it given a numerator/denominator
382      * pair of values. The final value will be rounded down to the nearest integer value.
383      *
384      * This function will revert the transaction if rounding the final value down would lose more
385      * than 0.1% precision.
386      *
387      * @param numerator The numerator of the proportion
388      * @param denominator The denominator of the proportion
389      * @param multiple The amount we want a proportion of
390      * @return The final proportion of multiple rounded down
391      */
392     function getPartialAmountFloor(uint256 numerator, uint256 denominator, uint256 multiple)
393         internal
394         pure
395         returns (uint256)
396     {
397         require(!isRoundingError(numerator, denominator, multiple), "ROUNDING_ERROR");
398         return numerator.mul(multiple).div(denominator);
399     }
400 
401     /**
402      * Returns the smaller integer of the two passed in.
403      *
404      * @param a Unsigned integer
405      * @param b Unsigned integer
406      * @return The smaller of the two integers
407      */
408     function min(uint256 a, uint256 b) internal pure returns (uint256) {
409         return a < b ? a : b;
410     }
411 }
412 
413 /**
414  * @title LibRelayer provides two distinct features for relayers. 
415  *
416  * First, Relayers can opt into or out of the Hydro liquidity incentive system.
417  *
418  * Second, a relayer can register a delegate address.
419  * Delegates can send matching requests on behalf of relayers.
420  * The delegate scheme allows additional possibilities for smart contract interaction.
421  * on behalf of the relayer.
422  */
423 contract LibRelayer {
424 
425     /**
426      * Mapping of relayerAddress => delegateAddress
427      */
428     mapping (address => mapping (address => bool)) public relayerDelegates;
429 
430     /**
431      * Mapping of relayerAddress => whether relayer is opted out of the liquidity incentive system
432      */
433     mapping (address => bool) hasExited;
434 
435     event RelayerApproveDelegate(address indexed relayer, address indexed delegate);
436     event RelayerRevokeDelegate(address indexed relayer, address indexed delegate);
437 
438     event RelayerExit(address indexed relayer);
439     event RelayerJoin(address indexed relayer);
440 
441     /**
442      * Approve an address to match orders on behalf of msg.sender
443      */
444     function approveDelegate(address delegate) external {
445         relayerDelegates[msg.sender][delegate] = true;
446         emit RelayerApproveDelegate(msg.sender, delegate);
447     }
448 
449     /**
450      * Revoke an existing delegate
451      */
452     function revokeDelegate(address delegate) external {
453         relayerDelegates[msg.sender][delegate] = false;
454         emit RelayerRevokeDelegate(msg.sender, delegate);
455     }
456 
457     /**
458      * @return true if msg.sender is allowed to match orders which belong to relayer
459      */
460     function canMatchOrdersFrom(address relayer) public view returns(bool) {
461         return msg.sender == relayer || relayerDelegates[relayer][msg.sender] == true;
462     }
463 
464     /**
465      * Join the Hydro incentive system.
466      */
467     function joinIncentiveSystem() external {
468         delete hasExited[msg.sender];
469         emit RelayerJoin(msg.sender);
470     }
471 
472     /**
473      * Exit the Hydro incentive system.
474      * For relayers that choose to opt-out, the Hydro Protocol
475      * effective becomes a tokenless protocol.
476      */
477     function exitIncentiveSystem() external {
478         hasExited[msg.sender] = true;
479         emit RelayerExit(msg.sender);
480     }
481 
482     /**
483      * @return true if relayer is participating in the Hydro incentive system.
484      */
485     function isParticipant(address relayer) public view returns(bool) {
486         return !hasExited[relayer];
487     }
488 }
489 
490 /**
491  * Library to handle fee discount calculation
492  */
493 contract LibDiscount is LibOwnable {
494     using SafeMath for uint256;
495     
496     // The base discounted rate is 100% of the current rate, or no discount.
497     uint256 public constant DISCOUNT_RATE_BASE = 100;
498 
499     address public hotTokenAddress;
500 
501     constructor(address _hotTokenAddress) internal {
502         hotTokenAddress = _hotTokenAddress;
503     }
504 
505     /**
506      * Get the HOT token balance of an address.
507      *
508      * @param owner The address to check.
509      * @return The HOT balance for the owner address.
510      */
511     function getHotBalance(address owner) internal view returns (uint256 result) {
512         address hotToken = hotTokenAddress;
513 
514         // IERC20(hotTokenAddress).balanceOf(owner)
515 
516         /**
517          * We construct calldata for the `balanceOf` ABI.
518          * The layout of this calldata is in the table below.
519          * 
520          * ╔════════╤════════╤════════╤═══════════════════╗
521          * ║ Area   │ Offset │ Length │ Contents          ║
522          * ╟────────┼────────┼────────┼───────────────────╢
523          * ║ Header │ 0      │ 4      │ function selector ║
524          * ║ Params │ 4      │ 32     │ owner address     ║
525          * ╚════════╧════════╧════════╧═══════════════════╝
526          */
527         assembly {
528             // Keep these so we can restore stack memory upon completion
529             let tmp1 := mload(0)
530             let tmp2 := mload(4)
531 
532             // keccak256('balanceOf(address)') bitmasked to 4 bytes
533             mstore(0, 0x70a0823100000000000000000000000000000000000000000000000000000000)
534             mstore(4, owner)
535 
536             // No need to check the return value because hotToken is a trustworthy contract
537             result := call(
538                 gas,      // Forward all gas
539                 hotToken, // HOT token deployment address
540                 0,        // Don't send any ETH
541                 0,        // Pointer to start of calldata
542                 36,       // Length of calldata
543                 0,        // Overwrite calldata with output
544                 32        // Expecting uint256 output, the token balance
545             )
546             result := mload(0)
547 
548             // Restore stack memory
549             mstore(0, tmp1)
550             mstore(4, tmp2)
551         }
552     }
553 
554     bytes32 public discountConfig = 0x043c000027106400004e205a000075305000009c404600000000000000000000;
555 
556     /**
557      * Calculate and return the rate at which fees will be charged for an address. The discounted
558      * rate depends on how much HOT token is owned by the user. Values returned will be a percentage
559      * used to calculate how much of the fee is paid, so a return value of 100 means there is 0
560      * discount, and a return value of 70 means a 30% rate reduction.
561      *
562      * The discountConfig is defined as such:
563      * ╔═══════════════════╤════════════════════════════════════════════╗
564      * ║                   │ length(bytes)   desc                       ║
565      * ╟───────────────────┼────────────────────────────────────────────╢
566      * ║ count             │ 1               the count of configs       ║
567      * ║ maxDiscountedRate │ 1               the max discounted rate    ║
568      * ║ config            │ 5 each                                     ║
569      * ╚═══════════════════╧════════════════════════════════════════════╝
570      *
571      * The default discount structure as defined in code would give the following result:
572      *
573      * Fee discount table
574      * ╔════════════════════╤══════════╗
575      * ║     HOT BALANCE    │ DISCOUNT ║
576      * ╠════════════════════╪══════════╣
577      * ║     0 <= x < 10000 │     0%   ║
578      * ╟────────────────────┼──────────╢
579      * ║ 10000 <= x < 20000 │    10%   ║
580      * ╟────────────────────┼──────────╢
581      * ║ 20000 <= x < 30000 │    20%   ║
582      * ╟────────────────────┼──────────╢
583      * ║ 30000 <= x < 40000 │    30%   ║
584      * ╟────────────────────┼──────────╢
585      * ║ 40000 <= x         │    40%   ║
586      * ╚════════════════════╧══════════╝
587      *
588      * Breaking down the bytes of 0x043c000027106400004e205a000075305000009c404600000000000000000000
589      *
590      * 0x  04           3c          0000271064  00004e205a  0000753050  00009c4046  0000000000  0000000000;
591      *     ~~           ~~          ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~
592      *      |            |               |           |           |           |           |           |
593      *    count  maxDiscountedRate       1           2           3           4           5           6
594      *
595      * The first config breaks down as follows:  00002710   64
596      *                                           ~~~~~~~~   ~~
597      *                                               |      |
598      *                                              bar    rate
599      *
600      * Meaning if a user has less than 10000 (0x00002710) HOT, they will pay 100%(0x64) of the
601      * standard fee.
602      *
603      * @param user The user address to calculate a fee discount for.
604      * @return The percentage of the regular fee this user will pay.
605      */
606     function getDiscountedRate(address user) public view returns (uint256 result) {
607         uint256 hotBalance = getHotBalance(user);
608 
609         if (hotBalance == 0) {
610             return DISCOUNT_RATE_BASE;
611         }
612 
613         bytes32 config = discountConfig;
614         uint256 count = uint256(byte(config));
615         uint256 bar;
616 
617         // HOT Token has 18 decimals
618         hotBalance = hotBalance.div(10**18);
619 
620         for (uint256 i = 0; i < count; i++) {
621             bar = uint256(bytes4(config << (2 + i * 5) * 8));
622 
623             if (hotBalance < bar) {
624                 result = uint256(byte(config << (2 + i * 5 + 4) * 8));
625                 break;
626             }
627         }
628 
629         // If we haven't found a rate in the config yet, use the maximum rate.
630         if (result == 0) {
631             result = uint256(config[1]);
632         }
633 
634         // Make sure our discount algorithm never returns a higher rate than the base.
635         require(result <= DISCOUNT_RATE_BASE, "DISCOUNT_ERROR");
636     }
637 
638     /**
639      * Owner can modify discount configuration.
640      *
641      * @param newConfig A data blob representing the new discount config. Details on format above.
642      */
643     function changeDiscountConfig(bytes32 newConfig) external onlyOwner {
644         discountConfig = newConfig;
645     }
646 }
647 
648 contract LibExchangeErrors {
649     string constant INVALID_TRADER = "INVALID_TRADER";
650     string constant INVALID_SENDER = "INVALID_SENDER";
651     // Taker order and maker order can't be matched
652     string constant INVALID_MATCH = "INVALID_MATCH";
653     string constant INVALID_SIDE = "INVALID_SIDE";
654     // Signature validation failed
655     string constant INVALID_ORDER_SIGNATURE = "INVALID_ORDER_SIGNATURE";
656     // Taker order is not valid
657     string constant INVALID_TAKER_ORDER = "INVALID_TAKER_ORDER";
658     string constant ORDER_IS_NOT_FILLABLE = "ORDER_IS_NOT_FILLABLE";
659     string constant MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER = "MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER";
660     string constant COMPLETE_MATCH_FAILED = "COMPLETE_MATCH_FAILED";
661     // Taker sells more than expected base tokens
662     string constant TAKER_SELL_BASE_EXCEEDED = "TAKER_SELL_BASE_EXCEEDED";
663     // Taker used more than expected quote tokens in market buy
664     string constant TAKER_MARKET_BUY_QUOTE_EXCEEDED = "TAKER_MARKET_BUY_QUOTE_EXCEEDED";
665     // Taker buys more than expected base tokens
666     string constant TAKER_LIMIT_BUY_BASE_EXCEEDED = "TAKER_LIMIT_BUY_BASE_EXCEEDED";
667     string constant TRANSFER_FROM_FAILED = "TRANSFER_FROM_FAILED";
668     string constant RECORD_ADDRESSES_ERROR = "RECORD_ADDRESSES_ERROR";
669     string constant PERIOD_NOT_COMPLETED_ERROR = "PERIOD_NOT_COMPLETED_ERROR";
670     string constant CLAIM_HOT_TOKEN_ERROR = "CLAIM_HOT_TOKEN_ERROR";
671     string constant INVALID_PERIOD = "INVALID_PERIOD";
672 }
673 
674 contract HybridExchange is LibOrder, LibMath, LibRelayer, LibDiscount, LibExchangeErrors {
675     using SafeMath for uint256;
676 
677     uint256 public constant FEE_RATE_BASE = 100000;
678 
679     /**
680      * Address of the proxy responsible for asset transfer.
681      */
682     address public proxyAddress;
683 
684     /**
685      * Mapping of orderHash => amount
686      * Generally the amount will be specified in base token units, however in the case of a market
687      * buy order the amount is specified in quote token units.
688      */
689     mapping (bytes32 => uint256) public filled;
690     /**
691      * Mapping of orderHash => whether order has been cancelled.
692      */
693     mapping (bytes32 => bool) public cancelled;
694 
695     event Cancel(bytes32 indexed orderHash);
696     event Match(
697         address baseToken,
698         address quoteToken,
699         address relayer,
700         address maker,
701         address taker,
702         uint256 baseTokenAmount,
703         uint256 quoteTokenAmount,
704         uint256 makerFee,
705         uint256 takerFee,
706         uint256 makerGasFee,
707         uint256 makerRebate,
708         uint256 takerGasFee
709     );
710 
711     struct TotalMatchResult {
712         uint256 baseTokenFilledAmount;
713         uint256 quoteTokenFilledAmount;
714     }
715 
716     struct MatchResult {
717         address maker;
718         address taker;
719         uint256 makerFee;
720         uint256 makerRebate;
721         uint256 takerFee;
722         uint256 makerGasFee;
723         uint256 takerGasFee;
724         uint256 baseTokenFilledAmount;
725         uint256 quoteTokenFilledAmount;
726     }
727 
728     /**
729      * When orders are being matched, they will always contain the exact same base token,
730      * quote token, and relayer. Since excessive call data is very expensive, we choose
731      * to create a stripped down OrderParam struct containing only data that may vary between
732      * Order objects, and separate out the common elements into a set of addresses that will
733      * be shared among all of the OrderParam items. This is meant to eliminate redundancy in
734      * the call data, reducing it's size, and hence saving gas.
735      */
736     struct OrderParam {
737         address trader;
738         uint256 baseTokenAmount;
739         uint256 quoteTokenAmount;
740         uint256 gasTokenAmount;
741         bytes32 data;
742         OrderSignature signature;
743     }
744 
745     struct OrderAddressSet {
746         address baseToken;
747         address quoteToken;
748         address relayer;
749     }
750 
751     /**
752      * Calculated data about an order object.
753      * Generally the filledAmount is specified in base token units, however in the case of a market
754      * buy order the filledAmount is specified in quote token units.
755      */
756     struct OrderInfo {
757         bytes32 orderHash;
758         uint256 filledAmount;
759     }
760 
761     constructor(address _proxyAddress, address hotTokenAddress)
762         LibDiscount(hotTokenAddress)
763         public
764     {
765         proxyAddress = _proxyAddress;
766     }
767 
768     /**
769      * Match taker order to a list of maker orders. Common addresses are passed in
770      * separately as an OrderAddressSet to reduce call size data and save gas.
771      *
772      * @param takerOrderParam A OrderParam object representing the order from the taker.
773      * @param makerOrderParams An array of OrderParam objects representing orders from a list of makers.
774      * @param orderAddressSet An object containing addresses common across each order.
775      */
776     function matchOrders(
777         OrderParam memory takerOrderParam,
778         OrderParam[] memory makerOrderParams,
779         OrderAddressSet memory orderAddressSet
780     ) public {
781         require(canMatchOrdersFrom(orderAddressSet.relayer), INVALID_SENDER);
782 
783         bool isParticipantRelayer = isParticipant(orderAddressSet.relayer);
784         uint256 takerFeeRate = getTakerFeeRate(takerOrderParam, isParticipantRelayer);
785         OrderInfo memory takerOrderInfo = getOrderInfo(takerOrderParam, orderAddressSet);
786 
787         // Calculate which orders match for settlement.
788         MatchResult[] memory results = new MatchResult[](makerOrderParams.length);
789         TotalMatchResult memory totalMatch;
790         for (uint256 i = 0; i < makerOrderParams.length; i++) {
791             require(!isMarketOrder(makerOrderParams[i].data), MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER);
792             require(isSell(takerOrderParam.data) != isSell(makerOrderParams[i].data), INVALID_SIDE);
793             validatePrice(takerOrderParam, makerOrderParams[i]);
794 
795             OrderInfo memory makerOrderInfo = getOrderInfo(makerOrderParams[i], orderAddressSet);
796 
797             results[i] = getMatchResult(
798                 takerOrderParam,
799                 takerOrderInfo,
800                 makerOrderParams[i],
801                 makerOrderInfo,
802                 takerFeeRate,
803                 isParticipantRelayer
804             );
805 
806             // Update TotalMatchResult with new fill amounts
807             totalMatch.baseTokenFilledAmount = totalMatch.baseTokenFilledAmount.add(
808                 results[i].baseTokenFilledAmount
809             );
810             totalMatch.quoteTokenFilledAmount = totalMatch.quoteTokenFilledAmount.add(
811                 results[i].quoteTokenFilledAmount
812             );
813 
814             // Update amount filled for this maker order.
815             filled[makerOrderInfo.orderHash] = makerOrderInfo.filledAmount.add(
816                 results[i].baseTokenFilledAmount
817             );
818         }
819 
820         validateMatchResult(takerOrderParam, totalMatch);
821         settleResults(results, takerOrderParam, orderAddressSet);
822 
823         // Update amount filled for this taker order.
824         filled[takerOrderInfo.orderHash] = takerOrderInfo.filledAmount;
825     }
826 
827     /**
828      * Cancels an order, preventing it from being matched. In practice, matching mode relayers will
829      * generally handle cancellation off chain by removing the order from their system, however if
830      * the trader wants to ensure the order never goes through, or they no longer trust the relayer,
831      * this function may be called to block it from ever matching at the contract level.
832      *
833      * Emits a Cancel event on success.
834      *
835      * @param order The order to be cancelled.
836      */
837     function cancelOrder(Order memory order) public {
838         require(order.trader == msg.sender, INVALID_TRADER);
839 
840         bytes32 orderHash = getOrderHash(order);
841         cancelled[orderHash] = true;
842 
843         emit Cancel(orderHash);
844     }
845 
846     /**
847      * Calculates current state of the order. Will revert transaction if this order is not
848      * fillable for any reason, or if the order signature is invalid.
849      *
850      * @param orderParam The OrderParam object containing Order data.
851      * @param orderAddressSet An object containing addresses common across each order.
852      * @return An OrderInfo object containing the hash and current amount filled
853      */
854     function getOrderInfo(OrderParam memory orderParam, OrderAddressSet memory orderAddressSet)
855         internal
856         view
857         returns (OrderInfo memory orderInfo)
858     {
859         Order memory order = getOrderFromOrderParam(orderParam, orderAddressSet);
860         orderInfo.orderHash = getOrderHash(order);
861         orderInfo.filledAmount = filled[orderInfo.orderHash];
862         uint8 status = uint8(OrderStatus.FILLABLE);
863 
864         if (!isMarketBuy(order.data) && orderInfo.filledAmount >= order.baseTokenAmount) {
865             status = uint8(OrderStatus.FULLY_FILLED);
866         } else if (isMarketBuy(order.data) && orderInfo.filledAmount >= order.quoteTokenAmount) {
867             status = uint8(OrderStatus.FULLY_FILLED);
868         } else if (block.timestamp >= getExpiredAtFromOrderData(order.data)) {
869             status = uint8(OrderStatus.EXPIRED);
870         } else if (cancelled[orderInfo.orderHash]) {
871             status = uint8(OrderStatus.CANCELLED);
872         }
873 
874         require(status == uint8(OrderStatus.FILLABLE), ORDER_IS_NOT_FILLABLE);
875         require(
876             isValidSignature(orderInfo.orderHash, orderParam.trader, orderParam.signature),
877             INVALID_ORDER_SIGNATURE
878         );
879 
880         return orderInfo;
881     }
882 
883     /**
884      * Reconstruct an Order object from the given OrderParam and OrderAddressSet objects.
885      *
886      * @param orderParam The OrderParam object containing the Order data.
887      * @param orderAddressSet An object containing addresses common across each order.
888      * @return The reconstructed Order object.
889      */
890     function getOrderFromOrderParam(OrderParam memory orderParam, OrderAddressSet memory orderAddressSet)
891         internal
892         pure
893         returns (Order memory order)
894     {
895         order.trader = orderParam.trader;
896         order.baseTokenAmount = orderParam.baseTokenAmount;
897         order.quoteTokenAmount = orderParam.quoteTokenAmount;
898         order.gasTokenAmount = orderParam.gasTokenAmount;
899         order.data = orderParam.data;
900         order.baseToken = orderAddressSet.baseToken;
901         order.quoteToken = orderAddressSet.quoteToken;
902         order.relayer = orderAddressSet.relayer;
903     }
904 
905     /**
906      * Validates that the maker and taker orders can be matched based on the listed prices.
907      *
908      * If the taker submitted a sell order, the matching maker order must have a price greater than
909      * or equal to the price the taker is willing to sell for.
910      *
911      * Since the price of an order is computed by order.quoteTokenAmount / order.baseTokenAmount
912      * we can establish the following formula:
913      *
914      *    takerOrder.quoteTokenAmount        makerOrder.quoteTokenAmount
915      *   -----------------------------  <=  -----------------------------
916      *     takerOrder.baseTokenAmount        makerOrder.baseTokenAmount
917      *
918      * To avoid precision loss from division, we modify the formula to avoid division entirely.
919      * In shorthand, this becomes:
920      *
921      *   takerOrder.quote * makerOrder.base <= takerOrder.base * makerOrder.quote
922      *
923      * We can apply this same process to buy orders - if the taker submitted a buy order then
924      * the matching maker order must have a price less than or equal to the price the taker is
925      * willing to pay. This means we can use the same result as above, but simply flip the
926      * sign of the comparison operator.
927      *
928      * The function will revert the transaction if the orders cannot be matched.
929      *
930      * @param takerOrderParam The OrderParam object representing the taker's order data
931      * @param makerOrderParam The OrderParam object representing the maker's order data
932      */
933     function validatePrice(OrderParam memory takerOrderParam, OrderParam memory makerOrderParam)
934         internal
935         pure
936     {
937         uint256 left = takerOrderParam.quoteTokenAmount.mul(makerOrderParam.baseTokenAmount);
938         uint256 right = takerOrderParam.baseTokenAmount.mul(makerOrderParam.quoteTokenAmount);
939         require(isSell(takerOrderParam.data) ? left <= right : left >= right, INVALID_MATCH);
940     }
941 
942     /**
943      * Construct a MatchResult from matching taker and maker order data, which will be used when
944      * settling the orders and transferring token.
945      *
946      * @param takerOrderParam The OrderParam object representing the taker's order data
947      * @param takerOrderInfo The OrderInfo object representing the current taker order state
948      * @param makerOrderParam The OrderParam object representing the maker's order data
949      * @param makerOrderInfo The OrderInfo object representing the current maker order state
950      * @param takerFeeRate The rate used to calculate the fee charged to the taker
951      * @param isParticipantRelayer Whether this relayer is participating in hot discount
952      * @return MatchResult object containing data that will be used during order settlement.
953      */
954     function getMatchResult(
955         OrderParam memory takerOrderParam,
956         OrderInfo memory takerOrderInfo,
957         OrderParam memory makerOrderParam,
958         OrderInfo memory makerOrderInfo,
959         uint256 takerFeeRate,
960         bool isParticipantRelayer
961     )
962         internal
963         view
964         returns (MatchResult memory result)
965     {
966         // This will represent the amount we will be filling in this match. In most cases this will
967         // be represented in base token units, but in the market buy case this will be quote token
968         // units.
969         uint256 filledAmount;
970 
971         // Determine the amount of token that will be filled by this match, in both base and quote
972         // token units. This is done by checking which order has the least amount of token available
973         // to fill or be filled and using that as the base fill amount.
974         if(!isMarketBuy(takerOrderParam.data)) {
975             filledAmount = min(
976                 takerOrderParam.baseTokenAmount.sub(takerOrderInfo.filledAmount),
977                 makerOrderParam.baseTokenAmount.sub(makerOrderInfo.filledAmount)
978             );
979             result.quoteTokenFilledAmount = convertBaseToQuote(makerOrderParam, filledAmount);
980             result.baseTokenFilledAmount = filledAmount;
981         } else {
982             // In the market buy order case, we have to compare the amount of quote token left in
983             // the taker order with the amount of base token left in the maker order. In order to do
984             // that we convert from base to quote units in our comparison.
985             filledAmount = min(
986                 takerOrderParam.quoteTokenAmount.sub(takerOrderInfo.filledAmount),
987                 convertBaseToQuote(
988                     makerOrderParam,
989                     makerOrderParam.baseTokenAmount.sub(makerOrderInfo.filledAmount)
990                 )
991             );
992             result.baseTokenFilledAmount = convertQuoteToBase(makerOrderParam, filledAmount);
993             result.quoteTokenFilledAmount = filledAmount;
994         }
995 
996         // Each order only pays gas once, so only pay gas when nothing has been filled yet.
997         if (takerOrderInfo.filledAmount == 0) {
998             result.takerGasFee = takerOrderParam.gasTokenAmount;
999         }
1000 
1001         if (makerOrderInfo.filledAmount == 0) {
1002             result.makerGasFee = makerOrderParam.gasTokenAmount;
1003         }
1004 
1005         // Update filled amount. The filledAmount variable will always be in the correct base or
1006         // quote unit.
1007         takerOrderInfo.filledAmount = takerOrderInfo.filledAmount.add(filledAmount);
1008 
1009         result.maker = makerOrderParam.trader;
1010         result.taker = takerOrderParam.trader;
1011 
1012         // rebateRate uses the same base as fee rates, so can be directly compared
1013         uint256 rebateRate = getMakerRebateRateFromOrderData(makerOrderParam.data);
1014         uint256 makerRawFeeRate = getAsMakerFeeRateFromOrderData(makerOrderParam.data);
1015 
1016         if (rebateRate > makerRawFeeRate) {
1017             // Cap the rebate so it will never exceed the fees paid by the taker.
1018             uint256 makerRebateRate = min(
1019                 // Don't want to apply discounts to the rebase, so simply multiply by
1020                 // DISCOUNT_RATE_BASE to get it to the correct units.
1021                 rebateRate.sub(makerRawFeeRate).mul(DISCOUNT_RATE_BASE),
1022                 takerFeeRate
1023             );
1024             result.makerRebate = result.quoteTokenFilledAmount.mul(makerRebateRate).div(
1025                 FEE_RATE_BASE.mul(DISCOUNT_RATE_BASE)
1026             );
1027             // If the rebate rate is higher, maker pays no fees.
1028             result.makerFee = 0;
1029         } else {
1030             // maker fee will be reduced, but still >= 0
1031             uint256 makerFeeRate = getFinalFeeRate(
1032                 makerOrderParam.trader,
1033                 makerRawFeeRate.sub(rebateRate),
1034                 isParticipantRelayer
1035             );
1036             result.makerFee = result.quoteTokenFilledAmount.mul(makerFeeRate).div(
1037                 FEE_RATE_BASE.mul(DISCOUNT_RATE_BASE)
1038             );
1039             result.makerRebate = 0;
1040         }
1041 
1042         result.takerFee = result.quoteTokenFilledAmount.mul(takerFeeRate).div(
1043             FEE_RATE_BASE.mul(DISCOUNT_RATE_BASE)
1044         );
1045     }
1046 
1047     /**
1048      * Get the rate used to calculate the taker fee.
1049      *
1050      * @param orderParam The OrderParam object representing the taker order data.
1051      * @param isParticipantRelayer Whether this relayer is participating in hot discount.
1052      * @return The final potentially discounted rate to use for the taker fee.
1053      */
1054     function getTakerFeeRate(OrderParam memory orderParam, bool isParticipantRelayer)
1055         internal
1056         view
1057         returns(uint256)
1058     {
1059         uint256 rawRate = getAsTakerFeeRateFromOrderData(orderParam.data);
1060         return getFinalFeeRate(orderParam.trader, rawRate, isParticipantRelayer);
1061     }
1062 
1063     /**
1064      * Take a fee rate and calculate the potentially discounted rate for this trader based on
1065      * HOT token ownership.
1066      *
1067      * @param trader The address of the trader who made the order.
1068      * @param rate The raw rate which we will discount if needed.
1069      * @param isParticipantRelayer Whether this relayer is participating in hot discount.
1070      * @return The final potentially discounted rate.
1071      */
1072     function getFinalFeeRate(address trader, uint256 rate, bool isParticipantRelayer)
1073         internal
1074         view
1075         returns(uint256)
1076     {
1077         if (isParticipantRelayer) {
1078             return rate.mul(getDiscountedRate(trader));
1079         } else {
1080             return rate.mul(DISCOUNT_RATE_BASE);
1081         }
1082     }
1083 
1084     /**
1085      * Take an amount and convert it from base token units to quote token units based on the price
1086      * in the order param.
1087      *
1088      * @param orderParam The OrderParam object containing the Order data.
1089      * @param amount An amount of base token.
1090      * @return The converted amount in quote token units.
1091      */
1092     function convertBaseToQuote(OrderParam memory orderParam, uint256 amount)
1093         internal
1094         pure
1095         returns (uint256)
1096     {
1097         return getPartialAmountFloor(
1098             orderParam.quoteTokenAmount,
1099             orderParam.baseTokenAmount,
1100             amount
1101         );
1102     }
1103 
1104     /**
1105      * Take an amount and convert it from quote token units to base token units based on the price
1106      * in the order param.
1107      *
1108      * @param orderParam The OrderParam object containing the Order data.
1109      * @param amount An amount of quote token.
1110      * @return The converted amount in base token units.
1111      */
1112     function convertQuoteToBase(OrderParam memory orderParam, uint256 amount)
1113         internal
1114         pure
1115         returns (uint256)
1116     {
1117         return getPartialAmountFloor(
1118             orderParam.baseTokenAmount,
1119             orderParam.quoteTokenAmount,
1120             amount
1121         );
1122     }
1123 
1124     /**
1125      * Validates sanity of match results.
1126      *
1127      * This function will revert the transaction if the results cannot be validated.
1128      *
1129      * @param takerOrderParam The OrderParam object representing the taker's order data
1130      * @param totalMatch Accumlated match result data representing how much token will be filled
1131      */
1132     function validateMatchResult(OrderParam memory takerOrderParam, TotalMatchResult memory totalMatch)
1133         internal
1134         pure
1135     {
1136         if (isSell(takerOrderParam.data)) {
1137             // Ensure we don't attempt to sell more tokens than the taker wished to sell
1138             require(
1139                 totalMatch.baseTokenFilledAmount <= takerOrderParam.baseTokenAmount,
1140                 TAKER_SELL_BASE_EXCEEDED
1141             );
1142         } else {
1143             // Ensure we don't attempt to buy more tokens than the taker wished to buy
1144             require(
1145                 totalMatch.quoteTokenFilledAmount <= takerOrderParam.quoteTokenAmount,
1146                 TAKER_MARKET_BUY_QUOTE_EXCEEDED
1147             );
1148 
1149             // If this isn't a market order, there may be maker orders with a better price. Ensure
1150             // we use exactly the taker's price in this case (as it is a limit order) by validating
1151             // that the amount of base token filled also matches.
1152             if (!isMarketOrder(takerOrderParam.data)) {
1153                 require(
1154                     totalMatch.baseTokenFilledAmount <= takerOrderParam.baseTokenAmount,
1155                     TAKER_LIMIT_BUY_BASE_EXCEEDED
1156                 );
1157             }
1158         }
1159     }
1160 
1161     /**
1162      * Take a list of matches and settle them with the taker order, transferring tokens all tokens
1163      * and paying all fees necessary to complete the transaction.
1164      *
1165      * @param results List of MatchResult objects representing each individual trade to settle.
1166      * @param takerOrderParam The OrderParam object representing the taker order data.
1167      * @param orderAddressSet An object containing addresses common across each order.
1168      */
1169     function settleResults(
1170         MatchResult[] memory results,
1171         OrderParam memory takerOrderParam,
1172         OrderAddressSet memory orderAddressSet
1173     )
1174         internal
1175     {
1176         if (isSell(takerOrderParam.data)) {
1177             settleTakerSell(results, orderAddressSet);
1178         } else {
1179             settleTakerBuy(results, orderAddressSet);
1180         }
1181     }
1182 
1183     /**
1184      * Settles a sell order given a list of MatchResult objects. A naive approach would be to take
1185      * each result, have the taker and maker transfer the appropriate tokens, and then have them
1186      * each send the appropriate fees to the relayer, meaning that for n makers there would be 4n
1187      * transactions. Additionally the taker would have to have an allowance set for the quote token
1188      * in order to pay the fees to the relayer.
1189      *
1190      * Instead we do the following:
1191      *  - Taker transfers the required base token to each maker
1192      *  - Each maker sends an amount of quote token to the relayer equal to:
1193      *    [Amount owed to taker] + [Maker fee] + [Maker gas cost] - [Maker rebate amount]
1194      *  - The relayer will then take all of this quote token and in a single batch transaction
1195      *    send the appropriate amount to the taker, equal to:
1196      *    [Total amount owed to taker] - [All taker fees] - [All taker gas costs]
1197      *
1198      * Thus in the end the taker will have the full amount of quote token, sans the fee and cost of
1199      * their share of gas. Each maker will have their share of base token, sans the fee and cost of
1200      * their share of gas, and will keep their rebate in quote token. The relayer will end up with
1201      * the fees from the taker and each maker (sans rebate), and the gas costs will pay for the
1202      * transactions. In this scenario, with n makers there will be 2n + 1 transactions, which will
1203      * be a significant gas savings over the original method.
1204      *
1205      * @param results A list of MatchResult objects representing each individual trade to settle.
1206      * @param orderAddressSet An object containing addresses common across each order.
1207      */
1208     function settleTakerSell(MatchResult[] memory results, OrderAddressSet memory orderAddressSet) internal {
1209         uint256 totalTakerBaseTokenFilledAmount = 0;
1210 
1211         for (uint256 i = 0; i < results.length; i++) {
1212             transferFrom(
1213                 orderAddressSet.baseToken,
1214                 results[i].taker,
1215                 results[i].maker,
1216                 results[i].baseTokenFilledAmount
1217             );
1218 
1219             transferFrom(
1220                 orderAddressSet.quoteToken,
1221                 results[i].maker,
1222                 orderAddressSet.relayer,
1223                 results[i].quoteTokenFilledAmount.
1224                     add(results[i].makerFee).
1225                     add(results[i].makerGasFee).
1226                     sub(results[i].makerRebate)
1227             );
1228 
1229             totalTakerBaseTokenFilledAmount = totalTakerBaseTokenFilledAmount.add(
1230                 results[i].quoteTokenFilledAmount.sub(results[i].takerFee)
1231             );
1232 
1233             emitMatchEvent(results[i], orderAddressSet);
1234         }
1235 
1236         transferFrom(
1237             orderAddressSet.quoteToken,
1238             orderAddressSet.relayer,
1239             results[0].taker,
1240             totalTakerBaseTokenFilledAmount.sub(results[0].takerGasFee)
1241         );
1242     }
1243 
1244     /**
1245      * Settles a buy order given a list of MatchResult objects. A naive approach would be to take
1246      * each result, have the taker and maker transfer the appropriate tokens, and then have them
1247      * each send the appropriate fees to the relayer, meaning that for n makers there would be 4n
1248      * transactions. Additionally each maker would have to have an allowance set for the quote token
1249      * in order to pay the fees to the relayer.
1250      *
1251      * Instead we do the following:
1252      *  - Each maker transfers base tokens to the taker
1253      *  - The taker sends an amount of quote tokens to each maker equal to:
1254      *    [Amount owed to maker] + [Maker rebate amount] - [Maker fee] - [Maker gas cost]
1255      *  - Since the taker saved all the maker fees and gas costs, it can then send them as a single
1256      *    batch transaction to the relayer, equal to:
1257      *    [All maker and taker fees] + [All maker and taker gas costs] - [All maker rebates]
1258      *
1259      * Thus in the end the taker will have the full amount of base token, sans the fee and cost of
1260      * their share of gas. Each maker will have their share of quote token, including their rebate,
1261      * but sans the fee and cost of their share of gas. The relayer will end up with the fees from
1262      * the taker and each maker (sans rebates), and the gas costs will pay for the transactions. In
1263      * this scenario, with n makers there will be 2n + 1 transactions, which will be a significant
1264      * gas savings over the original method.
1265      *
1266      * @param results A list of MatchResult objects representing each individual trade to settle.
1267      * @param orderAddressSet An object containing addresses common across each order.
1268      */
1269     function settleTakerBuy(MatchResult[] memory results, OrderAddressSet memory orderAddressSet) internal {
1270         uint256 totalFee = 0;
1271 
1272         for (uint256 i = 0; i < results.length; i++) {
1273             transferFrom(
1274                 orderAddressSet.baseToken,
1275                 results[i].maker,
1276                 results[i].taker,
1277                 results[i].baseTokenFilledAmount
1278             );
1279 
1280             transferFrom(
1281                 orderAddressSet.quoteToken,
1282                 results[i].taker,
1283                 results[i].maker,
1284                 results[i].quoteTokenFilledAmount.
1285                     sub(results[i].makerFee).
1286                     sub(results[i].makerGasFee).
1287                     add(results[i].makerRebate)
1288             );
1289 
1290             totalFee = totalFee.
1291                 add(results[i].takerFee).
1292                 add(results[i].makerFee).
1293                 add(results[i].makerGasFee).
1294                 add(results[i].takerGasFee).
1295                 sub(results[i].makerRebate);
1296 
1297             emitMatchEvent(results[i], orderAddressSet);
1298         }
1299 
1300         transferFrom(
1301             orderAddressSet.quoteToken,
1302             results[0].taker,
1303             orderAddressSet.relayer,
1304             totalFee
1305         );
1306     }
1307 
1308     /**
1309      * A helper function to call the transferFrom function in Proxy.sol with solidity assembly.
1310      * Copying the data in order to make an external call can be expensive, but performing the
1311      * operations in assembly seems to reduce gas cost.
1312      *
1313      * The function will revert the transaction if the transfer fails.
1314      *
1315      * @param token The address of the ERC20 token we will be transferring, 0 for ETH.
1316      * @param from The address we will be transferring from.
1317      * @param to The address we will be transferring to.
1318      * @param value The amount of token we will be transferring.
1319      */
1320     function transferFrom(address token, address from, address to, uint256 value) internal {
1321         if (value == 0) {
1322             return;
1323         }
1324 
1325         address proxy = proxyAddress;
1326         uint256 result;
1327 
1328         /**
1329          * We construct calldata for the `Proxy.transferFrom` ABI.
1330          * The layout of this calldata is in the table below.
1331          *
1332          * ╔════════╤════════╤════════╤═══════════════════╗
1333          * ║ Area   │ Offset │ Length │ Contents          ║
1334          * ╟────────┼────────┼────────┼───────────────────╢
1335          * ║ Header │ 0      │ 4      │ function selector ║
1336          * ║ Params │ 4      │ 32     │ token address     ║
1337          * ║        │ 36     │ 32     │ from address      ║
1338          * ║        │ 68     │ 32     │ to address        ║
1339          * ║        │ 100    │ 32     │ amount of token   ║
1340          * ╚════════╧════════╧════════╧═══════════════════╝
1341          */
1342         assembly {
1343             // Keep these so we can restore stack memory upon completion
1344             let tmp1 := mload(0)
1345             let tmp2 := mload(4)
1346             let tmp3 := mload(36)
1347             let tmp4 := mload(68)
1348             let tmp5 := mload(100)
1349 
1350             // keccak256('transferFrom(address,address,address,uint256)') bitmasked to 4 bytes
1351             mstore(0, 0x15dacbea00000000000000000000000000000000000000000000000000000000)
1352             mstore(4, token)
1353             mstore(36, from)
1354             mstore(68, to)
1355             mstore(100, value)
1356 
1357             // Call Proxy contract transferFrom function using constructed calldata
1358             result := call(
1359                 gas,   // Forward all gas
1360                 proxy, // Proxy.sol deployment address
1361                 0,     // Don't send any ETH
1362                 0,     // Pointer to start of calldata
1363                 132,   // Length of calldata
1364                 0,     // Output location
1365                 0      // We don't expect any output
1366             )
1367 
1368             // Restore stack memory
1369             mstore(0, tmp1)
1370             mstore(4, tmp2)
1371             mstore(36, tmp3)
1372             mstore(68, tmp4)
1373             mstore(100, tmp5)
1374         }
1375 
1376         if (result == 0) {
1377             revert(TRANSFER_FROM_FAILED);
1378         }
1379     }
1380 
1381     function emitMatchEvent(MatchResult memory result, OrderAddressSet memory orderAddressSet) internal {
1382         emit Match(
1383             orderAddressSet.baseToken,
1384             orderAddressSet.quoteToken,
1385             orderAddressSet.relayer,
1386             result.maker,
1387             result.taker,
1388             result.baseTokenFilledAmount,
1389             result.quoteTokenFilledAmount,
1390             result.makerFee,
1391             result.takerFee,
1392             result.makerGasFee,
1393             result.makerRebate,
1394             result.takerGasFee
1395         );
1396     }
1397 }