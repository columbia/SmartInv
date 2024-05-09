1 /**
2 
3 888 INFINITY
4 TOP METAVERSE CASINO & NFT MARKETPLACE  
5 
6 https://www.888infinity.io/
7 
8 */
9 
10 pragma solidity ^0.8.3;
11 // SPDX-License-Identifier: Unlicensed
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18     * @dev Returns the amount of tokens in existence.
19     */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23     * @dev Returns the amount of tokens owned by `account`.
24     */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28     * @dev Moves `amount` tokens from the caller's account to `recipient`.
29     *
30     * Returns a boolean value indicating whether the operation succeeded.
31     *
32     * Emits a {Transfer} event.
33     */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37     * @dev Returns the remaining number of tokens that `spender` will be
38     * allowed to spend on behalf of `owner` through {transferFrom}. This is
39     * zero by default.
40     *
41     * This value changes when {approve} or {transferFrom} are called.
42     */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47     *
48     * Returns a boolean value indicating whether the operation succeeded.
49     *
50     * IMPORTANT: Beware that changing an allowance with this method brings the risk
51     * that someone may use both the old and the new allowance by unfortunate
52     * transaction ordering. One possible solution to mitigate this race
53     * condition is to first reduce the spender's allowance to 0 and set the
54     * desired value afterwards:
55     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56     *
57     * Emits an {Approval} event.
58     */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62     * @dev Moves `amount` tokens from `sender` to `recipient` using the
63     * allowance mechanism. `amount` is then deducted from the caller's
64     * allowance.
65     *
66     * Returns a boolean value indicating whether the operation succeeded.
67     *
68     * Emits a {Transfer} event.
69     */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73     * @dev Emitted when `value` tokens are moved from one account (`from`) to
74     * another (`to`).
75     *
76     * Note that `value` may be zero.
77     */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82     * a call to {approve}. `value` is the new allowance.
83     */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // CAUTION
88 // This version of SafeMath should only be used with Solidity 0.8 or later,
89 // because it relies on the compiler's built in overflow checks.
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations.
93  *
94  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
95  * now has built in overflow checking.
96  */
97 library SafeMath {
98     /**
99     * @dev Returns the addition of two unsigned integers, with an overflow flag.
100     *
101     * _Available since v3.4._
102     */
103     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         unchecked {
105             uint256 c = a + b;
106             if (c < a) return (false, 0);
107             return (true, c);
108         }
109     }
110 
111     /**
112     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
113     *
114     * _Available since v3.4._
115     */
116     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             if (b > a) return (false, 0);
119             return (true, a - b);
120         }
121     }
122 
123     /**
124     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
125     *
126     * _Available since v3.4._
127     */
128     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         unchecked {
130             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131             // benefit is lost if 'b' is also tested.
132             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
133             if (a == 0) return (true, 0);
134             uint256 c = a * b;
135             if (c / a != b) return (false, 0);
136             return (true, c);
137         }
138     }
139 
140     /**
141     * @dev Returns the division of two unsigned integers, with a division by zero flag.
142     *
143     * _Available since v3.4._
144     */
145     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b == 0) return (false, 0);
148             return (true, a / b);
149         }
150     }
151 
152     /**
153     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
154     *
155     * _Available since v3.4._
156     */
157     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         unchecked {
159             if (b == 0) return (false, 0);
160             return (true, a % b);
161         }
162     }
163 
164     /**
165     * @dev Returns the addition of two unsigned integers, reverting on
166     * overflow.
167     *
168     * Counterpart to Solidity's `+` operator.
169     *
170     * Requirements:
171     *
172     * - Addition cannot overflow.
173     */
174     function add(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a + b;
176     }
177 
178     /**
179     * @dev Returns the subtraction of two unsigned integers, reverting on
180     * overflow (when the result is negative).
181     *
182     * Counterpart to Solidity's `-` operator.
183     *
184     * Requirements:
185     *
186     * - Subtraction cannot overflow.
187     */
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         return a - b;
190     }
191 
192     /**
193     * @dev Returns the multiplication of two unsigned integers, reverting on
194     * overflow.
195     *
196     * Counterpart to Solidity's `*` operator.
197     *
198     * Requirements:
199     *
200     * - Multiplication cannot overflow.
201     */
202     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203         return a * b;
204     }
205 
206     /**
207     * @dev Returns the integer division of two unsigned integers, reverting on
208     * division by zero. The result is rounded towards zero.
209     *
210     * Counterpart to Solidity's `/` operator.
211     *
212     * Requirements:
213     *
214     * - The divisor cannot be zero.
215     */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return a / b;
218     }
219 
220     /**
221     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222     * reverting when dividing by zero.
223     *
224     * Counterpart to Solidity's `%` operator. This function uses a `revert`
225     * opcode (which leaves remaining gas untouched) while Solidity uses an
226     * invalid opcode to revert (consuming all remaining gas).
227     *
228     * Requirements:
229     *
230     * - The divisor cannot be zero.
231     */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return a % b;
234     }
235 
236     /**
237     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238     * overflow (when the result is negative).
239     *
240     * CAUTION: This function is deprecated because it requires allocating memory for the error
241     * message unnecessarily. For custom revert reasons use {trySub}.
242     *
243     * Counterpart to Solidity's `-` operator.
244     *
245     * Requirements:
246     *
247     * - Subtraction cannot overflow.
248     */
249     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         unchecked {
251             require(b <= a, errorMessage);
252             return a - b;
253         }
254     }
255 
256     /**
257     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
258     * division by zero. The result is rounded towards zero.
259     *
260     * Counterpart to Solidity's `%` operator. This function uses a `revert`
261     * opcode (which leaves remaining gas untouched) while Solidity uses an
262     * invalid opcode to revert (consuming all remaining gas).
263     *
264     * Counterpart to Solidity's `/` operator. Note: this function uses a
265     * `revert` opcode (which leaves remaining gas untouched) while Solidity
266     * uses an invalid opcode to revert (consuming all remaining gas).
267     *
268     * Requirements:
269     *
270     * - The divisor cannot be zero.
271     */
272     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         unchecked {
274             require(b > 0, errorMessage);
275             return a / b;
276         }
277     }
278 
279     /**
280     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281     * reverting with custom message when dividing by zero.
282     *
283     * CAUTION: This function is deprecated because it requires allocating memory for the error
284     * message unnecessarily. For custom revert reasons use {tryMod}.
285     *
286     * Counterpart to Solidity's `%` operator. This function uses a `revert`
287     * opcode (which leaves remaining gas untouched) while Solidity uses an
288     * invalid opcode to revert (consuming all remaining gas).
289     *
290     * Requirements:
291     *
292     * - The divisor cannot be zero.
293     */
294     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         unchecked {
296             require(b > 0, errorMessage);
297             return a % b;
298         }
299     }
300 }
301 
302 /*
303  * @dev Provides information about the current execution context, including the
304  * sender of the transaction and its data. While these are generally available
305  * via msg.sender and msg.data, they should not be accessed in such a direct
306  * manner, since when dealing with meta-transactions the account sending and
307  * paying for execution may not be the actual sender (as far as an application
308  * is concerned).
309  *
310  * This contract is only required for intermediate, library-like contracts.
311  */
312 abstract contract Context {
313     function _msgSender() internal view virtual returns (address) {
314         return msg.sender;
315     }
316 
317     function _msgData() internal view virtual returns (bytes calldata) {
318         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
319         return msg.data;
320     }
321 }
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328     * @dev Returns true if `account` is a contract.
329     *
330     * [IMPORTANT]
331     * ====
332     * It is unsafe to assume that an address for which this function returns
333     * false is an externally-owned account (EOA) and not a contract.
334     *
335     * Among others, `isContract` will return false for the following
336     * types of addresses:
337     *
338     *  - an externally-owned account
339     *  - a contract in construction
340     *  - an address where a contract will be created
341     *  - an address where a contract lived, but was destroyed
342     * ====
343     */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies on extcodesize, which returns 0 for contracts in
346         // construction, since the code is only stored at the end of the
347         // constructor execution.
348 
349         uint256 size;
350         // solhint-disable-next-line no-inline-assembly
351         assembly { size := extcodesize(account) }
352         return size > 0;
353     }
354 
355     /**
356     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357     * `recipient`, forwarding all available gas and reverting on errors.
358     *
359     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360     * of certain opcodes, possibly making contracts go over the 2300 gas limit
361     * imposed by `transfer`, making them unable to receive funds via
362     * `transfer`. {sendValue} removes this limitation.
363     *
364     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365     *
366     * IMPORTANT: because control is transferred to `recipient`, care must be
367     * taken to not create reentrancy vulnerabilities. Consider using
368     * {ReentrancyGuard} or the
369     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370     */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
375         (bool success, ) = recipient.call{ value: amount }("");
376         require(success, "Address: unable to send value, recipient may have reverted");
377     }
378 
379     /**
380     * @dev Performs a Solidity function call using a low level `call`. A
381     * plain`call` is an unsafe replacement for a function call: use this
382     * function instead.
383     *
384     * If `target` reverts with a revert reason, it is bubbled up by this
385     * function (like regular Solidity function calls).
386     *
387     * Returns the raw returned data. To convert to the expected return value,
388     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389     *
390     * Requirements:
391     *
392     * - `target` must be a contract.
393     * - calling `target` with `data` must not revert.
394     *
395     * _Available since v3.1._
396     */
397     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
398       return functionCall(target, data, "Address: low-level call failed");
399     }
400 
401     /**
402     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
403     * `errorMessage` as a fallback revert reason when `target` reverts.
404     *
405     * _Available since v3.1._
406     */
407     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413     * but also transferring `value` wei to `target`.
414     *
415     * Requirements:
416     *
417     * - the calling contract must have an ETH balance of at least `value`.
418     * - the called Solidity function must be `payable`.
419     *
420     * _Available since v3.1._
421     */
422     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428     * with `errorMessage` as a fallback revert reason when `target` reverts.
429     *
430     * _Available since v3.1._
431     */
432     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.call{ value: value }(data);
438         return _verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443     * but performing a static call.
444     *
445     * _Available since v3.3._
446     */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453     * but performing a static call.
454     *
455     * _Available since v3.3._
456     */
457     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.staticcall(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467     * but performing a delegate call.
468     *
469     * _Available since v3.4._
470     */
471     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
473     }
474 
475     /**
476     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477     * but performing a delegate call.
478     *
479     * _Available since v3.4._
480     */
481     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
482         require(isContract(target), "Address: delegate call to non-contract");
483 
484         // solhint-disable-next-line avoid-low-level-calls
485         (bool success, bytes memory returndata) = target.delegatecall(data);
486         return _verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 // solhint-disable-next-line no-inline-assembly
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 /**
510  * @dev Contract module which provides a basic access control mechanism, where
511  * there is an account (an owner) that can be granted exclusive access to
512  * specific functions.
513  *
514  * By default, the owner account will be the one that deploys the contract. This
515  * can later be changed with {transferOwnership}.
516  *
517  * This module is used through inheritance. It will make available the modifier
518  * `onlyOwner`, which can be applied to your functions to restrict their use to
519  * the owner.
520  */
521 abstract contract Ownable is Context {
522     address private _owner;
523 
524     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
525 
526     /**
527     * @dev Initializes the contract setting the deployer as the initial owner.
528     */
529     constructor () {
530         _owner = _msgSender();
531         emit OwnershipTransferred(address(0), _owner);
532     }
533 
534     /**
535     * @dev Returns the address of the current owner.
536     */
537     function owner() public view virtual returns (address) {
538         return _owner;
539     }
540 
541     /**
542     * @dev Throws if called by any account other than the owner.
543     */
544     modifier onlyOwner() {
545         require(owner() == _msgSender(), "Ownable: caller is not the owner");
546         _;
547     }
548 
549     /**
550     * @dev Leaves the contract without owner. It will not be possible to call
551     * `onlyOwner` functions anymore. Can only be called by the current owner.
552     *
553     * NOTE: Renouncing ownership will leave the contract without an owner,
554     * thereby removing any functionality that is only available to the owner.
555     */
556     function renounceOwnership() public virtual onlyOwner {
557         emit OwnershipTransferred(_owner, address(0));
558         _owner = address(0);
559     }
560 
561     /**
562     * @dev Transfers ownership of the contract to a new account (`newOwner`).
563     * Can only be called by the current owner.
564     */
565     function transferOwnership(address newOwner) public virtual onlyOwner {
566         require(newOwner != address(0), "Ownable: new owner is the zero address");
567         emit OwnershipTransferred(_owner, newOwner);
568         _owner = newOwner;
569     }
570 }
571 
572 interface IUniswapV2Factory {
573     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
574 
575     function feeTo() external view returns (address);
576     function feeToSetter() external view returns (address);
577 
578     function getPair(address tokenA, address tokenB) external view returns (address pair);
579     function allPairs(uint) external view returns (address pair);
580     function allPairsLength() external view returns (uint);
581 
582     function createPair(address tokenA, address tokenB) external returns (address pair);
583 
584     function setFeeTo(address) external;
585     function setFeeToSetter(address) external;
586 }
587 
588 interface IUniswapV2Pair {
589     event Approval(address indexed owner, address indexed spender, uint value);
590     event Transfer(address indexed from, address indexed to, uint value);
591 
592     function name() external pure returns (string memory);
593     function symbol() external pure returns (string memory);
594     function decimals() external pure returns (uint8);
595     function totalSupply() external view returns (uint);
596     function balanceOf(address owner) external view returns (uint);
597     function allowance(address owner, address spender) external view returns (uint);
598 
599     function approve(address spender, uint value) external returns (bool);
600     function transfer(address to, uint value) external returns (bool);
601     function transferFrom(address from, address to, uint value) external returns (bool);
602 
603     function DOMAIN_SEPARATOR() external view returns (bytes32);
604     function PERMIT_TYPEHASH() external pure returns (bytes32);
605     function nonces(address owner) external view returns (uint);
606 
607     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
608 
609     event Mint(address indexed sender, uint amount0, uint amount1);
610     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
611     event Swap(
612         address indexed sender,
613         uint amount0In,
614         uint amount1In,
615         uint amount0Out,
616         uint amount1Out,
617         address indexed to
618     );
619     event Sync(uint112 reserve0, uint112 reserve1);
620 
621     function MINIMUM_LIQUIDITY() external pure returns (uint);
622     function factory() external view returns (address);
623     function token0() external view returns (address);
624     function token1() external view returns (address);
625     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
626     function price0CumulativeLast() external view returns (uint);
627     function price1CumulativeLast() external view returns (uint);
628     function kLast() external view returns (uint);
629 
630     function mint(address to) external returns (uint liquidity);
631     function burn(address to) external returns (uint amount0, uint amount1);
632     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
633     function skim(address to) external;
634     function sync() external;
635 
636     function initialize(address, address) external;
637 }
638 
639 interface IUniswapV2Router01 {
640     function factory() external pure returns (address);
641     function WETH() external pure returns (address);
642 
643     function addLiquidity(
644         address tokenA,
645         address tokenB,
646         uint amountADesired,
647         uint amountBDesired,
648         uint amountAMin,
649         uint amountBMin,
650         address to,
651         uint deadline
652     ) external returns (uint amountA, uint amountB, uint liquidity);
653     function addLiquidityETH(
654         address token,
655         uint amountTokenDesired,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline
660     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
661     function removeLiquidity(
662         address tokenA,
663         address tokenB,
664         uint liquidity,
665         uint amountAMin,
666         uint amountBMin,
667         address to,
668         uint deadline
669     ) external returns (uint amountA, uint amountB);
670     function removeLiquidityETH(
671         address token,
672         uint liquidity,
673         uint amountTokenMin,
674         uint amountETHMin,
675         address to,
676         uint deadline
677     ) external returns (uint amountToken, uint amountETH);
678     function removeLiquidityWithPermit(
679         address tokenA,
680         address tokenB,
681         uint liquidity,
682         uint amountAMin,
683         uint amountBMin,
684         address to,
685         uint deadline,
686         bool approveMax, uint8 v, bytes32 r, bytes32 s
687     ) external returns (uint amountA, uint amountB);
688     function removeLiquidityETHWithPermit(
689         address token,
690         uint liquidity,
691         uint amountTokenMin,
692         uint amountETHMin,
693         address to,
694         uint deadline,
695         bool approveMax, uint8 v, bytes32 r, bytes32 s
696     ) external returns (uint amountToken, uint amountETH);
697     function swapExactTokensForTokens(
698         uint amountIn,
699         uint amountOutMin,
700         address[] calldata path,
701         address to,
702         uint deadline
703     ) external returns (uint[] memory amounts);
704     function swapTokensForExactTokens(
705         uint amountOut,
706         uint amountInMax,
707         address[] calldata path,
708         address to,
709         uint deadline
710     ) external returns (uint[] memory amounts);
711     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
712         external
713         payable
714         returns (uint[] memory amounts);
715     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
716         external
717         returns (uint[] memory amounts);
718     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
719         external
720         returns (uint[] memory amounts);
721     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
722         external
723         payable
724         returns (uint[] memory amounts);
725 
726     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
727     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
728     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
729     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
730     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
731 }
732 
733 interface IUniswapV2Router02 is IUniswapV2Router01 {
734     function removeLiquidityETHSupportingFeeOnTransferTokens(
735         address token,
736         uint liquidity,
737         uint amountTokenMin,
738         uint amountETHMin,
739         address to,
740         uint deadline
741     ) external returns (uint amountETH);
742     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
743         address token,
744         uint liquidity,
745         uint amountTokenMin,
746         uint amountETHMin,
747         address to,
748         uint deadline,
749         bool approveMax, uint8 v, bytes32 r, bytes32 s
750     ) external returns (uint amountETH);
751 
752     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
753         uint amountIn,
754         uint amountOutMin,
755         address[] calldata path,
756         address to,
757         uint deadline
758     ) external;
759     function swapExactETHForTokensSupportingFeeOnTransferTokens(
760         uint amountOutMin,
761         address[] calldata path,
762         address to,
763         uint deadline
764     ) external payable;
765     function swapExactTokensForETHSupportingFeeOnTransferTokens(
766         uint amountIn,
767         uint amountOutMin,
768         address[] calldata path,
769         address to,
770         uint deadline
771     ) external;
772 }
773 
774 // contract implementation
775 contract EightEightEight is Context, IERC20, Ownable {
776     using SafeMath for uint256;
777     using Address for address;
778 
779     uint8 private _decimals = 9;
780 
781     // 
782     string private _name = "888 INFINITY";                                           // name
783     string private _symbol = "888";                                            // symbol
784     uint256 private _tTotal = 1000 * 10**9 * 10**uint256(_decimals);
785 
786     // % to holders
787     uint256 public defaultTaxFee = 2;
788     uint256 public _taxFee = defaultTaxFee;
789     uint256 private _previousTaxFee = _taxFee;
790 
791     // % to swap & send to marketing wallet
792     uint256 public defaultMarketingFee = 6;
793     uint256 public _marketingFee = defaultMarketingFee;
794     uint256 private _previousMarketingFee = _marketingFee;
795 
796     uint256 public _marketingFee4Sellers = 6;
797 
798     bool public feesOnSellersAndBuyers = true;
799 
800     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
801     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
802     address payable public marketingWallet = payable(0x138359839853F623D6fA03104f067d1dEE19082c);
803 
804     //
805 
806     mapping (address => uint256) private _rOwned;
807     mapping (address => uint256) private _tOwned;
808     mapping (address => mapping (address => uint256)) private _allowances;
809 
810     mapping (address => bool) private _isExcludedFromFee;
811 
812     mapping (address => bool) private _isExcluded;
813 
814     address[] private _excluded;
815     uint256 private constant MAX = ~uint256(0);
816 
817     uint256 private _tFeeTotal;
818     uint256 private _rTotal = (MAX - (MAX % _tTotal));
819 
820     IUniswapV2Router02 public immutable uniswapV2Router;
821     address public immutable uniswapV2Pair;
822 
823     bool inSwapAndSend;
824     bool public SwapAndSendEnabled = true;
825 
826     event SwapAndSendEnabledUpdated(bool enabled);
827 
828     modifier lockTheSwap {
829         inSwapAndSend = true;
830         _;
831         inSwapAndSend = false;
832     }
833 
834     constructor () {
835         _rOwned[_msgSender()] = _rTotal;
836 
837         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
838          // Create a uniswap pair for this new token
839         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
840             .createPair(address(this), _uniswapV2Router.WETH());
841 
842         // set the rest of the contract variables
843         uniswapV2Router = _uniswapV2Router;
844 
845         //exclude owner and this contract from fee
846         _isExcludedFromFee[owner()] = true;
847         _isExcludedFromFee[address(this)] = true;
848 
849         emit Transfer(address(0), _msgSender(), _tTotal);
850     }
851 
852     function name() public view returns (string memory) {
853         return _name;
854     }
855 
856     function symbol() public view returns (string memory) {
857         return _symbol;
858     }
859 
860     function decimals() public view returns (uint8) {
861         return _decimals;
862     }
863 
864     function totalSupply() public view override returns (uint256) {
865         return _tTotal;
866     }
867 
868     function balanceOf(address account) public view override returns (uint256) {
869         if (_isExcluded[account]) return _tOwned[account];
870         return tokenFromReflection(_rOwned[account]);
871     }
872 
873     function transfer(address recipient, uint256 amount) public override returns (bool) {
874         _transfer(_msgSender(), recipient, amount);
875         return true;
876     }
877 
878     function allowance(address owner, address spender) public view override returns (uint256) {
879         return _allowances[owner][spender];
880     }
881 
882     function approve(address spender, uint256 amount) public override returns (bool) {
883         _approve(_msgSender(), spender, amount);
884         return true;
885     }
886 
887     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
888         _transfer(sender, recipient, amount);
889         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
890         return true;
891     }
892 
893     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
894         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
895         return true;
896     }
897 
898     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
899         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
900         return true;
901     }
902 
903     function isExcludedFromReward(address account) public view returns (bool) {
904         return _isExcluded[account];
905     }
906 
907     function totalFees() public view returns (uint256) {
908         return _tFeeTotal;
909     }
910 
911     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
912         require(tAmount <= _tTotal, "Amount must be less than supply");
913         if (!deductTransferFee) {
914             (uint256 rAmount,,,,,) = _getValues(tAmount);
915             return rAmount;
916         } else {
917             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
918             return rTransferAmount;
919         }
920     }
921 
922     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
923         require(rAmount <= _rTotal, "Amount must be less than total reflections");
924         uint256 currentRate =  _getRate();
925         return rAmount.div(currentRate);
926     }
927 
928     function excludeFromReward(address account) public onlyOwner() {
929         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
930         require(!_isExcluded[account], "Account is already excluded");
931         if(_rOwned[account] > 0) {
932             _tOwned[account] = tokenFromReflection(_rOwned[account]);
933         }
934         _isExcluded[account] = true;
935         _excluded.push(account);
936     }
937 
938     function includeInReward(address account) external onlyOwner() {
939         require(_isExcluded[account], "Account is already excluded");
940         for (uint256 i = 0; i < _excluded.length; i++) {
941             if (_excluded[i] == account) {
942                 _excluded[i] = _excluded[_excluded.length - 1];
943                 _tOwned[account] = 0;
944                 _isExcluded[account] = false;
945                 _excluded.pop();
946                 break;
947             }
948         }
949     }
950 
951     function excludeFromFee(address account) public onlyOwner() {
952         _isExcludedFromFee[account] = true;
953     }
954 
955     function includeInFee(address account) public onlyOwner() {
956         _isExcludedFromFee[account] = false;
957     }
958 
959     function removeAllFee() private {
960         if(_taxFee == 0 && _marketingFee == 0) return;
961 
962         _previousTaxFee = _taxFee;
963         _previousMarketingFee = _marketingFee;
964 
965         _taxFee = 0;
966         _marketingFee = 0;
967     }
968 
969     function restoreAllFee() private {
970         _taxFee = _previousTaxFee;
971         _marketingFee = _previousMarketingFee;
972     }
973 
974     //to recieve ETH
975     receive() external payable {}
976 
977     function _reflectFee(uint256 rFee, uint256 tFee) private {
978         _rTotal = _rTotal.sub(rFee);
979         _tFeeTotal = _tFeeTotal.add(tFee);
980     }
981 
982     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
983         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
984         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
985         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
986     }
987 
988     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
989         uint256 tFee = calculateTaxFee(tAmount);
990         uint256 tMarketing = calculateMarketingFee(tAmount);
991         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
992         return (tTransferAmount, tFee, tMarketing);
993     }
994 
995     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
996         uint256 rAmount = tAmount.mul(currentRate);
997         uint256 rFee = tFee.mul(currentRate);
998         uint256 rMarketing = tMarketing.mul(currentRate);
999         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
1000         return (rAmount, rTransferAmount, rFee);
1001     }
1002 
1003     function _getRate() private view returns(uint256) {
1004         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1005         return rSupply.div(tSupply);
1006     }
1007 
1008     function _getCurrentSupply() private view returns(uint256, uint256) {
1009         uint256 rSupply = _rTotal;
1010         uint256 tSupply = _tTotal;
1011         for (uint256 i = 0; i < _excluded.length; i++) {
1012             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1013             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1014             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1015         }
1016         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1017         return (rSupply, tSupply);
1018     }
1019 
1020     function _takeMarketing(uint256 tMarketing) private {
1021         uint256 currentRate =  _getRate();
1022         uint256 rMarketing = tMarketing.mul(currentRate);
1023         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1024         if(_isExcluded[address(this)])
1025             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1026     }
1027 
1028     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1029         return _amount.mul(_taxFee).div(
1030             10**2
1031         );
1032     }
1033 
1034     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1035         return _amount.mul(_marketingFee).div(
1036             10**2
1037         );
1038     }
1039 
1040     function isExcludedFromFee(address account) public view returns(bool) {
1041         return _isExcludedFromFee[account];
1042     }
1043 
1044     function _approve(address owner, address spender, uint256 amount) private {
1045         require(owner != address(0), "ERC20: approve from the zero address");
1046         require(spender != address(0), "ERC20: approve to the zero address");
1047 
1048         _allowances[owner][spender] = amount;
1049         emit Approval(owner, spender, amount);
1050     }
1051 
1052     function _transfer(
1053         address from,
1054         address to,
1055         uint256 amount
1056     ) private {
1057         require(from != address(0), "ERC20: transfer from the zero address");
1058         require(to != address(0), "ERC20: transfer to the zero address");
1059         require(amount > 0, "Transfer amount must be greater than zero");
1060 
1061         if(from != owner() && to != owner())
1062             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1063 
1064         // is the token balance of this contract address over the min number of
1065         // tokens that we need to initiate a swap + send lock?
1066         // also, don't get caught in a circular sending event.
1067         // also, don't swap & liquify if sender is uniswap pair.
1068         uint256 contractTokenBalance = balanceOf(address(this));
1069         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1070 
1071         if(contractTokenBalance >= _maxTxAmount)
1072         {
1073             contractTokenBalance = _maxTxAmount;
1074         }
1075 
1076         if (
1077             overMinTokenBalance &&
1078             !inSwapAndSend &&
1079             from != uniswapV2Pair &&
1080             SwapAndSendEnabled
1081         ) {
1082             SwapAndSend(contractTokenBalance);
1083         }
1084 
1085         if(feesOnSellersAndBuyers) {
1086             setFees(to);
1087         }
1088 
1089         //indicates if fee should be deducted from transfer
1090         bool takeFee = true;
1091 
1092         //if any account belongs to _isExcludedFromFee account then remove the fee
1093         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1094             takeFee = false;
1095         }
1096 
1097         _tokenTransfer(from,to,amount,takeFee);
1098     }
1099 
1100     function setFees(address recipient) private {
1101         _taxFee = defaultTaxFee;
1102         _marketingFee = defaultMarketingFee;
1103         if (recipient == uniswapV2Pair) { // sell
1104             _marketingFee = _marketingFee4Sellers;
1105         }
1106     }
1107 
1108     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1109         // generate the uniswap pair path of token -> weth
1110         address[] memory path = new address[](2);
1111         path[0] = address(this);
1112         path[1] = uniswapV2Router.WETH();
1113 
1114         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1115 
1116         // make the swap
1117         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1118             contractTokenBalance,
1119             0, // accept any amount of ETH
1120             path,
1121             address(this),
1122             block.timestamp
1123         );
1124 
1125         uint256 contractETHBalance = address(this).balance;
1126         if(contractETHBalance > 0) {
1127             marketingWallet.transfer(contractETHBalance);
1128         }
1129     }
1130 
1131     //this method is responsible for taking all fee, if takeFee is true
1132     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1133         if(!takeFee)
1134             removeAllFee();
1135 
1136         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1137             _transferFromExcluded(sender, recipient, amount);
1138         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1139             _transferToExcluded(sender, recipient, amount);
1140         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1141             _transferStandard(sender, recipient, amount);
1142         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1143             _transferBothExcluded(sender, recipient, amount);
1144         } else {
1145             _transferStandard(sender, recipient, amount);
1146         }
1147 
1148         if(!takeFee)
1149             restoreAllFee();
1150     }
1151 
1152     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1153         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1154         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1155         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1156         _takeMarketing(tMarketing);
1157         _reflectFee(rFee, tFee);
1158         emit Transfer(sender, recipient, tTransferAmount);
1159     }
1160 
1161     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1162         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1163         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1164         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1165         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1166         _takeMarketing(tMarketing);
1167         _reflectFee(rFee, tFee);
1168         emit Transfer(sender, recipient, tTransferAmount);
1169     }
1170 
1171     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1172         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1173         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1174         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1175         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1176         _takeMarketing(tMarketing);
1177         _reflectFee(rFee, tFee);
1178         emit Transfer(sender, recipient, tTransferAmount);
1179     }
1180 
1181     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1182         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1183         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1184         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1185         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1186         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1187         _takeMarketing(tMarketing);
1188         _reflectFee(rFee, tFee);
1189         emit Transfer(sender, recipient, tTransferAmount);
1190     }
1191 
1192     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1193         defaultMarketingFee = marketingFee;
1194     }
1195 
1196     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1197         _marketingFee4Sellers = marketingFee4Sellers;
1198     }
1199 
1200     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1201         feesOnSellersAndBuyers = _enabled;
1202     }
1203 
1204     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1205         SwapAndSendEnabled = _enabled;
1206         emit SwapAndSendEnabledUpdated(_enabled);
1207     }
1208 
1209     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1210         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1211     }
1212 
1213     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1214         marketingWallet = wallet;
1215     }
1216 
1217     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1218         _maxTxAmount = maxTxAmount;
1219     }
1220 }