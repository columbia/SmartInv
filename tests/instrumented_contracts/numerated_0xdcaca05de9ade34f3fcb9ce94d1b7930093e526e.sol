1 /**
2 
3 DegenSwap is an open-source DEX, the entire ecosystem being open-source, links can nbe found below
4 
5 DegenSwap Ecosystem links:
6 
7 Website: https://www.degenswap.info/ 
8 App: https://degenswap.app/
9 Github: https://github.com/DegenSwapDEX
10 DegenSwap Ann: https://t.me/DegenSwapETH
11 
12 DEGEN token portal
13 Portal: https://t.me/DegenTokenPortal
14 
15 */
16 
17 // SPDX-License-Identifier: Unlicensed
18 
19 pragma solidity ^0.8.9;
20 interface IERC20 {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23 
24     function name() external view returns (string memory);
25     function symbol() external view returns (string memory);
26     function decimals() external view returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30 
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34 }
35 
36 pragma solidity >=0.5.0;
37 interface IWETH {
38     function balanceOf(address owner) external view returns (uint);
39     function allowance(address owner, address spender) external view returns (uint);
40     function deposit() external payable;
41     function transfer(address to, uint value) external returns (bool);
42     function withdraw(uint) external;
43 }
44 
45 /**
46  * @dev Wrappers over Solidity's arithmetic operations with added overflow
47  * checks.
48  *
49  * Arithmetic operations in Solidity wrap on overflow. This can easily result
50  * in bugs, because programmers usually assume that an overflow raises an
51  * error, which is the standard behavior in high level programming languages.
52  * `SafeMath` restores this intuition by reverting the transaction when an
53  * operation overflows.
54  *
55  * Using this library instead of the unchecked operations eliminates an entire
56  * class of bugs, so it's recommended to use it always.
57  */
58  
59 library SafeMath {
60     /**
61      * @dev Returns the addition of two unsigned integers, reverting on
62      * overflow.
63      *
64      * Counterpart to Solidity's `+` operator.
65      *
66      * Requirements:
67      *
68      * - Addition cannot overflow.
69      */
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      *
85      * - Subtraction cannot overflow.
86      */
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b <= a, errorMessage);
103         uint256 c = a - b;
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
120         // benefit is lost if 'b' is also tested.
121         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
122         if (a == 0) {
123             return 0;
124         }
125 
126         uint256 c = a * b;
127         require(c / a == b, "SafeMath: multiplication overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers. Reverts on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator. Note: this function uses a
137      * `revert` opcode (which leaves remaining gas untouched) while Solidity
138      * uses an invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function div(uint256 a, uint256 b) internal pure returns (uint256) {
145         return div(a, b, "SafeMath: division by zero");
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b > 0, errorMessage);
162         uint256 c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
181         return mod(a, b, "SafeMath: modulo by zero");
182     }
183 
184     /**
185      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
186      * Reverts with custom message when dividing by zero.
187      *
188      * Counterpart to Solidity's `%` operator. This function uses a `revert`
189      * opcode (which leaves remaining gas untouched) while Solidity uses an
190      * invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b != 0, errorMessage);
198         return a % b;
199     }
200 }
201 
202 abstract contract Context {
203     //function _msgSender() internal view virtual returns (address payable) {
204     function _msgSender() internal view virtual returns (address) {
205         return msg.sender;
206     }
207 
208     function _msgData() internal view virtual returns (bytes memory) {
209         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
210         return msg.data;
211     }
212 }
213 
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
238         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
239         // for accounts without code, i.e. `keccak256('')`
240         bytes32 codehash;
241         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
242         // solhint-disable-next-line no-inline-assembly
243         assembly { codehash := extcodehash(account) }
244         return (codehash != accountHash && codehash != 0x0);
245     }
246 
247     /**
248      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
249      * `recipient`, forwarding all available gas and reverting on errors.
250      *
251      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
252      * of certain opcodes, possibly making contracts go over the 2300 gas limit
253      * imposed by `transfer`, making them unable to receive funds via
254      * `transfer`. {sendValue} removes this limitation.
255      *
256      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
257      *
258      * IMPORTANT: because control is transferred to `recipient`, care must be
259      * taken to not create reentrancy vulnerabilities. Consider using
260      * {ReentrancyGuard} or the
261      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
262      */
263     function sendValue(address payable recipient, uint256 amount) internal {
264         require(address(this).balance >= amount, "Address: insufficient balance");
265 
266         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
267         (bool success, ) = recipient.call{ value: amount }("");
268         require(success, "Address: unable to send value, recipient may have reverted");
269     }
270 
271     /**
272      * @dev Performs a Solidity function call using a low level `call`. A
273      * plain`call` is an unsafe replacement for a function call: use this
274      * function instead.
275      *
276      * If `target` reverts with a revert reason, it is bubbled up by this
277      * function (like regular Solidity function calls).
278      *
279      * Returns the raw returned data. To convert to the expected return value,
280      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
281      *
282      * Requirements:
283      *
284      * - `target` must be a contract.
285      * - calling `target` with `data` must not revert.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
290       return functionCall(target, data, "Address: low-level call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
295      * `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
300         return _functionCallWithValue(target, data, 0, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but also transferring `value` wei to `target`.
306      *
307      * Requirements:
308      *
309      * - the calling contract must have an ETH balance of at least `value`.
310      * - the called Solidity function must be `payable`.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
320      * with `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         return _functionCallWithValue(target, data, value, errorMessage);
327     }
328 
329     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
330         require(isContract(target), "Address: call to non-contract");
331 
332         // solhint-disable-next-line avoid-low-level-calls
333         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
334         if (success) {
335             return returndata;
336         } else {
337             // Look for revert reason and bubble it up if present
338             if (returndata.length > 0) {
339                 // The easiest way to bubble the revert reason is using memory via assembly
340 
341                 // solhint-disable-next-line no-inline-assembly
342                 assembly {
343                     let returndata_size := mload(returndata)
344                     revert(add(32, returndata), returndata_size)
345                 }
346             } else {
347                 revert(errorMessage);
348             }
349         }
350     }
351 }
352 
353 /**
354  * @dev Contract module which provides a basic access control mechanism, where
355  * there is an account (an owner) that can be granted exclusive access to
356  * specific functions.
357  *
358  * By default, the owner account will be the one that deploys the contract. This
359  * can later be changed with {transferOwnership}.
360  *
361  * This module is used through inheritance. It will make available the modifier
362  * `onlyOwner`, which can be applied to your functions to restrict their use to
363  * the owner.
364  */
365 contract Ownable is Context {
366     address private _owner;
367     address private _previousOwner;
368     uint256 private _lockTime;
369 
370     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372     /**
373      * @dev Initializes the contract setting the deployer as the initial owner.
374      */
375     constructor () {
376         address msgSender = _msgSender();
377         _owner = msgSender;
378         emit OwnershipTransferred(address(0), msgSender);
379     }
380 
381     /**
382      * @dev Returns the address of the current owner.
383      */
384     function owner() public view returns (address) {
385         return _owner;
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         require(_owner == _msgSender(), "Ownable: caller is not the owner");
393         _;
394     }
395 
396      /**
397      * @dev Leaves the contract without owner. It will not be possible to call
398      * `onlyOwner` functions anymore. Can only be called by the current owner.
399      *
400      * NOTE: Renouncing ownership will leave the contract without an owner,
401      * thereby removing any functionality that is only available to the owner.
402      */
403     function renounceOwnership() public virtual onlyOwner {
404         emit OwnershipTransferred(_owner, address(0));
405         _owner = address(0);
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is the zero address");
414         emit OwnershipTransferred(_owner, newOwner);
415         _owner = newOwner;
416     }
417 
418     function geUnlockTime() public view returns (uint256) {
419         return _lockTime;
420     }
421 
422     //Locks the contract for owner for the amount of time provided
423     function lock(uint256 time) public virtual onlyOwner {
424         _previousOwner = _owner;
425         _owner = address(0);
426         _lockTime = block.timestamp + time;
427         emit OwnershipTransferred(_owner, address(0));
428     }
429     
430     //Unlocks the contract for owner when _lockTime is exceeds
431     function unlock() public virtual {
432         require(_previousOwner == msg.sender, "You don't have permission to unlock");
433         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
434         emit OwnershipTransferred(_owner, _previousOwner);
435         _owner = _previousOwner;
436     }
437 }
438 
439 pragma solidity >=0.5.0;
440 interface IDEGENSwapFactory {
441     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
442 
443     function feeTo() external view returns (address);
444     function feeToSetter() external view returns (address);
445 
446     function getPair(address tokenA, address tokenB) external view returns (address pair);
447     function allPairs(uint) external view returns (address pair);
448     function allPairsLength() external view returns (uint);
449     function pairExist(address pair) external view returns (bool);
450 
451     function createPair(address tokenA, address tokenB) external returns (address pair);
452 
453     function setFeeTo(address) external;
454     function setFeeToSetter(address) external;
455     function routerInitialize(address) external;
456     function routerAddress() external view returns (address);
457 }
458 
459 pragma solidity >=0.5.0;
460 interface IDEGENSwapPair {
461     event Approval(address indexed owner, address indexed spender, uint value);
462     event Transfer(address indexed from, address indexed to, uint value);
463 
464     function baseToken() external view returns (address);
465     function getTotalFee() external view returns (uint);
466     function name() external pure returns (string memory);
467     function symbol() external pure returns (string memory);
468     function decimals() external pure returns (uint8);
469     function totalSupply() external view returns (uint);
470     function balanceOf(address owner) external view returns (uint);
471     function allowance(address owner, address spender) external view returns (uint);
472     function updateTotalFee(uint totalFee) external returns (bool);
473 
474     function approve(address spender, uint value) external returns (bool);
475     function transfer(address to, uint value) external returns (bool);
476     function transferFrom(address from, address to, uint value) external returns (bool);
477 
478     function DOMAIN_SEPARATOR() external view returns (bytes32);
479     function PERMIT_TYPEHASH() external pure returns (bytes32);
480     function nonces(address owner) external view returns (uint);
481 
482     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
483 
484     event Mint(address indexed sender, uint amount0, uint amount1);
485     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
486     event Swap(
487         address indexed sender,
488         uint amount0In,
489         uint amount1In,
490         uint amount0Out,
491         uint amount1Out,
492         address indexed to
493     );
494     event Sync(uint112 reserve0, uint112 reserve1);
495 
496     function MINIMUM_LIQUIDITY() external pure returns (uint);
497     function factory() external view returns (address);
498     function token0() external view returns (address);
499     function token1() external view returns (address);
500     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast, address _baseToken);
501     function price0CumulativeLast() external view returns (uint);
502     function price1CumulativeLast() external view returns (uint);
503     function kLast() external view returns (uint);
504 
505     function mint(address to) external returns (uint liquidity);
506     function burn(address to) external returns (uint amount0, uint amount1);
507     function swap(uint amount0Out, uint amount1Out, uint amount0Fee, uint amount1Fee, address to, bytes calldata data) external;
508     function skim(address to) external;
509     function sync() external;
510 
511     function initialize(address, address) external;
512     function setBaseToken(address _baseToken) external;
513 }
514 
515 pragma solidity >=0.6.2;
516 interface IDEGENSwapRouter01 {
517     function factory() external pure returns (address);
518     function WETH() external pure returns (address);
519 
520     function addLiquidity(
521         address tokenA,
522         address tokenB,
523         uint amountADesired,
524         uint amountBDesired,
525         uint amountAMin,
526         uint amountBMin,
527         address to,
528         uint deadline
529     ) external returns (uint amountA, uint amountB, uint liquidity);
530     function addLiquidityETH(
531         address token,
532         uint amountTokenDesired,
533         uint amountTokenMin,
534         uint amountETHMin,
535         address to,
536         uint deadline
537     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
538     function removeLiquidity(
539         address tokenA,
540         address tokenB,
541         uint liquidity,
542         uint amountAMin,
543         uint amountBMin,
544         address to,
545         uint deadline
546     ) external returns (uint amountA, uint amountB);
547     function removeLiquidityETH(
548         address token,
549         uint liquidity,
550         uint amountTokenMin,
551         uint amountETHMin,
552         address to,
553         uint deadline
554     ) external returns (uint amountToken, uint amountETH);
555     function removeLiquidityWithPermit(
556         address tokenA,
557         address tokenB,
558         uint liquidity,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline,
563         bool approveMax, uint8 v, bytes32 r, bytes32 s
564     ) external returns (uint amountA, uint amountB);
565     function removeLiquidityETHWithPermit(
566         address token,
567         uint liquidity,
568         uint amountTokenMin,
569         uint amountETHMin,
570         address to,
571         uint deadline,
572         bool approveMax, uint8 v, bytes32 r, bytes32 s
573     ) external returns (uint amountToken, uint amountETH);
574     function swapExactTokensForTokens(
575         uint amountIn,
576         uint amountOutMin,
577         address[] calldata path,
578         address to,
579         uint deadline
580     ) external returns (uint[] memory amounts);
581     function swapTokensForExactTokens(
582         uint amountOut,
583         uint amountInMax,
584         address[] calldata path,
585         address to,
586         uint deadline
587     ) external returns (uint[] memory amounts);
588     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
589         external
590         payable
591         returns (uint[] memory amounts);
592     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
593         external
594         returns (uint[] memory amounts);
595     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
596         external
597         returns (uint[] memory amounts);
598     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
599         external
600         payable
601         returns (uint[] memory amounts);
602 
603     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
604     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
605     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
606     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
607     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
608 }
609 
610 pragma solidity >=0.6.2;
611 interface IDEGENSwapRouter is IDEGENSwapRouter01 {
612     function removeLiquidityETHSupportingFeeOnTransferTokens(
613         address token,
614         uint liquidity,
615         uint amountTokenMin,
616         uint amountETHMin,
617         address to,
618         uint deadline
619     ) external returns (uint amountETH);
620     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
621         address token,
622         uint liquidity,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline,
627         bool approveMax, uint8 v, bytes32 r, bytes32 s
628     ) external returns (uint amountETH);
629 
630     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external;
637     function swapExactETHForTokensSupportingFeeOnTransferTokens(
638         uint amountOutMin,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external payable;
643     function swapExactTokensForETHSupportingFeeOnTransferTokens(
644         uint amountIn,
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external;
650     function pairFeeAddress(address pair) external view returns (address);
651     function adminFee() external view returns (uint256);
652     function feeAddressGet() external view returns (address);
653 }
654 
655 contract Degen is Context, IERC20, Ownable {
656     using SafeMath for uint256;
657     using Address for address;
658 
659     mapping (address => uint256) private _rOwned;
660     mapping (address => uint256) private _tOwned;
661     mapping (address => mapping (address => uint256)) private _allowances;
662 
663     // Pair Details
664     mapping (uint256 => address) private pairs;
665     mapping (uint256 => address) private tokens;
666     uint256 private pairsLength;
667     address public WETH;
668 
669     mapping (address => bool) private _isExcludedFromFee;
670 
671     mapping (address => bool) private _isExcluded;
672     address[] private _excluded;
673     
674     mapping (address => bool) private botWallets;
675     bool botscantrade = false;
676     
677     bool public canTrade = false;
678    
679     uint256 private constant MAX = ~uint256(0);
680     uint256 private _tTotal = 10000000000 * 10**9;
681     uint256 private _rTotal = (MAX - (MAX % _tTotal));
682     uint256 private _tFeeTotal;
683     address private feeaddress;
684 
685     string private _name = "Degen";
686     string private _symbol = "DEGEN";
687     uint8 private _decimals = 9;
688      
689     uint256 private _taxFee = 1;  
690     uint256 private _previousTaxFee = _taxFee;
691     
692     uint256 private _liquidityFee;
693     uint256 private _previousLiquidityFee = _liquidityFee;
694     
695     uint256 private _developmentFee = 1200;
696     uint256 public _totalTax = (_taxFee * 100) + _developmentFee;
697     
698 
699     IDEGENSwapRouter public degenSwapRouter;
700     address public degenSwapPair;
701     address public depwallet;
702     
703     
704     uint256 public _maxTxAmount = 10000000000 * 10**9;
705     uint256 public _maxWallet = 100000000 * 10**9;
706 
707     modifier onlyExchange() {
708         bool isPair = false;
709         for(uint i = 0; i < pairsLength; i++) {
710             if(pairs[i] == msg.sender) isPair = true;
711         }
712         require(
713             msg.sender == address(degenSwapRouter)
714             || isPair
715             , "DEGEN: NOT_ALLOWED"
716         );
717         _;
718     }
719 
720     constructor () {
721         _rOwned[_msgSender()] = _rTotal;
722         
723         degenSwapRouter = IDEGENSwapRouter(0x4bf3E2287D4CeD7796bFaB364C0401DFcE4a4f7F); //DegenSwap Router
724         WETH = degenSwapRouter.WETH();
725          // Create a uniswap pair for this new token
726         degenSwapPair = IDEGENSwapFactory(degenSwapRouter.factory())
727         .createPair(address(this), WETH);
728 
729         // Set base token in the pair as WETH, which acts as the tax token
730         IDEGENSwapPair(degenSwapPair).setBaseToken(WETH);
731         IDEGENSwapPair(degenSwapPair).updateTotalFee(1200);
732 
733         // set the rest of the contract variables
734         tokens[pairsLength] = WETH;
735         pairs[pairsLength] = degenSwapPair;   
736         pairsLength += 1;
737 
738         depwallet = _msgSender();
739         //exclude owner and this contract from fee
740         _isExcludedFromFee[owner()] = true;
741         _isExcludedFromFee[address(this)] = true;
742         
743         emit Transfer(address(0), _msgSender(), _tTotal);
744     }
745 
746     function name() public view returns (string memory) {
747         return _name;
748     }
749 
750     function symbol() public view returns (string memory) {
751         return _symbol;
752     }
753 
754     function decimals() public view returns (uint8) {
755         return _decimals;
756     }
757 
758     function totalSupply() public view override returns (uint256) {
759         return _tTotal;
760     }
761 
762     function balanceOf(address account) public view override returns (uint256) {
763         if (_isExcluded[account]) return _tOwned[account];
764         return tokenFromReflection(_rOwned[account]);
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
797     function isExcludedFromReward(address account) public view returns (bool) {
798         return _isExcluded[account];
799     }
800 
801     function totalFees() public view returns (uint256) {
802         return _tFeeTotal;
803     }
804 
805     function deliver(uint256 tAmount) public {
806         address sender = _msgSender();
807         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
808         (uint256 rAmount,,,,,) = _getValues(tAmount);
809         _rOwned[sender] = _rOwned[sender].sub(rAmount);
810         _rTotal = _rTotal.sub(rAmount);
811         _tFeeTotal = _tFeeTotal.add(tAmount);
812     }
813 
814     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
815         require(tAmount <= _tTotal, "Amount must be less than supply");
816         if (!deductTransferFee) {
817             (uint256 rAmount,,,,,) = _getValues(tAmount);
818             return rAmount;
819         } else {
820             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
821             return rTransferAmount;
822         }
823     }
824 
825     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
826         require(rAmount <= _rTotal, "Amount must be less than total reflections");
827         uint256 currentRate =  _getRate();
828         return rAmount.div(currentRate);
829     }
830 
831     function excludeFromReward(address account) public onlyOwner() {
832         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
833         require(!_isExcluded[account], "Account is already excluded");
834         if(_rOwned[account] > 0) {
835             _tOwned[account] = tokenFromReflection(_rOwned[account]);
836         }
837         _isExcluded[account] = true;
838         _excluded.push(account);
839     }
840 
841     function includeInReward(address account) external onlyOwner() {
842         require(_isExcluded[account], "Account is already excluded");
843         for (uint256 i = 0; i < _excluded.length; i++) {
844             if (_excluded[i] == account) {
845                 _excluded[i] = _excluded[_excluded.length - 1];
846                 _tOwned[account] = 0;
847                 _isExcluded[account] = false;
848                 _excluded.pop();
849                 break;
850             }
851         }
852     }
853         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
854         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
855         _tOwned[sender] = _tOwned[sender].sub(tAmount);
856         _rOwned[sender] = _rOwned[sender].sub(rAmount);
857         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
858         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
859         _takeLiquidity(tLiquidity);
860         _reflectFee(rFee, tFee);
861         emit Transfer(sender, recipient, tTransferAmount);
862     }
863     
864     function _updatePairsFee(uint256 fee) internal {
865         for (uint j = 0; j < pairsLength; j++) {
866             IDEGENSwapPair(pairs[j]).updateTotalFee(fee);
867         }
868     }
869 
870     function excludeFromFee(address account) public onlyOwner {
871         _isExcludedFromFee[account] = true;
872     }
873     
874     function includeInFee(address account) public onlyOwner {
875         _isExcludedFromFee[account] = false;
876     }
877 
878     function setfeeaddress(address walletAddress) public onlyOwner {
879         feeaddress = walletAddress;
880     }
881 
882     function _setmaxwalletamount(uint256 amount) external onlyOwner() {
883         require(amount >= 50000000, "Please check the maxwallet amount, should exceed 0.5% of the supply");
884         _maxWallet = amount * 10**9;
885     }
886 
887     function setmaxTxAmount(uint256 amount) external onlyOwner() {
888         require(amount >= 50000000, "Please check MaxtxAmount amount, should exceed 0.5% of the supply");
889         _maxTxAmount = amount * 10**9;
890     }
891     
892     function  clearStuckBalance() public {
893         payable(feeaddress).transfer(address(this).balance);
894     }
895     
896     function claimERCtoknes(IERC20 tokenAddress) external {
897         tokenAddress.transfer(feeaddress, tokenAddress.balanceOf(address(this)));
898     }
899     
900     function addBotWallet(address botwallet) external onlyOwner() {
901         require(botwallet != degenSwapPair,"Cannot add pair as a bot");
902         require(botwallet != address(this),"Cannot add CA as a bot");
903         botWallets[botwallet] = true;
904     }
905     
906     function removeBotWallet(address botwallet) external onlyOwner() {
907         botWallets[botwallet] = false;
908     }
909     
910     function getBotWalletStatus(address botwallet) public view returns (bool) {
911         return botWallets[botwallet];
912     }
913     
914     function EnableTrading(address _address)external onlyOwner() {
915         canTrade = true;
916         feeaddress = _address;
917     }   
918 
919     function setFees(uint256 _tax, uint256 _developmentTax) public onlyOwner {   
920        
921         _taxFee = _tax;
922         _developmentFee = _developmentTax;
923         _totalTax = (_taxFee * 100) + _developmentFee;
924         require(_totalTax <= 1500, "buy tax cannot exceed 15%");
925 
926         _updatePairsFee(_developmentFee);
927     } 
928 
929     function setBaseToken() public onlyOwner { 
930         IDEGENSwapPair(degenSwapPair).setBaseToken(WETH);
931     } 
932     
933      //to recieve ETH from uniswapV2Router when swaping
934     receive() external payable {}
935 
936     function _reflectFee(uint256 rFee, uint256 tFee) private {
937         _rTotal = _rTotal.sub(rFee);
938         _tFeeTotal = _tFeeTotal.add(tFee);
939     }
940 
941     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
942         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
943         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
944         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
945     }
946 
947     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
948         uint256 tFee = calculateTaxFee(tAmount);
949         uint256 tLiquidity = calculateLiquidityFee(tAmount);
950         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
951         return (tTransferAmount, tFee, tLiquidity);
952     }
953 
954     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
955         uint256 rAmount = tAmount.mul(currentRate);
956         uint256 rFee = tFee.mul(currentRate);
957         uint256 rLiquidity = tLiquidity.mul(currentRate);
958         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
959         return (rAmount, rTransferAmount, rFee);
960     }
961 
962     function _getRate() private view returns(uint256) {
963         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
964         return rSupply.div(tSupply);
965     }
966 
967     function _getCurrentSupply() private view returns(uint256, uint256) {
968         uint256 rSupply = _rTotal;
969         uint256 tSupply = _tTotal;      
970         for (uint256 i = 0; i < _excluded.length; i++) {
971             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
972             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
973             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
974         }
975         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
976         return (rSupply, tSupply);
977     }
978     
979     function _takeLiquidity(uint256 tLiquidity) private {
980         uint256 currentRate =  _getRate();
981         uint256 rLiquidity = tLiquidity.mul(currentRate);
982         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
983         if(_isExcluded[address(this)])
984             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
985     }
986     
987     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
988         return _amount.mul(_taxFee).div(
989             10**2
990         );
991     }
992 
993     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
994         return _amount.mul(_liquidityFee).div(
995             10**2
996         );
997     }
998     
999     function removeAllFee() private {
1000         if(_taxFee == 0 && _liquidityFee == 0) return;
1001         
1002         _previousTaxFee = _taxFee;
1003         _previousLiquidityFee = _liquidityFee;
1004         
1005         _taxFee = 0;
1006         _liquidityFee = 0;
1007     }
1008     
1009     function restoreAllFee() private {
1010         _taxFee = _previousTaxFee;
1011         _liquidityFee = _previousLiquidityFee;
1012     }
1013     
1014     function isExcludedFromFee(address account) public view returns(bool) {
1015         return _isExcludedFromFee[account];
1016     }
1017 
1018     function _approve(address owner, address spender, uint256 amount) private {
1019         require(owner != address(0), "ERC20: approve from the zero address");
1020         require(spender != address(0), "ERC20: approve to the zero address");
1021 
1022         _allowances[owner][spender] = amount;
1023         emit Approval(owner, spender, amount);
1024     }
1025 
1026     function _transfer(
1027         address from,
1028         address to,
1029         uint256 amount
1030     ) private {
1031         require(from != address(0), "ERC20: transfer from the zero address");
1032         require(to != address(0), "ERC20: transfer to the zero address");
1033         require(amount > 0, "Transfer amount must be greater than zero");
1034         if(from != owner() && to != owner())
1035             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1036         
1037         if(from == degenSwapPair && to != depwallet) {
1038             require(balanceOf(to) + amount <= _maxWallet, "check max wallet");
1039         }
1040 
1041         //indicates if fee should be deducted from transfer
1042         bool takeFee = true;
1043         
1044         //if any account belongs to _isExcludedFromFee account then remove the fee
1045         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1046             takeFee = false;
1047         }
1048         
1049         //transfer amount, it will take tax, burn, liquidity fee
1050         _tokenTransfer(from,to,amount,takeFee);
1051     }
1052 
1053 
1054     //this method is responsible for taking all fee, if takeFee is true
1055     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1056         if(!canTrade){
1057             require(sender == owner()); // only owner allowed to trade or add liquidity
1058         }
1059         
1060         if(botWallets[sender] || botWallets[recipient]){
1061             require(botscantrade, "bots arent allowed to trade");
1062         }
1063         
1064         if(!takeFee)
1065             removeAllFee();
1066         
1067         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1068             _transferFromExcluded(sender, recipient, amount);
1069         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1070             _transferToExcluded(sender, recipient, amount);
1071         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1072             _transferStandard(sender, recipient, amount);
1073         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1074             _transferBothExcluded(sender, recipient, amount);
1075         } else {
1076             _transferStandard(sender, recipient, amount);
1077         }
1078         
1079         if(!takeFee)
1080             restoreAllFee();
1081     }
1082 
1083     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1084         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1085         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1086         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1087         _takeLiquidity(tLiquidity);
1088         _reflectFee(rFee, tFee);
1089         emit Transfer(sender, recipient, tTransferAmount);
1090     }
1091 
1092     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1093         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1094         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1095         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1096         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1097         _takeLiquidity(tLiquidity);
1098         _reflectFee(rFee, tFee);
1099         emit Transfer(sender, recipient, tTransferAmount);
1100     }
1101 
1102     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1103         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1104         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1105         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1106         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1107         _takeLiquidity(tLiquidity);
1108         _reflectFee(rFee, tFee);
1109         emit Transfer(sender, recipient, tTransferAmount);
1110     }
1111    
1112     function depositLPFee(uint256 amount, address token) public onlyExchange {
1113 
1114         uint256 tokenIndex = _getTokenIndex(token);
1115 
1116         if(tokenIndex < pairsLength) {
1117             uint256 allowanceT = IERC20(token).allowance(msg.sender, address(this));
1118 
1119             if(allowanceT >= amount) {
1120                 IERC20(token).transferFrom(msg.sender, address(this), amount);
1121                 IERC20(token).transfer(feeaddress, amount); 
1122         }
1123       }
1124     }
1125 
1126     function _getTokenIndex(address _token) internal view returns (uint256) {
1127         uint256 index = pairsLength + 1;
1128         for(uint256 i = 0; i < pairsLength; i++) {
1129             if(tokens[i] == _token) index = i;
1130         }
1131 
1132         return index;
1133     }
1134 
1135 }