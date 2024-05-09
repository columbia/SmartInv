1 pragma solidity 0.8.4;
2 
3 // SPDX-License-Identifier: Apache-2.0
4 
5 // ,,,,,,,,,,,,,,   ,,,,,,,,,,,,,
6 // ,,,,,,,,,,,,,,   ,,,,,,,,,,,,,
7 // ,,,,                      ,,,,
8 // ,,,,                      ,,,,
9 // ,,,,,,,,,,,,,,,,,         ,,,,
10 // ,,,,,,,,,,,,,,,,,,,,      ,,,,
11 //                  ,,,,,    ,,,,
12 // ,,,,     ,,,,     ,,,,,   ,,,,
13 // ,,,,     ,,,,      ,,,,   ,,,,
14 // ,,,,,    ,,,,     ,,,,.   ,,,,
15 //  ,,,,     ,,,,,,,,,,,     ,,,,
16 //   ,,,,,      ,,,,,,     ,,,,, 
17 //    ,,,,,,             ,,,,,,  
18 //      ,,,,,,,,,,,,,,,,,,,,     
19 //          .,,,,,,,,,,,.    
20 //
21 //          SAFE SHIELD        
22 //
23 // https://t.me/safeshieldtoken
24 
25 interface IERC20 {
26 
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations with added overflow
98  * checks.
99  *
100  * Arithmetic operations in Solidity wrap on overflow. This can easily result
101  * in bugs, because programmers usually assume that an overflow raises an
102  * error, which is the standard behavior in high level programming languages.
103  * `SafeMath` restores this intuition by reverting the transaction when an
104  * operation overflows.
105  *
106  * Using this library instead of the unchecked operations eliminates an entire
107  * class of bugs, so it's recommended to use it always.
108  */
109  
110 library SafeMath {
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         return sub(a, b, "SafeMath: subtraction overflow");
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      *
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         uint256 c = a / b;
214         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return mod(a, b, "SafeMath: modulo by zero");
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts with custom message when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b != 0, errorMessage);
249         return a % b;
250     }
251 }
252 
253 abstract contract Context {
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
417 
418     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
419 
420     /**
421      * @dev Initializes the contract setting the deployer as the initial owner.
422      */
423     constructor () {
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
485 
486 // pragma solidity >=0.5.0;
487 
488 interface IUniswapV2Pair {
489     event Approval(address indexed owner, address indexed spender, uint value);
490     event Transfer(address indexed from, address indexed to, uint value);
491 
492     function name() external pure returns (string memory);
493     function symbol() external pure returns (string memory);
494     function decimals() external pure returns (uint8);
495     function totalSupply() external view returns (uint);
496     function balanceOf(address owner) external view returns (uint);
497     function allowance(address owner, address spender) external view returns (uint);
498 
499     function approve(address spender, uint value) external returns (bool);
500     function transfer(address to, uint value) external returns (bool);
501     function transferFrom(address from, address to, uint value) external returns (bool);
502 
503     function DOMAIN_SEPARATOR() external view returns (bytes32);
504     function PERMIT_TYPEHASH() external pure returns (bytes32);
505     function nonces(address owner) external view returns (uint);
506 
507     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
508 
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
529     function burn(address to) external returns (uint amount0, uint amount1);
530     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
531     function skim(address to) external;
532     function sync() external;
533 
534     function initialize(address, address) external;
535 }
536 
537 // pragma solidity >=0.6.2;
538 
539 interface IUniswapV2Router01 {
540     function factory() external pure returns (address);
541     function WETH() external pure returns (address);
542 
543     function addLiquidity(
544         address tokenA,
545         address tokenB,
546         uint amountADesired,
547         uint amountBDesired,
548         uint amountAMin,
549         uint amountBMin,
550         address to,
551         uint deadline
552     ) external returns (uint amountA, uint amountB, uint liquidity);
553     function addLiquidityETH(
554         address token,
555         uint amountTokenDesired,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline
560     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
561     function removeLiquidity(
562         address tokenA,
563         address tokenB,
564         uint liquidity,
565         uint amountAMin,
566         uint amountBMin,
567         address to,
568         uint deadline
569     ) external returns (uint amountA, uint amountB);
570     function removeLiquidityETH(
571         address token,
572         uint liquidity,
573         uint amountTokenMin,
574         uint amountETHMin,
575         address to,
576         uint deadline
577     ) external returns (uint amountToken, uint amountETH);
578     function removeLiquidityWithPermit(
579         address tokenA,
580         address tokenB,
581         uint liquidity,
582         uint amountAMin,
583         uint amountBMin,
584         address to,
585         uint deadline,
586         bool approveMax, uint8 v, bytes32 r, bytes32 s
587     ) external returns (uint amountA, uint amountB);
588     function removeLiquidityETHWithPermit(
589         address token,
590         uint liquidity,
591         uint amountTokenMin,
592         uint amountETHMin,
593         address to,
594         uint deadline,
595         bool approveMax, uint8 v, bytes32 r, bytes32 s
596     ) external returns (uint amountToken, uint amountETH);
597     function swapExactTokensForTokens(
598         uint amountIn,
599         uint amountOutMin,
600         address[] calldata path,
601         address to,
602         uint deadline
603     ) external returns (uint[] memory amounts);
604     function swapTokensForExactTokens(
605         uint amountOut,
606         uint amountInMax,
607         address[] calldata path,
608         address to,
609         uint deadline
610     ) external returns (uint[] memory amounts);
611     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
612         external
613         payable
614         returns (uint[] memory amounts);
615     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
616         external
617         returns (uint[] memory amounts);
618     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
619         external
620         returns (uint[] memory amounts);
621     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
622         external
623         payable
624         returns (uint[] memory amounts);
625 
626     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
627     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
628     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
629     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
630     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
631 }
632 
633 
634 
635 // pragma solidity >=0.6.2;
636 
637 interface IUniswapV2Router02 is IUniswapV2Router01 {
638     function removeLiquidityETHSupportingFeeOnTransferTokens(
639         address token,
640         uint liquidity,
641         uint amountTokenMin,
642         uint amountETHMin,
643         address to,
644         uint deadline
645     ) external returns (uint amountETH);
646     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline,
653         bool approveMax, uint8 v, bytes32 r, bytes32 s
654     ) external returns (uint amountETH);
655 
656     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
657         uint amountIn,
658         uint amountOutMin,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external;
663     function swapExactETHForTokensSupportingFeeOnTransferTokens(
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external payable;
669     function swapExactTokensForETHSupportingFeeOnTransferTokens(
670         uint amountIn,
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external;
676 }
677 
678 
679 contract SafeShield is Context, IERC20, Ownable {
680     using SafeMath for uint256;
681     using Address for address;
682 
683     mapping (address => uint256) private _balances;
684     mapping (address => mapping (address => uint256)) private _allowances;
685 
686     mapping (address => bool) private _isExcludedFromFee;
687 
688 
689     uint256 private _totalSupply = 1000000000000000 * 10**9;
690 
691     string private _name = "Safe Shield";
692     string private _symbol = "SFSHLD";
693     uint8 private _decimals = 9;
694     
695     uint256 public _liquidityFee = 2;
696     uint256 private _previousLiquidityFee = _liquidityFee;
697 
698     uint256 public _devFee = 5;
699     uint256 private _previousDevFee = _devFee;
700     
701     address payable private _teamDevAddress;
702 
703     IUniswapV2Router02 public uniswapV2Router;
704     address public uniswapV2Pair;
705     
706     bool currentlySwapping;
707     bool public swapAndRedirectEthFeesEnabled = true;
708 
709     uint256 private tokensSoldThresholdForEthSwap = 10000 * 10**9;
710     
711     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
712     event SwapAndRedirectEthFeesUpdated(bool enabled);
713     event OnSwapAndRedirectEthFees(
714         uint256 tokensSwapped,
715         uint256 ethToLiquidity,
716         uint256 ethToDevWallet
717     );
718     
719     modifier lockTheSwap {
720         currentlySwapping = true;
721         _;
722         currentlySwapping = false;
723     }
724     
725     constructor () {
726         _balances[_msgSender()] = _totalSupply;
727 
728         emit Transfer(address(0), _msgSender(), _totalSupply);
729     }
730     
731     function initContract() external onlyOwner() {
732         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
733          // Create a uniswap pair for this new token
734         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
735             .createPair(address(this), _uniswapV2Router.WETH());
736 
737         // set the rest of the contract variables
738         uniswapV2Router = _uniswapV2Router;
739         
740         // exclude owner and this contract from fee
741         _isExcludedFromFee[owner()] = true;
742         _isExcludedFromFee[address(this)] = true;
743         
744         _teamDevAddress = payable(0x33206057141941E54914A425716576d7e9083B3C);
745     }
746 
747     function name() public view returns (string memory) {
748         return _name;
749     }
750 
751     function symbol() public view returns (string memory) {
752         return _symbol;
753     }
754 
755     function decimals() public view returns (uint8) {
756         return _decimals;
757     }
758 
759     function totalSupply() public view override returns (uint256) {
760         return _totalSupply;
761     }
762 
763     function balanceOf(address account) public view override returns (uint256) {
764         return _balances[account];
765     }
766 
767     function transfer(address recipient, uint256 amount) public override returns (bool) {
768         _transfer(_msgSender(), recipient, amount);
769         return true;
770     }
771 
772     function allowance(address owner, address spender) public view override returns (uint256) {
773         return _allowances[owner][spender];
774     }
775 
776     function approve(address spender, uint256 amount) public override returns (bool) {
777         _approve(_msgSender(), spender, amount);
778         return true;
779     }
780 
781     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
782         _transfer(sender, recipient, amount);
783         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
784         return true;
785     }
786 
787     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
788         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
789         return true;
790     }
791 
792     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
793         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
794         return true;
795     }
796 
797     function _approve(address owner, address spender, uint256 amount) private {
798         require(owner != address(0), "ERC20: approve from the zero address");
799         require(spender != address(0), "ERC20: approve to the zero address");
800 
801         _allowances[owner][spender] = amount;
802         emit Approval(owner, spender, amount);
803     }
804 
805     function _transfer(
806         address from,
807         address to,
808         uint256 amount
809     ) private {
810         require(from != address(0), "ERC20: transfer from the zero address");
811         require(amount > 0, "Transfer amount must be greater than zero");
812 
813         // is the token balance of this contract address over the min number of
814         // tokens that we need to initiate a swap + liquidity lock?
815         // also, don't get caught in a circular liquidity event.
816         // also, don't swap & liquify if sender is uniswap pair.
817         uint256 contractTokenBalance = balanceOf(address(this));        
818         bool overMinTokenBalance = contractTokenBalance >= tokensSoldThresholdForEthSwap;
819         if (
820             overMinTokenBalance &&
821             !currentlySwapping &&
822             from != uniswapV2Pair &&
823             swapAndRedirectEthFeesEnabled
824         ) {
825             // add liquidity and dev eth fees
826             swapAndRedirectEthFees(contractTokenBalance);
827         }
828         
829         // transfer amount
830         _tokenTransfer(from, to, amount);
831     }
832     
833         //this method is responsible for taking all fee, if takeFee is true
834     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
835         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
836             removeAllFee();
837         }
838 
839         (uint256 tTransferAmount, uint256 tLiquidity, uint256 tDev) = _getValues(amount);
840         _balances[sender] = _balances[sender].sub(tTransferAmount);
841         _balances[recipient] = _balances[recipient].add(tTransferAmount);
842         _takeLiquidity(tLiquidity);
843         _takeDevFee(tDev);
844 
845         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
846             restoreAllFee();
847         }
848         
849         emit Transfer(sender, recipient, tTransferAmount);
850     }
851 
852     //to recieve ETH from uniswapV2Router when swaping
853     receive() external payable {}
854 
855     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
856         uint256 tLiquidity = calculateLiquidityFee(tAmount);
857         uint256 tDev = calculateDevFee(tAmount);
858         uint256 tTransferAmount = tAmount.sub(tLiquidity).sub(tDev);
859         return (tTransferAmount, tLiquidity, tDev);
860     }
861     
862     function _takeLiquidity(uint256 liquidityAmount) private {
863         _balances[address(this)] = _balances[address(this)].add(liquidityAmount);
864     }
865     
866     function _takeDevFee(uint256 devAmount) private {
867         _balances[address(this)] = _balances[address(this)].add(devAmount);
868     }
869     
870     function calculateDevFee(uint256 _amount) private view returns (uint256) {
871         return _amount.mul(_devFee).div(100);
872     }
873 
874     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
875         return _amount.mul(_liquidityFee).div(100);
876     }
877     
878     function removeAllFee() private {
879         if(_liquidityFee == 0 && _devFee== 0) return;
880         
881         _previousLiquidityFee = _liquidityFee;
882         _previousDevFee = _devFee;
883         
884         _liquidityFee = 0;
885         _devFee = 0;
886     }
887     
888     function restoreAllFee() private {
889        _liquidityFee = _previousLiquidityFee;
890        _devFee = _previousDevFee;
891     }
892     
893     function isExcludedFromFee(address account) public view returns(bool) {
894         return _isExcludedFromFee[account];
895     }
896 
897     function swapAndRedirectEthFees(uint256 contractTokenBalance) private lockTheSwap {
898         // balance token fees based on variable percents
899         uint256 totalRedirectTokenFee = _devFee.add(_liquidityFee);
900         uint256 liquidityTokenBalance = contractTokenBalance.mul(_liquidityFee).div(totalRedirectTokenFee);
901         uint256 devTokenBalance = contractTokenBalance.mul(_devFee).div(totalRedirectTokenFee);
902         
903         // split the liquidity balance into halves
904         uint256 halfLiquidity = liquidityTokenBalance.div(2);
905         
906         // capture the contract's current ETH balance.
907         // this is so that we can capture exactly the amount of ETH that the
908         // swap creates, and not make the fee events include any ETH that
909         // has been manually sent to the contract
910         uint256 initialBalance = address(this).balance;
911         
912         // swap tokens for ETH
913         swapTokensForEth(devTokenBalance.add(halfLiquidity));
914         
915         uint256 newBalance = address(this).balance.sub(initialBalance);
916         
917         if(newBalance > 0) {
918             // rebalance ETH fees proportionally to half the liquidity
919             uint256 totalRedirectEthFee = _devFee.add(_liquidityFee.div(2));
920             uint256 liquidityEthBalance = newBalance.mul(_liquidityFee.div(2)).div(totalRedirectEthFee);
921             uint256 devEthBalance = newBalance.mul(_devFee).div(totalRedirectEthFee);
922 
923             //
924             // for liquidity
925             // add to uniswap
926             //
927     
928             addLiquidity(halfLiquidity, liquidityEthBalance);
929             
930             //
931             // for dev fee
932             // send to the dev address
933             //
934             
935             sendEthToDevAddress(devEthBalance);
936             
937             emit OnSwapAndRedirectEthFees(contractTokenBalance, liquidityEthBalance, devEthBalance);
938         }
939     }
940     
941     function sendEthToDevAddress(uint256 amount) private {
942         _teamDevAddress.transfer(amount);
943     }
944 
945     function swapTokensForEth(uint256 tokenAmount) private {
946         // generate the uniswap pair path of token -> weth
947         address[] memory path = new address[](2);
948         path[0] = address(this);
949         path[1] = uniswapV2Router.WETH();
950 
951         _approve(address(this), address(uniswapV2Router), tokenAmount);
952 
953         // make the swap
954         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
955             tokenAmount,
956             0, // accept any amount of ETH
957             path,
958             address(this),
959             block.timestamp
960         );
961     }
962 
963     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
964         // approve token transfer to cover all possible scenarios
965         _approve(address(this), address(uniswapV2Router), tokenAmount);
966 
967         // add the liquidity
968         uniswapV2Router.addLiquidityETH{value: ethAmount} (
969             address(this),
970             tokenAmount,
971             0, // slippage is unavoidable
972             0, // slippage is unavoidable
973             owner(),
974             block.timestamp
975         );
976     }
977     
978     function manualSwap() external onlyOwner() {
979         uint256 contractBalance = balanceOf(address(this));
980         swapTokensForEth(contractBalance);
981     }
982 
983     function manualSend() external onlyOwner() {
984         uint256 contractEthBalance = address(this).balance;
985         sendEthToDevAddress(contractEthBalance);
986     }
987 
988     function excludeFromFee(address account) public onlyOwner {
989         _isExcludedFromFee[account] = true;
990     }
991     
992     function includeInFee(address account) public onlyOwner {
993         _isExcludedFromFee[account] = false;
994     }
995     
996     function disableAllFees() external onlyOwner() {
997         _devFee = 0;
998         _liquidityFee = 0;
999         _previousLiquidityFee = _liquidityFee;
1000         _previousDevFee = _devFee;
1001         swapAndRedirectEthFeesEnabled = false;
1002         emit SwapAndRedirectEthFeesUpdated(false);
1003     }
1004 
1005     function _setDevWallet(address payable teamDevAddress) external onlyOwner() {
1006         _teamDevAddress = teamDevAddress;
1007     }
1008 
1009     function setRouterAddress(address newRouter) public onlyOwner() {
1010         IUniswapV2Router02 _newUniswapRouter = IUniswapV2Router02(newRouter);
1011         uniswapV2Pair = IUniswapV2Factory(_newUniswapRouter.factory()).createPair(address(this), _newUniswapRouter.WETH());
1012         uniswapV2Router = _newUniswapRouter;
1013     }
1014     
1015     function setSwapAndRedirectEthFeesEnabled(bool _enabled) public onlyOwner {
1016         swapAndRedirectEthFeesEnabled = _enabled;
1017         emit SwapAndRedirectEthFeesUpdated(_enabled);
1018     }
1019 }