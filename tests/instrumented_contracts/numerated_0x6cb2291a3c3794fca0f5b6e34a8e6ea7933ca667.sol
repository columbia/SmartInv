1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/IOneSplit.sol
81 
82 pragma solidity ^0.5.0;
83 
84 
85 //
86 //  [ msg.sender ]
87 //       | |
88 //       | |
89 //       \_/
90 // +---------------+ ________________________________
91 // | OneSplitAudit | _______________________________  \
92 // +---------------+                                 \ \
93 //       | |                      ______________      | | (staticcall)
94 //       | |                    /  ____________  \    | |
95 //       | | (call)            / /              \ \   | |
96 //       | |                  / /               | |   | |
97 //       \_/                  | |               \_/   \_/
98 // +--------------+           | |           +----------------------+
99 // | OneSplitWrap |           | |           |   OneSplitViewWrap   |
100 // +--------------+           | |           +----------------------+
101 //       | |                  | |                     | |
102 //       | | (delegatecall)   | | (staticcall)        | | (staticcall)
103 //       \_/                  | |                     \_/
104 // +--------------+           | |             +------------------+
105 // |   OneSplit   |           | |             |   OneSplitView   |
106 // +--------------+           | |             +------------------+
107 //       | |                  / /
108 //        \ \________________/ /
109 //         \__________________/
110 //
111 
112 
113 contract IOneSplitConsts {
114     // flags = FLAG_DISABLE_UNISWAP + FLAG_DISABLE_BANCOR + ...
115     uint256 internal constant FLAG_DISABLE_UNISWAP = 0x01;
116     uint256 internal constant DEPRECATED_FLAG_DISABLE_KYBER = 0x02; // Deprecated
117     uint256 internal constant FLAG_DISABLE_BANCOR = 0x04;
118     uint256 internal constant FLAG_DISABLE_OASIS = 0x08;
119     uint256 internal constant FLAG_DISABLE_COMPOUND = 0x10;
120     uint256 internal constant FLAG_DISABLE_FULCRUM = 0x20;
121     uint256 internal constant FLAG_DISABLE_CHAI = 0x40;
122     uint256 internal constant FLAG_DISABLE_AAVE = 0x80;
123     uint256 internal constant FLAG_DISABLE_SMART_TOKEN = 0x100;
124     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_ETH = 0x200; // Deprecated, Turned off by default
125     uint256 internal constant FLAG_DISABLE_BDAI = 0x400;
126     uint256 internal constant FLAG_DISABLE_IEARN = 0x800;
127     uint256 internal constant FLAG_DISABLE_CURVE_COMPOUND = 0x1000;
128     uint256 internal constant FLAG_DISABLE_CURVE_USDT = 0x2000;
129     uint256 internal constant FLAG_DISABLE_CURVE_Y = 0x4000;
130     uint256 internal constant FLAG_DISABLE_CURVE_BINANCE = 0x8000;
131     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_DAI = 0x10000; // Deprecated, Turned off by default
132     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_USDC = 0x20000; // Deprecated, Turned off by default
133     uint256 internal constant FLAG_DISABLE_CURVE_SYNTHETIX = 0x40000;
134     uint256 internal constant FLAG_DISABLE_WETH = 0x80000;
135     uint256 internal constant FLAG_DISABLE_UNISWAP_COMPOUND = 0x100000; // Works only when one of assets is ETH or FLAG_ENABLE_MULTI_PATH_ETH
136     uint256 internal constant FLAG_DISABLE_UNISWAP_CHAI = 0x200000; // Works only when ETH<>DAI or FLAG_ENABLE_MULTI_PATH_ETH
137     uint256 internal constant FLAG_DISABLE_UNISWAP_AAVE = 0x400000; // Works only when one of assets is ETH or FLAG_ENABLE_MULTI_PATH_ETH
138     uint256 internal constant FLAG_DISABLE_IDLE = 0x800000;
139     uint256 internal constant FLAG_DISABLE_MOONISWAP = 0x1000000;
140     uint256 internal constant FLAG_DISABLE_UNISWAP_V2 = 0x2000000;
141     uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ETH = 0x4000000;
142     uint256 internal constant FLAG_DISABLE_UNISWAP_V2_DAI = 0x8000000;
143     uint256 internal constant FLAG_DISABLE_UNISWAP_V2_USDC = 0x10000000;
144     uint256 internal constant FLAG_DISABLE_ALL_SPLIT_SOURCES = 0x20000000;
145     uint256 internal constant FLAG_DISABLE_ALL_WRAP_SOURCES = 0x40000000;
146     uint256 internal constant FLAG_DISABLE_CURVE_PAX = 0x80000000;
147     uint256 internal constant FLAG_DISABLE_CURVE_RENBTC = 0x100000000;
148     uint256 internal constant FLAG_DISABLE_CURVE_TBTC = 0x200000000;
149     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_USDT = 0x400000000; // Deprecated, Turned off by default
150     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_WBTC = 0x800000000; // Deprecated, Turned off by default
151     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_TBTC = 0x1000000000; // Deprecated, Turned off by default
152     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_RENBTC = 0x2000000000; // Deprecated, Turned off by default
153     uint256 internal constant FLAG_DISABLE_DFORCE_SWAP = 0x4000000000;
154     uint256 internal constant FLAG_DISABLE_SHELL = 0x8000000000;
155     uint256 internal constant FLAG_ENABLE_CHI_BURN = 0x10000000000;
156     uint256 internal constant FLAG_DISABLE_MSTABLE_MUSD = 0x20000000000;
157     uint256 internal constant FLAG_DISABLE_CURVE_SBTC = 0x40000000000;
158     uint256 internal constant FLAG_DISABLE_DMM = 0x80000000000;
159     uint256 internal constant FLAG_DISABLE_UNISWAP_ALL = 0x100000000000;
160     uint256 internal constant FLAG_DISABLE_CURVE_ALL = 0x200000000000;
161     uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ALL = 0x400000000000;
162     uint256 internal constant FLAG_DISABLE_SPLIT_RECALCULATION = 0x800000000000;
163     uint256 internal constant FLAG_DISABLE_BALANCER_ALL = 0x1000000000000;
164     uint256 internal constant FLAG_DISABLE_BALANCER_1 = 0x2000000000000;
165     uint256 internal constant FLAG_DISABLE_BALANCER_2 = 0x4000000000000;
166     uint256 internal constant FLAG_DISABLE_BALANCER_3 = 0x8000000000000;
167     uint256 internal constant DEPRECATED_FLAG_ENABLE_KYBER_UNISWAP_RESERVE = 0x10000000000000; // Deprecated, Turned off by default
168     uint256 internal constant DEPRECATED_FLAG_ENABLE_KYBER_OASIS_RESERVE = 0x20000000000000; // Deprecated, Turned off by default
169     uint256 internal constant DEPRECATED_FLAG_ENABLE_KYBER_BANCOR_RESERVE = 0x40000000000000; // Deprecated, Turned off by default
170     uint256 internal constant FLAG_ENABLE_REFERRAL_GAS_SPONSORSHIP = 0x80000000000000; // Turned off by default
171     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_COMP = 0x100000000000000; // Deprecated, Turned off by default
172     uint256 internal constant FLAG_DISABLE_KYBER_ALL = 0x200000000000000;
173     uint256 internal constant FLAG_DISABLE_KYBER_1 = 0x400000000000000;
174     uint256 internal constant FLAG_DISABLE_KYBER_2 = 0x800000000000000;
175     uint256 internal constant FLAG_DISABLE_KYBER_3 = 0x1000000000000000;
176     uint256 internal constant FLAG_DISABLE_KYBER_4 = 0x2000000000000000;
177     uint256 internal constant FLAG_ENABLE_CHI_BURN_BY_ORIGIN = 0x4000000000000000;
178     uint256 internal constant FLAG_DISABLE_MOONISWAP_ALL = 0x8000000000000000;
179     uint256 internal constant FLAG_DISABLE_MOONISWAP_ETH = 0x10000000000000000;
180     uint256 internal constant FLAG_DISABLE_MOONISWAP_DAI = 0x20000000000000000;
181     uint256 internal constant FLAG_DISABLE_MOONISWAP_USDC = 0x40000000000000000;
182     uint256 internal constant FLAG_DISABLE_MOONISWAP_POOL_TOKEN = 0x80000000000000000;
183 }
184 
185 
186 contract IOneSplit is IOneSplitConsts {
187     function getExpectedReturn(
188         IERC20 fromToken,
189         IERC20 destToken,
190         uint256 amount,
191         uint256 parts,
192         uint256 flags // See constants in IOneSplit.sol
193     )
194         public
195         view
196         returns(
197             uint256 returnAmount,
198             uint256[] memory distribution
199         );
200 
201     function getExpectedReturnWithGas(
202         IERC20 fromToken,
203         IERC20 destToken,
204         uint256 amount,
205         uint256 parts,
206         uint256 flags, // See constants in IOneSplit.sol
207         uint256 destTokenEthPriceTimesGasPrice
208     )
209         public
210         view
211         returns(
212             uint256 returnAmount,
213             uint256 estimateGasAmount,
214             uint256[] memory distribution
215         );
216 
217     function swap(
218         IERC20 fromToken,
219         IERC20 destToken,
220         uint256 amount,
221         uint256 minReturn,
222         uint256[] memory distribution,
223         uint256 flags
224     )
225         public
226         payable
227         returns(uint256 returnAmount);
228 }
229 
230 
231 contract IOneSplitMulti is IOneSplit {
232     function getExpectedReturnWithGasMulti(
233         IERC20[] memory tokens,
234         uint256 amount,
235         uint256[] memory parts,
236         uint256[] memory flags,
237         uint256[] memory destTokenEthPriceTimesGasPrices
238     )
239         public
240         view
241         returns(
242             uint256[] memory returnAmounts,
243             uint256 estimateGasAmount,
244             uint256[] memory distribution
245         );
246 
247     function swapMulti(
248         IERC20[] memory tokens,
249         uint256 amount,
250         uint256 minReturn,
251         uint256[] memory distribution,
252         uint256[] memory flags
253     )
254         public
255         payable
256         returns(uint256 returnAmount);
257 }
258 
259 // File: @openzeppelin/contracts/math/SafeMath.sol
260 
261 pragma solidity ^0.5.0;
262 
263 /**
264  * @dev Wrappers over Solidity's arithmetic operations with added overflow
265  * checks.
266  *
267  * Arithmetic operations in Solidity wrap on overflow. This can easily result
268  * in bugs, because programmers usually assume that an overflow raises an
269  * error, which is the standard behavior in high level programming languages.
270  * `SafeMath` restores this intuition by reverting the transaction when an
271  * operation overflows.
272  *
273  * Using this library instead of the unchecked operations eliminates an entire
274  * class of bugs, so it's recommended to use it always.
275  */
276 library SafeMath {
277     /**
278      * @dev Returns the addition of two unsigned integers, reverting on
279      * overflow.
280      *
281      * Counterpart to Solidity's `+` operator.
282      *
283      * Requirements:
284      * - Addition cannot overflow.
285      */
286     function add(uint256 a, uint256 b) internal pure returns (uint256) {
287         uint256 c = a + b;
288         require(c >= a, "SafeMath: addition overflow");
289 
290         return c;
291     }
292 
293     /**
294      * @dev Returns the subtraction of two unsigned integers, reverting on
295      * overflow (when the result is negative).
296      *
297      * Counterpart to Solidity's `-` operator.
298      *
299      * Requirements:
300      * - Subtraction cannot overflow.
301      */
302     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303         return sub(a, b, "SafeMath: subtraction overflow");
304     }
305 
306     /**
307      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
308      * overflow (when the result is negative).
309      *
310      * Counterpart to Solidity's `-` operator.
311      *
312      * Requirements:
313      * - Subtraction cannot overflow.
314      *
315      * _Available since v2.4.0._
316      */
317     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         require(b <= a, errorMessage);
319         uint256 c = a - b;
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the multiplication of two unsigned integers, reverting on
326      * overflow.
327      *
328      * Counterpart to Solidity's `*` operator.
329      *
330      * Requirements:
331      * - Multiplication cannot overflow.
332      */
333     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
334         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
335         // benefit is lost if 'b' is also tested.
336         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
337         if (a == 0) {
338             return 0;
339         }
340 
341         uint256 c = a * b;
342         require(c / a == b, "SafeMath: multiplication overflow");
343 
344         return c;
345     }
346 
347     /**
348      * @dev Returns the integer division of two unsigned integers. Reverts on
349      * division by zero. The result is rounded towards zero.
350      *
351      * Counterpart to Solidity's `/` operator. Note: this function uses a
352      * `revert` opcode (which leaves remaining gas untouched) while Solidity
353      * uses an invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      * - The divisor cannot be zero.
357      */
358     function div(uint256 a, uint256 b) internal pure returns (uint256) {
359         return div(a, b, "SafeMath: division by zero");
360     }
361 
362     /**
363      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
364      * division by zero. The result is rounded towards zero.
365      *
366      * Counterpart to Solidity's `/` operator. Note: this function uses a
367      * `revert` opcode (which leaves remaining gas untouched) while Solidity
368      * uses an invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      * - The divisor cannot be zero.
372      *
373      * _Available since v2.4.0._
374      */
375     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
376         // Solidity only automatically asserts when dividing by 0
377         require(b > 0, errorMessage);
378         uint256 c = a / b;
379         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
380 
381         return c;
382     }
383 
384     /**
385      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
386      * Reverts when dividing by zero.
387      *
388      * Counterpart to Solidity's `%` operator. This function uses a `revert`
389      * opcode (which leaves remaining gas untouched) while Solidity uses an
390      * invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      * - The divisor cannot be zero.
394      */
395     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
396         return mod(a, b, "SafeMath: modulo by zero");
397     }
398 
399     /**
400      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
401      * Reverts with custom message when dividing by zero.
402      *
403      * Counterpart to Solidity's `%` operator. This function uses a `revert`
404      * opcode (which leaves remaining gas untouched) while Solidity uses an
405      * invalid opcode to revert (consuming all remaining gas).
406      *
407      * Requirements:
408      * - The divisor cannot be zero.
409      *
410      * _Available since v2.4.0._
411      */
412     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
413         require(b != 0, errorMessage);
414         return a % b;
415     }
416 }
417 
418 // File: contracts/interface/IUniswapExchange.sol
419 
420 pragma solidity ^0.5.0;
421 
422 
423 
424 interface IUniswapExchange {
425     function getEthToTokenInputPrice(uint256 ethSold) external view returns (uint256 tokensBought);
426 
427     function getTokenToEthInputPrice(uint256 tokensSold) external view returns (uint256 ethBought);
428 
429     function ethToTokenSwapInput(uint256 minTokens, uint256 deadline)
430         external
431         payable
432         returns (uint256 tokensBought);
433 
434     function tokenToEthSwapInput(uint256 tokensSold, uint256 minEth, uint256 deadline)
435         external
436         returns (uint256 ethBought);
437 
438     function tokenToTokenSwapInput(
439         uint256 tokensSold,
440         uint256 minTokensBought,
441         uint256 minEthBought,
442         uint256 deadline,
443         address tokenAddr
444     ) external returns (uint256 tokensBought);
445 }
446 
447 // File: contracts/interface/IUniswapFactory.sol
448 
449 pragma solidity ^0.5.0;
450 
451 
452 
453 interface IUniswapFactory {
454     function getExchange(IERC20 token) external view returns (IUniswapExchange exchange);
455 }
456 
457 // File: contracts/interface/IKyberNetworkContract.sol
458 
459 pragma solidity ^0.5.0;
460 
461 
462 
463 interface IKyberNetworkContract {
464     function searchBestRate(IERC20 src, IERC20 dest, uint256 srcAmount, bool usePermissionless)
465         external
466         view
467         returns (address reserve, uint256 rate);
468 }
469 
470 // File: contracts/interface/IKyberNetworkProxy.sol
471 
472 pragma solidity ^0.5.0;
473 
474 
475 
476 interface IKyberNetworkProxy {
477     function getExpectedRateAfterFee(
478         IERC20 src,
479         IERC20 dest,
480         uint256 srcQty,
481         uint256 platformFeeBps,
482         bytes calldata hint
483     ) external view returns (uint256 expectedRate);
484 
485     function tradeWithHintAndFee(
486         IERC20 src,
487         uint256 srcAmount,
488         IERC20 dest,
489         address payable destAddress,
490         uint256 maxDestAmount,
491         uint256 minConversionRate,
492         address payable platformWallet,
493         uint256 platformFeeBps,
494         bytes calldata hint
495     ) external payable returns (uint256 destAmount);
496 
497     function kyberNetworkContract() external view returns (IKyberNetworkContract);
498 
499     // TODO: Limit usage by tx.gasPrice
500     // function maxGasPrice() external view returns (uint256);
501 
502     // TODO: Limit usage by user cap
503     // function getUserCapInWei(address user) external view returns (uint256);
504     // function getUserCapInTokenWei(address user, IERC20 token) external view returns (uint256);
505 }
506 
507 // File: contracts/interface/IKyberStorage.sol
508 
509 pragma solidity ^0.5.0;
510 
511 
512 
513 interface IKyberStorage {
514     function getReserveIdsPerTokenSrc(
515         IERC20 token
516     ) external view returns (bytes32[] memory);
517 }
518 
519 // File: contracts/interface/IKyberHintHandler.sol
520 
521 pragma solidity ^0.5.0;
522 
523 
524 
525 interface IKyberHintHandler {
526     enum TradeType {
527         BestOfAll,
528         MaskIn,
529         MaskOut,
530         Split
531     }
532 
533     function buildTokenToEthHint(
534         IERC20 tokenSrc,
535         TradeType tokenToEthType,
536         bytes32[] calldata tokenToEthReserveIds,
537         uint256[] calldata tokenToEthSplits
538     ) external view returns (bytes memory hint);
539 
540     function buildEthToTokenHint(
541         IERC20 tokenDest,
542         TradeType ethToTokenType,
543         bytes32[] calldata ethToTokenReserveIds,
544         uint256[] calldata ethToTokenSplits
545     ) external view returns (bytes memory hint);
546 }
547 
548 // File: contracts/interface/IBancorNetwork.sol
549 
550 pragma solidity ^0.5.0;
551 
552 
553 interface IBancorNetwork {
554     function getReturnByPath(address[] calldata path, uint256 amount)
555         external
556         view
557         returns (uint256 returnAmount, uint256 conversionFee);
558 
559     function claimAndConvert(address[] calldata path, uint256 amount, uint256 minReturn)
560         external
561         returns (uint256);
562 
563     function convert(address[] calldata path, uint256 amount, uint256 minReturn)
564         external
565         payable
566         returns (uint256);
567 }
568 
569 // File: contracts/interface/IBancorContractRegistry.sol
570 
571 pragma solidity ^0.5.0;
572 
573 
574 contract IBancorContractRegistry {
575     function addressOf(bytes32 contractName) external view returns (address);
576 }
577 
578 // File: contracts/interface/IBancorNetworkPathFinder.sol
579 
580 pragma solidity ^0.5.0;
581 
582 
583 
584 interface IBancorNetworkPathFinder {
585     function generatePath(IERC20 sourceToken, IERC20 targetToken)
586         external
587         view
588         returns (address[] memory);
589 }
590 
591 // File: contracts/interface/IBancorConverterRegistry.sol
592 
593 pragma solidity ^0.5.0;
594 
595 
596 
597 interface IBancorConverterRegistry {
598 
599     function getConvertibleTokenSmartTokenCount(IERC20 convertibleToken)
600         external view returns(uint256);
601 
602     function getConvertibleTokenSmartTokens(IERC20 convertibleToken)
603         external view returns(address[] memory);
604 
605     function getConvertibleTokenSmartToken(IERC20 convertibleToken, uint256 index)
606         external view returns(address);
607 
608     function isConvertibleTokenSmartToken(IERC20 convertibleToken, address value)
609         external view returns(bool);
610 }
611 
612 // File: contracts/interface/IBancorEtherToken.sol
613 
614 pragma solidity ^0.5.0;
615 
616 
617 
618 contract IBancorEtherToken is IERC20 {
619     function deposit() external payable;
620 
621     function withdraw(uint256 amount) external;
622 }
623 
624 // File: contracts/interface/IBancorFinder.sol
625 
626 pragma solidity ^0.5.0;
627 
628 
629 
630 interface IBancorFinder {
631     function buildBancorPath(
632         IERC20 fromToken,
633         IERC20 destToken
634     )
635         external
636         view
637         returns(address[] memory path);
638 }
639 
640 // File: contracts/interface/IOasisExchange.sol
641 
642 pragma solidity ^0.5.0;
643 
644 
645 
646 interface IOasisExchange {
647     function getBuyAmount(IERC20 buyGem, IERC20 payGem, uint256 payAmt)
648         external
649         view
650         returns (uint256 fillAmt);
651 
652     function sellAllAmount(IERC20 payGem, uint256 payAmt, IERC20 buyGem, uint256 minFillAmount)
653         external
654         returns (uint256 fillAmt);
655 }
656 
657 // File: contracts/interface/IWETH.sol
658 
659 pragma solidity ^0.5.0;
660 
661 
662 
663 contract IWETH is IERC20 {
664     function deposit() external payable;
665 
666     function withdraw(uint256 amount) external;
667 }
668 
669 // File: contracts/interface/ICurve.sol
670 
671 pragma solidity ^0.5.0;
672 
673 
674 interface ICurve {
675     // solium-disable-next-line mixedcase
676     function get_dy_underlying(int128 i, int128 j, uint256 dx) external view returns(uint256 dy);
677 
678     // solium-disable-next-line mixedcase
679     function get_dy(int128 i, int128 j, uint256 dx) external view returns(uint256 dy);
680 
681     // solium-disable-next-line mixedcase
682     function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 minDy) external;
683 
684     // solium-disable-next-line mixedcase
685     function exchange(int128 i, int128 j, uint256 dx, uint256 minDy) external;
686 }
687 
688 
689 contract ICurveRegistry {
690     function get_pool_info(address pool)
691         external
692         view
693         returns(
694             uint256[8] memory balances,
695             uint256[8] memory underlying_balances,
696             uint256[8] memory decimals,
697             uint256[8] memory underlying_decimals,
698             address lp_token,
699             uint256 A,
700             uint256 fee
701         );
702 }
703 
704 
705 contract ICurveCalculator {
706     function get_dy(
707         int128 nCoins,
708         uint256[8] calldata balances,
709         uint256 amp,
710         uint256 fee,
711         uint256[8] calldata rates,
712         uint256[8] calldata precisions,
713         bool underlying,
714         int128 i,
715         int128 j,
716         uint256[100] calldata dx
717     ) external view returns(uint256[100] memory dy);
718 }
719 
720 // File: contracts/interface/IChai.sol
721 
722 pragma solidity ^0.5.0;
723 
724 
725 
726 interface IPot {
727     function dsr() external view returns (uint256);
728 
729     function chi() external view returns (uint256);
730 
731     function rho() external view returns (uint256);
732 
733     function drip() external returns (uint256);
734 
735     function join(uint256) external;
736 
737     function exit(uint256) external;
738 }
739 
740 
741 contract IChai is IERC20 {
742     function POT() public view returns (IPot);
743 
744     function join(address dst, uint256 wad) external;
745 
746     function exit(address src, uint256 wad) external;
747 }
748 
749 
750 library ChaiHelper {
751     IPot private constant POT = IPot(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);
752     uint256 private constant RAY = 10**27;
753 
754     function _mul(uint256 x, uint256 y) private pure returns (uint256 z) {
755         require(y == 0 || (z = x * y) / y == x);
756     }
757 
758     function _rmul(uint256 x, uint256 y) private pure returns (uint256 z) {
759         // always rounds down
760         z = _mul(x, y) / RAY;
761     }
762 
763     function _rdiv(uint256 x, uint256 y) private pure returns (uint256 z) {
764         // always rounds down
765         z = _mul(x, RAY) / y;
766     }
767 
768     function rpow(uint256 x, uint256 n, uint256 base) private pure returns (uint256 z) {
769         // solium-disable-next-line security/no-inline-assembly
770         assembly {
771             switch x
772                 case 0 {
773                     switch n
774                         case 0 {
775                             z := base
776                         }
777                         default {
778                             z := 0
779                         }
780                 }
781                 default {
782                     switch mod(n, 2)
783                         case 0 {
784                             z := base
785                         }
786                         default {
787                             z := x
788                         }
789                     let half := div(base, 2) // for rounding.
790                     for {
791                         n := div(n, 2)
792                     } n {
793                         n := div(n, 2)
794                     } {
795                         let xx := mul(x, x)
796                         if iszero(eq(div(xx, x), x)) {
797                             revert(0, 0)
798                         }
799                         let xxRound := add(xx, half)
800                         if lt(xxRound, xx) {
801                             revert(0, 0)
802                         }
803                         x := div(xxRound, base)
804                         if mod(n, 2) {
805                             let zx := mul(z, x)
806                             if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) {
807                                 revert(0, 0)
808                             }
809                             let zxRound := add(zx, half)
810                             if lt(zxRound, zx) {
811                                 revert(0, 0)
812                             }
813                             z := div(zxRound, base)
814                         }
815                     }
816                 }
817         }
818     }
819 
820     function potDrip() private view returns (uint256) {
821         return _rmul(rpow(POT.dsr(), now - POT.rho(), RAY), POT.chi());
822     }
823 
824     function chaiPrice(IChai chai) internal view returns(uint256) {
825         return chaiToDai(chai, 1e18);
826     }
827 
828     function daiToChai(
829         IChai /*chai*/,
830         uint256 amount
831     ) internal view returns (uint256) {
832         uint256 chi = (now > POT.rho()) ? potDrip() : POT.chi();
833         return _rdiv(amount, chi);
834     }
835 
836     function chaiToDai(
837         IChai /*chai*/,
838         uint256 amount
839     ) internal view returns (uint256) {
840         uint256 chi = (now > POT.rho()) ? potDrip() : POT.chi();
841         return _rmul(chi, amount);
842     }
843 }
844 
845 // File: contracts/interface/ICompound.sol
846 
847 pragma solidity ^0.5.0;
848 
849 
850 
851 contract ICompound {
852     function markets(address cToken)
853         external
854         view
855         returns (bool isListed, uint256 collateralFactorMantissa);
856 }
857 
858 
859 contract ICompoundToken is IERC20 {
860     function underlying() external view returns (address);
861 
862     function exchangeRateStored() external view returns (uint256);
863 
864     function mint(uint256 mintAmount) external returns (uint256);
865 
866     function redeem(uint256 redeemTokens) external returns (uint256);
867 }
868 
869 
870 contract ICompoundEther is IERC20 {
871     function mint() external payable;
872 
873     function redeem(uint256 redeemTokens) external returns (uint256);
874 }
875 
876 // File: contracts/interface/ICompoundRegistry.sol
877 
878 pragma solidity ^0.5.0;
879 
880 
881 
882 
883 contract ICompoundRegistry {
884     function tokenByCToken(ICompoundToken cToken) external view returns(IERC20);
885     function cTokenByToken(IERC20 token) external view returns(ICompoundToken);
886 }
887 
888 // File: contracts/interface/IAaveToken.sol
889 
890 pragma solidity ^0.5.0;
891 
892 
893 
894 contract IAaveToken is IERC20 {
895     function underlyingAssetAddress() external view returns (IERC20);
896 
897     function redeem(uint256 amount) external;
898 }
899 
900 
901 interface IAaveLendingPool {
902     function core() external view returns (address);
903 
904     function deposit(IERC20 token, uint256 amount, uint16 refCode) external payable;
905 }
906 
907 // File: contracts/interface/IAaveRegistry.sol
908 
909 pragma solidity ^0.5.0;
910 
911 
912 
913 
914 contract IAaveRegistry {
915     function tokenByAToken(IAaveToken aToken) external view returns(IERC20);
916     function aTokenByToken(IERC20 token) external view returns(IAaveToken);
917 }
918 
919 // File: contracts/interface/IMooniswap.sol
920 
921 pragma solidity ^0.5.0;
922 
923 
924 
925 interface IMooniswapRegistry {
926     function pools(IERC20 token1, IERC20 token2) external view returns(IMooniswap);
927     function isPool(address addr) external view returns(bool);
928 }
929 
930 
931 interface IMooniswap {
932     function fee() external view returns (uint256);
933 
934     function tokens(uint256 i) external view returns (IERC20);
935 
936     function deposit(uint256[] calldata amounts, uint256[] calldata minAmounts) external payable returns(uint256 fairSupply);
937 
938     function withdraw(uint256 amount, uint256[] calldata minReturns) external;
939 
940     function getBalanceForAddition(IERC20 token) external view returns(uint256);
941 
942     function getBalanceForRemoval(IERC20 token) external view returns(uint256);
943 
944     function getReturn(
945         IERC20 fromToken,
946         IERC20 destToken,
947         uint256 amount
948     )
949         external
950         view
951         returns(uint256 returnAmount);
952 
953     function swap(
954         IERC20 fromToken,
955         IERC20 destToken,
956         uint256 amount,
957         uint256 minReturn,
958         address referral
959     )
960         external
961         payable
962         returns(uint256 returnAmount);
963 }
964 
965 // File: @openzeppelin/contracts/math/Math.sol
966 
967 pragma solidity ^0.5.0;
968 
969 /**
970  * @dev Standard math utilities missing in the Solidity language.
971  */
972 library Math {
973     /**
974      * @dev Returns the largest of two numbers.
975      */
976     function max(uint256 a, uint256 b) internal pure returns (uint256) {
977         return a >= b ? a : b;
978     }
979 
980     /**
981      * @dev Returns the smallest of two numbers.
982      */
983     function min(uint256 a, uint256 b) internal pure returns (uint256) {
984         return a < b ? a : b;
985     }
986 
987     /**
988      * @dev Returns the average of two numbers. The result is rounded towards
989      * zero.
990      */
991     function average(uint256 a, uint256 b) internal pure returns (uint256) {
992         // (a + b) / 2 can overflow, so we distribute
993         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
994     }
995 }
996 
997 // File: @openzeppelin/contracts/utils/Address.sol
998 
999 pragma solidity ^0.5.5;
1000 
1001 /**
1002  * @dev Collection of functions related to the address type
1003  */
1004 library Address {
1005     /**
1006      * @dev Returns true if `account` is a contract.
1007      *
1008      * [IMPORTANT]
1009      * ====
1010      * It is unsafe to assume that an address for which this function returns
1011      * false is an externally-owned account (EOA) and not a contract.
1012      *
1013      * Among others, `isContract` will return false for the following 
1014      * types of addresses:
1015      *
1016      *  - an externally-owned account
1017      *  - a contract in construction
1018      *  - an address where a contract will be created
1019      *  - an address where a contract lived, but was destroyed
1020      * ====
1021      */
1022     function isContract(address account) internal view returns (bool) {
1023         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1024         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1025         // for accounts without code, i.e. `keccak256('')`
1026         bytes32 codehash;
1027         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1028         // solhint-disable-next-line no-inline-assembly
1029         assembly { codehash := extcodehash(account) }
1030         return (codehash != accountHash && codehash != 0x0);
1031     }
1032 
1033     /**
1034      * @dev Converts an `address` into `address payable`. Note that this is
1035      * simply a type cast: the actual underlying value is not changed.
1036      *
1037      * _Available since v2.4.0._
1038      */
1039     function toPayable(address account) internal pure returns (address payable) {
1040         return address(uint160(account));
1041     }
1042 
1043     /**
1044      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1045      * `recipient`, forwarding all available gas and reverting on errors.
1046      *
1047      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1048      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1049      * imposed by `transfer`, making them unable to receive funds via
1050      * `transfer`. {sendValue} removes this limitation.
1051      *
1052      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1053      *
1054      * IMPORTANT: because control is transferred to `recipient`, care must be
1055      * taken to not create reentrancy vulnerabilities. Consider using
1056      * {ReentrancyGuard} or the
1057      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1058      *
1059      * _Available since v2.4.0._
1060      */
1061     function sendValue(address payable recipient, uint256 amount) internal {
1062         require(address(this).balance >= amount, "Address: insufficient balance");
1063 
1064         // solhint-disable-next-line avoid-call-value
1065         (bool success, ) = recipient.call.value(amount)("");
1066         require(success, "Address: unable to send value, recipient may have reverted");
1067     }
1068 }
1069 
1070 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1071 
1072 pragma solidity ^0.5.0;
1073 
1074 
1075 
1076 
1077 /**
1078  * @title SafeERC20
1079  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1080  * contract returns false). Tokens that return no value (and instead revert or
1081  * throw on failure) are also supported, non-reverting calls are assumed to be
1082  * successful.
1083  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1084  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1085  */
1086 library SafeERC20 {
1087     using SafeMath for uint256;
1088     using Address for address;
1089 
1090     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1091         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1092     }
1093 
1094     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1095         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1096     }
1097 
1098     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1099         // safeApprove should only be called when setting an initial allowance,
1100         // or when resetting it to zero. To increase and decrease it, use
1101         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1102         // solhint-disable-next-line max-line-length
1103         require((value == 0) || (token.allowance(address(this), spender) == 0),
1104             "SafeERC20: approve from non-zero to non-zero allowance"
1105         );
1106         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1107     }
1108 
1109     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1110         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1111         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1112     }
1113 
1114     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1115         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1116         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1117     }
1118 
1119     /**
1120      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1121      * on the return value: the return value is optional (but if data is returned, it must not be false).
1122      * @param token The token targeted by the call.
1123      * @param data The call data (encoded using abi.encode or one of its variants).
1124      */
1125     function callOptionalReturn(IERC20 token, bytes memory data) private {
1126         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1127         // we're implementing it ourselves.
1128 
1129         // A Solidity high level call has three parts:
1130         //  1. The target address is checked to verify it contains contract code
1131         //  2. The call itself is made, and success asserted
1132         //  3. The return value is decoded, which in turn checks the size of the returned data.
1133         // solhint-disable-next-line max-line-length
1134         require(address(token).isContract(), "SafeERC20: call to non-contract");
1135 
1136         // solhint-disable-next-line avoid-low-level-calls
1137         (bool success, bytes memory returndata) = address(token).call(data);
1138         require(success, "SafeERC20: low-level call failed");
1139 
1140         if (returndata.length > 0) { // Return data is optional
1141             // solhint-disable-next-line max-line-length
1142             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1143         }
1144     }
1145 }
1146 
1147 // File: contracts/UniversalERC20.sol
1148 
1149 pragma solidity ^0.5.0;
1150 
1151 
1152 
1153 
1154 
1155 library UniversalERC20 {
1156 
1157     using SafeMath for uint256;
1158     using SafeERC20 for IERC20;
1159 
1160     IERC20 private constant ZERO_ADDRESS = IERC20(0x0000000000000000000000000000000000000000);
1161     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1162 
1163     function universalTransfer(IERC20 token, address to, uint256 amount) internal returns(bool) {
1164         if (amount == 0) {
1165             return true;
1166         }
1167 
1168         if (isETH(token)) {
1169             address(uint160(to)).transfer(amount);
1170         } else {
1171             token.safeTransfer(to, amount);
1172             return true;
1173         }
1174     }
1175 
1176     function universalTransferFrom(IERC20 token, address from, address to, uint256 amount) internal {
1177         if (amount == 0) {
1178             return;
1179         }
1180 
1181         if (isETH(token)) {
1182             require(from == msg.sender && msg.value >= amount, "Wrong useage of ETH.universalTransferFrom()");
1183             if (to != address(this)) {
1184                 address(uint160(to)).transfer(amount);
1185             }
1186             if (msg.value > amount) {
1187                 msg.sender.transfer(msg.value.sub(amount));
1188             }
1189         } else {
1190             token.safeTransferFrom(from, to, amount);
1191         }
1192     }
1193 
1194     function universalTransferFromSenderToThis(IERC20 token, uint256 amount) internal {
1195         if (amount == 0) {
1196             return;
1197         }
1198 
1199         if (isETH(token)) {
1200             if (msg.value > amount) {
1201                 // Return remainder if exist
1202                 msg.sender.transfer(msg.value.sub(amount));
1203             }
1204         } else {
1205             token.safeTransferFrom(msg.sender, address(this), amount);
1206         }
1207     }
1208 
1209     function universalApprove(IERC20 token, address to, uint256 amount) internal {
1210         if (!isETH(token)) {
1211             if (amount == 0) {
1212                 token.safeApprove(to, 0);
1213                 return;
1214             }
1215 
1216             uint256 allowance = token.allowance(address(this), to);
1217             if (allowance < amount) {
1218                 if (allowance > 0) {
1219                     token.safeApprove(to, 0);
1220                 }
1221                 token.safeApprove(to, amount);
1222             }
1223         }
1224     }
1225 
1226     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
1227         if (isETH(token)) {
1228             return who.balance;
1229         } else {
1230             return token.balanceOf(who);
1231         }
1232     }
1233 
1234     function universalDecimals(IERC20 token) internal view returns (uint256) {
1235 
1236         if (isETH(token)) {
1237             return 18;
1238         }
1239 
1240         (bool success, bytes memory data) = address(token).staticcall.gas(10000)(
1241             abi.encodeWithSignature("decimals()")
1242         );
1243         if (!success || data.length == 0) {
1244             (success, data) = address(token).staticcall.gas(10000)(
1245                 abi.encodeWithSignature("DECIMALS()")
1246             );
1247         }
1248 
1249         return (success && data.length > 0) ? abi.decode(data, (uint256)) : 18;
1250     }
1251 
1252     function isETH(IERC20 token) internal pure returns(bool) {
1253         return (address(token) == address(ZERO_ADDRESS) || address(token) == address(ETH_ADDRESS));
1254     }
1255 
1256     function eq(IERC20 a, IERC20 b) internal pure returns(bool) {
1257         return a == b || (isETH(a) && isETH(b));
1258     }
1259 
1260     function notExist(IERC20 token) internal pure returns(bool) {
1261         return (address(token) == address(-1));
1262     }
1263 }
1264 
1265 // File: contracts/interface/IUniswapV2Exchange.sol
1266 
1267 pragma solidity ^0.5.0;
1268 
1269 
1270 
1271 
1272 
1273 
1274 interface IUniswapV2Exchange {
1275     function getReserves() external view returns(uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
1276     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1277     function skim(address to) external;
1278     function sync() external;
1279 }
1280 
1281 
1282 library UniswapV2ExchangeLib {
1283     using Math for uint256;
1284     using SafeMath for uint256;
1285     using UniversalERC20 for IERC20;
1286 
1287     function getReturn(
1288         IUniswapV2Exchange exchange,
1289         IERC20 fromToken,
1290         IERC20 destToken,
1291         uint amountIn
1292     ) internal view returns (uint256 result, bool needSync, bool needSkim) {
1293         uint256 reserveIn = fromToken.universalBalanceOf(address(exchange));
1294         uint256 reserveOut = destToken.universalBalanceOf(address(exchange));
1295         (uint112 reserve0, uint112 reserve1,) = exchange.getReserves();
1296         if (fromToken > destToken) {
1297             (reserve0, reserve1) = (reserve1, reserve0);
1298         }
1299         needSync = (reserveIn < reserve0 || reserveOut < reserve1);
1300         needSkim = !needSync && (reserveIn > reserve0 || reserveOut > reserve1);
1301 
1302         uint256 amountInWithFee = amountIn.mul(997);
1303         uint256 numerator = amountInWithFee.mul(Math.min(reserveOut, reserve1));
1304         uint256 denominator = Math.min(reserveIn, reserve0).mul(1000).add(amountInWithFee);
1305         result = (denominator == 0) ? 0 : numerator.div(denominator);
1306     }
1307 }
1308 
1309 // File: contracts/interface/IUniswapV2Factory.sol
1310 
1311 pragma solidity ^0.5.0;
1312 
1313 
1314 
1315 interface IUniswapV2Factory {
1316     function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (IUniswapV2Exchange pair);
1317 }
1318 
1319 // File: contracts/interface/IDForceSwap.sol
1320 
1321 pragma solidity ^0.5.0;
1322 
1323 
1324 
1325 interface IDForceSwap {
1326     function getAmountByInput(IERC20 input, IERC20 output, uint256 amount) external view returns(uint256);
1327     function swap(IERC20 input, IERC20 output, uint256 amount) external;
1328 }
1329 
1330 // File: contracts/interface/IShell.sol
1331 
1332 pragma solidity ^0.5.0;
1333 
1334 
1335 interface IShell {
1336     function viewOriginTrade(
1337         address origin,
1338         address target,
1339         uint256 originAmount
1340     ) external view returns (uint256);
1341 
1342     function swapByOrigin(
1343         address origin,
1344         address target,
1345         uint256 originAmount,
1346         uint256 minTargetAmount,
1347         uint256 deadline
1348     ) external returns (uint256);
1349 }
1350 
1351 // File: contracts/interface/IMStable.sol
1352 
1353 pragma solidity ^0.5.0;
1354 
1355 
1356 
1357 contract IMStable is IERC20 {
1358     function getSwapOutput(
1359         IERC20 _input,
1360         IERC20 _output,
1361         uint256 _quantity
1362     )
1363         external
1364         view
1365         returns (bool, string memory, uint256 output);
1366 
1367     function swap(
1368         IERC20 _input,
1369         IERC20 _output,
1370         uint256 _quantity,
1371         address _recipient
1372     )
1373         external
1374         returns (uint256 output);
1375 
1376     function redeem(
1377         IERC20 _basset,
1378         uint256 _bassetQuantity
1379     )
1380         external
1381         returns (uint256 massetRedeemed);
1382 }
1383 
1384 interface IMassetValidationHelper {
1385     /**
1386      * @dev Returns a valid bAsset to redeem
1387      * @param _mAsset Masset addr
1388      * @return valid bool
1389      * @return string message
1390      * @return address of bAsset to redeem
1391      */
1392     function suggestRedeemAsset(
1393         IERC20 _mAsset
1394     )
1395         external
1396         view
1397         returns (
1398             bool valid,
1399             string memory err,
1400             address token
1401         );
1402 
1403     /**
1404      * @dev Returns a valid bAsset with which to mint
1405      * @param _mAsset Masset addr
1406      * @return valid bool
1407      * @return string message
1408      * @return address of bAsset to mint
1409      */
1410     function suggestMintAsset(
1411         IERC20 _mAsset
1412     )
1413         external
1414         view
1415         returns (
1416             bool valid,
1417             string memory err,
1418             address token
1419         );
1420 
1421     /**
1422      * @dev Determines if a given Redemption is valid
1423      * @param _mAsset Address of the given mAsset (e.g. mUSD)
1424      * @param _mAssetQuantity Amount of mAsset to redeem (in mUSD units)
1425      * @param _outputBasset Desired output bAsset
1426      * @return valid
1427      * @return validity reason
1428      * @return output in bAsset units
1429      * @return bAssetQuantityArg - required input argument to the 'redeem' call
1430      */
1431     function getRedeemValidity(
1432         IERC20 _mAsset,
1433         uint256 _mAssetQuantity,
1434         IERC20 _outputBasset
1435     )
1436         external
1437         view
1438         returns (
1439             bool valid,
1440             string memory,
1441             uint256 output,
1442             uint256 bassetQuantityArg
1443         );
1444 }
1445 
1446 // File: contracts/interface/IBalancerPool.sol
1447 
1448 pragma solidity ^0.5.0;
1449 
1450 
1451 
1452 interface IBalancerPool {
1453     function getSwapFee()
1454         external view returns (uint256 balance);
1455 
1456     function getDenormalizedWeight(IERC20 token)
1457         external view returns (uint256 balance);
1458 
1459     function getBalance(IERC20 token)
1460         external view returns (uint256 balance);
1461 
1462     function swapExactAmountIn(
1463         IERC20 tokenIn,
1464         uint256 tokenAmountIn,
1465         IERC20 tokenOut,
1466         uint256 minAmountOut,
1467         uint256 maxPrice
1468     )
1469         external
1470         returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
1471 }
1472 
1473 
1474 // 0xA961672E8Db773be387e775bc4937C678F3ddF9a
1475 interface IBalancerHelper {
1476     function getReturns(
1477         IBalancerPool pool,
1478         IERC20 fromToken,
1479         IERC20 destToken,
1480         uint256[] calldata amounts
1481     )
1482         external
1483         view
1484         returns(uint256[] memory rets);
1485 }
1486 
1487 // File: contracts/interface/IBalancerRegistry.sol
1488 
1489 pragma solidity ^0.5.0;
1490 
1491 
1492 
1493 
1494 interface IBalancerRegistry {
1495     event PoolAdded(
1496         address indexed pool
1497     );
1498     event PoolTokenPairAdded(
1499         address indexed pool,
1500         address indexed fromToken,
1501         address indexed destToken
1502     );
1503     event IndicesUpdated(
1504         address indexed fromToken,
1505         address indexed destToken,
1506         bytes32 oldIndices,
1507         bytes32 newIndices
1508     );
1509 
1510     // Get info about pool pair for 1 SLOAD
1511     function getPairInfo(address pool, address fromToken, address destToken)
1512         external view returns(uint256 weight1, uint256 weight2, uint256 swapFee);
1513 
1514     // Pools
1515     function checkAddedPools(address pool)
1516         external view returns(bool);
1517     function getAddedPoolsLength()
1518         external view returns(uint256);
1519     function getAddedPools()
1520         external view returns(address[] memory);
1521     function getAddedPoolsWithLimit(uint256 offset, uint256 limit)
1522         external view returns(address[] memory result);
1523 
1524     // Tokens
1525     function getAllTokensLength()
1526         external view returns(uint256);
1527     function getAllTokens()
1528         external view returns(address[] memory);
1529     function getAllTokensWithLimit(uint256 offset, uint256 limit)
1530         external view returns(address[] memory result);
1531 
1532     // Pairs
1533     function getPoolsLength(address fromToken, address destToken)
1534         external view returns(uint256);
1535     function getPools(address fromToken, address destToken)
1536         external view returns(address[] memory);
1537     function getPoolsWithLimit(address fromToken, address destToken, uint256 offset, uint256 limit)
1538         external view returns(address[] memory result);
1539     function getBestPools(address fromToken, address destToken)
1540         external view returns(address[] memory pools);
1541     function getBestPoolsWithLimit(address fromToken, address destToken, uint256 limit)
1542         external view returns(address[] memory pools);
1543 
1544     // Get swap rates
1545     function getPoolReturn(address pool, address fromToken, address destToken, uint256 amount)
1546         external view returns(uint256);
1547     function getPoolReturns(address pool, address fromToken, address destToken, uint256[] calldata amounts)
1548         external view returns(uint256[] memory result);
1549 
1550     // Add and update registry
1551     function addPool(address pool) external returns(uint256 listed);
1552     function addPools(address[] calldata pools) external returns(uint256[] memory listed);
1553     function updatedIndices(address[] calldata tokens, uint256 lengthLimit) external;
1554 }
1555 
1556 // File: contracts/BalancerLib.sol
1557 
1558 pragma solidity ^0.5.0;
1559 
1560 
1561 library BalancerLib {
1562     uint public constant BONE              = 10**18;
1563 
1564     uint public constant MIN_BOUND_TOKENS  = 2;
1565     uint public constant MAX_BOUND_TOKENS  = 8;
1566 
1567     uint public constant MIN_FEE           = BONE / 10**6;
1568     uint public constant MAX_FEE           = BONE / 10;
1569     uint public constant EXIT_FEE          = 0;
1570 
1571     uint public constant MIN_WEIGHT        = BONE;
1572     uint public constant MAX_WEIGHT        = BONE * 50;
1573     uint public constant MAX_TOTAL_WEIGHT  = BONE * 50;
1574     uint public constant MIN_BALANCE       = BONE / 10**12;
1575 
1576     uint public constant INIT_POOL_SUPPLY  = BONE * 100;
1577 
1578     uint public constant MIN_BPOW_BASE     = 1 wei;
1579     uint public constant MAX_BPOW_BASE     = (2 * BONE) - 1 wei;
1580     uint public constant BPOW_PRECISION    = BONE / 10**10;
1581 
1582     uint public constant MAX_IN_RATIO      = BONE / 2;
1583     uint public constant MAX_OUT_RATIO     = (BONE / 3) + 1 wei;
1584 
1585     function btoi(uint a)
1586         internal pure
1587         returns (uint)
1588     {
1589         return a / BONE;
1590     }
1591 
1592     function bfloor(uint a)
1593         internal pure
1594         returns (uint)
1595     {
1596         return btoi(a) * BONE;
1597     }
1598 
1599     function badd(uint a, uint b)
1600         internal pure
1601         returns (uint)
1602     {
1603         uint c = a + b;
1604         require(c >= a, "ERR_ADD_OVERFLOW");
1605         return c;
1606     }
1607 
1608     function bsub(uint a, uint b)
1609         internal pure
1610         returns (uint)
1611     {
1612         (uint c, bool flag) = bsubSign(a, b);
1613         require(!flag, "ERR_SUB_UNDERFLOW");
1614         return c;
1615     }
1616 
1617     function bsubSign(uint a, uint b)
1618         internal pure
1619         returns (uint, bool)
1620     {
1621         if (a >= b) {
1622             return (a - b, false);
1623         } else {
1624             return (b - a, true);
1625         }
1626     }
1627 
1628     function bmul(uint a, uint b)
1629         internal pure
1630         returns (uint)
1631     {
1632         uint c0 = a * b;
1633         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
1634         uint c1 = c0 + (BONE / 2);
1635         require(c1 >= c0, "ERR_MUL_OVERFLOW");
1636         uint c2 = c1 / BONE;
1637         return c2;
1638     }
1639 
1640     function bdiv(uint a, uint b)
1641         internal pure
1642         returns (uint)
1643     {
1644         require(b != 0, "ERR_DIV_ZERO");
1645         uint c0 = a * BONE;
1646         require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow
1647         uint c1 = c0 + (b / 2);
1648         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
1649         uint c2 = c1 / b;
1650         return c2;
1651     }
1652 
1653     // DSMath.wpow
1654     function bpowi(uint a, uint n)
1655         internal pure
1656         returns (uint)
1657     {
1658         uint z = n % 2 != 0 ? a : BONE;
1659 
1660         for (n /= 2; n != 0; n /= 2) {
1661             a = bmul(a, a);
1662 
1663             if (n % 2 != 0) {
1664                 z = bmul(z, a);
1665             }
1666         }
1667         return z;
1668     }
1669 
1670     // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).
1671     // Use `bpowi` for `b^e` and `bpowK` for k iterations
1672     // of approximation of b^0.w
1673     function bpow(uint base, uint exp)
1674         internal pure
1675         returns (uint)
1676     {
1677         require(base >= MIN_BPOW_BASE, "ERR_BPOW_BASE_TOO_LOW");
1678         require(base <= MAX_BPOW_BASE, "ERR_BPOW_BASE_TOO_HIGH");
1679 
1680         uint whole  = bfloor(exp);
1681         uint remain = bsub(exp, whole);
1682 
1683         uint wholePow = bpowi(base, btoi(whole));
1684 
1685         if (remain == 0) {
1686             return wholePow;
1687         }
1688 
1689         uint partialResult = bpowApprox(base, remain, BPOW_PRECISION);
1690         return bmul(wholePow, partialResult);
1691     }
1692 
1693     function bpowApprox(uint base, uint exp, uint precision)
1694         internal pure
1695         returns (uint)
1696     {
1697         // term 0:
1698         uint a     = exp;
1699         (uint x, bool xneg)  = bsubSign(base, BONE);
1700         uint term = BONE;
1701         uint sum   = term;
1702         bool negative = false;
1703 
1704 
1705         // term(k) = numer / denom
1706         //         = (product(a - i - 1, i=1-->k) * x^k) / (k!)
1707         // each iteration, multiply previous term by (a-(k-1)) * x / k
1708         // continue until term is less than precision
1709         for (uint i = 1; term >= precision; i++) {
1710             uint bigK = i * BONE;
1711             (uint c, bool cneg) = bsubSign(a, bsub(bigK, BONE));
1712             term = bmul(term, bmul(c, x));
1713             term = bdiv(term, bigK);
1714             if (term == 0) break;
1715 
1716             if (xneg) negative = !negative;
1717             if (cneg) negative = !negative;
1718             if (negative) {
1719                 sum = bsub(sum, term);
1720             } else {
1721                 sum = badd(sum, term);
1722             }
1723         }
1724 
1725         return sum;
1726     }
1727 
1728     /**********************************************************************************************
1729     // calcSpotPrice                                                                             //
1730     // sP = spotPrice                                                                            //
1731     // bI = tokenBalanceIn                ( bI / wI )         1                                  //
1732     // bO = tokenBalanceOut         sP =  -----------  *  ----------                             //
1733     // wI = tokenWeightIn                 ( bO / wO )     ( 1 - sF )                             //
1734     // wO = tokenWeightOut                                                                       //
1735     // sF = swapFee                                                                              //
1736     **********************************************************************************************/
1737     function calcSpotPrice(
1738         uint tokenBalanceIn,
1739         uint tokenWeightIn,
1740         uint tokenBalanceOut,
1741         uint tokenWeightOut,
1742         uint swapFee
1743     )
1744         internal pure
1745         returns (uint spotPrice)
1746     {
1747         uint numer = bdiv(tokenBalanceIn, tokenWeightIn);
1748         uint denom = bdiv(tokenBalanceOut, tokenWeightOut);
1749         uint ratio = bdiv(numer, denom);
1750         uint scale = bdiv(BONE, bsub(BONE, swapFee));
1751         return  (spotPrice = bmul(ratio, scale));
1752     }
1753 
1754     /**********************************************************************************************
1755     // calcOutGivenIn                                                                            //
1756     // aO = tokenAmountOut                                                                       //
1757     // bO = tokenBalanceOut                                                                      //
1758     // bI = tokenBalanceIn              /      /            bI             \    (wI / wO) \      //
1759     // aI = tokenAmountIn    aO = bO * |  1 - | --------------------------  | ^            |     //
1760     // wI = tokenWeightIn               \      \ ( bI + ( aI * ( 1 - sF )) /              /      //
1761     // wO = tokenWeightOut                                                                       //
1762     // sF = swapFee                                                                              //
1763     **********************************************************************************************/
1764     function calcOutGivenIn(
1765         uint tokenBalanceIn,
1766         uint tokenWeightIn,
1767         uint tokenBalanceOut,
1768         uint tokenWeightOut,
1769         uint tokenAmountIn,
1770         uint swapFee
1771     )
1772         internal pure
1773         returns (uint tokenAmountOut)
1774     {
1775         uint weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
1776         uint adjustedIn = bsub(BONE, swapFee);
1777         adjustedIn = bmul(tokenAmountIn, adjustedIn);
1778         uint y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
1779         if (y == 0) {
1780             return 0;
1781         }
1782         uint foo = bpow(y, weightRatio);
1783         uint bar = bsub(BONE, foo);
1784         tokenAmountOut = bmul(tokenBalanceOut, bar);
1785         return tokenAmountOut;
1786     }
1787 
1788     /**********************************************************************************************
1789     // calcInGivenOut                                                                            //
1790     // aI = tokenAmountIn                                                                        //
1791     // bO = tokenBalanceOut               /  /     bO      \    (wO / wI)      \                 //
1792     // bI = tokenBalanceIn          bI * |  | ------------  | ^            - 1  |                //
1793     // aO = tokenAmountOut    aI =        \  \ ( bO - aO ) /                   /                 //
1794     // wI = tokenWeightIn           --------------------------------------------                 //
1795     // wO = tokenWeightOut                          ( 1 - sF )                                   //
1796     // sF = swapFee                                                                              //
1797     **********************************************************************************************/
1798     function calcInGivenOut(
1799         uint tokenBalanceIn,
1800         uint tokenWeightIn,
1801         uint tokenBalanceOut,
1802         uint tokenWeightOut,
1803         uint tokenAmountOut,
1804         uint swapFee
1805     )
1806         internal pure
1807         returns (uint tokenAmountIn)
1808     {
1809         uint weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
1810         uint diff = bsub(tokenBalanceOut, tokenAmountOut);
1811         uint y = bdiv(tokenBalanceOut, diff);
1812         if (y == 0) {
1813             return 0;
1814         }
1815         uint foo = bpow(y, weightRatio);
1816         foo = bsub(foo, BONE);
1817         tokenAmountIn = bsub(BONE, swapFee);
1818         tokenAmountIn = bdiv(bmul(tokenBalanceIn, foo), tokenAmountIn);
1819         return tokenAmountIn;
1820     }
1821 
1822     /**********************************************************************************************
1823     // calcPoolOutGivenSingleIn                                                                  //
1824     // pAo = poolAmountOut         /                                              \              //
1825     // tAi = tokenAmountIn        ///      /     //    wI \      \\       \     wI \             //
1826     // wI = tokenWeightIn        //| tAi *| 1 - || 1 - --  | * sF || + tBi \    --  \            //
1827     // tW = totalWeight     pAo=||  \      \     \\    tW /      //         | ^ tW   | * pS - pS //
1828     // tBi = tokenBalanceIn      \\  ------------------------------------- /        /            //
1829     // pS = poolSupply            \\                    tBi               /        /             //
1830     // sF = swapFee                \                                              /              //
1831     **********************************************************************************************/
1832     function calcPoolOutGivenSingleIn(
1833         uint tokenBalanceIn,
1834         uint tokenWeightIn,
1835         uint poolSupply,
1836         uint totalWeight,
1837         uint tokenAmountIn,
1838         uint swapFee
1839     )
1840         internal pure
1841         returns (uint poolAmountOut)
1842     {
1843         // Charge the trading fee for the proportion of tokenAi
1844         ///  which is implicitly traded to the other pool tokens.
1845         // That proportion is (1- weightTokenIn)
1846         // tokenAiAfterFee = tAi * (1 - (1-weightTi) * poolFee);
1847         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
1848         uint zaz = bmul(bsub(BONE, normalizedWeight), swapFee);
1849         uint tokenAmountInAfterFee = bmul(tokenAmountIn, bsub(BONE, zaz));
1850 
1851         uint newTokenBalanceIn = badd(tokenBalanceIn, tokenAmountInAfterFee);
1852         uint tokenInRatio = bdiv(newTokenBalanceIn, tokenBalanceIn);
1853 
1854         // uint newPoolSupply = (ratioTi ^ weightTi) * poolSupply;
1855         uint poolRatio = bpow(tokenInRatio, normalizedWeight);
1856         uint newPoolSupply = bmul(poolRatio, poolSupply);
1857         poolAmountOut = bsub(newPoolSupply, poolSupply);
1858         return poolAmountOut;
1859     }
1860 
1861     /**********************************************************************************************
1862     // calcSingleInGivenPoolOut                                                                  //
1863     // tAi = tokenAmountIn              //(pS + pAo)\     /    1    \\                           //
1864     // pS = poolSupply                 || ---------  | ^ | --------- || * bI - bI                //
1865     // pAo = poolAmountOut              \\    pS    /     \(wI / tW)//                           //
1866     // bI = balanceIn          tAi =  --------------------------------------------               //
1867     // wI = weightIn                              /      wI  \                                   //
1868     // tW = totalWeight                          |  1 - ----  |  * sF                            //
1869     // sF = swapFee                               \      tW  /                                   //
1870     **********************************************************************************************/
1871     function calcSingleInGivenPoolOut(
1872         uint tokenBalanceIn,
1873         uint tokenWeightIn,
1874         uint poolSupply,
1875         uint totalWeight,
1876         uint poolAmountOut,
1877         uint swapFee
1878     )
1879         internal pure
1880         returns (uint tokenAmountIn)
1881     {
1882         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
1883         uint newPoolSupply = badd(poolSupply, poolAmountOut);
1884         uint poolRatio = bdiv(newPoolSupply, poolSupply);
1885 
1886         //uint newBalTi = poolRatio^(1/weightTi) * balTi;
1887         uint boo = bdiv(BONE, normalizedWeight);
1888         uint tokenInRatio = bpow(poolRatio, boo);
1889         uint newTokenBalanceIn = bmul(tokenInRatio, tokenBalanceIn);
1890         uint tokenAmountInAfterFee = bsub(newTokenBalanceIn, tokenBalanceIn);
1891         // Do reverse order of fees charged in joinswap_ExternAmountIn, this way
1892         //     ``` pAo == joinswap_ExternAmountIn(Ti, joinswap_PoolAmountOut(pAo, Ti)) ```
1893         //uint tAi = tAiAfterFee / (1 - (1-weightTi) * swapFee) ;
1894         uint zar = bmul(bsub(BONE, normalizedWeight), swapFee);
1895         tokenAmountIn = bdiv(tokenAmountInAfterFee, bsub(BONE, zar));
1896         return tokenAmountIn;
1897     }
1898 
1899     /**********************************************************************************************
1900     // calcSingleOutGivenPoolIn                                                                  //
1901     // tAo = tokenAmountOut            /      /                                             \\   //
1902     // bO = tokenBalanceOut           /      // pS - (pAi * (1 - eF)) \     /    1    \      \\  //
1903     // pAi = poolAmountIn            | bO - || ----------------------- | ^ | --------- | * b0 || //
1904     // ps = poolSupply                \      \\          pS           /     \(wO / tW)/      //  //
1905     // wI = tokenWeightIn      tAo =   \      \                                             //   //
1906     // tW = totalWeight                    /     /      wO \       \                             //
1907     // sF = swapFee                    *  | 1 - |  1 - ---- | * sF  |                            //
1908     // eF = exitFee                        \     \      tW /       /                             //
1909     **********************************************************************************************/
1910     function calcSingleOutGivenPoolIn(
1911         uint tokenBalanceOut,
1912         uint tokenWeightOut,
1913         uint poolSupply,
1914         uint totalWeight,
1915         uint poolAmountIn,
1916         uint swapFee
1917     )
1918         internal pure
1919         returns (uint tokenAmountOut)
1920     {
1921         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
1922         // charge exit fee on the pool token side
1923         // pAiAfterExitFee = pAi*(1-exitFee)
1924         uint poolAmountInAfterExitFee = bmul(poolAmountIn, bsub(BONE, EXIT_FEE));
1925         uint newPoolSupply = bsub(poolSupply, poolAmountInAfterExitFee);
1926         uint poolRatio = bdiv(newPoolSupply, poolSupply);
1927 
1928         // newBalTo = poolRatio^(1/weightTo) * balTo;
1929         uint tokenOutRatio = bpow(poolRatio, bdiv(BONE, normalizedWeight));
1930         uint newTokenBalanceOut = bmul(tokenOutRatio, tokenBalanceOut);
1931 
1932         uint tokenAmountOutBeforeSwapFee = bsub(tokenBalanceOut, newTokenBalanceOut);
1933 
1934         // charge swap fee on the output token side
1935         //uint tAo = tAoBeforeSwapFee * (1 - (1-weightTo) * swapFee)
1936         uint zaz = bmul(bsub(BONE, normalizedWeight), swapFee);
1937         tokenAmountOut = bmul(tokenAmountOutBeforeSwapFee, bsub(BONE, zaz));
1938         return tokenAmountOut;
1939     }
1940 
1941     /**********************************************************************************************
1942     // calcPoolInGivenSingleOut                                                                  //
1943     // pAi = poolAmountIn               // /               tAo             \\     / wO \     \   //
1944     // bO = tokenBalanceOut            // | bO - -------------------------- |\   | ---- |     \  //
1945     // tAo = tokenAmountOut      pS - ||   \     1 - ((1 - (tO / tW)) * sF)/  | ^ \ tW /  * pS | //
1946     // ps = poolSupply                 \\ -----------------------------------/                /  //
1947     // wO = tokenWeightOut  pAi =       \\               bO                 /                /   //
1948     // tW = totalWeight           -------------------------------------------------------------  //
1949     // sF = swapFee                                        ( 1 - eF )                            //
1950     // eF = exitFee                                                                              //
1951     **********************************************************************************************/
1952     function calcPoolInGivenSingleOut(
1953         uint tokenBalanceOut,
1954         uint tokenWeightOut,
1955         uint poolSupply,
1956         uint totalWeight,
1957         uint tokenAmountOut,
1958         uint swapFee
1959     )
1960         internal pure
1961         returns (uint poolAmountIn)
1962     {
1963 
1964         // charge swap fee on the output token side
1965         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
1966         //uint tAoBeforeSwapFee = tAo / (1 - (1-weightTo) * swapFee) ;
1967         uint zoo = bsub(BONE, normalizedWeight);
1968         uint zar = bmul(zoo, swapFee);
1969         uint tokenAmountOutBeforeSwapFee = bdiv(tokenAmountOut, bsub(BONE, zar));
1970 
1971         uint newTokenBalanceOut = bsub(tokenBalanceOut, tokenAmountOutBeforeSwapFee);
1972         uint tokenOutRatio = bdiv(newTokenBalanceOut, tokenBalanceOut);
1973 
1974         //uint newPoolSupply = (ratioTo ^ weightTo) * poolSupply;
1975         uint poolRatio = bpow(tokenOutRatio, normalizedWeight);
1976         uint newPoolSupply = bmul(poolRatio, poolSupply);
1977         uint poolAmountInAfterExitFee = bsub(poolSupply, newPoolSupply);
1978 
1979         // charge exit fee on the pool token side
1980         // pAi = pAiAfterExitFee/(1-exitFee)
1981         poolAmountIn = bdiv(poolAmountInAfterExitFee, bsub(BONE, EXIT_FEE));
1982         return poolAmountIn;
1983     }
1984 }
1985 
1986 // File: contracts/OneSplitBase.sol
1987 
1988 pragma solidity ^0.5.0;
1989 
1990 
1991 
1992 
1993 
1994 
1995 
1996 
1997 
1998 
1999 
2000 
2001 
2002 
2003 
2004 
2005 
2006 
2007 
2008 
2009 
2010 
2011 
2012 
2013 
2014 
2015 
2016 
2017 
2018 
2019 
2020 contract IOneSplitView is IOneSplitConsts {
2021     function getExpectedReturn(
2022         IERC20 fromToken,
2023         IERC20 destToken,
2024         uint256 amount,
2025         uint256 parts,
2026         uint256 flags
2027     )
2028         public
2029         view
2030         returns(
2031             uint256 returnAmount,
2032             uint256[] memory distribution
2033         );
2034 
2035     function getExpectedReturnWithGas(
2036         IERC20 fromToken,
2037         IERC20 destToken,
2038         uint256 amount,
2039         uint256 parts,
2040         uint256 flags,
2041         uint256 destTokenEthPriceTimesGasPrice
2042     )
2043         public
2044         view
2045         returns(
2046             uint256 returnAmount,
2047             uint256 estimateGasAmount,
2048             uint256[] memory distribution
2049         );
2050 }
2051 
2052 
2053 library DisableFlags {
2054     function check(uint256 flags, uint256 flag) internal pure returns(bool) {
2055         return (flags & flag) != 0;
2056     }
2057 }
2058 
2059 
2060 contract OneSplitRoot is IOneSplitView {
2061     using SafeMath for uint256;
2062     using DisableFlags for uint256;
2063 
2064     using UniversalERC20 for IERC20;
2065     using UniversalERC20 for IWETH;
2066     using UniswapV2ExchangeLib for IUniswapV2Exchange;
2067     using ChaiHelper for IChai;
2068 
2069     uint256 constant internal DEXES_COUNT = 34;
2070     IERC20 constant internal ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
2071     IERC20 constant internal ZERO_ADDRESS = IERC20(0);
2072 
2073     IBancorEtherToken constant internal bancorEtherToken = IBancorEtherToken(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
2074     IWETH constant internal weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
2075     IChai constant internal chai = IChai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
2076     IERC20 constant internal dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
2077     IERC20 constant internal usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
2078     IERC20 constant internal usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
2079     IERC20 constant internal tusd = IERC20(0x0000000000085d4780B73119b644AE5ecd22b376);
2080     IERC20 constant internal busd = IERC20(0x4Fabb145d64652a948d72533023f6E7A623C7C53);
2081     IERC20 constant internal susd = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
2082     IERC20 constant internal pax = IERC20(0x8E870D67F660D95d5be530380D0eC0bd388289E1);
2083     IERC20 constant internal renbtc = IERC20(0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D);
2084     IERC20 constant internal wbtc = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
2085     IERC20 constant internal tbtc = IERC20(0x1bBE271d15Bb64dF0bc6CD28Df9Ff322F2eBD847);
2086     IERC20 constant internal hbtc = IERC20(0x0316EB71485b0Ab14103307bf65a021042c6d380);
2087     IERC20 constant internal sbtc = IERC20(0xfE18be6b3Bd88A2D2A7f928d00292E7a9963CfC6);
2088 
2089     IKyberNetworkProxy constant internal kyberNetworkProxy = IKyberNetworkProxy(0x9AAb3f75489902f3a48495025729a0AF77d4b11e);
2090     IKyberStorage constant internal kyberStorage = IKyberStorage(0xC8fb12402cB16970F3C5F4b48Ff68Eb9D1289301);
2091     IKyberHintHandler constant internal kyberHintHandler = IKyberHintHandler(0xa1C0Fa73c39CFBcC11ec9Eb1Afc665aba9996E2C);
2092     IUniswapFactory constant internal uniswapFactory = IUniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
2093     IBancorContractRegistry constant internal bancorContractRegistry = IBancorContractRegistry(0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4);
2094     IBancorNetworkPathFinder constant internal bancorNetworkPathFinder = IBancorNetworkPathFinder(0x6F0cD8C4f6F06eAB664C7E3031909452b4B72861);
2095     //IBancorConverterRegistry constant internal bancorConverterRegistry = IBancorConverterRegistry(0xf6E2D7F616B67E46D708e4410746E9AAb3a4C518);
2096     IBancorFinder constant internal bancorFinder = IBancorFinder(0x2B344e14dc2641D11D338C053C908c7A7D4c30B9);
2097     IOasisExchange constant internal oasisExchange = IOasisExchange(0x794e6e91555438aFc3ccF1c5076A74F42133d08D);
2098     ICurve constant internal curveCompound = ICurve(0xA2B47E3D5c44877cca798226B7B8118F9BFb7A56);
2099     ICurve constant internal curveUSDT = ICurve(0x52EA46506B9CC5Ef470C5bf89f17Dc28bB35D85C);
2100     ICurve constant internal curveY = ICurve(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
2101     ICurve constant internal curveBinance = ICurve(0x79a8C46DeA5aDa233ABaFFD40F3A0A2B1e5A4F27);
2102     ICurve constant internal curveSynthetix = ICurve(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD);
2103     ICurve constant internal curvePAX = ICurve(0x06364f10B501e868329afBc005b3492902d6C763);
2104     ICurve constant internal curveRenBTC = ICurve(0x93054188d876f558f4a66B2EF1d97d16eDf0895B);
2105     ICurve constant internal curveTBTC = ICurve(0x9726e9314eF1b96E45f40056bEd61A088897313E);
2106     ICurve constant internal curveSBTC = ICurve(0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714);
2107     IShell constant internal shell = IShell(0xA8253a440Be331dC4a7395B73948cCa6F19Dc97D);
2108     IAaveLendingPool constant internal aave = IAaveLendingPool(0x398eC7346DcD622eDc5ae82352F02bE94C62d119);
2109     ICompound constant internal compound = ICompound(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
2110     ICompoundEther constant internal cETH = ICompoundEther(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
2111     IMooniswapRegistry constant internal mooniswapRegistry = IMooniswapRegistry(0x71CD6666064C3A1354a3B4dca5fA1E2D3ee7D303);
2112     IUniswapV2Factory constant internal uniswapV2 = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
2113     IDForceSwap constant internal dforceSwap = IDForceSwap(0x03eF3f37856bD08eb47E2dE7ABc4Ddd2c19B60F2);
2114     IMStable constant internal musd = IMStable(0xe2f2a5C287993345a840Db3B0845fbC70f5935a5);
2115     IMassetValidationHelper constant internal musd_helper = IMassetValidationHelper(0xaBcC93c3be238884cc3309C19Afd128fAfC16911);
2116     IBalancerRegistry constant internal balancerRegistry = IBalancerRegistry(0x65e67cbc342712DF67494ACEfc06fe951EE93982);
2117     ICurveCalculator constant internal curveCalculator = ICurveCalculator(0xc1DB00a8E5Ef7bfa476395cdbcc98235477cDE4E);
2118     ICurveRegistry constant internal curveRegistry = ICurveRegistry(0x7002B727Ef8F5571Cb5F9D70D13DBEEb4dFAe9d1);
2119     ICompoundRegistry constant internal compoundRegistry = ICompoundRegistry(0xF451Dbd7Ba14BFa7B1B78A766D3Ed438F79EE1D1);
2120     IAaveRegistry constant internal aaveRegistry = IAaveRegistry(0xEd8b133B7B88366E01Bb9E38305Ab11c26521494);
2121     IBalancerHelper constant internal balancerHelper = IBalancerHelper(0xA961672E8Db773be387e775bc4937C678F3ddF9a);
2122 
2123     int256 internal constant VERY_NEGATIVE_VALUE = -1e72;
2124 
2125     function _findBestDistribution(
2126         uint256 s,                // parts
2127         int256[][] memory amounts // exchangesReturns
2128     )
2129         internal
2130         pure
2131         returns(
2132             int256 returnAmount,
2133             uint256[] memory distribution
2134         )
2135     {
2136         uint256 n = amounts.length;
2137 
2138         int256[][] memory answer = new int256[][](n); // int[n][s+1]
2139         uint256[][] memory parent = new uint256[][](n); // int[n][s+1]
2140 
2141         for (uint i = 0; i < n; i++) {
2142             answer[i] = new int256[](s + 1);
2143             parent[i] = new uint256[](s + 1);
2144         }
2145 
2146         for (uint j = 0; j <= s; j++) {
2147             answer[0][j] = amounts[0][j];
2148             for (uint i = 1; i < n; i++) {
2149                 answer[i][j] = -1e72;
2150             }
2151             parent[0][j] = 0;
2152         }
2153 
2154         for (uint i = 1; i < n; i++) {
2155             for (uint j = 0; j <= s; j++) {
2156                 answer[i][j] = answer[i - 1][j];
2157                 parent[i][j] = j;
2158 
2159                 for (uint k = 1; k <= j; k++) {
2160                     if (answer[i - 1][j - k] + amounts[i][k] > answer[i][j]) {
2161                         answer[i][j] = answer[i - 1][j - k] + amounts[i][k];
2162                         parent[i][j] = j - k;
2163                     }
2164                 }
2165             }
2166         }
2167 
2168         distribution = new uint256[](DEXES_COUNT);
2169 
2170         uint256 partsLeft = s;
2171         for (uint curExchange = n - 1; partsLeft > 0; curExchange--) {
2172             distribution[curExchange] = partsLeft - parent[curExchange][partsLeft];
2173             partsLeft = parent[curExchange][partsLeft];
2174         }
2175 
2176         returnAmount = (answer[n - 1][s] == VERY_NEGATIVE_VALUE) ? 0 : answer[n - 1][s];
2177     }
2178 
2179     function _kyberReserveIdByTokens(
2180         IERC20 fromToken,
2181         IERC20 destToken
2182     ) internal view returns(bytes32) {
2183         if (!fromToken.isETH() && !destToken.isETH()) {
2184             return 0;
2185         }
2186 
2187         bytes32[] memory reserveIds = kyberStorage.getReserveIdsPerTokenSrc(
2188             fromToken.isETH() ? destToken : fromToken
2189         );
2190 
2191         for (uint i = 0; i < reserveIds.length; i++) {
2192             if ((uint256(reserveIds[i]) >> 248) != 0xBB && // Bridge
2193                 reserveIds[i] != 0xff4b796265722046707200000000000000000000000000000000000000000000 && // Reserve 1
2194                 reserveIds[i] != 0xffabcd0000000000000000000000000000000000000000000000000000000000 && // Reserve 2
2195                 reserveIds[i] != 0xff4f6e65426974205175616e7400000000000000000000000000000000000000)   // Reserve 3
2196             {
2197                 return reserveIds[i];
2198             }
2199         }
2200 
2201         return 0;
2202     }
2203 
2204     function _scaleDestTokenEthPriceTimesGasPrice(
2205         IERC20 fromToken,
2206         IERC20 destToken,
2207         uint256 destTokenEthPriceTimesGasPrice
2208     ) internal view returns(uint256) {
2209         if (fromToken == destToken) {
2210             return destTokenEthPriceTimesGasPrice;
2211         }
2212 
2213         uint256 mul = _cheapGetPrice(ETH_ADDRESS, destToken, 0.01 ether);
2214         uint256 div = _cheapGetPrice(ETH_ADDRESS, fromToken, 0.01 ether);
2215         if (div > 0) {
2216             return destTokenEthPriceTimesGasPrice.mul(mul).div(div);
2217         }
2218         return 0;
2219     }
2220 
2221     function _cheapGetPrice(
2222         IERC20 fromToken,
2223         IERC20 destToken,
2224         uint256 amount
2225     ) internal view returns(uint256 returnAmount) {
2226         (returnAmount,,) = this.getExpectedReturnWithGas(
2227             fromToken,
2228             destToken,
2229             amount,
2230             1,
2231             FLAG_DISABLE_SPLIT_RECALCULATION |
2232             FLAG_DISABLE_ALL_SPLIT_SOURCES |
2233             FLAG_DISABLE_UNISWAP_V2_ALL |
2234             FLAG_DISABLE_UNISWAP,
2235             0
2236         );
2237     }
2238 
2239     function _linearInterpolation(
2240         uint256 value,
2241         uint256 parts
2242     ) internal pure returns(uint256[] memory rets) {
2243         rets = new uint256[](parts);
2244         for (uint i = 0; i < parts; i++) {
2245             rets[i] = value.mul(i + 1).div(parts);
2246         }
2247     }
2248 
2249     function _tokensEqual(IERC20 tokenA, IERC20 tokenB) internal pure returns(bool) {
2250         return ((tokenA.isETH() && tokenB.isETH()) || tokenA == tokenB);
2251     }
2252 }
2253 
2254 
2255 contract OneSplitViewWrapBase is IOneSplitView, OneSplitRoot {
2256     function getExpectedReturn(
2257         IERC20 fromToken,
2258         IERC20 destToken,
2259         uint256 amount,
2260         uint256 parts,
2261         uint256 flags // See constants in IOneSplit.sol
2262     )
2263         public
2264         view
2265         returns(
2266             uint256 returnAmount,
2267             uint256[] memory distribution
2268         )
2269     {
2270         (returnAmount, , distribution) = this.getExpectedReturnWithGas(
2271             fromToken,
2272             destToken,
2273             amount,
2274             parts,
2275             flags,
2276             0
2277         );
2278     }
2279 
2280     function getExpectedReturnWithGas(
2281         IERC20 fromToken,
2282         IERC20 destToken,
2283         uint256 amount,
2284         uint256 parts,
2285         uint256 flags,
2286         uint256 destTokenEthPriceTimesGasPrice
2287     )
2288         public
2289         view
2290         returns(
2291             uint256 returnAmount,
2292             uint256 estimateGasAmount,
2293             uint256[] memory distribution
2294         )
2295     {
2296         return _getExpectedReturnRespectingGasFloor(
2297             fromToken,
2298             destToken,
2299             amount,
2300             parts,
2301             flags,
2302             destTokenEthPriceTimesGasPrice
2303         );
2304     }
2305 
2306     function _getExpectedReturnRespectingGasFloor(
2307         IERC20 fromToken,
2308         IERC20 destToken,
2309         uint256 amount,
2310         uint256 parts,
2311         uint256 flags, // See constants in IOneSplit.sol
2312         uint256 destTokenEthPriceTimesGasPrice
2313     )
2314         internal
2315         view
2316         returns(
2317             uint256 returnAmount,
2318             uint256 estimateGasAmount,
2319             uint256[] memory distribution
2320         );
2321 }
2322 
2323 
2324 contract OneSplitView is IOneSplitView, OneSplitRoot {
2325     function getExpectedReturn(
2326         IERC20 fromToken,
2327         IERC20 destToken,
2328         uint256 amount,
2329         uint256 parts,
2330         uint256 flags // See constants in IOneSplit.sol
2331     )
2332         public
2333         view
2334         returns(
2335             uint256 returnAmount,
2336             uint256[] memory distribution
2337         )
2338     {
2339         (returnAmount, , distribution) = getExpectedReturnWithGas(
2340             fromToken,
2341             destToken,
2342             amount,
2343             parts,
2344             flags,
2345             0
2346         );
2347     }
2348 
2349     function getExpectedReturnWithGas(
2350         IERC20 fromToken,
2351         IERC20 destToken,
2352         uint256 amount,
2353         uint256 parts,
2354         uint256 flags, // See constants in IOneSplit.sol
2355         uint256 destTokenEthPriceTimesGasPrice
2356     )
2357         public
2358         view
2359         returns(
2360             uint256 returnAmount,
2361             uint256 estimateGasAmount,
2362             uint256[] memory distribution
2363         )
2364     {
2365         distribution = new uint256[](DEXES_COUNT);
2366 
2367         if (fromToken == destToken) {
2368             return (amount, 0, distribution);
2369         }
2370 
2371         function(IERC20,IERC20,uint256,uint256,uint256) view returns(uint256[] memory, uint256)[DEXES_COUNT] memory reserves = _getAllReserves(flags);
2372 
2373         int256[][] memory matrix = new int256[][](DEXES_COUNT);
2374         uint256[DEXES_COUNT] memory gases;
2375         bool atLeastOnePositive = false;
2376         for (uint i = 0; i < DEXES_COUNT; i++) {
2377             uint256[] memory rets;
2378             (rets, gases[i]) = reserves[i](fromToken, destToken, amount, parts, flags);
2379 
2380             // Prepend zero and sub gas
2381             int256 gas = int256(gases[i].mul(destTokenEthPriceTimesGasPrice).div(1e18));
2382             matrix[i] = new int256[](parts + 1);
2383             for (uint j = 0; j < rets.length; j++) {
2384                 matrix[i][j + 1] = int256(rets[j]) - gas;
2385                 atLeastOnePositive = atLeastOnePositive || (matrix[i][j + 1] > 0);
2386             }
2387         }
2388 
2389         if (!atLeastOnePositive) {
2390             for (uint i = 0; i < DEXES_COUNT; i++) {
2391                 for (uint j = 1; j < parts + 1; j++) {
2392                     if (matrix[i][j] == 0) {
2393                         matrix[i][j] = VERY_NEGATIVE_VALUE;
2394                     }
2395                 }
2396             }
2397         }
2398 
2399         (, distribution) = _findBestDistribution(parts, matrix);
2400 
2401         (returnAmount, estimateGasAmount) = _getReturnAndGasByDistribution(
2402             Args({
2403                 fromToken: fromToken,
2404                 destToken: destToken,
2405                 amount: amount,
2406                 parts: parts,
2407                 flags: flags,
2408                 destTokenEthPriceTimesGasPrice: destTokenEthPriceTimesGasPrice,
2409                 distribution: distribution,
2410                 matrix: matrix,
2411                 gases: gases,
2412                 reserves: reserves
2413             })
2414         );
2415         return (returnAmount, estimateGasAmount, distribution);
2416     }
2417 
2418     struct Args {
2419         IERC20 fromToken;
2420         IERC20 destToken;
2421         uint256 amount;
2422         uint256 parts;
2423         uint256 flags;
2424         uint256 destTokenEthPriceTimesGasPrice;
2425         uint256[] distribution;
2426         int256[][] matrix;
2427         uint256[DEXES_COUNT] gases;
2428         function(IERC20,IERC20,uint256,uint256,uint256) view returns(uint256[] memory, uint256)[DEXES_COUNT] reserves;
2429     }
2430 
2431     function _getReturnAndGasByDistribution(
2432         Args memory args
2433     ) internal view returns(uint256 returnAmount, uint256 estimateGasAmount) {
2434         bool[DEXES_COUNT] memory exact = [
2435             true,  // "Uniswap",
2436             false, // "Kyber",
2437             false, // "Bancor",
2438             false, // "Oasis",
2439             true,  // "Curve Compound",
2440             true,  // "Curve USDT",
2441             true,  // "Curve Y",
2442             true,  // "Curve Binance",
2443             true,  // "Curve Synthetix",
2444             true,  // "Uniswap Compound",
2445             true,  // "Uniswap CHAI",
2446             true,  // "Uniswap Aave",
2447             true,  // "Mooniswap 1",
2448             true,  // "Uniswap V2",
2449             true,  // "Uniswap V2 (ETH)",
2450             true,  // "Uniswap V2 (DAI)",
2451             true,  // "Uniswap V2 (USDC)",
2452             true,  // "Curve Pax",
2453             true,  // "Curve RenBTC",
2454             true,  // "Curve tBTC",
2455             true,  // "Dforce XSwap",
2456             false, // "Shell",
2457             true,  // "mStable",
2458             true,  // "Curve sBTC"
2459             true,  // "Balancer 1"
2460             true,  // "Balancer 2"
2461             true,  // "Balancer 3"
2462             true,  // "Kyber 1"
2463             true,  // "Kyber 2"
2464             true,  // "Kyber 3"
2465             true,  // "Kyber 4"
2466             true,  // "Mooniswap 2"
2467             true,  // "Mooniswap 3"
2468             true   // "Mooniswap 4"
2469         ];
2470 
2471         for (uint i = 0; i < DEXES_COUNT; i++) {
2472             if (args.distribution[i] > 0) {
2473                 if (args.distribution[i] == args.parts || exact[i] || args.flags.check(FLAG_DISABLE_SPLIT_RECALCULATION)) {
2474                     estimateGasAmount = estimateGasAmount.add(args.gases[i]);
2475                     int256 value = args.matrix[i][args.distribution[i]];
2476                     returnAmount = returnAmount.add(uint256(
2477                         (value == VERY_NEGATIVE_VALUE ? 0 : value) +
2478                         int256(args.gases[i].mul(args.destTokenEthPriceTimesGasPrice).div(1e18))
2479                     ));
2480                 }
2481                 else {
2482                     (uint256[] memory rets, uint256 gas) = args.reserves[i](args.fromToken, args.destToken, args.amount.mul(args.distribution[i]).div(args.parts), 1, args.flags);
2483                     estimateGasAmount = estimateGasAmount.add(gas);
2484                     returnAmount = returnAmount.add(rets[0]);
2485                 }
2486             }
2487         }
2488     }
2489 
2490     function _getAllReserves(uint256 flags)
2491         internal
2492         pure
2493         returns(function(IERC20,IERC20,uint256,uint256,uint256) view returns(uint256[] memory, uint256)[DEXES_COUNT] memory)
2494     {
2495         bool invert = flags.check(FLAG_DISABLE_ALL_SPLIT_SOURCES);
2496         return [
2497             invert != flags.check(FLAG_DISABLE_UNISWAP_ALL | FLAG_DISABLE_UNISWAP)            ? _calculateNoReturn : calculateUniswap,
2498             _calculateNoReturn, // invert != flags.check(FLAG_DISABLE_KYBER) ? _calculateNoReturn : calculateKyber,
2499             invert != flags.check(FLAG_DISABLE_BANCOR)                                        ? _calculateNoReturn : calculateBancor,
2500             invert != flags.check(FLAG_DISABLE_OASIS)                                         ? _calculateNoReturn : calculateOasis,
2501             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_COMPOUND)       ? _calculateNoReturn : calculateCurveCompound,
2502             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_USDT)           ? _calculateNoReturn : calculateCurveUSDT,
2503             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_Y)              ? _calculateNoReturn : calculateCurveY,
2504             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_BINANCE)        ? _calculateNoReturn : calculateCurveBinance,
2505             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_SYNTHETIX)      ? _calculateNoReturn : calculateCurveSynthetix,
2506             invert != flags.check(FLAG_DISABLE_UNISWAP_ALL | FLAG_DISABLE_UNISWAP_COMPOUND)   ? _calculateNoReturn : calculateUniswapCompound,
2507             invert != flags.check(FLAG_DISABLE_UNISWAP_ALL | FLAG_DISABLE_UNISWAP_CHAI)       ? _calculateNoReturn : calculateUniswapChai,
2508             invert != flags.check(FLAG_DISABLE_UNISWAP_ALL | FLAG_DISABLE_UNISWAP_AAVE)       ? _calculateNoReturn : calculateUniswapAave,
2509             invert != flags.check(FLAG_DISABLE_MOONISWAP_ALL | FLAG_DISABLE_MOONISWAP)        ? _calculateNoReturn : calculateMooniswap,
2510             invert != flags.check(FLAG_DISABLE_UNISWAP_V2_ALL | FLAG_DISABLE_UNISWAP_V2)      ? _calculateNoReturn : calculateUniswapV2,
2511             invert != flags.check(FLAG_DISABLE_UNISWAP_V2_ALL | FLAG_DISABLE_UNISWAP_V2_ETH)  ? _calculateNoReturn : calculateUniswapV2ETH,
2512             invert != flags.check(FLAG_DISABLE_UNISWAP_V2_ALL | FLAG_DISABLE_UNISWAP_V2_DAI)  ? _calculateNoReturn : calculateUniswapV2DAI,
2513             invert != flags.check(FLAG_DISABLE_UNISWAP_V2_ALL | FLAG_DISABLE_UNISWAP_V2_USDC) ? _calculateNoReturn : calculateUniswapV2USDC,
2514             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_PAX)            ? _calculateNoReturn : calculateCurvePAX,
2515             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_RENBTC)         ? _calculateNoReturn : calculateCurveRenBTC,
2516             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_TBTC)           ? _calculateNoReturn : calculateCurveTBTC,
2517             invert != flags.check(FLAG_DISABLE_DFORCE_SWAP)                                   ? _calculateNoReturn : calculateDforceSwap,
2518             invert != flags.check(FLAG_DISABLE_SHELL)                                         ? _calculateNoReturn : calculateShell,
2519             invert != flags.check(FLAG_DISABLE_MSTABLE_MUSD)                                  ? _calculateNoReturn : calculateMStableMUSD,
2520             invert != flags.check(FLAG_DISABLE_CURVE_ALL | FLAG_DISABLE_CURVE_SBTC)           ? _calculateNoReturn : calculateCurveSBTC,
2521             invert != flags.check(FLAG_DISABLE_BALANCER_ALL | FLAG_DISABLE_BALANCER_1)        ? _calculateNoReturn : calculateBalancer1,
2522             invert != flags.check(FLAG_DISABLE_BALANCER_ALL | FLAG_DISABLE_BALANCER_2)        ? _calculateNoReturn : calculateBalancer2,
2523             invert != flags.check(FLAG_DISABLE_BALANCER_ALL | FLAG_DISABLE_BALANCER_3)        ? _calculateNoReturn : calculateBalancer3,
2524             invert != flags.check(FLAG_DISABLE_KYBER_ALL | FLAG_DISABLE_KYBER_1)              ? _calculateNoReturn : calculateKyber1,
2525             invert != flags.check(FLAG_DISABLE_KYBER_ALL | FLAG_DISABLE_KYBER_2)              ? _calculateNoReturn : calculateKyber2,
2526             invert != flags.check(FLAG_DISABLE_KYBER_ALL | FLAG_DISABLE_KYBER_3)              ? _calculateNoReturn : calculateKyber3,
2527             invert != flags.check(FLAG_DISABLE_KYBER_ALL | FLAG_DISABLE_KYBER_4)              ? _calculateNoReturn : calculateKyber4,
2528             invert != flags.check(FLAG_DISABLE_MOONISWAP_ALL | FLAG_DISABLE_MOONISWAP_ETH)    ? _calculateNoReturn : calculateMooniswapOverETH,
2529             invert != flags.check(FLAG_DISABLE_MOONISWAP_ALL | FLAG_DISABLE_MOONISWAP_DAI)    ? _calculateNoReturn : calculateMooniswapOverDAI,
2530             invert != flags.check(FLAG_DISABLE_MOONISWAP_ALL | FLAG_DISABLE_MOONISWAP_USDC)   ? _calculateNoReturn : calculateMooniswapOverUSDC
2531         ];
2532     }
2533 
2534     function _calculateNoGas(
2535         IERC20 /*fromToken*/,
2536         IERC20 /*destToken*/,
2537         uint256 /*amount*/,
2538         uint256 /*parts*/,
2539         uint256 /*destTokenEthPriceTimesGasPrice*/,
2540         uint256 /*flags*/,
2541         uint256 /*destTokenEthPrice*/
2542     ) internal view returns(uint256[] memory /*rets*/, uint256 /*gas*/) {
2543         this;
2544     }
2545 
2546     // View Helpers
2547 
2548     struct Balances {
2549         uint256 src;
2550         uint256 dst;
2551     }
2552 
2553     function _calculateBalancer(
2554         IERC20 fromToken,
2555         IERC20 destToken,
2556         uint256 amount,
2557         uint256 parts,
2558         uint256 poolIndex
2559     ) internal view returns(uint256[] memory rets, uint256 gas) {
2560         address[] memory pools = balancerRegistry.getBestPoolsWithLimit(
2561             address(fromToken.isETH() ? weth : fromToken),
2562             address(destToken.isETH() ? weth : destToken),
2563             poolIndex + 1
2564         );
2565         if (poolIndex >= pools.length) {
2566             return (new uint256[](parts), 0);
2567         }
2568 
2569         rets = balancerHelper.getReturns(
2570             IBalancerPool(pools[poolIndex]),
2571             fromToken.isETH() ? weth : fromToken,
2572             destToken.isETH() ? weth : destToken,
2573             _linearInterpolation(amount, parts)
2574         );
2575         gas = 75_000 + (fromToken.isETH() || destToken.isETH() ? 0 : 65_000);
2576     }
2577 
2578     function calculateBalancer1(
2579         IERC20 fromToken,
2580         IERC20 destToken,
2581         uint256 amount,
2582         uint256 parts,
2583         uint256 /*flags*/
2584     ) internal view returns(uint256[] memory rets, uint256 gas) {
2585         return _calculateBalancer(
2586             fromToken,
2587             destToken,
2588             amount,
2589             parts,
2590             0
2591         );
2592     }
2593 
2594     function calculateBalancer2(
2595         IERC20 fromToken,
2596         IERC20 destToken,
2597         uint256 amount,
2598         uint256 parts,
2599         uint256 /*flags*/
2600     ) internal view returns(uint256[] memory rets, uint256 gas) {
2601         return _calculateBalancer(
2602             fromToken,
2603             destToken,
2604             amount,
2605             parts,
2606             1
2607         );
2608     }
2609 
2610     function calculateBalancer3(
2611         IERC20 fromToken,
2612         IERC20 destToken,
2613         uint256 amount,
2614         uint256 parts,
2615         uint256 /*flags*/
2616     ) internal view returns(uint256[] memory rets, uint256 gas) {
2617         return _calculateBalancer(
2618             fromToken,
2619             destToken,
2620             amount,
2621             parts,
2622             2
2623         );
2624     }
2625 
2626     function calculateMStableMUSD(
2627         IERC20 fromToken,
2628         IERC20 destToken,
2629         uint256 amount,
2630         uint256 parts,
2631         uint256 /*flags*/
2632     ) internal view returns(uint256[] memory rets, uint256 gas) {
2633         rets = new uint256[](parts);
2634 
2635         if ((fromToken != usdc && fromToken != dai && fromToken != usdt && fromToken != tusd) ||
2636             (destToken != usdc && destToken != dai && destToken != usdt && destToken != tusd))
2637         {
2638             return (rets, 0);
2639         }
2640 
2641         for (uint i = 1; i <= parts; i *= 2) {
2642             (bool success, bytes memory data) = address(musd).staticcall(abi.encodeWithSelector(
2643                 musd.getSwapOutput.selector,
2644                 fromToken,
2645                 destToken,
2646                 amount.mul(parts.div(i)).div(parts)
2647             ));
2648 
2649             if (success && data.length > 0) {
2650                 (,, uint256 maxRet) = abi.decode(data, (bool,string,uint256));
2651                 if (maxRet > 0) {
2652                     for (uint j = 0; j < parts.div(i); j++) {
2653                         rets[j] = maxRet.mul(j + 1).div(parts.div(i));
2654                     }
2655                     break;
2656                 }
2657             }
2658         }
2659 
2660         return (
2661             rets,
2662             700_000
2663         );
2664     }
2665 
2666     function _getCurvePoolInfo(
2667         ICurve curve,
2668         bool haveUnderlying
2669     ) internal view returns(
2670         uint256[8] memory balances,
2671         uint256[8] memory precisions,
2672         uint256[8] memory rates,
2673         uint256 amp,
2674         uint256 fee
2675     ) {
2676         uint256[8] memory underlying_balances;
2677         uint256[8] memory decimals;
2678         uint256[8] memory underlying_decimals;
2679 
2680         (
2681             balances,
2682             underlying_balances,
2683             decimals,
2684             underlying_decimals,
2685             /*address lp_token*/,
2686             amp,
2687             fee
2688         ) = curveRegistry.get_pool_info(address(curve));
2689 
2690         for (uint k = 0; k < 8 && balances[k] > 0; k++) {
2691             precisions[k] = 10 ** (18 - (haveUnderlying ? underlying_decimals : decimals)[k]);
2692             if (haveUnderlying) {
2693                 rates[k] = underlying_balances[k].mul(1e18).div(balances[k]);
2694             } else {
2695                 rates[k] = 1e18;
2696             }
2697         }
2698     }
2699 
2700     function _calculateCurveSelector(
2701         IERC20 fromToken,
2702         IERC20 destToken,
2703         uint256 amount,
2704         uint256 parts,
2705         ICurve curve,
2706         bool haveUnderlying,
2707         IERC20[] memory tokens
2708     ) internal view returns(uint256[] memory rets) {
2709         rets = new uint256[](parts);
2710 
2711         int128 i = 0;
2712         int128 j = 0;
2713         for (uint t = 0; t < tokens.length; t++) {
2714             if (fromToken == tokens[t]) {
2715                 i = int128(t + 1);
2716             }
2717             if (destToken == tokens[t]) {
2718                 j = int128(t + 1);
2719             }
2720         }
2721 
2722         if (i == 0 || j == 0) {
2723             return rets;
2724         }
2725 
2726         bytes memory data = abi.encodePacked(
2727             uint256(haveUnderlying ? 1 : 0),
2728             uint256(i - 1),
2729             uint256(j - 1),
2730             _linearInterpolation100(amount, parts)
2731         );
2732 
2733         (
2734             uint256[8] memory balances,
2735             uint256[8] memory precisions,
2736             uint256[8] memory rates,
2737             uint256 amp,
2738             uint256 fee
2739         ) = _getCurvePoolInfo(curve, haveUnderlying);
2740 
2741         bool success;
2742         (success, data) = address(curveCalculator).staticcall(
2743             abi.encodePacked(
2744                 abi.encodeWithSelector(
2745                     curveCalculator.get_dy.selector,
2746                     tokens.length,
2747                     balances,
2748                     amp,
2749                     fee,
2750                     rates,
2751                     precisions
2752                 ),
2753                 data
2754             )
2755         );
2756 
2757         if (!success || data.length == 0) {
2758             return rets;
2759         }
2760 
2761         uint256[100] memory dy = abi.decode(data, (uint256[100]));
2762         for (uint t = 0; t < parts; t++) {
2763             rets[t] = dy[t];
2764         }
2765     }
2766 
2767     function _linearInterpolation100(
2768         uint256 value,
2769         uint256 parts
2770     ) internal pure returns(uint256[100] memory rets) {
2771         for (uint i = 0; i < parts; i++) {
2772             rets[i] = value.mul(i + 1).div(parts);
2773         }
2774     }
2775 
2776     function calculateCurveCompound(
2777         IERC20 fromToken,
2778         IERC20 destToken,
2779         uint256 amount,
2780         uint256 parts,
2781         uint256 /*flags*/
2782     ) internal view returns(uint256[] memory rets, uint256 gas) {
2783         IERC20[] memory tokens = new IERC20[](2);
2784         tokens[0] = dai;
2785         tokens[1] = usdc;
2786         return (_calculateCurveSelector(
2787             fromToken,
2788             destToken,
2789             amount,
2790             parts,
2791             curveCompound,
2792             true,
2793             tokens
2794         ), 720_000);
2795     }
2796 
2797     function calculateCurveUSDT(
2798         IERC20 fromToken,
2799         IERC20 destToken,
2800         uint256 amount,
2801         uint256 parts,
2802         uint256 /*flags*/
2803     ) internal view returns(uint256[] memory rets, uint256 gas) {
2804         IERC20[] memory tokens = new IERC20[](3);
2805         tokens[0] = dai;
2806         tokens[1] = usdc;
2807         tokens[2] = usdt;
2808         return (_calculateCurveSelector(
2809             fromToken,
2810             destToken,
2811             amount,
2812             parts,
2813             curveUSDT,
2814             true,
2815             tokens
2816         ), 720_000);
2817     }
2818 
2819     function calculateCurveY(
2820         IERC20 fromToken,
2821         IERC20 destToken,
2822         uint256 amount,
2823         uint256 parts,
2824         uint256 /*flags*/
2825     ) internal view returns(uint256[] memory rets, uint256 gas) {
2826         IERC20[] memory tokens = new IERC20[](4);
2827         tokens[0] = dai;
2828         tokens[1] = usdc;
2829         tokens[2] = usdt;
2830         tokens[3] = tusd;
2831         return (_calculateCurveSelector(
2832             fromToken,
2833             destToken,
2834             amount,
2835             parts,
2836             curveY,
2837             true,
2838             tokens
2839         ), 1_400_000);
2840     }
2841 
2842     function calculateCurveBinance(
2843         IERC20 fromToken,
2844         IERC20 destToken,
2845         uint256 amount,
2846         uint256 parts,
2847         uint256 /*flags*/
2848     ) internal view returns(uint256[] memory rets, uint256 gas) {
2849         IERC20[] memory tokens = new IERC20[](4);
2850         tokens[0] = dai;
2851         tokens[1] = usdc;
2852         tokens[2] = usdt;
2853         tokens[3] = busd;
2854         return (_calculateCurveSelector(
2855             fromToken,
2856             destToken,
2857             amount,
2858             parts,
2859             curveBinance,
2860             true,
2861             tokens
2862         ), 1_400_000);
2863     }
2864 
2865     function calculateCurveSynthetix(
2866         IERC20 fromToken,
2867         IERC20 destToken,
2868         uint256 amount,
2869         uint256 parts,
2870         uint256 /*flags*/
2871     ) internal view returns(uint256[] memory rets, uint256 gas) {
2872         IERC20[] memory tokens = new IERC20[](4);
2873         tokens[0] = dai;
2874         tokens[1] = usdc;
2875         tokens[2] = usdt;
2876         tokens[3] = susd;
2877         return (_calculateCurveSelector(
2878             fromToken,
2879             destToken,
2880             amount,
2881             parts,
2882             curveSynthetix,
2883             true,
2884             tokens
2885         ), 200_000);
2886     }
2887 
2888     function calculateCurvePAX(
2889         IERC20 fromToken,
2890         IERC20 destToken,
2891         uint256 amount,
2892         uint256 parts,
2893         uint256 /*flags*/
2894     ) internal view returns(uint256[] memory rets, uint256 gas) {
2895         IERC20[] memory tokens = new IERC20[](4);
2896         tokens[0] = dai;
2897         tokens[1] = usdc;
2898         tokens[2] = usdt;
2899         tokens[3] = pax;
2900         return (_calculateCurveSelector(
2901             fromToken,
2902             destToken,
2903             amount,
2904             parts,
2905             curvePAX,
2906             true,
2907             tokens
2908         ), 1_000_000);
2909     }
2910 
2911     function calculateCurveRenBTC(
2912         IERC20 fromToken,
2913         IERC20 destToken,
2914         uint256 amount,
2915         uint256 parts,
2916         uint256 /*flags*/
2917     ) internal view returns(uint256[] memory rets, uint256 gas) {
2918         IERC20[] memory tokens = new IERC20[](2);
2919         tokens[0] = renbtc;
2920         tokens[1] = wbtc;
2921         return (_calculateCurveSelector(
2922             fromToken,
2923             destToken,
2924             amount,
2925             parts,
2926             curveRenBTC,
2927             false,
2928             tokens
2929         ), 130_000);
2930     }
2931 
2932     function calculateCurveTBTC(
2933         IERC20 fromToken,
2934         IERC20 destToken,
2935         uint256 amount,
2936         uint256 parts,
2937         uint256 /*flags*/
2938     ) internal view returns(uint256[] memory rets, uint256 gas) {
2939         IERC20[] memory tokens = new IERC20[](3);
2940         tokens[0] = tbtc;
2941         tokens[1] = wbtc;
2942         tokens[2] = hbtc;
2943         return (_calculateCurveSelector(
2944             fromToken,
2945             destToken,
2946             amount,
2947             parts,
2948             curveTBTC,
2949             false,
2950             tokens
2951         ), 145_000);
2952     }
2953 
2954     function calculateCurveSBTC(
2955         IERC20 fromToken,
2956         IERC20 destToken,
2957         uint256 amount,
2958         uint256 parts,
2959         uint256 /*flags*/
2960     ) internal view returns(uint256[] memory rets, uint256 gas) {
2961         IERC20[] memory tokens = new IERC20[](3);
2962         tokens[0] = renbtc;
2963         tokens[1] = wbtc;
2964         tokens[2] = sbtc;
2965         return (_calculateCurveSelector(
2966             fromToken,
2967             destToken,
2968             amount,
2969             parts,
2970             curveSBTC,
2971             false,
2972             tokens
2973         ), 150_000);
2974     }
2975 
2976     function calculateShell(
2977         IERC20 fromToken,
2978         IERC20 destToken,
2979         uint256 amount,
2980         uint256 parts,
2981         uint256 /*flags*/
2982     ) internal view returns(uint256[] memory rets, uint256 gas) {
2983         (bool success, bytes memory data) = address(shell).staticcall(abi.encodeWithSelector(
2984             shell.viewOriginTrade.selector,
2985             fromToken,
2986             destToken,
2987             amount
2988         ));
2989 
2990         if (!success || data.length == 0) {
2991             return (new uint256[](parts), 0);
2992         }
2993 
2994         uint256 maxRet = abi.decode(data, (uint256));
2995         return (_linearInterpolation(maxRet, parts), 300_000);
2996     }
2997 
2998     function calculateDforceSwap(
2999         IERC20 fromToken,
3000         IERC20 destToken,
3001         uint256 amount,
3002         uint256 parts,
3003         uint256 /*flags*/
3004     ) internal view returns(uint256[] memory rets, uint256 gas) {
3005         (bool success, bytes memory data) = address(dforceSwap).staticcall(
3006             abi.encodeWithSelector(
3007                 dforceSwap.getAmountByInput.selector,
3008                 fromToken,
3009                 destToken,
3010                 amount
3011             )
3012         );
3013         if (!success || data.length == 0) {
3014             return (new uint256[](parts), 0);
3015         }
3016 
3017         uint256 maxRet = abi.decode(data, (uint256));
3018         uint256 available = destToken.universalBalanceOf(address(dforceSwap));
3019         if (maxRet > available) {
3020             return (new uint256[](parts), 0);
3021         }
3022 
3023         return (_linearInterpolation(maxRet, parts), 160_000);
3024     }
3025 
3026     function _calculateUniswapFormula(uint256 fromBalance, uint256 toBalance, uint256 amount) internal pure returns(uint256) {
3027         if (amount == 0) {
3028             return 0;
3029         }
3030         return amount.mul(toBalance).mul(997).div(
3031             fromBalance.mul(1000).add(amount.mul(997))
3032         );
3033     }
3034 
3035     function _calculateUniswap(
3036         IERC20 fromToken,
3037         IERC20 destToken,
3038         uint256[] memory amounts,
3039         uint256 /*flags*/
3040     ) internal view returns(uint256[] memory rets, uint256 gas) {
3041         rets = amounts;
3042 
3043         if (!fromToken.isETH()) {
3044             IUniswapExchange fromExchange = uniswapFactory.getExchange(fromToken);
3045             if (fromExchange == IUniswapExchange(0)) {
3046                 return (new uint256[](rets.length), 0);
3047             }
3048 
3049             uint256 fromTokenBalance = fromToken.universalBalanceOf(address(fromExchange));
3050             uint256 fromEtherBalance = address(fromExchange).balance;
3051 
3052             for (uint i = 0; i < rets.length; i++) {
3053                 rets[i] = _calculateUniswapFormula(fromTokenBalance, fromEtherBalance, rets[i]);
3054             }
3055         }
3056 
3057         if (!destToken.isETH()) {
3058             IUniswapExchange toExchange = uniswapFactory.getExchange(destToken);
3059             if (toExchange == IUniswapExchange(0)) {
3060                 return (new uint256[](rets.length), 0);
3061             }
3062 
3063             uint256 toEtherBalance = address(toExchange).balance;
3064             uint256 toTokenBalance = destToken.universalBalanceOf(address(toExchange));
3065 
3066             for (uint i = 0; i < rets.length; i++) {
3067                 rets[i] = _calculateUniswapFormula(toEtherBalance, toTokenBalance, rets[i]);
3068             }
3069         }
3070 
3071         return (rets, fromToken.isETH() || destToken.isETH() ? 60_000 : 100_000);
3072     }
3073 
3074     function calculateUniswap(
3075         IERC20 fromToken,
3076         IERC20 destToken,
3077         uint256 amount,
3078         uint256 parts,
3079         uint256 flags
3080     ) internal view returns(uint256[] memory rets, uint256 gas) {
3081         return _calculateUniswap(
3082             fromToken,
3083             destToken,
3084             _linearInterpolation(amount, parts),
3085             flags
3086         );
3087     }
3088 
3089     function _calculateUniswapWrapped(
3090         IERC20 fromToken,
3091         IERC20 midToken,
3092         IERC20 destToken,
3093         uint256 amount,
3094         uint256 parts,
3095         uint256 midTokenPrice,
3096         uint256 flags,
3097         uint256 gas1,
3098         uint256 gas2
3099     ) internal view returns(uint256[] memory rets, uint256 gas) {
3100         if (!fromToken.isETH() && destToken.isETH()) {
3101             (rets, gas) = _calculateUniswap(
3102                 midToken,
3103                 destToken,
3104                 _linearInterpolation(amount.mul(1e18).div(midTokenPrice), parts),
3105                 flags
3106             );
3107             return (rets, gas + gas1);
3108         }
3109         else if (fromToken.isETH() && !destToken.isETH()) {
3110             (rets, gas) = _calculateUniswap(
3111                 fromToken,
3112                 midToken,
3113                 _linearInterpolation(amount, parts),
3114                 flags
3115             );
3116 
3117             for (uint i = 0; i < parts; i++) {
3118                 rets[i] = rets[i].mul(midTokenPrice).div(1e18);
3119             }
3120             return (rets, gas + gas2);
3121         }
3122 
3123         return (new uint256[](parts), 0);
3124     }
3125 
3126     function calculateUniswapCompound(
3127         IERC20 fromToken,
3128         IERC20 destToken,
3129         uint256 amount,
3130         uint256 parts,
3131         uint256 flags
3132     ) internal view returns(uint256[] memory rets, uint256 gas) {
3133         IERC20 midPreToken;
3134         if (!fromToken.isETH() && destToken.isETH()) {
3135             midPreToken = fromToken;
3136         }
3137         else if (!destToken.isETH() && fromToken.isETH()) {
3138             midPreToken = destToken;
3139         }
3140 
3141         if (!midPreToken.isETH()) {
3142             ICompoundToken midToken = compoundRegistry.cTokenByToken(midPreToken);
3143             if (midToken != ICompoundToken(0)) {
3144                 return _calculateUniswapWrapped(
3145                     fromToken,
3146                     midToken,
3147                     destToken,
3148                     amount,
3149                     parts,
3150                     midToken.exchangeRateStored(),
3151                     flags,
3152                     200_000,
3153                     200_000
3154                 );
3155             }
3156         }
3157 
3158         return (new uint256[](parts), 0);
3159     }
3160 
3161     function calculateUniswapChai(
3162         IERC20 fromToken,
3163         IERC20 destToken,
3164         uint256 amount,
3165         uint256 parts,
3166         uint256 flags
3167     ) internal view returns(uint256[] memory rets, uint256 gas) {
3168         if (fromToken == dai && destToken.isETH() ||
3169             fromToken.isETH() && destToken == dai)
3170         {
3171             return _calculateUniswapWrapped(
3172                 fromToken,
3173                 chai,
3174                 destToken,
3175                 amount,
3176                 parts,
3177                 chai.chaiPrice(),
3178                 flags,
3179                 180_000,
3180                 160_000
3181             );
3182         }
3183 
3184         return (new uint256[](parts), 0);
3185     }
3186 
3187     function calculateUniswapAave(
3188         IERC20 fromToken,
3189         IERC20 destToken,
3190         uint256 amount,
3191         uint256 parts,
3192         uint256 flags
3193     ) internal view returns(uint256[] memory rets, uint256 gas) {
3194         IERC20 midPreToken;
3195         if (!fromToken.isETH() && destToken.isETH()) {
3196             midPreToken = fromToken;
3197         }
3198         else if (!destToken.isETH() && fromToken.isETH()) {
3199             midPreToken = destToken;
3200         }
3201 
3202         if (!midPreToken.isETH()) {
3203             IAaveToken midToken = aaveRegistry.aTokenByToken(midPreToken);
3204             if (midToken != IAaveToken(0)) {
3205                 return _calculateUniswapWrapped(
3206                     fromToken,
3207                     midToken,
3208                     destToken,
3209                     amount,
3210                     parts,
3211                     1e18,
3212                     flags,
3213                     310_000,
3214                     670_000
3215                 );
3216             }
3217         }
3218 
3219         return (new uint256[](parts), 0);
3220     }
3221 
3222     function calculateKyber1(
3223         IERC20 fromToken,
3224         IERC20 destToken,
3225         uint256 amount,
3226         uint256 parts,
3227         uint256 flags
3228     ) internal view returns(uint256[] memory rets, uint256 gas) {
3229         return _calculateKyber(
3230             fromToken,
3231             destToken,
3232             amount,
3233             parts,
3234             flags,
3235             0xff4b796265722046707200000000000000000000000000000000000000000000 // 0x63825c174ab367968EC60f061753D3bbD36A0D8F
3236         );
3237     }
3238 
3239     function calculateKyber2(
3240         IERC20 fromToken,
3241         IERC20 destToken,
3242         uint256 amount,
3243         uint256 parts,
3244         uint256 flags
3245     ) internal view returns(uint256[] memory rets, uint256 gas) {
3246         return _calculateKyber(
3247             fromToken,
3248             destToken,
3249             amount,
3250             parts,
3251             flags,
3252             0xffabcd0000000000000000000000000000000000000000000000000000000000 // 0x7a3370075a54B187d7bD5DceBf0ff2B5552d4F7D
3253         );
3254     }
3255 
3256     function calculateKyber3(
3257         IERC20 fromToken,
3258         IERC20 destToken,
3259         uint256 amount,
3260         uint256 parts,
3261         uint256 flags
3262     ) internal view returns(uint256[] memory rets, uint256 gas) {
3263         return _calculateKyber(
3264             fromToken,
3265             destToken,
3266             amount,
3267             parts,
3268             flags,
3269             0xff4f6e65426974205175616e7400000000000000000000000000000000000000 // 0x4f32BbE8dFc9efD54345Fc936f9fEF1048746fCF
3270         );
3271     }
3272 
3273     function calculateKyber4(
3274         IERC20 fromToken,
3275         IERC20 destToken,
3276         uint256 amount,
3277         uint256 parts,
3278         uint256 flags
3279     ) internal view returns(uint256[] memory rets, uint256 gas) {
3280         bytes32 reserveId = _kyberReserveIdByTokens(fromToken, destToken);
3281         if (reserveId == 0) {
3282             return (new uint256[](parts), 0);
3283         }
3284 
3285         return _calculateKyber(
3286             fromToken,
3287             destToken,
3288             amount,
3289             parts,
3290             flags,
3291             reserveId
3292         );
3293     }
3294 
3295     function _kyberGetRate(
3296         IERC20 fromToken,
3297         IERC20 destToken,
3298         uint256 amount,
3299         uint256 flags,
3300         bytes memory hint
3301     ) private view returns(uint256) {
3302         (, bytes memory data) = address(kyberNetworkProxy).staticcall(
3303             abi.encodeWithSelector(
3304                 kyberNetworkProxy.getExpectedRateAfterFee.selector,
3305                 fromToken,
3306                 destToken,
3307                 amount,
3308                 (flags >> 255) * 10,
3309                 hint
3310             )
3311         );
3312 
3313         return (data.length == 32) ? abi.decode(data, (uint256)) : 0;
3314     }
3315 
3316     function _calculateKyber(
3317         IERC20 fromToken,
3318         IERC20 destToken,
3319         uint256 amount,
3320         uint256 parts,
3321         uint256 flags,
3322         bytes32 reserveId
3323     ) internal view returns(uint256[] memory rets, uint256 gas) {
3324         bytes memory fromHint;
3325         bytes memory destHint;
3326         {
3327             bytes32[] memory reserveIds = new bytes32[](1);
3328             reserveIds[0] = reserveId;
3329 
3330             (bool success, bytes memory data) = address(kyberHintHandler).staticcall(
3331                 abi.encodeWithSelector(
3332                     kyberHintHandler.buildTokenToEthHint.selector,
3333                     fromToken,
3334                     IKyberHintHandler.TradeType.MaskIn,
3335                     reserveIds,
3336                     new uint256[](0)
3337                 )
3338             );
3339             fromHint = success ? abi.decode(data, (bytes)) : bytes("");
3340 
3341             (success, data) = address(kyberHintHandler).staticcall(
3342                 abi.encodeWithSelector(
3343                     kyberHintHandler.buildEthToTokenHint.selector,
3344                     destToken,
3345                     IKyberHintHandler.TradeType.MaskIn,
3346                     reserveIds,
3347                     new uint256[](0)
3348                 )
3349             );
3350             destHint = success ? abi.decode(data, (bytes)) : bytes("");
3351         }
3352 
3353         uint256 fromTokenDecimals = 10 ** IERC20(fromToken).universalDecimals();
3354         uint256 destTokenDecimals = 10 ** IERC20(destToken).universalDecimals();
3355         rets = new uint256[](parts);
3356         for (uint i = 0; i < parts; i++) {
3357             if (i > 0 && rets[i - 1] == 0) {
3358                 break;
3359             }
3360             rets[i] = amount.mul(i + 1).div(parts);
3361 
3362             if (!fromToken.isETH()) {
3363                 if (fromHint.length == 0) {
3364                     rets[i] = 0;
3365                     break;
3366                 }
3367                 uint256 rate = _kyberGetRate(
3368                     fromToken,
3369                     ETH_ADDRESS,
3370                     rets[i],
3371                     flags,
3372                     fromHint
3373                 );
3374                 rets[i] = rate.mul(rets[i]).div(fromTokenDecimals);
3375             }
3376 
3377             if (!destToken.isETH() && rets[i] > 0) {
3378                 if (destHint.length == 0) {
3379                     rets[i] = 0;
3380                     break;
3381                 }
3382                 uint256 rate = _kyberGetRate(
3383                     ETH_ADDRESS,
3384                     destToken,
3385                     rets[i],
3386                     10,
3387                     destHint
3388                 );
3389                 rets[i] = rate.mul(rets[i]).mul(destTokenDecimals).div(1e36);
3390             }
3391         }
3392 
3393         return (rets, 100_000);
3394     }
3395 
3396     function calculateBancor(
3397         IERC20 /*fromToken*/,
3398         IERC20 /*destToken*/,
3399         uint256 /*amount*/,
3400         uint256 parts,
3401         uint256 /*flags*/
3402     ) internal view returns(uint256[] memory rets, uint256 gas) {
3403         return (new uint256[](parts), 0);
3404         // IBancorNetwork bancorNetwork = IBancorNetwork(bancorContractRegistry.addressOf("BancorNetwork"));
3405 
3406         // address[] memory path = bancorFinder.buildBancorPath(
3407         //     fromToken.isETH() ? bancorEtherToken : fromToken,
3408         //     destToken.isETH() ? bancorEtherToken : destToken
3409         // );
3410 
3411         // rets = _linearInterpolation(amount, parts);
3412         // for (uint i = 0; i < parts; i++) {
3413         //     (bool success, bytes memory data) = address(bancorNetwork).staticcall.gas(500000)(
3414         //         abi.encodeWithSelector(
3415         //             bancorNetwork.getReturnByPath.selector,
3416         //             path,
3417         //             rets[i]
3418         //         )
3419         //     );
3420         //     if (!success || data.length == 0) {
3421         //         for (; i < parts; i++) {
3422         //             rets[i] = 0;
3423         //         }
3424         //         break;
3425         //     } else {
3426         //         (uint256 ret,) = abi.decode(data, (uint256,uint256));
3427         //         rets[i] = ret;
3428         //     }
3429         // }
3430 
3431         // return (rets, path.length.mul(150_000));
3432     }
3433 
3434     function calculateOasis(
3435         IERC20 fromToken,
3436         IERC20 destToken,
3437         uint256 amount,
3438         uint256 parts,
3439         uint256 /*flags*/
3440     ) internal view returns(uint256[] memory rets, uint256 gas) {
3441         rets = _linearInterpolation(amount, parts);
3442         for (uint i = 0; i < parts; i++) {
3443             (bool success, bytes memory data) = address(oasisExchange).staticcall.gas(500000)(
3444                 abi.encodeWithSelector(
3445                     oasisExchange.getBuyAmount.selector,
3446                     destToken.isETH() ? weth : destToken,
3447                     fromToken.isETH() ? weth : fromToken,
3448                     rets[i]
3449                 )
3450             );
3451 
3452             if (!success || data.length == 0) {
3453                 for (; i < parts; i++) {
3454                     rets[i] = 0;
3455                 }
3456                 break;
3457             } else {
3458                 rets[i] = abi.decode(data, (uint256));
3459             }
3460         }
3461 
3462         return (rets, 500_000);
3463     }
3464 
3465     function calculateMooniswapMany(
3466         IERC20 fromToken,
3467         IERC20 destToken,
3468         uint256[] memory amounts
3469     ) internal view returns(uint256[] memory rets, uint256 gas) {
3470         rets = new uint256[](amounts.length);
3471 
3472         IMooniswap mooniswap = mooniswapRegistry.pools(
3473             fromToken.isETH() ? ZERO_ADDRESS : fromToken,
3474             destToken.isETH() ? ZERO_ADDRESS : destToken
3475         );
3476         if (mooniswap == IMooniswap(0)) {
3477             return (rets, 0);
3478         }
3479 
3480         uint256 fee = mooniswap.fee();
3481         uint256 fromBalance = mooniswap.getBalanceForAddition(fromToken.isETH() ? ZERO_ADDRESS : fromToken);
3482         uint256 destBalance = mooniswap.getBalanceForRemoval(destToken.isETH() ? ZERO_ADDRESS : destToken);
3483         if (fromBalance == 0 || destBalance == 0) {
3484             return (rets, 0);
3485         }
3486 
3487         for (uint i = 0; i < amounts.length; i++) {
3488             uint256 amount = amounts[i].sub(amounts[i].mul(fee).div(1e18));
3489             rets[i] = amount.mul(destBalance).div(
3490                 fromBalance.add(amount)
3491             );
3492         }
3493 
3494         return (rets, (fromToken.isETH() || destToken.isETH()) ? 80_000 : 110_000);
3495     }
3496 
3497     function calculateMooniswap(
3498         IERC20 fromToken,
3499         IERC20 destToken,
3500         uint256 amount,
3501         uint256 parts,
3502         uint256 /*flags*/
3503     ) internal view returns(uint256[] memory rets, uint256 gas) {
3504         return calculateMooniswapMany(
3505             fromToken,
3506             destToken,
3507             _linearInterpolation(amount, parts)
3508         );
3509     }
3510 
3511     function calculateMooniswapOverETH(
3512         IERC20 fromToken,
3513         IERC20 destToken,
3514         uint256 amount,
3515         uint256 parts,
3516         uint256 flags
3517     ) internal view returns(uint256[] memory rets, uint256 gas) {
3518         if (fromToken.isETH() || destToken.isETH()) {
3519             return (new uint256[](parts), 0);
3520         }
3521 
3522         (uint256[] memory results, uint256 gas1) = calculateMooniswap(fromToken, ZERO_ADDRESS, amount, parts, flags);
3523         (rets, gas) = calculateMooniswapMany(ZERO_ADDRESS, destToken, results);
3524         gas = gas.add(gas1);
3525     }
3526 
3527     function calculateMooniswapOverDAI(
3528         IERC20 fromToken,
3529         IERC20 destToken,
3530         uint256 amount,
3531         uint256 parts,
3532         uint256 flags
3533     ) internal view returns(uint256[] memory rets, uint256 gas) {
3534         if (fromToken == dai || destToken == dai) {
3535             return (new uint256[](parts), 0);
3536         }
3537 
3538         (uint256[] memory results, uint256 gas1) = calculateMooniswap(fromToken, dai, amount, parts, flags);
3539         (rets, gas) = calculateMooniswapMany(dai, destToken, results);
3540         gas = gas.add(gas1);
3541     }
3542 
3543     function calculateMooniswapOverUSDC(
3544         IERC20 fromToken,
3545         IERC20 destToken,
3546         uint256 amount,
3547         uint256 parts,
3548         uint256 flags
3549     ) internal view returns(uint256[] memory rets, uint256 gas) {
3550         if (fromToken == usdc || destToken == usdc) {
3551             return (new uint256[](parts), 0);
3552         }
3553 
3554         (uint256[] memory results, uint256 gas1) = calculateMooniswap(fromToken, usdc, amount, parts, flags);
3555         (rets, gas) = calculateMooniswapMany(usdc, destToken, results);
3556         gas = gas.add(gas1);
3557     }
3558 
3559     function calculateUniswapV2(
3560         IERC20 fromToken,
3561         IERC20 destToken,
3562         uint256 amount,
3563         uint256 parts,
3564         uint256 flags
3565     ) internal view returns(uint256[] memory rets, uint256 gas) {
3566         return _calculateUniswapV2(
3567             fromToken,
3568             destToken,
3569             _linearInterpolation(amount, parts),
3570             flags
3571         );
3572     }
3573 
3574     function calculateUniswapV2ETH(
3575         IERC20 fromToken,
3576         IERC20 destToken,
3577         uint256 amount,
3578         uint256 parts,
3579         uint256 flags
3580     ) internal view returns(uint256[] memory rets, uint256 gas) {
3581         if (fromToken.isETH() || fromToken == weth || destToken.isETH() || destToken == weth) {
3582             return (new uint256[](parts), 0);
3583         }
3584 
3585         return _calculateUniswapV2OverMidToken(
3586             fromToken,
3587             weth,
3588             destToken,
3589             amount,
3590             parts,
3591             flags
3592         );
3593     }
3594 
3595     function calculateUniswapV2DAI(
3596         IERC20 fromToken,
3597         IERC20 destToken,
3598         uint256 amount,
3599         uint256 parts,
3600         uint256 flags
3601     ) internal view returns(uint256[] memory rets, uint256 gas) {
3602         if (fromToken == dai || destToken == dai) {
3603             return (new uint256[](parts), 0);
3604         }
3605 
3606         return _calculateUniswapV2OverMidToken(
3607             fromToken,
3608             dai,
3609             destToken,
3610             amount,
3611             parts,
3612             flags
3613         );
3614     }
3615 
3616     function calculateUniswapV2USDC(
3617         IERC20 fromToken,
3618         IERC20 destToken,
3619         uint256 amount,
3620         uint256 parts,
3621         uint256 flags
3622     ) internal view returns(uint256[] memory rets, uint256 gas) {
3623         if (fromToken == usdc || destToken == usdc) {
3624             return (new uint256[](parts), 0);
3625         }
3626 
3627         return _calculateUniswapV2OverMidToken(
3628             fromToken,
3629             usdc,
3630             destToken,
3631             amount,
3632             parts,
3633             flags
3634         );
3635     }
3636 
3637     function _calculateUniswapV2(
3638         IERC20 fromToken,
3639         IERC20 destToken,
3640         uint256[] memory amounts,
3641         uint256 /*flags*/
3642     ) internal view returns(uint256[] memory rets, uint256 gas) {
3643         rets = new uint256[](amounts.length);
3644 
3645         IERC20 fromTokenReal = fromToken.isETH() ? weth : fromToken;
3646         IERC20 destTokenReal = destToken.isETH() ? weth : destToken;
3647         IUniswapV2Exchange exchange = uniswapV2.getPair(fromTokenReal, destTokenReal);
3648         if (exchange != IUniswapV2Exchange(0)) {
3649             uint256 fromTokenBalance = fromTokenReal.universalBalanceOf(address(exchange));
3650             uint256 destTokenBalance = destTokenReal.universalBalanceOf(address(exchange));
3651             for (uint i = 0; i < amounts.length; i++) {
3652                 rets[i] = _calculateUniswapFormula(fromTokenBalance, destTokenBalance, amounts[i]);
3653             }
3654             return (rets, 50_000);
3655         }
3656     }
3657 
3658     function _calculateUniswapV2OverMidToken(
3659         IERC20 fromToken,
3660         IERC20 midToken,
3661         IERC20 destToken,
3662         uint256 amount,
3663         uint256 parts,
3664         uint256 flags
3665     ) internal view returns(uint256[] memory rets, uint256 gas) {
3666         rets = _linearInterpolation(amount, parts);
3667 
3668         uint256 gas1;
3669         uint256 gas2;
3670         (rets, gas1) = _calculateUniswapV2(fromToken, midToken, rets, flags);
3671         (rets, gas2) = _calculateUniswapV2(midToken, destToken, rets, flags);
3672         return (rets, gas1 + gas2);
3673     }
3674 
3675     function _calculateNoReturn(
3676         IERC20 /*fromToken*/,
3677         IERC20 /*destToken*/,
3678         uint256 /*amount*/,
3679         uint256 parts,
3680         uint256 /*flags*/
3681     ) internal view returns(uint256[] memory rets, uint256 gas) {
3682         this;
3683         return (new uint256[](parts), 0);
3684     }
3685 }
3686 
3687 
3688 contract OneSplitBaseWrap is IOneSplit, OneSplitRoot {
3689     function _swap(
3690         IERC20 fromToken,
3691         IERC20 destToken,
3692         uint256 amount,
3693         uint256[] memory distribution,
3694         uint256 flags // See constants in IOneSplit.sol
3695     ) internal {
3696         if (fromToken == destToken) {
3697             return;
3698         }
3699 
3700         _swapFloor(
3701             fromToken,
3702             destToken,
3703             amount,
3704             distribution,
3705             flags
3706         );
3707     }
3708 
3709     function _swapFloor(
3710         IERC20 fromToken,
3711         IERC20 destToken,
3712         uint256 amount,
3713         uint256[] memory distribution,
3714         uint256 /*flags*/ // See constants in IOneSplit.sol
3715     ) internal;
3716 }
3717 
3718 
3719 contract OneSplit is IOneSplit, OneSplitRoot {
3720     IOneSplitView public oneSplitView;
3721 
3722     constructor(IOneSplitView _oneSplitView) public {
3723         oneSplitView = _oneSplitView;
3724     }
3725 
3726     function() external payable {
3727         // solium-disable-next-line security/no-tx-origin
3728         require(msg.sender != tx.origin);
3729     }
3730 
3731     function getExpectedReturn(
3732         IERC20 fromToken,
3733         IERC20 destToken,
3734         uint256 amount,
3735         uint256 parts,
3736         uint256 flags
3737     )
3738         public
3739         view
3740         returns(
3741             uint256 returnAmount,
3742             uint256[] memory distribution
3743         )
3744     {
3745         (returnAmount, , distribution) = getExpectedReturnWithGas(
3746             fromToken,
3747             destToken,
3748             amount,
3749             parts,
3750             flags,
3751             0
3752         );
3753     }
3754 
3755     function getExpectedReturnWithGas(
3756         IERC20 fromToken,
3757         IERC20 destToken,
3758         uint256 amount,
3759         uint256 parts,
3760         uint256 flags,
3761         uint256 destTokenEthPriceTimesGasPrice
3762     )
3763         public
3764         view
3765         returns(
3766             uint256 returnAmount,
3767             uint256 estimateGasAmount,
3768             uint256[] memory distribution
3769         )
3770     {
3771         return oneSplitView.getExpectedReturnWithGas(
3772             fromToken,
3773             destToken,
3774             amount,
3775             parts,
3776             flags,
3777             destTokenEthPriceTimesGasPrice
3778         );
3779     }
3780 
3781     function swap(
3782         IERC20 fromToken,
3783         IERC20 destToken,
3784         uint256 amount,
3785         uint256 minReturn,
3786         uint256[] memory distribution,
3787         uint256 flags  // See constants in IOneSplit.sol
3788     ) public payable returns(uint256 returnAmount) {
3789         if (fromToken == destToken) {
3790             return amount;
3791         }
3792 
3793         function(IERC20,IERC20,uint256,uint256)[DEXES_COUNT] memory reserves = [
3794             _swapOnUniswap,
3795             _swapOnNowhere,
3796             _swapOnBancor,
3797             _swapOnOasis,
3798             _swapOnCurveCompound,
3799             _swapOnCurveUSDT,
3800             _swapOnCurveY,
3801             _swapOnCurveBinance,
3802             _swapOnCurveSynthetix,
3803             _swapOnUniswapCompound,
3804             _swapOnUniswapChai,
3805             _swapOnUniswapAave,
3806             _swapOnMooniswap,
3807             _swapOnUniswapV2,
3808             _swapOnUniswapV2ETH,
3809             _swapOnUniswapV2DAI,
3810             _swapOnUniswapV2USDC,
3811             _swapOnCurvePAX,
3812             _swapOnCurveRenBTC,
3813             _swapOnCurveTBTC,
3814             _swapOnDforceSwap,
3815             _swapOnShell,
3816             _swapOnMStableMUSD,
3817             _swapOnCurveSBTC,
3818             _swapOnBalancer1,
3819             _swapOnBalancer2,
3820             _swapOnBalancer3,
3821             _swapOnKyber1,
3822             _swapOnKyber2,
3823             _swapOnKyber3,
3824             _swapOnKyber4,
3825             _swapOnMooniswapETH,
3826             _swapOnMooniswapDAI,
3827             _swapOnMooniswapUSDC
3828         ];
3829 
3830         require(distribution.length <= reserves.length, "OneSplit: Distribution array should not exceed reserves array size");
3831 
3832         uint256 parts = 0;
3833         uint256 lastNonZeroIndex = 0;
3834         for (uint i = 0; i < distribution.length; i++) {
3835             if (distribution[i] > 0) {
3836                 parts = parts.add(distribution[i]);
3837                 lastNonZeroIndex = i;
3838             }
3839         }
3840 
3841         if (parts == 0) {
3842             if (fromToken.isETH()) {
3843                 msg.sender.transfer(msg.value);
3844                 return msg.value;
3845             }
3846             return amount;
3847         }
3848 
3849         fromToken.universalTransferFrom(msg.sender, address(this), amount);
3850         uint256 remainingAmount = fromToken.universalBalanceOf(address(this));
3851 
3852         for (uint i = 0; i < distribution.length; i++) {
3853             if (distribution[i] == 0) {
3854                 continue;
3855             }
3856 
3857             uint256 swapAmount = amount.mul(distribution[i]).div(parts);
3858             if (i == lastNonZeroIndex) {
3859                 swapAmount = remainingAmount;
3860             }
3861             remainingAmount -= swapAmount;
3862             reserves[i](fromToken, destToken, swapAmount, flags);
3863         }
3864 
3865         returnAmount = destToken.universalBalanceOf(address(this));
3866         require(returnAmount >= minReturn, "OneSplit: Return amount was not enough");
3867         destToken.universalTransfer(msg.sender, returnAmount);
3868         fromToken.universalTransfer(msg.sender, fromToken.universalBalanceOf(address(this)));
3869     }
3870 
3871     // Swap helpers
3872 
3873     function _swapOnCurveCompound(
3874         IERC20 fromToken,
3875         IERC20 destToken,
3876         uint256 amount,
3877         uint256 /*flags*/
3878     ) internal {
3879         int128 i = (fromToken == dai ? 1 : 0) + (fromToken == usdc ? 2 : 0);
3880         int128 j = (destToken == dai ? 1 : 0) + (destToken == usdc ? 2 : 0);
3881         if (i == 0 || j == 0) {
3882             return;
3883         }
3884 
3885         fromToken.universalApprove(address(curveCompound), amount);
3886         curveCompound.exchange_underlying(i - 1, j - 1, amount, 0);
3887     }
3888 
3889     function _swapOnCurveUSDT(
3890         IERC20 fromToken,
3891         IERC20 destToken,
3892         uint256 amount,
3893         uint256 /*flags*/
3894     ) internal {
3895         int128 i = (fromToken == dai ? 1 : 0) +
3896             (fromToken == usdc ? 2 : 0) +
3897             (fromToken == usdt ? 3 : 0);
3898         int128 j = (destToken == dai ? 1 : 0) +
3899             (destToken == usdc ? 2 : 0) +
3900             (destToken == usdt ? 3 : 0);
3901         if (i == 0 || j == 0) {
3902             return;
3903         }
3904 
3905         fromToken.universalApprove(address(curveUSDT), amount);
3906         curveUSDT.exchange_underlying(i - 1, j - 1, amount, 0);
3907     }
3908 
3909     function _swapOnCurveY(
3910         IERC20 fromToken,
3911         IERC20 destToken,
3912         uint256 amount,
3913         uint256 /*flags*/
3914     ) internal {
3915         int128 i = (fromToken == dai ? 1 : 0) +
3916             (fromToken == usdc ? 2 : 0) +
3917             (fromToken == usdt ? 3 : 0) +
3918             (fromToken == tusd ? 4 : 0);
3919         int128 j = (destToken == dai ? 1 : 0) +
3920             (destToken == usdc ? 2 : 0) +
3921             (destToken == usdt ? 3 : 0) +
3922             (destToken == tusd ? 4 : 0);
3923         if (i == 0 || j == 0) {
3924             return;
3925         }
3926 
3927         fromToken.universalApprove(address(curveY), amount);
3928         curveY.exchange_underlying(i - 1, j - 1, amount, 0);
3929     }
3930 
3931     function _swapOnCurveBinance(
3932         IERC20 fromToken,
3933         IERC20 destToken,
3934         uint256 amount,
3935         uint256 /*flags*/
3936     ) internal {
3937         int128 i = (fromToken == dai ? 1 : 0) +
3938             (fromToken == usdc ? 2 : 0) +
3939             (fromToken == usdt ? 3 : 0) +
3940             (fromToken == busd ? 4 : 0);
3941         int128 j = (destToken == dai ? 1 : 0) +
3942             (destToken == usdc ? 2 : 0) +
3943             (destToken == usdt ? 3 : 0) +
3944             (destToken == busd ? 4 : 0);
3945         if (i == 0 || j == 0) {
3946             return;
3947         }
3948 
3949         fromToken.universalApprove(address(curveBinance), amount);
3950         curveBinance.exchange_underlying(i - 1, j - 1, amount, 0);
3951     }
3952 
3953     function _swapOnCurveSynthetix(
3954         IERC20 fromToken,
3955         IERC20 destToken,
3956         uint256 amount,
3957         uint256 /*flags*/
3958     ) internal {
3959         int128 i = (fromToken == dai ? 1 : 0) +
3960             (fromToken == usdc ? 2 : 0) +
3961             (fromToken == usdt ? 3 : 0) +
3962             (fromToken == susd ? 4 : 0);
3963         int128 j = (destToken == dai ? 1 : 0) +
3964             (destToken == usdc ? 2 : 0) +
3965             (destToken == usdt ? 3 : 0) +
3966             (destToken == susd ? 4 : 0);
3967         if (i == 0 || j == 0) {
3968             return;
3969         }
3970 
3971         fromToken.universalApprove(address(curveSynthetix), amount);
3972         curveSynthetix.exchange_underlying(i - 1, j - 1, amount, 0);
3973     }
3974 
3975     function _swapOnCurvePAX(
3976         IERC20 fromToken,
3977         IERC20 destToken,
3978         uint256 amount,
3979         uint256 /*flags*/
3980     ) internal {
3981         int128 i = (fromToken == dai ? 1 : 0) +
3982             (fromToken == usdc ? 2 : 0) +
3983             (fromToken == usdt ? 3 : 0) +
3984             (fromToken == pax ? 4 : 0);
3985         int128 j = (destToken == dai ? 1 : 0) +
3986             (destToken == usdc ? 2 : 0) +
3987             (destToken == usdt ? 3 : 0) +
3988             (destToken == pax ? 4 : 0);
3989         if (i == 0 || j == 0) {
3990             return;
3991         }
3992 
3993         fromToken.universalApprove(address(curvePAX), amount);
3994         curvePAX.exchange_underlying(i - 1, j - 1, amount, 0);
3995     }
3996 
3997     function _swapOnShell(
3998         IERC20 fromToken,
3999         IERC20 destToken,
4000         uint256 amount,
4001         uint256 /*flags*/
4002     ) internal {
4003         fromToken.universalApprove(address(shell), amount);
4004         shell.swapByOrigin(
4005             address(fromToken),
4006             address(destToken),
4007             amount,
4008             0,
4009             now + 50
4010         );
4011     }
4012 
4013     function _swapOnMStableMUSD(
4014         IERC20 fromToken,
4015         IERC20 destToken,
4016         uint256 amount,
4017         uint256 /*flags*/
4018     ) internal {
4019         fromToken.universalApprove(address(musd), amount);
4020         musd.swap(
4021             fromToken,
4022             destToken,
4023             amount,
4024             address(this)
4025         );
4026     }
4027 
4028     function _swapOnCurveRenBTC(
4029         IERC20 fromToken,
4030         IERC20 destToken,
4031         uint256 amount,
4032         uint256 /*flags*/
4033     ) internal {
4034         int128 i = (fromToken == renbtc ? 1 : 0) +
4035             (fromToken == wbtc ? 2 : 0);
4036         int128 j = (destToken == renbtc ? 1 : 0) +
4037             (destToken == wbtc ? 2 : 0);
4038         if (i == 0 || j == 0) {
4039             return;
4040         }
4041 
4042         fromToken.universalApprove(address(curveRenBTC), amount);
4043         curveRenBTC.exchange(i - 1, j - 1, amount, 0);
4044     }
4045 
4046     function _swapOnCurveTBTC(
4047         IERC20 fromToken,
4048         IERC20 destToken,
4049         uint256 amount,
4050         uint256 /*flags*/
4051     ) internal {
4052         int128 i = (fromToken == tbtc ? 1 : 0) +
4053             (fromToken == wbtc ? 2 : 0) +
4054             (fromToken == hbtc ? 3 : 0);
4055         int128 j = (destToken == tbtc ? 1 : 0) +
4056             (destToken == wbtc ? 2 : 0) +
4057             (destToken == hbtc ? 3 : 0);
4058         if (i == 0 || j == 0) {
4059             return;
4060         }
4061 
4062         fromToken.universalApprove(address(curveTBTC), amount);
4063         curveTBTC.exchange(i - 1, j - 1, amount, 0);
4064     }
4065 
4066     function _swapOnCurveSBTC(
4067         IERC20 fromToken,
4068         IERC20 destToken,
4069         uint256 amount,
4070         uint256 /*flags*/
4071     ) internal {
4072         int128 i = (fromToken == renbtc ? 1 : 0) +
4073             (fromToken == wbtc ? 2 : 0) +
4074             (fromToken == sbtc ? 3 : 0);
4075         int128 j = (destToken == renbtc ? 1 : 0) +
4076             (destToken == wbtc ? 2 : 0) +
4077             (destToken == sbtc ? 3 : 0);
4078         if (i == 0 || j == 0) {
4079             return;
4080         }
4081 
4082         fromToken.universalApprove(address(curveSBTC), amount);
4083         curveSBTC.exchange(i - 1, j - 1, amount, 0);
4084     }
4085 
4086     function _swapOnDforceSwap(
4087         IERC20 fromToken,
4088         IERC20 destToken,
4089         uint256 amount,
4090         uint256 /*flags*/
4091     ) internal {
4092         fromToken.universalApprove(address(dforceSwap), amount);
4093         dforceSwap.swap(fromToken, destToken, amount);
4094     }
4095 
4096     function _swapOnUniswap(
4097         IERC20 fromToken,
4098         IERC20 destToken,
4099         uint256 amount,
4100         uint256 /*flags*/
4101     ) internal {
4102         uint256 returnAmount = amount;
4103 
4104         if (!fromToken.isETH()) {
4105             IUniswapExchange fromExchange = uniswapFactory.getExchange(fromToken);
4106             if (fromExchange != IUniswapExchange(0)) {
4107                 fromToken.universalApprove(address(fromExchange), returnAmount);
4108                 returnAmount = fromExchange.tokenToEthSwapInput(returnAmount, 1, now);
4109             }
4110         }
4111 
4112         if (!destToken.isETH()) {
4113             IUniswapExchange toExchange = uniswapFactory.getExchange(destToken);
4114             if (toExchange != IUniswapExchange(0)) {
4115                 returnAmount = toExchange.ethToTokenSwapInput.value(returnAmount)(1, now);
4116             }
4117         }
4118     }
4119 
4120     function _swapOnUniswapCompound(
4121         IERC20 fromToken,
4122         IERC20 destToken,
4123         uint256 amount,
4124         uint256 flags
4125     ) internal {
4126         if (!fromToken.isETH()) {
4127             ICompoundToken fromCompound = compoundRegistry.cTokenByToken(fromToken);
4128             fromToken.universalApprove(address(fromCompound), amount);
4129             fromCompound.mint(amount);
4130             _swapOnUniswap(IERC20(fromCompound), destToken, IERC20(fromCompound).universalBalanceOf(address(this)), flags);
4131             return;
4132         }
4133 
4134         if (!destToken.isETH()) {
4135             ICompoundToken toCompound = compoundRegistry.cTokenByToken(destToken);
4136             _swapOnUniswap(fromToken, IERC20(toCompound), amount, flags);
4137             toCompound.redeem(IERC20(toCompound).universalBalanceOf(address(this)));
4138             destToken.universalBalanceOf(address(this));
4139             return;
4140         }
4141     }
4142 
4143     function _swapOnUniswapChai(
4144         IERC20 fromToken,
4145         IERC20 destToken,
4146         uint256 amount,
4147         uint256 flags
4148     ) internal {
4149         if (fromToken == dai) {
4150             fromToken.universalApprove(address(chai), amount);
4151             chai.join(address(this), amount);
4152             _swapOnUniswap(IERC20(chai), destToken, IERC20(chai).universalBalanceOf(address(this)), flags);
4153             return;
4154         }
4155 
4156         if (destToken == dai) {
4157             _swapOnUniswap(fromToken, IERC20(chai), amount, flags);
4158             chai.exit(address(this), chai.balanceOf(address(this)));
4159             return;
4160         }
4161     }
4162 
4163     function _swapOnUniswapAave(
4164         IERC20 fromToken,
4165         IERC20 destToken,
4166         uint256 amount,
4167         uint256 flags
4168     ) internal {
4169         if (!fromToken.isETH()) {
4170             IAaveToken fromAave = aaveRegistry.aTokenByToken(fromToken);
4171             fromToken.universalApprove(aave.core(), amount);
4172             aave.deposit(fromToken, amount, 1101);
4173             _swapOnUniswap(IERC20(fromAave), destToken, IERC20(fromAave).universalBalanceOf(address(this)), flags);
4174             return;
4175         }
4176 
4177         if (!destToken.isETH()) {
4178             IAaveToken toAave = aaveRegistry.aTokenByToken(destToken);
4179             _swapOnUniswap(fromToken, IERC20(toAave), amount, flags);
4180             toAave.redeem(toAave.balanceOf(address(this)));
4181             return;
4182         }
4183     }
4184 
4185     function _swapOnMooniswap(
4186         IERC20 fromToken,
4187         IERC20 destToken,
4188         uint256 amount,
4189         uint256 /*flags*/
4190     ) internal {
4191         IMooniswap mooniswap = mooniswapRegistry.pools(
4192             fromToken.isETH() ? ZERO_ADDRESS : fromToken,
4193             destToken.isETH() ? ZERO_ADDRESS : destToken
4194         );
4195         fromToken.universalApprove(address(mooniswap), amount);
4196         mooniswap.swap.value(fromToken.isETH() ? amount : 0)(
4197             fromToken.isETH() ? ZERO_ADDRESS : fromToken,
4198             destToken.isETH() ? ZERO_ADDRESS : destToken,
4199             amount,
4200             0,
4201             0x68a17B587CAF4f9329f0e372e3A78D23A46De6b5
4202         );
4203     }
4204 
4205     function _swapOnMooniswapETH(
4206         IERC20 fromToken,
4207         IERC20 destToken,
4208         uint256 amount,
4209         uint256 flags
4210     ) internal {
4211         _swapOnMooniswap(fromToken, ZERO_ADDRESS, amount, flags);
4212         _swapOnMooniswap(ZERO_ADDRESS, destToken, address(this).balance, flags);
4213     }
4214 
4215     function _swapOnMooniswapDAI(
4216         IERC20 fromToken,
4217         IERC20 destToken,
4218         uint256 amount,
4219         uint256 flags
4220     ) internal {
4221         _swapOnMooniswap(fromToken, dai, amount, flags);
4222         _swapOnMooniswap(dai, destToken, dai.balanceOf(address(this)), flags);
4223     }
4224 
4225     function _swapOnMooniswapUSDC(
4226         IERC20 fromToken,
4227         IERC20 destToken,
4228         uint256 amount,
4229         uint256 flags
4230     ) internal {
4231         _swapOnMooniswap(fromToken, usdc, amount, flags);
4232         _swapOnMooniswap(usdc, destToken, usdc.balanceOf(address(this)), flags);
4233     }
4234 
4235     function _swapOnNowhere(
4236         IERC20 /*fromToken*/,
4237         IERC20 /*destToken*/,
4238         uint256 /*amount*/,
4239         uint256 /*flags*/
4240     ) internal {
4241         revert("This source was deprecated");
4242     }
4243 
4244     function _swapOnKyber1(
4245         IERC20 fromToken,
4246         IERC20 destToken,
4247         uint256 amount,
4248         uint256 flags
4249     ) internal {
4250         _swapOnKyber(
4251             fromToken,
4252             destToken,
4253             amount,
4254             flags,
4255             0xff4b796265722046707200000000000000000000000000000000000000000000
4256         );
4257     }
4258 
4259     function _swapOnKyber2(
4260         IERC20 fromToken,
4261         IERC20 destToken,
4262         uint256 amount,
4263         uint256 flags
4264     ) internal {
4265         _swapOnKyber(
4266             fromToken,
4267             destToken,
4268             amount,
4269             flags,
4270             0xffabcd0000000000000000000000000000000000000000000000000000000000
4271         );
4272     }
4273 
4274     function _swapOnKyber3(
4275         IERC20 fromToken,
4276         IERC20 destToken,
4277         uint256 amount,
4278         uint256 flags
4279     ) internal {
4280         _swapOnKyber(
4281             fromToken,
4282             destToken,
4283             amount,
4284             flags,
4285             0xff4f6e65426974205175616e7400000000000000000000000000000000000000
4286         );
4287     }
4288 
4289     function _swapOnKyber4(
4290         IERC20 fromToken,
4291         IERC20 destToken,
4292         uint256 amount,
4293         uint256 flags
4294     ) internal {
4295         _swapOnKyber(
4296             fromToken,
4297             destToken,
4298             amount,
4299             flags,
4300             _kyberReserveIdByTokens(fromToken, destToken)
4301         );
4302     }
4303 
4304     function _swapOnKyber(
4305         IERC20 fromToken,
4306         IERC20 destToken,
4307         uint256 amount,
4308         uint256 flags,
4309         bytes32 reserveId
4310     ) internal {
4311         uint256 returnAmount = amount;
4312 
4313         bytes32[] memory reserveIds = new bytes32[](1);
4314         reserveIds[0] = reserveId;
4315 
4316         if (!fromToken.isETH()) {
4317             bytes memory fromHint = kyberHintHandler.buildTokenToEthHint(
4318                 fromToken,
4319                 IKyberHintHandler.TradeType.MaskIn,
4320                 reserveIds,
4321                 new uint256[](0)
4322             );
4323 
4324             fromToken.universalApprove(address(kyberNetworkProxy), amount);
4325             returnAmount = kyberNetworkProxy.tradeWithHintAndFee(
4326                 fromToken,
4327                 returnAmount,
4328                 ETH_ADDRESS,
4329                 address(this),
4330                 uint256(-1),
4331                 0,
4332                 0x68a17B587CAF4f9329f0e372e3A78D23A46De6b5,
4333                 (flags >> 255) * 10,
4334                 fromHint
4335             );
4336         }
4337 
4338         if (!destToken.isETH()) {
4339             bytes memory destHint = kyberHintHandler.buildEthToTokenHint(
4340                 destToken,
4341                 IKyberHintHandler.TradeType.MaskIn,
4342                 reserveIds,
4343                 new uint256[](0)
4344             );
4345 
4346             returnAmount = kyberNetworkProxy.tradeWithHintAndFee.value(returnAmount)(
4347                 ETH_ADDRESS,
4348                 returnAmount,
4349                 destToken,
4350                 address(this),
4351                 uint256(-1),
4352                 0,
4353                 0x68a17B587CAF4f9329f0e372e3A78D23A46De6b5,
4354                 (flags >> 255) * 10,
4355                 destHint
4356             );
4357         }
4358     }
4359 
4360     function _swapOnBancor(
4361         IERC20 fromToken,
4362         IERC20 destToken,
4363         uint256 amount,
4364         uint256 /*flags*/
4365     ) internal {
4366         IBancorNetwork bancorNetwork = IBancorNetwork(bancorContractRegistry.addressOf("BancorNetwork"));
4367         address[] memory path = bancorNetworkPathFinder.generatePath(
4368             fromToken.isETH() ? bancorEtherToken : fromToken,
4369             destToken.isETH() ? bancorEtherToken : destToken
4370         );
4371         fromToken.universalApprove(address(bancorNetwork), amount);
4372         bancorNetwork.convert.value(fromToken.isETH() ? amount : 0)(path, amount, 1);
4373     }
4374 
4375     function _swapOnOasis(
4376         IERC20 fromToken,
4377         IERC20 destToken,
4378         uint256 amount,
4379         uint256 /*flags*/
4380     ) internal {
4381         if (fromToken.isETH()) {
4382             weth.deposit.value(amount)();
4383         }
4384 
4385         IERC20 approveToken = fromToken.isETH() ? weth : fromToken;
4386         approveToken.universalApprove(address(oasisExchange), amount);
4387         oasisExchange.sellAllAmount(
4388             fromToken.isETH() ? weth : fromToken,
4389             amount,
4390             destToken.isETH() ? weth : destToken,
4391             1
4392         );
4393 
4394         if (destToken.isETH()) {
4395             weth.withdraw(weth.balanceOf(address(this)));
4396         }
4397     }
4398 
4399     function _swapOnUniswapV2Internal(
4400         IERC20 fromToken,
4401         IERC20 destToken,
4402         uint256 amount,
4403         uint256 /*flags*/
4404     ) internal returns(uint256 returnAmount) {
4405         if (fromToken.isETH()) {
4406             weth.deposit.value(amount)();
4407         }
4408 
4409         IERC20 fromTokenReal = fromToken.isETH() ? weth : fromToken;
4410         IERC20 toTokenReal = destToken.isETH() ? weth : destToken;
4411         IUniswapV2Exchange exchange = uniswapV2.getPair(fromTokenReal, toTokenReal);
4412         bool needSync;
4413         bool needSkim;
4414         (returnAmount, needSync, needSkim) = exchange.getReturn(fromTokenReal, toTokenReal, amount);
4415         if (needSync) {
4416             exchange.sync();
4417         }
4418         else if (needSkim) {
4419             exchange.skim(0x68a17B587CAF4f9329f0e372e3A78D23A46De6b5);
4420         }
4421 
4422         fromTokenReal.universalTransfer(address(exchange), amount);
4423         if (uint256(address(fromTokenReal)) < uint256(address(toTokenReal))) {
4424             exchange.swap(0, returnAmount, address(this), "");
4425         } else {
4426             exchange.swap(returnAmount, 0, address(this), "");
4427         }
4428 
4429         if (destToken.isETH()) {
4430             weth.withdraw(weth.balanceOf(address(this)));
4431         }
4432     }
4433 
4434     function _swapOnUniswapV2OverMid(
4435         IERC20 fromToken,
4436         IERC20 midToken,
4437         IERC20 destToken,
4438         uint256 amount,
4439         uint256 flags
4440     ) internal {
4441         _swapOnUniswapV2Internal(
4442             midToken,
4443             destToken,
4444             _swapOnUniswapV2Internal(
4445                 fromToken,
4446                 midToken,
4447                 amount,
4448                 flags
4449             ),
4450             flags
4451         );
4452     }
4453 
4454     function _swapOnUniswapV2(
4455         IERC20 fromToken,
4456         IERC20 destToken,
4457         uint256 amount,
4458         uint256 flags
4459     ) internal {
4460         _swapOnUniswapV2Internal(
4461             fromToken,
4462             destToken,
4463             amount,
4464             flags
4465         );
4466     }
4467 
4468     function _swapOnUniswapV2ETH(
4469         IERC20 fromToken,
4470         IERC20 destToken,
4471         uint256 amount,
4472         uint256 flags
4473     ) internal {
4474         _swapOnUniswapV2OverMid(
4475             fromToken,
4476             weth,
4477             destToken,
4478             amount,
4479             flags
4480         );
4481     }
4482 
4483     function _swapOnUniswapV2DAI(
4484         IERC20 fromToken,
4485         IERC20 destToken,
4486         uint256 amount,
4487         uint256 flags
4488     ) internal {
4489         _swapOnUniswapV2OverMid(
4490             fromToken,
4491             dai,
4492             destToken,
4493             amount,
4494             flags
4495         );
4496     }
4497 
4498     function _swapOnUniswapV2USDC(
4499         IERC20 fromToken,
4500         IERC20 destToken,
4501         uint256 amount,
4502         uint256 flags
4503     ) internal {
4504         _swapOnUniswapV2OverMid(
4505             fromToken,
4506             usdc,
4507             destToken,
4508             amount,
4509             flags
4510         );
4511     }
4512 
4513     function _swapOnBalancerX(
4514         IERC20 fromToken,
4515         IERC20 destToken,
4516         uint256 amount,
4517         uint256 /*flags*/,
4518         uint256 poolIndex
4519     ) internal {
4520         address[] memory pools = balancerRegistry.getBestPoolsWithLimit(
4521             address(fromToken.isETH() ? weth : fromToken),
4522             address(destToken.isETH() ? weth : destToken),
4523             poolIndex + 1
4524         );
4525 
4526         if (fromToken.isETH()) {
4527             weth.deposit.value(amount)();
4528         }
4529 
4530         (fromToken.isETH() ? weth : fromToken).universalApprove(pools[poolIndex], amount);
4531         IBalancerPool(pools[poolIndex]).swapExactAmountIn(
4532             fromToken.isETH() ? weth : fromToken,
4533             amount,
4534             destToken.isETH() ? weth : destToken,
4535             0,
4536             uint256(-1)
4537         );
4538 
4539         if (destToken.isETH()) {
4540             weth.withdraw(weth.balanceOf(address(this)));
4541         }
4542     }
4543 
4544     function _swapOnBalancer1(
4545         IERC20 fromToken,
4546         IERC20 destToken,
4547         uint256 amount,
4548         uint256 flags
4549     ) internal {
4550         _swapOnBalancerX(fromToken, destToken, amount, flags, 0);
4551     }
4552 
4553     function _swapOnBalancer2(
4554         IERC20 fromToken,
4555         IERC20 destToken,
4556         uint256 amount,
4557         uint256 flags
4558     ) internal {
4559         _swapOnBalancerX(fromToken, destToken, amount, flags, 1);
4560     }
4561 
4562     function _swapOnBalancer3(
4563         IERC20 fromToken,
4564         IERC20 destToken,
4565         uint256 amount,
4566         uint256 flags
4567     ) internal {
4568         _swapOnBalancerX(fromToken, destToken, amount, flags, 2);
4569     }
4570 }
4571 
4572 // File: contracts/OneSplitCompound.sol
4573 
4574 pragma solidity ^0.5.0;
4575 
4576 
4577 
4578 
4579 contract OneSplitCompoundView is OneSplitViewWrapBase {
4580     function getExpectedReturnWithGas(
4581         IERC20 fromToken,
4582         IERC20 destToken,
4583         uint256 amount,
4584         uint256 parts,
4585         uint256 flags,
4586         uint256 destTokenEthPriceTimesGasPrice
4587     )
4588         public
4589         view
4590         returns(
4591             uint256 returnAmount,
4592             uint256 estimateGasAmount,
4593             uint256[] memory distribution
4594         )
4595     {
4596         return _compoundGetExpectedReturn(
4597             fromToken,
4598             destToken,
4599             amount,
4600             parts,
4601             flags,
4602             destTokenEthPriceTimesGasPrice
4603         );
4604     }
4605 
4606     function _compoundGetExpectedReturn(
4607         IERC20 fromToken,
4608         IERC20 destToken,
4609         uint256 amount,
4610         uint256 parts,
4611         uint256 flags,
4612         uint256 destTokenEthPriceTimesGasPrice
4613     )
4614         private
4615         view
4616         returns(
4617             uint256 returnAmount,
4618             uint256 estimateGasAmount,
4619             uint256[] memory distribution
4620         )
4621     {
4622         if (fromToken == destToken) {
4623             return (amount, 0, new uint256[](DEXES_COUNT));
4624         }
4625 
4626         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_COMPOUND)) {
4627             IERC20 underlying = compoundRegistry.tokenByCToken(ICompoundToken(address(fromToken)));
4628             if (underlying != IERC20(0)) {
4629                 uint256 compoundRate = ICompoundToken(address(fromToken)).exchangeRateStored();
4630                 (returnAmount, estimateGasAmount, distribution) = _compoundGetExpectedReturn(
4631                     underlying,
4632                     destToken,
4633                     amount.mul(compoundRate).div(1e18),
4634                     parts,
4635                     flags,
4636                     destTokenEthPriceTimesGasPrice
4637                 );
4638                 return (returnAmount, estimateGasAmount + 295_000, distribution);
4639             }
4640 
4641             underlying = compoundRegistry.tokenByCToken(ICompoundToken(address(destToken)));
4642             if (underlying != IERC20(0)) {
4643                 uint256 _destTokenEthPriceTimesGasPrice = destTokenEthPriceTimesGasPrice;
4644                 uint256 compoundRate = ICompoundToken(address(destToken)).exchangeRateStored();
4645                 (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
4646                     fromToken,
4647                     underlying,
4648                     amount,
4649                     parts,
4650                     flags,
4651                     _destTokenEthPriceTimesGasPrice.mul(compoundRate).div(1e18)
4652                 );
4653                 return (returnAmount.mul(1e18).div(compoundRate), estimateGasAmount + 430_000, distribution);
4654             }
4655         }
4656 
4657         return super.getExpectedReturnWithGas(
4658             fromToken,
4659             destToken,
4660             amount,
4661             parts,
4662             flags,
4663             destTokenEthPriceTimesGasPrice
4664         );
4665     }
4666 }
4667 
4668 
4669 contract OneSplitCompound is OneSplitBaseWrap {
4670     function _swap(
4671         IERC20 fromToken,
4672         IERC20 destToken,
4673         uint256 amount,
4674         uint256[] memory distribution,
4675         uint256 flags
4676     ) internal {
4677         _compoundSwap(
4678             fromToken,
4679             destToken,
4680             amount,
4681             distribution,
4682             flags
4683         );
4684     }
4685 
4686     function _compoundSwap(
4687         IERC20 fromToken,
4688         IERC20 destToken,
4689         uint256 amount,
4690         uint256[] memory distribution,
4691         uint256 flags
4692     ) private {
4693         if (fromToken == destToken) {
4694             return;
4695         }
4696 
4697         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_COMPOUND)) {
4698             IERC20 underlying = compoundRegistry.tokenByCToken(ICompoundToken(address(fromToken)));
4699             if (underlying != IERC20(0)) {
4700                 ICompoundToken(address(fromToken)).redeem(amount);
4701                 uint256 underlyingAmount = underlying.universalBalanceOf(address(this));
4702 
4703                 return _compoundSwap(
4704                     underlying,
4705                     destToken,
4706                     underlyingAmount,
4707                     distribution,
4708                     flags
4709                 );
4710             }
4711 
4712             underlying = compoundRegistry.tokenByCToken(ICompoundToken(address(destToken)));
4713             if (underlying != IERC20(0)) {
4714                 super._swap(
4715                     fromToken,
4716                     underlying,
4717                     amount,
4718                     distribution,
4719                     flags
4720                 );
4721 
4722                 uint256 underlyingAmount = underlying.universalBalanceOf(address(this));
4723 
4724                 if (underlying.isETH()) {
4725                     cETH.mint.value(underlyingAmount)();
4726                 } else {
4727                     underlying.universalApprove(address(destToken), underlyingAmount);
4728                     ICompoundToken(address(destToken)).mint(underlyingAmount);
4729                 }
4730                 return;
4731             }
4732         }
4733 
4734         return super._swap(
4735             fromToken,
4736             destToken,
4737             amount,
4738             distribution,
4739             flags
4740         );
4741     }
4742 }
4743 
4744 // File: contracts/interface/IFulcrum.sol
4745 
4746 pragma solidity ^0.5.0;
4747 
4748 
4749 
4750 contract IFulcrumToken is IERC20 {
4751     function tokenPrice() external view returns (uint256);
4752 
4753     function loanTokenAddress() external view returns (address);
4754 
4755     function mintWithEther(address receiver) external payable returns (uint256 mintAmount);
4756 
4757     function mint(address receiver, uint256 depositAmount) external returns (uint256 mintAmount);
4758 
4759     function burnToEther(address receiver, uint256 burnAmount)
4760         external
4761         returns (uint256 loanAmountPaid);
4762 
4763     function burn(address receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);
4764 }
4765 
4766 // File: contracts/OneSplitFulcrum.sol
4767 
4768 pragma solidity ^0.5.0;
4769 
4770 
4771 
4772 
4773 contract OneSplitFulcrumBase {
4774     using UniversalERC20 for IERC20;
4775 
4776     function _isFulcrumToken(IERC20 token) internal view returns(IERC20) {
4777         if (token.isETH()) {
4778             return IERC20(-1);
4779         }
4780 
4781         (bool success, bytes memory data) = address(token).staticcall.gas(5000)(abi.encodeWithSignature(
4782             "name()"
4783         ));
4784         if (!success) {
4785             return IERC20(-1);
4786         }
4787 
4788         bool foundBZX = false;
4789         for (uint i = 0; i + 6 < data.length; i++) {
4790             if (data[i + 0] == "F" &&
4791                 data[i + 1] == "u" &&
4792                 data[i + 2] == "l" &&
4793                 data[i + 3] == "c" &&
4794                 data[i + 4] == "r" &&
4795                 data[i + 5] == "u" &&
4796                 data[i + 6] == "m")
4797             {
4798                 foundBZX = true;
4799                 break;
4800             }
4801         }
4802         if (!foundBZX) {
4803             return IERC20(-1);
4804         }
4805 
4806         (success, data) = address(token).staticcall.gas(5000)(abi.encodeWithSelector(
4807             IFulcrumToken(address(token)).loanTokenAddress.selector
4808         ));
4809         if (!success) {
4810             return IERC20(-1);
4811         }
4812 
4813         return abi.decode(data, (IERC20));
4814     }
4815 }
4816 
4817 
4818 contract OneSplitFulcrumView is OneSplitViewWrapBase, OneSplitFulcrumBase {
4819     function getExpectedReturnWithGas(
4820         IERC20 fromToken,
4821         IERC20 destToken,
4822         uint256 amount,
4823         uint256 parts,
4824         uint256 flags,
4825         uint256 destTokenEthPriceTimesGasPrice
4826     )
4827         public
4828         view
4829         returns(
4830             uint256 returnAmount,
4831             uint256 estimateGasAmount,
4832             uint256[] memory distribution
4833         )
4834     {
4835         return _fulcrumGetExpectedReturn(
4836             fromToken,
4837             destToken,
4838             amount,
4839             parts,
4840             flags,
4841             destTokenEthPriceTimesGasPrice
4842         );
4843     }
4844 
4845     function _fulcrumGetExpectedReturn(
4846         IERC20 fromToken,
4847         IERC20 destToken,
4848         uint256 amount,
4849         uint256 parts,
4850         uint256 flags,
4851         uint256 destTokenEthPriceTimesGasPrice
4852     )
4853         private
4854         view
4855         returns(
4856             uint256 returnAmount,
4857             uint256 estimateGasAmount,
4858             uint256[] memory distribution
4859         )
4860     {
4861         if (fromToken == destToken) {
4862             return (amount, 0, new uint256[](DEXES_COUNT));
4863         }
4864 
4865         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_FULCRUM)) {
4866             IERC20 underlying = _isFulcrumToken(fromToken);
4867             if (underlying != IERC20(-1)) {
4868                 uint256 fulcrumRate = IFulcrumToken(address(fromToken)).tokenPrice();
4869                 (returnAmount, estimateGasAmount, distribution) = _fulcrumGetExpectedReturn(
4870                     underlying,
4871                     destToken,
4872                     amount.mul(fulcrumRate).div(1e18),
4873                     parts,
4874                     flags,
4875                     destTokenEthPriceTimesGasPrice
4876                 );
4877                 return (returnAmount, estimateGasAmount + 381_000, distribution);
4878             }
4879 
4880             underlying = _isFulcrumToken(destToken);
4881             if (underlying != IERC20(-1)) {
4882                 uint256 _destTokenEthPriceTimesGasPrice = destTokenEthPriceTimesGasPrice;
4883                 uint256 fulcrumRate = IFulcrumToken(address(destToken)).tokenPrice();
4884                 (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
4885                     fromToken,
4886                     underlying,
4887                     amount,
4888                     parts,
4889                     flags,
4890                     _destTokenEthPriceTimesGasPrice.mul(fulcrumRate).div(1e18)
4891                 );
4892                 return (returnAmount.mul(1e18).div(fulcrumRate), estimateGasAmount + 354_000, distribution);
4893             }
4894         }
4895 
4896         return super.getExpectedReturnWithGas(
4897             fromToken,
4898             destToken,
4899             amount,
4900             parts,
4901             flags,
4902             destTokenEthPriceTimesGasPrice
4903         );
4904     }
4905 }
4906 
4907 
4908 contract OneSplitFulcrum is OneSplitBaseWrap, OneSplitFulcrumBase {
4909     function _swap(
4910         IERC20 fromToken,
4911         IERC20 destToken,
4912         uint256 amount,
4913         uint256[] memory distribution,
4914         uint256 flags
4915     ) internal {
4916         _fulcrumSwap(
4917             fromToken,
4918             destToken,
4919             amount,
4920             distribution,
4921             flags
4922         );
4923     }
4924 
4925     function _fulcrumSwap(
4926         IERC20 fromToken,
4927         IERC20 destToken,
4928         uint256 amount,
4929         uint256[] memory distribution,
4930         uint256 flags
4931     ) private {
4932         if (fromToken == destToken) {
4933             return;
4934         }
4935 
4936         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_FULCRUM)) {
4937             IERC20 underlying = _isFulcrumToken(fromToken);
4938             if (underlying != IERC20(-1)) {
4939                 if (underlying.isETH()) {
4940                     IFulcrumToken(address(fromToken)).burnToEther(address(this), amount);
4941                 } else {
4942                     IFulcrumToken(address(fromToken)).burn(address(this), amount);
4943                 }
4944 
4945                 uint256 underlyingAmount = underlying.universalBalanceOf(address(this));
4946 
4947                 return super._swap(
4948                     underlying,
4949                     destToken,
4950                     underlyingAmount,
4951                     distribution,
4952                     flags
4953                 );
4954             }
4955 
4956             underlying = _isFulcrumToken(destToken);
4957             if (underlying != IERC20(-1)) {
4958                 super._swap(
4959                     fromToken,
4960                     underlying,
4961                     amount,
4962                     distribution,
4963                     flags
4964                 );
4965 
4966                 uint256 underlyingAmount = underlying.universalBalanceOf(address(this));
4967 
4968                 if (underlying.isETH()) {
4969                     IFulcrumToken(address(destToken)).mintWithEther.value(underlyingAmount)(address(this));
4970                 } else {
4971                     underlying.universalApprove(address(destToken), underlyingAmount);
4972                     IFulcrumToken(address(destToken)).mint(address(this), underlyingAmount);
4973                 }
4974                 return;
4975             }
4976         }
4977 
4978         return super._swap(
4979             fromToken,
4980             destToken,
4981             amount,
4982             distribution,
4983             flags
4984         );
4985     }
4986 }
4987 
4988 // File: contracts/OneSplitChai.sol
4989 
4990 pragma solidity ^0.5.0;
4991 
4992 
4993 
4994 
4995 contract OneSplitChaiView is OneSplitViewWrapBase {
4996     function getExpectedReturnWithGas(
4997         IERC20 fromToken,
4998         IERC20 destToken,
4999         uint256 amount,
5000         uint256 parts,
5001         uint256 flags,
5002         uint256 destTokenEthPriceTimesGasPrice
5003     )
5004         public
5005         view
5006         returns(
5007             uint256 returnAmount,
5008             uint256 estimateGasAmount,
5009             uint256[] memory distribution
5010         )
5011     {
5012         if (fromToken == destToken) {
5013             return (amount, 0, new uint256[](DEXES_COUNT));
5014         }
5015 
5016         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_CHAI)) {
5017             if (fromToken == IERC20(chai)) {
5018                 (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
5019                     dai,
5020                     destToken,
5021                     chai.chaiToDai(amount),
5022                     parts,
5023                     flags,
5024                     destTokenEthPriceTimesGasPrice
5025                 );
5026                 return (returnAmount, estimateGasAmount + 197_000, distribution);
5027             }
5028 
5029             if (destToken == IERC20(chai)) {
5030                 uint256 price = chai.chaiPrice();
5031                 (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
5032                     fromToken,
5033                     dai,
5034                     amount,
5035                     parts,
5036                     flags,
5037                     destTokenEthPriceTimesGasPrice.mul(1e18).div(price)
5038                 );
5039                 return (returnAmount.mul(price).div(1e18), estimateGasAmount + 168_000, distribution);
5040             }
5041         }
5042 
5043         return super.getExpectedReturnWithGas(
5044             fromToken,
5045             destToken,
5046             amount,
5047             parts,
5048             flags,
5049             destTokenEthPriceTimesGasPrice
5050         );
5051     }
5052 }
5053 
5054 
5055 contract OneSplitChai is OneSplitBaseWrap {
5056     function _swap(
5057         IERC20 fromToken,
5058         IERC20 destToken,
5059         uint256 amount,
5060         uint256[] memory distribution,
5061         uint256 flags
5062     ) internal {
5063         if (fromToken == destToken) {
5064             return;
5065         }
5066 
5067         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_CHAI)) {
5068             if (fromToken == IERC20(chai)) {
5069                 chai.exit(address(this), amount);
5070 
5071                 return super._swap(
5072                     dai,
5073                     destToken,
5074                     dai.balanceOf(address(this)),
5075                     distribution,
5076                     flags
5077                 );
5078             }
5079 
5080             if (destToken == IERC20(chai)) {
5081                 super._swap(
5082                     fromToken,
5083                     dai,
5084                     amount,
5085                     distribution,
5086                     flags
5087                 );
5088 
5089                 uint256 daiBalance = dai.balanceOf(address(this));
5090                 dai.universalApprove(address(chai), daiBalance);
5091                 chai.join(address(this), daiBalance);
5092                 return;
5093             }
5094         }
5095 
5096         return super._swap(
5097             fromToken,
5098             destToken,
5099             amount,
5100             distribution,
5101             flags
5102         );
5103     }
5104 }
5105 
5106 // File: contracts/interface/IBdai.sol
5107 
5108 pragma solidity ^0.5.0;
5109 
5110 
5111 
5112 contract IBdai is IERC20 {
5113     function join(uint256) external;
5114 
5115     function exit(uint256) external;
5116 }
5117 
5118 // File: contracts/OneSplitBdai.sol
5119 
5120 pragma solidity ^0.5.0;
5121 
5122 
5123 
5124 
5125 contract OneSplitBdaiBase {
5126     IBdai internal constant bdai = IBdai(0x6a4FFAafa8DD400676Df8076AD6c724867b0e2e8);
5127     IERC20 internal constant btu = IERC20(0xb683D83a532e2Cb7DFa5275eED3698436371cc9f);
5128 }
5129 
5130 
5131 contract OneSplitBdaiView is OneSplitViewWrapBase, OneSplitBdaiBase {
5132     function getExpectedReturnWithGas(
5133         IERC20 fromToken,
5134         IERC20 destToken,
5135         uint256 amount,
5136         uint256 parts,
5137         uint256 flags,
5138         uint256 destTokenEthPriceTimesGasPrice
5139     )
5140         public
5141         view
5142         returns(
5143             uint256 returnAmount,
5144             uint256 estimateGasAmount,
5145             uint256[] memory distribution
5146         )
5147     {
5148         if (fromToken == destToken) {
5149             return (amount, 0, new uint256[](DEXES_COUNT));
5150         }
5151 
5152         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_BDAI)) {
5153             if (fromToken == IERC20(bdai)) {
5154                 (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
5155                     dai,
5156                     destToken,
5157                     amount,
5158                     parts,
5159                     flags,
5160                     destTokenEthPriceTimesGasPrice
5161                 );
5162                 return (returnAmount, estimateGasAmount + 227_000, distribution);
5163             }
5164 
5165             if (destToken == IERC20(bdai)) {
5166                 (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
5167                     fromToken,
5168                     dai,
5169                     amount,
5170                     parts,
5171                     flags,
5172                     destTokenEthPriceTimesGasPrice
5173                 );
5174                 return (returnAmount, estimateGasAmount + 295_000, distribution);
5175             }
5176         }
5177 
5178         return super.getExpectedReturnWithGas(
5179             fromToken,
5180             destToken,
5181             amount,
5182             parts,
5183             flags,
5184             destTokenEthPriceTimesGasPrice
5185         );
5186     }
5187 }
5188 
5189 
5190 contract OneSplitBdai is OneSplitBaseWrap, OneSplitBdaiBase {
5191     function _swap(
5192         IERC20 fromToken,
5193         IERC20 destToken,
5194         uint256 amount,
5195         uint256[] memory distribution,
5196         uint256 flags
5197     ) internal {
5198         if (fromToken == destToken) {
5199             return;
5200         }
5201 
5202         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_BDAI)) {
5203             if (fromToken == IERC20(bdai)) {
5204                 bdai.exit(amount);
5205 
5206                 uint256 btuBalance = btu.balanceOf(address(this));
5207                 if (btuBalance > 0) {
5208                     (,uint256[] memory btuDistribution) = getExpectedReturn(
5209                         btu,
5210                         destToken,
5211                         btuBalance,
5212                         1,
5213                         flags
5214                     );
5215 
5216                     _swap(
5217                         btu,
5218                         destToken,
5219                         btuBalance,
5220                         btuDistribution,
5221                         flags
5222                     );
5223                 }
5224 
5225                 return super._swap(
5226                     dai,
5227                     destToken,
5228                     amount,
5229                     distribution,
5230                     flags
5231                 );
5232             }
5233 
5234             if (destToken == IERC20(bdai)) {
5235                 super._swap(fromToken, dai, amount, distribution, flags);
5236 
5237                 uint256 daiBalance = dai.balanceOf(address(this));
5238                 dai.universalApprove(address(bdai), daiBalance);
5239                 bdai.join(daiBalance);
5240                 return;
5241             }
5242         }
5243 
5244         return super._swap(fromToken, destToken, amount, distribution, flags);
5245     }
5246 }
5247 
5248 // File: contracts/interface/IIearn.sol
5249 
5250 pragma solidity ^0.5.0;
5251 
5252 
5253 
5254 contract IIearn is IERC20 {
5255     function token() external view returns(IERC20);
5256 
5257     function calcPoolValueInToken() external view returns(uint256);
5258 
5259     function deposit(uint256 _amount) external;
5260 
5261     function withdraw(uint256 _shares) external;
5262 }
5263 
5264 // File: contracts/OneSplitIearn.sol
5265 
5266 pragma solidity ^0.5.0;
5267 
5268 
5269 
5270 
5271 contract OneSplitIearnBase {
5272     function _yTokens() internal pure returns(IIearn[13] memory) {
5273         return [
5274             IIearn(0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01),
5275             IIearn(0x04Aa51bbcB46541455cCF1B8bef2ebc5d3787EC9),
5276             IIearn(0x73a052500105205d34Daf004eAb301916DA8190f),
5277             IIearn(0x83f798e925BcD4017Eb265844FDDAbb448f1707D),
5278             IIearn(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e),
5279             IIearn(0xF61718057901F84C4eEC4339EF8f0D86D2B45600),
5280             IIearn(0x04bC0Ab673d88aE9dbC9DA2380cB6B79C4BCa9aE),
5281             IIearn(0xC2cB1040220768554cf699b0d863A3cd4324ce32),
5282             IIearn(0xE6354ed5bC4b393a5Aad09f21c46E101e692d447),
5283             IIearn(0x26EA744E5B887E5205727f55dFBE8685e3b21951),
5284             IIearn(0x99d1Fa417f94dcD62BfE781a1213c092a47041Bc),
5285             IIearn(0x9777d7E2b60bB01759D0E2f8be2095df444cb07E),
5286             IIearn(0x1bE5d71F2dA660BFdee8012dDc58D024448A0A59)
5287         ];
5288     }
5289 }
5290 
5291 
5292 contract OneSplitIearnView is OneSplitViewWrapBase, OneSplitIearnBase {
5293     function getExpectedReturnWithGas(
5294         IERC20 fromToken,
5295         IERC20 destToken,
5296         uint256 amount,
5297         uint256 parts,
5298         uint256 flags,
5299         uint256 destTokenEthPriceTimesGasPrice
5300     )
5301         public
5302         view
5303         returns(
5304             uint256 returnAmount,
5305             uint256 estimateGasAmount,
5306             uint256[] memory distribution
5307         )
5308     {
5309         return _iearnGetExpectedReturn(
5310             fromToken,
5311             destToken,
5312             amount,
5313             parts,
5314             flags,
5315             destTokenEthPriceTimesGasPrice
5316         );
5317     }
5318 
5319     function _iearnGetExpectedReturn(
5320         IERC20 fromToken,
5321         IERC20 destToken,
5322         uint256 amount,
5323         uint256 parts,
5324         uint256 flags,
5325         uint256 destTokenEthPriceTimesGasPrice
5326     )
5327         private
5328         view
5329         returns(
5330             uint256 returnAmount,
5331             uint256 estimateGasAmount,
5332             uint256[] memory distribution
5333         )
5334     {
5335         if (fromToken == destToken) {
5336             return (amount, 0, new uint256[](DEXES_COUNT));
5337         }
5338 
5339         if (!flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == !flags.check(FLAG_DISABLE_IEARN)) {
5340             IIearn[13] memory yTokens = _yTokens();
5341 
5342             for (uint i = 0; i < yTokens.length; i++) {
5343                 if (fromToken == IERC20(yTokens[i])) {
5344                     (returnAmount, estimateGasAmount, distribution) = _iearnGetExpectedReturn(
5345                         yTokens[i].token(),
5346                         destToken,
5347                         amount
5348                             .mul(yTokens[i].calcPoolValueInToken())
5349                             .div(yTokens[i].totalSupply()),
5350                         parts,
5351                         flags,
5352                         destTokenEthPriceTimesGasPrice
5353                     );
5354                     return (returnAmount, estimateGasAmount + 260_000, distribution);
5355                 }
5356             }
5357 
5358             for (uint i = 0; i < yTokens.length; i++) {
5359                 if (destToken == IERC20(yTokens[i])) {
5360                     uint256 _destTokenEthPriceTimesGasPrice = destTokenEthPriceTimesGasPrice;
5361                     IERC20 token = yTokens[i].token();
5362                     (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
5363                         fromToken,
5364                         token,
5365                         amount,
5366                         parts,
5367                         flags,
5368                         _destTokenEthPriceTimesGasPrice
5369                             .mul(yTokens[i].calcPoolValueInToken())
5370                             .div(yTokens[i].totalSupply())
5371                     );
5372 
5373                     return(
5374                         returnAmount
5375                             .mul(yTokens[i].totalSupply())
5376                             .div(yTokens[i].calcPoolValueInToken()),
5377                         estimateGasAmount + 743_000,
5378                         distribution
5379                     );
5380                 }
5381             }
5382         }
5383 
5384         return super.getExpectedReturnWithGas(
5385             fromToken,
5386             destToken,
5387             amount,
5388             parts,
5389             flags,
5390             destTokenEthPriceTimesGasPrice
5391         );
5392     }
5393 }
5394 
5395 
5396 contract OneSplitIearn is OneSplitBaseWrap, OneSplitIearnBase {
5397     function _swap(
5398         IERC20 fromToken,
5399         IERC20 destToken,
5400         uint256 amount,
5401         uint256[] memory distribution,
5402         uint256 flags
5403     ) internal {
5404         _iearnSwap(
5405             fromToken,
5406             destToken,
5407             amount,
5408             distribution,
5409             flags
5410         );
5411     }
5412 
5413     function _iearnSwap(
5414         IERC20 fromToken,
5415         IERC20 destToken,
5416         uint256 amount,
5417         uint256[] memory distribution,
5418         uint256 flags
5419     ) private {
5420         if (fromToken == destToken) {
5421             return;
5422         }
5423 
5424         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_IEARN)) {
5425             IIearn[13] memory yTokens = _yTokens();
5426 
5427             for (uint i = 0; i < yTokens.length; i++) {
5428                 if (fromToken == IERC20(yTokens[i])) {
5429                     IERC20 underlying = yTokens[i].token();
5430                     yTokens[i].withdraw(amount);
5431                     _iearnSwap(underlying, destToken, underlying.balanceOf(address(this)), distribution, flags);
5432                     return;
5433                 }
5434             }
5435 
5436             for (uint i = 0; i < yTokens.length; i++) {
5437                 if (destToken == IERC20(yTokens[i])) {
5438                     IERC20 underlying = yTokens[i].token();
5439                     super._swap(fromToken, underlying, amount, distribution, flags);
5440 
5441                     uint256 underlyingBalance = underlying.balanceOf(address(this));
5442                     underlying.universalApprove(address(yTokens[i]), underlyingBalance);
5443                     yTokens[i].deposit(underlyingBalance);
5444                     return;
5445                 }
5446             }
5447         }
5448 
5449         return super._swap(fromToken, destToken, amount, distribution, flags);
5450     }
5451 }
5452 
5453 // File: contracts/interface/IIdle.sol
5454 
5455 pragma solidity ^0.5.0;
5456 
5457 
5458 
5459 contract IIdle is IERC20 {
5460     function token()
5461         external view returns (IERC20);
5462 
5463     function tokenPrice()
5464         external view returns (uint256);
5465 
5466     function mintIdleToken(uint256 _amount, uint256[] calldata _clientProtocolAmounts)
5467         external returns (uint256 mintedTokens);
5468 
5469     function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata _clientProtocolAmounts)
5470         external returns (uint256 redeemedTokens);
5471 }
5472 
5473 // File: contracts/OneSplitIdle.sol
5474 
5475 pragma solidity ^0.5.0;
5476 
5477 
5478 
5479 
5480 contract OneSplitIdleBase {
5481     function _idleTokens() internal pure returns(IIdle[8] memory) {
5482         // https://developers.idle.finance/contracts-and-codebase
5483         return [
5484             // V3
5485             IIdle(0x78751B12Da02728F467A44eAc40F5cbc16Bd7934),
5486             IIdle(0x12B98C621E8754Ae70d0fDbBC73D6208bC3e3cA6),
5487             IIdle(0x63D27B3DA94A9E871222CB0A32232674B02D2f2D),
5488             IIdle(0x1846bdfDB6A0f5c473dEc610144513bd071999fB),
5489             IIdle(0xcDdB1Bceb7a1979C6caa0229820707429dd3Ec6C),
5490             IIdle(0x42740698959761BAF1B06baa51EfBD88CB1D862B),
5491             // V2
5492             IIdle(0x10eC0D497824e342bCB0EDcE00959142aAa766dD),
5493             IIdle(0xeB66ACc3d011056B00ea521F8203580C2E5d3991)
5494         ];
5495     }
5496 }
5497 
5498 
5499 contract OneSplitIdleView is OneSplitViewWrapBase, OneSplitIdleBase {
5500     function getExpectedReturnWithGas(
5501         IERC20 fromToken,
5502         IERC20 destToken,
5503         uint256 amount,
5504         uint256 parts,
5505         uint256 flags,
5506         uint256 destTokenEthPriceTimesGasPrice
5507     )
5508         public
5509         view
5510         returns(
5511             uint256 returnAmount,
5512             uint256 estimateGasAmount,
5513             uint256[] memory distribution
5514         )
5515     {
5516         return _idleGetExpectedReturn(
5517             fromToken,
5518             destToken,
5519             amount,
5520             parts,
5521             flags,
5522             destTokenEthPriceTimesGasPrice
5523         );
5524     }
5525 
5526     function _idleGetExpectedReturn(
5527         IERC20 fromToken,
5528         IERC20 destToken,
5529         uint256 amount,
5530         uint256 parts,
5531         uint256 flags,
5532         uint256 destTokenEthPriceTimesGasPrice
5533     )
5534         internal
5535         view
5536         returns(
5537             uint256 returnAmount,
5538             uint256 estimateGasAmount,
5539             uint256[] memory distribution
5540         )
5541     {
5542         if (fromToken == destToken) {
5543             return (amount, 0, new uint256[](DEXES_COUNT));
5544         }
5545 
5546         if (!flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == !flags.check(FLAG_DISABLE_IDLE)) {
5547             IIdle[8] memory tokens = _idleTokens();
5548 
5549             for (uint i = 0; i < tokens.length; i++) {
5550                 if (fromToken == IERC20(tokens[i])) {
5551                     (returnAmount, estimateGasAmount, distribution) = _idleGetExpectedReturn(
5552                         tokens[i].token(),
5553                         destToken,
5554                         amount.mul(tokens[i].tokenPrice()).div(1e18),
5555                         parts,
5556                         flags,
5557                         destTokenEthPriceTimesGasPrice
5558                     );
5559                     return (returnAmount, estimateGasAmount + 2_400_000, distribution);
5560                 }
5561             }
5562 
5563             for (uint i = 0; i < tokens.length; i++) {
5564                 if (destToken == IERC20(tokens[i])) {
5565                     uint256 _destTokenEthPriceTimesGasPrice = destTokenEthPriceTimesGasPrice;
5566                     uint256 _price = tokens[i].tokenPrice();
5567                     IERC20 token = tokens[i].token();
5568                     (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
5569                         fromToken,
5570                         token,
5571                         amount,
5572                         parts,
5573                         flags,
5574                         _destTokenEthPriceTimesGasPrice.mul(_price).div(1e18)
5575                     );
5576                     return (returnAmount.mul(1e18).div(_price), estimateGasAmount + 1_300_000, distribution);
5577                 }
5578             }
5579         }
5580 
5581         return super.getExpectedReturnWithGas(
5582             fromToken,
5583             destToken,
5584             amount,
5585             parts,
5586             flags,
5587             destTokenEthPriceTimesGasPrice
5588         );
5589     }
5590 }
5591 
5592 
5593 contract OneSplitIdle is OneSplitBaseWrap, OneSplitIdleBase {
5594     function _swap(
5595         IERC20 fromToken,
5596         IERC20 destToken,
5597         uint256 amount,
5598         uint256[] memory distribution,
5599         uint256 flags
5600     ) internal {
5601         _idleSwap(
5602             fromToken,
5603             destToken,
5604             amount,
5605             distribution,
5606             flags
5607         );
5608     }
5609 
5610     function _idleSwap(
5611         IERC20 fromToken,
5612         IERC20 destToken,
5613         uint256 amount,
5614         uint256[] memory distribution,
5615         uint256 flags
5616     ) internal {
5617         if (!flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == !flags.check(FLAG_DISABLE_IDLE)) {
5618             IIdle[8] memory tokens = _idleTokens();
5619 
5620             for (uint i = 0; i < tokens.length; i++) {
5621                 if (fromToken == IERC20(tokens[i])) {
5622                     IERC20 underlying = tokens[i].token();
5623                     uint256 minted = tokens[i].redeemIdleToken(amount, true, new uint256[](0));
5624                     _idleSwap(underlying, destToken, minted, distribution, flags);
5625                     return;
5626                 }
5627             }
5628 
5629             for (uint i = 0; i < tokens.length; i++) {
5630                 if (destToken == IERC20(tokens[i])) {
5631                     IERC20 underlying = tokens[i].token();
5632                     super._swap(fromToken, underlying, amount, distribution, flags);
5633 
5634                     uint256 underlyingBalance = underlying.balanceOf(address(this));
5635                     underlying.universalApprove(address(tokens[i]), underlyingBalance);
5636                     tokens[i].mintIdleToken(underlyingBalance, new uint256[](0));
5637                     return;
5638                 }
5639             }
5640         }
5641 
5642         return super._swap(fromToken, destToken, amount, distribution, flags);
5643     }
5644 }
5645 
5646 // File: contracts/OneSplitAave.sol
5647 
5648 pragma solidity ^0.5.0;
5649 
5650 
5651 
5652 
5653 contract OneSplitAaveView is OneSplitViewWrapBase {
5654     function getExpectedReturnWithGas(
5655         IERC20 fromToken,
5656         IERC20 destToken,
5657         uint256 amount,
5658         uint256 parts,
5659         uint256 flags, // See constants in IOneSplit.sol
5660         uint256 destTokenEthPriceTimesGasPrice
5661     )
5662         public
5663         view
5664         returns(
5665             uint256 returnAmount,
5666             uint256 estimateGasAmount,
5667             uint256[] memory distribution
5668         )
5669     {
5670         return _aaveGetExpectedReturn(
5671             fromToken,
5672             destToken,
5673             amount,
5674             parts,
5675             flags,
5676             destTokenEthPriceTimesGasPrice
5677         );
5678     }
5679 
5680     function _aaveGetExpectedReturn(
5681         IERC20 fromToken,
5682         IERC20 destToken,
5683         uint256 amount,
5684         uint256 parts,
5685         uint256 flags,
5686         uint256 destTokenEthPriceTimesGasPrice
5687     )
5688         private
5689         view
5690         returns(
5691             uint256 returnAmount,
5692             uint256 estimateGasAmount,
5693             uint256[] memory distribution
5694         )
5695     {
5696         if (fromToken == destToken) {
5697             return (amount, 0, new uint256[](DEXES_COUNT));
5698         }
5699 
5700         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_AAVE)) {
5701             IERC20 underlying = aaveRegistry.tokenByAToken(IAaveToken(address(fromToken)));
5702             if (underlying != IERC20(0)) {
5703                 (returnAmount, estimateGasAmount, distribution) = _aaveGetExpectedReturn(
5704                     underlying,
5705                     destToken,
5706                     amount,
5707                     parts,
5708                     flags,
5709                     destTokenEthPriceTimesGasPrice
5710                 );
5711                 return (returnAmount, estimateGasAmount + 670_000, distribution);
5712             }
5713 
5714             underlying = aaveRegistry.tokenByAToken(IAaveToken(address(destToken)));
5715             if (underlying != IERC20(0)) {
5716                 (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
5717                     fromToken,
5718                     underlying,
5719                     amount,
5720                     parts,
5721                     flags,
5722                     destTokenEthPriceTimesGasPrice
5723                 );
5724                 return (returnAmount, estimateGasAmount + 310_000, distribution);
5725             }
5726         }
5727 
5728         return super.getExpectedReturnWithGas(
5729             fromToken,
5730             destToken,
5731             amount,
5732             parts,
5733             flags,
5734             destTokenEthPriceTimesGasPrice
5735         );
5736     }
5737 }
5738 
5739 
5740 contract OneSplitAave is OneSplitBaseWrap {
5741     function _swap(
5742         IERC20 fromToken,
5743         IERC20 destToken,
5744         uint256 amount,
5745         uint256[] memory distribution,
5746         uint256 flags
5747     ) internal {
5748         _aaveSwap(
5749             fromToken,
5750             destToken,
5751             amount,
5752             distribution,
5753             flags
5754         );
5755     }
5756 
5757     function _aaveSwap(
5758         IERC20 fromToken,
5759         IERC20 destToken,
5760         uint256 amount,
5761         uint256[] memory distribution,
5762         uint256 flags
5763     ) private {
5764         if (fromToken == destToken) {
5765             return;
5766         }
5767 
5768         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_AAVE)) {
5769             IERC20 underlying = aaveRegistry.tokenByAToken(IAaveToken(address(fromToken)));
5770             if (underlying != IERC20(0)) {
5771                 IAaveToken(address(fromToken)).redeem(amount);
5772 
5773                 return _aaveSwap(
5774                     underlying,
5775                     destToken,
5776                     amount,
5777                     distribution,
5778                     flags
5779                 );
5780             }
5781 
5782             underlying = aaveRegistry.tokenByAToken(IAaveToken(address(destToken)));
5783             if (underlying != IERC20(0)) {
5784                 super._swap(
5785                     fromToken,
5786                     underlying,
5787                     amount,
5788                     distribution,
5789                     flags
5790                 );
5791 
5792                 uint256 underlyingAmount = underlying.universalBalanceOf(address(this));
5793 
5794                 underlying.universalApprove(aave.core(), underlyingAmount);
5795                 aave.deposit.value(underlying.isETH() ? underlyingAmount : 0)(
5796                     underlying.isETH() ? ETH_ADDRESS : underlying,
5797                     underlyingAmount,
5798                     1101
5799                 );
5800                 return;
5801             }
5802         }
5803 
5804         return super._swap(
5805             fromToken,
5806             destToken,
5807             amount,
5808             distribution,
5809             flags
5810         );
5811     }
5812 }
5813 
5814 // File: contracts/OneSplitWeth.sol
5815 
5816 pragma solidity ^0.5.0;
5817 
5818 
5819 
5820 
5821 contract OneSplitWethView is OneSplitViewWrapBase {
5822     function getExpectedReturnWithGas(
5823         IERC20 fromToken,
5824         IERC20 destToken,
5825         uint256 amount,
5826         uint256 parts,
5827         uint256 flags,
5828         uint256 destTokenEthPriceTimesGasPrice
5829     )
5830         public
5831         view
5832         returns(
5833             uint256 returnAmount,
5834             uint256 estimateGasAmount,
5835             uint256[] memory distribution
5836         )
5837     {
5838         return _wethGetExpectedReturn(
5839             fromToken,
5840             destToken,
5841             amount,
5842             parts,
5843             flags,
5844             destTokenEthPriceTimesGasPrice
5845         );
5846     }
5847 
5848     function _wethGetExpectedReturn(
5849         IERC20 fromToken,
5850         IERC20 destToken,
5851         uint256 amount,
5852         uint256 parts,
5853         uint256 flags,
5854         uint256 destTokenEthPriceTimesGasPrice
5855     )
5856         private
5857         view
5858         returns(
5859             uint256 returnAmount,
5860             uint256 estimateGasAmount,
5861             uint256[] memory distribution
5862         )
5863     {
5864         if (fromToken == destToken) {
5865             return (amount, 0, new uint256[](DEXES_COUNT));
5866         }
5867 
5868         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_WETH)) {
5869             if (fromToken == weth || fromToken == bancorEtherToken) {
5870                 return super.getExpectedReturnWithGas(ETH_ADDRESS, destToken, amount, parts, flags, destTokenEthPriceTimesGasPrice);
5871             }
5872 
5873             if (destToken == weth || destToken == bancorEtherToken) {
5874                 return super.getExpectedReturnWithGas(fromToken, ETH_ADDRESS, amount, parts, flags, destTokenEthPriceTimesGasPrice);
5875             }
5876         }
5877 
5878         return super.getExpectedReturnWithGas(
5879             fromToken,
5880             destToken,
5881             amount,
5882             parts,
5883             flags,
5884             destTokenEthPriceTimesGasPrice
5885         );
5886     }
5887 }
5888 
5889 
5890 contract OneSplitWeth is OneSplitBaseWrap {
5891     function _swap(
5892         IERC20 fromToken,
5893         IERC20 destToken,
5894         uint256 amount,
5895         uint256[] memory distribution,
5896         uint256 flags
5897     ) internal {
5898         _wethSwap(
5899             fromToken,
5900             destToken,
5901             amount,
5902             distribution,
5903             flags
5904         );
5905     }
5906 
5907     function _wethSwap(
5908         IERC20 fromToken,
5909         IERC20 destToken,
5910         uint256 amount,
5911         uint256[] memory distribution,
5912         uint256 flags
5913     ) private {
5914         if (fromToken == destToken) {
5915             return;
5916         }
5917 
5918         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_WETH)) {
5919             if (fromToken == weth) {
5920                 weth.withdraw(weth.balanceOf(address(this)));
5921                 super._swap(
5922                     ETH_ADDRESS,
5923                     destToken,
5924                     amount,
5925                     distribution,
5926                     flags
5927                 );
5928                 return;
5929             }
5930 
5931             if (fromToken == bancorEtherToken) {
5932                 bancorEtherToken.withdraw(bancorEtherToken.balanceOf(address(this)));
5933                 super._swap(
5934                     ETH_ADDRESS,
5935                     destToken,
5936                     amount,
5937                     distribution,
5938                     flags
5939                 );
5940                 return;
5941             }
5942 
5943             if (destToken == weth) {
5944                 _wethSwap(
5945                     fromToken,
5946                     ETH_ADDRESS,
5947                     amount,
5948                     distribution,
5949                     flags
5950                 );
5951                 weth.deposit.value(address(this).balance)();
5952                 return;
5953             }
5954 
5955             if (destToken == bancorEtherToken) {
5956                 _wethSwap(
5957                     fromToken,
5958                     ETH_ADDRESS,
5959                     amount,
5960                     distribution,
5961                     flags
5962                 );
5963                 bancorEtherToken.deposit.value(address(this).balance)();
5964                 return;
5965             }
5966         }
5967 
5968         return super._swap(
5969             fromToken,
5970             destToken,
5971             amount,
5972             distribution,
5973             flags
5974         );
5975     }
5976 }
5977 
5978 // File: contracts/OneSplitMStable.sol
5979 
5980 pragma solidity ^0.5.0;
5981 
5982 
5983 
5984 
5985 contract OneSplitMStableView is OneSplitViewWrapBase {
5986     function getExpectedReturnWithGas(
5987         IERC20 fromToken,
5988         IERC20 destToken,
5989         uint256 amount,
5990         uint256 parts,
5991         uint256 flags,
5992         uint256 destTokenEthPriceTimesGasPrice
5993     )
5994         public
5995         view
5996         returns(
5997             uint256 returnAmount,
5998             uint256 estimateGasAmount,
5999             uint256[] memory distribution
6000         )
6001     {
6002         if (fromToken == destToken) {
6003             return (amount, 0, new uint256[](DEXES_COUNT));
6004         }
6005 
6006         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_MSTABLE_MUSD)) {
6007             if (fromToken == IERC20(musd)) {
6008                 {
6009                     (bool valid1,, uint256 res1,) = musd_helper.getRedeemValidity(musd, amount, destToken);
6010                     if (valid1) {
6011                         return (res1, 300_000, new uint256[](DEXES_COUNT));
6012                     }
6013                 }
6014 
6015                 (bool valid,, address token) = musd_helper.suggestRedeemAsset(musd);
6016                 if (valid) {
6017                     (,, returnAmount,) = musd_helper.getRedeemValidity(musd, amount, IERC20(token));
6018                     if (IERC20(token) != destToken) {
6019                         (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
6020                             IERC20(token),
6021                             destToken,
6022                             returnAmount,
6023                             parts,
6024                             flags,
6025                             destTokenEthPriceTimesGasPrice
6026                         );
6027                     } else {
6028                         distribution = new uint256[](DEXES_COUNT);
6029                     }
6030 
6031                     return (returnAmount, estimateGasAmount + 300_000, distribution);
6032                 }
6033             }
6034 
6035             if (destToken == IERC20(musd)) {
6036                 if (fromToken == usdc || fromToken == dai || fromToken == usdt || fromToken == tusd) {
6037                     (,, returnAmount) = musd.getSwapOutput(fromToken, destToken, amount);
6038                     return (returnAmount, 300_000, new uint256[](DEXES_COUNT));
6039                 }
6040                 else {
6041                     IERC20 _destToken = destToken;
6042                     (bool valid,, address token) = musd_helper.suggestMintAsset(_destToken);
6043                     if (valid) {
6044                         if (IERC20(token) != fromToken) {
6045                             (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
6046                                 fromToken,
6047                                 IERC20(token),
6048                                 amount,
6049                                 parts,
6050                                 flags,
6051                                 _scaleDestTokenEthPriceTimesGasPrice(
6052                                     _destToken,
6053                                     IERC20(token),
6054                                     destTokenEthPriceTimesGasPrice
6055                                 )
6056                             );
6057                         } else {
6058                             returnAmount = amount;
6059                         }
6060                         (,, returnAmount) = musd.getSwapOutput(IERC20(token), _destToken, returnAmount);
6061                         return (returnAmount, estimateGasAmount + 300_000, distribution);
6062                     }
6063                 }
6064             }
6065         }
6066 
6067         return super.getExpectedReturnWithGas(
6068             fromToken,
6069             destToken,
6070             amount,
6071             parts,
6072             flags,
6073             destTokenEthPriceTimesGasPrice
6074         );
6075     }
6076 }
6077 
6078 
6079 contract OneSplitMStable is OneSplitBaseWrap {
6080     function _swap(
6081         IERC20 fromToken,
6082         IERC20 destToken,
6083         uint256 amount,
6084         uint256[] memory distribution,
6085         uint256 flags
6086     ) internal {
6087         if (fromToken == destToken) {
6088             return;
6089         }
6090 
6091         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_MSTABLE_MUSD)) {
6092             if (fromToken == IERC20(musd)) {
6093                 if (destToken == usdc || destToken == dai || destToken == usdt || destToken == tusd) {
6094                     (,,, uint256 result) = musd_helper.getRedeemValidity(fromToken, amount, destToken);
6095                     musd.redeem(
6096                         destToken,
6097                         result
6098                     );
6099                 }
6100                 else {
6101                     (,,, uint256 result) = musd_helper.getRedeemValidity(fromToken, amount, dai);
6102                     musd.redeem(
6103                         dai,
6104                         result
6105                     );
6106                     super._swap(
6107                         dai,
6108                         destToken,
6109                         dai.balanceOf(address(this)),
6110                         distribution,
6111                         flags
6112                     );
6113                 }
6114                 return;
6115             }
6116 
6117             if (destToken == IERC20(musd)) {
6118                 if (fromToken == usdc || fromToken == dai || fromToken == usdt || fromToken == tusd) {
6119                     fromToken.universalApprove(address(musd), amount);
6120                     musd.swap(
6121                         fromToken,
6122                         destToken,
6123                         amount,
6124                         address(this)
6125                     );
6126                 }
6127                 else {
6128                     super._swap(
6129                         fromToken,
6130                         dai,
6131                         amount,
6132                         distribution,
6133                         flags
6134                     );
6135                     musd.swap(
6136                         dai,
6137                         destToken,
6138                         dai.balanceOf(address(this)),
6139                         address(this)
6140                     );
6141                 }
6142                 return;
6143             }
6144         }
6145 
6146         return super._swap(
6147             fromToken,
6148             destToken,
6149             amount,
6150             distribution,
6151             flags
6152         );
6153     }
6154 }
6155 
6156 // File: contracts/interface/IDMM.sol
6157 
6158 pragma solidity ^0.5.0;
6159 
6160 
6161 
6162 interface IDMMController {
6163     function getUnderlyingTokenForDmm(IERC20 token) external view returns(IERC20);
6164 }
6165 
6166 
6167 contract IDMM is IERC20 {
6168     function getCurrentExchangeRate() public view returns(uint256);
6169     function mint(uint256 underlyingAmount) public returns(uint256);
6170     function redeem(uint256 amount) public returns(uint256);
6171 }
6172 
6173 // File: contracts/OneSplitDMM.sol
6174 
6175 pragma solidity ^0.5.0;
6176 
6177 
6178 
6179 
6180 contract OneSplitDMMBase {
6181     IDMMController internal constant _dmmController = IDMMController(0x4CB120Dd1D33C9A3De8Bc15620C7Cd43418d77E2);
6182 
6183     function _getDMMUnderlyingToken(IERC20 token) internal view returns(IERC20) {
6184         (bool success, bytes memory data) = address(_dmmController).staticcall(
6185             abi.encodeWithSelector(
6186                 _dmmController.getUnderlyingTokenForDmm.selector,
6187                 token
6188             )
6189         );
6190 
6191         if (!success || data.length == 0) {
6192             return IERC20(-1);
6193         }
6194 
6195         return abi.decode(data, (IERC20));
6196     }
6197 
6198     function _getDMMExchangeRate(IDMM dmm) internal view returns(uint256) {
6199         (bool success, bytes memory data) = address(dmm).staticcall(
6200             abi.encodeWithSelector(
6201                 dmm.getCurrentExchangeRate.selector
6202             )
6203         );
6204 
6205         if (!success || data.length == 0) {
6206             return 0;
6207         }
6208 
6209         return abi.decode(data, (uint256));
6210     }
6211 }
6212 
6213 
6214 contract OneSplitDMMView is OneSplitViewWrapBase, OneSplitDMMBase {
6215     function getExpectedReturnWithGas(
6216         IERC20 fromToken,
6217         IERC20 destToken,
6218         uint256 amount,
6219         uint256 parts,
6220         uint256 flags,
6221         uint256 destTokenEthPriceTimesGasPrice
6222     )
6223         public
6224         view
6225         returns(
6226             uint256 returnAmount,
6227             uint256 estimateGasAmount,
6228             uint256[] memory distribution
6229         )
6230     {
6231         return _dmmGetExpectedReturn(
6232             fromToken,
6233             destToken,
6234             amount,
6235             parts,
6236             flags,
6237             destTokenEthPriceTimesGasPrice
6238         );
6239     }
6240 
6241     function _dmmGetExpectedReturn(
6242         IERC20 fromToken,
6243         IERC20 destToken,
6244         uint256 amount,
6245         uint256 parts,
6246         uint256 flags,
6247         uint256 destTokenEthPriceTimesGasPrice
6248     )
6249         private
6250         view
6251         returns(
6252             uint256 returnAmount,
6253             uint256 estimateGasAmount,
6254             uint256[] memory distribution
6255         )
6256     {
6257         if (fromToken == destToken) {
6258             return (amount, 0, new uint256[](DEXES_COUNT));
6259         }
6260 
6261         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_DMM)) {
6262             IERC20 underlying = _getDMMUnderlyingToken(fromToken);
6263             if (underlying != IERC20(-1)) {
6264                 if (underlying == weth) {
6265                     underlying = ETH_ADDRESS;
6266                 }
6267                 IERC20 _fromToken = fromToken;
6268                 (returnAmount, estimateGasAmount, distribution) = _dmmGetExpectedReturn(
6269                     underlying,
6270                     destToken,
6271                     amount.mul(_getDMMExchangeRate(IDMM(address(_fromToken)))).div(1e18),
6272                     parts,
6273                     flags,
6274                     destTokenEthPriceTimesGasPrice
6275                 );
6276                 return (returnAmount, estimateGasAmount + 295_000, distribution);
6277             }
6278 
6279             underlying = _getDMMUnderlyingToken(destToken);
6280             if (underlying != IERC20(-1)) {
6281                 if (underlying == weth) {
6282                     underlying = ETH_ADDRESS;
6283                 }
6284                 uint256 price = _getDMMExchangeRate(IDMM(address(destToken)));
6285                 (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
6286                     fromToken,
6287                     underlying,
6288                     amount,
6289                     parts,
6290                     flags,
6291                     destTokenEthPriceTimesGasPrice.mul(price).div(1e18)
6292                 );
6293                 return (
6294                     returnAmount.mul(1e18).div(price),
6295                     estimateGasAmount + 430_000,
6296                     distribution
6297                 );
6298             }
6299         }
6300 
6301         return super.getExpectedReturnWithGas(
6302             fromToken,
6303             destToken,
6304             amount,
6305             parts,
6306             flags,
6307             destTokenEthPriceTimesGasPrice
6308         );
6309     }
6310 }
6311 
6312 
6313 contract OneSplitDMM is OneSplitBaseWrap, OneSplitDMMBase {
6314     function _swap(
6315         IERC20 fromToken,
6316         IERC20 destToken,
6317         uint256 amount,
6318         uint256[] memory distribution,
6319         uint256 flags
6320     ) internal {
6321         _dmmSwap(
6322             fromToken,
6323             destToken,
6324             amount,
6325             distribution,
6326             flags
6327         );
6328     }
6329 
6330     function _dmmSwap(
6331         IERC20 fromToken,
6332         IERC20 destToken,
6333         uint256 amount,
6334         uint256[] memory distribution,
6335         uint256 flags
6336     ) private {
6337         if (fromToken == destToken) {
6338             return;
6339         }
6340 
6341         if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_DMM)) {
6342             IERC20 underlying = _getDMMUnderlyingToken(fromToken);
6343             if (underlying != IERC20(-1)) {
6344                 IDMM(address(fromToken)).redeem(amount);
6345                 uint256 balance = underlying.universalBalanceOf(address(this));
6346                 if (underlying == weth) {
6347                     weth.withdraw(balance);
6348                 }
6349                 _dmmSwap(
6350                     (underlying == weth) ? ETH_ADDRESS : underlying,
6351                     destToken,
6352                     balance,
6353                     distribution,
6354                     flags
6355                 );
6356             }
6357 
6358             underlying = _getDMMUnderlyingToken(destToken);
6359             if (underlying != IERC20(-1)) {
6360                 super._swap(
6361                     fromToken,
6362                     (underlying == weth) ? ETH_ADDRESS : underlying,
6363                     amount,
6364                     distribution,
6365                     flags
6366                 );
6367 
6368                 uint256 underlyingAmount = ((underlying == weth) ? ETH_ADDRESS : underlying).universalBalanceOf(address(this));
6369                 if (underlying == weth) {
6370                     weth.deposit.value(underlyingAmount);
6371                 }
6372 
6373                 underlying.universalApprove(address(destToken), underlyingAmount);
6374                 IDMM(address(destToken)).mint(underlyingAmount);
6375                 return;
6376             }
6377         }
6378 
6379         return super._swap(
6380             fromToken,
6381             destToken,
6382             amount,
6383             distribution,
6384             flags
6385         );
6386     }
6387 }
6388 
6389 // File: contracts/OneSplitMooniswapPoolToken.sol
6390 
6391 pragma solidity ^0.5.0;
6392 
6393 
6394 
6395 
6396 
6397 contract OneSplitMooniswapTokenBase {
6398     using SafeMath for uint256;
6399     using Math for uint256;
6400     using UniversalERC20 for IERC20;
6401 
6402     struct TokenInfo {
6403         IERC20 token;
6404         uint256 reserve;
6405     }
6406 
6407     struct PoolDetails {
6408         TokenInfo[2] tokens;
6409         uint256 totalSupply;
6410     }
6411 
6412     function _getPoolDetails(IMooniswap pool) internal view returns (PoolDetails memory details) {
6413         for (uint i = 0; i < 2; i++) {
6414             IERC20 token = pool.tokens(i);
6415             details.tokens[i] = TokenInfo({
6416                 token: token,
6417                 reserve: token.universalBalanceOf(address(pool))
6418             });
6419         }
6420 
6421         details.totalSupply = IERC20(address(pool)).totalSupply();
6422     }
6423 }
6424 
6425 
6426 contract OneSplitMooniswapTokenView is OneSplitViewWrapBase, OneSplitMooniswapTokenBase {
6427 
6428     function getExpectedReturnWithGas(
6429         IERC20 fromToken,
6430         IERC20 toToken,
6431         uint256 amount,
6432         uint256 parts,
6433         uint256 flags,
6434         uint256 destTokenEthPriceTimesGasPrice
6435     )
6436         public
6437         view
6438         returns (
6439             uint256 returnAmount,
6440             uint256,
6441             uint256[] memory distribution
6442         )
6443     {
6444         if (fromToken.eq(toToken)) {
6445             return (amount, 0, new uint256[](DEXES_COUNT));
6446         }
6447 
6448 
6449         if (!flags.check(FLAG_DISABLE_MOONISWAP_POOL_TOKEN)) {
6450             bool isPoolTokenFrom = mooniswapRegistry.isPool(address(fromToken));
6451             bool isPoolTokenTo = mooniswapRegistry.isPool(address(toToken));
6452 
6453             if (isPoolTokenFrom && isPoolTokenTo) {
6454                 (
6455                     uint256 returnETHAmount,
6456                     uint256[] memory poolTokenFromDistribution
6457                 ) = _getExpectedReturnFromMooniswapPoolToken(
6458                     fromToken,
6459                     ETH_ADDRESS,
6460                     amount,
6461                     parts,
6462                     FLAG_DISABLE_MOONISWAP_POOL_TOKEN
6463                 );
6464 
6465                 (
6466                     uint256 returnPoolTokenToAmount,
6467                     uint256[] memory poolTokenToDistribution
6468                 ) = _getExpectedReturnToMooniswapPoolToken(
6469                     ETH_ADDRESS,
6470                     toToken,
6471                     returnETHAmount,
6472                     parts,
6473                     FLAG_DISABLE_MOONISWAP_POOL_TOKEN
6474                 );
6475 
6476                 for (uint i = 0; i < poolTokenToDistribution.length; i++) {
6477                     poolTokenFromDistribution[i] |= poolTokenToDistribution[i] << 128;
6478                 }
6479 
6480                 return (returnPoolTokenToAmount, 0, poolTokenFromDistribution);
6481             }
6482 
6483             if (isPoolTokenFrom) {
6484                 (returnAmount, distribution) = _getExpectedReturnFromMooniswapPoolToken(
6485                     fromToken,
6486                     toToken,
6487                     amount,
6488                     parts,
6489                     FLAG_DISABLE_MOONISWAP_POOL_TOKEN
6490                 );
6491                 return (returnAmount, 0, distribution);
6492             }
6493 
6494             if (isPoolTokenTo) {
6495                 (returnAmount, distribution) = _getExpectedReturnToMooniswapPoolToken(
6496                     fromToken,
6497                     toToken,
6498                     amount,
6499                     parts,
6500                     FLAG_DISABLE_MOONISWAP_POOL_TOKEN
6501                 );
6502                 return (returnAmount, 0, distribution);
6503             }
6504         }
6505 
6506         return super.getExpectedReturnWithGas(
6507             fromToken,
6508             toToken,
6509             amount,
6510             parts,
6511             flags,
6512             destTokenEthPriceTimesGasPrice
6513         );
6514     }
6515 
6516     function _getExpectedReturnFromMooniswapPoolToken(
6517         IERC20 poolToken,
6518         IERC20 toToken,
6519         uint256 amount,
6520         uint256 parts,
6521         uint256 flags
6522     )
6523         private
6524         view
6525         returns(
6526             uint256 returnAmount,
6527             uint256[] memory distribution
6528         )
6529     {
6530         distribution = new uint256[](DEXES_COUNT);
6531 
6532         PoolDetails memory details = _getPoolDetails(IMooniswap(address(poolToken)));
6533 
6534         for (uint i = 0; i < 2; i++) {
6535 
6536             uint256 exchangeAmount = amount
6537                 .mul(details.tokens[i].reserve)
6538                 .div(details.totalSupply);
6539 
6540             if (toToken.eq(details.tokens[i].token)) {
6541                 returnAmount = returnAmount.add(exchangeAmount);
6542                 continue;
6543             }
6544 
6545             (uint256 ret, ,uint256[] memory dist) = super.getExpectedReturnWithGas(
6546                 details.tokens[i].token,
6547                 toToken,
6548                 exchangeAmount,
6549                 parts,
6550                 flags,
6551                 0
6552             );
6553 
6554             returnAmount = returnAmount.add(ret);
6555             for (uint j = 0; j < distribution.length; j++) {
6556                 distribution[j] |= dist[j] << (i * 8);
6557             }
6558         }
6559 
6560         return (returnAmount, distribution);
6561     }
6562 
6563     function _getExpectedReturnToMooniswapPoolToken(
6564         IERC20 fromToken,
6565         IERC20 poolToken,
6566         uint256 amount,
6567         uint256 parts,
6568         uint256 flags
6569     )
6570         private
6571         view
6572         returns(
6573             uint256 returnAmount,
6574             uint256[] memory distribution
6575         )
6576     {
6577         distribution = new uint256[](DEXES_COUNT);
6578 
6579         PoolDetails memory details = _getPoolDetails(IMooniswap(address(poolToken)));
6580 
6581         // will overwritten to liquidity amounts
6582         uint256[2] memory amounts;
6583         amounts[0] = amount.div(2);
6584         amounts[1] = amount.sub(amounts[0]);
6585         uint256[] memory dist = new uint256[](distribution.length);
6586         for (uint i = 0; i < 2; i++) {
6587 
6588             if (fromToken.eq(details.tokens[i].token)) {
6589                 continue;
6590             }
6591 
6592             (amounts[i], ,dist) = super.getExpectedReturnWithGas(
6593                 fromToken,
6594                 details.tokens[i].token,
6595                 amounts[i],
6596                 parts,
6597                 flags,
6598                 0
6599             );
6600 
6601             for (uint j = 0; j < distribution.length; j++) {
6602                 distribution[j] |= dist[j] << (i * 8);
6603             }
6604         }
6605 
6606         returnAmount = uint256(-1);
6607         for (uint i = 0; i < 2; i++) {
6608             returnAmount = Math.min(
6609                 returnAmount,
6610                 details.totalSupply.mul(amounts[i]).div(details.tokens[i].reserve)
6611             );
6612         }
6613 
6614         return (
6615             returnAmount,
6616             distribution
6617         );
6618     }
6619 
6620 }
6621 
6622 
6623 contract OneSplitMooniswapToken is OneSplitBaseWrap, OneSplitMooniswapTokenBase {
6624     function _swap(
6625         IERC20 fromToken,
6626         IERC20 toToken,
6627         uint256 amount,
6628         uint256[] memory distribution,
6629         uint256 flags
6630     ) internal {
6631         if (fromToken.eq(toToken)) {
6632             return;
6633         }
6634 
6635         if (!flags.check(FLAG_DISABLE_MOONISWAP_POOL_TOKEN)) {
6636             bool isPoolTokenFrom = mooniswapRegistry.isPool(address(fromToken));
6637             bool isPoolTokenTo = mooniswapRegistry.isPool(address(toToken));
6638 
6639             if (isPoolTokenFrom && isPoolTokenTo) {
6640                 uint256[] memory dist = new uint256[](distribution.length);
6641                 for (uint i = 0; i < distribution.length; i++) {
6642                     dist[i] = distribution[i] & ((1 << 128) - 1);
6643                 }
6644 
6645                 uint256 ethBalanceBefore = ETH_ADDRESS.universalBalanceOf(address(this));
6646 
6647                 _swapFromMooniswapToken(
6648                     fromToken,
6649                     ETH_ADDRESS,
6650                     amount,
6651                     dist,
6652                     FLAG_DISABLE_MOONISWAP_POOL_TOKEN
6653                 );
6654 
6655                 for (uint i = 0; i < distribution.length; i++) {
6656                     dist[i] = distribution[i] >> 128;
6657                 }
6658 
6659                 uint256 ethBalanceAfter = ETH_ADDRESS.universalBalanceOf(address(this));
6660 
6661                 return _swapToMooniswapToken(
6662                     ETH_ADDRESS,
6663                     toToken,
6664                     ethBalanceAfter.sub(ethBalanceBefore),
6665                     dist,
6666                     FLAG_DISABLE_MOONISWAP_POOL_TOKEN
6667                 );
6668             }
6669 
6670             if (isPoolTokenFrom) {
6671                 return _swapFromMooniswapToken(
6672                     fromToken,
6673                     toToken,
6674                     amount,
6675                     distribution,
6676                     FLAG_DISABLE_MOONISWAP_POOL_TOKEN
6677                 );
6678             }
6679 
6680             if (isPoolTokenTo) {
6681                 return _swapToMooniswapToken(
6682                     fromToken,
6683                     toToken,
6684                     amount,
6685                     distribution,
6686                     FLAG_DISABLE_MOONISWAP_POOL_TOKEN
6687                 );
6688             }
6689         }
6690 
6691         return super._swap(
6692             fromToken,
6693             toToken,
6694             amount,
6695             distribution,
6696             flags
6697         );
6698     }
6699 
6700     function _swapFromMooniswapToken(
6701         IERC20 poolToken,
6702         IERC20 toToken,
6703         uint256 amount,
6704         uint256[] memory distribution,
6705         uint256 flags
6706     ) private {
6707         IERC20[2] memory tokens = [
6708             IMooniswap(address(poolToken)).tokens(0),
6709             IMooniswap(address(poolToken)).tokens(1)
6710         ];
6711 
6712         IMooniswap(address(poolToken)).withdraw(
6713             amount,
6714             new uint256[](0)
6715         );
6716 
6717         uint256[] memory dist = new uint256[](distribution.length);
6718         for (uint i = 0; i < 2; i++) {
6719 
6720             if (toToken.eq(tokens[i])) {
6721                 continue;
6722             }
6723 
6724             for (uint j = 0; j < distribution.length; j++) {
6725                 dist[j] = (distribution[j] >> (i * 8)) & 0xFF;
6726             }
6727 
6728             super._swap(
6729                 tokens[i],
6730                 toToken,
6731                 tokens[i].universalBalanceOf(address(this)),
6732                 dist,
6733                 flags
6734             );
6735         }
6736     }
6737 
6738     function _swapToMooniswapToken(
6739         IERC20 fromToken,
6740         IERC20 poolToken,
6741         uint256 amount,
6742         uint256[] memory distribution,
6743         uint256 flags
6744     ) private {
6745         IERC20[2] memory tokens = [
6746             IMooniswap(address(poolToken)).tokens(0),
6747             IMooniswap(address(poolToken)).tokens(1)
6748         ];
6749 
6750         // will overwritten to liquidity amounts
6751         uint256[] memory amounts = new uint256[](2);
6752         amounts[0] = amount.div(2);
6753         amounts[1] = amount.sub(amounts[0]);
6754         uint256[] memory dist = new uint256[](distribution.length);
6755         for (uint i = 0; i < 2; i++) {
6756 
6757             if (fromToken.eq(tokens[i])) {
6758                 continue;
6759             }
6760 
6761             for (uint j = 0; j < distribution.length; j++) {
6762                 dist[j] = (distribution[j] >> (i * 8)) & 0xFF;
6763             }
6764 
6765             super._swap(
6766                 fromToken,
6767                 tokens[i],
6768                 amounts[i],
6769                 dist,
6770                 flags
6771             );
6772 
6773             amounts[i] = tokens[i].universalBalanceOf(address(this));
6774             tokens[i].universalApprove(address(poolToken), amounts[i]);
6775         }
6776 
6777         uint256 ethValue = (tokens[0].isETH() ? amounts[0] : 0) + (tokens[1].isETH() ? amounts[1] : 0);
6778         IMooniswap(address(poolToken)).deposit.value(ethValue)(
6779             amounts,
6780             new uint256[](2)
6781         );
6782 
6783         for (uint i = 0; i < 2; i++) {
6784             tokens[i].universalTransfer(
6785                 msg.sender,
6786                 tokens[i].universalBalanceOf(address(this))
6787             );
6788         }
6789     }
6790 }
6791 
6792 // File: contracts/OneSplit.sol
6793 
6794 pragma solidity ^0.5.0;
6795 
6796 
6797 
6798 
6799 
6800 
6801 
6802 
6803 
6804 
6805 
6806 
6807 
6808 
6809 
6810 contract OneSplitViewWrap is
6811     OneSplitViewWrapBase,
6812     OneSplitMStableView,
6813     OneSplitChaiView,
6814     OneSplitBdaiView,
6815     OneSplitAaveView,
6816     OneSplitFulcrumView,
6817     OneSplitCompoundView,
6818     OneSplitIearnView,
6819     OneSplitIdleView,
6820     OneSplitWethView,
6821     OneSplitDMMView,
6822     OneSplitMooniswapTokenView
6823 {
6824     IOneSplitView public oneSplitView;
6825 
6826     constructor(IOneSplitView _oneSplit) public {
6827         oneSplitView = _oneSplit;
6828     }
6829 
6830     function getExpectedReturn(
6831         IERC20 fromToken,
6832         IERC20 destToken,
6833         uint256 amount,
6834         uint256 parts,
6835         uint256 flags
6836     )
6837         public
6838         view
6839         returns(
6840             uint256 returnAmount,
6841             uint256[] memory distribution
6842         )
6843     {
6844         (returnAmount, , distribution) = getExpectedReturnWithGas(
6845             fromToken,
6846             destToken,
6847             amount,
6848             parts,
6849             flags,
6850             0
6851         );
6852     }
6853 
6854     function getExpectedReturnWithGas(
6855         IERC20 fromToken,
6856         IERC20 destToken,
6857         uint256 amount,
6858         uint256 parts,
6859         uint256 flags, // See constants in IOneSplit.sol
6860         uint256 destTokenEthPriceTimesGasPrice
6861     )
6862         public
6863         view
6864         returns(
6865             uint256 returnAmount,
6866             uint256 estimateGasAmount,
6867             uint256[] memory distribution
6868         )
6869     {
6870         if (fromToken == destToken) {
6871             return (amount, 0, new uint256[](DEXES_COUNT));
6872         }
6873 
6874         return super.getExpectedReturnWithGas(
6875             fromToken,
6876             destToken,
6877             amount,
6878             parts,
6879             flags,
6880             destTokenEthPriceTimesGasPrice
6881         );
6882     }
6883 
6884     function _getExpectedReturnRespectingGasFloor(
6885         IERC20 fromToken,
6886         IERC20 destToken,
6887         uint256 amount,
6888         uint256 parts,
6889         uint256 flags,
6890         uint256 destTokenEthPriceTimesGasPrice
6891     )
6892         internal
6893         view
6894         returns(
6895             uint256 returnAmount,
6896             uint256 estimateGasAmount,
6897             uint256[] memory distribution
6898         )
6899     {
6900         return oneSplitView.getExpectedReturnWithGas(
6901             fromToken,
6902             destToken,
6903             amount,
6904             parts,
6905             flags,
6906             destTokenEthPriceTimesGasPrice
6907         );
6908     }
6909 }
6910 
6911 
6912 contract OneSplitWrap is
6913     OneSplitBaseWrap,
6914     OneSplitMStable,
6915     OneSplitChai,
6916     OneSplitBdai,
6917     OneSplitAave,
6918     OneSplitFulcrum,
6919     OneSplitCompound,
6920     OneSplitIearn,
6921     OneSplitIdle,
6922     OneSplitWeth,
6923     OneSplitDMM,
6924     OneSplitMooniswapToken
6925 {
6926     IOneSplitView public oneSplitView;
6927     IOneSplit public oneSplit;
6928 
6929     constructor(IOneSplitView _oneSplitView, IOneSplit _oneSplit) public {
6930         oneSplitView = _oneSplitView;
6931         oneSplit = _oneSplit;
6932     }
6933 
6934     function() external payable {
6935         // solium-disable-next-line security/no-tx-origin
6936         require(msg.sender != tx.origin);
6937     }
6938 
6939     function getExpectedReturn(
6940         IERC20 fromToken,
6941         IERC20 destToken,
6942         uint256 amount,
6943         uint256 parts,
6944         uint256 flags
6945     )
6946         public
6947         view
6948         returns(
6949             uint256 returnAmount,
6950             uint256[] memory distribution
6951         )
6952     {
6953         (returnAmount, , distribution) = getExpectedReturnWithGas(
6954             fromToken,
6955             destToken,
6956             amount,
6957             parts,
6958             flags,
6959             0
6960         );
6961     }
6962 
6963     function getExpectedReturnWithGas(
6964         IERC20 fromToken,
6965         IERC20 destToken,
6966         uint256 amount,
6967         uint256 parts,
6968         uint256 flags,
6969         uint256 destTokenEthPriceTimesGasPrice
6970     )
6971         public
6972         view
6973         returns(
6974             uint256 returnAmount,
6975             uint256 estimateGasAmount,
6976             uint256[] memory distribution
6977         )
6978     {
6979         return oneSplitView.getExpectedReturnWithGas(
6980             fromToken,
6981             destToken,
6982             amount,
6983             parts,
6984             flags,
6985             destTokenEthPriceTimesGasPrice
6986         );
6987     }
6988 
6989     function getExpectedReturnWithGasMulti(
6990         IERC20[] memory tokens,
6991         uint256 amount,
6992         uint256[] memory parts,
6993         uint256[] memory flags,
6994         uint256[] memory destTokenEthPriceTimesGasPrices
6995     )
6996         public
6997         view
6998         returns(
6999             uint256[] memory returnAmounts,
7000             uint256 estimateGasAmount,
7001             uint256[] memory distribution
7002         )
7003     {
7004         uint256[] memory dist;
7005 
7006         returnAmounts = new uint256[](tokens.length - 1);
7007         for (uint i = 1; i < tokens.length; i++) {
7008             if (tokens[i - 1] == tokens[i]) {
7009                 returnAmounts[i - 1] = (i == 1) ? amount : returnAmounts[i - 2];
7010                 continue;
7011             }
7012 
7013             IERC20[] memory _tokens = tokens;
7014 
7015             (
7016                 returnAmounts[i - 1],
7017                 amount,
7018                 dist
7019             ) = getExpectedReturnWithGas(
7020                 _tokens[i - 1],
7021                 _tokens[i],
7022                 (i == 1) ? amount : returnAmounts[i - 2],
7023                 parts[i - 1],
7024                 flags[i - 1],
7025                 destTokenEthPriceTimesGasPrices[i - 1]
7026             );
7027             estimateGasAmount = estimateGasAmount.add(amount);
7028 
7029             if (distribution.length == 0) {
7030                 distribution = new uint256[](dist.length);
7031             }
7032             for (uint j = 0; j < distribution.length; j++) {
7033                 distribution[j] = distribution[j].add(dist[j] << (8 * (i - 1)));
7034             }
7035         }
7036     }
7037 
7038     function swap(
7039         IERC20 fromToken,
7040         IERC20 destToken,
7041         uint256 amount,
7042         uint256 minReturn,
7043         uint256[] memory distribution,
7044         uint256 flags
7045     ) public payable returns(uint256 returnAmount) {
7046         fromToken.universalTransferFrom(msg.sender, address(this), amount);
7047         uint256 confirmed = fromToken.universalBalanceOf(address(this));
7048         _swap(fromToken, destToken, confirmed, distribution, flags);
7049 
7050         returnAmount = destToken.universalBalanceOf(address(this));
7051         require(returnAmount >= minReturn, "OneSplit: actual return amount is less than minReturn");
7052         destToken.universalTransfer(msg.sender, returnAmount);
7053         fromToken.universalTransfer(msg.sender, fromToken.universalBalanceOf(address(this)));
7054     }
7055 
7056     function swapMulti(
7057         IERC20[] memory tokens,
7058         uint256 amount,
7059         uint256 minReturn,
7060         uint256[] memory distribution,
7061         uint256[] memory flags
7062     ) public payable returns(uint256 returnAmount) {
7063         tokens[0].universalTransferFrom(msg.sender, address(this), amount);
7064 
7065         returnAmount = tokens[0].universalBalanceOf(address(this));
7066         for (uint i = 1; i < tokens.length; i++) {
7067             if (tokens[i - 1] == tokens[i]) {
7068                 continue;
7069             }
7070 
7071             uint256[] memory dist = new uint256[](distribution.length);
7072             for (uint j = 0; j < distribution.length; j++) {
7073                 dist[j] = (distribution[j] >> (8 * (i - 1))) & 0xFF;
7074             }
7075 
7076             _swap(
7077                 tokens[i - 1],
7078                 tokens[i],
7079                 returnAmount,
7080                 dist,
7081                 flags[i - 1]
7082             );
7083             returnAmount = tokens[i].universalBalanceOf(address(this));
7084             tokens[i - 1].universalTransfer(msg.sender, tokens[i - 1].universalBalanceOf(address(this)));
7085         }
7086 
7087         require(returnAmount >= minReturn, "OneSplit: actual return amount is less than minReturn");
7088         tokens[tokens.length - 1].universalTransfer(msg.sender, returnAmount);
7089     }
7090 
7091     function _swapFloor(
7092         IERC20 fromToken,
7093         IERC20 destToken,
7094         uint256 amount,
7095         uint256[] memory distribution,
7096         uint256 flags
7097     ) internal {
7098         fromToken.universalApprove(address(oneSplit), amount);
7099         oneSplit.swap.value(fromToken.isETH() ? amount : 0)(
7100             fromToken,
7101             destToken,
7102             amount,
7103             0,
7104             distribution,
7105             flags
7106         );
7107     }
7108 }