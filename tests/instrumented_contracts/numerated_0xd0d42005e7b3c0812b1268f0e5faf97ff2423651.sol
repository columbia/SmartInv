1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-02
3 */
4 
5 
6 pragma solidity ^0.8.3;
7 // SPDX-License-Identifier: Unlicensed
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */ 
12 interface IERC20 {
13     /**
14     * @dev Returns the amount of tokens in existence.
15     */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19     * @dev Returns the amount of tokens owned by `account`.
20     */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24     * @dev Moves `amount` tokens from the caller's account to `recipient`.
25     *
26     * Returns a boolean value indicating whether the operation succeeded.
27     *
28     * Emits a {Transfer} event.
29     */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33     * @dev Returns the remaining number of tokens that `spender` will be
34     * allowed to spend on behalf of `owner` through {transferFrom}. This is
35     * zero by default.
36     *
37     * This value changes when {approve} or {transferFrom} are called.
38     */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43     *
44     * Returns a boolean value indicating whether the operation succeeded.
45     *
46     * IMPORTANT: Beware that changing an allowance with this method brings the risk
47     * that someone may use both the old and the new allowance by unfortunate
48     * transaction ordering. One possible solution to mitigate this race
49     * condition is to first reduce the spender's allowance to 0 and set the
50     * desired value afterwards:
51     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52     *
53     * Emits an {Approval} event.
54     */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58     * @dev Moves `amount` tokens from `sender` to `recipient` using the
59     * allowance mechanism. `amount` is then deducted from the caller's
60     * allowance.
61     *
62     * Returns a boolean value indicating whether the operation succeeded.
63     *
64     * Emits a {Transfer} event.
65     */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69     * @dev Emitted when `value` tokens are moved from one account (`from`) to
70     * another (`to`).
71     *
72     * Note that `value` may be zero.
73     */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78     * a call to {approve}. `value` is the new allowance.
79     */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // CAUTION
84 // This version of SafeMath should only be used with Solidity 0.8 or later,
85 // because it relies on the compiler's built in overflow checks.
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations.
89  *
90  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
91  * now has built in overflow checking.
92  */
93 library SafeMath {
94     /**
95     * @dev Returns the addition of two unsigned integers, with an overflow flag.
96     *
97     * _Available since v3.4._
98     */
99     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
100         unchecked {
101             uint256 c = a + b;
102             if (c < a) return (false, 0);
103             return (true, c);
104         }
105     }
106 
107     /**
108     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
109     *
110     * _Available since v3.4._
111     */
112     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
113         unchecked {
114             if (b > a) return (false, 0);
115             return (true, a - b);
116         }
117     }
118 
119     /**
120     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
121     *
122     * _Available since v3.4._
123     */
124     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         unchecked {
126             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127             // benefit is lost if 'b' is also tested.
128             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
129             if (a == 0) return (true, 0);
130             uint256 c = a * b;
131             if (c / a != b) return (false, 0);
132             return (true, c);
133         }
134     }
135 
136     /**
137     * @dev Returns the division of two unsigned integers, with a division by zero flag.
138     *
139     * _Available since v3.4._
140     */
141     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         unchecked {
143             if (b == 0) return (false, 0);
144             return (true, a / b);
145         }
146     }
147 
148     /**
149     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
150     *
151     * _Available since v3.4._
152     */
153     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         unchecked {
155             if (b == 0) return (false, 0);
156             return (true, a % b);
157         }
158     }
159 
160     /**
161     * @dev Returns the addition of two unsigned integers, reverting on
162     * overflow.
163     *
164     * Counterpart to Solidity's `+` operator.
165     *
166     * Requirements:
167     *
168     * - Addition cannot overflow.
169     */
170     function add(uint256 a, uint256 b) internal pure returns (uint256) {
171         return a + b;
172     }
173 
174     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a - b;
176     }
177 
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a * b;
180     }
181 
182  
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a / b;
185     }
186 
187     /**
188     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
189     * reverting when dividing by zero.
190     *
191     * Counterpart to Solidity's `%` operator. This function uses a `revert`
192     * opcode (which leaves remaining gas untouched) while Solidity uses an
193     * invalid opcode to revert (consuming all remaining gas).
194     *
195     * Requirements:
196     *
197     * - The divisor cannot be zero.
198     */
199     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a % b;
201     }
202 
203     /**
204     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
205     * overflow (when the result is negative).
206     *
207     * CAUTION: This function is deprecated because it requires allocating memory for the error
208     * message unnecessarily. For custom revert reasons use {trySub}.
209     *
210     * Counterpart to Solidity's `-` operator.
211     *
212     * Requirements:
213     *
214     * - Subtraction cannot overflow.
215     */
216     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         unchecked {
218             require(b <= a, errorMessage);
219             return a - b;
220         }
221     }
222 
223     /**
224     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
225     * division by zero. The result is rounded towards zero.
226     *
227     * Counterpart to Solidity's `%` operator. This function uses a `revert`
228     * opcode (which leaves remaining gas untouched) while Solidity uses an
229     * invalid opcode to revert (consuming all remaining gas).
230     *
231     * Counterpart to Solidity's `/` operator. Note: this function uses a
232     * `revert` opcode (which leaves remaining gas untouched) while Solidity
233     * uses an invalid opcode to revert (consuming all remaining gas).
234     *
235     * Requirements:
236     *
237     * - The divisor cannot be zero.
238     */
239     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         unchecked {
241             require(b > 0, errorMessage);
242             return a / b;
243         }
244     }
245 
246     /**
247     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248     * reverting with custom message when dividing by zero.
249     *
250     * CAUTION: This function is deprecated because it requires allocating memory for the error
251     * message unnecessarily. For custom revert reasons use {tryMod}.
252     *
253     * Counterpart to Solidity's `%` operator. This function uses a `revert`
254     * opcode (which leaves remaining gas untouched) while Solidity uses an
255     * invalid opcode to revert (consuming all remaining gas).
256     *
257     * Requirements:
258     *
259     * - The divisor cannot be zero.
260     */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a % b;
265         }
266     }
267 }
268 
269 /*
270  * @dev Provides information about the current execution context, including the
271  * sender of the transaction and its data. While these are generally available
272  * via msg.sender and msg.data, they should not be accessed in such a direct
273  * manner, since when dealing with meta-transactions the account sending and
274  * paying for execution may not be the actual sender (as far as an application
275  * is concerned).
276  *
277  * This contract is only required for intermediate, library-like contracts.
278  */
279 abstract contract Context {
280     function _msgSender() internal view virtual returns (address) {
281         return msg.sender;
282     }
283 
284     function _msgData() internal view virtual returns (bytes calldata) {
285         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
286         return msg.data;
287     }
288 }
289 
290 /**
291  * @dev Collection of functions related to the address type
292  */
293 library Address {
294     /**
295     * @dev Returns true if `account` is a contract.
296     *
297     * [IMPORTANT]
298     * ====
299     * It is unsafe to assume that an address for which this function returns
300     * false is an externally-owned account (EOA) and not a contract.
301     *
302     * Among others, `isContract` will return false for the following
303     * types of addresses:
304     *
305     *  - an externally-owned account
306     *  - a contract in construction
307     *  - an address where a contract will be created
308     *  - an address where a contract lived, but was destroyed
309     * ====
310     */
311     function isContract(address account) internal view returns (bool) {
312         // This method relies on extcodesize, which returns 0 for contracts in
313         // construction, since the code is only stored at the end of the
314         // constructor execution.
315 
316         uint256 size;
317         // solhint-disable-next-line no-inline-assembly
318         assembly { size := extcodesize(account) }
319         return size > 0;
320     }
321 
322     /**
323     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
324     * `recipient`, forwarding all available gas and reverting on errors.
325     *
326     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
327     * of certain opcodes, possibly making contracts go over the 2300 gas limit
328     * imposed by `transfer`, making them unable to receive funds via
329     * `transfer`. {sendValue} removes this limitation.
330     *
331     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
332     *
333     * IMPORTANT: because control is transferred to `recipient`, care must be
334     * taken to not create reentrancy vulnerabilities. Consider using
335     * {ReentrancyGuard} or the
336     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
337     */
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, "Address: insufficient balance");
340 
341         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
342         (bool success, ) = recipient.call{ value: amount }("");
343         require(success, "Address: unable to send value, recipient may have reverted");
344     }
345 
346     /**
347     * @dev Performs a Solidity function call using a low level `call`. A
348     * plain`call` is an unsafe replacement for a function call: use this
349     * function instead.
350     *
351     * If `target` reverts with a revert reason, it is bubbled up by this
352     * function (like regular Solidity function calls).
353     *
354     * Returns the raw returned data. To convert to the expected return value,
355     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
356     *
357     * Requirements:
358     *
359     * - `target` must be a contract.
360     * - calling `target` with `data` must not revert.
361     *
362     * _Available since v3.1._
363     */
364     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
365       return functionCall(target, data, "Address: low-level call failed");
366     }
367 
368     /**
369     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
370     * `errorMessage` as a fallback revert reason when `target` reverts.
371     *
372     * _Available since v3.1._
373     */
374     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, 0, errorMessage);
376     }
377 
378     /**
379     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380     * but also transferring `value` wei to `target`.
381     *
382     * Requirements:
383     *
384     * - the calling contract must have an ETH balance of at least `value`.
385     * - the called Solidity function must be `payable`.
386     *
387     * _Available since v3.1._
388     */
389     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395     * with `errorMessage` as a fallback revert reason when `target` reverts.
396     *
397     * _Available since v3.1._
398     */
399     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         require(isContract(target), "Address: call to non-contract");
402 
403         // solhint-disable-next-line avoid-low-level-calls
404         (bool success, bytes memory returndata) = target.call{ value: value }(data);
405         return _verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410     * but performing a static call.
411     *
412     * _Available since v3.3._
413     */
414     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
415         return functionStaticCall(target, data, "Address: low-level static call failed");
416     }
417 
418     /**
419     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420     * but performing a static call.
421     *
422     * _Available since v3.3._
423     */
424     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
425         require(isContract(target), "Address: static call to non-contract");
426 
427         // solhint-disable-next-line avoid-low-level-calls
428         (bool success, bytes memory returndata) = target.staticcall(data);
429         return _verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434     * but performing a delegate call.
435     *
436     * _Available since v3.4._
437     */
438     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
439         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
440     }
441 
442     /**
443     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444     * but performing a delegate call.
445     *
446     * _Available since v3.4._
447     */
448     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
449         require(isContract(target), "Address: delegate call to non-contract");
450 
451         // solhint-disable-next-line avoid-low-level-calls
452         (bool success, bytes memory returndata) = target.delegatecall(data);
453         return _verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
457         if (success) {
458             return returndata;
459         } else {
460             // Look for revert reason and bubble it up if present
461             if (returndata.length > 0) {
462                 // The easiest way to bubble the revert reason is using memory via assembly
463 
464                 // solhint-disable-next-line no-inline-assembly
465                 assembly {
466                     let returndata_size := mload(returndata)
467                     revert(add(32, returndata), returndata_size)
468                 }
469             } else {
470                 revert(errorMessage);
471             }
472         }
473     }
474 }
475 
476 /**
477  * @dev Contract module which provides a basic access control mechanism, where
478  * there is an account (an owner) that can be granted exclusive access to
479  * specific functions.
480  *
481  * By default, the owner account will be the one that deploys the contract. This
482  * can later be changed with {transferOwnership}.
483  *
484  * This module is used through inheritance. It will make available the modifier
485  * `onlyOwner`, which can be applied to your functions to restrict their use to
486  * the owner.
487  */
488 abstract contract Ownable is Context {
489     address private _owner;
490 
491     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
492 
493     /**
494     * @dev Initializes the contract setting the deployer as the initial owner.
495     */
496     constructor () {
497         _owner = _msgSender();
498         emit OwnershipTransferred(address(0), _owner);
499     }
500 
501     /**
502     * @dev Returns the address of the current owner.
503     */
504     function owner() public view virtual returns (address) {
505         return _owner;
506     }
507 
508     /**
509     * @dev Throws if called by any account other than the owner.
510     */
511     modifier onlyOwner() {
512         require(owner() == _msgSender(), "Ownable: caller is not the owner");
513         _;
514     }
515 
516     /**
517     * @dev Leaves the contract without owner. It will not be possible to call
518     * `onlyOwner` functions anymore. Can only be called by the current owner.
519     *
520     * NOTE: Renouncing ownership will leave the contract without an owner,
521     * thereby removing any functionality that is only available to the owner.
522     */
523     function renounceOwnership() public virtual onlyOwner {
524         emit OwnershipTransferred(_owner, address(0));
525         _owner = address(0);
526     }
527 
528     /**
529     * @dev Transfers ownership of the contract to a new account (`newOwner`).
530     * Can only be called by the current owner.
531     */
532     function transferOwnership(address newOwner) public virtual onlyOwner {
533         require(newOwner != address(0), "Ownable: new owner is the zero address");
534         emit OwnershipTransferred(_owner, newOwner);
535         _owner = newOwner;
536     }
537 }
538 
539 interface IUniswapV2Factory {
540     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
541 
542     function feeTo() external view returns (address);
543     function feeToSetter() external view returns (address);
544 
545     function getPair(address tokenA, address tokenB) external view returns (address pair);
546     function allPairs(uint) external view returns (address pair);
547     function allPairsLength() external view returns (uint);
548 
549     function createPair(address tokenA, address tokenB) external returns (address pair);
550 
551     function setFeeTo(address) external;
552     function setFeeToSetter(address) external;
553 }
554 
555 interface IUniswapV2Pair {
556     event Approval(address indexed owner, address indexed spender, uint value);
557     event Transfer(address indexed from, address indexed to, uint value);
558 
559     function name() external pure returns (string memory);
560     function symbol() external pure returns (string memory);
561     function decimals() external pure returns (uint8);
562     function totalSupply() external view returns (uint);
563     function balanceOf(address owner) external view returns (uint);
564     function allowance(address owner, address spender) external view returns (uint);
565 
566     function approve(address spender, uint value) external returns (bool);
567     function transfer(address to, uint value) external returns (bool);
568     function transferFrom(address from, address to, uint value) external returns (bool);
569 
570     function DOMAIN_SEPARATOR() external view returns (bytes32);
571     function PERMIT_TYPEHASH() external pure returns (bytes32);
572     function nonces(address owner) external view returns (uint);
573 
574     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
575 
576     event Mint(address indexed sender, uint amount0, uint amount1);
577     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
578     event Swap(
579         address indexed sender,
580         uint amount0In,
581         uint amount1In,
582         uint amount0Out,
583         uint amount1Out,
584         address indexed to
585     );
586     event Sync(uint112 reserve0, uint112 reserve1);
587 
588     function MINIMUM_LIQUIDITY() external pure returns (uint);
589     function factory() external view returns (address);
590     function token0() external view returns (address);
591     function token1() external view returns (address);
592     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
593     function price0CumulativeLast() external view returns (uint);
594     function price1CumulativeLast() external view returns (uint);
595     function kLast() external view returns (uint);
596 
597     function mint(address to) external returns (uint liquidity);
598     function burn(address to) external returns (uint amount0, uint amount1);
599     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
600     function skim(address to) external;
601     function sync() external;
602 
603     function initialize(address, address) external;
604 }
605 
606 interface IUniswapV2Router01 {
607     function factory() external pure returns (address);
608     function WETH() external pure returns (address);
609 
610     function addLiquidity(
611         address tokenA,
612         address tokenB,
613         uint amountADesired,
614         uint amountBDesired,
615         uint amountAMin,
616         uint amountBMin,
617         address to,
618         uint deadline
619     ) external returns (uint amountA, uint amountB, uint liquidity);
620     function addLiquidityETH(
621         address token,
622         uint amountTokenDesired,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline
627     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
628     function removeLiquidity(
629         address tokenA,
630         address tokenB,
631         uint liquidity,
632         uint amountAMin,
633         uint amountBMin,
634         address to,
635         uint deadline
636     ) external returns (uint amountA, uint amountB);
637     function removeLiquidityETH(
638         address token,
639         uint liquidity,
640         uint amountTokenMin,
641         uint amountETHMin,
642         address to,
643         uint deadline
644     ) external returns (uint amountToken, uint amountETH);
645     function removeLiquidityWithPermit(
646         address tokenA,
647         address tokenB,
648         uint liquidity,
649         uint amountAMin,
650         uint amountBMin,
651         address to,
652         uint deadline,
653         bool approveMax, uint8 v, bytes32 r, bytes32 s
654     ) external returns (uint amountA, uint amountB);
655     function removeLiquidityETHWithPermit(
656         address token,
657         uint liquidity,
658         uint amountTokenMin,
659         uint amountETHMin,
660         address to,
661         uint deadline,
662         bool approveMax, uint8 v, bytes32 r, bytes32 s
663     ) external returns (uint amountToken, uint amountETH);
664     function swapExactTokensForTokens(
665         uint amountIn,
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external returns (uint[] memory amounts);
671     function swapTokensForExactTokens(
672         uint amountOut,
673         uint amountInMax,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external returns (uint[] memory amounts);
678     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
679         external
680         payable
681         returns (uint[] memory amounts);
682     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
683         external
684         returns (uint[] memory amounts);
685     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
686         external
687         returns (uint[] memory amounts);
688     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
689         external
690         payable
691         returns (uint[] memory amounts);
692 
693     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
694     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
695     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
696     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
697     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
698 }
699 
700 interface IUniswapV2Router02 is IUniswapV2Router01 {
701     function removeLiquidityETHSupportingFeeOnTransferTokens(
702         address token,
703         uint liquidity,
704         uint amountTokenMin,
705         uint amountETHMin,
706         address to,
707         uint deadline
708     ) external returns (uint amountETH);
709     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
710         address token,
711         uint liquidity,
712         uint amountTokenMin,
713         uint amountETHMin,
714         address to,
715         uint deadline,
716         bool approveMax, uint8 v, bytes32 r, bytes32 s
717     ) external returns (uint amountETH);
718 
719     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
720         uint amountIn,
721         uint amountOutMin,
722         address[] calldata path,
723         address to,
724         uint deadline
725     ) external;
726     function swapExactETHForTokensSupportingFeeOnTransferTokens(
727         uint amountOutMin,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external payable;
732     function swapExactTokensForETHSupportingFeeOnTransferTokens(
733         uint amountIn,
734         uint amountOutMin,
735         address[] calldata path,
736         address to,
737         uint deadline
738     ) external;
739 }
740 
741 
742 contract KOROMARU is Context, IERC20, Ownable {
743     using SafeMath for uint256;
744     using Address for address;
745 
746     uint8 private _decimals = 9;
747 
748     // 
749     string private _name = "KOROMARU";                                           // name
750     string private _symbol = "KOROMARU";                                            // symbol
751     uint256 private _tTotal = 100000000 * 10**9 * 10**uint256(_decimals);
752 
753     // % to holders
754     uint256 public defaultTaxFee = 1;
755     uint256 public _taxFee = defaultTaxFee;
756     uint256 private _previousTaxFee = _taxFee;
757 
758     // % to swap & send to marketing wallet
759     uint256 public defaultMarketingFee = 8;
760     uint256 public _marketingFee = defaultMarketingFee;
761     uint256 private _previousMarketingFee = _marketingFee;
762 
763     uint256 public _marketingFee4Sellers = 8;
764 
765     bool public feesOnSellersAndBuyers = true;
766 
767     uint256 public _maxTxAmount = _tTotal.div(1).div(100);
768     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
769     address payable public marketingWallet = payable(0xdb10247585fe1a9c721C6fc51b2Ce5EA1a06599c);
770 
771     //
772 
773     mapping (address => uint256) private _rOwned;
774     mapping (address => uint256) private _tOwned;
775     mapping (address => mapping (address => uint256)) private _allowances;
776 
777     mapping (address => bool) private _isExcludedFromFee;
778 
779     mapping (address => bool) private _isExcluded;
780     
781     mapping (address => bool) public _isBlacklisted;
782 
783     address[] private _excluded;
784     uint256 private constant MAX = ~uint256(0);
785 
786     uint256 private _tFeeTotal;
787     uint256 private _rTotal = (MAX - (MAX % _tTotal));
788 
789     IUniswapV2Router02 public immutable uniswapV2Router;
790     address public immutable uniswapV2Pair;
791 
792     bool inSwapAndSend;
793     bool public SwapAndSendEnabled = true;
794 
795     event SwapAndSendEnabledUpdated(bool enabled);
796 
797     modifier lockTheSwap {
798         inSwapAndSend = true;
799         _;
800         inSwapAndSend = false;
801     }
802 
803     constructor () {
804         _rOwned[_msgSender()] = _rTotal;
805 
806         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
807          // Create a uniswap pair for this new token
808         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
809             .createPair(address(this), _uniswapV2Router.WETH());
810 
811         // set the rest of the contract variables
812         uniswapV2Router = _uniswapV2Router;
813 
814         //exclude owner and this contract from fee
815         _isExcludedFromFee[owner()] = true;
816         _isExcludedFromFee[address(this)] = true;
817 
818         emit Transfer(address(0), _msgSender(), _tTotal);
819     }
820 
821     function name() public view returns (string memory) {
822         return _name;
823     }
824 
825     function symbol() public view returns (string memory) {
826         return _symbol;
827     }
828 
829     function decimals() public view returns (uint8) {
830         return _decimals;
831     }
832 
833     function totalSupply() public view override returns (uint256) {
834         return _tTotal;
835     }
836 
837     function balanceOf(address account) public view override returns (uint256) {
838         if (_isExcluded[account]) return _tOwned[account];
839         return tokenFromReflection(_rOwned[account]);
840     }
841 
842     function transfer(address recipient, uint256 amount) public override returns (bool) {
843         _transfer(_msgSender(), recipient, amount);
844         return true;
845     }
846 
847     function allowance(address owner, address spender) public view override returns (uint256) {
848         return _allowances[owner][spender];
849     }
850 
851     function approve(address spender, uint256 amount) public override returns (bool) {
852         _approve(_msgSender(), spender, amount);
853         return true;
854     }
855 
856     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
857         _transfer(sender, recipient, amount);
858         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
859         return true;
860     }
861 
862     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
863         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
864         return true;
865     }
866 
867     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
868         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
869         return true;
870     }
871 
872     function isExcludedFromReward(address account) public view returns (bool) {
873         return _isExcluded[account];
874     }
875 
876     function totalFees() public view returns (uint256) {
877         return _tFeeTotal;
878     }
879 
880     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
881         require(tAmount <= _tTotal, "Amount must be less than supply");
882         if (!deductTransferFee) {
883             (uint256 rAmount,,,,,) = _getValues(tAmount);
884             return rAmount;
885         } else {
886             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
887             return rTransferAmount;
888         }
889     }
890 
891     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
892         require(rAmount <= _rTotal, "Amount must be less than total reflections");
893         uint256 currentRate =  _getRate();
894         return rAmount.div(currentRate);
895     }
896 
897     function excludeFromReward(address account) public onlyOwner() {
898         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
899         require(!_isExcluded[account], "Account is already excluded");
900         if(_rOwned[account] > 0) {
901             _tOwned[account] = tokenFromReflection(_rOwned[account]);
902         }
903         _isExcluded[account] = true;
904         _excluded.push(account);
905     }
906 
907     function includeInReward(address account) external onlyOwner() {
908         require(_isExcluded[account], "Account is already excluded");
909         for (uint256 i = 0; i < _excluded.length; i++) {
910             if (_excluded[i] == account) {
911                 _excluded[i] = _excluded[_excluded.length - 1];
912                 _tOwned[account] = 0;
913                 _isExcluded[account] = false;
914                 _excluded.pop();
915                 break;
916             }
917         }
918     }
919 
920     function excludeFromFee(address account) public onlyOwner() {
921         _isExcludedFromFee[account] = true;
922     }
923 
924     function includeInFee(address account) public onlyOwner() {
925         _isExcludedFromFee[account] = false;
926     }
927 
928     function removeAllFee() private {
929         if(_taxFee == 0 && _marketingFee == 0) return;
930 
931         _previousTaxFee = _taxFee;
932         _previousMarketingFee = _marketingFee;
933 
934         _taxFee = 0;
935         _marketingFee = 0;
936     }
937 
938     function restoreAllFee() private {
939         _taxFee = _previousTaxFee;
940         _marketingFee = _previousMarketingFee;
941     }
942 
943     //to recieve ETH
944     receive() external payable {}
945 
946     function _reflectFee(uint256 rFee, uint256 tFee) private {
947         _rTotal = _rTotal.sub(rFee);
948         _tFeeTotal = _tFeeTotal.add(tFee);
949     }
950     
951      function addToBlackList(address[] calldata addresses) external onlyOwner {
952       for (uint256 i; i < addresses.length; ++i) {
953         _isBlacklisted[addresses[i]] = true;
954       }
955     }
956     
957       function removeFromBlackList(address account) external onlyOwner {
958         _isBlacklisted[account] = false;
959     }
960 
961     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
962         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
963         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
964         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
965     }
966 
967     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
968         uint256 tFee = calculateTaxFee(tAmount);
969         uint256 tMarketing = calculateMarketingFee(tAmount);
970         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
971         return (tTransferAmount, tFee, tMarketing);
972     }
973 
974     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
975         uint256 rAmount = tAmount.mul(currentRate);
976         uint256 rFee = tFee.mul(currentRate);
977         uint256 rMarketing = tMarketing.mul(currentRate);
978         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
979         return (rAmount, rTransferAmount, rFee);
980     }
981 
982     function _getRate() private view returns(uint256) {
983         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
984         return rSupply.div(tSupply);
985     }
986 
987     function _getCurrentSupply() private view returns(uint256, uint256) {
988         uint256 rSupply = _rTotal;
989         uint256 tSupply = _tTotal;
990         for (uint256 i = 0; i < _excluded.length; i++) {
991             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
992             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
993             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
994         }
995         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
996         return (rSupply, tSupply);
997     }
998 
999     function _takeMarketing(uint256 tMarketing) private {
1000         uint256 currentRate =  _getRate();
1001         uint256 rMarketing = tMarketing.mul(currentRate);
1002         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1003         if(_isExcluded[address(this)])
1004             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1005     }
1006 
1007     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1008         return _amount.mul(_taxFee).div(
1009             10**2
1010         );
1011     }
1012 
1013     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1014         return _amount.mul(_marketingFee).div(
1015             10**2
1016         );
1017     }
1018 
1019     function isExcludedFromFee(address account) public view returns(bool) {
1020         return _isExcludedFromFee[account];
1021     }
1022 
1023     function _approve(address owner, address spender, uint256 amount) private {
1024         require(owner != address(0), "ERC20: approve from the zero address");
1025         require(spender != address(0), "ERC20: approve to the zero address");
1026 
1027         _allowances[owner][spender] = amount;
1028         emit Approval(owner, spender, amount);
1029     }
1030 
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 amount
1035     ) private {
1036         require(from != address(0), "ERC20: transfer from the zero address");
1037         require(to != address(0), "ERC20: transfer to the zero address");
1038         require(amount > 0, "Transfer amount must be greater than zero");
1039         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted");
1040 
1041         if(from != owner() && to != owner())
1042             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1043 
1044         // is the token balance of this contract address over the min number of
1045         // tokens that we need to initiate a swap + send lock?
1046         // also, don't get caught in a circular sending event.
1047         // also, don't swap & liquify if sender is uniswap pair.
1048         uint256 contractTokenBalance = balanceOf(address(this));
1049         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1050 
1051         if(contractTokenBalance >= _maxTxAmount)
1052         {
1053             contractTokenBalance = _maxTxAmount;
1054         }
1055 
1056         if (
1057             overMinTokenBalance &&
1058             !inSwapAndSend &&
1059             from != uniswapV2Pair &&
1060             SwapAndSendEnabled
1061         ) {
1062             SwapAndSend(contractTokenBalance);
1063         }
1064 
1065         if(feesOnSellersAndBuyers) {
1066             setFees(to);
1067         }
1068 
1069         //indicates if fee should be deducted from transfer
1070         bool takeFee = true;
1071 
1072         //if any account belongs to _isExcludedFromFee account then remove the fee
1073         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1074             takeFee = false;
1075         }
1076 
1077         _tokenTransfer(from,to,amount,takeFee);
1078     }
1079 
1080     function setFees(address recipient) private {
1081         _taxFee = defaultTaxFee;
1082         _marketingFee = defaultMarketingFee;
1083         if (recipient == uniswapV2Pair) { // sell
1084             _marketingFee = _marketingFee4Sellers;
1085         }
1086     }
1087 
1088     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1089         // generate the uniswap pair path of token -> weth
1090         address[] memory path = new address[](2);
1091         path[0] = address(this);
1092         path[1] = uniswapV2Router.WETH();
1093 
1094         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1095 
1096         // make the swap
1097         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1098             contractTokenBalance,
1099             0, // accept any amount of ETH
1100             path,
1101             address(this),
1102             block.timestamp
1103         );
1104 
1105         uint256 contractETHBalance = address(this).balance;
1106         if(contractETHBalance > 0) {
1107             marketingWallet.transfer(contractETHBalance);
1108         }
1109     }
1110 
1111     //this method is responsible for taking all fee, if takeFee is true
1112     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1113         if(!takeFee)
1114             removeAllFee();
1115 
1116         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1117             _transferFromExcluded(sender, recipient, amount);
1118         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1119             _transferToExcluded(sender, recipient, amount);
1120         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1121             _transferStandard(sender, recipient, amount);
1122         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1123             _transferBothExcluded(sender, recipient, amount);
1124         } else {
1125             _transferStandard(sender, recipient, amount);
1126         }
1127 
1128         if(!takeFee)
1129             restoreAllFee();
1130     }
1131 
1132     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1133         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1134         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1135         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1136         _takeMarketing(tMarketing);
1137         _reflectFee(rFee, tFee);
1138         emit Transfer(sender, recipient, tTransferAmount);
1139     }
1140 
1141     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1142         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1143         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1144         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1145         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1146         _takeMarketing(tMarketing);
1147         _reflectFee(rFee, tFee);
1148         emit Transfer(sender, recipient, tTransferAmount);
1149     }
1150 
1151     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1152         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1153         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1154         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1155         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1156         _takeMarketing(tMarketing);
1157         _reflectFee(rFee, tFee);
1158         emit Transfer(sender, recipient, tTransferAmount);
1159     }
1160 
1161     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1162         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1163         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1164         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1165         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1166         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1167         _takeMarketing(tMarketing);
1168         _reflectFee(rFee, tFee);
1169         emit Transfer(sender, recipient, tTransferAmount);
1170     }
1171 
1172     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1173         defaultMarketingFee = marketingFee;
1174     }
1175 
1176     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1177         _marketingFee4Sellers = marketingFee4Sellers;
1178     }
1179 
1180     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1181         feesOnSellersAndBuyers = _enabled;
1182     }
1183 
1184     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1185         SwapAndSendEnabled = _enabled;
1186         emit SwapAndSendEnabledUpdated(_enabled);
1187     }
1188 
1189     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1190         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1191     }
1192 
1193     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1194         marketingWallet = wallet;
1195     }
1196     
1197     
1198 
1199     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1200         _maxTxAmount = maxTxAmount;
1201     }
1202 }