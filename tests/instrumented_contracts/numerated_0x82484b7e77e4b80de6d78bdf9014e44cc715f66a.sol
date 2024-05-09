1 // File: contracts/interface/IXPool.sol
2 
3 pragma solidity 0.5.17;
4 
5 interface IXPool {
6     // XPToken
7     event Approval(address indexed src, address indexed dst, uint256 amt);
8     event Transfer(address indexed src, address indexed dst, uint256 amt);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address whom) external view returns (uint256);
13 
14     function allowance(address src, address dst)
15         external
16         view
17         returns (uint256);
18 
19     function approve(address dst, uint256 amt) external returns (bool);
20 
21     function transfer(address dst, uint256 amt) external returns (bool);
22 
23     function transferFrom(
24         address src,
25         address dst,
26         uint256 amt
27     ) external returns (bool);
28 
29     // Swap
30     function swapExactAmountIn(
31         address tokenIn,
32         uint256 tokenAmountIn,
33         address tokenOut,
34         uint256 minAmountOut,
35         uint256 maxPrice
36     ) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
37 
38     function swapExactAmountOut(
39         address tokenIn,
40         uint256 maxAmountIn,
41         address tokenOut,
42         uint256 tokenAmountOut,
43         uint256 maxPrice
44     ) external returns (uint256 tokenAmountIn, uint256 spotPriceAfter);
45 
46     // Referral
47     function swapExactAmountInRefer(
48         address tokenIn,
49         uint256 tokenAmountIn,
50         address tokenOut,
51         uint256 minAmountOut,
52         uint256 maxPrice,
53         address referrer
54     ) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
55 
56     function swapExactAmountOutRefer(
57         address tokenIn,
58         uint256 maxAmountIn,
59         address tokenOut,
60         uint256 tokenAmountOut,
61         uint256 maxPrice,
62         address referrer
63     ) external returns (uint256 tokenAmountIn, uint256 spotPriceAfter);
64 
65     // Pool Data
66     function isBound(address token) external view returns (bool);
67 
68     function getFinalTokens() external view returns (address[] memory tokens);
69 
70     function getBalance(address token) external view returns (uint256);
71 
72     function swapFee() external view returns (uint256);
73 
74     function exitFee() external view returns (uint256);
75 
76     function finalized() external view returns (uint256);
77 
78     function controller() external view returns (uint256);
79 
80     function isFarmPool() external view returns (uint256);
81 
82     function xconfig() external view returns (uint256);
83 
84     function getDenormalizedWeight(address) external view returns (uint256);
85 
86     function getTotalDenormalizedWeight() external view returns (uint256);
87 
88     function getVersion() external view returns (bytes32);
89 
90     function calcInGivenOut(
91         uint256 tokenBalanceIn,
92         uint256 tokenWeightIn,
93         uint256 tokenBalanceOut,
94         uint256 tokenWeightOut,
95         uint256 tokenAmountOut,
96         uint256 _swapFee
97     ) external pure returns (uint256 tokenAmountIn);
98 
99     function calcOutGivenIn(
100         uint256 tokenBalanceIn,
101         uint256 tokenWeightIn,
102         uint256 tokenBalanceOut,
103         uint256 tokenWeightOut,
104         uint256 tokenAmountIn,
105         uint256 _swapFee
106     ) external pure returns (uint256 tokenAmountOut);
107 
108     // Pool Managment
109     function setController(address _controller) external;
110 
111     function setExitFee(uint256 newFee) external;
112 
113     function finalize(uint256 _swapFee) external;
114 
115     function bind(address token, uint256 denorm) external;
116 
117     function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn)
118         external;
119 
120     function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut)
121         external;
122 
123     function joinswapExternAmountIn(
124         address tokenIn,
125         uint256 tokenAmountIn,
126         uint256 minPoolAmountOut
127     ) external returns (uint256 poolAmountOut);
128 
129     function exitswapPoolAmountIn(
130         address tokenOut,
131         uint256 poolAmountIn,
132         uint256 minAmountOut
133     ) external returns (uint256 tokenAmountOut);
134 
135     // Pool Governance
136     function updateSafu(address safu, uint256 fee) external;
137 
138     function updateFarm(bool isFarm) external;
139 }
140 
141 // File: contracts/interface/IXFactory.sol
142 
143 pragma solidity 0.5.17;
144 
145 
146 interface IXFactory {
147     function newXPool() external returns (IXPool);
148 }
149 
150 // File: contracts/interface/IXConfig.sol
151 
152 pragma solidity 0.5.17;
153 
154 interface IXConfig {
155     function getCore() external view returns (address);
156 
157     function getSAFU() external view returns (address);
158 
159     function getMaxExitFee() external view returns (uint256);
160 
161     function getSafuFee() external view returns (uint256);
162 
163     function getSwapProxy() external view returns (address);
164 
165     function dedupPool(address[] calldata tokens, uint256[] calldata denorms)
166         external
167         returns (bool exist, bytes32 sig);
168 
169     function addPoolSig(bytes32 sig, address pool) external;
170 }
171 
172 // File: contracts/interface/IERC20.sol
173 
174 pragma solidity 0.5.17;
175 
176 interface IERC20 {
177     function name() external view returns (string memory);
178 
179     function symbol() external view returns (string memory);
180 
181     function decimals() external view returns (uint8);
182 
183     function totalSupply() external view returns (uint256);
184 
185     function balanceOf(address _owner) external view returns (uint256 balance);
186 
187     function transfer(address _to, uint256 _value)
188         external
189         returns (bool success);
190 
191     function transferFrom(
192         address _from,
193         address _to,
194         uint256 _value
195     ) external returns (bool success);
196 
197     function approve(address _spender, uint256 _value)
198         external
199         returns (bool success);
200 
201     function allowance(address _owner, address _spender)
202         external
203         view
204         returns (uint256 remaining);
205 }
206 
207 // File: contracts/lib/XNum.sol
208 
209 pragma solidity 0.5.17;
210 
211 library XNum {
212     uint256 public constant BONE = 10**18;
213     uint256 public constant MIN_BPOW_BASE = 1 wei;
214     uint256 public constant MAX_BPOW_BASE = (2 * BONE) - 1 wei;
215     uint256 public constant BPOW_PRECISION = BONE / 10**10;
216 
217     function btoi(uint256 a) internal pure returns (uint256) {
218         return a / BONE;
219     }
220 
221     function bfloor(uint256 a) internal pure returns (uint256) {
222         return btoi(a) * BONE;
223     }
224 
225     function badd(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a, "ERR_ADD_OVERFLOW");
228         return c;
229     }
230 
231     function bsub(uint256 a, uint256 b) internal pure returns (uint256) {
232         (uint256 c, bool flag) = bsubSign(a, b);
233         require(!flag, "ERR_SUB_UNDERFLOW");
234         return c;
235     }
236 
237     function bsubSign(uint256 a, uint256 b)
238         internal
239         pure
240         returns (uint256, bool)
241     {
242         if (a >= b) {
243             return (a - b, false);
244         } else {
245             return (b - a, true);
246         }
247     }
248 
249     function bmul(uint256 a, uint256 b) internal pure returns (uint256) {
250         uint256 c0 = a * b;
251         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
252         uint256 c1 = c0 + (BONE / 2);
253         require(c1 >= c0, "ERR_MUL_OVERFLOW");
254         uint256 c2 = c1 / BONE;
255         return c2;
256     }
257 
258     function bdiv(uint256 a, uint256 b) internal pure returns (uint256) {
259         require(b != 0, "ERR_DIV_ZERO");
260         uint256 c0 = a * BONE;
261         require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow
262         uint256 c1 = c0 + (b / 2);
263         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
264         uint256 c2 = c1 / b;
265         return c2;
266     }
267 
268     // DSMath.wpow
269     function bpowi(uint256 a, uint256 n) internal pure returns (uint256) {
270         uint256 z = n % 2 != 0 ? a : BONE;
271 
272         for (n /= 2; n != 0; n /= 2) {
273             a = bmul(a, a);
274 
275             if (n % 2 != 0) {
276                 z = bmul(z, a);
277             }
278         }
279         return z;
280     }
281 
282     // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).
283     // Use `bpowi` for `b^e` and `bpowK` for k iterations
284     // of approximation of b^0.w
285     function bpow(uint256 base, uint256 exp) internal pure returns (uint256) {
286         require(base >= MIN_BPOW_BASE, "ERR_BPOW_BASE_TOO_LOW");
287         require(base <= MAX_BPOW_BASE, "ERR_BPOW_BASE_TOO_HIGH");
288 
289         uint256 whole = bfloor(exp);
290         uint256 remain = bsub(exp, whole);
291 
292         uint256 wholePow = bpowi(base, btoi(whole));
293 
294         if (remain == 0) {
295             return wholePow;
296         }
297 
298         uint256 partialResult = bpowApprox(base, remain, BPOW_PRECISION);
299         return bmul(wholePow, partialResult);
300     }
301 
302     function bpowApprox(
303         uint256 base,
304         uint256 exp,
305         uint256 precision
306     ) internal pure returns (uint256) {
307         // term 0:
308         uint256 a = exp;
309         (uint256 x, bool xneg) = bsubSign(base, BONE);
310         uint256 term = BONE;
311         uint256 sum = term;
312         bool negative = false;
313 
314         // term(k) = numer / denom
315         //         = (product(a - i + 1, i=1-->k) * x^k) / (k!)
316         // each iteration, multiply previous term by (a-(k-1)) * x / k
317         // continue until term is less than precision
318         for (uint256 i = 1; term >= precision; i++) {
319             uint256 bigK = i * BONE;
320             (uint256 c, bool cneg) = bsubSign(a, bsub(bigK, BONE));
321             term = bmul(term, bmul(c, x));
322             term = bdiv(term, bigK);
323             if (term == 0) break;
324 
325             if (xneg) negative = !negative;
326             if (cneg) negative = !negative;
327             if (negative) {
328                 sum = bsub(sum, term);
329             } else {
330                 sum = badd(sum, term);
331             }
332         }
333 
334         return sum;
335     }
336 }
337 
338 // File: contracts/lib/Address.sol
339 
340 pragma solidity 0.5.17;
341 
342 //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/utils/Address.sol
343 
344 /**
345  * @dev Collection of functions related to the address type
346  */
347 library Address {
348     /**
349      * @dev Returns true if `account` is a contract.
350      *
351      * [IMPORTANT]
352      * ====
353      * It is unsafe to assume that an address for which this function returns
354      * false is an externally-owned account (EOA) and not a contract.
355      *
356      * Among others, `isContract` will return false for the following
357      * types of addresses:
358      *
359      *  - an externally-owned account
360      *  - a contract in construction
361      *  - an address where a contract will be created
362      *  - an address where a contract lived, but was destroyed
363      * ====
364      */
365     function isContract(address account) internal view returns (bool) {
366         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
367         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
368         // for accounts without code, i.e. `keccak256('')`
369         bytes32 codehash;
370         bytes32 accountHash =
371             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
372         // solhint-disable-next-line no-inline-assembly
373         assembly {
374             codehash := extcodehash(account)
375         }
376         return (codehash != accountHash && codehash != 0x0);
377     }
378 
379     /**
380      * @dev Converts an `address` into `address payable`. Note that this is
381      * simply a type cast: the actual underlying value is not changed.
382      *
383      * _Available since v2.4.0._
384      */
385     function toPayable(address account)
386         internal
387         pure
388         returns (address payable)
389     {
390         return address(uint160(account));
391     }
392 
393     /**
394      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
395      * `recipient`, forwarding all available gas and reverting on errors.
396      *
397      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
398      * of certain opcodes, possibly making contracts go over the 2300 gas limit
399      * imposed by `transfer`, making them unable to receive funds via
400      * `transfer`. {sendValue} removes this limitation.
401      *
402      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
403      *
404      * IMPORTANT: because control is transferred to `recipient`, care must be
405      * taken to not create reentrancy vulnerabilities. Consider using
406      * {ReentrancyGuard} or the
407      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
408      *
409      * _Available since v2.4.0._
410      */
411     function sendValue(address payable recipient, uint256 amount) internal {
412         require(
413             address(this).balance >= amount,
414             "Address: insufficient balance"
415         );
416 
417         // solhint-disable-next-line avoid-call-value
418         (bool success, ) = recipient.call.value(amount).gas(9100)("");
419         require(
420             success,
421             "Address: unable to send value, recipient may have reverted"
422         );
423     }
424 }
425 
426 // File: contracts/lib/SafeERC20.sol
427 
428 pragma solidity 0.5.17;
429 
430 
431 
432 //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/SafeERC20.sol
433 
434 /**
435  * @title SafeERC20
436  * @dev Wrappers around ERC20 operations that throw on failure (when the token
437  * contract returns false). Tokens that return no value (and instead revert or
438  * throw on failure) are also supported, non-reverting calls are assumed to be
439  * successful.
440  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
441  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
442  */
443 library SafeERC20 {
444     using Address for address;
445 
446     function safeTransfer(
447         IERC20 token,
448         address to,
449         uint256 value
450     ) internal {
451         callOptionalReturn(
452             token,
453             abi.encodeWithSelector(token.transfer.selector, to, value)
454         );
455     }
456 
457     function safeTransferFrom(
458         IERC20 token,
459         address from,
460         address to,
461         uint256 value
462     ) internal {
463         callOptionalReturn(
464             token,
465             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
466         );
467     }
468 
469     function safeApprove(
470         IERC20 token,
471         address spender,
472         uint256 value
473     ) internal {
474         // safeApprove should only be called when setting an initial allowance,
475         // or when resetting it to zero. To increase and decrease it, use
476         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
477         // solhint-disable-next-line max-line-length
478         require(
479             (value == 0) || (token.allowance(address(this), spender) == 0),
480             "SafeERC20: approve from non-zero to non-zero allowance"
481         );
482         callOptionalReturn(
483             token,
484             abi.encodeWithSelector(token.approve.selector, spender, value)
485         );
486     }
487 
488     /**
489      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
490      * on the return value: the return value is optional (but if data is returned, it must not be false).
491      * @param token The token targeted by the call.
492      * @param data The call data (encoded using abi.encode or one of its variants).
493      */
494     function callOptionalReturn(IERC20 token, bytes memory data) private {
495         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
496         // we're implementing it ourselves.
497 
498         // A Solidity high level call has three parts:
499         //  1. The target address is checked to verify it contains contract code
500         //  2. The call itself is made, and success asserted
501         //  3. The return value is decoded, which in turn checks the size of the returned data.
502         // solhint-disable-next-line max-line-length
503         require(address(token).isContract(), "SafeERC20: call to non-contract");
504 
505         // solhint-disable-next-line avoid-low-level-calls
506         (bool success, bytes memory returndata) = address(token).call(data);
507         require(success, "SafeERC20: low-level call failed");
508 
509         if (returndata.length > 0) {
510             // Return data is optional
511             // solhint-disable-next-line max-line-length
512             require(
513                 abi.decode(returndata, (bool)),
514                 "SafeERC20: ERC20 operation did not succeed"
515             );
516         }
517     }
518 }
519 
520 // File: contracts/lib/ReentrancyGuard.sol
521 
522 pragma solidity 0.5.17;
523 
524 //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/utils/ReentrancyGuard.sol
525 
526 /**
527  * @dev Contract module that helps prevent reentrant calls to a function.
528  *
529  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
530  * available, which can be applied to functions to make sure there are no nested
531  * (reentrant) calls to them.
532  *
533  * Note that because there is a single `nonReentrant` guard, functions marked as
534  * `nonReentrant` may not call one another. This can be worked around by making
535  * those functions `private`, and then adding `external` `nonReentrant` entry
536  * points to them.
537  *
538  * TIP: If you would like to learn more about reentrancy and alternative ways
539  * to protect against it, check out our blog post
540  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
541  *
542  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
543  * metering changes introduced in the Istanbul hardfork.
544  */
545 contract ReentrancyGuard {
546     bool private _notEntered;
547 
548     constructor() internal {
549         // Storing an initial non-zero value makes deployment a bit more
550         // expensive, but in exchange the refund on every call to nonReentrant
551         // will be lower in amount. Since refunds are capped to a percetange of
552         // the total transaction's gas, it is best to keep them low in cases
553         // like this one, to increase the likelihood of the full refund coming
554         // into effect.
555         _notEntered = true;
556     }
557 
558     /**
559      * @dev Prevents a contract from calling itself, directly or indirectly.
560      * Calling a `nonReentrant` function from another `nonReentrant`
561      * function is not supported. It is possible to prevent this from happening
562      * by making the `nonReentrant` function external, and make it call a
563      * `private` function that does the actual work.
564      */
565     modifier nonReentrant() {
566         // On the first call to nonReentrant, _notEntered will be true
567         require(_notEntered, "ReentrancyGuard: reentrant call");
568 
569         // Any calls to nonReentrant after this point will fail
570         _notEntered = false;
571 
572         _;
573 
574         // By storing the original value once again, a refund is triggered (see
575         // https://eips.ethereum.org/EIPS/eip-2200)
576         _notEntered = true;
577     }
578 }
579 
580 // File: contracts/XSwapProxyV1.sol
581 
582 pragma solidity 0.5.17;
583 pragma experimental ABIEncoderV2;
584 
585 
586 
587 
588 
589 
590 
591 
592 // WETH9
593 interface IWETH {
594     function balanceOf(address account) external view returns (uint256);
595 
596     function allowance(address owner, address spender)
597         external
598         view
599         returns (uint256);
600 
601     function approve(address, uint256) external returns (bool);
602 
603     function transfer(address to, uint256 amount) external returns (bool);
604 
605     function transferFrom(
606         address from,
607         address to,
608         uint256 amount
609     ) external returns (bool);
610 
611     function deposit() external payable;
612 
613     function withdraw(uint256 amount) external;
614 }
615 
616 contract XSwapProxyV1 is ReentrancyGuard {
617     using XNum for uint256;
618     using SafeERC20 for IERC20;
619 
620     uint256 public constant MAX = 2**256 - 1;
621     uint256 public constant BONE = 10**18;
622     uint256 public constant MIN_BOUND_TOKENS = 2;
623     uint256 public constant MAX_BOUND_TOKENS = 8;
624 
625     uint256 public constant MIN_BATCH_SWAPS = 1;
626     uint256 public constant MAX_BATCH_SWAPS = 4;
627 
628     /**
629      * the address used within the protocol to identify ETH
630      */
631     address public constant ETH_ADDR =
632         address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
633 
634     // WETH9
635     IWETH weth;
636 
637     IXConfig public xconfig;
638 
639     constructor(address _weth, address _xconfig) public {
640         weth = IWETH(_weth);
641         xconfig = IXConfig(_xconfig);
642     }
643 
644     function() external payable {}
645 
646     // Batch Swap
647     struct Swap {
648         address pool;
649         uint256 tokenInParam; // tokenInAmount / maxAmountIn
650         uint256 tokenOutParam; // minAmountOut / tokenAmountOut
651         uint256 maxPrice;
652     }
653 
654     function batchSwapExactIn(
655         Swap[] memory swaps,
656         address tokenIn,
657         address tokenOut,
658         uint256 totalAmountIn,
659         uint256 minTotalAmountOut
660     ) public payable returns (uint256 totalAmountOut) {
661         return
662             batchSwapExactInRefer(
663                 swaps,
664                 tokenIn,
665                 tokenOut,
666                 totalAmountIn,
667                 minTotalAmountOut,
668                 address(0x0)
669             );
670     }
671 
672     function batchSwapExactInRefer(
673         Swap[] memory swaps,
674         address tokenIn,
675         address tokenOut,
676         uint256 totalAmountIn,
677         uint256 minTotalAmountOut,
678         address referrer
679     ) public payable nonReentrant returns (uint256 totalAmountOut) {
680         require(
681             swaps.length >= MIN_BATCH_SWAPS && swaps.length <= MAX_BATCH_SWAPS,
682             "ERR_BATCH_COUNT"
683         );
684 
685         IERC20 TI = IERC20(tokenIn);
686         if (transferFromAllTo(TI, totalAmountIn, address(this))) {
687             TI = IERC20(address(weth));
688         }
689 
690         IERC20 TO = IERC20(tokenOut);
691         if (tokenOut == ETH_ADDR) {
692             TO = IERC20(address(weth));
693         }
694         require(TI != TO, "ERR_SAME_TOKEN");
695 
696         uint256 actualTotalIn = 0;
697         for (uint256 i = 0; i < swaps.length; i++) {
698             Swap memory swap = swaps[i];
699             IXPool pool = IXPool(swap.pool);
700 
701             if (TI.allowance(address(this), swap.pool) < totalAmountIn) {
702                 TI.safeApprove(swap.pool, 0);
703                 TI.safeApprove(swap.pool, MAX);
704             }
705 
706             (uint256 tokenAmountOut, ) =
707                 pool.swapExactAmountInRefer(
708                     address(TI),
709                     swap.tokenInParam,
710                     address(TO),
711                     swap.tokenOutParam,
712                     swap.maxPrice,
713                     referrer
714                 );
715 
716             actualTotalIn = actualTotalIn.badd(swap.tokenInParam);
717             totalAmountOut = tokenAmountOut.badd(totalAmountOut);
718         }
719         require(actualTotalIn <= totalAmountIn, "ERR_ACTUAL_IN");
720         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
721 
722         transferAll(tokenOut, totalAmountOut);
723         transferAll(tokenIn, getBalance(address(TI)));
724     }
725 
726     function batchSwapExactOut(
727         Swap[] memory swaps,
728         address tokenIn,
729         address tokenOut,
730         uint256 maxTotalAmountIn
731     ) public payable returns (uint256 totalAmountIn) {
732         return
733             batchSwapExactOutRefer(
734                 swaps,
735                 tokenIn,
736                 tokenOut,
737                 maxTotalAmountIn,
738                 address(0x0)
739             );
740     }
741 
742     function batchSwapExactOutRefer(
743         Swap[] memory swaps,
744         address tokenIn,
745         address tokenOut,
746         uint256 maxTotalAmountIn,
747         address referrer
748     ) public payable nonReentrant returns (uint256 totalAmountIn) {
749         require(
750             swaps.length >= MIN_BATCH_SWAPS && swaps.length <= MAX_BATCH_SWAPS,
751             "ERR_BATCH_COUNT"
752         );
753 
754         IERC20 TI = IERC20(tokenIn);
755         if (transferFromAllTo(TI, maxTotalAmountIn, address(this))) {
756             TI = IERC20(address(weth));
757         }
758 
759         IERC20 TO = IERC20(tokenOut);
760         if (tokenOut == ETH_ADDR) {
761             TO = IERC20(address(weth));
762         }
763         require(TI != TO, "ERR_SAME_TOKEN");
764 
765         for (uint256 i = 0; i < swaps.length; i++) {
766             Swap memory swap = swaps[i];
767             IXPool pool = IXPool(swap.pool);
768 
769             if (TI.allowance(address(this), swap.pool) < maxTotalAmountIn) {
770                 TI.safeApprove(swap.pool, 0);
771                 TI.safeApprove(swap.pool, MAX);
772             }
773 
774             (uint256 tokenAmountIn, ) =
775                 pool.swapExactAmountOutRefer(
776                     address(TI),
777                     swap.tokenInParam,
778                     address(TO),
779                     swap.tokenOutParam,
780                     swap.maxPrice,
781                     referrer
782                 );
783             totalAmountIn = tokenAmountIn.badd(totalAmountIn);
784         }
785         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
786 
787         transferAll(tokenOut, getBalance(tokenOut));
788         transferAll(tokenIn, getBalance(address(TI)));
789     }
790 
791     // Multihop Swap
792     struct MSwap {
793         address pool;
794         address tokenIn;
795         address tokenOut;
796         uint256 swapAmount; // tokenInAmount / tokenOutAmount
797         uint256 limitReturnAmount; // minAmountOut / maxAmountIn
798         uint256 maxPrice;
799     }
800 
801     function multihopBatchSwapExactIn(
802         MSwap[][] memory swapSequences,
803         address tokenIn,
804         address tokenOut,
805         uint256 totalAmountIn,
806         uint256 minTotalAmountOut
807     ) public payable returns (uint256 totalAmountOut) {
808         return
809             multihopBatchSwapExactInRefer(
810                 swapSequences,
811                 tokenIn,
812                 tokenOut,
813                 totalAmountIn,
814                 minTotalAmountOut,
815                 address(0x0)
816             );
817     }
818 
819     function multihopBatchSwapExactInRefer(
820         MSwap[][] memory swapSequences,
821         address tokenIn,
822         address tokenOut,
823         uint256 totalAmountIn,
824         uint256 minTotalAmountOut,
825         address referrer
826     ) public payable nonReentrant returns (uint256 totalAmountOut) {
827         require(
828             swapSequences.length >= MIN_BATCH_SWAPS &&
829                 swapSequences.length <= MAX_BATCH_SWAPS,
830             "ERR_BATCH_COUNT"
831         );
832 
833         IERC20 TI = IERC20(tokenIn);
834         if (transferFromAllTo(TI, totalAmountIn, address(this))) {
835             TI = IERC20(address(weth));
836         }
837 
838         uint256 actualTotalIn = 0;
839         for (uint256 i = 0; i < swapSequences.length; i++) {
840             require(
841                 address(TI) == swapSequences[i][0].tokenIn,
842                 "ERR_NOT_MATCH"
843             );
844             actualTotalIn = actualTotalIn.badd(swapSequences[i][0].swapAmount);
845 
846             uint256 tokenAmountOut = 0;
847             for (uint256 k = 0; k < swapSequences[i].length; k++) {
848                 MSwap memory swap = swapSequences[i][k];
849 
850                 IERC20 SwapTokenIn = IERC20(swap.tokenIn);
851                 if (k == 1) {
852                     // Makes sure that on the second swap the output of the first was used
853                     // so there is not intermediate token leftover
854                     swap.swapAmount = tokenAmountOut;
855                 }
856 
857                 if (
858                     SwapTokenIn.allowance(address(this), swap.pool) <
859                     totalAmountIn
860                 ) {
861                     SwapTokenIn.safeApprove(swap.pool, 0);
862                     SwapTokenIn.safeApprove(swap.pool, MAX);
863                 }
864 
865                 (tokenAmountOut, ) = IXPool(swap.pool).swapExactAmountInRefer(
866                     swap.tokenIn,
867                     swap.swapAmount,
868                     swap.tokenOut,
869                     swap.limitReturnAmount,
870                     swap.maxPrice,
871                     referrer
872                 );
873             }
874             // This takes the amountOut of the last swap
875             totalAmountOut = tokenAmountOut.badd(totalAmountOut);
876         }
877 
878         require(actualTotalIn <= totalAmountIn, "ERR_ACTUAL_IN");
879         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
880 
881         transferAll(tokenOut, totalAmountOut);
882         transferAll(tokenIn, getBalance(address(TI)));
883     }
884 
885     function multihopBatchSwapExactOut(
886         MSwap[][] memory swapSequences,
887         address tokenIn,
888         address tokenOut,
889         uint256 maxTotalAmountIn
890     ) public payable returns (uint256 totalAmountIn) {
891         return
892             multihopBatchSwapExactOutRefer(
893                 swapSequences,
894                 tokenIn,
895                 tokenOut,
896                 maxTotalAmountIn,
897                 address(0x0)
898             );
899     }
900 
901     function multihopBatchSwapExactOutRefer(
902         MSwap[][] memory swapSequences,
903         address tokenIn,
904         address tokenOut,
905         uint256 maxTotalAmountIn,
906         address referrer
907     ) public payable nonReentrant returns (uint256 totalAmountIn) {
908         require(
909             swapSequences.length >= MIN_BATCH_SWAPS &&
910                 swapSequences.length <= MAX_BATCH_SWAPS,
911             "ERR_BATCH_COUNT"
912         );
913 
914         IERC20 TI = IERC20(tokenIn);
915         if (transferFromAllTo(TI, maxTotalAmountIn, address(this))) {
916             TI = IERC20(address(weth));
917         }
918 
919         for (uint256 i = 0; i < swapSequences.length; i++) {
920             require(
921                 address(TI) == swapSequences[i][0].tokenIn,
922                 "ERR_NOT_MATCH"
923             );
924 
925             uint256 tokenAmountInFirstSwap = 0;
926             // Specific code for a simple swap and a multihop (2 swaps in sequence)
927             if (swapSequences[i].length == 1) {
928                 MSwap memory swap = swapSequences[i][0];
929                 IERC20 SwapTokenIn = IERC20(swap.tokenIn);
930 
931                 if (
932                     SwapTokenIn.allowance(address(this), swap.pool) <
933                     maxTotalAmountIn
934                 ) {
935                     SwapTokenIn.safeApprove(swap.pool, 0);
936                     SwapTokenIn.safeApprove(swap.pool, MAX);
937                 }
938 
939                 (tokenAmountInFirstSwap, ) = IXPool(swap.pool)
940                     .swapExactAmountOutRefer(
941                     swap.tokenIn,
942                     swap.limitReturnAmount,
943                     swap.tokenOut,
944                     swap.swapAmount,
945                     swap.maxPrice,
946                     referrer
947                 );
948             } else {
949                 // Consider we are swapping A -> B and B -> C. The goal is to buy a given amount
950                 // of token C. But first we need to buy B with A so we can then buy C with B
951                 // To get the exact amount of C we then first need to calculate how much B we'll need:
952                 uint256 intermediateTokenAmount;
953                 // This would be token B as described above
954                 MSwap memory secondSwap = swapSequences[i][1];
955                 IXPool poolSecondSwap = IXPool(secondSwap.pool);
956                 intermediateTokenAmount = poolSecondSwap.calcInGivenOut(
957                     poolSecondSwap.getBalance(secondSwap.tokenIn),
958                     poolSecondSwap.getDenormalizedWeight(secondSwap.tokenIn),
959                     poolSecondSwap.getBalance(secondSwap.tokenOut),
960                     poolSecondSwap.getDenormalizedWeight(secondSwap.tokenOut),
961                     secondSwap.swapAmount,
962                     poolSecondSwap.swapFee()
963                 );
964 
965                 // Buy intermediateTokenAmount of token B with A in the first pool
966                 MSwap memory firstSwap = swapSequences[i][0];
967                 IERC20 FirstSwapTokenIn = IERC20(firstSwap.tokenIn);
968                 IXPool poolFirstSwap = IXPool(firstSwap.pool);
969                 if (
970                     FirstSwapTokenIn.allowance(address(this), firstSwap.pool) <
971                     MAX
972                 ) {
973                     FirstSwapTokenIn.safeApprove(firstSwap.pool, 0);
974                     FirstSwapTokenIn.safeApprove(firstSwap.pool, MAX);
975                 }
976 
977                 (tokenAmountInFirstSwap, ) = poolFirstSwap.swapExactAmountOut(
978                     firstSwap.tokenIn,
979                     firstSwap.limitReturnAmount,
980                     firstSwap.tokenOut,
981                     intermediateTokenAmount, // This is the amount of token B we need
982                     firstSwap.maxPrice
983                 );
984 
985                 // Buy the final amount of token C desired
986                 IERC20 SecondSwapTokenIn = IERC20(secondSwap.tokenIn);
987                 if (
988                     SecondSwapTokenIn.allowance(
989                         address(this),
990                         secondSwap.pool
991                     ) < MAX
992                 ) {
993                     SecondSwapTokenIn.safeApprove(secondSwap.pool, 0);
994                     SecondSwapTokenIn.safeApprove(secondSwap.pool, MAX);
995                 }
996 
997                 poolSecondSwap.swapExactAmountOut(
998                     secondSwap.tokenIn,
999                     secondSwap.limitReturnAmount,
1000                     secondSwap.tokenOut,
1001                     secondSwap.swapAmount,
1002                     secondSwap.maxPrice
1003                 );
1004             }
1005             totalAmountIn = tokenAmountInFirstSwap.badd(totalAmountIn);
1006         }
1007 
1008         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
1009 
1010         transferAll(tokenOut, getBalance(tokenOut));
1011         transferAll(tokenIn, getBalance(address(TI)));
1012     }
1013 
1014     // Pool Management
1015     function create(
1016         address factoryAddress,
1017         address[] calldata tokens,
1018         uint256[] calldata balances,
1019         uint256[] calldata denorms,
1020         uint256 swapFee,
1021         uint256 exitFee
1022     ) external payable nonReentrant returns (address) {
1023         require(tokens.length == balances.length, "ERR_LENGTH_MISMATCH");
1024         require(tokens.length == denorms.length, "ERR_LENGTH_MISMATCH");
1025         require(tokens.length >= MIN_BOUND_TOKENS, "ERR_MIN_TOKENS");
1026         require(tokens.length <= MAX_BOUND_TOKENS, "ERR_MAX_TOKENS");
1027 
1028         // pool deduplication
1029         (bool exist, bytes32 sig) = xconfig.dedupPool(tokens, denorms);
1030         require(!exist, "ERR_POOL_EXISTS");
1031 
1032         // create new pool
1033         IXPool pool = IXFactory(factoryAddress).newXPool();
1034         bool hasETH = false;
1035         for (uint256 i = 0; i < tokens.length; i++) {
1036             if (
1037                 transferFromAllTo(IERC20(tokens[i]), balances[i], address(pool))
1038             ) {
1039                 hasETH = true;
1040                 pool.bind(address(weth), denorms[i]);
1041             } else {
1042                 pool.bind(tokens[i], denorms[i]);
1043             }
1044         }
1045         require(msg.value == 0 || hasETH, "ERR_INVALID_PAY");
1046         pool.setExitFee(exitFee);
1047         pool.finalize(swapFee);
1048 
1049         xconfig.addPoolSig(sig, address(pool));
1050         pool.transfer(msg.sender, pool.balanceOf(address(this)));
1051 
1052         return address(pool);
1053     }
1054 
1055     function joinPool(
1056         address poolAddress,
1057         uint256 poolAmountOut,
1058         uint256[] calldata maxAmountsIn
1059     ) external payable nonReentrant {
1060         IXPool pool = IXPool(poolAddress);
1061 
1062         address[] memory tokens = pool.getFinalTokens();
1063         require(maxAmountsIn.length == tokens.length, "ERR_LENGTH_MISMATCH");
1064 
1065         bool hasEth = false;
1066         for (uint8 i = 0; i < tokens.length; i++) {
1067             if (msg.value > 0 && tokens[i] == address(weth)) {
1068                 transferFromAllAndApprove(
1069                     ETH_ADDR,
1070                     maxAmountsIn[i],
1071                     poolAddress
1072                 );
1073                 hasEth = true;
1074             } else {
1075                 transferFromAllAndApprove(
1076                     tokens[i],
1077                     maxAmountsIn[i],
1078                     poolAddress
1079                 );
1080             }
1081         }
1082         require(msg.value == 0 || hasEth, "ERR_INVALID_PAY");
1083         pool.joinPool(poolAmountOut, maxAmountsIn);
1084         for (uint8 i = 0; i < tokens.length; i++) {
1085             if (hasEth && tokens[i] == address(weth)) {
1086                 transferAll(ETH_ADDR, getBalance(ETH_ADDR));
1087             } else {
1088                 transferAll(tokens[i], getBalance(tokens[i]));
1089             }
1090         }
1091         pool.transfer(msg.sender, pool.balanceOf(address(this)));
1092     }
1093 
1094     function joinswapExternAmountIn(
1095         address poolAddress,
1096         address tokenIn,
1097         uint256 tokenAmountIn,
1098         uint256 minPoolAmountOut
1099     ) external payable nonReentrant {
1100         IXPool pool = IXPool(poolAddress);
1101 
1102         bool hasEth = false;
1103         if (transferFromAllAndApprove(tokenIn, tokenAmountIn, poolAddress)) {
1104             hasEth = true;
1105         }
1106         require(msg.value == 0 || hasEth, "ERR_INVALID_PAY");
1107 
1108         if (hasEth) {
1109             uint256 poolAmountOut =
1110                 pool.joinswapExternAmountIn(
1111                     address(weth),
1112                     tokenAmountIn,
1113                     minPoolAmountOut
1114                 );
1115             pool.transfer(msg.sender, poolAmountOut);
1116         } else {
1117             uint256 poolAmountOut =
1118                 pool.joinswapExternAmountIn(
1119                     tokenIn,
1120                     tokenAmountIn,
1121                     minPoolAmountOut
1122                 );
1123             pool.transfer(msg.sender, poolAmountOut);
1124         }
1125     }
1126 
1127     // Internal
1128     function getBalance(address token) internal view returns (uint256) {
1129         if (token == ETH_ADDR) {
1130             return weth.balanceOf(address(this));
1131         }
1132         return IERC20(token).balanceOf(address(this));
1133     }
1134 
1135     function transferAll(address token, uint256 amount)
1136         internal
1137         returns (bool)
1138     {
1139         if (amount == 0) {
1140             return true;
1141         }
1142         if (token == ETH_ADDR) {
1143             weth.withdraw(amount);
1144             (bool xfer, ) = msg.sender.call.value(amount).gas(9100)("");
1145             require(xfer, "ERR_ETH_FAILED");
1146         } else {
1147             IERC20(token).safeTransfer(msg.sender, amount);
1148         }
1149         return true;
1150     }
1151 
1152     function transferFromAllTo(
1153         IERC20 token,
1154         uint256 amount,
1155         address to
1156     ) internal returns (bool hasETH) {
1157         hasETH = false;
1158         if (address(token) == ETH_ADDR) {
1159             require(amount == msg.value, "ERR_TOKEN_AMOUNT");
1160             weth.deposit.value(amount)();
1161             if (to != address(this)) {
1162                 weth.transfer(to, amount);
1163             }
1164             hasETH = true;
1165         } else {
1166             token.safeTransferFrom(msg.sender, to, amount);
1167         }
1168     }
1169 
1170     function transferFromAllAndApprove(
1171         address token,
1172         uint256 amount,
1173         address spender
1174     ) internal returns (bool hasETH) {
1175         hasETH = false;
1176         if (token == ETH_ADDR) {
1177             require(amount == msg.value, "ERR_TOKEN_AMOUNT");
1178             weth.deposit.value(amount)();
1179             if (weth.allowance(address(this), spender) < amount) {
1180                 IERC20(address(weth)).safeApprove(spender, 0);
1181                 IERC20(address(weth)).safeApprove(spender, amount);
1182             }
1183             hasETH = true;
1184         } else {
1185             IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1186             if (IERC20(token).allowance(address(this), spender) < amount) {
1187                 IERC20(token).safeApprove(spender, 0);
1188                 IERC20(token).safeApprove(spender, amount);
1189             }
1190         }
1191     }
1192 }