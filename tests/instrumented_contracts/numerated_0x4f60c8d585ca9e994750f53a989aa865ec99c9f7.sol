1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.16;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address recipient, uint256 amount)
11         external
12         returns (bool);
13 
14     function allowance(address owner, address spender)
15         external
16         view
17         returns (uint256);
18 
19     function approve(address spender, uint256 amount) external returns (bool);
20 
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33 }
34 
35 library SafeMath {
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         return a + b;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a - b;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a * b;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a / b;
51     }
52 
53     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a % b;
55     }
56 
57     function sub(
58         uint256 a,
59         uint256 b,
60         string memory errorMessage
61     ) internal pure returns (uint256) {
62         unchecked {
63             require(b <= a, errorMessage);
64             return a - b;
65         }
66     }
67 
68     function div(
69         uint256 a,
70         uint256 b,
71         string memory errorMessage
72     ) internal pure returns (uint256) {
73         unchecked {
74             require(b > 0, errorMessage);
75             return a / b;
76         }
77     }
78 }
79 
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view virtual returns (bytes calldata) {
86         this; 
87         return msg.data;
88     }
89 }
90 
91 abstract contract Ownable is Context {
92     address internal _owner;
93     address private _previousOwner;
94 
95     event OwnershipTransferred(
96         address indexed previousOwner,
97         address indexed newOwner
98     );
99 
100     constructor() {
101         _owner = _msgSender();
102         emit OwnershipTransferred(address(0), _owner);
103     }
104 
105     function owner() public view virtual returns (address) {
106         return _owner;
107     }
108 
109     modifier onlyOwner() {
110         require(owner() == _msgSender(), "Ownable: caller is not the owner");
111         _;
112     }
113 
114     function renounceOwnership() public virtual onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     function transferOwnership(address newOwner) public virtual onlyOwner {
120         require(
121             newOwner != address(0),
122             "Ownable: new owner is the zero address"
123         );
124         emit OwnershipTransferred(_owner, newOwner);
125         _owner = newOwner;
126     }
127 }
128 
129 interface IUniswapV2Factory {
130     event PairCreated(
131         address indexed token0,
132         address indexed token1,
133         address pair,
134         uint256
135     );
136 
137     function createPair(address tokenA, address tokenB) external returns (address pair);
138 }
139 
140 interface IUniswapV2Pair 
141 {
142     function factory() external view returns (address);
143 }
144 
145 interface IUniswapV2Router01 {
146     function factory() external pure returns (address);
147     function WETH() external pure returns (address);
148 
149     function addLiquidityETH(
150         address token,
151         uint256 amountTokenDesired,
152         uint256 amountTokenMin,
153         uint256 amountETHMin,
154         address to,
155         uint256 deadline
156     )
157         external
158         payable
159         returns (
160             uint256 amountToken,
161             uint256 amountETH,
162             uint256 liquidity
163         );
164 }
165 
166 interface IUniswapV2Router02 is IUniswapV2Router01 {
167     function swapExactTokensForETHSupportingFeeOnTransferTokens(
168         uint256 amountIn,
169         uint256 amountOutMin,
170         address[] calldata path,
171         address to,
172         uint256 deadline
173     ) external;
174 }
175 
176 contract Catcoin is Context, IERC20, Ownable {
177     using SafeMath for uint256;
178 
179     mapping(address => uint256) private _rOwned;
180     mapping(address => uint256) private _tOwned;
181     mapping(address => mapping(address => uint256)) private _allowances;
182     mapping(address => bool) private _isExcludedFromFee;
183     mapping(address => bool) private _isExcluded;
184     address[] private _excluded;
185 
186     address public _burnAddress = 0x000000000000000000000000000000000000dEaD;
187     uint256 private constant MAX = ~uint256(0);
188     uint256 private _tTotal;
189     uint256 private _rTotal;
190     uint256 private _tFeeTotal;
191     string private _name;
192     string private _symbol;
193     uint256 private _decimals;
194 
195     // Buy tax
196     uint256 private _buyTaxFee = 0;
197     uint256 private _buyLiquidityFee = 7;
198 
199     // Sell tax
200     uint256 private _sellTaxFee = 2;
201     uint256 private _sellLiquidityFee = 7;
202 
203     uint256 public _taxFee = _buyTaxFee;
204     uint256 public _liquidityFee = _buyLiquidityFee;
205 
206     uint256 private _previousTaxFee = _taxFee;
207     uint256 private _previousLiquidityFee = _liquidityFee;
208 
209     IUniswapV2Router02 public uniswapV2Router;
210     address public uniswapV2Pair;
211     bool public inSwapAndLiquify;
212     bool public swapAndLiquifyEnabled = true;
213     uint256 public numTokensSellToAddToLiquidity;
214     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
215     event SwapAndLiquifyEnabledUpdated(bool enabled);
216     event SwapAndLiquify(
217         uint256 tokensSwapped,
218         uint256 ethReceived,
219         uint256 tokensIntoLiqudity
220     );
221 
222     modifier lockTheSwap() {
223         inSwapAndLiquify = true;
224         _;
225         inSwapAndLiquify = false;
226     }
227 
228     constructor() {
229         _name = "Catcoin";
230         _symbol = "CATS";
231         _decimals = 0;
232         _tTotal = 9e12;
233         _rTotal = (MAX - (MAX % _tTotal));
234         numTokensSellToAddToLiquidity = 2e9;
235 
236         _rOwned[_msgSender()] = _rTotal;
237 
238         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
239             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
240         );
241         // Create a uniswap pair for this new token
242         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
243             .createPair(address(this), _uniswapV2Router.WETH());
244 
245         uniswapV2Router = _uniswapV2Router;
246 
247         emit Transfer(address(0), owner(), _tTotal);
248     }
249 
250     function name() public view returns (string memory) {
251         return _name;
252     }
253 
254     function symbol() public view returns (string memory) {
255         return _symbol;
256     }
257 
258     function decimals() public view returns (uint256) {
259         return _decimals;
260     }
261 
262     function totalSupply() public view override returns (uint256) {
263         return _tTotal;
264     }
265 
266     function balanceOf(address account) public view override returns (uint256) {
267         if (_isExcluded[account]) return _tOwned[account];
268         return tokenFromReflection(_rOwned[account]);
269     }
270 
271     function transfer(address recipient, uint256 amount)
272         public
273         override
274         returns (bool)
275     {
276         _transfer(_msgSender(), recipient, amount);
277         return true;
278     }
279 
280     function allowance(address owner, address spender)
281         public
282         view
283         override
284         returns (uint256)
285     {
286         return _allowances[owner][spender];
287     }
288 
289     function approve(address spender, uint256 amount)
290         public
291         override
292         returns (bool)
293     {
294         _approve(_msgSender(), spender, amount);
295         return true;
296     }
297 
298     function transferFrom(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) public override returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(
305             sender,
306             _msgSender(),
307             _allowances[sender][_msgSender()].sub(
308                 amount,
309                 "ERC20: transfer amount exceeds allowance"
310             )
311         );
312         return true;
313     }
314 
315     function increaseAllowance(address spender, uint256 addedValue)
316         public
317         virtual
318         returns (bool)
319     {
320         _approve(
321             _msgSender(),
322             spender,
323             _allowances[_msgSender()][spender].add(addedValue)
324         );
325         return true;
326     }
327 
328     function decreaseAllowance(address spender, uint256 subtractedValue)
329         public
330         virtual
331         returns (bool)
332     {
333         _approve(
334             _msgSender(),
335             spender,
336             _allowances[_msgSender()][spender].sub(
337                 subtractedValue,
338                 "ERC20: decreased allowance below zero"
339             )
340         );
341         return true;
342     }
343 
344     function isExcludedFromReward(address account) public view returns (bool) {
345         return _isExcluded[account];
346     }
347 
348     function totalFees() public view returns (uint256) {
349         return _tFeeTotal;
350     }
351 
352     function deliver(uint256 tAmount) public {
353         address sender = _msgSender();
354         require(
355             !_isExcluded[sender],
356             "Excluded addresses cannot call this function"
357         );
358         (uint256 rAmount, , , , , ) = _getValues(tAmount);
359         _rOwned[sender] = _rOwned[sender].sub(rAmount);
360         _rTotal = _rTotal.sub(rAmount);
361         _tFeeTotal = _tFeeTotal.add(tAmount);
362     }
363 
364     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
365         public
366         view
367         returns (uint256)
368     {
369         require(tAmount <= _tTotal, "Amount must be less than supply");
370         if (!deductTransferFee) {
371             (uint256 rAmount, , , , , ) = _getValues(tAmount);
372             return rAmount;
373         } else {
374             (, uint256 rTransferAmount, , , ,) = _getValues(tAmount);
375             return rTransferAmount;
376         }
377     }
378 
379     function tokenFromReflection(uint256 rAmount)
380         public
381         view
382         returns (uint256)
383     {
384         require(
385             rAmount <= _rTotal,
386             "Amount must be less than total reflections"
387         );
388         uint256 currentRate = _getRate();
389         return rAmount.div(currentRate);
390     }
391 
392     function excludeFromReward(address account) public onlyOwner {
393         require(!_isExcluded[account], "Account is already excluded");
394         if (_rOwned[account] > 0) {
395             _tOwned[account] = tokenFromReflection(_rOwned[account]);
396         }
397         _isExcluded[account] = true;
398         _excluded.push(account);
399     }
400 
401     function includeInReward(address account) external onlyOwner {
402         require(_isExcluded[account], "Account is already included");
403         for (uint256 i = 0; i < _excluded.length; i++) {
404             if (_excluded[i] == account) {
405                 _excluded[i] = _excluded[_excluded.length - 1];
406                 _tOwned[account] = 0;
407                 _isExcluded[account] = false;
408                 _excluded.pop();
409                 break;
410             }
411         }
412     }
413 
414     function _transferBothExcluded(
415         address sender,
416         address recipient,
417         uint256 tAmount
418     ) private {
419         (
420             uint256 rAmount,
421             uint256 rTransferAmount,
422             uint256 rFee,
423             uint256 tTransferAmount,
424             uint256 tFee,
425             uint256 tLiquidity
426         ) = _getValues(tAmount);
427         _tOwned[sender] = _tOwned[sender].sub(tAmount);
428         _rOwned[sender] = _rOwned[sender].sub(rAmount);
429         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
430         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
431         _takeLiquidity(tLiquidity);
432         _reflectFee(rFee, tFee);
433         emit Transfer(sender, recipient, tTransferAmount);
434     }
435 
436     function excludeFromFee(address account) public onlyOwner {
437         _isExcludedFromFee[account] = true;
438     }
439 
440     function includeInFee(address account) public onlyOwner {
441         _isExcludedFromFee[account] = false;
442     }
443 
444     function setSellFeePercent(
445         uint256 tFee,
446         uint256 lFee
447             ) external onlyOwner {
448         _sellTaxFee = tFee;
449         _sellLiquidityFee = lFee;
450         _taxFee = _sellTaxFee;
451         _liquidityFee = _sellLiquidityFee;
452         uint256 sFee = _taxFee.add(_liquidityFee);
453         require(sFee <= 9, "ERC20: Sell fees cannot be more than 9%");
454 
455     }
456 
457     function setBuyFeePercent(
458         uint256 tFee,
459         uint256 lFee
460             ) external onlyOwner {
461         _buyTaxFee = tFee;
462         _buyLiquidityFee = lFee;
463         _taxFee = _buyTaxFee;
464         _liquidityFee = _buyLiquidityFee;
465         uint256 bFee = _taxFee.add(_liquidityFee);
466         require(bFee <= 7, "ERC20: Buy fees cannot be more than 7%");
467 
468     }
469     
470     function setNumTokensSellToAddToLiquidity(uint256 amount)
471         external
472         onlyOwner
473     {
474         numTokensSellToAddToLiquidity = amount;
475     }
476 
477     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
478         swapAndLiquifyEnabled = _enabled;
479         emit SwapAndLiquifyEnabledUpdated(_enabled);
480     }
481 
482     //to recieve ETH from uniswapV2Router when swaping
483     receive() external payable {}
484 
485     function _reflectFee(uint256 rFee, uint256 tFee) private {
486         _rTotal = _rTotal.sub(rFee);
487         _tFeeTotal = _tFeeTotal.add(tFee);
488     }
489 
490     function _getValues(uint256 tAmount)
491         private
492         view
493         returns (
494             uint256,
495             uint256,
496             uint256,
497             uint256,
498             uint256,
499             uint256
500         )
501     {
502         (
503             uint256 tTransferAmount,
504             uint256 tFee,
505             uint256 tLiquidity
506         ) = _getTValues(tAmount);
507         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
508             tAmount,
509             tFee,
510             tLiquidity,
511             _getRate()
512         );
513         return (
514             rAmount,
515             rTransferAmount,
516             rFee,
517             tTransferAmount,
518             tFee,
519             tLiquidity
520         );
521     }
522 
523     function _getTValues(uint256 tAmount)
524         private
525         view
526         returns (
527             uint256,
528             uint256,
529             uint256
530         )
531     {
532         uint256 tFee = calculateTaxFee(tAmount);
533         uint256 tLiquidity = calculateLiquidityFee(tAmount);
534         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
535         return (tTransferAmount, tFee, tLiquidity);
536     }
537 
538     function _getRValues(
539         uint256 tAmount,
540         uint256 tFee,
541         uint256 tLiquidity,
542         uint256 currentRate
543     )
544         private
545         pure
546         returns (
547             uint256,
548             uint256,
549             uint256
550         )
551     {
552         uint256 rAmount = tAmount.mul(currentRate);
553         uint256 rFee = tFee.mul(currentRate);
554         uint256 rLiquidity = tLiquidity.mul(currentRate);
555         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
556         return (rAmount, rTransferAmount, rFee);
557     }
558 
559     function _getRate() private view returns (uint256) {
560         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
561         return rSupply.div(tSupply);
562     }
563 
564     function _getCurrentSupply() private view returns (uint256, uint256) {
565         uint256 rSupply = _rTotal;
566         uint256 tSupply = _tTotal;
567         for (uint256 i = 0; i < _excluded.length; i++) {
568             if (
569                 _rOwned[_excluded[i]] > rSupply ||
570                 _tOwned[_excluded[i]] > tSupply
571             ) return (_rTotal, _tTotal);
572             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
573             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
574         }
575         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
576         return (rSupply, tSupply);
577     }
578 
579     function _takeLiquidity(uint256 tLiquidity)
580         private
581     {
582         uint256 currentRate = _getRate();
583         uint256 rLiquidity = tLiquidity.mul(
584             currentRate
585         );
586         _rOwned[address(this)] = _rOwned[address(this)].add(
587             rLiquidity
588         );
589         if (_isExcluded[address(this)])
590             _tOwned[address(this)] = _tOwned[address(this)].add(
591                 tLiquidity
592             );
593     }
594 
595     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
596         return _amount.mul(_taxFee).div(10**2);
597     }
598 
599     function calculateLiquidityFee(uint256 _amount)
600         private
601         view
602         returns (uint256)
603     {
604         return _amount.mul((_liquidityFee)).div(10**2);
605     }
606 
607     function removeAllFee() private {
608         _previousTaxFee = _taxFee;
609         _previousLiquidityFee = _liquidityFee;
610 
611         _taxFee = 0;
612         _liquidityFee = 0;
613     }
614 
615     function restoreAllFee() private {
616         _taxFee = _previousTaxFee;
617         _liquidityFee = _previousLiquidityFee;
618     }
619 
620     function isExcludedFromFee(address account) public view returns (bool) {
621         return _isExcludedFromFee[account];
622     }
623 
624     function _approve(
625         address owner,
626         address spender,
627         uint256 amount
628     ) private {
629         require(owner != address(0), "ERC20: approve from the zero address");
630         require(spender != address(0), "ERC20: approve to the zero address");
631 
632         _allowances[owner][spender] = amount;
633         emit Approval(owner, spender, amount);
634     }
635 
636     function _transfer(
637         address from,
638         address to,
639         uint256 amount
640     ) private {
641         require(from != address(0), "ERC20: transfer from the zero address");
642         require(to != address(0), "ERC20: transfer to the zero address");
643         require(amount > 0, "Transfer amount must be greater than zero");
644 
645         uint256 contractTokenBalance = balanceOf(address(this));
646 
647         bool overMinTokenBalance = contractTokenBalance >=
648             numTokensSellToAddToLiquidity;
649         if (
650             overMinTokenBalance &&
651             !inSwapAndLiquify &&
652             from != uniswapV2Pair &&
653             swapAndLiquifyEnabled
654         ) {
655             contractTokenBalance = numTokensSellToAddToLiquidity;
656             swapAndLiquify(contractTokenBalance);
657         }
658 
659         bool takeFee = true;
660         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
661             takeFee = false;
662         } else {
663             if (from == uniswapV2Pair) {
664                 // Buy
665                 _taxFee = _buyTaxFee;
666                 _liquidityFee = _buyLiquidityFee;
667             } else if (to == uniswapV2Pair) {
668                 // Sell
669                 _taxFee = _sellTaxFee;
670                 _liquidityFee = _sellLiquidityFee;
671             } else {
672                 // Transfer
673                 _taxFee = 0;
674                 _liquidityFee = 0;
675             }
676         }
677         _tokenTransfer(from, to, amount, takeFee);
678     }
679 
680     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
681         uint256 half = contractTokenBalance.div(2);
682         uint256 otherHalf = contractTokenBalance.sub(half);
683         uint256 initialBalance = address(this).balance;
684         swapTokensForEth(half); 
685         uint256 newBalance = address(this).balance.sub(initialBalance);
686         addLiquidity(otherHalf, newBalance);
687         emit SwapAndLiquify(half, newBalance, otherHalf);
688     }
689 
690     function swapTokensForEth(uint256 tokenAmount) private {
691         address[] memory path = new address[](2);
692         path[0] = address(this);
693         path[1] = uniswapV2Router.WETH();
694         _approve(address(this), address(uniswapV2Router), tokenAmount);
695         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
696             tokenAmount,
697             0, // accept any amount of ETH
698             path,
699             address(this),
700             block.timestamp
701         );
702     }
703 
704     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
705         _approve(address(this), address(uniswapV2Router), tokenAmount);
706         uniswapV2Router.addLiquidityETH{value: ethAmount}(
707             address(this),
708             tokenAmount,
709             0, // slippage is unavoidable
710             0, // slippage is unavoidable
711             address(0xdead),
712             block.timestamp
713         );
714     }
715 
716     function _tokenTransfer(
717         address sender,
718         address recipient,
719         uint256 amount,
720         bool takeFee
721     ) private {
722         if (!takeFee) removeAllFee();
723 
724         if (_isExcluded[sender] && !_isExcluded[recipient]) {
725             _transferFromExcluded(sender, recipient, amount);
726         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
727             _transferToExcluded(sender, recipient, amount);
728         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
729             _transferStandard(sender, recipient, amount);
730         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
731             _transferBothExcluded(sender, recipient, amount);
732         } else {
733             _transferStandard(sender, recipient, amount);
734         }
735 
736         if (!takeFee) restoreAllFee();
737     }
738 
739     function _transferStandard(
740         address sender,
741         address recipient,
742         uint256 tAmount
743     ) private {
744         (
745             uint256 rAmount,
746             uint256 rTransferAmount,
747             uint256 rFee,
748             uint256 tTransferAmount,
749             uint256 tFee,
750             uint256 tLiquidity
751         ) = _getValues(tAmount);
752         _rOwned[sender] = _rOwned[sender].sub(rAmount);
753         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
754         _takeLiquidity(tLiquidity);
755         _reflectFee(rFee, tFee);
756         emit Transfer(sender, recipient, tTransferAmount);
757     }
758 
759     function _transferToExcluded(
760         address sender,
761         address recipient,
762         uint256 tAmount
763     ) private {
764         (
765             uint256 rAmount,
766             uint256 rTransferAmount,
767             uint256 rFee,
768             uint256 tTransferAmount,
769             uint256 tFee,
770             uint256 tLiquidity
771         ) = _getValues(tAmount);
772         _rOwned[sender] = _rOwned[sender].sub(rAmount);
773         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
774         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
775         _takeLiquidity(tLiquidity);
776         _reflectFee(rFee, tFee);
777         emit Transfer(sender, recipient, tTransferAmount);
778     }
779 
780     function _transferFromExcluded(
781         address sender,
782         address recipient,
783         uint256 tAmount
784     ) private {
785         (
786             uint256 rAmount,
787             uint256 rTransferAmount,
788             uint256 rFee,
789             uint256 tTransferAmount,
790             uint256 tFee,
791             uint256 tLiquidity
792         ) = _getValues(tAmount);
793         _tOwned[sender] = _tOwned[sender].sub(tAmount);
794         _rOwned[sender] = _rOwned[sender].sub(rAmount);
795         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
796         _takeLiquidity(tLiquidity);
797         _reflectFee(rFee, tFee);
798         emit Transfer(sender, recipient, tTransferAmount);
799     }
800 
801     function withdrawStuckETH() external onlyOwner{
802         require (address(this).balance > 0, "Can't withdraw negative or zero");
803         payable(owner()).transfer(address(this).balance);
804     }
805 
806     function removeStuckToken(address _address) external onlyOwner {
807         require(_address != address(this), "Can't withdraw tokens destined for liquidity");
808         require(IERC20(_address).balanceOf(address(this)) > 0, "Can't withdraw 0");
809 
810         IERC20(_address).transfer(owner(), IERC20(_address).balanceOf(address(this)));
811     }  
812 }