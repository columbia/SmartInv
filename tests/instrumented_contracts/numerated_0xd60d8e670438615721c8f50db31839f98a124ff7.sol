1 //: https://t.me/gatsbyinuerc
2 //WEB: https://gatsbyinuerc.com
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
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a - b;
174     }
175 
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a * b;
178     }
179 
180  
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a / b;
183     }
184 
185     /**
186     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187     * reverting when dividing by zero.
188     *
189     * Counterpart to Solidity's `%` operator. This function uses a `revert`
190     * opcode (which leaves remaining gas untouched) while Solidity uses an
191     * invalid opcode to revert (consuming all remaining gas).
192     *
193     * Requirements:
194     *
195     * - The divisor cannot be zero.
196     */
197     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a % b;
199     }
200 
201     /**
202     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
203     * overflow (when the result is negative).
204     *
205     * CAUTION: This function is deprecated because it requires allocating memory for the error
206     * message unnecessarily. For custom revert reasons use {trySub}.
207     *
208     * Counterpart to Solidity's `-` operator.
209     *
210     * Requirements:
211     *
212     * - Subtraction cannot overflow.
213     */
214     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         unchecked {
216             require(b <= a, errorMessage);
217             return a - b;
218         }
219     }
220 
221     /**
222     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
223     * division by zero. The result is rounded towards zero.
224     *
225     * Counterpart to Solidity's `%` operator. This function uses a `revert`
226     * opcode (which leaves remaining gas untouched) while Solidity uses an
227     * invalid opcode to revert (consuming all remaining gas).
228     *
229     * Counterpart to Solidity's `/` operator. Note: this function uses a
230     * `revert` opcode (which leaves remaining gas untouched) while Solidity
231     * uses an invalid opcode to revert (consuming all remaining gas).
232     *
233     * Requirements:
234     *
235     * - The divisor cannot be zero.
236     */
237     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         unchecked {
239             require(b > 0, errorMessage);
240             return a / b;
241         }
242     }
243 
244     /**
245     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246     * reverting with custom message when dividing by zero.
247     *
248     * CAUTION: This function is deprecated because it requires allocating memory for the error
249     * message unnecessarily. For custom revert reasons use {tryMod}.
250     *
251     * Counterpart to Solidity's `%` operator. This function uses a `revert`
252     * opcode (which leaves remaining gas untouched) while Solidity uses an
253     * invalid opcode to revert (consuming all remaining gas).
254     *
255     * Requirements:
256     *
257     * - The divisor cannot be zero.
258     */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         unchecked {
261             require(b > 0, errorMessage);
262             return a % b;
263         }
264     }
265 }
266 
267 /*
268  * @dev Provides information about the current execution context, including the
269  * sender of the transaction and its data. While these are generally available
270  * via msg.sender and msg.data, they should not be accessed in such a direct
271  * manner, since when dealing with meta-transactions the account sending and
272  * paying for execution may not be the actual sender (as far as an application
273  * is concerned).
274  *
275  * This contract is only required for intermediate, library-like contracts.
276  */
277 abstract contract Context {
278     function _msgSender() internal view virtual returns (address) {
279         return msg.sender;
280     }
281 
282     function _msgData() internal view virtual returns (bytes calldata) {
283         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
284         return msg.data;
285     }
286 }
287 
288 /**
289  * @dev Collection of functions related to the address type
290  */
291 library Address {
292     /**
293     * @dev Returns true if `account` is a contract.
294     *
295     * [IMPORTANT]
296     * ====
297     * It is unsafe to assume that an address for which this function returns
298     * false is an externally-owned account (EOA) and not a contract.
299     *
300     * Among others, `isContract` will return false for the following
301     * types of addresses:
302     *
303     *  - an externally-owned account
304     *  - a contract in construction
305     *  - an address where a contract will be created
306     *  - an address where a contract lived, but was destroyed
307     * ====
308     */
309     function isContract(address account) internal view returns (bool) {
310         // This method relies on extcodesize, which returns 0 for contracts in
311         // construction, since the code is only stored at the end of the
312         // constructor execution.
313 
314         uint256 size;
315         // solhint-disable-next-line no-inline-assembly
316         assembly { size := extcodesize(account) }
317         return size > 0;
318     }
319 
320     /**
321     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
322     * `recipient`, forwarding all available gas and reverting on errors.
323     *
324     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
325     * of certain opcodes, possibly making contracts go over the 2300 gas limit
326     * imposed by `transfer`, making them unable to receive funds via
327     * `transfer`. {sendValue} removes this limitation.
328     *
329     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
330     *
331     * IMPORTANT: because control is transferred to `recipient`, care must be
332     * taken to not create reentrancy vulnerabilities. Consider using
333     * {ReentrancyGuard} or the
334     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
335     */
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(address(this).balance >= amount, "Address: insufficient balance");
338 
339         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
340         (bool success, ) = recipient.call{ value: amount }("");
341         require(success, "Address: unable to send value, recipient may have reverted");
342     }
343 
344     /**
345     * @dev Performs a Solidity function call using a low level `call`. A
346     * plain`call` is an unsafe replacement for a function call: use this
347     * function instead.
348     *
349     * If `target` reverts with a revert reason, it is bubbled up by this
350     * function (like regular Solidity function calls).
351     *
352     * Returns the raw returned data. To convert to the expected return value,
353     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
354     *
355     * Requirements:
356     *
357     * - `target` must be a contract.
358     * - calling `target` with `data` must not revert.
359     *
360     * _Available since v3.1._
361     */
362     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
363       return functionCall(target, data, "Address: low-level call failed");
364     }
365 
366     /**
367     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
368     * `errorMessage` as a fallback revert reason when `target` reverts.
369     *
370     * _Available since v3.1._
371     */
372     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, 0, errorMessage);
374     }
375 
376     /**
377     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378     * but also transferring `value` wei to `target`.
379     *
380     * Requirements:
381     *
382     * - the calling contract must have an ETH balance of at least `value`.
383     * - the called Solidity function must be `payable`.
384     *
385     * _Available since v3.1._
386     */
387     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
389     }
390 
391     /**
392     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
393     * with `errorMessage` as a fallback revert reason when `target` reverts.
394     *
395     * _Available since v3.1._
396     */
397     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
398         require(address(this).balance >= value, "Address: insufficient balance for call");
399         require(isContract(target), "Address: call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.call{ value: value }(data);
403         return _verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408     * but performing a static call.
409     *
410     * _Available since v3.3._
411     */
412     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
413         return functionStaticCall(target, data, "Address: low-level static call failed");
414     }
415 
416     /**
417     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418     * but performing a static call.
419     *
420     * _Available since v3.3._
421     */
422     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
423         require(isContract(target), "Address: static call to non-contract");
424 
425         // solhint-disable-next-line avoid-low-level-calls
426         (bool success, bytes memory returndata) = target.staticcall(data);
427         return _verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432     * but performing a delegate call.
433     *
434     * _Available since v3.4._
435     */
436     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
437         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
438     }
439 
440     /**
441     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442     * but performing a delegate call.
443     *
444     * _Available since v3.4._
445     */
446     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
447         require(isContract(target), "Address: delegate call to non-contract");
448 
449         // solhint-disable-next-line avoid-low-level-calls
450         (bool success, bytes memory returndata) = target.delegatecall(data);
451         return _verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 // solhint-disable-next-line no-inline-assembly
463                 assembly {
464                     let returndata_size := mload(returndata)
465                     revert(add(32, returndata), returndata_size)
466                 }
467             } else {
468                 revert(errorMessage);
469             }
470         }
471     }
472 }
473 
474 /**
475  * @dev Contract module which provides a basic access control mechanism, where
476  * there is an account (an owner) that can be granted exclusive access to
477  * specific functions.
478  *
479  * By default, the owner account will be the one that deploys the contract. This
480  * can later be changed with {transferOwnership}.
481  *
482  * This module is used through inheritance. It will make available the modifier
483  * `onlyOwner`, which can be applied to your functions to restrict their use to
484  * the owner.
485  */
486 abstract contract Ownable is Context {
487     address private _owner;
488 
489     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
490 
491     /**
492     * @dev Initializes the contract setting the deployer as the initial owner.
493     */
494     constructor () {
495         _owner = _msgSender();
496         emit OwnershipTransferred(address(0), _owner);
497     }
498 
499     /**
500     * @dev Returns the address of the current owner.
501     */
502     function owner() public view virtual returns (address) {
503         return _owner;
504     }
505 
506     /**
507     * @dev Throws if called by any account other than the owner.
508     */
509     modifier onlyOwner() {
510         require(owner() == _msgSender(), "Ownable: caller is not the owner");
511         _;
512     }
513 
514     /**
515     * @dev Leaves the contract without owner. It will not be possible to call
516     * `onlyOwner` functions anymore. Can only be called by the current owner.
517     *
518     * NOTE: Renouncing ownership will leave the contract without an owner,
519     * thereby removing any functionality that is only available to the owner.
520     */
521     function renounceOwnership() public virtual onlyOwner {
522         emit OwnershipTransferred(_owner, address(0));
523         _owner = address(0);
524     }
525 
526     /**
527     * @dev Transfers ownership of the contract to a new account (`newOwner`).
528     * Can only be called by the current owner.
529     */
530     function transferOwnership(address newOwner) public virtual onlyOwner {
531         require(newOwner != address(0), "Ownable: new owner is the zero address");
532         emit OwnershipTransferred(_owner, newOwner);
533         _owner = newOwner;
534     }
535 }
536 
537 interface IUniswapV2Factory {
538     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
539 
540     function feeTo() external view returns (address);
541     function feeToSetter() external view returns (address);
542 
543     function getPair(address tokenA, address tokenB) external view returns (address pair);
544     function allPairs(uint) external view returns (address pair);
545     function allPairsLength() external view returns (uint);
546 
547     function createPair(address tokenA, address tokenB) external returns (address pair);
548 
549     function setFeeTo(address) external;
550     function setFeeToSetter(address) external;
551 }
552 
553 interface IUniswapV2Pair {
554     event Approval(address indexed owner, address indexed spender, uint value);
555     event Transfer(address indexed from, address indexed to, uint value);
556 
557     function name() external pure returns (string memory);
558     function symbol() external pure returns (string memory);
559     function decimals() external pure returns (uint8);
560     function totalSupply() external view returns (uint);
561     function balanceOf(address owner) external view returns (uint);
562     function allowance(address owner, address spender) external view returns (uint);
563 
564     function approve(address spender, uint value) external returns (bool);
565     function transfer(address to, uint value) external returns (bool);
566     function transferFrom(address from, address to, uint value) external returns (bool);
567 
568     function DOMAIN_SEPARATOR() external view returns (bytes32);
569     function PERMIT_TYPEHASH() external pure returns (bytes32);
570     function nonces(address owner) external view returns (uint);
571 
572     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
573 
574     event Mint(address indexed sender, uint amount0, uint amount1);
575     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
576     event Swap(
577         address indexed sender,
578         uint amount0In,
579         uint amount1In,
580         uint amount0Out,
581         uint amount1Out,
582         address indexed to
583     );
584     event Sync(uint112 reserve0, uint112 reserve1);
585 
586     function MINIMUM_LIQUIDITY() external pure returns (uint);
587     function factory() external view returns (address);
588     function token0() external view returns (address);
589     function token1() external view returns (address);
590     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
591     function price0CumulativeLast() external view returns (uint);
592     function price1CumulativeLast() external view returns (uint);
593     function kLast() external view returns (uint);
594 
595     function mint(address to) external returns (uint liquidity);
596     function burn(address to) external returns (uint amount0, uint amount1);
597     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
598     function skim(address to) external;
599     function sync() external;
600 
601     function initialize(address, address) external;
602 }
603 
604 interface IUniswapV2Router01 {
605     function factory() external pure returns (address);
606     function WETH() external pure returns (address);
607 
608     function addLiquidity(
609         address tokenA,
610         address tokenB,
611         uint amountADesired,
612         uint amountBDesired,
613         uint amountAMin,
614         uint amountBMin,
615         address to,
616         uint deadline
617     ) external returns (uint amountA, uint amountB, uint liquidity);
618     function addLiquidityETH(
619         address token,
620         uint amountTokenDesired,
621         uint amountTokenMin,
622         uint amountETHMin,
623         address to,
624         uint deadline
625     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
626     function removeLiquidity(
627         address tokenA,
628         address tokenB,
629         uint liquidity,
630         uint amountAMin,
631         uint amountBMin,
632         address to,
633         uint deadline
634     ) external returns (uint amountA, uint amountB);
635     function removeLiquidityETH(
636         address token,
637         uint liquidity,
638         uint amountTokenMin,
639         uint amountETHMin,
640         address to,
641         uint deadline
642     ) external returns (uint amountToken, uint amountETH);
643     function removeLiquidityWithPermit(
644         address tokenA,
645         address tokenB,
646         uint liquidity,
647         uint amountAMin,
648         uint amountBMin,
649         address to,
650         uint deadline,
651         bool approveMax, uint8 v, bytes32 r, bytes32 s
652     ) external returns (uint amountA, uint amountB);
653     function removeLiquidityETHWithPermit(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline,
660         bool approveMax, uint8 v, bytes32 r, bytes32 s
661     ) external returns (uint amountToken, uint amountETH);
662     function swapExactTokensForTokens(
663         uint amountIn,
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external returns (uint[] memory amounts);
669     function swapTokensForExactTokens(
670         uint amountOut,
671         uint amountInMax,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external returns (uint[] memory amounts);
676     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
677         external
678         payable
679         returns (uint[] memory amounts);
680     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
681         external
682         returns (uint[] memory amounts);
683     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
684         external
685         returns (uint[] memory amounts);
686     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
687         external
688         payable
689         returns (uint[] memory amounts);
690 
691     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
692     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
693     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
694     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
695     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
696 }
697 
698 interface IUniswapV2Router02 is IUniswapV2Router01 {
699     function removeLiquidityETHSupportingFeeOnTransferTokens(
700         address token,
701         uint liquidity,
702         uint amountTokenMin,
703         uint amountETHMin,
704         address to,
705         uint deadline
706     ) external returns (uint amountETH);
707     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
708         address token,
709         uint liquidity,
710         uint amountTokenMin,
711         uint amountETHMin,
712         address to,
713         uint deadline,
714         bool approveMax, uint8 v, bytes32 r, bytes32 s
715     ) external returns (uint amountETH);
716 
717     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
718         uint amountIn,
719         uint amountOutMin,
720         address[] calldata path,
721         address to,
722         uint deadline
723     ) external;
724     function swapExactETHForTokensSupportingFeeOnTransferTokens(
725         uint amountOutMin,
726         address[] calldata path,
727         address to,
728         uint deadline
729     ) external payable;
730     function swapExactTokensForETHSupportingFeeOnTransferTokens(
731         uint amountIn,
732         uint amountOutMin,
733         address[] calldata path,
734         address to,
735         uint deadline
736     ) external;
737 }
738 
739 
740 contract GatsbyInu is Context, IERC20, Ownable {
741     using SafeMath for uint256;
742     using Address for address;
743 
744     uint8 private _decimals = 9;
745 
746     // 
747     string private _name = "Gatsby Inu";                                           // name
748     string private _symbol = "$GATSBYINU";                                            // symbol
749     uint256 private _tTotal = 1000 * 10**9 * 10**uint256(_decimals);
750 
751     // % to holders
752     uint256 public defaultTaxFee = 0;
753     uint256 public _taxFee = defaultTaxFee;
754     uint256 private _previousTaxFee = _taxFee;
755 
756     // % to swap & send to marketing wallet
757     uint256 public defaultMarketingFee = 9;
758     uint256 public _marketingFee = defaultMarketingFee;
759     uint256 private _previousMarketingFee = _marketingFee;
760 
761     uint256 public _marketingFee4Sellers = 9;
762 
763     bool public feesOnSellersAndBuyers = true;
764 
765     uint256 public _maxTxAmount = _tTotal.div(1).div(49);
766     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
767     address payable public marketingWallet = payable(0xc80837E8e3b6F4b440899efAA3A5eEF29Cdd5499);
768 
769     //
770 
771     mapping (address => uint256) private _rOwned;
772     mapping (address => uint256) private _tOwned;
773     mapping (address => mapping (address => uint256)) private _allowances;
774 
775     mapping (address => bool) private _isExcludedFromFee;
776 
777     mapping (address => bool) private _isExcluded;
778     
779     mapping (address => bool) public _isBlacklisted;
780 
781     address[] private _excluded;
782     uint256 private constant MAX = ~uint256(0);
783 
784     uint256 private _tFeeTotal;
785     uint256 private _rTotal = (MAX - (MAX % _tTotal));
786 
787     IUniswapV2Router02 public immutable uniswapV2Router;
788     address public immutable uniswapV2Pair;
789 
790     bool inSwapAndSend;
791     bool public SwapAndSendEnabled = true;
792 
793     event SwapAndSendEnabledUpdated(bool enabled);
794 
795     modifier lockTheSwap {
796         inSwapAndSend = true;
797         _;
798         inSwapAndSend = false;
799     }
800 
801     constructor () {
802         _rOwned[_msgSender()] = _rTotal;
803 
804         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
805          // Create a uniswap pair for this new token
806         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
807             .createPair(address(this), _uniswapV2Router.WETH());
808 
809         // set the rest of the contract variables
810         uniswapV2Router = _uniswapV2Router;
811 
812         //exclude owner and this contract from fee
813         _isExcludedFromFee[owner()] = true;
814         _isExcludedFromFee[address(this)] = true;
815 
816         emit Transfer(address(0), _msgSender(), _tTotal);
817     }
818 
819     function name() public view returns (string memory) {
820         return _name;
821     }
822 
823     function symbol() public view returns (string memory) {
824         return _symbol;
825     }
826 
827     function decimals() public view returns (uint8) {
828         return _decimals;
829     }
830 
831     function totalSupply() public view override returns (uint256) {
832         return _tTotal;
833     }
834 
835     function balanceOf(address account) public view override returns (uint256) {
836         if (_isExcluded[account]) return _tOwned[account];
837         return tokenFromReflection(_rOwned[account]);
838     }
839 
840     function transfer(address recipient, uint256 amount) public override returns (bool) {
841         _transfer(_msgSender(), recipient, amount);
842         return true;
843     }
844 
845     function allowance(address owner, address spender) public view override returns (uint256) {
846         return _allowances[owner][spender];
847     }
848 
849     function approve(address spender, uint256 amount) public override returns (bool) {
850         _approve(_msgSender(), spender, amount);
851         return true;
852     }
853 
854     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
855         _transfer(sender, recipient, amount);
856         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
857         return true;
858     }
859 
860     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
861         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
862         return true;
863     }
864 
865     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
866         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
867         return true;
868     }
869 
870     function isExcludedFromReward(address account) public view returns (bool) {
871         return _isExcluded[account];
872     }
873 
874     function totalFees() public view returns (uint256) {
875         return _tFeeTotal;
876     }
877 
878     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
879         require(tAmount <= _tTotal, "Amount must be less than supply");
880         if (!deductTransferFee) {
881             (uint256 rAmount,,,,,) = _getValues(tAmount);
882             return rAmount;
883         } else {
884             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
885             return rTransferAmount;
886         }
887     }
888 
889     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
890         require(rAmount <= _rTotal, "Amount must be less than total reflections");
891         uint256 currentRate =  _getRate();
892         return rAmount.div(currentRate);
893     }
894 
895     function excludeFromReward(address account) public onlyOwner() {
896         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
897         require(!_isExcluded[account], "Account is already excluded");
898         if(_rOwned[account] > 0) {
899             _tOwned[account] = tokenFromReflection(_rOwned[account]);
900         }
901         _isExcluded[account] = true;
902         _excluded.push(account);
903     }
904 
905     function includeInReward(address account) external onlyOwner() {
906         require(_isExcluded[account], "Account is already excluded");
907         for (uint256 i = 0; i < _excluded.length; i++) {
908             if (_excluded[i] == account) {
909                 _excluded[i] = _excluded[_excluded.length - 1];
910                 _tOwned[account] = 0;
911                 _isExcluded[account] = false;
912                 _excluded.pop();
913                 break;
914             }
915         }
916     }
917 
918     function excludeFromFee(address account) public onlyOwner() {
919         _isExcludedFromFee[account] = true;
920     }
921 
922     function includeInFee(address account) public onlyOwner() {
923         _isExcludedFromFee[account] = false;
924     }
925 
926     function removeAllFee() private {
927         if(_taxFee == 0 && _marketingFee == 0) return;
928 
929         _previousTaxFee = _taxFee;
930         _previousMarketingFee = _marketingFee;
931 
932         _taxFee = 0;
933         _marketingFee = 0;
934     }
935 
936     function restoreAllFee() private {
937         _taxFee = _previousTaxFee;
938         _marketingFee = _previousMarketingFee;
939     }
940 
941     //to recieve ETH
942     receive() external payable {}
943 
944     function _reflectFee(uint256 rFee, uint256 tFee) private {
945         _rTotal = _rTotal.sub(rFee);
946         _tFeeTotal = _tFeeTotal.add(tFee);
947     }
948     
949      function addToBlackList(address[] calldata addresses) external onlyOwner {
950       for (uint256 i; i < addresses.length; ++i) {
951         _isBlacklisted[addresses[i]] = true;
952       }
953     }
954     
955       function removeFromBlackList(address account) external onlyOwner {
956         _isBlacklisted[account] = false;
957     }
958 
959     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
960         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
961         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
962         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
963     }
964 
965     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
966         uint256 tFee = calculateTaxFee(tAmount);
967         uint256 tMarketing = calculateMarketingFee(tAmount);
968         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
969         return (tTransferAmount, tFee, tMarketing);
970     }
971 
972     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
973         uint256 rAmount = tAmount.mul(currentRate);
974         uint256 rFee = tFee.mul(currentRate);
975         uint256 rMarketing = tMarketing.mul(currentRate);
976         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
977         return (rAmount, rTransferAmount, rFee);
978     }
979 
980     function _getRate() private view returns(uint256) {
981         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
982         return rSupply.div(tSupply);
983     }
984 
985     function _getCurrentSupply() private view returns(uint256, uint256) {
986         uint256 rSupply = _rTotal;
987         uint256 tSupply = _tTotal;
988         for (uint256 i = 0; i < _excluded.length; i++) {
989             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
990             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
991             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
992         }
993         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
994         return (rSupply, tSupply);
995     }
996 
997     function _takeMarketing(uint256 tMarketing) private {
998         uint256 currentRate =  _getRate();
999         uint256 rMarketing = tMarketing.mul(currentRate);
1000         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1001         if(_isExcluded[address(this)])
1002             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1003     }
1004 
1005     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1006         return _amount.mul(_taxFee).div(
1007             10**2
1008         );
1009     }
1010 
1011     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1012         return _amount.mul(_marketingFee).div(
1013             10**2
1014         );
1015     }
1016 
1017     function isExcludedFromFee(address account) public view returns(bool) {
1018         return _isExcludedFromFee[account];
1019     }
1020 
1021     function _approve(address owner, address spender, uint256 amount) private {
1022         require(owner != address(0), "ERC20: approve from the zero address");
1023         require(spender != address(0), "ERC20: approve to the zero address");
1024 
1025         _allowances[owner][spender] = amount;
1026         emit Approval(owner, spender, amount);
1027     }
1028 
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 amount
1033     ) private {
1034         require(from != address(0), "ERC20: transfer from the zero address");
1035         require(to != address(0), "ERC20: transfer to the zero address");
1036         require(amount > 0, "Transfer amount must be greater than zero");
1037         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted");
1038 
1039         if(from != owner() && to != owner())
1040             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1041 
1042         // is the token balance of this contract address over the min number of
1043         // tokens that we need to initiate a swap + send lock?
1044         // also, don't get caught in a circular sending event.
1045         // also, don't swap & liquify if sender is uniswap pair.
1046         uint256 contractTokenBalance = balanceOf(address(this));
1047         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1048 
1049         if(contractTokenBalance >= _maxTxAmount)
1050         {
1051             contractTokenBalance = _maxTxAmount;
1052         }
1053 
1054         if (
1055             overMinTokenBalance &&
1056             !inSwapAndSend &&
1057             from != uniswapV2Pair &&
1058             SwapAndSendEnabled
1059         ) {
1060             SwapAndSend(contractTokenBalance);
1061         }
1062 
1063         if(feesOnSellersAndBuyers) {
1064             setFees(to);
1065         }
1066 
1067         //indicates if fee should be deducted from transfer
1068         bool takeFee = true;
1069 
1070         //if any account belongs to _isExcludedFromFee account then remove the fee
1071         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1072             takeFee = false;
1073         }
1074 
1075         _tokenTransfer(from,to,amount,takeFee);
1076     }
1077 
1078     function setFees(address recipient) private {
1079         _taxFee = defaultTaxFee;
1080         _marketingFee = defaultMarketingFee;
1081         if (recipient == uniswapV2Pair) { // sell
1082             _marketingFee = _marketingFee4Sellers;
1083         }
1084     }
1085 
1086     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1087         // generate the uniswap pair path of token -> weth
1088         address[] memory path = new address[](2);
1089         path[0] = address(this);
1090         path[1] = uniswapV2Router.WETH();
1091 
1092         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1093 
1094         // make the swap
1095         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1096             contractTokenBalance,
1097             0, // accept any amount of ETH
1098             path,
1099             address(this),
1100             block.timestamp
1101         );
1102 
1103         uint256 contractETHBalance = address(this).balance;
1104         if(contractETHBalance > 0) {
1105             marketingWallet.transfer(contractETHBalance);
1106         }
1107     }
1108 
1109     //this method is responsible for taking all fee, if takeFee is true
1110     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1111         if(!takeFee)
1112             removeAllFee();
1113 
1114         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1115             _transferFromExcluded(sender, recipient, amount);
1116         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1117             _transferToExcluded(sender, recipient, amount);
1118         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1119             _transferStandard(sender, recipient, amount);
1120         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1121             _transferBothExcluded(sender, recipient, amount);
1122         } else {
1123             _transferStandard(sender, recipient, amount);
1124         }
1125 
1126         if(!takeFee)
1127             restoreAllFee();
1128     }
1129 
1130     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1131         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1132         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1133         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1134         _takeMarketing(tMarketing);
1135         _reflectFee(rFee, tFee);
1136         emit Transfer(sender, recipient, tTransferAmount);
1137     }
1138 
1139     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1140         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1141         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1142         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1143         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1144         _takeMarketing(tMarketing);
1145         _reflectFee(rFee, tFee);
1146         emit Transfer(sender, recipient, tTransferAmount);
1147     }
1148 
1149     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1150         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1151         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1152         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1153         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1154         _takeMarketing(tMarketing);
1155         _reflectFee(rFee, tFee);
1156         emit Transfer(sender, recipient, tTransferAmount);
1157     }
1158 
1159     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1161         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1162         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1163         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1164         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1165         _takeMarketing(tMarketing);
1166         _reflectFee(rFee, tFee);
1167         emit Transfer(sender, recipient, tTransferAmount);
1168     }
1169 
1170     function setDefaultMarketingFee(uint256 marketingFee) external onlyOwner() {
1171         defaultMarketingFee = marketingFee;
1172     }
1173 
1174     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyOwner() {
1175         _marketingFee4Sellers = marketingFee4Sellers;
1176     }
1177 
1178     function setFeesOnSellersAndBuyers(bool _enabled) public onlyOwner() {
1179         feesOnSellersAndBuyers = _enabled;
1180     }
1181 
1182     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1183         SwapAndSendEnabled = _enabled;
1184         emit SwapAndSendEnabledUpdated(_enabled);
1185     }
1186 
1187     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1188         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1189     }
1190 
1191     function _setMarketingWallet(address payable wallet) external onlyOwner() {
1192         marketingWallet = wallet;
1193     }
1194     
1195     
1196 
1197     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1198         _maxTxAmount = maxTxAmount;
1199     }
1200 }