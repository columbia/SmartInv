1 // #DOGENOBI 
2 // #JEDI
3 // Website: https://Dogenobi.xyz
4 // Twitter: https://twitter.com/DogenobiERC
5 // TG: https://t.me/dogenobi
6 // Instagram: https://www.instagram.com/dogenobi_official
7 // Reddit: https://www.reddit.com/r/Dogenobi/
8 // Announcements: https://t.me/dogenobiannouncements
9 
10 pragma solidity ^0.8.9;
11 // SPDX-License-Identifier: Unlicensed
12 interface IERC20 {
13 
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96  
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 abstract contract Context {
241     //function _msgSender() internal view virtual returns (address payable) {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes memory) {
247         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
248         return msg.data;
249     }
250 }
251 
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
276         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
277         // for accounts without code, i.e. `keccak256('')`
278         bytes32 codehash;
279         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
280         // solhint-disable-next-line no-inline-assembly
281         assembly { codehash := extcodehash(account) }
282         return (codehash != accountHash && codehash != 0x0);
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328       return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
338         return _functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         return _functionCallWithValue(target, data, value, errorMessage);
365     }
366 
367     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 /**
392  * @dev Contract module which provides a basic access control mechanism, where
393  * there is an account (an owner) that can be granted exclusive access to
394  * specific functions.
395  *
396  * By default, the owner account will be the one that deploys the contract. This
397  * can later be changed with {transferOwnership}.
398  *
399  * This module is used through inheritance. It will make available the modifier
400  * `onlyOwner`, which can be applied to your functions to restrict their use to
401  * the owner.
402  */
403 contract Ownable is Context {
404     address private _owner;
405     address private _previousOwner;
406     uint256 private _lockTime;
407 
408     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
409 
410     /**
411      * @dev Initializes the contract setting the deployer as the initial owner.
412      */
413     constructor () {
414         address msgSender = _msgSender();
415         _owner = msgSender;
416         emit OwnershipTransferred(address(0), msgSender);
417     }
418 
419     /**
420      * @dev Returns the address of the current owner.
421      */
422     function owner() public view returns (address) {
423         return _owner;
424     }
425 
426     /**
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         require(_owner == _msgSender(), "Ownable: caller is not the owner");
431         _;
432     }
433 
434      /**
435      * @dev Leaves the contract without owner. It will not be possible to call
436      * `onlyOwner` functions anymore. Can only be called by the current owner.
437      *
438      * NOTE: Renouncing ownership will leave the contract without an owner,
439      * thereby removing any functionality that is only available to the owner.
440      */
441     function renounceOwnership() public virtual onlyOwner {
442         emit OwnershipTransferred(_owner, address(0));
443         _owner = address(0);
444     }
445 
446     /**
447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
448      * Can only be called by the current owner.
449      */
450     function transferOwnership(address newOwner) public virtual onlyOwner {
451         require(newOwner != address(0), "Ownable: new owner is the zero address");
452         emit OwnershipTransferred(_owner, newOwner);
453         _owner = newOwner;
454     }
455 
456     function geUnlockTime() public view returns (uint256) {
457         return _lockTime;
458     }
459 
460     //Locks the contract for owner for the amount of time provided
461     function lock(uint256 time) public virtual onlyOwner {
462         _previousOwner = _owner;
463         _owner = address(0);
464         _lockTime = block.timestamp + time;
465         emit OwnershipTransferred(_owner, address(0));
466     }
467     
468     //Unlocks the contract for owner when _lockTime is exceeds
469     function unlock() public virtual {
470         require(_previousOwner == msg.sender, "You don't have permission to unlock");
471         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
472         emit OwnershipTransferred(_owner, _previousOwner);
473         _owner = _previousOwner;
474     }
475 }
476 
477 
478 interface IUniswapV2Factory {
479     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
480 
481     function feeTo() external view returns (address);
482     function feeToSetter() external view returns (address);
483 
484     function getPair(address tokenA, address tokenB) external view returns (address pair);
485     function allPairs(uint) external view returns (address pair);
486     function allPairsLength() external view returns (uint);
487 
488     function createPair(address tokenA, address tokenB) external returns (address pair);
489 
490     function setFeeTo(address) external;
491     function setFeeToSetter(address) external;
492 }
493 
494 
495 
496 interface IUniswapV2Pair {
497     event Approval(address indexed owner, address indexed spender, uint value);
498     event Transfer(address indexed from, address indexed to, uint value);
499 
500     function name() external pure returns (string memory);
501     function symbol() external pure returns (string memory);
502     function decimals() external pure returns (uint8);
503     function totalSupply() external view returns (uint);
504     function balanceOf(address owner) external view returns (uint);
505     function allowance(address owner, address spender) external view returns (uint);
506 
507     function approve(address spender, uint value) external returns (bool);
508     function transfer(address to, uint value) external returns (bool);
509     function transferFrom(address from, address to, uint value) external returns (bool);
510 
511     function DOMAIN_SEPARATOR() external view returns (bytes32);
512     function PERMIT_TYPEHASH() external pure returns (bytes32);
513     function nonces(address owner) external view returns (uint);
514 
515     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
516 
517     event Mint(address indexed sender, uint amount0, uint amount1);
518     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
519     event Swap(
520         address indexed sender,
521         uint amount0In,
522         uint amount1In,
523         uint amount0Out,
524         uint amount1Out,
525         address indexed to
526     );
527     event Sync(uint112 reserve0, uint112 reserve1);
528 
529     function MINIMUM_LIQUIDITY() external pure returns (uint);
530     function factory() external view returns (address);
531     function token0() external view returns (address);
532     function token1() external view returns (address);
533     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
534     function price0CumulativeLast() external view returns (uint);
535     function price1CumulativeLast() external view returns (uint);
536     function kLast() external view returns (uint);
537 
538     function mint(address to) external returns (uint liquidity);
539     function burn(address to) external returns (uint amount0, uint amount1);
540     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
541     function skim(address to) external;
542     function sync() external;
543 
544     function initialize(address, address) external;
545 }
546 
547 
548 interface IUniswapV2Router01 {
549     function factory() external pure returns (address);
550     function WETH() external pure returns (address);
551 
552     function addLiquidity(
553         address tokenA,
554         address tokenB,
555         uint amountADesired,
556         uint amountBDesired,
557         uint amountAMin,
558         uint amountBMin,
559         address to,
560         uint deadline
561     ) external returns (uint amountA, uint amountB, uint liquidity);
562     function addLiquidityETH(
563         address token,
564         uint amountTokenDesired,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline
569     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
570     function removeLiquidity(
571         address tokenA,
572         address tokenB,
573         uint liquidity,
574         uint amountAMin,
575         uint amountBMin,
576         address to,
577         uint deadline
578     ) external returns (uint amountA, uint amountB);
579     function removeLiquidityETH(
580         address token,
581         uint liquidity,
582         uint amountTokenMin,
583         uint amountETHMin,
584         address to,
585         uint deadline
586     ) external returns (uint amountToken, uint amountETH);
587     function removeLiquidityWithPermit(
588         address tokenA,
589         address tokenB,
590         uint liquidity,
591         uint amountAMin,
592         uint amountBMin,
593         address to,
594         uint deadline,
595         bool approveMax, uint8 v, bytes32 r, bytes32 s
596     ) external returns (uint amountA, uint amountB);
597     function removeLiquidityETHWithPermit(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline,
604         bool approveMax, uint8 v, bytes32 r, bytes32 s
605     ) external returns (uint amountToken, uint amountETH);
606     function swapExactTokensForTokens(
607         uint amountIn,
608         uint amountOutMin,
609         address[] calldata path,
610         address to,
611         uint deadline
612     ) external returns (uint[] memory amounts);
613     function swapTokensForExactTokens(
614         uint amountOut,
615         uint amountInMax,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external returns (uint[] memory amounts);
620     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
621         external
622         payable
623         returns (uint[] memory amounts);
624     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
625         external
626         returns (uint[] memory amounts);
627     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
628         external
629         returns (uint[] memory amounts);
630     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
631         external
632         payable
633         returns (uint[] memory amounts);
634 
635     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
636     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
637     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
638     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
639     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
640 }
641 
642 
643 
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
686 interface IAirdrop {
687     function airdrop(address recipient, uint256 amount) external;
688 }
689 
690 contract Dogenobi is Context, IERC20, Ownable {
691     using SafeMath for uint256;
692     using Address for address;
693 
694     mapping (address => uint256) private _rOwned;
695     mapping (address => uint256) private _tOwned;
696     mapping (address => mapping (address => uint256)) private _allowances;
697 
698     mapping (address => bool) private _isExcludedFromFee;
699 
700     mapping (address => bool) private _isExcluded;
701     address[] private _excluded;
702     
703     mapping (address => bool) private botWallets;
704     bool botscantrade = false;
705     
706     bool public canTrade = false;
707    
708     uint256 private constant MAX = ~uint256(0);
709     uint256 private _tTotal = 69000000000000000000000 * 10**9;
710     uint256 private _rTotal = (MAX - (MAX % _tTotal));
711     uint256 private _tFeeTotal;
712     address public marketingWallet;
713 
714     string private _name = "Dogenobi";
715     string private _symbol = "JEDI";
716     uint8 private _decimals = 9;
717     
718     uint256 public _taxFee = 2;
719     uint256 private _previousTaxFee = _taxFee;
720 
721     uint256 public marketingFeePercent = 75;
722     
723     uint256 public _liquidityFee = 9;
724     uint256 private _previousLiquidityFee = _liquidityFee;
725 
726     IUniswapV2Router02 public immutable uniswapV2Router;
727     address public immutable uniswapV2Pair;
728     
729     bool inSwapAndLiquify;
730     bool public swapAndLiquifyEnabled = true;
731     
732     uint256 public _maxTxAmount = 276000000000000000000 * 10**9;
733     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
734     uint256 public _maxWalletSize = 690000000000000000000 * 10**9;
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
914     function setMarketingFeePercent(uint256 fee) public onlyOwner {
915         marketingFeePercent = fee;
916     }
917 
918     function setMarketingWallet(address walletAddress) public onlyOwner {
919         marketingWallet = walletAddress;
920     }
921     
922     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
923         require(taxFee < 10, "Tax fee cannot be more than 10%");
924         _taxFee = taxFee;
925     }
926     
927     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
928         _liquidityFee = liquidityFee;
929     }
930 
931     function _setMaxWalletSizePercent(uint256 maxWalletSize)
932         external
933         onlyOwner
934     {
935         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
936     }
937    
938     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
939         require(maxTxAmount > 69000000, "Max Tx Amount cannot be less than 69 Million");
940         _maxTxAmount = maxTxAmount * 10**9;
941     }
942     
943     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
944         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
945         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
946     }
947     
948     function claimTokens () public onlyOwner {
949         // make sure we capture all BNB that may or may not be sent to this contract
950         payable(marketingWallet).transfer(address(this).balance);
951     }
952     
953     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
954         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
955     }
956     
957     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
958         walletaddress.transfer(address(this).balance);
959     }
960     
961     function addBotWallet(address botwallet) external onlyOwner() {
962         botWallets[botwallet] = true;
963     }
964     
965     function removeBotWallet(address botwallet) external onlyOwner() {
966         botWallets[botwallet] = false;
967     }
968     
969     function getBotWalletStatus(address botwallet) public view returns (bool) {
970         return botWallets[botwallet];
971     }
972     
973     function allowtrading()external onlyOwner() {
974         canTrade = true;
975     }
976 
977     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
978         swapAndLiquifyEnabled = _enabled;
979         emit SwapAndLiquifyEnabledUpdated(_enabled);
980     }
981     
982      //to recieve ETH from uniswapV2Router when swaping
983     receive() external payable {}
984 
985     function _reflectFee(uint256 rFee, uint256 tFee) private {
986         _rTotal = _rTotal.sub(rFee);
987         _tFeeTotal = _tFeeTotal.add(tFee);
988     }
989 
990     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
991         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
992         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
993         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
994     }
995 
996     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
997         uint256 tFee = calculateTaxFee(tAmount);
998         uint256 tLiquidity = calculateLiquidityFee(tAmount);
999         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1000         return (tTransferAmount, tFee, tLiquidity);
1001     }
1002 
1003     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1004         uint256 rAmount = tAmount.mul(currentRate);
1005         uint256 rFee = tFee.mul(currentRate);
1006         uint256 rLiquidity = tLiquidity.mul(currentRate);
1007         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1008         return (rAmount, rTransferAmount, rFee);
1009     }
1010 
1011     function _getRate() private view returns(uint256) {
1012         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1013         return rSupply.div(tSupply);
1014     }
1015 
1016     function _getCurrentSupply() private view returns(uint256, uint256) {
1017         uint256 rSupply = _rTotal;
1018         uint256 tSupply = _tTotal;      
1019         for (uint256 i = 0; i < _excluded.length; i++) {
1020             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1021             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1022             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1023         }
1024         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1025         return (rSupply, tSupply);
1026     }
1027     
1028     function _takeLiquidity(uint256 tLiquidity) private {
1029         uint256 currentRate =  _getRate();
1030         uint256 rLiquidity = tLiquidity.mul(currentRate);
1031         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1032         if(_isExcluded[address(this)])
1033             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1034     }
1035     
1036     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1037         return _amount.mul(_taxFee).div(
1038             10**2
1039         );
1040     }
1041 
1042     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1043         return _amount.mul(_liquidityFee).div(
1044             10**2
1045         );
1046     }
1047     
1048     function removeAllFee() private {
1049         if(_taxFee == 0 && _liquidityFee == 0) return;
1050         
1051         _previousTaxFee = _taxFee;
1052         _previousLiquidityFee = _liquidityFee;
1053         
1054         _taxFee = 0;
1055         _liquidityFee = 0;
1056     }
1057     
1058     function restoreAllFee() private {
1059         _taxFee = _previousTaxFee;
1060         _liquidityFee = _previousLiquidityFee;
1061     }
1062     
1063     function isExcludedFromFee(address account) public view returns(bool) {
1064         return _isExcludedFromFee[account];
1065     }
1066 
1067     function _approve(address owner, address spender, uint256 amount) private {
1068         require(owner != address(0), "ERC20: approve from the zero address");
1069         require(spender != address(0), "ERC20: approve to the zero address");
1070 
1071         _allowances[owner][spender] = amount;
1072         emit Approval(owner, spender, amount);
1073     }
1074 
1075     function _transfer(
1076         address from,
1077         address to,
1078         uint256 amount
1079     ) private {
1080         require(from != address(0), "ERC20: transfer from the zero address");
1081         require(to != address(0), "ERC20: transfer to the zero address");
1082         require(amount > 0, "Transfer amount must be greater than zero");
1083         if(from != owner() && to != owner())
1084             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1085 
1086         // is the token balance of this contract address over the min number of
1087         // tokens that we need to initiate a swap + liquidity lock?
1088         // also, don't get caught in a circular liquidity event.
1089         // also, don't swap & liquify if sender is uniswap pair.
1090         uint256 contractTokenBalance = balanceOf(address(this));
1091         
1092         if(contractTokenBalance >= _maxTxAmount)
1093         {
1094             contractTokenBalance = _maxTxAmount;
1095         }
1096         
1097         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1098         if (
1099             overMinTokenBalance &&
1100             !inSwapAndLiquify &&
1101             from != uniswapV2Pair &&
1102             swapAndLiquifyEnabled
1103         ) {
1104             contractTokenBalance = numTokensSellToAddToLiquidity;
1105             //add liquidity
1106             swapAndLiquify(contractTokenBalance);
1107         }
1108         
1109         //indicates if fee should be deducted from transfer
1110         bool takeFee = true;
1111         
1112         //if any account belongs to _isExcludedFromFee account then remove the fee
1113         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1114             takeFee = false;
1115         }
1116 
1117         if (takeFee) {
1118             if (to != uniswapV2Pair) {
1119                 require(
1120                     amount + balanceOf(to) <= _maxWalletSize,
1121                     "Recipient exceeds max wallet size."
1122                 );
1123             }
1124         }
1125         
1126         
1127         //transfer amount, it will take tax, burn, liquidity fee
1128         _tokenTransfer(from,to,amount,takeFee);
1129     }
1130 
1131     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1132         // split the contract balance into halves
1133         // add the marketing wallet
1134         uint256 half = contractTokenBalance.div(2);
1135         uint256 otherHalf = contractTokenBalance.sub(half);
1136 
1137         // capture the contract's current ETH balance.
1138         // this is so that we can capture exactly the amount of ETH that the
1139         // swap creates, and not make the liquidity event include any ETH that
1140         // has been manually sent to the contract
1141         uint256 initialBalance = address(this).balance;
1142 
1143         // swap tokens for ETH
1144         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1145 
1146         // how much ETH did we just swap into?
1147         uint256 newBalance = address(this).balance.sub(initialBalance);
1148         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1149         payable(marketingWallet).transfer(marketingshare);
1150         newBalance -= marketingshare;
1151         // add liquidity to uniswap
1152         addLiquidity(otherHalf, newBalance);
1153         
1154         emit SwapAndLiquify(half, newBalance, otherHalf);
1155     }
1156 
1157     function swapTokensForEth(uint256 tokenAmount) private {
1158         // generate the uniswap pair path of token -> weth
1159         address[] memory path = new address[](2);
1160         path[0] = address(this);
1161         path[1] = uniswapV2Router.WETH();
1162 
1163         _approve(address(this), address(uniswapV2Router), tokenAmount);
1164 
1165         // make the swap
1166         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1167             tokenAmount,
1168             0, // accept any amount of ETH
1169             path,
1170             address(this),
1171             block.timestamp
1172         );
1173     }
1174 
1175     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1176         // approve token transfer to cover all possible scenarios
1177         _approve(address(this), address(uniswapV2Router), tokenAmount);
1178 
1179         // add the liquidity
1180         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1181             address(this),
1182             tokenAmount,
1183             0, // slippage is unavoidable
1184             0, // slippage is unavoidable
1185             owner(),
1186             block.timestamp
1187         );
1188     }
1189 
1190     //this method is responsible for taking all fee, if takeFee is true
1191     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1192         if(!canTrade){
1193             require(sender == owner()); // only owner allowed to trade or add liquidity
1194         }
1195         
1196         if(botWallets[sender] || botWallets[recipient]){
1197             require(botscantrade, "bots arent allowed to trade");
1198         }
1199         
1200         if(!takeFee)
1201             removeAllFee();
1202         
1203         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1204             _transferFromExcluded(sender, recipient, amount);
1205         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1206             _transferToExcluded(sender, recipient, amount);
1207         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1208             _transferStandard(sender, recipient, amount);
1209         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1210             _transferBothExcluded(sender, recipient, amount);
1211         } else {
1212             _transferStandard(sender, recipient, amount);
1213         }
1214         
1215         if(!takeFee)
1216             restoreAllFee();
1217     }
1218 
1219     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1220         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1221         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1222         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1223         _takeLiquidity(tLiquidity);
1224         _reflectFee(rFee, tFee);
1225         emit Transfer(sender, recipient, tTransferAmount);
1226     }
1227 
1228     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1229         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1230         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1231         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1232         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1233         _takeLiquidity(tLiquidity);
1234         _reflectFee(rFee, tFee);
1235         emit Transfer(sender, recipient, tTransferAmount);
1236     }
1237 
1238     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1239         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1240         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1241         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1242         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1243         _takeLiquidity(tLiquidity);
1244         _reflectFee(rFee, tFee);
1245         emit Transfer(sender, recipient, tTransferAmount);
1246     }
1247 
1248 }