1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-15
3 */
4 
5 
6 
7 pragma solidity ^0.6.12;
8 // SPDX-License-Identifier: Unlicensed
9 interface IERC20 {
10 
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93  
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) {
158             return 0;
159         }
160 
161         uint256 c = a * b;
162         require(c / a == b, "SafeMath: multiplication overflow");
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers. Reverts on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         return mod(a, b, "SafeMath: modulo by zero");
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts with custom message when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236 
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address payable) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes memory) {
243         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
244         return msg.data;
245     }
246 }
247 
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 /**
388  * @dev Contract module which provides a basic access control mechanism, where
389  * there is an account (an owner) that can be granted exclusive access to
390  * specific functions.
391  *
392  * By default, the owner account will be the one that deploys the contract. This
393  * can later be changed with {transferOwnership}.
394  *
395  * This module is used through inheritance. It will make available the modifier
396  * `onlyOwner`, which can be applied to your functions to restrict their use to
397  * the owner.
398  */
399 contract Ownable is Context {
400     address private _owner;
401     address private _previousOwner;
402     uint256 private _lockTime;
403 
404     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
405 
406     /**
407      * @dev Initializes the contract setting the deployer as the initial owner.
408      */
409     constructor () internal {
410         address msgSender = _msgSender();
411         _owner = msgSender;
412         emit OwnershipTransferred(address(0), msgSender);
413     }
414 
415     /**
416      * @dev Returns the address of the current owner.
417      */
418     function owner() public view returns (address) {
419         return _owner;
420     }
421 
422     /**
423      * @dev Throws if called by any account other than the owner.
424      */
425     modifier onlyOwner() {
426         require(_owner == _msgSender(), "Ownable: caller is not the owner");
427         _;
428     }
429 
430      /**
431      * @dev Leaves the contract without owner. It will not be possible to call
432      * `onlyOwner` functions anymore. Can only be called by the current owner.
433      *
434      * NOTE: Renouncing ownership will leave the contract without an owner,
435      * thereby removing any functionality that is only available to the owner.
436      */
437     function renounceOwnership() public virtual onlyOwner {
438         emit OwnershipTransferred(_owner, address(0));
439         _owner = address(0);
440     }
441 
442     /**
443      * @dev Transfers ownership of the contract to a new account (`newOwner`).
444      * Can only be called by the current owner.
445      */
446     function transferOwnership(address newOwner) public virtual onlyOwner {
447         require(newOwner != address(0), "Ownable: new owner is the zero address");
448         emit OwnershipTransferred(_owner, newOwner);
449         _owner = newOwner;
450     }
451 
452     function geUnlockTime() public view returns (uint256) {
453         return _lockTime;
454     }
455 
456     //Locks the contract for owner for the amount of time provided
457     function lock(uint256 time) public virtual onlyOwner {
458         _previousOwner = _owner;
459         _owner = address(0);
460         _lockTime = now + time;
461         emit OwnershipTransferred(_owner, address(0));
462     }
463     
464     //Unlocks the contract for owner when _lockTime is exceeds
465     function unlock() public virtual {
466         require(_previousOwner == msg.sender, "You don't have permission to unlock");
467         require(now > _lockTime , "Contract is locked until 7 days");
468         emit OwnershipTransferred(_owner, _previousOwner);
469         _owner = _previousOwner;
470     }
471 }
472 
473 // pragma solidity >=0.5.0;
474 
475 interface IUniswapV2Factory {
476     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
477 
478     function feeTo() external view returns (address);
479     function feeToSetter() external view returns (address);
480 
481     function getPair(address tokenA, address tokenB) external view returns (address pair);
482     function allPairs(uint) external view returns (address pair);
483     function allPairsLength() external view returns (uint);
484 
485     function createPair(address tokenA, address tokenB) external returns (address pair);
486 
487     function setFeeTo(address) external;
488     function setFeeToSetter(address) external;
489 }
490 
491 
492 // pragma solidity >=0.5.0;
493 
494 interface IUniswapV2Pair {
495     event Approval(address indexed owner, address indexed spender, uint value);
496     event Transfer(address indexed from, address indexed to, uint value);
497 
498     function name() external pure returns (string memory);
499     function symbol() external pure returns (string memory);
500     function decimals() external pure returns (uint8);
501     function totalSupply() external view returns (uint);
502     function balanceOf(address owner) external view returns (uint);
503     function allowance(address owner, address spender) external view returns (uint);
504 
505     function approve(address spender, uint value) external returns (bool);
506     function transfer(address to, uint value) external returns (bool);
507     function transferFrom(address from, address to, uint value) external returns (bool);
508 
509     function DOMAIN_SEPARATOR() external view returns (bytes32);
510     function PERMIT_TYPEHASH() external pure returns (bytes32);
511     function nonces(address owner) external view returns (uint);
512 
513     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
514 
515     event Mint(address indexed sender, uint amount0, uint amount1);
516     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
517     event Swap(
518         address indexed sender,
519         uint amount0In,
520         uint amount1In,
521         uint amount0Out,
522         uint amount1Out,
523         address indexed to
524     );
525     event Sync(uint112 reserve0, uint112 reserve1);
526 
527     function MINIMUM_LIQUIDITY() external pure returns (uint);
528     function factory() external view returns (address);
529     function token0() external view returns (address);
530     function token1() external view returns (address);
531     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
532     function price0CumulativeLast() external view returns (uint);
533     function price1CumulativeLast() external view returns (uint);
534     function kLast() external view returns (uint);
535 
536     function mint(address to) external returns (uint liquidity);
537     function burn(address to) external returns (uint amount0, uint amount1);
538     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
539     function skim(address to) external;
540     function sync() external;
541 
542     function initialize(address, address) external;
543 }
544 
545 // pragma solidity >=0.6.2;
546 
547 interface IUniswapV2Router01 {
548     function factory() external pure returns (address);
549     function WETH() external pure returns (address);
550 
551     function addLiquidity(
552         address tokenA,
553         address tokenB,
554         uint amountADesired,
555         uint amountBDesired,
556         uint amountAMin,
557         uint amountBMin,
558         address to,
559         uint deadline
560     ) external returns (uint amountA, uint amountB, uint liquidity);
561     function addLiquidityETH(
562         address token,
563         uint amountTokenDesired,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline
568     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
569     function removeLiquidity(
570         address tokenA,
571         address tokenB,
572         uint liquidity,
573         uint amountAMin,
574         uint amountBMin,
575         address to,
576         uint deadline
577     ) external returns (uint amountA, uint amountB);
578     function removeLiquidityETH(
579         address token,
580         uint liquidity,
581         uint amountTokenMin,
582         uint amountETHMin,
583         address to,
584         uint deadline
585     ) external returns (uint amountToken, uint amountETH);
586     function removeLiquidityWithPermit(
587         address tokenA,
588         address tokenB,
589         uint liquidity,
590         uint amountAMin,
591         uint amountBMin,
592         address to,
593         uint deadline,
594         bool approveMax, uint8 v, bytes32 r, bytes32 s
595     ) external returns (uint amountA, uint amountB);
596     function removeLiquidityETHWithPermit(
597         address token,
598         uint liquidity,
599         uint amountTokenMin,
600         uint amountETHMin,
601         address to,
602         uint deadline,
603         bool approveMax, uint8 v, bytes32 r, bytes32 s
604     ) external returns (uint amountToken, uint amountETH);
605     function swapExactTokensForTokens(
606         uint amountIn,
607         uint amountOutMin,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external returns (uint[] memory amounts);
612     function swapTokensForExactTokens(
613         uint amountOut,
614         uint amountInMax,
615         address[] calldata path,
616         address to,
617         uint deadline
618     ) external returns (uint[] memory amounts);
619     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
620         external
621         payable
622         returns (uint[] memory amounts);
623     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
624         external
625         returns (uint[] memory amounts);
626     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
630         external
631         payable
632         returns (uint[] memory amounts);
633 
634     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
635     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
636     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
637     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
638     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
639 }
640 
641 
642 
643 // pragma solidity >=0.6.2;
644 
645 interface IUniswapV2Router02 is IUniswapV2Router01 {
646     function removeLiquidityETHSupportingFeeOnTransferTokens(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline
653     ) external returns (uint amountETH);
654     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
655         address token,
656         uint liquidity,
657         uint amountTokenMin,
658         uint amountETHMin,
659         address to,
660         uint deadline,
661         bool approveMax, uint8 v, bytes32 r, bytes32 s
662     ) external returns (uint amountETH);
663 
664     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
665         uint amountIn,
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external;
671     function swapExactETHForTokensSupportingFeeOnTransferTokens(
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external payable;
677     function swapExactTokensForETHSupportingFeeOnTransferTokens(
678         uint amountIn,
679         uint amountOutMin,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external;
684 }
685 
686 
687 contract KoromaruInu is Context, IERC20, Ownable {
688     using SafeMath for uint256;
689     using Address for address;
690 
691     mapping (address => uint256) private _rOwned;
692     mapping (address => uint256) private _tOwned;
693     mapping (address => mapping (address => uint256)) private _allowances;
694 
695     mapping (address => bool) private _isExcludedFromFee;
696 
697     mapping (address => bool) private _isExcluded;
698     address[] private _excluded;
699    
700     uint256 private constant MAX = ~uint256(0);
701     uint256 private _tTotal = 100000000000 * 10**6 * 10**9;
702     uint256 private _rTotal = (MAX - (MAX % _tTotal));
703     uint256 private _tFeeTotal;
704 
705     string private _name = "Koromaru Inu";
706     string private _symbol = "KORO";
707     uint8 private _decimals = 9;
708     
709     uint256 public _taxFee = 1;
710     uint256 private _previousTaxFee = _taxFee;
711     
712     uint256 public _liquidityFee = 1;
713     uint256 private _previousLiquidityFee = _liquidityFee;
714 
715     uint256 public _marketingFee = 8; // All taxes are divided by 100 for more accuracy.
716     uint256 private _previousMarketingFee = _marketingFee;    
717 
718     IUniswapV2Router02 public immutable uniswapV2Router;
719     address public immutable uniswapV2Pair;
720     
721     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
722     address payable private _marketingWallet;
723 
724     bool inSwapAndLiquify;
725     bool public swapAndLiquifyEnabled = true;
726     
727     uint256 public _maxTxAmount = 250000000 * 10**6 * 10**9;
728     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
729     
730     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
731     event SwapAndLiquifyEnabledUpdated(bool enabled);
732     event SwapAndLiquify(
733         uint256 tokensSwapped,
734         uint256 ethReceived,
735         uint256 tokensIntoLiqudity
736     );
737     
738     modifier lockTheSwap {
739         inSwapAndLiquify = true;
740         _;
741         inSwapAndLiquify = false;
742     }
743     
744     constructor (address marketingWallet) public {
745         _rOwned[_msgSender()] = _rTotal;
746         
747         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
748          // Create a uniswap pair for this new token
749         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
750             .createPair(address(this), _uniswapV2Router.WETH());
751 
752         // set the rest of the contract variables
753         uniswapV2Router = _uniswapV2Router;
754         _marketingWallet = payable(marketingWallet);
755         
756         //exclude owner and this contract from fee
757         _isExcludedFromFee[owner()] = true;
758         _isExcludedFromFee[address(this)] = true;
759         
760         emit Transfer(address(0), _msgSender(), _tTotal);
761     }
762 
763     function name() public view returns (string memory) {
764         return _name;
765     }
766 
767     function symbol() public view returns (string memory) {
768         return _symbol;
769     }
770 
771     function decimals() public view returns (uint8) {
772         return _decimals;
773     }
774 
775     function totalSupply() public view override returns (uint256) {
776         return _tTotal;
777     }
778 
779     function balanceOf(address account) public view override returns (uint256) {
780         if (_isExcluded[account]) return _tOwned[account];
781         return tokenFromReflection(_rOwned[account]);
782     }
783 
784     function transfer(address recipient, uint256 amount) public override returns (bool) {
785         _transfer(_msgSender(), recipient, amount);
786         return true;
787     }
788 
789     function allowance(address owner, address spender) public view override returns (uint256) {
790         return _allowances[owner][spender];
791     }
792 
793     function approve(address spender, uint256 amount) public override returns (bool) {
794         _approve(_msgSender(), spender, amount);
795         return true;
796     }
797 
798     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
799         _transfer(sender, recipient, amount);
800         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
801         return true;
802     }
803 
804     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
805         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
806         return true;
807     }
808 
809     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
811         return true;
812     }
813 
814     function isExcludedFromReward(address account) public view returns (bool) {
815         return _isExcluded[account];
816     }
817 
818     function totalFees() public view returns (uint256) {
819         return _tFeeTotal;
820     }
821 
822     function deliver(uint256 tAmount) public {
823         address sender = _msgSender();
824         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
825         (uint256 rAmount,,,,,) = _getValues(tAmount);
826         _rOwned[sender] = _rOwned[sender].sub(rAmount);
827         _rTotal = _rTotal.sub(rAmount);
828         _tFeeTotal = _tFeeTotal.add(tAmount);
829     }
830 
831     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
832         require(tAmount <= _tTotal, "Amount must be less than supply");
833         if (!deductTransferFee) {
834             (uint256 rAmount,,,,,) = _getValues(tAmount);
835             return rAmount;
836         } else {
837             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
838             return rTransferAmount;
839         }
840     }
841 
842     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
843         require(rAmount <= _rTotal, "Amount must be less than total reflections");
844         uint256 currentRate =  _getRate();
845         return rAmount.div(currentRate);
846     }
847 
848     function excludeFromReward(address account) public onlyOwner() {
849         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
850         require(!_isExcluded[account], "Account is already excluded");
851         if(_rOwned[account] > 0) {
852             _tOwned[account] = tokenFromReflection(_rOwned[account]);
853         }
854         _isExcluded[account] = true;
855         _excluded.push(account);
856     }
857 
858     function includeInReward(address account) external onlyOwner() {
859         require(_isExcluded[account], "Account is already excluded");
860         for (uint256 i = 0; i < _excluded.length; i++) {
861             if (_excluded[i] == account) {
862                 _excluded[i] = _excluded[_excluded.length - 1];
863                 _tOwned[account] = 0;
864                 _isExcluded[account] = false;
865                 _excluded.pop();
866                 break;
867             }
868         }
869     }
870         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
871         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
872         _tOwned[sender] = _tOwned[sender].sub(tAmount);
873         _rOwned[sender] = _rOwned[sender].sub(rAmount);
874         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
875         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
876         _takeLiquidity(tLiquidity);
877         _reflectFee(rFee, tFee);
878         emit Transfer(sender, recipient, tTransferAmount);
879     }
880     
881         function excludeFromFee(address account) public onlyOwner {
882         _isExcludedFromFee[account] = true;
883     }
884     
885     function includeInFee(address account) public onlyOwner {
886         _isExcludedFromFee[account] = false;
887     }
888     
889     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
890         _taxFee = taxFee;
891     }
892     
893     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
894         _liquidityFee = liquidityFee;
895     }
896 
897     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
898         _marketingFee = marketingFee;
899     }    
900    
901     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
902         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
903             10**2
904         );
905     }
906 
907     function setMarketingWallet(address payable newWallet) external onlyOwner {
908         require(_marketingWallet != newWallet, "Wallet already set!");
909         _marketingWallet = payable(newWallet);
910     }
911 
912     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
913         swapAndLiquifyEnabled = _enabled;
914         emit SwapAndLiquifyEnabledUpdated(_enabled);
915     }
916     
917      //to recieve ETH from uniswapV2Router when swaping
918     receive() external payable {}
919 
920     function _reflectFee(uint256 rFee, uint256 tFee) private {
921         _rTotal = _rTotal.sub(rFee);
922         _tFeeTotal = _tFeeTotal.add(tFee);
923     }
924 
925     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
926         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
927         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
928         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
929     }
930 
931     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
932         uint256 tFee = calculateTaxFee(tAmount);
933         uint256 tLiquidity = calculateLiquidityFee(tAmount);
934         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
935         return (tTransferAmount, tFee, tLiquidity);
936     }
937 
938     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
939         uint256 rAmount = tAmount.mul(currentRate);
940         uint256 rFee = tFee.mul(currentRate);
941         uint256 rLiquidity = tLiquidity.mul(currentRate);
942         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
943         return (rAmount, rTransferAmount, rFee);
944     }
945 
946     function _getRate() private view returns(uint256) {
947         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
948         return rSupply.div(tSupply);
949     }
950 
951     function _getCurrentSupply() private view returns(uint256, uint256) {
952         uint256 rSupply = _rTotal;
953         uint256 tSupply = _tTotal;      
954         for (uint256 i = 0; i < _excluded.length; i++) {
955             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
956             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
957             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
958         }
959         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
960         return (rSupply, tSupply);
961     }
962     
963     function _takeLiquidity(uint256 tLiquidity) private {
964         uint256 currentRate =  _getRate();
965         uint256 rLiquidity = tLiquidity.mul(currentRate);
966         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
967         if(_isExcluded[address(this)])
968             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
969     }
970     
971     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
972         return _amount.mul(_taxFee).div(
973             10**2
974         );
975     }
976 
977     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
978         return _amount.mul(_liquidityFee.add(_marketingFee)).div(
979             10**2
980         );
981     }
982     
983     function removeAllFee() private {
984         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
985         
986         _previousTaxFee = _taxFee;
987         _previousLiquidityFee = _liquidityFee;
988         _previousMarketingFee = _marketingFee;
989         
990         _taxFee = 0;
991         _liquidityFee = 0;
992         _marketingFee = 0;
993     }
994     
995     function restoreAllFee() private {
996         _taxFee = _previousTaxFee;
997         _liquidityFee = _previousLiquidityFee;
998         _marketingFee = _previousMarketingFee;
999     }
1000     
1001     function isExcludedFromFee(address account) public view returns(bool) {
1002         return _isExcludedFromFee[account];
1003     }
1004 
1005     function _approve(address owner, address spender, uint256 amount) private {
1006         require(owner != address(0), "ERC20: approve from the zero address");
1007         require(spender != address(0), "ERC20: approve to the zero address");
1008 
1009         _allowances[owner][spender] = amount;
1010         emit Approval(owner, spender, amount);
1011     }
1012 
1013     function _transfer(
1014         address from,
1015         address to,
1016         uint256 amount
1017     ) private {
1018         require(from != address(0), "ERC20: transfer from the zero address");
1019         require(to != address(0), "ERC20: transfer to the zero address");
1020         require(amount > 0, "Transfer amount must be greater than zero");
1021         if(from != owner() && to != owner())
1022             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1023 
1024         // is the token balance of this contract address over the min number of
1025         // tokens that we need to initiate a swap + liquidity lock?
1026         // also, don't get caught in a circular liquidity event.
1027         // also, don't swap & liquify if sender is uniswap pair.
1028         uint256 contractTokenBalance = balanceOf(address(this));
1029         
1030         if(contractTokenBalance >= _maxTxAmount)
1031         {
1032             contractTokenBalance = _maxTxAmount;
1033         }
1034         
1035         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1036         if (
1037             overMinTokenBalance &&
1038             !inSwapAndLiquify &&
1039             from != uniswapV2Pair &&
1040             swapAndLiquifyEnabled
1041         ) {
1042             contractTokenBalance = numTokensSellToAddToLiquidity;
1043             //add liquidity
1044             swapAndLiquify(contractTokenBalance);
1045         }
1046         
1047         //indicates if fee should be deducted from transfer
1048         bool takeFee = true;
1049         
1050         //if any account belongs to _isExcludedFromFee account then remove the fee
1051         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1052             takeFee = false;
1053         }
1054         
1055         //transfer amount, it will take tax, burn, liquidity fee
1056         _tokenTransfer(from,to,amount,takeFee);
1057     }
1058 
1059     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1060         if (_marketingFee + _liquidityFee == 0)
1061             return;
1062         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
1063         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
1064 
1065         // split the contract balance into halves
1066         uint256 half = toLiquify.div(2);
1067         uint256 otherHalf = toLiquify.sub(half);
1068 
1069         // capture the contract's current ETH balance.
1070         // this is so that we can capture exactly the amount of ETH that the
1071         // swap creates, and not make the liquidity event include any ETH that
1072         // has been manually sent to the contract
1073         uint256 initialBalance = address(this).balance;
1074 
1075         // swap tokens for ETH
1076         uint256 toSwapForEth = half.add(toMarketing);
1077         swapTokensForEth(toSwapForEth);
1078 
1079         // how much ETH did we just swap into?
1080         uint256 fromSwap = address(this).balance.sub(initialBalance);
1081         uint256 liquidityBalance = fromSwap.mul(half).div(toSwapForEth);
1082 
1083         addLiquidity(otherHalf, liquidityBalance);
1084 
1085         emit SwapAndLiquify(half, liquidityBalance, otherHalf);
1086 
1087         _marketingWallet.transfer(fromSwap.sub(liquidityBalance));
1088     }
1089 
1090     function swapTokensForEth(uint256 tokenAmount) private {
1091         // generate the uniswap pair path of token -> weth
1092         address[] memory path = new address[](2);
1093         path[0] = address(this);
1094         path[1] = uniswapV2Router.WETH();
1095 
1096         _approve(address(this), address(uniswapV2Router), tokenAmount);
1097 
1098         // make the swap
1099         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1100             tokenAmount,
1101             0, // accept any amount of ETH
1102             path,
1103             address(this),
1104             block.timestamp
1105         );
1106     }
1107 
1108     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1109         // approve token transfer to cover all possible scenarios
1110         _approve(address(this), address(uniswapV2Router), tokenAmount);
1111 
1112         // add the liquidity
1113         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1114             address(this),
1115             tokenAmount,
1116             0, // slippage is unavoidable
1117             0, // slippage is unavoidable
1118             burnAddress,
1119             block.timestamp
1120         );
1121     }
1122 
1123     //this method is responsible for taking all fee, if takeFee is true
1124     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1125         if(!takeFee)
1126             removeAllFee();
1127         
1128         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1129             _transferFromExcluded(sender, recipient, amount);
1130         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1131             _transferToExcluded(sender, recipient, amount);
1132         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1133             _transferStandard(sender, recipient, amount);
1134         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1135             _transferBothExcluded(sender, recipient, amount);
1136         } else {
1137             _transferStandard(sender, recipient, amount);
1138         }
1139         
1140         if(!takeFee)
1141             restoreAllFee();
1142     }
1143 
1144     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1145         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1146         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1147         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1148         _takeLiquidity(tLiquidity);
1149         _reflectFee(rFee, tFee);
1150         emit Transfer(sender, recipient, tTransferAmount);
1151     }
1152 
1153     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1154         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1155         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1156         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1157         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1158         _takeLiquidity(tLiquidity);
1159         _reflectFee(rFee, tFee);
1160         emit Transfer(sender, recipient, tTransferAmount);
1161     }
1162 
1163     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1164         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1165         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1166         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1167         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1168         _takeLiquidity(tLiquidity);
1169         _reflectFee(rFee, tFee);
1170         emit Transfer(sender, recipient, tTransferAmount);
1171     }
1172 
1173 
1174     
1175 
1176 }