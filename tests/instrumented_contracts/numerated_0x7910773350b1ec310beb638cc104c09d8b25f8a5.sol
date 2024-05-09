1 // File: contracts\sakeswap\interfaces\ISakeSwapRouter.sol
2 
3 // SPDX-License-Identifier: GPL-3.0
4 pragma solidity >=0.6.2;
5 
6 interface ISakeSwapRouter {
7     function factory() external pure returns (address);
8 
9     function WETH() external pure returns (address);
10 
11     function addLiquidity(
12         address tokenA,
13         address tokenB,
14         uint256 amountADesired,
15         uint256 amountBDesired,
16         uint256 amountAMin,
17         uint256 amountBMin,
18         address to,
19         uint256 deadline
20     )
21         external
22         returns (
23             uint256 amountA,
24             uint256 amountB,
25             uint256 liquidity
26         );
27 
28     function addLiquidityETH(
29         address token,
30         uint256 amountTokenDesired,
31         uint256 amountTokenMin,
32         uint256 amountETHMin,
33         address to,
34         uint256 deadline
35     )
36         external
37         payable
38         returns (
39             uint256 amountToken,
40             uint256 amountETH,
41             uint256 liquidity
42         );
43 
44     function removeLiquidity(
45         address tokenA,
46         address tokenB,
47         uint256 liquidity,
48         uint256 amountAMin,
49         uint256 amountBMin,
50         address to,
51         uint256 deadline
52     )
53         external
54         returns (
55             uint256 amountA,
56             uint256 amountB
57         );
58 
59     function removeLiquidityETH(
60         address token,
61         uint256 liquidity,
62         uint256 amountTokenMin,
63         uint256 amountETHMin,
64         address to,
65         uint256 deadline
66     )
67         external
68         returns (
69             uint256 amountToken,
70             uint256 amountETH
71         );
72 
73     function removeLiquidityWithPermit(
74         address tokenA,
75         address tokenB,
76         uint256 liquidity,
77         uint256 amountAMin,
78         uint256 amountBMin,
79         address to,
80         uint256 deadline,
81         bool approveMax,
82         uint8 v,
83         bytes32 r,
84         bytes32 s
85     )
86         external
87         returns (
88             uint256 amountA,
89             uint256 amountB
90         );
91 
92     function removeLiquidityETHWithPermit(
93         address token,
94         uint256 liquidity,
95         uint256 amountTokenMin,
96         uint256 amountETHMin,
97         address to,
98         uint256 deadline,
99         bool approveMax,
100         uint8 v,
101         bytes32 r,
102         bytes32 s
103     )
104         external
105         returns (
106             uint256 amountToken,
107             uint256 amountETH
108         );
109 
110     function swapExactTokensForTokens(
111         uint256 amountIn,
112         uint256 amountOutMin,
113         address[] calldata path,
114         address to,
115         uint256 deadline,
116         bool ifmint
117     ) external returns (uint256[] memory amounts);
118 
119     function swapTokensForExactTokens(
120         uint256 amountOut,
121         uint256 amountInMax,
122         address[] calldata path,
123         address to,
124         uint256 deadline,
125         bool ifmint
126     ) external returns (uint256[] memory amounts);
127 
128     function swapExactETHForTokens(
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline,
133         bool ifmint
134     ) external payable returns (uint256[] memory amounts);
135 
136     function swapTokensForExactETH(
137         uint256 amountOut,
138         uint256 amountInMax,
139         address[] calldata path,
140         address to,
141         uint256 deadline,
142         bool ifmint
143     ) external returns (uint256[] memory amounts);
144 
145     function swapExactTokensForETH(
146         uint256 amountIn,
147         uint256 amountOutMin,
148         address[] calldata path,
149         address to,
150         uint256 deadline,
151         bool ifmint
152     ) external returns (uint256[] memory amounts);
153 
154     function swapETHForExactTokens(
155         uint256 amountOut,
156         address[] calldata path,
157         address to,
158         uint256 deadline,
159         bool ifmint
160     ) external payable returns (uint256[] memory amounts);
161 
162     function quote(
163         uint256 amountA,
164         uint256 reserveA,
165         uint256 reserveB
166     ) external pure returns (uint256 amountB);
167 
168     function getAmountOut(
169         uint256 amountIn,
170         uint256 reserveIn,
171         uint256 reserveOut
172     ) external pure returns (uint256 amountOut);
173 
174     function getAmountIn(
175         uint256 amountOut,
176         uint256 reserveIn,
177         uint256 reserveOut
178     ) external pure returns (uint256 amountIn);
179 
180     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
181 
182     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
183 
184     function removeLiquidityETHSupportingFeeOnTransferTokens(
185         address token,
186         uint256 liquidity,
187         uint256 amountTokenMin,
188         uint256 amountETHMin,
189         address to,
190         uint256 deadline
191     ) external returns (uint256 amountETH);
192 
193     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
194         address token,
195         uint256 liquidity,
196         uint256 amountTokenMin,
197         uint256 amountETHMin,
198         address to,
199         uint256 deadline,
200         bool approveMax,
201         uint8 v,
202         bytes32 r,
203         bytes32 s
204     ) external returns (uint256 amountETH);
205 
206     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
207         uint256 amountIn,
208         uint256 amountOutMin,
209         address[] calldata path,
210         address to,
211         uint256 deadline,
212         bool ifmint
213     ) external;
214 
215     function swapExactETHForTokensSupportingFeeOnTransferTokens(
216         uint256 amountOutMin,
217         address[] calldata path,
218         address to,
219         uint256 deadline,
220         bool ifmint
221     ) external payable;
222 
223     function swapExactTokensForETHSupportingFeeOnTransferTokens(
224         uint256 amountIn,
225         uint256 amountOutMin,
226         address[] calldata path,
227         address to,
228         uint256 deadline,
229         bool ifmint
230     ) external;
231 }
232 
233 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
234 
235 pragma solidity ^0.6.0;
236 
237 /**
238  * @dev Interface of the ERC20 standard as defined in the EIP.
239  */
240 interface IERC20 {
241     /**
242      * @dev Returns the amount of tokens in existence.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns the amount of tokens owned by `account`.
248      */
249     function balanceOf(address account) external view returns (uint256);
250 
251     /**
252      * @dev Moves `amount` tokens from the caller's account to `recipient`.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transfer(address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Returns the remaining number of tokens that `spender` will be
262      * allowed to spend on behalf of `owner` through {transferFrom}. This is
263      * zero by default.
264      *
265      * This value changes when {approve} or {transferFrom} are called.
266      */
267     function allowance(address owner, address spender) external view returns (uint256);
268 
269     /**
270      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * IMPORTANT: Beware that changing an allowance with this method brings the risk
275      * that someone may use both the old and the new allowance by unfortunate
276      * transaction ordering. One possible solution to mitigate this race
277      * condition is to first reduce the spender's allowance to 0 and set the
278      * desired value afterwards:
279      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address spender, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Moves `amount` tokens from `sender` to `recipient` using the
287      * allowance mechanism. `amount` is then deducted from the caller's
288      * allowance.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Emitted when `value` tokens are moved from one account (`from`) to
298      * another (`to`).
299      *
300      * Note that `value` may be zero.
301      */
302     event Transfer(address indexed from, address indexed to, uint256 value);
303 
304     /**
305      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
306      * a call to {approve}. `value` is the new allowance.
307      */
308     event Approval(address indexed owner, address indexed spender, uint256 value);
309 }
310 
311 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
312 
313 pragma solidity ^0.6.0;
314 
315 /**
316  * @dev Wrappers over Solidity's arithmetic operations with added overflow
317  * checks.
318  *
319  * Arithmetic operations in Solidity wrap on overflow. This can easily result
320  * in bugs, because programmers usually assume that an overflow raises an
321  * error, which is the standard behavior in high level programming languages.
322  * `SafeMath` restores this intuition by reverting the transaction when an
323  * operation overflows.
324  *
325  * Using this library instead of the unchecked operations eliminates an entire
326  * class of bugs, so it's recommended to use it always.
327  */
328 library SafeMath {
329     /**
330      * @dev Returns the addition of two unsigned integers, reverting on
331      * overflow.
332      *
333      * Counterpart to Solidity's `+` operator.
334      *
335      * Requirements:
336      *
337      * - Addition cannot overflow.
338      */
339     function add(uint256 a, uint256 b) internal pure returns (uint256) {
340         uint256 c = a + b;
341         require(c >= a, "SafeMath: addition overflow");
342 
343         return c;
344     }
345 
346     /**
347      * @dev Returns the subtraction of two unsigned integers, reverting on
348      * overflow (when the result is negative).
349      *
350      * Counterpart to Solidity's `-` operator.
351      *
352      * Requirements:
353      *
354      * - Subtraction cannot overflow.
355      */
356     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
357         return sub(a, b, "SafeMath: subtraction overflow");
358     }
359 
360     /**
361      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
362      * overflow (when the result is negative).
363      *
364      * Counterpart to Solidity's `-` operator.
365      *
366      * Requirements:
367      *
368      * - Subtraction cannot overflow.
369      */
370     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
371         require(b <= a, errorMessage);
372         uint256 c = a - b;
373 
374         return c;
375     }
376 
377     /**
378      * @dev Returns the multiplication of two unsigned integers, reverting on
379      * overflow.
380      *
381      * Counterpart to Solidity's `*` operator.
382      *
383      * Requirements:
384      *
385      * - Multiplication cannot overflow.
386      */
387     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
388         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
389         // benefit is lost if 'b' is also tested.
390         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
391         if (a == 0) {
392             return 0;
393         }
394 
395         uint256 c = a * b;
396         require(c / a == b, "SafeMath: multiplication overflow");
397 
398         return c;
399     }
400 
401     /**
402      * @dev Returns the integer division of two unsigned integers. Reverts on
403      * division by zero. The result is rounded towards zero.
404      *
405      * Counterpart to Solidity's `/` operator. Note: this function uses a
406      * `revert` opcode (which leaves remaining gas untouched) while Solidity
407      * uses an invalid opcode to revert (consuming all remaining gas).
408      *
409      * Requirements:
410      *
411      * - The divisor cannot be zero.
412      */
413     function div(uint256 a, uint256 b) internal pure returns (uint256) {
414         return div(a, b, "SafeMath: division by zero");
415     }
416 
417     /**
418      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
419      * division by zero. The result is rounded towards zero.
420      *
421      * Counterpart to Solidity's `/` operator. Note: this function uses a
422      * `revert` opcode (which leaves remaining gas untouched) while Solidity
423      * uses an invalid opcode to revert (consuming all remaining gas).
424      *
425      * Requirements:
426      *
427      * - The divisor cannot be zero.
428      */
429     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
430         require(b > 0, errorMessage);
431         uint256 c = a / b;
432         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
433 
434         return c;
435     }
436 
437     /**
438      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
439      * Reverts when dividing by zero.
440      *
441      * Counterpart to Solidity's `%` operator. This function uses a `revert`
442      * opcode (which leaves remaining gas untouched) while Solidity uses an
443      * invalid opcode to revert (consuming all remaining gas).
444      *
445      * Requirements:
446      *
447      * - The divisor cannot be zero.
448      */
449     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
450         return mod(a, b, "SafeMath: modulo by zero");
451     }
452 
453     /**
454      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
455      * Reverts with custom message when dividing by zero.
456      *
457      * Counterpart to Solidity's `%` operator. This function uses a `revert`
458      * opcode (which leaves remaining gas untouched) while Solidity uses an
459      * invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      *
463      * - The divisor cannot be zero.
464      */
465     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
466         require(b != 0, errorMessage);
467         return a % b;
468     }
469 }
470 
471 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
472 
473 pragma solidity ^0.6.2;
474 
475 /**
476  * @dev Collection of functions related to the address type
477  */
478 library Address {
479     /**
480      * @dev Returns true if `account` is a contract.
481      *
482      * [IMPORTANT]
483      * ====
484      * It is unsafe to assume that an address for which this function returns
485      * false is an externally-owned account (EOA) and not a contract.
486      *
487      * Among others, `isContract` will return false for the following
488      * types of addresses:
489      *
490      *  - an externally-owned account
491      *  - a contract in construction
492      *  - an address where a contract will be created
493      *  - an address where a contract lived, but was destroyed
494      * ====
495      */
496     function isContract(address account) internal view returns (bool) {
497         // This method relies in extcodesize, which returns 0 for contracts in
498         // construction, since the code is only stored at the end of the
499         // constructor execution.
500 
501         uint256 size;
502         // solhint-disable-next-line no-inline-assembly
503         assembly { size := extcodesize(account) }
504         return size > 0;
505     }
506 
507     /**
508      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
509      * `recipient`, forwarding all available gas and reverting on errors.
510      *
511      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
512      * of certain opcodes, possibly making contracts go over the 2300 gas limit
513      * imposed by `transfer`, making them unable to receive funds via
514      * `transfer`. {sendValue} removes this limitation.
515      *
516      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
517      *
518      * IMPORTANT: because control is transferred to `recipient`, care must be
519      * taken to not create reentrancy vulnerabilities. Consider using
520      * {ReentrancyGuard} or the
521      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
522      */
523     function sendValue(address payable recipient, uint256 amount) internal {
524         require(address(this).balance >= amount, "Address: insufficient balance");
525 
526         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
527         (bool success, ) = recipient.call{ value: amount }("");
528         require(success, "Address: unable to send value, recipient may have reverted");
529     }
530 
531     /**
532      * @dev Performs a Solidity function call using a low level `call`. A
533      * plain`call` is an unsafe replacement for a function call: use this
534      * function instead.
535      *
536      * If `target` reverts with a revert reason, it is bubbled up by this
537      * function (like regular Solidity function calls).
538      *
539      * Returns the raw returned data. To convert to the expected return value,
540      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
541      *
542      * Requirements:
543      *
544      * - `target` must be a contract.
545      * - calling `target` with `data` must not revert.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
550       return functionCall(target, data, "Address: low-level call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
555      * `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
560         return _functionCallWithValue(target, data, 0, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but also transferring `value` wei to `target`.
566      *
567      * Requirements:
568      *
569      * - the calling contract must have an ETH balance of at least `value`.
570      * - the called Solidity function must be `payable`.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
580      * with `errorMessage` as a fallback revert reason when `target` reverts.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
585         require(address(this).balance >= value, "Address: insufficient balance for call");
586         return _functionCallWithValue(target, data, value, errorMessage);
587     }
588 
589     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
590         require(isContract(target), "Address: call to non-contract");
591 
592         // solhint-disable-next-line avoid-low-level-calls
593         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
594         if (success) {
595             return returndata;
596         } else {
597             // Look for revert reason and bubble it up if present
598             if (returndata.length > 0) {
599                 // The easiest way to bubble the revert reason is using memory via assembly
600 
601                 // solhint-disable-next-line no-inline-assembly
602                 assembly {
603                     let returndata_size := mload(returndata)
604                     revert(add(32, returndata), returndata_size)
605                 }
606             } else {
607                 revert(errorMessage);
608             }
609         }
610     }
611 }
612 
613 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
614 
615 pragma solidity ^0.6.0;
616 
617 
618 
619 
620 /**
621  * @title SafeERC20
622  * @dev Wrappers around ERC20 operations that throw on failure (when the token
623  * contract returns false). Tokens that return no value (and instead revert or
624  * throw on failure) are also supported, non-reverting calls are assumed to be
625  * successful.
626  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
627  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
628  */
629 library SafeERC20 {
630     using SafeMath for uint256;
631     using Address for address;
632 
633     function safeTransfer(IERC20 token, address to, uint256 value) internal {
634         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
635     }
636 
637     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
638         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
639     }
640 
641     /**
642      * @dev Deprecated. This function has issues similar to the ones found in
643      * {IERC20-approve}, and its usage is discouraged.
644      *
645      * Whenever possible, use {safeIncreaseAllowance} and
646      * {safeDecreaseAllowance} instead.
647      */
648     function safeApprove(IERC20 token, address spender, uint256 value) internal {
649         // safeApprove should only be called when setting an initial allowance,
650         // or when resetting it to zero. To increase and decrease it, use
651         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
652         // solhint-disable-next-line max-line-length
653         require((value == 0) || (token.allowance(address(this), spender) == 0),
654             "SafeERC20: approve from non-zero to non-zero allowance"
655         );
656         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
657     }
658 
659     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
660         uint256 newAllowance = token.allowance(address(this), spender).add(value);
661         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
662     }
663 
664     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
665         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
666         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
667     }
668 
669     /**
670      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
671      * on the return value: the return value is optional (but if data is returned, it must not be false).
672      * @param token The token targeted by the call.
673      * @param data The call data (encoded using abi.encode or one of its variants).
674      */
675     function _callOptionalReturn(IERC20 token, bytes memory data) private {
676         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
677         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
678         // the target address contains contract code and also asserts for success in the low-level call.
679 
680         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
681         if (returndata.length > 0) { // Return data is optional
682             // solhint-disable-next-line max-line-length
683             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
684         }
685     }
686 }
687 
688 // File: contracts\sakewear\SakeWear.sol
689 
690 pragma solidity 0.6.12;
691 
692 
693 
694 
695 
696 contract SakeWear {
697     using SafeMath for uint256;
698     using SafeERC20 for IERC20;
699 
700     ISakeSwapRouter public router;
701     uint256 public wearRate = 50;
702     uint256 public burnRate = 800;
703     address public sake;
704     address public owner;
705     address public airDrop;
706 
707     constructor(ISakeSwapRouter _router, address _sake, address _airDrop) public {
708         require(address(_router) != address(0), "Invalid Router Address");
709         require(_sake != address(0), "Invalid Sake Address");
710         require(_airDrop != address(0), "Invalid AirDrop Address");
711 
712         owner = msg.sender;
713         router = _router;
714         sake = _sake;
715         airDrop = _airDrop;
716     }
717 
718     modifier onlyOwner() {
719         require(msg.sender == owner, "Not Owner");
720         _;
721     }
722 
723     function swapExactTokensForTokens(
724         uint256 amountIn,
725         uint256 amountOutMin,
726         address[] calldata path,
727         address to,
728         uint256 deadline,
729         bool ifmint
730     ) external {
731         require(path[0] == sake, "Only Sell Sake");
732         uint256 _wearAmount = amountIn.mul(wearRate).div(1000);
733         uint256 _amountIn = amountIn.sub(_wearAmount);
734         uint256 _burnAmount = _wearAmount.mul(burnRate).div(1000);
735         uint256 _airDropAmount = _wearAmount.sub(_burnAmount);
736         IERC20(sake).safeTransferFrom(msg.sender, address(this), amountIn);
737         IERC20(sake).safeTransfer(address(1), _burnAmount);
738         IERC20(sake).safeTransfer(airDrop, _airDropAmount);
739         IERC20(sake).safeApprove(address(router), _amountIn);
740         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
741             _amountIn,
742             amountOutMin,
743             path,
744             to,
745             deadline,
746             ifmint
747         );
748     }
749 
750     function swapExactTokensForETH(
751         uint256 amountIn,
752         uint256 amountOutMin,
753         address[] calldata path,
754         address to,
755         uint256 deadline,
756         bool ifmint
757     ) external {
758         require(path[0] == sake, "Only Sell Sake");
759         uint256 _wearAmount = amountIn.mul(wearRate).div(1000);
760         uint256 _amountIn = amountIn.sub(_wearAmount);
761         uint256 _burnAmount = _wearAmount.mul(burnRate).div(1000);
762         uint256 _airDropAmount = _wearAmount.sub(_burnAmount);
763         IERC20(sake).safeTransferFrom(msg.sender, address(this), amountIn);
764         IERC20(sake).safeTransfer(address(1), _burnAmount);
765         IERC20(sake).safeTransfer(airDrop, _airDropAmount);
766         IERC20(sake).safeApprove(address(router), _amountIn);
767         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
768             _amountIn,
769             amountOutMin,
770             path,
771             to,
772             deadline,
773             ifmint
774         );
775     }
776 
777     function getAmountsOut(uint256 amountIn, address[] memory path) public view returns (uint256[] memory amounts) {
778         require(path[0] == sake, "Only Sell Sake");
779         uint256 _amountIn = amountIn.mul(1000 - wearRate).div(1000);
780         return router.getAmountsOut(_amountIn, path);
781     }
782 
783     function getAmountsIn(uint256 amountOut, address[] memory path) public view returns (uint256[] memory amounts) {
784         require(path[0] == sake, "Only Sell Sake");
785         uint256[] memory _amounts = router.getAmountsIn(amountOut, path);
786         _amounts[0] = _amounts[0].mul(1000).div(1000 - wearRate);
787         return _amounts;
788     }
789 
790     function setWearRate(uint256 _wearRate) external onlyOwner {
791         require(_wearRate < 1000, "Too Big Wear Rate");
792         wearRate = _wearRate;
793     }
794 
795     function setBurnRate(uint256 _burnRate) external onlyOwner {
796         require(_burnRate <= 1000, "Too Big burn Rate");
797         burnRate = _burnRate;
798     }
799 }