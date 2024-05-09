1 /*
2 Spindle Braiding
3 Deposit Rope Here to Generate HOPE
4 */
5 
6 pragma solidity ^0.6.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 contract Context {
19     // Empty internal constructor, to prevent people from mistakenly deploying
20     // an instance of this contract, which should be used via inheritance.
21     constructor () internal { }
22     // solhint-disable-previous-line no-empty-blocks
23 
24     function _msgSender() internal view returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 pragma solidity ^0.6.0;
35 
36 /**
37  * @dev Collection of functions related to the address type
38  */
39 library Address {
40     /**
41      * @dev Returns true if `account` is a contract.
42      *
43      * [IMPORTANT]
44      * ====
45      * It is unsafe to assume that an address for which this function returns
46      * false is an externally-owned account (EOA) and not a contract.
47      *
48      * Among others, `isContract` will return false for the following
49      * types of addresses:
50      *
51      *  - an externally-owned account
52      *  - a contract in construction
53      *  - an address where a contract will be created
54      *  - an address where a contract lived, but was destroyed
55      * ====
56      */
57     function isContract(address account) internal view returns (bool) {
58         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
59         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
60         // for accounts without code, i.e. `keccak256('')`
61         bytes32 codehash;
62         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
63         // solhint-disable-next-line no-inline-assembly
64         assembly { codehash := extcodehash(account) }
65         return (codehash != accountHash && codehash != 0x0);
66     }
67 
68     /**
69      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
70      * `recipient`, forwarding all available gas and reverting on errors.
71      *
72      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
73      * of certain opcodes, possibly making contracts go over the 2300 gas limit
74      * imposed by `transfer`, making them unable to receive funds via
75      * `transfer`. {sendValue} removes this limitation.
76      *
77      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
78      *
79      * IMPORTANT: because control is transferred to `recipient`, care must be
80      * taken to not create reentrancy vulnerabilities. Consider using
81      * {ReentrancyGuard} or the
82      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
83      */
84     function sendValue(address payable recipient, uint256 amount) internal {
85         require(address(this).balance >= amount, "Address: insufficient balance");
86 
87         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
88         (bool success, ) = recipient.call{ value: amount }("");
89         require(success, "Address: unable to send value, recipient may have reverted");
90     }
91 
92     /**
93      * @dev Performs a Solidity function call using a low level `call`. A
94      * plain`call` is an unsafe replacement for a function call: use this
95      * function instead.
96      *
97      * If `target` reverts with a revert reason, it is bubbled up by this
98      * function (like regular Solidity function calls).
99      *
100      * Returns the raw returned data. To convert to the expected return value,
101      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
102      *
103      * Requirements:
104      *
105      * - `target` must be a contract.
106      * - calling `target` with `data` must not revert.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111         return functionCall(target, data, "Address: low-level call failed");
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
116      * `errorMessage` as a fallback revert reason when `target` reverts.
117      *
118      * _Available since v3.1._
119      */
120     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
121         return _functionCallWithValue(target, data, 0, errorMessage);
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
126      * but also transferring `value` wei to `target`.
127      *
128      * Requirements:
129      *
130      * - the calling contract must have an ETH balance of at least `value`.
131      * - the called Solidity function must be `payable`.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
141      * with `errorMessage` as a fallback revert reason when `target` reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
146         require(address(this).balance >= value, "Address: insufficient balance for call");
147         return _functionCallWithValue(target, data, value, errorMessage);
148     }
149 
150     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
151         require(isContract(target), "Address: call to non-contract");
152 
153         // solhint-disable-next-line avoid-low-level-calls
154         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
155         if (success) {
156             return returndata;
157         } else {
158             // Look for revert reason and bubble it up if present
159             if (returndata.length > 0) {
160                 // The easiest way to bubble the revert reason is using memory via assembly
161 
162                 // solhint-disable-next-line no-inline-assembly
163                 assembly {
164                     let returndata_size := mload(returndata)
165                     revert(add(32, returndata), returndata_size)
166                 }
167             } else {
168                 revert(errorMessage);
169             }
170         }
171     }
172 }
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * This module is used through inheritance. It will make available the modifier
180  * `onlyOwner`, which can be applied to your functions to restrict their use to
181  * the owner.
182  */
183 contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor () internal {
192         address msgSender = _msgSender();
193         _owner = msgSender;
194         emit OwnershipTransferred(address(0), msgSender);
195     }
196 
197     /**
198      * @dev Returns the address of the current owner.
199      */
200     function owner() public view returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(isOwner(), "Ownable: caller is not the owner");
209         _;
210     }
211 
212     /**
213      * @dev Returns true if the caller is the current owner.
214      */
215     function isOwner() public view returns (bool) {
216         return _msgSender() == _owner;
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public onlyOwner {
227         emit OwnershipTransferred(_owner, address(0));
228         _owner = address(0);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Can only be called by the current owner.
234      */
235     function transferOwnership(address newOwner) public onlyOwner {
236         _transferOwnership(newOwner);
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      */
242     function _transferOwnership(address newOwner) internal {
243         require(newOwner != address(0), "Ownable: new owner is the zero address");
244         emit OwnershipTransferred(_owner, newOwner);
245         _owner = newOwner;
246     }
247 }
248 
249 /**
250  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
251  * the optional functions; to access them see {ERC20Detailed}.
252  */
253 interface IERC20 {
254     /**
255      * @dev Returns the amount of tokens in existence.
256      */
257     function totalSupply() external view returns (uint256);
258 
259     /**
260      * @dev Returns the amount of tokens owned by `account`.
261      */
262     function balanceOf(address account) external view returns (uint256);
263 
264     /**
265      * @dev Moves `amount` tokens from the caller's account to `recipient`.
266      *
267      * Returns a boolean value indicating whether the operation succeeded.
268      *
269      * Emits a {Transfer} event.
270      */
271     function transfer(address recipient, uint256 amount) external returns (bool);
272 
273     /**
274      * @dev Returns the remaining number of tokens that `spender` will be
275      * allowed to spend on behalf of `owner` through {transferFrom}. This is
276      * zero by default.
277      *
278      * This value changes when {approve} or {transferFrom} are called.
279      */
280     function allowance(address owner, address spender) external view returns (uint256);
281 
282     /**
283      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * IMPORTANT: Beware that changing an allowance with this method brings the risk
288      * that someone may use both the old and the new allowance by unfortunate
289      * transaction ordering. One possible solution to mitigate this race
290      * condition is to first reduce the spender's allowance to 0 and set the
291      * desired value afterwards:
292      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
293      *
294      * Emits an {Approval} event.
295      */
296     function approve(address spender, uint256 amount) external returns (bool);
297 
298     /**
299      * @dev Moves `amount` tokens from `sender` to `recipient` using the
300      * allowance mechanism. `amount` is then deducted from the caller's
301      * allowance.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Emitted when `value` tokens are moved from one account (`from`) to
311      * another (`to`).
312      *
313      * Note that `value` may be zero.
314      */
315     event Transfer(address indexed from, address indexed to, uint256 value);
316 
317     /**
318      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
319      * a call to {approve}. `value` is the new allowance.
320      */
321     event Approval(address indexed owner, address indexed spender, uint256 value);
322 }
323 
324 /**
325  * @title SafeERC20
326  * @dev Wrappers around ERC20 operations that throw on failure (when the token
327  * contract returns false). Tokens that return no value (and instead revert or
328  * throw on failure) are also supported, non-reverting calls are assumed to be
329  * successful.
330  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
331  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
332  */
333 library SafeERC20 {
334     using SafeMath for uint256;
335     using Address for address;
336 
337     function safeTransfer(IERC20 token, address to, uint256 value) internal {
338         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
339     }
340 
341     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
342         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
343     }
344 
345     /**
346      * @dev Deprecated. This function has issues similar to the ones found in
347      * {IERC20-approve}, and its usage is discouraged.
348      *
349      * Whenever possible, use {safeIncreaseAllowance} and
350      * {safeDecreaseAllowance} instead.
351      */
352     function safeApprove(IERC20 token, address spender, uint256 value) internal {
353         // safeApprove should only be called when setting an initial allowance,
354         // or when resetting it to zero. To increase and decrease it, use
355         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
356         // solhint-disable-next-line max-line-length
357         require((value == 0) || (token.allowance(address(this), spender) == 0),
358             "SafeERC20: approve from non-zero to non-zero allowance"
359         );
360         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
361     }
362 
363     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
364         uint256 newAllowance = token.allowance(address(this), spender).add(value);
365         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
366     }
367 
368     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
369         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
370         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371     }
372 
373     /**
374      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
375      * on the return value: the return value is optional (but if data is returned, it must not be false).
376      * @param token The token targeted by the call.
377      * @param data The call data (encoded using abi.encode or one of its variants).
378      */
379     function _callOptionalReturn(IERC20 token, bytes memory data) private {
380         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
381         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
382         // the target address contains contract code and also asserts for success in the low-level call.
383 
384         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
385         if (returndata.length > 0) { // Return data is optional
386             // solhint-disable-next-line max-line-length
387             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
388         }
389     }
390 }
391 
392 /**
393  * @dev Wrappers over Solidity's arithmetic operations with added overflow
394  * checks.
395  *
396  * Arithmetic operations in Solidity wrap on overflow. This can easily result
397  * in bugs, because programmers usually assume that an overflow raises an
398  * error, which is the standard behavior in high level programming languages.
399  * `SafeMath` restores this intuition by reverting the transaction when an
400  * operation overflows.
401  *
402  * Using this library instead of the unchecked operations eliminates an entire
403  * class of bugs, so it's recommended to use it always.
404  */
405 library SafeMath {
406     /**
407      * @dev Returns the addition of two unsigned integers, reverting on
408      * overflow.
409      *
410      * Counterpart to Solidity's `+` operator.
411      *
412      * Requirements:
413      *
414      * - Addition cannot overflow.
415      */
416     function add(uint256 a, uint256 b) internal pure returns (uint256) {
417         uint256 c = a + b;
418         require(c >= a, "SafeMath: addition overflow");
419 
420         return c;
421     }
422 
423     /**
424      * @dev Returns the subtraction of two unsigned integers, reverting on
425      * overflow (when the result is negative).
426      *
427      * Counterpart to Solidity's `-` operator.
428      *
429      * Requirements:
430      *
431      * - Subtraction cannot overflow.
432      */
433     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
434         return sub(a, b, "SafeMath: subtraction overflow");
435     }
436 
437     /**
438      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
439      * overflow (when the result is negative).
440      *
441      * Counterpart to Solidity's `-` operator.
442      *
443      * Requirements:
444      *
445      * - Subtraction cannot overflow.
446      */
447     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
448         require(b <= a, errorMessage);
449         uint256 c = a - b;
450 
451         return c;
452     }
453 
454     /**
455      * @dev Returns the multiplication of two unsigned integers, reverting on
456      * overflow.
457      *
458      * Counterpart to Solidity's `*` operator.
459      *
460      * Requirements:
461      *
462      * - Multiplication cannot overflow.
463      */
464     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
465         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
466         // benefit is lost if 'b' is also tested.
467         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
468         if (a == 0) {
469             return 0;
470         }
471 
472         uint256 c = a * b;
473         require(c / a == b, "SafeMath: multiplication overflow");
474 
475         return c;
476     }
477 
478     /**
479      * @dev Returns the integer division of two unsigned integers. Reverts on
480      * division by zero. The result is rounded towards zero.
481      *
482      * Counterpart to Solidity's `/` operator. Note: this function uses a
483      * `revert` opcode (which leaves remaining gas untouched) while Solidity
484      * uses an invalid opcode to revert (consuming all remaining gas).
485      *
486      * Requirements:
487      *
488      * - The divisor cannot be zero.
489      */
490     function div(uint256 a, uint256 b) internal pure returns (uint256) {
491         return div(a, b, "SafeMath: division by zero");
492     }
493 
494     /**
495      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
496      * division by zero. The result is rounded towards zero.
497      *
498      * Counterpart to Solidity's `/` operator. Note: this function uses a
499      * `revert` opcode (which leaves remaining gas untouched) while Solidity
500      * uses an invalid opcode to revert (consuming all remaining gas).
501      *
502      * Requirements:
503      *
504      * - The divisor cannot be zero.
505      */
506     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b > 0, errorMessage);
508         uint256 c = a / b;
509         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
510 
511         return c;
512     }
513 
514     /**
515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
516      * Reverts when dividing by zero.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
527         return mod(a, b, "SafeMath: modulo by zero");
528     }
529 
530     /**
531      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
532      * Reverts with custom message when dividing by zero.
533      *
534      * Counterpart to Solidity's `%` operator. This function uses a `revert`
535      * opcode (which leaves remaining gas untouched) while Solidity uses an
536      * invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b != 0, errorMessage);
544         return a % b;
545     }
546 }
547 
548 interface UniswapRouterV2 {
549     function swapExactTokensForTokens(
550         uint256 amountIn,
551         uint256 amountOutMin,
552         address[] calldata path,
553         address to,
554         uint256 deadline
555     ) external returns (uint256[] memory amounts);
556 
557     function addLiquidity(
558         address tokenA,
559         address tokenB,
560         uint256 amountADesired,
561         uint256 amountBDesired,
562         uint256 amountAMin,
563         uint256 amountBMin,
564         address to,
565         uint256 deadline
566     )
567     external
568     returns (
569         uint256 amountA,
570         uint256 amountB,
571         uint256 liquidity
572     );
573 
574     function addLiquidityETH(
575         address token,
576         uint256 amountTokenDesired,
577         uint256 amountTokenMin,
578         uint256 amountETHMin,
579         address to,
580         uint256 deadline
581     )
582     external
583     payable
584     returns (
585         uint256 amountToken,
586         uint256 amountETH,
587         uint256 liquidity
588     );
589 
590     function removeLiquidity(
591         address tokenA,
592         address tokenB,
593         uint256 liquidity,
594         uint256 amountAMin,
595         uint256 amountBMin,
596         address to,
597         uint256 deadline
598     ) external returns (uint256 amountA, uint256 amountB);
599 
600     function getAmountsOut(uint256 amountIn, address[] calldata path)
601     external
602     view
603     returns (uint256[] memory amounts);
604 
605     function getAmountsIn(uint256 amountOut, address[] calldata path)
606     external
607     view
608     returns (uint256[] memory amounts);
609 
610     function swapETHForExactTokens(
611         uint256 amountOut,
612         address[] calldata path,
613         address to,
614         uint256 deadline
615     ) external payable returns (uint256[] memory amounts);
616 
617     function swapExactETHForTokens(
618         uint256 amountOutMin,
619         address[] calldata path,
620         address to,
621         uint256 deadline
622     ) external payable returns (uint256[] memory amounts);
623 }
624 
625 interface IUniswapV2Pair {
626     event Approval(
627         address indexed owner,
628         address indexed spender,
629         uint256 value
630     );
631     event Transfer(address indexed from, address indexed to, uint256 value);
632 
633     function name() external pure returns (string memory);
634 
635     function symbol() external pure returns (string memory);
636 
637     function decimals() external pure returns (uint8);
638 
639     function totalSupply() external view returns (uint256);
640 
641     function balanceOf(address owner) external view returns (uint256);
642 
643     function allowance(address owner, address spender)
644     external
645     view
646     returns (uint256);
647 
648     function approve(address spender, uint256 value) external returns (bool);
649 
650     function transfer(address to, uint256 value) external returns (bool);
651 
652     function transferFrom(
653         address from,
654         address to,
655         uint256 value
656     ) external returns (bool);
657 
658     function DOMAIN_SEPARATOR() external view returns (bytes32);
659 
660     function PERMIT_TYPEHASH() external pure returns (bytes32);
661 
662     function nonces(address owner) external view returns (uint256);
663 
664     function permit(
665         address owner,
666         address spender,
667         uint256 value,
668         uint256 deadline,
669         uint8 v,
670         bytes32 r,
671         bytes32 s
672     ) external;
673 
674     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
675     event Burn(
676         address indexed sender,
677         uint256 amount0,
678         uint256 amount1,
679         address indexed to
680     );
681     event Swap(
682         address indexed sender,
683         uint256 amount0In,
684         uint256 amount1In,
685         uint256 amount0Out,
686         uint256 amount1Out,
687         address indexed to
688     );
689     event Sync(uint112 reserve0, uint112 reserve1);
690 
691     function MINIMUM_LIQUIDITY() external pure returns (uint256);
692 
693     function factory() external view returns (address);
694 
695     function token0() external view returns (address);
696 
697     function token1() external view returns (address);
698 
699     function getReserves()
700     external
701     view
702     returns (
703         uint112 reserve0,
704         uint112 reserve1,
705         uint32 blockTimestampLast
706     );
707 
708     function price0CumulativeLast() external view returns (uint256);
709 
710     function price1CumulativeLast() external view returns (uint256);
711 
712     function kLast() external view returns (uint256);
713 
714     function mint(address to) external returns (uint256 liquidity);
715 
716     function burn(address to)
717     external
718     returns (uint256 amount0, uint256 amount1);
719 
720     function swap(
721         uint256 amount0Out,
722         uint256 amount1Out,
723         address to,
724         bytes calldata data
725     ) external;
726 
727     function skim(address to) external;
728 
729     function sync() external;
730 }
731 
732 interface IUniswapV2Factory {
733     event PairCreated(
734         address indexed token0,
735         address indexed token1,
736         address pair,
737         uint256
738     );
739 
740     function getPair(address tokenA, address tokenB)
741     external
742     view
743     returns (address pair);
744 
745     function allPairs(uint256) external view returns (address pair);
746 
747     function allPairsLength() external view returns (uint256);
748 
749     function feeTo() external view returns (address);
750 
751     function feeToSetter() external view returns (address);
752 
753     function createPair(address tokenA, address tokenB)
754     external
755     returns (address pair);
756 }
757 
758 interface HopeNonTradable {
759     function totalSupply() external view returns (uint256);
760 
761     function totalClaimed() external view returns (uint256);
762 
763     function addClaimed(uint256 _amount) external;
764 
765     function setClaimed(uint256 _amount) external;
766 
767     function transfer(address receiver, uint numTokens) external returns (bool);
768 
769     function transferFrom(address owner, address buyer, uint numTokens) external returns (bool);
770 
771     function balanceOf(address owner) external view returns (uint256);
772 
773     function mint(address _to, uint256 _amount) external;
774 
775     function burn(address _account, uint256 value) external;
776 }
777 
778 // Uniswap Liquidity Mining
779 interface IStakingRewards {
780     function earned(address account) external view returns (uint256);
781 
782     function stake(uint256 amount) external;
783 
784     function withdraw(uint256 amount) external;
785 
786     function getReward() external;
787 
788     function exit() external;
789 
790     function balanceOf(address account) external view returns (uint256);
791 }
792 
793 
794 interface HopeBooster {
795     function deposit(address _addr, uint256 _amount, bool ignoreFee) external;
796 }
797 
798 contract RopeUniSpindle is Ownable {
799     using SafeMath for uint256;
800     using SafeERC20 for IERC20;
801 
802     // Info of each user.
803     struct UserInfo {
804         uint256 amount; // How many tokens the user has provided.
805         uint256 uniRewardDebt; // Reward debt. See explanation below.
806         //
807         // We do some fancy math here. Basically, any point in time, the amount of HOPEs
808         // entitled to a user but is pending to be distributed is:
809         //
810         //   pending reward = (user.amount * pool.accHopePerShare) - user.rewardDebt
811         //
812         // Whenever a user deposits or withdraws tokens to a pool. Here's what happens:
813         //   1. The pool's `accHopePerShare` (and `lastRewardBlock`) gets updated.
814         //   2. User receives the pending reward sent to his/her address.
815         //   3. User's `amount` gets updated.
816         //   4. User's `rewardDebt` gets updated.
817     }
818 
819     // Info of each pool.
820     struct PoolInfo {
821         IERC20 token; // Address of token contract.
822         IStakingRewards uniStaking; // Address of the uni staking
823         uint256 lastRewardBlock; // Last block number that UNI distribution occurs.
824         uint256 accUniPerShare; // Accumulated UNIs per share, times 1e12.
825         uint256 supply; // Total tokens in the pool
826     }
827 
828     // tokens we're farming
829     address public constant uni = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
830 
831     // weth
832     address public constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
833 
834     // dex
835     address public univ2Router2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
836 
837     // Info of each pool.
838     PoolInfo[] public poolInfo;
839     // Info of each user that stakes LP tokens.
840     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
841     // Record whether the pair has been added.
842     mapping(address => uint256) public tokenPID;
843 
844     HopeBooster public hopeBooster;
845     IERC20 public rope;
846 
847     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
848     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
849 
850     constructor(IERC20 _ropeAddress, HopeBooster _hopeBoosterAddress) public {
851         rope = _ropeAddress;
852         hopeBooster = _hopeBoosterAddress;
853     }
854 
855     function poolLength() external view returns (uint256) {
856         return poolInfo.length;
857     }
858 
859     // Add a new token to the pool. Can only be called by the owner.
860     // XXX DO NOT add the same token more than once. Rewards will be messed up if you do.
861     function add(IERC20 _token, IStakingRewards _uniStaking) public onlyOwner {
862         require(tokenPID[address(_token)] == 0, "Duplicate add.");
863         poolInfo.push(
864             PoolInfo({
865         token: _token,
866         uniStaking: _uniStaking,
867         lastRewardBlock: block.number,
868         accUniPerShare: 0,
869         supply: 0
870         })
871         );
872         tokenPID[address(_token)] = poolInfo.length;
873     }
874 
875     // Withdraw tokens from multiple pools
876     function massWithdraw(uint256[] memory _pids) public {
877         // We batch the handling of all rewards collection here, to reduce gas fee
878         loadAllRopesIntoBooster();
879 
880         for (uint i=0; i < _pids.length; i++) {
881             // As we handled the rewards at the beginning, we dont need to worry about it
882             _withdrawWithoutRewards(i);
883         }
884     }
885 
886     function exit() public {
887         // We batch the handling of all rewards collection here, to reduce gas fee
888         loadAllRopesIntoBooster();
889 
890         uint256 length = poolInfo.length;
891         for (uint256 i = 0; i < length; ++i) {
892             // As we handled the rewards at the beginning, we dont need to worry about it
893             _withdrawWithoutRewards(i);
894         }
895     }
896 
897     // Update reward variables for all pools. Be careful of gas spending!
898     function massUpdatePool() public {
899         uint256 length = poolInfo.length;
900         for (uint256 pid = 0; pid < length; ++pid) {
901             updatePool(pid);
902         }
903     }
904 
905     // Update reward variables of the given pool to be up-to-date.
906     function updatePool(uint256 _pid) public {
907         PoolInfo storage pool = poolInfo[_pid];
908 
909         if (block.number <= pool.lastRewardBlock) {
910             return;
911         }
912 
913         uint256 tokenSupply = pool.supply;
914 
915         if (tokenSupply == 0) {
916             pool.lastRewardBlock = block.number;
917             return;
918         }
919 
920         uint256 uniReward = pool.uniStaking.earned(address(this));
921         pool.uniStaking.getReward();
922 
923         pool.accUniPerShare = pool.accUniPerShare.add(uniReward.mul(1e12).div(tokenSupply));
924         pool.lastRewardBlock = block.number;
925     }
926 
927     // Deposit LP tokens to pool for HOPE allocation.
928     function deposit(uint256 _pid, uint256 _amount) public {
929         require(_amount > 0, "Amount to deposit must be > 0");
930 
931         PoolInfo storage pool = poolInfo[_pid];
932         UserInfo storage user = userInfo[_pid][msg.sender];
933         updatePool(_pid);
934 
935         uint256 pendingUni = user.amount.mul(pool.accUniPerShare).div(1e12).sub(user.uniRewardDebt);
936         user.amount = user.amount.add(_amount);
937         pool.supply = pool.supply.add(_amount);
938         user.uniRewardDebt = user.amount.mul(pool.accUniPerShare).div(1e12);
939 
940         if (pendingUni > 0) {
941             _loadRopesIntoBooster(msg.sender, pendingUni);
942         }
943 
944         pool.token.safeTransferFrom(msg.sender, address(this), _amount);
945 
946         //approve and stake to uniswap
947         pool.token.approve(address(pool.uniStaking), _amount);
948         pool.uniStaking.stake(_amount);
949 
950         emit Deposit(msg.sender, _pid, _amount);
951     }
952 
953     // Withdraw tokens from pool.
954     function withdraw(uint256 _pid, uint256 _amount) public {
955         require(_amount >= 0, "Amount to withdraw must be >= 0");
956 
957         PoolInfo storage pool = poolInfo[_pid];
958         UserInfo storage user = userInfo[_pid][msg.sender];
959         require(user.amount >= _amount, "withdraw: not good");
960         updatePool(_pid);
961 
962         uint256 pendingUni = user.amount.mul(pool.accUniPerShare).div(1e12).sub(user.uniRewardDebt);
963         user.amount = user.amount.sub(_amount);
964         pool.supply = pool.supply.sub(_amount);
965         user.uniRewardDebt = user.amount.mul(pool.accUniPerShare).div(1e12);
966 
967         if (pendingUni > 0) {
968             _loadRopesIntoBooster(msg.sender, pendingUni);
969         }
970 
971         //unstake uniswap lp token from uniswap
972         pool.uniStaking.withdraw(_amount);
973 
974         pool.token.safeTransfer(msg.sender, _amount);
975 
976         emit Withdraw(msg.sender, _pid, _amount);
977     }
978 
979     function loadAllRopesIntoBooster() public {
980         loadAllRopesOfAddressIntoBooster(msg.sender);
981     }
982 
983     function loadAllRopesOfAddressIntoBooster(address _addr) public {
984         uint256 totalPendingUni = 0;
985 
986         uint256 length = poolInfo.length;
987         for (uint256 pid = 0; pid < length; ++pid) {
988             UserInfo storage user = userInfo[pid][_addr];
989 
990             if (user.amount == 0) {
991                 continue;
992             }
993 
994             PoolInfo storage pool = poolInfo[pid];
995 
996             updatePool(pid);
997 
998             uint256 pendingUni = user.amount.mul(pool.accUniPerShare).div(1e12).sub(user.uniRewardDebt);
999             user.uniRewardDebt = user.amount.mul(pool.accUniPerShare).div(1e12);
1000 
1001             totalPendingUni = totalPendingUni.add(pendingUni);
1002         }
1003 
1004         if (totalPendingUni > 0) {
1005             _loadRopesIntoBooster(_addr, totalPendingUni);
1006         }
1007     }
1008 
1009     function _loadRopesIntoBooster(address _addr, uint256 _amount) internal {
1010         uint256[] memory amounts = _swap(address(uni), address(rope), _amount);
1011 
1012         rope.safeApprove(address(hopeBooster), amounts[amounts.length - 1]);
1013         hopeBooster.deposit(_addr, amounts[amounts.length - 1], false);
1014     }
1015 
1016     function _swap(address _from, address _to, uint256 _amount) internal returns (uint256[] memory amounts) {
1017         // Swap with uniswap
1018         IERC20(_from).safeApprove(univ2Router2, 0);
1019         IERC20(_from).safeApprove(univ2Router2, _amount);
1020 
1021         address[] memory path;
1022 
1023         if (_from == weth || _to == weth) {
1024             path = new address[](2);
1025             path[0] = _from;
1026             path[1] = _to;
1027         } else {
1028             path = new address[](3);
1029             path[0] = _from;
1030             path[1] = weth;
1031             path[2] = _to;
1032         }
1033 
1034         uint256 minAmount = 0;
1035 
1036         return UniswapRouterV2(univ2Router2).swapExactTokensForTokens(
1037             _amount,
1038             minAmount,
1039             path,
1040             address(this),
1041             now.add(60)
1042         );
1043     }
1044 
1045     function _withdrawWithoutRewards(uint256 _pid) internal returns(uint256) {
1046         PoolInfo storage pool = poolInfo[_pid];
1047         UserInfo storage user = userInfo[_pid][msg.sender];
1048 
1049         if (user.amount == 0) {
1050             return 0;
1051         }
1052 
1053         uint256 _amount = user.amount;
1054         user.amount = 0;
1055         pool.supply = pool.supply.sub(_amount);
1056         user.uniRewardDebt = 0;
1057 
1058         //unstake lp token from uniswap
1059         pool.uniStaking.withdraw(_amount);
1060 
1061         pool.token.safeTransfer(msg.sender, _amount);
1062         emit Withdraw(msg.sender, _pid, _amount);
1063         return _amount;
1064     }
1065 
1066     // Withdraw without caring about rewards. EMERGENCY ONLY.
1067     function emergencyWithdraw(uint256 _pid) public {
1068         _withdrawWithoutRewards(_pid);
1069     }
1070 }