1 /**
2 
3 BORED Museum - the first decentralized art museum on the blockchain
4 
5 Bringing
6 Our
7 Retrospective
8 Effects of
9 Decentralization
10 
11 Website: https://www.borednft.io/
12 Twitter: @BOREDMuseum
13 Instagram: @BOREDMuseum
14 Telegram: https://t.me/BOREDmuseum
15 
16 */
17 
18 pragma solidity ^0.8.3;
19 // SPDX-License-Identifier: Unlicensed
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26     * @dev Returns the amount of tokens in existence.
27     */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31     * @dev Returns the amount of tokens owned by `account`.
32     */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36     * @dev Moves `amount` tokens from the caller's account to `recipient`.
37     *
38     * Returns a boolean value indicating whether the operation succeeded.
39     *
40     * Emits a {Transfer} event.
41     */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45     * @dev Returns the remaining number of tokens that `spender` will be
46     * allowed to spend on behalf of `owner` through {transferFrom}. This is
47     * zero by default.
48     *
49     * This value changes when {approve} or {transferFrom} are called.
50     */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55     *
56     * Returns a boolean value indicating whether the operation succeeded.
57     *
58     * IMPORTANT: Beware that changing an allowance with this method brings the risk
59     * that someone may use both the old and the new allowance by unfortunate
60     * transaction ordering. One possible solution to mitigate this race
61     * condition is to first reduce the spender's allowance to 0 and set the
62     * desired value afterwards:
63     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64     *
65     * Emits an {Approval} event.
66     */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70     * @dev Moves `amount` tokens from `sender` to `recipient` using the
71     * allowance mechanism. `amount` is then deducted from the caller's
72     * allowance.
73     *
74     * Returns a boolean value indicating whether the operation succeeded.
75     *
76     * Emits a {Transfer} event.
77     */
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     /**
81     * @dev Emitted when `value` tokens are moved from one account (`from`) to
82     * another (`to`).
83     *
84     * Note that `value` may be zero.
85     */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90     * a call to {approve}. `value` is the new allowance.
91     */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // CAUTION
96 // This version of SafeMath should only be used with Solidity 0.8 or later,
97 // because it relies on the compiler's built in overflow checks.
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations.
101  *
102  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
103  * now has built in overflow checking.
104  */
105 library SafeMath {
106     /**
107     * @dev Returns the addition of two unsigned integers, with an overflow flag.
108     *
109     * _Available since v3.4._
110     */
111     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         unchecked {
113             uint256 c = a + b;
114             if (c < a) return (false, 0);
115             return (true, c);
116         }
117     }
118 
119     /**
120     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
121     *
122     * _Available since v3.4._
123     */
124     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         unchecked {
126             if (b > a) return (false, 0);
127             return (true, a - b);
128         }
129     }
130 
131     /**
132     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
133     *
134     * _Available since v3.4._
135     */
136     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         unchecked {
138             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139             // benefit is lost if 'b' is also tested.
140             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
141             if (a == 0) return (true, 0);
142             uint256 c = a * b;
143             if (c / a != b) return (false, 0);
144             return (true, c);
145         }
146     }
147 
148     /**
149     * @dev Returns the division of two unsigned integers, with a division by zero flag.
150     *
151     * _Available since v3.4._
152     */
153     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         unchecked {
155             if (b == 0) return (false, 0);
156             return (true, a / b);
157         }
158     }
159 
160     /**
161     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
162     *
163     * _Available since v3.4._
164     */
165     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         unchecked {
167             if (b == 0) return (false, 0);
168             return (true, a % b);
169         }
170     }
171 
172     /**
173     * @dev Returns the addition of two unsigned integers, reverting on
174     * overflow.
175     *
176     * Counterpart to Solidity's `+` operator.
177     *
178     * Requirements:
179     *
180     * - Addition cannot overflow.
181     */
182     function add(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a + b;
184     }
185 
186     /**
187     * @dev Returns the subtraction of two unsigned integers, reverting on
188     * overflow (when the result is negative).
189     *
190     * Counterpart to Solidity's `-` operator.
191     *
192     * Requirements:
193     *
194     * - Subtraction cannot overflow.
195     */
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a - b;
198     }
199 
200     /**
201     * @dev Returns the multiplication of two unsigned integers, reverting on
202     * overflow.
203     *
204     * Counterpart to Solidity's `*` operator.
205     *
206     * Requirements:
207     *
208     * - Multiplication cannot overflow.
209     */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a * b;
212     }
213 
214     /**
215     * @dev Returns the integer division of two unsigned integers, reverting on
216     * division by zero. The result is rounded towards zero.
217     *
218     * Counterpart to Solidity's `/` operator.
219     *
220     * Requirements:
221     *
222     * - The divisor cannot be zero.
223     */
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a / b;
226     }
227 
228     /**
229     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230     * reverting when dividing by zero.
231     *
232     * Counterpart to Solidity's `%` operator. This function uses a `revert`
233     * opcode (which leaves remaining gas untouched) while Solidity uses an
234     * invalid opcode to revert (consuming all remaining gas).
235     *
236     * Requirements:
237     *
238     * - The divisor cannot be zero.
239     */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a % b;
242     }
243 
244     /**
245     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
246     * overflow (when the result is negative).
247     *
248     * CAUTION: This function is deprecated because it requires allocating memory for the error
249     * message unnecessarily. For custom revert reasons use {trySub}.
250     *
251     * Counterpart to Solidity's `-` operator.
252     *
253     * Requirements:
254     *
255     * - Subtraction cannot overflow.
256     */
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         unchecked {
259             require(b <= a, errorMessage);
260             return a - b;
261         }
262     }
263 
264     /**
265     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
266     * division by zero. The result is rounded towards zero.
267     *
268     * Counterpart to Solidity's `%` operator. This function uses a `revert`
269     * opcode (which leaves remaining gas untouched) while Solidity uses an
270     * invalid opcode to revert (consuming all remaining gas).
271     *
272     * Counterpart to Solidity's `/` operator. Note: this function uses a
273     * `revert` opcode (which leaves remaining gas untouched) while Solidity
274     * uses an invalid opcode to revert (consuming all remaining gas).
275     *
276     * Requirements:
277     *
278     * - The divisor cannot be zero.
279     */
280     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         unchecked {
282             require(b > 0, errorMessage);
283             return a / b;
284         }
285     }
286 
287     /**
288     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289     * reverting with custom message when dividing by zero.
290     *
291     * CAUTION: This function is deprecated because it requires allocating memory for the error
292     * message unnecessarily. For custom revert reasons use {tryMod}.
293     *
294     * Counterpart to Solidity's `%` operator. This function uses a `revert`
295     * opcode (which leaves remaining gas untouched) while Solidity uses an
296     * invalid opcode to revert (consuming all remaining gas).
297     *
298     * Requirements:
299     *
300     * - The divisor cannot be zero.
301     */
302     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
303         unchecked {
304             require(b > 0, errorMessage);
305             return a % b;
306         }
307     }
308 }
309 
310 /*
311  * @dev Provides information about the current execution context, including the
312  * sender of the transaction and its data. While these are generally available
313  * via msg.sender and msg.data, they should not be accessed in such a direct
314  * manner, since when dealing with meta-transactions the account sending and
315  * paying for execution may not be the actual sender (as far as an application
316  * is concerned).
317  *
318  * This contract is only required for intermediate, library-like contracts.
319  */
320 abstract contract Context {
321     function _msgSender() internal view virtual returns (address) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view virtual returns (bytes calldata) {
326         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
327         return msg.data;
328     }
329 }
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336     * @dev Returns true if `account` is a contract.
337     *
338     * [IMPORTANT]
339     * ====
340     * It is unsafe to assume that an address for which this function returns
341     * false is an externally-owned account (EOA) and not a contract.
342     *
343     * Among others, `isContract` will return false for the following
344     * types of addresses:
345     *
346     *  - an externally-owned account
347     *  - a contract in construction
348     *  - an address where a contract will be created
349     *  - an address where a contract lived, but was destroyed
350     * ====
351     */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize, which returns 0 for contracts in
354         // construction, since the code is only stored at the end of the
355         // constructor execution.
356 
357         uint256 size;
358         // solhint-disable-next-line no-inline-assembly
359         assembly { size := extcodesize(account) }
360         return size > 0;
361     }
362 
363     /**
364     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
365     * `recipient`, forwarding all available gas and reverting on errors.
366     *
367     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
368     * of certain opcodes, possibly making contracts go over the 2300 gas limit
369     * imposed by `transfer`, making them unable to receive funds via
370     * `transfer`. {sendValue} removes this limitation.
371     *
372     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
373     *
374     * IMPORTANT: because control is transferred to `recipient`, care must be
375     * taken to not create reentrancy vulnerabilities. Consider using
376     * {ReentrancyGuard} or the
377     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
378     */
379     function sendValue(address payable recipient, uint256 amount) internal {
380         require(address(this).balance >= amount, "Address: insufficient balance");
381 
382         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
383         (bool success, ) = recipient.call{ value: amount }("");
384         require(success, "Address: unable to send value, recipient may have reverted");
385     }
386 
387     /**
388     * @dev Performs a Solidity function call using a low level `call`. A
389     * plain`call` is an unsafe replacement for a function call: use this
390     * function instead.
391     *
392     * If `target` reverts with a revert reason, it is bubbled up by this
393     * function (like regular Solidity function calls).
394     *
395     * Returns the raw returned data. To convert to the expected return value,
396     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
397     *
398     * Requirements:
399     *
400     * - `target` must be a contract.
401     * - calling `target` with `data` must not revert.
402     *
403     * _Available since v3.1._
404     */
405     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
406       return functionCall(target, data, "Address: low-level call failed");
407     }
408 
409     /**
410     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
411     * `errorMessage` as a fallback revert reason when `target` reverts.
412     *
413     * _Available since v3.1._
414     */
415     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, 0, errorMessage);
417     }
418 
419     /**
420     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421     * but also transferring `value` wei to `target`.
422     *
423     * Requirements:
424     *
425     * - the calling contract must have an ETH balance of at least `value`.
426     * - the called Solidity function must be `payable`.
427     *
428     * _Available since v3.1._
429     */
430     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
432     }
433 
434     /**
435     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
436     * with `errorMessage` as a fallback revert reason when `target` reverts.
437     *
438     * _Available since v3.1._
439     */
440     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
441         require(address(this).balance >= value, "Address: insufficient balance for call");
442         require(isContract(target), "Address: call to non-contract");
443 
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.call{ value: value }(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451     * but performing a static call.
452     *
453     * _Available since v3.3._
454     */
455     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
456         return functionStaticCall(target, data, "Address: low-level static call failed");
457     }
458 
459     /**
460     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461     * but performing a static call.
462     *
463     * _Available since v3.3._
464     */
465     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         // solhint-disable-next-line avoid-low-level-calls
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return _verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475     * but performing a delegate call.
476     *
477     * _Available since v3.4._
478     */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485     * but performing a delegate call.
486     *
487     * _Available since v3.4._
488     */
489     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         // solhint-disable-next-line avoid-low-level-calls
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return _verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
498         if (success) {
499             return returndata;
500         } else {
501             // Look for revert reason and bubble it up if present
502             if (returndata.length > 0) {
503                 // The easiest way to bubble the revert reason is using memory via assembly
504 
505                 // solhint-disable-next-line no-inline-assembly
506                 assembly {
507                     let returndata_size := mload(returndata)
508                     revert(add(32, returndata), returndata_size)
509                 }
510             } else {
511                 revert(errorMessage);
512             }
513         }
514     }
515 }
516 
517 /**
518  * @dev Contract module which provides a basic access control mechanism, where
519  * there is an account (an owner) that can be granted exclusive access to
520  * specific functions.
521  *
522  * By default, the owner account will be the one that deploys the contract. This
523  * can later be changed with {transferOwnership}.
524  *
525  * This module is used through inheritance. It will make available the modifier
526  * `onlyOwner`, which can be applied to your functions to restrict their use to
527  * the owner.
528  */
529 abstract contract Ownable is Context {
530     address private _owner;
531 
532     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
533 
534     /**
535     * @dev Initializes the contract setting the deployer as the initial owner.
536     */
537     constructor () {
538         _owner = _msgSender();
539         emit OwnershipTransferred(address(0), _owner);
540     }
541 
542     /**
543     * @dev Returns the address of the current owner.
544     */
545     function owner() public view virtual returns (address) {
546         return _owner;
547     }
548 
549     /**
550     * @dev Throws if called by any account other than the owner.
551     */
552     modifier onlyOwner() {
553         require(owner() == _msgSender(), "Ownable: caller is not the owner");
554         _;
555     }
556 
557     /**
558     * @dev Leaves the contract without owner. It will not be possible to call
559     * `onlyOwner` functions anymore. Can only be called by the current owner.
560     *
561     * NOTE: Renouncing ownership will leave the contract without an owner,
562     * thereby removing any functionality that is only available to the owner.
563     */
564     function renounceOwnership() public virtual onlyOwner {
565         emit OwnershipTransferred(_owner, address(0));
566         _owner = address(0);
567     }
568 
569     /**
570     * @dev Transfers ownership of the contract to a new account (`newOwner`).
571     * Can only be called by the current owner.
572     */
573     function transferOwnership(address newOwner) public virtual onlyOwner {
574         require(newOwner != address(0), "Ownable: new owner is the zero address");
575         emit OwnershipTransferred(_owner, newOwner);
576         _owner = newOwner;
577     }
578 }
579 
580 interface IUniswapV2Factory {
581     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
582 
583     function feeTo() external view returns (address);
584     function feeToSetter() external view returns (address);
585 
586     function getPair(address tokenA, address tokenB) external view returns (address pair);
587     function allPairs(uint) external view returns (address pair);
588     function allPairsLength() external view returns (uint);
589 
590     function createPair(address tokenA, address tokenB) external returns (address pair);
591 
592     function setFeeTo(address) external;
593     function setFeeToSetter(address) external;
594 }
595 
596 interface IUniswapV2Pair {
597     event Approval(address indexed owner, address indexed spender, uint value);
598     event Transfer(address indexed from, address indexed to, uint value);
599 
600     function name() external pure returns (string memory);
601     function symbol() external pure returns (string memory);
602     function decimals() external pure returns (uint8);
603     function totalSupply() external view returns (uint);
604     function balanceOf(address owner) external view returns (uint);
605     function allowance(address owner, address spender) external view returns (uint);
606 
607     function approve(address spender, uint value) external returns (bool);
608     function transfer(address to, uint value) external returns (bool);
609     function transferFrom(address from, address to, uint value) external returns (bool);
610 
611     function DOMAIN_SEPARATOR() external view returns (bytes32);
612     function PERMIT_TYPEHASH() external pure returns (bytes32);
613     function nonces(address owner) external view returns (uint);
614 
615     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
616 
617     event Mint(address indexed sender, uint amount0, uint amount1);
618     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
619     event Swap(
620         address indexed sender,
621         uint amount0In,
622         uint amount1In,
623         uint amount0Out,
624         uint amount1Out,
625         address indexed to
626     );
627     event Sync(uint112 reserve0, uint112 reserve1);
628 
629     function MINIMUM_LIQUIDITY() external pure returns (uint);
630     function factory() external view returns (address);
631     function token0() external view returns (address);
632     function token1() external view returns (address);
633     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
634     function price0CumulativeLast() external view returns (uint);
635     function price1CumulativeLast() external view returns (uint);
636     function kLast() external view returns (uint);
637 
638     function mint(address to) external returns (uint liquidity);
639     function burn(address to) external returns (uint amount0, uint amount1);
640     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
641     function skim(address to) external;
642     function sync() external;
643 
644     function initialize(address, address) external;
645 }
646 
647 interface IUniswapV2Router01 {
648     function factory() external pure returns (address);
649     function WETH() external pure returns (address);
650 
651     function addLiquidity(
652         address tokenA,
653         address tokenB,
654         uint amountADesired,
655         uint amountBDesired,
656         uint amountAMin,
657         uint amountBMin,
658         address to,
659         uint deadline
660     ) external returns (uint amountA, uint amountB, uint liquidity);
661     function addLiquidityETH(
662         address token,
663         uint amountTokenDesired,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline
668     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
669     function removeLiquidity(
670         address tokenA,
671         address tokenB,
672         uint liquidity,
673         uint amountAMin,
674         uint amountBMin,
675         address to,
676         uint deadline
677     ) external returns (uint amountA, uint amountB);
678     function removeLiquidityETH(
679         address token,
680         uint liquidity,
681         uint amountTokenMin,
682         uint amountETHMin,
683         address to,
684         uint deadline
685     ) external returns (uint amountToken, uint amountETH);
686     function removeLiquidityWithPermit(
687         address tokenA,
688         address tokenB,
689         uint liquidity,
690         uint amountAMin,
691         uint amountBMin,
692         address to,
693         uint deadline,
694         bool approveMax, uint8 v, bytes32 r, bytes32 s
695     ) external returns (uint amountA, uint amountB);
696     function removeLiquidityETHWithPermit(
697         address token,
698         uint liquidity,
699         uint amountTokenMin,
700         uint amountETHMin,
701         address to,
702         uint deadline,
703         bool approveMax, uint8 v, bytes32 r, bytes32 s
704     ) external returns (uint amountToken, uint amountETH);
705     function swapExactTokensForTokens(
706         uint amountIn,
707         uint amountOutMin,
708         address[] calldata path,
709         address to,
710         uint deadline
711     ) external returns (uint[] memory amounts);
712     function swapTokensForExactTokens(
713         uint amountOut,
714         uint amountInMax,
715         address[] calldata path,
716         address to,
717         uint deadline
718     ) external returns (uint[] memory amounts);
719     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
720         external
721         payable
722         returns (uint[] memory amounts);
723     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
724         external
725         returns (uint[] memory amounts);
726     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
727         external
728         returns (uint[] memory amounts);
729     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
730         external
731         payable
732         returns (uint[] memory amounts);
733 
734     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
735     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
736     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
737     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
738     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
739 }
740 
741 interface IUniswapV2Router02 is IUniswapV2Router01 {
742     function removeLiquidityETHSupportingFeeOnTransferTokens(
743         address token,
744         uint liquidity,
745         uint amountTokenMin,
746         uint amountETHMin,
747         address to,
748         uint deadline
749     ) external returns (uint amountETH);
750     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
751         address token,
752         uint liquidity,
753         uint amountTokenMin,
754         uint amountETHMin,
755         address to,
756         uint deadline,
757         bool approveMax, uint8 v, bytes32 r, bytes32 s
758     ) external returns (uint amountETH);
759 
760     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
761         uint amountIn,
762         uint amountOutMin,
763         address[] calldata path,
764         address to,
765         uint deadline
766     ) external;
767     function swapExactETHForTokensSupportingFeeOnTransferTokens(
768         uint amountOutMin,
769         address[] calldata path,
770         address to,
771         uint deadline
772     ) external payable;
773     function swapExactTokensForETHSupportingFeeOnTransferTokens(
774         uint amountIn,
775         uint amountOutMin,
776         address[] calldata path,
777         address to,
778         uint deadline
779     ) external;
780 }
781 
782 // contract implementation
783 contract BORED is Context, IERC20, Ownable {
784     using SafeMath for uint256;
785     using Address for address;
786 
787     uint8 private _decimals = 9;
788 
789     // 
790     string private _name = "BORED MUSEUM";                                       // name
791     string private _symbol = "BORED";                                            // symbol
792     uint256 private _tTotal = 1000 * 10**9 * 10**uint256(_decimals);
793 
794     // % to holders
795     uint256 public defaultTaxFee = 2;
796     uint256 public _taxFee = defaultTaxFee;
797     uint256 private _previousTaxFee = _taxFee;
798 
799     // % to swap & send to marketing wallet
800     uint256 public defaultMarketingFee = 6;
801     uint256 public _marketingFee = defaultMarketingFee;
802     uint256 private _previousMarketingFee = _marketingFee;
803 
804     uint256 public _marketingFee4Sellers = 8;
805 
806     bool public feesOnSellersAndBuyers = true;
807 
808     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
809     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
810     address payable public marketingWallet = payable(0x331679d5250eEcE17019A57D6D61979391A6aeB4);   // marketing
811 
812     //
813 
814     mapping (address => uint256) private _rOwned;
815     mapping (address => uint256) private _tOwned;
816     mapping (address => mapping (address => uint256)) private _allowances;
817 
818     mapping (address => bool) private _isExcludedFromFee;
819 
820     mapping (address => bool) private _isExcluded;
821 
822     address[] private _excluded;
823     uint256 private constant MAX = ~uint256(0);
824 
825     uint256 private _tFeeTotal;
826     uint256 private _rTotal = (MAX - (MAX % _tTotal));
827 
828     IUniswapV2Router02 public immutable uniswapV2Router;
829     address public immutable uniswapV2Pair;
830 
831     bool inSwapAndSend;
832     bool public SwapAndSendEnabled = true;
833 
834     event SwapAndSendEnabledUpdated(bool enabled);
835 
836     modifier lockTheSwap {
837         inSwapAndSend = true;
838         _;
839         inSwapAndSend = false;
840     }
841 
842     constructor () {
843         _rOwned[_msgSender()] = _rTotal;
844 
845         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
846          // Create a uniswap pair for this new token
847         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
848             .createPair(address(this), _uniswapV2Router.WETH());
849 
850         // set the rest of the contract variables
851         uniswapV2Router = _uniswapV2Router;
852 
853         //exclude owner and this contract from fee
854         _isExcludedFromFee[owner()] = true;
855         _isExcludedFromFee[address(this)] = true;
856 
857         emit Transfer(address(0), _msgSender(), _tTotal);
858     }
859 
860     function name() public view returns (string memory) {
861         return _name;
862     }
863 
864     function symbol() public view returns (string memory) {
865         return _symbol;
866     }
867 
868     function decimals() public view returns (uint8) {
869         return _decimals;
870     }
871 
872     function totalSupply() public view override returns (uint256) {
873         return _tTotal;
874     }
875 
876     function balanceOf(address account) public view override returns (uint256) {
877         if (_isExcluded[account]) return _tOwned[account];
878         return tokenFromReflection(_rOwned[account]);
879     }
880 
881     function transfer(address recipient, uint256 amount) public override returns (bool) {
882         _transfer(_msgSender(), recipient, amount);
883         return true;
884     }
885 
886     function allowance(address owner, address spender) public view override returns (uint256) {
887         return _allowances[owner][spender];
888     }
889 
890     function approve(address spender, uint256 amount) public override returns (bool) {
891         _approve(_msgSender(), spender, amount);
892         return true;
893     }
894 
895     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
896         _transfer(sender, recipient, amount);
897         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
898         return true;
899     }
900 
901     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
902         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
903         return true;
904     }
905 
906     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
907         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
908         return true;
909     }
910 
911     function isExcludedFromReward(address account) public view returns (bool) {
912         return _isExcluded[account];
913     }
914 
915     function totalFees() public view returns (uint256) {
916         return _tFeeTotal;
917     }
918 
919     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
920         require(tAmount <= _tTotal, "Amount must be less than supply");
921         if (!deductTransferFee) {
922             (uint256 rAmount,,,,,) = _getValues(tAmount);
923             return rAmount;
924         } else {
925             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
926             return rTransferAmount;
927         }
928     }
929 
930     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
931         require(rAmount <= _rTotal, "Amount must be less than total reflections");
932         uint256 currentRate =  _getRate();
933         return rAmount.div(currentRate);
934     }
935 
936     function excludeFromReward(address account) public onlyOwner() {
937         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
938         require(!_isExcluded[account], "Account is already excluded");
939         if(_rOwned[account] > 0) {
940             _tOwned[account] = tokenFromReflection(_rOwned[account]);
941         }
942         _isExcluded[account] = true;
943         _excluded.push(account);
944     }
945 
946     function includeInReward(address account) external onlyOwner() {
947         require(_isExcluded[account], "Account is already excluded");
948         for (uint256 i = 0; i < _excluded.length; i++) {
949             if (_excluded[i] == account) {
950                 _excluded[i] = _excluded[_excluded.length - 1];
951                 _tOwned[account] = 0;
952                 _isExcluded[account] = false;
953                 _excluded.pop();
954                 break;
955             }
956         }
957     }
958 
959     function excludeFromFee(address account) public onlyOwner() {
960         _isExcludedFromFee[account] = true;
961     }
962 
963     function includeInFee(address account) public onlyOwner() {
964         _isExcludedFromFee[account] = false;
965     }
966 
967     function removeAllFee() private {
968         if(_taxFee == 0 && _marketingFee == 0) return;
969 
970         _previousTaxFee = _taxFee;
971         _previousMarketingFee = _marketingFee;
972 
973         _taxFee = 0;
974         _marketingFee = 0;
975     }
976 
977     function restoreAllFee() private {
978         _taxFee = _previousTaxFee;
979         _marketingFee = _previousMarketingFee;
980     }
981 
982     //to recieve ETH
983     receive() external payable {}
984 
985     function _reflectFee(uint256 rFee, uint256 tFee) private {
986         _rTotal = _rTotal.sub(rFee);
987         _tFeeTotal = _tFeeTotal.add(tFee);
988     }
989 
990     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
991         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
992         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
993         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
994     }
995 
996     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
997         uint256 tFee = calculateTaxFee(tAmount);
998         uint256 tMarketing = calculateMarketingFee(tAmount);
999         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
1000         return (tTransferAmount, tFee, tMarketing);
1001     }
1002 
1003     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1004         uint256 rAmount = tAmount.mul(currentRate);
1005         uint256 rFee = tFee.mul(currentRate);
1006         uint256 rMarketing = tMarketing.mul(currentRate);
1007         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
1008         return (rAmount, rTransferAmount, rFee);
1009     }
1010 
1011     function _getRate() private view returns(uint256) {
1012         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1013         return rSupply.div(tSupply);
1014     }
1015 
1016     function _getCurrentSupply() private view returns(uint256, uint256) {
1017         uint256 rSupply = _rTotal;
1018         uint256 tSupply = _tTotal;
1019         for (uint256 i = 0; i < _excluded.length; i++) {
1020             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1021             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1022             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1023         }
1024         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1025         return (rSupply, tSupply);
1026     }
1027 
1028     function _takeMarketing(uint256 tMarketing) private {
1029         uint256 currentRate =  _getRate();
1030         uint256 rMarketing = tMarketing.mul(currentRate);
1031         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1032         if(_isExcluded[address(this)])
1033             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1034     }
1035 
1036     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1037         return _amount.mul(_taxFee).div(
1038             10**2
1039         );
1040     }
1041 
1042     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1043         return _amount.mul(_marketingFee).div(
1044             10**2
1045         );
1046     }
1047 
1048     function isExcludedFromFee(address account) public view returns(bool) {
1049         return _isExcludedFromFee[account];
1050     }
1051 
1052     function _approve(address owner, address spender, uint256 amount) private {
1053         require(owner != address(0), "ERC20: approve from the zero address");
1054         require(spender != address(0), "ERC20: approve to the zero address");
1055 
1056         _allowances[owner][spender] = amount;
1057         emit Approval(owner, spender, amount);
1058     }
1059 
1060     function _transfer(
1061         address from,
1062         address to,
1063         uint256 amount
1064     ) private {
1065         require(from != address(0), "ERC20: transfer from the zero address");
1066         require(to != address(0), "ERC20: transfer to the zero address");
1067         require(amount > 0, "Transfer amount must be greater than zero");
1068 
1069         if(from != owner() && to != owner())
1070             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1071 
1072         // is the token balance of this contract address over the min number of
1073         // tokens that we need to initiate a swap + send lock?
1074         // also, don't get caught in a circular sending event.
1075         // also, don't swap & liquify if sender is uniswap pair.
1076         uint256 contractTokenBalance = balanceOf(address(this));
1077         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1078 
1079         if(contractTokenBalance >= _maxTxAmount)
1080         {
1081             contractTokenBalance = _maxTxAmount;
1082         }
1083 
1084         if (
1085             overMinTokenBalance &&
1086             !inSwapAndSend &&
1087             from != uniswapV2Pair &&
1088             SwapAndSendEnabled
1089         ) {
1090             SwapAndSend(contractTokenBalance);
1091         }
1092 
1093         if(feesOnSellersAndBuyers) {
1094             setFees(to);
1095         }
1096 
1097         //indicates if fee should be deducted from transfer
1098         bool takeFee = true;
1099 
1100         //if any account belongs to _isExcludedFromFee account then remove the fee
1101         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1102             takeFee = false;
1103         }
1104 
1105         _tokenTransfer(from,to,amount,takeFee);
1106     }
1107 
1108     function setFees(address recipient) private {
1109         _taxFee = defaultTaxFee;
1110         _marketingFee = defaultMarketingFee;
1111         if (recipient == uniswapV2Pair) { // sell
1112             _marketingFee = _marketingFee4Sellers;
1113         }
1114     }
1115 
1116     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1117         // generate the uniswap pair path of token -> weth
1118         address[] memory path = new address[](2);
1119         path[0] = address(this);
1120         path[1] = uniswapV2Router.WETH();
1121 
1122         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1123 
1124         // make the swap
1125         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1126             contractTokenBalance,
1127             0, // accept any amount of ETH
1128             path,
1129             address(this),
1130             block.timestamp
1131         );
1132 
1133         uint256 contractETHBalance = address(this).balance;
1134         if(contractETHBalance > 0) {
1135             marketingWallet.transfer(contractETHBalance);
1136         }
1137     }
1138 
1139     //this method is responsible for taking all fee, if takeFee is true
1140     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1141         if(!takeFee)
1142             removeAllFee();
1143 
1144         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1145             _transferFromExcluded(sender, recipient, amount);
1146         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1147             _transferToExcluded(sender, recipient, amount);
1148         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1149             _transferStandard(sender, recipient, amount);
1150         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1151             _transferBothExcluded(sender, recipient, amount);
1152         } else {
1153             _transferStandard(sender, recipient, amount);
1154         }
1155 
1156         if(!takeFee)
1157             restoreAllFee();
1158     }
1159 
1160     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1161         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1162         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1163         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1164         _takeMarketing(tMarketing);
1165         _reflectFee(rFee, tFee);
1166         emit Transfer(sender, recipient, tTransferAmount);
1167     }
1168 
1169     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1170         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1171         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1172         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1173         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1174         _takeMarketing(tMarketing);
1175         _reflectFee(rFee, tFee);
1176         emit Transfer(sender, recipient, tTransferAmount);
1177     }
1178 
1179     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1180         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1181         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1182         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1183         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1184         _takeMarketing(tMarketing);
1185         _reflectFee(rFee, tFee);
1186         emit Transfer(sender, recipient, tTransferAmount);
1187     }
1188 
1189     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1190         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1191         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1192         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1193         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1194         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1195         _takeMarketing(tMarketing);
1196         _reflectFee(rFee, tFee);
1197         emit Transfer(sender, recipient, tTransferAmount);
1198     }
1199 
1200     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1201         defaultMarketingFee = marketingFee;
1202     }
1203 
1204     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1205         _marketingFee4Sellers = marketingFee4Sellers;
1206     }
1207 
1208     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1209         feesOnSellersAndBuyers = _enabled;
1210     }
1211 
1212     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1213         SwapAndSendEnabled = _enabled;
1214         emit SwapAndSendEnabledUpdated(_enabled);
1215     }
1216 
1217     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1218         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1219     }
1220 
1221     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1222         marketingWallet = wallet;
1223     }
1224 
1225     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1226         _maxTxAmount = maxTxAmount;
1227     }
1228 }