1 pragma solidity ^0.8.3;
2 // SPDX-License-Identifier: Unlicensed
3 
4 /*
5 Token features:
6 5% redistribution to all holders
7 10% tax on sell transactions to the marketing wallet (can be updated)
8 */
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15     * @dev Returns the amount of tokens in existence.
16     */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20     * @dev Returns the amount of tokens owned by `account`.
21     */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25     * @dev Moves `amount` tokens from the caller's account to `recipient`.
26     *
27     * Returns a boolean value indicating whether the operation succeeded.
28     *
29     * Emits a {Transfer} event.
30     */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34     * @dev Returns the remaining number of tokens that `spender` will be
35     * allowed to spend on behalf of `owner` through {transferFrom}. This is
36     * zero by default.
37     *
38     * This value changes when {approve} or {transferFrom} are called.
39     */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44     *
45     * Returns a boolean value indicating whether the operation succeeded.
46     *
47     * IMPORTANT: Beware that changing an allowance with this method brings the risk
48     * that someone may use both the old and the new allowance by unfortunate
49     * transaction ordering. One possible solution to mitigate this race
50     * condition is to first reduce the spender's allowance to 0 and set the
51     * desired value afterwards:
52     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53     *
54     * Emits an {Approval} event.
55     */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59     * @dev Moves `amount` tokens from `sender` to `recipient` using the
60     * allowance mechanism. `amount` is then deducted from the caller's
61     * allowance.
62     *
63     * Returns a boolean value indicating whether the operation succeeded.
64     *
65     * Emits a {Transfer} event.
66     */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70     * @dev Emitted when `value` tokens are moved from one account (`from`) to
71     * another (`to`).
72     *
73     * Note that `value` may be zero.
74     */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79     * a call to {approve}. `value` is the new allowance.
80     */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // CAUTION
85 // This version of SafeMath should only be used with Solidity 0.8 or later,
86 // because it relies on the compiler's built in overflow checks.
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations.
90  *
91  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
92  * now has built in overflow checking.
93  */
94 library SafeMath {
95     /**
96     * @dev Returns the addition of two unsigned integers, with an overflow flag.
97     *
98     * _Available since v3.4._
99     */
100     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         unchecked {
102             uint256 c = a + b;
103             if (c < a) return (false, 0);
104             return (true, c);
105         }
106     }
107 
108     /**
109     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
110     *
111     * _Available since v3.4._
112     */
113     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         unchecked {
115             if (b > a) return (false, 0);
116             return (true, a - b);
117         }
118     }
119 
120     /**
121     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
122     *
123     * _Available since v3.4._
124     */
125     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         unchecked {
127             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
128             // benefit is lost if 'b' is also tested.
129             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
130             if (a == 0) return (true, 0);
131             uint256 c = a * b;
132             if (c / a != b) return (false, 0);
133             return (true, c);
134         }
135     }
136 
137     /**
138     * @dev Returns the division of two unsigned integers, with a division by zero flag.
139     *
140     * _Available since v3.4._
141     */
142     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         unchecked {
144             if (b == 0) return (false, 0);
145             return (true, a / b);
146         }
147     }
148 
149     /**
150     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
151     *
152     * _Available since v3.4._
153     */
154     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         unchecked {
156             if (b == 0) return (false, 0);
157             return (true, a % b);
158         }
159     }
160 
161     /**
162     * @dev Returns the addition of two unsigned integers, reverting on
163     * overflow.
164     *
165     * Counterpart to Solidity's `+` operator.
166     *
167     * Requirements:
168     *
169     * - Addition cannot overflow.
170     */
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a + b;
173     }
174 
175     /**
176     * @dev Returns the subtraction of two unsigned integers, reverting on
177     * overflow (when the result is negative).
178     *
179     * Counterpart to Solidity's `-` operator.
180     *
181     * Requirements:
182     *
183     * - Subtraction cannot overflow.
184     */
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         return a - b;
187     }
188 
189     /**
190     * @dev Returns the multiplication of two unsigned integers, reverting on
191     * overflow.
192     *
193     * Counterpart to Solidity's `*` operator.
194     *
195     * Requirements:
196     *
197     * - Multiplication cannot overflow.
198     */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a * b;
201     }
202 
203     /**
204     * @dev Returns the integer division of two unsigned integers, reverting on
205     * division by zero. The result is rounded towards zero.
206     *
207     * Counterpart to Solidity's `/` operator.
208     *
209     * Requirements:
210     *
211     * - The divisor cannot be zero.
212     */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a / b;
215     }
216 
217     /**
218     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219     * reverting when dividing by zero.
220     *
221     * Counterpart to Solidity's `%` operator. This function uses a `revert`
222     * opcode (which leaves remaining gas untouched) while Solidity uses an
223     * invalid opcode to revert (consuming all remaining gas).
224     *
225     * Requirements:
226     *
227     * - The divisor cannot be zero.
228     */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a % b;
231     }
232 
233     /**
234     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
235     * overflow (when the result is negative).
236     *
237     * CAUTION: This function is deprecated because it requires allocating memory for the error
238     * message unnecessarily. For custom revert reasons use {trySub}.
239     *
240     * Counterpart to Solidity's `-` operator.
241     *
242     * Requirements:
243     *
244     * - Subtraction cannot overflow.
245     */
246     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         unchecked {
248             require(b <= a, errorMessage);
249             return a - b;
250         }
251     }
252 
253     /**
254     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
255     * division by zero. The result is rounded towards zero.
256     *
257     * Counterpart to Solidity's `%` operator. This function uses a `revert`
258     * opcode (which leaves remaining gas untouched) while Solidity uses an
259     * invalid opcode to revert (consuming all remaining gas).
260     *
261     * Counterpart to Solidity's `/` operator. Note: this function uses a
262     * `revert` opcode (which leaves remaining gas untouched) while Solidity
263     * uses an invalid opcode to revert (consuming all remaining gas).
264     *
265     * Requirements:
266     *
267     * - The divisor cannot be zero.
268     */
269     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         unchecked {
271             require(b > 0, errorMessage);
272             return a / b;
273         }
274     }
275 
276     /**
277     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278     * reverting with custom message when dividing by zero.
279     *
280     * CAUTION: This function is deprecated because it requires allocating memory for the error
281     * message unnecessarily. For custom revert reasons use {tryMod}.
282     *
283     * Counterpart to Solidity's `%` operator. This function uses a `revert`
284     * opcode (which leaves remaining gas untouched) while Solidity uses an
285     * invalid opcode to revert (consuming all remaining gas).
286     *
287     * Requirements:
288     *
289     * - The divisor cannot be zero.
290     */
291     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         unchecked {
293             require(b > 0, errorMessage);
294             return a % b;
295         }
296     }
297 }
298 
299 /*
300  * @dev Provides information about the current execution context, including the
301  * sender of the transaction and its data. While these are generally available
302  * via msg.sender and msg.data, they should not be accessed in such a direct
303  * manner, since when dealing with meta-transactions the account sending and
304  * paying for execution may not be the actual sender (as far as an application
305  * is concerned).
306  *
307  * This contract is only required for intermediate, library-like contracts.
308  */
309 abstract contract Context {
310     function _msgSender() internal view virtual returns (address) {
311         return msg.sender;
312     }
313 
314     function _msgData() internal view virtual returns (bytes calldata) {
315         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
316         return msg.data;
317     }
318 }
319 
320 /**
321  * @dev Collection of functions related to the address type
322  */
323 library Address {
324     /**
325     * @dev Returns true if `account` is a contract.
326     *
327     * [IMPORTANT]
328     * ====
329     * It is unsafe to assume that an address for which this function returns
330     * false is an externally-owned account (EOA) and not a contract.
331     *
332     * Among others, `isContract` will return false for the following
333     * types of addresses:
334     *
335     *  - an externally-owned account
336     *  - a contract in construction
337     *  - an address where a contract will be created
338     *  - an address where a contract lived, but was destroyed
339     * ====
340     */
341     function isContract(address account) internal view returns (bool) {
342         // This method relies on extcodesize, which returns 0 for contracts in
343         // construction, since the code is only stored at the end of the
344         // constructor execution.
345 
346         uint256 size;
347         // solhint-disable-next-line no-inline-assembly
348         assembly { size := extcodesize(account) }
349         return size > 0;
350     }
351 
352     /**
353     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
354     * `recipient`, forwarding all available gas and reverting on errors.
355     *
356     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
357     * of certain opcodes, possibly making contracts go over the 2300 gas limit
358     * imposed by `transfer`, making them unable to receive funds via
359     * `transfer`. {sendValue} removes this limitation.
360     *
361     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
362     *
363     * IMPORTANT: because control is transferred to `recipient`, care must be
364     * taken to not create reentrancy vulnerabilities. Consider using
365     * {ReentrancyGuard} or the
366     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
367     */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
372         (bool success, ) = recipient.call{ value: amount }("");
373         require(success, "Address: unable to send value, recipient may have reverted");
374     }
375 
376     /**
377     * @dev Performs a Solidity function call using a low level `call`. A
378     * plain`call` is an unsafe replacement for a function call: use this
379     * function instead.
380     *
381     * If `target` reverts with a revert reason, it is bubbled up by this
382     * function (like regular Solidity function calls).
383     *
384     * Returns the raw returned data. To convert to the expected return value,
385     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
386     *
387     * Requirements:
388     *
389     * - `target` must be a contract.
390     * - calling `target` with `data` must not revert.
391     *
392     * _Available since v3.1._
393     */
394     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
395       return functionCall(target, data, "Address: low-level call failed");
396     }
397 
398     /**
399     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
400     * `errorMessage` as a fallback revert reason when `target` reverts.
401     *
402     * _Available since v3.1._
403     */
404     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410     * but also transferring `value` wei to `target`.
411     *
412     * Requirements:
413     *
414     * - the calling contract must have an ETH balance of at least `value`.
415     * - the called Solidity function must be `payable`.
416     *
417     * _Available since v3.1._
418     */
419     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
421     }
422 
423     /**
424     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
425     * with `errorMessage` as a fallback revert reason when `target` reverts.
426     *
427     * _Available since v3.1._
428     */
429     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         // solhint-disable-next-line avoid-low-level-calls
434         (bool success, bytes memory returndata) = target.call{ value: value }(data);
435         return _verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440     * but performing a static call.
441     *
442     * _Available since v3.3._
443     */
444     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
445         return functionStaticCall(target, data, "Address: low-level static call failed");
446     }
447 
448     /**
449     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450     * but performing a static call.
451     *
452     * _Available since v3.3._
453     */
454     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
455         require(isContract(target), "Address: static call to non-contract");
456 
457         // solhint-disable-next-line avoid-low-level-calls
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return _verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464     * but performing a delegate call.
465     *
466     * _Available since v3.4._
467     */
468     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
469         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
470     }
471 
472     /**
473     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474     * but performing a delegate call.
475     *
476     * _Available since v3.4._
477     */
478     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
479         require(isContract(target), "Address: delegate call to non-contract");
480 
481         // solhint-disable-next-line avoid-low-level-calls
482         (bool success, bytes memory returndata) = target.delegatecall(data);
483         return _verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
487         if (success) {
488             return returndata;
489         } else {
490             // Look for revert reason and bubble it up if present
491             if (returndata.length > 0) {
492                 // The easiest way to bubble the revert reason is using memory via assembly
493 
494                 // solhint-disable-next-line no-inline-assembly
495                 assembly {
496                     let returndata_size := mload(returndata)
497                     revert(add(32, returndata), returndata_size)
498                 }
499             } else {
500                 revert(errorMessage);
501             }
502         }
503     }
504 }
505 
506 /**
507  * @dev Contract module which provides a basic access control mechanism, where
508  * there is an account (an owner) that can be granted exclusive access to
509  * specific functions.
510  *
511  * By default, the owner account will be the one that deploys the contract. This
512  * can later be changed with {transferOwnership}.
513  *
514  * This module is used through inheritance. It will make available the modifier
515  * `onlyOwner`, which can be applied to your functions to restrict their use to
516  * the owner.
517  */
518 abstract contract Ownable is Context {
519     address private _owner;
520 
521     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
522 
523     /**
524     * @dev Initializes the contract setting the deployer as the initial owner.
525     */
526     constructor () {
527         _owner = _msgSender();
528         emit OwnershipTransferred(address(0), _owner);
529     }
530 
531     /**
532     * @dev Returns the address of the current owner.
533     */
534     function owner() public view virtual returns (address) {
535         return _owner;
536     }
537 
538     /**
539     * @dev Throws if called by any account other than the owner.
540     */
541     modifier onlyOwner() {
542         require(owner() == _msgSender(), "Ownable: caller is not the owner");
543         _;
544     }
545 
546     /**
547     * @dev Leaves the contract without owner. It will not be possible to call
548     * `onlyOwner` functions anymore. Can only be called by the current owner.
549     *
550     * NOTE: Renouncing ownership will leave the contract without an owner,
551     * thereby removing any functionality that is only available to the owner.
552     */
553     function renounceOwnership() public virtual onlyOwner {
554         emit OwnershipTransferred(_owner, address(0));
555         _owner = address(0);
556     }
557 
558     /**
559     * @dev Transfers ownership of the contract to a new account (`newOwner`).
560     * Can only be called by the current owner.
561     */
562     function transferOwnership(address newOwner) public virtual onlyOwner {
563         require(newOwner != address(0), "Ownable: new owner is the zero address");
564         emit OwnershipTransferred(_owner, newOwner);
565         _owner = newOwner;
566     }
567 }
568 
569 interface IUniswapV2Factory {
570     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
571 
572     function feeTo() external view returns (address);
573     function feeToSetter() external view returns (address);
574 
575     function getPair(address tokenA, address tokenB) external view returns (address pair);
576     function allPairs(uint) external view returns (address pair);
577     function allPairsLength() external view returns (uint);
578 
579     function createPair(address tokenA, address tokenB) external returns (address pair);
580 
581     function setFeeTo(address) external;
582     function setFeeToSetter(address) external;
583 }
584 
585 interface IUniswapV2Pair {
586     event Approval(address indexed owner, address indexed spender, uint value);
587     event Transfer(address indexed from, address indexed to, uint value);
588 
589     function name() external pure returns (string memory);
590     function symbol() external pure returns (string memory);
591     function decimals() external pure returns (uint8);
592     function totalSupply() external view returns (uint);
593     function balanceOf(address owner) external view returns (uint);
594     function allowance(address owner, address spender) external view returns (uint);
595 
596     function approve(address spender, uint value) external returns (bool);
597     function transfer(address to, uint value) external returns (bool);
598     function transferFrom(address from, address to, uint value) external returns (bool);
599 
600     function DOMAIN_SEPARATOR() external view returns (bytes32);
601     function PERMIT_TYPEHASH() external pure returns (bytes32);
602     function nonces(address owner) external view returns (uint);
603 
604     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
605 
606     event Mint(address indexed sender, uint amount0, uint amount1);
607     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
608     event Swap(
609         address indexed sender,
610         uint amount0In,
611         uint amount1In,
612         uint amount0Out,
613         uint amount1Out,
614         address indexed to
615     );
616     event Sync(uint112 reserve0, uint112 reserve1);
617 
618     function MINIMUM_LIQUIDITY() external pure returns (uint);
619     function factory() external view returns (address);
620     function token0() external view returns (address);
621     function token1() external view returns (address);
622     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
623     function price0CumulativeLast() external view returns (uint);
624     function price1CumulativeLast() external view returns (uint);
625     function kLast() external view returns (uint);
626 
627     function mint(address to) external returns (uint liquidity);
628     function burn(address to) external returns (uint amount0, uint amount1);
629     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
630     function skim(address to) external;
631     function sync() external;
632 
633     function initialize(address, address) external;
634 }
635 
636 interface IUniswapV2Router01 {
637     function factory() external pure returns (address);
638     function WETH() external pure returns (address);
639 
640     function addLiquidity(
641         address tokenA,
642         address tokenB,
643         uint amountADesired,
644         uint amountBDesired,
645         uint amountAMin,
646         uint amountBMin,
647         address to,
648         uint deadline
649     ) external returns (uint amountA, uint amountB, uint liquidity);
650     function addLiquidityETH(
651         address token,
652         uint amountTokenDesired,
653         uint amountTokenMin,
654         uint amountETHMin,
655         address to,
656         uint deadline
657     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
658     function removeLiquidity(
659         address tokenA,
660         address tokenB,
661         uint liquidity,
662         uint amountAMin,
663         uint amountBMin,
664         address to,
665         uint deadline
666     ) external returns (uint amountA, uint amountB);
667     function removeLiquidityETH(
668         address token,
669         uint liquidity,
670         uint amountTokenMin,
671         uint amountETHMin,
672         address to,
673         uint deadline
674     ) external returns (uint amountToken, uint amountETH);
675     function removeLiquidityWithPermit(
676         address tokenA,
677         address tokenB,
678         uint liquidity,
679         uint amountAMin,
680         uint amountBMin,
681         address to,
682         uint deadline,
683         bool approveMax, uint8 v, bytes32 r, bytes32 s
684     ) external returns (uint amountA, uint amountB);
685     function removeLiquidityETHWithPermit(
686         address token,
687         uint liquidity,
688         uint amountTokenMin,
689         uint amountETHMin,
690         address to,
691         uint deadline,
692         bool approveMax, uint8 v, bytes32 r, bytes32 s
693     ) external returns (uint amountToken, uint amountETH);
694     function swapExactTokensForTokens(
695         uint amountIn,
696         uint amountOutMin,
697         address[] calldata path,
698         address to,
699         uint deadline
700     ) external returns (uint[] memory amounts);
701     function swapTokensForExactTokens(
702         uint amountOut,
703         uint amountInMax,
704         address[] calldata path,
705         address to,
706         uint deadline
707     ) external returns (uint[] memory amounts);
708     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
709         external
710         payable
711         returns (uint[] memory amounts);
712     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
713         external
714         returns (uint[] memory amounts);
715     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
716         external
717         returns (uint[] memory amounts);
718     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
719         external
720         payable
721         returns (uint[] memory amounts);
722 
723     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
724     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
725     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
726     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
727     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
728 }
729 
730 interface IUniswapV2Router02 is IUniswapV2Router01 {
731     function removeLiquidityETHSupportingFeeOnTransferTokens(
732         address token,
733         uint liquidity,
734         uint amountTokenMin,
735         uint amountETHMin,
736         address to,
737         uint deadline
738     ) external returns (uint amountETH);
739     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
740         address token,
741         uint liquidity,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline,
746         bool approveMax, uint8 v, bytes32 r, bytes32 s
747     ) external returns (uint amountETH);
748 
749     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
750         uint amountIn,
751         uint amountOutMin,
752         address[] calldata path,
753         address to,
754         uint deadline
755     ) external;
756     function swapExactETHForTokensSupportingFeeOnTransferTokens(
757         uint amountOutMin,
758         address[] calldata path,
759         address to,
760         uint deadline
761     ) external payable;
762     function swapExactTokensForETHSupportingFeeOnTransferTokens(
763         uint amountIn,
764         uint amountOutMin,
765         address[] calldata path,
766         address to,
767         uint deadline
768     ) external;
769 }
770 
771 // contract implementation
772 contract BabyElon is Context, IERC20, Ownable {
773     using SafeMath for uint256;
774     using Address for address;
775 
776     uint8 private _decimals = 9;
777 
778     // ********************************* START VARIABLES **********************************
779     string private _name = "BabyElon";                                                // name
780     string private _symbol = "BABYELON";                                             // symbol
781     uint256 private _tTotal = 1000 * 10**9 * 10**uint256(_decimals);             // total supply
782 
783     // % to holders
784     uint256 public defaultTaxFee = 5;
785     uint256 public _taxFee = defaultTaxFee;
786     uint256 private _previousTaxFee = _taxFee;
787 
788     // % to swap & send to marketing wallet
789     uint256 public defaultMarketingFee = 0;
790     uint256 public _marketingFee = defaultMarketingFee;
791     uint256 private _previousMarketingFee = _marketingFee;
792 
793     uint256 public _marketingFee4Sellers = 10;
794 
795     bool public feesOnSellersAndBuyers = true;
796 
797     uint256 public _maxTxAmount = _tTotal.div(1).div(100);                                           // max transaction amount
798     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);                     // contract balance to trigger swap & send
799     address payable public marketingWallet = payable(0xbD254a25FCaBa747f3EF82c74ab27785A60d0292); // marketing wallet
800 
801     // ********************************** END VARIABLES ***********************************
802 
803     mapping (address => uint256) private _rOwned;
804     mapping (address => uint256) private _tOwned;
805     mapping (address => mapping (address => uint256)) private _allowances;
806 
807     mapping (address => bool) private _isExcludedFromFee;
808 
809     mapping (address => bool) private _isExcluded;
810 
811     address[] private _excluded;
812     uint256 private constant MAX = ~uint256(0);
813 
814     uint256 private _tFeeTotal;
815     uint256 private _rTotal = (MAX - (MAX % _tTotal));
816 
817     IUniswapV2Router02 public immutable uniswapV2Router;
818     address public immutable uniswapV2Pair;
819 
820     bool inSwapAndSend;
821     bool public SwapAndSendEnabled = true;
822 
823     event SwapAndSendEnabledUpdated(bool enabled);
824 
825     modifier lockTheSwap {
826         inSwapAndSend = true;
827         _;
828         inSwapAndSend = false;
829     }
830 
831     constructor () {
832         _rOwned[_msgSender()] = _rTotal;
833 
834         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
835          // Create a uniswap pair for this new token
836         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
837             .createPair(address(this), _uniswapV2Router.WETH());
838 
839         // set the rest of the contract variables
840         uniswapV2Router = _uniswapV2Router;
841 
842         //exclude owner and this contract from fee
843         _isExcludedFromFee[owner()] = true;
844         _isExcludedFromFee[address(this)] = true;
845 
846         emit Transfer(address(0), _msgSender(), _tTotal);
847     }
848 
849     function name() public view returns (string memory) {
850         return _name;
851     }
852 
853     function symbol() public view returns (string memory) {
854         return _symbol;
855     }
856 
857     function decimals() public view returns (uint8) {
858         return _decimals;
859     }
860 
861     function totalSupply() public view override returns (uint256) {
862         return _tTotal;
863     }
864 
865     function balanceOf(address account) public view override returns (uint256) {
866         if (_isExcluded[account]) return _tOwned[account];
867         return tokenFromReflection(_rOwned[account]);
868     }
869 
870     function transfer(address recipient, uint256 amount) public override returns (bool) {
871         _transfer(_msgSender(), recipient, amount);
872         return true;
873     }
874 
875     function allowance(address owner, address spender) public view override returns (uint256) {
876         return _allowances[owner][spender];
877     }
878 
879     function approve(address spender, uint256 amount) public override returns (bool) {
880         _approve(_msgSender(), spender, amount);
881         return true;
882     }
883 
884     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
885         _transfer(sender, recipient, amount);
886         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
887         return true;
888     }
889 
890     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
891         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
892         return true;
893     }
894 
895     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
896         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
897         return true;
898     }
899 
900     function isExcludedFromReward(address account) public view returns (bool) {
901         return _isExcluded[account];
902     }
903 
904     function totalFees() public view returns (uint256) {
905         return _tFeeTotal;
906     }
907 
908     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
909         require(tAmount <= _tTotal, "Amount must be less than supply");
910         if (!deductTransferFee) {
911             (uint256 rAmount,,,,,) = _getValues(tAmount);
912             return rAmount;
913         } else {
914             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
915             return rTransferAmount;
916         }
917     }
918 
919     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
920         require(rAmount <= _rTotal, "Amount must be less than total reflections");
921         uint256 currentRate =  _getRate();
922         return rAmount.div(currentRate);
923     }
924 
925     function excludeFromReward(address account) public onlyOwner() {
926         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
927         require(!_isExcluded[account], "Account is already excluded");
928         if(_rOwned[account] > 0) {
929             _tOwned[account] = tokenFromReflection(_rOwned[account]);
930         }
931         _isExcluded[account] = true;
932         _excluded.push(account);
933     }
934 
935     function includeInReward(address account) external onlyOwner() {
936         require(_isExcluded[account], "Account is already excluded");
937         for (uint256 i = 0; i < _excluded.length; i++) {
938             if (_excluded[i] == account) {
939                 _excluded[i] = _excluded[_excluded.length - 1];
940                 _tOwned[account] = 0;
941                 _isExcluded[account] = false;
942                 _excluded.pop();
943                 break;
944             }
945         }
946     }
947 
948     function excludeFromFee(address account) public onlyOwner() {
949         _isExcludedFromFee[account] = true;
950     }
951 
952     function includeInFee(address account) public onlyOwner() {
953         _isExcludedFromFee[account] = false;
954     }
955 
956     function removeAllFee() private {
957         if(_taxFee == 0 && _marketingFee == 0) return;
958 
959         _previousTaxFee = _taxFee;
960         _previousMarketingFee = _marketingFee;
961 
962         _taxFee = 0;
963         _marketingFee = 0;
964     }
965 
966     function restoreAllFee() private {
967         _taxFee = _previousTaxFee;
968         _marketingFee = _previousMarketingFee;
969     }
970 
971     //to recieve ETH when swaping
972     receive() external payable {}
973 
974     function _reflectFee(uint256 rFee, uint256 tFee) private {
975         _rTotal = _rTotal.sub(rFee);
976         _tFeeTotal = _tFeeTotal.add(tFee);
977     }
978 
979     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
980         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
981         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
982         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
983     }
984 
985     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
986         uint256 tFee = calculateTaxFee(tAmount);
987         uint256 tMarketing = calculateMarketingFee(tAmount);
988         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
989         return (tTransferAmount, tFee, tMarketing);
990     }
991 
992     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
993         uint256 rAmount = tAmount.mul(currentRate);
994         uint256 rFee = tFee.mul(currentRate);
995         uint256 rMarketing = tMarketing.mul(currentRate);
996         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
997         return (rAmount, rTransferAmount, rFee);
998     }
999 
1000     function _getRate() private view returns(uint256) {
1001         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1002         return rSupply.div(tSupply);
1003     }
1004 
1005     function _getCurrentSupply() private view returns(uint256, uint256) {
1006         uint256 rSupply = _rTotal;
1007         uint256 tSupply = _tTotal;
1008         for (uint256 i = 0; i < _excluded.length; i++) {
1009             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1010             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1011             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1012         }
1013         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1014         return (rSupply, tSupply);
1015     }
1016 
1017     function _takeMarketing(uint256 tMarketing) private {
1018         uint256 currentRate =  _getRate();
1019         uint256 rMarketing = tMarketing.mul(currentRate);
1020         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1021         if(_isExcluded[address(this)])
1022             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1023     }
1024 
1025     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1026         return _amount.mul(_taxFee).div(
1027             10**2
1028         );
1029     }
1030 
1031     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1032         return _amount.mul(_marketingFee).div(
1033             10**2
1034         );
1035     }
1036 
1037     function isExcludedFromFee(address account) public view returns(bool) {
1038         return _isExcludedFromFee[account];
1039     }
1040 
1041     function _approve(address owner, address spender, uint256 amount) private {
1042         require(owner != address(0), "ERC20: approve from the zero address");
1043         require(spender != address(0), "ERC20: approve to the zero address");
1044 
1045         _allowances[owner][spender] = amount;
1046         emit Approval(owner, spender, amount);
1047     }
1048 
1049     function _transfer(
1050         address from,
1051         address to,
1052         uint256 amount
1053     ) private {
1054         require(from != address(0), "ERC20: transfer from the zero address");
1055         require(to != address(0), "ERC20: transfer to the zero address");
1056         require(amount > 0, "Transfer amount must be greater than zero");
1057 
1058         if(from != owner() && to != owner())
1059             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1060 
1061         // is the token balance of this contract address over the min number of
1062         // tokens that we need to initiate a swap + send lock?
1063         // also, don't get caught in a circular sending event.
1064         // also, don't swap & liquify if sender is uniswap pair.
1065         uint256 contractTokenBalance = balanceOf(address(this));
1066         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1067 
1068         if(contractTokenBalance >= _maxTxAmount)
1069         {
1070             contractTokenBalance = _maxTxAmount;
1071         }
1072 
1073         if (
1074             overMinTokenBalance &&
1075             !inSwapAndSend &&
1076             from != uniswapV2Pair &&
1077             SwapAndSendEnabled
1078         ) {
1079             SwapAndSend(contractTokenBalance);
1080         }
1081 
1082         if(feesOnSellersAndBuyers) {
1083             setFees(to);
1084         }
1085 
1086         //indicates if fee should be deducted from transfer
1087         bool takeFee = true;
1088 
1089         //if any account belongs to _isExcludedFromFee account then remove the fee
1090         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1091             takeFee = false;
1092         }
1093 
1094         _tokenTransfer(from,to,amount,takeFee);
1095     }
1096 
1097     function setFees(address recipient) private {
1098         _taxFee = defaultTaxFee;
1099         _marketingFee = defaultMarketingFee;
1100         if (recipient == uniswapV2Pair) { // sell
1101             _marketingFee = _marketingFee4Sellers;
1102         }
1103     }
1104 
1105     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1106         // generate the uniswap pair path of token -> weth
1107         address[] memory path = new address[](2);
1108         path[0] = address(this);
1109         path[1] = uniswapV2Router.WETH();
1110 
1111         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1112 
1113         // make the swap
1114         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1115             contractTokenBalance,
1116             0, // accept any amount of ETH
1117             path,
1118             address(this),
1119             block.timestamp
1120         );
1121 
1122         uint256 contractETHBalance = address(this).balance;
1123         if(contractETHBalance > 0) {
1124             marketingWallet.transfer(contractETHBalance);
1125         }
1126     }
1127 
1128     //this method is responsible for taking all fee, if takeFee is true
1129     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1130         if(!takeFee)
1131             removeAllFee();
1132 
1133         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1134             _transferFromExcluded(sender, recipient, amount);
1135         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1136             _transferToExcluded(sender, recipient, amount);
1137         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1138             _transferStandard(sender, recipient, amount);
1139         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1140             _transferBothExcluded(sender, recipient, amount);
1141         } else {
1142             _transferStandard(sender, recipient, amount);
1143         }
1144 
1145         if(!takeFee)
1146             restoreAllFee();
1147     }
1148 
1149     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1150         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1151         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1152         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1153         _takeMarketing(tMarketing);
1154         _reflectFee(rFee, tFee);
1155         emit Transfer(sender, recipient, tTransferAmount);
1156     }
1157 
1158     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1159         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1160         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1161         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1162         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1163         _takeMarketing(tMarketing);
1164         _reflectFee(rFee, tFee);
1165         emit Transfer(sender, recipient, tTransferAmount);
1166     }
1167 
1168     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1169         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1170         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1171         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1172         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1173         _takeMarketing(tMarketing);
1174         _reflectFee(rFee, tFee);
1175         emit Transfer(sender, recipient, tTransferAmount);
1176     }
1177 
1178     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1179         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1180         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1181         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1182         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1183         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1184         _takeMarketing(tMarketing);
1185         _reflectFee(rFee, tFee);
1186         emit Transfer(sender, recipient, tTransferAmount);
1187     }
1188 
1189     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1190         defaultMarketingFee = marketingFee;
1191     }
1192 
1193     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1194         _marketingFee4Sellers = marketingFee4Sellers;
1195     }
1196 
1197     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1198         feesOnSellersAndBuyers = _enabled;
1199     }
1200 
1201     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1202         SwapAndSendEnabled = _enabled;
1203         emit SwapAndSendEnabledUpdated(_enabled);
1204     }
1205 
1206     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1207         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1208     }
1209 
1210     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1211         marketingWallet = wallet;
1212     }
1213 
1214     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1215         _maxTxAmount = maxTxAmount;
1216     }
1217 }