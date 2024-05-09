1 //https://t.me/religiondao
2 
3 
4 pragma solidity ^0.8.3;
5 // SPDX-License-Identifier: Unlicensed
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12     * @dev Returns the amount of tokens in existence.
13     */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17     * @dev Returns the amount of tokens owned by `account`.
18     */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22     * @dev Moves `amount` tokens from the caller's account to `recipient`.
23     *
24     * Returns a boolean value indicating whether the operation succeeded.
25     *
26     * Emits a {Transfer} event.
27     */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31     * @dev Returns the remaining number of tokens that `spender` will be
32     * allowed to spend on behalf of `owner` through {transferFrom}. This is
33     * zero by default.
34     *
35     * This value changes when {approve} or {transferFrom} are called.
36     */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41     *
42     * Returns a boolean value indicating whether the operation succeeded.
43     *
44     * IMPORTANT: Beware that changing an allowance with this method brings the risk
45     * that someone may use both the old and the new allowance by unfortunate
46     * transaction ordering. One possible solution to mitigate this race
47     * condition is to first reduce the spender's allowance to 0 and set the
48     * desired value afterwards:
49     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50     *
51     * Emits an {Approval} event.
52     */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56     * @dev Moves `amount` tokens from `sender` to `recipient` using the
57     * allowance mechanism. `amount` is then deducted from the caller's
58     * allowance.
59     *
60     * Returns a boolean value indicating whether the operation succeeded.
61     *
62     * Emits a {Transfer} event.
63     */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67     * @dev Emitted when `value` tokens are moved from one account (`from`) to
68     * another (`to`).
69     *
70     * Note that `value` may be zero.
71     */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76     * a call to {approve}. `value` is the new allowance.
77     */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // CAUTION
82 // This version of SafeMath should only be used with Solidity 0.8 or later,
83 // because it relies on the compiler's built in overflow checks.
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations.
87  *
88  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
89  * now has built in overflow checking.
90  */
91 library SafeMath {
92     /**
93     * @dev Returns the addition of two unsigned integers, with an overflow flag.
94     *
95     * _Available since v3.4._
96     */
97     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
98         unchecked {
99             uint256 c = a + b;
100             if (c < a) return (false, 0);
101             return (true, c);
102         }
103     }
104 
105     /**
106     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
107     *
108     * _Available since v3.4._
109     */
110     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             if (b > a) return (false, 0);
113             return (true, a - b);
114         }
115     }
116 
117     /**
118     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
119     *
120     * _Available since v3.4._
121     */
122     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125             // benefit is lost if 'b' is also tested.
126             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
127             if (a == 0) return (true, 0);
128             uint256 c = a * b;
129             if (c / a != b) return (false, 0);
130             return (true, c);
131         }
132     }
133 
134     /**
135     * @dev Returns the division of two unsigned integers, with a division by zero flag.
136     *
137     * _Available since v3.4._
138     */
139     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         unchecked {
141             if (b == 0) return (false, 0);
142             return (true, a / b);
143         }
144     }
145 
146     /**
147     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
148     *
149     * _Available since v3.4._
150     */
151     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             if (b == 0) return (false, 0);
154             return (true, a % b);
155         }
156     }
157 
158     /**
159     * @dev Returns the addition of two unsigned integers, reverting on
160     * overflow.
161     *
162     * Counterpart to Solidity's `+` operator.
163     *
164     * Requirements:
165     *
166     * - Addition cannot overflow.
167     */
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         return a + b;
170     }
171 
172     /**
173     * @dev Returns the subtraction of two unsigned integers, reverting on
174     * overflow (when the result is negative).
175     *
176     * Counterpart to Solidity's `-` operator.
177     *
178     * Requirements:
179     *
180     * - Subtraction cannot overflow.
181     */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a - b;
184     }
185 
186     /**
187     * @dev Returns the multiplication of two unsigned integers, reverting on
188     * overflow.
189     *
190     * Counterpart to Solidity's `*` operator.
191     *
192     * Requirements:
193     *
194     * - Multiplication cannot overflow.
195     */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a * b;
198     }
199 
200     /**
201     * @dev Returns the integer division of two unsigned integers, reverting on
202     * division by zero. The result is rounded towards zero.
203     *
204     * Counterpart to Solidity's `/` operator.
205     *
206     * Requirements:
207     *
208     * - The divisor cannot be zero.
209     */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a / b;
212     }
213 
214     /**
215     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216     * reverting when dividing by zero.
217     *
218     * Counterpart to Solidity's `%` operator. This function uses a `revert`
219     * opcode (which leaves remaining gas untouched) while Solidity uses an
220     * invalid opcode to revert (consuming all remaining gas).
221     *
222     * Requirements:
223     *
224     * - The divisor cannot be zero.
225     */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a % b;
228     }
229 
230     /**
231     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
232     * overflow (when the result is negative).
233     *
234     * CAUTION: This function is deprecated because it requires allocating memory for the error
235     * message unnecessarily. For custom revert reasons use {trySub}.
236     *
237     * Counterpart to Solidity's `-` operator.
238     *
239     * Requirements:
240     *
241     * - Subtraction cannot overflow.
242     */
243     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         unchecked {
245             require(b <= a, errorMessage);
246             return a - b;
247         }
248     }
249 
250     /**
251     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
252     * division by zero. The result is rounded towards zero.
253     *
254     * Counterpart to Solidity's `%` operator. This function uses a `revert`
255     * opcode (which leaves remaining gas untouched) while Solidity uses an
256     * invalid opcode to revert (consuming all remaining gas).
257     *
258     * Counterpart to Solidity's `/` operator. Note: this function uses a
259     * `revert` opcode (which leaves remaining gas untouched) while Solidity
260     * uses an invalid opcode to revert (consuming all remaining gas).
261     *
262     * Requirements:
263     *
264     * - The divisor cannot be zero.
265     */
266     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         unchecked {
268             require(b > 0, errorMessage);
269             return a / b;
270         }
271     }
272 
273     /**
274     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275     * reverting with custom message when dividing by zero.
276     *
277     * CAUTION: This function is deprecated because it requires allocating memory for the error
278     * message unnecessarily. For custom revert reasons use {tryMod}.
279     *
280     * Counterpart to Solidity's `%` operator. This function uses a `revert`
281     * opcode (which leaves remaining gas untouched) while Solidity uses an
282     * invalid opcode to revert (consuming all remaining gas).
283     *
284     * Requirements:
285     *
286     * - The divisor cannot be zero.
287     */
288     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         unchecked {
290             require(b > 0, errorMessage);
291             return a % b;
292         }
293     }
294 }
295 
296 /*
297  * @dev Provides information about the current execution context, including the
298  * sender of the transaction and its data. While these are generally available
299  * via msg.sender and msg.data, they should not be accessed in such a direct
300  * manner, since when dealing with meta-transactions the account sending and
301  * paying for execution may not be the actual sender (as far as an application
302  * is concerned).
303  *
304  * This contract is only required for intermediate, library-like contracts.
305  */
306 abstract contract Context {
307     function _msgSender() internal view virtual returns (address) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view virtual returns (bytes calldata) {
312         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
313         return msg.data;
314     }
315 }
316 
317 /**
318  * @dev Collection of functions related to the address type
319  */
320 library Address {
321     /**
322     * @dev Returns true if `account` is a contract.
323     *
324     * [IMPORTANT]
325     * ====
326     * It is unsafe to assume that an address for which this function returns
327     * false is an externally-owned account (EOA) and not a contract.
328     *
329     * Among others, `isContract` will return false for the following
330     * types of addresses:
331     *
332     *  - an externally-owned account
333     *  - a contract in construction
334     *  - an address where a contract will be created
335     *  - an address where a contract lived, but was destroyed
336     * ====
337     */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize, which returns 0 for contracts in
340         // construction, since the code is only stored at the end of the
341         // constructor execution.
342 
343         uint256 size;
344         // solhint-disable-next-line no-inline-assembly
345         assembly { size := extcodesize(account) }
346         return size > 0;
347     }
348 
349     /**
350     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351     * `recipient`, forwarding all available gas and reverting on errors.
352     *
353     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354     * of certain opcodes, possibly making contracts go over the 2300 gas limit
355     * imposed by `transfer`, making them unable to receive funds via
356     * `transfer`. {sendValue} removes this limitation.
357     *
358     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359     *
360     * IMPORTANT: because control is transferred to `recipient`, care must be
361     * taken to not create reentrancy vulnerabilities. Consider using
362     * {ReentrancyGuard} or the
363     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364     */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
369         (bool success, ) = recipient.call{ value: amount }("");
370         require(success, "Address: unable to send value, recipient may have reverted");
371     }
372 
373     /**
374     * @dev Performs a Solidity function call using a low level `call`. A
375     * plain`call` is an unsafe replacement for a function call: use this
376     * function instead.
377     *
378     * If `target` reverts with a revert reason, it is bubbled up by this
379     * function (like regular Solidity function calls).
380     *
381     * Returns the raw returned data. To convert to the expected return value,
382     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
383     *
384     * Requirements:
385     *
386     * - `target` must be a contract.
387     * - calling `target` with `data` must not revert.
388     *
389     * _Available since v3.1._
390     */
391     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
392       return functionCall(target, data, "Address: low-level call failed");
393     }
394 
395     /**
396     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
397     * `errorMessage` as a fallback revert reason when `target` reverts.
398     *
399     * _Available since v3.1._
400     */
401     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, 0, errorMessage);
403     }
404 
405     /**
406     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407     * but also transferring `value` wei to `target`.
408     *
409     * Requirements:
410     *
411     * - the calling contract must have an ETH balance of at least `value`.
412     * - the called Solidity function must be `payable`.
413     *
414     * _Available since v3.1._
415     */
416     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
418     }
419 
420     /**
421     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
422     * with `errorMessage` as a fallback revert reason when `target` reverts.
423     *
424     * _Available since v3.1._
425     */
426     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
427         require(address(this).balance >= value, "Address: insufficient balance for call");
428         require(isContract(target), "Address: call to non-contract");
429 
430         // solhint-disable-next-line avoid-low-level-calls
431         (bool success, bytes memory returndata) = target.call{ value: value }(data);
432         return _verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437     * but performing a static call.
438     *
439     * _Available since v3.3._
440     */
441     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
442         return functionStaticCall(target, data, "Address: low-level static call failed");
443     }
444 
445     /**
446     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447     * but performing a static call.
448     *
449     * _Available since v3.3._
450     */
451     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
452         require(isContract(target), "Address: static call to non-contract");
453 
454         // solhint-disable-next-line avoid-low-level-calls
455         (bool success, bytes memory returndata) = target.staticcall(data);
456         return _verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461     * but performing a delegate call.
462     *
463     * _Available since v3.4._
464     */
465     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
466         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
467     }
468 
469     /**
470     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
471     * but performing a delegate call.
472     *
473     * _Available since v3.4._
474     */
475     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
476         require(isContract(target), "Address: delegate call to non-contract");
477 
478         // solhint-disable-next-line avoid-low-level-calls
479         (bool success, bytes memory returndata) = target.delegatecall(data);
480         return _verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
484         if (success) {
485             return returndata;
486         } else {
487             // Look for revert reason and bubble it up if present
488             if (returndata.length > 0) {
489                 // The easiest way to bubble the revert reason is using memory via assembly
490 
491                 // solhint-disable-next-line no-inline-assembly
492                 assembly {
493                     let returndata_size := mload(returndata)
494                     revert(add(32, returndata), returndata_size)
495                 }
496             } else {
497                 revert(errorMessage);
498             }
499         }
500     }
501 }
502 
503 /**
504  * @dev Contract module which provides a basic access control mechanism, where
505  * there is an account (an owner) that can be granted exclusive access to
506  * specific functions.
507  *
508  * By default, the owner account will be the one that deploys the contract. This
509  * can later be changed with {transferOwnership}.
510  *
511  * This module is used through inheritance. It will make available the modifier
512  * `onlyOwner`, which can be applied to your functions to restrict their use to
513  * the owner.
514  */
515 abstract contract Ownable is Context {
516     address private _owner;
517 
518     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
519 
520     /**
521     * @dev Initializes the contract setting the deployer as the initial owner.
522     */
523     constructor () {
524         _owner = _msgSender();
525         emit OwnershipTransferred(address(0), _owner);
526     }
527 
528     /**
529     * @dev Returns the address of the current owner.
530     */
531     function owner() public view virtual returns (address) {
532         return _owner;
533     }
534 
535     /**
536     * @dev Throws if called by any account other than the owner.
537     */
538     modifier onlyOwner() {
539         require(owner() == _msgSender(), "Ownable: caller is not the owner");
540         _;
541     }
542 
543     /**
544     * @dev Leaves the contract without owner. It will not be possible to call
545     * `onlyOwner` functions anymore. Can only be called by the current owner.
546     *
547     * NOTE: Renouncing ownership will leave the contract without an owner,
548     * thereby removing any functionality that is only available to the owner.
549     */
550     function renounceOwnership() public virtual onlyOwner {
551         emit OwnershipTransferred(_owner, address(0));
552         _owner = address(0);
553     }
554 
555     /**
556     * @dev Transfers ownership of the contract to a new account (`newOwner`).
557     * Can only be called by the current owner.
558     */
559     function transferOwnership(address newOwner) public virtual onlyOwner {
560         require(newOwner != address(0), "Ownable: new owner is the zero address");
561         emit OwnershipTransferred(_owner, newOwner);
562         _owner = newOwner;
563     }
564 }
565 
566 interface IUniswapV2Factory {
567     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
568 
569     function feeTo() external view returns (address);
570     function feeToSetter() external view returns (address);
571 
572     function getPair(address tokenA, address tokenB) external view returns (address pair);
573     function allPairs(uint) external view returns (address pair);
574     function allPairsLength() external view returns (uint);
575 
576     function createPair(address tokenA, address tokenB) external returns (address pair);
577 
578     function setFeeTo(address) external;
579     function setFeeToSetter(address) external;
580 }
581 
582 interface IUniswapV2Pair {
583     event Approval(address indexed owner, address indexed spender, uint value);
584     event Transfer(address indexed from, address indexed to, uint value);
585 
586     function name() external pure returns (string memory);
587     function symbol() external pure returns (string memory);
588     function decimals() external pure returns (uint8);
589     function totalSupply() external view returns (uint);
590     function balanceOf(address owner) external view returns (uint);
591     function allowance(address owner, address spender) external view returns (uint);
592 
593     function approve(address spender, uint value) external returns (bool);
594     function transfer(address to, uint value) external returns (bool);
595     function transferFrom(address from, address to, uint value) external returns (bool);
596 
597     function DOMAIN_SEPARATOR() external view returns (bytes32);
598     function PERMIT_TYPEHASH() external pure returns (bytes32);
599     function nonces(address owner) external view returns (uint);
600 
601     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
602 
603     event Mint(address indexed sender, uint amount0, uint amount1);
604     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
605     event Swap(
606         address indexed sender,
607         uint amount0In,
608         uint amount1In,
609         uint amount0Out,
610         uint amount1Out,
611         address indexed to
612     );
613     event Sync(uint112 reserve0, uint112 reserve1);
614 
615     function MINIMUM_LIQUIDITY() external pure returns (uint);
616     function factory() external view returns (address);
617     function token0() external view returns (address);
618     function token1() external view returns (address);
619     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
620     function price0CumulativeLast() external view returns (uint);
621     function price1CumulativeLast() external view returns (uint);
622     function kLast() external view returns (uint);
623 
624     function mint(address to) external returns (uint liquidity);
625     function burn(address to) external returns (uint amount0, uint amount1);
626     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
627     function skim(address to) external;
628     function sync() external;
629 
630     function initialize(address, address) external;
631 }
632 
633 interface IUniswapV2Router01 {
634     function factory() external pure returns (address);
635     function WETH() external pure returns (address);
636 
637     function addLiquidity(
638         address tokenA,
639         address tokenB,
640         uint amountADesired,
641         uint amountBDesired,
642         uint amountAMin,
643         uint amountBMin,
644         address to,
645         uint deadline
646     ) external returns (uint amountA, uint amountB, uint liquidity);
647     function addLiquidityETH(
648         address token,
649         uint amountTokenDesired,
650         uint amountTokenMin,
651         uint amountETHMin,
652         address to,
653         uint deadline
654     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
655     function removeLiquidity(
656         address tokenA,
657         address tokenB,
658         uint liquidity,
659         uint amountAMin,
660         uint amountBMin,
661         address to,
662         uint deadline
663     ) external returns (uint amountA, uint amountB);
664     function removeLiquidityETH(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline
671     ) external returns (uint amountToken, uint amountETH);
672     function removeLiquidityWithPermit(
673         address tokenA,
674         address tokenB,
675         uint liquidity,
676         uint amountAMin,
677         uint amountBMin,
678         address to,
679         uint deadline,
680         bool approveMax, uint8 v, bytes32 r, bytes32 s
681     ) external returns (uint amountA, uint amountB);
682     function removeLiquidityETHWithPermit(
683         address token,
684         uint liquidity,
685         uint amountTokenMin,
686         uint amountETHMin,
687         address to,
688         uint deadline,
689         bool approveMax, uint8 v, bytes32 r, bytes32 s
690     ) external returns (uint amountToken, uint amountETH);
691     function swapExactTokensForTokens(
692         uint amountIn,
693         uint amountOutMin,
694         address[] calldata path,
695         address to,
696         uint deadline
697     ) external returns (uint[] memory amounts);
698     function swapTokensForExactTokens(
699         uint amountOut,
700         uint amountInMax,
701         address[] calldata path,
702         address to,
703         uint deadline
704     ) external returns (uint[] memory amounts);
705     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
706         external
707         payable
708         returns (uint[] memory amounts);
709     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
710         external
711         returns (uint[] memory amounts);
712     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
713         external
714         returns (uint[] memory amounts);
715     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
716         external
717         payable
718         returns (uint[] memory amounts);
719 
720     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
721     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
722     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
723     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
724     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
725 }
726 
727 interface IUniswapV2Router02 is IUniswapV2Router01 {
728     function removeLiquidityETHSupportingFeeOnTransferTokens(
729         address token,
730         uint liquidity,
731         uint amountTokenMin,
732         uint amountETHMin,
733         address to,
734         uint deadline
735     ) external returns (uint amountETH);
736     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
737         address token,
738         uint liquidity,
739         uint amountTokenMin,
740         uint amountETHMin,
741         address to,
742         uint deadline,
743         bool approveMax, uint8 v, bytes32 r, bytes32 s
744     ) external returns (uint amountETH);
745 
746     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
747         uint amountIn,
748         uint amountOutMin,
749         address[] calldata path,
750         address to,
751         uint deadline
752     ) external;
753     function swapExactETHForTokensSupportingFeeOnTransferTokens(
754         uint amountOutMin,
755         address[] calldata path,
756         address to,
757         uint deadline
758     ) external payable;
759     function swapExactTokensForETHSupportingFeeOnTransferTokens(
760         uint amountIn,
761         uint amountOutMin,
762         address[] calldata path,
763         address to,
764         uint deadline
765     ) external;
766 }
767 
768 // contract implementation
769 contract RELIGION is Context, IERC20, Ownable {
770     using SafeMath for uint256;
771     using Address for address;
772 
773     uint8 private _decimals = 9;
774 
775     
776     string private _name = "RELIGION DAO";
777     string private _symbol = "RELIGION";
778     uint256 private _tTotal = 10 * 10**9 * 10**uint256(_decimals);
779 
780    
781     uint256 public defaultTaxFee = 0;
782     uint256 public _taxFee = defaultTaxFee;
783     uint256 private _previousTaxFee = _taxFee;
784 
785     
786     uint256 public defaultMarketingFee = 7;
787     uint256 public _marketingFee = defaultMarketingFee;
788     uint256 private _previousMarketingFee = _marketingFee;
789 
790     uint256 public _marketingFee4Sellers = 7;
791 
792     bool public feesOnSellersAndBuyers = true;
793 
794     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
795     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
796     address payable public marketingWallet = payable(0x287203dED0f2C18f0E7c777b52C2C8240aB0Bf3e);
797 
798     
799 
800     mapping (address => uint256) private _rOwned;
801     mapping (address => uint256) private _tOwned;
802     mapping (address => mapping (address => uint256)) private _allowances;
803 
804     mapping (address => bool) private _isExcludedFromFee;
805 
806     mapping (address => bool) private _isExcluded;
807 
808     address[] private _excluded;
809     uint256 private constant MAX = ~uint256(0);
810 
811     uint256 private _tFeeTotal;
812     uint256 private _rTotal = (MAX - (MAX % _tTotal));
813 
814     IUniswapV2Router02 public immutable uniswapV2Router;
815     address public immutable uniswapV2Pair;
816 
817     bool inSwapAndSend;
818     bool public SwapAndSendEnabled = true;
819 
820     event SwapAndSendEnabledUpdated(bool enabled);
821 
822     modifier lockTheSwap {
823         inSwapAndSend = true;
824         _;
825         inSwapAndSend = false;
826     }
827 
828     constructor () {
829         _rOwned[_msgSender()] = _rTotal;
830 
831         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
832          // Create a uniswap pair for this new token
833         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
834             .createPair(address(this), _uniswapV2Router.WETH());
835 
836         // set the rest of the contract variables
837         uniswapV2Router = _uniswapV2Router;
838 
839         //exclude owner and this contract from fee
840         _isExcludedFromFee[owner()] = true;
841         _isExcludedFromFee[address(this)] = true;
842 
843         emit Transfer(address(0), _msgSender(), _tTotal);
844     }
845 
846     function name() public view returns (string memory) {
847         return _name;
848     }
849 
850     function symbol() public view returns (string memory) {
851         return _symbol;
852     }
853 
854     function decimals() public view returns (uint8) {
855         return _decimals;
856     }
857 
858     function totalSupply() public view override returns (uint256) {
859         return _tTotal;
860     }
861 
862     function balanceOf(address account) public view override returns (uint256) {
863         if (_isExcluded[account]) return _tOwned[account];
864         return tokenFromReflection(_rOwned[account]);
865     }
866 
867     function transfer(address recipient, uint256 amount) public override returns (bool) {
868         _transfer(_msgSender(), recipient, amount);
869         return true;
870     }
871 
872     function allowance(address owner, address spender) public view override returns (uint256) {
873         return _allowances[owner][spender];
874     }
875 
876     function approve(address spender, uint256 amount) public override returns (bool) {
877         _approve(_msgSender(), spender, amount);
878         return true;
879     }
880 
881     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
882         _transfer(sender, recipient, amount);
883         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
884         return true;
885     }
886 
887     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
888         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
889         return true;
890     }
891 
892     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
893         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
894         return true;
895     }
896 
897     function isExcludedFromReward(address account) public view returns (bool) {
898         return _isExcluded[account];
899     }
900 
901     function totalFees() public view returns (uint256) {
902         return _tFeeTotal;
903     }
904 
905     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
906         require(tAmount <= _tTotal, "Amount must be less than supply");
907         if (!deductTransferFee) {
908             (uint256 rAmount,,,,,) = _getValues(tAmount);
909             return rAmount;
910         } else {
911             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
912             return rTransferAmount;
913         }
914     }
915 
916     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
917         require(rAmount <= _rTotal, "Amount must be less than total reflections");
918         uint256 currentRate =  _getRate();
919         return rAmount.div(currentRate);
920     }
921 
922     function excludeFromReward(address account) public onlyOwner() {
923         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
924         require(!_isExcluded[account], "Account is already excluded");
925         if(_rOwned[account] > 0) {
926             _tOwned[account] = tokenFromReflection(_rOwned[account]);
927         }
928         _isExcluded[account] = true;
929         _excluded.push(account);
930     }
931 
932     function includeInReward(address account) external onlyOwner() {
933         require(_isExcluded[account], "Account is already excluded");
934         for (uint256 i = 0; i < _excluded.length; i++) {
935             if (_excluded[i] == account) {
936                 _excluded[i] = _excluded[_excluded.length - 1];
937                 _tOwned[account] = 0;
938                 _isExcluded[account] = false;
939                 _excluded.pop();
940                 break;
941             }
942         }
943     }
944 
945     function excludeFromFee(address account) public onlyOwner() {
946         _isExcludedFromFee[account] = true;
947     }
948 
949     function includeInFee(address account) public onlyOwner() {
950         _isExcludedFromFee[account] = false;
951     }
952 
953     function removeAllFee() private {
954         if(_taxFee == 0 && _marketingFee == 0) return;
955 
956         _previousTaxFee = _taxFee;
957         _previousMarketingFee = _marketingFee;
958 
959         _taxFee = 0;
960         _marketingFee = 0;
961     }
962 
963     function restoreAllFee() private {
964         _taxFee = _previousTaxFee;
965         _marketingFee = _previousMarketingFee;
966     }
967 
968     //to recieve ETH
969     receive() external payable {}
970 
971     function _reflectFee(uint256 rFee, uint256 tFee) private {
972         _rTotal = _rTotal.sub(rFee);
973         _tFeeTotal = _tFeeTotal.add(tFee);
974     }
975 
976     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
977         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
978         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
979         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
980     }
981 
982     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
983         uint256 tFee = calculateTaxFee(tAmount);
984         uint256 tMarketing = calculateMarketingFee(tAmount);
985         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
986         return (tTransferAmount, tFee, tMarketing);
987     }
988 
989     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
990         uint256 rAmount = tAmount.mul(currentRate);
991         uint256 rFee = tFee.mul(currentRate);
992         uint256 rMarketing = tMarketing.mul(currentRate);
993         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
994         return (rAmount, rTransferAmount, rFee);
995     }
996 
997     function _getRate() private view returns(uint256) {
998         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
999         return rSupply.div(tSupply);
1000     }
1001 
1002     function _getCurrentSupply() private view returns(uint256, uint256) {
1003         uint256 rSupply = _rTotal;
1004         uint256 tSupply = _tTotal;
1005         for (uint256 i = 0; i < _excluded.length; i++) {
1006             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1007             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1008             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1009         }
1010         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1011         return (rSupply, tSupply);
1012     }
1013 
1014     function _takeMarketing(uint256 tMarketing) private {
1015         uint256 currentRate =  _getRate();
1016         uint256 rMarketing = tMarketing.mul(currentRate);
1017         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1018         if(_isExcluded[address(this)])
1019             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1020     }
1021 
1022     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1023         return _amount.mul(_taxFee).div(
1024             10**2
1025         );
1026     }
1027 
1028     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1029         return _amount.mul(_marketingFee).div(
1030             10**2
1031         );
1032     }
1033 
1034     function isExcludedFromFee(address account) public view returns(bool) {
1035         return _isExcludedFromFee[account];
1036     }
1037 
1038     function _approve(address owner, address spender, uint256 amount) private {
1039         require(owner != address(0), "ERC20: approve from the zero address");
1040         require(spender != address(0), "ERC20: approve to the zero address");
1041 
1042         _allowances[owner][spender] = amount;
1043         emit Approval(owner, spender, amount);
1044     }
1045 
1046     function _transfer(
1047         address from,
1048         address to,
1049         uint256 amount
1050     ) private {
1051         require(from != address(0), "ERC20: transfer from the zero address");
1052         require(to != address(0), "ERC20: transfer to the zero address");
1053         require(amount > 0, "Transfer amount must be greater than zero");
1054 
1055         if(from != owner() && to != owner())
1056             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1057 
1058         // is the token balance of this contract address over the min number of
1059         // tokens that we need to initiate a swap + send lock?
1060         // also, don't get caught in a circular sending event.
1061         // also, don't swap & liquify if sender is uniswap pair.
1062         uint256 contractTokenBalance = balanceOf(address(this));
1063         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1064 
1065         if(contractTokenBalance >= _maxTxAmount)
1066         {
1067             contractTokenBalance = _maxTxAmount;
1068         }
1069 
1070         if (
1071             overMinTokenBalance &&
1072             !inSwapAndSend &&
1073             from != uniswapV2Pair &&
1074             SwapAndSendEnabled
1075         ) {
1076             SwapAndSend(contractTokenBalance);
1077         }
1078 
1079         if(feesOnSellersAndBuyers) {
1080             setFees(to);
1081         }
1082 
1083         //indicates if fee should be deducted from transfer
1084         bool takeFee = true;
1085 
1086         //if any account belongs to _isExcludedFromFee account then remove the fee
1087         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1088             takeFee = false;
1089         }
1090 
1091         _tokenTransfer(from,to,amount,takeFee);
1092     }
1093 
1094     function setFees(address recipient) private {
1095         _taxFee = defaultTaxFee;
1096         _marketingFee = defaultMarketingFee;
1097         if (recipient == uniswapV2Pair) { // sell
1098             _marketingFee = _marketingFee4Sellers;
1099         }
1100     }
1101 
1102     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1103         // generate the uniswap pair path of token -> weth
1104         address[] memory path = new address[](2);
1105         path[0] = address(this);
1106         path[1] = uniswapV2Router.WETH();
1107 
1108         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1109 
1110         // make the swap
1111         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1112             contractTokenBalance,
1113             0, // accept any amount of ETH
1114             path,
1115             address(this),
1116             block.timestamp
1117         );
1118 
1119         uint256 contractETHBalance = address(this).balance;
1120         if(contractETHBalance > 0) {
1121             marketingWallet.transfer(contractETHBalance);
1122         }
1123     }
1124 
1125     //this method is responsible for taking all fee, if takeFee is true
1126     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1127         if(!takeFee)
1128             removeAllFee();
1129 
1130         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1131             _transferFromExcluded(sender, recipient, amount);
1132         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1133             _transferToExcluded(sender, recipient, amount);
1134         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1135             _transferStandard(sender, recipient, amount);
1136         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1137             _transferBothExcluded(sender, recipient, amount);
1138         } else {
1139             _transferStandard(sender, recipient, amount);
1140         }
1141 
1142         if(!takeFee)
1143             restoreAllFee();
1144     }
1145 
1146     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1147         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1148         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1149         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1150         _takeMarketing(tMarketing);
1151         _reflectFee(rFee, tFee);
1152         emit Transfer(sender, recipient, tTransferAmount);
1153     }
1154 
1155     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1156         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1157         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1158         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1159         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1160         _takeMarketing(tMarketing);
1161         _reflectFee(rFee, tFee);
1162         emit Transfer(sender, recipient, tTransferAmount);
1163     }
1164 
1165     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1166         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1167         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1168         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1169         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1170         _takeMarketing(tMarketing);
1171         _reflectFee(rFee, tFee);
1172         emit Transfer(sender, recipient, tTransferAmount);
1173     }
1174 
1175     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1176         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1177         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1178         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1179         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1180         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1181         _takeMarketing(tMarketing);
1182         _reflectFee(rFee, tFee);
1183         emit Transfer(sender, recipient, tTransferAmount);
1184     }
1185 
1186     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1187         defaultMarketingFee = marketingFee;
1188     }
1189 
1190     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1191         _marketingFee4Sellers = marketingFee4Sellers;
1192     }
1193 
1194     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1195         feesOnSellersAndBuyers = _enabled;
1196     }
1197 
1198     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1199         SwapAndSendEnabled = _enabled;
1200         emit SwapAndSendEnabledUpdated(_enabled);
1201     }
1202 
1203     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1204         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1205     }
1206 
1207     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1208         marketingWallet = wallet;
1209     }
1210 
1211     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1212         _maxTxAmount = maxTxAmount;
1213     }
1214 }