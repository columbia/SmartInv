1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a {Transfer} event.
19      */
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     /**
23      * @dev Returns the remaining number of tokens that `spender` will be
24      * allowed to spend on behalf of `owner` through {transferFrom}. This is
25      * zero by default.
26      *
27      * This value changes when {approve} or {transferFrom} are called.
28      */
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     /**
32      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * IMPORTANT: Beware that changing an allowance with this method brings the risk
37      * that someone may use both the old and the new allowance by unfortunate
38      * transaction ordering. One possible solution to mitigate this race
39      * condition is to first reduce the spender's allowance to 0 and set the
40      * desired value afterwards:
41      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
42      *
43      * Emits an {Approval} event.
44      */
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Moves `amount` tokens from `sender` to `recipient` using the
49      * allowance mechanism. `amount` is then deducted from the caller's
50      * allowance.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
68      * a call to {approve}. `value` is the new allowance.
69      */
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations with added overflow
77  * checks.
78  *
79  * Arithmetic operations in Solidity wrap on overflow. This can easily result
80  * in bugs, because programmers usually assume that an overflow raises an
81  * error, which is the standard behavior in high level programming languages.
82  * `SafeMath` restores this intuition by reverting the transaction when an
83  * operation overflows.
84  *
85  * Using this library instead of the unchecked operations eliminates an entire
86  * class of bugs, so it's recommended to use it always.
87  */
88 
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      *
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      *
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 abstract contract Context {
233     function _msgSender() internal view virtual returns (address payable) {
234         return msg.sender;
235     }
236 
237     function _msgData() internal view virtual returns (bytes memory) {
238         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
239         return msg.data;
240     }
241 }
242 
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268         // for accounts without code, i.e. `keccak256('')`
269         bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { codehash := extcodehash(account) }
273         return (codehash != accountHash && codehash != 0x0);
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319       return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return _functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         return _functionCallWithValue(target, data, value, errorMessage);
356     }
357 
358     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 contract Ownable is Context {
395     address private _owner;
396     address private _previousOwner;
397     uint256 private _lockTime;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev Initializes the contract setting the deployer as the initial owner.
403      */
404     constructor () internal {
405         address msgSender = _msgSender();
406         _owner = msgSender;
407         emit OwnershipTransferred(address(0), msgSender);
408     }
409 
410     /**
411      * @dev Returns the address of the current owner.
412      */
413     function owner() public view returns (address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(_owner == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425      /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 
447     function geUnlockTime() public view returns (uint256) {
448         return _lockTime;
449     }
450 
451     //Locks the contract for owner for the amount of time provided
452     function lock(uint256 time) public virtual onlyOwner {
453         _previousOwner = _owner;
454         _owner = address(0);
455         _lockTime = now + time;
456         emit OwnershipTransferred(_owner, address(0));
457     }
458 
459     //Unlocks the contract for owner when _lockTime is exceeds
460     function unlock() public virtual {
461         require(_previousOwner == msg.sender, "You don't have permission to unlock");
462         require(now > _lockTime , "Contract is locked until 7 days");
463         emit OwnershipTransferred(_owner, _previousOwner);
464         _owner = _previousOwner;
465     }
466 }
467 
468 // pragma solidity >=0.5.0;
469 
470 interface IUniswapV2Factory {
471     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
472 
473     function feeTo() external view returns (address);
474     function feeToSetter() external view returns (address);
475 
476     function getPair(address tokenA, address tokenB) external view returns (address pair);
477     function allPairs(uint) external view returns (address pair);
478     function allPairsLength() external view returns (uint);
479 
480     function createPair(address tokenA, address tokenB) external returns (address pair);
481 
482     function setFeeTo(address) external;
483     function setFeeToSetter(address) external;
484 }
485 
486 
487 // pragma solidity >=0.5.0;
488 
489 interface IUniswapV2Pair {
490     event Approval(address indexed owner, address indexed spender, uint value);
491     event Transfer(address indexed from, address indexed to, uint value);
492 
493     function name() external pure returns (string memory);
494     function symbol() external pure returns (string memory);
495     function decimals() external pure returns (uint8);
496     function totalSupply() external view returns (uint);
497     function balanceOf(address owner) external view returns (uint);
498     function allowance(address owner, address spender) external view returns (uint);
499 
500     function approve(address spender, uint value) external returns (bool);
501     function transfer(address to, uint value) external returns (bool);
502     function transferFrom(address from, address to, uint value) external returns (bool);
503 
504     function DOMAIN_SEPARATOR() external view returns (bytes32);
505     function PERMIT_TYPEHASH() external pure returns (bytes32);
506     function nonces(address owner) external view returns (uint);
507 
508     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
509 
510     event Mint(address indexed sender, uint amount0, uint amount1);
511     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
512     event Swap(
513         address indexed sender,
514         uint amount0In,
515         uint amount1In,
516         uint amount0Out,
517         uint amount1Out,
518         address indexed to
519     );
520     event Sync(uint112 reserve0, uint112 reserve1);
521 
522     function MINIMUM_LIQUIDITY() external pure returns (uint);
523     function factory() external view returns (address);
524     function token0() external view returns (address);
525     function token1() external view returns (address);
526     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
527     function price0CumulativeLast() external view returns (uint);
528     function price1CumulativeLast() external view returns (uint);
529     function kLast() external view returns (uint);
530 
531     function mint(address to) external returns (uint liquidity);
532     function burn(address to) external returns (uint amount0, uint amount1);
533     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
534     function skim(address to) external;
535     function sync() external;
536 
537     function initialize(address, address) external;
538 }
539 
540 // pragma solidity >=0.6.2;
541 
542 interface IUniswapV2Router01 {
543     function factory() external pure returns (address);
544     function WETH() external pure returns (address);
545 
546     function addLiquidity(
547         address tokenA,
548         address tokenB,
549         uint amountADesired,
550         uint amountBDesired,
551         uint amountAMin,
552         uint amountBMin,
553         address to,
554         uint deadline
555     ) external returns (uint amountA, uint amountB, uint liquidity);
556     function addLiquidityETH(
557         address token,
558         uint amountTokenDesired,
559         uint amountTokenMin,
560         uint amountETHMin,
561         address to,
562         uint deadline
563     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
564     function removeLiquidity(
565         address tokenA,
566         address tokenB,
567         uint liquidity,
568         uint amountAMin,
569         uint amountBMin,
570         address to,
571         uint deadline
572     ) external returns (uint amountA, uint amountB);
573     function removeLiquidityETH(
574         address token,
575         uint liquidity,
576         uint amountTokenMin,
577         uint amountETHMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountToken, uint amountETH);
581     function removeLiquidityWithPermit(
582         address tokenA,
583         address tokenB,
584         uint liquidity,
585         uint amountAMin,
586         uint amountBMin,
587         address to,
588         uint deadline,
589         bool approveMax, uint8 v, bytes32 r, bytes32 s
590     ) external returns (uint amountA, uint amountB);
591     function removeLiquidityETHWithPermit(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline,
598         bool approveMax, uint8 v, bytes32 r, bytes32 s
599     ) external returns (uint amountToken, uint amountETH);
600     function swapExactTokensForTokens(
601         uint amountIn,
602         uint amountOutMin,
603         address[] calldata path,
604         address to,
605         uint deadline
606     ) external returns (uint[] memory amounts);
607     function swapTokensForExactTokens(
608         uint amountOut,
609         uint amountInMax,
610         address[] calldata path,
611         address to,
612         uint deadline
613     ) external returns (uint[] memory amounts);
614     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
615         external
616         payable
617         returns (uint[] memory amounts);
618     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
619         external
620         returns (uint[] memory amounts);
621     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
622         external
623         returns (uint[] memory amounts);
624     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
625         external
626         payable
627         returns (uint[] memory amounts);
628 
629     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
630     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
631     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
632     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
633     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
634 }
635 
636 
637 
638 // pragma solidity >=0.6.2;
639 
640 interface IUniswapV2Router02 is IUniswapV2Router01 {
641     function removeLiquidityETHSupportingFeeOnTransferTokens(
642         address token,
643         uint liquidity,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline
648     ) external returns (uint amountETH);
649     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline,
656         bool approveMax, uint8 v, bytes32 r, bytes32 s
657     ) external returns (uint amountETH);
658 
659     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
660         uint amountIn,
661         uint amountOutMin,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external;
666     function swapExactETHForTokensSupportingFeeOnTransferTokens(
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external payable;
672     function swapExactTokensForETHSupportingFeeOnTransferTokens(
673         uint amountIn,
674         uint amountOutMin,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external;
679 }
680 
681 
682 contract NerdyInu is Context, IERC20, Ownable {
683     using SafeMath for uint256;
684     using Address for address payable;
685 
686     mapping (address => uint256) private _rOwned;
687     mapping (address => uint256) private _tOwned;
688     mapping (address => mapping (address => uint256)) private _allowances;
689 
690     mapping (address => bool) private _isExcludedFromFee;
691 
692     mapping (address => bool) private _isExcluded;
693     address[] private _excluded;
694 
695     address payable public nerdy_1;
696     address payable public nerdy_2;
697     address payable public nerdy_3;
698     address payable public treasury;
699 
700     uint256 private constant MAX = ~uint256(0);
701     uint256 private _tTotal = 100 * 10**6 * 10**9;
702     uint256 private _rTotal = (MAX - (MAX % _tTotal));
703     uint256 private _tFeeTotal;
704 
705     string private _name = "Nerdy Inu";
706     string private _symbol = "NERDY";
707     uint8 private _decimals = 9;
708 
709     //redistributed to holders
710     uint256 public _taxFee = 2; 
711     uint256 private _previousTaxFee = _taxFee;
712 
713     //goes to Uniswap liquidity pool
714     uint256 public _liquidityFee = 200;
715     uint256 private _previousLiquidityFee = _liquidityFee;
716 
717     //Budget for sponsorships, promotions, partnerships / development grants
718     uint256 public _treasuryFee = 599; //Treasury fee (actual fee is 5.99%; 599 is for floating precision purposes)
719     uint256 private _previousTreasuryFee = _treasuryFee;
720 
721     //Operational costs (salaries, HR, networking)
722     uint256 public _nerdyPartOfTreasury = 16; 
723 
724     IUniswapV2Router02 public immutable uniswapV2Router;
725     address public immutable uniswapV2Pair;
726 
727     bool inSwapAndLiquify;
728     bool public swapAndLiquifyEnabled = true;
729 
730     uint256 public _maxTxAmount = 15 * 10**6 * 10**9;
731     uint256 private numTokensSellToAddToLiquidity = 100 * 10**3 * 10**9;
732 
733     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
734     event SwapAndLiquifyEnabledUpdated(bool enabled);
735     event SwapAndLiquify(
736         uint256 tokensSwapped,
737         uint256 ethReceived,
738         uint256 tokensIntoLiquidity
739     );
740 
741     modifier lockTheSwap {
742         inSwapAndLiquify = true;
743         _;
744         inSwapAndLiquify = false;
745     }
746 
747     constructor (address payable _nerdy1Wallet, address payable _nerdy2Wallet, address payable _nerdy3Wallet, address payable _treasuryWallet) public {
748       nerdy_1 = _nerdy1Wallet;
749       nerdy_2 = _nerdy2Wallet;
750       nerdy_3 = _nerdy3Wallet;
751       treasury = _treasuryWallet;
752       _rOwned[_msgSender()] = _rTotal;
753       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
754       uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
755             .createPair(address(this), _uniswapV2Router.WETH());
756       uniswapV2Router = _uniswapV2Router;
757       //exclude owner and this contract from fee
758       _isExcludedFromFee[owner()] = true;
759       _isExcludedFromFee[address(this)] = true;
760       emit Transfer(address(0), _msgSender(), _tTotal);
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
822     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
823         require(tAmount <= _tTotal, "Amount must be less than supply");
824         if (!deductTransferFee) {
825             (uint256 rAmount,,,,,,) = _getValues(tAmount);
826             return rAmount;
827         } else {
828             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
829             return rTransferAmount;
830         }
831     }
832 
833     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
834         require(rAmount <= _rTotal, "Amount must be less than total reflections");
835         uint256 currentRate =  _getRate();
836         return rAmount.div(currentRate);
837     }
838 
839     //this can be called externally by deployer to immediately process accumulated fees accordingly (distribute to treasury & liquidity)
840     function manualSwapAndLiquify() public onlyOwner() {
841         uint256 contractTokenBalance = balanceOf(address(this));
842         swapAndLiquify(contractTokenBalance);
843     }
844 
845     function excludeFromReward(address account) public onlyOwner() {
846         require(!_isExcluded[account], "Account is already excluded");
847         if(_rOwned[account] > 0) {
848             _tOwned[account] = tokenFromReflection(_rOwned[account]);
849         }
850         _isExcluded[account] = true;
851         _excluded.push(account);
852     }
853 
854     function includeInReward(address account) external onlyOwner() {
855         require(_isExcluded[account], "Account is not excluded");
856         for (uint256 i = 0; i < _excluded.length; i++) {
857             if (_excluded[i] == account) {
858                 _excluded[i] = _excluded[_excluded.length - 1];
859                 _tOwned[account] = 0;
860                 _isExcluded[account] = false;
861                 _excluded.pop();
862                 break;
863             }
864         }
865     }
866 
867     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
868         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tTreasury) = _getValues(tAmount);
869         _tOwned[sender] = _tOwned[sender].sub(tAmount);
870         _rOwned[sender] = _rOwned[sender].sub(rAmount);
871         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
872         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
873         _takeLiquidity(tLiquidity);
874         _takeTreasury(tTreasury);
875         _reflectFee(rFee, tFee);
876         emit Transfer(sender, recipient, tTransferAmount);
877     }
878 
879     function excludeFromFee(address account) public onlyOwner {
880         _isExcludedFromFee[account] = true;
881     }
882 
883     function includeInFee(address account) public onlyOwner {
884         _isExcludedFromFee[account] = false;
885     }
886 
887     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
888         _taxFee = taxFee;
889     }
890 
891     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
892         _liquidityFee = liquidityFee;
893     }
894     
895     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
896         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
897             10**2
898         );
899     }
900 
901     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
902         swapAndLiquifyEnabled = _enabled;
903         emit SwapAndLiquifyEnabledUpdated(_enabled);
904     }
905 
906      //to receive ETH from uniswapV2Router when swaping
907     receive() external payable {}
908 
909     function _reflectFee(uint256 rFee, uint256 tFee) private {
910         _rTotal = _rTotal.sub(rFee);
911         _tFeeTotal = _tFeeTotal.add(tFee);
912     }
913 
914     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
915         uint256[4] memory tValues = _getTValuesArray(tAmount);
916         uint256[3] memory rValues = _getRValuesArray(tAmount, tValues[1], tValues[2], tValues[3]);
917         return (rValues[0], rValues[1], rValues[2], tValues[0], tValues[1], tValues[2], tValues[3]);
918     }
919 
920     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
921         uint256 tFee = calculateTaxFee(tAmount);
922         uint256 tLiquidity = calculateLiquidityFee(tAmount);
923         uint256 tTreasury = calculateTreasuryFee(tAmount);
924         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tTreasury);
925         return (tTransferAmount, tFee, tLiquidity, tTreasury);
926     }
927 
928     function _getTValuesArray(uint256 tAmount) private view returns (uint256[4] memory val) {
929         uint256 tFee = calculateTaxFee(tAmount);
930         uint256 tLiquidity = calculateLiquidityFee(tAmount);
931         uint256 tTreasury = calculateTreasuryFee(tAmount);
932         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tTreasury);
933         return [tTransferAmount, tFee, tLiquidity, tTreasury];
934     }
935 
936     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tTreasury) private view returns (uint256, uint256, uint256) {
937         uint256 currentRate = _getRate();
938         uint256 rAmount = tAmount.mul(currentRate);
939         uint256 rFee = tFee.mul(currentRate);
940         uint256 rTransferAmount = rAmount.sub(rFee).sub(tLiquidity.mul(currentRate)).sub(tTreasury.mul(currentRate));
941         return (rAmount, rTransferAmount, rFee);
942     }
943 
944     function _getRValuesArray(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tTreasury) private view returns (uint256[3] memory val) {
945         uint256 currentRate = _getRate();
946         uint256 rAmount = tAmount.mul(currentRate);
947         uint256 rFee = tFee.mul(currentRate);
948         uint256 rTransferAmount = rAmount.sub(rFee).sub(tLiquidity.mul(currentRate)).sub(tTreasury.mul(currentRate));
949         return [rAmount, rTransferAmount, rFee];
950     }
951 
952     function _getRate() private view returns(uint256) {
953         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
954         return rSupply.div(tSupply);
955     }
956 
957     function _getCurrentSupply() private view returns(uint256, uint256) {
958         uint256 rSupply = _rTotal;
959         uint256 tSupply = _tTotal;
960         for (uint256 i = 0; i < _excluded.length; i++) {
961             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
962             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
963             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
964         }
965         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
966         return (rSupply, tSupply);
967     }
968 
969     function _takeLiquidity(uint256 tLiquidity) private {
970         uint256 currentRate =  _getRate();
971         uint256 rLiquidity = tLiquidity.mul(currentRate);
972         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
973         if(_isExcluded[address(this)])
974             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
975     }
976 
977     function _takeTreasury(uint256 tTreasury) private {
978         uint256 currentRate =  _getRate();
979         uint256 rTreasury = tTreasury.mul(currentRate);
980         _rOwned[address(this)] = _rOwned[address(this)].add(rTreasury);
981         if(_isExcluded[address(this)])
982             _tOwned[address(this)] = _tOwned[address(this)].add(tTreasury);
983     }
984 
985     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
986         return _amount.mul(_taxFee).div(
987             10**2
988         );
989     }
990 
991     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
992         return _amount.mul(_liquidityFee).div(
993             10**4
994         );
995     }
996 
997     function calculateTreasuryFee(uint256 _amount) private view returns (uint256) {
998         return _amount.mul(_treasuryFee).div(
999             10**4
1000         );
1001     }
1002 
1003     function removeAllFee() private {
1004         if(_taxFee == 0 && _liquidityFee == 0 && _treasuryFee == 0) return;
1005 
1006         _previousTaxFee = _taxFee;
1007         _previousLiquidityFee = _liquidityFee;
1008         _previousTreasuryFee = _treasuryFee;
1009 
1010         _taxFee = 0;
1011         _liquidityFee = 0;
1012         _treasuryFee = 0;
1013     }
1014 
1015     function restoreAllFee() private {
1016         _taxFee = _previousTaxFee;
1017         _liquidityFee = _previousLiquidityFee;
1018         _treasuryFee = _previousTreasuryFee;
1019     }
1020 
1021     function isExcludedFromFee(address account) public view returns(bool) {
1022         return _isExcludedFromFee[account];
1023     }
1024 
1025     function _approve(address owner, address spender, uint256 amount) private {
1026         require(owner != address(0), "ERC20: approve from the zero address");
1027         require(spender != address(0), "ERC20: approve to the zero address");
1028 
1029         _allowances[owner][spender] = amount;
1030         emit Approval(owner, spender, amount);
1031     }
1032 
1033     function _transfer(
1034         address from,
1035         address to,
1036         uint256 amount
1037     ) private {
1038         require(from != address(0), "ERC20: transfer from the zero address");
1039         require(to != address(0), "ERC20: transfer to the zero address");
1040         require(amount > 0, "Transfer amount must be greater than zero");
1041 
1042         uint256 contractTokenBalance = balanceOf(address(this));
1043 
1044         if(contractTokenBalance >= _maxTxAmount)
1045         {
1046             contractTokenBalance = _maxTxAmount;
1047         }
1048 
1049         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1050         if (
1051             overMinTokenBalance &&
1052             !inSwapAndLiquify &&
1053             from != uniswapV2Pair &&
1054             swapAndLiquifyEnabled
1055         ) {
1056             swapAndLiquify(contractTokenBalance);
1057         }
1058 
1059         //indicates if fee should be deducted from transfer
1060         bool takeFee = true;
1061 
1062         //if any account belongs to _isExcludedFromFee account then remove the fee
1063         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1064             takeFee = false;
1065         }
1066 
1067         //transfer amount, it will take tax, liquidity & treasury fees
1068         _tokenTransfer(from,to,amount,takeFee);
1069     }
1070 
1071     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1072         //split contract balance into two parts — one for liquidity addition, another for treasury fill up
1073         uint256 totalContractBalanceFees = _liquidityFee.add(_treasuryFee);
1074 
1075         uint256 liquidityPart = contractTokenBalance.mul(_liquidityFee).div(totalContractBalanceFees);
1076         uint256 treasuryPart = contractTokenBalance.sub(liquidityPart);
1077 
1078         uint256 liquidityHalfPart = liquidityPart.div(2);
1079 
1080         //now swapping half of the liquidity part + all of the treasury part into ETH
1081         uint256 totalETHSwap = liquidityHalfPart.add(treasuryPart);
1082 
1083         uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart);
1084 
1085         // capture the contract's current ETH balance.
1086         // this is so that we can capture exactly the amount of ETH that the
1087         // swap creates, and not make the liquidity event include any ETH that
1088         // has been manually sent to the contract
1089         uint256 initialBalance = address(this).balance;
1090 
1091         // swap tokens for ETH
1092         swapTokensForEth(totalETHSwap);
1093 
1094         uint256 newBalance = address(this).balance.sub(initialBalance);
1095 
1096         uint256 liquidityPartETHSwap = _liquidityFee.div(2);
1097         uint256 totalETHSwapPart = totalContractBalanceFees.sub(liquidityPartETHSwap);
1098         uint256 liquidityBalance = liquidityPartETHSwap.mul(newBalance).div(totalETHSwapPart);
1099 
1100         // add liquidity to uniswap
1101         addLiquidity(liquidityHalfTokenPart, liquidityBalance);
1102         emit SwapAndLiquify(liquidityHalfPart, liquidityBalance, liquidityHalfPart);
1103 
1104         newBalance = address(this).balance;
1105         payTreasury(newBalance);
1106     }
1107 
1108     function swapTokensForEth(uint256 tokenAmount) private {
1109         // generate the uniswap pair path of token -> weth
1110         address[] memory path = new address[](2);
1111         path[0] = address(this);
1112         path[1] = uniswapV2Router.WETH();
1113 
1114         _approve(address(this), address(uniswapV2Router), tokenAmount);
1115 
1116         // make the swap
1117         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1118             tokenAmount,
1119             0, // accept any amount of ETH
1120             path,
1121             address(this),
1122             block.timestamp
1123         );
1124     }
1125 
1126     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1127         // approve token transfer to cover all possible scenarios
1128         _approve(address(this), address(uniswapV2Router), tokenAmount);
1129 
1130         // add the liquidity
1131         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1132             address(this),
1133             tokenAmount,
1134             0, // slippage is unavoidable
1135             0, // slippage is unavoidable
1136             address(this),
1137             block.timestamp
1138         );
1139     }
1140 
1141     function payTreasury(uint256 ethAmount) private {
1142       uint256 nerdyFee = ethAmount.mul(_nerdyPartOfTreasury).div(100);
1143       uint256 treasuryWalletFee = ethAmount.sub(nerdyFee).sub(nerdyFee).sub(nerdyFee);
1144 
1145       treasury.sendValue(treasuryWalletFee);
1146 
1147       nerdy_1.sendValue(nerdyFee);
1148       nerdy_2.sendValue(nerdyFee);
1149       nerdy_3.sendValue(nerdyFee);
1150     }
1151 
1152     //this method is responsible for taking all fee, if takeFee is true
1153     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1154         if(!takeFee)
1155             removeAllFee();
1156 
1157         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1158             _transferFromExcluded(sender, recipient, amount);
1159         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1160             _transferToExcluded(sender, recipient, amount);
1161         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1162             _transferStandard(sender, recipient, amount);
1163         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1164             _transferBothExcluded(sender, recipient, amount);
1165         } else {
1166             _transferStandard(sender, recipient, amount);
1167         }
1168 
1169         if(!takeFee)
1170             restoreAllFee();
1171     }
1172 
1173     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1174         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tTreasury) = _getValues(tAmount);
1175         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1176         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1177         _takeLiquidity(tLiquidity);
1178         _takeTreasury(tTreasury);
1179         _reflectFee(rFee, tFee);
1180         emit Transfer(sender, recipient, tTransferAmount);
1181     }
1182 
1183     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1184         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tTreasury) = _getValues(tAmount);
1185         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1186         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1187         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1188         _takeLiquidity(tLiquidity);
1189         _takeTreasury(tTreasury);
1190         _reflectFee(rFee, tFee);
1191         emit Transfer(sender, recipient, tTransferAmount);
1192     }
1193 
1194     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1195         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tTreasury) = _getValues(tAmount);
1196         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1197         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1198         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1199         _takeLiquidity(tLiquidity);
1200         _takeTreasury(tTreasury);
1201         _reflectFee(rFee, tFee);
1202         emit Transfer(sender, recipient, tTransferAmount);
1203     }
1204 }