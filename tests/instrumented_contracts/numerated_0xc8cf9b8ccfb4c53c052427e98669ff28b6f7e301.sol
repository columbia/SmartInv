1 /**
2 
3 ──────────────███████──███████
4 ──────────████▓▓▓▓▓▓████░░░░░██
5 ────────██▓▓▓▓▓▓▓▓▓▓▓▓██░░░░░░██
6 ──────██▓▓▓▓▓▓████████████░░░░██
7 ────██▓▓▓▓▓▓████████████████░██
8 ────██▓▓████░░░░░░░░░░░░██████
9 ──████████░░░░░░██░░██░░██▓▓▓▓██
10 ──██░░████░░░░░░██░░██░░██▓▓▓▓██
11 ██░░░░██████░░░░░░░░░░░░░░██▓▓██
12 ██░░░░░░██░░░░██░░░░░░░░░░██▓▓██
13 ──██░░░░░░░░░███████░░░░██████
14 ────████░░░░░░░███████████▓▓██
15 ──────██████░░░░░░░░░░██▓▓▓▓██
16 ────██▓▓▓▓██████████████▓▓██
17 ──██▓▓▓▓▓▓▓▓████░░░░░░████
18 ████▓▓▓▓▓▓▓▓██░░░░░░░░░░██
19 ████▓▓▓▓▓▓▓▓██░░░░░░░░░░██
20 ██████▓▓▓▓▓▓▓▓██░░░░░░████████
21 ──██████▓▓▓▓▓▓████████████████
22 ────██████████████████████▓▓▓▓██
23 ──██▓▓▓▓████████████████▓▓▓▓▓▓██
24 ████▓▓██████████████████▓▓▓▓▓▓██
25 ██▓▓▓▓██████████████████▓▓▓▓▓▓██
26 ██▓▓▓▓██████████──────██▓▓▓▓████
27 ██▓▓▓▓████──────────────██████
28 ──████
29 
30 */
31 
32 pragma solidity ^0.8.3;
33 // SPDX-License-Identifier: Unlicensed
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40     * @dev Returns the amount of tokens in existence.
41     */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45     * @dev Returns the amount of tokens owned by `account`.
46     */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50     * @dev Moves `amount` tokens from the caller's account to `recipient`.
51     *
52     * Returns a boolean value indicating whether the operation succeeded.
53     *
54     * Emits a {Transfer} event.
55     */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59     * @dev Returns the remaining number of tokens that `spender` will be
60     * allowed to spend on behalf of `owner` through {transferFrom}. This is
61     * zero by default.
62     *
63     * This value changes when {approve} or {transferFrom} are called.
64     */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69     *
70     * Returns a boolean value indicating whether the operation succeeded.
71     *
72     * IMPORTANT: Beware that changing an allowance with this method brings the risk
73     * that someone may use both the old and the new allowance by unfortunate
74     * transaction ordering. One possible solution to mitigate this race
75     * condition is to first reduce the spender's allowance to 0 and set the
76     * desired value afterwards:
77     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78     *
79     * Emits an {Approval} event.
80     */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84     * @dev Moves `amount` tokens from `sender` to `recipient` using the
85     * allowance mechanism. `amount` is then deducted from the caller's
86     * allowance.
87     *
88     * Returns a boolean value indicating whether the operation succeeded.
89     *
90     * Emits a {Transfer} event.
91     */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95     * @dev Emitted when `value` tokens are moved from one account (`from`) to
96     * another (`to`).
97     *
98     * Note that `value` may be zero.
99     */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104     * a call to {approve}. `value` is the new allowance.
105     */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // CAUTION
110 // This version of SafeMath should only be used with Solidity 0.8 or later,
111 // because it relies on the compiler's built in overflow checks.
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations.
115  *
116  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
117  * now has built in overflow checking.
118  */
119 library SafeMath {
120     /**
121     * @dev Returns the addition of two unsigned integers, with an overflow flag.
122     *
123     * _Available since v3.4._
124     */
125     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         unchecked {
127             uint256 c = a + b;
128             if (c < a) return (false, 0);
129             return (true, c);
130         }
131     }
132 
133     /**
134     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
135     *
136     * _Available since v3.4._
137     */
138     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         unchecked {
140             if (b > a) return (false, 0);
141             return (true, a - b);
142         }
143     }
144 
145     /**
146     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
147     *
148     * _Available since v3.4._
149     */
150     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153             // benefit is lost if 'b' is also tested.
154             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155             if (a == 0) return (true, 0);
156             uint256 c = a * b;
157             if (c / a != b) return (false, 0);
158             return (true, c);
159         }
160     }
161 
162     /**
163     * @dev Returns the division of two unsigned integers, with a division by zero flag.
164     *
165     * _Available since v3.4._
166     */
167     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         unchecked {
169             if (b == 0) return (false, 0);
170             return (true, a / b);
171         }
172     }
173 
174     /**
175     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176     *
177     * _Available since v3.4._
178     */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         unchecked {
181             if (b == 0) return (false, 0);
182             return (true, a % b);
183         }
184     }
185 
186     /**
187     * @dev Returns the addition of two unsigned integers, reverting on
188     * overflow.
189     *
190     * Counterpart to Solidity's `+` operator.
191     *
192     * Requirements:
193     *
194     * - Addition cannot overflow.
195     */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a + b;
198     }
199 
200     /**
201     * @dev Returns the subtraction of two unsigned integers, reverting on
202     * overflow (when the result is negative).
203     *
204     * Counterpart to Solidity's `-` operator.
205     *
206     * Requirements:
207     *
208     * - Subtraction cannot overflow.
209     */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a - b;
212     }
213 
214     /**
215     * @dev Returns the multiplication of two unsigned integers, reverting on
216     * overflow.
217     *
218     * Counterpart to Solidity's `*` operator.
219     *
220     * Requirements:
221     *
222     * - Multiplication cannot overflow.
223     */
224     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a * b;
226     }
227 
228     /**
229     * @dev Returns the integer division of two unsigned integers, reverting on
230     * division by zero. The result is rounded towards zero.
231     *
232     * Counterpart to Solidity's `/` operator.
233     *
234     * Requirements:
235     *
236     * - The divisor cannot be zero.
237     */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a / b;
240     }
241 
242     /**
243     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244     * reverting when dividing by zero.
245     *
246     * Counterpart to Solidity's `%` operator. This function uses a `revert`
247     * opcode (which leaves remaining gas untouched) while Solidity uses an
248     * invalid opcode to revert (consuming all remaining gas).
249     *
250     * Requirements:
251     *
252     * - The divisor cannot be zero.
253     */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a % b;
256     }
257 
258     /**
259     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
260     * overflow (when the result is negative).
261     *
262     * CAUTION: This function is deprecated because it requires allocating memory for the error
263     * message unnecessarily. For custom revert reasons use {trySub}.
264     *
265     * Counterpart to Solidity's `-` operator.
266     *
267     * Requirements:
268     *
269     * - Subtraction cannot overflow.
270     */
271     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         unchecked {
273             require(b <= a, errorMessage);
274             return a - b;
275         }
276     }
277 
278     /**
279     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
280     * division by zero. The result is rounded towards zero.
281     *
282     * Counterpart to Solidity's `%` operator. This function uses a `revert`
283     * opcode (which leaves remaining gas untouched) while Solidity uses an
284     * invalid opcode to revert (consuming all remaining gas).
285     *
286     * Counterpart to Solidity's `/` operator. Note: this function uses a
287     * `revert` opcode (which leaves remaining gas untouched) while Solidity
288     * uses an invalid opcode to revert (consuming all remaining gas).
289     *
290     * Requirements:
291     *
292     * - The divisor cannot be zero.
293     */
294     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         unchecked {
296             require(b > 0, errorMessage);
297             return a / b;
298         }
299     }
300 
301     /**
302     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303     * reverting with custom message when dividing by zero.
304     *
305     * CAUTION: This function is deprecated because it requires allocating memory for the error
306     * message unnecessarily. For custom revert reasons use {tryMod}.
307     *
308     * Counterpart to Solidity's `%` operator. This function uses a `revert`
309     * opcode (which leaves remaining gas untouched) while Solidity uses an
310     * invalid opcode to revert (consuming all remaining gas).
311     *
312     * Requirements:
313     *
314     * - The divisor cannot be zero.
315     */
316     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
317         unchecked {
318             require(b > 0, errorMessage);
319             return a % b;
320         }
321     }
322 }
323 
324 /*
325  * @dev Provides information about the current execution context, including the
326  * sender of the transaction and its data. While these are generally available
327  * via msg.sender and msg.data, they should not be accessed in such a direct
328  * manner, since when dealing with meta-transactions the account sending and
329  * paying for execution may not be the actual sender (as far as an application
330  * is concerned).
331  *
332  * This contract is only required for intermediate, library-like contracts.
333  */
334 abstract contract Context {
335     function _msgSender() internal view virtual returns (address) {
336         return msg.sender;
337     }
338 
339     function _msgData() internal view virtual returns (bytes calldata) {
340         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
341         return msg.data;
342     }
343 }
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350     * @dev Returns true if `account` is a contract.
351     *
352     * [IMPORTANT]
353     * ====
354     * It is unsafe to assume that an address for which this function returns
355     * false is an externally-owned account (EOA) and not a contract.
356     *
357     * Among others, `isContract` will return false for the following
358     * types of addresses:
359     *
360     *  - an externally-owned account
361     *  - a contract in construction
362     *  - an address where a contract will be created
363     *  - an address where a contract lived, but was destroyed
364     * ====
365     */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         uint256 size;
372         // solhint-disable-next-line no-inline-assembly
373         assembly { size := extcodesize(account) }
374         return size > 0;
375     }
376 
377     /**
378     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
379     * `recipient`, forwarding all available gas and reverting on errors.
380     *
381     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
382     * of certain opcodes, possibly making contracts go over the 2300 gas limit
383     * imposed by `transfer`, making them unable to receive funds via
384     * `transfer`. {sendValue} removes this limitation.
385     *
386     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
387     *
388     * IMPORTANT: because control is transferred to `recipient`, care must be
389     * taken to not create reentrancy vulnerabilities. Consider using
390     * {ReentrancyGuard} or the
391     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
392     */
393     function sendValue(address payable recipient, uint256 amount) internal {
394         require(address(this).balance >= amount, "Address: insufficient balance");
395 
396         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
397         (bool success, ) = recipient.call{ value: amount }("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402     * @dev Performs a Solidity function call using a low level `call`. A
403     * plain`call` is an unsafe replacement for a function call: use this
404     * function instead.
405     *
406     * If `target` reverts with a revert reason, it is bubbled up by this
407     * function (like regular Solidity function calls).
408     *
409     * Returns the raw returned data. To convert to the expected return value,
410     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411     *
412     * Requirements:
413     *
414     * - `target` must be a contract.
415     * - calling `target` with `data` must not revert.
416     *
417     * _Available since v3.1._
418     */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420       return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425     * `errorMessage` as a fallback revert reason when `target` reverts.
426     *
427     * _Available since v3.1._
428     */
429     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, 0, errorMessage);
431     }
432 
433     /**
434     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435     * but also transferring `value` wei to `target`.
436     *
437     * Requirements:
438     *
439     * - the calling contract must have an ETH balance of at least `value`.
440     * - the called Solidity function must be `payable`.
441     *
442     * _Available since v3.1._
443     */
444     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
445         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
446     }
447 
448     /**
449     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
450     * with `errorMessage` as a fallback revert reason when `target` reverts.
451     *
452     * _Available since v3.1._
453     */
454     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
455         require(address(this).balance >= value, "Address: insufficient balance for call");
456         require(isContract(target), "Address: call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.call{ value: value }(data);
460         return _verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465     * but performing a static call.
466     *
467     * _Available since v3.3._
468     */
469     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
470         return functionStaticCall(target, data, "Address: low-level static call failed");
471     }
472 
473     /**
474     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475     * but performing a static call.
476     *
477     * _Available since v3.3._
478     */
479     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
480         require(isContract(target), "Address: static call to non-contract");
481 
482         // solhint-disable-next-line avoid-low-level-calls
483         (bool success, bytes memory returndata) = target.staticcall(data);
484         return _verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     /**
488     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489     * but performing a delegate call.
490     *
491     * _Available since v3.4._
492     */
493     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
494         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
495     }
496 
497     /**
498     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
499     * but performing a delegate call.
500     *
501     * _Available since v3.4._
502     */
503     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
504         require(isContract(target), "Address: delegate call to non-contract");
505 
506         // solhint-disable-next-line avoid-low-level-calls
507         (bool success, bytes memory returndata) = target.delegatecall(data);
508         return _verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
512         if (success) {
513             return returndata;
514         } else {
515             // Look for revert reason and bubble it up if present
516             if (returndata.length > 0) {
517                 // The easiest way to bubble the revert reason is using memory via assembly
518 
519                 // solhint-disable-next-line no-inline-assembly
520                 assembly {
521                     let returndata_size := mload(returndata)
522                     revert(add(32, returndata), returndata_size)
523                 }
524             } else {
525                 revert(errorMessage);
526             }
527         }
528     }
529 }
530 
531 /**
532  * @dev Contract module which provides a basic access control mechanism, where
533  * there is an account (an owner) that can be granted exclusive access to
534  * specific functions.
535  *
536  * By default, the owner account will be the one that deploys the contract. This
537  * can later be changed with {transferOwnership}.
538  *
539  * This module is used through inheritance. It will make available the modifier
540  * `onlyOwner`, which can be applied to your functions to restrict their use to
541  * the owner.
542  */
543 abstract contract Ownable is Context {
544     address private _owner;
545 
546     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
547 
548     /**
549     * @dev Initializes the contract setting the deployer as the initial owner.
550     */
551     constructor () {
552         _owner = _msgSender();
553         emit OwnershipTransferred(address(0), _owner);
554     }
555 
556     /**
557     * @dev Returns the address of the current owner.
558     */
559     function owner() public view virtual returns (address) {
560         return _owner;
561     }
562 
563     /**
564     * @dev Throws if called by any account other than the owner.
565     */
566     modifier onlyOwner() {
567         require(owner() == _msgSender(), "Ownable: caller is not the owner");
568         _;
569     }
570 
571     /**
572     * @dev Leaves the contract without owner. It will not be possible to call
573     * `onlyOwner` functions anymore. Can only be called by the current owner.
574     *
575     * NOTE: Renouncing ownership will leave the contract without an owner,
576     * thereby removing any functionality that is only available to the owner.
577     */
578     function renounceOwnership() public virtual onlyOwner {
579         emit OwnershipTransferred(_owner, address(0));
580         _owner = address(0);
581     }
582 
583     /**
584     * @dev Transfers ownership of the contract to a new account (`newOwner`).
585     * Can only be called by the current owner.
586     */
587     function transferOwnership(address newOwner) public virtual onlyOwner {
588         require(newOwner != address(0), "Ownable: new owner is the zero address");
589         emit OwnershipTransferred(_owner, newOwner);
590         _owner = newOwner;
591     }
592 }
593 
594 interface IUniswapV2Factory {
595     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
596 
597     function feeTo() external view returns (address);
598     function feeToSetter() external view returns (address);
599 
600     function getPair(address tokenA, address tokenB) external view returns (address pair);
601     function allPairs(uint) external view returns (address pair);
602     function allPairsLength() external view returns (uint);
603 
604     function createPair(address tokenA, address tokenB) external returns (address pair);
605 
606     function setFeeTo(address) external;
607     function setFeeToSetter(address) external;
608 }
609 
610 interface IUniswapV2Pair {
611     event Approval(address indexed owner, address indexed spender, uint value);
612     event Transfer(address indexed from, address indexed to, uint value);
613 
614     function name() external pure returns (string memory);
615     function symbol() external pure returns (string memory);
616     function decimals() external pure returns (uint8);
617     function totalSupply() external view returns (uint);
618     function balanceOf(address owner) external view returns (uint);
619     function allowance(address owner, address spender) external view returns (uint);
620 
621     function approve(address spender, uint value) external returns (bool);
622     function transfer(address to, uint value) external returns (bool);
623     function transferFrom(address from, address to, uint value) external returns (bool);
624 
625     function DOMAIN_SEPARATOR() external view returns (bytes32);
626     function PERMIT_TYPEHASH() external pure returns (bytes32);
627     function nonces(address owner) external view returns (uint);
628 
629     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
630 
631     event Mint(address indexed sender, uint amount0, uint amount1);
632     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
633     event Swap(
634         address indexed sender,
635         uint amount0In,
636         uint amount1In,
637         uint amount0Out,
638         uint amount1Out,
639         address indexed to
640     );
641     event Sync(uint112 reserve0, uint112 reserve1);
642 
643     function MINIMUM_LIQUIDITY() external pure returns (uint);
644     function factory() external view returns (address);
645     function token0() external view returns (address);
646     function token1() external view returns (address);
647     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
648     function price0CumulativeLast() external view returns (uint);
649     function price1CumulativeLast() external view returns (uint);
650     function kLast() external view returns (uint);
651 
652     function mint(address to) external returns (uint liquidity);
653     function burn(address to) external returns (uint amount0, uint amount1);
654     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
655     function skim(address to) external;
656     function sync() external;
657 
658     function initialize(address, address) external;
659 }
660 
661 interface IUniswapV2Router01 {
662     function factory() external pure returns (address);
663     function WETH() external pure returns (address);
664 
665     function addLiquidity(
666         address tokenA,
667         address tokenB,
668         uint amountADesired,
669         uint amountBDesired,
670         uint amountAMin,
671         uint amountBMin,
672         address to,
673         uint deadline
674     ) external returns (uint amountA, uint amountB, uint liquidity);
675     function addLiquidityETH(
676         address token,
677         uint amountTokenDesired,
678         uint amountTokenMin,
679         uint amountETHMin,
680         address to,
681         uint deadline
682     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
683     function removeLiquidity(
684         address tokenA,
685         address tokenB,
686         uint liquidity,
687         uint amountAMin,
688         uint amountBMin,
689         address to,
690         uint deadline
691     ) external returns (uint amountA, uint amountB);
692     function removeLiquidityETH(
693         address token,
694         uint liquidity,
695         uint amountTokenMin,
696         uint amountETHMin,
697         address to,
698         uint deadline
699     ) external returns (uint amountToken, uint amountETH);
700     function removeLiquidityWithPermit(
701         address tokenA,
702         address tokenB,
703         uint liquidity,
704         uint amountAMin,
705         uint amountBMin,
706         address to,
707         uint deadline,
708         bool approveMax, uint8 v, bytes32 r, bytes32 s
709     ) external returns (uint amountA, uint amountB);
710     function removeLiquidityETHWithPermit(
711         address token,
712         uint liquidity,
713         uint amountTokenMin,
714         uint amountETHMin,
715         address to,
716         uint deadline,
717         bool approveMax, uint8 v, bytes32 r, bytes32 s
718     ) external returns (uint amountToken, uint amountETH);
719     function swapExactTokensForTokens(
720         uint amountIn,
721         uint amountOutMin,
722         address[] calldata path,
723         address to,
724         uint deadline
725     ) external returns (uint[] memory amounts);
726     function swapTokensForExactTokens(
727         uint amountOut,
728         uint amountInMax,
729         address[] calldata path,
730         address to,
731         uint deadline
732     ) external returns (uint[] memory amounts);
733     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
734         external
735         payable
736         returns (uint[] memory amounts);
737     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
738         external
739         returns (uint[] memory amounts);
740     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
741         external
742         returns (uint[] memory amounts);
743     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
744         external
745         payable
746         returns (uint[] memory amounts);
747 
748     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
749     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
750     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
751     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
752     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
753 }
754 
755 interface IUniswapV2Router02 is IUniswapV2Router01 {
756     function removeLiquidityETHSupportingFeeOnTransferTokens(
757         address token,
758         uint liquidity,
759         uint amountTokenMin,
760         uint amountETHMin,
761         address to,
762         uint deadline
763     ) external returns (uint amountETH);
764     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
765         address token,
766         uint liquidity,
767         uint amountTokenMin,
768         uint amountETHMin,
769         address to,
770         uint deadline,
771         bool approveMax, uint8 v, bytes32 r, bytes32 s
772     ) external returns (uint amountETH);
773 
774     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
775         uint amountIn,
776         uint amountOutMin,
777         address[] calldata path,
778         address to,
779         uint deadline
780     ) external;
781     function swapExactETHForTokensSupportingFeeOnTransferTokens(
782         uint amountOutMin,
783         address[] calldata path,
784         address to,
785         uint deadline
786     ) external payable;
787     function swapExactTokensForETHSupportingFeeOnTransferTokens(
788         uint amountIn,
789         uint amountOutMin,
790         address[] calldata path,
791         address to,
792         uint deadline
793     ) external;
794 }
795 
796 // contract implementation
797 contract MARIO is Context, IERC20, Ownable {
798     using SafeMath for uint256;
799     using Address for address;
800 
801     uint8 private _decimals = 9;
802 
803     // 
804     string private _name = "SUPER MARIO";
805     string private _symbol = "MARIO";
806     uint256 private _tTotal = 1000 * 10**9 * 10**uint256(_decimals);
807 
808     //
809     uint256 public defaultTaxFee = 0;
810     uint256 public _taxFee = defaultTaxFee;
811     uint256 private _previousTaxFee = _taxFee;
812 
813     //
814     uint256 public defaultMarketingFee = 9;
815     uint256 public _marketingFee = defaultMarketingFee;
816     uint256 private _previousMarketingFee = _marketingFee;
817 
818     uint256 public _marketingFee4Sellers = 9;
819 
820     bool public feesOnSellersAndBuyers = true;
821 
822     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
823     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
824     address payable public marketingWallet = payable(0xE4C51783cBBBF35543CdE3296b1D50f900cE2D7A);
825 
826     //
827 
828     mapping (address => uint256) private _rOwned;
829     mapping (address => uint256) private _tOwned;
830     mapping (address => mapping (address => uint256)) private _allowances;
831 
832     mapping (address => bool) private _isExcludedFromFee;
833 
834     mapping (address => bool) private _isExcluded;
835 
836     address[] private _excluded;
837     uint256 private constant MAX = ~uint256(0);
838 
839     uint256 private _tFeeTotal;
840     uint256 private _rTotal = (MAX - (MAX % _tTotal));
841 
842     IUniswapV2Router02 public immutable uniswapV2Router;
843     address public immutable uniswapV2Pair;
844 
845     bool inSwapAndSend;
846     bool public SwapAndSendEnabled = true;
847 
848     event SwapAndSendEnabledUpdated(bool enabled);
849 
850     modifier lockTheSwap {
851         inSwapAndSend = true;
852         _;
853         inSwapAndSend = false;
854     }
855 
856     constructor () {
857         _rOwned[_msgSender()] = _rTotal;
858 
859         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
860          // Create a uniswap pair for this new token
861         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
862             .createPair(address(this), _uniswapV2Router.WETH());
863 
864         // set the rest of the contract variables
865         uniswapV2Router = _uniswapV2Router;
866 
867         //exclude owner and this contract from fee
868         _isExcludedFromFee[owner()] = true;
869         _isExcludedFromFee[address(this)] = true;
870 
871         emit Transfer(address(0), _msgSender(), _tTotal);
872     }
873 
874     function name() public view returns (string memory) {
875         return _name;
876     }
877 
878     function symbol() public view returns (string memory) {
879         return _symbol;
880     }
881 
882     function decimals() public view returns (uint8) {
883         return _decimals;
884     }
885 
886     function totalSupply() public view override returns (uint256) {
887         return _tTotal;
888     }
889 
890     function balanceOf(address account) public view override returns (uint256) {
891         if (_isExcluded[account]) return _tOwned[account];
892         return tokenFromReflection(_rOwned[account]);
893     }
894 
895     function transfer(address recipient, uint256 amount) public override returns (bool) {
896         _transfer(_msgSender(), recipient, amount);
897         return true;
898     }
899 
900     function allowance(address owner, address spender) public view override returns (uint256) {
901         return _allowances[owner][spender];
902     }
903 
904     function approve(address spender, uint256 amount) public override returns (bool) {
905         _approve(_msgSender(), spender, amount);
906         return true;
907     }
908 
909     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
910         _transfer(sender, recipient, amount);
911         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
912         return true;
913     }
914 
915     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
916         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
917         return true;
918     }
919 
920     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
921         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
922         return true;
923     }
924 
925     function isExcludedFromReward(address account) public view returns (bool) {
926         return _isExcluded[account];
927     }
928 
929     function totalFees() public view returns (uint256) {
930         return _tFeeTotal;
931     }
932 
933     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
934         require(tAmount <= _tTotal, "Amount must be less than supply");
935         if (!deductTransferFee) {
936             (uint256 rAmount,,,,,) = _getValues(tAmount);
937             return rAmount;
938         } else {
939             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
940             return rTransferAmount;
941         }
942     }
943 
944     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
945         require(rAmount <= _rTotal, "Amount must be less than total reflections");
946         uint256 currentRate =  _getRate();
947         return rAmount.div(currentRate);
948     }
949 
950     function excludeFromReward(address account) public onlyOwner() {
951         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
952         require(!_isExcluded[account], "Account is already excluded");
953         if(_rOwned[account] > 0) {
954             _tOwned[account] = tokenFromReflection(_rOwned[account]);
955         }
956         _isExcluded[account] = true;
957         _excluded.push(account);
958     }
959 
960     function includeInReward(address account) external onlyOwner() {
961         require(_isExcluded[account], "Account is already excluded");
962         for (uint256 i = 0; i < _excluded.length; i++) {
963             if (_excluded[i] == account) {
964                 _excluded[i] = _excluded[_excluded.length - 1];
965                 _tOwned[account] = 0;
966                 _isExcluded[account] = false;
967                 _excluded.pop();
968                 break;
969             }
970         }
971     }
972 
973     function excludeFromFee(address account) public onlyOwner() {
974         _isExcludedFromFee[account] = true;
975     }
976 
977     function includeInFee(address account) public onlyOwner() {
978         _isExcludedFromFee[account] = false;
979     }
980 
981     function removeAllFee() private {
982         if(_taxFee == 0 && _marketingFee == 0) return;
983 
984         _previousTaxFee = _taxFee;
985         _previousMarketingFee = _marketingFee;
986 
987         _taxFee = 0;
988         _marketingFee = 0;
989     }
990 
991     function restoreAllFee() private {
992         _taxFee = _previousTaxFee;
993         _marketingFee = _previousMarketingFee;
994     }
995 
996     //to recieve ETH
997     receive() external payable {}
998 
999     function _reflectFee(uint256 rFee, uint256 tFee) private {
1000         _rTotal = _rTotal.sub(rFee);
1001         _tFeeTotal = _tFeeTotal.add(tFee);
1002     }
1003 
1004     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1005         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
1006         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
1007         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
1008     }
1009 
1010     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1011         uint256 tFee = calculateTaxFee(tAmount);
1012         uint256 tMarketing = calculateMarketingFee(tAmount);
1013         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
1014         return (tTransferAmount, tFee, tMarketing);
1015     }
1016 
1017     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1018         uint256 rAmount = tAmount.mul(currentRate);
1019         uint256 rFee = tFee.mul(currentRate);
1020         uint256 rMarketing = tMarketing.mul(currentRate);
1021         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
1022         return (rAmount, rTransferAmount, rFee);
1023     }
1024 
1025     function _getRate() private view returns(uint256) {
1026         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1027         return rSupply.div(tSupply);
1028     }
1029 
1030     function _getCurrentSupply() private view returns(uint256, uint256) {
1031         uint256 rSupply = _rTotal;
1032         uint256 tSupply = _tTotal;
1033         for (uint256 i = 0; i < _excluded.length; i++) {
1034             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1035             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1036             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1037         }
1038         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1039         return (rSupply, tSupply);
1040     }
1041 
1042     function _takeMarketing(uint256 tMarketing) private {
1043         uint256 currentRate =  _getRate();
1044         uint256 rMarketing = tMarketing.mul(currentRate);
1045         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1046         if(_isExcluded[address(this)])
1047             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1048     }
1049 
1050     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1051         return _amount.mul(_taxFee).div(
1052             10**2
1053         );
1054     }
1055 
1056     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1057         return _amount.mul(_marketingFee).div(
1058             10**2
1059         );
1060     }
1061 
1062     function isExcludedFromFee(address account) public view returns(bool) {
1063         return _isExcludedFromFee[account];
1064     }
1065 
1066     function _approve(address owner, address spender, uint256 amount) private {
1067         require(owner != address(0), "ERC20: approve from the zero address");
1068         require(spender != address(0), "ERC20: approve to the zero address");
1069 
1070         _allowances[owner][spender] = amount;
1071         emit Approval(owner, spender, amount);
1072     }
1073 
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 amount
1078     ) private {
1079         require(from != address(0), "ERC20: transfer from the zero address");
1080         require(to != address(0), "ERC20: transfer to the zero address");
1081         require(amount > 0, "Transfer amount must be greater than zero");
1082 
1083         if(from != owner() && to != owner())
1084             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1085 
1086         // is the token balance of this contract address over the min number of
1087         // tokens that we need to initiate a swap + send lock?
1088         // also, don't get caught in a circular sending event.
1089         // also, don't swap & liquify if sender is uniswap pair.
1090         uint256 contractTokenBalance = balanceOf(address(this));
1091         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1092 
1093         if(contractTokenBalance >= _maxTxAmount)
1094         {
1095             contractTokenBalance = _maxTxAmount;
1096         }
1097 
1098         if (
1099             overMinTokenBalance &&
1100             !inSwapAndSend &&
1101             from != uniswapV2Pair &&
1102             SwapAndSendEnabled
1103         ) {
1104             SwapAndSend(contractTokenBalance);
1105         }
1106 
1107         if(feesOnSellersAndBuyers) {
1108             setFees(to);
1109         }
1110 
1111         //indicates if fee should be deducted from transfer
1112         bool takeFee = true;
1113 
1114         //if any account belongs to _isExcludedFromFee account then remove the fee
1115         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1116             takeFee = false;
1117         }
1118 
1119         _tokenTransfer(from,to,amount,takeFee);
1120     }
1121 
1122     function setFees(address recipient) private {
1123         _taxFee = defaultTaxFee;
1124         _marketingFee = defaultMarketingFee;
1125         if (recipient == uniswapV2Pair) { // sell
1126             _marketingFee = _marketingFee4Sellers;
1127         }
1128     }
1129 
1130     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1131         // generate the uniswap pair path of token -> weth
1132         address[] memory path = new address[](2);
1133         path[0] = address(this);
1134         path[1] = uniswapV2Router.WETH();
1135 
1136         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1137 
1138         // make the swap
1139         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1140             contractTokenBalance,
1141             0, // accept any amount of ETH
1142             path,
1143             address(this),
1144             block.timestamp
1145         );
1146 
1147         uint256 contractETHBalance = address(this).balance;
1148         if(contractETHBalance > 0) {
1149             marketingWallet.transfer(contractETHBalance);
1150         }
1151     }
1152 
1153     //this method is responsible for taking all fee, if takeFee is true
1154     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1155         if(!takeFee)
1156             removeAllFee();
1157 
1158         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1159             _transferFromExcluded(sender, recipient, amount);
1160         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1161             _transferToExcluded(sender, recipient, amount);
1162         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1163             _transferStandard(sender, recipient, amount);
1164         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1165             _transferBothExcluded(sender, recipient, amount);
1166         } else {
1167             _transferStandard(sender, recipient, amount);
1168         }
1169 
1170         if(!takeFee)
1171             restoreAllFee();
1172     }
1173 
1174     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1175         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1176         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1177         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1178         _takeMarketing(tMarketing);
1179         _reflectFee(rFee, tFee);
1180         emit Transfer(sender, recipient, tTransferAmount);
1181     }
1182 
1183     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1184         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1185         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1186         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1187         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1188         _takeMarketing(tMarketing);
1189         _reflectFee(rFee, tFee);
1190         emit Transfer(sender, recipient, tTransferAmount);
1191     }
1192 
1193     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1194         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1195         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1196         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1197         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1198         _takeMarketing(tMarketing);
1199         _reflectFee(rFee, tFee);
1200         emit Transfer(sender, recipient, tTransferAmount);
1201     }
1202 
1203     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1204         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1205         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1206         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1207         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1208         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1209         _takeMarketing(tMarketing);
1210         _reflectFee(rFee, tFee);
1211         emit Transfer(sender, recipient, tTransferAmount);
1212     }
1213 
1214     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1215         defaultMarketingFee = marketingFee;
1216     }
1217 
1218     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1219         _marketingFee4Sellers = marketingFee4Sellers;
1220     }
1221 
1222     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1223         feesOnSellersAndBuyers = _enabled;
1224     }
1225 
1226     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1227         SwapAndSendEnabled = _enabled;
1228         emit SwapAndSendEnabledUpdated(_enabled);
1229     }
1230 
1231     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1232         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1233     }
1234 
1235     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1236         marketingWallet = wallet;
1237     }
1238 
1239     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1240         _maxTxAmount = maxTxAmount;
1241     }
1242 }