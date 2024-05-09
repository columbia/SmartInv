1 // SPDX-License-Identifier: MIT
2 
3 /*
4 https://twitter.com/boruto_inu?s=21
5 https://t.me/borutoinu
6 
7 3 Protections:
8 1. Antisnipe - Prevents trading or transfers of any kind if bought in the first few blocks since liquidity is added.
9 2. Antigas - Rejects transactions that use too high of a gas price value.
10 3. Antiblock - Rejects multiple transactions in the same block by the same user.
11 
12 */
13 
14 pragma solidity >=0.6.0 <0.9.0;
15 
16 abstract contract Context {
17     function _msgSender() internal view returns (address payable) {
18         return payable(msg.sender);
19     }
20 
21     function _msgData() internal view returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IERC20 {
28   /**
29    * @dev Returns the amount of tokens in existence.
30    */
31   function totalSupply() external view returns (uint256);
32 
33   /**
34    * @dev Returns the token decimals.
35    */
36   function decimals() external view returns (uint8);
37 
38   /**
39    * @dev Returns the token symbol.
40    */
41   function symbol() external view returns (string memory);
42 
43   /**
44   * @dev Returns the token name.
45   */
46   function name() external view returns (string memory);
47 
48   /**
49    * @dev Returns the bep token owner.
50    */
51   function getOwner() external view returns (address);
52 
53   /**
54    * @dev Returns the amount of tokens owned by `account`.
55    */
56   function balanceOf(address account) external view returns (uint256);
57 
58   /**
59    * @dev Moves `amount` tokens from the caller's account to `recipient`.
60    *
61    * Returns a boolean value indicating whether the operation succeeded.
62    *
63    * Emits a {Transfer} event.
64    */
65   function transfer(address recipient, uint256 amount) external returns (bool);
66 
67   /**
68    * @dev Returns the remaining number of tokens that `spender` will be
69    * allowed to spend on behalf of `owner` through {transferFrom}. This is
70    * zero by default.
71    *
72    * This value changes when {approve} or {transferFrom} are called.
73    */
74   function allowance(address _owner, address spender) external view returns (uint256);
75 
76   /**
77    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78    *
79    * Returns a boolean value indicating whether the operation succeeded.
80    *
81    * IMPORTANT: Beware that changing an allowance with this method brings the risk
82    * that someone may use both the old and the new allowance by unfortunate
83    * transaction ordering. One possible solution to mitigate this race
84    * condition is to first reduce the spender's allowance to 0 and set the
85    * desired value afterwards:
86    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87    *
88    * Emits an {Approval} event.
89    */
90   function approve(address spender, uint256 amount) external returns (bool);
91 
92   /**
93    * @dev Moves `amount` tokens from `sender` to `recipient` using the
94    * allowance mechanism. `amount` is then deducted from the caller's
95    * allowance.
96    *
97    * Returns a boolean value indicating whether the operation succeeded.
98    *
99    * Emits a {Transfer} event.
100    */
101   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
102 
103   /**
104    * @dev Emitted when `value` tokens are moved from one account (`from`) to
105    * another (`to`).
106    *
107    * Note that `value` may be zero.
108    */
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 
111   /**
112    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113    * a call to {approve}. `value` is the new allowance.
114    */
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      *
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193         // benefit is lost if 'b' is also tested.
194         // See: https://github.com/OpenZeppelin/bo/r_u/to_in_u/pull/522
195         if (a == 0) {
196             return 0;
197         }
198 
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223      * division by zero. The result is rounded towards zero.
224      * 
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b > 0, errorMessage);
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts when dividing by zero.
244      * b*or*ut*o*in*u
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return mod(a, b, "SafeMath: modulo by zero");
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts with custom message when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 library Address {
276     function isContract(address account) internal view returns (bool) {
277         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
278         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
279         // for accounts without code, i.e. `keccak256('')`
280         bytes32 codehash;
281         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
282         // solhint-disable-next-line no-inline-assembly
283         assembly { codehash := extcodehash(account) }
284         return (codehash != accountHash && codehash != 0x0);
285     }
286 
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291         (bool success, ) = recipient.call{ value: amount }("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
300         return _functionCallWithValue(target, data, 0, errorMessage);
301     }
302 
303 
304     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307 
308     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
309         require(address(this).balance >= value, "Address: insufficient balance for call");
310         return _functionCallWithValue(target, data, value, errorMessage);
311     }
312 
313     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
314         require(isContract(target), "Address: call to non-contract");
315 
316         // solhint-disable-next-line avoid-low-level-calls
317         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
318         if (success) {
319             return returndata;
320         } else {
321             // Look for revert reason and bubble it up if present
322             if (returndata.length > 0) {
323                 // The easiest way to bubble the revert reason is using memory via assembly
324 
325                 // solhint-disable-next-line no-inline-assembly
326                 assembly {
327                     let returndata_size := mload(returndata)
328                     revert(add(32, returndata), returndata_size)
329                 }
330             } else {
331                 revert(errorMessage);
332             }
333         }
334     }
335 }
336 
337 interface IUniswapV2Factory {
338     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
339     function feeTo() external view returns (address);
340     function feeToSetter() external view returns (address);
341     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
342     function allPairs(uint) external view returns (address lpPair);
343     function allPairsLength() external view returns (uint);
344     function createPair(address tokenA, address tokenB) external returns (address lpPair);
345     function setFeeTo(address) external;
346     function setFeeToSetter(address) external;
347 }
348 
349 interface IUniswapV2Pair {
350     event Approval(address indexed owner, address indexed spender, uint value);
351     event Transfer(address indexed from, address indexed to, uint value);
352 
353     function name() external pure returns (string memory);
354     function symbol() external pure returns (string memory);
355     function decimals() external pure returns (uint8);
356     function totalSupply() external view returns (uint);
357     function balanceOf(address owner) external view returns (uint);
358     function allowance(address owner, address spender) external view returns (uint);
359     function approve(address spender, uint value) external returns (bool);
360     function transfer(address to, uint value) external returns (bool);
361     function transferFrom(address from, address to, uint value) external returns (bool);
362     function DOMAIN_SEPARATOR() external view returns (bytes32);
363     function PERMIT_TYPEHASH() external pure returns (bytes32);
364     function nonces(address owner) external view returns (uint);
365     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
366     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
367     event Swap(
368         address indexed sender,
369         uint amount0In,
370         uint amount1In,
371         uint amount0Out,
372         uint amount1Out,
373         address indexed to
374     );
375     event Sync(uint112 reserve0, uint112 reserve1);
376 
377     function MINIMUM_LIQUIDITY() external pure returns (uint);
378     function factory() external view returns (address);
379     function token0() external view returns (address);
380     function token1() external view returns (address);
381     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
382     function price0CumulativeLast() external view returns (uint);
383     function price1CumulativeLast() external view returns (uint);
384     function kLast() external view returns (uint);
385     function mint(address to) external returns (uint liquidity);
386     function burn(address to) external returns (uint amount0, uint amount1);
387     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
388     function skim(address to) external;
389     function sync() external;
390     function initialize(address, address) external;
391 }
392 
393 interface IUniswapV2Router01 {
394     function factory() external pure returns (address);
395     function WETH() external pure returns (address);
396     function addLiquidity(
397         address tokenA,
398         address tokenB,
399         uint amountADesired,
400         uint amountBDesired,
401         uint amountAMin,
402         uint amountBMin,
403         address to,
404         uint deadline
405     ) external returns (uint amountA, uint amountB, uint liquidity);
406     function addLiquidityETH(
407         address token,
408         uint amountTokenDesired,
409         uint amountTokenMin,
410         uint amountETHMin,
411         address to,
412         uint deadline
413     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
414     function removeLiquidity(
415         address tokenA,
416         address tokenB,
417         uint liquidity,
418         uint amountAMin,
419         uint amountBMin,
420         address to,
421         uint deadline
422     ) external returns (uint amountA, uint amountB);
423     function removeLiquidityETH(
424         address token,
425         uint liquidity,
426         uint amountTokenMin,
427         uint amountETHMin,
428         address to,
429         uint deadline
430     ) external returns (uint amountToken, uint amountETH);
431     function removeLiquidityWithPermit(
432         address tokenA,
433         address tokenB,
434         uint liquidity,
435         uint amountAMin,
436         uint amountBMin,
437         address to,
438         uint deadline,
439         bool approveMax, uint8 v, bytes32 r, bytes32 s
440     ) external returns (uint amountA, uint amountB);
441     function removeLiquidityETHWithPermit(
442         address token,
443         uint liquidity,
444         uint amountTokenMin,
445         uint amountETHMin,
446         address to,
447         uint deadline,
448         bool approveMax, uint8 v, bytes32 r, bytes32 s
449     ) external returns (uint amountToken, uint amountETH);
450     function swapExactTokensForTokens(
451         uint amountIn,
452         uint amountOutMin,
453         address[] calldata path,
454         address to,
455         uint deadline
456     ) external returns (uint[] memory amounts);
457     function swapTokensForExactTokens(
458         uint amountOut,
459         uint amountInMax,
460         address[] calldata path,
461         address to,
462         uint deadline
463     ) external returns (uint[] memory amounts);
464     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
465     external
466     payable
467     returns (uint[] memory amounts);
468     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
469     external
470     returns (uint[] memory amounts);
471     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
472     external
473     returns (uint[] memory amounts);
474     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
475     external
476     payable
477     returns (uint[] memory amounts);
478 
479     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
480     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
481     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
482     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
483     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
484 }
485 
486 interface IUniswapV2Router02 is IUniswapV2Router01 {
487     function removeLiquidityETHSupportingFeeOnTransferTokens(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline
494     ) external returns (uint amountETH);
495     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
496         address token,
497         uint liquidity,
498         uint amountTokenMin,
499         uint amountETHMin,
500         address to,
501         uint deadline,
502         bool approveMax, uint8 v, bytes32 r, bytes32 s
503     ) external returns (uint amountETH);
504 
505     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external;
512     function swapExactETHForTokensSupportingFeeOnTransferTokens(
513         uint amountOutMin,
514         address[] calldata path,
515         address to,
516         uint deadline
517     ) external payable;
518     function swapExactTokensForETHSupportingFeeOnTransferTokens(
519         uint amountIn,
520         uint amountOutMin,
521         address[] calldata path,
522         address to,
523         uint deadline
524     ) external;
525 }
526 
527 abstract contract Ownable is Context {
528     address private _owner;
529 
530     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
531 
532     constructor () {
533         address msgSender = _msgSender();
534         _owner = msgSender;
535         emit OwnershipTransferred(address(0), msgSender);
536     }
537 
538     function owner() public view returns (address) {
539         return _owner;
540     }
541 
542     modifier onlyOwner() {
543         require(_owner == _msgSender(), "Ownable: caller is not the owner");
544         _;
545     }
546 
547     function renounceOwnership() public virtual onlyOwner {
548         emit OwnershipTransferred(_owner, address(0));
549         _owner = address(0);
550     }
551 
552     function transferOwnership(address newOwner) public virtual onlyOwner {
553         require(newOwner != address(0), "Ownable: new owner is the zero address");
554         
555         emit OwnershipTransferred(_owner, newOwner);
556         _owner = newOwner;
557     }
558     
559 }
560 
561 contract BorutoInu is Context, IERC20, Ownable {
562     using SafeMath for uint256;
563     using Address for address;
564 
565     mapping (address => uint256) private _rOwned;
566     mapping (address => uint256) private _tOwned;
567     mapping (address => mapping (address => uint256)) private _allowances;
568     mapping (address => uint256) private lastTrade;
569 
570     mapping (address => bool) private _isExcludedFromFee;
571     mapping (address => bool) private _isExcluded;
572     address[] private _excluded;
573 
574     mapping (address => bool) private _isBlacklisted;
575     mapping (address => bool) private _liquidityHolders;
576    
577     uint256 private startingSupply = 1_000_000_000_000_000; //1 Quadrillion, underscores aid readability
578    
579     uint256 private constant MAX = ~uint256(0);
580     uint8 private _decimals = 9;
581     uint256 private _decimalsMul = _decimals;
582     uint256 private _tTotal = startingSupply * 10**_decimalsMul;
583     uint256 private _rTotal = (MAX - (MAX % _tTotal));
584     uint256 private _tFeeTotal;
585 
586     string private _name = "Boruto Inu";
587     string private _symbol = "BORUTO";
588     
589     uint256 public _reflectFee = 200; // All taxes are divided by 100 for more accuracy.
590     uint256 private _previousReflectFee = _reflectFee;
591     uint256 private maxReflectFee = 800;
592     
593     uint256 public _liquidityFee = 200; // All taxes are divided by 100 for more accuracy.
594     uint256 private _previousLiquidityFee = _liquidityFee;
595     uint256 private maxLiquidityFee = 800;
596 
597     uint256 public _marketingFee = 400; // All taxes are divided by 100 for more accuracy.
598     uint256 private _previousMarketingFee = _marketingFee;
599     uint256 private maxMarketingFee = 800;
600 
601     uint256 private masterTaxDivisor = 10000; // All tax calculations are divided by this number.
602 
603     IUniswapV2Router02 public dexRouter;
604     address public lpPair;
605 
606     // Uniswap Router
607     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
608 
609     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
610     address payable private _marketingWallet = payable(0x3129cb26885b14AAA7C9B13f18691449c54CE307);
611     
612     bool inSwapAndLiquify;
613     bool public swapAndLiquifyEnabled = false;
614     
615     // Max TX amount is 1% of the total supply.
616     uint256 private maxTxPercent = 15; // Less fields to edit
617     uint256 private maxTxDivisor = 1000;
618     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
619     uint256 private _previousMaxTxAmount = _maxTxAmount;
620     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor; // Actual amount for UI's
621     // Maximum wallet size is 2% of the total supply.
622     uint256 private maxWalletPercent = 3; // Less fields to edit
623     uint256 private maxWalletDivisor = 100;
624     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
625     uint256 private _previousMaxWalletSize = _maxWalletSize;
626     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor; // Actual amount for UI's
627     // 0.05% of Total Supply
628     uint256 private numTokensSellToAddToLiquidity = (_tTotal * 5) / 10000;
629 
630     bool private sniperProtection = true;
631     bool public _hasLiqBeenAdded = false;
632     uint256 private _liqAddBlock = 0;
633     uint256 private _liqAddStamp = 0;
634     uint256 private immutable snipeBlockAmt;
635     uint256 public snipersCaught = 0;
636     bool private gasLimitActive = true;
637     uint256 private gasPriceLimit;
638     bool private sameBlockActive = true;
639     
640     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
641     event SwapAndLiquifyEnabledUpdated(bool enabled);
642     event SwapAndLiquify(
643         uint256 tokensSwapped,
644         uint256 ethReceived,
645         uint256 tokensIntoLiqudity
646     );
647     event SniperCaught(address sniperAddress);
648     
649     modifier lockTheSwap {
650         inSwapAndLiquify = true;
651         _;
652         inSwapAndLiquify = false;
653     }
654     
655     constructor (uint256 _snipeBlockAmt, uint256 _gasPriceLimit) payable {
656         _tOwned[_msgSender()] = _tTotal;
657         _rOwned[_msgSender()] = _rTotal;
658 
659         // Set the amount of blocks to count a sniper.
660         snipeBlockAmt = _snipeBlockAmt;
661         gasPriceLimit = _gasPriceLimit * 1 gwei;
662 
663         IUniswapV2Router02 _dexRouter = IUniswapV2Router02(_routerAddress);
664         lpPair = IUniswapV2Factory(_dexRouter.factory())
665             .createPair(address(this), _dexRouter.WETH());
666 
667         dexRouter = _dexRouter;
668         
669         _isExcludedFromFee[owner()] = true;
670         _isExcludedFromFee[address(this)] = true;
671         _liquidityHolders[owner()] = true;
672         _isExcluded[address(this)] = true;
673         _excluded.push(address(this));
674         _isExcluded[owner()] = true;
675         _excluded.push(owner());
676         _isExcluded[burnAddress] = true;
677         _excluded.push(burnAddress);
678         _isExcluded[_marketingWallet] = true;
679         _excluded.push(_marketingWallet);
680         _isExcluded[lpPair] = true;
681         _excluded.push(lpPair);
682         // DxLocker Address (BSC)
683         _isExcludedFromFee[0x2D045410f002A95EFcEE67759A92518fA3FcE677] = true;
684         _isExcluded[0x2D045410f002A95EFcEE67759A92518fA3FcE677] = true;
685         _excluded.push(0x2D045410f002A95EFcEE67759A92518fA3FcE677);
686 
687         // Approve the owner for PancakeSwap, timesaver.
688         _approve(_msgSender(), _routerAddress, _tTotal);
689 
690         // Ever-growing sniper/tool blacklist
691         _isBlacklisted[0xE4882975f933A199C92b5A925C9A8fE65d599Aa8] = true;
692         _isBlacklisted[0x86C70C4a3BC775FB4030448c9fdb73Dc09dd8444] = true;
693         _isBlacklisted[0xa4A25AdcFCA938aa030191C297321323C57148Bd] = true;
694         _isBlacklisted[0x20C00AFf15Bb04cC631DB07ee9ce361ae91D12f8] = true;
695         _isBlacklisted[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
696 
697         emit Transfer(address(0), _msgSender(), _tTotal);
698     }
699 
700     function totalSupply() external view override returns (uint256) { return _tTotal; }
701     function decimals() external view override returns (uint8) { return _decimals; }
702     function symbol() external view override returns (string memory) { return _symbol; }
703     function name() external view override returns (string memory) { return _name; }
704     function getOwner() external view override returns (address) { return owner(); }
705     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
706 
707     function balanceOf(address account) public view override returns (uint256) {
708         if (_isExcluded[account]) return _tOwned[account];
709         return tokenFromReflection(_rOwned[account]);
710     }
711 
712     function transfer(address recipient, uint256 amount) public override returns (bool) {
713         _transfer(_msgSender(), recipient, amount);
714         return true;
715     }
716 
717     function approve(address spender, uint256 amount) public override returns (bool) {
718         _approve(_msgSender(), spender, amount);
719         return true;
720     }
721 
722     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
723         _transfer(sender, recipient, amount);
724         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
725         return true;
726     }
727 
728     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
729         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
730         return true;
731     }
732 
733     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
734         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
735         return true;
736     }
737 
738     function isExcludedFromReward(address account) public view returns (bool) {
739         return _isExcluded[account];
740     }
741 
742     function isExcludedFromFee(address account) public view returns(bool) {
743         return _isExcludedFromFee[account];
744     }
745 
746     function isBlacklisted(address account) public view returns (bool) {
747         return _isBlacklisted[account];
748     }
749 
750     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
751         _isBlacklisted[account] = enabled;
752     }
753 
754     function setProtectionSettings(bool antiSnipe, bool antiGas, bool antiBlock) external onlyOwner() {
755         sniperProtection = antiSnipe;
756         gasLimitActive = antiGas;
757         sameBlockActive = antiBlock;
758     }
759     
760     function setTaxFeePercent(uint256 reflectFee) external onlyOwner() {
761         require(reflectFee <= maxReflectFee); // Prevents owner from abusing fees.
762         _reflectFee = reflectFee;
763     }
764     
765     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
766         require(liquidityFee <= maxLiquidityFee); // Prevents owner from abusing fees.
767         _liquidityFee = liquidityFee;
768     }
769 
770     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
771         require(marketingFee <= maxMarketingFee); // Prevents owner from abusing fees.
772         _marketingFee = marketingFee;
773     }
774 
775     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner() {
776         require(divisor <= 10000); // Cannot set lower than 0.01%
777         _maxTxAmount = _tTotal.mul(percent).div(divisor);
778         maxTxAmountUI = startingSupply.mul(percent).div(divisor);
779     }
780 
781     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner() {
782         require(divisor <= 1000); // Cannot set lower than 0.1%
783         _maxWalletSize = _tTotal.mul(percent).div(divisor);
784         maxWalletSizeUI = startingSupply.mul(percent).div(divisor);
785     }
786 
787     function setMarketingWallet(address payable newWallet) external onlyOwner {
788         require(_marketingWallet != newWallet, "Wallet already set!");
789         _marketingWallet = payable(newWallet);
790     }
791 
792     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
793         swapAndLiquifyEnabled = _enabled;
794         emit SwapAndLiquifyEnabledUpdated(_enabled);
795     }
796 
797     function excludeFromFee(address account) public onlyOwner {
798         _isExcludedFromFee[account] = true;
799     }
800     
801     function includeInFee(address account) external onlyOwner {
802         _isExcludedFromFee[account] = false;
803     }
804 
805     function totalFees() public view returns (uint256) {
806         return _tFeeTotal;
807     }
808 
809     function setGasPriceLimit(uint256 gas) external onlyOwner {
810         require(gas >= 150);
811         gasPriceLimit = gas * 1 gwei;
812     }
813 
814     function _hasLimits(address from, address to) private view returns (bool) {
815         return from != owner()
816             && to != owner()
817             && !_liquidityHolders[to]
818             && !_liquidityHolders[from]
819             && to != burnAddress
820             && to != address(0)
821             && from != address(this);
822     }
823 
824     function deliver(uint256 tAmount) public {
825         address sender = _msgSender();
826         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
827         (uint256 rAmount,,,,,) = _getValues(tAmount);
828         _rOwned[sender] = _rOwned[sender].sub(rAmount);
829         _rTotal = _rTotal.sub(rAmount);
830         _tFeeTotal = _tFeeTotal.add(tAmount);
831     }
832 
833     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
834         require(tAmount <= _tTotal, "Amount must be less than supply");
835         if (!deductTransferFee) {
836             (uint256 rAmount,,,,,) = _getValues(tAmount);
837             return rAmount;
838         } else {
839             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
840             return rTransferAmount;
841         }
842     }
843 
844     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
845         require(rAmount <= _rTotal, "Amount must be less than total reflections");
846         uint256 currentRate =  _getRate();
847         return rAmount.div(currentRate);
848     }
849 
850     function excludeFromReward(address account) public onlyOwner() {
851         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
852         require(!_isExcluded[account], "Account is already excluded");
853         if(_rOwned[account] > 0) {
854             _tOwned[account] = tokenFromReflection(_rOwned[account]);
855         }
856         _isExcluded[account] = true;
857         _excluded.push(account);
858     }
859 
860     function includeInReward(address account) external onlyOwner() {
861         require(_isExcluded[account], "Account is already excluded");
862         for (uint256 i = 0; i < _excluded.length; i++) {
863             if (_excluded[i] == account) {
864                 _excluded[i] = _excluded[_excluded.length - 1];
865                 _tOwned[account] = 0;
866                 _isExcluded[account] = false;
867                 _excluded.pop();
868                 break;
869             }
870         }
871     }
872     
873      //to recieve ETH from dexRouter when swaping
874     receive() external payable {}
875 
876     function _approve(address owner, address spender, uint256 amount) private {
877         require(owner != address(0), "ERC20: approve from the zero address");
878         require(spender != address(0), "ERC20: approve to the zero address");
879 
880         _allowances[owner][spender] = amount;
881         emit Approval(owner, spender, amount);
882     }
883 
884     function _transfer(
885         address from
886 ,        address to,
887         uint256 amount
888     ) private {
889         require(from != address(0), "ERC20: transfer from the zero address");
890         require(to != address(0), "ERC20: transfer to the zero address");
891         require(amount > 0, "Transfer amount must be greater than zero");
892         if (gasLimitActive) {
893             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
894         }
895         if(_hasLimits(from, to)) {
896             if (sameBlockActive) {
897                 if (from == lpPair){
898                     require(lastTrade[to] != block.number);
899                     lastTrade[to] = block.number;
900                 } else {
901                     require(lastTrade[from] != block.number);
902                     lastTrade[from] = block.number;
903                 }
904             }
905             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
906             if(to != _routerAddress && to != lpPair) {
907                 uint256 contractBalanceRecepient = balanceOf(to);
908                 require(contractBalanceRecepient + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
909             }
910         }
911 
912 
913         uint256 contractTokenBalance = balanceOf(address(this));
914         
915         if(contractTokenBalance >= _maxTxAmount)
916         {
917             contractTokenBalance = _maxTxAmount;
918         }
919         
920         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
921         if (!inSwapAndLiquify
922             && to == lpPair
923             && swapAndLiquifyEnabled
924         ) {
925             if (overMinTokenBalance) {
926                 contractTokenBalance = numTokensSellToAddToLiquidity;
927                 swapAndLiquify(contractTokenBalance);
928             }
929         }
930         
931         bool takeFee = true;
932         
933         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
934             takeFee = false;
935         }
936         
937         _tokenTransfer(from,to,amount,takeFee);
938     }
939 
940     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
941         if (_marketingFee + _liquidityFee == 0)
942             return;
943         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
944         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
945 
946         // split the contract balance into halves
947         uint256 half = toLiquify.div(2);
948         uint256 otherHalf = toLiquify.sub(half);
949 
950         // capture the contract's current ETH balance.
951         // this is so that we can capture exactly the amount of ETH that the
952         // swap creates, and not make the liquidity event include any ETH that
953         // has been manually sent to the contract
954         uint256 initialBalance = address(this).balance;
955 
956         // swap tokens for ETH
957         uint256 toSwapForEth = half.add(toMarketing);
958         swapTokensForEth(toSwapForEth);
959 
960         // how much ETH did we just swap into?
961         uint256 fromSwap = address(this).balance.sub(initialBalance);
962         uint256 liquidityBalance = fromSwap.mul(half).div(toSwapForEth);
963 
964         addLiquidity(otherHalf, liquidityBalance);
965 
966         emit SwapAndLiquify(half, liquidityBalance, otherHalf);
967 
968         _marketingWallet.transfer(fromSwap.sub(liquidityBalance));
969     }
970 
971     function swapTokensForEth(uint256 tokenAmount) private {
972         // generate the uniswap lpPair path of token -> weth
973         address[] memory path = new address[](2);
974         path[0] = address(this);
975         path[1] = dexRouter.WETH();
976 
977         _approve(address(this), address(dexRouter), tokenAmount);
978 
979         // make the swap
980         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
981             tokenAmount,
982             0, // accept any amount of ETH
983             path,
984             address(this),
985             block.timestamp
986         );
987     }
988 
989     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
990         // approve token transfer to cover all possible scenarios
991         _approve(address(this), address(dexRouter), tokenAmount);
992 
993         // add the liquidity
994         dexRouter.addLiquidityETH{value: ethAmount}(
995             address(this),
996             tokenAmount,
997             0, // slippage is unavoidable
998             0, // slippage is unavoidable
999             burnAddress,
1000             block.timestamp
1001         );
1002     }
1003 
1004     function _checkLiquidityAdd(address from, address to) private {
1005         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
1006         if (!_hasLimits(from, to) && to == lpPair) {
1007             _liquidityHolders[from] = true;
1008             _hasLiqBeenAdded = true;
1009             _liqAddBlock = block.number;
1010             _liqAddStamp = block.timestamp;
1011 
1012             swapAndLiquifyEnabled = true;
1013             emit SwapAndLiquifyEnabledUpdated(true);
1014         }
1015     }
1016 
1017     //this method is responsible for taking all fee, if takeFee is true
1018     function _tokenTransfer(address from, address to, uint256 amount,bool takeFee) private {
1019         // Failsafe, disable the whole system if needed.
1020         if (sniperProtection){
1021             // If sender is a sniper address, reject the transfer.
1022             if (isBlacklisted(from) || isBlacklisted(to)) {
1023                 revert("Sniper rejected.");
1024             }
1025 
1026             // Check if this is the liquidity adding tx to startup.
1027             if (!_hasLiqBeenAdded) {
1028                 _checkLiquidityAdd(from, to);
1029                     if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
1030                         revert("Only owner can transfer at this time.");
1031                     }
1032             } else {
1033                 if (_liqAddBlock > 0 
1034                     && from == lpPair 
1035                     && _hasLimits(from, to)
1036                 ) {
1037                     if (block.number - _liqAddBlock < snipeBlockAmt) {
1038                         _isBlacklisted[to] = true;
1039                         snipersCaught ++;
1040                         emit SniperCaught(to);
1041                     }
1042                 }
1043             }
1044         }
1045 
1046         if(!takeFee)
1047             removeAllFee();
1048         
1049         _finalizeTransfer(from, to, amount);
1050         
1051         if(!takeFee)
1052             restoreAllFee();
1053     }
1054 
1055     function _finalizeTransfer(address sender, address recipient, uint256 tAmount) private {
1056         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1057 
1058         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1059         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1060 
1061         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1062             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1063         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1064             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);  
1065         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1066             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1067             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1068         }
1069 
1070         if (tLiquidity > 0)
1071             _takeLiquidity(sender, tLiquidity);
1072         if (rFee > 0 || tFee > 0)
1073             _takeReflect(rFee, tFee);
1074 
1075         emit Transfer(sender, recipient, tTransferAmount);
1076     }
1077 
1078     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1079         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1080         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1081         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1082     }
1083 
1084     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1085         uint256 tFee = calculateTaxFee(tAmount);
1086         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1087         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1088         return (tTransferAmount, tFee, tLiquidity);
1089     }
1090 
1091     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1092         uint256 rAmount = tAmount.mul(currentRate);
1093         uint256 rFee = tFee.mul(currentRate);
1094         uint256 rLiquidity = tLiquidity.mul(currentRate);
1095         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1096         return (rAmount, rTransferAmount, rFee);
1097     }
1098 
1099 
1100     function _getRate() private view returns(uint256) {
1101         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1102         return rSupply.div(tSupply);
1103     }
1104 
1105     function _getCurrentSupply() private view returns(uint256, uint256) {
1106         uint256 rSupply = _rTotal;
1107         uint256 tSupply = _tTotal;      
1108         for (uint256 i = 0; i < _excluded.length; i++) {
1109             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1110             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1111             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1112         }
1113         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1114         return (rSupply, tSupply);
1115     }
1116 
1117     function _takeReflect(uint256 rFee, uint256 tFee) private {
1118         _rTotal = _rTotal.sub(rFee);
1119         _tFeeTotal = _tFeeTotal.add(tFee);
1120     }
1121     
1122     function _takeLiquidity(address sender, uint256 tLiquidity) private {
1123         uint256 currentRate =  _getRate();
1124         uint256 rLiquidity = tLiquidity.mul(currentRate);
1125         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1126         if(_isExcluded[address(this)])
1127             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1128         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
1129     }
1130 
1131     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1132         return _amount.mul(_reflectFee).div(masterTaxDivisor);
1133     }
1134 
1135     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1136         return _amount.mul(_liquidityFee.add(_marketingFee)).div(masterTaxDivisor);
1137     }
1138 
1139     function removeAllFee() private {
1140         if(_reflectFee == 0 && _liquidityFee == 0) return;
1141         
1142         _previousReflectFee = _reflectFee;
1143         _previousLiquidityFee = _liquidityFee;
1144         _previousMarketingFee = _marketingFee;
1145 
1146         _reflectFee = 0;
1147         _liquidityFee = 0;
1148         _marketingFee = 0;
1149     }
1150     
1151     function restoreAllFee() private {
1152         _reflectFee = _previousReflectFee;
1153         _liquidityFee = _previousLiquidityFee;
1154         _marketingFee = _previousMarketingFee;
1155     }
1156 }