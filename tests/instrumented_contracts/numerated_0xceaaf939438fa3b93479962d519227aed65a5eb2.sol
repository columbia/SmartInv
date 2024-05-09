1 /*
2 
3     SHIBMONG
4 
5     https://shibmong.com/
6 
7 
8 */
9 
10 
11 
12 // SPDX-License-Identifier: Unlicensed
13 
14 pragma solidity ^0.8.9;
15 interface IERC20 {
16 
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99  
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 abstract contract Context {
244     //function _msgSender() internal view virtual returns (address payable) {
245     function _msgSender() internal view virtual returns (address) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes memory) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
279         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
280         // for accounts without code, i.e. `keccak256('')`
281         bytes32 codehash;
282         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { codehash := extcodehash(account) }
285         return (codehash != accountHash && codehash != 0x0);
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain`call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331       return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
341         return _functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         return _functionCallWithValue(target, data, value, errorMessage);
368     }
369 
370     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
371         require(isContract(target), "Address: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 /**
395  * @dev Contract module which provides a basic access control mechanism, where
396  * there is an account (an owner) that can be granted exclusive access to
397  * specific functions.
398  *
399  * By default, the owner account will be the one that deploys the contract. This
400  * can later be changed with {transferOwnership}.
401  *
402  * This module is used through inheritance. It will make available the modifier
403  * `onlyOwner`, which can be applied to your functions to restrict their use to
404  * the owner.
405  */
406 contract Ownable is Context {
407     address private _owner;
408     address private _previousOwner;
409     uint256 private _lockTime;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     /**
414      * @dev Initializes the contract setting the deployer as the initial owner.
415      */
416     constructor () {
417         address msgSender = _msgSender();
418         _owner = msgSender;
419         emit OwnershipTransferred(address(0), msgSender);
420     }
421 
422     /**
423      * @dev Returns the address of the current owner.
424      */
425     function owner() public view returns (address) {
426         return _owner;
427     }
428 
429     /**
430      * @dev Throws if called by any account other than the owner.
431      */
432     modifier onlyOwner() {
433         require(_owner == _msgSender(), "Ownable: caller is not the owner");
434         _;
435     }
436 
437      /**
438      * @dev Leaves the contract without owner. It will not be possible to call
439      * `onlyOwner` functions anymore. Can only be called by the current owner.
440      *
441      * NOTE: Renouncing ownership will leave the contract without an owner,
442      * thereby removing any functionality that is only available to the owner.
443      */
444     function renounceOwnership() public virtual onlyOwner {
445         emit OwnershipTransferred(_owner, address(0));
446         _owner = address(0);
447     }
448 
449     /**
450      * @dev Transfers ownership of the contract to a new account (`newOwner`).
451      * Can only be called by the current owner.
452      */
453     function transferOwnership(address newOwner) public virtual onlyOwner {
454         require(newOwner != address(0), "Ownable: new owner is the zero address");
455         emit OwnershipTransferred(_owner, newOwner);
456         _owner = newOwner;
457     }
458 
459     function geUnlockTime() public view returns (uint256) {
460         return _lockTime;
461     }
462 
463     //Locks the contract for owner for the amount of time provided
464     function lock(uint256 time) public virtual onlyOwner {
465         _previousOwner = _owner;
466         _owner = address(0);
467         _lockTime = block.timestamp + time;
468         emit OwnershipTransferred(_owner, address(0));
469     }
470     
471     //Unlocks the contract for owner when _lockTime is exceeds
472     function unlock() public virtual {
473         require(_previousOwner == msg.sender, "You don't have permission to unlock");
474         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
475         emit OwnershipTransferred(_owner, _previousOwner);
476         _owner = _previousOwner;
477     }
478 }
479 
480 
481 interface IUniswapV2Factory {
482     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
483 
484     function feeTo() external view returns (address);
485     function feeToSetter() external view returns (address);
486 
487     function getPair(address tokenA, address tokenB) external view returns (address pair);
488     function allPairs(uint) external view returns (address pair);
489     function allPairsLength() external view returns (uint);
490 
491     function createPair(address tokenA, address tokenB) external returns (address pair);
492 
493     function setFeeTo(address) external;
494     function setFeeToSetter(address) external;
495 }
496 
497 
498 
499 interface IUniswapV2Pair {
500     event Approval(address indexed owner, address indexed spender, uint value);
501     event Transfer(address indexed from, address indexed to, uint value);
502 
503     function name() external pure returns (string memory);
504     function symbol() external pure returns (string memory);
505     function decimals() external pure returns (uint8);
506     function totalSupply() external view returns (uint);
507     function balanceOf(address owner) external view returns (uint);
508     function allowance(address owner, address spender) external view returns (uint);
509 
510     function approve(address spender, uint value) external returns (bool);
511     function transfer(address to, uint value) external returns (bool);
512     function transferFrom(address from, address to, uint value) external returns (bool);
513 
514     function DOMAIN_SEPARATOR() external view returns (bytes32);
515     function PERMIT_TYPEHASH() external pure returns (bytes32);
516     function nonces(address owner) external view returns (uint);
517 
518     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
519 
520     event Mint(address indexed sender, uint amount0, uint amount1);
521     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
522     event Swap(
523         address indexed sender,
524         uint amount0In,
525         uint amount1In,
526         uint amount0Out,
527         uint amount1Out,
528         address indexed to
529     );
530     event Sync(uint112 reserve0, uint112 reserve1);
531 
532     function MINIMUM_LIQUIDITY() external pure returns (uint);
533     function factory() external view returns (address);
534     function token0() external view returns (address);
535     function token1() external view returns (address);
536     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
537     function price0CumulativeLast() external view returns (uint);
538     function price1CumulativeLast() external view returns (uint);
539     function kLast() external view returns (uint);
540 
541     function mint(address to) external returns (uint liquidity);
542     function burn(address to) external returns (uint amount0, uint amount1);
543     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
544     function skim(address to) external;
545     function sync() external;
546 
547     function initialize(address, address) external;
548 }
549 
550 
551 interface IUniswapV2Router01 {
552     function factory() external pure returns (address);
553     function WETH() external pure returns (address);
554 
555     function addLiquidity(
556         address tokenA,
557         address tokenB,
558         uint amountADesired,
559         uint amountBDesired,
560         uint amountAMin,
561         uint amountBMin,
562         address to,
563         uint deadline
564     ) external returns (uint amountA, uint amountB, uint liquidity);
565     function addLiquidityETH(
566         address token,
567         uint amountTokenDesired,
568         uint amountTokenMin,
569         uint amountETHMin,
570         address to,
571         uint deadline
572     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
573     function removeLiquidity(
574         address tokenA,
575         address tokenB,
576         uint liquidity,
577         uint amountAMin,
578         uint amountBMin,
579         address to,
580         uint deadline
581     ) external returns (uint amountA, uint amountB);
582     function removeLiquidityETH(
583         address token,
584         uint liquidity,
585         uint amountTokenMin,
586         uint amountETHMin,
587         address to,
588         uint deadline
589     ) external returns (uint amountToken, uint amountETH);
590     function removeLiquidityWithPermit(
591         address tokenA,
592         address tokenB,
593         uint liquidity,
594         uint amountAMin,
595         uint amountBMin,
596         address to,
597         uint deadline,
598         bool approveMax, uint8 v, bytes32 r, bytes32 s
599     ) external returns (uint amountA, uint amountB);
600     function removeLiquidityETHWithPermit(
601         address token,
602         uint liquidity,
603         uint amountTokenMin,
604         uint amountETHMin,
605         address to,
606         uint deadline,
607         bool approveMax, uint8 v, bytes32 r, bytes32 s
608     ) external returns (uint amountToken, uint amountETH);
609     function swapExactTokensForTokens(
610         uint amountIn,
611         uint amountOutMin,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external returns (uint[] memory amounts);
616     function swapTokensForExactTokens(
617         uint amountOut,
618         uint amountInMax,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external returns (uint[] memory amounts);
623     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
624         external
625         payable
626         returns (uint[] memory amounts);
627     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
628         external
629         returns (uint[] memory amounts);
630     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
631         external
632         returns (uint[] memory amounts);
633     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
634         external
635         payable
636         returns (uint[] memory amounts);
637 
638     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
639     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
640     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
641     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
642     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
643 }
644 
645 
646 
647 
648 interface IUniswapV2Router02 is IUniswapV2Router01 {
649     function removeLiquidityETHSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline
656     ) external returns (uint amountETH);
657     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline,
664         bool approveMax, uint8 v, bytes32 r, bytes32 s
665     ) external returns (uint amountETH);
666 
667     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
668         uint amountIn,
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external;
674     function swapExactETHForTokensSupportingFeeOnTransferTokens(
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external payable;
680     function swapExactTokensForETHSupportingFeeOnTransferTokens(
681         uint amountIn,
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external;
687 }
688 
689 interface IAirdrop {
690     function airdrop(address recipient, uint256 amount) external;
691 }
692 
693 contract SHIBMONG is Context, IERC20, Ownable {
694     using SafeMath for uint256;
695     using Address for address;
696 
697     mapping (address => uint256) private _rOwned;
698     mapping (address => uint256) private _tOwned;
699     mapping (address => mapping (address => uint256)) private _allowances;
700 
701     mapping (address => bool) private _isExcludedFromFee;
702 
703     mapping (address => bool) private _isExcluded;
704     address[] private _excluded;
705     
706     mapping (address => bool) private botWallets;
707     bool botscantrade = false;
708     
709     bool public canTrade = false;
710    
711     uint256 private constant MAX = ~uint256(0);
712     uint256 private _tTotal = 69000000000000000000000 * 10**9;
713     uint256 private _rTotal = (MAX - (MAX % _tTotal));
714     uint256 private _tFeeTotal;
715     address public marketingWallet;
716 
717     string private _name = "Shiba Mongoose";
718     string private _symbol = "SHIBMONG";
719     uint8 private _decimals = 9;
720     
721     uint256 public _taxFee = 1;
722     uint256 private _previousTaxFee = _taxFee;
723     
724     uint256 public _liquidityFee = 12;
725     uint256 private _previousLiquidityFee = _liquidityFee;
726 
727     IUniswapV2Router02 public immutable uniswapV2Router;
728     address public immutable uniswapV2Pair;
729     
730     bool inSwapAndLiquify;
731     bool public swapAndLiquifyEnabled = true;
732     
733     uint256 public _maxTxAmount = 990000000000000000000 * 10**9;
734     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
735     
736     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
737     event SwapAndLiquifyEnabledUpdated(bool enabled);
738     event SwapAndLiquify(
739         uint256 tokensSwapped,
740         uint256 ethReceived,
741         uint256 tokensIntoLiqudity
742     );
743     
744     modifier lockTheSwap {
745         inSwapAndLiquify = true;
746         _;
747         inSwapAndLiquify = false;
748     }
749     
750     constructor () {
751         _rOwned[_msgSender()] = _rTotal;
752         
753         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
754          // Create a uniswap pair for this new token
755         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
756             .createPair(address(this), _uniswapV2Router.WETH());
757 
758         // set the rest of the contract variables
759         uniswapV2Router = _uniswapV2Router;
760         
761         //exclude owner and this contract from fee
762         _isExcludedFromFee[owner()] = true;
763         _isExcludedFromFee[address(this)] = true;
764         
765         emit Transfer(address(0), _msgSender(), _tTotal);
766     }
767 
768     function name() public view returns (string memory) {
769         return _name;
770     }
771 
772     function symbol() public view returns (string memory) {
773         return _symbol;
774     }
775 
776     function decimals() public view returns (uint8) {
777         return _decimals;
778     }
779 
780     function totalSupply() public view override returns (uint256) {
781         return _tTotal;
782     }
783 
784     function balanceOf(address account) public view override returns (uint256) {
785         if (_isExcluded[account]) return _tOwned[account];
786         return tokenFromReflection(_rOwned[account]);
787     }
788 
789     function transfer(address recipient, uint256 amount) public override returns (bool) {
790         _transfer(_msgSender(), recipient, amount);
791         return true;
792     }
793 
794     function allowance(address owner, address spender) public view override returns (uint256) {
795         return _allowances[owner][spender];
796     }
797 
798     function approve(address spender, uint256 amount) public override returns (bool) {
799         _approve(_msgSender(), spender, amount);
800         return true;
801     }
802 
803     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
804         _transfer(sender, recipient, amount);
805         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
806         return true;
807     }
808 
809     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
811         return true;
812     }
813 
814     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
815         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
816         return true;
817     }
818 
819     function isExcludedFromReward(address account) public view returns (bool) {
820         return _isExcluded[account];
821     }
822 
823     function totalFees() public view returns (uint256) {
824         return _tFeeTotal;
825     }
826     
827     function airdrop(address recipient, uint256 amount) external onlyOwner() {
828         removeAllFee();
829         _transfer(_msgSender(), recipient, amount * 10**9);
830         restoreAllFee();
831     }
832     
833     function airdropInternal(address recipient, uint256 amount) internal {
834         removeAllFee();
835         _transfer(_msgSender(), recipient, amount);
836         restoreAllFee();
837     }
838     
839     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
840         uint256 iterator = 0;
841         require(newholders.length == amounts.length, "must be the same length");
842         while(iterator < newholders.length){
843             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
844             iterator += 1;
845         }
846     }
847 
848     function deliver(uint256 tAmount) public {
849         address sender = _msgSender();
850         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
851         (uint256 rAmount,,,,,) = _getValues(tAmount);
852         _rOwned[sender] = _rOwned[sender].sub(rAmount);
853         _rTotal = _rTotal.sub(rAmount);
854         _tFeeTotal = _tFeeTotal.add(tAmount);
855     }
856 
857     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
858         require(tAmount <= _tTotal, "Amount must be less than supply");
859         if (!deductTransferFee) {
860             (uint256 rAmount,,,,,) = _getValues(tAmount);
861             return rAmount;
862         } else {
863             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
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
874     function excludeFromReward(address account) public onlyOwner() {
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
885         require(_isExcluded[account], "Account is already excluded");
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
897         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
898         _tOwned[sender] = _tOwned[sender].sub(tAmount);
899         _rOwned[sender] = _rOwned[sender].sub(rAmount);
900         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
901         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
902         _takeLiquidity(tLiquidity);
903         _reflectFee(rFee, tFee);
904         emit Transfer(sender, recipient, tTransferAmount);
905     }
906     
907     function excludeFromFee(address account) public onlyOwner {
908         _isExcludedFromFee[account] = true;
909     }
910     
911     function includeInFee(address account) public onlyOwner {
912         _isExcludedFromFee[account] = false;
913     }
914 
915     function setMarketingWallet(address walletAddress) public onlyOwner {
916         marketingWallet = walletAddress;
917     }
918 
919     function upliftTxAmount() external onlyOwner() {
920         _maxTxAmount = 69000000000000000000000 * 10**9;
921     }
922     
923     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
924         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
925         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
926     }
927     
928     function claimTokens () public onlyOwner {
929         // make sure we capture all BNB that may or may not be sent to this contract
930         payable(marketingWallet).transfer(address(this).balance);
931     }
932     
933     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
934         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
935     }
936     
937     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
938         walletaddress.transfer(address(this).balance);
939     }
940     
941     function addBotWallet(address botwallet) external onlyOwner() {
942         botWallets[botwallet] = true;
943     }
944     
945     function removeBotWallet(address botwallet) external onlyOwner() {
946         botWallets[botwallet] = false;
947     }
948     
949     function getBotWalletStatus(address botwallet) public view returns (bool) {
950         return botWallets[botwallet];
951     }
952     
953     function allowtrading()external onlyOwner() {
954         canTrade = true;
955     }
956 
957     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
958         swapAndLiquifyEnabled = _enabled;
959         emit SwapAndLiquifyEnabledUpdated(_enabled);
960     }
961     
962      //to recieve ETH from uniswapV2Router when swaping
963     receive() external payable {}
964 
965     function _reflectFee(uint256 rFee, uint256 tFee) private {
966         _rTotal = _rTotal.sub(rFee);
967         _tFeeTotal = _tFeeTotal.add(tFee);
968     }
969 
970     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
971         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
972         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
973         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
974     }
975 
976     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
977         uint256 tFee = calculateTaxFee(tAmount);
978         uint256 tLiquidity = calculateLiquidityFee(tAmount);
979         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
980         return (tTransferAmount, tFee, tLiquidity);
981     }
982 
983     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
984         uint256 rAmount = tAmount.mul(currentRate);
985         uint256 rFee = tFee.mul(currentRate);
986         uint256 rLiquidity = tLiquidity.mul(currentRate);
987         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
988         return (rAmount, rTransferAmount, rFee);
989     }
990 
991     function _getRate() private view returns(uint256) {
992         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
993         return rSupply.div(tSupply);
994     }
995 
996     function _getCurrentSupply() private view returns(uint256, uint256) {
997         uint256 rSupply = _rTotal;
998         uint256 tSupply = _tTotal;      
999         for (uint256 i = 0; i < _excluded.length; i++) {
1000             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1001             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1002             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1003         }
1004         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1005         return (rSupply, tSupply);
1006     }
1007     
1008     function _takeLiquidity(uint256 tLiquidity) private {
1009         uint256 currentRate =  _getRate();
1010         uint256 rLiquidity = tLiquidity.mul(currentRate);
1011         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1012         if(_isExcluded[address(this)])
1013             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1014     }
1015     
1016     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1017         return _amount.mul(_taxFee).div(
1018             10**2
1019         );
1020     }
1021 
1022     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1023         return _amount.mul(_liquidityFee).div(
1024             10**2
1025         );
1026     }
1027     
1028     function removeAllFee() private {
1029         if(_taxFee == 0 && _liquidityFee == 0) return;
1030         
1031         _previousTaxFee = _taxFee;
1032         _previousLiquidityFee = _liquidityFee;
1033         
1034         _taxFee = 0;
1035         _liquidityFee = 0;
1036     }
1037     
1038     function restoreAllFee() private {
1039         _taxFee = _previousTaxFee;
1040         _liquidityFee = _previousLiquidityFee;
1041     }
1042     
1043     function isExcludedFromFee(address account) public view returns(bool) {
1044         return _isExcludedFromFee[account];
1045     }
1046 
1047     function _approve(address owner, address spender, uint256 amount) private {
1048         require(owner != address(0), "ERC20: approve from the zero address");
1049         require(spender != address(0), "ERC20: approve to the zero address");
1050 
1051         _allowances[owner][spender] = amount;
1052         emit Approval(owner, spender, amount);
1053     }
1054 
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 amount
1059     ) private {
1060         require(from != address(0), "ERC20: transfer from the zero address");
1061         require(to != address(0), "ERC20: transfer to the zero address");
1062         require(amount > 0, "Transfer amount must be greater than zero");
1063         if(from != owner() && to != owner())
1064             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1065 
1066         // is the token balance of this contract address over the min number of
1067         // tokens that we need to initiate a swap + liquidity lock?
1068         // also, don't get caught in a circular liquidity event.
1069         // also, don't swap & liquify if sender is uniswap pair.
1070         uint256 contractTokenBalance = balanceOf(address(this));
1071         
1072         if(contractTokenBalance >= _maxTxAmount)
1073         {
1074             contractTokenBalance = _maxTxAmount;
1075         }
1076         
1077         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1078         if (
1079             overMinTokenBalance &&
1080             !inSwapAndLiquify &&
1081             from != uniswapV2Pair &&
1082             swapAndLiquifyEnabled
1083         ) {
1084             contractTokenBalance = numTokensSellToAddToLiquidity;
1085             //add liquidity
1086             swapAndLiquify(contractTokenBalance);
1087         }
1088         
1089         //indicates if fee should be deducted from transfer
1090         bool takeFee = true;
1091         
1092         //if any account belongs to _isExcludedFromFee account then remove the fee
1093         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1094             takeFee = false;
1095         }
1096         
1097         //transfer amount, it will take tax, burn, liquidity fee
1098         _tokenTransfer(from,to,amount,takeFee);
1099     }
1100 
1101     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1102         // split the contract balance into halves
1103         // add the marketing wallet
1104         uint256 half = contractTokenBalance.div(2);
1105         uint256 otherHalf = contractTokenBalance.sub(half);
1106 
1107         // capture the contract's current ETH balance.
1108         // this is so that we can capture exactly the amount of ETH that the
1109         // swap creates, and not make the liquidity event include any ETH that
1110         // has been manually sent to the contract
1111         uint256 initialBalance = address(this).balance;
1112 
1113         // swap tokens for ETH
1114         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1115 
1116         // how much ETH did we just swap into?
1117         uint256 newBalance = address(this).balance.sub(initialBalance);
1118         uint256 marketingshare = newBalance.mul(75).div(100);
1119         payable(marketingWallet).transfer(marketingshare);
1120         newBalance -= marketingshare;
1121         // add liquidity to uniswap
1122         addLiquidity(otherHalf, newBalance);
1123         
1124         emit SwapAndLiquify(half, newBalance, otherHalf);
1125     }
1126 
1127     function swapTokensForEth(uint256 tokenAmount) private {
1128         // generate the uniswap pair path of token -> weth
1129         address[] memory path = new address[](2);
1130         path[0] = address(this);
1131         path[1] = uniswapV2Router.WETH();
1132 
1133         _approve(address(this), address(uniswapV2Router), tokenAmount);
1134 
1135         // make the swap
1136         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1137             tokenAmount,
1138             0, // accept any amount of ETH
1139             path,
1140             address(this),
1141             block.timestamp
1142         );
1143     }
1144 
1145     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1146         // approve token transfer to cover all possible scenarios
1147         _approve(address(this), address(uniswapV2Router), tokenAmount);
1148 
1149         // add the liquidity
1150         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1151             address(this),
1152             tokenAmount,
1153             0, // slippage is unavoidable
1154             0, // slippage is unavoidable
1155             owner(),
1156             block.timestamp
1157         );
1158     }
1159 
1160     //this method is responsible for taking all fee, if takeFee is true
1161     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1162         if(!canTrade){
1163             require(sender == owner()); // only owner allowed to trade or add liquidity
1164         }
1165         
1166         if(botWallets[sender] || botWallets[recipient]){
1167             require(botscantrade, "bots arent allowed to trade");
1168         }
1169         
1170         if(!takeFee)
1171             removeAllFee();
1172         
1173         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1174             _transferFromExcluded(sender, recipient, amount);
1175         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1176             _transferToExcluded(sender, recipient, amount);
1177         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1178             _transferStandard(sender, recipient, amount);
1179         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1180             _transferBothExcluded(sender, recipient, amount);
1181         } else {
1182             _transferStandard(sender, recipient, amount);
1183         }
1184         
1185         if(!takeFee)
1186             restoreAllFee();
1187     }
1188 
1189     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1190         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1191         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1192         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1193         _takeLiquidity(tLiquidity);
1194         _reflectFee(rFee, tFee);
1195         emit Transfer(sender, recipient, tTransferAmount);
1196     }
1197 
1198     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1199         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1200         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1201         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1202         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1203         _takeLiquidity(tLiquidity);
1204         _reflectFee(rFee, tFee);
1205         emit Transfer(sender, recipient, tTransferAmount);
1206     }
1207 
1208     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1209         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1210         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1211         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1212         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1213         _takeLiquidity(tLiquidity);
1214         _reflectFee(rFee, tFee);
1215         emit Transfer(sender, recipient, tTransferAmount);
1216     }
1217 
1218 }