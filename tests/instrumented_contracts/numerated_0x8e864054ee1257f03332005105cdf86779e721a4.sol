1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104  
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
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
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 contract Ownable is Context {
399     address private _owner;
400     address private _previousOwner;
401     uint256 private _lockTime;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor () internal {
409         address msgSender = _msgSender();
410         _owner = _msgSender();
411         emit OwnershipTransferred(address(0), msgSender);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429      /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         emit OwnershipTransferred(_owner, newOwner);
448         _owner = newOwner;
449     }
450 
451     function geUnlockTime() public view returns (uint256) {
452         return _lockTime;
453     }
454 
455     //Locks the contract for owner for the amount of time provided
456     function lock(uint256 time) public virtual onlyOwner {
457         _previousOwner = _owner;
458         _owner = address(0);
459         _lockTime = now + time;
460         emit OwnershipTransferred(_owner, address(0));
461     }
462     
463     //Unlocks the contract for owner when _lockTime is exceeds
464     function unlock() public virtual {
465         require(_previousOwner == msg.sender, "You don't have permission to unlock");
466         require(now > _lockTime , "Contract is locked until 7 days");
467         emit OwnershipTransferred(_owner, _previousOwner);
468         _owner = _previousOwner;
469     }
470 }
471 
472 // pragma solidity >=0.5.0;
473 
474 interface IUniswapV2Factory {
475     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
476 
477     function feeTo() external view returns (address);
478     function feeToSetter() external view returns (address);
479 
480     function getPair(address tokenA, address tokenB) external view returns (address pair);
481     function allPairs(uint) external view returns (address pair);
482     function allPairsLength() external view returns (uint);
483 
484     function createPair(address tokenA, address tokenB) external returns (address pair);
485 
486     function setFeeTo(address) external;
487     function setFeeToSetter(address) external;
488 }
489 
490 // pragma solidity >=0.5.0;
491 
492 interface IUniswapV2Pair {
493     event Approval(address indexed owner, address indexed spender, uint value);
494     event Transfer(address indexed from, address indexed to, uint value);
495 
496     function name() external pure returns (string memory);
497     function symbol() external pure returns (string memory);
498     function decimals() external pure returns (uint8);
499     function totalSupply() external view returns (uint);
500     function balanceOf(address owner) external view returns (uint);
501     function allowance(address owner, address spender) external view returns (uint);
502 
503     function approve(address spender, uint value) external returns (bool);
504     function transfer(address to, uint value) external returns (bool);
505     function transferFrom(address from, address to, uint value) external returns (bool);
506 
507     function DOMAIN_SEPARATOR() external view returns (bytes32);
508     function PERMIT_TYPEHASH() external pure returns (bytes32);
509     function nonces(address owner) external view returns (uint);
510 
511     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
512 
513     event Mint(address indexed sender, uint amount0, uint amount1);
514     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
515     event Swap(
516         address indexed sender,
517         uint amount0In,
518         uint amount1In,
519         uint amount0Out,
520         uint amount1Out,
521         address indexed to
522     );
523     event Sync(uint112 reserve0, uint112 reserve1);
524 
525     function MINIMUM_LIQUIDITY() external pure returns (uint);
526     function factory() external view returns (address);
527     function token0() external view returns (address);
528     function token1() external view returns (address);
529     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
530     function price0CumulativeLast() external view returns (uint);
531     function price1CumulativeLast() external view returns (uint);
532     function kLast() external view returns (uint);
533 
534     function mint(address to) external returns (uint liquidity);
535     function burn(address to) external returns (uint amount0, uint amount1);
536     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
537     function skim(address to) external;
538     function sync() external;
539 
540     function initialize(address, address) external;
541 }
542 
543 // pragma solidity >=0.6.2;
544 
545 interface IUniswapV2Router01 {
546     function factory() external pure returns (address);
547     function WETH() external pure returns (address);
548 
549     function addLiquidity(
550         address tokenA,
551         address tokenB,
552         uint amountADesired,
553         uint amountBDesired,
554         uint amountAMin,
555         uint amountBMin,
556         address to,
557         uint deadline
558     ) external returns (uint amountA, uint amountB, uint liquidity);
559     function addLiquidityETH(
560         address token,
561         uint amountTokenDesired,
562         uint amountTokenMin,
563         uint amountETHMin,
564         address to,
565         uint deadline
566     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
567     function removeLiquidity(
568         address tokenA,
569         address tokenB,
570         uint liquidity,
571         uint amountAMin,
572         uint amountBMin,
573         address to,
574         uint deadline
575     ) external returns (uint amountA, uint amountB);
576     function removeLiquidityETH(
577         address token,
578         uint liquidity,
579         uint amountTokenMin,
580         uint amountETHMin,
581         address to,
582         uint deadline
583     ) external returns (uint amountToken, uint amountETH);
584     function removeLiquidityWithPermit(
585         address tokenA,
586         address tokenB,
587         uint liquidity,
588         uint amountAMin,
589         uint amountBMin,
590         address to,
591         uint deadline,
592         bool approveMax, uint8 v, bytes32 r, bytes32 s
593     ) external returns (uint amountA, uint amountB);
594     function removeLiquidityETHWithPermit(
595         address token,
596         uint liquidity,
597         uint amountTokenMin,
598         uint amountETHMin,
599         address to,
600         uint deadline,
601         bool approveMax, uint8 v, bytes32 r, bytes32 s
602     ) external returns (uint amountToken, uint amountETH);
603     function swapExactTokensForTokens(
604         uint amountIn,
605         uint amountOutMin,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external returns (uint[] memory amounts);
610     function swapTokensForExactTokens(
611         uint amountOut,
612         uint amountInMax,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external returns (uint[] memory amounts);
617     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
618         external
619         payable
620         returns (uint[] memory amounts);
621     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
622         external
623         returns (uint[] memory amounts);
624     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
625         external
626         returns (uint[] memory amounts);
627     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
628         external
629         payable
630         returns (uint[] memory amounts);
631 
632     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
633     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
634     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
635     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
636     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
637 }
638 
639 // pragma solidity >=0.6.2;
640 
641 interface IUniswapV2Router02 is IUniswapV2Router01 {
642     function removeLiquidityETHSupportingFeeOnTransferTokens(
643         address token,
644         uint liquidity,
645         uint amountTokenMin,
646         uint amountETHMin,
647         address to,
648         uint deadline
649     ) external returns (uint amountETH);
650     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
651         address token,
652         uint liquidity,
653         uint amountTokenMin,
654         uint amountETHMin,
655         address to,
656         uint deadline,
657         bool approveMax, uint8 v, bytes32 r, bytes32 s
658     ) external returns (uint amountETH);
659 
660     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
661         uint amountIn,
662         uint amountOutMin,
663         address[] calldata path,
664         address to,
665         uint deadline
666     ) external;
667     function swapExactETHForTokensSupportingFeeOnTransferTokens(
668         uint amountOutMin,
669         address[] calldata path,
670         address to,
671         uint deadline
672     ) external payable;
673     function swapExactTokensForETHSupportingFeeOnTransferTokens(
674         uint amountIn,
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external;
680 }
681 
682 contract LuckyCat is Context, IERC20, Ownable {
683     using SafeMath for uint256;
684     using Address for address;
685 
686     mapping (address => uint256) private _rOwned;
687     mapping (address => uint256) private _tOwned;
688     mapping (address => mapping (address => uint256)) private _allowances;
689     mapping (address => bool) private _isExcludedFromFee;
690 
691     mapping (address => bool) private _isExcluded;
692     address[] private _excluded;
693    
694     uint256 private constant MAX = ~uint256(0);
695     uint256 private _tTotal = 1000000000000000 * 10**9;
696     uint256 private _rTotal = (MAX - (MAX % _tTotal));
697     uint256 private _tFeeTotal;
698 
699     string private _name = "Lucky Cat";
700     string private _symbol = "LUCKY😺"; 
701     uint8 private _decimals = 9;
702     
703     uint256 public _taxFee = 2;
704     uint256 private _previousTaxFee = _taxFee;
705     
706     uint256 public _liquidityFee = 8;
707     uint256 private _previousLiquidityFee = _liquidityFee;
708     
709     address [] public tokenHolder;
710     uint256 public numberOfTokenHolders = 0;
711     mapping(address => bool) public exist;
712 
713     mapping (address => bool) private _isBlackListedBot;
714     address[] private _blackListedBots;
715     mapping (address => bool) private bots;
716     mapping (address => bool) private _isBlacklisted;
717 
718     uint256 public _maxTxAmount = 100000000 * 10**9;
719     address payable wallet;
720     address payable rewardsWallet;
721     IUniswapV2Router02 public uniswapV2Router;
722     address public uniswapV2Pair;
723     
724     bool inSwapAndLiquify;
725     bool public swapAndLiquifyEnabled = false;
726     uint256 private minTokensBeforeSwap = 20000 * 10**9;
727     
728     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
729     event SwapAndLiquifyEnabledUpdated(bool enabled);
730     event SwapAndLiquify(
731         uint256 tokensSwapped,
732         uint256 ethReceived,
733         uint256 tokensIntoLiqudity
734     );
735     
736     modifier lockTheSwap {
737         inSwapAndLiquify = true;
738          _;
739         inSwapAndLiquify = false;
740     }
741     
742     constructor () public {
743         _rOwned[_msgSender()] = _rTotal;
744         wallet = msg.sender;
745         rewardsWallet= msg.sender;
746         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
747         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
748             .createPair(address(this), _uniswapV2Router.WETH());
749         
750         //exclude owner and this contract from fee
751         _isExcludedFromFee[owner()] = true;
752         _isExcludedFromFee[address(this)] = true;
753         
754         emit Transfer(address(0), _msgSender(), _tTotal);
755     }
756 
757     // @dev set Pair
758     function setPair(address _uniswapV2Pair) external onlyOwner {
759         uniswapV2Pair = _uniswapV2Pair;
760     }
761 
762     // @dev set Router
763     function setRouter(address _newUniswapV2Router) external onlyOwner {
764         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_newUniswapV2Router);
765         uniswapV2Router = _uniswapV2Router;
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
794     function addBotToBlackList(address account) external onlyOwner() {
795         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist UniswapV2 router.');
796         require(!_isBlackListedBot[account], "Account is already blacklisted");
797         _isBlackListedBot[account] = true;
798         _blackListedBots.push(account);
799     }
800     
801     function removeBotFromBlackList(address account) external onlyOwner() {
802         require(_isBlackListedBot[account], "Account is not blacklisted");
803         for (uint256 i = 0; i < _blackListedBots.length; i++) {
804             if (_blackListedBots[i] == account) {
805                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
806                 _isBlackListedBot[account] = false;
807                 _blackListedBots.pop();
808                 break;
809             }
810         }
811     }
812 
813     function isBlackListed(address account) public view returns (bool) {
814         return _isBlackListedBot[account];
815     }
816     
817     function blacklistSingleWallet(address addresses) public onlyOwner(){
818         if(_isBlacklisted[addresses] == true) return;
819         _isBlacklisted[addresses] = true;
820     }
821 
822     function blacklistMultipleWallets(address[] calldata addresses) public onlyOwner(){
823         for (uint256 i; i < addresses.length; ++i) {
824             _isBlacklisted[addresses[i]] = true;
825         }
826     }
827     
828     function isBlacklisted(address addresses) public view returns (bool){
829         if(_isBlacklisted[addresses] == true) return true;
830         else return false;
831     }
832     
833     
834     function unBlacklistSingleWallet(address addresses) external onlyOwner(){
835          if(_isBlacklisted[addresses] == false) return;
836         _isBlacklisted[addresses] = false;
837     }
838 
839     function unBlacklistMultipleWallets(address[] calldata addresses) public onlyOwner(){
840         for (uint256 i; i < addresses.length; ++i) {
841             _isBlacklisted[addresses[i]] = false;
842         }
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
878     function deliver(uint256 tAmount) public {
879         address sender = _msgSender();
880         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
881         (uint256 rAmount,,,,,) = _getValues(tAmount);
882         _rOwned[sender] = _rOwned[sender].sub(rAmount);
883         _rTotal = _rTotal.sub(rAmount);
884         _tFeeTotal = _tFeeTotal.add(tAmount);
885     }
886 
887     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
888         require(tAmount <= _tTotal, "Amount must be less than supply");
889         if (!deductTransferFee) {
890             (uint256 rAmount,,,,,) = _getValues(tAmount);
891             return rAmount;
892         } else {
893             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
894             return rTransferAmount;
895         }
896     }
897 
898     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
899         require(rAmount <= _rTotal, "Amount must be less than total reflections");
900         uint256 currentRate =  _getRate();
901         return rAmount.div(currentRate);
902     }
903 
904     function excludeFromReward(address account) public onlyOwner() {
905         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude uniswapV2 router.');
906         require(!_isExcluded[account], "Account is already excluded");
907         if(_rOwned[account] > 0) {
908             _tOwned[account] = tokenFromReflection(_rOwned[account]);
909         }
910         _isExcluded[account] = true;
911         _excluded.push(account);
912     }
913 
914     function includeInReward(address account) external onlyOwner() {
915         require(_isExcluded[account], "Account is already excluded");
916         for (uint256 i = 0; i < _excluded.length; i++) {
917             if (_excluded[i] == account) {
918                 _excluded[i] = _excluded[_excluded.length - 1];
919                 _tOwned[account] = 0;
920                 _isExcluded[account] = false;
921                 _excluded.pop();
922                 break;
923             }
924         }
925     }
926     
927     function _approve(address owner, address spender, uint256 amount) private {
928         require(owner != address(0));
929         require(spender != address(0));
930 
931         _allowances[owner][spender] = amount;
932         emit Approval(owner, spender, amount);
933     }
934 
935     bool public limit = true;
936     function changeLimit() public onlyOwner(){
937         require(limit == true, 'limit is already false');
938             limit = false;
939     }
940     
941     function expectedRewards(address _sender) external view returns(uint256){
942         uint256 _balance = address(this).balance;
943         address sender = _sender;
944         uint256 holdersBal = balanceOf(sender);
945         uint totalExcludedBal;
946         for(uint256 i = 0; i<_excluded.length; i++){
947          totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);   
948         }
949         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(uniswapV2Pair)).sub(totalExcludedBal));
950         return rewards;
951     }
952     
953     function _transfer(
954         address from,
955         address to,
956         uint256 amount
957     ) private {
958         require(from != address(0), "ERC20: transfer from the zero address");
959         require(to != address(0), "ERC20: transfer to the zero address");
960         require(amount > 0, "Transfer amount must be greater than zero");
961         require(!_isBlackListedBot[to], "You have no power here!");
962         require(!_isBlackListedBot[from], "You have no power here!");
963         require(_isBlacklisted[from] == false || to == address(0), "You are banned");
964         require(_isBlacklisted[to] == false, "The recipient is banned");
965         
966         if(limit ==  true && from != owner() && to != owner()){
967             if(to != uniswapV2Pair){
968                 require(((balanceOf(to).add(amount)) <= 500 ether));
969             }
970             require(amount <= 100 ether, 'Transfer amount must be less than 100 tokens');
971             }
972         if(from != owner() && to != owner())
973             require(amount <= _maxTxAmount);
974 
975         // is the token balance of this contract address over the min number of
976         // tokens that we need to initiate a swap + liquidity lock?
977         // also, don't get caught in a circular liquidity event.
978         // also, don't swap & liquify if sender is uniswapV2 pair.
979         if(!exist[to]){
980             tokenHolder.push(to);
981             numberOfTokenHolders++;
982             exist[to] = true;
983         }
984         uint256 contractTokenBalance = balanceOf(address(this));
985         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
986         if (
987             overMinTokenBalance &&
988             !inSwapAndLiquify &&
989             from != uniswapV2Pair &&
990             swapAndLiquifyEnabled
991         ) {
992             //add liquidity
993             swapAndLiquify(contractTokenBalance);
994         }
995         
996         //indicates if fee should be deducted from transfer
997         bool takeFee = true;
998         
999         //if any account belongs to _isExcludedFromFee account then remove the fee
1000         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1001             takeFee = false;
1002         }
1003         
1004         //transfer amount, it will take tax, burn, liquidity fee
1005         _tokenTransfer(from,to,amount,takeFee);
1006     }
1007     mapping(address => uint256) public myRewards;
1008     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1009         uint256 forLiquidity = contractTokenBalance.div(2);
1010         uint256 devExp = contractTokenBalance.div(4);
1011         uint256 forRewards = contractTokenBalance.div(4);
1012         // split the liquidity
1013         uint256 half = forLiquidity.div(2);
1014         uint256 otherHalf = forLiquidity.sub(half);
1015         // capture the contract's current ETH balance.
1016         // this is so that we can capture exactly the amount of ETH that the
1017         // swap creates, and not make the liquidity event include any ETH that
1018         // has been manually sent to the contract
1019         uint256 initialBalance = address(this).balance;
1020 
1021         // swap tokens for ETH
1022         swapTokensForEth(half.add(devExp).add(forRewards)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1023 
1024         // how much ETH did we just swap into?
1025         uint256 Balance = address(this).balance.sub(initialBalance);
1026         uint256 oneThird = Balance.div(3);
1027         wallet.transfer(oneThird);
1028         rewardsWallet.transfer(oneThird);
1029  
1030         // add liquidity to uniswapV2
1031         addLiquidity(otherHalf, oneThird);
1032         
1033         emit SwapAndLiquify(half, oneThird, otherHalf);
1034     }
1035        
1036     function ETHBalance() external view returns(uint256){
1037         return address(this).balance;
1038     }
1039     function swapTokensForEth(uint256 tokenAmount) private {
1040         // generate the uniswapV2 pair path of token -> weth
1041         address[] memory path = new address[](2);
1042         path[0] = address(this);
1043         path[1] = uniswapV2Router.WETH();
1044 
1045         _approve(address(this), address(uniswapV2Router), tokenAmount);
1046 
1047         // make the swap
1048         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1049             tokenAmount,
1050             0, // accept any amount of ETH
1051             path,
1052             address(this),
1053             block.timestamp
1054         );
1055     }
1056 
1057     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1058         // approve token transfer to cover all possible scenarios
1059         _approve(address(this), address(uniswapV2Router), tokenAmount);
1060 
1061         // add the liquidity
1062         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1063             address(this),
1064             tokenAmount,
1065             0, // slippage is unavoidable
1066             0, // slippage is unavoidable
1067             owner(),
1068             block.timestamp
1069         );
1070     }
1071 
1072     //this method is responsible for taking all fee, if takeFee is true
1073     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1074         if(!takeFee)
1075             removeAllFee();
1076         
1077         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1078             _transferFromExcluded(sender, recipient, amount);
1079         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1080             _transferToExcluded(sender, recipient, amount);
1081         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1082             _transferStandard(sender, recipient, amount);
1083         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1084             _transferBothExcluded(sender, recipient, amount);
1085         } else {
1086             _transferStandard(sender, recipient, amount);
1087         }
1088         
1089         if(!takeFee)
1090             restoreAllFee();
1091     }
1092 
1093     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1094         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1095         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1096         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1097         _takeLiquidity(tLiquidity);
1098         _reflectFee(rFee, tFee);
1099         emit Transfer(sender, recipient, tTransferAmount);
1100     }
1101 
1102     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1103         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1104         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1105         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1106         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1107         _takeLiquidity(tLiquidity);
1108         _reflectFee(rFee, tFee);
1109         emit Transfer(sender, recipient, tTransferAmount);
1110     }
1111 
1112     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1113         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1114         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1115         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1116         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1117         _takeLiquidity(tLiquidity);
1118         _reflectFee(rFee, tFee);
1119         emit Transfer(sender, recipient, tTransferAmount);
1120     }
1121 
1122     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1123         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1124         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1125         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1126         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1127         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1128         _takeLiquidity(tLiquidity);
1129         _reflectFee(rFee, tFee);
1130         emit Transfer(sender, recipient, tTransferAmount);
1131     }
1132 
1133     function _reflectFee(uint256 rFee, uint256 tFee) private {
1134         _rTotal = _rTotal.sub(rFee);
1135         _tFeeTotal = _tFeeTotal.add(tFee);
1136     }
1137 
1138     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1139         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1140         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1141         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1142     }
1143 
1144     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1145         uint256 tFee = calculateTaxFee(tAmount);
1146         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1147         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1148         return (tTransferAmount, tFee, tLiquidity);
1149     }
1150 
1151     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1152         uint256 rAmount = tAmount.mul(currentRate);
1153         uint256 rFee = tFee.mul(currentRate);
1154         uint256 rLiquidity = tLiquidity.mul(currentRate);
1155         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1156         return (rAmount, rTransferAmount, rFee);
1157     }
1158 
1159     function _getRate() private view returns(uint256) {
1160         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1161         return rSupply.div(tSupply);
1162     }
1163 
1164     function _getCurrentSupply() private view returns(uint256, uint256) {
1165         uint256 rSupply = _rTotal;
1166         uint256 tSupply = _tTotal;      
1167         for (uint256 i = 0; i < _excluded.length; i++) {
1168             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1169             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1170             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1171         }
1172         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1173         return (rSupply, tSupply);
1174     }
1175     
1176     function _takeLiquidity(uint256 tLiquidity) private {
1177         uint256 currentRate =  _getRate();
1178         uint256 rLiquidity = tLiquidity.mul(currentRate);
1179         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1180         if(_isExcluded[address(this)])
1181             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1182     }
1183     
1184     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1185         return _amount.mul(_taxFee).div(
1186             10**2
1187         );
1188     }
1189 
1190     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1191         return _amount.mul(_liquidityFee).div(
1192             10**2
1193         );
1194     }
1195     
1196     function removeAllFee() private {
1197         if(_taxFee == 0 && _liquidityFee == 0) return;
1198         
1199         _previousTaxFee = _taxFee;
1200         _previousLiquidityFee = _liquidityFee;
1201         
1202         _taxFee = 0;
1203         _liquidityFee = 0;
1204     }
1205     
1206     function restoreAllFee() private {
1207         _taxFee = _previousTaxFee;
1208         _liquidityFee = _previousLiquidityFee;
1209     }
1210     
1211     function isExcludedFromFee(address account) public view returns(bool) {
1212         return _isExcludedFromFee[account];
1213     }
1214     
1215     function excludeFromFee(address account) public onlyOwner {
1216         _isExcludedFromFee[account] = true;
1217     }
1218     
1219     function includeInFee(address account) public onlyOwner {
1220         _isExcludedFromFee[account] = false;
1221     }
1222     
1223     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1224          require(taxFee <= 10, "Maximum fee limit is 10 percent");
1225         _taxFee = taxFee;
1226     }
1227     
1228     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1229         require(liquidityFee <= 10, "Maximum fee limit is 10 percent");
1230         _liquidityFee = liquidityFee;
1231     }
1232    
1233     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1234          require(maxTxPercent <= 50, "MaxTxPercent is 50 percent of total supplyC");
1235         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1236             10**2
1237         );
1238     }
1239 
1240     function setNumTokensSellToAddToLiquidity(uint256 _minTokensBeforeSwap) external onlyOwner() {
1241         minTokensBeforeSwap = _minTokensBeforeSwap;
1242     }
1243 
1244     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1245         swapAndLiquifyEnabled = _enabled;
1246         emit SwapAndLiquifyEnabledUpdated(_enabled);
1247     }
1248     
1249      //to recieve ETH from uniswapV2Router when swaping
1250     receive() external payable {}
1251 }