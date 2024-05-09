1 /*
2 
3  _______  __   __  ___      ___      _______  _______  __   __ 
4 |  _    ||  | |  ||   |    |   |    |       ||       ||  | |  |
5 | |_|   ||  | |  ||   |    |   |    |    ___||_     _||  |_|  |
6 |       ||  |_|  ||   |    |   |    |   |___   |   |  |       |
7 |  _   | |       ||   |___ |   |___ |    ___|  |   |  |       |
8 | |_|   ||       ||       ||       ||   |___   |   |  |   _   |
9 |_______||_______||_______||_______||_______|  |___|  |__| |__
10 
11 The first NFT-based weapon skins platform. Buy, sell and collect unique NFT weapon skins, trade the Bulleth ERC-20 token and join our growing community.
12 
13 Taxes
14 - 5% Marketing
15 - 5% Development
16 - 2% Buybacks
17 - Taxes will be gradually lowered
18 - Locked Liquidity
19 
20 Useful links
21 - t.me/bulletherc
22 - www.bulleth.org
23 - twitter.com/bullethnft
24 - opensea.com/bulleth
25 
26 */
27 
28 pragma solidity ^0.8.3;
29 // SPDX-License-Identifier: Unlicensed
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36     * @dev Returns the amount of tokens in existence.
37     */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41     * @dev Returns the amount of tokens owned by `account`.
42     */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46     * @dev Moves `amount` tokens from the caller's account to `recipient`.
47     *
48     * Returns a boolean value indicating whether the operation succeeded.
49     *
50     * Emits a {Transfer} event.
51     */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55     * @dev Returns the remaining number of tokens that `spender` will be
56     * allowed to spend on behalf of `owner` through {transferFrom}. This is
57     * zero by default.
58     *
59     * This value changes when {approve} or {transferFrom} are called.
60     */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65     *
66     * Returns a boolean value indicating whether the operation succeeded.
67     *
68     * IMPORTANT: Beware that changing an allowance with this method brings the risk
69     * that someone may use both the old and the new allowance by unfortunate
70     * transaction ordering. One possible solution to mitigate this race
71     * condition is to first reduce the spender's allowance to 0 and set the
72     * desired value afterwards:
73     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74     *
75     * Emits an {Approval} event.
76     */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80     * @dev Moves `amount` tokens from `sender` to `recipient` using the
81     * allowance mechanism. `amount` is then deducted from the caller's
82     * allowance.
83     *
84     * Returns a boolean value indicating whether the operation succeeded.
85     *
86     * Emits a {Transfer} event.
87     */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91     * @dev Emitted when `value` tokens are moved from one account (`from`) to
92     * another (`to`).
93     *
94     * Note that `value` may be zero.
95     */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100     * a call to {approve}. `value` is the new allowance.
101     */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 // CAUTION
106 // This version of SafeMath should only be used with Solidity 0.8 or later,
107 // because it relies on the compiler's built in overflow checks.
108 
109 /**
110  * @dev Wrappers over Solidity's arithmetic operations.
111  *
112  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
113  * now has built in overflow checking.
114  */
115 library SafeMath {
116     /**
117     * @dev Returns the addition of two unsigned integers, with an overflow flag.
118     *
119     * _Available since v3.4._
120     */
121     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             uint256 c = a + b;
124             if (c < a) return (false, 0);
125             return (true, c);
126         }
127     }
128 
129     /**
130     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
131     *
132     * _Available since v3.4._
133     */
134     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             if (b > a) return (false, 0);
137             return (true, a - b);
138         }
139     }
140 
141     /**
142     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
143     *
144     * _Available since v3.4._
145     */
146     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         unchecked {
148             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149             // benefit is lost if 'b' is also tested.
150             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151             if (a == 0) return (true, 0);
152             uint256 c = a * b;
153             if (c / a != b) return (false, 0);
154             return (true, c);
155         }
156     }
157 
158     /**
159     * @dev Returns the division of two unsigned integers, with a division by zero flag.
160     *
161     * _Available since v3.4._
162     */
163     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         unchecked {
165             if (b == 0) return (false, 0);
166             return (true, a / b);
167         }
168     }
169 
170     /**
171     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
172     *
173     * _Available since v3.4._
174     */
175     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         unchecked {
177             if (b == 0) return (false, 0);
178             return (true, a % b);
179         }
180     }
181 
182     /**
183     * @dev Returns the addition of two unsigned integers, reverting on
184     * overflow.
185     *
186     * Counterpart to Solidity's `+` operator.
187     *
188     * Requirements:
189     *
190     * - Addition cannot overflow.
191     */
192     function add(uint256 a, uint256 b) internal pure returns (uint256) {
193         return a + b;
194     }
195 
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a - b;
198     }
199 
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a * b;
202     }
203 
204  
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a / b;
207     }
208 
209     /**
210     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211     * reverting when dividing by zero.
212     *
213     * Counterpart to Solidity's `%` operator. This function uses a `revert`
214     * opcode (which leaves remaining gas untouched) while Solidity uses an
215     * invalid opcode to revert (consuming all remaining gas).
216     *
217     * Requirements:
218     *
219     * - The divisor cannot be zero.
220     */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a % b;
223     }
224 
225     /**
226     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
227     * overflow (when the result is negative).
228     *
229     * CAUTION: This function is deprecated because it requires allocating memory for the error
230     * message unnecessarily. For custom revert reasons use {trySub}.
231     *
232     * Counterpart to Solidity's `-` operator.
233     *
234     * Requirements:
235     *
236     * - Subtraction cannot overflow.
237     */
238     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         unchecked {
240             require(b <= a, errorMessage);
241             return a - b;
242         }
243     }
244 
245     /**
246     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
247     * division by zero. The result is rounded towards zero.
248     *
249     * Counterpart to Solidity's `%` operator. This function uses a `revert`
250     * opcode (which leaves remaining gas untouched) while Solidity uses an
251     * invalid opcode to revert (consuming all remaining gas).
252     *
253     * Counterpart to Solidity's `/` operator. Note: this function uses a
254     * `revert` opcode (which leaves remaining gas untouched) while Solidity
255     * uses an invalid opcode to revert (consuming all remaining gas).
256     *
257     * Requirements:
258     *
259     * - The divisor cannot be zero.
260     */
261     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a / b;
265         }
266     }
267 
268     /**
269     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270     * reverting with custom message when dividing by zero.
271     *
272     * CAUTION: This function is deprecated because it requires allocating memory for the error
273     * message unnecessarily. For custom revert reasons use {tryMod}.
274     *
275     * Counterpart to Solidity's `%` operator. This function uses a `revert`
276     * opcode (which leaves remaining gas untouched) while Solidity uses an
277     * invalid opcode to revert (consuming all remaining gas).
278     *
279     * Requirements:
280     *
281     * - The divisor cannot be zero.
282     */
283     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         unchecked {
285             require(b > 0, errorMessage);
286             return a % b;
287         }
288     }
289 }
290 
291 /*
292  * @dev Provides information about the current execution context, including the
293  * sender of the transaction and its data. While these are generally available
294  * via msg.sender and msg.data, they should not be accessed in such a direct
295  * manner, since when dealing with meta-transactions the account sending and
296  * paying for execution may not be the actual sender (as far as an application
297  * is concerned).
298  *
299  * This contract is only required for intermediate, library-like contracts.
300  */
301 abstract contract Context {
302     function _msgSender() internal view virtual returns (address) {
303         return msg.sender;
304     }
305 
306     function _msgData() internal view virtual returns (bytes calldata) {
307         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
308         return msg.data;
309     }
310 }
311 
312 /**
313  * @dev Collection of functions related to the address type
314  */
315 library Address {
316     /**
317     * @dev Returns true if `account` is a contract.
318     *
319     * [IMPORTANT]
320     * ====
321     * It is unsafe to assume that an address for which this function returns
322     * false is an externally-owned account (EOA) and not a contract.
323     *
324     * Among others, `isContract` will return false for the following
325     * types of addresses:
326     *
327     *  - an externally-owned account
328     *  - a contract in construction
329     *  - an address where a contract will be created
330     *  - an address where a contract lived, but was destroyed
331     * ====
332     */
333     function isContract(address account) internal view returns (bool) {
334         // This method relies on extcodesize, which returns 0 for contracts in
335         // construction, since the code is only stored at the end of the
336         // constructor execution.
337 
338         uint256 size;
339         // solhint-disable-next-line no-inline-assembly
340         assembly { size := extcodesize(account) }
341         return size > 0;
342     }
343 
344     /**
345     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346     * `recipient`, forwarding all available gas and reverting on errors.
347     *
348     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349     * of certain opcodes, possibly making contracts go over the 2300 gas limit
350     * imposed by `transfer`, making them unable to receive funds via
351     * `transfer`. {sendValue} removes this limitation.
352     *
353     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354     *
355     * IMPORTANT: because control is transferred to `recipient`, care must be
356     * taken to not create reentrancy vulnerabilities. Consider using
357     * {ReentrancyGuard} or the
358     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359     */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
364         (bool success, ) = recipient.call{ value: amount }("");
365         require(success, "Address: unable to send value, recipient may have reverted");
366     }
367 
368     /**
369     * @dev Performs a Solidity function call using a low level `call`. A
370     * plain`call` is an unsafe replacement for a function call: use this
371     * function instead.
372     *
373     * If `target` reverts with a revert reason, it is bubbled up by this
374     * function (like regular Solidity function calls).
375     *
376     * Returns the raw returned data. To convert to the expected return value,
377     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378     *
379     * Requirements:
380     *
381     * - `target` must be a contract.
382     * - calling `target` with `data` must not revert.
383     *
384     * _Available since v3.1._
385     */
386     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
387       return functionCall(target, data, "Address: low-level call failed");
388     }
389 
390     /**
391     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
392     * `errorMessage` as a fallback revert reason when `target` reverts.
393     *
394     * _Available since v3.1._
395     */
396     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, 0, errorMessage);
398     }
399 
400     /**
401     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402     * but also transferring `value` wei to `target`.
403     *
404     * Requirements:
405     *
406     * - the calling contract must have an ETH balance of at least `value`.
407     * - the called Solidity function must be `payable`.
408     *
409     * _Available since v3.1._
410     */
411     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
413     }
414 
415     /**
416     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
417     * with `errorMessage` as a fallback revert reason when `target` reverts.
418     *
419     * _Available since v3.1._
420     */
421     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
422         require(address(this).balance >= value, "Address: insufficient balance for call");
423         require(isContract(target), "Address: call to non-contract");
424 
425         // solhint-disable-next-line avoid-low-level-calls
426         (bool success, bytes memory returndata) = target.call{ value: value }(data);
427         return _verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432     * but performing a static call.
433     *
434     * _Available since v3.3._
435     */
436     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
437         return functionStaticCall(target, data, "Address: low-level static call failed");
438     }
439 
440     /**
441     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442     * but performing a static call.
443     *
444     * _Available since v3.3._
445     */
446     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
447         require(isContract(target), "Address: static call to non-contract");
448 
449         // solhint-disable-next-line avoid-low-level-calls
450         (bool success, bytes memory returndata) = target.staticcall(data);
451         return _verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456     * but performing a delegate call.
457     *
458     * _Available since v3.4._
459     */
460     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
461         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
462     }
463 
464     /**
465     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466     * but performing a delegate call.
467     *
468     * _Available since v3.4._
469     */
470     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
471         require(isContract(target), "Address: delegate call to non-contract");
472 
473         // solhint-disable-next-line avoid-low-level-calls
474         (bool success, bytes memory returndata) = target.delegatecall(data);
475         return _verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
479         if (success) {
480             return returndata;
481         } else {
482             // Look for revert reason and bubble it up if present
483             if (returndata.length > 0) {
484                 // The easiest way to bubble the revert reason is using memory via assembly
485 
486                 // solhint-disable-next-line no-inline-assembly
487                 assembly {
488                     let returndata_size := mload(returndata)
489                     revert(add(32, returndata), returndata_size)
490                 }
491             } else {
492                 revert(errorMessage);
493             }
494         }
495     }
496 }
497 
498 /**
499  * @dev Contract module which provides a basic access control mechanism, where
500  * there is an account (an owner) that can be granted exclusive access to
501  * specific functions.
502  *
503  * By default, the owner account will be the one that deploys the contract. This
504  * can later be changed with {transferOwnership}.
505  *
506  * This module is used through inheritance. It will make available the modifier
507  * `onlyOwner`, which can be applied to your functions to restrict their use to
508  * the owner.
509  */
510 abstract contract Ownable is Context {
511     address private _owner;
512 
513     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
514 
515     /**
516     * @dev Initializes the contract setting the deployer as the initial owner.
517     */
518     constructor () {
519         _owner = _msgSender();
520         emit OwnershipTransferred(address(0), _owner);
521     }
522 
523     /**
524     * @dev Returns the address of the current owner.
525     */
526     function owner() public view virtual returns (address) {
527         return _owner;
528     }
529 
530     /**
531     * @dev Throws if called by any account other than the owner.
532     */
533     modifier onlyOwner() {
534         require(owner() == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537 
538     /**
539     * @dev Leaves the contract without owner. It will not be possible to call
540     * `onlyOwner` functions anymore. Can only be called by the current owner.
541     *
542     * NOTE: Renouncing ownership will leave the contract without an owner,
543     * thereby removing any functionality that is only available to the owner.
544     */
545     function renounceOwnership() public virtual onlyOwner {
546         emit OwnershipTransferred(_owner, address(0));
547         _owner = address(0);
548     }
549 
550     /**
551     * @dev Transfers ownership of the contract to a new account (`newOwner`).
552     * Can only be called by the current owner.
553     */
554     function transferOwnership(address newOwner) public virtual onlyOwner {
555         require(newOwner != address(0), "Ownable: new owner is the zero address");
556         emit OwnershipTransferred(_owner, newOwner);
557         _owner = newOwner;
558     }
559 }
560 
561 interface IUniswapV2Factory {
562     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
563 
564     function feeTo() external view returns (address);
565     function feeToSetter() external view returns (address);
566 
567     function getPair(address tokenA, address tokenB) external view returns (address pair);
568     function allPairs(uint) external view returns (address pair);
569     function allPairsLength() external view returns (uint);
570 
571     function createPair(address tokenA, address tokenB) external returns (address pair);
572 
573     function setFeeTo(address) external;
574     function setFeeToSetter(address) external;
575 }
576 
577 interface IUniswapV2Pair {
578     event Approval(address indexed owner, address indexed spender, uint value);
579     event Transfer(address indexed from, address indexed to, uint value);
580 
581     function name() external pure returns (string memory);
582     function symbol() external pure returns (string memory);
583     function decimals() external pure returns (uint8);
584     function totalSupply() external view returns (uint);
585     function balanceOf(address owner) external view returns (uint);
586     function allowance(address owner, address spender) external view returns (uint);
587 
588     function approve(address spender, uint value) external returns (bool);
589     function transfer(address to, uint value) external returns (bool);
590     function transferFrom(address from, address to, uint value) external returns (bool);
591 
592     function DOMAIN_SEPARATOR() external view returns (bytes32);
593     function PERMIT_TYPEHASH() external pure returns (bytes32);
594     function nonces(address owner) external view returns (uint);
595 
596     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
597 
598     event Mint(address indexed sender, uint amount0, uint amount1);
599     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
600     event Swap(
601         address indexed sender,
602         uint amount0In,
603         uint amount1In,
604         uint amount0Out,
605         uint amount1Out,
606         address indexed to
607     );
608     event Sync(uint112 reserve0, uint112 reserve1);
609 
610     function MINIMUM_LIQUIDITY() external pure returns (uint);
611     function factory() external view returns (address);
612     function token0() external view returns (address);
613     function token1() external view returns (address);
614     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
615     function price0CumulativeLast() external view returns (uint);
616     function price1CumulativeLast() external view returns (uint);
617     function kLast() external view returns (uint);
618 
619     function mint(address to) external returns (uint liquidity);
620     function burn(address to) external returns (uint amount0, uint amount1);
621     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
622     function skim(address to) external;
623     function sync() external;
624 
625     function initialize(address, address) external;
626 }
627 
628 interface IUniswapV2Router01 {
629     function factory() external pure returns (address);
630     function WETH() external pure returns (address);
631 
632     function addLiquidity(
633         address tokenA,
634         address tokenB,
635         uint amountADesired,
636         uint amountBDesired,
637         uint amountAMin,
638         uint amountBMin,
639         address to,
640         uint deadline
641     ) external returns (uint amountA, uint amountB, uint liquidity);
642     function addLiquidityETH(
643         address token,
644         uint amountTokenDesired,
645         uint amountTokenMin,
646         uint amountETHMin,
647         address to,
648         uint deadline
649     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
650     function removeLiquidity(
651         address tokenA,
652         address tokenB,
653         uint liquidity,
654         uint amountAMin,
655         uint amountBMin,
656         address to,
657         uint deadline
658     ) external returns (uint amountA, uint amountB);
659     function removeLiquidityETH(
660         address token,
661         uint liquidity,
662         uint amountTokenMin,
663         uint amountETHMin,
664         address to,
665         uint deadline
666     ) external returns (uint amountToken, uint amountETH);
667     function removeLiquidityWithPermit(
668         address tokenA,
669         address tokenB,
670         uint liquidity,
671         uint amountAMin,
672         uint amountBMin,
673         address to,
674         uint deadline,
675         bool approveMax, uint8 v, bytes32 r, bytes32 s
676     ) external returns (uint amountA, uint amountB);
677     function removeLiquidityETHWithPermit(
678         address token,
679         uint liquidity,
680         uint amountTokenMin,
681         uint amountETHMin,
682         address to,
683         uint deadline,
684         bool approveMax, uint8 v, bytes32 r, bytes32 s
685     ) external returns (uint amountToken, uint amountETH);
686     function swapExactTokensForTokens(
687         uint amountIn,
688         uint amountOutMin,
689         address[] calldata path,
690         address to,
691         uint deadline
692     ) external returns (uint[] memory amounts);
693     function swapTokensForExactTokens(
694         uint amountOut,
695         uint amountInMax,
696         address[] calldata path,
697         address to,
698         uint deadline
699     ) external returns (uint[] memory amounts);
700     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
701         external
702         payable
703         returns (uint[] memory amounts);
704     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
705         external
706         returns (uint[] memory amounts);
707     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
708         external
709         returns (uint[] memory amounts);
710     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
711         external
712         payable
713         returns (uint[] memory amounts);
714 
715     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
716     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
717     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
718     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
719     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
720 }
721 
722 interface IUniswapV2Router02 is IUniswapV2Router01 {
723     function removeLiquidityETHSupportingFeeOnTransferTokens(
724         address token,
725         uint liquidity,
726         uint amountTokenMin,
727         uint amountETHMin,
728         address to,
729         uint deadline
730     ) external returns (uint amountETH);
731     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
732         address token,
733         uint liquidity,
734         uint amountTokenMin,
735         uint amountETHMin,
736         address to,
737         uint deadline,
738         bool approveMax, uint8 v, bytes32 r, bytes32 s
739     ) external returns (uint amountETH);
740 
741     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
742         uint amountIn,
743         uint amountOutMin,
744         address[] calldata path,
745         address to,
746         uint deadline
747     ) external;
748     function swapExactETHForTokensSupportingFeeOnTransferTokens(
749         uint amountOutMin,
750         address[] calldata path,
751         address to,
752         uint deadline
753     ) external payable;
754     function swapExactTokensForETHSupportingFeeOnTransferTokens(
755         uint amountIn,
756         uint amountOutMin,
757         address[] calldata path,
758         address to,
759         uint deadline
760     ) external;
761 }
762 
763 
764 contract BULLETH is Context, IERC20, Ownable {
765     using SafeMath for uint256;
766     using Address for address;
767 
768     uint8 private _decimals = 9;
769 
770     //
771     string private _name = "BULLETH";                                           // name
772     string private _symbol = "BULLETH";                                            // symbol
773     uint256 private _tTotal = 1 * 10**9 * 10**uint256(_decimals);
774 
775     // % to holders
776     uint256 public defaultTaxFee = 0;
777     uint256 public _taxFee = defaultTaxFee;
778     uint256 private _previousTaxFee = _taxFee;
779 
780     // % to swap & send to marketing wallet
781     uint256 public defaultMarketingFee = 12;
782     uint256 public _marketingFee = defaultMarketingFee;
783     uint256 private _previousMarketingFee = _marketingFee;
784 
785     uint256 public _marketingFee4Sellers = 12;
786 
787     bool public feesOnSellersAndBuyers = true;
788 
789     uint256 public _maxTxAmount = _tTotal.div(1).div(50);
790     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
791     address payable public marketingWallet = payable(0x15bbb2E61814d3Eb709Bbe05202A66AeEa2022ee);
792 
793     //
794 
795     mapping (address => uint256) private _rOwned;
796     mapping (address => uint256) private _tOwned;
797     mapping (address => mapping (address => uint256)) private _allowances;
798 
799     mapping (address => bool) private _isExcludedFromFee;
800 
801     mapping (address => bool) private _isExcluded;
802    
803     mapping (address => bool) public _isBlacklisted;
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
828         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
973      function addToBlackList(address[] calldata addresses) external onlyOwner {
974       for (uint256 i; i < addresses.length; ++i) {
975         _isBlacklisted[addresses[i]] = true;
976       }
977     }
978    
979       function removeFromBlackList(address account) external onlyOwner {
980         _isBlacklisted[account] = false;
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
1061         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted");
1062 
1063         if(from != owner() && to != owner())
1064             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1065 
1066         // is the token balance of this contract address over the min number of
1067         // tokens that we need to initiate a swap + send lock?
1068         // also, don't get caught in a circular sending event.
1069         // also, don't swap & liquify if sender is uniswap pair.
1070         uint256 contractTokenBalance = balanceOf(address(this));
1071         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1072 
1073         if(contractTokenBalance >= _maxTxAmount)
1074         {
1075             contractTokenBalance = _maxTxAmount;
1076         }
1077 
1078         if (
1079             overMinTokenBalance &&
1080             !inSwapAndSend &&
1081             from != uniswapV2Pair &&
1082             SwapAndSendEnabled
1083         ) {
1084             SwapAndSend(contractTokenBalance);
1085         }
1086 
1087         if(feesOnSellersAndBuyers) {
1088             setFees(to);
1089         }
1090 
1091         //indicates if fee should be deducted from transfer
1092         bool takeFee = true;
1093 
1094         //if any account belongs to _isExcludedFromFee account then remove the fee
1095         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1096             takeFee = false;
1097         }
1098 
1099         _tokenTransfer(from,to,amount,takeFee);
1100     }
1101 
1102     function setFees(address recipient) private {
1103         _taxFee = defaultTaxFee;
1104         _marketingFee = defaultMarketingFee;
1105         if (recipient == uniswapV2Pair) { // sell
1106             _marketingFee = _marketingFee4Sellers;
1107         }
1108     }
1109 
1110     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1111         // generate the uniswap pair path of token -> weth
1112         address[] memory path = new address[](2);
1113         path[0] = address(this);
1114         path[1] = uniswapV2Router.WETH();
1115 
1116         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1117 
1118         // make the swap
1119         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1120             contractTokenBalance,
1121             0, // accept any amount of ETH
1122             path,
1123             address(this),
1124             block.timestamp
1125         );
1126 
1127         uint256 contractETHBalance = address(this).balance;
1128         if(contractETHBalance > 0) {
1129             marketingWallet.transfer(contractETHBalance);
1130         }
1131     }
1132 
1133     //this method is responsible for taking all fee, if takeFee is true
1134     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1135         if(!takeFee)
1136             removeAllFee();
1137 
1138         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1139             _transferFromExcluded(sender, recipient, amount);
1140         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1141             _transferToExcluded(sender, recipient, amount);
1142         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1143             _transferStandard(sender, recipient, amount);
1144         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1145             _transferBothExcluded(sender, recipient, amount);
1146         } else {
1147             _transferStandard(sender, recipient, amount);
1148         }
1149 
1150         if(!takeFee)
1151             restoreAllFee();
1152     }
1153 
1154     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1155         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1156         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1157         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1158         _takeMarketing(tMarketing);
1159         _reflectFee(rFee, tFee);
1160         emit Transfer(sender, recipient, tTransferAmount);
1161     }
1162 
1163     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1164         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1165         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1166         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1167         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1168         _takeMarketing(tMarketing);
1169         _reflectFee(rFee, tFee);
1170         emit Transfer(sender, recipient, tTransferAmount);
1171     }
1172 
1173     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1174         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1175         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1176         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1177         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1178         _takeMarketing(tMarketing);
1179         _reflectFee(rFee, tFee);
1180         emit Transfer(sender, recipient, tTransferAmount);
1181     }
1182 
1183     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1184         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1185         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1186         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1187         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1188         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1189         _takeMarketing(tMarketing);
1190         _reflectFee(rFee, tFee);
1191         emit Transfer(sender, recipient, tTransferAmount);
1192     }
1193 
1194     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1195         defaultMarketingFee = marketingFee;
1196     }
1197 
1198     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1199         _marketingFee4Sellers = marketingFee4Sellers;
1200     }
1201 
1202     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1203         feesOnSellersAndBuyers = _enabled;
1204     }
1205 
1206     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1207         SwapAndSendEnabled = _enabled;
1208         emit SwapAndSendEnabledUpdated(_enabled);
1209     }
1210 
1211     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1212         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1213     }
1214 
1215     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1216         marketingWallet = wallet;
1217     }
1218    
1219    
1220 
1221     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1222         _maxTxAmount = maxTxAmount;
1223     }
1224 }