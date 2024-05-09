1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.10;
3 
4 interface IBEP20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b > a) return (false, 0);
37             return (true, a - b);
38         }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a % b);
79         }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         unchecked {
169             require(b <= a, errorMessage);
170             return a - b;
171         }
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
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
191         unchecked {
192             require(b > 0, errorMessage);
193             return a / b;
194         }
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         unchecked {
214             require(b > 0, errorMessage);
215             return a % b;
216         }
217     }
218 }
219 
220 
221 abstract contract Context {
222     function _msgSender() internal view virtual returns (address) {
223         return msg.sender;
224     }
225 
226     function _msgData() internal view virtual returns (bytes memory) {
227         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
228         return msg.data;
229     }
230 }
231 
232 abstract contract Ownable is Context {
233     address private _owner;
234 
235     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237     /**
238      * @dev Initializes the contract setting the deployer as the initial owner.
239      */
240     constructor() {
241         _transferOwnership(_msgSender());
242     }
243 
244     /**
245      * @dev Returns the address of the current owner.
246      */
247     function owner() public view virtual returns (address) {
248         return _owner;
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         require(owner() == _msgSender(), "Ownable: caller is not the owner");
256         _;
257     }
258 
259     /**
260      * @dev Leaves the contract without owner. It will not be possible to call
261      * `onlyOwner` functions anymore. Can only be called by the current owner.
262      *
263      * NOTE: Renouncing ownership will leave the contract without an owner,
264      * thereby removing any functionality that is only available to the owner.
265      */
266     function renounceOwnership() public virtual onlyOwner {
267         _transferOwnership(address(0));
268     }
269 
270     /**
271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
272      * Can only be called by the current owner.
273      */
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(newOwner != address(0), "Ownable: new owner is the zero address");
276         _transferOwnership(newOwner);
277     }
278 
279     /**
280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
281      * Internal function without access restriction.
282      */
283     function _transferOwnership(address newOwner) internal virtual {
284         address oldOwner = _owner;
285         _owner = newOwner;
286         emit OwnershipTransferred(oldOwner, newOwner);
287     }
288 }
289 
290 interface IUniswapV2Factory {
291     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
292 
293     function feeTo() external view returns (address);
294     function feeToSetter() external view returns (address);
295 
296     function getPair(address tokenA, address tokenB) external view returns (address pair);
297     function allPairs(uint) external view returns (address pair);
298     function allPairsLength() external view returns (uint);
299 
300     function createPair(address tokenA, address tokenB) external returns (address pair);
301 
302     function setFeeTo(address) external;
303     function setFeeToSetter(address) external;
304 }
305 
306 interface IUniswapV2Pair {
307     event Approval(address indexed owner, address indexed spender, uint value);
308     event Transfer(address indexed from, address indexed to, uint value);
309 
310     function name() external pure returns (string memory);
311     function symbol() external pure returns (string memory);
312     function decimals() external pure returns (uint8);
313     function totalSupply() external view returns (uint);
314     function balanceOf(address owner) external view returns (uint);
315     function allowance(address owner, address spender) external view returns (uint);
316 
317     function approve(address spender, uint value) external returns (bool);
318     function transfer(address to, uint value) external returns (bool);
319     function transferFrom(address from, address to, uint value) external returns (bool);
320 
321     function DOMAIN_SEPARATOR() external view returns (bytes32);
322     function PERMIT_TYPEHASH() external pure returns (bytes32);
323     function nonces(address owner) external view returns (uint);
324 
325     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
326 
327     event Mint(address indexed sender, uint amount0, uint amount1);
328     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
329     event Swap(
330         address indexed sender,
331         uint amount0In,
332         uint amount1In,
333         uint amount0Out,
334         uint amount1Out,
335         address indexed to
336     );
337     event Sync(uint112 reserve0, uint112 reserve1);
338 
339     function MINIMUM_LIQUIDITY() external pure returns (uint);
340     function factory() external view returns (address);
341     function token0() external view returns (address);
342     function token1() external view returns (address);
343     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
344     function price0CumulativeLast() external view returns (uint);
345     function price1CumulativeLast() external view returns (uint);
346     function kLast() external view returns (uint);
347 
348     function mint(address to) external returns (uint liquidity);
349     function burn(address to) external returns (uint amount0, uint amount1);
350     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
351     function skim(address to) external;
352     function sync() external;
353 
354     function initialize(address, address) external;
355 }
356 
357 interface IUniswapV2Router01 {
358     function factory() external pure returns (address);
359     function WETH() external pure returns (address);
360 
361     function addLiquidity(
362         address tokenA,
363         address tokenB,
364         uint amountADesired,
365         uint amountBDesired,
366         uint amountAMin,
367         uint amountBMin,
368         address to,
369         uint deadline
370     ) external returns (uint amountA, uint amountB, uint liquidity);
371     function addLiquidityETH(
372         address token,
373         uint amountTokenDesired,
374         uint amountTokenMin,
375         uint amountETHMin,
376         address to,
377         uint deadline
378     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
379     function removeLiquidity(
380         address tokenA,
381         address tokenB,
382         uint liquidity,
383         uint amountAMin,
384         uint amountBMin,
385         address to,
386         uint deadline
387     ) external returns (uint amountA, uint amountB);
388     function removeLiquidityETH(
389         address token,
390         uint liquidity,
391         uint amountTokenMin,
392         uint amountETHMin,
393         address to,
394         uint deadline
395     ) external returns (uint amountToken, uint amountETH);
396     function removeLiquidityWithPermit(
397         address tokenA,
398         address tokenB,
399         uint liquidity,
400         uint amountAMin,
401         uint amountBMin,
402         address to,
403         uint deadline,
404         bool approveMax, uint8 v, bytes32 r, bytes32 s
405     ) external returns (uint amountA, uint amountB);
406     function removeLiquidityETHWithPermit(
407         address token,
408         uint liquidity,
409         uint amountTokenMin,
410         uint amountETHMin,
411         address to,
412         uint deadline,
413         bool approveMax, uint8 v, bytes32 r, bytes32 s
414     ) external returns (uint amountToken, uint amountETH);
415     function swapExactTokensForTokens(
416         uint amountIn,
417         uint amountOutMin,
418         address[] calldata path,
419         address to,
420         uint deadline
421     ) external returns (uint[] memory amounts);
422     function swapTokensForExactTokens(
423         uint amountOut,
424         uint amountInMax,
425         address[] calldata path,
426         address to,
427         uint deadline
428     ) external returns (uint[] memory amounts);
429     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
430         external
431         payable
432         returns (uint[] memory amounts);
433     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
434         external
435         returns (uint[] memory amounts);
436     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
437         external
438         returns (uint[] memory amounts);
439     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
440         external
441         payable
442         returns (uint[] memory amounts);
443 
444     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
445     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
446     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
447     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
448     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
449 }
450 
451 interface IUniswapV2Router02 is IUniswapV2Router01 {
452     function removeLiquidityETHSupportingFeeOnTransferTokens(
453         address token,
454         uint liquidity,
455         uint amountTokenMin,
456         uint amountETHMin,
457         address to,
458         uint deadline
459     ) external returns (uint amountETH);
460     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
461         address token,
462         uint liquidity,
463         uint amountTokenMin,
464         uint amountETHMin,
465         address to,
466         uint deadline,
467         bool approveMax, uint8 v, bytes32 r, bytes32 s
468     ) external returns (uint amountETH);
469 
470     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
471         uint amountIn,
472         uint amountOutMin,
473         address[] calldata path,
474         address to,
475         uint deadline
476     ) external;
477     function swapExactETHForTokensSupportingFeeOnTransferTokens(
478         uint amountOutMin,
479         address[] calldata path,
480         address to,
481         uint deadline
482     ) external payable;
483     function swapExactTokensForETHSupportingFeeOnTransferTokens(
484         uint amountIn,
485         uint amountOutMin,
486         address[] calldata path,
487         address to,
488         uint deadline
489     ) external;
490 }
491 
492 
493 contract VacuumCoin is Context, IBEP20, Ownable {
494     using SafeMath for uint256;
495 
496     mapping (address => uint256) private _rOwned;
497     mapping (address => uint256) private _tOwned;
498     mapping (address => bool) private _isExcludedFromFee;
499     mapping (address => bool) private _isExcluded;
500     mapping (address => mapping (address => uint256)) private _allowances;
501     mapping (address => bool) public _isExcludedFromAutoLiquidity;
502 
503     address[] private _excluded;
504     address public _marketingWallet = 0xAC384287797DD6698461C6a178cAEfd723eaa645;
505 
506     string private constant _name     = "Vacuum Coin";
507     string private constant _symbol   = "VC";
508     uint8 private constant _decimals = 9;
509 
510     uint256 private constant MAX = ~uint256(0);
511     uint256 private constant _tTotal = 2997924580 * 10 ** _decimals;
512     uint256 private _rTotal = (MAX - (MAX % _tTotal));
513     uint256 private _tFeeTotal;
514 
515     uint256 public taxFee = 1;
516     uint256 public liquidityFee = 2;
517     uint256 public percentageOfLiquidityForMarketing = 100;
518     uint256 public maxWalletToken = _tTotal * 2 / 100;
519     uint256 public maxTxAmount     = _tTotal / 100;
520     uint256 private _minTokenBalance = _tTotal * 5 / 1000;
521 
522     bool public limitsInEffect = true;
523     bool public tradingActive = false;
524     bool public swapEnabled = false;
525     bool _inSwapAndLiquify;
526     IUniswapV2Router02 public _uniswapV2Router;
527     address            public _uniswapV2Pair;
528     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
529     event SwapAndLiquifyEnabledUpdated(bool enabled);
530     event SwapAndLiquify(
531         uint256 tokensSwapped,
532         uint256 bnbReceived,
533         uint256 tokensIntoLiqudity
534     );
535     event MarketingFeeSent(address to, uint256 bnbSent);
536 
537     modifier lockTheSwap {
538         _inSwapAndLiquify = true;
539         _;
540         _inSwapAndLiquify = false;
541     }
542 
543     constructor () {
544         _rOwned[msg.sender] = _rTotal;
545 
546         // uniswap
547         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
548         _uniswapV2Router = uniswapV2Router;
549         _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
550             .createPair(address(this), uniswapV2Router.WETH());
551 
552         // exclude system contracts
553         _isExcludedFromFee[msg.sender] = true;
554         _isExcludedFromFee[address(this)] = true;
555         _isExcludedFromFee[_marketingWallet] = true;
556 
557         _isExcludedFromAutoLiquidity[_uniswapV2Pair]            = true;
558         _isExcludedFromAutoLiquidity[address(_uniswapV2Router)] = true;
559 
560         emit Transfer(address(0), msg.sender, _tTotal);
561     }
562 
563     function name() public pure returns (string memory) {
564         return _name;
565     }
566 
567     function symbol() public pure returns (string memory) {
568         return _symbol;
569     }
570 
571     function decimals() public pure returns (uint8) {
572         return _decimals;
573     }
574 
575     function totalSupply() public pure override returns (uint256) {
576         return _tTotal;
577     }
578 
579     function balanceOf(address account) public view override returns (uint256) {
580         if (_isExcluded[account]) return _tOwned[account];
581         return tokenFromReflection(_rOwned[account]);
582     }
583 
584     function transfer(address recipient, uint256 amount) public override returns (bool) {
585         _transfer(_msgSender(), recipient, amount);
586         return true;
587     }
588 
589     function allowance(address owner, address spender) public view override returns (uint256) {
590         return _allowances[owner][spender];
591     }
592 
593     function approve(address spender, uint256 amount) public override returns (bool) {
594         _approve(_msgSender(), spender, amount);
595         return true;
596     }
597 
598     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
599         _transfer(sender, recipient, amount);
600         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
601         return true;
602     }
603 
604     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
605         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
606         return true;
607     }
608 
609     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
610         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
611         return true;
612     }
613 
614     function isExcludedFromReward(address account) public view returns (bool) {
615         return _isExcluded[account];
616     }
617 
618     function totalFees() public view returns (uint256) {
619         return _tFeeTotal;
620     }
621 
622     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
623         require(tAmount <= _tTotal, "Amount must be less than supply");
624         (, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
625         uint256 currentRate = _getRate();
626 
627         if (!deductTransferFee) {
628             (uint256 rAmount,,) = _getRValues(tAmount, tFee, tLiquidity, currentRate);
629             return rAmount;
630 
631         } else {
632             (, uint256 rTransferAmount,) = _getRValues(tAmount, tFee, tLiquidity, currentRate);
633             return rTransferAmount;
634         }
635     }
636 
637     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
638         require(rAmount <= _rTotal, "Amount must be less than total reflections");
639 
640         uint256 currentRate = _getRate();
641         return rAmount.div(currentRate);
642     }
643 
644     // once enabled, can never be turned off
645     function enableTrading() external onlyOwner {
646         require(!tradingActive, "Trading is already enabled");
647         tradingActive = true;
648         swapEnabled = true;
649     }
650 
651     // remove limits after token is stable
652     function removeLimits() external onlyOwner {
653         limitsInEffect = false;
654     }
655 
656     function excludeFromReward(address account) external onlyOwner {
657         require(!_isExcluded[account], "Account is already excluded");
658 
659         if (_rOwned[account] > 0) {
660             _tOwned[account] = tokenFromReflection(_rOwned[account]);
661         }
662         _isExcluded[account] = true;
663         _excluded.push(account);
664     }
665 
666     function includeInReward(address account) external onlyOwner {
667         require(_isExcluded[account], "Account is already excluded");
668 
669         for (uint256 i = 0; i < _excluded.length; i++) {
670             if (_excluded[i] == account) {
671                 _excluded[i] = _excluded[_excluded.length - 1];
672                 _tOwned[account] = 0;
673                 _isExcluded[account] = false;
674                 _excluded.pop();
675                 break;
676             }
677         }
678     }
679 
680     function setMarketingWallet(address marketingWallet) external onlyOwner {
681         _marketingWallet = marketingWallet;
682     }
683     
684     function setMinimumTokenBalance (uint256 minimumToken) external onlyOwner {
685         _minTokenBalance = minimumToken;
686     }
687     function setExcludedFromFee(address account, bool e) external onlyOwner {
688         _isExcludedFromFee[account] = e;
689     }
690 
691     function setTaxFeePercent(uint256 amount) external onlyOwner {
692         require(amount <= 4, "Holder Reflection cannot exceed 4%");
693         taxFee = amount;
694     }
695 
696     function setLiquidityFeePercent(uint256 amount) external onlyOwner {
697         require(amount <= 6, "Liquidity Fee cannot exceed 6%");
698         liquidityFee = amount;
699     }
700 
701     function setPercentageOfLiquidityForMarketing(uint256 marketingFee) external onlyOwner {
702         require(marketingFee <= 100, "Percent cannot exceed 100%");
703         percentageOfLiquidityForMarketing = marketingFee;
704     }
705 
706     function setMaxWalletTokens(uint256 amount) external onlyOwner {
707         require(amount >= _tTotal / 100, "Cannot set maxTransactionAmount lower than 1%");
708   	    maxWalletToken = amount ;
709   	}
710 
711     function setMaxTxAmount(uint256 amount) external onlyOwner {
712         require(amount >= _tTotal * 5 / 1000, "Cannot set maxTransactionAmount lower than 0.5%");
713         maxTxAmount = amount;
714     }
715 
716     function setSwapAndLiquifyEnabled(bool enabled) external onlyOwner {
717         swapEnabled = enabled;
718         emit SwapAndLiquifyEnabledUpdated(enabled);
719     }
720 
721     receive() external payable {}
722 
723     function setUniswapRouter(address r) external onlyOwner {
724         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(r);
725         _uniswapV2Router = uniswapV2Router;
726     }
727 
728     function setUniswapPair(address p) external onlyOwner {
729         _uniswapV2Pair = p;
730     }
731 
732     function setExcludedFromAutoLiquidity(address a, bool b) external onlyOwner {
733         _isExcludedFromAutoLiquidity[a] = b;
734     }
735 
736     function _reflectFee(uint256 rFee, uint256 tFee) private {
737         _rTotal    = _rTotal.sub(rFee);
738         _tFeeTotal = _tFeeTotal.add(tFee);
739     }
740 
741     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
742         uint256 tFee       = calculateFee(tAmount, taxFee);
743         uint256 tLiquidity = calculateFee(tAmount, liquidityFee);
744         uint256 tTransferAmount = tAmount.sub(tFee);
745         tTransferAmount = tTransferAmount.sub(tLiquidity);
746         return (tTransferAmount, tFee, tLiquidity);
747     }
748 
749     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
750         uint256 rAmount    = tAmount.mul(currentRate);
751         uint256 rFee       = tFee.mul(currentRate);
752         uint256 rLiquidity = tLiquidity.mul(currentRate);
753         uint256 rTransferAmount = rAmount.sub(rFee);
754         rTransferAmount = rTransferAmount.sub(rLiquidity);
755         return (rAmount, rTransferAmount, rFee);
756     }
757 
758     function _getRate() private view returns(uint256) {
759         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
760         return rSupply.div(tSupply);
761     }
762 
763     function _getCurrentSupply() private view returns(uint256, uint256) {
764         uint256 rSupply = _rTotal;
765         uint256 tSupply = _tTotal;
766         for (uint256 i = 0; i < _excluded.length; i++) {
767             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
768             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
769             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
770         }
771         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
772         return (rSupply, tSupply);
773     }
774 
775     function takeTransactionFee(address to, uint256 tAmount, uint256 currentRate) private {
776         if (tAmount <= 0) { return; }
777 
778         uint256 rAmount = tAmount.mul(currentRate);
779         _rOwned[to] = _rOwned[to].add(rAmount);
780         if (_isExcluded[to]) {
781             _tOwned[to] = _tOwned[to].add(tAmount);
782         }
783     }
784 
785     function calculateFee(uint256 amount, uint256 fee) private pure returns (uint256) {
786         return amount.mul(fee).div(100);
787     }
788 
789     function isExcludedFromFee(address account) public view returns(bool) {
790         return _isExcludedFromFee[account];
791     }
792 
793     function _approve(address owner, address spender, uint256 amount) private {
794         require(owner != address(0), "BEP20: approve from the zero address");
795         require(spender != address(0), "BEP20: approve to the zero address");
796 
797         _allowances[owner][spender] = amount;
798         emit Approval(owner, spender, amount);
799     }
800 
801     function _transfer(
802         address from,
803         address to,
804         uint256 amount
805     ) private {
806         require(from != address(0), "BEP20: transfer from the zero address");
807         require(to != address(0), "BEP20: transfer to the zero address");
808         require(amount > 0, "Transfer amount must be greater than zero");
809 
810         uint256 contractTokenBalance = balanceOf(address(this));
811 
812         if (limitsInEffect) {
813             if (!tradingActive) {
814                 require(
815                     _isExcludedFromFee[from] || _isExcludedFromFee[to],
816                     "Trading is not active."
817                 );
818             }
819 
820             if (from != owner() && to != owner()) {
821                 require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
822             }
823 
824             /*
825                 - swapAndLiquify will be initiated when token balance of this contract
826                 has accumulated enough over the minimum number of tokens required.
827                 - don't get caught in a circular liquidity event.
828                 - don't swapAndLiquify if sender is uniswap pair.
829             */
830 
831             if (contractTokenBalance >= maxTxAmount) {
832                 contractTokenBalance = maxTxAmount;
833             }
834             if (
835                 from != owner() &&
836                 to != owner() &&
837                 to != address(0) &&
838                 to != address(0xdead) &&
839                 to != _uniswapV2Pair
840             ) {
841 
842                 uint256 contractBalanceRecepient = balanceOf(to);
843                 require(
844                     contractBalanceRecepient + amount <= maxWalletToken,
845                     "Exceeds maximum wallet token amount."
846                 );
847 
848             }
849         }
850 
851         bool isOverMinTokenBalance = contractTokenBalance >= _minTokenBalance;
852         if (
853             isOverMinTokenBalance &&
854             !_inSwapAndLiquify &&
855             !_isExcludedFromAutoLiquidity[from] &&
856             swapEnabled
857         ) {
858             // contractTokenBalance = _minTokenBalance;
859             swapAndLiquify(contractTokenBalance);
860         }
861 
862 
863         bool takeFee = true;
864         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
865             takeFee = false;
866         }
867         _tokenTransfer(from, to, amount, takeFee);
868     }
869 
870     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
871         uint256 liqTokens = contractTokenBalance.mul(100 - percentageOfLiquidityForMarketing).div(200);
872         uint256 swapTokens = contractTokenBalance.sub(liqTokens);
873 
874         uint256 initialBalance = address(this).balance;
875 
876         // swap tokens for BNB
877         swapTokensForBnb(swapTokens);
878 
879         // this is the amount of BNB that we just swapped into
880         uint256 newBalance = address(this).balance.sub(initialBalance);
881 
882         // take marketing fee
883         uint256 bnbForLiquidity = newBalance.mul(100 - percentageOfLiquidityForMarketing).div(100);
884         uint256 marketingFee = newBalance.sub(bnbForLiquidity);
885         if (marketingFee > 0) {
886             payable(_marketingWallet).transfer(marketingFee);
887             emit MarketingFeeSent(_marketingWallet, marketingFee);
888         }
889 
890         if (liqTokens > 0) {
891             addLiquidity(liqTokens, bnbForLiquidity);
892         }
893 
894         emit SwapAndLiquify(swapTokens, bnbForLiquidity, liqTokens);
895     }
896     function swapTokensForBnb(uint256 tokenAmount) private {
897         // generate the uniswap pair path of token -> weth
898         address[] memory path = new address[](2);
899         path[0] = address(this);
900         path[1] = _uniswapV2Router.WETH();
901 
902         _approve(address(this), address(_uniswapV2Router), tokenAmount);
903 
904         // make the swap
905         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
906             tokenAmount,
907             0, // accept any amount of BNB
908             path,
909             address(this),
910             block.timestamp
911         );
912     }
913     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
914         // approve token transfer to cover all possible scenarios
915         _approve(address(this), address(_uniswapV2Router), tokenAmount);
916 
917         // add the liquidity
918         _uniswapV2Router.addLiquidityETH{value: bnbAmount}(
919             address(this),
920             tokenAmount,
921             0, // slippage is unavoidable
922             0, // slippage is unavoidable
923             address(this),
924             block.timestamp
925         );
926     }
927 
928     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
929         uint256 previousTaxFee       = taxFee;
930         uint256 previousLiquidityFee = liquidityFee;
931 
932         if (!takeFee) {
933             taxFee       = 0;
934             liquidityFee = 0;
935         }
936 
937         if (_isExcluded[sender] && !_isExcluded[recipient]) {
938             _transferFromExcluded(sender, recipient, amount);
939 
940         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
941             _transferToExcluded(sender, recipient, amount);
942 
943         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
944             _transferStandard(sender, recipient, amount);
945 
946         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
947             _transferBothExcluded(sender, recipient, amount);
948 
949         } else {
950             _transferStandard(sender, recipient, amount);
951         }
952 
953         if (!takeFee) {
954             taxFee       = previousTaxFee;
955             liquidityFee = previousLiquidityFee;
956         }
957     }
958 
959     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
960         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
961         uint256 currentRate = _getRate();
962         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, currentRate);
963 
964         _rOwned[sender]    = _rOwned[sender].sub(rAmount);
965         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
966 
967         takeTransactionFee(address(this), tLiquidity, currentRate);
968         _reflectFee(rFee, tFee);
969         emit Transfer(sender, recipient, tTransferAmount);
970     }
971 
972     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
973         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
974         uint256 currentRate = _getRate();
975         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, currentRate);
976 
977         _tOwned[sender] = _tOwned[sender].sub(tAmount);
978         _rOwned[sender] = _rOwned[sender].sub(rAmount);
979         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
980         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
981 
982         takeTransactionFee(address(this), tLiquidity, currentRate);
983         _reflectFee(rFee, tFee);
984         emit Transfer(sender, recipient, tTransferAmount);
985     }
986 
987     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
988         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
989         uint256 currentRate = _getRate();
990         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, currentRate);
991 
992         _rOwned[sender] = _rOwned[sender].sub(rAmount);
993         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
994         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
995 
996         takeTransactionFee(address(this), tLiquidity, currentRate);
997         _reflectFee(rFee, tFee);
998         emit Transfer(sender, recipient, tTransferAmount);
999     }
1000 
1001     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1002         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1003         uint256 currentRate = _getRate();
1004         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, currentRate);
1005 
1006         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1007         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1008         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1009 
1010         takeTransactionFee(address(this), tLiquidity, currentRate);
1011         _reflectFee(rFee, tFee);
1012         emit Transfer(sender, recipient, tTransferAmount);
1013     }
1014 
1015 }