1 /**
2  *
3  *   
4  *  $MEANCARROT - Mean Carrot
5  *
6  *  THIS CARROT ISN’T MESSING AROUND🥕
7  *
8  *  He mean af and ready to rule the meme chain.
9  *
10  *
11  * 
12  *  🌎: https://www.meancarrot.com/
13  *  🐧: https://twitter.com/MEANCARROTToken
14  *  🎤: https://t.me/MEANCARROT_Join
15  * 
16  *                                                                           
17  *                                                                           
18 */                                                                           
19 
20 
21 pragma solidity ^0.8.9;
22 // SPDX-License-Identifier: Unlicensed
23 interface IERC20 {
24 
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107  
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplication overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         return div(a, b, "SafeMath: division by zero");
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b != 0, errorMessage);
247         return a % b;
248     }
249 }
250 
251 abstract contract Context {
252     //function _msgSender() internal view virtual returns (address payable) {
253     function _msgSender() internal view virtual returns (address) {
254         return msg.sender;
255     }
256 
257     function _msgData() internal view virtual returns (bytes memory) {
258         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
259         return msg.data;
260     }
261 }
262 
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288         // for accounts without code, i.e. `keccak256('')`
289         bytes32 codehash;
290         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { codehash := extcodehash(account) }
293         return (codehash != accountHash && codehash != 0x0);
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 contract Ownable is Context {
415     address private _owner;
416     address private _previousOwner;
417     uint256 private _lockTime;
418 
419     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
420 
421     /**
422      * @dev Initializes the contract setting the deployer as the initial owner.
423      */
424     constructor () {
425         address msgSender = _msgSender();
426         _owner = msgSender;
427         emit OwnershipTransferred(address(0), msgSender);
428     }
429 
430     /**
431      * @dev Returns the address of the current owner.
432      */
433     function owner() public view returns (address) {
434         return _owner;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         require(_owner == _msgSender(), "Ownable: caller is not the owner");
442         _;
443     }
444 
445      /**
446      * @dev Leaves the contract without owner. It will not be possible to call
447      * `onlyOwner` functions anymore. Can only be called by the current owner.
448      *
449      * NOTE: Renouncing ownership will leave the contract without an owner,
450      * thereby removing any functionality that is only available to the owner.
451      */
452     function renounceOwnership() public virtual onlyOwner {
453         emit OwnershipTransferred(_owner, address(0));
454         _owner = address(0);
455     }
456 
457     /**
458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
459      * Can only be called by the current owner.
460      */
461     function transferOwnership(address newOwner) public virtual onlyOwner {
462         require(newOwner != address(0), "Ownable: new owner is the zero address");
463         emit OwnershipTransferred(_owner, newOwner);
464         _owner = newOwner;
465     }
466 
467     function geUnlockTime() public view returns (uint256) {
468         return _lockTime;
469     }
470 
471     //Locks the contract for owner for the amount of time provided
472     function lock(uint256 time) public virtual onlyOwner {
473         _previousOwner = _owner;
474         _owner = address(0);
475         _lockTime = block.timestamp + time;
476         emit OwnershipTransferred(_owner, address(0));
477     }
478     
479     //Unlocks the contract for owner when _lockTime is exceeds
480     function unlock() public virtual {
481         require(_previousOwner == msg.sender, "You don't have permission to unlock");
482         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
483         emit OwnershipTransferred(_owner, _previousOwner);
484         _owner = _previousOwner;
485     }
486 }
487 
488 
489 interface IUniswapV2Factory {
490     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
491 
492     function feeTo() external view returns (address);
493     function feeToSetter() external view returns (address);
494 
495     function getPair(address tokenA, address tokenB) external view returns (address pair);
496     function allPairs(uint) external view returns (address pair);
497     function allPairsLength() external view returns (uint);
498 
499     function createPair(address tokenA, address tokenB) external returns (address pair);
500 
501     function setFeeTo(address) external;
502     function setFeeToSetter(address) external;
503 }
504 
505 
506 
507 interface IUniswapV2Pair {
508     event Approval(address indexed owner, address indexed spender, uint value);
509     event Transfer(address indexed from, address indexed to, uint value);
510 
511     function name() external pure returns (string memory);
512     function symbol() external pure returns (string memory);
513     function decimals() external pure returns (uint8);
514     function totalSupply() external view returns (uint);
515     function balanceOf(address owner) external view returns (uint);
516     function allowance(address owner, address spender) external view returns (uint);
517 
518     function approve(address spender, uint value) external returns (bool);
519     function transfer(address to, uint value) external returns (bool);
520     function transferFrom(address from, address to, uint value) external returns (bool);
521 
522     function DOMAIN_SEPARATOR() external view returns (bytes32);
523     function PERMIT_TYPEHASH() external pure returns (bytes32);
524     function nonces(address owner) external view returns (uint);
525 
526     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
527 
528     event Mint(address indexed sender, uint amount0, uint amount1);
529     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
530     event Swap(
531         address indexed sender,
532         uint amount0In,
533         uint amount1In,
534         uint amount0Out,
535         uint amount1Out,
536         address indexed to
537     );
538     event Sync(uint112 reserve0, uint112 reserve1);
539 
540     function MINIMUM_LIQUIDITY() external pure returns (uint);
541     function factory() external view returns (address);
542     function token0() external view returns (address);
543     function token1() external view returns (address);
544     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
545     function price0CumulativeLast() external view returns (uint);
546     function price1CumulativeLast() external view returns (uint);
547     function kLast() external view returns (uint);
548 
549     function mint(address to) external returns (uint liquidity);
550     function burn(address to) external returns (uint amount0, uint amount1);
551     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
552     function skim(address to) external;
553     function sync() external;
554 
555     function initialize(address, address) external;
556 }
557 
558 
559 interface IUniswapV2Router01 {
560     function factory() external pure returns (address);
561     function WETH() external pure returns (address);
562 
563     function addLiquidity(
564         address tokenA,
565         address tokenB,
566         uint amountADesired,
567         uint amountBDesired,
568         uint amountAMin,
569         uint amountBMin,
570         address to,
571         uint deadline
572     ) external returns (uint amountA, uint amountB, uint liquidity);
573     function addLiquidityETH(
574         address token,
575         uint amountTokenDesired,
576         uint amountTokenMin,
577         uint amountETHMin,
578         address to,
579         uint deadline
580     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
581     function removeLiquidity(
582         address tokenA,
583         address tokenB,
584         uint liquidity,
585         uint amountAMin,
586         uint amountBMin,
587         address to,
588         uint deadline
589     ) external returns (uint amountA, uint amountB);
590     function removeLiquidityETH(
591         address token,
592         uint liquidity,
593         uint amountTokenMin,
594         uint amountETHMin,
595         address to,
596         uint deadline
597     ) external returns (uint amountToken, uint amountETH);
598     function removeLiquidityWithPermit(
599         address tokenA,
600         address tokenB,
601         uint liquidity,
602         uint amountAMin,
603         uint amountBMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountA, uint amountB);
608     function removeLiquidityETHWithPermit(
609         address token,
610         uint liquidity,
611         uint amountTokenMin,
612         uint amountETHMin,
613         address to,
614         uint deadline,
615         bool approveMax, uint8 v, bytes32 r, bytes32 s
616     ) external returns (uint amountToken, uint amountETH);
617     function swapExactTokensForTokens(
618         uint amountIn,
619         uint amountOutMin,
620         address[] calldata path,
621         address to,
622         uint deadline
623     ) external returns (uint[] memory amounts);
624     function swapTokensForExactTokens(
625         uint amountOut,
626         uint amountInMax,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external returns (uint[] memory amounts);
631     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
632         external
633         payable
634         returns (uint[] memory amounts);
635     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
636         external
637         returns (uint[] memory amounts);
638     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
639         external
640         returns (uint[] memory amounts);
641     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
642         external
643         payable
644         returns (uint[] memory amounts);
645 
646     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
647     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
648     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
649     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
650     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
651 }
652 
653 
654 
655 
656 interface IUniswapV2Router02 is IUniswapV2Router01 {
657     function removeLiquidityETHSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline
664     ) external returns (uint amountETH);
665     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
666         address token,
667         uint liquidity,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         uint deadline,
672         bool approveMax, uint8 v, bytes32 r, bytes32 s
673     ) external returns (uint amountETH);
674 
675     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
676         uint amountIn,
677         uint amountOutMin,
678         address[] calldata path,
679         address to,
680         uint deadline
681     ) external;
682     function swapExactETHForTokensSupportingFeeOnTransferTokens(
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external payable;
688     function swapExactTokensForETHSupportingFeeOnTransferTokens(
689         uint amountIn,
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external;
695 }
696 
697 interface IAirdrop {
698     function airdrop(address recipient, uint256 amount) external;
699 }
700 
701 contract MEANCARROT is Context, IERC20, Ownable {
702     using SafeMath for uint256;
703     using Address for address;
704 
705     mapping (address => uint256) private _rOwned;
706     mapping (address => uint256) private _tOwned;
707     mapping (address => mapping (address => uint256)) private _allowances;
708 
709     mapping (address => bool) private _isExcludedFromFee;
710 
711     mapping (address => bool) private _isExcluded;
712     address[] private _excluded;
713     
714     mapping (address => bool) private botWallets;
715     bool botscantrade = false;
716     
717     bool public canTrade = false;
718    
719     uint256 private constant MAX = ~uint256(0);
720     uint256 private _tTotal = 69000000000000000000000 * 10**9;
721     uint256 private _rTotal = (MAX - (MAX % _tTotal));
722     uint256 private _tFeeTotal;
723     //This wallet is used for Developer, Callers, Dextools, Marketing and other expenses. No one is working for free!
724     address public taxWallet;
725 
726     string private _name = "Mean Carrot";
727     string private _symbol = "MEANCARROT";
728     uint8 private _decimals = 9;
729     
730     uint256 public _taxFee = 1;
731     uint256 private _previousTaxFee = _taxFee;
732     
733     uint256 public _liquidityFee = 9;
734     uint256 private _previousLiquidityFee = _liquidityFee;
735 
736     IUniswapV2Router02 public immutable uniswapV2Router;
737     address public immutable uniswapV2Pair;
738     
739     bool inSwapAndLiquify;
740     bool public swapAndLiquifyEnabled = true;
741     
742     uint256 public _maxTxAmount = 690000000000000000000 * 10**9;
743     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
744     uint256 public _maxWalletSize = 690000000000000000000 * 10**9;
745     
746     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
747     event SwapAndLiquifyEnabledUpdated(bool enabled);
748     event SwapAndLiquify(
749         uint256 tokensSwapped,
750         uint256 ethReceived,
751         uint256 tokensIntoLiqudity
752     );
753     
754     modifier lockTheSwap {
755         inSwapAndLiquify = true;
756         _;
757         inSwapAndLiquify = false;
758     }
759     
760     constructor () {
761         _rOwned[_msgSender()] = _rTotal;
762         
763         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
764          // Create a uniswap pair for this new token
765         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
766             .createPair(address(this), _uniswapV2Router.WETH());
767 
768         // set the rest of the contract variables
769         uniswapV2Router = _uniswapV2Router;
770         
771         //exclude owner and this contract from fee
772         _isExcludedFromFee[owner()] = true;
773         _isExcludedFromFee[address(this)] = true;
774         
775         emit Transfer(address(0), _msgSender(), _tTotal);
776     }
777 
778     function name() public view returns (string memory) {
779         return _name;
780     }
781 
782     function symbol() public view returns (string memory) {
783         return _symbol;
784     }
785 
786     function decimals() public view returns (uint8) {
787         return _decimals;
788     }
789 
790     function totalSupply() public view override returns (uint256) {
791         return _tTotal;
792     }
793 
794     function balanceOf(address account) public view override returns (uint256) {
795         if (_isExcluded[account]) return _tOwned[account];
796         return tokenFromReflection(_rOwned[account]);
797     }
798 
799     function transfer(address recipient, uint256 amount) public override returns (bool) {
800         _transfer(_msgSender(), recipient, amount);
801         return true;
802     }
803 
804     function allowance(address owner, address spender) public view override returns (uint256) {
805         return _allowances[owner][spender];
806     }
807 
808     function approve(address spender, uint256 amount) public override returns (bool) {
809         _approve(_msgSender(), spender, amount);
810         return true;
811     }
812 
813     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
814         _transfer(sender, recipient, amount);
815         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
816         return true;
817     }
818 
819     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
820         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
821         return true;
822     }
823 
824     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
825         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
826         return true;
827     }
828 
829     function isExcludedFromReward(address account) public view returns (bool) {
830         return _isExcluded[account];
831     }
832 
833     function totalFees() public view returns (uint256) {
834         return _tFeeTotal;
835     }
836     
837     function airdrop(address recipient, uint256 amount) external onlyOwner() {
838         removeAllFee();
839         _transfer(_msgSender(), recipient, amount * 10**9);
840         restoreAllFee();
841     }
842     
843     function airdropInternal(address recipient, uint256 amount) internal {
844         removeAllFee();
845         _transfer(_msgSender(), recipient, amount);
846         restoreAllFee();
847     }
848     
849     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
850         uint256 iterator = 0;
851         require(newholders.length == amounts.length, "must be the same length");
852         while(iterator < newholders.length){
853             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
854             iterator += 1;
855         }
856     }
857 
858     function deliver(uint256 tAmount) public {
859         address sender = _msgSender();
860         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
861         (uint256 rAmount,,,,,) = _getValues(tAmount);
862         _rOwned[sender] = _rOwned[sender].sub(rAmount);
863         _rTotal = _rTotal.sub(rAmount);
864         _tFeeTotal = _tFeeTotal.add(tAmount);
865     }
866 
867     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
868         require(tAmount <= _tTotal, "Amount must be less than supply");
869         if (!deductTransferFee) {
870             (uint256 rAmount,,,,,) = _getValues(tAmount);
871             return rAmount;
872         } else {
873             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
874             return rTransferAmount;
875         }
876     }
877 
878     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
879         require(rAmount <= _rTotal, "Amount must be less than total reflections");
880         uint256 currentRate =  _getRate();
881         return rAmount.div(currentRate);
882     }
883 
884     function excludeFromReward(address account) public onlyOwner() {
885         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
886         require(!_isExcluded[account], "Account is already excluded");
887         if(_rOwned[account] > 0) {
888             _tOwned[account] = tokenFromReflection(_rOwned[account]);
889         }
890         _isExcluded[account] = true;
891         _excluded.push(account);
892     }
893 
894     function includeInReward(address account) external onlyOwner() {
895         require(_isExcluded[account], "Account is already excluded");
896         for (uint256 i = 0; i < _excluded.length; i++) {
897             if (_excluded[i] == account) {
898                 _excluded[i] = _excluded[_excluded.length - 1];
899                 _tOwned[account] = 0;
900                 _isExcluded[account] = false;
901                 _excluded.pop();
902                 break;
903             }
904         }
905     }
906         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
907         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
908         _tOwned[sender] = _tOwned[sender].sub(tAmount);
909         _rOwned[sender] = _rOwned[sender].sub(rAmount);
910         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
911         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
912         _takeLiquidity(tLiquidity);
913         _reflectFee(rFee, tFee);
914         emit Transfer(sender, recipient, tTransferAmount);
915     }
916     
917     function excludeFromFee(address account) public onlyOwner {
918         _isExcludedFromFee[account] = true;
919     }
920     
921     function includeInFee(address account) public onlyOwner {
922         _isExcludedFromFee[account] = false;
923     }
924 
925     function setTaxWallet(address walletAddress) public onlyOwner {
926         taxWallet = walletAddress;
927     }
928     
929     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
930         require(taxFee < 10, "Tax fee cannot be more than 10%");
931         _taxFee = taxFee;
932     }
933     
934     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
935         _liquidityFee = liquidityFee;
936     }
937 
938     function _setMaxWalletSizePercent(uint256 maxWalletSize)
939         external
940         onlyOwner
941     {
942         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
943     }
944    
945     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
946         require(maxTxAmount > 69000000, "Max Tx Amount cannot be less than 69 Million");
947         _maxTxAmount = maxTxAmount * 10**9;
948     }
949     
950     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
951         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
952         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
953     }
954     
955     
956     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
957         walletaddress.transfer(address(this).balance);
958     }
959     
960     function addBotWallet(address botwallet) external onlyOwner() {
961         botWallets[botwallet] = true;
962     }
963     
964     function removeBotWallet(address botwallet) external onlyOwner() {
965         botWallets[botwallet] = false;
966     }
967     
968     function getBotWalletStatus(address botwallet) public view returns (bool) {
969         return botWallets[botwallet];
970     }
971     
972     function allowtrading()external onlyOwner() {
973         canTrade = true;
974     }
975 
976     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
977         swapAndLiquifyEnabled = _enabled;
978         emit SwapAndLiquifyEnabledUpdated(_enabled);
979     }
980     
981      //to recieve ETH from uniswapV2Router when swaping
982     receive() external payable {}
983 
984     function _reflectFee(uint256 rFee, uint256 tFee) private {
985         _rTotal = _rTotal.sub(rFee);
986         _tFeeTotal = _tFeeTotal.add(tFee);
987     }
988 
989     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
990         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
991         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
992         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
993     }
994 
995     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
996         uint256 tFee = calculateTaxFee(tAmount);
997         uint256 tLiquidity = calculateLiquidityFee(tAmount);
998         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
999         return (tTransferAmount, tFee, tLiquidity);
1000     }
1001 
1002     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1003         uint256 rAmount = tAmount.mul(currentRate);
1004         uint256 rFee = tFee.mul(currentRate);
1005         uint256 rLiquidity = tLiquidity.mul(currentRate);
1006         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1007         return (rAmount, rTransferAmount, rFee);
1008     }
1009 
1010     function _getRate() private view returns(uint256) {
1011         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1012         return rSupply.div(tSupply);
1013     }
1014 
1015     function _getCurrentSupply() private view returns(uint256, uint256) {
1016         uint256 rSupply = _rTotal;
1017         uint256 tSupply = _tTotal;      
1018         for (uint256 i = 0; i < _excluded.length; i++) {
1019             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1020             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1021             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1022         }
1023         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1024         return (rSupply, tSupply);
1025     }
1026     
1027     function _takeLiquidity(uint256 tLiquidity) private {
1028         uint256 currentRate =  _getRate();
1029         uint256 rLiquidity = tLiquidity.mul(currentRate);
1030         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1031         if(_isExcluded[address(this)])
1032             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1033     }
1034     
1035     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1036         return _amount.mul(_taxFee).div(
1037             10**2
1038         );
1039     }
1040 
1041     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1042         return _amount.mul(_liquidityFee).div(
1043             10**2
1044         );
1045     }
1046     
1047     function removeAllFee() private {
1048         if(_taxFee == 0 && _liquidityFee == 0) return;
1049         
1050         _previousTaxFee = _taxFee;
1051         _previousLiquidityFee = _liquidityFee;
1052         
1053         _taxFee = 0;
1054         _liquidityFee = 0;
1055     }
1056     
1057     function restoreAllFee() private {
1058         _taxFee = _previousTaxFee;
1059         _liquidityFee = _previousLiquidityFee;
1060     }
1061     
1062     function isExcludedFromFee(address account) public view returns(bool) {
1063         return _isExcludedFromFee[account];
1064     }
1065 
1066     function _approve(address owner, address spender, uint256 amount) private {
1067         require(owner != address(0), "ERC20: approve from the zero address");
1068         require(spender != address(0), "ERC20: approve to the zero address");
1069 
1070         _allowances[owner][spender] = amount;
1071         emit Approval(owner, spender, amount);
1072     }
1073 
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 amount
1078     ) private {
1079         require(from != address(0), "ERC20: transfer from the zero address");
1080         require(to != address(0), "ERC20: transfer to the zero address");
1081         require(amount > 0, "Transfer amount must be greater than zero");
1082         if(from != owner() && to != owner())
1083             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1084 
1085         // is the token balance of this contract address over the min number of
1086         // tokens that we need to initiate a swap + liquidity lock?
1087         // also, don't get caught in a circular liquidity event.
1088         // also, don't swap & liquify if sender is uniswap pair.
1089         uint256 contractTokenBalance = balanceOf(address(this));
1090         
1091         if(contractTokenBalance >= _maxTxAmount)
1092         {
1093             contractTokenBalance = _maxTxAmount;
1094         }
1095         
1096         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1097         if (
1098             overMinTokenBalance &&
1099             !inSwapAndLiquify &&
1100             from != uniswapV2Pair &&
1101             swapAndLiquifyEnabled
1102         ) {
1103             contractTokenBalance = numTokensSellToAddToLiquidity;
1104             //add liquidity
1105             swapAndLiquify(contractTokenBalance);
1106         }
1107         
1108         //indicates if fee should be deducted from transfer
1109         bool takeFee = true;
1110         
1111         //if any account belongs to _isExcludedFromFee account then remove the fee
1112         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1113             takeFee = false;
1114         }
1115 
1116         if (takeFee) {
1117             if (to != uniswapV2Pair) {
1118                 require(
1119                     amount + balanceOf(to) <= _maxWalletSize,
1120                     "Recipient exceeds max wallet size."
1121                 );
1122             }
1123         }
1124         
1125         
1126         //transfer amount, it will take tax, burn, liquidity fee
1127         _tokenTransfer(from,to,amount,takeFee);
1128     }
1129 
1130     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1131         // split the contract balance into halves
1132         // add the marketing wallet
1133         uint256 half = contractTokenBalance.div(2);
1134         uint256 otherHalf = contractTokenBalance.sub(half);
1135 
1136         // capture the contract's current ETH balance.
1137         // this is so that we can capture exactly the amount of ETH that the
1138         // swap creates, and not make the liquidity event include any ETH that
1139         // has been manually sent to the contract
1140         uint256 initialBalance = address(this).balance;
1141 
1142         // swap tokens for ETH
1143         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1144 
1145         // how much ETH did we just swap into?
1146         uint256 newBalance = address(this).balance.sub(initialBalance);
1147         uint256 marketingshare = newBalance.mul(80).div(100);
1148         payable(taxWallet).transfer(marketingshare);
1149         newBalance -= marketingshare;
1150         // add liquidity to uniswap
1151         addLiquidity(otherHalf, newBalance);
1152         
1153         emit SwapAndLiquify(half, newBalance, otherHalf);
1154     }
1155 
1156     function swapTokensForEth(uint256 tokenAmount) private {
1157         // generate the uniswap pair path of token -> weth
1158         address[] memory path = new address[](2);
1159         path[0] = address(this);
1160         path[1] = uniswapV2Router.WETH();
1161 
1162         _approve(address(this), address(uniswapV2Router), tokenAmount);
1163 
1164         // make the swap
1165         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1166             tokenAmount,
1167             0, // accept any amount of ETH
1168             path,
1169             address(this),
1170             block.timestamp
1171         );
1172     }
1173 
1174     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1175         // approve token transfer to cover all possible scenarios
1176         _approve(address(this), address(uniswapV2Router), tokenAmount);
1177 
1178         // add the liquidity
1179         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1180             address(this),
1181             tokenAmount,
1182             0, // slippage is unavoidable
1183             0, // slippage is unavoidable
1184             owner(),
1185             block.timestamp
1186         );
1187     }
1188 
1189     //this method is responsible for taking all fee, if takeFee is true
1190     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1191         if(!canTrade){
1192             require(sender == owner()); // only owner allowed to trade or add liquidity
1193         }
1194         
1195         if(botWallets[sender] || botWallets[recipient]){
1196             require(botscantrade, "bots arent allowed to trade");
1197         }
1198         
1199         if(!takeFee)
1200             removeAllFee();
1201         
1202         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1203             _transferFromExcluded(sender, recipient, amount);
1204         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1205             _transferToExcluded(sender, recipient, amount);
1206         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1207             _transferStandard(sender, recipient, amount);
1208         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1209             _transferBothExcluded(sender, recipient, amount);
1210         } else {
1211             _transferStandard(sender, recipient, amount);
1212         }
1213         
1214         if(!takeFee)
1215             restoreAllFee();
1216     }
1217 
1218     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1219         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1220         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1221         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1222         _takeLiquidity(tLiquidity);
1223         _reflectFee(rFee, tFee);
1224         emit Transfer(sender, recipient, tTransferAmount);
1225     }
1226 
1227     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1228         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1229         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1230         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1231         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1232         _takeLiquidity(tLiquidity);
1233         _reflectFee(rFee, tFee);
1234         emit Transfer(sender, recipient, tTransferAmount);
1235     }
1236 
1237     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1238         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1239         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1240         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1241         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1242         _takeLiquidity(tLiquidity);
1243         _reflectFee(rFee, tFee);
1244         emit Transfer(sender, recipient, tTransferAmount);
1245     }
1246 
1247 }