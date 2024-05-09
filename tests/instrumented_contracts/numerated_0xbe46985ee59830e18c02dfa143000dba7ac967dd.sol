1 /**
2 
3 Baby Penguins - Pudgey Penguins
4 
5 Website: https://www.babypenguins.org/
6 Telegram: https://t.me/BabyPenguinERC
7 Twitter: https://twitter.com/babypenguinserc
8 
9 */
10 
11 pragma solidity ^0.8.3;
12 // SPDX-License-Identifier: Unlicensed
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19     * @dev Returns the amount of tokens in existence.
20     */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24     * @dev Returns the amount of tokens owned by `account`.
25     */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29     * @dev Moves `amount` tokens from the caller's account to `recipient`.
30     *
31     * Returns a boolean value indicating whether the operation succeeded.
32     *
33     * Emits a {Transfer} event.
34     */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38     * @dev Returns the remaining number of tokens that `spender` will be
39     * allowed to spend on behalf of `owner` through {transferFrom}. This is
40     * zero by default.
41     *
42     * This value changes when {approve} or {transferFrom} are called.
43     */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48     *
49     * Returns a boolean value indicating whether the operation succeeded.
50     *
51     * IMPORTANT: Beware that changing an allowance with this method brings the risk
52     * that someone may use both the old and the new allowance by unfortunate
53     * transaction ordering. One possible solution to mitigate this race
54     * condition is to first reduce the spender's allowance to 0 and set the
55     * desired value afterwards:
56     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57     *
58     * Emits an {Approval} event.
59     */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63     * @dev Moves `amount` tokens from `sender` to `recipient` using the
64     * allowance mechanism. `amount` is then deducted from the caller's
65     * allowance.
66     *
67     * Returns a boolean value indicating whether the operation succeeded.
68     *
69     * Emits a {Transfer} event.
70     */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74     * @dev Emitted when `value` tokens are moved from one account (`from`) to
75     * another (`to`).
76     *
77     * Note that `value` may be zero.
78     */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83     * a call to {approve}. `value` is the new allowance.
84     */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // CAUTION
89 // This version of SafeMath should only be used with Solidity 0.8 or later,
90 // because it relies on the compiler's built in overflow checks.
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations.
94  *
95  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
96  * now has built in overflow checking.
97  */
98 library SafeMath {
99     /**
100     * @dev Returns the addition of two unsigned integers, with an overflow flag.
101     *
102     * _Available since v3.4._
103     */
104     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             uint256 c = a + b;
107             if (c < a) return (false, 0);
108             return (true, c);
109         }
110     }
111 
112     /**
113     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
114     *
115     * _Available since v3.4._
116     */
117     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         unchecked {
119             if (b > a) return (false, 0);
120             return (true, a - b);
121         }
122     }
123 
124     /**
125     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
126     *
127     * _Available since v3.4._
128     */
129     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         unchecked {
131             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132             // benefit is lost if 'b' is also tested.
133             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
134             if (a == 0) return (true, 0);
135             uint256 c = a * b;
136             if (c / a != b) return (false, 0);
137             return (true, c);
138         }
139     }
140 
141     /**
142     * @dev Returns the division of two unsigned integers, with a division by zero flag.
143     *
144     * _Available since v3.4._
145     */
146     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         unchecked {
148             if (b == 0) return (false, 0);
149             return (true, a / b);
150         }
151     }
152 
153     /**
154     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
155     *
156     * _Available since v3.4._
157     */
158     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         unchecked {
160             if (b == 0) return (false, 0);
161             return (true, a % b);
162         }
163     }
164 
165     /**
166     * @dev Returns the addition of two unsigned integers, reverting on
167     * overflow.
168     *
169     * Counterpart to Solidity's `+` operator.
170     *
171     * Requirements:
172     *
173     * - Addition cannot overflow.
174     */
175     function add(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a + b;
177     }
178 
179     /**
180     * @dev Returns the subtraction of two unsigned integers, reverting on
181     * overflow (when the result is negative).
182     *
183     * Counterpart to Solidity's `-` operator.
184     *
185     * Requirements:
186     *
187     * - Subtraction cannot overflow.
188     */
189     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a - b;
191     }
192 
193     /**
194     * @dev Returns the multiplication of two unsigned integers, reverting on
195     * overflow.
196     *
197     * Counterpart to Solidity's `*` operator.
198     *
199     * Requirements:
200     *
201     * - Multiplication cannot overflow.
202     */
203     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a * b;
205     }
206 
207     /**
208     * @dev Returns the integer division of two unsigned integers, reverting on
209     * division by zero. The result is rounded towards zero.
210     *
211     * Counterpart to Solidity's `/` operator.
212     *
213     * Requirements:
214     *
215     * - The divisor cannot be zero.
216     */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a / b;
219     }
220 
221     /**
222     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223     * reverting when dividing by zero.
224     *
225     * Counterpart to Solidity's `%` operator. This function uses a `revert`
226     * opcode (which leaves remaining gas untouched) while Solidity uses an
227     * invalid opcode to revert (consuming all remaining gas).
228     *
229     * Requirements:
230     *
231     * - The divisor cannot be zero.
232     */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a % b;
235     }
236 
237     /**
238     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
239     * overflow (when the result is negative).
240     *
241     * CAUTION: This function is deprecated because it requires allocating memory for the error
242     * message unnecessarily. For custom revert reasons use {trySub}.
243     *
244     * Counterpart to Solidity's `-` operator.
245     *
246     * Requirements:
247     *
248     * - Subtraction cannot overflow.
249     */
250     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         unchecked {
252             require(b <= a, errorMessage);
253             return a - b;
254         }
255     }
256 
257     /**
258     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
259     * division by zero. The result is rounded towards zero.
260     *
261     * Counterpart to Solidity's `%` operator. This function uses a `revert`
262     * opcode (which leaves remaining gas untouched) while Solidity uses an
263     * invalid opcode to revert (consuming all remaining gas).
264     *
265     * Counterpart to Solidity's `/` operator. Note: this function uses a
266     * `revert` opcode (which leaves remaining gas untouched) while Solidity
267     * uses an invalid opcode to revert (consuming all remaining gas).
268     *
269     * Requirements:
270     *
271     * - The divisor cannot be zero.
272     */
273     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         unchecked {
275             require(b > 0, errorMessage);
276             return a / b;
277         }
278     }
279 
280     /**
281     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282     * reverting with custom message when dividing by zero.
283     *
284     * CAUTION: This function is deprecated because it requires allocating memory for the error
285     * message unnecessarily. For custom revert reasons use {tryMod}.
286     *
287     * Counterpart to Solidity's `%` operator. This function uses a `revert`
288     * opcode (which leaves remaining gas untouched) while Solidity uses an
289     * invalid opcode to revert (consuming all remaining gas).
290     *
291     * Requirements:
292     *
293     * - The divisor cannot be zero.
294     */
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         unchecked {
297             require(b > 0, errorMessage);
298             return a % b;
299         }
300     }
301 }
302 
303 /*
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 abstract contract Context {
314     function _msgSender() internal view virtual returns (address) {
315         return msg.sender;
316     }
317 
318     function _msgData() internal view virtual returns (bytes calldata) {
319         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
320         return msg.data;
321     }
322 }
323 
324 /**
325  * @dev Collection of functions related to the address type
326  */
327 library Address {
328     /**
329     * @dev Returns true if `account` is a contract.
330     *
331     * [IMPORTANT]
332     * ====
333     * It is unsafe to assume that an address for which this function returns
334     * false is an externally-owned account (EOA) and not a contract.
335     *
336     * Among others, `isContract` will return false for the following
337     * types of addresses:
338     *
339     *  - an externally-owned account
340     *  - a contract in construction
341     *  - an address where a contract will be created
342     *  - an address where a contract lived, but was destroyed
343     * ====
344     */
345     function isContract(address account) internal view returns (bool) {
346         // This method relies on extcodesize, which returns 0 for contracts in
347         // construction, since the code is only stored at the end of the
348         // constructor execution.
349 
350         uint256 size;
351         // solhint-disable-next-line no-inline-assembly
352         assembly { size := extcodesize(account) }
353         return size > 0;
354     }
355 
356     /**
357     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358     * `recipient`, forwarding all available gas and reverting on errors.
359     *
360     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361     * of certain opcodes, possibly making contracts go over the 2300 gas limit
362     * imposed by `transfer`, making them unable to receive funds via
363     * `transfer`. {sendValue} removes this limitation.
364     *
365     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366     *
367     * IMPORTANT: because control is transferred to `recipient`, care must be
368     * taken to not create reentrancy vulnerabilities. Consider using
369     * {ReentrancyGuard} or the
370     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371     */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(address(this).balance >= amount, "Address: insufficient balance");
374 
375         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
376         (bool success, ) = recipient.call{ value: amount }("");
377         require(success, "Address: unable to send value, recipient may have reverted");
378     }
379 
380     /**
381     * @dev Performs a Solidity function call using a low level `call`. A
382     * plain`call` is an unsafe replacement for a function call: use this
383     * function instead.
384     *
385     * If `target` reverts with a revert reason, it is bubbled up by this
386     * function (like regular Solidity function calls).
387     *
388     * Returns the raw returned data. To convert to the expected return value,
389     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
390     *
391     * Requirements:
392     *
393     * - `target` must be a contract.
394     * - calling `target` with `data` must not revert.
395     *
396     * _Available since v3.1._
397     */
398     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
399       return functionCall(target, data, "Address: low-level call failed");
400     }
401 
402     /**
403     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
404     * `errorMessage` as a fallback revert reason when `target` reverts.
405     *
406     * _Available since v3.1._
407     */
408     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, 0, errorMessage);
410     }
411 
412     /**
413     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414     * but also transferring `value` wei to `target`.
415     *
416     * Requirements:
417     *
418     * - the calling contract must have an ETH balance of at least `value`.
419     * - the called Solidity function must be `payable`.
420     *
421     * _Available since v3.1._
422     */
423     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429     * with `errorMessage` as a fallback revert reason when `target` reverts.
430     *
431     * _Available since v3.1._
432     */
433     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         // solhint-disable-next-line avoid-low-level-calls
438         (bool success, bytes memory returndata) = target.call{ value: value }(data);
439         return _verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444     * but performing a static call.
445     *
446     * _Available since v3.3._
447     */
448     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
449         return functionStaticCall(target, data, "Address: low-level static call failed");
450     }
451 
452     /**
453     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454     * but performing a static call.
455     *
456     * _Available since v3.3._
457     */
458     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
459         require(isContract(target), "Address: static call to non-contract");
460 
461         // solhint-disable-next-line avoid-low-level-calls
462         (bool success, bytes memory returndata) = target.staticcall(data);
463         return _verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468     * but performing a delegate call.
469     *
470     * _Available since v3.4._
471     */
472     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
474     }
475 
476     /**
477     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478     * but performing a delegate call.
479     *
480     * _Available since v3.4._
481     */
482     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
483         require(isContract(target), "Address: delegate call to non-contract");
484 
485         // solhint-disable-next-line avoid-low-level-calls
486         (bool success, bytes memory returndata) = target.delegatecall(data);
487         return _verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497 
498                 // solhint-disable-next-line no-inline-assembly
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 /**
511  * @dev Contract module which provides a basic access control mechanism, where
512  * there is an account (an owner) that can be granted exclusive access to
513  * specific functions.
514  *
515  * By default, the owner account will be the one that deploys the contract. This
516  * can later be changed with {transferOwnership}.
517  *
518  * This module is used through inheritance. It will make available the modifier
519  * `onlyOwner`, which can be applied to your functions to restrict their use to
520  * the owner.
521  */
522 abstract contract Ownable is Context {
523     address private _owner;
524 
525     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
526 
527     /**
528     * @dev Initializes the contract setting the deployer as the initial owner.
529     */
530     constructor () {
531         _owner = _msgSender();
532         emit OwnershipTransferred(address(0), _owner);
533     }
534 
535     /**
536     * @dev Returns the address of the current owner.
537     */
538     function owner() public view virtual returns (address) {
539         return _owner;
540     }
541 
542     /**
543     * @dev Throws if called by any account other than the owner.
544     */
545     modifier onlyOwner() {
546         require(owner() == _msgSender(), "Ownable: caller is not the owner");
547         _;
548     }
549 
550     /**
551     * @dev Leaves the contract without owner. It will not be possible to call
552     * `onlyOwner` functions anymore. Can only be called by the current owner.
553     *
554     * NOTE: Renouncing ownership will leave the contract without an owner,
555     * thereby removing any functionality that is only available to the owner.
556     */
557     function renounceOwnership() public virtual onlyOwner {
558         emit OwnershipTransferred(_owner, address(0));
559         _owner = address(0);
560     }
561 
562     /**
563     * @dev Transfers ownership of the contract to a new account (`newOwner`).
564     * Can only be called by the current owner.
565     */
566     function transferOwnership(address newOwner) public virtual onlyOwner {
567         require(newOwner != address(0), "Ownable: new owner is the zero address");
568         emit OwnershipTransferred(_owner, newOwner);
569         _owner = newOwner;
570     }
571 }
572 
573 interface IUniswapV2Factory {
574     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
575 
576     function feeTo() external view returns (address);
577     function feeToSetter() external view returns (address);
578 
579     function getPair(address tokenA, address tokenB) external view returns (address pair);
580     function allPairs(uint) external view returns (address pair);
581     function allPairsLength() external view returns (uint);
582 
583     function createPair(address tokenA, address tokenB) external returns (address pair);
584 
585     function setFeeTo(address) external;
586     function setFeeToSetter(address) external;
587 }
588 
589 interface IUniswapV2Pair {
590     event Approval(address indexed owner, address indexed spender, uint value);
591     event Transfer(address indexed from, address indexed to, uint value);
592 
593     function name() external pure returns (string memory);
594     function symbol() external pure returns (string memory);
595     function decimals() external pure returns (uint8);
596     function totalSupply() external view returns (uint);
597     function balanceOf(address owner) external view returns (uint);
598     function allowance(address owner, address spender) external view returns (uint);
599 
600     function approve(address spender, uint value) external returns (bool);
601     function transfer(address to, uint value) external returns (bool);
602     function transferFrom(address from, address to, uint value) external returns (bool);
603 
604     function DOMAIN_SEPARATOR() external view returns (bytes32);
605     function PERMIT_TYPEHASH() external pure returns (bytes32);
606     function nonces(address owner) external view returns (uint);
607 
608     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
609 
610     event Mint(address indexed sender, uint amount0, uint amount1);
611     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
612     event Swap(
613         address indexed sender,
614         uint amount0In,
615         uint amount1In,
616         uint amount0Out,
617         uint amount1Out,
618         address indexed to
619     );
620     event Sync(uint112 reserve0, uint112 reserve1);
621 
622     function MINIMUM_LIQUIDITY() external pure returns (uint);
623     function factory() external view returns (address);
624     function token0() external view returns (address);
625     function token1() external view returns (address);
626     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
627     function price0CumulativeLast() external view returns (uint);
628     function price1CumulativeLast() external view returns (uint);
629     function kLast() external view returns (uint);
630 
631     function mint(address to) external returns (uint liquidity);
632     function burn(address to) external returns (uint amount0, uint amount1);
633     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
634     function skim(address to) external;
635     function sync() external;
636 
637     function initialize(address, address) external;
638 }
639 
640 interface IUniswapV2Router01 {
641     function factory() external pure returns (address);
642     function WETH() external pure returns (address);
643 
644     function addLiquidity(
645         address tokenA,
646         address tokenB,
647         uint amountADesired,
648         uint amountBDesired,
649         uint amountAMin,
650         uint amountBMin,
651         address to,
652         uint deadline
653     ) external returns (uint amountA, uint amountB, uint liquidity);
654     function addLiquidityETH(
655         address token,
656         uint amountTokenDesired,
657         uint amountTokenMin,
658         uint amountETHMin,
659         address to,
660         uint deadline
661     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
662     function removeLiquidity(
663         address tokenA,
664         address tokenB,
665         uint liquidity,
666         uint amountAMin,
667         uint amountBMin,
668         address to,
669         uint deadline
670     ) external returns (uint amountA, uint amountB);
671     function removeLiquidityETH(
672         address token,
673         uint liquidity,
674         uint amountTokenMin,
675         uint amountETHMin,
676         address to,
677         uint deadline
678     ) external returns (uint amountToken, uint amountETH);
679     function removeLiquidityWithPermit(
680         address tokenA,
681         address tokenB,
682         uint liquidity,
683         uint amountAMin,
684         uint amountBMin,
685         address to,
686         uint deadline,
687         bool approveMax, uint8 v, bytes32 r, bytes32 s
688     ) external returns (uint amountA, uint amountB);
689     function removeLiquidityETHWithPermit(
690         address token,
691         uint liquidity,
692         uint amountTokenMin,
693         uint amountETHMin,
694         address to,
695         uint deadline,
696         bool approveMax, uint8 v, bytes32 r, bytes32 s
697     ) external returns (uint amountToken, uint amountETH);
698     function swapExactTokensForTokens(
699         uint amountIn,
700         uint amountOutMin,
701         address[] calldata path,
702         address to,
703         uint deadline
704     ) external returns (uint[] memory amounts);
705     function swapTokensForExactTokens(
706         uint amountOut,
707         uint amountInMax,
708         address[] calldata path,
709         address to,
710         uint deadline
711     ) external returns (uint[] memory amounts);
712     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
713         external
714         payable
715         returns (uint[] memory amounts);
716     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
717         external
718         returns (uint[] memory amounts);
719     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
720         external
721         returns (uint[] memory amounts);
722     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
723         external
724         payable
725         returns (uint[] memory amounts);
726 
727     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
728     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
729     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
730     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
731     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
732 }
733 
734 interface IUniswapV2Router02 is IUniswapV2Router01 {
735     function removeLiquidityETHSupportingFeeOnTransferTokens(
736         address token,
737         uint liquidity,
738         uint amountTokenMin,
739         uint amountETHMin,
740         address to,
741         uint deadline
742     ) external returns (uint amountETH);
743     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
744         address token,
745         uint liquidity,
746         uint amountTokenMin,
747         uint amountETHMin,
748         address to,
749         uint deadline,
750         bool approveMax, uint8 v, bytes32 r, bytes32 s
751     ) external returns (uint amountETH);
752 
753     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
754         uint amountIn,
755         uint amountOutMin,
756         address[] calldata path,
757         address to,
758         uint deadline
759     ) external;
760     function swapExactETHForTokensSupportingFeeOnTransferTokens(
761         uint amountOutMin,
762         address[] calldata path,
763         address to,
764         uint deadline
765     ) external payable;
766     function swapExactTokensForETHSupportingFeeOnTransferTokens(
767         uint amountIn,
768         uint amountOutMin,
769         address[] calldata path,
770         address to,
771         uint deadline
772     ) external;
773 }
774 
775 // contract implementation
776 contract BabyPenguins is Context, IERC20, Ownable {
777     using SafeMath for uint256;
778     using Address for address;
779 
780     uint8 private _decimals = 9;
781 
782     // 
783     string private _name = "BabyPenguins";                                         // name
784     string private _symbol = "bPENG";                                              // symbol
785     uint256 private _tTotal = 1000 * 10**9 * 10**uint256(_decimals);            // total supply
786 
787     // % to holders
788     uint256 public defaultTaxFee = 2;
789     uint256 public _taxFee = defaultTaxFee;
790     uint256 private _previousTaxFee = _taxFee;
791 
792     // % to swap & send to marketing wallet
793     uint256 public defaultMarketingFee = 4;
794     uint256 public _marketingFee = defaultMarketingFee;
795     uint256 private _previousMarketingFee = _marketingFee;
796 
797     uint256 public _marketingFee4Sellers = 8;
798 
799     bool public feesOnSellersAndBuyers = true;
800 
801     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
802     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
803     address payable public marketingWallet = payable(0xC5Ab924F4738463A358F2B577852F1e85409590D);   // Wallet
804 
805     //
806 
807     mapping (address => uint256) private _rOwned;
808     mapping (address => uint256) private _tOwned;
809     mapping (address => mapping (address => uint256)) private _allowances;
810 
811     mapping (address => bool) private _isExcludedFromFee;
812 
813     mapping (address => bool) private _isExcluded;
814 
815     address[] private _excluded;
816     uint256 private constant MAX = ~uint256(0);
817 
818     uint256 private _tFeeTotal;
819     uint256 private _rTotal = (MAX - (MAX % _tTotal));
820 
821     IUniswapV2Router02 public immutable uniswapV2Router;
822     address public immutable uniswapV2Pair;
823 
824     bool inSwapAndSend;
825     bool public SwapAndSendEnabled = true;
826 
827     event SwapAndSendEnabledUpdated(bool enabled);
828 
829     modifier lockTheSwap {
830         inSwapAndSend = true;
831         _;
832         inSwapAndSend = false;
833     }
834 
835     constructor () {
836         _rOwned[_msgSender()] = _rTotal;
837 
838         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
839          // Create a uniswap pair for this new token
840         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
841             .createPair(address(this), _uniswapV2Router.WETH());
842 
843         // set the rest of the contract variables
844         uniswapV2Router = _uniswapV2Router;
845 
846         //exclude owner and this contract from fee
847         _isExcludedFromFee[owner()] = true;
848         _isExcludedFromFee[address(this)] = true;
849 
850         emit Transfer(address(0), _msgSender(), _tTotal);
851     }
852 
853     function name() public view returns (string memory) {
854         return _name;
855     }
856 
857     function symbol() public view returns (string memory) {
858         return _symbol;
859     }
860 
861     function decimals() public view returns (uint8) {
862         return _decimals;
863     }
864 
865     function totalSupply() public view override returns (uint256) {
866         return _tTotal;
867     }
868 
869     function balanceOf(address account) public view override returns (uint256) {
870         if (_isExcluded[account]) return _tOwned[account];
871         return tokenFromReflection(_rOwned[account]);
872     }
873 
874     function transfer(address recipient, uint256 amount) public override returns (bool) {
875         _transfer(_msgSender(), recipient, amount);
876         return true;
877     }
878 
879     function allowance(address owner, address spender) public view override returns (uint256) {
880         return _allowances[owner][spender];
881     }
882 
883     function approve(address spender, uint256 amount) public override returns (bool) {
884         _approve(_msgSender(), spender, amount);
885         return true;
886     }
887 
888     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
889         _transfer(sender, recipient, amount);
890         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
891         return true;
892     }
893 
894     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
895         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
896         return true;
897     }
898 
899     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
900         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
901         return true;
902     }
903 
904     function isExcludedFromReward(address account) public view returns (bool) {
905         return _isExcluded[account];
906     }
907 
908     function totalFees() public view returns (uint256) {
909         return _tFeeTotal;
910     }
911 
912     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
913         require(tAmount <= _tTotal, "Amount must be less than supply");
914         if (!deductTransferFee) {
915             (uint256 rAmount,,,,,) = _getValues(tAmount);
916             return rAmount;
917         } else {
918             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
919             return rTransferAmount;
920         }
921     }
922 
923     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
924         require(rAmount <= _rTotal, "Amount must be less than total reflections");
925         uint256 currentRate =  _getRate();
926         return rAmount.div(currentRate);
927     }
928 
929     function excludeFromReward(address account) public onlyOwner() {
930         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
931         require(!_isExcluded[account], "Account is already excluded");
932         if(_rOwned[account] > 0) {
933             _tOwned[account] = tokenFromReflection(_rOwned[account]);
934         }
935         _isExcluded[account] = true;
936         _excluded.push(account);
937     }
938 
939     function includeInReward(address account) external onlyOwner() {
940         require(_isExcluded[account], "Account is already excluded");
941         for (uint256 i = 0; i < _excluded.length; i++) {
942             if (_excluded[i] == account) {
943                 _excluded[i] = _excluded[_excluded.length - 1];
944                 _tOwned[account] = 0;
945                 _isExcluded[account] = false;
946                 _excluded.pop();
947                 break;
948             }
949         }
950     }
951 
952     function excludeFromFee(address account) public onlyOwner() {
953         _isExcludedFromFee[account] = true;
954     }
955 
956     function includeInFee(address account) public onlyOwner() {
957         _isExcludedFromFee[account] = false;
958     }
959 
960     function removeAllFee() private {
961         if(_taxFee == 0 && _marketingFee == 0) return;
962 
963         _previousTaxFee = _taxFee;
964         _previousMarketingFee = _marketingFee;
965 
966         _taxFee = 0;
967         _marketingFee = 0;
968     }
969 
970     function restoreAllFee() private {
971         _taxFee = _previousTaxFee;
972         _marketingFee = _previousMarketingFee;
973     }
974 
975     //to recieve ETH
976     receive() external payable {}
977 
978     function _reflectFee(uint256 rFee, uint256 tFee) private {
979         _rTotal = _rTotal.sub(rFee);
980         _tFeeTotal = _tFeeTotal.add(tFee);
981     }
982 
983     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
984         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
985         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
986         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
987     }
988 
989     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
990         uint256 tFee = calculateTaxFee(tAmount);
991         uint256 tMarketing = calculateMarketingFee(tAmount);
992         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
993         return (tTransferAmount, tFee, tMarketing);
994     }
995 
996     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
997         uint256 rAmount = tAmount.mul(currentRate);
998         uint256 rFee = tFee.mul(currentRate);
999         uint256 rMarketing = tMarketing.mul(currentRate);
1000         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
1001         return (rAmount, rTransferAmount, rFee);
1002     }
1003 
1004     function _getRate() private view returns(uint256) {
1005         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1006         return rSupply.div(tSupply);
1007     }
1008 
1009     function _getCurrentSupply() private view returns(uint256, uint256) {
1010         uint256 rSupply = _rTotal;
1011         uint256 tSupply = _tTotal;
1012         for (uint256 i = 0; i < _excluded.length; i++) {
1013             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1014             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1015             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1016         }
1017         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1018         return (rSupply, tSupply);
1019     }
1020 
1021     function _takeMarketing(uint256 tMarketing) private {
1022         uint256 currentRate =  _getRate();
1023         uint256 rMarketing = tMarketing.mul(currentRate);
1024         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1025         if(_isExcluded[address(this)])
1026             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1027     }
1028 
1029     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1030         return _amount.mul(_taxFee).div(
1031             10**2
1032         );
1033     }
1034 
1035     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1036         return _amount.mul(_marketingFee).div(
1037             10**2
1038         );
1039     }
1040 
1041     function isExcludedFromFee(address account) public view returns(bool) {
1042         return _isExcludedFromFee[account];
1043     }
1044 
1045     function _approve(address owner, address spender, uint256 amount) private {
1046         require(owner != address(0), "ERC20: approve from the zero address");
1047         require(spender != address(0), "ERC20: approve to the zero address");
1048 
1049         _allowances[owner][spender] = amount;
1050         emit Approval(owner, spender, amount);
1051     }
1052 
1053     function _transfer(
1054         address from,
1055         address to,
1056         uint256 amount
1057     ) private {
1058         require(from != address(0), "ERC20: transfer from the zero address");
1059         require(to != address(0), "ERC20: transfer to the zero address");
1060         require(amount > 0, "Transfer amount must be greater than zero");
1061 
1062         if(from != owner() && to != owner())
1063             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1064 
1065         // is the token balance of this contract address over the min number of
1066         // tokens that we need to initiate a swap + send lock?
1067         // also, don't get caught in a circular sending event.
1068         // also, don't swap & liquify if sender is uniswap pair.
1069         uint256 contractTokenBalance = balanceOf(address(this));
1070         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1071 
1072         if(contractTokenBalance >= _maxTxAmount)
1073         {
1074             contractTokenBalance = _maxTxAmount;
1075         }
1076 
1077         if (
1078             overMinTokenBalance &&
1079             !inSwapAndSend &&
1080             from != uniswapV2Pair &&
1081             SwapAndSendEnabled
1082         ) {
1083             SwapAndSend(contractTokenBalance);
1084         }
1085 
1086         if(feesOnSellersAndBuyers) {
1087             setFees(to);
1088         }
1089 
1090         //indicates if fee should be deducted from transfer
1091         bool takeFee = true;
1092 
1093         //if any account belongs to _isExcludedFromFee account then remove the fee
1094         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1095             takeFee = false;
1096         }
1097 
1098         _tokenTransfer(from,to,amount,takeFee);
1099     }
1100 
1101     function setFees(address recipient) private {
1102         _taxFee = defaultTaxFee;
1103         _marketingFee = defaultMarketingFee;
1104         if (recipient == uniswapV2Pair) { // sell
1105             _marketingFee = _marketingFee4Sellers;
1106         }
1107     }
1108 
1109     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1110         // generate the uniswap pair path of token -> weth
1111         address[] memory path = new address[](2);
1112         path[0] = address(this);
1113         path[1] = uniswapV2Router.WETH();
1114 
1115         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1116 
1117         // make the swap
1118         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1119             contractTokenBalance,
1120             0, // accept any amount of ETH
1121             path,
1122             address(this),
1123             block.timestamp
1124         );
1125 
1126         uint256 contractETHBalance = address(this).balance;
1127         if(contractETHBalance > 0) {
1128             marketingWallet.transfer(contractETHBalance);
1129         }
1130     }
1131 
1132     //this method is responsible for taking all fee, if takeFee is true
1133     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1134         if(!takeFee)
1135             removeAllFee();
1136 
1137         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1138             _transferFromExcluded(sender, recipient, amount);
1139         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1140             _transferToExcluded(sender, recipient, amount);
1141         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1142             _transferStandard(sender, recipient, amount);
1143         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1144             _transferBothExcluded(sender, recipient, amount);
1145         } else {
1146             _transferStandard(sender, recipient, amount);
1147         }
1148 
1149         if(!takeFee)
1150             restoreAllFee();
1151     }
1152 
1153     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1154         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1155         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1156         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1157         _takeMarketing(tMarketing);
1158         _reflectFee(rFee, tFee);
1159         emit Transfer(sender, recipient, tTransferAmount);
1160     }
1161 
1162     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1163         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1164         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1165         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1166         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1167         _takeMarketing(tMarketing);
1168         _reflectFee(rFee, tFee);
1169         emit Transfer(sender, recipient, tTransferAmount);
1170     }
1171 
1172     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1173         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1174         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1175         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1176         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1177         _takeMarketing(tMarketing);
1178         _reflectFee(rFee, tFee);
1179         emit Transfer(sender, recipient, tTransferAmount);
1180     }
1181 
1182     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1183         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1184         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1185         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1186         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1187         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1188         _takeMarketing(tMarketing);
1189         _reflectFee(rFee, tFee);
1190         emit Transfer(sender, recipient, tTransferAmount);
1191     }
1192 
1193     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1194         defaultMarketingFee = marketingFee;
1195     }
1196 
1197     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1198         _marketingFee4Sellers = marketingFee4Sellers;
1199     }
1200 
1201     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1202         feesOnSellersAndBuyers = _enabled;
1203     }
1204 
1205     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1206         SwapAndSendEnabled = _enabled;
1207         emit SwapAndSendEnabledUpdated(_enabled);
1208     }
1209 
1210     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1211         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1212     }
1213 
1214     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1215         marketingWallet = wallet;
1216     }
1217 
1218     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1219         _maxTxAmount = maxTxAmount;
1220     }
1221 }