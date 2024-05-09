1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.6.12;
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
682 contract SUCK is Context, IERC20, Ownable {
683     using SafeMath for uint256;
684     using Address for address;
685 
686     mapping (address => uint256) private m_Balances;
687     mapping (address => mapping (address => uint256)) private _allowances;
688 
689     mapping (address => bool) private isBot;
690     mapping (address => bool) private _isExcludedFromFee;
691     mapping (address => User) private cooldown;
692     address[] private _excluded;
693    
694     uint256 private constant MAX = ~uint256(0);
695     uint256 private _tTotal = 100000000 * 10**1 * 10**9;
696     uint256 private _tFeeTotal = 10;
697 
698     string private _name = "SUCK";
699     string private _symbol = "SUCK";
700     uint8 private _decimals = 9;    
701       
702 
703     IUniswapV2Router02 public immutable uniswapV2Router;
704     address public immutable uniswapV2Pair;
705     address payable public MarketingandDevWallet = payable(0x3f4cF2b72CbA8a1696CdfbF29329bA36d0B93268);
706     
707     bool inSwapAndLiquify;
708 
709     bool public tradingOpen;
710     uint256 public launchedAt;
711     uint256 private _blockLimit = 1;
712     bool private _cooldownEnabled=true;   
713     uint256 public _maxTxAmount = 4000001 * 10**9;
714     uint256 public numTokensSellToAddToLiquidity = 10000000 * 10**9;
715 
716       struct User {
717         uint256 buy;
718         uint256 sell;
719         bool exists;
720     }
721     
722     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
723     event SwapAndLiquify(
724         uint256 tokensSwapped,
725         uint256 ethReceived,
726         uint256 tokensIntoLiqudity
727     );
728     
729     modifier lockTheSwap {
730         inSwapAndLiquify = true;
731         _;
732         inSwapAndLiquify = false;
733     }
734     
735     constructor () public {               
736         
737         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
738          // Create a uniswap pair for this new token
739         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
740             .createPair(address(this), _uniswapV2Router.WETH());
741 
742         // set the rest of the contract variables
743         uniswapV2Router = _uniswapV2Router;
744         
745         //exclude owner and this contract from fee
746         _isExcludedFromFee[owner()] = true;
747         _isExcludedFromFee[address(this)] = true;
748 
749         m_Balances[_msgSender()] = _tTotal;
750         
751         emit Transfer(address(0), _msgSender(), _tTotal);
752     }
753 
754     function name() public view returns (string memory) {
755         return _name;
756     }
757 
758     function symbol() public view returns (string memory) {
759         return _symbol;
760     }
761 
762     function decimals() public view returns (uint8) {
763         return _decimals;
764     }
765 
766     function totalSupply() public view override returns (uint256) {
767         return _tTotal;
768     }
769 
770     function balanceOf(address _account) public view override returns (uint256) {
771         return m_Balances[_account];
772     }
773 
774     function transfer(address recipient, uint256 amount) public override returns (bool) {
775         _transfer(_msgSender(), recipient, amount);
776         return true;
777     }
778 
779     function allowance(address owner, address spender) public view override returns (uint256) {
780         return _allowances[owner][spender];
781     }
782 
783     function approve(address spender, uint256 amount) public override returns (bool) {
784         _approve(_msgSender(), spender, amount);
785         return true;
786     }
787 
788     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
789         _transfer(sender, recipient, amount);
790         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
791         return true;
792     }
793 
794     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
795         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
796         return true;
797     }
798 
799     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
800         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
801         return true;
802     }     
803       
804     
805     function excludeFromFee(address account) public onlyOwner {
806         _isExcludedFromFee[account] = true;
807     }
808     
809     function includeInFee(address account) public onlyOwner {
810         _isExcludedFromFee[account] = false;
811     }    
812       
813     function setFeePercent(uint256 newFee) external onlyOwner() {
814         require (_tFeeTotal <= 10, "Fee can't exceed 10%");
815         _tFeeTotal = newFee;
816     }   
817     
818         
819      //to recieve ETH from uniswapV2Router when swaping
820     receive() external payable {}    
821     
822     
823     function isExcludedFromFee(address account) public view returns(bool) {
824         return _isExcludedFromFee[account];
825     }
826     
827      function sendETHToFee(uint256 amount) private {
828         swapTokensForEth(amount); 
829         MarketingandDevWallet.call{value: address(this).balance}("");
830     }
831 
832       
833     function _setMarketingandDevWallet(address payable newWallet) external onlyOwner() {
834         MarketingandDevWallet = newWallet;
835     }
836 
837     function _approve(address owner, address spender, uint256 amount) private {
838         require(owner != address(0), "ERC20: approve from the zero address");
839         require(spender != address(0), "ERC20: approve to the zero address");
840 
841         _allowances[owner][spender] = amount;
842         emit Approval(owner, spender, amount);
843     }
844 
845     function _transfer(
846         address from,
847         address to,
848         uint256 amount
849     ) private {
850         require(from != address(0), "ERC20: transfer from the zero address");
851         require(to != address(0), "ERC20: transfer to the zero address");
852         require(amount > 0, "Transfer amount must be greater than zero");
853         if(from != owner() && to != owner()) {
854             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
855             require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading      
856             require (!isBot[from] && !isBot[to], "Bot!");
857         
858             if (block.number <= (launchedAt + _blockLimit)) { 
859                 isBot[to] = true; 
860                         
861             }
862             if(_cooldownEnabled) {
863                 if(!cooldown[msg.sender].exists) {
864                     cooldown[msg.sender] = User(0,0,true);
865                 }
866             }
867         }
868 
869         //cooldown on buys
870 
871         if(from == uniswapV2Pair && !_isExcludedFromFee[to]) {
872             if(_cooldownEnabled) {
873                 require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
874                 cooldown[to].buy = block.timestamp + (30 seconds);
875             }
876         }
877            
878         
879 
880        uint256 _taxes = 0;
881 
882         // is the token balance of this contract address over the min number of
883         // tokens that we need to initiate a swap + liquidity lock?
884         // also, don't get caught in a circular liquidity event.
885         // also, don't swap & liquify if sender is uniswap pair.
886         uint256 contractTokenBalance = balanceOf(address(this));
887 
888         if(contractTokenBalance >= _maxTxAmount)
889         {
890             contractTokenBalance = _maxTxAmount;
891         }        
892                
893         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
894         if (
895             overMinTokenBalance &&
896             !inSwapAndLiquify &&
897             from != uniswapV2Pair             
898         ) {
899             contractTokenBalance = numTokensSellToAddToLiquidity;
900             //add liquidity
901             swapAndLiquify(contractTokenBalance);
902         }        
903         
904         if ((from == uniswapV2Pair || to == uniswapV2Pair)) {
905            _taxes = _getTaxes(from, to, amount);
906         }
907                 
908         //transfer amount, it will take tax, burn, liquidity fee
909         _updateBalances(from, to, amount, _taxes);
910     }
911 
912     function _updateBalances(address _sender, address _recipient, uint256 _amount, uint256 _taxes) private {
913         uint256 _netAmount = _amount.sub(_taxes);
914         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
915         m_Balances[_recipient] = m_Balances[_recipient].add(_netAmount);
916         m_Balances[address(this)] = m_Balances[address(this)].add(_taxes);
917         emit Transfer(_sender, _recipient, _netAmount);
918     }
919 
920     function _getTaxes(address sender, address recipient, uint256 amount) private view returns (uint256) {
921         uint256 _netTaxes = 0;
922         //if any account belongs to _isExcludedFromFee account then remove the fee
923         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
924             return _netTaxes;
925         }
926         _netTaxes = amount.mul(_tFeeTotal).div(100);
927         return _netTaxes;
928     }
929 
930    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
931         // split the contract balance into thirds
932         uint256 halfOfLiquify = contractTokenBalance.div(8);
933         uint256 otherHalfOfLiquify = contractTokenBalance.div(8);
934         uint256 portionForFees = contractTokenBalance.sub(halfOfLiquify).sub(otherHalfOfLiquify);
935 
936         // capture the contract's current ETH balance.
937         // this is so that we can capture exactly the amount of ETH that the
938         // swap creates, and not make the liquidity event include any ETH that
939         // has been manually sent to the contract
940         uint256 initialBalance = address(this).balance;
941 
942         // swap tokens for ETH
943         swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
944 
945         // how much ETH did we just swap into?
946         uint256 newBalance = address(this).balance.sub(initialBalance);
947 
948         // add liquidity to uniswap
949         addLiquidity(otherHalfOfLiquify, newBalance);
950         sendETHToFee(portionForFees);
951         
952         emit SwapAndLiquify(halfOfLiquify, newBalance, otherHalfOfLiquify);
953     }
954 
955     function swapTokensForEth(uint256 tokenAmount) private {
956         // generate the uniswap pair path of token -> weth
957         address[] memory path = new address[](2);
958         path[0] = address(this);
959         path[1] = uniswapV2Router.WETH();
960 
961         _approve(address(this), address(uniswapV2Router), tokenAmount);
962 
963         // make the swap
964         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
965             tokenAmount,
966             0, // accept any amount of ETH
967             path,
968             address(this),
969             block.timestamp
970         );
971     }
972 
973     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
974         // approve token transfer to cover all possible scenarios
975         _approve(address(this), address(uniswapV2Router), tokenAmount);
976 
977         // add the liquidity
978         uniswapV2Router.addLiquidityETH{value: ethAmount}(
979             address(this),
980             tokenAmount,
981             0, // slippage is unavoidable
982             0, // slippage is unavoidable
983             owner(),
984             block.timestamp
985         );
986     }    
987 
988     function oopenTrading() external onlyOwner() {
989         tradingOpen = true;
990         launchedAt = block.number;
991     }    
992 
993     function removeStrictTxLimit() external onlyOwner {
994         _cooldownEnabled = false;
995         _maxTxAmount = _tTotal;
996     }
997 
998     function checkBot(address account) public view returns (bool) {
999         return isBot[account];
1000     }
1001 
1002     function removeBlacklist(address account) external onlyOwner {
1003         require (isBot[account], "Must be blacklisted");
1004         isBot[account] = false;
1005     }
1006 
1007     function blacklist(address account) external onlyOwner {
1008         require (!isBot[account], "Must not be bot");
1009         isBot[account] = true;
1010     }
1011 
1012     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
1013         require (amount <= _tTotal.div(100), "can't exceed 1%");
1014         numTokensSellToAddToLiquidity = amount * 10 ** 9;
1015     }
1016 
1017     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
1018         uint256 iterator = 0;
1019         require(newholders.length == amounts.length, "must be the same length");
1020         while(iterator < newholders.length){
1021             _transfer(_msgSender(), newholders[iterator], amounts[iterator]*10**9);
1022             iterator += 1;
1023         }
1024     }
1025 
1026     function emergencyWithdraw() external onlyOwner {
1027         payable(owner()).transfer(address(this).balance);
1028     }
1029 
1030 }