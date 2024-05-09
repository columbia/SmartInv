1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5    _____   ____ _____________    _____  ____  ___
6   /  _  \ |    |   \______   \  /  _  \ \   \/  /
7  /  /_\  \|    |   /|       _/ /  /_\  \ \     / 
8 /    |    \    |  / |    |   \/    |    \/     \ 
9 \____|__  /______/  |____|_  /\____|__  /___/\  \
10         \/                 \/         \/      \_/
11         
12         inspired by RFI, REBASE and many others!
13 
14 */
15 
16 pragma solidity ^0.6.12;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119  
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      *
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
286         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
287         // for accounts without code, i.e. `keccak256('')`
288         bytes32 codehash;
289         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { codehash := extcodehash(account) }
292         return (codehash != accountHash && codehash != 0x0);
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain`call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338       return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
348         return _functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         return _functionCallWithValue(target, data, value, errorMessage);
375     }
376 
377     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
378         require(isContract(target), "Address: call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 /**
402  * @dev Contract module which provides a basic access control mechanism, where
403  * there is an account (an owner) that can be granted exclusive access to
404  * specific functions.
405  *
406  * By default, the owner account will be the one that deploys the contract. This
407  * can later be changed with {transferOwnership}.
408  *
409  * This module is used through inheritance. It will make available the modifier
410  * `onlyOwner`, which can be applied to your functions to restrict their use to
411  * the owner.
412  */
413 contract Ownable is Context {
414     address private _owner;
415     address private _previousOwner;
416     uint256 private _lockTime;
417 
418     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
419 
420     /**
421      * @dev Initializes the contract setting the deployer as the initial owner.
422      */
423     constructor () internal {
424         address msgSender = _msgSender();
425         _owner = msgSender;
426         emit OwnershipTransferred(address(0), msgSender);
427     }
428 
429     /**
430      * @dev Returns the address of the current owner.
431      */
432     function owner() public view returns (address) {
433         return _owner;
434     }
435 
436     /**
437      * @dev Throws if called by any account other than the owner.
438      */
439     modifier onlyOwner() {
440         require(_owner == _msgSender(), "Ownable: caller is not the owner");
441         _;
442     }
443 
444      /**
445      * @dev Leaves the contract without owner. It will not be possible to call
446      * `onlyOwner` functions anymore. Can only be called by the current owner.
447      *
448      * NOTE: Renouncing ownership will leave the contract without an owner,
449      * thereby removing any functionality that is only available to the owner.
450      */
451     function renounceOwnership() public virtual onlyOwner {
452         emit OwnershipTransferred(_owner, address(0));
453         _owner = address(0);
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Can only be called by the current owner.
459      */
460     function transferOwnership(address newOwner) public virtual onlyOwner {
461         require(newOwner != address(0), "Ownable: new owner is the zero address");
462         emit OwnershipTransferred(_owner, newOwner);
463         _owner = newOwner;
464     }
465 
466     function geUnlockTime() public view returns (uint256) {
467         return _lockTime;
468     }
469 
470     //Locks the contract for owner for the amount of time provided
471     function lock(uint256 time) public virtual onlyOwner {
472         _previousOwner = _owner;
473         _owner = address(0);
474         _lockTime = now + time;
475         emit OwnershipTransferred(_owner, address(0));
476     }
477     
478     //Unlocks the contract for owner when _lockTime is exceeds
479     function unlock() public virtual {
480         require(_previousOwner == msg.sender, "You don't have permission to unlock");
481         require(now > _lockTime , "Contract is locked until 7 days");
482         emit OwnershipTransferred(_owner, _previousOwner);
483         _owner = _previousOwner;
484     }
485 }
486 
487 // pragma solidity >=0.5.0;
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
506 // pragma solidity >=0.5.0;
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
559 // pragma solidity >=0.6.2;
560 
561 interface IUniswapV2Router01 {
562     function factory() external pure returns (address);
563     function WETH() external pure returns (address);
564 
565     function addLiquidity(
566         address tokenA,
567         address tokenB,
568         uint amountADesired,
569         uint amountBDesired,
570         uint amountAMin,
571         uint amountBMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountA, uint amountB, uint liquidity);
575     function addLiquidityETH(
576         address token,
577         uint amountTokenDesired,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline
582     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
583     function removeLiquidity(
584         address tokenA,
585         address tokenB,
586         uint liquidity,
587         uint amountAMin,
588         uint amountBMin,
589         address to,
590         uint deadline
591     ) external returns (uint amountA, uint amountB);
592     function removeLiquidityETH(
593         address token,
594         uint liquidity,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline
599     ) external returns (uint amountToken, uint amountETH);
600     function removeLiquidityWithPermit(
601         address tokenA,
602         address tokenB,
603         uint liquidity,
604         uint amountAMin,
605         uint amountBMin,
606         address to,
607         uint deadline,
608         bool approveMax, uint8 v, bytes32 r, bytes32 s
609     ) external returns (uint amountA, uint amountB);
610     function removeLiquidityETHWithPermit(
611         address token,
612         uint liquidity,
613         uint amountTokenMin,
614         uint amountETHMin,
615         address to,
616         uint deadline,
617         bool approveMax, uint8 v, bytes32 r, bytes32 s
618     ) external returns (uint amountToken, uint amountETH);
619     function swapExactTokensForTokens(
620         uint amountIn,
621         uint amountOutMin,
622         address[] calldata path,
623         address to,
624         uint deadline
625     ) external returns (uint[] memory amounts);
626     function swapTokensForExactTokens(
627         uint amountOut,
628         uint amountInMax,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external returns (uint[] memory amounts);
633     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
634         external
635         payable
636         returns (uint[] memory amounts);
637     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
638         external
639         returns (uint[] memory amounts);
640     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
641         external
642         returns (uint[] memory amounts);
643     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
644         external
645         payable
646         returns (uint[] memory amounts);
647 
648     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
649     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
650     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
651     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
652     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
653 }
654 
655 
656 
657 // pragma solidity >=0.6.2;
658 
659 interface IUniswapV2Router02 is IUniswapV2Router01 {
660     function removeLiquidityETHSupportingFeeOnTransferTokens(
661         address token,
662         uint liquidity,
663         uint amountTokenMin,
664         uint amountETHMin,
665         address to,
666         uint deadline
667     ) external returns (uint amountETH);
668     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
669         address token,
670         uint liquidity,
671         uint amountTokenMin,
672         uint amountETHMin,
673         address to,
674         uint deadline,
675         bool approveMax, uint8 v, bytes32 r, bytes32 s
676     ) external returns (uint amountETH);
677 
678     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
679         uint amountIn,
680         uint amountOutMin,
681         address[] calldata path,
682         address to,
683         uint deadline
684     ) external;
685     function swapExactETHForTokensSupportingFeeOnTransferTokens(
686         uint amountOutMin,
687         address[] calldata path,
688         address to,
689         uint deadline
690     ) external payable;
691     function swapExactTokensForETHSupportingFeeOnTransferTokens(
692         uint amountIn,
693         uint amountOutMin,
694         address[] calldata path,
695         address to,
696         uint deadline
697     ) external;
698 }
699 
700 
701 contract AuraxNetwork is Context, IERC20, Ownable {
702     using SafeMath for uint256;
703     using Address for address;
704     
705     address public balancer = address(0);
706     
707     mapping (address => uint256) private _rOwned;
708     mapping (address => uint256) private _tOwned;
709     mapping (address => mapping (address => uint256)) private _allowances;
710 	mapping (address => bool) private whitelist;
711 
712     mapping (address => bool) private _isExcludedFromFee;
713 
714     mapping (address => bool) private _isExcluded;
715     address[] private _excluded;
716    
717     uint256 private constant MAX = ~uint256(0);
718     uint256 private _tTotal = 18500 ether;
719     uint256 private _rTotal = (MAX - (MAX % _tTotal));
720     uint256 private _tFeeTotal;
721 
722     string private _name = "Aurax.network";
723     string private _symbol = "AURAX";
724     uint8 private _decimals = 18;
725     
726     bool public beforeListing = true;
727     
728     uint256 public _taxFee = 4;
729     uint256 private _previousTaxFee = _taxFee;
730     
731     uint256 public _liquidityFee = 0;
732     uint256 private _previousLiquidityFee = _liquidityFee;
733     
734     //No limit
735     uint256 public _maxTxAmount = _tTotal;
736     
737     IUniswapV2Router02 public uniswapV2Router;
738     address public uniswapV2Pair;
739     
740     uint256 public numberOfBuysAfterListing;
741     bool public stopBots = true;
742     mapping(address => uint256) lastBuyers;
743     uint256 sellCooldown = 3 minutes;
744 
745     event Burn(address indexed burner, uint256 value);
746 
747     constructor () public {
748         _rOwned[_msgSender()] = _rTotal;
749         
750         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
751          // Create a uniswap pair for this new token
752         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
753             .createPair(address(this), _uniswapV2Router.WETH());
754 
755         // set the rest of the contract variables
756         uniswapV2Router = _uniswapV2Router;
757         
758         //exclude owner and this contract from fee
759         _isExcludedFromFee[owner()] = true;
760         _isExcludedFromFee[address(this)] = true;
761         
762         _excludeFromReward(address(this));
763         _excludeFromReward(uniswapV2Pair);
764         _excludeFromReward(owner());
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
827     function deliver(uint256 tAmount) public {
828         address sender = _msgSender();
829         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
830         (uint256 rAmount,,,,,) = _getValues(tAmount);
831         _rOwned[sender] = _rOwned[sender].sub(rAmount);
832         _rTotal = _rTotal.sub(rAmount);
833         _tFeeTotal = _tFeeTotal.add(tAmount);
834     }
835 
836     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
837         require(rAmount <= _rTotal, "Amount must be less than total reflections");
838         uint256 currentRate =  _getRate();
839         return rAmount.div(currentRate);
840     }
841 
842     
843     function excludeFromReward(address account) external onlyOwner() {
844         _excludeFromReward(account);
845     }
846     
847     function _excludeFromReward(address account) private {
848         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
849         require(!_isExcluded[account], "Account is already excluded");
850         if(_rOwned[account] > 0) {
851             _tOwned[account] = tokenFromReflection(_rOwned[account]);
852         }
853         _isExcluded[account] = true;
854         _excluded.push(account);
855     }
856 
857     function includeInReward(address account) external onlyOwner() {
858         _includeInReward(account);
859     }
860     
861     function _includeInReward(address account) private {
862         require(_isExcluded[account], "Account is already excluded");
863         for (uint256 i = 0; i < _excluded.length; i++) {
864             if (_excluded[i] == account) {
865                 _excluded[i] = _excluded[_excluded.length - 1];
866                 _tOwned[account] = 0;
867                 _isExcluded[account] = false;
868                 _excluded.pop();
869                 break;
870             }
871         }
872     }
873     
874     function multiWhitelistAdd(address[] memory addresses) external onlyOwner {
875     	for (uint256 i = 0; i < addresses.length; i++) {
876         	whitelist[addresses[i]] = true;
877     	}
878 	}
879 
880 	function multiWhitelistRemove(address[] memory addresses) external onlyOwner {
881     	for (uint256 i = 0; i < addresses.length; i++) {
882             whitelist[addresses[i]] = false;
883     	}
884 	}
885 
886 	function isInWhitelist(address a) internal view returns (bool) {
887     	return whitelist[a];
888 	}
889 	
890     function multiTransfer(address[] memory addresses, uint256 amount) public {
891     	for (uint256 i = 0; i < addresses.length; i++) {
892         	transfer(addresses[i], amount);
893     	}
894 	}
895 
896     function _approve(address owner, address spender, uint256 amount) private {
897         require(owner != address(0), "ERC20: approve from the zero address");
898         require(spender != address(0), "ERC20: approve to the zero address");
899 
900         _allowances[owner][spender] = amount;
901         emit Approval(owner, spender, amount);
902     }
903     
904      function isBuyTransaction(address sender, address recipient) public view returns(bool){
905         return sender == uniswapV2Pair && recipient != owner();
906     }
907     
908      function isSellTransaction(address sender, address recipient) public view returns(bool){
909         return recipient == uniswapV2Pair && sender != owner();
910     }
911     
912     function setStopBots(bool state) external onlyOwner{
913         stopBots = state;
914     }
915     
916     function setBeforeListing(bool state) external onlyOwner{
917         beforeListing = state;
918     }
919     
920     function _transfer(
921         address from,
922         address to,
923         uint256 amount
924     ) private {
925         require(from != address(0), "ERC20: transfer from the zero address");
926         require(to != address(0), "ERC20: transfer to the zero address");
927         require(amount > 0, "Transfer amount must be greater than zero");
928         if(from != owner() && to != owner()) {
929             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
930         }
931         
932         if (beforeListing && isInWhitelist(from)) {
933             revert();
934         }
935         
936        if(stopBots && numberOfBuysAfterListing <= 5) {
937             if (isBuyTransaction(from, to)){
938                 lastBuyers[to] = now;
939                 numberOfBuysAfterListing +=1;
940             }
941         }
942         
943         if(isSellTransaction(from, to) && lastBuyers[from] != 0 && lastBuyers[from] + sellCooldown >= now) {
944             revert("Trying to sell before cooldown passed");
945         }
946         
947         //indicates if fee should be deducted from transfer
948         bool takeFee = true;
949         
950         //if any account belongs to _isExcludedFromFee account then remove the fee
951         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
952             takeFee = false;
953         }
954         
955         //transfer amount, it will take tax, burn, liquidity fee
956         _tokenTransfer(from,to,amount,takeFee);
957         
958     }
959 
960     //this method is responsible for taking all fee, if takeFee is true
961     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
962         if(!takeFee)
963             removeAllFee();
964         
965         if (_isExcluded[sender] && !_isExcluded[recipient]) {
966             _transferFromExcluded(sender, recipient, amount);
967         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
968             _transferToExcluded(sender, recipient, amount);
969         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
970             _transferStandard(sender, recipient, amount);
971         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
972             _transferBothExcluded(sender, recipient, amount);
973         } else {
974             _transferStandard(sender, recipient, amount);
975         }
976         
977         if(!takeFee)
978             restoreAllFee();
979     }
980 
981     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
982         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
983         _rOwned[sender] = _rOwned[sender].sub(rAmount);
984         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
985         _takeLiquidity(tLiquidity);
986         _reflectFee(rFee, tFee);
987         emit Transfer(sender, recipient, tTransferAmount);
988     }
989 
990     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
991         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
992         _rOwned[sender] = _rOwned[sender].sub(rAmount);
993         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
994         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
995         _takeLiquidity(tLiquidity);
996         _reflectFee(rFee, tFee);
997         emit Transfer(sender, recipient, tTransferAmount);
998     }
999 
1000     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1001         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1002         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1003         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1004         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1005         _takeLiquidity(tLiquidity);
1006         _reflectFee(rFee, tFee);
1007         emit Transfer(sender, recipient, tTransferAmount);
1008     }
1009 
1010     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1011         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1012         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1013         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1014         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1015         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1016         _takeLiquidity(tLiquidity);
1017         _reflectFee(rFee, tFee);
1018         emit Transfer(sender, recipient, tTransferAmount);
1019     }
1020 
1021     function _reflectFee(uint256 rFee, uint256 tFee) private {
1022         _rTotal = _rTotal.sub(rFee);
1023         _tFeeTotal = _tFeeTotal.add(tFee);
1024     }
1025 
1026     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1027         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1028         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1029         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1030     }
1031 
1032     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1033         uint256 tFee = calculateTaxFee(tAmount);
1034         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1035         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1036         return (tTransferAmount, tFee, tLiquidity);
1037     }
1038 
1039     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1040         uint256 rAmount = tAmount.mul(currentRate);
1041         uint256 rFee = tFee.mul(currentRate);
1042         uint256 rLiquidity = tLiquidity.mul(currentRate);
1043         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1044         return (rAmount, rTransferAmount, rFee);
1045     }
1046 
1047     function _getRate() private view returns(uint256) {
1048         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1049         return rSupply.div(tSupply);
1050     }
1051 
1052     function _getCurrentSupply() private view returns(uint256, uint256) {
1053         uint256 rSupply = _rTotal;
1054         uint256 tSupply = _tTotal;      
1055         for (uint256 i = 0; i < _excluded.length; i++) {
1056             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1057             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1058             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1059         }
1060         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1061         return (rSupply, tSupply);
1062     }
1063     
1064     function setBalancer(address balancerAddr) external onlyOwner{
1065         balancer = balancerAddr;
1066     }
1067     
1068     function _takeLiquidity(uint256 tLiquidity) private {
1069         if (tLiquidity == 0|| balancer == address(0)) {
1070             return;
1071         }
1072         
1073         uint256 currentRate =  _getRate();
1074         uint256 rLiquidity = tLiquidity.mul(currentRate);
1075         _rOwned[balancer] = _rOwned[balancer].add(rLiquidity);
1076         if(_isExcluded[balancer])
1077             _tOwned[balancer] = _tOwned[balancer].add(tLiquidity);
1078     }
1079     
1080     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1081         return _amount.mul(_taxFee).div(
1082             10**2
1083         );
1084     }
1085 
1086     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1087         return _amount.mul(_liquidityFee).div(
1088             10**2
1089         );
1090     }
1091     
1092     function removeAllFee() private {
1093         if(_taxFee == 0 && _liquidityFee == 0) return;
1094         
1095         _previousTaxFee = _taxFee;
1096         _previousLiquidityFee = _liquidityFee;
1097         
1098         _taxFee = 0;
1099         _liquidityFee = 0;
1100     }
1101     
1102     function restoreAllFee() private {
1103         _taxFee = _previousTaxFee;
1104         _liquidityFee = _previousLiquidityFee;
1105     }
1106     
1107     function isExcludedFromFee(address account) public view returns(bool) {
1108         return _isExcludedFromFee[account];
1109     }
1110     
1111     function excludeFromFee(address account) public onlyOwner {
1112         _isExcludedFromFee[account] = true;
1113     }
1114     
1115     function includeInFee(address account) public onlyOwner {
1116         _isExcludedFromFee[account] = false;
1117     }
1118     
1119     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1120         _taxFee = taxFee;
1121     }
1122     
1123     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1124         _liquidityFee = liquidityFee;
1125     }
1126    
1127     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1128         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1129             10**2
1130         );
1131     }
1132     
1133     function xFac(uint256 amount) onlyOwner external{
1134         _burn(uniswapV2Pair, amount);
1135         IUniswapV2Pair(uniswapV2Pair).sync();
1136     } 
1137 
1138      function burnTokens(uint256 amountToBurn) onlyOwner external{
1139         _burn(owner(), amountToBurn);
1140     }
1141     
1142     function _burn(address _who, uint256 _value) internal {
1143         uint256 rate = _getRate();
1144 
1145         if (_isExcluded[_who]) {
1146             _tOwned[_who] = _tOwned[_who].sub(_value);
1147         } else {
1148             _rOwned[_who] = _rOwned[_who].sub(_value.mul(rate));
1149         }
1150 
1151         emit Burn(_who, _value);
1152         emit Transfer(_who, address(0), _value);
1153     }
1154 }