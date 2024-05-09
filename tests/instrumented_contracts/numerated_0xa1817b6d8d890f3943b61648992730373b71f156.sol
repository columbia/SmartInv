1 /*
2 
3     Mongoose Coin!
4 
5     https://t.me/MongooseCoin
6 */
7 
8 
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity ^0.8.9;
13 interface IERC20 {
14 
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97  
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 abstract contract Context {
242     //function _msgSender() internal view virtual returns (address payable) {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes memory) {
248         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
249         return msg.data;
250     }
251 }
252 
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
276         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
277         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
278         // for accounts without code, i.e. `keccak256('')`
279         bytes32 codehash;
280         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { codehash := extcodehash(account) }
283         return (codehash != accountHash && codehash != 0x0);
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
339         return _functionCallWithValue(target, data, 0, errorMessage);
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
365         return _functionCallWithValue(target, data, value, errorMessage);
366     }
367 
368     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
369         require(isContract(target), "Address: call to non-contract");
370 
371         // solhint-disable-next-line avoid-low-level-calls
372         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 // solhint-disable-next-line no-inline-assembly
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 /**
393  * @dev Contract module which provides a basic access control mechanism, where
394  * there is an account (an owner) that can be granted exclusive access to
395  * specific functions.
396  *
397  * By default, the owner account will be the one that deploys the contract. This
398  * can later be changed with {transferOwnership}.
399  *
400  * This module is used through inheritance. It will make available the modifier
401  * `onlyOwner`, which can be applied to your functions to restrict their use to
402  * the owner.
403  */
404 contract Ownable is Context {
405     address private _owner;
406     address private _previousOwner;
407     uint256 private _lockTime;
408 
409     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411     /**
412      * @dev Initializes the contract setting the deployer as the initial owner.
413      */
414     constructor () {
415         address msgSender = _msgSender();
416         _owner = msgSender;
417         emit OwnershipTransferred(address(0), msgSender);
418     }
419 
420     /**
421      * @dev Returns the address of the current owner.
422      */
423     function owner() public view returns (address) {
424         return _owner;
425     }
426 
427     /**
428      * @dev Throws if called by any account other than the owner.
429      */
430     modifier onlyOwner() {
431         require(_owner == _msgSender(), "Ownable: caller is not the owner");
432         _;
433     }
434 
435      /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         emit OwnershipTransferred(_owner, address(0));
444         _owner = address(0);
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Can only be called by the current owner.
450      */
451     function transferOwnership(address newOwner) public virtual onlyOwner {
452         require(newOwner != address(0), "Ownable: new owner is the zero address");
453         emit OwnershipTransferred(_owner, newOwner);
454         _owner = newOwner;
455     }
456 
457     function geUnlockTime() public view returns (uint256) {
458         return _lockTime;
459     }
460 
461     //Locks the contract for owner for the amount of time provided
462     function lock(uint256 time) public virtual onlyOwner {
463         _previousOwner = _owner;
464         _owner = address(0);
465         _lockTime = block.timestamp + time;
466         emit OwnershipTransferred(_owner, address(0));
467     }
468     
469     //Unlocks the contract for owner when _lockTime is exceeds
470     function unlock() public virtual {
471         require(_previousOwner == msg.sender, "You don't have permission to unlock");
472         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
473         emit OwnershipTransferred(_owner, _previousOwner);
474         _owner = _previousOwner;
475     }
476 }
477 
478 
479 interface IUniswapV2Factory {
480     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
481 
482     function feeTo() external view returns (address);
483     function feeToSetter() external view returns (address);
484 
485     function getPair(address tokenA, address tokenB) external view returns (address pair);
486     function allPairs(uint) external view returns (address pair);
487     function allPairsLength() external view returns (uint);
488 
489     function createPair(address tokenA, address tokenB) external returns (address pair);
490 
491     function setFeeTo(address) external;
492     function setFeeToSetter(address) external;
493 }
494 
495 
496 
497 interface IUniswapV2Pair {
498     event Approval(address indexed owner, address indexed spender, uint value);
499     event Transfer(address indexed from, address indexed to, uint value);
500 
501     function name() external pure returns (string memory);
502     function symbol() external pure returns (string memory);
503     function decimals() external pure returns (uint8);
504     function totalSupply() external view returns (uint);
505     function balanceOf(address owner) external view returns (uint);
506     function allowance(address owner, address spender) external view returns (uint);
507 
508     function approve(address spender, uint value) external returns (bool);
509     function transfer(address to, uint value) external returns (bool);
510     function transferFrom(address from, address to, uint value) external returns (bool);
511 
512     function DOMAIN_SEPARATOR() external view returns (bytes32);
513     function PERMIT_TYPEHASH() external pure returns (bytes32);
514     function nonces(address owner) external view returns (uint);
515 
516     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
517 
518     event Mint(address indexed sender, uint amount0, uint amount1);
519     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
520     event Swap(
521         address indexed sender,
522         uint amount0In,
523         uint amount1In,
524         uint amount0Out,
525         uint amount1Out,
526         address indexed to
527     );
528     event Sync(uint112 reserve0, uint112 reserve1);
529 
530     function MINIMUM_LIQUIDITY() external pure returns (uint);
531     function factory() external view returns (address);
532     function token0() external view returns (address);
533     function token1() external view returns (address);
534     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
535     function price0CumulativeLast() external view returns (uint);
536     function price1CumulativeLast() external view returns (uint);
537     function kLast() external view returns (uint);
538 
539     function mint(address to) external returns (uint liquidity);
540     function burn(address to) external returns (uint amount0, uint amount1);
541     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
542     function skim(address to) external;
543     function sync() external;
544 
545     function initialize(address, address) external;
546 }
547 
548 
549 interface IUniswapV2Router01 {
550     function factory() external pure returns (address);
551     function WETH() external pure returns (address);
552 
553     function addLiquidity(
554         address tokenA,
555         address tokenB,
556         uint amountADesired,
557         uint amountBDesired,
558         uint amountAMin,
559         uint amountBMin,
560         address to,
561         uint deadline
562     ) external returns (uint amountA, uint amountB, uint liquidity);
563     function addLiquidityETH(
564         address token,
565         uint amountTokenDesired,
566         uint amountTokenMin,
567         uint amountETHMin,
568         address to,
569         uint deadline
570     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
571     function removeLiquidity(
572         address tokenA,
573         address tokenB,
574         uint liquidity,
575         uint amountAMin,
576         uint amountBMin,
577         address to,
578         uint deadline
579     ) external returns (uint amountA, uint amountB);
580     function removeLiquidityETH(
581         address token,
582         uint liquidity,
583         uint amountTokenMin,
584         uint amountETHMin,
585         address to,
586         uint deadline
587     ) external returns (uint amountToken, uint amountETH);
588     function removeLiquidityWithPermit(
589         address tokenA,
590         address tokenB,
591         uint liquidity,
592         uint amountAMin,
593         uint amountBMin,
594         address to,
595         uint deadline,
596         bool approveMax, uint8 v, bytes32 r, bytes32 s
597     ) external returns (uint amountA, uint amountB);
598     function removeLiquidityETHWithPermit(
599         address token,
600         uint liquidity,
601         uint amountTokenMin,
602         uint amountETHMin,
603         address to,
604         uint deadline,
605         bool approveMax, uint8 v, bytes32 r, bytes32 s
606     ) external returns (uint amountToken, uint amountETH);
607     function swapExactTokensForTokens(
608         uint amountIn,
609         uint amountOutMin,
610         address[] calldata path,
611         address to,
612         uint deadline
613     ) external returns (uint[] memory amounts);
614     function swapTokensForExactTokens(
615         uint amountOut,
616         uint amountInMax,
617         address[] calldata path,
618         address to,
619         uint deadline
620     ) external returns (uint[] memory amounts);
621     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
622         external
623         payable
624         returns (uint[] memory amounts);
625     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
626         external
627         returns (uint[] memory amounts);
628     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
629         external
630         returns (uint[] memory amounts);
631     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
632         external
633         payable
634         returns (uint[] memory amounts);
635 
636     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
637     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
638     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
639     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
640     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
641 }
642 
643 
644 
645 
646 interface IUniswapV2Router02 is IUniswapV2Router01 {
647     function removeLiquidityETHSupportingFeeOnTransferTokens(
648         address token,
649         uint liquidity,
650         uint amountTokenMin,
651         uint amountETHMin,
652         address to,
653         uint deadline
654     ) external returns (uint amountETH);
655     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
656         address token,
657         uint liquidity,
658         uint amountTokenMin,
659         uint amountETHMin,
660         address to,
661         uint deadline,
662         bool approveMax, uint8 v, bytes32 r, bytes32 s
663     ) external returns (uint amountETH);
664 
665     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
666         uint amountIn,
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external;
672     function swapExactETHForTokensSupportingFeeOnTransferTokens(
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external payable;
678     function swapExactTokensForETHSupportingFeeOnTransferTokens(
679         uint amountIn,
680         uint amountOutMin,
681         address[] calldata path,
682         address to,
683         uint deadline
684     ) external;
685 }
686 
687 interface IAirdrop {
688     function airdrop(address recipient, uint256 amount) external;
689 }
690 
691 contract MONGOOSE is Context, IERC20, Ownable {
692     using SafeMath for uint256;
693     using Address for address;
694 
695     mapping (address => uint256) private _rOwned;
696     mapping (address => uint256) private _tOwned;
697     mapping (address => mapping (address => uint256)) private _allowances;
698 
699     mapping (address => bool) private _isExcludedFromFee;
700 
701     mapping (address => bool) private _isExcluded;
702     address[] private _excluded;
703     
704     mapping (address => bool) private botWallets;
705     bool botscantrade = false;
706     
707     bool public canTrade = false;
708    
709     uint256 private constant MAX = ~uint256(0);
710     uint256 private _tTotal = 69000000000000000000000 * 10**9;
711     uint256 private _rTotal = (MAX - (MAX % _tTotal));
712     uint256 private _tFeeTotal;
713     address public marketingWallet;
714 
715     string private _name = "Mongoose";
716     string private _symbol = "MONGOOSE";
717     uint8 private _decimals = 9;
718     
719     uint256 public _taxFee = 1;
720     uint256 private _previousTaxFee = _taxFee;
721     
722     uint256 public _liquidityFee = 12;
723     uint256 private _previousLiquidityFee = _liquidityFee;
724 
725     IUniswapV2Router02 public immutable uniswapV2Router;
726     address public immutable uniswapV2Pair;
727     
728     bool inSwapAndLiquify;
729     bool public swapAndLiquifyEnabled = true;
730     
731     uint256 public _maxTxAmount = 990000000000000000000 * 10**9;
732     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
733     
734     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
735     event SwapAndLiquifyEnabledUpdated(bool enabled);
736     event SwapAndLiquify(
737         uint256 tokensSwapped,
738         uint256 ethReceived,
739         uint256 tokensIntoLiqudity
740     );
741     
742     modifier lockTheSwap {
743         inSwapAndLiquify = true;
744         _;
745         inSwapAndLiquify = false;
746     }
747     
748     constructor () {
749         _rOwned[_msgSender()] = _rTotal;
750         
751         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
752          // Create a uniswap pair for this new token
753         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
754             .createPair(address(this), _uniswapV2Router.WETH());
755 
756         // set the rest of the contract variables
757         uniswapV2Router = _uniswapV2Router;
758         
759         //exclude owner and this contract from fee
760         _isExcludedFromFee[owner()] = true;
761         _isExcludedFromFee[address(this)] = true;
762         
763         emit Transfer(address(0), _msgSender(), _tTotal);
764     }
765 
766     function name() public view returns (string memory) {
767         return _name;
768     }
769 
770     function symbol() public view returns (string memory) {
771         return _symbol;
772     }
773 
774     function decimals() public view returns (uint8) {
775         return _decimals;
776     }
777 
778     function totalSupply() public view override returns (uint256) {
779         return _tTotal;
780     }
781 
782     function balanceOf(address account) public view override returns (uint256) {
783         if (_isExcluded[account]) return _tOwned[account];
784         return tokenFromReflection(_rOwned[account]);
785     }
786 
787     function transfer(address recipient, uint256 amount) public override returns (bool) {
788         _transfer(_msgSender(), recipient, amount);
789         return true;
790     }
791 
792     function allowance(address owner, address spender) public view override returns (uint256) {
793         return _allowances[owner][spender];
794     }
795 
796     function approve(address spender, uint256 amount) public override returns (bool) {
797         _approve(_msgSender(), spender, amount);
798         return true;
799     }
800 
801     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
802         _transfer(sender, recipient, amount);
803         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
804         return true;
805     }
806 
807     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
808         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
809         return true;
810     }
811 
812     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
814         return true;
815     }
816 
817     function isExcludedFromReward(address account) public view returns (bool) {
818         return _isExcluded[account];
819     }
820 
821     function totalFees() public view returns (uint256) {
822         return _tFeeTotal;
823     }
824     
825     function airdrop(address recipient, uint256 amount) external onlyOwner() {
826         removeAllFee();
827         _transfer(_msgSender(), recipient, amount * 10**9);
828         restoreAllFee();
829     }
830     
831     function airdropInternal(address recipient, uint256 amount) internal {
832         removeAllFee();
833         _transfer(_msgSender(), recipient, amount);
834         restoreAllFee();
835     }
836     
837     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
838         uint256 iterator = 0;
839         require(newholders.length == amounts.length, "must be the same length");
840         while(iterator < newholders.length){
841             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
842             iterator += 1;
843         }
844     }
845 
846     function deliver(uint256 tAmount) public {
847         address sender = _msgSender();
848         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
849         (uint256 rAmount,,,,,) = _getValues(tAmount);
850         _rOwned[sender] = _rOwned[sender].sub(rAmount);
851         _rTotal = _rTotal.sub(rAmount);
852         _tFeeTotal = _tFeeTotal.add(tAmount);
853     }
854 
855     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
856         require(tAmount <= _tTotal, "Amount must be less than supply");
857         if (!deductTransferFee) {
858             (uint256 rAmount,,,,,) = _getValues(tAmount);
859             return rAmount;
860         } else {
861             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
862             return rTransferAmount;
863         }
864     }
865 
866     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
867         require(rAmount <= _rTotal, "Amount must be less than total reflections");
868         uint256 currentRate =  _getRate();
869         return rAmount.div(currentRate);
870     }
871 
872     function excludeFromReward(address account) public onlyOwner() {
873         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
874         require(!_isExcluded[account], "Account is already excluded");
875         if(_rOwned[account] > 0) {
876             _tOwned[account] = tokenFromReflection(_rOwned[account]);
877         }
878         _isExcluded[account] = true;
879         _excluded.push(account);
880     }
881 
882     function includeInReward(address account) external onlyOwner() {
883         require(_isExcluded[account], "Account is already excluded");
884         for (uint256 i = 0; i < _excluded.length; i++) {
885             if (_excluded[i] == account) {
886                 _excluded[i] = _excluded[_excluded.length - 1];
887                 _tOwned[account] = 0;
888                 _isExcluded[account] = false;
889                 _excluded.pop();
890                 break;
891             }
892         }
893     }
894         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
895         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
896         _tOwned[sender] = _tOwned[sender].sub(tAmount);
897         _rOwned[sender] = _rOwned[sender].sub(rAmount);
898         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
899         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
900         _takeLiquidity(tLiquidity);
901         _reflectFee(rFee, tFee);
902         emit Transfer(sender, recipient, tTransferAmount);
903     }
904     
905     function excludeFromFee(address account) public onlyOwner {
906         _isExcludedFromFee[account] = true;
907     }
908     
909     function includeInFee(address account) public onlyOwner {
910         _isExcludedFromFee[account] = false;
911     }
912 
913     function setMarketingWallet(address walletAddress) public onlyOwner {
914         marketingWallet = walletAddress;
915     }
916 
917     function upliftTxAmount() external onlyOwner() {
918         _maxTxAmount = 69000000000000000000000 * 10**9;
919     }
920     
921     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
922         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
923         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
924     }
925     
926     function claimTokens () public onlyOwner {
927         // make sure we capture all BNB that may or may not be sent to this contract
928         payable(marketingWallet).transfer(address(this).balance);
929     }
930     
931     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
932         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
933     }
934     
935     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
936         walletaddress.transfer(address(this).balance);
937     }
938     
939     function addBotWallet(address botwallet) external onlyOwner() {
940         botWallets[botwallet] = true;
941     }
942     
943     function removeBotWallet(address botwallet) external onlyOwner() {
944         botWallets[botwallet] = false;
945     }
946     
947     function getBotWalletStatus(address botwallet) public view returns (bool) {
948         return botWallets[botwallet];
949     }
950     
951     function allowtrading()external onlyOwner() {
952         canTrade = true;
953     }
954 
955     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
956         swapAndLiquifyEnabled = _enabled;
957         emit SwapAndLiquifyEnabledUpdated(_enabled);
958     }
959     
960      //to recieve ETH from uniswapV2Router when swaping
961     receive() external payable {}
962 
963     function _reflectFee(uint256 rFee, uint256 tFee) private {
964         _rTotal = _rTotal.sub(rFee);
965         _tFeeTotal = _tFeeTotal.add(tFee);
966     }
967 
968     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
969         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
970         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
971         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
972     }
973 
974     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
975         uint256 tFee = calculateTaxFee(tAmount);
976         uint256 tLiquidity = calculateLiquidityFee(tAmount);
977         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
978         return (tTransferAmount, tFee, tLiquidity);
979     }
980 
981     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
982         uint256 rAmount = tAmount.mul(currentRate);
983         uint256 rFee = tFee.mul(currentRate);
984         uint256 rLiquidity = tLiquidity.mul(currentRate);
985         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
986         return (rAmount, rTransferAmount, rFee);
987     }
988 
989     function _getRate() private view returns(uint256) {
990         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
991         return rSupply.div(tSupply);
992     }
993 
994     function _getCurrentSupply() private view returns(uint256, uint256) {
995         uint256 rSupply = _rTotal;
996         uint256 tSupply = _tTotal;      
997         for (uint256 i = 0; i < _excluded.length; i++) {
998             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
999             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1000             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1001         }
1002         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1003         return (rSupply, tSupply);
1004     }
1005     
1006     function _takeLiquidity(uint256 tLiquidity) private {
1007         uint256 currentRate =  _getRate();
1008         uint256 rLiquidity = tLiquidity.mul(currentRate);
1009         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1010         if(_isExcluded[address(this)])
1011             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1012     }
1013     
1014     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1015         return _amount.mul(_taxFee).div(
1016             10**2
1017         );
1018     }
1019 
1020     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1021         return _amount.mul(_liquidityFee).div(
1022             10**2
1023         );
1024     }
1025     
1026     function removeAllFee() private {
1027         if(_taxFee == 0 && _liquidityFee == 0) return;
1028         
1029         _previousTaxFee = _taxFee;
1030         _previousLiquidityFee = _liquidityFee;
1031         
1032         _taxFee = 0;
1033         _liquidityFee = 0;
1034     }
1035     
1036     function restoreAllFee() private {
1037         _taxFee = _previousTaxFee;
1038         _liquidityFee = _previousLiquidityFee;
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
1061         if(from != owner() && to != owner())
1062             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1063 
1064         // is the token balance of this contract address over the min number of
1065         // tokens that we need to initiate a swap + liquidity lock?
1066         // also, don't get caught in a circular liquidity event.
1067         // also, don't swap & liquify if sender is uniswap pair.
1068         uint256 contractTokenBalance = balanceOf(address(this));
1069         
1070         if(contractTokenBalance >= _maxTxAmount)
1071         {
1072             contractTokenBalance = _maxTxAmount;
1073         }
1074         
1075         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1076         if (
1077             overMinTokenBalance &&
1078             !inSwapAndLiquify &&
1079             from != uniswapV2Pair &&
1080             swapAndLiquifyEnabled
1081         ) {
1082             contractTokenBalance = numTokensSellToAddToLiquidity;
1083             //add liquidity
1084             swapAndLiquify(contractTokenBalance);
1085         }
1086         
1087         //indicates if fee should be deducted from transfer
1088         bool takeFee = true;
1089         
1090         //if any account belongs to _isExcludedFromFee account then remove the fee
1091         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1092             takeFee = false;
1093         }
1094         
1095         //transfer amount, it will take tax, burn, liquidity fee
1096         _tokenTransfer(from,to,amount,takeFee);
1097     }
1098 
1099     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1100         // split the contract balance into halves
1101         // add the marketing wallet
1102         uint256 half = contractTokenBalance.div(2);
1103         uint256 otherHalf = contractTokenBalance.sub(half);
1104 
1105         // capture the contract's current ETH balance.
1106         // this is so that we can capture exactly the amount of ETH that the
1107         // swap creates, and not make the liquidity event include any ETH that
1108         // has been manually sent to the contract
1109         uint256 initialBalance = address(this).balance;
1110 
1111         // swap tokens for ETH
1112         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1113 
1114         // how much ETH did we just swap into?
1115         uint256 newBalance = address(this).balance.sub(initialBalance);
1116         uint256 marketingshare = newBalance.mul(75).div(100);
1117         payable(marketingWallet).transfer(marketingshare);
1118         newBalance -= marketingshare;
1119         // add liquidity to uniswap
1120         addLiquidity(otherHalf, newBalance);
1121         
1122         emit SwapAndLiquify(half, newBalance, otherHalf);
1123     }
1124 
1125     function swapTokensForEth(uint256 tokenAmount) private {
1126         // generate the uniswap pair path of token -> weth
1127         address[] memory path = new address[](2);
1128         path[0] = address(this);
1129         path[1] = uniswapV2Router.WETH();
1130 
1131         _approve(address(this), address(uniswapV2Router), tokenAmount);
1132 
1133         // make the swap
1134         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1135             tokenAmount,
1136             0, // accept any amount of ETH
1137             path,
1138             address(this),
1139             block.timestamp
1140         );
1141     }
1142 
1143     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1144         // approve token transfer to cover all possible scenarios
1145         _approve(address(this), address(uniswapV2Router), tokenAmount);
1146 
1147         // add the liquidity
1148         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1149             address(this),
1150             tokenAmount,
1151             0, // slippage is unavoidable
1152             0, // slippage is unavoidable
1153             owner(),
1154             block.timestamp
1155         );
1156     }
1157 
1158     //this method is responsible for taking all fee, if takeFee is true
1159     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1160         if(!canTrade){
1161             require(sender == owner()); // only owner allowed to trade or add liquidity
1162         }
1163         
1164         if(botWallets[sender] || botWallets[recipient]){
1165             require(botscantrade, "bots arent allowed to trade");
1166         }
1167         
1168         if(!takeFee)
1169             removeAllFee();
1170         
1171         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1172             _transferFromExcluded(sender, recipient, amount);
1173         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1174             _transferToExcluded(sender, recipient, amount);
1175         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1176             _transferStandard(sender, recipient, amount);
1177         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1178             _transferBothExcluded(sender, recipient, amount);
1179         } else {
1180             _transferStandard(sender, recipient, amount);
1181         }
1182         
1183         if(!takeFee)
1184             restoreAllFee();
1185     }
1186 
1187     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1188         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1189         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1190         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1191         _takeLiquidity(tLiquidity);
1192         _reflectFee(rFee, tFee);
1193         emit Transfer(sender, recipient, tTransferAmount);
1194     }
1195 
1196     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1197         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1198         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1199         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1200         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1201         _takeLiquidity(tLiquidity);
1202         _reflectFee(rFee, tFee);
1203         emit Transfer(sender, recipient, tTransferAmount);
1204     }
1205 
1206     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1207         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1208         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1209         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1210         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1211         _takeLiquidity(tLiquidity);
1212         _reflectFee(rFee, tFee);
1213         emit Transfer(sender, recipient, tTransferAmount);
1214     }
1215 
1216 }