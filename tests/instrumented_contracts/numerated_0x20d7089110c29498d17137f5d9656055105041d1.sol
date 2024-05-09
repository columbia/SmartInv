1 /**
2 
3 RugRelief $RR
4 https://t.me/RugRelief
5 
6 */
7 
8 pragma solidity ^0.8.3;
9 // SPDX-License-Identifier: Unlicensed
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16     * @dev Returns the amount of tokens in existence.
17     */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21     * @dev Returns the amount of tokens owned by `account`.
22     */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26     * @dev Moves `amount` tokens from the caller's account to `recipient`.
27     *
28     * Returns a boolean value indicating whether the operation succeeded.
29     *
30     * Emits a {Transfer} event.
31     */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35     * @dev Returns the remaining number of tokens that `spender` will be
36     * allowed to spend on behalf of `owner` through {transferFrom}. This is
37     * zero by default.
38     *
39     * This value changes when {approve} or {transferFrom} are called.
40     */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45     *
46     * Returns a boolean value indicating whether the operation succeeded.
47     *
48     * IMPORTANT: Beware that changing an allowance with this method brings the risk
49     * that someone may use both the old and the new allowance by unfortunate
50     * transaction ordering. One possible solution to mitigate this race
51     * condition is to first reduce the spender's allowance to 0 and set the
52     * desired value afterwards:
53     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54     *
55     * Emits an {Approval} event.
56     */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60     * @dev Moves `amount` tokens from `sender` to `recipient` using the
61     * allowance mechanism. `amount` is then deducted from the caller's
62     * allowance.
63     *
64     * Returns a boolean value indicating whether the operation succeeded.
65     *
66     * Emits a {Transfer} event.
67     */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71     * @dev Emitted when `value` tokens are moved from one account (`from`) to
72     * another (`to`).
73     *
74     * Note that `value` may be zero.
75     */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80     * a call to {approve}. `value` is the new allowance.
81     */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // CAUTION
86 // This version of SafeMath should only be used with Solidity 0.8 or later,
87 // because it relies on the compiler's built in overflow checks.
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations.
91  *
92  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
93  * now has built in overflow checking.
94  */
95 library SafeMath {
96     /**
97     * @dev Returns the addition of two unsigned integers, with an overflow flag.
98     *
99     * _Available since v3.4._
100     */
101     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             uint256 c = a + b;
104             if (c < a) return (false, 0);
105             return (true, c);
106         }
107     }
108 
109     /**
110     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
111     *
112     * _Available since v3.4._
113     */
114     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         unchecked {
116             if (b > a) return (false, 0);
117             return (true, a - b);
118         }
119     }
120 
121     /**
122     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
123     *
124     * _Available since v3.4._
125     */
126     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         unchecked {
128             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129             // benefit is lost if 'b' is also tested.
130             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131             if (a == 0) return (true, 0);
132             uint256 c = a * b;
133             if (c / a != b) return (false, 0);
134             return (true, c);
135         }
136     }
137 
138     /**
139     * @dev Returns the division of two unsigned integers, with a division by zero flag.
140     *
141     * _Available since v3.4._
142     */
143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         unchecked {
145             if (b == 0) return (false, 0);
146             return (true, a / b);
147         }
148     }
149 
150     /**
151     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
152     *
153     * _Available since v3.4._
154     */
155     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         unchecked {
157             if (b == 0) return (false, 0);
158             return (true, a % b);
159         }
160     }
161 
162     /**
163     * @dev Returns the addition of two unsigned integers, reverting on
164     * overflow.
165     *
166     * Counterpart to Solidity's `+` operator.
167     *
168     * Requirements:
169     *
170     * - Addition cannot overflow.
171     */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a + b;
174     }
175 
176     /**
177     * @dev Returns the subtraction of two unsigned integers, reverting on
178     * overflow (when the result is negative).
179     *
180     * Counterpart to Solidity's `-` operator.
181     *
182     * Requirements:
183     *
184     * - Subtraction cannot overflow.
185     */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         return a - b;
188     }
189 
190     /**
191     * @dev Returns the multiplication of two unsigned integers, reverting on
192     * overflow.
193     *
194     * Counterpart to Solidity's `*` operator.
195     *
196     * Requirements:
197     *
198     * - Multiplication cannot overflow.
199     */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a * b;
202     }
203 
204     /**
205     * @dev Returns the integer division of two unsigned integers, reverting on
206     * division by zero. The result is rounded towards zero.
207     *
208     * Counterpart to Solidity's `/` operator.
209     *
210     * Requirements:
211     *
212     * - The divisor cannot be zero.
213     */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a / b;
216     }
217 
218     /**
219     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220     * reverting when dividing by zero.
221     *
222     * Counterpart to Solidity's `%` operator. This function uses a `revert`
223     * opcode (which leaves remaining gas untouched) while Solidity uses an
224     * invalid opcode to revert (consuming all remaining gas).
225     *
226     * Requirements:
227     *
228     * - The divisor cannot be zero.
229     */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a % b;
232     }
233 
234     /**
235     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
236     * overflow (when the result is negative).
237     *
238     * CAUTION: This function is deprecated because it requires allocating memory for the error
239     * message unnecessarily. For custom revert reasons use {trySub}.
240     *
241     * Counterpart to Solidity's `-` operator.
242     *
243     * Requirements:
244     *
245     * - Subtraction cannot overflow.
246     */
247     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         unchecked {
249             require(b <= a, errorMessage);
250             return a - b;
251         }
252     }
253 
254     /**
255     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
256     * division by zero. The result is rounded towards zero.
257     *
258     * Counterpart to Solidity's `%` operator. This function uses a `revert`
259     * opcode (which leaves remaining gas untouched) while Solidity uses an
260     * invalid opcode to revert (consuming all remaining gas).
261     *
262     * Counterpart to Solidity's `/` operator. Note: this function uses a
263     * `revert` opcode (which leaves remaining gas untouched) while Solidity
264     * uses an invalid opcode to revert (consuming all remaining gas).
265     *
266     * Requirements:
267     *
268     * - The divisor cannot be zero.
269     */
270     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         unchecked {
272             require(b > 0, errorMessage);
273             return a / b;
274         }
275     }
276 
277     /**
278     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279     * reverting with custom message when dividing by zero.
280     *
281     * CAUTION: This function is deprecated because it requires allocating memory for the error
282     * message unnecessarily. For custom revert reasons use {tryMod}.
283     *
284     * Counterpart to Solidity's `%` operator. This function uses a `revert`
285     * opcode (which leaves remaining gas untouched) while Solidity uses an
286     * invalid opcode to revert (consuming all remaining gas).
287     *
288     * Requirements:
289     *
290     * - The divisor cannot be zero.
291     */
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         unchecked {
294             require(b > 0, errorMessage);
295             return a % b;
296         }
297     }
298 }
299 
300 /*
301  * @dev Provides information about the current execution context, including the
302  * sender of the transaction and its data. While these are generally available
303  * via msg.sender and msg.data, they should not be accessed in such a direct
304  * manner, since when dealing with meta-transactions the account sending and
305  * paying for execution may not be the actual sender (as far as an application
306  * is concerned).
307  *
308  * This contract is only required for intermediate, library-like contracts.
309  */
310 abstract contract Context {
311     function _msgSender() internal view virtual returns (address) {
312         return msg.sender;
313     }
314 
315     function _msgData() internal view virtual returns (bytes calldata) {
316         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
317         return msg.data;
318     }
319 }
320 
321 /**
322  * @dev Collection of functions related to the address type
323  */
324 library Address {
325     /**
326     * @dev Returns true if `account` is a contract.
327     *
328     * [IMPORTANT]
329     * ====
330     * It is unsafe to assume that an address for which this function returns
331     * false is an externally-owned account (EOA) and not a contract.
332     *
333     * Among others, `isContract` will return false for the following
334     * types of addresses:
335     *
336     *  - an externally-owned account
337     *  - a contract in construction
338     *  - an address where a contract will be created
339     *  - an address where a contract lived, but was destroyed
340     * ====
341     */
342     function isContract(address account) internal view returns (bool) {
343         // This method relies on extcodesize, which returns 0 for contracts in
344         // construction, since the code is only stored at the end of the
345         // constructor execution.
346 
347         uint256 size;
348         // solhint-disable-next-line no-inline-assembly
349         assembly { size := extcodesize(account) }
350         return size > 0;
351     }
352 
353     /**
354     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
355     * `recipient`, forwarding all available gas and reverting on errors.
356     *
357     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
358     * of certain opcodes, possibly making contracts go over the 2300 gas limit
359     * imposed by `transfer`, making them unable to receive funds via
360     * `transfer`. {sendValue} removes this limitation.
361     *
362     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
363     *
364     * IMPORTANT: because control is transferred to `recipient`, care must be
365     * taken to not create reentrancy vulnerabilities. Consider using
366     * {ReentrancyGuard} or the
367     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
368     */
369     function sendValue(address payable recipient, uint256 amount) internal {
370         require(address(this).balance >= amount, "Address: insufficient balance");
371 
372         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
373         (bool success, ) = recipient.call{ value: amount }("");
374         require(success, "Address: unable to send value, recipient may have reverted");
375     }
376 
377     /**
378     * @dev Performs a Solidity function call using a low level `call`. A
379     * plain`call` is an unsafe replacement for a function call: use this
380     * function instead.
381     *
382     * If `target` reverts with a revert reason, it is bubbled up by this
383     * function (like regular Solidity function calls).
384     *
385     * Returns the raw returned data. To convert to the expected return value,
386     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
387     *
388     * Requirements:
389     *
390     * - `target` must be a contract.
391     * - calling `target` with `data` must not revert.
392     *
393     * _Available since v3.1._
394     */
395     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
396       return functionCall(target, data, "Address: low-level call failed");
397     }
398 
399     /**
400     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
401     * `errorMessage` as a fallback revert reason when `target` reverts.
402     *
403     * _Available since v3.1._
404     */
405     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, 0, errorMessage);
407     }
408 
409     /**
410     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411     * but also transferring `value` wei to `target`.
412     *
413     * Requirements:
414     *
415     * - the calling contract must have an ETH balance of at least `value`.
416     * - the called Solidity function must be `payable`.
417     *
418     * _Available since v3.1._
419     */
420     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423 
424     /**
425     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426     * with `errorMessage` as a fallback revert reason when `target` reverts.
427     *
428     * _Available since v3.1._
429     */
430     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
431         require(address(this).balance >= value, "Address: insufficient balance for call");
432         require(isContract(target), "Address: call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.call{ value: value }(data);
436         return _verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441     * but performing a static call.
442     *
443     * _Available since v3.3._
444     */
445     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
446         return functionStaticCall(target, data, "Address: low-level static call failed");
447     }
448 
449     /**
450     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451     * but performing a static call.
452     *
453     * _Available since v3.3._
454     */
455     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.staticcall(data);
460         return _verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465     * but performing a delegate call.
466     *
467     * _Available since v3.4._
468     */
469     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
471     }
472 
473     /**
474     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475     * but performing a delegate call.
476     *
477     * _Available since v3.4._
478     */
479     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
480         require(isContract(target), "Address: delegate call to non-contract");
481 
482         // solhint-disable-next-line avoid-low-level-calls
483         (bool success, bytes memory returndata) = target.delegatecall(data);
484         return _verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             // Look for revert reason and bubble it up if present
492             if (returndata.length > 0) {
493                 // The easiest way to bubble the revert reason is using memory via assembly
494 
495                 // solhint-disable-next-line no-inline-assembly
496                 assembly {
497                     let returndata_size := mload(returndata)
498                     revert(add(32, returndata), returndata_size)
499                 }
500             } else {
501                 revert(errorMessage);
502             }
503         }
504     }
505 }
506 
507 /**
508  * @dev Contract module which provides a basic access control mechanism, where
509  * there is an account (an owner) that can be granted exclusive access to
510  * specific functions.
511  *
512  * By default, the owner account will be the one that deploys the contract. This
513  * can later be changed with {transferOwnership}.
514  *
515  * This module is used through inheritance. It will make available the modifier
516  * `onlyOwner`, which can be applied to your functions to restrict their use to
517  * the owner.
518  */
519 abstract contract Ownable is Context {
520     address private _owner;
521 
522     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
523 
524     /**
525     * @dev Initializes the contract setting the deployer as the initial owner.
526     */
527     constructor () {
528         _owner = _msgSender();
529         emit OwnershipTransferred(address(0), _owner);
530     }
531 
532     /**
533     * @dev Returns the address of the current owner.
534     */
535     function owner() public view virtual returns (address) {
536         return _owner;
537     }
538 
539     /**
540     * @dev Throws if called by any account other than the owner.
541     */
542     modifier onlyOwner() {
543         require(owner() == _msgSender(), "Ownable: caller is not the owner");
544         _;
545     }
546 
547     /**
548     * @dev Leaves the contract without owner. It will not be possible to call
549     * `onlyOwner` functions anymore. Can only be called by the current owner.
550     *
551     * NOTE: Renouncing ownership will leave the contract without an owner,
552     * thereby removing any functionality that is only available to the owner.
553     */
554     function renounceOwnership() public virtual onlyOwner {
555         emit OwnershipTransferred(_owner, address(0));
556         _owner = address(0);
557     }
558 
559     /**
560     * @dev Transfers ownership of the contract to a new account (`newOwner`).
561     * Can only be called by the current owner.
562     */
563     function transferOwnership(address newOwner) public virtual onlyOwner {
564         require(newOwner != address(0), "Ownable: new owner is the zero address");
565         emit OwnershipTransferred(_owner, newOwner);
566         _owner = newOwner;
567     }
568 }
569 
570 interface IUniswapV2Factory {
571     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
572 
573     function feeTo() external view returns (address);
574     function feeToSetter() external view returns (address);
575 
576     function getPair(address tokenA, address tokenB) external view returns (address pair);
577     function allPairs(uint) external view returns (address pair);
578     function allPairsLength() external view returns (uint);
579 
580     function createPair(address tokenA, address tokenB) external returns (address pair);
581 
582     function setFeeTo(address) external;
583     function setFeeToSetter(address) external;
584 }
585 
586 interface IUniswapV2Pair {
587     event Approval(address indexed owner, address indexed spender, uint value);
588     event Transfer(address indexed from, address indexed to, uint value);
589 
590     function name() external pure returns (string memory);
591     function symbol() external pure returns (string memory);
592     function decimals() external pure returns (uint8);
593     function totalSupply() external view returns (uint);
594     function balanceOf(address owner) external view returns (uint);
595     function allowance(address owner, address spender) external view returns (uint);
596 
597     function approve(address spender, uint value) external returns (bool);
598     function transfer(address to, uint value) external returns (bool);
599     function transferFrom(address from, address to, uint value) external returns (bool);
600 
601     function DOMAIN_SEPARATOR() external view returns (bytes32);
602     function PERMIT_TYPEHASH() external pure returns (bytes32);
603     function nonces(address owner) external view returns (uint);
604 
605     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
606 
607     event Mint(address indexed sender, uint amount0, uint amount1);
608     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
609     event Swap(
610         address indexed sender,
611         uint amount0In,
612         uint amount1In,
613         uint amount0Out,
614         uint amount1Out,
615         address indexed to
616     );
617     event Sync(uint112 reserve0, uint112 reserve1);
618 
619     function MINIMUM_LIQUIDITY() external pure returns (uint);
620     function factory() external view returns (address);
621     function token0() external view returns (address);
622     function token1() external view returns (address);
623     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
624     function price0CumulativeLast() external view returns (uint);
625     function price1CumulativeLast() external view returns (uint);
626     function kLast() external view returns (uint);
627 
628     function mint(address to) external returns (uint liquidity);
629     function burn(address to) external returns (uint amount0, uint amount1);
630     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
631     function skim(address to) external;
632     function sync() external;
633 
634     function initialize(address, address) external;
635 }
636 
637 interface IUniswapV2Router01 {
638     function factory() external pure returns (address);
639     function WETH() external pure returns (address);
640 
641     function addLiquidity(
642         address tokenA,
643         address tokenB,
644         uint amountADesired,
645         uint amountBDesired,
646         uint amountAMin,
647         uint amountBMin,
648         address to,
649         uint deadline
650     ) external returns (uint amountA, uint amountB, uint liquidity);
651     function addLiquidityETH(
652         address token,
653         uint amountTokenDesired,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline
658     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
659     function removeLiquidity(
660         address tokenA,
661         address tokenB,
662         uint liquidity,
663         uint amountAMin,
664         uint amountBMin,
665         address to,
666         uint deadline
667     ) external returns (uint amountA, uint amountB);
668     function removeLiquidityETH(
669         address token,
670         uint liquidity,
671         uint amountTokenMin,
672         uint amountETHMin,
673         address to,
674         uint deadline
675     ) external returns (uint amountToken, uint amountETH);
676     function removeLiquidityWithPermit(
677         address tokenA,
678         address tokenB,
679         uint liquidity,
680         uint amountAMin,
681         uint amountBMin,
682         address to,
683         uint deadline,
684         bool approveMax, uint8 v, bytes32 r, bytes32 s
685     ) external returns (uint amountA, uint amountB);
686     function removeLiquidityETHWithPermit(
687         address token,
688         uint liquidity,
689         uint amountTokenMin,
690         uint amountETHMin,
691         address to,
692         uint deadline,
693         bool approveMax, uint8 v, bytes32 r, bytes32 s
694     ) external returns (uint amountToken, uint amountETH);
695     function swapExactTokensForTokens(
696         uint amountIn,
697         uint amountOutMin,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external returns (uint[] memory amounts);
702     function swapTokensForExactTokens(
703         uint amountOut,
704         uint amountInMax,
705         address[] calldata path,
706         address to,
707         uint deadline
708     ) external returns (uint[] memory amounts);
709     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
710         external
711         payable
712         returns (uint[] memory amounts);
713     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
714         external
715         returns (uint[] memory amounts);
716     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
717         external
718         returns (uint[] memory amounts);
719     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
720         external
721         payable
722         returns (uint[] memory amounts);
723 
724     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
725     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
726     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
727     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
728     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
729 }
730 
731 interface IUniswapV2Router02 is IUniswapV2Router01 {
732     function removeLiquidityETHSupportingFeeOnTransferTokens(
733         address token,
734         uint liquidity,
735         uint amountTokenMin,
736         uint amountETHMin,
737         address to,
738         uint deadline
739     ) external returns (uint amountETH);
740     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
741         address token,
742         uint liquidity,
743         uint amountTokenMin,
744         uint amountETHMin,
745         address to,
746         uint deadline,
747         bool approveMax, uint8 v, bytes32 r, bytes32 s
748     ) external returns (uint amountETH);
749 
750     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
751         uint amountIn,
752         uint amountOutMin,
753         address[] calldata path,
754         address to,
755         uint deadline
756     ) external;
757     function swapExactETHForTokensSupportingFeeOnTransferTokens(
758         uint amountOutMin,
759         address[] calldata path,
760         address to,
761         uint deadline
762     ) external payable;
763     function swapExactTokensForETHSupportingFeeOnTransferTokens(
764         uint amountIn,
765         uint amountOutMin,
766         address[] calldata path,
767         address to,
768         uint deadline
769     ) external;
770 }
771 
772 // contract implementation
773 contract RugRelief is Context, IERC20, Ownable {
774     using SafeMath for uint256;
775     using Address for address;
776 
777     uint8 private _decimals = 9;
778 
779     // 
780     string private _name = "RugRelief";                                         // name
781     string private _symbol = "RR";                                              // symbol
782     uint256 private _tTotal = 1000 * 10**9 * 10**uint256(_decimals);            // total supply
783 
784     // % to holders
785     uint256 public defaultTaxFee = 2;
786     uint256 public _taxFee = defaultTaxFee;
787     uint256 private _previousTaxFee = _taxFee;
788 
789     // % to swap & send to marketing wallet
790     uint256 public defaultMarketingFee = 4;
791     uint256 public _marketingFee = defaultMarketingFee;
792     uint256 private _previousMarketingFee = _marketingFee;
793 
794     uint256 public _marketingFee4Sellers = 8;
795 
796     bool public feesOnSellersAndBuyers = true;
797 
798     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
799     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
800     address payable public marketingWallet = payable(0x149eBF0dEf03E43aA3B312a8dF2df50c881067CB);   // RugRelief Wallet
801 
802     //
803 
804     mapping (address => uint256) private _rOwned;
805     mapping (address => uint256) private _tOwned;
806     mapping (address => mapping (address => uint256)) private _allowances;
807 
808     mapping (address => bool) private _isExcludedFromFee;
809 
810     mapping (address => bool) private _isExcluded;
811 
812     address[] private _excluded;
813     uint256 private constant MAX = ~uint256(0);
814 
815     uint256 private _tFeeTotal;
816     uint256 private _rTotal = (MAX - (MAX % _tTotal));
817 
818     IUniswapV2Router02 public immutable uniswapV2Router;
819     address public immutable uniswapV2Pair;
820 
821     bool inSwapAndSend;
822     bool public SwapAndSendEnabled = true;
823 
824     event SwapAndSendEnabledUpdated(bool enabled);
825 
826     modifier lockTheSwap {
827         inSwapAndSend = true;
828         _;
829         inSwapAndSend = false;
830     }
831 
832     constructor () {
833         _rOwned[_msgSender()] = _rTotal;
834 
835         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
836          // Create a uniswap pair for this new token
837         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
838             .createPair(address(this), _uniswapV2Router.WETH());
839 
840         // set the rest of the contract variables
841         uniswapV2Router = _uniswapV2Router;
842 
843         //exclude owner and this contract from fee
844         _isExcludedFromFee[owner()] = true;
845         _isExcludedFromFee[address(this)] = true;
846 
847         emit Transfer(address(0), _msgSender(), _tTotal);
848     }
849 
850     function name() public view returns (string memory) {
851         return _name;
852     }
853 
854     function symbol() public view returns (string memory) {
855         return _symbol;
856     }
857 
858     function decimals() public view returns (uint8) {
859         return _decimals;
860     }
861 
862     function totalSupply() public view override returns (uint256) {
863         return _tTotal;
864     }
865 
866     function balanceOf(address account) public view override returns (uint256) {
867         if (_isExcluded[account]) return _tOwned[account];
868         return tokenFromReflection(_rOwned[account]);
869     }
870 
871     function transfer(address recipient, uint256 amount) public override returns (bool) {
872         _transfer(_msgSender(), recipient, amount);
873         return true;
874     }
875 
876     function allowance(address owner, address spender) public view override returns (uint256) {
877         return _allowances[owner][spender];
878     }
879 
880     function approve(address spender, uint256 amount) public override returns (bool) {
881         _approve(_msgSender(), spender, amount);
882         return true;
883     }
884 
885     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
886         _transfer(sender, recipient, amount);
887         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
888         return true;
889     }
890 
891     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
892         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
893         return true;
894     }
895 
896     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
897         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
898         return true;
899     }
900 
901     function isExcludedFromReward(address account) public view returns (bool) {
902         return _isExcluded[account];
903     }
904 
905     function totalFees() public view returns (uint256) {
906         return _tFeeTotal;
907     }
908 
909     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
910         require(tAmount <= _tTotal, "Amount must be less than supply");
911         if (!deductTransferFee) {
912             (uint256 rAmount,,,,,) = _getValues(tAmount);
913             return rAmount;
914         } else {
915             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
916             return rTransferAmount;
917         }
918     }
919 
920     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
921         require(rAmount <= _rTotal, "Amount must be less than total reflections");
922         uint256 currentRate =  _getRate();
923         return rAmount.div(currentRate);
924     }
925 
926     function excludeFromReward(address account) public onlyOwner() {
927         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
928         require(!_isExcluded[account], "Account is already excluded");
929         if(_rOwned[account] > 0) {
930             _tOwned[account] = tokenFromReflection(_rOwned[account]);
931         }
932         _isExcluded[account] = true;
933         _excluded.push(account);
934     }
935 
936     function includeInReward(address account) external onlyOwner() {
937         require(_isExcluded[account], "Account is already excluded");
938         for (uint256 i = 0; i < _excluded.length; i++) {
939             if (_excluded[i] == account) {
940                 _excluded[i] = _excluded[_excluded.length - 1];
941                 _tOwned[account] = 0;
942                 _isExcluded[account] = false;
943                 _excluded.pop();
944                 break;
945             }
946         }
947     }
948 
949     function excludeFromFee(address account) public onlyOwner() {
950         _isExcludedFromFee[account] = true;
951     }
952 
953     function includeInFee(address account) public onlyOwner() {
954         _isExcludedFromFee[account] = false;
955     }
956 
957     function removeAllFee() private {
958         if(_taxFee == 0 && _marketingFee == 0) return;
959 
960         _previousTaxFee = _taxFee;
961         _previousMarketingFee = _marketingFee;
962 
963         _taxFee = 0;
964         _marketingFee = 0;
965     }
966 
967     function restoreAllFee() private {
968         _taxFee = _previousTaxFee;
969         _marketingFee = _previousMarketingFee;
970     }
971 
972     //to recieve ETH
973     receive() external payable {}
974 
975     function _reflectFee(uint256 rFee, uint256 tFee) private {
976         _rTotal = _rTotal.sub(rFee);
977         _tFeeTotal = _tFeeTotal.add(tFee);
978     }
979 
980     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
981         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
982         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
983         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
984     }
985 
986     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
987         uint256 tFee = calculateTaxFee(tAmount);
988         uint256 tMarketing = calculateMarketingFee(tAmount);
989         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
990         return (tTransferAmount, tFee, tMarketing);
991     }
992 
993     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
994         uint256 rAmount = tAmount.mul(currentRate);
995         uint256 rFee = tFee.mul(currentRate);
996         uint256 rMarketing = tMarketing.mul(currentRate);
997         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
998         return (rAmount, rTransferAmount, rFee);
999     }
1000 
1001     function _getRate() private view returns(uint256) {
1002         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1003         return rSupply.div(tSupply);
1004     }
1005 
1006     function _getCurrentSupply() private view returns(uint256, uint256) {
1007         uint256 rSupply = _rTotal;
1008         uint256 tSupply = _tTotal;
1009         for (uint256 i = 0; i < _excluded.length; i++) {
1010             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1011             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1012             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1013         }
1014         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1015         return (rSupply, tSupply);
1016     }
1017 
1018     function _takeMarketing(uint256 tMarketing) private {
1019         uint256 currentRate =  _getRate();
1020         uint256 rMarketing = tMarketing.mul(currentRate);
1021         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1022         if(_isExcluded[address(this)])
1023             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1024     }
1025 
1026     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1027         return _amount.mul(_taxFee).div(
1028             10**2
1029         );
1030     }
1031 
1032     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1033         return _amount.mul(_marketingFee).div(
1034             10**2
1035         );
1036     }
1037 
1038     function isExcludedFromFee(address account) public view returns(bool) {
1039         return _isExcludedFromFee[account];
1040     }
1041 
1042     function _approve(address owner, address spender, uint256 amount) private {
1043         require(owner != address(0), "ERC20: approve from the zero address");
1044         require(spender != address(0), "ERC20: approve to the zero address");
1045 
1046         _allowances[owner][spender] = amount;
1047         emit Approval(owner, spender, amount);
1048     }
1049 
1050     function _transfer(
1051         address from,
1052         address to,
1053         uint256 amount
1054     ) private {
1055         require(from != address(0), "ERC20: transfer from the zero address");
1056         require(to != address(0), "ERC20: transfer to the zero address");
1057         require(amount > 0, "Transfer amount must be greater than zero");
1058 
1059         if(from != owner() && to != owner())
1060             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1061 
1062         // is the token balance of this contract address over the min number of
1063         // tokens that we need to initiate a swap + send lock?
1064         // also, don't get caught in a circular sending event.
1065         // also, don't swap & liquify if sender is uniswap pair.
1066         uint256 contractTokenBalance = balanceOf(address(this));
1067         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1068 
1069         if(contractTokenBalance >= _maxTxAmount)
1070         {
1071             contractTokenBalance = _maxTxAmount;
1072         }
1073 
1074         if (
1075             overMinTokenBalance &&
1076             !inSwapAndSend &&
1077             from != uniswapV2Pair &&
1078             SwapAndSendEnabled
1079         ) {
1080             SwapAndSend(contractTokenBalance);
1081         }
1082 
1083         if(feesOnSellersAndBuyers) {
1084             setFees(to);
1085         }
1086 
1087         //indicates if fee should be deducted from transfer
1088         bool takeFee = true;
1089 
1090         //if any account belongs to _isExcludedFromFee account then remove the fee
1091         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1092             takeFee = false;
1093         }
1094 
1095         _tokenTransfer(from,to,amount,takeFee);
1096     }
1097 
1098     function setFees(address recipient) private {
1099         _taxFee = defaultTaxFee;
1100         _marketingFee = defaultMarketingFee;
1101         if (recipient == uniswapV2Pair) { // sell
1102             _marketingFee = _marketingFee4Sellers;
1103         }
1104     }
1105 
1106     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1107         // generate the uniswap pair path of token -> weth
1108         address[] memory path = new address[](2);
1109         path[0] = address(this);
1110         path[1] = uniswapV2Router.WETH();
1111 
1112         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1113 
1114         // make the swap
1115         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1116             contractTokenBalance,
1117             0, // accept any amount of ETH
1118             path,
1119             address(this),
1120             block.timestamp
1121         );
1122 
1123         uint256 contractETHBalance = address(this).balance;
1124         if(contractETHBalance > 0) {
1125             marketingWallet.transfer(contractETHBalance);
1126         }
1127     }
1128 
1129     //this method is responsible for taking all fee, if takeFee is true
1130     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1131         if(!takeFee)
1132             removeAllFee();
1133 
1134         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1135             _transferFromExcluded(sender, recipient, amount);
1136         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1137             _transferToExcluded(sender, recipient, amount);
1138         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1139             _transferStandard(sender, recipient, amount);
1140         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1141             _transferBothExcluded(sender, recipient, amount);
1142         } else {
1143             _transferStandard(sender, recipient, amount);
1144         }
1145 
1146         if(!takeFee)
1147             restoreAllFee();
1148     }
1149 
1150     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1151         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1152         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1153         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1154         _takeMarketing(tMarketing);
1155         _reflectFee(rFee, tFee);
1156         emit Transfer(sender, recipient, tTransferAmount);
1157     }
1158 
1159     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1161         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1162         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1163         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1164         _takeMarketing(tMarketing);
1165         _reflectFee(rFee, tFee);
1166         emit Transfer(sender, recipient, tTransferAmount);
1167     }
1168 
1169     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1170         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1171         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1172         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1173         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1174         _takeMarketing(tMarketing);
1175         _reflectFee(rFee, tFee);
1176         emit Transfer(sender, recipient, tTransferAmount);
1177     }
1178 
1179     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1180         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1181         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1182         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1183         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1184         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1185         _takeMarketing(tMarketing);
1186         _reflectFee(rFee, tFee);
1187         emit Transfer(sender, recipient, tTransferAmount);
1188     }
1189 
1190     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1191         defaultMarketingFee = marketingFee;
1192     }
1193 
1194     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1195         _marketingFee4Sellers = marketingFee4Sellers;
1196     }
1197 
1198     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1199         feesOnSellersAndBuyers = _enabled;
1200     }
1201 
1202     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1203         SwapAndSendEnabled = _enabled;
1204         emit SwapAndSendEnabledUpdated(_enabled);
1205     }
1206 
1207     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1208         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1209     }
1210 
1211     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1212         marketingWallet = wallet;
1213     }
1214 
1215     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1216         _maxTxAmount = maxTxAmount;
1217     }
1218 }