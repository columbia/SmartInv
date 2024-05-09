1 /**
2  *Submitted for verification at BscScan.com on 2021-07-10
3 */
4 
5 /**
6    #MContent
7    5% fee auto add to the liquidity pool to locked forever when selling
8    1% fee auto distributed to all holders
9    4% fee auto contributed to Content Creators Fund wallet
10 */
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.3;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79 
80      function mint(address from, uint256 value) external;
81     function burn(address from, uint256 value) external;
82 
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 // CAUTION
94 // This version of SafeMath should only be used with Solidity 0.8 or later,
95 // because it relies on the compiler's built in overflow checks.
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations.
99  *
100  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
101  * now has built in overflow checking.
102  */
103 library SafeMath {
104    
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      *
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a + b;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a - b;
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `*` operator.
138      *
139      * Requirements:
140      *
141      * - Multiplication cannot overflow.
142      */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a * b;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers, reverting on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator.
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function div(uint256 a, uint256 b) internal pure returns (uint256) {
158         return a / b;
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * reverting when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
177      * overflow (when the result is negative).
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {trySub}.
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      *
186      * - Subtraction cannot overflow.
187      */
188     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         unchecked {
190             require(b <= a, errorMessage);
191             return a - b;
192         }
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a / b;
215         }
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting with custom message when dividing by zero.
221      *
222      * CAUTION: This function is deprecated because it requires allocating memory for the error
223      * message unnecessarily. For custom revert reasons use {tryMod}.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     
234 }
235 
236 /*
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     
252 }
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize, which returns 0 for contracts in
277         // construction, since the code is only stored at the end of the
278         // constructor execution.
279 
280         uint256 size;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { size := extcodesize(account) }
283         return size > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
306         (bool success, ) = recipient.call{ value: amount }("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329       return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: value }(data);
369         return _verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
379         return functionStaticCall(target, data, "Address: low-level static call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return _verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
421         if (success) {
422             return returndata;
423         } else {
424             // Look for revert reason and bubble it up if present
425             if (returndata.length > 0) {
426                 // The easiest way to bubble the revert reason is using memory via assembly
427 
428                 // solhint-disable-next-line no-inline-assembly
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 /**
441  * @dev Contract module which provides a basic access control mechanism, where
442  * there is an account (an owner) that can be granted exclusive access to
443  * specific functions.
444  *
445  * By default, the owner account will be the one that deploys the contract. This
446  * can later be changed with {transferOwnership}.
447  *
448  * This module is used through inheritance. It will make available the modifier
449  * `onlyOwner`, which can be applied to your functions to restrict their use to
450  * the owner.
451  */
452 abstract contract Ownable is Context {
453     address private _owner;
454 
455     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
456 
457     /**
458      * @dev Initializes the contract setting the deployer as the initial owner.
459      */
460     constructor () {
461      
462         _owner = 0x992Cd46dfE21377bef5A5178F8b8349de2C37453;
463         emit OwnershipTransferred(address(0), _owner);
464     }
465 
466     /**
467      * @dev Returns the address of the current owner.
468      */
469     function owner() public view virtual returns (address) {
470         return _owner;
471     }
472 
473     /**
474      * @dev Throws if called by any account other than the owner.
475      */
476     modifier onlyOwner() {
477         require(owner() == _msgSender(), "Ownable: caller is not the owner");
478         _;
479     }
480 
481     /**
482      * @dev Leaves the contract without owner. It will not be possible to call
483      * `onlyOwner` functions anymore. Can only be called by the current owner.
484      *
485      * NOTE: Renouncing ownership will leave the contract without an owner,
486      * thereby removing any functionality that is only available to the owner.
487      */
488     function renounceOwnership() public virtual onlyOwner {
489         emit OwnershipTransferred(_owner, address(0));
490         _owner = address(0);
491     }
492 
493     /**
494      * @dev Transfers ownership of the contract to a new account (`newOwner`).
495      * Can only be called by the current owner.
496      */
497     function transferOwnership(address newOwner) public virtual onlyOwner {
498         require(newOwner != address(0), "Ownable: new owner is the zero address");
499         emit OwnershipTransferred(_owner, newOwner);
500         _owner = newOwner;
501     }
502 }
503 
504 interface IUniswapV2Factory {
505     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
506 
507     function feeTo() external view returns (address);
508     function feeToSetter() external view returns (address);
509 
510     function getPair(address tokenA, address tokenB) external view returns (address pair);
511     function allPairs(uint) external view returns (address pair);
512     function allPairsLength() external view returns (uint);
513 
514     function createPair(address tokenA, address tokenB) external returns (address pair);
515 
516     function setFeeTo(address) external;
517     function setFeeToSetter(address) external;
518 }
519 
520 interface IUniswapV2Pair {
521     event Approval(address indexed owner, address indexed spender, uint value);
522     event Transfer(address indexed from, address indexed to, uint value);
523 
524     function name() external pure returns (string memory);
525     function symbol() external pure returns (string memory);
526     function decimals() external pure returns (uint8);
527     function totalSupply() external view returns (uint);
528     function balanceOf(address owner) external view returns (uint);
529     function allowance(address owner, address spender) external view returns (uint);
530 
531     function approve(address spender, uint value) external returns (bool);
532     function transfer(address to, uint value) external returns (bool);
533     function transferFrom(address from, address to, uint value) external returns (bool);
534 
535     function DOMAIN_SEPARATOR() external view returns (bytes32);
536     function PERMIT_TYPEHASH() external pure returns (bytes32);
537     function nonces(address owner) external view returns (uint);
538 
539     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
540 
541     event Mint(address indexed sender, uint amount0, uint amount1);
542     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
543     event Swap(
544         address indexed sender,
545         uint amount0In,
546         uint amount1In,
547         uint amount0Out,
548         uint amount1Out,
549         address indexed to
550     );
551     event Sync(uint112 reserve0, uint112 reserve1);
552 
553     function MINIMUM_LIQUIDITY() external pure returns (uint);
554     function factory() external view returns (address);
555     function token0() external view returns (address);
556     function token1() external view returns (address);
557     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
558     function price0CumulativeLast() external view returns (uint);
559     function price1CumulativeLast() external view returns (uint);
560     function kLast() external view returns (uint);
561 
562     function mint(address to) external returns (uint liquidity);
563     function burn(address to) external returns (uint amount0, uint amount1);
564     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
565     function skim(address to) external;
566     function sync() external;
567 
568     function initialize(address, address) external;
569 }
570 
571 interface IUniswapV2Router01 {
572     function factory() external pure returns (address);
573     function WETH() external pure returns (address);
574 
575     function addLiquidity(
576         address tokenA,
577         address tokenB,
578         uint amountADesired,
579         uint amountBDesired,
580         uint amountAMin,
581         uint amountBMin,
582         address to,
583         uint deadline
584     ) external returns (uint amountA, uint amountB, uint liquidity);
585     function addLiquidityETH(
586         address token,
587         uint amountTokenDesired,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
593     function removeLiquidity(
594         address tokenA,
595         address tokenB,
596         uint liquidity,
597         uint amountAMin,
598         uint amountBMin,
599         address to,
600         uint deadline
601     ) external returns (uint amountA, uint amountB);
602     function removeLiquidityETH(
603         address token,
604         uint liquidity,
605         uint amountTokenMin,
606         uint amountETHMin,
607         address to,
608         uint deadline
609     ) external returns (uint amountToken, uint amountETH);
610     function removeLiquidityWithPermit(
611         address tokenA,
612         address tokenB,
613         uint liquidity,
614         uint amountAMin,
615         uint amountBMin,
616         address to,
617         uint deadline,
618         bool approveMax, uint8 v, bytes32 r, bytes32 s
619     ) external returns (uint amountA, uint amountB);
620     function removeLiquidityETHWithPermit(
621         address token,
622         uint liquidity,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline,
627         bool approveMax, uint8 v, bytes32 r, bytes32 s
628     ) external returns (uint amountToken, uint amountETH);
629     function swapExactTokensForTokens(
630         uint amountIn,
631         uint amountOutMin,
632         address[] calldata path,
633         address to,
634         uint deadline
635     ) external returns (uint[] memory amounts);
636     function swapTokensForExactTokens(
637         uint amountOut,
638         uint amountInMax,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external returns (uint[] memory amounts);
643     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
644         external
645         payable
646         returns (uint[] memory amounts);
647     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
648         external
649         returns (uint[] memory amounts);
650     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
651         external
652         returns (uint[] memory amounts);
653     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
654         external
655         payable
656         returns (uint[] memory amounts);
657 
658     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
659     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
660     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
661     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
662     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
663 }
664 
665 interface IUniswapV2Router02 is IUniswapV2Router01 {
666     function removeLiquidityETHSupportingFeeOnTransferTokens(
667         address token,
668         uint liquidity,
669         uint amountTokenMin,
670         uint amountETHMin,
671         address to,
672         uint deadline
673     ) external returns (uint amountETH);
674     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
675         address token,
676         uint liquidity,
677         uint amountTokenMin,
678         uint amountETHMin,
679         address to,
680         uint deadline,
681         bool approveMax, uint8 v, bytes32 r, bytes32 s
682     ) external returns (uint amountETH);
683 
684     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
685         uint amountIn,
686         uint amountOutMin,
687         address[] calldata path,
688         address to,
689         uint deadline
690     ) external;
691     function swapExactETHForTokensSupportingFeeOnTransferTokens(
692         uint amountOutMin,
693         address[] calldata path,
694         address to,
695         uint deadline
696     ) external payable;
697     function swapExactTokensForETHSupportingFeeOnTransferTokens(
698         uint amountIn,
699         uint amountOutMin,
700         address[] calldata path,
701         address to,
702         uint deadline
703     ) external;
704 }
705 
706 contract ethMContent is Context, IERC20, Ownable {
707     using SafeMath for uint256;
708     using Address for address;
709 
710     mapping (address => uint256) private _rOwned;
711     mapping (address => uint256) private _tOwned;
712     mapping (address => mapping (address => uint256)) private _allowances;
713 
714     mapping (address => bool) private _isExcludedFromFee;
715 
716     mapping (address => bool) private _isExcluded;
717     mapping(address => bool) public adminAddresses;
718     address[] private _excluded;
719 
720 
721     address private _contentWalletAddress = 0x38A294f69ce947573bea45D94FbC450109FabBb5;
722    
723       
724     uint256 private _tTotal =1*10**0;
725     uint256 private _rTotal =  2**128;  
726     uint256 private _tFeeTotal;
727 
728     string private constant _name = "MContent";
729     string private constant _symbol = "MCONTENT";
730     uint8 private  constant _decimals = 6;
731     
732     uint256 public _taxFee = 1;
733     uint256 private _previousTaxFee = _taxFee;
734     
735     uint256 public _contentFee = 4;
736     uint256 private _previousContentFee = _contentFee;
737     uint256 public _liquidityFee = 5;
738     uint256 private _previousLiquidityFee = _liquidityFee;
739 
740     IUniswapV2Router02 public uniswapV2Router;
741     address public uniswapV2Pair;
742     
743     bool inSwapAndLiquify;
744     bool public swapAndLiquifyEnabled = true;
745     
746     uint256 public _maxTxAmount = 100000000000000; //Now set to 1% of totalSupply, "50000 * 10**6 * 10**9" would be 0.5% of supply
747     uint256 private constant numTokensSellToAddToLiquidity = 10000 * 10**6 * 10**9; //set to 0.1% of totalSupply to trigger LP event 
748     
749     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
750     event SwapAndLiquifyEnabledUpdated(bool enabled);
751     event SwapAndLiquify(
752         uint256 tokensSwapped,
753         uint256 ethReceived,
754         uint256 tokensIntoLiqudity
755     );
756     event Mint(uint256 amount, address mintAddress);
757     event Burn(uint256 amount, address burnAddress);
758     event LiquidityFeePercentUpdated(uint256 liquidityFee , address updatedBy);
759     event MaxTxPercentUpdated(uint256 maxTxPercent , address updatedBy);
760     event ContentFeePercentUpdated(uint256 contentFee , address updatedBy);
761     event TaxFeePercentUpdated(uint256 taxFee, address updatedBy);
762 
763     modifier lockTheSwap {
764         inSwapAndLiquify = true;
765         _;
766         inSwapAndLiquify = false;
767     }
768     
769     constructor () {
770         _rOwned[owner()] = _rTotal;
771         
772         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
773     //      //Create a uniswap pair for this new token
774        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
775            .createPair(address(this), _uniswapV2Router.WETH());
776 
777     //     // set the rest of the contract variables
778         uniswapV2Router = _uniswapV2Router;
779         
780         //exclude owner and this contract from fee
781         _isExcludedFromFee[owner()] = true;
782         _isExcludedFromFee[address(this)] = true;
783 
784         adminAddresses[0x992Cd46dfE21377bef5A5178F8b8349de2C37453] = true;
785         
786         emit Transfer(address(0), owner(), _tTotal);
787     }
788 
789     function name() public view returns (string memory) {
790         return _name;
791     }
792 
793     function symbol() public view returns (string memory) {
794         return _symbol;
795     }
796 
797     function decimals() public view returns (uint8) {
798         return _decimals;
799     }
800 
801     function totalSupply() public view override returns (uint256) {
802         return _tTotal;
803     }
804 
805     function balanceOf(address account) public view override returns (uint256) {
806         if (_isExcluded[account]) return _tOwned[account];
807         return tokenFromReflection(_rOwned[account]);
808     }
809 
810     function transfer(address recipient, uint256 amount) public override returns (bool) {
811         _transfer(_msgSender(), recipient, amount);
812         return true;
813     }
814 
815     function allowance(address owner, address spender) public view override returns (uint256) {
816         return _allowances[owner][spender];
817     }
818 
819     function approve(address spender, uint256 amount) public override returns (bool) {
820         _approve(_msgSender(), spender, amount);
821         return true;
822     }
823 
824     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
825         _transfer(sender, recipient, amount);
826         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
827         return true;
828     }
829 
830     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
831         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
832         return true;
833     }
834 
835     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
836         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
837         return true;
838     }
839 
840     function isExcludedFromReward(address account) external view returns (bool) {
841         return _isExcluded[account];
842     }
843 
844     function totalFees() external view returns (uint256) {
845         return _tFeeTotal;
846     }
847 
848     function deliver(uint256 tAmount) external {
849         address sender = _msgSender();
850         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
851         (uint256 rAmount,,,,,,) = _getValues(tAmount);
852         _rOwned[sender] = _rOwned[sender].sub(rAmount);
853         _rTotal = _rTotal.sub(rAmount);
854         _tFeeTotal = _tFeeTotal.add(tAmount);
855     }
856 
857     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
858         require(tAmount <= _tTotal, "Amount must be less than supply");
859         if (!deductTransferFee) {
860             (uint256 rAmount,,,,,,) = _getValues(tAmount);
861             return rAmount;
862         } else {
863             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
864             return rTransferAmount;
865         }
866     }
867 
868     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
869         require(rAmount <= _rTotal, "Amount must be less than total reflections");
870         uint256 currentRate =  _getRate();
871         return rAmount.div(currentRate);
872     }
873 
874     function excludeFromReward(address account) external onlyOwner() {
875         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
876         require(!_isExcluded[account], "Account is already excluded");
877         if(_rOwned[account] > 0) {
878             _tOwned[account] = tokenFromReflection(_rOwned[account]);
879         }
880         _isExcluded[account] = true;
881         _excluded.push(account);
882     }
883 
884     function includeInReward(address account) external onlyOwner() {
885         require(_isExcluded[account], "Account is already included");
886         for (uint256 i = 0; i < _excluded.length; i++) {
887             if (_excluded[i] == account) {
888                 _excluded[i] = _excluded[_excluded.length - 1];
889                 _tOwned[account] = 0;
890                 _isExcluded[account] = false;
891                 _excluded.pop();
892                 break;
893             }
894         }
895     }
896         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
897         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tContent) = _getValues(tAmount);
898         _tOwned[sender] = _tOwned[sender].sub(tAmount);
899         _rOwned[sender] = _rOwned[sender].sub(rAmount);
900         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
901         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
902         _takeLiquidity(tLiquidity);
903         _takeContent(tContent);
904         _reflectFee(rFee, tFee);
905         emit Transfer(sender, recipient, tTransferAmount);
906     }
907     
908         function excludeFromFee(address account) external onlyOwner {
909         _isExcludedFromFee[account] = true;
910     }
911     
912     function includeInFee(address account) external onlyOwner {
913         _isExcludedFromFee[account] = false;
914     }
915     
916     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
917         _taxFee = taxFee;
918         require(_taxFee+_contentFee+_liquidityFee < 25 , "Can't set the TaxFee greater than 25%");
919          emit TaxFeePercentUpdated(taxFee , _msgSender());
920     }
921 
922     function setContentFeePercent(uint256 contentFee) external onlyOwner() {
923         _contentFee = contentFee;
924          require(_taxFee+_contentFee+_liquidityFee < 25 , "Can't set the TaxFee greater than 25%");
925         emit ContentFeePercentUpdated(contentFee ,_msgSender());
926     }
927     
928     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
929         _liquidityFee = liquidityFee;
930         require(_taxFee+_contentFee+_liquidityFee < 25 , "Can't set the TaxFee greater than 25%");
931         emit LiquidityFeePercentUpdated(liquidityFee ,_msgSender());
932     }
933    
934     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
935          uint256 _minTxAmount = (_tTotal.mul(100000000000000000)).div(100000000000000000000);
936         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
937             10**2
938         );
939         require(_maxTxAmount >= _minTxAmount,"Can't set the maxTxAmount less than 0.1% of tTotal");
940         emit MaxTxPercentUpdated(maxTxPercent ,_msgSender());
941     }
942 
943     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
944         swapAndLiquifyEnabled = _enabled;
945         emit SwapAndLiquifyEnabledUpdated(_enabled);
946     }
947     
948      //to recieve ETH from uniswapV2Router when swaping
949     receive() external payable {}
950 
951     function _reflectFee(uint256 rFee, uint256 tFee) private {
952         _rTotal = _rTotal.sub(rFee);
953         _tFeeTotal = _tFeeTotal.add(tFee);
954     }
955 
956     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
957         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tContent) = _getTValues(tAmount);
958         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tContent, _getRate());
959         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tContent);
960     }
961 
962     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
963         uint256 tFee = calculateTaxFee(tAmount);
964         uint256 tLiquidity = calculateLiquidityFee(tAmount);
965         uint256 tContent = calculateContentFee(tAmount);
966         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tContent);
967         return (tTransferAmount, tFee, tLiquidity, tContent);
968     }
969 
970     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tContent, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
971         uint256 rAmount = tAmount.mul(currentRate);
972         uint256 rFee = tFee.mul(currentRate);
973         uint256 rLiquidity = tLiquidity.mul(currentRate);
974         uint256 rContent = tContent.mul(currentRate);
975         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rContent);
976         return (rAmount, rTransferAmount, rFee);
977     }
978 
979     function _getRate() private view returns(uint256) {
980         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
981         return rSupply.div(tSupply);
982     }
983 
984     function _getCurrentSupply() private view returns(uint256, uint256) {
985         uint256 rSupply = _rTotal;
986         uint256 tSupply = _tTotal;      
987         for (uint256 i = 0; i < _excluded.length; i++) {
988             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
989             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
990             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
991         }
992         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
993         return (rSupply, tSupply);
994     }
995     
996     function _takeLiquidity(uint256 tLiquidity) private {
997         uint256 currentRate =  _getRate();
998         uint256 rLiquidity = tLiquidity.mul(currentRate);
999         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1000         if(_isExcluded[address(this)])
1001             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1002     }
1003     
1004     function _takeContent(uint256 tContent) private {
1005         uint256 currentRate =  _getRate();
1006         uint256 rContent = tContent.mul(currentRate);
1007         _rOwned[_contentWalletAddress] = _rOwned[_contentWalletAddress].add(rContent);
1008         if(_isExcluded[_contentWalletAddress])
1009             _tOwned[_contentWalletAddress] = _tOwned[_contentWalletAddress].add(tContent);
1010     }
1011     
1012     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1013         return _amount.mul(_taxFee).div(
1014             10**2
1015         );
1016     }
1017 
1018     function calculateContentFee(uint256 _amount) private view returns (uint256) {
1019         return _amount.mul(_contentFee).div(
1020             10**2
1021         );
1022     }
1023 
1024     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1025         return _amount.mul(_liquidityFee).div(
1026             10**2
1027         );
1028     }
1029     
1030     function removeAllFee() private {
1031         if(_taxFee == 0 && _liquidityFee == 0) return;
1032         
1033         _previousTaxFee = _taxFee;
1034         _previousContentFee = _contentFee;
1035         _previousLiquidityFee = _liquidityFee;
1036         
1037         _taxFee = 0;
1038         _contentFee = 0;
1039         _liquidityFee = 0;
1040     }
1041     
1042     function restoreAllFee() private {
1043         _taxFee = _previousTaxFee;
1044         _contentFee = _previousContentFee;
1045         _liquidityFee = _previousLiquidityFee;
1046     }
1047     
1048     function isExcludedFromFee(address account) external view returns(bool) {
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
1068         if(from != owner() && to != owner())
1069             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1070 
1071         // is the token balance of this contract address over the min number of
1072         // tokens that we need to initiate a swap + liquidity lock?
1073         // also, don't get caught in a circular liquidity event.
1074         // also, don't swap & liquify if sender is uniswap pair.
1075         uint256 contractTokenBalance = balanceOf(address(this));
1076         
1077         if(contractTokenBalance >= _maxTxAmount)
1078         {
1079             contractTokenBalance = _maxTxAmount;
1080         }
1081         
1082         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1083         if (
1084             overMinTokenBalance &&
1085             !inSwapAndLiquify &&
1086             from != uniswapV2Pair &&
1087             swapAndLiquifyEnabled
1088         ) {
1089             contractTokenBalance = numTokensSellToAddToLiquidity;
1090             //add liquidity
1091             swapAndLiquify(contractTokenBalance);
1092         }
1093         
1094         //indicates if fee should be deducted from transfer
1095         bool takeFee = true;
1096         
1097         //if any account belongs to _isExcludedFromFee account then remove the fee
1098         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1099             takeFee = false;
1100         }
1101         
1102         //transfer amount, it will take tax, burn, liquidity fee
1103         _tokenTransfer(from,to,amount,takeFee);
1104     }
1105 
1106     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1107         // split the contract balance into halves
1108         uint256 half = contractTokenBalance.div(2);
1109         uint256 otherHalf = contractTokenBalance.sub(half);
1110 
1111         // capture the contract's current ETH balance.
1112         // this is so that we can capture exactly the amount of ETH that the
1113         // swap creates, and not make the liquidity event include any ETH that
1114         // has been manually sent to the contract
1115         uint256 initialBalance = address(this).balance;
1116 
1117         // swap tokens for ETH
1118         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1119 
1120         // how much ETH did we just swap into?
1121         uint256 newBalance = address(this).balance.sub(initialBalance);
1122 
1123         // add liquidity to uniswap
1124         addLiquidity(otherHalf, newBalance);
1125         
1126         emit SwapAndLiquify(half, newBalance, otherHalf);
1127     }
1128 
1129     function swapTokensForEth(uint256 tokenAmount) private {
1130         // generate the uniswap pair path of token -> weth
1131         address[] memory path = new address[](2);
1132         path[0] = address(this);
1133         path[1] = uniswapV2Router.WETH();
1134 
1135         _approve(address(this), address(uniswapV2Router), tokenAmount);
1136 
1137         // make the swap
1138         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1139             tokenAmount,
1140             0, // accept any amount of ETH
1141             path,
1142             address(this),
1143             block.timestamp
1144         );
1145     }
1146 
1147     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1148         // approve token transfer to cover all possible scenarios
1149         _approve(address(this), address(uniswapV2Router), tokenAmount);
1150 
1151         // add the liquidity
1152         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1153             address(this),
1154             tokenAmount,
1155             0, // slippage is unavoidable
1156             0, // slippage is unavoidable
1157             owner(),
1158             block.timestamp
1159         );
1160     }
1161 
1162     //this method is responsible for taking all fee, if takeFee is true
1163     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1164         if(!takeFee)
1165             removeAllFee();
1166         
1167         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1168             _transferFromExcluded(sender, recipient, amount);
1169         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1170             _transferToExcluded(sender, recipient, amount);
1171         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1172             _transferStandard(sender, recipient, amount);
1173         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1174             _transferBothExcluded(sender, recipient, amount);
1175         } else {
1176             _transferStandard(sender, recipient, amount);
1177         }
1178         
1179         if(!takeFee)
1180             restoreAllFee();
1181     }
1182 
1183     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1184         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tContent) = _getValues(tAmount);
1185         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1186         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1187         _takeLiquidity(tLiquidity);
1188         _takeContent(tContent);
1189         _reflectFee(rFee, tFee);
1190         emit Transfer(sender, recipient, tTransferAmount);
1191     }
1192 
1193     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1194         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tContent) = _getValues(tAmount);
1195         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1196         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1197         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1198         _takeLiquidity(tLiquidity);
1199         _takeContent(tContent);
1200         _reflectFee(rFee, tFee);
1201         emit Transfer(sender, recipient, tTransferAmount);
1202     }
1203 
1204     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1205         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tContent) = _getValues(tAmount);
1206         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1207         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1208         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1209         _takeLiquidity(tLiquidity);
1210         _takeContent(tContent);
1211         _reflectFee(rFee, tFee);
1212         emit Transfer(sender, recipient, tTransferAmount);
1213     }
1214       
1215     //Swaps Pancake router addresses
1216     function setRouterAddress(address newRouter) external onlyOwner() {
1217         IUniswapV2Router02 _newPancakeRouter = IUniswapV2Router02(newRouter);
1218         uniswapV2Pair = IUniswapV2Factory(_newPancakeRouter.factory()).createPair(address(this), _newPancakeRouter.WETH());
1219         uniswapV2Router = _newPancakeRouter;
1220     }
1221      
1222     function adminConfig(address adminAddress , bool isAdmin) external onlyOwner {
1223         adminAddresses[adminAddress] = isAdmin;
1224     }
1225 
1226     modifier onlyAdmin() {
1227         require(adminAddresses[_msgSender()], "Caller is not an admin.");
1228         _;
1229     }
1230     function _mint(address recipient, uint256 amount) private {
1231         require(amount > 0, "Transfer amount must be greater than zero");
1232         require(_tTotal + amount <=  10000000 * 10**6 * 10**9, "Total supply cannot exceed 10 SexTillion");
1233         
1234         uint256 _rTransferAmount = (amount.mul(_rTotal)).div(_tTotal);
1235         
1236         _tTotal = _tTotal.add(amount);
1237         _rTotal = _rTotal.add(_rTransferAmount);
1238 
1239         if (_isExcluded[recipient]) {
1240             _tOwned[recipient] = _tOwned[recipient].add(amount);
1241         }
1242 
1243         _rOwned[recipient] = _rOwned[recipient].add(_rTransferAmount);
1244 
1245         emit Transfer(address(0), recipient, amount);
1246     }
1247 
1248     function _burn(address senderAddress, uint256 amount) private {
1249         require(amount > 0, "Transfer amount must be greater than zero");
1250         require(amount <= balanceOf(senderAddress), "Insufficient balance");
1251  
1252 
1253         uint256 _rTransferAmount = (amount.mul(_rTotal)).div(_tTotal);
1254         
1255         _tTotal = _tTotal.sub(amount);
1256         _rTotal = _rTotal.sub(_rTransferAmount);
1257 
1258         if (_isExcluded[senderAddress]) {
1259             _tOwned[senderAddress] = _tOwned[senderAddress].sub(amount);
1260         }
1261 
1262         _rOwned[senderAddress] = _rOwned[senderAddress].sub(_rTransferAmount);
1263 
1264         emit Transfer(senderAddress, address(0), amount);
1265     }
1266 
1267     function mint(address recipient, uint256 value)
1268         external
1269         override
1270         onlyAdmin
1271         
1272     {
1273         _mint(recipient, value);
1274         emit Mint(value, recipient);
1275     }
1276 
1277     function burn(address fromAddress, uint256 value) external override onlyAdmin {
1278         _burn(fromAddress, value);
1279         emit Burn(value, fromAddress);
1280     }
1281 }