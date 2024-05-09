1 /**
2  *
3  *   
4  * SHIBGEKI - $SHIBGEKI
5  *
6  * Resurrected from inside the blockchain to save the memecoins.
7  *
8  * Website: https://www.shibgeki.com/
9  * Twitter: https://twitter.com/SHIBGEKI
10  * Telegram: https://t.me/ShibGeki_Join
11  *
12  * 
13  *                                                                           
14  *                                                                           
15 */                                                                           
16 
17 
18 pragma solidity ^0.8.9;
19 // SPDX-License-Identifier: Unlicensed
20 interface IERC20 {
21 
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
248 abstract contract Context {
249     //function _msgSender() internal view virtual returns (address payable) {
250     function _msgSender() internal view virtual returns (address) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes memory) {
255         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256         return msg.data;
257     }
258 }
259 
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * By default, the owner account will be the one that deploys the contract. This
405  * can later be changed with {transferOwnership}.
406  *
407  * This module is used through inheritance. It will make available the modifier
408  * `onlyOwner`, which can be applied to your functions to restrict their use to
409  * the owner.
410  */
411 contract Ownable is Context {
412     address private _owner;
413     address private _previousOwner;
414     uint256 private _lockTime;
415 
416     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
417 
418     /**
419      * @dev Initializes the contract setting the deployer as the initial owner.
420      */
421     constructor () {
422         address msgSender = _msgSender();
423         _owner = msgSender;
424         emit OwnershipTransferred(address(0), msgSender);
425     }
426 
427     /**
428      * @dev Returns the address of the current owner.
429      */
430     function owner() public view returns (address) {
431         return _owner;
432     }
433 
434     /**
435      * @dev Throws if called by any account other than the owner.
436      */
437     modifier onlyOwner() {
438         require(_owner == _msgSender(), "Ownable: caller is not the owner");
439         _;
440     }
441 
442      /**
443      * @dev Leaves the contract without owner. It will not be possible to call
444      * `onlyOwner` functions anymore. Can only be called by the current owner.
445      *
446      * NOTE: Renouncing ownership will leave the contract without an owner,
447      * thereby removing any functionality that is only available to the owner.
448      */
449     function renounceOwnership() public virtual onlyOwner {
450         emit OwnershipTransferred(_owner, address(0));
451         _owner = address(0);
452     }
453 
454     /**
455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
456      * Can only be called by the current owner.
457      */
458     function transferOwnership(address newOwner) public virtual onlyOwner {
459         require(newOwner != address(0), "Ownable: new owner is the zero address");
460         emit OwnershipTransferred(_owner, newOwner);
461         _owner = newOwner;
462     }
463 
464     function geUnlockTime() public view returns (uint256) {
465         return _lockTime;
466     }
467 
468     //Locks the contract for owner for the amount of time provided
469     function lock(uint256 time) public virtual onlyOwner {
470         _previousOwner = _owner;
471         _owner = address(0);
472         _lockTime = block.timestamp + time;
473         emit OwnershipTransferred(_owner, address(0));
474     }
475     
476     //Unlocks the contract for owner when _lockTime is exceeds
477     function unlock() public virtual {
478         require(_previousOwner == msg.sender, "You don't have permission to unlock");
479         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
480         emit OwnershipTransferred(_owner, _previousOwner);
481         _owner = _previousOwner;
482     }
483 }
484 
485 
486 interface IUniswapV2Factory {
487     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
488 
489     function feeTo() external view returns (address);
490     function feeToSetter() external view returns (address);
491 
492     function getPair(address tokenA, address tokenB) external view returns (address pair);
493     function allPairs(uint) external view returns (address pair);
494     function allPairsLength() external view returns (uint);
495 
496     function createPair(address tokenA, address tokenB) external returns (address pair);
497 
498     function setFeeTo(address) external;
499     function setFeeToSetter(address) external;
500 }
501 
502 
503 
504 interface IUniswapV2Pair {
505     event Approval(address indexed owner, address indexed spender, uint value);
506     event Transfer(address indexed from, address indexed to, uint value);
507 
508     function name() external pure returns (string memory);
509     function symbol() external pure returns (string memory);
510     function decimals() external pure returns (uint8);
511     function totalSupply() external view returns (uint);
512     function balanceOf(address owner) external view returns (uint);
513     function allowance(address owner, address spender) external view returns (uint);
514 
515     function approve(address spender, uint value) external returns (bool);
516     function transfer(address to, uint value) external returns (bool);
517     function transferFrom(address from, address to, uint value) external returns (bool);
518 
519     function DOMAIN_SEPARATOR() external view returns (bytes32);
520     function PERMIT_TYPEHASH() external pure returns (bytes32);
521     function nonces(address owner) external view returns (uint);
522 
523     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
524 
525     event Mint(address indexed sender, uint amount0, uint amount1);
526     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
527     event Swap(
528         address indexed sender,
529         uint amount0In,
530         uint amount1In,
531         uint amount0Out,
532         uint amount1Out,
533         address indexed to
534     );
535     event Sync(uint112 reserve0, uint112 reserve1);
536 
537     function MINIMUM_LIQUIDITY() external pure returns (uint);
538     function factory() external view returns (address);
539     function token0() external view returns (address);
540     function token1() external view returns (address);
541     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
542     function price0CumulativeLast() external view returns (uint);
543     function price1CumulativeLast() external view returns (uint);
544     function kLast() external view returns (uint);
545 
546     function mint(address to) external returns (uint liquidity);
547     function burn(address to) external returns (uint amount0, uint amount1);
548     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
549     function skim(address to) external;
550     function sync() external;
551 
552     function initialize(address, address) external;
553 }
554 
555 
556 interface IUniswapV2Router01 {
557     function factory() external pure returns (address);
558     function WETH() external pure returns (address);
559 
560     function addLiquidity(
561         address tokenA,
562         address tokenB,
563         uint amountADesired,
564         uint amountBDesired,
565         uint amountAMin,
566         uint amountBMin,
567         address to,
568         uint deadline
569     ) external returns (uint amountA, uint amountB, uint liquidity);
570     function addLiquidityETH(
571         address token,
572         uint amountTokenDesired,
573         uint amountTokenMin,
574         uint amountETHMin,
575         address to,
576         uint deadline
577     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
578     function removeLiquidity(
579         address tokenA,
580         address tokenB,
581         uint liquidity,
582         uint amountAMin,
583         uint amountBMin,
584         address to,
585         uint deadline
586     ) external returns (uint amountA, uint amountB);
587     function removeLiquidityETH(
588         address token,
589         uint liquidity,
590         uint amountTokenMin,
591         uint amountETHMin,
592         address to,
593         uint deadline
594     ) external returns (uint amountToken, uint amountETH);
595     function removeLiquidityWithPermit(
596         address tokenA,
597         address tokenB,
598         uint liquidity,
599         uint amountAMin,
600         uint amountBMin,
601         address to,
602         uint deadline,
603         bool approveMax, uint8 v, bytes32 r, bytes32 s
604     ) external returns (uint amountA, uint amountB);
605     function removeLiquidityETHWithPermit(
606         address token,
607         uint liquidity,
608         uint amountTokenMin,
609         uint amountETHMin,
610         address to,
611         uint deadline,
612         bool approveMax, uint8 v, bytes32 r, bytes32 s
613     ) external returns (uint amountToken, uint amountETH);
614     function swapExactTokensForTokens(
615         uint amountIn,
616         uint amountOutMin,
617         address[] calldata path,
618         address to,
619         uint deadline
620     ) external returns (uint[] memory amounts);
621     function swapTokensForExactTokens(
622         uint amountOut,
623         uint amountInMax,
624         address[] calldata path,
625         address to,
626         uint deadline
627     ) external returns (uint[] memory amounts);
628     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
629         external
630         payable
631         returns (uint[] memory amounts);
632     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
633         external
634         returns (uint[] memory amounts);
635     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
636         external
637         returns (uint[] memory amounts);
638     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
639         external
640         payable
641         returns (uint[] memory amounts);
642 
643     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
644     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
645     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
646     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
647     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
648 }
649 
650 
651 
652 
653 interface IUniswapV2Router02 is IUniswapV2Router01 {
654     function removeLiquidityETHSupportingFeeOnTransferTokens(
655         address token,
656         uint liquidity,
657         uint amountTokenMin,
658         uint amountETHMin,
659         address to,
660         uint deadline
661     ) external returns (uint amountETH);
662     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
663         address token,
664         uint liquidity,
665         uint amountTokenMin,
666         uint amountETHMin,
667         address to,
668         uint deadline,
669         bool approveMax, uint8 v, bytes32 r, bytes32 s
670     ) external returns (uint amountETH);
671 
672     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
673         uint amountIn,
674         uint amountOutMin,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external;
679     function swapExactETHForTokensSupportingFeeOnTransferTokens(
680         uint amountOutMin,
681         address[] calldata path,
682         address to,
683         uint deadline
684     ) external payable;
685     function swapExactTokensForETHSupportingFeeOnTransferTokens(
686         uint amountIn,
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external;
692 }
693 
694 interface IAirdrop {
695     function airdrop(address recipient, uint256 amount) external;
696 }
697 
698 contract Shibgeki is Context, IERC20, Ownable {
699     using SafeMath for uint256;
700     using Address for address;
701 
702     mapping (address => uint256) private _rOwned;
703     mapping (address => uint256) private _tOwned;
704     mapping (address => mapping (address => uint256)) private _allowances;
705 
706     mapping (address => bool) private _isExcludedFromFee;
707 
708     mapping (address => bool) private _isExcluded;
709     address[] private _excluded;
710     
711     mapping (address => bool) private botWallets;
712     bool botscantrade = false;
713     
714     bool public canTrade = false;
715    
716     uint256 private constant MAX = ~uint256(0);
717     uint256 private _tTotal = 69000000000000000000000 * 10**9;
718     uint256 private _rTotal = (MAX - (MAX % _tTotal));
719     uint256 private _tFeeTotal;
720     address public teamAndMarketingWallet;
721 
722     string private _name = "Shibgeki";
723     string private _symbol = "SHIBGEKI";
724     uint8 private _decimals = 9;
725     
726     uint256 public _taxFee = 2;
727     uint256 private _previousTaxFee = _taxFee;
728 
729     uint256 public marketingFeePercent = 75;
730     
731     uint256 public _liquidityFee = 9;
732     uint256 private _previousLiquidityFee = _liquidityFee;
733 
734     IUniswapV2Router02 public immutable uniswapV2Router;
735     address public immutable uniswapV2Pair;
736     
737     bool inSwapAndLiquify;
738     bool public swapAndLiquifyEnabled = true;
739     
740     uint256 public _maxTxAmount = 345000000000000000000 * 10**9;
741     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
742     uint256 public _maxWalletSize = 690000000000000000000 * 10**9;
743     
744     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
745     event SwapAndLiquifyEnabledUpdated(bool enabled);
746     event SwapAndLiquify(
747         uint256 tokensSwapped,
748         uint256 ethReceived,
749         uint256 tokensIntoLiqudity
750     );
751     
752     modifier lockTheSwap {
753         inSwapAndLiquify = true;
754         _;
755         inSwapAndLiquify = false;
756     }
757     
758     constructor () {
759         _rOwned[_msgSender()] = _rTotal;
760         
761         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
762          // Create a uniswap pair for this new token
763         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
764             .createPair(address(this), _uniswapV2Router.WETH());
765 
766         // set the rest of the contract variables
767         uniswapV2Router = _uniswapV2Router;
768         
769         //exclude owner and this contract from fee
770         _isExcludedFromFee[owner()] = true;
771         _isExcludedFromFee[address(this)] = true;
772         
773         emit Transfer(address(0), _msgSender(), _tTotal);
774     }
775 
776     function name() public view returns (string memory) {
777         return _name;
778     }
779 
780     function symbol() public view returns (string memory) {
781         return _symbol;
782     }
783 
784     function decimals() public view returns (uint8) {
785         return _decimals;
786     }
787 
788     function totalSupply() public view override returns (uint256) {
789         return _tTotal;
790     }
791 
792     function balanceOf(address account) public view override returns (uint256) {
793         if (_isExcluded[account]) return _tOwned[account];
794         return tokenFromReflection(_rOwned[account]);
795     }
796 
797     function transfer(address recipient, uint256 amount) public override returns (bool) {
798         _transfer(_msgSender(), recipient, amount);
799         return true;
800     }
801 
802     function allowance(address owner, address spender) public view override returns (uint256) {
803         return _allowances[owner][spender];
804     }
805 
806     function approve(address spender, uint256 amount) public override returns (bool) {
807         _approve(_msgSender(), spender, amount);
808         return true;
809     }
810 
811     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
812         _transfer(sender, recipient, amount);
813         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
814         return true;
815     }
816 
817     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
818         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
819         return true;
820     }
821 
822     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
823         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
824         return true;
825     }
826 
827     function isExcludedFromReward(address account) public view returns (bool) {
828         return _isExcluded[account];
829     }
830 
831     function totalFees() public view returns (uint256) {
832         return _tFeeTotal;
833     }
834     
835     function airdrop(address recipient, uint256 amount) external onlyOwner() {
836         removeAllFee();
837         _transfer(_msgSender(), recipient, amount * 10**9);
838         restoreAllFee();
839     }
840     
841     function airdropInternal(address recipient, uint256 amount) internal {
842         removeAllFee();
843         _transfer(_msgSender(), recipient, amount);
844         restoreAllFee();
845     }
846     
847     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
848         uint256 iterator = 0;
849         require(newholders.length == amounts.length, "must be the same length");
850         while(iterator < newholders.length){
851             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
852             iterator += 1;
853         }
854     }
855 
856     function deliver(uint256 tAmount) public {
857         address sender = _msgSender();
858         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
859         (uint256 rAmount,,,,,) = _getValues(tAmount);
860         _rOwned[sender] = _rOwned[sender].sub(rAmount);
861         _rTotal = _rTotal.sub(rAmount);
862         _tFeeTotal = _tFeeTotal.add(tAmount);
863     }
864 
865     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
866         require(tAmount <= _tTotal, "Amount must be less than supply");
867         if (!deductTransferFee) {
868             (uint256 rAmount,,,,,) = _getValues(tAmount);
869             return rAmount;
870         } else {
871             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
872             return rTransferAmount;
873         }
874     }
875 
876     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
877         require(rAmount <= _rTotal, "Amount must be less than total reflections");
878         uint256 currentRate =  _getRate();
879         return rAmount.div(currentRate);
880     }
881 
882     function excludeFromReward(address account) public onlyOwner() {
883         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
884         require(!_isExcluded[account], "Account is already excluded");
885         if(_rOwned[account] > 0) {
886             _tOwned[account] = tokenFromReflection(_rOwned[account]);
887         }
888         _isExcluded[account] = true;
889         _excluded.push(account);
890     }
891 
892     function includeInReward(address account) external onlyOwner() {
893         require(_isExcluded[account], "Account is already excluded");
894         for (uint256 i = 0; i < _excluded.length; i++) {
895             if (_excluded[i] == account) {
896                 _excluded[i] = _excluded[_excluded.length - 1];
897                 _tOwned[account] = 0;
898                 _isExcluded[account] = false;
899                 _excluded.pop();
900                 break;
901             }
902         }
903     }
904         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
905         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
906         _tOwned[sender] = _tOwned[sender].sub(tAmount);
907         _rOwned[sender] = _rOwned[sender].sub(rAmount);
908         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
909         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
910         _takeLiquidity(tLiquidity);
911         _reflectFee(rFee, tFee);
912         emit Transfer(sender, recipient, tTransferAmount);
913     }
914     
915     function excludeFromFee(address account) public onlyOwner {
916         _isExcludedFromFee[account] = true;
917     }
918     
919     function includeInFee(address account) public onlyOwner {
920         _isExcludedFromFee[account] = false;
921     }
922     function setMarketingFeePercent(uint256 fee) public onlyOwner {
923         marketingFeePercent = fee;
924     }
925 
926     function setTeamAndMarketingWallet(address walletAddress) public onlyOwner {
927         teamAndMarketingWallet = walletAddress;
928     }
929     
930     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
931         require(taxFee < 10, "Tax fee cannot be more than 10%");
932         _taxFee = taxFee;
933     }
934     
935     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
936         _liquidityFee = liquidityFee;
937     }
938 
939     function _setMaxWalletSizePercent(uint256 maxWalletSize)
940         external
941         onlyOwner
942     {
943         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
944     }
945    
946     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
947         require(maxTxAmount > 69000000, "Max Tx Amount cannot be less than 69 Million");
948         _maxTxAmount = maxTxAmount * 10**9;
949     }
950     
951     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
952         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
953         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
954     }
955     
956     function claimTokens () public onlyOwner {
957         // make sure we capture all BNB that may or may not be sent to this contract
958         payable(teamAndMarketingWallet).transfer(address(this).balance);
959     }
960     
961     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
962         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
963     }
964     
965     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
966         walletaddress.transfer(address(this).balance);
967     }
968     
969     function addBotWallet(address botwallet) external onlyOwner() {
970         botWallets[botwallet] = true;
971     }
972     
973     function removeBotWallet(address botwallet) external onlyOwner() {
974         botWallets[botwallet] = false;
975     }
976     
977     function getBotWalletStatus(address botwallet) public view returns (bool) {
978         return botWallets[botwallet];
979     }
980     
981     function allowtrading()external onlyOwner() {
982         canTrade = true;
983     }
984 
985     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
986         swapAndLiquifyEnabled = _enabled;
987         emit SwapAndLiquifyEnabledUpdated(_enabled);
988     }
989     
990      //to recieve ETH from uniswapV2Router when swaping
991     receive() external payable {}
992 
993     function _reflectFee(uint256 rFee, uint256 tFee) private {
994         _rTotal = _rTotal.sub(rFee);
995         _tFeeTotal = _tFeeTotal.add(tFee);
996     }
997 
998     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
999         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1000         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1001         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1002     }
1003 
1004     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1005         uint256 tFee = calculateTaxFee(tAmount);
1006         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1007         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1008         return (tTransferAmount, tFee, tLiquidity);
1009     }
1010 
1011     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1012         uint256 rAmount = tAmount.mul(currentRate);
1013         uint256 rFee = tFee.mul(currentRate);
1014         uint256 rLiquidity = tLiquidity.mul(currentRate);
1015         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1016         return (rAmount, rTransferAmount, rFee);
1017     }
1018 
1019     function _getRate() private view returns(uint256) {
1020         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1021         return rSupply.div(tSupply);
1022     }
1023 
1024     function _getCurrentSupply() private view returns(uint256, uint256) {
1025         uint256 rSupply = _rTotal;
1026         uint256 tSupply = _tTotal;      
1027         for (uint256 i = 0; i < _excluded.length; i++) {
1028             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1029             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1030             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1031         }
1032         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1033         return (rSupply, tSupply);
1034     }
1035     
1036     function _takeLiquidity(uint256 tLiquidity) private {
1037         uint256 currentRate =  _getRate();
1038         uint256 rLiquidity = tLiquidity.mul(currentRate);
1039         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1040         if(_isExcluded[address(this)])
1041             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1042     }
1043     
1044     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1045         return _amount.mul(_taxFee).div(
1046             10**2
1047         );
1048     }
1049 
1050     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1051         return _amount.mul(_liquidityFee).div(
1052             10**2
1053         );
1054     }
1055     
1056     function removeAllFee() private {
1057         if(_taxFee == 0 && _liquidityFee == 0) return;
1058         
1059         _previousTaxFee = _taxFee;
1060         _previousLiquidityFee = _liquidityFee;
1061         
1062         _taxFee = 0;
1063         _liquidityFee = 0;
1064     }
1065     
1066     function restoreAllFee() private {
1067         _taxFee = _previousTaxFee;
1068         _liquidityFee = _previousLiquidityFee;
1069     }
1070     
1071     function isExcludedFromFee(address account) public view returns(bool) {
1072         return _isExcludedFromFee[account];
1073     }
1074 
1075     function _approve(address owner, address spender, uint256 amount) private {
1076         require(owner != address(0), "ERC20: approve from the zero address");
1077         require(spender != address(0), "ERC20: approve to the zero address");
1078 
1079         _allowances[owner][spender] = amount;
1080         emit Approval(owner, spender, amount);
1081     }
1082 
1083     function _transfer(
1084         address from,
1085         address to,
1086         uint256 amount
1087     ) private {
1088         require(from != address(0), "ERC20: transfer from the zero address");
1089         require(to != address(0), "ERC20: transfer to the zero address");
1090         require(amount > 0, "Transfer amount must be greater than zero");
1091         if(from != owner() && to != owner())
1092             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1093 
1094         // is the token balance of this contract address over the min number of
1095         // tokens that we need to initiate a swap + liquidity lock?
1096         // also, don't get caught in a circular liquidity event.
1097         // also, don't swap & liquify if sender is uniswap pair.
1098         uint256 contractTokenBalance = balanceOf(address(this));
1099         
1100         if(contractTokenBalance >= _maxTxAmount)
1101         {
1102             contractTokenBalance = _maxTxAmount;
1103         }
1104         
1105         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1106         if (
1107             overMinTokenBalance &&
1108             !inSwapAndLiquify &&
1109             from != uniswapV2Pair &&
1110             swapAndLiquifyEnabled
1111         ) {
1112             contractTokenBalance = numTokensSellToAddToLiquidity;
1113             //add liquidity
1114             swapAndLiquify(contractTokenBalance);
1115         }
1116         
1117         //indicates if fee should be deducted from transfer
1118         bool takeFee = true;
1119         
1120         //if any account belongs to _isExcludedFromFee account then remove the fee
1121         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1122             takeFee = false;
1123         }
1124 
1125         if (takeFee) {
1126             if (to != uniswapV2Pair) {
1127                 require(
1128                     amount + balanceOf(to) <= _maxWalletSize,
1129                     "Recipient exceeds max wallet size."
1130                 );
1131             }
1132         }
1133         
1134         
1135         //transfer amount, it will take tax, burn, liquidity fee
1136         _tokenTransfer(from,to,amount,takeFee);
1137     }
1138 
1139     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1140         // split the contract balance into halves
1141         // add the marketing wallet
1142         uint256 half = contractTokenBalance.div(2);
1143         uint256 otherHalf = contractTokenBalance.sub(half);
1144 
1145         // capture the contract's current ETH balance.
1146         // this is so that we can capture exactly the amount of ETH that the
1147         // swap creates, and not make the liquidity event include any ETH that
1148         // has been manually sent to the contract
1149         uint256 initialBalance = address(this).balance;
1150 
1151         // swap tokens for ETH
1152         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1153 
1154         // how much ETH did we just swap into?
1155         uint256 newBalance = address(this).balance.sub(initialBalance);
1156         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1157         payable(teamAndMarketingWallet).transfer(marketingshare);
1158         newBalance -= marketingshare;
1159         // add liquidity to uniswap
1160         addLiquidity(otherHalf, newBalance);
1161         
1162         emit SwapAndLiquify(half, newBalance, otherHalf);
1163     }
1164 
1165     function swapTokensForEth(uint256 tokenAmount) private {
1166         // generate the uniswap pair path of token -> weth
1167         address[] memory path = new address[](2);
1168         path[0] = address(this);
1169         path[1] = uniswapV2Router.WETH();
1170 
1171         _approve(address(this), address(uniswapV2Router), tokenAmount);
1172 
1173         // make the swap
1174         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1175             tokenAmount,
1176             0, // accept any amount of ETH
1177             path,
1178             address(this),
1179             block.timestamp
1180         );
1181     }
1182 
1183     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1184         // approve token transfer to cover all possible scenarios
1185         _approve(address(this), address(uniswapV2Router), tokenAmount);
1186 
1187         // add the liquidity
1188         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1189             address(this),
1190             tokenAmount,
1191             0, // slippage is unavoidable
1192             0, // slippage is unavoidable
1193             owner(),
1194             block.timestamp
1195         );
1196     }
1197 
1198     //this method is responsible for taking all fee, if takeFee is true
1199     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1200         if(!canTrade){
1201             require(sender == owner()); // only owner allowed to trade or add liquidity
1202         }
1203         
1204         if(botWallets[sender] || botWallets[recipient]){
1205             require(botscantrade, "bots arent allowed to trade");
1206         }
1207         
1208         if(!takeFee)
1209             removeAllFee();
1210         
1211         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1212             _transferFromExcluded(sender, recipient, amount);
1213         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1214             _transferToExcluded(sender, recipient, amount);
1215         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1216             _transferStandard(sender, recipient, amount);
1217         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1218             _transferBothExcluded(sender, recipient, amount);
1219         } else {
1220             _transferStandard(sender, recipient, amount);
1221         }
1222         
1223         if(!takeFee)
1224             restoreAllFee();
1225     }
1226 
1227     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1228         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1229         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1230         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1231         _takeLiquidity(tLiquidity);
1232         _reflectFee(rFee, tFee);
1233         emit Transfer(sender, recipient, tTransferAmount);
1234     }
1235 
1236     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1237         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1238         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1239         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1240         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1241         _takeLiquidity(tLiquidity);
1242         _reflectFee(rFee, tFee);
1243         emit Transfer(sender, recipient, tTransferAmount);
1244     }
1245 
1246     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1247         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1248         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1249         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1250         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1251         _takeLiquidity(tLiquidity);
1252         _reflectFee(rFee, tFee);
1253         emit Transfer(sender, recipient, tTransferAmount);
1254     }
1255 
1256 }