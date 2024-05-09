1 /**
2  *Green Eyed Monster
3 
4 */
5 
6 pragma solidity ^0.6.12;
7 // SPDX-License-Identifier: Unlicensed
8 interface IERC20 {
9 
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92  
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address payable) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes memory) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
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
410         _owner = msgSender;
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
490 
491 // pragma solidity >=0.5.0;
492 
493 interface IUniswapV2Pair {
494     event Approval(address indexed owner, address indexed spender, uint value);
495     event Transfer(address indexed from, address indexed to, uint value);
496 
497     function name() external pure returns (string memory);
498     function symbol() external pure returns (string memory);
499     function decimals() external pure returns (uint8);
500     function totalSupply() external view returns (uint);
501     function balanceOf(address owner) external view returns (uint);
502     function allowance(address owner, address spender) external view returns (uint);
503 
504     function approve(address spender, uint value) external returns (bool);
505     function transfer(address to, uint value) external returns (bool);
506     function transferFrom(address from, address to, uint value) external returns (bool);
507 
508     function DOMAIN_SEPARATOR() external view returns (bytes32);
509     function PERMIT_TYPEHASH() external pure returns (bytes32);
510     function nonces(address owner) external view returns (uint);
511 
512     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
513 
514     event Mint(address indexed sender, uint amount0, uint amount1);
515     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
516     event Swap(
517         address indexed sender,
518         uint amount0In,
519         uint amount1In,
520         uint amount0Out,
521         uint amount1Out,
522         address indexed to
523     );
524     event Sync(uint112 reserve0, uint112 reserve1);
525 
526     function MINIMUM_LIQUIDITY() external pure returns (uint);
527     function factory() external view returns (address);
528     function token0() external view returns (address);
529     function token1() external view returns (address);
530     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
531     function price0CumulativeLast() external view returns (uint);
532     function price1CumulativeLast() external view returns (uint);
533     function kLast() external view returns (uint);
534 
535     function mint(address to) external returns (uint liquidity);
536     function burn(address to) external returns (uint amount0, uint amount1);
537     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
538     function skim(address to) external;
539     function sync() external;
540 
541     function initialize(address, address) external;
542 }
543 
544 // pragma solidity >=0.6.2;
545 
546 interface IUniswapV2Router01 {
547     function factory() external pure returns (address);
548     function WETH() external pure returns (address);
549 
550     function addLiquidity(
551         address tokenA,
552         address tokenB,
553         uint amountADesired,
554         uint amountBDesired,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline
559     ) external returns (uint amountA, uint amountB, uint liquidity);
560     function addLiquidityETH(
561         address token,
562         uint amountTokenDesired,
563         uint amountTokenMin,
564         uint amountETHMin,
565         address to,
566         uint deadline
567     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
568     function removeLiquidity(
569         address tokenA,
570         address tokenB,
571         uint liquidity,
572         uint amountAMin,
573         uint amountBMin,
574         address to,
575         uint deadline
576     ) external returns (uint amountA, uint amountB);
577     function removeLiquidityETH(
578         address token,
579         uint liquidity,
580         uint amountTokenMin,
581         uint amountETHMin,
582         address to,
583         uint deadline
584     ) external returns (uint amountToken, uint amountETH);
585     function removeLiquidityWithPermit(
586         address tokenA,
587         address tokenB,
588         uint liquidity,
589         uint amountAMin,
590         uint amountBMin,
591         address to,
592         uint deadline,
593         bool approveMax, uint8 v, bytes32 r, bytes32 s
594     ) external returns (uint amountA, uint amountB);
595     function removeLiquidityETHWithPermit(
596         address token,
597         uint liquidity,
598         uint amountTokenMin,
599         uint amountETHMin,
600         address to,
601         uint deadline,
602         bool approveMax, uint8 v, bytes32 r, bytes32 s
603     ) external returns (uint amountToken, uint amountETH);
604     function swapExactTokensForTokens(
605         uint amountIn,
606         uint amountOutMin,
607         address[] calldata path,
608         address to,
609         uint deadline
610     ) external returns (uint[] memory amounts);
611     function swapTokensForExactTokens(
612         uint amountOut,
613         uint amountInMax,
614         address[] calldata path,
615         address to,
616         uint deadline
617     ) external returns (uint[] memory amounts);
618     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
619         external
620         payable
621         returns (uint[] memory amounts);
622     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
623         external
624         returns (uint[] memory amounts);
625     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
626         external
627         returns (uint[] memory amounts);
628     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
629         external
630         payable
631         returns (uint[] memory amounts);
632 
633     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
634     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
635     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
636     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
637     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
638 }
639 
640 
641 
642 // pragma solidity >=0.6.2;
643 
644 interface IUniswapV2Router02 is IUniswapV2Router01 {
645     function removeLiquidityETHSupportingFeeOnTransferTokens(
646         address token,
647         uint liquidity,
648         uint amountTokenMin,
649         uint amountETHMin,
650         address to,
651         uint deadline
652     ) external returns (uint amountETH);
653     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline,
660         bool approveMax, uint8 v, bytes32 r, bytes32 s
661     ) external returns (uint amountETH);
662 
663     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
664         uint amountIn,
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external;
670     function swapExactETHForTokensSupportingFeeOnTransferTokens(
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external payable;
676     function swapExactTokensForETHSupportingFeeOnTransferTokens(
677         uint amountIn,
678         uint amountOutMin,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external;
683 }
684 
685 
686 contract GreenEyedMonsters is Context, IERC20, Ownable {
687     using SafeMath for uint256;
688     using Address for address;
689 
690     mapping (address => uint256) private _rOwned;
691     mapping (address => uint256) private _tOwned;
692     mapping (address => mapping (address => uint256)) private _allowances;
693 
694     mapping (address => bool) private _isExcludedFromFee;
695 
696     mapping (address => bool) private _isExcluded;
697     address[] private _excluded;
698     mapping (address => bool) private _isBlackListedBot;
699     address[] private _blackListedBots;
700    
701     uint256 private constant MAX = ~uint256(0);
702     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
703     uint256 private _rTotal = (MAX - (MAX % _tTotal));
704     uint256 private _tFeeTotal;
705 
706     address payable public _marketingAddress = 0xdb70e82E403c261D1B59369c41cDE493123bd0A0;
707     address private _devAddress = 0x585Ef5bABb73B2ce4Bd3436E32A4Fd1b4bfA1348;
708 
709     string private _name = "Green Eyed Monsters";
710     string private _symbol = "GEM";
711     uint8 private _decimals = 9;
712     
713     uint256 public _taxFee = 99;
714     uint256 private _previousTaxFee = _taxFee;
715     
716     uint256 public _liquidityFee = 4;
717     uint256 private _previousLiquidityFee = _liquidityFee;
718 
719     uint256 public _marketingFee = 3;
720     uint256 private _previousMarketingFee = _marketingFee;
721 
722     uint256 public _devFee = 2;
723     uint256 private _previousDevFee = _devFee;
724 
725     IUniswapV2Router02 public immutable uniswapV2Router;
726     address public immutable uniswapV2Pair;
727     
728     bool inSwapAndLiquify;
729     bool public swapAndLiquifyEnabled = true;
730     
731     uint256 public _maxTxAmount = 10000 * 10**6 * 10**9;
732     uint256 private numTokensSellToAddToLiquidity = 5000 * 10**6 * 10**9;
733     uint256 public _maxWalletSize = 1000000 * 10**6 * 10**9;
734     
735     event botAddedToBlacklist(address account);
736     event botRemovedFromBlacklist(address account);
737     
738     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
739     event SwapAndLiquifyEnabledUpdated(bool enabled);
740     event SwapAndLiquify(
741         uint256 tokensSwapped,
742         uint256 ethReceived,
743         uint256 tokensIntoLiqudity
744     );
745     
746     modifier lockTheSwap {
747         inSwapAndLiquify = true;
748         _;
749         inSwapAndLiquify = false;
750     }
751     
752     constructor () public {
753         _rOwned[_msgSender()] = _rTotal;
754         
755         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D );
756          // Create a uniswap pair for this new token
757         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
758             .createPair(address(this), _uniswapV2Router.WETH());
759 
760         // set the rest of the contract variables
761         uniswapV2Router = _uniswapV2Router;
762 
763         // exclude owner, dev wallet, and this contract from fee
764         _isExcludedFromFee[owner()] = true;
765         _isExcludedFromFee[address(this)] = true;
766         _isExcludedFromFee[_marketingAddress] = true;
767 
768         emit Transfer(address(0), _msgSender(), _tTotal);
769     }
770 
771     function name() public view returns (string memory) {
772         return _name;
773     }
774 
775     function symbol() public view returns (string memory) {
776         return _symbol;
777     }
778 
779     function decimals() public view returns (uint8) {
780         return _decimals;
781     }
782 
783     function totalSupply() public view override returns (uint256) {
784         return _tTotal;
785     }
786 
787     function balanceOf(address account) public view override returns (uint256) {
788         if (_isExcluded[account]) return _tOwned[account];
789         return tokenFromReflection(_rOwned[account]);
790     }
791 
792     function transfer(address recipient, uint256 amount) public override returns (bool) {
793         _transfer(_msgSender(), recipient, amount);
794         return true;
795     }
796 
797     function allowance(address owner, address spender) public view override returns (uint256) {
798         return _allowances[owner][spender];
799     }
800 
801     function approve(address spender, uint256 amount) public override returns (bool) {
802         _approve(_msgSender(), spender, amount);
803         return true;
804     }
805 
806     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
807         _transfer(sender, recipient, amount);
808         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
809         return true;
810     }
811 
812     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
814         return true;
815     }
816 
817     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
818         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
819         return true;
820     }
821 
822     function isExcludedFromReward(address account) public view returns (bool) {
823         return _isExcluded[account];
824     }
825 
826     function totalFees() public view returns (uint256) {
827         return _tFeeTotal;
828     }
829 
830     function devAddress() public view returns (address) {
831         return _devAddress;
832     }
833 
834     function marketingAddress() public view returns (address) {
835         return _marketingAddress;
836     }
837 
838     function deliver(uint256 tAmount) public {
839         address sender = _msgSender();
840         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
841 
842         (,uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDev) = _getTValues(tAmount);
843         (uint256 rAmount,,) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDev, _getRate());
844         
845         _rOwned[sender] = _rOwned[sender].sub(rAmount);
846         _rTotal = _rTotal.sub(rAmount);
847         _tFeeTotal = _tFeeTotal.add(tAmount);
848     }
849 
850     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
851         require(tAmount <= _tTotal, "Amount must be less than supply");
852         
853         (,uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDev) = _getTValues(tAmount);
854         (uint256 rAmount, uint256 rTransferAmount,) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDev, _getRate());
855 
856         if (!deductTransferFee) {
857             return rAmount;
858         } else {
859             return rTransferAmount;
860         }
861     }
862 
863     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
864         require(rAmount <= _rTotal, "Amount must be less than total reflections");
865         uint256 currentRate =  _getRate();
866         return rAmount.div(currentRate);
867     }
868     
869     function addBotToBlacklist (address account) external onlyOwner() {
870            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
871            require (!_isBlackListedBot[account], 'Account is already blacklisted');
872            _isBlackListedBot[account] = true;
873            _blackListedBots.push(account);
874         }
875 
876     function removeBotFromBlacklist(address account) external onlyOwner() {
877            require (_isBlackListedBot[account], 'Account is not blacklisted');
878            for (uint256 i = 0; i < _blackListedBots.length; i++) {
879                  if (_blackListedBots[i] == account) {
880                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
881                      _isBlackListedBot[account] = false;
882                      _blackListedBots.pop();
883                      break;
884                  }
885            }
886         }       
887 
888     function excludeFromReward(address account) public onlyOwner() {
889         require(!_isExcluded[account], "Account is already excluded");
890         if(_rOwned[account] > 0) {
891             _tOwned[account] = tokenFromReflection(_rOwned[account]);
892         }
893         _isExcluded[account] = true;
894         _excluded.push(account);
895     }
896 
897     function includeInReward(address account) external onlyOwner() {
898         require(_isExcluded[account], "Account is not excluded");
899         for (uint256 i = 0; i < _excluded.length; i++) {
900             if (_excluded[i] == account) {
901                 _excluded[i] = _excluded[_excluded.length - 1];
902                 _tOwned[account] = 0;
903                 _isExcluded[account] = false;
904                 _excluded.pop();
905                 break;
906             }
907         }
908     }
909         
910     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
911         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDev) = _getTValues(tAmount);
912         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDev, _getRate());
913 
914         _tOwned[sender] = _tOwned[sender].sub(tAmount);
915         _rOwned[sender] = _rOwned[sender].sub(rAmount);
916         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
917         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
918         _takeLiquidity(tLiquidity);
919         _takeMarketingFee(tMarketing);
920         _takeDevFee(tDev);
921         _reflectFee(rFee, tFee);
922         emit Transfer(sender, recipient, tTransferAmount);
923     }
924         
925     function excludeFromFee(address account) public onlyOwner {
926         _isExcludedFromFee[account] = true;
927     }
928     
929     function includeInFee(address account) public onlyOwner {
930         _isExcludedFromFee[account] = false;
931     }
932     
933     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
934         _taxFee = taxFee;
935     }
936     
937     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
938         _liquidityFee = liquidityFee;
939     }
940     
941     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
942         _marketingFee = marketingFee;
943     }
944    
945     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
946         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
947             10**2
948         );
949     }
950     
951      function _setMaxWalletSizePercent (uint256 maxWalletSize) external onlyOwner() {
952           _maxWalletSize = _tTotal.mul(maxWalletSize).div(
953             10**2
954         );
955             
956     }
957 
958     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
959         swapAndLiquifyEnabled = _enabled;
960         emit SwapAndLiquifyEnabledUpdated(_enabled);
961     }
962     
963      //to recieve ETH from uniswapV2Router when swapping
964     receive() external payable {}
965 
966     function _reflectFee(uint256 rFee, uint256 tFee) private {
967         _rTotal = _rTotal.sub(rFee);
968         _tFeeTotal = _tFeeTotal.add(tFee);
969     }
970 
971     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
972         uint256 tFee = calculateTaxFee(tAmount);
973         uint256 tLiquidity = calculateLiquidityFee(tAmount);
974         uint256 tMarketing = calculateMarketingFee(tAmount);
975         uint256 tDev = calculateDevFee(tAmount);
976         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
977                 tTransferAmount = tTransferAmount.sub(tMarketing);
978                 tTransferAmount = tTransferAmount.sub(tDev);
979 
980         return (tTransferAmount, tFee, tLiquidity, tMarketing, tDev);
981     }
982 
983     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDev, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
984         uint256 rAmount = tAmount.mul(currentRate);
985         uint256 rFee = tFee.mul(currentRate);
986         uint256 rLiquidity = tLiquidity.mul(currentRate);
987         uint256 rMarketing = tMarketing.mul(currentRate);
988         uint256 rDev = tDev.mul(currentRate);
989         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rMarketing).sub(rDev);
990         return (rAmount, rTransferAmount, rFee);
991     }
992 
993     function _getRate() private view returns(uint256) {
994         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
995         return rSupply.div(tSupply);
996     }
997 
998     function _getCurrentSupply() private view returns(uint256, uint256) {
999         uint256 rSupply = _rTotal;
1000         uint256 tSupply = _tTotal;      
1001         for (uint256 i = 0; i < _excluded.length; i++) {
1002             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1003             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1004             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1005         }
1006         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1007         return (rSupply, tSupply);
1008     }
1009 
1010     function _takeLiquidity(uint256 tLiquidity) private {
1011         uint256 currentRate =  _getRate();
1012         uint256 rLiquidity = tLiquidity.mul(currentRate);
1013         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1014         if(_isExcluded[address(this)])
1015             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1016     }
1017 
1018     function _takeMarketingFee(uint256 tMarketing) private {
1019         uint256 currentRate =  _getRate();
1020         uint256 rMarketing = tMarketing.mul(currentRate);
1021         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1022         if(_isExcluded[address(this)])
1023             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1024     }
1025 
1026     function _takeDevFee(uint256 tDev) private {
1027         uint256 currentRate =  _getRate();
1028         uint256 rDev = tDev.mul(currentRate);
1029         _rOwned[_devAddress] = _rOwned[_devAddress].add(rDev);
1030         if(_isExcluded[_devAddress])
1031             _tOwned[_devAddress] = _tOwned[_devAddress].add(tDev);
1032     }
1033 
1034     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1035         return _amount.mul(_taxFee).div(
1036             10**2
1037         );
1038     }
1039 
1040     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1041         return _amount.mul(_liquidityFee).div(
1042             10**2
1043         );
1044     }
1045 
1046     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1047         return _amount.mul(_marketingFee).div(
1048             10**2
1049         );
1050     }
1051 
1052     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1053         return _amount.mul(_devFee).div(
1054             10**2
1055         );
1056     }
1057 
1058     function removeAllFee() private {
1059         if(_taxFee == 0 && _liquidityFee == 0) return;
1060         
1061         _previousTaxFee = _taxFee;
1062         _previousLiquidityFee = _liquidityFee;
1063         _previousMarketingFee = _marketingFee;
1064         _previousDevFee = _devFee;
1065         
1066         _taxFee = 0;
1067         _liquidityFee = 0;
1068         _marketingFee = 0;
1069         _devFee = 0;
1070     }
1071 
1072     function restoreAllFee() private {
1073         _taxFee = _previousTaxFee;
1074         _liquidityFee = _previousLiquidityFee;
1075         _marketingFee = _previousMarketingFee;
1076         _devFee = _previousDevFee;
1077     }
1078 
1079     function isExcludedFromFee(address account) public view returns(bool) {
1080         return _isExcludedFromFee[account];
1081     }
1082 
1083     function _approve(address owner, address spender, uint256 amount) private {
1084         require(owner != address(0), "ERC20: approve from the zero address");
1085         require(spender != address(0), "ERC20: approve to the zero address");
1086 
1087         _allowances[owner][spender] = amount;
1088         emit Approval(owner, spender, amount);
1089     }
1090 
1091     function _transfer(
1092         address from,
1093         address to,
1094         uint256 amount
1095     ) private {
1096         require(from != address(0), "ERC20: transfer from the zero address");
1097         require(to != address(0), "ERC20: transfer to the zero address");
1098         require(amount > 0, "Transfer amount must be greater than zero");
1099         require(!_isBlackListedBot[from], "You are blacklisted");
1100         require(!_isBlackListedBot[msg.sender], "blacklisted");
1101         require(!_isBlackListedBot[tx.origin], "blacklisted");
1102         if(from != owner() && to != owner())
1103             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1104             require(amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
1105 
1106         // is the token balance of this contract address over the min number of
1107         // tokens that we need to initiate a swap + liquidity lock?
1108         // also, don't get caught in a circular liquidity event.
1109         // also, don't swap & liquify if sender is uniswap pair.
1110         uint256 contractTokenBalance = balanceOf(address(this));
1111         
1112         if(contractTokenBalance >= _maxTxAmount)
1113         {
1114             contractTokenBalance = _maxTxAmount;
1115         }
1116         
1117         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1118         if (
1119             overMinTokenBalance &&
1120             !inSwapAndLiquify &&
1121             from != uniswapV2Pair &&
1122             swapAndLiquifyEnabled
1123         ) {
1124             contractTokenBalance = numTokensSellToAddToLiquidity;
1125             //add liquidity
1126             swapAndLiquify(contractTokenBalance);
1127         }
1128         
1129         //indicates if fee should be deducted from transfer
1130         bool takeFee = true;
1131         
1132         //if any account belongs to _isExcludedFromFee account then remove the fee
1133         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1134             takeFee = false;
1135         }
1136         
1137         //transfer amount, it will take tax, burn, liquidity fee
1138         _tokenTransfer(from,to,amount,takeFee);
1139     }
1140 
1141     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1142         // Split the contract balance into halves
1143         uint256 denominator= (_liquidityFee + _marketingFee) * 2;
1144         uint256 tokensToAddLiquidityWith = tokens * _liquidityFee / denominator;
1145         uint256 toSwap = tokens - tokensToAddLiquidityWith;
1146 
1147         uint256 initialBalance = address(this).balance;
1148 
1149         swapTokensForEth(toSwap);
1150 
1151         uint256 deltaBalance = address(this).balance - initialBalance;
1152         uint256 unitBalance= deltaBalance / (denominator - _liquidityFee);
1153         uint256 bnbToAddLiquidityWith = unitBalance * _liquidityFee;
1154 
1155         if(bnbToAddLiquidityWith > 0){
1156             // Add liquidity to pancake
1157             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
1158         }
1159 
1160         // Send ETH to marketing
1161         uint256 marketingAmt = unitBalance * 2 * _marketingFee;
1162         if(marketingAmt > 0){
1163             payable(_marketingAddress).transfer(marketingAmt);
1164         }
1165     }
1166 
1167     function swapTokensForEth(uint256 tokenAmount) private {
1168         // generate the uniswap pair path of token -> weth
1169         address[] memory path = new address[](2);
1170         path[0] = address(this);
1171         path[1] = uniswapV2Router.WETH();
1172 
1173         _approve(address(this), address(uniswapV2Router), tokenAmount);
1174 
1175         // make the swap
1176         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1177             tokenAmount,
1178             0, // accept any amount of ETH
1179             path,
1180             address(this),
1181             block.timestamp
1182         );
1183     }
1184 
1185     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1186         // approve token transfer to cover all possible scenarios
1187         _approve(address(this), address(uniswapV2Router), tokenAmount);
1188 
1189         // add the liquidity
1190         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1191             address(this),
1192             tokenAmount,
1193             0, // slippage is unavoidable
1194             0, // slippage is unavoidable
1195             address(this),
1196             block.timestamp
1197         );
1198     }
1199 
1200     //this method is responsible for taking all fee, if takeFee is true
1201     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1202         if(!takeFee)
1203             removeAllFee();
1204         
1205         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1206             _transferFromExcluded(sender, recipient, amount);
1207         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1208             _transferToExcluded(sender, recipient, amount);
1209         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1210             _transferStandard(sender, recipient, amount);
1211         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1212             _transferBothExcluded(sender, recipient, amount);
1213         } else {
1214             _transferStandard(sender, recipient, amount);
1215         }
1216         
1217         if(!takeFee)
1218             restoreAllFee();
1219     }
1220 
1221     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1222         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDev) = _getTValues(tAmount);
1223         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDev, _getRate());
1224         
1225         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1226         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1227         _takeLiquidity(tLiquidity);
1228         _takeMarketingFee(tMarketing);
1229         _takeDevFee(tDev);
1230         _reflectFee(rFee, tFee);
1231         emit Transfer(sender, recipient, tTransferAmount);
1232     }
1233 
1234     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1235         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDev) = _getTValues(tAmount);
1236         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDev, _getRate());
1237 
1238         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1239         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1240         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1241         _takeLiquidity(tLiquidity);
1242         _takeMarketingFee(tMarketing);
1243         _takeDevFee(tDev);
1244         _reflectFee(rFee, tFee);
1245         emit Transfer(sender, recipient, tTransferAmount);
1246     }
1247 
1248     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1249         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDev) = _getTValues(tAmount);
1250         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDev, _getRate());
1251 
1252         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1253         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1254         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1255         _takeLiquidity(tLiquidity);
1256         _takeMarketingFee(tMarketing);
1257         _takeDevFee(tDev);
1258         _reflectFee(rFee, tFee);
1259         emit Transfer(sender, recipient, tTransferAmount);
1260     }
1261 }