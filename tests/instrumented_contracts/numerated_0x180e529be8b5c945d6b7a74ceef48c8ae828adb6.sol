1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.5;
3 
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
15         require(b <= a, errorMessage);
16         uint256 c = a - b;
17 
18         return c;
19     }
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27 
28         return c;
29     }
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         return div(a, b, "SafeMath: division by zero");
32     }
33     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         // Solidity only automatically asserts when dividing by 0
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39         return c;
40     }
41 }
42 
43 /**
44  * BEP20 standard interface.
45  */
46 interface IBEP20 {
47     function totalSupply() external view returns (uint256);
48     function decimals() external view returns (uint8);
49     function symbol() external view returns (string memory);
50     function name() external view returns (string memory);
51     function getOwner() external view returns (address);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address _owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 abstract contract Ownable is Context {
72     address private _owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor() {
80         _transferOwnership(_msgSender());
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         _checkOwner();
88         _;
89     }
90 
91     /**
92      * @dev Returns the address of the current owner.
93      */
94     function owner() public view virtual returns (address) {
95         return _owner;
96     }
97 
98     /**
99      * @dev Throws if the sender is not the owner.
100      */
101     function _checkOwner() internal view virtual {
102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
103     }
104 
105     /**
106      * @dev Leaves the contract without owner. It will not be possible to call
107      * `onlyOwner` functions anymore. Can only be called by the current owner.
108      *
109      * NOTE: Renouncing ownership will leave the contract without an owner,
110      * thereby removing any functionality that is only available to the owner.
111      */
112     function renounceOwnership() public virtual onlyOwner {
113         _transferOwnership(address(0));
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Can only be called by the current owner.
119      */
120     function transferOwnership(address newOwner) public virtual onlyOwner {
121         require(newOwner != address(0), "Ownable: new owner is the zero address");
122         _transferOwnership(newOwner);
123     }
124 
125     /**
126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
127      * Internal function without access restriction.
128      */
129     function _transferOwnership(address newOwner) internal virtual {
130         address oldOwner = _owner;
131         _owner = newOwner;
132         emit OwnershipTransferred(oldOwner, newOwner);
133     }
134 }
135 
136 
137 /**
138  * Allows for contract ownership along with multi-address authorization
139  */
140 
141 
142 interface IUniswapV2Factory {
143     event PairCreated(
144         address indexed token0,
145         address indexed token1,
146         address pair,
147         uint256
148     );
149 
150     function feeTo() external view returns (address);
151 
152     function feeToSetter() external view returns (address);
153 
154     function getPair(address tokenA, address tokenB)
155         external
156         view
157         returns (address pair);
158 
159     function allPairs(uint256) external view returns (address pair);
160 
161     function allPairsLength() external view returns (uint256);
162 
163     function createPair(address tokenA, address tokenB)
164         external
165         returns (address pair);
166 
167     function setFeeTo(address) external;
168 
169     function setFeeToSetter(address) external;
170 }
171 
172 
173 interface IUniswapV2Pair {
174     event Approval(
175         address indexed owner,
176         address indexed spender,
177         uint256 value
178     );
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     function name() external pure returns (string memory);
182 
183     function symbol() external pure returns (string memory);
184 
185     function decimals() external pure returns (uint8);
186 
187     function totalSupply() external view returns (uint256);
188 
189     function balanceOf(address owner) external view returns (uint256);
190 
191     function allowance(address owner, address spender)
192         external
193         view
194         returns (uint256);
195 
196     function approve(address spender, uint256 value) external returns (bool);
197 
198     function transfer(address to, uint256 value) external returns (bool);
199 
200     function transferFrom(
201         address from,
202         address to,
203         uint256 value
204     ) external returns (bool);
205 
206     function DOMAIN_SEPARATOR() external view returns (bytes32);
207 
208     function PERMIT_TYPEHASH() external pure returns (bytes32);
209 
210     function nonces(address owner) external view returns (uint256);
211 
212     function permit(
213         address owner,
214         address spender,
215         uint256 value,
216         uint256 deadline,
217         uint8 v,
218         bytes32 r,
219         bytes32 s
220     ) external;
221 
222     event Burn(
223         address indexed sender,
224         uint256 amount0,
225         uint256 amount1,
226         address indexed to
227     );
228     event Swap(
229         address indexed sender,
230         uint256 amount0In,
231         uint256 amount1In,
232         uint256 amount0Out,
233         uint256 amount1Out,
234         address indexed to
235     );
236     event Sync(uint112 reserve0, uint112 reserve1);
237 
238     function MINIMUM_LIQUIDITY() external pure returns (uint256);
239 
240     function factory() external view returns (address);
241 
242     function token0() external view returns (address);
243 
244     function token1() external view returns (address);
245 
246     function getReserves()
247         external
248         view
249         returns (
250             uint112 reserve0,
251             uint112 reserve1,
252             uint32 blockTimestampLast
253         );
254 
255     function price0CumulativeLast() external view returns (uint256);
256 
257     function price1CumulativeLast() external view returns (uint256);
258 
259     function kLast() external view returns (uint256);
260 
261     function burn(address to)
262         external
263         returns (uint256 amount0, uint256 amount1);
264 
265     function swap(
266         uint256 amount0Out,
267         uint256 amount1Out,
268         address to,
269         bytes calldata data
270     ) external;
271 
272     function skim(address to) external;
273 
274     function sync() external;
275 
276     function initialize(address, address) external;
277 }
278 
279 interface IUniswapV2Router01 {
280     function factory() external pure returns (address);
281 
282     function WETH() external pure returns (address);
283 
284     function addLiquidity(
285         address tokenA,
286         address tokenB,
287         uint256 amountADesired,
288         uint256 amountBDesired,
289         uint256 amountAMin,
290         uint256 amountBMin,
291         address to,
292         uint256 deadline
293     )
294         external
295         returns (
296             uint256 amountA,
297             uint256 amountB,
298             uint256 liquidity
299         );
300 
301     function addLiquidityETH(
302         address token,
303         uint256 amountTokenDesired,
304         uint256 amountTokenMin,
305         uint256 amountETHMin,
306         address to,
307         uint256 deadline
308     )
309         external
310         payable
311         returns (
312             uint256 amountToken,
313             uint256 amountETH,
314             uint256 liquidity
315         );
316 
317     function removeLiquidity(
318         address tokenA,
319         address tokenB,
320         uint256 liquidity,
321         uint256 amountAMin,
322         uint256 amountBMin,
323         address to,
324         uint256 deadline
325     ) external returns (uint256 amountA, uint256 amountB);
326 
327     function removeLiquidityETH(
328         address token,
329         uint256 liquidity,
330         uint256 amountTokenMin,
331         uint256 amountETHMin,
332         address to,
333         uint256 deadline
334     ) external returns (uint256 amountToken, uint256 amountETH);
335 
336     function removeLiquidityWithPermit(
337         address tokenA,
338         address tokenB,
339         uint256 liquidity,
340         uint256 amountAMin,
341         uint256 amountBMin,
342         address to,
343         uint256 deadline,
344         bool approveMax,
345         uint8 v,
346         bytes32 r,
347         bytes32 s
348     ) external returns (uint256 amountA, uint256 amountB);
349 
350     function removeLiquidityETHWithPermit(
351         address token,
352         uint256 liquidity,
353         uint256 amountTokenMin,
354         uint256 amountETHMin,
355         address to,
356         uint256 deadline,
357         bool approveMax,
358         uint8 v,
359         bytes32 r,
360         bytes32 s
361     ) external returns (uint256 amountToken, uint256 amountETH);
362 
363     function swapExactTokensForTokens(
364         uint256 amountIn,
365         uint256 amountOutMin,
366         address[] calldata path,
367         address to,
368         uint256 deadline
369     ) external returns (uint256[] memory amounts);
370 
371     function swapTokensForExactTokens(
372         uint256 amountOut,
373         uint256 amountInMax,
374         address[] calldata path,
375         address to,
376         uint256 deadline
377     ) external returns (uint256[] memory amounts);
378 
379     function swapExactETHForTokens(
380         uint256 amountOutMin,
381         address[] calldata path,
382         address to,
383         uint256 deadline
384     ) external payable returns (uint256[] memory amounts);
385 
386     function swapTokensForExactETH(
387         uint256 amountOut,
388         uint256 amountInMax,
389         address[] calldata path,
390         address to,
391         uint256 deadline
392     ) external returns (uint256[] memory amounts);
393 
394     function swapExactTokensForETH(
395         uint256 amountIn,
396         uint256 amountOutMin,
397         address[] calldata path,
398         address to,
399         uint256 deadline
400     ) external returns (uint256[] memory amounts);
401 
402     function swapETHForExactTokens(
403         uint256 amountOut,
404         address[] calldata path,
405         address to,
406         uint256 deadline
407     ) external payable returns (uint256[] memory amounts);
408 
409     function quote(
410         uint256 amountA,
411         uint256 reserveA,
412         uint256 reserveB
413     ) external pure returns (uint256 amountB);
414 
415     function getAmountOut(
416         uint256 amountIn,
417         uint256 reserveIn,
418         uint256 reserveOut
419     ) external pure returns (uint256 amountOut);
420 
421     function getAmountIn(
422         uint256 amountOut,
423         uint256 reserveIn,
424         uint256 reserveOut
425     ) external pure returns (uint256 amountIn);
426 
427     function getAmountsOut(uint256 amountIn, address[] calldata path)
428         external
429         view
430         returns (uint256[] memory amounts);
431 
432     function getAmountsIn(uint256 amountOut, address[] calldata path)
433         external
434         view
435         returns (uint256[] memory amounts);
436 }
437 
438 interface IUniswapV2Router02 is IUniswapV2Router01 {
439     function removeLiquidityETHSupportingFeeOnTransferTokens(
440         address token,
441         uint256 liquidity,
442         uint256 amountTokenMin,
443         uint256 amountETHMin,
444         address to,
445         uint256 deadline
446     ) external returns (uint256 amountETH);
447 
448     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
449         address token,
450         uint256 liquidity,
451         uint256 amountTokenMin,
452         uint256 amountETHMin,
453         address to,
454         uint256 deadline,
455         bool approveMax,
456         uint8 v,
457         bytes32 r,
458         bytes32 s
459     ) external returns (uint256 amountETH);
460 
461     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
462         uint256 amountIn,
463         uint256 amountOutMin,
464         address[] calldata path,
465         address to,
466         uint256 deadline
467     ) external;
468 
469     function swapExactETHForTokensSupportingFeeOnTransferTokens(
470         uint256 amountOutMin,
471         address[] calldata path,
472         address to,
473         uint256 deadline
474     ) external payable;
475 
476     function swapExactTokensForETHSupportingFeeOnTransferTokens(
477         uint256 amountIn,
478         uint256 amountOutMin,
479         address[] calldata path,
480         address to,
481         uint256 deadline
482     ) external;
483 }
484 
485 contract SIGN is IBEP20, Ownable {
486     using SafeMath for uint256;
487 
488     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
489     address DEAD = 0x000000000000000000000000000000000000dEaD;
490     address ZERO = 0x0000000000000000000000000000000000000000;
491 
492     string constant _name = "SIGNAL";
493     string constant _symbol = "SIGN";
494     uint8 constant _decimals = 18;
495 
496     uint256 _totalSupply = 1000000000 * (10 ** _decimals);
497     uint256 public _maxTxAmount = (_totalSupply * 2) / 100;  // 2% max tx
498     uint256 public _maxWalletSize = (_totalSupply * 2) / 100;  // 2% max wallet
499 
500 
501     mapping (address => uint256) _balances;
502     mapping (address => mapping (address => uint256)) _allowances;
503 
504     mapping (address => bool) public isFeeExempt;
505     mapping (address => bool) public isTxLimitExempt;
506 
507     uint256 liquidityFee = 0;
508     uint256 teamFee = 1;
509     uint256 marketingFee = 4;
510     uint256 devFee = 1;
511     uint256 totalFee = 6;
512     uint256 feeDenominator = 100;
513     
514     address private marketingFeeReceiver = 0xb11ee03a587B893a94Ae3e9d2E98658fC718E4f1;
515     address private devFeeReceiver = 0xb11ee03a587B893a94Ae3e9d2E98658fC718E4f1;
516     address private teamFeeReceiver = 0xb11ee03a587B893a94Ae3e9d2E98658fC718E4f1;
517 
518     IUniswapV2Router02 public router;
519     address public pair;
520 
521     uint256 public launchedAt;
522 
523     bool public swapEnabled = true;
524     bool public tradingActive = false;
525 
526     uint256 public swapThreshold = _totalSupply / 1000 * 1; // .1%
527     bool inSwap;
528     modifier swapping() { inSwap = true; _; inSwap = false; }
529 
530     constructor ()  {
531         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
532         pair = IUniswapV2Factory(router.factory()).createPair(WETH, address(this));
533         _allowances[address(this)][address(router)] = type(uint256).max;
534 
535         address _owner = owner();
536         isFeeExempt[_owner] = true;
537         isTxLimitExempt[_owner] = true;
538         isTxLimitExempt[address(router)] = true;
539         isTxLimitExempt[address(pair)] = true;
540 
541         _balances[_owner] = _totalSupply;
542         emit Transfer(address(0), _owner, _totalSupply);
543     }
544 
545     receive() external payable { }
546 
547     function totalSupply() external view override returns (uint256) { return _totalSupply; }
548     function decimals() external pure override returns (uint8) { return _decimals; }
549     function symbol() external pure override returns (string memory) { return _symbol; }
550     function name() external pure override returns (string memory) { return _name; }
551     
552 
553     function getOwner() external view returns (address) { return owner(); }
554     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
555     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
556 
557     function approve(address spender, uint256 amount) public override returns (bool) {
558         _allowances[msg.sender][spender] = amount;
559         emit Approval(msg.sender, spender, amount);
560         return true;
561     }
562 
563     function approveMax(address spender) external returns (bool) {
564         return approve(spender, type(uint256).max);
565     }
566 
567     function transfer(address recipient, uint256 amount) external override returns (bool) {
568         return _transferFrom(msg.sender, recipient, amount);
569     }
570 
571     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
572         if(_allowances[sender][msg.sender] != type(uint256).max){
573             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
574         }
575 
576         return _transferFrom(sender, recipient, amount);
577     }
578 
579     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
580         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
581 
582         if(!tradingActive){
583             require(isFeeExempt[sender] || isFeeExempt[recipient], "Trading is not active yet.");
584         }
585         
586         checkTxLimit(sender, amount);
587         
588         if (recipient != pair && recipient != DEAD) {
589             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the bag size.");
590         }
591         
592         if(shouldSwapBack()){ swapBack(); }
593 
594         if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }
595 
596         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
597 
598         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
599         _balances[recipient] = _balances[recipient].add(amountReceived);
600 
601         emit Transfer(sender, recipient, amountReceived);
602         return true;
603     }
604     
605     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
606         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
607         _balances[recipient] = _balances[recipient].add(amount);
608         emit Transfer(sender, recipient, amount);
609         return true;
610     }
611 
612     function checkTxLimit(address sender, uint256 amount) internal view {
613         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
614     }
615     
616     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
617         return !(isFeeExempt[sender] || isFeeExempt[recipient]);
618     }
619 
620     function getTotalFee(bool selling) public view returns (uint256) {
621         if(launchedAt + 1 >= block.number){ return feeDenominator.sub(1); }
622         if(selling) { return totalFee.add(1); }
623         return totalFee;
624     }
625 
626     function enableTrading() external onlyOwner() {
627         tradingActive = true;
628     }
629 
630     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
631         uint256 feeAmount = amount.mul(getTotalFee(receiver == pair)).div(feeDenominator);
632 
633         _balances[address(this)] = _balances[address(this)].add(feeAmount);
634         emit Transfer(sender, address(this), feeAmount);
635 
636         return amount.sub(feeAmount);
637     }
638 
639     function shouldSwapBack() internal view returns (bool) {
640         return msg.sender != pair
641         && !inSwap
642         && swapEnabled
643         && _balances[address(this)] >= swapThreshold;
644     }
645 
646     function swapBack() internal swapping {
647         uint256 contractTokenBalance = balanceOf(address(this));
648         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
649         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
650 
651         address[] memory path = new address[](2);
652         path[0] = address(this);
653         path[1] = WETH;
654 
655         uint256 balanceBefore = address(this).balance;
656 
657         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
658             amountToSwap,
659             0,
660             path,
661             address(this),
662             block.timestamp
663         );
664         uint256 amountBNB = address(this).balance.sub(balanceBefore);
665         uint256 totalBNBFee = totalFee.sub(liquidityFee.div(2));
666         //uint256 amountBNBLiquidity = amountBNB.mul(liquidityFee).div(totalBNBFee).div(2);
667         uint256 amountBNBdevelopment = amountBNB.mul(teamFee).div(totalBNBFee);
668         uint256 amountBNBmarketing = amountBNB.mul(marketingFee).div(totalBNBFee);
669         uint256 amountBNBDev = amountBNB.mul(devFee).div(totalBNBFee);
670 
671 
672 
673         (bool marketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountBNBmarketing, gas: 30000}("");
674         require(marketingSuccess, "receiver rejected ETH transfer");
675 
676         (bool DevSuccess, /* bytes memory data */) = payable(devFeeReceiver).call{value: amountBNBDev, gas: 30000}("");
677         require(DevSuccess, "receiver rejected ETH transfer");
678 
679         (bool developmentSuccess, /* bytes memory data */) = payable(teamFeeReceiver).call{value: amountBNBdevelopment, gas: 30000}("");
680         require(developmentSuccess, "receiver rejected ETH transfer");
681 
682 
683     }
684 
685     function buyTokens(uint256 amount, address to) internal swapping {
686         address[] memory path = new address[](2);
687         path[0] = WETH;
688         path[1] = address(this);
689 
690         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
691             0,
692             path,
693             to,
694             block.timestamp
695         );
696     }
697 
698     function launched() internal view returns (bool) {
699         return launchedAt != 0;
700     }
701 
702     function launch() internal {
703         launchedAt = block.number;
704     }
705 
706     function setTxLimit(uint256 amount) external onlyOwner() {
707         require(amount >= _totalSupply / 1000);
708         _maxTxAmount = amount;
709     }
710 
711    function setMaxWallet(uint256 amount) external onlyOwner() {
712         require(amount >= _totalSupply / 1000 );
713         _maxWalletSize = amount;
714     }    
715 
716     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
717         isFeeExempt[holder] = exempt;
718     }
719 
720     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
721         isTxLimitExempt[holder] = exempt;
722     }
723 
724     function setFees( uint256 _teamFee, uint256 _marketingFee, uint256 _devFee , uint256 _feeDenominator) external onlyOwner() {
725         teamFee = _teamFee;
726         marketingFee = _marketingFee;
727         devFee = _devFee ;
728         totalFee = _devFee.add(_teamFee).add(_marketingFee);
729         feeDenominator = _feeDenominator;
730     }
731 
732     function setFeeReceiver(address _marketingFeeReceiver, address _teamFeeReceiver) external onlyOwner() {
733         marketingFeeReceiver = _marketingFeeReceiver;
734         teamFeeReceiver = _teamFeeReceiver;
735     }
736 
737     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner() {
738         swapEnabled = _enabled;
739         swapThreshold = _amount;
740     }
741 
742     function manualSend() external onlyOwner() {
743         uint256 contractETHBalance = address(this).balance;
744         payable(marketingFeeReceiver).transfer(contractETHBalance);
745     }
746 
747     function transferForeignToken(address _token) public onlyOwner() {
748         require(_token != address(this), "Can't let you take all native token");
749         uint256 _contractBalance = IBEP20(_token).balanceOf(address(this));
750         payable(marketingFeeReceiver).transfer(_contractBalance);
751     }
752         
753     function getCirculatingSupply() public view returns (uint256) {
754         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
755     }
756 
757     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
758         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
759     }
760 
761     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
762         return getLiquidityBacking(accuracy) > target;
763     }
764     
765     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
766 }