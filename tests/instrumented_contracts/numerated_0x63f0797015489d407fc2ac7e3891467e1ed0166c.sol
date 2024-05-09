1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 
6 
7 // Part: IBasicRewards
8 
9 interface IBasicRewards {
10     function stakeFor(address, uint256) external returns (bool);
11 
12     function balanceOf(address) external view returns (uint256);
13 
14     function earned(address) external view returns (uint256);
15 
16     function withdrawAll(bool) external returns (bool);
17 
18     function withdraw(uint256, bool) external returns (bool);
19 
20     function withdrawAndUnwrap(uint256 amount, bool claim)
21         external
22         returns (bool);
23 
24     function getReward() external returns (bool);
25 
26     function stake(uint256) external returns (bool);
27 
28     function extraRewards(uint256) external view returns (address);
29 }
30 
31 // Part: ICVXLocker
32 
33 interface ICVXLocker {
34     function lock(
35         address _account,
36         uint256 _amount,
37         uint256 _spendRatio
38     ) external;
39 
40     function balances(address _user)
41         external
42         view
43         returns (
44             uint112 locked,
45             uint112 boosted,
46             uint32 nextUnlockIndex
47         );
48 }
49 
50 // Part: ICurveTriCrypto
51 
52 interface ICurveTriCrypto {
53     function exchange(
54         uint256 i,
55         uint256 j,
56         uint256 dx,
57         uint256 min_dy,
58         bool use_eth
59     ) external payable;
60 
61     function get_dy(
62         uint256 i,
63         uint256 j,
64         uint256 dx
65     ) external view returns (uint256);
66 }
67 
68 // Part: ICurveV2Pool
69 
70 interface ICurveV2Pool {
71     function get_dy(
72         uint256 i,
73         uint256 j,
74         uint256 dx
75     ) external view returns (uint256);
76 
77     function exchange_underlying(
78         uint256 i,
79         uint256 j,
80         uint256 dx,
81         uint256 min_dy
82     ) external payable returns (uint256);
83 
84     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
85         external
86         returns (uint256);
87 
88     function lp_price() external view returns (uint256);
89 
90     function price_oracle() external view returns (uint256);
91 
92     function remove_liquidity_one_coin(
93         uint256 token_amount,
94         uint256 i,
95         uint256 min_amount,
96         bool use_eth,
97         address receiver
98     ) external returns (uint256);
99 }
100 
101 // Part: IGenericVault
102 
103 interface IGenericVault {
104     function withdraw(address _to, uint256 _shares)
105         external
106         returns (uint256 withdrawn);
107 
108     function withdrawAll(address _to) external returns (uint256 withdrawn);
109 
110     function depositAll(address _to) external returns (uint256 _shares);
111 
112     function deposit(address _to, uint256 _amount)
113         external
114         returns (uint256 _shares);
115 
116     function harvest() external;
117 
118     function balanceOfUnderlying(address user)
119         external
120         view
121         returns (uint256 amount);
122 
123     function totalUnderlying() external view returns (uint256 total);
124 
125     function totalSupply() external view returns (uint256 total);
126 
127     function underlying() external view returns (address);
128 
129     function setPlatform(address _platform) external;
130 
131     function setPlatformFee(uint256 _fee) external;
132 
133     function setCallIncentive(uint256 _incentive) external;
134 
135     function setWithdrawalPenalty(uint256 _penalty) external;
136 
137     function setApprovals() external;
138 
139     function callIncentive() external view returns (uint256);
140 
141     function platformFee() external view returns (uint256);
142 
143     function platform() external view returns (address);
144 }
145 
146 // Part: IUniV2Router
147 
148 interface IUniV2Router {
149     function swapExactTokensForETH(
150         uint256 amountIn,
151         uint256 amountOutMin,
152         address[] calldata path,
153         address to,
154         uint256 deadline
155     ) external payable returns (uint256[] memory amounts);
156 
157     function swapExactETHForTokens(
158         uint256 amountOutMin,
159         address[] calldata path,
160         address to,
161         uint256 deadline
162     ) external payable returns (uint256[] memory amounts);
163 
164     function swapExactTokensForTokens(
165         uint256 amountIn,
166         uint256 amountOutMin,
167         address[] calldata path,
168         address to,
169         uint256 deadline
170     ) external returns (uint256[] memory amounts);
171 
172     function getAmountsOut(uint256 amountIn, address[] memory path)
173         external
174         view
175         returns (uint256[] memory amounts);
176 }
177 
178 // Part: IUniV3Router
179 
180 interface IUniV3Router {
181     struct ExactInputSingleParams {
182         address tokenIn;
183         address tokenOut;
184         uint24 fee;
185         address recipient;
186         uint256 deadline;
187         uint256 amountIn;
188         uint256 amountOutMinimum;
189         uint160 sqrtPriceLimitX96;
190     }
191 
192     function exactInputSingle(ExactInputSingleParams calldata params)
193         external
194         payable
195         returns (uint256 amountOut);
196 
197     struct ExactInputParams {
198         bytes path;
199         address recipient;
200         uint256 deadline;
201         uint256 amountIn;
202         uint256 amountOutMinimum;
203     }
204 
205     function exactInput(ExactInputParams calldata params)
206         external
207         payable
208         returns (uint256 amountOut);
209 }
210 
211 // Part: IWETH
212 
213 interface IWETH {
214     function deposit() external payable;
215 
216     function transfer(address to, uint256 value) external returns (bool);
217 
218     function withdraw(uint256) external;
219 }
220 
221 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Address
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      */
244     function isContract(address account) internal view returns (bool) {
245         // This method relies on extcodesize, which returns 0 for contracts in
246         // construction, since the code is only stored at the end of the
247         // constructor execution.
248 
249         uint256 size;
250         // solhint-disable-next-line no-inline-assembly
251         assembly { size := extcodesize(account) }
252         return size > 0;
253     }
254 
255     /**
256      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
257      * `recipient`, forwarding all available gas and reverting on errors.
258      *
259      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
260      * of certain opcodes, possibly making contracts go over the 2300 gas limit
261      * imposed by `transfer`, making them unable to receive funds via
262      * `transfer`. {sendValue} removes this limitation.
263      *
264      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
265      *
266      * IMPORTANT: because control is transferred to `recipient`, care must be
267      * taken to not create reentrancy vulnerabilities. Consider using
268      * {ReentrancyGuard} or the
269      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
270      */
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
275         (bool success, ) = recipient.call{ value: amount }("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain`call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298       return functionCall(target, data, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, 0, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but also transferring `value` wei to `target`.
314      *
315      * Requirements:
316      *
317      * - the calling contract must have an ETH balance of at least `value`.
318      * - the called Solidity function must be `payable`.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
328      * with `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
333         require(address(this).balance >= value, "Address: insufficient balance for call");
334         require(isContract(target), "Address: call to non-contract");
335 
336         // solhint-disable-next-line avoid-low-level-calls
337         (bool success, bytes memory returndata) = target.call{ value: value }(data);
338         return _verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
348         return functionStaticCall(target, data, "Address: low-level static call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
358         require(isContract(target), "Address: static call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.staticcall(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.delegatecall(data);
386         return _verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Context
410 
411 /*
412  * @dev Provides information about the current execution context, including the
413  * sender of the transaction and its data. While these are generally available
414  * via msg.sender and msg.data, they should not be accessed in such a direct
415  * manner, since when dealing with meta-transactions the account sending and
416  * paying for execution may not be the actual sender (as far as an application
417  * is concerned).
418  *
419  * This contract is only required for intermediate, library-like contracts.
420  */
421 abstract contract Context {
422     function _msgSender() internal view virtual returns (address) {
423         return msg.sender;
424     }
425 
426     function _msgData() internal view virtual returns (bytes calldata) {
427         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
428         return msg.data;
429     }
430 }
431 
432 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC20
433 
434 /**
435  * @dev Interface of the ERC20 standard as defined in the EIP.
436  */
437 interface IERC20 {
438     /**
439      * @dev Returns the amount of tokens in existence.
440      */
441     function totalSupply() external view returns (uint256);
442 
443     /**
444      * @dev Returns the amount of tokens owned by `account`.
445      */
446     function balanceOf(address account) external view returns (uint256);
447 
448     /**
449      * @dev Moves `amount` tokens from the caller's account to `recipient`.
450      *
451      * Returns a boolean value indicating whether the operation succeeded.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transfer(address recipient, uint256 amount) external returns (bool);
456 
457     /**
458      * @dev Returns the remaining number of tokens that `spender` will be
459      * allowed to spend on behalf of `owner` through {transferFrom}. This is
460      * zero by default.
461      *
462      * This value changes when {approve} or {transferFrom} are called.
463      */
464     function allowance(address owner, address spender) external view returns (uint256);
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
468      *
469      * Returns a boolean value indicating whether the operation succeeded.
470      *
471      * IMPORTANT: Beware that changing an allowance with this method brings the risk
472      * that someone may use both the old and the new allowance by unfortunate
473      * transaction ordering. One possible solution to mitigate this race
474      * condition is to first reduce the spender's allowance to 0 and set the
475      * desired value afterwards:
476      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address spender, uint256 amount) external returns (bool);
481 
482     /**
483      * @dev Moves `amount` tokens from `sender` to `recipient` using the
484      * allowance mechanism. `amount` is then deducted from the caller's
485      * allowance.
486      *
487      * Returns a boolean value indicating whether the operation succeeded.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
492 
493     /**
494      * @dev Emitted when `value` tokens are moved from one account (`from`) to
495      * another (`to`).
496      *
497      * Note that `value` may be zero.
498      */
499     event Transfer(address indexed from, address indexed to, uint256 value);
500 
501     /**
502      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
503      * a call to {approve}. `value` is the new allowance.
504      */
505     event Approval(address indexed owner, address indexed spender, uint256 value);
506 }
507 
508 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/ReentrancyGuard
509 
510 /**
511  * @dev Contract module that helps prevent reentrant calls to a function.
512  *
513  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
514  * available, which can be applied to functions to make sure there are no nested
515  * (reentrant) calls to them.
516  *
517  * Note that because there is a single `nonReentrant` guard, functions marked as
518  * `nonReentrant` may not call one another. This can be worked around by making
519  * those functions `private`, and then adding `external` `nonReentrant` entry
520  * points to them.
521  *
522  * TIP: If you would like to learn more about reentrancy and alternative ways
523  * to protect against it, check out our blog post
524  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
525  */
526 abstract contract ReentrancyGuard {
527     // Booleans are more expensive than uint256 or any type that takes up a full
528     // word because each write operation emits an extra SLOAD to first read the
529     // slot's contents, replace the bits taken up by the boolean, and then write
530     // back. This is the compiler's defense against contract upgrades and
531     // pointer aliasing, and it cannot be disabled.
532 
533     // The values being non-zero value makes deployment a bit more expensive,
534     // but in exchange the refund on every call to nonReentrant will be lower in
535     // amount. Since refunds are capped to a percentage of the total
536     // transaction's gas, it is best to keep them low in cases like this one, to
537     // increase the likelihood of the full refund coming into effect.
538     uint256 private constant _NOT_ENTERED = 1;
539     uint256 private constant _ENTERED = 2;
540 
541     uint256 private _status;
542 
543     constructor () {
544         _status = _NOT_ENTERED;
545     }
546 
547     /**
548      * @dev Prevents a contract from calling itself, directly or indirectly.
549      * Calling a `nonReentrant` function from another `nonReentrant`
550      * function is not supported. It is possible to prevent this from happening
551      * by making the `nonReentrant` function external, and make it call a
552      * `private` function that does the actual work.
553      */
554     modifier nonReentrant() {
555         // On the first call to nonReentrant, _notEntered will be true
556         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
557 
558         // Any calls to nonReentrant after this point will fail
559         _status = _ENTERED;
560 
561         _;
562 
563         // By storing the original value once again, a refund is triggered (see
564         // https://eips.ethereum.org/EIPS/eip-2200)
565         _status = _NOT_ENTERED;
566     }
567 }
568 
569 // Part: CvxFxsStrategyBase
570 
571 contract CvxFxsStrategyBase {
572     address public constant CVXFXS_STAKING_CONTRACT =
573         0xf27AFAD0142393e4b3E5510aBc5fe3743Ad669Cb;
574     address public constant CURVE_CRV_ETH_POOL =
575         0x8301AE4fc9c624d1D396cbDAa1ed877821D7C511;
576     address public constant CURVE_CVX_ETH_POOL =
577         0xB576491F1E6e5E62f1d8F26062Ee822B40B0E0d4;
578     address public constant CURVE_FXS_ETH_POOL =
579         0x941Eb6F616114e4Ecaa85377945EA306002612FE;
580     address public constant CURVE_CVXFXS_FXS_POOL =
581         0xd658A338613198204DCa1143Ac3F01A722b5d94A;
582     address public constant UNISWAP_ROUTER =
583         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
584     address public constant UNIV3_ROUTER =
585         0xE592427A0AEce92De3Edee1F18E0157C05861564;
586 
587     address public constant CRV_TOKEN =
588         0xD533a949740bb3306d119CC777fa900bA034cd52;
589     address public constant CVXFXS_TOKEN =
590         0xFEEf77d3f69374f66429C91d732A244f074bdf74;
591     address public constant FXS_TOKEN =
592         0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0;
593     address public constant CVX_TOKEN =
594         0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B;
595     address public constant WETH_TOKEN =
596         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
597     address public constant CURVE_CVXFXS_FXS_LP_TOKEN =
598         0xF3A43307DcAFa93275993862Aae628fCB50dC768;
599     address public constant USDT_TOKEN =
600         0xdAC17F958D2ee523a2206206994597C13D831ec7;
601     address public constant USDC_TOKEN =
602         0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
603     address public constant FRAX_TOKEN =
604         0x853d955aCEf822Db058eb8505911ED77F175b99e;
605 
606     uint256 public constant CRVETH_ETH_INDEX = 0;
607     uint256 public constant CRVETH_CRV_INDEX = 1;
608     uint256 public constant CVXETH_ETH_INDEX = 0;
609     uint256 public constant CVXETH_CVX_INDEX = 1;
610 
611     // The swap strategy to use when going eth -> fxs
612     enum SwapOption {
613         Curve,
614         Uniswap,
615         Unistables
616     }
617     SwapOption public swapOption = SwapOption.Curve;
618     event OptionChanged(SwapOption oldOption, SwapOption newOption);
619 
620     IBasicRewards cvxFxsStaking = IBasicRewards(CVXFXS_STAKING_CONTRACT);
621     ICurveV2Pool cvxEthSwap = ICurveV2Pool(CURVE_CVX_ETH_POOL);
622 
623     ICurveV2Pool crvEthSwap = ICurveV2Pool(CURVE_CRV_ETH_POOL);
624     ICurveV2Pool fxsEthSwap = ICurveV2Pool(CURVE_FXS_ETH_POOL);
625     ICurveV2Pool cvxFxsFxsSwap = ICurveV2Pool(CURVE_CVXFXS_FXS_POOL);
626 
627     /// @notice Swap CRV for native ETH on Curve
628     /// @param amount - amount to swap
629     /// @return amount of ETH obtained after the swap
630     function _swapCrvToEth(uint256 amount) internal returns (uint256) {
631         return _crvToEth(amount, 0);
632     }
633 
634     /// @notice Swap CRV for native ETH on Curve
635     /// @param amount - amount to swap
636     /// @param minAmountOut - minimum expected amount of output tokens
637     /// @return amount of ETH obtained after the swap
638     function _swapCrvToEth(uint256 amount, uint256 minAmountOut)
639         internal
640         returns (uint256)
641     {
642         return _crvToEth(amount, minAmountOut);
643     }
644 
645     /// @notice Swap CRV for native ETH on Curve
646     /// @param amount - amount to swap
647     /// @param minAmountOut - minimum expected amount of output tokens
648     /// @return amount of ETH obtained after the swap
649     function _crvToEth(uint256 amount, uint256 minAmountOut)
650         internal
651         returns (uint256)
652     {
653         return
654             crvEthSwap.exchange_underlying{value: 0}(
655                 CRVETH_CRV_INDEX,
656                 CRVETH_ETH_INDEX,
657                 amount,
658                 minAmountOut
659             );
660     }
661 
662     /// @notice Swap native ETH for CRV on Curve
663     /// @param amount - amount to swap
664     /// @return amount of CRV obtained after the swap
665     function _swapEthToCrv(uint256 amount) internal returns (uint256) {
666         return _ethToCrv(amount, 0);
667     }
668 
669     /// @notice Swap native ETH for CRV on Curve
670     /// @param amount - amount to swap
671     /// @param minAmountOut - minimum expected amount of output tokens
672     /// @return amount of CRV obtained after the swap
673     function _swapEthToCrv(uint256 amount, uint256 minAmountOut)
674         internal
675         returns (uint256)
676     {
677         return _ethToCrv(amount, minAmountOut);
678     }
679 
680     /// @notice Swap native ETH for CRV on Curve
681     /// @param amount - amount to swap
682     /// @param minAmountOut - minimum expected amount of output tokens
683     /// @return amount of CRV obtained after the swap
684     function _ethToCrv(uint256 amount, uint256 minAmountOut)
685         internal
686         returns (uint256)
687     {
688         return
689             crvEthSwap.exchange_underlying{value: amount}(
690                 CRVETH_ETH_INDEX,
691                 CRVETH_CRV_INDEX,
692                 amount,
693                 minAmountOut
694             );
695     }
696 
697     /// @notice Swap native ETH for CVX on Curve
698     /// @param amount - amount to swap
699     /// @return amount of CVX obtained after the swap
700     function _swapEthToCvx(uint256 amount) internal returns (uint256) {
701         return _ethToCvx(amount, 0);
702     }
703 
704     /// @notice Swap native ETH for CVX on Curve
705     /// @param amount - amount to swap
706     /// @param minAmountOut - minimum expected amount of output tokens
707     /// @return amount of CVX obtained after the swap
708     function _swapEthToCvx(uint256 amount, uint256 minAmountOut)
709         internal
710         returns (uint256)
711     {
712         return _ethToCvx(amount, minAmountOut);
713     }
714 
715     /// @notice Swap CVX for native ETH on Curve
716     /// @param amount - amount to swap
717     /// @return amount of ETH obtained after the swap
718     function _swapCvxToEth(uint256 amount) internal returns (uint256) {
719         return _cvxToEth(amount, 0);
720     }
721 
722     /// @notice Swap CVX for native ETH on Curve
723     /// @param amount - amount to swap
724     /// @param minAmountOut - minimum expected amount of output tokens
725     /// @return amount of ETH obtained after the swap
726     function _swapCvxToEth(uint256 amount, uint256 minAmountOut)
727         internal
728         returns (uint256)
729     {
730         return _cvxToEth(amount, minAmountOut);
731     }
732 
733     /// @notice Swap native ETH for CVX on Curve
734     /// @param amount - amount to swap
735     /// @param minAmountOut - minimum expected amount of output tokens
736     /// @return amount of CVX obtained after the swap
737     function _ethToCvx(uint256 amount, uint256 minAmountOut)
738         internal
739         returns (uint256)
740     {
741         return
742             cvxEthSwap.exchange_underlying{value: amount}(
743                 CVXETH_ETH_INDEX,
744                 CVXETH_CVX_INDEX,
745                 amount,
746                 minAmountOut
747             );
748     }
749 
750     /// @notice Swap native CVX for ETH on Curve
751     /// @param amount - amount to swap
752     /// @param minAmountOut - minimum expected amount of output tokens
753     /// @return amount of ETH obtained after the swap
754     function _cvxToEth(uint256 amount, uint256 minAmountOut)
755         internal
756         returns (uint256)
757     {
758         return
759             cvxEthSwap.exchange_underlying{value: 0}(
760                 1,
761                 0,
762                 amount,
763                 minAmountOut
764             );
765     }
766 
767     /// @notice Swap native ETH for FXS via different routes
768     /// @param _ethAmount - amount to swap
769     /// @param _option - the option to use when swapping
770     /// @return amount of FXS obtained after the swap
771     function _swapEthForFxs(uint256 _ethAmount, SwapOption _option)
772         internal
773         returns (uint256)
774     {
775         return _swapEthFxs(_ethAmount, _option, true);
776     }
777 
778     /// @notice Swap FXS for native ETH via different routes
779     /// @param _fxsAmount - amount to swap
780     /// @param _option - the option to use when swapping
781     /// @return amount of ETH obtained after the swap
782     function _swapFxsForEth(uint256 _fxsAmount, SwapOption _option)
783         internal
784         returns (uint256)
785     {
786         return _swapEthFxs(_fxsAmount, _option, false);
787     }
788 
789     /// @notice Swap ETH<->FXS on Curve
790     /// @param _amount - amount to swap
791     /// @param _ethToFxs - whether to swap from eth to fxs or the inverse
792     /// @return amount of token obtained after the swap
793     function _curveEthFxsSwap(uint256 _amount, bool _ethToFxs)
794         internal
795         returns (uint256)
796     {
797         return
798             fxsEthSwap.exchange_underlying{value: _ethToFxs ? _amount : 0}(
799                 _ethToFxs ? 0 : 1,
800                 _ethToFxs ? 1 : 0,
801                 _amount,
802                 0
803             );
804     }
805 
806     /// @notice Swap ETH<->FXS on UniV3 FXSETH pool
807     /// @param _amount - amount to swap
808     /// @param _ethToFxs - whether to swap from eth to fxs or the inverse
809     /// @return amount of token obtained after the swap
810     function _uniV3EthFxsSwap(uint256 _amount, bool _ethToFxs)
811         internal
812         returns (uint256)
813     {
814         IUniV3Router.ExactInputSingleParams memory _params = IUniV3Router
815             .ExactInputSingleParams(
816                 _ethToFxs ? WETH_TOKEN : FXS_TOKEN,
817                 _ethToFxs ? FXS_TOKEN : WETH_TOKEN,
818                 10000,
819                 address(this),
820                 block.timestamp + 1,
821                 _amount,
822                 1,
823                 0
824             );
825 
826         uint256 _receivedAmount = IUniV3Router(UNIV3_ROUTER).exactInputSingle{
827             value: _ethToFxs ? _amount : 0
828         }(_params);
829         if (!_ethToFxs) {
830             IWETH(WETH_TOKEN).withdraw(_receivedAmount);
831         }
832         return _receivedAmount;
833     }
834 
835     /// @notice Swap ETH->FXS on UniV3 via stable pair
836     /// @param _amount - amount to swap
837     /// @return amount of token obtained after the swap
838     function _uniStableEthToFxsSwap(uint256 _amount)
839         internal
840         returns (uint256)
841     {
842         uint24 fee = 500;
843         IUniV3Router.ExactInputParams memory _params = IUniV3Router
844             .ExactInputParams(
845                 abi.encodePacked(WETH_TOKEN, fee, USDC_TOKEN, fee, FRAX_TOKEN),
846                 address(this),
847                 block.timestamp + 1,
848                 _amount,
849                 0
850             );
851 
852         uint256 _fraxAmount = IUniV3Router(UNIV3_ROUTER).exactInput{
853             value: _amount
854         }(_params);
855         address[] memory _path = new address[](2);
856         _path[0] = FRAX_TOKEN;
857         _path[1] = FXS_TOKEN;
858         uint256[] memory amounts = IUniV2Router(UNISWAP_ROUTER)
859             .swapExactTokensForTokens(
860                 _fraxAmount,
861                 1,
862                 _path,
863                 address(this),
864                 block.timestamp + 1
865             );
866         return amounts[1];
867     }
868 
869     /// @notice Swap FXS->ETH on UniV3 via stable pair
870     /// @param _amount - amount to swap
871     /// @return amount of token obtained after the swap
872     function _uniStableFxsToEthSwap(uint256 _amount)
873         internal
874         returns (uint256)
875     {
876         address[] memory _path = new address[](2);
877         _path[0] = FXS_TOKEN;
878         _path[1] = FRAX_TOKEN;
879         uint256[] memory amounts = IUniV2Router(UNISWAP_ROUTER)
880             .swapExactTokensForTokens(
881                 _amount,
882                 1,
883                 _path,
884                 address(this),
885                 block.timestamp + 1
886             );
887 
888         uint256 _fraxAmount = amounts[1];
889         uint24 fee = 500;
890 
891         IUniV3Router.ExactInputParams memory _params = IUniV3Router
892             .ExactInputParams(
893                 abi.encodePacked(FRAX_TOKEN, fee, USDC_TOKEN, fee, WETH_TOKEN),
894                 address(this),
895                 block.timestamp + 1,
896                 _fraxAmount,
897                 0
898             );
899 
900         uint256 _ethAmount = IUniV3Router(UNIV3_ROUTER).exactInput{value: 0}(
901             _params
902         );
903         IWETH(WETH_TOKEN).withdraw(_ethAmount);
904         return _ethAmount;
905     }
906 
907     /// @notice Swap native ETH for FXS via different routes
908     /// @param _amount - amount to swap
909     /// @param _option - the option to use when swapping
910     /// @param _ethToFxs - whether to swap from eth to fxs or the inverse
911     /// @return amount of token obtained after the swap
912     function _swapEthFxs(
913         uint256 _amount,
914         SwapOption _option,
915         bool _ethToFxs
916     ) internal returns (uint256) {
917         if (_option == SwapOption.Curve) {
918             return _curveEthFxsSwap(_amount, _ethToFxs);
919         } else if (_option == SwapOption.Uniswap) {
920             return _uniV3EthFxsSwap(_amount, _ethToFxs);
921         } else {
922             return
923                 _ethToFxs
924                     ? _uniStableEthToFxsSwap(_amount)
925                     : _uniStableFxsToEthSwap(_amount);
926         }
927     }
928 
929     receive() external payable {}
930 }
931 
932 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Ownable
933 
934 /**
935  * @dev Contract module which provides a basic access control mechanism, where
936  * there is an account (an owner) that can be granted exclusive access to
937  * specific functions.
938  *
939  * By default, the owner account will be the one that deploys the contract. This
940  * can later be changed with {transferOwnership}.
941  *
942  * This module is used through inheritance. It will make available the modifier
943  * `onlyOwner`, which can be applied to your functions to restrict their use to
944  * the owner.
945  */
946 abstract contract Ownable is Context {
947     address private _owner;
948 
949     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
950 
951     /**
952      * @dev Initializes the contract setting the deployer as the initial owner.
953      */
954     constructor () {
955         address msgSender = _msgSender();
956         _owner = msgSender;
957         emit OwnershipTransferred(address(0), msgSender);
958     }
959 
960     /**
961      * @dev Returns the address of the current owner.
962      */
963     function owner() public view virtual returns (address) {
964         return _owner;
965     }
966 
967     /**
968      * @dev Throws if called by any account other than the owner.
969      */
970     modifier onlyOwner() {
971         require(owner() == _msgSender(), "Ownable: caller is not the owner");
972         _;
973     }
974 
975     /**
976      * @dev Leaves the contract without owner. It will not be possible to call
977      * `onlyOwner` functions anymore. Can only be called by the current owner.
978      *
979      * NOTE: Renouncing ownership will leave the contract without an owner,
980      * thereby removing any functionality that is only available to the owner.
981      */
982     function renounceOwnership() public virtual onlyOwner {
983         emit OwnershipTransferred(_owner, address(0));
984         _owner = address(0);
985     }
986 
987     /**
988      * @dev Transfers ownership of the contract to a new account (`newOwner`).
989      * Can only be called by the current owner.
990      */
991     function transferOwnership(address newOwner) public virtual onlyOwner {
992         require(newOwner != address(0), "Ownable: new owner is the zero address");
993         emit OwnershipTransferred(_owner, newOwner);
994         _owner = newOwner;
995     }
996 }
997 
998 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/SafeERC20
999 
1000 /**
1001  * @title SafeERC20
1002  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1003  * contract returns false). Tokens that return no value (and instead revert or
1004  * throw on failure) are also supported, non-reverting calls are assumed to be
1005  * successful.
1006  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1007  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1008  */
1009 library SafeERC20 {
1010     using Address for address;
1011 
1012     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1013         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1014     }
1015 
1016     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1017         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1018     }
1019 
1020     /**
1021      * @dev Deprecated. This function has issues similar to the ones found in
1022      * {IERC20-approve}, and its usage is discouraged.
1023      *
1024      * Whenever possible, use {safeIncreaseAllowance} and
1025      * {safeDecreaseAllowance} instead.
1026      */
1027     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1028         // safeApprove should only be called when setting an initial allowance,
1029         // or when resetting it to zero. To increase and decrease it, use
1030         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1031         // solhint-disable-next-line max-line-length
1032         require((value == 0) || (token.allowance(address(this), spender) == 0),
1033             "SafeERC20: approve from non-zero to non-zero allowance"
1034         );
1035         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1036     }
1037 
1038     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1039         uint256 newAllowance = token.allowance(address(this), spender) + value;
1040         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1041     }
1042 
1043     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1044         unchecked {
1045             uint256 oldAllowance = token.allowance(address(this), spender);
1046             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1047             uint256 newAllowance = oldAllowance - value;
1048             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1049         }
1050     }
1051 
1052     /**
1053      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1054      * on the return value: the return value is optional (but if data is returned, it must not be false).
1055      * @param token The token targeted by the call.
1056      * @param data The call data (encoded using abi.encode or one of its variants).
1057      */
1058     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1059         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1060         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1061         // the target address contains contract code and also asserts for success in the low-level call.
1062 
1063         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1064         if (returndata.length > 0) { // Return data is optional
1065             // solhint-disable-next-line max-line-length
1066             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1067         }
1068     }
1069 }
1070 
1071 // File: StrategyZaps.sol
1072 
1073 contract CvxFxsZaps is Ownable, CvxFxsStrategyBase, ReentrancyGuard {
1074     using SafeERC20 for IERC20;
1075 
1076     address public immutable vault;
1077 
1078     address private constant CONVEX_LOCKER =
1079         0x72a19342e8F1838460eBFCCEf09F6585e32db86E;
1080     address private constant TRICRYPTO =
1081         0xD51a44d3FaE010294C616388b506AcdA1bfAAE46;
1082     ICurveTriCrypto triCryptoSwap = ICurveTriCrypto(TRICRYPTO);
1083     ICVXLocker locker = ICVXLocker(CONVEX_LOCKER);
1084 
1085     constructor(address _vault) {
1086         vault = _vault;
1087     }
1088 
1089     /// @notice Change the default swap option for eth -> fxs
1090     /// @param _newOption - the new option to use
1091     function setSwapOption(SwapOption _newOption) external onlyOwner {
1092         SwapOption _oldOption = swapOption;
1093         swapOption = _newOption;
1094         emit OptionChanged(_oldOption, swapOption);
1095     }
1096 
1097     /// @notice Set approvals for the contracts used when swapping & staking
1098     function setApprovals() external {
1099         IERC20(CURVE_CVXFXS_FXS_LP_TOKEN).safeApprove(vault, 0);
1100         IERC20(CURVE_CVXFXS_FXS_LP_TOKEN).safeApprove(vault, type(uint256).max);
1101 
1102         IERC20(CVX_TOKEN).safeApprove(CURVE_CVX_ETH_POOL, 0);
1103         IERC20(CVX_TOKEN).safeApprove(CURVE_CVX_ETH_POOL, type(uint256).max);
1104 
1105         IERC20(FXS_TOKEN).safeApprove(CURVE_CVXFXS_FXS_POOL, 0);
1106         IERC20(FXS_TOKEN).safeApprove(CURVE_CVXFXS_FXS_POOL, type(uint256).max);
1107 
1108         IERC20(FXS_TOKEN).safeApprove(CURVE_FXS_ETH_POOL, 0);
1109         IERC20(FXS_TOKEN).safeApprove(CURVE_FXS_ETH_POOL, type(uint256).max);
1110 
1111         IERC20(FXS_TOKEN).safeApprove(UNISWAP_ROUTER, 0);
1112         IERC20(FXS_TOKEN).safeApprove(UNISWAP_ROUTER, type(uint256).max);
1113 
1114         IERC20(FXS_TOKEN).safeApprove(UNIV3_ROUTER, 0);
1115         IERC20(FXS_TOKEN).safeApprove(UNIV3_ROUTER, type(uint256).max);
1116 
1117         IERC20(FRAX_TOKEN).safeApprove(UNIV3_ROUTER, 0);
1118         IERC20(FRAX_TOKEN).safeApprove(UNIV3_ROUTER, type(uint256).max);
1119 
1120         IERC20(CVXFXS_TOKEN).safeApprove(CURVE_CVXFXS_FXS_POOL, 0);
1121         IERC20(CVXFXS_TOKEN).safeApprove(
1122             CURVE_CVXFXS_FXS_POOL,
1123             type(uint256).max
1124         );
1125 
1126         IERC20(CVX_TOKEN).safeApprove(CONVEX_LOCKER, 0);
1127         IERC20(CVX_TOKEN).safeApprove(CONVEX_LOCKER, type(uint256).max);
1128 
1129         IERC20(FRAX_TOKEN).safeApprove(UNISWAP_ROUTER, 0);
1130         IERC20(FRAX_TOKEN).safeApprove(UNISWAP_ROUTER, type(uint256).max);
1131 
1132         IERC20(CRV_TOKEN).safeApprove(CURVE_CRV_ETH_POOL, 0);
1133         IERC20(CRV_TOKEN).safeApprove(CURVE_CRV_ETH_POOL, type(uint256).max);
1134     }
1135 
1136     /// @notice Deposit from FXS and/or cvxFXS
1137     /// @param amounts - the amounts of FXS and cvxFXS to deposit respectively
1138     /// @param minAmountOut - min amount of LP tokens expected
1139     /// @param to - address to stake on behalf of
1140     function depositFromUnderlyingAssets(
1141         uint256[2] calldata amounts,
1142         uint256 minAmountOut,
1143         address to
1144     ) external notToZeroAddress(to) {
1145         if (amounts[0] > 0) {
1146             IERC20(FXS_TOKEN).safeTransferFrom(
1147                 msg.sender,
1148                 address(this),
1149                 amounts[0]
1150             );
1151         }
1152         if (amounts[1] > 0) {
1153             IERC20(CVXFXS_TOKEN).safeTransferFrom(
1154                 msg.sender,
1155                 address(this),
1156                 amounts[1]
1157             );
1158         }
1159         _addAndDeposit(amounts, minAmountOut, to);
1160     }
1161 
1162     function _addAndDeposit(
1163         uint256[2] memory amounts,
1164         uint256 minAmountOut,
1165         address to
1166     ) internal {
1167         cvxFxsFxsSwap.add_liquidity(amounts, minAmountOut);
1168         IGenericVault(vault).depositAll(to);
1169     }
1170 
1171     /// @notice Deposit from FXS LP tokens, CRV and/or CVX
1172     /// @dev Used for users migrating their FXS + rewards from Convex
1173     /// @param lpTokenAmount - amount of FXS-cvxFXS LP Token from Curve
1174     /// @param crvAmount - amount of CRV to deposit
1175     /// @param cvxAmount - amount of CVX to deposit
1176     /// @param minAmountOut - minimum amount of LP Tokens after swapping CRV+CVX
1177     /// @param to - address to stake on behalf of
1178     function depositWithRewards(
1179         uint256 lpTokenAmount,
1180         uint256 crvAmount,
1181         uint256 cvxAmount,
1182         uint256 minAmountOut,
1183         address to
1184     ) external notToZeroAddress(to) {
1185         require(lpTokenAmount + crvAmount + cvxAmount > 0, "cheap");
1186         if (lpTokenAmount > 0) {
1187             IERC20(CURVE_CVXFXS_FXS_LP_TOKEN).safeTransferFrom(
1188                 msg.sender,
1189                 address(this),
1190                 lpTokenAmount
1191             );
1192         }
1193         if (crvAmount > 0) {
1194             IERC20(CRV_TOKEN).safeTransferFrom(
1195                 msg.sender,
1196                 address(this),
1197                 crvAmount
1198             );
1199             _swapCrvToEth(crvAmount);
1200         }
1201         if (cvxAmount > 0) {
1202             IERC20(CVX_TOKEN).safeTransferFrom(
1203                 msg.sender,
1204                 address(this),
1205                 cvxAmount
1206             );
1207             _swapCvxToEth(cvxAmount);
1208         }
1209         if (address(this).balance > 0) {
1210             uint256 fxsBalance = _swapEthForFxs(
1211                 address(this).balance,
1212                 swapOption
1213             );
1214             cvxFxsFxsSwap.add_liquidity([fxsBalance, 0], minAmountOut);
1215         }
1216         IGenericVault(vault).depositAll(to);
1217     }
1218 
1219     /// @notice Deposit into the pounder from ETH
1220     /// @param minAmountOut - min amount of lp tokens expected
1221     /// @param to - address to stake on behalf of
1222     function depositFromEth(uint256 minAmountOut, address to)
1223         external
1224         payable
1225         notToZeroAddress(to)
1226     {
1227         require(msg.value > 0, "cheap");
1228         _depositFromEth(msg.value, minAmountOut, to);
1229     }
1230 
1231     /// @notice Internal function to deposit ETH to the pounder
1232     /// @param amount - amount of ETH
1233     /// @param minAmountOut - min amount of lp tokens expected
1234     /// @param to - address to stake on behalf of
1235     function _depositFromEth(
1236         uint256 amount,
1237         uint256 minAmountOut,
1238         address to
1239     ) internal {
1240         uint256 fxsBalance = _swapEthForFxs(amount, swapOption);
1241         _addAndDeposit([fxsBalance, 0], minAmountOut, to);
1242     }
1243 
1244     /// @notice Deposit into the pounder from any token via Uni interface
1245     /// @notice Use at your own risk
1246     /// @dev Zap contract needs approval for spending of inputToken
1247     /// @param amount - min amount of input token
1248     /// @param minAmountOut - min amount of cvxCRV expected
1249     /// @param router - address of the router to use. e.g. 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F for Sushi
1250     /// @param inputToken - address of the token to swap from, needs to have an ETH pair on router used
1251     /// @param to - address to stake on behalf of
1252     function depositViaUniV2EthPair(
1253         uint256 amount,
1254         uint256 minAmountOut,
1255         address router,
1256         address inputToken,
1257         address to
1258     ) external notToZeroAddress(to) {
1259         require(router != address(0));
1260 
1261         IERC20(inputToken).safeTransferFrom(msg.sender, address(this), amount);
1262         address[] memory _path = new address[](2);
1263         _path[0] = inputToken;
1264         _path[1] = WETH_TOKEN;
1265 
1266         IERC20(inputToken).safeApprove(router, 0);
1267         IERC20(inputToken).safeApprove(router, amount);
1268 
1269         IUniV2Router(router).swapExactTokensForETH(
1270             amount,
1271             1,
1272             _path,
1273             address(this),
1274             block.timestamp + 1
1275         );
1276         _depositFromEth(address(this).balance, minAmountOut, to);
1277     }
1278 
1279     /// @notice Remove liquidity from the Curve pool for either asset
1280     /// @param _amount - amount to withdraw
1281     /// @param _assetIndex - asset to withdraw (0: FXS, 1: cvxFXS)
1282     /// @param _minAmountOut - minimum amount of LP tokens expected
1283     /// @param _to - address to send withdrawn underlying to
1284     /// @return amount of underlying withdrawn
1285     function _claimAsUnderlying(
1286         uint256 _amount,
1287         uint256 _assetIndex,
1288         uint256 _minAmountOut,
1289         address _to
1290     ) internal returns (uint256) {
1291         return
1292             cvxFxsFxsSwap.remove_liquidity_one_coin(
1293                 _amount,
1294                 _assetIndex,
1295                 _minAmountOut,
1296                 false,
1297                 _to
1298             );
1299     }
1300 
1301     /// @notice Retrieves a user's vault shares and withdraw all
1302     /// @param _amount - amount of shares to retrieve
1303     function _claimAndWithdraw(uint256 _amount) internal {
1304         IERC20(vault).safeTransferFrom(msg.sender, address(this), _amount);
1305         IGenericVault(vault).withdrawAll(address(this));
1306     }
1307 
1308     /// @notice Claim as either FXS or cvxFXS
1309     /// @param amount - amount to withdraw
1310     /// @param assetIndex - asset to withdraw (0: FXS, 1: cvxFXS)
1311     /// @param minAmountOut - minimum amount of underlying tokens expected
1312     /// @param to - address to send withdrawn underlying to
1313     /// @return amount of underlying withdrawn
1314     function claimFromVaultAsUnderlying(
1315         uint256 amount,
1316         uint256 assetIndex,
1317         uint256 minAmountOut,
1318         address to
1319     ) public notToZeroAddress(to) returns (uint256) {
1320         _claimAndWithdraw(amount);
1321         return
1322             _claimAsUnderlying(
1323                 IERC20(CURVE_CVXFXS_FXS_LP_TOKEN).balanceOf(address(this)),
1324                 assetIndex,
1325                 minAmountOut,
1326                 to
1327             );
1328     }
1329 
1330     /// @notice Claim as native ETH
1331     /// @param amount - amount to withdraw
1332     /// @param minAmountOut - minimum amount of ETH expected
1333     /// @param to - address to send ETH to
1334     /// @return amount of ETH withdrawn
1335     function claimFromVaultAsEth(
1336         uint256 amount,
1337         uint256 minAmountOut,
1338         address to
1339     ) public notToZeroAddress(to) returns (uint256) {
1340         uint256 _ethAmount = _claimAsEth(amount);
1341         require(_ethAmount >= minAmountOut, "Slippage");
1342         (bool success, ) = to.call{value: _ethAmount}("");
1343         require(success, "ETH transfer failed");
1344         return _ethAmount;
1345     }
1346 
1347     /// @notice Withdraw as native ETH (internal)
1348     /// @param amount - amount to withdraw
1349     /// @return amount of ETH withdrawn
1350     function _claimAsEth(uint256 amount) public nonReentrant returns (uint256) {
1351         _claimAndWithdraw(amount);
1352         uint256 _fxsAmount = _claimAsUnderlying(
1353             IERC20(CURVE_CVXFXS_FXS_LP_TOKEN).balanceOf(address(this)),
1354             0,
1355             0,
1356             address(this)
1357         );
1358         return _swapFxsForEth(_fxsAmount, swapOption);
1359     }
1360 
1361     /// @notice Claim to any token via a univ2 router
1362     /// @notice Use at your own risk
1363     /// @param amount - amount of uFXS to unstake
1364     /// @param minAmountOut - min amount of output token expected
1365     /// @param router - address of the router to use. e.g. 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F for Sushi
1366     /// @param outputToken - address of the token to swap to
1367     /// @param to - address of the final recipient of the swapped tokens
1368     function claimFromVaultViaUniV2EthPair(
1369         uint256 amount,
1370         uint256 minAmountOut,
1371         address router,
1372         address outputToken,
1373         address to
1374     ) public notToZeroAddress(to) {
1375         require(router != address(0));
1376         _claimAsEth(amount);
1377         address[] memory _path = new address[](2);
1378         _path[0] = WETH_TOKEN;
1379         _path[1] = outputToken;
1380         IUniV2Router(router).swapExactETHForTokens{
1381             value: address(this).balance
1382         }(minAmountOut, _path, to, block.timestamp + 1);
1383     }
1384 
1385     /// @notice Claim as USDT via Tricrypto
1386     /// @param amount - the amount of uFXS to unstake
1387     /// @param minAmountOut - the min expected amount of USDT to receive
1388     /// @param to - the adress that will receive the USDT
1389     /// @return amount of USDT obtained
1390     function claimFromVaultAsUsdt(
1391         uint256 amount,
1392         uint256 minAmountOut,
1393         address to
1394     ) public notToZeroAddress(to) returns (uint256) {
1395         uint256 _ethAmount = _claimAsEth(amount);
1396         _swapEthToUsdt(_ethAmount, minAmountOut);
1397         uint256 _usdtAmount = IERC20(USDT_TOKEN).balanceOf(address(this));
1398         IERC20(USDT_TOKEN).safeTransfer(to, _usdtAmount);
1399         return _usdtAmount;
1400     }
1401 
1402     /// @notice swap ETH to USDT via Curve's tricrypto
1403     /// @param _amount - the amount of ETH to swap
1404     /// @param _minAmountOut - the minimum amount expected
1405     function _swapEthToUsdt(uint256 _amount, uint256 _minAmountOut) internal {
1406         triCryptoSwap.exchange{value: _amount}(
1407             2, // ETH
1408             0, // USDT
1409             _amount,
1410             _minAmountOut,
1411             true
1412         );
1413     }
1414 
1415     /// @notice Claim as CVX via CurveCVX
1416     /// @param amount - the amount of uFXS to unstake
1417     /// @param minAmountOut - the min expected amount of USDT to receive
1418     /// @param to - the adress that will receive the CVX
1419     /// @param lock - whether to lock the CVX or not
1420     /// @return amount of CVX obtained
1421     function claimFromVaultAsCvx(
1422         uint256 amount,
1423         uint256 minAmountOut,
1424         address to,
1425         bool lock
1426     ) public notToZeroAddress(to) returns (uint256) {
1427         uint256 _ethAmount = _claimAsEth(amount);
1428         uint256 _cvxAmount = _swapEthToCvx(_ethAmount, minAmountOut);
1429         if (lock) {
1430             locker.lock(to, _cvxAmount, 0);
1431         } else {
1432             IERC20(CVX_TOKEN).safeTransfer(to, _cvxAmount);
1433         }
1434         return _cvxAmount;
1435     }
1436 
1437     modifier notToZeroAddress(address _to) {
1438         require(_to != address(0), "Invalid address!");
1439         _;
1440     }
1441 }
