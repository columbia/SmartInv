1 //@theserwen
2 
3 pragma solidity ^0.8.3;
4 // SPDX-License-Identifier: Unlicensed
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11     * @dev Returns the amount of tokens in existence.
12     */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16     * @dev Returns the amount of tokens owned by `account`.
17     */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21     * @dev Moves `amount` tokens from the caller's account to `recipient`.
22     *
23     * Returns a boolean value indicating whether the operation succeeded.
24     *
25     * Emits a {Transfer} event.
26     */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30     * @dev Returns the remaining number of tokens that `spender` will be
31     * allowed to spend on behalf of `owner` through {transferFrom}. This is
32     * zero by default.
33     *
34     * This value changes when {approve} or {transferFrom} are called.
35     */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40     *
41     * Returns a boolean value indicating whether the operation succeeded.
42     *
43     * IMPORTANT: Beware that changing an allowance with this method brings the risk
44     * that someone may use both the old and the new allowance by unfortunate
45     * transaction ordering. One possible solution to mitigate this race
46     * condition is to first reduce the spender's allowance to 0 and set the
47     * desired value afterwards:
48     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49     *
50     * Emits an {Approval} event.
51     */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55     * @dev Moves `amount` tokens from `sender` to `recipient` using the
56     * allowance mechanism. `amount` is then deducted from the caller's
57     * allowance.
58     *
59     * Returns a boolean value indicating whether the operation succeeded.
60     *
61     * Emits a {Transfer} event.
62     */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66     * @dev Emitted when `value` tokens are moved from one account (`from`) to
67     * another (`to`).
68     *
69     * Note that `value` may be zero.
70     */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75     * a call to {approve}. `value` is the new allowance.
76     */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // CAUTION
81 // This version of SafeMath should only be used with Solidity 0.8 or later,
82 // because it relies on the compiler's built in overflow checks.
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations.
86  *
87  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
88  * now has built in overflow checking.
89  */
90 library SafeMath {
91     /**
92     * @dev Returns the addition of two unsigned integers, with an overflow flag.
93     *
94     * _Available since v3.4._
95     */
96     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         unchecked {
98             uint256 c = a + b;
99             if (c < a) return (false, 0);
100             return (true, c);
101         }
102     }
103 
104     /**
105     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
106     *
107     * _Available since v3.4._
108     */
109     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             if (b > a) return (false, 0);
112             return (true, a - b);
113         }
114     }
115 
116     /**
117     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
118     *
119     * _Available since v3.4._
120     */
121     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
124             // benefit is lost if 'b' is also tested.
125             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
126             if (a == 0) return (true, 0);
127             uint256 c = a * b;
128             if (c / a != b) return (false, 0);
129             return (true, c);
130         }
131     }
132 
133     /**
134     * @dev Returns the division of two unsigned integers, with a division by zero flag.
135     *
136     * _Available since v3.4._
137     */
138     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         unchecked {
140             if (b == 0) return (false, 0);
141             return (true, a / b);
142         }
143     }
144 
145     /**
146     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
147     *
148     * _Available since v3.4._
149     */
150     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             if (b == 0) return (false, 0);
153             return (true, a % b);
154         }
155     }
156 
157     /**
158     * @dev Returns the addition of two unsigned integers, reverting on
159     * overflow.
160     *
161     * Counterpart to Solidity's `+` operator.
162     *
163     * Requirements:
164     *
165     * - Addition cannot overflow.
166     */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a + b;
169     }
170 
171     /**
172     * @dev Returns the subtraction of two unsigned integers, reverting on
173     * overflow (when the result is negative).
174     *
175     * Counterpart to Solidity's `-` operator.
176     *
177     * Requirements:
178     *
179     * - Subtraction cannot overflow.
180     */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a - b;
183     }
184 
185     /**
186     * @dev Returns the multiplication of two unsigned integers, reverting on
187     * overflow.
188     *
189     * Counterpart to Solidity's `*` operator.
190     *
191     * Requirements:
192     *
193     * - Multiplication cannot overflow.
194     */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         return a * b;
197     }
198 
199     /**
200     * @dev Returns the integer division of two unsigned integers, reverting on
201     * division by zero. The result is rounded towards zero.
202     *
203     * Counterpart to Solidity's `/` operator.
204     *
205     * Requirements:
206     *
207     * - The divisor cannot be zero.
208     */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a / b;
211     }
212 
213     /**
214     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215     * reverting when dividing by zero.
216     *
217     * Counterpart to Solidity's `%` operator. This function uses a `revert`
218     * opcode (which leaves remaining gas untouched) while Solidity uses an
219     * invalid opcode to revert (consuming all remaining gas).
220     *
221     * Requirements:
222     *
223     * - The divisor cannot be zero.
224     */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a % b;
227     }
228 
229     /**
230     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231     * overflow (when the result is negative).
232     *
233     * CAUTION: This function is deprecated because it requires allocating memory for the error
234     * message unnecessarily. For custom revert reasons use {trySub}.
235     *
236     * Counterpart to Solidity's `-` operator.
237     *
238     * Requirements:
239     *
240     * - Subtraction cannot overflow.
241     */
242     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         unchecked {
244             require(b <= a, errorMessage);
245             return a - b;
246         }
247     }
248 
249     /**
250     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
251     * division by zero. The result is rounded towards zero.
252     *
253     * Counterpart to Solidity's `%` operator. This function uses a `revert`
254     * opcode (which leaves remaining gas untouched) while Solidity uses an
255     * invalid opcode to revert (consuming all remaining gas).
256     *
257     * Counterpart to Solidity's `/` operator. Note: this function uses a
258     * `revert` opcode (which leaves remaining gas untouched) while Solidity
259     * uses an invalid opcode to revert (consuming all remaining gas).
260     *
261     * Requirements:
262     *
263     * - The divisor cannot be zero.
264     */
265     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         unchecked {
267             require(b > 0, errorMessage);
268             return a / b;
269         }
270     }
271 
272     /**
273     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
274     * reverting with custom message when dividing by zero.
275     *
276     * CAUTION: This function is deprecated because it requires allocating memory for the error
277     * message unnecessarily. For custom revert reasons use {tryMod}.
278     *
279     * Counterpart to Solidity's `%` operator. This function uses a `revert`
280     * opcode (which leaves remaining gas untouched) while Solidity uses an
281     * invalid opcode to revert (consuming all remaining gas).
282     *
283     * Requirements:
284     *
285     * - The divisor cannot be zero.
286     */
287     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         unchecked {
289             require(b > 0, errorMessage);
290             return a % b;
291         }
292     }
293 }
294 
295 /*
296  * @dev Provides information about the current execution context, including the
297  * sender of the transaction and its data. While these are generally available
298  * via msg.sender and msg.data, they should not be accessed in such a direct
299  * manner, since when dealing with meta-transactions the account sending and
300  * paying for execution may not be the actual sender (as far as an application
301  * is concerned).
302  *
303  * This contract is only required for intermediate, library-like contracts.
304  */
305 abstract contract Context {
306     function _msgSender() internal view virtual returns (address) {
307         return msg.sender;
308     }
309 
310     function _msgData() internal view virtual returns (bytes calldata) {
311         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
312         return msg.data;
313     }
314 }
315 
316 /**
317  * @dev Collection of functions related to the address type
318  */
319 library Address {
320     /**
321     * @dev Returns true if `account` is a contract.
322     *
323     * [IMPORTANT]
324     * ====
325     * It is unsafe to assume that an address for which this function returns
326     * false is an externally-owned account (EOA) and not a contract.
327     *
328     * Among others, `isContract` will return false for the following
329     * types of addresses:
330     *
331     *  - an externally-owned account
332     *  - a contract in construction
333     *  - an address where a contract will be created
334     *  - an address where a contract lived, but was destroyed
335     * ====
336     */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies on extcodesize, which returns 0 for contracts in
339         // construction, since the code is only stored at the end of the
340         // constructor execution.
341 
342         uint256 size;
343         // solhint-disable-next-line no-inline-assembly
344         assembly { size := extcodesize(account) }
345         return size > 0;
346     }
347 
348     /**
349     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350     * `recipient`, forwarding all available gas and reverting on errors.
351     *
352     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353     * of certain opcodes, possibly making contracts go over the 2300 gas limit
354     * imposed by `transfer`, making them unable to receive funds via
355     * `transfer`. {sendValue} removes this limitation.
356     *
357     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358     *
359     * IMPORTANT: because control is transferred to `recipient`, care must be
360     * taken to not create reentrancy vulnerabilities. Consider using
361     * {ReentrancyGuard} or the
362     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363     */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
368         (bool success, ) = recipient.call{ value: amount }("");
369         require(success, "Address: unable to send value, recipient may have reverted");
370     }
371 
372     /**
373     * @dev Performs a Solidity function call using a low level `call`. A
374     * plain`call` is an unsafe replacement for a function call: use this
375     * function instead.
376     *
377     * If `target` reverts with a revert reason, it is bubbled up by this
378     * function (like regular Solidity function calls).
379     *
380     * Returns the raw returned data. To convert to the expected return value,
381     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382     *
383     * Requirements:
384     *
385     * - `target` must be a contract.
386     * - calling `target` with `data` must not revert.
387     *
388     * _Available since v3.1._
389     */
390     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
391       return functionCall(target, data, "Address: low-level call failed");
392     }
393 
394     /**
395     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
396     * `errorMessage` as a fallback revert reason when `target` reverts.
397     *
398     * _Available since v3.1._
399     */
400     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, 0, errorMessage);
402     }
403 
404     /**
405     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406     * but also transferring `value` wei to `target`.
407     *
408     * Requirements:
409     *
410     * - the calling contract must have an ETH balance of at least `value`.
411     * - the called Solidity function must be `payable`.
412     *
413     * _Available since v3.1._
414     */
415     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
417     }
418 
419     /**
420     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
421     * with `errorMessage` as a fallback revert reason when `target` reverts.
422     *
423     * _Available since v3.1._
424     */
425     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
426         require(address(this).balance >= value, "Address: insufficient balance for call");
427         require(isContract(target), "Address: call to non-contract");
428 
429         // solhint-disable-next-line avoid-low-level-calls
430         (bool success, bytes memory returndata) = target.call{ value: value }(data);
431         return _verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436     * but performing a static call.
437     *
438     * _Available since v3.3._
439     */
440     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
441         return functionStaticCall(target, data, "Address: low-level static call failed");
442     }
443 
444     /**
445     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446     * but performing a static call.
447     *
448     * _Available since v3.3._
449     */
450     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
451         require(isContract(target), "Address: static call to non-contract");
452 
453         // solhint-disable-next-line avoid-low-level-calls
454         (bool success, bytes memory returndata) = target.staticcall(data);
455         return _verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460     * but performing a delegate call.
461     *
462     * _Available since v3.4._
463     */
464     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
465         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
466     }
467 
468     /**
469     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470     * but performing a delegate call.
471     *
472     * _Available since v3.4._
473     */
474     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
475         require(isContract(target), "Address: delegate call to non-contract");
476 
477         // solhint-disable-next-line avoid-low-level-calls
478         (bool success, bytes memory returndata) = target.delegatecall(data);
479         return _verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
483         if (success) {
484             return returndata;
485         } else {
486             // Look for revert reason and bubble it up if present
487             if (returndata.length > 0) {
488                 // The easiest way to bubble the revert reason is using memory via assembly
489 
490                 // solhint-disable-next-line no-inline-assembly
491                 assembly {
492                     let returndata_size := mload(returndata)
493                     revert(add(32, returndata), returndata_size)
494                 }
495             } else {
496                 revert(errorMessage);
497             }
498         }
499     }
500 }
501 
502 /**
503  * @dev Contract module which provides a basic access control mechanism, where
504  * there is an account (an owner) that can be granted exclusive access to
505  * specific functions.
506  *
507  * By default, the owner account will be the one that deploys the contract. This
508  * can later be changed with {transferOwnership}.
509  *
510  * This module is used through inheritance. It will make available the modifier
511  * `onlyOwner`, which can be applied to your functions to restrict their use to
512  * the owner.
513  */
514 abstract contract Ownable is Context {
515     address private _owner;
516 
517     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
518 
519     /**
520     * @dev Initializes the contract setting the deployer as the initial owner.
521     */
522     constructor () {
523         _owner = _msgSender();
524         emit OwnershipTransferred(address(0), _owner);
525     }
526 
527     /**
528     * @dev Returns the address of the current owner.
529     */
530     function owner() public view virtual returns (address) {
531         return _owner;
532     }
533 
534     /**
535     * @dev Throws if called by any account other than the owner.
536     */
537     modifier onlyOwner() {
538         require(owner() == _msgSender(), "Ownable: caller is not the owner");
539         _;
540     }
541 
542     /**
543     * @dev Leaves the contract without owner. It will not be possible to call
544     * `onlyOwner` functions anymore. Can only be called by the current owner.
545     *
546     * NOTE: Renouncing ownership will leave the contract without an owner,
547     * thereby removing any functionality that is only available to the owner.
548     */
549     function renounceOwnership() public virtual onlyOwner {
550         emit OwnershipTransferred(_owner, address(0));
551         _owner = address(0);
552     }
553 
554     /**
555     * @dev Transfers ownership of the contract to a new account (`newOwner`).
556     * Can only be called by the current owner.
557     */
558     function transferOwnership(address newOwner) public virtual onlyOwner {
559         require(newOwner != address(0), "Ownable: new owner is the zero address");
560         emit OwnershipTransferred(_owner, newOwner);
561         _owner = newOwner;
562     }
563 }
564 
565 interface IUniswapV2Factory {
566     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
567 
568     function feeTo() external view returns (address);
569     function feeToSetter() external view returns (address);
570 
571     function getPair(address tokenA, address tokenB) external view returns (address pair);
572     function allPairs(uint) external view returns (address pair);
573     function allPairsLength() external view returns (uint);
574 
575     function createPair(address tokenA, address tokenB) external returns (address pair);
576 
577     function setFeeTo(address) external;
578     function setFeeToSetter(address) external;
579 }
580 
581 interface IUniswapV2Pair {
582     event Approval(address indexed owner, address indexed spender, uint value);
583     event Transfer(address indexed from, address indexed to, uint value);
584 
585     function name() external pure returns (string memory);
586     function symbol() external pure returns (string memory);
587     function decimals() external pure returns (uint8);
588     function totalSupply() external view returns (uint);
589     function balanceOf(address owner) external view returns (uint);
590     function allowance(address owner, address spender) external view returns (uint);
591 
592     function approve(address spender, uint value) external returns (bool);
593     function transfer(address to, uint value) external returns (bool);
594     function transferFrom(address from, address to, uint value) external returns (bool);
595 
596     function DOMAIN_SEPARATOR() external view returns (bytes32);
597     function PERMIT_TYPEHASH() external pure returns (bytes32);
598     function nonces(address owner) external view returns (uint);
599 
600     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
601 
602     event Mint(address indexed sender, uint amount0, uint amount1);
603     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
604     event Swap(
605         address indexed sender,
606         uint amount0In,
607         uint amount1In,
608         uint amount0Out,
609         uint amount1Out,
610         address indexed to
611     );
612     event Sync(uint112 reserve0, uint112 reserve1);
613 
614     function MINIMUM_LIQUIDITY() external pure returns (uint);
615     function factory() external view returns (address);
616     function token0() external view returns (address);
617     function token1() external view returns (address);
618     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
619     function price0CumulativeLast() external view returns (uint);
620     function price1CumulativeLast() external view returns (uint);
621     function kLast() external view returns (uint);
622 
623     function mint(address to) external returns (uint liquidity);
624     function burn(address to) external returns (uint amount0, uint amount1);
625     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
626     function skim(address to) external;
627     function sync() external;
628 
629     function initialize(address, address) external;
630 }
631 
632 interface IUniswapV2Router01 {
633     function factory() external pure returns (address);
634     function WETH() external pure returns (address);
635 
636     function addLiquidity(
637         address tokenA,
638         address tokenB,
639         uint amountADesired,
640         uint amountBDesired,
641         uint amountAMin,
642         uint amountBMin,
643         address to,
644         uint deadline
645     ) external returns (uint amountA, uint amountB, uint liquidity);
646     function addLiquidityETH(
647         address token,
648         uint amountTokenDesired,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline
653     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
654     function removeLiquidity(
655         address tokenA,
656         address tokenB,
657         uint liquidity,
658         uint amountAMin,
659         uint amountBMin,
660         address to,
661         uint deadline
662     ) external returns (uint amountA, uint amountB);
663     function removeLiquidityETH(
664         address token,
665         uint liquidity,
666         uint amountTokenMin,
667         uint amountETHMin,
668         address to,
669         uint deadline
670     ) external returns (uint amountToken, uint amountETH);
671     function removeLiquidityWithPermit(
672         address tokenA,
673         address tokenB,
674         uint liquidity,
675         uint amountAMin,
676         uint amountBMin,
677         address to,
678         uint deadline,
679         bool approveMax, uint8 v, bytes32 r, bytes32 s
680     ) external returns (uint amountA, uint amountB);
681     function removeLiquidityETHWithPermit(
682         address token,
683         uint liquidity,
684         uint amountTokenMin,
685         uint amountETHMin,
686         address to,
687         uint deadline,
688         bool approveMax, uint8 v, bytes32 r, bytes32 s
689     ) external returns (uint amountToken, uint amountETH);
690     function swapExactTokensForTokens(
691         uint amountIn,
692         uint amountOutMin,
693         address[] calldata path,
694         address to,
695         uint deadline
696     ) external returns (uint[] memory amounts);
697     function swapTokensForExactTokens(
698         uint amountOut,
699         uint amountInMax,
700         address[] calldata path,
701         address to,
702         uint deadline
703     ) external returns (uint[] memory amounts);
704     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
705         external
706         payable
707         returns (uint[] memory amounts);
708     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
709         external
710         returns (uint[] memory amounts);
711     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
712         external
713         returns (uint[] memory amounts);
714     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
715         external
716         payable
717         returns (uint[] memory amounts);
718 
719     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
720     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
721     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
722     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
723     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
724 }
725 
726 interface IUniswapV2Router02 is IUniswapV2Router01 {
727     function removeLiquidityETHSupportingFeeOnTransferTokens(
728         address token,
729         uint liquidity,
730         uint amountTokenMin,
731         uint amountETHMin,
732         address to,
733         uint deadline
734     ) external returns (uint amountETH);
735     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
736         address token,
737         uint liquidity,
738         uint amountTokenMin,
739         uint amountETHMin,
740         address to,
741         uint deadline,
742         bool approveMax, uint8 v, bytes32 r, bytes32 s
743     ) external returns (uint amountETH);
744 
745     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
746         uint amountIn,
747         uint amountOutMin,
748         address[] calldata path,
749         address to,
750         uint deadline
751     ) external;
752     function swapExactETHForTokensSupportingFeeOnTransferTokens(
753         uint amountOutMin,
754         address[] calldata path,
755         address to,
756         uint deadline
757     ) external payable;
758     function swapExactTokensForETHSupportingFeeOnTransferTokens(
759         uint amountIn,
760         uint amountOutMin,
761         address[] calldata path,
762         address to,
763         uint deadline
764     ) external;
765 }
766 
767 
768 contract THESER is Context, IERC20, Ownable {
769     using SafeMath for uint256;
770     using Address for address;
771 
772     uint8 private _decimals = 9;
773 
774     
775     string private _name = "The Ser";
776     string private _symbol = "TS";
777     uint256 private _tTotal = 10 * 10**9 * 10**uint256(_decimals);
778 
779    
780     uint256 public defaultTaxFee = 0;
781     uint256 public _taxFee = defaultTaxFee;
782     uint256 private _previousTaxFee = _taxFee;
783 
784     
785     uint256 public defaultMarketingFee = 0;
786     uint256 public _marketingFee = defaultMarketingFee;
787     uint256 private _previousMarketingFee = _marketingFee;
788 
789     uint256 public _marketingFee4Sellers = 0;
790 
791     bool public feesOnSellersAndBuyers = true;
792 
793     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
794     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
795     address payable public marketingWallet = payable(0x000000000000000000000000000000000000dEaD);
796 
797     
798 
799     mapping (address => uint256) private _rOwned;
800     mapping (address => uint256) private _tOwned;
801     mapping (address => mapping (address => uint256)) private _allowances;
802 
803     mapping (address => bool) private _isExcludedFromFee;
804 
805     mapping (address => bool) private _isExcluded;
806 
807     address[] private _excluded;
808     uint256 private constant MAX = ~uint256(0);
809 
810     uint256 private _tFeeTotal;
811     uint256 private _rTotal = (MAX - (MAX % _tTotal));
812 
813     IUniswapV2Router02 public immutable uniswapV2Router;
814     address public immutable uniswapV2Pair;
815 
816     bool inSwapAndSend;
817     bool public SwapAndSendEnabled = true;
818 
819     event SwapAndSendEnabledUpdated(bool enabled);
820 
821     modifier lockTheSwap {
822         inSwapAndSend = true;
823         _;
824         inSwapAndSend = false;
825     }
826 
827     constructor () {
828         _rOwned[_msgSender()] = _rTotal;
829 
830         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
831          // Create a uniswap pair for this new token
832         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
833             .createPair(address(this), _uniswapV2Router.WETH());
834 
835         // set the rest of the contract variables
836         uniswapV2Router = _uniswapV2Router;
837 
838         //exclude owner and this contract from fee
839         _isExcludedFromFee[owner()] = true;
840         _isExcludedFromFee[address(this)] = true;
841 
842         emit Transfer(address(0), _msgSender(), _tTotal);
843     }
844 
845     function name() public view returns (string memory) {
846         return _name;
847     }
848 
849     function symbol() public view returns (string memory) {
850         return _symbol;
851     }
852 
853     function decimals() public view returns (uint8) {
854         return _decimals;
855     }
856 
857     function totalSupply() public view override returns (uint256) {
858         return _tTotal;
859     }
860 
861     function balanceOf(address account) public view override returns (uint256) {
862         if (_isExcluded[account]) return _tOwned[account];
863         return tokenFromReflection(_rOwned[account]);
864     }
865 
866     function transfer(address recipient, uint256 amount) public override returns (bool) {
867         _transfer(_msgSender(), recipient, amount);
868         return true;
869     }
870 
871     function allowance(address owner, address spender) public view override returns (uint256) {
872         return _allowances[owner][spender];
873     }
874 
875     function approve(address spender, uint256 amount) public override returns (bool) {
876         _approve(_msgSender(), spender, amount);
877         return true;
878     }
879 
880     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
881         _transfer(sender, recipient, amount);
882         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
883         return true;
884     }
885 
886     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
887         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
888         return true;
889     }
890 
891     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
892         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
893         return true;
894     }
895 
896     function isExcludedFromReward(address account) public view returns (bool) {
897         return _isExcluded[account];
898     }
899 
900     function totalFees() public view returns (uint256) {
901         return _tFeeTotal;
902     }
903 
904     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
905         require(tAmount <= _tTotal, "Amount must be less than supply");
906         if (!deductTransferFee) {
907             (uint256 rAmount,,,,,) = _getValues(tAmount);
908             return rAmount;
909         } else {
910             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
911             return rTransferAmount;
912         }
913     }
914 
915     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
916         require(rAmount <= _rTotal, "Amount must be less than total reflections");
917         uint256 currentRate =  _getRate();
918         return rAmount.div(currentRate);
919     }
920 
921     function excludeFromReward(address account) public onlyOwner() {
922         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
923         require(!_isExcluded[account], "Account is already excluded");
924         if(_rOwned[account] > 0) {
925             _tOwned[account] = tokenFromReflection(_rOwned[account]);
926         }
927         _isExcluded[account] = true;
928         _excluded.push(account);
929     }
930 
931     function includeInReward(address account) external onlyOwner() {
932         require(_isExcluded[account], "Account is already excluded");
933         for (uint256 i = 0; i < _excluded.length; i++) {
934             if (_excluded[i] == account) {
935                 _excluded[i] = _excluded[_excluded.length - 1];
936                 _tOwned[account] = 0;
937                 _isExcluded[account] = false;
938                 _excluded.pop();
939                 break;
940             }
941         }
942     }
943 
944     function excludeFromFee(address account) public onlyOwner() {
945         _isExcludedFromFee[account] = true;
946     }
947 
948     function includeInFee(address account) public onlyOwner() {
949         _isExcludedFromFee[account] = false;
950     }
951 
952     function removeAllFee() private {
953         if(_taxFee == 0 && _marketingFee == 0) return;
954 
955         _previousTaxFee = _taxFee;
956         _previousMarketingFee = _marketingFee;
957 
958         _taxFee = 0;
959         _marketingFee = 0;
960     }
961 
962     function restoreAllFee() private {
963         _taxFee = _previousTaxFee;
964         _marketingFee = _previousMarketingFee;
965     }
966 
967     //to recieve ETH
968     receive() external payable {}
969 
970     function _reflectFee(uint256 rFee, uint256 tFee) private {
971         _rTotal = _rTotal.sub(rFee);
972         _tFeeTotal = _tFeeTotal.add(tFee);
973     }
974 
975     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
976         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
977         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
978         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
979     }
980 
981     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
982         uint256 tFee = calculateTaxFee(tAmount);
983         uint256 tMarketing = calculateMarketingFee(tAmount);
984         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
985         return (tTransferAmount, tFee, tMarketing);
986     }
987 
988     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
989         uint256 rAmount = tAmount.mul(currentRate);
990         uint256 rFee = tFee.mul(currentRate);
991         uint256 rMarketing = tMarketing.mul(currentRate);
992         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
993         return (rAmount, rTransferAmount, rFee);
994     }
995 
996     function _getRate() private view returns(uint256) {
997         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
998         return rSupply.div(tSupply);
999     }
1000 
1001     function _getCurrentSupply() private view returns(uint256, uint256) {
1002         uint256 rSupply = _rTotal;
1003         uint256 tSupply = _tTotal;
1004         for (uint256 i = 0; i < _excluded.length; i++) {
1005             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1006             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1007             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1008         }
1009         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1010         return (rSupply, tSupply);
1011     }
1012 
1013     function _takeMarketing(uint256 tMarketing) private {
1014         uint256 currentRate =  _getRate();
1015         uint256 rMarketing = tMarketing.mul(currentRate);
1016         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1017         if(_isExcluded[address(this)])
1018             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1019     }
1020 
1021     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1022         return _amount.mul(_taxFee).div(
1023             10**2
1024         );
1025     }
1026 
1027     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1028         return _amount.mul(_marketingFee).div(
1029             10**2
1030         );
1031     }
1032 
1033     function isExcludedFromFee(address account) public view returns(bool) {
1034         return _isExcludedFromFee[account];
1035     }
1036 
1037     function _approve(address owner, address spender, uint256 amount) private {
1038         require(owner != address(0), "ERC20: approve from the zero address");
1039         require(spender != address(0), "ERC20: approve to the zero address");
1040 
1041         _allowances[owner][spender] = amount;
1042         emit Approval(owner, spender, amount);
1043     }
1044 
1045     function _transfer(
1046         address from,
1047         address to,
1048         uint256 amount
1049     ) private {
1050         require(from != address(0), "ERC20: transfer from the zero address");
1051         require(to != address(0), "ERC20: transfer to the zero address");
1052         require(amount > 0, "Transfer amount must be greater than zero");
1053 
1054         if(from != owner() && to != owner())
1055             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1056 
1057         // is the token balance of this contract address over the min number of
1058         // tokens that we need to initiate a swap + send lock?
1059         // also, don't get caught in a circular sending event.
1060         // also, don't swap & liquify if sender is uniswap pair.
1061         uint256 contractTokenBalance = balanceOf(address(this));
1062         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1063 
1064         if(contractTokenBalance >= _maxTxAmount)
1065         {
1066             contractTokenBalance = _maxTxAmount;
1067         }
1068 
1069         if (
1070             overMinTokenBalance &&
1071             !inSwapAndSend &&
1072             from != uniswapV2Pair &&
1073             SwapAndSendEnabled
1074         ) {
1075             SwapAndSend(contractTokenBalance);
1076         }
1077 
1078         if(feesOnSellersAndBuyers) {
1079             setFees(to);
1080         }
1081 
1082         //indicates if fee should be deducted from transfer
1083         bool takeFee = true;
1084 
1085         //if any account belongs to _isExcludedFromFee account then remove the fee
1086         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1087             takeFee = false;
1088         }
1089 
1090         _tokenTransfer(from,to,amount,takeFee);
1091     }
1092 
1093     function setFees(address recipient) private {
1094         _taxFee = defaultTaxFee;
1095         _marketingFee = defaultMarketingFee;
1096         if (recipient == uniswapV2Pair) { // sell
1097             _marketingFee = _marketingFee4Sellers;
1098         }
1099     }
1100 
1101     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1102         // generate the uniswap pair path of token -> weth
1103         address[] memory path = new address[](2);
1104         path[0] = address(this);
1105         path[1] = uniswapV2Router.WETH();
1106 
1107         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1108 
1109         // make the swap
1110         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1111             contractTokenBalance,
1112             0, // accept any amount of ETH
1113             path,
1114             address(this),
1115             block.timestamp
1116         );
1117 
1118         uint256 contractETHBalance = address(this).balance;
1119         if(contractETHBalance > 0) {
1120             marketingWallet.transfer(contractETHBalance);
1121         }
1122     }
1123 
1124     //this method is responsible for taking all fee, if takeFee is true
1125     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1126         if(!takeFee)
1127             removeAllFee();
1128 
1129         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1130             _transferFromExcluded(sender, recipient, amount);
1131         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1132             _transferToExcluded(sender, recipient, amount);
1133         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1134             _transferStandard(sender, recipient, amount);
1135         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1136             _transferBothExcluded(sender, recipient, amount);
1137         } else {
1138             _transferStandard(sender, recipient, amount);
1139         }
1140 
1141         if(!takeFee)
1142             restoreAllFee();
1143     }
1144 
1145     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1146         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1147         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1148         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1149         _takeMarketing(tMarketing);
1150         _reflectFee(rFee, tFee);
1151         emit Transfer(sender, recipient, tTransferAmount);
1152     }
1153 
1154     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1155         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1156         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1157         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1158         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1159         _takeMarketing(tMarketing);
1160         _reflectFee(rFee, tFee);
1161         emit Transfer(sender, recipient, tTransferAmount);
1162     }
1163 
1164     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1165         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1166         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1167         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1168         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1169         _takeMarketing(tMarketing);
1170         _reflectFee(rFee, tFee);
1171         emit Transfer(sender, recipient, tTransferAmount);
1172     }
1173 
1174     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1175         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1176         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1177         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1178         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1179         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1180         _takeMarketing(tMarketing);
1181         _reflectFee(rFee, tFee);
1182         emit Transfer(sender, recipient, tTransferAmount);
1183     }
1184 
1185     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1186         defaultMarketingFee = marketingFee;
1187     }
1188 
1189     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1190         _marketingFee4Sellers = marketingFee4Sellers;
1191     }
1192 
1193     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1194         feesOnSellersAndBuyers = _enabled;
1195     }
1196 
1197     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1198         SwapAndSendEnabled = _enabled;
1199         emit SwapAndSendEnabledUpdated(_enabled);
1200     }
1201 
1202     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1203         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1204     }
1205 
1206     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1207         marketingWallet = wallet;
1208     }
1209 
1210     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1211         _maxTxAmount = maxTxAmount;
1212     }
1213 }