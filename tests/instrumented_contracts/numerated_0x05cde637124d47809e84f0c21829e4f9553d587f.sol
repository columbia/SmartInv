1 /*
2 
3   _____  _____            _____  ____  _   _ _               _   _ _____  
4  |  __ \|  __ \     /\   / ____|/ __ \| \ | | |        /\   | \ | |  __ \ 
5  | |  | | |__) |   /  \ | |  __| |  | |  \| | |       /  \  |  \| | |  | |
6  | |  | |  _  /   / /\ \| | |_ | |  | | . ` | |      / /\ \ | . ` | |  | |
7  | |__| | | \ \  / ____ \ |__| | |__| | |\  | |____ / ____ \| |\  | |__| |
8  |_____/|_|  \_\/_/    \_\_____|\____/|_| \_|______/_/    \_\_| \_|_____/              
9                      
10 Enter the Dragon Land Metaverse
11 
12 website - www.dragonlanderc.com
13 telegram - https://t.me/dragonlanderc
14 twitter - twitter.com/dragonlanderc
15 
16 Initial Supply:
17 - 1,000,000,000 Total Supply
18 - No Team Wallet
19 - Liquidity Locked
20 
21 Taxes:
22 - 6% Marketing
23 - 5% Development (Game and Metaverse)
24 
25 */
26 
27 pragma solidity ^0.8.3;
28 // SPDX-License-Identifier: Unlicensed
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35     * @dev Returns the amount of tokens in existence.
36     */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40     * @dev Returns the amount of tokens owned by `account`.
41     */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45     * @dev Moves `amount` tokens from the caller's account to `recipient`.
46     *
47     * Returns a boolean value indicating whether the operation succeeded.
48     *
49     * Emits a {Transfer} event.
50     */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54     * @dev Returns the remaining number of tokens that `spender` will be
55     * allowed to spend on behalf of `owner` through {transferFrom}. This is
56     * zero by default.
57     *
58     * This value changes when {approve} or {transferFrom} are called.
59     */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64     *
65     * Returns a boolean value indicating whether the operation succeeded.
66     *
67     * IMPORTANT: Beware that changing an allowance with this method brings the risk
68     * that someone may use both the old and the new allowance by unfortunate
69     * transaction ordering. One possible solution to mitigate this race
70     * condition is to first reduce the spender's allowance to 0 and set the
71     * desired value afterwards:
72     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73     *
74     * Emits an {Approval} event.
75     */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79     * @dev Moves `amount` tokens from `sender` to `recipient` using the
80     * allowance mechanism. `amount` is then deducted from the caller's
81     * allowance.
82     *
83     * Returns a boolean value indicating whether the operation succeeded.
84     *
85     * Emits a {Transfer} event.
86     */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90     * @dev Emitted when `value` tokens are moved from one account (`from`) to
91     * another (`to`).
92     *
93     * Note that `value` may be zero.
94     */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99     * a call to {approve}. `value` is the new allowance.
100     */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // CAUTION
105 // This version of SafeMath should only be used with Solidity 0.8 or later,
106 // because it relies on the compiler's built in overflow checks.
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations.
110  *
111  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
112  * now has built in overflow checking.
113  */
114 library SafeMath {
115     /**
116     * @dev Returns the addition of two unsigned integers, with an overflow flag.
117     *
118     * _Available since v3.4._
119     */
120     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         unchecked {
122             uint256 c = a + b;
123             if (c < a) return (false, 0);
124             return (true, c);
125         }
126     }
127 
128     /**
129     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
130     *
131     * _Available since v3.4._
132     */
133     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             if (b > a) return (false, 0);
136             return (true, a - b);
137         }
138     }
139 
140     /**
141     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
142     *
143     * _Available since v3.4._
144     */
145     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148             // benefit is lost if 'b' is also tested.
149             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150             if (a == 0) return (true, 0);
151             uint256 c = a * b;
152             if (c / a != b) return (false, 0);
153             return (true, c);
154         }
155     }
156 
157     /**
158     * @dev Returns the division of two unsigned integers, with a division by zero flag.
159     *
160     * _Available since v3.4._
161     */
162     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         unchecked {
164             if (b == 0) return (false, 0);
165             return (true, a / b);
166         }
167     }
168 
169     /**
170     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
171     *
172     * _Available since v3.4._
173     */
174     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         unchecked {
176             if (b == 0) return (false, 0);
177             return (true, a % b);
178         }
179     }
180 
181     /**
182     * @dev Returns the addition of two unsigned integers, reverting on
183     * overflow.
184     *
185     * Counterpart to Solidity's `+` operator.
186     *
187     * Requirements:
188     *
189     * - Addition cannot overflow.
190     */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a + b;
193     }
194 
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         return a - b;
197     }
198 
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a * b;
201     }
202 
203  
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a / b;
206     }
207 
208     /**
209     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210     * reverting when dividing by zero.
211     *
212     * Counterpart to Solidity's `%` operator. This function uses a `revert`
213     * opcode (which leaves remaining gas untouched) while Solidity uses an
214     * invalid opcode to revert (consuming all remaining gas).
215     *
216     * Requirements:
217     *
218     * - The divisor cannot be zero.
219     */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return a % b;
222     }
223 
224     /**
225     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
226     * overflow (when the result is negative).
227     *
228     * CAUTION: This function is deprecated because it requires allocating memory for the error
229     * message unnecessarily. For custom revert reasons use {trySub}.
230     *
231     * Counterpart to Solidity's `-` operator.
232     *
233     * Requirements:
234     *
235     * - Subtraction cannot overflow.
236     */
237     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         unchecked {
239             require(b <= a, errorMessage);
240             return a - b;
241         }
242     }
243 
244     /**
245     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
246     * division by zero. The result is rounded towards zero.
247     *
248     * Counterpart to Solidity's `%` operator. This function uses a `revert`
249     * opcode (which leaves remaining gas untouched) while Solidity uses an
250     * invalid opcode to revert (consuming all remaining gas).
251     *
252     * Counterpart to Solidity's `/` operator. Note: this function uses a
253     * `revert` opcode (which leaves remaining gas untouched) while Solidity
254     * uses an invalid opcode to revert (consuming all remaining gas).
255     *
256     * Requirements:
257     *
258     * - The divisor cannot be zero.
259     */
260     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         unchecked {
262             require(b > 0, errorMessage);
263             return a / b;
264         }
265     }
266 
267     /**
268     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269     * reverting with custom message when dividing by zero.
270     *
271     * CAUTION: This function is deprecated because it requires allocating memory for the error
272     * message unnecessarily. For custom revert reasons use {tryMod}.
273     *
274     * Counterpart to Solidity's `%` operator. This function uses a `revert`
275     * opcode (which leaves remaining gas untouched) while Solidity uses an
276     * invalid opcode to revert (consuming all remaining gas).
277     *
278     * Requirements:
279     *
280     * - The divisor cannot be zero.
281     */
282     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         unchecked {
284             require(b > 0, errorMessage);
285             return a % b;
286         }
287     }
288 }
289 
290 /*
291  * @dev Provides information about the current execution context, including the
292  * sender of the transaction and its data. While these are generally available
293  * via msg.sender and msg.data, they should not be accessed in such a direct
294  * manner, since when dealing with meta-transactions the account sending and
295  * paying for execution may not be the actual sender (as far as an application
296  * is concerned).
297  *
298  * This contract is only required for intermediate, library-like contracts.
299  */
300 abstract contract Context {
301     function _msgSender() internal view virtual returns (address) {
302         return msg.sender;
303     }
304 
305     function _msgData() internal view virtual returns (bytes calldata) {
306         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
307         return msg.data;
308     }
309 }
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316     * @dev Returns true if `account` is a contract.
317     *
318     * [IMPORTANT]
319     * ====
320     * It is unsafe to assume that an address for which this function returns
321     * false is an externally-owned account (EOA) and not a contract.
322     *
323     * Among others, `isContract` will return false for the following
324     * types of addresses:
325     *
326     *  - an externally-owned account
327     *  - a contract in construction
328     *  - an address where a contract will be created
329     *  - an address where a contract lived, but was destroyed
330     * ====
331     */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize, which returns 0 for contracts in
334         // construction, since the code is only stored at the end of the
335         // constructor execution.
336 
337         uint256 size;
338         // solhint-disable-next-line no-inline-assembly
339         assembly { size := extcodesize(account) }
340         return size > 0;
341     }
342 
343     /**
344     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345     * `recipient`, forwarding all available gas and reverting on errors.
346     *
347     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348     * of certain opcodes, possibly making contracts go over the 2300 gas limit
349     * imposed by `transfer`, making them unable to receive funds via
350     * `transfer`. {sendValue} removes this limitation.
351     *
352     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353     *
354     * IMPORTANT: because control is transferred to `recipient`, care must be
355     * taken to not create reentrancy vulnerabilities. Consider using
356     * {ReentrancyGuard} or the
357     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358     */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
363         (bool success, ) = recipient.call{ value: amount }("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368     * @dev Performs a Solidity function call using a low level `call`. A
369     * plain`call` is an unsafe replacement for a function call: use this
370     * function instead.
371     *
372     * If `target` reverts with a revert reason, it is bubbled up by this
373     * function (like regular Solidity function calls).
374     *
375     * Returns the raw returned data. To convert to the expected return value,
376     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377     *
378     * Requirements:
379     *
380     * - `target` must be a contract.
381     * - calling `target` with `data` must not revert.
382     *
383     * _Available since v3.1._
384     */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386       return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391     * `errorMessage` as a fallback revert reason when `target` reverts.
392     *
393     * _Available since v3.1._
394     */
395     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401     * but also transferring `value` wei to `target`.
402     *
403     * Requirements:
404     *
405     * - the calling contract must have an ETH balance of at least `value`.
406     * - the called Solidity function must be `payable`.
407     *
408     * _Available since v3.1._
409     */
410     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
412     }
413 
414     /**
415     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
416     * with `errorMessage` as a fallback revert reason when `target` reverts.
417     *
418     * _Available since v3.1._
419     */
420     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
421         require(address(this).balance >= value, "Address: insufficient balance for call");
422         require(isContract(target), "Address: call to non-contract");
423 
424         // solhint-disable-next-line avoid-low-level-calls
425         (bool success, bytes memory returndata) = target.call{ value: value }(data);
426         return _verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431     * but performing a static call.
432     *
433     * _Available since v3.3._
434     */
435     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
436         return functionStaticCall(target, data, "Address: low-level static call failed");
437     }
438 
439     /**
440     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441     * but performing a static call.
442     *
443     * _Available since v3.3._
444     */
445     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
446         require(isContract(target), "Address: static call to non-contract");
447 
448         // solhint-disable-next-line avoid-low-level-calls
449         (bool success, bytes memory returndata) = target.staticcall(data);
450         return _verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455     * but performing a delegate call.
456     *
457     * _Available since v3.4._
458     */
459     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
461     }
462 
463     /**
464     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465     * but performing a delegate call.
466     *
467     * _Available since v3.4._
468     */
469     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
470         require(isContract(target), "Address: delegate call to non-contract");
471 
472         // solhint-disable-next-line avoid-low-level-calls
473         (bool success, bytes memory returndata) = target.delegatecall(data);
474         return _verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
478         if (success) {
479             return returndata;
480         } else {
481             // Look for revert reason and bubble it up if present
482             if (returndata.length > 0) {
483                 // The easiest way to bubble the revert reason is using memory via assembly
484 
485                 // solhint-disable-next-line no-inline-assembly
486                 assembly {
487                     let returndata_size := mload(returndata)
488                     revert(add(32, returndata), returndata_size)
489                 }
490             } else {
491                 revert(errorMessage);
492             }
493         }
494     }
495 }
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 abstract contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515     * @dev Initializes the contract setting the deployer as the initial owner.
516     */
517     constructor () {
518         _owner = _msgSender();
519         emit OwnershipTransferred(address(0), _owner);
520     }
521 
522     /**
523     * @dev Returns the address of the current owner.
524     */
525     function owner() public view virtual returns (address) {
526         return _owner;
527     }
528 
529     /**
530     * @dev Throws if called by any account other than the owner.
531     */
532     modifier onlyOwner() {
533         require(owner() == _msgSender(), "Ownable: caller is not the owner");
534         _;
535     }
536 
537     /**
538     * @dev Leaves the contract without owner. It will not be possible to call
539     * `onlyOwner` functions anymore. Can only be called by the current owner.
540     *
541     * NOTE: Renouncing ownership will leave the contract without an owner,
542     * thereby removing any functionality that is only available to the owner.
543     */
544     function renounceOwnership() public virtual onlyOwner {
545         emit OwnershipTransferred(_owner, address(0));
546         _owner = address(0);
547     }
548 
549     /**
550     * @dev Transfers ownership of the contract to a new account (`newOwner`).
551     * Can only be called by the current owner.
552     */
553     function transferOwnership(address newOwner) public virtual onlyOwner {
554         require(newOwner != address(0), "Ownable: new owner is the zero address");
555         emit OwnershipTransferred(_owner, newOwner);
556         _owner = newOwner;
557     }
558 }
559 
560 interface IUniswapV2Factory {
561     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
562 
563     function feeTo() external view returns (address);
564     function feeToSetter() external view returns (address);
565 
566     function getPair(address tokenA, address tokenB) external view returns (address pair);
567     function allPairs(uint) external view returns (address pair);
568     function allPairsLength() external view returns (uint);
569 
570     function createPair(address tokenA, address tokenB) external returns (address pair);
571 
572     function setFeeTo(address) external;
573     function setFeeToSetter(address) external;
574 }
575 
576 interface IUniswapV2Pair {
577     event Approval(address indexed owner, address indexed spender, uint value);
578     event Transfer(address indexed from, address indexed to, uint value);
579 
580     function name() external pure returns (string memory);
581     function symbol() external pure returns (string memory);
582     function decimals() external pure returns (uint8);
583     function totalSupply() external view returns (uint);
584     function balanceOf(address owner) external view returns (uint);
585     function allowance(address owner, address spender) external view returns (uint);
586 
587     function approve(address spender, uint value) external returns (bool);
588     function transfer(address to, uint value) external returns (bool);
589     function transferFrom(address from, address to, uint value) external returns (bool);
590 
591     function DOMAIN_SEPARATOR() external view returns (bytes32);
592     function PERMIT_TYPEHASH() external pure returns (bytes32);
593     function nonces(address owner) external view returns (uint);
594 
595     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
596 
597     event Mint(address indexed sender, uint amount0, uint amount1);
598     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
599     event Swap(
600         address indexed sender,
601         uint amount0In,
602         uint amount1In,
603         uint amount0Out,
604         uint amount1Out,
605         address indexed to
606     );
607     event Sync(uint112 reserve0, uint112 reserve1);
608 
609     function MINIMUM_LIQUIDITY() external pure returns (uint);
610     function factory() external view returns (address);
611     function token0() external view returns (address);
612     function token1() external view returns (address);
613     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
614     function price0CumulativeLast() external view returns (uint);
615     function price1CumulativeLast() external view returns (uint);
616     function kLast() external view returns (uint);
617 
618     function mint(address to) external returns (uint liquidity);
619     function burn(address to) external returns (uint amount0, uint amount1);
620     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
621     function skim(address to) external;
622     function sync() external;
623 
624     function initialize(address, address) external;
625 }
626 
627 interface IUniswapV2Router01 {
628     function factory() external pure returns (address);
629     function WETH() external pure returns (address);
630 
631     function addLiquidity(
632         address tokenA,
633         address tokenB,
634         uint amountADesired,
635         uint amountBDesired,
636         uint amountAMin,
637         uint amountBMin,
638         address to,
639         uint deadline
640     ) external returns (uint amountA, uint amountB, uint liquidity);
641     function addLiquidityETH(
642         address token,
643         uint amountTokenDesired,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline
648     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
649     function removeLiquidity(
650         address tokenA,
651         address tokenB,
652         uint liquidity,
653         uint amountAMin,
654         uint amountBMin,
655         address to,
656         uint deadline
657     ) external returns (uint amountA, uint amountB);
658     function removeLiquidityETH(
659         address token,
660         uint liquidity,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline
665     ) external returns (uint amountToken, uint amountETH);
666     function removeLiquidityWithPermit(
667         address tokenA,
668         address tokenB,
669         uint liquidity,
670         uint amountAMin,
671         uint amountBMin,
672         address to,
673         uint deadline,
674         bool approveMax, uint8 v, bytes32 r, bytes32 s
675     ) external returns (uint amountA, uint amountB);
676     function removeLiquidityETHWithPermit(
677         address token,
678         uint liquidity,
679         uint amountTokenMin,
680         uint amountETHMin,
681         address to,
682         uint deadline,
683         bool approveMax, uint8 v, bytes32 r, bytes32 s
684     ) external returns (uint amountToken, uint amountETH);
685     function swapExactTokensForTokens(
686         uint amountIn,
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external returns (uint[] memory amounts);
692     function swapTokensForExactTokens(
693         uint amountOut,
694         uint amountInMax,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external returns (uint[] memory amounts);
699     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
700         external
701         payable
702         returns (uint[] memory amounts);
703     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
704         external
705         returns (uint[] memory amounts);
706     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
707         external
708         returns (uint[] memory amounts);
709     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
710         external
711         payable
712         returns (uint[] memory amounts);
713 
714     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
715     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
716     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
717     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
718     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
719 }
720 
721 interface IUniswapV2Router02 is IUniswapV2Router01 {
722     function removeLiquidityETHSupportingFeeOnTransferTokens(
723         address token,
724         uint liquidity,
725         uint amountTokenMin,
726         uint amountETHMin,
727         address to,
728         uint deadline
729     ) external returns (uint amountETH);
730     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
731         address token,
732         uint liquidity,
733         uint amountTokenMin,
734         uint amountETHMin,
735         address to,
736         uint deadline,
737         bool approveMax, uint8 v, bytes32 r, bytes32 s
738     ) external returns (uint amountETH);
739 
740     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
741         uint amountIn,
742         uint amountOutMin,
743         address[] calldata path,
744         address to,
745         uint deadline
746     ) external;
747     function swapExactETHForTokensSupportingFeeOnTransferTokens(
748         uint amountOutMin,
749         address[] calldata path,
750         address to,
751         uint deadline
752     ) external payable;
753     function swapExactTokensForETHSupportingFeeOnTransferTokens(
754         uint amountIn,
755         uint amountOutMin,
756         address[] calldata path,
757         address to,
758         uint deadline
759     ) external;
760 }
761 
762 
763 contract FANGS is Context, IERC20, Ownable {
764     using SafeMath for uint256;
765     using Address for address;
766 
767     uint8 private _decimals = 9;
768 
769     //
770     string private _name = "FANGS";                                           // name
771     string private _symbol = "FANGS";                                            // symbol
772     uint256 private _tTotal = 1 * 10**9 * 10**uint256(_decimals);
773 
774     // % to holders
775     uint256 public defaultTaxFee = 0;
776     uint256 public _taxFee = defaultTaxFee;
777     uint256 private _previousTaxFee = _taxFee;
778 
779     // % to swap & send to marketing wallet
780     uint256 public defaultMarketingFee = 11;
781     uint256 public _marketingFee = defaultMarketingFee;
782     uint256 private _previousMarketingFee = _marketingFee;
783 
784     uint256 public _marketingFee4Sellers = 11;
785 
786     bool public feesOnSellersAndBuyers = true;
787 
788     uint256 public _maxTxAmount = _tTotal.div(1).div(50);
789     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
790     address payable public marketingWallet = payable(0x68FA9c0Bd1a9aa177Bb12aC377440C96592965CC);
791 
792     //
793 
794     mapping (address => uint256) private _rOwned;
795     mapping (address => uint256) private _tOwned;
796     mapping (address => mapping (address => uint256)) private _allowances;
797 
798     mapping (address => bool) private _isExcludedFromFee;
799 
800     mapping (address => bool) private _isExcluded;
801    
802     mapping (address => bool) public _isBlacklisted;
803 
804     address[] private _excluded;
805     uint256 private constant MAX = ~uint256(0);
806 
807     uint256 private _tFeeTotal;
808     uint256 private _rTotal = (MAX - (MAX % _tTotal));
809 
810     IUniswapV2Router02 public immutable uniswapV2Router;
811     address public immutable uniswapV2Pair;
812 
813     bool inSwapAndSend;
814     bool public SwapAndSendEnabled = true;
815 
816     event SwapAndSendEnabledUpdated(bool enabled);
817 
818     modifier lockTheSwap {
819         inSwapAndSend = true;
820         _;
821         inSwapAndSend = false;
822     }
823 
824     constructor () {
825         _rOwned[_msgSender()] = _rTotal;
826 
827         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
828          // Create a uniswap pair for this new token
829         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
830             .createPair(address(this), _uniswapV2Router.WETH());
831 
832         // set the rest of the contract variables
833         uniswapV2Router = _uniswapV2Router;
834 
835         //exclude owner and this contract from fee
836         _isExcludedFromFee[owner()] = true;
837         _isExcludedFromFee[address(this)] = true;
838 
839         emit Transfer(address(0), _msgSender(), _tTotal);
840     }
841 
842     function name() public view returns (string memory) {
843         return _name;
844     }
845 
846     function symbol() public view returns (string memory) {
847         return _symbol;
848     }
849 
850     function decimals() public view returns (uint8) {
851         return _decimals;
852     }
853 
854     function totalSupply() public view override returns (uint256) {
855         return _tTotal;
856     }
857 
858     function balanceOf(address account) public view override returns (uint256) {
859         if (_isExcluded[account]) return _tOwned[account];
860         return tokenFromReflection(_rOwned[account]);
861     }
862 
863     function transfer(address recipient, uint256 amount) public override returns (bool) {
864         _transfer(_msgSender(), recipient, amount);
865         return true;
866     }
867 
868     function allowance(address owner, address spender) public view override returns (uint256) {
869         return _allowances[owner][spender];
870     }
871 
872     function approve(address spender, uint256 amount) public override returns (bool) {
873         _approve(_msgSender(), spender, amount);
874         return true;
875     }
876 
877     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
878         _transfer(sender, recipient, amount);
879         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
880         return true;
881     }
882 
883     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
884         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
885         return true;
886     }
887 
888     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
889         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
890         return true;
891     }
892 
893     function isExcludedFromReward(address account) public view returns (bool) {
894         return _isExcluded[account];
895     }
896 
897     function totalFees() public view returns (uint256) {
898         return _tFeeTotal;
899     }
900 
901     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
902         require(tAmount <= _tTotal, "Amount must be less than supply");
903         if (!deductTransferFee) {
904             (uint256 rAmount,,,,,) = _getValues(tAmount);
905             return rAmount;
906         } else {
907             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
908             return rTransferAmount;
909         }
910     }
911 
912     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
913         require(rAmount <= _rTotal, "Amount must be less than total reflections");
914         uint256 currentRate =  _getRate();
915         return rAmount.div(currentRate);
916     }
917 
918     function excludeFromReward(address account) public onlyOwner() {
919         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
920         require(!_isExcluded[account], "Account is already excluded");
921         if(_rOwned[account] > 0) {
922             _tOwned[account] = tokenFromReflection(_rOwned[account]);
923         }
924         _isExcluded[account] = true;
925         _excluded.push(account);
926     }
927 
928     function includeInReward(address account) external onlyOwner() {
929         require(_isExcluded[account], "Account is already excluded");
930         for (uint256 i = 0; i < _excluded.length; i++) {
931             if (_excluded[i] == account) {
932                 _excluded[i] = _excluded[_excluded.length - 1];
933                 _tOwned[account] = 0;
934                 _isExcluded[account] = false;
935                 _excluded.pop();
936                 break;
937             }
938         }
939     }
940 
941     function excludeFromFee(address account) public onlyOwner() {
942         _isExcludedFromFee[account] = true;
943     }
944 
945     function includeInFee(address account) public onlyOwner() {
946         _isExcludedFromFee[account] = false;
947     }
948 
949     function removeAllFee() private {
950         if(_taxFee == 0 && _marketingFee == 0) return;
951 
952         _previousTaxFee = _taxFee;
953         _previousMarketingFee = _marketingFee;
954 
955         _taxFee = 0;
956         _marketingFee = 0;
957     }
958 
959     function restoreAllFee() private {
960         _taxFee = _previousTaxFee;
961         _marketingFee = _previousMarketingFee;
962     }
963 
964     //to recieve ETH
965     receive() external payable {}
966 
967     function _reflectFee(uint256 rFee, uint256 tFee) private {
968         _rTotal = _rTotal.sub(rFee);
969         _tFeeTotal = _tFeeTotal.add(tFee);
970     }
971    
972      function addToBlackList(address[] calldata addresses) external onlyOwner {
973       for (uint256 i; i < addresses.length; ++i) {
974         _isBlacklisted[addresses[i]] = true;
975       }
976     }
977    
978       function removeFromBlackList(address account) external onlyOwner {
979         _isBlacklisted[account] = false;
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
1060         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted");
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
1218    
1219 
1220     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1221         _maxTxAmount = maxTxAmount;
1222     }
1223 }