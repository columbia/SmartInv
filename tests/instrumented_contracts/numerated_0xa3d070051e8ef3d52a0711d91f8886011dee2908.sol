1 //SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Heart Protocol | HPT
6 
7 http://heartprotocol.io
8 
9 https://t.me/heartprotocol
10 
11 https://twitter.com/heartprotocol_
12 
13 www.heartprotocol.io (https://www.heartprotocol.io/)
14 */
15 
16 
17 pragma solidity ^0.6.12;
18 
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
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
417 
418     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
419 
420     /**
421      * @dev Initializes the contract setting the deployer as the initial owner.
422      */
423     constructor () internal {
424         address msgSender = _msgSender();
425         _owner = _msgSender();
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
465 }
466 
467 // pragma solidity >=0.5.0;
468 
469 interface IUniswapV2Factory {
470     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
471 
472     function feeTo() external view returns (address);
473     function feeToSetter() external view returns (address);
474 
475     function getPair(address tokenA, address tokenB) external view returns (address pair);
476     function allPairs(uint) external view returns (address pair);
477     function allPairsLength() external view returns (uint);
478 
479     function createPair(address tokenA, address tokenB) external returns (address pair);
480 
481     function setFeeTo(address) external;
482     function setFeeToSetter(address) external;
483 }
484 
485 // pragma solidity >=0.5.0;
486 
487 interface IUniswapV2Pair {
488     event Approval(address indexed owner, address indexed spender, uint value);
489     event Transfer(address indexed from, address indexed to, uint value);
490 
491     function name() external pure returns (string memory);
492     function symbol() external pure returns (string memory);
493     function decimals() external pure returns (uint8);
494     function totalSupply() external view returns (uint);
495     function balanceOf(address owner) external view returns (uint);
496     function allowance(address owner, address spender) external view returns (uint);
497 
498     function approve(address spender, uint value) external returns (bool);
499     function transfer(address to, uint value) external returns (bool);
500     function transferFrom(address from, address to, uint value) external returns (bool);
501 
502     function DOMAIN_SEPARATOR() external view returns (bytes32);
503     function PERMIT_TYPEHASH() external pure returns (bytes32);
504     function nonces(address owner) external view returns (uint);
505 
506     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
507 
508     event Mint(address indexed sender, uint amount0, uint amount1);
509     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
510     event Swap(
511         address indexed sender,
512         uint amount0In,
513         uint amount1In,
514         uint amount0Out,
515         uint amount1Out,
516         address indexed to
517     );
518     event Sync(uint112 reserve0, uint112 reserve1);
519 
520     function MINIMUM_LIQUIDITY() external pure returns (uint);
521     function factory() external view returns (address);
522     function token0() external view returns (address);
523     function token1() external view returns (address);
524     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
525     function price0CumulativeLast() external view returns (uint);
526     function price1CumulativeLast() external view returns (uint);
527     function kLast() external view returns (uint);
528 
529     function mint(address to) external returns (uint liquidity);
530     function burn(address to) external returns (uint amount0, uint amount1);
531     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
532     function skim(address to) external;
533     function sync() external;
534 
535     function initialize(address, address) external;
536 }
537 
538 // pragma solidity >=0.6.2;
539 
540 interface IUniswapV2Router {
541     function factory() external pure returns (address);
542     function WETH() external pure returns (address);
543 
544     function addLiquidity(
545         address tokenA,
546         address tokenB,
547         uint amountADesired,
548         uint amountBDesired,
549         uint amountAMin,
550         uint amountBMin,
551         address to,
552         uint deadline
553     ) external returns (uint amountA, uint amountB, uint liquidity);
554     function addLiquidityETH(
555         address token,
556         uint amountTokenDesired,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline
561     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
562     function removeLiquidity(
563         address tokenA,
564         address tokenB,
565         uint liquidity,
566         uint amountAMin,
567         uint amountBMin,
568         address to,
569         uint deadline
570     ) external returns (uint amountA, uint amountB);
571     function removeLiquidityETH(
572         address token,
573         uint liquidity,
574         uint amountTokenMin,
575         uint amountETHMin,
576         address to,
577         uint deadline
578     ) external returns (uint amountToken, uint amountETH);
579     function removeLiquidityWithPermit(
580         address tokenA,
581         address tokenB,
582         uint liquidity,
583         uint amountAMin,
584         uint amountBMin,
585         address to,
586         uint deadline,
587         bool approveMax, uint8 v, bytes32 r, bytes32 s
588     ) external returns (uint amountA, uint amountB);
589     function removeLiquidityETHWithPermit(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline,
596         bool approveMax, uint8 v, bytes32 r, bytes32 s
597     ) external returns (uint amountToken, uint amountETH);
598     function swapExactTokensForTokens(
599         uint amountIn,
600         uint amountOutMin,
601         address[] calldata path,
602         address to,
603         uint deadline
604     ) external returns (uint[] memory amounts);
605     function swapTokensForExactTokens(
606         uint amountOut,
607         uint amountInMax,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external returns (uint[] memory amounts);
612     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
613         external
614         payable
615         returns (uint[] memory amounts);
616     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
617         external
618         returns (uint[] memory amounts);
619     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
620         external
621         returns (uint[] memory amounts);
622     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626 
627     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
628     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
629     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
630     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
631     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
632 }
633 
634 // pragma solidity >=0.6.2;
635 
636 interface IUniswapV2Router02 is IUniswapV2Router {
637     function removeLiquidityETHSupportingFeeOnTransferTokens(
638         address token,
639         uint liquidity,
640         uint amountTokenMin,
641         uint amountETHMin,
642         address to,
643         uint deadline
644     ) external returns (uint amountETH);
645     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
646         address token,
647         uint liquidity,
648         uint amountTokenMin,
649         uint amountETHMin,
650         address to,
651         uint deadline,
652         bool approveMax, uint8 v, bytes32 r, bytes32 s
653     ) external returns (uint amountETH);
654 
655     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
656         uint amountIn,
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external;
662     function swapExactETHForTokensSupportingFeeOnTransferTokens(
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external payable;
668     function swapExactTokensForETHSupportingFeeOnTransferTokens(
669         uint amountIn,
670         uint amountOutMin,
671         address[] calldata path,
672         address to,
673         uint deadline
674     ) external;
675 }
676 
677 contract HTP is Context, IERC20, Ownable {
678     using SafeMath for uint256;
679     using Address for address;
680 
681     mapping (address => uint256) private _rOwned;
682     mapping (address => uint256) private _tOwned;
683     mapping (address => mapping (address => uint256)) private _allowances;
684     mapping (address => bool) private _isExcludedFromFee;
685     mapping(address => bool) private _isExcludedFromMaxTx;
686 
687     mapping (address => bool) private _isExcluded;
688     address[] private _excluded;
689    
690     uint256 private constant MAX = ~uint256(0);
691     uint256 private _tTotal = 10000000 * 10**9;
692     uint256 private _rTotal = (MAX - (MAX % _tTotal));
693     uint256 private _tFeeTotal;
694 
695     string private _name = "Heart Protocol";
696     string private _symbol = "HPT";
697     uint8 private _decimals = 9;
698     
699     uint256 public _taxFee = 0;
700     uint256 private _previousTaxFee = _taxFee;
701 
702     uint256 public _devFee = 40;
703     uint256 private _devTax = 30;
704     uint256 private _marketingTax = 10;
705     uint256 private _previousDevFee = _devFee;
706     
707     uint256 public _liquidityFee = 10;
708     uint256 private _previousLiquidityFee = _liquidityFee;
709 
710     uint256 public launchSellFee = 40;
711     uint256 private _previousLaunchSellFee = launchSellFee;
712 
713     uint256 public maxTxAmount = _tTotal.mul(50).div(1000); // 2%
714     address payable private _devWallet = payable(0x4825c92Ed433E507309A1713E8f533c53b08D2f5);
715     address payable private _marketingWallet = payable(0x4825c92Ed433E507309A1713E8f533c53b08D2f5);
716 
717     uint256 public launchSellFeeDeadline = 0;
718 
719     IUniswapV2Router02 public uniswapV2Router;
720     address public uniswapV2Pair;
721     
722     bool inSwapAndLiquify;
723     bool public swapAndLiquifyEnabled = true;
724     uint256 private minTokensBeforeSwap = 20000 * 10**9;
725     
726     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
727     event SwapAndLiquifyEnabledUpdated(bool enabled);
728     event SwapAndLiquify(
729         uint256 tokensSwapped,
730         uint256 liquidityEthBalance,
731         uint256 devEthBalance
732     );
733     
734     modifier lockTheSwap {
735         inSwapAndLiquify = true;
736          _;
737         inSwapAndLiquify = false;
738     }
739     
740     constructor () public {
741         _rOwned[_msgSender()] = _rTotal;
742         
743         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
744          // Create a uniswap pair for this new token
745         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
746             .createPair(address(this), _uniswapV2Router.WETH());
747 
748         // set the rest of the contract variables
749         uniswapV2Router = _uniswapV2Router;
750         
751         //exclude owner and this contract from fee
752         _isExcludedFromFee[owner()] = true;
753         _isExcludedFromFee[address(this)] = true;
754 
755         // internal exclude from max tx
756         _isExcludedFromMaxTx[owner()] = true;
757         _isExcludedFromMaxTx[address(this)] = true;
758 
759         // launch sell fee
760         launchSellFeeDeadline = now + 1 days;
761         
762         emit Transfer(address(0), _msgSender(), _tTotal);
763     }
764 
765     function setRouterAddress(address newRouter) public onlyOwner() {
766         IUniswapV2Router02 _newUniswapRouter = IUniswapV2Router02(newRouter);
767         uniswapV2Pair = IUniswapV2Factory(_newUniswapRouter.factory()).createPair(address(this), _newUniswapRouter.WETH());
768         uniswapV2Router = _newUniswapRouter;
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
830     function deliver(uint256 tAmount) public {
831         address sender = _msgSender();
832         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
833         (uint256 rAmount,,,,,,) = _getValues(tAmount);
834         _rOwned[sender] = _rOwned[sender].sub(rAmount);
835         _rTotal = _rTotal.sub(rAmount);
836         _tFeeTotal = _tFeeTotal.add(tAmount);
837     }
838 
839     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
840         require(tAmount <= _tTotal, "Amount must be less than supply");
841         if (!deductTransferFee) {
842             (uint256 rAmount,,,,,,) = _getValues(tAmount);
843             return rAmount;
844         } else {
845             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
846             return rTransferAmount;
847         }
848     }
849 
850     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
851         require(rAmount <= _rTotal, "Amount must be less than total reflections");
852         uint256 currentRate =  _getRate();
853         return rAmount.div(currentRate);
854     }
855 
856     function excludeFromReward(address account) public onlyOwner() {
857         require(!_isExcluded[account], "Account is already excluded");
858         if(_rOwned[account] > 0) {
859             _tOwned[account] = tokenFromReflection(_rOwned[account]);
860         }
861         _isExcluded[account] = true;
862         _excluded.push(account);
863     }
864 
865     function includeInReward(address account) external onlyOwner() {
866         require(_isExcluded[account], "Account is already excluded");
867         for (uint256 i = 0; i < _excluded.length; i++) {
868             if (_excluded[i] == account) {
869                 _excluded[i] = _excluded[_excluded.length - 1];
870                 _tOwned[account] = 0;
871                 _isExcluded[account] = false;
872                 _excluded.pop();
873                 break;
874             }
875         }
876     }
877     
878     function _approve(address owner, address spender, uint256 amount) private {
879         require(owner != address(0));
880         require(spender != address(0));
881 
882         _allowances[owner][spender] = amount;
883         emit Approval(owner, spender, amount);
884     }
885     
886     function expectedRewards(address _sender) external view returns(uint256){
887         uint256 _balance = address(this).balance;
888         address sender = _sender;
889         uint256 holdersBal = balanceOf(sender);
890         uint totalExcludedBal;
891         for (uint256 i = 0; i < _excluded.length; i++){
892             totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);   
893         }
894         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(uniswapV2Pair)).sub(totalExcludedBal));
895         return rewards;
896     }
897     
898     function _transfer(
899         address from,
900         address to,
901         uint256 amount
902     ) private {
903         require(from != address(0), "ERC20: transfer from the zero address");
904         require(to != address(0), "ERC20: transfer to the zero address");
905         require(amount > 0, "Transfer amount must be greater than zero");
906         
907         if (
908             !_isExcludedFromMaxTx[from] &&
909             !_isExcludedFromMaxTx[to] // by default false
910         ) {
911             require(
912                 amount <= maxTxAmount,
913                 "Transfer amount exceeds the maxTxAmount."
914             );
915         }
916 
917         // initial sell fee
918         uint256 regularDevFee = _devFee;
919         uint256 regularDevTax = _devTax;
920         if (launchSellFeeDeadline >= now && to == uniswapV2Pair) {
921             _devFee = _devFee.add(launchSellFee);
922             _devTax = _devTax.add(launchSellFee);
923         }
924 
925         // is the token balance of this contract address over the min number of
926         // tokens that we need to initiate a swap + liquidity lock?
927         // also, don't get caught in a circular liquidity event.
928         // also, don't swap & liquify if sender is uniswap pair.
929         uint256 contractTokenBalance = balanceOf(address(this));
930         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
931         if (
932             overMinTokenBalance &&
933             !inSwapAndLiquify &&
934             from != uniswapV2Pair &&
935             swapAndLiquifyEnabled
936         ) {
937             // add liquidity
938             uint256 tokensToSell = maxTxAmount > contractTokenBalance ? contractTokenBalance : maxTxAmount;
939             swapAndLiquify(tokensToSell);
940         }
941         
942         // indicates if fee should be deducted from transfer
943         bool takeFee = true;
944         
945         // if any account belongs to _isExcludedFromFee account then remove the fee
946         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
947             takeFee = false;
948         }
949         
950         // transfer amount, it will take tax, dev fee, liquidity fee
951         _tokenTransfer(from, to, amount, takeFee);
952 
953         _devFee = regularDevFee;
954         _devTax = regularDevTax;
955     }
956     
957     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
958         // balance token fees based on variable percents
959         uint256 totalRedirectTokenFee = _devFee.add(_liquidityFee);
960 
961         if (totalRedirectTokenFee == 0) return;
962         uint256 liquidityTokenBalance = contractTokenBalance.mul(_liquidityFee).div(totalRedirectTokenFee);
963         uint256 devTokenBalance = contractTokenBalance.mul(_devFee).div(totalRedirectTokenFee);
964         
965         // split the liquidity balance into halves
966         uint256 halfLiquidity = liquidityTokenBalance.div(2);
967         
968         // capture the contract's current ETH balance.
969         // this is so that we can capture exactly the amount of ETH that the
970         // swap creates, and not make the fee events include any ETH that
971         // has been manually sent to the contract
972         uint256 initialBalance = address(this).balance;
973         
974         if (liquidityTokenBalance == 0 && devTokenBalance == 0) return;
975         
976         // swap tokens for ETH
977         swapTokensForEth(devTokenBalance.add(halfLiquidity));
978         
979         uint256 newBalance = address(this).balance.sub(initialBalance);
980         
981         if(newBalance > 0) {
982             // rebalance ETH fees proportionally to half the liquidity
983             uint256 totalRedirectEthFee = _devFee.add(_liquidityFee.div(2));
984             uint256 liquidityEthBalance = newBalance.mul(_liquidityFee.div(2)).div(totalRedirectEthFee);
985             uint256 devEthBalance = newBalance.mul(_devFee).div(totalRedirectEthFee);
986 
987             //
988             // for liquidity
989             // add to uniswap
990             //
991     
992             addLiquidity(halfLiquidity, liquidityEthBalance);
993             
994             //
995             // for dev fee
996             // send to the dev address
997             //
998             
999             sendEthToDevAddress(devEthBalance);
1000             
1001             emit SwapAndLiquify(contractTokenBalance, liquidityEthBalance, devEthBalance);
1002         }
1003     } 
1004     
1005     function sendEthToDevAddress(uint256 amount) private {
1006         if (amount > 0 && _devFee > 0) {
1007             uint256 ethToDev = amount.mul(_devTax).div(_devFee);
1008             uint256 ethToMarketing = amount.mul(_marketingTax).div(_devFee);
1009             if (ethToDev > 0) _devWallet.transfer(ethToDev);
1010             if (ethToMarketing > 0) _marketingWallet.transfer(ethToMarketing);
1011         }
1012     }
1013 
1014     function swapTokensForEth(uint256 tokenAmount) private {
1015         // generate the uniswap pair path of token -> weth
1016         address[] memory path = new address[](2);
1017         path[0] = address(this);
1018         path[1] = uniswapV2Router.WETH();
1019 
1020         _approve(address(this), address(uniswapV2Router), tokenAmount);
1021 
1022         // make the swap
1023         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1024             tokenAmount,
1025             0, // accept any amount of ETH
1026             path,
1027             address(this),
1028             block.timestamp
1029         );
1030     }
1031 
1032     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1033         if (tokenAmount > 0 && ethAmount > 0) {
1034             // approve token transfer to cover all possible scenarios
1035             _approve(address(this), address(uniswapV2Router), tokenAmount);
1036 
1037             // add the liquidity
1038             uniswapV2Router.addLiquidityETH{value: ethAmount} (
1039                 address(this),
1040                 tokenAmount,
1041                 0, // slippage is unavoidable
1042                 0, // slippage is unavoidable
1043                 owner(),
1044                 block.timestamp
1045             );
1046         }
1047     }
1048 
1049     //this method is responsible for taking all fee, if takeFee is true
1050     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1051         if(!takeFee) {
1052             removeAllFee();
1053         }
1054         
1055         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1056             _transferFromExcluded(sender, recipient, amount);
1057         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1058             _transferToExcluded(sender, recipient, amount);
1059         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1060             _transferStandard(sender, recipient, amount);
1061         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1062             _transferBothExcluded(sender, recipient, amount);
1063         } else {
1064             _transferStandard(sender, recipient, amount);
1065         }
1066         
1067         if(!takeFee) {
1068             restoreAllFee();
1069         }
1070     }
1071 
1072     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1073         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1074         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1075         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1076         _takeLiquidity(tLiquidity);
1077         _takeDev(tDev);
1078         _reflectFee(rFee, tFee);
1079         emit Transfer(sender, recipient, tTransferAmount);
1080     }
1081 
1082     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1083         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1084         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1085         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1086         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1087         _takeLiquidity(tLiquidity);
1088         _takeDev(tDev);
1089         _reflectFee(rFee, tFee);
1090         emit Transfer(sender, recipient, tTransferAmount);
1091     }
1092 
1093     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1094         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1095         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1096         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1097         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1098         _takeLiquidity(tLiquidity);
1099         _takeDev(tDev);
1100         _reflectFee(rFee, tFee);
1101         emit Transfer(sender, recipient, tTransferAmount);
1102     }
1103 
1104     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1105         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1106         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1107         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1108         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1109         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1110         _takeLiquidity(tLiquidity);
1111         _takeDev(tDev);
1112         _reflectFee(rFee, tFee);
1113         emit Transfer(sender, recipient, tTransferAmount);
1114     }
1115 
1116     function _reflectFee(uint256 rFee, uint256 tFee) private {
1117         _rTotal = _rTotal.sub(rFee);
1118         _tFeeTotal = _tFeeTotal.add(tFee);
1119     }
1120 
1121     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1122         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getTValues(tAmount);
1123         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tLiquidity, _getRate());
1124         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tDev, tLiquidity);
1125     }
1126 
1127     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1128         uint256 tFee = calculateTaxFee(tAmount);
1129         uint256 tDev = calculateDevFee(tAmount);
1130         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1131         uint256 tTransferAmount = tAmount.sub(tFee).sub(tDev).sub(tLiquidity);
1132         return (tTransferAmount, tFee, tDev, tLiquidity);
1133     }
1134 
1135     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1136         uint256 rAmount = tAmount.mul(currentRate);
1137         uint256 rFee = tFee.mul(currentRate);
1138         uint256 rDev = tDev.mul(currentRate);
1139         uint256 rLiquidity = tLiquidity.mul(currentRate);
1140         uint256 rTransferAmount = rAmount.sub(rFee).sub(rDev).sub(rLiquidity);
1141         return (rAmount, rTransferAmount, rFee);
1142     }
1143 
1144     function _getRate() private view returns(uint256) {
1145         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1146         return rSupply.div(tSupply);
1147     }
1148 
1149     function _getCurrentSupply() private view returns(uint256, uint256) {
1150         uint256 rSupply = _rTotal;
1151         uint256 tSupply = _tTotal;      
1152         for (uint256 i = 0; i < _excluded.length; i++) {
1153             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1154             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1155             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1156         }
1157         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1158         return (rSupply, tSupply);
1159     }
1160     
1161     function _takeLiquidity(uint256 tLiquidity) private {
1162         uint256 currentRate =  _getRate();
1163         uint256 rLiquidity = tLiquidity.mul(currentRate);
1164         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1165         if(_isExcluded[address(this)]) {
1166             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1167         }
1168     }
1169     
1170     function _takeDev(uint256 tDev) private {
1171         uint256 currentRate =  _getRate();
1172         uint256 rDev = tDev.mul(currentRate);
1173         _rOwned[address(this)] = _rOwned[address(this)].add(rDev);
1174         if(_isExcluded[address(this)]) {
1175             _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
1176         }
1177     }
1178     
1179     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1180         return _amount.mul(_taxFee).div(1000);
1181     }
1182 
1183     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1184         return _amount.mul(_devFee).div(1000);
1185     }
1186 
1187     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1188         return _amount.mul(_liquidityFee).div(1000);
1189     }
1190     
1191     function removeAllFee() private {
1192         if(_taxFee == 0 && _devFee == 0 && _liquidityFee == 0 && launchSellFee == 0) return;
1193         
1194         _previousTaxFee = _taxFee;
1195         _previousDevFee = _devFee;
1196         _previousLiquidityFee = _liquidityFee;
1197         _previousLaunchSellFee = launchSellFee;
1198         
1199         _taxFee = 0;
1200         _devFee = 0;
1201         _liquidityFee = 0;
1202         launchSellFee = 0;
1203     }
1204     
1205     function restoreAllFee() private {
1206         _taxFee = _previousTaxFee;
1207         _devFee = _previousDevFee;
1208         _liquidityFee = _previousLiquidityFee;
1209         launchSellFee = _previousLaunchSellFee;
1210     }
1211     
1212     function manualSwap() external onlyOwner() {
1213         uint256 contractBalance = balanceOf(address(this));
1214         swapTokensForEth(contractBalance);
1215     }
1216 
1217     function manualSend() external onlyOwner() {
1218         uint256 contractEthBalance = address(this).balance;
1219         sendEthToDevAddress(contractEthBalance);
1220     }
1221     
1222     function isExcludedFromFee(address account) external view returns(bool) {
1223         return _isExcludedFromFee[account];
1224     }
1225     
1226     function excludeFromFee(address account) external onlyOwner {
1227         _isExcludedFromFee[account] = true;
1228     }
1229     
1230     function includeInFee(address account) external onlyOwner {
1231         _isExcludedFromFee[account] = false;
1232     }
1233 
1234     // for 0.5% input 5, for 1% input 10
1235     function setMaxTxPercent(uint256 newMaxTx) external onlyOwner {
1236         require(newMaxTx >= 20, "Max TX should be above 0.5%");
1237         maxTxAmount = _tTotal.mul(newMaxTx).div(1000);
1238     }
1239     
1240     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1241          require(taxFee <= 90, "Maximum fee limit is 9 percent");
1242         _taxFee = taxFee;
1243     }
1244     
1245     function setDevFeePercent(uint256 devFee, uint256 devTax, uint256 marketingTax) external onlyOwner() {
1246          require(devFee <= 100, "Maximum fee limit is 10 percent");
1247          require(devTax + marketingTax == devFee, "Dev + marketing must equal total fee");
1248         _devFee = devFee;
1249         _devTax = devTax;
1250         _marketingTax = marketingTax;
1251     }
1252     
1253     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1254         require(liquidityFee <= 80, "Maximum fee limit is 8 percent");
1255         _liquidityFee = liquidityFee;
1256     }
1257 
1258     function setLaunchSellFee(uint256 newLaunchSellFee) external onlyOwner {
1259         require(newLaunchSellFee <= 250, "Maximum launch sell fee is 25%");
1260         launchSellFee = newLaunchSellFee;
1261     }
1262 
1263     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1264         swapAndLiquifyEnabled = _enabled;
1265         emit SwapAndLiquifyEnabledUpdated(_enabled);
1266     }
1267 
1268     function setMinTokensBeforeSwap(uint256 minTokens) external onlyOwner {
1269         minTokensBeforeSwap = minTokens * 10**9;
1270         emit MinTokensBeforeSwapUpdated(minTokens);
1271     }
1272     
1273     // to receive ETH from uniswapV2Router when swaping
1274     receive() external payable {}
1275 }