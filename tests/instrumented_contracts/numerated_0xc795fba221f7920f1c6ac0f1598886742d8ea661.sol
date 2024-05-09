1 /*
2   _________      .__  __                        ____  ___
3  /   _____/____  |__|/  |______    _____ _____  \   \/  /
4  \_____  \\__  \ |  \   __\__  \  /     \\__  \  \     / 
5  /        \/ __ \|  ||  |  / __ \|  Y Y  \/ __ \_/     \ 
6 /_______  (____  /__||__| (____  /__|_|  (____  /___/\  \
7         \/     \/              \/      \/     \/      \_/
8 
9 //TG: https://t.me/SaitamaX_eth
10 //Website: https://SaitamaX.io
11 */
12 pragma solidity ^0.8.3;
13 // SPDX-License-Identifier: Unlicensed
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */ 
18 interface IERC20 {
19     /**
20     * @dev Returns the amount of tokens in existence.
21     */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25     * @dev Returns the amount of tokens owned by `account`.
26     */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30     * @dev Moves `amount` tokens from the caller's account to `recipient`.
31     *
32     * Returns a boolean value indicating whether the operation succeeded.
33     *
34     * Emits a {Transfer} event.
35     */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39     * @dev Returns the remaining number of tokens that `spender` will be
40     * allowed to spend on behalf of `owner` through {transferFrom}. This is
41     * zero by default.
42     *
43     * This value changes when {approve} or {transferFrom} are called.
44     */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49     *
50     * Returns a boolean value indicating whether the operation succeeded.
51     *
52     * IMPORTANT: Beware that changing an allowance with this method brings the risk
53     * that someone may use both the old and the new allowance by unfortunate
54     * transaction ordering. One possible solution to mitigate this race
55     * condition is to first reduce the spender's allowance to 0 and set the
56     * desired value afterwards:
57     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58     *
59     * Emits an {Approval} event.
60     */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64     * @dev Moves `amount` tokens from `sender` to `recipient` using the
65     * allowance mechanism. `amount` is then deducted from the caller's
66     * allowance.
67     *
68     * Returns a boolean value indicating whether the operation succeeded.
69     *
70     * Emits a {Transfer} event.
71     */
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     /**
75     * @dev Emitted when `value` tokens are moved from one account (`from`) to
76     * another (`to`).
77     *
78     * Note that `value` may be zero.
79     */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84     * a call to {approve}. `value` is the new allowance.
85     */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 // CAUTION
90 // This version of SafeMath should only be used with Solidity 0.8 or later,
91 // because it relies on the compiler's built in overflow checks.
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations.
95  *
96  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
97  * now has built in overflow checking.
98  */
99 library SafeMath {
100     /**
101     * @dev Returns the addition of two unsigned integers, with an overflow flag.
102     *
103     * _Available since v3.4._
104     */
105     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         unchecked {
107             uint256 c = a + b;
108             if (c < a) return (false, 0);
109             return (true, c);
110         }
111     }
112 
113     /**
114     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115     *
116     * _Available since v3.4._
117     */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         unchecked {
120             if (b > a) return (false, 0);
121             return (true, a - b);
122         }
123     }
124 
125     /**
126     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127     *
128     * _Available since v3.4._
129     */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
133             // benefit is lost if 'b' is also tested.
134             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
135             if (a == 0) return (true, 0);
136             uint256 c = a * b;
137             if (c / a != b) return (false, 0);
138             return (true, c);
139         }
140     }
141 
142     /**
143     * @dev Returns the division of two unsigned integers, with a division by zero flag.
144     *
145     * _Available since v3.4._
146     */
147     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         unchecked {
149             if (b == 0) return (false, 0);
150             return (true, a / b);
151         }
152     }
153 
154     /**
155     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
156     *
157     * _Available since v3.4._
158     */
159     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         unchecked {
161             if (b == 0) return (false, 0);
162             return (true, a % b);
163         }
164     }
165 
166     /**
167     * @dev Returns the addition of two unsigned integers, reverting on
168     * overflow.
169     *
170     * Counterpart to Solidity's `+` operator.
171     *
172     * Requirements:
173     *
174     * - Addition cannot overflow.
175     */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a + b;
178     }
179 
180     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a - b;
182     }
183 
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         return a * b;
186     }
187 
188  
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a / b;
191     }
192 
193     /**
194     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195     * reverting when dividing by zero.
196     *
197     * Counterpart to Solidity's `%` operator. This function uses a `revert`
198     * opcode (which leaves remaining gas untouched) while Solidity uses an
199     * invalid opcode to revert (consuming all remaining gas).
200     *
201     * Requirements:
202     *
203     * - The divisor cannot be zero.
204     */
205     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a % b;
207     }
208 
209     /**
210     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
211     * overflow (when the result is negative).
212     *
213     * CAUTION: This function is deprecated because it requires allocating memory for the error
214     * message unnecessarily. For custom revert reasons use {trySub}.
215     *
216     * Counterpart to Solidity's `-` operator.
217     *
218     * Requirements:
219     *
220     * - Subtraction cannot overflow.
221     */
222     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         unchecked {
224             require(b <= a, errorMessage);
225             return a - b;
226         }
227     }
228 
229     /**
230     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
231     * division by zero. The result is rounded towards zero.
232     *
233     * Counterpart to Solidity's `%` operator. This function uses a `revert`
234     * opcode (which leaves remaining gas untouched) while Solidity uses an
235     * invalid opcode to revert (consuming all remaining gas).
236     *
237     * Counterpart to Solidity's `/` operator. Note: this function uses a
238     * `revert` opcode (which leaves remaining gas untouched) while Solidity
239     * uses an invalid opcode to revert (consuming all remaining gas).
240     *
241     * Requirements:
242     *
243     * - The divisor cannot be zero.
244     */
245     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         unchecked {
247             require(b > 0, errorMessage);
248             return a / b;
249         }
250     }
251 
252     /**
253     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254     * reverting with custom message when dividing by zero.
255     *
256     * CAUTION: This function is deprecated because it requires allocating memory for the error
257     * message unnecessarily. For custom revert reasons use {tryMod}.
258     *
259     * Counterpart to Solidity's `%` operator. This function uses a `revert`
260     * opcode (which leaves remaining gas untouched) while Solidity uses an
261     * invalid opcode to revert (consuming all remaining gas).
262     *
263     * Requirements:
264     *
265     * - The divisor cannot be zero.
266     */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         unchecked {
269             require(b > 0, errorMessage);
270             return a % b;
271         }
272     }
273 }
274 
275 /*
276  * @dev Provides information about the current execution context, including the
277  * sender of the transaction and its data. While these are generally available
278  * via msg.sender and msg.data, they should not be accessed in such a direct
279  * manner, since when dealing with meta-transactions the account sending and
280  * paying for execution may not be the actual sender (as far as an application
281  * is concerned).
282  *
283  * This contract is only required for intermediate, library-like contracts.
284  */
285 abstract contract Context {
286     function _msgSender() internal view virtual returns (address) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view virtual returns (bytes calldata) {
291         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
292         return msg.data;
293     }
294 }
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301     * @dev Returns true if `account` is a contract.
302     *
303     * [IMPORTANT]
304     * ====
305     * It is unsafe to assume that an address for which this function returns
306     * false is an externally-owned account (EOA) and not a contract.
307     *
308     * Among others, `isContract` will return false for the following
309     * types of addresses:
310     *
311     *  - an externally-owned account
312     *  - a contract in construction
313     *  - an address where a contract will be created
314     *  - an address where a contract lived, but was destroyed
315     * ====
316     */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies on extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         uint256 size;
323         // solhint-disable-next-line no-inline-assembly
324         assembly { size := extcodesize(account) }
325         return size > 0;
326     }
327 
328     /**
329     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330     * `recipient`, forwarding all available gas and reverting on errors.
331     *
332     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333     * of certain opcodes, possibly making contracts go over the 2300 gas limit
334     * imposed by `transfer`, making them unable to receive funds via
335     * `transfer`. {sendValue} removes this limitation.
336     *
337     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338     *
339     * IMPORTANT: because control is transferred to `recipient`, care must be
340     * taken to not create reentrancy vulnerabilities. Consider using
341     * {ReentrancyGuard} or the
342     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343     */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
348         (bool success, ) = recipient.call{ value: amount }("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353     * @dev Performs a Solidity function call using a low level `call`. A
354     * plain`call` is an unsafe replacement for a function call: use this
355     * function instead.
356     *
357     * If `target` reverts with a revert reason, it is bubbled up by this
358     * function (like regular Solidity function calls).
359     *
360     * Returns the raw returned data. To convert to the expected return value,
361     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362     *
363     * Requirements:
364     *
365     * - `target` must be a contract.
366     * - calling `target` with `data` must not revert.
367     *
368     * _Available since v3.1._
369     */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371       return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376     * `errorMessage` as a fallback revert reason when `target` reverts.
377     *
378     * _Available since v3.1._
379     */
380     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, 0, errorMessage);
382     }
383 
384     /**
385     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386     * but also transferring `value` wei to `target`.
387     *
388     * Requirements:
389     *
390     * - the calling contract must have an ETH balance of at least `value`.
391     * - the called Solidity function must be `payable`.
392     *
393     * _Available since v3.1._
394     */
395     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
397     }
398 
399     /**
400     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
401     * with `errorMessage` as a fallback revert reason when `target` reverts.
402     *
403     * _Available since v3.1._
404     */
405     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
406         require(address(this).balance >= value, "Address: insufficient balance for call");
407         require(isContract(target), "Address: call to non-contract");
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = target.call{ value: value }(data);
411         return _verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416     * but performing a static call.
417     *
418     * _Available since v3.3._
419     */
420     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
421         return functionStaticCall(target, data, "Address: low-level static call failed");
422     }
423 
424     /**
425     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
426     * but performing a static call.
427     *
428     * _Available since v3.3._
429     */
430     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         // solhint-disable-next-line avoid-low-level-calls
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return _verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440     * but performing a delegate call.
441     *
442     * _Available since v3.4._
443     */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450     * but performing a delegate call.
451     *
452     * _Available since v3.4._
453     */
454     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
455         require(isContract(target), "Address: delegate call to non-contract");
456 
457         // solhint-disable-next-line avoid-low-level-calls
458         (bool success, bytes memory returndata) = target.delegatecall(data);
459         return _verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
463         if (success) {
464             return returndata;
465         } else {
466             // Look for revert reason and bubble it up if present
467             if (returndata.length > 0) {
468                 // The easiest way to bubble the revert reason is using memory via assembly
469 
470                 // solhint-disable-next-line no-inline-assembly
471                 assembly {
472                     let returndata_size := mload(returndata)
473                     revert(add(32, returndata), returndata_size)
474                 }
475             } else {
476                 revert(errorMessage);
477             }
478         }
479     }
480 }
481 
482 /**
483  * @dev Contract module which provides a basic access control mechanism, where
484  * there is an account (an owner) that can be granted exclusive access to
485  * specific functions.
486  *
487  * By default, the owner account will be the one that deploys the contract. This
488  * can later be changed with {transferOwnership}.
489  *
490  * This module is used through inheritance. It will make available the modifier
491  * `onlyOwner`, which can be applied to your functions to restrict their use to
492  * the owner.
493  */
494 abstract contract Ownable is Context {
495     address private _owner;
496 
497     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
498 
499     /**
500     * @dev Initializes the contract setting the deployer as the initial owner.
501     */
502     constructor () {
503         _owner = _msgSender();
504         emit OwnershipTransferred(address(0), _owner);
505     }
506 
507     /**
508     * @dev Returns the address of the current owner.
509     */
510     function owner() public view virtual returns (address) {
511         return _owner;
512     }
513 
514     /**
515     * @dev Throws if called by any account other than the owner.
516     */
517     modifier onlyOwner() {
518         require(owner() == _msgSender(), "Ownable: caller is not the owner");
519         _;
520     }
521 
522     /**
523     * @dev Leaves the contract without owner. It will not be possible to call
524     * `onlyOwner` functions anymore. Can only be called by the current owner.
525     *
526     * NOTE: Renouncing ownership will leave the contract without an owner,
527     * thereby removing any functionality that is only available to the owner.
528     */
529     function renounceOwnership() public virtual onlyOwner {
530         emit OwnershipTransferred(_owner, address(0));
531         _owner = address(0);
532     }
533 
534     /**
535     * @dev Transfers ownership of the contract to a new account (`newOwner`).
536     * Can only be called by the current owner.
537     */
538     function transferOwnership(address newOwner) public virtual onlyOwner {
539         require(newOwner != address(0), "Ownable: new owner is the zero address");
540         emit OwnershipTransferred(_owner, newOwner);
541         _owner = newOwner;
542     }
543 }
544 
545 interface IUniswapV2Factory {
546     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
547 
548     function feeTo() external view returns (address);
549     function feeToSetter() external view returns (address);
550 
551     function getPair(address tokenA, address tokenB) external view returns (address pair);
552     function allPairs(uint) external view returns (address pair);
553     function allPairsLength() external view returns (uint);
554 
555     function createPair(address tokenA, address tokenB) external returns (address pair);
556 
557     function setFeeTo(address) external;
558     function setFeeToSetter(address) external;
559 }
560 
561 interface IUniswapV2Pair {
562     event Approval(address indexed owner, address indexed spender, uint value);
563     event Transfer(address indexed from, address indexed to, uint value);
564 
565     function name() external pure returns (string memory);
566     function symbol() external pure returns (string memory);
567     function decimals() external pure returns (uint8);
568     function totalSupply() external view returns (uint);
569     function balanceOf(address owner) external view returns (uint);
570     function allowance(address owner, address spender) external view returns (uint);
571 
572     function approve(address spender, uint value) external returns (bool);
573     function transfer(address to, uint value) external returns (bool);
574     function transferFrom(address from, address to, uint value) external returns (bool);
575 
576     function DOMAIN_SEPARATOR() external view returns (bytes32);
577     function PERMIT_TYPEHASH() external pure returns (bytes32);
578     function nonces(address owner) external view returns (uint);
579 
580     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
581 
582     event Mint(address indexed sender, uint amount0, uint amount1);
583     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
584     event Swap(
585         address indexed sender,
586         uint amount0In,
587         uint amount1In,
588         uint amount0Out,
589         uint amount1Out,
590         address indexed to
591     );
592     event Sync(uint112 reserve0, uint112 reserve1);
593 
594     function MINIMUM_LIQUIDITY() external pure returns (uint);
595     function factory() external view returns (address);
596     function token0() external view returns (address);
597     function token1() external view returns (address);
598     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
599     function price0CumulativeLast() external view returns (uint);
600     function price1CumulativeLast() external view returns (uint);
601     function kLast() external view returns (uint);
602 
603     function mint(address to) external returns (uint liquidity);
604     function burn(address to) external returns (uint amount0, uint amount1);
605     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
606     function skim(address to) external;
607     function sync() external;
608 
609     function initialize(address, address) external;
610 }
611 
612 interface IUniswapV2Router01 {
613     function factory() external pure returns (address);
614     function WETH() external pure returns (address);
615 
616     function addLiquidity(
617         address tokenA,
618         address tokenB,
619         uint amountADesired,
620         uint amountBDesired,
621         uint amountAMin,
622         uint amountBMin,
623         address to,
624         uint deadline
625     ) external returns (uint amountA, uint amountB, uint liquidity);
626     function addLiquidityETH(
627         address token,
628         uint amountTokenDesired,
629         uint amountTokenMin,
630         uint amountETHMin,
631         address to,
632         uint deadline
633     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
634     function removeLiquidity(
635         address tokenA,
636         address tokenB,
637         uint liquidity,
638         uint amountAMin,
639         uint amountBMin,
640         address to,
641         uint deadline
642     ) external returns (uint amountA, uint amountB);
643     function removeLiquidityETH(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline
650     ) external returns (uint amountToken, uint amountETH);
651     function removeLiquidityWithPermit(
652         address tokenA,
653         address tokenB,
654         uint liquidity,
655         uint amountAMin,
656         uint amountBMin,
657         address to,
658         uint deadline,
659         bool approveMax, uint8 v, bytes32 r, bytes32 s
660     ) external returns (uint amountA, uint amountB);
661     function removeLiquidityETHWithPermit(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline,
668         bool approveMax, uint8 v, bytes32 r, bytes32 s
669     ) external returns (uint amountToken, uint amountETH);
670     function swapExactTokensForTokens(
671         uint amountIn,
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external returns (uint[] memory amounts);
677     function swapTokensForExactTokens(
678         uint amountOut,
679         uint amountInMax,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external returns (uint[] memory amounts);
684     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
685         external
686         payable
687         returns (uint[] memory amounts);
688     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
689         external
690         returns (uint[] memory amounts);
691     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
692         external
693         returns (uint[] memory amounts);
694     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
695         external
696         payable
697         returns (uint[] memory amounts);
698 
699     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
700     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
701     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
702     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
703     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
704 }
705 
706 interface IUniswapV2Router02 is IUniswapV2Router01 {
707     function removeLiquidityETHSupportingFeeOnTransferTokens(
708         address token,
709         uint liquidity,
710         uint amountTokenMin,
711         uint amountETHMin,
712         address to,
713         uint deadline
714     ) external returns (uint amountETH);
715     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
716         address token,
717         uint liquidity,
718         uint amountTokenMin,
719         uint amountETHMin,
720         address to,
721         uint deadline,
722         bool approveMax, uint8 v, bytes32 r, bytes32 s
723     ) external returns (uint amountETH);
724 
725     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
726         uint amountIn,
727         uint amountOutMin,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external;
732     function swapExactETHForTokensSupportingFeeOnTransferTokens(
733         uint amountOutMin,
734         address[] calldata path,
735         address to,
736         uint deadline
737     ) external payable;
738     function swapExactTokensForETHSupportingFeeOnTransferTokens(
739         uint amountIn,
740         uint amountOutMin,
741         address[] calldata path,
742         address to,
743         uint deadline
744     ) external;
745 }
746 
747 
748 contract SaitamaX is Context, IERC20, Ownable {
749     using SafeMath for uint256;
750     using Address for address;
751 
752     uint8 private _decimals = 9;
753 
754     // 
755     string private _name = "SaitamaX";                                           // name
756     string private _symbol = "SaitaX";                                            // symbol
757     uint256 private _tTotal = 100 * 10**12 * 10**uint256(_decimals);
758 
759     // % to holders
760     uint256 public defaultTaxFee = 1;
761     uint256 public _taxFee = defaultTaxFee;
762     uint256 private _previousTaxFee = _taxFee;
763 
764     // % to swap & send to marketing wallet
765     uint256 public defaultMarketingFee = 11;
766     uint256 public _marketingFee = defaultMarketingFee;
767     uint256 private _previousMarketingFee = _marketingFee;
768 
769     uint256 public _marketingFee4Sellers = 11;
770 
771     bool public feesOnSellersAndBuyers = true;
772 
773     uint256 public _maxTxAmount = _tTotal.div(200);
774     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
775     address payable public marketingWallet = payable(0xdd203180Ee391a45fe8c844cb83f1b9c4EbcF9F2);
776 
777     //
778 
779     mapping (address => uint256) private _rOwned;
780     mapping (address => uint256) private _tOwned;
781     mapping (address => mapping (address => uint256)) private _allowances;
782 
783     mapping (address => bool) private _isExcludedFromFee;
784 
785     mapping (address => bool) private _isExcluded;
786     
787     mapping (address => bool) public _isBlacklisted;
788 
789     address[] private _excluded;
790     uint256 private constant MAX = ~uint256(0);
791 
792     uint256 private _tFeeTotal;
793     uint256 private _rTotal = (MAX - (MAX % _tTotal));
794 
795     IUniswapV2Router02 public immutable uniswapV2Router;
796     address public immutable uniswapV2Pair;
797 
798     bool inSwapAndSend;
799     bool public SwapAndSendEnabled = true;
800 
801     event SwapAndSendEnabledUpdated(bool enabled);
802 
803     modifier lockTheSwap {
804         inSwapAndSend = true;
805         _;
806         inSwapAndSend = false;
807     }
808 
809     constructor () {
810         _rOwned[_msgSender()] = _rTotal;
811 
812         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
813          // Create a uniswap pair for this new token
814         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
815             .createPair(address(this), _uniswapV2Router.WETH());
816 
817         // set the rest of the contract variables
818         uniswapV2Router = _uniswapV2Router;
819 
820         //exclude owner and this contract from fee
821         _isExcludedFromFee[owner()] = true;
822         _isExcludedFromFee[address(this)] = true;
823 
824         emit Transfer(address(0), _msgSender(), _tTotal);
825     }
826 
827     function name() public view returns (string memory) {
828         return _name;
829     }
830 
831     function symbol() public view returns (string memory) {
832         return _symbol;
833     }
834 
835     function decimals() public view returns (uint8) {
836         return _decimals;
837     }
838 
839     function totalSupply() public view override returns (uint256) {
840         return _tTotal;
841     }
842 
843     function balanceOf(address account) public view override returns (uint256) {
844         if (_isExcluded[account]) return _tOwned[account];
845         return tokenFromReflection(_rOwned[account]);
846     }
847 
848     function transfer(address recipient, uint256 amount) public override returns (bool) {
849         _transfer(_msgSender(), recipient, amount);
850         return true;
851     }
852 
853     function allowance(address owner, address spender) public view override returns (uint256) {
854         return _allowances[owner][spender];
855     }
856 
857     function approve(address spender, uint256 amount) public override returns (bool) {
858         _approve(_msgSender(), spender, amount);
859         return true;
860     }
861 
862     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
863         _transfer(sender, recipient, amount);
864         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
865         return true;
866     }
867 
868     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
869         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
870         return true;
871     }
872 
873     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
874         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
875         return true;
876     }
877 
878     function isExcludedFromReward(address account) public view returns (bool) {
879         return _isExcluded[account];
880     }
881 
882     function totalFees() public view returns (uint256) {
883         return _tFeeTotal;
884     }
885 
886     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
887         require(tAmount <= _tTotal, "Amount must be less than supply");
888         if (!deductTransferFee) {
889             (uint256 rAmount,,,,,) = _getValues(tAmount);
890             return rAmount;
891         } else {
892             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
893             return rTransferAmount;
894         }
895     }
896 
897     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
898         require(rAmount <= _rTotal, "Amount must be less than total reflections");
899         uint256 currentRate =  _getRate();
900         return rAmount.div(currentRate);
901     }
902 
903     function excludeFromReward(address account) public onlyOwner() {
904         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
905         require(!_isExcluded[account], "Account is already excluded");
906         if(_rOwned[account] > 0) {
907             _tOwned[account] = tokenFromReflection(_rOwned[account]);
908         }
909         _isExcluded[account] = true;
910         _excluded.push(account);
911     }
912 
913     function includeInReward(address account) external onlyOwner() {
914         require(_isExcluded[account], "Account is already excluded");
915         for (uint256 i = 0; i < _excluded.length; i++) {
916             if (_excluded[i] == account) {
917                 _excluded[i] = _excluded[_excluded.length - 1];
918                 _tOwned[account] = 0;
919                 _isExcluded[account] = false;
920                 _excluded.pop();
921                 break;
922             }
923         }
924     }
925 
926     function excludeFromFee(address account) public onlyOwner() {
927         _isExcludedFromFee[account] = true;
928     }
929 
930     function includeInFee(address account) public onlyOwner() {
931         _isExcludedFromFee[account] = false;
932     }
933 
934     function removeAllFee() private {
935         if(_taxFee == 0 && _marketingFee == 0) return;
936 
937         _previousTaxFee = _taxFee;
938         _previousMarketingFee = _marketingFee;
939 
940         _taxFee = 0;
941         _marketingFee = 0;
942     }
943 
944     function restoreAllFee() private {
945         _taxFee = _previousTaxFee;
946         _marketingFee = _previousMarketingFee;
947     }
948 
949     //to recieve ETH
950     receive() external payable {}
951 
952     function _reflectFee(uint256 rFee, uint256 tFee) private {
953         _rTotal = _rTotal.sub(rFee);
954         _tFeeTotal = _tFeeTotal.add(tFee);
955     }
956     
957      function addToBlackList(address[] calldata addresses) external onlyOwner {
958       for (uint256 i; i < addresses.length; ++i) {
959         _isBlacklisted[addresses[i]] = true;
960       }
961     }
962     
963       function removeFromBlackList(address account) external onlyOwner {
964         _isBlacklisted[account] = false;
965     }
966 
967     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
968         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
969         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
970         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
971     }
972 
973     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
974         uint256 tFee = calculateTaxFee(tAmount);
975         uint256 tMarketing = calculateMarketingFee(tAmount);
976         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
977         return (tTransferAmount, tFee, tMarketing);
978     }
979 
980     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
981         uint256 rAmount = tAmount.mul(currentRate);
982         uint256 rFee = tFee.mul(currentRate);
983         uint256 rMarketing = tMarketing.mul(currentRate);
984         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
985         return (rAmount, rTransferAmount, rFee);
986     }
987 
988     function _getRate() private view returns(uint256) {
989         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
990         return rSupply.div(tSupply);
991     }
992 
993     function _getCurrentSupply() private view returns(uint256, uint256) {
994         uint256 rSupply = _rTotal;
995         uint256 tSupply = _tTotal;
996         for (uint256 i = 0; i < _excluded.length; i++) {
997             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
998             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
999             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1000         }
1001         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1002         return (rSupply, tSupply);
1003     }
1004 
1005     function _takeMarketing(uint256 tMarketing) private {
1006         uint256 currentRate =  _getRate();
1007         uint256 rMarketing = tMarketing.mul(currentRate);
1008         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1009         if(_isExcluded[address(this)])
1010             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1011     }
1012 
1013     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1014         return _amount.mul(_taxFee).div(
1015             10**2
1016         );
1017     }
1018 
1019     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1020         return _amount.mul(_marketingFee).div(
1021             10**2
1022         );
1023     }
1024 
1025     function isExcludedFromFee(address account) public view returns(bool) {
1026         return _isExcludedFromFee[account];
1027     }
1028 
1029     function _approve(address owner, address spender, uint256 amount) private {
1030         require(owner != address(0), "ERC20: approve from the zero address");
1031         require(spender != address(0), "ERC20: approve to the zero address");
1032 
1033         _allowances[owner][spender] = amount;
1034         emit Approval(owner, spender, amount);
1035     }
1036 
1037     function _transfer(
1038         address from,
1039         address to,
1040         uint256 amount
1041     ) private {
1042         require(from != address(0), "ERC20: transfer from the zero address");
1043         require(to != address(0), "ERC20: transfer to the zero address");
1044         require(amount > 0, "Transfer amount must be greater than zero");
1045         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted");
1046 
1047         if(from != owner() && to != owner())
1048             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1049 
1050         // is the token balance of this contract address over the min number of
1051         // tokens that we need to initiate a swap + send lock?
1052         // also, don't get caught in a circular sending event.
1053         // also, don't swap & liquify if sender is uniswap pair.
1054         uint256 contractTokenBalance = balanceOf(address(this));
1055         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1056 
1057         if(contractTokenBalance >= _maxTxAmount)
1058         {
1059             contractTokenBalance = _maxTxAmount;
1060         }
1061 
1062         if (
1063             overMinTokenBalance &&
1064             !inSwapAndSend &&
1065             from != uniswapV2Pair &&
1066             SwapAndSendEnabled
1067         ) {
1068             SwapAndSend(contractTokenBalance);
1069         }
1070 
1071         if(feesOnSellersAndBuyers) {
1072             setFees(to);
1073         }
1074 
1075         //indicates if fee should be deducted from transfer
1076         bool takeFee = true;
1077 
1078         //if any account belongs to _isExcludedFromFee account then remove the fee
1079         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1080             takeFee = false;
1081         }
1082 
1083         _tokenTransfer(from,to,amount,takeFee);
1084     }
1085 
1086     function setFees(address recipient) private {
1087         _taxFee = defaultTaxFee;
1088         _marketingFee = defaultMarketingFee;
1089         if (recipient == uniswapV2Pair) { // sell
1090             _marketingFee = _marketingFee4Sellers;
1091         }
1092     }
1093 
1094     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1095         // generate the uniswap pair path of token -> weth
1096         address[] memory path = new address[](2);
1097         path[0] = address(this);
1098         path[1] = uniswapV2Router.WETH();
1099 
1100         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1101 
1102         // make the swap
1103         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1104             contractTokenBalance,
1105             0, // accept any amount of ETH
1106             path,
1107             address(this),
1108             block.timestamp
1109         );
1110 
1111         uint256 contractETHBalance = address(this).balance;
1112         if(contractETHBalance > 0) {
1113             marketingWallet.transfer(contractETHBalance);
1114         }
1115     }
1116 
1117     //this method is responsible for taking all fee, if takeFee is true
1118     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1119         if(!takeFee)
1120             removeAllFee();
1121 
1122         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1123             _transferFromExcluded(sender, recipient, amount);
1124         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1125             _transferToExcluded(sender, recipient, amount);
1126         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1127             _transferStandard(sender, recipient, amount);
1128         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1129             _transferBothExcluded(sender, recipient, amount);
1130         } else {
1131             _transferStandard(sender, recipient, amount);
1132         }
1133 
1134         if(!takeFee)
1135             restoreAllFee();
1136     }
1137 
1138     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1139         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1140         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1141         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1142         _takeMarketing(tMarketing);
1143         _reflectFee(rFee, tFee);
1144         emit Transfer(sender, recipient, tTransferAmount);
1145     }
1146 
1147     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1148         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1149         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1150         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1151         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1152         _takeMarketing(tMarketing);
1153         _reflectFee(rFee, tFee);
1154         emit Transfer(sender, recipient, tTransferAmount);
1155     }
1156 
1157     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1158         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1159         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1160         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1161         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1162         _takeMarketing(tMarketing);
1163         _reflectFee(rFee, tFee);
1164         emit Transfer(sender, recipient, tTransferAmount);
1165     }
1166 
1167     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1168         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1169         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1170         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1171         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1172         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1173         _takeMarketing(tMarketing);
1174         _reflectFee(rFee, tFee);
1175         emit Transfer(sender, recipient, tTransferAmount);
1176     }
1177 
1178     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1179         defaultMarketingFee = marketingFee;
1180     }
1181 
1182     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1183         _marketingFee4Sellers = marketingFee4Sellers;
1184     }
1185 
1186     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1187         feesOnSellersAndBuyers = _enabled;
1188     }
1189 
1190     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1191         SwapAndSendEnabled = _enabled;
1192         emit SwapAndSendEnabledUpdated(_enabled);
1193     }
1194 
1195     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1196         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1197     }
1198 
1199     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1200         marketingWallet = wallet;
1201     }
1202     
1203     
1204 
1205     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1206         _maxTxAmount = maxTxAmount;
1207     }
1208 }