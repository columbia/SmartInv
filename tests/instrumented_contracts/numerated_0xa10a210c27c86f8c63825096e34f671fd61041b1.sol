1 pragma solidity ^0.8.3;
2 // SPDX-License-Identifier: Unlicensed
3 
4 /*
5 
6 JEFF IN SPACE v2
7 
8 Telegram: https://t.me/jeffinspaceofficial
9 Website: jeffin.space
10 */
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17     * @dev Returns the amount of tokens in existence.
18     */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22     * @dev Returns the amount of tokens owned by `account`.
23     */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27     * @dev Moves `amount` tokens from the caller's account to `recipient`.
28     *
29     * Returns a boolean value indicating whether the operation succeeded.
30     *
31     * Emits a {Transfer} event.
32     */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36     * @dev Returns the remaining number of tokens that `spender` will be
37     * allowed to spend on behalf of `owner` through {transferFrom}. This is
38     * zero by default.
39     *
40     * This value changes when {approve} or {transferFrom} are called.
41     */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46     *
47     * Returns a boolean value indicating whether the operation succeeded.
48     *
49     * IMPORTANT: Beware that changing an allowance with this method brings the risk
50     * that someone may use both the old and the new allowance by unfortunate
51     * transaction ordering. One possible solution to mitigate this race
52     * condition is to first reduce the spender's allowance to 0 and set the
53     * desired value afterwards:
54     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55     *
56     * Emits an {Approval} event.
57     */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61     * @dev Moves `amount` tokens from `sender` to `recipient` using the
62     * allowance mechanism. `amount` is then deducted from the caller's
63     * allowance.
64     *
65     * Returns a boolean value indicating whether the operation succeeded.
66     *
67     * Emits a {Transfer} event.
68     */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72     * @dev Emitted when `value` tokens are moved from one account (`from`) to
73     * another (`to`).
74     *
75     * Note that `value` may be zero.
76     */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81     * a call to {approve}. `value` is the new allowance.
82     */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // CAUTION
87 // This version of SafeMath should only be used with Solidity 0.8 or later,
88 // because it relies on the compiler's built in overflow checks.
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations.
92  *
93  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
94  * now has built in overflow checking.
95  */
96 library SafeMath {
97     /**
98     * @dev Returns the addition of two unsigned integers, with an overflow flag.
99     *
100     * _Available since v3.4._
101     */
102     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             uint256 c = a + b;
105             if (c < a) return (false, 0);
106             return (true, c);
107         }
108     }
109 
110     /**
111     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
112     *
113     * _Available since v3.4._
114     */
115     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         unchecked {
117             if (b > a) return (false, 0);
118             return (true, a - b);
119         }
120     }
121 
122     /**
123     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
124     *
125     * _Available since v3.4._
126     */
127     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         unchecked {
129             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130             // benefit is lost if 'b' is also tested.
131             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132             if (a == 0) return (true, 0);
133             uint256 c = a * b;
134             if (c / a != b) return (false, 0);
135             return (true, c);
136         }
137     }
138 
139     /**
140     * @dev Returns the division of two unsigned integers, with a division by zero flag.
141     *
142     * _Available since v3.4._
143     */
144     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         unchecked {
146             if (b == 0) return (false, 0);
147             return (true, a / b);
148         }
149     }
150 
151     /**
152     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
153     *
154     * _Available since v3.4._
155     */
156     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         unchecked {
158             if (b == 0) return (false, 0);
159             return (true, a % b);
160         }
161     }
162 
163     /**
164     * @dev Returns the addition of two unsigned integers, reverting on
165     * overflow.
166     *
167     * Counterpart to Solidity's `+` operator.
168     *
169     * Requirements:
170     *
171     * - Addition cannot overflow.
172     */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a + b;
175     }
176 
177     /**
178     * @dev Returns the subtraction of two unsigned integers, reverting on
179     * overflow (when the result is negative).
180     *
181     * Counterpart to Solidity's `-` operator.
182     *
183     * Requirements:
184     *
185     * - Subtraction cannot overflow.
186     */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a - b;
189     }
190 
191     /**
192     * @dev Returns the multiplication of two unsigned integers, reverting on
193     * overflow.
194     *
195     * Counterpart to Solidity's `*` operator.
196     *
197     * Requirements:
198     *
199     * - Multiplication cannot overflow.
200     */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a * b;
203     }
204 
205     /**
206     * @dev Returns the integer division of two unsigned integers, reverting on
207     * division by zero. The result is rounded towards zero.
208     *
209     * Counterpart to Solidity's `/` operator.
210     *
211     * Requirements:
212     *
213     * - The divisor cannot be zero.
214     */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return a / b;
217     }
218 
219     /**
220     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221     * reverting when dividing by zero.
222     *
223     * Counterpart to Solidity's `%` operator. This function uses a `revert`
224     * opcode (which leaves remaining gas untouched) while Solidity uses an
225     * invalid opcode to revert (consuming all remaining gas).
226     *
227     * Requirements:
228     *
229     * - The divisor cannot be zero.
230     */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a % b;
233     }
234 
235     /**
236     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237     * overflow (when the result is negative).
238     *
239     * CAUTION: This function is deprecated because it requires allocating memory for the error
240     * message unnecessarily. For custom revert reasons use {trySub}.
241     *
242     * Counterpart to Solidity's `-` operator.
243     *
244     * Requirements:
245     *
246     * - Subtraction cannot overflow.
247     */
248     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         unchecked {
250             require(b <= a, errorMessage);
251             return a - b;
252         }
253     }
254 
255     /**
256     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
257     * division by zero. The result is rounded towards zero.
258     *
259     * Counterpart to Solidity's `%` operator. This function uses a `revert`
260     * opcode (which leaves remaining gas untouched) while Solidity uses an
261     * invalid opcode to revert (consuming all remaining gas).
262     *
263     * Counterpart to Solidity's `/` operator. Note: this function uses a
264     * `revert` opcode (which leaves remaining gas untouched) while Solidity
265     * uses an invalid opcode to revert (consuming all remaining gas).
266     *
267     * Requirements:
268     *
269     * - The divisor cannot be zero.
270     */
271     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         unchecked {
273             require(b > 0, errorMessage);
274             return a / b;
275         }
276     }
277 
278     /**
279     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280     * reverting with custom message when dividing by zero.
281     *
282     * CAUTION: This function is deprecated because it requires allocating memory for the error
283     * message unnecessarily. For custom revert reasons use {tryMod}.
284     *
285     * Counterpart to Solidity's `%` operator. This function uses a `revert`
286     * opcode (which leaves remaining gas untouched) while Solidity uses an
287     * invalid opcode to revert (consuming all remaining gas).
288     *
289     * Requirements:
290     *
291     * - The divisor cannot be zero.
292     */
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         unchecked {
295             require(b > 0, errorMessage);
296             return a % b;
297         }
298     }
299 }
300 
301 /*
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
318         return msg.data;
319     }
320 }
321 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327     * @dev Returns true if `account` is a contract.
328     *
329     * [IMPORTANT]
330     * ====
331     * It is unsafe to assume that an address for which this function returns
332     * false is an externally-owned account (EOA) and not a contract.
333     *
334     * Among others, `isContract` will return false for the following
335     * types of addresses:
336     *
337     *  - an externally-owned account
338     *  - a contract in construction
339     *  - an address where a contract will be created
340     *  - an address where a contract lived, but was destroyed
341     * ====
342     */
343     function isContract(address account) internal view returns (bool) {
344         // This method relies on extcodesize, which returns 0 for contracts in
345         // construction, since the code is only stored at the end of the
346         // constructor execution.
347 
348         uint256 size;
349         // solhint-disable-next-line no-inline-assembly
350         assembly { size := extcodesize(account) }
351         return size > 0;
352     }
353 
354     /**
355     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
356     * `recipient`, forwarding all available gas and reverting on errors.
357     *
358     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
359     * of certain opcodes, possibly making contracts go over the 2300 gas limit
360     * imposed by `transfer`, making them unable to receive funds via
361     * `transfer`. {sendValue} removes this limitation.
362     *
363     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
364     *
365     * IMPORTANT: because control is transferred to `recipient`, care must be
366     * taken to not create reentrancy vulnerabilities. Consider using
367     * {ReentrancyGuard} or the
368     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
369     */
370     function sendValue(address payable recipient, uint256 amount) internal {
371         require(address(this).balance >= amount, "Address: insufficient balance");
372 
373         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
374         (bool success, ) = recipient.call{ value: amount }("");
375         require(success, "Address: unable to send value, recipient may have reverted");
376     }
377 
378     /**
379     * @dev Performs a Solidity function call using a low level `call`. A
380     * plain`call` is an unsafe replacement for a function call: use this
381     * function instead.
382     *
383     * If `target` reverts with a revert reason, it is bubbled up by this
384     * function (like regular Solidity function calls).
385     *
386     * Returns the raw returned data. To convert to the expected return value,
387     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388     *
389     * Requirements:
390     *
391     * - `target` must be a contract.
392     * - calling `target` with `data` must not revert.
393     *
394     * _Available since v3.1._
395     */
396     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
397       return functionCall(target, data, "Address: low-level call failed");
398     }
399 
400     /**
401     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402     * `errorMessage` as a fallback revert reason when `target` reverts.
403     *
404     * _Available since v3.1._
405     */
406     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, 0, errorMessage);
408     }
409 
410     /**
411     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412     * but also transferring `value` wei to `target`.
413     *
414     * Requirements:
415     *
416     * - the calling contract must have an ETH balance of at least `value`.
417     * - the called Solidity function must be `payable`.
418     *
419     * _Available since v3.1._
420     */
421     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
423     }
424 
425     /**
426     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
427     * with `errorMessage` as a fallback revert reason when `target` reverts.
428     *
429     * _Available since v3.1._
430     */
431     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
432         require(address(this).balance >= value, "Address: insufficient balance for call");
433         require(isContract(target), "Address: call to non-contract");
434 
435         // solhint-disable-next-line avoid-low-level-calls
436         (bool success, bytes memory returndata) = target.call{ value: value }(data);
437         return _verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442     * but performing a static call.
443     *
444     * _Available since v3.3._
445     */
446     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
447         return functionStaticCall(target, data, "Address: low-level static call failed");
448     }
449 
450     /**
451     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452     * but performing a static call.
453     *
454     * _Available since v3.3._
455     */
456     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
457         require(isContract(target), "Address: static call to non-contract");
458 
459         // solhint-disable-next-line avoid-low-level-calls
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return _verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466     * but performing a delegate call.
467     *
468     * _Available since v3.4._
469     */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473 
474     /**
475     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476     * but performing a delegate call.
477     *
478     * _Available since v3.4._
479     */
480     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
481         require(isContract(target), "Address: delegate call to non-contract");
482 
483         // solhint-disable-next-line avoid-low-level-calls
484         (bool success, bytes memory returndata) = target.delegatecall(data);
485         return _verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
489         if (success) {
490             return returndata;
491         } else {
492             // Look for revert reason and bubble it up if present
493             if (returndata.length > 0) {
494                 // The easiest way to bubble the revert reason is using memory via assembly
495 
496                 // solhint-disable-next-line no-inline-assembly
497                 assembly {
498                     let returndata_size := mload(returndata)
499                     revert(add(32, returndata), returndata_size)
500                 }
501             } else {
502                 revert(errorMessage);
503             }
504         }
505     }
506 }
507 
508 /**
509  * @dev Contract module which provides a basic access control mechanism, where
510  * there is an account (an owner) that can be granted exclusive access to
511  * specific functions.
512  *
513  * By default, the owner account will be the one that deploys the contract. This
514  * can later be changed with {transferOwnership}.
515  *
516  * This module is used through inheritance. It will make available the modifier
517  * `onlyOwner`, which can be applied to your functions to restrict their use to
518  * the owner.
519  */
520 abstract contract Ownable is Context {
521     address private _owner;
522 
523     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
524 
525     /**
526     * @dev Initializes the contract setting the deployer as the initial owner.
527     */
528     constructor () {
529         _owner = _msgSender();
530         emit OwnershipTransferred(address(0), _owner);
531     }
532 
533     /**
534     * @dev Returns the address of the current owner.
535     */
536     function owner() public view virtual returns (address) {
537         return _owner;
538     }
539 
540     /**
541     * @dev Throws if called by any account other than the owner.
542     */
543     modifier onlyOwner() {
544         require(owner() == _msgSender(), "Ownable: caller is not the owner");
545         _;
546     }
547 
548     /**
549     * @dev Leaves the contract without owner. It will not be possible to call
550     * `onlyOwner` functions anymore. Can only be called by the current owner.
551     *
552     * NOTE: Renouncing ownership will leave the contract without an owner,
553     * thereby removing any functionality that is only available to the owner.
554     */
555     function renounceOwnership() public virtual onlyOwner {
556         emit OwnershipTransferred(_owner, address(0));
557         _owner = address(0);
558     }
559 
560     /**
561     * @dev Transfers ownership of the contract to a new account (`newOwner`).
562     * Can only be called by the current owner.
563     */
564     function transferOwnership(address newOwner) public virtual onlyOwner {
565         require(newOwner != address(0), "Ownable: new owner is the zero address");
566         emit OwnershipTransferred(_owner, newOwner);
567         _owner = newOwner;
568     }
569 }
570 
571 interface IUniswapV2Factory {
572     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
573 
574     function feeTo() external view returns (address);
575     function feeToSetter() external view returns (address);
576 
577     function getPair(address tokenA, address tokenB) external view returns (address pair);
578     function allPairs(uint) external view returns (address pair);
579     function allPairsLength() external view returns (uint);
580 
581     function createPair(address tokenA, address tokenB) external returns (address pair);
582 
583     function setFeeTo(address) external;
584     function setFeeToSetter(address) external;
585 }
586 
587 interface IUniswapV2Pair {
588     event Approval(address indexed owner, address indexed spender, uint value);
589     event Transfer(address indexed from, address indexed to, uint value);
590 
591     function name() external pure returns (string memory);
592     function symbol() external pure returns (string memory);
593     function decimals() external pure returns (uint8);
594     function totalSupply() external view returns (uint);
595     function balanceOf(address owner) external view returns (uint);
596     function allowance(address owner, address spender) external view returns (uint);
597 
598     function approve(address spender, uint value) external returns (bool);
599     function transfer(address to, uint value) external returns (bool);
600     function transferFrom(address from, address to, uint value) external returns (bool);
601 
602     function DOMAIN_SEPARATOR() external view returns (bytes32);
603     function PERMIT_TYPEHASH() external pure returns (bytes32);
604     function nonces(address owner) external view returns (uint);
605 
606     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
607 
608     event Mint(address indexed sender, uint amount0, uint amount1);
609     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
610     event Swap(
611         address indexed sender,
612         uint amount0In,
613         uint amount1In,
614         uint amount0Out,
615         uint amount1Out,
616         address indexed to
617     );
618     event Sync(uint112 reserve0, uint112 reserve1);
619 
620     function MINIMUM_LIQUIDITY() external pure returns (uint);
621     function factory() external view returns (address);
622     function token0() external view returns (address);
623     function token1() external view returns (address);
624     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
625     function price0CumulativeLast() external view returns (uint);
626     function price1CumulativeLast() external view returns (uint);
627     function kLast() external view returns (uint);
628 
629     function mint(address to) external returns (uint liquidity);
630     function burn(address to) external returns (uint amount0, uint amount1);
631     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
632     function skim(address to) external;
633     function sync() external;
634 
635     function initialize(address, address) external;
636 }
637 
638 interface IUniswapV2Router01 {
639     function factory() external pure returns (address);
640     function WETH() external pure returns (address);
641 
642     function addLiquidity(
643         address tokenA,
644         address tokenB,
645         uint amountADesired,
646         uint amountBDesired,
647         uint amountAMin,
648         uint amountBMin,
649         address to,
650         uint deadline
651     ) external returns (uint amountA, uint amountB, uint liquidity);
652     function addLiquidityETH(
653         address token,
654         uint amountTokenDesired,
655         uint amountTokenMin,
656         uint amountETHMin,
657         address to,
658         uint deadline
659     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
660     function removeLiquidity(
661         address tokenA,
662         address tokenB,
663         uint liquidity,
664         uint amountAMin,
665         uint amountBMin,
666         address to,
667         uint deadline
668     ) external returns (uint amountA, uint amountB);
669     function removeLiquidityETH(
670         address token,
671         uint liquidity,
672         uint amountTokenMin,
673         uint amountETHMin,
674         address to,
675         uint deadline
676     ) external returns (uint amountToken, uint amountETH);
677     function removeLiquidityWithPermit(
678         address tokenA,
679         address tokenB,
680         uint liquidity,
681         uint amountAMin,
682         uint amountBMin,
683         address to,
684         uint deadline,
685         bool approveMax, uint8 v, bytes32 r, bytes32 s
686     ) external returns (uint amountA, uint amountB);
687     function removeLiquidityETHWithPermit(
688         address token,
689         uint liquidity,
690         uint amountTokenMin,
691         uint amountETHMin,
692         address to,
693         uint deadline,
694         bool approveMax, uint8 v, bytes32 r, bytes32 s
695     ) external returns (uint amountToken, uint amountETH);
696     function swapExactTokensForTokens(
697         uint amountIn,
698         uint amountOutMin,
699         address[] calldata path,
700         address to,
701         uint deadline
702     ) external returns (uint[] memory amounts);
703     function swapTokensForExactTokens(
704         uint amountOut,
705         uint amountInMax,
706         address[] calldata path,
707         address to,
708         uint deadline
709     ) external returns (uint[] memory amounts);
710     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
711         external
712         payable
713         returns (uint[] memory amounts);
714     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
715         external
716         returns (uint[] memory amounts);
717     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
718         external
719         returns (uint[] memory amounts);
720     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
721         external
722         payable
723         returns (uint[] memory amounts);
724 
725     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
726     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
727     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
728     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
729     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
730 }
731 
732 interface IUniswapV2Router02 is IUniswapV2Router01 {
733     function removeLiquidityETHSupportingFeeOnTransferTokens(
734         address token,
735         uint liquidity,
736         uint amountTokenMin,
737         uint amountETHMin,
738         address to,
739         uint deadline
740     ) external returns (uint amountETH);
741     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
742         address token,
743         uint liquidity,
744         uint amountTokenMin,
745         uint amountETHMin,
746         address to,
747         uint deadline,
748         bool approveMax, uint8 v, bytes32 r, bytes32 s
749     ) external returns (uint amountETH);
750 
751     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
752         uint amountIn,
753         uint amountOutMin,
754         address[] calldata path,
755         address to,
756         uint deadline
757     ) external;
758     function swapExactETHForTokensSupportingFeeOnTransferTokens(
759         uint amountOutMin,
760         address[] calldata path,
761         address to,
762         uint deadline
763     ) external payable;
764     function swapExactTokensForETHSupportingFeeOnTransferTokens(
765         uint amountIn,
766         uint amountOutMin,
767         address[] calldata path,
768         address to,
769         uint deadline
770     ) external;
771 }
772 
773 // contract implementation
774 contract JeffInSpace is Context, IERC20, Ownable {
775     using SafeMath for uint256;
776     using Address for address;
777 
778     uint8 private _decimals = 9;
779 
780     // ********************************* START VARIABLES **********************************
781     string private _name = "JEFF IN SPACE"; // name
782     string private _symbol = "JEFF"; // symbol
783     uint256 private _tTotal = 2441441441440 * 10**uint256(_decimals); // total supply
784 
785     // % to holders
786     uint256 public defaultTaxFee = 2;
787     uint256 public _taxFee = defaultTaxFee;
788     uint256 private _previousTaxFee = _taxFee;
789 
790     // % to swap & send to marketing wallet
791     uint256 public defaultMarketingFee = 6;
792     uint256 public _marketingFee = defaultMarketingFee;
793     uint256 private _previousMarketingFee = _marketingFee;
794 
795     uint256 public _marketingFee4Sellers = 6;
796 
797     bool public feesOnSellersAndBuyers = true;
798 
799     uint256 public _maxTxAmount = _tTotal.div(1).div(100); // max transaction amount
800     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100); // contract balance to trigger swap & send
801 
802     address payable private _teamWalletAddress;
803     address payable private _marketingWalletAddress;
804 
805     // ********************************** END VARIABLES ***********************************
806 
807     mapping (address => uint256) private _rOwned;
808     mapping (address => uint256) private _tOwned;
809     mapping (address => mapping (address => uint256)) private _allowances;
810 
811     mapping (address => bool) private _isExcludedFromFee;
812 
813     mapping (address => bool) private _isExcluded;
814     
815     mapping (address => bool) private _isBlackListedBot;
816     address[] private _blackListedBots;
817 
818     address[] private _excluded;
819     uint256 private constant MAX = ~uint256(0);
820 
821     uint256 private _tFeeTotal;
822     uint256 private _rTotal = (MAX - (MAX % _tTotal));
823 
824     IUniswapV2Router02 public immutable uniswapV2Router;
825     address public immutable uniswapV2Pair;
826 
827     bool inSwapAndSend;
828     bool public SwapAndSendEnabled = true;        
829     bool public tradingEnabled = false;
830 
831     event SwapAndSendEnabledUpdated(bool enabled);
832 
833     modifier lockTheSwap {
834         inSwapAndSend = true;
835         _;
836         inSwapAndSend = false;
837     }
838 
839     constructor (address payable teamWalletAddress, address payable marketingWalletAddress) {
840         
841         _teamWalletAddress = teamWalletAddress;
842         _marketingWalletAddress = marketingWalletAddress;
843         
844         _rOwned[_msgSender()] = _rTotal;
845 
846         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
847          // Create a uniswap pair for this new token
848         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
849             .createPair(address(this), _uniswapV2Router.WETH());
850 
851         // set the rest of the contract variables
852         uniswapV2Router = _uniswapV2Router;
853 
854         //exclude owner and this contract from fee
855         _isExcludedFromFee[owner()] = true;
856         _isExcludedFromFee[address(this)] = true;
857 
858         _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
859         _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
860         
861         _isBlackListedBot[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
862         _blackListedBots.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
863         
864         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
865         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
866         
867         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
868         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
869 
870         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
871         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
872 
873         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
874         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
875 
876         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
877         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
878 
879         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
880         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
881 
882         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
883         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
884 
885         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
886         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
887 
888         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
889         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
890         
891         _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
892         _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
893         
894         _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
895         _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
896         
897         _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
898         _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
899         
900         _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
901         _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));
902 
903         _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
904         _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
905         
906         _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
907         _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
908         
909         _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
910         _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
911         
912         _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
913         _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
914         
915         _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
916         _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
917         
918         _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
919         _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
920         
921         _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
922         _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
923         
924         _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
925         _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
926         
927         _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
928         _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
929         
930         _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
931         _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
932         
933         _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
934         _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
935         
936         _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
937         _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
938 
939         _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
940         _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
941         
942         _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
943         _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
944         
945         _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
946         _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
947 
948         _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
949         _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
950 
951         _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
952         _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
953 
954         _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
955         _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
956         
957         _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
958         _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
959         
960         _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
961         _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
962         
963         _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
964         _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
965   
966         emit Transfer(address(0), _msgSender(), _tTotal);
967     }
968 
969     function name() public view returns (string memory) {
970         return _name;
971     }
972 
973     function symbol() public view returns (string memory) {
974         return _symbol;
975     }
976 
977     function decimals() public view returns (uint8) {
978         return _decimals;
979     }
980 
981     function totalSupply() public view override returns (uint256) {
982         return _tTotal;
983     }
984 
985     function balanceOf(address account) public view override returns (uint256) {
986         if (_isExcluded[account]) return _tOwned[account];
987         return tokenFromReflection(_rOwned[account]);
988     }
989 
990     function transfer(address recipient, uint256 amount) public override returns (bool) {
991         _transfer(_msgSender(), recipient, amount);
992         return true;
993     }
994 
995     function allowance(address owner, address spender) public view override returns (uint256) {
996         return _allowances[owner][spender];
997     }
998 
999     function approve(address spender, uint256 amount) public override returns (bool) {
1000         _approve(_msgSender(), spender, amount);
1001         return true;
1002     }
1003 
1004     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1005         _transfer(sender, recipient, amount);
1006         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1007         return true;
1008     }
1009 
1010     function addBotToBlackList(address account) external onlyOwner() {
1011         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
1012         require(!_isBlackListedBot[account], "Account is already blacklisted");
1013         _isBlackListedBot[account] = true;
1014         _blackListedBots.push(account);
1015     }
1016     
1017     function removeBotFromBlackList(address account) external onlyOwner() {
1018         require(_isBlackListedBot[account], "Account is not blacklisted");
1019         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1020             if (_blackListedBots[i] == account) {
1021                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
1022                 _isBlackListedBot[account] = false;
1023                 _blackListedBots.pop();
1024                 break;
1025             }
1026         }
1027     }
1028 
1029     function isBlackListed(address account) public view returns (bool) {
1030         return _isBlackListedBot[account];
1031     }
1032 
1033     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1034         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1035         return true;
1036     }
1037 
1038     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1039         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1040         return true;
1041     }
1042 
1043     function isExcludedFromReward(address account) public view returns (bool) {
1044         return _isExcluded[account];
1045     }
1046 
1047     function totalFees() public view returns (uint256) {
1048         return _tFeeTotal;
1049     }
1050 
1051     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1052         require(tAmount <= _tTotal, "Amount must be less than supply");
1053         if (!deductTransferFee) {
1054             (uint256 rAmount,,,,,) = _getValues(tAmount);
1055             return rAmount;
1056         } else {
1057             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
1058             return rTransferAmount;
1059         }
1060     }
1061 
1062     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1063         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1064         uint256 currentRate =  _getRate();
1065         return rAmount.div(currentRate);
1066     }
1067 
1068     function excludeFromReward(address account) public onlyOwner() {
1069         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1070         require(!_isExcluded[account], "Account is already excluded");
1071         if(_rOwned[account] > 0) {
1072             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1073         }
1074         _isExcluded[account] = true;
1075         _excluded.push(account);
1076     }
1077 
1078     function includeInReward(address account) external onlyOwner() {
1079         require(_isExcluded[account], "Account is already excluded");
1080         for (uint256 i = 0; i < _excluded.length; i++) {
1081             if (_excluded[i] == account) {
1082                 _excluded[i] = _excluded[_excluded.length - 1];
1083                 _tOwned[account] = 0;
1084                 _isExcluded[account] = false;
1085                 _excluded.pop();
1086                 break;
1087             }
1088         }
1089     }
1090 
1091     function excludeFromFee(address account) public onlyOwner() {
1092         _isExcludedFromFee[account] = true;
1093     }
1094 
1095     function includeInFee(address account) public onlyOwner() {
1096         _isExcludedFromFee[account] = false;
1097     }
1098 
1099     function removeAllFee() private {
1100         if(_taxFee == 0 && _marketingFee == 0) return;
1101 
1102         _previousTaxFee = _taxFee;
1103         _previousMarketingFee = _marketingFee;
1104 
1105         _taxFee = 0;
1106         _marketingFee = 0;
1107     }
1108 
1109     function restoreAllFee() private {
1110         _taxFee = _previousTaxFee;
1111         _marketingFee = _previousMarketingFee;
1112     }
1113 
1114     //to recieve ETH when swaping
1115     receive() external payable {}
1116 
1117     function _reflectFee(uint256 rFee, uint256 tFee) private {
1118         _rTotal = _rTotal.sub(rFee);
1119         _tFeeTotal = _tFeeTotal.add(tFee);
1120     }
1121 
1122     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1123         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
1124         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
1125         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
1126     }
1127 
1128     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1129         uint256 tFee = calculateTaxFee(tAmount);
1130         uint256 tMarketing = calculateMarketingFee(tAmount);
1131         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
1132         return (tTransferAmount, tFee, tMarketing);
1133     }
1134 
1135     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1136         uint256 rAmount = tAmount.mul(currentRate);
1137         uint256 rFee = tFee.mul(currentRate);
1138         uint256 rMarketing = tMarketing.mul(currentRate);
1139         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
1140         return (rAmount, rTransferAmount, rFee);
1141     }
1142 
1143     function _getRate() private view returns(uint256) {
1144         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1145         return rSupply.div(tSupply);
1146     }
1147 
1148     function _getCurrentSupply() private view returns(uint256, uint256) {
1149         uint256 rSupply = _rTotal;
1150         uint256 tSupply = _tTotal;
1151         for (uint256 i = 0; i < _excluded.length; i++) {
1152             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1153             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1154             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1155         }
1156         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1157         return (rSupply, tSupply);
1158     }
1159 
1160     function _takeMarketing(uint256 tMarketing) private {
1161         uint256 currentRate =  _getRate();
1162         uint256 rMarketing = tMarketing.mul(currentRate);
1163         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1164         if(_isExcluded[address(this)])
1165             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1166     }
1167 
1168     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1169         return _amount.mul(_taxFee).div(
1170             10**2
1171         );
1172     }
1173 
1174     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1175         return _amount.mul(_marketingFee).div(
1176             10**2
1177         );
1178     }
1179 
1180     function isExcludedFromFee(address account) public view returns(bool) {
1181         return _isExcludedFromFee[account];
1182     }
1183 
1184     function _approve(address owner, address spender, uint256 amount) private {
1185         require(owner != address(0), "ERC20: approve from the zero address");
1186         require(spender != address(0), "ERC20: approve to the zero address");
1187 
1188         _allowances[owner][spender] = amount;
1189         emit Approval(owner, spender, amount);
1190     }
1191 
1192     function _transfer(
1193         address from,
1194         address to,
1195         uint256 amount
1196     ) private {
1197         require(from != address(0), "ERC20: transfer from the zero address");
1198         require(to != address(0), "ERC20: transfer to the zero address");
1199         require(amount > 0, "Transfer amount must be greater than zero");
1200         require(!_isBlackListedBot[to], "You have no power here!");
1201         require(!_isBlackListedBot[from], "You have no power here!");
1202 
1203         if(from != owner() && to != owner()) {
1204             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1205             if (from == uniswapV2Pair || to == uniswapV2Pair) {
1206                 require(tradingEnabled, "Trading is not enabled yet");
1207             }
1208         }
1209 
1210         // is the token balance of this contract address over the min number of
1211         // tokens that we need to initiate a swap + send lock?
1212         // also, don't get caught in a circular sending event.
1213         // also, don't swap & liquify if sender is uniswap pair.
1214         uint256 contractTokenBalance = balanceOf(address(this));
1215         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1216 
1217         if(contractTokenBalance >= _maxTxAmount)
1218         {
1219             contractTokenBalance = _maxTxAmount;
1220         }
1221 
1222         if (
1223             overMinTokenBalance &&
1224             !inSwapAndSend &&
1225             from != uniswapV2Pair &&
1226             SwapAndSendEnabled
1227         ) {
1228             SwapAndSend(contractTokenBalance);
1229         }
1230 
1231         if(feesOnSellersAndBuyers) {
1232             setFees(to);
1233         }
1234 
1235         //indicates if fee should be deducted from transfer
1236         bool takeFee = true;
1237 
1238         //if any account belongs to _isExcludedFromFee account then remove the fee
1239         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1240             takeFee = false;
1241         }
1242 
1243         _tokenTransfer(from,to,amount,takeFee);
1244     }
1245 
1246     function setFees(address recipient) private {
1247         _taxFee = defaultTaxFee;
1248         _marketingFee = defaultMarketingFee;
1249         if (recipient == uniswapV2Pair) { // sell
1250             _marketingFee = _marketingFee4Sellers;
1251         }
1252     }
1253 
1254     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1255         // generate the uniswap pair path of token -> weth
1256         address[] memory path = new address[](2);
1257         path[0] = address(this);
1258         path[1] = uniswapV2Router.WETH();
1259 
1260         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1261 
1262         // make the swap
1263         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1264             contractTokenBalance,
1265             0, // accept any amount of ETH
1266             path,
1267             address(this),
1268             block.timestamp
1269         );
1270 
1271         uint256 contractETHBalance = address(this).balance;
1272         if(contractETHBalance > 0) {
1273              _teamWalletAddress.transfer(contractETHBalance.div(2));
1274             _marketingWalletAddress.transfer(contractETHBalance.div(2));
1275         }
1276     }
1277 
1278     //this method is responsible for taking all fee, if takeFee is true
1279     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1280         if(!takeFee)
1281             removeAllFee();
1282 
1283         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1284             _transferFromExcluded(sender, recipient, amount);
1285         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1286             _transferToExcluded(sender, recipient, amount);
1287         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1288             _transferStandard(sender, recipient, amount);
1289         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1290             _transferBothExcluded(sender, recipient, amount);
1291         } else {
1292             _transferStandard(sender, recipient, amount);
1293         }
1294 
1295         if(!takeFee)
1296             restoreAllFee();
1297     }
1298 
1299     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1300         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1301         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1302         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1303         _takeMarketing(tMarketing);
1304         _reflectFee(rFee, tFee);
1305         emit Transfer(sender, recipient, tTransferAmount);
1306     }
1307 
1308     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1309         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1310         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1311         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1312         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1313         _takeMarketing(tMarketing);
1314         _reflectFee(rFee, tFee);
1315         emit Transfer(sender, recipient, tTransferAmount);
1316     }
1317 
1318     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1319         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1320         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1321         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1322         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1323         _takeMarketing(tMarketing);
1324         _reflectFee(rFee, tFee);
1325         emit Transfer(sender, recipient, tTransferAmount);
1326     }
1327 
1328     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1329         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1330         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1331         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1332         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1333         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1334         _takeMarketing(tMarketing);
1335         _reflectFee(rFee, tFee);
1336         emit Transfer(sender, recipient, tTransferAmount);
1337     }
1338 
1339     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1340         defaultMarketingFee = marketingFee;
1341     }
1342 
1343     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1344         _marketingFee4Sellers = marketingFee4Sellers;
1345     }
1346 
1347     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1348         feesOnSellersAndBuyers = _enabled;
1349     }
1350 
1351     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1352         SwapAndSendEnabled = _enabled;
1353         emit SwapAndSendEnabledUpdated(_enabled);
1354     }
1355     
1356     function LetTradingBegin(bool _tradingEnabled) external onlyOwner() {
1357          tradingEnabled = _tradingEnabled;
1358     }
1359 
1360     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1361         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1362     }
1363 
1364     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1365         _maxTxAmount = maxTxAmount;
1366     }
1367 }