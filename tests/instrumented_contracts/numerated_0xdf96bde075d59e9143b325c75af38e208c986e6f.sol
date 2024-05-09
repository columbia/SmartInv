1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166 
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
171         (bool success, ) = recipient.call{ value: amount }("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 }
175 
176 interface IUniswapV2Factory {
177     function createPair(address tokenA, address tokenB) external returns (address pair);
178 }
179 
180 interface IUniswapV2Router01 {
181     function factory() external pure returns (address);
182     function WETH() external pure returns (address);
183 
184     function addLiquidity(
185         address tokenA,
186         address tokenB,
187         uint amountADesired,
188         uint amountBDesired,
189         uint amountAMin,
190         uint amountBMin,
191         address to,
192         uint deadline
193     ) external returns (uint amountA, uint amountB, uint liquidity);
194     function addLiquidityETH(
195         address token,
196         uint amountTokenDesired,
197         uint amountTokenMin,
198         uint amountETHMin,
199         address to,
200         uint deadline
201     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
202     function removeLiquidity(
203         address tokenA,
204         address tokenB,
205         uint liquidity,
206         uint amountAMin,
207         uint amountBMin,
208         address to,
209         uint deadline
210     ) external returns (uint amountA, uint amountB);
211     function removeLiquidityETH(
212         address token,
213         uint liquidity,
214         uint amountTokenMin,
215         uint amountETHMin,
216         address to,
217         uint deadline
218     ) external returns (uint amountToken, uint amountETH);
219     function removeLiquidityWithPermit(
220         address tokenA,
221         address tokenB,
222         uint liquidity,
223         uint amountAMin,
224         uint amountBMin,
225         address to,
226         uint deadline,
227         bool approveMax, uint8 v, bytes32 r, bytes32 s
228     ) external returns (uint amountA, uint amountB);
229     function removeLiquidityETHWithPermit(
230         address token,
231         uint liquidity,
232         uint amountTokenMin,
233         uint amountETHMin,
234         address to,
235         uint deadline,
236         bool approveMax, uint8 v, bytes32 r, bytes32 s
237     ) external returns (uint amountToken, uint amountETH);
238     function swapExactTokensForTokens(
239         uint amountIn,
240         uint amountOutMin,
241         address[] calldata path,
242         address to,
243         uint deadline
244     ) external returns (uint[] memory amounts);
245     function swapTokensForExactTokens(
246         uint amountOut,
247         uint amountInMax,
248         address[] calldata path,
249         address to,
250         uint deadline
251     ) external returns (uint[] memory amounts);
252     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
253         external
254         payable
255         returns (uint[] memory amounts);
256     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
257         external
258         returns (uint[] memory amounts);
259     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
260         external
261         returns (uint[] memory amounts);
262     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
263         external
264         payable
265         returns (uint[] memory amounts);
266 
267     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
268     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
269     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
270     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
271     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
272 }
273 
274 interface IUniswapV2Router02 is IUniswapV2Router01 {
275     function removeLiquidityETHSupportingFeeOnTransferTokens(
276         address token,
277         uint liquidity,
278         uint amountTokenMin,
279         uint amountETHMin,
280         address to,
281         uint deadline
282     ) external returns (uint amountETH);
283     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
284         address token,
285         uint liquidity,
286         uint amountTokenMin,
287         uint amountETHMin,
288         address to,
289         uint deadline,
290         bool approveMax, uint8 v, bytes32 r, bytes32 s
291     ) external returns (uint amountETH);
292 
293     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
294         uint amountIn,
295         uint amountOutMin,
296         address[] calldata path,
297         address to,
298         uint deadline
299     ) external;
300     function swapExactETHForTokensSupportingFeeOnTransferTokens(
301         uint amountOutMin,
302         address[] calldata path,
303         address to,
304         uint deadline
305     ) external payable;
306     function swapExactTokensForETHSupportingFeeOnTransferTokens(
307         uint amountIn,
308         uint amountOutMin,
309         address[] calldata path,
310         address to,
311         uint deadline
312     ) external;
313 }
314 
315 
316 contract YetiCoin {
317     using SafeMath for uint256;
318     using Address for address payable;
319 
320     event Approval(address indexed owner, address indexed spender, uint value);
321     event Transfer(address indexed from, address indexed to, uint value);
322 
323     mapping (address => uint256) private _rOwned;
324     mapping (address => uint256) private _tOwned;
325     mapping (address => mapping (address => uint256)) private _allowances;
326     mapping (address => bool) private _isExcludedFromFee;
327 
328     address public _owner;
329     address payable public marketing;
330     address payable public development;
331 
332     uint256 private constant MAX = ~uint256(0);
333     uint256 private _tTotal = 1 * 10**15 * 10**9;
334     uint256 private _rTotal = (MAX - (MAX % _tTotal));
335     uint256 private _tFeeTotal;
336 
337     string private _name = "YetiCoin";
338     string private _symbol = "YETIC";
339     uint8 private _decimals = 9;
340 
341     uint256 public __reflectFee = 1;
342     uint256 public __marketingFee = 4;
343     uint256 public __developmentFee = 1;
344     uint256 public __liquidityFee = 1;
345     uint256 public __prev_liquidityFee = 1;
346 
347     uint256 public immutable contract_deployed;
348 
349     uint256 public _pendingLiquidityFees = 0;
350 
351     IUniswapV2Router02 public immutable uniswapV2Router;
352     address public immutable uniswapV2Pair;
353 
354     bool inSwapAndLiquify;
355     bool public swapAndLiquifyEnabled = true;
356 
357     uint256 public _maxWalletHolding = 25 * 10**12 * 10**9;
358     uint256 private numTokensSellToAddToLiquidity = 9 * 10**12 * 10**9;
359 
360     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
361     event SwapAndLiquifyEnabledUpdated(bool enabled);
362     event SwapAndLiquify(
363         uint256 tokensSwapped,
364         uint256 ethReceived,
365         uint256 tokensIntoLiquidity
366     );
367 
368     function _msgSender() internal view virtual returns (address payable) {
369        return msg.sender;
370      }
371 
372     modifier onlyOwner() {
373        require(_owner == msg.sender, "Caller is not the owner");
374        _;
375    }
376 
377     modifier lockTheSwap {
378         inSwapAndLiquify = true;
379         _;
380         inSwapAndLiquify = false;
381     }
382 
383     constructor (address payable _marketing, address payable _development) public {
384       _owner = msg.sender;
385       marketing = _marketing;
386       development = _development;
387       contract_deployed = block.timestamp;
388       _rOwned[msg.sender] = _rTotal;
389       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
390       uniswapV2Router = _uniswapV2Router;
391       uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
392       _isExcludedFromFee[msg.sender] = true;
393       _isExcludedFromFee[address(this)] = true;
394       emit Transfer(address(0), msg.sender, _tTotal);
395     }
396 
397     function name() public view returns (string memory) {
398         return _name;
399     }
400 
401     function symbol() public view returns (string memory) {
402         return _symbol;
403     }
404 
405     function decimals() public view returns (uint8) {
406         return _decimals;
407     }
408 
409     function totalSupply() public view returns (uint256) {
410         return _tTotal;
411     }
412 
413     function balanceOf(address account) public view returns (uint256) {
414         return tokenFromReflection(_rOwned[account]);
415     }
416 
417     function transfer(address recipient, uint256 amount) public returns (bool) {
418         _transfer(_msgSender(), recipient, amount);
419         return true;
420     }
421 
422     function allowance(address owner, address spender) public view returns (uint256) {
423         return _allowances[owner][spender];
424     }
425 
426     function approve(address spender, uint256 amount) public returns (bool) {
427         _approve(_msgSender(), spender, amount);
428         return true;
429     }
430 
431     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
432         _transfer(sender, recipient, amount);
433         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
434         return true;
435     }
436 
437     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
438         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
439         return true;
440     }
441 
442     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
443         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
444         return true;
445     }
446 
447     function totalFees() public view returns (uint256) {
448         return _tFeeTotal;
449     }
450 
451     function renounceOwnership() public onlyOwner {
452         _owner = address(0);
453     }
454 
455     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
456         require(tAmount <= _tTotal, "Amount must be less than supply");
457         if (!deductTransferFee) {
458             (uint256 rAmount,,,,,,) = _getValues(tAmount);
459             return rAmount;
460         } else {
461             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
462             return rTransferAmount;
463         }
464     }
465 
466     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
467         require(rAmount <= _rTotal, "Amount must be less than total reflections");
468         uint256 currentRate =  _getRate();
469         return rAmount.div(currentRate);
470     }
471 
472     //this can be called externally by deployer to immediately process accumulated fees accordingly (distribute to treasury & liquidity)
473     function manualSwapAndLiquify() public onlyOwner() {
474         uint256 contractTokenBalance = balanceOf(address(this));
475         swapAndLiquify(contractTokenBalance);
476     }
477 
478     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
479         swapAndLiquifyEnabled = _enabled;
480         emit SwapAndLiquifyEnabledUpdated(_enabled);
481     }
482 
483      //to receive ETH from uniswapV2Router when swaping
484     receive() external payable {}
485 
486     function _reflectFee(uint256 rFee, uint256 tFee) private {
487         _rTotal = _rTotal.sub(rFee);
488         _tFeeTotal = _tFeeTotal.add(tFee);
489     }
490 
491     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
492         uint256[4] memory tValues = _getTValuesArray(tAmount);
493         uint256[3] memory rValues = _getRValuesArray(tAmount, tValues[1], tValues[2], tValues[3]);
494         return (rValues[0], rValues[1], rValues[2], tValues[0], tValues[1], tValues[2], tValues[3]);
495     }
496 
497     function _getTValuesArray(uint256 tAmount) private view returns (uint256[4] memory val) {
498         uint256 tFee = calculateTaxFee(tAmount);
499         uint256 tLiquidity = calculateLiquidityFee(tAmount);
500         uint256 tOperations = calculateOperationsFee(tAmount);
501         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tOperations);
502         return [tTransferAmount, tFee, tLiquidity, tOperations];
503     }
504 
505     function _getRValuesArray(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations) private view returns (uint256[3] memory val) {
506         uint256 currentRate = _getRate();
507         uint256 rAmount = tAmount.mul(currentRate);
508         uint256 rFee = tFee.mul(currentRate);
509         uint256 rTransferAmount = rAmount.sub(rFee).sub(tLiquidity.mul(currentRate)).sub(tOperations.mul(currentRate));
510         return [rAmount, rTransferAmount, rFee];
511     }
512 
513     function _getRate() private view returns(uint256) {
514         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
515         return rSupply.div(tSupply);
516     }
517 
518     function _getCurrentSupply() private view returns(uint256, uint256) {
519         uint256 rSupply = _rTotal;
520         uint256 tSupply = _tTotal;
521         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
522         return (rSupply, tSupply);
523     }
524 
525     function _takeLiquidity(uint256 tLiquidity) private {
526         uint256 currentRate =  _getRate();
527         uint256 rLiquidity = tLiquidity.mul(currentRate);
528         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
529         _pendingLiquidityFees = _pendingLiquidityFees.add(tLiquidity);
530     }
531 
532     function _takeOperations(uint256 tOperations) private {
533         uint256 currentRate =  _getRate();
534         uint256 rOperations = tOperations.mul(currentRate);
535         _rOwned[address(this)] = _rOwned[address(this)].add(rOperations);
536     }
537 
538     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
539         return _amount.mul(__reflectFee).div(
540             10**2
541         );
542     }
543 
544     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
545         return _amount.mul(__liquidityFee).div(
546             10**2
547         );
548     }
549 
550     function calculateOperationsFee(uint256 _amount) private view returns (uint256) {
551         uint256 operations_fee = __marketingFee.add(__developmentFee);
552         return _amount.mul(operations_fee).div(
553             10**2
554         );
555     }
556 
557     function removeAllFee() private {
558         __prev_liquidityFee = __liquidityFee;
559 
560         __reflectFee = 0;
561         __liquidityFee = 0;
562         __marketingFee = 0;
563         __developmentFee = 0;
564     }
565 
566     function restoreAllFee() private {
567         __reflectFee = 1;
568         __liquidityFee = __prev_liquidityFee;
569         __marketingFee = 4;
570         __developmentFee = 1;
571     }
572 
573     function isExcludedFromFee(address account) public view returns(bool) {
574         return _isExcludedFromFee[account];
575     }
576 
577     function _approve(address owner, address spender, uint256 amount) private {
578         require(owner != address(0), "ERC20: approve from the zero address");
579         require(spender != address(0), "ERC20: approve to the zero address");
580 
581         _allowances[owner][spender] = amount;
582         emit Approval(owner, spender, amount);
583     }
584 
585     function _transfer(
586         address from,
587         address to,
588         uint256 amount
589     ) private {
590         require(from != address(0), "ERC20: transfer from the zero address");
591         require(to != address(0), "ERC20: transfer to the zero address");
592         require(amount > 0, "Transfer amount must be greater than zero");
593         if ((contract_deployed + 30 days) < block.timestamp) {
594           __liquidityFee = 0;
595           __prev_liquidityFee = 0;
596         }
597 
598         uint256 contractTokenBalance = balanceOf(address(this));
599 
600         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
601         if (
602             overMinTokenBalance &&
603             !inSwapAndLiquify &&
604             from != uniswapV2Pair &&
605             swapAndLiquifyEnabled
606         ) {
607             swapAndLiquify(contractTokenBalance);
608         }
609 
610         //indicates if fee should be deducted from transfer
611         bool takeFee = true;
612 
613         //if any account belongs to _isExcludedFromFee account then remove the fee
614         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
615             takeFee = false;
616         }
617 
618         bool isTransferBuy = from == uniswapV2Pair;
619         bool isTransferSell = to == uniswapV2Pair;
620         if (!isTransferBuy && !isTransferSell) takeFee = false;
621 
622         _tokenTransfer(from,to,amount,takeFee);
623 
624         restoreAllFee();
625     }
626 
627     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
628         uint256 liquidityPart = 0;
629         if (_pendingLiquidityFees < contractTokenBalance) liquidityPart = _pendingLiquidityFees;
630         uint256 distributionPart = contractTokenBalance.sub(liquidityPart);
631         uint256 liquidityHalfPart = liquidityPart.div(2);
632         uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart);
633 
634         //now swapping half of the liquidity part + all of the distribution part into ETH
635         uint256 totalETHSwap = liquidityHalfPart.add(distributionPart);
636 
637         uint256 initialBalance = address(this).balance;
638 
639         // swap tokens for ETH
640         swapTokensForEth(totalETHSwap);
641 
642         uint256 newBalance = address(this).balance.sub(initialBalance);
643         uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap);
644 
645         // add liquidity to uniswap
646         if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance);
647         emit SwapAndLiquify(liquidityHalfPart, liquidityBalance, liquidityHalfPart);
648 
649         newBalance = address(this).balance;
650         payDistribution(newBalance);
651         _pendingLiquidityFees = 0;
652     }
653 
654     function swapTokensForEth(uint256 tokenAmount) private {
655         // generate the uniswap pair path of token -> weth
656         address[] memory path = new address[](2);
657         path[0] = address(this);
658         path[1] = uniswapV2Router.WETH();
659 
660         _approve(address(this), address(uniswapV2Router), tokenAmount);
661 
662         // make the swap
663         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
664             tokenAmount,
665             0, // accept any amount of ETH
666             path,
667             address(this),
668             block.timestamp
669         );
670     }
671 
672     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
673         // approve token transfer to cover all possible scenarios
674         _approve(address(this), address(uniswapV2Router), tokenAmount);
675 
676         // add the liquidity
677         uniswapV2Router.addLiquidityETH{value: ethAmount}(
678             address(this),
679             tokenAmount,
680             0, // slippage is unavoidable
681             0, // slippage is unavoidable
682             marketing,
683             block.timestamp
684         );
685     }
686 
687     function payDistribution(uint256 distrib) private {
688       uint256 marketingPart = distrib.mul(__marketingFee).div(__marketingFee.add(__developmentFee));
689       marketing.sendValue(marketingPart);
690       development.sendValue(distrib.sub(marketingPart));
691     }
692 
693     //this method is responsible for taking all fee, if takeFee is true
694     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
695         if(!takeFee) removeAllFee();
696         _transferStandard(sender, recipient, amount);
697         if (!_isExcludedFromFee[recipient] && (recipient != uniswapV2Pair)) require(balanceOf(recipient) < _maxWalletHolding, "Max Wallet holding limit exceeded");
698     }
699 
700     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
701         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations) = _getValues(tAmount);
702         _rOwned[sender] = _rOwned[sender].sub(rAmount);
703         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
704         _takeLiquidity(tLiquidity);
705         _takeOperations(tOperations);
706         _reflectFee(rFee, tFee);
707         emit Transfer(sender, recipient, tTransferAmount);
708     }
709 
710 }