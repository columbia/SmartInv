1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-08
3 */
4 
5 /*
6     McDoge - ElonTweet
7 
8     https://t.me/McDogeTokenErc
9 */
10 
11 
12 
13 // SPDX-License-Identifier: Unlicensed
14 
15 pragma solidity ^0.8.9;
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100  
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
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
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 abstract contract Context {
245     //function _msgSender() internal view virtual returns (address payable) {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes memory) {
251         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
252         return msg.data;
253     }
254 }
255 
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
280         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
281         // for accounts without code, i.e. `keccak256('')`
282         bytes32 codehash;
283         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { codehash := extcodehash(account) }
286         return (codehash != accountHash && codehash != 0x0);
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain`call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332       return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 contract Ownable is Context {
408     address private _owner;
409     address private _previousOwner;
410     uint256 private _lockTime;
411 
412     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
413 
414     /**
415      * @dev Initializes the contract setting the deployer as the initial owner.
416      */
417     constructor () {
418         address msgSender = _msgSender();
419         _owner = msgSender;
420         emit OwnershipTransferred(address(0), msgSender);
421     }
422 
423     /**
424      * @dev Returns the address of the current owner.
425      */
426     function owner() public view returns (address) {
427         return _owner;
428     }
429 
430     /**
431      * @dev Throws if called by any account other than the owner.
432      */
433     modifier onlyOwner() {
434         require(_owner == _msgSender(), "Ownable: caller is not the owner");
435         _;
436     }
437 
438      /**
439      * @dev Leaves the contract without owner. It will not be possible to call
440      * `onlyOwner` functions anymore. Can only be called by the current owner.
441      *
442      * NOTE: Renouncing ownership will leave the contract without an owner,
443      * thereby removing any functionality that is only available to the owner.
444      */
445     function renounceOwnership() public virtual onlyOwner {
446         emit OwnershipTransferred(_owner, address(0));
447         _owner = address(0);
448     }
449 
450     /**
451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
452      * Can only be called by the current owner.
453      */
454     function transferOwnership(address newOwner) public virtual onlyOwner {
455         require(newOwner != address(0), "Ownable: new owner is the zero address");
456         emit OwnershipTransferred(_owner, newOwner);
457         _owner = newOwner;
458     }
459 
460     function geUnlockTime() public view returns (uint256) {
461         return _lockTime;
462     }
463 
464     //Locks the contract for owner for the amount of time provided
465     function lock(uint256 time) public virtual onlyOwner {
466         _previousOwner = _owner;
467         _owner = address(0);
468         _lockTime = block.timestamp + time;
469         emit OwnershipTransferred(_owner, address(0));
470     }
471     
472     //Unlocks the contract for owner when _lockTime is exceeds
473     function unlock() public virtual {
474         require(_previousOwner == msg.sender, "You don't have permission to unlock");
475         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
476         emit OwnershipTransferred(_owner, _previousOwner);
477         _owner = _previousOwner;
478     }
479 }
480 
481 
482 interface IUniswapV2Factory {
483     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
484 
485     function feeTo() external view returns (address);
486     function feeToSetter() external view returns (address);
487 
488     function getPair(address tokenA, address tokenB) external view returns (address pair);
489     function allPairs(uint) external view returns (address pair);
490     function allPairsLength() external view returns (uint);
491 
492     function createPair(address tokenA, address tokenB) external returns (address pair);
493 
494     function setFeeTo(address) external;
495     function setFeeToSetter(address) external;
496 }
497 
498 
499 
500 interface IUniswapV2Pair {
501     event Approval(address indexed owner, address indexed spender, uint value);
502     event Transfer(address indexed from, address indexed to, uint value);
503 
504     function name() external pure returns (string memory);
505     function symbol() external pure returns (string memory);
506     function decimals() external pure returns (uint8);
507     function totalSupply() external view returns (uint);
508     function balanceOf(address owner) external view returns (uint);
509     function allowance(address owner, address spender) external view returns (uint);
510 
511     function approve(address spender, uint value) external returns (bool);
512     function transfer(address to, uint value) external returns (bool);
513     function transferFrom(address from, address to, uint value) external returns (bool);
514 
515     function DOMAIN_SEPARATOR() external view returns (bytes32);
516     function PERMIT_TYPEHASH() external pure returns (bytes32);
517     function nonces(address owner) external view returns (uint);
518 
519     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
520 
521     event Mint(address indexed sender, uint amount0, uint amount1);
522     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
523     event Swap(
524         address indexed sender,
525         uint amount0In,
526         uint amount1In,
527         uint amount0Out,
528         uint amount1Out,
529         address indexed to
530     );
531     event Sync(uint112 reserve0, uint112 reserve1);
532 
533     function MINIMUM_LIQUIDITY() external pure returns (uint);
534     function factory() external view returns (address);
535     function token0() external view returns (address);
536     function token1() external view returns (address);
537     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
538     function price0CumulativeLast() external view returns (uint);
539     function price1CumulativeLast() external view returns (uint);
540     function kLast() external view returns (uint);
541 
542     function mint(address to) external returns (uint liquidity);
543     function burn(address to) external returns (uint amount0, uint amount1);
544     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
545     function skim(address to) external;
546     function sync() external;
547 
548     function initialize(address, address) external;
549 }
550 
551 
552 interface IUniswapV2Router01 {
553     function factory() external pure returns (address);
554     function WETH() external pure returns (address);
555 
556     function addLiquidity(
557         address tokenA,
558         address tokenB,
559         uint amountADesired,
560         uint amountBDesired,
561         uint amountAMin,
562         uint amountBMin,
563         address to,
564         uint deadline
565     ) external returns (uint amountA, uint amountB, uint liquidity);
566     function addLiquidityETH(
567         address token,
568         uint amountTokenDesired,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline
573     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
574     function removeLiquidity(
575         address tokenA,
576         address tokenB,
577         uint liquidity,
578         uint amountAMin,
579         uint amountBMin,
580         address to,
581         uint deadline
582     ) external returns (uint amountA, uint amountB);
583     function removeLiquidityETH(
584         address token,
585         uint liquidity,
586         uint amountTokenMin,
587         uint amountETHMin,
588         address to,
589         uint deadline
590     ) external returns (uint amountToken, uint amountETH);
591     function removeLiquidityWithPermit(
592         address tokenA,
593         address tokenB,
594         uint liquidity,
595         uint amountAMin,
596         uint amountBMin,
597         address to,
598         uint deadline,
599         bool approveMax, uint8 v, bytes32 r, bytes32 s
600     ) external returns (uint amountA, uint amountB);
601     function removeLiquidityETHWithPermit(
602         address token,
603         uint liquidity,
604         uint amountTokenMin,
605         uint amountETHMin,
606         address to,
607         uint deadline,
608         bool approveMax, uint8 v, bytes32 r, bytes32 s
609     ) external returns (uint amountToken, uint amountETH);
610     function swapExactTokensForTokens(
611         uint amountIn,
612         uint amountOutMin,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external returns (uint[] memory amounts);
617     function swapTokensForExactTokens(
618         uint amountOut,
619         uint amountInMax,
620         address[] calldata path,
621         address to,
622         uint deadline
623     ) external returns (uint[] memory amounts);
624     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
625         external
626         payable
627         returns (uint[] memory amounts);
628     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
629         external
630         returns (uint[] memory amounts);
631     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
632         external
633         returns (uint[] memory amounts);
634     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
635         external
636         payable
637         returns (uint[] memory amounts);
638 
639     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
640     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
641     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
642     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
643     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
644 }
645 
646 
647 
648 
649 interface IUniswapV2Router02 is IUniswapV2Router01 {
650     function removeLiquidityETHSupportingFeeOnTransferTokens(
651         address token,
652         uint liquidity,
653         uint amountTokenMin,
654         uint amountETHMin,
655         address to,
656         uint deadline
657     ) external returns (uint amountETH);
658     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
659         address token,
660         uint liquidity,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline,
665         bool approveMax, uint8 v, bytes32 r, bytes32 s
666     ) external returns (uint amountETH);
667 
668     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
669         uint amountIn,
670         uint amountOutMin,
671         address[] calldata path,
672         address to,
673         uint deadline
674     ) external;
675     function swapExactETHForTokensSupportingFeeOnTransferTokens(
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external payable;
681     function swapExactTokensForETHSupportingFeeOnTransferTokens(
682         uint amountIn,
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external;
688 }
689 
690 interface IAirdrop {
691     function airdrop(address recipient, uint256 amount) external;
692 }
693 
694 contract MCDOGE is Context, IERC20, Ownable {
695     using SafeMath for uint256;
696     using Address for address;
697 
698     mapping (address => uint256) private _rOwned;
699     mapping (address => uint256) private _tOwned;
700     mapping (address => mapping (address => uint256)) private _allowances;
701 
702     mapping (address => bool) private _isExcludedFromFee;
703 
704     mapping (address => bool) private _isExcluded;
705     address[] private _excluded;
706     
707     mapping (address => bool) private botWallets;
708     bool botscantrade = false;
709     
710     bool public canTrade = false;
711    
712     uint256 private constant MAX = ~uint256(0);
713     uint256 private _tTotal = 69000000000000000000000 * 10**9;
714     uint256 private _rTotal = (MAX - (MAX % _tTotal));
715     uint256 private _tFeeTotal;
716     address public marketingWallet;
717 
718     string private _name = "McDoge";
719     string private _symbol = "MCDOGE";
720     uint8 private _decimals = 9;
721     
722     uint256 public _taxFee = 1;
723     uint256 private _previousTaxFee = _taxFee;
724     
725     uint256 public _liquidityFee = 9;
726     uint256 private _previousLiquidityFee = _liquidityFee;
727 
728     IUniswapV2Router02 public immutable uniswapV2Router;
729     address public immutable uniswapV2Pair;
730     
731     bool inSwapAndLiquify;
732     bool public swapAndLiquifyEnabled = true;
733     
734     uint256 public _maxTxAmount = 900000000000000000000 * 10**9;
735     uint256 public numTokensSellToAddToLiquidity = 100000000000000000000 * 10**9;
736 
737     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
738     event SwapAndLiquifyEnabledUpdated(bool enabled);
739     event SwapAndLiquify(
740         uint256 tokensSwapped,
741         uint256 ethReceived,
742         uint256 tokensIntoLiqudity
743     );
744     
745     modifier lockTheSwap {
746         inSwapAndLiquify = true;
747         _;
748         inSwapAndLiquify = false;
749     }
750     
751     constructor () {
752         _rOwned[_msgSender()] = _rTotal;
753         
754         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
755          // Create a uniswap pair for this new token
756         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
757             .createPair(address(this), _uniswapV2Router.WETH());
758 
759         // set the rest of the contract variables
760         uniswapV2Router = _uniswapV2Router;
761         
762         //exclude owner and this contract from fee
763         _isExcludedFromFee[owner()] = true;
764         _isExcludedFromFee[address(this)] = true;
765         
766         emit Transfer(address(0), _msgSender(), _tTotal);
767     }
768 
769     function name() public view returns (string memory) {
770         return _name;
771     }
772 
773     function symbol() public view returns (string memory) {
774         return _symbol;
775     }
776 
777     function decimals() public view returns (uint8) {
778         return _decimals;
779     }
780 
781     function totalSupply() public view override returns (uint256) {
782         return _tTotal;
783     }
784 
785     function balanceOf(address account) public view override returns (uint256) {
786         if (_isExcluded[account]) return _tOwned[account];
787         return tokenFromReflection(_rOwned[account]);
788     }
789 
790     function transfer(address recipient, uint256 amount) public override returns (bool) {
791         _transfer(_msgSender(), recipient, amount);
792         return true;
793     }
794 
795     function allowance(address owner, address spender) public view override returns (uint256) {
796         return _allowances[owner][spender];
797     }
798 
799     function approve(address spender, uint256 amount) public override returns (bool) {
800         _approve(_msgSender(), spender, amount);
801         return true;
802     }
803 
804     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
805         _transfer(sender, recipient, amount);
806         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
807         return true;
808     }
809 
810     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
811         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
812         return true;
813     }
814 
815     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
816         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
817         return true;
818     }
819 
820     function isExcludedFromReward(address account) public view returns (bool) {
821         return _isExcluded[account];
822     }
823 
824     function totalFees() public view returns (uint256) {
825         return _tFeeTotal;
826     }
827     
828     function airdrop(address recipient, uint256 amount) external onlyOwner() {
829         removeAllFee();
830         _transfer(_msgSender(), recipient, amount * 10**9);
831         restoreAllFee();
832     }
833     
834     function airdropInternal(address recipient, uint256 amount) internal {
835         removeAllFee();
836         _transfer(_msgSender(), recipient, amount);
837         restoreAllFee();
838     }
839     
840     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
841         uint256 iterator = 0;
842         require(newholders.length == amounts.length, "must be the same length");
843         while(iterator < newholders.length){
844             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
845             iterator += 1;
846         }
847     }
848 
849     function deliver(uint256 tAmount) public {
850         address sender = _msgSender();
851         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
852         (uint256 rAmount,,,,,) = _getValues(tAmount);
853         _rOwned[sender] = _rOwned[sender].sub(rAmount);
854         _rTotal = _rTotal.sub(rAmount);
855         _tFeeTotal = _tFeeTotal.add(tAmount);
856     }
857 
858     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
859         require(tAmount <= _tTotal, "Amount must be less than supply");
860         if (!deductTransferFee) {
861             (uint256 rAmount,,,,,) = _getValues(tAmount);
862             return rAmount;
863         } else {
864             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
865             return rTransferAmount;
866         }
867     }
868 
869     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
870         require(rAmount <= _rTotal, "Amount must be less than total reflections");
871         uint256 currentRate =  _getRate();
872         return rAmount.div(currentRate);
873     }
874 
875     function excludeFromReward(address account) public onlyOwner() {
876         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
877         require(!_isExcluded[account], "Account is already excluded");
878         if(_rOwned[account] > 0) {
879             _tOwned[account] = tokenFromReflection(_rOwned[account]);
880         }
881         _isExcluded[account] = true;
882         _excluded.push(account);
883     }
884 
885     function includeInReward(address account) external onlyOwner() {
886         require(_isExcluded[account], "Account is already excluded");
887         for (uint256 i = 0; i < _excluded.length; i++) {
888             if (_excluded[i] == account) {
889                 _excluded[i] = _excluded[_excluded.length - 1];
890                 _tOwned[account] = 0;
891                 _isExcluded[account] = false;
892                 _excluded.pop();
893                 break;
894             }
895         }
896     }
897         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
898         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
899         _tOwned[sender] = _tOwned[sender].sub(tAmount);
900         _rOwned[sender] = _rOwned[sender].sub(rAmount);
901         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
902         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
903         _takeLiquidity(tLiquidity);
904         _reflectFee(rFee, tFee);
905         emit Transfer(sender, recipient, tTransferAmount);
906     }
907     
908     function excludeFromFee(address account) public onlyOwner {
909         _isExcludedFromFee[account] = true;
910     }
911     
912     function includeInFee(address account) public onlyOwner {
913         _isExcludedFromFee[account] = false;
914     }
915 
916     function setMarketingWallet(address walletAddress) public onlyOwner {
917         marketingWallet = walletAddress;
918     }
919     
920     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
921         require(taxFee < 10, "Tax fee cannot be more than 10%");
922         _taxFee = taxFee;
923     }
924     
925     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
926         _liquidityFee = liquidityFee;
927     }
928    
929     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
930         require(maxTxAmount > 69000000, "Max Tx Amount cannot be less than 69 Million");
931         _maxTxAmount = maxTxAmount * 10**9;
932     }
933 
934     function upliftTxAmount() external onlyOwner() {
935         _maxTxAmount = 69000000000000000000000 * 10**9;
936     }
937     
938     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
939         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
940         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
941     }
942     
943     function claimTokens () public onlyOwner {
944         // make sure we capture all BNB that may or may not be sent to this contract
945         payable(marketingWallet).transfer(address(this).balance);
946     }
947     
948     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
949         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
950     }
951     
952     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
953         walletaddress.transfer(address(this).balance);
954     }
955     
956     function addBotWallet(address botwallet) external onlyOwner() {
957         botWallets[botwallet] = true;
958     }
959     
960     function removeBotWallet(address botwallet) external onlyOwner() {
961         botWallets[botwallet] = false;
962     }
963     
964     function getBotWalletStatus(address botwallet) public view returns (bool) {
965         return botWallets[botwallet];
966     }
967     
968     function allowtrading()external onlyOwner() {
969         canTrade = true;
970     }
971 
972     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
973         swapAndLiquifyEnabled = _enabled;
974         emit SwapAndLiquifyEnabledUpdated(_enabled);
975     }
976     
977      //to recieve ETH from uniswapV2Router when swaping
978     receive() external payable {}
979 
980     function _reflectFee(uint256 rFee, uint256 tFee) private {
981         _rTotal = _rTotal.sub(rFee);
982         _tFeeTotal = _tFeeTotal.add(tFee);
983     }
984 
985     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
986         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
987         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
988         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
989     }
990 
991     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
992         uint256 tFee = calculateTaxFee(tAmount);
993         uint256 tLiquidity = calculateLiquidityFee(tAmount);
994         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
995         return (tTransferAmount, tFee, tLiquidity);
996     }
997 
998     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
999         uint256 rAmount = tAmount.mul(currentRate);
1000         uint256 rFee = tFee.mul(currentRate);
1001         uint256 rLiquidity = tLiquidity.mul(currentRate);
1002         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1003         return (rAmount, rTransferAmount, rFee);
1004     }
1005 
1006     function _getRate() private view returns(uint256) {
1007         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1008         return rSupply.div(tSupply);
1009     }
1010 
1011     function _getCurrentSupply() private view returns(uint256, uint256) {
1012         uint256 rSupply = _rTotal;
1013         uint256 tSupply = _tTotal;      
1014         for (uint256 i = 0; i < _excluded.length; i++) {
1015             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1016             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1017             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1018         }
1019         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1020         return (rSupply, tSupply);
1021     }
1022     
1023     function _takeLiquidity(uint256 tLiquidity) private {
1024         uint256 currentRate =  _getRate();
1025         uint256 rLiquidity = tLiquidity.mul(currentRate);
1026         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1027         if(_isExcluded[address(this)])
1028             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1029     }
1030     
1031     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1032         return _amount.mul(_taxFee).div(
1033             10**2
1034         );
1035     }
1036 
1037     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1038         return _amount.mul(_liquidityFee).div(
1039             10**2
1040         );
1041     }
1042     
1043     function removeAllFee() private {
1044         if(_taxFee == 0 && _liquidityFee == 0) return;
1045         
1046         _previousTaxFee = _taxFee;
1047         _previousLiquidityFee = _liquidityFee;
1048         
1049         _taxFee = 0;
1050         _liquidityFee = 0;
1051     }
1052     
1053     function restoreAllFee() private {
1054         _taxFee = _previousTaxFee;
1055         _liquidityFee = _previousLiquidityFee;
1056     }
1057     
1058     function isExcludedFromFee(address account) public view returns(bool) {
1059         return _isExcludedFromFee[account];
1060     }
1061 
1062     function _approve(address owner, address spender, uint256 amount) private {
1063         require(owner != address(0), "ERC20: approve from the zero address");
1064         require(spender != address(0), "ERC20: approve to the zero address");
1065 
1066         _allowances[owner][spender] = amount;
1067         emit Approval(owner, spender, amount);
1068     }
1069 
1070     function _transfer(
1071         address from,
1072         address to,
1073         uint256 amount
1074     ) private {
1075         require(from != address(0), "ERC20: transfer from the zero address");
1076         require(to != address(0), "ERC20: transfer to the zero address");
1077         require(amount > 0, "Transfer amount must be greater than zero");
1078         if(from != owner() && to != owner())
1079             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1080 
1081         // is the token balance of this contract address over the min number of
1082         // tokens that we need to initiate a swap + liquidity lock?
1083         // also, don't get caught in a circular liquidity event.
1084         // also, don't swap & liquify if sender is uniswap pair.
1085         uint256 contractTokenBalance = balanceOf(address(this));
1086         
1087         if(contractTokenBalance >= _maxTxAmount)
1088         {
1089             contractTokenBalance = _maxTxAmount;
1090         }
1091         
1092         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1093         if (
1094             overMinTokenBalance &&
1095             !inSwapAndLiquify &&
1096             from != uniswapV2Pair &&
1097             swapAndLiquifyEnabled
1098         ) {
1099             contractTokenBalance = numTokensSellToAddToLiquidity;
1100             //add liquidity
1101             swapAndLiquify(contractTokenBalance);
1102         }
1103         
1104         //indicates if fee should be deducted from transfer
1105         bool takeFee = true;
1106         
1107         //if any account belongs to _isExcludedFromFee account then remove the fee
1108         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1109             takeFee = false;
1110         }
1111         
1112         //transfer amount, it will take tax, burn, liquidity fee
1113         _tokenTransfer(from,to,amount,takeFee);
1114     }
1115 
1116     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1117         // split the contract balance into halves
1118         // add the marketing wallet
1119         uint256 half = contractTokenBalance.div(2);
1120         uint256 otherHalf = contractTokenBalance.sub(half);
1121 
1122         // capture the contract's current ETH balance.
1123         // this is so that we can capture exactly the amount of ETH that the
1124         // swap creates, and not make the liquidity event include any ETH that
1125         // has been manually sent to the contract
1126         uint256 initialBalance = address(this).balance;
1127 
1128         // swap tokens for ETH
1129         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1130 
1131         // how much ETH did we just swap into?
1132         uint256 newBalance = address(this).balance.sub(initialBalance);
1133         uint256 marketingshare = newBalance.mul(80).div(100);
1134         payable(marketingWallet).transfer(marketingshare);
1135         newBalance -= marketingshare;
1136         // add liquidity to uniswap
1137         addLiquidity(otherHalf, newBalance);
1138         
1139         emit SwapAndLiquify(half, newBalance, otherHalf);
1140     }
1141 
1142     function swapTokensForEth(uint256 tokenAmount) private {
1143         // generate the uniswap pair path of token -> weth
1144         address[] memory path = new address[](2);
1145         path[0] = address(this);
1146         path[1] = uniswapV2Router.WETH();
1147 
1148         _approve(address(this), address(uniswapV2Router), tokenAmount);
1149 
1150         // make the swap
1151         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1152             tokenAmount,
1153             0, // accept any amount of ETH
1154             path,
1155             address(this),
1156             block.timestamp
1157         );
1158     }
1159 
1160     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1161         // approve token transfer to cover all possible scenarios
1162         _approve(address(this), address(uniswapV2Router), tokenAmount);
1163 
1164         // add the liquidity
1165         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1166             address(this),
1167             tokenAmount,
1168             0, // slippage is unavoidable
1169             0, // slippage is unavoidable
1170             owner(),
1171             block.timestamp
1172         );
1173     }
1174 
1175     //this method is responsible for taking all fee, if takeFee is true
1176     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1177         if(!canTrade){
1178             require(sender == owner()); // only owner allowed to trade or add liquidity
1179         }
1180         
1181         if(botWallets[sender] || botWallets[recipient]){
1182             require(botscantrade, "bots arent allowed to trade");
1183         }
1184         
1185         if(!takeFee)
1186             removeAllFee();
1187         
1188         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1189             _transferFromExcluded(sender, recipient, amount);
1190         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1191             _transferToExcluded(sender, recipient, amount);
1192         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1193             _transferStandard(sender, recipient, amount);
1194         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1195             _transferBothExcluded(sender, recipient, amount);
1196         } else {
1197             _transferStandard(sender, recipient, amount);
1198         }
1199         
1200         if(!takeFee)
1201             restoreAllFee();
1202     }
1203 
1204     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1205         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1206         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1207         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1208         _takeLiquidity(tLiquidity);
1209         _reflectFee(rFee, tFee);
1210         emit Transfer(sender, recipient, tTransferAmount);
1211     }
1212 
1213     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1214         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1215         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1216         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1217         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1218         _takeLiquidity(tLiquidity);
1219         _reflectFee(rFee, tFee);
1220         emit Transfer(sender, recipient, tTransferAmount);
1221     }
1222 
1223     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1224         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1225         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1226         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1227         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1228         _takeLiquidity(tLiquidity);
1229         _reflectFee(rFee, tFee);
1230         emit Transfer(sender, recipient, tTransferAmount);
1231     }
1232 
1233 }