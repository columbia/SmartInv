1 pragma solidity ^0.8.3;
2 // SPDX-License-Identifier: Unlicensed
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9     * @dev Returns the amount of tokens in existence.
10     */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14     * @dev Returns the amount of tokens owned by `account`.
15     */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19     * @dev Moves `amount` tokens from the caller's account to `recipient`.
20     *
21     * Returns a boolean value indicating whether the operation succeeded.
22     *
23     * Emits a {Transfer} event.
24     */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28     * @dev Returns the remaining number of tokens that `spender` will be
29     * allowed to spend on behalf of `owner` through {transferFrom}. This is
30     * zero by default.
31     *
32     * This value changes when {approve} or {transferFrom} are called.
33     */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38     *
39     * Returns a boolean value indicating whether the operation succeeded.
40     *
41     * IMPORTANT: Beware that changing an allowance with this method brings the risk
42     * that someone may use both the old and the new allowance by unfortunate
43     * transaction ordering. One possible solution to mitigate this race
44     * condition is to first reduce the spender's allowance to 0 and set the
45     * desired value afterwards:
46     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47     *
48     * Emits an {Approval} event.
49     */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53     * @dev Moves `amount` tokens from `sender` to `recipient` using the
54     * allowance mechanism. `amount` is then deducted from the caller's
55     * allowance.
56     *
57     * Returns a boolean value indicating whether the operation succeeded.
58     *
59     * Emits a {Transfer} event.
60     */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64     * @dev Emitted when `value` tokens are moved from one account (`from`) to
65     * another (`to`).
66     *
67     * Note that `value` may be zero.
68     */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73     * a call to {approve}. `value` is the new allowance.
74     */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // CAUTION
79 // This version of SafeMath should only be used with Solidity 0.8 or later,
80 // because it relies on the compiler's built in overflow checks.
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations.
84  *
85  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
86  * now has built in overflow checking.
87  */
88 library SafeMath {
89     /**
90     * @dev Returns the addition of two unsigned integers, with an overflow flag.
91     *
92     * _Available since v3.4._
93     */
94     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96             uint256 c = a + b;
97             if (c < a) return (false, 0);
98             return (true, c);
99         }
100     }
101 
102     /**
103     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
104     *
105     * _Available since v3.4._
106     */
107     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         unchecked {
109             if (b > a) return (false, 0);
110             return (true, a - b);
111         }
112     }
113 
114     /**
115     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
116     *
117     * _Available since v3.4._
118     */
119     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
122             // benefit is lost if 'b' is also tested.
123             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
124             if (a == 0) return (true, 0);
125             uint256 c = a * b;
126             if (c / a != b) return (false, 0);
127             return (true, c);
128         }
129     }
130 
131     /**
132     * @dev Returns the division of two unsigned integers, with a division by zero flag.
133     *
134     * _Available since v3.4._
135     */
136     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         unchecked {
138             if (b == 0) return (false, 0);
139             return (true, a / b);
140         }
141     }
142 
143     /**
144     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
145     *
146     * _Available since v3.4._
147     */
148     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         unchecked {
150             if (b == 0) return (false, 0);
151             return (true, a % b);
152         }
153     }
154 
155     /**
156     * @dev Returns the addition of two unsigned integers, reverting on
157     * overflow.
158     *
159     * Counterpart to Solidity's `+` operator.
160     *
161     * Requirements:
162     *
163     * - Addition cannot overflow.
164     */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a + b;
167     }
168 
169     /**
170     * @dev Returns the subtraction of two unsigned integers, reverting on
171     * overflow (when the result is negative).
172     *
173     * Counterpart to Solidity's `-` operator.
174     *
175     * Requirements:
176     *
177     * - Subtraction cannot overflow.
178     */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a - b;
181     }
182 
183     /**
184     * @dev Returns the multiplication of two unsigned integers, reverting on
185     * overflow.
186     *
187     * Counterpart to Solidity's `*` operator.
188     *
189     * Requirements:
190     *
191     * - Multiplication cannot overflow.
192     */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         return a * b;
195     }
196 
197     /**
198     * @dev Returns the integer division of two unsigned integers, reverting on
199     * division by zero. The result is rounded towards zero.
200     *
201     * Counterpart to Solidity's `/` operator.
202     *
203     * Requirements:
204     *
205     * - The divisor cannot be zero.
206     */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a / b;
209     }
210 
211     /**
212     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213     * reverting when dividing by zero.
214     *
215     * Counterpart to Solidity's `%` operator. This function uses a `revert`
216     * opcode (which leaves remaining gas untouched) while Solidity uses an
217     * invalid opcode to revert (consuming all remaining gas).
218     *
219     * Requirements:
220     *
221     * - The divisor cannot be zero.
222     */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a % b;
225     }
226 
227     /**
228     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
229     * overflow (when the result is negative).
230     *
231     * CAUTION: This function is deprecated because it requires allocating memory for the error
232     * message unnecessarily. For custom revert reasons use {trySub}.
233     *
234     * Counterpart to Solidity's `-` operator.
235     *
236     * Requirements:
237     *
238     * - Subtraction cannot overflow.
239     */
240     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         unchecked {
242             require(b <= a, errorMessage);
243             return a - b;
244         }
245     }
246 
247     /**
248     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
249     * division by zero. The result is rounded towards zero.
250     *
251     * Counterpart to Solidity's `%` operator. This function uses a `revert`
252     * opcode (which leaves remaining gas untouched) while Solidity uses an
253     * invalid opcode to revert (consuming all remaining gas).
254     *
255     * Counterpart to Solidity's `/` operator. Note: this function uses a
256     * `revert` opcode (which leaves remaining gas untouched) while Solidity
257     * uses an invalid opcode to revert (consuming all remaining gas).
258     *
259     * Requirements:
260     *
261     * - The divisor cannot be zero.
262     */
263     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         unchecked {
265             require(b > 0, errorMessage);
266             return a / b;
267         }
268     }
269 
270     /**
271     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272     * reverting with custom message when dividing by zero.
273     *
274     * CAUTION: This function is deprecated because it requires allocating memory for the error
275     * message unnecessarily. For custom revert reasons use {tryMod}.
276     *
277     * Counterpart to Solidity's `%` operator. This function uses a `revert`
278     * opcode (which leaves remaining gas untouched) while Solidity uses an
279     * invalid opcode to revert (consuming all remaining gas).
280     *
281     * Requirements:
282     *
283     * - The divisor cannot be zero.
284     */
285     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         unchecked {
287             require(b > 0, errorMessage);
288             return a % b;
289         }
290     }
291 }
292 
293 /*
294  * @dev Provides information about the current execution context, including the
295  * sender of the transaction and its data. While these are generally available
296  * via msg.sender and msg.data, they should not be accessed in such a direct
297  * manner, since when dealing with meta-transactions the account sending and
298  * paying for execution may not be the actual sender (as far as an application
299  * is concerned).
300  *
301  * This contract is only required for intermediate, library-like contracts.
302  */
303 abstract contract Context {
304     function _msgSender() internal view virtual returns (address) {
305         return msg.sender;
306     }
307 
308     function _msgData() internal view virtual returns (bytes calldata) {
309         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
310         return msg.data;
311     }
312 }
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319     * @dev Returns true if `account` is a contract.
320     *
321     * [IMPORTANT]
322     * ====
323     * It is unsafe to assume that an address for which this function returns
324     * false is an externally-owned account (EOA) and not a contract.
325     *
326     * Among others, `isContract` will return false for the following
327     * types of addresses:
328     *
329     *  - an externally-owned account
330     *  - a contract in construction
331     *  - an address where a contract will be created
332     *  - an address where a contract lived, but was destroyed
333     * ====
334     */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize, which returns 0 for contracts in
337         // construction, since the code is only stored at the end of the
338         // constructor execution.
339 
340         uint256 size;
341         // solhint-disable-next-line no-inline-assembly
342         assembly { size := extcodesize(account) }
343         return size > 0;
344     }
345 
346     /**
347     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
348     * `recipient`, forwarding all available gas and reverting on errors.
349     *
350     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
351     * of certain opcodes, possibly making contracts go over the 2300 gas limit
352     * imposed by `transfer`, making them unable to receive funds via
353     * `transfer`. {sendValue} removes this limitation.
354     *
355     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
356     *
357     * IMPORTANT: because control is transferred to `recipient`, care must be
358     * taken to not create reentrancy vulnerabilities. Consider using
359     * {ReentrancyGuard} or the
360     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
361     */
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
366         (bool success, ) = recipient.call{ value: amount }("");
367         require(success, "Address: unable to send value, recipient may have reverted");
368     }
369 
370     /**
371     * @dev Performs a Solidity function call using a low level `call`. A
372     * plain`call` is an unsafe replacement for a function call: use this
373     * function instead.
374     *
375     * If `target` reverts with a revert reason, it is bubbled up by this
376     * function (like regular Solidity function calls).
377     *
378     * Returns the raw returned data. To convert to the expected return value,
379     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
380     *
381     * Requirements:
382     *
383     * - `target` must be a contract.
384     * - calling `target` with `data` must not revert.
385     *
386     * _Available since v3.1._
387     */
388     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
389       return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394     * `errorMessage` as a fallback revert reason when `target` reverts.
395     *
396     * _Available since v3.1._
397     */
398     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, 0, errorMessage);
400     }
401 
402     /**
403     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404     * but also transferring `value` wei to `target`.
405     *
406     * Requirements:
407     *
408     * - the calling contract must have an ETH balance of at least `value`.
409     * - the called Solidity function must be `payable`.
410     *
411     * _Available since v3.1._
412     */
413     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
415     }
416 
417     /**
418     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
419     * with `errorMessage` as a fallback revert reason when `target` reverts.
420     *
421     * _Available since v3.1._
422     */
423     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
424         require(address(this).balance >= value, "Address: insufficient balance for call");
425         require(isContract(target), "Address: call to non-contract");
426 
427         // solhint-disable-next-line avoid-low-level-calls
428         (bool success, bytes memory returndata) = target.call{ value: value }(data);
429         return _verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434     * but performing a static call.
435     *
436     * _Available since v3.3._
437     */
438     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
439         return functionStaticCall(target, data, "Address: low-level static call failed");
440     }
441 
442     /**
443     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444     * but performing a static call.
445     *
446     * _Available since v3.3._
447     */
448     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
449         require(isContract(target), "Address: static call to non-contract");
450 
451         // solhint-disable-next-line avoid-low-level-calls
452         (bool success, bytes memory returndata) = target.staticcall(data);
453         return _verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458     * but performing a delegate call.
459     *
460     * _Available since v3.4._
461     */
462     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
463         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
464     }
465 
466     /**
467     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468     * but performing a delegate call.
469     *
470     * _Available since v3.4._
471     */
472     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
473         require(isContract(target), "Address: delegate call to non-contract");
474 
475         // solhint-disable-next-line avoid-low-level-calls
476         (bool success, bytes memory returndata) = target.delegatecall(data);
477         return _verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
481         if (success) {
482             return returndata;
483         } else {
484             // Look for revert reason and bubble it up if present
485             if (returndata.length > 0) {
486                 // The easiest way to bubble the revert reason is using memory via assembly
487 
488                 // solhint-disable-next-line no-inline-assembly
489                 assembly {
490                     let returndata_size := mload(returndata)
491                     revert(add(32, returndata), returndata_size)
492                 }
493             } else {
494                 revert(errorMessage);
495             }
496         }
497     }
498 }
499 
500 /**
501  * @dev Contract module which provides a basic access control mechanism, where
502  * there is an account (an owner) that can be granted exclusive access to
503  * specific functions.
504  *
505  * By default, the owner account will be the one that deploys the contract. This
506  * can later be changed with {transferOwnership}.
507  *
508  * This module is used through inheritance. It will make available the modifier
509  * `onlyOwner`, which can be applied to your functions to restrict their use to
510  * the owner.
511  */
512 abstract contract Ownable is Context {
513     address private _owner;
514 
515     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
516 
517     /**
518     * @dev Initializes the contract setting the deployer as the initial owner.
519     */
520     constructor () {
521         _owner = _msgSender();
522         emit OwnershipTransferred(address(0), _owner);
523     }
524 
525     /**
526     * @dev Returns the address of the current owner.
527     */
528     function owner() public view virtual returns (address) {
529         return _owner;
530     }
531 
532     /**
533     * @dev Throws if called by any account other than the owner.
534     */
535     modifier onlyOwner() {
536         require(owner() == _msgSender(), "Ownable: caller is not the owner");
537         _;
538     }
539 
540     /**
541     * @dev Leaves the contract without owner. It will not be possible to call
542     * `onlyOwner` functions anymore. Can only be called by the current owner.
543     *
544     * NOTE: Renouncing ownership will leave the contract without an owner,
545     * thereby removing any functionality that is only available to the owner.
546     */
547     function renounceOwnership() public virtual onlyOwner {
548         emit OwnershipTransferred(_owner, address(0));
549         _owner = address(0);
550     }
551 
552     /**
553     * @dev Transfers ownership of the contract to a new account (`newOwner`).
554     * Can only be called by the current owner.
555     */
556     function transferOwnership(address newOwner) public virtual onlyOwner {
557         require(newOwner != address(0), "Ownable: new owner is the zero address");
558         emit OwnershipTransferred(_owner, newOwner);
559         _owner = newOwner;
560     }
561 }
562 
563 interface IUniswapV2Factory {
564     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
565 
566     function feeTo() external view returns (address);
567     function feeToSetter() external view returns (address);
568 
569     function getPair(address tokenA, address tokenB) external view returns (address pair);
570     function allPairs(uint) external view returns (address pair);
571     function allPairsLength() external view returns (uint);
572 
573     function createPair(address tokenA, address tokenB) external returns (address pair);
574 
575     function setFeeTo(address) external;
576     function setFeeToSetter(address) external;
577 }
578 
579 interface IUniswapV2Pair {
580     event Approval(address indexed owner, address indexed spender, uint value);
581     event Transfer(address indexed from, address indexed to, uint value);
582 
583     function name() external pure returns (string memory);
584     function symbol() external pure returns (string memory);
585     function decimals() external pure returns (uint8);
586     function totalSupply() external view returns (uint);
587     function balanceOf(address owner) external view returns (uint);
588     function allowance(address owner, address spender) external view returns (uint);
589 
590     function approve(address spender, uint value) external returns (bool);
591     function transfer(address to, uint value) external returns (bool);
592     function transferFrom(address from, address to, uint value) external returns (bool);
593 
594     function DOMAIN_SEPARATOR() external view returns (bytes32);
595     function PERMIT_TYPEHASH() external pure returns (bytes32);
596     function nonces(address owner) external view returns (uint);
597 
598     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
599 
600     event Mint(address indexed sender, uint amount0, uint amount1);
601     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
602     event Swap(
603         address indexed sender,
604         uint amount0In,
605         uint amount1In,
606         uint amount0Out,
607         uint amount1Out,
608         address indexed to
609     );
610     event Sync(uint112 reserve0, uint112 reserve1);
611 
612     function MINIMUM_LIQUIDITY() external pure returns (uint);
613     function factory() external view returns (address);
614     function token0() external view returns (address);
615     function token1() external view returns (address);
616     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
617     function price0CumulativeLast() external view returns (uint);
618     function price1CumulativeLast() external view returns (uint);
619     function kLast() external view returns (uint);
620 
621     function mint(address to) external returns (uint liquidity);
622     function burn(address to) external returns (uint amount0, uint amount1);
623     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
624     function skim(address to) external;
625     function sync() external;
626 
627     function initialize(address, address) external;
628 }
629 
630 interface IUniswapV2Router01 {
631     function factory() external pure returns (address);
632     function WETH() external pure returns (address);
633 
634     function addLiquidity(
635         address tokenA,
636         address tokenB,
637         uint amountADesired,
638         uint amountBDesired,
639         uint amountAMin,
640         uint amountBMin,
641         address to,
642         uint deadline
643     ) external returns (uint amountA, uint amountB, uint liquidity);
644     function addLiquidityETH(
645         address token,
646         uint amountTokenDesired,
647         uint amountTokenMin,
648         uint amountETHMin,
649         address to,
650         uint deadline
651     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
652     function removeLiquidity(
653         address tokenA,
654         address tokenB,
655         uint liquidity,
656         uint amountAMin,
657         uint amountBMin,
658         address to,
659         uint deadline
660     ) external returns (uint amountA, uint amountB);
661     function removeLiquidityETH(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline
668     ) external returns (uint amountToken, uint amountETH);
669     function removeLiquidityWithPermit(
670         address tokenA,
671         address tokenB,
672         uint liquidity,
673         uint amountAMin,
674         uint amountBMin,
675         address to,
676         uint deadline,
677         bool approveMax, uint8 v, bytes32 r, bytes32 s
678     ) external returns (uint amountA, uint amountB);
679     function removeLiquidityETHWithPermit(
680         address token,
681         uint liquidity,
682         uint amountTokenMin,
683         uint amountETHMin,
684         address to,
685         uint deadline,
686         bool approveMax, uint8 v, bytes32 r, bytes32 s
687     ) external returns (uint amountToken, uint amountETH);
688     function swapExactTokensForTokens(
689         uint amountIn,
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external returns (uint[] memory amounts);
695     function swapTokensForExactTokens(
696         uint amountOut,
697         uint amountInMax,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external returns (uint[] memory amounts);
702     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
703         external
704         payable
705         returns (uint[] memory amounts);
706     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
707         external
708         returns (uint[] memory amounts);
709     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
710         external
711         returns (uint[] memory amounts);
712     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
713         external
714         payable
715         returns (uint[] memory amounts);
716 
717     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
718     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
719     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
720     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
721     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
722 }
723 
724 interface IUniswapV2Router02 is IUniswapV2Router01 {
725     function removeLiquidityETHSupportingFeeOnTransferTokens(
726         address token,
727         uint liquidity,
728         uint amountTokenMin,
729         uint amountETHMin,
730         address to,
731         uint deadline
732     ) external returns (uint amountETH);
733     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
734         address token,
735         uint liquidity,
736         uint amountTokenMin,
737         uint amountETHMin,
738         address to,
739         uint deadline,
740         bool approveMax, uint8 v, bytes32 r, bytes32 s
741     ) external returns (uint amountETH);
742 
743     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
744         uint amountIn,
745         uint amountOutMin,
746         address[] calldata path,
747         address to,
748         uint deadline
749     ) external;
750     function swapExactETHForTokensSupportingFeeOnTransferTokens(
751         uint amountOutMin,
752         address[] calldata path,
753         address to,
754         uint deadline
755     ) external payable;
756     function swapExactTokensForETHSupportingFeeOnTransferTokens(
757         uint amountIn,
758         uint amountOutMin,
759         address[] calldata path,
760         address to,
761         uint deadline
762     ) external;
763 }
764 
765 // contract implementation
766 contract PUFA is Context, IERC20, Ownable {
767     using SafeMath for uint256;
768     using Address for address;
769 
770     uint8 private _decimals = 9;
771 
772     // 
773     string private _name = "Platform for Underpaid Female Athletes";
774     string private _symbol = "PUFA";
775     uint256 private _tTotal = 1000 * 10**9 * 10**uint256(_decimals);
776 
777     //
778     uint256 public defaultTaxFee = 0;
779     uint256 public _taxFee = defaultTaxFee;
780     uint256 private _previousTaxFee = _taxFee;
781 
782     //
783     uint256 public defaultMarketingFee = 10;
784     uint256 public _marketingFee = defaultMarketingFee;
785     uint256 private _previousMarketingFee = _marketingFee;
786 
787     uint256 public _marketingFee4Sellers = 12;
788 
789     bool public feesOnSellersAndBuyers = true;
790 
791     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
792     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
793     address payable public marketingWallet = payable(0x1779376cFE6F8f7EBD5a8E1dd56D4F98C0b625A3);
794 
795     //
796 
797     mapping (address => uint256) private _rOwned;
798     mapping (address => uint256) private _tOwned;
799     mapping (address => mapping (address => uint256)) private _allowances;
800 
801     mapping (address => bool) private _isExcludedFromFee;
802 
803     mapping (address => bool) private _isExcluded;
804 
805     address[] private _excluded;
806     uint256 private constant MAX = ~uint256(0);
807 
808     uint256 private _tFeeTotal;
809     uint256 private _rTotal = (MAX - (MAX % _tTotal));
810 
811     IUniswapV2Router02 public immutable uniswapV2Router;
812     address public immutable uniswapV2Pair;
813 
814     bool inSwapAndSend;
815     bool public SwapAndSendEnabled = true;
816 
817     event SwapAndSendEnabledUpdated(bool enabled);
818 
819     modifier lockTheSwap {
820         inSwapAndSend = true;
821         _;
822         inSwapAndSend = false;
823     }
824 
825     constructor () {
826         _rOwned[_msgSender()] = _rTotal;
827 
828         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);
829          // Create a uniswap pair for this new token
830         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
831             .createPair(address(this), _uniswapV2Router.WETH());
832 
833         // set the rest of the contract variables
834         uniswapV2Router = _uniswapV2Router;
835 
836         //exclude owner and this contract from fee
837         _isExcludedFromFee[owner()] = true;
838         _isExcludedFromFee[address(this)] = true;
839 
840         emit Transfer(address(0), _msgSender(), _tTotal);
841     }
842 
843     function name() public view returns (string memory) {
844         return _name;
845     }
846 
847     function symbol() public view returns (string memory) {
848         return _symbol;
849     }
850 
851     function decimals() public view returns (uint8) {
852         return _decimals;
853     }
854 
855     function totalSupply() public view override returns (uint256) {
856         return _tTotal;
857     }
858 
859     function balanceOf(address account) public view override returns (uint256) {
860         if (_isExcluded[account]) return _tOwned[account];
861         return tokenFromReflection(_rOwned[account]);
862     }
863 
864     function transfer(address recipient, uint256 amount) public override returns (bool) {
865         _transfer(_msgSender(), recipient, amount);
866         return true;
867     }
868 
869     function allowance(address owner, address spender) public view override returns (uint256) {
870         return _allowances[owner][spender];
871     }
872 
873     function approve(address spender, uint256 amount) public override returns (bool) {
874         _approve(_msgSender(), spender, amount);
875         return true;
876     }
877 
878     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
879         _transfer(sender, recipient, amount);
880         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
881         return true;
882     }
883 
884     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
885         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
886         return true;
887     }
888 
889     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
890         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
891         return true;
892     }
893 
894     function isExcludedFromReward(address account) public view returns (bool) {
895         return _isExcluded[account];
896     }
897 
898     function totalFees() public view returns (uint256) {
899         return _tFeeTotal;
900     }
901 
902     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
903         require(tAmount <= _tTotal, "Amount must be less than supply");
904         if (!deductTransferFee) {
905             (uint256 rAmount,,,,,) = _getValues(tAmount);
906             return rAmount;
907         } else {
908             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
909             return rTransferAmount;
910         }
911     }
912 
913     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
914         require(rAmount <= _rTotal, "Amount must be less than total reflections");
915         uint256 currentRate =  _getRate();
916         return rAmount.div(currentRate);
917     }
918 
919     function excludeFromReward(address account) public onlyOwner() {
920         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
921         require(!_isExcluded[account], "Account is already excluded");
922         if(_rOwned[account] > 0) {
923             _tOwned[account] = tokenFromReflection(_rOwned[account]);
924         }
925         _isExcluded[account] = true;
926         _excluded.push(account);
927     }
928 
929     function includeInReward(address account) external onlyOwner() {
930         require(_isExcluded[account], "Account is already excluded");
931         for (uint256 i = 0; i < _excluded.length; i++) {
932             if (_excluded[i] == account) {
933                 _excluded[i] = _excluded[_excluded.length - 1];
934                 _tOwned[account] = 0;
935                 _isExcluded[account] = false;
936                 _excluded.pop();
937                 break;
938             }
939         }
940     }
941 
942     function excludeFromFee(address account) public onlyOwner() {
943         _isExcludedFromFee[account] = true;
944     }
945 
946     function includeInFee(address account) public onlyOwner() {
947         _isExcludedFromFee[account] = false;
948     }
949 
950     function removeAllFee() private {
951         if(_taxFee == 0 && _marketingFee == 0) return;
952 
953         _previousTaxFee = _taxFee;
954         _previousMarketingFee = _marketingFee;
955 
956         _taxFee = 0;
957         _marketingFee = 0;
958     }
959 
960     function restoreAllFee() private {
961         _taxFee = _previousTaxFee;
962         _marketingFee = _previousMarketingFee;
963     }
964 
965     //to recieve ETH
966     receive() external payable {}
967 
968     function _reflectFee(uint256 rFee, uint256 tFee) private {
969         _rTotal = _rTotal.sub(rFee);
970         _tFeeTotal = _tFeeTotal.add(tFee);
971     }
972 
973     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
974         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
975         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
976         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
977     }
978 
979     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
980         uint256 tFee = calculateTaxFee(tAmount);
981         uint256 tMarketing = calculateMarketingFee(tAmount);
982         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
983         return (tTransferAmount, tFee, tMarketing);
984     }
985 
986     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
987         uint256 rAmount = tAmount.mul(currentRate);
988         uint256 rFee = tFee.mul(currentRate);
989         uint256 rMarketing = tMarketing.mul(currentRate);
990         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
991         return (rAmount, rTransferAmount, rFee);
992     }
993 
994     function _getRate() private view returns(uint256) {
995         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
996         return rSupply.div(tSupply);
997     }
998 
999     function _getCurrentSupply() private view returns(uint256, uint256) {
1000         uint256 rSupply = _rTotal;
1001         uint256 tSupply = _tTotal;
1002         for (uint256 i = 0; i < _excluded.length; i++) {
1003             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1004             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1005             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1006         }
1007         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1008         return (rSupply, tSupply);
1009     }
1010 
1011     function _takeMarketing(uint256 tMarketing) private {
1012         uint256 currentRate =  _getRate();
1013         uint256 rMarketing = tMarketing.mul(currentRate);
1014         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1015         if(_isExcluded[address(this)])
1016             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1017     }
1018 
1019     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1020         return _amount.mul(_taxFee).div(
1021             10**2
1022         );
1023     }
1024 
1025     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1026         return _amount.mul(_marketingFee).div(
1027             10**2
1028         );
1029     }
1030 
1031     function isExcludedFromFee(address account) public view returns(bool) {
1032         return _isExcludedFromFee[account];
1033     }
1034 
1035     function _approve(address owner, address spender, uint256 amount) private {
1036         require(owner != address(0), "ERC20: approve from the zero address");
1037         require(spender != address(0), "ERC20: approve to the zero address");
1038 
1039         _allowances[owner][spender] = amount;
1040         emit Approval(owner, spender, amount);
1041     }
1042 
1043     function _transfer(
1044         address from,
1045         address to,
1046         uint256 amount
1047     ) private {
1048         require(from != address(0), "ERC20: transfer from the zero address");
1049         require(to != address(0), "ERC20: transfer to the zero address");
1050         require(amount > 0, "Transfer amount must be greater than zero");
1051 
1052         if(from != owner() && to != owner())
1053             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1054 
1055         // is the token balance of this contract address over the min number of
1056         // tokens that we need to initiate a swap + send lock?
1057         // also, don't get caught in a circular sending event.
1058         // also, don't swap & liquify if sender is uniswap pair.
1059         uint256 contractTokenBalance = balanceOf(address(this));
1060         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1061 
1062         if(contractTokenBalance >= _maxTxAmount)
1063         {
1064             contractTokenBalance = _maxTxAmount;
1065         }
1066 
1067         if (
1068             overMinTokenBalance &&
1069             !inSwapAndSend &&
1070             from != uniswapV2Pair &&
1071             SwapAndSendEnabled
1072         ) {
1073             SwapAndSend(contractTokenBalance);
1074         }
1075 
1076         if(feesOnSellersAndBuyers) {
1077             setFees(to);
1078         }
1079 
1080         //indicates if fee should be deducted from transfer
1081         bool takeFee = true;
1082 
1083         //if any account belongs to _isExcludedFromFee account then remove the fee
1084         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1085             takeFee = false;
1086         }
1087 
1088         _tokenTransfer(from,to,amount,takeFee);
1089     }
1090 
1091     function setFees(address recipient) private {
1092         _taxFee = defaultTaxFee;
1093         _marketingFee = defaultMarketingFee;
1094         if (recipient == uniswapV2Pair) { // sell
1095             _marketingFee = _marketingFee4Sellers;
1096         }
1097     }
1098 
1099     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1100         // generate the uniswap pair path of token -> weth
1101         address[] memory path = new address[](2);
1102         path[0] = address(this);
1103         path[1] = uniswapV2Router.WETH();
1104 
1105         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1106 
1107         // make the swap
1108         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1109             contractTokenBalance,
1110             0, // accept any amount of ETH
1111             path,
1112             address(this),
1113             block.timestamp
1114         );
1115 
1116         uint256 contractETHBalance = address(this).balance;
1117         if(contractETHBalance > 0) {
1118             marketingWallet.transfer(contractETHBalance);
1119         }
1120     }
1121 
1122     //this method is responsible for taking all fee, if takeFee is true
1123     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1124         if(!takeFee)
1125             removeAllFee();
1126 
1127         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1128             _transferFromExcluded(sender, recipient, amount);
1129         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1130             _transferToExcluded(sender, recipient, amount);
1131         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1132             _transferStandard(sender, recipient, amount);
1133         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1134             _transferBothExcluded(sender, recipient, amount);
1135         } else {
1136             _transferStandard(sender, recipient, amount);
1137         }
1138 
1139         if(!takeFee)
1140             restoreAllFee();
1141     }
1142 
1143     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1144         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1145         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1146         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1147         _takeMarketing(tMarketing);
1148         _reflectFee(rFee, tFee);
1149         emit Transfer(sender, recipient, tTransferAmount);
1150     }
1151 
1152     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1153         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1154         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1155         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1156         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1157         _takeMarketing(tMarketing);
1158         _reflectFee(rFee, tFee);
1159         emit Transfer(sender, recipient, tTransferAmount);
1160     }
1161 
1162     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1163         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1164         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1165         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1166         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1167         _takeMarketing(tMarketing);
1168         _reflectFee(rFee, tFee);
1169         emit Transfer(sender, recipient, tTransferAmount);
1170     }
1171 
1172     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1173         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1174         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1175         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1176         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1177         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1178         _takeMarketing(tMarketing);
1179         _reflectFee(rFee, tFee);
1180         emit Transfer(sender, recipient, tTransferAmount);
1181     }
1182 
1183     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1184         defaultMarketingFee = marketingFee;
1185     }
1186 
1187     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1188         _marketingFee4Sellers = marketingFee4Sellers;
1189     }
1190 
1191     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1192         feesOnSellersAndBuyers = _enabled;
1193     }
1194 
1195     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1196         SwapAndSendEnabled = _enabled;
1197         emit SwapAndSendEnabledUpdated(_enabled);
1198     }
1199 
1200     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1201         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1202     }
1203 
1204     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1205         marketingWallet = wallet;
1206     }
1207 
1208     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1209         _maxTxAmount = maxTxAmount;
1210     }
1211 }