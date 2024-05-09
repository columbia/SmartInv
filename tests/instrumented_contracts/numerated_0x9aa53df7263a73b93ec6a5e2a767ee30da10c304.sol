1 /**
2  * 
3  * 
4    %%%%%%%%%%
5    AUTZ TOKEN
6    %%%%%%%%%%
7    
8    A charity-oriented token with the ultimate goal to support autistic children and adults in the spectrum (autism spectrum disorder - ASD)
9 
10    Official Website :
11    ------------------
12    autz.io
13    
14 
15    AUTZ TOKEN Tokenomics :
16    -----------------------
17    3% congagement fee auto distributed to all AUTZ Token holders
18    30% Supply burnt at start.
19    
20    
21    Official Social Platforms : 
22    ---------------------------
23    Telegram : autz.io/telegram
24    Facebook : autz.io/facebook
25    Instagram : autz.io/instagram
26    Twitter : autz.io/twitter
27    
28    
29    Official Charity Wallet :
30    --------------------------------------
31    0x55Abd9020a78B5b493fac811eADCB8D3EDD37B88
32 
33  */
34 
35 pragma solidity ^0.6.12;
36 // SPDX-License-Identifier: Unlicensed
37 interface IERC20 {
38 
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121  
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         return sub(a, b, "SafeMath: subtraction overflow");
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      *
179      * - Multiplication cannot overflow.
180      */
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183         // benefit is lost if 'b' is also tested.
184         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b != 0, errorMessage);
261         return a % b;
262     }
263 }
264 
265 abstract contract Context {
266     function _msgSender() internal view virtual returns (address payable) {
267         return msg.sender;
268     }
269 
270     function _msgData() internal view virtual returns (bytes memory) {
271         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
272         return msg.data;
273     }
274 }
275 
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 /**
416  * @dev Contract module which provides a basic access control mechanism, where
417  * there is an account (an owner) that can be granted exclusive access to
418  * specific functions.
419  *
420  * By default, the owner account will be the one that deploys the contract. This
421  * can later be changed with {transferOwnership}.
422  *
423  * This module is used through inheritance. It will make available the modifier
424  * `onlyOwner`, which can be applied to your functions to restrict their use to
425  * the owner.
426  */
427 contract Ownable is Context {
428     address private _owner;
429     address private _previousOwner;
430     uint256 private _lockTime;
431 
432     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
433 
434     /**
435      * @dev Initializes the contract setting the deployer as the initial owner.
436      */
437     constructor () internal {
438         address msgSender = _msgSender();
439         _owner = msgSender;
440         emit OwnershipTransferred(address(0), msgSender);
441     }
442 
443     /**
444      * @dev Returns the address of the current owner.
445      */
446     function owner() public view returns (address) {
447         return _owner;
448     }
449 
450     /**
451      * @dev Throws if called by any account other than the owner.
452      */
453     modifier onlyOwner() {
454         require(_owner == _msgSender(), "Ownable: caller is not the owner");
455         _;
456     }
457 
458      /**
459      * @dev Leaves the contract without owner. It will not be possible to call
460      * `onlyOwner` functions anymore. Can only be called by the current owner.
461      *
462      * NOTE: Renouncing ownership will leave the contract without an owner,
463      * thereby removing any functionality that is only available to the owner.
464      */
465     function renounceOwnership() public virtual onlyOwner {
466         emit OwnershipTransferred(_owner, address(0));
467         _owner = address(0);
468     }
469 
470     /**
471      * @dev Transfers ownership of the contract to a new account (`newOwner`).
472      * Can only be called by the current owner.
473      */
474     function transferOwnership(address newOwner) public virtual onlyOwner {
475         require(newOwner != address(0), "Ownable: new owner is the zero address");
476         emit OwnershipTransferred(_owner, newOwner);
477         _owner = newOwner;
478     }
479 
480     function geUnlockTime() public view returns (uint256) {
481         return _lockTime;
482     }
483 
484     //Locks the contract for owner for the amount of time provided
485     function lock(uint256 time) public virtual onlyOwner {
486         _previousOwner = _owner;
487         _owner = address(0);
488         _lockTime = now + time;
489         emit OwnershipTransferred(_owner, address(0));
490     }
491     
492     //Unlocks the contract for owner when _lockTime is exceeds
493     function unlock() public virtual {
494         require(_previousOwner == msg.sender, "You don't have permission to unlock");
495         require(now > _lockTime , "Contract is locked until 7 days");
496         emit OwnershipTransferred(_owner, _previousOwner);
497         _owner = _previousOwner;
498     }
499 }
500 
501 // pragma solidity >=0.5.0;
502 
503 interface IUniswapV2Factory {
504     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
505 
506     function feeTo() external view returns (address);
507     function feeToSetter() external view returns (address);
508 
509     function getPair(address tokenA, address tokenB) external view returns (address pair);
510     function allPairs(uint) external view returns (address pair);
511     function allPairsLength() external view returns (uint);
512 
513     function createPair(address tokenA, address tokenB) external returns (address pair);
514 
515     function setFeeTo(address) external;
516     function setFeeToSetter(address) external;
517 }
518 
519 
520 // pragma solidity >=0.5.0;
521 
522 interface IUniswapV2Pair {
523     event Approval(address indexed owner, address indexed spender, uint value);
524     event Transfer(address indexed from, address indexed to, uint value);
525 
526     function name() external pure returns (string memory);
527     function symbol() external pure returns (string memory);
528     function decimals() external pure returns (uint8);
529     function totalSupply() external view returns (uint);
530     function balanceOf(address owner) external view returns (uint);
531     function allowance(address owner, address spender) external view returns (uint);
532 
533     function approve(address spender, uint value) external returns (bool);
534     function transfer(address to, uint value) external returns (bool);
535     function transferFrom(address from, address to, uint value) external returns (bool);
536 
537     function DOMAIN_SEPARATOR() external view returns (bytes32);
538     function PERMIT_TYPEHASH() external pure returns (bytes32);
539     function nonces(address owner) external view returns (uint);
540 
541     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
542 
543     event Mint(address indexed sender, uint amount0, uint amount1);
544     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
545     event Swap(
546         address indexed sender,
547         uint amount0In,
548         uint amount1In,
549         uint amount0Out,
550         uint amount1Out,
551         address indexed to
552     );
553     event Sync(uint112 reserve0, uint112 reserve1);
554 
555     function MINIMUM_LIQUIDITY() external pure returns (uint);
556     function factory() external view returns (address);
557     function token0() external view returns (address);
558     function token1() external view returns (address);
559     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
560     function price0CumulativeLast() external view returns (uint);
561     function price1CumulativeLast() external view returns (uint);
562     function kLast() external view returns (uint);
563 
564     function mint(address to) external returns (uint liquidity);
565     function burn(address to) external returns (uint amount0, uint amount1);
566     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
567     function skim(address to) external;
568     function sync() external;
569 
570     function initialize(address, address) external;
571 }
572 
573 // pragma solidity >=0.6.2;
574 
575 interface IUniswapV2Router01 {
576     function factory() external pure returns (address);
577     function WETH() external pure returns (address);
578 
579     function addLiquidity(
580         address tokenA,
581         address tokenB,
582         uint amountADesired,
583         uint amountBDesired,
584         uint amountAMin,
585         uint amountBMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountA, uint amountB, uint liquidity);
589     function addLiquidityETH(
590         address token,
591         uint amountTokenDesired,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline
596     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
597     function removeLiquidity(
598         address tokenA,
599         address tokenB,
600         uint liquidity,
601         uint amountAMin,
602         uint amountBMin,
603         address to,
604         uint deadline
605     ) external returns (uint amountA, uint amountB);
606     function removeLiquidityETH(
607         address token,
608         uint liquidity,
609         uint amountTokenMin,
610         uint amountETHMin,
611         address to,
612         uint deadline
613     ) external returns (uint amountToken, uint amountETH);
614     function removeLiquidityWithPermit(
615         address tokenA,
616         address tokenB,
617         uint liquidity,
618         uint amountAMin,
619         uint amountBMin,
620         address to,
621         uint deadline,
622         bool approveMax, uint8 v, bytes32 r, bytes32 s
623     ) external returns (uint amountA, uint amountB);
624     function removeLiquidityETHWithPermit(
625         address token,
626         uint liquidity,
627         uint amountTokenMin,
628         uint amountETHMin,
629         address to,
630         uint deadline,
631         bool approveMax, uint8 v, bytes32 r, bytes32 s
632     ) external returns (uint amountToken, uint amountETH);
633     function swapExactTokensForTokens(
634         uint amountIn,
635         uint amountOutMin,
636         address[] calldata path,
637         address to,
638         uint deadline
639     ) external returns (uint[] memory amounts);
640     function swapTokensForExactTokens(
641         uint amountOut,
642         uint amountInMax,
643         address[] calldata path,
644         address to,
645         uint deadline
646     ) external returns (uint[] memory amounts);
647     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
648         external
649         payable
650         returns (uint[] memory amounts);
651     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
652         external
653         returns (uint[] memory amounts);
654     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
655         external
656         returns (uint[] memory amounts);
657     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
658         external
659         payable
660         returns (uint[] memory amounts);
661 
662     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
663     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
664     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
665     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
666     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
667 }
668 
669 
670 
671 // pragma solidity >=0.6.2;
672 
673 interface IUniswapV2Router02 is IUniswapV2Router01 {
674     function removeLiquidityETHSupportingFeeOnTransferTokens(
675         address token,
676         uint liquidity,
677         uint amountTokenMin,
678         uint amountETHMin,
679         address to,
680         uint deadline
681     ) external returns (uint amountETH);
682     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
683         address token,
684         uint liquidity,
685         uint amountTokenMin,
686         uint amountETHMin,
687         address to,
688         uint deadline,
689         bool approveMax, uint8 v, bytes32 r, bytes32 s
690     ) external returns (uint amountETH);
691 
692     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
693         uint amountIn,
694         uint amountOutMin,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external;
699     function swapExactETHForTokensSupportingFeeOnTransferTokens(
700         uint amountOutMin,
701         address[] calldata path,
702         address to,
703         uint deadline
704     ) external payable;
705     function swapExactTokensForETHSupportingFeeOnTransferTokens(
706         uint amountIn,
707         uint amountOutMin,
708         address[] calldata path,
709         address to,
710         uint deadline
711     ) external;
712 }
713 
714 
715 contract AUTZToken is Context, IERC20, Ownable {
716     using SafeMath for uint256;
717     using Address for address;
718 
719     mapping (address => uint256) private _rOwned;
720     mapping (address => uint256) private _tOwned;
721     mapping (address => mapping (address => uint256)) private _allowances;
722 
723     mapping (address => bool) private _isExcludedFromFee;
724 
725     mapping (address => bool) private _isExcluded;
726     address[] private _excluded;
727    
728     uint256 private constant MAX = ~uint256(0);
729     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
730     uint256 private _rTotal = (MAX - (MAX % _tTotal));
731     uint256 private _tFeeTotal;
732 
733     string private _name = "AUTZ Token";
734     string private _symbol = "AUTZ";
735     uint8 private _decimals = 9;
736     
737     uint256 public _taxFee = 3;
738     uint256 private _previousTaxFee = _taxFee;
739     
740     uint256 public _liquidityFee = 0;
741     uint256 private _previousLiquidityFee = _liquidityFee;
742 
743     IUniswapV2Router02 public immutable uniswapV2Router;
744     address public immutable uniswapV2Pair;
745     
746     bool inSwapAndLiquify;
747     bool public swapAndLiquifyEnabled = true;
748     
749     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
750     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
751     
752     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
753     event SwapAndLiquifyEnabledUpdated(bool enabled);
754     event SwapAndLiquify(
755         uint256 tokensSwapped,
756         uint256 ethReceived,
757         uint256 tokensIntoLiqudity
758     );
759     
760     modifier lockTheSwap {
761         inSwapAndLiquify = true;
762         _;
763         inSwapAndLiquify = false;
764     }
765     
766     constructor () public {
767         _rOwned[_msgSender()] = _rTotal;
768         
769         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
770          // Create a uniswap pair for this new token
771         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
772             .createPair(address(this), _uniswapV2Router.WETH());
773 
774         // set the rest of the contract variables
775         uniswapV2Router = _uniswapV2Router;
776         
777         //exclude owner and this contract from fee
778         _isExcludedFromFee[owner()] = true;
779         _isExcludedFromFee[address(this)] = true;
780         
781         emit Transfer(address(0), _msgSender(), _tTotal);
782     }
783 
784     function name() public view returns (string memory) {
785         return _name;
786     }
787 
788     function symbol() public view returns (string memory) {
789         return _symbol;
790     }
791 
792     function decimals() public view returns (uint8) {
793         return _decimals;
794     }
795 
796     function totalSupply() public view override returns (uint256) {
797         return _tTotal;
798     }
799 
800     function balanceOf(address account) public view override returns (uint256) {
801         if (_isExcluded[account]) return _tOwned[account];
802         return tokenFromReflection(_rOwned[account]);
803     }
804 
805     function transfer(address recipient, uint256 amount) public override returns (bool) {
806         _transfer(_msgSender(), recipient, amount);
807         return true;
808     }
809 
810     function allowance(address owner, address spender) public view override returns (uint256) {
811         return _allowances[owner][spender];
812     }
813 
814     function approve(address spender, uint256 amount) public override returns (bool) {
815         _approve(_msgSender(), spender, amount);
816         return true;
817     }
818 
819     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
820         _transfer(sender, recipient, amount);
821         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
822         return true;
823     }
824 
825     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
826         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
827         return true;
828     }
829 
830     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
831         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
832         return true;
833     }
834 
835     function isExcludedFromReward(address account) public view returns (bool) {
836         return _isExcluded[account];
837     }
838 
839     function totalFees() public view returns (uint256) {
840         return _tFeeTotal;
841     }
842 
843     function deliver(uint256 tAmount) public {
844         address sender = _msgSender();
845         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
846         (uint256 rAmount,,,,,) = _getValues(tAmount);
847         _rOwned[sender] = _rOwned[sender].sub(rAmount);
848         _rTotal = _rTotal.sub(rAmount);
849         _tFeeTotal = _tFeeTotal.add(tAmount);
850     }
851 
852     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
853         require(tAmount <= _tTotal, "Amount must be less than supply");
854         if (!deductTransferFee) {
855             (uint256 rAmount,,,,,) = _getValues(tAmount);
856             return rAmount;
857         } else {
858             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
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
869     function excludeFromReward(address account) public onlyOwner() {
870         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
871         require(!_isExcluded[account], "Account is already excluded");
872         if(_rOwned[account] > 0) {
873             _tOwned[account] = tokenFromReflection(_rOwned[account]);
874         }
875         _isExcluded[account] = true;
876         _excluded.push(account);
877     }
878 
879     function includeInReward(address account) external onlyOwner() {
880         require(_isExcluded[account], "Account is already excluded");
881         for (uint256 i = 0; i < _excluded.length; i++) {
882             if (_excluded[i] == account) {
883                 _excluded[i] = _excluded[_excluded.length - 1];
884                 _tOwned[account] = 0;
885                 _isExcluded[account] = false;
886                 _excluded.pop();
887                 break;
888             }
889         }
890     }
891         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
892         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
893         _tOwned[sender] = _tOwned[sender].sub(tAmount);
894         _rOwned[sender] = _rOwned[sender].sub(rAmount);
895         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
896         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
897         _takeLiquidity(tLiquidity);
898         _reflectFee(rFee, tFee);
899         emit Transfer(sender, recipient, tTransferAmount);
900     }
901     
902         function excludeFromFee(address account) public onlyOwner {
903         _isExcludedFromFee[account] = true;
904     }
905     
906     function includeInFee(address account) public onlyOwner {
907         _isExcludedFromFee[account] = false;
908     }
909     
910     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
911         _taxFee = taxFee;
912     }
913     
914     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
915         _liquidityFee = liquidityFee;
916     }
917    
918     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
919         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
920             10**2
921         );
922     }
923 
924     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
925         swapAndLiquifyEnabled = _enabled;
926         emit SwapAndLiquifyEnabledUpdated(_enabled);
927     }
928     
929      //to recieve ETH from uniswapV2Router when swaping
930     receive() external payable {}
931 
932     function _reflectFee(uint256 rFee, uint256 tFee) private {
933         _rTotal = _rTotal.sub(rFee);
934         _tFeeTotal = _tFeeTotal.add(tFee);
935     }
936 
937     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
938         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
939         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
940         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
941     }
942 
943     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
944         uint256 tFee = calculateTaxFee(tAmount);
945         uint256 tLiquidity = calculateLiquidityFee(tAmount);
946         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
947         return (tTransferAmount, tFee, tLiquidity);
948     }
949 
950     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
951         uint256 rAmount = tAmount.mul(currentRate);
952         uint256 rFee = tFee.mul(currentRate);
953         uint256 rLiquidity = tLiquidity.mul(currentRate);
954         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
955         return (rAmount, rTransferAmount, rFee);
956     }
957 
958     function _getRate() private view returns(uint256) {
959         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
960         return rSupply.div(tSupply);
961     }
962 
963     function _getCurrentSupply() private view returns(uint256, uint256) {
964         uint256 rSupply = _rTotal;
965         uint256 tSupply = _tTotal;      
966         for (uint256 i = 0; i < _excluded.length; i++) {
967             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
968             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
969             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
970         }
971         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
972         return (rSupply, tSupply);
973     }
974     
975     function _takeLiquidity(uint256 tLiquidity) private {
976         uint256 currentRate =  _getRate();
977         uint256 rLiquidity = tLiquidity.mul(currentRate);
978         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
979         if(_isExcluded[address(this)])
980             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
981     }
982     
983     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
984         return _amount.mul(_taxFee).div(
985             10**2
986         );
987     }
988 
989     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
990         return _amount.mul(_liquidityFee).div(
991             10**2
992         );
993     }
994     
995     function removeAllFee() private {
996         if(_taxFee == 0 && _liquidityFee == 0) return;
997         
998         _previousTaxFee = _taxFee;
999         _previousLiquidityFee = _liquidityFee;
1000         
1001         _taxFee = 0;
1002         _liquidityFee = 0;
1003     }
1004     
1005     function restoreAllFee() private {
1006         _taxFee = _previousTaxFee;
1007         _liquidityFee = _previousLiquidityFee;
1008     }
1009     
1010     function isExcludedFromFee(address account) public view returns(bool) {
1011         return _isExcludedFromFee[account];
1012     }
1013 
1014     function _approve(address owner, address spender, uint256 amount) private {
1015         require(owner != address(0), "ERC20: approve from the zero address");
1016         require(spender != address(0), "ERC20: approve to the zero address");
1017 
1018         _allowances[owner][spender] = amount;
1019         emit Approval(owner, spender, amount);
1020     }
1021 
1022     function _transfer(
1023         address from,
1024         address to,
1025         uint256 amount
1026     ) private {
1027         require(from != address(0), "ERC20: transfer from the zero address");
1028         require(to != address(0), "ERC20: transfer to the zero address");
1029         require(amount > 0, "Transfer amount must be greater than zero");
1030         if(from != owner() && to != owner())
1031             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1032 
1033         // is the token balance of this contract address over the min number of
1034         // tokens that we need to initiate a swap + liquidity lock?
1035         // also, don't get caught in a circular liquidity event.
1036         // also, don't swap & liquify if sender is uniswap pair.
1037         uint256 contractTokenBalance = balanceOf(address(this));
1038         
1039         if(contractTokenBalance >= _maxTxAmount)
1040         {
1041             contractTokenBalance = _maxTxAmount;
1042         }
1043         
1044         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1045         if (
1046             overMinTokenBalance &&
1047             !inSwapAndLiquify &&
1048             from != uniswapV2Pair &&
1049             swapAndLiquifyEnabled
1050         ) {
1051             contractTokenBalance = numTokensSellToAddToLiquidity;
1052             //add liquidity
1053             swapAndLiquify(contractTokenBalance);
1054         }
1055         
1056         //indicates if fee should be deducted from transfer
1057         bool takeFee = true;
1058         
1059         //if any account belongs to _isExcludedFromFee account then remove the fee
1060         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1061             takeFee = false;
1062         }
1063         
1064         //transfer amount, it will take tax, burn, liquidity fee
1065         _tokenTransfer(from,to,amount,takeFee);
1066     }
1067 
1068     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1069         // split the contract balance into halves
1070         uint256 half = contractTokenBalance.div(2);
1071         uint256 otherHalf = contractTokenBalance.sub(half);
1072 
1073         // capture the contract's current ETH balance.
1074         // this is so that we can capture exactly the amount of ETH that the
1075         // swap creates, and not make the liquidity event include any ETH that
1076         // has been manually sent to the contract
1077         uint256 initialBalance = address(this).balance;
1078 
1079         // swap tokens for ETH
1080         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1081 
1082         // how much ETH did we just swap into?
1083         uint256 newBalance = address(this).balance.sub(initialBalance);
1084 
1085         // add liquidity to uniswap
1086         addLiquidity(otherHalf, newBalance);
1087         
1088         emit SwapAndLiquify(half, newBalance, otherHalf);
1089     }
1090 
1091     function swapTokensForEth(uint256 tokenAmount) private {
1092         // generate the uniswap pair path of token -> weth
1093         address[] memory path = new address[](2);
1094         path[0] = address(this);
1095         path[1] = uniswapV2Router.WETH();
1096 
1097         _approve(address(this), address(uniswapV2Router), tokenAmount);
1098 
1099         // make the swap
1100         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1101             tokenAmount,
1102             0, // accept any amount of ETH
1103             path,
1104             address(this),
1105             block.timestamp
1106         );
1107     }
1108 
1109     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1110         // approve token transfer to cover all possible scenarios
1111         _approve(address(this), address(uniswapV2Router), tokenAmount);
1112 
1113         // add the liquidity
1114         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1115             address(this),
1116             tokenAmount,
1117             0, // slippage is unavoidable
1118             0, // slippage is unavoidable
1119             owner(),
1120             block.timestamp
1121         );
1122     }
1123 
1124     //this method is responsible for taking all fee, if takeFee is true
1125     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1126         if(!takeFee)
1127             removeAllFee();
1128         
1129         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1130             _transferFromExcluded(sender, recipient, amount);
1131         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1132             _transferToExcluded(sender, recipient, amount);
1133         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1134             _transferStandard(sender, recipient, amount);
1135         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1136             _transferBothExcluded(sender, recipient, amount);
1137         } else {
1138             _transferStandard(sender, recipient, amount);
1139         }
1140         
1141         if(!takeFee)
1142             restoreAllFee();
1143     }
1144 
1145     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1146         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1147         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1148         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1149         _takeLiquidity(tLiquidity);
1150         _reflectFee(rFee, tFee);
1151         emit Transfer(sender, recipient, tTransferAmount);
1152     }
1153 
1154     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1155         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1156         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1157         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1158         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1159         _takeLiquidity(tLiquidity);
1160         _reflectFee(rFee, tFee);
1161         emit Transfer(sender, recipient, tTransferAmount);
1162     }
1163 
1164     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1165         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1166         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1167         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1168         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1169         _takeLiquidity(tLiquidity);
1170         _reflectFee(rFee, tFee);
1171         emit Transfer(sender, recipient, tTransferAmount);
1172     }
1173 
1174 
1175 }