1 /**
2 Community Token - brought to you by MSN dev.
3 
4 
5 🔥Supply : 100000000
6 
7 🔥Tax : 2% ( 1:1 Liquidity and growth)
8 
9 
10 MSN reached ath of 12 million marketcap.
11 It was all community effort right from the start.
12 Everything is possible if.
13 
14 Dev did his part from sidelines and we will do it again.
15 Trust the process.
16 
17 No official socials/website/twitter.
18 Community owned.
19 
20 */
21 
22 pragma solidity ^0.8.9;
23 // SPDX-License-Identifier: Unlicensed
24 interface IERC20 {
25 
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108  
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, "SafeMath: subtraction overflow");
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the multiplication of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `*` operator.
163      *
164      * Requirements:
165      *
166      * - Multiplication cannot overflow.
167      */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts on
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
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         return div(a, b, "SafeMath: division by zero");
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         uint256 c = a / b;
213         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return mod(a, b, "SafeMath: modulo by zero");
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts with custom message when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b != 0, errorMessage);
248         return a % b;
249     }
250 }
251 
252 abstract contract Context {
253     //function _msgSender() internal view virtual returns (address payable) {
254     function _msgSender() internal view virtual returns (address) {
255         return msg.sender;
256     }
257 
258     function _msgData() internal view virtual returns (bytes memory) {
259         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
260         return msg.data;
261     }
262 }
263 
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != accountHash && codehash != 0x0);
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain`call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340       return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
350         return _functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
370      * with `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         return _functionCallWithValue(target, data, value, errorMessage);
377     }
378 
379     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
380         require(isContract(target), "Address: call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 // solhint-disable-next-line no-inline-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 /**
404  * @dev Contract module which provides a basic access control mechanism, where
405  * there is an account (an owner) that can be granted exclusive access to
406  * specific functions.
407  *
408  * By default, the owner account will be the one that deploys the contract. This
409  * can later be changed with {transferOwnership}.
410  *
411  * This module is used through inheritance. It will make available the modifier
412  * `onlyOwner`, which can be applied to your functions to restrict their use to
413  * the owner.
414  */
415 contract Ownable is Context {
416     address private _owner;
417     address private _previousOwner;
418     uint256 private _lockTime;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor () {
426         address msgSender = _msgSender();
427         _owner = msgSender;
428         emit OwnershipTransferred(address(0), msgSender);
429     }
430 
431     /**
432      * @dev Returns the address of the current owner.
433      */
434     function owner() public view returns (address) {
435         return _owner;
436     }
437 
438     /**
439      * @dev Throws if called by any account other than the owner.
440      */
441     modifier onlyOwner() {
442         require(_owner == _msgSender(), "Ownable: caller is not the owner");
443         _;
444     }
445 
446      /**
447      * @dev Leaves the contract without owner. It will not be possible to call
448      * `onlyOwner` functions anymore. Can only be called by the current owner.
449      *
450      * NOTE: Renouncing ownership will leave the contract without an owner,
451      * thereby removing any functionality that is only available to the owner.
452      */
453     function renounceOwnership() public virtual onlyOwner {
454         emit OwnershipTransferred(_owner, address(0));
455         _owner = address(0);
456     }
457 
458     /**
459      * @dev Transfers ownership of the contract to a new account (`newOwner`).
460      * Can only be called by the current owner.
461      */
462     function transferOwnership(address newOwner) public virtual onlyOwner {
463         require(newOwner != address(0), "Ownable: new owner is the zero address");
464         emit OwnershipTransferred(_owner, newOwner);
465         _owner = newOwner;
466     }
467 
468     function geUnlockTime() public view returns (uint256) {
469         return _lockTime;
470     }
471 
472     //Locks the contract for owner for the amount of time provided
473     function lock(uint256 time) public virtual onlyOwner {
474         _previousOwner = _owner;
475         _owner = address(0);
476         _lockTime = block.timestamp + time;
477         emit OwnershipTransferred(_owner, address(0));
478     }
479     
480     //Unlocks the contract for owner when _lockTime is exceeds
481     function unlock() public virtual {
482         require(_previousOwner == msg.sender, "You don't have permission to unlock");
483         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
484         emit OwnershipTransferred(_owner, _previousOwner);
485         _owner = _previousOwner;
486     }
487 }
488 
489 
490 interface IUniswapV2Factory {
491     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
492 
493     function feeTo() external view returns (address);
494     function feeToSetter() external view returns (address);
495 
496     function getPair(address tokenA, address tokenB) external view returns (address pair);
497     function allPairs(uint) external view returns (address pair);
498     function allPairsLength() external view returns (uint);
499 
500     function createPair(address tokenA, address tokenB) external returns (address pair);
501 
502     function setFeeTo(address) external;
503     function setFeeToSetter(address) external;
504 }
505 
506 
507 
508 interface IUniswapV2Pair {
509     event Approval(address indexed owner, address indexed spender, uint value);
510     event Transfer(address indexed from, address indexed to, uint value);
511 
512     function name() external pure returns (string memory);
513     function symbol() external pure returns (string memory);
514     function decimals() external pure returns (uint8);
515     function totalSupply() external view returns (uint);
516     function balanceOf(address owner) external view returns (uint);
517     function allowance(address owner, address spender) external view returns (uint);
518 
519     function approve(address spender, uint value) external returns (bool);
520     function transfer(address to, uint value) external returns (bool);
521     function transferFrom(address from, address to, uint value) external returns (bool);
522 
523     function DOMAIN_SEPARATOR() external view returns (bytes32);
524     function PERMIT_TYPEHASH() external pure returns (bytes32);
525     function nonces(address owner) external view returns (uint);
526 
527     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
528 
529     event Mint(address indexed sender, uint amount0, uint amount1);
530     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
531     event Swap(
532         address indexed sender,
533         uint amount0In,
534         uint amount1In,
535         uint amount0Out,
536         uint amount1Out,
537         address indexed to
538     );
539     event Sync(uint112 reserve0, uint112 reserve1);
540 
541     function MINIMUM_LIQUIDITY() external pure returns (uint);
542     function factory() external view returns (address);
543     function token0() external view returns (address);
544     function token1() external view returns (address);
545     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
546     function price0CumulativeLast() external view returns (uint);
547     function price1CumulativeLast() external view returns (uint);
548     function kLast() external view returns (uint);
549 
550     function mint(address to) external returns (uint liquidity);
551     function burn(address to) external returns (uint amount0, uint amount1);
552     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
553     function skim(address to) external;
554     function sync() external;
555 
556     function initialize(address, address) external;
557 }
558 
559 
560 interface IUniswapV2Router01 {
561     function factory() external pure returns (address);
562     function WETH() external pure returns (address);
563 
564     function addLiquidity(
565         address tokenA,
566         address tokenB,
567         uint amountADesired,
568         uint amountBDesired,
569         uint amountAMin,
570         uint amountBMin,
571         address to,
572         uint deadline
573     ) external returns (uint amountA, uint amountB, uint liquidity);
574     function addLiquidityETH(
575         address token,
576         uint amountTokenDesired,
577         uint amountTokenMin,
578         uint amountETHMin,
579         address to,
580         uint deadline
581     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
582     function removeLiquidity(
583         address tokenA,
584         address tokenB,
585         uint liquidity,
586         uint amountAMin,
587         uint amountBMin,
588         address to,
589         uint deadline
590     ) external returns (uint amountA, uint amountB);
591     function removeLiquidityETH(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline
598     ) external returns (uint amountToken, uint amountETH);
599     function removeLiquidityWithPermit(
600         address tokenA,
601         address tokenB,
602         uint liquidity,
603         uint amountAMin,
604         uint amountBMin,
605         address to,
606         uint deadline,
607         bool approveMax, uint8 v, bytes32 r, bytes32 s
608     ) external returns (uint amountA, uint amountB);
609     function removeLiquidityETHWithPermit(
610         address token,
611         uint liquidity,
612         uint amountTokenMin,
613         uint amountETHMin,
614         address to,
615         uint deadline,
616         bool approveMax, uint8 v, bytes32 r, bytes32 s
617     ) external returns (uint amountToken, uint amountETH);
618     function swapExactTokensForTokens(
619         uint amountIn,
620         uint amountOutMin,
621         address[] calldata path,
622         address to,
623         uint deadline
624     ) external returns (uint[] memory amounts);
625     function swapTokensForExactTokens(
626         uint amountOut,
627         uint amountInMax,
628         address[] calldata path,
629         address to,
630         uint deadline
631     ) external returns (uint[] memory amounts);
632     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
637         external
638         returns (uint[] memory amounts);
639     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
640         external
641         returns (uint[] memory amounts);
642     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
643         external
644         payable
645         returns (uint[] memory amounts);
646 
647     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
648     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
649     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
650     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
651     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
652 }
653 
654 
655 
656 
657 interface IUniswapV2Router02 is IUniswapV2Router01 {
658     function removeLiquidityETHSupportingFeeOnTransferTokens(
659         address token,
660         uint liquidity,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline
665     ) external returns (uint amountETH);
666     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
667         address token,
668         uint liquidity,
669         uint amountTokenMin,
670         uint amountETHMin,
671         address to,
672         uint deadline,
673         bool approveMax, uint8 v, bytes32 r, bytes32 s
674     ) external returns (uint amountETH);
675 
676     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
677         uint amountIn,
678         uint amountOutMin,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external;
683     function swapExactETHForTokensSupportingFeeOnTransferTokens(
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external payable;
689     function swapExactTokensForETHSupportingFeeOnTransferTokens(
690         uint amountIn,
691         uint amountOutMin,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external;
696 }
697 
698 interface IAirdrop {
699     function airdrop(address recipient, uint256 amount) external;
700 }
701 
702 contract COMMUNITYTOKEN is Context, IERC20, Ownable {
703     using SafeMath for uint256;
704     using Address for address;
705 
706     mapping (address => uint256) private _rOwned;
707     mapping (address => uint256) private _tOwned;
708     mapping (address => mapping (address => uint256)) private _allowances;
709 
710     mapping (address => bool) private _isExcludedFromFee;
711 
712     mapping (address => bool) private _isExcluded;
713     address[] private _excluded;
714     
715     mapping (address => bool) private botWallets;
716     bool botscantrade = false;
717     
718     bool public canTrade = false;
719    
720     uint256 private constant MAX = ~uint256(0);
721     uint256 private _tTotal = 100000000 * 10**9;
722     uint256 private _rTotal = (MAX - (MAX % _tTotal));
723     uint256 private _tFeeTotal;
724     address public marketingWallet;
725 
726     string private _name = "COMMUNITY TOKEN";
727     string private _symbol = "CMT";
728     uint8 private _decimals = 9;
729     
730     uint256 public _taxFee = 0;
731     uint256 private _previousTaxFee = _taxFee;
732 
733     uint256 public marketingFeePercent = 50;
734     
735     uint256 public _liquidityFee = 2;
736     uint256 private _previousLiquidityFee = _liquidityFee;
737 
738     IUniswapV2Router02 public immutable uniswapV2Router;
739     address public immutable uniswapV2Pair;
740     
741     bool inSwapAndLiquify;
742     bool public swapAndLiquifyEnabled = true;
743     
744     uint256 public _maxTxAmount = 500000 * 10**9;
745     uint256 public numTokensSellToAddToLiquidity = 500000 * 10**9;
746     uint256 public _maxWalletSize = 3000000 * 10**9;
747     
748     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
749     event SwapAndLiquifyEnabledUpdated(bool enabled);
750     event SwapAndLiquify(
751         uint256 tokensSwapped,
752         uint256 ethReceived,
753         uint256 tokensIntoLiqudity
754     );
755     
756     modifier lockTheSwap {
757         inSwapAndLiquify = true;
758         _;
759         inSwapAndLiquify = false;
760     }
761     
762     constructor () {
763         _rOwned[_msgSender()] = _rTotal;
764         
765         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
766          // Create a uniswap pair for this new token
767         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
768             .createPair(address(this), _uniswapV2Router.WETH());
769 
770         // set the rest of the contract variables
771         uniswapV2Router = _uniswapV2Router;
772         
773         //exclude owner and this contract from fee
774         _isExcludedFromFee[owner()] = true;
775         _isExcludedFromFee[address(this)] = true;
776         
777         emit Transfer(address(0), _msgSender(), _tTotal);
778     }
779 
780     function name() public view returns (string memory) {
781         return _name;
782     }
783 
784     function symbol() public view returns (string memory) {
785         return _symbol;
786     }
787 
788     function decimals() public view returns (uint8) {
789         return _decimals;
790     }
791 
792     function totalSupply() public view override returns (uint256) {
793         return _tTotal;
794     }
795 
796     function balanceOf(address account) public view override returns (uint256) {
797         if (_isExcluded[account]) return _tOwned[account];
798         return tokenFromReflection(_rOwned[account]);
799     }
800 
801     function transfer(address recipient, uint256 amount) public override returns (bool) {
802         _transfer(_msgSender(), recipient, amount);
803         return true;
804     }
805 
806     function allowance(address owner, address spender) public view override returns (uint256) {
807         return _allowances[owner][spender];
808     }
809 
810     function approve(address spender, uint256 amount) public override returns (bool) {
811         _approve(_msgSender(), spender, amount);
812         return true;
813     }
814 
815     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
816         _transfer(sender, recipient, amount);
817         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
818         return true;
819     }
820 
821     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
822         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
823         return true;
824     }
825 
826     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
827         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
828         return true;
829     }
830 
831     function isExcludedFromReward(address account) public view returns (bool) {
832         return _isExcluded[account];
833     }
834 
835     function totalFees() public view returns (uint256) {
836         return _tFeeTotal;
837     }
838     
839     function airdrop(address recipient, uint256 amount) external onlyOwner() {
840         removeAllFee();
841         _transfer(_msgSender(), recipient, amount * 10**9);
842         restoreAllFee();
843     }
844     
845     function airdropInternal(address recipient, uint256 amount) internal {
846         removeAllFee();
847         _transfer(_msgSender(), recipient, amount);
848         restoreAllFee();
849     }
850     
851     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
852         uint256 iterator = 0;
853         require(newholders.length == amounts.length, "must be the same length");
854         while(iterator < newholders.length){
855             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
856             iterator += 1;
857         }
858     }
859 
860     function deliver(uint256 tAmount) public {
861         address sender = _msgSender();
862         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
863         (uint256 rAmount,,,,,) = _getValues(tAmount);
864         _rOwned[sender] = _rOwned[sender].sub(rAmount);
865         _rTotal = _rTotal.sub(rAmount);
866         _tFeeTotal = _tFeeTotal.add(tAmount);
867     }
868 
869     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
870         require(tAmount <= _tTotal, "Amount must be less than supply");
871         if (!deductTransferFee) {
872             (uint256 rAmount,,,,,) = _getValues(tAmount);
873             return rAmount;
874         } else {
875             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
876             return rTransferAmount;
877         }
878     }
879 
880     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
881         require(rAmount <= _rTotal, "Amount must be less than total reflections");
882         uint256 currentRate =  _getRate();
883         return rAmount.div(currentRate);
884     }
885 
886     function excludeFromReward(address account) public onlyOwner() {
887         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
888         require(!_isExcluded[account], "Account is already excluded");
889         if(_rOwned[account] > 0) {
890             _tOwned[account] = tokenFromReflection(_rOwned[account]);
891         }
892         _isExcluded[account] = true;
893         _excluded.push(account);
894     }
895 
896     function includeInReward(address account) external onlyOwner() {
897         require(_isExcluded[account], "Account is already excluded");
898         for (uint256 i = 0; i < _excluded.length; i++) {
899             if (_excluded[i] == account) {
900                 _excluded[i] = _excluded[_excluded.length - 1];
901                 _tOwned[account] = 0;
902                 _isExcluded[account] = false;
903                 _excluded.pop();
904                 break;
905             }
906         }
907     }
908         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
909         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
910         _tOwned[sender] = _tOwned[sender].sub(tAmount);
911         _rOwned[sender] = _rOwned[sender].sub(rAmount);
912         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
913         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
914         _takeLiquidity(tLiquidity);
915         _reflectFee(rFee, tFee);
916         emit Transfer(sender, recipient, tTransferAmount);
917     }
918     
919     function excludeFromFee(address account) public onlyOwner {
920         _isExcludedFromFee[account] = true;
921     }
922     
923     function includeInFee(address account) public onlyOwner {
924         _isExcludedFromFee[account] = false;
925     }
926     function setMarketingFeePercent(uint256 fee) public onlyOwner {
927         marketingFeePercent = fee;
928     }
929 
930     function setMarketingWallet(address walletAddress) public onlyOwner {
931         marketingWallet = walletAddress;
932     }
933     
934     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
935         require(taxFee < 10, "Tax fee cannot be more than 10%");
936         _taxFee = taxFee;
937     }
938     
939     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
940         _liquidityFee = liquidityFee;
941     }
942 
943     function _setMaxWalletSizePercent(uint256 maxWalletSize)
944         external
945         onlyOwner
946     {
947         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
948     }
949    
950     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
951         require(maxTxAmount > 200000, "Max Tx Amount cannot be less than 69 Million");
952         _maxTxAmount = maxTxAmount * 10**9;
953     }
954     
955     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
956         require(SwapThresholdAmount > 200000, "Swap Threshold Amount cannot be less than 69 Million");
957         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
958     }
959     
960     function claimTokens () public onlyOwner {
961         // make sure we capture all BNB that may or may not be sent to this contract
962         payable(marketingWallet).transfer(address(this).balance);
963     }
964     
965     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
966         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
967     }
968     
969     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
970         walletaddress.transfer(address(this).balance);
971     }
972     
973     function addBotWallet(address botwallet) external onlyOwner() {
974         botWallets[botwallet] = true;
975     }
976     
977     function removeBotWallet(address botwallet) external onlyOwner() {
978         botWallets[botwallet] = false;
979     }
980     
981     function getBotWalletStatus(address botwallet) public view returns (bool) {
982         return botWallets[botwallet];
983     }
984     
985     function allowtrading()external onlyOwner() {
986         canTrade = true;
987     }
988 
989     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
990         swapAndLiquifyEnabled = _enabled;
991         emit SwapAndLiquifyEnabledUpdated(_enabled);
992     }
993     
994      //to recieve ETH from uniswapV2Router when swaping
995     receive() external payable {}
996 
997     function _reflectFee(uint256 rFee, uint256 tFee) private {
998         _rTotal = _rTotal.sub(rFee);
999         _tFeeTotal = _tFeeTotal.add(tFee);
1000     }
1001 
1002     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1003         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1004         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1005         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1006     }
1007 
1008     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1009         uint256 tFee = calculateTaxFee(tAmount);
1010         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1011         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1012         return (tTransferAmount, tFee, tLiquidity);
1013     }
1014 
1015     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1016         uint256 rAmount = tAmount.mul(currentRate);
1017         uint256 rFee = tFee.mul(currentRate);
1018         uint256 rLiquidity = tLiquidity.mul(currentRate);
1019         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1020         return (rAmount, rTransferAmount, rFee);
1021     }
1022 
1023     function _getRate() private view returns(uint256) {
1024         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1025         return rSupply.div(tSupply);
1026     }
1027 
1028     function _getCurrentSupply() private view returns(uint256, uint256) {
1029         uint256 rSupply = _rTotal;
1030         uint256 tSupply = _tTotal;      
1031         for (uint256 i = 0; i < _excluded.length; i++) {
1032             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1033             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1034             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1035         }
1036         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1037         return (rSupply, tSupply);
1038     }
1039     
1040     function _takeLiquidity(uint256 tLiquidity) private {
1041         uint256 currentRate =  _getRate();
1042         uint256 rLiquidity = tLiquidity.mul(currentRate);
1043         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1044         if(_isExcluded[address(this)])
1045             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1046     }
1047     
1048     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1049         return _amount.mul(_taxFee).div(
1050             10**2
1051         );
1052     }
1053 
1054     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1055         return _amount.mul(_liquidityFee).div(
1056             10**2
1057         );
1058     }
1059     
1060     function removeAllFee() private {
1061         if(_taxFee == 0 && _liquidityFee == 0) return;
1062         
1063         _previousTaxFee = _taxFee;
1064         _previousLiquidityFee = _liquidityFee;
1065         
1066         _taxFee = 0;
1067         _liquidityFee = 0;
1068     }
1069     
1070     function restoreAllFee() private {
1071         _taxFee = _previousTaxFee;
1072         _liquidityFee = _previousLiquidityFee;
1073     }
1074     
1075     function isExcludedFromFee(address account) public view returns(bool) {
1076         return _isExcludedFromFee[account];
1077     }
1078 
1079     function _approve(address owner, address spender, uint256 amount) private {
1080         require(owner != address(0), "ERC20: approve from the zero address");
1081         require(spender != address(0), "ERC20: approve to the zero address");
1082 
1083         _allowances[owner][spender] = amount;
1084         emit Approval(owner, spender, amount);
1085     }
1086 
1087     function _transfer(
1088         address from,
1089         address to,
1090         uint256 amount
1091     ) private {
1092         require(from != address(0), "ERC20: transfer from the zero address");
1093         require(to != address(0), "ERC20: transfer to the zero address");
1094         require(amount > 0, "Transfer amount must be greater than zero");
1095         if(from != owner() && to != owner())
1096             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1097 
1098         // is the token balance of this contract address over the min number of
1099         // tokens that we need to initiate a swap + liquidity lock?
1100         // also, don't get caught in a circular liquidity event.
1101         // also, don't swap & liquify if sender is uniswap pair.
1102         uint256 contractTokenBalance = balanceOf(address(this));
1103         
1104         if(contractTokenBalance >= _maxTxAmount)
1105         {
1106             contractTokenBalance = _maxTxAmount;
1107         }
1108         
1109         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1110         if (
1111             overMinTokenBalance &&
1112             !inSwapAndLiquify &&
1113             from != uniswapV2Pair &&
1114             swapAndLiquifyEnabled
1115         ) {
1116             contractTokenBalance = numTokensSellToAddToLiquidity;
1117             //add liquidity
1118             swapAndLiquify(contractTokenBalance);
1119         }
1120         
1121         //indicates if fee should be deducted from transfer
1122         bool takeFee = true;
1123         
1124         //if any account belongs to _isExcludedFromFee account then remove the fee
1125         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1126             takeFee = false;
1127         }
1128 
1129         if (takeFee) {
1130             if (to != uniswapV2Pair) {
1131                 require(
1132                     amount + balanceOf(to) <= _maxWalletSize,
1133                     "Recipient exceeds max wallet size."
1134                 );
1135             }
1136         }
1137         
1138         
1139         //transfer amount, it will take tax, burn, liquidity fee
1140         _tokenTransfer(from,to,amount,takeFee);
1141     }
1142 
1143     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1144         // split the contract balance into halves
1145         // add the marketing wallet
1146         uint256 half = contractTokenBalance.div(2);
1147         uint256 otherHalf = contractTokenBalance.sub(half);
1148 
1149         // capture the contract's current ETH balance.
1150         // this is so that we can capture exactly the amount of ETH that the
1151         // swap creates, and not make the liquidity event include any ETH that
1152         // has been manually sent to the contract
1153         uint256 initialBalance = address(this).balance;
1154 
1155         // swap tokens for ETH
1156         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1157 
1158         // how much ETH did we just swap into?
1159         uint256 newBalance = address(this).balance.sub(initialBalance);
1160         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1161         payable(marketingWallet).transfer(marketingshare);
1162         newBalance -= marketingshare;
1163         // add liquidity to uniswap
1164         addLiquidity(otherHalf, newBalance);
1165         
1166         emit SwapAndLiquify(half, newBalance, otherHalf);
1167     }
1168 
1169     function swapTokensForEth(uint256 tokenAmount) private {
1170         // generate the uniswap pair path of token -> weth
1171         address[] memory path = new address[](2);
1172         path[0] = address(this);
1173         path[1] = uniswapV2Router.WETH();
1174 
1175         _approve(address(this), address(uniswapV2Router), tokenAmount);
1176 
1177         // make the swap
1178         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1179             tokenAmount,
1180             0, // accept any amount of ETH
1181             path,
1182             address(this),
1183             block.timestamp
1184         );
1185     }
1186 
1187     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1188         // approve token transfer to cover all possible scenarios
1189         _approve(address(this), address(uniswapV2Router), tokenAmount);
1190 
1191         // add the liquidity
1192         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1193             address(this),
1194             tokenAmount,
1195             0, // slippage is unavoidable
1196             0, // slippage is unavoidable
1197             owner(),
1198             block.timestamp
1199         );
1200     }
1201 
1202     //this method is responsible for taking all fee, if takeFee is true
1203     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1204         if(!canTrade){
1205             require(sender == owner()); // only owner allowed to trade or add liquidity
1206         }
1207         
1208         if(botWallets[sender] || botWallets[recipient]){
1209             require(botscantrade, "bots arent allowed to trade");
1210         }
1211         
1212         if(!takeFee)
1213             removeAllFee();
1214         
1215         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1216             _transferFromExcluded(sender, recipient, amount);
1217         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1218             _transferToExcluded(sender, recipient, amount);
1219         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1220             _transferStandard(sender, recipient, amount);
1221         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1222             _transferBothExcluded(sender, recipient, amount);
1223         } else {
1224             _transferStandard(sender, recipient, amount);
1225         }
1226         
1227         if(!takeFee)
1228             restoreAllFee();
1229     }
1230 
1231     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1232         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1233         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1234         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1235         _takeLiquidity(tLiquidity);
1236         _reflectFee(rFee, tFee);
1237         emit Transfer(sender, recipient, tTransferAmount);
1238     }
1239 
1240     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1241         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1242         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1243         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1244         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1245         _takeLiquidity(tLiquidity);
1246         _reflectFee(rFee, tFee);
1247         emit Transfer(sender, recipient, tTransferAmount);
1248     }
1249 
1250     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1251         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1252         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1253         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1254         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1255         _takeLiquidity(tLiquidity);
1256         _reflectFee(rFee, tFee);
1257         emit Transfer(sender, recipient, tTransferAmount);
1258     }
1259 
1260 }