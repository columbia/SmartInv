1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity >=0.6.0 <0.9.0;
5 
6 abstract contract Context {
7     function _msgSender() internal view returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18   /**
19    * @dev Returns the amount of tokens in existence.
20    */
21   function totalSupply() external view returns (uint256);
22 
23   /**
24    * @dev Returns the token decimals.
25    */
26   function decimals() external view returns (uint8);
27 
28   /**
29    * @dev Returns the token symbol.
30    */
31   function symbol() external view returns (string memory);
32 
33   /**
34   * @dev Returns the token name.
35   */
36   function name() external view returns (string memory);
37 
38   /**
39    * @dev Returns the bep token owner.
40    */
41   function getOwner() external view returns (address);
42 
43   /**
44    * @dev Returns the amount of tokens owned by `account`.
45    */
46   function balanceOf(address account) external view returns (uint256);
47 
48   /**
49    * @dev Moves `amount` tokens from the caller's account to `recipient`.
50    *
51    * Returns a boolean value indicating whether the operation succeeded.
52    *
53    * Emits a {Transfer} event.
54    */
55   function transfer(address recipient, uint256 amount) external returns (bool);
56 
57   /**
58    * @dev Returns the remaining number of tokens that `spender` will be
59    * allowed to spend on behalf of `owner` through {transferFrom}. This is
60    * zero by default.
61    *
62    * This value changes when {approve} or {transferFrom} are called.
63    */
64   function allowance(address _owner, address spender) external view returns (uint256);
65 
66   /**
67    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68    *
69    * Returns a boolean value indicating whether the operation succeeded.
70    *
71    * IMPORTANT: Beware that changing an allowance with this method brings the risk
72    * that someone may use both the old and the new allowance by unfortunate
73    * transaction ordering. One possible solution to mitigate this race
74    * condition is to first reduce the spender's allowance to 0 and set the
75    * desired value afterwards:
76    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77    *
78    * Emits an {Approval} event.
79    */
80   function approve(address spender, uint256 amount) external returns (bool);
81 
82   /**
83    * @dev Moves `amount` tokens from `sender` to `recipient` using the
84    * allowance mechanism. `amount` is then deducted from the caller's
85    * allowance.
86    *
87    * Returns a boolean value indicating whether the operation succeeded.
88    *
89    * Emits a {Transfer} event.
90    */
91   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93   /**
94    * @dev Emitted when `value` tokens are moved from one account (`from`) to
95    * another (`to`).
96    *
97    * Note that `value` may be zero.
98    */
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 
101   /**
102    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103    * a call to {approve}. `value` is the new allowance.
104    */
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
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
184         // See: https://github.com/OpenZeppelin/bo/r_u/to_in_u/pull/522
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
234      * b*or*ut*o*in*u
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
265 library Address {
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, "Address: insufficient balance");
279 
280         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
281         (bool success, ) = recipient.call{ value: amount }("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
286         return functionCall(target, data, "Address: low-level call failed");
287     }
288 
289     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
290         return _functionCallWithValue(target, data, 0, errorMessage);
291     }
292 
293 
294     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
296     }
297 
298     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
299         require(address(this).balance >= value, "Address: insufficient balance for call");
300         return _functionCallWithValue(target, data, value, errorMessage);
301     }
302 
303     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
304         require(isContract(target), "Address: call to non-contract");
305 
306         // solhint-disable-next-line avoid-low-level-calls
307         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
308         if (success) {
309             return returndata;
310         } else {
311             // Look for revert reason and bubble it up if present
312             if (returndata.length > 0) {
313                 // The easiest way to bubble the revert reason is using memory via assembly
314 
315                 // solhint-disable-next-line no-inline-assembly
316                 assembly {
317                     let returndata_size := mload(returndata)
318                     revert(add(32, returndata), returndata_size)
319                 }
320             } else {
321                 revert(errorMessage);
322             }
323         }
324     }
325 }
326 
327 interface IUniswapV2Factory {
328     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
329     function feeTo() external view returns (address);
330     function feeToSetter() external view returns (address);
331     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
332     function allPairs(uint) external view returns (address lpPair);
333     function allPairsLength() external view returns (uint);
334     function createPair(address tokenA, address tokenB) external returns (address lpPair);
335     function setFeeTo(address) external;
336     function setFeeToSetter(address) external;
337 }
338 
339 interface IUniswapV2Pair {
340     event Approval(address indexed owner, address indexed spender, uint value);
341     event Transfer(address indexed from, address indexed to, uint value);
342 
343     function name() external pure returns (string memory);
344     function symbol() external pure returns (string memory);
345     function decimals() external pure returns (uint8);
346     function totalSupply() external view returns (uint);
347     function balanceOf(address owner) external view returns (uint);
348     function allowance(address owner, address spender) external view returns (uint);
349     function approve(address spender, uint value) external returns (bool);
350     function transfer(address to, uint value) external returns (bool);
351     function transferFrom(address from, address to, uint value) external returns (bool);
352     function DOMAIN_SEPARATOR() external view returns (bytes32);
353     function PERMIT_TYPEHASH() external pure returns (bytes32);
354     function nonces(address owner) external view returns (uint);
355     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
356     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
357     event Swap(
358         address indexed sender,
359         uint amount0In,
360         uint amount1In,
361         uint amount0Out,
362         uint amount1Out,
363         address indexed to
364     );
365     event Sync(uint112 reserve0, uint112 reserve1);
366 
367     function MINIMUM_LIQUIDITY() external pure returns (uint);
368     function factory() external view returns (address);
369     function token0() external view returns (address);
370     function token1() external view returns (address);
371     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
372     function price0CumulativeLast() external view returns (uint);
373     function price1CumulativeLast() external view returns (uint);
374     function kLast() external view returns (uint);
375     function mint(address to) external returns (uint liquidity);
376     function burn(address to) external returns (uint amount0, uint amount1);
377     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
378     function skim(address to) external;
379     function sync() external;
380     function initialize(address, address) external;
381 }
382 
383 interface IUniswapV2Router01 {
384     function factory() external pure returns (address);
385     function WETH() external pure returns (address);
386     function addLiquidity(
387         address tokenA,
388         address tokenB,
389         uint amountADesired,
390         uint amountBDesired,
391         uint amountAMin,
392         uint amountBMin,
393         address to,
394         uint deadline
395     ) external returns (uint amountA, uint amountB, uint liquidity);
396     function addLiquidityETH(
397         address token,
398         uint amountTokenDesired,
399         uint amountTokenMin,
400         uint amountETHMin,
401         address to,
402         uint deadline
403     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
404     function removeLiquidity(
405         address tokenA,
406         address tokenB,
407         uint liquidity,
408         uint amountAMin,
409         uint amountBMin,
410         address to,
411         uint deadline
412     ) external returns (uint amountA, uint amountB);
413     function removeLiquidityETH(
414         address token,
415         uint liquidity,
416         uint amountTokenMin,
417         uint amountETHMin,
418         address to,
419         uint deadline
420     ) external returns (uint amountToken, uint amountETH);
421     function removeLiquidityWithPermit(
422         address tokenA,
423         address tokenB,
424         uint liquidity,
425         uint amountAMin,
426         uint amountBMin,
427         address to,
428         uint deadline,
429         bool approveMax, uint8 v, bytes32 r, bytes32 s
430     ) external returns (uint amountA, uint amountB);
431     function removeLiquidityETHWithPermit(
432         address token,
433         uint liquidity,
434         uint amountTokenMin,
435         uint amountETHMin,
436         address to,
437         uint deadline,
438         bool approveMax, uint8 v, bytes32 r, bytes32 s
439     ) external returns (uint amountToken, uint amountETH);
440     function swapExactTokensForTokens(
441         uint amountIn,
442         uint amountOutMin,
443         address[] calldata path,
444         address to,
445         uint deadline
446     ) external returns (uint[] memory amounts);
447     function swapTokensForExactTokens(
448         uint amountOut,
449         uint amountInMax,
450         address[] calldata path,
451         address to,
452         uint deadline
453     ) external returns (uint[] memory amounts);
454     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
455     external
456     payable
457     returns (uint[] memory amounts);
458     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
459     external
460     returns (uint[] memory amounts);
461     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
462     external
463     returns (uint[] memory amounts);
464     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
465     external
466     payable
467     returns (uint[] memory amounts);
468 
469     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
470     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
471     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
472     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
473     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
474 }
475 
476 interface IUniswapV2Router02 is IUniswapV2Router01 {
477     function removeLiquidityETHSupportingFeeOnTransferTokens(
478         address token,
479         uint liquidity,
480         uint amountTokenMin,
481         uint amountETHMin,
482         address to,
483         uint deadline
484     ) external returns (uint amountETH);
485     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
486         address token,
487         uint liquidity,
488         uint amountTokenMin,
489         uint amountETHMin,
490         address to,
491         uint deadline,
492         bool approveMax, uint8 v, bytes32 r, bytes32 s
493     ) external returns (uint amountETH);
494 
495     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
496         uint amountIn,
497         uint amountOutMin,
498         address[] calldata path,
499         address to,
500         uint deadline
501     ) external;
502     function swapExactETHForTokensSupportingFeeOnTransferTokens(
503         uint amountOutMin,
504         address[] calldata path,
505         address to,
506         uint deadline
507     ) external payable;
508     function swapExactTokensForETHSupportingFeeOnTransferTokens(
509         uint amountIn,
510         uint amountOutMin,
511         address[] calldata path,
512         address to,
513         uint deadline
514     ) external;
515 }
516 
517 abstract contract Ownable is Context {
518     address private _owner;
519 
520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
521 
522     constructor () {
523         address msgSender = _msgSender();
524         _owner = msgSender;
525         emit OwnershipTransferred(address(0), msgSender);
526     }
527 
528     function owner() public view returns (address) {
529         return _owner;
530     }
531 
532     modifier onlyOwner() {
533         require(_owner == _msgSender(), "Ownable: caller is not the owner");
534         _;
535     }
536 
537     function renounceOwnership() public virtual onlyOwner {
538         emit OwnershipTransferred(_owner, address(0));
539         _owner = address(0);
540     }
541 
542     function transferOwnership(address newOwner) public virtual onlyOwner {
543         require(newOwner != address(0), "Ownable: new owner is the zero address");
544         
545         emit OwnershipTransferred(_owner, newOwner);
546         _owner = newOwner;
547     }
548     
549 }
550 
551 contract FULLMETALINU is Context, IERC20, Ownable {
552     using SafeMath for uint256;
553     using Address for address;
554 
555     mapping (address => uint256) private _rOwned;
556     mapping (address => uint256) private _tOwned;
557     mapping (address => mapping (address => uint256)) private _allowances;
558     mapping (address => uint256) private lastTrade;
559 
560     mapping (address => bool) private _isExcludedFromFee;
561     mapping (address => bool) private _isExcluded;
562     address[] private _excluded;
563 
564     mapping (address => bool) private _isBlacklisted;
565     mapping (address => bool) private _liquidityHolders;
566    
567     uint256 private startingSupply = 1_000_000_000_000_000; //1 Quadrillion, underscores aid readability
568    
569     uint256 private constant MAX = ~uint256(0);
570     uint8 private _decimals = 9;
571     uint256 private _decimalsMul = _decimals;
572     uint256 private _tTotal = startingSupply * 10**_decimalsMul;
573     uint256 private _rTotal = (MAX - (MAX % _tTotal));
574     uint256 private _tFeeTotal;
575 
576     string private _name = "FullMetal Inu";
577     string private _symbol = "FMA";
578     
579     uint256 public _reflectFee = 0; // All taxes are divided by 100 for more accuracy.
580     uint256 private _previousReflectFee = _reflectFee;
581     uint256 private maxReflectFee = 800;
582     
583     uint256 public _liquidityFee = 300; // All taxes are divided by 100 for more accuracy.
584     uint256 private _previousLiquidityFee = _liquidityFee;
585     uint256 private maxLiquidityFee = 800;
586 
587     uint256 public _marketingFee = 500; // All taxes are divided by 100 for more accuracy.
588     uint256 private _previousMarketingFee = _marketingFee;
589     uint256 private maxMarketingFee = 800;
590 
591     uint256 private masterTaxDivisor = 10000; // All tax calculations are divided by this number.
592 
593     IUniswapV2Router02 public dexRouter;
594     address public lpPair;
595 
596     // Uniswap Router
597     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
598 
599     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
600     address payable private _marketingWallet = payable(0x2c97E684751b7bfEf540DA13DEd685d59cF0262A);
601     
602     bool inSwapAndLiquify;
603     bool public swapAndLiquifyEnabled = true;
604     
605     // Max TX amount is 0.5% of the total supply.
606     uint256 private maxTxPercent = 5; // Less fields to edit
607     uint256 private maxTxDivisor = 1000;
608     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
609     uint256 private _previousMaxTxAmount = _maxTxAmount;
610     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor; // Actual amount for UI's
611     // Maximum wallet size is 2% of the total supply.
612     uint256 private maxWalletPercent = 2; // Less fields to edit
613     uint256 private maxWalletDivisor = 100;
614     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
615     uint256 private _previousMaxWalletSize = _maxWalletSize;
616     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor; // Actual amount for UI's
617     // 0.05% of Total Supply
618     uint256 private numTokensSellToAddToLiquidity = (_tTotal * 5) / 10000;
619 
620     bool private sniperProtection = true;
621     bool public _hasLiqBeenAdded = false;
622     uint256 private _liqAddBlock = 0;
623     uint256 private _liqAddStamp = 0;
624     uint256 private immutable snipeBlockAmt;
625     uint256 public snipersCaught = 0;
626     bool private gasLimitActive = true;
627     uint256 private gasPriceLimit;
628     bool private sameBlockActive = true;
629     
630     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
631     event SwapAndLiquifyEnabledUpdated(bool enabled);
632     event SwapAndLiquify(
633         uint256 tokensSwapped,
634         uint256 ethReceived,
635         uint256 tokensIntoLiqudity
636     );
637     event SniperCaught(address sniperAddress);
638     
639     modifier lockTheSwap {
640         inSwapAndLiquify = true;
641         _;
642         inSwapAndLiquify = false;
643     }
644     
645     constructor (uint256 _snipeBlockAmt, uint256 _gasPriceLimit) payable {
646         _tOwned[_msgSender()] = _tTotal;
647         _rOwned[_msgSender()] = _rTotal;
648 
649         // Set the amount of blocks to count a sniper.
650         snipeBlockAmt = _snipeBlockAmt;
651         gasPriceLimit = _gasPriceLimit * 1 gwei;
652 
653         IUniswapV2Router02 _dexRouter = IUniswapV2Router02(_routerAddress);
654         lpPair = IUniswapV2Factory(_dexRouter.factory())
655             .createPair(address(this), _dexRouter.WETH());
656 
657         dexRouter = _dexRouter;
658         
659         _isExcludedFromFee[owner()] = true;
660         _isExcludedFromFee[address(this)] = true;
661         _liquidityHolders[owner()] = true;
662         _isExcluded[address(this)] = true;
663         _excluded.push(address(this));
664         _isExcluded[owner()] = true;
665         _excluded.push(owner());
666         _isExcluded[burnAddress] = true;
667         _excluded.push(burnAddress);
668         _isExcluded[_marketingWallet] = true;
669         _excluded.push(_marketingWallet);
670         _isExcluded[lpPair] = true;
671         _excluded.push(lpPair);
672         // DxLocker Address (BSC)
673         _isExcludedFromFee[0x8BF418C4C734F85A8D0b51c37B2d92373906fEb2] = true;
674         _isExcluded[0x8BF418C4C734F85A8D0b51c37B2d92373906fEb2] = true;
675         _excluded.push(0x8BF418C4C734F85A8D0b51c37B2d92373906fEb2);
676 
677         // Approve the owner for PancakeSwap, timesaver.
678         _approve(_msgSender(), _routerAddress, _tTotal);
679 
680         // Ever-growing sniper/tool blacklist
681 	_isBlacklisted[0xE4882975f933A199C92b5A925C9A8fE65d599Aa8] = true;
682         _isBlacklisted[0x86C70C4a3BC775FB4030448c9fdb73Dc09dd8444] = true;
683         _isBlacklisted[0xa4A25AdcFCA938aa030191C297321323C57148Bd] = true;
684         _isBlacklisted[0x20C00AFf15Bb04cC631DB07ee9ce361ae91D12f8] = true;
685         _isBlacklisted[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
686         _isBlacklisted[0xa76e2294d3FeEfaCd17e1ad4d0971a50685FF3A5] = true;
687         _isBlacklisted[0xB995Ec6e8292C1b4ff1e2E0D354789a5A136DcfA] = true;
688         _isBlacklisted[0x9b61312263D804F7bcCC66492BAc6eDE8bE2DFb6] = true;
689         _isBlacklisted[0x0E388888309d64e97F97a4740EC9Ed3DADCA71be] = true;
690         _isBlacklisted[0x93a2d57088BC7ad7C69feEE402E753606d045237] = true;
691         _isBlacklisted[0x6932a1C9276b0dF81edadC818c9D5157f1Bbc6E0] = true;
692         _isBlacklisted[0x3233b0919fe9BE5E289446c26C7322Cbc464838b] = true;
693         _isBlacklisted[0xed0c2fFAfbF2e337680CcB6255C44b19C8F586e5] = true;
694         _isBlacklisted[0x925ED3529f6fF3913278C5B3B1C103dD3c4Bdd16] = true;
695         _isBlacklisted[0x9e1a9C8202777B251A17bf288A2a0903EF5d9885] = true;
696         _isBlacklisted[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
697         _isBlacklisted[0x9560A38F4F7E52AF49B0BE4033450198Ca88d81b] = true;
698         _isBlacklisted[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
699         _isBlacklisted[0x6077831872bbB434960a28991B941cC2f26a84Aa] = true;
700         _isBlacklisted[0x2336b2eCE8103c80fA823C9387de8Da8Cce7E2a4] = true;
701         _isBlacklisted[0x2336b2eCE8103c80fA823C9387de8Da8Cce7E2a4] = true;
702         _isBlacklisted[0xde594D578E98533D3663027E4AA3Ba976442dB40] = true;
703         _isBlacklisted[0x3DfbbFDBD20754BB3489dC4FD955719be61FF755] = true;
704         _isBlacklisted[0x549cdf92D66C648A563CAC307Ea03F12E3835d8C] = true;
705         _isBlacklisted[0x6faA2Bb2f1125A1AD4a6551631C1f85DDD39b21a] = true;
706         _isBlacklisted[0x4Db61B50607086483eA59810e05f3E2F2384a748] = true;
707         _isBlacklisted[0xeA1079a114afCD0d7Ffe2171A070D93191913bc6] = true;
708         _isBlacklisted[0x6077831872bbB434960a28991B941cC2f26a84Aa] = true;
709         _isBlacklisted[0x2336b2eCE8103c80fA823C9387de8Da8Cce7E2a4] = true;
710         _isBlacklisted[0xde594D578E98533D3663027E4AA3Ba976442dB40] = true;
711         _isBlacklisted[0xeA1079a114afCD0d7Ffe2171A070D93191913bc6] = true;
712         _isBlacklisted[0x93a2d57088BC7ad7C69feEE402E753606d045237] = true;
713         _isBlacklisted[0x4Db61B50607086483eA59810e05f3E2F2384a748] = true;
714         _isBlacklisted[0x6faA2Bb2f1125A1AD4a6551631C1f85DDD39b21a] = true;
715         _isBlacklisted[0x3DfbbFDBD20754BB3489dC4FD955719be61FF755] = true;
716         _isBlacklisted[0x2AC6C749B0d9a4908D935Bb26B0dDCbc7a9F76C6] = true;
717         _isBlacklisted[0xde594D578E98533D3663027E4AA3Ba976442dB40] = true;
718         _isBlacklisted[0x50A77964D208b5cA4B86B8EaB5E9b8C10bb70390] = true;
719         _isBlacklisted[0xeA1079a114afCD0d7Ffe2171A070D93191913bc6] = true;
720         _isBlacklisted[0x93a2d57088BC7ad7C69feEE402E753606d045237] = true;
721         _isBlacklisted[0x4Db61B50607086483eA59810e05f3E2F2384a748] = true;
722         _isBlacklisted[0x6faA2Bb2f1125A1AD4a6551631C1f85DDD39b21a] = true;
723         _isBlacklisted[0x3DfbbFDBD20754BB3489dC4FD955719be61FF755] = true;
724         _isBlacklisted[0x00000000003b3cc22aF3aE1EAc0440BcEe416B40] = true;
725         _isBlacklisted[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
726         _isBlacklisted[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
727         _isBlacklisted[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
728         _isBlacklisted[0x3066Cc1523dE539D36f94597e233719727599693] = true;
729         _isBlacklisted[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
730         _isBlacklisted[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
731         _isBlacklisted[0x201044fa39866E6dD3552D922CDa815899F63f20] = true;
732         _isBlacklisted[0x6F3aC41265916DD06165b750D88AB93baF1a11F8] = true;
733         _isBlacklisted[0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6] = true;
734         _isBlacklisted[0xDEF441C00B5Ca72De73b322aA4e5FE2b21D2D593] = true;
735         _isBlacklisted[0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418] = true;
736         _isBlacklisted[0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40] = true;
737         _isBlacklisted[0x7e2b3808cFD46fF740fBd35C584D67292A407b95] = true;
738         _isBlacklisted[0xe89C7309595E3e720D8B316F065ecB2730e34757] = true;
739         _isBlacklisted[0x725AD056625326B490B128E02759007BA5E4eBF1] = true;
740 
741         emit Transfer(address(0), _msgSender(), _tTotal);
742     }
743 
744     function totalSupply() external view override returns (uint256) { return _tTotal; }
745     function decimals() external view override returns (uint8) { return _decimals; }
746     function symbol() external view override returns (string memory) { return _symbol; }
747     function name() external view override returns (string memory) { return _name; }
748     function getOwner() external view override returns (address) { return owner(); }
749     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
750 
751     function balanceOf(address account) public view override returns (uint256) {
752         if (_isExcluded[account]) return _tOwned[account];
753         return tokenFromReflection(_rOwned[account]);
754     }
755 
756     function transfer(address recipient, uint256 amount) public override returns (bool) {
757         _transfer(_msgSender(), recipient, amount);
758         return true;
759     }
760 
761     function approve(address spender, uint256 amount) public override returns (bool) {
762         _approve(_msgSender(), spender, amount);
763         return true;
764     }
765 
766     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
767         _transfer(sender, recipient, amount);
768         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
769         return true;
770     }
771 
772     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
773         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
774         return true;
775     }
776 
777     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
778         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
779         return true;
780     }
781 
782     function isExcludedFromReward(address account) public view returns (bool) {
783         return _isExcluded[account];
784     }
785 
786     function isExcludedFromFee(address account) public view returns(bool) {
787         return _isExcludedFromFee[account];
788     }
789 
790     function isBlacklisted(address account) public view returns (bool) {
791         return _isBlacklisted[account];
792     }
793 
794     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
795         _isBlacklisted[account] = enabled;
796     }
797 
798     function setProtectionSettings(bool antiSnipe, bool antiGas, bool antiBlock) external onlyOwner() {
799         sniperProtection = antiSnipe;
800         gasLimitActive = antiGas;
801         sameBlockActive = antiBlock;
802     }
803     
804     function setTaxFeePercent(uint256 reflectFee) external onlyOwner() {
805         _reflectFee = reflectFee;
806     }
807     
808     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
809         _liquidityFee = liquidityFee;
810     }
811 
812     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
813         _marketingFee = marketingFee;
814     }
815 
816     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner() {
817         _maxTxAmount = _tTotal.mul(percent).div(divisor);
818         maxTxAmountUI = startingSupply.mul(percent).div(divisor);
819     }
820 
821     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner() {
822         _maxWalletSize = _tTotal.mul(percent).div(divisor);
823         maxWalletSizeUI = startingSupply.mul(percent).div(divisor);
824     }
825 
826     function setMarketingWallet(address payable newWallet) external onlyOwner {
827         _marketingWallet = payable(newWallet);
828     }
829 
830     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
831         swapAndLiquifyEnabled = _enabled;
832         emit SwapAndLiquifyEnabledUpdated(_enabled);
833     }
834 
835     function excludeFromFee(address account) public onlyOwner {
836         _isExcludedFromFee[account] = true;
837     }
838     
839     function includeInFee(address account) external onlyOwner {
840         _isExcludedFromFee[account] = false;
841     }
842 
843     function totalFees() public view returns (uint256) {
844         return _tFeeTotal;
845     }
846 
847     function setGasPriceLimit(uint256 gas) external onlyOwner {
848         require(gas >= 150);
849         gasPriceLimit = gas * 1 gwei;
850     }
851 
852     function _hasLimits(address from, address to) private view returns (bool) {
853         return from != owner()
854             && to != owner()
855             && !_liquidityHolders[to]
856             && !_liquidityHolders[from]
857             && to != burnAddress
858             && to != address(0)
859             && from != address(this);
860     }
861 
862     function deliver(uint256 tAmount) public {
863         address sender = _msgSender();
864         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
865         (uint256 rAmount,,,,,) = _getValues(tAmount);
866         _rOwned[sender] = _rOwned[sender].sub(rAmount);
867         _rTotal = _rTotal.sub(rAmount);
868         _tFeeTotal = _tFeeTotal.add(tAmount);
869     }
870 
871     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
872         require(tAmount <= _tTotal, "Amount must be less than supply");
873         if (!deductTransferFee) {
874             (uint256 rAmount,,,,,) = _getValues(tAmount);
875             return rAmount;
876         } else {
877             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
878             return rTransferAmount;
879         }
880     }
881 
882     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
883         require(rAmount <= _rTotal, "Amount must be less than total reflections");
884         uint256 currentRate =  _getRate();
885         return rAmount.div(currentRate);
886     }
887 
888     function excludeFromReward(address account) public onlyOwner() {
889         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
890         require(!_isExcluded[account], "Account is already excluded");
891         if(_rOwned[account] > 0) {
892             _tOwned[account] = tokenFromReflection(_rOwned[account]);
893         }
894         _isExcluded[account] = true;
895         _excluded.push(account);
896     }
897 
898     function includeInReward(address account) external onlyOwner() {
899         require(_isExcluded[account], "Account is already excluded");
900         for (uint256 i = 0; i < _excluded.length; i++) {
901             if (_excluded[i] == account) {
902                 _excluded[i] = _excluded[_excluded.length - 1];
903                 _tOwned[account] = 0;
904                 _isExcluded[account] = false;
905                 _excluded.pop();
906                 break;
907             }
908         }
909     }
910     
911      //to recieve ETH from dexRouter when swaping
912     receive() external payable {}
913 
914     function _approve(address owner, address spender, uint256 amount) private {
915         require(owner != address(0), "ERC20: approve from the zero address");
916         require(spender != address(0), "ERC20: approve to the zero address");
917 
918         _allowances[owner][spender] = amount;
919         emit Approval(owner, spender, amount);
920     }
921 
922     function _transfer(
923         address from
924 ,        address to,
925         uint256 amount
926     ) private {
927         require(from != address(0), "ERC20: transfer from the zero address");
928         require(to != address(0), "ERC20: transfer to the zero address");
929         require(amount > 0, "Transfer amount must be greater than zero");
930         if (gasLimitActive) {
931             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
932         }
933         if(_hasLimits(from, to)) {
934             if (sameBlockActive) {
935                 if (from == lpPair){
936                     require(lastTrade[to] != block.number);
937                     lastTrade[to] = block.number;
938                 } else {
939                     require(lastTrade[from] != block.number);
940                     lastTrade[from] = block.number;
941                 }
942             }
943             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
944             if(to != _routerAddress && to != lpPair) {
945                 uint256 contractBalanceRecepient = balanceOf(to);
946                 require(contractBalanceRecepient + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
947             }
948         }
949 
950 
951         uint256 contractTokenBalance = balanceOf(address(this));
952         
953         if(contractTokenBalance >= _maxTxAmount)
954         {
955             contractTokenBalance = _maxTxAmount;
956         }
957         
958         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
959         if (!inSwapAndLiquify
960             && to == lpPair
961             && swapAndLiquifyEnabled
962         ) {
963             if (overMinTokenBalance) {
964                 contractTokenBalance = numTokensSellToAddToLiquidity;
965                 swapAndLiquify(contractTokenBalance);
966             }
967         }
968         
969         bool takeFee = true;
970         
971         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
972             takeFee = false;
973         }
974         
975         _tokenTransfer(from,to,amount,takeFee);
976     }
977 
978     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
979         if (_marketingFee + _liquidityFee == 0)
980             return;
981         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
982         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
983 
984         // split the contract balance into halves
985         uint256 half = toLiquify.div(2);
986         uint256 otherHalf = toLiquify.sub(half);
987 
988         // capture the contract's current ETH balance.
989         // this is so that we can capture exactly the amount of ETH that the
990         // swap creates, and not make the liquidity event include any ETH that
991         // has been manually sent to the contract
992         uint256 initialBalance = address(this).balance;
993 
994         // swap tokens for ETH
995         uint256 toSwapForEth = half.add(toMarketing);
996         swapTokensForEth(toSwapForEth);
997 
998         // how much ETH did we just swap into?
999         uint256 fromSwap = address(this).balance.sub(initialBalance);
1000         uint256 liquidityBalance = fromSwap.mul(half).div(toSwapForEth);
1001 
1002         addLiquidity(otherHalf, liquidityBalance);
1003 
1004         emit SwapAndLiquify(half, liquidityBalance, otherHalf);
1005 
1006         _marketingWallet.transfer(fromSwap.sub(liquidityBalance));
1007     }
1008 
1009     function swapTokensForEth(uint256 tokenAmount) private {
1010         // generate the uniswap lpPair path of token -> weth
1011         address[] memory path = new address[](2);
1012         path[0] = address(this);
1013         path[1] = dexRouter.WETH();
1014 
1015         _approve(address(this), address(dexRouter), tokenAmount);
1016 
1017         // make the swap
1018         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1019             tokenAmount,
1020             0, // accept any amount of ETH
1021             path,
1022             address(this),
1023             block.timestamp
1024         );
1025     }
1026 
1027     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1028         // approve token transfer to cover all possible scenarios
1029         _approve(address(this), address(dexRouter), tokenAmount);
1030 
1031         // add the liquidity
1032         dexRouter.addLiquidityETH{value: ethAmount}(
1033             address(this),
1034             tokenAmount,
1035             0, // slippage is unavoidable
1036             0, // slippage is unavoidable
1037             burnAddress,
1038             block.timestamp
1039         );
1040     }
1041 
1042     function _checkLiquidityAdd(address from, address to) private {
1043         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
1044         if (!_hasLimits(from, to) && to == lpPair) {
1045             _liquidityHolders[from] = true;
1046             _hasLiqBeenAdded = true;
1047             _liqAddBlock = block.number;
1048             _liqAddStamp = block.timestamp;
1049 
1050             swapAndLiquifyEnabled = true;
1051             emit SwapAndLiquifyEnabledUpdated(true);
1052         }
1053     }
1054 
1055     //this method is responsible for taking all fee, if takeFee is true
1056     function _tokenTransfer(address from, address to, uint256 amount,bool takeFee) private {
1057         // Failsafe, disable the whole system if needed.
1058         if (sniperProtection){
1059             // If sender is a sniper address, reject the transfer.
1060             if (isBlacklisted(from) || isBlacklisted(to)) {
1061                 revert("Sniper rejected.");
1062             }
1063 
1064             // Check if this is the liquidity adding tx to startup.
1065             if (!_hasLiqBeenAdded) {
1066                 _checkLiquidityAdd(from, to);
1067                     if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
1068                         revert("Only owner can transfer at this time.");
1069                     }
1070             } else {
1071                 if (_liqAddBlock > 0 
1072                     && from == lpPair 
1073                     && _hasLimits(from, to)
1074                 ) {
1075                     if (block.number - _liqAddBlock < snipeBlockAmt) {
1076                         _isBlacklisted[to] = true;
1077                         snipersCaught ++;
1078                         emit SniperCaught(to);
1079                     }
1080                 }
1081             }
1082         }
1083 
1084         if(!takeFee)
1085             removeAllFee();
1086         
1087         _finalizeTransfer(from, to, amount);
1088         
1089         if(!takeFee)
1090             restoreAllFee();
1091     }
1092 
1093     function _finalizeTransfer(address sender, address recipient, uint256 tAmount) private {
1094         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1095 
1096         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1097         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1098 
1099         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1100             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1101         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1102             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);  
1103         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1104             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1105             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1106         }
1107 
1108         if (tLiquidity > 0)
1109             _takeLiquidity(sender, tLiquidity);
1110         if (rFee > 0 || tFee > 0)
1111             _takeReflect(rFee, tFee);
1112 
1113         emit Transfer(sender, recipient, tTransferAmount);
1114     }
1115 
1116     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1117         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1118         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1119         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1120     }
1121 
1122     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1123         uint256 tFee = calculateTaxFee(tAmount);
1124         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1125         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1126         return (tTransferAmount, tFee, tLiquidity);
1127     }
1128 
1129     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1130         uint256 rAmount = tAmount.mul(currentRate);
1131         uint256 rFee = tFee.mul(currentRate);
1132         uint256 rLiquidity = tLiquidity.mul(currentRate);
1133         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1134         return (rAmount, rTransferAmount, rFee);
1135     }
1136 
1137 
1138     function _getRate() private view returns(uint256) {
1139         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1140         return rSupply.div(tSupply);
1141     }
1142 
1143     function _getCurrentSupply() private view returns(uint256, uint256) {
1144         uint256 rSupply = _rTotal;
1145         uint256 tSupply = _tTotal;      
1146         for (uint256 i = 0; i < _excluded.length; i++) {
1147             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1148             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1149             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1150         }
1151         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1152         return (rSupply, tSupply);
1153     }
1154 
1155     function _takeReflect(uint256 rFee, uint256 tFee) private {
1156         _rTotal = _rTotal.sub(rFee);
1157         _tFeeTotal = _tFeeTotal.add(tFee);
1158     }
1159     
1160     function _takeLiquidity(address sender, uint256 tLiquidity) private {
1161         uint256 currentRate =  _getRate();
1162         uint256 rLiquidity = tLiquidity.mul(currentRate);
1163         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1164         if(_isExcluded[address(this)])
1165             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1166         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
1167     }
1168 
1169     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1170         return _amount.mul(_reflectFee).div(masterTaxDivisor);
1171     }
1172 
1173     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1174         return _amount.mul(_liquidityFee.add(_marketingFee)).div(masterTaxDivisor);
1175     }
1176 
1177     function removeAllFee() private {
1178         if(_reflectFee == 0 && _liquidityFee == 0) return;
1179         
1180         _previousReflectFee = _reflectFee;
1181         _previousLiquidityFee = _liquidityFee;
1182         _previousMarketingFee = _marketingFee;
1183 
1184         _reflectFee = 0;
1185         _liquidityFee = 0;
1186         _marketingFee = 0;
1187     }
1188     
1189     function restoreAllFee() private {
1190         _reflectFee = _previousReflectFee;
1191         _liquidityFee = _previousLiquidityFee;
1192         _marketingFee = _previousMarketingFee;
1193     }
1194 }